"""Integration tests for ValidationProcessor.to_issues().

Covers the Z3-classification → graded-issues policy that maps each per-item
classification (and block-level coverage gap) into a structured issue with a
severity (error/warning), machine type, human message, and suggestion:

- A clean questionnaire (all TAUTOLOGICAL/NONE postconditions) yields no errors.
- An INFEASIBLE postcondition surfaces as an ``error`` issue with the documented
  message + suggestion.
- A NEVER-reachable item surfaces as an ``unreachable_item`` ``error``.
- A tautological postcondition surfaces as a ``warning``, not an ``error``.
- An undefined name in a precondition surfaces as an ``undefined_name`` ``error``
  naming the identifier, with a ``q_<name>.outcome`` suggestion when that item
  exists.
- The three U3 hygiene lints (all ``warning``): a write-only variable, a
  pass-through alias (single bare-outcome assignment) with a use-the-outcome
  suggestion, and a postcondition that merely restates its control's min/max
  (duplicate_input_bound) — while transformed derivations, consolidated
  two-producer variables, and tighter-than-bound postconditions are NOT flagged.
- A Textarea item's ``.outcome`` referenced in a precondition/postcondition or a
  codeBlock surfaces as a ``textarea_in_predicate`` ``warning`` naming the
  Textarea item and the referencing location; an unreferenced Textarea is silent.
- Three Demo-instrument authoring warnings (#559): a codeBlock statement that
  assigns something to itself, a postcondition admitting exactly one answer of
  a choice control, and a Checkbox "none of the above" option that can be
  ticked beside the others — each beside the shapes it must leave alone.
- A Checkbox's Z3 domain is a bitmask (#1140): a gate on a combination of
  ticked keys, or on nothing ticked, is reachable; one on an undeclared bit or
  above the sum of the keys is not.
- Postcondition coverage statistics count relational vs local postconditions and
  surface them in ``get_statistics()`` and the validation report text.
- Issue dicts carry exactly the five contract keys (item_id, severity, type,
  message, suggestion).
- Validation hierarchy Levels 2–4 (#164): a globally-UNSAT questionnaire (no
  valid completion — every respondent trapped) surfaces as a ``global_unsat``
  error; a dependency cycle surfaces as a ``dependency_cycle`` error; and, under
  ``deep=True`` (the publish-gate path), an accumulated-dead-code item surfaces
  as an ``accumulated_dead_code`` warning while the default fast path omits the
  O(items²) pass.
- Uninitialized-read lint (#1024): a variable read where a respondent can
  arrive with no earlier assignment having run — read before its only
  assignment, assigned on one branch, or assigned by an item its own gate can
  skip — is a ``warning`` whose message names the runtime consequence per read
  site, and a block-level condition is reported once against the block; a read
  gated like its assignment, an earlier unconditional, both-branch or
  complementary-branch assignment, a same-block read after assignment, a
  codeInit default and a comprehension local are not.
- Sandbox-admissibility lint (#729): a `codeBlock`, `codeInit` or predicate the
  Python sandbox will refuse surfaces as an ``unsafe_code`` **error** before
  fielding, carrying the runner's own message; the undefined-name lint wins
  where the two overlap on a disallowed call; and a corpus sweep asserts no
  other committed fixture is refused, because the publish gate blocks on any
  error and a false positive would make a live questionnaire unpublishable.
- Frozen-variable lint (#169): a variable initialized in codeInit, never
  reassigned, but read by a gate surfaces as a ``frozen_variable`` error naming
  the root cause and the affected gates — symmetrically for the always-false
  polarity (which also yields the downstream ``unreachable_item`` errors) and the
  always-true polarity (which otherwise produced zero diagnostics).
- VACUOUS-before-TAUTOLOGICAL (#169): a NEVER-reachable item's postcondition is
  reported only as ``unreachable_item``, never mislabeled ``tautological_``/
  ``vacuous_postcondition`` — the classifier's TAUTOLOGICAL label there is an
  artifact of unreachability.
- Name-collision scoping: a comprehension / generator / lambda local in one unit
  does not leak, so it must not suppress an undefined_name, frozen-gate
  unreachable_item, or write_only finding for a same-named variable in an
  unrelated unit (the file-wide-union suppression class).
- Census non-Name producers: a variable produced via tuple-unpack / for / walrus
  / with-as is seen by the read/write census — so a legitimate second producer is
  not a pass-through alias, and a non-Name-only unread producer is still write-only.
- Reserved sentinel item ids: item ids ``__init__`` and ``codeInit`` collide with
  internal sentinels and are rejected by the loader.
- None-unsafe reference lint (#659): a condition that ORDERS on an item not asked
  on every path reaching it surfaces as a ``none_unsafe_reference`` ``warning``,
  while equality against the same item, an explicit ``is not None`` guard, and
  ordering against an ALWAYS-reachable item are all silent. The suggested guard
  points the way the RUNTIME fails (``is not None and`` for a precondition,
  ``is None or`` for a postcondition), and one block-level condition yields one
  finding against the block rather than one per member item.
- Questionnaire-level condition lint (#559): a root-level ``precondition`` or
  ``postcondition`` key surfaces as a ``questionnaire_level_condition``
  ``warning`` (one per key), and a questionnaire with neither is silent.
- Hygiene owner fallback: a codeInit-only hygiene finding carries the ``"codeInit"``
  owner label, never ``item_id=None``.
- Publish gate (``evaluate_publish_gate_content``): the soundness gate every
  publish door — passes clean and warning-only files, blocks on error-severity
  issues, and fails closed (file_not_found / load_error) when the file cannot
  be loaded or analyzed at all.
- Merge gate (``merge_qml`` / ``evaluate_merge_gate``, plan 2026-07-21-001 U3):
  the same gate applied to a 3-way merge result — a textually clean merge that
  breaks the skip graph is downgraded to a conflict and never promoted, a valid
  merge stamps the per-version validation verdict, a textual conflict never
  reaches Z3, and a fast-forward / no-op deliberately skips the gate (R16).

These integration tests run the real Z3 classification pipeline against the
thesis/matrix fixtures, so they exercise the actual classification shapes the
mapping consumes (not hand-built dicts) and lock the MCP issue contract.
"""

import copy
import functools
from pathlib import Path
from types import SimpleNamespace
from typing import Any
from unittest.mock import patch

import pytest
import yaml
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import (
    ValidationProcessor,
    _admitted_outcomes,
    _none_unsafe_item_references,
)
from askalot_qml.models.qml_state import QMLState

FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def _dump_yaml(raw: dict[str, Any]) -> str:
    """Serialize a raw questionnaire dict to YAML for QMLLoader.load_from_string.

    Used by the reserved-item-id tests, which must exercise the loader's
    validation path (where the reserved-id guard lives) rather than constructing
    a QMLState directly.
    """
    return yaml.safe_dump(raw, sort_keys=False)

# Fixtures spanning clean, error, and warning classifications. Each is loaded
# without schema validation (schema_path=None) to match the validation-hierarchy
# suite and keep the focus on the classification → issues mapping.
FIXTURE_SUITE = [
    "basic.qml",
    "classification.qml",
    "scoring.qml",
    "thesis_driving_experience.qml",
    "thesis_conflicting_postconditions.qml",
    "thesis_dead_code_simple.qml",
    "thesis_dead_code_income.qml",
    "matrix_infeasible_sum.qml",
    "matrix_fixed_sum.qml",
    "question_group.qml",
]


def _processor(filename: str) -> ValidationProcessor:
    """Load a QML fixture and build a ValidationProcessor for it."""
    loader = QMLLoader(schema_path=None)
    data = loader.load_from_path(str(FIXTURES_DIR / filename))
    return ValidationProcessor(QMLState(data))


@pytest.mark.integration
class TestToIssuesScenarios:
    """Targeted scenarios for the severity-and-message policy."""

    def test_clean_questionnaire_has_no_errors(self):
        """basic.qml has no postconditions → no error-severity issues."""
        issues = _processor("basic.qml").to_issues()
        errors = [i for i in issues if i["severity"] == "error"]
        assert errors == [], f"clean questionnaire produced errors: {errors}"

    def test_infeasible_postcondition_is_error(self):
        """An infeasible postcondition surfaces as an error with documented text."""
        issues = _processor("matrix_infeasible_sum.qml").to_issues()
        infeasible = [i for i in issues if i["type"] == "infeasible_postcondition"]
        assert infeasible, "expected an infeasible_postcondition issue"
        for issue in infeasible:
            assert issue["severity"] == "error"
            assert "infeasible postcondition" in issue["message"]
            assert issue["suggestion"]

    def test_unreachable_item_is_error(self):
        """A NEVER-reachable item surfaces as an unreachable_item error."""
        # thesis_dead_code_simple has a CONDITIONAL-but-dead item; classification.qml
        # is the dedicated NEVER fixture. Search both; at least one must produce it.
        produced = []
        for fixture in ("classification.qml", "thesis_dead_code_simple.qml"):
            produced += [
                i for i in _processor(fixture).to_issues() if i["type"] == "unreachable_item"
            ]
        if not produced:
            pytest.skip("no NEVER-reachable item in the available fixtures")
        for issue in produced:
            assert issue["severity"] == "error"
            assert "unreachable" in issue["message"]

    def test_tautological_postcondition_is_warning_not_error(self):
        """A tautological postcondition is a warning, never an error."""
        produced = []
        for fixture in FIXTURE_SUITE:
            produced += [
                i
                for i in _processor(fixture).to_issues()
                if i["type"] == "tautological_postcondition"
            ]
        if not produced:
            pytest.skip("no tautological postcondition in the available fixtures")
        for issue in produced:
            assert issue["severity"] == "warning"

    def test_issue_dicts_carry_exact_contract_keys(self):
        """Every issue dict has exactly the five MCP-contract keys."""
        expected_keys = {"item_id", "severity", "type", "message", "suggestion"}
        for fixture in FIXTURE_SUITE:
            for issue in _processor(fixture).to_issues():
                assert set(issue.keys()) == expected_keys, (
                    f"{fixture}: issue keys {set(issue.keys())} != {expected_keys}"
                )
                assert issue["severity"] in ("error", "warning")


