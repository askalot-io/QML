#!/usr/bin/env python3
"""Integration tests for U5: FlowProcessor capped-Group runtime traversal.

This suite exercises the U5 deliverable of the block-kind collapse plan
(docs/plans/2026-06-17-001-refactor-qml-block-kinds-group-collapse-plan.md)
end-to-end via inline `kind: Group` QML, the real loader, the topology
builder, and the FlowProcessor. The Sample kind is gone (collapsed into an
optional `count` on Group); there is no randomization and no frozen per-block
order. The draw order is the global ``navigation_path`` FILTERED to the
block's inner item ids — a projection, NOT a positional slice (global
stable-Kahn can interleave another block's items between this Group's items).

Architecture under test:

  inline `kind: Group` QML (count omitted → ask all; count: N → first-N draw)
            ↓
  QMLLoader (U1/U2)  →  QMLState (U4)  →  FlowProcessor (U5)
            ↓
  state['group_asked'][block_id]  — per-pass drawn-slot list (draw order),
            re-derived every pass from the navigation_path projection
  history pairs in state['history'] / state['history_iter_key'] (iter_key=None
            for Group — a Group has no per-iteration identity, only a draw set)

## Coverage

- AE1: no-`count` Group → all in-scope items asked in canonical order.
- AE2: `count`, more eligible items than the cap → first N asked; rest absent.
- AE3: `count`, a precondition-False item → free pass, next eligible consume slots.
- AE4: `count`, eligible pool below the cap → fewer asked; draw ends on exhaustion.
- AE5: backward nav with no edit → asked-set unchanged, answers preserved.
- AE8: `count >= item_count`, all eligible → asks all (no spurious rejection).
- AE13: backward edit flips a free-pass item into the count → a previously
  drawn-and-answered item is EVICTED (absent from history AND outcome cleared).
- AE14: all preconditions false → empty draw, block skipped, recap preserved.
- AE15: false block-level precondition → whole block absent.
- AE19: benign backward nav (no precondition change) preserves all answers
  (the eviction clear must NOT fire on an unchanged draw).
- Projection: a cross-block dependency makes the Group's items NON-CONTIGUOUS
  in the global navigation_path; the draw still walks exactly the block's
  members in global order (proving projection, not positional slice).
- C1 (on-reach eligibility): an inner item whose precondition depends on a
  cross-block item that sorts BETWEEN group members is NOT eligible at first
  block entry but BECOMES eligible once the forward walk reaches the outer
  item. The evaluate-on-reach model presents it; the old frozen-at-entry draw
  silently dropped it.
- A1 (eviction scope): a codeInit/codeBlock-set outcome on an inner item the
  group never asked MUST survive — only items the group actually asked may be
  evicted/cleared.
- T4 (backward-nav clears group_asked): driving the FlowProcessor backward out
  of an incomplete capped-Group pass clears has_group_pass() so re-entry
  re-derives eligibility (the Group analogue of the retired Sample test).

All tests drive the FlowProcessor through the shared
``tests/helpers/flow_walker.walk_and_answer`` driver (no per-file walker).
Where the Sample suite asserted "one of T! orderings" the Group suite asserts
"exactly canonical first-N" — the draw is fully deterministic.
"""

import unittest

from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import SOURCE_RESPONDENT, QMLState

from tests.helpers.flow_walker import walk_and_answer as _walk_and_answer


def _load(qml: str) -> tuple[FlowProcessor, QMLState]:
    """Load inline QML through the real loader + schema and return
    (processor, state) ready for traversal."""
    loader = QMLLoader()
    questionnaire = loader.load_from_string(qml)
    state = QMLState(questionnaire)
    processor = FlowProcessor(state)
    return processor, state


# ---------------------------------------------------------------------------
# Inline fixtures
# ---------------------------------------------------------------------------

# No-`count` Group: every in-scope item is asked once in canonical order.
QML_NO_COUNT = """
qmlVersion: "2.0"
questionnaire:
  title: "No-count Group asks all"
  blocks:
    - id: intro
      title: "Intro"
      items:
        - id: q_intro
          kind: Question
          title: "Ready?"
          input:
            control: Editbox
            min: 0
            max: 1
    - id: pref_group
      kind: Group
      title: "Preferences"
      items:
        - id: q_a
          kind: Question
          title: "A?"
          input: {control: Slider, min: 0, max: 10}
        - id: q_b
          kind: Question
          title: "B?"
          input: {control: Slider, min: 0, max: 10}
        - id: q_c
          kind: Question
          title: "C?"
          input: {control: Slider, min: 0, max: 10}
    - id: outro
      title: "Outro"
      items:
        - id: q_thanks
          kind: Question
          title: "Bye?"
          input:
            control: Editbox
            min: 0
            max: 1
"""

