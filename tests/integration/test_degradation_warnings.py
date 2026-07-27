"""
Integration tests for the engine's degradation-warning collection (U4).

A warning records a point where the FlowProcessor degraded instead of failing —
it kept an answer, a path, or a half-built variable state that its own rules
would have rejected. These tests cover the collection contract end to end:

- A codeBlock that raises at runtime records a `codeblock` warning at `critical`
  severity AND the flow continues past it (R15) — the failure is surfaced to the
  caller instead of being swallowed inside PythonRunner.
- No `__error__` sentinel reaches any downstream item's context.
- Partial codeBlock state survives the raise: variables assigned before the
  failing statement stay assigned, they are not rolled back.
- A Roster `iterateOver` mask bit with no declared label records an
  `informational` warning and is still ignored for traversal (R18).
- Dedup on (item, iteration, type): a re-answered item that re-raises the same
  evaluation error is ONE entry with count 2 (R20), while the same error under
  two Roster iterations is two entries.
- Every recorded warning carries severity, block_id, iter_key, count, and both
  timestamps — no field is optional (KTD12).
- add_warning refuses an unrecognized severity rather than recording it.

These integration tests drive a real FlowProcessor over inline QML (no service
layer, no repository) and assert on the resulting QMLState, because the point
under test is what the engine WRITES about its own fallbacks — the input to
dataset exclusion and to the campaign-level degradation rollup.
"""

import pytest
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import SOURCE_RESPONDENT, QMLState

# Fields every warning record carries. Named once here so the "no field is
# optional" assertion and the shape test cannot drift apart.
REQUIRED_WARNING_FIELDS = (
    "item_id",
    "block_id",
    "iter_key",
    "type",
    "severity",
    "message",
    "count",
    "first_seen",
    "last_seen",
)


def _state(qml: str) -> QMLState:
    """Load inline QML into a QMLState (schema off — inline docs omit qmlVersion)."""
    return QMLState(QMLLoader(schema_path=None).load_from_string(qml))


def _warnings_of_type(state: QMLState, warning_type: str) -> list[dict]:
    return [w for w in state.get_warnings() if w["type"] == warning_type]


# q1's codeBlock assigns one variable and then raises (NameError on an
# undefined name) — the shape that distinguishes "recorded and continued" from
# "rolled back", since `first_var` must survive and `second_var` must not exist.
_QML_RAISING_CODEBLOCK = """
questionnaire:
  title: Raising code block
  blocks:
    - id: main
      kind: Group
      items:
        - id: q1
          kind: Question
          title: First
          input:
            control: Radio
            labels:
              1: A
              2: B
          codeBlock: |
            first_var = 1
            second_var = never_defined_anywhere + 1
        - id: q2
          kind: Question
          title: Second
          input:
            control: Radio
            labels:
              1: A
              2: B
"""


