#!/usr/bin/env python3
"""Unit tests for Roster + Sample schema validation and loader propagation.

This file covers two plans' loader-side U1 deliverables:

* Roster — docs/plans/2026-05-04-001-feat-roster-block-plan.md (original scope).
* Sample — docs/plans/2026-05-17-001-feat-sample-block-kind-aware-z3-plan.md,
  U1. Sample is now a first-class loadable kind (no longer reserved). The
  Sample cases live here (not a sibling file) per the repo CLAUDE.md
  "Test Placement — Existing Files First" rule: the loader acceptance +
  `_propagate_block_inheritance` surface is the same component the Roster
  cases already exercise.

  **Schema-spelling decision (settled in U1):** the Sample count attribute is
  spelled ``count`` (not ``n``) — consistent with the schema's existing
  descriptive lowercase names (``iterateOver``, ``labels``, ``maxEntries``)
  rather than a single letter. ``count`` is **mandatory** for Sample blocks
  (schema ``allOf if/then`` ``required`` + a loud loader re-check; no silent
  default — monorepo "No Silent Fallbacks" rule). ``is_random`` is
  **optional**, schema-defaulted to ``false`` when omitted. Inner items carry
  ``_sample_block_id`` / ``_sample_n`` / ``_sample_is_random``, mirroring the
  Roster ``_roster_*`` tag family.

This test suite verifies the U1 deliverable from the Roster plan
(docs/plans/2026-05-04-001-feat-roster-block-plan.md):

  1. Schema accepts `kind: Roster` blocks with the required `iterateOver`
     (string expression) and `labels` (power-of-2 keyed map).
  2. Schema rejects Roster missing `iterateOver` / `labels` and rejects
     forbidden v1 fields (`as`, `maxEntries`).
  3. Loader rejects non-power-of-2 keys on Roster `labels` and on
     Checkbox `input.labels` (forward-tightening — see Key Technical
     Decisions; Checkbox outcome is the bitmask sum of selected keys, so
     each key must occupy a unique bit position so the outcome can flow
     directly into a sibling Roster's `iterateOver`).
  4. Loader rejects `iterateOver` expressions referencing items that live
     inside the same Roster (self-cycle prevention).
  5. Loader propagates `_roster_block_id`, `_roster_iterate_over`, and
     `_roster_labels` onto every child item of a Roster so downstream
     consumers (FlowProcessor, Z3 dependency wiring, Bronze schema build)
     can detect roster items without re-walking the block tree.
  6. Block-level `precondition` and `postcondition` are allowed on both
     Block and Roster. They live ONLY on the block object — the loader
     does NOT copy them onto items (R25, 2026-05-14). Downstream
     consumers (FlowProcessor for runtime, StaticBuilder for Z3) compose
     block + item conditions at evaluation time; the diagram emitter
     renders block chiclets on the block and item chiclets on the item.
     Items never gain `_source`, `_block_id`, `_block_precondition_count`
     or `_block_postcondition_count` markers.
  7. Backward compatibility: existing fixtures without `kind` on Block
     continue to validate unchanged (no-op for the existing fixture suite).

## Coverage areas

- Happy-path schema acceptance (Roster + plain Block + explicit kind=Block)
- Required-field rejection (iterateOver, labels)
- Forbidden-field rejection (as, maxEntries)
- Power-of-2 enforcement on Roster labels (and edge cases: 0, negative, 3)
- Power-of-2 enforcement on Checkbox labels (forward-tightening rule)
- Self-cycle rejection on iterateOver
- Roster metadata propagation onto inner items
- Block postcondition propagation (symmetric to precondition)
- Existing fixtures continue to load unchanged

The fixtures live under tests/fixtures/ for reuse by U3/U6/U7/U9 integration
tests; U1 tests reference them by short YAML strings (load_from_string)
because the canonical fixture files are introduced wholesale in U9.
"""

import pytest
from askalot_qml.core.qml_loader import QMLLoader
from jsonschema import ValidationError

# ---------------------------------------------------------------------------
# YAML test fixtures (inline — canonical .qml files arrive in U9)
# ---------------------------------------------------------------------------

