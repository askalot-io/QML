"""
Unit tests for the Quality Scorecard metrics engine (core/quality_metrics.py).

Tests the D2-D8 mechanical quality dimensions computed over validation artifacts:
- D6 order coherence: inversion detection when authoring order fights the
  dependency graph, and zero inversions when it doesn't
- D5/D7 complexity and path diversity: zero-branching questionnaires grade weak
- D3 quality-gate density: tautological postconditions and duplicate input
  bounds do not count as constraining gates
- D2 instrument economy: dead-weight variables (write-only, pass-through alias)
  are counted via the shared issue policy
- D4 verification coverage: runtime-degraded predicates (Subscript fallback)
  lower the coverage share
- D8 burden & balance: Roster worst-case multiplication vs zero-iteration
  guaranteed burden, the zero-guaranteed (spread None) branch, capped-Group
  top-count cost selection, and the item-cost table
- Positive-arm grades: STRONG/ADEQUATE bands pinned on well-designed fixtures
  so a band-constant regression cannot silently flip good instruments to weak
- Report shape and determinism: every dimension carries the same envelope and
  two runs over the same file return identical reports

These unit tests build real ValidationProcessor pipelines over small synthetic
fixtures (tests/fixtures/quality_*.qml), so the metrics are exercised against
genuine StaticBuilder/QMLTopology/ItemClassifier artifacts rather than mocks —
the scorecard is a derivation over those artifacts, and mocking them would
test nothing.
"""

import unittest
from pathlib import Path

import pytest
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.quality_metrics import (
    GRADE_ADEQUATE,
    GRADE_NA,
    GRADE_STRONG,
    GRADE_WEAK,
    _item_cost,
)
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState

FIXTURES_DIR = Path(__file__).parent.parent.parent / "fixtures"

EXPECTED_DIMENSIONS = {
    "instrument_economy": "D2",
    "quality_gate_density": "D3",
    "verification_coverage": "D4",
    "structural_complexity": "D5",
    "order_coherence": "D6",
    "path_diversity": "D7",
    "burden_balance": "D8",
}


def quality_report(filename: str) -> dict:
    """Load a QML fixture, run the validation pipeline, return the scorecard."""
    loader = QMLLoader(schema_path=None)
    data = loader.load_from_path(str(FIXTURES_DIR / filename))
    processor = ValidationProcessor(QMLState(data))
    return processor.get_quality_report()


@pytest.mark.unit
class TestReportShape(unittest.TestCase):
    """Envelope contract: dimension set, per-dimension keys, determinism."""

    def test_all_dimensions_present_with_envelope(self):
        report = quality_report("quality_zero_branching.qml")
        self.assertEqual(set(report["dimensions"]), set(EXPECTED_DIMENSIONS))
        for name, dim_id in EXPECTED_DIMENSIONS.items():
            dim = report["dimensions"][name]
            self.assertEqual(dim["id"], dim_id)
            self.assertIn(dim["grade"], ("strong", "adequate", "weak", "not_applicable"))
            self.assertIsInstance(dim["metrics"], dict)
            self.assertIsInstance(dim["offenders"], list)
            self.assertIsInstance(dim["truncated"], bool)
        self.assertEqual(report["item_count"], 4)
        self.assertIsInstance(report["notes"], list)

    def test_determinism_same_file_same_report(self):
        # AE6: no LLM, no randomness — two independent pipelines over the same
        # file must produce byte-identical reports.
        self.assertEqual(
            quality_report("quality_roster_burden.qml"),
            quality_report("quality_roster_burden.qml"),
        )


@pytest.mark.unit
class TestOrderCoherence(unittest.TestCase):
    """D6: authored order vs delivered (stable-Kahn topological) order."""

    def test_inverted_authoring_detected(self):
        report = quality_report("quality_inverted_order.qml")
        dim = report["dimensions"]["order_coherence"]
        self.assertGreater(dim["metrics"]["inversions"], 0)
        self.assertNotEqual(dim["grade"], GRADE_STRONG)
        offender_ids = {o["item_id"] for o in dim["offenders"]}
        # Both the displaced gate and the displaced dependent appear.
        self.assertIn("q_detail", offender_ids)
        self.assertIn("q_gate", offender_ids)

    def test_consistent_order_zero_inversions(self):
        # branching_flow.qml authors gates before their dependents, so the
        # stable sort reproduces the file order exactly.
        report = quality_report("branching_flow.qml")
        dim = report["dimensions"]["order_coherence"]
        self.assertEqual(dim["metrics"]["inversions"], 0)
        self.assertEqual(dim["grade"], GRADE_STRONG)
        self.assertEqual(dim["offenders"], [])


