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
- A session bound to the requested survey outranks an organization a JWT
  already set (#1605): a signed-in visitor walking a link into another
  organization reads the survey in the link's organization. A session bound to
  a DIFFERENT survey changes nothing, and the JWT's organization stands.
- A signed-in caller's JWT sets the organization only when the whole session
  check passes (``verified_session``): a token revoked by a logout chooses
  nothing and the request is refused like one with no credential (#2184).
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
        self.campaign_id = "camp-1"
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
        #: The organization context each survey read ran under.
        self.read_in: list[str | None] = []
        self._questionnaire = type(
            "Q", (), {"id": "q-1", "name": "Session Binding", "document_id": "doc-1"}
        )()

    def get_survey(self, survey_id):
        from askalot_common.repository import get_organization_context

        ctx = get_organization_context()
        self.read_in.append(ctx.id if ctx else None)
        if survey_id in (SURVEY_A, SURVEY_B):
            return _FakeSurvey(survey_id)
        return None

    def get_questionnaire(self, questionnaire_id):
        return self._questionnaire

    def get_campaign(self, campaign_id):
        """A fielding, unpinned campaign: every survey has one (``ck_surveys_campaign_present``)."""
        if not campaign_id:
            return None
        return type("C", (), {"id": campaign_id, "status": "active", "qml_version_id": None})()

    def get_document_content(self, document_id, *, version_id=None):
        return _FakeVersion(_QML) if document_id == "doc-1" else None

    def get_organization(self, org_id):
        return None

    def save_survey_walk(self, survey):
        return survey.id


def _app(session=None, *, repo=None, jwt_org=None):
    """A client plus a probe that reports the organization context the request ran under.

    ``jwt_org`` stands in for the JWT middleware, which sets the signed-in
    caller's active organization before the flow blueprint runs.
    """
    app = Flask(__name__)
    if jwt_org is not None:

        @app.before_request
        def _jwt_middleware():
            from askalot_common.repository import set_organization_context

            set_organization_context(jwt_org, "jwt-slug")

    app.register_blueprint(
        create_flow_blueprint(
            repository=repo or _FakeRepo(),
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

        resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_A}&organization_id=org-1")

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

        resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_A}&organization_id=org-1")

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
class TestABoundSessionOutranksTheJWT:
    """#1605. A signed-in visitor opened a link into another organization."""

    def test_the_survey_is_read_in_the_sessions_organization(self):
        repo = _FakeRepo()
        client = _app(("org-link", "link-slug", SURVEY_A), repo=repo, jwt_org="org-visitor")

        resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_A}")

        assert resp.status_code == 200
        assert repo.read_in and set(repo.read_in) == {"org-link"}

    def test_a_non_object_json_body_is_not_a_500(self):
        """A bare JSON list names no survey; reading it must not raise."""
        client = _app(("org-link", "link-slug", SURVEY_A), jwt_org="org-visitor")

        resp = client.open(f"/api/flow/current-item?survey_id={SURVEY_A}", method="GET", json=[1])

        assert resp.status_code != 500

    def test_a_session_for_another_survey_leaves_the_jwt_in_charge(self):
        repo = _FakeRepo()
        client = _app(("org-link", "link-slug", SURVEY_A), repo=repo, jwt_org="org-visitor")

        resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_B}")

        assert resp.status_code == 200
        assert repo.read_in and set(repo.read_in) == {"org-visitor"}


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

        resp = client.post("/api/flow/evaluate-item", json={"survey_id": SURVEY_B, "outcome": 1})

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


@pytest.mark.integration
@pytest.mark.flow
class TestOnlyALiveSessionChoosesTheOrganization:
    """The JWT branch checks revocation, not the signature alone (#2184)."""

    _PAYLOAD = {
        "sub": "user-1",
        "jti": "jti-1",
        "sid": "sid-1",
        "role_memberships": {"tenant": [], "organization": []},
        "organization_id": "org-jwt",
        "organization_slug": "jwt-slug",
    }

    def _client_with_token(self, *, revoked):
        from unittest.mock import MagicMock, patch

        user_service = MagicMock()
        user_service.repository.is_token_blacklisted.return_value = revoked
        user_service.load_user_by_id.return_value = {"id": "user-1"}
        repo = _FakeRepo()
        patches = [
            patch("askalot_common.auth.extract_jwt_token", return_value="a-signed-token"),
            patch("askalot_common.auth.get_auth_config", return_value=object()),
            patch("askalot_common.auth.verify_jwt_token", return_value=dict(self._PAYLOAD)),
            patch("askalot_common.auth.middleware.verify_jwt_token", return_value=dict(self._PAYLOAD)),
            patch("askalot_common.auth.user_service.get_user_service", return_value=user_service),
        ]
        return _app(repo=repo), repo, patches

    def test_a_revoked_token_sets_no_organization(self):
        client, repo, patches = self._client_with_token(revoked=True)
        for p in patches:
            p.start()
        try:
            resp = client.get(f"/api/flow/current-item?survey_id={SURVEY_A}")
        finally:
            for p in patches:
                p.stop()

        assert resp.status_code == 401
        assert repo.read_in == []

    def test_a_live_token_serves_its_organization(self):
        client, repo, patches = self._client_with_token(revoked=False)
        for p in patches:
            p.start()
        try:
            client.get(f"/api/flow/current-item?survey_id={SURVEY_A}")
        finally:
            for p in patches:
                p.stop()

        assert repo.read_in and repo.read_in[0] == "org-jwt"
