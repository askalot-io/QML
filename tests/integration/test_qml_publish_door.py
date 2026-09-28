"""
Integration tests for the QML publish door (plan 2026-07-21-001, U7 — R16/R17,
Covers AE6).

Tests the asymmetry that IS the product rule: a save is evaluated and stamped
but never blocked, while fielding refuses anything unvalidated.

- ``evaluate_qml_content`` grades real QML and produces the stored verdict shape
- ``stamp_questionnaire_validation`` writes the verdict on the head VERSION and
  on the questionnaire row, and never raises for unsound content (AE6, save half)
- a fail-closed gate (unparseable QML) clears the quality report to "not
  assessed" rather than leaving a stale one standing
- the stamp records WHICH version the quality report graded, and moves it with
  the head on the next stamp (#540)
- ``publish_questionnaire_to_campaign`` refuses an unsound head, writes no pin,
  and returns the graded issues; it pins a sound one and returns the version id
  (AE6, publish half)
- publishing again after an edit re-pins to the NEW head
- a questionnaire with no document fails loud instead of publishing nothing
- the stamp→pin split runs the Z3 gate exactly ONCE per publish and reads the
  document once (#212), and pinning a failing ticket raises rather than fielding

These integration tests run the real Z3 publish gate over real QML — the whole
question is whether a genuinely broken questionnaire is refused at exactly one
door and welcomed at the other, which a stubbed gate could not answer. Only
persistence is a fake, implementing the repository contract the primitive uses.
"""

import pytest
from askalot_qml.core import (
    QMLDocumentMissingError,
    evaluate_qml_content,
    pin_validated_version,
    publish_questionnaire_to_campaign,
    publish_refusal_message,
    stamp_questionnaire_validation,
    validation_record,
)

PROJECT_ID = "11111111-1111-1111-1111-111111111111"
QUESTIONNAIRE_ID = "22222222-2222-2222-2222-222222222222"
DOCUMENT_ID = "33333333-3333-3333-3333-333333333333"
CAMPAIGN_ID = "44444444-4444-4444-4444-444444444444"

SOUND_QML = """
qmlVersion: "2.2"
questionnaire:
  title: Sound
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_age
          kind: Question
          title: How old are you?
          input:
            control: Editbox
            min: 18
            max: 99
        - id: q_ok
          kind: Question
          title: Are you well?
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
"""

#: ``q_gated``'s precondition names an item that does not exist, so the gate
#: raises ``undefined_name`` (error severity) — the single most common real
#: failure in the dev corpus (241 occurrences, issue #201).
UNSOUND_QML = """
qmlVersion: "2.2"
questionnaire:
  title: Unsound
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_ok
          kind: Question
          title: Are you well?
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_gated
          kind: Question
          title: Follow-up
          precondition:
            - predicate: q_does_not_exist.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
"""

UNPARSEABLE_QML = "this: is: not: valid: qml:\n  - [\n"


class _FakeVersion:
    def __init__(self, version_id: str, content: str):
        self.id = version_id
        self.document_id = DOCUMENT_ID
        self.content = content
        self.validation: dict = {}


class _FakeQuestionnaire:
    def __init__(self, document_id: str | None = DOCUMENT_ID):
        self.id = QUESTIONNAIRE_ID
        self.project_id = PROJECT_ID
        self.document_id = document_id
        self.logic_validated = False
        self.logic_validated_at = None
        self.quality_report = {"stale": "report"}
        self.quality_report_at = "2020-01-01T00:00:00+00:00"
        self.quality_report_version_id = "an-earlier-version"


class _FakeRepo:
    """The repository contract the publish primitive uses, in memory.

    ``pin_campaign_qml_version`` reproduces the real fail-closed floor: it
    refuses a version whose recorded verdict is not ``ok``. That matters here
    because a bug that stamped the verdict AFTER pinning would still pass a
    test whose fake pinned unconditionally.
    """

    def __init__(self, questionnaire, versions):
        self.questionnaire = questionnaire
        self.versions = {v.id: v for v in versions}
        self.head_id = versions[-1].id if versions else None
        self.pins: dict[str, str] = {}
        self.upserts = 0
        #: Full-content reads. The publish path used to make four per campaign
        #: create — the counter is what keeps a re-introduced redundant fetch
        #: (#212) from passing silently.
        self.content_reads = 0

    def get_document_content(self, document_id, *, version_id=None):
        self.content_reads += 1
        assert document_id == DOCUMENT_ID
        if version_id is not None:
            return self.versions.get(version_id)
        return self.versions.get(self.head_id) if self.head_id else None

    def stamp_qml_version_validation(self, version_id, validation):
        self.versions[version_id].validation = dict(validation)

    def upsert_questionnaire(self, questionnaire):
        self.upserts += 1
        return questionnaire.id

    def pin_campaign_qml_version(self, campaign_id, version_id):
        version = self.versions[version_id]
        if not bool(dict(version.validation or {}).get("ok")):
            raise AssertionError(
                "pin attempted on a version with no passing verdict — the "
                "publish primitive must refuse before reaching the pin"
            )
        self.pins[campaign_id] = version_id

    def append_head(self, version):
        self.versions[version.id] = version
        self.head_id = version.id


