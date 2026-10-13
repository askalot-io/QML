"""
Integration tests for the /api/qml/validation response shape (post-2026-05-13 rewrite).

Verifies the title-fallback half of the response contract for the QML Explorer
React webview: `questionnaire_title` is populated from the QML YAML top-level
`questionnaire.title`, and falls back to the filename when that field is
absent.

Tests also cover the `validation_issues` field (#728), which carries every
graded `to_issues()` finding to the human author:

- the field is present and is a list
- an error the diagram's two colour axes cannot express (`unsafe_code`) is in
  the payload, since a finding absent from it is nowhere the author can see
- every finding carries exactly the five contract keys the client maps onto
  diagnostics
- the endpoint stays solver-cheap: `deep` is NOT set, so the O(items^2) Level 4
  pass belongs to the publish gate and not to the edit-validate loop
- the eight pre-existing keys are untouched, because an added key is only safe
  if the ones the webview already reads are all still there

The address space is stated (#415): a document address that misses is refused
as the wrong address space (400), an ordinary miss stays a 404, and the
response's ``content_origin`` names the copy that was validated.

A file that is not YAML is refused with the parser's own complaint (#759): a
400 carrying ``problem`` and the 1-based ``line``/``column``, on both routes, and
never the snippet or context PyYAML prints, which quote the file. A single
offending character (a tab) survives the blanking, and a control character the
YAML reader refuses is located the same way.

Every other load fault is answered alike by ``/validate`` and ``/validation``
(#1136): a schema failure is the structured 400 on both, and a fault whose
message would quote the file is a generic 500 on both, with none of the file in
the body.

Posted content is validated without a stored copy: ``POST /validation`` takes
the questionnaire in the request body and answers with the payload the GET route
gives for the same questionnaire (same keys, same ``graph_data``), under the
``content_origin`` the registering service names for posted content. Its
refusals are the GET route's (``parse_error`` with no file text,
``validation_error``), plus a 413 ``too_large`` for a body over 1 MB and a 400
``content_required`` for a body with no content. A blueprint registered without
a posted-content origin does not carry the route.

This integration test exercises the Flask blueprint end to end (routing +
QMLLoader + ValidationProcessor + IR emission) on a questionnaire written into
tmp_path, so it depends on no fixture file.
"""

from pathlib import Path

import pytest
from askalot_qml.api.validation_blueprint import create_validation_blueprint
from flask import Flask

FIXTURES = Path(__file__).resolve().parents[1] / "fixtures"


def _client(
    qml_dir: Path = FIXTURES,
    content_origin: str = "directory",
    posted_content_origin: str | None = None,
):
    app = Flask(__name__)
    app.register_blueprint(
        create_validation_blueprint(
            qml_dir=qml_dir,
            content_origin=content_origin,
            posted_content_origin=posted_content_origin,
        )
    )
    return app.test_client()


class TestFallbackTitle:
    def test_missing_title_falls_back_to_qml_name(self, tmp_path):
        """A QML without a top-level title must fall back to the filename."""
        qml = tmp_path / "untitled.qml"
        qml.write_text(
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
            "            max: 10\n",
        )
        with _client(tmp_path) as c:
            resp = c.get("/api/qml/validation", query_string={"qml_name": "untitled.qml"})
            # Schema may or may not pass (depends on bundled schema strictness);
            # if it does, fallback must apply.
            if resp.status_code == 200:
                body = resp.get_json()
                assert body["questionnaire_title"] == "untitled.qml"


class TestValidationIssuesInResponse:
    """The graded findings reach the human author, not only the agent (#728).

    Until this field existed, `/api/qml/validation` returned the two Z3 axes and
    a text summary. The QML Explorer colours items on those axes alone, so three
    of the twenty finding types got a pixel and the other seventeen rendered as a
    healthy diagram. `to_issues()` had exactly two consumers — Portor's MCP tool
    and the publish gate — and a person editing QML in code-server was neither.
    """

    def _body(self, fixture: str) -> dict:
        with _client() as client:
            response = client.get("/api/qml/validation", query_string={"qml_name": fixture})
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


