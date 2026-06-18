#!/usr/bin/env python3
"""Unit tests for capped-Group Z3: single-presence-per-item conditional model.

StaticBuilder Pass 3.6 (`_emit_capped_group_conditional_presence`) validates a
`count`-capped Group through the shared U2 conditionally-present primitive. The
model is single-presence-per-item — one `present` Bool per inner item (k=0),
NO ordering enumeration, NO component permutation, NO cap. It is the sibling of
the Roster bit-guarded unroll but a distinct concern (a first-N draw, not a
bitmask unroll), so it lives in its own file rather than extending
test_roster_z3_dependencies.py.

Tests the capped-Group presence model:
- A `count`-capped Group registers every inner item conditionally-present at
  exactly k=0; an uncapped Group registers NONE (its items stay on the
  canonical unconditional path).
- Classification-safety: a capped-Group inner item that may not be drawn is
  selection-absent, NOT NEVER / dead-code.
- AE11: a capped Group's beyond-`count` item classifies CONDITIONAL, never
  NEVER / dead-code (an inner item whose precondition is unsatisfiable in
  isolation is demoted to CONDITIONAL because it is conditionally-present).
- AE12: an uncapped Group containing a genuinely dead item (unsatisfiable
  precondition) still reports NEVER / dead-code — the no-`count` path is NOT
  masked by conditional presence.
- Block-level precondition gates the whole block and block-level postcondition
  applies to drawn items only, both present-gated, for a capped Group.
- A Roster-only fixture registers ZERO capped-Group selection keys (the
  primitive is a proven no-op off the capped-Group path).

It also covers the U8 two-layer capped-Group independence rule (R10):
- AE6: a capped Group whose inner item directly references a sibling is rejected
  at LOAD time by the loader's structural name-match check.
- AE9: a transitive / variable-mediated intra-Group dependency LOADS (the
  loader's name-match is blind to it) but is flagged at VALIDATION time via a
  structured `group_dependency` coverage gap on the real dependency graph.
- AE10: a capped-Group inner item depending on a cross-block (outer) item LOADS
  and VALIDATES cleanly — only intra-Group edges are flagged.

These exercise the exact pipeline ValidationProcessor uses, so a green suite
means capped-Group questionnaires validate kind-aware with the simplified
single-presence model, no-`count` Groups still surface real dead code, and
non-independent capped Groups are rejected in both layers.
"""

import textwrap
import unittest

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.item_classifier import ItemClassifier
from askalot_qml.z3.path_based_validation import PathBasedValidator
from askalot_qml.z3.static_builder import StaticBuilder


def _build_static_inline(qml: str) -> StaticBuilder:
    """Build a StaticBuilder from inline QML (loader → state → builder).

    Uses `load_from_string`, which runs the full pipeline (schema validation,
    `kind` defaulting, kind/constraint validation, flattening + capped-Group
    `_group_*` propagation) — the same path `load_from_file` takes. Inline QML
    is required for the AE11/AE12 capped-vs-uncapped contrast because the
    legacy `sample_*.qml` fixtures are being deleted (U12) and none are
    migrated yet.
    """
    loader = QMLLoader()
    return StaticBuilder(QMLState(loader.load_from_string(textwrap.dedent(qml))))


def _selection_keys(builder: StaticBuilder) -> set:
    """The set of selection indices k registered conditionally-present. A
    capped Group uses exactly {0}; an uncapped Group registers none."""
    return {k for _iid, k in builder._conditionally_present}


def _cond_present_items(builder: StaticBuilder) -> set:
    return {iid for iid, _k in builder._conditionally_present}


# Two independent Radio items in a `count`-capped Group. `count: 1` < 2 items,
# so at least one inner item is always beyond the cap (the AE11 contrast). Both
# preconditions are trivially satisfiable, so any NEVER result would come from
# the absence of conditional presence, not from a contradictory predicate.
CAPPED_GROUP_QML = """\
qmlVersion: "2.0"
questionnaire:
  title: capped group
  blocks:
    - id: capped_block
      kind: Group
      count: 1
      items:
        - id: q_one
          kind: Question
          title: One
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
        - id: q_two
          kind: Question
          title: Two
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
"""

