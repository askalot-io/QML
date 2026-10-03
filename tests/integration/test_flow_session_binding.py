"""
Integration tests for the flow API's organization binding (plan 2026-08-30 U7 —
R21/R37, KTD4).

``/api/flow/*`` is excluded from JWT middleware so a respondent with no platform
account can walk a survey from a magic link. Until this unit it resolved the
organization from an ``organization_id`` request parameter when no JWT was
present, which meant an unauthenticated caller could name the tenant it wanted
to act in and be believed — a survey id was then the only remaining secret. Two
new unauthenticated surfaces (the preview share link and the campaign open link)
ride the same endpoints, so that fallback is removed rather than inherited.

Tests what now authorizes a flow request, and what does not:

- A request carrying only an ``organization_id`` parameter is refused (AE17),
  in the query string and in the JSON body, and no organization context is set.
- A request carrying a session serves that session's organization and ignores a
  conflicting ``organization_id`` parameter entirely.
- A session naming survey A is refused on a request for survey B — so a leaked
  survey id is not sufficient on its own — and the refusal is a 403, distinct
  from the 401 for "nothing authorized you".
- A blueprint registered with no session resolver at all serves authenticated
  callers only: there is no path back to the parameter.
- The refusal fires BEFORE the endpoint body, so it arrives as a 401/403 rather
  than as the 500 the endpoints' broad exception handler would produce.

These integration tests drive the real blueprint over Flask's test client
because the property under test is which credential the request is served
under — a unit test of the resolver could not see the endpoint's own
exception handling, which is where the previous shape of this check would have
been swallowed.
"""

import pytest
from askalot_qml.api import create_flow_blueprint
from flask import Flask, jsonify

_QML = """
qmlVersion: "2.2"
questionnaire:
  title: Session Binding
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
"""

SURVEY_A = "aaaaaaaa-1111-1111-1111-111111111111"
SURVEY_B = "bbbbbbbb-2222-2222-2222-222222222222"


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
        # The blueprint tags timing events with the survey's mode. Set
        # explicitly rather than left to a MagicMock-style auto-attribute:
        # this fake exists to be exactly the surface under test.
        self.mode = "direct"


class _FakeRepo:
    """Only the surface the flow blueprint reaches during a current-item read.

    ``get_organization`` returns None deliberately: the retired parameter
    fallback used it to turn a caller-supplied id into a context, so a fake that
    answered it would let a regression pass here.
    """

    def __init__(self):
        self._questionnaire = type(
            "Q", (), {"id": "q-1", "name": "Session Binding", "document_id": "doc-1"}
        )()

    def get_survey(self, survey_id):
        if survey_id in (SURVEY_A, SURVEY_B):
            return _FakeSurvey(survey_id)
        return None

    def get_questionnaire(self, questionnaire_id):
        return self._questionnaire

    def get_campaign(self, campaign_id):
        return None

    def get_document_content(self, document_id, *, version_id=None):
        return _FakeVersion(_QML) if document_id == "doc-1" else None

    def get_organization(self, org_id):
        return None

    def save_survey_walk(self, survey):
        return survey.id


def _app(session=None):
    """A client plus a probe that reports the organization context the request ran under."""
    app = Flask(__name__)
    app.register_blueprint(
        create_flow_blueprint(
            repository=_FakeRepo(),
            url_prefix="/api/flow",
            session_resolver=(lambda: session) if session is not None else None,
        )
    )

    @app.route("/probe")
    def _probe():
        from askalot_common.repository import get_organization_context

        ctx = get_organization_context()
        return jsonify({"org": ctx.id if ctx else None})

    return app.test_client()


@pytest.fixture(autouse=True)
def _clean_context():
    """Organization context is thread-local and survives between requests in a
    test process. Clearing it around every test is what keeps a passing
    assertion from being a leftover from the previous one."""
    from askalot_common.repository import clear_organization_context

    clear_organization_context()
    yield
    clear_organization_context()


