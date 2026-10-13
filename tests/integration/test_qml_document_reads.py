"""
Integration tests for DB-canonical QML reads and the fielding pin
(plan 2026-07-21-001, U5 — R11 / KTD6 read side).

Tests that QML content resolves from the document store rather than the
filesystem, and that a survey keeps the instrument it was fielded on:

- ``load_qml_content`` returns the questionnaire document's head
- ``load_qml_content(version_id=...)`` returns that exact version instead
- ``load_fielded_qml_content`` serves the campaign's pinned version EVEN AFTER
  the questionnaire's head advances (Covers F4)
- a VOLUNTEER survey, created against a campaign after that head moved, is
  served the same pinned version as a drawn one (Covers AE4)
- a campaign-less preview, and a campaign with no pin, read head
- a questionnaire with no document link fails loud (``QMLDocumentMissingError``,
  a ``FileNotFoundError``) instead of silently resolving to nothing
- ``parse_qml_address`` reads the canonical and the bare address into their
  ids and form, and answers nothing for any other layout
- ``RepositoryQMLSource`` resolves canonical questionnaire names and refuses
  non-canonical ones, the bare ``<questionnaire_id>.qml`` included; ``QMLLoader(content_source=...)`` runs the full
  parse/validate pipeline over the resolved content and lists document names
- ``RepositoryQMLSource.read_within`` returns a body with ITS OWN byte size,
  version id and version number in one read, withholds an oversized body while
  still reporting its size and version, and fails loud rather than reporting 0
  for a document that is not there (#213)
- the SirWay flow blueprint, driven end-to-end over HTTP, serves the pinned
  questionnaire's first item after the head moved on

These integration tests exercise the real loader, the real ``FlowProcessor``,
and the real Flask blueprint; only persistence is a fake, implementing the
``DocumentMixin`` read contract (head vs ``version_id``) verbatim. The fielding
pin is the guarantee that a respondent mid-interview is never handed a
different questionnaire, so it is asserted at both the helper and the HTTP
layer.
"""

from types import SimpleNamespace

