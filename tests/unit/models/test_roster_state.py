#!/usr/bin/env python3
"""Unit tests for U2: QMLState roster outcome storage and ItemProxy outcomes accessor.

This test suite verifies the U2 deliverable from the Roster plan
(docs/plans/2026-05-04-001-feat-roster-block-plan.md):

  1. QMLState exposes roster outcome storage in a sibling `roster_outcomes`
     map keyed by `(block_id, label_key, item_id)` — NOT mixed into
     `state['items']`. Single keying scheme using power-of-2 label keys
     (1, 2, 4, 8, …).
  2. Transient pass state lives in `roster_iter` (current label_key) and
     `roster_active_keys` (frozen sorted active keys for the current pass).
     `clear_roster_iter_state(block_id)` cleans both on roster exit.
  3. History migration: parallel `state['history_iter_key']` list lockstep-
     indexed with `state['history']`; non-roster entries carry `None`.
     `add_to_history(item_id, iter_key=None)` and `pop_history()` keep both
     in sync. `get_history()` is unchanged shape (List[str]) for backward
     compatibility with the four enumerated callsites that iterate strings.
     Legacy state with `history` but no `history_iter_key` is back-filled
     on construct — no Alembic migration required.
  4. `reset()` clears all roster runtime state (parallel to history clear).
  5. ItemProxy gains a dict-shaped `outcomes` attribute keyed by label_key
     when constructed with `roster_outcomes_for_block` AND the item carries
     the `_roster_block_id` tag from U1's loader. Non-roster items don't get
     `outcomes` (AttributeError signals "outcomes is roster-only").

## Coverage

- Default initialization populates the sibling maps as empty.
- Legacy state without history_iter_key gets back-filled in lockstep.
- add_to_history / pop_history maintain lockstep.
- get_history shape unchanged; get_history_with_iter exposes pairs.
- Roster outcome read/write round-trip.
- Transient roster_iter / roster_active_keys lifecycle.
- reset() clears roster runtime state.
- ItemProxy.outcomes for outside-roster reads.
- ItemProxy.outcome (singular) still works for non-roster items.
- Multiselect-driven roster scenario from Canonical Example A (covers AE2).
"""

import pytest
from askalot_qml.models.item_proxy import ItemProxy
from askalot_qml.models.qml_state import QMLState

# ---------------------------------------------------------------------------
# QMLState initialization + persistence shape
# ---------------------------------------------------------------------------


class TestQMLStateRosterFields:
    def test_default_init_has_empty_roster_maps(self):
        state = QMLState()
        assert state.get("roster_outcomes") == {}
        assert state.get("roster_iter") == {}
        assert state.get("roster_active_keys") == {}
        assert state.get("history") == []
        assert state.get("history_iter_key") == []

    def test_legacy_state_backfills_history_iter_key_with_nones(self):
        """A persisted state with `history` but no `history_iter_key` is back-filled."""
        legacy = {"history": ["q1", "q2", "q3"]}
        state = QMLState(legacy)
        assert state["history_iter_key"] == [None, None, None]

    def test_length_drift_is_repaired_defensively(self):
        """If the two lists arrive out of lockstep we pad/truncate to match."""
        # Iter-keys list shorter than history.
        s1 = QMLState({"history": ["a", "b", "c"], "history_iter_key": [1]})
        assert s1["history_iter_key"] == [1, None, None]

        # Iter-keys list longer than history.
        s2 = QMLState({"history": ["a"], "history_iter_key": [1, 2, 4]})
        assert s2["history_iter_key"] == [1]


# ---------------------------------------------------------------------------
# History add/pop with iter_key
# ---------------------------------------------------------------------------


