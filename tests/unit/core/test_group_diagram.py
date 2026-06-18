#!/usr/bin/env python3
"""Unit tests for QMLDiagramIR Group-block emission + Roster bitmask-source edge.

Group (the two-kind model's default kind) diagram emission is a distinct
concern from Roster (different node header fields, no per-iteration label
universe), so it gets its own file rather than extending test_roster_diagram.py.

Pins the contract the QML Explorer React webview relies on (U9, R21):
- A `count`-capped Group carries `kind="Group"` and `count` (the N draw cap)
  so the diagram-viewer can render the count badge. There is NO `is_random`
  or `sample_count` field — `Sample` and randomization were removed in the
  2.0.0 collapse.
- An uncapped Group (no `count`, or `kind` omitted → defaults to Group) emits
  no `count` field at all, so the badge only appears when the draw is capped.
- Roster blocks emit a `bitmask_source` edge from the block id to the
  item/variable resolved from the `iterateOver` expression — the data
  provenance arrow distinguishing a Checkbox-driven mask (item_outcome)
  from a codeBlock-computed mask (variable_read). Roster emission is
  unchanged by the collapse.

These unit tests build QML inline through QMLLoader.load_from_string →
QMLState → QMLEngine → QMLDiagramIR (the same pipeline production uses,
exercising the 2.0.0 schema/loader contract) and assert on the
positions-free structural IR. They deliberately do NOT load the `sample_*`
/ `Sequence` fixtures (unmigrated until U12) — the inline QML keeps this
file green independent of the fixture-migration unit.
"""

import unittest

from askalot_qml.core.qml_diagram_ir import QMLDiagramIR
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import QMLState


def _build_graph_from_string(qml_content: str):
    """Load inline QML through the production pipeline and return the base IR."""
    loader = QMLLoader(qml_dir=".")
    questionnaire = loader.load_from_string(qml_content)
    state = QMLState(questionnaire)
    engine = QMLEngine(state)
    diagram = QMLDiagramIR(engine.topology, state)
    return diagram.generate_base_graph()


# A two-block questionnaire: an uncapped Group (kind omitted → defaults to
# Group) followed by a `count`-capped Group with three independent inner items.
_CAPPED_GROUP_QML = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group"
  blocks:
    - id: intro_block
      title: "Intro"
      items:
        - id: q_intro
          kind: Question
          title: "Welcome"
          input: {control: Editbox, min: 0, max: 9}
    - id: brand_group
      kind: Group
      count: 2
      title: "Brands"
      items:
        - id: q_brand_a
          kind: Question
          title: "Brand A"
          input: {control: Editbox, min: 0, max: 9}
        - id: q_brand_b
          kind: Question
          title: "Brand B"
          input: {control: Editbox, min: 0, max: 9}
        - id: q_brand_c
          kind: Question
          title: "Brand C"
          input: {control: Editbox, min: 0, max: 9}
"""


class TestGroupBlockEmission(unittest.TestCase):
    def test_capped_group_emits_group_kind_and_count(self):
        """Happy path: a `count`-capped Group carries kind/count, no random fields."""
        graph = _build_graph_from_string(_CAPPED_GROUP_QML)
        brand = next(b for b in graph["blocks"] if b["id"] == "brand_group")
        self.assertEqual(brand["kind"], "Group")
        self.assertEqual(brand["count"], 2)
        # Sample/randomization fields are gone in the 2.0.0 collapse.
        self.assertNotIn("is_random", brand)
        self.assertNotIn("sample_count", brand)
        # Group is not Roster — no roster-only fields leak onto the node.
        self.assertNotIn("iterate_over", brand)
        self.assertNotIn("label_count", brand)
        self.assertNotIn("labels", brand)

    def test_uncapped_group_omits_count(self):
        """An uncapped Group (kind omitted → Group) emits no `count` badge field."""
        graph = _build_graph_from_string(_CAPPED_GROUP_QML)
        intro = next(b for b in graph["blocks"] if b["id"] == "intro_block")
        self.assertEqual(intro["kind"], "Group")
        self.assertNotIn("count", intro)
        self.assertNotIn("is_random", intro)
        self.assertNotIn("sample_count", intro)

    def test_inner_group_items_carry_block_id(self):
        """Inner capped-Group items still group under the block for layout."""
        graph = _build_graph_from_string(_CAPPED_GROUP_QML)
        inner = [
            i
            for i in graph["items"]
            if i["id"] in ("q_brand_a", "q_brand_b", "q_brand_c")
        ]
        self.assertEqual(len(inner), 3)
        for item in inner:
            self.assertEqual(item["block_id"], "brand_group")

    def test_empty_group_block_still_renders_node(self):
        """Edge: a count==0 Group renders a node rather than crashing the emitter.

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
                        "id": "empty_group",
                        "title": "Empty Group",
                        "kind": "Group",
                        "count": 0,
                    },
                    {"id": "seq", "title": "Seq", "kind": "Group"},
                ],
                "items": [
                    {
                        "id": "q_only",
                        "blockId": "seq",
                        "kind": "Question",
                        "title": "Only question",
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                    {
                        "id": "q_capped",
                        "blockId": "empty_group",
                        "kind": "Question",
                        "title": "Capped question",
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                ],
            }
        )
        engine = QMLEngine(state)
        graph = QMLDiagramIR(engine.topology, state).generate_base_graph()
        group_node = next(b for b in graph["blocks"] if b["id"] == "empty_group")
        self.assertEqual(group_node["kind"], "Group")
        # `count` is present (0) on a hand-built capped Group — the `in block`
        # gate fires for the explicit key even when N==0.
        self.assertEqual(group_node["count"], 0)
        self.assertNotIn("is_random", group_node)


