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
- the page refusal names each blocking issue by its translated type, in the
  reader's language, while agents keep the English detail (#2166)
- the stamp→pin split runs the Z3 gate exactly ONCE per publish and reads the
  document once (#212), also when a caller composes the stamp's read, judge and
  record halves itself and publishes with its ticket (#1696), and pinning a
  failing ticket raises rather than fielding
- the stamp carries every translation of the version's parent forward before
  the pin, on the head branch and on the superseded branch, copying only text
  whose source is unchanged; seeding twice inserts once, a saved row is never
  overwritten, and content that cannot be parsed seeds nothing

These integration tests run the real Z3 publish gate over real QML — the whole
question is whether a genuinely broken questionnaire is refused at exactly one
door and welcomed at the other, which a stubbed gate could not answer. Only
persistence is a fake, implementing the repository contract the primitive uses.
"""

import copy

import pytest
from askalot_common.repository.mixins.qml_translation import (
    TranslationSeedPlan,
    TranslationSeedSource,
)
from askalot_qml.core import (
    QMLDocumentMissingError,
    evaluate_qml_content,
    pin_validated_version,
    publish_questionnaire_to_campaign,
    publish_refusal_message,
    stamp_questionnaire_validation,
    validation_record,
)
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_translation import seed_translations, text_keys

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
    def __init__(self, version_id: str, content: str, parent_version_id: str | None = None):
        self.id = version_id
        self.document_id = DOCUMENT_ID
        self.content = content
        self.parent_version_id = parent_version_id
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
        #: (version id, locale) → {"texts", "untranslated"}: the translation rows.
        self.translations: dict[tuple[str, str], dict] = {}
        #: campaign id → the (version, locale) rows that existed when it was pinned.
        self.rows_at_pin: dict[str, set[tuple[str, str]]] = {}

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

    def record_qml_head_verdict(
        self, document_id, *, expected_version_id, validation, record_row_verdict
    ):
        """``QMLDocumentMixin.record_qml_head_verdict``: both writes, or neither on a moved head."""
        assert document_id == DOCUMENT_ID
        if self.head_id != expected_version_id:
            return "superseded"
        self.versions[self.head_id].validation = dict(validation)
        self.stored_row = copy.deepcopy(self.questionnaire)
        record_row_verdict(self.stored_row)
        self.upserts += 1
        return "recorded"

    def pin_campaign_qml_version(self, campaign_id, version_id):
        version = self.versions[version_id]
        if not bool(dict(version.validation or {}).get("ok")):
            raise AssertionError(
                "pin attempted on a version with no passing verdict — the "
                "publish primitive must refuse before reaching the pin"
            )
        self.pins[campaign_id] = version_id
        self.rows_at_pin[campaign_id] = set(self.translations)

    def qml_translation_seed_plan(self, questionnaire_id, version_id):
        """``QmlTranslationMixin.qml_translation_seed_plan``: nearest ancestor per missing locale."""
        assert questionnaire_id == QUESTIONNAIRE_ID
        held = {locale for (vid, locale) in self.translations if vid == version_id}
        sources: dict[str, TranslationSeedSource] = {}
        ancestor = self.versions[version_id].parent_version_id
        while ancestor is not None:
            for (vid, locale), row in self.translations.items():
                if vid == ancestor and locale not in held and locale not in sources:
                    sources[locale] = TranslationSeedSource(
                        locale=locale,
                        ancestor_version_id=ancestor,
                        ancestor_content=self.versions[ancestor].content,
                        texts=dict(row["texts"]),
                        human_edited_at=None,
                    )
            ancestor = self.versions[ancestor].parent_version_id
        return TranslationSeedPlan(
            version_content=self.versions[version_id].content if sources else None,
            sources=tuple(sources.values()),
        )

    def insert_seeded_translations(self, questionnaire_id, version_id, rows):
        """``insert_seeded_translations``: insert what is absent, never overwrite."""
        assert questionnaire_id == QUESTIONNAIRE_ID
        inserted = []
        for row in rows:
            if (version_id, row.locale) not in self.translations:
                self.translations[(version_id, row.locale)] = {
                    "texts": dict(row.texts),
                    "untranslated": list(row.untranslated),
                }
                inserted.append(row.locale)
        return inserted

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

    def test_the_page_refusal_names_the_defect_in_the_readers_language(self):
        """A page shows the issue's translated type and its item, never the English detail (#2166)."""
        from askalot_qml.core import publish_refusal_text
        from askalot_qml.core.publish_gate import ISSUE_TYPE_LABELS

        version = _FakeVersion("v1", UNSOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])
        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        english = publish_refusal_text(result.gate, "en")
        hungarian = publish_refusal_text(result.gate, "hu")
        assert ISSUE_TYPE_LABELS["undefined_name"] in english
        assert "undefined_name" not in english
        assert hungarian != english
        assert ISSUE_TYPE_LABELS["undefined_name"] not in hungarian

    def test_the_page_refusal_keeps_the_loaders_reason_for_content_that_did_not_load(self):
        """An unloadable head names why it failed: the reader may have no editor to look in (#2166)."""
        from askalot_qml.core import publish_refusal_text
        from askalot_qml.core.publish_gate import ISSUE_TYPE_LABELS

        version = _FakeVersion("v1", UNPARSEABLE_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])
        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        (issue,) = [i for i in result.gate.errors if i["type"] == "load_error"]
        text = publish_refusal_text(result.gate, "en")
        assert f"{ISSUE_TYPE_LABELS['load_error']}: {issue['message']}" in text

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

    def test_the_three_halves_stamp_exactly_what_the_one_call_does(self, monkeypatch):
        """#1696: a caller that runs the gate on its own thread composes the read,
        the judgement and the record; publishing with that ticket gates nothing
        again."""
        from askalot_qml.core import head_version_to_stamp, judge_head_version, record_stamp

        version = _FakeVersion("v1", SOUND_QML)
        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [version])
        gate_calls = self._counting_gate(monkeypatch)

        head = head_version_to_stamp(repo, questionnaire)
        ticket = record_stamp(repo, questionnaire, head, judge_head_version(head, questionnaire))
        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire, ticket=ticket
        )

        assert len(gate_calls) == 1
        assert repo.content_reads == 1
        assert (ticket.version_id, result.pinned) == ("v1", True)
        assert repo.pins == {CAMPAIGN_ID: "v1"}
        assert questionnaire.quality_report_version_id == "v1"

    def test_a_head_that_moved_while_the_gate_ran_gets_no_row_write(self):
        """#1696: the judged version is stamped alone (the pin reads it); the row
        and the caller's copy stay with the head's own verdict."""
        from askalot_qml.core import head_version_to_stamp, judge_head_version, record_stamp

        questionnaire = _FakeQuestionnaire()
        repo = _FakeRepo(questionnaire, [_FakeVersion("v1", SOUND_QML)])
        judged = head_version_to_stamp(repo, questionnaire)
        gate = judge_head_version(judged, questionnaire)
        repo.append_head(_FakeVersion("v2", SOUND_QML))

        ticket = record_stamp(repo, questionnaire, judged, gate)

        assert ticket.version_id == "v1"
        assert repo.versions["v1"].validation["ok"] is True
        assert repo.versions["v2"].validation == {}
        assert repo.upserts == 0
        assert questionnaire.quality_report_version_id == "an-earlier-version"
        pin_validated_version(repo, campaign_id=CAMPAIGN_ID, ticket=ticket)
        assert repo.pins == {CAMPAIGN_ID: "v1"}

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


