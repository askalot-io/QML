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

It also covers the per-answer response timing log (Survey Detail Timing plan,
U1), which sits beside the history contract above but is deliberately keyed by
content rather than lockstep-indexed by position: events must survive
`pop_history` truncating `history` under them.

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
- Timing log: open/close round-trip, refresh idempotence, uncommitted exits,
  repeated attempts, per-iteration independence, reset(), JSON persistence.
"""

import itertools
import json

import pytest
from askalot_qml.models import qml_state as qml_state_module
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


# ---------------------------------------------------------------------------
# Per-answer response timing log
# ---------------------------------------------------------------------------


@pytest.fixture
def clock(monkeypatch):
    """Deterministic millisecond clock: every stamp advances exactly 1000 ms.

    The refresh test asserts WHICH call stamped the presentation moment, and
    the real clock can serve two calls in the same millisecond — which would
    let the bug this log exists to avoid pass the test.
    """
    ticks = itertools.count(1_700_000_000_000, 1000)
    monkeypatch.setattr(qml_state_module, "_now_ms", lambda: next(ticks))
    return ticks


class TestTimingLog:
    def test_open_then_close_records_one_complete_event(self, clock):
        state = QMLState()
        state.open_timing_event("q_age", None, "respondent")
        state.close_timing_event("q_age", None, committed=True)

        assert state.get_timing_events() == [
            {
                "i": "q_age",
                "k": None,
                "p": 1_700_000_000_000,
                "s": 1_700_000_001_000,
                "c": True,
                "src": "respondent",
            }
        ]

    def test_reopening_an_open_event_keeps_the_first_presentation_moment(self, clock):
        """The refresh case: current-item is a GET that re-runs on every render.

        A non-idempotent open would reset the respondent's clock on each
        refresh, under-reporting duration while still producing plausible
        numbers — the failure this test exists to catch.
        """
        state = QMLState()
        state.open_timing_event("q_age", None, "respondent")
        state.open_timing_event("q_age", None, "respondent")
        state.open_timing_event("q_age", None, "respondent")
        state.close_timing_event("q_age", None, committed=True)

        events = state.get_timing_events()
        assert len(events) == 1
        assert events[0]["p"] == 1_700_000_000_000  # first call, not the third
        assert events[0]["s"] == 1_700_000_001_000  # close took the very next tick

    def test_uncommitted_close_records_the_event_with_the_flag_clear(self, clock):
        """Backward navigation spends real time but is not an answer attempt."""
        state = QMLState()
        state.open_timing_event("q_age", None, "respondent")
        state.close_timing_event("q_age", None, committed=False)

        (event,) = state.get_timing_events()
        assert event["c"] is False
        assert event["s"] is not None
        assert state.count_timing_attempts("q_age", None) == 0

    def test_two_cycles_for_one_item_append_rather_than_overwrite(self, clock):
        """Answer, navigate back, re-answer → two events, oldest first."""
        state = QMLState()
        state.open_timing_event("q_age", None, "respondent")
        state.close_timing_event("q_age", None, committed=True)
        state.open_timing_event("q_age", None, "respondent")
        state.close_timing_event("q_age", None, committed=True)

        events = state.get_timing_events_for_item("q_age")
        assert len(events) == 2
        assert events[0]["p"] < events[1]["p"]
        assert events[0]["s"] < events[1]["p"]  # the first event is untouched by the second
        assert state.count_timing_attempts("q_age", None) == 2

    def test_same_item_under_two_iterations_produces_independent_events(self, clock):
        """A Roster item answered for two subjects is two answers, not two attempts."""
        state = QMLState()
        state.open_timing_event("q_satisfaction", 1, "respondent")
        state.close_timing_event("q_satisfaction", 1, committed=True)
        state.open_timing_event("q_satisfaction", 4, "respondent")
        state.close_timing_event("q_satisfaction", 4, committed=True)

        events = state.get_timing_events_for_item("q_satisfaction")
        assert [event["k"] for event in events] == [1, 4]
        assert state.count_timing_attempts("q_satisfaction", 1) == 1
        assert state.count_timing_attempts("q_satisfaction", 4) == 1

    def test_open_for_a_second_iteration_does_not_close_the_first(self, clock):
        """The open guard matches on the pair, so iterations do not shadow each other."""
        state = QMLState()
        state.open_timing_event("q_satisfaction", 1, "respondent")
        state.open_timing_event("q_satisfaction", 4, "respondent")
        assert len(state.get_timing_events()) == 2

        state.close_timing_event("q_satisfaction", 1, committed=True)
        by_iter = {event["k"]: event for event in state.get_timing_events()}
        assert by_iter[1]["s"] is not None
        assert by_iter[4]["s"] is None

    def test_close_without_an_open_event_records_nothing(self, clock):
        """A submission seam with no matching presentation seam fabricates no duration."""
        state = QMLState()
        state.close_timing_event("q_age", None, committed=True)
        assert state.get_timing_events() == []

    def test_drop_timing_events_removes_only_the_named_item(self, clock):
        """A capped-Group eviction drops the item's answer entirely, so its
        timing must go too — otherwise a re-draw double-counts the earlier
        attempt. Only the evicted item's events are removed; siblings stay."""
        state = QMLState()
        state.open_timing_event("q_drawn", None, "respondent")
        state.close_timing_event("q_drawn", None, committed=True)
        state.open_timing_event("q_kept", None, "respondent")
        state.close_timing_event("q_kept", None, committed=True)

        state.drop_timing_events_for_item("q_drawn")

        assert state.get_timing_events_for_item("q_drawn") == []
        assert len(state.get_timing_events_for_item("q_kept")) == 1

    def test_reset_empties_the_log(self, clock):
        state = QMLState({"items": [], "blocks": []})
        state.open_timing_event("q_age", None, "respondent")
        state.close_timing_event("q_age", None, committed=True)

        state.reset()

        assert state["response_timing"] == []
        assert state.get_timing_events() == []

    def test_log_survives_a_json_round_trip(self, clock):
        """The JSONB persistence path: every field must be a plain JSON type."""
        state = QMLState({"items": [], "blocks": []})
        state.open_timing_event("q_age", None, "respondent")
        state.close_timing_event("q_age", None, committed=True)
        state.open_timing_event("q_satisfaction", 4, "interviewer")
        state.close_timing_event("q_satisfaction", 4, committed=False)

        before = state.get_timing_events()
        restored = QMLState(json.loads(json.dumps(dict(state))))

        assert restored.get_timing_events() == before
        # The iteration key is a list ELEMENT, so it survives as an int — no
        # string-key coercion pass is involved, unlike roster_outcomes.
        assert restored.get_timing_events_for_item("q_satisfaction")[0]["k"] == 4


