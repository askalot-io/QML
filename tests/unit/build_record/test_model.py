"""
The inventory/v1 model that validates a questionnaire build record before it is stored.

Tests askalot_qml.build_record.model and the report summary it carries:
- The WHO AUDIT build record fixture round-trips through JSON with no loss
- Its ids are the ones map_source_ids gives the printed ids, and the report lists the mapping
- A question whose QML id the loader refuses (`1`, `len`, `codeInit`) is refused
- Two QML ids equal in lower case are refused
- A question missing from the scope table is refused, and so is a scope row naming no question
- An OUT unit with no reason is refused
- An unknown key and a malformed language tag are refused; a well-formed tag
  outside the supported locales is kept in its canonical spelling
- A question's declared rating scale is stored with every key (codes above the
  range kept), and refused when a point is missing from its codes, a code lies
  below the range, the declaration is malformed (a point count above the
  maximum, a `start` written as a float), or the question is not a single
  choice; the refusal names a few codes and counts the rest
- A question may state why its printed scale is not declared, from a closed
  set, never beside a declaration; the report summary lists exactly those
  questions with their reason
- The report summary counts IN and OUT units, lists OUT reasons and invented checks

These unit tests build every case from the stored fixture, so each refusal is a
one-field change to a build record that is otherwise valid.
"""

import copy
import json
from pathlib import Path

import pytest
from askalot_qml.build_record import (
    BuildRecord,
    map_source_ids,
    parse_build_record,
    report_summary,
    serialize_build_record,
)
from pydantic import ValidationError

_FIXTURE = Path(__file__).resolve().parents[2] / "fixtures" / "build_record" / "who_audit.json"


@pytest.fixture
def audit() -> dict:
    return json.loads(_FIXTURE.read_text(encoding="utf-8"))


def _audit_questions(data: dict) -> list[dict]:
    return data["sections"][1]["questions"]


def test_the_audit_fixture_round_trips_through_json(audit):
    build_record = parse_build_record(json.dumps(audit))

    again = parse_build_record(serialize_build_record(build_record))

    assert again == build_record
    assert json.loads(serialize_build_record(again)) == json.loads(serialize_build_record(build_record))
    assert json.loads(serialize_build_record(build_record))["schema"] == "inventory/v1"


def test_the_audit_ids_are_the_mappers_and_the_report_lists_them(audit):
    build_record = BuildRecord.model_validate(audit)
    questions = list(build_record.questions())

    assert [q.qml_id for q in questions] == map_source_ids([q.source_id for q in questions])
    mapping = report_summary(build_record)["id_mapping"]
    assert mapping[1:] == [{"source_id": str(n), "qml_id": f"Q{n}"} for n in range(1, 11)]


@pytest.mark.parametrize("qml_id", ["1", "len", "codeInit", "if", "Q 1"])
def test_a_qml_id_the_loader_refuses_is_refused(audit, qml_id):
    _audit_questions(audit)[0]["qml_id"] = qml_id
    audit["scope"][1]["qml_id"] = qml_id

    with pytest.raises(ValidationError, match="not an item id the QML loader accepts"):
        BuildRecord.model_validate(audit)


def test_qml_ids_equal_in_lower_case_are_refused(audit):
    _audit_questions(audit)[1]["qml_id"] = "q1"
    audit["scope"][2]["qml_id"] = "q1"

    with pytest.raises(ValidationError, match="used twice"):
        BuildRecord.model_validate(audit)


def test_a_question_left_out_of_the_scope_table_is_refused(audit):
    audit["scope"] = [row for row in audit["scope"] if row.get("qml_id") != "Q7"]

    with pytest.raises(ValidationError, match="'Q7'.*missing from the scope table"):
        BuildRecord.model_validate(audit)


def test_a_scope_row_naming_no_question_is_refused(audit):
    audit["scope"].append({"unit": "Question 11", "status": "in", "qml_id": "Q11"})

    with pytest.raises(ValidationError, match="which no question has"):
        BuildRecord.model_validate(audit)


def test_an_out_unit_without_a_reason_is_refused(audit):
    del audit["scope"][-1]["reason"]

    with pytest.raises(ValidationError, match="gives no reason"):
        BuildRecord.model_validate(audit)


def test_an_unknown_key_is_refused(audit):
    broken = copy.deepcopy(audit)
    _audit_questions(broken)[0]["answer"] = 3

    with pytest.raises(ValidationError, match="answer"):
        BuildRecord.model_validate(broken)


@pytest.mark.parametrize("value", ["English", "pt_BR!", "en-GB-oxendict"])
def test_a_malformed_language_tag_is_refused(audit, value):
    audit["source_language"] = value

    with pytest.raises(ValidationError, match="BCP-47"):
        BuildRecord.model_validate(audit)


