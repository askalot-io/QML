#!/usr/bin/env python3
"""Unit tests for U5: QMLState Sample pass-state storage and round-trip.

This suite verifies the U5 QMLState deliverable from the Sample plan
(docs/plans/2026-05-17-001-feat-sample-block-kind-aware-z3-plan.md):

  1. QMLState exposes Sample pass state in two sibling maps — NOT mixed into
     `state['items']`:
       * `sample_order` — the FROZEN per-block traversal order (one of U4's
         validated orderings). Frozen at first entry; persists across
         backward-nav and re-entry (divergence from Roster). Only `reset()`
         wipes it.
       * `sample_asked` — the per-pass list of inner items that consumed an
         N slot. Re-derived every pass; cleared on pass exit via
         `clear_sample_pass_state`.
  2. `has_sample_pass(block_id)` is the per-pass sentinel (distinguishes
     "entered, drawn set computed — possibly empty degenerate pass" from
     "not entered / cleared on exit"); `sample_order` is NOT the sentinel.
  3. `clear_sample_pass_state` drops `sample_asked` only; `sample_order`
     survives (frozen-order-persists contract).
  4. `reset()` clears BOTH maps (a reset re-randomises is_random blocks).
  5. State serializes through dict round-trip (QMLState IS a dict) with the
     new keys defaulted on construct — no migration needed; mixed
     Roster+Sample state keeps both key families independent.

## Coverage

- Default init populates both maps as empty; legacy state without the keys
  back-fills cleanly.
- set/get_sample_order round-trip; frozen list is copied (not aliased).
- set/get_sample_asked round-trip.
- has_sample_pass true only after a drawn set is recorded; false after clear.
- clear_sample_pass_state preserves sample_order, drops sample_asked.
- reset() clears both.
- A mixed Roster+Sample state round-trips: roster_* and sample_* coexist.
"""

import pytest
from askalot_qml.models.qml_state import QMLState


@pytest.mark.unit
class TestSampleStateDefaults:
    def test_default_init_has_empty_sample_maps(self):
        state = QMLState()
        assert state.get("sample_order") == {}
        assert state.get("sample_asked") == {}

    def test_legacy_state_without_sample_keys_backfills(self):
        # Persisted state predating U5 has no sample_* keys at all.
        state = QMLState({"items": [], "blocks": [], "history": []})
        assert state.get("sample_order") == {}
        assert state.get("sample_asked") == {}
        assert state.has_sample_pass("anything") is False


@pytest.mark.unit
class TestSampleOrderAccessors:
    def test_order_round_trip_and_copy_isolation(self):
        state = QMLState()
        order = ["q_a", "q_b", "q_c"]
        state.set_sample_order("blk", order)
        assert state.get_sample_order("blk") == ["q_a", "q_b", "q_c"]
        # Stored as a copy — mutating the caller's list must not bleed through.
        order.append("q_d")
        assert state.get_sample_order("blk") == ["q_a", "q_b", "q_c"]

    def test_unentered_block_order_is_none_sentinel(self):
        state = QMLState()
        assert state.get_sample_order("never") is None


@pytest.mark.unit
class TestSampleAskedAndSentinel:
    def test_asked_round_trip(self):
        state = QMLState()
        assert state.get_sample_asked("blk") == []
        state.set_sample_asked("blk", ["q_a", "q_c"])
        assert state.get_sample_asked("blk") == ["q_a", "q_c"]

    def test_has_sample_pass_is_per_pass_sentinel(self):
        state = QMLState()
        # Freezing the order alone does NOT make a pass active — sample_order
        # is the persistent frozen order, not the pass sentinel.
        state.set_sample_order("blk", ["q_a"])
        assert state.has_sample_pass("blk") is False
        # Recording a drawn set (even empty — degenerate pass) activates it.
        state.set_sample_asked("blk", [])
        assert state.has_sample_pass("blk") is True

    def test_clear_preserves_order_drops_asked(self):
        state = QMLState()
        state.set_sample_order("blk", ["q_a", "q_b"])
        state.set_sample_asked("blk", ["q_a"])
        assert state.has_sample_pass("blk") is True
        state.clear_sample_pass_state("blk")
        # Frozen order persists; drawn set + sentinel gone.
        assert state.get_sample_order("blk") == ["q_a", "q_b"]
        assert state.has_sample_pass("blk") is False
        assert state.get_sample_asked("blk") == []


@pytest.mark.unit
class TestSampleReset:
    def test_reset_clears_both_maps(self):
        state = QMLState()
        state.set_sample_order("blk", ["q_a"])
        state.set_sample_asked("blk", ["q_a"])
        state.reset()
        assert state.get("sample_order") == {}
        assert state.get("sample_asked") == {}
        assert state.get_sample_order("blk") is None


@pytest.mark.unit
class TestMixedRosterSampleRoundTrip:
    def test_roster_and_sample_state_coexist_through_dict_roundtrip(self):
        # Build state with BOTH families populated, serialize via the dict
        # round-trip QMLState performs (it IS a dict), reconstruct, and assert
        # neither family's keys collide or get dropped.
        state = QMLState({"items": [], "blocks": [], "history": ["q_x"]})
        state.set_roster_active_keys("r_blk", [1, 4])
        state.set_roster_outcome("r_blk", 1, "q_in", 42)
        state.set_sample_order("s_blk", ["q_s1", "q_s2"])
        state.set_sample_asked("s_blk", ["q_s1"])

        # Round-trip through a plain dict (the persistence shape).
        persisted = dict(state)
        restored = QMLState(persisted)

        assert restored.get_roster_active_keys("r_blk") == [1, 4]
        assert restored.get_roster_outcome("r_blk", 1, "q_in") == 42
        assert restored.get_sample_order("s_blk") == ["q_s1", "q_s2"]
        assert restored.get_sample_asked("s_blk") == ["q_s1"]
        assert restored.has_sample_pass("s_blk") is True
        # history_iter_key parallel-list contract unaffected by Sample (Sample
        # entries use iter_key=None — no per-iteration identity).
        assert restored.get_history() == ["q_x"]
