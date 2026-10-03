"""Integration tests for the flow API serving two stores from one engine.

A preview walk and a fielded interview traverse the instrument identically —
same navigation, same postcondition ordering, same timing log, same degradation
warnings (plan 2026-08-31-2030, R10). What differs is only where the state
lands: a preview's state goes to ``preview_runs``, a fielded interview's to
``surveys``. Keeping one engine is the point — a parallel preview blueprint
would mean a flow fix could land on only half of walks (KTD2).

Tests the store seam:
- A preview walk reads and writes the preview store and never touches surveys.
- A fielded walk is unaffected and still reads and writes surveys.
- The store is chosen from the credential, not from a caller-supplied kind, so
  a request cannot name the store it wants.
- Advancing a preview persists through the preview store's state writer rather
  than through an upsert of a whole row.
- Timing events open and close on a preview walk exactly as on a fielded one,
  which is what R10's "same timing record" means concretely.
- A fielded walk in a SEALED organization is closed legibly, on the endpoints
  that look like reads as well as the ones that obviously write — while a
  preview walk in the same sealed organization keeps working.
- A fielded write that lost a race with another step on the same survey
  answers 409 ``survey_state_conflict``, not a 500, and records nothing.

These integration tests drive the real blueprint over Flask's test client, with
a fake repository that records which store each call reached. A unit test of the
resolver could not show that the 9 write sites and 11 read sites inside the
endpoints actually route through the seam — which is the whole property.
"""

import pytest
from askalot_qml.api import create_flow_blueprint
from flask import Flask

_QML = """
qmlVersion: "2.2"
questionnaire:
  title: Preview Store
  blocks:
    - id: main
      kind: Group
      items:
        - id: q1
          kind: Question
          title: How are you?
          input:
            control: Radio
            labels:
              1: Fine
              2: Not fine
        - id: q2
          kind: Question
          title: Why?
          input:
            control: Radio
            labels:
              1: Because
              2: No reason
"""

SURVEY_ID = "aaaaaaaa-1111-1111-1111-111111111111"
PREVIEW_ID = "pppppppp-3333-3333-3333-333333333333"


class _FakeVersion:
    def __init__(self, content):
        self.content = content


class _FakeSurvey:
    def __init__(self, survey_id):
        self.id = survey_id
        self.questionnaire_id = "q-1"
        self.respondent_id = "r-1"
        self.campaign_id = None
        self.interviewer_user_id = None
        self.status = "in_progress"
        self.qml_state = {}
        self.current_block_id = None
        self.current_item_id = None
        self.mode = "direct"


class _FakePreviewRun:
    """The preview store's row, with the surface the flow engine reads.

    ``campaign_id`` is None because a preview belongs to no fielding — the
    engine reads it for its audit context, and a preview genuinely has none.
    """

    def __init__(self, run_id):
        self.id = run_id
        self.questionnaire_id = "q-1"
        self.launched_by_user_id = None
        self.campaign_id = None
        self.status = "in_progress"
        self.qml_state = {}
        self.current_block_id = None
        self.current_item_id = None
        self.mode = "direct"


class _RecordingRepo:
    """Records which store each call reached, so routing is observable."""

    def __init__(self):
        self._questionnaire = type(
            "Q", (), {"id": "q-1", "name": "Preview Store", "document_id": "doc-1"}
        )()
        self.survey_reads: list[str] = []
        self.survey_writes: list[str] = []
        self.preview_reads: list[str] = []
        self.preview_writes: list[str] = []
        self._surveys: dict[str, _FakeSurvey] = {SURVEY_ID: _FakeSurvey(SURVEY_ID)}
        self._previews: dict[str, _FakePreviewRun] = {PREVIEW_ID: _FakePreviewRun(PREVIEW_ID)}

    # --- survey store ---
    def get_survey(self, survey_id):
        self.survey_reads.append(survey_id)
        return self._surveys.get(survey_id)

    def save_survey_walk(self, survey):
        self.survey_writes.append(survey.id)
        self._surveys[survey.id] = survey
        return survey.id

    # --- preview store ---
    def get_preview_run(self, run_id):
        self.preview_reads.append(run_id)
        return self._previews.get(run_id)

    def update_preview_run_state(
        self, run_id, *, qml_state, current_block_id=None, current_item_id=None, status=None
    ):
        self.preview_writes.append(run_id)
        run = self._previews.get(run_id)
        if run is None:
            return False
        run.qml_state = qml_state
        run.current_block_id = current_block_id
        run.current_item_id = current_item_id
        if status is not None:
            run.status = status
        return True

    # --- shared reads ---
    def get_questionnaire(self, questionnaire_id):
        return self._questionnaire

    def get_campaign(self, campaign_id):
        return None

    def get_document_content(self, document_id, *, version_id=None):
        return _FakeVersion(_QML) if document_id == "doc-1" else None

    def get_organization(self, org_id):
        return None


