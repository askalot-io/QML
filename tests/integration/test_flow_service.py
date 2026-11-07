"""
Integration tests for the Flask-free flow service that SirWay's blueprint and the respondent lane share.

Tests the step functions in ``askalot_qml.api.flow_service`` called directly:
- Presenting an item opens its timing event and evaluating the answer closes
  it with a positive duration, tagged with the caller's source and channel
- Stepping back and then answering an earlier item rewinds the walk (B256):
  later entries leave history and are un-visited, their answers kept
- Finishing an unfinished walk closes the open event uncommitted and emits
  ``finished_early``; a finish at the end and an early one close the walk the
  same way and differ only in outcome and audit action (#1294)
- Resuming closes a stale open event, opens a fresh one on the current item,
  and emits ``resumed``
- Reading the current state opens no timing event, while presenting does
- The compute phase takes no repository or store and runs on its own; the
  persist phase is the only writer
- The service runs with no Flask application context and imports no Flask
- The web blueprint's timing events carry channel ``web``; events written
  before channels existed stay readable
- Choosing a language re-materializes the walk from the campaign's pin with
  the translation's text (titles, labels, the postcondition hint a rejection
  returns) and records the row it copied; choosing again before an answer
  replaces the text; a language the pin no longer offers, a translation
  deleted or emptied after the offer was read, or a walk that holds a
  committed answer, changes nothing; a campaign rebound to another
  questionnaire offers the walk only its source language
- Every pick mints its own id, so two picks of one language differ; an answer
  shown under an earlier pick (another tab picked since) is refused before
  anything is written or frozen, and an answer naming the current pick, or a
  walk no pick re-materialized with no token, is taken (#2127)

These integration tests drive the real engine (QML parse, Z3 initialization,
FlowProcessor) over an in-memory repository and a deterministic clock, because
the properties are about what the steps write and when — a mocked processor
could not show a timing event opening at the right seam.
"""

import ast
import inspect
import itertools
from pathlib import Path
from types import SimpleNamespace

import flask
import pytest
from askalot_common.repository.mixins.survey import (
    LANGUAGE_PICK_KEY,
    SurveyLanguageLockedError,
    language_pick_token,
)
from askalot_qml.api import create_flow_blueprint, flow_service
from askalot_qml.api.flow_service import FlowOutcome, FlowStore, LanguageChoiceOutcome
from askalot_qml.models import qml_state as qml_state_module
from askalot_qml.models.qml_state import (
    CHANNEL_AI,
    CHANNEL_WEB,
    SOURCE_INTERVIEWER,
    SOURCE_RESPONDENT,
    QMLState,
)

_QML = """
qmlVersion: "2.0"
questionnaire:
  title: Flow service walk
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_first
          kind: Question
          title: First
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_second
          kind: Question
          title: Second
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_third
          kind: Question
          title: Third
          input:
            control: Radio
            labels:
              1: A
              2: B
"""


class _FakeSurvey:
    def __init__(self, mode: str = "direct"):
        self.id = "s-1"
        self.questionnaire_id = "q-1"
        self.campaign_id = "c-1"
        self.respondent_id = "r-1"
        self.qml_state = None
        self.status = "in_progress"
        self.current_item_id = None
        self.current_block_id = None
        self.mode = mode


class _FakeQuestionnaire:
    id = "q-1"
    document_id = "doc-1"


class _FakeVersion:
    id = "v-1"
    document_id = "doc-1"
    content = _QML


class _FakeRepo:
    """The repository surface the flow service touches, recording writes."""

    def __init__(self, survey):
        self._survey = survey
        self.writes: list[str] = []

    def get_survey(self, survey_id):
        return self._survey if survey_id == self._survey.id else None

    def get_preview_run(self, run_id):
        return None

    def get_questionnaire(self, questionnaire_id):
        return _FakeQuestionnaire()

    def get_campaign(self, campaign_id):
        """A fielding, unpinned campaign: every survey has one (``ck_surveys_campaign_present``)."""
        if not campaign_id:
            return None
        return type("C", (), {"id": campaign_id, "status": "active", "qml_version_id": None})()

    def get_document_content(self, document_id, *, version_id=None):
        return _FakeVersion() if document_id == "doc-1" else None

    def get_organization(self, org_id):
        return None

    def save_survey_walk(self, survey):
        self.writes.append(survey.id)
        return survey.id


