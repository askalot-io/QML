"""
Integration tests for FlowProcessor navigation.

Tests survey flow including:
- Forward/backward navigation with state handling
- Outcomes stored in questionnaire state
- Outcome persistence when navigating backward and taking different paths
- Topological order respecting dependencies
- Response timing captured at the answer seam: a forward answer records one
  committed event, a backward convenience save records an uncommitted one that
  does not count as an attempt, a re-answer records a second event beside the
  first, and a Roster item answered under two iterations records two
  independent events
- `process_item` refuses to record an untagged answer — `source` is required
- The variable state is a chain (#1021): a re-answer that no longer assigns a
  variable or writes an outcome leaves it absent downstream; answering an
  earlier item directly (as an API driver may) rewinds the walk to it and
  rolls back every later codeBlock write; a survey persisted with per-item
  contexts is upgraded to the same variables it read before
"""

from pathlib import Path
from typing import Any, Optional

import pytest
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import SOURCE_RESPONDENT, SOURCE_SYNTHETIC, QMLState

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def get_outcome_value(item: dict) -> Any | None:
    """Extract the outcome value from an item — native shape, returned as-is."""
    return item.get("outcome")


def load_qml_fixture(filename: str) -> QMLState:
    """Load a QML fixture file and return QMLState."""
    loader = QMLLoader(schema_path=None)
    qml_path = FIXTURES_DIR / filename
    data = loader.load_from_path(str(qml_path))
    return QMLState(data)


@pytest.mark.integration
@pytest.mark.flow
class TestFlowInitialization:
    """Test FlowProcessor initialization with real QML files."""

    def test_initialization_creates_navigation_path(self):
        """Test that initialization creates a navigation path from topological order."""
        state = load_qml_fixture("branching_flow.qml")
        FlowProcessor(state)

        nav_path = state.get_navigation_path()
        assert nav_path is not None
        assert len(nav_path) > 0
        # First item should be q_start (no dependencies)
        assert nav_path[0] == "q_start"

    def test_initialization_executes_code_init(self):
        """Test that codeInit is executed during initialization."""
        state = load_qml_fixture("branching_flow.qml")
        FlowProcessor(state)

        # codeInit's variables are the state the first history entry derives from
        assert state["init_variables"] == {"score": 0}

    def test_initialization_sets_items_unvisited(self):
        """Test that all items start as unvisited."""
        state = load_qml_fixture("branching_flow.qml")
        FlowProcessor(state)

        for item in state.get_items():
            assert item.get("visited") is False

    def test_initialization_respects_dependencies_in_navigation_path(self):
        """Test that navigation path respects item dependencies."""
        state = load_qml_fixture("dependencies.qml")
        FlowProcessor(state)

        nav_path = state.get_navigation_path()

        # q_employed must come before q_job_title and q_years_employed
        employed_idx = nav_path.index("q_employed")
        job_title_idx = nav_path.index("q_job_title")
        years_idx = nav_path.index("q_years_employed")

        assert employed_idx < job_title_idx
        assert employed_idx < years_idx


@pytest.mark.integration
@pytest.mark.flow
class TestForwardNavigation:
    """Test forward navigation through the survey."""

    def test_first_item_is_returned_on_initial_navigation(self):
        """Test that the first item in topological order is returned initially."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        current = processor.get_current_item(state)
        assert current is not None
        assert current["id"] == "q_start"

    def test_navigation_adds_to_history(self):
        """Test that navigating to an item adds it to history."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)

        history = state.get_history()
        assert "q_start" in history

    def test_forward_navigation_skips_items_with_unsatisfied_preconditions(self):
        """Test that items with unsatisfied preconditions are skipped."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Get first item and process with "Yes" to start
        current = processor.get_current_item(state)
        assert current["id"] == "q_start"

        # Process with outcome=1 (Yes)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        # Next should be q_path (precondition: q_start.outcome == 1)
        current = processor.get_current_item(state)
        assert current["id"] == "q_path"

    def test_forward_navigation_skips_branch_with_unsatisfied_condition(self):
        """Test that entire branch is skipped when precondition is not met."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # q_start -> Yes
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)  # q_path

        # q_path -> Technology (1)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)

        # Next should be tech path, not nature path
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_interest"

        # Complete tech path
        processor.process_item(state, "q_tech_interest", 2, source=SOURCE_RESPONDENT)
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_experience"

        processor.process_item(state, "q_tech_experience", 5, source=SOURCE_RESPONDENT)

        # Should skip nature path entirely and go to final
        current = processor.get_current_item(state)
        assert current["id"] == "q_final"


