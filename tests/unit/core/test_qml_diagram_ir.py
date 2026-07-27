"""
Unit tests for the positions-free structural IR emitted by QMLDiagramIR.

Tests the IR shape and key invariants introduced by the 2026-05-13
diagram-viewer rewrite:

- Typed top-level arrays (blocks, items, conditions, variables, edges)
  replace the legacy flat {nodes, edges} with `type` discriminator.
- Per-(variable, version) nodes anchor to the defining item via SSA
  `version_history`, replacing the collapsed `var_<name>` single node.
- Version-chain edges (v_n -> v_{n+1}) emit for every consecutive pair.
- Block-kind coloring axis (Group/Roster) is declarative — the IR reports
  `kind`, the client decides visual encoding.
- No positions: x/y/width/height/bend_points/arrow_end/arrow_start and
  the top-level `layout` key never appear on any IR entry.
- apply_validation_coloring inlines `classification` onto item entries
  (no separate `classes` map).

Most tests construct minimal QMLState instances directly — they exercise
the emission logic without needing full-size reference questionnaires, which
do not live in this repo. `TestRosterEmission` is the exception: Roster and
capped-Group emission is asserted against a multi-block fixture file, because
those fields only mean something where several block kinds coexist.
"""

from pathlib import Path

import pytest
from askalot_qml.core.qml_diagram_ir import QMLDiagramIR
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.models.qml_state import QMLState


def _make_state(items_data, code_init="", blocks_data=None):
    """Build a QMLState for a single-block questionnaire (unless blocks_data provided)."""
    default_blocks = [{"id": "b1", "title": "Block 1", "kind": "Group"}]
    return QMLState(
        {
            "title": "Test",
            "codeInit": code_init,
            "blocks": blocks_data or default_blocks,
            "items": [
                {
                    "id": i["id"],
                    "blockId": i.get("blockId", "b1"),
                    "kind": i.get("kind", "Question"),
                    "title": i.get("title", f"Item {i['id']}"),
                    **{k: v for k, v in i.items() if k not in ("id", "blockId", "kind", "title")},
                }
                for i in items_data
            ],
        }
    )


def _build_ir(state):
    engine = QMLEngine(state)
    return QMLDiagramIR(engine.topology, state).generate_base_graph()


class TestIRShape:
    def test_top_level_arrays_present(self):
        ir = _build_ir(_make_state([{"id": "q1"}]))
        for key in ("blocks", "items", "conditions", "variables", "edges", "metadata"):
            assert key in ir, f"missing IR top-level key {key!r}"
        # Legacy shape must not leak through
        assert "nodes" not in ir
        assert "classes" not in ir
        assert "layout" not in ir

    def test_no_positions_anywhere(self):
        """IR is positions-free — no layout coords on any entry."""
        state = _make_state(
            [
                {"id": "q1", "input": {"control": "Editbox", "min": 1, "max": 5}},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome > 0"}]},
            ]
        )
        ir = _build_ir(state)
        forbidden = {"x", "y", "width", "height", "bend_points", "arrow_end", "arrow_start"}
        for bucket in ("blocks", "items", "conditions", "variables", "edges"):
            for entry in ir[bucket]:
                assert not (forbidden & set(entry.keys())), f"position leak in {bucket}: {entry}"

    def test_item_entries_carry_block_id_and_kind(self):
        ir = _build_ir(
            _make_state(
                [
                    {"id": "q1", "kind": "Question"},
                    {"id": "note1", "kind": "Comment"},
                ]
            )
        )
        by_id = {i["id"]: i for i in ir["items"]}
        assert by_id["q1"]["block_id"] == "b1"
        assert by_id["q1"]["kind"] == "Question"
        assert by_id["note1"]["kind"] == "Comment"


