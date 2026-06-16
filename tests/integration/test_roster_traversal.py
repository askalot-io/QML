#!/usr/bin/env python3
"""Integration tests for U3: FlowProcessor Roster traversal.

This test suite exercises the U3 deliverable from the Roster plan
end-to-end via real .qml fixtures, the loader, the topology builder, and
the FlowProcessor. It covers the AE1, AE2, AE3 scenarios from the plan
plus the headline edge cases (mid-survey mask change, mask=0, sparse
inner preconditions).

Architecture under test (all wired together by these tests):

  fixtures/roster_numeric.qml       (Canonical Example B — numeric count)
  fixtures/roster_multiselect.qml   (Canonical Example A — Checkbox-driven)
  fixtures/roster_inner_precondition.qml (inner precondition referencing outer)
            ↓
  QMLLoader (U1)
            ↓
  QMLState + ItemProxy (U2)
            ↓
  FlowProcessor (U3) — iteration-major depth-first traversal,
            ↓        snapshot/restore around process_item, mid-survey
            ↓        mask change retain-but-hidden, backward navigation
            ↓        across iter and roster boundaries.
            ↓
  Per-iteration outcomes in state['roster_outcomes'][block][iter]
  History pairs in state['history'] / state['history_iter_key']

## Coverage areas

- AE1: Numeric-count (Example B). q_family_count=3 → mask=7 → walks 3 iters
       × 2 items, leaves bit 8 absent.
- AE2: Multiselect (Example A). q_meals_eaten=5 → walks 2 iters (Breakfast,
       Dinner), leaves Lunch and Snack absent.
- AE3: Backward navigation. From iter=4 q_notes back to iter=4 q_satisfaction
       → iter=1 q_notes → iter=1 q_satisfaction → exits roster to outer.
- iterateOver=0 → empty roster pass; flow advances to next non-roster item.
- Mid-survey mask shrink (5 → 6, Breakfast→Lunch swap): retain-but-hidden by
  label-key. Bit 1 keeps its data hidden in roster_outcomes; bit 2 fresh
  empty slot; bit 4 retains.
- Mid-survey mask grow (5 → 7, add Lunch): new bit 2 gets fresh slot, bits 1
  and 4 retain.
- Inner precondition referencing outer item (roster_inner_precondition.qml):
  resolves correctly within roster context via snapshot/restore.
- Outside-roster read of `q.outcomes[K]` after roster completion: dict-shape
  accessor works for post-roster preconditions and codeBlocks.
"""

import unittest
from pathlib import Path

import pytest
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import QMLState

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def _load(fixture_name: str) -> tuple[FlowProcessor, QMLState]:
    """Load a fixture and return (processor, state) ready for traversal."""
    loader = QMLLoader(qml_dir=FIXTURES_DIR)
    questionnaire = loader.load_from_file(fixture_name)
    state = QMLState(questionnaire)
    processor = FlowProcessor(state)
    return processor, state


def _walk_and_answer(
    processor: FlowProcessor,
    state: QMLState,
    answer_for: dict,
) -> list[tuple[str, int | None]]:
    """
    Drive the processor forward, answering each item with the value mapped to
    its (item_id, iter_key) tuple in `answer_for`. Returns the ordered list of
    (item_id, iter_key) tuples the processor presented.

    `answer_for` keys may be:
      - bare item_id (str) — answer used for every iteration of that item
      - (item_id, iter_key) tuple — exact-match takes precedence

    Raises if the processor hands the test an item we have no answer for.
    """
    walked: list[tuple[str, int | None]] = []
    for _step in range(200):  # generous safety bound
        item = processor.get_current_item(state, backward=False)
        if item is None:
            break
        # Drop the post-completion "isLast" recap entry — it's a redisplay of
        # the last item the user actually saw, not a new presentation. The
        # walker is interested in the user-visible step sequence.
        if item.get("isLast"):
            break

        item_id = item["id"]
        iter_key = _current_iter_for(item, state)
        walked.append((item_id, iter_key))

        # Resolve the answer: prefer (id, iter) over bare id.
        if (item_id, iter_key) in answer_for:
            value = answer_for[(item_id, iter_key)]
        elif item_id in answer_for:
            value = answer_for[item_id]
        else:
            raise AssertionError(
                f"Test fixture has no answer for ({item_id}, iter_key={iter_key}); "
                f"walked so far: {walked!r}"
            )

        # Native shape: bare value passed directly (plan 2026-05-05-001).
        result = processor.process_item(state, item_id, value)
        assert result.get("success"), f"process_item failed for {item_id}: {result}"
    else:
        raise AssertionError(f"Walked >200 items — likely a navigation loop: {walked!r}")
    return walked


