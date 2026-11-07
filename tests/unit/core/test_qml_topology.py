#!/usr/bin/env python3
"""Unit tests for QMLTopology - Dependency graph and cycle detection.

This test suite verifies the QMLTopology class which handles:
1. Building dependency graphs from questionnaire items
2. Detecting cycles via Kahn's algorithm and DFS path discovery
3. Computing topological order for navigation
4. Identifying all cycle-affected items (cycle members + collateral)
5. Analyzing dependency layers and connected components

## Coverage Areas:

### Dependency Graph Building (4 tests)
- Empty questionnaire (no items)
- Linear dependencies (A → B → C)
- Multiple independent items (no dependencies)
- Complex dependencies (diamond pattern)

### Cycle Detection (5 tests)
- No cycles in linear dependencies
- Simple cycle (A → B → A)
- Complex cycle (A → B → C → A)
- Multiple cycles
- Self-referencing item

### Cycle-Tolerant Topology (3 tests)
- Complete order produced even with cycles
- Downstream items ordered after cycle members
- get_topological_order() never returns None

### Topological Ordering (4 tests)
- Correct order for linear dependencies
- Order preserves QML file order for independent items
- Order respects all dependencies
- Fallback when cycles exist

### Accumulators are read in file order (#1891, D91)
- The article's block counter (3 and 6 items) and item-level counter gates
  are no cycle; a reader depends only on the writers before it
- A counter read only after its writers keeps its dependencies
- A cycle through answers, or through variables only the other item writes, is still a cycle
- A later writer waits for an earlier reader (ordering edge)

### Dependency Analysis (3 tests)
- Connected components identification
- Dependency layers grouping
- Reachability analysis

These unit tests verify the core graph algorithms that determine questionnaire
navigation order and detect circular dependencies that would prevent valid
interview completion.
"""

import unittest

import pytest
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.static_builder import StaticBuilder

from tests.helpers.block_counter import NO_YES, counter_questionnaire


def create_questionnaire(items_data: list, code_init: str = "") -> QMLState:
    """Helper to create QMLState from item definitions."""
    return QMLState(
        {
            "title": "Test Questionnaire",
            "codeInit": code_init,
            "blocks": [{"id": "b1", "title": "Block 1"}],
            "items": [
                {
                    "id": item["id"],
                    "blockId": "b1",
                    "kind": "Question",
                    "title": f"Question {item['id']}",
                    **{k: v for k, v in item.items() if k != "id"},
                }
                for item in items_data
            ],
        }
    )