# A capped Group whose inner item carries a precondition that is UNSAT in
# isolation (an outcome cannot equal both 1 and 2). The precondition references
# ONLY the item's OWN outcome — NOT a sibling — so it passes the U8 load-time
# independence check (a self-reference is not an intra-Group dependency) while
# still being unsatisfiable. Without conditional presence this item would
# classify NEVER; because a capped-Group item is conditionally-present the
# classifier must demote it to CONDITIONAL (AE11).
CAPPED_GROUP_UNSAT_PRECOND_QML = """\
qmlVersion: "2.0"
questionnaire:
  title: capped group with unsat precond
  blocks:
    - id: capped_block
      kind: Group
      count: 1
      items:
        - id: q_keep
          kind: Question
          title: Keep
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
        - id: q_beyond
          kind: Question
          title: Beyond
          precondition:
            - predicate: "q_beyond.outcome == 1 and q_beyond.outcome == 2"
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
"""

# An UNCAPPED Group (no `count`) whose second item has the SAME UNSAT
# precondition as the capped fixture above. Because an uncapped Group does NOT
# mark its items conditionally-present, this item must still classify NEVER and
# be reported as dead code (AE12 — the no-`count` path is not masked).
UNCAPPED_GROUP_DEAD_ITEM_QML = """\
qmlVersion: "2.0"
questionnaire:
  title: uncapped group with dead item
  blocks:
    - id: uncapped_block
      kind: Group
      items:
        - id: q_live
          kind: Question
          title: Live
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
        - id: q_dead
          kind: Question
          title: Dead
          precondition:
            - predicate: "q_live.outcome == 1 and q_live.outcome == 2"
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
"""

# A capped Group with a block-level precondition AND postcondition. Both must
# be present-gated so the block-precondition-false world stays satisfiable
# (the inner items are conditionally-present, never NEVER/dead-code).
CAPPED_GROUP_BLOCK_CONDITION_QML = """\
qmlVersion: "2.0"
questionnaire:
  title: capped group block conditions
  blocks:
    - id: gate_outer
      kind: Group
      items:
        - id: q_age
          kind: Question
          title: Age
          input:
            control: Editbox
            min: 0
            max: 120
    - id: capped_block
      kind: Group
      count: 1
      precondition:
        - predicate: "q_age.outcome >= 18"
      postcondition:
        - predicate: "True"
          hint: "always"
      items:
        - id: q_p
          kind: Question
          title: P
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
        - id: q_q
          kind: Question
          title: Q
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
"""


# AE6: a capped Group whose inner item `b` has a precondition that DIRECTLY
# references sibling inner item `a`. The draw can leave `a` undrawn, so `b`'s
# precondition could read `a`'s None outcome — rejected at LOAD time by the
# loader's structural name-match check (`_validate_group_independence`).
CAPPED_GROUP_DIRECT_SIBLING_DEP_QML = """\
qmlVersion: "2.0"
questionnaire:
  title: capped group direct sibling dep
  blocks:
    - id: capped_block
      kind: Group
      count: 1
      items:
        - id: q_a
          kind: Question
          title: A
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
        - id: q_b
          kind: Question
          title: B
          precondition:
            - predicate: "q_a.outcome == 1"
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
"""

# AE9: a capped Group with a TRANSITIVE / variable-mediated intra-Group
# dependency — item `a`'s codeBlock WRITES `chosen`, item `b`'s precondition
# READS `chosen`. No inner-item id appears in any predicate/codeBlock, so the
# loader's name-match cannot see it and the document LOADS. The validation-time
# layer resolves `q_b -> var:chosen -> q_a` to `q_b -> q_a` on the real
# dependency graph and records a `group_dependency` gap.
CAPPED_GROUP_TRANSITIVE_DEP_QML = """\
qmlVersion: "2.0"
questionnaire:
  title: capped group transitive dep
  blocks:
    - id: capped_block
      kind: Group
      count: 1
      items:
        - id: q_a
          kind: Question
          title: A
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
          codeBlock: |
            chosen = q_a.outcome
        - id: q_b
          kind: Question
          title: B
          precondition:
            - predicate: "chosen == 1"
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
"""