class _AuditRecorder:
    def __init__(self):
        self.actions: list[str] = []

    def __call__(self, entity_type, entity_id, action, context_extra=None):
        assert entity_type == "survey"
        self.actions.append(action)


@pytest.fixture
def clock(monkeypatch):
    """Every timing stamp advances 1000 ms, so durations are positive and exact."""
    ticks = itertools.count(1_700_000_000_000, 1000)
    monkeypatch.setattr(qml_state_module, "_now_ms", lambda: next(ticks))
    return ticks


@pytest.fixture
def walk():
    survey = _FakeSurvey()
    repo = _FakeRepo(survey)
    store = FlowStore(repo)
    loaded = flow_service.prepare_walk(store.load(survey.id))
    return store, loaded


def _present(store, survey, audit=None, channel=CHANNEL_AI):
    return flow_service.present_current_item(
        store,
        survey,
        source=SOURCE_RESPONDENT,
        channel=channel,
        audit_callback=audit,
        external_input_resolver=None,
    )


_SHOWN_UNDER_THE_CURRENT_PICK = object()


def _answer(store, survey, item_id, outcome, audit=None, pick_token=_SHOWN_UNDER_THE_CURRENT_PICK):
    """Answer ``item_id``; by default as shown under the walk's own pick."""
    if pick_token is _SHOWN_UNDER_THE_CURRENT_PICK:
        pick_token = language_pick_token(survey.qml_state)
    return flow_service.evaluate_item(
        store,
        survey,
        item_id=item_id,
        outcome=outcome,
        skip_postcondition=False,
        source=SOURCE_RESPONDENT,
        channel=CHANNEL_AI,
        pick_token=pick_token,
        audit_callback=audit,
        external_input_resolver=None,
    )


@pytest.mark.integration
@pytest.mark.flow
class TestTimingAtPresentation:
    def test_presenting_opens_and_answering_closes_with_a_positive_duration(self, clock, walk):
        store, survey = walk
        audit = _AuditRecorder()

        step = _present(store, survey, audit)

        assert step.outcome is FlowOutcome.ITEM
        assert step.item["id"] == "q_first"
        assert audit.actions == ["started"]
        [event] = survey.qml_state.get_timing_events()
        assert event["s"] is None, "presentation must open the event, not close it"
        presented_at = event["p"]

        answered = _answer(store, survey, "q_first", 1, audit)

        assert answered.outcome is FlowOutcome.ACCEPTED
        assert answered.has_next is True
        [event] = survey.qml_state.get_timing_events()
        assert event["p"] == presented_at, "the answer re-stamped the presentation"
        assert event["s"] - event["p"] > 0
        assert event["c"] is True
        assert event["src"] == SOURCE_RESPONDENT
        assert event["ch"] == CHANNEL_AI

    def test_reading_the_current_state_opens_no_timing_event(self, clock, walk):
        """A view remounting from an old transcript reads state; only a
        presentation may start the respondent's clock."""
        store, survey = walk
        audit = _AuditRecorder()

        step = flow_service.read_current_state(
            store, survey, audit_callback=audit, external_input_resolver=None
        )

        assert step.outcome is FlowOutcome.ITEM
        assert step.item["id"] == "q_first"
        assert survey.qml_state.get_timing_events() == []
        # The first read initializes the walk, and that is written and audited.
        assert store.repository.writes == ["s-1"]
        assert audit.actions == ["started"]

        flow_service.read_current_state(
            store, survey, audit_callback=audit, external_input_resolver=None
        )
        assert survey.qml_state.get_timing_events() == []
        assert store.repository.writes == ["s-1"], "a plain read wrote the walk"

        _present(store, survey)
        assert len(survey.qml_state.get_timing_events()) == 1

    def test_reading_at_the_end_of_the_walk_opens_and_completes_nothing(self, clock, walk):
        """With every item answered the engine hands back the last one
        (``isLast``). Reading it must not reopen its event — presenting does,
        which is the web's re-render of the end screen."""
        store, survey = walk
        for item_id in ("q_first", "q_second", "q_third"):
            _present(store, survey)
            _answer(store, survey, item_id, 1)
        assert len(survey.qml_state.get_timing_events()) == 3

        step = flow_service.read_current_state(
            store, survey, audit_callback=None, external_input_resolver=None
        )

        assert step.outcome is FlowOutcome.ITEM
        assert step.item["id"] == "q_third"
        assert step.item["isLast"] is True
        assert survey.status == "in_progress"
        assert len(survey.qml_state.get_timing_events()) == 3

        _present(store, survey)
        assert len(survey.qml_state.get_timing_events()) == 4


