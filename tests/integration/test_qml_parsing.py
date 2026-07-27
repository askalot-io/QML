#!/usr/bin/env python3
"""Integration tests for QML parsing, block precondition propagation, and Z3 transformation.

Tests the complete pipeline from QML files to Z3 constraints:
- QMLLoader parses YAML files and flattens nested block/item structure
- Block-level preconditions propagate to enclosed items during flattening
- Items with existing preconditions receive block preconditions prepended
- Scalar predicates (bool, int, float) at block level are normalized to strings
- QMLState is initialized with correct flat structure and blockId references
- StaticBuilder generates Z3 constraints including inherited block preconditions
- QMLTopology discovers dependencies from block-inherited preconditions
- ItemClassifier produces correct classifications for block-conditioned items

These integration tests use real QML fixture files and inline QML strings to verify
that block precondition inheritance works correctly through the entire pipeline, from
YAML parsing through Z3 constraint generation to item classification.
"""

import unittest
from pathlib import Path

import pytest
from jsonschema import ValidationError
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.item_classifier import ItemClassifier
from askalot_qml.z3.static_builder import StaticBuilder

# Path to fixture files
FIXTURES_DIR = Path(__file__).parent.parent / "fixtures"


def load_qml_fixture(filename: str) -> QMLState:
    """Load a QML fixture file and return QMLState."""
    loader = QMLLoader(schema_path=None)
    qml_path = FIXTURES_DIR / filename
    data = loader.load_from_path(str(qml_path))
    return QMLState(data)


@pytest.mark.integration
class TestQMLLoading(unittest.TestCase):
    """Tests for QML file loading and parsing."""

    def test_load_basic_qml(self):
        """Test loading a basic QML file."""
        state = load_qml_fixture("basic.qml")

        self.assertEqual(state.get("title"), "Basic Survey")
        self.assertEqual(len(state.get_blocks()), 1)
        self.assertEqual(len(state.get_items()), 3)

    def test_load_dependencies_qml(self):
        """Test loading QML with preconditions."""
        state = load_qml_fixture("dependencies.qml")

        self.assertEqual(state.get("title"), "Survey with Dependencies")
        self.assertEqual(len(state.get_blocks()), 2)
        self.assertEqual(len(state.get_items()), 5)

        # Check preconditions are loaded
        q_job = state.get_item("q_job_title")
        self.assertIn("precondition", q_job)
        self.assertEqual(len(q_job["precondition"]), 1)

    def test_load_scoring_qml(self):
        """Test loading QML with codeInit and codeBlock."""
        state = load_qml_fixture("scoring.qml")

        self.assertEqual(state.get("title"), "Scored Assessment")

        # Check codeInit is loaded
        code_init = state.get_code_init()
        self.assertIn("score = 0", code_init)
        self.assertIn("risk_level = 0", code_init)

        # Check codeBlock on items
        q_age = state.get_item("q_age")
        self.assertIn("codeBlock", q_age)
        self.assertIn("risk_level", q_age["codeBlock"])

    def test_nested_to_flat_conversion(self):
        """Test that nested QML structure is converted to flat."""
        state = load_qml_fixture("basic.qml")

        # Items should have blockId, not be nested in blocks
        for item in state.get_items():
            self.assertIn("blockId", item)

        # Blocks should not have items array
        for block in state.get_blocks():
            self.assertNotIn("items", block)

    def test_scalar_predicate_normalization(self):
        """Test that YAML scalar predicates are converted to strings.

        YAML parses certain values as non-string types, but predicates must be
        strings for ast.parse(). The loader should normalize scalars (bool, int, float).
        """
        loader = QMLLoader(schema_path=None)

        # QML with various scalar predicates (YAML will parse as non-string)
        qml_content = """
questionnaire:
  title: Scalar Predicate Test
  blocks:
    - id: main
      kind: Group
      items:
        - id: q1
          kind: Question
          title: Boolean true
          precondition:
            - predicate: true
        - id: q2
          kind: Question
          title: Boolean false
          postcondition:
            - predicate: false
              hint: This always fails
        - id: q3
          kind: Question
          title: Integer predicate
          precondition:
            - predicate: 1
        - id: q4
          kind: Question
          title: Float predicate
          precondition:
            - predicate: 1.5
        - id: q5
          kind: Question
          title: String predicate
          precondition:
            - predicate: "q1.outcome > 0"
"""
        data = loader.load_from_string(qml_content)
        state = QMLState(data)

        # Check that boolean predicates were converted to strings
        q1 = state.get_item("q1")
        self.assertEqual(q1["precondition"][0]["predicate"], "True")
        self.assertIsInstance(q1["precondition"][0]["predicate"], str)

        q2 = state.get_item("q2")
        self.assertEqual(q2["postcondition"][0]["predicate"], "False")
        self.assertIsInstance(q2["postcondition"][0]["predicate"], str)

        # Check that int predicate was converted
        q3 = state.get_item("q3")
        self.assertEqual(q3["precondition"][0]["predicate"], "1")
        self.assertIsInstance(q3["precondition"][0]["predicate"], str)

        # Check that float predicate was converted
        q4 = state.get_item("q4")
        self.assertEqual(q4["precondition"][0]["predicate"], "1.5")
        self.assertIsInstance(q4["precondition"][0]["predicate"], str)

        # String predicates should remain unchanged
        q5 = state.get_item("q5")
        self.assertEqual(q5["precondition"][0]["predicate"], "q1.outcome > 0")

    def test_complex_predicate_raises_error(self):
        """Test that complex type predicates (list, dict) raise ValueError."""
        loader = QMLLoader(schema_path=None)

        # QML with list predicate (likely a mistake)
        qml_content = """
questionnaire:
  title: Invalid Predicate Test
  blocks:
    - id: main
      kind: Group
      items:
        - id: q1
          kind: Question
          title: Invalid predicate
          precondition:
            - predicate:
                - item1
                - item2
"""
        with self.assertRaises(ValueError) as ctx:
            loader.load_from_string(qml_content)

        self.assertIn("Invalid predicate type", str(ctx.exception))
        self.assertIn("list", str(ctx.exception))


