#!/usr/bin/env python3
"""Unit tests for Group + Roster schema validation and loader propagation.

This file covers the loader-side contract of the two-kind block model
(docs/plans/2026-06-17-001-refactor-qml-block-kinds-group-collapse-plan.md, U2),
which collapsed the three legacy kinds (`Sequence`, `Roster`, `Sample`) into two:

* `Group` — the renamed `Sequence`: visit each in-scope inner item once in
  canonical (stable-Kahn) order. An optional `count` caps the block to the first
  N eligible items — `Sample` (`is_random:false`) folded into this attribute.
  `is_random` and the random-draw subsystem are deleted.
* `Roster` — unchanged: repeat inner items per set bit in an `iterateOver`
  bitmask.

The Group cases live here (not a sibling file) per the repo CLAUDE.md
"Test Placement — Existing Files First" rule: the loader acceptance +
`_propagate_block_inheritance` surface is the same component the Roster cases
already exercise.

**Two-kind loader contract (U2):**
  * `kind` is **optional** and defaults to `Group` in both schema and loader.
    A block with `kind` omitted loads as a Group (AE16).
  * The legacy `Sequence` / `Sample` kinds (and any other unrecognized literal)
    are rejected **loudly** at both the schema layer and the loader layer —
    including when `schema_path=None`, so a schema-less caller still fails (AE7b).
  * `count` is **optional** on a Group (omitted ⇒ ask all in-scope items). When
    present it must be a positive integer literal; 0 / negative / non-int / bool
    fail loud (no silent fallback). A Roster must NOT carry `count`.
  * Inner items of a `count`-capped Group carry `_group_block_id` / `_group_count`,
    mirroring the Roster `_roster_*` tag family. An **uncapped** Group adds no
    tags (its items are asked unconditionally).

This suite verifies:

  1. Schema accepts `kind: Roster` blocks with required `iterateOver` (string
     expression) and `labels` (power-of-2 keyed map).
  2. Schema rejects Roster missing `iterateOver` / `labels` and rejects
     forbidden v1 fields (`as`, `maxEntries`).
  3. Loader rejects non-power-of-2 keys on Roster `labels` and on Checkbox
     `input.labels` (forward-tightening — Checkbox outcome is the bitmask sum of
     selected keys, so each key must occupy a unique bit position so the outcome
     can flow directly into a sibling Roster's `iterateOver`).
  4. Loader rejects `iterateOver` expressions referencing items that live inside
     the same Roster (self-cycle prevention).
  5. Loader propagates `_roster_block_id` / `_roster_iterate_over` /
     `_roster_labels` onto Roster inner items, and `_group_block_id` /
     `_group_count` onto capped-Group inner items, so downstream consumers
     (FlowProcessor, Z3 dependency wiring, Bronze schema build) can detect them
     without re-walking the block tree.
  6. Block-level `precondition` and `postcondition` are allowed on both Block and
     Roster. They live ONLY on the block object — the loader does NOT copy them
     onto items (R25, 2026-05-14). Downstream consumers (FlowProcessor for
     runtime, StaticBuilder for Z3) compose block + item conditions at
     evaluation time; items never gain `_source`, `_block_id`,
     `_block_precondition_count` or `_block_postcondition_count` markers.
  7. `kind` defaults to `Group` when omitted (AE16); legacy `Sequence` / `Sample`
     rejected at both layers, including schema-less (AE7b).

## Coverage areas

- Happy-path schema acceptance (Group with/without count, explicit + omitted
  kind, Roster)
- Legacy-kind rejection (`Sequence`, `Sample`) at both layers, incl. schema-less
- `kind` omitted defaults to Group
- Required-field rejection on Roster (iterateOver, labels)
- Forbidden-field rejection on Roster (as, maxEntries, count)
- Power-of-2 enforcement on Roster + Checkbox labels (and edge cases: 0, neg, 3)
- Self-cycle rejection on iterateOver
- Group `count` propagation onto inner items; uncapped Group adds no tags
- Roster metadata propagation onto inner items (unchanged)
- Group `count` loud validation (missing-is-fine, zero/negative/non-int/bool
  rejected)
- Block postcondition propagation (symmetric to precondition)
- Existing legacy fixtures continue to load unchanged (schema bypassed)

These are integration-style loader tests built from inline QML strings and
in-memory dicts. Where a test must touch a shipped `.qml` fixture, that
dependency is called out explicitly.
"""

import pytest
from askalot_qml.core.qml_loader import QMLLoader
from jsonschema import ValidationError

# ---------------------------------------------------------------------------
# YAML test fixtures (inline)
# ---------------------------------------------------------------------------