# Capped Group: count=3 over five inner items; two carry preconditions on the
# OUTER q_age. The block items are INDEPENDENT of each other (cross-block
# dependency on q_age only) so the capped-Group independence rule is satisfied.
QML_BASIC = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group — count=3, five items, two outer-gated"
  blocks:
    - id: screen_block
      title: "Screening"
      items:
        - id: q_age
          kind: Question
          title: "How old are you?"
          input:
            control: Editbox
            min: 0
            max: 120
    - id: lifestyle_group
      kind: Group
      title: "Lifestyle questions"
      count: 3
      items:
        - id: q_s1
          kind: Question
          title: "Sleep hours?"
          input: {control: Slider, min: 0, max: 12}
        - id: q_s2
          kind: Question
          title: "Alcohol units (adults)?"
          input: {control: Editbox, min: 0, max: 100}
          precondition:
            - predicate: "q_age.outcome >= 18"
              hint: "Adults only"
        - id: q_s3
          kind: Question
          title: "Exercise sessions?"
          input: {control: Slider, min: 0, max: 7}
        - id: q_s4
          kind: Question
          title: "Screen time (teens+)?"
          input: {control: Slider, min: 0, max: 24}
          precondition:
            - predicate: "q_age.outcome >= 13"
              hint: "13 and older"
        - id: q_s5
          kind: Question
          title: "Coffee cups?"
          input: {control: Editbox, min: 0, max: 30}
    - id: outro_block
      title: "Outro"
      items:
        - id: q_thanks
          kind: Question
          title: "Anything else?"
          input:
            control: Editbox
            min: 0
            max: 1
"""

# count >= item_count fixture (AE8). Real `count: 99` through the loader — the
# cap exceeds the five inner items, so all are asked (no spurious rejection).
# All inner items are unconditionally eligible (no preconditions) so the cap is
# the only thing under test.
QML_COUNT_GE_ITEMS = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group — count exceeds item count"
  blocks:
    - id: screen_block
      title: "Screening"
      items:
        - id: q_age
          kind: Question
          title: "How old are you?"
          input:
            control: Editbox
            min: 0
            max: 120
    - id: lifestyle_group
      kind: Group
      title: "Lifestyle questions"
      count: 99
      items:
        - id: q_s1
          kind: Question
          title: "Sleep hours?"
          input: {control: Slider, min: 0, max: 12}
        - id: q_s2
          kind: Question
          title: "Alcohol units?"
          input: {control: Editbox, min: 0, max: 100}
        - id: q_s3
          kind: Question
          title: "Exercise sessions?"
          input: {control: Slider, min: 0, max: 7}
        - id: q_s4
          kind: Question
          title: "Screen time?"
          input: {control: Slider, min: 0, max: 24}
        - id: q_s5
          kind: Question
          title: "Coffee cups?"
          input: {control: Editbox, min: 0, max: 30}
    - id: outro_block
      title: "Outro"
      items:
        - id: q_thanks
          kind: Question
          title: "Anything else?"
          input:
            control: Editbox
            min: 0
            max: 1
"""

# Eviction fixture (AE13 / AE19). count=2, projection order [g1, g2, g3].
# q_mode is an OUTER switch: g1's precondition is `q_mode.outcome == 1`.
# - q_mode == 0 → g1 is a FREE PASS; g2, g3 consume the two slots → drawn
#   = [g2, g3].
# - q_mode == 1 → g1 consumes slot 1, g2 slot 2 → drawn = [g1, g2]; g3 evicted.
QML_EVICTION = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group eviction"
  blocks:
    - id: mode_block
      title: "Mode"
      items:
        - id: q_mode
          kind: Question
          title: "Mode?"
          input:
            control: Editbox
            min: 0
            max: 1
    - id: pick_group
      kind: Group
      title: "Pick two"
      count: 2
      items:
        - id: g1
          kind: Question
          title: "G1 (mode-gated)?"
          input: {control: Slider, min: 0, max: 10}
          precondition:
            - predicate: "q_mode.outcome == 1"
              hint: "Only in mode 1"
        - id: g2
          kind: Question
          title: "G2?"
          input: {control: Slider, min: 0, max: 10}
        - id: g3
          kind: Question
          title: "G3?"
          input: {control: Slider, min: 0, max: 10}
    - id: tail_block
      title: "Tail"
      items:
        - id: q_tail
          kind: Question
          title: "Tail?"
          input:
            control: Editbox
            min: 0
            max: 1