@pytest.mark.integration
class TestUndefinedNameLint:
    """U1: undefined identifiers in predicates surface as undefined_name errors."""

    def test_phantom_precondition_name_is_single_error_with_suggestion(self):
        """lint_undefined_name.qml: bare `smoking_status` where `q_smoking_status`
        exists → exactly one undefined_name error naming the identifier, with a
        suggestion pointing at `q_smoking_status.outcome`, on the gated item."""
        issues = _processor("lint_undefined_name.qml").to_issues()

        undefined = [i for i in issues if i["type"] == "undefined_name"]
        assert len(undefined) == 1, f"expected exactly one undefined_name issue, got {undefined}"

        issue = undefined[0]
        assert issue["severity"] == "error"
        assert issue["item_id"] == "q_cigarettes_per_day"
        assert "smoking_status" in issue["message"]
        assert "precondition" in issue["message"]
        assert "q_smoking_status.outcome" in issue["suggestion"]

    def test_phantom_name_is_the_only_error(self):
        """The fixture is otherwise clean: the undefined_name error is the only
        error-severity issue (no spurious unreachable/infeasible classifications)."""
        issues = _processor("lint_undefined_name.qml").to_issues()
        errors = [i for i in issues if i["severity"] == "error"]
        assert len(errors) == 1, f"expected only the undefined_name error, got {errors}"
        assert errors[0]["type"] == "undefined_name"

    def test_undefined_name_issue_carries_contract_keys(self):
        """The undefined_name issue matches the five-key MCP contract."""
        expected_keys = {"item_id", "severity", "type", "message", "suggestion"}
        for issue in _processor("lint_undefined_name.qml").to_issues():
            assert set(issue.keys()) == expected_keys

    def test_yaml_boolean_literal_gets_a_targeted_suggestion(self):
        """#201: `== false` in a predicate is an undefined name, not a boolean.

        The generic suggestion ("reference an item's outcome, or add a codeBlock
        that produces it") is unactionable here — nobody intended a variable
        named `false`. Two live dev campaigns fielded exactly this shape, and
        the AI designer keeps reproducing the YAML spelling, so the fix has to
        be named."""
        issues = _processor("lint_yaml_boolean_predicate.qml").to_issues()
        undefined = {
            i["item_id"]: i for i in issues if i["type"] == "undefined_name"
        }

        assert set(undefined) == {"q_pillar1_full", "q_pillar1_simplified"}

        false_issue = undefined["q_pillar1_full"]
        assert false_issue["severity"] == "error"
        assert "'False'" in false_issue["suggestion"]
        assert "Python expressions" in false_issue["suggestion"]
        # The unactionable generic advice must NOT be what the author reads.
        assert "add a codeBlock" not in false_issue["suggestion"]

        true_issue = undefined["q_pillar1_simplified"]
        assert "'True'" in true_issue["suggestion"]

    def test_targeted_suggestion_does_not_displace_a_real_outcome_match(self):
        """A phantom that DOES resolve to an existing `q_<name>` still gets the
        outcome suggestion — the literal table is a fallback, not an override."""
        issues = _processor("lint_undefined_name.qml").to_issues()
        undefined = [i for i in issues if i["type"] == "undefined_name"]
        assert "q_smoking_status.outcome" in undefined[0]["suggestion"]

    def test_block_level_precondition_phantom_is_attributed_to_block(self):
        """A phantom in a block-level precondition (kept on the block per R25)
        surfaces via the synthetic block-keyed classification entry as an
        undefined_name error attributed to the block id."""
        state = QMLState(
            {
                "title": "block-phantom",
                "blocks": [
                    {
                        "id": "emp",
                        "kind": "Group",
                        "title": "Employment",
                        "precondition": [{"predicate": "employment_status == 1"}],
                    }
                ],
                "items": [
                    {
                        "id": "q_emp",
                        "blockId": "emp",
                        "kind": "Question",
                        "title": "Employed?",
                        "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                    }
                ],
            }
        )
        undefined = [i for i in ValidationProcessor(state).to_issues() if i["type"] == "undefined_name"]
        assert len(undefined) == 1, f"expected one block-level undefined_name issue, got {undefined}"
        issue = undefined[0]
        assert issue["item_id"] == "emp"
        assert issue["severity"] == "error"
        assert "employment_status" in issue["message"]


@pytest.mark.integration
class TestNoneUnsafeReferenceLint:
    """#659: ordering against an item that may never have been asked.

    An unasked item's outcome is None. Equality survives that; ordering and
    arithmetic raise, and the runtime then skips the gated item or accepts the
    answer unchecked. The lint's whole value is telling those two apart, so
    every test here pairs a flagged shape with the safe shape it resembles.
    """

    def _findings(self) -> list[dict[str, Any]]:
        return [
            i
            for i in _processor("lint_none_unsafe_reference.qml").to_issues()
            if i["type"] == "none_unsafe_reference"
        ]

    def test_ordering_on_a_conditional_item_is_flagged(self):
        """Both the postcondition and the precondition shape, at warning severity."""
        findings = self._findings()
        assert {i["item_id"] for i in findings} == {"q_age", "q_gated"}
        assert {i["severity"] for i in findings} == {"warning"}

    def test_message_names_both_items_and_the_suggestion_offers_the_guard(self):
        """The author needs to know WHICH reference is unsafe, not just that one is."""
        finding = next(i for i in self._findings() if i["item_id"] == "q_age")
        assert "q_dx_age.outcome" in finding["message"]
        assert "not asked on every path" in finding["message"]
        assert "q_dx_age.outcome is None or" in finding["suggestion"]

    def test_none_safe_shapes_are_silent(self):
        """The three ways to reference a conditional item correctly.

        Equality (``!= 1``), an explicit ``is not None`` guard, and ordering
        against an item Z3 proves ALWAYS-reachable. Asserted as absences from
        the same fixture as the positives, so a lint that fired on everything
        could not pass the class.
        """
        flagged = {i["item_id"] for i in self._findings()}
        assert "q_equality" not in flagged
        assert "q_guarded" not in flagged
        assert "q_always" not in flagged

    def test_the_suggested_guard_does_not_re_trip_the_lint(self):
        """A remedy that reproduces the finding is not a remedy.

        The suggestion wraps the predicate in ``Y.outcome is None or …``, which
        leaves the ordering comparison in the AST — so the lint has to read the
        None test as the author's acknowledgement rather than count operators.
        """
        assert _none_unsafe_item_references(
            "q_dx_age.outcome is None or q_age.outcome >= q_dx_age.outcome"
        ) == {"q_age"}

    def test_chained_comparison_reports_only_the_ordering_half(self):
        """``a == b < c`` raises on b and c, never on a."""
        assert _none_unsafe_item_references("q_a.outcome == q_b.outcome < q_c.outcome") == {
            "q_b",
            "q_c",
        }

    def test_arithmetic_operands_count_as_unsafe(self):
        """``None + 1`` raises exactly as ``None > 1`` does."""
        assert _none_unsafe_item_references("q_a.outcome + q_b.outcome > 3") == {"q_a", "q_b"}

    def test_an_unparseable_predicate_yields_nothing(self):
        """The syntax error is another lint's finding; guessing at a broken AST
        would stack noise on top of it. Matches ``_scan_predicate``'s stance in
        ``static_builder``."""
        assert _none_unsafe_item_references("q_a.outcome >=") == set()

    def test_the_guard_points_the_way_the_runtime_fails(self):
        """A precondition guard must EXCLUDE the unasked case; a postcondition
        guard must ADMIT it.

        The two runtime directions are opposite (see
        ``_UNEVALUATABLE_CONDITION_POLICY``), so one guard form cannot serve
        both. Emitting the postcondition form for a precondition writes #658
        back into the remedy: ``Y.outcome is None or <gate>`` is TRUE for
        exactly the respondents the gate excludes, so the module is
        administered to all of them.
        """
        findings = {i["item_id"]: i["suggestion"] for i in self._findings()}
        assert "is not None and (q_dx_age.outcome >= 40)" in findings["q_gated"]
        assert "is None or (q_age.outcome >= q_dx_age.outcome)" in findings["q_age"]

    def test_the_guard_is_parenthesised(self):
        """``and`` binds tighter than ``or``, so an unparenthesised precondition
        guard lets the unguarded branch through.

        ``A is not None and X or Y`` parses as ``(A is not None and X) or Y``,
        which is True whenever Y is — the guard is bypassed entirely.
        """
        suggestion = {i["item_id"]: i["suggestion"] for i in self._findings()}["q_gated"]
        guard = suggestion.split("'")[1]
        assert eval(guard.replace("q_dx_age.outcome", "None"), {}, {}) is False

    def test_one_block_level_condition_yields_one_finding(self):
        """A block condition is composed onto every member, so the naive loop
        reports it once per member — N problems that are one line in one block,
        each keyed to an item that declares nothing."""
        issues = [
            i
            for i in _processor("lint_none_unsafe_block_gate.qml").to_issues()
            if i["type"] == "none_unsafe_reference"
        ]
        assert len(issues) == 1
        assert issues[0]["item_id"] == "b_gated"
        assert "block 'b_gated'" in issues[0]["message"]


def _item(item_id: str, extra: str = "") -> str:
    """One Radio item for the inline #1024 questionnaires; *extra* is YAML
    at the item's key indentation (precondition / codeBlock)."""
    return (
        f"        - id: {item_id}\n          kind: Question\n          title: {item_id}\n"
        f"{extra}          input:\n            control: Radio\n"
        f"            labels:\n              2: Low\n              9: High\n"
    )


def _gate(predicate: str) -> str:
    return f'          precondition:\n            - predicate: "{predicate}"\n              hint: h\n'


def _code(line: str) -> str:
    return "          codeBlock: |\n" + "".join(f"            {x}\n" for x in line.split("\n"))


def _uninitialized_read_issues(*items: str, init: str = "", blocks: str = "") -> list[dict]:
    """Every ``uninitialized_read`` issue the questionnaire yields. *items* go in
    one ``main`` block; *blocks* is extra block YAML appended after it."""
    qml = (
        "questionnaire:\n  title: t\n"
        + (f'  codeInit: "{init}"\n' if init else "")
        + "  blocks:\n    - id: main\n      items:\n"
        + "".join(items)
        + blocks
    )
    processor = ValidationProcessor(QMLState(QMLLoader(schema_path=None).load_from_string(qml)))
    return [i for i in processor.to_issues() if i["type"] == "uninitialized_read"]


def _uninitialized_reads(*items: str, init: str = "") -> set[tuple[str, str]]:
    """(reader, variable) for every ``uninitialized_read`` the questionnaire yields."""
    return {
        (i["item_id"], i["message"].split("variable '")[1].split("'")[0])
        for i in _uninitialized_read_issues(*items, init=init)
    }


@pytest.mark.integration
class TestUninitializedVariableRead:
    """#1024: a variable read where no assignment is guaranteed to have run.

    ``undefined_name`` knows only whether a name is bound ANYWHERE; this lint
    asks, per read, whether a respondent can reach it with no earlier assigner
    having run — path-sensitively, so a read gated like its assignment stays
    silent. Every flagged shape is paired with the safe one it resembles.
    """

    def test_a_read_before_its_only_assignment_is_flagged(self):
        found = _uninitialized_reads(
            _item("q_b", _gate("threshold > 10")), _item("q_z", _code("threshold = 20"))
        )
        assert found == {("q_b", "threshold")}

    def test_a_one_branch_assignment_is_flagged(self):
        found = _uninitialized_reads(
            _item("q_b", _code("if q_b.outcome > 5:\n    risk = 1")),
            _item("q_c", _gate("risk == 1")),
        )
        assert found == {("q_c", "risk")}

    def test_an_assigner_its_own_gate_can_skip_is_flagged(self):
        found = _uninitialized_reads(
            _item("q_a"),
            _item("q_z", _gate("q_a.outcome == 2") + _code("threshold = 20")),
            _item("q_b", _gate("threshold > 10")),
        )
        assert found == {("q_b", "threshold")}

    def test_a_read_gated_like_its_assignment_is_not_flagged(self):
        found = _uninitialized_reads(
            _item("q_b", _code("if q_b.outcome > 5:\n    risk = 1")),
            _item("q_c", _gate("q_b.outcome > 5 and risk == 1")),
        )
        assert found == set()

    def test_an_earlier_unconditional_assignment_is_not_flagged(self):
        found = _uninitialized_reads(
            _item("q_b", _code("risk = 1")), _item("q_c", _gate("risk == 1"))
        )
        assert found == set()

    def test_a_read_after_its_own_assignment_in_one_block_is_not_flagged(self):
        found = _uninitialized_reads(
            _item("q_b", _code("t = 1\nu = t + 1")), _item("q_c", _gate("u == 2"))
        )
        assert found == set()

    def test_both_branches_assigning_is_not_flagged(self):
        found = _uninitialized_reads(
            _item("q_b", _code("if q_b.outcome > 5:\n    risk = 1\nelse:\n    risk = 0")),
            _item("q_c", _gate("risk == 1")),
        )
        assert found == set()

    def test_a_codeinit_default_exempts_the_variable(self):
        found = _uninitialized_reads(
            _item("q_b", _code("if q_b.outcome > 5:\n    risk = 1")),
            _item("q_c", _gate("risk == 1")),
            init="risk = 0",
        )
        assert found == set()

    def test_a_reader_gate_z3_cannot_express_is_not_judged(self):
        """A reader gate the solver drops would read as True and flag a read the
        gate protects; the lint says nothing rather than something false."""
        found = _uninitialized_reads(
            _item("q_b", _code("if q_b.outcome > 5:\n    risk = 1")),
            _item("q_c", _gate("str(q_b.outcome) == '9' and risk == 1")),
        )
        assert found == set()

    def test_a_comprehension_local_is_not_a_read(self):
        found = _uninitialized_reads(
            _item("q_b", _code("x = 1")),
            _item("q_c", _gate("any(x > 1 for x in [q_b.outcome])")),
            _item("q_z", _code("x = 2")),
        )
        assert found == set()

    def test_complementary_one_branch_assignments_are_not_flagged(self):
        found = _uninitialized_reads(
            _item(
                "q_b",
                _code("if q_b.outcome > 5:\n    risk = 1\nif q_b.outcome <= 5:\n    risk = 0"),
            ),
            _item("q_c", _gate("risk == 1")),
        )
        assert found == set()

    def test_a_loop_beside_a_one_branch_assignment_counts_as_assigning(self):
        found = _uninitialized_reads(
            _item("q_b", _code("if q_b.outcome > 5:\n    risk = 1\nfor k in [1]:\n    risk = k")),
            _item("q_c", _gate("risk == 1")),
        )
        assert found == set()

    def test_a_block_condition_is_reported_once_against_the_block(self):
        issues = _uninitialized_read_issues(
            _item("q_b", _code("if q_b.outcome > 5:\n    risk = 1")),
            blocks=(
                "    - id: gated\n      precondition:\n"
                '        - predicate: "risk == 1"\n          hint: h\n      items:\n'
                + _item("q_c")
                + _item("q_d")
                + _item("q_e")
            ),
        )
        assert [i["item_id"] for i in issues] == ["gated"]
        assert "block 'gated'" in issues[0]["message"]

    def test_the_message_names_what_the_runtime_does_at_each_site(self):
        pre, post = (
            _uninitialized_read_issues(
                _item("q_b", _gate("threshold > 10")), _item("q_z", _code("threshold = 20"))
            )[0],
            _uninitialized_read_issues(
                _item(
                    "q_b",
                    '          postcondition:\n            - predicate: "x > 0"\n'
                    "              hint: h\n" + _code("x = 1"),
                )
            )[0],
        )
        assert "skipped (recorded degraded)" in pre["message"]
        assert "accepted unchecked (recorded critical" in post["message"]
        assert "its own codeBlock" in post["message"]

    def test_the_finding_is_a_warning(self):
        finding = _uninitialized_read_issues(
            _item("q_b", _gate("threshold > 10")), _item("q_z", _code("threshold = 20"))
        )[0]
        assert finding["severity"] == "warning"
        assert "codeInit" in finding["suggestion"]


@pytest.mark.integration
class TestQuestionnaireLevelConditionLint:
    """#559: a root-level condition key that nothing evaluates.

    Conditions are composed from the block and the item only. The schema
    advertised two root-level keys no layer ever read, so an author who wrote
    one got a gate that silently enforced nothing. The keys are gone from the
    schema at 2.4.1; this lint exists because the schema does not reject
    unknown keys, so removal alone would leave the same silence.
    """

    def _issues(self, raw: dict) -> list[dict[str, Any]]:
        loader = QMLLoader(schema_path=None)
        state = QMLState(loader.load_from_string(_dump_yaml(raw)))
        return [
            i for i in ValidationProcessor(state).to_issues()
            if i["type"] == "questionnaire_level_condition"
        ]

    def _questionnaire(self, **root) -> dict:
        return {
            "questionnaire": {
                "title": "Root-level gate",
                **root,
                "blocks": [
                    {
                        "id": "main",
                        "kind": "Group",
                        "items": [
                            {
                                "id": "q1",
                                "kind": "Question",
                                "title": "First",
                                "input": {"control": "Radio", "labels": {1: "A", 2: "B"}},
                            }
                        ],
                    }
                ],
            }
        }

    def test_a_root_level_precondition_is_flagged(self):
        issues = self._issues(
            self._questionnaire(precondition=[{"predicate": "1 == 1", "hint": "never runs"}])
        )
        assert len(issues) == 1
        assert issues[0]["severity"] == "warning"
        assert "precondition" in issues[0]["message"]
        assert "never runs" in issues[0]["message"]

    def test_a_root_level_postcondition_is_flagged(self):
        issues = self._issues(
            self._questionnaire(postcondition=[{"predicate": "1 == 1", "hint": "never runs"}])
        )
        assert len(issues) == 1
        assert "postcondition" in issues[0]["message"]

    def test_both_keys_yield_one_finding_each(self):
        """Two dead keys are two defects, not one — each needs its own move."""
        issues = self._issues(
            self._questionnaire(
                precondition=[{"predicate": "1 == 1", "hint": "a"}],
                postcondition=[{"predicate": "2 == 2", "hint": "b"}],
            )
        )
        assert len(issues) == 2

    def test_a_questionnaire_with_neither_key_is_silent(self):
        """The negative control: a lint that fired on every questionnaire would
        pass all three tests above."""
        assert self._issues(self._questionnaire()) == []

    def test_block_level_conditions_are_not_flagged(self):
        """Block-level conditions ARE evaluated (composed before each item's
        own), so flagging them would be exactly backwards."""
        raw = self._questionnaire()
        raw["questionnaire"]["blocks"][0]["precondition"] = [
            {"predicate": "1 == 1", "hint": "this one really runs"}
        ]
        assert self._issues(raw) == []


@pytest.mark.integration
class TestHygieneLints:
    """U3: write-only, pass-through-alias, and duplicate-input-bound WARNs.

    All three come from ``lint_hygiene.qml`` (a single fixture exercising every
    positive and negative case), plus one inline state for the tighter-bound
    negative that would otherwise inflate the fixture's local-postcondition count.
    """

    def test_pass_through_alias_warns_with_outcome_suggestion(self):
        """AE5: `num_children = q_a1_num_children.outcome`, read once → one
        pass_through_alias warning suggesting the direct outcome reference."""
        issues = _processor("lint_hygiene.qml").to_issues()
        alias = [i for i in issues if i["type"] == "pass_through_alias"]
        assert len(alias) == 1, f"expected exactly one alias warning, got {alias}"
        issue = alias[0]
        assert issue["severity"] == "warning"
        assert "num_children" in issue["message"]
        assert "q_a1_num_children.outcome" in issue["suggestion"]

    def test_transformed_derivation_is_not_an_alias(self):
        """`months = q_age.outcome * 12` transforms the outcome → not an alias."""
        alias = [
            i for i in _processor("lint_hygiene.qml").to_issues()
            if i["type"] == "pass_through_alias"
        ]
        assert all("months" not in i["message"] for i in alias)

    def test_two_producers_are_not_an_alias(self):
        """`status` has two mutually exclusive producers → consolidation, not an
        alias (exempt)."""
        alias = [
            i for i in _processor("lint_hygiene.qml").to_issues()
            if i["type"] == "pass_through_alias"
        ]
        assert all("status" not in i["message"] for i in alias)

    def test_write_only_variable_warns(self):
        """`path` is assigned in two codeBlocks and never read → write_only WARN."""
        issues = _processor("lint_hygiene.qml").to_issues()
        write_only = [i for i in issues if i["type"] == "write_only_variable"]
        assert len(write_only) == 1, f"expected one write_only warning, got {write_only}"
        assert write_only[0]["severity"] == "warning"
        assert "path" in write_only[0]["message"]

    def test_read_variables_are_not_write_only(self):
        """num_children / months / status are read somewhere → not write-only."""
        write_only = [
            i for i in _processor("lint_hygiene.qml").to_issues()
            if i["type"] == "write_only_variable"
        ]
        for name in ("num_children", "months", "status"):
            assert all(name not in i["message"] for i in write_only)

    def test_duplicate_input_bound_warns(self):
        """q_pct's postcondition restates the Slider's exact min/max → WARN."""
        issues = _processor("lint_hygiene.qml").to_issues()
        dup = [i for i in issues if i["type"] == "duplicate_input_bound"]
        assert len(dup) == 1, f"expected one duplicate_input_bound warning, got {dup}"
        assert dup[0]["severity"] == "warning"
        assert dup[0]["item_id"] == "q_pct"

    def test_relational_postcondition_is_not_duplicate_bound(self):
        """A postcondition referencing another item (q_falls <= q_total_falls) is
        never flagged duplicate_input_bound even though a bound is involved."""
        dup = [
            i for i in _processor("lint_hygiene.qml").to_issues()
            if i["type"] == "duplicate_input_bound"
        ]
        assert all(i["item_id"] != "q_falls" for i in dup)

    def test_tighter_bound_local_postcondition_not_flagged(self):
        """A local postcondition tighter than the control min (`own.outcome >= 1`
        over a min=0 control) restates nothing exactly → not duplicate_input_bound.

        Kept inline rather than in lint_hygiene.qml: embedding a second local
        postcondition there would make its local-postcondition count 2 and break
        the `relational: 2, local: 1` coverage assertion.
        """
        state = QMLState(
            {
                "title": "tighter-bound",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_score",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "Score",
                        "input": {"control": "Slider", "min": 0, "max": 100},
                        "postcondition": [{"predicate": "q_score.outcome >= 1"}],
                    }
                ],
            }
        )
        dup = [i for i in ValidationProcessor(state).to_issues() if i["type"] == "duplicate_input_bound"]
        assert dup == [], f"a tighter bound must not be flagged, got {dup}"

    def test_hygiene_only_file_has_no_errors(self):
        """Scenario 7: every hygiene finding is a warning, so a file with only
        hygiene issues yields no error-severity issue (stays is_valid=True through
        Portor's error-only gate)."""
        errors = [i for i in _processor("lint_hygiene.qml").to_issues() if i["severity"] == "error"]
        assert errors == [], f"hygiene fixture produced errors: {errors}"

    def test_hygiene_issues_carry_contract_keys(self):
        """Every issue (including the three new warning types) has exactly the
        five MCP-contract keys."""
        expected_keys = {"item_id", "severity", "type", "message", "suggestion"}
        for issue in _processor("lint_hygiene.qml").to_issues():
            assert set(issue.keys()) == expected_keys


