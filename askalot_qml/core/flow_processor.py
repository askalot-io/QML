"""
FlowProcessor - Flow Mode Implementation for QML Navigation

This processor handles runtime navigation for survey flow:
- Uses pre-computed topological order from QMLTopology for navigation path
- Evaluates preconditions dynamically at runtime (NOT using Z3)
- Optimized for performance (no expensive Z3 item classification during navigation)
- Tracks full navigation history for robust backward navigation
- Skips visited items when unvisited items remain ahead

Architecture:
1. Z3 Usage (initialization only):
   - Builds dependency graph via StaticBuilder
   - Detects cycles via QMLTopology
   - Computes stable topological order (Kahn's algorithm)

2. Runtime Navigation (no Z3):
   - Iterates through pre-computed navigation path
   - Evaluates preconditions via Python expressions
   - Tracks visited/isLast state attributes
   - Returns first item with satisfied preconditions

Uses the common QMLEngine pipeline for topology analysis.
"""

import ast
import copy
import functools
import logging
from collections.abc import Callable, Iterable
from dataclasses import dataclass
from typing import Any

from askalot_qml.core.domain_validator import outcome_in_domain
from askalot_qml.core.python_runner import CodeExecutionError, PythonRunner
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.item_proxy import ItemProxy
from askalot_qml.models.qml_state import SOURCE_EXTERNAL_PREFILL, QMLState
from askalot_qml.predicate_ast import (
    name_reads,
    none_tested_names,
    none_tested_outcomes,
    outcome_reads,
)

# What the engine does with a condition it could not evaluate (#168, #658).
#
# Each entry is ``(value_the_evaluator_returns, severity_recorded)``. The two
# kinds differ on BOTH axes, and the axes are decided by different facts:
#
#   precondition  → False, ``degraded``. A precondition RESTRICTS: it names the
#                   respondents an item is for. When the restriction cannot be
#                   checked, honouring it (skip) preserves the instrument;
#                   ignoring it (show) silently administers a different one.
#                   Returning False cannot strand anyone — navigation simply
#                   moves to the next item. The cost is under-collection of an
#                   item that may have been wanted, which the warning records:
#                   ``degraded``, and the survey stays dataset-eligible.
#   postcondition → True, ``critical``. A postcondition ADMITS: returning False
#                   is what ``process_item`` turns into "you may not advance"
#                   (it returns ``success: False`` with the author's hint), so
#                   failing closed here strands the respondent on an item whose
#                   check errors on every attempt. It must fail open — and the
#                   answer was then accepted without the check that decides
#                   whether it is admissible, so the stored value may be one the
#                   instrument's own rules reject. That is ``critical``, the
#                   string the dataset-eligibility probe matches on (the JSONB
#                   probe in ``askalot_common.repository.mixins.dataset``).
#
# #168 read the stranding argument as applying to both kinds and made both fail
# open; it only ever applied to the postcondition, because only there does False
# block. The precondition half of that stance was the defect #658 named: on the
# BRFSS demo fill an unanswered upstream item made three age-gated modules
# (``>= 45``) evaluate ``None >= 45``, and every one of them was administered to
# every respondent. Skipping is what the gate asked for.
_UNEVALUATABLE_CONDITION_POLICY: dict[str, tuple[bool, str]] = {
    "precondition": (False, "degraded"),
    "postcondition": (True, "critical"),
}

# Severity of a condition left undecided because a part that would decide it
# reads an item the respondent was SHOWN and left unanswered (#1023). The
# direction is ``_UNEVALUATABLE_CONDITION_POLICY``'s; the severity is
# ``degraded`` for both kinds, because a waived postcondition relates the answer
# to a value that does not exist and so no stored value contradicts it. The
# reasoning and the corpus figures are in askalot_qml/CLAUDE.md (Degradation
# warnings).
_UNANSWERED_OPERAND_SEVERITY = "degraded"

# The third truth value: a part of a condition that reads an unanswered item.
_UNKNOWN = object()


@dataclass(frozen=True)
class _Leaf:
    """A part of a condition below its and/or/not structure, evaluated on its own."""

    source: str
    # Items the leaf reads as ``X.outcome`` without itself testing them
    # against None — the operands whose missing answer makes it unknown.
    operands: frozenset[str]
    # Bare names the leaf reads without testing them against None: a variable
    # among them computed from an unanswered item makes the leaf unknown too
    # (#1044). Names read as ``X.outcome`` are operands, not variables.
    variables: frozenset[str]


@dataclass(frozen=True)
class _Junction:
    op: str  # "and" | "or" | "not"
    parts: tuple[_Leaf | _Junction, ...]


@dataclass(frozen=True)
class _ParsedCondition:
    root: _Leaf | _Junction
    operands: frozenset[str]  # every leaf's operands, for the no-unknowns fast path
    variables: frozenset[str]  # every leaf's variables, likewise


@functools.lru_cache(maxsize=4096)
def _parse_condition(expression: str) -> _ParsedCondition | None:
    """Split a condition into its and/or/not structure over leaves (#1023).

    A leaf that reads an unanswered item is UNKNOWN, and the structure combines
    it the Kleene way, so the parts that were answered still decide the gate
    when they can: ``q_a.outcome == 1 or q_b.outcome == 1`` holds for a
    respondent who answered 1 to ``q_a`` and skipped ``q_b``. A leaf that tests
    its own operand against None (``q_b.outcome is None``) has said what a
    missing answer means, so it is evaluated as written.

    A variable the state marks as computed from an unanswered item counts the
    same way (#1044), so ``v in [1, 2]`` after ``v = q_a.outcome`` is unknown
    when ``q_a`` was skipped — see ``_unknown_after``.
    Cached on the text because the serving path (``from_cached_state``) builds
    no dependency graph and a condition runs on every navigation step. None for
    an unparseable expression, which the evaluator then raises on and records.
    """
    try:
        body = ast.parse(expression, mode="eval").body
    except SyntaxError:
        return None

    operands: set[str] = set()
    variables: set[str] = set()

    def split(node: ast.expr) -> _Leaf | _Junction:
        if isinstance(node, ast.BoolOp):
            op = "and" if isinstance(node.op, ast.And) else "or"
            return _Junction(op, tuple(split(value) for value in node.values))
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.Not):
            return _Junction("not", (split(node.operand),))
        leaf_operands = frozenset(outcome_reads(node) - none_tested_outcomes(node))
        leaf_variables = frozenset(name_reads(node) - outcome_reads(node) - none_tested_names(node))
        operands.update(leaf_operands)
        variables.update(leaf_variables)
        return _Leaf(ast.unparse(node), leaf_operands, leaf_variables)

    root = split(body)
    return _ParsedCondition(root, frozenset(operands), frozenset(variables))


@functools.lru_cache(maxsize=1024)
def _parse_code_block(code: str) -> ast.Module | None:
    try:
        return ast.parse(code)
    except SyntaxError:
        return None


def _unknown_after(
    code: str,
    unknown: frozenset[str],
    unanswered: Callable[[str], bool],
) -> tuple[set[str], set[str]]:
    """Which variables a codeBlock computes from an unanswered item (#1044).

    Walks the block's statements in order and returns ``(marked, cleared)``:
    names assigned from an expression that reads the ``.outcome`` of an item
    *unanswered* says was left without an answer, or a variable already
    unknown — and names assigned from anything else. An assignment under an
    ``if`` / ``while`` / ``for`` whose test reads such data is marked too: which
    branch ran was itself decided by the missing answer. A read the expression
    tests against None (``q.outcome if q.outcome is not None else 0``) is the
    author's own handling and does not taint. Static and conservative — it
    cannot tell which branch actually ran, so alternative branches are walked
    from the same starting marks and merged: a name marked in ANY branch stays
    marked. The caller only CLEARS a mark on a name whose value actually
    changed, so an untaken clean branch keeps it. A container mutated with
    unanswered data (``d[k] = q.outcome``, ``xs.append(q.outcome)``) is marked
    but never cleared — its other elements may still hold such data.
    """
    tree = _parse_code_block(code)
    if tree is None:
        return set(), set()
    current = set(unknown)
    marked: set[str] = set()
    cleared: set[str] = set()

    def tainted(expr: ast.AST) -> bool:
        reads = outcome_reads(expr) - none_tested_outcomes(expr)
        if any(unanswered(item_id) for item_id in reads):
            return True
        return bool((name_reads(expr) - none_tested_names(expr)) & current)

    def stores(node: ast.AST) -> set[str]:
        return {
            n.id for n in ast.walk(node) if isinstance(n, ast.Name) and isinstance(n.ctx, ast.Store)
        }

    def mutated(node: ast.AST) -> set[str]:
        """The variable a subscript / attribute target (or call receiver) mutates."""
        while isinstance(node, (ast.Subscript, ast.Attribute)):
            node = node.value
        return {node.id} if isinstance(node, ast.Name) else set()

    def assign(names: set[str], is_tainted: bool) -> None:
        if is_tainted:
            current.update(names)
            marked.update(names)
            cleared.difference_update(names)
        else:
            current.difference_update(names)
            cleared.update(names)
            marked.difference_update(names)

    def mutate(names: set[str], is_tainted: bool) -> None:
        if is_tainted:
            assign(names, True)

    def alternatives(bodies: list[list[ast.stmt]], under_taint: bool) -> None:
        """Walk each body from the same marks, then keep the union of marks."""
        nonlocal current, marked, cleared
        start = (current, marked, cleared)
        results = []
        for body in bodies:
            current, marked, cleared = set(start[0]), set(start[1]), set(start[2])
            walk(body, under_taint)
            results.append((current, marked, cleared))
        current = set().union(*(r[0] for r in results))
        marked = set().union(*(r[1] for r in results))
        cleared = set().union(*(r[2] for r in results)) - marked

    def walk(statements: list[ast.stmt], under_taint: bool) -> None:
        for st in statements:
            if isinstance(st, (ast.Assign, ast.AnnAssign)):
                targets = st.targets if isinstance(st, ast.Assign) else [st.target]
                is_tainted = under_taint or (st.value is not None and tainted(st.value))
                assign(set().union(*(stores(t) for t in targets)), is_tainted)
                mutate(set().union(*(mutated(t) for t in targets)), is_tainted)
            elif isinstance(st, ast.AugAssign):
                names = stores(st.target)
                assign(names, under_taint or bool(names & current) or tainted(st.value))
                mutate(mutated(st.target), under_taint or tainted(st.value))
            elif (
                isinstance(st, ast.Expr)
                and isinstance(st.value, ast.Call)
                and isinstance(st.value.func, ast.Attribute)
            ):
                mutate(mutated(st.value.func.value), under_taint or tainted(st.value))
            elif isinstance(st, (ast.If, ast.While)):
                alternatives([st.body, st.orelse], under_taint or tainted(st.test))
            elif isinstance(st, ast.For):
                branch = under_taint or tainted(st.iter)
                assign(stores(st.target), branch)
                alternatives([st.body, st.orelse], branch)
            elif isinstance(st, ast.With):
                walk(st.body, under_taint)
            elif isinstance(st, ast.Try):
                alternatives(
                    [st.body + st.orelse, *(handler.body for handler in st.handlers)],
                    under_taint,
                )
                walk(st.finalbody, under_taint)

    walk(tree.body, False)
    return marked, cleared


