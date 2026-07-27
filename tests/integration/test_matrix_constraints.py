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


if __name__ == "__main__":
    pytest.main([__file__, "-v", "-s"])
