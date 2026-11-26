"""
Goal coverage computed from the KPI links an item inventory states.

Tests askalot_qml.inventory.coverage:
- An item with a purpose and no KPI is covered: it is not listed as serving nothing
- A KPI no asked item names is listed, in the order the paper numbers them
- An item with no entry, and one with neither a KPI nor a purpose, are listed
  in the QML's document order
- An entry whose item the QML does not ask covers nothing
- A battery row's own KPI counts, and a row that states none carries its item's
- A KPI the paper does not number is named with the item that states it
- The same questionnaire, inventory and tokens give the same coverage twice
- With no inventory there is no coverage and there are no links
- A KPI is collected by no item, one item, several items, or open-ended items only

These unit tests load real QML through the loader and write entries through
the model's patch, so coverage is computed over the shapes production holds.
"""

import json

import pytest
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.inventory import (
    apply_patch,
    collection_modes,
    covering_links,
    empty_inventory,
    goal_coverage,
)

_QML = """
qmlVersion: "2.0"
questionnaire:
  title: Service study
  blocks:
    - id: b_main
      title: Main
      items:
        - id: q_intro
          kind: Comment
          title: "Welcome"
        - id: q_age
          kind: Question
          title: "How old are you?"
          input:
            control: Editbox
            min: 0
            max: 120
        - id: q_loyal
          kind: Question
          title: "Would you recommend us?"
          input:
            control: Switch
        - id: q_trust
          kind: QuestionGroup
          title: "How much do you agree?"
          questions:
            - "I trust the service"
            - "The service hides things from me"
            - "The service is quick"
          input:
            control: Radio
            labels:
              1: Disagree
              2: Agree
        - id: q_why
          kind: Question
          title: "Why do you say so?"
          input:
            control: Textarea
        - id: q_extra
          kind: Question
          title: "Anything else?"
          input:
            control: Switch
"""

_AGE = {"item_id": "q_age", "kind": "fact", "purpose": "demographics"}
_LOYAL = {"item_id": "q_loyal", "kind": "intention", "construct": "Loyalty", "kpis": ["KPI-2"]}
_TRUST = {
    "item_id": "q_trust",
    "kind": "opinion",
    "construct": "Trust",
    "kpis": ["KPI-1"],
    "rows": {"3": {"construct": "Speed", "kpis": ["KPI-3"]}},
}
_WHY = {"item_id": "q_why", "kind": "opinion", "construct": "Loyalty", "kpis": ["KPI-4"]}
_EXTRA = {"item_id": "q_extra", "kind": "opinion", "construct": "Other"}
_TOKENS = ["KPI-1", "KPI-2", "KPI-3", "KPI-4"]


@pytest.fixture
def qml() -> dict:
    return QMLLoader().load_from_string(_QML)


def _inventory(*entries: dict, qml: dict):
    result = apply_patch(empty_inventory(), upsert=list(entries), remove=[], rename=[], qml=qml)
    assert result.refusals == []
    return result.inventory


class TestCoveringLinks:
    def test_an_item_naming_a_kpi_is_one_link(self, qml):
        links = covering_links(qml, _inventory(_AGE, _LOYAL, qml=qml))

        assert links == [
            {"item_id": "q_loyal", "position": None, "kpis": ["KPI-2"], "open_ended": False}
        ]

    def test_a_battery_links_row_by_row_and_a_rows_own_kpi_counts(self, qml):
        links = covering_links(qml, _inventory(_TRUST, qml=qml))

        assert links == [
            {"item_id": "q_trust", "position": 1, "kpis": ["KPI-1"], "open_ended": False},
            {"item_id": "q_trust", "position": 2, "kpis": ["KPI-1"], "open_ended": False},
            {"item_id": "q_trust", "position": 3, "kpis": ["KPI-3"], "open_ended": False},
        ]

    def test_a_free_text_item_is_open_ended(self, qml):
        assert covering_links(qml, _inventory(_WHY, qml=qml)) == [
            {"item_id": "q_why", "position": None, "kpis": ["KPI-4"], "open_ended": True}
        ]

    def test_an_entry_whose_item_is_not_asked_links_nothing(self, qml):
        gone = {"item_id": "q_gone", "kind": "fact", "kpis": ["KPI-2"]}

        assert covering_links(qml, _inventory(gone, qml=qml)) == []

    def test_no_inventory_links_nothing(self, qml):
        assert covering_links(qml, None) == []