class TestHistoryWithIterKey:
    def test_add_non_roster_item_records_none_iter_key(self):
        state = QMLState()
        state.add_to_history("q_outer")
        assert state.get_history() == ["q_outer"]
        assert state["history_iter_key"] == [None]

    def test_add_roster_item_records_iter_key(self):
        state = QMLState()
        state.add_to_history("q_satisfaction", iter_key=4)  # Dinner iteration
        assert state.get_history() == ["q_satisfaction"]
        assert state["history_iter_key"] == [4]

    def test_pop_returns_pair_and_keeps_lockstep(self):
        state = QMLState()
        state.add_to_history("q_outer")
        state.add_to_history("q_satisfaction", iter_key=1)
        state.add_to_history("q_notes", iter_key=1)

        popped = state.pop_history()
        assert popped == ("q_notes", 1)
        assert state.get_history() == ["q_outer", "q_satisfaction"]
        assert state["history_iter_key"] == [None, 1]

    def test_pop_on_empty_history_returns_none(self):
        state = QMLState()
        assert state.pop_history() is None

    def test_get_history_unchanged_shape_for_backcompat(self):
        """Legacy callers (flow_blueprint stepper, targetor, survey_extractor)
        iterate `get_history()` as List[str] — must keep that shape."""
        state = QMLState()
        state.add_to_history("q_outer")
        state.add_to_history("q_satisfaction", iter_key=1)
        history = state.get_history()
        assert isinstance(history, list)
        assert all(isinstance(item_id, str) for item_id in history)
        assert history == ["q_outer", "q_satisfaction"]

    def test_get_history_with_iter_returns_tuple_pairs(self):
        """Roster-aware consumers (FlowProcessor backward nav) get the iter context."""
        state = QMLState()
        state.add_to_history("q_outer")
        state.add_to_history("q_satisfaction", iter_key=1)
        state.add_to_history("q_satisfaction", iter_key=4)
        assert state.get_history_with_iter() == [
            ("q_outer", None),
            ("q_satisfaction", 1),
            ("q_satisfaction", 4),
        ]


# ---------------------------------------------------------------------------
# Roster outcome storage
# ---------------------------------------------------------------------------


class TestRosterOutcomeStorage:
    def test_set_then_get_single_cell(self):
        state = QMLState()
        state.set_roster_outcome("per_meal", 1, "q_satisfaction", 4)
        assert state.get_roster_outcome("per_meal", 1, "q_satisfaction") == 4

    def test_get_unset_cell_returns_none(self):
        state = QMLState()
        assert state.get_roster_outcome("per_meal", 1, "q_satisfaction") is None

    def test_outcomes_for_iter_returns_full_dict(self):
        state = QMLState()
        state.set_roster_outcome("per_meal", 1, "q_satisfaction", 4)
        state.set_roster_outcome("per_meal", 1, "q_notes", "good")
        assert state.get_roster_outcomes_for_iter("per_meal", 1) == {
            "q_satisfaction": 4,
            "q_notes": "good",
        }

    def test_outcomes_for_iter_unset_returns_empty(self):
        state = QMLState()
        assert state.get_roster_outcomes_for_iter("per_meal", 1) == {}

    def test_outcomes_for_item_projects_across_iterations(self):
        """get_roster_outcomes_for_item is the data ItemProxy.outcomes exposes."""
        state = QMLState()
        # Multiselect Breakfast+Dinner (mask=5): only bits 1 and 4 are populated.
        state.set_roster_outcome("per_meal", 1, "q_satisfaction", 4)  # Breakfast
        state.set_roster_outcome("per_meal", 1, "q_notes", "rushed")
        state.set_roster_outcome("per_meal", 4, "q_satisfaction", 5)  # Dinner
        state.set_roster_outcome("per_meal", 4, "q_notes", "great")

        # q_satisfaction across iterations: bit 1 -> 4, bit 4 -> 5; bits 2 and 8 absent.
        assert state.get_roster_outcomes_for_item("per_meal", "q_satisfaction") == {
            1: 4,
            4: 5,
        }
        assert state.get_roster_outcomes_for_item("per_meal", "q_notes") == {
            1: "rushed",
            4: "great",
        }

    def test_outcomes_for_item_skips_iterations_missing_that_item(self):
        """If an inner item's precondition skipped it for an iteration, no entry appears."""
        state = QMLState()
        state.set_roster_outcome("per_meal", 1, "q_satisfaction", 4)
        # iter 4 sets only q_notes — q_satisfaction skipped (precondition false on this iter).
        state.set_roster_outcome("per_meal", 4, "q_notes", "great")
        assert state.get_roster_outcomes_for_item("per_meal", "q_satisfaction") == {1: 4}


# ---------------------------------------------------------------------------
# Transient pass state
# ---------------------------------------------------------------------------