@pytest.mark.unit
class TestComplexityAndDiversity(unittest.TestCase):
    """D5 decision density and D7 path diversity on the branching extremes."""

    def test_zero_branching_grades_weak(self):
        report = quality_report("quality_zero_branching.qml")
        complexity = report["dimensions"]["structural_complexity"]
        diversity = report["dimensions"]["path_diversity"]
        self.assertEqual(complexity["metrics"]["decision_points"], 0)
        self.assertEqual(complexity["grade"], GRADE_WEAK)
        self.assertEqual(diversity["metrics"]["conditional_share"], 0.0)
        self.assertEqual(diversity["metrics"]["gate_source_count"], 0)
        self.assertEqual(diversity["grade"], GRADE_WEAK)

    def test_branching_flow_has_diversity_and_gate_sources(self):
        report = quality_report("branching_flow.qml")
        diversity = report["dimensions"]["path_diversity"]
        self.assertGreater(diversity["metrics"]["conditional_share"], 0.0)
        self.assertGreaterEqual(diversity["metrics"]["gate_source_count"], 1)
        # Pin the positive-arm band, not just "not weak" — a band-constant
        # regression must fail here.
        self.assertEqual(diversity["grade"], GRADE_STRONG)
        complexity = report["dimensions"]["structural_complexity"]
        self.assertGreater(complexity["metrics"]["decision_points"], 0)
        self.assertGreaterEqual(complexity["metrics"]["dependency_depth"], 2)
        self.assertEqual(complexity["grade"], GRADE_STRONG)


@pytest.mark.unit
class TestQualityGateDensity(unittest.TestCase):
    """D3: only CONSTRAINING postconditions count as real gates."""

    def test_tautology_and_duplicate_bound_not_constraining(self):
        report = quality_report("quality_tautology_only.qml")
        dim = report["dimensions"]["quality_gate_density"]
        # AE2: the file validates (no errors) yet carries zero real gates.
        self.assertEqual(dim["metrics"]["constraining_postcondition_items"], 0)
        self.assertEqual(dim["grade"], GRADE_WEAK)
        details = " ".join(o["detail"] for o in dim["offenders"])
        self.assertIn("TAUTOLOGICAL", details)
        self.assertIn("min/max", details)
        self.assertGreaterEqual(dim["metrics"]["duplicate_input_bounds"], 1)

    def test_constraining_postcondition_counts(self):
        # classification.qml carries a genuinely constraining gate; its
        # constraining share (0.2) sits exactly on the strong band floor,
        # pinning the positive arm of the D3 grade bands.
        report = quality_report("classification.qml")
        dim = report["dimensions"]["quality_gate_density"]
        self.assertGreater(dim["metrics"]["constraining_postcondition_items"], 0)
        self.assertEqual(dim["grade"], GRADE_STRONG)


@pytest.mark.unit
class TestInstrumentEconomy(unittest.TestCase):
    """D2: dead-weight variables via the shared hygiene-issue policy."""

    def test_dead_weight_variables_counted(self):
        report = quality_report("quality_tautology_only.qml")
        dim = report["dimensions"]["instrument_economy"]
        # unused_var (write-only) and alias_val (pass-through) are both dead
        # weight out of two censused variables.
        self.assertEqual(dim["metrics"]["total_variables"], 2)
        self.assertEqual(dim["metrics"]["dead_weight_variables"], 2)
        self.assertEqual(dim["grade"], GRADE_WEAK)

    def test_live_variable_grades_strong(self):
        # branching_flow's `score` is a self-accumulating live variable — zero
        # dead weight must pin the STRONG arm.
        report = quality_report("branching_flow.qml")
        dim = report["dimensions"]["instrument_economy"]
        self.assertEqual(dim["metrics"]["dead_weight_variables"], 0)
        self.assertEqual(dim["grade"], GRADE_STRONG)

    def test_no_variables_is_not_applicable(self):
        report = quality_report("quality_zero_branching.qml")
        dim = report["dimensions"]["instrument_economy"]
        self.assertEqual(dim["grade"], GRADE_NA)
        self.assertEqual(dim["metrics"]["total_variables"], 0)


