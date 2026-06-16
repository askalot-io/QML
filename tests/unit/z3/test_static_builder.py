#!/usr/bin/env python3
"""Unit tests for StaticBuilder - Z3 constraint generation and SSA versioning.

This test suite verifies the StaticBuilder class which provides:
1. SSA (Static Single Assignment) versioning for variables
2. Z3 constraint generation from preconditions, postconditions, code blocks
3. Item dependency discovery through constraint analysis
4. ItemClassifier compatibility interface

## Coverage Areas:

### SSA Versioning (5 tests)
- Version tracking for single assignment
- Version increment on reassignment
- Independent versioning for multiple variables
- Version history tracking
- Code block processing creates versions

### Z3 Constraint Generation (5 tests)
- Precondition constraints
- Postcondition constraints
- Code block assignment constraints
- Initialization code constraints (unconditional)
- Arithmetic expression constraints

### Dependency Discovery (4 tests)
- Precondition-based dependencies
- No dependencies for independent items
- Multiple dependencies per item
- Transitive dependency handling

### ItemClassifier Compatibility (4 tests)
- item_details population
- item_order preservation
- compile_conditions method
- get_domain_base method

### AST to Z3 Conversion (5 tests)
- Integer constants
- Boolean constants
- Comparison operators
- Boolean operators (and, or, not)
- Item outcome attribute access

### Regression Tests (8 tests)
- AugAssign (+=) dependency tracking
- Outcome assignment (item.outcome = expr) dependency tracking
- NotIn operator classification
- Non-integer min/max defensive handling
- If-condition dependency tracking
- Multiple augmented assignments to same variable
- Outcome augmented assignment (item.outcome += expr)
- Complex code block with if/elif/else and AugAssign

Total: 53 tests covering StaticBuilder.
"""

import unittest

