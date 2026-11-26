"""
The disagreements between a questionnaire's QML and its item inventory.

Tests askalot_qml.inventory.warnings:
- Changing an item's wording changes no warning, because the inventory holds none
- An entry whose item is gone raises `entry_without_item` naming the id, after
  every warning about an item the QML asks
- A question, a question group, a matrix and a roster's inner question with no
  entry raise `item_without_entry`; a Comment never does
- An entry stating a kind and a purpose raises nothing; one with no kind, or
  with neither a construct nor a purpose, raises `intent_missing`
- A row is judged on its own facts laid over its item's: a row stating only a
  reverse mark inherits the rest, and a row that alone lacks intent is named
- A row position beyond the item's rows raises `entry_without_item` for that row
- Row facts stated against rows that were since reordered raise `rows_changed`;
  against the unchanged rows they raise nothing
- No inventory yields exactly one `no_inventory` notice of severity info
- An entry naming a KPI the paper does not number raises `unknown_kpi`, once
  per item and token; without the paper's tokens nothing of the kind is raised
- Warnings are counted by type

These unit tests load real QML through the loader and write entries through
the model's patch, so the comparison runs over the shapes production holds.
"""

import pytest
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.inventory import apply_patch, empty_inventory
from askalot_qml.inventory.warnings import inventory_warnings, warning_counts

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
        - id: q_trust
          kind: QuestionGroup
          title: "How much do you agree?"
          questions:
            - "I trust the service"
            - "The service hides things from me"
            - "I would recommend the service"
          input:
            control: Radio
            labels:
              1: Disagree
              2: Agree
        - id: q_grid
          kind: MatrixQuestion
          title: "Rate each branch"
          rows: ["North", "South", "East", "West", "Centre", "Online"]
          columns: ["Speed", "Care"]
          input:
            control: Radio
            labels:
              1: Poor
              2: Good
"""

_ROSTER_QML = """
qmlVersion: "2.0"
questionnaire:
  title: Household
  blocks:
    - id: b_who
      title: Who
      items:
        - id: q_members
          kind: Question
          title: "Who lives with you?"
          input:
            control: Checkbox
            labels:
              1: Partner
              2: Child
    - id: b_each
      kind: Roster
      title: Each member
      iterateOver: q_members.outcome
      labels:
        1: Partner
        2: Child
      items:
        - id: q_member_age
          kind: Question
          title: "How old is this person?"
          input:
            control: Editbox
            min: 0
            max: 120
