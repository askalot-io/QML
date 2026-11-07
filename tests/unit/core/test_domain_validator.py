"""
Unit tests for the per-control runtime domain validator (QML External Inputs, U2).

`outcome_in_domain(item, value)` is the runtime companion to StaticBuilder's
Z3 domain builders — the only check that guards a server-injected external
value against an item's declared control domain (R11 / AE3). These tests pin the
per-control contract, including two deliberate departures from the Z3 model:

- Checkbox is a runtime bitmask (set bits must all be declared label keys), not
  a single-choice enumeration.
- Switch domain is {0, 1} even though the schema gives it `on`/`off`, not labels.

Range is a pair `[low, high]` in domain when `min <= low <= high <= max`; a
scalar, however in-bounds, is not a Range answer.

Also covers the fail-safe surface: None, non-Question kinds, list/nested-list
outcomes, missing input specs, and unknown controls all return False so the
resolver leaves the item to be asked in the normal flow.

A number sent as text is read only in ASCII decimal notation, the Editbox's own (#1824):
`1_0`, Unicode digits, `inf` / `nan` and an int too large for a float are refused, never coerced
or raised.

`answer_refusal(item, value)` applies the same rule to an answer (#1757, #1616):
None is allowed, a Comment takes nothing, a QuestionGroup is one cell per
question at most and a MatrixQuestion rows × columns with each cell in the control's
domain, an item with no judgeable control is not judged, a non-finite number
(NaN) is never in a numeric domain, and the reason never quotes the value. A number names the declared bounds when refused, NaN is out
of every domain, and a decimal is never in an Editbox / Slider domain nor at
either end of a Range (D90, #1801: the schema allows no fractional step).
"""

import pytest
from askalot_qml.core.domain_validator import answer_refusal, outcome_in_domain


def _q(control: str, **input_extra) -> dict:
    return {"id": "q", "kind": "Question", "input": {"control": control, **input_extra}}


