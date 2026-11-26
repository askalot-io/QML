"""
The flow API's fixed sentences render in the chrome locale the walk's questionnaire decides.

Tests the respondent-facing messages of ``create_flow_blueprint``:
- "Survey completed" is Hungarian for a survey whose questionnaire is ``hu``
- the same message is English for an ``en`` questionnaire, whatever the browser asks for
- "Cannot navigate to this item" is Hungarian for a ``hu`` survey and English for an ``en`` one
- the browser's language never overrides a known walk's questionnaire language
- a walk in an "other" language (``it``) speaks the browser's supported
  language, the respondent's preferred language before it, and English on an
  interviewer-assisted survey, whose browser is the interviewer's; a launched
  preview (``field_interview`` mode, no interviewer) still follows the browser
- the refusal's error code and the engine's own reason are not what is translated
- any askalot_qml import registers the catalog, not only the flow API's (a
  service rendering an askalot_qml word through its own template, #2137)
- every engine word a page shows (warning types, grading reasons, issue types)
  has a msgid with a Hungarian translation, and every issue type the validator
  can emit and every warning type the flow engine records has a label (#2166)
- every issue type the item inventory raises (they are raised outside the
  validator's files) has a label in each supported language
- every warning the flow engine records stores a catalog msgid and its
  variables, and reads in the page's language, or as its stored English when
  it has none (#2177); ``add_warning`` takes only a singular ``Sentence`` with
  plain variables (a ``Paragraph``, alone or nested, is refused too), and nothing in the package calls it but the engine's
  ``_warning`` (#2191)
- a sandbox refusal's reason (``reason``, the one slot that may nest a
  Sentence) is stored as its msgid, so a refused condition or codeBlock reads
  wholly in the page's language, its named construct too, while ``message``
  stays the same English; a reason stored as text before that still reads (#2194)
- a flow endpoint that fails on an exception quoting an answer logs the
  endpoint, the survey, the exception's class and where it was raised, never
  its text; no logging call in the flow API or runtime formats an exception or
  logs a traceback, read off the syntax tree (#2193)
- every one of the ten endpoints answers such a failure with
  ``flow_failed`` and a fixed sentence in the walk's language, never the
  text (#2198); a failing session resolver in the ``before_request`` hook is
  answered the same way and leaves no text or traceback in any log, while an
  HTTP error (a resolver's 403, routing's 404 / 405, a malformed body's 400)
  keeps its status and headers, and an ``abort(response)`` its response (#2199)

These integration tests drive the real blueprint over Flask's test client with a
fake repository holding the survey, its questionnaire (with its ``language``) and
the QML document, because the locale is resolved inside the endpoint from the
walk it read; a unit test of ``gettext`` could not see which language the
endpoint chose. The Hungarian expectations need the askalot_qml catalog filled.
"""

import subprocess
import sys

import pytest
from askalot_qml.api import create_flow_blueprint
from flask import Flask

_QML = """
qmlVersion: "2.2"
questionnaire:
  title: Locale
  blocks:
    - id: main
      kind: Group
      items:
        - id: q1
          kind: Question
          title: Do you smoke?
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q2
          kind: Question
          title: How many a day?
          precondition:
            - predicate: q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 100
"""

#: Nothing to ask: the only item's gate reads a codeInit constant that holds it
#: shut, so the first presentation completes the walk.
_QML_NOTHING_TO_ASK = """
qmlVersion: "2.2"
questionnaire:
  title: Locale
  codeInit: |
    closed = 1
  blocks:
    - id: main
      kind: Group
      items:
        - id: q1
          kind: Question
          title: Do you smoke?
          precondition:
            - predicate: closed == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
"""

SURVEY_ID = "aaaaaaaa-1111-1111-1111-111111111111"


class _Version:
    def __init__(self, content):
        self.content = content


class _Survey:
    def __init__(self):
        self.id = SURVEY_ID
        self.questionnaire_id = "q-1"
        self.respondent_id = "r-1"
        self.campaign_id = "camp-1"
        self.interviewer_user_id = None
        self.status = "in_progress"
        self.qml_state = {}
        self.current_block_id = None
        self.current_item_id = None
        self.mode = "direct"
        self.language = None