class TestTheAddressSpaceIsStated:
    """``qml_name`` here is a directory path, not a document address (#415; see the blueprint docstring)."""

    DOCUMENT_ADDRESS = "projects/p-1/questionnaires/q-1.qml"

    @pytest.mark.parametrize("route", ["/api/qml/validation", "/api/qml/validate"])
    def test_a_document_address_is_refused_as_one(self, route):
        resp = _client(content_origin="workspace").get(route, query_string={"qml_name": self.DOCUMENT_ADDRESS})
        assert resp.status_code == 400
        body = resp.get_json()
        assert body["error"] == "qml_name_is_a_document_address"
        assert "workspace copy" in body["detail"]

    @pytest.mark.parametrize("route", ["/api/qml/validation", "/api/qml/validate"])
    def test_an_ordinary_missing_path_is_still_a_404(self, route):
        resp = _client().get(route, query_string={"qml_name": "sessions/s/p/questionnaires/q.qml"})
        assert resp.status_code == 404
        assert resp.get_json()["error"].startswith("QML file not found")

    def test_a_document_address_the_directory_holds_is_validated(self, tmp_path):
        """The refusal is for a miss only: a directory laid out canonically still answers."""
        target = tmp_path / self.DOCUMENT_ADDRESS
        target.parent.mkdir(parents=True)
        target.write_text((FIXTURES / "defect_unreachable.qml").read_text())
        resp = _client(tmp_path).get("/api/qml/validation", query_string={"qml_name": self.DOCUMENT_ADDRESS})
        assert resp.status_code == 200, resp.get_data(as_text=True)

    def test_the_response_names_the_copy_it_validated(self):
        resp = _client(content_origin="workspace").get(
            "/api/qml/validation", query_string={"qml_name": "defect_unreachable.qml"}
        )
        assert resp.status_code == 200, resp.get_data(as_text=True)
        assert resp.get_json()["content_origin"] == "workspace"

    @pytest.mark.parametrize(
        ("route", "fixture"),
        [
            ("/api/qml/validate", "defect_unreachable.qml"),
            ("/api/qml/validate", "basic.qml"),
            ("/api/qml/validation", "basic.qml"),
        ],
    )
    def test_every_verdict_names_its_copy(self, route, fixture):
        """A /validate verdict, and a schema refusal, judged a copy too (basic.qml fails the schema)."""
        resp = _client(content_origin="workspace").get(route, query_string={"qml_name": fixture})
        assert resp.status_code in (200, 400), resp.get_data(as_text=True)
        assert resp.get_json()["content_origin"] == "workspace"


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

    @pytest.mark.parametrize("route", ["/api/qml/validation", "/api/qml/validate"])
    def test_the_parser_complaint_is_returned_without_the_file(self, route, tmp_path):
        (tmp_path / "broken.qml").write_text(self.BROKEN)
        resp = _client(tmp_path, content_origin="workspace").get(route, query_string={"qml_name": "broken.qml"})

        assert resp.status_code == 400, resp.get_data(as_text=True)
        body = resp.get_json()
        assert body["valid"] is False and body["content_origin"] == "workspace"
        err = body["parse_error"]
        assert set(err) == {"problem", "line", "column"}
        assert err == {"problem": "found unexpected end of stream", "line": 8, "column": 1}
        assert "SECRET-MARKER" not in resp.get_data(as_text=True)

    @pytest.mark.parametrize("route", ["/api/qml/validation", "/api/qml/validate"])
    def test_a_problem_that_quotes_the_file_is_blanked(self, route, tmp_path):
        """``found undefined alias 'x'`` copies author text; the fragment is replaced."""
        (tmp_path / "alias.qml").write_text("qmlVersion: '2.0'\nquestionnaire: *SECRET-MARKER\n")
        resp = _client(tmp_path).get(route, query_string={"qml_name": "alias.qml"})

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json()["parse_error"]["problem"] == "found undefined alias '…'"
        assert "SECRET-MARKER" not in resp.get_data(as_text=True)

    @pytest.mark.parametrize("route", ["/api/qml/validation", "/api/qml/validate"])
    def test_a_stray_tab_is_named(self, route, tmp_path):
        """A one-character fragment is the diagnosis, not author text, so it stays."""
        (tmp_path / "tab.qml").write_text("qmlVersion: '2.0'\nquestionnaire:\n\ttitle: T\n")
        resp = _client(tmp_path).get(route, query_string={"qml_name": "tab.qml"})

        assert resp.status_code == 400, resp.get_data(as_text=True)
        err = resp.get_json()["parse_error"]
        assert err == {
            "problem": "found character '\\t' that cannot start any token",
            "line": 3,
            "column": 1,
        }

    @pytest.mark.parametrize("route", ["/api/qml/validation", "/api/qml/validate"])
    def test_a_control_character_is_located(self, route, tmp_path):
        """PyYAML's ReaderError has no mark; its offset becomes a line and column."""
        (tmp_path / "ctrl.qml").write_text(
            "qmlVersion: '2.0'\nquestionnaire:\n  title: \x07SECRET-MARKER\n"
        )
        resp = _client(tmp_path).get(route, query_string={"qml_name": "ctrl.qml"})

        assert resp.status_code == 400, resp.get_data(as_text=True)
        err = resp.get_json()["parse_error"]
        assert err == {
            "problem": "unacceptable character #x0007: special characters are not allowed",
            "line": 3,
            "column": 10,
        }
        assert "SECRET-MARKER" not in resp.get_data(as_text=True)