@pytest.mark.integration
class TestPostconditionCoverageStatistics:
    """U3/R12: relational vs local postcondition counts in stats + report."""

    def test_relational_and_local_counts(self):
        """lint_hygiene.qml has 2 relational (q_falls → item, q_diag_age → var)
        and 1 local (q_pct) item-level postconditions."""
        stats = _processor("lint_hygiene.qml").get_statistics()
        assert stats["relational_postconditions"] == 2
        assert stats["local_postconditions"] == 1

    def test_report_includes_coverage_counts(self):
        """The validation report text carries the coverage counts."""
        report = _processor("lint_hygiene.qml").generate_validation_report()
        assert "Relational: 2" in report
        assert "Local: 1" in report


@pytest.mark.integration
class TestAuthoringLints:
    """#532: a Comment titled as a request, and a Roster subject that cannot answer.

    Both come from ``lint_comment_title.qml``, a single fixture carrying every
    positive and negative case, so a predicate that widens too far fails on the
    negatives rather than passing silently.
    """

    def test_comment_with_question_mark_warns(self):
        """A Comment carries no outcome, so a '?' in its title asks for something
        the item cannot record — even when the mark is mid-title, as in
        'What is this person's name? (Last name, First name, MI)'."""
        issues = _processor("lint_comment_title.qml").to_issues()
        flagged = {
            i["item_id"] for i in issues if i["type"] == "comment_titled_as_question"
        }
        assert "q_ask_name" in flagged

    def test_comment_with_inscription_verb_warns(self):
        """'Please print …' asks for something written down and carries no
        question mark — the shape a trailing-'?' rule would miss entirely."""
        issues = _processor("lint_comment_title.qml").to_issues()
        asked = [
            i
            for i in issues
            if i["type"] == "comment_titled_as_question" and i["item_id"] == "q_ask_contact"
        ]
        assert len(asked) == 1, f"expected one warning for q_ask_contact, got {asked}"
        assert asked[0]["severity"] == "warning"
        # The suggestion has to name BOTH repairs: the item may be meant to
        # collect an answer, or meant not to ask at all.
        assert "Textarea" in asked[0]["suggestion"]
        assert "reword" in asked[0]["suggestion"]

    def test_instructional_comments_are_not_flagged(self):
        """A Comment EXISTS to instruct. 'Please answer … honestly' and 'Please
        read …' are exactly right, and 'a list of household expenses' uses the
        verb as a noun — none may warn, or the lint fires on correct authoring."""
        issues = _processor("lint_comment_title.qml").to_issues()
        flagged = {
            i["item_id"] for i in issues if i["type"] == "comment_titled_as_question"
        }
        for item_id in (
            "q_instruction",
            "q_instruction_read",
            "q_section_header",
            "q_describes_a_list",
        ):
            assert item_id not in flagged, f"{item_id} was flagged but is correct authoring"

    def test_question_titled_with_a_question_mark_is_not_flagged(self):
        """The lint is Comment-only: a Question asking a question is the point."""
        issues = _processor("lint_comment_title.qml").to_issues()
        flagged = {
            i["item_id"] for i in issues if i["type"] == "comment_titled_as_question"
        }
        assert "q_real_question" not in flagged

    def test_roster_subject_naming_a_comment_warns(self):
        """subjectFrom names the item whose ANSWER titles each iteration. A
        Comment supplies none, so the subject can never resolve and
        FlowProcessor falls back to the static label forever — silently."""
        issues = _processor("lint_comment_title.qml").to_issues()
        subject = [i for i in issues if i["type"] == "roster_subject_not_answerable"]
        assert len(subject) == 1, f"expected one subjectFrom warning, got {subject}"
        issue = subject[0]
        assert issue["severity"] == "warning"
        # Owned by the BLOCK: the defect is the roster's declaration, not the
        # Comment's own authoring.
        assert issue["item_id"] == "b_broken_roster"
        assert "q_roster_note" in issue["message"]
        assert "Comment" in issue["message"]

    def test_roster_subject_naming_an_answerable_item_is_not_flagged(self):
        """b_good_roster points at a Textarea Question inside itself — correct."""
        issues = _processor("lint_comment_title.qml").to_issues()
        flagged = {
            i["item_id"] for i in issues if i["type"] == "roster_subject_not_answerable"
        }
        assert "b_good_roster" not in flagged

    def test_authoring_lints_never_flip_is_valid(self):
        """Both are advisory: an instrument that runs, just not as its wording
        promises. Portor's gate is error-only, so a warning here must not reach
        it — an authoring nit that blocked publishing would be worse than the nit."""
        issues = _processor("lint_comment_title.qml").to_issues()
        assert [i for i in issues if i["type"] == "comment_titled_as_question"]
        assert [i for i in issues if i["type"] == "roster_subject_not_answerable"]
        assert not [i for i in issues if i["severity"] == "error"]