def _client(repo, session):
    app = Flask(__name__)
    app.register_blueprint(
        create_flow_blueprint(
            repository=repo,
            url_prefix="/api/flow",
            session_resolver=lambda: session,
        )
    )
    return app.test_client()


@pytest.fixture(autouse=True)
def _clean_context():
    from askalot_common.repository import clear_organization_context

    clear_organization_context()
    yield
    clear_organization_context()


@pytest.mark.integration
@pytest.mark.flow
class TestAPreviewWalkNeverTouchesSurveys:
    def test_reading_the_current_item_uses_the_preview_store(self):
        repo = _RecordingRepo()
        client = _client(repo, ("org-1", "org-slug", PREVIEW_ID))

        resp = client.get(f"/api/flow/current-item?survey_id={PREVIEW_ID}")

        assert resp.status_code == 200
        assert repo.preview_reads, "the preview store was never read"
        # Surveys is probed once to resolve the store — a lookup that returns
        # nothing. What must never happen is a survey WRITE; see below.
        assert repo.survey_writes == [], f"surveys was written: {repo.survey_writes}"

    def test_answering_writes_the_preview_store_and_not_surveys(self):
        repo = _RecordingRepo()
        client = _client(repo, ("org-1", "org-slug", PREVIEW_ID))
        client.get(f"/api/flow/current-item?survey_id={PREVIEW_ID}")

        resp = client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": PREVIEW_ID, "item_id": "q1", "outcome": 1},
        )

        assert resp.status_code == 200
        assert repo.preview_writes, "the preview store was never written"
        # The whole point of the unit: testing an instrument alters no survey row.
        assert repo.survey_writes == [], f"surveys was written: {repo.survey_writes}"

    def test_the_walk_records_timing_exactly_as_a_fielded_one_does(self):
        """R10 — same timing record, which is what makes the engine one engine."""
        repo = _RecordingRepo()
        client = _client(repo, ("org-1", "org-slug", PREVIEW_ID))
        client.get(f"/api/flow/current-item?survey_id={PREVIEW_ID}")
        client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": PREVIEW_ID, "item_id": "q1", "outcome": 1},
        )

        events = repo._previews[PREVIEW_ID].qml_state.get("response_timing") or []

        assert events, "a preview walk recorded no timing events"
        assert any(e.get("s") for e in events), "no submission was stamped"


@pytest.mark.integration
@pytest.mark.flow
class TestAFieldedWalkIsUnaffected:
    def test_reading_and_answering_still_use_surveys(self):
        repo = _RecordingRepo()
        client = _client(repo, ("org-1", "org-slug", SURVEY_ID))

        client.get(f"/api/flow/current-item?survey_id={SURVEY_ID}")
        resp = client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": SURVEY_ID, "item_id": "q1", "outcome": 1},
        )

        assert resp.status_code == 200
        assert repo.survey_reads, "surveys was never read"
        assert repo.survey_writes, "surveys was never written"
        assert repo.preview_writes == [], "a fielded walk wrote the preview store"


@pytest.mark.integration
@pytest.mark.flow
class TestTheStoreComesFromTheCredential:
    def test_a_session_naming_a_preview_is_refused_for_a_survey_id(self):
        """The binding check still applies; the store choice does not weaken it."""
        repo = _RecordingRepo()
        client = _client(repo, ("org-1", "org-slug", PREVIEW_ID))

        resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_ID}")

        assert resp.status_code == 403
        assert repo.survey_reads == []
        assert repo.preview_reads == []


