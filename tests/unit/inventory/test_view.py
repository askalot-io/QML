"""
The plain facts the readable inventory view and the editor's item hints are drawn from.

Tests askalot_qml.inventory.view:
- Constructs come in order of first appearance, grouped by name whatever its
  case or surrounding space, shown with the first spelling, each holding its
  items in document order
- An item with a purpose and no construct sits under its purpose group, never
  under the items without intent
- An item with no entry, and one whose entry lacks intent, sit under the items
  without intent; a Comment appears nowhere
- Wording is the QML's, with markup stripped
- A battery lists every row with its wording and its facts laid over the
  item's, so a reverse-worded row alone reads as reversed
- With no inventory every item is without intent and the view says none exists
- Item hints cover exactly the items that have an entry, and count the
  battery rows marked reverse-worded
- Given the paper's KPI tokens the view carries goal coverage; without them,
  or without an inventory, it carries none

These unit tests load real QML through the loader and write entries through
the model's patch, so the join runs over the shapes production holds.
"""

import json

import pytest
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.inventory import apply_patch, empty_inventory
from askalot_qml.inventory.view import inventory_view_facts, item_hints

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
          title: "How <b>old</b> are   you?"
          input:
            control: Editbox
            min: 0
            max: 120
        - id: q_loyal
          kind: Question
          title: "Would you **recommend** us?"
          input:
            control: Switch
        - id: q_trust
          kind: QuestionGroup
          title: "How much do you agree?"
          questions:
            - "I trust the service"
            - "The service *hides* things from me"
          input:
            control: Radio
            labels:
              1: Disagree
              2: Agree
        - id: q_region
          kind: Question
          title: "Where do you live?"
          input:
            control: Editbox
            min: 1
            max: 20
        - id: q_stay
          kind: Question
          title: "Will you stay with us?"
          input:
            control: Switch
        - id: q_unstated
          kind: Question
          title: "Anything else?"
          input:
            control: Switch
        - id: q_half
          kind: Question
          title: "Half stated"
          input:
            control: Switch