VALID_ROSTER_NUMERIC = """
qmlVersion: "1.0"
questionnaire:
  title: "Family Roster"
  blocks:
    - id: count_block
      kind: Sequence
      items:
        - id: q_family_count
          kind: Question
          title: "How many family members?"
          input:
            control: Editbox
            min: 1
            max: 4
          codeBlock: |
            family_mask = 2 ** q_family_count.outcome - 1
    - id: per_member
      kind: Roster
      title: "Family member details"
      iterateOver: "family_mask"
      labels:
        1: "Member 1"
        2: "Member 2"
        4: "Member 3"
        8: "Member 4"
      items:
        - id: q_member_name
          kind: Question
          title: "Name?"
          input:
            control: Editbox
            min: 0
            max: 100
        - id: q_member_age
          kind: Question
          title: "Age?"
          input:
            control: Editbox
            min: 0
            max: 120
"""


VALID_ROSTER_MULTISELECT = """
qmlVersion: "1.0"
questionnaire:
  title: "Daily Meal Tracker"
  blocks:
    - id: meal_selection
      kind: Sequence
      items:
        - id: q_meals_eaten
          kind: Question
          title: "Which meals did you eat today?"
          input:
            control: Checkbox
            labels:
              1: "Breakfast"
              2: "Lunch"
              4: "Dinner"
              8: "Snack"
    - id: per_meal
      kind: Roster
      iterateOver: "q_meals_eaten.outcome"
      labels:
        1: "Breakfast"
        2: "Lunch"
        4: "Dinner"
        8: "Snack"
      items:
        - id: q_satisfaction
          kind: Question
          title: "How satisfied were you?"
          input:
            control: Slider
            min: 1
            max: 5
"""


PLAIN_SEQUENCE_BLOCK = """
qmlVersion: "1.0"
questionnaire:
  title: "Plain"
  blocks:
    - id: b1
      kind: Sequence
      items:
        - id: q1
          kind: Question
          title: "Anything?"
          input:
            control: Editbox
            min: 0
            max: 10
"""


def _make_qml(roster_block_yaml: str) -> str:
    """Wrap one or more block YAML fragments into a complete questionnaire.

    Each block fragment in `roster_block_yaml` must declare its own `kind`
    (Sequence or Roster) — `kind` is mandatory after the 2026-05-05 schema
    change.
    """
    return f"""
qmlVersion: "1.0"
questionnaire:
  title: "Test"
  blocks:
{roster_block_yaml}
"""


# ---------------------------------------------------------------------------
# Schema acceptance — happy paths
# ---------------------------------------------------------------------------