@pytest.mark.integration
@pytest.mark.flow
class TestBackwardEditRewinds:
    def test_previous_then_answering_an_earlier_item_rewinds_the_walk(self, clock, walk):
        """B256: an answer to an item later entries were built on truncates
        history after it; the abandoned items are un-visited but keep their
        answers, so they come back pre-filled."""
        store, survey = walk
        for item_id in ("q_first", "q_second"):
            _present(store, survey)
            _answer(store, survey, item_id, 1)
        _present(store, survey)  # q_third on screen

        back = flow_service.previous_item(
            store,
            survey,
            source=SOURCE_RESPONDENT,
            channel=CHANNEL_AI,
            audit_callback=None,
            external_input_resolver=None,
        )
        assert back.outcome is FlowOutcome.ITEM
        assert back.item["id"] == "q_second"
        assert survey.qml_state.get_history() == ["q_first", "q_second"]

        _answer(store, survey, "q_first", 2)

        state = survey.qml_state
        assert state.get_history() == ["q_first"]
        assert state.get_item("q_first")["outcome"] == 2
        assert state.get_item("q_second")["visited"] is False
        assert state.get_item("q_second")["outcome"] == 1, "the later answer was dropped"

        again = _present(store, survey)
        assert again.item["id"] == "q_second"


@pytest.mark.integration
@pytest.mark.flow
class TestFinishAndResume:
    def test_finish_closes_the_open_event_and_emits_finished_early(self, clock, walk):
        store, survey = walk
        audit = _AuditRecorder()
        _present(store, survey, audit)

        step = flow_service.finish(store, survey, audit_callback=audit)

        assert step.outcome is FlowOutcome.FINISHED
        assert survey.status == "completed"
        assert survey.current_item_id is None
        [event] = survey.qml_state.get_timing_events()
        assert event["s"] is not None
        assert event["c"] is False
        assert audit.actions == ["started", "finished_early"]

        again = flow_service.finish(store, survey, audit_callback=audit)
        assert again.outcome is FlowOutcome.ALREADY_COMPLETED
        assert audit.actions == ["started", "finished_early"]

    def test_resume_closes_the_stale_event_and_reopens_on_the_current_item(self, clock, walk):
        """A walk completed while an event was still open (a departure no step
        closed) gets two events on resume: the stale one closed uncommitted,
        and a fresh one timing the answer that follows."""
        store, survey = walk
        audit = _AuditRecorder()
        _present(store, survey, audit)
        stale_moment = survey.qml_state.get_timing_events()[0]["p"]
        survey.status = "completed"

        step = flow_service.resume(
            store,
            survey,
            source=SOURCE_RESPONDENT,
            channel=CHANNEL_AI,
            audit_callback=audit,
            external_input_resolver=None,
        )

        assert step.outcome is FlowOutcome.RESUMED
        assert step.item["id"] == "q_first"
        assert survey.status == "in_progress"
        stale, fresh = survey.qml_state.get_timing_events_for_item("q_first")
        assert stale["p"] == stale_moment
        assert stale["c"] is False
        assert fresh["s"] is None
        assert fresh["p"] > stale["s"]
        assert audit.actions == ["started", "resumed"]

    def test_resume_refuses_a_walk_that_is_not_completed(self, walk):
        store, survey = walk

        step = flow_service.resume(
            store,
            survey,
            source=SOURCE_RESPONDENT,
            channel=CHANNEL_AI,
            audit_callback=None,
            external_input_resolver=None,
        )

        assert step.outcome is FlowOutcome.NOT_COMPLETED
        assert store.repository.writes == []