@pytest.mark.integration
@pytest.mark.flow
class TestOutcomeStorage:
    """Test that outcomes are properly stored in questionnaire state."""

    def test_outcome_stored_after_process_item(self):
        """Test that processing an item stores its outcome."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        item = state.get_item("q_start")
        assert get_outcome_value(item) == 1

    def test_multiple_outcomes_stored(self):
        """Test that multiple item outcomes are stored correctly."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Process several items
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)  # Technology

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 2, source=SOURCE_RESPONDENT)  # Web

        # Verify all outcomes
        assert get_outcome_value(state.get_item("q_start")) == 1
        assert get_outcome_value(state.get_item("q_path")) == 1
        assert get_outcome_value(state.get_item("q_tech_interest")) == 2

    def test_code_block_updates_score_variable(self):
        """Test that codeBlock execution updates variables."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)

        # Process q_tech_interest with outcome 2 (Web)
        # codeBlock: score = score + q_tech_interest.outcome
        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 2, source=SOURCE_RESPONDENT)

        # The state the walk carries forward holds the updated score
        assert state.tail_state()["vars"]["score"] == 2

    def test_item_marked_visited_after_processing(self):
        """Test that items are marked as visited after processing."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        item = state.get_item("q_start")
        assert item["visited"] is True


@pytest.mark.integration
@pytest.mark.flow
class TestBackwardNavigation:
    """Test backward navigation through the survey."""

    def test_backward_navigation_returns_previous_item(self):
        """Test that backward navigation returns to the previous item."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Navigate forward
        processor.get_current_item(state)  # q_start
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)  # q_path

        # Navigate backward
        previous = processor.get_current_item(state, backward=True)
        assert previous is not None
        assert previous["id"] == "q_start"

    def test_backward_navigation_marks_current_as_unvisited(self):
        """Test that backward navigation marks the current item as unvisited."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Navigate forward
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)

        # q_path should be visited
        assert state.get_item("q_path")["visited"] is True

        # Navigate backward from q_path
        processor.get_current_item(state, backward=True)

        # q_path should be unvisited now
        assert state.get_item("q_path")["visited"] is False

    def test_backward_navigation_updates_history(self):
        """Test that backward navigation removes item from history."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)

        # History should have both items
        assert "q_start" in state.get_history()
        assert "q_path" in state.get_history()

        # Navigate backward
        processor.get_current_item(state, backward=True)

        # q_path should be removed from history
        assert "q_start" in state.get_history()
        assert "q_path" not in state.get_history()

    def test_backward_navigation_at_start_returns_none(self):
        """Test that backward navigation at start returns None."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Get first item (adds to history)
        processor.get_current_item(state)

        # Try to go back from first item
        previous = processor.get_current_item(state, backward=True)

        # Should return None (can't go back further)
        assert previous is None