@pytest.mark.unit
class TestVerificationCoverage(unittest.TestCase):
    """D4: runtime-degraded predicates lower the verified share."""

    def test_subscript_fallback_counts_as_degraded(self):
        report = quality_report("quality_subscript_degraded.qml")
        dim = report["dimensions"]["verification_coverage"]
        # AE4: one of two precondition predicates fell back to runtime.
        self.assertGreaterEqual(dim["metrics"]["degraded_predicates"], 1)
        self.assertLess(dim["metrics"]["coverage_share"], 1.0)
        offender_ids = {o["item_id"] for o in dim["offenders"]}
        self.assertIn("q_degraded", offender_ids)

    def test_fully_lowered_file_has_full_coverage(self):
        report = quality_report("branching_flow.qml")
        dim = report["dimensions"]["verification_coverage"]
        self.assertEqual(dim["metrics"]["degraded_predicates"], 0)
        self.assertEqual(dim["metrics"]["coverage_share"], 1.0)
        self.assertEqual(dim["grade"], GRADE_STRONG)


@pytest.mark.unit
class TestBurdenBalance(unittest.TestCase):
    """D8: cost-weighted burden bounds with construct-aware multipliers."""

    def test_roster_widens_worst_case(self):
        report = quality_report("quality_roster_burden.qml")
        dim = report["dimensions"]["burden_balance"]
        metrics = dim["metrics"]
        # Guaranteed: only q_vehicles (the Textarea is CONDITIONAL, roster
        # items can run zero iterations).
        self.assertEqual(metrics["guaranteed_burden"], 1.0)
        # Worst case: q_vehicles (1) + Textarea (3) + 2 roster items x 3 labels (6).
        self.assertEqual(metrics["worst_case_burden"], 10.0)
        self.assertEqual(metrics["burden_spread_ratio"], 10.0)
        self.assertEqual(dim["grade"], GRADE_WEAK)

    def test_zero_guaranteed_burden_spread_is_none(self):
        # Everything inside a Roster: zero iterations possible, so nothing is
        # guaranteed — spread must be None (never a ZeroDivisionError) and the
        # grade falls to the adequate-by-fiat branch.
        report = quality_report("quality_all_conditional.qml")
        dim = report["dimensions"]["burden_balance"]
        self.assertEqual(dim["metrics"]["guaranteed_burden"], 0.0)
        self.assertIsNone(dim["metrics"]["burden_spread_ratio"])
        self.assertEqual(dim["grade"], GRADE_ADEQUATE)

    def test_capped_group_takes_top_count_costs(self):
        # count: 2 over {Textarea(3), Radio(1), Radio(1)} — worst case must sum
        # the two costliest members (4), not all three (5), plus the ALWAYS
        # consent item (1).
        report = quality_report("quality_capped_group.qml")
        dim = report["dimensions"]["burden_balance"]
        self.assertEqual(dim["metrics"]["guaranteed_burden"], 1.0)
        self.assertEqual(dim["metrics"]["worst_case_burden"], 5.0)

    def test_item_cost_table(self):
        self.assertEqual(_item_cost({"kind": "Comment"}), 0.0)
        self.assertEqual(
            _item_cost({"kind": "Question", "input": {"control": "Textarea"}}), 3.0
        )
        self.assertEqual(
            _item_cost({"kind": "Question", "input": {"control": "Radio"}}), 1.0
        )
        # Matrix rows live under the top-level `rows` key (schema-required for
        # MatrixQuestion) — `questions` belongs to QuestionGroup and must not
        # be what the cost table reads.
        self.assertEqual(
            _item_cost({"kind": "MatrixQuestion", "rows": ["r1", "r2", "r3"]}), 3.0
        )
        self.assertEqual(
            _item_cost({"kind": "MatrixQuestion", "questions": [{}, {}, {}]}), 1.0
        )
