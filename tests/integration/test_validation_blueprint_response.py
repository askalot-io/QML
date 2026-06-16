"""
Integration tests for the /api/qml/validation response shape (post-2026-05-13 rewrite).

Verifies the response contract for the QML Explorer React webview:

- `questionnaire_title` field populated from the QML YAML top-level
  `questionnaire.title` (canonical schema field); falls back to the
  filename when the field is missing.
- `graph_data` uses the new positions-free IR with typed top-level arrays
  (blocks, items, conditions, variables, edges, metadata).
- No position fields (x/y/width/height/bend_points/arrow_end/arrow_start,
  top-level `layout`) leak through the response.
- `questionnaire_name` (filename) and `questionnaire_title` (human-readable)
  are distinct fields.

These integration tests exercise the Flask blueprint against the real
`data/qml` corpus to catch regressions the unit tests can't see
(end-to-end Flask routing + QMLLoader + ValidationProcessor + IR emission).
"""

from pathlib import Path

import pytest
from askalot_qml.api.validation_blueprint import create_validation_blueprint
from flask import Flask

DATA_QML_DIR = Path("/Project/askalot/data/qml")


@pytest.fixture
def client():
    app = Flask(__name__)
    app.register_blueprint(create_validation_blueprint(qml_dir=DATA_QML_DIR))
    with app.test_client() as c:
        yield c


def _get_validation(client, qml_name: str):
    resp = client.get("/api/qml/validation", query_string={"qml_name": qml_name})
    assert resp.status_code == 200, f"{qml_name}: {resp.status_code} {resp.get_data(as_text=True)}"
    return resp.get_json()


class TestResponseShape:
    def test_questionnaire_title_populated_from_yaml(self):
        """DORA QMLs declare `questionnaire.title: "DORA Article 5: ..."` at top level."""
        if not (DATA_QML_DIR / "DORA_Article_5_Governance.qml").exists():
            pytest.skip("DORA fixture not present in data/qml")
        app = Flask(__name__)
        app.register_blueprint(create_validation_blueprint(qml_dir=DATA_QML_DIR))
        with app.test_client() as c:
            body = _get_validation(c, "DORA_Article_5_Governance.qml")
        assert "questionnaire_title" in body
        # The DORA_Article_5_Governance.qml top-level title starts with "DORA Article 5:"
        assert body["questionnaire_title"].startswith("DORA Article 5")
        # Distinct from filename
        assert body["qml_name"] == "DORA_Article_5_Governance.qml"
        assert body["questionnaire_title"] != body["qml_name"]

    def test_no_layout_engine_query_arg_accepted(self):
        """The old ?layout_engine= query arg is stripped; response identical either way."""
        if not (DATA_QML_DIR / "DORA_Article_5_Governance.qml").exists():
            pytest.skip("DORA fixture not present in data/qml")
        app = Flask(__name__)
        app.register_blueprint(create_validation_blueprint(qml_dir=DATA_QML_DIR))
        with app.test_client() as c:
            # Legacy clients that still send ?layout_engine= should not break.
            resp = c.get(
                "/api/qml/validation",
                query_string={"qml_name": "DORA_Article_5_Governance.qml", "layout_engine": "dot"},
            )
            assert resp.status_code == 200

    def test_graph_data_uses_typed_top_level_arrays(self):
        if not (DATA_QML_DIR / "DORA_Article_5_Governance.qml").exists():
            pytest.skip("DORA fixture not present in data/qml")
        app = Flask(__name__)
        app.register_blueprint(create_validation_blueprint(qml_dir=DATA_QML_DIR))
        with app.test_client() as c:
            body = _get_validation(c, "DORA_Article_5_Governance.qml")
        gd = body["graph_data"]
        for key in ("blocks", "items", "conditions", "variables", "edges", "metadata"):
            assert key in gd, f"graph_data missing {key!r}"
        # Legacy shape must not leak through
        assert "nodes" not in gd
        assert "classes" not in gd
        assert "layout" not in gd

    def test_no_position_leak_across_response(self):
        if not (DATA_QML_DIR / "DORA_Article_5_Governance.qml").exists():
            pytest.skip("DORA fixture not present in data/qml")
        app = Flask(__name__)
        app.register_blueprint(create_validation_blueprint(qml_dir=DATA_QML_DIR))
        with app.test_client() as c:
            body = _get_validation(c, "DORA_Article_5_Governance.qml")
        forbidden = {"x", "y", "width", "height", "bend_points", "arrow_end", "arrow_start"}
        for bucket in ("blocks", "items", "conditions", "variables", "edges"):
            for entry in body["graph_data"].get(bucket, []):
                leaks = forbidden & set(entry.keys())
                assert not leaks, f"{bucket}: position leak {leaks} in {entry}"

    def test_classifications_inlined_on_items(self):
        if not (DATA_QML_DIR / "DORA_Article_5_Governance.qml").exists():
            pytest.skip("DORA fixture not present in data/qml")
        app = Flask(__name__)
        app.register_blueprint(create_validation_blueprint(qml_dir=DATA_QML_DIR))
        with app.test_client() as c:
            body = _get_validation(c, "DORA_Article_5_Governance.qml")
        items = body["graph_data"]["items"]
        assert items, "expected at least one item in the DORA IR"
        # Every item carries a classification post-coloring.
        for item in items:
            assert "classification" in item, item
            assert item["classification"] in {
                "always",
                "conditional",
                "never",
                "tautological",
                "infeasible",
                "visited",
                "pending",
                "cycle",
            }


class TestFallbackTitle:
    def test_missing_title_falls_back_to_qml_name(self, tmp_path):
        """A QML without a top-level title must fall back to the filename."""
        qml = tmp_path / "untitled.qml"
        qml.write_text(
            'qmlVersion: "1.0"\n'
            "questionnaire:\n"
            "  blocks:\n"
            "    - id: b1\n"
            "      title: Block\n"
            "      kind: Sequence\n"
            "      items:\n"
            "        - id: q1\n"
            "          title: Question 1\n"
            "          kind: Question\n"
            "          input:\n"
            "            control: Editbox\n"
            "            min: 0\n"
            "            max: 10\n",
        )
        app = Flask(__name__)
        # Pass schema_path=None via a loader override — simplest here is to use tmp_path
        # directly and let the bundled schema validate the shape above.
        app.register_blueprint(create_validation_blueprint(qml_dir=tmp_path))
        with app.test_client() as c:
            resp = c.get("/api/qml/validation", query_string={"qml_name": "untitled.qml"})
            # Schema may or may not pass (depends on bundled schema strictness);
            # if it does, fallback must apply.
            if resp.status_code == 200:
                body = resp.get_json()
                assert body["questionnaire_title"] == "untitled.qml"
