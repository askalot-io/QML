"""
The QML translation layer: text keys, validation, completeness, carry-forward, overlay.

Tests the pure functions in askalot_qml.core.qml_translation:
- A translation that changes an option code is refused, naming the item and both codes
- A translation naming an item id the source lacks is refused, naming the id
- A positional list (matrix rows) translated one entry short is a length mismatch
- Z3 gives the same verdict on the source and on the source overlaid with a translation
- `untranslated` is empty for a complete translation and names exactly a dropped hint
- Postcondition hints, the questionnaire title and block titles are text keys
- An invented postcondition's hint is one key and its `invented` marker none
- Carry-forward keeps unchanged text, drops changed keys, and drops a changed positional list whole
- `apply_translation` replaces text only: ids, codes, preconditions and code blocks stay byte-identical

These unit tests run on documents parsed by the real QMLLoader (the flattened
shape the flow service materializes) and on the real ValidationProcessor, so the
key scheme is proven against the shape production reads rather than a hand-built
dict.
"""

import copy
import json
from pathlib import Path

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_translation import (
    RefusalKind,
    apply_translation,
    carry_forward,
    text_keys,
    untranslated,
    validate_translation,
)
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"

#: Every respondent-visible text field the schema declares, once each.
ALL_FIELDS_QML = """
qmlVersion: "2.0"
questionnaire:
  title: "Everything survey"
  blocks:
    - id: b_main
      title: "Main"
      postcondition:
        - predicate: "True"
          hint: "Block-level hint"
      items:
        - id: c_intro
          kind: Comment
          title: "Welcome"
        - id: q3
          kind: Question
          title: "How satisfied are you?"
          precondition:
            - predicate: "True"
          input:
            control: Radio
            labels:
              1: "Very unsatisfied"
              2: "Unsatisfied"
              3: "Neutral"
              4: "Satisfied"
              5: "Very satisfied"
          postcondition:
            - predicate: "q3.outcome >= 1"
              hint: "Pick an answer."
            - predicate: "q3.outcome <= 5"
        - id: q_switch
          kind: Question
          title: "Do you agree?"
          input:
            control: Switch
            on: "Agree"
            off: "Disagree"
            left: "No"
            right: "Yes"
        - id: q_age
          kind: Question
          title: "Your age"
          input:
            control: Editbox
            min: 18
            max: 99
            left: "I am"
            right: "years old"
        - id: q_text
          kind: Question
          title: "Any comments?"
          input:
            control: Textarea
            placeholder: "Type here"
        - id: q_drop
          kind: Question
          title: "Country"
          input:
            control: Dropdown
            labels:
              1: "Hungary"
              2: "Germany"
        - id: q_slide
          kind: Question
          title: "Rate us"
          input:
            control: Slider
            min: 0
            max: 2
            labels:
              0: "Bad"
              2: "Good"
        - id: q_group
          kind: QuestionGroup
          title: "Rate each aspect"
          questions:
            - "Price"
            - "Support"
          input:
            control: Radio
            labels:
              1: "Poor"
              2: "Good"
        - id: m1
          kind: MatrixQuestion
          title: "Hours per day"
          rows:
            - "Work"
            - "Sleep"
            - "Leisure"
          columns:
            - "Weekday"
            - "Weekend"
          input:
            control: Editbox
            min: 0
            max: 24
          codeBlock: |
            total = 1
    - id: b_people
      kind: Roster
      title: "People"
      iterateOver: q_members.outcome
      labels:
        1: "Partner"
        2: "Child"
      items:
        - id: q_member_age
          kind: Question
          title: "Age of this person"
          input:
            control: Editbox
            min: 0
            max: 120
    - id: b_members
      title: "Members"
      items:
        - id: q_members
          kind: Question
          title: "Who lives with you?"
          input:
            control: Checkbox
            labels:
              1: "Partner"
              2: "Child"
"""


def _load(content: str) -> dict:
    return QMLLoader().load_from_string(content)


def _load_fixture(name: str) -> dict:
    return QMLLoader(schema_path=None).load_from_path(FIXTURES_DIR / name)


def _hungarian(qml: dict) -> dict[str, str]:
    """A complete translation: every source text prefixed, so each is distinct."""
    return {key: f"HU {text}" for key, text in text_keys(qml).items()}


def _kinds_and_keys(refusals) -> set[tuple[RefusalKind, str]]:
    return {(refusal.kind, refusal.key) for refusal in refusals}


