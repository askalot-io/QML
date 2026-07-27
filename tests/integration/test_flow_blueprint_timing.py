"""
Integration tests for response-timing capture at the flow_blueprint HTTP seams.

The processor-level half of the contract (what an accepted answer writes) lives
in test_flow_navigation.py. What is only observable at the endpoint level, and
therefore tested here:

- GET /current-item stamps the presentation moment, and stamps it ONCE: three
  reads before an answer produce one event, kept at the first read's moment
  (AE6). This is the failure mode the unit exists around — re-stamping would
  under-report every duration while still producing plausible numbers, so the
  test is written against the endpoint that actually re-runs on every refresh.
- The event's source is derived from the survey's mode: an interviewer-assisted
  survey is tagged `interviewer`, a self-administered one `respondent` (R9).
- Backward navigation closes the event the answerer left as uncommitted, so the
  time counts toward visit totals but not toward attempts (KTD4).
- Departing an item unanswered (finishing early, stepping back, jumping) closes
  its event as uncommitted, and resuming opens a fresh one — so an absence lands
  in its own event instead of inflating the answer that follows it.

These drive a real Flask test client over the blueprint, backed by an in-memory
repository, because the refresh and resume behaviors are properties of the
endpoints, not of the processor they call.
"""

import pytest
from askalot_qml.api import create_flow_blueprint
from askalot_qml.models.qml_state import SOURCE_INTERVIEWER, SOURCE_RESPONDENT
from flask import Flask

_QML = """
qmlVersion: "2.0"
questionnaire:
  title: Timing at the blueprint seams
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
"""


class _FakeSurvey:
    def __init__(self, mode: str = "direct"):
        self.id = "s-1"
        self.questionnaire_id = "q-1"
        self.campaign_id = None
        self.respondent_id = "r-1"
        self.qml_state = None
        self.status = "in_progress"
        self.current_item_id = None
        self.current_block_id = None
        # 'direct' or 'field_interview' — the only input to the source tag.
        self.mode = mode


class _FakeQuestionnaire:
    def __init__(self):
        self.id = "q-1"
        self.document_id = "doc-1"


class _FakeVersion:
    def __init__(self, content):
        self.id = "v-1"
        self.document_id = "doc-1"
        self.content = content


class _FakeRepo:
    """The repository surface the blueprint touches, in memory."""

    def __init__(self, survey):
        self._survey = survey
        self._questionnaire = _FakeQuestionnaire()

    def get_survey(self, survey_id):
        return self._survey if survey_id == self._survey.id else None

    def get_questionnaire(self, questionnaire_id):
        return self._questionnaire

    def get_campaign(self, campaign_id):
        return None

    def get_document_content(self, document_id, *, version_id=None):
        return _FakeVersion(_QML) if document_id == "doc-1" else None

    def get_organization(self, org_id):
        return None

    def upsert_survey(self, survey):
        return survey.id


def _client(survey):
    app = Flask(__name__)
    app.register_blueprint(create_flow_blueprint(repository=_FakeRepo(survey)))
    return app.test_client()


@pytest.mark.integration
@pytest.mark.flow
class TestPresentationStamping:
    def test_repeated_current_item_reads_record_one_event(self):
        """AE6: the endpoint is a GET that re-runs on every render, refresh and
        resume. Three reads before an answer must leave ONE open event, still
        holding the first read's presentation moment — otherwise a respondent
        who refreshes has their own clock reset under them."""
        survey = _FakeSurvey()
        client = _client(survey)

        first = client.get("/api/flow/current-item?survey_id=s-1")
        assert first.status_code == 200
        assert first.get_json()["id"] == "q_first"
        first_moment = survey.qml_state.get_timing_events()[0]["p"]

        client.get("/api/flow/current-item?survey_id=s-1")
        client.get("/api/flow/current-item?survey_id=s-1")

        events = survey.qml_state.get_timing_events()
        assert len(events) == 1
        assert events[0]["i"] == "q_first"
        assert events[0]["p"] == first_moment
        assert events[0]["s"] is None  # still open — nothing has been answered

    def test_answer_closes_the_event_opened_at_presentation(self):
        """The presentation and the submission belong to the same event, so the
        recorded duration spans the whole time the item was on screen rather
        than only the moment the answer arrived."""
        survey = _FakeSurvey()
        client = _client(survey)

        client.get("/api/flow/current-item?survey_id=s-1")
        presented_at = survey.qml_state.get_timing_events()[0]["p"]

        resp = client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": "s-1", "item_id": "q_first", "outcome": 1},
        )
        assert resp.status_code == 200

        events = survey.qml_state.get_timing_events()
        assert len(events) == 1
        assert events[0]["p"] == presented_at
        assert events[0]["s"] is not None
        assert events[0]["c"] is True