class TestSchemaAcceptance:
    """Schema accepts the canonical Roster shape and stays backward-compatible."""

    def test_valid_roster_numeric_loads(self):
        loader = QMLLoader()
        result = loader.load_from_string(VALID_ROSTER_NUMERIC)
        # Two blocks (count_block, per_member); 3 items total flattened.
        assert len(result["blocks"]) == 2
        assert len(result["items"]) == 3
        per_member = next(b for b in result["blocks"] if b["id"] == "per_member")
        assert per_member["kind"] == "Roster"
        assert per_member["iterateOver"] == "family_mask"
        assert per_member["labels"] == {1: "Member 1", 2: "Member 2", 4: "Member 3", 8: "Member 4"}

    def test_valid_roster_multiselect_loads(self):
        loader = QMLLoader()
        result = loader.load_from_string(VALID_ROSTER_MULTISELECT)
        per_meal = next(b for b in result["blocks"] if b["id"] == "per_meal")
        assert per_meal["kind"] == "Roster"
        # Checkbox label keys are also powers of 2 — forward-tightening passes.
        q_meals = next(i for i in result["items"] if i["id"] == "q_meals_eaten")
        assert q_meals["input"]["labels"] == {1: "Breakfast", 2: "Lunch", 4: "Dinner", 8: "Snack"}

    def test_explicit_sequence_kind_loads(self):
        """`kind: Sequence` is the explicit form of the default block kind."""
        loader = QMLLoader()
        result = loader.load_from_string(PLAIN_SEQUENCE_BLOCK)
        assert result["blocks"][0]["kind"] == "Sequence"

    def test_block_without_kind_is_rejected(self):
        """`kind` is mandatory after the 2026-05-05 schema change."""
        # NOTE: this YAML deliberately omits `kind` on b1 — that's the SUT.
        yaml_str = """
qmlVersion: "1.0"
questionnaire:
  title: "Legacy"
  blocks:
    - id: b1
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
"""
        # Schema-level rejection (kind in Block.required) OR loader-level rejection
        # (defense in depth in _validate_block_kinds). Either is acceptable.
        with pytest.raises((ValidationError, ValueError)):
            QMLLoader().load_from_string(yaml_str)

    def test_sample_kind_is_now_supported(self):
        """`Sample` is a first-class loadable kind as of plan 2026-05-17-001
        U1 — it must NOT raise NotImplementedError anymore (regression guard
        against the old reserved-kind rejection)."""
        for is_random_clause in ("", "      is_random: false\n", "      is_random: true\n"):
            yaml_str = _make_qml(f"""
    - id: b1
      kind: Sample
      count: 1
{is_random_clause}      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
""")
            # Must not raise — Sample loads cleanly.
            result = QMLLoader().load_from_string(yaml_str)
            assert result["blocks"][0]["kind"] == "Sample"

    def test_single_label_roster_loads(self):
        """Degenerate-but-valid Roster with a single label key."""
        yaml_str = _make_qml("""
    - id: outer
      kind: Sequence
      items:
        - id: q_count
          kind: Question
          title: "?"
          input:
            control: Editbox
            min: 1
            max: 1
          codeBlock: "mask = 1"
    - id: lonely
      kind: Roster
      iterateOver: "mask"
      labels:
        1: "Only"
      items:
        - id: q_lonely
          kind: Question
          title: "Only one"
          input:
            control: Editbox
            min: 0
            max: 1
""")
        loader = QMLLoader()
        result = loader.load_from_string(yaml_str)
        lonely = next(b for b in result["blocks"] if b["id"] == "lonely")
        assert lonely["labels"] == {1: "Only"}


# ---------------------------------------------------------------------------
# Schema rejection — required fields and forbidden v1 fields
# ---------------------------------------------------------------------------


class TestSchemaRejection:
    """Schema-level rejection of malformed Rosters."""

    def test_rejects_roster_without_iterateover(self):
        yaml_str = _make_qml("""
    - id: bad
      kind: Roster
      labels:
        1: "A"
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 1
""")
        with pytest.raises(ValidationError):
            QMLLoader().load_from_string(yaml_str)

    def test_rejects_roster_without_labels(self):
        yaml_str = _make_qml("""
    - id: bad
      kind: Roster
      iterateOver: "1"
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 1
""")
        with pytest.raises(ValidationError):
            QMLLoader().load_from_string(yaml_str)

    def test_rejects_roster_with_as_field(self):
        """`as:` iterator-variable binding is dropped in v1."""
        yaml_str = _make_qml("""
    - id: bad
      kind: Roster
      iterateOver: "1"
      labels:
        1: "A"
      as: member
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 1
""")
        with pytest.raises(ValidationError):
            QMLLoader().load_from_string(yaml_str)

    def test_rejects_roster_with_maxentries_field(self):
        """`maxEntries` is superseded by `labels` (the universe of iterations)."""
        yaml_str = _make_qml("""
    - id: bad
      kind: Roster
      iterateOver: "1"
      labels:
        1: "A"
      maxEntries: 4
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 1
""")
        with pytest.raises(ValidationError):
            QMLLoader().load_from_string(yaml_str)

    def test_rejects_unknown_block_kind(self):
        yaml_str = _make_qml("""
    - id: bad
      kind: MagicBlock
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 1
""")
        with pytest.raises(ValidationError):
            QMLLoader().load_from_string(yaml_str)


# ---------------------------------------------------------------------------
# Loader-level Roster validation: power-of-2 + self-cycle
# ---------------------------------------------------------------------------


