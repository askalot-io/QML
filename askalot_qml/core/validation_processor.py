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

import logging
from typing import Any

from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.item_classifier import ItemClassifier

from askalot_common.tracing import create_span


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
                # namespace is closed, so at runtime it fails open (NameError →
                # treated as true) and Z3 sees a free symbol — the gate silently
                # enforces nothing. ``item_id`` here is the classification key: the
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
                                f"predicate fails open at runtime and the logic enforces "
                                f"nothing."
                            ),
                            "suggestion": (
                                f"Reference '{suggested}' instead."
                                if suggested
                                else (
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

        # Validation hierarchy Levels 2–4 (global satisfiability, dependency
        # cycles, accumulated dead code). Kept out of the per-item loop because
        # they are whole-questionnaire properties, not per-item classifications.
        issues.extend(self._hierarchy_issues(deep=deep))

        return issues

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