@pytest.mark.integration
@pytest.mark.flow
class TestAFieldedWalkInASealedOrganization:
    """The seal reaches the walk, and says so instead of crashing.

    ``save_survey_walk`` refuses a survey write in a sealed organization, and every
    survey write here funnels through ``_FlowStore.save``. The endpoints wrap
    their bodies in a blanket ``except Exception`` that returns 500 with the
    raw message, so without a translation the respondent's page load answered
    with a database sentence naming a table and a UUID.

    ``current-item`` matters most: it LOOKS like a read and the request guard
    exempts GET on purpose, but it writes a timing event before rendering.
    """

    class _SealedRepo(_RecordingRepo):
        def save_survey_walk(self, survey):
            from askalot_common.repository.exceptions import OrganizationSealedError

            raise OrganizationSealedError("Organization org-1 is sealed; no write may land.")

    def test_reading_the_current_item_of_a_fielded_walk_is_closed_not_crashed(self):
        repo = self._SealedRepo()
        client = _client(repo, ("org-1", "org-slug", SURVEY_ID))

        resp = client.get("/api/flow/current-item", query_string={"survey_id": SURVEY_ID})

        assert resp.status_code == 403, (
            "a sealed organization answered a GET walk with something other than "
            f"a refusal: {resp.status_code} {resp.get_data(as_text=True)}"
        )
        body = resp.get_json()
        assert body["error"] == "org_sealed"
        assert "closed" in body["detail"].lower()
        assert "no write may land" not in body["detail"], (
            "the raw repository message reached the respondent"
        )

    def test_answering_a_fielded_walk_is_closed_too(self):
        repo = self._SealedRepo()
        client = _client(repo, ("org-1", "org-slug", SURVEY_ID))

        resp = client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": SURVEY_ID, "item_id": "q1", "outcome": 1},
        )

        assert resp.status_code == 403
        assert resp.get_json()["error"] == "org_sealed"

    def test_a_preview_walk_in_the_same_sealed_organization_still_works(self):
        """The whole point of the two stores, asserted against the seal.

        A preview writes ``preview_runs``, which no dataset can return, so the
        organization that closes a fielded walk still lets an instrument be
        reviewed.
        """
        repo = self._SealedRepo()
        client = _client(repo, ("org-1", "org-slug", PREVIEW_ID))

        resp = client.get("/api/flow/current-item", query_string={"survey_id": PREVIEW_ID})

        assert resp.status_code == 200, resp.get_data(as_text=True)
        assert repo.preview_writes, "the preview store was never written"
        assert repo.survey_writes == [], "a preview walk reached surveys"


@pytest.mark.integration
@pytest.mark.flow
class TestAFieldedWriteThatLostARace:
    """A step whose survey changed since it was read is refused, legibly.

    ``save_survey_walk`` raises ``SurveyStateConflictError`` when the row moved
    under the walk (another tab, the respondent's AI channel). Writing anyway
    would restore what this step had read over what the other one saved; the
    blanket ``except Exception`` would have turned the refusal into a 500.
    """

    class _RacedRepo(_RecordingRepo):
        def save_survey_walk(self, survey):
            from askalot_common.repository.exceptions import SurveyStateConflictError

            raise SurveyStateConflictError(survey.id)

    @pytest.mark.parametrize(
        "method,path,payload",
        [
            ("get", "/api/flow/current-item", None),
            ("post", "/api/flow/evaluate-item", {"item_id": "q1", "outcome": 1}),
        ],
    )
    def test_the_step_answers_409_and_says_reload(self, method, path, payload):
        client = _client(self._RacedRepo(), ("org-1", "org-slug", SURVEY_ID))

        if method == "get":
            resp = client.get(path, query_string={"survey_id": SURVEY_ID})
        else:
            resp = client.post(path, json={"survey_id": SURVEY_ID, **payload})

        assert resp.status_code == 409, resp.get_data(as_text=True)
        body = resp.get_json()
        assert body["error"] == "survey_state_conflict"
        assert "Reload" in body["message"] and SURVEY_ID not in body["message"]