class TestLoaderRosterValidation:
    """Loader rejects bad label keys and self-cycles with author-actionable errors."""

    @pytest.mark.parametrize(
        "bad_keys,offending",
        [
            ({1: "A", 2: "B", 3: "C"}, 3),  # 3 is not a power of 2
            ({1: "A", 5: "B"}, 5),
            ({0: "A"}, 0),  # 0 fails k > 0
        ],
    )
    def test_rejects_non_power_of_two_label_keys(self, bad_keys, offending):
        labels_yaml = "\n".join(f"        {k}: {v!r}" for k, v in bad_keys.items())
        yaml_str = _make_qml(f"""
    - id: outer
      kind: Sequence
      items:
        - id: q_outer
          kind: Question
          title: "?"
          input:
            control: Editbox
            min: 0
            max: 10
          codeBlock: "mask = 1"
    - id: bad
      kind: Roster
      iterateOver: "mask"
      labels:
{labels_yaml}
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 1
""")
        with pytest.raises(ValueError) as exc:
            QMLLoader().load_from_string(yaml_str)
        # Error message must name the offending key for author debuggability.
        assert str(offending) in str(exc.value)
        assert "Roster block 'bad'" in str(exc.value)

    def test_rejects_self_cycle_in_iterateover(self):
        """iterateOver referencing an inner item id is a self-cycle."""
        yaml_str = _make_qml("""
    - id: bad
      kind: Roster
      iterateOver: "q_inner.outcome"
      labels:
        1: "A"
      items:
        - id: q_inner
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 7
""")
        with pytest.raises(ValueError) as exc:
            QMLLoader().load_from_string(yaml_str)
        assert "q_inner" in str(exc.value)
        assert "self-reference" in str(exc.value).lower() or "cycle" in str(exc.value).lower()

    def test_outside_reference_in_iterateover_is_fine(self):
        """Referencing an outside item is the normal case — must not raise."""
        # VALID_ROSTER_MULTISELECT does exactly this (q_meals_eaten is outside per_meal).
        QMLLoader().load_from_string(VALID_ROSTER_MULTISELECT)


# ---------------------------------------------------------------------------
# Checkbox forward-tightening
# ---------------------------------------------------------------------------


class TestCheckboxPowerOfTwoTightening:
    """Checkbox label keys must be powers of 2 (aligns with Roster iterateOver)."""

    def test_checkbox_with_power_of_two_keys_loads(self):
        yaml_str = _make_qml("""
    - id: b1
      kind: Sequence
      items:
        - id: q_meals
          kind: Question
          title: "Meals"
          input:
            control: Checkbox
            labels:
              1: "B"
              2: "L"
              4: "D"
              8: "S"
""")
        result = QMLLoader().load_from_string(yaml_str)
        assert result["items"][0]["input"]["labels"] == {1: "B", 2: "L", 4: "D", 8: "S"}

    @pytest.mark.parametrize(
        "bad_keys,offending",
        [
            ({1: "A", 2: "B", 3: "C"}, 3),
            ({1: "A", 2: "B", 4: "C", 7: "D"}, 7),
            ({0: "A"}, 0),
        ],
    )
    def test_checkbox_with_non_power_of_two_keys_rejected(self, bad_keys, offending):
        labels_yaml = "\n".join(f"              {k}: {v!r}" for k, v in bad_keys.items())
        yaml_str = _make_qml(f"""
    - id: b1
      kind: Sequence
      items:
        - id: q_bad_checkbox
          kind: Question
          title: "Q"
          input:
            control: Checkbox
            labels:
{labels_yaml}
""")
        with pytest.raises(ValueError) as exc:
            QMLLoader().load_from_string(yaml_str)
        assert str(offending) in str(exc.value)
        assert "q_bad_checkbox" in str(exc.value)

    def test_radio_with_sequential_keys_unaffected(self):
        """The tightening is Checkbox-only; Radio keeps sequential-key freedom."""
        yaml_str = _make_qml("""
    - id: b1
      kind: Sequence
      items:
        - id: q_radio
          kind: Question
          title: "Pick one"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Maybe"
""")
        # Should not raise — Radio is unaffected by the Checkbox rule.
        QMLLoader().load_from_string(yaml_str)