class TestValidateTranslation:
    """A translation replaces text only; anything else is refused by key."""

    def test_a_translation_changing_a_code_is_refused(self):
        qml = _load(ALL_FIELDS_QML)
        texts = {f"item:q3/labels/{code}": f"label {code}" for code in (1, 2, 3, 4, 6)}

        refusals = validate_translation(qml, texts)

        assert _kinds_and_keys(refusals) == {
            (RefusalKind.UNKNOWN_CODE, "item:q3/labels/6"),
            (RefusalKind.MISSING_CODE, "item:q3/labels/5"),
        }
        for refusal in refusals:
            assert "q3" in refusal.message

    def test_a_partial_coded_map_with_no_foreign_code_is_valid(self):
        """Missing codes alone are untranslated text, not a changed code."""
        qml = _load(ALL_FIELDS_QML)

        assert validate_translation(qml, {"item:q3/labels/1": "Nagyon elégedetlen"}) == []

    def test_an_item_id_absent_from_the_source_is_refused(self):
        qml = _load(ALL_FIELDS_QML)

        refusals = validate_translation(qml, {"item:q_ghost/title": "Szellem"})

        assert _kinds_and_keys(refusals) == {(RefusalKind.UNKNOWN_SCOPE, "item:q_ghost/title")}
        assert "q_ghost" in refusals[0].message

    def test_matrix_rows_one_entry_short_is_a_length_mismatch(self):
        qml = _load(ALL_FIELDS_QML)
        texts = {"item:m1/rows/0": "Munka", "item:m1/rows/1": "Alvás"}

        refusals = validate_translation(qml, texts)

        assert _kinds_and_keys(refusals) == {(RefusalKind.LIST_LENGTH_MISMATCH, "item:m1/rows")}

    def test_an_index_past_the_source_list_is_out_of_range(self):
        qml = _load(ALL_FIELDS_QML)
        texts = {f"item:m1/columns/{index}": "x" for index in range(3)}

        refusals = validate_translation(qml, texts)

        assert _kinds_and_keys(refusals) == {(RefusalKind.INDEX_OUT_OF_RANGE, "item:m1/columns/2")}

    def test_a_non_text_field_or_value_is_refused(self):
        qml = _load(ALL_FIELDS_QML)
        texts = {
            "item:q3/precondition/0/predicate": "False",
            "item:q3/title": 7,
            "item:q3/postcondition/1/hint": "There was no hint here",
        }

        refusals = validate_translation(qml, texts)

        assert _kinds_and_keys(refusals) == {
            (RefusalKind.UNKNOWN_FIELD, "item:q3/precondition/0/predicate"),
            (RefusalKind.NON_STRING_VALUE, "item:q3/title"),
            (RefusalKind.UNKNOWN_FIELD, "item:q3/postcondition/1/hint"),
        }

    def test_a_complete_translation_is_valid(self):
        qml = _load(ALL_FIELDS_QML)

        assert validate_translation(qml, _hungarian(qml)) == []


class TestTextKeys:
    def test_every_respondent_visible_field_is_a_key(self):
        keys = text_keys(_load(ALL_FIELDS_QML))

        assert keys["questionnaire/title"] == "Everything survey"
        assert keys["block:b_main/title"] == "Main"
        assert keys["block:b_main/postcondition/0/hint"] == "Block-level hint"
        assert keys["item:q3/postcondition/0/hint"] == "Pick an answer."
        assert "item:q3/postcondition/1/hint" not in keys
        assert keys["item:c_intro/title"] == "Welcome"
        assert keys["item:q3/labels/5"] == "Very satisfied"
        assert [keys[f"item:q_switch/{f}"] for f in ("on", "off", "left", "right")] == [
            "Agree",
            "Disagree",
            "No",
            "Yes",
        ]
        assert keys["item:q_age/right"] == "years old"
        assert keys["item:q_text/placeholder"] == "Type here"
        assert keys["item:q_slide/labels/0"] == "Bad"
        assert keys["item:q_group/questions/1"] == "Support"
        assert keys["item:m1/rows/2"] == "Leisure"
        assert keys["item:m1/columns/1"] == "Weekend"
        assert keys["block:b_people/labels/2"] == "Child"
        # Conditions, code blocks, ids and numeric bounds are never text.
        assert not any("predicate" in key or "codeBlock" in key for key in keys)

    def test_an_invented_check_gives_its_hint_once_and_its_marker_no_key(self):
        """The `invented` marker is for authors: a translator receives only the hint."""
        marked = ALL_FIELDS_QML.replace(
            '              hint: "Pick an answer."\n',
            '              hint: "Pick an answer."\n              invented: true\n',
        ).replace(
            '          hint: "Block-level hint"\n',
            '          hint: "Block-level hint"\n          invented: true\n',
        )
        assert marked.count("invented: true") == 2

        keys = text_keys(_load(marked))

        assert keys == text_keys(_load(ALL_FIELDS_QML))
        assert list(keys.values()).count("Pick an answer.") == 1
        assert list(keys.values()).count("Block-level hint") == 1
        assert not any("invented" in key for key in keys)

    def test_keys_serialize_into_json(self):
        qml = _load(ALL_FIELDS_QML)
        texts = _hungarian(qml)

        assert json.loads(json.dumps(texts)) == texts