@pytest.mark.integration
@pytest.mark.flow
class TestOutcomePersistenceOnPathChange:
    """Test that outcomes persist when navigating backward and taking different paths."""

    def test_outcomes_persist_when_going_backward(self):
        """Test that outcomes remain when navigating backward."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Complete part of the survey
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)  # Technology

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 3, source=SOURCE_RESPONDENT)  # Mobile

        # Navigate backward to q_path
        processor.get_current_item(state, backward=True)  # to q_path

        # q_tech_interest outcome should still be there
        assert get_outcome_value(state.get_item("q_tech_interest")) == 3
        # q_path outcome should still be there
        assert get_outcome_value(state.get_item("q_path")) == 1
        # q_start outcome should still be there
        assert get_outcome_value(state.get_item("q_start")) == 1

    def test_outcomes_overwritten_when_revisiting_item(self):
        """Test that outcomes are overwritten when item is revisited with new answer."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Start survey
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)  # Technology

        # Go back and change answer
        processor.get_current_item(state, backward=True)

        # Re-answer with different value
        processor.process_item(state, "q_path", 2, source=SOURCE_RESPONDENT)  # Nature

        # Outcome should be updated
        assert get_outcome_value(state.get_item("q_path")) == 2

    def test_different_path_after_backward_navigation(self):
        """Test taking a different path after going backward."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Take Technology path first
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)  # Technology

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 2, source=SOURCE_RESPONDENT)

        # Now go back to q_path and choose Nature instead
        processor.get_current_item(state, backward=True)  # to q_path
        processor.process_item(state, "q_path", 2, source=SOURCE_RESPONDENT)  # Nature

        # Forward navigation should now go to Nature path
        current = processor.get_current_item(state)
        assert current["id"] == "q_nature_interest"

        # Old tech answers should still exist (not cleared)
        assert get_outcome_value(state.get_item("q_tech_interest")) == 2

    def test_score_recalculated_on_different_path(self):
        """Test that score is recalculated when taking a different path."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Take Technology path
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(
            state, "q_tech_interest", 3, source=SOURCE_RESPONDENT
        )  # Mobile = 3 points

        # Check score after tech_interest
        assert state.tail_state()["vars"]["score"] == 3

        # Go back and take Nature path
        processor.get_current_item(state, backward=True)  # to q_path
        processor.process_item(state, "q_path", 2, source=SOURCE_RESPONDENT)  # Nature

        processor.get_current_item(state)  # q_nature_interest
        processor.process_item(
            state, "q_nature_interest", 1, source=SOURCE_RESPONDENT
        )  # Wildlife = 1 point

        # Score should reflect new path
        assert state.tail_state()["vars"]["score"] == 1


@pytest.mark.integration
@pytest.mark.flow
class TestCompleteFlowScenarios:
    """Test complete survey flow scenarios."""

    def test_complete_technology_path(self):
        """Test completing the entire technology path."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # q_start
        current = processor.get_current_item(state)
        assert current["id"] == "q_start"
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        # q_path
        current = processor.get_current_item(state)
        assert current["id"] == "q_path"
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)  # Technology

        # q_tech_interest
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_interest"
        processor.process_item(state, "q_tech_interest", 1, source=SOURCE_RESPONDENT)  # AI

        # q_tech_experience
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_experience"
        processor.process_item(state, "q_tech_experience", 10, source=SOURCE_RESPONDENT)

        # q_final
        current = processor.get_current_item(state)
        assert current["id"] == "q_final"
        processor.process_item(state, "q_final", 1, source=SOURCE_RESPONDENT)

        # Verify final score: 1 (AI) + 10 (experience >= 5) = 11
        assert state.tail_state()["vars"]["score"] == 11

    def test_complete_nature_path(self):
        """Test completing the entire nature path."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # q_start
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        # q_path -> Nature
        processor.get_current_item(state)
        processor.process_item(state, "q_path", 2, source=SOURCE_RESPONDENT)

        # q_nature_interest
        current = processor.get_current_item(state)
        assert current["id"] == "q_nature_interest"
        processor.process_item(state, "q_nature_interest", 2, source=SOURCE_RESPONDENT)  # Plants

        # q_nature_frequency
        current = processor.get_current_item(state)
        assert current["id"] == "q_nature_frequency"
        processor.process_item(state, "q_nature_frequency", 1, source=SOURCE_RESPONDENT)  # Daily

        # q_final
        current = processor.get_current_item(state)
        assert current["id"] == "q_final"

        # Verify final score: 2 (Plants) + 5 (frequency <= 2) = 7
        assert state.tail_state()["vars"]["score"] == 7

    def test_survey_ends_when_user_declines(self):
        """Test that survey ends quickly when user declines to start."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # q_start -> No
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 2, source=SOURCE_RESPONDENT)  # No

        # Should skip q_path (precondition: q_start.outcome == 1)
        # and go directly to q_final
        current = processor.get_current_item(state)
        assert current["id"] == "q_final"

    def test_back_and_forth_multiple_times(self):
        """Test navigating back and forth multiple times."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Forward through several items
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1, source=SOURCE_RESPONDENT)

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 2, source=SOURCE_RESPONDENT)

        # Go back
        processor.get_current_item(state, backward=True)
        assert state.get_history()[-1] == "q_path"

        # Go forward again
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_interest"

        # Go back twice
        processor.get_current_item(state, backward=True)
        processor.get_current_item(state, backward=True)
        assert state.get_history()[-1] == "q_start"

        # Go forward and take different path
        current = processor.get_current_item(state)
        assert current["id"] == "q_path"
        processor.process_item(state, "q_path", 2, source=SOURCE_RESPONDENT)  # Nature

        current = processor.get_current_item(state)
        assert current["id"] == "q_nature_interest"