@pytest.mark.parametrize("value,stored", [("pt-BR", "pt-BR"), ("pt_br", "pt-BR"), ("it", "it"), ("en-GB", "en")])
def test_any_questionnaire_language_is_kept_in_its_canonical_spelling(audit, value, stored):
    audit["source_language"] = value

    assert BuildRecord.model_validate(audit).source_language == stored


def test_a_designed_build_record_needs_no_provenance_or_report(audit):
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

    build_record = BuildRecord.model_validate(audit)

    assert report_summary(build_record)["import"] is None


def test_the_report_summary_counts_scope_and_lists_invented_checks(audit):
    summary = report_summary(BuildRecord.model_validate(audit))

    assert summary["scope"]["in"] == 12
    assert summary["scope"]["out"] == 2
    assert {row["unit"] for row in summary["scope"]["out_units"]} == {
        "Scoring table",
        "Patient name and date",
    }
    assert [check["qml_id"] for check in summary["invented_checks"]] == ["Q3"]
    assert summary["import"]["vision_pages"] == [2]
    assert summary["import"]["answers_discarded"] is False


_AGREE = ["Strongly disagree", "Disagree", "Neither agree nor disagree", "Agree", "Strongly agree"]


def _rate_q1(audit: dict, codes: list[int], scale: dict, answer_type: str = "single_choice") -> None:
    question = _audit_questions(audit)[0]
    question["answer_type"] = answer_type
    labels = [*_AGREE, "Don't know"][: len(codes)]
    question["codes"] = [{"value": v, "label": label} for v, label in zip(codes, labels, strict=True)]
    question["scale"] = scale


def test_a_declared_scale_is_stored_with_every_key(audit):
    _rate_q1(audit, [1, 2, 3, 4, 5, 9], {"polarity": "bipolar", "points": 5})

    qml_id = _audit_questions(audit)[0]["qml_id"]
    question = next(q for q in BuildRecord.model_validate(audit).questions() if q.qml_id == qml_id)

    assert question.scale == {"polarity": "bipolar", "points": 5, "start": 1, "order": "ascending"}
    assert [code.value for code in question.codes] == [1, 2, 3, 4, 5, 9]


@pytest.mark.parametrize(
    ("codes", "scale", "answer_type", "message"),
    [
        ([0, 1, 2, 3, 4], {"polarity": "bipolar", "points": 5}, "single_choice", "code 5 is missing; code 0 is below"),
        ([1, 2, 3, 4, 5], {"polarity": "bipolar", "points": 6}, "single_choice", "code 6 is missing"),
        ([0, 1, 2, 3, 4, 5], {"polarity": "bipolar", "points": 5}, "single_choice", "code 0 is below the scale"),
        ([1, 2, 3, 4, 5], {"family": "Agreement", "points": 5}, "single_choice", "'family'"),
        ([1, 2, 3, 4, 5], {"polarity": "bipolar", "points": 10**9}, "single_choice", "from 2 to 101"),
        ([1, 2, 3, 4, 5], {"polarity": "bipolar", "points": 5, "start": 1.0}, "single_choice", "start is 0 or 1"),
        (
            [1, 2, 3, 4, 5],
            {"polarity": "unipolar", "points": 101},
            "single_choice",
            "code 6, 7, 8, 9, 10, 11, 12, 13 and 88 more is missing",
        ),
        ([1, 2, 3, 4, 5], {"polarity": "bipolar", "points": 5}, "multiple_choice", "not a single choice"),
    ],
)
def test_a_scale_the_question_does_not_carry_is_refused(audit, codes, scale, answer_type, message):
    _rate_q1(audit, codes, scale, answer_type)

    with pytest.raises(ValidationError, match=message):
        BuildRecord.model_validate(audit)


def test_an_undeclared_printed_scale_states_its_reason_and_the_report_lists_it(audit):
    question = _audit_questions(audit)[0]
    question["scale_undeclared_reason"] = "codes_descend"

    summary = report_summary(BuildRecord.model_validate(audit))

    assert summary["undeclared_scales"] == [
        {"qml_id": question["qml_id"], "source_id": question["source_id"], "reason": "codes_descend"}
    ]


def test_a_question_stating_nothing_about_a_scale_is_not_reported(audit):
    assert report_summary(BuildRecord.model_validate(audit))["undeclared_scales"] == []


def test_a_reason_outside_the_closed_set_is_refused(audit):
    _audit_questions(audit)[0]["scale_undeclared_reason"] = "labels_unfamiliar"

    with pytest.raises(ValidationError, match="scale_undeclared_reason"):
        BuildRecord.model_validate(audit)


def test_a_scale_beside_a_reason_for_declaring_none_is_refused(audit):
    _rate_q1(audit, [1, 2, 3, 4, 5], {"polarity": "bipolar", "points": 5})
    _audit_questions(audit)[0]["scale_undeclared_reason"] = "codes_descend"

    with pytest.raises(ValidationError, match="states both a rating scale and a reason"):
        BuildRecord.model_validate(audit)