@pytest.mark.unit
@pytest.mark.topology
class TestQMLTopologyDependencyGraph(unittest.TestCase):
    """Tests for dependency graph building."""

    def test_empty_questionnaire(self):
        """Test topology with no items."""
        state = QMLState({"title": "Empty", "blocks": [], "items": []})
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertEqual(len(topology.items), 0)
        self.assertFalse(topology.has_cycles)
        self.assertEqual(topology.topological_order, [])

    def test_linear_dependencies(self):
        """Test linear dependency chain: q1 → q2 → q3."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q2.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # Check dependencies
        self.assertIn("q1", topology.dependencies.get("q2", set()))
        self.assertIn("q2", topology.dependencies.get("q3", set()))
        self.assertEqual(len(topology.dependencies.get("q1", set())), 0)

    def test_independent_items(self):
        """Test items with no dependencies."""
        state = create_questionnaire([{"id": "q1"}, {"id": "q2"}, {"id": "q3"}])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # No dependencies between items
        for item_id in ["q1", "q2", "q3"]:
            self.assertEqual(len(topology.dependencies.get(item_id, set())), 0)

        self.assertFalse(topology.has_cycles)

    def test_diamond_dependencies(self):
        """Test diamond pattern: q1 → q2, q1 → q3, q2 → q4, q3 → q4."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q1.outcome == 2"}]},
                {"id": "q4", "precondition": [{"predicate": "q2.outcome == 1 or q3.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # Check diamond structure
        self.assertIn("q1", topology.dependencies.get("q2", set()))
        self.assertIn("q1", topology.dependencies.get("q3", set()))
        self.assertIn("q2", topology.dependencies.get("q4", set()))
        self.assertIn("q3", topology.dependencies.get("q4", set()))

        self.assertFalse(topology.has_cycles)


@pytest.mark.unit
@pytest.mark.topology
@pytest.mark.cycle_detection
class TestQMLTopologyCycleDetection(unittest.TestCase):
    """Tests for cycle detection (Kahn's algorithm + DFS path discovery)."""

    def test_no_cycles_linear(self):
        """Test no cycles in linear dependencies."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q2.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertFalse(topology.has_cycles)
        self.assertEqual(len(topology.cycles), 0)

    def test_simple_cycle(self):
        """Test detection of simple cycle: q1 → q2 → q1."""
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "q2.outcome == 1"}]},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)
        self.assertGreater(len(topology.cycles), 0)

    def test_complex_cycle(self):
        """Test detection of complex cycle: q1 → q2 → q3 → q1."""
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "q3.outcome == 1"}]},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q2.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)

    def test_multiple_cycles(self):
        """Test detection with multiple independent cycles."""
        state = create_questionnaire(
            [
                # Cycle 1: q1 → q2 → q1
                {"id": "q1", "precondition": [{"predicate": "q2.outcome == 1"}]},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                # Cycle 2: q3 → q4 → q3
                {"id": "q3", "precondition": [{"predicate": "q4.outcome == 1"}]},
                {"id": "q4", "precondition": [{"predicate": "q3.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)

    def test_self_reference(self):
        """Test that self-referencing precondition is filtered out.

        A precondition referencing its own item's outcome (e.g., q1.outcome in q1's
        precondition) is semantically invalid since the item hasn't been visited yet.
        These self-references are filtered from the dependency graph and don't create cycles.
        """
        state = create_questionnaire(
            [{"id": "q1", "precondition": [{"predicate": "q1.outcome == 1"}]}]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # Self-references in preconditions are filtered out, so no cycle
        self.assertFalse(topology.has_cycles)
        # Item has no dependencies (self-reference was filtered)
        self.assertEqual(len(topology.dependencies.get("q1", set())), 0)


@pytest.mark.unit
@pytest.mark.topology
@pytest.mark.cycle_detection
class TestCycleTolerantTopology(unittest.TestCase):
    """Tests for cycle-tolerant Kahn's: always produces a complete topological order."""

    def test_complete_order_with_cycle(self):
        """All items appear in topological_order even when cycles exist.

        Cycle: q1 → q2 → q3 → q1. q4 depends on q2. q5 independent.
        All 5 items should be in the order.
        """
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "q3.outcome == 1"}]},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q2.outcome == 1"}]},
                {"id": "q4", "precondition": [{"predicate": "q2.outcome == 1"}]},
                {"id": "q5"},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)
        # All items appear in order
        self.assertEqual(set(topology.topological_order), {"q1", "q2", "q3", "q4", "q5"})
        # q5 (independent) comes before cycle members that depend on others
        self.assertLess(
            topology.topological_order.index("q5"),
            topology.topological_order.index("q4"),
        )

    def test_downstream_items_ordered_after_cycle(self):
        """Items depending on cycle members are properly ordered after them."""
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "q2.outcome == 1"}]},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q2.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        self.assertTrue(topology.has_cycles)
        order = topology.topological_order
        self.assertEqual(len(order), 3)
        # q3 depends on q2 (cycle member) → q3 comes after q2
        self.assertGreater(order.index("q3"), order.index("q2"))

    def test_get_topological_order_never_none(self):
        """get_topological_order() always returns a list, never None."""
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "q2.outcome == 1"}]},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)
        self.assertEqual(set(order), {"q1", "q2"})


