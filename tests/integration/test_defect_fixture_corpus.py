"""Each defect fixture actually exhibits the defect its name claims.

The five `defect_*.qml` fixtures are the QML Explorer's diagram corpus: each one
is supposed to be the smallest instrument that produces one finding class, so the
harness can render every treatment. Until #762 the claim rested entirely on a
**hand-written comment at the top of each file** — nothing loaded them and
asserted anything, so a fixture whose defect was accidentally repaired (a rename,
a reindent, a schema change that made the construct legal) would go on being
described as a defect fixture while exhibiting nothing.

That is the same shape as a guard that cannot fail: the corpus reports the same
green whether it is correct or empty.

Tests:
- Every fixture named `defect_*.qml` is in the expectation table, so adding one
  without an expectation fails rather than joining silently.
- Each parseable fixture's `ValidationProcessor.to_issues()` emits its claimed
  finding type.
- The syntax-error fixture fails to PARSE, which is its defect — it has no
  finding type because it never becomes a questionnaire.
- `defect_dead_end` is order-dependent, and the committed order is the one that
  produces the finding.
- The corpus is non-empty, so a glob that stopped matching cannot read as a pass.
- The B390 edge-case corpus (`fixtures/b390/`, one smallest questionnaire per
  Z3-precision issue, its header saying what goes wrong and why): each fixture
  is declared, gets the verdict and the findings its issue says, walks the way
  the runtime does, or is refused at load (#1813); an open issue's correct
  verdict is a strict xfail, so its fix shows here (none open since #1779).
- The block counter (#1891): the publish gate accepts it with its gate verified
  item by item and refuses its impossible variant; the walk ends the block
  after the third "No".
- A variable a later-in-file item writes but the walk asks first (#1989) is read
  at the version the walk gives it, so the check reading it is not INFEASIBLE.
- A Textarea's codeBlock is lowered (#2003), so a check on what it sets passes.
- A gate on a variable computed from a blank answer is CONDITIONAL, not ALWAYS
  (#1844), and a blank first answer ends the block counter, as the walk shows.

These integration tests run the real loader and the real Z3-backed processor
against the real fixture files — a mocked processor would assert the table I
wrote rather than what the corpus contains.
"""

from __future__ import annotations

from pathlib import Path

import pytest
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.publish_gate import evaluate_publish_gate_content
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import SOURCE_SYNTHETIC, QMLState

from tests.helpers.flow_walker import walk_and_answer

FIXTURE_DIR = Path(__file__).resolve().parent.parent / "fixtures"

#: fixture stem -> the `to_issues()` type it must emit, or None when its defect
#: is that the file never parses.
#:
#: This table is the expectation that used to live in each file's comment. The
#: comments now point here, because a claim in a file nothing executes is how
#: #762 happened.
EXPECTED_FINDING: dict[str, str | None] = {
    "defect_cycle": "dependency_cycle",
    "defect_dead_end": "infeasible_postcondition",
    "defect_unreachable": "unreachable_item",
    "defect_unsupported_python": "unsafe_code",
    "defect_syntax_error": None,
}


def _fixture_stems() -> list[str]:
    return sorted(p.stem for p in FIXTURE_DIR.glob("defect_*.qml"))


def _issues_for(stem: str) -> list[dict]:
    content = (FIXTURE_DIR / f"{stem}.qml").read_text(encoding="utf-8")
    # Through the loader, not a bare yaml.safe_load: the loader unwraps the
    # `questionnaire:` root key. Handing QMLState the raw mapping yields a state
    # with no blocks and no items, which reports a clean sweep for every input —
    # a green that measures nothing.
    state = QMLState(QMLLoader(schema_path=None).load_from_string(content))
    return ValidationProcessor(state).to_issues()