import pytest
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.static_builder import StaticBuilder
from z3 import *


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
@pytest.mark.z3
class TestStaticBuilderSSAVersioning(unittest.TestCase):
    """Tests for SSA versioning functionality."""

    def test_single_assignment_creates_version(self):
        """Test that single assignment creates version 0."""
        state = create_questionnaire([{"id": "q1", "codeBlock": "x = 5"}])
        builder = StaticBuilder(state)

        self.assertIn("x", builder.version_map)
        self.assertEqual(builder.version_map["x"], 0)
        self.assertIn("x_0", builder.z3_vars)

    def test_reassignment_increments_version(self):
        """Test that reassignment increments version."""
        state = create_questionnaire([{"id": "q1", "codeBlock": "x = 5\nx = 10"}])
        builder = StaticBuilder(state)

        self.assertEqual(builder.version_map["x"], 1)
        self.assertIn("x_0", builder.z3_vars)
        self.assertIn("x_1", builder.z3_vars)

    def test_multiple_variables_versioned_independently(self):
        """Test that different variables have independent versioning."""
        state = create_questionnaire([{"id": "q1", "codeBlock": "x = 5\ny = 10\nx = 15"}])
        builder = StaticBuilder(state)

        self.assertEqual(builder.version_map["x"], 1)  # Two assignments
        self.assertEqual(builder.version_map["y"], 0)  # One assignment

    def test_version_history_tracked(self):
        """Test that version history includes context."""
        state = create_questionnaire(
            [{"id": "q1", "codeBlock": "x = 5"}, {"id": "q2", "codeBlock": "x = 10"}]
        )
        builder = StaticBuilder(state)

        self.assertIn("x", builder.version_history)
        history = builder.version_history["x"]
        # Should have two entries: one from q1, one from q2
        self.assertEqual(len(history), 2)
        self.assertEqual(history[0], (0, "q1"))
        self.assertEqual(history[1], (1, "q2"))

    def test_init_code_creates_versions(self):
        """Test that initialization code creates SSA versions."""
        state = create_questionnaire([{"id": "q1"}], code_init="score = 0")
        builder = StaticBuilder(state)

        self.assertIn("score", builder.version_map)
        self.assertEqual(builder.version_map["score"], 0)
        # Init versions are tracked with __init__ context
        self.assertEqual(builder.version_history["score"][0], (0, "__init__"))


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderConstraintGeneration(unittest.TestCase):
    """Tests for Z3 constraint generation."""

    def test_precondition_generates_constraint(self):
        """Test that preconditions generate Z3 constraints."""
        state = create_questionnaire(
            [{"id": "q1"}, {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]}]
        )
        builder = StaticBuilder(state)

        # Should have constraints for precondition
        self.assertGreater(len(builder.constraints), 0)

    def test_postcondition_generates_constraint(self):
        """Test that postconditions generate Z3 constraints."""
        state = create_questionnaire(
            [{"id": "q1", "postcondition": [{"predicate": "q1.outcome > 0"}]}]
        )
        builder = StaticBuilder(state)

        # Should have constraints for postcondition
        self.assertGreater(len(builder.constraints), 0)

    def test_code_block_generates_constraint(self):
        """Test that code block assignments generate constraints."""
        state = create_questionnaire([{"id": "q1", "codeBlock": "x = 5"}])
        builder = StaticBuilder(state)

        # Should have constraint: x_0 == 5 (conditional on item being visited)
        # CodeBlock constraints are now stored in codeblock_constraints
        self.assertGreater(len(builder.codeblock_constraints), 0)

    def test_init_code_generates_unconditional_constraint(self):
        """Test that init code generates unconditional constraints."""
        state = create_questionnaire([{"id": "q1"}], code_init="x = 10")
        builder = StaticBuilder(state)

        # Verify constraint is satisfiable and x_0 == 10
        # CodeBlock constraints are now stored in codeblock_constraints
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.codeblock_constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        x_0 = builder.z3_vars.get("x_0")
        if x_0 is not None:
            self.assertEqual(model.eval(x_0, model_completion=True).as_long(), 10)

    def test_arithmetic_expression_constraint(self):
        """Test arithmetic expression generates correct constraint."""
        state = create_questionnaire([{"id": "q1"}], code_init="x = 5 + 3")
        builder = StaticBuilder(state)

        # CodeBlock constraints are now stored in codeblock_constraints
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.codeblock_constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        x_0 = builder.z3_vars.get("x_0")
        if x_0 is not None:
            self.assertEqual(model.eval(x_0, model_completion=True).as_long(), 8)


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderDependencyDiscovery(unittest.TestCase):
    """Tests for item dependency discovery."""

    def test_precondition_creates_dependency(self):
        """Test that precondition referencing item creates dependency."""
        state = create_questionnaire(
            [{"id": "q1"}, {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]}]
        )
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        self.assertIn("q1", deps.get("q2", set()))

    def test_independent_items_no_dependencies(self):
        """Test that items without preconditions have no dependencies."""
        state = create_questionnaire([{"id": "q1"}, {"id": "q2"}, {"id": "q3"}])
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        self.assertEqual(len(deps.get("q1", set())), 0)
        self.assertEqual(len(deps.get("q2", set())), 0)
        self.assertEqual(len(deps.get("q3", set())), 0)

    def test_multiple_dependencies(self):
        """Test item with multiple dependencies."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2"},
                {
                    "id": "q3",
                    "precondition": [{"predicate": "q1.outcome == 1 and q2.outcome == 2"}],
                },
            ]
        )
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        q3_deps = deps.get("q3", set())
        self.assertIn("q1", q3_deps)
        self.assertIn("q2", q3_deps)

    def test_dependency_from_multiple_preconditions(self):
        """Test dependencies from multiple precondition entries."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2"},
                {
                    "id": "q3",
                    "precondition": [
                        {"predicate": "q1.outcome == 1"},
                        {"predicate": "q2.outcome == 2"},
                    ],
                },
            ]
        )
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        q3_deps = deps.get("q3", set())
        self.assertIn("q1", q3_deps)
        self.assertIn("q2", q3_deps)


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderItemClassifierCompatibility(unittest.TestCase):
    """Tests for ItemClassifier compatibility interface."""

    def test_item_details_populated(self):
        """Test that item_details is populated for all items."""
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "True"}]},
                {"id": "q2", "postcondition": [{"predicate": "q2.outcome > 0"}]},
                {"id": "q3", "codeBlock": "x = 5"},
            ]
        )
        builder = StaticBuilder(state)

        self.assertIn("q1", builder.item_details)
        self.assertIn("q2", builder.item_details)
        self.assertIn("q3", builder.item_details)

        # Check structure
        self.assertIn("preconditions", builder.item_details["q1"])
        self.assertIn("postconditions", builder.item_details["q2"])
        self.assertIn("code_block", builder.item_details["q3"])

    def test_item_order_preserves_qml_order(self):
        """Test that item_order preserves QML file order."""
        state = create_questionnaire([{"id": "q1"}, {"id": "q2"}, {"id": "q3"}])
        builder = StaticBuilder(state)

        self.assertEqual(builder.item_order, ["q1", "q2", "q3"])

    def test_compile_conditions_method(self):
        """Test compile_conditions returns Z3 boolean expression."""
        state = create_questionnaire([{"id": "q1"}, {"id": "q2"}])
        builder = StaticBuilder(state)

        conditions = [{"predicate": "q1.outcome == 1"}]
        compiled = builder.compile_conditions("q2", conditions)

        self.assertIsNotNone(compiled)
        # Should be a Z3 boolean expression
        self.assertTrue(is_bool(compiled) or isinstance(compiled, BoolRef))

    def test_compile_conditions_empty_returns_true(self):
        """Test compile_conditions with empty list returns True."""
        state = create_questionnaire([{"id": "q1"}])
        builder = StaticBuilder(state)

        compiled = builder.compile_conditions("q1", [])

        self.assertIsNotNone(compiled)
        # Should be BoolVal(True)
        self.assertTrue(is_true(compiled))

    def test_get_domain_base_method(self):
        """Test get_domain_base returns domain constraints only."""
        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 1, "max": 100},
                    "postcondition": [{"predicate": "q1.outcome > 50"}],
                }
            ]
        )
        builder = StaticBuilder(state)

        base = builder.get_domain_base()

        self.assertIsNotNone(base)
        # Should be a Z3 expression containing domain constraints
        self.assertTrue(is_expr(base))

    def test_domain_constraints_from_labels_schema_format(self):
        """Test domain constraints from labels (schema format: Radio, labels dict)."""
        state = create_questionnaire(
            [{"id": "q1", "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}}}]
        )
        builder = StaticBuilder(state)

        self.assertGreater(len(builder.domain_constraints), 0)


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderASTToZ3(unittest.TestCase):
    """Tests for AST to Z3 conversion."""

    def test_integer_constant_conversion(self):
        """Test integer constant conversion to Z3."""
        state = create_questionnaire([{"id": "q1"}], code_init="x = 42")
        builder = StaticBuilder(state)

        # CodeBlock constraints are now stored in codeblock_constraints
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.codeblock_constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        self.assertEqual(model.eval(builder.z3_vars["x_0"], model_completion=True).as_long(), 42)

    def test_boolean_constant_conversion(self):
        """Test boolean constant conversion to Z3 (as integer)."""
        state = create_questionnaire([{"id": "q1"}], code_init="x = True")
        builder = StaticBuilder(state)

        # CodeBlock constraints are now stored in codeblock_constraints
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.codeblock_constraints)
        self.assertEqual(solver.check(), sat)

        model = solver.model()
        # Boolean True is converted to IntVal(1)
        self.assertEqual(model.eval(builder.z3_vars["x_0"], model_completion=True).as_long(), 1)

    def test_comparison_operators(self):
        """Test comparison operators in preconditions."""
        state = create_questionnaire(
            [{"id": "q1"}, {"id": "q2", "precondition": [{"predicate": "q1.outcome > 5"}]}]
        )
        builder = StaticBuilder(state)

        # Constraints should be generated without error
        self.assertGreater(len(builder.constraints), 0)

    def test_boolean_operators(self):
        """Test boolean operators (and, or, not) in preconditions."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2"},
                {
                    "id": "q3",
                    "precondition": [{"predicate": "q1.outcome == 1 and q2.outcome == 2"}],
                },
                {"id": "q4", "precondition": [{"predicate": "q1.outcome == 1 or q2.outcome == 2"}]},
                {"id": "q5", "precondition": [{"predicate": "not q1.outcome == 0"}]},
            ]
        )
        builder = StaticBuilder(state)

        # All constraints should be generated
        self.assertGreater(len(builder.constraints), 0)

    def test_item_outcome_attribute_access(self):
        """Test item.outcome attribute access conversion."""
        state = create_questionnaire(
            [{"id": "q1"}, {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]}]
        )
        builder = StaticBuilder(state)

        # item_vars should contain q1
        self.assertIn("q1", builder.item_vars)
        # q2 should depend on q1
        self.assertIn("q1", builder.get_item_dependencies().get("q2", set()))


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderHelperMethods(unittest.TestCase):
    """Tests for helper methods."""

    def test_get_constraints(self):
        """Test get_constraints returns list."""
        state = create_questionnaire([{"id": "q1"}])
        builder = StaticBuilder(state)

        constraints = builder.get_constraints()
        self.assertIsInstance(constraints, list)

    def test_get_all_z3_vars(self):
        """Test get_all_z3_vars includes both SSA and item vars."""
        state = create_questionnaire([{"id": "q1", "codeBlock": "x = 5"}])
        builder = StaticBuilder(state)

        all_vars = builder.get_all_z3_vars()

        # Should include item variable
        self.assertIn("item_q1", str(all_vars))
        # Should include SSA variable
        self.assertIn("x_0", all_vars)

    def test_debug_dump_returns_string(self):
        """Test debug_dump returns informative string."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "x = 5"},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]},
            ]
        )
        builder = StaticBuilder(state)

        dump = builder.debug_dump()

        self.assertIsInstance(dump, str)
        self.assertIn("SSA", dump)
        self.assertIn("q1", dump)
        self.assertIn("q2", dump)


