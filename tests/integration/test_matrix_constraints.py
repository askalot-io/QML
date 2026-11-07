#!/usr/bin/env python3
"""Integration tests for MatrixQuestion runtime postcondition enforcement.

Covers the three matrix constraint patterns documented in the Designer skill
``qml-syntax/matrix-constraint-patterns.md``:

1. Matrix Symmetry — ``S[j][k] == S[k][j]`` for j < k (factor-relationship
   matrix).
2. Fixed-Sum Allocation — each row sums to a fixed total (quarterly budget).
3. Ranking / Distinctness — each row is a permutation of ``[1..k]`` (product
   attribute ranks).

For each pattern the test submits:

- a valid matrix outcome → ``FlowProcessor.process_item`` returns
  ``{'success': True, ...}``.
- a matrix that violates the constraint → ``process_item`` returns
  ``{'success': False, 'message': <hint>}``.

``TestDeclaredListLengthsRuntime`` (#1782) checks that ``len(m.rows)``,
``len(m.columns)`` and ``len(qg.questions)`` evaluate at runtime to the bounds
the static builder unrolls, through ``FlowProcessor`` and ``ItemClassifier``.

These tests exercise the RUNTIME path only (Python ``eval`` via
``PythonRunner``, which supports list comprehensions, ``all``, ``sum``,
``len``, ``set``, two-arg ``range``, and subscript reads). The
complementary **static** validation path — ``ItemClassifier`` /
``GlobalFormula`` over Z3 — now LOWERS the canonical folded shapes of
these patterns (``sum([...]) == K``, ``len(set([...])) == N``,
``all([...])`` over comprehensions with **literal** range bounds), so they
classify CONSTRAINING rather than being silently dropped (closed per
``docs/plans/2026-05-05-002-feat-z3-listcomp-matrix-plan.md``).
``test_matrix_static_gap.py`` covers that static path and the residual
runtime-only variants (``min``/``max`` folds, non-literal range bounds,
partial distinctness) that still fall back to a ``coverage_gap``.

Reference:
- ``shared/modules/askalot_ai/askalot_ai/plugin/skills/qml-syntax/matrix-constraint-patterns.md``
- ``shared/modules/askalot_qml/askalot_qml/core/python_runner.py``
  (safe_builtins expose ``all``, ``any``, ``sum``, ``len``, ``set``,
  ``range``, ``map``, ``filter``, ``sorted``, ``list``, …).
- ``shared/modules/askalot_qml/askalot_qml/models/item_proxy.py``
  (``_set_matrix_outcome`` validates ``List[List[Any]]`` shape against
  ``rows`` / ``columns``).
"""

from pathlib import Path

import pytest
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import SOURCE_RESPONDENT, QMLState

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def load_qml_fixture(filename: str) -> QMLState:
    loader = QMLLoader(schema_path=None)
    data = loader.load_from_path(str(FIXTURES_DIR / filename))
    return QMLState(data)


@pytest.mark.integration
@pytest.mark.flow
class TestMatrixSymmetryRuntime:
    """Pattern 1 — symmetric relationship matrix (S[j][k] == S[k][j])."""

    FIXTURE = "matrix_symmetry.qml"
    ITEM_ID = "factor_relationships"

    def test_symmetric_matrix_accepted(self):
        """A fully symmetric 4x4 matrix passes the symmetry postcondition."""
        state = load_qml_fixture(self.FIXTURE)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        symmetric = [
            [10, 7, 3, 5],
            [7, 10, 6, 4],
            [3, 6, 10, 8],
            [5, 4, 8, 10],
        ]
        result = processor.process_item(state, self.ITEM_ID, symmetric, source=SOURCE_RESPONDENT)
        assert result["success"] is True, result

    def test_asymmetric_matrix_rejected_with_hint(self):
        """An asymmetric entry (S[0][1] != S[1][0]) is rejected with the hint."""
        state = load_qml_fixture(self.FIXTURE)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        asymmetric = [
            [10, 7, 3, 5],
            [2, 10, 6, 4],  # [1][0] = 2, but [0][1] = 7 → violates symmetry
            [3, 6, 10, 8],
            [5, 4, 8, 10],
        ]
        result = processor.process_item(state, self.ITEM_ID, asymmetric, source=SOURCE_RESPONDENT)
        assert result["success"] is False
        assert "relationship" in result["message"].lower()


@pytest.mark.integration
@pytest.mark.flow
class TestMatrixFixedSumRuntime:
    """Pattern 2 — each row sums to a fixed total (100)."""

    FIXTURE = "matrix_fixed_sum.qml"
    ITEM_ID = "quarterly_budget"

    def test_each_row_sums_to_100_accepted(self):
        """Every row summing to exactly 100 passes the fixed-sum postcondition."""
        state = load_qml_fixture(self.FIXTURE)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        budget = [
            [40, 20, 30, 10],
            [25, 25, 25, 25],
            [50, 10, 30, 10],
            [10, 40, 40, 10],
        ]
        result = processor.process_item(state, self.ITEM_ID, budget, source=SOURCE_RESPONDENT)
        assert result["success"] is True, result

    def test_row_sum_not_100_rejected_with_hint(self):
        """A row that doesn't sum to 100 is rejected with the hint."""
        state = load_qml_fixture(self.FIXTURE)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        bad_budget = [
            [40, 20, 30, 10],  # sum = 100 ✓
            [25, 25, 25, 20],  # sum = 95 ✗
            [50, 10, 30, 10],  # sum = 100 ✓
            [10, 40, 40, 10],  # sum = 100 ✓
        ]
        result = processor.process_item(state, self.ITEM_ID, bad_budget, source=SOURCE_RESPONDENT)
        assert result["success"] is False
        assert "sum" in result["message"].lower()


