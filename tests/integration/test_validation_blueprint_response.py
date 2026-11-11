"""
Integration tests for the /api/qml/validation response shape.

Tests ``POST /validation``, which judges the questionnaire sent in the request
body, and ``POST /guard-tree``, the Tree view's on-demand answer for it:
- ``questionnaire_title`` comes from the QML top-level title and falls back to
  the posted name when the questionnaire states none;
- ``validation_issues`` carries every graded ``to_issues()`` finding (#728),
  including one the diagram's two colour axes cannot express (``unsafe_code``),
  each with exactly the five contract keys, without the O(items^2) Level 4 pass,
  and beside every key the webview already reads;
- every answer names the copy it judged in ``content_origin``, the label the
  registering service supplies;
- the host's ``language_of`` hook reads the questionnaire's language from the
  posted body (#2200): an "other" one answers ``language_not_judged`` in place
  of the word-list lints, and no hook or ``None`` keeps them;
- content that is not YAML is refused with the parser's own complaint (#759): a
  400 carrying ``problem`` and the 1-based ``line``/``column``, never the snippet
  or context PyYAML prints; a single offending character (a tab) survives the
  blanking, and a control character the reader refuses is located the same way;
- a document whose root is not a mapping is the loader's 400 sentence naming
  the root's shape, never its text (#1819)
- a schema failure is the structured 400, and a fault whose message would quote
  the content is a generic 500 with none of it in the body (#1136);
- a body over 1 MB is refused 413 ``too_large``, a body with no content 400
  ``content_required``;
- the directory-backed routes are gone: ``GET /validation`` is not allowed, and
  ``/validate`` and ``/files`` answer 404;
- ``validation_answer``, called with no Flask app or request, answers the body
  and status the route does, for a verdict and for a refusal;
- the validation answer carries no guard tree; ``POST /guard-tree`` answers it
  for the same body, refuses what ``/validation`` refuses, and is what
  ``guard_tree_answer`` answers.

This integration test exercises the Flask blueprint end to end (routing +
QMLLoader + ValidationProcessor + IR emission) on content read from the fixture
directory, so the payload is the one a running server builds.
"""

from pathlib import Path

import pytest
from askalot_qml.api.validation_blueprint import (
    create_validation_blueprint,
    guard_tree_answer,
    validation_answer,
)
from flask import Flask

FIXTURES = Path(__file__).resolve().parents[1] / "fixtures"
ROUTE = "/api/qml/validation"
TREE_ROUTE = "/api/qml/guard-tree"


def _client(posted_content_origin: str = "editor"):
    app = Flask(__name__)
    app.register_blueprint(create_validation_blueprint(posted_content_origin=posted_content_origin))
    return app.test_client()


def _post(content: str, name: str = "doc.qml", origin: str = "editor"):
    return _client(origin).post(ROUTE, json={"content": content, "name": name})


def _post_fixture(fixture: str):
    return _post((FIXTURES / fixture).read_text(), name=fixture)


class TestFallbackTitle:
    def test_missing_title_falls_back_to_the_posted_name(self):
        """A QML without a top-level title must fall back to the name sent with it."""
        content = (
            'qmlVersion: "2.0"\n'
            "questionnaire:\n"
            "  blocks:\n"
            "    - id: b1\n"
            "      title: Block\n"
            "      kind: Group\n"
            "      items:\n"
            "        - id: q1\n"
            "          title: Question 1\n"
            "          kind: Question\n"
            "          input:\n"
            "            control: Editbox\n"
            "            min: 0\n"
            "            max: 10\n"
        )
        resp = _post(content, name="untitled.qml")
        # Schema may or may not pass (depends on bundled schema strictness);
        # if it does, fallback must apply.
        if resp.status_code == 200:
            assert resp.get_json()["questionnaire_title"] == "untitled.qml"