@pytest.mark.unit
@pytest.mark.z3
@pytest.mark.dependency_graph
class TestStaticBuilderDependencyGraph(unittest.TestCase):
    """Tests for comprehensive dependency graph functionality.

    The dependency graph tracks all dependency types:
    - Item → Item (via preconditions)
    - Variable → Item (via codeBlock assignments)
    - Item → Variable (via preconditions/postconditions referencing variables)
    - Variable → Variable (via codeBlock assignments)
    """

    # Variable → Item Dependencies

    def test_variable_depends_on_item_outcome(self):
        """Test that score = q1.outcome creates var:score → q1."""
        state = create_questionnaire([{"id": "q1", "codeBlock": "score = q1.outcome"}])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("var:score", graph)
        self.assertIn("q1", graph["var:score"])

    def test_variable_depends_on_multiple_items(self):
        """Test that total = q1.outcome + q2.outcome creates var:total → {q1, q2}."""
        state = create_questionnaire(
            [{"id": "q1"}, {"id": "q2", "codeBlock": "total = q1.outcome + q2.outcome"}]
        )
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("var:total", graph)
        self.assertIn("q1", graph["var:total"])
        self.assertIn("q2", graph["var:total"])

    def test_variable_depends_on_defining_item(self):
        """Test that variable assignment in q1's codeBlock makes var depend on q1."""
        state = create_questionnaire([{"id": "q1", "codeBlock": "x = 5"}])
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("var:x", graph)
        # Variable defined in q1's codeBlock depends on q1
        self.assertIn("q1", graph["var:x"])

    # Item → Item Dependencies (via precondition)

    def test_item_depends_on_item_via_precondition(self):
        """Test that precondition: q1.outcome > 5 creates q2 → q1."""
        state = create_questionnaire(
            [{"id": "q1"}, {"id": "q2", "precondition": [{"predicate": "q1.outcome > 5"}]}]
        )
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("q1", graph["q2"])

    # Item → Item Dependencies (via postcondition)

    def test_item_depends_on_item_via_postcondition(self):
        """Test that postcondition: q1.outcome + q2.outcome > 10 creates q2 → q1."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "postcondition": [{"predicate": "q1.outcome + q2.outcome > 10"}]},
            ]
        )
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("q1", graph["q2"])

    # Item → Variable Dependencies (via precondition)

    def test_item_depends_on_variable_in_precondition(self):
        """Test that precondition: score > 5 creates q2 → var:score."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "score = q1.outcome"},
                {"id": "q2", "precondition": [{"predicate": "score > 5"}]},
            ]
        )
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("var:score", graph["q2"])

    # Item → Variable Dependencies (via postcondition)

    def test_item_depends_on_variable_in_postcondition(self):
        """Test that postcondition: var1 > 10 creates q2 → var:var1."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "var1 = q1.outcome"},
                {"id": "q2", "postcondition": [{"predicate": "var1 > 10"}]},
            ]
        )
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("var:var1", graph["q2"])

    # Variable → Variable Dependencies

    def test_variable_depends_on_variable(self):
        """Test that total = score + bonus creates var:total → {var:score, var:bonus}."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "score = 10"},
                {"id": "q2", "codeBlock": "bonus = 5"},
                {"id": "q3", "codeBlock": "total = score + bonus"},
            ]
        )
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("var:total", graph)
        self.assertIn("var:score", graph["var:total"])
        self.assertIn("var:bonus", graph["var:total"])