# AE10: a capped Group whose inner item depends on an item in a PRIOR block (a
# cross-block dependency). Cross-block deps are explicitly allowed — the prior
# block's item is always asked, never drawn away — so this LOADS and VALIDATES
# with NO group_dependency gap.
CAPPED_GROUP_CROSS_BLOCK_DEP_QML = """\
qmlVersion: "2.0"
questionnaire:
  title: capped group cross-block dep
  blocks:
    - id: gate_block
      kind: Group
      items:
        - id: q_outer
          kind: Question
          title: Outer
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
    - id: capped_block
      kind: Group
      count: 1
      items:
        - id: q_inner1
          kind: Question
          title: Inner1
          precondition:
            - predicate: "q_outer.outcome == 1"
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
        - id: q_inner2
          kind: Question
          title: Inner2
          input:
            control: Radio
            labels: {1: "A", 2: "B"}
"""


def _group_dependency_gaps(builder: StaticBuilder) -> list:
    """Flatten every `group_dependency` coverage gap recorded by the builder
    (across all block keys) into a list of gap dicts."""
    return [
        gap
        for gaps in builder.coverage_gaps.values()
        for gap in gaps
        if gap.get("kind") == "group_dependency"
    ]


class TestGroupConditionalPresence(unittest.TestCase):
    """A `count`-capped Group registers each inner item conditionally-present
    once (k=0); an uncapped Group registers none."""

    def test_capped_group_all_items_conditionally_present_at_k0(self):
        """Capped Group: every inner item conditionally-present at k=0 — one
        presence var per item, no ordering enumeration."""
        builder = _build_static_inline(CAPPED_GROUP_QML)
        self.assertEqual(_selection_keys(builder), {0})
        self.assertEqual(_cond_present_items(builder), {"q_one", "q_two"})

    def test_uncapped_group_registers_no_presence(self):
        """Uncapped Group: NO inner item is conditionally-present — its items
        stay on the canonical unconditional single-pass path (R13)."""
        builder = _build_static_inline(UNCAPPED_GROUP_DEAD_ITEM_QML)
        self.assertEqual(_cond_present_items(builder), set())
        self.assertEqual(builder._conditionally_present, set())

    def test_capped_inner_items_not_never_or_dead_code(self):
        """Classification-safety: a capped-Group inner item that may not be
        drawn is selection-absent, NOT NEVER / dead-code."""
        builder = _build_static_inline(CAPPED_GROUP_QML)
        classifier = ItemClassifier(builder)
        for iid in ("q_one", "q_two"):
            self.assertTrue(builder.is_conditionally_present(iid))
            status = classifier.classify_item(iid)["precondition"]["status"]
            self.assertNotEqual(status, "NEVER", f"{iid} must not be NEVER")
        topology = QMLTopology(builder.state, builder)
        dead = PathBasedValidator(builder, topology).validate().dead_code_items
        for iid in ("q_one", "q_two"):
            self.assertNotIn(iid, dead)

    def test_no_capped_group_is_noop(self):
        """A Roster-only questionnaire registers ZERO capped-Group selection
        keys — the conditional-presence primitive is a proven no-op off the
        capped-Group path. Roster items use power-of-2 keys, never k=0.

        Inline QML (not a fixture) keeps this case self-contained — the exact
        Group+Roster shape under test is declared right here rather than
        depending on a shared fixture's evolving inner structure."""
        roster_qml = """\
            qmlVersion: "2.0"
            questionnaire:
              title: roster only
              blocks:
                - id: count_block
                  kind: Group
                  items:
                    - id: q_count
                      kind: Question
                      title: Count
                      input:
                        control: Editbox
                        min: 1
                        max: 4
                      codeBlock: |
                        family_mask = 2 ** q_count.outcome - 1
                - id: per_member
                  kind: Roster
                  iterateOver: "family_mask"
                  labels:
                    1: "Member 1"
                    2: "Member 2"
                  items:
                    - id: q_name
                      kind: Question
                      title: Name
                      input:
                        control: Editbox
                        min: 0
                        max: 100
            """
        builder = _build_static_inline(roster_qml)
        keys = _selection_keys(builder)
        # Roster registers power-of-2 keys (1, 2), never the capped-Group k=0.
        self.assertTrue(keys, "Roster must register power-of-2 presence keys")
        self.assertNotIn(
            0,
            keys,
            "Roster-only questionnaire must not register capped-Group k=0 keys",
        )


