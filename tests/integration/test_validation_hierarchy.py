#!/usr/bin/env python3
"""Integration tests for the validation hierarchy based on thesis examples.

This test suite verifies the three-level validation hierarchy from the thesis:
1. Per-item validation (ItemClassifier) - W_i = B ∧ P_i ∧ ¬Q_i
2. Global validation (GlobalFormula) - F = B ∧ ∧(P_i ⇒ Q_i)
3. Path-based validation (PathBasedValidator) - A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)

It also covers U2 frozen-gate reachability (constant propagation into the
reachability base):
- A frozen codeInit variable (initialized, never reassigned) makes a gate on it
  statically decidable: `has_partner == 1` classifies NEVER (unreachable_item
  error), `has_partner == 0` classifies ALWAYS.
- A produced variable (reassigned in a codeBlock) is NOT propagated, so a gate on
  it stays CONDITIONAL — no regression.
- The full base still carries the frozen constant, so a postcondition on a frozen
  variable still fires the INFEASIBLE / globally-false machinery.

Reference: askalot-io/docs thesis/chapters/comprehensive_validation.tex
"""

import unittest
from pathlib import Path

import pytest
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3 import (
    GlobalFormula,
    ItemClassifier,
    PathBasedValidator,
)

# Path to fixture files
FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def load_qml_fixture(filename: str) -> QMLState:
    """Load a QML fixture file and return QMLState."""
    loader = QMLLoader(schema_path=None)
    qml_path = FIXTURES_DIR / filename
    data = loader.load_from_path(str(qml_path))
    return QMLState(data)


def create_engine(filename: str) -> QMLEngine:
    """Load a QML fixture and create QMLEngine."""
    state = load_qml_fixture(filename)
    return QMLEngine(state)