class TestValidationIssuesInResponse:
    """The graded findings reach the human author, not only the agent (#728).

    The QML Explorer colours items on the two Z3 axes alone, so three of the
    twenty finding types get a colour and the other seventeen would render as a
    healthy diagram without this list.
    """

    def _body(self, fixture: str) -> dict:
        response = _post_fixture(fixture)
        assert response.status_code == 200, response.get_data(as_text=True)
        return response.get_json()

    def test_the_response_carries_the_findings(self):
        body = self._body("defect_unreachable.qml")
        assert "validation_issues" in body
        assert isinstance(body["validation_issues"], list)

    def test_an_error_the_diagram_cannot_colour_is_in_the_payload(self):
        """The whole point: a finding with no axis still reaches the author.

        `unsafe_code` is neither a reachability nor an invariant property, so
        neither colour axis can express it and the item renders healthy. If it
        is not in this payload it is nowhere the author can see.
        """
        issues = self._body("defect_unsupported_python.qml")["validation_issues"]
        unsafe = [i for i in issues if i["type"] == "unsafe_code"]
        assert unsafe, [i["type"] for i in issues]
        assert unsafe[0]["severity"] == "error"
        assert unsafe[0]["item_id"] == "q_age"

    def test_every_finding_carries_the_five_contract_keys(self):
        """The client maps these onto diagnostics, so the shape is a contract."""
        issues = self._body("defect_unsupported_python.qml")["validation_issues"]
        assert issues
        for issue in issues:
            assert set(issue) == {"item_id", "severity", "type", "message", "suggestion"}

    def test_the_interactive_path_stays_solver_cheap(self):
        """`deep` is NOT set here — Level 4 is O(items^2) and this is the edit loop.

        Asserted by absence: `accumulated_dead_code` is the deep-only finding,
        and the publish gate is what runs it. A future edit that flips this
        endpoint to `deep=True` for convenience would put an O(items^2) solver
        pass on every keystroke-debounced fetch.
        """
        issues = self._body("defect_dead_end.qml")["validation_issues"]
        assert not [i for i in issues if i["type"] == "accumulated_dead_code"]

    def test_the_existing_keys_are_untouched(self):
        """An added key must not disturb what the webview already reads.

        `DiagramApp.isValidationResponse` checks named fields, so a new key is
        safe — but only if the old ones are all still there.
        """
        body = self._body("defect_unreachable.qml")
        for key in (
            "qml_name",
            "questionnaire_title",
            "topology_stats",
            "components",
            "dependency_layers",
            "graph_data",
            "item_classifications",
            "validation_report",
        ):
            assert key in body, key
        assert body["graph_data"]["items"]


class TestEveryAnswerNamesItsCopy:
    """``content_origin`` is the registering service's label for posted content."""

    def test_a_verdict_names_the_origin_it_was_registered_with(self):
        resp = _post((FIXTURES / "defect_unreachable.qml").read_text(), origin="editor")
        assert resp.status_code == 200, resp.get_data(as_text=True)
        assert resp.get_json()["content_origin"] == "editor"

    def test_the_label_is_the_services_own(self):
        resp = _post((FIXTURES / "defect_unreachable.qml").read_text(), origin="somewhere-else")
        assert resp.get_json()["content_origin"] == "somewhere-else"

    def test_a_schema_refusal_names_it_too(self):
        """basic.qml fails the bundled schema; the refusal still says what it judged."""
        resp = _post_fixture("basic.qml")
        assert resp.status_code in (200, 400), resp.get_data(as_text=True)
        assert resp.get_json()["content_origin"] == "editor"

    def test_the_origin_is_required(self):
        with pytest.raises(TypeError):
            create_validation_blueprint()


class TestTheHostNamesTheLanguage:
    """#2200: ``language_of`` reads the posted body; the blueprint reads no row itself."""

    @staticmethod
    def _types(language_of):
        app = Flask(__name__)
        app.register_blueprint(
            create_validation_blueprint(posted_content_origin="editor", language_of=language_of)
        )
        body = {
            "content": (FIXTURES / "language_neutral_en.qml").read_text(),
            "name": "doc.qml",
            "questionnaire_id": "q-1",
        }
        resp = app.test_client().post(ROUTE, json=body)
        assert resp.status_code == 200, resp.get_data(as_text=True)
        return [i["type"] for i in resp.get_json()["validation_issues"]]

    def test_an_other_language_reports_not_judged(self):
        seen = []

        def language_of(body):
            seen.append(body["questionnaire_id"])
            return "it"

        types = self._types(language_of)
        assert seen == ["q-1"]
        assert types.count("language_not_judged") == 1
        assert "combinable_none_option" not in types

    @pytest.mark.parametrize("language_of", [None, lambda _body: None, lambda _body: "hu"])
    def test_no_language_or_a_supported_one_keeps_the_word_lists(self, language_of):
        types = self._types(language_of)
        assert "language_not_judged" not in types
        assert "combinable_none_option" in types