@pytest.mark.integration
@pytest.mark.flow
class TestMatrixRankingRuntime:
    """Pattern 3 — each row is a permutation of [1..n] (no duplicate ranks)."""

    FIXTURE = "matrix_ranking.qml"
    ITEM_ID = "product_attribute_ranks"

    def test_each_row_a_permutation_accepted(self):
        """Rows that are valid permutations of [1..4] pass the distinctness check."""
        state = load_qml_fixture(self.FIXTURE)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        ranks = [
            [1, 2, 3, 4],
            [4, 3, 2, 1],
            [2, 4, 1, 3],
        ]
        result = processor.process_item(state, self.ITEM_ID, ranks, source=SOURCE_RESPONDENT)
        assert result["success"] is True, result

    def test_duplicate_rank_rejected_with_hint(self):
        """A row with duplicate ranks (tie) is rejected with the hint."""
        state = load_qml_fixture(self.FIXTURE)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        ranks = [
            [1, 2, 3, 4],
            [1, 1, 2, 2],  # duplicates — set has size 2, not 4
            [2, 4, 1, 3],
        ]
        result = processor.process_item(state, self.ITEM_ID, ranks, source=SOURCE_RESPONDENT)
        assert result["success"] is False
        assert "rank" in result["message"].lower() or "once" in result["message"].lower()

def _declared_lists_state() -> QMLState:
    """A 2 x 3 Editbox matrix ``m`` whose postcondition bounds every cell
    through ``range(len(m.rows))`` / ``range(len(m.columns))``, a three-question
    group ``qg``, and ``q_after``, gated on folds over all three declared
    lengths."""
    return QMLState(
        {
            "title": "Declared lists",
            "blocks": [{"id": "b1", "title": "B"}],
            "items": [
                {
                    "id": "m",
                    "blockId": "b1",
                    "kind": "MatrixQuestion",
                    "title": "M",
                    "rows": ["r1", "r2"],
                    "columns": ["c1", "c2", "c3"],
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "postcondition": [
                        {
                            "predicate": "all([m.outcome[j][k] <= 5 for j in range(len(m.rows)) "
                            "for k in range(len(m.columns))])",
                            "hint": "at most 5",
                        }
                    ],
                },
                {
                    "id": "qg",
                    "blockId": "b1",
                    "kind": "QuestionGroup",
                    "title": "G",
                    "questions": ["a", "b", "c"],
                    "input": {"control": "Radio", "labels": {1: "y", 2: "n"}},
                },
                {
                    "id": "q_after",
                    "blockId": "b1",
                    "kind": "Question",
                    "title": "After",
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "precondition": [
                        {
                            "predicate": "sum([m.outcome[j][k] for j in range(len(m.rows)) "
                            "for k in range(len(m.columns))]) <= 30 and "
                            "all([qg.outcome[i] != 9 for i in range(len(qg.questions))])"
                        }
                    ],
                },
            ],
        }
    )


@pytest.mark.integration
@pytest.mark.flow
class TestDeclaredListLengthsRuntime:
    """``len(m.rows)``, ``len(m.columns)`` and ``len(qg.questions)`` evaluate
    at runtime to what the Z3 builder unrolled (#1782): ItemProxy exposes the
    declared lists, so a gate the validator proves is not a raise for every
    respondent."""

    def test_a_postcondition_over_the_declared_lengths_is_enforced(self):
        state = _declared_lists_state()
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        over = processor.process_item(state, "m", [[1, 2, 3], [4, 5, 9]], source=SOURCE_RESPONDENT)
        assert over["success"] is False, over
        assert processor.process_item(
            state, "m", [[1, 2, 3], [4, 5, 5]], source=SOURCE_RESPONDENT
        )["success"] is True

    def test_a_gate_on_the_declared_lengths_holds(self):
        state = _declared_lists_state()
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "m", [[1, 1, 1], [1, 1, 1]], source=SOURCE_RESPONDENT)
        processor.process_item(state, "qg", [1, 2, 1], source=SOURCE_RESPONDENT)

        assert processor.get_current_item(state)["id"] == "q_after"
        assert not state.get("warnings")

    def test_the_validator_proves_what_the_runtime_runs(self):
        from askalot_qml.core.qml_engine import QMLEngine
        from askalot_qml.z3 import ItemClassifier

        builder = QMLEngine(_declared_lists_state()).static_builder
        classified = ItemClassifier(builder).classify_all_items()

        assert classified["m"]["postcondition"]["invariant"] == "CONSTRAINING"
        assert not [g for gaps in builder.coverage_gaps.values() for g in gaps if "wide_items" not in g]

    def test_a_comprehension_variable_shadowing_an_item_has_no_declared_list(self):
        """``for qg in range(1)`` rebinds ``qg`` to an int, so
        ``len(qg.questions)`` raises at runtime; Z3 must not read the group's
        declared length through the shadowing name (a comprehension whose
        target names an item does not lower)."""
        from askalot_qml.core.qml_engine import QMLEngine

        state = _declared_lists_state()
        state["items"][2]["precondition"] = [
            {"predicate": "all([len(set([1])) == len(qg.questions) for qg in range(1)])"}
        ]
        builder = QMLEngine(state).static_builder

        assert builder.coverage_gaps.get("q_after")


if __name__ == "__main__":
    pytest.main([__file__, "-v", "-s"])
