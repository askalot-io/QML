#!/usr/bin/env python3
"""
Tests for ItemProxy under the native-shape outcome contract (plan 2026-05-05-001).

The contract:

- Question      → bare scalar (int | float | str | bool | None).
                  Checkbox: bitmask int (already reduced upstream by the input
                  boundary parser; ItemProxy does NOT coerce list → bitmask).
- QuestionGroup → List[Any] of length input.count (None pads short answers).
- MatrixQuestion→ List[List[Any]] sized rows × cols.
- Comment       → None unconditionally.

Loud failure on legacy dict shapes:
- {"_": v}, {"_0": v0, "_1": v1}, {"_0_0": v} reaching from_outcome → ValueError.
- Any shape mismatch → ValueError.

`to_outcome()` is a trivial accessor returning self.outcome (Optional[Any]).
"""

import unittest

import pytest
from askalot_qml.models.item_proxy import ItemProxy


@pytest.mark.unit
@pytest.mark.models
class TestQuestionShape(unittest.TestCase):
    """Question kind: bare scalar in/out."""

    def test_none_outcome(self):
        item = {
            "id": "q1",
            "kind": "Question",
            "outcome": None,
            "input": {"control": "Editbox", "min": 0, "max": 100},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.id, "q1")
        self.assertEqual(proxy.kind, "Question")
        self.assertIsNone(proxy.outcome)
        self.assertEqual(proxy.min, 0)
        self.assertEqual(proxy.max, 100)

    def test_int_outcome(self):
        item = {"id": "q1", "kind": "Question", "outcome": 42, "input": {"control": "Editbox"}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, 42)

    def test_float_outcome(self):
        item = {"id": "q1", "kind": "Question", "outcome": 3.14, "input": {"control": "Slider"}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, 3.14)

    def test_string_outcome_textarea(self):
        item = {
            "id": "q1",
            "kind": "Question",
            "outcome": "hello world",
            "input": {"control": "Textarea"},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, "hello world")

    def test_bool_outcome_switch(self):
        item = {"id": "q1", "kind": "Question", "outcome": True, "input": {"control": "Switch"}}
        proxy = ItemProxy(item)
        self.assertIs(proxy.outcome, True)

    def test_checkbox_bitmask_int(self):
        """Checkbox arrives as bitmask int (already reduced upstream)."""
        item = {
            "id": "q",
            "kind": "Question",
            "outcome": 5,
            "input": {"control": "Checkbox", "labels": {1: "Breakfast", 2: "Lunch", 4: "Dinner"}},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, 5)

    def test_checkbox_list_raises(self):
        """List for a Checkbox is rejected — coercion is the input parser's job, not ItemProxy's."""
        item = {
            "id": "q",
            "kind": "Question",
            "outcome": [1, 4],
            "input": {"control": "Checkbox", "labels": {1: "Breakfast", 2: "Lunch", 4: "Dinner"}},
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_legacy_dict_raises(self):
        """Legacy {"_": value} reaches Question's from_outcome → ValueError."""
        item = {
            "id": "q1",
            "kind": "Question",
            "outcome": {"_": 42},
            "input": {"control": "Editbox"},
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)


@pytest.mark.unit
@pytest.mark.models
class TestQuestionGroupShape(unittest.TestCase):
    """QuestionGroup kind: native list."""

    def test_none_outcome(self):
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": None, "input": {"count": 3}}
        proxy = ItemProxy(item)
        self.assertIsNone(proxy.outcome)

    def test_list_outcome(self):
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": [10, 20, 30], "input": {"count": 3}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [10, 20, 30])

    def test_partial_list_padded(self):
        """Shorter list pads with None to reach input.count."""
        item = {
            "id": "qg",
            "kind": "QuestionGroup",
            "outcome": [1, None, "text"],
            "input": {"count": 3},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [1, None, "text"])

    def test_list_too_long_raises(self):
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": [1, 2, 3, 4], "input": {"count": 3}}
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_list_short_padded_with_none(self):
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": [1], "input": {"count": 3}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [1, None, None])

    def test_legacy_dict_raises(self):
        item = {
            "id": "qg",
            "kind": "QuestionGroup",
            "outcome": {"_0": 1, "_1": 2},
            "input": {"count": 2},
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_string_values_coerced(self):
        """String-numeric values inside the list are coerced to int/float."""
        item = {
            "id": "qg",
            "kind": "QuestionGroup",
            "outcome": ["10", "20", "30"],
            "input": {"count": 3},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [10, 20, 30])


@pytest.mark.unit
@pytest.mark.models
class TestMatrixQuestionShape(unittest.TestCase):
    """MatrixQuestion kind: nested list."""

    def test_none_outcome(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": None,
            "input": {
                "control": "RadioMatrix",
                "rows": [{"id": "r0"}, {"id": "r1"}],
                "columns": [{"id": "c0"}, {"id": "c1"}],
            },
        }
        proxy = ItemProxy(item)
        self.assertIsNone(proxy.outcome)

    def test_full_2x2(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [[1, 2], [3, 4]],
            "input": {
                "control": "RadioMatrix",
                "rows": [{"id": "r0"}, {"id": "r1"}],
                "columns": [{"id": "c0"}, {"id": "c1"}],
            },
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [[1, 2], [3, 4]])
        self.assertEqual(proxy.outcome[0][0], 1)
        self.assertEqual(proxy.outcome[1][1], 4)

    def test_diagonal_with_nones(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [[1, None], [None, 4]],
            "input": {
                "control": "RadioMatrix",
                "rows": [{"id": "r0"}, {"id": "r1"}],
                "columns": [{"id": "c0"}, {"id": "c1"}],
            },
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [[1, None], [None, 4]])

    def test_string_values_coerced(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [["1", "2"], ["3", "4"]],
            "input": {
                "control": "RadioMatrix",
                "rows": [{"id": "r0"}, {"id": "r1"}],
                "columns": [{"id": "c0"}, {"id": "c1"}],
            },
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [[1, 2], [3, 4]])

    def test_legacy_dict_raises(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": {"_0_0": 1, "_1_1": 4},
            "input": {
                "control": "RadioMatrix",
                "rows": [{"id": "r0"}, {"id": "r1"}],
                "columns": [{"id": "c0"}, {"id": "c1"}],
            },
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_wrong_row_count_raises(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [[1, 2]],
            "input": {
                "control": "RadioMatrix",
                "rows": [{"id": "r0"}, {"id": "r1"}],
                "columns": [{"id": "c0"}, {"id": "c1"}],
            },
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_wrong_col_count_raises(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [[1], [2]],
            "input": {
                "control": "RadioMatrix",
                "rows": [{"id": "r0"}, {"id": "r1"}],
                "columns": [{"id": "c0"}, {"id": "c1"}],
            },
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_non_nested_list_raises(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [1, 2, 3, 4],
            "input": {
                "control": "RadioMatrix",
                "rows": [{"id": "r0"}, {"id": "r1"}],
                "columns": [{"id": "c0"}, {"id": "c1"}],
            },
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)


@pytest.mark.unit
@pytest.mark.models
class TestCommentShape(unittest.TestCase):
    """Comment kind: always None."""

    def test_comment_none(self):
        item = {"id": "c1", "kind": "Comment", "outcome": None, "input": {}}
        proxy = ItemProxy(item)
        self.assertIsNone(proxy.outcome)

    def test_comment_drops_legacy_empty_dict(self):
        """{} legacy form is gone; Comment unconditionally → None."""
        item = {"id": "c1", "kind": "Comment", "outcome": {}, "input": {}}
        proxy = ItemProxy(item)
        self.assertIsNone(proxy.outcome)


@pytest.mark.unit
@pytest.mark.models
class TestRoundTrip(unittest.TestCase):
    """to_outcome → from_outcome on a fresh proxy preserves shape and values."""

    def test_question_round_trip(self):
        item = {"id": "q", "kind": "Question", "outcome": 42, "input": {"control": "Editbox"}}
        a = ItemProxy(item)
        item2 = {
            "id": "q",
            "kind": "Question",
            "outcome": a.to_outcome(),
            "input": {"control": "Editbox"},
        }
        b = ItemProxy(item2)
        self.assertEqual(b.outcome, 42)

    def test_question_group_round_trip(self):
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": [1, None, 3], "input": {"count": 3}}
        a = ItemProxy(item)
        item2 = {
            "id": "qg",
            "kind": "QuestionGroup",
            "outcome": a.to_outcome(),
            "input": {"count": 3},
        }
        b = ItemProxy(item2)
        self.assertEqual(b.outcome, [1, None, 3])

    def test_matrix_round_trip(self):
        rows = [{"id": "r0"}, {"id": "r1"}]
        cols = [{"id": "c0"}, {"id": "c1"}]
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [[1, None], [None, 4]],
            "input": {"control": "RadioMatrix", "rows": rows, "columns": cols},
        }
        a = ItemProxy(item)
        item2 = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": a.to_outcome(),
            "input": {"control": "RadioMatrix", "rows": rows, "columns": cols},
        }
        b = ItemProxy(item2)
        self.assertEqual(b.outcome, [[1, None], [None, 4]])

    def test_checkbox_bitmask_round_trip_into_iterate_over(self):
        """Covers R6 / origin Success bullet 5: Checkbox bitmask 5 round-trips unchanged."""
        item = {
            "id": "q_meals_eaten",
            "kind": "Question",
            "outcome": 5,
            "input": {"control": "Checkbox", "labels": {1: "Breakfast", 2: "Lunch", 4: "Dinner"}},
        }
        a = ItemProxy(item)
        self.assertEqual(a.outcome, 5)
        item2 = {
            "id": "q_meals_eaten",
            "kind": "Question",
            "outcome": a.to_outcome(),
            "input": {"control": "Checkbox", "labels": {1: "Breakfast", 2: "Lunch", 4: "Dinner"}},
        }
        b = ItemProxy(item2)
        self.assertEqual(b.outcome, 5)


@pytest.mark.unit
@pytest.mark.models
class TestPropertyExtraction(unittest.TestCase):
    """Item.input properties surface on the proxy unchanged by the refactor."""

    def test_min_max_step(self):
        item = {
            "id": "q1",
            "kind": "Question",
            "outcome": None,
            "input": {"control": "Slider", "min": 0, "max": 100, "step": 5},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.min, 0)
        self.assertEqual(proxy.max, 100)
        self.assertEqual(proxy.step, 5)
        self.assertIn("min", proxy.input_props)

    def test_labels(self):
        item = {
            "id": "q1",
            "kind": "Question",
            "outcome": None,
            "input": {
                "control": "RadioButton",
                "labels": {"1": "Strongly Disagree", "5": "Strongly Agree"},
            },
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.labels["5"], "Strongly Agree")

    def test_on_off(self):
        item = {
            "id": "q1",
            "kind": "Question",
            "outcome": None,
            "input": {"control": "Toggle", "on": "Yes", "off": "No", "default": True},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.on, "Yes")
        self.assertEqual(proxy.off, "No")
        self.assertEqual(proxy.default, True)

    def test_control_stored(self):
        item = {"id": "q1", "kind": "Question", "outcome": None, "input": {"control": "DatePicker"}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.control, "DatePicker")

    def test_repr(self):
        item = {"id": "test_q", "kind": "Question", "outcome": 42, "input": {"control": "Editbox"}}
        proxy = ItemProxy(item)
        s = repr(proxy)
        self.assertIn("test_q", s)
        self.assertIn("42", s)


@pytest.mark.unit
@pytest.mark.models
class TestStringCoercion(unittest.TestCase):
    """String-numeric coercion preserved (orthogonal to shape)."""

    def test_string_int_outcome_coerced(self):
        item = {"id": "q1", "kind": "Question", "outcome": "7", "input": {"control": "Radio"}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, 7)
        self.assertIsInstance(proxy.outcome, int)

    def test_string_float_outcome_coerced(self):
        item = {"id": "q1", "kind": "Question", "outcome": "3.14", "input": {"control": "Slider"}}
        proxy = ItemProxy(item)
        self.assertAlmostEqual(proxy.outcome, 3.14)
        self.assertIsInstance(proxy.outcome, float)

    def test_textarea_string_preserved(self):
        item = {
            "id": "q1",
            "kind": "Question",
            "outcome": "hello",
            "input": {"control": "Textarea"},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, "hello")

    def test_textarea_numeric_string_not_coerced(self):
        item = {"id": "q1", "kind": "Question", "outcome": "42", "input": {"control": "Textarea"}}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, "42")
        self.assertIsInstance(proxy.outcome, str)


if __name__ == "__main__":
    unittest.main()