"""

# All-preconditions-false fixture (AE14): every inner item gated by q_gate>=50;
# with q_gate=0 none are eligible → empty draw, block skipped.
QML_ALL_SKIPPED = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group all skipped"
  blocks:
    - id: gate_block
      title: "Gate"
      items:
        - id: q_gate
          kind: Question
          title: "Gate?"
          input:
            control: Editbox
            min: 0
            max: 100
    - id: skip_group
      kind: Group
      title: "Skippable"
      count: 2
      items:
        - id: q_x
          kind: Question
          title: "X?"
          input: {control: Slider, min: 0, max: 10}
          precondition:
            - predicate: "q_gate.outcome >= 50"
        - id: q_y
          kind: Question
          title: "Y?"
          input: {control: Slider, min: 0, max: 10}
          precondition:
            - predicate: "q_gate.outcome >= 50"
    - id: tail_block
      title: "Tail"
      items:
        - id: q_tail
          kind: Question
          title: "Tail?"
          input:
            control: Editbox
            min: 0
            max: 1
"""

# False block-level precondition fixture (AE15): the whole Group is gated off
# by a block-level precondition referencing the outer q_open.
QML_BLOCK_GATED = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group with false block precondition"
  blocks:
    - id: open_block
      title: "Open"
      items:
        - id: q_open
          kind: Question
          title: "Open?"
          input:
            control: Editbox
            min: 0
            max: 1
    - id: gated_group
      kind: Group
      title: "Only if open"
      count: 2
      precondition:
        - predicate: "q_open.outcome == 1"
      items:
        - id: g_a
          kind: Question
          title: "A?"
          input: {control: Slider, min: 0, max: 10}
        - id: g_b
          kind: Question
          title: "B?"
          input: {control: Slider, min: 0, max: 10}
        - id: g_c
          kind: Question
          title: "C?"
          input: {control: Slider, min: 0, max: 10}
    - id: tail_block
      title: "Tail"
      items:
        - id: q_tail
          kind: Question
          title: "Tail?"
          input:
            control: Editbox
            min: 0
            max: 1
"""

# Non-contiguous-projection fixture. The capped Group {gA, gB} has count=2.
# A FOREIGN item `f_mid` (in a later block) depends on gA, and gB depends on
# f_mid. Stable-Kahn therefore emits gA → f_mid → gB, so the Group's two items
# are NOT adjacent in navigation_path. A positional slice of the path would
# pick up f_mid (wrong); only filtering to the block's members yields the
# correct draw order [gA, gB]. The deps are all CROSS-BLOCK (f_mid is not a
# sibling of gA/gB), so the capped-Group independence rule is satisfied.
QML_NONCONTIGUOUS = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group with non-contiguous projection"
  blocks:
    - id: pair_group
      kind: Group
      title: "Pair"
      count: 2
      items:
        - id: gA
          kind: Question
          title: "A?"
          input: {control: Slider, min: 0, max: 10}
        - id: gB
          kind: Question
          title: "B (needs f_mid)?"
          input: {control: Slider, min: 0, max: 10}
          precondition:
            - predicate: "f_mid.outcome >= 0"
    - id: mid_block
      title: "Middle"
      items:
        - id: f_mid
          kind: Question
          title: "Mid (needs gA)?"
          input: {control: Slider, min: 0, max: 10}
          precondition:
            - predicate: "gA.outcome >= 0"
    - id: tail_block
      title: "Tail"
      items:
        - id: q_tail
          kind: Question
          title: "Tail?"
          input:
            control: Editbox
            min: 0
            max: 1
"""

