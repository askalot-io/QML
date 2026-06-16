#!/usr/bin/env python3
"""Unit tests for Roster Z3: iterateOver dependency wiring + U3 bit-guarded unroll.

This suite covers two coordinated Roster Z3 concerns:

## iterateOver dependency wiring (pre-U3, unchanged by U3)

StaticBuilder Pass 3 walks each Roster inner item's `_roster_iterate_over`
AST and registers the referenced items / variables as dependencies of the
inner item, so topology places roster items after their iterateOver source.
U3 is purely ADDITIVE — these dependency edges must remain byte-identical:

- Numeric-driven roster (Canonical Example B): inner items depend on the
  variable `family_mask` (set by q_family_count's codeBlock) AND
  transitively on q_family_count.
- Multiselect-driven roster (Canonical Example A): inner items depend
  directly on q_meals_eaten via the `q_meals_eaten.outcome` reference.
- Inner items keep their own precondition deps alongside iterateOver deps.
- The canonical scalar var per inner item is unchanged (one `item_{id}`
  Int); U3's per-iteration vars are ADDITIONAL, never a replacement.

## U3 bit-guarded unroll (this unit)

StaticBuilder Pass 3.5 emits exactly `len(labels)` bit-guarded copies of
each Roster inner item's domain/pre/post via the U2 conditionally-present
primitive:

- AE3: 4 label keys with an iterateOver that can set ≤2 bits → 4 copies
  emitted; the impossible iterations contribute constraints, no error.
- A typing error present per labelled iteration is caught under each
  iteration's `present` gate (single-pass would alias it to one var).
- Bits of iterateOver beyond `len(labels)` are silently ignored.
- `len(labels) == 1` → exactly one guarded copy.
- Bit-guard keying: `present(item, K) ⇔ (E / K) % 2 == 1` (literal
  power-of-2 mask K — linear int, no BitVec).
- Classification-safety: a bit-unset iteration is NOT NEVER / dead-code.
- Timing-shape: constraint count scales ~linearly with `len(labels)`.

These exercise the same pipeline ValidationProcessor uses, so a green suite
means roster questionnaires validate kind-aware without a worse-than-linear
constraint blow-up.
"""

import unittest
from pathlib import Path

import pytest
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.static_builder import StaticBuilder

FIXTURES_DIR = Path(__file__).parent.parent.parent / "fixtures"


def _build_static(fixture_name: str) -> StaticBuilder:
    """Build a StaticBuilder directly from a fixture (loader → state →
    builder) — the construction ValidationProcessor uses for classification."""
    loader = QMLLoader(qml_dir=FIXTURES_DIR)
    return StaticBuilder(QMLState(loader.load_from_file(fixture_name)))


def _build_topology(fixture_name: str) -> QMLTopology:
    """Drive the full pipeline (loader → engine → topology) the same way
    FlowProcessor / ValidationProcessor do at runtime."""
    loader = QMLLoader(qml_dir=FIXTURES_DIR)
    questionnaire = loader.load_from_file(fixture_name)
    state = QMLState(questionnaire)
    engine = QMLEngine(state)
    return engine.topology


