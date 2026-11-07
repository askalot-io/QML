"""
The flow API's fixed sentences render in the language of the walk's questionnaire.

Tests the respondent-facing messages of ``create_flow_blueprint``:
- "Survey completed" is Hungarian for a survey whose questionnaire is ``hu``
- the same message is English for an ``en`` questionnaire, whatever the browser asks for
- "Cannot navigate to this item" is Hungarian for a ``hu`` survey and English for an ``en`` one
- the browser's language never overrides a known walk's questionnaire language
- the refusal's error code and the engine's own reason are not what is translated
- any askalot_qml import registers the catalog, not only the flow API's (a
  service rendering an askalot_qml word through its own template, #2137)
- every engine word a page shows (warning types, grading reasons, issue types)
  has a msgid with a Hungarian translation, and every issue type the validator
  can emit and every warning type the flow engine records has a label (#2166)
- every warning the flow engine records stores a catalog msgid and its
  variables, and reads in the page's language, or as its stored English when
  it has none (#2177); ``add_warning`` takes only a singular ``Sentence`` with
  plain variables (a ``Paragraph``, alone or nested, is refused too), and nothing in the package calls it but the engine's
  ``_warning`` (#2191)
- a flow endpoint that fails on an exception quoting an answer logs the
  endpoint, the survey, the exception's class and where it was raised, never
  its text; no logging call in the flow API or runtime formats an exception or
  logs a traceback, read off the syntax tree (#2193)

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

    def __init__(self, language, qml):
        self.qml = qml
        self.survey = _Survey()
        self.questionnaire = type(
            "Q", (), {"id": "q-1", "name": "Locale", "document_id": "doc-1", "language": language}
        )()

    def get_survey(self, survey_id):
        return self.survey if survey_id == SURVEY_ID else None

    def get_questionnaire(self, questionnaire_id, include_deleted=False):
        return self.questionnaire if questionnaire_id == "q-1" else None

    def get_campaign(self, campaign_id):
        return type("C", (), {"id": campaign_id, "status": "active", "qml_version_id": None})()

    def get_document_content(self, document_id, *, version_id=None):
        return _Version(self.qml) if document_id == "doc-1" else None

    def save_survey_walk(self, survey):
        self.survey = survey
        return survey.id


def _client(language, qml=_QML):
    app = Flask(__name__)
    app.register_blueprint(
        create_flow_blueprint(
            repository=_Repo(language, qml),
            url_prefix="/api/flow",
            session_resolver=lambda: ("org-1", "org-slug", SURVEY_ID),
        )
    )
    return app.test_client()


@pytest.fixture(autouse=True)
def _clean_context():
    from askalot_common.repository import clear_organization_context

    clear_organization_context()
    yield
    clear_organization_context()


def _complete(language, accept_language):
    """Present a walk with nothing to ask: the presentation completes it."""
    client = _client(language, _QML_NOTHING_TO_ASK)
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
class TestCannotNavigate:
    def test_a_hungarian_survey_refuses_in_hungarian(self):
        resp = _navigate_ahead(_client("hu"), accept_language="en")

        assert resp.status_code == 400
        assert resp.get_json()["error"] == "Ehhez a kérdéshez most nem lehet ugrani"

    def test_an_english_survey_refuses_in_english(self):
        resp = _navigate_ahead(_client("en"), accept_language="hu")

        assert resp.status_code == 400
        assert resp.get_json()["error"] == "Cannot navigate to this item"


@pytest.mark.integration
@pytest.mark.flow
class TestAFailureLogsNoAnswer:
    """#2193: an exception's text can quote what the respondent typed, and Loki
    cannot be scrubbed, so a failing endpoint logs its class and the survey."""

    @pytest.mark.parametrize(
        ("method", "path", "body", "action"),
        [
            ("get", f"/api/flow/current-item?survey_id={SURVEY_ID}", None, "current_item"),
            ("post", "/api/flow/evaluate-item", {"survey_id": SURVEY_ID, "item_id": "q1", "response": "Jane"}, "evaluate_item"),
        ],
    )
    def test_the_log_names_the_class_never_the_text(self, monkeypatch, caplog, method, path, body, action):
        from askalot_qml.api import flow_service

        def fails_on_the_answer(walk):
            raise ValueError("invalid literal for int() with base 10: 'Jane'")

        monkeypatch.setattr(flow_service, "prepare_walk", fails_on_the_answer)
        client = _client("en")
        with caplog.at_level("DEBUG"):
            resp = client.get(path) if method == "get" else client.post(path, json=body)

        assert resp.status_code == 500
        logged = "\n".join(record.getMessage() for record in caplog.records)
        assert "Jane" not in logged
        assert (
            f"flow.{action}_failed survey_ids={SURVEY_ID} error=ValueError"
            " at=test_flow_messages_locale.py:"
        ) in logged

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
        with pytest.raises(TypeError, match="takes a Sentence"):
            state.add_warning("q1", "item_missing", paragraph(Sentence("q1")), severity="degraded")
        assert state.get_warnings() == []

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
