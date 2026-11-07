"""
GlobalFormula - Global Satisfiability Check for QML Questionnaires

Implements the global satisfiability formula from the thesis:
    F := B ∧ ∧(P_i ⇒ Q_i)

Where:
- B: Base constraints (domain constraints for all outcome variables)
- P_i: Precondition for item I_i
- Q_i: Postcondition for item I_i

SAT(F) indicates that at least one valid questionnaire completion exists.
UNSAT(F) indicates accumulated postconditions conflict - no valid completion possible.

Reference: askalot-io/docs thesis/chapters/comprehensive_validation.tex, Definition 2.1
"""

import logging
from dataclasses import dataclass
from typing import Any

from z3 import Solver, is_true, sat, unsat

from askalot_qml.z3.static_builder import StaticBuilder


def _witness_value(model: Any, expr: Any) -> int | str:
    """A model's value for one variable: its integer, else its printed form."""
    value = model.eval(expr, model_completion=True)
    try:
        return value.as_long()
    except (AttributeError, ValueError):
        return str(value)


@dataclass
class GlobalFormulaResult:
    """Result of global satisfiability check."""

    satisfiable: bool
    status: str  # "SAT", "UNSAT", "UNKNOWN"
    witness: dict[str, Any] | None = None  # Example valid assignment if SAT
    message: str = ""