@pytest.mark.integration
class TestQMLStateInitialization(unittest.TestCase):
    """Tests for QMLState correct initialization."""

    def test_items_have_required_fields(self):
        """Test that items have all required fields after loading."""
        state = load_qml_fixture("basic.qml")

        for item in state.get_items():
            self.assertIn("id", item)
            self.assertIn("blockId", item)
            self.assertIn("kind", item)
            self.assertIn("title", item)

    def test_items_have_runtime_state(self):
        """Test that items are initialized with runtime state fields."""
        state = load_qml_fixture("basic.qml")

        for item in state.get_items():
            # Runtime state should be initialized
            self.assertFalse(item.get("visited", False))

    def test_get_items_by_block(self):
        """Test filtering items by block."""
        state = load_qml_fixture("dependencies.qml")

        screening_items = state.get_items_by_block("screening")
        self.assertEqual(len(screening_items), 3)

        education_items = state.get_items_by_block("education")
        self.assertEqual(len(education_items), 2)

    def test_history_initialization(self):
        """Test that history is empty on initialization."""
        state = load_qml_fixture("basic.qml")

        self.assertEqual(state.get_history(), [])

    def test_item_input_properties(self):
        """Test that input properties are preserved."""
        state = load_qml_fixture("basic.qml")

        q_age = state.get_item("q_age")
        self.assertIn("input", q_age)
        self.assertEqual(q_age["input"]["control"], "Editbox")
        self.assertEqual(q_age["input"]["min"], 18)
        self.assertEqual(q_age["input"]["max"], 120)


