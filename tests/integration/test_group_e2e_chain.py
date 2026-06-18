#!/usr/bin/env python3
"""Closing-gate E2E chain: author -> validate -> run -> diagram, plus the
Group/Roster latent-bug-flush regression pass.

This is the deterministic, guaranteed-to-run in-process proof that ALWAYS runs
under `make test`. The e2e-tests/ Playwright spec drives the live dev tenant
when it is reachable and the monorepo+z3 are importable; this suite is the
in-process counterpart (the e2e venv has neither askalot_qml nor z3, so the
heavyweight chained proof cannot live there — see e2e-tests/CLAUDE.md
graceful-skip precedent in test_research_brief_roundtrip.py).

Why this file is distinct from test_group_traversal.py
------------------------------------------------------
The traversal suite exhaustively proves the FlowProcessor capped-draw invariant
in ISOLATION. This file's distinct value is the CROSS-COMPONENT chain: one
questionnaire flowing through every consumer the Group kind touches, in
sequence, proving they agree end-to-end — which no single-unit test does. The
components under test, chained:

  QMLLoader
     -> ValidationProcessor / QMLEngine -> StaticBuilder
        -> ItemClassifier + PathBasedValidator   [Z3, expect GREEN]
     -> FlowProcessor  [run, capped draw <= N]
     -> QMLDiagramIR   [kind="Group" + count; Roster bitmask_source edge]

Tests:

- E2E happy path: a capped-Group questionnaire authors, validates GREEN (no
  NEVER / no coverage_gap on drawable inner items), runs with <= N answered,
  and the diagram IR carries the Group `count` badge field.
- Regression: a plain (uncapped) Group questionnaire (with a precondition AND a
  postcondition) and a Roster questionnaire still validate and run unchanged
  (the feedback_e2e_coverage_for_agent_refactors guard — new block kinds have
  historically broken sibling paths silently).
- Regression: a mixed Roster + capped-Group survey runs and its run-state
  round-trips through JSON serialization without the two state shapes colliding
  (the cross-consumer state-shape contract, proven through a real traversal
  rather than a synthesized state dict).

These integration tests exercise the exact construction the SirWay flow API
and the validate_qml MCP tool use (ValidationProcessor + FlowProcessor +
QMLDiagramIR over the real loader), so a green run means a capped-Group
instrument works end-to-end and the uncapped-Group/Roster paths did not regress.
"""

import json
import unittest
from pathlib import Path

from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState

from tests.helpers.flow_walker import walk_and_answer as _walk

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def _load(fixture_name: str) -> dict:
    """Author step: load a .qml fixture through the real loader.

    Reuses the loader-from-fixtures shape established in
    test_group_traversal.py / test_group_z3.py rather than introducing a
    parallel utility.
    """
    loader = QMLLoader(qml_dir=FIXTURES_DIR)
    return loader.load_from_file(fixture_name)


def _validate_green(questionnaire: dict, *, drawable_items: set[str]) -> dict:
    """Validate step: run the real Z3 pipeline via ValidationProcessor and
    assert it is GREEN for the items that must be reachable.

    "Green" for a capped-Group questionnaire means: the conditionally-present
    inner items are NOT classified NEVER (they are draw-absent, not dead code —
    the classification-safety contract) and the questionnaire produced no
    blocking coverage_gap. Returns the classifications dict for further
    assertions.
    """
    vp = ValidationProcessor(QMLState(questionnaire))
    classifications = vp.get_item_classifications()
    assert classifications, "Z3 validation produced no classifications at all"
    for iid in drawable_items:
        cls = classifications.get(iid)
        assert cls is not None, f"{iid} missing from classifications"
        status = cls.get("precondition", {}).get("status")
        assert status != "NEVER", (
            f"{iid} classified NEVER — a drawable capped-Group item must "
            f"never be dead-code (classification-safety regression)"
        )
        assert not cls.get("coverage_gaps"), (
            f"{iid} carries a blocking coverage_gap: {cls.get('coverage_gaps')!r}"
        )
    return classifications


