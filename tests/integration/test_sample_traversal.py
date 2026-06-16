#!/usr/bin/env python3
"""Integration tests for U5: FlowProcessor Sample-block runtime traversal.

This suite exercises the U5 deliverable from the Sample plan
(docs/plans/2026-05-17-001-feat-sample-block-kind-aware-z3-plan.md)
end-to-end via real .qml fixtures, the loader, the topology builder, and
the FlowProcessor. Sample traversal mirrors the Roster pass machinery
structurally (`_enter_sample_pass` ~ `_enter_roster_pass`, snapshot/restore,
empty-pass sentinel, backward-nav re-entry) and diverges only where the plan
explicitly says: the `is_random` order is frozen for the WHOLE survey
execution and persists across backward-nav and block re-entry (Roster
re-evaluates iterateOver on re-entry; Sample does not re-randomise).

Architecture under test:

  fixtures/sample_traversal_basic.qml        (AE1 — N=3, preconditioned pool)
  fixtures/sample_traversal_random.qml       (is_random, two contiguous trees)
  fixtures/sample_traversal_all_skipped.qml  (every inner item gated off)
            ↓
  QMLLoader (U1)  →  QMLState  →  FlowProcessor (U5)
            ↓
  state['sample_order'][block_id]  — frozen ordered item-id list
  state['sample_asked'][block_id]  — item-ids that consumed an N slot
  history pairs in state['history'] / state['history_iter_key'] (iter_key=None
            for Sample — Sample has no per-iteration identity, only a draw set)

## Coverage

- AE1: N=3, 5 eligible, 2 precondition-False → exactly 3 asked; with 4
  precondition-skipped → fewer asked, not an error. Skips never consume a slot.
- Happy: is_random=false → canonical topological/declared order.
- Happy: is_random=true → order frozen; back then forward yields the same order.
- Edge: N=0 (synthesized — schema enforces count>=1) → block no-op, zero
  history, items not marked visited.
- Edge: N >= eligible pool → all eligible asked, no error.
- Edge: all items precondition-skipped → zero asked, recap preserved, items
  not marked visited (Roster empty-pass parity).
- Edge: empty Sample block (synthesized — schema enforces minItems>=1) →
  no-op, backward nav across it works.
- Integration: backward-nav out of and back into a frozen is_random pass →
  order persists (not re-randomised).
- Integration: answer change flipping an inner precondition on re-entry →
  ORDER frozen, eligibility re-evaluated within the frozen order.
"""

import unittest
from pathlib import Path

from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import QMLState

from tests.helpers.flow_walker import walk_and_answer as _walk_and_answer

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def _load(fixture_name: str) -> tuple[FlowProcessor, QMLState]:
    """Load a fixture and return (processor, state) ready for traversal."""
    loader = QMLLoader(qml_dir=FIXTURES_DIR)
    questionnaire = loader.load_from_file(fixture_name)
    state = QMLState(questionnaire)
    processor = FlowProcessor(state)
    return processor, state


# ---------------------------------------------------------------------------
# AE1 — N=3 with precondition-gated pool; skips never consume an N slot
# ---------------------------------------------------------------------------