@pytest.mark.integration
class TestVerdictShape:
    def test_sound_qml_produces_an_ok_record(self):
        gate, record = evaluate_qml_content(SOUND_QML, source_label="sound")

        assert gate.ok is True
        assert record["ok"] is True
        assert record["errors"] == 0
        assert record["source"] == "publish_gate"
        assert record["checked_at"]

    def test_unsound_qml_produces_a_failing_record_with_a_counted_error(self):
        gate, record = evaluate_qml_content(UNSOUND_QML, source_label="unsound")

        assert gate.ok is False
        assert record["ok"] is False
        assert record["errors"] == len(gate.errors) >= 1
        assert any(issue["type"] == "undefined_name" for issue in gate.errors)

    def test_record_counts_warnings_separately_from_errors(self):
        gate, record = evaluate_qml_content(UNSOUND_QML, source_label="unsound")

        assert record["warnings"] == len(gate.issues) - len(gate.errors)


@pytest.mark.integration
class TestStampingNeverBlocks:
    def test_unsound_head_is_stamped_invalid_and_stays_head(self):
        """AE6, save half: the verdict lands, the content is not rejected."""
        version = _FakeVersion("v1", UNSOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        gate = stamp_questionnaire_validation(repo, questionnaire)

        assert gate.ok is False
        assert version.validation["ok"] is False
        assert version.content == UNSOUND_QML
        assert questionnaire.logic_validated is False
        assert questionnaire.logic_validated_at
        assert repo.upserts == 1

    def test_sound_head_is_stamped_valid_with_a_quality_report(self):
        version = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        gate = stamp_questionnaire_validation(repo, questionnaire)

        assert gate.ok is True
        assert version.validation["ok"] is True
        assert questionnaire.logic_validated is True
        assert questionnaire.quality_report is not None
        assert questionnaire.quality_report_at == questionnaire.logic_validated_at
        assert questionnaire.quality_report_version_id == "v1"

    def test_the_report_names_the_head_it_graded_after_an_edit(self):
        """#540: a report is only current while its version is the head, so the
        stamp must move the recorded version with the head it re-graded."""
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [_FakeVersion("v1", SOUND_QML)])
        stamp_questionnaire_validation(repo, questionnaire)

        repo.append_head(_FakeVersion("v2", SOUND_QML.replace("Sound", "Sound v2")))
        stamp_questionnaire_validation(repo, questionnaire)

        assert questionnaire.quality_report_version_id == "v2"

    def test_fail_closed_gate_clears_the_stale_quality_report(self):
        """R7: unparseable content produces no artifacts, so "not assessed"
        must replace the previous report rather than leave it standing."""
        version = _FakeVersion("v1", UNPARSEABLE_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        gate = stamp_questionnaire_validation(repo, questionnaire)

        assert gate.ok is False
        assert questionnaire.quality_report is None
        assert questionnaire.quality_report_at is None
        assert questionnaire.quality_report_version_id is None

    def test_questionnaire_without_a_document_fails_loud(self):
        questionnaire = _FakeQuestionnaire(document_id=None)
        repo = _FakeRepo(questionnaire, [_FakeVersion("v1", SOUND_QML)])

        with pytest.raises(QMLDocumentMissingError):
            stamp_questionnaire_validation(repo, questionnaire)


@pytest.mark.integration
class TestPublishRefusesUnsoundHeads:
    def test_publish_of_an_unsound_head_is_refused_and_pins_nothing(self):
        """AE6, publish half."""
        version = _FakeVersion("v1", UNSOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        assert result.ok is False
        assert result.pinned is False
        assert repo.pins == {}
        assert any(issue["type"] == "undefined_name" for issue in result.errors)
        # The verdict is durable even though the publish failed, so the user's
        # next screen can show why without re-running Z3.
        assert version.validation["ok"] is False

    def test_refusal_message_names_the_defect(self):
        version = _FakeVersion("v1", UNSOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        message = publish_refusal_message(result.gate)
        assert "undefined_name" in message
        assert "q_does_not_exist" in message

    def test_publish_of_an_unparseable_head_is_refused(self):
        version = _FakeVersion("v1", UNPARSEABLE_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        assert result.ok is False
        assert repo.pins == {}


@pytest.mark.integration
class TestPublishPinsTheValidatedVersion:
    def test_publish_pins_the_head_it_validated(self):
        version = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        assert result.ok is True and result.pinned is True
        assert result.version_id == "v1"
        assert repo.pins == {CAMPAIGN_ID: "v1"}
        assert version.validation["ok"] is True

    def test_republishing_after_an_edit_repins_to_the_new_head(self):
        first = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [first])
        publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        second = _FakeVersion("v2", SOUND_QML.replace("Sound", "Sound v2"))
        repo.append_head(second)
        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        assert result.version_id == "v2"
        assert repo.pins == {CAMPAIGN_ID: "v2"}

    def test_a_regressing_edit_cannot_be_republished(self):
        """The pin only moves when the NEW head is sound; a campaign is never
        silently re-pointed at a broken instrument."""
        first = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [first])
        publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        repo.append_head(_FakeVersion("v2", UNSOUND_QML))
        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        assert result.ok is False
        assert repo.pins == {CAMPAIGN_ID: "v1"}


@pytest.mark.integration
class TestStampThenPinRunsTheGateOnce:
    """The #212 split: a caller that must write a row between the refusal and
    the pin stamps once, holds the ticket, and redeems it.

    Before the split, every campaign create / edit / rebind ran the full
    ``deep=True`` Z3 gate TWICE over byte-identical content — once at the
    caller's own refuse-before-write check, once again inside the pin — and
    resolved the document four times. These tests pin the count, not just the
    outcome, because the outcome was always correct; only the cost was wrong.
    """

    def _counting_gate(self, monkeypatch):
        """Wrap the real gate in a call counter, leaving its behaviour intact."""
        from askalot_qml.core import qml_publish

        calls = []
        real = qml_publish.evaluate_publish_gate_content

        def counted(content, **kwargs):
            calls.append(content)
            return real(content, **kwargs)

        monkeypatch.setattr(qml_publish, "evaluate_publish_gate_content", counted)
        return calls

    def test_stamp_then_pin_evaluates_the_gate_exactly_once(self, monkeypatch):
        version = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])
        gate_calls = self._counting_gate(monkeypatch)

        ticket = stamp_questionnaire_validation(repo, questionnaire)
        # …the caller writes its campaign row here…
        pinned = pin_validated_version(repo, campaign_id=CAMPAIGN_ID, ticket=ticket)

        assert len(gate_calls) == 1
        assert repo.content_reads == 1
        assert pinned == "v1"
        assert repo.pins == {CAMPAIGN_ID: "v1"}

    def test_one_shot_publish_also_evaluates_the_gate_exactly_once(self, monkeypatch):
        version = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])
        gate_calls = self._counting_gate(monkeypatch)

        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        assert len(gate_calls) == 1
        assert repo.content_reads == 1
        assert result.pinned is True

    def test_the_ticket_names_the_version_its_verdict_was_written_onto(self):
        """What makes a ticket redeemable: the pin's fail-closed floor re-reads
        that version's stored verdict, so the two must be the same row."""
        version = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        ticket = stamp_questionnaire_validation(repo, questionnaire)

        assert ticket.version_id == "v1"
        assert repo.versions["v1"].validation["ok"] is True

    def test_pinning_a_failing_ticket_raises_instead_of_fielding_it(self):
        """A refusal belongs at the stamp, where no campaign row exists yet.
        Reaching the pin with one is a caller-ordering bug, not an outcome."""
        version = _FakeVersion("v1", UNSOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])

        ticket = stamp_questionnaire_validation(repo, questionnaire)

        assert ticket.ok is False
        with pytest.raises(ValueError, match="refusing to pin"):
            pin_validated_version(repo, campaign_id=CAMPAIGN_ID, ticket=ticket)
        assert repo.pins == {}

    def test_the_pinned_version_is_the_one_the_caller_was_shown(self):
        """The ticket also closes a TOCTOU the second stamp introduced: a save
        landing between the refusal check and the pin used to move the campaign
        onto content the caller never saw a verdict for."""
        first = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [first])

        ticket = stamp_questionnaire_validation(repo, questionnaire)
        # A concurrent save advances head while the campaign row is written.
        second = _FakeVersion("v2", SOUND_QML.replace("Sound", "Sound v2"))
        second.validation = {"ok": True}
        repo.append_head(second)
        pin_validated_version(repo, campaign_id=CAMPAIGN_ID, ticket=ticket)

        assert repo.pins == {CAMPAIGN_ID: "v1"}


@pytest.mark.integration
class TestValidationRecordHelper:
    def test_checked_at_is_honoured_when_supplied(self):
        gate, _ = evaluate_qml_content(SOUND_QML, source_label="sound")

        record = validation_record(gate, checked_at="2026-07-21T12:00:00+00:00")

        assert record["checked_at"] == "2026-07-21T12:00:00+00:00"
