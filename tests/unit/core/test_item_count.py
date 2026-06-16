"""
Unit tests for the shared questionnaire item-count helper.

Tests ``questionnaire_item_count`` (askalot_qml.core.item_count), which both
Targetor and Portor use to gate the free-tier 30-item cap (plan 2026-06-14-001,
KTD3). The pinned definition: the count is the number of TOP-LEVEL items, where
every item counts as exactly 1 regardless of kind — a Comment, a Question, a
QuestionGroup, and a MatrixQuestion each count as 1. Composites are NOT expanded
into their sub-questions, rows, or cells, so the count is simply len(items).

Covered scenarios:
- A flat questionnaire (only Questions + a Comment) counts every item as 1.
- A MatrixQuestion counts as a single item, not its rows or cells.
- A QuestionGroup counts as a single item, not its sub-questions.
- A mixed questionnaire lands exactly on the 30-item boundary.
- A missing QML file fails loud (FileNotFoundError), never a silent 0.
- Malformed QML fails loud (ValidationError), never a silent 0.

These are unit tests over real QML fixtures (no mocks) — the helper's whole job
is to read real QML the way the loader does, so fixtures exercise the genuine
parse-and-flatten path.
"""

from pathlib import Path

import pytest
from askalot_qml.core import questionnaire_item_count
from jsonschema import ValidationError

FIXTURES_DIR = Path(__file__).parent.parent.parent / "fixtures"


@pytest.mark.unit
class TestQuestionnaireItemCount:
    """Top-level item-count behaviour across the four QML item kinds and failure modes."""

    def test_flat_questionnaire_counts_each_item(self):
        """item_count_flat.qml has 3 Questions + 1 Comment -> 4 top-level items."""
        assert questionnaire_item_count(FIXTURES_DIR, "item_count_flat.qml") == 4

    def test_matrix_counts_as_one_item(self):
        """matrix_ranking.qml is a single MatrixQuestion -> 1 (not expanded)."""
        assert questionnaire_item_count(FIXTURES_DIR, "matrix_ranking.qml") == 1

    def test_question_group_counts_as_one_item(self):
        """question_group.qml: QuestionGroup(1) + Question(1) + Comment(1) -> 3."""
        assert questionnaire_item_count(FIXTURES_DIR, "question_group.qml") == 3

    def test_boundary_exactly_thirty(self):
        """Mixed fixture (1 matrix + 1 group + 1 comment + 27 questions) -> 30 items."""
        assert questionnaire_item_count(FIXTURES_DIR, "item_count_boundary_30.qml") == 30

    def test_missing_file_fails_loud(self):
        """A missing QML file raises FileNotFoundError, not a silent 0."""
        with pytest.raises(FileNotFoundError):
            questionnaire_item_count(FIXTURES_DIR, "does_not_exist.qml")

    def test_malformed_qml_fails_loud(self, tmp_path):
        """QML that violates the schema raises, never silently returns 0."""
        bad = tmp_path / "bad.qml"
        # 'kind' is mandatory on every block; omitting it is a schema violation.
        bad.write_text(
            "questionnaire:\n"
            "  title: Broken\n"
            "  blocks:\n"
            "    - id: b1\n"
            "      title: No kind here\n"
            "      items:\n"
            "        - id: q1\n"
            "          kind: Question\n"
            "          title: Q\n"
            "          input:\n"
            "            control: Radio\n"
            "            labels:\n"
            "              1: Yes\n"
            "              2: No\n"
        )
        with pytest.raises(ValidationError):
            questionnaire_item_count(tmp_path, "bad.qml")