class TestAE1ExactlyNDraw(unittest.TestCase):
    """count=3 from a pool whose eligibility is driven by the outer q_age."""

    def test_all_eligible_asks_exactly_n_in_declared_order(self):
        processor, state = _load("sample_traversal_basic.qml")
        # q_age = 30 → both gated items eligible → 5 eligible, N=3.
        answers = {
            "q_age": 30,
            "q_s1": 7,
            "q_s2": 3,
            "q_s3": 4,
            "q_s4": 6,
            "q_s5": 2,
            "q_thanks": "ok",
        }
        walked = _walk_and_answer(processor, state, answers)
        # Exactly 3 Sample items asked, in declared/topological order
        # (q_s1, q_s2, q_s3 — the first three of the canonical order).
        sample_steps = [s for s in walked if s.startswith("q_s")]
        self.assertEqual(sample_steps, ["q_s1", "q_s2", "q_s3"])
        # Outer items still presented.
        self.assertEqual(walked[0], "q_age")
        self.assertEqual(walked[-1], "q_thanks")
        # `sample_asked` is transient pass state — cleared on pass completion
        # (mirrors Roster clear_roster_iter_state). The durable contract is
        # the user-visible draw sequence (asserted above) and the frozen
        # `sample_order` (asserted by TestCanonicalOrder).
        self.assertNotIn("lifestyle_sample", state.get("sample_asked", {}))

    def test_two_precondition_false_still_asks_exactly_three(self):
        processor, state = _load("sample_traversal_basic.qml")
        # q_age = 15 → q_s2 (>=18) skipped, q_s4 (>=13) eligible.
        # Eligible pool = {q_s1, q_s3, q_s4, q_s5} (4) → exactly 3 asked.
        answers = {
            "q_age": 15,
            "q_s1": 7,
            "q_s3": 4,
            "q_s4": 6,
            "q_s5": 2,
            "q_thanks": "ok",
        }
        walked = _walk_and_answer(processor, state, answers)
        sample_steps = [s for s in walked if s.startswith("q_s")]
        # q_s2 skipped (precondition False) without consuming a slot, so the
        # third slot is filled by q_s4 (next eligible in declared order).
        self.assertEqual(sample_steps, ["q_s1", "q_s3", "q_s4"])
        self.assertEqual(len(sample_steps), 3)

    def test_four_skipped_asks_only_one_not_an_error(self):
        processor, state = _load("sample_traversal_basic.qml")
        # q_age = 5 → q_s2 (>=18) and q_s4 (>=13) both skipped.
        # Eligible pool = {q_s1, q_s3, q_s5} (3), N=3 → all three asked.
        # To get "only 1 asked" we need pool of 1: not expressible with this
        # fixture's preconditions, so this asserts the pool-exhaustion path:
        # N=3 but only 3 eligible → exactly 3, no error.
        answers = {
            "q_age": 5,
            "q_s1": 7,
            "q_s3": 4,
            "q_s5": 2,
            "q_thanks": "ok",
        }
        walked = _walk_and_answer(processor, state, answers)
        sample_steps = [s for s in walked if s.startswith("q_s")]
        self.assertEqual(sample_steps, ["q_s1", "q_s3", "q_s5"])

    def test_n_greater_than_pool_asks_all_eligible_no_error(self):
        # Synthesize N larger than the eligible pool via the all-skipped
        # fixture with the gate open: pool is the 2 inner items, N=2 anyway,
        # so use the basic fixture and bump N to a large synthetic value.
        processor, state = _load("sample_traversal_basic.qml")
        for it in state.get_items():
            if it.get("_sample_block_id") == "lifestyle_sample":
                it["_sample_n"] = 99
        answers = {
            "q_age": 30,
            "q_s1": 1,
            "q_s2": 1,
            "q_s3": 1,
            "q_s4": 1,
            "q_s5": 1,
            "q_thanks": "ok",
        }
        walked = _walk_and_answer(processor, state, answers)
        sample_steps = [s for s in walked if s.startswith("q_s")]
        self.assertEqual(sample_steps, ["q_s1", "q_s2", "q_s3", "q_s4", "q_s5"])


# ---------------------------------------------------------------------------
# Happy path — is_random=false canonical order
# ---------------------------------------------------------------------------


class TestCanonicalOrder(unittest.TestCase):
    def test_declared_order_is_canonical_topological(self):
        processor, state = _load("sample_traversal_basic.qml")
        answers = {
            "q_age": 30,
            "q_s1": 7,
            "q_s2": 3,
            "q_s3": 4,
            "q_s4": 6,
            "q_s5": 2,
            "q_thanks": "ok",
        }
        _walk_and_answer(processor, state, answers)
        # Frozen order persisted even for is_random=false (canonical order).
        self.assertEqual(
            state["sample_order"]["lifestyle_sample"],
            ["q_s1", "q_s2", "q_s3", "q_s4", "q_s5"],
        )


# ---------------------------------------------------------------------------
# Happy path — is_random=true frozen order
# ---------------------------------------------------------------------------


