"""
Integration tests for the engine's degradation-warning collection (U4).

A warning records a point where the FlowProcessor degraded instead of failing —
it kept an answer, a path, or a half-built variable state that its own rules
would have rejected. These tests cover the collection contract end to end:

- A codeBlock that raises at runtime records a `codeblock` warning at `critical`
  severity AND the flow continues past it (R15) — the failure is surfaced to the
  caller instead of being swallowed inside PythonRunner.
- No `__error__` sentinel reaches any history entry's variable state.
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
- The two condition kinds fail in OPPOSITE directions (#658): an unevaluatable
  precondition returns False (the item is skipped, `degraded`, and the survey
  stays dataset-eligible) while an unevaluatable postcondition returns True (the
  answer is accepted unchecked, `critical`) — direction and severity pinned
  together, since either axis can be flattened without the other showing.
- A capped-Group member whose gate RAISES is skipped but never evicted: a gate
  that decided nothing must not delete a collected answer, its history entry and
  its timing events, while a gate that genuinely evaluated False still does.
- A condition reading an item the respondent was SHOWN and left unanswered is
  decided only by the answers it has (#1023): a gate the missing answer could
  change skips its item (`==` and `!=` alike) or waives its postcondition at
  `degraded`, with a record, and a capped-Group member gated on it is not
  evicted; an answered part still settles an any-of or all-of gate; an item its
  own gate kept out keeps its intended None, an explicit `is None` test runs as
  written, an item's own postcondition checks the answer being given, and a part
  that raises only because an unanswered part it depends on could not
  short-circuit it stays undecided rather than becoming a `critical` failure.
- A gate reading a codeBlock VARIABLE copied from such an item is undecided the
  same way (#1044) — also through a derived variable, and when the item was
  answered through the API without being presented — unless the block handled
  the None itself; re-answering the item, or a later clean reassignment,
  clears the mark.
- "Shown" means presented on the current path (in history AND processed), not
  merely `visited`: a Roster member its gate kept out, force-visited when the
  pass completes, keeps its intended None.

These integration tests drive a real FlowProcessor over inline QML (no service
layer, no repository) and assert on the resulting QMLState, because the point
under test is what the engine WRITES about its own fallbacks — the input to
dataset exclusion and to the campaign-level degradation rollup.
"""

import pytest
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.qml_state import SOURCE_RESPONDENT, QMLState

from tests.helpers.flow_walker import walk_and_answer

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

        for entry in state["history_state"]:
            assert "__error__" not in entry["vars"]

    def test_partial_codeblock_state_is_preserved(self):
        """Assignments completed before the raise stay assigned — the engine
        continues on the partial state (which is exactly why the warning is
        `critical`), it does not roll back."""
        state = _state(_QML_RAISING_CODEBLOCK)
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q1", 1, source=SOURCE_RESPONDENT)

        downstream_context = state.tail_state()["vars"]
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


# A precondition that cannot be evaluated (undefined name). Fails CLOSED, so q2
# is SKIPPED: a gate the engine cannot check is honoured, not ignored.
_QML_MALFORMED_PRECONDITION = """
questionnaire:
  title: Malformed precondition
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
        - id: q2
          kind: Question
          title: Second
          precondition:
            - predicate: "q1.outcome == never_defined_anywhere"
              hint: Unevaluatable
          input:
            control: Radio
            labels:
              1: A
              2: B
"""


# The BRFSS shape (#658): ``q_age`` is itself gated and goes unasked, so its
# outcome stays None and the module gate evaluates ``None >= 45``, which raises.
# The three real modules were ``b_colorectal``, ``b_prostate`` and
# ``b_cognitive_decline``, all gated ``q_cdem_01.outcome >= 45``.
_QML_AGE_GATED_BLOCK = """
questionnaire:
  title: Age-gated module
  blocks:
    - id: core
      kind: Group
      items:
        - id: q_intro
          kind: Question
          title: Will you tell us your age?
          input:
            control: Radio
            labels:
              1: No
              2: Yes
        - id: q_age
          kind: Question
          title: What is your age?
          precondition:
            - predicate: "q_intro.outcome == 2"
              hint: Only when the respondent agreed
          input:
            control: Editbox
            min: 18
            max: 99
    - id: b_age_gated
      kind: Group
      precondition:
        - predicate: "q_age.outcome >= 45"
          hint: Adults 45 and over only
      items:
        - id: q_gated
          kind: Question
          title: Screening question
          input:
            control: Radio
            labels:
              1: Yes
              2: No
"""


