"""
The closed model of a questionnaire's living item inventory and its patch operations.

Tests askalot_qml.inventory.model:
- A patch is refused, naming the item and the problem, for a kind or purpose
  outside the fixed lists, a key that belongs to the QML, a borrowed origin
  with no instrument, a row position below 1, an item id that is empty or no
  string, and a rows digest the caller supplies
- A rename moves an entry whole, and is refused when its source has no entry
  or its target already has one
- An upsert replaces the whole entry, and an entry for an item the QML does
  not ask yet is accepted
- A batch with one bad entry returns every refusal and leaves the inventory unchanged
- Row facts are keyed by position and survive serialize and parse; serializing
  the same inventory twice gives the same text
- Two construct names differing only by case and surrounding space share one key
- The rows digest is computed from the given QML when the item exists there,
  and is absent when it does not; given a second QML for the rows, it is
  computed from that one
- An upsert whose row facts equal the stored entry's keeps the stored digest,
  so a change of item-level facts never confirms rows; ``rows_confirmed``
  stamps it again, is never stored, and is refused on an entry without rows
- A battery's rows are its sub-questions or matrix rows as plain text, 1-based
  in document order
- ``without_kpis`` empties every entry's KPI list and every row's that states
  one, leaves a row that states none following its item, and keeps every other
  fact, the rows digest and the given inventory itself as they were

These unit tests load small real QML through the loader, so the row shapes the
model reads are the loader's own and a change there breaks them.
"""

import json

import pytest
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.inventory import (
    INVENTORY_SCHEMA,
    MEASURE_KINDS,
    PURPOSES,
    ItemInventory,
    apply_patch,
    construct_key,
    empty_inventory,
    parse_inventory,
    row_texts,
    rows_digest,
    serialize_inventory,
    without_kpis,
)
from pydantic import ValidationError

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
            - "I **trust**   the service"
            - "The service <em>hides</em> things from me"
          input:
            control: Radio
            labels:
              1: Disagree
              2: Agree
        - id: q_grid
          kind: MatrixQuestion
          title: "Rate each branch"
          rows: ["North [branch](https://example.org)", "South branch"]
          columns: ["Speed", "Care"]
          input:
            control: Radio
            labels:
              1: Poor
              2: Good