class _Repo:
    """One fielding survey whose questionnaire is in ``language``; writes are kept."""

    def __init__(self, language, qml, *, preferred=None, mode="direct", interviewer_user_id=None):
        self.qml = qml
        self.survey = _Survey()
        self.survey.mode = mode
        self.survey.interviewer_user_id = interviewer_user_id
        self.respondent = type("R", (), {"id": "r-1", "preferred_language": preferred})()
        self.questionnaire = type(
            "Q", (), {"id": "q-1", "name": "Locale", "document_id": "doc-1", "language": language}
        )()

    def get_survey(self, survey_id):
        return self.survey if survey_id == SURVEY_ID else None

    def get_respondent(self, respondent_id):
        return self.respondent if respondent_id == "r-1" else None

    def get_questionnaire(self, questionnaire_id, include_deleted=False):
        return self.questionnaire if questionnaire_id == "q-1" else None

    def get_campaign(self, campaign_id):
        return type("C", (), {"id": campaign_id, "status": "active", "qml_version_id": None})()

    def get_document_content(self, document_id, *, version_id=None):
        return _Version(self.qml) if document_id == "doc-1" else None

    def save_survey_walk(self, survey):
        self.survey = survey
        return survey.id


def _bound_session():
    return ("org-1", "org-slug", SURVEY_ID)


def _client(language, qml=_QML, *, session_resolver=_bound_session, **survey):
    app = Flask(__name__)
    app.register_blueprint(
        create_flow_blueprint(
            repository=_Repo(language, qml, **survey),
            url_prefix="/api/flow",
            session_resolver=session_resolver,
        )
    )
    return app.test_client()


@pytest.fixture(autouse=True)
def _clean_context():
    from askalot_common.repository import clear_organization_context

    clear_organization_context()
    yield
    clear_organization_context()


def _complete(language, accept_language, **survey):
    """Present a walk with nothing to ask: the presentation completes it."""
    client = _client(language, _QML_NOTHING_TO_ASK, **survey)
    return client.get(
        f"/api/flow/current-item?survey_id={SURVEY_ID}",
        headers={"Accept-Language": accept_language},
    )


def _navigate_ahead(client, accept_language):
    """Jump to q2 before q1 is answered: the engine refuses it."""
    headers = {"Accept-Language": accept_language}
    first = client.get(f"/api/flow/current-item?survey_id={SURVEY_ID}", headers=headers)
    assert first.status_code == 200
    return client.post(
        "/api/flow/navigate-to-item",
        json={"survey_id": SURVEY_ID, "target_item_id": "q2"},
        headers=headers,
    )


@pytest.mark.integration
@pytest.mark.flow
class TestSurveyCompleted:
    def test_a_hungarian_survey_says_so_in_hungarian(self):
        resp = _complete("hu", accept_language="en")

        body = resp.get_json()
        assert body["justCompleted"] is True
        assert body["message"] == "A kérdőív kitöltése befejeződött"

    @pytest.mark.parametrize("language", ["es", "fr", "de"])
    def test_every_tier_one_survey_says_so_in_its_language(self, language):
        from askalot_common.i18n import gettext

        resp = _complete(language, accept_language="en")

        message = resp.get_json()["message"]
        assert message == gettext(language, "Survey completed")
        assert message != "Survey completed"

    def test_an_english_survey_says_so_in_english_whatever_the_browser_asks(self):
        resp = _complete("en", accept_language="hu")

        assert resp.get_json()["message"] == "Survey completed"


@pytest.mark.integration
@pytest.mark.flow
class TestAnOtherLanguageWalk:
    """``it`` is no supported locale, so the sentences take a chrome locale of their own."""

    def test_the_browsers_supported_language_is_the_chrome(self):
        resp = _complete("it", accept_language="de-CH, en;q=0.5")

        assert resp.get_json()["message"] == "Umfrage abgeschlossen"

    def test_the_respondents_preferred_language_comes_before_the_browser(self):
        resp = _complete("it", accept_language="de", preferred="hu")

        assert resp.get_json()["message"] == "A kérdőív kitöltése befejeződött"

    def test_an_interviewers_browser_is_never_asked(self):
        resp = _complete("it", accept_language="de", mode="field_interview", interviewer_user_id="u-1")

        assert resp.get_json()["message"] == "Survey completed"

    def test_a_launched_preview_follows_the_researchers_browser(self):
        """``DTO_PreviewRun.mode`` is ``field_interview`` once launched, with no interviewer."""
        resp = _complete("it", accept_language="de", mode="field_interview")

        assert resp.get_json()["message"] == "Umfrage abgeschlossen"

    def test_a_refusal_speaks_the_chrome_too(self):
        resp = _navigate_ahead(_client("it"), accept_language="hu")

        assert resp.status_code == 400
        assert resp.get_json()["error"] == "Ehhez a kérdéshez most nem lehet ugrani"


