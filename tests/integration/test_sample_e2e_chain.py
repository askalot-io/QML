#!/usr/bin/env python3
"""U9 closing-gate E2E chain: author -> validate -> run -> diagram, plus the
Sequence/Roster latent-bug-flush regression pass.

This is the deterministic, guaranteed-to-run half of U9
(docs/plans/2026-05-17-001-feat-sample-block-kind-aware-z3-plan.md). The
e2e-tests/ Playwright spec drives the live dev tenant when it is reachable
and the monorepo+z3 are importable; this suite is the in-process proof that
ALWAYS runs under `make test` (the e2e venv has neither askalot_qml nor z3,
so the heavyweight chained proof cannot live there — see e2e-tests/CLAUDE.md
graceful-skip precedent in test_research_brief_roundtrip.py).

Why this file is distinct from test_sample_traversal.py (U5)
------------------------------------------------------------
U5's suite exhaustively proves the FlowProcessor frozen-order invariant in
ISOLATION. U9's distinct value is the CROSS-COMPONENT chain: one
questionnaire flowing through every consumer the Sample kind touches, in
sequence, proving they agree end-to-end — which no single-unit test does.
The components under test, chained:

  QMLLoader (U1)
     -> ValidationProcessor / QMLEngine -> StaticBuilder (U2)
        -> ItemClassifier + PathBasedValidator (U2/U4)   [Z3, expect GREEN]
     -> FlowProcessor (U5)  [run + backward-nav frozen-order invariant]
     -> QMLDiagramIR (U7)   [kind="Sample"/sample_count/is_random
                             + Roster bitmask_source edge]

Tests (all R14, the closing-gate requirement):

- E2E happy path: a Sample questionnaire authors, validates GREEN (no NEVER /
  no coverage_gap on drawable inner items), runs with <= N answered.
- E2E frozen-order end-to-end: an is_random Sample survey — navigate back
  across the whole pass then forward; the user-visible draw order is the
  SAME (the R3/R6 frozen-order invariant proven through the real
  FlowProcessor, not a unit stub).
- E2E diagram: the same validated questionnaire's IR carries the U7 Sample
  header fields, and a Roster questionnaire emits the new bitmask_source
  edge — proving the just-landed diagram-viewer rewrite's IR contract holds
  on the now-live Sample/bitmask path.
- Regression: a plain Sequence questionnaire (with a precondition AND a
  postcondition) and a Roster questionnaire still validate and run
  unchanged (the feedback_e2e_coverage_for_agent_refactors guard — new
  block kinds have historically broken sibling paths silently).
- Regression: a mixed Roster+Sample survey runs and its run-state
  round-trips through JSON serialization without the two state shapes
  colliding (the U6 cross-consumer state-shape contract, proven through a
  real traversal rather than a synthesized state dict).

These integration tests exercise the exact construction the SirWay flow API
and the validate_qml MCP tool use (ValidationProcessor + FlowProcessor +
QMLDiagramIR over the real loader), so a green run means a Sample instrument
works end-to-end and Sequence/Roster did not regress.
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
    """Author step: load a .qml fixture through the real loader (U1).

    Reuses the loader-from-fixtures shape established in
    test_sample_traversal.py / test_sample_z3.py rather than introducing a
    parallel utility.
    """
    loader = QMLLoader(qml_dir=FIXTURES_DIR)
    return loader.load_from_file(fixture_name)


def _validate_green(questionnaire: dict, *, drawable_items: set[str]) -> dict:
    """Validate step: run the real Z3 pipeline via ValidationProcessor and
    assert it is GREEN for the items that must be reachable.

    "Green" for a Sample questionnaire means: the conditionally-present inner
    items are NOT classified NEVER (they are sampling-absent, not dead code —
    the U2 classification-safety contract) and the questionnaire produced no
    blocking coverage_gap (e.g. a sample_cap reject). Returns the
    classifications dict for further assertions.
    """
    vp = ValidationProcessor(QMLState(questionnaire))
    classifications = vp.get_item_classifications()
    assert classifications, "Z3 validation produced no classifications at all"
    for iid in drawable_items:
        cls = classifications.get(iid)
        assert cls is not None, f"{iid} missing from classifications"
        status = cls.get("precondition", {}).get("status")
        assert status != "NEVER", (
            f"{iid} classified NEVER — a drawable Sample/Sequence item must "
            f"never be dead-code (U2 classification-safety regression)"
        )
        assert not cls.get("coverage_gaps"), (
            f"{iid} carries a blocking coverage_gap: {cls.get('coverage_gaps')!r}"
        )
    return classifications


class TestSampleEndToEndChain(unittest.TestCase):
    """Author -> validate (green) -> run (<= N) -> diagram, one Sample
    questionnaire flowing through every consumer in sequence."""

    def test_sample_authors_validates_runs_and_diagrams(self):
        # Author.
        q = _load("sample_traversal_basic.qml")

        # Validate — Z3 GREEN for the drawable Sample inner items.
        self._classifications = _validate_green(
            q, drawable_items={"q_s1", "q_s2", "q_s3", "q_s4", "q_s5"}
        )

        # Run — exactly N=3 Sample items asked (<= N invariant), outer items
        # still presented around the pass.
        state = QMLState(_load("sample_traversal_basic.qml"))
        processor = FlowProcessor(state)
        answers = {
            "q_age": 30, "q_s1": 7, "q_s2": 3, "q_s3": 4,
            "q_s4": 6, "q_s5": 2, "q_thanks": "ok",
        }
        walked = _walk(processor, state, answers)
        sample_steps = [s for s in walked if s.startswith("q_s")]
        self.assertEqual(len(sample_steps), 3, "exactly N=3 must be asked")
        self.assertLessEqual(len(sample_steps), 3, "<= N invariant")
        self.assertEqual(walked[0], "q_age")
        self.assertEqual(walked[-1], "q_thanks")

        # Diagram — the U7 Sample header fields are present on the IR the
        # just-landed diagram-viewer rewrite consumes.
        vp = ValidationProcessor(QMLState(_load("sample_traversal_basic.qml")))
        graph = vp.generate_validation_graph(enable_z3_validation=True)
        blocks = {b["id"]: b for b in graph["blocks"]}
        sample_block = next(
            b for b in blocks.values() if b.get("kind") == "Sample"
        )
        self.assertIn("sample_count", sample_block)
        self.assertEqual(sample_block["sample_count"], 3)
        self.assertIn("is_random", sample_block)
        self.assertIsInstance(sample_block["is_random"], bool)


class TestIsRandomFrozenOrderEndToEnd(unittest.TestCase):
    """R3/R6: the frozen-order invariant proven through the REAL
    FlowProcessor — back across the whole pass then forward yields the SAME
    user-visible draw order (not re-randomised)."""

    def test_backward_nav_on_is_random_block_keeps_order_stable(self):
        state = QMLState(_load("sample_traversal_random.qml"))
        processor = FlowProcessor(state)
        answers = {
            "q_warmup": 3, "q_a1": 1, "q_a2": 2,
            "q_b1": 3, "q_b2": 4, "q_done": 1,
        }

        # First forward walk — capture the user-visible Sample step order.
        walked_1 = _walk(processor, state, answers)
        sample_1 = [s for s in walked_1
                    if s in ("q_a1", "q_a2", "q_b1", "q_b2")]
        frozen = list(state["sample_order"]["topic_sample"])
        self.assertEqual(sample_1, frozen,
                          "first pass must follow the frozen order")

        # Navigate BACKWARD across the entire Sample pass and back out.
        for _ in range(6):
            processor.get_current_item(state, backward=True)

        # The frozen order must be untouched by backward navigation alone.
        self.assertEqual(
            state["sample_order"]["topic_sample"], frozen,
            "backward-nav must NOT re-randomise the frozen order",
        )

        # Walk FORWARD again — same user-visible order, end to end.
        walked_2 = _walk(processor, state, answers)
        sample_2 = [s for s in walked_2
                    if s in ("q_a1", "q_a2", "q_b1", "q_b2")]
        self.assertEqual(
            sample_2, frozen,
            "back-then-forward must yield the SAME order (R3 frozen-order "
            "invariant, end-to-end through the real FlowProcessor)",
        )


class TestSequenceRosterRegression(unittest.TestCase):
    """feedback_e2e_coverage_for_agent_refactors guard: new block kinds have
    historically broken sibling Sequence/Roster paths SILENTLY. Smoke every
    touched flow, not just Sample."""

    def test_plain_sequence_validates_and_runs_unchanged(self):
        # thesis_driving_experience.qml: a pure-Sequence questionnaire with a
        # precondition AND a postcondition — more flow surface than a flat
        # demographics block, and it goes through the SAME schema-validating
        # loader path the Sample fixtures use (the realistic author path).
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
        # The Roster inner items are conditionally-present via U3; they must
        # not be NEVER (same classification-safety contract as Sample).
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
        # The U7 new edge kind on a Roster questionnaire — proving the
        # diagram-viewer rewrite's bitmask_source contract on the live path.
        vp = ValidationProcessor(QMLState(_load("roster_numeric.qml")))
        graph = vp.generate_validation_graph(enable_z3_validation=True)
        bitmask_edges = [
            e for e in graph["edges"] if e.get("kind") == "bitmask_source"
        ]
        self.assertTrue(
            bitmask_edges,
            "Roster block must emit a bitmask_source edge to its "
            "iterateOver source (U7/R11)",
        )


class TestMixedRosterSampleStateRoundTrip(unittest.TestCase):
    """U6 cross-consumer state-shape contract, proven through a REAL
    traversal: a survey carrying BOTH a Roster and a Sample block runs, and
    its run-state survives a JSON serialization round-trip without the two
    state shapes colliding."""

    def test_mixed_survey_runs_and_state_round_trips(self):
        # Validate green first (no kind cross-contamination at Z3 time).
        q = _load("roster_and_sample_mixed.qml")
        _validate_green(
            q,
            drawable_items={
                "q_member_name", "q_member_age",  # Roster
                "q_pref_a", "q_pref_b",            # Sample (count=2, declared)
            },
        )

        state = QMLState(_load("roster_and_sample_mixed.qml"))
        processor = FlowProcessor(state)
        # family_count=2 → mask 3 → Members 1 & 2; Sample count=2, is_random
        # false → q_pref_a, q_pref_b drawn (q_pref_c never drawn).
        answers = {
            "q_family_count": 2,
            "q_member_name": "Bob",
            "q_member_age": 33,
            "q_pref_a": 1,
            "q_pref_b": 2,
            "q_thanks": "done",
        }
        walked = _walk(processor, state, answers)

        # Both kinds exercised in one run.
        self.assertEqual(walked.count("q_member_name"), 2, "Roster x2")
        self.assertIn("q_pref_a", walked)
        self.assertIn("q_pref_b", walked)
        self.assertNotIn("q_pref_c", walked,
                          "count=2 declared-order: q_pref_c never drawn")

        # The two state shapes coexist without key collision.
        self.assertIn("per_member", state.get("roster_outcomes", {}))
        self.assertIn("pref_sample", state.get("sample_order", {}))

        # JSON round-trip — QMLState is a dict subclass, so this is the exact
        # serialization SirWay's session store performs.
        revived = QMLState(json.loads(json.dumps(dict(state))))
        self.assertEqual(
            revived["roster_outcomes"]["per_member"],
            state["roster_outcomes"]["per_member"],
            "Roster outcomes must survive serialization unchanged",
        )
        self.assertEqual(
            revived["sample_order"]["pref_sample"],
            state["sample_order"]["pref_sample"],
            "Frozen Sample order must survive serialization unchanged",
        )


if __name__ == "__main__":
    unittest.main()