import pytest
from askalot_common.repository.mixins.document import HeadContentProbe
from askalot_qml.api import create_flow_blueprint
from askalot_qml.core import (
    QMLDocumentMissingError,
    QMLLoader,
    RepositoryQMLSource,
    canonical_qml_rel_path,
    load_fielded_qml_content,
    load_qml_content,
    parse_qml_address,
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
    def __init__(self, version_id: str, content: str, version_number: int = 1):
        self.id = version_id
        self.document_id = DOCUMENT_ID
        self.content = content
        self.version_number = version_number


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
    def __init__(self, campaign_id: str | None, arrival: str = "drawn"):
        self.id = "survey-1"
        self.questionnaire_id = QUESTIONNAIRE_ID
        self.campaign_id = campaign_id
        # How the respondent reached the campaign. Resolution keys on the
        # campaign, never on this, which is what AE4 asserts.
        self.arrival = arrival
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

    def _is_preview(self) -> bool:
        return getattr(self._survey, "arrival", None) == "preview"

    def get_survey(self, survey_id):
        """A preview is NOT in surveys — it lives in the preview store.

        The fixture answers the way production does after previews moved out of
        ``surveys``, so a test that says "preview" exercises the store that
        actually holds one.
        """
        if not self._survey or survey_id != self._survey.id or self._is_preview():
            return None
        return self._survey

    def get_preview_run(self, run_id):
        if not self._survey or run_id != self._survey.id or not self._is_preview():
            return None
        return self._survey

    def update_preview_run_state(
        self, run_id, *, qml_state, current_block_id=None, current_item_id=None, status=None
    ):
        self._survey.qml_state = qml_state
        self._survey.current_block_id = current_block_id
        self._survey.current_item_id = current_item_id
        if status is not None:
            self._survey.status = status
        return True

    def head_content_within(self, document_id, *, max_bytes):
        """The real one-read probe: id, number and size always, body only when it fits.

        Reproduces the SQL exactly — every value is taken from the one head
        row, so a caller cannot get an id, a size and a body that describe
        different versions.
        """
        if document_id != DOCUMENT_ID:
            return None
        version = self._versions.get(self._head_version_id)
        if version is None:
            return None
        size = len(version.content.encode("utf-8"))
        return HeadContentProbe(
            version_id=version.id,
            version_number=version.version_number,
            size_bytes=size,
            content=version.content if size <= max_bytes else None,
        )

    def get_organization(self, org_id):
        return None

    def save_survey_walk(self, survey):
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
        versions={"v1": _FakeVersion("v1", PINNED_QML), "v2": _FakeVersion("v2", HEAD_QML, 2)},
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

    def test_volunteer_survey_gets_the_same_pin_as_a_drawn_one(self, repo):
        """Covers AE4 — a volunteer joins an already-fielded campaign, so the
        instrument they answer is the one that campaign pinned, not whatever
        the questionnaire's head has since become. Resolution keys on the
        campaign; how the respondent arrived never enters it."""
        volunteer = _FakeSurvey(campaign_id="camp-pinned", arrival="volunteer")
        drawn = _FakeSurvey(campaign_id="camp-pinned", arrival="drawn")

        content = load_fielded_qml_content(repo, volunteer, _FakeQuestionnaire())

        assert content == PINNED_QML
        assert content == load_fielded_qml_content(repo, drawn, _FakeQuestionnaire())

    def test_survey_without_campaign_reads_head(self, repo):
        """A preview or training run belongs to no campaign, so there is no pin
        to serve. This is the only head-reading branch, and a volunteer does not
        widen it — they have a campaign."""
        survey = _FakeSurvey(campaign_id=None)

        assert load_fielded_qml_content(repo, survey, _FakeQuestionnaire()) == HEAD_QML

    def test_volunteer_on_an_unpinned_campaign_reads_head(self, repo):
        """A campaign with no pin reads head for every arrival alike — the
        missing pin is the reason, and it is logged where it happens."""
        survey = _FakeSurvey(campaign_id="camp-unpinned", arrival="volunteer")

        assert load_fielded_qml_content(repo, survey, _FakeQuestionnaire()) == HEAD_QML

    def test_campaign_without_pin_reads_head(self, repo):
        survey = _FakeSurvey(campaign_id="camp-unpinned")

        assert load_fielded_qml_content(repo, survey, _FakeQuestionnaire()) == HEAD_QML


@pytest.mark.integration
class TestQmlAddressParser:
    def test_a_canonical_address_yields_both_ids(self):
        address = parse_qml_address(canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID))

        assert address.form == "canonical"
        assert address.project_id == PROJECT_ID
        assert address.questionnaire_id == QUESTIONNAIRE_ID

    def test_a_bare_address_yields_the_questionnaire_and_no_project(self):
        address = parse_qml_address(f"{QUESTIONNAIRE_ID}.qml")

        assert address.form == "bare"
        assert address.project_id is None
        assert address.questionnaire_id == QUESTIONNAIRE_ID

    def test_slashes_around_an_address_are_ignored(self):
        name = canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)

        assert parse_qml_address(f"/{name}/") == parse_qml_address(name)

    @pytest.mark.parametrize(
        "qml_name",
        [
            "",
            ".qml",
            "shared/foo.qml",
            QUESTIONNAIRE_ID,
            f"{QUESTIONNAIRE_ID}.txt",
            f"projects/{PROJECT_ID}/questionnaires/{QUESTIONNAIRE_ID}",
            f"projects/{PROJECT_ID}/{QUESTIONNAIRE_ID}.qml",
            f"drafts/{PROJECT_ID}/questionnaires/{QUESTIONNAIRE_ID}.qml",
            f"projects/{PROJECT_ID}/questionnaires/extra/{QUESTIONNAIRE_ID}.qml",
        ],
    )
    def test_any_other_layout_addresses_nothing(self, qml_name):
        assert parse_qml_address(qml_name) is None