#: v3 → v4 edits one item's title; every other text is unchanged.
SOUND_V4_QML = SOUND_QML.replace("Are you well?", "Are you feeling well?")


def _hungarian(content: str) -> dict[str, str]:
    """A complete Hungarian translation of ``content``."""
    return {
        key: f"HU {text}" for key, text in text_keys(QMLLoader().load_from_string(content)).items()
    }


def _translated_chain() -> tuple[_FakeQuestionnaire, _FakeRepo]:
    """v3 with a complete Hungarian row, and its child v4 as head."""
    questionnaire = _FakeQuestionnaire()
    repo = _FakeRepo(
        questionnaire,
        [_FakeVersion("v3", SOUND_QML), _FakeVersion("v4", SOUND_V4_QML, parent_version_id="v3")],
    )
    repo.translations[("v3", "hu")] = {"texts": _hungarian(SOUND_QML), "untranslated": []}
    return questionnaire, repo


@pytest.mark.integration
class TestTheStampCarriesTranslationsForward:
    def test_a_version_stamped_and_pinned_before_any_verdict_job_gets_its_carried_row(self):
        questionnaire, repo = _translated_chain()

        result = publish_questionnaire_to_campaign(
            repo, campaign_id=CAMPAIGN_ID, questionnaire=questionnaire
        )

        assert result.pinned and result.version_id == "v4"
        carried = repo.translations[("v4", "hu")]
        expected = {k: v for k, v in _hungarian(SOUND_QML).items() if k != "item:q_ok/title"}
        assert carried["texts"] == expected
        assert carried["untranslated"] == ["item:q_ok/title"]
        assert ("v4", "hu") in repo.rows_at_pin[CAMPAIGN_ID]

    def test_a_version_stamped_on_the_superseded_branch_gets_its_rows_before_the_pin(self):
        from askalot_qml.core import head_version_to_stamp, judge_head_version, record_stamp

        questionnaire, repo = _translated_chain()
        judged = head_version_to_stamp(repo, questionnaire)
        gate = judge_head_version(judged, questionnaire)
        repo.append_head(_FakeVersion("v5", SOUND_V4_QML, parent_version_id="v4"))

        ticket = record_stamp(repo, questionnaire, judged, gate)
        pin_validated_version(repo, campaign_id=CAMPAIGN_ID, ticket=ticket)

        assert repo.upserts == 0  # the superseded branch: the row was not written
        assert repo.pins == {CAMPAIGN_ID: "v4"}
        assert ("v4", "hu") in repo.rows_at_pin[CAMPAIGN_ID]
        assert ("v5", "hu") not in repo.translations

    def test_seeding_twice_inserts_once_and_leaves_a_saved_row_untouched(self):
        _, repo = _translated_chain()

        assert seed_translations(repo, QUESTIONNAIRE_ID, "v4") == ["hu"]
        assert seed_translations(repo, QUESTIONNAIRE_ID, "v4") == []

        saved = {"texts": {"questionnaire/title": "Saved"}, "untranslated": ["x"]}
        repo.translations[("v4", "de")] = saved
        repo.translations[("v3", "de")] = {"texts": _hungarian(SOUND_QML), "untranslated": []}
        assert seed_translations(repo, QUESTIONNAIRE_ID, "v4") == []
        assert repo.translations[("v4", "de")] is saved

    def test_content_that_is_not_text_is_refused_rather_than_parsed(self):
        """A mocked repository answers an object for the content; the loader
        would read it as an endless YAML stream, so it must raise at once."""
        from askalot_common.repository.mixins.qml_translation import TranslationSeedPlan

        _, repo = _translated_chain()
        plan = repo.qml_translation_seed_plan(QUESTIONNAIRE_ID, "v4")
        repo.qml_translation_seed_plan = lambda *_a: TranslationSeedPlan(
            version_content=object(), sources=plan.sources
        )

        with pytest.raises(TypeError, match="QML content must be text"):
            seed_translations(repo, QUESTIONNAIRE_ID, "v4")

    def test_content_that_cannot_be_parsed_seeds_nothing_and_still_stamps(self):
        questionnaire, repo = _translated_chain()
        repo.append_head(_FakeVersion("v5", UNPARSEABLE_QML, parent_version_id="v4"))

        ticket = stamp_questionnaire_validation(repo, questionnaire)

        assert (ticket.version_id, ticket.ok) == ("v5", False)
        assert ("v5", "hu") not in repo.translations


@pytest.mark.integration
class TestValidationRecordHelper:
    def test_checked_at_is_honoured_when_supplied(self):
        gate, _ = evaluate_qml_content(SOUND_QML, source_label="sound")

        record = validation_record(gate, checked_at="2026-07-21T12:00:00+00:00")

        assert record["checked_at"] == "2026-07-21T12:00:00+00:00"