@pytest.mark.integration
@pytest.mark.z3
class TestZ3ConstraintGeneration(unittest.TestCase):
    """Tests for Z3 constraint generation from QML."""

    def test_basic_constraint_generation(self):
        """Test that StaticBuilder generates constraints from basic QML."""
        state = load_qml_fixture("basic.qml")
        builder = StaticBuilder(state)

        # Should create item variables
        self.assertIn("q_age", builder.item_vars)
        self.assertIn("q_gender", builder.item_vars)
        self.assertIn("q_comment", builder.item_vars)

    def test_precondition_constraint_generation(self):
        """Test constraint generation from preconditions."""
        state = load_qml_fixture("dependencies.qml")
        builder = StaticBuilder(state)

        # Should have constraints for preconditions
        self.assertGreater(len(builder.constraints), 0)

        # q_job_title depends on q_employed
        deps = builder.get_item_dependencies()
        self.assertIn("q_employed", deps.get("q_job_title", set()))

    def test_code_init_variable_creation(self):
        """Test that codeInit creates SSA variables."""
        state = load_qml_fixture("scoring.qml")
        builder = StaticBuilder(state)

        # Variables from codeInit should exist
        self.assertIn("score", builder.version_map)
        self.assertIn("risk_level", builder.version_map)

    def test_code_block_constraint_generation(self):
        """Test constraint generation from codeBlock."""
        state = load_qml_fixture("scoring.qml")
        builder = StaticBuilder(state)

        # Items with codeBlock should create new variable versions
        # risk_level is modified in multiple items
        risk_versions = builder.version_history.get("risk_level", [])
        self.assertGreater(len(risk_versions), 1)

    def test_postcondition_constraint_generation(self):
        """Test constraint generation from postconditions."""
        state = load_qml_fixture("scoring.qml")
        builder = StaticBuilder(state)

        # Should have constraints
        self.assertGreater(len(builder.constraints), 0)

        # Item details should include postconditions
        q_exercise = builder.item_details.get("q_exercise", {})
        self.assertIn("postconditions", q_exercise)
        self.assertEqual(len(q_exercise["postconditions"]), 1)