# A capped Group whose member is gated on an item that can lose its answer.
# Answer q_age, m1 is drawn and answered; clear q_age and the gate raises, which
# routes m1 into the eviction seam (#658 follow-up).
_QML_CAPPED_GROUP_AGE_GATE = """
questionnaire:
  title: Capped group with an age-gated member
  blocks:
    - id: intro
      kind: Group
      items:
        - id: q_age
          kind: Question
          title: What is your age?
          input:
            control: Editbox
            min: 18
            max: 99
    - id: pool
      kind: Group
      count: 2
      items:
        - id: m1
          kind: Question
          title: Age-gated member
          precondition:
            - predicate: "q_age.outcome >= 45"
              hint: Adults 45 and over only
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: m2
          kind: Question
          title: Ungated member
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
"""


def _fill_then_rewind(age: object) -> QMLState:
    """Answer the capped-Group fixture (age 50, so m1 is drawn and answered),
    replace q_age's outcome with *age*, and walk back and forward again so the
    on-reach walk re-decides m1's gate."""
    state = _state(_QML_CAPPED_GROUP_AGE_GATE)
    processor = FlowProcessor(state)
    walk_and_answer(processor, state, {"q_age": 50, "m1": 1, "m2": 1})
    assert state.get_item("m1")["outcome"] == 1, "precondition: m1 was asked and answered"

    state.get_item("q_age")["outcome"] = age
    for _ in range(2):
        processor.get_current_item(state, backward=True)
    processor.get_current_item(state)
    return state


