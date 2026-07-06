"""
PathBasedValidator - Path-Based Validation for QML Questionnaires

Implements accumulated reachability analysis from the thesis:
    A_i := B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)

Where:
- B: Base constraints (domain constraints for all outcome variables)
- Pred(i): Set of predecessor items in the topological order
- P_j, Q_j: Precondition and postcondition for predecessor item I_j

An item is accumulated-reachable if SAT(A_i ∧ P_i).
If UNSAT(A_i ∧ P_i) for a CONDITIONAL item, it is dead code.

This is the third and most thorough level of the validation hierarchy:
1. Per-item validation - checks each item independently
2. Global validation - checks if any valid completion exists
3. Path-based validation - detects dead code from accumulated constraints

Reference: askalot-research/thesis/chapters/comprehensive_validation.tex, Definition 2.5
"""

import logging
from dataclasses import dataclass, field
from typing import TYPE_CHECKING

from z3 import BoolRef, Implies, Not, Solver, sat, unsat

from askalot_qml.z3.static_builder import StaticBuilder

if TYPE_CHECKING:
    from askalot_qml.core.qml_topology import QMLTopology


@dataclass
class ItemReachabilityResult:
    """Result of accumulated reachability check for a single item."""

    item_id: str
    per_item_status: str  # ALWAYS, CONDITIONAL, NEVER (from per-item check)
    accumulated_reachable: bool
    is_dead_code: bool  # True if CONDITIONAL per-item but not accumulated-reachable
    predecessors: list[str] = field(default_factory=list)
    message: str = ""


@dataclass
class PathValidationResult:
    """Result of path-based validation for entire questionnaire."""

    has_dead_code: bool
    dead_code_items: list[str] = field(default_factory=list)
    item_results: dict[str, ItemReachabilityResult] = field(default_factory=dict)
    message: str = ""