@pytest.mark.integration
@pytest.mark.flow
class TestCannotNavigate:
    def test_a_hungarian_survey_refuses_in_hungarian(self):
        resp = _navigate_ahead(_client("hu"), accept_language="en")

        assert resp.status_code == 400
        assert resp.get_json()["error"] == "Ehhez a kérdéshez most nem lehet ugrani"

    def test_an_english_survey_refuses_in_english(self):
        resp = _navigate_ahead(_client("en"), accept_language="hu")

        assert resp.status_code == 400
        assert resp.get_json()["error"] == "Cannot navigate to this item"


#: Every flow endpoint, with a request that reaches its ``prepare_walk``: each
#: catches an unexpected failure in its own ``except Exception``.
_ENDPOINTS = [
    ("get", f"/api/flow/current-item?survey_id={SURVEY_ID}", None, "current_item"),
    (
        "post",
        "/api/flow/evaluate-item",
        {"survey_id": SURVEY_ID, "item_id": "q1", "response": "Jane"},
        "evaluate_item",
    ),
    ("post", "/api/flow/choose-language", {"survey_id": SURVEY_ID, "language": "de"}, "choose_language"),
    ("get", f"/api/flow/previous-item?survey_id={SURVEY_ID}", None, "previous_item"),
    ("get", f"/api/flow/stepper?survey_id={SURVEY_ID}", None, "stepper"),
    ("get", f"/api/flow/navigation-path?survey_id={SURVEY_ID}", None, "navigation_path"),
    ("post", "/api/flow/navigate-to-item", {"survey_id": SURVEY_ID, "target_item_id": "q2"}, "navigate_to_item"),
    ("post", "/api/flow/reset", {"survey_id": SURVEY_ID}, "reset"),
    ("post", "/api/flow/finish", {"survey_id": SURVEY_ID}, "finish"),
    ("post", "/api/flow/resume", {"survey_id": SURVEY_ID}, "resume"),
]

_FAILED_EN = "Something went wrong on our side. Please try again in a moment."
_FAILED_HU = "Valami hiba történt nálunk. Kérjük, próbálja újra egy kis idő múlva."


def _send(client, method, path, body, headers=None):
    if method == "get":
        return client.get(path, headers=headers)
    return client.post(path, json=body, headers=headers)


def _fail_on_the_answer(monkeypatch):
    from askalot_qml.api import flow_service

    def fails_on_the_answer(walk):
        raise ValueError("invalid literal for int() with base 10: 'Jane'")

    monkeypatch.setattr(flow_service, "prepare_walk", fails_on_the_answer)


def _assert_logged_nothing_of(caplog, text):
    """No record of any logger (Flask's app logger included) holds *text* or a traceback."""
    for record in caplog.records:
        assert text not in record.getMessage(), record.name
        assert not record.exc_info, f"{record.name} logged a traceback"
    assert text not in caplog.text
    assert "Traceback" not in caplog.text