@pytest.mark.integration
class TestEachDefectFixtureExhibitsItsDefect:
    def test_the_corpus_is_not_empty(self):
        """A glob that stopped matching would make every case below vacuous."""
        stems = _fixture_stems()
        assert len(stems) >= 5, stems

    def test_every_fixture_has_a_declared_expectation(self):
        """Adding a fixture without an expectation must fail, not join silently.

        The defect this file exists for is a corpus member whose claim is
        recorded nowhere executable; a new member with no entry would be exactly
        that again.
        """
        undeclared = [s for s in _fixture_stems() if s not in EXPECTED_FINDING]
        assert not undeclared, (
            f"defect fixtures with no declared expected finding: {undeclared} — "
            "add them to EXPECTED_FINDING rather than describing them in a comment"
        )

    @pytest.mark.parametrize(
        "stem", [s for s, code in EXPECTED_FINDING.items() if code is not None]
    )
    def test_the_fixture_emits_its_claimed_finding(self, stem):
        expected = EXPECTED_FINDING[stem]
        types = {issue.get("type") for issue in _issues_for(stem)}
        assert expected in types, (
            f"{stem}.qml is described as a {expected!r} fixture but emits "
            f"{sorted(t for t in types if t)} — "
            "either the fixture's defect was repaired or the finding was renamed"
        )

    def test_the_syntax_fixture_fails_to_parse(self):
        """Its defect IS the parse failure, so it has no finding type.

        Asserting a finding for it would be asserting that the file becomes a
        questionnaire, which is the opposite of what it demonstrates.
        """
        content = (FIXTURE_DIR / "defect_syntax_error.qml").read_text(encoding="utf-8")
        with pytest.raises(Exception):  # noqa: B017 - the loader's error type is not the claim
            QMLLoader(schema_path=None).load_from_string(content)

    def test_dead_end_is_order_dependent_and_the_committed_order_is_right(self):
        """The finding depends on the two items' order, which a reorder would lose.

        Recorded here rather than in a comment on the fixture: a future edit that
        reorders them should fail this test rather than silently stop
        demonstrating the defect. The assertion is the committed order producing
        the finding; the order dependence itself is what this docstring pins.
        """
        types = [issue.get("type") for issue in _issues_for("defect_dead_end")]
        assert "infeasible_postcondition" in types, types


B390_DIR = FIXTURE_DIR / "b390"

#: B390 edge-case fixture stem -> (item, condition kind, the verdict Z3 gives,
#: the exact issue types the item carries). One per issue of the Z3-precision
#: batch, each the smallest questionnaire that shows what goes wrong and why
#: (the file's header says it). An open issue's entry is the verdict it SHOULD
#: get, run as a strict xfail, so the fix that lands it fails the xfail and
#: moves the entry here.
B390_VERDICTS: dict[str, tuple[str, str, str, set[str]]] = {
    "1250-none-guard": ("r", "precondition", "ALWAYS", set()),
    "1769-skipped-not-equal": ("r", "precondition", "CONDITIONAL", set()),
    "1775-ordering-on-skipped": ("r", "precondition", "CONDITIONAL", {"none_unsafe_reference"}),
    "1779-raise-under-not": ("r", "precondition", "NEVER", {"unreachable_item"}),
    "1781-bare-matrix-read": ("r", "precondition", "CONDITIONAL", {"skipped_condition"}),
    "1782-len-rows": ("r", "precondition", "CONDITIONAL", set()),
    "1783-name-alias": ("m_0_0", "postcondition", "CONSTRAINING", set()),
    "1785-distinct-over-skippable": ("r", "precondition", "CONDITIONAL", {"skipped_condition"}),
    "1798-ssa-alias": ("z", "precondition", "CONDITIONAL", set()),
    "184-questiongroup-cell": ("r", "precondition", "NEVER", {"unreachable_item"}),
    "1784-ungated-blank": ("r", "precondition", "CONDITIONAL", set()),
    "1780-gated-matrix-cell": ("r", "precondition", "CONDITIONAL", set()),
    "1776-codeblock-reads-skipped": ("r", "postcondition", "CONSTRAINING", set()),
    "1838-own-check-before-codeblock": ("q", "postcondition", "TAUTOLOGICAL", {"tautological_postcondition"}),
    "1843-codeblock-branch": ("r", "postcondition", "CONSTRAINING", set()),
    "1847-codeblock-none-copy": ("r", "postcondition", "CONSTRAINING", set()),
    "1867-ternary-skip-into-in": ("r", "precondition", "CONDITIONAL", {"skipped_condition"}),
    "1891-block-counter": ("q_concept_4", "precondition", "CONDITIONAL", set()),
    "1891-block-counter-never": ("q_concept_1", "precondition", "NEVER", {"unreachable_item"}),
    "1989-later-writer-asked-first": ("r", "postcondition", "CONSTRAINING", set()),
    "2003-textarea-codeblock": ("r", "postcondition", "TAUTOLOGICAL", {"tautological_postcondition"}),
    "1044-tainted-variable-gate": ("r", "precondition", "CONDITIONAL", set()),
}

#: Open issues: (item, condition kind, the verdict the runtime says it should be, issue).
B390_OPEN: dict[str, tuple[str, str, str, str]] = {}

#: Fixtures the loader refuses since #1813 (QML arithmetic is whole numbers).
B390_REFUSED = ("1767-true-division", "1771-fractional-outcome", "1811-per-name-fraction")