def _current_iter_for(item: dict, state: QMLState) -> int | None:
    """Return current iter_key for a roster item, or None for non-roster items."""
    block_id = item.get("_roster_block_id")
    return state.get_current_roster_iter(block_id) if block_id else None


# ---------------------------------------------------------------------------
# AE1 — Numeric-count roster (Canonical Example B)
# ---------------------------------------------------------------------------


class TestAE1NumericRoster(unittest.TestCase):
    """q_family_count=3 → family_mask=7 → bits {1, 2, 4} active. Walk 6 pages."""

    def test_full_walk_populates_three_iterations(self):
        processor, state = _load("roster_numeric.qml")

        answers = {
            "q_family_count": 3,
            ("q_member_name", 1): "Alice",
            ("q_member_age", 1): 30,
            ("q_member_name", 2): "Bob",
            ("q_member_age", 2): 7,
            ("q_member_name", 4): "Carol",
            ("q_member_age", 4): 4,
        }
        walked = _walk_and_answer(processor, state, answers)

        # Expected page order: outer count first, then iteration-major DFS.
        expected = [
            ("q_family_count", None),
            ("q_member_name", 1),
            ("q_member_age", 1),
            ("q_member_name", 2),
            ("q_member_age", 2),
            ("q_member_name", 4),
            ("q_member_age", 4),
        ]
        self.assertEqual(walked, expected)

        per_member = state["roster_outcomes"]["per_member"]
        self.assertEqual(sorted(per_member.keys()), [1, 2, 4])
        self.assertEqual(per_member[1], {"q_member_name": "Alice", "q_member_age": 30})
        self.assertEqual(per_member[2], {"q_member_name": "Bob", "q_member_age": 7})
        self.assertEqual(per_member[4], {"q_member_name": "Carol", "q_member_age": 4})

        # Bit 8 (Member 4) was not in the active mask → no entry.
        self.assertNotIn(8, per_member)


# ---------------------------------------------------------------------------
# AE2 — Multiselect-driven roster (Canonical Example A)
# ---------------------------------------------------------------------------


class TestAE2MultiselectRoster(unittest.TestCase):
    """q_meals_eaten=5 (Breakfast+Dinner) → bits {1, 4} active. Walk 4 pages."""

    def test_full_walk_populates_two_iterations(self):
        processor, state = _load("roster_multiselect.qml")

        answers = {
            "q_meals_eaten": 5,  # Breakfast (1) + Dinner (4)
            ("q_satisfaction", 1): 4,
            ("q_notes", 1): "rushed",
            ("q_satisfaction", 4): 5,
            ("q_notes", 4): "great",
        }
        walked = _walk_and_answer(processor, state, answers)

        expected = [
            ("q_meals_eaten", None),
            ("q_satisfaction", 1),
            ("q_notes", 1),
            ("q_satisfaction", 4),
            ("q_notes", 4),
        ]
        self.assertEqual(walked, expected)

        per_meal = state["roster_outcomes"]["per_meal"]
        self.assertEqual(sorted(per_meal.keys()), [1, 4])
        self.assertEqual(per_meal[1], {"q_satisfaction": 4, "q_notes": "rushed"})
        self.assertEqual(per_meal[4], {"q_satisfaction": 5, "q_notes": "great"})


# ---------------------------------------------------------------------------
# AE3 — Backward navigation through iter boundaries and out of roster
# ---------------------------------------------------------------------------