@pytest.mark.integration
@pytest.mark.flow
class TestFinishClosesTheWalkOnce:
    """#1294: one close for every driver; a finish at the end is a completion."""

    @staticmethod
    def _presented():
        survey = _FakeSurvey()
        store = FlowStore(_FakeRepo(survey))
        loaded = flow_service.prepare_walk(store.load(survey.id))
        _present(store, loaded)
        return loaded

    @staticmethod
    def _closed_state(walk):
        return (
            walk.status,
            walk.current_item_id,
            walk.current_block_id,
            [(e["i"], e["c"]) for e in walk.qml_state.get_timing_events()],
        )

    def test_both_entry_points_leave_the_same_state_and_differ_in_the_audit(self, clock):
        early, at_end = self._presented(), self._presented()

        finished = flow_service.compute_finish(early, at_end=False)
        completed = flow_service.compute_finish(at_end, at_end=True)

        assert self._closed_state(early) == self._closed_state(at_end)
        assert self._closed_state(early)[:3] == ("completed", None, None)
        assert all(committed is False for _, committed in self._closed_state(early)[3])
        assert (finished.outcome, finished.audit_actions) == (
            FlowOutcome.FINISHED,
            ["finished_early"],
        )
        assert (completed.outcome, completed.audit_actions) == (
            FlowOutcome.JUST_COMPLETED,
            ["completed"],
        )

    def test_a_finished_walk_is_not_closed_twice(self, clock):
        walk = self._presented()
        flow_service.compute_finish(walk, at_end=True)

        again = flow_service.compute_finish(walk, at_end=True)

        assert again.outcome is FlowOutcome.ALREADY_COMPLETED
        assert not again.persist


@pytest.mark.integration
@pytest.mark.flow
class TestPhases:
    def test_no_compute_function_takes_a_repository_or_store(self):
        compute = [
            obj
            for name, obj in vars(flow_service).items()
            if name.startswith("compute_") and callable(obj)
        ]
        assert len(compute) >= 7
        for function in compute:
            params = set(inspect.signature(function).parameters)
            assert not params & {"repository", "repo", "store"}, function.__name__

    def test_compute_runs_alone_and_only_persist_writes(self, clock):
        survey = _FakeSurvey()
        repo = _FakeRepo(survey)
        instrument = flow_service.load_instrument(repo, survey)

        step = flow_service.compute_present_current_item(
            survey,
            instrument,
            source=SOURCE_INTERVIEWER,
            channel=CHANNEL_WEB,
            external_input_resolver=None,
        )

        assert step.outcome is FlowOutcome.ITEM
        assert step.persist is True
        assert step.audit_actions == ["started"]
        assert repo.writes == [], "the compute phase wrote"
        # The decoration is on the copy handed back, never on the stored item.
        assert "navigationPosition" in step.item
        assert "navigationPosition" not in survey.qml_state.get_item("q_first")

        audit = _AuditRecorder()
        store = FlowStore(repo)
        store.kind = "survey"
        flow_service.persist_step(store, survey, step, audit)
        assert repo.writes == ["s-1"]
        assert audit.actions == ["started"]

    def test_computing_on_an_uninitialized_walk_without_its_instrument_is_refused(self):
        with pytest.raises(ValueError, match="load its instrument"):
            flow_service.compute_current_state(_FakeSurvey(), None, external_input_resolver=None)

    def test_the_service_runs_with_no_flask_application_context(self, clock, walk):
        store, survey = walk
        assert not flask.has_app_context()

        _present(store, survey)
        _answer(store, survey, "q_first", 1)
        flow_service.finish(store, survey, audit_callback=None)

        assert survey.status == "completed"

    def test_the_service_module_imports_nothing_from_flask(self):
        tree = ast.parse(Path(flow_service.__file__).read_text())
        imported = set()
        for node in ast.walk(tree):
            if isinstance(node, ast.Import):
                imported.update(alias.name.split(".")[0] for alias in node.names)
            elif isinstance(node, ast.ImportFrom) and node.module:
                imported.add(node.module.split(".")[0])
        assert "flask" not in imported


