"""
ValidationProcessor - Validation Mode Implementation for QML Static Validation

This processor handles static validation of questionnaires:
- Uses topological order + ItemClassifier for Z3 validation
- Determines item availability (ALWAYS/CONDITIONALLY/NEVER)
- Determines postcondition effects (TAUTOLOGICAL/CONSTRAINING/INFEASIBLE)
- Generates graph data with classification colors for visualization
- Supports isolated Z3 validation for safety

Uses the common QMLEngine pipeline then adds Z3-based item classification.
"""

import logging
from typing import Any

from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.item_classifier import ItemClassifier

try:
    from askalot_common.tracing import create_span
except ImportError:
    create_span = None


class ValidationProcessor:
    """
    Validation mode processor for static questionnaire validation.

    Provides:
    - Z3-based item classification (availability and postcondition effects)
    - Detailed validation diagrams with semantic coloring
    - Comprehensive static validation reports
    """

    def __init__(self, questionnaire_state: QMLState):
        """
        Initialize validation processor with questionnaire state.

        Args:
            questionnaire_state: The questionnaire to validate
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state

        # Use unified engine for common pipeline
        self.engine = QMLEngine(questionnaire_state)

        # Item classifications (lazy-loaded)
        self._classifications: dict[str, Any] | None = None

        self.logger.info(
            f"ValidationProcessor initialized for {len(self.engine.get_items())} items"
        )

    def get_item_classifications(self) -> dict[str, Any]:
        """
        Get Z3-based item classifications (lazy-loaded).

        Returns:
            Dict mapping item_id to classification results
        """
        if self._classifications is not None:
            return self._classifications

        try:
            self.logger.info("Running Z3 validation...")
            item_count = len(self.engine.get_items())
            span_ctx = (
                create_span("qml.z3_validation", {"item_count": item_count})
                if create_span
                else None
            )
            if span_ctx:
                span_ctx.__enter__()
            try:
                classifier = ItemClassifier(self.engine.static_builder)
                self._classifications = classifier.classify_all_items()
            finally:
                if span_ctx:
                    span_ctx.__exit__(None, None, None)
            self.logger.info("Z3 validation completed successfully")
        except Exception as e:
            self.logger.error(f"Z3 validation failed: {e}", exc_info=True)
            self._classifications = {}

        return self._classifications

    def classify_item(self, item_id: str) -> dict[str, Any]:
        """
        Get classification for a specific item.

        Args:
            item_id: ID of the item to classify

        Returns:
            Classification result for the item
        """
        classifications = self.get_item_classifications()
        return classifications.get(
            item_id,
            {
                "precondition": {"status": "UNKNOWN"},
                "postcondition": {
                    "invariant": "UNKNOWN",
                    "vacuous": False,
                    "global": {"q_globally_true": False, "q_globally_false": False},
                },
            },
        )

    def generate_validation_graph(self, enable_z3_validation: bool = True) -> dict:
        """
        Generate positions-free structural IR with Z3 validation coloring.

        Builds the JSON IR and inlines per-item classifications onto the item
        entries directly. Layout is computed client-side in the QML Explorer
        React webview via ELK.js — the server never emits coordinates.

        Args:
            enable_z3_validation: Whether to inline Z3 classifications

        Returns:
            IR dict with top-level arrays (blocks, items, conditions, variables,
            edges) and metadata; items carry a `classification` field when
            ``enable_z3_validation=True``.
        """
        from askalot_qml.core.qml_diagram_ir import QMLDiagramIR

        diagram_generator = QMLDiagramIR(self.engine.topology, self.state)
        base_graph = diagram_generator.generate_base_graph()

        if enable_z3_validation:
            # Reuse cached classifications (lazy-loaded once, not re-computed)
            classifications = self.get_item_classifications()
            return diagram_generator.apply_validation_coloring(
                base_graph, classifications=classifications
            )
        return base_graph

    def generate_validation_report(self) -> str:
        """
        Generate comprehensive text validation report.

        Returns:
            Detailed text report of questionnaire validation
        """
        from askalot_qml.core.qml_diagram_ir import QMLDiagramIR

        diagram_generator = QMLDiagramIR(self.engine.topology, self.state)
        base_report = diagram_generator.generate_validation_report()

        # Add Z3 classification summary if available
        classifications = self.get_item_classifications()
        if classifications:
            lines = [base_report, "", "Z3 Validation Results:"]

            # Count classification types
            always_count = sum(
                1
                for c in classifications.values()
                if c.get("precondition", {}).get("status") == "ALWAYS"
            )
            conditional_count = sum(
                1
                for c in classifications.values()
                if c.get("precondition", {}).get("status") == "CONDITIONAL"
            )
            never_count = sum(
                1
                for c in classifications.values()
                if c.get("precondition", {}).get("status") == "NEVER"
            )

            tautological_count = sum(
                1
                for c in classifications.values()
                if c.get("postcondition", {}).get("invariant") == "TAUTOLOGICAL"
            )
            constraining_count = sum(
                1
                for c in classifications.values()
                if c.get("postcondition", {}).get("invariant") == "CONSTRAINING"
            )
            infeasible_count = sum(
                1
                for c in classifications.values()
                if c.get("postcondition", {}).get("invariant") == "INFEASIBLE"
            )

            # Count block pre/postcondition inheritance (R25 reads from
            # block objects directly — block conditions are no longer
            # copied onto items at load time).
            items_with_block_preconds = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                for block in self.state.get_blocks()
                if block.get("precondition")
            )
            items_with_block_postconds = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                for block in self.state.get_blocks()
                if block.get("postcondition")
            )

            lines.append("  Precondition Reachability:")
            lines.append(
                f"    Always: {always_count}, Conditional: {conditional_count}, Never: {never_count}"
            )
            if items_with_block_preconds:
                lines.append(
                    f"    ({items_with_block_preconds} items inherit block-level preconditions)"
                )
            lines.append("  Postcondition Effects:")
            lines.append(
                f"    Tautological: {tautological_count}, Constraining: {constraining_count}, Infeasible: {infeasible_count}"
            )
            if items_with_block_postconds:
                lines.append(
                    f"    ({items_with_block_postconds} items inherit block-level postconditions)"
                )

            # Highlight problematic items
            problematic_items = []
            for item_id, classification in classifications.items():
                precond_status = classification.get("precondition", {}).get("status", "UNKNOWN")
                postcond_invariant = classification.get("postcondition", {}).get(
                    "invariant", "UNKNOWN"
                )

                if precond_status == "NEVER":
                    problematic_items.append(f"{item_id} (never reachable)")
                elif postcond_invariant == "INFEASIBLE":
                    problematic_items.append(f"{item_id} (infeasible postcondition)")

            if problematic_items:
                lines.append("\n⚠️  Potential Issues:")
                for item in problematic_items[:5]:  # Show first 5
                    lines.append(f"    {item}")
                if len(problematic_items) > 5:
                    lines.append(f"    ... and {len(problematic_items) - 5} more")

            return "\n".join(lines)

        return base_report

    def get_statistics(self) -> dict[str, Any]:
        """
        Get validation-specific statistics.

        Returns:
            Statistics about the questionnaire validation
        """
        stats = self.engine.get_statistics()

        # Add validation-specific information
        classifications = self.get_item_classifications()
        stats.update({"validation_mode": True, "z3_validation_available": bool(classifications)})

        if classifications:
            # Add classification statistics
            precond_stats = {}
            postcond_stats = {}

            for _item_id, classification in classifications.items():
                precond_status = classification.get("precondition", {}).get("status", "UNKNOWN")
                postcond_invariant = classification.get("postcondition", {}).get(
                    "invariant", "UNKNOWN"
                )

                precond_stats[precond_status] = precond_stats.get(precond_status, 0) + 1
                postcond_stats[postcond_invariant] = postcond_stats.get(postcond_invariant, 0) + 1

            # Count block pre/postcondition inheritance (R25 reads from
            # block objects directly). "Items inheriting" = items in any
            # block that declares a precondition/postcondition; "total
            # block predicates" = sum of block-level predicate lengths
            # multiplied by the number of items that inherit each one.
            items_with_block_preconditions = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                for block in self.state.get_blocks()
                if block.get("precondition")
            )
            total_block_preconditions = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                * len(block.get("precondition") or [])
                for block in self.state.get_blocks()
                if block.get("precondition")
            )
            items_with_block_postconditions = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                for block in self.state.get_blocks()
                if block.get("postcondition")
            )
            total_block_postconditions = sum(
                len(self.state.get_items_by_block(block.get("id", "")))
                * len(block.get("postcondition") or [])
                for block in self.state.get_blocks()
                if block.get("postcondition")
            )

            stats.update(
                {
                    "precondition_classification": precond_stats,
                    "postcondition_classification": postcond_stats,
                    "block_precondition_items": items_with_block_preconditions,
                    "block_preconditions_total": total_block_preconditions,
                    "block_postcondition_items": items_with_block_postconditions,
                    "block_postconditions_total": total_block_postconditions,
                }
            )

        return stats

    def debug_dump(self) -> str:
        """Generate debug output for validation processor."""
        lines = []
        lines.append("=" * 60)
        lines.append("VALIDATION PROCESSOR DEBUG DUMP")
        lines.append("=" * 60)

        stats = self.get_statistics()
        lines.append("\nValidation Summary:")
        lines.append(f"  Z3 validation available: {stats['z3_validation_available']}")
        lines.append(f"  Has cycles: {self.engine.has_cycles()}")

        if stats.get("precondition_classification"):
            lines.append("\nPrecondition Classification:")
            for status, count in stats["precondition_classification"].items():
                lines.append(f"    {status}: {count}")

        if stats.get("postcondition_classification"):
            lines.append("\nPostcondition Classification:")
            for invariant, count in stats["postcondition_classification"].items():
                lines.append(f"    {invariant}: {count}")

        # Include engine debug info
        lines.append("\n" + self.engine.debug_dump())

        return "\n".join(lines)