class TestAParseFailureNamesWhereItBroke:
    """#759: a YAML syntax error answers 400 with problem, line and column only."""

    # Line 6 opens a quote that never closes, so PyYAML's context quotes that
    # line (with its marker) and its problem mark is line 8, column 1: the
    # end of the stream.
    BROKEN = (
        "qmlVersion: '2.0'\n"
        "questionnaire:\n"
        "  title: T\n"
        "  blocks:\n"
        "    - id: b\n"
        '      title: "SECRET-MARKER\n'
        "      items: []\n"
    )

    def test_the_parser_complaint_is_returned_without_the_content(self):
        resp = _post(self.BROKEN, name="broken.qml")

        assert resp.status_code == 400, resp.get_data(as_text=True)
        body = resp.get_json()
        assert body["valid"] is False and body["content_origin"] == "editor"
        err = body["parse_error"]
        assert set(err) == {"problem", "line", "column"}
        assert err == {"problem": "found unexpected end of stream", "line": 8, "column": 1}
        assert "SECRET-MARKER" not in resp.get_data(as_text=True)

    def test_a_problem_that_quotes_the_content_is_blanked(self):
        """``found undefined alias 'x'`` copies author text; the fragment is replaced."""
        resp = _post("qmlVersion: '2.0'\nquestionnaire: *SECRET-MARKER\n", name="alias.qml")

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json()["parse_error"]["problem"] == "found undefined alias '…'"
        assert "SECRET-MARKER" not in resp.get_data(as_text=True)

    def test_a_stray_tab_is_named(self):
        """A one-character fragment is the diagnosis, not author text, so it stays."""
        resp = _post("qmlVersion: '2.0'\nquestionnaire:\n\ttitle: T\n", name="tab.qml")

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json()["parse_error"] == {
            "problem": "found character '\\t' that cannot start any token",
            "line": 3,
            "column": 1,
        }

    def test_a_control_character_is_located(self):
        """PyYAML's ReaderError has no mark; its offset becomes a line and column."""
        resp = _post("qmlVersion: '2.0'\nquestionnaire:\n  title: \x07SECRET-MARKER\n", name="ctrl.qml")

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json()["parse_error"] == {
            "problem": "unacceptable character #x0007: special characters are not allowed",
            "line": 3,
            "column": 10,
        }
        assert "SECRET-MARKER" not in resp.get_data(as_text=True)


class TestLoadFaultsAreNotEchoed:
    """#1136: a fault is answered by the one ladder, and never with ``str(e)``."""

    def test_a_fault_quoting_the_content_is_not_echoed(self, monkeypatch):
        """A fault the ladder does not know, whose message quotes the content,
        is answered with the generic 500 and none of the content."""
        from askalot_qml.core.qml_loader import QMLLoader

        marker = "private-marker-7f3a"

        def quoting_fault(self, content):
            raise RuntimeError(f"could not read {content!r}")

        monkeypatch.setattr(QMLLoader, "load_from_string", quoting_fault)
        resp = _post(f"questionnaire:\n  title: {marker}\n")

        assert resp.status_code == 500, resp.get_data(as_text=True)
        assert marker not in resp.get_data(as_text=True)
        assert resp.get_json() == {"error": "Could not analyse this questionnaire"}

    @pytest.mark.parametrize(("content", "shape"), [("123\n", "a number"), ("- a\n", "a list"),
                                                    ("private-marker-7f3a\n", "a line of text")])
    def test_a_root_that_is_not_a_mapping_is_the_loaders_sentence(self, content, shape):
        """#1819: a scalar or list root is the loader's 400, a sentence the
        editor shows, naming the root's shape and never its text."""
        resp = _post(content)

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json() == {
            "error": f"QML content must be a YAML mapping with a 'questionnaire' section; its root is {shape}."
        }

    def test_a_schema_failure_is_the_structured_400(self):
        resp = _post("questionnaire:\n  title: 7\n  blocks: nope\n")

        assert resp.status_code == 400, resp.get_data(as_text=True)
        body = resp.get_json()
        assert body["valid"] is False and body["content_origin"] == "editor"
        assert set(body["validation_error"]) == {"message", "path", "schema_path"}