class TestGoalCoverage:
    def test_an_item_with_a_purpose_and_no_kpi_is_covered(self, qml):
        coverage = goal_coverage(qml, _inventory(_AGE, _LOYAL, _TRUST, _WHY, _EXTRA, qml=qml), _TOKENS)

        assert "q_age" not in coverage["items_without_kpi_or_purpose"]

    def test_a_kpi_no_asked_item_names_is_listed_in_the_papers_order(self, qml):
        coverage = goal_coverage(qml, _inventory(_AGE, _LOYAL, qml=qml), ["KPI-4", "KPI-2", "KPI-1"])

        assert coverage["kpis_without_items"] == ["KPI-4", "KPI-1"]

    def test_a_rows_own_kpi_covers_it(self, qml):
        coverage = goal_coverage(qml, _inventory(_TRUST, qml=qml), _TOKENS)

        assert coverage["kpis_without_items"] == ["KPI-2", "KPI-4"]

    def test_an_entry_whose_item_is_not_asked_covers_nothing(self, qml):
        gone = {"item_id": "q_gone", "kind": "fact", "kpis": ["KPI-2"]}

        coverage = goal_coverage(qml, _inventory(gone, qml=qml), ["KPI-2"])

        assert coverage["kpis_without_items"] == ["KPI-2"]
        assert coverage["unknown_kpis"] == []

    def test_items_with_neither_a_kpi_nor_a_purpose_come_in_document_order(self, qml):
        coverage = goal_coverage(qml, _inventory(_AGE, _TRUST, _EXTRA, qml=qml), _TOKENS)

        assert coverage["items_without_kpi_or_purpose"] == ["q_loyal", "q_why", "q_extra"]

    def test_a_battery_row_with_neither_lists_its_item(self, qml):
        trust = {**_TRUST, "kpis": [], "rows": {"1": {"kpis": ["KPI-1"]}, "2": {"purpose": "screening"}}}

        coverage = goal_coverage(qml, _inventory(_AGE, _LOYAL, trust, _WHY, qml=qml), _TOKENS)

        assert coverage["items_without_kpi_or_purpose"] == ["q_trust", "q_extra"]

    def test_a_kpi_the_paper_does_not_number_is_named_once_per_item(self, qml):
        loyal = {**_LOYAL, "kpis": ["KPI-2", "KPI-9"]}
        trust = {**_TRUST, "kpis": ["KPI-8"]}

        coverage = goal_coverage(qml, _inventory(loyal, trust, qml=qml), ["KPI-1", "KPI-2", "KPI-3"])

        assert coverage["unknown_kpis"] == [
            {"item_id": "q_loyal", "kpi": "KPI-9"},
            {"item_id": "q_trust", "kpi": "KPI-8"},
        ]

    def test_the_same_inputs_give_the_same_coverage_twice(self, qml):
        inventory = _inventory(_AGE, _LOYAL, _TRUST, qml=qml)

        first = goal_coverage(qml, inventory, _TOKENS)

        assert goal_coverage(qml, inventory, _TOKENS) == first
        assert json.loads(json.dumps(first)) == first

    def test_no_inventory_has_no_coverage(self, qml):
        assert goal_coverage(qml, None, _TOKENS) is None

    def test_a_paper_with_no_kpis_still_lists_the_items(self, qml):
        coverage = goal_coverage(qml, _inventory(_AGE, qml=qml), [])

        assert coverage["kpis_without_items"] == []
        assert coverage["items_without_kpi_or_purpose"] == ["q_loyal", "q_trust", "q_why", "q_extra"]


class TestCollectionModes:
    def test_each_kpi_reads_none_one_several_or_open_ended(self, qml):
        links = covering_links(qml, _inventory(_LOYAL, _TRUST, _WHY, qml=qml))

        assert collection_modes(links, [*_TOKENS, "KPI-5"]) == {
            "KPI-1": "several_items",
            "KPI-2": "one_item",
            "KPI-3": "one_item",
            "KPI-4": "open_ended",
            "KPI-5": "not_collected",
        }

    def test_a_kpi_with_a_closed_and_an_open_item_is_several_items(self, qml):
        why = {**_WHY, "kpis": ["KPI-2"]}

        links = covering_links(qml, _inventory(_LOYAL, why, qml=qml))

        assert collection_modes(links, ["KPI-2"]) == {"KPI-2": "several_items"}

    def test_links_of_several_questionnaires_are_counted_together(self, qml):
        first = covering_links(qml, _inventory(_LOYAL, qml=qml))
        second = covering_links(qml, _inventory(_LOYAL, qml=qml))

        assert collection_modes([*first, *second], ["KPI-2"]) == {"KPI-2": "several_items"}

    def test_no_links_collect_nothing(self):
        assert collection_modes([], ["KPI-1"]) == {"KPI-1": "not_collected"}