class TestAE3BackwardNavigation(unittest.TestCase):
    def test_back_steps_through_iters_and_exits_roster(self):
        processor, state = _load("roster_multiselect.qml")
        # Walk forward fully first. Last user-visible page is q_notes @ iter=4.
        answers = {
            "q_meals_eaten": 5,
            ("q_satisfaction", 1): 4,
            ("q_notes", 1): "rushed",
            ("q_satisfaction", 4): 5,
            ("q_notes", 4): "great",
        }
        _walk_and_answer(processor, state, answers)

        # Standard backward semantics: pop current (q_notes @ iter=4), return
        # the prior history entry (q_satisfaction @ iter=4). After the four
        # backward steps below we land back on q_meals_eaten (the outer item).
        prev = processor.get_current_item(state, backward=True)
        self.assertIsNotNone(prev)
        self.assertEqual(prev["id"], "q_satisfaction")
        self.assertEqual(state.get_current_roster_iter("per_meal"), 4)

        prev = processor.get_current_item(state, backward=True)
        self.assertEqual(prev["id"], "q_notes")
        self.assertEqual(state.get_current_roster_iter("per_meal"), 1)

        prev = processor.get_current_item(state, backward=True)
        self.assertEqual(prev["id"], "q_satisfaction")
        self.assertEqual(state.get_current_roster_iter("per_meal"), 1)

        # One more back exits the roster pass and returns to q_meals_eaten.
        prev = processor.get_current_item(state, backward=True)
        self.assertEqual(prev["id"], "q_meals_eaten")
        # Roster pass state is cleared on exit.
        self.assertIsNone(state.get_current_roster_iter("per_meal"))


# ---------------------------------------------------------------------------
# Edge case — iterateOver=0 → empty pass, flow advances past the roster
# ---------------------------------------------------------------------------


class TestEmptyMaskSkipsRoster(unittest.TestCase):
    def test_zero_mask_advances_past_roster(self):
        processor, state = _load("roster_multiselect.qml")
        # Answer Checkbox with 0 (no meals selected).
        answers = {"q_meals_eaten": 0}
        walked = _walk_and_answer(processor, state, answers)
        # Only one page: q_meals_eaten. The roster is skipped entirely.
        self.assertEqual(walked, [("q_meals_eaten", None)])
        self.assertEqual(state["roster_outcomes"].get("per_meal", {}), {})

    def test_numeric_count_zero_skips_roster(self):
        # roster_numeric.qml has min=1 on q_family_count, but we can simulate
        # a zero-mask by passing 1 and noting mask = 2**1 - 1 = 1 → only iter=1.
        # For mask=0 we'd need count=0 (out of range) — this asserts the mask=1
        # case works as a sanity check that small-N rosters still iterate.
        processor, state = _load("roster_numeric.qml")
        answers = {
            "q_family_count": 1,
            ("q_member_name", 1): "Solo",
            ("q_member_age", 1): 42,
        }
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(
            walked,
            [
                ("q_family_count", None),
                ("q_member_name", 1),
                ("q_member_age", 1),
            ],
        )
        self.assertEqual(sorted(state["roster_outcomes"]["per_member"].keys()), [1])


# ---------------------------------------------------------------------------
# Mid-survey mask change — retain-but-hidden by label_key
# ---------------------------------------------------------------------------


