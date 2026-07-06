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
- Parity: ``to_issues()`` reproduces, byte-for-byte, the issues list that
  Portor's MCP ``_run_validation`` built inline before the policy moved into
  this module — asserted by replaying a verbatim copy of that pre-move mapping
  against the same classifications across a set of fixture QMLs. The undefined_name
  issue type is a U1 addition on top of that mapping; the parity fixtures are
  phantom-free, so the new branch never fires on them and parity is preserved.
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
- Publish gate (``evaluate_publish_gate``): the shared soundness gate for every
  publish door — passes clean and warning-only files, blocks on error-severity
  issues, and fails closed (file_not_found / load_error) when the file cannot
  be loaded or analyzed at all.

These integration tests run the real Z3 classification pipeline against the
thesis/matrix fixtures, so they exercise the actual classification shapes the
mapping consumes (not hand-built dicts) and lock the MCP issue contract.
"""

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
PARITY_FIXTURES = [
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


def _legacy_run_validation_issues(classifications: dict[str, Any]) -> list[dict[str, Any]]:
    """Verbatim copy of Portor _run_validation's pre-move issue mapping.

    Reproduces the exact inline loop that lived in
    services/tenant/portor/app/mcp_tools/qml_validation_tools.py before U3
    extracted it into ValidationProcessor.to_issues(). The parity test asserts
    to_issues() produces an identical list for the same classifications — any
    divergence in severity, type, message, or suggestion is a behavior change.
    """
    issues: list[dict[str, Any]] = []
    for item_id, classification in classifications.items():
        pre_status = classification.get("precondition", {}).get("status", "UNKNOWN")
        post_invariant = classification.get("postcondition", {}).get("invariant", "UNKNOWN")
        post_vacuous = classification.get("postcondition", {}).get("vacuous", False)
        post_global = classification.get("postcondition", {}).get("global", {})

        if pre_status == "NEVER":
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "error",
                    "type": "unreachable_item",
                    "message": f"Item '{item_id}' is unreachable (precondition is never satisfiable).",
                    "suggestion": (
                        f"Check the precondition of '{item_id}'. It may reference "
                        f"variables that can never have the required values, or it may "
                        f"depend on items that set contradictory conditions."
                    ),
                }
            )

        if post_invariant == "INFEASIBLE":
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "error",
                    "type": "infeasible_postcondition",
                    "message": f"Item '{item_id}' has an infeasible postcondition (contradicts global constraints).",
                    "suggestion": (
                        f"The postcondition of '{item_id}' cannot be satisfied given "
                        f"the control's domain constraints (min/max, allowed values). "
                        f"Review the validation rule or control configuration."
                    ),
                }
            )

        if post_global.get("q_globally_false"):
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "error",
                    "type": "globally_false_postcondition",
                    "message": f"Item '{item_id}' has a postcondition that is always false.",
                    "suggestion": (
                        f"The postcondition of '{item_id}' can never be true for any "
                        f"valid response. Remove it or fix the validation logic."
                    ),
                }
            )

        if post_invariant == "TAUTOLOGICAL":
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "warning",
                    "type": "tautological_postcondition",
                    "message": f"Item '{item_id}' has a tautological postcondition (always true, redundant).",
                    "suggestion": (
                        f"The postcondition of '{item_id}' is always satisfied. "
                        f"It can be safely removed unless it serves as documentation."
                    ),
                }
            )

        if post_vacuous and pre_status == "NEVER":
            issues.append(
                {
                    "item_id": item_id,
                    "severity": "warning",
                    "type": "vacuous_postcondition",
                    "message": f"Item '{item_id}' has a vacuous postcondition (item is never reached).",
                    "suggestion": (
                        f"The postcondition of '{item_id}' is technically valid but "
                        f"the item is never reached, so it has no effect."
                    ),
                }
            )

        for gap in classification.get("coverage_gaps", []) or []:
            if gap.get("kind") != "group_dependency":
                continue
            block_id = gap["block_id"]
            dependant = gap["item_id"]
            depends_on = gap["depends_on"]
            issues.append(
                {
                    "item_id": block_id,
                    "severity": "error",
                    "type": "group_dependency",
                    "message": (
                        f"Capped Group '{block_id}': inner item '{dependant}' depends "
                        f"on sibling inner item '{depends_on}'. Inner items of a "
                        f"count-capped Group must be independent — the draw can leave "
                        f"'{depends_on}' undrawn, so '{dependant}' may evaluate against "
                        f"a None outcome."
                    ),
                    "suggestion": (
                        f"Move '{dependant}' or '{depends_on}' to a separate block, or "
                        f"remove the 'count' cap so the Group asks every inner item."
                    ),
                }
            )
    return issues


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
        for fixture in PARITY_FIXTURES:
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
        for fixture in PARITY_FIXTURES:
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
class TestToIssuesPortorParity:
    """Behavior-preservation: to_issues() == Portor's pre-move inline mapping."""

    @pytest.mark.parametrize("fixture", PARITY_FIXTURES)
    def test_to_issues_matches_legacy_portor_mapping(self, fixture):
        """to_issues() reproduces _run_validation's pre-move issues, byte-for-byte.

        Both consume the SAME classifications object, so any difference is in the
        mapping policy itself, not in Z3 nondeterminism.
        """
        processor = _processor(fixture)
        classifications = processor.get_item_classifications()

        expected = _legacy_run_validation_issues(classifications)
        actual = processor.to_issues()

        assert actual == expected, (
            f"{fixture}: to_issues() diverged from Portor's pre-move mapping"
        )


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
    """evaluate_publish_gate — the shared soundness gate every publish door runs.

    The gate blocks on error-severity issues only (warnings pass), and fails
    CLOSED on anything that prevents analysis (missing file, YAML/schema
    failure) — a structurally broken work-in-progress file is saveable but
    never publishable.
    """

    @staticmethod
    def _write_qml(tmp_path: Path, name: str, doc: dict[str, Any]) -> None:
        (tmp_path / name).write_text(yaml.safe_dump(doc), encoding="utf-8")

    # Documents below use the on-disk QML DOCUMENT shape (qmlVersion +
    # nested questionnaire.blocks[].items[]) — the gate runs the real
    # QMLLoader, unlike the flattened dicts the other classes feed
    # ValidationProcessor directly.
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

    def test_clean_file_passes(self, tmp_path):
        from askalot_qml.core import evaluate_publish_gate

        self._write_qml(tmp_path, "clean.qml", self._CLEAN_DOC)
        result = evaluate_publish_gate(tmp_path, "clean.qml")
        assert result.ok, f"clean QML must pass the gate; issues: {result.issues}"
        assert result.errors == []

    def test_phantom_name_blocks(self, tmp_path):
        from askalot_qml.core import evaluate_publish_gate

        doc = {
            "qmlVersion": "2.0",
            "questionnaire": {
                "title": "publish gate phantom",
                "blocks": [
                    {
                        "id": "b",
                        "kind": "Group",
                        "title": "B",
                        "items": [
                            {
                                "id": "q_a",
                                "kind": "Question",
                                "title": "Gated on a phantom",
                                "input": {"control": "Editbox", "min": 0, "max": 10},
                                "precondition": [{"predicate": "phantom_flag == 1"}],
                            }
                        ],
                    }
                ],
            },
        }
        self._write_qml(tmp_path, "phantom.qml", doc)
        result = evaluate_publish_gate(tmp_path, "phantom.qml")
        assert not result.ok
        assert any(i["type"] == "undefined_name" for i in result.errors), result.errors

    def test_warnings_only_passes(self, tmp_path):
        from askalot_qml.core import evaluate_publish_gate

        # write-only variable → hygiene warning, must NOT block publication
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
        self._write_qml(tmp_path, "warn.qml", doc)
        result = evaluate_publish_gate(tmp_path, "warn.qml")
        assert result.ok, f"warning-only findings must pass the gate; got {result.errors}"
        assert any(i["severity"] == "warning" for i in result.issues)

    def test_missing_file_fails_closed(self, tmp_path):
        from askalot_qml.core import evaluate_publish_gate

        result = evaluate_publish_gate(tmp_path, "nope.qml")
        assert not result.ok
        assert result.errors[0]["type"] == "file_not_found"

    def test_unparseable_yaml_fails_closed(self, tmp_path):
        from askalot_qml.core import evaluate_publish_gate

        (tmp_path / "broken.qml").write_text(
            "title: [unclosed\nitems: - half a sketch:\n", encoding="utf-8"
        )
        result = evaluate_publish_gate(tmp_path, "broken.qml")
        assert not result.ok
        assert result.errors[0]["type"] == "load_error"

    def test_schema_invalid_fails_closed(self, tmp_path):
        from askalot_qml.core import evaluate_publish_gate

        # parses as YAML but violates the QML JSON schema (blocks not a list)
        self._write_qml(
            tmp_path,
            "schema.qml",
            {"qmlVersion": "2.0", "questionnaire": {"title": "bad", "blocks": {"not": "a list"}}},
        )
        result = evaluate_publish_gate(tmp_path, "schema.qml")
        assert not result.ok
        assert result.errors[0]["type"] == "load_error"