@pytest.mark.integration
@pytest.mark.flow
class TestTheParameterIsNoLongerAuthority:
    def test_an_organization_id_query_parameter_alone_is_refused(self):
        """AE17. The parameter used to be enough; now it is not read at all."""
        client = _app()

        resp = client.get(
            f"/api/flow/current-item?survey_id={SURVEY_A}&organization_id=org-1"
        )

        assert resp.status_code == 401
        assert "credential" in resp.get_json()["error"]

    def test_an_organization_id_in_the_json_body_alone_is_refused(self):
        """The old fallback read both places, so both have to be closed."""
        client = _app()

        resp = client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": SURVEY_A, "organization_id": "org-1", "outcome": 1},
        )

        assert resp.status_code == 401

    def test_the_refusal_is_a_401_not_the_endpoints_500(self):
        """Every endpoint wraps its body in a broad ``except Exception`` that
        renders a 500. A check raised inside one would reach the caller as a
        server error, which reads as a bug rather than as a refusal — so the
        check runs before the body."""
        client = _app()

        resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_A}")

        assert resp.status_code == 401
        assert resp.status_code != 500

    def test_no_session_resolver_at_all_leaves_no_path_back_to_the_parameter(self):
        """A service that registers the blueprint without a resolver serves
        authenticated callers only. It must not silently re-open the fallback."""
        client = _app()

        resp = client.get(
            f"/api/flow/current-item?survey_id={SURVEY_A}&organization_id=org-1"
        )

        assert resp.status_code == 401


@pytest.mark.integration
@pytest.mark.flow
class TestTheSessionIsTheAuthority:
    def test_a_session_serves_its_own_organization(self):
        client = _app(session=("org-session", "session-slug", SURVEY_A))

        resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_A}")

        assert resp.status_code == 200

    def test_a_conflicting_organization_parameter_is_ignored(self):
        """Not merely "the session wins" — the parameter is not consulted, so a
        caller cannot steer the request by supplying one."""
        client = _app(session=("org-session", "session-slug", SURVEY_A))

        resp = client.get(
            f"/api/flow/current-item?survey_id={SURVEY_A}&organization_id=org-attacker"
        )

        assert resp.status_code == 200
        probe = client.get("/probe")
        # The probe runs in the same client, after the flow request; what it
        # must never report is the attacker-supplied organization.
        assert probe.get_json()["org"] != "org-attacker"


@pytest.mark.integration
@pytest.mark.flow
class TestTheSessionNamesOneSurvey:
    def test_a_session_for_another_survey_is_refused(self):
        """The whole reason the session names a survey: a leaked survey id is
        not sufficient on its own, even inside the right organization."""
        client = _app(session=("org-session", "session-slug", SURVEY_A))

        resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_B}")

        assert resp.status_code == 403
        assert "not valid for that survey" in resp.get_json()["error"]

    def test_the_mismatch_refusal_is_distinct_from_the_missing_credential_one(self):
        """403 and 401 answer different questions — "your credential is out of
        scope" versus "you have none". Collapsing them would hide a real
        credential being used somewhere it should not be."""
        bound = _app(session=("org-session", "session-slug", SURVEY_A))
        anonymous = _app()

        mismatch = bound.get(f"/api/flow/current-item?survey_id={SURVEY_B}")
        missing = anonymous.get(f"/api/flow/current-item?survey_id={SURVEY_B}")

        assert mismatch.status_code == 403
        assert missing.status_code == 401

    def test_the_binding_is_checked_on_a_json_body_request_too(self):
        client = _app(session=("org-session", "session-slug", SURVEY_A))

        resp = client.post(
            "/api/flow/evaluate-item", json={"survey_id": SURVEY_B, "outcome": 1}
        )

        assert resp.status_code == 403

    def test_a_matching_query_argument_does_not_license_a_mismatching_body(self):
        """The bypass this check exists to close.

        The guard used to read the query argument and fall back to the body
        only when the argument was absent, while ``evaluate-item`` reads the
        body alone. So naming the session's own survey in the query string
        satisfied the guard, and the endpoint then acted on the body's survey —
        a leaked id in the same organization was enough again, which is exactly
        what binding the session to one survey is for.
        """
        client = _app(session=("org-session", "session-slug", SURVEY_A))

        resp = client.post(
            f"/api/flow/evaluate-item?survey_id={SURVEY_A}",
            json={"survey_id": SURVEY_B, "outcome": 1},
        )

        assert resp.status_code == 403
        assert "not valid for that survey" in resp.get_json()["error"]

    def test_a_matching_body_does_not_license_a_mismatching_query_argument(self):
        """The same gap in the other direction, for the GET routes that read
        ``request.args``. Neither source is authority; every id the request
        carries must be the session's."""
        client = _app(session=("org-session", "session-slug", SURVEY_A))

        resp = client.post(
            f"/api/flow/evaluate-item?survey_id={SURVEY_B}",
            json={"survey_id": SURVEY_A, "outcome": 1},
        )

        assert resp.status_code == 403

    def test_a_request_naming_no_survey_still_needs_a_session(self):
        """An endpoint that takes no survey id cannot check the binding, so the
        session's mere existence is what authorizes it — and its absence still
        refuses."""
        client = _app()

        resp = client.get("/api/flow/current-item")

        assert resp.status_code == 401