@pytest.mark.integration
@pytest.mark.flow
class TestChannel:
    def test_the_event_records_the_channel_the_caller_passed(self, clock, walk):
        store, survey = walk
        _present(store, survey, channel=CHANNEL_WEB)
        _answer(store, survey, "q_first", 1)  # answered via ai; presentation fixed the channel

        [event] = survey.qml_state.get_timing_events()
        assert event["ch"] == CHANNEL_WEB

        _present(store, survey, channel=CHANNEL_AI)
        assert survey.qml_state.get_timing_events_for_item("q_second")[0]["ch"] == CHANNEL_AI

    def test_an_unknown_channel_is_refused_before_anything_runs(self, walk):
        store, survey = walk
        with pytest.raises(ValueError, match="Unknown timing channel"):
            _present(store, survey, channel="sms")
        assert store.repository.writes == []

    def test_the_web_blueprint_records_channel_web(self, clock):
        survey = _FakeSurvey()
        app = flask.Flask(__name__)
        app.register_blueprint(
            create_flow_blueprint(
                repository=_FakeRepo(survey),
                session_resolver=lambda: ("org-1", "org-slug", survey.id),
            )
        )
        client = app.test_client()

        client.get("/api/flow/current-item?survey_id=s-1")
        client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": "s-1", "item_id": "q_first", "outcome": 1},
        )
        client.get("/api/flow/current-item?survey_id=s-1")
        client.get("/api/flow/previous-item?survey_id=s-1")

        events = survey.qml_state.get_timing_events()
        assert len(events) == 3
        assert {event["ch"] for event in events} == {CHANNEL_WEB}

    def test_an_event_recorded_before_channels_existed_stays_readable(self, clock):
        state = QMLState()
        state["response_timing"] = [
            {"i": "q_first", "k": None, "p": 1, "s": None, "c": None, "src": "respondent"}
        ]

        state.close_timing_event("q_first", None, committed=True)

        [event] = state.get_timing_events()
        assert event["c"] is True
        assert event.get("ch") is None
        assert state.count_timing_attempts("q_first", None) == 1


_TRANSLATED_QML = """
qmlVersion: "2.0"
questionnaire:
  title: Translated walk
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_first
          kind: Question
          title: First
          postcondition:
            - predicate: "q_first.outcome == 1"
              hint: Pick A
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_second
          kind: Question
          title: Second
          input:
            control: Radio
            labels:
              1: A
              2: B
"""

_HU = {
    "questionnaire/title": "Lefordított",
    "item:q_first/title": "Első",
    "item:q_first/labels/1": "Egy",
    "item:q_first/labels/2": "Kettő",
    "item:q_first/postcondition/0/hint": "Válassza az Egyet",
    "item:q_second/title": "Második",
    "item:q_second/labels/1": "Egy",
    "item:q_second/labels/2": "Kettő",
}
_DE = {**_HU, "item:q_first/title": "Erste", "item:q_first/postcondition/0/hint": "Wählen Sie Eins"}