def _set_bits(mask: int) -> list[int]:
    """The power-of-2 values set in a Roster ``iterateOver`` mask, low to high.

    Roster iteration identity IS the bit value, so this yields the keys the
    mask asks for — the set the declared ``labels`` are checked against.
    """
    return [1 << position for position in range(mask.bit_length()) if mask & (1 << position)]


class FlowProcessor:
    """
    Flow mode processor for runtime survey navigation.

    Provides:
    - Pre-computed topological navigation path
    - Graph data generation for flow visualization
    - Current item tracking and bidirectional navigation
    - Performance-optimized (no Z3 during navigation)

    Navigation strategy:
    1. Initialization (uses Z3 once):
       - Builds dependency graph from preconditions/postconditions/code blocks
       - Detects cycles via Z3 satisfiability checking
       - Computes stable topological order (Kahn's algorithm preserving QML order)

    2. Forward Navigation (no Z3):
       - Iterates through pre-computed navigation path
       - Skips visited items if unvisited items remain ahead
       - Evaluates preconditions dynamically via Python eval
       - Returns first item with satisfied preconditions

    3. Backward Navigation:
       - Uses navigation history stack (list of visited item IDs)
       - Pops current item and marks as unvisited
       - Returns to previous item from history

    State attributes:
    - visited: Item has been completed by user
    - isLast: Last item in survey (completion marker)
    """

    def __init__(self, questionnaire_state: QMLState):
        """
        Initialize flow processor with questionnaire state.

        This constructor creates a full QMLEngine (which includes Z3 topology analysis).
        For already-initialized surveys, use from_cached_state() instead to skip Z3.

        Args:
            questionnaire_state: The questionnaire to process
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state
        self.python_runner = PythonRunner()
        self.topology: QMLTopology | None = None
        # See _check_preconditions: transient, and only _group_reach_decision reads it.
        self._last_gate_undecided = False

        # Use unified engine for common pipeline
        self.engine = QMLEngine(questionnaire_state)
        self.topology = self.engine.topology

        # Only initialize the questionnaire if it hasn't been initialized yet
        # Check if navigation_path exists as a marker of initialization
        if not questionnaire_state.get_navigation_path():
            self._initialize_questionnaire(questionnaire_state)
            self.logger.info("Questionnaire initialized for the first time")
        else:
            self.logger.debug("Questionnaire already initialized, skipping initialization")

        self.logger.info(f"FlowProcessor initialized for {len(self.engine.get_items())} items")

    @classmethod
    def from_cached_state(cls, questionnaire_state: QMLState) -> FlowProcessor:
        """Create a lightweight FlowProcessor without Z3/QMLEngine initialization.

        Use this when the survey is already initialized (has navigation_path cached).
        Skips QMLEngine/StaticBuilder/QMLTopology creation entirely, avoiding Z3 overhead.

        Runtime navigation (get_current_item, process_item) only needs:
        - PythonRunner for precondition/postcondition evaluation
        - The cached navigation path from questionnaire_state

        Args:
            questionnaire_state: Already-initialized QMLState with cached navigation path
        """
        instance = cls.__new__(cls)
        instance.logger = logging.getLogger(__name__)
        instance.state = questionnaire_state
        instance.python_runner = PythonRunner()
        instance.topology = None
        instance.engine = None
        instance._last_gate_undecided = False
        instance.logger.debug("FlowProcessor created from cached state (no Z3)")
        return instance

    def _evaluate_condition(
        self,
        condition_expr: str,
        context_of: Callable[[], dict[str, Any]],
        item_id: str,
        condition_type: str,
        unknown: Iterable[str] | None = None,
    ) -> bool:
        """
        Evaluate a condition expression.

        Args:
            condition_expr: The Python expression to evaluate
            context_of: Returns the variables and item proxies to evaluate in.
                Called only when a part of the condition is actually evaluated:
                building the context costs a deep copy plus one proxy per item,
                and a gate undecided on an unanswered item — re-checked on every
                navigation step — needs none.
            item_id: Item ID the condition belongs to, for warning collection
            condition_type: Key into ``_UNEVALUATABLE_CONDITION_POLICY`` —
                'precondition' or 'postcondition'. Required and indexed
                directly: an unrecognised kind has no defensible fallback
                direction, so a KeyError is the honest outcome.
            unknown: The variables *context_of* marks as computed from an
                unanswered item (#1044). Must describe the same state the
                context is built from; None means the current (tail) state,
                which is what a gate reads.

        Returns:
            - True if condition expression evaluates to truthy value
            - False if condition expression evaluates to falsy value
            - The policy's fail value if the expression cannot be evaluated
              (unsupported AST constructs, missing variables, type errors) —
              False for a precondition, True for a postcondition — with a
              warning recorded on QMLState at the matching severity.
            - The same fail value when the answered parts of the condition
              cannot decide it and the rest read an item the respondent was
              shown and left unanswered — ``<kind>_unanswered_dependency`` at
              ``_UNANSWERED_OPERAND_SEVERITY`` (#1023).

        Design rationale:
            The two kinds fail in opposite directions because False means
            opposite things to their callers: a precondition that returns False
            skips an item, a postcondition that returns False refuses to let the
            respondent advance. See ``_UNEVALUATABLE_CONDITION_POLICY``.
        """
        if not condition_expr:
            return True  # If no condition, it's always satisfied

        parsed = _parse_condition(condition_expr)
        unanswered: frozenset[str] = frozenset()
        if parsed:
            # One history snapshot for both scans: a skipped item's gate is
            # re-checked on every navigation step.
            on_path = self._on_path()
            self._record_orphan_reads(parsed.operands, item_id, condition_type, on_path)
            unanswered = self._unanswered(
                parsed.operands, item_id, on_path
            ) | self._unknown_variables(parsed.variables, unknown)
        try:
            if not unanswered:
                return self.python_runner.eval_expr(expr=condition_expr, **context_of())
            verdict = self._evaluate_three_valued(parsed.root, unanswered, context_of)
        except Exception as e:
            return self._undecided(
                condition_type,
                item_id,
                warning_type=condition_type,
                reason=f"Unable to evaluate {condition_type} '{condition_expr}': {e}.",
                severity=_UNEVALUATABLE_CONDITION_POLICY[condition_type][1],
            )
        if verdict is not _UNKNOWN:
            return verdict
        return self._undecided(
            condition_type,
            item_id,
            warning_type=f"{condition_type}_unanswered_dependency",
            reason=(
                f"Could not decide {condition_type} '{condition_expr}': it reads "
                f"{', '.join(sorted(unanswered))}, presented and left unanswered "
                f"or computed from such an item."
            ),
            severity=_UNANSWERED_OPERAND_SEVERITY,
        )

    def _presented(self, item: dict[str, Any], on_path: frozenset[str]) -> bool:
        """The flow presented *item* on the current path and it was processed.

        The one predicate for "the respondent was shown this" (#1022/#1023):
        history holds only items the walk actually reached, and ``visited``
        that the item was processed. Either alone is wrong — ``visited`` is also
        set by Roster completion on members nobody asked, and by a codeBlock
        writing another item's outcome; history also holds the presented item
        not yet answered.
        """
        return item["id"] in on_path and bool(item.get("visited"))

    @staticmethod
    def _orphaned(item: dict[str, Any], on_path: frozenset[str]) -> bool:
        """An answer the respondent gave to an item a backward edit has since
        taken off the path (D12: mask, never evict). ``_asked`` is what
        separates it from an outcome codeInit or a codeBlock set on an item
        nobody asked, which reads through wherever the item is."""
        return bool(item.get("_asked")) and item["id"] not in on_path

    def _on_path(self) -> frozenset[str]:
        return frozenset(self.state.get_history())

    def _unanswered(
        self, operands: frozenset[str], item_id: str | None, on_path: frozenset[str]
    ) -> frozenset[str]:
        """The *operands* the respondent was shown and left without an answer.

        Being presented is what separates the two ways an outcome is None: an
        item its own gate kept out was never meant to be answered, and gating
        on its None is the sanctioned pattern (#559's BRFSS pregnancy item),
        while a presented item's None is unknown. The condition's own item is
        excluded: its postcondition is validating the answer being given now,
        which the state does not hold yet.

        *on_path* is the caller's: ``process_item`` passes history plus the item
        it is processing, which joins history only after its codeBlock's marks
        are computed — an item answered without being presented (an API
        submission) is still the one answered now.
        """
        return frozenset(
            name
            for name in operands
            if name != item_id
            and (item := self.state.get_item(name))
            and self._presented(item, on_path)
            and item.get("outcome") is None
        )

    def _record_orphan_reads(
        self,
        operands: frozenset[str],
        item_id: str | None,
        condition_type: str,
        on_path: frozenset[str],
    ) -> None:
        """Record a condition that read an orphaned answer as None (#1022).

        ``informational``: the engine did what the instrument asks — an answer
        off the current path is not the respondent's answer to this path — but
        the survey record should say a collected answer was set aside, rather
        than leave it to be inferred from an absence. An orphan holding None
        (left blank, or evicted from a capped Group) set nothing aside, so it
        is masked like any other but not recorded."""
        if not item_id:
            return
        orphans = sorted(
            name
            for name in operands
            if name != item_id
            and (item := self.state.get_item(name))
            and self._orphaned(item, on_path)
            and item.get("outcome") is not None
        )
        if orphans:
            self.state.add_warning(
                item_id,
                f"{condition_type}_orphaned_answer",
                f"{condition_type.capitalize()} read {', '.join(orphans)} as never asked: "
                f"the answer given is off the current path after a backward edit.",
                severity="informational",
            )

    def _unknown_variables(
        self, names: frozenset[str], marks: Iterable[str] | None
    ) -> frozenset[str]:
        """The *names* among *marks* (default: the current state's) — the
        variables computed from an unanswered item."""
        if marks is None:
            marks = self.state.tail_state()["unknown"]
        return frozenset(names).intersection(marks)

    def _evaluate_three_valued(
        self,
        node: _Leaf | _Junction,
        unanswered: frozenset[str],
        context_of: Callable[[], dict[str, Any]],
        after_unknown: bool = False,
    ) -> bool | object:
        """Kleene evaluation of a parsed condition: a leaf reading an
        unanswered item is ``_UNKNOWN``; ``or`` is settled by any True part and
        ``and`` by any False part, left to right as Python would, so an
        answered part still decides the gate whenever it can.

        ``after_unknown`` marks a part reached only because an earlier sibling
        (here or in an enclosing junction) was undecided. Python would have
        short-circuited before it — ``q_a.outcome == 1 and q_c.outcome > 3``
        never reads ``q_c`` when ``q_a`` is None — so such a part raising is
        undecided too, not an unevaluatable condition: that would record the
        postcondition kind ``critical`` and exclude the survey from datasets."""
        if isinstance(node, _Leaf):
            if (node.operands | node.variables) & unanswered:
                return _UNKNOWN
            try:
                return bool(self.python_runner.eval_expr(expr=node.source, **context_of()))
            except Exception:
                if after_unknown:
                    return _UNKNOWN
                raise
        if node.op == "not":
            value = self._evaluate_three_valued(
                node.parts[0], unanswered, context_of, after_unknown
            )
            return value if value is _UNKNOWN else not value
        settles = node.op == "or"
        unknown = False
        for part in node.parts:
            value = self._evaluate_three_valued(
                part, unanswered, context_of, after_unknown or unknown
            )
            if value is _UNKNOWN:
                unknown = True
            elif value is settles:
                return settles
        return _UNKNOWN if unknown else not settles

    def _undecided(
        self,
        condition_type: str,
        item_id: str | None,
        *,
        warning_type: str,
        reason: str,
        severity: str,
    ) -> bool:
        """Record a condition the engine could not decide and return the
        policy's fail value for its kind.

        Sets ``_last_gate_undecided``, which is what keeps capped-Group eviction
        from deleting a collected answer on a gate that decided nothing. Logs
        once per record: an undecided gate is re-checked on every navigation
        step, and the record's ``count`` already carries the repeats.
        """
        self._last_gate_undecided = True
        fail_value = _UNEVALUATABLE_CONDITION_POLICY[condition_type][0]
        consequence = (
            "Treating it as satisfied (the answer is accepted unchecked)."
            if fail_value
            else "Treating it as unsatisfied (the gated item is skipped)."
        )
        message = f"{reason} {consequence}"
        first = (
            self.state.add_warning(item_id, warning_type, message, severity=severity)
            if item_id
            else True
        )
        self.logger.log(logging.WARNING if first else logging.DEBUG, message)
        return fail_value

    def _execute_code_block(
        self, code_block: str, context: dict[str, Any], item_id: str = None
    ) -> dict[str, Any]:
        """
        Execute a code block in the given context and return the updated context.

        Args:
            code_block: Python code to execute
            context: Variables and item proxies available for execution
            item_id: Optional item ID for warning collection

        Returns:
            Updated context dictionary. When the block raises part-way through,
            returns the partial environment (R15: the flow continues, the
            assignments that completed stay); when the block is refused as
            unsafe, nothing ran, so the original context is returned. Either
            way the degradation is recorded in QMLState as `critical`.
        """
        if not code_block:
            return context  # No code block means no changes to context

        try:
            # Execute code and get the updated context
            result = self.python_runner.run_code(code=code_block, **context)
            return result
        except CodeExecutionError as e:
            # The block ran part-way. `critical`, not `degraded`: every value
            # derived downstream from a half-built variable state may be wrong,
            # which is a different claim than "an answer was kept that a gate
            # would have rejected". This is the severity that excludes the
            # survey from dataset construction (R16).
            warning_msg = (
                f"Error executing code block: {e}. "
                f"Variables assigned before the failure are kept; downstream state may be wrong."
            )
            self.logger.warning(warning_msg)

            if item_id:
                self.state.add_warning(item_id, "codeblock", warning_msg, severity="critical")

            return e.local_env
        except Exception as e:
            # validate_code refused the block (AST-unsafe), so nothing executed
            # and no variable the block was supposed to set exists downstream.
            warning_msg = f"Error executing code block: {e}. Context unchanged."
            self.logger.warning(warning_msg)

            if item_id:
                self.state.add_warning(item_id, "codeblock", warning_msg, severity="critical")

            return context

    def _initialize_questionnaire(self, questionnaire_state: QMLState) -> None:
        """
        Initialize questionnaire state and build topology.
        This should only be called once when first loading a questionnaire.

        Args:
            questionnaire_state: The questionnaire state object
        """
        # Topological order is always available (cycle members linearized in file order)
        questionnaire_state.set_navigation_path(self.topology.topological_order)
        self.logger.info(f"Stored navigation path ({len(self.topology.topological_order)} items)")

        # Check for cycles
        if self.topology.has_cycles:
            cycles_str = ", ".join([" -> ".join(cycle) for cycle in self.topology.cycles])
            self.logger.warning(f"Questionnaire has cycles: {cycles_str}")

        # Create initial context with item proxies
        init_context = {}

        all_items = questionnaire_state.get_all_items()

        # Create ItemProxy for each item in the context (roster items get the
        # dict-shaped `outcomes` accessor when their block has any persisted
        # roster_outcomes — typically empty during init).
        on_path = self._on_path()
        for item in all_items:
            item_proxy = self._build_item_proxy(item, on_path)
            init_context[item["id"]] = item_proxy

        # Execute questionnaire initialization code block. Pass the reserved
        # "codeInit" id (never a real item — RESERVED_ITEM_IDS) so a block that
        # raises here records a `critical` warning through _execute_code_block's
        # `if item_id:` guard; without an id the failure would continue the flow
        # silently and the survey would escape the critical-warning dataset
        # exclusion (R16) — the exact gap the item-level codeblock repair closed.
        init_context = self._execute_code_block(
            questionnaire_state.get_code_init(), init_context, item_id="codeInit"
        )

        # update the outcomes of all the items from the init context
        for item in all_items:
            item_proxy = init_context[item["id"]]
            # Convert the simplified outcome back to the storage format
            item["outcome"] = item_proxy.to_outcome()
            # Ensure visited field is always present
            item["visited"] = False

        # codeInit's variables are the state the first history entry derives
        # from. Its print() capture is not a variable.
        init_context.pop("__output__", None)
        questionnaire_state["init_variables"] = self._variables_of(init_context)

    @staticmethod
    def _variables_of(context: dict[str, Any]) -> dict[str, Any]:
        """The variables in an execution context — everything but the item proxies."""
        return {k: v for k, v in context.items() if not isinstance(v, ItemProxy)}

    def _evaluation_context(self, all_items: list[dict[str, Any]]) -> dict[str, Any]:
        """The current state's variables plus a proxy per item — what a gate,
        or a Roster's ``iterateOver``, is evaluated in when the walk reaches it."""
        context = copy.deepcopy(self.state.tail_state()["vars"])
        on_path = self._on_path()
        for item in all_items:
            context[item["id"]] = self._build_item_proxy(item, on_path)
        return context

    def _build_item_proxy(self, item: dict[str, Any], on_path: frozenset[str]) -> ItemProxy:
        """
        Construct an ItemProxy, threading roster outcomes through if applicable.

        For items that belong to a Roster (`_roster_block_id` tag set by U1
        loader), pass the per-iteration outcomes dict for the block so the proxy
        can expose the dict-shaped `outcomes` attribute used by outside-roster
        reads (e.g. `q_satisfaction.outcomes[4]` from a post-roster codeBlock).
        Inner-roster reads of `q.outcome` (singular) work via the snapshot/restore
        layer below — `item['outcome']` is set to the current iteration's value
        before any precondition or codeBlock runs.

        With *on_path* (the ids in history), an orphaned answer reads as None
        (D12, #1022): off the path it is not an answer to this path, yet it
        stays in the state for a gate that flips back. Required, so no caller
        can build an unmasked context by omission.
        """
        if self._orphaned(item, on_path):
            masked = {**item, "outcome": None}
            if item.get("_roster_block_id"):
                return ItemProxy(masked, roster_outcomes_for_block={})
            return ItemProxy(masked)
        block_id = item.get("_roster_block_id")
        if block_id:
            roster_block = self.state.get("roster_outcomes", {}).get(block_id, {})
            return ItemProxy(item, roster_outcomes_for_block=roster_block)
        return ItemProxy(item)

    def _decorate_with_roster_progress(self, item: dict[str, Any]) -> dict[str, Any]:
        """
        Attach current-iteration metadata to a roster item before returning it
        to a caller (MCP `get_survey_current_item`, HTTP flow blueprint).

        Adds three fields when the item belongs to a roster:
          - `_roster_current_key`: the bit-value label key for the active iteration
          - `_roster_current_label`: the human-readable label from `_roster_labels`
          - `_roster_iteration_index`: 1-based ordinal among active keys
          - `_roster_iteration_count`: total active iterations for this pass

        Non-roster items are returned unchanged. Mutates `item` in place and
        returns it for call-site ergonomics.

        These fields are advisory — they let a UI render "Breakfast (1 of 2)"
        without the client re-fetching `roster_active_keys` from state. Not
        stored in the DB (items never serialize the runtime state again after
        the caller receives them); the authoritative roster state is still
        `state['roster_iter']` / `state['roster_active_keys']`.
        """
        block_id = item.get("_roster_block_id")
        if not block_id:
            return item
        iter_key = self.state.get_current_roster_iter(block_id)
        if iter_key is None:
            return item
        active_keys = self.state.get_roster_active_keys(block_id) or []
        # Coerce label keys to int for lookup (JSON roundtrip turns them into
        # strings — same reason the _enter_roster_pass coercion exists).
        raw_labels = item.get("_roster_labels", {})
        labels = {int(k): v for k, v in raw_labels.items()}
        item["_roster_current_key"] = iter_key
        # Dynamic subject (F-001): when the block declares subjectFrom, the
        # iteration's display label is the respondent's answer to that inner
        # item; it falls back to the static label until that item is answered.
        item["_roster_current_label"] = self._resolve_roster_subject(
            block_id, iter_key, item.get("_roster_subject_from"), labels.get(iter_key)
        )
        try:
            item["_roster_iteration_index"] = active_keys.index(iter_key) + 1
        except ValueError:
            # iter_key should always be in active_keys — defensive guard for
            # state corruption (e.g., a codeBlock mutated active_keys directly).
            item["_roster_iteration_index"] = None
        item["_roster_iteration_count"] = len(active_keys)
        return item

    def _resolve_roster_subject(
        self, block_id: str, iter_key: int, subject_from: str | None, static_label: Any
    ) -> Any:
        """The iteration's display subject (F-001).

        When the Roster block declares ``subjectFrom``, return the respondent's
        stored answer to that inner item for the current iteration (e.g. the name
        they typed), falling back to the static label until it is answered.
        Tries both int and str ``iter_key`` — roster_outcomes keys arrive as
        strings after a JSONB roundtrip, the same reason the label lookup does.
        """
        if not subject_from:
            return static_label
        block_outcomes = self.state.get("roster_outcomes", {}).get(block_id, {})
        iter_outcomes = block_outcomes.get(iter_key) or block_outcomes.get(str(iter_key)) or {}
        value = iter_outcomes.get(subject_from)
        return str(value) if value not in (None, "") else static_label

    def _restore_roster_outcomes_for_iter(self, block_id: str, iter_key: int) -> None:
        """
        Restore item['outcome'] for every roster item in a block to its stored
        value for `iter_key` (or None if the iteration hasn't been visited yet).

        Called at roster entry, on iter advancement, and on backward-navigation
        re-entry. Together with the snapshot in `_snapshot_roster_outcomes`, this
        keeps the canonical `process_item` flow oblivious to roster semantics —
        it always sees a single coherent outcome per item.
        """
        iter_outcomes = self.state.get_roster_outcomes_for_iter(block_id, iter_key)
        for roster_item in self.state.get_items_by_block(block_id):
            item_id = roster_item["id"]
            canonical = iter_outcomes.get(item_id)
            if canonical is None:
                roster_item["outcome"] = None
            else:
                # Wrap canonical → storage via the ItemProxy roundtrip.
                proxy = ItemProxy(roster_item)
                proxy.outcome = canonical
                roster_item["outcome"] = proxy.to_outcome()

    def _snapshot_roster_outcomes(self, block_id: str, iter_key: int) -> None:
        """
        Capture every roster item's current outcome into roster_outcomes for the
        given iter_key. Called after process_item to persist the user's response
        AND any sibling items mutated by the codeBlock.
        """
        for roster_item in self.state.get_items_by_block(block_id):
            storage = roster_item.get("outcome")
            if storage is None:
                # Skip empty cells — get_roster_outcomes_for_item drops them anyway.
                continue
            proxy = ItemProxy(roster_item)
            self.state.set_roster_outcome(block_id, iter_key, roster_item["id"], proxy.outcome)

    def _enter_roster_pass(
        self, item: dict[str, Any], all_items: list[dict[str, Any]]
    ) -> list[int] | None:
        """
        Evaluate iterateOver, freeze active_keys, and prime the roster pass.

        Returns the active_keys list if the pass is entered (possibly with
        zero iterations to traverse if mask=0), or None if iterateOver
        evaluation hit an unrecoverable error (a warning is logged in that
        case and the caller should mark all roster items visited so the
        navigation walk skips past them).

        Implements the "iterateOver evaluated exactly once per roster entry,
        not between iterations" invariant from the plan: result is frozen in
        `state['roster_active_keys'][block_id]` for the duration of the pass.
        """
        block_id = item["_roster_block_id"]
        iterate_over_expr = item.get("_roster_iterate_over", "")

        # Coerce label keys to int. They arrive as ints in-memory (from the QML
        # loader) but after a DB roundtrip they come back as strings because
        # JSON object keys are always strings. Coercing here keeps the rest of
        # the method (mask & k, sorted(...)) working with native ints.
        raw_labels = item.get("_roster_labels", {})
        labels = {int(k): v for k, v in raw_labels.items()}

        # Evaluate iterateOver in the current state (with all ItemProxies bound).
        eval_context = self._evaluation_context(all_items)

        try:
            # Use eval_value (raw) — eval_expr applies bool() coercion which would
            # turn a perfectly good int-bitmask like 7 into True.
            mask = self.python_runner.eval_value(expr=iterate_over_expr, **eval_context)
        except Exception as e:
            warning = (
                f"iterateOver expression {iterate_over_expr!r} raised: {e}; skipping roster pass."
            )
            self.logger.warning(warning)
            self.state.add_warning(
                item["id"], "roster_iterate_over", warning, severity="informational"
            )
            return None

        if not isinstance(mask, int) or isinstance(mask, bool) or mask < 0:
            warning = (
                f"iterateOver expression {iterate_over_expr!r} resolved to {mask!r} "
                f"(must be a non-negative int); skipping roster pass."
            )
            self.logger.warning(warning)
            self.state.add_warning(
                item["id"], "roster_iterate_over", warning, severity="informational"
            )
            return None

        # Walk set bits low-to-high, intersect with declared labels. A bit set
        # in the mask with no declared label is still ignored for traversal —
        # there is no label to iterate under — but it is recorded, because the
        # difference between "the author declared two subjects" and "the
        # respondent's answer asked for three" is invisible otherwise.
        active_keys = sorted(k for k in labels.keys() if mask & k)
        undeclared = sorted(bit for bit in _set_bits(mask) if bit not in labels)
        if undeclared:
            warning = (
                f"iterateOver mask {mask} sets bit(s) {undeclared} with no declared label; "
                f"those iterations are not traversed."
            )
            self.logger.warning(warning)
            # `informational`: no answer was accepted or rejected — the pass
            # simply covers fewer subjects than the mask asked for.
            self.state.add_warning(
                item["id"], "roster_mask_undeclared", warning, severity="informational"
            )

        self.state.set_roster_active_keys(block_id, active_keys)

        if active_keys:
            self.state.set_current_roster_iter(block_id, active_keys[0])
            self._restore_roster_outcomes_for_iter(block_id, active_keys[0])
            # Mark all roster items unvisited so the navigation walk picks them up.
            for ri in self.state.get_items_by_block(block_id):
                ri["visited"] = False

        return active_keys

    @staticmethod
    def _resolve_cap(n: Any) -> int:
        """Coerce a Group ``count`` cap to a usable slot count.

        Returns ``n`` when it is a positive int, else ``0``. The loader
        loud-validates ``count`` as a positive int, so this is defence in
        depth for the on-reach draw (``_group_reach_decision`` /
        ``is_item_done``): a malformed / absent cap degrades to a 0-slot draw
        rather than crashing the walk.
        """
        return n if isinstance(n, int) and n > 0 else 0

    def _effective_conditions(self, item: dict[str, Any], field: str) -> list[dict[str, Any]]:
        """Compose block-level and item-level conditions for evaluation.

        Since R25 (2026-05-14) the loader no longer prepends block
        pre/postconditions onto items. Consumers that need the merged
        view assemble it at evaluation time: block conditions take effect
        BEFORE item conditions, mirroring the historical merge order.

        ``field`` is either ``'precondition'`` or ``'postcondition'``.
        Returns an empty list when neither scope declares anything.
        """
        block_id = item.get("blockId")
        block = self.state.get_block(block_id) if block_id else None
        block_conds: list[dict[str, Any]] = list(block.get(field) or []) if block else []
        item_conds: list[dict[str, Any]] = list(item.get(field) or [])
        return block_conds + item_conds

    def _enter_group_pass(self, item: dict[str, Any]) -> None:
        """Open a fresh ``count``-capped Group pass: reset the running asked-list
        to empty so the on-reach walk can fill it slot-by-slot.

        The draw is NOT frozen at entry. The forward walk
        (``_group_reach_decision``) evaluates each member's precondition *when it
        reaches the member in navigation_path order* and consumes one of the N
        slots per asked member. This is the only correct model when a member's
        precondition depends on a cross-block (outer) item that sorts BETWEEN
        the Group's members in stable-Kahn order: such a member is ineligible at
        first block entry but becomes eligible once the walk has run the outer
        item (every dependency precedes the member in navigation_path).

        ``group_asked`` therefore becomes the RUNNING list of members the group
        has actually asked this pass (not a precomputed frozen draw). It starts
        empty here and persists for the duration of the pass — across foreign
        items that interleave the block and across backward navigation within
        the block — so the slot count survives. It is reset only on a fresh
        entry (this method) and cleared on pass completion / backward exit.
        """
        block_id = item["_group_block_id"]
        self.state.set_group_asked(block_id, [])

    def _group_reach_decision(
        self, item: dict[str, Any], all_items: list[dict[str, Any]]
    ) -> bool:
        """On-reach decision for one capped-Group member the forward walk has
        reached. Returns True if the member should be PRESENTED now, False if it
        is skipped (free pass on a False precondition, or beyond the N cap).

        Model (R8 / AE2–AE4): a member already in the running asked-list is
        re-presented (drawn-and-unvisited). Otherwise evaluate eligibility:

          * precondition holds AND ``len(group_asked) < count`` → ASK: consume
            one slot (append to ``group_asked``), tag the item ``_group_asked``
            (the durable "the group asked this") and return True;
          * precondition False → free pass (no slot), return False;
          * cap already full → skip, return False.

        Eviction (A1-scoped, AE13): when a member is skipped (False precondition
        or cap full) but was asked in a prior pass — its durable ``_group_asked``
        tag is set and it still carries an ``outcome`` — its answer must be
        dropped (a backward edit flipped a precondition or pushed it past the
        cap). ``_evict_group_item`` clears the outcome and removes its history
        entry. A member the group NEVER asked (e.g. a ``codeInit``-set outcome on
        an undrawn member — A1) has no ``_group_asked`` tag, so it is never
        evicted. A benign re-entry re-asks the identical set, so no member is
        skipped-after-having-been-asked and nothing is evicted (AE19).
        """
        block_id = item["_group_block_id"]
        n = item.get("_group_count")
        asked = self.state.get_group_asked(block_id)
        item_id = item["id"]

        if item_id in asked:
            return True  # already asked this pass → re-present (drawn+unvisited)

        cap = self._resolve_cap(n)
        eligible = self._check_preconditions(item, all_items)
        if eligible and len(asked) < cap:
            # ASK: consume a slot and tag the item as group-asked (durable).
            self.state.set_group_asked(block_id, [*asked, item_id])
            item["_group_asked"] = True
            return True

        # Skipped (free pass or cap full). Evict iff the group previously asked
        # this member and it still carries an answer — A1: only group-asked items
        # may be cleared; codeInit/codeBlock-set outcomes on never-asked members
        # survive.
        #
        # A skip forced by an UNDECIDED gate never evicts. Eviction exists for a
        # gate that decided against the member — the respondent changed an
        # upstream answer and the instrument no longer wants this question — and
        # it deletes a collected answer, its history entry and its timing events.
        # A gate that raised, or that could not be decided because an item it
        # reads was left unanswered, decided nothing, so destroying data on the
        # strength of it would turn "the engine could not tell" into "the
        # respondent never answered". Skipping the member is still right: it is
        # what the gate asked for, and it is recoverable. Deleting the answer is
        # not.
        if not self._last_gate_undecided and item.get("_group_asked") and item.get("outcome") is not None:
            self._evict_group_item(item)
        return False

    def _evict_group_item(self, item: dict[str, Any]) -> None:
        """Remove a previously-asked capped-Group item from the survey record
        because a flipped precondition (or a now-consumed earlier slot) dropped
        it from the on-reach draw.

        The analysis extractor (``survey_extractor.extract_survey_outcomes``)
        walks ``state['history']`` and emits any item whose ``outcome`` is not
        None, so a stale outcome left on an evicted item would leak into the
        Bronze dataset. Every surface that carries the answer is reset:

          * ``item['outcome']`` → None (the value), and the item un-visited so
            the forward walk does not treat it as already shown;
          * the durable ``_group_asked`` tag cleared — the group no longer owns
            this answer, so a later sweep must not re-evict an already-clean item
            — and ``_asked`` with it: there is no answer left to mask (#1022);
          * the item's ``history`` entry (and its lockstep
            ``history_iter_key``) removed so the extractor never reaches it;
          * the item's ``response_timing`` events removed — the answer is gone,
            so its timing must go too, or a re-draw of the same item would
            double-count the evicted attempt's duration in visit totals and in
            the per-answer durations Bronze carries;
          * the item's ``external_provenance`` marker removed, or the next
            answer the respondent gives on a re-draw would read as prefilled.

        A capped-Group item has no per-iteration identity (iter_key is always
        None), so every history occurrence of this item id is removed.
        """
        item_id = item["id"]
        item["outcome"] = None
        item["visited"] = False
        item.pop("_group_asked", None)
        item.pop("_asked", None)
        self.state.drop_timing_events_for_item(item_id)
        self.state.clear_external_provenance(item_id)

        # Drop the item's history entry/entries (R9 — the extractor walks
        # history, so nulling outcome alone would still be insufficient if the
        # entry remained). Later entries keep the variables they were derived
        # with, the evicted member's codeBlock output included.
        self.state.remove_history_entries(item_id)

    def _check_preconditions(self, item: dict[str, Any], all_items: list[dict[str, Any]]) -> bool:
        """
        Check if item's preconditions are satisfied.

        Block-level preconditions (declared on the item's enclosing block)
        evaluate BEFORE the item's own preconditions — same effective
        semantics as the pre-R25 loader merge. An item is shown only if
        ALL preconditions (block + item) evaluate to True.

        Returns:
            True if all preconditions are satisfied, or none exist.
            False if any precondition evaluates to False, or cannot be
            evaluated at all (unrecognized Python, missing variables, a
            comparison against an unasked item's ``None`` outcome).

            An unevaluatable gate skips the item and records a ``degraded``
            warning: a gate that cannot be checked is honoured, not ignored,
            because ignoring it administers an item the instrument restricted.
            See ``_UNEVALUATABLE_CONDITION_POLICY``.

            Sets ``_last_gate_undecided`` for the duration of this call, so a
            caller that acts DESTRUCTIVELY on a False can tell "the gate said
            no" from "the gate decided nothing" — it raised, or an item it
            reads was left unanswered (#1023). Only
            ``_group_reach_decision`` reads it, immediately after its own call;
            it is reset on entry here and is meaningless at any other moment.
        """
        self._last_gate_undecided = False

        effective = self._effective_conditions(item, "precondition")
        if not effective:
            return True  # No preconditions

        # The current state plus a proxy per item, built on first use: a gate
        # left undecided by an unanswered item evaluates nothing and needs none.
        # The current state is the last history entry's — the items that
        # actually ran — whichever item the gate belongs to (#1021).
        context: dict[str, Any] | None = None

        def context_of() -> dict[str, Any]:
            nonlocal context
            if context is None:
                context = self._evaluation_context(all_items)
            return context

        # Evaluate all preconditions - ALL must be satisfied
        item_id = item.get("id")
        for condition in effective:
            if not self._evaluate_condition(
                condition.get("predicate", ""),
                context_of,
                item_id=item_id,
                condition_type="precondition",
            ):
                return False

        return True

    def get_current_item(
        self, questionnaire_state: QMLState, backward: bool = False
    ) -> dict[str, Any] | None:
        """
        Get the current item based on preconditions and navigation history.

        Forward navigation strategy:
        1. Iterates through pre-computed navigation path (topological order)
        2. Skips visited items if unvisited items remain ahead
        3. Evaluates preconditions dynamically via Python expressions (NOT Z3)
        4. Items with unsatisfied preconditions are skipped (not shown to user)
        5. Returns first item with satisfied preconditions
        6. Tracks item in navigation history for backward navigation

        Backward navigation strategy:
        1. Pops current item from navigation history
        2. Marks current item as unvisited
        3. Returns to previous item from history stack

        Args:
            questionnaire_state: Current questionnaire state
            backward: Whether to navigate backward

        Returns:
            Item data dict or None if survey is complete
        """
        if not questionnaire_state.get_navigation_path():
            self.logger.error(
                "Navigation path not initialized. Call initialize_questionnaire first."
            )
            return None

        all_items = questionnaire_state.get_all_items()

        # Handle backward navigation
        if backward:
            return self._backward_navigate(questionnaire_state, all_items)

        # Forward navigation - use stored navigation path.
        # For Roster items the path entry is visited once *per active iteration*;
        # the visited flag is reset between iterations (see process_item's iter
        # advancement) so the same path entry serves multiple presentations.
        navigation_path = questionnaire_state.get_navigation_path()

        def is_item_visited(item):
            """Check if an item has been visited by the user.

            Note: We only check the visited flag, NOT outcome values.
            Items may have non-empty outcomes from default values in QML,
            but they're not "visited" until the user has actually seen them.
            """
            if not item:
                return True  # Missing items don't block completion
            return item.get("visited", False)

        def is_item_done(item):
            """Check if an item is done: either visited, in an empty roster pass,
            or has unsatisfied preconditions.

            Items in a Roster whose pass was determined empty (active_keys=[])
            are implicitly done — we recorded the empty pass but never showed them.
            Items with unsatisfied preconditions are implicitly skipped.
            """
            if not item:
                return True
            if item.get("visited"):
                return True
            block_id = item.get("_roster_block_id")
            if block_id is not None:
                active_keys = questionnaire_state.get_roster_active_keys(block_id)
                if active_keys is not None and len(active_keys) == 0:
                    return True  # empty pass already established
            # Capped-Group items (on-reach model): a member is "done" only once
            # the forward walk has REACHED and DECIDED it — either asked (and
            # then visited, caught above) or skipped (free pass on a False
            # precondition, or beyond the N cap). The decision is NOT frozen at
            # entry: a member is presentable iff its precondition holds AND a
            # slot is still free in the running asked-list. We mirror that here
            # WITHOUT mutating state (no eviction in the terminator):
            #   - in the running asked-list → drawn, still pending → NOT done;
            #   - currently presentable (precond true AND slot free) → NOT done;
            #   - otherwise (free pass / cap full) → settled-skipped → done.
            # An un-reached member whose precondition will only flip true after a
            # later-running outer item is, right now, NOT presentable and would
            # read "done" here — but the all-done terminator requires EVERY item
            # done, and the outer item it depends on is itself still unvisited
            # (so all_done is False) until that item runs and flips the member
            # presentable. Hence no premature finalization (the C1 guarantee).
            group_block_id = item.get("_group_block_id")
            if group_block_id is not None:
                if not questionnaire_state.has_group_pass(group_block_id):
                    return False  # pass not entered yet → must enter it
                asked = questionnaire_state.get_group_asked(group_block_id)
                if item.get("id") in asked:
                    return False  # asked + unvisited → still pending
                n = item.get("_group_count")
                cap = self._resolve_cap(n)
                presentable = len(asked) < cap and self._check_preconditions(item, all_items)
                return not presentable  # free pass / cap full → settled-skipped
            # Item with unsatisfied preconditions is implicitly done (skipped)
            if not self._check_preconditions(item, all_items):
                return True
            return False

        # Check if all items are already done (survey complete)
        # In this case, return the last item rather than looping
        all_done = all(
            is_item_done(questionnaire_state.get_item(item_id)) for item_id in navigation_path
        )

        if all_done:
            # All items done - return last visited item with isLast flag
            for item_id in reversed(navigation_path):
                item = questionnaire_state.get_item(item_id)
                if item and item.get("visited"):
                    item["isLast"] = True
                    return self._decorate_with_roster_progress(item)
            return None

        # Navigate using the pre-computed path - find next item that needs attention
        for item_id in navigation_path:
            item = questionnaire_state.get_item(item_id)
            if not item:
                continue

            # Skip items already visited
            if is_item_visited(item):
                continue

            # Roster items have an extra preflight: enter the pass on first
            # encounter (eval iterateOver, freeze active_keys, snapshot-restore).
            # If the pass turns out to be empty (mask=0 or no overlapping bits)
            # we record `active_keys=[]` as the sentinel and skip silently —
            # critically WITHOUT marking inner items visited, since they were
            # never shown to the respondent (preserves the survey's "last item
            # actually visited" recap behavior).
            if item.get("_roster_block_id"):
                block_id = item["_roster_block_id"]
                if questionnaire_state.get_roster_active_keys(block_id) is None:
                    active_keys = self._enter_roster_pass(item, all_items)
                    if active_keys is None:
                        # Eval error: record as empty pass and skip.
                        questionnaire_state.set_roster_active_keys(block_id, [])
                        active_keys = []
                if not questionnaire_state.get_roster_active_keys(block_id):
                    # Empty pass — skip silently. is_item_done() below treats
                    # these as done so the all-done check still terminates.
                    continue

            # Capped-Group items (on-reach model): no frozen draw, no redirect.
            # Each member is decided WHEN THE WALK REACHES IT in navigation_path
            # order, so a member whose precondition depends on an outer item that
            # sorts between the Group's members is evaluated only after that outer
            # item has run (the C1 guarantee). On first encounter of an unvisited
            # member we open the pass (reset the running asked-list to empty);
            # then _group_reach_decision either ASKS this member (consuming a
            # slot, recording it in group_asked, tagging it _group_asked) or
            # skips it (free pass on a False precondition, or beyond the N cap —
            # evicting any prior answer it carried). A skipped member is left
            # absent (outcome=None, not visited) and the walk continues; it is
            # never force-visited. Because the member is visited in
            # navigation_path order, the user sees the block in its global
            # sequence with no projection helper.
            if item.get("_group_block_id"):
                gblock_id = item["_group_block_id"]
                if not questionnaire_state.has_group_pass(gblock_id):
                    self._enter_group_pass(item)
                if not self._group_reach_decision(item, all_items):
                    # Free pass / cap full — skip this member silently.
                    continue
                # Asked this pass: fall through to the normal presentation path
                # (history append, return). _group_reach_decision already
                # evaluated this member's precondition (it asked it), so the
                # redundant precondition gate below is skipped for group items
                # via the `elif not item.get("_group_block_id")` guard — each
                # _check_preconditions does a deepcopy + per-item proxy build.

            # Check preconditions — items with unsatisfied preconditions are
            # skipped. A group member reaching here was already gated by
            # _group_reach_decision (precondition known true), so re-checking it
            # is pure redundant work; present it directly.
            if item.get("_group_block_id"):
                presentable = True
            else:
                presentable = self._check_preconditions(item, all_items)
            if presentable:
                # Track navigation in questionnaire state. Roster items legitimately
                # appear multiple times in history (once per iteration), so the
                # non-roster uniqueness check (`item_id not in history`) would drop
                # them. Instead, dedup on the (item_id, iter_key) pair against the
                # *last* history entry — that blocks the repeated push caused by
                # idempotent get_current_item calls within a single turn without
                # preventing legitimate cross-iteration re-entries.
                iter_key = None
                block_id = item.get("_roster_block_id")
                if block_id:
                    iter_key = questionnaire_state.get_current_roster_iter(block_id)

                history = questionnaire_state.get_history()
                history_keys = questionnaire_state.get("history_iter_key", [])
                last_entry = (history[-1], history_keys[-1]) if history else (None, None)
                if last_entry != (item_id, iter_key):
                    # Non-roster items also get a stricter "not anywhere in history"
                    # check — they must appear at most once, period.
                    if item.get("_roster_block_id") or item_id not in history:
                        questionnaire_state.add_to_history(item_id, iter_key=iter_key)
                # Defensively clear any stale isLast flag — once we're handing back
                # an item from the active forward walk it is, by definition, not
                # the survey-complete recap. The flag is only set in the all_done
                # / end-of-path branches above.
                item.pop("isLast", None)
                return self._decorate_with_roster_progress(item)
            # else: precondition not satisfied — skip silently

        # Return last visited item if no more items
        visited_items = [item for item in all_items if item.get("visited")]
        if visited_items:
            last_item = visited_items[-1]
            last_item["isLast"] = True
            return self._decorate_with_roster_progress(last_item)

        return None

    def process_item(
        self,
        questionnaire_state: QMLState,
        item_id: str,
        outcome: Any,
        *,
        source: str,
        channel: str | None = None,
        skip_postcondition: bool = False,
    ) -> dict[str, Any]:
        """
        Process an item with the given outcome and return the updated context.
        Updates the item's outcome and context in the questionnaire state.

        This is also the submission seam of the response-timing log (R7): the
        answer's timing event is opened here (a no-op when a presentation seam
        already opened it, so the respondent's own clock is preserved) and
        closed once the answer is accepted. Keeping both halves here is what
        gives every driver — the survey runtime, the API, the mass-fill job,
        the external-input prefill — a timed answer from one insertion point.

        Args:
            questionnaire_state: The questionnaire state object
            item_id: The ID of the item to process
            outcome: The outcome value for the item
            source: What produced this answer (R9), one of
                ``askalot_qml.models.qml_state.TIMING_SOURCES``. Required and
                keyword-only: only the caller's driver knows whether a person,
                an API client, or a fill job supplied the value, and a default
                here would tag machine answers as human ones.
            channel: The surface the answer came through (``web`` / ``ai``,
                ``TIMING_CHANNELS``), or None for a driver with no presenting
                surface. Used only when this call opens the event itself — an
                event a presentation seam opened keeps that seam's channel.
            skip_postcondition: If True, skip postcondition validation.
                Used for backward navigation where:
                - The item keeps the visited flag it had: Back unmarks it when
                  it leaves, and on the first item, which Back cannot leave, an
                  unvalidated answer must not count as answered
                - The saved answer is just for convenience (restored when user returns)
                - Real validation happens when user leaves the item going forward
                It is also what makes the timing event UNCOMMITTED (KTD4): the
                time was genuinely spent, but a convenience save is not an
                answer attempt.

        Returns:
            Dictionary with success status and optional error message or output
        """
        all_items = questionnaire_state.get_all_items()

        # Find the item in the questionnaire state
        current_item = questionnaire_state.get_item(item_id)
        if not current_item:
            warning_msg = f"Item {item_id} not found in questionnaire state"
            self.logger.error(warning_msg)
            # `degraded`: a caller submitted an answer the engine had nowhere to
            # put. Nothing wrong was accepted, but a respondent's answer was
            # dropped, and a survey that hits this has an id mismatch between
            # what was presented and what the state holds.
            questionnaire_state.add_warning(
                item_id, "item_missing", warning_msg, severity="degraded"
            )
            return {"success": False, "message": f"Item {item_id} not found"}

        # Resolve the timing event's iteration key BEFORE anything else: the
        # Roster post-processing below advances the block's current iteration
        # once the pass is exhausted, so a key read after that point would close
        # the event of the iteration the respondent is moving INTO.
        timing_iter_key = questionnaire_state.current_iter_key(item_id)
        was_visited = current_item.get("visited", False)
        # Idempotent: when a presentation seam already stamped this pair the
        # original moment stands. A driver with no presentation seam (the API,
        # the mass-fill job, prefill) gets its event here instead, with the
        # near-zero duration that honestly describes a machine-supplied answer.
        questionnaire_state.open_timing_event(item_id, timing_iter_key, source, channel=channel)

        # The history entry this answer belongs to. An item answered without
        # being presented (the external-input prefill, an API submission for an
        # item the walk has not reached) joins the path here: it now has an
        # answer, and its variables must reach whatever runs after it.
        entry_idx = questionnaire_state.entry_index(item_id, timing_iter_key)
        # Answering an item that later entries were built on is a backward
        # edit, whichever driver sends it (the API takes any item id): the
        # walk rewinds to it, as the stepper jump does, and the items after
        # it are re-reached against the new state. Their answers stay on the
        # items. Re-running the entry in place would leave every later state
        # derived from the abandoned answer.
        if entry_idx is not None and entry_idx < len(questionnaire_state.get_history()) - 1:
            for removed_id, _ in questionnaire_state.truncate_history(entry_idx + 1):
                removed = questionnaire_state.get_item(removed_id)
                if removed is not None:
                    removed["visited"] = False
        base = (
            questionnaire_state.state_before(entry_idx)
            if entry_idx is not None
            else questionnaire_state.tail_state()
        )

        # The state chain (#1021): this item runs on the state of the entry
        # before it, never on one a later item already built on.
        new_context = copy.deepcopy(base["vars"])

        # Fill in the new context with the ItemProxies. Roster items get the
        # dict-shaped `outcomes` attribute via _build_item_proxy so that
        # post-roster code (and any inner codeBlock that legitimately reads
        # other iterations) can resolve `q_satisfaction.outcomes[K]`.
        on_path = self._on_path() | {item_id}
        for item in all_items:
            item_proxy = self._build_item_proxy(item, on_path)
            if item["id"] == item_id:
                item_proxy.from_outcome(outcome)
            new_context[item["id"]] = item_proxy

        # Validate postcondition (unless skipped for backward navigation)
        # When navigating backward, the item will be marked unvisited and the user
        # must re-validate when leaving forward again. Block-level postconditions
        # (declared on the item's enclosing block) evaluate BEFORE the item's
        # own postconditions — same effective semantics as the pre-R25 merge.
        if not skip_postcondition:
            effective_post = self._effective_conditions(current_item, "postcondition")
            for condition in effective_post:
                if not self._evaluate_condition(
                    condition.get("predicate", ""),
                    lambda: new_context,
                    item_id=item_id,
                    condition_type="postcondition",
                    unknown=base["unknown"],
                ):
                    # Return the hint message instead of just False
                    hint = condition.get("hint", "Postcondition failed")
                    return {"success": False, "message": hint}

        # A prefill marker describes the value the item holds now, so an answer
        # that REPLACES the value drops it; the prefill seam sets it again after
        # its own answer. An unchanged value keeps it: a prefilled item sits in
        # history, so a respondent paging back through it re-submits the same
        # value (the Back button's convenience save, or Next on the unchanged
        # item), and that value is still the prefilled one.
        if outcome != current_item.get("outcome"):
            questionnaire_state.clear_external_provenance(item_id)

        # A re-run replaces this entry's earlier run, so the outcomes that run
        # wrote on other items go back first — or a branch the new answer no
        # longer takes would leave its write behind. The proxies are rebuilt
        # after the undo so the codeBlock reads the restored values.
        if (
            entry_idx is not None
            and questionnaire_state["history_state"][entry_idx]["outcome_undo"]
        ):
            questionnaire_state.undo_entry_outcomes(entry_idx)
            for item in all_items:
                if item["id"] != item_id:
                    new_context[item["id"]] = self._build_item_proxy(item, on_path)

        # Execute the code block
        code_block = current_item.get("codeBlock")
        new_context = self._execute_code_block(code_block, new_context, item_id=item_id)

        # Extract captured output if any
        output_messages = new_context.pop("__output__", [])

        # Update outcomes for all items that may have been modified in the code block
        # and mark them as visited if they now have outcomes. Every OTHER item's
        # prior value goes in the entry's undo log (the current item's is the
        # answer itself, which history truncation already governs), beside the
        # value written — an undo restores only a value nothing replaced since.
        # An orphan's proxy was built reading None, so None is its baseline:
        # the block changed it only if it wrote something else. Comparing with
        # the stored answer instead would read the mask itself as a write and
        # delete the answer the mask exists to keep.
        outcome_undo: dict[str, list[Any]] = {}
        for item in all_items:
            item_proxy = new_context[item["id"]]
            updated_outcome = item_proxy.to_outcome()
            baseline = None if self._orphaned(item, on_path) else item.get("outcome")

            # If the outcome has changed or is newly set, update it and mark as visited
            if updated_outcome != baseline:
                if item["id"] != item_id:
                    outcome_undo[item["id"]] = [
                        item.get("outcome"),
                        item.get("visited", False),
                        updated_outcome,
                    ]
                item["outcome"] = updated_outcome
                if updated_outcome is not None:
                    item["visited"] = True

        # The current item is marked as visited since it was actively processed
        # (a convenience save keeps the flag it had, see skip_postcondition),
        # and tagged as asked: its outcome is an answer, which _orphaned masks
        # once a backward edit takes it off the path.
        current_item["visited"] = was_visited if skip_postcondition else True
        current_item["_asked"] = True

        # Record the entry's new state. A mark follows the value: set on a name
        # assigned from unanswered data, cleared only on a name whose value the
        # block actually changed from clean data (#1044).
        variables = self._variables_of(new_context)
        unknown = set(base["unknown"]) & variables.keys()
        if code_block:
            marked, cleared = _unknown_after(
                code_block,
                frozenset(unknown),
                lambda name: bool(self._unanswered(frozenset((name,)), None, on_path)),
            )
            unknown |= marked & variables.keys()
            unknown -= {
                name
                for name in cleared
                if name not in base["vars"] or base["vars"][name] != variables.get(name)
            }
        if entry_idx is None:
            questionnaire_state.add_to_history(item_id, iter_key=timing_iter_key)
            entry_idx = len(questionnaire_state.get_history()) - 1
        questionnaire_state["history_state"][entry_idx] = {
            "vars": variables,
            "unknown": sorted(unknown),
            "outcome_undo": outcome_undo,
        }

        # ------------------------------------------------------------------
        # Roster post-processing: snapshot all roster items in the block
        # to roster_outcomes[block_id][iter_key], then advance iter_key if the
        # current iteration is exhausted.
        #
        # Non-roster items: clear active_keys for ALL roster blocks so the next
        # forward encounter re-evaluates iterateOver. This implements the plan's
        # "iterateOver re-evaluated only on roster ENTRY/RE-ENTRY" rule for the
        # mid-survey-mask-change case (e.g., user goes back to q_meals_eaten,
        # picks different meals, then walks the roster again with the new mask).
        # ------------------------------------------------------------------
        roster_block_id = current_item.get("_roster_block_id")
        if not roster_block_id:
            # Invalidate all cached roster passes so subsequent forward entries
            # re-evaluate iterateOver against the (potentially modified) state.
            # get_blocks_by_kind returns [] when there are no Roster blocks —
            # the loop is then a constant-time short-circuit.
            for block in questionnaire_state.get_blocks_by_kind("Roster"):
                block_id = block.get("id")
                if block_id:
                    questionnaire_state.clear_roster_iter_state(block_id)
        # NOTE: a non-Group item processed mid-survey must NOT clear an active
        # Group pass. Under the on-reach model `group_asked` is the RUNNING
        # asked-list and must survive a foreign item that interleaves the
        # block's members in navigation_path order (the non-contiguous
        # projection case) so the slot count is preserved across the foreign
        # item. Eligibility is re-evaluated per member WHEN THE WALK REACHES IT
        # (_group_reach_decision), so there is no clear-to-re-derive step on
        # non-Group items — the frozen-model teardown that lived here is gone.
        # A fresh pass is opened only by _enter_group_pass (first/forward
        # re-entry) and torn down only on pass completion (below) or backward
        # exit of the block (_backward_navigate).
        if roster_block_id:
            iter_key = questionnaire_state.get_current_roster_iter(roster_block_id)
            if iter_key is not None:
                # Snapshot the current item AND any sibling roster items the
                # codeBlock may have written through (plan: "captures both the
                # directly-processed item AND any sibling roster items whose
                # outcomes were modified by the codeBlock").
                self._snapshot_roster_outcomes(roster_block_id, iter_key)

                # Has the user (or the codeBlock) finished every still-relevant
                # roster item for this iteration? An item is "relevant" if it's
                # unvisited AND its preconditions are satisfied; one with failing
                # preconditions is implicitly skipped.
                roster_items = questionnaire_state.get_items_by_block(roster_block_id)
                any_pending = any(
                    (not ri.get("visited")) and self._check_preconditions(ri, all_items)
                    for ri in roster_items
                )
                if not any_pending:
                    # Iteration exhausted — try to advance.
                    active_keys = questionnaire_state.get_roster_active_keys(roster_block_id) or []
                    try:
                        current_idx = active_keys.index(iter_key)
                    except ValueError:
                        current_idx = -1

                    if current_idx >= 0 and current_idx + 1 < len(active_keys):
                        # Move to next active iter_key.
                        new_iter = active_keys[current_idx + 1]
                        questionnaire_state.set_current_roster_iter(roster_block_id, new_iter)
                        # Reset visited so each item can be re-presented for the
                        # new iteration; restore outcomes from any prior visit.
                        for ri in roster_items:
                            ri["visited"] = False
                        self._restore_roster_outcomes_for_iter(roster_block_id, new_iter)
                    else:
                        # All iterations done. Mark roster items permanently
                        # visited so the navigation walk advances past them, and
                        # clear pass state so a future re-entry (after backward
                        # navigation) re-evaluates iterateOver.
                        for ri in roster_items:
                            ri["visited"] = True
                        questionnaire_state.clear_roster_iter_state(roster_block_id)

        # ------------------------------------------------------------------
        # Capped-Group post-processing (on-reach model). Group members are asked
        # at most ONCE (no per-iteration repeat), so there is no snapshot/restore
        # sibling map — the item's single outcome lives on item['outcome'] via
        # the canonical flow. There is deliberately NO completion bookkeeping
        # here: a non-asked member is left absent (outcome=None, NOT visited),
        # and the pass state is NOT cleared on forward completion.
        #
        # Clearing on completion would re-open a fresh empty pass the moment the
        # forward walk reached a still-undecided member of the SAME block (the
        # cap would reset to zero, so a beyond-cap member would wrongly get a
        # slot — the C1/A1-adjacent over-ask bug). Instead the pass lingers
        # active and harmless: every asked member is visited (so never
        # re-presented), every other member is settled-skipped by the on-reach
        # terminator (is_item_done keys on has_group_pass + the running
        # asked-list), and extraction never reads group_asked. The pass is reset
        # to empty only by _enter_group_pass on a fresh forward (re-)entry, and
        # cleared only when backward navigation steps out of the block
        # (_backward_navigate). This is the on-reach analogue of relying on the
        # walk rather than force-visiting non-asked members.
        # ------------------------------------------------------------------

        # Stamp submission. Only on the success path — a postcondition failure
        # leaves the answerer sitting on the item, so its event stays open and
        # keeps accruing until the answer is actually accepted.
        questionnaire_state.close_timing_event(
            item_id, timing_iter_key, committed=not skip_postcondition
        )

        # Add output messages to the result if any
        result = {"success": True}
        if output_messages:
            result["output"] = output_messages

        return result

    @staticmethod
    def _warn_prefill_declined(
        questionnaire_state: QMLState, item_id: str, gate: str, reason: str
    ) -> None:
        """Record that a supplied external value was declined, naming the gate.

        The gate is the warning TYPE rather than prose inside the message, so a
        campaign-level rollup can separate "the instrument refused this value"
        from "the item was never going to be asked" without parsing text. The
        message carries the reason and never the value — an external value is
        respondent data (R17, and the same non-PII rule the provenance marker
        follows).
        """
        message = f"External prefill declined for {item_id}: {reason}."
        questionnaire_state.add_warning(
            item_id, f"external_prefill_{gate}", message, severity="degraded"
        )

    def apply_external_inputs(
        self,
        questionnaire_state: QMLState,
        injection_map: dict[str, Any],
        sources: dict[str, str] | None = None,
    ) -> dict[str, Any]:
        """Auto-answer `external: true` items at survey init from an injection map.

        QML External Inputs plan, U2 (R9/R10/R11/R12 write side). The service
        layer (U5) resolves each external item's value from the respondent
        record and passes ``{item_id: value}``; this method applies it through
        the normal answer path so an injected value is indistinguishable from a
        real answer downstream, apart from its provenance flag.

        For each ``external`` item, in navigation order:
          1. Skip if not eligible for prefill (not a plain Question, or it lives
             in a Roster/capped-Group block — prefill of a repeated/drawn item
             is undefined in v1; it is asked in the normal flow).
          2. Evaluate its effective precondition; skip when False — a
             precondition-false external must stay absent (running its codeBlock
             at init would corrupt downstream branching). ``process_item`` does
             NOT check the precondition, hence this explicit gate.
          3. Validate the injected value against the item's declared domain
             (``process_item`` never range-checks the outcome); skip if
             out-of-domain — the item is asked in the normal flow (AE3/R11).
          4. ``process_item(state, id, value)`` — validates the postcondition
             and runs the codeBlock. An item the walk has not presented joins
             history there (iter_key=None), so the history-keyed Bronze
             extractor (U3) emits it and its variables reach later items.
          5. On ``success=True``: set the externally-supplied provenance marker. On ``success=False`` (a
             postcondition failure) leave it unresolved — no history entry, no
             provenance — so it is asked in the flow (fail-safe, KTD5).

        Ordering: because externals are processed in navigation order and
        each one's history entry derives from the one before, an external item whose
        codeBlock feeds a *later* external item resolves in dependency order.

        Idempotent via the ``external_inputs_applied`` sentinel — both runtimes
        re-construct the FlowProcessor on every call, so a re-entrant init must
        not re-inject or re-run external codeBlocks.

        ``sources`` (optional) maps each item id to its non-PII source label
        (e.g. ``custom_attributes.rotate_out``) for the provenance marker U3
        surfaces in Bronze extraction. Absent, or missing an entry, the item id
        is recorded as the label (presence-only provenance). The source LABEL —
        never the resolved value — is stored.

        Returns a PII-free summary ``{applied, skipped, item_ids}`` for the
        service layer to log (item ids + counts, never the resolved values).
        """
        summary = {"applied": 0, "skipped": 0, "item_ids": []}

        if questionnaire_state.external_inputs_applied():
            self.logger.debug("External inputs already applied; skipping re-injection")
            return summary
        # Mark applied up-front: even a pass that injects nothing (empty/all-
        # invalid map) is "done", so a re-entrant init does not retry.
        questionnaire_state.mark_external_inputs_applied()

        if not injection_map:
            return summary

        all_items = questionnaire_state.get_all_items()
        navigation_path = questionnaire_state.get_navigation_path()

        for item_id in navigation_path:
            item = questionnaire_state.get_item(item_id)
            if not item:
                continue
            # Nothing supplied for this item — there is no decline to record.
            # Tested before the gates below so each of them fires only on a
            # value the platform actually tried to apply.
            if item_id not in injection_map:
                continue

            # Every gate below declines a supplied value, and each records which
            # one declined it (R17). They are all `degraded`: a value the
            # platform held about this respondent did not reach the dataset, so
            # the item is either asked again or left absent.
            #
            # Guard (plan): only `external` items are injectable — a value for a
            # non-external item is ignored.
            if not item.get("external"):
                self._warn_prefill_declined(
                    questionnaire_state,
                    item_id,
                    "not_external",
                    "item is not declared `external: true`",
                )
                continue
            # v1 scope: only plain single-control Questions outside Roster/Group
            # blocks are prefill-eligible. A repeated/drawn external item has no
            # well-defined single value, so it is asked in the normal flow.
            if item.get("_roster_block_id") or item.get("_group_block_id"):
                self._warn_prefill_declined(
                    questionnaire_state,
                    item_id,
                    "block_kind",
                    "item is repeated or drawn (Roster/Group), so a single prefilled "
                    "value has no well-defined iteration",
                )
                summary["skipped"] += 1
                continue

            value = injection_map[item_id]

            # (2) Precondition gate — a precondition-false external stays absent.
            if not self._check_preconditions(item, all_items):
                self._warn_prefill_declined(
                    questionnaire_state,
                    item_id,
                    "precondition",
                    "the item's precondition is false, so it is not asked at all",
                )
                summary["skipped"] += 1
                continue

            # (3) Domain validation — out-of-domain value is not applied (AE3).
            # The one decline that is a rejected ANSWER rather than a skipped
            # item: the platform held a value for this respondent that the
            # instrument's own domain refuses.
            if not outcome_in_domain(item, value):
                self.logger.info(
                    "external input for %s rejected: value out of declared domain", item_id
                )
                self._warn_prefill_declined(
                    questionnaire_state,
                    item_id,
                    "domain",
                    "the supplied value is outside the item's declared domain",
                )
                summary["skipped"] += 1
                continue

            # (4) Drive the normal answer path (postcondition + codeBlock).
            # The timing event opens and closes inside this one call, so a
            # prefilled item records zero elapsed time (R9). That is the honest
            # measurement — nobody read the question — and it is exactly why the
            # source tag matters: without it these zeros would drag a
            # respondent-duration median toward the floor.
            result = self.process_item(
                questionnaire_state, item_id, value, source=SOURCE_EXTERNAL_PREFILL
            )
            if not result.get("success", False):
                # Postcondition failed — leave unresolved (no history, no
                # provenance). Asked in the flow. Do NOT mark visited (process_
                # item already returned early before the visited flip on a
                # postcondition failure).
                self._warn_prefill_declined(
                    questionnaire_state,
                    item_id,
                    "postcondition",
                    f"the supplied value fails the item's postcondition ({result.get('message')})",
                )
                summary["skipped"] += 1
                continue

            # (5) Success — process_item put the item on history (it was not
            # presented), so the history-walking Bronze extractor emits it.
            # Flag provenance with the item's non-PII source label (falls back
            # to the item id when no sources map is supplied — presence-only
            # provenance).
            source_label = (sources or {}).get(item_id, item_id)
            questionnaire_state.set_external_provenance(item_id, source_label)
            summary["applied"] += 1
            summary["item_ids"].append(item_id)

        self.logger.info(
            "external inputs applied=%d skipped=%d for %d mapped item(s)",
            summary["applied"],
            summary["skipped"],
            len(injection_map),
        )
        return summary

    def _backward_navigate(
        self,
        questionnaire_state: QMLState,
        all_items: list[dict[str, Any]],
    ) -> dict[str, Any] | None:
        """
        Pop one history entry and return the prior item (or None if at start).

        Roster-aware: history entries carry an `iter_key` (None for non-roster).
        - When the popped item is a roster item, its visited flag is reset and
          we ensure pass state matches the iter_key we're returning to.
        - When popping the FIRST entry of a roster pass, the pass is exited
          (state cleared) so a future forward step re-enters via _enter_roster_pass
          and re-evaluates iterateOver.
        - When the new top-of-history is a roster item from a different (or
          re-entered) pass, restore that pass's iter_key and outcomes context.

        Group-aware: capped-Group items also use iter_key=None, so the Roster
        guard does not fire for them. A parallel branch checks _group_block_id:
        when backward-nav pops the last remaining Group item out of history,
        clear_group_pass_state wipes group_asked so the next forward entry
        re-derives the drawn set from current precondition values. There is no
        frozen order to preserve — draw order comes from the navigation_path
        projection (R8/R17), itself frozen at init.
        """
        # Nothing before the current entry: Back changes nothing. Popping it
        # anyway left the first item unvisited and off history in memory, which
        # a driver persisting only on success never wrote, so the stored walk
        # and the one the driver went on with disagreed (flow walker).
        if len(questionnaire_state.get_history_with_iter()) < 2:
            self.logger.debug("No previous item for backward navigation")
            return None
        popped = questionnaire_state.pop_history()

        current_id, current_iter = popped
        current_item = next((item for item in all_items if item["id"] == current_id), None)
        if current_item:
            current_item["visited"] = False
            # Roster items: also clear pass state if this was the only roster
            # entry for the block (forward will re-enter via _enter_roster_pass).
            if current_iter is not None:
                block_id = current_item.get("_roster_block_id")
                if block_id and not self._block_has_history_entries(questionnaire_state, block_id):
                    # Reset all roster items in the block to unvisited so a fresh
                    # pass entry doesn't get confused; clear pass state.
                    for ri in questionnaire_state.get_items_by_block(block_id):
                        ri["visited"] = False
                    questionnaire_state.clear_roster_iter_state(block_id)
            # Capped-Group items: iter_key is always None, so the Roster guard
            # above never fires. When backward nav has popped the LAST group
            # history entry (we've stepped out of the pass), clear group_asked so
            # the next forward entry opens a fresh pass and re-evaluates each
            # member's eligibility ON REACH. Members keep their outcome and the
            # durable _group_asked tag across this clear, so on forward re-walk a
            # member still asked is re-presented (answer preserved — AE19) and a
            # member pushed out (precondition flipped, or cap now claimed by an
            # earlier member) is evicted at its reach decision (AE13). There is
            # no frozen draw to preserve — the on-reach walk re-derives it.
            group_block_id = current_item.get("_group_block_id")
            if group_block_id and not self._block_has_group_history_entries(
                questionnaire_state, group_block_id
            ):
                questionnaire_state.clear_group_pass_state(group_block_id)

        return self._reenter_top_of_history(questionnaire_state, all_items)

    def reenter_top_of_history(self, questionnaire_state: QMLState) -> dict[str, Any] | None:
        """The item on top of history, back in its Roster iteration, without popping it.

        For a driver that shows an end screen past the last item: stepping back
        from it re-presents that item where it was answered. A Roster item is in
        history once per iteration, and the pass state is cleared once the pass
        is done, so the iteration comes from the history entry, not from the item
        id (a jump by id lands on the first iteration and truncates the rest).
        ``None`` when history is empty.
        """
        return self._reenter_top_of_history(
            questionnaire_state, questionnaire_state.get_all_items()
        )

    def _reenter_top_of_history(
        self, questionnaire_state: QMLState, all_items: list[dict[str, Any]]
    ) -> dict[str, Any] | None:
        """The top history entry's item, its Roster pass and iteration restored."""
        new_history = questionnaire_state.get_history_with_iter()
        if not new_history:
            return None

        prev_id, prev_iter = new_history[-1]
        prev_item = next((item for item in all_items if item["id"] == prev_id), None)
        if not prev_item:
            return None

        # Re-establish roster pass state if the previous item lives in one.
        prev_block_id = prev_item.get("_roster_block_id")
        if prev_iter is not None and prev_block_id:
            # Make sure the pass is active. If it's not (e.g., we exited to a
            # non-roster item and are now navigating back into the roster),
            # re-enter using the same iterateOver eval.
            if questionnaire_state.get_roster_active_keys(prev_block_id) is None:
                self._enter_roster_pass(prev_item, all_items)
            questionnaire_state.set_current_roster_iter(prev_block_id, prev_iter)
            self._restore_roster_outcomes_for_iter(prev_block_id, prev_iter)

        self.logger.debug(f"Backward navigation to: {prev_id} (iter_key={prev_iter})")
        # Decorated like a forward step's item, so a Roster item stepped back
        # into still says which iteration it asks about.
        return self._decorate_with_roster_progress(prev_item)

    @staticmethod
    def _block_has_history_entries(state: QMLState, block_id: str) -> bool:
        """True if any remaining history entry belongs to the given roster block."""
        for item_id, iter_key in state.get_history_with_iter():
            if iter_key is None:
                continue
            item = state.get_item(item_id)
            if item and item.get("_roster_block_id") == block_id:
                return True
        return False

    @staticmethod
    def _block_has_group_history_entries(state: QMLState, block_id: str) -> bool:
        """True if any remaining history entry belongs to the given capped-Group
        block.

        Capped-Group items carry iter_key=None (no per-iteration identity), so
        we discriminate by _group_block_id on the item, not by iter_key.
        """
        for item_id, _ in state.get_history_with_iter():
            item = state.get_item(item_id)
            if item and item.get("_group_block_id") == block_id:
                return True
        return False

    def get_navigation_path(self) -> list[str]:
        """
        Get the pre-computed navigation path (topological order).

        Returns:
            List of item IDs in topological order (cycle members linearized in file order)
        """
        return self.engine.get_topological_order()

    def get_statistics(self) -> dict[str, Any]:
        """
        Get flow-specific statistics.

        Returns:
            Statistics about the questionnaire flow
        """
        stats = self.engine.get_statistics()

        # Add flow-specific information
        navigation_path = self.get_navigation_path()
        stats.update(
            {
                "flow_mode": True,
                "navigation_path_length": len(navigation_path),
                "navigation_path": navigation_path,
                "can_use_topological_order": not self.engine.has_cycles(),
            }
        )

        return stats

    def debug_dump(self) -> str:
        """Generate debug output for flow processor."""
        lines = []
        lines.append("=" * 60)
        lines.append("FLOW PROCESSOR DEBUG DUMP")
        lines.append("=" * 60)

        stats = self.get_statistics()
        lines.append("\n📊 Flow Summary:")
        lines.append(f"  Navigation path length: {stats['navigation_path_length']}")
        lines.append(f"  Using topological order: {stats['can_use_topological_order']}")
        lines.append(f"  Has cycles: {self.engine.has_cycles()}")

        if self.engine.has_cycles():
            cycles = self.engine.get_cycles()
            lines.append(f"  Number of cycles: {len(cycles)}")

        lines.append("\n📋 Navigation Path:")
        navigation_path = stats["navigation_path"]
        if len(navigation_path) <= 10:
            lines.append(f"  {' → '.join(navigation_path)}")
        else:
            lines.append(
                f"  {' → '.join(navigation_path[:5])} ... {' → '.join(navigation_path[-5:])}"
            )

        # Include engine debug info
        lines.append("\n" + self.engine.debug_dump())

        return "\n".join(lines)