@pytest.mark.integration
@pytest.mark.flow
class TestDependencyBasedNavigation:
    """Test navigation with complex dependencies."""

    def test_navigation_with_dependencies_qml(self):
        """Test navigation respects dependencies in dependencies.qml."""
        state = load_qml_fixture("dependencies.qml")
        processor = FlowProcessor(state)

        # q_employed first
        current = processor.get_current_item(state)
        assert current["id"] == "q_employed"
        processor.process_item(state, "q_employed", 1, source=SOURCE_RESPONDENT)  # Yes

        # Complete the survey and verify job questions were shown
        visited_ids = []
        while True:
            current = processor.get_current_item(state)
            if current is None or current.get("isLast"):
                break
            visited_ids.append(current["id"])
            # Provide simple answers
            processor.process_item(state, current["id"], 1, source=SOURCE_RESPONDENT)

        # Job questions should have been visited (precondition satisfied)
        assert "q_job_title" in visited_ids
        assert "q_years_employed" in visited_ids

    def test_skipped_branch_when_not_employed(self):
        """Test that employment questions are skipped when not employed."""
        state = load_qml_fixture("dependencies.qml")
        processor = FlowProcessor(state)

        # q_employed -> No
        processor.get_current_item(state)
        processor.process_item(state, "q_employed", 2, source=SOURCE_RESPONDENT)

        # Should skip job questions and go to degree
        current = processor.get_current_item(state)
        assert current["id"] == "q_degree"


@pytest.mark.integration
@pytest.mark.flow
class TestPreconditionErrorHandling:
    """Test handling of malformed or unevaluatable preconditions."""

    def test_malformed_precondition_skips_item_with_warning(self, caplog):
        """An unevaluatable gate is honoured, not ignored: the item is skipped.

        Showing it would administer an item the instrument restricted, silently
        turning the interview into a different one (#658). The skip is recorded
        on QMLState so the analysis layer can tell it from an intended skip.
        """
        import logging

        state = load_qml_fixture("malformed_precondition.qml")

        with caplog.at_level(logging.WARNING):
            processor = FlowProcessor(state)

            # First question should work
            current = processor.get_current_item(state)
            assert current["id"] == "q_first"
            processor.process_item(state, "q_first", 1, source=SOURCE_RESPONDENT)

            # q_malformed is SKIPPED — navigation moves past it to q_last.
            current = processor.get_current_item(state)
            assert current["id"] == "q_last"

            # Check that a warning was logged about the malformed precondition
            assert any("Unable to evaluate" in record.message for record in caplog.records)

            # Verify warning is also collected in QMLState for data analysis
            assert state.has_warnings()
            warnings = state.get_warnings()
            assert len(warnings) >= 1
            assert any(w["item_id"] == "q_malformed" for w in warnings)
            assert any(w["type"] == "precondition" for w in warnings)

    def test_malformed_precondition_survey_completes(self):
        """The survey still reaches its end — skipping does not stall the walk.

        This is the half of the #168 stranding worry that survives: a gate that
        errors on every attempt must not trap the respondent. It does not,
        because a False precondition advances navigation exactly as a
        legitimately-False one does.
        """
        state = load_qml_fixture("malformed_precondition.qml")
        processor = FlowProcessor(state)

        # Navigate through the entire survey with a max iterations guard
        visited_ids = []
        max_iterations = 10
        for _ in range(max_iterations):
            current = processor.get_current_item(state)
            if current is None:
                break
            current_id = current["id"]
            if current_id not in visited_ids:
                visited_ids.append(current_id)
            processor.process_item(state, current_id, 1, source=SOURCE_RESPONDENT)
            if current.get("isLast"):
                break

        # The gated item is the only one left out; the walk still reaches the end.
        assert "q_first" in visited_ids
        assert "q_malformed" not in visited_ids
        assert "q_last" in visited_ids


