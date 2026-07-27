"""
Integration tests for DB-canonical QML reads and the fielding pin
(plan 2026-07-21-001, U5 — R11 / KTD6 read side).

Tests that QML content resolves from the document store rather than the
filesystem, and that a survey keeps the instrument it was fielded on:

- ``load_qml_content`` returns the questionnaire document's head
- ``load_qml_content(version_id=...)`` returns that exact version instead
- ``load_fielded_qml_content`` serves the campaign's pinned version EVEN AFTER
  the questionnaire's head advances (Covers F4)
- a campaign-less ad-hoc survey, and a campaign with no pin, read head
- a questionnaire with no document link fails loud (``QMLDocumentMissingError``,
  a ``FileNotFoundError``) instead of silently resolving to nothing
- ``RepositoryQMLSource`` resolves canonical questionnaire names and refuses
  non-canonical ones; ``QMLLoader(content_source=...)`` runs the full
  parse/validate pipeline over the resolved content and lists document names
- the SirWay flow blueprint, driven end-to-end over HTTP, serves the pinned
  questionnaire's first item after the head moved on

These integration tests exercise the real loader, the real ``FlowProcessor``,
and the real Flask blueprint; only persistence is a fake, implementing the
``DocumentMixin`` read contract (head vs ``version_id``) verbatim. The fielding
pin is the guarantee that a respondent mid-interview is never handed a
different questionnaire, so it is asserted at both the helper and the HTTP
layer.
"""

import pytest
from askalot_qml.api import create_flow_blueprint
from askalot_qml.core import (
    QMLDocumentMissingError,
    QMLLoader,
    RepositoryQMLSource,
    canonical_qml_rel_path,
    load_fielded_qml_content,
    load_qml_content,
)
from flask import Flask

PROJECT_ID = "11111111-1111-1111-1111-111111111111"
QUESTIONNAIRE_ID = "22222222-2222-2222-2222-222222222222"
DOCUMENT_ID = "33333333-3333-3333-3333-333333333333"


def _qml(title: str, first_item_title: str) -> str:
    return f"""
qmlVersion: "2.2"
questionnaire:
  title: {title}
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_first
          kind: Question
          title: {first_item_title}
          input:
            control: Radio
            labels:
              1: A
              2: B
"""


PINNED_QML = _qml("Pinned", "Pinned question")
HEAD_QML = _qml("Head", "Head question")


class _FakeVersion:
    def __init__(self, version_id: str, content: str):
        self.id = version_id
        self.document_id = DOCUMENT_ID
        self.content = content


class _FakeDocument:
    def __init__(self, document_id: str, project_id: str, key: str):
        self.id = document_id
        self.project_id = project_id
        self.key = key
        self.kind = "qml"


class _FakeQuestionnaire:
    def __init__(self, document_id: str | None = DOCUMENT_ID):
        self.id = QUESTIONNAIRE_ID
        self.project_id = PROJECT_ID
        self.qml_name = canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)
        self.document_id = document_id


class _FakeCampaign:
    def __init__(self, campaign_id: str, qml_version_id: str | None):
        self.id = campaign_id
        self.qml_version_id = qml_version_id


class _FakeSurvey:
    def __init__(self, campaign_id: str | None):
        self.id = "survey-1"
        self.questionnaire_id = QUESTIONNAIRE_ID
        self.campaign_id = campaign_id
        self.respondent_id = "r-1"
        self.qml_state = None
        self.status = "in_progress"
        self.current_item_id = None
        self.current_block_id = None
        # Read by the blueprint to tag timing events respondent vs interviewer.
        self.mode = "direct"


class _FakeRepo:
    """The ``DocumentMixin`` read contract, in memory.

    ``get_document_content`` reproduces the real method exactly: ``version_id``
    resolves that row, its absence resolves head, and a version belonging to
    another document raises rather than silently missing.
    """

    def __init__(self, *, questionnaire, campaigns=None, versions=None, head_version_id=None):
        self._questionnaire = questionnaire
        self._campaigns = campaigns or {}
        self._versions = versions or {}
        self._head_version_id = head_version_id
        self._survey = None

    # -- document store -------------------------------------------------
    def get_document_content(self, document_id, *, version_id=None):
        if document_id != DOCUMENT_ID:
            return None
        resolved = version_id or self._head_version_id
        version = self._versions.get(resolved)
        if version is None:
            return None
        if version.document_id != document_id:
            raise ValueError(f"Version {version_id!r} does not belong to {document_id!r}")
        return version

    def list_documents(self, *, project_id=None, kind=None, include_deleted=False):
        return [_FakeDocument(DOCUMENT_ID, PROJECT_ID, QUESTIONNAIRE_ID)] if kind == "qml" else []

    # -- domain rows ----------------------------------------------------
    def get_questionnaire(self, questionnaire_id):
        return self._questionnaire if questionnaire_id == QUESTIONNAIRE_ID else None

    def get_campaign(self, campaign_id):
        return self._campaigns.get(campaign_id)

    def get_survey(self, survey_id):
        return self._survey if self._survey and survey_id == self._survey.id else None

    def get_organization(self, org_id):
        return None

    def upsert_survey(self, survey):
        return survey.id