class PathBasedValidator:
    """
    Path-based validation for detecting dead code in questionnaires.

    Detects items that are CONDITIONAL per-item (precondition can be satisfied
    in isolation) but become unreachable due to accumulated postconditions
    from predecessor items.

    Example from thesis:
        I_1: postcondition Q_1 = (S_1 > 50)
        I_2: precondition P_2 = (S_1 < 30)

        Per-item: P_2 is CONDITIONAL (SAT for S_1 < 30)
        Accumulated: A_2 ∧ P_2 = B ∧ (S_1 > 50) ∧ (S_1 < 30) is UNSAT
        Result: I_2 is dead code

    Theorem (Global Necessary): If UNSAT(F), then all paths are invalid.
    Theorem (Global Not Sufficient): SAT(F) doesn't guarantee all items reachable.
    """

    def __init__(self, builder: StaticBuilder, topology: "QMLTopology"):
        """
        Initialize path-based validator.

        Args:
            builder: StaticBuilder with compiled constraints and item details
            topology: QMLTopology with dependency graph and topological order
        """
        self.logger = logging.getLogger(__name__)
        self.builder = builder
        self.topology = topology
        self.ctx = builder.ctx

    def validate(self) -> PathValidationResult:
        """
        Perform path-based validation on all items.

        For each item with CONDITIONAL precondition:
        1. Compute Pred(i) = predecessors in topological order
        2. Build A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)
        3. Check SAT(A_i ∧ P_i)
        4. If UNSAT, item is dead code

        Returns:
            PathValidationResult with dead code detection results
        """
        item_results = {}
        dead_code_items = []
        topological_order = self.topology.get_topological_order() or []

        # Build predecessor map from topological order
        predecessors_map = self._build_predecessors_map(topological_order)

        # Pre-compile each item's (P_i, Q_i) once and assert the domain base once
        # into a single persistent solver, then reuse both across every per-item
        # check. An item that is a predecessor of M others would otherwise have
        # its P/Q recompiled M times, and the domain base rebuilt and re-asserted
        # once per item — O(items^2) of redundant Z3 work. compile_conditions
        # reads the now-frozen SSA versions, so a single build yields expressions
        # identical to the per-call ones; per-item constraints are scoped with
        # push()/pop() so the shared base is never disturbed.
        base = self.builder.get_domain_base()
        compiled_conditions: dict[str, tuple[BoolRef, BoolRef]] = {
            iid: (
                self.builder.compile_conditions(iid, details["preconditions"]),
                self.builder.compile_conditions(iid, details["postconditions"]),
            )
            for iid, details in self.builder.item_details.items()
        }
        solver = Solver(ctx=self.ctx)
        solver.add(base)

        for item_id in topological_order:
            result = self._check_item_reachability(
                item_id, predecessors_map, solver, compiled_conditions
            )
            item_results[item_id] = result

            if result.is_dead_code:
                dead_code_items.append(item_id)

        has_dead_code = len(dead_code_items) > 0
        message = (
            f"Found {len(dead_code_items)} dead code items."
            if has_dead_code
            else "No dead code detected. All conditional items are reachable."
        )

        return PathValidationResult(
            has_dead_code=has_dead_code,
            dead_code_items=dead_code_items,
            item_results=item_results,
            message=message,
        )

    def _build_predecessors_map(self, topological_order: list[str]) -> dict[str, list[str]]:
        """
        Build Pred(i) for each item: every item earlier in the topological order.

        Per the accumulated-reachability definition, Pred(i) = {j : I_j ≺ I_i} —
        all items preceding I_i in the topological order, NOT only I_i's data-flow
        ancestors. Accumulating a non-ancestor predecessor's implication
        (P_j ⇒ Q_j) is sound: when P_j is unsatisfiable the implication is vacuous,
        and when P_j is always true (an always-present sibling) its postcondition
        Q_j genuinely constrains every execution that reaches I_i. This is what
        lets accumulated reachability catch dead code whose killing constraint is
        carried by an always-present sibling rather than a direct ancestor (e.g.
        a tax-bracket postcondition that forces a lower bound on income, making a
        sibling low-income item unreachable).

        Consequently dead-code detection depends on the topological order.
        QMLTopology emits a deterministic stable-Kahn order (keyed by QML file
        index) — the same canonical order the runtime FlowProcessor follows — so
        the result is reproducible for a given questionnaire.

        Args:
            topological_order: Items in topological order

        Returns:
            Dict mapping item_id to list of predecessor item_ids
        """
        return {
            item_id: list(topological_order[:idx])
            for idx, item_id in enumerate(topological_order)
        }

    def _check_item_reachability(
        self,
        item_id: str,
        predecessors_map: dict[str, list[str]],
        solver: Solver,
        compiled_conditions: dict[str, tuple[BoolRef, BoolRef]],
    ) -> ItemReachabilityResult:
        """
        Check accumulated reachability for a single item.

        Args:
            item_id: The item to check
            predecessors_map: Map of item_id to predecessor list
            solver: Shared persistent solver with the domain base B already
                asserted. Every check here is wrapped in ``push()`` / ``pop()``
                so the base is asserted once for the whole pass, not per item.
            compiled_conditions: Pre-compiled (P_i, Q_i) per item.

        Returns:
            ItemReachabilityResult for this item
        """
        details = self.builder.item_details.get(item_id)
        if not details:
            return ItemReachabilityResult(
                item_id=item_id,
                per_item_status="UNKNOWN",
                accumulated_reachable=True,
                is_dead_code=False,
                message="Item not found in builder details",
            )

        predecessors = predecessors_map.get(item_id, [])

        # First, get per-item precondition status (pre-compiled in validate()).
        P_i, _ = compiled_conditions[item_id]

        # Check per-item reachability: SAT(B ∧ P_i)?
        solver.push()
        solver.add(P_i)
        per_item_reachable = solver.check() == sat
        solver.pop()

        # Determine per-item status
        if not per_item_reachable:
            per_item_status = "NEVER"
        else:
            # Check if always reachable: UNSAT(B ∧ ¬P_i)?
            solver.push()
            solver.add(Not(P_i))
            always_reachable = solver.check() == unsat
            solver.pop()
            per_item_status = "ALWAYS" if always_reachable else "CONDITIONAL"

        # If per-item is NEVER, no need to check accumulated (already unreachable)
        if per_item_status == "NEVER":
            return ItemReachabilityResult(
                item_id=item_id,
                per_item_status=per_item_status,
                accumulated_reachable=False,
                is_dead_code=False,  # NEVER is a per-item issue, not dead code
                predecessors=predecessors,
                message="Item is NEVER reachable (per-item check)",
            )

        # If per-item is ALWAYS, check accumulated reachability for completeness
        # but it cannot be dead code (ALWAYS items are always reachable)
        if per_item_status == "ALWAYS" and not predecessors:
            return ItemReachabilityResult(
                item_id=item_id,
                per_item_status=per_item_status,
                accumulated_reachable=True,
                is_dead_code=False,
                predecessors=predecessors,
                message="Item is ALWAYS reachable with no dependencies",
            )

        # Build accumulated formula: A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j) on the
        # shared base solver, scoped by push()/pop() so it reverts to just B.
        solver.push()

        # Add implications from all predecessors (P/Q pre-compiled in validate()).
        for pred_id in predecessors:
            pred_compiled = compiled_conditions.get(pred_id)
            if pred_compiled is not None:
                P_j, Q_j = pred_compiled
                solver.add(Implies(P_j, Q_j))

        # Check SAT(A_i ∧ P_i)
        solver.add(P_i)
        accumulated_reachable = solver.check() == sat
        solver.pop()

        # Dead code: CONDITIONAL per-item but not accumulated-reachable.
        #
        # Classification-safety: an item registered as conditionally-present
        # (capped-Group draw / Roster bit) is selection-absent by design, not
        # dead code. Accumulated predecessor postconditions
        # making its precondition unsatisfiable just means it is not drawn on
        # those paths — legitimate, never a design error. Exclude it from
        # dead-code regardless of accumulated reachability (the core C4
        # regression guard: a reachable-but-never-drawn item is not dead).
        is_conditionally_present = self.builder.is_conditionally_present(item_id)
        is_dead_code = (
            per_item_status == "CONDITIONAL"
            and not accumulated_reachable
            and not is_conditionally_present
        )

        if is_dead_code:
            message = (
                f"Dead code: Precondition is CONDITIONAL but becomes "
                f"unreachable due to accumulated postconditions from: "
                f"{', '.join(predecessors)}"
            )
        elif not accumulated_reachable and per_item_status == "ALWAYS":
            message = (
                "Warning: ALWAYS reachable per-item but accumulated constraints "
                "make it unreachable. This may indicate conflicting postconditions."
            )
        else:
            message = "Item is reachable under accumulated constraints"

        return ItemReachabilityResult(
            item_id=item_id,
            per_item_status=per_item_status,
            accumulated_reachable=accumulated_reachable,
            is_dead_code=is_dead_code,
            predecessors=predecessors,
            message=message,
        )

    def get_dead_code_items(self) -> list[str]:
        """
        Get list of dead code items.

        Convenience method that returns only the dead code item IDs.

        Returns:
            List of item IDs that are dead code
        """
        result = self.validate()
        return result.dead_code_items

    def debug_dump(self) -> str:
        """Generate debug output."""
        result = self.validate()

        lines = []
        lines.append("=" * 60)
        lines.append("PATH-BASED VALIDATION (Accumulated Reachability)")
        lines.append("=" * 60)
        lines.append(
            f"\nStatus: {'DEAD CODE DETECTED' if result.has_dead_code else 'ALL REACHABLE'}"
        )
        lines.append(f"Message: {result.message}")

        if result.dead_code_items:
            lines.append("\nDead Code Items:")
            for item_id in result.dead_code_items:
                item_result = result.item_results.get(item_id)
                if item_result:
                    lines.append(f"  - {item_id}: {item_result.message}")

        lines.append("\nItem Reachability Summary:")
        for item_id, item_result in result.item_results.items():
            status = "DEAD" if item_result.is_dead_code else "OK"
            acc = "✓" if item_result.accumulated_reachable else "✗"
            preds = (
                f" (deps: {', '.join(item_result.predecessors)})"
                if item_result.predecessors
                else ""
            )
            lines.append(
                f"  {item_id}: per-item={item_result.per_item_status}, "
                f"accumulated={acc}, status={status}{preds}"
            )

        return "\n".join(lines)
