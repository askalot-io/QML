"""
The inventory/v1 model that validates a questionnaire inventory before it is stored.

Tests askalot_qml.inventory.model and the report summary it carries:
- The WHO AUDIT inventory fixture round-trips through JSON with no loss
- Its ids are the ones map_source_ids gives the printed ids, and the report lists the mapping
- A question whose QML id the loader refuses (`1`, `len`, `codeInit`) is refused
- Two QML ids equal in lower case are refused
- A question missing from the scope table is refused, and so is a scope row naming no question
- An OUT unit with no reason is refused
- An unknown key and a malformed language tag are refused; a well-formed tag
  outside the supported locales is kept in its canonical spelling
- The report summary counts IN and OUT units, lists OUT reasons and invented checks

These unit tests build every case from the stored fixture, so each refusal is a
one-field change to an inventory that is otherwise valid.
"""

import copy
import json
from pathlib import Path

import pytest
from askalot_qml.inventory import (
    Inventory,
    map_source_ids,
    parse_inventory,
    report_summary,
    serialize_inventory,
)
from pydantic import ValidationError

_FIXTURE = Path(__file__).resolve().parents[2] / "fixtures" / "inventory" / "who_audit.json"


@pytest.fixture
def audit() -> dict:
    return json.loads(_FIXTURE.read_text(encoding="utf-8"))


def _audit_questions(data: dict) -> list[dict]:
    return data["sections"][1]["questions"]


def test_the_audit_fixture_round_trips_through_json(audit):
    inventory = parse_inventory(json.dumps(audit))

    again = parse_inventory(serialize_inventory(inventory))

    assert again == inventory
    assert json.loads(serialize_inventory(again)) == json.loads(serialize_inventory(inventory))
    assert json.loads(serialize_inventory(inventory))["schema"] == "inventory/v1"


def test_the_audit_ids_are_the_mappers_and_the_report_lists_them(audit):
    inventory = Inventory.model_validate(audit)
    questions = list(inventory.questions())

    assert [q.qml_id for q in questions] == map_source_ids([q.source_id for q in questions])
    mapping = report_summary(inventory)["id_mapping"]
    assert mapping[1:] == [{"source_id": str(n), "qml_id": f"Q{n}"} for n in range(1, 11)]


@pytest.mark.parametrize("qml_id", ["1", "len", "codeInit", "if", "Q 1"])
def test_a_qml_id_the_loader_refuses_is_refused(audit, qml_id):
    _audit_questions(audit)[0]["qml_id"] = qml_id
    audit["scope"][1]["qml_id"] = qml_id

    with pytest.raises(ValidationError, match="not an item id the QML loader accepts"):
        Inventory.model_validate(audit)


def test_qml_ids_equal_in_lower_case_are_refused(audit):
    _audit_questions(audit)[1]["qml_id"] = "q1"
    audit["scope"][2]["qml_id"] = "q1"

    with pytest.raises(ValidationError, match="used twice"):
        Inventory.model_validate(audit)


def test_a_question_left_out_of_the_scope_table_is_refused(audit):
    audit["scope"] = [row for row in audit["scope"] if row.get("qml_id") != "Q7"]

    with pytest.raises(ValidationError, match="'Q7'.*missing from the scope table"):
        Inventory.model_validate(audit)


def test_a_scope_row_naming_no_question_is_refused(audit):
    audit["scope"].append({"unit": "Question 11", "status": "in", "qml_id": "Q11"})

    with pytest.raises(ValidationError, match="which no question has"):
        Inventory.model_validate(audit)


def test_an_out_unit_without_a_reason_is_refused(audit):
    del audit["scope"][-1]["reason"]

    with pytest.raises(ValidationError, match="gives no reason"):
        Inventory.model_validate(audit)


def test_an_unknown_key_is_refused(audit):
    broken = copy.deepcopy(audit)
    _audit_questions(broken)[0]["answer"] = 3

    with pytest.raises(ValidationError, match="answer"):
        Inventory.model_validate(broken)


@pytest.mark.parametrize("value", ["English", "pt_BR!", "en-GB-oxendict"])
def test_a_malformed_language_tag_is_refused(audit, value):
    audit["source_language"] = value

    with pytest.raises(ValidationError, match="BCP-47"):
        Inventory.model_validate(audit)


@pytest.mark.parametrize("value,stored", [("pt-BR", "pt-BR"), ("pt_br", "pt-BR"), ("it", "it"), ("en-GB", "en")])
def test_any_questionnaire_language_is_kept_in_its_canonical_spelling(audit, value, stored):
    audit["source_language"] = value

    assert Inventory.model_validate(audit).source_language == stored


def test_a_designed_inventory_needs_no_provenance_or_report(audit):
    for section in audit["sections"]:
        section.pop("provenance", None)
        for question in section["questions"]:
            question.pop("provenance", None)
            for condition in (
                *question.get("preconditions", []),
                *question.get("postconditions", []),
            ):
                condition.pop("provenance", None)
    for row in audit["scope"]:
        row.pop("provenance", None)
    del audit["report"]

    inventory = Inventory.model_validate(audit)

    assert report_summary(inventory)["import"] is None


def test_the_report_summary_counts_scope_and_lists_invented_checks(audit):
    summary = report_summary(Inventory.model_validate(audit))

    assert summary["scope"]["in"] == 12
    assert summary["scope"]["out"] == 2
    assert {row["unit"] for row in summary["scope"]["out_units"]} == {
        "Scoring table",
        "Patient name and date",
    }
    assert [check["qml_id"] for check in summary["invented_checks"]] == ["Q3"]
    assert summary["import"]["vision_pages"] == [2]
    assert summary["import"]["answers_discarded"] is False