class TestGroupClassificationScoping(unittest.TestCase):
    """AE11/AE12 inverse pair: capped Groups mask NEVER (selection-absent),
    uncapped Groups do not (real dead code surfaces)."""

    def test_ae11_capped_beyond_count_item_is_conditional_not_never(self):
        """AE11: a capped Group's inner item whose precondition is UNSAT in
        isolation (would be NEVER without conditional presence) is demoted to
        CONDITIONAL and is NOT reported as dead code — it is merely
        selection-absent."""
        builder = _build_static_inline(CAPPED_GROUP_UNSAT_PRECOND_QML)
        # The item is conditionally-present, so the classifier clamps NEVER to
        # CONDITIONAL.
        self.assertTrue(builder.is_conditionally_present("q_beyond"))
        classifier = ItemClassifier(builder)
        status = classifier.classify_item("q_beyond")["precondition"]["status"]
        self.assertEqual(
            status,
            "CONDITIONAL",
            "a capped-Group beyond-count item must be CONDITIONAL, never NEVER",
        )
        topology = QMLTopology(builder.state, builder)
        dead = PathBasedValidator(builder, topology).validate().dead_code_items
        self.assertNotIn(
            "q_beyond", dead, "a capped-Group item must never be dead code"
        )

    def test_ae12_uncapped_group_dead_item_still_never(self):
        """AE12: the SAME UNSAT precondition inside an UNCAPPED Group still
        classifies NEVER — proving the no-`count` path is NOT masked by
        conditional presence (R13). The inverse of AE11: this item is NOT
        conditionally-present, so the classifier does not demote NEVER to
        CONDITIONAL.

        NEVER (per-item, UNSAT(B ∧ P)) is the dead-code verdict at the
        per-item level; `PathBasedValidator.dead_code_items` is a *different*
        category (CONDITIONAL-but-accumulated-unreachable) and by design holds
        no NEVER items, so the per-item NEVER status is the decisive assertion
        here."""
        builder = _build_static_inline(UNCAPPED_GROUP_DEAD_ITEM_QML)
        # The dead item is NOT conditionally-present (uncapped Group) — the
        # exact mechanism by which it stays NEVER instead of being demoted.
        self.assertFalse(builder.is_conditionally_present("q_dead"))
        classifier = ItemClassifier(builder)
        status = classifier.classify_item("q_dead")["precondition"]["status"]
        self.assertEqual(
            status,
            "NEVER",
            "an uncapped-Group item with an UNSAT precondition must stay NEVER",
        )


class TestGroupBlockConditions(unittest.TestCase):
    """Integration: block precondition/postcondition × conditional-presence
    for a capped Group."""

    def test_block_precondition_and_postcondition_present_gated(self):
        """A capped Group's block-level precondition gates the whole block and
        its block-level postcondition applies to drawn items only. Both inner
        items are conditionally-present and the composed (block+item)
        conditions are emitted under the present gate, so the build succeeds
        and neither item is NEVER / dead-code (the gate makes the
        block-precondition-false world satisfiable rather than dead)."""
        builder = _build_static_inline(CAPPED_GROUP_BLOCK_CONDITION_QML)
        self.assertEqual(_cond_present_items(builder), {"q_p", "q_q"})
        self.assertEqual(_selection_keys(builder), {0})
        classifier = ItemClassifier(builder)
        for iid in ("q_p", "q_q"):
            status = classifier.classify_item(iid)["precondition"]["status"]
            self.assertNotEqual(status, "NEVER")


