"""
Integration tests for the Flask-free flow service that SirWay's blueprint and the respondent lane share.

Tests the step functions in ``askalot_qml.api.flow_service`` called directly:
- Presenting an item opens its timing event and evaluating the answer closes
  it with a positive duration, tagged with the caller's source and channel
- Stepping back and then answering an earlier item rewinds the walk (B256):
  later entries leave history and are un-visited, their answers kept
- Finishing an unfinished walk closes the open event uncommitted and emits
  ``finished_early``
- Resuming closes a stale open event, opens a fresh one on the current item,
  and emits ``resumed``
- Reading the current state opens no timing event, while presenting does
- The compute phase takes no repository or store and runs on its own; the
  persist phase is the only writer
- The service runs with no Flask application context and imports no Flask
- The web blueprint's timing events carry channel ``web``; events written
  before channels existed stay readable

These integration tests drive the real engine (QML parse, Z3 initialization,
FlowProcessor) over an in-memory repository and a deterministic clock, because
the properties are about what the steps write and when — a mocked processor
could not show a timing event opening at the right seam.
"""

import ast
import inspect
import itertools
from pathlib import Path

import flask
import pytest
from askalot_qml.api import create_flow_blueprint, flow_service
from askalot_qml.api.flow_service import FlowOutcome, FlowStore
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
        return None

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


def _answer(store, survey, item_id, outcome, audit=None):
    return flow_service.evaluate_item(
        store,
        survey,
        item_id=item_id,
        outcome=outcome,
        skip_postcondition=False,
        source=SOURCE_RESPONDENT,
        channel=CHANNEL_AI,
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