@functools.cache
def _lint_559_issues() -> tuple[dict[str, Any], ...]:
    """``lint_authoring_559.qml``'s issues, validated once for the whole class."""
    return tuple(_processor("lint_authoring_559.qml").to_issues())


def _flagged(issue_type: str) -> dict[str, list[dict[str, Any]]]:
    """``lint_authoring_559.qml``'s issues of one type, grouped by item."""
    grouped: dict[str, list[dict[str, Any]]] = {}
    for issue in _lint_559_issues():
        if issue["type"] == issue_type:
            grouped.setdefault(issue["item_id"], []).append(issue)
    return grouped


@pytest.mark.integration
class TestDemoInstrumentAuthoringLints:
    """#559: three defects the Demo-instrument review found by reading.

    All three come from ``lint_authoring_559.qml``, which carries each lint's
    positive next to the shapes it must leave alone, so a rule that widens
    fails on a negative instead of passing on the positive alone.
    """

    def test_self_assignment_warns_once_naming_the_statement(self):
        """``q_building.outcome = q_building.outcome`` (the ACS shape) changes
        nothing, nested under an ``if`` (q_nested) too; ``rooms = rooms + 0``
        and a plain copy are real statements."""
        flagged = _flagged("self_assignment")
        assert set(flagged) == {"q_building", "q_nested"}
        (issue,) = flagged["q_building"]
        assert issue["severity"] == "warning"
        assert "'q_building.outcome'" in issue["message"]

    def test_postcondition_admitting_one_answer_warns(self):
        """A Switch and a two-option Radio each admit one answer, and q_tier's
        two postconditions admit one of three between them: the other answers
        hold the respondent on the item and are never recorded."""
        flagged = _flagged("mandated_answer_postcondition")
        assert set(flagged) == {"q_consent", "q_outsourced", "q_tier"}
        assert "only the answer 3 of 3" in flagged["q_tier"][0]["message"]
        consent = flagged["q_consent"][0]
        assert "only the answer 1 of 2" in consent["message"]
        # The remedy is routing, and it names the gate to write.
        assert "q_consent.outcome == 1" in consent["suggestion"]
        assert "screen-out" in consent["suggestion"]

    def test_postconditions_that_admit_more_or_relate_answers_are_silent(self):
        """Two of three admitted is a real restriction, not a mandate; a numeric
        control is not a choice; a relational rule is a consistency check, even
        one (q_confirm) that admits a single answer for most respondents."""
        flagged = _flagged("mandated_answer_postcondition")
        for item_id in ("q_region", "q_age", "q_match", "q_confirm"):
            assert item_id not in flagged

    def test_combinable_none_option_warns(self):
        """"No health insurance" ticked beside a plan is an answer that
        contradicts itself, and nothing on q_cover refuses it."""
        flagged = _flagged("combinable_none_option")
        (issue,) = flagged["q_cover"]
        assert "bit 4" in issue["message"]
        # The suggested guard must itself satisfy the lint, or the author who
        # follows it is told the same thing again.
        assert "(q_cover.outcome // 4) % 2 == 0 or q_cover.outcome == 4" in issue["suggestion"]

    def test_a_guard_that_still_admits_a_combination_warns(self):
        """The lint reads the guard, not just its presence: '>= 4' lets "None"
        plus Medicare (5) through, so q_cover_leaky still warns."""
        assert "q_cover_leaky" in _flagged("combinable_none_option")

    def test_guarded_unreadable_and_non_denial_options_are_silent(self):
        """The suggested guard clears the lint, on the item or on its block; a
        postcondition reading another item may already exclude the combination;
        "Not sure" denies nothing; a QuestionGroup's list outcome is not a
        bitmask the suggested guard could test."""
        flagged = _flagged("combinable_none_option")
        assert set(flagged) == {"q_cover", "q_cover_leaky"}

    @pytest.mark.parametrize(
        "predicate",
        [
            "q.outcome == 1",
            "q.outcome != 1 and q.outcome != 2",
            "(q.outcome == 1 or 2) == 2",
            "q.outcome == 1 or (1, 2) != [1, 2]",
            "q.outcome in {1, 3}",
            "not (q.outcome // 2) % 2 == 0",
            "q.outcome & 2 == 0",
        ],
    )
    def test_the_interpreter_agrees_with_python(self, predicate):
        """The answer set is read by a small interpreter, so it must agree
        with Python on what Python itself decides — and/or return operands
        and short-circuit, and a tuple is not a list."""
        values = [1, 2, 3]
        expected = {
            v
            for v in values
            if eval(predicate, {"__builtins__": {}}, {"q": SimpleNamespace(outcome=v)})
        }
        assert _admitted_outcomes(predicate, "q", values) == expected

    def test_a_reference_hidden_behind_a_short_circuit_is_still_relational(self):
        """Locality is structural: 'or (False and other.outcome == 1)' never
        evaluates the foreign read, but the rule still names another item."""
        predicate = "q.outcome == 1 or (False and other.outcome == 1)"
        assert _admitted_outcomes(predicate, "q", [1, 2]) is None

    def test_an_evaluation_error_is_silence_not_an_exception(self):
        """to_issues feeds the publish gate, which turns an exception into a
        blocking validation_error — an advisory lint must never refuse a publish."""
        assert _admitted_outcomes('("%" % q.outcome) == "x"', "q", [1, 2]) is None

    def test_none_of_the_three_flips_is_valid(self):
        """Each describes an instrument that runs, so each is a warning: an
        authoring nit that blocked publishing would be worse than the nit."""
        mine = [
            i
            for i in _lint_559_issues()
            if i["type"]
            in {"self_assignment", "mandated_answer_postcondition", "combinable_none_option"}
        ]
        assert {i["type"] for i in mine} == {
            "self_assignment",
            "mandated_answer_postcondition",
            "combinable_none_option",
        }
        assert all(i["severity"] == "warning" for i in mine)


_CHECKBOX_GATE_QML = """
qmlVersion: "2.0"
questionnaire:
  title: "Checkbox gate"
  blocks:
    - id: b
      title: b
      items:
        - id: q_cb
          kind: Question
          title: "Which apply?"
          input:
            control: Checkbox
            labels: {labels}
        - id: q_gated
          kind: Question
          title: "Follow-up"
          precondition:
            - predicate: "{predicate}"
          input:
            control: Radio
            labels: {{1: "Yes", 2: "No"}}
"""


def _checkbox_gate_errors(
    predicate: str, labels: str = '{1: "A", 2: "B", 8: "D"}'
) -> list[tuple[str, str]]:
    """Error findings for an item gated on a Checkbox (keys {1, 2, 8} by default)."""
    qml = _CHECKBOX_GATE_QML.format(predicate=predicate, labels=labels)
    data = QMLLoader().load_from_string(qml)
    issues = ValidationProcessor(QMLState(data)).to_issues()
    return [(i["type"], i["item_id"]) for i in issues if i["severity"] == "error"]


@pytest.mark.integration
class TestCheckboxBitmaskDomain:
    """#1140: a Checkbox answers the sum of its ticked keys, not one key.

    Enumerating the keys (as for a Radio) made a gate on a real combination
    classify NEVER — an ``unreachable_item`` ERROR, which the publish gate
    refuses — for an instrument that runs correctly.
    """

    @pytest.mark.parametrize(
        "predicate",
        ["q_cb.outcome == 3", "q_cb.outcome == 11", "q_cb.outcome == 0"],
    )
    def test_a_combination_or_nothing_ticked_is_reachable(self, predicate):
        """A+B (3), all three (11) and nothing ticked (0, the control's
        initial value) are all answers the runtime accepts."""
        assert _checkbox_gate_errors(predicate) == []

    @pytest.mark.parametrize(
        "predicate",
        ["q_cb.outcome == 4", "q_cb.outcome == 12", "q_cb.outcome > 11"],
    )
    def test_an_undeclared_bit_or_an_overflow_stays_unreachable(self, predicate):
        """4 is not a declared key and 12 carries it; nothing exceeds 1+2+8.
        Widening the domain to 'any integer' would pass the test above and
        lose these."""
        assert _checkbox_gate_errors(predicate) == [("unreachable_item", "q_gated")]

    def test_every_bit_of_a_longer_undeclared_run_stays_clear(self):
        """Keys {1, 16} leave 2, 4 and 8 undeclared, cleared as ONE run: 5
        (1 + 4) sets its middle bit and 9 (1 + 8) its top bit; 17 is a real
        answer."""
        labels = '{1: "A", 16: "E"}'
        for undeclared in ("q_cb.outcome == 5", "q_cb.outcome == 9"):
            assert _checkbox_gate_errors(undeclared, labels) == [
                ("unreachable_item", "q_gated")
            ]
        assert _checkbox_gate_errors("q_cb.outcome == 17", labels) == []