class TestCappedGroupEndToEndChain(unittest.TestCase):
    """Author -> validate (green) -> run (<= N) -> diagram, one capped-Group
    questionnaire flowing through every consumer in sequence."""

    def test_capped_group_authors_validates_runs_and_diagrams(self):
        # Author.
        q = _load("group_traversal_basic.qml")

        # Validate — Z3 GREEN for the drawable capped-Group inner items.
        self._classifications = _validate_green(
            q, drawable_items={"q_s1", "q_s2", "q_s3", "q_s4", "q_s5"}
        )

        # Run — exactly N=3 Group items asked (<= N invariant), outer items
        # still presented around the pass.
        state = QMLState(_load("group_traversal_basic.qml"))
        processor = FlowProcessor(state)
        answers = {
            "q_age": 30, "q_s1": 7, "q_s2": 3, "q_s3": 4,
            "q_s4": 6, "q_s5": 2, "q_thanks": "ok",
        }
        walked = _walk(processor, state, answers)
        group_steps = [s for s in walked if s.startswith("q_s")]
        self.assertEqual(len(group_steps), 3, "exactly N=3 must be asked")
        self.assertLessEqual(len(group_steps), 3, "<= N invariant")
        # The draw walks the block's navigation_path projection in canonical
        # order: with q_age=30 all five are eligible, so the first 3 declared
        # items are asked (deterministic first-N, no randomization).
        self.assertEqual(group_steps, ["q_s1", "q_s2", "q_s3"])
        self.assertEqual(walked[0], "q_age")
        self.assertEqual(walked[-1], "q_thanks")

        # Diagram — the Group `count` badge field is present on the IR the
        # diagram-viewer consumes; no Sample/randomization residue.
        vp = ValidationProcessor(QMLState(_load("group_traversal_basic.qml")))
        graph = vp.generate_validation_graph(enable_z3_validation=True)
        blocks = {b["id"]: b for b in graph["blocks"]}
        group_block = next(
            b for b in blocks.values()
            if b.get("kind") == "Group" and "count" in b
        )
        self.assertEqual(group_block["count"], 3)
        self.assertNotIn("is_random", group_block)
        self.assertNotIn("sample_count", group_block)


class TestUncappedGroupRosterRegression(unittest.TestCase):
    """feedback_e2e_coverage_for_agent_refactors guard: new block kinds have
    historically broken sibling paths SILENTLY. Smoke every touched flow, not
    just the capped Group."""

    def test_plain_group_validates_and_runs_unchanged(self):
        # thesis_driving_experience.qml: a pure uncapped-Group questionnaire
        # with a precondition AND a postcondition — more flow surface than a
        # flat demographics block, and it goes through the SAME
        # schema-validating loader path the capped-Group fixtures use.
        q = _load("thesis_driving_experience.qml")
        _validate_green(q, drawable_items={"q_age", "q_experience"})
        state = QMLState(_load("thesis_driving_experience.qml"))
        processor = FlowProcessor(state)
        # q_age = 30 (>= 16 → q_experience eligible); q_experience = 5
        # (<= 30 - 16 = 14 → postcondition satisfied).
        walked = _walk(processor, state, {"q_age": 30, "q_experience": 5})
        self.assertEqual(walked[0], "q_age")
        self.assertIn("q_experience", walked,
                       "precondition q_age>=16 must let q_experience through")

    def test_roster_validates_and_runs_unchanged(self):
        q = _load("roster_numeric.qml")
        # The Roster inner items are conditionally-present; they must not be
        # NEVER (same classification-safety contract as a capped Group).
        _validate_green(q, drawable_items={"q_member_name", "q_member_age"})

        state = QMLState(_load("roster_numeric.qml"))
        processor = FlowProcessor(state)
        # q_family_count = 2 → family_mask = 2**2 - 1 = 3 → bits 1,2 set →
        # 2 Roster iterations (Member 1, Member 2).
        answers = {
            "q_family_count": 2,
            "q_member_name": "Alice",
            "q_member_age": 40,
        }
        walked = _walk(processor, state, answers)
        self.assertEqual(walked[0], "q_family_count")
        # The roster inner items are each presented twice (once per active
        # label bit) — the Roster runtime traversal is unchanged.
        self.assertEqual(walked.count("q_member_name"), 2)
        self.assertEqual(walked.count("q_member_age"), 2)
        self.assertIn("per_member", state.get("roster_outcomes", {}))

    def test_roster_diagram_emits_bitmask_source_edge(self):
        # The bitmask_source edge on a Roster questionnaire — proving the
        # diagram-viewer's bitmask_source contract on the live path.
        vp = ValidationProcessor(QMLState(_load("roster_numeric.qml")))
        graph = vp.generate_validation_graph(enable_z3_validation=True)
        bitmask_edges = [
            e for e in graph["edges"] if e.get("kind") == "bitmask_source"
        ]
        self.assertTrue(
            bitmask_edges,
            "Roster block must emit a bitmask_source edge to its "
            "iterateOver source",
        )