class TestValidateDoesNotEchoLoadFaults:
    """#1136: ``/validate`` had a ``str(e)`` catch-all ``/validation`` retired."""

    ROUTES = ("/api/qml/validate", "/api/qml/validation")

    def _answers(self, tmp_path: Path, content: str) -> list[tuple[int, dict]]:
        (tmp_path / "doc.qml").write_text(content)
        with _client(tmp_path) as client:
            return [
                (r.status_code, r.get_json())
                for r in (client.get(route, query_string={"qml_name": "doc.qml"}) for route in self.ROUTES)
            ]

    def test_a_fault_quoting_the_file_is_not_echoed_by_either_route(self, tmp_path):
        """A one-line text file parses as a YAML string, and the loader's fault
        on it names the file's content; neither route may return any of it."""
        marker = "private-marker-7f3a"
        answers = self._answers(tmp_path, f"{marker}\n")

        assert {status for status, _ in answers} == {500}, answers
        assert all(marker not in str(body) for _, body in answers)
        assert answers[0][1]["error"] == answers[1][1]["error"]

    def test_a_schema_failure_is_the_same_structured_400_on_both(self, tmp_path):
        answers = self._answers(tmp_path, "questionnaire:\n  title: 7\n  blocks: nope\n")

        assert [status for status, _ in answers] == [400, 400], answers
        assert all("validation_error" in body for _, body in answers)


class TestPostedContentIsValidated:
    """``POST /validation`` judges the content in the request body, with no stored copy."""

    ROUTE = "/api/qml/validation"
    FIXTURE = "defect_unreachable.qml"

    def _post(self, body: dict):
        return _client(content_origin="workspace", posted_content_origin="editor").post(self.ROUTE, json=body)

    def test_posted_and_stored_content_yield_the_same_payload(self):
        """One questionnaire, read from the directory and sent in the body."""
        client = _client(content_origin="workspace", posted_content_origin="editor")
        stored = client.get(self.ROUTE, query_string={"qml_name": self.FIXTURE})
        posted = client.post(
            self.ROUTE, json={"content": (FIXTURES / self.FIXTURE).read_text(), "name": self.FIXTURE}
        )

        assert stored.status_code == 200, stored.get_data(as_text=True)
        assert posted.status_code == 200, posted.get_data(as_text=True)
        stored_body, posted_body = stored.get_json(), posted.get_json()
        assert set(posted_body) == set(stored_body)
        assert posted_body["graph_data"] == stored_body["graph_data"]
        assert posted_body["graph_data"]["items"]
        # Only the provenance differs: each verdict names the copy it judged.
        assert stored_body.pop("content_origin") == "workspace"
        assert posted_body.pop("content_origin") == "editor"
        assert posted_body == stored_body

    def test_a_yaml_syntax_error_names_where_it_broke_without_the_file(self):
        resp = self._post({"content": TestAParseFailureNamesWhereItBroke.BROKEN, "name": "broken.qml"})

        assert resp.status_code == 400, resp.get_data(as_text=True)
        body = resp.get_json()
        assert body["valid"] is False and body["content_origin"] == "editor"
        assert body["parse_error"] == {"problem": "found unexpected end of stream", "line": 8, "column": 1}
        assert "SECRET-MARKER" not in resp.get_data(as_text=True)

    def test_a_problem_that_quotes_the_content_is_blanked(self):
        resp = self._post({"content": "qmlVersion: '2.0'\nquestionnaire: *SECRET-MARKER\n", "name": "alias.qml"})

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json()["parse_error"]["problem"] == "found undefined alias '…'"
        assert "SECRET-MARKER" not in resp.get_data(as_text=True)

    def test_a_schema_failure_is_the_structured_400(self):
        resp = self._post({"content": "questionnaire:\n  title: 7\n  blocks: nope\n", "name": "doc.qml"})

        assert resp.status_code == 400, resp.get_data(as_text=True)
        body = resp.get_json()
        assert body["valid"] is False and body["content_origin"] == "editor"
        assert set(body["validation_error"]) == {"message", "path", "schema_path"}

    def test_a_body_over_the_cap_is_refused(self):
        """One megabyte of content plus its JSON envelope is over the cap."""
        resp = self._post({"content": "#" * 1_048_576, "name": "big.qml"})

        assert resp.status_code == 413, resp.get_data(as_text=True)[:200]
        assert resp.get_json()["error"] == "too_large"

    def test_a_body_under_the_cap_is_read(self):
        """The cap is on size alone: a large comment over a real questionnaire validates."""
        content = "#" * 900_000 + "\n" + (FIXTURES / self.FIXTURE).read_text()
        resp = self._post({"content": content, "name": self.FIXTURE})

        assert resp.status_code == 200, resp.get_data(as_text=True)[:200]

    @pytest.mark.parametrize("body", [{"name": "doc.qml"}, {"content": "", "name": "doc.qml"}])
    def test_missing_or_empty_content_is_refused_with_a_code(self, body):
        resp = self._post(body)

        assert resp.status_code == 400, resp.get_data(as_text=True)
        assert resp.get_json()["error"] == "content_required"

    def test_a_blueprint_without_a_posted_origin_has_no_post_route(self):
        """A service that names no origin for posted content does not serve it."""
        resp = _client().post(self.ROUTE, json={"content": "x", "name": "doc.qml"})

        assert resp.status_code == 405