@pytest.mark.integration
class TestTextareaInPredicateLint:
    """A Textarea outcome referenced in a predicate/codeBlock surfaces as a
    ``textarea_in_predicate`` WARNING.

    A Textarea has a string outcome with no Z3 integer variable; ``.outcome`` in
    a predicate lowers to a sentinel, so the constraint is statically wrong.
    WARNING (not error) so stored files that already do this still save. Built
    from inline states — no parity fixture uses a Textarea outcome in logic.
    """

    def _state(self, gate: dict[str, Any]) -> QMLState:
        """One Textarea item plus a second item carrying ``gate`` (a precondition
        or codeBlock referencing — or not — the Textarea outcome)."""
        return QMLState(
            {
                "title": "textarea-lint",
                "blocks": [{"id": "b1", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_comment",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "Any comments?",
                        "input": {"control": "Textarea"},
                    },
                    {
                        "id": "q_follow",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "Follow up?",
                        "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                        **gate,
                    },
                ],
            }
        )

    def test_precondition_referencing_textarea_outcome_warns(self):
        """A precondition on ``q_comment.outcome`` → one textarea_in_predicate
        warning attributed to the referencing item, naming the Textarea item."""
        state = self._state({"precondition": [{"predicate": "q_comment.outcome >= 0"}]})
        issues = ValidationProcessor(state).to_issues()

        textarea = [i for i in issues if i["type"] == "textarea_in_predicate"]
        assert len(textarea) == 1, f"expected one textarea_in_predicate warning, got {issues}"
        issue = textarea[0]
        assert issue["severity"] == "warning"
        assert issue["item_id"] == "q_follow"
        assert "q_comment" in issue["message"]
        assert "precondition" in issue["message"]
        assert set(issue.keys()) == {"item_id", "severity", "type", "message", "suggestion"}

    def test_textarea_outcome_never_referenced_no_warning(self):
        """A Textarea whose outcome is not referenced in any predicate/codeBlock
        yields no textarea_in_predicate warning."""
        state = self._state({})
        issues = ValidationProcessor(state).to_issues()
        assert [i for i in issues if i["type"] == "textarea_in_predicate"] == []

    def test_codeblock_read_of_textarea_outcome_warns(self):
        """A codeBlock reading ``q_comment.outcome`` → one textarea_in_predicate
        warning with condition_kind ``codeBlock``, attributed to the item."""
        state = self._state({"codeBlock": "seen = q_comment.outcome + 1"})
        issues = ValidationProcessor(state).to_issues()

        textarea = [i for i in issues if i["type"] == "textarea_in_predicate"]
        assert len(textarea) == 1, f"expected one textarea_in_predicate warning, got {issues}"
        issue = textarea[0]
        assert issue["severity"] == "warning"
        assert issue["item_id"] == "q_follow"
        assert "codeBlock" in issue["message"]


@pytest.mark.integration
class TestNameCollisionScoping:
    """The lint name oracles must be scope-aware, not a file-wide flattened union.

    A comprehension / generator / lambda local does not leak out of its own
    expression in Python 3, so reusing such a name in one unit must NOT define,
    un-freeze, or count-as-read a same-named variable that lives in an unrelated
    unit. These lock the fix for the file-wide-union suppression class: an
    unrelated ``[... for X in ...]`` elsewhere in the document silently erased a
    real undefined_name error (#1), a frozen-gate unreachable_item error (#2),
    and a write_only warning (#3/#4).
    """

    def test_phantom_survives_unrelated_comprehension_reuse(self):
        """A genuine phantom stays an undefined_name error even when an unrelated
        item's codeBlock binds the same name as a comprehension local."""
        state = QMLState(
            {
                "title": "collision-phantom",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_gate",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "gated on a phantom",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": "smoking_status == 1"}],
                    },
                    {
                        "id": "q_other",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "unrelated comprehension reuses the name",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "codeBlock": "counts = [smoking_status * 2 for smoking_status in [1, 2, 3]]",
                    },
                ],
            }
        )
        undefined = [i for i in ValidationProcessor(state).to_issues() if i["type"] == "undefined_name"]
        assert len(undefined) == 1, (
            f"phantom suppressed by an unrelated comprehension-local reuse; got {undefined}"
        )
        assert undefined[0]["item_id"] == "q_gate"
        assert "smoking_status" in undefined[0]["message"]

    def test_frozen_gate_survives_unrelated_comprehension_reuse(self):
        """A frozen-gate unreachable_item error stays fired even when an unrelated
        item's comprehension binds the frozen variable's name."""
        state = QMLState(
            {
                "title": "collision-frozen",
                "codeInit": "has_partner = 0",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_partner_name",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "gated on a frozen constant",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": "has_partner == 1"}],
                    },
                    {
                        "id": "q_other",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "unrelated comprehension reuses the name",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "codeBlock": "flags = [has_partner for has_partner in [0, 1, 1]]",
                    },
                ],
            }
        )
        unreachable = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "unreachable_item"
        ]
        assert any(i["item_id"] == "q_partner_name" for i in unreachable), (
            f"frozen-gate dead code suppressed by an unrelated comprehension-local reuse; "
            f"got {unreachable}"
        )

    def test_write_only_survives_unrelated_comprehension_reuse(self):
        """A write-only variable stays flagged even when an unrelated item's
        comprehension-local shadow reuses its name (a comprehension local is not
        a read of the outer variable)."""
        state = QMLState(
            {
                "title": "collision-write-only",
                "codeInit": "path = 0",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_a",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "assigns the write-only var",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "codeBlock": "path = 1",
                    },
                    {
                        "id": "q_other",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "unrelated comprehension reuses the name",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "codeBlock": "doubled = [path * 2 for path in [1, 2, 3]]",
                    },
                ],
            }
        )
        write_only = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "write_only_variable"
        ]
        assert any(i["message"] and "path" in i["message"] for i in write_only), (
            f"write-only var suppressed by an unrelated comprehension-local shadow; got {write_only}"
        )


@pytest.mark.integration
class TestCensusNonNameProducers:
    """The read/write census must see producers bound via non-Name targets.

    ``_scan_code`` originally recorded only ``ast.Name`` assignment targets, so a
    variable produced via tuple-unpack / for-loop / walrus / with-as was invisible
    to the census: a legitimate second producer looked like a single-assignment
    alias (#6), and a non-Name-only producer that is never read escaped the
    write-only lint entirely (#7).
    """

    def test_non_name_second_producer_is_not_a_pass_through_alias(self):
        """One bare-outcome Name assignment PLUS a tuple-unpack producer is a
        two-producer consolidation, not a pass-through alias."""
        state = QMLState(
            {
                "title": "census-consolidation",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_src",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "source",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                    },
                    {
                        "id": "q_a",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "bare-outcome producer",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "codeBlock": "consolidated = q_src.outcome",
                    },
                    {
                        "id": "q_b",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "tuple-unpack second producer",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "codeBlock": "consolidated, spare = 5, 6",
                    },
                    {
                        "id": "q_c",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "reads the consolidated var",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": "consolidated >= 0"}],
                    },
                ],
            }
        )
        alias = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "pass_through_alias"
        ]
        assert all("consolidated" not in (i["message"] or "") for i in alias), (
            f"a two-producer consolidation was mis-flagged a pass-through alias; got {alias}"
        )

    def test_non_name_only_producer_is_write_only_when_unread(self):
        """A variable produced ONLY via a tuple-unpack target, never read, is
        write-only — the census must see the non-Name producer to flag it."""
        state = QMLState(
            {
                "title": "census-nonname-writeonly",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_src",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "source",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                    },
                    {
                        "id": "q_a",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "produces dead_var only via tuple-unpack, never read",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "codeBlock": "dead_var, spare = q_src.outcome, 0",
                    },
                ],
            }
        )
        write_only = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "write_only_variable"
        ]
        assert any("dead_var" in (i["message"] or "") for i in write_only), (
            f"a non-Name-only unread producer escaped the write-only lint; got {write_only}"
        )


@pytest.mark.integration
class TestReservedSentinelItemIds:
    """Item ids ``__init__`` and ``codeInit`` collide with internal sentinels and
    are rejected by the loader (#3 full-base gating corruption / frozen-oracle
    pollution; #5 hygiene-owner misroute to item_id=None)."""

    @pytest.mark.parametrize("reserved", ["__init__", "codeInit"])
    def test_reserved_item_id_is_rejected(self, reserved):
        raw = {
            "questionnaire": {
                "title": "reserved-id",
                "blocks": [
                    {
                        "id": "b",
                        "kind": "Group",
                        "title": "B",
                        "items": [
                            {
                                "id": reserved,
                                "kind": "Question",
                                "title": "misnamed",
                                "input": {"control": "Editbox", "min": 0, "max": 10},
                            }
                        ],
                    }
                ],
            }
        }
        loader = QMLLoader(schema_path=None)
        with pytest.raises(ValueError, match="reserved"):
            loader.load_from_string(_dump_yaml(raw))


@pytest.mark.integration
class TestHygieneOwnerFallback:
    """A hygiene issue for a variable assigned only in codeInit carries the
    ``"codeInit"`` owner label, never ``item_id=None`` (#8 — every issue type must
    populate item_id with a real owner string)."""

    def test_codeinit_only_write_only_owner_is_codeinit(self):
        state = QMLState(
            {
                "title": "codeinit-only-writeonly",
                "codeInit": "orphan = 7",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_a",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "reads nothing relevant",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                    }
                ],
            }
        )
        write_only = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "write_only_variable"
        ]
        orphan = [i for i in write_only if "orphan" in (i["message"] or "")]
        assert len(orphan) == 1, f"expected one write_only for the codeInit-only var; got {write_only}"
        assert orphan[0]["item_id"] == "codeInit", (
            f"codeInit-only hygiene owner must be the 'codeInit' label, not {orphan[0]['item_id']!r}"
        )


@pytest.mark.integration
class TestPublishGate:
    """evaluate_publish_gate_content — the soundness gate every publish door runs.

    The gate blocks on error-severity issues only (warnings pass), and fails
    CLOSED on anything that prevents analysis (YAML/schema failure, a non-string
    argument) — a structurally broken work-in-progress questionnaire is saveable
    but never publishable.

    It takes CONTENT, never a path: QML is canonical in the document store, and
    a merge candidate is synthesised in memory and never belongs on disk.
    """

    # Documents below use the full QML DOCUMENT shape (qmlVersion + nested
    # questionnaire.blocks[].items[]) — the gate runs the real QMLLoader,
    # unlike the flattened dicts the other classes feed ValidationProcessor
    # directly.
    _CLEAN_DOC: dict[str, Any] = {
        "qmlVersion": "2.0",
        "questionnaire": {
            "title": "publish gate clean",
            "blocks": [
                {
                    "id": "b",
                    "kind": "Group",
                    "title": "B",
                    "items": [
                        {
                            "id": "q_age",
                            "kind": "Question",
                            "title": "Age",
                            "input": {"control": "Editbox", "min": 18, "max": 99},
                        }
                    ],
                }
            ],
        },
    }

    @staticmethod
    def _qml(doc: dict[str, Any]) -> str:
        return yaml.safe_dump(doc)

    def test_clean_content_passes(self):
        from askalot_qml.core import evaluate_publish_gate_content

        result = evaluate_publish_gate_content(self._qml(self._CLEAN_DOC))
        assert result.ok, f"clean QML must pass the gate; issues: {result.issues}"
        assert result.errors == []

    def test_fails_closed_on_broken_yaml(self):
        from askalot_qml.core import evaluate_publish_gate_content

        result = evaluate_publish_gate_content("questionnaire: [unterminated")

        assert result.ok is False
        assert any(i["type"] == "load_error" for i in result.issues)
        # No artifacts were produced — a null report is the "not assessed"
        # signal publish doors persist (R7).
        assert result.quality_report is None

    def test_refuses_a_non_string_instead_of_reading_it(self):
        """A stream-like non-string must be refused, never handed to PyYAML.

        PyYAML duck-types any object exposing ``read`` as a stream and calls it
        until it returns empty. An object that answers every attribute never
        does, so the reader grows its buffer without bound and the process dies
        of memory exhaustion rather than raising — an OOM kill, not a refusal.
        """
        from unittest.mock import MagicMock

        from askalot_qml.core import evaluate_publish_gate_content

        result = evaluate_publish_gate_content(MagicMock(), source_label="probe")

        assert result.ok is False
        assert any(i["type"] == "load_error" for i in result.issues)
        assert result.quality_report is None

    def test_phantom_name_blocks(self):
        from askalot_qml.core import evaluate_publish_gate_content

        doc = copy.deepcopy(self._CLEAN_DOC)
        doc["questionnaire"]["blocks"][0]["items"][0]["precondition"] = [
            {"predicate": "phantom_flag == 1"}
        ]
        result = evaluate_publish_gate_content(self._qml(doc))
        assert not result.ok
        assert any(i["type"] == "undefined_name" for i in result.errors), result.errors

    def test_warnings_only_passes(self):
        from askalot_qml.core import evaluate_publish_gate_content

        # write-only variable -> hygiene warning, must NOT block publication
        doc = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "publish gate warn-only",
                "codeInit": "unused_counter = 0",
                "blocks": [
                    {
                        "id": "b",
                        "kind": "Group",
                        "title": "B",
                        "items": [
                            {
                                "id": "q_a",
                                "kind": "Question",
                                "title": "A",
                                "input": {"control": "Editbox", "min": 0, "max": 10},
                                "codeBlock": "unused_counter = 1",
                            }
                        ],
                    }
                ],
            },
        }
        result = evaluate_publish_gate_content(self._qml(doc))
        assert result.ok, f"warning-only findings must pass the gate; got {result.errors}"
        assert any(i["severity"] == "warning" for i in result.issues)

    def test_clean_content_carries_quality_report(self):
        # The gate computes the advisory D2-D8 scorecard from the same
        # ValidationProcessor artifacts, so sound content carries a report.
        from askalot_qml.core import evaluate_publish_gate_content

        result = evaluate_publish_gate_content(self._qml(self._CLEAN_DOC))
        assert result.ok
        assert isinstance(result.quality_report, dict)
        assert "dimensions" in result.quality_report

    def test_error_severity_content_still_carries_quality_report(self):
        # Content that loads and analyzes but has an error-severity issue is
        # unsound (ok=False) yet still analyzable — the scorecard is
        # soundness-independent, so the report is present (R7 distinction).
        from askalot_qml.core import evaluate_publish_gate_content

        doc = copy.deepcopy(self._CLEAN_DOC)
        doc["questionnaire"]["blocks"][0]["items"][0]["precondition"] = [
            {"predicate": "phantom_flag == 1"}
        ]
        result = evaluate_publish_gate_content(self._qml(doc))
        assert not result.ok
        assert isinstance(result.quality_report, dict)
        assert "dimensions" in result.quality_report

    def test_unparseable_yaml_fails_closed(self):
        from askalot_qml.core import evaluate_publish_gate_content

        result = evaluate_publish_gate_content("title: [unclosed\nitems: - half a sketch:\n")
        assert not result.ok
        assert result.errors[0]["type"] == "load_error"
        assert result.quality_report is None

    def test_schema_invalid_fails_closed(self):
        from askalot_qml.core import evaluate_publish_gate_content

        # parses as YAML but violates the QML JSON schema (blocks not a list)
        doc = {"qmlVersion": "2.0", "questionnaire": {"title": "bad", "blocks": {"not": "a list"}}}
        result = evaluate_publish_gate_content(self._qml(doc))
        assert not result.ok
        assert result.errors[0]["type"] == "load_error"


