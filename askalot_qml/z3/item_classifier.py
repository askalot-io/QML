import logging
from typing import Any

from z3 import (
    BoolRef,
    Not,
    Solver,
    unsat,
)

from askalot_qml.z3.static_builder import StaticBuilder

# Import profiling - graceful fallback if not available
try:
    from askalot_common.profiling import add_profiling_tags, profile_block, remove_profiling_tags
except ImportError:
    from contextlib import contextmanager

    @contextmanager
    def profile_block(name, tags=None):
        yield

    def add_profiling_tags(tags):
        pass

    def remove_profiling_tags(keys):
        pass


class ItemClassifier:
    """
    Computes separate classifications for each item:
    - Precondition reachability: ALWAYS | CONDITIONAL | NEVER
    - Postcondition invariant (relative to P): TAUTOLOGICAL | CONSTRAINING | INFEASIBLE
    - Global Q flags: q_globally_true | q_globally_false
    """

    def __init__(self, builder: StaticBuilder):
        self.logger = logging.getLogger(__name__)
        self.builder = builder
        self.ctx = builder.ctx

    def classify_item(self, item_id: str) -> dict[str, Any]:
        """Classify a single item using Z3 SMT solver."""
        with profile_block("z3_classify_item", {"item_id": item_id}):
            if item_id not in self.builder.item_details:
                return {
                    "precondition": {"status": "UNKNOWN"},
                    "postcondition": {
                        "invariant": "UNKNOWN",
                        "vacuous": False,
                        "global": {"q_globally_true": False, "q_globally_false": False},
                    },
                    "coverage_gaps": [],
                }

            details = self.builder.item_details[item_id]

            # Check if item has postconditions
            has_postconditions = bool(details["postconditions"])

            # Compile precondition and postcondition using the shared helper
            with profile_block("z3_compile_conditions", {"item_id": item_id}):
                P_form: BoolRef = self.builder.compile_conditions(item_id, details["preconditions"])  # type: ignore
                Q_form: BoolRef = self.builder.compile_conditions(
                    item_id, details["postconditions"]
                )  # type: ignore

            # Use domain-only base constraint B for precondition checks
            # B := ∧_i D_i(S_i) where D_i are domain constraints (min/max, enumeration)
            domain_base = self.builder.get_domain_base()

            # Use full base (domain + behavioral) for postcondition checks
            # This includes SSA constraints from codeBlocks, enabling proper
            # bounds checking for computed variables like var1 = q1 + q2
            full_base = self.builder.get_full_base()

            # ------------------------------
            # Precondition reachability
            # ALWAYS  iff  UNSAT(base ∧ ¬P)
            # NEVER   iff  UNSAT(base ∧ P)
            # else CONDITIONAL
            # ------------------------------
            with profile_block("z3_precondition_check", {"item_id": item_id}):
                s_always = Solver(ctx=self.ctx)
                s_always.add(domain_base, Not(P_form))
                precondition_always = s_always.check() == unsat

                s_never = Solver(ctx=self.ctx)
                s_never.add(domain_base, P_form)
                precondition_never = s_never.check() == unsat

            # U2 classification-safety (R5/R7): an item registered as
            # conditionally-present (Sample draw / Roster bit) is
            # *sampling-absent*, not dead code. Its precondition being
            # unsatisfiable in isolation only means "this item is not drawn",
            # which is legitimate — the validation question for such items is
            # "IF drawn, is it well-typed and are its conditions SAT", never
            # "is it always reachable". So NEVER is demoted to CONDITIONAL:
            # the item is drawn on some selections and absent on others. An
            # ALWAYS result is likewise impossible for a conditionally-present
            # item (it can always be skipped), so clamp that too.
            if self.builder.is_conditionally_present(item_id):
                pre_status = "CONDITIONAL"
            elif precondition_always:
                pre_status = "ALWAYS"
            elif precondition_never:
                pre_status = "NEVER"
            else:
                pre_status = "CONDITIONAL"

            # ------------------------------
            # Postcondition invariants (relative to P)
            # Only items with postconditions can have TAUTOLOGICAL/INFEASIBLE/CONSTRAINING classifications
            # TAUTOLOGICAL: UNSAT(base ∧ P ∧ ¬Q)  i.e., B ∧ P ⊨ Q
            # INFEASIBLE:   UNSAT(base ∧ P ∧ Q)
            # CONSTRAINING: otherwise (both SAT for P∧Q and P∧¬Q)
            # ------------------------------
            vacuous = pre_status == "NEVER"

            # Compute postcondition classification only for items with postconditions
            if not has_postconditions:
                # Items without postconditions should not have these classifications
                post_invariant = "NONE"
            elif not vacuous:
                # Item has postconditions and is reachable
                # Use full_base to include behavioral constraints from codeBlocks
                with profile_block("z3_postcondition_check", {"item_id": item_id}):
                    s_impl = Solver(ctx=self.ctx)
                    s_impl.add(full_base, P_form, Not(Q_form))
                    tautological_under_P = s_impl.check() == unsat

                    s_feas = Solver(ctx=self.ctx)
                    s_feas.add(full_base, P_form, Q_form)
                    infeasible_under_P = s_feas.check() == unsat

                if tautological_under_P:
                    post_invariant = "TAUTOLOGICAL"
                elif infeasible_under_P:
                    post_invariant = "INFEASIBLE"
                else:
                    post_invariant = "CONSTRAINING"
            else:
                # Vacuous w.r.t. P (NEVER reachable); keep label informative
                post_invariant = "TAUTOLOGICAL"

            # ------------------------------
            # Global Q flags (only meaningful for items with postconditions)
            # q_globally_false: UNSAT(full_base ∧ Q)
            # q_globally_true:  UNSAT(full_base ∧ ¬Q)
            # Use full_base to include behavioral constraints from codeBlocks
            # ------------------------------
            if has_postconditions:
                with profile_block("z3_global_flags_check", {"item_id": item_id}):
                    s_q_false = Solver(ctx=self.ctx)
                    s_q_false.add(full_base, Q_form)
                    q_globally_false = s_q_false.check() == unsat

                    s_q_true = Solver(ctx=self.ctx)
                    s_q_true.add(full_base, Not(Q_form))
                    q_globally_true = s_q_true.check() == unsat
            else:
                # Items without postconditions have no global Q flags
                q_globally_false = False
                q_globally_true = False

            # R13: surface coverage gaps recorded by the static builder so the
            # human author — not just application logs — sees which conditions
            # fell back to runtime enforcement.
            coverage_gaps = list(self.builder.coverage_gaps.get(item_id, []))

            # U4: propagate block-level sample_cap gaps to per-item results so
            # a consumer that classifies item-by-item (rather than via
            # classify_all_items) sees the cap rejection on every inner item,
            # not only on the synthetic block-keyed entry.
            raw_item = self.builder.state.get_item(item_id)
            sample_block_id = raw_item.get("_sample_block_id") if raw_item else None
            if sample_block_id is not None:
                for gap in self.builder.coverage_gaps.get(sample_block_id, []):
                    if gap not in coverage_gaps:
                        coverage_gaps.append(gap)

            return {
                "precondition": {"status": pre_status},
                "postcondition": {
                    "invariant": post_invariant,
                    "vacuous": vacuous,
                    "global": {
                        "q_globally_true": q_globally_true,
                        "q_globally_false": q_globally_false,
                    },
                },
                "coverage_gaps": coverage_gaps,
            }

    def classify_all_items(self) -> dict[str, Any]:
        """Classify all items using Z3 SMT solver.

        Block-level coverage gaps (U4: the R9 ``sample_cap`` reject — keyed by
        a Sample block_id, not an item_id) are surfaced ONCE here as a
        synthetic result entry keyed by the block_id. A block over the
        randomization cap is never solved, so it has no per-item
        classification; the synthetic entry carries only its ``coverage_gaps``
        list so authors (diagram / validation report) see exactly which block
        was rejected and why. The loud WARNING was already emitted once at
        record time by ``StaticBuilder._record_sample_cap_gap``.
        """
        with profile_block("z3_classify_all_items", {"item_count": len(self.builder.item_order)}):
            results: dict[str, Any] = {}
            for item_id in self.builder.item_order:
                results[item_id] = self.classify_item(item_id)

            # Surface block-level gaps (keys in builder.coverage_gaps that are
            # NOT real items — currently only the U4 sample_cap reject). Emit
            # once per block; never overwrites a real item classification
            # because block_id is disjoint from item_order.
            item_keys = set(self.builder.item_order)
            for key, gaps in self.builder.coverage_gaps.items():
                if key in item_keys or key in results:
                    continue
                results[key] = {
                    "precondition": {"status": "UNKNOWN"},
                    "postcondition": {
                        "invariant": "UNKNOWN",
                        "vacuous": False,
                        "global": {"q_globally_true": False, "q_globally_false": False},
                    },
                    "coverage_gaps": list(gaps),
                }
            return results
