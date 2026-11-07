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
- A Range inner item (#1755): each iteration's answer is stored as the plain
  `[low, high]` pair, inside and after the roster `q.outcomes[K]` reads it with
  named ends, and the state stays JSON.
- A navigate-to-item jump back to a Roster item (#1808) lands on its first
  history entry in that entry's iteration, undoes the later iterations, and a
  re-answer stays one `(item, iteration)` entry, never an iteration-less one.
  Back and a jump re-enter an iteration alike: only what they take off history
  is un-visited (an answered item before the target is not presented again),
  and a truncated entry's codeBlock write is undone in `roster_outcomes` too,
  so re-entering the iteration does not bring it back.
- A direct `process_item` re-answer of a Roster item whose pass is done is a
  backward edit to its first entry, in that entry's iteration, never refused
  on a gate its own codeBlock moved.
- A Roster item never on the path with no live iteration (#1846): an API
  submit is refused (`roster_iteration_not_active`, the convenience save
  ignored) and a forward jump onto it is refused, while a forward jump inside
  the pass lands in the live iteration, so no `(roster item, None)` entry.
"""

import json
import unittest
from pathlib import Path

import pytest
from askalot_qml.api import flow_service
from askalot_qml.api.flow_service import FlowOutcome
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import CHANNEL_WEB, SOURCE_RESPONDENT, SOURCE_SYNTHETIC, QMLState

from tests.helpers.flow_walker import NavigationWalk

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
        result = processor.process_item(state, item_id, value, source=SOURCE_RESPONDENT)
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
            ("q_member_name", 1): 11,
            ("q_member_age", 1): 30,
            ("q_member_name", 2): 12,
            ("q_member_age", 2): 7,
            ("q_member_name", 4): 13,
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
        self.assertEqual(per_member[1], {"q_member_name": 11, "q_member_age": 30})
        self.assertEqual(per_member[2], {"q_member_name": 12, "q_member_age": 7})
        self.assertEqual(per_member[4], {"q_member_name": 13, "q_member_age": 4})

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
            ("q_member_name", 1): 14,
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
        result = processor.process_item(state, "q_meals_eaten", 6, source=SOURCE_RESPONDENT)
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
        processor.process_item(state, "q_meals_eaten", 7, source=SOURCE_RESPONDENT)

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
            ("q_member_name", 1): 21,
            ("q_member_age", 1): 10,
            ("q_member_name", 2): 22,
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
            ("q_member_name", 1): 21,
            ("q_member_age", 1): 10,
            ("q_member_name", 2): 22,
            ("q_member_age", 2): 20,
        }
        _walk_and_answer(processor, state, answers)

        # The dict-shape ItemProxy.outcomes consumers expect:
        ages_by_iter = state.get_roster_outcomes_for_item("per_member", "q_member_age")
        self.assertEqual(ages_by_iter, {1: 10, 2: 20})

        names_by_iter = state.get_roster_outcomes_for_item("per_member", "q_member_name")
        self.assertEqual(names_by_iter, {1: 21, 2: 22})



_QML_RANGE_IN_ROSTER = """
qmlVersion: "2.5"
questionnaire:
  title: Range in a Roster
  blocks:
    - id: count_block
      kind: Group
      items:
        - id: q_count
          kind: Question
          title: How many?
          input:
            control: Editbox
            min: 1
            max: 2
          codeBlock: "member_mask = 2 ** q_count.outcome - 1"
    - id: per_member
      kind: Roster
      iterateOver: member_mask
      labels:
        1: Member 1
        2: Member 2
      items:
        - id: q_span
          kind: Question
          title: Which range of hours?
          input:
            control: Range
            min: 0
            max: 10
          postcondition:
            - predicate: "q_span.outcome.high - q_span.outcome.low <= 6"
              hint: At most six hours
    - id: after
      kind: Group
      items:
        - id: q_wide_second
          kind: Question
          title: The second member's range ends late
          precondition:
            - predicate: "q_span.outcomes[2].high >= 9"
          input:
            control: Switch
"""


class TestRangeInsideRoster(unittest.TestCase):
    def test_each_iteration_stores_a_plain_pair_read_by_name(self):
        state = QMLState(QMLLoader().load_from_string(_QML_RANGE_IN_ROSTER))
        processor = FlowProcessor(state)
        walked = _walk_and_answer(
            processor,
            state,
            {
                "q_count": 2,
                ("q_span", 1): [1, 4],
                ("q_span", 2): ["3", "9"],
                "q_wide_second": True,
            },
        )

        self.assertEqual(
            walked, [("q_count", None), ("q_span", 1), ("q_span", 2), ("q_wide_second", None)]
        )
        self.assertEqual(
            state.get_roster_outcomes_for_item("per_member", "q_span"), {1: [1, 4], 2: [3, 9]}
        )
        json.dumps(dict(state))

    def test_a_named_end_postcondition_holds_inside_the_roster(self):
        state = QMLState(QMLLoader().load_from_string(_QML_RANGE_IN_ROSTER))
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_count", 1, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)

        result = processor.process_item(state, "q_span", [0, 9], source=SOURCE_RESPONDENT)

        self.assertFalse(result.get("success"))


_QML_ROSTER_SELF_GATE = """
qmlVersion: "2.5"
questionnaire:
  title: Roster self gate
  codeInit: |
    v = 0
    mask = {mask}
  blocks:
    - id: per
      kind: Roster
      iterateOver: mask
      labels: {1: One, 2: Two}
      items:
        - id: q
          kind: Question
          title: Q
          precondition: [{predicate: "v == 0 or mask == 3"}]
          codeBlock: "v = 1"
          input: {control: Slider, min: 0, max: 10}
    - id: after
      items:
        - {id: q_end, kind: Question, title: End, input: {control: Switch}}
"""


class TestJumpBackIntoRoster(unittest.TestCase):
    """A navigate-to-item jump back to a Roster item lands in the iteration
    of the target's first history entry (#1808): a completed pass has cleared
    its iteration, and a re-answer given without one joined history as a
    second, iteration-less entry. q's own codeBlock also moves the gate it
    passed, so the re-answer is accepted only because it is found on the
    path under its iteration. With two items per iteration (q1, q2), Back
    and a jump re-enter alike: q1, still on the path, stays answered, and a
    truncated q2's codeBlock write into q1 is undone in its Roster cell.
    A Roster item never on the path, with no live iteration, can be neither
    answered nor jumped to (#1846)."""

    def _completed_pass(self, mask: int, answers: dict) -> tuple[FlowProcessor, QMLState]:
        qml = _QML_ROSTER_SELF_GATE.replace("{mask}", str(mask))
        state = QMLState(QMLLoader().load_from_string(qml))
        processor = FlowProcessor(state)
        _walk_and_answer(processor, state, answers)
        processor.get_current_item(state)
        return processor, state

    def _jump_to_q(self, state: QMLState):
        return flow_service.compute_navigate_to_item(
            NavigationWalk(state), None, target_item_id="q", source=SOURCE_RESPONDENT,
            channel=CHANNEL_WEB, external_input_resolver=None,
        )

    def test_a_jump_back_restores_the_iteration_and_a_re_answer_keeps_one_entry(self):
        processor, state = self._completed_pass(1, {("q", 1): 3, "q_end": True})
        self.assertIsNone(state.current_iter_key("q"), "the completed pass kept its iteration")

        step = self._jump_to_q(state)

        self.assertIs(step.outcome, FlowOutcome.ITEM)
        self.assertEqual(state.current_iter_key("q"), 1)
        self.assertEqual(step.item["iterationKey"], 1)
        self.assertEqual(step.item["outcome"], 3)
        self.assertEqual(state.get_history_with_iter(), [("q", 1)])

        result = processor.process_item(state, "q", 4, source=SOURCE_RESPONDENT)

        self.assertTrue(result["success"], result)
        self.assertEqual(state.get_history_with_iter(), [("q", 1)])
        self.assertEqual(state.get_roster_outcomes_for_item("per", "q"), {1: 4})

    def test_a_jump_back_lands_on_the_first_iteration_and_undoes_the_later_ones(self):
        processor, state = self._completed_pass(3, {("q", 1): 3, ("q", 2): 5, "q_end": True})

        self._jump_to_q(state)

        self.assertEqual(state.get_history_with_iter(), [("q", 1)])
        self.assertEqual(state.current_iter_key("q"), 1)
        processor.process_item(state, "q", 4, source=SOURCE_RESPONDENT)
        # The walk goes on into iteration 2, presented with its kept answer.
        item = processor.get_current_item(state)
        self.assertEqual((item["id"], state.current_iter_key("q"), item["outcome"]), ("q", 2, 5))
        self.assertNotIn(("q", None), state.get_history_with_iter())

    # A two-item iteration: q1 then q2, whose codeBlock may write q1.

    def _two_item_pass(
        self, mask: int, answers: dict, code: str = "pass"
    ) -> tuple[FlowProcessor, QMLState]:
        qml = _QML_ROSTER_TWO_ITEMS.replace("{mask}", str(mask)).replace("{code}", code)
        state = QMLState(QMLLoader().load_from_string(qml))
        processor = FlowProcessor(state)
        _walk_and_answer(processor, state, answers)
        processor.get_current_item(state)
        return processor, state

    def _jump(self, state: QMLState, target: str):
        return flow_service.compute_navigate_to_item(
            NavigationWalk(state), None, target_item_id=target, source=SOURCE_RESPONDENT,
            channel=CHANNEL_WEB, external_input_resolver=None,
        )

    def _assert_re_answer_moves_on(self, processor: FlowProcessor, state: QMLState) -> None:
        """Re-answering q2 finishes the iteration: q1, still on the path before
        it, is neither re-presented nor given a second entry."""
        self.assertTrue(state.get_item("q1")["visited"], "q1 is still on the path")
        processor.process_item(state, "q2", 3, source=SOURCE_RESPONDENT)
        item = processor.get_current_item(state)
        self.assertEqual(item["id"], "q_end")
        self.assertEqual(
            state.get_history_with_iter(), [("q1", 1), ("q2", 1), ("q_end", None)]
        )

    def test_a_jump_back_un_visits_only_what_it_truncates(self):
        processor, state = self._two_item_pass(1, {"q1": 1, "q2": 2, "q_end": True})

        self._jump(state, "q2")

        self._assert_re_answer_moves_on(processor, state)

    def test_back_into_a_completed_roster_un_visits_only_what_it_pops(self):
        processor, state = self._two_item_pass(1, {"q1": 1, "q2": 2, "q_end": True})

        item = processor.get_current_item(state, backward=True)

        self.assertEqual((item["id"], state.current_iter_key("q2")), ("q2", 1))
        self._assert_re_answer_moves_on(processor, state)

    def test_a_jump_back_undoes_a_later_entry_s_write_into_the_iteration(self):
        processor, state = self._two_item_pass(
            1, {"q1": 1, "q2": 2, "q_end": True}, code="q1.outcome = 9"
        )
        self.assertEqual(state.get_roster_outcomes_for_item("per", "q1"), {1: 9})

        step = self._jump(state, "q1")

        self.assertEqual(step.item["outcome"], 1)
        self.assertEqual(state.get_item("q1")["outcome"], 1)
        self.assertEqual(state.get_roster_outcomes_for_item("per", "q1"), {1: 1})

    def test_back_undoes_a_later_entry_s_write_into_the_iteration(self):
        processor, state = self._two_item_pass(
            1, {"q1": 1, "q2": 2, "q_end": True}, code="q1.outcome = 9"
        )

        processor.get_current_item(state, backward=True)
        item = processor.get_current_item(state, backward=True)

        self.assertEqual((item["id"], item["outcome"]), ("q1", 1))
        self.assertEqual(state.get_roster_outcomes_for_item("per", "q1"), {1: 1})

    def test_a_jump_back_undoes_the_writes_of_every_truncated_iteration(self):
        processor, state = self._two_item_pass(
            3,
            {("q1", 1): 1, ("q2", 1): 2, ("q1", 2): 5, ("q2", 2): 6, "q_end": True},
            code="q1.outcome = 9",
        )
        self.assertEqual(state.get_roster_outcomes_for_item("per", "q1"), {1: 9, 2: 9})

        step = self._jump(state, "q1")

        # Each iteration's cell gets back the answer the undone codeBlock
        # overwrote; iteration 2's answer stays, as every truncated answer does.
        self.assertEqual(step.item["outcome"], 1)
        self.assertEqual(state.get_roster_outcomes_for_item("per", "q1"), {1: 1, 2: 5})

    # A Roster item never on the path, with no live iteration (#1846).

    def test_a_submit_after_the_pass_never_records_a_none_iteration(self):
        """An empty pass (mask 0) is over and q1 was never on the path: an
        API submit to q1 belongs to no iteration, so it is refused, and the
        convenience save is ignored."""
        processor, state = self._two_item_pass(0, {"q_end": True})
        history = state.get_history_with_iter()
        events = len(state.get_timing_events())

        result = processor.process_item(state, "q1", 4, source=SOURCE_SYNTHETIC)

        self.assertFalse(result["success"])
        self.assertEqual(result["reason"], "roster_iteration_not_active")
        self.assertEqual(state.get_history_with_iter(), history)
        self.assertEqual(len(state.get_timing_events()), events)
        self.assertIsNone(state.get_item("q1")["outcome"])
        ignored = processor.process_item(
            state, "q1", 4, source=SOURCE_RESPONDENT, skip_postcondition=True
        )
        self.assertEqual(ignored, {"success": True, "ignored": "roster_iteration_not_active"})
        self.assertNotIn(("q1", None), state.get_history_with_iter())

    def test_a_submit_before_the_pass_is_refused(self):
        state = QMLState(QMLLoader().load_from_string(
            _QML_ROSTER_TWO_ITEMS.replace("{mask}", "1").replace("{code}", "pass")
        ))
        processor = FlowProcessor(state)

        result = processor.process_item(state, "q1", 4, source=SOURCE_SYNTHETIC)

        self.assertEqual(result["reason"], "roster_iteration_not_active")
        self.assertEqual(state.get_history_with_iter(), [])

    def test_a_forward_jump_before_the_pass_is_refused(self):
        state = QMLState(QMLLoader().load_from_string(
            _QML_ROSTER_TWO_ITEMS.replace("{mask}", "1").replace("{code}", "pass")
        ))

        step = self._jump(state, "q1")

        self.assertIs(step.outcome, FlowOutcome.NAVIGATION_REFUSED)
        self.assertEqual(state.get_history_with_iter(), [])

    def test_a_forward_jump_inside_the_pass_lands_in_its_iteration(self):
        state = QMLState(QMLLoader().load_from_string(
            _QML_ROSTER_TWO_ITEMS.replace("{mask}", "3").replace("{code}", "pass")
        ))
        processor = FlowProcessor(state)
        self.assertEqual(processor.get_current_item(state)["id"], "q1")
        processor.process_item(state, "q1", 1, source=SOURCE_RESPONDENT)

        step = self._jump(state, "q2")

        self.assertIs(step.outcome, FlowOutcome.ITEM)
        self.assertEqual(state.get_history_with_iter(), [("q1", 1), ("q2", 1)])


_QML_ROSTER_TWO_ITEMS = """
qmlVersion: "2.5"
questionnaire:
  title: Roster two items
  codeInit: |
    mask = {mask}
  blocks:
    - id: per
      kind: Roster
      iterateOver: mask
      labels: {1: One, 2: Two}
      items:
        - {id: q1, kind: Question, title: Q1, input: {control: Slider, min: 0, max: 10}}
        - id: q2
          kind: Question
          title: Q2
          codeBlock: "{code}"
          input: {control: Slider, min: 0, max: 10}
    - id: after
      items:
        - {id: q_end, kind: Question, title: End, input: {control: Switch}}
"""


class TestDirectReanswerOfACompletedRoster(unittest.TestCase):
    """An answer sent straight to `process_item` (Portor's
    `submit_survey_response`, no jump) for a Roster item of a completed pass
    is a backward edit: the item is on the path under its iteration, so its
    gate is not judged again, and the answer lands under that entry's
    iteration with its Roster snapshot — never under no iteration. q's own
    codeBlock moved the gate it passed (`v == 0`, then `v = 1`)."""

    def _completed_pass(self, mask: int, answers: dict) -> tuple[FlowProcessor, QMLState]:
        qml = _QML_ROSTER_SELF_GATE.replace("{mask}", str(mask))
        state = QMLState(QMLLoader().load_from_string(qml))
        processor = FlowProcessor(state)
        _walk_and_answer(processor, state, answers)
        processor.get_current_item(state)
        return processor, state

    def test_a_re_answer_is_a_backward_edit_under_the_entry_s_iteration(self):
        processor, state = self._completed_pass(1, {"q": 3, "q_end": True})
        self.assertIsNone(state.current_iter_key("q"))

        result = processor.process_item(state, "q", 4, source=SOURCE_RESPONDENT)

        self.assertTrue(result["success"], result)
        # The edit rewinds to q's entry; q_end is re-reached afterwards.
        self.assertEqual(state.get_history_with_iter(), [("q", 1)])
        self.assertEqual(state.get_roster_outcomes_for_item("per", "q"), {1: 4})
        self.assertEqual(processor.get_current_item(state)["id"], "q_end")

    def test_a_re_answer_lands_on_the_first_iteration_as_a_jump_does(self):
        processor, state = self._completed_pass(3, {("q", 1): 3, ("q", 2): 5, "q_end": True})

        result = processor.process_item(state, "q", 4, source=SOURCE_RESPONDENT)

        self.assertTrue(result["success"], result)
        self.assertEqual(state.get_history_with_iter(), [("q", 1)])
        self.assertEqual(state.get_roster_outcomes_for_item("per", "q"), {1: 4, 2: 5})
        item = processor.get_current_item(state)
        self.assertEqual((item["id"], state.current_iter_key("q"), item["outcome"]), ("q", 2, 5))


if __name__ == "__main__":
    unittest.main()