@pytest.mark.integration
class TestValidationHierarchy:
    """#164: Levels 2–4 of the validation hierarchy reach the issue channel.

    Before #164 only Level 1 (per-item classification) reached ``to_issues``, so
    a questionnaire that traps every respondent (globally UNSAT) or has a
    dependency cycle passed the publish gate. Level 4 accumulated dead code is
    O(items²) solver work, gated behind ``deep`` so the interactive validate loop
    stays fast; the publish gate opts in.
    """

    def test_globally_unsat_questionnaire_is_error(self):
        """thesis_conflicting_postconditions.qml has no valid completion (F is
        UNSAT) → a ``global_unsat`` error even though no single item is
        INFEASIBLE."""
        issues = _processor("thesis_conflicting_postconditions.qml").to_issues()
        gu = [i for i in issues if i["type"] == "global_unsat"]
        assert len(gu) == 1, f"expected one global_unsat error, got {gu}"
        assert gu[0]["severity"] == "error"
        assert gu[0]["item_id"] is None
        assert set(gu[0].keys()) == {"item_id", "severity", "type", "message", "suggestion"}

    def test_dependency_cycle_is_error(self):
        """Two items whose codeBlocks/preconditions read each other's produced
        variable form a cycle → a ``dependency_cycle`` error naming the loop."""
        state = QMLState(
            {
                "title": "cycle",
                "codeInit": "pa = 0\npb = 0",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_a",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "A",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": "pb == 1"}],
                        "codeBlock": "pa = 1",
                    },
                    {
                        "id": "q_b",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "B",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": "pa == 1"}],
                        "codeBlock": "pb = 1",
                    },
                ],
            }
        )
        cycle = [i for i in ValidationProcessor(state).to_issues() if i["type"] == "dependency_cycle"]
        assert cycle, "expected a dependency_cycle error"
        for issue in cycle:
            assert issue["severity"] == "error"
            assert "q_a" in issue["message"] and "q_b" in issue["message"]

    def test_accumulated_dead_code_is_deep_only(self):
        """thesis_dead_code_simple.qml has a CONDITIONAL-but-accumulated-dead item.
        The default (fast) path omits the O(items²) Level 4 pass; ``deep=True``
        surfaces it as an ``accumulated_dead_code`` warning."""
        default_types = {i["type"] for i in _processor("thesis_dead_code_simple.qml").to_issues()}
        assert "accumulated_dead_code" not in default_types

        deep = [
            i
            for i in _processor("thesis_dead_code_simple.qml").to_issues(deep=True)
            if i["type"] == "accumulated_dead_code"
        ]
        assert deep, "deep validation must surface accumulated dead code"
        for issue in deep:
            assert issue["severity"] == "warning"
            assert set(issue.keys()) == {"item_id", "severity", "type", "message", "suggestion"}


@pytest.mark.integration
class TestFrozenVariableLint:
    """#169: a frozen variable read by a gate surfaces as a ``frozen_variable``
    error naming the root cause — symmetrically in both polarities.

    A frozen variable (initialized in codeInit, never reassigned by any
    codeBlock) is a compile-time constant, so every gate on it is statically
    decided. The always-false polarity ALSO yields downstream ``unreachable_item``
    errors; the always-true polarity produced ZERO diagnostics before #169.
    """

    def _frozen_state(self, init: str, predicate: str) -> QMLState:
        return QMLState(
            {
                "title": "frozen",
                "codeInit": init,
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_gate",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "gated on a frozen constant",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": predicate}],
                    }
                ],
            }
        )

    def test_always_false_frozen_gate_names_root_cause(self):
        """`has_partner = 0` frozen, gate `has_partner == 1` → the item is
        unreachable AND a frozen_variable error names the root cause and the
        affected gate."""
        issues = ValidationProcessor(self._frozen_state("has_partner = 0", "has_partner == 1")).to_issues()
        frozen = [i for i in issues if i["type"] == "frozen_variable"]
        assert len(frozen) == 1, f"expected one frozen_variable error, got {frozen}"
        assert frozen[0]["severity"] == "error"
        assert "has_partner" in frozen[0]["message"]
        assert "q_gate" in frozen[0]["message"]
        # The downstream symptom stays visible (grouped, not replaced).
        assert any(i["type"] == "unreachable_item" and i["item_id"] == "q_gate" for i in issues)

    def test_always_true_frozen_gate_is_caught(self):
        """`has_kids = 0` frozen, gate `has_kids == 0` classifies ALWAYS (no
        unreachable_item) — before #169 this produced zero diagnostics; now the
        frozen_variable error catches the silently-dead gate."""
        issues = ValidationProcessor(self._frozen_state("has_kids = 0", "has_kids == 0")).to_issues()
        frozen = [i for i in issues if i["type"] == "frozen_variable"]
        assert len(frozen) == 1, f"expected one frozen_variable error, got {frozen}"
        assert frozen[0]["severity"] == "error"
        assert "has_kids" in frozen[0]["message"]

    def test_suggestion_names_external_flag(self):
        """QML External Inputs U8 / R5: the frozen_variable suggestion points
        authors at the sanctioned `external: true` resolution (not the
        `ADMIN:`-preamble workaround it named before)."""
        issues = ValidationProcessor(self._frozen_state("has_kids = 0", "has_kids == 0")).to_issues()
        frozen = [i for i in issues if i["type"] == "frozen_variable"]
        assert len(frozen) == 1
        suggestion = frozen[0]["suggestion"]
        assert "external: true" in suggestion
        # The retired ADMIN-preamble phrasing must be gone from this suggestion.
        assert "admin/preamble" not in suggestion

    def test_produced_variable_is_not_frozen(self):
        """A variable reassigned by a codeBlock is produced, not frozen — its gate
        stays conditional and yields no frozen_variable error."""
        state = QMLState(
            {
                "title": "produced",
                "codeInit": "flag = 0",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_src",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "produces flag",
                        "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                        "codeBlock": "flag = q_src.outcome",
                    },
                    {
                        "id": "q_gate",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "gated on the produced flag",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": "flag == 1"}],
                    },
                ],
            }
        )
        assert [i for i in ValidationProcessor(state).to_issues() if i["type"] == "frozen_variable"] == []


@pytest.mark.integration
class TestWriteOnlyMultiSite:
    """#167: a write-only variable's finding enumerates EVERY writer site.

    The finding used to name only the first assigning item, so a fixer removed
    one dead write and left the rest.
    """

    def test_write_only_lists_all_writer_sites(self):
        """`path` written by two codeBlocks and never read → one write_only
        warning whose message names both writer items."""
        state = QMLState(
            {
                "title": "multi-site-writeonly",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_p1",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "writer one",
                        "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                        "codeBlock": "path = 1",
                    },
                    {
                        "id": "q_p2",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "writer two",
                        "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                        "codeBlock": "path = 2",
                    },
                ],
            }
        )
        write_only = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "write_only_variable"
        ]
        assert len(write_only) == 1, f"expected one write_only warning, got {write_only}"
        msg = write_only[0]["message"]
        assert "q_p1" in msg and "q_p2" in msg, f"message must list both writer sites: {msg}"


@pytest.mark.integration
class TestDuplicateInputBoundDedup:
    """#167: one duplicate_input_bound warning per ITEM, and no overlapping
    tautological_postcondition for the same authoring defect."""

    def test_two_bound_restatements_yield_one_warning_no_tautological(self):
        """An item that restates its min in one postcondition and its max in
        another (both redundant with the [0,100] Slider domain) is ONE defect:
        exactly one duplicate_input_bound warning and no tautological_postcondition
        (the more specific finding wins)."""
        state = QMLState(
            {
                "title": "dup-bound",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_pct",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "pct",
                        "input": {"control": "Slider", "min": 0, "max": 100},
                        "postcondition": [
                            {"predicate": "q_pct.outcome >= 0"},
                            {"predicate": "q_pct.outcome <= 100"},
                        ],
                    }
                ],
            }
        )
        issues = ValidationProcessor(state).to_issues()
        dup = [i for i in issues if i["type"] == "duplicate_input_bound"]
        taut = [i for i in issues if i["type"] == "tautological_postcondition"]
        assert len(dup) == 1, f"expected one duplicate_input_bound, got {dup}"
        assert taut == [], f"tautological must be suppressed when duplicate_input_bound fires: {taut}"