@pytest.mark.integration
@pytest.mark.flow
class TestUnevaluatableConditionSeverity:
    """#168 / #658: the two condition kinds fail in OPPOSITE directions.

    False means opposite things to the two callers, which is what decides the
    direction. A precondition that returns False skips an item — nobody is
    stranded, and honouring an uncheckable gate keeps the instrument the author
    declared. A postcondition that returns False is turned by ``process_item``
    into "you may not advance", so failing closed there traps the respondent on
    an item whose check errors on every attempt; it must fail open, and the
    answer is then kept without the check that admits it.

    Severity follows from that: skipping costs an item (``degraded``, the survey
    stays dataset-eligible), accepting unchecked costs the answer's
    admissibility (``critical``, the survey is excluded).
    """

    def test_unevaluatable_postcondition_is_critical(self):
        """The answer was accepted without the check that admits it.

        ``critical`` is the exact string ``askalot_common``'s dataset-eligibility
        probe matches on, so recording it here is what keeps the survey out of
        Bronze extraction. Recording ``degraded`` instead let data through whose
        declared validation never ran — the divergence #168 named.
        """
        state = _state(_QML_MALFORMED_POSTCONDITION)
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        result = processor.process_item(state, "q1", 1, source=SOURCE_RESPONDENT)

        # Still fails open — the answer is kept and the respondent moves on.
        assert result["success"] is True
        assert state.get_item("q1")["outcome"] == 1

        postcondition_warnings = _warnings_of_type(state, "postcondition")
        assert len(postcondition_warnings) == 1
        assert postcondition_warnings[0]["severity"] == "critical"

    def test_unevaluatable_precondition_skips_the_item_at_degraded(self):
        """The gate could not be checked, so it is honoured: q2 is not shown.

        Showing it would administer an item the instrument restricted — the
        defect #658 named. Skipping under-collects instead, which the warning
        records at ``degraded``: the survey stays dataset-eligible because
        nothing inadmissible was stored.
        """
        state = _state(_QML_MALFORMED_PRECONDITION)
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q1", 1, source=SOURCE_RESPONDENT)

        # Fails closed: q2 is skipped, so the walk ends on q1 flagged isLast —
        # the identical shape a legitimately-False gate produces, which is what
        # "honoured, not ignored" has to mean.
        end = processor.get_current_item(state)
        assert end["id"] == "q1"
        assert end["isLast"] is True
        assert state.get_item("q2").get("visited") is not True

        precondition_warnings = _warnings_of_type(state, "precondition")
        assert len(precondition_warnings) >= 1
        assert {w["severity"] for w in precondition_warnings} == {"degraded"}

    def test_age_gated_block_is_not_admitted_when_age_is_unanswered(self):
        """The BRFSS shape from #658, at its smallest.

        ``None >= 45`` raised on three age-gated modules of the demo instrument
        and every one of them was administered to every respondent, 20-year-olds
        included. The gate says 45-and-over; an engine that cannot tell must not
        answer "yes" on the instrument's behalf.
        """
        state = _state(_QML_AGE_GATED_BLOCK)
        processor = FlowProcessor(state)

        seen = []
        for _ in range(5):
            current = processor.get_current_item(state)
            if current is None:
                break
            seen.append(current["id"])
            processor.process_item(state, current["id"], 1, source=SOURCE_RESPONDENT)

        assert "q_gated" not in seen
        assert {w["severity"] for w in _warnings_of_type(state, "precondition")} == {"degraded"}

    def test_a_raised_gate_skips_a_group_member_without_evicting_its_answer(self):
        """A gate that could not be checked must not delete a collected answer.

        Capped-Group eviction exists for a gate that DECIDED against the member
        — the respondent changed an upstream answer and the instrument no longer
        wants this question — and it removes the outcome, the history entry and
        the timing events. Routing a raised gate into it turns "the engine could
        not tell" into "the respondent never answered", destroying real data on
        no evidence. Skipping is still right; deleting is not.
        """
        # A value the gate cannot order ("unknown" >= 45 raises). Not None, so
        # this stays on the RAISE path; an unanswered q_age is tested below.
        state = _fill_then_rewind("unknown")

        assert state.get_item("m1")["outcome"] == 1

    def test_a_group_member_whose_gate_decides_false_is_still_evicted(self):
        """The negative control, and the reason the fix is a distinction rather
        than a blanket "never evict".

        Eviction is correct here: the gate ran, and the instrument does not want
        this member for a 20-year-old. A stale outcome left behind would leak
        into Bronze, which is what _evict_group_item exists to prevent.
        """
        state = _fill_then_rewind(20)  # evaluable, and False

        assert state.get_item("m1").get("outcome") is None

    def test_the_two_kinds_fail_in_opposite_directions(self):
        """Direction AND severity pinned together, because either can be
        flattened without the other showing.

        Making both fail open restores #658 (every gated block admitted);
        making both fail closed strands respondents on an erroring
        postcondition. Making both ``critical`` disqualifies every survey with
        a skipped item; making both ``degraded`` restores #168. None of the
        four is visible from a single-case test.
        """
        post_state = _state(_QML_MALFORMED_POSTCONDITION)
        post_processor = FlowProcessor(post_state)
        post_processor.get_current_item(post_state)
        post_processor.process_item(post_state, "q1", 1, source=SOURCE_RESPONDENT)

        pre_state = _state(_QML_MALFORMED_PRECONDITION)
        pre_processor = FlowProcessor(pre_state)
        pre_processor.get_current_item(pre_state)
        pre_processor.process_item(pre_state, "q1", 1, source=SOURCE_RESPONDENT)
        pre_processor.get_current_item(pre_state)

        post_severities = {w["severity"] for w in _warnings_of_type(post_state, "postcondition")}
        pre_severities = {w["severity"] for w in _warnings_of_type(pre_state, "precondition")}
        assert post_severities == {"critical"}
        assert pre_severities == {"degraded"}

        # The postcondition failed OPEN: q1's answer was kept and the respondent
        # advanced. The precondition failed CLOSED: q2 was never presented —
        # asserted through navigation, because q2's outcome is None either way
        # (it is never answered in this test) and would prove nothing.
        assert post_state.get_item("q1")["outcome"] == 1
        assert pre_processor.get_current_item(pre_state)["id"] == "q1"