VALID_ROSTER_NUMERIC = """
qmlVersion: "2.0"
questionnaire:
  title: "Family Roster"
  blocks:
    - id: count_block
      kind: Group
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
qmlVersion: "2.0"
questionnaire:
  title: "Daily Meal Tracker"
  blocks:
    - id: meal_selection
      kind: Group
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


PLAIN_GROUP_BLOCK = """
qmlVersion: "2.0"
questionnaire:
  title: "Plain"
  blocks:
    - id: b1
      kind: Group
      items:
        - id: q1
          kind: Question
          title: "Anything?"
          input:
            control: Editbox
            min: 0
            max: 10
"""


# Same questionnaire as PLAIN_GROUP_BLOCK but with `kind` omitted, exercising
# the loader's absent-kind → Group default (AE16).
GROUP_KIND_OMITTED = """
qmlVersion: "2.0"
questionnaire:
  title: "Kind omitted"
  blocks:
    - id: b1
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

    Block fragments may declare their own `kind` (Group or Roster) or omit it
    (defaults to Group) — `kind` is optional in the two-kind model.
    """
    return f"""
qmlVersion: "2.0"
questionnaire:
  title: "Test"
  blocks:
{roster_block_yaml}
"""


# ---------------------------------------------------------------------------
# Schema acceptance — happy paths
# ---------------------------------------------------------------------------


class TestSchemaAcceptance:
    """Schema + loader accept the two-kind model (Group, Roster) and the
    omitted-kind → Group default; legacy kinds are rejected."""

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

    def test_explicit_group_kind_loads(self):
        """`kind: Group` is the explicit form of the default block kind."""
        loader = QMLLoader()
        result = loader.load_from_string(PLAIN_GROUP_BLOCK)
        assert result["blocks"][0]["kind"] == "Group"

    def test_block_without_kind_defaults_to_group(self):
        """AE16 — `kind` omitted ⇒ the loader defaults it to Group and the
        block loads (the inverse of the old mandatory-kind rejection)."""
        result = QMLLoader().load_from_string(GROUP_KIND_OMITTED)
        b1 = result["blocks"][0]
        assert b1["kind"] == "Group"
        # An uncapped Group adds no draw-cap tags to its inner items.
        q1 = next(i for i in result["items"] if i["id"] == "q1")
        assert "_group_block_id" not in q1
        assert "_group_count" not in q1

    def test_legacy_sequence_kind_is_rejected(self):
        """`Sequence` collapsed into `Group` — it must be rejected at both the
        schema and loader layers (AE7b is the schema-less variant below)."""
        yaml_str = _make_qml("""
    - id: b1
      kind: Sequence
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

    def test_legacy_sample_kind_is_rejected(self):
        """`Sample` became the optional `count` attribute on `Group` — the kind
        literal itself is rejected at both layers."""
        yaml_str = _make_qml("""
    - id: b1
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
        with pytest.raises((ValidationError, ValueError)):
            QMLLoader().load_from_string(yaml_str)

    def test_single_label_roster_loads(self):
        """Degenerate-but-valid Roster with a single label key."""
        yaml_str = _make_qml("""
    - id: outer
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
qmlVersion: "2.0"
questionnaire:
  title: "Block postcondition"
  blocks:
    - id: b1
      kind: Group
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
      kind: Group
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
    Shipped fixtures must continue to flow through the loader unchanged.

    These fixtures use the two-kind model (`kind: Group`, or `kind` omitted).
    The assertions prove non-Roster QML flattens with no `_roster_*` tags, and
    that the two `qmlVersion`-carrying fixtures pass the schema path.
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
        """Schema bypassed — proves the flatten path is unchanged for non-Roster QML."""
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
        """Schema-valid fixtures still pass — the Roster allOf branch is gated on
        `kind: Roster`, so `kind: Group` fixtures validate cleanly."""
        from pathlib import Path

        fixtures_dir = Path(__file__).parent.parent.parent / "fixtures"
        loader = QMLLoader(qml_dir=fixtures_dir)  # default schema
        loader.load_from_file(fixture_name)


# ---------------------------------------------------------------------------
# Group block — plan 2026-06-17-001 U2
#
# `kind: Group` is the renamed `Sequence`. An optional `count` caps the block to
# the first N eligible items (the folded-in `Sample` attribute). `count` is
# OPTIONAL — omitted ⇒ ask all in-scope items. A capped Group tags inner items
# `_group_block_id` / `_group_count`; an uncapped Group adds no tags.
# ---------------------------------------------------------------------------


GROUP_CAPPED = """
qmlVersion: "2.0"
questionnaire:
  title: "Capped Group"
  blocks:
    - id: brand_group
      kind: Group
      title: "Brand impressions"
      count: 2
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


class TestGroupSchemaAndLoaderAcceptance:
    """A capped Group loads with `count`; inner items carry _group_* tags. An
    uncapped Group (and an omitted-kind Group) carry no draw-cap tags."""

    def test_capped_group_propagates_group_tags(self):
        """Happy path — a Group with `count` loads and tags every inner item
        with `_group_block_id` / `_group_count`."""
        result = QMLLoader().load_from_string(GROUP_CAPPED)
        block = next(b for b in result["blocks"] if b["id"] == "brand_group")
        assert block["kind"] == "Group"
        assert block["count"] == 2

        inner = [i for i in result["items"] if i.get("blockId") == "brand_group"]
        assert len(inner) == 3
        for item in inner:
            assert item["_group_block_id"] == "brand_group"
            assert item["_group_count"] == 2

    def test_uncapped_group_adds_no_tags(self):
        """An uncapped Group (no `count`) asks all items, so it must NOT tag its
        inner items — the absence of `_group_*` is the "ask all" signal."""
        yaml_str = _make_qml("""
    - id: g1
      kind: Group
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
        for item in result["items"]:
            assert "_group_block_id" not in item
            assert "_group_count" not in item

    def test_omitted_kind_group_with_count_propagates_tags(self):
        """`kind` omitted + `count` set ⇒ defaults to Group and still propagates
        the capped-Group tags (the default-then-propagate ordering holds)."""
        yaml_str = """
qmlVersion: "2.0"
questionnaire:
  title: "Omitted kind, capped"
  blocks:
    - id: g1
      count: 1
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
"""
        result = QMLLoader().load_from_string(yaml_str)
        block = next(b for b in result["blocks"] if b["id"] == "g1")
        assert block["kind"] == "Group"
        q1 = next(i for i in result["items"] if i["id"] == "q1")
        assert q1["_group_block_id"] == "g1"
        assert q1["_group_count"] == 1

    def test_count_larger_than_item_count_loads(self):
        """AE8 (loader side) — count greater than the number of inner items
        loads fine; the runtime "ask up to N" clamp is a U5 concern."""
        yaml_str = _make_qml("""
    - id: g1
      kind: Group
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
        block = next(b for b in result["blocks"] if b["id"] == "g1")
        assert block["count"] == 9
        assert len([i for i in result["items"] if i.get("blockId") == "g1"]) == 2

    def test_group_inner_items_have_no_roster_tags(self):
        """Group and Roster tag families are mutually exclusive — a Group inner
        item must not carry _roster_* tags."""
        result = QMLLoader().load_from_string(GROUP_CAPPED)
        for item in result["items"]:
            assert "_roster_block_id" not in item
            assert "_roster_iterate_over" not in item
            assert "_roster_labels" not in item


class TestLegacyKindRejectedSchemaless:
    """AE7b — the retired `Sequence` / `Sample` kinds are rejected loudly by the
    loader even when `schema_path=None` (the schema enum never runs)."""

    def test_sequence_rejected_without_schema(self):
        """AE7b — `kind: Sequence` with schema disabled is rejected by the
        loader's defence-in-depth `_validate_block_kinds`, with an
        author-actionable migration hint."""
        yaml_str = _make_qml("""
    - id: b1
      kind: Sequence
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
        msg = str(exc.value)
        assert "Sequence" in msg
        assert "Group" in msg  # names the replacement kind

    def test_sample_rejected_without_schema(self):
        """`kind: Sample` with schema disabled is rejected by the loader, with a
        hint pointing at `Group` + `count`."""
        yaml_str = _make_qml("""
    - id: b1
      kind: Sample
      count: 2
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
        msg = str(exc.value)
        assert "Sample" in msg
        assert "Group" in msg
        assert "count" in msg.lower()


class TestGroupEmptyAndDegenerate:
    """Degenerate-but-valid Group blocks load without error."""

    def test_empty_capped_group_loads(self):
        """Edge case — a capped Group with zero inner items.

        The JSON schema enforces `items` minItems: 1, so the schema path rejects
        a truly empty block; the loader's own metadata-propagation path must
        still be a no-op for it (zero inner items ⇒ nothing to tag, no crash).
        Schema disabled to exercise the propagation/validation code directly."""
        yaml_str = _make_qml("""
    - id: g_empty
      kind: Group
      count: 3
      items: []
""")
        loader = QMLLoader(schema_path=None)
        result = loader.load_from_string(yaml_str)
        block = next(b for b in result["blocks"] if b["id"] == "g_empty")
        assert block["kind"] == "Group"
        assert block["count"] == 3
        assert [i for i in result["items"] if i.get("blockId") == "g_empty"] == []


class TestGroupCountLoudValidation:
    """`count` is optional, but when present must be a positive int — invalid
    values fail loud at both layers; a missing `count` is NOT an error."""

    def test_missing_count_is_allowed(self):
        """Omitting `count` means "ask all in-scope items" — it must load
        cleanly (the inverse of the old mandatory-count Sample rule)."""
        yaml_str = _make_qml("""
    - id: g1
      kind: Group
      items:
        - id: q1
          kind: Question
          title: "Q"
          input:
            control: Editbox
            min: 0
            max: 10
""")
        # Must not raise, on either path.
        result = QMLLoader().load_from_string(yaml_str)
        assert next(b for b in result["blocks"] if b["id"] == "g1")["kind"] == "Group"
        QMLLoader(schema_path=None).load_from_string(yaml_str)

    @pytest.mark.parametrize(
        "count_literal",
        [
            "0",        # zero — not a positive cap
            "-2",       # negative
            "1.5",      # non-integer-resolvable literal
            '"three"',  # string, not an int
            "true",     # YAML bool (int subclass in Python) — must be rejected
        ],
    )
    def test_non_positive_or_non_integer_count_rejected(self, count_literal):
        """Error path — a present `count` that is not a positive integer is
        rejected loudly (schema or loader). The loader-only path (schema
        disabled) must also reject these — the no-silent-fallback guarantee
        cannot rely on the schema."""
        yaml_str = _make_qml(f"""
    - id: g1
      kind: Group
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
        with pytest.raises(ValueError) as exc:
            QMLLoader(schema_path=None).load_from_string(yaml_str)
        assert "Group block 'g1'" in str(exc.value)

    def test_roster_rejects_count(self):
        """A Roster must NOT carry `count` — the schema rejects it, and the
        loader mirrors that on the schema-less path."""
        yaml_str = _make_qml("""
    - id: bad_roster
      kind: Roster
      iterateOver: "1"
      count: 2
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
        # Schema path rejects.
        with pytest.raises((ValidationError, ValueError)):
            QMLLoader().load_from_string(yaml_str)
        # Loader-only path also rejects, naming the offending block.
        with pytest.raises(ValueError) as exc:
            QMLLoader(schema_path=None).load_from_string(yaml_str)
        assert "Roster block 'bad_roster'" in str(exc.value)
        assert "count" in str(exc.value).lower()


class TestQmlVersionGate:
    """U3: the loader rejects a document whose declared qmlVersion MAJOR is
    incompatible with the current schema major (2.x), and rejects a malformed
    (non-dotted-numeric) qmlVersion outright. An absent qmlVersion is advisory
    (the schema's own required-list catches it on the validated path); the gate
    fires before schema validation so a legacy document gets a clear version
    error rather than a cryptic enum failure on the removed kinds."""

    _GROUP_DOC = """
qmlVersion: "{ver}"
questionnaire:
  title: "Version gate"
  blocks:
    - id: b1
      kind: Group
      items:
        - id: q1
          kind: Question
          title: "Q1?"
          input:
            control: Editbox
            min: 0
            max: 10
"""

    def test_ae17_legacy_major_rejected(self):
        # AE17: a document declaring a legacy qmlVersion 1.x no longer loads.
        with pytest.raises(ValueError, match="qmlVersion"):
            QMLLoader().load_from_string(self._GROUP_DOC.format(ver="1.0"))

    def test_current_major_loads(self):
        result = QMLLoader().load_from_string(self._GROUP_DOC.format(ver="2.0"))
        assert result is not None

    def test_malformed_version_rejected(self):
        # A non-numeric / malformed qmlVersion (e.g. "2.x") must be rejected
        # loudly rather than silently truncated to major "2" by split(".")[0].
        # The two-part "2.0" the gate compares against must still load.
        with pytest.raises(ValueError, match="[Mm]alformed qmlVersion"):
            QMLLoader().load_from_string(self._GROUP_DOC.format(ver="2.x"))
        assert QMLLoader().load_from_string(self._GROUP_DOC.format(ver="2.0")) is not None

    def test_legacy_major_rejected_even_schemaless(self):
        # Defense-in-depth: the gate runs before schema validation, so a
        # schema-less load still rejects an incompatible declared version.
        with pytest.raises(ValueError, match="qmlVersion"):
            QMLLoader(schema_path=None).load_from_string(self._GROUP_DOC.format(ver="1.5"))