@pytest.mark.integration
class TestSkippedConditionLint:
    """#165: a pre/postcondition the static translator cannot lower to Z3 is
    surfaced as a ``skipped_condition`` WARNING instead of being silently dropped.

    The gap was RECORDED in ``coverage_gaps`` but no ``to_issues`` branch surfaced
    it, so the author saw a clean file while the item's classification fell back to
    a trivial default and only the runtime enforced the rule. The canonical
    trigger is a QuestionGroup vector outcome ``qg.outcome[i]`` — QuestionGroups
    carry a single scalar Z3 var (no per-question cells), so the subscript read has
    no Z3 target in EITHER a precondition or a postcondition.
    """

    def _state(self, gate: dict[str, Any]) -> QMLState:
        return QMLState(
            {
                "title": "skipped-condition",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "qg_conditions",
                        "blockId": "b",
                        "kind": "QuestionGroup",
                        "title": "conds",
                        "questions": ["Asthma", "Diabetes", "Arthritis"],
                        "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                    },
                    {
                        "id": "q_followup",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "followup",
                        "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                        **gate,
                    },
                ],
            }
        )

    def test_unlowerable_precondition_surfaces_warning(self):
        """A precondition `qg_conditions.outcome[0] == 1` (Subscript over a
        QuestionGroup vector) → one skipped_condition warning naming the item and
        the unsupported node, never an error (runtime still enforces it)."""
        state = self._state({"precondition": [{"predicate": "qg_conditions.outcome[0] == 1"}]})
        issues = ValidationProcessor(state).to_issues()
        skipped = [i for i in issues if i["type"] == "skipped_condition"]
        assert len(skipped) == 1, f"expected one skipped_condition warning, got {issues}"
        issue = skipped[0]
        assert issue["severity"] == "warning"
        assert issue["item_id"] == "q_followup"
        assert "precondition" in issue["message"]
        assert "Subscript" in issue["message"]
        assert set(issue.keys()) == {"item_id", "severity", "type", "message", "suggestion"}
        assert [i for i in issues if i["severity"] == "error"] == []

    def test_lowerable_condition_yields_no_skipped_warning(self):
        """A fully-supported precondition (a plain outcome comparison) is lowered,
        so no skipped_condition warning is produced."""
        state = self._state({"precondition": [{"predicate": "qg_conditions.outcome == 1"}]})
        skipped = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "skipped_condition"
        ]
        assert skipped == []


@pytest.mark.integration
class TestUndefinedNameSuggestionOrder:
    """#167: the undefined_name fallback suggestion leads with the endorsed fix,
    not the frozen-variable / pass-through anti-patterns the other lints ban."""

    def test_fallback_suggestion_leads_with_outcome_reference(self):
        """A phantom with no matching `q_<name>` item takes the fallback branch;
        the suggestion must recommend referencing an existing outcome / adding an
        admin question BEFORE creating a codeInit or codeBlock variable."""
        state = QMLState(
            {
                "title": "undef-fallback",
                "blocks": [{"id": "b", "kind": "Group", "title": "B"}],
                "items": [
                    {
                        "id": "q_x",
                        "blockId": "b",
                        "kind": "Question",
                        "title": "gated on an external flag",
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                        "precondition": [{"predicate": "external_flag == 1"}],
                    }
                ],
            }
        )
        undefined = [i for i in ValidationProcessor(state).to_issues() if i["type"] == "undefined_name"]
        assert len(undefined) == 1
        suggestion = undefined[0]["suggestion"]
        # The endorsed options come first; the codeInit/codeBlock variable option
        # is last (it was the misleading lead-in before #167).
        outcome_pos = suggestion.find("outcome directly")
        admin_pos = suggestion.find("admin/preamble question")
        variable_pos = suggestion.find("introduce a variable")
        assert 0 <= outcome_pos < variable_pos, suggestion
        assert 0 <= admin_pos < variable_pos, suggestion


@pytest.mark.integration
class TestMergeGate:
    """merge_qml / evaluate_merge_gate — the publish gate applied to merge results.

    A canonical merge is machine-synthesised content no human ever reviewed, so
    R16/KTD3 puts the Z3 gate in front of it: a textually clean merge that
    breaks the logic graph is downgraded to a conflict and never promoted. The
    asymmetry is deliberate — a user-authored fast-forward is content the user
    just wrote and looked at, so it skips the gate.
    """

    # A three-block corpus whose edit regions sit far enough apart that a diff3
    # edit in each is genuinely disjoint. Written as literal YAML (not a dumped
    # dict) because the merge under test is line-oriented.
    BASE_QML = """qmlVersion: "2.0"
questionnaire:
  title: merge gate corpus
  blocks:
    - id: b_demo
      kind: Group
      title: Demographics
      items:
        - id: q_age
          kind: Question
          title: Age
          input:
            control: Editbox
            min: 18
            max: 99
        - id: q_region
          kind: Question
          title: Region
          input:
            control: Radio
            labels:
              1: North
              2: South
        - id: q_income
          kind: Question
          title: Monthly income
          input:
            control: Editbox
            min: 0
            max: 1000
"""

    @staticmethod
    def _edit(text: str, old: str, new: str) -> str:
        assert text.count(old) == 1, f"fixture drift: {old!r} is not unique"
        return text.replace(old, new)

    # Head adds a gate on q_income that references q_region.
    _INCOME_GATE = """            max: 1000
          precondition:
            - predicate: "q_region.outcome == 1"
"""

    def test_clean_merge_that_breaks_the_skip_graph_is_a_conflict(self):
        """Covers AE3 — Z3 failure downgrades a textually clean merge."""
        from askalot_common.documents.merge import MergeStatus
        from askalot_qml.core import merge_qml

        # Head gates q_income on q_region (valid on its own).
        head = self._edit(self.BASE_QML, "            max: 1000\n", self._INCOME_GATE)
        # Workspace renames q_region in a disjoint region (valid on its own).
        workspace = self._edit(self.BASE_QML, "        - id: q_region\n", "        - id: q_area\n")

        result = merge_qml(base=self.BASE_QML, head=head, workspace=workspace)

        assert result.merge.status is MergeStatus.CONFLICT
        assert result.promotable is False
        # The collision is semantic, not textual — no markers were produced.
        assert result.merge.conflict_count == 0
        assert result.verdict is not None and result.verdict.ok is False
        assert any(i["type"] == "undefined_name" for i in result.verdict.issues), result.verdict.issues
        assert result.reason and "q_region" in result.reason

    def test_clean_valid_merge_is_promotable_and_stamps_validation(self):
        from askalot_common.documents.merge import MergeStatus
        from askalot_qml.core import merge_qml

        head = self._edit(self.BASE_QML, "            max: 1000\n", self._INCOME_GATE)
        workspace = self._edit(self.BASE_QML, "            max: 99\n", "            max: 120\n")

        result = merge_qml(base=self.BASE_QML, head=head, workspace=workspace)

        assert result.merge.status is MergeStatus.CLEAN, result.merge.content
        assert result.promotable is True
        # Both sides' edits survive into the promotable content.
        assert "max: 120" in result.merge.content
        assert "q_region.outcome == 1" in result.merge.content
        assert result.verdict is not None and result.verdict.ok is True
        assert result.verdict.validation["ok"] is True
        assert result.verdict.validation["checked_at"]
        assert result.verdict.validation["source"] == "merge_gate"

    def test_textual_conflict_never_reaches_the_gate(self):
        from askalot_common.documents.merge import MergeStatus
        from askalot_qml.core import merge_qml

        head = self._edit(self.BASE_QML, "            max: 99\n", "            max: 120\n")
        workspace = self._edit(self.BASE_QML, "            max: 99\n", "            max: 65\n")

        result = merge_qml(base=self.BASE_QML, head=head, workspace=workspace)

        assert result.merge.status is MergeStatus.CONFLICT
        assert result.merge.conflict_count == 1
        assert "<<<<<<<" in result.merge.content
        # Marker-annotated text is not valid QML; running Z3 on it would only
        # produce a misleading second diagnosis.
        assert result.verdict is None

    def test_fast_forward_skips_the_gate(self):
        """R16 asymmetry — a user-authored fast-forward is not machine-synthesised."""
        from askalot_common.documents.merge import MergeStatus
        from askalot_qml.core import evaluate_merge_gate, merge_qml

        workspace = self._edit(
            self.BASE_QML,
            "            max: 1000\n",
            '            max: 1000\n          precondition:\n            - predicate: "phantom_flag == 1"\n',
        )
        # The skip is only meaningful if this content would actually be refused.
        assert evaluate_merge_gate(workspace).ok is False

        result = merge_qml(base=self.BASE_QML, head=self.BASE_QML, workspace=workspace)

        assert result.merge.status is MergeStatus.CLEAN
        assert result.merge.fast_forward is True
        assert result.promotable is True
        assert result.verdict is None

    def test_no_op_skips_the_gate(self):
        from askalot_qml.core import merge_qml

        head = self._edit(self.BASE_QML, "            max: 99\n", "            max: 120\n")

        result = merge_qml(base=self.BASE_QML, head=head, workspace=head)

        assert result.merge.no_op is True
        assert result.promotable is True
        assert result.verdict is None

    def test_gate_fails_closed_on_unloadable_candidate(self):
        """A candidate that cannot be validated is never reported as promotable."""
        from askalot_qml.core import evaluate_merge_gate

        verdict = evaluate_merge_gate("questionnaire: [unterminated\n")

        assert verdict.ok is False
        assert any(i["type"] == "load_error" for i in verdict.issues), verdict.issues
        assert verdict.validation["ok"] is False
        assert verdict.quality_report is None

    def test_gate_passes_warning_only_candidate(self):
        """Warnings are surfaced, not blocking — same severity policy as publish."""
        from askalot_qml.core import evaluate_merge_gate

        candidate = self._edit(
            self.BASE_QML,
            "  title: merge gate corpus\n",
            "  title: merge gate corpus\n  codeInit: |\n    unused_counter = 0\n",
        )
        candidate = self._edit(
            candidate,
            "            max: 1000\n",
            "            max: 1000\n          codeBlock: |\n            unused_counter = 1\n",
        )

        verdict = evaluate_merge_gate(candidate)

        assert verdict.ok is True, verdict.issues
        assert any(i["severity"] == "warning" for i in verdict.issues)
        assert verdict.validation["ok"] is True