# ---------------------------------------------------------------------------
# Roster metadata propagation onto child items
# ---------------------------------------------------------------------------


class TestRosterMetadataPropagation:
    """Inner items of a Roster carry _roster_* tags after flatten."""

    def test_inner_items_carry_roster_tags(self):
        result = QMLLoader().load_from_string(VALID_ROSTER_NUMERIC)
        roster_items = [i for i in result["items"] if i.get("blockId") == "per_member"]
        assert len(roster_items) == 2

        for item in roster_items:
            assert item["_roster_block_id"] == "per_member"
            assert item["_roster_iterate_over"] == "family_mask"
            assert item["_roster_labels"] == {
                1: "Member 1",
                2: "Member 2",
                4: "Member 3",
                8: "Member 4",
            }

    def test_non_roster_items_have_no_roster_tags(self):
        result = QMLLoader().load_from_string(VALID_ROSTER_NUMERIC)
        non_roster = [i for i in result["items"] if i.get("blockId") == "count_block"]
        assert len(non_roster) == 1
        item = non_roster[0]
        assert "_roster_block_id" not in item
        assert "_roster_iterate_over" not in item
        assert "_roster_labels" not in item

    def test_block_metadata_preserves_kind_iterateover_labels(self):
        """state['blocks'] retains the original Roster metadata for reverse lookup."""
        result = QMLLoader().load_from_string(VALID_ROSTER_NUMERIC)
        per_member = next(b for b in result["blocks"] if b["id"] == "per_member")
        assert per_member["kind"] == "Roster"
        assert per_member["iterateOver"] == "family_mask"
        assert per_member["labels"] == {1: "Member 1", 2: "Member 2", 4: "Member 3", 8: "Member 4"}


# ---------------------------------------------------------------------------
# Block-level postcondition propagation (symmetric with precondition)
# ---------------------------------------------------------------------------


class TestBlockPostconditionPropagation:
    """Block postcondition stays on the block object (R25 — no merge into items)."""

    def test_block_postcondition_stays_on_block(self):
        """Block conditions live on the block; items keep only their own
        conditions. Downstream consumers (FlowProcessor, StaticBuilder)
        compose them at use time."""
        yaml_str = """
qmlVersion: "1.0"
questionnaire:
  title: "Block postcondition"
  blocks:
    - id: b1
      kind: Sequence
      postcondition:
        - predicate: "q1.outcome > 0"
          hint: "Block-level rule"
      items:
        - id: q1
          kind: Question
          title: "Q1"
          input:
            control: Editbox
            min: -5
            max: 10
          postcondition:
            - predicate: "q1.outcome < 100"
              hint: "Item-level rule"
        - id: q2
          kind: Question
          title: "Q2"
          input:
            control: Editbox
            min: 0
            max: 10
"""
        result = QMLLoader().load_from_string(yaml_str)
        items_by_id = {i["id"]: i for i in result["items"]}
        blocks_by_id = {b["id"]: b for b in result["blocks"]}

        # Block's postcondition stays where it was authored.
        b1 = blocks_by_id["b1"]
        assert b1["postcondition"] == [{"predicate": "q1.outcome > 0", "hint": "Block-level rule"}]

        # q1 has ONLY its own postcondition — no prepended block entry.
        q1 = items_by_id["q1"]
        assert q1["postcondition"] == [{"predicate": "q1.outcome < 100", "hint": "Item-level rule"}]
        # No legacy markers on the item.
        assert "_block_postcondition_count" not in q1
        assert all("_source" not in c for c in q1.get("postcondition", []))

        # q2 declares no postcondition of its own — and inherits no marker
        # either. The block carries its rule; consumers compose at use time.
        q2 = items_by_id["q2"]
        assert q2.get("postcondition", []) == []
        assert "_block_postcondition_count" not in q2

    def test_roster_block_can_carry_postcondition(self):
        """Roster postconditions also stay on the roster block; only the
        roster markers (_roster_block_id etc.) propagate onto items."""
        yaml_str = _make_qml("""
    - id: outer
      kind: Sequence
      items:
        - id: q_count
          kind: Question
          title: "?"
          input:
            control: Editbox
            min: 1
            max: 4
          codeBlock: "mask = 2 ** q_count.outcome - 1"
    - id: per_thing
      kind: Roster
      iterateOver: "mask"
      labels:
        1: "A"
        2: "B"
      postcondition:
        - predicate: "q_thing.outcome >= 0"
          hint: "Roster-level rule"
      items:
        - id: q_thing
          kind: Question
          title: "Thing"
          input:
            control: Editbox
            min: 0
            max: 100
""")
        result = QMLLoader().load_from_string(yaml_str)
        roster_block = next(b for b in result["blocks"] if b["id"] == "per_thing")
        q_thing = next(i for i in result["items"] if i["id"] == "q_thing")

        # Roster-level postcondition stays on the roster block.
        assert roster_block["postcondition"] == [
            {"predicate": "q_thing.outcome >= 0", "hint": "Roster-level rule"}
        ]
        # Item has no prepended block postcondition or count marker.
        assert q_thing.get("postcondition", []) == []
        assert "_block_postcondition_count" not in q_thing
        # Roster metadata still propagates onto inner items.
        assert q_thing["_roster_block_id"] == "per_thing"

    def test_block_without_postcondition_leaves_item_postconditions_alone(self):
        """No postcondition on block → items still don't get marker fields
        (the loader never injected them on a no-op block either)."""
        result = QMLLoader().load_from_string(VALID_ROSTER_NUMERIC)
        for item in result["items"]:
            assert "_block_postcondition_count" not in item
            assert all("_source" not in c for c in item.get("postcondition", []))