class TestSyntheticTimingInstall:
    """Generated answers get generated durations — but only over generated answers."""

    def test_spans_are_laid_end_to_end_backwards_from_the_end_moment(self):
        state = QMLState()
        state.install_synthetic_timing(
            [("q_age", None), ("q_city", None), ("q_note", None)],
            [3000, 5000, 2000],
            end_at_ms=1_700_000_100_000,
        )
        events = state.get_timing_events()
        assert [e["i"] for e in events] == ["q_age", "q_city", "q_note"]
        # Contiguous: each event starts exactly where the previous one ended,
        # so the log reads as one sitting rather than overlapping intervals.
        assert [(e["p"], e["s"]) for e in events] == [
            (1_700_000_090_000, 1_700_000_093_000),
            (1_700_000_093_000, 1_700_000_098_000),
            (1_700_000_098_000, 1_700_000_100_000),
        ]
        assert {e["src"] for e in events} == {"synthetic"}
        assert all(e["c"] is True for e in events)

    def test_roster_iteration_keys_are_carried_through(self):
        state = QMLState()
        state.install_synthetic_timing(
            [("q_rating", 1), ("q_rating", 2)], [4000, 4000], end_at_ms=1_700_000_100_000
        )
        assert [e["k"] for e in state.get_timing_events()] == [1, 2]

    def test_refuses_to_overwrite_measured_timing(self, clock):
        """The guard that matters: a real respondent's timing is not recoverable.

        Without this, a backfill pointed at the wrong organization would replace
        observed durations with invented ones that look exactly as plausible,
        and nothing downstream could tell which was which.
        """
        state = QMLState()
        state.open_timing_event("q_age", None, "respondent")
        state.close_timing_event("q_age", None, committed=True)

        with pytest.raises(ValueError, match="measured events"):
            state.install_synthetic_timing([("q_age", None)], [5000], end_at_ms=1_700_000_100_000)

        # Untouched — the refusal is not partial.
        (event,) = state.get_timing_events()
        assert event["src"] == "respondent"

    def test_replaces_an_existing_synthetic_log(self, clock):
        # The fill job's own zero-span events are what this replaces, so a log
        # already full of synthetic events must not block the rewrite.
        state = QMLState()
        state.open_timing_event("q_age", None, "synthetic")
        state.close_timing_event("q_age", None, committed=True)
        assert state.get_timing_events()[0]["s"] - state.get_timing_events()[0]["p"] == 1000

        state.install_synthetic_timing([("q_age", None)], [7000], end_at_ms=1_700_000_100_000)
        (event,) = state.get_timing_events()
        assert event["s"] - event["p"] == 7000

    def test_length_mismatch_is_refused(self):
        state = QMLState()
        with pytest.raises(ValueError, match="align"):
            state.install_synthetic_timing([("q_age", None)], [1000, 2000])

    def test_end_moment_defaults_to_now(self, clock):
        state = QMLState()
        state.install_synthetic_timing([("q_age", None)], [6000])
        (event,) = state.get_timing_events()
        assert event["s"] == 1_700_000_000_000
        assert event["p"] == 1_700_000_000_000 - 6000