@pytest.mark.integration
class TestUnsafeCodeLint:
    """Code the sandbox will refuse is refused at validation time (#729).

    ``PythonRunner.validate_code`` / ``validate_expr`` were reachable only from
    ``run_code`` / ``eval_expr``, so nothing static ever asked whether a body was
    admissible. A ``codeBlock`` containing ``import os`` passed validation,
    passed the publish gate, and was fielded — and then every respondent
    reaching that item tripped the same refusal, the block was skipped whole,
    and any item gated on a variable it should have assigned took the wrong
    branch with nothing said.
    """

    def _unsafe(self, filename: str) -> list[dict[str, Any]]:
        return [i for i in _processor(filename).to_issues() if i["type"] == "unsafe_code"]

    def test_a_forbidden_import_is_an_error_before_fielding(self):
        findings = self._unsafe("defect_unsupported_python.qml")
        assert len(findings) == 1, findings
        finding = findings[0]
        assert finding["severity"] == "error"
        assert finding["item_id"] == "q_age"
        # The runner's own words, not a paraphrase: the static path and the
        # runtime path must not have two vocabularies for one refusal.
        assert "Disallowed node type: Import" in finding["message"]

    def test_the_finding_carries_the_contract_keys(self):
        finding = self._unsafe("defect_unsupported_python.qml")[0]
        assert set(finding) == {"item_id", "severity", "type", "message", "suggestion"}
        assert finding["suggestion"]

    def test_a_clean_questionnaire_yields_none(self):
        assert self._unsafe("basic.qml") == []
        assert self._unsafe("branching_flow.qml") == []

    def test_a_call_refusal_is_worded_without_accusing_the_author(self):
        """A typo and ``__import__`` produce the SAME runner string.

        ``_check_ast_safety``'s Call-to-Name branch asks only whether the name is
        in the safe set, so "Call to disallowed function: X" cannot distinguish a
        misspelling from an escape. Reporting it with the sandbox's security
        wording accuses an author who mistyped. The message must name what is
        true of both — the name is unavailable — and must not claim a refusal
        the runner did not actually characterise.
        """
        issues = _processor("malformed_precondition.qml").to_issues()
        unsafe = [
            i for i in issues if i["item_id"] == "q_malformed" and i["type"] == "unsafe_code"
        ]
        assert len(unsafe) == 1, unsafe
        message = unsafe[0]["message"]
        assert "undefined_function" in message
        assert "does not provide" in message
        # The security framing belongs to unambiguous refusals only.
        assert "will be refused by the execution sandbox" not in message

    def test_both_lints_report_a_typo_because_they_say_different_things(self):
        """No suppression: ``undefined_name`` and ``unsafe_code`` both fire.

        They are not duplicates. The name lint says a name does not resolve; this
        one says the UNIT WILL NOT RUN — the block is skipped for every
        respondent. An earlier revision dropped the second when the first covered
        the same owner, and that is what let an escape hide behind a typo
        (``test_an_escape_behind_a_typo_is_still_reported``).
        """
        issues = _processor("malformed_precondition.qml").to_issues()
        types = {i["type"] for i in issues if i["item_id"] == "q_malformed"}
        assert {"undefined_name", "unsafe_code"} <= types

    def test_an_escape_behind_a_typo_is_still_reported(self):
        """A real escape must not be swallowed by a call refusal in front of it.

        ``_check_ast_safety`` returns on its FIRST refusal, so a predicate
        reading ``math.__dict__ == 1 and undefined_fn(1)`` reports the CALL. The
        suppression this replaced dropped that finding because ``undefined_fn``
        carried an ``undefined_name`` on the same item — leaving the attribute
        escape behind it with no error at all, and the publish gate open.
        """
        raw = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "Escape behind a typo",
                "blocks": [
                    {
                        "id": "b1",
                        "kind": "Group",
                        "title": "B",
                        "items": [
                            {
                                "id": "q_gated",
                                "kind": "Question",
                                "title": "Gated?",
                                "precondition": [
                                    {"predicate": "math.__dict__ == 1 and undefined_fn(1)"}
                                ],
                                "input": {"control": "Editbox"},
                            }
                        ],
                    }
                ],
            },
        }
        state = QMLState(QMLLoader(schema_path=None).load_from_string(yaml.safe_dump(raw)))
        issues = ValidationProcessor(state).to_issues()
        unsafe = [i for i in issues if i["type"] == "unsafe_code" and i["item_id"] == "q_gated"]
        assert unsafe, "the unit is refused by the sandbox and must carry an error"
        assert unsafe[0]["severity"] == "error"

    def test_a_syntax_error_is_not_reported_as_a_sandbox_refusal(self):
        """``validate_expr`` returns "Syntax error: ..." for unparseable code.

        The sandbox never got as far as judging what the code DOES, so the
        security wording and "use only the modules the sandbox declares" send
        the author hunting for a permissions problem in code that does not
        parse. The consequence is the same (the unit is skipped), so it is still
        an error — but it must say what is actually wrong.
        """
        raw = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "Syntax",
                "blocks": [
                    {
                        "id": "b1",
                        "kind": "Group",
                        "title": "B",
                        "items": [
                            {
                                "id": "q_one",
                                "kind": "Question",
                                "title": "One?",
                                "input": {"control": "Editbox"},
                            },
                            {
                                "id": "q_two",
                                "kind": "Question",
                                "title": "Two?",
                                "precondition": [{"predicate": "q_one.outcome == "}],
                                "input": {"control": "Editbox"},
                            },
                        ],
                    }
                ],
            },
        }
        state = QMLState(QMLLoader(schema_path=None).load_from_string(yaml.safe_dump(raw)))
        unsafe = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "unsafe_code"
        ]
        assert len(unsafe) == 1, unsafe
        finding = unsafe[0]
        assert "is not valid Python" in finding["message"]
        assert "will be refused by the execution sandbox" not in finding["message"]
        assert "modules and builtins the sandbox declares" not in finding["suggestion"]

    def test_a_fault_in_this_lint_does_not_discard_the_other_nineteen(self):
        """The degrade boundary every other lint in ``to_issues`` already has.

        ``to_issues`` is called by the validation endpoint, whose tail turns any
        exception into a 500. Unwrapped, one fault here would take the other
        lints' findings AND the endpoint down with it — so the failure mode is a
        blank Problems panel and a broken diagram, not a missing lint.
        """
        processor = _processor("defect_unsupported_python.qml")
        healthy = processor.to_issues()
        assert healthy, "fixture must produce findings for this test to mean anything"

        broken = _processor("defect_unsupported_python.qml")
        with patch.object(
            ValidationProcessor,
            "_sandbox_admissibility_issues",
            side_effect=RuntimeError("boom"),
        ):
            degraded = broken.to_issues()

        assert degraded, "a fault in one lint discarded every other lint's findings"
        assert not [i for i in degraded if i["type"] == "unsafe_code"]
        # Everything the other lints found is still reported.
        assert {i["type"] for i in degraded} == {i["type"] for i in healthy} - {"unsafe_code"}

    def test_a_roster_iterateOver_is_linted(self):
        """``iterateOver`` is author Python the same sandbox evaluates (#729).

        At fielding, ``flow_processor._prime_roster_pass`` catches the refusal,
        records it as ``informational`` and skips the WHOLE roster pass — so
        nothing error-severity ever reaches the publish gate. The block walk
        originally read only ``precondition``/``postcondition``, which left this
        third code unit on a Block completely unlinted.
        """
        raw = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "Roster",
                "blocks": [
                    {
                        "id": "roster_blk",
                        "kind": "Roster",
                        "title": "Roster",
                        "iterateOver": "3 if math.__dict__ else 1",
                        "items": [
                            {
                                "id": "q_name",
                                "kind": "Question",
                                "title": "Name?",
                                "input": {"control": "Editbox"},
                            }
                        ],
                    }
                ],
            },
        }
        state = QMLState(QMLLoader(schema_path=None).load_from_string(yaml.safe_dump(raw)))
        unsafe = [
            i for i in ValidationProcessor(state).to_issues() if i["type"] == "unsafe_code"
        ]
        assert len(unsafe) == 1, unsafe
        assert unsafe[0]["item_id"] == "roster_blk"
        assert unsafe[0]["severity"] == "error"
        assert "iterateOver" in unsafe[0]["message"]
        # An attribute refusal IS unambiguous, so it keeps the sandbox's words.
        assert "Access to disallowed attribute" in unsafe[0]["message"]

    def test_an_unsafe_codeInit_is_caught(self):
        """`codeInit` runs through the same sandbox and owns no item.

        It is walked by the lint and was covered by nothing: the fixture that
        exercises this lint carries its forbidden construct in an item's
        `codeBlock`, so a regression that dropped the codeInit branch would
        have left every test green.
        """
        raw = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "Unsafe codeInit",
                "codeInit": "import os\nbase = 1\n",
                "blocks": [
                    {
                        "id": "b1",
                        "kind": "Group",
                        "items": [
                            {
                                "id": "q_one",
                                "kind": "Question",
                                "title": "A question",
                                "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                            }
                        ],
                    }
                ],
            },
        }
        loader = QMLLoader(schema_path=None)
        processor = ValidationProcessor(QMLState(loader.load_from_string(_dump_yaml(raw))))
        findings = [i for i in processor.to_issues() if i["type"] == "unsafe_code"]
        assert findings, "an unsafe codeInit must be refused before fielding"
        # The owner is not an item, and that is within the contract: `item_id`
        # is the classification key, not a promise the value names an item.
        assert findings[0]["item_id"] == "codeInit"
        assert "Import" in findings[0]["message"]

    def test_an_unsafe_block_level_predicate_is_caught(self):
        """Block conditions are composed at evaluation time and run in the sandbox.

        They live on the block, not on its items (R25), so a walk over items
        alone would miss them — and a block precondition gates every item
        inside it, which makes it the more consequential of the two.
        """
        raw = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "Unsafe block condition",
                "blocks": [
                    {
                        "id": "b_gated",
                        "kind": "Group",
                        "precondition": [{"predicate": "math.__dict__ == 1"}],
                        "items": [
                            {
                                "id": "q_one",
                                "kind": "Question",
                                "title": "A question",
                                "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                            }
                        ],
                    }
                ],
            },
        }
        loader = QMLLoader(schema_path=None)
        processor = ValidationProcessor(QMLState(loader.load_from_string(_dump_yaml(raw))))
        findings = [i for i in processor.to_issues() if i["type"] == "unsafe_code"]
        assert findings, "an unsafe block-level predicate must be refused"
        assert findings[0]["item_id"] == "b_gated"
        assert "block precondition" in findings[0]["message"]

    def test_a_forbidden_predicate_is_caught_as_well_as_a_body(self):
        """Predicates run through the sandbox too (``eval_expr``).

        The predicate reaches for a member of an allowlisted module rather than
        calling a forbidden function, and that is deliberate: a disallowed CALL
        is suppressed in favour of the name lint (see above), so a test written
        with ``__import__(...)`` would assert the suppression rather than the
        coverage it means to prove.

        Built here rather than committed as a fixture: the corpus guard below
        asserts no committed fixture fires, and a fixture added for this case
        would have to be exempted from it.
        """
        raw = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "Predicate the sandbox refuses",
                "blocks": [
                    {
                        "id": "b1",
                        "kind": "Group",
                        "items": [
                            {
                                "id": "q_one",
                                "kind": "Question",
                                "title": "A question",
                                "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                            },
                            {
                                "id": "q_two",
                                "kind": "Question",
                                "title": "Gated",
                                "precondition": [{"predicate": "math.__dict__ == 1"}],
                                "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                            },
                        ],
                    }
                ],
            },
        }
        loader = QMLLoader(schema_path=None)
        processor = ValidationProcessor(QMLState(loader.load_from_string(_dump_yaml(raw))))
        findings = [i for i in processor.to_issues() if i["type"] == "unsafe_code"]
        assert findings, "a predicate the sandbox refuses must be an error before fielding"
        assert findings[0]["item_id"] == "q_two"
        assert "precondition" in findings[0]["message"]


@pytest.mark.integration
class TestUnsafeCodeLintFiresOnNothingElse:
    """The corpus sweep, because a false positive here blocks publishing.

    ``publish_gate`` refuses any error-severity finding, so a lint that misjudged
    one legitimate predicate would make an existing questionnaire unpublishable
    — fleet-wide, and only discovered by the researcher it stopped.

    Measured before this shipped: of 49 committed fixtures, 48 parse and 46 of
    those are clean; and on the live dev corpus (74 head QML versions, 30 of
    which declare an ``iterateOver``) the lint fires on NONE. The second half of
    that measurement is the one that matters — no stored questionnaire becomes
    unpublishable — and it cannot be pinned by a test, so this pins the fixture
    half and the number above records the rest.
    """

    #: The committed fixtures that may fire; anything else is a false positive.
    #: ``defect_unsupported_python.qml`` carries constructs the sandbox refuses.
    #: ``malformed_precondition.qml`` calls ``undefined_function(...)``, which the
    #: sandbox genuinely refuses at fielding — it fires because no suppression
    #: hides it any more, and it already carried an error-severity
    #: ``undefined_name``, so the publish gate's verdict on it is unchanged.
    EXPECTED = {"defect_unsupported_python.qml", "malformed_precondition.qml"}

    #: The only fixture that does not parse — it exists to BE unparseable, so it
    #: never reaches this lint. Named rather than caught, because a blanket
    #: ``except: continue`` cannot tell it from a fixture the sweep has silently
    #: stopped measuring: a loader regression would drop the corpus to a handful
    #: and the sweep would still report success.
    DOES_NOT_PARSE = {"defect_syntax_error.qml"}

    def test_no_other_committed_fixture_is_refused(self):
        loader = QMLLoader(schema_path=None)
        fixtures = sorted(FIXTURES_DIR.glob("*.qml"))
        firing, swept = set(), 0
        for path in fixtures:
            try:
                processor = ValidationProcessor(QMLState(loader.load_from_path(str(path))))
                issues = processor.to_issues()
            except Exception as exc:
                if path.name in self.DOES_NOT_PARSE:
                    continue
                raise AssertionError(
                    f"{path.name} dropped out of the sweep: {type(exc).__name__}: {exc}. "
                    f"Either it is newly unparseable, or the sweep has stopped measuring it."
                ) from exc
            swept += 1
            if any(i["type"] == "unsafe_code" for i in issues):
                firing.add(path.name)
        # Exact, not a floor: every fixture is either swept or named above.
        assert swept == len(fixtures) - len(self.DOES_NOT_PARSE), (
            f"swept {swept} of {len(fixtures)} fixtures"
        )
        assert firing == self.EXPECTED, f"unexpected refusals: {firing - self.EXPECTED}"