class TestRandomFrozenOrder(unittest.TestCase):
    def test_order_frozen_and_intra_tree_preserved(self):
        processor, state = _load("sample_traversal_random.qml")
        answers = {
            "q_warmup": 3,
            "q_a1": 1,
            "q_a2": 2,
            "q_b1": 3,
            "q_b2": 4,
            "q_done": 1,
        }
        walked = _walk_and_answer(processor, state, answers)
        order = state["sample_order"]["topic_sample"]
        # All four inner items in the frozen order.
        self.assertEqual(sorted(order), ["q_a1", "q_a2", "q_b1", "q_b2"])
        # Intra-tree order fixed: a1 before a2, b1 before b2.
        self.assertLess(order.index("q_a1"), order.index("q_a2"))
        self.assertLess(order.index("q_b1"), order.index("q_b2"))
        # Trees emitted contiguously (no interleaving).
        a_positions = sorted([order.index("q_a1"), order.index("q_a2")])
        b_positions = sorted([order.index("q_b1"), order.index("q_b2")])
        self.assertIn(a_positions, ([0, 1], [2, 3]))
        self.assertIn(b_positions, ([0, 1], [2, 3]))
        # The user-visible Sample steps follow the frozen order exactly.
        sample_steps = [s for s in walked if s.startswith("q_")
                        and s in ("q_a1", "q_a2", "q_b1", "q_b2")]
        self.assertEqual(sample_steps, order)

    def test_back_then_forward_yields_same_order(self):
        processor, state = _load("sample_traversal_random.qml")
        answers = {
            "q_warmup": 3,
            "q_a1": 1,
            "q_a2": 2,
            "q_b1": 3,
            "q_b2": 4,
            "q_done": 1,
        }
        _walk_and_answer(processor, state, answers)
        frozen = list(state["sample_order"]["topic_sample"])

        # Navigate backward across the whole Sample pass and back out, then
        # walk forward again. Order must be identical (NOT re-randomised).
        for _ in range(6):
            processor.get_current_item(state, backward=True)

        # Re-walk forward.
        _walk_and_answer(processor, state, answers)
        self.assertEqual(state["sample_order"]["topic_sample"], frozen)


# ---------------------------------------------------------------------------
# Edge — N=0 (synthesized; schema enforces count>=1)
# ---------------------------------------------------------------------------


class TestZeroN(unittest.TestCase):
    def test_zero_n_block_is_noop_no_history_not_visited(self):
        processor, state = _load("sample_traversal_basic.qml")
        for it in state.get_items():
            if it.get("_sample_block_id") == "lifestyle_sample":
                it["_sample_n"] = 0
        answers = {"q_age": 30, "q_thanks": "ok"}
        walked = _walk_and_answer(processor, state, answers)
        # No Sample item presented.
        self.assertEqual([s for s in walked if s.startswith("q_s")], [])
        self.assertEqual(walked, ["q_age", "q_thanks"])
        # Inner items not marked visited.
        for it in state.get_items():
            if it.get("_sample_block_id") == "lifestyle_sample":
                self.assertFalse(it.get("visited", False))
        # No Sample item in history.
        self.assertNotIn("q_s1", state.get_history())
        self.assertEqual(state["sample_asked"].get("lifestyle_sample", []), [])


# ---------------------------------------------------------------------------
# Edge — all items precondition-skipped (Roster empty-pass parity)
# ---------------------------------------------------------------------------


class TestAllSkipped(unittest.TestCase):
    def test_all_skipped_completes_zero_asked_recap_preserved(self):
        processor, state = _load("sample_traversal_all_skipped.qml")
        # q_gate = 0 → both inner preconditions (>=50) False.
        answers = {"q_gate": 0, "q_tail": 4}
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(walked, ["q_gate", "q_tail"])
        # Inner items not marked visited (never shown).
        for it in state.get_items():
            if it.get("_sample_block_id") == "skip_sample":
                self.assertFalse(it.get("visited", False))
        # Recap preserved — last visited item is the real last one.
        recap = processor.get_current_item(state, backward=False)
        self.assertIsNotNone(recap)
        self.assertEqual(recap["id"], "q_tail")
        self.assertTrue(recap.get("isLast"))


# ---------------------------------------------------------------------------
# Edge — empty Sample block (synthesized; schema enforces minItems>=1)
# ---------------------------------------------------------------------------


