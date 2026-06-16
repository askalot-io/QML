#!/usr/bin/env python3
"""Unit tests for Sample Z3 (U4): conditional presence + ordering enumeration
+ validation-time component cap.

Sample Z3 is a sibling of the Roster bit-guarded unroll but a distinct
concern (selection-draw + contiguous-tree-block randomization, not a bitmask
unroll), so it lives in its own file rather than extending
test_roster_z3_dependencies.py.

StaticBuilder Pass 3.6 validates each Sample block through the U2
conditionally-present primitive:

- R5: every Sample inner item is registered conditionally-present; its
  domain/pre/post are present-gated (drawn ⇒ well-typed & SAT, never NEVER).
- R6 / AE2 (refined): is_random=true enumerates every distinct
  contiguous-tree-block ordering — independent components permuted, each
  component emitted contiguously in the topology's fixed cycle-tolerant
  linearization (a-before-b preserved; c stays contiguous).
- R9 / AE4: is_random=true with > 7 block-scoped components is rejected
  loudly via a structured `sample_cap` coverage gap — NO solve, the T! (here
  8! = 40320) orderings are NEVER materialized (the gate is an int compare
  taken before any itertools.permutations call).
- R10 / AE5: is_random=false (or T ≤ 1) → single canonical order, no
  enumeration, no cap (20 independent items accepted even though 20 > 7).
- Edge: single component + is_random=true → exactly one ordering; cyclic /
  diamond component → topology linearization, no special rejection; empty
  block → base case = 1 (empty) ordering, no divide-by-zero / no permute.
- Integration: block precondition gates the whole block; block postcondition
  applies to drawn items only (present-gated).
- Block-scoped components are extracted over the SAME StaticBuilder
  dependency graph Z3 enumerates (variable-mediated transitive edges
  included) — the explicit reason R9 is validation-time.

These exercise the exact pipeline ValidationProcessor uses, so a green suite
means Sample questionnaires validate kind-aware with the contiguous-block
randomization model and a hard, loud component cap.
"""

import itertools
import unittest
from pathlib import Path

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.item_classifier import ItemClassifier
from askalot_qml.z3.static_builder import StaticBuilder

FIXTURES_DIR = Path(__file__).parent.parent.parent / "fixtures"


def _build_static(fixture_name: str) -> StaticBuilder:
    """Build a StaticBuilder directly from a fixture (loader → state →
    builder) — the construction ValidationProcessor uses for classification.

    Reuses the same helper shape as test_roster_z3_dependencies.py rather
    than introducing a parallel loader utility.
    """
    loader = QMLLoader(qml_dir=FIXTURES_DIR)
    return StaticBuilder(QMLState(loader.load_from_file(fixture_name)))


def _selection_keys(builder: StaticBuilder) -> set[int]:
    """The set of selection indices k registered conditionally-present —
    one per enumerated ordering for is_random=true, {0} for the single
    canonical order."""
    return {k for _iid, k in builder._conditionally_present}


def _cond_present_items(builder: StaticBuilder) -> set[str]:
    return {iid for iid, _k in builder._conditionally_present}


class TestSampleConditionalPresence(unittest.TestCase):
    """R5/R10: every Sample inner item is conditionally-present; is_random
    =false yields exactly one canonical order."""

    def test_is_random_false_single_canonical_order(self):
        """sample_basic.qml: is_random omitted (→false), 3 independent items.
        R10: ONE canonical order (k=0 only), all 3 conditionally-present."""
        builder = _build_static("sample_basic.qml")
        self.assertEqual(_selection_keys(builder), {0})
        self.assertEqual(
            _cond_present_items(builder),
            {"q_brand_a", "q_brand_b", "q_brand_c"},
        )

    def test_inner_items_not_never_or_dead_code(self):
        """Classification-safety (R5/R7): a Sample inner item that may not be
        drawn is sampling-absent, NOT NEVER / dead-code."""
        from askalot_qml.z3.path_based_validation import PathBasedValidator

        builder = _build_static("sample_basic.qml")
        classifier = ItemClassifier(builder)
        for iid in ("q_brand_a", "q_brand_b", "q_brand_c"):
            self.assertTrue(builder.is_conditionally_present(iid))
            status = classifier.classify_item(iid)["precondition"]["status"]
            self.assertNotEqual(status, "NEVER", f"{iid} must not be NEVER")
        topology = QMLTopology(builder.state, builder)
        dead = PathBasedValidator(builder, topology).validate().dead_code_items
        for iid in ("q_brand_a", "q_brand_b", "q_brand_c"):
            self.assertNotIn(iid, dead)

    def test_no_sample_blocks_is_noop(self):
        """A Roster-only fixture must register ZERO Sample selection keys —
        the U2 no-op invariant holds off the Sample path (Pass 3.6 returns
        before building the throwaway topology)."""
        builder = _build_static("roster_numeric.qml")
        # roster items are conditionally-present via U3 with power-of-2 keys;
        # NO sequential Sample key 0 from a (non-existent) single-canonical
        # Sample order should appear, and no Sample-specific var either.
        self.assertFalse(
            any(k == 0 for _iid, k in builder._conditionally_present),
            "Roster-only fixture must not register Sample k=0 selection keys",
        )