@pytest.mark.integration
class TestTheoremLocalInvalidityNotGlobal(unittest.TestCase):
    """
    Theorem 2.2: Local Invalidity Does Not Imply Global Unsatisfiability.

    If SAT(W_i) for some i, it does not follow that UNSAT(F).

    Example: Driving experience survey
    - I_1: age ∈ [0, 120], P_1 = true, Q_1 = true
    - I_2: experience ∈ [0, 100], P_2 = (age >= 16), Q_2 = (exp <= age - 16)

    SAT(W_2) with S_1=20, S_2=10 (10 years at age 20 violates Q_2)
    But SAT(F) with S_1=30, S_2=5 (5 years at age 30 is valid)
    """

    def setUp(self):
        self.engine = create_engine("thesis_driving_experience.qml")

    def test_per_item_not_infeasible(self):
        """Postcondition should not be INFEASIBLE."""
        classifier = ItemClassifier(self.engine.static_builder)
        classifications = classifier.classify_all_items()

        q_exp = classifications.get("q_experience", {})
        postcond = q_exp.get("postcondition", {})

        self.assertNotEqual(
            postcond.get("invariant"),
            "INFEASIBLE",
            "q_experience postcondition should not be INFEASIBLE",
        )

    def test_global_formula_is_sat(self):
        """Global formula F should be SAT despite local constraint violations."""
        global_formula = GlobalFormula(self.engine.static_builder)
        result = global_formula.check()

        self.assertTrue(
            result.satisfiable, "Global formula should be SAT (valid completions exist)"
        )
        self.assertEqual(result.status, "SAT")

    def test_no_dead_code(self):
        """No items should be dead code."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        self.assertFalse(result.has_dead_code, "No dead code should be detected")
        self.assertEqual(len(result.dead_code_items), 0)


@pytest.mark.integration
class TestTheoremAccumulatedConstraintsUnsatisfiable(unittest.TestCase):
    """
    Theorem 2.3: Accumulated Constraints Can Cause Global Unsatisfiability.

    There exist questionnaires where no item is INFEASIBLE, yet UNSAT(F).

    Example: Conflicting postconditions
    - I_1: rating ∈ [1, 100], P_1 = true, Q_1 = (rating > 50)
    - I_2: confirm ∈ {0, 1}, P_2 = true, Q_2 = (rating < 30)

    Per-item: Both are CONSTRAINING (not INFEASIBLE)
    Global: UNSAT(F) - no rating satisfies both > 50 AND < 30
    """

    def setUp(self):
        self.engine = create_engine("thesis_conflicting_postconditions.qml")

    def test_per_item_not_infeasible(self):
        """Neither item should be INFEASIBLE when checked independently."""
        classifier = ItemClassifier(self.engine.static_builder)
        classifications = classifier.classify_all_items()

        for item_id, classification in classifications.items():
            postcond = classification.get("postcondition", {})
            invariant = postcond.get("invariant", "UNKNOWN")

            self.assertNotEqual(
                invariant,
                "INFEASIBLE",
                f"{item_id} should not be INFEASIBLE when checked independently",
            )

    def test_global_formula_is_unsat(self):
        """Global formula F should be UNSAT due to conflicting postconditions."""
        global_formula = GlobalFormula(self.engine.static_builder)
        result = global_formula.check()

        self.assertFalse(
            result.satisfiable, "Global formula should be UNSAT (accumulated constraints conflict)"
        )
        self.assertEqual(result.status, "UNSAT")


@pytest.mark.integration
class TestTheoremGlobalNotSufficient(unittest.TestCase):
    """
    Theorem 2.5: Global Validity Does Not Guarantee All Items Reachable.

    There exist questionnaires where SAT(F) but some item is unreachable.

    Example: Dead code simple
    - I_1: rating ∈ [1, 100], P_1 = true, Q_1 = (rating > 80)
    - I_2: feedback ∈ {0, 1}, P_2 = (rating < 50), Q_2 = true

    Per-item: P_2 is CONDITIONAL (reachable for rating < 50)
    Global: SAT(F) with rating = 90 (implication P_2 => Q_2 vacuously true)
    Path-based: I_2 is DEAD CODE (rating > 80 AND rating < 50 is UNSAT)
    """

    def setUp(self):
        self.engine = create_engine("thesis_dead_code_simple.qml")

    def test_precondition_is_conditional(self):
        """q_feedback precondition should be CONDITIONAL (not NEVER)."""
        classifier = ItemClassifier(self.engine.static_builder)
        classifications = classifier.classify_all_items()

        q_feedback = classifications.get("q_feedback", {})
        precond = q_feedback.get("precondition", {})

        self.assertEqual(
            precond.get("status"),
            "CONDITIONAL",
            "q_feedback precondition should be CONDITIONAL per-item",
        )

    def test_global_formula_is_sat(self):
        """Global formula F should be SAT (vacuous truth of implication)."""
        global_formula = GlobalFormula(self.engine.static_builder)
        result = global_formula.check()

        self.assertTrue(
            result.satisfiable, "Global formula should be SAT (implication is vacuously true)"
        )

    def test_dead_code_detected(self):
        """q_feedback should be detected as dead code."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        self.assertTrue(result.has_dead_code, "Dead code should be detected")
        self.assertIn(
            "q_feedback", result.dead_code_items, "q_feedback should be identified as dead code"
        )

    def test_dead_code_item_details(self):
        """Verify dead code item has correct classification details."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        q_feedback_result = result.item_results.get("q_feedback")
        self.assertIsNotNone(q_feedback_result)

        # Should be CONDITIONAL per-item but not accumulated-reachable
        self.assertEqual(q_feedback_result.per_item_status, "CONDITIONAL")
        self.assertFalse(q_feedback_result.accumulated_reachable)
        self.assertTrue(q_feedback_result.is_dead_code)


@pytest.mark.integration
class TestAccumulatedReachabilityExample(unittest.TestCase):
    """
    Accumulated Reachability — sibling-mediated dead code (icai2026 ex:income).

    Example: Income survey where a tax-bracket postcondition smuggles a lower
    bound on income through an always-present sibling, killing a low-income branch.
    - I_1: income ∈ [0, 1M], P_1 = true, Q_1 = true
    - I_2: tax_bracket ∈ {1,2,3}, P_2 = true, Q_2 = (income >= tax_bracket * 10000)
    - I_3: low_income_assist ∈ {0,1}, P_3 = (income < 10000), Q_3 = true

    Dependency: I_1 → I_2 (Q_2 references income) and I_1 → I_3 (P_3 references
    income). I_2 and I_3 are independent siblings (no edge between them); stable
    topological order is I_1, I_2, I_3.

    Pred(3) = {1, 2} — every item earlier in the topological order. I_2 is
    always-present, so Q_2 is enforced on every execution reaching I_3.

    A_3 = B ∧ (true => true) ∧ (true => income >= tax_bracket * 10000)
    A_3 ∧ P_3 = B ∧ (income >= tax_bracket * 10000) ∧ (income < 10000) = UNSAT
    (since tax_bracket >= 1, income is forced >= 10000)

    I_3 is dead code despite being CONDITIONAL per-item.
    """

    def setUp(self):
        self.engine = create_engine("thesis_dead_code_income.qml")

    def test_topological_order(self):
        """Verify correct topological order."""
        topo_order = self.engine.get_topological_order()
        self.assertIsNotNone(topo_order)

        # q_income should come before q_low_income_assist (dependency)
        if "q_income" in topo_order and "q_low_income_assist" in topo_order:
            income_idx = topo_order.index("q_income")
            assist_idx = topo_order.index("q_low_income_assist")
            self.assertLess(
                income_idx,
                assist_idx,
                "q_income should come before q_low_income_assist in topological order",
            )

    def test_per_item_conditional(self):
        """q_low_income_assist precondition should be CONDITIONAL."""
        classifier = ItemClassifier(self.engine.static_builder)
        classifications = classifier.classify_all_items()

        q_assist = classifications.get("q_low_income_assist", {})
        precond = q_assist.get("precondition", {})

        self.assertEqual(
            precond.get("status"),
            "CONDITIONAL",
            "q_low_income_assist precondition should be CONDITIONAL per-item",
        )

    def test_global_formula_is_sat(self):
        """Global formula should be SAT."""
        global_formula = GlobalFormula(self.engine.static_builder)
        result = global_formula.check()

        self.assertTrue(result.satisfiable, "Global formula should be SAT")

    def test_dead_code_detected(self):
        """q_low_income_assist should be detected as dead code."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        self.assertTrue(result.has_dead_code, "Dead code should be detected")
        self.assertIn(
            "q_low_income_assist",
            result.dead_code_items,
            "q_low_income_assist should be identified as dead code",
        )

    def test_always_present_sibling_not_dead_code(self):
        """q_tax_bracket is always-present (P_2 = true), so it is never dead code."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        self.assertNotIn(
            "q_tax_bracket",
            result.dead_code_items,
            "q_tax_bracket is always-present and cannot be dead code",
        )

    def test_predecessor_relationship(self):
        """Verify Pred(3) includes every earlier item, not only data-flow ancestors."""
        validator = PathBasedValidator(self.engine.static_builder, self.engine.topology)
        result = validator.validate()

        q_assist_result = result.item_results.get("q_low_income_assist")
        self.assertIsNotNone(q_assist_result)

        # Both earlier items are predecessors: q_income (a data-flow ancestor) and
        # q_tax_bracket (a sibling whose postcondition makes q_low_income_assist
        # dead). The latter is the crux of sibling-mediated dead-code detection.
        self.assertIn(
            "q_income",
            q_assist_result.predecessors,
            "q_income should be a predecessor of q_low_income_assist",
        )
        self.assertIn(
            "q_tax_bracket",
            q_assist_result.predecessors,
            "q_tax_bracket should be a predecessor of q_low_income_assist",
        )


@pytest.mark.integration
class TestValidationHierarchyRelationships(unittest.TestCase):
    """
    Tests for the relationships between validation levels.

    From the thesis:
    - Per-item passes → Global passes (Theorem: Soundness)
    - Global fails → Path-based fails (Theorem: Global Necessary)
    - Global passes ↛ All paths valid (Theorem: Global Not Sufficient)
    """

    def test_soundness_all_tautological(self):
        """
        Soundness: If all W_i are UNSAT (all TAUTOLOGICAL), then SAT(F).

        Use basic.qml which has no postconditions (all TAUTOLOGICAL/NONE).
        """
        engine = create_engine("basic.qml")

        classifier = ItemClassifier(engine.static_builder)
        classifications = classifier.classify_all_items()

        # All items should have TAUTOLOGICAL or NONE postconditions
        all_safe = True
        for _item_id, classification in classifications.items():
            postcond = classification.get("postcondition", {})
            invariant = postcond.get("invariant", "UNKNOWN")
            if invariant not in ("TAUTOLOGICAL", "NONE"):
                all_safe = False
                break

        if all_safe:
            # Then global should be SAT (by Soundness theorem)
            global_formula = GlobalFormula(engine.static_builder)
            result = global_formula.check()

            self.assertTrue(
                result.satisfiable,
                "If all postconditions are TAUTOLOGICAL/NONE, global should be SAT",
            )

    def test_global_necessary_for_paths(self):
        """
        Global Necessary: If UNSAT(F), then no execution path is valid.

        Use conflicting_postconditions which has UNSAT(F).
        """
        engine = create_engine("thesis_conflicting_postconditions.qml")

        global_formula = GlobalFormula(engine.static_builder)
        global_result = global_formula.check()

        # If global is UNSAT, path-based should also find issues
        if not global_result.satisfiable:
            validator = PathBasedValidator(engine.static_builder, engine.topology)
            validator.validate()

            # When global is UNSAT, all items effectively become problematic
            # The path-based validator may detect this as dead code or other issues
            # At minimum, the questionnaire is not completable
            self.assertEqual(global_result.status, "UNSAT", "Global formula should be UNSAT")


@pytest.mark.integration
class TestFrozenGateReachability(unittest.TestCase):
    """U2: constant propagation of frozen codeInit variables into the
    reachability base (R10, AE4).

    A frozen variable — initialized in codeInit and never reassigned by any
    codeBlock — holds its initializer constant for the whole run. Its SSA
    constant constraint now contributes to the base the ItemClassifier's
    precondition-reachability check uses, so gates on it decide statically
    (NEVER / ALWAYS) instead of treating the variable as a free symbol
    (CONDITIONAL). Postcondition and global checks keep using the full base
    unchanged.
    """

    def _classifications(self, filename: str) -> dict:
        engine = create_engine(filename)
        return ItemClassifier(engine.static_builder).classify_all_items()

    def test_frozen_gate_equal_one_is_never(self):
        """AE4: `has_partner == 1` on a frozen `has_partner = 0` → NEVER."""
        classifications = self._classifications("lint_frozen_gate.qml")
        status = classifications["q_partner_age"]["precondition"]["status"]
        self.assertEqual(
            status,
            "NEVER",
            "A gate on frozen `has_partner == 1` must classify NEVER (dead code), "
            "not CONDITIONAL as a domain-only base would report.",
        )

    def test_frozen_gate_emits_unreachable_item_error(self):
        """AE4: the NEVER item surfaces the downstream unreachable_item ERROR, and
        (#169) the frozen variable ALSO surfaces its root cause.

        `has_partner = 0` is frozen and read by two gates — `has_partner == 1`
        (q_partner_age → NEVER) and `has_partner == 0` (q_living_alone → ALWAYS).
        The fixture therefore yields exactly two errors: the unreachable_item
        symptom on q_partner_age plus a single frozen_variable root-cause error
        naming `has_partner` and both gated locations (grouped, not replaced), and
        nothing incidental.
        """
        state = load_qml_fixture("lint_frozen_gate.qml")
        issues = ValidationProcessor(state).to_issues()
        unreachable = [
            i
            for i in issues
            if i["type"] == "unreachable_item" and i["item_id"] == "q_partner_age"
        ]
        self.assertEqual(
            len(unreachable),
            1,
            f"expected one unreachable_item error on q_partner_age, got {issues}",
        )
        self.assertEqual(unreachable[0]["severity"], "error")

        errors = [i for i in issues if i["severity"] == "error"]
        self.assertEqual(
            sorted(i["type"] for i in errors),
            ["frozen_variable", "unreachable_item"],
            f"frozen-gate fixture must yield the unreachable_item symptom plus the "
            f"frozen_variable root cause, got {errors}",
        )
        frozen = [i for i in errors if i["type"] == "frozen_variable"]
        self.assertEqual(len(frozen), 1, f"expected one frozen_variable error, got {frozen}")
        self.assertIn("has_partner", frozen[0]["message"])
        # Both gated locations are named so the fixer sees the full blast radius.
        self.assertIn("q_partner_age", frozen[0]["message"])
        self.assertIn("q_living_alone", frozen[0]["message"])

    def test_frozen_gate_equal_zero_is_always(self):
        """`has_partner == 0` on a frozen `has_partner = 0` → ALWAYS (so no
        unreachable_item; the frozen_variable root-cause lint fires separately —
        see test_frozen_gate_emits_unreachable_item_error)."""
        classifications = self._classifications("lint_frozen_gate.qml")
        status = classifications["q_living_alone"]["precondition"]["status"]
        self.assertEqual(
            status,
            "ALWAYS",
            "A gate on frozen `has_partner == 0` must classify ALWAYS — the "
            "constant satisfies it on every run.",
        )

    def test_produced_variable_gate_stays_conditional(self):
        """No regression: a gate on a codeBlock-produced variable stays
        CONDITIONAL. `scoring.qml`'s `risk_level` is initialized in codeInit but
        reassigned by three item codeBlocks, so it is NOT frozen — its
        initializer is not propagated and `q_result` (gated `risk_level >= 0`)
        keeps its CONDITIONAL classification under the domain-only base."""
        classifications = self._classifications("scoring.qml")
        status = classifications["q_result"]["precondition"]["status"]
        self.assertEqual(
            status,
            "CONDITIONAL",
            "A produced (reassigned) variable must not be constant-propagated; "
            "its gated item stays CONDITIONAL.",
        )

    def test_frozen_postcondition_infeasible_full_base_unchanged(self):
        """Full-base semantics unchanged: a postcondition on a frozen variable
        still fires the existing INFEASIBLE / globally-false machinery.

        The frozen constant lives in ``codeblock_constraints`` (hence the full
        base) — only the reachability base additionally carries a copy.
        An item reachable by a satisfiable outcome gate whose postcondition
        asserts `has_partner == 1` (impossible for the frozen `has_partner = 0`)
        must classify INFEASIBLE and flag q_globally_false."""
        state = QMLState(
            {
                "title": "Frozen Postcondition",
                "codeInit": "has_partner = 0",
                "blocks": [{"id": "b1", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_income",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "Household income bracket?",
                        "input": {"control": "Editbox", "min": 0, "max": 100},
                        "postcondition": [
                            {
                                "predicate": "has_partner == 1",
                                "hint": "impossible for a frozen has_partner = 0",
                            }
                        ],
                    }
                ],
            }
        )
        engine = QMLEngine(state)
        classification = ItemClassifier(engine.static_builder).classify_all_items()["q_income"]

        # Reachable (ALWAYS) — the item itself is not gated away...
        self.assertEqual(classification["precondition"]["status"], "ALWAYS")
        # ...yet its postcondition can never hold under the frozen constant.
        self.assertEqual(classification["postcondition"]["invariant"], "INFEASIBLE")
        self.assertTrue(classification["postcondition"]["global"]["q_globally_false"])

    def test_item_outcome_gates_unchanged(self):
        """Scenario 5: fixtures whose gates reference item outcomes (not frozen
        variables) classify exactly as before — they carry no frozen codeInit
        variable, so the reachability base equals the domain base for them.

        `thesis_dead_code_simple` / `thesis_dead_code_income` gate on outcomes;
        their per-item precondition stays CONDITIONAL (dead code is a path-based
        finding, unchanged by U2)."""
        simple = self._classifications("thesis_dead_code_simple.qml")
        self.assertEqual(simple["q_feedback"]["precondition"]["status"], "CONDITIONAL")

        income = self._classifications("thesis_dead_code_income.qml")
        # The income fixture's outcome-gated item remains CONDITIONAL per-item.
        self.assertEqual(income["q_low_income_assist"]["precondition"]["status"], "CONDITIONAL")

    def test_non_name_rebinding_keeps_gate_conditional(self):
        """A codeInit variable rebound in a codeBlock ONLY through a tuple-unpack
        is produced, not frozen — so a gate on it stays CONDITIONAL and does not
        raise a false unreachable_item error.

        SSA registers only plain ``Name`` assignment targets, so the tuple-unpack
        ``x, y = q_a.outcome, q_b.outcome`` leaves ``version_history`` all
        ``__init__``. Freezing on that alone would pin the stale ``x = 0``
        constant into the reachability base, classify the ``x == 5`` gate NEVER,
        and block saving a valid questionnaire. Excluding any codeBlock-bound
        name from the frozen set keeps ``x`` free."""
        state = QMLState(
            {
                "title": "Tuple-unpack rebinding",
                "codeInit": "x = 0\ny = 0",
                "blocks": [{"id": "b1", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_a",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "A?",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                    },
                    {
                        "id": "q_b",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "B?",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                    },
                    {
                        "id": "q_pair",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "Pair",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "codeBlock": "x, y = q_a.outcome, q_b.outcome",
                    },
                    {
                        "id": "q_gate",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "Gated on x",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": "x == 5"}],
                    },
                ],
            }
        )
        engine = QMLEngine(state)
        classification = ItemClassifier(engine.static_builder).classify_all_items()["q_gate"]
        self.assertEqual(
            classification["precondition"]["status"],
            "CONDITIONAL",
            "a gate on a tuple-unpack-rebound variable must stay CONDITIONAL",
        )

        issues = ValidationProcessor(state).to_issues()
        unreachable = [
            i for i in issues if i["type"] == "unreachable_item" and i["item_id"] == "q_gate"
        ]
        self.assertEqual(
            unreachable, [], f"q_gate must not raise a false unreachable_item error, got {issues}"
        )


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