class TestRosterPassState:
    def test_set_get_current_iter(self):
        state = QMLState()
        assert state.get_current_roster_iter("per_meal") is None
        state.set_current_roster_iter("per_meal", 4)
        assert state.get_current_roster_iter("per_meal") == 4

    def test_set_get_active_keys(self):
        state = QMLState()
        assert state.get_roster_active_keys("per_meal") is None
        state.set_roster_active_keys("per_meal", [1, 4])  # Breakfast+Dinner mask
        assert state.get_roster_active_keys("per_meal") == [1, 4]

    def test_clear_roster_iter_state_drops_both_transients(self):
        state = QMLState()
        state.set_current_roster_iter("per_meal", 4)
        state.set_roster_active_keys("per_meal", [1, 4])
        # Outcomes survive — clear is for iter+active_keys only.
        state.set_roster_outcome("per_meal", 1, "q_satisfaction", 4)

        state.clear_roster_iter_state("per_meal")

        assert state.get_current_roster_iter("per_meal") is None
        assert state.get_roster_active_keys("per_meal") is None
        # Outcomes survive (retain-but-hidden semantics on roster exit).
        assert state.get_roster_outcome("per_meal", 1, "q_satisfaction") == 4


# ---------------------------------------------------------------------------
# reset() integration
# ---------------------------------------------------------------------------


class TestResetClearsRoster:
    def test_reset_clears_all_roster_state(self):
        state = QMLState({"items": [], "blocks": []})
        state.set_roster_outcome("per_meal", 1, "q_satisfaction", 4)
        state.set_current_roster_iter("per_meal", 1)
        state.set_roster_active_keys("per_meal", [1, 4])
        state.add_to_history("q_satisfaction", iter_key=1)

        state.reset()

        assert state["roster_outcomes"] == {}
        assert state["roster_iter"] == {}
        assert state["roster_active_keys"] == {}
        assert state["history"] == []
        assert state["history_iter_key"] == []


# ---------------------------------------------------------------------------
# ItemProxy outcomes (plural) accessor
# ---------------------------------------------------------------------------


class TestItemProxyOutcomes:
    def _roster_item(self, item_id="q_satisfaction", kind="Question"):
        """Build a minimal item dict tagged as belonging to a Roster."""
        return {
            "id": item_id,
            "kind": kind,
            "_roster_block_id": "per_meal",
            "_roster_iterate_over": "q_meals_eaten.outcome",
            "_roster_labels": {1: "Breakfast", 2: "Lunch", 4: "Dinner", 8: "Snack"},
            "input": {"control": "Slider", "min": 1, "max": 5},
        }

    def test_roster_item_with_outcomes_for_block_exposes_dict(self):
        outcomes_for_block = {
            1: {"q_satisfaction": 4, "q_notes": "rushed"},
            4: {"q_satisfaction": 5, "q_notes": "great"},
        }
        proxy = ItemProxy(self._roster_item(), roster_outcomes_for_block=outcomes_for_block)
        assert proxy.outcomes == {1: 4, 4: 5}

    def test_roster_item_with_empty_block_outcomes_has_empty_outcomes(self):
        proxy = ItemProxy(self._roster_item(), roster_outcomes_for_block={})
        assert proxy.outcomes == {}

    def test_roster_item_indexed_access_returns_per_iteration_value(self):
        outcomes_for_block = {1: {"q_satisfaction": 4}, 4: {"q_satisfaction": 5}}
        proxy = ItemProxy(self._roster_item(), roster_outcomes_for_block=outcomes_for_block)
        assert proxy.outcomes[1] == 4
        assert proxy.outcomes[4] == 5
        # Unvisited iteration → KeyError (caller can use .get() to default).
        with pytest.raises(KeyError):
            _ = proxy.outcomes[2]
        # .get() returns None for unvisited iterations.
        assert proxy.outcomes.get(2) is None

    def test_non_roster_item_does_not_get_outcomes_attribute(self):
        """`outcomes` is roster-only — non-roster items raise AttributeError on access."""
        item = {
            "id": "q_outside",
            "kind": "Question",
            "input": {"control": "Editbox", "min": 0, "max": 10},
            "outcome": 7,
        }
        proxy = ItemProxy(item)
        assert proxy.outcome == 7
        with pytest.raises(AttributeError):
            _ = proxy.outcomes

    def test_roster_item_without_block_outcomes_param_does_not_get_outcomes(self):
        """If FlowProcessor doesn't pass roster_outcomes_for_block, no outcomes dict."""
        proxy = ItemProxy(self._roster_item())  # no roster_outcomes_for_block
        with pytest.raises(AttributeError):
            _ = proxy.outcomes


