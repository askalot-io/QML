#!/usr/bin/env python3
"""Unit tests for QMLState Group `count`-cap pass-state storage and round-trip.

This suite verifies the Group pass-state surface on QMLState:

  1. QMLState exposes the Group drawn-set in a single sibling map — NOT mixed
     into `state['items']`:
       * `group_asked` — the per-pass list of inner items that consumed an
         N slot. Re-derived every pass; cleared on pass exit via
         `clear_group_pass_state`. There is NO frozen per-block order: draw
         order derives from the block's projection of `navigation_path`, so
         nothing order-related is stored on the state.
  2. `has_group_pass(block_id)` is the per-pass sentinel (distinguishes
     "entered, drawn set computed — possibly empty degenerate pass" from
     "not entered / cleared on exit").
  3. `clear_group_pass_state` drops `group_asked` for the block.
  4. `reset()` clears the map.
  5. State serializes through dict round-trip (QMLState IS a dict) with the
     key defaulted on construct — no migration needed; a mixed Roster+Group
     state keeps both key families independent.

## Coverage

- Default init populates `group_asked` as empty; legacy state without the key
  back-fills cleanly.
- set/get_group_asked round-trip (stored as a copy, not aliased).
- has_group_pass true only after a drawn set is recorded; false after clear.
- clear_group_pass_state drops the drawn set + sentinel.
- reset() clears the map.
- A mixed Roster+Group state round-trips: roster_* and group_asked coexist.
"""

import pytest
from askalot_qml.models.qml_state import QMLState


@pytest.mark.unit
class TestGroupStateDefaults:
    def test_default_init_has_empty_group_map(self):
        state = QMLState()
        assert state.get("group_asked") == {}

    def test_legacy_state_without_group_key_backfills(self):
        # Persisted state predating the Group cap has no group_asked key at all.
        state = QMLState({"items": [], "blocks": [], "history": []})
        assert state.get("group_asked") == {}
        assert state.has_group_pass("anything") is False


@pytest.mark.unit
class TestGroupAskedAndSentinel:
    def test_asked_round_trip_and_copy_isolation(self):
        state = QMLState()
        assert state.get_group_asked("blk") == []
        asked = ["q_a", "q_c"]
        state.set_group_asked("blk", asked)
        assert state.get_group_asked("blk") == ["q_a", "q_c"]
        # Stored as a copy — mutating the caller's list must not bleed through.
        asked.append("q_d")
        assert state.get_group_asked("blk") == ["q_a", "q_c"]

    def test_has_group_pass_is_per_pass_sentinel(self):
        state = QMLState()
        assert state.has_group_pass("blk") is False
        # Recording a drawn set (even empty — degenerate pass) activates it.
        state.set_group_asked("blk", [])
        assert state.has_group_pass("blk") is True

    def test_clear_drops_asked_and_sentinel(self):
        state = QMLState()
        state.set_group_asked("blk", ["q_a"])
        assert state.has_group_pass("blk") is True
        state.clear_group_pass_state("blk")
        assert state.has_group_pass("blk") is False
        assert state.get_group_asked("blk") == []


@pytest.mark.unit
class TestGroupReset:
    def test_reset_clears_group_map(self):
        state = QMLState()
        state.set_group_asked("blk", ["q_a"])
        state.reset()
        assert state.get("group_asked") == {}
        assert state.has_group_pass("blk") is False


@pytest.mark.unit
class TestMixedRosterGroupRoundTrip:
    def test_roster_and_group_state_coexist_through_dict_roundtrip(self):
        # Build state with BOTH families populated, serialize via the dict
        # round-trip QMLState performs (it IS a dict), reconstruct, and assert
        # neither family's keys collide or get dropped.
        state = QMLState({"items": [], "blocks": [], "history": ["q_x"]})
        state.set_roster_active_keys("r_blk", [1, 4])
        state.set_roster_outcome("r_blk", 1, "q_in", 42)
        state.set_group_asked("g_blk", ["q_s1"])

        # Round-trip through a plain dict (the persistence shape).
        persisted = dict(state)
        restored = QMLState(persisted)

        assert restored.get_roster_active_keys("r_blk") == [1, 4]
        assert restored.get_roster_outcome("r_blk", 1, "q_in") == 42
        assert restored.get_group_asked("g_blk") == ["q_s1"]
        assert restored.has_group_pass("g_blk") is True
        # history_iter_key parallel-list contract unaffected by Group (Group
        # entries use iter_key=None — no per-iteration identity).
        assert restored.get_history() == ["q_x"]
