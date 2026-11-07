#!/usr/bin/env python3
"""
Tests for ItemProxy under the native-shape outcome contract (plan 2026-05-05-001).

The contract:

- Question      → bare scalar (int | float | str | bool | None).
                  Checkbox: bitmask int (already reduced upstream by the input
                  boundary parser; ItemProxy does NOT coerce list → bitmask).
- QuestionGroup → List[Any], one cell per entry of the item's `questions`
                  (None pads short answers; a longer list raises, #1616).
- MatrixQuestion→ List[List[Any]] sized by the item's `rows` × `columns`
                  (a wrong count raises, #1616).
- Comment       → None unconditionally.
- Range cell    → None or a pair [low, high] of numbers, low <= high, in all
                  three kinds; each end is coerced, a scalar is never paired.
                  Read as a RangeValue (`.low` / `.high`, no positional alias,
                  #1755) and stored by `to_outcome()` as the pair, including a
                  codeBlock's `q.outcome = [a, b]` write and a cell written in
                  place; comparing it with a list raises instead of a silent
                  False.

Loud failure on legacy dict shapes:
- {"_": v}, {"_0": v0, "_1": v1}, {"_0_0": v} reaching from_outcome → ValueError.
- Any shape mismatch → ValueError.

`to_outcome()` returns the storage shape: self.outcome, except a Range cell
(or a RangeValue a codeBlock put on a non-Range item) becomes its
`[low, high]` pair.
"""

import unittest

