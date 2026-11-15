#!/usr/bin/env python3
"""Integration tests proving static Z3 validation classifies matrix postconditions.

Verifies the three documented matrix patterns (symmetry, fixed-sum,
ranking/distinctness) reach the static validator as ``CONSTRAINING``
classifications under ``ItemClassifier``. The runtime side is covered by
``test_matrix_constraints.py``.

A Range matrix cell is a ``[low, high]`` pair (#1474,
``fixtures/range_matrix.qml``): each cell holds two bounded variables,
``m.outcome[j][k].low|high`` with literal indices is proven over them (#1755),
and a fold over Range cells, a bare cell compared as a number or a positional
end (``m.outcome[j][k][0]``) is a coverage gap naming the matrix.

Static-builder language support relied on:
- ``ast.Subscript`` two-level reads (``X.outcome[j][k]``)
- ``ast.ListComp`` / ``GeneratorExp`` static unrolling
- Fold lowering: ``sum`` → ``z3.Sum``, ``all`` / ``any`` → ``z3.And`` / ``z3.Or``,
  ``len(set([…])) == k`` → ``z3.Distinct``
- Two-arg ``range(start, stop)``
- Per-cell ``item_{id}@{r}@{c}`` Z3 variables for ``MatrixQuestion`` items
  (``item_{id}@{r}@{c}@lo`` / ``@hi`` for a Range matrix)

A read of a whole matrix answer or a whole row (``m.outcome == 1``,
``m.outcome[0] == [1, 2]``) has no variable to lower to and is a coverage gap
carrying ``matrix_items`` (#1781); a cell read and a None test record none.

A cell read of a matrix a codeBlock writes still raises on the whole answer's
skip and is unknown on its blank (#2256), so a gate reading it is
CONDITIONAL, as every walk of the runtime agrees.

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
    hold 999 in a cell is in a parallel universe where Z3 lies. Its check
    refuses a blank matrix and an empty cell, which would otherwise waive it
    (#1780)."""

    def test_infeasible_cell_postcondition_is_infeasible(self):
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


@pytest.mark.integration
@pytest.mark.z3
class TestRangeMatrixEnds:
    """A Range matrix cell is a ``[low, high]`` pair (#1474) with named ends
    (#1755): two variables per cell, ``m.outcome[j][k].low|high`` proven over
    them, and every other read of a Range cell (a positional end included) a
    coverage gap rather than a dropped condition."""

    def _classify(self):
        engine = create_engine("range_matrix.qml")
        builder = engine.static_builder
        return builder, ItemClassifier(builder).classify_all_items()

    def test_each_cell_holds_two_bounded_ends(self):
        from z3 import Solver, unsat

        builder, _ = self._classify()
        names = builder.get_all_z3_vars()
        lo, hi = names["item_m@1@2@lo"], names["item_m@1@2@hi"]
        assert "item_m@1@2" not in names
        for escape in (lo < 0, hi > 10, lo > hi):
            solver = Solver(ctx=builder.ctx)
            solver.add(builder.get_domain_base(), escape)
            assert solver.check() == unsat, str(escape)

    def test_end_reads_are_proven(self):
        builder, classifications = self._classify()

        assert classifications["q_inverted"]["precondition"]["status"] == "NEVER"
        assert classifications["q_low_high"]["precondition"]["status"] == "CONDITIONAL"
        assert "q_inverted" not in builder.coverage_gaps
        assert "q_low_high" not in builder.coverage_gaps

    def test_a_fold_a_bare_cell_and_a_positional_end_are_coverage_gaps(self):
        builder, classifications = self._classify()

        for item_id in ("q_fold", "q_bare", "q_positional"):
            gaps = builder.coverage_gaps.get(item_id, [])
            assert [g["range_items"] for g in gaps] == [["m"]], (item_id, gaps)
            assert classifications[item_id]["precondition"]["status"] != "NEVER"


def _engine_with_readers(predicates: dict[str, str]) -> QMLEngine:
    """``matrix_infeasible_sum.qml`` (2 x 2 Editbox ``impossible_budget``) plus
    one Editbox Question per entry of *predicates*, gated on its predicate."""
    loader = QMLLoader(schema_path=None)
    data = loader.load_from_path(str(FIXTURES_DIR / "matrix_infeasible_sum.qml"))
    block_id = data["items"][0]["blockId"]
    for item_id, predicate in predicates.items():
        data["items"].append(
            {
                "id": item_id,
                "blockId": block_id,
                "kind": "Question",
                "title": item_id,
                "input": {"control": "Editbox", "min": 0, "max": 10},
                "precondition": [{"predicate": predicate}],
            }
        )
    return QMLEngine(QMLState(data))


