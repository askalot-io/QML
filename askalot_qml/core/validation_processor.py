"""
ValidationProcessor - Validation Mode Implementation for QML Static Validation

This processor handles static validation of questionnaires:
- Uses topological order + ItemClassifier for Z3 validation
- Determines item availability (ALWAYS/CONDITIONALLY/NEVER)
- Determines postcondition effects (TAUTOLOGICAL/CONSTRAINING/INFEASIBLE)
- Generates graph data with classification colors for visualization
- Supports isolated Z3 validation for safety

Uses the common QMLEngine pipeline then adds Z3-based item classification.
"""

import ast
import logging
import operator
import re
from typing import Any

from askalot_common.tracing import create_span
from z3 import And, Not, Solver, sat, unsat

from askalot_qml.core.controls import label_keys
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.models.qml_state import Condition, QMLState, QuestionnaireItem
from askalot_qml.predicate_ast import (
    name_reads,
    none_tested_outcomes,
    outcome_reads,
    outcome_ref_name,
)
from askalot_qml.z3.item_classifier import ItemClassifier
from askalot_qml.z3.static_builder import StaticBuilder

#: YAML spellings of literals that are NOT Python names, mapped to the fix
#: (#201). A QML `predicate:` is a YAML *string* holding a **Python** expression,
#: so `q_eligible.outcome == false` parses `false` as an identifier that resolves
#: to nothing, so the predicate raises at runtime — a precondition then skips
#: its item and a postcondition accepts the answer unchecked (#658) — and Z3 sees
#: a free symbol, so the branch proves nothing either. Either way the author's
#: branch never branches.
#:
#: These earn a targeted suggestion rather than the generic
#: "reference an item's outcome / add a codeBlock" advice, which is actively
#: unhelpful here: nobody meant to introduce a variable named `false`. A corpus
#: sweep found this shape fielded in two live campaigns, and the AI designer
#: reproduces the YAML spelling, so the generic message was being read past.
#: Same family as #186 (Switch on/off YAML-boolean coercion).
_YAML_LITERAL_SUGGESTIONS: dict[str, str] = {
    "true": (
        "QML predicates are Python expressions, not YAML — did you mean 'True'? "
        "Lowercase 'true' is an undefined name, so the condition cannot be "
        "evaluated and the branch does not branch."
    ),
    "false": (
        "QML predicates are Python expressions, not YAML — did you mean 'False'? "
        "Lowercase 'false' is an undefined name, so the condition cannot be "
        "evaluated and the branch does not branch."
    ),
    "null": (
        "QML predicates are Python expressions, not YAML — did you mean 'None'? "
        "'null' is an undefined name, so the condition cannot be evaluated and "
        "the branch does not branch."
    ),
}


#: A Comment title that reads as a request for an answer. Two arms:
#:
#: * a ``?`` ANYWHERE in the title — language-neutral, so it holds for any
#:   instrument. Deliberately not anchored to the end: the case this lint was
#:   written for is "What is this person's name? (Last name, First name, MI)",
#:   where the question mark is followed by a format hint. A rhetorical question
#:   inside an instruction ("Not sure what counts as income? See the guide.")
#:   will therefore also warn — accepted, because the warning is advisory and
#:   the alternative misses the real shape;
#: * an **inscription verb** in request position (start of a sentence, or after
#:   "please"). The distinction that matters is not imperative-vs-not: a Comment
#:   EXISTS to instruct, so "Please read the following carefully" is exactly
#:   right and "Please print your name" is exactly wrong. An instruction to read
#:   is what the kind is for; an instruction to write is what it cannot honour.
#:
#: The verb list is English, so a non-English instrument gets the ``?`` arm
#: only. That is a false negative, which for an advisory warning is the safe
#: direction — the alternative is matching English stems against another
#: language's prose.
_COMMENT_ASKS_QUESTION_MARK = re.compile(r"\?")
_COMMENT_ASKS_INSCRIPTION = re.compile(
    r"(?:^|[.;:]\s+|\bplease\s+)(print|enter|write|specify|list|fill\s+in)\b",
    re.IGNORECASE,
)


#: Comparison operators that raise when an operand is None. Equality and
#: identity are deliberately absent: ``None == 1`` and ``None != 1`` evaluate
#: cleanly, which is why gating on an unasked item with ``!=`` is a sanctioned
#: idiom and ordering against one is a defect (#659).
_NONE_UNSAFE_COMPARE_OPS = (ast.Lt, ast.LtE, ast.Gt, ast.GtE)


def _definitely_assigned(statements: list[ast.stmt]) -> set[str]:
    """Names every path through *statements* assigns (#1024).

    Classic definite assignment over the shapes a codeBlock uses: an
    assignment binds its targets, an ``if`` binds what BOTH branches bind, a
    loop binds nothing (its body may not run), and ``with`` / ``try`` bind what
    their body binds. Anything else binds nothing.
    """
    bound: set[str] = set()
    for st in statements:
        if isinstance(st, (ast.Assign, ast.AugAssign)) or (
            isinstance(st, ast.AnnAssign) and st.value is not None
        ):
            targets = st.targets if isinstance(st, ast.Assign) else [st.target]
            for target in targets:
                bound |= {
                    n.id
                    for n in ast.walk(target)
                    if isinstance(n, ast.Name) and isinstance(n.ctx, ast.Store)
                }
        elif isinstance(st, ast.If):
            bound |= _definitely_assigned(st.body) & _definitely_assigned(st.orelse)
        elif isinstance(st, (ast.With, ast.Try)):
            bound |= _definitely_assigned(st.body)
    return bound


def _assignment_guard(tree: ast.Module, name: str) -> ast.expr | None:
    """The condition under which a codeBlock assigns *name*, or None for
    "assumed always".

    Modelled only where it is exact and cheap: every top-level statement that
    binds the name is an ``if`` that binds it on one branch and not at all on
    the other — the one-branch shape #1024 names. The guard is the disjunction
    of those branch conditions, so ``if a: r = 1`` followed by ``if not a:
    r = 0`` reads as always assigning. A test is used only when it reads
    nothing but item outcomes, because a variable in it would compile against
    a static SSA version the runtime state may not hold. Any other binding site
    (a loop, a nested or partial branch, a variable-reading test) makes the
    whole block count as always assigning: the lint then says less, never
    something false.
    """
    if name in _definitely_assigned(tree.body):
        return None
    guards: list[ast.expr] = []
    for st in tree.body:
        if name not in StaticBuilder._collect_leaking_bound_names(
            ast.Module(body=[st], type_ignores=[])
        ):
            continue
        if not isinstance(st, ast.If):
            return None
        in_body = name in _definitely_assigned(st.body)
        in_else = name in _definitely_assigned(st.orelse)
        other = st.orelse if in_body else st.body
        if in_body == in_else or name in StaticBuilder._collect_leaking_bound_names(
            ast.Module(body=other, type_ignores=[])
        ):
            return None
        if name_reads(st.test) - outcome_reads(st.test):
            return None
        guards.append(st.test if in_body else ast.UnaryOp(op=ast.Not(), operand=st.test))
    if not guards:
        return None
    return guards[0] if len(guards) == 1 else ast.BoolOp(op=ast.Or(), values=guards)


def _free_reads(tree: ast.AST) -> set[str]:
    """Bare names *tree* reads that it does not bind itself (comprehension,
    lambda and walrus locals excluded, scope-flattened as the undefined-name
    lint does)."""
    return name_reads(tree) - StaticBuilder._collect_bound_names(tree)


def _none_unsafe_item_references(predicate: str) -> set[str]:
    """Item ids whose ``.outcome`` this predicate uses where None would raise.

    Ordering comparisons and binary arithmetic only. A chained comparison is
    walked operator by operator, so ``a == b < c`` reports ``b`` and ``c`` and
    not ``a`` — the equality half is safe on its own.

    An unparseable predicate yields nothing: the syntax error is another lint's
    finding, and guessing at a broken AST would produce noise on top of it.
    """
    try:
        tree = ast.parse(predicate, mode="eval")
    except SyntaxError:
        return set()

    found: set[str] = set()
    for node in ast.walk(tree):
        operands: list[ast.expr] = []
        if isinstance(node, ast.Compare):
            chain = [node.left, *node.comparators]
            for index, op in enumerate(node.ops):
                if isinstance(op, _NONE_UNSAFE_COMPARE_OPS):
                    operands.extend(chain[index : index + 2])
        elif isinstance(node, ast.BinOp):
            operands = [node.left, node.right]
        for operand in operands:
            owner = outcome_ref_name(operand)
            if owner:
                found.add(owner)
    # An explicit None test anywhere in the predicate means the author already
    # knows the item may not have been asked — 'Y.outcome is None or …' (the
    # guard this lint suggests) and 'Y.outcome is not None and …' both land
    # here. Recognising it is what stops the lint firing on its own remedy; the
    # runtime honours the same guard (predicate_ast, #1023).
    return found - none_tested_outcomes(tree)


#: A Checkbox label that denies every other option: "None of the above", "No
#: health insurance", "Neither". Anchored at the start so a label merely
#: CONTAINING "no" ("Know someone", "Not sure") does not match; ``\b`` keeps
#: "Not"/"Nothing but…" from matching the ``no`` arm. English only — a
#: non-English instrument is a false negative, the safe direction for an
#: advisory warning.
_CHECKBOX_NONE_LABEL = re.compile(r"^\s*(?:no|none|nothing|neither)\b", re.IGNORECASE)

_CMP_OPS: dict[type[ast.cmpop], Any] = {
    ast.Eq: operator.eq,
    ast.NotEq: operator.ne,
    ast.Lt: operator.lt,
    ast.LtE: operator.le,
    ast.Gt: operator.gt,
    ast.GtE: operator.ge,
    ast.In: lambda a, b: a in b,
    ast.NotIn: lambda a, b: a not in b,
}

#: ``//`` and ``%`` are how a QML author tests a Checkbox bit in a form Z3 can
#: lower (``(q.outcome // 256) % 2 == 0``); ``&`` / ``|`` are the runtime-only
#: spelling of the same test.
_BIN_OPS: dict[type[ast.operator], Any] = {
    ast.BitAnd: operator.and_,
    ast.BitOr: operator.or_,
    ast.FloorDiv: operator.floordiv,
    ast.Mod: operator.mod,
}


class _NotLocal(Exception):
    """The predicate reads something other than its own item's outcome."""


#: Node types a local predicate may contain, besides the operators in
#: ``_CMP_OPS`` / ``_BIN_OPS``. Checked over the WHOLE tree before evaluating:
#: a foreign reference in a branch short-circuit never reaches
#: (``q.outcome == 1 or (False and other.outcome == 1)``) still makes the
#: predicate relational.
_LOCAL_NODE_TYPES = (
    ast.Expression,
    ast.Constant,
    ast.Attribute,
    ast.Name,
    ast.Load,
    ast.Tuple,
    ast.List,
    ast.Set,
    ast.BoolOp,
    ast.And,
    ast.Or,
    ast.UnaryOp,
    ast.Not,
    ast.USub,
    ast.BinOp,
    ast.Compare,
    *_CMP_OPS,
    *_BIN_OPS,
)


