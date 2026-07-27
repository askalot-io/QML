"""
Integration tests for external-input prefill (QML External Inputs plan, U2).

Tests the auto-answer resolver `FlowProcessor.apply_external_inputs`, which
drives `external: true` items through the normal `process_item` path at survey
init from a service-supplied `{item_id: value}` injection map:

- Happy: an in-domain injection auto-answers the item, runs its codeBlock, and
  hides it from the flow (AE1 / R9).
- Missing: an external item with no injection is asked in the normal flow (AE2 / R10).
- Out-of-domain: a value outside the item's declared domain is rejected and the
  item is asked (AE3 / R11).
- Provenance: an auto-answered outcome carries the externally-supplied marker (R12).
- Precondition-false: a precondition-false external stays absent despite a value.
- Postcondition-fail: an in-domain value failing the postcondition leaves the
  item unresolved (no history, no provenance) and asked in the flow.
- History: an auto-answered external item appears in state['history'] so U3 can
  extract it.
- Re-entrancy: a second apply pass does not re-inject or re-run codeBlocks.
- Guard: a non-external item with an injection value is ignored.
- Ordering: an external item whose codeBlock feeds a later external resolves in
  dependency order.
- Timing (R9): a prefilled answer records a committed event tagged
  `external_prefill` with zero elapsed time — the honest record for a value
  nobody read a question to produce.
- Decline warnings (R17): every gate that turns a supplied value away records a
  `external_prefill_<gate>` warning naming itself, so a dropped value is
  detectable instead of surviving only as a counter in a log line.

These integration tests build a FlowProcessor over inline QML (no service
layer, no repository) and assert on the resulting QMLState — the shared apply
logic both survey runtimes (Portor + SirWay) call in U5.
"""

from typing import Any

import pytest
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import SOURCE_EXTERNAL_PREFILL, QMLState


def _state(qml: str) -> QMLState:
    """Load inline QML into a QMLState (schema off — inline docs omit qmlVersion)."""
    return QMLState(QMLLoader(schema_path=None).load_from_string(qml))


# A questionnaire with one external item (q_rotate_out, domain {0,1}, a codeBlock
# that derives `rotate_flag`) followed by a normal question. The external item is
# NOT gated, so it is presented first when no injection is applied.
_QML_BASIC = """
questionnaire:
  title: External basic
  codeInit: |
    rotate_flag = -1
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_rotate_out
          kind: Question
          title: Rotate out?
          external: true
          input:
            control: Radio
            labels:
              0: "No"
              1: "Yes"
          codeBlock: |
            rotate_flag = q_rotate_out.outcome
        - id: q_followup
          kind: Question
          title: Follow-up
          input:
            control: Radio
            labels:
              1: A
              2: B
"""


def _first_item_id(state: QMLState) -> str | None:
    processor = FlowProcessor.from_cached_state(state)
    item = processor.get_current_item(state)
    return item.get("id") if item else None


def _decline_warning(state: QMLState, item_id: str, gate: str) -> dict[str, Any]:
    """The single decline warning this gate recorded for the item.

    Asserts uniqueness: a declined prefill is one event, and each gate is
    mutually exclusive with the others within one apply pass.
    """
    matches = [
        w
        for w in state.get_warnings()
        if w["item_id"] == item_id and w["type"] == f"external_prefill_{gate}"
    ]
    assert len(matches) == 1, f"expected one {gate} decline for {item_id}, got {matches!r}"
    return matches[0]