# ---------------------------------------------------------------------------
# Backward compatibility: existing fixtures still load
# ---------------------------------------------------------------------------


class TestExistingFixturesUnchanged:
    """
    All shipped fixtures must continue to flow through the loader unchanged.

    Two notes on fixture state (audited 2026-05-05):
      * Most fixtures predate the schema's `qmlVersion` requirement and the
        `RadioButton`-vs-`Radio` enum tightening. They are intentionally loaded
        with `schema_path=None` by the existing test suites that use them.
      * This test mirrors that reality — we verify the fixtures still parse +
        flatten correctly with the new loader (Roster additions are purely
        additive on legacy blocks: kind absent → no _roster_* tags emitted).

    The two fixtures that DO carry `qmlVersion` (codeblock_postcondition.qml,
    thesis_driving_experience.qml) are also exercised through the schema path
    to confirm the schema additions don't reject them.
    """

    LEGACY_FIXTURES = [
        "basic.qml",
        "block_preconditions.qml",
        "branching_flow.qml",
        "classification.qml",
        "cycles.qml",
        "dependencies.qml",
        "scoring.qml",
    ]

    SCHEMA_VALID_FIXTURES = [
        "codeblock_postcondition.qml",
        "thesis_driving_experience.qml",
    ]

    @pytest.mark.parametrize("fixture_name", LEGACY_FIXTURES + SCHEMA_VALID_FIXTURES)
    def test_legacy_fixture_flattens_unchanged(self, fixture_name):
        """Schema bypassed — proves the flatten path is unchanged for legacy QML."""
        from pathlib import Path

        fixtures_dir = Path(__file__).parent.parent.parent / "fixtures"
        loader = QMLLoader(qml_dir=fixtures_dir, schema_path=None)
        result = loader.load_from_file(fixture_name)

        # No legacy fixture is a Roster — none of its items should carry roster tags.
        for item in result.get("items", []):
            assert "_roster_block_id" not in item
            assert "_roster_iterate_over" not in item
            assert "_roster_labels" not in item

    @pytest.mark.parametrize("fixture_name", SCHEMA_VALID_FIXTURES)
    def test_schema_valid_fixture_passes_schema(self, fixture_name):
        """Schema-valid fixtures still pass — the new Roster allOf branch is gated on `kind: Roster`."""
        from pathlib import Path

        fixtures_dir = Path(__file__).parent.parent.parent / "fixtures"
        loader = QMLLoader(qml_dir=fixtures_dir)  # default schema
        loader.load_from_file(fixture_name)


