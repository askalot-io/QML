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
from pathlib import Path
from typing import Any

import pytest
import yaml
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
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