#: Fixtures whose claim is about the walk, not a verdict: the answer to each
#: item the walk may present (None leaves it blank) -> the items shown, in order.
B390_WALKS: dict[str, tuple[dict, list[str]]] = {
    "1250-none-guard": ({"q_a": None, "r": None}, ["q_a", "r"]),
    "1769-skipped-not-equal": ({"q_a": 2, "r": None}, ["q_a", "r"]),
    "1775-ordering-on-skipped": ({"q_a": 2, "r": None}, ["q_a"]),
    "1776-codeblock-reads-skipped": ({"q_a": 2, "q_c": 1, "r": 1}, ["q_a", "q_c", "r"]),
    "1843-codeblock-branch": ({"q_a": 2, "r": 1}, ["q_a", "r"]),
    "1847-codeblock-none-copy": ({"q_a": 2, "q_c": 1, "r": 1}, ["q_a", "q_c", "r"]),
    "1782-len-rows": ({"m": [[2]], "r": None}, ["m", "r"]),
    "1780-gated-matrix-cell": ({"q_a": 2, "r": None}, ["q_a"]),
    "1784-ungated-blank": ({"q": None, "r": None}, ["q"]),
    # Three "No"s end the block: the gate is re-checked before every item (#1891).
    "1891-block-counter": (
        {"q_concept_1": 0, "q_concept_2": 0, "q_concept_3": 0, "q_why": 1},
        ["q_concept_1", "q_concept_2", "q_concept_3", "q_why"],
    ),
    # The walk asks the later-in-file writer t first; the model follows it (#1989).
    "1989-later-writer-asked-first": ({"q": 1, "t": 1, "r": 1}, ["t", "q", "r"]),
    # A Textarea's codeBlock runs, so r's check passes (#2003).
    "2003-textarea-codeblock": ({"t": "fine", "r": 1}, ["t", "r"]),
    # A blank q_a marks flag unknown, so r's gate is undecided and r is skipped (#1844).
    "1044-tainted-variable-gate": ({"q_a": None, "r": 1}, ["q_a"]),
    # The runtime truth #1779's verdict (NEVER) rests on.
    "1779-raise-under-not": ({"q_a": 1, "q_age": 5, "r": None}, ["q_a", "q_age"]),
}

#: Where each condition kind's verdict lives in a classification.
_VERDICT_KEY = {"precondition": "status", "postcondition": "invariant"}


def _b390_state(stem: str) -> QMLState:
    return QMLState(QMLLoader().load_from_string((B390_DIR / f"{stem}.qml").read_text(encoding="utf-8")))


def _verdict(processor: ValidationProcessor, item: str, kind: str) -> str:
    return processor.get_item_classifications()[item][kind][_VERDICT_KEY[kind]]


@pytest.mark.integration
class TestEachB390FixtureShowsItsEdgeCase:
    """The B390 edge-case corpus (`fixtures/b390/`): each fixture loads with the
    schema (or is refused at load, #1813), gets the verdict and the findings its
    issue says, and walks the way the runtime does; an open issue's correct
    verdict is a strict xfail."""

    def test_every_fixture_has_a_declared_expectation(self):
        declared = {*B390_VERDICTS, *B390_OPEN, *B390_REFUSED, *B390_WALKS,
                    "1768-gated-out-answer", "1801-whole-number", "186-switch-yaml-booleans"}
        stems = {p.stem for p in B390_DIR.glob("*.qml")}
        assert stems == declared, (stems - declared, declared - stems)

    @pytest.mark.parametrize("stem", sorted(B390_VERDICTS))
    def test_the_fixture_gets_its_verdict_and_findings(self, stem):
        item, kind, verdict, types = B390_VERDICTS[stem]
        processor = ValidationProcessor(_b390_state(stem))
        issues = {i["type"] for i in processor.to_issues() if i["item_id"] == item}

        assert _verdict(processor, item, kind) == verdict
        # Exact, not a subset: a construct that stops lowering keeps CONDITIONAL
        # and only gains a `skipped_condition`, which a subset would let through.
        assert issues == types, (types, issues)

    @pytest.mark.parametrize(
        "stem",
        # raises=AssertionError: only the wrong verdict is the expected failure;
        # a crash (a renamed item, a Z3 fault leaving no classification) fails.
        [pytest.param(stem, marks=pytest.mark.xfail(
            strict=True, raises=AssertionError, reason=f"open: {B390_OPEN[stem][3]}"))
         for stem in sorted(B390_OPEN)],
    )
    def test_an_open_issue_gets_the_verdict_the_runtime_says(self, stem):
        item, kind, verdict, _issue = B390_OPEN[stem]

        assert _verdict(ValidationProcessor(_b390_state(stem)), item, kind) == verdict

    @pytest.mark.parametrize("stem", B390_REFUSED)
    def test_a_fractional_construct_is_refused_at_load(self, stem):
        with pytest.raises(ValueError, match="QML arithmetic is whole numbers"):
            _b390_state(stem)

    @pytest.mark.parametrize("stem", sorted(B390_WALKS))
    def test_the_walk_shows_what_the_runtime_shows(self, stem):
        answers, shown = B390_WALKS[stem]
        state = _b390_state(stem)

        assert walk_and_answer(FlowProcessor(state), state, answers) == shown

    def test_an_answer_to_a_gated_out_item_is_refused(self):
        state = _b390_state("1768-gated-out-answer")
        processor = FlowProcessor(state)
        processor.get_current_item(state)
        # q_a must be recorded as No: unrecorded, q_b's gate refuses anyway and proves nothing.
        assert processor.process_item(state, "q_a", 2, source=SOURCE_SYNTHETIC).get("success")

        assert processor.process_item(state, "q_b", 1, source=SOURCE_SYNTHETIC).get("reason") == "precondition_not_met"

    def test_a_numeric_answer_is_a_whole_number(self):
        state = _b390_state("1801-whole-number")
        processor = FlowProcessor(state)
        processor.get_current_item(state)

        assert processor.process_item(state, "q", 3.5, source=SOURCE_SYNTHETIC).get("reason") == "answer_out_of_domain"
        assert processor.process_item(state, "q", 3, source=SOURCE_SYNTHETIC).get("success")

    def test_yaml_boolean_switch_labels_load_as_on_and_off(self):
        item = next(i for i in _b390_state("186-switch-yaml-booleans").get_all_items() if i["id"] == "s")

        assert {k: v for k, v in item["input"].items() if k != "control"} == {"on": "Agree", "off": "Disagree"}