@pytest.mark.integration
@pytest.mark.flow
class TestAFailureLogsNoAnswer:
    """#2193: an exception's text can quote what the respondent typed, and Loki
    cannot be scrubbed, so a failing endpoint logs its class and the survey.
    #2198: the answer is a fixed sentence in the walk's language, never the
    text. #2199: a failure in the ``before_request`` hook is answered and
    logged the same way, not by Flask's default handler."""

    @pytest.mark.parametrize(("method", "path", "body", "action"), _ENDPOINTS)
    def test_the_log_names_the_class_never_the_text(self, monkeypatch, caplog, method, path, body, action):
        _fail_on_the_answer(monkeypatch)
        with caplog.at_level("DEBUG"):
            resp = _send(_client("en"), method, path, body)

        assert resp.status_code == 500
        _assert_logged_nothing_of(caplog, "Jane")
        logged = "\n".join(record.getMessage() for record in caplog.records)
        assert (
            f"flow.{action}_failed survey_ids={SURVEY_ID} error=ValueError"
            " at=test_flow_messages_locale.py:"
        ) in logged

    @pytest.mark.parametrize(("language", "expected"), [("en", _FAILED_EN), ("hu", _FAILED_HU)])
    @pytest.mark.parametrize(("method", "path", "body", "action"), _ENDPOINTS)
    def test_the_answer_is_a_fixed_sentence_in_the_walks_language(
        self, monkeypatch, method, path, body, action, language, expected
    ):
        """The browser asks for the other language: the walk's questionnaire decides."""
        _fail_on_the_answer(monkeypatch)
        browser = "hu" if language == "en" else "en"
        resp = _send(_client(language), method, path, body, headers={"Accept-Language": browser})

        assert resp.status_code == 500
        assert "Jane" not in resp.get_data(as_text=True)
        assert resp.get_json() == {"error": "flow_failed", "message": expected}

    def test_a_failing_session_resolver_is_answered_and_logged_without_its_text(self, caplog):
        """The hook runs before any endpoint's ``except``; unhandled, Flask's
        default handler would log the text with a traceback and answer HTML."""

        def resolver_fails():
            raise RuntimeError("session row for Jane could not be decoded")

        client = _client("en", session_resolver=resolver_fails)
        with caplog.at_level("DEBUG"):
            resp = client.get(
                f"/api/flow/current-item?survey_id={SURVEY_ID}", headers={"Accept-Language": "hu"}
            )

        assert resp.status_code == 500
        # No walk was read, so the browser's language decides.
        assert resp.get_json() == {"error": "flow_failed", "message": _FAILED_HU}
        _assert_logged_nothing_of(caplog, "Jane")
        assert f"survey_ids={SURVEY_ID} error=RuntimeError" in caplog.text

    def test_an_http_error_keeps_its_own_status(self, caplog):
        """A resolver that refuses with an HTTP error (and routing's 404 / 405)
        keeps its status, never re-dressed as a 500, and its description, which
        may quote caller text, never reaches the body."""
        from werkzeug.exceptions import BadRequest

        def resolver_refuses():
            raise BadRequest(description="Invalid answer: Jane")

        refused = _client("en", session_resolver=resolver_refuses).get(
            f"/api/flow/current-item?survey_id={SURVEY_ID}"
        )
        assert refused.status_code == 400
        assert refused.get_json() == {"error": "bad_request"}
        assert b"Jane" not in refused.data
        client = _client("en")
        assert client.get("/api/flow/no-such-endpoint").status_code == 404
        assert client.get("/api/flow/evaluate-item").status_code == 405
        # A malformed body is the caller's fault, inside an endpoint too.
        malformed = client.post(
            "/api/flow/evaluate-item", data="{not json", content_type="application/json"
        )
        assert malformed.status_code == 400
        assert malformed.get_json() == {"error": "bad_request"}
        assert "flow_failed" not in caplog.text

    def test_an_http_error_keeps_its_headers_and_a_built_response(self):
        """Its headers are protocol (a 401's ``WWW-Authenticate``), and an
        ``abort(response)`` (the capability gate's 402) is answered as built."""
        from flask import abort, jsonify, make_response
        from werkzeug.datastructures import WWWAuthenticate
        from werkzeug.exceptions import Unauthorized

        def resolver_challenges():
            raise Unauthorized(www_authenticate=WWWAuthenticate("Bearer"))

        challenged = _client("en", session_resolver=resolver_challenges).get(
            f"/api/flow/current-item?survey_id={SURVEY_ID}"
        )
        assert challenged.status_code == 401
        assert challenged.get_json() == {"error": "unauthorized"}
        assert challenged.headers["WWW-Authenticate"] == "Bearer"

        def resolver_gates():
            abort(make_response(jsonify({"error": "payment_required"}), 402))

        gated = _client("en", session_resolver=resolver_gates).get(
            f"/api/flow/current-item?survey_id={SURVEY_ID}"
        )
        assert gated.status_code == 402
        assert gated.get_json() == {"error": "payment_required"}

    def test_a_survey_id_that_is_not_a_uuid_is_not_logged(self, monkeypatch, caplog):
        """The id field is caller text too: anything but a UUID reads ``<invalid>``."""
        from askalot_qml.api import flow_service
        from askalot_qml.api.flow_blueprint import _loggable_id

        def fails(walk):
            raise ValueError("boom")

        monkeypatch.setattr(flow_service, "prepare_walk", fails)
        with caplog.at_level("DEBUG"):
            _client("en").post(
                "/api/flow/evaluate-item",
                json={"survey_id": SURVEY_ID, "item_id": "q1", "response": 1},
            )
        assert f"survey_ids={SURVEY_ID} " in caplog.text
        assert _loggable_id("Jane\nflow.finish_failed survey_ids=x") == "<invalid>"
        assert _loggable_id(SURVEY_ID) == SURVEY_ID

    def test_no_flow_log_call_formats_an_exception(self):
        """Every handler, not only the two driven above, and the engine the walk
        runs: no logging call in the flow API or the flow runtime passes an
        ``except``-bound name anywhere in its arguments (an f-string, ``%s``,
        ``repr``, ``str``, an attribute) other than as ``type(name)``, and none
        logs a traceback (``.exception`` or a truthy ``exc_info``). Read off the
        syntax tree, so the receiver's spelling (``logger``, ``self.logger``,
        ``logging.getLogger(...)``) and nested parentheses cannot hide a call."""
        import ast
        from pathlib import Path

        import askalot_qml

        methods = {"debug", "info", "warning", "error", "critical", "exception", "log"}
        root = Path(askalot_qml.__file__).parent
        for name in (
            "api/flow_blueprint.py",
            "api/flow_service.py",
            "core/flow_processor.py",
            "core/python_runner.py",
            "models/qml_state.py",
        ):
            tree = ast.parse((root / name).read_text(encoding="utf-8"))
            bound = {h.name for h in ast.walk(tree) if isinstance(h, ast.ExceptHandler) and h.name}
            for call in ast.walk(tree):
                func = call.func if isinstance(call, ast.Call) else None
                if not (
                    isinstance(func, ast.Attribute)
                    and func.attr in methods
                    and "log" in ast.unparse(func.value).lower()
                ):
                    continue
                where = f"{name}:{call.lineno}"
                assert func.attr != "exception", where
                for keyword in call.keywords:
                    if keyword.arg == "exc_info":
                        assert isinstance(keyword.value, ast.Constant), where
                        assert not keyword.value.value, where
                as_class = {
                    id(node.args[0])
                    for node in ast.walk(call)
                    if isinstance(node, ast.Call)
                    and isinstance(node.func, ast.Name)
                    and node.func.id == "type"
                    and node.args
                }
                for node in ast.walk(call):
                    if isinstance(node, ast.Name) and node.id in bound:
                        assert id(node) in as_class, f"{where} formats {node.id}"