@pytest.fixture
def repo():
    """A questionnaire whose head has advanced past the version a campaign pinned."""
    return _FakeRepo(
        questionnaire=_FakeQuestionnaire(),
        campaigns={
            "camp-pinned": _FakeCampaign("camp-pinned", "v1"),
            "camp-unpinned": _FakeCampaign("camp-unpinned", None),
        },
        versions={"v1": _FakeVersion("v1", PINNED_QML), "v2": _FakeVersion("v2", HEAD_QML)},
        head_version_id="v2",
    )


@pytest.mark.integration
class TestDocumentContentReads:
    def test_head_is_the_default_read(self, repo):
        assert load_qml_content(repo, _FakeQuestionnaire()) == HEAD_QML

    def test_explicit_version_wins_over_head(self, repo):
        assert load_qml_content(repo, _FakeQuestionnaire(), version_id="v1") == PINNED_QML

    def test_questionnaire_without_document_fails_loud(self, repo):
        with pytest.raises(QMLDocumentMissingError):
            load_qml_content(repo, _FakeQuestionnaire(document_id=None))

    def test_missing_version_fails_loud(self, repo):
        with pytest.raises(QMLDocumentMissingError):
            load_qml_content(repo, _FakeQuestionnaire(), version_id="nope")


@pytest.mark.integration
class TestFieldingPin:
    """Covers F4 — a survey in flight keeps the version its campaign pinned."""

    def test_pinned_version_survives_head_advance(self, repo):
        survey = _FakeSurvey(campaign_id="camp-pinned")

        content = load_fielded_qml_content(repo, survey, _FakeQuestionnaire())

        assert content == PINNED_QML
        assert content != HEAD_QML

    def test_ad_hoc_survey_without_campaign_reads_head(self, repo):
        survey = _FakeSurvey(campaign_id=None)

        assert load_fielded_qml_content(repo, survey, _FakeQuestionnaire()) == HEAD_QML

    def test_campaign_without_pin_reads_head(self, repo):
        survey = _FakeSurvey(campaign_id="camp-unpinned")

        assert load_fielded_qml_content(repo, survey, _FakeQuestionnaire()) == HEAD_QML


@pytest.mark.integration
class TestRepositoryQMLSource:
    def test_canonical_name_resolves_head_content(self, repo):
        source = RepositoryQMLSource(repo)

        assert source.read(canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)) == HEAD_QML

    def test_non_canonical_name_is_refused(self, repo):
        with pytest.raises(QMLDocumentMissingError):
            RepositoryQMLSource(repo).read("demographic.qml")

    def test_listing_returns_document_names(self, repo):
        assert RepositoryQMLSource(repo).list_names() == [
            canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)
        ]

    def test_loader_seam_runs_the_full_pipeline(self, repo):
        loader = QMLLoader(content_source=RepositoryQMLSource(repo))

        parsed = loader.load_from_file(canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID))

        # Flattened items + injected default block kind prove the real
        # post-parse pipeline ran, not a raw YAML load.
        assert [item["id"] for item in parsed["items"]] == ["q_first"]
        assert parsed["blocks"][0]["kind"] == "Group"
        assert loader.list_available_files() == [
            canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)
        ]


@pytest.mark.integration
@pytest.mark.flow
class TestFlowBlueprintServesPinnedVersion:
    """The HTTP fielding path, end to end (Covers F4)."""

    def _client(self, repo, survey):
        repo._survey = survey
        app = Flask(__name__)
        app.register_blueprint(create_flow_blueprint(repository=repo, url_prefix="/api/flow"))
        return app.test_client()

    def test_current_item_comes_from_the_pinned_version(self, repo):
        client = self._client(repo, _FakeSurvey(campaign_id="camp-pinned"))

        response = client.get("/api/flow/current-item?survey_id=survey-1")

        assert response.status_code == 200
        assert response.get_json()["title"] == "Pinned question"

    def test_ad_hoc_survey_gets_head(self, repo):
        client = self._client(repo, _FakeSurvey(campaign_id=None))

        response = client.get("/api/flow/current-item?survey_id=survey-1")

        assert response.status_code == 200
        assert response.get_json()["title"] == "Head question"