@pytest.mark.integration
@pytest.mark.flow
class TestResponseTiming:
    """Per-answer timing events written at the FlowProcessor answer seam.

    The blueprint-level half of the capture — presentation stamping, refresh
    idempotence, resume, and the respondent/interviewer tag — lives in
    test_flow_blueprint_timing.py, because those seams are HTTP endpoints.
    """

    def test_forward_answer_records_one_committed_event(self):
        """An answered item leaves exactly one closed, committed event whose
        submission moment is at or after its presentation moment."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        events = state.get_timing_events()
        assert len(events) == 1
        event = events[0]
        assert event["i"] == "q_start"
        assert event["k"] is None
        assert event["c"] is True
        assert event["src"] == SOURCE_RESPONDENT
        assert event["s"] >= event["p"]

    def test_backward_convenience_save_is_uncommitted_and_not_an_attempt(self):
        """KTD4: a save made while stepping back is timed but is not an answer
        attempt — the event exists (the time was spent) and the attempt count
        stays zero, so a back-and-forth does not inflate R12's per-item count."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(
            state, "q_start", 1, source=SOURCE_RESPONDENT, skip_postcondition=True
        )

        events = state.get_timing_events()
        assert len(events) == 1
        assert events[0]["c"] is False
        assert state.count_timing_attempts("q_start", None) == 0

    def test_reanswer_after_going_back_records_two_events(self):
        """AE2: answering, stepping back, and re-answering keeps BOTH events —
        one uncommitted, one committed — because the log is append-only and the
        second attempt must not overwrite the first attempt's duration."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)
        # The convenience save the UI issues on the way back, then a fresh
        # presentation and a real re-answer.
        processor.process_item(
            state, "q_start", 2, source=SOURCE_RESPONDENT, skip_postcondition=True
        )
        state.open_timing_event("q_start", None, SOURCE_RESPONDENT)
        processor.process_item(state, "q_start", 1, source=SOURCE_RESPONDENT)

        events = state.get_timing_events_for_item("q_start")
        assert [event["c"] for event in events] == [True, False, True]
        # Only the two real answers count as attempts.
        assert state.count_timing_attempts("q_start", None) == 2

    def test_roster_iterations_record_independent_events(self):
        """AE1: the same item answered under two Roster iterations is two
        answers, not two attempts at one — the events carry distinct iteration
        keys and each iteration's attempt count is 1."""
        state = load_qml_fixture("roster_numeric.qml")
        processor = FlowProcessor(state)

        # 2 family members → mask 3 → iterations under bits 1 and 2.
        processor.get_current_item(state)
        processor.process_item(state, "q_family_count", 2, source=SOURCE_RESPONDENT)

        for _step in range(10):
            item = processor.get_current_item(state)
            if item is None or item.get("isLast"):
                break
            processor.process_item(state, item["id"], 1, source=SOURCE_RESPONDENT)

        name_events = state.get_timing_events_for_item("q_member_name")
        assert [event["k"] for event in name_events] == [1, 2]
        assert state.count_timing_attempts("q_member_name", 1) == 1
        assert state.count_timing_attempts("q_member_name", 2) == 1

    def test_process_item_without_source_raises(self):
        """The argument is required, not defaulted: a driver that forgets it
        must fail where it is written rather than record answers no consumer
        can separate from human ones (KTD12)."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        with pytest.raises(TypeError):
            processor.process_item(state, "q_start", 1)

        assert state.get_timing_events() == []

    def test_unknown_source_is_refused(self):
        """An unrecognized tag is rejected rather than stored — the same rule
        add_warning applies to severity, and for the same reason: a typo would
        silently escape every source-based filter downstream."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        with pytest.raises(ValueError, match="Unknown timing source"):
            processor.process_item(state, "q_start", 1, source="robot")

        assert state.get_timing_events() == []

    def test_source_is_recorded_verbatim_per_driver(self):
        """The tag on the event is the one the driver supplied — a machine fill
        stays separable from a human answer in the same log (AE5)."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1, source=SOURCE_SYNTHETIC)

        assert state.get_timing_events()[0]["src"] == SOURCE_SYNTHETIC


# q_b's codeBlock sets `risk` only on one branch and writes q_flag's outcome on
# the same branch; q_c reads the variable, q_d the written outcome. {init} is
# replaced per test to seed `risk` (or not) in codeInit.
_QML_CONDITIONAL_ASSIGNMENT = """
questionnaire:
  title: Conditional assignment
  {init}
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_b
          kind: Question
          title: Score
          codeBlock: |
            if q_b.outcome > 5:
                risk = 1
                q_flag.outcome = 1
          input:
            control: Radio
            labels:
              2: Low
              9: High
        - id: q_flag
          kind: Question
          title: Flag set by q_b, never asked
          precondition:
            - predicate: "q_b.outcome == 100"
              hint: Never
          input:
            control: Radio
            labels:
              1: Flagged
        - id: q_c
          kind: Question
          title: Follow-up on risk
          precondition:
            - predicate: "risk == 1"
              hint: At risk
          input:
            control: Radio
            labels:
              1: "Yes"
        - id: q_d
          kind: Question
          title: Follow-up on the flag
          precondition:
            - predicate: "q_flag.outcome == 1"
              hint: Flagged
          input:
            control: Radio
            labels:
              1: "Yes"
        - id: q_end
          kind: Question
          title: End
          input:
            control: Radio
            labels:
              1: Done