class GlobalFormula:
    """
    Global satisfiability check for questionnaire validation.

    Verifies that at least one valid questionnaire completion exists by checking:
        SAT(F) where F := B ∧ ∧(P_i ⇒ Q_i)

    This is the second level of the validation hierarchy:
    1. Per-item validation (ItemClassifier) - checks each item independently
    2. Global validation (GlobalFormula) - checks if any valid completion exists
    3. Path-based validation (PathBasedValidator) - checks for dead code

    Theorem (Soundness): If all W_i are UNSAT (per-item), then SAT(F) is guaranteed.
    Theorem (Accumulated Conflicts): UNSAT(F) can occur even when no item is INFEASIBLE.
    """

    def __init__(self, builder: StaticBuilder):
        """
        Initialize global formula checker.

        Args:
            builder: StaticBuilder with compiled constraints and item details
        """
        self.logger = logging.getLogger(__name__)
        self.builder = builder
        self.ctx = builder.ctx

    def check(self) -> GlobalFormulaResult:
        """
        Check global satisfiability: SAT(F) where F := B ∧ ∧(P_i ⇒ Q_i).

        Returns:
            GlobalFormulaResult with satisfiability status and optional witness
        """
        solver = Solver(ctx=self.ctx)

        # Add base constraints B (domain-only constraints as per thesis)
        # B := ∧_i D_i(S_i) where D_i are domain constraints (min/max, enumeration)
        base = self.builder.get_domain_base()
        solver.add(base)

        # Build ∧(P_i ⇒ Q_i) for all items
        implications = []
        for item_id in self.builder.item_order:
            details = self.builder.item_details.get(item_id)
            if not details:
                continue

            # P_i ⇒ Q_i, left out when P_i did not lower whole (see
            # StaticBuilder.item_implication): UNSAT here blocks publication.
            implication = self.builder.item_implication(item_id)
            implications.append(implication)
            solver.add(implication)

        self.logger.debug(f"Global formula built with {len(implications)} implications")

        # Check satisfiability
        result = solver.check()

        if result == sat:
            # Extract witness (example valid completion)
            model = solver.model()
            witness = self._extract_witness(model)
            return GlobalFormulaResult(
                satisfiable=True,
                status="SAT",
                witness=witness,
                message="At least one valid questionnaire completion exists.",
            )
        elif result == unsat:
            return GlobalFormulaResult(
                satisfiable=False,
                status="UNSAT",
                message="No valid questionnaire completion exists. "
                "Accumulated postconditions conflict.",
            )
        else:
            return GlobalFormulaResult(
                satisfiable=False,
                status="UNKNOWN",
                message="Z3 solver returned unknown. "
                "The formula may be too complex or require different tactics.",
            )

    def _extract_witness(self, model) -> dict[str, Any]:
        """
        Extract a witness (example valid assignment) from Z3 model.

        Args:
            model: Z3 model from satisfiable check

        Returns:
            Dictionary mapping variable names to values
        """
        witness = {}

        def chosen(choice: Any) -> bool:
            return choice is not None and is_true(model.eval(choice, model_completion=True))

        def none_answer(item_id: str) -> bool:
            # Skipped (#1769) or shown and left blank (#1784): the item reads None.
            return chosen(self.builder.skip_choice(item_id)) or chosen(self.builder.blank_choice(item_id))

        def answer(item_id: str, cells: dict, *index: int) -> Any:
            # One answer of a list: None where its slot read as unanswered
            # (#184, #1780), a Range answer as its [low, high] pair.
            if chosen(self.builder.slot_choice(item_id, *index)):
                return None
            if index in cells:
                return _witness_value(model, cells[index])
            return [_witness_value(model, cells[(*index, end)]) for end in (0, 1)]

        for item_id, z3_var in self.builder.item_vars.items():
            witness[f"{item_id}.outcome"] = None if none_answer(item_id) else _witness_value(model, z3_var)

        # A Range Question's outcome is its [low, high] pair (#1474).
        for item_id, pair in self.builder.item_pairs.items():
            witness[f"{item_id}.outcome"] = (
                None if none_answer(item_id) else [_witness_value(model, end) for end in pair]
            )

        # A QuestionGroup's outcome is its list of answers (#184), a matrix's
        # its rows of cells (#1780).
        for item_id in self.builder.question_groups:
            details = self.builder.item_details[item_id]
            cells = self.builder.item_cells[item_id]
            witness[f"{item_id}.outcome"] = (
                None
                if none_answer(item_id)
                else [answer(item_id, cells, i) for i in range(details["questions_len"])]
            )
        for item_id in self.builder.matrices:
            details = self.builder.item_details[item_id]
            cells = self.builder.item_cells[item_id]
            witness[f"{item_id}.outcome"] = (
                None
                if none_answer(item_id)
                else [
                    [answer(item_id, cells, r, c) for c in range(details["cols_len"])]
                    for r in range(details["rows_len"])
                ]
            )

        # Extract SSA variable values
        for var_name, z3_var in self.builder.z3_vars.items():
            witness[var_name] = _witness_value(model, z3_var)

        return witness

    def get_conflicting_items(self) -> list[str]:
        """
        If UNSAT, attempt to find which items' postconditions conflict.

        Uses incremental solving to identify the minimal set of implications
        that cause unsatisfiability.

        Returns:
            List of item IDs whose postconditions contribute to the conflict
        """
        # First verify that the formula is indeed UNSAT
        result = self.check()
        if result.satisfiable:
            return []

        conflicting = []
        solver = Solver(ctx=self.ctx)
        solver.add(self.builder.get_domain_base())

        # Add implications one by one to find which causes UNSAT
        for item_id in self.builder.item_order:
            details = self.builder.item_details.get(item_id)
            if not details:
                continue

            implication = self.builder.item_implication(item_id)

            solver.push()
            solver.add(implication)

            if solver.check() == unsat:
                conflicting.append(item_id)
                solver.pop()
            else:
                solver.pop()
                solver.add(implication)

        return conflicting

    def debug_dump(self) -> str:
        """Generate debug output."""
        result = self.check()

        lines = []
        lines.append("=" * 60)
        lines.append("GLOBAL FORMULA CHECK (F := B ∧ ∧(P_i ⇒ Q_i))")
        lines.append("=" * 60)
        lines.append(f"\nStatus: {result.status}")
        lines.append(f"Message: {result.message}")

        if result.witness:
            lines.append("\nWitness (example valid completion):")
            for var, value in sorted(result.witness.items()):
                lines.append(f"  {var} = {value}")

        if not result.satisfiable:
            conflicting = self.get_conflicting_items()
            if conflicting:
                lines.append(f"\nConflicting items: {', '.join(conflicting)}")

        return "\n".join(lines)