class TestTheCatalogRegistersOnAnyImport:
    def test_importing_another_submodule_registers_the_catalog(self):
        """Run in a fresh interpreter: this module's own import of the flow API
        would mask a catalog only that import registers."""
        script = (
            "import askalot_qml.core; from askalot_common.i18n import gettext; "
            "print(gettext('hu', 'Survey completed'))"
        )
        out = subprocess.run(
            [sys.executable, "-c", script], capture_output=True, text=True, check=True
        )
        assert out.stdout.strip().splitlines()[-1] == "A kérdőív kitöltése befejeződött"


def _hungarian(msgid: str) -> str:
    from askalot_common.i18n import gettext

    return gettext("hu", msgid)


class TestEngineWordsAreTranslated:
    """The engine's words a page shows are catalog msgids, read in the page's language (#2166)."""

    @pytest.mark.parametrize("vocabulary", ["warning types", "grading reasons", "issue types"])
    def test_every_label_has_a_hungarian_translation(self, vocabulary):
        from askalot_qml.core.publish_gate import ISSUE_TYPE_LABELS
        from askalot_qml.core.quality_metrics import UNGRADED_REASON_SENTENCES
        from askalot_qml.models import WARNING_TYPE_LABELS

        labels = {
            "warning types": WARNING_TYPE_LABELS,
            "grading reasons": UNGRADED_REASON_SENTENCES,
            "issue types": ISSUE_TYPE_LABELS,
        }[vocabulary]
        untranslated = sorted(code for code, msgid in labels.items() if _hungarian(msgid) == msgid)
        assert untranslated == []

    def test_every_issue_type_the_validator_emits_has_a_label(self):
        """Read off the source, so a new lint cannot reach a page as a bare code."""
        import re
        from pathlib import Path

        import askalot_qml
        from askalot_qml.core.publish_gate import ISSUE_TYPE_LABELS

        root = Path(askalot_qml.__file__).parent
        emitted = set()
        for name in ("core/validation_processor.py", "core/publish_gate.py"):
            source = (root / name).read_text(encoding="utf-8")
            emitted |= set(re.findall(r'"type": "([a-z_]+)"', source))
            emitted |= set(re.findall(r'_load_failure\(\s*"([a-z_]+)"', source))
        assert emitted, "the pattern found no issue types: the source moved"
        assert sorted(emitted - set(ISSUE_TYPE_LABELS)) == []

    @pytest.mark.parametrize("locale", ["es", "fr", "de", "hu"])
    def test_every_inventory_issue_type_has_a_label_in_each_language(self, locale):
        """The inventory's issue types are raised outside the validator's two
        files, so they are named here and read off their own source."""
        import re
        from pathlib import Path

        import askalot_qml
        from askalot_common.i18n import gettext
        from askalot_qml.core.publish_gate import ISSUE_TYPE_LABELS, issue_type_label

        types = {
            "item_without_entry",
            "entry_without_item",
            "intent_missing",
            "rows_changed",
            "unknown_kpi",
            "no_inventory",
        }
        source = (Path(askalot_qml.__file__).parent / "inventory/warnings.py").read_text(
            encoding="utf-8"
        )
        raised = set(re.findall(r'_issue\(\s*[^,()]+,\s*"([a-z_]+)"', source))
        assert raised == types, "the inventory raises other issue types than the ones named here"
        assert sorted(types - set(ISSUE_TYPE_LABELS)) == []
        untranslated = sorted(
            code for code in types if gettext(locale, ISSUE_TYPE_LABELS[code]) == ISSUE_TYPE_LABELS[code]
        )
        assert untranslated == []
        assert issue_type_label(locale, "no_inventory") != issue_type_label("en", "no_inventory")

    def test_every_warning_type_the_engine_records_has_a_label(self):
        """Read off the source: ``add_warning`` raises on an unlabelled type, and
        it runs inside a respondent's walk, so a missing label must fail here."""
        import re
        from pathlib import Path

        import askalot_qml
        from askalot_qml.core.flow_processor import _UNEVALUATABLE_CONDITION_POLICY
        from askalot_qml.models import WARNING_TYPE_LABELS

        source = (Path(askalot_qml.__file__).parent / "core/flow_processor.py").read_text(
            encoding="utf-8"
        )
        recorded = set(re.findall(r'_warning\(\s*[^,()]+,\s*[^,()]+,\s*"([a-z_]+)"', source))
        recorded |= {
            f"external_prefill_{gate}"
            for gate in re.findall(
                r'_warn_prefill_declined\(\s*questionnaire_state,\s*item_id,\s*"([a-z_]+)"', source
            )
        }
        suffixes = set(re.findall(r'f"\{condition_type\}_([a-z_]+)"', source))
        recorded |= {
            f"{kind}_{suffix}" if suffix else kind
            for kind in _UNEVALUATABLE_CONDITION_POLICY
            for suffix in suffixes | {""}
        }
        assert {"codeblock", "item_missing", "roster_iterate_over"} <= recorded, (
            "the pattern found too few warning types: the source moved"
        )
        assert suffixes, "the pattern found no condition-type warnings: the source moved"
        assert "external_prefill_domain" in recorded, "the prefill pattern found nothing"
        assert sorted(recorded - set(WARNING_TYPE_LABELS)) == []

    def test_every_warning_the_engine_records_has_a_catalog_msgid(self):
        """Every msgid ``flow_processor`` records is a module message constant
        (``_..._MESSAGE`` / ``_..._MESSAGES``), and each is in the askalot_qml
        catalog, so a page can translate the detail (#2177). A ``_warning`` call
        names such a constant or a local ``msgid`` chosen from them."""
        import re
        from pathlib import Path

        import askalot_qml
        from askalot_qml.core import flow_processor
        from babel.messages.pofile import read_po

        package = Path(askalot_qml.__file__).parent
        source = (package / "core/flow_processor.py").read_text(encoding="utf-8")
        constants = {
            name for name in vars(flow_processor) if re.fullmatch(r"_[A-Z_]+_MESSAGES?", name)
        }
        calls = re.findall(r"(?<![\w.])(?<!def )_warning\(\s*[^,()]+,\s*[^,()]+,\s*[^,()]+,\s*([A-Za-z_]+)", source)
        assert len(calls) >= 5, "the pattern found too few _warning calls: the source moved"
        assert set(calls) - {"msgid"} <= constants
        # Each local `msgid` is assigned from one of the constants.
        assigned = re.findall(r"\bmsgid(?:, facts)? = (_[A-Z_]+)", source)
        assert assigned and set(assigned) <= constants
        msgids = set()
        for name in constants:
            value = getattr(flow_processor, name)
            msgids |= set(value.values()) if isinstance(value, dict) else {value}
        with (package / "translations/hu/LC_MESSAGES/messages.po").open("rb") as catalog:
            in_catalog = {message.id for message in read_po(catalog) if message.id}
        assert sorted(msgids - in_catalog) == []

    def test_only_the_engines_warning_helper_calls_add_warning(self):
        """A writer that bypassed ``_warning`` would still have to pass a
        Sentence, but the one call site keeps the msgid scan above complete."""
        import re
        from pathlib import Path

        import askalot_qml

        package = Path(askalot_qml.__file__).parent
        callers = {
            str(path.relative_to(package))
            for path in package.rglob("*.py")
            if re.search(r"\.add_warning\(", path.read_text(encoding="utf-8"))
        }
        assert callers == {"core/flow_processor.py"}
        source = (package / "core/flow_processor.py").read_text(encoding="utf-8")
        assert len(re.findall(r"\.add_warning\(", source)) == 1

    def test_a_plain_string_message_is_refused(self):
        from askalot_qml.models import QMLState

        state = QMLState({"items": [{"id": "q1", "kind": "Question"}], "blocks": [], "history": []})
        with pytest.raises(TypeError, match="Sentence"):
            state.add_warning("q1", "item_missing", "Item q1 not found", severity="degraded")

    def test_a_stored_warning_reads_in_the_readers_language_when_it_names_its_msgid(self):
        from askalot_common.i18n import Sentence
        from askalot_qml.models import QMLState, warning_message_text

        state = QMLState({"items": [{"id": "q1", "kind": "Question"}], "blocks": [], "history": []})
        msgid = "Item %(item)s not found in questionnaire state"
        state.add_warning("q1", "item_missing", Sentence(msgid, item="q1"), severity="degraded")
        [warning] = state.get_warnings()
        assert warning["message"] == "Item q1 not found in questionnaire state"
        assert warning["message_msgid"] == msgid
        assert warning["message_vars"] == {"item": "q1"}
        assert warning_message_text(warning, "en") == warning["message"]
        from askalot_common.i18n import gettext

        hungarian = warning_message_text(warning, "hu")
        assert hungarian == gettext("hu", msgid, item="q1") != warning["message"]
        # A warning stored before the msgid existed reads as its English text.
        legacy = {k: v for k, v in warning.items() if not k.startswith("message_")}
        assert warning_message_text(legacy, "hu") == warning["message"]

    def test_a_counted_or_nested_sentence_is_refused(self):
        """Only the msgid and JSON variables are stored, so a counted form or a
        nested Sentence could not be rebuilt by ``warning_message_text``."""
        from askalot_common.i18n import Sentence, counted_sentence, paragraph
        from askalot_qml.models import QMLState

        state = QMLState({"items": [{"id": "q1", "kind": "Question"}], "blocks": [], "history": []})
        counted = counted_sentence("%(num)d item missing", "%(num)d items missing", 2)
        with pytest.raises(TypeError, match="singular Sentence"):
            state.add_warning("q1", "item_missing", counted, severity="degraded")
        nested = Sentence("Item %(item)s not found", item=Sentence("q1"))
        with pytest.raises(TypeError, match="singular Sentence"):
            state.add_warning("q1", "item_missing", nested, severity="degraded")
        in_paragraph = Sentence("Item %(item)s not found", item=paragraph(Sentence("q1")))
        with pytest.raises(TypeError, match="singular Sentence"):
            state.add_warning("q1", "item_missing", in_paragraph, severity="degraded")
        # ``reason`` may nest a Sentence (#2194), but not one that cannot be rebuilt.
        for reason in (counted, paragraph(Sentence("q1"))):
            refused = Sentence("Item %(item)s refused (%(reason)s)", item="q1", reason=reason)
            with pytest.raises(TypeError, match="singular Sentence"):
                state.add_warning("q1", "item_missing", refused, severity="degraded")
        with pytest.raises(TypeError, match="takes a Sentence"):
            state.add_warning("q1", "item_missing", paragraph(Sentence("q1")), severity="degraded")
        assert state.get_warnings() == []

    def test_a_refused_conditions_reason_reads_in_the_readers_language(self):
        """#2194: the sandbox's refusal is a Sentence, stored as its msgid, so a
        Hungarian page shows no English clause; ``message`` stays the English
        text it always was, and the stored warning is JSON."""
        import json

        from askalot_common.i18n import gettext
        from askalot_qml.core.flow_processor import _REFUSED_CONDITION_MESSAGES, _warning
        from askalot_qml.core.python_runner import CodeRefused, PythonRunner
        from askalot_qml.models import QMLState, warning_message_text

        expr = "q1.outcome.__class__ == 1"
        with pytest.raises(CodeRefused) as refused:
            PythonRunner().eval_expr(expr, q1=None)
        state = QMLState({"items": [{"id": "q1", "kind": "Question"}], "blocks": [], "history": []})
        msgid = _REFUSED_CONDITION_MESSAGES["precondition"]
        _warning(state, "q1", "precondition", msgid, severity="degraded", expr=expr, reason=refused.value.reason)
        [warning] = json.loads(json.dumps(state.get_warnings()))

        assert warning["message"] == (
            "Precondition 'q1.outcome.__class__ == 1' was refused (Access to disallowed "
            "attribute: __class__), so it never ran. Treating it as unsatisfied (the gated "
            "item is skipped)."
        )
        assert warning["message_vars"]["reason"] == {
            "msgid": "Access to disallowed attribute: %(attr)s",
            "vars": {"attr": "__class__"},
        }
        assert warning_message_text(warning, "en") == warning["message"]
        hungarian = warning_message_text(warning, "hu")
        assert "Nem engedélyezett attribútum elérése: __class__" in hungarian
        assert hungarian == gettext(
            "hu", msgid, expr=expr, reason="Nem engedélyezett attribútum elérése: __class__"
        )
        assert "disallowed" not in hungarian

    def test_a_refusal_naming_a_construct_translates_both(self):
        """The whole-number refusal names its construct in words, a Sentence
        inside the reason: both levels are stored and both translate."""
        import json

        from askalot_common.i18n import Sentence
        from askalot_qml.core.flow_processor import _CODEBLOCK_REFUSED_MESSAGE
        from askalot_qml.core.python_runner import PythonRunner
        from askalot_qml.models import QMLState, warning_message_text

        reason = PythonRunner().validate_code("x = q1.outcome * 1.5")
        state = QMLState({"items": [{"id": "q1", "kind": "Question"}], "blocks": [], "history": []})
        state.add_warning(
            "q1", "codeblock", Sentence(_CODEBLOCK_REFUSED_MESSAGE, reason=reason), severity="critical"
        )
        [warning] = json.loads(json.dumps(state.get_warnings()))

        assert "the number 1.5 can produce a fraction; use '//'" in warning["message"]
        hungarian = warning_message_text(warning, "hu")
        assert "A QML csak egész számokkal számol: a(z) 1.5 szám törtet adhat" in hungarian
        assert "the number" not in hungarian and "whole numbers" not in hungarian

    def test_a_parse_failure_is_refused_by_line_or_by_class(self):
        """A syntax error names its line; one with no line (a NUL byte) names
        its class, never "line None"."""
        from askalot_qml.core.python_runner import SYNTAX_ERROR_MSGID, PythonRunner

        runner = PythonRunner()
        unclosed = runner.validate_code("x = (")
        assert unclosed.msgid == SYNTAX_ERROR_MSGID
        assert unclosed.variables == {"line": 1}
        nul = runner.validate_code("x = 1\x00")
        assert nul == "Validation error (SyntaxError)"
        assert "None" not in runner.validate_expr("1\x00")

    def test_a_reason_stored_as_text_reads_as_it_did(self):
        """A refusal warning written before #2194 holds its reason as English
        text: the sentence around it translates, the reason reads as stored."""
        from askalot_common.i18n import gettext
        from askalot_qml.core.flow_processor import _REFUSED_CONDITION_MESSAGES
        from askalot_qml.models import warning_message_text

        msgid = _REFUSED_CONDITION_MESSAGES["postcondition"]
        variables = {"expr": "import_ok", "reason": "Disallowed node type: Import"}
        stored = {
            "type": "postcondition",
            "message": msgid % variables,
            "message_msgid": msgid,
            "message_vars": variables,
        }
        assert warning_message_text(stored, "hu") == gettext("hu", msgid, **variables)
        assert warning_message_text(stored, "en") == stored["message"]

    def test_a_warning_type_with_no_label_is_refused(self):
        from askalot_common.i18n import Sentence
        from askalot_qml.models import QMLState

        state = QMLState({"items": [{"id": "q1", "kind": "Question"}], "blocks": [], "history": []})
        with pytest.raises(ValueError, match="WARNING_TYPE_LABELS"):
            state.add_warning("q1", "made_up_kind", Sentence("boom"), severity="degraded")

    def test_a_stored_type_that_has_no_label_reads_as_itself(self):
        from askalot_qml.models import warning_type_label

        assert warning_type_label("hu", "retired_kind") == "retired_kind"
        assert warning_type_label("hu", "codeblock") == _hungarian("Code block error")


class TestTheSandboxStatesTheOneWholeNumberFix:
    def test_the_refusal_quotes_the_fix_the_loader_and_runtime_give(self):
        """The sandbox's refusal msgid writes the fix out (a catalog needs a
        literal), so it is held equal to ``WHOLE_NUMBER_FIX`` here: an edit to
        one cannot leave one refusal reading two ways."""
        from askalot_qml.core.python_runner import WHOLE_NUMBER_FIX, PythonRunner

        refusal = PythonRunner().validate_expr("a / 2")
        assert refusal is not None and str(refusal).endswith(WHOLE_NUMBER_FIX)