import pytest
from askalot_qml.core.controls import RangeValue
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
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": None, "questions": ["Q1?", "Q2?", "Q3?"]}
        proxy = ItemProxy(item)
        self.assertIsNone(proxy.outcome)

    def test_list_outcome(self):
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": [10, 20, 30], "questions": ["Q1?", "Q2?", "Q3?"]}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [10, 20, 30])

    def test_partial_list_padded(self):
        """Shorter list pads with None, one cell per question."""
        item = {
            "id": "qg",
            "kind": "QuestionGroup",
            "outcome": [1, None, "text"],
            "questions": ["Q1?", "Q2?", "Q3?"],
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [1, None, "text"])

    def test_list_too_long_raises(self):
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": [1, 2, 3, 4], "questions": ["Q1?", "Q2?", "Q3?"]}
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_list_short_padded_with_none(self):
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": [1], "questions": ["Q1?", "Q2?", "Q3?"]}
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [1, None, None])

    def test_legacy_dict_raises(self):
        item = {
            "id": "qg",
            "kind": "QuestionGroup",
            "outcome": {"_0": 1, "_1": 2},
            "questions": ["Q1?", "Q2?"],
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_string_values_coerced(self):
        """String-numeric values inside the list are coerced to int/float."""
        item = {
            "id": "qg",
            "kind": "QuestionGroup",
            "outcome": ["10", "20", "30"],
            "questions": ["Q1?", "Q2?", "Q3?"],
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
            "rows": [{"id": "r0"}, {"id": "r1"}],
            "columns": [{"id": "c0"}, {"id": "c1"}],
            "input": {"control": "Radio"},
        }
        proxy = ItemProxy(item)
        self.assertIsNone(proxy.outcome)

    def test_full_2x2(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [[1, 2], [3, 4]],
            "rows": [{"id": "r0"}, {"id": "r1"}],
            "columns": [{"id": "c0"}, {"id": "c1"}],
            "input": {"control": "Radio"},
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
            "rows": [{"id": "r0"}, {"id": "r1"}],
            "columns": [{"id": "c0"}, {"id": "c1"}],
            "input": {"control": "Radio"},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [[1, None], [None, 4]])

    def test_string_values_coerced(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [["1", "2"], ["3", "4"]],
            "rows": [{"id": "r0"}, {"id": "r1"}],
            "columns": [{"id": "c0"}, {"id": "c1"}],
            "input": {"control": "Radio"},
        }
        proxy = ItemProxy(item)
        self.assertEqual(proxy.outcome, [[1, 2], [3, 4]])

    def test_legacy_dict_raises(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": {"_0_0": 1, "_1_1": 4},
            "rows": [{"id": "r0"}, {"id": "r1"}],
            "columns": [{"id": "c0"}, {"id": "c1"}],
            "input": {"control": "Radio"},
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_wrong_row_count_raises(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [[1, 2]],
            "rows": [{"id": "r0"}, {"id": "r1"}],
            "columns": [{"id": "c0"}, {"id": "c1"}],
            "input": {"control": "Radio"},
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_wrong_col_count_raises(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [[1], [2]],
            "rows": [{"id": "r0"}, {"id": "r1"}],
            "columns": [{"id": "c0"}, {"id": "c1"}],
            "input": {"control": "Radio"},
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_non_nested_list_raises(self):
        item = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": [1, 2, 3, 4],
            "rows": [{"id": "r0"}, {"id": "r1"}],
            "columns": [{"id": "c0"}, {"id": "c1"}],
            "input": {"control": "Radio"},
        }
        with self.assertRaises(ValueError):
            ItemProxy(item)


def _range_question(outcome, **input_extra):
    return {
        "id": "q_range",
        "kind": "Question",
        "outcome": outcome,
        "input": {"control": "Range", "min": 0, "max": 10, **input_extra},
    }


def _range_group(outcome):
    # Production shape: the loader keeps `questions` on the item, not `input.count`.
    return {
        "id": "qg_range",
        "kind": "QuestionGroup",
        "questions": ["First?", "Second?", "Third?"],
        "outcome": outcome,
        "input": {"control": "Range", "min": 0, "max": 100},
    }


def _range_matrix(outcome):
    # Production shape: `rows` / `columns` sit on the item as plain strings.
    return {
        "id": "mq_range",
        "kind": "MatrixQuestion",
        "rows": ["English", "Spanish", "French", "German", "Italian"],
        "columns": ["Mother", "Father", "Sister", "Brother"],
        "outcome": outcome,
        "input": {"control": "Range", "min": 0, "max": 6},
    }


@pytest.mark.unit
@pytest.mark.models
class TestRangeShape(unittest.TestCase):
    """Range cell: None or a pair [low, high] of numbers with low <= high (#1474),
    read as a ``RangeValue`` with named ends and stored as the pair (#1755).

    ItemProxy coerces each end but never builds a pair from anything else, in
    every kind that can carry a Range control.
    """

    def test_pair_round_trips(self):
        """AE1: the pair the respondent chose is stored unchanged, and read
        with named ends (#1755)."""
        proxy = ItemProxy(_range_question([2, 8]))
        self.assertEqual(proxy.outcome, RangeValue(2, 8))
        self.assertEqual((proxy.outcome.low, proxy.outcome.high), (2, 8))
        self.assertEqual(proxy.to_outcome(), [2, 8])

    def test_a_positional_read_is_refused(self):
        """#1755: no positional alias; the error names the ends."""
        proxy = ItemProxy(_range_question([2, 8]))
        for index in (0, 1):
            with self.subTest(index=index), self.assertRaises(TypeError) as exc:
                proxy.outcome[index]
            self.assertIn(".low / .high", str(exc.exception))

    def test_a_code_block_pair_write_is_read_by_name_and_stored_as_a_pair(self):
        """``q.outcome = [a, b]`` is the codeBlock write form (D89): the proxy
        reads it by name at once, stores the pair, and refuses a malformed one
        at the write."""
        proxy = ItemProxy(_range_question([2, 8]))
        proxy.outcome = ["1", 3]
        self.assertEqual(proxy.outcome.low, 1)
        self.assertEqual(proxy.to_outcome(), [1, 3])
        with self.assertRaises(ValueError) as exc:
            proxy.outcome = [5, 1]
        self.assertIn("q_range", str(exc.exception))

    def test_roster_iterations_of_every_range_kind_read_by_name(self):
        """``outcomes[K]`` of a Range Question, QuestionGroup or matrix inside a
        Roster reads its cells with named ends too."""
        for item, stored, read in (
            (_range_question(None), [1, 4], lambda v: v.high),
            (_range_group(None), [[0, 2], None, [3, 5]], lambda v: v[2].high),
            (_range_matrix(None), [[[0, 1]] * 4] * 5, lambda v: v[4][3].low),
        ):
            with self.subTest(kind=item["kind"]):
                item = {**item, "_roster_block_id": "per_member"}
                proxy = ItemProxy(item, roster_outcomes_for_block={1: {item["id"]: stored}})
                self.assertIn(read(proxy.outcomes[1]), (0, 4, 5))

    def test_none_is_unanswered(self):
        self.assertIsNone(ItemProxy(_range_question(None)).outcome)

    def test_equal_ends_are_a_pair(self):
        self.assertEqual(ItemProxy(_range_question([5, 5])).to_outcome(), [5, 5])

    def test_stringified_ends_are_coerced(self):
        proxy = ItemProxy(_range_question(["2", "8"]))
        self.assertEqual(proxy.to_outcome(), [2, 8])
        self.assertTrue(all(type(end) is int for end in proxy.to_outcome()))

    def test_fractional_ends_are_kept(self):
        proxy = ItemProxy(_range_question([2.5, 3]))
        self.assertEqual(proxy.outcome, RangeValue(2.5, 3))

    def test_malformed_cells_are_refused(self):
        for bad in (
            7,  # a scalar is never turned into a pair
            "7",
            [3],
            [1, 2, 3],
            [],
            ["a", 2],
            [4, None],
            [None, None],
            [True, 2],  # a bool is not a number
            [8, 2],  # low > high
            ["nan", "nan"],
            {"low": 2, "high": 8},
            (2, 8),
        ):
            with self.subTest(bad=bad):
                with self.assertRaises(ValueError) as exc:
                    ItemProxy(_range_question(bad))
                self.assertIn("q_range", str(exc.exception))

    def test_group_of_pairs(self):
        proxy = ItemProxy(_range_group([[1, 2], None, [0, 0]]))
        self.assertEqual(proxy.outcome, [RangeValue(1, 2), None, RangeValue(0, 0)])
        self.assertEqual(proxy.to_outcome(), [[1, 2], None, [0, 0]])

    def test_group_with_a_scalar_cell_is_refused(self):
        with self.assertRaises(ValueError) as exc:
            ItemProxy(_range_group([[1, 2], 5]))
        self.assertIn("qg_range", str(exc.exception))

    def test_matrix_of_pairs(self):
        grid = [[[r, r + c] for c in range(4)] for r in range(5)]
        grid[1][2] = None
        proxy = ItemProxy(_range_matrix(grid))
        self.assertEqual(proxy.outcome[2][3].low, 2)
        self.assertEqual(proxy.outcome[2][3].high, 5)
        self.assertIsNone(proxy.outcome[1][2])
        self.assertEqual(proxy.to_outcome(), grid)

    def test_matrix_with_a_scalar_cell_is_refused(self):
        grid = [[[0, 1] for _ in range(4)] for _ in range(5)]
        grid[3][1] = 4
        with self.assertRaises(ValueError) as exc:
            ItemProxy(_range_matrix(grid))
        self.assertIn("mq_range", str(exc.exception))

    def test_a_range_matrix_with_a_wrong_row_count_is_refused(self):
        """#1616: the matrix shape reads the item's own rows / columns."""
        with self.assertRaises(ValueError) as exc:
            ItemProxy(_range_matrix([[[0, 1]] * 4] * 4))
        self.assertIn("row count 4", str(exc.exception))

    def test_a_malformed_list_write_is_refused_at_the_write(self):
        """#1616: a codeBlock's group / matrix assignment is shape-checked by
        the setter, so it fails where it was written."""
        matrix = ItemProxy(_range_matrix(None))
        with self.assertRaises(ValueError) as exc:
            matrix.outcome = [[[0, 1]] * 4]
        self.assertIn("mq_range", str(exc.exception))
        group = ItemProxy(_range_group(None))
        group.outcome = [[0, 1]]  # short: the rest unanswered
        with self.assertRaises(ValueError):
            group.outcome = [[0, 1]] * 4

    def test_a_non_range_question_still_refuses_a_list(self):
        item = {"id": "q", "kind": "Question", "outcome": [2, 8], "input": {"control": "Slider"}}
        with self.assertRaises(ValueError):
            ItemProxy(item)

    def test_a_cell_written_in_place_is_checked_and_stored_as_a_pair(self):
        """A codeBlock writing one cell in place (``qg.outcome[i] = [a, b]``)
        never passes the setter; the write-back still stores the pair, and
        refuses a malformed one naming the item and the cell."""
        group = ItemProxy(_range_group([[1, 2], None, None]))
        group.outcome[1] = ["3", 4]
        self.assertEqual(group.to_outcome(), [[1, 2], [3, 4], None])
        grid = [[[0, 1] for _ in range(4)] for _ in range(5)]
        matrix = ItemProxy(_range_matrix(grid))
        matrix.outcome[2][3] = [5, 6]
        self.assertEqual(matrix.to_outcome()[2][3], [5, 6])
        matrix.outcome[0][1] = [6, 5]
        with self.assertRaises(ValueError) as exc:
            matrix.to_outcome()
        self.assertIn("mq_range", str(exc.exception))
        self.assertIn("row 0, column 1", str(exc.exception))

    def test_comparing_with_the_stored_list_raises(self):
        """``q.outcome == [2, 8]`` would otherwise be a silent False, a gate
        that never holds; it raises, like a positional read."""
        proxy = ItemProxy(_range_question([2, 8]))
        for written in (lambda v: v == [2, 8], lambda v: [2, 8] != v, lambda v: v == (2, 8)):
            with self.subTest(), self.assertRaises(TypeError) as exc:
                written(proxy.outcome)
            self.assertIn(".low / .high", str(exc.exception))
        self.assertEqual(proxy.outcome, RangeValue(2, 8))
        self.assertNotEqual(proxy.outcome, None)

    def test_a_range_value_assigned_to_another_item_is_stored_as_a_pair(self):
        """``other.outcome = q.outcome`` on a non-Range item stores the pair, so
        no dataclass reaches the JSON survey state."""
        source = ItemProxy(_range_question([2, 8]))
        other = ItemProxy({"id": "q_copy", "kind": "Question", "outcome": None, "input": {}})
        other.outcome = source.outcome
        self.assertEqual(other.to_outcome(), [2, 8])


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
        item = {"id": "qg", "kind": "QuestionGroup", "outcome": [1, None, 3], "questions": ["Q1?", "Q2?", "Q3?"]}
        a = ItemProxy(item)
        item2 = {
            "id": "qg",
            "kind": "QuestionGroup",
            "outcome": a.to_outcome(),
            "questions": ["Q1?", "Q2?", "Q3?"],
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
            "rows": rows,
            "columns": cols,
            "input": {"control": "Radio"},
        }
        a = ItemProxy(item)
        item2 = {
            "id": "mq",
            "kind": "MatrixQuestion",
            "outcome": a.to_outcome(),
            "rows": rows,
            "columns": cols,
            "input": {"control": "Radio"},
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
                "control": "Radio",
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
