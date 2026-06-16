#!/usr/bin/env python3
"""Integration tests proving static Z3 validation classifies matrix postconditions.

Verifies the three documented matrix patterns (symmetry, fixed-sum,
ranking/distinctness) reach the static validator as ``CONSTRAINING``
classifications under ``ItemClassifier``. The runtime side is covered by
``test_matrix_constraints.py``.

Static-builder language support relied on:
- ``ast.Subscript`` two-level reads (``X.outcome[j][k]``)
- ``ast.ListComp`` / ``GeneratorExp`` static unrolling
- Fold lowering: ``sum`` → ``z3.Sum``, ``all`` / ``any`` → ``z3.And`` / ``z3.Or``,
  ``len(set([…])) == k`` → ``z3.Distinct``
- Two-arg ``range(start, stop)``
- Per-cell ``item_{id}_{r}_{c}`` Z3 variables for ``MatrixQuestion`` items

Reference:
- ``shared/modules/askalot_ai/askalot_ai/agents/designer/.claude/skills/qml-syntax/matrix-constraint-patterns.md``
- ``shared/modules/askalot_qml/askalot_qml/z3/static_builder.py``
- ``docs/plans/2026-05-05-002-feat-z3-listcomp-matrix-plan.md``
"""

from pathlib import Path

import pytest
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3 import ItemClassifier

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def create_engine(filename: str) -> QMLEngine:
    loader = QMLLoader(schema_path=None)
    data = loader.load_from_path(str(FIXTURES_DIR / filename))
    return QMLEngine(QMLState(data))


@pytest.mark.integration
@pytest.mark.z3
class TestMatrixStaticGap:
    """Z3 validator should classify each matrix postcondition as CONSTRAINING."""

    def test_symmetry_postcondition_is_constraining(self):
        engine = create_engine("matrix_symmetry.qml")
        classifier = ItemClassifier(engine.static_builder)
        classifications = classifier.classify_all_items()

        postcond = classifications.get("factor_relationships", {}).get("postcondition", {})
        assert postcond.get("invariant") == "CONSTRAINING", (
            f"Expected CONSTRAINING, got {postcond.get('invariant')}. "
            f"Full postcond block: {postcond}"
        )

    def test_fixed_sum_postcondition_is_constraining(self):
        engine = create_engine("matrix_fixed_sum.qml")
        classifier = ItemClassifier(engine.static_builder)
        classifications = classifier.classify_all_items()

        postcond = classifications.get("quarterly_budget", {}).get("postcondition", {})
        assert postcond.get("invariant") == "CONSTRAINING", (
            f"Expected CONSTRAINING, got {postcond.get('invariant')}. "
            f"Full postcond block: {postcond}"
        )

    def test_ranking_postcondition_is_constraining(self):
        engine = create_engine("matrix_ranking.qml")
        classifier = ItemClassifier(engine.static_builder)
        classifications = classifier.classify_all_items()

        postcond = classifications.get("product_attribute_ranks", {}).get("postcondition", {})
        assert postcond.get("invariant") == "CONSTRAINING", (
            f"Expected CONSTRAINING, got {postcond.get('invariant')}. "
            f"Full postcond block: {postcond}"
        )


@pytest.mark.integration
@pytest.mark.z3
class TestMatrixInfeasibleDetection:
    """The negative-test fixture proves the validator reasons about matrix
    postconditions — the only way a 2x2 Editbox capped at 10 per cell can
    have row sum 999 is in a parallel universe where Z3 lies."""

    def test_infeasible_sum_postcondition_is_infeasible(self):
        engine = create_engine("matrix_infeasible_sum.qml")
        classifier = ItemClassifier(engine.static_builder)
        classifications = classifier.classify_all_items()

        postcond = classifications.get("impossible_budget", {}).get("postcondition", {})
        assert postcond.get("invariant") == "INFEASIBLE", (
            f"Expected INFEASIBLE, got {postcond.get('invariant')}. Full postcond block: {postcond}"
        )


@pytest.mark.integration
@pytest.mark.z3
class TestLoudWarningOnSilentDrop:
    """R7/R13: silent drops on unsupported predicate AST log a WARNING and
    are recorded as coverage gaps on the builder. This is the cure for the
    pre-1.14.0 anti-pattern where ``_ast_to_z3_bool`` returning None
    disappeared into a one-liner ``if constraint is not None:`` guard."""

    def test_unsupported_min_fold_warns_and_records_gap(self, caplog):
        # ``min(...)`` is intentionally not lowered (Risks: nested If encoding;
        # not needed by any documented matrix pattern). Authoring it triggers
        # the WARNING + coverage_gap path.
        # We re-use the infeasible-sum fixture's structure and patch a single
        # postcondition predicate at the QML-dict level to keep the trigger
        # narrow.
        loader = QMLLoader(schema_path=None)
        data = loader.load_from_path(str(FIXTURES_DIR / "matrix_infeasible_sum.qml"))
        # Inject an unsupported min-fold predicate.
        item = data["items"][0]  # impossible_budget after flattening
        item["postcondition"] = [
            {
                "predicate": "min([impossible_budget.outcome[j][0] for j in range(2)]) >= 0",
                "hint": "placeholder hint",
            }
        ]

        import logging

        with caplog.at_level(logging.WARNING, logger="askalot_qml.z3.static_builder"):
            engine = QMLEngine(QMLState(data))

        # The WARNING text uses %-formatting via logger.warning(...) — caplog
        # captures the formatted message.
        warning_messages = [
            record.message
            for record in caplog.records
            if record.levelno == logging.WARNING and "static validator skipped" in record.message
        ]
        assert any("impossible_budget" in m for m in warning_messages), (
            f"Expected at least one WARNING mentioning impossible_budget, got: {warning_messages}"
        )

        # Coverage gap is recorded on the builder for downstream consumers.
        gaps = engine.static_builder.coverage_gaps.get("impossible_budget", [])
        assert any(gap["kind"] == "postcondition" and gap["condition_idx"] == 0 for gap in gaps), (
            f"Expected postcondition coverage gap on impossible_budget, got {gaps}"
        )


if __name__ == "__main__":
    pytest.main([__file__, "-v", "-s"])
