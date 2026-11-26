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
- The source-level appliers rewrite a raw parsed QML file: the dumped file loads with exactly the
  translation's text keys, its non-text structure is the source's, and precondition hints are
  keyed, replaced and re-read like the other texts
- Every label of a declared rating scale is a key, the out-of-scale answers' included: a
  translation without one is incomplete, a key for a code the item lacks is an unknown code,
  carry-forward copies the unchanged labels, the overlay rewrites the ordered options from the
  translated labels keeping order and out-of-scale flags (two items sharing one anchored
  `input` or `labels` mapping each keep their own translation), and a seeded row lacks
  exactly the label a new version added

These unit tests run on documents parsed by the real QMLLoader (the flattened
shape the flow service materializes) and on the real ValidationProcessor, so the
key scheme is proven against the shape production reads rather than a hand-built
dict.
"""

import copy
import json
from pathlib import Path

import pytest
import yaml
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_translation import (
    RefusalKind,
    apply_source_precondition_hints,
    apply_source_translation,
    apply_translation,
    carry_forward,
    dump_source,
    source_precondition_hints,
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


#: A source file whose preconditions carry hints at block and item level, one unhinted.
HINTED_QML = """
qmlVersion: "2.0"
questionnaire:
  title: "Hinted"
  blocks:
    - id: b_main
      title: "Main"
      items:
        - id: q_pet
          kind: Question
          title: "Do you have a pet?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
    - id: b_pets
      title: "Pets"
      precondition:
        - predicate: "q_pet.outcome == 1"
          hint: "Only pet owners"
      items:
        - id: q_kind
          kind: Question
          title: "Which pet?"
          precondition:
            - predicate: "q_pet.outcome == 1"
            - predicate: "q_pet.outcome != 2"
              hint: "Not for those without one"
          input:
            control: Textarea
          codeBlock: |
            note = 1
            other = 2
"""


class TestSourceLevelAppliers:
    """A translation applied to the raw source file, dumped, reads as the translated twin."""

    def test_the_dumped_source_loads_with_exactly_the_translation(self):
        raw = yaml.safe_load(ALL_FIELDS_QML)
        before = copy.deepcopy(raw)
        hungarian = _hungarian(_load(ALL_FIELDS_QML))

        dumped = dump_source(apply_source_translation(raw, hungarian))

        assert raw == before, "the source document is not mutated"
        translated = _load(dumped)
        assert text_keys(translated) == hungarian
        assert _strip_text(translated) == _strip_text(_load(ALL_FIELDS_QML))

    def test_a_switch_written_with_bare_on_off_keys_is_translated(self):
        raw = yaml.safe_load(ALL_FIELDS_QML)

        translated = _load(
            dump_source(apply_source_translation(raw, {"item:q_switch/on": "Egyetért"}))
        )

        switch = next(i for i in translated["items"] if i["id"] == "q_switch")
        assert switch["input"]["on"] == "Egyetért"
        assert switch["input"]["off"] == "Disagree"

    def test_precondition_hints_are_keyed_by_scope_and_position(self):
        assert source_precondition_hints(yaml.safe_load(HINTED_QML)) == {
            "block:b_pets/precondition/0/hint": "Only pet owners",
            "item:q_kind/precondition/1/hint": "Not for those without one",
        }

    def test_applied_hints_replace_only_the_hints(self):
        raw = yaml.safe_load(HINTED_QML)
        before = copy.deepcopy(raw)
        hints = {
            "block:b_pets/precondition/0/hint": "Csak kisállattartóknak",
            "item:q_kind/precondition/1/hint": "Annak nem, akinek nincs",
        }

        dumped = dump_source(apply_source_precondition_hints(raw, hints))

        assert raw == before, "the source document is not mutated"
        reread = yaml.safe_load(dumped)
        assert source_precondition_hints(reread) == hints
        blank = dict.fromkeys(hints, "")
        assert apply_source_precondition_hints(reread, blank) == apply_source_precondition_hints(
            raw, blank
        )
        assert text_keys(_load(dumped)) == text_keys(_load(HINTED_QML))

    def test_a_multi_line_string_stays_a_literal_block(self):
        dumped = dump_source(yaml.safe_load(HINTED_QML))

        assert "codeBlock: |" in dumped
        assert _load(dumped) == _load(HINTED_QML)


#: Three choice items: a declared scale shown highest first, a declared scale
#: with one out-of-scale answer, and an undeclared item.
SCALED_QML = """
qmlVersion: "2.9.0"
questionnaire:
  title: "Scaled survey"
  blocks:
    - id: b_main
      title: "Main"
      items:
        - id: q_agree
          kind: Question
          title: "Taxes should be lower"
          scale:
            polarity: bipolar
            points: 3
            order: descending
          input:
            control: Radio
            labels:
              1: "Disagree"
              2: "Neither"
              3: "Agree"
        - id: q_mood
          kind: Question
          title: "How was your stay?"
          scale:
            polarity: bipolar
            points: 5
          input:
            control: Dropdown
            labels:
              1: "Awful"
              2: "Poor"
              3: "Fine"
              4: "Good"
              5: "Superb"
              8: "Don't know"
        - id: q_plain
          kind: Question
          title: "Pick one"
          input:
            control: Radio
            labels:
              1: "Left"
              2: "Right"