class TestMixedRosterGroupStateRoundTrip(unittest.TestCase):
    """Cross-consumer state-shape contract, proven through a REAL traversal: a
    survey carrying BOTH a Roster and a capped-Group block runs, and its
    run-state survives a JSON serialization round-trip without the two state
    shapes colliding."""

    def test_mixed_survey_runs_and_state_round_trips(self):
        # Validate green first (no kind cross-contamination at Z3 time).
        q = _load("roster_and_group_mixed.qml")
        _validate_green(
            q,
            drawable_items={
                "q_member_name", "q_member_age",  # Roster
                "q_pref_a", "q_pref_b",            # capped Group (count=2)
            },
        )

        state = QMLState(_load("roster_and_group_mixed.qml"))
        processor = FlowProcessor(state)
        # family_count=2 → mask 3 → Members 1 & 2; Group count=2 → q_pref_a,
        # q_pref_b drawn in canonical order (q_pref_c never drawn).
        answers = {
            "q_family_count": 2,
            "q_member_name": "Bob",
            "q_member_age": 33,
            "q_pref_a": 1,
            "q_pref_b": 2,
            "q_thanks": "done",
        }
        walked = _walk(processor, state, answers)

        # Both kinds exercised in one run. The observable draw — q_pref_a and
        # q_pref_b drawn in canonical order, q_pref_c never drawn — is the
        # end-to-end proof of the capped-Group first-N contract. (The transient
        # `group_asked` pass state is cleared on Group exit, so it is empty here
        # post-completion — see QMLState.clear_group_pass_state.)
        self.assertEqual(walked.count("q_member_name"), 2, "Roster x2")
        self.assertIn("q_pref_a", walked)
        self.assertIn("q_pref_b", walked)
        self.assertNotIn("q_pref_c", walked,
                          "count=2 canonical order: q_pref_c never drawn")

        # The persistent Roster state survives a JSON round-trip without the
        # capped-Group path corrupting it — QMLState is a dict subclass, so this
        # is the exact serialization SirWay's session store performs.
        revived = QMLState(json.loads(json.dumps(dict(state))))
        self.assertEqual(
            revived["roster_outcomes"]["per_member"],
            state["roster_outcomes"]["per_member"],
            "Roster outcomes must survive serialization unchanged",
        )
        # The drawn Group items keep their answers; the non-drawn one is absent.
        items_by_id = {i["id"]: i for i in revived["items"]}
        self.assertEqual(items_by_id["q_pref_a"]["outcome"], 1)
        self.assertEqual(items_by_id["q_pref_b"]["outcome"], 2)
        self.assertIsNone(items_by_id["q_pref_c"].get("outcome"),
                          "non-drawn capped-Group item stays absent (outcome=None)")


if __name__ == "__main__":
    unittest.main()