class TestSSAVersions:
    def test_one_node_per_version(self):
        """A variable assigned in three item codeBlocks emits three version nodes."""
        state = _make_state(
            [
                {"id": "q1", "codeBlock": "score = 0"},
                {"id": "q2", "codeBlock": "score = score + 1"},
                {"id": "q3", "codeBlock": "score = score + 2"},
            ]
        )
        ir = _build_ir(state)
        score_versions = [v for v in ir["variables"] if v["name"] == "score"]
        assert len(score_versions) == 3, ir["variables"]
        versions = sorted(v["version"] for v in score_versions)
        # Each assignment produces a new version; exact values depend on
        # StaticBuilder's _get_next_version, but all three must be distinct.
        assert len(set(versions)) == 3
        anchors = {v["version"]: v["anchor_item_id"] for v in score_versions}
        # Each version anchored to a known item (not __init__, no codeInit here)
        assert set(anchors.values()) <= {"q1", "q2", "q3"}

    def test_version_chain_edges_emitted(self):
        state = _make_state(
            [
                {"id": "q1", "codeBlock": "score = 0"},
                {"id": "q2", "codeBlock": "score = score + 1"},
            ]
        )
        ir = _build_ir(state)
        chain_edges = [e for e in ir["edges"] if e["kind"] == "version_chain"]
        # Two versions -> one chain edge between them
        assert len(chain_edges) == 1
        assert chain_edges[0]["source"].startswith("var_score_v")
        assert chain_edges[0]["target"].startswith("var_score_v")
        assert chain_edges[0]["source"] != chain_edges[0]["target"]

    def test_codeinit_variable_anchors_to_init(self):
        state = _make_state(
            [{"id": "q1"}],
            code_init="flag = 1",
        )
        ir = _build_ir(state)
        flags = [v for v in ir["variables"] if v["name"] == "flag"]
        assert len(flags) == 1
        assert flags[0]["anchor_item_id"] == "__init__"

    def test_zero_variables_no_error(self):
        ir = _build_ir(_make_state([{"id": "q1"}]))
        assert ir["variables"] == []
        # No version-chain edges when there are no versions.
        assert all(e["kind"] != "version_chain" for e in ir["edges"])