class _TranslationRepo(_FakeRepo):
    """A pinned campaign offering ``en`` (the source) and the translations it holds."""

    def __init__(self, survey):
        super().__init__(survey)
        self.pin = "v-1"
        self.campaign_questionnaire_id = survey.questionnaire_id
        self.translations = {
            "hu": SimpleNamespace(texts=_HU, updated_at="2026-11-04T10:00:00+00:00", untranslated=[]),
            "de": SimpleNamespace(texts=_DE, updated_at="2026-11-04T11:00:00+00:00", untranslated=[]),
        }
        self.picks: list[str] = []

    def get_questionnaire(self, questionnaire_id):
        return SimpleNamespace(id="q-1", document_id="doc-1", language="en")

    def get_campaign(self, campaign_id):
        return SimpleNamespace(
            id=campaign_id,
            status="active",
            qml_version_id=self.pin,
            questionnaire_id=self.campaign_questionnaire_id,
        )

    def get_document_content(self, document_id, *, version_id=None):
        return SimpleNamespace(id=version_id, document_id="doc-1", content=_TRANSLATED_QML)

    def qml_translation_seed_plan(self, questionnaire_id, version_id):
        return SimpleNamespace(sources=[])

    def offered_locales(self, questionnaire_id, version_id):
        return ["en", *sorted(self.translations)] if version_id == "v-1" else ["en"]

    def get_qml_translation(self, questionnaire_id, version_id, locale):
        return self.translations.get(locale)

    def choose_survey_language(self, survey_id, locale, *, qml_state, version_id):
        if any(e.get("c") for e in qml_state.get("response_timing", [])):
            raise SurveyLanguageLockedError(survey_id)
        self.picks.append(locale)
        return SimpleNamespace(id=survey_id, language=locale, modified_at="")


@pytest.fixture
def translated_walk():
    survey = _FakeSurvey()
    survey.language = None
    survey.modified_at = ""
    repo = _TranslationRepo(survey)
    store = FlowStore(repo)
    return store, flow_service.prepare_walk(store.load(survey.id))


def _choose(store, survey, locale):
    return flow_service.choose_language(
        store.repository, survey, locale, external_input_resolver=None
    )