"""

_MOOD_LABEL_KEYS = [f"item:q_mood/labels/{code}" for code in (1, 2, 3, 4, 5, 8)]


def _item(qml: dict, item_id: str) -> dict:
    return next(item for item in qml["items"] if item["id"] == item_id)


class TestDeclaredScaleKeys:
    """Every label of a declared scale is a translation key, as any label is."""

    def test_every_label_of_a_declared_item_is_a_key(self):
        keys = list(text_keys(_load(SCALED_QML)))

        assert [key for key in keys if key.startswith("item:q_agree/labels/")] == [
            f"item:q_agree/labels/{code}" for code in (1, 2, 3)
        ]
        assert [key for key in keys if key.startswith("item:q_mood/labels/")] == _MOOD_LABEL_KEYS
        assert "item:q_plain/labels/1" in keys and "item:q_plain/labels/2" in keys

    def test_a_translation_missing_the_out_of_scale_label_is_incomplete(self):
        """Six keys for five points and one out-of-scale answer; five leave it incomplete."""
        qml = _load(SCALED_QML)
        texts = _hungarian(qml)
        assert untranslated(qml, texts) == []

        del texts["item:q_mood/labels/8"]

        assert validate_translation(qml, texts) == []
        assert untranslated(qml, texts) == ["item:q_mood/labels/8"]

    def test_a_key_for_a_code_the_item_lacks_is_an_unknown_code(self):
        qml = _load(SCALED_QML)
        texts = {**_hungarian(qml), "item:q_mood/labels/9": "Nem válaszol"}

        refusals = validate_translation(qml, texts)

        assert (RefusalKind.UNKNOWN_CODE, "item:q_mood/labels/9") in _kinds_and_keys(refusals)
        assert {refusal.kind for refusal in refusals} <= {
            RefusalKind.UNKNOWN_CODE,
            RefusalKind.MISSING_CODE,
        }

    def test_carry_forward_copies_a_declared_items_unchanged_labels(self):
        old = _load(SCALED_QML)
        new = _load(SCALED_QML.replace('5: "Superb"', '5: "Excellent"'))

        carried = carry_forward(old, _hungarian(old), new)

        assert carried["item:q_mood/labels/8"] == "HU Don't know"
        assert carried["item:q_agree/labels/3"] == "HU Agree"
        assert untranslated(new, carried) == ["item:q_mood/labels/5"]


class TestDeclaredScaleOverlay:
    """The overlay rewrites the ordered options from the translated labels."""

    def test_labels_and_options_are_overlaid_together_keeping_order_and_flags(self):
        qml = _load(SCALED_QML)

        translated = apply_translation(qml, _hungarian(qml))

        mood = _item(translated, "q_mood")["input"]
        assert mood["labels"] == {
            1: "HU Awful",
            2: "HU Poor",
            3: "HU Fine",
            4: "HU Good",
            5: "HU Superb",
            8: "HU Don't know",
        }
        assert [(o["code"], o["label"], o["outOfScale"]) for o in mood["options"]] == [
            (1, "HU Awful", False),
            (2, "HU Poor", False),
            (3, "HU Fine", False),
            (4, "HU Good", False),
            (5, "HU Superb", False),
            (8, "HU Don't know", True),
        ]
        agree = _item(translated, "q_agree")["input"]
        assert [(o["code"], o["label"]) for o in agree["options"]] == [
            (3, "HU Agree"),
            (2, "HU Neither"),
            (1, "HU Disagree"),
        ]
        assert _item(translated, "q_agree")["scale"] == _item(qml, "q_agree")["scale"]
        assert _item(qml, "q_mood")["input"]["options"][0]["label"] == "Awful", "the source is not mutated"

    @pytest.mark.parametrize(
        ("first", "second"),
        [
            ("input: &shared\n            control: Radio\n            labels: {1: Low, 2: High}", "input: *shared"),
            (
                "input:\n            control: Radio\n            labels: &shared {1: Low, 2: High}",
                "input:\n            control: Radio\n            labels: *shared",
            ),
        ],
        ids=["anchored-input", "anchored-labels"],
    )
    def test_items_sharing_an_anchored_mapping_keep_their_own_translations(self, first, second):
        qml = _load(
            'qmlVersion: "2.9.0"\n'
            "questionnaire:\n"
            "  title: Anchored\n"
            "  blocks:\n"
            "    - id: b_main\n"
            "      title: Main\n"
            "      items:\n"
            "        - id: q_a\n"
            "          kind: Question\n"
            "          title: First\n"
            "          scale: {polarity: bipolar, points: 2}\n"
            f"          {first}\n"
            "        - id: q_c\n"
            "          kind: Question\n"
            "          title: Second\n"
            "          scale: {polarity: bipolar, points: 2}\n"
            f"          {second}\n"
        )

        translated = apply_translation(
            qml, {"item:q_a/labels/1": "Nem (a)", "item:q_c/labels/1": "Nem (c)"}
        )

        for item_id, text in (("q_a", "Nem (a)"), ("q_c", "Nem (c)")):
            spec = _item(translated, item_id)["input"]
            assert spec["labels"] == {1: text, 2: "High"}
            assert [(o["code"], o["label"]) for o in spec["options"]] == [(1, text), (2, "High")]

    def test_a_partial_overlay_leaves_the_other_options_in_the_source_text(self):
        qml = _load(SCALED_QML)

        translated = apply_translation(qml, {"item:q_mood/labels/8": "Nem tudom"})

        assert [o["label"] for o in _item(translated, "q_mood")["input"]["options"]] == [
            "Awful",
            "Poor",
            "Fine",
            "Good",
            "Superb",
            "Nem tudom",
        ]

    def test_a_translated_file_carries_every_label_and_loads_with_the_translations_keys(self):
        hungarian = _hungarian(_load(SCALED_QML))

        dumped = dump_source(apply_source_translation(yaml.safe_load(SCALED_QML), hungarian))

        reloaded = _load(dumped)
        assert text_keys(reloaded) == hungarian
        assert [o["label"] for o in _item(reloaded, "q_agree")["input"]["options"]] == [
            "HU Agree",
            "HU Neither",
            "HU Disagree",
        ]


class TestSeedingADeclaredScale:
    """Seeding computes the untranslated list against the version's own labels."""

    def test_a_seeded_row_lacks_exactly_the_label_the_new_version_added(self):
        from types import SimpleNamespace

        from askalot_qml.core.qml_translation import seed_translations

        old_content = SCALED_QML.replace('              8: "Don\'t know"\n', "")
        old_qml = _load(old_content)
        inserted = []
        repository = SimpleNamespace(
            qml_translation_seed_plan=lambda questionnaire_id, version_id: SimpleNamespace(
                version_content=SCALED_QML,
                sources=[
                    SimpleNamespace(
                        locale="hu",
                        ancestor_version_id="v1",
                        ancestor_content=old_content,
                        texts=_hungarian(old_qml),
                        human_edited_at=None,
                    )
                ],
            ),
            insert_seeded_translations=lambda questionnaire_id, version_id, rows: (
                inserted.extend(rows) or [row.locale for row in rows]
            ),
        )

        assert seed_translations(repository, "q-1", "v2") == ["hu"]
        assert inserted[0].untranslated == ["item:q_mood/labels/8"]
        assert inserted[0].texts == _hungarian(old_qml)