# C1 — late-eligibility fixture. Group `gb` {count:2, items:[a, c]}; `c`'s
# precondition depends on the variable `g`, which `codeInit` sets to 0 and an
# OUTER item `f` (in a block that sorts BETWEEN the two group members) sets to
# 5 via its codeBlock. The cross-block dependency forces stable-Kahn to order
# the navigation_path as [a, f, c], so `c` is NOT eligible at first block entry
# (g still 0) but BECOMES eligible once the walk reaches and processes `f`.
#
# The frozen-at-entry draw evaluates `c` at first block entry (g=0 → ineligible),
# never draws it, finalizes the block, and silently drops `c`. The on-reach
# model evaluates `c` when the walk reaches it (after `f` ran g=5) → drawn.
QML_LATE_ELIGIBLE = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group with late-eligible cross-block member"
  codeInit: |
    g = 0
  blocks:
    - id: gb
      kind: Group
      title: "Pair"
      count: 2
      items:
        - id: a
          kind: Question
          title: "A?"
          input: {control: Slider, min: 0, max: 10}
        - id: c
          kind: Question
          title: "C (needs g>0)?"
          input: {control: Slider, min: 0, max: 10}
          precondition:
            - predicate: "g > 0"
    - id: mid_block
      title: "Middle"
      items:
        - id: f
          kind: Question
          title: "F (sets g, needs a)?"
          input: {control: Slider, min: 0, max: 10}
          precondition:
            - predicate: "a.outcome >= 0"
          codeBlock: |
            g = 5
"""

# A1 — eviction-scope fixture. count=1 Group over {g2_keep, g_drawn}. `codeInit`
# writes an outcome onto `g2_keep` (an inner item the group's count=1 draw will
# NOT ask) and binds it to a variable. A downstream OUTER item reads
# g2_keep.outcome. The group asks only `g_drawn` (first in canonical order); the
# group must NEVER clear g2_keep's codeInit-set outcome on eviction sweep.
QML_PRESET_NOT_DRAWN = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group must not evict a codeInit-set non-drawn member"
  codeInit: |
    g2_keep.outcome = 8
  blocks:
    - id: preset_group
      kind: Group
      title: "Preset"
      count: 1
      items:
        - id: g_drawn
          kind: Question
          title: "Drawn?"
          input: {control: Slider, min: 0, max: 10}
        - id: g2_keep
          kind: Question
          title: "Preset (not drawn)?"
          input: {control: Slider, min: 0, max: 10}
    - id: read_block
      title: "Read"
      items:
        - id: q_read
          kind: Question
          title: "Read preset?"
          input: {control: Editbox, min: 0, max: 100}
          codeBlock: |
            captured = g2_keep.outcome
        - id: q_final
          kind: Question
          title: "Final?"
          input: {control: Editbox, min: 0, max: 100}
"""


# ---------------------------------------------------------------------------
# AE1 — no-count Group asks all in canonical order
# ---------------------------------------------------------------------------


class TestAE1NoCountAsksAll(unittest.TestCase):
    """A Group with `count` omitted asks every in-scope item, in canonical
    (stable-Kahn) order — the old Sequence behavior."""

    def test_no_count_group_asks_all_in_canonical_order(self):
        processor, state = _load(QML_NO_COUNT)
        answers = {"q_intro": 1, "q_a": 1, "q_b": 2, "q_c": 3, "q_thanks": 1}
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(walked, ["q_intro", "q_a", "q_b", "q_c", "q_thanks"])
        # Uncapped Group carries no draw-cap tag → no group_asked pass state.
        self.assertEqual(state.get("group_asked", {}), {})
        for item_id in ("q_a", "q_b", "q_c"):
            self.assertIsNotNone(state.get_item(item_id).get("outcome"))


# ---------------------------------------------------------------------------
# AE2 / AE3 / AE4 / AE8 — count-cap draw mechanics
# ---------------------------------------------------------------------------