# #1023: an item the respondent was SHOWN and left unanswered. ``q_marital`` is
# always asked; ``q_spouse`` is gated on ``!= 3`` ("not single"), the operator
# that evaluates cleanly against None and so, run as written, admits everyone
# who skipped the question it depends on.
_QML_UNANSWERED_OPERAND = """
questionnaire:
  title: Unanswered operand
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_marital
          kind: Question
          title: Marital status
          input:
            control: Radio
            labels:
              1: Married
              2: Partnered
              3: Single
        - id: q_spouse
          kind: Question
          title: Does your spouse or partner live with you?
          precondition:
            - predicate: "q_marital.outcome != 3"
              hint: Not single
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_single
          kind: Question
          title: Have you ever been married?
          precondition:
            - predicate: "q_marital.outcome == 3"
              hint: Single
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_guarded
          kind: Question
          title: Asked when status is unknown or not single
          precondition:
            - predicate: "q_marital.outcome is None or q_marital.outcome != 3"
              hint: Unknown or not single
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
"""
_MARITAL_ANSWERS = {"q_marital": 1, "q_spouse": 1, "q_single": 1, "q_guarded": 1}

# Any-of and all-of gates over two always-asked items: the symptom-screener
# shape, where one endorsed symptom is enough to ask the follow-up.
_QML_ANY_OF = """
questionnaire:
  title: Any-of gate
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_a
          kind: Question
          title: First symptom
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_b
          kind: Question
          title: Second symptom
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_any
          kind: Question
          title: Follow-up for either symptom
          precondition:
            - predicate: "q_a.outcome == 1 or q_b.outcome == 1"
              hint: Either symptom
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_both
          kind: Question
          title: Follow-up for both symptoms
          precondition:
            - predicate: "q_a.outcome == 1 and q_b.outcome == 1"
              hint: Both symptoms
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_not_both
          kind: Question
          title: Follow-up unless both symptoms
          precondition:
            - predicate: "not (q_a.outcome == 1 and q_b.outcome == 1)"
              hint: Not both symptoms
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
"""
_SYMPTOM_ANSWERS = {"q_any": 1, "q_both": 1, "q_not_both": 1}

# The BRFSS shape from #559: ``q_pregnant`` is asked only of the respondents its
# own gate admits, and a later item reads it with ``!= 1``. For everyone the
# gate kept out, ``None != 1`` → True is the instrument's intent.
_QML_NEVER_PRESENTED_OPERAND = """
questionnaire:
  title: Never-presented operand
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_sex
          kind: Question
          title: Sex
          input:
            control: Radio
            labels:
              1: Male
              2: Female
        - id: q_pregnant
          kind: Question
          title: Are you pregnant?
          precondition:
            - predicate: "q_sex.outcome == 2"
              hint: Women only
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_alcohol
          kind: Question
          title: Alcohol use
          precondition:
            - predicate: "q_pregnant.outcome != 1"
              hint: Not pregnant
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
"""

# A postcondition that compares against an upstream answer (the time-diary
# continuity shape on the dev corpus). With ``q_end`` skipped, ``x == None`` is
# False for every x, so no answer to ``q_start`` could clear the check.
_QML_POSTCONDITION_ON_UNANSWERED = """
questionnaire:
  title: Postcondition on an unanswered item
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_end
          kind: Question
          title: When did the first episode end?
          input:
            control: Editbox
            min: 0
            max: 23
        - id: q_start
          kind: Question
          title: When did the second episode start?
          postcondition:
            - predicate: "q_start.outcome == q_end.outcome"
              hint: The second episode starts when the first ends
          input:
            control: Editbox
            min: 0
            max: 23
"""


# A part guarded by an unanswered one: ``q_c`` is asked only when ``q_a`` is 1,
# so Python would never reach ``q_c.outcome > …`` for a respondent who skipped
# ``q_a`` — it short-circuits on ``None == 1`` / ``None != 1``. The three-valued
# walk does reach it, and ``None > 3`` raising there must stay "undecided".
_QML_GUARDED_BY_UNANSWERED = """
questionnaire:
  title: Part guarded by an unanswered one
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_a
          kind: Question
          title: Do you smoke?
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_c
          kind: Question
          title: Cigarettes per day
          precondition:
            - predicate: "q_a.outcome == 1"
              hint: Smokers only
          input:
            control: Editbox
            min: 0
            max: 99
        - id: q_heavy
          kind: Question
          title: Heavy-smoker follow-up
          precondition:
            - predicate: "q_a.outcome == 1 and q_c.outcome > 20"
              hint: Heavy smokers
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_d
          kind: Question
          title: Cigarettes yesterday
          postcondition:
            - predicate: "q_a.outcome != 1 or q_d.outcome <= q_c.outcome"
              hint: No more than a usual day
          input:
            control: Editbox
            min: 0
            max: 99
"""