# ---------------------------------------------------------------------------
# Sample block — plan 2026-05-17-001 U1
#
# Schema-spelling decision (settled here): the count attribute is `count`
# (mandatory, no default) and `is_random` is optional → defaults false.
# Inner items carry _sample_block_id / _sample_n / _sample_is_random.
# ---------------------------------------------------------------------------


SAMPLE_BASIC = """
qmlVersion: "1.0"
questionnaire:
  title: "Sample Basic"
  blocks:
    - id: brand_sample
      kind: Sample
      title: "Brand impressions"
      count: 2
      is_random: true
      items:
        - id: q_brand_a
          kind: Question
          title: "Rate brand A"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_brand_b
          kind: Question
          title: "Rate brand B"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_brand_c
          kind: Question
          title: "Rate brand C"
          input:
            control: Slider
            min: 1
            max: 5
"""


class TestSampleSchemaAndLoaderAcceptance:
    """Sample loads with `count` + `is_random`; inner items carry _sample_* tags."""

    def test_sample_block_with_count_and_is_random_loads(self):
        """Happy path — Sample with count + is_random loads; inner items
        carry _sample_block_id / _sample_n / _sample_is_random."""
        result = QMLLoader().load_from_string(SAMPLE_BASIC)
        block = next(b for b in result["blocks"] if b["id"] == "brand_sample")
        assert block["kind"] == "Sample"
        assert block["count"] == 2
        assert block["is_random"] is True

        inner = [i for i in result["items"] if i.get("blockId") == "brand_sample"]
        assert len(inner) == 3
        for item in inner:
            assert item["_sample_block_id"] == "brand_sample"
            assert item["_sample_n"] == 2
            assert item["_sample_is_random"] is True

    def test_is_random_omitted_defaults_false(self):
        """Edge case — `is_random` omitted ⇒ propagated tag is False
        (the U1-chosen rule: is_random is optional, default false)."""
        yaml_str = _make_qml("""
    - id: s1
      kind: Sample
      count: 1
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
""")
        result = QMLLoader().load_from_string(yaml_str)
        q1 = next(i for i in result["items"] if i["id"] == "q1")
        assert q1["_sample_is_random"] is False
        assert q1["_sample_n"] == 1

    def test_n_larger_than_item_count_loads(self):
        """AE1 (loader side) — count greater than the number of inner items
        loads fine; the runtime "ask up to N" clamp is a U5 concern."""
        yaml_str = _make_qml("""
    - id: s1
      kind: Sample
      count: 9
      items:
        - id: q1
          kind: Question
          title: "Q1"
          input:
            control: Editbox
            min: 0
            max: 10
        - id: q2
          kind: Question
          title: "Q2"
          input:
            control: Editbox
            min: 0
            max: 10
""")
        result = QMLLoader().load_from_string(yaml_str)
        block = next(b for b in result["blocks"] if b["id"] == "s1")
        assert block["count"] == 9
        assert len([i for i in result["items"] if i.get("blockId") == "s1"]) == 2

    def test_sample_fixtures_load(self):
        """The three canonical fixtures load and flatten with _sample_* tags."""
        from pathlib import Path

        fixtures_dir = Path(__file__).parent.parent.parent / "fixtures"
        loader = QMLLoader(qml_dir=fixtures_dir)  # default schema

        for fixture_name, block_id, expected_n, expected_random in (
            ("sample_basic.qml", "brand_sample", 2, False),
            ("sample_random.qml", "topic_sample", 5, True),
            ("sample_precondition.qml", "lifestyle_sample", 2, False),
        ):
            result = loader.load_from_file(fixture_name)
            block = next(b for b in result["blocks"] if b["id"] == block_id)
            assert block["kind"] == "Sample"
            assert block["count"] == expected_n
            inner = [i for i in result["items"] if i.get("blockId") == block_id]
            assert inner, f"{fixture_name}: no inner items flattened"
            for item in inner:
                assert item["_sample_block_id"] == block_id
                assert item["_sample_n"] == expected_n
                assert item["_sample_is_random"] is expected_random

    def test_sample_inner_items_have_no_roster_tags(self):
        """Sample and Roster tag families are mutually exclusive — a Sample
        inner item must not carry _roster_* tags."""
        result = QMLLoader().load_from_string(SAMPLE_BASIC)
        for item in result["items"]:
            assert "_roster_block_id" not in item
            assert "_roster_iterate_over" not in item
            assert "_roster_labels" not in item


