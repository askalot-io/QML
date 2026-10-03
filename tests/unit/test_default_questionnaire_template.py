"""
Guard: every committed catalog questionnaire template is publish-gate valid.

Tests the templates ``askalot_common`` ships under
``askalot_common/assets/questionnaires/*.qml``:
- the new-Project starter (``starter.qml``) that every newly inserted Project
  receives, and the three samples (``SAMPLE_QUESTIONNAIRES``) that seed the
  Demo showcase and heal existing clones, are all present
- every committed template passes the publish gate with no issues
- the starter is one block holding exactly one Comment and nothing else

``Repository.create_catalog_questionnaire`` stamps each created questionnaire
``logic_validated=True`` WITHOUT re-running Z3 at request time
(``askalot_common`` must not depend on ``askalot_qml``), so that stamp is only
honest if the committed bytes actually pass the gate. This test is that
build-time guarantee: if someone edits a template — or adds a new one — into
something the gate rejects, this fails instead of every new Project silently
getting a falsely-"validated" broken questionnaire.

These are unit tests: they run the real ``evaluate_publish_gate_content`` (load
+ schema + Z3 static analysis) over each committed asset's bytes read straight
from the repo tree — no wheel, no cross-module import.
"""

from __future__ import annotations

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