class TestCappedGroupDraw(unittest.TestCase):
    def test_ae2_first_n_asked_rest_absent(self):
        """count=3 with all five inner items eligible → exactly the first 3 in
        canonical order; the remaining two are absent (outcome=None, not
        visited, excluded from history)."""
        processor, state = _load(QML_BASIC)
        answers = {
            "q_age": 30,  # all five inner items eligible
            "q_s1": 7,
            "q_s2": 3,
            "q_s3": 4,
            "q_thanks": 1,
        }
        walked = _walk_and_answer(processor, state, answers)
        group_steps = [s for s in walked if s.startswith("q_s")]
        self.assertEqual(group_steps, ["q_s1", "q_s2", "q_s3"])
        # Beyond-cap items are absent from the survey record: outcome=None and
        # never in history (the two surfaces the extractor reads). They were
        # never user-visible (absent from `walked`). After block completion the
        # navigation machinery flips their visited flag to advance past the
        # block — parity with Roster's "all-iterations-done" marking — so the
        # absence guarantee is outcome+history, not the visited flag.
        for absent in ("q_s4", "q_s5"):
            self.assertIsNone(state.get_item(absent).get("outcome"))
            self.assertNotIn(absent, state.get_history())

    def test_ae3_precondition_false_is_free_pass(self):
        """A precondition-False item consumes NO slot; the slots are filled by
        the next eligible items in canonical order."""
        processor, state = _load(QML_BASIC)
        # q_age = 15 → q_s2 (>=18) skipped (free pass), q_s4 (>=13) eligible.
        answers = {
            "q_age": 15,
            "q_s1": 7,
            "q_s3": 4,
            "q_s4": 6,
            "q_thanks": 1,
        }
        walked = _walk_and_answer(processor, state, answers)
        group_steps = [s for s in walked if s.startswith("q_s")]
        # q_s2 free-passed without consuming a slot → q_s1, q_s3, q_s4.
        self.assertEqual(group_steps, ["q_s1", "q_s3", "q_s4"])
        self.assertIsNone(state.get_item("q_s2").get("outcome"))

    def test_ae4_pool_exhaustion_fewer_than_count_no_error(self):
        """count=3 but the eligible pool exhausts below the cap when
        preconditions free-pass items — draw ends on pool exhaustion."""
        processor, state = _load(QML_BASIC)
        # q_age = 5 → q_s2 (>=18) and q_s4 (>=13) both free-passed.
        # Eligible pool = {q_s1, q_s3, q_s5} (3) → exactly 3 asked.
        answers = {
            "q_age": 5,
            "q_s1": 7,
            "q_s3": 4,
            "q_s5": 2,
            "q_thanks": 1,
        }
        walked = _walk_and_answer(processor, state, answers)
        group_steps = [s for s in walked if s.startswith("q_s")]
        self.assertEqual(group_steps, ["q_s1", "q_s3", "q_s5"])

    def test_ae8_count_ge_item_count_asks_all(self):
        """count >= number of inner items → asks all, no spurious rejection
        (equivalent to a no-count Group). Uses a real `count: 99` in inline QML
        through the loader — never mutates the internal `_group_count` tag."""
        processor, state = _load(QML_COUNT_GE_ITEMS)
        answers = {
            "q_age": 30,
            "q_s1": 1,
            "q_s2": 1,
            "q_s3": 1,
            "q_s4": 1,
            "q_s5": 1,
            "q_thanks": 1,
        }
        walked = _walk_and_answer(processor, state, answers)
        group_steps = [s for s in walked if s.startswith("q_s")]
        self.assertEqual(group_steps, ["q_s1", "q_s2", "q_s3", "q_s4", "q_s5"])


# ---------------------------------------------------------------------------
# AE5 / AE19 — backward nav with no precondition change preserves answers
# ---------------------------------------------------------------------------


class TestBenignBackwardNav(unittest.TestCase):
    """AE5 + AE19: the asked-set is stable across backward navigation when no
    precondition changes; eviction must NOT fire on benign re-entry."""

    def test_ae19_benign_backward_preserves_all_answers(self):
        processor, state = _load(QML_BASIC)
        answers = {
            "q_age": 30,
            "q_s1": 7,
            "q_s2": 3,
            "q_s3": 4,
            "q_thanks": 1,
        }
        _walk_and_answer(processor, state, answers)
        # All three drawn items answered and in history.
        drawn_before = ["q_s1", "q_s2", "q_s3"]
        for iid in drawn_before:
            self.assertIsNotNone(state.get_item(iid).get("outcome"))
            self.assertIn(iid, state.get_history())

        # Backward all the way to q_age WITHOUT changing any answer.
        for _ in range(20):
            item = processor.get_current_item(state, backward=True)
            if item is not None and item["id"] == "q_age":
                break
        # Re-answer q_age with the SAME value (no precondition change).
        processor.process_item(state, "q_age", 30, source=SOURCE_RESPONDENT)
        walked2 = _walk_and_answer(processor, state, answers)

        # Same draw, every prior answer preserved — no eviction.
        group_steps2 = [s for s in walked2 if s.startswith("q_s")]
        self.assertEqual(group_steps2, ["q_s1", "q_s2", "q_s3"])
        for iid in drawn_before:
            self.assertIsNotNone(state.get_item(iid).get("outcome"))
            self.assertIn(iid, state.get_history())