class TestUntranslated:
    def test_a_complete_translation_has_nothing_untranslated(self):
        qml = _load(ALL_FIELDS_QML)

        assert untranslated(qml, _hungarian(qml)) == []

    def test_dropping_one_hint_leaves_exactly_that_key(self):
        qml = _load(ALL_FIELDS_QML)
        texts = _hungarian(qml)
        del texts["item:q3/postcondition/0/hint"]

        assert untranslated(qml, texts) == ["item:q3/postcondition/0/hint"]


class TestCarryForward:
    def test_only_the_changed_label_is_dropped(self):
        v3 = _load(ALL_FIELDS_QML)
        v4 = _load(ALL_FIELDS_QML.replace('"Unsatisfied"', '"Rather unsatisfied"'))
        v3_hu = _hungarian(v3)

        v4_hu = carry_forward(v3, v3_hu, v4)

        assert set(v3_hu) - set(v4_hu) == {"item:q3/labels/2"}
        assert untranslated(v4, v4_hu) == ["item:q3/labels/2"]
        assert v3_hu == _hungarian(v3), "the old translation is not modified"

    def test_swapping_two_option_codes_drops_both_keys(self):
        v3 = _load(ALL_FIELDS_QML)
        swapped = ALL_FIELDS_QML.replace('1: "Hungary"', '1: "@@"').replace(
            '2: "Germany"', '2: "Hungary"'
        )
        v4 = _load(swapped.replace('1: "@@"', '1: "Germany"'))

        v4_hu = carry_forward(v3, _hungarian(v3), v4)

        assert untranslated(v4, v4_hu) == ["item:q_drop/labels/1", "item:q_drop/labels/2"]

    def test_a_changed_matrix_row_list_drops_the_whole_list(self):
        v3 = _load(ALL_FIELDS_QML)
        v4 = _load(ALL_FIELDS_QML.replace('- "Leisure"', '- "Free time"'))

        v4_hu = carry_forward(v3, _hungarian(v3), v4)

        assert untranslated(v4, v4_hu) == ["item:m1/rows/0", "item:m1/rows/1", "item:m1/rows/2"]
        assert "item:m1/columns/0" in v4_hu

    def test_a_new_item_is_untranslated(self):
        v3 = _load(ALL_FIELDS_QML)
        v4 = _load(
            ALL_FIELDS_QML.replace(
                "        - id: c_intro\n",
                '        - id: c_new\n          kind: Comment\n          title: "New"\n'
                "        - id: c_intro\n",
            )
        )

        v4_hu = carry_forward(v3, _hungarian(v3), v4)

        assert untranslated(v4, v4_hu) == ["item:c_new/title"]


class TestApplyTranslation:
    def test_text_is_replaced_and_nothing_else_moves(self):
        qml = _load(ALL_FIELDS_QML)
        before = copy.deepcopy(qml)

        translated = apply_translation(qml, _hungarian(qml))

        assert qml == before, "the source document is not mutated"
        assert text_keys(translated) == _hungarian(qml)
        assert _strip_text(translated) == _strip_text(qml)
        roster_item = next(i for i in translated["items"] if i["id"] == "q_member_age")
        assert roster_item["_roster_labels"] == {1: "HU Partner", 2: "HU Child"}

    def test_a_partial_translation_overlays_only_its_keys(self):
        qml = _load(ALL_FIELDS_QML)

        translated = apply_translation(qml, {"item:q3/labels/1": "Nagyon elégedetlen"})

        q3 = next(i for i in translated["items"] if i["id"] == "q3")
        assert q3["input"]["labels"][1] == "Nagyon elégedetlen"
        assert q3["input"]["labels"][2] == "Unsatisfied"


def _strip_text(qml: dict) -> str:
    """The document with every text value blanked, serialized for byte comparison."""
    blanked = apply_translation(qml, dict.fromkeys(text_keys(qml), ""))
    return json.dumps(blanked, sort_keys=True, default=str)


class TestZ3VerdictIsLanguageBlind:
    """Z3 validation sees the same verdict with and without a translation overlaid."""

    @staticmethod
    def _verdict(qml: dict):
        processor = ValidationProcessor(QMLState(qml))
        issues = [(i["item_id"], i["severity"], i["type"]) for i in processor.to_issues(deep=True)]
        return processor.get_item_classifications(), issues

    def test_the_overlay_is_the_twin_and_the_verdict_is_identical(self):
        hungarian_texts = text_keys(_load_fixture("language_neutral_hu.qml"))
        source = _load_fixture("language_neutral_en.qml")
        assert validate_translation(source, hungarian_texts) == []
        assert untranslated(source, hungarian_texts) == []

        translated = apply_translation(source, hungarian_texts)

        assert translated == _load_fixture("language_neutral_hu.qml")
        assert self._verdict(translated) == self._verdict(_load_fixture("language_neutral_en.qml"))