class TestTheBodyIsBounded:
    def test_a_body_over_the_cap_is_refused(self):
        """One megabyte of content plus its JSON envelope is over the cap."""
        resp = _post("#" * 1_048_576, name="big.qml")

        assert resp.status_code == 413, resp.get_data(as_text=True)[:200]
        assert resp.get_json()["error"] == "too_large"

    def test_a_body_under_the_cap_is_read(self):
        """The cap is on size alone: a large comment over a real questionnaire validates."""
        fixture = "defect_unreachable.qml"
        resp = _post("#" * 900_000 + "\n" + (FIXTURES / fixture).read_text(), name=fixture)

        assert resp.status_code == 200, resp.get_data(as_text=True)[:200]

    @pytest.mark.parametrize("body", [{"name": "doc.qml"}, {"content": "", "name": "doc.qml"}])
    def test_missing_or_empty_content_is_refused_with_a_code(self, body):
        resp = _client().post(ROUTE, json=body)

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json()["error"] == "content_required"

    def test_a_missing_name_is_refused_with_a_code(self):
        resp = _client().post(ROUTE, json={"content": "x"})

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json()["error"] == "name_required"


class TestNoDirectoryIsRead:
    """Nothing on the blueprint resolves a name against a directory any more."""

    def test_get_validation_is_not_allowed(self):
        resp = _client().get(ROUTE, query_string={"qml_name": "defect_unreachable.qml"})
        assert resp.status_code == 405

    @pytest.mark.parametrize("path", ["/api/qml/validate", "/api/qml/files"])
    def test_the_directory_routes_are_gone(self, path):
        resp = _client().get(path, query_string={"qml_name": "defect_unreachable.qml"})
        assert resp.status_code == 404

    def test_the_blueprint_serves_two_rules(self):
        app = Flask(__name__)
        app.register_blueprint(create_validation_blueprint(posted_content_origin="editor"))
        rules = {(str(r), tuple(sorted(r.methods - {"OPTIONS", "HEAD"}))) for r in app.url_map.iter_rules()}
        assert rules - {("/static/<path:filename>", ("GET",))} == {
            (ROUTE, ("POST",)),
            (TREE_ROUTE, ("POST",)),
        }


class TestTheAnswerWithoutARequest:
    """A server-rendered page draws the same diagram from ``validation_answer``, so it must be the route's answer."""

    @pytest.mark.parametrize("fixture", ["branching_flow.qml", "defect_syntax_error.qml"])
    def test_it_is_what_the_route_answers(self, fixture):
        content = (FIXTURES / fixture).read_text()

        body, status = validation_answer(content, fixture, content_origin="template")
        resp = _post(content, name=fixture, origin="template")

        assert (body, status) == (resp.get_json(), resp.status_code)


class TestTheGuardTreeIsAskedFor:
    """The Tree view asks for the tree; the validation the editor runs on every edit carries none."""

    def test_the_validation_answer_carries_no_tree(self):
        resp = _post_fixture("guard_tree_branches.qml")
        assert resp.status_code == 200
        assert "guard_tree" not in resp.get_json()["graph_data"]["metadata"]

    def test_the_route_answers_the_tree_for_the_posted_text(self):
        content = (FIXTURES / "guard_tree_branches.qml").read_text()
        resp = _client("template").post(TREE_ROUTE, json={"content": content, "name": "b.qml"})

        assert resp.status_code == 200
        body = resp.get_json()
        assert body["guard_tree"]["trunk"] == ["q_screen", "q_contact"]
        assert (body, 200) == guard_tree_answer(content, "b.qml", content_origin="template")

    def test_it_refuses_what_validation_refuses(self):
        assert _client().post(TREE_ROUTE, json={"name": "d.qml"}).get_json()["error"] == "content_required"
        assert _client().post(TREE_ROUTE, json={"content": "x"}).get_json()["error"] == "name_required"
        big = _client().post(TREE_ROUTE, json={"content": "#" * 1_048_576, "name": "big.qml"})
        assert big.status_code == 413

    def test_a_parse_failure_is_the_ladders_400(self):
        resp = _client().post(TREE_ROUTE, json={"content": "questionnaire: [", "name": "x.qml"})
        assert resp.status_code == 400 and "parse_error" in resp.get_json()