@pytest.mark.unit
class TestOutcomeInDomain:
    # ── Radio / Dropdown ────────────────────────────────────────────────
    def test_radio_valid_key(self):
        assert outcome_in_domain(_q("Radio", labels={0: "No", 1: "Yes"}), 1)

    def test_radio_invalid_key(self):
        assert not outcome_in_domain(_q("Radio", labels={0: "No", 1: "Yes"}), 7)

    def test_radio_string_coerced_to_int(self):
        # A source attribute arriving as "1" matches the integer domain 1.
        assert outcome_in_domain(_q("Radio", labels={0: "No", 1: "Yes"}), "1")

    def test_radio_string_key_labels(self):
        # JSONB roundtrip can turn label keys into strings — still matched.
        assert outcome_in_domain(_q("Dropdown", labels={"1": "A", "2": "B"}), 2)

    # ── Switch ──────────────────────────────────────────────────────────
    def test_switch_zero_one(self):
        assert outcome_in_domain(_q("Switch"), 0)
        assert outcome_in_domain(_q("Switch"), 1)

    def test_switch_bool(self):
        assert outcome_in_domain(_q("Switch"), True)
        assert outcome_in_domain(_q("Switch"), False)

    def test_switch_out_of_domain(self):
        assert not outcome_in_domain(_q("Switch"), 2)

    # ── Checkbox (bitmask) ──────────────────────────────────────────────
    def test_checkbox_single_bit(self):
        assert outcome_in_domain(_q("Checkbox", labels={1: "A", 2: "B", 4: "C"}), 4)

    def test_checkbox_combined_bits(self):
        # 1 | 4 = 5 — both bits are declared keys.
        assert outcome_in_domain(_q("Checkbox", labels={1: "A", 2: "B", 4: "C"}), 5)

    def test_checkbox_zero_is_valid(self):
        # No selection (0) is a valid bitmask.
        assert outcome_in_domain(_q("Checkbox", labels={1: "A", 2: "B"}), 0)

    def test_checkbox_undeclared_bit_rejected(self):
        # 8 is not a declared key — reject.
        assert not outcome_in_domain(_q("Checkbox", labels={1: "A", 2: "B", 4: "C"}), 8)

    def test_checkbox_negative_rejected(self):
        assert not outcome_in_domain(_q("Checkbox", labels={1: "A"}), -1)

    def test_checkbox_empty_labels_fails_closed(self):
        # A label-less Checkbox has an empty domain — fail CLOSED (reject any
        # value), matching Radio/Dropdown/Switch, not fail-open. This is the only
        # runtime domain guard, so a degenerate item must not accept an arbitrary
        # integer.
        assert not outcome_in_domain(_q("Checkbox", labels={}), 5)
        assert not outcome_in_domain(_q("Checkbox", labels={}), 0)
        assert not outcome_in_domain(_q("Checkbox"), 999999999)

    # ── Numeric (Editbox / Slider) ──────────────────────────────────────
    def test_editbox_in_range(self):
        assert outcome_in_domain(_q("Editbox", min=18, max=120), 42)

    def test_editbox_below_min(self):
        assert not outcome_in_domain(_q("Editbox", min=18, max=120), 5)

    def test_editbox_above_max(self):
        assert not outcome_in_domain(_q("Editbox", min=18, max=120), 200)

    def test_editbox_boundaries_inclusive(self):
        assert outcome_in_domain(_q("Editbox", min=18, max=120), 18)
        assert outcome_in_domain(_q("Editbox", min=18, max=120), 120)

    def test_slider_string_coerced(self):
        assert outcome_in_domain(_q("Slider", min=0, max=10), "7")

    def test_editbox_only_max_declared(self):
        # A bound not declared is not enforced.
        assert outcome_in_domain(_q("Editbox", max=100), -50)
        assert not outcome_in_domain(_q("Editbox", max=100), 101)

    # ── Range (a pair [low, high], #1474) ───────────────────────────────
    def test_range_pair_in_domain(self):
        """AE1: the pair a respondent can submit is in domain, ends inclusive."""
        item = _q("Range", min=0, max=10)
        assert outcome_in_domain(item, [2, 8])
        assert outcome_in_domain(item, [0, 10])
        assert outcome_in_domain(item, [5, 5])

    def test_range_pair_outside_bounds_rejected(self):
        item = _q("Range", min=0, max=10)
        assert not outcome_in_domain(item, [-1, 3])
        assert not outcome_in_domain(item, [2, 11])

    def test_range_stringified_pair_coerced(self):
        assert outcome_in_domain(_q("Range", min=0, max=10), ["2", "8"])

    def test_range_scalar_rejected(self):
        """A single number is not a Range answer, even one inside [min, max]."""
        item = _q("Range", min=0, max=10)
        assert not outcome_in_domain(item, 5)
        assert not outcome_in_domain(item, "5")

    def test_range_fractional_end_rejected(self):
        """D90 / #1801: Z3 models both ends as Int, so a decimal end is out of
        domain however in-bounds; an integral float is whole."""
        item = _q("Range", min=0, max=10)
        assert not outcome_in_domain(item, [3.5, 4])
        assert not outcome_in_domain(item, [3, "4.5"])
        assert outcome_in_domain(item, [3.0, 4])
        assert answer_refusal(item, [2.5, 7.5]) is not None

    def test_range_malformed_pair_rejected(self):
        item = _q("Range", min=0, max=10)
        for bad in ([3], [1, 2, 3], ["a", 2], [4, None], [True, 2], [8, 2]):
            assert not outcome_in_domain(item, bad), bad

    # ── Textarea ────────────────────────────────────────────────────────
    def test_textarea_string(self):
        assert outcome_in_domain(_q("Textarea"), "free text")

    def test_textarea_non_string_rejected(self):
        # A number for a free-text control is not a valid text answer.
        assert not outcome_in_domain(_q("Textarea"), 5)

    # ── Fail-safe surface ───────────────────────────────────────────────
    def test_none_value_rejected(self):
        assert not outcome_in_domain(_q("Radio", labels={1: "A"}), None)

    def test_non_question_kind_rejected(self):
        item = {"id": "q", "kind": "QuestionGroup", "input": {"control": "Radio"}}
        assert not outcome_in_domain(item, 1)

    def test_comment_rejected(self):
        assert not outcome_in_domain({"id": "c", "kind": "Comment"}, 1)

    def test_missing_input_spec_rejected(self):
        assert not outcome_in_domain({"id": "q", "kind": "Question"}, 1)

    def test_unknown_control_rejected(self):
        assert not outcome_in_domain(_q("Hologram"), 1)

    def test_list_value_for_scalar_rejected(self):
        # A list shape (QuestionGroup-style) is never a valid single-choice answer.
        assert not outcome_in_domain(_q("Radio", labels={1: "A"}), [1])