@pytest.mark.integration
@pytest.mark.flow
class TestCodeBlockRuntimeFailure:
    def test_raising_codeblock_records_critical_warning_and_flow_continues(self):
        """R15: the runtime failure is recorded as `critical`, and the respondent
        is not blocked — the flow moves on to the next item."""
        state = _state(_QML_RAISING_CODEBLOCK)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        result = processor.process_item(state, "q1", 1, source=SOURCE_RESPONDENT)

        # The answer is accepted and the walk advances: a broken codeBlock must
        # not strand a respondent mid-instrument.
        assert result["success"] is True
        assert processor.get_current_item(state)["id"] == "q2"

        codeblock_warnings = _warnings_of_type(state, "codeblock")
        assert len(codeblock_warnings) == 1
        warning = codeblock_warnings[0]
        assert warning["item_id"] == "q1"
        assert warning["severity"] == "critical"
        assert "never_defined_anywhere" in warning["message"]

    def test_no_error_sentinel_in_downstream_contexts(self):
        """The failure travels as an exception, not as a context key: no item
        downstream of the failure carries an `__error__` variable."""
        state = _state(_QML_RAISING_CODEBLOCK)
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q1", 1, source=SOURCE_RESPONDENT)

        for item in state.get_all_items():
            assert "__error__" not in item["context"]

    def test_partial_codeblock_state_is_preserved(self):
        """Assignments completed before the raise stay assigned — the engine
        continues on the partial state (which is exactly why the warning is
        `critical`), it does not roll back."""
        state = _state(_QML_RAISING_CODEBLOCK)
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q1", 1, source=SOURCE_RESPONDENT)

        downstream_context = state.get_item("q2")["context"]
        assert downstream_context["first_var"] == 1
        assert "second_var" not in downstream_context

    def test_raising_code_init_records_critical_warning(self):
        """R16: a codeInit block that raises must record a `critical` warning so
        the survey is excluded from datasets — the failure runs before any item,
        so it is attributed to the reserved `codeInit` id rather than dropped.
        Without an id, the warning's `if item_id:` guard would fire silently and
        the corrupted survey would pass the critical-warning dataset exclusion.
        """
        qml = _QML_RAISING_CODEBLOCK.replace(
            "questionnaire:\n  title: Raising code block",
            "questionnaire:\n  title: Raising code init\n"
            "  codeInit: |\n    boom = never_defined_at_init + 1",
        )
        state = _state(qml)

        # Building the processor runs _initialize_questionnaire, which executes
        # codeInit. The raise must not abort init — the respondent still reaches
        # the first item — and it must leave a critical warning behind.
        processor = FlowProcessor(state)
        assert processor.get_current_item(state)["id"] == "q1"

        codeblock_warnings = _warnings_of_type(state, "codeblock")
        assert len(codeblock_warnings) == 1
        warning = codeblock_warnings[0]
        assert warning["item_id"] == "codeInit"
        assert warning["severity"] == "critical"
        assert "never_defined_at_init" in warning["message"]


# A Roster whose mask (5 = bits 1 and 4) asks for an iteration the block never
# declared a label for.
_QML_UNDECLARED_MASK_BIT = """
questionnaire:
  title: Undeclared mask bit
  codeInit: |
    mask = 5
  blocks:
    - id: intro
      kind: Group
      items:
        - id: q_intro
          kind: Question
          title: Intro
          input:
            control: Radio
            labels:
              1: A
              2: B
    - id: per_subject
      kind: Roster
      iterateOver: "mask"
      labels:
        1: "First"
      items:
        - id: q_note
          kind: Question
          title: Note
          input:
            control: Slider
            min: 1
            max: 5
"""


@pytest.mark.integration
@pytest.mark.flow
class TestRosterMaskWarnings:
    def test_undeclared_mask_bit_is_recorded_and_still_not_traversed(self):
        """R18: the dropped bit becomes visible as an `informational` warning —
        the dataset is unaffected, the pass simply covers fewer subjects than
        the mask asked for."""
        state = _state(_QML_UNDECLARED_MASK_BIT)
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_intro", 1, source=SOURCE_RESPONDENT)
        # Reaching the roster item is what enters the pass and evaluates the mask.
        assert processor.get_current_item(state)["id"] == "q_note"

        mask_warnings = _warnings_of_type(state, "roster_mask_undeclared")
        assert len(mask_warnings) == 1
        assert mask_warnings[0]["severity"] == "informational"
        assert "[4]" in mask_warnings[0]["message"]

        # Traversal is unchanged: only the declared bit is iterated.
        assert state.get_roster_active_keys("per_subject") == [1]


# A postcondition that cannot be evaluated (undefined name) fails open, so the
# answer is kept and a warning recorded — once per evaluation.
_QML_MALFORMED_POSTCONDITION = """
questionnaire:
  title: Malformed postcondition
  blocks:
    - id: main
      kind: Group
      items:
        - id: q1
          kind: Question
          title: First
          postcondition:
            - predicate: "q1.outcome > never_defined_anywhere"
              hint: Unevaluatable
          input:
            control: Radio
            labels:
              1: A
              2: B
"""