@pytest.mark.integration
class TestBlockCounterIsPublishable:
    """The founding article's block counter (#1891, D91): an accumulator read by
    its block's precondition is read in file order, so the publish gate accepts
    it and verifies the gate item by item; its impossible variant is refused."""

    def test_the_publish_gate_accepts_the_counter(self):
        result = evaluate_publish_gate_content((B390_DIR / "1891-block-counter.qml").read_text(encoding="utf-8"))

        assert result.ok, result.errors
        assert not {i["type"] for i in result.issues} & {"dependency_cycle", "unreachable_item"}

    def test_the_publish_gate_refuses_the_impossible_counter(self):
        result = evaluate_publish_gate_content(
            (B390_DIR / "1891-block-counter-never.qml").read_text(encoding="utf-8")
        )

        assert not result.ok
        assert {i["type"] for i in result.errors} == {"unreachable_item"}

    def test_the_counter_gate_is_verified_item_by_item(self):
        classifications = ValidationProcessor(_b390_state("1891-block-counter")).get_item_classifications()
        statuses = {item: c["precondition"]["status"] for item, c in classifications.items() if item.startswith("q_")}

        # The article's items do not require an answer: a blank one marks the
        # counter unknown and the runtime skips the rest (#1044, #1844), so
        # only the first item is always asked.
        assert statuses == {
            "q_concept_1": "ALWAYS",
            "q_concept_2": "CONDITIONAL",
            "q_concept_3": "CONDITIONAL",
            "q_concept_4": "CONDITIONAL",
            "q_concept_5": "CONDITIONAL",
            "q_concept_6": "CONDITIONAL",
            "q_why": "CONDITIONAL",
        }

    def test_every_item_of_the_impossible_counter_is_never(self):
        classifications = ValidationProcessor(_b390_state("1891-block-counter-never")).get_item_classifications()
        statuses = {c["precondition"]["status"] for item, c in classifications.items() if item.startswith("q_concept")}

        assert statuses == {"NEVER"}

    def test_no_negative_answer_asks_the_whole_block_and_skips_the_follow_up(self):
        state = _b390_state("1891-block-counter")
        answers = {f"q_concept_{n}": 1 for n in range(1, 7)}

        assert walk_and_answer(FlowProcessor(state), state, answers) == list(answers)

    def test_a_blank_first_answer_ends_the_block(self):
        """The runtime truth behind q_concept_2's CONDITIONAL (#1844): a blank
        q_concept_1 marks the counter unknown, so every later gate is undecided
        and skips its item."""
        state = _b390_state("1891-block-counter")
        answers = {"q_concept_1": None, **{f"q_concept_{n}": 1 for n in range(2, 7)}, "q_why": 1}

        assert walk_and_answer(FlowProcessor(state), state, answers) == ["q_concept_1"]
        # The static verdict agrees: the walk can skip q_concept_2, so it is not ALWAYS.
        classifications = ValidationProcessor(_b390_state("1891-block-counter")).get_item_classifications()
        assert classifications["q_concept_2"]["precondition"]["status"] == "CONDITIONAL"