@pytest.mark.integration
@pytest.mark.z3
class TestWholeMatrixReadsAreGaps:
    """A matrix is one variable per cell (#1781): a read of the whole answer
    or of a whole row has nothing to lower to, and is a coverage gap naming
    the matrix rather than a condition silently dropped."""

    READERS = {
        "q_bare": "impossible_budget.outcome == 1",
        "q_truth": "not impossible_budget.outcome",
        "q_row": "impossible_budget.outcome[0] == [1, 2]",
        "q_row_set": "len(set(impossible_budget.outcome[0])) == 2",
        "q_cell": "impossible_budget.outcome[0][0] > 3",
        "q_none": "impossible_budget.outcome is not None",
    }

    def test_whole_and_row_reads_record_a_gap_naming_the_matrix(self):
        builder = _engine_with_readers(self.READERS).static_builder

        for item_id in ("q_bare", "q_truth", "q_row", "q_row_set"):
            gaps = builder.coverage_gaps.get(item_id, [])
            assert [g.get("matrix_items") for g in gaps] == [["impossible_budget"]], (item_id, gaps)
        for item_id in ("q_cell", "q_none"):
            assert not builder.coverage_gaps.get(item_id), item_id

    def test_the_warning_names_the_matrix_and_the_cell_form(self):
        from askalot_qml.core.validation_processor import ValidationProcessor

        state = _engine_with_readers({"q_bare": self.READERS["q_bare"]}).state
        issues = [
            issue
            for issue in ValidationProcessor(state).to_issues()
            if issue["type"] == "skipped_condition" and issue["item_id"] == "q_bare"
        ]
        assert len(issues) == 1, issues
        assert "MatrixQuestion 'impossible_budget'" in issues[0]["message"]
        assert "m.outcome[j][k]" in issues[0]["suggestion"]



@pytest.mark.integration
@pytest.mark.z3
class TestCodeWrittenGatedMatrixCellRead:
    """A gated matrix a codeBlock writes is still ``None`` where its gate
    skipped it (#2256): a cell read of it raises at runtime (``None[1]``), so
    a gate reading one is not ALWAYS. Walked through the runtime too."""

    @staticmethod
    def _judge(matrix_gate: str | None):
        """``a`` Textarea; ``b`` a 2 x 1 Radio matrix whose codeBlock writes
        one cell, gated on ``matrix_gate``; ``c`` gated on another cell of
        ``b``. Checked against every walk of the runtime first."""
        from askalot_qml.core.validation_processor import ValidationProcessor

        from tests.helpers.soundness_fuzz import unsound

        radio = {"control": "Radio", "labels": {1: "one", 2: "two"}}
        matrix = {
            "id": "b",
            "kind": "MatrixQuestion",
            "rows": ["r1", "r2"],
            "columns": ["c1"],
            "input": radio,
            "codeBlock": "b.outcome[0][0] = 1",
        }
        if matrix_gate is not None:
            matrix["precondition"] = [{"predicate": matrix_gate}]
        items = [
            {"id": "a", "kind": "Question", "input": {"control": "Textarea"}},
            matrix,
            {"id": "c", "kind": "Question", "input": radio, "precondition": [{"predicate": "b.outcome[1][0] != 7"}]},
        ]
        doc = {
            "title": "written matrix",
            "blocks": [{"id": "b1", "kind": "Group", "title": "B"}],
            "items": [{"blockId": "b1", "title": item["id"], **item} for item in items],
        }
        assert unsound(doc) == []
        processor = ValidationProcessor(QMLState(doc))
        return processor.get_item_classifications(), processor.engine.static_builder

    def test_a_cell_read_of_a_skipped_written_matrix_is_not_always(self):
        """Fuzzer seed 5119's shape: ``b``'s gate never holds, so every walk
        skips ``b`` and then ``c``: the read raises on ``b``'s skip."""
        classifications, builder = self._judge('a.outcome == "never typed"')

        assert classifications["c"]["precondition"]["status"] == "CONDITIONAL"
        assert builder.skip_choice("b") is not None

    def test_a_cell_read_of_a_blank_written_matrix_is_not_always(self):
        """Ungated, ``b`` may be submitted blank: its codeBlock then raises
        (``None[0]``) and ``c``'s leaf reads it unknown, so ``c`` is skipped."""
        classifications, builder = self._judge(None)

        assert classifications["c"]["precondition"]["status"] == "CONDITIONAL"
        assert builder.blank_choice("b") is not None


if __name__ == "__main__":
    pytest.main([__file__, "-v", "-s"])