# ---------------------------------------------------------------------------
# AE13 — flipped precondition evicts a previously-answered item
# ---------------------------------------------------------------------------


class TestAE13Eviction(unittest.TestCase):
    """A backward edit promotes a free-pass item into the count and pushes a
    previously drawn-and-answered item OUT of the draw → the evicted item is
    cleared (outcome=None) AND its history entry is removed."""

    def test_flipped_precondition_evicts_answered_item(self):
        processor, state = _load(QML_EVICTION)
        # Pass 1: q_mode = 0 → g1 free-passed; g2, g3 drawn (count=2).
        answers1 = {"q_mode": 0, "g2": 5, "g3": 6, "q_tail": 1}
        walked1 = _walk_and_answer(processor, state, answers1)
        group_steps1 = [s for s in walked1 if s.startswith("g")]
        self.assertEqual(group_steps1, ["g2", "g3"])
        self.assertEqual(state.get_item("g2").get("outcome"), 5)
        self.assertEqual(state.get_item("g3").get("outcome"), 6)
        self.assertIsNone(state.get_item("g1").get("outcome"))
        self.assertIn("g3", state.get_history())

        # Backward to q_mode and flip it to 1 (g1 precondition now True).
        for _ in range(20):
            item = processor.get_current_item(state, backward=True)
            if item is not None and item["id"] == "q_mode":
                break
        processor.process_item(state, "q_mode", 1, source=SOURCE_RESPONDENT)

        # Pass 2: q_mode = 1 → g1 consumes slot 1, g2 slot 2 → drawn [g1, g2].
        # g3 was drawn+answered in pass 1 but is no longer drawn → EVICTED.
        answers2 = {"q_mode": 1, "g1": 9, "g2": 5, "q_tail": 1}
        walked2 = _walk_and_answer(processor, state, answers2)
        group_steps2 = [s for s in walked2 if s.startswith("g")]
        self.assertEqual(group_steps2, ["g1", "g2"])

        # The evicted item is absent from BOTH surfaces the extractor reads.
        self.assertIsNone(
            state.get_item("g3").get("outcome"),
            "evicted item's outcome must be cleared",
        )
        self.assertNotIn(
            "g3",
            state.get_history(),
            "evicted item's history entry must be removed (extractor walks history)",
        )
        # history / history_iter_key stay in lockstep after the removal.
        self.assertEqual(
            len(state.get("history", [])), len(state.get("history_iter_key", []))
        )
        # Newly-drawn item is present and answered.
        self.assertEqual(state.get_item("g1").get("outcome"), 9)
        self.assertIn("g1", state.get_history())


# ---------------------------------------------------------------------------
# AE14 — all preconditions false → empty draw, block skipped, recap preserved
# ---------------------------------------------------------------------------


class TestAE14AllSkipped(unittest.TestCase):
    def test_all_preconditions_false_block_skipped_recap_preserved(self):
        processor, state = _load(QML_ALL_SKIPPED)
        answers = {"q_gate": 0, "q_tail": 1}
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(walked, ["q_gate", "q_tail"])
        # Inner items never shown / never answered.
        for iid in ("q_x", "q_y"):
            self.assertFalse(state.get_item(iid).get("visited", False))
            self.assertIsNone(state.get_item(iid).get("outcome"))
            self.assertNotIn(iid, state.get_history())
        # Recap preserved — last visited item is the real last one.
        recap = processor.get_current_item(state, backward=False)
        self.assertIsNotNone(recap)
        self.assertEqual(recap["id"], "q_tail")
        self.assertTrue(recap.get("isLast"))


# ---------------------------------------------------------------------------
# AE15 — false block-level precondition → whole block absent
# ---------------------------------------------------------------------------


class TestAE15BlockPreconditionFalse(unittest.TestCase):
    def test_false_block_precondition_whole_block_absent(self):
        processor, state = _load(QML_BLOCK_GATED)
        # q_open = 0 → block-level precondition False for every inner item.
        answers = {"q_open": 0, "q_tail": 1}
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(walked, ["q_open", "q_tail"])
        for iid in ("g_a", "g_b", "g_c"):
            self.assertFalse(state.get_item(iid).get("visited", False))
            self.assertIsNone(state.get_item(iid).get("outcome"))

    def test_true_block_precondition_draws_count(self):
        """Sanity inverse: q_open = 1 → block precondition True → first 2 asked
        (distinct from the count-exhausted / block-absent cases)."""
        processor, state = _load(QML_BLOCK_GATED)
        answers = {"q_open": 1, "g_a": 1, "g_b": 2, "q_tail": 1}
        walked = _walk_and_answer(processor, state, answers)
        group_steps = [s for s in walked if s.startswith("g_")]
        self.assertEqual(group_steps, ["g_a", "g_b"])
        self.assertIsNone(state.get_item("g_c").get("outcome"))