def _is_local(tree: ast.AST, item_id: str) -> bool:
    """True iff every name in ``tree`` is ``<item_id>.outcome`` and every node
    is one the interpreter evaluates."""
    for node in ast.walk(tree):
        if not isinstance(node, _LOCAL_NODE_TYPES):
            return False
        if isinstance(node, ast.Attribute) and outcome_ref_name(node) != item_id:
            return False
        if isinstance(node, ast.Name) and node.id != item_id:
            return False
    return True


def _eval_own_outcome(node: ast.AST, item_id: str, value: int) -> Any:
    """Evaluate a predicate that reads nothing but ``<item_id>.outcome``.

    A deliberately tiny interpreter rather than ``eval``: literals, the item's
    own outcome, comparisons, ``and``/``or``/``not``, unary minus, the
    ``_BIN_OPS`` bit arithmetic and literal collections for ``in``. Anything
    else — another item, a variable, a call — raises ``_NotLocal``, because the answer set of such a
    predicate cannot be read off the item's own domain.
    """
    if isinstance(node, ast.Constant) and isinstance(node.value, (int, str)):
        return node.value
    if outcome_ref_name(node) == item_id:
        return value
    if isinstance(node, (ast.Tuple, ast.List, ast.Set)):
        elements = [_eval_own_outcome(e, item_id, value) for e in node.elts]
        # Keep the collection's own type: (1, 2) != [1, 2] in Python too.
        return {ast.Tuple: tuple, ast.List: list, ast.Set: set}[type(node)](elements)
    if isinstance(node, ast.BoolOp):
        # Python's and/or return an OPERAND, not a bool, and short-circuit:
        # ``(q.outcome == 1 or 2) == 2`` depends on which operand came back.
        result: Any = None
        for operand in node.values:
            result = _eval_own_outcome(operand, item_id, value)
            if bool(result) != isinstance(node.op, ast.And):
                return result
        return result
    if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.Not, ast.USub)):
        operand = _eval_own_outcome(node.operand, item_id, value)
        return (not operand) if isinstance(node.op, ast.Not) else -operand
    if isinstance(node, ast.BinOp) and type(node.op) in _BIN_OPS:
        left = _eval_own_outcome(node.left, item_id, value)
        right = _eval_own_outcome(node.right, item_id, value)
        return _BIN_OPS[type(node.op)](left, right)
    if isinstance(node, ast.Compare) and all(type(op) in _CMP_OPS for op in node.ops):
        left = _eval_own_outcome(node.left, item_id, value)
        for op, comparator in zip(node.ops, node.comparators, strict=True):
            right = _eval_own_outcome(comparator, item_id, value)
            if not _CMP_OPS[type(op)](left, right):
                return False
            left = right
        return True
    raise _NotLocal


def _admitted_outcomes(predicate: str, item_id: str, values: list[int]) -> set[int] | None:
    """The subset of ``values`` for which a LOCAL predicate holds.

    ``None`` when the predicate is not local (reads another item, a variable,
    a call) or does not evaluate: the caller cannot reason about it, and an
    advisory lint must stay silent rather than guess. Any evaluation error is
    swallowed for the same reason: ``to_issues`` feeds the publish gate, which
    turns an exception into a blocking ``validation_error`` — an advisory lint
    must never be the thing that refuses a publish.
    """
    try:
        tree = ast.parse(predicate, mode="eval")
    except SyntaxError:
        return None
    if not _is_local(tree, item_id):
        return None
    try:
        return {v for v in values if _eval_own_outcome(tree.body, item_id, v)}
    except Exception:
        return None


def _choice_domain(input_spec: dict[str, Any]) -> list[int]:
    """A single-choice control's outcome values; empty for any other control.

    A Radio or Dropdown answers one of its integer label keys, as the Z3 domain
    reads them. A Switch does too when it declares integer keys, and otherwise
    answers 1 (on) or 0 (off) — the same fallback ``external_items`` uses.
    """
    control = input_spec.get("control")
    if control not in ("Radio", "Dropdown", "Switch"):
        return []
    keys = label_keys(input_spec)
    if not keys and control == "Switch":
        return [0, 1]
    return sorted(keys)