class TestBlockKind:
    def test_group_and_roster_kinds_reported_declaratively(self):
        state = QMLState(
            {
                "title": "Mixed",
                "codeInit": "",
                "blocks": [
                    {"id": "b_group", "title": "Group", "kind": "Group"},
                    {
                        "id": "b_roster",
                        "title": "Roster",
                        "kind": "Roster",
                        "iterateOver": "q_count.outcome",
                        "labels": {1: "A", 2: "B", 4: "C"},
                    },
                ],
                "items": [
                    {
                        "id": "q_count",
                        "blockId": "b_group",
                        "kind": "Question",
                        "title": "Count",
                        "input": {"control": "Editbox", "min": 0, "max": 7},
                    },
                    {
                        "id": "q_name",
                        "blockId": "b_roster",
                        "kind": "Question",
                        "title": "Name",
                        "input": {"control": "Textarea"},
                    },
                ],
            }
        )
        ir = _build_ir(state)
        by_id = {b["id"]: b for b in ir["blocks"]}
        assert by_id["b_group"]["kind"] == "Group"
        # An uncapped Group carries no `count` field.
        assert "count" not in by_id["b_group"]
        assert by_id["b_roster"]["kind"] == "Roster"
        assert by_id["b_roster"]["label_count"] == 3
        assert by_id["b_roster"]["iterate_over"] == "q_count.outcome"

    def test_capped_group_reports_count(self):
        """A `count`-capped Group surfaces the draw cap; an uncapped one omits it."""
        state = QMLState(
            {
                "title": "Capped",
                "codeInit": "",
                "blocks": [
                    {"id": "b_cap", "title": "Capped", "kind": "Group", "count": 2},
                ],
                "items": [
                    {
                        "id": "q_a",
                        "blockId": "b_cap",
                        "kind": "Question",
                        "title": "A",
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                    {
                        "id": "q_b",
                        "blockId": "b_cap",
                        "kind": "Question",
                        "title": "B",
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                ],
            }
        )
        ir = _build_ir(state)
        cap = next(b for b in ir["blocks"] if b["id"] == "b_cap")
        assert cap["kind"] == "Group"
        assert cap["count"] == 2
        # No Sample/randomization residue from the 2.0.0 collapse.
        assert "is_random" not in cap
        assert "sample_count" not in cap


class TestConditionChiclets:
    def test_item_precondition_becomes_chiclet(self):
        state = _make_state(
            [
                {"id": "q1", "input": {"control": "Editbox", "min": 0, "max": 10}},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome > 5"}]},
            ]
        )
        ir = _build_ir(state)
        q2_preconds = [c for c in ir["conditions"] if c["owner_id"] == "q2" and c["kind"] == "pre"]
        assert len(q2_preconds) == 1
        assert q2_preconds[0]["owner_kind"] == "item"
        assert q2_preconds[0]["predicate"] == "q1.outcome > 5"

    def test_item_outcome_reference_emitted_in_references_and_edges(self):
        """`q1.outcome > 5` on q2 → q2_pre_0 carries a ref to q1, and the IR
        emits a `condition_ref` edge from the chiclet to q1."""
        state = _make_state(
            [
                {"id": "q1", "input": {"control": "Editbox", "min": 0, "max": 10}},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome > 5"}]},
            ]
        )
        ir = _build_ir(state)
        q2_pre = next(c for c in ir["conditions"] if c["owner_id"] == "q2" and c["kind"] == "pre")
        assert q2_pre["references"] == [{"kind": "item_outcome", "target_id": "q1"}]
        cond_ref_edges = [e for e in ir["edges"] if e["kind"] == "condition_ref"]
        # R26: edges now carry source_kind + ref_kind for handle routing.
        matching = [
            e for e in cond_ref_edges if e["source"] == q2_pre["id"] and e["target"] == "q1"
        ]
        assert len(matching) == 1
        assert matching[0]["source_kind"] == "pre"
        assert matching[0]["ref_kind"] == "item_outcome"

    def test_variable_read_reference_targets_latest_version(self):
        """A bare `is_adult` reference resolves to the highest emitted version
        of that variable in the IR."""
        state = _make_state(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 0, "max": 99},
                    "codeBlock": "is_adult = 1 if q1.outcome >= 18 else 0",
                },
                {"id": "q2", "precondition": [{"predicate": "is_adult == 1"}]},
            ],
            code_init="is_adult = 0",
        )
        ir = _build_ir(state)
        # Variables: is_adult has two versions (v0 from codeInit, v1 from q1's codeBlock).
        var_ids = sorted(v["id"] for v in ir["variables"] if v["name"] == "is_adult")
        assert var_ids == ["var_is_adult_v0", "var_is_adult_v1"]
        q2_pre = next(c for c in ir["conditions"] if c["owner_id"] == "q2" and c["kind"] == "pre")
        # Reference points at the latest version (v1), not v0.
        assert {"kind": "variable_read", "target_id": "var_is_adult_v1"} in q2_pre["references"]
        cond_ref_edges = [e for e in ir["edges"] if e["kind"] == "condition_ref"]
        assert any(
            e["source"] == q2_pre["id"] and e["target"] == "var_is_adult_v1" for e in cond_ref_edges
        )

    def test_unparseable_predicate_yields_empty_references(self):
        """Garbage predicates must not crash the emitter — references just
        come back empty for that condition."""
        state = _make_state(
            [
                {"id": "q1", "input": {"control": "Editbox", "min": 0, "max": 10}},
                {"id": "q2", "precondition": [{"predicate": "not valid python @"}]},
            ]
        )
        ir = _build_ir(state)
        q2_pre = next(c for c in ir["conditions"] if c["owner_id"] == "q2" and c["kind"] == "pre")
        assert q2_pre["references"] == []

    def test_block_level_precondition_pinned_to_block_not_items(self):
        """Block-level preconditions emit ONCE per block. R25: items only
        carry their OWN preconditions (loader no longer merges)."""
        state = QMLState(
            {
                "title": "Block pre",
                "codeInit": "",
                "blocks": [
                    {
                        "id": "b1",
                        "title": "Gate",
                        "kind": "Group",
                        "precondition": [{"predicate": "True"}],
                    },
                ],
                "items": [
                    {
                        "id": "q1",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "q1",
                        "precondition": [{"predicate": "q1.outcome > 0"}],
                    },
                    {"id": "q2", "blockId": "b1", "kind": "Question", "title": "q2"},
                ],
            }
        )
        ir = _build_ir(state)
        block_preconds = [
            c for c in ir["conditions"] if c["owner_kind"] == "block" and c["kind"] == "pre"
        ]
        # One block-level pre, not two (one per item).
        assert len(block_preconds) == 1
        assert block_preconds[0]["owner_id"] == "b1"

        # Item-level chiclets reflect ONLY the items' own preconditions —
        # not a duplicated block prefix.
        q1_preconds = [
            c
            for c in ir["conditions"]
            if c["owner_kind"] == "item" and c["owner_id"] == "q1" and c["kind"] == "pre"
        ]
        q2_preconds = [
            c
            for c in ir["conditions"]
            if c["owner_kind"] == "item" and c["owner_id"] == "q2" and c["kind"] == "pre"
        ]
        assert len(q1_preconds) == 1
        assert q1_preconds[0]["predicate"] == "q1.outcome > 0"
        assert q2_preconds == []