@pytest.mark.integration
@pytest.mark.flow
class TestSourceFromSurveyMode:
    def test_direct_survey_is_tagged_respondent(self):
        survey = _FakeSurvey(mode="direct")
        client = _client(survey)

        client.get("/api/flow/current-item?survey_id=s-1")
        client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": "s-1", "item_id": "q_first", "outcome": 1},
        )

        assert {e["src"] for e in survey.qml_state.get_timing_events()} == {SOURCE_RESPONDENT}

    def test_field_interview_survey_is_tagged_interviewer(self):
        """An interviewer-paced answer has a different duration distribution
        from a self-administered one; tagging is what keeps either from reading
        as anomalous against the other."""
        survey = _FakeSurvey(mode="field_interview")
        client = _client(survey)

        client.get("/api/flow/current-item?survey_id=s-1")
        client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": "s-1", "item_id": "q_first", "outcome": 1},
        )

        assert {e["src"] for e in survey.qml_state.get_timing_events()} == {SOURCE_INTERVIEWER}


@pytest.mark.integration
@pytest.mark.flow
class TestNavigationSeams:
    def test_backward_navigation_closes_the_event_uncommitted(self):
        """A respondent who steps back without the UI saving first still leaves
        a closed event: the time was spent. It is uncommitted, so it feeds visit
        totals (R11) without counting as an attempt (R12)."""
        survey = _FakeSurvey()
        client = _client(survey)

        client.get("/api/flow/current-item?survey_id=s-1")
        client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": "s-1", "item_id": "q_first", "outcome": 1},
        )
        client.get("/api/flow/current-item?survey_id=s-1")  # presents q_second

        resp = client.get("/api/flow/previous-item?survey_id=s-1")
        assert resp.status_code == 200

        second_events = survey.qml_state.get_timing_events_for_item("q_second")
        assert len(second_events) == 1
        assert second_events[0]["c"] is False
        assert survey.qml_state.count_timing_attempts("q_second", None) == 0

    def test_resume_opens_a_fresh_event_rather_than_extending_the_abandoned_one(self):
        """An abandon-and-return records two events. The departure closes the
        first as uncommitted; the answer that follows is timed from the moment
        the item was actually put back on screen, not from before the absence."""
        survey = _FakeSurvey()
        client = _client(survey)

        client.get("/api/flow/current-item?survey_id=s-1")
        abandoned_moment = survey.qml_state.get_timing_events()[0]["p"]

        # Finish early while sitting on q_first, then come back to it.
        assert client.post("/api/flow/finish", json={"survey_id": "s-1"}).status_code == 200
        assert client.post("/api/flow/resume", json={"survey_id": "s-1"}).status_code == 200

        events = survey.qml_state.get_timing_events_for_item("q_first")
        assert len(events) == 2
        # The abandoned presentation is closed, uncommitted, and keeps its own
        # moment — the absence is recorded, not folded into the next answer.
        assert events[0]["p"] == abandoned_moment
        assert events[0]["c"] is False
        # The fresh presentation is open and waiting for a real answer.
        assert events[1]["s"] is None

    def test_backward_navigation_reopens_a_presentation_event_for_the_prior_item(self):
        """Stepping back re-presents the prior item, so a fresh timing event must
        open for it — the client renders the /previous-item response directly and
        never re-fetches /current-item, so without the reopen a re-answer would be
        timed only from process_item's own open+close and read ~0s (falsifying
        AE2). Mirrors the resume seam."""
        survey = _FakeSurvey()
        client = _client(survey)

        client.get("/api/flow/current-item?survey_id=s-1")
        client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": "s-1", "item_id": "q_first", "outcome": 1},
        )
        client.get("/api/flow/current-item?survey_id=s-1")  # presents q_second

        resp = client.get("/api/flow/previous-item?survey_id=s-1")
        assert resp.status_code == 200
        assert resp.get_json()["id"] == "q_first"

        # q_first now carries an open event opened by the back-navigation, so the
        # re-answer that follows is timed from re-presentation, not near-zero.
        assert survey.qml_state.has_open_timing_event("q_first", None)

    def test_stepper_jump_reopens_a_presentation_event_for_the_target(self):
        """A stepper jump-back re-presents its target the same way, so it must
        reopen a timing event too — the same near-zero-duration bug otherwise
        hits every jump-back re-answer."""
        survey = _FakeSurvey()
        client = _client(survey)

        client.get("/api/flow/current-item?survey_id=s-1")
        client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": "s-1", "item_id": "q_first", "outcome": 1},
        )
        client.get("/api/flow/current-item?survey_id=s-1")  # presents q_second

        resp = client.post(
            "/api/flow/navigate-to-item",
            json={"survey_id": "s-1", "target_item_id": "q_first"},
        )
        assert resp.status_code == 200

        assert survey.qml_state.has_open_timing_event("q_first", None)