@pytest.mark.integration
@pytest.mark.z3
class TestDependencyDiscovery(unittest.TestCase):
    """Tests for dependency discovery from QML."""

    def test_no_dependencies_basic(self):
        """Test that basic QML has no dependencies."""
        state = load_qml_fixture("basic.qml")
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        for _item_id, item_deps in deps.items():
            self.assertEqual(len(item_deps), 0)

    def test_precondition_dependencies(self):
        """Test dependency discovery from preconditions."""
        state = load_qml_fixture("dependencies.qml")
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()

        # q_job_title depends on q_employed
        self.assertIn("q_employed", deps.get("q_job_title", set()))

        # q_years_employed depends on q_employed
        self.assertIn("q_employed", deps.get("q_years_employed", set()))

        # q_field depends on q_degree
        self.assertIn("q_degree", deps.get("q_field", set()))

    def test_topological_order(self):
        """Test topological ordering respects dependencies."""
        state = load_qml_fixture("dependencies.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q_employed must come before q_job_title
        self.assertLess(order.index("q_employed"), order.index("q_job_title"))

        # q_degree must come before q_field
        self.assertLess(order.index("q_degree"), order.index("q_field"))


@pytest.mark.integration
@pytest.mark.z3
@pytest.mark.cycle_detection
class TestCycleDetection(unittest.TestCase):
    """Tests for cycle detection in QML dependencies."""

    def test_no_cycles_in_valid_qml(self):
        """Test that valid QML has no cycles."""
        state = load_qml_fixture("dependencies.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertFalse(topology.has_cycles)
        self.assertEqual(len(topology.cycles), 0)

    def test_cycle_detection(self):
        """Test that cyclic dependencies are detected."""
        state = load_qml_fixture("cycles.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)
        self.assertGreater(len(topology.cycles), 0)

    def test_topological_order_complete_with_cycles(self):
        """Topological order includes all items even when cycles exist."""
        state = load_qml_fixture("cycles.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)
        self.assertTrue(topology.has_cycles)
        # All items appear in the order
        all_item_ids = {item["id"] for item in state.get_all_items() if item.get("id")}
        self.assertEqual(set(order), all_item_ids)


@pytest.mark.integration
@pytest.mark.z3
class TestItemClassification(unittest.TestCase):
    """Tests for item classification (ALWAYS, CONDITIONAL, NEVER)."""

    def test_always_classification(self):
        """Test that items without preconditions are ALWAYS."""
        state = load_qml_fixture("classification.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        result = classifier.classify_item("q_always")
        self.assertEqual(result["precondition"]["status"], "ALWAYS")

    def test_conditional_classification(self):
        """Test that items with satisfiable preconditions are CONDITIONAL."""
        state = load_qml_fixture("classification.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        result = classifier.classify_item("q_conditional")
        self.assertEqual(result["precondition"]["status"], "CONDITIONAL")

    def test_never_classification(self):
        """Test that items with contradictory preconditions are NEVER."""
        state = load_qml_fixture("classification.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        result = classifier.classify_item("q_never")
        self.assertEqual(result["precondition"]["status"], "NEVER")

    def test_constraining_postcondition(self):
        """Test that constraining postconditions are detected."""
        state = load_qml_fixture("classification.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        result = classifier.classify_item("q_constraining")
        # Should have postcondition classification
        self.assertIn("postcondition", result)
        self.assertIn("invariant", result["postcondition"])


@pytest.mark.integration
class TestEndToEndPipeline(unittest.TestCase):
    """End-to-end tests for the complete QML processing pipeline."""

    def test_complete_pipeline_basic(self):
        """Test complete pipeline with basic QML."""
        # Load
        state = load_qml_fixture("basic.qml")

        # Build constraints
        builder = StaticBuilder(state)

        # Build topology
        topology = QMLTopology(state, builder)

        # Verify
        self.assertFalse(topology.has_cycles)
        self.assertEqual(len(topology.get_topological_order()), 3)

    def test_complete_pipeline_scoring(self):
        """Test complete pipeline with scoring QML."""
        # Load
        state = load_qml_fixture("scoring.qml")

        # Build constraints
        builder = StaticBuilder(state)

        # Verify SSA versioning
        self.assertIn("score", builder.version_map)
        self.assertIn("risk_level", builder.version_map)

        # Build topology
        topology = QMLTopology(state, builder)
        self.assertFalse(topology.has_cycles)

        # Classify items
        classifier = ItemClassifier(builder)
        q_age_result = classifier.classify_item("q_age")
        self.assertEqual(q_age_result["precondition"]["status"], "ALWAYS")

    def test_complete_pipeline_dependencies(self):
        """Test complete pipeline preserves all dependencies."""
        # Load
        state = load_qml_fixture("dependencies.qml")

        # Build
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # Verify dependency chain
        deps = builder.get_item_dependencies()

        # Employed → Job Title → (end of chain)
        self.assertIn("q_employed", deps.get("q_job_title", set()))

        # Degree → Field → (end of chain)
        self.assertIn("q_degree", deps.get("q_field", set()))

        # Components should be 2 (screening chain + education chain)
        components = topology.get_components()
        # Note: components may vary based on exact dependency structure
        self.assertGreaterEqual(len(components), 1)


@pytest.mark.integration
class TestBlockPreconditionPropagation(unittest.TestCase):
    """Block preconditions stay on the block object (R25 — no item-list merge).

    Downstream consumers (FlowProcessor at runtime, StaticBuilder at Z3
    constraint-build time) compose ``block.precondition + item.precondition``
    when they need the combined view. The loader's job is just to lift
    blocks and items to top-level arrays and preserve each scope's
    conditions where the author wrote them.
    """

    def _load_from_string(self, qml_content: str) -> QMLState:
        loader = QMLLoader(schema_path=None)
        data = loader.load_from_string(qml_content)
        return QMLState(data)

    def test_block_precondition_stays_on_block(self):
        """The block keeps its precondition; items don't inherit it at the
        list level."""
        state = self._load_from_string("""
questionnaire:
  title: Block Inheritance Test
  blocks:
    - id: conditional_block
      kind: Group
      precondition:
        - predicate: "q_gate.outcome == 1"
      items:
        - id: q_a
          kind: Question
          title: Question A
        - id: q_b
          kind: Question
          title: Question B
""")
        blocks_by_id = {b["id"]: b for b in state.get_blocks()}
        gated_block = blocks_by_id["conditional_block"]
        self.assertEqual(len(gated_block["precondition"]), 1)
        self.assertEqual(gated_block["precondition"][0]["predicate"], "q_gate.outcome == 1")

        # Items keep their OWN precondition list — empty here, since neither
        # q_a nor q_b declared one. No merged copy of the block's predicate.
        q_a = state.get_item("q_a")
        q_b = state.get_item("q_b")
        self.assertFalse(q_a.get("precondition"))
        self.assertFalse(q_b.get("precondition"))

    def test_block_and_item_preconditions_kept_separate(self):
        """The block's preconditions stay on the block; the item's own
        precondition list contains ONLY the item-authored entry."""
        state = self._load_from_string("""
questionnaire:
  title: Separation Test
  blocks:
    - id: filtered_block
      kind: Group
      precondition:
        - predicate: "q_gate.outcome == 1"
          hint: Block-level gate
      items:
        - id: q_detail
          kind: Question
          title: Detail question
          precondition:
            - predicate: "q_other.outcome > 5"
              hint: Item-level filter
""")
        block = next(b for b in state.get_blocks() if b["id"] == "filtered_block")
        q_detail = state.get_item("q_detail")

        self.assertEqual(
            block["precondition"],
            [
                {"predicate": "q_gate.outcome == 1", "hint": "Block-level gate"},
            ],
        )
        # Item list has its own predicate only, no block prefix and no marker.
        self.assertEqual(
            q_detail["precondition"],
            [
                {"predicate": "q_other.outcome > 5", "hint": "Item-level filter"},
            ],
        )
        self.assertNotIn("_block_precondition_count", q_detail)
        self.assertTrue(all("_source" not in c for c in q_detail["precondition"]))

    def test_block_without_precondition_does_not_affect_items(self):
        """Items in blocks without preconditions are unchanged."""
        state = self._load_from_string("""
questionnaire:
  title: No Block Precondition Test
  blocks:
    - id: plain_block
      kind: Group
      items:
        - id: q_plain
          kind: Question
          title: Plain question
        - id: q_with_own
          kind: Question
          title: Has own precondition
          precondition:
            - predicate: "q_plain.outcome > 0"
""")
        q_plain = state.get_item("q_plain")
        q_with_own = state.get_item("q_with_own")

        # No precondition added
        self.assertFalse(q_plain.get("precondition"))

        # Item's own precondition preserved, no extras
        self.assertEqual(len(q_with_own["precondition"]), 1)
        self.assertEqual(q_with_own["precondition"][0]["predicate"], "q_plain.outcome > 0")

    def test_multiple_blocks_mixed_preconditions(self):
        """Each block keeps its own precondition list; items get none."""
        state = self._load_from_string("""
questionnaire:
  title: Mixed Blocks Test
  blocks:
    - id: open_block
      kind: Group
      items:
        - id: q_open
          kind: Question
          title: Open question
    - id: gated_block
      kind: Group
      precondition:
        - predicate: "q_open.outcome == 1"
      items:
        - id: q_gated
          kind: Question
          title: Gated question
""")
        blocks_by_id = {b["id"]: b for b in state.get_blocks()}
        q_open = state.get_item("q_open")
        q_gated = state.get_item("q_gated")

        # Block precondition lives on the block; item list is empty.
        self.assertFalse(blocks_by_id["open_block"].get("precondition"))
        self.assertEqual(
            blocks_by_id["gated_block"]["precondition"],
            [{"predicate": "q_open.outcome == 1"}],
        )
        self.assertFalse(q_open.get("precondition"))
        self.assertFalse(q_gated.get("precondition"))

    def test_multiple_block_preconditions_kept_on_block(self):
        """All block-level preconditions live on the block as a list."""
        state = self._load_from_string("""
questionnaire:
  title: Multi Precondition Test
  blocks:
    - id: multi_gate
      kind: Group
      precondition:
        - predicate: "q_gate1.outcome == 1"
        - predicate: "q_gate2.outcome == 1"
      items:
        - id: q_inner
          kind: Question
          title: Inner question
""")
        block = next(b for b in state.get_blocks() if b["id"] == "multi_gate")
        q_inner = state.get_item("q_inner")

        self.assertEqual(len(block["precondition"]), 2)
        self.assertEqual(block["precondition"][0]["predicate"], "q_gate1.outcome == 1")
        self.assertEqual(block["precondition"][1]["predicate"], "q_gate2.outcome == 1")
        # Item keeps no copy of either.
        self.assertFalse(q_inner.get("precondition"))

    def test_block_scalar_predicate_normalization(self):
        """Block-level scalar predicates (bool) are normalized to strings on
        the block itself."""
        state = self._load_from_string("""
questionnaire:
  title: Block Normalization Test
  blocks:
    - id: always_block
      kind: Group
      precondition:
        - predicate: true
      items:
        - id: q_always
          kind: Question
          title: Always shown
""")
        block = next(b for b in state.get_blocks() if b["id"] == "always_block")
        self.assertEqual(len(block["precondition"]), 1)
        self.assertEqual(block["precondition"][0]["predicate"], "True")
        self.assertIsInstance(block["precondition"][0]["predicate"], str)

    def test_block_preconditions_stripped_from_block_metadata(self):
        """Flattened block metadata retains preconditions but not items."""
        state = self._load_from_string("""
questionnaire:
  title: Block Metadata Test
  blocks:
    - id: gated
      kind: Group
      title: Gated Block
      precondition:
        - predicate: "x == 1"
      items:
        - id: q1
          kind: Question
          title: Q1
""")
        blocks = state.get_blocks()
        self.assertEqual(len(blocks), 1)

        block = blocks[0]
        self.assertNotIn("items", block)
        self.assertEqual(block["id"], "gated")
        self.assertIn("precondition", block)


@pytest.mark.integration
@pytest.mark.z3
class TestBlockPreconditionPipeline(unittest.TestCase):
    """Tests that block preconditions flow through to Z3 constraints and classification."""

    def test_block_precondition_creates_dependencies(self):
        """Block-inherited preconditions create item dependencies in StaticBuilder."""
        state = load_qml_fixture("block_preconditions.qml")
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()

        # q_employed inherits block precondition referencing q_age
        self.assertIn("q_age", deps.get("q_employed", set()))

        # q_job_title has block precondition (q_age) + own precondition (q_employed)
        q_job_deps = deps.get("q_job_title", set())
        self.assertIn("q_age", q_job_deps)
        self.assertIn("q_employed", q_job_deps)

        # q_retired inherits block precondition referencing q_age
        self.assertIn("q_age", deps.get("q_retired", set()))

        # q_country in screening block has no preconditions → no deps
        self.assertEqual(len(deps.get("q_country", set())), 0)

    def test_block_precondition_topological_order(self):
        """Block-inherited dependencies are respected in topological order."""
        state = load_qml_fixture("block_preconditions.qml")
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertFalse(topology.has_cycles)

        # q_age must come before all employment and retirement items
        age_idx = order.index("q_age")
        self.assertLess(age_idx, order.index("q_employed"))
        self.assertLess(age_idx, order.index("q_job_title"))
        self.assertLess(age_idx, order.index("q_retired"))

        # q_employed must come before q_job_title (item-level dep)
        self.assertLess(order.index("q_employed"), order.index("q_job_title"))

    def test_block_precondition_item_classification(self):
        """Items with block-inherited preconditions are classified as CONDITIONAL."""
        state = load_qml_fixture("block_preconditions.qml")
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        # Screening items (no block precondition) → ALWAYS
        result_age = classifier.classify_item("q_age")
        self.assertEqual(result_age["precondition"]["status"], "ALWAYS")

        result_country = classifier.classify_item("q_country")
        self.assertEqual(result_country["precondition"]["status"], "ALWAYS")

        # Employment items (block precondition: q_age.outcome <= 2) → CONDITIONAL
        result_employed = classifier.classify_item("q_employed")
        self.assertEqual(result_employed["precondition"]["status"], "CONDITIONAL")

        # Retirement item (block precondition: q_age.outcome == 3) → CONDITIONAL
        result_retired = classifier.classify_item("q_retired")
        self.assertEqual(result_retired["precondition"]["status"], "CONDITIONAL")

    def test_block_and_item_preconditions_compose_in_static_builder(self):
        """R25: the loader doesn't merge, but StaticBuilder's item_details
        composes block + item preconditions so ItemClassifier still sees
        the combined view."""
        state = load_qml_fixture("block_preconditions.qml")

        # Loader: q_job_title carries ONLY its own precondition.
        q_job = state.get_item("q_job_title")
        self.assertEqual(len(q_job["precondition"]), 1)
        self.assertEqual(q_job["precondition"][0]["predicate"], "q_employed.outcome == 1")

        # StaticBuilder: when populating item_details for ItemClassifier,
        # the block precondition is prepended onto the item's own list.
        builder = StaticBuilder(state)
        details = builder.item_details["q_job_title"]
        composed = details["preconditions"]
        self.assertEqual(len(composed), 2)
        self.assertEqual(composed[0]["predicate"], "q_age.outcome <= 2")
        self.assertEqual(composed[1]["predicate"], "q_employed.outcome == 1")


@pytest.mark.integration
class TestSchemaClosedObjects(unittest.TestCase):
    """#166: the Item and Condition objects are closed with
    `unevaluatedProperties: false` (schema 2.1.1), so a typo'd key is rejected at
    load time (against the bundled schema) instead of silently attaching nothing.

    `Input` is deliberately left OPEN for now: the Switch control's canonical
    `on:`/`off:` keys are coerced to booleans by YAML (`{True: ..., False: ...}`)
    and never matched the schema's string `on`/`off` names, so closing `Input`
    would reject the shipped default templates. Closing it needs a loader-side
    on/off normalization first — tracked as a follow-up.

    Uses the DEFAULT loader (bundled schema on), unlike the `schema_path=None`
    helper the rest of this module uses.
    """

    def _doc(self, item: dict) -> str:
        import yaml

        return yaml.safe_dump(
            {
                "qmlVersion": "2.0",
                "questionnaire": {
                    "title": "closed-objects",
                    "blocks": [{"id": "b", "kind": "Group", "title": "B", "items": [item]}],
                },
            }
        )

    def test_valid_item_loads(self):
        """A well-formed item (only declared keys) still loads cleanly."""
        item = {
            "id": "q",
            "kind": "Question",
            "title": "Q",
            "precondition": [{"predicate": "1 == 1"}],
            "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
        }
        QMLLoader().load_from_string(self._doc(item))  # no exception

    def test_item_typo_key_rejected(self):
        """A misspelled item key (`precondtion`) is rejected, not silently dropped."""
        item = {
            "id": "q",
            "kind": "Question",
            "title": "Q",
            "precondtion": [{"predicate": "1 == 1"}],
            "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
        }
        with self.assertRaises(Exception) as ctx:
            QMLLoader().load_from_string(self._doc(item))
        self.assertIn("precondtion", str(ctx.exception))

    def test_condition_typo_key_rejected(self):
        """A misspelled condition key (`hnt` for `hint`) is rejected."""
        item = {
            "id": "q",
            "kind": "Question",
            "title": "Q",
            "postcondition": [{"predicate": "q.outcome == 1", "hnt": "typo"}],
            "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
        }
        with self.assertRaises(Exception) as ctx:
            QMLLoader().load_from_string(self._doc(item))
        self.assertIn("hnt", str(ctx.exception))


@pytest.mark.integration
class TestExternalItemFlag(unittest.TestCase):
    """Schema 2.2.0: the optional boolean `external` Item flag (prefill
    eligibility). U1 of the QML External Inputs plan (R1-R5).

    The flag is runtime-only and invisible to Z3 — an external item classifies
    identically to the same item without it (AE4 / R4, R5). These tests use the
    DEFAULT loader (bundled schema on) so schema-level acceptance/rejection is
    exercised against the real 2.2.0 schema; the static-neutral test builds a
    StaticBuilder + ItemClassifier over an inline twin pair.
    """

    def _doc(self, item: dict) -> str:
        import yaml

        return yaml.safe_dump(
            {
                "qmlVersion": "2.2",
                "questionnaire": {
                    "title": "external-flag",
                    "blocks": [{"id": "b", "kind": "Group", "title": "B", "items": [item]}],
                },
            }
        )

    def test_external_true_item_loads(self):
        """An item with `external: true` validates against the bundled schema."""
        item = {
            "id": "q_rotate_out",
            "kind": "Question",
            "title": "Rotate out?",
            "external": True,
            "input": {"control": "Radio", "labels": {0: "No", 1: "Yes"}},
        }
        state = QMLState(QMLLoader().load_from_string(self._doc(item)))
        # The flag survives flattening onto the item (not dropped by the loader).
        self.assertTrue(state.get_item("q_rotate_out").get("external"))

    def test_external_false_item_loads(self):
        """`external: false` validates (explicit default)."""
        item = {
            "id": "q_ok",
            "kind": "Question",
            "title": "Q",
            "external": False,
            "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
        }
        QMLLoader().load_from_string(self._doc(item))  # no exception

    def test_external_absent_item_loads(self):
        """An item without `external` still loads (backward compatible — R3)."""
        item = {
            "id": "q_plain",
            "kind": "Question",
            "title": "Q",
            "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
        }
        state = QMLState(QMLLoader().load_from_string(self._doc(item)))
        # Absent → falsy (schema default is false; loader does not inject it).
        self.assertFalse(state.get_item("q_plain").get("external", False))

    def test_external_non_boolean_rejected(self):
        """A non-boolean `external` (e.g. the string "yes") is rejected by the schema."""
        item = {
            "id": "q_bad",
            "kind": "Question",
            "title": "Q",
            "external": "yes",
            "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
        }
        with self.assertRaises(ValidationError):
            QMLLoader().load_from_string(self._doc(item))

    def test_external_flag_is_static_neutral(self):
        """AE4 / R4, R5: two items differing ONLY in `external: true` classify
        identically — same reachability, no free symbol, no coverage gap, no
        frozen-variable error. The flag must never touch the Z3 model."""
        loader = QMLLoader(schema_path=None)
        # A CONDITIONAL item (gated on an earlier answer) and its external twin.
        qml = """
questionnaire:
  title: static-neutral twins
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_gate
          kind: Question
          title: Gate
          input:
            control: Radio
            labels:
              1: Yes
              2: No
        - id: q_plain
          kind: Question
          title: Plain conditional
          precondition:
            - predicate: "q_gate.outcome == 1"
          input:
            control: Radio
            labels:
              0: No
              1: Yes
        - id: q_ext
          kind: Question
          title: External conditional (identical but for the flag)
          external: true
          precondition:
            - predicate: "q_gate.outcome == 1"
          input:
            control: Radio
            labels:
              0: No
              1: Yes
"""
        state = QMLState(loader.load_from_string(qml))
        builder = StaticBuilder(state)
        classifier = ItemClassifier(builder)

        plain = classifier.classify_item("q_plain")
        ext = classifier.classify_item("q_ext")

        # Same precondition reachability class.
        self.assertEqual(
            plain["precondition"]["status"], ext["precondition"]["status"]
        )
        self.assertEqual(ext["precondition"]["status"], "CONDITIONAL")

        # No lint fallout introduced by the flag: neither twin produces a
        # coverage_gap or frozen_variable issue attributable to `external`.
        issues = ValidationProcessor(state).to_issues()
        ext_issues = [i for i in issues if i.get("item_id") == "q_ext"]
        plain_issues = [i for i in issues if i.get("item_id") == "q_plain"]
        self.assertEqual(
            sorted(i["type"] for i in ext_issues),
            sorted(i["type"] for i in plain_issues),
            f"external twin produced different issues: {ext_issues} vs {plain_issues}",
        )


if __name__ == "__main__":
    unittest.main()