# ---------------------------------------------------------------------------
# Projection (NOT positional slice) — non-contiguous Group items
# ---------------------------------------------------------------------------


class TestNonContiguousProjection(unittest.TestCase):
    """A cross-block dependency forces a foreign item between the Group's two
    items in navigation_path. The on-reach walk decides each member WHERE IT
    SITS in the global order, so the interleaved foreign item is presented in
    between and the Group's two members are still both drawn (count=2) in global
    order — the on-reach analogue of "draw walks members only, not a positional
    slice that would pick up the foreign item."""

    def test_group_items_non_contiguous_in_navigation_path(self):
        processor, state = _load(QML_NONCONTIGUOUS)
        nav = state.get_navigation_path()
        # gA → f_mid → gB: the Group's items are NOT adjacent — a positional
        # slice between them would wrongly span the foreign f_mid.
        self.assertLess(nav.index("gA"), nav.index("f_mid"))
        self.assertLess(nav.index("f_mid"), nav.index("gB"))
        # Observable proof (replaces the old _group_projection direct call): the
        # walk presents the foreign item BETWEEN the two Group members, and both
        # Group members are drawn — neither is dropped (frozen-at-entry would
        # have dropped gB, which depends on f_mid that runs after block entry),
        # and f_mid is NOT a Group member of pick/pair_group.
        answers = {"gA": 1, "f_mid": 2, "gB": 3, "q_tail": 1}
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(walked, ["gA", "f_mid", "gB", "q_tail"])
        # f_mid sits between the Group members but is not itself a Group member.
        self.assertIsNone(state.get_item("f_mid").get("_group_block_id"))

    def test_draw_walks_projection_members_only(self):
        processor, state = _load(QML_NONCONTIGUOUS)
        answers = {"gA": 1, "f_mid": 2, "gB": 3, "q_tail": 1}
        walked = _walk_and_answer(processor, state, answers)
        # The user sees gA, then f_mid (the interleaved foreign item), then gB.
        self.assertEqual(walked, ["gA", "f_mid", "gB", "q_tail"])
        # Both Group members were drawn (count=2) and answered, in global order —
        # gA before gB — even though f_mid sits between them in navigation_path.
        self.assertEqual(state.get_item("gA").get("outcome"), 1)
        self.assertEqual(state.get_item("gB").get("outcome"), 3)
        self.assertIn("gA", state.get_history())
        self.assertIn("gB", state.get_history())
        self.assertLess(
            state.get_history().index("gA"), state.get_history().index("gB")
        )


# ---------------------------------------------------------------------------
# C1 — evaluate-on-reach presents a later-eligible cross-block member
# ---------------------------------------------------------------------------


class TestC1LateEligibleMember(unittest.TestCase):
    """A capped-Group member whose precondition only becomes true AFTER an outer
    item (sorting between the group's members) runs MUST still be presented.

    The frozen-at-first-block-entry draw evaluated eligibility once, before the
    outer item ran, so it never drew the late-eligible member and finalized the
    block — silently dropping the question. The evaluate-on-reach model checks
    eligibility when the forward walk reaches the member, by which point the
    outer item's codeBlock has run (navigation_path is the stable-Kahn order, so
    every dependency precedes the member).
    """

    def test_late_eligible_member_is_presented_for_answering(self):
        processor, state = _load(QML_LATE_ELIGIBLE)
        # nav order is [a, f, c]: the cross-block dep forces f between a and c.
        nav = state.get_navigation_path()
        self.assertLess(nav.index("a"), nav.index("f"))
        self.assertLess(nav.index("f"), nav.index("c"))

        # answer a, then f (codeBlock sets g=5), then c MUST be presented for a
        # real answer — not merely shown as an isLast recap with outcome=None.
        answers = {"a": 1, "f": 2, "c": 3}
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(walked, ["a", "f", "c"])
        # c was genuinely answered (a slot was free, g>0 when reached).
        self.assertEqual(state.get_item("c").get("outcome"), 3)
        self.assertIn("c", state.get_history())