class TestGroupIndependence(unittest.TestCase):
    """U8 two-layer capped-Group independence enforcement (R10).

    Inner items of a `count`-capped Group must be independent. Two layers:
    - Load time (`QMLLoader._validate_group_independence`): rejects DIRECT
      sibling references (AE6).
    - Validation time (`StaticBuilder._emit_capped_group_independence_gaps`):
      rejects transitive / variable-mediated intra-Group edges via the real
      dependency graph, surfaced as a structured `group_dependency` gap (AE9).
    Cross-block dependencies remain allowed (AE10).
    """

    def test_ae6_direct_sibling_dep_rejected_at_load(self):
        """AE6: a capped Group whose inner item `b` has a precondition that
        directly references sibling `a` is rejected at LOAD time. The loader's
        structural name-match raises before any Z3 build runs."""
        loader = QMLLoader()
        with self.assertRaises(ValueError) as ctx:
            loader.load_from_string(
                textwrap.dedent(CAPPED_GROUP_DIRECT_SIBLING_DEP_QML)
            )
        message = str(ctx.exception)
        # The error must name BOTH the offending item and the sibling so the
        # author can act on it.
        self.assertIn("q_b", message)
        self.assertIn("q_a", message)
        self.assertIn("capped_block", message)

    def test_ae9_transitive_dep_loads_but_flagged_at_validation(self):
        """AE9: a variable-mediated intra-Group dependency (item `a`'s codeBlock
        writes `chosen`, item `b`'s precondition reads it) LOADS — no inner-item
        id is named in any predicate/codeBlock, so the loader's name-match is
        blind to it — but the validation-time layer resolves the transitive edge
        and records a structured `group_dependency` gap. Validation surfaces it
        loudly (no swallowed None) via the block-id-keyed coverage-gaps channel
        ItemClassifier reads."""
        # LOADS: the loader's direct-reference check does not trip.
        builder = _build_static_inline(CAPPED_GROUP_TRANSITIVE_DEP_QML)

        # The validation-time layer resolved q_b -> var:chosen -> q_a and
        # recorded exactly one group_dependency gap for that edge.
        gaps = _group_dependency_gaps(builder)
        self.assertEqual(len(gaps), 1, f"expected one group_dependency gap, got {gaps}")
        gap = gaps[0]
        self.assertEqual(gap["kind"], "group_dependency")
        self.assertEqual(gap["block_id"], "capped_block")
        self.assertEqual(gap["item_id"], "q_b")
        self.assertEqual(gap["depends_on"], "q_a")

        # The gap is stored under the BLOCK id key (disjoint from item ids), the
        # generic block-id-keyed channel.
        self.assertIn("capped_block", builder.coverage_gaps)

        # It surfaces through the validation pipeline ItemClassifier feeds:
        # classify_all_items emits a synthetic block-keyed result carrying the
        # gap, which validate_qml_file reads into issues[]. This is the loud,
        # visible failure path — not a swallowed None.
        classifier = ItemClassifier(builder)
        results = classifier.classify_all_items()
        self.assertIn("capped_block", results)
        surfaced = [
            g
            for g in results["capped_block"]["coverage_gaps"]
            if g.get("kind") == "group_dependency"
        ]
        self.assertEqual(len(surfaced), 1)
        self.assertEqual(surfaced[0]["depends_on"], "q_a")

    def test_ae10_cross_block_dep_loads_and_validates_clean(self):
        """AE10: a capped-Group inner item depending on an item in a PRIOR block
        (cross-block) LOADS and VALIDATES with NO group_dependency gap. The
        outer item is never drawn away, so the dependency is safe — only
        intra-Group edges are flagged."""
        # LOADS: no sibling reference, so the loader passes.
        builder = _build_static_inline(CAPPED_GROUP_CROSS_BLOCK_DEP_QML)

        # The cross-block edge q_inner1 -> q_outer is NOT flagged: q_outer lives
        # in a different block, so it is not an intra-Group dependency.
        gaps = _group_dependency_gaps(builder)
        self.assertEqual(gaps, [], f"cross-block dep must not be flagged: {gaps}")

        # And the dependency edge genuinely exists (proving the absence of a gap
        # is because of the cross-block scoping, not a missing edge).
        deps = builder.get_item_dependencies()
        self.assertIn("q_outer", deps.get("q_inner1", set()))

        # No group_dependency gap reaches the validation pipeline either.
        classifier = ItemClassifier(builder)
        results = classifier.classify_all_items()
        for result in results.values():
            for gap in result.get("coverage_gaps", []):
                self.assertNotEqual(gap.get("kind"), "group_dependency")


if __name__ == "__main__":
    unittest.main()