class TestSampleOrderingEnumeration(unittest.TestCase):
    """R6 / AE2: contiguous-tree-block permutation semantics."""

    def test_ae2_two_components_two_contiguous_orderings(self):
        """sample_multi_tree.qml: component [q_a→q_b] and component [q_c].
        T=2 → exactly the 2 orderings {q_a,q_b,q_c} and {q_c,q_a,q_b}: q_c
        contiguous, q_a-before-q_b preserved in both. Validated by
        reconstructing the orderings the pass enumerates over the SAME graph
        and asserting the contiguous-block invariant + the registered
        selection-key count (one k per ordering)."""
        builder = _build_static("sample_multi_tree.qml")
        # One selection index per ordering → exactly 2 (k ∈ {0, 1}).
        self.assertEqual(_selection_keys(builder), {0, 1})
        self.assertEqual(
            _cond_present_items(builder), {"q_a", "q_b", "q_c"}
        )

        # Reconstruct the orderings deterministically (same graph, same
        # topology, same linearization the pass uses).
        topology = QMLTopology(builder.state, builder)
        ti = {i: n for n, i in enumerate(topology.get_topological_order())}
        comps = topology.get_block_scoped_components({"q_a", "q_b", "q_c"})
        self.assertEqual(len(comps), 2, "expected 2 block-scoped components")

        def lin(c):
            return sorted(c, key=lambda i: ti.get(i, len(ti)))

        oc = sorted(comps, key=lambda c: min(ti.get(i, len(ti)) for i in c))
        linz = [lin(c) for c in oc]
        orderings = [
            [i for comp in p for i in comp]
            for p in itertools.permutations(linz)
        ]
        self.assertEqual(
            sorted(map(tuple, orderings)),
            sorted([("q_a", "q_b", "q_c"), ("q_c", "q_a", "q_b")]),
        )
        # Contiguity + intra-order invariants on every ordering.
        for o in orderings:
            self.assertLess(o.index("q_a"), o.index("q_b"), "a before b")
            # q_c is a singleton component → trivially contiguous; assert the
            # [q_a, q_b] block is never split by q_c.
            self.assertEqual(
                abs(o.index("q_a") - o.index("q_b")), 1, "a,b contiguous"
            )

    def test_is_random_true_two_independent_items(self):
        """sample_random.qml: is_random=true, 2 independent inner items →
        T=2 → 2 orderings (k ∈ {0,1})."""
        builder = _build_static("sample_random.qml")
        self.assertEqual(_selection_keys(builder), {0, 1})

    def test_single_component_is_random_true_one_ordering(self):
        """Edge: sample_single_component.qml — is_random=true but q_d2
        depends on q_d1, so T=1. T ≤ 1 short-circuits the permutation branch
        → exactly ONE ordering (k=0), behaving like is_random=false."""
        builder = _build_static("sample_single_component.qml")
        self.assertEqual(_selection_keys(builder), {0})
        self.assertEqual(
            _cond_present_items(builder), {"q_d1", "q_d2"}
        )

    def test_cyclic_component_is_random_no_special_rejection(self):
        """Edge: sample_cyclic.qml — q_x ↔ q_y form a 2-node cycle (one
        component), q_z independent (second). is_random=true, T=2 ≤ cap. The
        cyclic component is NOT rejected; it is linearized via the topology's
        cycle-tolerant order and emitted contiguously like any component.
        2 orderings (k ∈ {0,1}); no coverage gap."""
        builder = _build_static("sample_cyclic.qml")
        self.assertEqual(_selection_keys(builder), {0, 1})
        self.assertEqual(
            _cond_present_items(builder), {"q_x", "q_y", "q_z"}
        )
        self.assertNotIn("loop_sample", builder.coverage_gaps)


