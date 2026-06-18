#!/usr/bin/env python3
"""Unit tests for QMLDiagramIR roster block emission in the structural IR.

Pins the contract the QML Explorer React webview relies on when rendering
Roster blocks — the "↻ N" badge is driven by `labels`/`label_count` and the
iterate-over tooltip by `iterate_over`. The IR is positions-free; layout
runs client-side via ELK.js.
"""

import unittest
from pathlib import Path

from askalot_qml.core.qml_diagram_ir import QMLDiagramIR
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import QMLState

FIXTURES_DIR = Path(__file__).parent.parent.parent / "fixtures"


def _build_graph(fixture_name: str):
    loader = QMLLoader(qml_dir=FIXTURES_DIR)
    questionnaire = loader.load_from_file(fixture_name)
    state = QMLState(questionnaire)
    engine = QMLEngine(state)
    diagram = QMLDiagramIR(engine.topology, state)
    return diagram.generate_base_graph()


class TestRosterBlockEmission(unittest.TestCase):
    def test_numeric_roster_emits_roster_kind(self):
        graph = _build_graph("roster_numeric.qml")
        per_member = next(b for b in graph["blocks"] if b["id"] == "per_member")
        self.assertEqual(per_member["kind"], "Roster")
        self.assertEqual(per_member["iterate_over"], "family_mask")
        self.assertEqual(per_member["label_count"], 4)
        self.assertEqual(
            per_member["labels"], {1: "Member 1", 2: "Member 2", 4: "Member 3", 8: "Member 4"}
        )

    def test_multiselect_roster_emits_roster_kind(self):
        graph = _build_graph("roster_multiselect.qml")
        per_meal = next(b for b in graph["blocks"] if b["id"] == "per_meal")
        self.assertEqual(per_meal["kind"], "Roster")
        self.assertEqual(per_meal["iterate_over"], "q_meals_eaten.outcome")
        self.assertEqual(per_meal["label_count"], 4)

    def test_non_roster_block_keeps_group_kind(self):
        graph = _build_graph("roster_numeric.qml")
        count_block = next(b for b in graph["blocks"] if b["id"] == "count_block")
        self.assertEqual(count_block["kind"], "Group")
        self.assertNotIn("iterate_over", count_block)
        self.assertNotIn("label_count", count_block)

    def test_inner_roster_items_have_block_id(self):
        """Inner roster items still carry `block_id` for layout grouping."""
        graph = _build_graph("roster_numeric.qml")
        inner_items = [i for i in graph["items"] if i["id"] in ("q_member_name", "q_member_age")]
        self.assertEqual(len(inner_items), 2)
        for item in inner_items:
            self.assertEqual(item["block_id"], "per_member")