def _group(control: str, questions: int = 3, **input_extra) -> dict:
    return {
        "id": "qg",
        "kind": "QuestionGroup",
        "questions": [f"Q{i}?" for i in range(questions)],
        "input": {"control": control, **input_extra},
    }


def _matrix(control: str, rows: int = 2, columns: int = 2, **input_extra) -> dict:
    return {
        "id": "m",
        "kind": "MatrixQuestion",
        "rows": [f"R{i}" for i in range(rows)],
        "columns": [f"C{i}" for i in range(columns)],
        "input": {"control": control, **input_extra},
    }


@pytest.mark.unit
class TestAnswerRefusal:
    """#1757 / #1616: the answer gate process_item asks before accepting."""

    def test_in_domain_answers_pass(self):
        for item, value in (
            (_q("Radio", labels={1: "A", 2: "B"}), 2),
            (_q("Slider", min=0, max=10), 10),
            (_q("Switch"), True),
            (_q("Checkbox", labels={1: "a", 2: "b", 4: "c"}), 5),
            (_q("Range", min=0, max=4), [1, 3]),
            (_q("Textarea"), "free text"),
            (_group("Radio", labels={1: "A", 2: "B"}), [1, None, 2]),
            (_matrix("Slider", min=0, max=5), [[0, 5], [None, 3]]),
        ):
            assert answer_refusal(item, value) is None, (item["input"], value)

    def test_none_is_no_answer_and_is_allowed(self):
        assert answer_refusal(_q("Radio", labels={1: "A"}), None) is None

    def test_out_of_domain_answers_are_refused(self):
        for item, value in (
            (_q("Radio", labels={1: "A", 2: "B"}), 7),
            (_q("Slider", min=0, max=10), 99),
            (_q("Editbox", min=0, max=10), "abc"),
            (_q("Switch"), "on"),
            (_q("Checkbox", labels={1: "a", 2: "b"}), 4),
            (_q("Range", min=0, max=4), [1, 9]),
            (_q("Range", min=0, max=4), 2),
            (_q("Textarea"), 5),
            # NaN compares False with both bounds; it must not slip through them.
            (_q("Editbox", min=0, max=10), "nan"),
            (_q("Slider", min=0, max=10), float("nan")),
        ):
            assert answer_refusal(item, value) is not None, (item["input"], value)

    def test_a_group_answer_has_at_most_one_cell_per_question(self):
        item = _group("Radio", labels={1: "A", 2: "B"})
        assert answer_refusal(item, [1, 2]) is None  # the third is unanswered
        assert "3" in answer_refusal(item, [1, 2, 1, 2])
        assert answer_refusal(item, 1) is not None
        assert "question 2" in answer_refusal(item, [1, 9, 1])

    def test_a_matrix_answer_is_rows_by_columns(self):
        item = _matrix("Slider", rows=2, columns=3, min=0, max=5)
        assert answer_refusal(item, [[1, 2, 3]]) is not None
        assert answer_refusal(item, [[1, 2], [3, 4]]) is not None
        assert "row 2, column 3" in answer_refusal(item, [[1, 2, 3], [1, 2, 6]])
        range_matrix = _matrix("Range", min=0, max=4)
        assert answer_refusal(range_matrix, [[[0, 1], None], [[2, 5], [0, 0]]]) is not None

    @pytest.mark.parametrize("text", ["abc", "1_0", "\uff11\uff12", "inf", "nan", "0x1A", "1e400", "9" * 309])
    def test_text_the_editbox_marks_invalid_is_refused_with_the_message(self, text):
        """#1824: the survey's Editbox sends what it marks invalid as text; the
        server reads the same ASCII decimal notation, so each is refused with
        the whole-number message, never coerced (``1_0``, ``１２``) and never a
        500 (an int too large for a float)."""
        assert answer_refusal(_q("Editbox", min=0, max=99), text) == "enter a whole number between 0 and 99"

    @pytest.mark.parametrize("end", ["9" * 400, 10**400])
    def test_a_range_end_too_large_for_a_float_is_refused_not_raised(self, end):
        """#1824: a Range end is an int too large for a float, as text or as a
        JSON number; it is judged by the bounds, never a 500."""
        assert answer_refusal(_q("Range", min=0, max=99), [0, end]) is not None

    @pytest.mark.parametrize("value", [2**53, -(2**53), "9007199254740993", "1e21", 1e21])
    def test_a_number_past_the_browsers_exact_range_is_refused_unbounded_too(self, value):
        """#1824: the Editbox marks a number past ``Number.MAX_SAFE_INTEGER``
        invalid, so the server refuses it even where no bound is declared."""
        assert answer_refusal(_q("Editbox"), value) is not None
        assert answer_refusal(_q("Editbox"), 2**53 - 1) is None

    def test_whole_number_text_is_stored_as_an_int(self):
        """``'1e1'`` and ``'4.0'`` coerce to the ints the box would send."""
        from askalot_qml.core.controls import coerce_scalar

        assert [type(coerce_scalar(t, "Editbox")) for t in ("1e1", "4.0", "3")] == [int, int, int]
        assert coerce_scalar("2.5", "Editbox") == 2.5

    def test_the_server_and_the_editbox_read_one_notation(self):
        """The two patterns are one rule written twice (Python here, the
        survey's ``EditboxControl.js``); a change to either alone fails here."""
        from pathlib import Path

        from askalot_qml.core.controls import DECIMAL_NOTATION

        js = (Path(__file__).resolve().parents[4] / "askalot_common" / "askalot_common" / "web" / "static"
              / "js" / "items" / "controls" / "EditboxControl.js").read_text()
        js_pattern = js.split("const DECIMAL_NOTATION = /^", 1)[1].split("$/;", 1)[0]
        assert js_pattern.replace("(", "(?:").replace("(?:?:", "(?:") == DECIMAL_NOTATION.pattern

    @pytest.mark.parametrize(("text", "number"), [("3", 3), (" 7 ", 7), ("1e1", 10), ("-0", 0), ("4.0", 4)])
    def test_decimal_notation_text_is_read_as_its_number(self, text, number):
        assert answer_refusal(_q("Editbox", min=0, max=99), text) is None
        assert answer_refusal(_q("Editbox", min=number + 1, max=99), text) is not None

    def test_a_number_refusal_names_the_declared_bounds(self):
        assert answer_refusal(_q("Slider", min=0, max=10), 99) == "enter a whole number between 0 and 10"
        assert answer_refusal(_q("Editbox", min=18), 3) == "enter a whole number of at least 18"
        assert answer_refusal(_q("Editbox", max=5), 9) == "enter a whole number of at most 5"

    def test_a_fraction_is_out_of_every_numeric_domain(self):
        """D90: Z3 models Editbox / Slider as Int, and the schema allows no
        fractional step on either (#1801), so 3.5 is always refused."""
        assert answer_refusal(_q("Editbox", min=0, max=10), 3.5) is not None
        assert answer_refusal(_q("Editbox", min=0, max=10), "3.5") is not None
        assert answer_refusal(_q("Editbox", min=0, max=10), 3.0) is None
        assert answer_refusal(_q("Slider", min=0, max=10, step=1), 3.5) is not None
        # A ``step`` the schema would refuse opens nothing either.
        assert answer_refusal(_q("Slider", min=0, max=10, step=0.5), 3.5) is not None
        assert "allowed values" in answer_refusal(_q("Radio", labels={1: "A"}), 7)

    def test_a_comment_takes_no_answer(self):
        assert answer_refusal({"id": "c", "kind": "Comment"}, 1) is not None

    def test_what_cannot_be_judged_is_not_refused(self):
        assert answer_refusal({"id": "q", "kind": "Question"}, 99) is None
        assert answer_refusal(_q("SomeFutureControl"), 99) is None

    def test_the_reason_never_quotes_the_value(self):
        secret = "4242424242"
        for item in (_q("Radio", labels={1: "A"}), _group("Radio", labels={1: "A"}, questions=1)):
            value = secret if item["kind"] == "Question" else [secret]
            assert secret not in answer_refusal(item, value)
