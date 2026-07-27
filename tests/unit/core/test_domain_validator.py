"""
Unit tests for the per-control runtime domain validator (QML External Inputs, U2).

`outcome_in_domain(item, value)` is the runtime companion to StaticBuilder's
Z3 domain builders — the only check that guards a server-injected external
value against an item's declared control domain (R11 / AE3). These tests pin the
per-control contract, including two deliberate departures from the Z3 model:

- Checkbox is a runtime bitmask (set bits must all be declared label keys), not
  a single-choice enumeration.
- Switch domain is {0, 1} even though the schema gives it `on`/`off`, not labels.

Also covers the fail-safe surface: None, non-Question kinds, list/nested-list
outcomes, missing input specs, and unknown controls all return False so the
resolver leaves the item to be asked in the normal flow.
"""

import pytest
from askalot_qml.core.domain_validator import outcome_in_domain


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

    # ── Numeric (Editbox / Slider / Range) ──────────────────────────────
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