class TestSampleEmptyAndDegenerate:
    """Degenerate-but-valid Sample blocks load without error."""

    def test_empty_sample_block_loads(self):
        """Edge case — a Sample block with zero inner items.

        The JSON schema enforces `items` minItems: 1, so the schema path
        rejects a truly empty block; the loader's own metadata-propagation
        path must still be a no-op for it (zero inner items ⇒ nothing to
        tag, no crash). We exercise the loader path with schema disabled to
        prove the propagation/validation code itself does not choke on an
        empty Sample."""
        yaml_str = _make_qml("""
    - id: s_empty
      kind: Sample
      count: 3
      items: []
""")
        loader = QMLLoader(schema_path=None)
        result = loader.load_from_string(yaml_str)
        block = next(b for b in result["blocks"] if b["id"] == "s_empty")
        assert block["kind"] == "Sample"
        assert block["count"] == 3
        assert [i for i in result["items"] if i.get("blockId") == "s_empty"] == []


class TestSampleCountLoudValidation:
    """Missing / invalid `count` fails loud — no silent default."""

    def test_missing_count_rejected(self):
        """Error path — Sample without `count`. Schema (count in the Sample
        allOf `required`) OR loader (defence-in-depth) rejects; either is
        acceptable, but it must NOT silently default."""
        yaml_str = _make_qml("""
    - id: s1
      kind: Sample
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
""")
        with pytest.raises((ValidationError, ValueError)):
            QMLLoader().load_from_string(yaml_str)

    def test_missing_count_loud_even_without_schema(self):
        """With schema disabled the loud loader re-check still fires —
        proving there is no silent fallback when callers bypass the schema."""
        yaml_str = _make_qml("""
    - id: s1
      kind: Sample
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
""")
        with pytest.raises(ValueError) as exc:
            QMLLoader(schema_path=None).load_from_string(yaml_str)
        assert "Sample block 's1'" in str(exc.value)
        assert "count" in str(exc.value).lower()

    @pytest.mark.parametrize(
        "count_literal",
        [
            "0",        # zero — not a positive draw count
            "-2",       # negative
            "1.5",      # non-integer-resolvable literal
            '"three"',  # string, not an int
            "true",     # YAML bool (int subclass in Python) — must be rejected
        ],
    )
    def test_non_positive_or_non_integer_count_rejected(self, count_literal):
        """Error path — count that is not a positive integer is rejected
        loudly (schema or loader). Bypass schema for the float/string/bool
        cases the loader must independently catch."""
        yaml_str = _make_qml(f"""
    - id: s1
      kind: Sample
      count: {count_literal}
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
""")
        with pytest.raises((ValidationError, ValueError)):
            QMLLoader().load_from_string(yaml_str)
        # The loader-only path (schema disabled) must also reject these —
        # the no-silent-fallback guarantee cannot rely on the schema.
        with pytest.raises(ValueError) as exc:
            QMLLoader(schema_path=None).load_from_string(yaml_str)
        assert "Sample block 's1'" in str(exc.value)

    def test_sample_rejects_roster_only_fields(self):
        """Schema — a Sample block must not carry Roster-only `iterateOver`
        / `labels` (the new Sample allOf `not/anyOf` branch)."""
        yaml_str = _make_qml("""
    - id: s1
      kind: Sample
      count: 1
      iterateOver: "1"
      labels:
        1: "A"
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
""")
        with pytest.raises(ValidationError):
            QMLLoader().load_from_string(yaml_str)