def _walk(qml: str, answers: dict[str, object]) -> tuple[QMLState, list[str]]:
    state = _state(qml)
    return state, walk_and_answer(FlowProcessor(state), state, answers)


def _warning_owners(state: QMLState, warning_type: str) -> set[str]:
    return {w["item_id"] for w in _warnings_of_type(state, warning_type)}


def _on_q_start(end: object) -> tuple[QMLState, FlowProcessor]:
    """Answer (or skip, with None) q_end and stop on q_start."""
    state = _state(_QML_POSTCONDITION_ON_UNANSWERED)
    processor = FlowProcessor(state)
    processor.get_current_item(state)
    processor.process_item(state, "q_end", end, source=SOURCE_RESPONDENT)
    processor.get_current_item(state)
    return state, processor


# q_a's codeBlock copies its outcome into `v` ({assign} is replaced per test);
# q_b is gated on the variable, not on q_a directly (#1044).
_QML_COPIED_VARIABLE = """
questionnaire:
  title: Copied variable
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_a
          kind: Question
          title: Building type
          codeBlock: "{assign}"
          input:
            control: Radio
            labels:
              1: House
              2: Apartment
              3: Other
        - id: q_b
          kind: Question
          title: Acreage
          precondition:
            - predicate: "v in [1, 2]"
              hint: House or apartment
          input:
            control: Radio
            labels:
              1: Small
        - id: q_end
          kind: Question
          title: End
          input:
            control: Radio
            labels:
              1: Done
"""

# As above, with q_z between them reassigning `v` from data that is not missing.
_QML_REASSIGNED_VARIABLE = _QML_COPIED_VARIABLE.replace("{assign}", "v = q_a.outcome").replace(
    """        - id: q_b
""",
    """        - id: q_z
          kind: Question
          title: Tenure
          codeBlock: "v = q_z.outcome"
          input:
            control: Radio
            labels:
              1: Owned
        - id: q_b
""",
)


def _copied(assign: str, answer: object) -> tuple[QMLState, list[str]]:
    qml = _QML_COPIED_VARIABLE.replace("{assign}", assign)
    return _walk(qml, {"q_a": answer, "q_b": 1, "q_end": 1})


# A Roster whose second member is gated off for every iteration. Completing the
# pass force-visits every member, so r_never is visited with a None outcome
# although nobody was ever asked it; q_after gates on it with `!=`.
_QML_ROSTER_MEMBER_NEVER_ASKED = """
questionnaire:
  title: Roster member never asked
  codeInit: "mask = 1"
  blocks:
    - id: per_subject
      kind: Roster
      iterateOver: "mask"
      labels:
        1: "First"
      items:
        - id: r_asked
          kind: Question
          title: Asked
          input:
            control: Radio
            labels:
              1: "Yes"
        - id: r_never
          kind: Question
          title: Never asked
          precondition:
            - predicate: "r_asked.outcome == 99"
              hint: Never
          input:
            control: Radio
            labels:
              1: "Yes"
    - id: after
      items:
        - id: q_after
          kind: Question
          title: After
          precondition:
            - predicate: "r_never.outcome != 1"
              hint: Not endorsed
          input:
            control: Radio
            labels:
              1: "Yes"
"""


_UNANSWERED = "precondition_unanswered_dependency"


