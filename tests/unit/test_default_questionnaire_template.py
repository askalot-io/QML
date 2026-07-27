"""
Guard: every committed sample-questionnaire template is publish-gate valid.

The starter samples that new-user registration materializes into every default
(ACME) project — ``askalot_common.defaults.SAMPLE_QUESTIONNAIRES`` — ship as
committed assets in ``askalot_common``
(``askalot_common/assets/questionnaires/*.qml``). Registration stamps the
resulting rows ``logic_validated=True`` WITHOUT re-running Z3 at request time
(``askalot_common`` must not depend on ``askalot_qml``), so that stamp is only
honest if the committed bytes actually pass the gate. This test is that
build-time guarantee: if someone edits a template — or adds a new one — into
something the gate rejects, this fails instead of every new user silently
getting a falsely-"validated" broken sample.

These are unit tests: they run the real ``evaluate_publish_gate_content`` (load
+ schema + Z3 static analysis) over each committed asset's bytes read straight
from the repo tree — no wheel, no cross-module import.
"""

from __future__ import annotations

from pathlib import Path

import pytest
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
    assert templates, "no committed .qml sample templates found"
    return templates


@pytest.mark.unit
class TestSampleQuestionnaireTemplates:
    def test_assets_dir_has_known_templates(self):
        # The three known starter samples all ship as committed assets.
        names = {p.name for p in _committed_templates()}
        assert {
            "all-controls.qml",
            "demographics.qml",
            "family-food-consumption.qml",
        } <= names

    @pytest.mark.parametrize(
        "template", _committed_templates(), ids=lambda p: p.name
    )
    def test_template_passes_publish_gate(self, template: Path):
        result = evaluate_publish_gate_content(
            template.read_text(encoding="utf-8"), source_label=template.name
        )
        assert result.ok, (
            f"committed sample template {template.name!r} fails the publish gate; "
            "registration would stamp logic_validated=True falsely. issues="
            f"{result.issues}"
        )
        assert result.issues == []
