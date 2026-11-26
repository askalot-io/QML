"""
Guard: every committed catalog questionnaire template is publish-gate valid.

Tests the templates ``askalot_common`` ships under
``askalot_common/assets/questionnaires/``:
- the new-Project starter (``starter.qml``) that every newly inserted Project
  receives, and the three samples (``SAMPLE_QUESTIONNAIRES``) that seed the
  Demo showcase and heal existing clones, are all present
- every committed template passes the publish gate with no issues
- the starter is one block holding exactly one Comment and nothing else
- the questionnaire template library, built from ``content/templates/`` by
  ``scripts/dev/template_library.py`` into a temporary directory: every file of
  every declared language (the English source and each language's
  materialized copy) passes the publish gate with the English template's issue
  set, which is none, and the library is not empty

``Repository.create_catalog_questionnaire`` stamps each created questionnaire
``logic_validated=True`` WITHOUT re-running Z3 at request time
(``askalot_common`` must not depend on ``askalot_qml``), so that stamp is only
honest if the committed bytes actually pass the gate. This test is that
build-time guarantee: if someone edits a template — or adds a new one — into
something the gate rejects, this fails instead of every new Project silently
getting a falsely-"validated" broken questionnaire.

These are unit tests: they run the real ``evaluate_publish_gate_content`` (load
+ schema + Z3 static analysis) over each committed asset's bytes read straight
from the repo tree, and over the built library the consumers read (a copy is
stored without re-running Z3, so its language must keep the English verdict) —
no wheel, no cross-module import.
"""

from __future__ import annotations

import json
import subprocess
import sys
from functools import cache
from pathlib import Path

import pytest
import yaml
from askalot_qml.core import evaluate_publish_gate_content


def _assets_dir() -> Path:
    """Resolve the committed questionnaire-assets directory inside the monorepo.

    Walks up from this test file to the ``shared/modules`` ancestor rather than
    hard-coding a ``parents[N]`` depth, so moving the test file does not silently
    break the resolution into a skip.
    """
    here = Path(__file__).resolve()
    for ancestor in here.parents:
        candidate = (
            ancestor
            / "askalot_common"
            / "askalot_common"
            / "assets"
            / "questionnaires"
        )
        if candidate.is_dir():
            return candidate
    raise FileNotFoundError(
        "committed questionnaire-assets dir not found walking up from "
        f"{here} — did the assets move?"
    )


def _repo_root() -> Path:
    """Resolve the monorepo root (the directory holding ``content/templates/``), walking up."""
    here = Path(__file__).resolve()
    for ancestor in here.parents:
        if (ancestor / "content" / "templates" / "index.json").is_file():
            return ancestor
    raise FileNotFoundError(f"content/templates/ not found walking up from {here}")


def _library_files() -> list[tuple[str, str]]:
    """Every (language, asset) the build writes: each declared language times each indexed template."""
    source = _repo_root() / "content" / "templates"
    languages = json.loads((source / "languages.json").read_text(encoding="utf-8"))
    assets = [t["asset"] for t in json.loads((source / "index.json").read_text(encoding="utf-8"))["templates"]]
    assert assets, "the questionnaire template library's index names no template"
    return [(language, asset) for language in languages for asset in assets]


@pytest.fixture(scope="session")
def built_library(tmp_path_factory) -> Path:
    """The library as consumers read it, built once by the library's own build step."""
    out = tmp_path_factory.mktemp("template-library") / "library"
    script = _repo_root() / "scripts" / "dev" / "template_library.py"
    result = subprocess.run(
        [sys.executable, str(script), "--out", str(out)], capture_output=True, text=True, check=False
    )
    assert result.returncode == 0, f"the template library does not build:\n{result.stdout}{result.stderr}"
    return out


@cache
def _gate_issues(path: Path) -> tuple:
    result = evaluate_publish_gate_content(path.read_text(encoding="utf-8"), source_label=path.name)
    assert result.ok, f"library template {path} fails the publish gate: {result.issues}"
    return tuple(result.issues)


def _committed_templates() -> list[Path]:
    templates = sorted(_assets_dir().glob("*.qml"))
    assert templates, "no committed .qml catalog templates found"
    return templates


@pytest.mark.unit
class TestSampleQuestionnaireTemplates:
    def test_assets_dir_has_known_templates(self):
        # The starter and the three samples all ship as committed assets.
        names = {p.name for p in _committed_templates()}
        assert {
            "starter.qml",
            "all-controls.qml",
            "demographics.qml",
            "family-food-consumption.qml",
        } <= names

    def test_the_starter_is_one_block_holding_one_comment(self):
        body = yaml.safe_load((_assets_dir() / "starter.qml").read_text(encoding="utf-8"))
        [block] = body["questionnaire"]["blocks"]
        [item] = block["items"]
        assert item["kind"] == "Comment"
        assert item["title"].strip()

    @pytest.mark.parametrize(
        "template", _committed_templates(), ids=lambda p: p.name
    )
    def test_template_passes_publish_gate(self, template: Path):
        result = evaluate_publish_gate_content(
            template.read_text(encoding="utf-8"), source_label=template.name
        )
        assert result.ok, (
            f"committed catalog template {template.name!r} fails the publish gate; "
            "create_catalog_questionnaire would stamp logic_validated=True falsely. issues="
            f"{result.issues}"
        )
        assert result.issues == []


@pytest.mark.unit
class TestQuestionnaireTemplateLibrary:
    """A questionnaire created from a library template is stamped publish-valid
    without re-running Z3 at request time, so each built file must pass, in
    every language with the English template's verdict."""

    @pytest.mark.parametrize(
        ("language", "asset"), _library_files(), ids=lambda value: value
    )
    def test_built_template_passes_publish_gate_with_the_english_issues(
        self, built_library: Path, language: str, asset: str
    ):
        english = _gate_issues(built_library / "en" / asset)
        assert english == (), f"library template en/{asset} has publish-gate issues: {english}"
        assert _gate_issues(built_library / language / asset) == english