"""


@pytest.fixture
def qml() -> dict:
    return QMLLoader().load_from_string(_QML)


def _item(qml: dict, item_id: str) -> dict:
    return next(item for item in qml["items"] if item["id"] == item_id)


def _patch(
    inventory: ItemInventory | None = None,
    *,
    qml: dict | None = None,
    rows_qml: dict | None = None,
    **operations,
):
    return apply_patch(
        inventory or empty_inventory(),
        upsert=operations.get("upsert", []),
        remove=operations.get("remove", []),
        rename=operations.get("rename", []),
        qml=qml,
        rows_qml=rows_qml,
    )


def _with(*entries: dict, qml: dict | None = None) -> ItemInventory:
    result = _patch(upsert=list(entries), qml=qml)
    assert result.refusals == []
    return result.inventory


def _reordered(qml: dict) -> dict:
    """``qml`` with the rows of ``q_trust`` in the opposite order."""
    items = [
        {**item, "questions": list(reversed(item["questions"]))} if item["id"] == "q_trust" else item
        for item in qml["items"]
    ]
    return {**qml, "items": items}


def _only_refusal(result) -> dict:
    assert len(result.refusals) == 1, result.refusals
    return result.refusals[0]


class TestRefusals:
    def test_a_kind_outside_the_fixed_list_names_the_item_and_the_value(self):
        refusal = _only_refusal(_patch(upsert=[{"item_id": "q_age", "kind": "attitude"}]))

        assert refusal["item_id"] == "q_age"
        assert "'attitude'" in refusal["problem"]
        assert all(kind in refusal["problem"] for kind in MEASURE_KINDS)

    def test_a_purpose_outside_the_fixed_list_names_the_item_and_the_value(self):
        refusal = _only_refusal(_patch(upsert=[{"item_id": "q_age", "purpose": "filler"}]))

        assert refusal["item_id"] == "q_age"
        assert "'filler'" in refusal["problem"]
        assert all(purpose in refusal["problem"] for purpose in PURPOSES)

    @pytest.mark.parametrize(
        "key",
        [
            "text",
            "title",
            "label",
            "labels",
            "codes",
            "scale",
            "answer_type",
            "preconditions",
            "postconditions",
        ],
    )
    def test_a_key_that_belongs_to_the_qml_is_refused_by_name(self, key):
        refusal = _only_refusal(
            _patch(upsert=[{"item_id": "q_age", "kind": "fact", key: "anything"}])
        )

        assert refusal["item_id"] == "q_age"
        assert f"`{key}`" in refusal["problem"]
        assert "QML" in refusal["problem"]

    def test_a_qml_key_inside_a_row_is_refused_by_name(self):
        refusal = _only_refusal(
            _patch(upsert=[{"item_id": "q_trust", "kind": "opinion", "rows": {"2": {"text": "x"}}}])
        )

        assert refusal["item_id"] == "q_trust"
        assert "`text`" in refusal["problem"]
        assert "Row 2" in refusal["problem"]

    def test_an_unknown_key_is_refused_by_name(self):
        refusal = _only_refusal(_patch(upsert=[{"item_id": "q_age", "konstruct": "Age"}]))

        assert refusal["item_id"] == "q_age"
        assert "`konstruct`" in refusal["problem"]

    @pytest.mark.parametrize("mode", ["verbatim", "adapted"])
    def test_a_borrowed_origin_with_no_instrument_is_refused(self, mode):
        refusal = _only_refusal(
            _patch(upsert=[{"item_id": "q_age", "kind": "fact", "origin": {"mode": mode}}])
        )

        assert refusal["item_id"] == "q_age"
        assert f"'{mode}'" in refusal["problem"]
        assert "instrument" in refusal["problem"]

    def test_a_new_origin_needs_no_instrument(self):
        inventory = _with({"item_id": "q_age", "kind": "fact", "origin": {"mode": "new"}})

        assert inventory.items["q_age"].origin.mode == "new"
        assert inventory.items["q_age"].origin.instrument is None

    def test_a_rename_onto_an_id_that_has_an_entry_is_refused(self):
        inventory = _with({"item_id": "q_a", "kind": "fact"}, {"item_id": "q_b", "kind": "fact"})

        refusal = _only_refusal(_patch(inventory, rename=[{"from": "q_a", "to": "q_b"}]))

        assert refusal["item_id"] == "q_a"
        assert "`q_b`" in refusal["problem"]

    def test_a_rename_from_an_id_with_no_entry_is_refused(self):
        refusal = _only_refusal(_patch(rename=[{"from": "q_gone", "to": "q_new"}]))

        assert refusal["item_id"] == "q_gone"
        assert "no entry" in refusal["problem"]

    @pytest.mark.parametrize("position", ["0", "-1"])
    def test_a_row_position_below_one_is_refused(self, position):
        refusal = _only_refusal(
            _patch(
                upsert=[
                    {"item_id": "q_trust", "kind": "opinion", "rows": {position: {"reversed": True}}}
                ]
            )
        )

        assert refusal["item_id"] == "q_trust"
        assert position in refusal["problem"]
        assert "1" in refusal["problem"]

    @pytest.mark.parametrize("item_id", ["", "   ", 7, None])
    def test_an_item_id_that_is_empty_or_no_string_is_refused(self, item_id):
        refusal = _only_refusal(_patch(upsert=[{"item_id": item_id, "kind": "fact"}]))

        assert "item id" in refusal["problem"]

    def test_an_upsert_with_no_item_id_is_refused(self):
        refusal = _only_refusal(_patch(upsert=[{"kind": "fact"}]))

        assert "item id" in refusal["problem"]

    def test_a_rows_digest_from_the_caller_is_refused(self, qml):
        refusal = _only_refusal(
            _patch(
                upsert=[
                    {
                        "item_id": "q_trust",
                        "kind": "opinion",
                        "rows": {"2": {"reversed": True}},
                        "rows_digest": "abc",
                    }
                ],
                qml=qml,
            )
        )

        assert refusal["item_id"] == "q_trust"
        assert "`rows_digest`" in refusal["problem"]

    def test_a_batch_with_one_bad_entry_returns_every_refusal_and_changes_nothing(self):
        before = _with({"item_id": "q_keep", "kind": "fact", "purpose": "demographics"})

        result = _patch(
            before,
            upsert=[
                {"item_id": "q_good", "kind": "opinion", "construct": "Trust"},
                {"item_id": "q_bad", "kind": "attitude", "text": "How old?"},
                {"item_id": "q_worse", "purpose": "filler"},
            ],
            remove=["q_keep"],
            rename=[{"from": "q_missing", "to": "q_other"}],
        )

        assert sorted(r["item_id"] for r in result.refusals) == [
            "q_bad",
            "q_bad",
            "q_missing",
            "q_worse",
        ]
        assert result.inventory == before
        assert serialize_inventory(result.inventory) == serialize_inventory(before)


class TestOperations:
    def test_an_upsert_replaces_the_whole_entry(self):
        before = _with(
            {"item_id": "q_age", "kind": "fact", "construct": "Age", "kpis": ["KPI-1"], "reversed": True}
        )

        after = _patch(before, upsert=[{"item_id": "q_age", "kind": "fact", "purpose": "demographics"}])

        assert after.refusals == []
        entry = after.inventory.items["q_age"]
        assert entry.construct is None
        assert entry.kpis == []
        assert entry.reversed is False
        assert entry.purpose == "demographics"
        assert before.items["q_age"].construct == "Age"

    def test_an_entry_for_an_item_the_qml_does_not_ask_is_accepted(self, qml):
        result = _patch(upsert=[{"item_id": "q_not_written_yet", "kind": "opinion"}], qml=qml)

        assert result.refusals == []
        assert "q_not_written_yet" in result.inventory.items

    def test_an_entry_with_no_kind_and_no_intent_is_accepted(self):
        result = _patch(upsert=[{"item_id": "q_age"}])

        assert result.refusals == []
        assert result.inventory.items["q_age"].kind is None

    def test_kpi_tokens_are_stored_as_given(self):
        inventory = _with({"item_id": "q_age", "kind": "fact", "kpis": ["KPI-2", "kpi 9"]})

        assert inventory.items["q_age"].kpis == ["KPI-2", "kpi 9"]

    def test_a_rename_moves_the_entry_whole(self, qml):
        before = _with(
            {
                "item_id": "q_trust",
                "kind": "opinion",
                "construct": "Trust",
                "kpis": ["KPI-1"],
                "origin": {"mode": "adapted", "instrument": "ESS", "item": "B3"},
                "rows": {"2": {"reversed": True}},
            },
            qml=qml,
        )

        after = _patch(before, rename=[{"from": "q_trust", "to": "q_confidence"}])

        assert after.refusals == []
        assert "q_trust" not in after.inventory.items
        assert after.inventory.items["q_confidence"] == before.items["q_trust"]

    def test_a_remove_drops_the_entry(self):
        before = _with({"item_id": "q_a", "kind": "fact"}, {"item_id": "q_b", "kind": "fact"})

        after = _patch(before, remove=["q_a"])

        assert after.refusals == []
        assert list(after.inventory.items) == ["q_b"]


class TestStoredForm:
    def test_an_empty_inventory_carries_the_format_tag(self):
        assert json.loads(serialize_inventory(empty_inventory())) == {
            "schema": INVENTORY_SCHEMA,
            "items": {},
        }
        assert INVENTORY_SCHEMA == "item-inventory/v1"

    def test_row_facts_round_trip_keyed_by_position(self, qml):
        inventory = _with(
            {
                "item_id": "q_trust",
                "kind": "opinion",
                "construct": "Trust",
                "rows": {"2": {"reversed": True}, "1": {"kpis": ["KPI-3"]}},
            },
            qml=qml,
        )

        text = serialize_inventory(inventory)
        again = parse_inventory(text)

        assert again == inventory
        assert sorted(again.items["q_trust"].rows) == [1, 2]
        assert again.items["q_trust"].rows[2].reversed is True
        assert again.items["q_trust"].rows[1].kpis == ["KPI-3"]
        assert list(json.loads(text)["items"]["q_trust"]["rows"]) == ["1", "2"]

    def test_serializing_is_stable(self):
        one = _with(
            {"item_id": "q_b", "kind": "fact", "purpose": "demographics"},
            {"item_id": "q_a", "construct": "Trust", "kind": "opinion"},
        )
        other = _with(
            {"item_id": "q_a", "kind": "opinion", "construct": "Trust"},
            {"item_id": "q_b", "purpose": "demographics", "kind": "fact"},
        )

        assert serialize_inventory(one) == serialize_inventory(other)
        assert serialize_inventory(one) == serialize_inventory(parse_inventory(serialize_inventory(one)))

    def test_stored_content_with_an_unknown_key_does_not_parse(self):
        content = json.dumps({"schema": INVENTORY_SCHEMA, "items": {"q_a": {"text": "How old?"}}})

        with pytest.raises(ValidationError):
            parse_inventory(content)

    def test_stored_content_of_another_format_does_not_parse(self):
        with pytest.raises(ValidationError):
            parse_inventory(json.dumps({"schema": "inventory/v1", "items": {}}))


class TestConstructKey:
    def test_names_differing_by_case_and_surrounding_space_share_one_key(self):
        assert construct_key("  Institutional Trust ") == construct_key("institutional trust")

    def test_different_names_have_different_keys(self):
        assert construct_key("Trust") != construct_key("Trust in courts")


class TestRows:
    def test_a_question_group_s_rows_are_its_sub_questions_as_plain_text(self, qml):
        assert row_texts(_item(qml, "q_trust")) == [
            "I trust the service",
            "The service hides things from me",
        ]

    def test_a_matrix_s_rows_are_its_rows_as_plain_text(self, qml):
        assert row_texts(_item(qml, "q_grid")) == ["North branch", "South branch"]

    def test_a_question_has_no_rows(self, qml):
        assert row_texts(_item(qml, "q_age")) == []

    def test_the_digest_follows_the_row_list(self):
        assert rows_digest(["a", "b"]) == rows_digest(["a", "b"])
        assert rows_digest(["a", "b"]) != rows_digest(["b", "a"])
        assert rows_digest(["a", "b"]) != rows_digest(["a", "b", "c"])
        assert rows_digest(["ab"]) != rows_digest(["a", "b"])

    def test_the_digest_is_computed_when_the_item_exists_in_the_qml(self, qml):
        inventory = _with(
            {"item_id": "q_trust", "kind": "opinion", "rows": {"2": {"reversed": True}}}, qml=qml
        )

        assert inventory.items["q_trust"].rows_digest == rows_digest(row_texts(_item(qml, "q_trust")))

    def test_the_digest_is_absent_when_the_item_is_not_in_the_qml(self, qml):
        inventory = _with(
            {"item_id": "q_later", "kind": "opinion", "rows": {"2": {"reversed": True}}}, qml=qml
        )

        assert inventory.items["q_later"].rows_digest is None

    def test_the_digest_is_absent_when_no_qml_is_given(self):
        inventory = _with({"item_id": "q_trust", "kind": "opinion", "rows": {"2": {"reversed": True}}})

        assert inventory.items["q_trust"].rows_digest is None

    def test_an_entry_with_no_row_facts_carries_no_digest(self, qml):
        inventory = _with({"item_id": "q_trust", "kind": "opinion"}, qml=qml)

        assert inventory.items["q_trust"].rows_digest is None


class TestWithoutKpis:
    @pytest.fixture
    def linked(self, qml) -> ItemInventory:
        return apply_patch(
            empty_inventory(),
            upsert=[
                {
                    "item_id": "q_trust",
                    "construct": "Trust",
                    "kind": "opinion",
                    "kpis": ["KPI-1", "KPI-2"],
                    "origin": {"mode": "adapted", "instrument": "Trust scale"},
                    "rows": {
                        "1": {"kpis": ["KPI-3"]},
                        "2": {"reversed": True},
                    },
                },
                {"item_id": "q_age", "kind": "fact", "purpose": "demographics"},
                {"item_id": "q_grid", "construct": "Reach", "kind": "behaviour", "kpis": ["KPI-2"]},
            ],
            remove=[],
            rename=[],
            qml=qml,
        ).inventory

    def test_no_entry_and_no_row_names_a_kpi_afterwards(self, linked):
        unlinked = without_kpis(linked)

        assert [entry.kpis for entry in unlinked.items.values()] == [[], [], []]
        assert unlinked.items["q_trust"].rows[1].kpis == []
        assert "KPI-" not in serialize_inventory(unlinked)

    def test_a_row_stating_no_kpi_list_keeps_following_its_item(self, linked):
        assert without_kpis(linked).items["q_trust"].rows[2].kpis is None

    def test_every_other_fact_and_the_rows_digest_are_kept(self, linked, qml):
        unlinked = without_kpis(linked)

        def facts(inventory: ItemInventory) -> dict:
            data = json.loads(serialize_inventory(inventory))
            for entry in data["items"].values():
                entry.pop("kpis", None)
                for row in entry.get("rows", {}).values():
                    row.pop("kpis", None)
            return data

        assert facts(unlinked) == facts(linked)
        assert unlinked.items["q_trust"].rows_digest == rows_digest(row_texts(_item(qml, "q_trust")))
        assert list(unlinked.items) == list(linked.items)

    def test_the_given_inventory_is_not_changed(self, linked):
        before = serialize_inventory(linked)

        without_kpis(linked)

        assert serialize_inventory(linked) == before

    def test_the_result_is_stored_content_that_parses_back_to_itself(self, linked):
        unlinked = without_kpis(linked)

        assert parse_inventory(serialize_inventory(unlinked)) == unlinked

    def test_an_inventory_naming_no_kpi_is_returned_equal(self, qml):
        plain = _with({"item_id": "q_age", "kind": "fact", "purpose": "demographics"}, qml=qml)

        assert without_kpis(plain) == plain


_TRUST_ROWS = {"item_id": "q_trust", "kind": "opinion", "rows": {"2": {"reversed": True}}}


class TestRowsDigestOfAnUpsert:
    def test_the_digest_is_computed_from_the_rows_qml_when_one_is_given(self, qml):
        read = _reordered(qml)

        result = _patch(upsert=[_TRUST_ROWS], qml=qml, rows_qml=read)

        digest = result.inventory.items["q_trust"].rows_digest
        assert digest == rows_digest(row_texts(_item(read, "q_trust")))
        assert digest != rows_digest(row_texts(_item(qml, "q_trust")))

    def test_an_item_the_rows_qml_does_not_ask_leaves_the_digest_absent(self, qml):
        result = _patch(upsert=[_TRUST_ROWS], qml=qml, rows_qml={"items": []})

        assert result.refusals == []
        assert result.inventory.items["q_trust"].rows_digest is None

    def test_an_upsert_with_the_same_row_facts_keeps_the_stored_digest(self, qml):
        before = _with(_TRUST_ROWS, qml=qml)
        head = _reordered(qml)

        after = _patch(before, upsert=[{**_TRUST_ROWS, "kpis": ["KPI-1"]}], qml=head)

        entry = after.inventory.items["q_trust"]
        assert entry.kpis == ["KPI-1"]
        assert entry.rows_digest == before.items["q_trust"].rows_digest
        assert entry.rows_digest != rows_digest(row_texts(_item(head, "q_trust")))

    def test_an_upsert_with_the_same_row_facts_keeps_a_digest_never_recorded(self, qml):
        before = _with(_TRUST_ROWS)

        after = _patch(before, upsert=[{**_TRUST_ROWS, "construct": "Trust"}], qml=qml)

        assert after.inventory.items["q_trust"].rows_digest is None

    def test_an_upsert_with_other_row_facts_stamps_the_digest_again(self, qml):
        before = _with(_TRUST_ROWS, qml=qml)
        head = _reordered(qml)

        after = _patch(before, upsert=[{**_TRUST_ROWS, "rows": {"1": {"reversed": True}}}], qml=head)

        assert after.inventory.items["q_trust"].rows_digest == rows_digest(
            row_texts(_item(head, "q_trust"))
        )

    def test_rows_confirmed_stamps_the_digest_of_unchanged_row_facts(self, qml):
        before = _with(_TRUST_ROWS, qml=qml)
        head = _reordered(qml)

        after = _patch(before, upsert=[{**_TRUST_ROWS, "rows_confirmed": True}], qml=head)

        assert after.refusals == []
        entry = after.inventory.items["q_trust"]
        assert entry.rows_digest == rows_digest(row_texts(_item(head, "q_trust")))
        assert "rows_confirmed" not in json.loads(serialize_inventory(after.inventory))["items"]["q_trust"]

    def test_rows_confirmed_false_keeps_the_stored_digest(self, qml):
        before = _with(_TRUST_ROWS, qml=qml)

        after = _patch(
            before, upsert=[{**_TRUST_ROWS, "rows_confirmed": False}], qml=_reordered(qml)
        )

        assert after.refusals == []
        assert after.inventory.items["q_trust"].rows_digest == before.items["q_trust"].rows_digest

    def test_rows_confirmed_on_an_entry_without_rows_is_refused_by_name(self, qml):
        refusal = _only_refusal(
            _patch(upsert=[{"item_id": "q_age", "kind": "fact", "rows_confirmed": True}], qml=qml)
        )

        assert refusal["item_id"] == "q_age"
        assert "`rows_confirmed`" in refusal["problem"]
        assert "row facts" in refusal["problem"]

    def test_rows_confirmed_that_is_no_boolean_is_refused_by_name(self, qml):
        refusal = _only_refusal(
            _patch(upsert=[{**_TRUST_ROWS, "rows_confirmed": "yes"}], qml=qml)
        )

        assert refusal["item_id"] == "q_trust"
        assert "`rows_confirmed`" in refusal["problem"]

    def test_stored_content_carrying_rows_confirmed_does_not_parse(self):
        content = json.dumps(
            {"schema": INVENTORY_SCHEMA, "items": {"q_a": {"rows_confirmed": True}}}
        )

        with pytest.raises(ValidationError):
            parse_inventory(content)