# ---------------------------------------------------------------------------
# Canonical Example A end-to-end shape (AE2 partial coverage at the state layer)
# ---------------------------------------------------------------------------


class TestCanonicalExampleAStateShape:
    """Multiselect-driven roster state shape after walking AE2.

    Doesn't exercise FlowProcessor (that's U3) — verifies that the storage
    primitives U2 introduced can hold the AE2 outcome correctly when the
    respondent answered q_meals_eaten=5 (Breakfast+Dinner).
    """

    def test_ae2_state_shape_after_simulated_walk(self):
        state = QMLState({"items": [], "blocks": []})
        # Outer item: q_meals_eaten Checkbox outcome = 5 (Breakfast+Dinner).
        state.add_to_history("q_meals_eaten")

        # Roster entry: active_keys frozen as [1, 4] (low-bit-first walk of mask=5).
        state.set_roster_active_keys("per_meal", [1, 4])

        # Iter 1 (Breakfast): two pages.
        state.set_current_roster_iter("per_meal", 1)
        state.add_to_history("q_satisfaction", iter_key=1)
        state.set_roster_outcome("per_meal", 1, "q_satisfaction", 4)
        state.add_to_history("q_notes", iter_key=1)
        state.set_roster_outcome("per_meal", 1, "q_notes", "rushed")

        # Iter 4 (Dinner): two pages.
        state.set_current_roster_iter("per_meal", 4)
        state.add_to_history("q_satisfaction", iter_key=4)
        state.set_roster_outcome("per_meal", 4, "q_satisfaction", 5)
        state.add_to_history("q_notes", iter_key=4)
        state.set_roster_outcome("per_meal", 4, "q_notes", "great")

        # Roster exit clears transients but keeps outcomes.
        state.clear_roster_iter_state("per_meal")

        # Bits 2 and 8 (Lunch and Snack) never set.
        per_meal = state["roster_outcomes"]["per_meal"]
        assert sorted(per_meal.keys()) == [1, 4]
        assert per_meal[1] == {"q_satisfaction": 4, "q_notes": "rushed"}
        assert per_meal[4] == {"q_satisfaction": 5, "q_notes": "great"}

        # History lockstep — q_meals_eaten + 4 roster pages = 5 entries.
        assert state.get_history() == [
            "q_meals_eaten",
            "q_satisfaction",
            "q_notes",
            "q_satisfaction",
            "q_notes",
        ]
        assert state["history_iter_key"] == [None, 1, 1, 4, 4]


def test_roster_outcomes_string_keys_coerced_to_int_on_restore():
    """
    After a JSON roundtrip (persist → DB → load) the inner iter keys come back
    as strings, because JSON object keys are always strings. QMLState.__init__
    re-keys them to int so accessors, tests, and direct-dict callers can rely
    on native bitmask keys like `per_meal[1]`.
    """
    persisted = {
        "items": [],
        "blocks": [],
        "variables": {},
        "history": [],
        "roster_outcomes": {
            "per_meal": {
                "1": {"q_satisfaction": 4, "q_notes": "rushed"},
                "4": {"q_satisfaction": 5, "q_notes": "great"},
            }
        },
    }
    state = QMLState(persisted)
    per_meal = state["roster_outcomes"]["per_meal"]
    assert sorted(per_meal.keys()) == [1, 4]
    # Accessors resolve with native int keys after the restore.
    assert state.get_roster_outcome("per_meal", 1, "q_satisfaction") == 4
    assert state.get_roster_outcome("per_meal", 4, "q_notes") == "great"
    # get_roster_outcomes_for_item also returns int-keyed dict.
    by_iter = state.get_roster_outcomes_for_item("per_meal", "q_satisfaction")
    assert by_iter == {1: 4, 4: 5}