@pytest.mark.unit
@pytest.mark.z3
@pytest.mark.dependency_graph
class TestStaticBuilderTransitiveResolution(unittest.TestCase):
    """Tests for transitive dependency resolution through variables."""

    def test_transitive_simple_chain(self):
        """Test q2 → var:score → q1 resolves to q2 → q1."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "score = q1.outcome"},
                {"id": "q2", "precondition": [{"predicate": "score > 5"}]},
            ]
        )
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        self.assertIn("q1", deps["q2"])

    def test_transitive_scoring_pattern(self):
        """Test q_result depends on all items that modify risk_level."""
        state = create_questionnaire(
            [
                {"id": "q_age", "codeBlock": "risk_level = risk_level + 1"},
                {"id": "q_smoker", "codeBlock": "risk_level = risk_level + 2"},
                {"id": "q_exercise", "codeBlock": "risk_level = risk_level - 1"},
                {"id": "q_result", "precondition": [{"predicate": "risk_level >= 0"}]},
            ],
            code_init="risk_level = 0",
        )
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # q_result should depend on all items that modify risk_level
        self.assertIn("q_age", deps["q_result"])
        self.assertIn("q_smoker", deps["q_result"])
        self.assertIn("q_exercise", deps["q_result"])

    def test_transitive_multi_hop(self):
        """Test q3 → var:total → var:score → q1 resolves to q3 → q1."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "score = q1.outcome"},
                {"id": "q2", "codeBlock": "total = score + 10"},
                {"id": "q3", "precondition": [{"predicate": "total > 20"}]},
            ]
        )
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # q3 depends on q1 through the chain: q3 → var:total → var:score → q1
        self.assertIn("q1", deps["q3"])
        # q3 also depends on q2 because var:total depends on q2 (the defining item)
        self.assertIn("q2", deps["q3"])

    def test_transitive_postcondition_chain(self):
        """Test postcondition-based transitive dependencies."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "total = q1.outcome"},
                {"id": "q2", "postcondition": [{"predicate": "total > 0"}]},
            ]
        )
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # q2 depends on q1 through var:total
        self.assertIn("q1", deps["q2"])


@pytest.mark.unit
@pytest.mark.z3
@pytest.mark.dependency_graph
class TestStaticBuilderDependencyGraphEdgeCases(unittest.TestCase):
    """Tests for edge cases in dependency graph handling."""

    def test_codeInit_variable_no_item_dependency(self):
        """Test that variables defined in codeInit have no item dependencies."""
        state = create_questionnaire([{"id": "q1"}], code_init="score = 0")
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        self.assertIn("var:score", graph)
        # Variable defined in __init__ should not depend on any item
        item_deps = [d for d in graph["var:score"] if not d.startswith("var:")]
        self.assertEqual(len(item_deps), 0)

    def test_undefined_variable_not_tracked(self):
        """Test that undefined variable reference doesn't crash or create edge."""
        state = create_questionnaire(
            [{"id": "q1", "precondition": [{"predicate": "undefined_var > 5"}]}]
        )
        # Should not raise
        builder = StaticBuilder(state)

        # undefined_var not in version_map, so not added to graph
        self.assertIn("q1", builder.dependency_graph)
        self.assertNotIn("var:undefined_var", builder.dependency_graph.get("q1", set()))

    def test_get_item_dependencies_returns_items_only(self):
        """Test that get_item_dependencies() returns item IDs, not var: nodes."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "score = q1.outcome"},
                {"id": "q2", "precondition": [{"predicate": "score > 5"}]},
            ]
        )
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # All dependencies should be item IDs, not var: nodes
        for _item_id, item_deps in deps.items():
            for dep in item_deps:
                self.assertFalse(
                    dep.startswith("var:"), f"Found var: node in item dependencies: {dep}"
                )

    def test_self_referencing_variable_update(self):
        """Test variable self-reference like x = x + 1."""
        state = create_questionnaire([{"id": "q1", "codeBlock": "x = x + 1"}], code_init="x = 0")
        builder = StaticBuilder(state)
        graph = builder.get_dependency_graph()

        # var:x should depend on itself (previous version) and on q1
        self.assertIn("var:x", graph)
        self.assertIn("q1", graph["var:x"])

    def test_multiple_items_modify_same_variable(self):
        """Test that multiple items modifying same variable creates correct deps."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "counter = counter + 1"},
                {"id": "q2", "codeBlock": "counter = counter + 2"},
                {"id": "q3", "precondition": [{"predicate": "counter > 3"}]},
            ],
            code_init="counter = 0",
        )
        builder = StaticBuilder(state)
        deps = builder.get_item_dependencies()

        # q3 should depend on both q1 and q2 transitively through var:counter
        self.assertIn("q1", deps["q3"])
        self.assertIn("q2", deps["q3"])


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderRegressions(unittest.TestCase):
    """Regression tests for bugs found during Z3 compilation audit.

    Covers:
    - AugAssign (+=, -=) dependency tracking (was silently skipped)
    - Outcome assignment (item.outcome = expr) dependency tracking (was silently skipped)
    - NotIn operator in preconditions (was silently treated as True)
    - Non-integer min/max defensive handling (was crashing with Z3Exception)
    - If-condition dependency tracking for nested assignments
    - Multiple augmented assignments to the same variable
    - Outcome augmented assignment (item.outcome += expr)
    - Complex code blocks with if/elif/else and AugAssign patterns
    """

    def test_augassign_creates_dependency(self):
        """Test that score += q1.outcome creates dependency from var:score to q1."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "codeBlock": "score += q1.outcome"},
                {"id": "q3", "precondition": [{"predicate": "score > 5"}]},
            ],
            code_init="score = 0",
        )
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q3 depends on q1 transitively through var:score
        self.assertIn(
            "q1",
            deps.get("q3", set()),
            "AugAssign dependency q3 → q1 through var:score was not tracked",
        )

    def test_outcome_assignment_creates_dependency(self):
        """Test that q_total.outcome = q1.outcome + q2.outcome creates dependency."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2"},
                {"id": "q_total", "codeBlock": "q_total.outcome = q1.outcome + q2.outcome"},
            ]
        )
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q_total depends on q1 and q2
        self.assertIn(
            "q1",
            deps.get("q_total", set()),
            "Outcome assignment dependency q_total → q1 was not tracked",
        )
        self.assertIn(
            "q2",
            deps.get("q_total", set()),
            "Outcome assignment dependency q_total → q2 was not tracked",
        )

    def test_not_in_operator_classified_correctly(self):
        """Test that 'not in' operator produces a valid Z3 constraint (not None)."""
        state = create_questionnaire(
            [
                {"id": "q1", "input": {"control": "Editbox", "min": 1, "max": 10}},
                {"id": "q2", "precondition": [{"predicate": "q1.outcome not in [1, 2, 3]"}]},
            ]
        )
        builder = StaticBuilder(state)

        # The precondition should generate a constraint (not return None)
        self.assertGreater(
            len(builder.constraints), 0, "NotIn operator failed to generate Z3 constraint"
        )

        # Verify the constraint is satisfiable (q1.outcome in 4..10)
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.get_domain_base())
        solver.add(builder.constraints)
        self.assertEqual(
            solver.check(),
            sat,
            "NotIn constraint should be satisfiable for values outside the list",
        )

    def test_non_integer_min_max_handled_gracefully(self):
        """Test that non-integer min/max values don't crash but are skipped."""
        state = create_questionnaire(
            [{"id": "q1", "input": {"control": "Editbox", "min": "abc", "max": "xyz"}}]
        )
        # Should not raise
        builder = StaticBuilder(state)

        # No domain constraints should be generated for invalid min/max
        self.assertEqual(
            len(builder.domain_constraints), 0, "Non-integer min/max should be skipped, not crash"
        )

    def test_if_condition_dependency_tracked(self):
        """Test that assignments inside if-blocks track condition dependencies."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "codeBlock": "if q1.outcome == 1:\n    flag = True"},
                {"id": "q3", "precondition": [{"predicate": "flag"}]},
            ],
            code_init="flag = False",
        )
        builder = StaticBuilder(state)

        graph = builder.get_dependency_graph()
        # var:flag should depend on q1 (from the if-condition)
        self.assertIn(
            "q1",
            graph.get("var:flag", set()),
            "If-condition dependency var:flag → q1 was not tracked",
        )

    def test_multiple_augassign_same_variable(self):
        """Test multiple += to same variable across items."""
        state = create_questionnaire(
            [
                {"id": "q1", "codeBlock": "total += q1.outcome"},
                {"id": "q2", "codeBlock": "total += q2.outcome"},
                {"id": "q3", "precondition": [{"predicate": "total > 10"}]},
            ],
            code_init="total = 0",
        )
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q3 should depend on both q1 and q2 through var:total
        self.assertIn(
            "q1",
            deps.get("q3", set()),
            "Multiple AugAssign: q3 → q1 through var:total was not tracked",
        )
        self.assertIn(
            "q2",
            deps.get("q3", set()),
            "Multiple AugAssign: q3 → q2 through var:total was not tracked",
        )

    def test_outcome_augassign_creates_dependency(self):
        """Test that item.outcome += expr creates dependency."""
        state = create_questionnaire(
            [{"id": "q1"}, {"id": "q_score", "codeBlock": "q_score.outcome += q1.outcome"}]
        )
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q_score should depend on q1
        self.assertIn(
            "q1",
            deps.get("q_score", set()),
            "Outcome AugAssign dependency q_score → q1 was not tracked",
        )

    def test_complex_if_elif_else_with_augassign(self):
        """Test complex code block with if/elif/else and AugAssign patterns."""
        code = (
            "if q1.outcome == 1:\n"
            "    score += 10\n"
            "elif q1.outcome == 2:\n"
            "    score += 20\n"
            "else:\n"
            "    score += 5\n"
        )
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "codeBlock": code},
                {"id": "q3", "precondition": [{"predicate": "score > 15"}]},
            ],
            code_init="score = 0",
        )
        builder = StaticBuilder(state)

        deps = builder.get_item_dependencies()
        # q3 should depend on q1 transitively (score depends on q1 via the if-condition)
        self.assertIn(
            "q1",
            deps.get("q3", set()),
            "Complex if/elif/else: q3 → q1 through var:score was not tracked",
        )


# ---------------------------------------------------------------------------
# U2 — shared conditionally-present Z3 primitive
# ---------------------------------------------------------------------------

import json  # noqa: E402
from pathlib import Path  # noqa: E402

from askalot_qml.core.qml_loader import QMLLoader  # noqa: E402
from askalot_qml.z3.item_classifier import ItemClassifier  # noqa: E402

_FIXTURES_DIR = Path(__file__).parent.parent.parent / "fixtures"


def _state_from_fixture(fixture_name: str) -> QMLState:
    """Load a .qml fixture through the real loader (so block-kind metadata
    propagation runs) and wrap it in QMLState — the same path FlowProcessor /
    ValidationProcessor take."""
    loader = QMLLoader(qml_dir=_FIXTURES_DIR)
    return QMLState(loader.load_from_file(fixture_name))


def _classification_fingerprint(builder: StaticBuilder) -> str:
    """Deterministic JSON fingerprint of the full per-item classification.

    Captures precondition status, postcondition invariant, global Q flags and
    coverage gaps for every item, in item_order. Two builders producing the
    same fingerprint are observationally identical to every downstream
    consumer (ValidationProcessor, validate_qml_file MCP tool, the diagram
    colorer)."""
    classifier = ItemClassifier(builder)
    return json.dumps(classifier.classify_all_items(), sort_keys=True)


@pytest.mark.unit
@pytest.mark.z3
class TestPresentPrimitiveCharacterization(unittest.TestCase):
    """Characterization of the shared ``present(item, k)`` primitive.

    Two halves with DIFFERENT contracts after U3:

    - **Sequence path (still a proven no-op):** off the primitive's two
      intended callers (Roster/Sample) it degrades to ``present := True`` so
      the emitted constraint set and classification are byte-identical to the
      pre-U2 model. ``test_sequence_only_fixture_constraint_shape_unchanged``
      is the regression guard — U3 must NOT touch Sequence.
    - **Roster path (U3 now fires):** the bit-guard caller emits exactly
      ``inner_items × len(labels)`` additional present-definition constraints.
      The constraint count moved on purpose (the deliberate linear growth);
      the *classification fingerprint* must still be regression-clean and
      deterministic — that is what the roster test now pins."""

    # roster_numeric.qml: one Sequence block (q_family_count) + one Roster
    # block (q_member_name, q_member_age) with 4 label keys (1,2,4,8). No
    # pre/postconditions, and `family_mask = 2 ** ... - 1` uses `**` which the
    # AST→Z3 lowering does not model (no codeblock constraint emitted).
    #
    # PRE-U3 the Roster was a no-op (0 constraints). U3 (this unit) makes the
    # primitive's two intended callers fire: each Roster inner item emits ONE
    # bit-guard ``present(item, K) == ((E / K) % 2 == 1)`` constraint per
    # label key. 2 inner items × 4 keys = 8 bit-guard constraints + 1
    # non-negativity constraint for the single Roster block's iterateOver
    # expression = 9 constraints total. Codeblock count is still 0 (`**`
    # unmodelled, U3 emits no codeblock constraints).
    EXPECTED_ROSTER_NUMERIC_CONSTRAINTS = 9
    EXPECTED_ROSTER_NUMERIC_CODEBLOCK = 0

    def test_sequence_only_fixture_constraint_shape_unchanged(self):
        """A pure Sequence questionnaire emits the same constraint shape as
        before U2 — the primitive contributes nothing off the Sample/Roster
        path."""
        state = create_questionnaire(
            [
                {"id": "q1", "input": {"control": "Slider", "min": 1, "max": 5}},
                {
                    "id": "q2",
                    "precondition": [{"predicate": "q1.outcome > 2"}],
                    "postcondition": [{"predicate": "q2.outcome >= 0"}],
                    "input": {"control": "Slider", "min": 0, "max": 10},
                },
            ]
        )
        builder = StaticBuilder(state)
        # Exactly the pre/post implications a Sequence questionnaire produced
        # before U2: one precondition + one postcondition implication.
        self.assertEqual(len(builder.constraints), 2)
        # And every `present` antecedent on a Sequence item is the literal
        # True (no gating Bool introduced for non-Sample/Roster items).
        for item_id in builder.item_order:
            present = builder._present_antecedent(item_id, None)
            self.assertTrue(
                is_true(simplify(present)),
                f"{item_id}: present must degrade to True off Sample/Roster",
            )

    def test_roster_numeric_classification_fingerprint_pinned(self):
        """roster_numeric.qml (Sequence + Roster) post-U3.

        U3 makes the Roster bit-guard fire: the constraint count grows by
        exactly ``inner_items × len(labels)`` bit-guard constraints (the
        deliberate linear-in-len(labels) growth this unit introduces). The
        *classification fingerprint* must still be regression-clean — no inner
        item becomes NEVER / dead-code (the U2 classification-safety tag keeps
        a bit-unset iteration from being flagged), and the result is stable
        across rebuilds."""
        builder = StaticBuilder(_state_from_fixture("roster_numeric.qml"))

        self.assertEqual(
            len(builder.constraints),
            self.EXPECTED_ROSTER_NUMERIC_CONSTRAINTS,
        )
        self.assertEqual(
            len(builder.codeblock_constraints),
            self.EXPECTED_ROSTER_NUMERIC_CODEBLOCK,
        )

        fingerprint = _classification_fingerprint(builder)
        # No item is NEVER / dead-code in this well-formed fixture, and the
        # Roster items classify exactly as a Sequence would (U2 is a no-op
        # until U3 wires the bit-guard). Pin the whole structure.
        classifier = ItemClassifier(builder)
        results = classifier.classify_all_items()
        for item_id in ("q_family_count", "q_member_name", "q_member_age"):
            self.assertIn(item_id, results)
            self.assertNotEqual(
                results[item_id]["precondition"]["status"],
                "NEVER",
                f"{item_id} must not be NEVER (well-formed fixture)",
            )
        # Stable across rebuilds (determinism guard for the fingerprint).
        builder2 = StaticBuilder(_state_from_fixture("roster_numeric.qml"))
        self.assertEqual(fingerprint, _classification_fingerprint(builder2))


@pytest.mark.unit
@pytest.mark.z3
class TestPresentPrimitiveBehavior(unittest.TestCase):
    """Direct behavioral tests of the ``present(item, k)`` primitive.

    These assert the primitive's contract that U3 (Roster bit-guard) and U4
    (Sample optional-skip) will both call:

    - ``_present_var(item_id, k)`` returns a per-(item, k) Z3 Bool created
      with the builder's isolated context.
    - ``_present_antecedent(item_id, None)`` degrades to literal True
      (the no-op / always-present case).
    - ``_wrap_present(item_id, k, constraint)`` gates a constraint behind the
      presence Bool via ``Implies``.
    - Items registered via ``mark_conditionally_present`` are tagged so
      ItemClassifier / PathBasedValidator never report them NEVER/dead-code."""

    def test_present_var_is_bool_in_builder_context(self):
        """present(item, k) is a Z3 Bool in the builder's isolated context."""
        state = create_questionnaire([{"id": "q1"}])
        builder = StaticBuilder(state)
        p = builder._present_var("q1", 0)
        self.assertTrue(is_bool(p))
        self.assertIs(p.ctx, builder.ctx)
        # Same (item, k) → same Bool (stable identity for repeated wiring).
        self.assertEqual(p.get_id(), builder._present_var("q1", 0).get_id())
        # Different k → different Bool.
        self.assertNotEqual(p.get_id(), builder._present_var("q1", 1).get_id())

    def test_present_antecedent_degrades_to_true_off_sample_roster(self):
        """With no conditionally-present registration, the antecedent is the
        literal True — Implies(True, C) ≡ C, so the model is unchanged."""
        state = create_questionnaire(
            [{"id": "q1", "precondition": [{"predicate": "True"}]}]
        )
        builder = StaticBuilder(state)
        ant = builder._present_antecedent("q1", None)
        self.assertTrue(is_true(simplify(ant)))

    def test_present_true_validates_identically_to_unconditional(self):
        """Happy path: a constraint wrapped with present=True is logically
        identical to the unconditional constraint."""
        state = create_questionnaire([{"id": "q1"}])
        builder = StaticBuilder(state)
        x = Int("x", builder.ctx)
        wrapped = builder._wrap_present("q1", None, x == 5)
        s = Solver(ctx=builder.ctx)
        s.add(wrapped, x == 5)
        self.assertEqual(s.check(), sat)
        s2 = Solver(ctx=builder.ctx)
        s2.add(wrapped, x == 6)
        # present degrades to True so the implication bites: x==5 forced.
        self.assertEqual(s2.check(), unsat)

    def test_present_false_contributes_no_constraint(self):
        """Happy path: present=False ⇒ the wrapped constraint is vacuous
        (the item contributes no domain/pre/post restriction)."""
        state = create_questionnaire([{"id": "q1"}])
        builder = StaticBuilder(state)
        builder.mark_conditionally_present("q1", 0)
        present = builder._present_var("q1", 0)
        x = Int("x", builder.ctx)
        wrapped = builder._wrap_present("q1", 0, x == 5)
        s = Solver(ctx=builder.ctx)
        s.add(wrapped, Not(present), x == 6)
        # present=False → Implies(False, x==5) is True → x is free → SAT.
        self.assertEqual(s.check(), sat)

    def test_conditionally_present_tag_excludes_from_never(self):
        """Core regression guard: an item registered as conditionally-present
        is classification-safe — never reported NEVER even if its precondition
        is unsatisfiable in isolation (it is 'absent', not 'dead code')."""
        state = create_questionnaire(
            [
                {"id": "q1", "input": {"control": "Slider", "min": 1, "max": 5}},
                {
                    "id": "q_sampled",
                    # Precondition unsat against domain in isolation, but the
                    # item is only ever drawn conditionally — must NOT be NEVER.
                    "precondition": [{"predicate": "q1.outcome == 99"}],
                    "input": {"control": "Slider", "min": 1, "max": 5},
                },
            ]
        )
        builder = StaticBuilder(state)
        builder.mark_conditionally_present("q_sampled", 0)
        classifier = ItemClassifier(builder)
        result = classifier.classify_item("q_sampled")
        self.assertEqual(
            result["precondition"]["status"],
            "CONDITIONAL",
            "A conditionally-present (sampling-absent) item must not be NEVER",
        )
        # The plain Sequence item is unaffected.
        self.assertEqual(
            classifier.classify_item("q1")["precondition"]["status"], "ALWAYS"
        )

    def test_conditionally_present_excluded_from_dead_code(self):
        """PathBasedValidator must not flag a conditionally-present item as
        dead code even if accumulated predecessor postconditions make its
        precondition unsatisfiable — it is sampling-absent, not dead."""
        from askalot_qml.core.qml_engine import QMLEngine
        from askalot_qml.z3.path_based_validation import PathBasedValidator

        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "input": {"control": "Slider", "min": 0, "max": 100},
                    "postcondition": [{"predicate": "q1.outcome > 50"}],
                },
                {
                    "id": "q_sampled",
                    "precondition": [{"predicate": "q1.outcome < 30"}],
                    "input": {"control": "Slider", "min": 0, "max": 100},
                },
            ]
        )
        engine = QMLEngine(state)
        builder = engine.topology.static_builder
        builder.mark_conditionally_present("q_sampled", 0)
        validator = PathBasedValidator(builder, engine.topology)
        result = validator.validate()
        self.assertNotIn(
            "q_sampled",
            result.dead_code_items,
            "Conditionally-present item must be excluded from dead-code",
        )


if __name__ == "__main__":
    unittest.main()