@pytest.mark.integration
class TestRepositoryQMLSource:
    def test_canonical_name_resolves_head_content(self, repo):
        source = RepositoryQMLSource(repo)

        assert source.read(canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)) == HEAD_QML

    def test_non_canonical_name_is_refused(self, repo):
        with pytest.raises(QMLDocumentMissingError):
            RepositoryQMLSource(repo).read("demographic.qml")

    def test_the_bare_address_of_a_stored_questionnaire_is_refused(self, repo):
        """A read serves the canonical form only: the reach gate in front of
        the read tools checks canonical names, so a bare name would pass it."""
        with pytest.raises(QMLDocumentMissingError):
            RepositoryQMLSource(repo).read(f"{QUESTIONNAIRE_ID}.qml")

    def test_listing_returns_document_names(self, repo):
        assert RepositoryQMLSource(repo).list_names() == [
            canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)
        ]

    def test_read_within_returns_the_body_and_its_own_size_when_it_fits(self, repo):
        """Portor's inline-vs-signed-URL threshold reads this instead of
        measuring a body it is about to discard (#213), and the size it gets
        must describe the body it gets — they come from one read."""
        name = canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)
        source = RepositoryQMLSource(repo)

        probe = source.read_within(name, 1_000_000)

        assert probe.content == source.read(name)
        assert probe.size_bytes == len(probe.content.encode("utf-8"))
        assert (probe.version_id, probe.version_number) == ("v2", 2)

    def test_read_within_withholds_an_oversized_body_but_still_reports_its_size(self, repo):
        """The whole point: the caller learns it is too big without paying to
        move it, and has nothing it could accidentally inline."""
        name = canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID)

        probe = RepositoryQMLSource(repo).read_within(name, 1)

        assert probe.content is None
        assert probe.size_bytes == len(HEAD_QML.encode("utf-8"))
        assert (probe.version_id, probe.version_number) == ("v2", 2)

    def test_read_within_refuses_a_non_canonical_name(self, repo):
        with pytest.raises(QMLDocumentMissingError):
            RepositoryQMLSource(repo).read_within("demographic.qml", 1024)

    def test_read_within_of_a_documentless_questionnaire_fails_loud(self):
        """Not zero — an absent document is a miss, and reporting 0 bytes would
        inline an "empty" questionnaire instead of saying it is not there."""
        repo = _FakeRepo(questionnaire=_FakeQuestionnaire(document_id=None))

        with pytest.raises(QMLDocumentMissingError):
            RepositoryQMLSource(repo).read_within(
                canonical_qml_rel_path(PROJECT_ID, QUESTIONNAIRE_ID), 1024
            )

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
        app.register_blueprint(
            create_flow_blueprint(
                repository=repo,
                url_prefix="/api/flow",
                # The flow API needs a credential (R37); these tests are about
                # which QML VERSION is served, so they present the smallest
                # session that authorizes them.
                session_resolver=lambda: ("org-1", "org-slug", str(survey.id)),
            )
        )
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

    def test_preview_reset_picks_up_a_moved_head(self, repo):
        """#534: a preview is a walk of an instrument someone is editing.

        Its state is materialized once, so a reload keeps serving the copy
        captured at first render — Reset is what re-reads the document.
        """
        repo._head_version_id = "v1"
        client = self._client(repo, _FakeSurvey(campaign_id=None, arrival="preview"))

        first = client.get("/api/flow/current-item?survey_id=survey-1")
        assert first.get_json()["title"] == "Pinned question"

        # The designer edits the QML: head advances underneath the live preview.
        repo._head_version_id = "v2"

        # A plain reload still serves the materialized copy — deliberate, and
        # the reason Reset has to be the door.
        stale = client.get("/api/flow/current-item?survey_id=survey-1")
        assert stale.get_json()["title"] == "Pinned question"

        reset = client.post("/api/flow/reset", json={"survey_id": "survey-1"})
        assert reset.status_code == 200
        assert reset.get_json()["item"]["title"] == "Head question"

    def test_fielded_reset_keeps_the_pinned_version(self, repo):
        """The load-bearing half: a reset must NOT re-read for a real interview.

        The campaign's pin is what stops a save from changing the questions
        mid-interview, and a Reset is still inside that interview.
        """
        client = self._client(repo, _FakeSurvey(campaign_id="camp-pinned"))

        assert (
            client.get("/api/flow/current-item?survey_id=survey-1").get_json()["title"]
            == "Pinned question"
        )
        # Head is already v2 in the fixture — the pin is the only thing holding
        # this survey on v1.
        reset = client.post("/api/flow/reset", json={"survey_id": "survey-1"})

        assert reset.status_code == 200
        assert reset.get_json()["item"]["title"] == "Pinned question"

    def test_preview_reset_without_a_moved_head_still_clears_answers(self, repo):
        """Re-reading is additional to the reset, not instead of it."""
        repo._head_version_id = "v1"
        survey = _FakeSurvey(campaign_id=None, arrival="preview")
        client = self._client(repo, survey)

        client.get("/api/flow/current-item?survey_id=survey-1")
        client.post(
            "/api/flow/evaluate-item",
            json={"survey_id": "survey-1", "item_id": "q_first", "outcome": 1},
        )

        reset = client.post("/api/flow/reset", json={"survey_id": "survey-1"})

        assert reset.status_code == 200
        assert reset.get_json()["item"]["title"] == "Pinned question"
        first_item = survey.qml_state.get_item("q_first")
        assert first_item.get("outcome") is None
        assert not first_item.get("visited")