@pytest.mark.integration
@pytest.mark.flow
class TestUnansweredOperandIsNotSilentlyDecided:
    """#1023: a gate reading an item the respondent was shown and left empty
    decides on the answers it has, and on nothing else.

    Two situations give an outcome of None and only one is missing data: an item
    its own gate kept out was never meant to be answered (its None is the
    instrument's intent, and gating on it is the sanctioned pattern), while an
    item that was presented and skipped is unknown. ``visited`` tells them
    apart. A part of the condition that reads an unknown item is UNKNOWN, and
    and/or combine it three-valued, so an answered part still settles the gate
    when it can. A gate that stays undecided takes the unevaluatable direction
    (a precondition skips, a postcondition waives) under its own warning type.
    """

    def test_not_equal_skips_the_gated_item_with_a_record(self):
        state, seen = _walk(_QML_UNANSWERED_OPERAND, {**_MARITAL_ANSWERS, "q_marital": None})

        assert "q_spouse" not in seen
        [warning] = [w for w in _warnings_of_type(state, _UNANSWERED) if w["item_id"] == "q_spouse"]
        assert warning["severity"] == "degraded"
        assert "q_marital" in warning["message"]

    def test_equal_skips_the_gated_item_with_a_record(self):
        state, seen = _walk(_QML_UNANSWERED_OPERAND, {**_MARITAL_ANSWERS, "q_marital": None})

        assert "q_single" not in seen
        assert "q_single" in _warning_owners(state, _UNANSWERED)

    def test_an_explicit_none_test_is_evaluated_as_written(self):
        """``is None`` is the guard the qml-preconditions skill teaches: the
        author has said what an unanswered operand means, so the gate runs."""
        state, seen = _walk(_QML_UNANSWERED_OPERAND, {**_MARITAL_ANSWERS, "q_marital": None})

        assert "q_guarded" in seen
        assert "q_guarded" not in _warning_owners(state, _UNANSWERED)

    def test_an_answered_operand_is_evaluated(self):
        state, seen = _walk(_QML_UNANSWERED_OPERAND, _MARITAL_ANSWERS)

        assert "q_spouse" in seen and "q_single" not in seen
        assert _warnings_of_type(state, _UNANSWERED) == []

    def test_an_answered_part_settles_an_any_of_gate(self):
        """One endorsed symptom is enough: the skipped one cannot change an
        ``or`` that is already True, so the follow-up is asked, unrecorded —
        while the ``and`` it cannot settle stays undecided and is recorded."""
        state, seen = _walk(_QML_ANY_OF, {**_SYMPTOM_ANSWERS, "q_a": 1, "q_b": None})

        assert "q_any" in seen
        assert "q_both" not in seen and "q_not_both" not in seen
        # `not` of an undecided part is still undecided.
        assert _warning_owners(state, _UNANSWERED) == {"q_both", "q_not_both"}

    def test_an_answered_part_settles_an_all_of_gate(self):
        """The mirror image: a denied symptom makes the ``and`` False whatever
        the skipped one says, and the ``or`` is left for the skipped one to
        decide, so it is the one recorded."""
        state, seen = _walk(_QML_ANY_OF, {**_SYMPTOM_ANSWERS, "q_a": 2, "q_b": None})

        assert "q_any" not in seen and "q_both" not in seen
        assert "q_not_both" in seen  # `not` of a decided False
        assert _warning_owners(state, _UNANSWERED) == {"q_any"}

    def test_a_never_presented_operand_keeps_its_meaning(self):
        """The BRFSS pattern (#559): a man is never asked about pregnancy, and
        ``None != 1`` admitting him to the alcohol item is the intent."""
        state, seen = _walk(_QML_NEVER_PRESENTED_OPERAND, {"q_sex": 1, "q_alcohol": 1})

        assert seen == ["q_sex", "q_alcohol"]
        assert state.get_warnings() == []

    def test_a_postcondition_on_an_unanswered_item_waives_at_degraded(self):
        """With q_end skipped no answer to q_start could clear ``x == None``,
        and the respondent could never advance. The check waives, and at
        ``degraded``: the stored row is consistent (the upstream column is
        NULL), so it stays dataset-eligible."""
        state, processor = _on_q_start(None)

        result = processor.process_item(state, "q_start", 9, source=SOURCE_RESPONDENT)

        assert result["success"] is True
        assert state.get_item("q_start")["outcome"] == 9
        [warning] = _warnings_of_type(state, "postcondition_unanswered_dependency")
        assert warning["severity"] == "degraded"
        assert _warnings_of_type(state, "postcondition") == []

    def test_a_postcondition_on_an_answered_item_blocks(self):
        state, processor = _on_q_start(8)

        result = processor.process_item(state, "q_start", 9, source=SOURCE_RESPONDENT)

        assert result["success"] is False
        assert state.get_warnings() == []

    def test_an_items_own_postcondition_checks_the_answer_being_given(self):
        """The last item stays on screen after it is submitted. A respondent
        who left it blank and then answers it is resubmitting an item that is
        visited with no outcome — and its own postcondition must check the new
        answer, not be waived as if it read somebody else's missing one."""
        state, processor = _on_q_start(8)
        processor.process_item(state, "q_start", None, source=SOURCE_RESPONDENT, skip_postcondition=True)
        assert state.get_item("q_start").get("visited") is True, "precondition: blank and on screen"

        result = processor.process_item(state, "q_start", 9, source=SOURCE_RESPONDENT)

        assert result["success"] is False
        assert _warnings_of_type(state, "postcondition_unanswered_dependency") == []

    def test_a_part_guarded_by_the_unanswered_one_is_not_unevaluatable(self):
        """``q_a.outcome == 1 and q_c.outcome > 20`` with ``q_a`` skipped: the
        ``q_c`` part raises on its never-asked None, but only because the
        three-valued walk reached a part Python would have short-circuited
        before. That is still an undecided gate — never an unevaluatable one,
        which for the postcondition would be ``critical`` and drop the survey
        from every dataset."""
        state, seen = _walk(_QML_GUARDED_BY_UNANSWERED, {"q_a": None, "q_heavy": 1, "q_d": 5})

        assert "q_c" not in seen and "q_heavy" not in seen and "q_d" in seen
        assert _warnings_of_type(state, "precondition") == []
        assert _warnings_of_type(state, "postcondition") == []
        assert _warning_owners(state, _UNANSWERED) == {"q_c", "q_heavy"}
        [waived] = _warnings_of_type(state, "postcondition_unanswered_dependency")
        assert waived["item_id"] == "q_d" and waived["severity"] == "degraded"

    def test_a_capped_group_member_gated_on_it_is_skipped_not_evicted(self):
        """Missing data decides nothing, exactly like a gate that raised: the
        member is skipped, and its collected answer is not deleted."""
        state = _fill_then_rewind(None)  # the respondent cleared their age

        assert state.get_item("m1")["outcome"] == 1
        assert "m1" in _warning_owners(state, _UNANSWERED)

    def test_a_variable_copied_from_a_skipped_item_is_unknown(self):
        """#1044: the gate reads `v`, not `q_a.outcome`, yet `v` holds the
        missing answer — the gate is undecided and recorded, exactly as the
        direct read would be."""
        state, seen = _copied("v = q_a.outcome", None)

        assert "q_b" not in seen
        assert _warning_owners(state, _UNANSWERED) == {"q_b"}

    def test_a_variable_copied_from_an_item_answered_unpresented_is_unknown(self):
        """An API submission answers an item the walk never presented; the item
        joins history only after its codeBlock's marks are computed, and it is
        still the item answered now — so its None marks `v` as a walked one does."""
        state = _state(_QML_COPIED_VARIABLE.replace("{assign}", "v = q_a.outcome"))
        processor = FlowProcessor(state)
        processor.process_item(state, "q_a", None, source=SOURCE_RESPONDENT)

        assert state.tail_state()["unknown"] == ["v"]
        assert "q_b" not in walk_and_answer(processor, state, {"q_b": 1, "q_end": 1})
        assert _warning_owners(state, _UNANSWERED) == {"q_b"}

    def test_a_variable_copied_from_an_answered_item_is_evaluated(self):
        state, seen = _copied("v = q_a.outcome", 1)

        assert "q_b" in seen
        assert _warnings_of_type(state, _UNANSWERED) == []

    def test_a_variable_whose_block_handles_none_is_not_unknown(self):
        """The mark follows the value, not the mention: a block that tests the
        outcome against None produced a real value."""
        state, seen = _copied("v = q_a.outcome if q_a.outcome is not None else 1", None)

        assert "q_b" in seen
        assert _warnings_of_type(state, _UNANSWERED) == []

    def test_the_mark_travels_through_a_derived_variable(self):
        state, seen = _copied("w = q_a.outcome; v = w", None)

        assert "q_b" not in seen
        assert _warning_owners(state, _UNANSWERED) == {"q_b"}

    def test_re_answering_clears_the_mark(self):
        """Skip q_a, go back, answer it: the mark was the skipped run's and the
        re-run replaced it, so q_b is asked with no record."""
        state = _state(_QML_COPIED_VARIABLE.replace("{assign}", "v = q_a.outcome"))
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_a", None, source=SOURCE_RESPONDENT)
        assert processor.get_current_item(state)["id"] == "q_end"
        assert state.tail_state()["unknown"] == ["v"]
        assert processor.get_current_item(state, backward=True)["id"] == "q_a"
        processor.process_item(state, "q_a", 2, source=SOURCE_RESPONDENT)

        assert processor.get_current_item(state)["id"] == "q_b"
        assert state.tail_state()["unknown"] == []

    def test_a_clean_reassignment_clears_the_mark(self):
        """A later block that assigns `v` from an answered item replaced the
        unknown value, so the gate reads it as written."""
        state, seen = _walk(_QML_REASSIGNED_VARIABLE, {"q_a": None, "q_z": 1, "q_b": 1, "q_end": 1})

        assert "q_b" in seen
        assert _warnings_of_type(state, _UNANSWERED) == []

    def test_a_taken_tainted_branch_is_not_cleared_by_its_clean_alternative(self):
        """The else branch assigns `v` cleanly, but the if branch that ran
        copied the missing answer: a static pass that walks the branches in
        sequence let the else clear the mark the if set."""
        state, seen = _copied(
            "if q_a.outcome is None:\\n    v = q_a.outcome\\nelse:\\n    v = 0", None
        )

        assert "q_b" not in seen
        assert _warning_owners(state, _UNANSWERED) == {"q_b"}

    def test_a_container_filled_from_a_skipped_item_carries_the_mark(self):
        state, seen = _copied("d = {}; d['k'] = q_a.outcome; v = d['k']", None)

        assert "q_b" not in seen
        assert _warning_owners(state, _UNANSWERED) == {"q_b"}

    def test_a_re_run_postcondition_reads_the_marks_of_the_state_it_runs_on(self):
        """q_b's own codeBlock clears `v`'s mark, so its entry's state is clean
        — but its postcondition runs on the state BEFORE it, where `v` still
        holds the missing answer. Re-answering after a Back must waive it the
        same way the first answer did, not evaluate `1 <= None`."""
        state = _state(_QML_POSTCONDITION_ON_A_MARKED_VARIABLE)
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        processor.process_item(state, "q_a", None, source=SOURCE_RESPONDENT)
        processor.get_current_item(state)
        assert processor.process_item(state, "q_b", 1, source=SOURCE_RESPONDENT)["success"]
        assert processor.get_current_item(state)["id"] == "q_end"
        assert processor.get_current_item(state, backward=True)["id"] == "q_b"

        assert processor.process_item(state, "q_b", 1, source=SOURCE_RESPONDENT)["success"]
        assert _warnings_of_type(state, "postcondition") == []
        assert _warning_owners(state, "postcondition_unanswered_dependency") == {"q_b"}

    def test_a_roster_member_nobody_was_asked_keeps_its_intended_none(self):
        """Roster completion marks every member visited, including one its gate
        kept out; being visited is not being presented. Its None is the
        instrument's intent, so `!= 1` is evaluated as written."""
        state, seen = _walk(_QML_ROSTER_MEMBER_NEVER_ASKED, {"r_asked": 1, "q_after": 1})

        assert state.get_item("r_never")["visited"] is True
        assert "q_after" in seen
        assert _warnings_of_type(state, _UNANSWERED) == []


_QML_POSTCONDITION_ON_A_MARKED_VARIABLE = """
questionnaire:
  title: Postcondition on a marked variable
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_a
          kind: Question
          title: Limit
          codeBlock: "v = q_a.outcome"
          input:
            control: Radio
            labels:
              1: One
              2: Two
        - id: q_b
          kind: Question
          title: Count
          codeBlock: "v = 5"
          postcondition:
            - predicate: "q_b.outcome <= v"
              hint: Within the limit
          input:
            control: Radio
            labels:
              1: One
        - id: q_end
          kind: Question
          title: End
          input:
            control: Radio
            labels:
              1: Done
"""
