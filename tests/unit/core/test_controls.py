"""
Unit tests for the shared control-value helpers (askalot_qml.core.controls).

`coerce_scalar`, `label_keys` and `checkbox_mask` are pure functions shared by
several call sites (ItemProxy, the external-input domain validator, the
external-item enumerator, the Z3 Checkbox domain), so a regression in any would
otherwise only surface indirectly via unrelated test files. These direct tests
pin their edge behavior:

- coerce_scalar: string→int/float for non-text controls, Textarea preserves
  strings, non-strings pass through, unparseable strings stay strings.
- label_keys: int keys kept, string keys coerced, bool keys skipped, missing /
  non-dict labels yield [].
- checkbox_mask: ORs the declared keys (string keys coerced); 0 with no keys.
"""

import pytest
from askalot_qml.core.controls import checkbox_mask, coerce_scalar, label_keys


@pytest.mark.unit
class TestCoerceScalar:
    def test_numeric_string_to_int(self):
        assert coerce_scalar("7", "Radio") == 7

    def test_numeric_string_to_float(self):
        assert coerce_scalar("3.5", "Slider") == 3.5

    def test_textarea_preserves_string(self):
        assert coerce_scalar("7", "Textarea") == "7"

    def test_textarea_case_insensitive(self):
        assert coerce_scalar("7", "textarea") == "7"

    def test_non_string_passes_through(self):
        assert coerce_scalar(7, "Radio") == 7
        assert coerce_scalar(True, "Switch") is True
        assert coerce_scalar(None, "Radio") is None

    def test_unparseable_string_stays_string(self):
        assert coerce_scalar("hello", "Editbox") == "hello"

    def test_none_control_still_coerces(self):
        assert coerce_scalar("42", None) == 42


@pytest.mark.unit
class TestLabelKeys:
    def test_int_keys(self):
        assert sorted(label_keys({"labels": {1: "A", 2: "B"}})) == [1, 2]

    def test_string_keys_coerced(self):
        assert sorted(label_keys({"labels": {"1": "A", "2": "B"}})) == [1, 2]

    def test_bool_keys_skipped(self):
        # A bool is an int subclass but never a valid domain code. (Use 2, not
        # 1: a `{True: ...}` dict literal would collapse with a `1:` key since
        # True == 1 in Python — keep them distinct to prove the bool is skipped.)
        assert label_keys({"labels": {True: "yes", 2: "two"}}) == [2]

    def test_non_coercible_key_dropped(self):
        assert label_keys({"labels": {"x": "A", 2: "B"}}) == [2]

    def test_no_labels(self):
        assert label_keys({}) == []
        assert label_keys({"labels": None}) == []
        assert label_keys({"labels": "notadict"}) == []


@pytest.mark.unit
class TestCheckboxMask:
    def test_ors_the_declared_keys(self):
        assert checkbox_mask({"labels": {1: "A", 2: "B", 8: "D"}}) == 11

    def test_string_keys_coerced(self):
        assert checkbox_mask({"labels": {"1": "A", "16": "E"}}) == 17

    def test_no_labels_is_zero(self):
        assert checkbox_mask({}) == 0
        assert checkbox_mask({"labels": {}}) == 0