"""

_AGE = {"item_id": "q_age", "kind": "fact", "purpose": "demographics"}
_TRUST = {"item_id": "q_trust", "kind": "opinion", "construct": "Trust", "kpis": ["KPI-1"]}
_GRID = {"item_id": "q_grid", "kind": "evaluation", "construct": "Branch quality"}


def _load(text: str = _QML) -> dict:
    return QMLLoader().load_from_string(text)


def _inventory(*entries: dict, qml: dict | None = None):
    result = apply_patch(empty_inventory(), upsert=list(entries), remove=[], rename=[], qml=qml)
    assert result.refusals == []
    return result.inventory


def _types(issues: list[dict]) -> list[tuple[str | None, str]]:
    return [(issue["item_id"], issue["type"]) for issue in issues]


@pytest.fixture
def qml() -> dict:
    return _load()


class TestAgreement:
    def test_a_complete_inventory_raises_nothing(self, qml):
        assert inventory_warnings(qml, _inventory(_AGE, _TRUST, _GRID, qml=qml)) == []

    def test_changing_an_items_wording_changes_no_warning(self, qml):
        inventory = _inventory(_AGE, _TRUST, qml=qml)
        reworded = _load(_QML.replace("How old are you?", "What is your age in years?"))

        assert inventory_warnings(reworded, inventory) == inventory_warnings(qml, inventory)

    def test_a_kind_and_a_purpose_with_no_construct_raise_nothing(self, qml):
        issues = inventory_warnings(qml, _inventory(_AGE, _TRUST, _GRID, qml=qml))

        assert [issue for issue in issues if issue["item_id"] == "q_age"] == []


class TestItemsAndEntries:
    def test_a_question_with_no_entry_raises_item_without_entry(self, qml):
        issues = inventory_warnings(qml, _inventory(_TRUST, _GRID, qml=qml))

        assert _types(issues) == [("q_age", "item_without_entry")]
        assert issues[0]["severity"] == "warning"
        assert "`q_age`" in issues[0]["message"]
        assert set(issues[0]) == {"item_id", "severity", "type", "message", "suggestion"}

    def test_a_comment_never_needs_an_entry(self, qml):
        issues = inventory_warnings(qml, empty_inventory())

        assert _types(issues) == [
            ("q_age", "item_without_entry"),
            ("q_trust", "item_without_entry"),
            ("q_grid", "item_without_entry"),
        ]

    def test_a_question_inside_a_roster_needs_an_entry(self):
        issues = inventory_warnings(_load(_ROSTER_QML), empty_inventory())

        assert _types(issues) == [
            ("q_members", "item_without_entry"),
            ("q_member_age", "item_without_entry"),
        ]

    def test_an_entry_whose_item_is_gone_raises_entry_without_item_naming_the_id(self, qml):
        inventory = _inventory(
            _AGE, _TRUST, _GRID, {"item_id": "q_removed", "kind": "fact", "purpose": "routing"}, qml=qml
        )

        issues = inventory_warnings(qml, inventory)

        assert _types(issues) == [("q_removed", "entry_without_item")]
        assert "`q_removed`" in issues[0]["message"]
        assert issues[0]["severity"] == "warning"

    def test_orphan_entries_come_after_the_items_in_document_order(self, qml):
        inventory = _inventory({"item_id": "a_removed", "kind": "fact", "purpose": "routing"}, _GRID, qml=qml)

        assert _types(inventory_warnings(qml, inventory)) == [
            ("q_age", "item_without_entry"),
            ("q_trust", "item_without_entry"),
            ("a_removed", "entry_without_item"),
        ]


class TestIntent:
    def test_an_entry_with_neither_construct_nor_purpose_raises_intent_missing(self, qml):
        inventory = _inventory({"item_id": "q_age", "kind": "fact"}, _TRUST, _GRID, qml=qml)

        issues = inventory_warnings(qml, inventory)

        assert _types(issues) == [("q_age", "intent_missing")]
        assert "construct" in issues[0]["message"] and "purpose" in issues[0]["message"]

    def test_an_entry_with_no_kind_raises_intent_missing(self, qml):
        inventory = _inventory({"item_id": "q_age", "purpose": "demographics"}, _TRUST, _GRID, qml=qml)

        issues = inventory_warnings(qml, inventory)

        assert _types(issues) == [("q_age", "intent_missing")]
        assert "kind of measure" in issues[0]["message"]

    def test_a_row_stating_only_a_reverse_mark_inherits_its_items_intent(self, qml):
        trust = {**_TRUST, "rows": {"2": {"reversed": True}}}

        assert inventory_warnings(qml, _inventory(_AGE, trust, _GRID, qml=qml)) == []

    def test_rows_that_state_the_intent_their_item_leaves_out_raise_nothing(self, qml):
        trust = {
            "item_id": "q_trust",
            "kind": "opinion",
            "rows": {
                "1": {"construct": "Trust"},
                "2": {"construct": "Trust", "reversed": True},
                "3": {"construct": "Loyalty"},
            },
        }

        assert inventory_warnings(qml, _inventory(_AGE, trust, _GRID, qml=qml)) == []

    def test_a_row_that_alone_lacks_intent_is_named(self, qml):
        trust = {
            "item_id": "q_trust",
            "kind": "opinion",
            "rows": {"1": {"construct": "Trust"}, "2": {"construct": "Trust"}},
        }

        issues = inventory_warnings(qml, _inventory(_AGE, trust, _GRID, qml=qml))

        assert _types(issues) == [("q_trust", "intent_missing")]
        assert "row 3" in issues[0]["message"]


class TestRows:
    def test_a_row_beyond_the_items_rows_raises_entry_without_item_for_that_row(self, qml):
        grid = {**_GRID, "rows": {"7": {"reversed": True}}}

        issues = inventory_warnings(qml, _inventory(_AGE, _TRUST, grid, qml=qml))

        assert _types(issues) == [("q_grid", "entry_without_item")]
        assert "`q_grid`" in issues[0]["message"]
        assert "row 7" in issues[0]["message"]

    def test_row_facts_on_a_question_name_rows_it_does_not_have(self, qml):
        age = {**_AGE, "rows": {"1": {"reversed": True}}}

        issues = inventory_warnings(qml, _inventory(age, _TRUST, _GRID, qml=qml))

        assert _types(issues) == [("q_age", "entry_without_item")]

    def test_reordered_rows_raise_rows_changed(self, qml):
        trust = {**_TRUST, "rows": {"2": {"reversed": True}}}
        inventory = _inventory(_AGE, trust, _GRID, qml=qml)
        reordered = _load(
            _QML.replace(
                '            - "I trust the service"\n            - "The service hides things from me"\n',
                '            - "The service hides things from me"\n            - "I trust the service"\n',
            )
        )

        assert inventory_warnings(qml, inventory) == []
        issues = inventory_warnings(reordered, inventory)
        assert _types(issues) == [("q_trust", "rows_changed")]
        assert issues[0]["severity"] == "warning"
        assert "`q_trust`" in issues[0]["message"]

    def test_row_facts_stated_before_the_item_existed_raise_rows_changed(self, qml):
        trust = {**_TRUST, "rows": {"2": {"reversed": True}}}
        inventory = _inventory(_AGE, trust, _GRID, qml=None)

        assert inventory.items["q_trust"].rows_digest is None
        assert _types(inventory_warnings(qml, inventory)) == [("q_trust", "rows_changed")]

    def test_reordered_rows_of_an_entry_with_no_row_facts_raise_nothing(self, qml):
        inventory = _inventory(_AGE, _TRUST, _GRID, qml=qml)
        reordered = _load(_QML.replace('["North", "South",', '["South", "North",'))

        assert inventory_warnings(reordered, inventory) == []


class TestNoInventory:
    def test_no_inventory_is_one_notice_and_no_per_item_warning(self, qml):
        issues = inventory_warnings(qml, None)

        assert _types(issues) == [(None, "no_inventory")]
        assert issues[0]["severity"] == "info"
        assert issues[0]["message"]

    def test_an_empty_inventory_is_not_a_missing_one(self, qml):
        assert "no_inventory" not in {issue["type"] for issue in inventory_warnings(qml, empty_inventory())}


class TestUnknownKpi:
    def test_a_kpi_the_paper_does_not_number_raises_unknown_kpi(self, qml):
        inventory = _inventory(_AGE, {**_TRUST, "kpis": ["KPI-1", "KPI-9"]}, _GRID, qml=qml)

        issues = inventory_warnings(qml, inventory, kpi_tokens=["KPI-1", "KPI-2", "KPI-3"])

        assert _types(issues) == [("q_trust", "unknown_kpi")]
        assert "KPI-9" in issues[0]["message"]
        assert issues[0]["severity"] == "warning"

    def test_without_the_papers_tokens_nothing_is_raised(self, qml):
        inventory = _inventory(_AGE, {**_TRUST, "kpis": ["KPI-9"]}, _GRID, qml=qml)

        assert inventory_warnings(qml, inventory) == []
        assert inventory_warnings(qml, inventory, kpi_tokens=None) == []

    def test_a_paper_that_numbers_no_kpi_makes_every_named_one_unknown(self, qml):
        inventory = _inventory(_AGE, _TRUST, _GRID, qml=qml)

        assert _types(inventory_warnings(qml, inventory, kpi_tokens=[])) == [("q_trust", "unknown_kpi")]

    def test_a_rows_own_unknown_kpi_is_raised_once_for_its_item(self, qml):
        trust = {**_TRUST, "rows": {"1": {"kpis": ["KPI-7"]}, "2": {"kpis": ["KPI-7", "KPI-1"]}}}
        inventory = _inventory(_AGE, trust, _GRID, qml=qml)

        issues = inventory_warnings(qml, inventory, kpi_tokens=["KPI-1"])

        assert _types(issues) == [("q_trust", "unknown_kpi")]

    def test_an_entry_whose_item_is_gone_raises_no_unknown_kpi(self, qml):
        gone = {"item_id": "q_gone", "kind": "fact", "purpose": "routing", "kpis": ["KPI-9"]}
        inventory = _inventory(_AGE, _TRUST, _GRID, gone, qml=qml)

        issues = inventory_warnings(qml, inventory, kpi_tokens=["KPI-1"])

        assert _types(issues) == [("q_gone", "entry_without_item")]


class TestCounts:
    def test_warnings_are_counted_by_type(self, qml):
        inventory = _inventory(
            {"item_id": "q_age", "kind": "fact"},
            {"item_id": "q_gone", "kind": "fact", "purpose": "routing"},
            qml=qml,
        )

        assert warning_counts(inventory_warnings(qml, inventory)) == {
            "intent_missing": 1,
            "item_without_entry": 2,
            "entry_without_item": 1,
        }

    def test_no_issues_count_as_nothing(self):
        assert warning_counts([]) == {}

    def test_no_message_names_an_action(self, qml):
        inventory = _inventory(
            {"item_id": "q_age"},
            {**_TRUST, "rows": {"9": {"reversed": True}}},
            {"item_id": "q_gone", "kind": "fact", "purpose": "routing"},
        )

        issues = inventory_warnings(qml, inventory, kpi_tokens=[]) + inventory_warnings(qml, None)

        assert {issue["type"] for issue in issues} == {
            "unknown_kpi",
            "intent_missing",
            "entry_without_item",
            "rows_changed",
            "item_without_entry",
            "no_inventory",
        }
        assert all(issue["message"].endswith(".") for issue in issues)
        assert all(issue["suggestion"] == "" for issue in issues)