"""


# q_a's codeBlock writes q_x on one branch, q_c's unconditionally; q_x is
# never asked.
_QML_TWO_WRITERS = """
questionnaire:
  title: Two writers
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_a
          kind: Question
          title: Score
          codeBlock: |
            if q_a.outcome > 5:
                q_x.outcome = 1
          input:
            control: Radio
            labels:
              2: Low
              9: High
        - id: q_x
          kind: Question
          title: Written, never asked
          precondition:
            - predicate: "q_a.outcome == 100"
              hint: Never
          input:
            control: Radio
            labels:
              1: One
              2: Two
        - id: q_c
          kind: Question
          title: Override
          codeBlock: "q_x.outcome = 2"
          input:
            control: Radio
            labels:
              1: Done
        - id: q_end
          kind: Question
          title: End
          input:
            control: Radio
            labels:
              1: Done
"""


def _conditional_state(init: str = "") -> QMLState:
    qml = _QML_CONDITIONAL_ASSIGNMENT.replace("{init}", init)
    return QMLState(QMLLoader(schema_path=None).load_from_string(qml))


def _answer_high_then_low(state: QMLState) -> tuple[FlowProcessor, list[str], str]:
    """Answer q_b=9, walk to the next item, go back, re-answer q_b=2.

    Returns the processor, the items presented after the first answer, and
    the id presented after the re-answer.
    """
    processor = FlowProcessor(state)
    assert processor.get_current_item(state)["id"] == "q_b"
    processor.process_item(state, "q_b", 9, source=SOURCE_RESPONDENT)
    first = processor.get_current_item(state)["id"]
    processor.process_item(state, first, 1, source=SOURCE_RESPONDENT)
    second = processor.get_current_item(state)["id"]

    # Back twice to q_b, then change the answer so the branch is not taken.
    processor.get_current_item(state, backward=True)
    assert processor.get_current_item(state, backward=True)["id"] == "q_b"
    processor.process_item(state, "q_b", 2, source=SOURCE_RESPONDENT)
    after = processor.get_current_item(state)["id"]
    return processor, [first, second], after


@pytest.mark.integration
@pytest.mark.flow
class TestStateChainRollsBackOnBackwardEdit:
    """#1021: a variable (or a codeBlock-written outcome) that a re-answer no
    longer produces is gone from the state downstream items see — absent, not
    left over from the abandoned answer."""

    def test_a_variable_no_longer_assigned_is_absent_downstream(self):
        state = _conditional_state()

        _, before, after = _answer_high_then_low(state)

        assert before == ["q_c", "q_d"]
        assert after == "q_end"
        assert "risk" not in state.tail_state()["vars"]

    def test_a_codeinit_seed_is_what_downstream_reads_after_the_edit(self):
        state = _conditional_state('codeInit: "risk = 0"')

        _, before, after = _answer_high_then_low(state)

        assert before == ["q_c", "q_d"]
        assert after == "q_end"
        assert state.tail_state()["vars"]["risk"] == 0

    def test_a_codeblock_written_outcome_is_rolled_back(self):
        state = _conditional_state()

        _answer_high_then_low(state)

        flag = state.get_item("q_flag")
        assert flag["outcome"] is None
        assert flag["visited"] is False

    def test_answering_an_earlier_writer_rolls_back_every_later_write(self):
        """q_a's codeBlock writes q_x, then q_c's overwrites it. Answering q_a
        again rewinds past q_c, so both writes are undone newest first and the
        re-run's branch decides q_x afresh."""
        state = QMLState(QMLLoader(schema_path=None).load_from_string(_QML_TWO_WRITERS))
        processor = FlowProcessor(state)
        for item_id, answer in (("q_a", 9), ("q_c", 1)):
            assert processor.get_current_item(state)["id"] == item_id
            processor.process_item(state, item_id, answer, source=SOURCE_RESPONDENT)
        assert state.get_item("q_x")["outcome"] == 2

        processor.process_item(state, "q_a", 2, source=SOURCE_RESPONDENT)

        assert state.get_item("q_x")["outcome"] is None
        assert state.get_history() == ["q_a"]

    def test_answering_an_earlier_item_directly_rewinds_the_walk(self):
        """An API driver may answer any item. Answering q_b while q_d is
        presented is a backward edit: later entries go, and the walk re-reaches
        them against the new state rather than one built on the old answer."""
        state = _conditional_state()
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_b", 9, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)
        processor.process_item(state, "q_c", 1, source=SOURCE_RESPONDENT)
        assert processor.get_current_item(state)["id"] == "q_d"

        processor.process_item(state, "q_b", 2, source=SOURCE_RESPONDENT)

        assert state.get_history() == ["q_b"]
        assert "risk" not in state.tail_state()["vars"]
        assert state.get_item("q_c")["visited"] is False
        assert processor.get_current_item(state)["id"] == "q_end"

    def test_history_lists_stay_in_lockstep_through_edits(self):
        state = _conditional_state()

        _answer_high_then_low(state)

        assert (
            len(state["history"]) == len(state["history_iter_key"]) == len(state["history_state"])
        )