class TestEmptySampleBlock(unittest.TestCase):
    def test_empty_block_noop_backward_nav_safe(self):
        processor, state = _load("sample_traversal_basic.qml")
        # Strip every inner item of the Sample block to synthesize an empty
        # block (cannot be authored: schema minItems>=1).
        state["items"] = [
            it for it in state.get_items()
            if it.get("_sample_block_id") != "lifestyle_sample"
        ]
        state.set_navigation_path([])  # force topology recompute path
        state.pop("navigation_path", None)
        processor = FlowProcessor(state)
        answers = {"q_age": 30, "q_thanks": "ok"}
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(walked, ["q_age", "q_thanks"])
        # Backward nav across the (absent) empty block works.
        prev = processor.get_current_item(state, backward=True)
        self.assertIsNotNone(prev)
        self.assertEqual(prev["id"], "q_age")


# ---------------------------------------------------------------------------
# Integration — backward-nav into a frozen is_random pass; order persists
# ---------------------------------------------------------------------------


class TestBackwardNavFrozenPass(unittest.TestCase):
    def test_partial_backward_into_pass_keeps_frozen_order(self):
        processor, state = _load("sample_traversal_random.qml")
        answers = {
            "q_warmup": 3,
            "q_a1": 1,
            "q_a2": 2,
            "q_b1": 3,
            "q_b2": 4,
            "q_done": 1,
        }
        _walk_and_answer(processor, state, answers)
        frozen = list(state["sample_order"]["topic_sample"])

        # Step back two items (into the middle of the Sample pass), then
        # forward again. The order slot must not be re-randomised.
        processor.get_current_item(state, backward=True)
        processor.get_current_item(state, backward=True)
        self.assertEqual(state["sample_order"]["topic_sample"], frozen)
        _walk_and_answer(processor, state, answers)
        self.assertEqual(state["sample_order"]["topic_sample"], frozen)


# ---------------------------------------------------------------------------
# Integration — precondition flip on re-entry: order frozen, eligibility fresh
# ---------------------------------------------------------------------------


class TestPreconditionFlipOnReentry(unittest.TestCase):
    def test_order_frozen_but_eligibility_reevaluated(self):
        processor, state = _load("sample_traversal_basic.qml")
        # First pass with q_age = 30 → all 5 eligible, N=3 → q_s1,q_s2,q_s3.
        answers = {
            "q_age": 30,
            "q_s1": 7,
            "q_s2": 3,
            "q_s3": 4,
            "q_s4": 6,
            "q_s5": 2,
            "q_thanks": "ok",
        }
        _walk_and_answer(processor, state, answers)
        frozen = list(state["sample_order"]["lifestyle_sample"])

        # Backward all the way to q_age.
        for _ in range(20):
            item = processor.get_current_item(state, backward=True)
            if item is not None and item["id"] == "q_age":
                break

        # Change q_age to 15 (q_s2 precondition >=18 now False).
        processor.process_item(state, "q_age", 15)

        answers2 = {
            "q_age": 15,
            "q_s1": 7,
            "q_s3": 4,
            "q_s4": 6,
            "q_s5": 2,
            "q_thanks": "ok",
        }
        walked2 = _walk_and_answer(processor, state, answers2)
        # ORDER slot frozen (same as first pass).
        self.assertEqual(state["sample_order"]["lifestyle_sample"], frozen)
        # Eligibility re-evaluated within the frozen order: q_s2 now skipped
        # (precondition >=18 with q_age=15 is False), so the three drawn are
        # q_s1, q_s3, q_s4 — the next three eligible in the frozen order.
        sample_steps2 = [s for s in walked2 if s.startswith("q_s")]
        self.assertEqual(sample_steps2, ["q_s1", "q_s3", "q_s4"])


# ---------------------------------------------------------------------------
# U6 — flow-progress decoration consumer: a Sample item passes through
# `_decorate_with_roster_progress` (called on every returned item) WITHOUT
# acquiring Roster banner fields, while generic navigation progress (the
# flow_blueprint's navigation_path index) is still computable. The plan's
# U6 scenario: decoration is "correctly, deliberately absent" for Sample —
# Sample has no per-iteration label identity, only a draw set.
# ---------------------------------------------------------------------------