# The same unevaluatable postcondition, on an item repeated under two Roster
# iterations (mask 3 = bits 1 and 2, both declared).
_QML_ROSTER_MALFORMED_POSTCONDITION = """
questionnaire:
  title: Roster malformed postcondition
  codeInit: |
    mask = 3
  blocks:
    - id: intro
      kind: Group
      items:
        - id: q_intro
          kind: Question
          title: Intro
          input:
            control: Radio
            labels:
              1: A
              2: B
    - id: per_subject
      kind: Roster
      iterateOver: "mask"
      labels:
        1: "First"
        2: "Second"
      items:
        - id: q_note
          kind: Question
          title: Note
          postcondition:
            - predicate: "q_note.outcome > never_defined_anywhere"
              hint: Unevaluatable
          input:
            control: Slider
            min: 1
            max: 5
"""


@pytest.mark.integration
@pytest.mark.flow
class TestWarningDeduplication:
    def test_reanswered_item_increments_count_instead_of_appending(self):
        """R20: a re-answered item re-raises the same evaluation error. That is
        one defect seen twice, not two defects."""
        state = _state(_QML_MALFORMED_POSTCONDITION)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        processor.process_item(state, "q1", 1, source=SOURCE_RESPONDENT)
        processor.process_item(state, "q1", 2, source=SOURCE_RESPONDENT)

        postcondition_warnings = _warnings_of_type(state, "postcondition")
        assert len(postcondition_warnings) == 1
        assert postcondition_warnings[0]["count"] == 2
        assert postcondition_warnings[0]["last_seen"] >= postcondition_warnings[0]["first_seen"]

    def test_two_roster_iterations_produce_two_entries(self):
        """The same error under two iterations is two occurrences, not one
        repeated: each belongs to the subject it was raised for."""
        state = _state(_QML_ROSTER_MALFORMED_POSTCONDITION)
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_intro", 1, source=SOURCE_RESPONDENT)

        # One answer per declared iteration; the processor advances the
        # iteration itself once the current one is exhausted.
        for _ in range(2):
            assert processor.get_current_item(state)["id"] == "q_note"
            processor.process_item(state, "q_note", 3, source=SOURCE_RESPONDENT)

        postcondition_warnings = _warnings_of_type(state, "postcondition")
        assert len(postcondition_warnings) == 2
        assert sorted(w["iter_key"] for w in postcondition_warnings) == [1, 2]
        assert all(w["count"] == 1 for w in postcondition_warnings)
        assert all(w["block_id"] == "per_subject" for w in postcondition_warnings)


@pytest.mark.integration
@pytest.mark.flow
class TestWarningRecordShape:
    def test_every_warning_carries_the_full_record(self):
        """KTD12: one shape. Severity, block attribution, and the occurrence
        count are present on every entry, whichever site recorded it."""
        state = _state(_QML_UNDECLARED_MASK_BIT)
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_intro", 1, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)
        # An item the state has no record of — the engine had nowhere to put
        # this answer, which is a degradation in its own right.
        processor.process_item(state, "q_does_not_exist", 1, source=SOURCE_RESPONDENT)

        warnings = state.get_warnings()
        assert {w["type"] for w in warnings} == {"roster_mask_undeclared", "item_missing"}
        for warning in warnings:
            for field in REQUIRED_WARNING_FIELDS:
                assert field in warning, f"{warning['type']} is missing {field}"
            assert warning["severity"] in {"critical", "degraded", "informational"}
            assert warning["count"] >= 1

        # An item absent from state has no block to attribute the warning to;
        # the field is still written, so no consumer branches on its presence.
        missing = _warnings_of_type(state, "item_missing")[0]
        assert missing["block_id"] is None
        assert missing["severity"] == "degraded"

    def test_unknown_severity_is_refused(self):
        """Severity drives dataset exclusion, so a typo must fail loudly rather
        than quietly downgrade a corrupted survey to noise."""
        state = _state(_QML_MALFORMED_POSTCONDITION)
        with pytest.raises(ValueError, match="Unknown warning severity"):
            state.add_warning("q1", "codeblock", "boom", severity="fatal")