class TestMidSurveyMaskChange(unittest.TestCase):
    def test_swap_breakfast_for_lunch_retains_dinner_hides_breakfast(self):
        processor, state = _load("roster_multiselect.qml")
        # Initial walk with mask=5 (Breakfast+Dinner).
        first_walk = {
            "q_meals_eaten": 5,
            ("q_satisfaction", 1): 4,
            ("q_notes", 1): "rushed",
            ("q_satisfaction", 4): 5,
            ("q_notes", 4): "great",
        }
        _walk_and_answer(processor, state, first_walk)

        # Backward all the way to q_meals_eaten.
        for _ in range(5):
            prev = processor.get_current_item(state, backward=True)
            if prev and prev["id"] == "q_meals_eaten":
                break

        # Re-answer with mask=6 (Lunch+Dinner). Bit 1 dropped, bit 2 added,
        # bit 4 retained.
        result = processor.process_item(state, "q_meals_eaten", 6)
        self.assertTrue(result.get("success"))

        # Walk forward through the new pass.
        # Lunch (bit 2) is fresh; Dinner (bit 4) retains its prior values
        # (the user can edit but they're pre-populated).
        answers_after = {
            ("q_satisfaction", 2): 3,
            ("q_notes", 2): "short break",
            # Dinner: re-confirm the prior values without changing them.
            ("q_satisfaction", 4): 5,
            ("q_notes", 4): "great",
        }
        walked = _walk_and_answer(processor, state, answers_after)
        self.assertEqual(
            walked,
            [
                ("q_satisfaction", 2),
                ("q_notes", 2),
                ("q_satisfaction", 4),
                ("q_notes", 4),
            ],
        )

        per_meal = state["roster_outcomes"]["per_meal"]
        # Bit 1 (Breakfast) data is RETAINED-BUT-HIDDEN — still in storage.
        self.assertIn(1, per_meal)
        self.assertEqual(per_meal[1], {"q_satisfaction": 4, "q_notes": "rushed"})
        # New bit 2 populated.
        self.assertEqual(per_meal[2], {"q_satisfaction": 3, "q_notes": "short break"})
        # Bit 4 retained.
        self.assertEqual(per_meal[4], {"q_satisfaction": 5, "q_notes": "great"})

    def test_grow_mask_keeps_existing_iters_and_adds_new(self):
        processor, state = _load("roster_multiselect.qml")
        # Initial walk with mask=5.
        _walk_and_answer(
            processor,
            state,
            {
                "q_meals_eaten": 5,
                ("q_satisfaction", 1): 4,
                ("q_notes", 1): "rushed",
                ("q_satisfaction", 4): 5,
                ("q_notes", 4): "great",
            },
        )

        # Back to q_meals_eaten, grow mask to 7 (add Lunch).
        for _ in range(5):
            prev = processor.get_current_item(state, backward=True)
            if prev and prev["id"] == "q_meals_eaten":
                break
        processor.process_item(state, "q_meals_eaten", 7)

        # Forward walk should re-traverse all 3 active iters but only NEW iter
        # (bit 2) needs fresh answers; existing iters can be re-answered.
        walked = _walk_and_answer(
            processor,
            state,
            {
                ("q_satisfaction", 1): 4,
                ("q_notes", 1): "rushed",
                ("q_satisfaction", 2): 3,
                ("q_notes", 2): "new lunch",
                ("q_satisfaction", 4): 5,
                ("q_notes", 4): "great",
            },
        )
        self.assertEqual(
            walked,
            [
                ("q_satisfaction", 1),
                ("q_notes", 1),
                ("q_satisfaction", 2),
                ("q_notes", 2),
                ("q_satisfaction", 4),
                ("q_notes", 4),
            ],
        )
        per_meal = state["roster_outcomes"]["per_meal"]
        self.assertEqual(sorted(per_meal.keys()), [1, 2, 4])


# ---------------------------------------------------------------------------
# Inner-precondition referencing outer item resolves through roster context
# ---------------------------------------------------------------------------


class TestInnerPreconditionReferencesOuter(unittest.TestCase):
    def test_inner_precondition_resolves_outer_outcome(self):
        processor, state = _load("roster_inner_precondition.qml")
        answers = {
            "q_family_count": 2,  # mask = 3 → bits {1, 2}
            ("q_member_name", 1): "A",
            ("q_member_age", 1): 10,
            ("q_member_name", 2): "B",
            ("q_member_age", 2): 20,
        }
        walked = _walk_and_answer(processor, state, answers)
        # All four roster pages run because q_family_count.outcome > 0 is True.
        expected = [
            ("q_family_count", None),
            ("q_member_name", 1),
            ("q_member_age", 1),
            ("q_member_name", 2),
            ("q_member_age", 2),
        ]
        self.assertEqual(walked, expected)


# ---------------------------------------------------------------------------
# Outside-roster read of dict-shaped outcomes (post-roster context)
# ---------------------------------------------------------------------------


class TestOutsideRosterDictAccess(unittest.TestCase):
    def test_post_roster_outcomes_dict_is_correct(self):
        processor, state = _load("roster_numeric.qml")
        answers = {
            "q_family_count": 2,
            ("q_member_name", 1): "A",
            ("q_member_age", 1): 10,
            ("q_member_name", 2): "B",
            ("q_member_age", 2): 20,
        }
        _walk_and_answer(processor, state, answers)

        # The dict-shape ItemProxy.outcomes consumers expect:
        ages_by_iter = state.get_roster_outcomes_for_item("per_member", "q_member_age")
        self.assertEqual(ages_by_iter, {1: 10, 2: 20})

        names_by_iter = state.get_roster_outcomes_for_item("per_member", "q_member_name")
        self.assertEqual(names_by_iter, {1: "A", 2: "B"})


if __name__ == "__main__":
    unittest.main()
