"""
Integration tests for the flow_blueprint external-input resolver callback
(QML External Inputs plan, U5 — SirWay runtime wiring).

SirWay has no service-layer survey-init seam: its qml_state is built lazily
inside the shared flow_blueprint._initialize_survey_state. To keep askalot_qml
repository-free, the service passes an `external_input_resolver` callback into
create_flow_blueprint; the shared module calls it once at init, after the
FlowProcessor is constructed (codeInit run, items unvisited) and before the flow
is walked (KTD3).

These tests build the blueprint over a fake in-memory repository serving the
questionnaire's QML document, drive GET /api/flow/current-item, and assert:
- the resolver callback fires exactly once at survey init, receiving (survey,
  processor);
- a callback that injects an external item hides it from the first-item read
  (the item is pre-answered), matching the Portor runtime;
- absent a resolver callback, the external item is asked in the normal flow
  (backward-compatible default).
"""

import pytest
from askalot_qml.api import create_flow_blueprint
from askalot_qml.models.qml_state import QMLState
from flask import Flask

_QML = """
qmlVersion: "2.2"
questionnaire:
  title: External at init (blueprint)
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_rotate_out
          kind: Question
          title: Rotate out?
          external: true
          input:
            control: Radio
            labels:
              0: "No"
              1: "Yes"
        - id: q_followup
          kind: Question
          title: Follow-up
          input:
            control: Radio
            labels:
              1: A
              2: B
"""


class _FakeSurvey:
    def __init__(self, survey_id, questionnaire_id):
        self.id = survey_id
        self.questionnaire_id = questionnaire_id
        self.campaign_id = "camp-1"
        self.respondent_id = "r-1"
        self.qml_state = None
        self.status = "in_progress"
        self.current_item_id = None
        self.current_block_id = None
        # Read by the blueprint to tag timing events respondent vs interviewer.
        self.mode = "direct"


class _FakeQuestionnaire:
    def __init__(self, document_id="doc-1"):
        self.id = "q-1"
        self.document_id = document_id


class _FakeVersion:
    def __init__(self, content):
        self.id = "v-1"
        self.document_id = "doc-1"
        self.content = content


class _FakeRepo:
    """Minimal repository the flow_blueprint touches during init + first read.

    QML content is canonical in the document store, so the fake serves it from
    ``get_document_content`` rather than a file.
    """

    def __init__(self, survey, questionnaire):
        self._survey = survey
        self._questionnaire = questionnaire

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


def _make_app(repo, resolver=None) -> Flask:
    app = Flask(__name__)
    bp = create_flow_blueprint(
        repository=repo,
        url_prefix="/api/flow",
        external_input_resolver=resolver,
    )
    app.register_blueprint(bp)
    return app


@pytest.mark.integration
@pytest.mark.flow
class TestFlowBlueprintExternalInputs:
    def test_resolver_callback_fires_at_init(self):
        """The resolver is invoked exactly once at survey init with (survey,
        processor)."""
        survey = _FakeSurvey("s-1", "q-1")
        repo = _FakeRepo(survey, _FakeQuestionnaire())

        calls = []

        def resolver(survey_arg, processor_arg):
            calls.append((survey_arg, processor_arg))

        app = _make_app(repo, resolver=resolver)
        client = app.test_client()
        resp = client.get("/api/flow/current-item?survey_id=s-1")
        assert resp.status_code == 200

        assert len(calls) == 1
        called_survey, called_processor = calls[0]
        assert called_survey is survey
        assert hasattr(called_processor, "apply_external_inputs")

    def test_resolver_injection_hides_external_item(self):
        """A resolver that injects q_rotate_out auto-answers it, so the first
        presented item is the follow-up — matching the Portor runtime."""
        survey = _FakeSurvey("s-1", "q-1")
        repo = _FakeRepo(survey, _FakeQuestionnaire())

        def resolver(survey_arg, processor_arg):
            processor_arg.apply_external_inputs(survey_arg.qml_state, {"q_rotate_out": 1})

        app = _make_app(repo, resolver=resolver)
        resp = app.test_client().get("/api/flow/current-item?survey_id=s-1")
        assert resp.status_code == 200
        data = resp.get_json()

        # The external item was pre-answered and hidden; the follow-up is first.
        assert data["id"] == "q_followup"
        assert isinstance(survey.qml_state, QMLState)
        assert survey.qml_state.get_item("q_rotate_out")["outcome"] == 1
        assert survey.qml_state.is_externally_supplied("q_rotate_out")

    def test_no_resolver_asks_external_item(self):
        """Without a resolver callback (backward-compatible default), the
        external item is asked in the normal flow."""
        survey = _FakeSurvey("s-1", "q-1")
        repo = _FakeRepo(survey, _FakeQuestionnaire())

        app = _make_app(repo, resolver=None)
        resp = app.test_client().get("/api/flow/current-item?survey_id=s-1")
        assert resp.status_code == 200
        data = resp.get_json()

        assert data["id"] == "q_rotate_out"
        assert not survey.qml_state.is_externally_supplied("q_rotate_out")

    def test_reset_re_injects_external_item(self):
        """After POST /reset (which clears the sentinel + provenance), the
        resolver re-runs so the external item is re-prefilled and hidden again —
        a reset must not leave an external item to be asked directly."""
        survey = _FakeSurvey("s-1", "q-1")
        repo = _FakeRepo(survey, _FakeQuestionnaire())

        def resolver(survey_arg, processor_arg):
            processor_arg.apply_external_inputs(survey_arg.qml_state, {"q_rotate_out": 1})

        app = _make_app(repo, resolver=resolver)
        client = app.test_client()

        # First init: external item prefilled + hidden.
        first = client.get("/api/flow/current-item?survey_id=s-1").get_json()
        assert first["id"] == "q_followup"
        assert survey.qml_state.is_externally_supplied("q_rotate_out")

        # Reset: sentinel + provenance cleared, then the resolver re-runs.
        reset = client.post("/api/flow/reset", json={"survey_id": "s-1"})
        assert reset.status_code == 200
        item = reset.get_json()["item"]

        # The external item is auto-answered again (not presented) — the reset
        # re-prefilled it, so the first item post-reset is the follow-up.
        assert item["id"] == "q_followup"
        assert survey.qml_state.get_item("q_rotate_out")["outcome"] == 1
        assert survey.qml_state.is_externally_supplied("q_rotate_out")