@pytest.mark.unit
@pytest.mark.topology
class TestQMLTopologyTopologicalOrder(unittest.TestCase):
    """Tests for topological ordering."""

    def test_linear_order(self):
        """Test correct order for linear dependencies."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q2.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q1 must come before q2, q2 must come before q3
        self.assertLess(order.index("q1"), order.index("q2"))
        self.assertLess(order.index("q2"), order.index("q3"))

    def test_preserves_qml_order_for_independent(self):
        """Test that QML file order is preserved for independent items."""
        state = create_questionnaire([{"id": "q1"}, {"id": "q2"}, {"id": "q3"}])
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # Should preserve original order: q1, q2, q3
        self.assertEqual(order, ["q1", "q2", "q3"])
        # Regression guard: the canonical stable-Kahn order is unchanged by the
        # removal of the orphaned Sample-only topology helpers — the ordering
        # path (min-heap Kahn + cycle handling) is byte-identical.
        self.assertEqual(topology.topological_order, ["q1", "q2", "q3"])

    def test_respects_all_dependencies(self):
        """Test that order respects all dependencies in diamond pattern."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q1.outcome == 2"}]},
                {
                    "id": "q4",
                    "precondition": [{"predicate": "q2.outcome == 1 and q3.outcome == 1"}],
                },
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q1 must come before q2 and q3
        self.assertLess(order.index("q1"), order.index("q2"))
        self.assertLess(order.index("q1"), order.index("q3"))
        # q2 and q3 must come before q4
        self.assertLess(order.index("q2"), order.index("q4"))
        self.assertLess(order.index("q3"), order.index("q4"))

    def test_returns_order_even_with_cycles(self):
        """Topological order is always available, even when cycles exist."""
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "q2.outcome == 1"}]},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)
        self.assertEqual(set(order), {"q1", "q2"})
        self.assertTrue(topology.has_cycles)