@pytest.mark.integration
@pytest.mark.flow
class TestChoosingALanguage:
    def test_choosing_hu_renders_the_walk_in_hungarian_and_records_the_row(self, clock, translated_walk):
        store, survey = translated_walk
        _present(store, survey)

        choice = _choose(store, survey, "hu")

        assert choice.outcome is LanguageChoiceOutcome.CHOSEN
        assert store.repository.picks == ["hu"]
        assert survey.language == "hu"
        assert survey.qml_state[LANGUAGE_PICK_KEY] == {
            "locale": "hu",
            "version_id": "v-1",
            "updated_at": "2026-11-04T10:00:00+00:00",
            "pick_id": language_pick_token(survey.qml_state),
        }
        assert len(language_pick_token(survey.qml_state)) == 32
        item = _present(store, survey).item
        assert item["title"] == "Első"
        assert item["input"]["labels"] == {1: "Egy", 2: "Kettő"}
        assert survey.qml_state["title"] == "Lefordított"

    def test_a_postcondition_rejection_after_choosing_hu_returns_the_hungarian_hint(
        self, clock, translated_walk
    ):
        store, survey = translated_walk
        _choose(store, survey, "hu")
        _present(store, survey)

        rejected = _answer(store, survey, "q_first", 2)

        assert rejected.outcome is FlowOutcome.REJECTED
        assert rejected.message == "Válassza az Egyet"

    def test_choosing_de_before_any_answer_replaces_the_hungarian_text(self, clock, translated_walk):
        store, survey = translated_walk
        _choose(store, survey, "hu")

        _choose(store, survey, "de")

        assert survey.language == "de"
        assert _present(store, survey).item["title"] == "Erste"
        assert survey.qml_state[LANGUAGE_PICK_KEY]["updated_at"] == "2026-11-04T11:00:00+00:00"

    def test_choosing_the_source_language_records_no_translation_row(self, clock, translated_walk):
        store, survey = translated_walk

        _choose(store, survey, "en")

        assert _present(store, survey).item["title"] == "First"
        assert survey.qml_state[LANGUAGE_PICK_KEY] == {
            "locale": "en",
            "version_id": "v-1",
            "updated_at": None,
            "pick_id": language_pick_token(survey.qml_state),
        }

    def test_a_language_the_pin_no_longer_offers_changes_nothing(self, clock, translated_walk):
        store, survey = translated_walk
        _present(store, survey)
        before = dict(survey.qml_state)
        store.repository.pin = "v-2"

        choice = _choose(store, survey, "hu")

        assert choice.outcome is LanguageChoiceOutcome.NOT_OFFERED
        assert choice.offered == ["en"]
        assert store.repository.picks == []
        assert dict(survey.qml_state) == before
        assert survey.language is None

    def test_a_translation_deleted_after_the_offer_was_read_is_not_offered(
        self, clock, translated_walk
    ):
        store, survey = translated_walk
        _present(store, survey)
        before = dict(survey.qml_state)
        repo = store.repository
        repo.get_qml_translation = lambda questionnaire_id, version_id, locale: None

        choice = _choose(store, survey, "hu")

        assert choice.outcome is LanguageChoiceOutcome.NOT_OFFERED
        assert repo.picks == []
        assert dict(survey.qml_state) == before

    def test_a_translation_emptied_after_the_offer_was_read_is_not_offered(
        self, clock, translated_walk
    ):
        store, survey = translated_walk
        _present(store, survey)
        before = dict(survey.qml_state)
        repo = store.repository
        repo.translations["hu"] = SimpleNamespace(
            texts=_HU, updated_at="2026-11-04T12:00:00+00:00", untranslated=["item:q_first/title"]
        )

        choice = _choose(store, survey, "hu")

        assert choice.outcome is LanguageChoiceOutcome.NOT_OFFERED
        assert repo.picks == []
        assert dict(survey.qml_state) == before

    def test_a_campaign_rebound_to_another_questionnaire_offers_only_the_source(
        self, clock, translated_walk
    ):
        store, survey = translated_walk
        _present(store, survey)
        before = dict(survey.qml_state)
        store.repository.campaign_questionnaire_id = "q-other"

        assert flow_service.offered_languages(store.repository, survey) == ["en"]
        choice = _choose(store, survey, "hu")

        assert choice.outcome is LanguageChoiceOutcome.NOT_OFFERED
        assert choice.offered == ["en"]
        assert store.repository.picks == []
        assert dict(survey.qml_state) == before

    def test_a_walk_holding_a_committed_answer_is_locked(self, clock, translated_walk):
        store, survey = translated_walk
        _present(store, survey)
        _answer(store, survey, "q_first", 1)

        choice = _choose(store, survey, "hu")

        assert choice.outcome is LanguageChoiceOutcome.LOCKED
        assert store.repository.picks == []
        assert _present(store, survey).item["title"] == "Second"

    def test_an_answer_rendered_under_an_earlier_pick_is_refused_and_freezes_nothing(
        self, clock, translated_walk
    ):
        """#2127: tab A rendered Hungarian, tab B picked German, tab A answers."""
        store, survey = translated_walk
        _choose(store, survey, "hu")
        _present(store, survey)
        hungarian = language_pick_token(survey.qml_state)
        _choose(store, survey, "de")
        writes = list(store.repository.writes)

        step = _answer(store, survey, "q_first", 1, pick_token=hungarian)

        assert step.outcome is FlowOutcome.PICK_CHANGED
        assert store.repository.writes == writes
        assert survey.qml_state.get_item("q_first").get("outcome") is None
        assert not any(e.get("c") for e in survey.qml_state.get("response_timing", []))

    def test_an_answer_naming_the_current_pick_is_taken(self, clock, translated_walk):
        store, survey = translated_walk
        _choose(store, survey, "hu")
        _present(store, survey)

        step = _answer(store, survey, "q_first", 1, pick_token=language_pick_token(survey.qml_state))

        assert step.outcome is FlowOutcome.ACCEPTED

    def test_two_picks_of_one_language_are_told_apart(self, clock, translated_walk):
        """The source language has no row ``updated_at``, so only the pick id can tell them apart."""
        store, survey = translated_walk
        _choose(store, survey, "en")
        first = language_pick_token(survey.qml_state)
        _present(store, survey)

        _choose(store, survey, "en")

        assert language_pick_token(survey.qml_state) != first
        assert _answer(store, survey, "q_first", 1, pick_token=first).outcome is FlowOutcome.PICK_CHANGED

    def test_a_walk_no_pick_rematerialized_answers_with_no_token(self, clock, walk):
        store, survey = walk
        _present(store, survey)

        assert _answer(store, survey, "q_first", 1, pick_token=None).outcome is FlowOutcome.ACCEPTED
        assert _answer(store, survey, "q_first", 1, pick_token="stale").outcome is FlowOutcome.PICK_CHANGED