# Roster fixtures (below) are inline so this file stays green independent of
# the fixture-migration unit (U12). Roster emission is unchanged by the
# Group collapse — these assertions mirror the pre-collapse Roster contract.
_ROSTER_VARIABLE_MASK_QML = """
qmlVersion: "2.0"
questionnaire:
  title: "Family Roster"
  blocks:
    - id: count_block
      title: "Family"
      items:
        - id: q_family_count
          kind: Question
          title: "Members?"
          input: {control: Editbox, min: 1, max: 4}
          codeBlock: |
            family_mask = 2 ** q_family_count.outcome - 1
    - id: per_member
      kind: Roster
      title: "Member details"
      iterateOver: "family_mask"
      labels:
        1: "Member 1"
        2: "Member 2"
        4: "Member 3"
        8: "Member 4"
      items:
        - id: q_member_name
          kind: Question
          title: "Name?"
          input: {control: Editbox, min: 0, max: 100}
"""

_ROSTER_ITEM_OUTCOME_MASK_QML = """
qmlVersion: "2.0"
questionnaire:
  title: "Meals Roster"
  blocks:
    - id: meals_block
      title: "Meals"
      items:
        - id: q_meals_eaten
          kind: Question
          title: "Which meals?"
          input:
            control: Checkbox
            labels:
              1: "Breakfast"
              2: "Lunch"
              4: "Dinner"
    - id: per_meal
      kind: Roster
      title: "Per-meal detail"
      iterateOver: "q_meals_eaten.outcome"
      labels:
        1: "Breakfast"
        2: "Lunch"
        4: "Dinner"
      items:
        - id: q_meal_rating
          kind: Question
          title: "Rating?"
          input: {control: Editbox, min: 0, max: 5}
"""


class TestRosterBitmaskSourceEdge(unittest.TestCase):
    def test_variable_iterate_over_resolves_to_version_node(self):
        """Edge: `iterateOver` referencing a codeBlock variable.

        A codeBlock-computed bitmask (`iterateOver: "family_mask"`) → the edge
        targets the latest emitted variable version node.
        """
        graph = _build_graph_from_string(_ROSTER_VARIABLE_MASK_QML)
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

        A Checkbox feeding the mask (`iterateOver: "q_meals_eaten.outcome"`) →
        the edge targets that item id directly.
        """
        graph = _build_graph_from_string(_ROSTER_ITEM_OUTCOME_MASK_QML)
        bm = [e for e in graph["edges"] if e["kind"] == "bitmask_source"]
        self.assertEqual(len(bm), 1)
        edge = bm[0]
        self.assertEqual(edge["source"], "per_meal")
        self.assertEqual(edge["target"], "q_meals_eaten")
        self.assertEqual(edge["ref_kind"], "item_outcome")
        item_ids = {i["id"] for i in graph["items"]}
        self.assertIn(edge["target"], item_ids)

    def test_group_block_emits_no_bitmask_source_edge(self):
        """A Group has no iterateOver — no bitmask_source edge for it."""
        graph = _build_graph_from_string(_CAPPED_GROUP_QML)
        bm = [e for e in graph["edges"] if e["kind"] == "bitmask_source"]
        self.assertEqual(bm, [])

    def test_bitmask_source_does_not_collide_with_other_edge_kinds(self):
        """Integration: the bitmask edge kind is additive — existing roster

        diagram edges (topology / cycle / version_chain / condition_ref) are
        unchanged and no edge is double-classified.
        """
        graph = _build_graph_from_string(_ROSTER_VARIABLE_MASK_QML)
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