@pytest.mark.unit
@pytest.mark.topology
class TestQMLTopologyAnalysis(unittest.TestCase):
    """Tests for dependency analysis features."""

    def test_connected_components_independent(self):
        """Test identification of independent components."""
        state = create_questionnaire(
            [
                # Component 1: q1 → q2
                {"id": "q1"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                # Component 2: q3 → q4
                {"id": "q3"},
                {"id": "q4", "precondition": [{"predicate": "q3.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        components = topology.get_components()
        self.assertEqual(len(components), 2)

    def test_dependency_layers(self):
        """Test grouping items into dependency layers."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2"},
                {"id": "q3", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q4", "precondition": [{"predicate": "q3.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        layers = topology.get_dependency_layers()

        # Layer 0: q1, q2 (no dependencies)
        # Layer 1: q3 (depends on q1)
        # Layer 2: q4 (depends on q3)
        self.assertEqual(len(layers), 3)
        self.assertIn("q1", layers[0])
        self.assertIn("q2", layers[0])
        self.assertIn("q3", layers[1])
        self.assertIn("q4", layers[2])

    def test_reachability(self):
        """Test reachability analysis between items."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
                {"id": "q3", "precondition": [{"predicate": "q2.outcome == 1"}]},
                {"id": "q4"},  # Independent
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        # q3 can reach q1 through dependencies
        self.assertTrue(topology.can_reach("q3", "q1"))
        self.assertTrue(topology.can_reach("q3", "q2"))

        # q4 cannot reach q1 (independent)
        self.assertFalse(topology.can_reach("q4", "q1"))

        # Self-reachability
        self.assertTrue(topology.can_reach("q1", "q1"))


@pytest.mark.unit
@pytest.mark.topology
@pytest.mark.transitive
class TestQMLTopologyTransitiveDependencies(unittest.TestCase):
    """Tests for transitive dependency resolution through variables.

    These tests verify that QMLTopology correctly handles dependencies that
    flow through variables, ensuring proper topological ordering.
    """

    def test_topology_respects_transitive_dependencies(self):
        """Test that topology orders items correctly via transitive variable dependencies."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "score = q1.outcome"},
                {"id": "q2", "precondition": [{"predicate": "score > 5"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)
        # q1 must come before q2 because q2 depends on var:score which depends on q1
        self.assertLess(order.index("q1"), order.index("q2"))

    def test_topology_scoring_pattern(self):
        """Test topology with scoring pattern - result depends on all score modifiers."""
        state = create_questionnaire(
            [
                {"id": "q_age", "codeBlock": "risk = risk + 1"},
                {"id": "q_smoker", "codeBlock": "risk = risk + 2"},
                {"id": "q_exercise", "codeBlock": "risk = risk - 1"},
                {"id": "q_result", "precondition": [{"predicate": "risk >= 0"}]},
            ],
            code_init="risk = 0",
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q_result must come after all items that modify risk
        result_idx = order.index("q_result")
        for item_id in ["q_age", "q_smoker", "q_exercise"]:
            self.assertLess(
                order.index(item_id), result_idx, f"{item_id} should come before q_result"
            )

    def test_topology_multi_hop_variable_chain(self):
        """Test topology with multi-hop variable chain: q3 → var:total → var:score → q1."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "score = q1.outcome"},
                {"id": "q2", "codeBlock": "total = score + 10"},
                {"id": "q3", "precondition": [{"predicate": "total > 20"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q1 must come first, then q2, then q3
        self.assertLess(order.index("q1"), order.index("q2"))
        self.assertLess(order.index("q2"), order.index("q3"))

    def test_topology_postcondition_transitive_dependency(self):
        """Test topology handles postcondition-based transitive dependencies."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "total = q1.outcome"},
                {"id": "q2", "postcondition": [{"predicate": "total > 0"}]},
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q1 must come before q2 because q2's postcondition depends on var:total → q1
        self.assertLess(order.index("q1"), order.index("q2"))

    def test_topology_mixed_direct_and_transitive_deps(self):
        """Test topology with mix of direct and transitive dependencies."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "codeBlock": "flag = q2.outcome"},
                {
                    "id": "q3",
                    "precondition": [
                        {"predicate": "q1.outcome > 0"},  # Direct dependency on q1
                        {"predicate": "flag == 1"},  # Transitive dependency on q2 via flag
                    ],
                },
            ]
        )
        builder = StaticBuilder(state)
        topology = QMLTopology(state, builder)

        order = topology.get_topological_order()
        self.assertIsNotNone(order)

        # q3 must come after both q1 and q2
        self.assertLess(order.index("q1"), order.index("q3"))
        self.assertLess(order.index("q2"), order.index("q3"))


def _topology(state: QMLState) -> QMLTopology:
    return QMLTopology(state, StaticBuilder(state))


@pytest.mark.unit
@pytest.mark.topology
class TestAccumulatorIsNotACycle(unittest.TestCase):
    """A variable written by items and read by their (block's) preconditions is
    an accumulator, read in file order (#1891, D91): a reader depends on the
    writers before it in the file, so the article's counter is no cycle, and
    the walk asks its items in file order. A cycle through answers stays one."""

    def test_the_article_counter_is_no_cycle(self):
        for count in (3, 6):
            with self.subTest(count=count):
                topology = _topology(counter_questionnaire(count))

                self.assertFalse(topology.has_cycles, topology.get_cycles())
                self.assertEqual(topology.get_topological_order(), [f"q{n}" for n in range(1, count + 1)])

    def test_a_reader_depends_on_the_writers_before_it_only(self):
        dependencies = _topology(counter_questionnaire(6)).get_dependency_chains()

        self.assertEqual(dependencies["q1"], set())
        self.assertEqual(dependencies["q4"], {"q1", "q2", "q3"})

    def test_item_level_counter_gates_are_no_cycle(self):
        topology = _topology(counter_questionnaire(6, block_gate=None, item_gate_from=4))

        self.assertFalse(topology.has_cycles, topology.get_cycles())
        self.assertEqual(topology.get_dependency_chains()["q4"], {"q1", "q2", "q3"})

    def test_a_counter_read_only_after_its_writers_keeps_its_dependencies(self):
        state = counter_questionnaire(
            3,
            block_gate=None,
            extra_blocks=[{"id": "b2", "title": "Follow-up", "precondition": [{"predicate": "negative_count >= 3"}]}],
            extra_items=[{"id": "q_why", "blockId": "b2", "kind": "Question", "title": "Why?", "input": NO_YES}],
        )
        builder = StaticBuilder(state)

        self.assertEqual(builder.accumulator_variables(), set())
        self.assertEqual(builder.get_item_dependencies()["q_why"], {"q1", "q2", "q3"})

    def test_a_cycle_through_answers_is_still_a_cycle(self):
        state = create_questionnaire(
            [
                {"id": "a", "input": NO_YES, "precondition": [{"predicate": "b.outcome == 1"}]},
                {"id": "b", "input": NO_YES, "precondition": [{"predicate": "a.outcome == 1"}]},
            ]
        )

        self.assertTrue(_topology(state).has_cycles)

    def test_a_copy_of_the_counter_sees_it_where_it_was_copied(self):
        """``w`` copies the counter after q1 and q2; q4 counts after ``w``. A
        gate reading the copy depends on what ``w`` saw, not on q4."""
        state = counter_questionnaire(
            2,
            extra_blocks=[{"id": "b2", "title": "Later"}],
            extra_items=[
                {"id": "w", "blockId": "b2", "kind": "Question", "title": "W", "input": NO_YES,
                 "codeBlock": "snapshot = negative_count"},
                {"id": "q4", "blockId": "b2", "kind": "Question", "title": "Q4", "input": NO_YES,
                 "precondition": [{"predicate": "negative_count < 3"}],
                 "codeBlock": "negative_count = negative_count + 1"},
                {"id": "r", "blockId": "b2", "kind": "Question", "title": "R", "input": NO_YES,
                 "precondition": [{"predicate": "snapshot >= 1"}]},
            ],
        )

        self.assertEqual(StaticBuilder(state).get_item_dependencies()["r"], {"w", "q1", "q2"})

    def test_a_self_reading_writer_with_no_cycle_keeps_dependency_order(self):
        """q1 reads and writes ``x``, q2 sets it later, nothing waits for q1:
        no cycle, so the walk still asks q2 first, as it did before #1891."""
        state = create_questionnaire(
            [
                {"id": "q1", "input": NO_YES, "precondition": [{"predicate": "x < 3"}], "codeBlock": "x = x + 1"},
                {"id": "q2", "input": NO_YES, "codeBlock": "x = 10"},
            ],
            code_init="x = 0",
        )
        builder = StaticBuilder(state)

        self.assertEqual(builder.accumulator_variables(), set())
        self.assertEqual(builder.topology.get_topological_order(), ["q2", "q1"])

    def test_items_gated_on_what_only_the_other_writes_are_still_a_cycle(self):
        """Neither item reads what it writes, so neither variable is an accumulator."""
        state = create_questionnaire(
            [
                {"id": "a", "input": NO_YES, "precondition": [{"predicate": "pb == 1"}], "codeBlock": "pa = 1"},
                {"id": "b", "input": NO_YES, "precondition": [{"predicate": "pa == 1"}], "codeBlock": "pb = 1"},
            ],
            code_init="pa = 0\npb = 0",
        )

        self.assertTrue(_topology(state).has_cycles)

    def test_a_later_writer_waits_for_an_earlier_reader(self):
        """An unrelated dependency must not let the walk ask a later writer of
        the counter before an earlier reader: the reader would then see an
        update D91 says it does not."""
        state = counter_questionnaire(
            2,
            extra_blocks=[{"id": "b2", "title": "Unrelated"}],
            extra_items=[
                {"id": "q_reset", "blockId": "b2", "kind": "Question", "title": "Reset", "input": NO_YES,
                 "codeBlock": "negative_count = 0\n"},
                {"id": "q_z", "blockId": "b2", "kind": "Question", "title": "Z", "input": NO_YES},
            ],
        )
        state.get_item("q1")["precondition"] = [{"predicate": "q_z.outcome is not None"}]
        topology = _topology(state)
        order = topology.get_topological_order()

        self.assertFalse(topology.has_cycles, topology.get_cycles())
        self.assertLess(order.index("q1"), order.index("q_reset"))


if __name__ == "__main__":
    unittest.main()
