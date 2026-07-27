import logging
from typing import Any

from z3 import (
    BoolRef,
    Not,
    Solver,
    unsat,
)

from askalot_qml.z3.static_builder import StaticBuilder

from askalot_common.profiling import add_profiling_tags, profile_block, remove_profiling_tags


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

    def classify_item(
        self,
        item_id: str,
        *,
        reachability_solver: Solver | None = None,
        full_solver: Solver | None = None,
    ) -> dict[str, Any]:
        """Classify a single item using Z3 SMT solver.

        ``reachability_solver`` / ``full_solver`` are optional persistent solvers
        with the reachability / full base already asserted. When classifying every item
        (``classify_all_items``) they are built once and shared, and each
        per-item check is wrapped in ``push()`` / ``pop()`` so the base — one
        constraint per item — is asserted a single time total rather than
        re-asserted for every item. That is the difference between O(items) and
        O(items^2) Z3 work. When omitted (standalone single-item use) they are
        built on demand, so the public API is unchanged.
        """
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

            # Persistent base solvers. The reachability base B := ∧_i D_i(S_i)
            # (min/max, enumeration) PLUS frozen-variable constants — a variable
            # initialized in codeInit and never reassigned holds its constant, so
            # a gate on it is statically decidable (U2). The full base (B ∧
            # codeBlock SSA constraints) drives postcondition and global checks,
            # so computed variables like var1 = q1 + q2 are properly bounded.
            # Per-check constraints go in under push()/pop() so the base is
            # asserted once, never per item (see the docstring).
            if reachability_solver is None:
                reachability_solver = Solver(ctx=self.ctx)
                reachability_solver.add(self.builder.get_reachability_base())
            if full_solver is None:
                full_solver = Solver(ctx=self.ctx)
                full_solver.add(self.builder.get_full_base())

            # ------------------------------
            # Precondition reachability
            # ALWAYS  iff  UNSAT(base ∧ ¬P)
            # NEVER   iff  UNSAT(base ∧ P)
            # else CONDITIONAL
            # ------------------------------
            with profile_block("z3_precondition_check", {"item_id": item_id}):
                reachability_solver.push()
                reachability_solver.add(Not(P_form))
                precondition_always = reachability_solver.check() == unsat
                reachability_solver.pop()

                reachability_solver.push()
                reachability_solver.add(P_form)
                precondition_never = reachability_solver.check() == unsat
                reachability_solver.pop()

            # Classification-safety: an item registered as
            # conditionally-present (capped-Group draw / Roster bit) is
            # *selection-absent*, not dead code. Its precondition being
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
                    full_solver.push()
                    full_solver.add(P_form, Not(Q_form))
                    tautological_under_P = full_solver.check() == unsat
                    full_solver.pop()

                    full_solver.push()
                    full_solver.add(P_form, Q_form)
                    infeasible_under_P = full_solver.check() == unsat
                    full_solver.pop()

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
                    full_solver.push()
                    full_solver.add(Q_form)
                    q_globally_false = full_solver.check() == unsat
                    full_solver.pop()

                    full_solver.push()
                    full_solver.add(Not(Q_form))
                    q_globally_true = full_solver.check() == unsat
                    full_solver.pop()
            else:
                # Items without postconditions have no global Q flags
                q_globally_false = False
                q_globally_true = False

            # R13: surface coverage gaps recorded by the static builder so the
            # human author — not just application logs — sees which conditions
            # fell back to runtime enforcement.
            coverage_gaps = list(self.builder.coverage_gaps.get(item_id, []))

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

        Block-level coverage gaps (keyed by a block_id, not an item_id) are
        surfaced ONCE here as a synthetic result entry keyed by the block_id.
        Such a block has no per-item classification of its own; the synthetic
        entry carries only its ``coverage_gaps`` list so authors (diagram /
        validation report) see exactly which block was flagged and why. The
        loud WARNING is emitted once at record time by the gap recorder.
        """
        with profile_block("z3_classify_all_items", {"item_count": len(self.builder.item_order)}):
            # Build the two base solvers once and share them across every item.
            # classify_item adds its per-item constraints under push()/pop(), so
            # the base (one domain constraint per item) is asserted a single time
            # rather than rebuilt and re-asserted for each item — turning an
            # O(items^2) classification pass into an O(items) one.
            reachability_solver = Solver(ctx=self.ctx)
            reachability_solver.add(self.builder.get_reachability_base())
            full_solver = Solver(ctx=self.ctx)
            full_solver.add(self.builder.get_full_base())

            results: dict[str, Any] = {}
            for item_id in self.builder.item_order:
                results[item_id] = self.classify_item(
                    item_id, reachability_solver=reachability_solver, full_solver=full_solver
                )

            # Surface block-level gaps (keys in builder.coverage_gaps that are
            # NOT real items — block_id-keyed entries). Emit once per block;
            # never overwrites a real item classification because block_id is
            # disjoint from item_order.
            # `results` is keyed exactly by `item_order` at this point, so
            # `key in results` is a subset of `key in item_keys` — the latter
            # alone is sufficient to skip real-item keys.
            item_keys = set(self.builder.item_order)
            for key, gaps in self.builder.coverage_gaps.items():
                if key in item_keys:
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