class TestValidationColoringInlined:
    def test_classification_added_to_items_not_as_separate_map(self):
        state = _make_state([{"id": "q1"}])
        engine = QMLEngine(state)
        diagram = QMLDiagramIR(engine.topology, state)
        base = diagram.generate_base_graph()
        classifications = {
            "q1": {
                "precondition": {"status": "ALWAYS"},
                "postcondition": {"invariant": "NONE", "vacuous": False},
            },
        }
        colored = diagram.apply_validation_coloring(base, classifications=classifications)
        assert "classes" not in colored
        q1 = next(i for i in colored["items"] if i["id"] == "q1")
        assert q1["classification"] == "always"

    def test_items_without_classifications_get_pending(self):
        state = _make_state([{"id": "q1"}])
        engine = QMLEngine(state)
        diagram = QMLDiagramIR(engine.topology, state)
        base = diagram.generate_base_graph()
        colored = diagram.apply_validation_coloring(base, classifications=None)
        q1 = next(i for i in colored["items"] if i["id"] == "q1")
        assert q1["classification"] == "pending"
        # No classifications → both raw axes are None so the front-end falls
        # back to the default border/fill instead of leaving stale colours.
        assert q1["precondition_status"] is None
        assert q1["postcondition_invariant"] is None

    def test_raw_precondition_and_postcondition_axes_inlined(self):
        """The two-axis colour scheme needs raw precondition.status and
        postcondition.invariant on each item — apply_validation_coloring should
        forward them verbatim so the diagram front-end can pick border (pre)
        and fill (post) independently."""
        state = _make_state([{"id": "q1"}, {"id": "q2"}])
        engine = QMLEngine(state)
        diagram = QMLDiagramIR(engine.topology, state)
        base = diagram.generate_base_graph()
        classifications = {
            "q1": {
                "precondition": {"status": "CONDITIONAL"},
                "postcondition": {"invariant": "INFEASIBLE", "vacuous": False},
            },
            "q2": {
                "precondition": {"status": "NEVER"},
                "postcondition": {"invariant": "TAUTOLOGICAL", "vacuous": False},
            },
        }
        colored = diagram.apply_validation_coloring(base, classifications=classifications)
        q1 = next(i for i in colored["items"] if i["id"] == "q1")
        q2 = next(i for i in colored["items"] if i["id"] == "q2")
        assert q1["precondition_status"] == "CONDITIONAL"
        assert q1["postcondition_invariant"] == "INFEASIBLE"
        assert q2["precondition_status"] == "NEVER"
        assert q2["postcondition_invariant"] == "TAUTOLOGICAL"