@pytest.mark.integration
@pytest.mark.flow
class TestLegacyItemContextUpgrade:
    """A survey persisted before the state chain carried a merged `context`
    per item; loading it builds `history_state` from those contexts, so it
    reads the same variables it did before, and drops the item key."""

    def test_item_contexts_become_the_history_state(self):
        state = _conditional_state('codeInit: "risk = 0"')
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_b", 9, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)

        legacy = dict(state)
        legacy.pop("history_state")
        legacy.pop("init_variables")
        contexts = {
            "q_b": {"risk": 0},
            "q_flag": {"risk": 1},
            "q_c": {"risk": 1},
            "q_d": {"risk": 1},
            "q_end": {"risk": 1},
        }
        for item in legacy["items"]:
            item["context"] = contexts[item["id"]]

        upgraded = QMLState(legacy)

        assert upgraded["init_variables"] == {"risk": 0}
        assert [entry["vars"] for entry in upgraded["history_state"]] == [
            {"risk": 1},
            {"risk": 1},
        ]
        assert all("context" not in item for item in upgraded["items"])

    def test_an_answered_last_entry_takes_the_state_its_codeblock_broadcast(self):
        """Saved between an answer and the next walk step: the last history
        item's own context predates its codeBlock, so its entry takes the
        context of the item after it, which received the broadcast."""
        state = _conditional_state()
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_b", 9, source=SOURCE_RESPONDENT)

        legacy = dict(state)
        legacy.pop("history_state")
        legacy.pop("init_variables")
        for item in legacy["items"]:
            item["context"] = {} if item["id"] == "q_b" else {"risk": 1}

        upgraded = QMLState(legacy)

        assert upgraded["history"] == ["q_b"]
        assert upgraded["history_state"][0]["vars"] == {"risk": 1}