# ---------------------------------------------------------------------------
# A1 — eviction must never clear a non-asked member's preset outcome
# ---------------------------------------------------------------------------


class TestA1EvictionScopedToAsked(unittest.TestCase):
    """An outcome written by codeInit (or an outer codeBlock) onto a capped-Group
    member the group never asks MUST survive — only items the group actually
    asked may be evicted. The old eviction swept ANY not-drawn inner item with a
    non-None outcome, wrongly nulling these preset values."""

    def test_codeinit_set_outcome_on_non_drawn_member_survives(self):
        processor, state = _load(QML_PRESET_NOT_DRAWN)
        # codeInit set g2_keep.outcome = 8 before any draw.
        self.assertEqual(state.get_item("g2_keep").get("outcome"), 8)
        # count=1 → only g_drawn is asked; g2_keep is never asked by the group
        # but carries a codeInit-set outcome of 8.
        answers = {"g_drawn": 4, "q_read": 0, "q_final": 0}
        walked = _walk_and_answer(processor, state, answers)
        self.assertEqual(walked, ["g_drawn", "q_read", "q_final"])

        # The preset survives — the group never asked g2_keep, so it may not be
        # evicted/cleared.
        self.assertEqual(
            state.get_item("g2_keep").get("outcome"),
            8,
            "codeInit-set outcome on a non-asked member must NOT be cleared",
        )
        # And the downstream read saw 8, not None: q_read's codeBlock evaluated
        # `captured = g2_keep.outcome` and that variable propagated forward to
        # q_final's context (the current item's own context is not rewritten
        # post-codeBlock — variables flow to subsequent items, the canonical
        # FlowProcessor contract).
        self.assertEqual(state.get_item("q_final")["context"].get("captured"), 8)


# ---------------------------------------------------------------------------
# T4 — backward nav out of an incomplete pass clears group_asked (restored)
# ---------------------------------------------------------------------------


class TestBackwardNavClearsGroupAsked(unittest.TestCase):
    """Backward-navigate out of an incomplete capped-Group pass and back in; the
    group_asked sentinel must be cleared so re-entry re-derives eligibility.

    Group analogue of the retired ``TestBackwardNavClearsSampleAsked``. The
    Roster teardown guard ``if current_iter is not None`` never fires for Group
    items (iter_key is always None), so a dedicated _group_block_id branch in
    _backward_navigate must clear group_asked. If it didn't, the next forward
    entry would find has_group_pass() True, skip _enter_group_pass, and serve a
    stale running asked-list.
    """

    def test_backward_past_block_clears_group_asked(self):
        processor, state = _load(QML_BASIC)
        block_id = "lifestyle_group"

        # Answer q_age, then step into the Group pass (draws q_s1 first).
        first = processor.get_current_item(state, backward=False)
        self.assertEqual(first["id"], "q_age")
        processor.process_item(state, "q_age", 30, source=SOURCE_RESPONDENT)

        drawn = processor.get_current_item(state, backward=False)
        self.assertIsNotNone(drawn)
        self.assertEqual(drawn.get("_group_block_id"), block_id)
        self.assertTrue(
            state.has_group_pass(block_id),
            "group_asked must be populated while inside the pass",
        )

        # Backward-navigate past q_s1 (the only Group entry in history so far),
        # landing back on q_age (off the block entirely).
        prev = processor.get_current_item(state, backward=True)
        self.assertIsNotNone(prev)
        self.assertEqual(prev["id"], "q_age")

        # After backward-nav out of the pass, group_asked must be cleared.
        self.assertFalse(
            state.has_group_pass(block_id),
            "group_asked must be empty after backward-nav past the block start",
        )

        # Re-answer q_age and re-enter — the pass is re-populated by a fresh
        # _enter_group_pass (eligibility re-derived from scratch).
        processor.process_item(state, "q_age", 30, source=SOURCE_RESPONDENT)
        re_drawn = processor.get_current_item(state, backward=False)
        self.assertIsNotNone(re_drawn)
        self.assertEqual(re_drawn.get("_group_block_id"), block_id)
        self.assertTrue(
            state.has_group_pass(block_id),
            "group_asked must be re-populated after forward re-entry",
        )


if __name__ == "__main__":
    unittest.main()