class ValidationProcessor:
    """
    Validation mode processor for static questionnaire validation.

    Provides:
    - Z3-based item classification (availability and postcondition effects)
    - Detailed validation diagrams with semantic coloring
    - Comprehensive static validation reports
    """

    def __init__(self, questionnaire_state: QMLState):
        """
        Initialize validation processor with questionnaire state.

        Args:
            questionnaire_state: The questionnaire to validate
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state

        # Use unified engine for common pipeline
        self.engine = QMLEngine(questionnaire_state)

        # Item classifications (lazy-loaded)
        self._classifications: dict[str, Any] | None = None

        # Postcondition analysis records (lazy-loaded). ``analyze_postconditions``
        # re-parses every postcondition AST; three consumers (_hygiene_issues,
        # generate_validation_report, get_statistics) need the same records, so
        # memoize once. A ValidationProcessor is per-validation over one fixed
        # ``engine.static_builder``, and the analysis mutates no state, so a plain
        # lazy memo is correct (mirrors ``self._classifications``).
        self._postcondition_records: list[dict[str, Any]] | None = None

        self.logger.info(
            f"ValidationProcessor initialized for {len(self.engine.get_items())} items"
        )

    def get_item_classifications(self) -> dict[str, Any]:
        """
        Get Z3-based item classifications (lazy-loaded).

        Returns:
            Dict mapping item_id to classification results
        """
        if self._classifications is not None:
            return self._classifications

        try:
            self.logger.info("Running Z3 validation...")
            item_count = len(self.engine.get_items())
            with create_span("qml.z3_validation", {"item_count": item_count}):
                classifier = ItemClassifier(self.engine.static_builder)
                self._classifications = classifier.classify_all_items()
            self.logger.info("Z3 validation completed successfully")
        except Exception as e:
            self.logger.error(f"Z3 validation failed: {e}", exc_info=True)
            self._classifications = {}

        return self._classifications

    def _get_postcondition_records(self) -> list[dict[str, Any]]:
        """Return the builder's postcondition analysis records (lazy-loaded).

        See :meth:`StaticBuilder.analyze_postconditions` for the record shape.
        Memoized because three consumers read it per validation and each call
        re-parses every postcondition AST.
        """
        if self._postcondition_records is None:
            self._postcondition_records = self.engine.static_builder.analyze_postconditions()
        return self._postcondition_records

    def to_issues(self, *, deep: bool = False) -> list[dict[str, Any]]:
        """
        Translate Z3 item classifications into a graded list of validation issues.

        Maps each per-item classification (and block-level coverage gap) produced
        by :meth:`get_item_classifications` into a structured issue carrying a
        ``severity`` (``error`` / ``warning``), a stable machine ``type``, a
        human-readable ``message``, and a remediation ``suggestion``. This is the
        severity-and-message policy: which classifications are surfaced, whether
        each is an error or a warning, and the exact author-facing wording. It
        lives here, beside the classifier that produces its input, so every
        consumer (the MCP ``validate_qml_file`` tool, future UI surfaces) renders
        identical issues without re-implementing the mapping.

        **Validation hierarchy coverage.** Beyond the per-item classifications
        (Level 1) and the structural lints, this channel also surfaces the higher
        hierarchy levels via :meth:`_hierarchy_issues`, so the publish gate's
        "formally verified before fielding" promise is not limited to per-item
        properties: Level 2 global satisfiability (``global_unsat`` — a
        questionnaire that traps every respondent) and Level 3 dependency cycles
        (``dependency_cycle`` — ambiguous evaluation order) are ERRORS run
        unconditionally (Level 2 is one solver call; Level 3 is computed at engine
        init). Level 4 accumulated dead code (``accumulated_dead_code``, WARNING)
        is O(items²) solver work, so it runs only when ``deep`` is set — the
        publish gate passes ``deep=True``; the interactive ``validate_qml_file``
        tool keeps the default so the edit-validate loop stays fast.

        A single pass covers both per-item statuses (NEVER, INFEASIBLE, ...) and
        coverage gaps carried alongside them. Block-level gaps keyed by block_id
        rather than item_id would otherwise be invisible and produce
        ``is_valid=True`` for a block with a structural defect, leading the Designer
        agent to save an unvalidated questionnaire. The capped-Group independence
        check records a ``group_dependency`` gap per offending intra-Group
        dependency edge; the classifier surfaces it ONLY under a synthetic
        block-keyed entry (disjoint from item_order), so each edge yields exactly
        one issue. The U1 undefined-name lint records an ``undefined_name`` gap
        (severity ``error``) per phantom identifier — an identifier in a
        precondition, postcondition, or codeBlock resolving to no item id, produced
        variable, or safe builtin — keyed under the owning item (or block).

        Returns:
            List of issue dicts, each with keys ``item_id``, ``severity``,
            ``type``, ``message``, and ``suggestion``.
        """
        classifications = self.get_item_classifications()

        # Items whose postcondition merely restates the control's own min/max
        # (duplicate_input_bound, emitted as a WARNING by _hygiene_issues). Such a
        # postcondition is TAUTOLOGICAL by construction — the domain base already
        # implies it — so the classifier ALSO flags it tautological: one authoring
        # defect, two overlapping findings (#167). The more specific
        # duplicate_input_bound wins; the ``tautological_postcondition`` branch
        # below suppresses these to avoid the double-report.
        duplicate_bound_items = {
            r["item_id"] for r in self._get_postcondition_records() if r["duplicate_input_bound"]
        }

        issues: list[dict[str, Any]] = []
        for item_id, classification in classifications.items():
            pre_status = classification.get("precondition", {}).get("status", "UNKNOWN")
            post_invariant = classification.get("postcondition", {}).get("invariant", "UNKNOWN")
            post_vacuous = classification.get("postcondition", {}).get("vacuous", False)
            post_global = classification.get("postcondition", {}).get("global", {})

            # Unreachable items (NEVER reachable)
            if pre_status == "NEVER":
                issues.append(
                    {
                        "item_id": item_id,
                        "severity": "error",
                        "type": "unreachable_item",
                        "message": f"Item '{item_id}' is unreachable (precondition is never satisfiable).",
                        "suggestion": (
                            f"Check the precondition of '{item_id}'. It may reference "
                            f"variables that can never have the required values, or it may "
                            f"depend on items that set contradictory conditions."
                        ),
                    }
                )

            # Infeasible postconditions
            if post_invariant == "INFEASIBLE":
                issues.append(
                    {
                        "item_id": item_id,
                        "severity": "error",
                        "type": "infeasible_postcondition",
                        "message": f"Item '{item_id}' has an infeasible postcondition (contradicts global constraints).",
                        "suggestion": (
                            f"The postcondition of '{item_id}' cannot be satisfied given "
                            f"the control's domain constraints (min/max, allowed values). "
                            f"Review the validation rule or control configuration."
                        ),
                    }
                )

            # Globally false postcondition
            if post_global.get("q_globally_false"):
                issues.append(
                    {
                        "item_id": item_id,
                        "severity": "error",
                        "type": "globally_false_postcondition",
                        "message": f"Item '{item_id}' has a postcondition that is always false.",
                        "suggestion": (
                            f"The postcondition of '{item_id}' can never be true for any "
                            f"valid response. Remove it or fix the validation logic."
                        ),
                    }
                )

            # Tautological postconditions (warning, not error). Suppressed for a
            # vacuous (NEVER-reachable) item: UNSAT(B ∧ P ∧ ¬Q) is *vacuously*
            # true whenever P is unsatisfiable, so the classifier's TAUTOLOGICAL
            # label there is an artifact of unreachability, not a redundant rule.
            # Reporting it would mislabel the finding and send the author to
            # "remove the redundant postcondition" instead of the real problem —
            # the item is unreachable, already surfaced as ``unreachable_item``
            # above. Checking vacuity first is the VACUOUS-before-TAUTOLOGICAL
            # order fix (#169). The separate ``vacuous_postcondition`` warning was
            # removed as pure noise: it fired iff ``pre_status == NEVER``, i.e.
            # exactly when ``unreachable_item`` already fires, so it doubled every
            # dead-item finding without adding an action.
            if (
                post_invariant == "TAUTOLOGICAL"
                and not post_vacuous
                and item_id not in duplicate_bound_items
            ):
                issues.append(
                    {
                        "item_id": item_id,
                        "severity": "warning",
                        "type": "tautological_postcondition",
                        "message": f"Item '{item_id}' has a tautological postcondition (always true, redundant).",
                        "suggestion": (
                            f"The postcondition of '{item_id}' is always satisfied. "
                            f"It can be safely removed unless it serves as documentation."
                        ),
                    }
                )

            # Structured coverage gaps recorded by the static builder. Both the
            # capped-Group independence violation (U8, block-keyed) and the U1
            # undefined-name lint (item- or block-keyed) travel through the same
            # ``coverage_gaps`` list; each is surfaced exactly once (the block-keyed
            # ones under a synthetic block entry disjoint from item_order), so we
            # append directly with no dedup.
            for gap in classification.get("coverage_gaps", []) or []:
                gap_kind = gap.get("kind")

                # Capped-Group independence violation (U8). A count-capped Group
                # whose inner item depends — directly or transitively /
                # variable-mediated — on a sibling inner item of the same Group is
                # rejected: the draw can leave the sibling undrawn, so the
                # dependant would evaluate against a None outcome at runtime.
                if gap_kind == "group_dependency":
                    block_id = gap["block_id"]
                    dependant = gap["item_id"]
                    depends_on = gap["depends_on"]
                    issues.append(
                        {
                            "item_id": block_id,
                            "severity": "error",
                            "type": "group_dependency",
                            "message": (
                                f"Capped Group '{block_id}': inner item '{dependant}' depends "
                                f"on sibling inner item '{depends_on}'. Inner items of a "
                                f"count-capped Group must be independent — the draw can leave "
                                f"'{depends_on}' undrawn, so '{dependant}' may evaluate against "
                                f"a None outcome."
                            ),
                            "suggestion": (
                                f"Move '{dependant}' or '{depends_on}' to a separate block, or "
                                f"remove the 'count' cap so the Group asks every inner item."
                            ),
                        }
                    )

                # Undefined-name lint (U1, ERROR). An identifier in a precondition,
                # postcondition, or codeBlock that resolves to no item id,
                # codeInit/codeBlock variable, or safe builtin. The predicate eval
                # namespace is closed, so at runtime the predicate raises: a
                # precondition skips its item, a postcondition accepts the answer
                # unchecked (#658), and Z3 sees a free symbol — either way the gate
                # enforces nothing it declared. ``item_id`` here is the classification key: the
                # owning item, or the block for a block-level condition.
                elif gap_kind == "undefined_name":
                    identifier = gap["identifier"]
                    condition_kind = gap["condition_kind"]
                    suggested = gap.get("suggested_outcome")
                    issues.append(
                        {
                            "item_id": item_id,
                            "severity": "error",
                            "type": "undefined_name",
                            "message": (
                                f"Item '{item_id}' references undefined name "
                                f"'{identifier}' in its {condition_kind}. It resolves to no "
                                f"item id, produced variable, or safe builtin, so the "
                                f"predicate cannot be evaluated at runtime and the "
                                f"logic enforces nothing."
                            ),
                            "suggestion": (
                                f"Reference '{suggested}' instead."
                                if suggested
                                else _YAML_LITERAL_SUGGESTIONS.get(identifier)
                                or (
                                    # Ordered so the FIRST option is the one the other
                                    # lints endorse — the old wording led with "produce it
                                    # in codeInit/codeBlock", which is exactly the
                                    # frozen-variable (codeInit) and pass-through-alias
                                    # (codeBlock) anti-patterns those lints then flag (#167).
                                    f"Reference an existing item's outcome directly "
                                    f"(e.g. 'q_{identifier}.outcome') if one measures "
                                    f"'{identifier}'; if the value comes from outside the "
                                    f"interview (prefill, sample file, roster, proxy flag), "
                                    f"add an explicit admin/preamble question and gate on ITS "
                                    f"outcome; only introduce a variable when '{identifier}' "
                                    f"is genuinely derived (accumulate / classify / "
                                    f"consolidate) and add a codeBlock that actually produces "
                                    f"it before it is read."
                                )
                            ),
                        }
                    )

                # Textarea-in-predicate lint (WARNING). A predicate/codeBlock
                # references a Textarea item's ``.outcome`` — a free-text answer
                # with no verified Z3 model (it lowers to a sentinel), so gating
                # logic on it is statically wrong and outside the verified
                # envelope. WARNING (not error) so stored files that already do
                # this still save. ``item_id`` is the referencing location's
                # classification key; ``gap["item"]`` is the Textarea item.
                elif gap_kind == "textarea_in_predicate":
                    textarea_item = gap["item"]
                    condition_kind = gap["condition_kind"]
                    issues.append(
                        {
                            "item_id": item_id,
                            "severity": "warning",
                            "type": "textarea_in_predicate",
                            "message": (
                                f"Item '{item_id}' references Textarea outcome "
                                f"'{textarea_item}.outcome' in its {condition_kind}. A "
                                f"free-text outcome has no verified Z3 model — it lowers "
                                f"to a sentinel, so the logic is outside the verified "
                                f"envelope and may misclassify reachability."
                            ),
                            "suggestion": (
                                "free-text outcomes are outside the verified envelope — "
                                "gate logic on a coded control (Radio/Switch/Dropdown) "
                                "instead"
                            ),
                        }
                    )

                # Skipped-condition coverage gap (#165, WARNING). A precondition
                # or postcondition the static translator could not fully lower to
                # Z3 — an unsupported Call / ListComp / GeneratorExp, or a
                # Subscript over an outcome the model does not represent per-cell
                # (a QuestionGroup vector ``qg.outcome[i]`` — QuestionGroups carry
                # a single scalar var, no per-question cells, so the read has no
                # Z3 target). The gap was RECORDED in ``coverage_gaps`` but, before
                # #165, no ``to_issues`` branch surfaced it, so the author saw a
                # clean file while the item's classification silently fell back to
                # a trivial default (a skipped precondition → ALWAYS, a skipped
                # postcondition → TAUTOLOGICAL) and only the runtime enforced the
                # rule. WARNING, not error: the runtime still applies the predicate
                # and some forms are legitimately runtime-only — but the author
                # must know the static guarantee does not cover it.
                elif gap_kind in ("precondition", "postcondition"):
                    nodes = ", ".join(gap.get("unsupported_nodes", []) or []) or "an unsupported construct"
                    issues.append(
                        {
                            "item_id": item_id,
                            "severity": "warning",
                            "type": "skipped_condition",
                            "message": (
                                f"Item '{item_id}' has a {gap_kind} the static validator "
                                f"could not lower to Z3 ({nodes}), so it was skipped: the "
                                f"item's {gap_kind} classification fell back to a trivial "
                                f"default and only the runtime enforces the rule — it sits "
                                f"outside the verified envelope, so reachability/invariant "
                                f"results for '{item_id}' may be wrong."
                            ),
                            "suggestion": (
                                "Rewrite the condition into the statically-verified subset "
                                "(item outcomes, bound variables, and the supported folds "
                                "over matrix cells), or accept that this rule is "
                                "runtime-only and unverified. A QuestionGroup vector "
                                "outcome 'qg.outcome[i]' is not yet modeled per-question — "
                                "gate on a dedicated item's outcome instead."
                            ),
                        }
                    )

        # U3 hygiene lints (WARNING). Computed here — beside the severity-and-
        # message policy for every other issue type — from the builder's
        # read/write census and its postcondition analysis, NOT via the
        # ``coverage_gaps`` channel: those two are variable- and
        # postcondition-level aggregates, while coverage_gaps carries per-item
        # AST findings surfaced through ItemClassifier. All three are warnings,
        # so they never flip Portor's error-only ``is_valid`` gate.
        issues.extend(self._hygiene_issues())

        # Authoring lints (WARNING). Sourced from the AUTHORED tree — item
        # kinds, titles and block metadata — rather than from the Z3 census
        # the hygiene lints read, which is why they are a sibling method
        # rather than more branches inside ``_hygiene_issues``.
        issues.extend(self._authoring_issues())

        # Reference-safety lint (WARNING). A pairwise reachability question —
        # "is the item this predicate reads guaranteed answered when the
        # predicate runs" — so it belongs neither to the per-item loop nor to
        # the whole-questionnaire hierarchy levels.
        issues.extend(self._condition_reference_issues(classifications))

        # Uninitialized-read lint (WARNING, #1024). The same reachability
        # question asked of a variable: can the reader run while no assigner
        # before it did.
        issues.extend(self._uninitialized_read_issues())

        # Validation hierarchy Levels 2–4 (global satisfiability, dependency
        # cycles, accumulated dead code). Kept out of the per-item loop because
        # they are whole-questionnaire properties, not per-item classifications.
        issues.extend(self._hierarchy_issues(deep=deep))

        # Sandbox-admissibility lint (ERROR). Pure AST, no solver, so it stays
        # admissible on the interactive path beside the structural lints.
        issues.extend(self._unsafe_code_issues())

        return issues

    def _unsafe_code_issues(self) -> list[dict[str, Any]]:
        """Refuse, at validation time, code the sandbox will refuse at runtime.

        Wrapped so a fault degrades THIS lint only. Every other lint in
        ``to_issues`` carries the same boundary (``_condition_reference_issues``,
        ``_hierarchy_issues``, the classifier's own guard), and it is not
        optional here: ``to_issues`` is now called by the validation endpoint,
        whose tail turns any exception into a 500 — so one fault in this lint
        would take the other nineteen lints' findings AND the endpoint with it.

        ``PythonRunner.validate_code`` / ``validate_expr`` were reachable only
        from ``run_code`` / ``eval_expr``, so nothing on the static path ever
        asked whether a body was admissible (#729). A ``codeBlock`` containing
        ``import os`` passed validation, passed the publish gate, and was
        fielded — and then every respondent who reached that item tripped the
        same refusal, ``FlowProcessor`` recorded a critical warning and returned
        the context unchanged, so no variable the block was supposed to set
        existed downstream and anything gated on one took the wrong branch
        silently. A construct the sandbox categorically refuses is a property of
        the FILE, knowable before anyone is interviewed.

        The runner's own gate is called rather than its forbidden sets being
        re-read here. The allowlist is deliberately narrow and versioned (#697),
        and a second copy of the rule would drift the first time either moved —
        which is the defect this module has already paid for twice, in the
        role-scope rule and the diagram's cycle red.

        Predicates are checked as well as bodies. They also run through the
        sandbox (``eval_expr``), and a lint that walked ``codeBlock`` alone
        would leave the more common authoring surface unguarded.

        Every message is the runner's verbatim text: the author needs to see
        the sandbox's own reason, and paraphrasing it here would give the
        static path and the runtime path two vocabularies for one refusal.

        **A call refusal is worded neutrally, because the runner cannot tell a
        typo from an escape.** ``_check_ast_safety``'s Call-to-Name branch asks
        only whether the name is in the safe set, so it returns the identical
        string for ``eval``, ``__import__`` and a misspelling. Dressing that as
        a security refusal accuses an author who mistyped; dressing it as a typo
        excuses a real escape. So "Call to disallowed function: X" is reported
        as *X is not available here*, which is the only thing that is true of
        both, and the consequence — the unit is skipped at fielding — is stated
        either way. Every other refusal (a forbidden NODE type, or an attribute
        reached on an allowlisted module the sandbox does not declare) IS
        unambiguous, and keeps the sandbox's own wording.

        **Nothing is suppressed.** An earlier revision dropped a call refusal
        when ``undefined_name`` already named X on the same owner, on #167's
        "more specific finding survives" rule. Two things were wrong with it.
        ``codeInit`` gets no ``undefined_name`` at all — the census scans it with
        ``item_id=None`` because no item owns it — so the suppression could never
        fire there and every ``codeInit`` typo kept the security wording. And
        because ``_check_ast_safety`` returns on the FIRST refusal it meets,
        dropping a call refusal drops the unit's only finding: a predicate
        reading ``math.__dict__ == 1 and undefined_fn(1)`` reports the call,
        and suppressing it hid the attribute escape behind it. The two lints do
        not actually overlap — ``undefined_name`` says a name does not resolve,
        this one says the unit will not RUN — so both are true and both are kept.

        One property worth knowing: ``_check_ast_safety`` returns on the FIRST
        refusal it meets, so a body with three forbidden constructs yields one
        finding, not three. That is the runner's contract, not a choice made
        here, and re-walking the tree to enumerate the rest would be the second
        copy of the rule this method exists to avoid.
        """
        issues: list[dict[str, Any]] = []
        try:
            return self._sandbox_admissibility_issues(issues)
        except Exception as e:
            self.logger.warning(f"Sandbox-admissibility lint failed: {e}", exc_info=True)
            return issues

    def _sandbox_admissibility_issues(self, issues: list[dict[str, Any]]) -> list[dict[str, Any]]:
        """The body of :meth:`_unsafe_code_issues`, split so the caller owns the
        degrade-on-failure boundary.

        ``issues`` is passed in rather than created here so a partial result
        survives the caller's except branch — refusals already proven stay.
        """
        from askalot_qml.core.python_runner import PythonRunner

        runner = PythonRunner()

        # What a refused unit costs at fielding — the same for every refusal
        # shape, so it is stated once and appended to whichever lead applies.
        consequence = (
            "A unit the sandbox refuses does not fail loudly at fielding: it is "
            "skipped for every respondent, so any variable it assigns is missing "
            "and any item gated on that variable takes the wrong branch."
        )

        def _refuse(owner_id: str, where: str, refusal: str) -> None:
            syntax_error = re.match(r"Syntax error: (.+)$", refusal)
            unknown_call = re.match(r"Call to disallowed function: (.+)$", refusal)
            if syntax_error:
                # Not a refusal at all: the sandbox never got as far as judging
                # what the code DOES. Saying it "will be refused by the execution
                # sandbox" and advising the author to use only declared modules
                # sends them looking for a permissions problem in code that does
                # not parse.
                message = (
                    f"'{owner_id}': the {where} is not valid Python — "
                    f"{syntax_error.group(1)}"
                )
                suggestion = (
                    "Fix the syntax. An unparseable unit is skipped for every "
                    "respondent exactly as a refused one is, so any variable it "
                    "assigns is missing and any item gated on that variable "
                    "takes the wrong branch."
                )
            elif unknown_call:
                # Ambiguous by construction: the runner returns this same string
                # for a misspelling and for ``__import__``. Say only what holds
                # of both.
                name = unknown_call.group(1)
                message = (
                    f"'{owner_id}': the {where} calls '{name}', which the "
                    f"execution sandbox does not provide."
                )
                suggestion = (
                    f"Check the spelling of '{name}'. If it is intentional, it is "
                    f"still unavailable — the sandbox provides a declared set of "
                    f"modules and builtins and nothing else. " + consequence
                )
            else:
                message = (
                    f"'{owner_id}': the {where} will be refused by the "
                    f"execution sandbox — {refusal}"
                )
                suggestion = (
                    "Rewrite it using only the modules and builtins the sandbox "
                    "declares. " + consequence
                )
            issues.append(
                {
                    "item_id": owner_id,
                    "severity": "error",
                    "type": "unsafe_code",
                    "message": message,
                    "suggestion": suggestion,
                }
            )

        code_init = self.state.get_code_init()
        if code_init:
            refusal = runner.validate_code(code_init)
            if refusal:
                _refuse("codeInit", "questionnaire codeInit", refusal)

        for block in self.state.get_blocks():
            block_id = block.get("id")
            if not block_id:
                continue
            # A Roster's iterateOver is author-written Python evaluated by the
            # same sandbox at fielding (flow_processor._prime_roster_pass). A
            # refusal there is caught, logged and recorded only as
            # ``informational``, and the whole roster pass is skipped — so
            # without this walk the escape is invisible to the publish gate.
            iterate_over = block.get("iterateOver")
            if iterate_over:
                refusal = runner.validate_expr(iterate_over)
                if refusal:
                    _refuse(block_id, f"block iterateOver '{iterate_over}'", refusal)

            for kind in ("precondition", "postcondition"):
                for condition in block.get(kind) or []:
                    predicate = (condition or {}).get("predicate")
                    if not predicate:
                        continue
                    refusal = runner.validate_expr(predicate)
                    if refusal:
                        _refuse(block_id, f"block {kind} '{predicate}'", refusal)

        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue
            body = item.get("codeBlock")
            if body:
                refusal = runner.validate_code(body)
                if refusal:
                    _refuse(item_id, "codeBlock", refusal)
            for kind in ("precondition", "postcondition"):
                for condition in item.get(kind) or []:
                    predicate = (condition or {}).get("predicate")
                    if not predicate:
                        continue
                    refusal = runner.validate_expr(predicate)
                    if refusal:
                        _refuse(item_id, f"{kind} '{predicate}'", refusal)

        return issues

    def _condition_reference_issues(
        self, classifications: dict[str, Any]
    ) -> list[dict[str, Any]]:
        """Flag a condition that orders or computes on an item it cannot count on (#659).

        An item that was never asked has ``outcome is None``. Equality survives
        that (``None != 1`` is a clean True), which is why the idiom is safe and
        common; an ORDERING comparison or an arithmetic operand does not — it
        raises ``TypeError``, and the runtime then skips the gated item
        (precondition) or accepts the answer unchecked (postcondition, recorded
        ``critical`` and excluded from Bronze). See
        ``FlowProcessor._UNEVALUATABLE_CONDITION_POLICY``.

        The rule: for a condition owned by X that orders on ``Y.outcome``, Y must
        be reachable whenever X is — ``UNSAT(base ∧ P_X ∧ ¬P_Y)``. The check is
        skipped outright when Y is classified ALWAYS, which is the overwhelming
        majority of references, so this costs one push/pop per genuinely
        conditional referent rather than one per predicate.

        WARNING, not ERROR: the shape is fielded in live instruments (BRFSS's
        ``q_cdem_01.outcome >= q_cchc_13.outcome`` excluded 58 of 60 surveys from
        Bronze) and a publish-blocking error would strand them. It shows in the
        quality report and never flips Portor's error-only ``is_valid`` gate.
        """
        builder = self.engine.static_builder
        issues: list[dict[str, Any]] = []
        try:
            return self._reference_issues(builder, classifications, issues)
        except Exception as e:
            # Same stance as the per-level wrapping in _hierarchy_issues and the
            # classifier's own guard: a solver or builder fault degrades THIS
            # lint's coverage. Without it, one fault discards the whole
            # to_issues() result — including the per-item classifications and
            # every other lint that already succeeded.
            self.logger.warning(f"Reference-safety lint failed: {e}", exc_info=True)
            return issues

    def _reference_issues(
        self,
        builder: Any,
        classifications: dict[str, Any],
        issues: list[dict[str, Any]],
    ) -> list[dict[str, Any]]:
        """The body of :meth:`_condition_reference_issues`, split out so the
        caller owns the degrade-on-failure boundary and this stays readable.

        ``issues`` is passed in rather than created here so a partial result
        survives the caller's except branch — findings already proven stay.
        """

        # Y is safe to order against iff it is asked on every path. That status
        # is already computed; consulting it first keeps the solver out of the
        # common case entirely.
        always_reachable = {
            item_id
            for item_id, result in classifications.items()
            if (result.get("precondition") or {}).get("status") == "ALWAYS"
        }

        solver = Solver(ctx=builder.ctx)
        solver.add(builder.get_reachability_base())

        def is_guaranteed(owner_id: str, referenced: str) -> bool:
            """Is ``referenced`` asked on every path that reaches ``owner_id``?

            A solver failure answers True — the finding is dropped rather than
            asserted on evidence the solver never produced. Reporting a gate as
            unsafe because Z3 fell over would send the author to edit a correct
            predicate. An owner gate that did not lower whole answers True for
            the same reason: it is wider than the real gate, so a SAT here could
            be a path the real gate never takes (#1164).
            """
            try:
                owner_gate, owner_exact = builder.compile_conditions_exactly(
                    owner_id, _gate(owner_id)
                )
                if not owner_exact:
                    return True
                solver.push()
                solver.add(owner_gate)
                solver.add(Not(builder.compile_conditions(referenced, _gate(referenced))))
                answer = solver.check() == unsat
                solver.pop()
                return answer
            except Exception as e:
                self.logger.warning(
                    f"Reference-safety check for '{owner_id}' -> '{referenced}' failed: {e}",
                    exc_info=True,
                )
                return True

        def _gate(item_id: str) -> list[dict[str, Any]]:
            return builder.item_details[item_id].get("preconditions") or []

        # One block-level condition appears in the composed list of EVERY item in
        # the block (static_builder composes block + item at population time), so
        # without this the author is told to fix N problems that are one line in
        # one block, each keyed to an item that declares nothing. Report a
        # block-sourced condition once, against the block.
        reported: set[tuple[str, str, str]] = set()

        for owner_id, details in builder.item_details.items():
            block_id = (self.state.get_item(owner_id) or {}).get("blockId")
            block = self.state.get_block(block_id) if block_id else None
            for kind in ("preconditions", "postconditions"):
                block_predicates = {
                    (c or {}).get("predicate") for c in ((block or {}).get(kind[:-1]) or [])
                }
                for condition in details.get(kind) or []:
                    predicate = condition.get("predicate", "")
                    if not predicate:
                        continue
                    # Attribute a block-sourced condition to the block that declares it.
                    from_block = predicate in block_predicates
                    declared_by = block_id if from_block else owner_id
                    for referenced in sorted(_none_unsafe_item_references(predicate)):
                        if referenced == owner_id or referenced in always_reachable:
                            continue
                        if referenced not in builder.item_details:
                            continue  # undefined_name lint owns this case
                        if (declared_by, predicate, referenced) in reported:
                            continue
                        if is_guaranteed(owner_id, referenced):
                            continue
                        reported.add((declared_by, predicate, referenced))
                        condition_kind = kind[:-1]  # 'preconditions' -> 'precondition'
                        scope = "block" if from_block else "item"
                        # The guard must fail to the side the RUNTIME fails to, and
                        # the two sides are opposite: a precondition that cannot be
                        # evaluated skips its item, so its guard must make the
                        # unasked case FALSE ('is not None and'); a postcondition
                        # accepts the answer, so its guard makes the unasked case
                        # TRUE ('is None or'). Emitting the postcondition form for a
                        # precondition is #658 written back into the remedy: the
                        # gate becomes true for exactly the respondents it excludes.
                        # Parenthesised because 'and' binds tighter than 'or' — an
                        # unparenthesised 'A is not None and X or Y' lets Y through.
                        guard = (
                            f"{referenced}.outcome is not None and ({predicate})"
                            if condition_kind == "precondition"
                            else f"{referenced}.outcome is None or ({predicate})"
                        )
                        issues.append(
                            {
                                "item_id": declared_by,
                                "severity": "warning",
                                "type": "none_unsafe_reference",
                                "message": (
                                    f"The {condition_kind} of {scope} '{declared_by}' orders or "
                                    f"computes on '{referenced}.outcome', but '{referenced}' is "
                                    f"not asked on every path that reaches it. When it was not "
                                    f"asked its outcome is None and the predicate raises, so the "
                                    f"rule does not apply where the author meant it to."
                                ),
                                "suggestion": (
                                    f"Guard the reference — '{guard}' — or repeat "
                                    f"'{referenced}'s own gate so the two are always reached "
                                    f"together. An equality test against "
                                    f"'{referenced}.outcome' needs no guard; only ordering and "
                                    f"arithmetic raise on None."
                                ),
                            }
                        )
        return issues

    def _uninitialized_read_issues(self) -> list[dict[str, Any]]:
        """Report a codeBlock variable read where it may not hold a value (#1024).

        ``undefined_name`` is file-scoped by design: a name any codeBlock binds
        is "known" everywhere, so a read that precedes its assignment in
        execution order, or follows an assignment made on one branch only,
        passes it. At runtime such a read raises ``NameError`` — since #1021
        the state chain makes that the honest outcome instead of a stale value —
        and what follows depends on the site: a precondition skips its item
        (``degraded``), a postcondition accepts the answer unchecked and a
        codeBlock stops part-way (both ``critical``). This lint moves the
        finding to publish time, and a block-level condition is reported once,
        against the block.

        For each item reading variable ``v`` (in a condition or its codeBlock)
        with the assigners of ``v`` that run before it in ``navigation_path``
        order: SAT(base ∧ P_reader ∧ ⋀ ¬(P_assigner ∧ guard)) means a
        respondent can reach the read with no assignment having run. Path-
        sensitive on purpose — a read gated on the same condition as the
        assignment (``q_b.outcome > 5 and risk == 1``) is safe and is not
        flagged. Exempt: names codeInit binds (always defined), names the
        reader's own codeBlock binds (a self-accumulator or a read after its
        own assignment), and names no codeBlock binds (``undefined_name``'s).

        WARNING: it never flips Portor's error-only ``is_valid`` gate, since
        instruments already in the field carry the shape. A solver or builder
        fault degrades this lint only, keeping the findings already proven.
        """
        issues: list[dict[str, Any]] = []
        try:
            self._collect_uninitialized_reads(self.engine.static_builder, issues)
        except Exception as e:
            self.logger.warning(f"Uninitialized-read lint failed: {e}", exc_info=True)
        return issues

    def _collect_uninitialized_reads(self, builder: Any, issues: list[dict[str, Any]]) -> None:
        """The body of :meth:`_uninitialized_read_issues`; ``issues`` is passed in
        so a partial result survives the caller's except branch."""
        order = {item_id: i for i, item_id in enumerate(self.engine.topology.topological_order)}

        init_code = self.state.get_code_init()
        init_bound = (
            StaticBuilder._collect_leaking_bound_names(ast.parse(init_code)) if init_code else set()
        )

        # variable -> {assigning item: guard or None}
        assigners: dict[str, dict[str, ast.expr | None]] = {}
        own_bound: dict[str, set[str]] = {}
        code_trees: dict[str, ast.Module] = {}
        for item in self.state.get_all_items():
            code = item.get("codeBlock")
            if not code or item.get("id") not in order:
                continue
            try:
                tree = ast.parse(code)
            except SyntaxError:
                continue  # the syntax lint owns this block
            item_id = item["id"]
            code_trees[item_id] = tree
            own_bound[item_id] = StaticBuilder._collect_bound_names(tree)
            for name in StaticBuilder._collect_leaking_bound_names(tree):
                assigners.setdefault(name, {})[item_id] = _assignment_guard(tree, name)

        candidates = set(assigners) - init_bound - set(builder.item_details)
        if not candidates:
            return

        solver = Solver(ctx=builder.ctx)
        solver.add(builder.get_reachability_base())

        # Each item's gate and each (assigner, variable) run condition is compiled
        # once: the same assigner is consulted for every later reader of the name.
        gates: dict[str, Any] = {}
        runs: dict[tuple[str, str], Any] = {}

        def gate(item_id: str) -> Any:
            if item_id not in gates:
                gates[item_id] = builder.compile_conditions(
                    item_id, builder.item_details[item_id].get("preconditions") or []
                )
            return gates[item_id]

        def ran(item_id: str, name: str) -> Any:
            if (item_id, name) not in runs:
                guard = assigners[name][item_id]
                runs[item_id, name] = (
                    gate(item_id)
                    if guard is None
                    else And(
                        gate(item_id),
                        builder.compile_conditions(item_id, [{"predicate": ast.unparse(guard)}]),
                    )
                )
            return runs[item_id, name]

        # The Z3 lowering drops a predicate it cannot express whole (#1164: one
        # unlowerable operand of ``str(q.outcome) == '9' and …`` drops the whole
        # predicate, leaving the gate True). On an assigner that only widens "it ran"
        # (fewer findings); on the READER it widens where the read can happen and
        # would flag a read its own gate protects. So a reader whose gate uses a
        # construct outside the plain comparison-and-arithmetic subset (a call, a
        # subscript, a string literal) is not judged: the lint says less rather
        # than something false.
        exact_gates: dict[str, bool] = {}

        def gate_is_exact(item_id: str) -> bool:
            if item_id not in exact_gates:
                exact = True
                for condition in builder.item_details[item_id].get("preconditions") or []:
                    try:
                        tree = ast.parse(condition.get("predicate", "") or "True", mode="eval")
                    except SyntaxError:
                        exact = False
                        break
                    if any(
                        isinstance(node, (ast.Call, ast.Subscript))
                        or (isinstance(node, ast.Constant) and isinstance(node.value, str))
                        for node in ast.walk(tree)
                    ):
                        exact = False
                        break
                exact_gates[item_id] = exact
            return exact_gates[item_id]

        def readable_unassigned(reader: str, name: str) -> bool:
            """Can a respondent reach *reader* with no earlier assigner of *name* run?
            A solver failure, or a reader gate Z3 cannot fully express, answers
            False — no finding on evidence the solver never produced."""
            if not gate_is_exact(reader):
                return False
            try:
                solver.push()
                try:
                    solver.add(gate(reader))
                    for assigner in assigners[name]:
                        if order[assigner] < order[reader]:
                            solver.add(Not(ran(assigner, name)))
                    return solver.check() == sat
                finally:
                    solver.pop()
            except Exception as e:
                self.logger.warning(
                    f"Uninitialized-read check for '{reader}' -> '{name}' failed: {e}",
                    exc_info=True,
                )
                return False

        # What the runtime does with the NameError depends on where the read is
        # (FlowProcessor._UNEVALUATABLE_CONDITION_POLICY and _execute_code_block).
        consequence = {
            "precondition": "the precondition raises NameError and the item is skipped "
            "(recorded degraded)",
            "postcondition": "the postcondition raises NameError and the answer is accepted "
            "unchecked (recorded critical, which excludes the survey from datasets)",
            "codeBlock": "the codeBlock stops at the read and leaves what follows it "
            "unassigned (recorded critical, which excludes the survey from datasets)",
        }

        # A block-level condition sits in the composed list of every member, so
        # it is reported once, against the block, as _reference_issues does.
        reported: set[tuple[str, str, str]] = set()

        for reader in sorted(builder.item_details, key=lambda i: order.get(i, len(order))):
            if reader not in order:
                continue
            details = builder.item_details[reader]
            block_id = (self.state.get_item(reader) or {}).get("blockId")
            block = self.state.get_block(block_id) if block_id else None
            # variable -> [(site kind, declaring item or block, scope word)]
            sites: dict[str, list[tuple[str, str, str]]] = {}
            for kind in ("precondition", "postcondition"):
                block_predicates = {
                    (c or {}).get("predicate") for c in ((block or {}).get(kind) or [])
                }
                for condition in details.get(f"{kind}s") or []:
                    predicate = condition.get("predicate", "")
                    if not predicate:
                        continue
                    try:
                        names = _free_reads(ast.parse(predicate, mode="eval"))
                    except SyntaxError:
                        continue
                    site = (
                        (kind, block_id, "block")
                        if predicate in block_predicates
                        else (kind, reader, "item")
                    )
                    for name in names & candidates:
                        sites.setdefault(name, []).append(site)
            if reader in code_trees:
                for name in (_free_reads(code_trees[reader]) - own_bound[reader]) & candidates:
                    sites.setdefault(name, []).append(("codeBlock", reader, "item"))

            for name in sorted(sites):
                pending = [
                    s for s in dict.fromkeys(sites[name]) if (s[1], s[0], name) not in reported
                ]
                if not pending or not readable_unassigned(reader, name):
                    continue
                later = sorted(a for a in assigners[name] if order[a] >= order[reader])
                earlier = sorted(a for a in assigners[name] if order[a] < order[reader])
                where = (
                    "it is assigned only by "
                    + ", ".join("its own codeBlock" if a == reader else repr(a) for a in later)
                    + ", which runs after the read"
                    if not earlier
                    else f"a respondent can reach it without {', '.join(repr(a) for a in earlier)} "
                    f"having assigned it (skipped by its precondition, or assigned on one "
                    f"branch only)"
                )
                for kind, declared_by, scope in pending:
                    reported.add((declared_by, kind, name))
                    issues.append(
                        {
                            "item_id": declared_by,
                            "severity": "warning",
                            "type": "uninitialized_read",
                            "message": (
                                f"The {kind} of {scope} '{declared_by}' reads variable "
                                f"'{name}', but {where}. At runtime {consequence[kind]}."
                            ),
                            "suggestion": (
                                f"Give '{name}' a value on every path before '{declared_by}' — "
                                f"assign a default in codeInit (e.g. '{name} = 0') or on both "
                                f"branches — or gate '{declared_by}' on the same condition as "
                                f"the assignment."
                            ),
                        }
                    )

    def _hierarchy_issues(self, *, deep: bool) -> list[dict[str, Any]]:
        """Surface validation-hierarchy Levels 2–4 as graded issues.

        The three levels are implemented and tested in ``askalot_qml/z3/`` but,
        before #164, no production channel ran them — only Level 1 reached
        ``to_issues``. Consequences: a globally-UNSAT questionnaire (traps every
        respondent) and a cyclic one (ambiguous evaluation order) both passed the
        publish gate. This method closes that gap, reusing the already-built
        ``engine`` (StaticBuilder + topology) so no work is duplicated.

        Severity policy:

        - **Level 2 — global satisfiability** (``GlobalFormula``, one solver
          call): ``global_unsat`` ERROR when ``F := B ∧ ∧(P_i ⇒ Q_i)`` is UNSAT
          (no valid completion exists — every path is trapped). ``UNKNOWN`` from
          the solver is a ``global_unknown`` WARNING (soundness unproven, rare for
          the linear-integer domain), never a false block.
        - **Level 3 — dependency cycles** (computed at engine init, free):
          ``dependency_cycle`` ERROR per cycle — a variable feedback loop makes
          evaluation order ambiguous. The topology linearizes cycles so the
          runtime does not crash, but the author must break the loop.
        - **Level 4 — accumulated dead code** (``PathBasedValidator``, O(items²)
          solver work): ``accumulated_dead_code`` WARNING per item that is
          CONDITIONAL per-item yet unreachable once predecessor postconditions
          accumulate. WARNING (not error) because the analysis is
          topological-order-dependent; gated behind ``deep`` so it never slows the
          interactive validate loop (only the publish gate opts in).

        Each level is wrapped defensively (log + skip on failure) so a single
        solver hiccup degrades coverage rather than nuking the whole issue list —
        matching :meth:`get_item_classifications`, which swallows Z3 errors the
        same way.
        """
        from askalot_qml.z3.global_formula import GlobalFormula

        issues: list[dict[str, Any]] = []
        builder = self.engine.static_builder

        # Level 2 — global satisfiability F := B ∧ ∧(P_i ⇒ Q_i).
        try:
            gf = GlobalFormula(builder)
            result = gf.check()
            if result.status == "UNSAT":
                conflicting = gf.get_conflicting_items()
                where = (
                    f" The conflict involves: {', '.join(conflicting)}."
                    if conflicting
                    else ""
                )
                issues.append(
                    {
                        "item_id": None,
                        "severity": "error",
                        "type": "global_unsat",
                        "message": (
                            "The questionnaire has no valid completion: accumulated "
                            "postconditions conflict, so every respondent is trapped at "
                            f"runtime (global formula B ∧ ∧(Pᵢ ⇒ Qᵢ) is UNSAT).{where}"
                        ),
                        "suggestion": (
                            "Relax or remove the conflicting postconditions so at least "
                            "one set of answers satisfies every reachable item's "
                            "postcondition simultaneously."
                        ),
                    }
                )
            elif result.status == "UNKNOWN":
                issues.append(
                    {
                        "item_id": None,
                        "severity": "warning",
                        "type": "global_unknown",
                        "message": (
                            "Global satisfiability could not be decided by the solver, so "
                            "the questionnaire's soundness is unproven (it may or may not "
                            "have a valid completion)."
                        ),
                        "suggestion": (
                            "Simplify the postcondition logic (fewer non-linear or deeply "
                            "nested constraints) so the solver can decide it."
                        ),
                    }
                )
        except Exception as e:
            self.logger.warning(f"Global satisfiability check failed: {e}", exc_info=True)

        # Level 3 — dependency cycles.
        try:
            if self.engine.has_cycles():
                for cycle in self.engine.get_cycles():
                    if not cycle:
                        continue
                    path = " → ".join(cycle) + f" → {cycle[0]}"
                    issues.append(
                        {
                            "item_id": cycle[0],
                            "severity": "error",
                            "type": "dependency_cycle",
                            "message": (
                                f"Items form a dependency cycle ({path}): each reads a "
                                "value the next produces, so their evaluation order is "
                                "ambiguous."
                            ),
                            "suggestion": (
                                "Break the loop by removing one of the cross-references — "
                                "give the cycle a single acyclic direction (one item "
                                "produces, the others read)."
                            ),
                        }
                    )
        except Exception as e:
            self.logger.warning(f"Cycle detection failed: {e}", exc_info=True)

        # Level 4 — accumulated dead code (deep only; O(items²) solver work).
        if deep:
            from askalot_qml.z3.path_based_validation import PathBasedValidator

            try:
                path_result = PathBasedValidator(builder, self.engine.topology).validate()
                for item_id in path_result.dead_code_items:
                    item_result = path_result.item_results.get(item_id)
                    preds = (
                        ", ".join(item_result.predecessors)
                        if item_result and item_result.predecessors
                        else "earlier items"
                    )
                    issues.append(
                        {
                            "item_id": item_id,
                            "severity": "warning",
                            "type": "accumulated_dead_code",
                            "message": (
                                f"Item '{item_id}' is reachable in isolation but becomes "
                                f"unreachable once the postconditions of preceding items "
                                f"({preds}) accumulate — it is dead code on every valid "
                                f"path."
                            ),
                            "suggestion": (
                                f"Loosen the precondition of '{item_id}' or the upstream "
                                f"postconditions that contradict it, or remove '{item_id}' "
                                f"if it is genuinely unreachable."
                            ),
                        }
                    )
            except Exception as e:
                self.logger.warning(f"Path-based dead-code check failed: {e}", exc_info=True)

        return issues

    def _hygiene_issues(self) -> list[dict[str, Any]]:
        """Build the U3 hygiene warnings (R11): write-only variables, pass-through
        aliases, and postconditions that duplicate an input control's bounds.

        Sources: the StaticBuilder read/write census
        (:meth:`StaticBuilder.get_variable_census`) for the two variable lints,
        and :meth:`StaticBuilder.analyze_postconditions` for the bound-duplicate
        lint. Each issue carries the same five contract keys as every other issue.
        """
        builder = self.engine.static_builder
        issues: list[dict[str, Any]] = []

        for var_name, entry in builder.get_variable_census().items():
            assignments = entry["assignments"]
            if not assignments:
                continue

            # Write-only: assigned at least once, never read anywhere (across
            # predicates and codeBlock RHS). A self-only accumulator (``x = x +
            # 1``) still records a read of ``x``, so reads>0 keeps it off this
            # lint — the target is the LFS ``path`` shape (constant assignments,
            # zero reads). Attributed to the first real item that assigns it, or
            # to the ``"codeInit"`` label when every assignment is in codeInit —
            # never ``None`` (every issue carries a real owner string, and
            # ``"codeInit"`` is now a reserved id so it can't shadow a real item).
            if entry["reads"] == 0:
                # Enumerate EVERY writer site (#167): the finding used to name
                # only the first assigning item, so a fixer who trusted it removed
                # one dead write and left the rest (LFS: ``path`` written by six
                # codeBlocks, flagged at one). ``owner`` remains the first real
                # item (or the ``"codeInit"`` label) as the issue's anchor; the
                # message lists all sites so the fixer removes them all.
                sites = list(dict.fromkeys(a["context"] for a in assignments))
                owner = next((c for c in sites if c != "codeInit"), "codeInit")
                site_list = ", ".join(f"'{s}'" for s in sites)
                issues.append(
                    {
                        "item_id": owner,
                        "severity": "warning",
                        "type": "write_only_variable",
                        "message": (
                            f"Variable '{var_name}' is assigned at {len(sites)} site(s) "
                            f"({site_list}) but never read (write-only). Its value gates "
                            f"nothing, so every assignment is dead state."
                        ),
                        "suggestion": (
                            f"Remove '{var_name}' and all {len(sites)} of its assignments, "
                            f"or add the condition that was meant to consume it."
                        ),
                    }
                )
                continue

            # Pass-through alias: exactly one assignment, a bare ``<item>.outcome``
            # with no transformation, and the variable is read somewhere (reads>0,
            # guaranteed here since write-only was handled above). Two producers
            # (consolidation) or any transformation leaves ``bare_outcome_item``
            # None and exempts the variable.
            if len(assignments) == 1 and assignments[0]["bare_outcome_item"]:
                # ``context`` is the owning item id, or the ``"codeInit"`` label
                # for a codeInit-only alias — never None (see write-only above).
                context = assignments[0]["context"]
                source_item = assignments[0]["bare_outcome_item"]
                issues.append(
                    {
                        "item_id": context,
                        "severity": "warning",
                        "type": "pass_through_alias",
                        "message": (
                            f"Variable '{var_name}' is a pass-through alias of "
                            f"'{source_item}.outcome' (assigned once, no "
                            f"transformation)."
                        ),
                        "suggestion": (
                            f"Reference '{source_item}.outcome' directly instead of "
                            f"introducing the '{var_name}' variable."
                        ),
                    }
                )

        # Frozen-variable gates (#169). A frozen variable — initialized in
        # codeInit, never reassigned by any codeBlock — is a compile-time
        # constant, so every precondition/postcondition that reads it is
        # statically decided (always true or always false) while looking
        # conditional. The classifier already USES this fact for reachability
        # (get_reachability_base), but before #169 the defect had no direct lint:
        # the always-FALSE polarity surfaced only indirectly as N downstream
        # ``unreachable_item`` errors (root cause unstated), and the always-TRUE
        # polarity produced ZERO diagnostics — a gate the instrument specified
        # silently enforcing nothing. This ERROR names the root cause and lists
        # the affected gates; it groups (does not replace) the symptom findings,
        # which stay per-location and actionable. Structural — no solver calls.
        for var_name, locations in builder.get_frozen_variable_gates().items():
            loc_list = ", ".join(f"'{loc}'" for loc in locations)
            issues.append(
                {
                    "item_id": "codeInit",
                    "severity": "error",
                    "type": "frozen_variable",
                    "message": (
                        f"Variable '{var_name}' is initialized in codeInit and read by the "
                        f"condition(s) of {len(locations)} item(s)/block(s) ({loc_list}) but "
                        f"never assigned by any codeBlock — it always holds its initial "
                        f"value, so every gate on it is statically decided (always true or "
                        f"always false) while looking conditional."
                    ),
                    "suggestion": (
                        f"If '{var_name}' is an external value (prefill, sample file, "
                        f"roster, proxy flag), model it as a normal question with a real "
                        f"input domain, mark that item 'external: true', and gate on its "
                        f"outcome — the platform pre-answers it at survey init from the "
                        f"respondent record when a value is available and asks it otherwise; "
                        f"if it is meant to be derived, add a codeBlock that actually "
                        f"produces it; if it is a true constant, fold it into the predicates "
                        f"and drop the dead gate."
                    ),
                }
            )

        # One warning per ITEM, not per postcondition predicate (#167): an item
        # that restates its min in one condition and its max in another (or has
        # the same bound in two conditions) is a single authoring defect, but
        # analyze_postconditions yields one record per predicate — dedup here so
        # the item is flagged once.
        seen_duplicate_bound: set[str] = set()
        for record in self._get_postcondition_records():
            if not record["duplicate_input_bound"]:
                continue
            item_id = record["item_id"]
            if item_id in seen_duplicate_bound:
                continue
            seen_duplicate_bound.add(item_id)
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "warning",
                    "type": "duplicate_input_bound",
                    "message": (
                        f"Item '{item_id}' has a postcondition that merely restates "
                        f"its input control's min/max bounds — the control's domain "
                        f"already enforces them, so the rule constrains nothing new."
                    ),
                    "suggestion": (
                        f"Remove the postcondition, or replace it with a "
                        f"cross-question constraint that ties '{item_id}' to another "
                        f"answer."
                    ),
                }
            )
        return issues

    def _authoring_issues(self) -> list[dict[str, Any]]:
        """Build the authoring warnings: a Comment that asks, a Roster whose
        ``subjectFrom`` names an item that can never answer, a
        questionnaire-level condition nothing will ever evaluate, and the three
        per-item shapes the Demo-instrument review found by reading (#559): a
        self-assignment, a mandated-answer postcondition and a combinable
        "none of the above" option.

        All read the AUTHORED tree (item ``kind``/``title``/``input``, the
        conditions and codeBlocks as written, block metadata) rather than the Z3
        census, so none needs the solver. All are WARNINGs: they describe an
        instrument that runs, just not as its own wording promises, so they
        must not reach the publish gate.
        """
        issues: list[dict[str, Any]] = []

        # --- A questionnaire-level condition (#559) ----------------------
        # Conditions exist at ITEM and BLOCK level. The schema advertised the
        # two root-level keys and no consumer ever read them: not the flow
        # processor (``_effective_conditions`` composes block + item only), not
        # the Z3 builder (``item_details`` composes the same two), not the
        # diagram. An author who wrote one got a gate that silently enforced
        # nothing. The keys are gone from the schema; this lint exists because
        # the schema does not reject unknown keys, so removal alone would leave
        # the same silence.
        for condition_kind in ("precondition", "postcondition"):
            if not self.state.get(condition_kind):
                continue
            issues.append(
                {
                    "item_id": self.state.get("title") or "questionnaire",
                    "severity": "warning",
                    "type": "questionnaire_level_condition",
                    "message": (
                        f"The questionnaire declares a root-level "
                        f"'{condition_kind}'. Conditions are evaluated at item and "
                        f"block level only, so this one never runs — it enforces "
                        f"nothing and is invisible to Z3."
                    ),
                    "suggestion": (
                        f"Move the {condition_kind} onto the block it should gate "
                        f"(a block-level {condition_kind} applies to every item in "
                        f"the block, evaluated before the item's own), or onto the "
                        f"individual items."
                    ),
                }
            )

        # --- A Comment titled as a request -------------------------------
        # A Comment carries no outcome by contract (ItemProxy.from_outcome), so
        # a title asking for one is unanswerable by construction: the item
        # renders as text with no control, and the respondent is asked a
        # question the instrument then refuses to record.
        for item in self.state.get_all_items():
            if item.get("kind") != "Comment":
                continue
            title = (item.get("title") or "").strip()
            if not title:
                continue
            if not (
                _COMMENT_ASKS_QUESTION_MARK.search(title)
                or _COMMENT_ASKS_INSCRIPTION.search(title)
            ):
                continue
            item_id = item.get("id")
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "warning",
                    "type": "comment_titled_as_question",
                    "message": (
                        f"Comment '{item_id}' is titled as a request for an answer "
                        f"({title[:80]!r}), but a Comment is display-only and carries "
                        f"no outcome — it renders with no input control, so the "
                        f"respondent is asked something the instrument cannot record."
                    ),
                    "suggestion": (
                        f"If '{item_id}' should collect an answer, make it a Question "
                        f"with an 'input' block (control: Textarea for free text). If "
                        f"it should not, reword the title so it states rather than "
                        f"asks — the current wording promises a field that will never "
                        f"appear."
                    ),
                }
            )

        # --- A Roster subject that can never resolve ----------------------
        # ``subjectFrom`` names the inner item whose per-iteration ANSWER
        # becomes the iteration's display subject. A target that is missing,
        # lives in another block, or is a Comment supplies no answer ever, and
        # FlowProcessor._resolve_roster_subject degrades silently to the static
        # label — so without this the defect has no surface at any layer.
        for block in self.state.get_blocks():
            if block.get("kind") != "Roster":
                continue
            subject_from = block.get("subjectFrom")
            if not subject_from:
                continue
            block_id = block.get("id")
            target = self.state.get_item(subject_from)
            if target is None:
                reason = "names no item in this questionnaire"
            elif target.get("_roster_block_id") != block_id:
                reason = f"names an item outside the '{block_id}' Roster"
            elif target.get("kind") == "Comment":
                reason = "names a Comment, which carries no outcome by contract"
            else:
                continue
            issues.append(
                {
                    "item_id": block_id,
                    "severity": "warning",
                    "type": "roster_subject_not_answerable",
                    "message": (
                        f"Roster '{block_id}' declares subjectFrom '{subject_from}', "
                        f"which {reason}. The per-iteration subject can never resolve, "
                        f"so every iteration silently falls back to its static label."
                    ),
                    "suggestion": (
                        f"Point subjectFrom at an answerable item inside '{block_id}' "
                        f"— typically the Textarea Question collecting the subject's "
                        f"name — or drop it and keep the static labels."
                    ),
                }
            )

        for item in self.state.get_all_items():
            issues.extend(self._self_assignment_issues(item))
            # Only a single Question has a scalar outcome. A QuestionGroup or
            # MatrixQuestion answers a list, which the domain interpreter would
            # misread and the suggested ``//``/``%`` guard would crash on.
            if item.get("kind") != "Question" or not item.get("id"):
                continue
            # A block-level postcondition runs for every item in its block
            # (``FlowProcessor._effective_conditions``), so it can mandate an
            # answer or refuse a combination just as an item-level one can.
            block_id = item.get("blockId")
            block = self.state.get_block(block_id) if block_id else None
            postconditions = list((block or {}).get("postcondition") or []) + list(
                item.get("postcondition") or []
            )
            issues.extend(self._mandated_answer_issues(item, postconditions))
            issues.extend(self._combinable_none_option_issues(item, postconditions))

        return issues

    @staticmethod
    def _self_assignment_issues(item: QuestionnaireItem) -> list[dict[str, Any]]:
        """A codeBlock statement that assigns a name or outcome to itself (#559).

        ``q_h1_building.outcome = q_h1_building.outcome`` changes nothing, yet
        reads like a derivation — a reader looks for the transformation that was
        meant to be there. Compared on the unparsed text so ``x = x`` and
        ``q.outcome = q.outcome`` both match and ``x = x + 0`` does not. A
        codeBlock that does not parse is ``unsafe_code``'s finding. Nested
        statements (inside an ``if`` or a loop) are walked too.
        """
        code = item.get("codeBlock")
        if not code:
            return []
        try:
            tree = ast.parse(code)
        except SyntaxError:
            return []
        item_id = item.get("id")
        issues = []
        for statement in ast.walk(tree):
            if not (isinstance(statement, ast.Assign) and len(statement.targets) == 1):
                continue
            target = ast.unparse(statement.targets[0])
            if target != ast.unparse(statement.value):
                continue
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "warning",
                    "type": "self_assignment",
                    "message": (
                        f"The codeBlock of '{item_id}' assigns '{target}' to itself "
                        f"(line {statement.lineno}). The statement changes nothing, "
                        f"but reads as if it derived a value."
                    ),
                    "suggestion": (
                        f"Delete the statement, or write the transformation it was "
                        f"meant to apply to '{target}'."
                    ),
                }
            )
        return issues

    @staticmethod
    def _mandated_answer_issues(
        item: QuestionnaireItem, postconditions: list[Condition]
    ) -> list[dict[str, Any]]:
        """Postconditions that together admit exactly one answer of a choice control (#559).

        ``q_ssn_consent.outcome == 1`` on a Yes/No item is not validation: every
        respondent who answers No is held on the item and can only leave the
        interview, so the refusal the item exists to measure never becomes a
        row. Only LOCAL postconditions (ones that read nothing but the item's
        own outcome) are judged — a relational one depends on other answers, and
        admitting one value there can be a legitimate consistency rule. The
        local ones are intersected, since the respondent must satisfy every one
        (``!= 1`` and ``!= 2`` on a three-option Radio mandate 3 as surely as
        ``== 3`` does). ``postconditions`` is the block's plus the item's own.
        One warning per item.
        """
        domain = _choice_domain(item.get("input") or {})
        if len(domain) < 2:
            return []
        item_id = item.get("id")
        admitted = set(domain)
        narrowing: list[str] = []
        for condition in postconditions:
            predicate = condition.get("predicate") or ""
            local = _admitted_outcomes(predicate, item_id, domain)
            if local is None or local >= admitted:
                continue
            admitted &= local
            narrowing.append(predicate)
        if len(admitted) == 1:
            (only,) = admitted
            predicate = " and ".join(narrowing)
            return [
                {
                    "item_id": item_id,
                    "severity": "warning",
                    "type": "mandated_answer_postcondition",
                    "message": (
                        f"The postcondition '{predicate}' on '{item_id}' admits only "
                        f"the answer {only} of {len(domain)}. A respondent who gives "
                        f"any other answer cannot move past the item, so that answer "
                        f"is never recorded."
                    ),
                    "suggestion": (
                        f"Accept every answer and route on it instead: gate the items "
                        f"that follow on '{item_id}.outcome == {only}', and close the "
                        f"other branch with a screen-out Comment, so the refusal is "
                        f"recorded as data."
                    ),
                }
            ]
        return []

    @staticmethod
    def _combinable_none_option_issues(
        item: QuestionnaireItem, postconditions: list[Condition]
    ) -> list[dict[str, Any]]:
        """A Checkbox "none of the above" option that can be ticked beside others (#559).

        A Checkbox outcome is the sum of the ticked bits, so "No health
        insurance" plus a plan is a valid answer unless a postcondition refuses
        it, and a downstream gate reading ``!= 256`` then counts that respondent
        as insured and uninsured at once. Warns when some combination of the
        option with another bit passes every postcondition on the item. A
        postcondition this lint cannot evaluate (it reads another item, a
        variable or a call) silences it: the rule may already exclude the
        combination. ``postconditions`` is the block's plus the item's own, so a
        guard written on the block clears it too.
        """
        input_spec = item.get("input") or {}
        if input_spec.get("control") != "Checkbox":
            return []
        bits = label_keys(input_spec)
        if len(bits) < 2:
            return []
        raw_labels = input_spec.get("labels") or {}
        item_id = item.get("id")
        # Every postcondition must admit the combination, so judge their
        # conjunction; no postcondition at all admits everything.
        conjunction = " and ".join(f"({c.get('predicate') or 'True'})" for c in postconditions)
        issues = []
        for bit in bits:
            label = str(raw_labels.get(bit, raw_labels.get(str(bit), "")))
            if not _CHECKBOX_NONE_LABEL.search(label):
                continue
            combinations = [bit | other for other in bits if other != bit]
            admitted = _admitted_outcomes(conjunction or "True", item_id, combinations)
            if not admitted:
                continue
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "warning",
                    "type": "combinable_none_option",
                    "message": (
                        f"Checkbox '{item_id}' offers {label!r} (bit {bit}), which "
                        f"denies the other options, yet it can be ticked together "
                        f"with them. An answer carrying both contradicts itself, and "
                        f"a gate on '{item_id}.outcome' reads it as both."
                    ),
                    "suggestion": (
                        f"Add a postcondition that refuses the combination, e.g. "
                        f"'({item_id}.outcome // {bit}) % 2 == 0 or "
                        f"{item_id}.outcome == {bit}', with a hint telling the "
                        f"respondent to untick the other options."
                    ),
                }
            )
        return issues

    def classify_item(self, item_id: str) -> dict[str, Any]:
        """
        Get classification for a specific item.

        Args:
            item_id: ID of the item to classify

        Returns:
            Classification result for the item
        """
        classifications = self.get_item_classifications()
        return classifications.get(
            item_id,
            {
                "precondition": {"status": "UNKNOWN"},
                "postcondition": {
                    "invariant": "UNKNOWN",
                    "vacuous": False,
                    "global": {"q_globally_true": False, "q_globally_false": False},
                },
            },
        )

    def generate_validation_graph(self, enable_z3_validation: bool = True) -> dict:
        """
        Generate positions-free structural IR with Z3 validation coloring.

        Builds the JSON IR and inlines per-item classifications onto the item
        entries directly. Layout is computed client-side in the QML Explorer
        React webview via ELK.js — the server never emits coordinates.

        Args:
            enable_z3_validation: Whether to inline Z3 classifications

        Returns:
            IR dict with top-level arrays (blocks, items, conditions, variables,
            edges) and metadata; items carry a `classification` field when
            ``enable_z3_validation=True``.
        """
        from askalot_qml.core.qml_diagram_ir import QMLDiagramIR

        diagram_generator = QMLDiagramIR(self.engine.topology, self.state)
        base_graph = diagram_generator.generate_base_graph()

        if enable_z3_validation:
            # Reuse cached classifications (lazy-loaded once, not re-computed)
            classifications = self.get_item_classifications()
            return diagram_generator.apply_validation_coloring(
                base_graph, classifications=classifications
            )
        return base_graph

    def generate_validation_report(self) -> str:
        """
        Generate comprehensive text validation report.

        Returns:
            Detailed text report of questionnaire validation
        """
        from askalot_qml.core.qml_diagram_ir import QMLDiagramIR

        diagram_generator = QMLDiagramIR(self.engine.topology, self.state)
        base_report = diagram_generator.generate_validation_report()

        # Add Z3 classification summary if available
        classifications = self.get_item_classifications()
        if classifications:
            lines = [base_report, "", "Z3 Validation Results:"]

            # Count classification types
            always_count = sum(
                1
                for c in classifications.values()
                if c.get("precondition", {}).get("status") == "ALWAYS"
            )
            conditional_count = sum(
                1
                for c in classifications.values()
                if c.get("precondition", {}).get("status") == "CONDITIONAL"
            )
            never_count = sum(
                1
                for c in classifications.values()
                if c.get("precondition", {}).get("status") == "NEVER"
            )

            tautological_count = sum(
                1
                for c in classifications.values()
                if c.get("postcondition", {}).get("invariant") == "TAUTOLOGICAL"
            )
            constraining_count = sum(
                1
                for c in classifications.values()
                if c.get("postcondition", {}).get("invariant") == "CONSTRAINING"
            )
            infeasible_count = sum(
                1
                for c in classifications.values()
                if c.get("postcondition", {}).get("invariant") == "INFEASIBLE"
            )

            # Count block pre/postcondition inheritance (R25 reads from
            # block objects directly — block conditions are no longer
            # copied onto items at load time).
            items_with_block_preconds = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                for block in self.state.get_blocks()
                if block.get("precondition")
            )
            items_with_block_postconds = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                for block in self.state.get_blocks()
                if block.get("postcondition")
            )

            lines.append("  Precondition Reachability:")
            lines.append(
                f"    Always: {always_count}, Conditional: {conditional_count}, Never: {never_count}"
            )
            if items_with_block_preconds:
                lines.append(
                    f"    ({items_with_block_preconds} items inherit block-level preconditions)"
                )
            lines.append("  Postcondition Effects:")
            lines.append(
                f"    Tautological: {tautological_count}, Constraining: {constraining_count}, Infeasible: {infeasible_count}"
            )
            if items_with_block_postconds:
                lines.append(
                    f"    ({items_with_block_postconds} items inherit block-level postconditions)"
                )

            # R12: relational vs local postcondition coverage — how many
            # item-level postconditions actually tie one answer to another
            # (relational) vs constrain a single answer in isolation (local).
            postcondition_records = self._get_postcondition_records()
            relational = sum(1 for r in postcondition_records if r["relational"])
            local = len(postcondition_records) - relational
            lines.append("  Postcondition Coverage:")
            lines.append(f"    Relational: {relational}, Local: {local}")

            # Highlight problematic items
            problematic_items = []
            for item_id, classification in classifications.items():
                precond_status = classification.get("precondition", {}).get("status", "UNKNOWN")
                postcond_invariant = classification.get("postcondition", {}).get(
                    "invariant", "UNKNOWN"
                )

                if precond_status == "NEVER":
                    problematic_items.append(f"{item_id} (never reachable)")
                elif postcond_invariant == "INFEASIBLE":
                    problematic_items.append(f"{item_id} (infeasible postcondition)")

            if problematic_items:
                lines.append("\n⚠️  Potential Issues:")
                for item in problematic_items[:5]:  # Show first 5
                    lines.append(f"    {item}")
                if len(problematic_items) > 5:
                    lines.append(f"    ... and {len(problematic_items) - 5} more")

            return "\n".join(lines)

        return base_report

    def get_quality_report(self, issues: list[dict[str, Any]] | None = None) -> dict[str, Any]:
        """Compute the D2-D8 quality scorecard over this validation's artifacts.

        Thin delegate to :func:`askalot_qml.core.quality_metrics.compute_quality_report`
        — the scorecard is a *consumer* of validation artifacts, not a
        validation level, so the metric definitions live in their own module.
        Advisory only: nothing here feeds ``is_valid`` or the publish gate.

        Args:
            issues: Pre-computed ``to_issues()`` output. Callers that already
                have it (the publish gate computes it first) pass it to avoid a
                redundant second walk; ``None`` falls back to computing it here.
        """
        from askalot_qml.core.quality_metrics import compute_quality_report

        return compute_quality_report(
            state=self.state,
            topology=self.engine.topology,
            builder=self.engine.static_builder,
            classifications=self.get_item_classifications(),
            postcondition_records=self._get_postcondition_records(),
            issues=self.to_issues() if issues is None else issues,
        )

    def get_statistics(self) -> dict[str, Any]:
        """
        Get validation-specific statistics.

        Returns:
            Statistics about the questionnaire validation
        """
        stats = self.engine.get_statistics()

        # Add validation-specific information
        classifications = self.get_item_classifications()
        stats.update({"validation_mode": True, "z3_validation_available": bool(classifications)})

        if classifications:
            # Add classification statistics
            precond_stats = {}
            postcond_stats = {}

            for _item_id, classification in classifications.items():
                precond_status = classification.get("precondition", {}).get("status", "UNKNOWN")
                postcond_invariant = classification.get("postcondition", {}).get(
                    "invariant", "UNKNOWN"
                )

                precond_stats[precond_status] = precond_stats.get(precond_status, 0) + 1
                postcond_stats[postcond_invariant] = postcond_stats.get(postcond_invariant, 0) + 1

            # Count block pre/postcondition inheritance (R25 reads from
            # block objects directly). "Items inheriting" = items in any
            # block that declares a precondition/postcondition; "total
            # block predicates" = sum of block-level predicate lengths
            # multiplied by the number of items that inherit each one.
            items_with_block_preconditions = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                for block in self.state.get_blocks()
                if block.get("precondition")
            )
            total_block_preconditions = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                * len(block.get("precondition") or [])
                for block in self.state.get_blocks()
                if block.get("precondition")
            )
            items_with_block_postconditions = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                for block in self.state.get_blocks()
                if block.get("postcondition")
            )
            total_block_postconditions = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                * len(block.get("postcondition") or [])
                for block in self.state.get_blocks()
                if block.get("postcondition")
            )

            stats.update(
                {
                    "precondition_classification": precond_stats,
                    "postcondition_classification": postcond_stats,
                    "block_precondition_items": items_with_block_preconditions,
                    "block_preconditions_total": total_block_preconditions,
                    "block_postcondition_items": items_with_block_postconditions,
                    "block_postconditions_total": total_block_postconditions,
                }
            )

        # R12: relational vs local postcondition coverage. Independent of Z3
        # classification (it is a syntactic dependency count), so it is always
        # added — the Designer loop reads it alongside the consistency stats.
        postcondition_records = self._get_postcondition_records()
        relational = sum(1 for r in postcondition_records if r["relational"])
        stats.update(
            {
                "relational_postconditions": relational,
                "local_postconditions": len(postcondition_records) - relational,
            }
        )

        return stats

    def debug_dump(self) -> str:
        """Generate debug output for validation processor."""
        lines = []
        lines.append("=" * 60)
        lines.append("VALIDATION PROCESSOR DEBUG DUMP")
        lines.append("=" * 60)

        stats = self.get_statistics()
        lines.append("\nValidation Summary:")
        lines.append(f"  Z3 validation available: {stats['z3_validation_available']}")
        lines.append(f"  Has cycles: {self.engine.has_cycles()}")

        if stats.get("precondition_classification"):
            lines.append("\nPrecondition Classification:")
            for status, count in stats["precondition_classification"].items():
                lines.append(f"    {status}: {count}")

        if stats.get("postcondition_classification"):
            lines.append("\nPostcondition Classification:")
            for invariant, count in stats["postcondition_classification"].items():
                lines.append(f"    {invariant}: {count}")

        # Include engine debug info
        lines.append("\n" + self.engine.debug_dump())

        return "\n".join(lines)