"""

_ENTRIES = [
    {"item_id": "q_age", "kind": "fact", "purpose": "demographics"},
    {"item_id": "q_loyal", "kind": "intention", "construct": "Loyalty", "kpis": ["KPI-2"]},
    {
        "item_id": "q_trust",
        "kind": "opinion",
        "construct": "Trust",
        "kpis": ["KPI-1"],
        "origin": {"mode": "adapted", "instrument": "ESS", "item": "B3"},
        "rows": {"2": {"reversed": True}},
    },
    {"item_id": "q_region", "kind": "fact", "purpose": "demographics"},
    {"item_id": "q_stay", "kind": "intention", "construct": "  loyalty "},
    {"item_id": "q_half", "kind": "fact"},
    {"item_id": "q_gone", "kind": "fact", "purpose": "routing"},
]


@pytest.fixture
def qml() -> dict:
    return QMLLoader().load_from_string(_QML)


@pytest.fixture
def inventory(qml):
    result = apply_patch(empty_inventory(), upsert=_ENTRIES, remove=[], rename=[], qml=qml)
    assert result.refusals == []
    return result.inventory


def _ids(items: list[dict]) -> list[str]:
    return [item["item_id"] for item in items]


class TestGrouping:
    def test_constructs_come_in_first_appearance_order_with_the_first_spelling(self, qml, inventory):
        view = inventory_view_facts(qml, inventory)

        assert view["exists"] is True
        assert [(group["name"], _ids(group["items"])) for group in view["constructs"]] == [
            ("Loyalty", ["q_loyal", "q_stay"]),
            ("Trust", ["q_trust"]),
        ]

    def test_a_purpose_with_no_construct_sits_under_its_purpose_group(self, qml, inventory):
        view = inventory_view_facts(qml, inventory)

        assert [(group["purpose"], _ids(group["items"])) for group in view["purposes"]] == [
            ("demographics", ["q_age", "q_region"]),
        ]
        assert "q_age" not in _ids(view["without_intent"])

    def test_items_with_no_entry_or_no_intent_are_without_intent(self, qml, inventory):
        view = inventory_view_facts(qml, inventory)

        assert _ids(view["without_intent"]) == ["q_unstated", "q_half"]
        unstated, half = view["without_intent"]
        assert unstated["kind"] is None and unstated["kpis"] == [] and unstated["reversed"] is False
        assert half["kind"] == "fact"

    def test_a_comment_and_an_entry_with_no_item_appear_nowhere(self, qml, inventory):
        text = json.dumps(inventory_view_facts(qml, inventory))

        assert "q_intro" not in text
        assert "q_gone" not in text

    def test_no_inventory_leaves_every_item_without_intent(self, qml):
        view = inventory_view_facts(qml, None)

        assert view["exists"] is False
        assert view["constructs"] == [] and view["purposes"] == []
        assert _ids(view["without_intent"]) == [
            "q_age",
            "q_loyal",
            "q_trust",
            "q_region",
            "q_stay",
            "q_unstated",
            "q_half",
        ]


class TestItemFacts:
    def test_an_item_carries_its_qml_kind_its_plain_wording_and_its_entry(self, qml, inventory):
        view = inventory_view_facts(qml, inventory)
        trust = view["constructs"][1]["items"][0]

        assert trust["item_kind"] == "QuestionGroup"
        assert trust["wording"] == "How much do you agree?"
        assert trust["kind"] == "opinion"
        assert trust["construct"] == "Trust"
        assert trust["kpis"] == ["KPI-1"]
        assert trust["purpose"] is None
        assert trust["origin"] == {"mode": "adapted", "instrument": "ESS", "item": "B3"}
        assert trust["reversed"] is False

    def test_markup_in_wording_is_stripped(self, qml, inventory):
        view = inventory_view_facts(qml, inventory)

        assert view["purposes"][0]["items"][0]["wording"] == "How old are you?"
        assert view["constructs"][0]["items"][0]["wording"] == "Would you recommend us?"

    def test_a_reverse_worded_row_alone_reads_as_reversed(self, qml, inventory):
        trust = inventory_view_facts(qml, inventory)["constructs"][1]["items"][0]

        assert [(row["position"], row["wording"], row["reversed"]) for row in trust["rows"]] == [
            (1, "I trust the service", False),
            (2, "The service hides things from me", True),
        ]
        assert all(row["construct"] == "Trust" and row["kind"] == "opinion" for row in trust["rows"])
        assert all(row["kpis"] == ["KPI-1"] for row in trust["rows"])

    def test_a_question_lists_no_rows(self, qml, inventory):
        assert inventory_view_facts(qml, inventory)["purposes"][0]["items"][0]["rows"] == []

    def test_the_view_is_plain_data(self, qml, inventory):
        view = inventory_view_facts(qml, inventory)

        assert json.loads(json.dumps(view)) == view


class TestCoverage:
    def test_the_view_carries_coverage_when_given_the_papers_kpis(self, qml, inventory):
        view = inventory_view_facts(qml, inventory, kpi_tokens=["KPI-1", "KPI-2", "KPI-3"])

        assert view["coverage"] == {
            "kpis_without_items": ["KPI-3"],
            "items_without_kpi_or_purpose": ["q_stay", "q_unstated", "q_half"],
            "unknown_kpis": [],
        }

    def test_without_the_papers_kpis_there_is_no_coverage(self, qml, inventory):
        assert inventory_view_facts(qml, inventory)["coverage"] is None

    def test_without_an_inventory_there_is_no_coverage(self, qml):
        assert inventory_view_facts(qml, None, kpi_tokens=["KPI-1"])["coverage"] is None


class TestHints:
    def test_hints_cover_exactly_the_items_that_have_an_entry(self, qml, inventory):
        hints = item_hints(qml, inventory)

        assert list(hints) == ["q_age", "q_loyal", "q_trust", "q_region", "q_stay", "q_half"]
        assert hints["q_trust"] == {
            "construct": "Trust",
            "kind": "opinion",
            "kpis": ["KPI-1"],
            "purpose": None,
            "reversed": False,
            "reversed_rows": 1,
        }
        assert hints["q_age"]["purpose"] == "demographics"
        assert hints["q_age"]["reversed_rows"] == 0

    def test_a_reverse_mark_on_a_row_the_item_does_not_have_is_not_counted(self, qml):
        entries = [{"item_id": "q_trust", "kind": "opinion", "rows": {"1": {"reversed": True}, "7": {"reversed": True}}}]
        inventory = apply_patch(empty_inventory(), upsert=entries, remove=[], rename=[], qml=qml).inventory

        assert item_hints(qml, inventory)["q_trust"]["reversed_rows"] == 1

    def test_no_inventory_gives_no_hints(self, qml):
        assert item_hints(qml, None) == {}
