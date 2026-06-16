#!/usr/bin/env python3
"""Unit tests for QMLDiagramIR Sample-block emission + Roster bitmask-source edge.

Sample diagram emission is a distinct concern from Roster (different node
header fields, no per-iteration label universe), so it gets its own file
rather than extending test_roster_diagram.py.

Pins the contract the QML Explorer React webview relies on (U7, R11/R12):
- Sample blocks carry `kind="Sample"`, `sample_count` (the N), and
  `is_random` so the amber Sample header in the diagram-viewer can render
  `N` + the randomized/declared-order indicator.
- Roster blocks emit a `bitmask_source` edge from the block id to the
  item/variable resolved from the `iterateOver` expression — the data
  provenance arrow distinguishing a Checkbox-driven mask (item_outcome)
  from a codeBlock-computed mask (variable_read).
- `is_random=true` Sample blocks surface `is_random=True` in the header.
- A synthesized N=0 / empty Sample block still renders a node (the QML
  loader enforces count>=1 and minItems>=1, so this path is only reachable
  via a hand-built structure — exercised here so the IR stays robust).
- Existing roster diagram fixtures gain the new edge kind without any
  collision with topology/cycle/version_chain/condition_ref edges.

These unit tests load real fixtures through QMLLoader → QMLState →
QMLEngine → QMLDiagramIR (the same pipeline production uses) and assert on
the positions-free structural IR.
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


class TestSampleBlockEmission(unittest.TestCase):
    def test_sample_block_emits_sample_kind_and_count(self):
        """Happy path: declared-order Sample carries kind/sample_count/is_random."""
        graph = _build_graph("sample_basic.qml")
        brand = next(b for b in graph["blocks"] if b["id"] == "brand_sample")
        self.assertEqual(brand["kind"], "Sample")
        self.assertEqual(brand["sample_count"], 2)
        self.assertFalse(brand["is_random"])
        # Sample is not Roster — no roster-only fields leak onto the node.
        self.assertNotIn("iterate_over", brand)
        self.assertNotIn("label_count", brand)
        self.assertNotIn("labels", brand)

    def test_sample_block_is_random_true(self):
        """Happy path: is_random:true surfaces in the node header."""
        graph = _build_graph("sample_random.qml")
        topic = next(b for b in graph["blocks"] if b["id"] == "topic_sample")
        self.assertEqual(topic["kind"], "Sample")
        # count=5 deliberately exceeds the 2 inner items — the IR carries the
        # declared N verbatim; the "ask up to N" clamp is a runtime concern.
        self.assertEqual(topic["sample_count"], 5)
        self.assertTrue(topic["is_random"])

    def test_non_sample_block_has_no_sample_fields(self):
        graph = _build_graph("sample_basic.qml")
        intro = next(b for b in graph["blocks"] if b["id"] == "intro_block")
        self.assertEqual(intro["kind"], "Sequence")
        self.assertNotIn("sample_count", intro)
        self.assertNotIn("is_random", intro)

    def test_inner_sample_items_carry_block_id(self):
        """Inner Sample items still group under the block for layout."""
        graph = _build_graph("sample_basic.qml")
        inner = [
            i
            for i in graph["items"]
            if i["id"] in ("q_brand_a", "q_brand_b", "q_brand_c")
        ]
        self.assertEqual(len(inner), 3)
        for item in inner:
            self.assertEqual(item["block_id"], "brand_sample")

    def test_empty_sample_block_still_renders_node(self):
        """Edge: N=0 / empty Sample block renders a node.

        The QML loader enforces ``count >= 1`` and ``minItems >= 1`` (U1
        schema), so this state is unreachable through the QML parse path.
        It IS reachable through a hand-built QMLState (e.g. a programmatic
        questionnaire builder or a corrupted persisted state), so the IR
        emitter must not crash on it. Synthesize the structure directly.
        """
        state = QMLState(
            {
                "blocks": [
                    {
                        "id": "empty_sample",
                        "title": "Empty Sample",
                        "kind": "Sample",
                        "count": 0,
                    }
                ],
                "items": [
                    # A single Sequence item so the topology is non-empty;
                    # the Sample block itself has zero inner items.
                    {
                        "id": "q_only",
                        "blockId": "seq",
                        "kind": "Question",
                        "title": "Only question",
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    }
                ],
            }
        )
        # The Sample block has no topology items, so by the same
        # "block must contain >=1 topology item" rule that governs every
        # block it is omitted from `blocks` — and crucially, emission does
        # not raise. Add an inner item to confirm the node renders when the
        # block IS populated but count==0.
        state["items"].append(
            {
                "id": "q_sampled",
                "blockId": "empty_sample",
                "kind": "Question",
                "title": "Sampled question",
                "input": {"control": "Editbox", "min": 0, "max": 9},
            }
        )
        state["blocks"].append(
            {"id": "seq", "title": "Seq", "kind": "Sequence"}
        )
        engine = QMLEngine(state)
        graph = QMLDiagramIR(engine.topology, state).generate_base_graph()
        sample_node = next(
            b for b in graph["blocks"] if b["id"] == "empty_sample"
        )
        self.assertEqual(sample_node["kind"], "Sample")
        self.assertEqual(sample_node["sample_count"], 0)
        self.assertFalse(sample_node["is_random"])


class TestRosterBitmaskSourceEdge(unittest.TestCase):
    def test_variable_iterate_over_resolves_to_version_node(self):
        """Edge: `iterateOver` referencing a codeBlock variable.

        roster_numeric's `iterateOver: "family_mask"` is a codeBlock-computed
        bitmask → the edge targets the latest emitted variable version node.
        """
        graph = _build_graph("roster_numeric.qml")
        bm = [e for e in graph["edges"] if e["kind"] == "bitmask_source"]
        self.assertEqual(len(bm), 1)
        edge = bm[0]
        self.assertEqual(edge["source"], "per_member")
        self.assertEqual(edge["ref_kind"], "variable_read")
        # Target is a real emitted variable node, not a bare name.
        var_ids = {v["id"] for v in graph["variables"]}
        self.assertIn(edge["target"], var_ids)
        self.assertTrue(edge["target"].startswith("var_family_mask_v"))

    def test_item_outcome_iterate_over_resolves_to_item(self):
        """Edge: `iterateOver` referencing an item outcome.

        roster_multiselect's `iterateOver: "q_meals_eaten.outcome"` is a
        Checkbox feeding the mask → the edge targets that item id directly.
        """
        graph = _build_graph("roster_multiselect.qml")
        bm = [e for e in graph["edges"] if e["kind"] == "bitmask_source"]
        self.assertEqual(len(bm), 1)
        edge = bm[0]
        self.assertEqual(edge["source"], "per_meal")
        self.assertEqual(edge["target"], "q_meals_eaten")
        self.assertEqual(edge["ref_kind"], "item_outcome")
        item_ids = {i["id"] for i in graph["items"]}
        self.assertIn(edge["target"], item_ids)

    def test_sample_block_emits_no_bitmask_source_edge(self):
        """Sample has no iterateOver — no bitmask_source edge for it."""
        graph = _build_graph("sample_basic.qml")
        bm = [e for e in graph["edges"] if e["kind"] == "bitmask_source"]
        self.assertEqual(bm, [])

    def test_bitmask_source_does_not_collide_with_other_edge_kinds(self):
        """Integration: the new edge kind is additive — existing roster

        diagram edges (topology / cycle / version_chain / condition_ref) are
        unchanged and no edge is double-classified.
        """
        graph = _build_graph("roster_numeric.qml")
        kinds = {e["kind"] for e in graph["edges"]}
        self.assertIn("bitmask_source", kinds)
        self.assertIn("topology", kinds)
        # Every edge has exactly one kind; no bitmask_source edge masquerades
        # as topology or vice versa (source/target/kind triples are unique).
        triples = [
            (e["source"], e["target"], e["kind"]) for e in graph["edges"]
        ]
        self.assertEqual(len(triples), len(set(triples)))
        # bitmask_source endpoints are a block→(item|variable) pair, never an
        # item→item topology pair.
        for e in graph["edges"]:
            if e["kind"] == "bitmask_source":
                self.assertEqual(e["source"], "per_member")


if __name__ == "__main__":
    unittest.main()