class TestTopologyAndCycles:
    def test_topology_edges_follow_kahn_order(self):
        state = _make_state(
            [
                {"id": "q1"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome > 0"}]},
                {"id": "q3", "precondition": [{"predicate": "q2.outcome > 0"}]},
            ]
        )
        ir = _build_ir(state)
        topology = [e for e in ir["edges"] if e["kind"] == "topology"]
        # Two edges along the 3-item chain: q1 -> q2 -> q3
        assert len(topology) == 2

    def test_cycle_metadata_populated_when_cycles_exist(self):
        state = _make_state(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "precondition": [{"predicate": "q2.outcome > 0"}],
                },
                {
                    "id": "q2",
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "precondition": [{"predicate": "q1.outcome > 0"}],
                },
            ]
        )
        ir = _build_ir(state)
        assert ir["metadata"]["has_cycles"] is True
        assert ir["metadata"]["cycle_nodes"]  # non-empty


FIXTURES_DIR = Path(__file__).parents[2] / "fixtures"


def _ir_from_fixture(filename: str):
    """Load a fixture questionnaire through the production pipeline into base IR."""
    from askalot_qml.core.qml_loader import QMLLoader

    questionnaire = QMLLoader(qml_dir=FIXTURES_DIR).load_from_file(filename)
    return _build_ir(QMLState(questionnaire))


class TestRosterEmission:
    """Roster + capped-Group emission, pinned on a multi-block questionnaire.

    The other roster_*.qml fixtures each isolate one construct. This one runs
    two Rosters alongside Groups, block preconditions, and a capped Group, so
    the block-kind fields the QML Explorer's renderer reads are asserted where
    they have to coexist rather than standing alone.
    """

    FIXTURE = "roster_household_labour.qml"

    def test_roster_blocks_carry_kind_and_label_count(self):
        """Both Rosters emit kind + label_count — the ×N badge's inputs."""
        ir = _ir_from_fixture(self.FIXTURE)
        rosters = {b["id"]: b for b in ir["blocks"] if b.get("kind") == "Roster"}
        assert set(rosters) == {"member_demographics", "member_labour"}
        for block in rosters.values():
            assert block["label_count"] == 4
            assert block["iterate_over"] == "q_members_present.outcome"

    def test_bitmask_source_edge_resolves_to_the_checkbox_item(self):
        """Checkbox forward-tightening: iterateOver reaches the item directly.

        The Checkbox's power-of-2 label keys make its outcome the bitmask, so
        the provenance edge lands on the item itself. A decode codeBlock in
        between would make this a variable_read against an intermediate name.
        """
        ir = _ir_from_fixture(self.FIXTURE)
        edges = [e for e in ir["edges"] if e["kind"] == "bitmask_source"]
        assert {(e["source"], e["target"]) for e in edges} == {
            ("member_demographics", "q_members_present"),
            ("member_labour", "q_members_present"),
        }

    def test_capped_group_emits_count_and_uncapped_groups_do_not(self):
        """`count` appears only on the capped Group — the badge's gate."""
        ir = _ir_from_fixture(self.FIXTURE)
        by_id = {b["id"]: b for b in ir["blocks"]}
        assert by_id["rotating_module"]["count"] == 2
        for block_id in ("screening", "composition", "household_totals", "closing"):
            assert "count" not in by_id[block_id], block_id

    def test_roster_inner_items_carry_their_block_id(self):
        """Inner items resolve to their Roster, so the renderer can group them."""
        ir = _ir_from_fixture(self.FIXTURE)
        labour_items = {i["id"] for i in ir["items"] if i["block_id"] == "member_labour"}
        assert {"q_activity_status", "q_usual_hours", "q_search_duration"} <= labour_items