@pytest.mark.integration
@pytest.mark.flow
class TestApplyExternalInputs:
    def test_in_domain_value_auto_answers_and_runs_codeblock(self):
        """AE1 / R9: an in-domain injection auto-answers the item, its codeBlock
        runs (deriving rotate_flag), and it is not presented."""
        state = _state(_QML_BASIC)
        processor = FlowProcessor(state)
        summary = processor.apply_external_inputs(state, {"q_rotate_out": 1})

        assert summary["applied"] == 1
        assert "q_rotate_out" in summary["item_ids"]

        item = state.get_item("q_rotate_out")
        assert item["outcome"] == 1
        assert item["visited"] is True
        # codeBlock ran: derived variable set on downstream context.
        followup = state.get_item("q_followup")
        assert followup["context"]["rotate_flag"] == 1
        # Not presented — the flow skips straight to the follow-up.
        assert _first_item_id(state) == "q_followup"

    def test_missing_value_is_asked_in_flow(self):
        """AE2 / R10: an external item with no injection entry is presented."""
        state = _state(_QML_BASIC)
        processor = FlowProcessor(state)
        summary = processor.apply_external_inputs(state, {})

        assert summary["applied"] == 0
        item = state.get_item("q_rotate_out")
        assert item.get("outcome") is None
        assert item.get("visited") is False
        assert _first_item_id(state) == "q_rotate_out"

    def test_out_of_domain_value_rejected_and_asked(self):
        """AE3 / R11: a value outside the declared domain ({0,1}) is not applied;
        the item is asked in the flow — never silently accepted.

        R17: this is the decline that matters most — a value the platform held
        about this respondent that the instrument's own domain refuses. It is
        recorded rather than dropped into a counter.
        """
        state = _state(_QML_BASIC)
        processor = FlowProcessor(state)
        summary = processor.apply_external_inputs(state, {"q_rotate_out": 7})

        assert summary["applied"] == 0
        assert summary["skipped"] == 1
        item = state.get_item("q_rotate_out")
        assert item.get("outcome") is None
        assert item.get("visited") is False
        assert not state.is_externally_supplied("q_rotate_out")
        assert _first_item_id(state) == "q_rotate_out"

        warning = _decline_warning(state, "q_rotate_out", "domain")
        assert warning["severity"] == "degraded"
        assert "declared domain" in warning["message"]
        # The rejected value is respondent data and never appears in the record.
        assert "7" not in warning["message"]

    def test_provenance_marker_recorded(self):
        """R12 (write): an auto-answered item carries the externally-supplied marker."""
        state = _state(_QML_BASIC)
        processor = FlowProcessor(state)
        processor.apply_external_inputs(state, {"q_rotate_out": 0})

        assert state.is_externally_supplied("q_rotate_out")
        assert state.get_external_provenance("q_rotate_out") == {"source": "q_rotate_out"}
        # A normal, un-injected item is unmarked.
        assert not state.is_externally_supplied("q_followup")

    def test_prefill_records_a_committed_zero_duration_event(self):
        """R9: a prefilled answer is timed like any other, tagged
        `external_prefill`, and elapses no time — nobody read the question. The
        zero is the honest record, and the tag is what keeps a survey full of
        prefills from dragging a respondent-duration median to the floor."""
        state = _state(_QML_BASIC)
        processor = FlowProcessor(state)
        processor.apply_external_inputs(state, {"q_rotate_out": 1})

        events = state.get_timing_events_for_item("q_rotate_out")
        assert len(events) == 1
        event = events[0]
        assert event["src"] == SOURCE_EXTERNAL_PREFILL
        assert event["c"] is True
        # Opened and closed inside the one call, so the span is the call itself.
        assert event["s"] - event["p"] < 1000
        # A declined value produces no event at all — nothing was answered.
        assert state.get_timing_events_for_item("q_followup") == []

    def test_auto_answered_item_in_history(self):
        """AE1: an auto-answered external item appears in state['history'] so the
        history-walking Bronze extractor (U3) emits it."""
        state = _state(_QML_BASIC)
        processor = FlowProcessor(state)
        processor.apply_external_inputs(state, {"q_rotate_out": 1})

        assert "q_rotate_out" in state.get_history()
        # iter_key lockstep: non-roster entry carries None.
        idx = state.get_history().index("q_rotate_out")
        assert state.get("history_iter_key")[idx] is None

    def test_precondition_false_external_stays_absent(self):
        """A precondition-false external is left unvisited despite a value being
        present (absent, not answered) — running its codeBlock at init would
        corrupt downstream branching."""
        qml = """
questionnaire:
  title: Gated external
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_gate
          kind: Question
          title: Gate
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_ext
          kind: Question
          title: External gated on q_gate
          external: true
          precondition:
            - predicate: "q_gate.outcome == 1"
          input:
            control: Radio
            labels:
              0: "No"
              1: "Yes"
"""
        state = _state(qml)
        processor = FlowProcessor(state)
        # q_gate is unanswered at init, so q_ext's precondition is False.
        summary = processor.apply_external_inputs(state, {"q_ext": 1})

        assert summary["applied"] == 0
        assert summary["skipped"] == 1
        item = state.get_item("q_ext")
        assert item.get("outcome") is None
        assert item.get("visited") is False
        assert not state.is_externally_supplied("q_ext")

        warning = _decline_warning(state, "q_ext", "precondition")
        assert warning["severity"] == "degraded"
        assert "precondition" in warning["message"]

    def test_postcondition_fail_leaves_unresolved(self):
        """An in-domain value that fails the item's postcondition leaves the item
        unresolved — no history entry, no provenance — and asked in the flow."""
        qml = """
questionnaire:
  title: Postcondition external
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_ext
          kind: Question
          title: External with postcondition
          external: true
          postcondition:
            - predicate: "q_ext.outcome == 1"
              hint: Must be 1
          input:
            control: Radio
            labels:
              0: "No"
              1: "Yes"
"""
        state = _state(qml)
        processor = FlowProcessor(state)
        # 0 is in-domain but fails the postcondition (must be 1).
        summary = processor.apply_external_inputs(state, {"q_ext": 0})

        assert summary["applied"] == 0
        assert summary["skipped"] == 1
        assert "q_ext" not in state.get_history()
        assert not state.is_externally_supplied("q_ext")

        warning = _decline_warning(state, "q_ext", "postcondition")
        assert warning["severity"] == "degraded"
        # The gate's own hint identifies which rule refused the value.
        assert "Must be 1" in warning["message"]

    def test_reentrancy_does_not_reinject(self):
        """A second apply pass honors the external_inputs_applied sentinel — no
        re-injection, no re-run of external codeBlocks."""
        state = _state(_QML_BASIC)
        processor = FlowProcessor(state)
        first = processor.apply_external_inputs(state, {"q_rotate_out": 1})
        assert first["applied"] == 1
        assert state.external_inputs_applied()

        # Second pass (fresh processor, e.g. a re-entrant init) is a no-op.
        processor2 = FlowProcessor.from_cached_state(state)
        second = processor2.apply_external_inputs(state, {"q_rotate_out": 0})
        assert second["applied"] == 0
        # Outcome unchanged from the first pass (not overwritten with 0).
        assert state.get_item("q_rotate_out")["outcome"] == 1
        # History not duplicated.
        assert state.get_history().count("q_rotate_out") == 1

    def test_non_external_item_ignored(self):
        """Guard: a value for a non-`external` item is ignored (only external
        items are injectable) — and the mismatch between what the campaign
        mapped and what the instrument declares is recorded."""
        state = _state(_QML_BASIC)
        processor = FlowProcessor(state)
        summary = processor.apply_external_inputs(state, {"q_followup": 2})

        assert summary["applied"] == 0
        item = state.get_item("q_followup")
        assert item.get("outcome") is None
        assert item.get("visited") is False

        warning = _decline_warning(state, "q_followup", "not_external")
        assert warning["severity"] == "degraded"
        assert "external: true" in warning["message"]

    def test_repeated_item_prefill_declines_and_names_the_block_gate(self):
        """A Roster inner item has no well-defined single prefill value, so it is
        asked in the flow — and the declined value is recorded against the gate
        that turned it away, not lost in the skipped counter."""
        qml = """
questionnaire:
  title: Roster external
  codeInit: |
    mask = 1
  blocks:
    - id: per_subject
      kind: Roster
      iterateOver: "mask"
      labels:
        1: "First"
      items:
        - id: q_ext
          kind: Question
          title: External inside a Roster
          external: true
          input:
            control: Radio
            labels:
              0: "No"
              1: "Yes"
"""
        state = _state(qml)
        processor = FlowProcessor(state)
        summary = processor.apply_external_inputs(state, {"q_ext": 1})

        assert summary["applied"] == 0
        assert summary["skipped"] == 1
        assert state.get_item("q_ext").get("outcome") is None

        warning = _decline_warning(state, "q_ext", "block_kind")
        assert warning["severity"] == "degraded"
        assert warning["block_id"] == "per_subject"

    def test_dependent_externals_resolve_in_order(self):
        """An external item whose codeBlock feeds a later external item resolves
        in dependency order — process_item propagates the variable forward."""
        qml = """
questionnaire:
  title: Dependent externals
  codeInit: |
    base = 0
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_a
          kind: Question
          title: External A
          external: true
          input:
            control: Radio
            labels:
              0: "Zero"
              1: "One"
          codeBlock: |
            base = q_a.outcome + 10
        - id: q_b
          kind: Question
          title: External B gated on A's derived variable
          external: true
          precondition:
            - predicate: "base == 11"
          input:
            control: Radio
            labels:
              0: "No"
              1: "Yes"
"""
        state = _state(qml)
        processor = FlowProcessor(state)
        # A=1 → base becomes 11 → B's precondition (base == 11) holds → B applies.
        summary = processor.apply_external_inputs(state, {"q_a": 1, "q_b": 1})

        assert summary["applied"] == 2
        assert state.get_item("q_a")["outcome"] == 1
        assert state.get_item("q_b")["outcome"] == 1
        assert state.is_externally_supplied("q_b")

    def test_no_external_items_is_noop_but_marks_sentinel(self):
        """A questionnaire with no external items: apply is a no-op and the
        resulting state is byte-identical to today apart from the sentinel."""
        qml = """
questionnaire:
  title: No externals
  blocks:
    - id: main
      kind: Group
      items:
        - id: q1
          kind: Question
          title: Q1
          input:
            control: Radio
            labels:
              1: A
              2: B
"""
        state = _state(qml)
        processor = FlowProcessor(state)
        summary = processor.apply_external_inputs(state, {"q1": 1})

        assert summary == {"applied": 0, "skipped": 0, "item_ids": []}
        assert state.get_item("q1").get("outcome") is None
        assert state.external_inputs_applied()