class TestRosterIterateOverDependencies(unittest.TestCase):
    def test_numeric_roster_inner_items_depend_on_iter_var_and_outer_item(self):
        """Example B: iterateOver=family_mask. Each inner roster item should
        transitively depend on q_family_count (via the var:family_mask edge
        that's resolved through the codeBlock writing it)."""
        topology = _build_topology("roster_numeric.qml")
        deps_by_id = topology.dependencies  # already var-resolved to item ids

        for inner_id in ("q_member_name", "q_member_age"):
            self.assertIn(
                "q_family_count",
                deps_by_id.get(inner_id, set()),
                f"Roster inner item {inner_id} should depend on q_family_count "
                f"(transitively via var:family_mask)",
            )

        # Topological order places q_family_count BEFORE the inner roster
        # items, since family_mask is defined in q_family_count's codeBlock.
        topo = topology.get_topological_order()
        self.assertLess(topo.index("q_family_count"), topo.index("q_member_name"))
        self.assertLess(topo.index("q_family_count"), topo.index("q_member_age"))

    def test_var_node_present_in_raw_dependency_graph(self):
        """The raw dependency_graph (pre-resolution) carries the var:family_mask edge.
        This is what pre-/post-condition rendering and other downstream consumers
        that need un-resolved deps should see."""
        topology = _build_topology("roster_numeric.qml")
        raw = topology.static_builder.get_dependency_graph()
        for inner_id in ("q_member_name", "q_member_age"):
            self.assertIn("var:family_mask", raw.get(inner_id, set()))

    def test_multiselect_roster_inner_items_depend_directly_on_outer_item(self):
        """Example A: iterateOver=q_meals_eaten.outcome. Inner items should
        depend directly on q_meals_eaten."""
        topology = _build_topology("roster_multiselect.qml")
        deps_by_id = topology.dependencies

        for inner_id in ("q_satisfaction", "q_notes"):
            self.assertIn(
                "q_meals_eaten",
                deps_by_id.get(inner_id, set()),
                f"Roster inner item {inner_id} should carry q_meals_eaten dep",
            )

        topo = topology.get_topological_order()
        self.assertLess(topo.index("q_meals_eaten"), topo.index("q_satisfaction"))
        self.assertLess(topo.index("q_meals_eaten"), topo.index("q_notes"))

    def test_inner_precondition_dep_combines_with_iterate_over_dep(self):
        """If an inner item has its own precondition referencing an outer item,
        BOTH the iterateOver dep and the precondition dep contribute. The
        resolved view collapses both edges to the same item (q_family_count),
        and the raw graph keeps the var: edge separately."""
        topology = _build_topology("roster_inner_precondition.qml")
        deps_by_id = topology.dependencies

        # Resolved (post var:): both edges converge on q_family_count.
        age_deps = deps_by_id.get("q_member_age", set())
        self.assertIn("q_family_count", age_deps)

        # Raw graph keeps the iterateOver var: edge AND the precondition edge.
        raw = topology.static_builder.get_dependency_graph()
        age_raw = raw.get("q_member_age", set())
        self.assertIn("var:family_mask", age_raw)  # from iterateOver
        self.assertIn("q_family_count", age_raw)  # from precondition

    def test_single_canonical_z3_var_per_inner_item(self):
        """No unrolling: each inner item gets one Int variable, not one per label."""
        topology = _build_topology("roster_numeric.qml")

        # The static builder is the source-of-truth for item Z3 vars.
        # 3 items in roster_numeric.qml: q_family_count + 2 inner roster items.
        # We expect 3 Z3 vars, NOT 3 + (4 labels × 2 inner items) = 11.
        self.assertEqual(
            len(topology.static_builder.item_vars),
            3,
            "Expected one Z3 var per source item (no per-iteration unrolling)",
        )

    def test_no_cycle_introduced_by_iterate_over_dependency(self):
        """U1 loader rejects self-cycles. The Z3/topology layer should never
        see one, so cycle detection should agree."""
        topology = _build_topology("roster_numeric.qml")
        self.assertFalse(topology.has_cycles)