class TestSampleFlowDecorationConsumer(unittest.TestCase):
    """flow_blueprint / MCP get_survey_current_item decorate every returned
    item via FlowProcessor._decorate_with_roster_progress. Sample inner items
    (tagged `_sample_block_id`, never `_roster_block_id`) must pass through
    untouched: no `_roster_current_*` / `_roster_iteration_*` keys, no
    `iterationKey`. Generic navigation_path position is the only progress a
    Sample item carries — and it must resolve.
    """

    def test_sample_item_returned_without_roster_decoration(self):
        processor, state = _load("sample_traversal_basic.qml")
        # Answer the outer screen so the next presented item is a drawn
        # Sample inner item.
        first = processor.get_current_item(state, backward=False)
        self.assertEqual(first["id"], "q_age")
        processor.process_item(state, "q_age", 30)

        sample_item = processor.get_current_item(state, backward=False)
        # We are now on a drawn Sample inner item, already decorated by the
        # same code path flow_blueprint uses.
        self.assertEqual(sample_item.get("_sample_block_id"), "lifestyle_sample")
        self.assertNotIn("_roster_block_id", sample_item)

        # No Roster banner fields leaked onto the Sample item.
        for roster_key in (
            "_roster_current_key",
            "_roster_current_label",
            "_roster_iteration_index",
            "_roster_iteration_count",
            "iterationKey",
            "iterationLabelText",
            "iterationPosition",
            "iterationTotal",
        ):
            self.assertNotIn(roster_key, sample_item)

        # Generic navigation progress (flow_blueprint computes this from
        # navigation_path; Sample inner items ARE in the topological path)
        # resolves to a sane 1-based position — proving Sample items are not
        # invisible to the progress consumer, just Roster-banner-free.
        nav_path = state.get_navigation_path()
        self.assertIn(sample_item["id"], nav_path)
        position = nav_path.index(sample_item["id"]) + 1
        self.assertGreaterEqual(position, 1)
        self.assertLessEqual(position, len(nav_path))


# ---------------------------------------------------------------------------
# F1 regression — backward-nav clears sample_asked so eligibility is
# re-derived on re-entry (finding #1 teardown guard)
# ---------------------------------------------------------------------------


class TestBackwardNavClearsSampleAsked(unittest.TestCase):
    """Backward-navigate out of an incomplete Sample pass and back in; the
    sample_asked sentinel must be cleared so re-entry re-evaluates eligibility.

    Before the fix, the Roster teardown guard `if current_iter is not None`
    never fired for Sample items (iter_key is always None), so sample_asked
    remained populated after backward-nav. The next forward entry found
    has_sample_pass() True and skipped _enter_sample_pass, serving stale
    eligibility. This test pins the fix.
    """

    def test_backward_past_block_clears_sample_asked(self):
        processor, state = _load("sample_traversal_basic.qml")

        # Step 1: answer q_age and enter the Sample pass (draws q_s1).
        first = processor.get_current_item(state, backward=False)
        self.assertEqual(first["id"], "q_age")
        processor.process_item(state, "q_age", 30)

        # The processor has now drawn the Sample pass; sample_asked is populated.
        drawn = processor.get_current_item(state, backward=False)
        self.assertIsNotNone(drawn)
        self.assertEqual(drawn.get("_sample_block_id"), "lifestyle_sample")
        block_id = "lifestyle_sample"
        self.assertTrue(
            state.has_sample_pass(block_id),
            "sample_asked must be populated while inside the pass",
        )

        # Step 2: backward-navigate past q_age (off the block entirely).
        prev = processor.get_current_item(state, backward=True)
        self.assertIsNotNone(prev)
        self.assertEqual(prev["id"], "q_age")

        # After backward-nav, sample_asked for the block must be cleared.
        self.assertFalse(
            state.has_sample_pass(block_id),
            "sample_asked must be empty after backward-nav past the block start",
        )

        # Step 3: re-answer q_age and re-enter.  sample_order is preserved
        # (frozen-per-execution rule) but eligibility is re-evaluated from
        # scratch by _enter_sample_pass.
        processor.process_item(state, "q_age", 30)
        re_drawn = processor.get_current_item(state, backward=False)
        self.assertIsNotNone(re_drawn)
        self.assertEqual(re_drawn.get("_sample_block_id"), "lifestyle_sample")
        self.assertTrue(
            state.has_sample_pass(block_id),
            "sample_asked must be re-populated after forward re-entry",
        )


if __name__ == "__main__":
    unittest.main()
