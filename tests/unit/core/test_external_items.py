"""
Unit tests for the shared external-item enumeration helper.

Tests ``list_external_items`` (askalot_qml.core.external_items), which Targetor's
external-input mapping admin UI (QML External Inputs plan, U6) uses to list a
questionnaire's ``external: true`` items and their domain codes for the coercion
editor. Covered:

- Only ``external: true`` items are returned, in document order.
- Each entry carries id/title/control/domain_codes/labels.
- Choice controls expose their labels keys as domain codes; a Switch without
  labels exposes {0, 1}; numeric/textarea expose no codes.
- A questionnaire with no external items yields [].
- Malformed QML fails loud (never a silent []).

Unit tests over real QML content — the helper's job is to parse real QML the
way the loader does. It takes CONTENT (QML is canonical in the document store,
plan 2026-07-21-001 U5), so the fixtures are inline strings.
"""

import pytest
from askalot_qml.core import list_external_items
from jsonschema import ValidationError

_QML = """
qmlVersion: "2.2"
questionnaire:
  title: External items
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_rotate_out
          kind: Question
          title: Rotate out?
          external: true
          input:
            control: Radio
            labels:
              0: "No"
              1: "Yes"
        - id: q_normal
          kind: Question
          title: Normal question
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_sex
          kind: Question
          title: Sex
          external: true
          input:
            control: Dropdown
            labels:
              1: Male
              2: Female
        - id: q_flag
          kind: Question
          title: A switch flag
          external: true
          input:
            control: Switch
"""


@pytest.mark.unit
class TestListExternalItems:
    def test_returns_only_external_items_in_order(self):
        items = list_external_items(_QML)
        assert [i["id"] for i in items] == ["q_rotate_out", "q_sex", "q_flag"]

    def test_entry_shape_and_domain_codes(self):
        items = {i["id"]: i for i in list_external_items(_QML)}
        rotate = items["q_rotate_out"]
        assert rotate["title"] == "Rotate out?"
        assert rotate["control"] == "Radio"
        assert sorted(rotate["domain_codes"]) == [0, 1]

    def test_switch_without_labels_domain_zero_one(self):
        items = {i["id"]: i for i in list_external_items(_QML)}
        assert items["q_flag"]["domain_codes"] == [0, 1]

    def test_no_external_items_returns_empty(self):
        no_externals = """
qmlVersion: "2.2"
questionnaire:
  title: No externals
  blocks:
    - id: b
      kind: Group
      items:
        - id: q1
          kind: Question
          title: Q
          input:
            control: Radio
            labels:
              1: A
"""
        assert list_external_items(no_externals) == []

    def test_malformed_qml_fails_loud(self):
        """A block missing its mandatory ``kind`` raises, never a silent []."""
        broken = """
qmlVersion: "2.2"
questionnaire:
  title: Broken
  blocks:
    - id: b
      items: []
"""
        with pytest.raises(ValidationError):
            list_external_items(broken)