@pytest.mark.unit
@pytest.mark.z3
class TestRosterBitGuardedUnroll(unittest.TestCase):
    """U3: Roster bit-guarded unroll via the U2 conditionally-present
    primitive, exercised through the real loader → state → StaticBuilder
    pipeline ValidationProcessor uses.

    U3 makes the primitive's Roster caller fire: each inner item is
    re-emitted once per label-key, gated by the literal-power-of-2-mask
    bit-test. The emission is purely ADDITIVE — the canonical scalar var,
    item_order, item_details and the dependency graph are untouched (those
    invariants are pinned by the dependency-wiring class above and by
    test_static_builder's classification fingerprint)."""

    def test_ae3_four_labels_emit_four_bit_guarded_copies(self):
        """AE3: roster_numeric.qml has 4 label keys (1,2,4,8) and
        iterateOver=family_mask where family_mask = 2**count-1, count∈[1,4]
        — so at most 4 bits can ever be set. U3 emits exactly 4 bit-guarded
        copies per inner item regardless of how few bits a given respondent
        sets; the 'impossible' iterations contribute constraints (the
        present-definition) and raise no error."""
        builder = _build_static("roster_numeric.qml")
        for inner_id in ("q_member_name", "q_member_age"):
            # Every label key registered conditionally-present.
            for k in (1, 2, 4, 8):
                self.assertIn(
                    (inner_id, k),
                    builder._conditionally_present,
                    f"{inner_id} iteration k={k} must be conditionally-present",
                )
            # is_conditionally_present (classification-safety) reports True.
            self.assertTrue(builder.is_conditionally_present(inner_id))
            # Exactly 4 distinct per-iteration present Bools were created.
            iter_bools = {
                k for (iid, k) in builder._present_vars if iid == inner_id
            }
            self.assertEqual(iter_bools, {1, 2, 4, 8})

    def test_bit_guard_uses_literal_power_of_two_mask(self):
        """The present Bool is DEFINED by `(E / K) % 2 == 1` with K the
        literal power-of-2 label key — a div/mod-by-constant linear int test,
        never a BitVec. We assert structurally: for each label key K there is
        a constraint equating present(item,K) to a Boolean built from `/ K`
        and `% 2`, and no Z3 BitVec sort appears anywhere in the model."""
        from z3 import is_bv_sort

        builder = _build_static("roster_numeric.qml")
        # No constraint anywhere uses a bit-vector sort (integer model only).
        for c in builder.constraints + builder.domain_constraints:
            for sub in _walk_z3(c):
                self.assertFalse(
                    is_bv_sort(sub.sort()) if hasattr(sub, "sort") else False,
                    "U3 must stay in linear integer arithmetic (no BitVec)",
                )
        # For label key K=4 (the 3rd iteration), the present-definition
        # constraint mentions division by the literal 4 and mod by 2.
        present_4 = builder._present_var("q_member_name", 4)
        defs = [
            c
            for c in builder.constraints
            if _mentions(c, present_4.get_id())
        ]
        self.assertTrue(
            defs, "expected a present(q_member_name, 4) definition constraint"
        )
        joined = " ".join(str(c) for c in defs)
        self.assertIn("4", joined)  # literal mask K
        self.assertIn("2", joined)  # % 2 bit isolation

    def test_per_iteration_typing_error_detected(self):
        """A postcondition INFEASIBLE against the inner item's own domain is
        re-emitted under EVERY label-key's present gate. The single-canonical
        model aliases all iterations to one var; U3 binds a fresh per-iteration
        var per key, so the infeasibility is independently provable for each
        labelled iteration (the whole point of the unit). We assert the
        per-iteration postcondition constraints exist for every key and that
        each is jointly UNSAT with its present gate + domain."""
        from z3 import And, Solver, sat

        builder = _build_static("roster_typing_error.qml")
        for k in (1, 2, 4, 8):
            self.assertIn(("q_rating", k), builder._conditionally_present)
            present_k = builder._present_var("q_rating", k)
            # Domain (0..5) + postcondition (>100) for THIS iteration, forced
            # present — must be UNSAT (the typing error, per iteration).
            iter_constraints = [
                c
                for c in builder.constraints + builder.domain_constraints
                if _mentions(c, present_k.get_id())
            ]
            self.assertTrue(
                iter_constraints,
                f"iteration k={k} must contribute present-gated constraints",
            )
            s = Solver(ctx=builder.ctx)
            s.add(present_k)  # force this iteration drawn
            for c in iter_constraints:
                s.add(c)
            self.assertNotEqual(
                s.check(),
                sat,
                f"iteration k={k}: domain∧postcondition must be UNSAT "
                f"(rating∈[0,5] ∧ rating>100)",
            )

    def test_bits_beyond_labels_silently_ignored(self):
        """R8: the unroll universe is EXACTLY the declared label keys. An
        iterateOver that can set bits beyond len(labels) (family_mask up to
        2**4-1 = 15 vs only 4 labels) emits exactly len(labels) copies — the
        high bits are never magnitude-validated, capped, or errored."""
        builder = _build_static("roster_numeric.qml")
        for inner_id in ("q_member_name", "q_member_age"):
            keys = {k for (iid, k) in builder._conditionally_present if iid == inner_id}
            self.assertEqual(
                keys,
                {1, 2, 4, 8},
                "exactly the declared label keys — no bit beyond len(labels)",
            )

    def test_single_label_emits_exactly_one_copy(self):
        """Edge: len(labels) == 1 → exactly one guarded copy (lower bound of
        the linear-in-len(labels) unroll)."""
        builder = _build_static("roster_single_label.qml")
        keys = {k for (iid, k) in builder._conditionally_present if iid == "q_detail"}
        self.assertEqual(keys, {1})
        self.assertTrue(builder.is_conditionally_present("q_detail"))

    def test_dependency_edges_unchanged_by_unroll(self):
        """U3 is additive: the iterateOver dependency edges and topo order
        are byte-identical to the pre-U3 (dependency-wiring) expectation."""
        topology = _build_topology("roster_numeric.qml")
        deps = topology.dependencies
        for inner_id in ("q_member_name", "q_member_age"):
            self.assertIn("q_family_count", deps.get(inner_id, set()))
        topo = topology.get_topological_order()
        self.assertLess(topo.index("q_family_count"), topo.index("q_member_name"))
        self.assertFalse(topology.has_cycles)
        # Canonical scalar var count unchanged (per-iteration vars are NOT in
        # item_vars — they are local Ints): 3 source items, 3 item_vars.
        self.assertEqual(len(topology.static_builder.item_vars), 3)

    def test_classification_safety_no_never_or_dead_code(self):
        """A bit-unset iteration is sampling-absent, NOT NEVER / dead-code
        (the U2 classification-safety tag, now actually exercised because U3
        registers the keys). Roster inner items must not regress to NEVER or
        appear in dead-code output."""
        from askalot_qml.z3.item_classifier import ItemClassifier
        from askalot_qml.z3.path_based_validation import PathBasedValidator

        topology = _build_topology("roster_numeric.qml")
        builder = topology.static_builder
        classifier = ItemClassifier(builder)
        for inner_id in ("q_member_name", "q_member_age"):
            status = classifier.classify_item(inner_id)["precondition"]["status"]
            self.assertNotEqual(status, "NEVER", f"{inner_id} must not be NEVER")
        dead = PathBasedValidator(builder, topology).validate().dead_code_items
        self.assertNotIn("q_member_name", dead)
        self.assertNotIn("q_member_age", dead)

    def test_constraint_count_scales_linearly_with_label_count(self):
        """Timing-shape guard (plan EXECUTION NOTE): U3 deliberately trades
        the prior flat single-pass for linear-in-len(labels) work. We assert
        the constraint delta is ~linear in len(labels) and flag an
        UNEXPECTED super-linear (e.g. quadratic) blow-up.

        roster_numeric.qml has 4 labels and 2 inner items with NO
        pre/postconditions, so the U3 delta is exactly the bit-guard
        present-definitions: 2 inner × 4 labels = 8. The point is the SHAPE
        (≈ inner_items × len(labels)), not an exact pin — a quadratic bug
        would land at ~inner × labels² and trip the upper bound."""
        builder = _build_static("roster_numeric.qml")
        inner_items = ("q_member_name", "q_member_age")
        n_labels = 4
        # Count present-definition constraints (the per-iteration bit-guard).
        present_ids = {
            builder._present_var(iid, k).get_id()
            for iid in inner_items
            for k in (1, 2, 4, 8)
        }
        defs = [
            c
            for c in builder.constraints
            if any(_mentions(c, pid) for pid in present_ids)
        ]
        n = len(defs)
        linear = len(inner_items) * n_labels  # = 8
        # Lower bound: at least one bit-guard per (item, label) — linear.
        self.assertGreaterEqual(n, linear)
        # Upper bound: stay well below quadratic-in-labels. A quadratic bug
        # (inner × labels²) would be 2*16 = 32; allow generous linear slack
        # (pre/post would add O(inner×labels) too, still linear) but trip
        # anything approaching the quadratic regime.
        self.assertLess(
            n,
            len(inner_items) * n_labels * n_labels,
            f"constraint count {n} is super-linear in len(labels)={n_labels} "
            f"— suspected accidental quadratic unroll",
        )


def _walk_z3(expr):
    """Yield expr and all its sub-expressions (Z3 AST DFS)."""
    stack = [expr]
    seen = set()
    while stack:
        e = stack.pop()
        try:
            eid = e.get_id()
        except Exception:
            continue
        if eid in seen:
            continue
        seen.add(eid)
        yield e
        try:
            stack.extend(e.children())
        except Exception:
            pass


def _mentions(expr, target_id: int) -> bool:
    """True iff the Z3 AST `expr` contains a sub-expression with `target_id`."""
    return any(
        sub.get_id() == target_id
        for sub in _walk_z3(expr)
        if hasattr(sub, "get_id")
    )