class TestSampleComponentCap(unittest.TestCase):
    """R9 / AE4: validation-time cap, loud, no solve, no materialization."""

    def test_over_cap_emits_structured_gap_no_solve(self):
        """sample_over_cap.qml: is_random=true, 8 independent components > 7.
        A structured `sample_cap` gap is recorded for the named block and ZERO
        inner constraints are emitted (no solve)."""
        builder = _build_static("sample_over_cap.qml")
        self.assertIn("big_sample", builder.coverage_gaps)
        gaps = builder.coverage_gaps["big_sample"]
        self.assertEqual(len(gaps), 1)
        gap = gaps[0]
        self.assertEqual(gap["kind"], "sample_cap")
        self.assertEqual(gap["block_id"], "big_sample")
        self.assertEqual(gap["component_count"], 8)
        self.assertEqual(gap["cap"], 7)
        # No solve: no Sample inner item was registered conditionally-present.
        for iid in (f"q_s{i}" for i in range(1, 9)):
            self.assertFalse(
                builder.is_conditionally_present(iid),
                f"{iid} must NOT be conditionally-present (block not solved)",
            )

    def test_over_cap_never_materializes_factorial_orderings(self):
        """The R9 gate counts T and rejects BEFORE any ordering exists. We
        spy on itertools.permutations during the over-cap build and assert it
        is NEVER called — a `> 7` fixture must not build a 40320-element
        structure (plan verification: 'ordering count never materialized for
        the gate check')."""
        calls: list = []
        original = itertools.permutations

        def spy(*args, **kwargs):
            calls.append(args)
            return original(*args, **kwargs)

        itertools.permutations = spy
        try:
            _build_static("sample_over_cap.qml")
        finally:
            itertools.permutations = original
        self.assertEqual(
            calls,
            [],
            "itertools.permutations must NOT be called for an over-cap "
            "block — the gate is an int compare, not len(list(permute))",
        )

    def test_cap_gap_surfaced_once_per_block_via_classifier(self):
        """The structured cap gap reaches authors exactly once: a synthetic
        block-keyed entry in classify_all_items carries the gap, and it is
        emitted once per block (dedup)."""
        builder = _build_static("sample_over_cap.qml")
        classifier = ItemClassifier(builder)
        results = classifier.classify_all_items()
        self.assertIn("big_sample", results)
        block_gaps = results["big_sample"]["coverage_gaps"]
        self.assertEqual(len(block_gaps), 1)
        self.assertEqual(block_gaps[0]["kind"], "sample_cap")
        # Re-recording for the same block is a no-op (dedup).
        builder._record_sample_cap_gap("big_sample", 8)
        self.assertEqual(len(builder.coverage_gaps["big_sample"]), 1)

    def test_is_random_false_twenty_items_no_cap(self):
        """AE5: sample_no_random_many.qml — is_random=false, 20 independent
        items. T=20 > 7 but R10 applies: NO cap (is_random-only), single
        canonical order (k=0), all 20 conditionally-present, no gap."""
        builder = _build_static("sample_no_random_many.qml")
        self.assertNotIn("many_sample", builder.coverage_gaps)
        self.assertEqual(_selection_keys(builder), {0})
        self.assertEqual(
            len(_cond_present_items(builder)), 20, "all 20 present"
        )


class TestSampleBlockConditions(unittest.TestCase):
    """Integration: block precondition × conditional-presence × ordering."""

    def test_block_precondition_and_postcondition_present_gated(self):
        """sample_block_condition.qml: block-level precondition gates the
        whole block and block-level postcondition applies to drawn items
        only. Both inner items are conditionally-present and the composed
        (block+item) conditions are emitted under the present gate (the build
        succeeds and the items are not NEVER/dead-code — the gate makes the
        block-precondition-false world satisfiable rather than dead)."""
        builder = _build_static("sample_block_condition.qml")
        self.assertEqual(
            _cond_present_items(builder), {"q_p", "q_q"}
        )
        self.assertEqual(_selection_keys(builder), {0})
        classifier = ItemClassifier(builder)
        for iid in ("q_p", "q_q"):
            status = classifier.classify_item(iid)["precondition"]["status"]
            self.assertNotEqual(status, "NEVER")

    def test_empty_block_base_case_one_ordering_no_divide_by_zero(self):
        """Edge: a Sample block with zero inner items must not crash and must
        not call itertools.permutations. The schema forbids authoring an
        empty block (minItems:1), so this state is synthesized directly. With
        no flat items carrying `_sample_block_id` the pass early-returns
        before building the topology — proving the no-crash / no-permute /
        no-gap contract holds for the degenerate count base case (T → one
        empty ordering, never a divide-by-zero or a permutation of [])."""
        state = QMLState(
            {
                "qmlVersion": "1.0",
                "questionnaire": {
                    "title": "synthetic empty sample",
                    "blocks": [
                        {
                            "id": "empty_block",
                            "kind": "Sample",
                            "count": 1,
                            "is_random": True,
                            "items": [],
                        }
                    ],
                    "items": [],
                },
            }
        )
        calls: list = []
        original = itertools.permutations

        def spy(*args, **kwargs):
            calls.append(args)
            return original(*args, **kwargs)

        itertools.permutations = spy
        try:
            builder = StaticBuilder(state)
        finally:
            itertools.permutations = original
        # No items → no Sample selection keys, no gap, no permutation, no
        # ZeroDivisionError.
        self.assertEqual(builder._conditionally_present, set())
        self.assertNotIn("empty_block", builder.coverage_gaps)
        self.assertEqual(calls, [])


if __name__ == "__main__":
    unittest.main()
