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

### Unlowerable operands are not dropped (#1164)
- An ``and`` / ``or`` with an unlowerable operand (a ``str()`` call) lowers to
  ``None`` as a whole, never to its remaining operand, and records an
  ``unsupported_nodes`` coverage gap
- An item gated on such an ``or`` is not classified NEVER
- A ``not`` over it and an ``in [...]`` with an unlowerable member lower to
  ``None`` too; a fully lowerable ``and`` / ``or`` still lowers
- A condition left out of P or Q never yields ALWAYS, TAUTOLOGICAL or
  globally-true (the formula is wider than the real one)
- An inexact P is never ASSUMED as ``P ⇒ Q`` (no false ``global_unsat`` or
  ``accumulated_dead_code``), and an inexact owner gate reports no
  ``none_unsafe_reference``

### Bound-restating postcondition lint
- A Slider postcondition restating its own min/max is flagged; a Range one is
  not, since a Range answer is a pair (#1474)

### A Range answer is a pair in the model (#1474)
- A Range Question holds ``item_{id}@lo`` / ``item_{id}@hi`` bound by
  ``min <= lo <= hi <= max``, and no scalar variable
- ``q.outcome.low`` / ``q.outcome.high`` are proven (#1755): ``high >= 5`` on a 0–4 scale
  and ``low > high`` are NEVER, ``low <= 2`` is CONDITIONAL (AE3); a span wider
  than the scale is an INFEASIBLE postcondition
- A bare Range ``q.outcome``, an out-of-pair index and a positional Range
  QuestionGroup read are coverage gaps naming the Range item, and the issue
  says why; the global witness lists both ends
- Range Question / Group preconditions and codeBlocks stay in the model; a
  capped-Group Range item binds its own ``item_q@group0@lo`` / ``@hi`` pair
- A Range end symbol (``item_q@lo``) never aliases an item named ``q_lo``
- A codeBlock pair literal ``q.outcome = [a, b]`` binds both ends (a later
  ``low != a`` postcondition is INFEASIBLE); any other Range codeBlock write is
  a coverage gap naming the Range item

### None guards lower (#1250, D70)
- ``X.outcome is (not) None`` and ``== / != None`` lower exactly to a fresh
  ``answered`` Bool per predicate, so the guard ``none_unsafe_reference``
  recommends leaves the gate verified; a guarded postcondition that can fail
  is CONSTRAINING
- An answer implies nothing about the item's gate, an item code sets stays
  modelled, an item's own pre/postcondition do not contradict, and a code
  write between two conditions is no global conflict
- A gate reading the item's value, or a variable, where it may be unanswered
  is not lowered; reordering clears the ``Is`` gap; a None test on a
  variable is neither lowered nor warned
- Gates with no None test classify unchanged; a None test on free text is no
  ``textarea_in_predicate`` read, and does not lower beside a read of the text; ``uninitialized_read`` treats a None-tested
  ``if`` as always assigning and does not judge a reader gate that did not lower

### A skipped item reads None (#1769)
- ``!= c`` / ``not in [...]`` / ``not`` on an item gated out are reachable
  through its ``None``, so a gate no answer satisfies is CONDITIONAL, not
  NEVER; the same gate on an always-asked item stays NEVER
- A gated item may be skipped even where its gate's reads say it is asked
  (a read left empty skips it), and a gated-out item may still hold an
  answer, so neither that gate nor an any-of over its labels is ALWAYS
- A skipped item inside a literal list, ``bool()`` or ``any([...])`` reads
  as ``None``; an item a codeBlock writes (any store target) is skipped per
  predicate; a global witness shows a skipped item as None; a gate that
  raises on a skip skips its item too; a postcondition a skip satisfies
  is not INFEASIBLE
- #1775: a read that raises on a skipped item's ``None`` fails a precondition
  and waives a postcondition, exact wherever it sits (#1779), so
  an ordering gate on a skippable item is not ALWAYS, a contradiction stays
  NEVER and an impossible check is not INFEASIBLE
- #1779: each node lowers two-sided (holds, raises), combined as Python
  short-circuits: a raise under ``not`` or in an earlier ``or`` operand fails
  a gate, a postcondition raise is exact, a raise after a settling operand or
  an unknown one is never fatal, a raise the model cannot place is unknown (not
  False) after an unknown operand, and a chain raises only on the clause it reaches
- #1776: a codeBlock reads a skipped item's ``None`` too: a ``!=`` test on
  it can set the variable a later check needs, and a read that raises stops
  the block, so that variable and every later one keep their old values
- #1847: a ``None`` copied into a variable or passed through a ternary is
  still ``None`` when compared, so it never forces an equality
- An annotation (``x: <expr> = v``) is never evaluated, so its read raises nothing
- #1867: a skippable read that is itself a ternary branch passes its ``None``
  on untouched, so the condition is refused (a gap naming the item), never
  proven NEVER; arithmetic inside the branch raises first and stays wide

### codeBlock control flow (#1843)
- An assignment holds only on its ``if`` / ``elif`` / ``else`` path, the taken
  branch wins, statements run in source order, ``if False:`` is dead, a loop
  widens what it assigns, and an outcome write holds only on its branch

### Code state follows the navigation order (#1989)
- A variable a later-in-file item writes, which the walk asks first, is read at
  the version the walk gives it, straight-line and in a branch (CONSTRAINING,
  not INFEASIBLE); the rebuild reproduces its own order and the blocks are
  lowered in it (t before q); a questionnaire
  already in walk order and one with a cycle keep the file-order build

### A gated writer's codeBlock may not run (#1994)
- A check holding when the gated writer was skipped is not refused, a skipped
  writer keeps the value it found, an ungated writer always runs, a gated
  outcome write may not happen, and a capped-Group or Roster member's write
  (drawn or not, once per iteration) is left free

### ``x & K`` lowers (#2037)
- A mask test on a declared Checkbox bit is exact and CONDITIONAL, an
  undeclared bit is NEVER, multi-bit and left-literal masks lower, the terms
  agree with Python's ``&`` on negative values, ``x &= K`` lowers too, and
  ``&`` of two variables or by a negative literal stays unlowered

### A Textarea's codeBlock is lowered (#2003)
- A check on what it sets is not refused, the reader depends on it, a gated
  one may not run its codeBlock, its own text is opaque in it, a blank one may
  stop its codeBlock at a raise, and another Textarea's text is opaque in any
  codeBlock (never a stand-in constant)

### QuestionGroup answers (#184)
- A group holds one variable per answer (``item_qg@{i}``, a ``@lo`` / ``@hi``
  pair for Range) and no scalar; a cell never aliases an item named after it;
  the witness shows the list
- ``qg.outcome[i]`` and a fold over the answers are proven; a group that is
  None raises on an answer read where it may be skipped (gated, or its own
  postcondition), an unanswered slot reads None the #1769 way (a Range end
  raises), and a None guard on a group keeps the gate exact
- #1784 (KTD5): an ungated group left blank makes its leaf unknown (the
  ``blank`` choice, no skip choice), so a read under an earlier ``or``
  operand is exact; a gated group still raises on skip; a None guard carries
  the blank; one that refuses
  ``None`` keeps the group from being blank
- A whole-list read, a set of answers, a scoped group and any codeBlock write
  are gaps naming the group; a codeBlock read binds nothing

### A matrix reads None too (#1780, KTD5)
- A gate on a gated matrix's cell is CONDITIONAL with a skip witness (AE8);
  an ungated matrix is ``None`` only when blank; a None guard carries both
- An answered matrix's empty cell (``unanswered@m@r@c``) passes ``!= 9`` and
  fails ``> 2``; a Range cell's ``.low`` raises on it; comprehension indices
  pick their own cell
- A code-written or scoped matrix gets no new choice and keeps its verdict
- The witness shows an empty cell, and a matrix read as ``None``, as ``None``

### An own postcondition is judged on answers (#1839)
- One no real answer satisfies is INFEASIBLE for a Question, a QuestionGroup
  and a MatrixQuestion alike, gated or not, though a blank stays admissible;
  a satisfiable one, or one a None test opens to a blank, stays CONSTRAINING

### Named Range ends (#1755, D89)
- ``q.outcome.low`` / ``.high`` and ``m.outcome[j][k].low`` / ``.high`` are
  proven; a positional end read is a coverage gap whose suggestion names the
  ends; another attribute of a Range is no end

### The one lowering covers every construct (#1660)
- ``/``, and ``//`` / ``%`` with anything but a positive literal divisor, do
  not lower (Z3 and Python disagree, #1767) and are reported as gaps; the
  augmented forms follow the same rule (a fraction never reaches the model:
  the loader refuses it, #1813)
- Each operator, comparison, boolean form and lowered call classifies a gate
  that no answer satisfies as NEVER with no coverage gap

### Derived Z3 names never alias an item (#1783, #1798)
- A matrix cell is ``item_m@0@0`` and a capped-Group outcome
  ``item_q@group0``, so a Question ``m_0_0`` or ``q_group0`` keeps its own
  variable (a ``!=`` between them is not INFEASIBLE; the member can be drawn);
  an SSA variable is ``var@{name}@{n}``, so a variable ``item_q`` and a
  Question ``q_0`` stay apart

### A blank answer is unknown (#1784)
- A gate on an ungated Question is CONDITIONAL, with a blank witness; one
  answered part still settles an ``or`` exactly; ``not`` over a blank leaf
  still fails; ``any([...])`` is one leaf
- A postcondition true only because a blank waives it is accepted but not
  TAUTOLOGICAL; a None guard carries the blank (ALWAYS stays, AE6)
- An item whose own postcondition refuses ``None`` is never blank, one that
  raises on it admits a blank; a gate on constants keeps its verdict
- A code-written item reads blank per predicate; a codeBlock ``if`` guard
  models no blank, so ``uninitialized_read`` does not fire on it
- A codeBlock reads a blank item as ``None`` (#1776): an ordering read of it
  raises and stops the block, and a variable computed from it is free in the
  model (the runtime marks it unknown, #1044), so a check on it is not
  INFEASIBLE; an item refusing ``None`` keeps both verdicts INFEASIBLE
- A global witness shows a blank item as ``None`` (R5)
- #1844: a variable computed from a blank answer is marked unknown as the
  runtime marks it (#1044), so a gate true for every number is CONDITIONAL;
  a blank branch test marks what the branch assigns, a None-tested read marks
  nothing, a clean reassignment that changes the value clears the mark, the
  mark travels through a variable and through a ``match`` / walrus write the
  mark walk does not follow, and a mark never makes a gate NEVER

### Distinct over skippable Questions (#1785)
- ``len(set([...])) == k`` over gated Questions is a coverage gap, not NEVER;
  over always-asked Questions it stays NEVER

### A counter gate is verified (#1891)
- The article's block counter with required answers: items 1–3 ALWAYS, 4–6
  CONDITIONAL; as written (a blank allowed) only item 1 is ALWAYS (#1844); an
  impossible gate makes every item NEVER; item-level gates likewise
- An ungated earlier writer always counts; a skippable one may not
- A Textarea writer counts like any other (#2003): its codeBlock is lowered
- A ``del`` of the counter, and a value read from another counter out of walk
  order, leave the counter open
- A counter read only after its writers (no accumulator) keeps its verdicts

### Import order
- ``askalot_qml.z3`` imports in a fresh interpreter before ``askalot_qml.core``

### U1 Undefined-Name Detection & Variable Census
- Phantom predicate identifier recorded as an undefined_name coverage gap,
  with a `q_<name>.outcome` suggestion when that item exists
- Forward codeBlock reference NOT flagged (definedness is file-scoped)
- codeInit target / item outcome / safe builtin / safe module / comprehension
  and for-loop-bound names NOT flagged
- Undefined name in a postcondition and on a codeBlock RHS flagged with the
  right condition kind
- Per-variable read/write census (assignments with context, bare-outcome RHS
  shape, read count across predicates and code) exposed for the U3 hygiene lints

### A condition is lowered once after the build (#2246)
- Each condition is lowered at most once across ``to_issues(deep=True)`` and
  the classification; findings and verdicts equal those of a builder that
  keeps nothing
- Two compiles of one key share exactly the symbols two uncached compiles
  share, and conjoined (``P ∧ ¬P'``) stay as independent as they are
- A cache hit still records the wide gap a ``record_wide`` compile asks for
"""

import ast
import subprocess
import sys
import unittest
import unittest.mock

import pytest
from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.item_classifier import ItemClassifier
from askalot_qml.z3.static_builder import StaticBuilder
from tests.helpers.block_counter import NO_YES, counter_questionnaire
from tests.helpers.flow_walker import walk_and_answer
from z3 import *
from z3.z3util import get_vars


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
        compiled = builder.compile_conditions("q2", conditions, kind="precondition")

        self.assertIsNotNone(compiled)
        # Should be a Z3 boolean expression
        self.assertTrue(is_bool(compiled) or isinstance(compiled, BoolRef))

    def test_compile_conditions_empty_returns_true(self):
        """Test compile_conditions with empty list returns True."""
        state = create_questionnaire([{"id": "q1"}])
        builder = StaticBuilder(state)

        compiled = builder.compile_conditions("q1", [], kind="precondition")

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
        # Should include SSA variable, keyed by its Z3 name (#1798)
        self.assertIn("var@x@0", all_vars)

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

    Two halves with DIFFERENT contracts:

    - **Off its callers (a proven no-op):** an uncapped Group registers
      nothing, so the antecedent degrades to the literal ``True`` and the
      emitted constraint set and classification match the unconditional model
      exactly. ``test_present_is_noop_off_roster_and_capped_group`` is the
      regression guard — the primitive must stay invisible on that path.
    - **Roster path (the bit-guard fires):** emits exactly
      ``inner_items × len(labels)`` additional present-definition constraints.
      That count grows linearly in ``len(labels)`` by design; the
      *classification fingerprint* must still be regression-clean and
      deterministic — that is what the roster test pins."""

    # roster_numeric.qml: one Group block (q_family_count) + one Roster
    # block (q_member_name, q_member_age) with 4 label keys (1,2,4,8). No
    # pre/postconditions, and `family_mask = 2 ** ... - 1` uses `**` which the
    # AST→Z3 lowering does not model (no codeblock constraint emitted).
    #
    # Each Roster inner item emits ONE bit-guard
    # ``present(item, K) == ((E / K) % 2 == 1)`` constraint per
    # label key. 2 inner items × 4 keys = 8 bit-guard constraints + 1
    # non-negativity constraint for the single Roster block's iterateOver
    # expression = 9 constraints total. Codeblock count is still 0 (`**`
    # unmodelled, U3 emits no codeblock constraints).
    EXPECTED_ROSTER_NUMERIC_CONSTRAINTS = 9
    EXPECTED_ROSTER_NUMERIC_CODEBLOCK = 0

    def test_present_is_noop_off_roster_and_capped_group(self):
        """A plain uncapped-Group questionnaire emits the unconditional
        constraint shape — the primitive contributes nothing off the Roster /
        capped-Group paths."""
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
        # Exactly the pre/post implications an unconditional questionnaire
        # produces: one precondition + one postcondition implication.
        self.assertEqual(len(builder.constraints), 2)
        # And every `present` antecedent is the literal True (no gating Bool
        # introduced for items outside a Roster or capped Group).
        for item_id in builder.item_order:
            present = builder._present_antecedent(item_id, None)
            self.assertTrue(
                is_true(simplify(present)),
                f"{item_id}: present must degrade to True off Roster/capped Group",
            )

    def test_roster_numeric_classification_fingerprint_pinned(self):
        """roster_numeric.qml — one Group block plus one Roster block.

        The Roster bit-guard contributes exactly
        ``inner_items × len(labels)`` constraints (linear in ``len(labels)``
        by design). The *classification fingerprint* must be regression-clean
        — no inner item becomes NEVER / dead-code, because the
        classification-safety tag keeps a bit-unset iteration from being
        flagged — and stable across rebuilds."""
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
        # Roster items classify exactly as unconditional items would. Pin the
        # whole structure.
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
        # The plain unconditional item is unaffected.
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


# ---------------------------------------------------------------------------
# U1 — undefined-name detection + variable read/write census
# ---------------------------------------------------------------------------


def _undefined_gaps(builder: StaticBuilder) -> list[dict]:
    """Flatten every ``undefined_name`` coverage gap the builder recorded.

    Each returned dict carries ``owner`` (the item_id / block_id the gap is
    keyed under) plus the gap's own fields (identifier, condition_kind,
    suggested_outcome)."""
    out = []
    for owner_id, gaps in builder.coverage_gaps.items():
        for gap in gaps:
            if gap.get("kind") == "undefined_name":
                out.append({"owner": owner_id, **gap})
    return out


@pytest.mark.unit
@pytest.mark.z3
class TestUndefinedNameDetection(unittest.TestCase):
    """U1: identifiers in predicates / codeBlocks that resolve to no item id,
    codeInit/codeBlock assignment target, or safe builtin/module are recorded as
    ``undefined_name`` coverage gaps.

    The known-variable oracle is ``version_history`` (real assignments), NOT
    ``version_map`` — the latter is polluted with a version-0 entry for every
    phantom name by ``_get_current_z3_var`` during constraint lowering, so using
    it would mask exactly the defect this lint targets.
    """

    def test_phantom_precondition_name_flagged_with_suggestion(self):
        """Bare `smoking_status` where item `q_smoking_status` exists → one
        undefined_name gap on the gated item, suggesting the item outcome."""
        state = create_questionnaire(
            [
                {
                    "id": "q_smoking_status",
                    "input": {"control": "Radio", "labels": {1: "Yes", 2: "No"}},
                },
                {
                    "id": "q_cigs",
                    "precondition": [{"predicate": "smoking_status == 1"}],
                    "input": {"control": "Editbox", "min": 0, "max": 100},
                },
            ]
        )
        builder = StaticBuilder(state)
        gaps = _undefined_gaps(builder)
        self.assertEqual(len(gaps), 1, f"expected one undefined_name gap, got {gaps}")
        gap = gaps[0]
        self.assertEqual(gap["owner"], "q_cigs")
        self.assertEqual(gap["identifier"], "smoking_status")
        self.assertEqual(gap["condition_kind"], "precondition")
        self.assertEqual(gap["suggested_outcome"], "q_smoking_status.outcome")

    def test_forward_codeblock_reference_not_flagged(self):
        """A name assigned only by a LATER item's codeBlock, referenced earlier,
        is not undefined — definedness is file-scoped, ordering is the topology
        pass's concern."""
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "flag == 1"}]},
                {"id": "q2", "codeBlock": "flag = 1"},
            ]
        )
        builder = StaticBuilder(state)
        self.assertEqual(_undefined_gaps(builder), [])

    def test_codeinit_variable_reference_not_flagged(self):
        """A codeInit-defined variable referenced in a predicate is defined."""
        state = create_questionnaire(
            [{"id": "q1", "precondition": [{"predicate": "has_partner == 1"}]}],
            code_init="has_partner = 0",
        )
        builder = StaticBuilder(state)
        self.assertEqual(_undefined_gaps(builder), [])

    def test_item_outcome_reference_not_flagged(self):
        """`q_item.outcome` resolves to an item id — not undefined."""
        state = create_questionnaire(
            [{"id": "q1"}, {"id": "q2", "precondition": [{"predicate": "q1.outcome == 1"}]}]
        )
        builder = StaticBuilder(state)
        self.assertEqual(_undefined_gaps(builder), [])

    def test_safe_builtins_in_codeblock_not_flagged(self):
        """`range` / `int` / `bool` in a codeBlock are safe builtins."""
        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "codeBlock": "n = int(q1.outcome)\nr = range(n)\nb = bool(n)",
                }
            ]
        )
        builder = StaticBuilder(state)
        self.assertEqual(_undefined_gaps(builder), [])

    def test_undefined_name_in_postcondition_flagged(self):
        """An undefined name in a postcondition is flagged with the postcondition
        condition kind."""
        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "postcondition": [{"predicate": "phantom_limit >= q1.outcome"}],
                }
            ]
        )
        builder = StaticBuilder(state)
        gaps = _undefined_gaps(builder)
        self.assertEqual(len(gaps), 1, f"expected one gap, got {gaps}")
        self.assertEqual(gaps[0]["identifier"], "phantom_limit")
        self.assertEqual(gaps[0]["condition_kind"], "postcondition")
        # No `q_phantom_limit` item exists → no suggestion.
        self.assertIsNone(gaps[0]["suggested_outcome"])

    def test_undefined_name_on_codeblock_rhs_flagged(self):
        """An undefined name read only on a codeBlock RHS (never in a predicate)
        is flagged with the codeBlock condition kind. The assigned target is
        itself defined and never flagged."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "codeBlock": "derived = phantom_input + 1"},
            ]
        )
        builder = StaticBuilder(state)
        gaps = _undefined_gaps(builder)
        self.assertEqual(len(gaps), 1, f"expected one gap, got {gaps}")
        self.assertEqual(gaps[0]["owner"], "q2")
        self.assertEqual(gaps[0]["identifier"], "phantom_input")
        self.assertEqual(gaps[0]["condition_kind"], "codeBlock")

    def test_comprehension_bound_variable_not_flagged(self):
        """Comprehension loop variables are locally bound — flagging them would
        make valid matrix-style predicates unsaveable."""
        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "postcondition": [{"predicate": "all([q1.outcome > k for k in range(3)])"}],
                }
            ]
        )
        builder = StaticBuilder(state)
        self.assertEqual(_undefined_gaps(builder), [])

    def test_for_loop_target_in_codeblock_not_flagged(self):
        """A for-loop target inside a codeBlock is locally bound, not undefined."""
        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "codeBlock": "acc = 0\nfor i in range(3):\n    acc = acc + i",
                }
            ]
        )
        builder = StaticBuilder(state)
        self.assertEqual(_undefined_gaps(builder), [])

    def test_tuple_unpacked_codeinit_name_not_flagged(self):
        """A codeInit tuple-unpacking target binds at runtime even though SSA does
        not model it — a predicate reading it must NOT be flagged undefined."""
        state = create_questionnaire(
            [{"id": "q1", "precondition": [{"predicate": "lo <= 1"}]}],
            code_init="lo, hi = 0, 10",
        )
        builder = StaticBuilder(state)
        self.assertEqual(_undefined_gaps(builder), [])

    def test_safe_module_usage_in_codeblock_not_flagged(self):
        """`math.floor(...)` — `math` is a safe module name; `floor` is an
        attribute, not a bare name."""
        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 0, "max": 120},
                    "codeBlock": "years = math.floor(q1.outcome / 12)",
                }
            ]
        )
        builder = StaticBuilder(state)
        self.assertEqual(_undefined_gaps(builder), [])

    def test_repeated_phantom_reference_deduplicated(self):
        """The same identifier referenced twice in one condition kind yields a
        single gap (dedup by identifier + condition kind)."""
        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                    "precondition": [{"predicate": "ghost > 0 and ghost < 5"}],
                }
            ]
        )
        builder = StaticBuilder(state)
        gaps = _undefined_gaps(builder)
        self.assertEqual(len(gaps), 1, f"expected dedup to one gap, got {gaps}")
        self.assertEqual(gaps[0]["identifier"], "ghost")


@pytest.mark.unit
@pytest.mark.z3
class TestVariableCensus(unittest.TestCase):
    """U1 deliverable for U3: the per-variable read/write census.

    ``get_variable_census()`` returns ``{var: {"assignments": [...], "reads": int}}``
    where each assignment carries its ``context`` (``"codeInit"`` or the item id)
    and ``bare_outcome_item`` (the item id X when the assignment is exactly
    ``var = X.outcome``, else None). Reads count Load references across
    predicates and code (codeInit + codeBlocks). U3 consumes it for the
    write-only and pass-through-alias hygiene lints.
    """

    def test_write_only_variable_has_no_reads(self):
        """A variable assigned repeatedly but never read → reads == 0."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "codeBlock": "path = 1"},
                {"id": "q3", "codeBlock": "path = 2"},
            ],
            code_init="path = 0",
        )
        census = StaticBuilder(state).get_variable_census()
        self.assertIn("path", census)
        self.assertEqual(census["path"]["reads"], 0)
        self.assertEqual(len(census["path"]["assignments"]), 3)
        contexts = [a["context"] for a in census["path"]["assignments"]]
        self.assertIn("codeInit", contexts)
        self.assertIn("q2", contexts)
        self.assertIn("q3", contexts)

    def test_pass_through_alias_records_bare_outcome_item(self):
        """A single `var = X.outcome` assignment records X as the bare-outcome
        item and is read at least once."""
        state = create_questionnaire(
            [
                {"id": "q_a1_num_children", "input": {"control": "Editbox", "min": 0, "max": 10}},
                {"id": "q_x", "codeBlock": "num_children = q_a1_num_children.outcome"},
                {"id": "q_y", "precondition": [{"predicate": "num_children >= 1"}]},
            ]
        )
        census = StaticBuilder(state).get_variable_census()
        self.assertIn("num_children", census)
        assignments = census["num_children"]["assignments"]
        self.assertEqual(len(assignments), 1)
        self.assertEqual(assignments[0]["bare_outcome_item"], "q_a1_num_children")
        self.assertGreaterEqual(census["num_children"]["reads"], 1)

    def test_transformed_assignment_is_not_bare_outcome(self):
        """`months = q_age.outcome * 12` transforms the outcome → not a bare
        alias (bare_outcome_item is None)."""
        state = create_questionnaire(
            [
                {"id": "q_age", "input": {"control": "Editbox", "min": 0, "max": 120}},
                {"id": "q_x", "codeBlock": "months = q_age.outcome * 12"},
            ]
        )
        census = StaticBuilder(state).get_variable_census()
        self.assertIsNone(census["months"]["assignments"][0]["bare_outcome_item"])

    def test_two_producers_are_not_single_assignment(self):
        """Two mutually exclusive producers into one variable → two assignments
        (consolidation is legal; U3 exempts it from the alias lint)."""
        state = create_questionnaire(
            [
                {"id": "q_p", "codeBlock": "status = 1"},
                {"id": "q_q", "codeBlock": "status = 2"},
            ]
        )
        census = StaticBuilder(state).get_variable_census()
        self.assertEqual(len(census["status"]["assignments"]), 2)

    def test_reads_counted_across_predicate_and_codeblock(self):
        """Reads sum across a codeBlock RHS reference and a predicate reference."""
        state = create_questionnaire(
            [
                {"id": "q1"},
                {"id": "q2", "codeBlock": "total = total + q1.outcome"},
                {"id": "q3", "precondition": [{"predicate": "total > 5"}]},
            ],
            code_init="total = 0",
        )
        census = StaticBuilder(state).get_variable_census()
        # q2 RHS `total` + q3 precondition `total` = 2 reads.
        self.assertEqual(census["total"]["reads"], 2)

    def test_census_keys_are_exactly_the_assigned_variables(self):
        """The census covers every assigned variable and nothing else (no item
        ids, no phantom names)."""
        state = create_questionnaire(
            [
                {"id": "q1", "precondition": [{"predicate": "phantom > 0"}]},
                {"id": "q2", "codeBlock": "real = q1.outcome"},
            ],
            code_init="init_var = 0",
        )
        census = StaticBuilder(state).get_variable_census()
        self.assertEqual(set(census.keys()), {"real", "init_var"})

    def test_augmented_assignment_counts_as_a_read(self):
        """``x += 20`` reads ``x`` even though the target carries a Store ctx.
        The census must count that read so a self-only accumulator is exempt from
        the write-only lint — matching the semantically identical ``x = x + 1``,
        which already records a read."""
        state = create_questionnaire(
            [{"id": "q1", "codeBlock": "risk_score += 20"}],
            code_init="risk_score = 0",
        )
        census = StaticBuilder(state).get_variable_census()
        self.assertGreaterEqual(census["risk_score"]["reads"], 1)

        # A self-only accumulator is not write-only: no hygiene warning fires.
        issues = ValidationProcessor(state).to_issues()
        write_only = [
            i
            for i in issues
            if i["type"] == "write_only_variable" and "risk_score" in i["message"]
        ]
        self.assertEqual(write_only, [], f"risk_score must not be flagged write-only, got {issues}")


@pytest.mark.unit
@pytest.mark.z3
class TestFrozenReachabilityBase(unittest.TestCase):
    """U2: constant propagation of frozen codeInit variables into the
    precondition-reachability base.

    A frozen variable is one whose entire ``version_history`` is ``__init__``
    contexts (initialized in codeInit, never reassigned by any codeBlock). Its
    SSA constant constraint — already in ``codeblock_constraints`` (hence the
    full base) — is additionally conjoined into ``get_reachability_base()`` so a
    gate on it is statically decidable. A produced variable (any codeBlock
    assignment) is NOT frozen and its initializer is not propagated.
    """

    def test_frozen_variable_detected(self):
        """A codeInit-only variable is frozen; a reassigned one is not."""
        state = create_questionnaire(
            [{"id": "q1", "codeBlock": "produced = produced + 1"}],
            code_init="frozen_v = 3\nproduced = 0",
        )
        builder = StaticBuilder(state)
        self.assertEqual(builder._frozen_variable_names(), {"frozen_v"})

    def test_frozen_constant_in_reachability_base_not_domain_base(self):
        """The frozen constant pins its Z3 var in the reachability base but the
        domain base leaves it free."""
        state = create_questionnaire(
            [
                {
                    "id": "q1",
                    "precondition": [{"predicate": "has_partner == 1"}],
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                }
            ],
            code_init="has_partner = 0",
        )
        builder = StaticBuilder(state)
        hp = builder.z3_vars["has_partner_0"]

        reach = Solver(ctx=builder.ctx)
        reach.add(builder.get_reachability_base())
        reach.add(hp != 0)
        self.assertEqual(
            reach.check(), unsat, "frozen constant must be enforced in the reachability base"
        )

        domain = Solver(ctx=builder.ctx)
        domain.add(builder.get_domain_base())
        domain.add(hp != 0)
        self.assertEqual(
            domain.check(), sat, "the domain base must leave the frozen variable free"
        )

    def test_produced_variable_not_propagated(self):
        """A variable reassigned by a codeBlock is not frozen — its initializer
        is absent from the reachability base, so a gate on it stays decidable
        only by the (free) variable, i.e. CONDITIONAL at classification time."""
        state = create_questionnaire(
            [
                {"id": "q_age", "codeBlock": "band = 1", "input": {"control": "Editbox"}},
                {
                    "id": "q_dep",
                    "precondition": [{"predicate": "band == 1"}],
                    "input": {"control": "Editbox"},
                },
            ],
            code_init="band = 0",
        )
        builder = StaticBuilder(state)
        self.assertNotIn("band", builder._frozen_variable_names())

        band0 = builder.z3_vars["band_0"]
        reach = Solver(ctx=builder.ctx)
        reach.add(builder.get_reachability_base())
        reach.add(band0 != 0)
        self.assertEqual(
            reach.check(), sat, "a produced variable's initializer must NOT be propagated"
        )

    def test_reachability_base_selective_across_mixed_variables(self):
        """With a frozen and a produced variable co-existing, only the frozen
        one's constant is propagated."""
        state = create_questionnaire(
            [{"id": "q1", "codeBlock": "produced = produced + 5"}],
            code_init="frozen_v = 7\nproduced = 2",
        )
        builder = StaticBuilder(state)
        frozen0 = builder.z3_vars["frozen_v_0"]
        produced0 = builder.z3_vars["produced_0"]

        solver = Solver(ctx=builder.ctx)
        solver.add(builder.get_reachability_base())
        solver.push()
        solver.add(frozen0 != 7)
        self.assertEqual(solver.check(), unsat, "frozen constant is propagated")
        solver.pop()
        solver.add(produced0 != 2)
        self.assertEqual(solver.check(), sat, "produced initializer is not propagated")

    def test_reachability_base_equals_domain_when_no_frozen_vars(self):
        """No codeInit variable → no frozen constants → the reachability base is
        the domain base (both give identical satisfiability)."""
        state = create_questionnaire(
            [{"id": "q1", "input": {"control": "Editbox", "min": 1, "max": 5}}]
        )
        builder = StaticBuilder(state)
        self.assertEqual(builder._frozen_variable_names(), set())

        # Equisatisfiable: neither base implies anything the other does not.
        s = Solver(ctx=builder.ctx)
        s.add(builder.get_reachability_base() != builder.get_domain_base())
        self.assertEqual(s.check(), unsat, "with no frozen vars the two bases are identical")

    def test_tuple_unpack_rebinding_unfreezes(self):
        """A codeInit variable rebound ONLY via tuple-unpack in a codeBlock is
        produced, not frozen. SSA records no ``Name`` target for the unpack, so
        the ``version_history`` oracle alone would wrongly freeze it and pin its
        stale initializer into the reachability base."""
        state = create_questionnaire(
            [
                {"id": "q_a", "input": {"control": "Editbox", "min": 0, "max": 10}},
                {"id": "q_b", "input": {"control": "Editbox", "min": 0, "max": 10}},
                {"id": "q_pair", "codeBlock": "x, y = q_a.outcome, q_b.outcome"},
            ],
            code_init="x = 0\ny = 0",
        )
        builder = StaticBuilder(state)
        self.assertNotIn("x", builder._frozen_variable_names())
        self.assertNotIn("y", builder._frozen_variable_names())

        # The stale codeInit constant must NOT be pinned into the reachability base.
        x0 = builder.z3_vars["x_0"]
        reach = Solver(ctx=builder.ctx)
        reach.add(builder.get_reachability_base())
        reach.add(x0 != 0)
        self.assertEqual(
            reach.check(),
            sat,
            "a tuple-unpack-rebound variable's initializer must not be propagated",
        )

    def test_for_loop_target_rebinding_unfreezes(self):
        """A codeInit variable rebound as a for-loop target is produced, not
        frozen — SSA does not model the loop target."""
        state = create_questionnaire(
            [{"id": "q1", "codeBlock": "for x in [1, 2]:\n    pass"}],
            code_init="x = 0",
        )
        builder = StaticBuilder(state)
        self.assertNotIn("x", builder._frozen_variable_names())

    def test_walrus_rebinding_unfreezes(self):
        """A codeInit variable rebound via a walrus in a codeBlock is produced,
        not frozen — SSA does not model the walrus target."""
        state = create_questionnaire(
            [{"id": "q1", "codeBlock": "y = (x := 5) + 1"}],
            code_init="x = 0\ny = 0",
        )
        builder = StaticBuilder(state)
        self.assertNotIn("x", builder._frozen_variable_names())


def _gated_on(predicate: str) -> StaticBuilder:
    """``q_b`` (Radio 1/2/9), a codeInit variable ``risk``, and ``q_c`` gated on *predicate*."""
    return StaticBuilder(
        create_questionnaire(
            [
                {"id": "q_b", "input": {"control": "Radio", "labels": {1: "A", 2: "B", 9: "C"}}},
                {
                    "id": "q_c",
                    "precondition": [{"predicate": predicate}],
                    "input": {"control": "Editbox", "min": 0, "max": 10},
                },
            ],
            code_init="risk = 1",
        )
    )


@pytest.mark.unit
@pytest.mark.z3
class TestUnsupportedOperandIsNotDropped(unittest.TestCase):
    """#1164: a gate Z3 cannot express in full is not verified as a different one."""

    def test_and_or_with_an_unlowerable_operand_lower_to_none(self):
        for predicate in (
            "str(q_b.outcome) == '9' and risk == 1",
            "str(q_b.outcome) == '9' or q_b.outcome == 2",
            "not (str(q_b.outcome) == '9' and q_b.outcome == 2)",
            "q_b.outcome in [1, str(q_b.outcome)]",
        ):
            with self.subTest(predicate=predicate):
                builder = _gated_on(predicate)
                self.assertIsNone(builder._compile_predicate(predicate, "q_c", "precondition")[0])

    def test_the_dropped_operand_is_recorded_as_a_coverage_gap(self):
        builder = _gated_on("str(q_b.outcome) == '9' and risk == 1")

        gaps = builder.coverage_gaps.get("q_c") or []
        self.assertEqual(
            [(g["kind"], g["unsupported_nodes"]) for g in gaps], [("precondition", ["Call"])]
        )

    def test_an_or_gated_item_is_not_classified_never(self):
        """Before the fix the ``or`` lowered to ``q_b == 2`` alone; with a domain
        that makes that side impossible it classified a reachable item NEVER."""
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {"id": "q_b", "input": {"control": "Radio", "labels": {1: "A", 9: "C"}}},
                    {
                        "id": "q_c",
                        "precondition": [
                            {"predicate": "str(q_b.outcome) == '9' or q_b.outcome == 2"}
                        ],
                        "input": {"control": "Editbox", "min": 0, "max": 10},
                    },
                ]
            )
        )

        status = ItemClassifier(builder).classify_item("q_c")["precondition"]["status"]
        self.assertNotEqual(status, "NEVER")

    def test_a_none_guard_postcondition_is_not_called_tautological(self):
        """``x is None or y >= x`` cannot be lowered (``is``). Leaving it out makes
        Q true, which must not be reported as a redundant, removable condition —
        found on a dev questionnaire by the corpus check for this change."""
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {"id": "q_a", "input": {"control": "Editbox", "min": 0, "max": 99}},
                    {
                        "id": "q_b",
                        "postcondition": [
                            {"predicate": "q_a.outcome is None or q_b.outcome >= q_a.outcome"}
                        ],
                        "input": {"control": "Editbox", "min": 0, "max": 99},
                    },
                ]
            )
        )

        post = ItemClassifier(builder).classify_item("q_b")["postcondition"]
        self.assertNotEqual(post["invariant"], "TAUTOLOGICAL")
        self.assertFalse(post["global"]["q_globally_true"])

    def test_an_unlowerable_operand_in_a_postcondition_is_not_called_tautological(self):
        """``str(...)`` does not lower, so Q is inexact; its True stand-in must
        not read as a redundant, always-true check (``Q_exact`` in the
        classifier)."""
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q_b",
                        "postcondition": [{"predicate": "str(q_b.outcome) == '9' or q_b.outcome >= 0"}],
                        "input": {"control": "Radio", "labels": {1: "A", 2: "B", 9: "C"}},
                    },
                ]
            )
        )

        post = ItemClassifier(builder).classify_item("q_b")["postcondition"]
        self.assertNotEqual(post["invariant"], "TAUTOLOGICAL")
        self.assertFalse(post["global"]["q_globally_true"])

    def test_an_inexact_precondition_is_not_called_always(self):
        """An unlowerable gate conjoins to True; ALWAYS would tell the
        none-unsafe-reference lint the item is asked on every path."""
        builder = _gated_on("str(q_b.outcome) == '9' and risk == 1")

        pre = ItemClassifier(builder).classify_item("q_c")["precondition"]["status"]
        self.assertEqual(pre, "CONDITIONAL")

    def test_a_fully_lowerable_and_or_still_lowers(self):
        builder = _gated_on("q_b.outcome == 1 and risk == 1")
        for predicate in ("q_b.outcome == 1 and risk == 1", "q_b.outcome == 1 or q_b.outcome == 2"):
            with self.subTest(predicate=predicate):
                self.assertIsNotNone(builder._compile_predicate(predicate, "q_c", "precondition")[0])
        self.assertEqual(builder.coverage_gaps.get("q_c"), None)

    def test_an_inexact_gate_is_not_assumed_where_it_is_false(self):
        """``x is not None and x == 1`` lowers to None, so P is True. Assumed as
        ``P ⇒ Q``, that P demands Q on every path: two items gated on q_0 == 1
        and == 2, each restating its gate as a postcondition, read as a
        publish-blocking global conflict, and an item gated on q_0 == 2 as dead."""
        radio = {"control": "Radio", "labels": {1: "A", 2: "B"}}
        state = create_questionnaire(
            [
                {"id": "q_0", "input": radio},
                *(
                    {
                        "id": f"q_{k}",
                        "precondition": [
                            {"predicate": f"q_0.outcome is not None and q_0.outcome == {k}"}
                        ],
                        "postcondition": [{"predicate": f"q_0.outcome == {k}"}],
                        "input": radio,
                    }
                    for k in (1, 2)
                ),
                {"id": "q_3", "precondition": [{"predicate": "q_0.outcome == 2"}], "input": radio},
            ]
        )

        types = {i["type"] for i in ValidationProcessor(state).to_issues(deep=True)}
        self.assertNotIn("global_unsat", types)
        self.assertNotIn("accumulated_dead_code", types)

    def test_an_inexact_owner_gate_reports_no_unsafe_reference(self):
        """The owner's gate lowers to True, so the solver would find a path to
        it on which ``q_r`` (gated on q_0 == 1) is not asked, though the real
        gate is false there."""
        radio = {"control": "Radio", "labels": {1: "A", 2: "B"}}
        state = create_questionnaire(
            [
                {"id": "q_0", "input": radio},
                {"id": "q_r", "precondition": [{"predicate": "q_0.outcome == 1"}], "input": radio},
                {
                    "id": "q_o",
                    "precondition": [
                        {
                            "predicate": "q_0.outcome == 1 and q_r.outcome >= 1"
                            " and str(q_0.outcome) == '1'"
                        }
                    ],
                    "input": radio,
                },
            ]
        )

        types = {i["type"] for i in ValidationProcessor(state).to_issues()}
        self.assertNotIn("none_unsafe_reference", types)


def _duplicate_bound_flags(control: str, predicate: str) -> list[bool]:
    """``analyze_postconditions``'s duplicate-input-bound verdicts for one 0–10 item."""
    builder = StaticBuilder(
        create_questionnaire(
            [
                {
                    "id": "q",
                    "input": {"control": control, "min": 0, "max": 10},
                    "postcondition": [{"predicate": predicate}],
                }
            ]
        )
    )
    return [r["duplicate_input_bound"] for r in builder.analyze_postconditions()]


def _answer_gated(
    predicate: str,
    *,
    kind: str = "precondition",
    extra: list | None = None,
    q_b_input: dict | None = None,
    gated: bool = True,
    never_blank: bool = False,
):
    """``q_a`` (Radio 1/2), ``q_b`` (Editbox 0-99, or *q_b_input*) asked only
    when ``q_a == 1`` (always, when not *gated*), and ``q_c`` carrying
    *predicate* as its *kind* condition. *never_blank* gives ``q_b`` the own
    postcondition ``q_b.outcome is not None``, which refuses a blank answer
    (#1784), so an always-asked ``q_b`` always holds one."""
    return StaticBuilder(
        create_questionnaire(
            [
                {"id": "q_a", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                {
                    "id": "q_b",
                    **({"precondition": [{"predicate": "q_a.outcome == 1"}]} if gated else {}),
                    **({"postcondition": [{"predicate": "q_b.outcome is not None"}]} if never_blank else {}),
                    "input": q_b_input or {"control": "Editbox", "min": 0, "max": 99},
                },
                {
                    "id": "q_c",
                    kind: [{"predicate": predicate}],
                    "input": {"control": "Editbox", "min": 0, "max": 99},
                },
                *(extra or []),
            ]
        )
    )


def _status(builder: StaticBuilder, item_id: str = "q_c") -> str:
    return ItemClassifier(builder).classify_item(item_id)["precondition"]["status"]


def _invariant(builder: StaticBuilder, item_id: str = "q_c") -> str:
    return ItemClassifier(builder).classify_item(item_id)["postcondition"]["invariant"]


def _exact(
    builder: StaticBuilder, predicate: str, owner: str = "q_c", kind: str = "precondition"
) -> bool:
    return builder.compile_conditions_exactly(owner, [{"predicate": predicate}], kind=kind)[1]


@pytest.mark.unit
@pytest.mark.z3
class TestNoneGuardLowers(unittest.TestCase):
    """#1250 (D70): ``X.outcome is None`` lowers to ``Not(answered_X)``, so the
    guard the ``none_unsafe_reference`` lint recommends keeps a gate verified."""

    def test_a_none_guard_and_its_comparison_lower_exactly(self):
        builder = _answer_gated("q_b.outcome is not None and q_b.outcome > 3")

        for predicate in (
            "q_b.outcome is not None and q_b.outcome > 3",
            "q_b.outcome is None or q_c.outcome >= q_b.outcome",
            "q_b.outcome == None",
            "None != q_b.outcome",
        ):
            with self.subTest(predicate=predicate):
                self.assertTrue(_exact(builder, predicate))
        self.assertEqual(builder.coverage_gaps.get("q_c") or [], [])

    def test_a_none_guard_postcondition_that_can_fail_is_not_tautological(self):
        predicate = "q_b.outcome is None or q_c.outcome >= q_b.outcome"
        builder = _answer_gated(predicate, kind="postcondition")

        post = ItemClassifier(builder).classify_item("q_c")["postcondition"]
        self.assertEqual(post["invariant"], "CONSTRAINING")
        self.assertTrue(_exact(builder, predicate))

    def test_a_gate_on_an_always_items_answer_is_conditional_not_never(self):
        """q_a has no precondition, but a respondent can still skip it."""
        builder = _answer_gated("q_a.outcome is not None")

        self.assertEqual(_status(builder), "CONDITIONAL")
        self.assertTrue(_exact(builder, "q_a.outcome is not None"))

    def test_an_answer_says_nothing_about_the_items_gate(self):
        """``answered`` stays a free Bool for every gate (#1768). The runtime
        refuses an answer whose gate says no when it arrives, but a gate None
        satisfies (``q_a.outcome != 1`` with q_a unasked) can pass, and a later
        out-of-order API answer to q_a is appended, not rewound, so the gate
        turns false while the answered item stays on the path."""
        predicate = "q_b.outcome is not None and q_a.outcome == 2"
        builder = _answer_gated(predicate)

        self.assertEqual(_status(builder), "CONDITIONAL")
        self.assertTrue(_exact(builder, predicate))

    def test_an_unanswered_item_is_possible_where_it_was_asked(self):
        predicate = "q_b.outcome is None and q_a.outcome == 1"
        builder = _answer_gated(predicate)

        self.assertEqual(_status(builder), "CONDITIONAL")
        self.assertTrue(_exact(builder, predicate))

    def test_a_value_read_where_the_item_may_be_unanswered_is_not_lowered(self):
        """At runtime ``None != 1`` is True; the model holds q_a as 1 or 2, so
        lowering this gate would call a reachable item NEVER."""
        for predicate in (
            "q_a.outcome is None and q_a.outcome != 1 and q_a.outcome != 2",
            "q_a.outcome != 1 and q_a.outcome is not None",
            "q_a.outcome is not None or q_a.outcome != 1",
        ):
            with self.subTest(predicate=predicate):
                builder = _answer_gated(predicate)
                self.assertFalse(_exact(builder, predicate))
                self.assertNotEqual(_status(builder), "NEVER")

    def test_an_items_own_conditions_each_get_their_own_answered_bool(self):
        """Its gate runs before it is answered and its postcondition after, so
        the two tests on q do not contradict each other."""
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q",
                        "precondition": [{"predicate": "q.outcome is None"}],
                        "postcondition": [{"predicate": "q.outcome is not None"}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    }
                ]
            )
        )

        post = ItemClassifier(builder).classify_item("q")["postcondition"]
        self.assertNotEqual(post["invariant"], "INFEASIBLE")
        self.assertTrue(_exact(builder, "q.outcome is None", owner="q"))

    def test_an_item_code_sets_is_still_modelled(self):
        """A free Bool already allows an answer nobody gave, so code that sets
        q_b leaves the guard verified."""
        predicate = "q_b.outcome is not None and q_a.outcome == 2"
        builder = _answer_gated(
            predicate,
            extra=[
                {
                    "id": "q_d",
                    "input": {"control": "Editbox", "min": 0, "max": 9},
                    "codeBlock": "q_b.outcome = 5",
                }
            ],
        )

        self.assertTrue(_exact(builder, predicate))
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_a_none_test_nobody_can_make_provable_is_not_lowered_or_warned(self):
        """A variable has no answeredness; no rewrite clears it, so no gap."""
        predicate = "v is None or v > 2"
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q_c",
                        "precondition": [{"predicate": predicate}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                ],
                code_init="v = 3",
            )
        )
        self.assertFalse(_exact(builder, predicate))
        self.assertEqual(builder.coverage_gaps.get("q_c") or [], [])

    def test_a_none_test_after_a_read_of_its_item_is_a_gap_the_author_can_clear(self):
        predicate = "q_a.outcome != 1 or q_a.outcome is None"
        builder = _answer_gated(predicate)

        gaps = builder.coverage_gaps.get("q_c") or []
        self.assertEqual([(g["kind"], g["unsupported_nodes"]) for g in gaps], [("precondition", ["Is"])])
        self.assertTrue(_exact(builder, "q_a.outcome is None or q_a.outcome != 1"))

    def test_a_variable_holding_the_items_value_is_a_read_of_it(self):
        """``v = q_b.outcome`` stores None for a skipped q_b, so the postcondition
        holds at runtime while the model holds v as 1 or 2."""
        predicate = "q_b.outcome is None and v != 1 and v != 2"
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q_b",
                        "precondition": [{"predicate": "False"}],
                        "input": {"control": "Radio", "labels": {1: "A", 2: "B"}},
                    },
                    {
                        "id": "q_c",
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                        "codeBlock": "v = q_b.outcome",
                    },
                    {
                        "id": "q_d",
                        "postcondition": [{"predicate": predicate}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                ]
            )
        )

        self.assertFalse(_exact(builder, predicate, owner="q_d"))
        post = ItemClassifier(builder).classify_item("q_d")["postcondition"]
        self.assertNotEqual(post["invariant"], "INFEASIBLE")

    def test_answeredness_code_changes_between_conditions_is_no_conflict(self):
        """q_x is skipped, q_y's postcondition sees it unanswered and q_y's
        codeBlock sets it, q_z's postcondition sees it answered: all hold."""
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q_x",
                        "precondition": [{"predicate": "False"}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                    {
                        "id": "q_y",
                        "postcondition": [{"predicate": "q_x.outcome is None"}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                        "codeBlock": "q_x.outcome = 5",
                    },
                    {
                        "id": "q_z",
                        "postcondition": [{"predicate": "q_x.outcome is not None"}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                ]
            )
        )

        self.assertTrue(_exact(builder, "q_x.outcome is None", owner="q_y"))
        issues = ValidationProcessor(builder.state).to_issues(deep=True)
        self.assertNotIn("global_unsat", [i["type"] for i in issues])

    def test_a_gate_without_a_none_test_classifies_unchanged(self):
        for predicate, expected in (("q_a.outcome == 2", "CONDITIONAL"), ("q_a.outcome == 3", "NEVER")):
            with self.subTest(predicate=predicate):
                self.assertEqual(_status(_answer_gated(predicate)), expected)

    def test_a_none_test_on_free_text_is_not_a_sentinel_read(self):
        builder = _answer_gated(
            "q_t.outcome is not None",
            extra=[{"id": "q_t", "input": {"control": "Textarea"}}],
        )

        kinds = [g["kind"] for g in builder.coverage_gaps.get("q_c") or []]
        self.assertNotIn("textarea_in_predicate", kinds)
        self.assertTrue(_exact(builder, "q_t.outcome is not None"))

    def test_a_none_test_beside_a_read_of_the_text_is_not_lowered(self):
        """Free text lowers to a constant, so ``q_t.outcome is not None and
        q_t.outcome`` would be proven False although any answer makes it True."""
        predicate = "q_t.outcome is not None and q_t.outcome"
        builder = _answer_gated(predicate, extra=[{"id": "q_t", "input": {"control": "Textarea"}}])

        self.assertFalse(_exact(builder, predicate))
        self.assertNotEqual(_status(builder), "NEVER")

    def test_a_none_test_beside_a_variable_that_may_hold_the_text_is_not_lowered(self):
        predicate = "q_t.outcome is not None and v != 0"
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {"id": "q_t", "input": {"control": "Textarea"}},
                    {
                        "id": "q_v",
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                        "codeBlock": "v = q_t.outcome",
                    },
                    {
                        "id": "q_c",
                        "postcondition": [{"predicate": predicate}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                ]
            )
        )

        self.assertFalse(_exact(builder, predicate))
        post = ItemClassifier(builder).classify_item("q_c")["postcondition"]
        self.assertNotEqual(post["invariant"], "INFEASIBLE")

    def test_a_codeblock_none_test_does_not_make_an_assignment_skippable(self):
        """``uninitialized_read`` treats a None-tested ``if`` as always
        assigning: an answer can arrive whatever q_b's gate, so the free Bool
        would read r as possibly unassigned where every walk assigns it."""
        state = create_questionnaire(
            [
                {"id": "q_a", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                {
                    "id": "q_b",
                    "precondition": [{"predicate": "q_a.outcome == 1"}],
                    "input": {"control": "Editbox", "min": 0, "max": 9},
                },
                {
                    "id": "q_c",
                    "input": {"control": "Editbox", "min": 0, "max": 9},
                    "codeBlock": "if q_b.outcome is None:\n    r = 1",
                },
                {
                    "id": "q_r",
                    "precondition": [{"predicate": "q_a.outcome == 2 and r == 1"}],
                    "input": {"control": "Editbox", "min": 0, "max": 9},
                },
            ]
        )

        issues = ValidationProcessor(state).to_issues()
        self.assertNotIn("uninitialized_read", [i["type"] for i in issues])

    def test_a_reader_gate_with_an_unlowered_none_test_is_not_judged(self):
        """The guard follows a read of q_a, so the gate does not lower and the
        lint would see it as True; q_r is reached only when q_a == 1, where r
        is always assigned."""
        issue_types = {}
        for gate in (
            "q_a.outcome != 2 and q_a.outcome is not None and r == 1",
            "q_a.outcome is not None and q_a.outcome != 2 and r == 1",
        ):
            state = create_questionnaire(
                [
                    {"id": "q_a", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                    {
                        "id": "q_c",
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                        "codeBlock": "if q_a.outcome == 1:\n    r = 1",
                    },
                    {
                        "id": "q_r",
                        "precondition": [{"predicate": gate}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                ]
            )
            issue_types[gate] = [i["type"] for i in ValidationProcessor(state).to_issues()]

        for gate, types in issue_types.items():
            with self.subTest(gate=gate):
                self.assertNotIn("uninitialized_read", types)


def _skip_gated(predicate: str, **kwargs) -> StaticBuilder:
    """``_answer_gated`` with ``q_b`` a Radio 1/2, whose two labels a ``!=`` gate can exhaust."""
    return _answer_gated(predicate, q_b_input={"control": "Radio", "labels": {1: "Y", 2: "N"}}, **kwargs)


def _code_reader(
    code: str,
    post: str,
    *,
    code_init: str = "flag = 0",
    q_b_input: dict | None = None,
    gated: bool = True,
    never_blank: bool = False,
) -> StaticBuilder:
    """#1776: ``q_a`` (Radio 1/2), ``q_b`` (Radio {1}, or *q_b_input*) asked
    only when ``q_a == 1`` (always, when not *gated*; *never_blank* refuses a
    blank ``q_b``, as in ``_answer_gated``), ``q_c`` whose codeBlock *code*
    reads ``q_b``, and ``r`` carrying *post* as its postcondition."""
    return StaticBuilder(
        create_questionnaire(
            [
                {"id": "q_a", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                {
                    "id": "q_b",
                    **({"precondition": [{"predicate": "q_a.outcome == 1"}]} if gated else {}),
                    **({"postcondition": [{"predicate": "q_b.outcome is not None"}]} if never_blank else {}),
                    "input": q_b_input or {"control": "Radio", "labels": {1: "Y"}},
                },
                {"id": "q_c", "codeBlock": code, "input": {"control": "Radio", "labels": {1: "Y", 2: "N"}}},
                {"id": "r", "postcondition": [{"predicate": post}], "input": {"control": "Radio", "labels": {1: "OK"}}},
            ],
            code_init=code_init,
        )
    )


@pytest.mark.unit
@pytest.mark.z3
class TestSkippedItemReads(unittest.TestCase):
    """#1769: a gated-out item reads ``None``, and ``None != 1`` is True, so a
    gate on ``!=`` / ``not in`` is reachable through the skip.

    The first test and the any-of / postcondition / left-empty / list tests
    fail without the skip. The precision tests (always-asked, still-answered)
    pass without it too: they fail when the skip is modelled too wide. The
    codeBlock tests extend the skip to a codeBlock's reads (#1776).
    """

    def test_a_gate_no_answer_satisfies_is_reachable_through_the_skip(self):
        for predicate in (
            "q_b.outcome != 1 and q_b.outcome != 2",
            "q_b.outcome not in [1, 2]",
            "not (q_b.outcome == 1 or q_b.outcome == 2)",
            "not q_b.outcome",
        ):
            with self.subTest(predicate=predicate):
                builder = _skip_gated(predicate)
                self.assertEqual(_status(builder), "CONDITIONAL")
                self.assertTrue(_exact(builder, predicate))

    def test_the_same_gate_on_an_always_asked_item_stays_never(self):
        """Precision: an item with no gate is never skipped."""
        self.assertEqual(_status(_skip_gated("q_b.outcome != 1 and q_b.outcome != 2", gated=False)), "NEVER")

    def test_a_gate_on_an_item_left_empty_skips_too(self):
        """q_a shown and left empty leaves q_b's gate ``q_a.outcome == 1``
        undecided, which skips q_b (#1023), although the model holds q_a as 1:
        a skip is not tied to the item's gate being false."""
        builder = _answer_gated(
            "q_b.outcome != 1",
            q_b_input={"control": "Radio", "labels": {1: "Y"}},
        )
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_a_gated_out_item_may_still_hold_an_answer(self):
        """Precision the other way: an API submit answers q_b whatever q_a is,
        so q_a == 2 with q_b == 1 leaves this gate false: it is not ALWAYS."""
        builder = _skip_gated("q_b.outcome != 1 or q_a.outcome == 1")
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_an_any_of_over_a_skippable_items_labels_is_not_always(self):
        predicate = "q_b.outcome == 1 or q_b.outcome == 2"
        self.assertEqual(_status(_skip_gated(predicate)), "CONDITIONAL")
        self.assertEqual(_status(_skip_gated(predicate, gated=False, never_blank=True)), "ALWAYS")

    def test_a_postcondition_a_skip_satisfies_is_not_infeasible(self):
        predicate = "q_b.outcome != 1 and q_b.outcome != 2"
        post = ItemClassifier(_skip_gated(predicate, kind="postcondition")).classify_item("q_c")
        self.assertEqual(post["postcondition"]["invariant"], "CONSTRAINING")
        always = ItemClassifier(_skip_gated(predicate, kind="postcondition", gated=False, never_blank=True)).classify_item("q_c")
        self.assertEqual(always["postcondition"]["invariant"], "INFEASIBLE")

    def test_a_raise_is_exact_wherever_it_sits(self):
        """#1775 / #1779: ``None > 1`` raises, which fails a precondition. The
        two-sided lowering places it exactly under ``and``, in any ``or``
        operand, under ``not`` and as a truth-tested arithmetic leaf; a read in
        a ternary branch may not raise there and is refused (#1867)."""
        for predicate, exact in (
            ("q_b.outcome != 1 and q_b.outcome > 1", True),
            ("q_a.outcome == 2 or (q_a.outcome == 1 and q_b.outcome > 1)", True),
            ("q_b.outcome > 1 or q_b.outcome != 1", True),
            ("not q_b.outcome > 1", True),
            ("q_b.outcome % 2", True),
            ("(q_b.outcome if q_a.outcome == 1 else 1) > 0", False),
        ):
            with self.subTest(predicate=predicate):
                builder = _skip_gated(predicate)
                self.assertEqual(_exact(builder, predicate), exact)
                self.assertNotEqual(_status(builder), "ALWAYS")

    def test_an_ordering_read_of_a_skippable_item_is_not_always(self):
        """q_b (0-99) is asked only when q_a == 1; ``q_b.outcome >= 0`` raises for
        everyone else, so the item it gates is not ALWAYS."""
        self.assertEqual(_status(_answer_gated("q_b.outcome >= 0")), "CONDITIONAL")
        self.assertEqual(_status(_answer_gated("q_b.outcome >= 0", gated=False, never_blank=True)), "ALWAYS")

    def test_an_ordering_gate_no_answer_meets_stays_never(self):
        """Precision: a raise fails the gate, so the skip opens no path here."""
        self.assertEqual(_status(_answer_gated("q_b.outcome > 50 and q_b.outcome < 10")), "NEVER")

    def test_a_read_that_may_not_run_or_cannot_raise_is_not_a_raise(self):
        """A ternary branch the comparison may not evaluate claims no raise,
        ``1 != None != 2`` raises nothing, and ``set([None, 2])`` holds the
        None as a value: none of them forces q_b answered."""
        for predicate in (
            "q_b.outcome != 1 and q_b.outcome != 2 and (q_b.outcome if q_a.outcome == 1 else 1) > 0",
            "not q_b.outcome and 1 != q_b.outcome != 2",
            "len(set([q_b.outcome, q_a.outcome])) == 2 and not q_b.outcome",
        ):
            with self.subTest(predicate=predicate):
                self.assertEqual(_status(_skip_gated(predicate)), "CONDITIONAL")

    def test_a_skippable_read_through_a_ternary_into_in_is_never_never(self):
        """#1867: the ternary passes a skipped q_b's None on to ``in``, which
        reads it without raising (``None in [0, 1, 2]`` is False), so with
        q_a == 1 and q_b skipped the gate holds. The condition is refused, a
        gap naming q_b, not lowered with q_b in-domain (which proved NEVER);
        the no-ternary control stays CONDITIONAL and lowers exactly."""
        radio = {"control": "Radio", "labels": {1: "A", 2: "B"}}
        for predicate, refused in (
            ("not ((q_b.outcome if q_a.outcome == 1 else 0) in [0, 1, 2])", True),
            ("not ((q_b.outcome if q_a.outcome == 1 else 0) == 0)", True),
            ("not (q_b.outcome in [0, 1, 2])", False),
        ):
            with self.subTest(predicate=predicate):
                builder = _answer_gated(predicate, q_b_input=radio)
                self.assertEqual(_status(builder), "CONDITIONAL")
                self.assertEqual(_exact(builder, predicate), not refused)
                gaps = [g.get("ternary_items") for g in builder.coverage_gaps.get("q_c", [])]
                self.assertEqual(gaps, [["q_b"]] if refused else [])

    def test_a_ternary_into_an_ordering_stays_a_provable_raise(self):
        """PR #1986 review: ``None > 199`` raises, so a ternary landing in an
        ordering is the wide raise (#1775), not a refusal: still NEVER."""
        predicate = "(q_b.outcome if q_a.outcome == 1 else 0) > 199"
        builder = _answer_gated(predicate)
        self.assertEqual(_status(builder), "NEVER")
        self.assertFalse(any(g.get("ternary_items") for g in builder.coverage_gaps.get("q_c", [])))

    def test_a_refused_ternary_names_every_item_it_passes_on(self):
        predicate = "(q_b.outcome if q_a.outcome == 1 else 0) == (q_d.outcome if q_a.outcome == 1 else 0)"
        gated = {"precondition": [{"predicate": "q_a.outcome == 1"}], "input": {"control": "Radio", "labels": {1: "Y"}}}
        builder = _answer_gated(predicate, extra=[{"id": "q_d", **gated}])
        self.assertEqual([g.get("ternary_items") for g in builder.coverage_gaps.get("q_c", [])], [["q_b", "q_d"]])

    def test_arithmetic_inside_a_ternary_branch_stays_a_wide_raise(self):
        """``None + 1`` raises before the ternary passes anything on, so the
        read keeps the wide lowering (an ``inexact`` formula, no refusal)."""
        predicate = "(q_b.outcome + 1 if q_a.outcome == 1 else 0) > 0"
        builder = _answer_gated(predicate)
        self.assertFalse(_exact(builder, predicate))
        self.assertNotEqual(_status(builder), "ALWAYS")
        self.assertFalse(any(g.get("ternary_items") for g in builder.coverage_gaps.get("q_c", [])))

    def test_an_unknown_condition_kind_is_refused_loudly(self):
        """The kind decides the raise's direction, so a misspelt one raises
        instead of being swallowed by the lowering's error guard."""
        builder = _answer_gated("q_b.outcome > 1")
        with self.assertRaises(ValueError):
            builder.compile_conditions_exactly("q_c", [{"predicate": "q_b.outcome > 1"}], kind="pre")

    def test_a_raising_postcondition_is_waived_not_infeasible(self):
        """A postcondition that raises is waived, so ``q_b.outcome > 200`` over a
        0-99 scale passes for everyone who skipped q_b."""
        def invariant(gated: bool) -> str:
            return _invariant(
                _answer_gated("q_b.outcome > 200", kind="postcondition", gated=gated, never_blank=not gated)
            )

        self.assertEqual(invariant(True), "CONSTRAINING")
        self.assertEqual(invariant(False), "INFEASIBLE")
        builder = _answer_gated("q_b.outcome > 200", kind="postcondition")
        self.assertTrue(_exact(builder, "q_b.outcome > 200", kind="postcondition"))

    def test_a_raise_before_a_failing_operand_still_waives(self):
        """``q_b.outcome > 200 and q_a.outcome == 9`` raises before q_a's test
        is reached, so the whole check is waived, not failed."""
        builder = _answer_gated("q_b.outcome > 200 and q_a.outcome == 9", kind="postcondition")
        self.assertEqual(_invariant(builder), "CONSTRAINING")

    def test_two_conditions_read_like_their_conjunction(self):
        """One skip fact joins the conditions of one item: ``[!= 200, >= 0]``
        over a 0-99 q_b is ``!= 200 and >= 0``, which a skipped q_b fails
        (``None >= 0`` raises), so neither spelling is ALWAYS."""
        split = _answer_gated("q_b.outcome != 200")
        split.item_details["q_c"]["preconditions"].append({"predicate": "q_b.outcome >= 0"})
        joined = _answer_gated("q_b.outcome != 200 and q_b.outcome >= 0")
        self.assertEqual(_status(split), "CONDITIONAL")
        self.assertEqual(_status(joined), "CONDITIONAL")

    def test_a_gate_that_raises_on_a_skip_is_no_condition_for_one(self):
        """q_z is skipped when q_a == 2; q_y's gate ``q_z.outcome > 3`` then
        raises, so q_y is skipped too and ``q_y.outcome != 1`` holds, although
        q_z's scale (4-5) makes the gate's negation impossible in the model."""
        radio = {"control": "Radio", "labels": {1: "Y"}}
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {"id": "q_a", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                    {
                        "id": "q_z",
                        "precondition": [{"predicate": "q_a.outcome == 1"}],
                        "input": {"control": "Editbox", "min": 4, "max": 5},
                    },
                    {"id": "q_y", "precondition": [{"predicate": "q_z.outcome > 3"}], "input": radio},
                    {
                        "id": "q_c",
                        "precondition": [{"predicate": "q_y.outcome != 1"}],
                        "input": {"control": "Editbox", "min": 0, "max": 9},
                    },
                ]
            )
        )
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_an_items_skip_is_one_fact_across_predicates(self):
        """Precision: q_c's gate repeats q_b's, so q_b is asked wherever q_c is
        reached and ``q_b.outcome > 0`` needs no None guard. A skip choice per
        predicate would let q_a read as skipped in one gate and answered in the
        other, and warn."""
        radio = {"control": "Radio", "labels": {1: "Y", 2: "N"}}
        gate = [{"predicate": "path == 1"}, {"predicate": "q_a.outcome == 1"}]
        state = create_questionnaire(
            [
                {"id": "q_g", "input": radio, "codeBlock": "path = q_g.outcome"},
                {"id": "q_a", "precondition": [{"predicate": "q_g.outcome == 1"}], "input": {"control": "Switch"}},
                {"id": "q_b", "precondition": gate, "input": radio},
                {"id": "q_c", "precondition": [*gate, {"predicate": "q_b.outcome > 0"}], "input": radio},
            ],
            code_init="path = 0",
        )
        types = [i["type"] for i in ValidationProcessor(state).to_issues() if i["item_id"] == "q_c"]
        self.assertNotIn("none_unsafe_reference", types)

    def test_a_code_written_item_is_skipped_per_predicate(self):
        """q_y's check passes on a skipped q_x (``!= 1 and != 2``), its codeBlock
        then answers q_x = 1, and q_z's check needs exactly that: one skip fact
        for q_x would make the two checks a false global conflict."""
        radio = {"control": "Radio", "labels": {1: "Y", 2: "N"}}
        state = create_questionnaire(
            [
                {"id": "q_g", "input": radio},
                {"id": "q_x", "precondition": [{"predicate": "q_g.outcome == 1"}], "input": radio},
                {
                    "id": "q_y",
                    "postcondition": [{"predicate": "q_x.outcome != 1 and q_x.outcome != 2"}],
                    "codeBlock": "q_x.outcome = 1",
                    "input": radio,
                },
                {"id": "q_z", "postcondition": [{"predicate": "q_x.outcome == 1"}], "input": radio},
            ]
        )
        types = [i["type"] for i in ValidationProcessor(state).to_issues()]
        self.assertNotIn("global_unsat", types)

    def test_a_tuple_target_is_a_code_write(self):
        """``q_x.outcome, unused = 1, 0`` answers q_x like ``q_x.outcome = 1``."""
        radio = {"control": "Radio", "labels": {1: "Y", 2: "N"}}
        state = create_questionnaire(
            [
                {"id": "q_g", "input": radio},
                {"id": "q_x", "precondition": [{"predicate": "q_g.outcome == 1"}], "input": radio},
                {
                    "id": "q_y",
                    "postcondition": [{"predicate": "q_x.outcome != 1 and q_x.outcome != 2"}],
                    "codeBlock": "q_x.outcome, unused = 1, 0",
                    "input": radio,
                },
                {"id": "q_z", "postcondition": [{"predicate": "q_x.outcome == 1"}], "input": radio},
            ]
        )
        types = [i["type"] for i in ValidationProcessor(state).to_issues()]
        self.assertNotIn("global_unsat", types)

    def test_a_store_through_an_alias_counts_as_writing_every_item(self):
        """``alias.outcome = 1`` may write q_x, so q_x is skipped per predicate."""
        radio = {"control": "Radio", "labels": {1: "Y", 2: "N"}}
        state = create_questionnaire(
            [
                {"id": "q_g", "input": radio},
                {"id": "q_x", "precondition": [{"predicate": "q_g.outcome == 1"}], "input": radio},
                {
                    "id": "q_y",
                    "postcondition": [{"predicate": "q_x.outcome != 1 and q_x.outcome != 2"}],
                    "codeBlock": "alias = q_x\nalias.outcome = 1",
                    "input": radio,
                },
                {"id": "q_z", "postcondition": [{"predicate": "q_x.outcome == 1"}], "input": radio},
            ]
        )
        types = [i["type"] for i in ValidationProcessor(state).to_issues()]
        self.assertNotIn("global_unsat", types)

    def test_a_witness_reports_a_skipped_code_written_item_as_none(self):
        from askalot_qml.z3.global_formula import GlobalFormula

        radio = {"control": "Radio", "labels": {1: "Y", 2: "N"}}
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {"id": "q_g", "input": radio},
                    {"id": "q_x", "precondition": [{"predicate": "q_g.outcome == 1"}], "input": radio},
                    {
                        "id": "q_y",
                        "postcondition": [{"predicate": "q_x.outcome != 1 and q_x.outcome != 2"}],
                        "codeBlock": "if False:\n    q_x.outcome = 1",
                        "input": radio,
                    },
                ]
            )
        )
        result = GlobalFormula(builder).check()
        self.assertTrue(result.satisfiable)
        self.assertIsNone(result.witness["q_x.outcome"])

    def test_a_witness_reports_a_skipped_item_as_none(self):
        """A completion that holds only because q_b was skipped shows q_b unasked."""
        from askalot_qml.z3.global_formula import GlobalFormula

        builder = _skip_gated("q_b.outcome != 1 and q_b.outcome != 2", kind="postcondition")
        result = GlobalFormula(builder).check()
        self.assertTrue(result.satisfiable)
        self.assertIsNone(result.witness["q_b.outcome"])

    def test_bool_and_any_of_a_skipped_item_read_none(self):
        """``bool(None)`` and ``any([None])`` are False without raising."""
        radio = {"control": "Radio", "labels": {1: "Y"}}
        for predicate in (
            "not bool(q_b.outcome)",
            "not any([q_b.outcome])",
            "not any(q_b.outcome for i in range(1))",
        ):
            with self.subTest(predicate=predicate):
                builder = _answer_gated(predicate, q_b_input=radio)
                self.assertEqual(_status(builder), "CONDITIONAL")
                self.assertTrue(_exact(builder, predicate))

    def test_a_skipped_item_in_a_literal_list_reads_none(self):
        """``1 not in [None]`` is True, and ``None in [None]`` too: a list member
        compares as ``==``, either side skipped (#1777)."""
        radio = {"control": "Radio", "labels": {1: "Y"}}
        for predicate, extra in (
            ("1 not in [q_b.outcome]", []),
            (
                "q_b.outcome in [q_d.outcome] and q_b.outcome != 1",
                [{"id": "q_d", "precondition": [{"predicate": "q_a.outcome == 2"}], "input": radio}],
            ),
        ):
            with self.subTest(predicate=predicate):
                builder = _answer_gated(predicate, q_b_input=radio, extra=extra)
                self.assertEqual(_status(builder), "CONDITIONAL")
                self.assertTrue(_exact(builder, predicate))

    def test_a_codeblock_test_on_a_skipped_item_can_set_its_variable(self):
        """#1776: q_b (Radio {1}) skipped reads ``None`` in q_c's codeBlock
        too, so ``flag = 1 if q_b.outcome != 1 else 0`` sets ``flag`` to 1 and
        ``r``'s check passes on that walk: not INFEASIBLE (the B390 fixture
        ``1776-codeblock-reads-skipped``). q_b refuses a blank, so only its
        skip reads ``None``. Precision: always asked, it always reads 1."""
        code = "flag = 1 if q_b.outcome != 1 else 0"
        post = "q_c.outcome == 1 and flag == 1"
        self.assertEqual(_invariant(_code_reader(code, post, never_blank=True), "r"), "CONSTRAINING")
        self.assertEqual(_invariant(_code_reader(code, post, gated=False, never_blank=True), "r"), "INFEASIBLE")

    def test_a_none_copied_through_a_variable_never_forces_an_equality(self):
        """#1847: a skipped q_b copied into ``x`` (or passed through a ternary)
        is still ``None``, and Python's ``None == None`` sets ``flag`` to 1, so
        ``r``'s check passes on the skip walk: CONSTRAINING, never the
        INFEASIBLE that comparing a number with ``None`` gave. q_b refuses a
        blank, so only its skip reads ``None``. Precision: always asked, the
        copy is q_b's answer, ``flag`` is 1 and ``q_b.outcome != 1`` fails."""
        post = "q_b.outcome != 1 and flag == 1"
        for code in (
            "x = q_b.outcome\nflag = 1 if x == q_b.outcome else 0",
            "flag = 1 if (q_b.outcome if True else 1) == q_b.outcome else 0",
        ):
            with self.subTest(code=code):
                self.assertEqual(_invariant(_code_reader(code, post, never_blank=True), "r"), "CONSTRAINING")
                always = _code_reader(code, post, gated=False, never_blank=True)
                self.assertEqual(_invariant(always, "r"), "INFEASIBLE")

    def test_a_reassignment_clears_a_copied_none(self):
        """Codex on PR #1986: ``x = 1`` replaces the ``None`` copied into ``x``,
        so ``x + 1`` cannot raise and a skipped q_b leaves ``flag`` at 2:
        CONSTRAINING, never the INFEASIBLE a stale mark gave."""
        code = "x = q_b.outcome\nx = 1\nflag = x + 1"
        self.assertEqual(_invariant(_code_reader(code, "q_b.outcome != 1 and flag == 2", never_blank=True), "r"), "CONSTRAINING")

    def test_a_none_copied_on_a_branch_not_taken_marks_nothing(self):
        """Codex round 2 on PR #1986: ``if False: x = q_b.outcome`` never runs,
        so ``x`` keeps 1, ``x + 1`` cannot raise and ``flag`` is 2 for a
        skipped q_b: CONSTRAINING. Taken (``if True:``), the copy makes
        ``x + 1`` raise on the skip and ``flag`` stays 0: INFEASIBLE."""
        post = "q_b.outcome != 1 and flag == 2"
        for test, invariant in (("False", "CONSTRAINING"), ("True", "INFEASIBLE")):
            with self.subTest(test=test):
                code = f"if {test}:\n    x = q_b.outcome\nflag = x + 1"
                builder = _code_reader(code, post, code_init="x = 1\nflag = 0", never_blank=True)
                self.assertEqual(_invariant(builder, "r"), invariant)

    def test_an_augmented_assignment_on_a_copied_none_raises(self):
        """PR #1986 review: ``x += 1`` reads ``x``; a skipped q_b copied into
        it is ``None``, so the block stops there and ``flag`` keeps 0:
        CONSTRAINING. Always asked, ``flag`` is 5 and the check INFEASIBLE."""
        code = "x = q_b.outcome\nx += 1\nflag = 5"
        post = "q_b.outcome != 1 and flag == 0"
        self.assertEqual(_invariant(_code_reader(code, post, never_blank=True), "r"), "CONSTRAINING")
        self.assertEqual(_invariant(_code_reader(code, post, gated=False, never_blank=True), "r"), "INFEASIBLE")

    def test_an_annotation_is_not_a_read(self):
        """#1776: an ``x: <annotation> = value`` annotation is never evaluated
        (deferred on Python 3.14, stripped by the runner), so a skipped q_b
        in it raises nothing and ``flag = 1`` always runs: ``flag == 0`` is
        INFEASIBLE."""
        code = "x: q_b.outcome + 1 = 0\nflag = 1"
        q_b_input = {"control": "Editbox", "min": 1, "max": 5}
        builder = _code_reader(code, "flag == 0", q_b_input=q_b_input, never_blank=True)
        self.assertEqual(_invariant(builder, "r"), "INFEASIBLE")

    def test_a_codeblock_read_that_raises_on_a_skip_leaves_its_variables(self):
        """#1776: ``None + 10`` raises, so the block stops there: ``flag`` and
        every later assignment (``after``) keep the values they had, exactly
        (a skipped q_b forces both), and ``r``'s check on them is not
        INFEASIBLE. q_b refuses a blank, so only its skip reads ``None``."""
        code = "flag = q_b.outcome + 10\nafter = 1"
        post = "flag == 0 and after == 0"
        q_b_input = {"control": "Editbox", "min": 1, "max": 5}
        builder = _code_reader(code, post, code_init="flag = 0\nafter = 0", q_b_input=q_b_input, never_blank=True)
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")
        ran = builder._visited_sentinel("q_c")
        for name in ("flag_1", "after_1"):
            with self.subTest(variable=name):
                changed = builder.z3_vars[name] != 0
                self.assertFalse(_sat(builder.get_full_base(), ran, builder.skip_choice("q_b"), changed))
        always = _code_reader(
            code, post, code_init="flag = 0\nafter = 0", q_b_input=q_b_input, gated=False, never_blank=True
        )
        self.assertEqual(_invariant(always, "r"), "INFEASIBLE")


def _branch_writer(code: str, post: str, code_init: str = "flag = 0") -> StaticBuilder:
    """#1843: ``q_a`` (Radio 1/2, refusing a blank) whose codeBlock is *code*,
    and ``r`` carrying *post* as its postcondition."""
    return StaticBuilder(
        create_questionnaire(
            [
                {
                    "id": "q_a",
                    "postcondition": [{"predicate": "q_a.outcome is not None"}],
                    "codeBlock": code,
                    "input": {"control": "Radio", "labels": {1: "A", 2: "B"}},
                },
                {"id": "r", "postcondition": [{"predicate": post}], "input": {"control": "Radio", "labels": {1: "OK"}}},
            ],
            code_init=code_init,
        )
    )


@pytest.mark.unit
@pytest.mark.z3
class TestCodeBlockControlFlow(unittest.TestCase):
    """#1843: a codeBlock is lowered in statement order, each assignment under
    the path of the ``if`` / ``elif`` / ``else`` branches holding it
    (``new == If(path, value, old)``), and a loop widens what it assigns.
    Before, every assignment ran unconditionally in ``ast.walk`` order, so
    ``r``'s check was INFEASIBLE for the runtime-sound shapes below."""

    def test_an_if_only_assignment_keeps_the_old_value_off_its_branch(self):
        builder = _branch_writer("if q_a.outcome == 1:\n    flag = 1", "flag == 0")
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")
        # Precision: on the branch, flag is 1.
        on_branch = And(builder.item_vars["q_a"] == 1, builder.z3_vars["flag_1"] != 1)
        self.assertFalse(_sat(builder.get_full_base(), builder._visited_sentinel("q_a"), on_branch))

    def test_the_taken_branch_of_an_if_else_wins(self):
        code = "if q_a.outcome == 1:\n    flag = 1\nelif q_a.outcome == 2:\n    flag = 2\nelse:\n    flag = 3"
        for post, invariant in (("flag == 1", "CONSTRAINING"), ("flag == 2", "CONSTRAINING"), ("flag == 3", "INFEASIBLE")):
            with self.subTest(post=post):
                self.assertEqual(_invariant(_branch_writer(code, post), "r"), invariant)

    def test_statements_run_in_source_order(self):
        """A top-level assignment after a nested one has the last word."""
        builder = _branch_writer("if q_a.outcome == 1:\n    flag = 1\nflag = 5", "flag == 5")
        self.assertEqual(_invariant(builder, "r"), "TAUTOLOGICAL")

    def test_a_dead_branch_changes_nothing(self):
        builder = _branch_writer("if False:\n    flag = 1", "flag == 0")
        self.assertEqual(_invariant(builder, "r"), "TAUTOLOGICAL")

    def test_a_loop_assignment_is_widened(self):
        """The model does not unroll a ``for``: flag (and the loop variable)
        get a fresh unconstrained version, never ``flag == v``'s phantom."""
        builder = _branch_writer("for v in [3, 4]:\n    flag = v", "flag == 4")
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")
        self.assertIn("v", builder.version_history)

    def test_a_raise_in_a_branch_stops_the_rest_of_the_block(self):
        """Codex on PR #1986: a skipped q_b takes the branch, ``q_b.outcome + 1``
        raises, and the block stops (``CodeExecutionError``), so ``flag = 1``
        never runs and ``flag`` stays 0: CONSTRAINING, not INFEASIBLE. Always
        asked, q_b is 1 and the ``else`` sets ``flag`` to 2. No assignment sets
        ``flag`` to 0, so only the raise can leave it there (an unconditional
        lowering ends at the ``else`` value, a path one without the raise at 1)."""
        code = "if q_b.outcome != 1:\n    tmp = q_b.outcome + 1\n    flag = 1\nelse:\n    flag = 2"
        post = "q_b.outcome != 1 and flag == 0"
        self.assertEqual(_invariant(_code_reader(code, post, never_blank=True), "r"), "CONSTRAINING")
        self.assertEqual(_invariant(_code_reader(code, post, gated=False, never_blank=True), "r"), "INFEASIBLE")

    def test_a_raising_branch_test_runs_neither_branch(self):
        """PR #1986 review: ``None > 3`` raises in the ``if`` test, so the
        block stops and neither branch runs: ``flag`` keeps 0 for a skipped
        q_b (CONSTRAINING). Always asked, one branch runs (INFEASIBLE)."""
        code = "if q_b.outcome > 3:\n    flag = 1\nelse:\n    flag = 2"
        post = "q_b.outcome != 1 and flag == 0"
        q_b_input = {"control": "Editbox", "min": 1, "max": 5}
        self.assertEqual(
            _invariant(_code_reader(code, post, q_b_input=q_b_input, never_blank=True), "r"), "CONSTRAINING"
        )
        self.assertEqual(
            _invariant(_code_reader(code, "flag == 0", q_b_input=q_b_input, gated=False, never_blank=True), "r"),
            "INFEASIBLE",
        )

    def test_an_annotated_assignment_binds_its_value(self):
        builder = _branch_writer("flag: int = 2", "flag == 2")
        self.assertEqual(_invariant(builder, "r"), "TAUTOLOGICAL")

    def test_every_name_a_statement_may_bind_is_widened(self):
        """A walrus, ``with … as``, ``except … as`` and a ``match`` capture
        bind ``flag``; none is lowered, so ``flag == 0`` is not TAUTOLOGICAL."""
        for code in (
            "if (flag := 7):\n    pass",
            "with q_a as flag:\n    pass",
            "try:\n    pass\nexcept ValueError as flag:\n    pass",
            "match q_a.outcome:\n    case flag:\n        pass",
        ):
            with self.subTest(code=code):
                self.assertEqual(_invariant(_branch_writer(code, "flag == 0"), "r"), "CONSTRAINING")

    def test_an_outcome_write_holds_only_on_its_branch(self):
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q_a",
                        "postcondition": [{"predicate": "q_a.outcome is not None"}],
                        "codeBlock": "if q_a.outcome == 1:\n    t.outcome = 2",
                        "input": {"control": "Radio", "labels": {1: "A", 2: "B"}},
                    },
                    {"id": "t", "postcondition": [{"predicate": "t.outcome is not None"}],
                     "input": {"control": "Editbox", "min": 0, "max": 9}},
                    {"id": "r", "postcondition": [{"predicate": "q_a.outcome == 2 and t.outcome == 0"}],
                     "input": {"control": "Radio", "labels": {1: "OK"}}},
                ]
            )
        )
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")


_NEVER_BLANK_RADIO = {"control": "Radio", "labels": {1: "A", 2: "B"}}


def _later_writer_asked_first(q_code: str, *, t_code: str = "x = 1", q_gate: str | None = "x >= 0") -> StaticBuilder:
    """#1989: ``q``, ``t``, ``r`` in file order. ``q``'s gate reads ``x``,
    which only ``t`` writes, so the walk asks ``t`` first; ``q``'s codeBlock
    *q_code* derives ``flag`` from ``x`` and ``r`` checks ``flag == 1``."""

    def radio(item_id: str, **extra) -> dict:
        post = [{"predicate": f"{item_id}.outcome is not None"}, *extra.pop("post", [])]
        return {"id": item_id, "postcondition": post, "input": _NEVER_BLANK_RADIO, **extra}

    q = radio("q", codeBlock=q_code, **({"precondition": [{"predicate": q_gate}]} if q_gate else {}))
    return StaticBuilder(
        create_questionnaire(
            [q, radio("t", codeBlock=t_code), radio("r", post=[{"predicate": "flag == 1"}])],
            code_init="x = 0\nflag = 0",
        )
    )


@pytest.mark.unit
@pytest.mark.z3
class TestCodeStateFollowsNavigationOrder(unittest.TestCase):
    """#1989: conditions and codeBlocks are lowered in the walk's navigation
    order, so SSA versions are numbered as the walk runs them: ``q`` reads
    ``t``'s ``x = 1``, which the walk runs first, not codeInit's ``x = 0``, so
    ``r``'s ``flag == 1`` is not INFEASIBLE."""

    def test_a_straight_line_read_sees_the_later_writer(self):
        builder = _later_writer_asked_first("flag = x")

        self.assertEqual(builder.topology.get_topological_order(), ["t", "q", "r"])
        # t runs first and sets x = 1; q's gate may still skip it (the model
        # does not decide ``x >= 0`` there), leaving flag 0: CONSTRAINING.
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")

    def test_a_branch_read_sees_the_later_writer(self):
        builder = _later_writer_asked_first("if x == 1:\n    flag = 1")

        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")

    def test_an_answer_carried_through_the_later_writer_constrains(self):
        """The issue's shape with a real choice: t copies its answer, so
        ``flag == 1`` holds for one answer only (CONSTRAINING, not INFEASIBLE)."""
        builder = _later_writer_asked_first("flag = x", t_code="x = t.outcome")

        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")

    def test_the_rebuild_reproduces_its_own_order(self):
        """The second build's topology is the order it was built in (the fixed
        point ``_build`` relies on): t's write precedes q's read in the SSA history."""
        builder = _later_writer_asked_first("flag = x")

        self.assertEqual([context for _, context in builder.version_history["x"]], ["__init__", "t"])
        self.assertEqual([context for _, context in builder.version_history["flag"]], ["__init__", "q"])
        self.assertEqual(builder.topology.get_topological_order(), builder._navigation_build_order())

    def test_the_blocks_are_lowered_in_navigation_order(self):
        """The order the build lowered in, not the order it would derive:
        ``_submission_versions`` is filled as each item is lowered, so t comes
        before q, and q's conditions see t's ``x`` (version 1, not codeInit's 0)."""
        builder = _later_writer_asked_first("flag = x")

        self.assertEqual(list(builder._submission_versions), ["t", "q", "r"])
        self.assertEqual(builder._submission_versions["q"]["x"], 1)

    def test_a_questionnaire_already_in_walk_order_is_built_once(self):
        """With no gate on x, the walk keeps file order: q reads codeInit's x
        (flag is 0) and r's check is INFEASIBLE, as the runtime agrees."""
        builder = _later_writer_asked_first("flag = x", q_gate=None)

        self.assertEqual(builder.topology.get_topological_order(), ["q", "t", "r"])
        self.assertEqual(_invariant(builder, "r"), "INFEASIBLE")

    def test_a_cycle_keeps_the_file_order_build(self):
        """The #1989 shape plus two items gated on each other's answer: a real
        cycle (#1979), so the topology is no order of the graph and the build
        stays in file order, although the walk still asks t before q (the
        questionnaire is refused as a `dependency_cycle` either way)."""
        builder = _later_writer_asked_first("flag = x")
        for item_id, other in (("a", "b"), ("b", "a")):
            builder.state.get_all_items().append(
                {"id": item_id, "blockId": "b1", "kind": "Question", "title": item_id,
                 "precondition": [{"predicate": f"{other}.outcome == 1"}], "input": _NEVER_BLANK_RADIO}
            )
        cyclic = StaticBuilder(builder.state)

        self.assertTrue(cyclic.topology.has_cycles)
        self.assertEqual(cyclic.topology.get_topological_order()[:2], ["t", "q"])
        self.assertIsNone(cyclic._navigation_build_order())
        self.assertEqual(_invariant(cyclic, "r"), "INFEASIBLE")


def _radio_writer(code: str, post: str, *, gate: str | None = None) -> StaticBuilder:
    """#1994: Radio ``q0``, Radio ``q1`` with codeBlock *code* (and *gate*, if
    any), then Radio ``r`` checking *post*; codeInit ``x = 0``."""
    q1 = {"id": "q1", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}, "codeBlock": code}
    if gate:
        q1["precondition"] = [{"predicate": gate}]
    items = [{"id": "q0", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}}, q1,
             {"id": "r", "postcondition": [{"predicate": post}], "input": {"control": "Radio", "labels": {1: "OK"}}}]
    return StaticBuilder(create_questionnaire(items, code_init="x = 0"))


@pytest.mark.unit
@pytest.mark.z3
class TestGatedWriterMayNotRun(unittest.TestCase):
    """#1994: a gated item's codeBlock runs only when its gate lets it
    through. The visited sentinel (``item >= 0``) holds for every Radio
    answer, so it cannot stand for that: it would say q1's codeBlock always
    ran, and a check holding exactly when q1 was skipped would be a false
    INFEASIBLE. A Roster or capped-Group member's write is left free."""

    def test_a_check_that_holds_when_the_writer_is_skipped_is_not_refused(self):
        self.assertEqual(_invariant(_radio_writer("x = 5", "x == 0", gate="q0.outcome == 1"), "r"), "CONSTRAINING")

    def test_a_skipped_writer_keeps_the_value_it_found(self):
        """Not run, the block leaves x at codeInit's 0, so x is 5 or 0 and
        nothing else: a check on any third value stays INFEASIBLE."""
        self.assertEqual(_invariant(_radio_writer("x = 5", "x == 7", gate="q0.outcome == 1"), "r"), "INFEASIBLE")

    def test_an_ungated_writer_always_runs(self):
        self.assertEqual(_invariant(_radio_writer("x = 5", "x == 0"), "r"), "INFEASIBLE")
        self.assertEqual(_invariant(_radio_writer("x = 5", "x == 5"), "r"), "TAUTOLOGICAL")

    def test_a_gated_outcome_write_may_not_happen(self):
        """The same guard holds an outcome write: skipped, q1 writes nothing
        to q0, so ``q0.outcome == 2`` stays possible at r."""
        self.assertEqual(
            _invariant(_radio_writer("q0.outcome = 1", "q0.outcome == 2", gate="q0.outcome == 1"), "r"),
            "CONSTRAINING",
        )

    @staticmethod
    def _scoped_counter(block: str, post: str) -> StaticBuilder:
        """Checkbox ``q_pick``, then *block* (two lines of block keys) holding
        ``g1`` and ``g2``, each ``count = count + 1``, then ``r`` checking *post*."""
        member = (
            "        - id: {id}\n          kind: Question\n          title: {id}\n"
            "          input: {{control: Radio, labels: {{1: Y, 2: N}}}}\n"
            "          codeBlock: |\n            count = count + 1\n"
        )
        qml = (
            "qmlVersion: \"2.6\"\nquestionnaire:\n  title: T\n  codeInit: |\n    count = 0\n  blocks:\n"
            "    - id: b0\n      title: B0\n      items:\n        - id: q_pick\n          kind: Question\n"
            "          title: Pick\n          input: {control: Checkbox, labels: {1: A, 2: B, 4: C}}\n"
            f"    - id: b1\n      title: B1\n{block}      items:\n"
            + member.format(id="g1") + member.format(id="g2")
            + "    - id: b2\n      title: B2\n      items:\n        - id: r\n          kind: Question\n"
            f"          title: R\n          postcondition:\n            - predicate: \"{post}\"\n"
            "          input: {control: Radio, labels: {1: OK}}\n"
        )
        return StaticBuilder(QMLState(QMLLoader().load_from_string(qml)))

    def test_a_capped_group_member_runs_only_when_drawn(self):
        """``count: 1`` draws one of the two writers, so the counter ends at 1;
        modelled as both always running, ``count == 1`` was refused."""
        builder = self._scoped_counter("      kind: Group\n      count: 1\n", "count == 1")
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")

    def test_a_roster_member_runs_once_per_iteration(self):
        """Three picked bits run each writer three times; one SSA version
        cannot hold that, so the counter is left free."""
        builder = self._scoped_counter(
            "      kind: Roster\n      iterateOver: \"q_pick.outcome\"\n      labels: {1: A, 2: B, 4: C}\n",
            "count == 6",
        )
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")


@pytest.mark.unit
@pytest.mark.z3
class TestStringLiteralOperandsDoNotLower(unittest.TestCase):
    """#2048: a string literal is an Int in the model only for equality (its
    hash). As an arithmetic or bitwise operand Python raises (``"a" - 1``) or
    builds a string (``"a" * 2``), never the hash's number, so the codeBlock
    must not be modelled as assigning one and a later check on the old value
    is not refused as INFEASIBLE; nor does a string order by its hash. A
    predicate left unlowered that way is a ``Str`` coverage gap, not silent."""

    @staticmethod
    def _after(code: str) -> str:
        state = create_questionnaire(
            [
                {"id": "q", "input": {"control": "Radio", "labels": {1: "A"}}, "codeBlock": code},
                {"id": "r", "postcondition": [{"predicate": "x == 5"}],
                 "input": {"control": "Radio", "labels": {1: "OK"}}},
            ],
            code_init="x = 5",
        )
        return _invariant(StaticBuilder(state), "r")

    def test_arithmetic_and_bitwise_operands_are_not_lowered(self):
        for code in ('x = "a" - 1', 'x = "a" & 0', 'x = "a" + 1', 'x = 1 - "a"', 'x = "a" * 2',
                     'x = "a" // 2', 'x = "a" % 2', 'x = -"a"', 'x -= "a"', 'x &= "a"'):
            with self.subTest(code=code):
                self.assertNotEqual(self._after(code), "INFEASIBLE")

    def test_an_int_assignment_is_still_decided(self):
        self.assertEqual(self._after("x = 1"), "INFEASIBLE")
        self.assertEqual(self._after("x = 2 + 3"), "TAUTOLOGICAL")

    def test_a_string_literal_never_orders_by_its_hash(self):
        builder = StaticBuilder(create_questionnaire(
            [{"id": "q", "input": {"control": "Radio", "labels": {1: "A"}}},
             {"id": "r", "input": {"control": "Radio", "labels": {1: "OK"}}}],
        ))
        for predicate in ('"a" < q.outcome', 'q.outcome >= "a"', '"a" < "b"'):
            with self.subTest(predicate=predicate):
                self.assertFalse(_exact(builder, predicate, owner="r"))

    def test_a_predicate_left_unlowered_by_a_string_operand_is_a_gap(self):
        state = create_questionnaire(
            [{"id": "q", "input": {"control": "Radio", "labels": {1: "A"}}},
             {"id": "r", "precondition": [{"predicate": 'q.outcome >= "a"'}],
              "input": {"control": "Radio", "labels": {1: "OK"}}}],
        )
        gaps = StaticBuilder(state).coverage_gaps.get("r", [])
        self.assertEqual([g["unsupported_nodes"] for g in gaps], [["Str"]])
        issues = ValidationProcessor(state).to_issues()
        skipped = [i for i in issues if i["type"] == "skipped_condition" and i["item_id"] == "r"]
        self.assertEqual(len(skipped), 1)
        self.assertIn("string literal", skipped[0]["suggestion"])

    def test_string_equality_in_a_predicate_keeps_its_lowering(self):
        builder = StaticBuilder(create_questionnaire(
            [{"id": "q", "input": {"control": "Radio", "labels": {1: "A"}}},
             {"id": "r", "precondition": [{"predicate": 'tag == "a"'}],
              "input": {"control": "Radio", "labels": {1: "OK"}}}],
            code_init='tag = "a"',
        ))
        self.assertTrue(_exact(builder, 'tag == "a"', owner="r"))


@pytest.mark.unit
@pytest.mark.z3
class TestBitAndLowers(unittest.TestCase):
    """#2037: ``x & K`` for a non-negative literal ``K`` lowers exactly as the
    sum of K's bits, so the Checkbox mask idiom is verified, not skipped."""

    @staticmethod
    def _checkbox_gated(predicate: str) -> StaticBuilder:
        return StaticBuilder(
            create_questionnaire(
                [
                    {"id": "q_a", "input": {"control": "Checkbox", "labels": {1: "A", 2: "B", 4: "C"}}},
                    {"id": "q_c", "precondition": [{"predicate": predicate}],
                     "input": {"control": "Editbox", "min": 0, "max": 99}},
                ]
            )
        )

    def test_a_mask_test_on_a_declared_bit_is_exact_and_conditional(self):
        builder = self._checkbox_gated("q_a.outcome & 2 > 0")

        self.assertTrue(_exact(builder, "q_a.outcome & 2 > 0"))
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_a_mask_test_on_an_undeclared_bit_is_never(self):
        self.assertEqual(_status(self._checkbox_gated("q_a.outcome & 8 > 0")), "NEVER")

    def test_a_multi_bit_mask_and_a_literal_on_the_left(self):
        left = self._checkbox_gated("(5 & q_a.outcome) == 5")
        self.assertTrue(_exact(left, "(5 & q_a.outcome) == 5"))
        self.assertEqual(_status(left), "CONDITIONAL")
        self.assertEqual(_status(self._checkbox_gated("(8 & q_a.outcome) > 0")), "NEVER")
        self.assertEqual(_status(self._checkbox_gated("q_a.outcome & 3 > 3")), "NEVER")

    def test_the_lowering_agrees_with_python_on_negative_values(self):
        """Python's ``&`` reads two's complement; Z3's div/mod by a positive
        literal floor the same way, so each term reads the same bit."""
        ctx = self._checkbox_gated("q_a.outcome & 2 > 0").ctx
        for x in (-7, -1, 0, 5, 13):
            for k in (0, 1, 6, 13):
                node = ast.parse(f"{x} & {k}", mode="eval").body
                lowered = StaticBuilder._lower_bit_and(node, IntVal(x, ctx), IntVal(k, ctx))
                with self.subTest(x=x, k=k):
                    self.assertEqual(simplify(lowered).as_long(), x & k)

    def test_an_augmented_mask_assignment_lowers(self):
        """``x &= K`` in a codeBlock lowers by the same rule, so a check on
        what it leaves is decided."""
        state = create_questionnaire(
            [
                {"id": "q", "input": {"control": "Radio", "labels": {1: "A"}}, "codeBlock": "x &= 4"},
                {"id": "r", "postcondition": [{"predicate": "x == 4"}], "input": {"control": "Radio", "labels": {1: "OK"}}},
            ],
            code_init="x = 6",
        )
        self.assertEqual(_invariant(StaticBuilder(state), "r"), "TAUTOLOGICAL")

    def test_an_and_of_two_variables_or_a_negative_mask_does_not_lower(self):
        for predicate in ("q_a.outcome & q_a.outcome > 0", "q_a.outcome & -2 > 0"):
            with self.subTest(predicate=predicate):
                self.assertFalse(_exact(self._checkbox_gated(predicate), predicate))


def _textarea_writer(code: str, post: str, *, gate: str | None = None) -> StaticBuilder:
    """#2003: Textarea ``t`` with codeBlock *code* (and *gate*, if any), then
    Radio ``r`` checking *post*; codeInit ``x = 0``."""
    t = {"id": "t", "input": {"control": "Textarea"}, "codeBlock": code}
    if gate:
        t["precondition"] = [{"predicate": gate}]
    items = [{"id": "q", "input": _NEVER_BLANK_RADIO}, t,
             {"id": "r", "postcondition": [{"predicate": post}], "input": {"control": "Radio", "labels": {1: "OK"}}}]
    return StaticBuilder(create_questionnaire(items, code_init="x = 0"))


@pytest.mark.unit
@pytest.mark.z3
class TestSkippedItemCodeBlocksAreLowered(unittest.TestCase):
    """#2003: the runtime runs a Textarea's codeBlock, so the build lowers it.
    Before, the build skipped every item with no outcome model: ``x`` kept
    codeInit's 0, ``r``'s ``x == 1`` was INFEASIBLE (publish refused) and the
    graph had no ``t -> r`` edge."""

    def test_a_check_on_what_a_textarea_sets_is_not_refused(self):
        builder = _textarea_writer("x = 1", "x == 1")

        self.assertEqual(_invariant(builder, "r"), "TAUTOLOGICAL")
        self.assertEqual(builder.version_history["x"], [(0, "__init__"), (1, "t")])

    def test_the_reader_depends_on_the_textarea(self):
        builder = _textarea_writer("x = 1", "x == 1")

        self.assertEqual(builder.get_item_dependencies()["r"], {"t"})

    def test_a_gated_textarea_may_not_run_its_codeblock(self):
        """Skipped by its gate, t runs nothing and x stays 0, so neither value
        is certain (no refusal moves from accept to refuse, #1994's class)."""
        self.assertEqual(_invariant(_textarea_writer("x = 1", "x == 1", gate="q.outcome == 1"), "r"), "CONSTRAINING")
        self.assertEqual(_invariant(_textarea_writer("x = 1", "x == 0", gate="q.outcome == 1"), "r"), "CONSTRAINING")

    def test_the_textareas_own_text_is_opaque(self):
        """``t.outcome`` is free text: what the codeBlock computes from it is
        unconstrained, never a stand-in constant."""
        builder = _textarea_writer("x = t.outcome", "x == 0")

        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")
        self.assertEqual(_invariant(_textarea_writer("if t.outcome:\n    x = 1", "x == 1"), "r"), "CONSTRAINING")

    def test_a_blank_textarea_may_stop_its_codeblock(self):
        """Submitted blank, ``len(t.outcome)`` raises on ``None``: the runtime
        keeps what ran before and skips ``x = 1``, so x stays 0 and ``x == 0``
        holds. The write is a possibility, not a certainty: CONSTRAINING."""
        code = "n = len(t.outcome)\nx = 1"
        builder = _textarea_writer(code, "x == 0")
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")

        state = builder.state
        self.assertEqual(walk_and_answer(FlowProcessor(state), state, {"q": 1, "t": None, "r": 1}), ["q", "t", "r"])
        self.assertEqual(state.tail_state()["vars"]["x"], 0)

    def test_another_textareas_text_is_opaque_in_a_codeblock(self):
        """``b``'s codeBlock writes ``r.outcome = 1 if a.outcome else 2``; with
        ``a`` answered the runtime writes 1, r's only label. ``a``'s text is
        not a stand-in 0 there, which would force 2 and leave no world."""
        items = [
            {"id": "a", "input": {"control": "Textarea"}},
            {"id": "b", "input": {"control": "Textarea"}, "codeBlock": "r.outcome = 1 if a.outcome else 2"},
            {"id": "r", "input": {"control": "Radio", "labels": {1: "OK"}}},
        ]
        builder = StaticBuilder(create_questionnaire(items))
        self.assertTrue(_sat(builder.get_full_base()))

        state = builder.state
        self.assertEqual(walk_and_answer(FlowProcessor(state), state, {"a": "hello", "b": "x"}), ["a", "b"])
        self.assertEqual(state.get_item("r")["outcome"], 1)


def _never_blank_q_a(predicate: str, kind: str = "precondition") -> StaticBuilder:
    """``_answer_gated`` with ``q_a`` refusing a blank answer, so a gate its
    test settles is decided by that test alone (#1784)."""
    return StaticBuilder(
        create_questionnaire(
            [
                {
                    "id": "q_a",
                    "postcondition": [{"predicate": "q_a.outcome is not None"}],
                    "input": {"control": "Radio", "labels": {1: "A", 2: "B"}},
                },
                {
                    "id": "q_b",
                    "precondition": [{"predicate": "q_a.outcome == 1"}],
                    "input": {"control": "Editbox", "min": 0, "max": 99},
                },
                {"id": "q_c", kind: [{"predicate": predicate}], "input": {"control": "Editbox", "min": 0, "max": 99}},
            ]
        )
    )


@pytest.mark.unit
@pytest.mark.z3
class TestARaiseIsLoweredTwoSided(unittest.TestCase):
    """#1779: each predicate node lowers to whether it holds and whether it
    raises, combined the way Python short-circuits, and the condition kind
    applies once at the root (a raise fails a precondition, waives a
    postcondition). A raise under ``not``, in an earlier ``or`` operand or in
    a postcondition is exact, and a raise evaluation never reaches raises
    nothing. Each verdict here was wide (or wrong-direction refused) before.
    """

    def test_a_raise_under_not_fails_the_gate(self):
        """``not None >= 0`` raises, so the gate fails for a skipped q_b as for
        an answered one: NEVER, and exact."""
        builder = _answer_gated("not q_b.outcome >= 0")
        self.assertEqual(_status(builder), "NEVER")
        self.assertTrue(_exact(builder, "not q_b.outcome >= 0"))

    def test_a_raise_in_an_earlier_or_operand_fails_the_gate(self):
        """``None > 200`` raises before ``not q_b.outcome`` (True on a skip)
        is reached; an answered q_b (1-99) fails both operands: NEVER."""
        predicate = "q_b.outcome > 200 or not q_b.outcome"
        builder = _answer_gated(predicate, q_b_input={"control": "Editbox", "min": 1, "max": 99})
        self.assertEqual(_status(builder), "NEVER")
        self.assertTrue(_exact(builder, predicate))

    def test_a_raise_in_a_postcondition_is_exact(self):
        """``not None > 1`` raises and waives the check: CONSTRAINING, no
        longer widened at the root."""
        builder = _answer_gated("not q_b.outcome > 1", kind="postcondition")
        self.assertEqual(_invariant(builder), "CONSTRAINING")
        self.assertTrue(_exact(builder, "not q_b.outcome > 1", kind="postcondition"))

    def test_a_postcondition_raise_after_a_false_and_operand_is_never_reached(self):
        """``q_c.outcome == 200`` is False for every answer (and for q_c's own
        blank), so ``and`` stops there and q_b's raise cannot waive the check:
        INFEASIBLE."""
        builder = _answer_gated("q_c.outcome == 200 and q_b.outcome > 1", kind="postcondition")
        self.assertEqual(_invariant(builder), "INFEASIBLE")

    def test_a_postcondition_raise_after_a_true_or_operand_is_never_reached(self):
        """``q_c.outcome != 200`` holds for every answer and for q_c's own
        blank, so ``or`` stops before q_b's raise: TAUTOLOGICAL."""
        predicate = "q_c.outcome != 200 or q_b.outcome > 1"
        builder = _answer_gated(predicate, kind="postcondition")
        self.assertEqual(_invariant(builder), "TAUTOLOGICAL")
        self.assertTrue(_exact(builder, predicate, kind="postcondition"))

    def test_a_precondition_raise_after_a_true_or_operand_is_never_reached(self):
        """``q_a.outcome != 9`` holds for every answer q_a (never blank) can
        hold, so ``not q_b.outcome > 1`` is never evaluated: ALWAYS."""
        predicate = "q_a.outcome != 9 or not q_b.outcome > 1"
        builder = _never_blank_q_a(predicate)
        self.assertEqual(_status(builder), "ALWAYS")
        self.assertTrue(_exact(builder, predicate))

    def test_a_raise_after_an_unknown_operand_is_unknown_not_fatal(self):
        """At runtime a part reached only after an undecided one does not
        raise (``FlowProcessor._evaluate_three_valued``): with q_a left blank,
        ``None > 1`` on a skipped q_b is undecided, and the False third operand
        still settles ``and`` False, so the gate under ``not`` holds."""
        for predicate in (
            "not (q_a.outcome == 1 and q_b.outcome > 1 and False)",
            # Nested: the inner ``and`` would raise on its own, but reached
            # after the unknown it is evaluated leniently and settles False.
            "not (q_a.outcome == 1 and (q_b.outcome > 1 and False))",
        ):
            with self.subTest(predicate=predicate):
                builder = _answer_gated(predicate)
                gate, exact = builder.compile_conditions_exactly(
                    "q_c", [{"predicate": predicate}], kind="precondition"
                )
                self.assertTrue(exact)
                solver = Solver(ctx=builder.ctx)
                # q_b skipped, not blank: its leaf raises rather than being unknown.
                skipped_b = And(Bool("skipped@q_b", builder.ctx), Not(Bool("blank@q_b", builder.ctx)))
                solver.add(gate, Bool("blank@q_a", builder.ctx), skipped_b)
                self.assertEqual(solver.check(), sat)

    def test_an_unknown_operand_lets_a_later_raise_through_as_unknown(self):
        """``q_a.outcome == 1 and None > 1`` with q_a blank is unknown, not a
        raise (and likewise ``or``), so the enclosing ``or`` goes on to ``not
        q_b.outcome``, True on the skip: the gate holds there."""
        for predicate in (
            "(q_a.outcome == 1 and q_b.outcome > 1) or not q_b.outcome",
            "(q_a.outcome == 1 or q_b.outcome > 1) or not q_b.outcome",
        ):
            with self.subTest(predicate=predicate):
                builder = _answer_gated(predicate)
                gate, exact = builder.compile_conditions_exactly(
                    "q_c", [{"predicate": predicate}], kind="precondition"
                )
                self.assertTrue(exact)
                solver = Solver(ctx=builder.ctx)
                skipped_b = And(Bool("skipped@q_b", builder.ctx), Not(Bool("blank@q_b", builder.ctx)))
                solver.add(gate, Bool("blank@q_a", builder.ctx), skipped_b)
                self.assertEqual(solver.check(), sat)

    def test_a_raise_propagates_through_a_nested_operand(self):
        """A raise inside an operand ends its enclosing junction too, and only
        where Python reaches it: through ``not`` (``not None < 200`` raises
        before ``not q_b.outcome`` could hold), and not past a settled inner
        ``and`` / ``or`` (``False and …``, ``True or …``), after which a
        skipped q_b (1-99) holds ``not q_b.outcome``."""
        q_b = {"control": "Editbox", "min": 1, "max": 99}
        for predicate, status in (
            ("(not q_b.outcome < 200) or not q_b.outcome", "NEVER"),
            ("(False and q_b.outcome > 1) or not q_b.outcome", "CONDITIONAL"),
            ("(True or q_b.outcome > 1) and not q_b.outcome", "CONDITIONAL"),
        ):
            with self.subTest(predicate=predicate):
                builder = _answer_gated(predicate, q_b_input=q_b)
                self.assertEqual(_status(builder), status)
                self.assertTrue(_exact(builder, predicate))

    def test_a_raise_the_model_cannot_place_is_unknown_after_an_unknown_operand(self):
        """A raise inside ``any([...])`` cannot be placed and lowers as False
        on the skip, which holds only where a raise is fatal. Reached after an
        unknown operand (q_a left blank) the runtime reads it as unknown, so
        ``or`` goes on (``q_b.outcome > 1`` unknown too) to ``True``, and a
        skipped q_b (1-99) holds ``not q_b.outcome``: the gate is reachable.
        The leaf is the whole call or ternary even when an ``and`` / ``not``
        sits inside it (the runtime splits only the top-level junctions)."""
        for inner in (
            "any([q_b.outcome > 1])",
            "any([q_b.outcome > 1 and True])",
            "any([True and q_b.outcome > 1])",
            "any([not (q_b.outcome > 1)])",
            "((q_b.outcome > 1 and True) if q_a.outcome == 2 else False)",
        ):
            predicate = f"((q_a.outcome == 1 and {inner}) or q_b.outcome > 1 or True) and not q_b.outcome"
            with self.subTest(predicate=predicate):
                builder = _answer_gated(predicate, q_b_input={"control": "Editbox", "min": 1, "max": 99})
                self.assertEqual(_status(builder), "CONDITIONAL")
                gate, exact = builder.compile_conditions_exactly(
                    "q_c", [{"predicate": predicate}], kind="precondition"
                )
                self.assertFalse(exact)
                solver = Solver(ctx=builder.ctx)
                skipped_b = And(Bool("skipped@q_b", builder.ctx), Not(Bool("blank@q_b", builder.ctx)))
                solver.add(builder.get_reachability_base(), gate, Bool("blank@q_a", builder.ctx), skipped_b)
                self.assertEqual(solver.check(), sat)

    def test_a_chained_comparison_raises_only_on_the_clause_it_reaches(self):
        """``1 == None < 5`` stops at ``1 == None`` (False) and raises nothing,
        so under ``not`` a skipped q_b holds the gate; ``0 <= None`` raises at
        the first clause and fails it: NEVER."""
        predicate = "not (1 == q_b.outcome < 5)"
        builder = _answer_gated(predicate)
        gate, exact = builder.compile_conditions_exactly("q_c", [{"predicate": predicate}], kind="precondition")
        self.assertTrue(exact)
        solver = Solver(ctx=builder.ctx)
        # q_b's value pinned to 1: only ``1 == None`` being False (a skipped
        # q_b equals nothing) keeps the ``<`` clause from being reached.
        solver.add(
            gate,
            Bool("skipped@q_b", builder.ctx),
            Not(Bool("blank@q_b", builder.ctx)),
            builder.item_vars["q_b"] == 1,
        )
        self.assertEqual(solver.check(), sat)
        raises = _answer_gated("not (0 <= q_b.outcome <= 99)")
        self.assertEqual(_status(raises), "NEVER")
        self.assertTrue(_exact(raises, "not (0 <= q_b.outcome <= 99)"))


@pytest.mark.unit
@pytest.mark.z3
class TestRangeLeavesTheBoundRestatingLint(unittest.TestCase):
    """A Range answer is a pair (#1474): ``q.outcome >= min`` compares a list
    with a number, so the lint that recognises a postcondition restating the
    control's own bounds does not apply to Range. A postcondition on a Range
    still gates the answer; only the lint's verdict changes."""

    def test_a_slider_restating_its_bounds_is_still_flagged(self):
        self.assertEqual(
            _duplicate_bound_flags("Slider", "q.outcome >= 0 and q.outcome <= 10"), [True]
        )

    def test_a_range_scalar_bound_predicate_is_not_flagged(self):
        self.assertEqual(
            _duplicate_bound_flags("Range", "q.outcome >= 0 and q.outcome <= 10"), [False]
        )

    def test_a_range_end_postcondition_is_not_flagged(self):
        self.assertEqual(_duplicate_bound_flags("Range", "q.outcome.low >= 0"), [False])


def _range_builder(items: list, code_init: str = "") -> StaticBuilder:
    """A builder over *items*, with ``q`` a Range Question on 0–4 unless overridden."""
    return StaticBuilder(create_questionnaire(items, code_init=code_init))


def _reachability(builder: StaticBuilder) -> dict[str, str]:
    """Each item's precondition status from the classifier."""
    return {
        item_id: result["precondition"]["status"]
        for item_id, result in ItemClassifier(builder).classify_all_items().items()
        if "precondition" in result
    }


_RANGE_0_4 = {"id": "q", "input": {"control": "Range", "min": 0, "max": 4}}


@pytest.mark.unit
@pytest.mark.z3
class TestRangePairModel(unittest.TestCase):
    """A Range answer is a ``[low, high]`` pair (#1474), so the static model
    holds a Range Question as two variables bound by ``min <= lo <= hi <= max``
    and proves conditions that read ``outcome.low`` / ``outcome.high`` over them.
    A Range read the model cannot represent is a coverage gap, never a drop."""

    def test_a_range_question_holds_two_ends_and_no_scalar(self):
        builder = _range_builder([_RANGE_0_4])

        self.assertNotIn("q", builder.item_vars)
        lo, hi = builder.item_pairs["q"]
        self.assertEqual((str(lo), str(hi)), ("item_q@lo", "item_q@hi"))
        domain = builder.get_domain_base()
        for escape in (lo < 0, hi > 4, lo > hi):
            s = Solver(ctx=builder.ctx)
            s.add(domain, escape)
            self.assertEqual(s.check(), unsat, str(escape))
        self.assertIn("item_q@lo", builder.get_all_z3_vars())
        self.assertIn("item_q@hi", builder.get_all_z3_vars())

    def test_end_reads_are_proven(self):
        """AE3: with ``max: 4`` a gate needing ``high >= 5`` or ``low > high``
        is NEVER, and ``low <= 2`` is SOMETIMES."""
        builder = _range_builder(
            [
                _RANGE_0_4,
                {"id": "a", "precondition": [{"predicate": "q.outcome.high >= 5"}]},
                {"id": "b", "precondition": [{"predicate": "q.outcome.low > q.outcome.high"}]},
                {"id": "c", "precondition": [{"predicate": "q.outcome.low <= 2"}]},
            ]
        )

        status = _reachability(builder)
        self.assertEqual((status["a"], status["b"], status["c"]), ("NEVER", "NEVER", "CONDITIONAL"))
        self.assertEqual(builder.coverage_gaps, {})

    def test_a_span_wider_than_the_scale_is_infeasible(self):
        state = create_questionnaire(
            [
                {
                    "id": "q",
                    "input": {"control": "Range", "min": 0, "max": 10},
                    "postcondition": [{"predicate": "q.outcome.high - q.outcome.low >= 20"}],
                }
            ]
        )
        result = ItemClassifier(StaticBuilder(state)).classify_all_items()["q"]

        self.assertEqual(result["postcondition"]["invariant"], "INFEASIBLE")
        issues = ValidationProcessor(state).to_issues()
        self.assertIn(("q", "infeasible_postcondition"), {(i["item_id"], i["type"]) for i in issues})

    def test_unrepresentable_range_reads_are_coverage_gaps(self):
        """R7: a bare Range outcome compared as a number and any QuestionGroup
        Range read have no variable to lower to; each is a recorded gap that
        names the Range item, and the issue says why."""
        group = {
            "id": "qg",
            "kind": "QuestionGroup",
            "questions": ["A", "B"],
            "input": {"control": "Range", "min": 0, "max": 4},
        }
        for predicate, range_item in (
            ("q.outcome >= 3", "q"),
            ("qg.outcome[0][1] > 2", "qg"),
            ("q.outcome[2] > 1", "q"),
            ("q.outcome[0] > 1", "q"),
            ("q.outcome[1] <= 2", "q"),
        ):
            with self.subTest(predicate=predicate):
                state = create_questionnaire(
                    [_RANGE_0_4, group, {"id": "r", "precondition": [{"predicate": predicate}]}]
                )
                builder = StaticBuilder(state)

                gaps = builder.coverage_gaps.get("r") or []
                self.assertEqual([g["range_items"] for g in gaps], [[range_item]])
                self.assertNotEqual(_reachability(builder)["r"], "NEVER")
                skipped = [
                    i for i in ValidationProcessor(state).to_issues()
                    if i["type"] == "skipped_condition" and i["item_id"] == "r"
                ]
                self.assertEqual(len(skipped), 1)
                self.assertIn(f"Range answer of '{range_item}'", skipped[0]["message"])

    def test_the_witness_lists_both_ends(self):
        from askalot_qml.z3.global_formula import GlobalFormula

        builder = _range_builder(
            [
                {
                    "id": "q",
                    "input": {"control": "Range", "min": 0, "max": 4},
                    "postcondition": [{"predicate": "q.outcome.high - q.outcome.low >= 3"}],
                }
            ]
        )
        result = GlobalFormula(builder).check()

        self.assertTrue(result.satisfiable)
        low, high = result.witness["q.outcome"]
        self.assertTrue(0 <= low <= high <= 4 and high - low >= 3, (low, high))

    def test_range_items_keep_their_conditions_and_code_blocks(self):
        """A Range Question and a Range QuestionGroup hold no scalar variable,
        yet their contradicting preconditions are still reported and the
        variables their codeBlocks set still reach the items that read them."""
        state = create_questionnaire(
            [
                {"id": "q_age", "input": {"control": "Editbox", "min": 0, "max": 120}},
                {
                    "id": "q_span",
                    "input": {"control": "Range", "min": 0, "max": 10},
                    "precondition": [{"predicate": "q_age.outcome > 200"}],
                    "codeBlock": "flag = 1",
                },
                {
                    "id": "qg",
                    "kind": "QuestionGroup",
                    "questions": ["A", "B"],
                    "input": {"control": "Range", "min": 0, "max": 10},
                    "precondition": [{"predicate": "q_age.outcome < 0"}],
                    "codeBlock": "group_flag = 1",
                },
                {"id": "q_later", "precondition": [{"predicate": "flag == 1"}]},
                {"id": "q_after_group", "precondition": [{"predicate": "group_flag == 1"}]},
            ],
            code_init="flag = 0\ngroup_flag = 0",
        )
        builder = StaticBuilder(state)

        self.assertNotIn("q_span", builder.item_vars)
        self.assertNotIn("qg", builder.item_vars)
        status = _reachability(builder)
        self.assertEqual((status["q_span"], status["qg"]), ("NEVER", "NEVER"))
        self.assertEqual(status["q_later"], "CONDITIONAL")
        self.assertEqual(status["q_after_group"], "CONDITIONAL")
        deps = builder.get_item_dependencies()
        self.assertIn("q_span", deps["q_later"])
        self.assertIn("qg", deps["q_after_group"])
        self.assertIn("q_age", deps["q_span"])

    def test_a_capped_group_range_item_binds_its_own_pair(self):
        state = QMLState(
            {
                "title": "Capped",
                "blocks": [{"id": "g", "title": "G", "kind": "Group", "count": 1}],
                "items": [
                    {
                        "id": "q_span",
                        "blockId": "g",
                        "_group_block_id": "g",
                        "_group_count": 1,
                        "kind": "Question",
                        "title": "Span",
                        "input": {"control": "Range", "min": 0, "max": 4},
                        "postcondition": [{"predicate": "q_span.outcome.high >= 5"}],
                    }
                ],
            }
        )
        builder = StaticBuilder(state)

        present = builder._present_var("q_span", 0)
        gated = [
            c
            for c in builder.constraints + builder.domain_constraints
            if "item_q_span@group0" in str(c)
        ]
        self.assertTrue(gated)
        s = Solver(ctx=builder.ctx)
        s.add(present, *gated)
        self.assertEqual(s.check(), unsat)
        self.assertTrue(any("item_q_span@group0@hi" in str(c) for c in gated))

    def test_a_range_end_never_aliases_an_item_named_after_it(self):
        """Item ids are Python identifiers and can end in ``_lo``: a Range
        ``q`` beside an independent Question ``q_lo`` must keep two symbols,
        so ``q.outcome.low == q_lo.outcome`` is no tautology."""
        state = create_questionnaire(
            [
                _RANGE_0_4,
                {"id": "q_lo", "input": {"control": "Editbox", "min": 0, "max": 4}},
                {
                    "id": "r",
                    "postcondition": [{"predicate": "q.outcome.low == q_lo.outcome"}],
                },
            ]
        )
        builder = StaticBuilder(state)

        lo, _ = builder.item_pairs["q"]
        self.assertFalse(lo.eq(builder.item_vars["q_lo"]))
        self.assertNotEqual(str(lo), str(builder.item_vars["q_lo"]))
        result = ItemClassifier(builder).classify_all_items()["r"]
        self.assertNotEqual(result["postcondition"]["invariant"], "TAUTOLOGICAL")

    def test_a_code_block_pair_literal_binds_both_ends(self):
        """A codeBlock writing ``q.outcome = [1, 1]`` fixes both ends, so a
        later postcondition needing ``low != 1`` can never hold. It is
        CONSTRAINING, not INFEASIBLE: ``q`` is a Question a codeBlock writes,
        so each predicate may read it blank (#1784), which waives the check."""
        state = create_questionnaire(
            [
                _RANGE_0_4,
                {
                    "id": "w",
                    "input": {"control": "Editbox", "min": 0, "max": 4},
                    "codeBlock": "q.outcome = [1, 1]",
                },
                {"id": "r", "postcondition": [{"predicate": "q.outcome.low != 1"}]},
            ]
        )
        builder = StaticBuilder(state)

        result = ItemClassifier(builder).classify_all_items()["r"]
        self.assertEqual(result["postcondition"]["invariant"], "CONSTRAINING")
        holds = builder.compile_postcondition_truth("r", builder.item_details["r"]["postconditions"])
        solver = Solver(ctx=builder.ctx)
        solver.add(builder.get_full_base(), holds)
        self.assertEqual(solver.check(), unsat)

    def test_an_unlowerable_range_code_block_write_is_a_coverage_gap(self):
        """A Range write the model cannot lower (here a non-literal RHS) is a
        coverage gap naming the Range item, never a silent drop."""
        state = create_questionnaire(
            [
                _RANGE_0_4,
                {
                    "id": "w",
                    "input": {"control": "Editbox", "min": 0, "max": 4},
                    "codeBlock": "q.outcome = some_var",
                },
            ],
            code_init="some_var = 0",
        )
        builder = StaticBuilder(state)

        gaps = builder.coverage_gaps.get("w") or []
        self.assertEqual([g.get("range_items") for g in gaps], [["q"]])
        skipped = [
            i for i in ValidationProcessor(state).to_issues()
            if i["type"] == "skipped_condition" and i["item_id"] == "w"
        ]
        self.assertEqual(len(skipped), 1)
        self.assertIn("Range answer of 'q'", skipped[0]["message"])


_RANGE_MATRIX_0_4 = {
    "id": "m",
    "kind": "MatrixQuestion",
    "rows": ["R1", "R2"],
    "columns": ["C1", "C2"],
    "input": {"control": "Range", "min": 0, "max": 4},
}


_RADIO_1_3 = {"control": "Radio", "labels": {1: "A", 2: "B", 3: "C"}}


def _group_gated(
    predicate: str,
    *,
    group_input: dict | None = None,
    gated: bool = False,
    kind: str = "precondition",
    owner: str = "q_c",
    questions: int = 3,
    code_init: str = "",
    group_code: str = "",
    group_post: str | None = None,
) -> StaticBuilder:
    """``q_a`` (Radio 1/2), a QuestionGroup ``qg`` of *questions* answers
    (Radio 1–3 unless *group_input*; asked only when ``q_a == 1`` when
    *gated*; *group_post* as its own postcondition), and ``q_c``.
    *predicate* is the *kind* condition of *owner* (``q_c``, or ``qg``
    itself)."""
    condition = {kind: [{"predicate": predicate}]}
    return StaticBuilder(
        create_questionnaire(
            [
                {"id": "q_a", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                {
                    "id": "qg",
                    "kind": "QuestionGroup",
                    "questions": [f"Q{i}" for i in range(questions)],
                    "input": group_input or _RADIO_1_3,
                    **({"precondition": [{"predicate": "q_a.outcome == 1"}]} if gated else {}),
                    **({"codeBlock": group_code} if group_code else {}),
                    **(condition if owner == "qg" else {}),
                    **({"postcondition": [{"predicate": group_post}]} if group_post else {}),
                },
                {
                    "id": "q_c",
                    "input": {"control": "Editbox", "min": 0, "max": 99},
                    **(condition if owner == "q_c" else {}),
                },
            ],
            code_init=code_init,
        )
    )


def _group_gap_items(builder: StaticBuilder, item_id: str = "q_c") -> list[list[str]]:
    return [gap.get("group_items", []) for gap in builder.coverage_gaps.get(item_id, [])]


@pytest.mark.unit
@pytest.mark.z3
class TestQuestionGroupAnswers(unittest.TestCase):
    """#184: a QuestionGroup's answer is a list, one entry per question, so
    the model holds one variable per answer (a pair for Range) and no scalar,
    and ``qg.outcome[i]`` in a condition is proven. The list is ``None`` until
    the group is answered (skipped, or shown and left blank, see
    ``TestQuestionGroupBlank``) and an answered group pads unanswered slots
    with ``None``; both are modelled, so no verdict claims more than the
    runtime does. Reads the model does not hold are coverage gaps naming the
    group."""

    def test_a_group_holds_one_variable_per_answer_and_no_scalar(self):
        builder = _group_gated("q_a.outcome == 1")

        self.assertNotIn("qg", builder.item_vars)
        cells = builder.item_cells["qg"]
        self.assertEqual({key: str(var) for key, var in cells.items()},
                         {(0,): "item_qg@0", (1,): "item_qg@1", (2,): "item_qg@2"})
        s = Solver(ctx=builder.ctx)
        s.add(builder.get_domain_base(), cells[(1,)] == 4)
        self.assertEqual(s.check(), unsat)

    def test_a_range_group_holds_a_pair_per_answer(self):
        builder = _group_gated(
            "q_a.outcome == 1", group_input={"control": "Range", "min": 0, "max": 4}, questions=2
        )

        cells = builder.item_cells["qg"]
        self.assertEqual(sorted(str(v) for v in cells.values()),
                         ["item_qg@0@hi", "item_qg@0@lo", "item_qg@1@hi", "item_qg@1@lo"])
        domain = builder.get_domain_base()
        for escape in (cells[(1, 0)] < 0, cells[(1, 1)] > 4, cells[(1, 0)] > cells[(1, 1)]):
            s = Solver(ctx=builder.ctx)
            s.add(domain, escape)
            self.assertEqual(s.check(), unsat, str(escape))

    def test_a_group_with_no_questions_holds_no_cells(self):
        builder = _group_gated("q_a.outcome == 1", questions=0)

        self.assertEqual(builder.item_cells["qg"], {})
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_a_cell_never_aliases_an_item_named_after_it(self):
        state = create_questionnaire(
            [
                {"id": "qg", "kind": "QuestionGroup", "questions": ["A"], "input": _RADIO_1_3},
                {"id": "qg_0", "input": {"control": "Editbox", "min": 50, "max": 60}},
                {"id": "q_c", "precondition": [{"predicate": "qg.outcome[0] == 1 and qg_0.outcome == 55"}]},
            ]
        )
        builder = StaticBuilder(state)

        self.assertNotEqual(str(builder.item_cells["qg"][(0,)]), str(builder.item_vars["qg_0"]))
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_the_witness_shows_a_group_as_a_list(self):
        from askalot_qml.z3.global_formula import GlobalFormula

        builder = _group_gated("qg.outcome[1] == 2", kind="postcondition", owner="qg")
        result = GlobalFormula(builder).check()

        self.assertTrue(result.satisfiable)
        answers = result.witness["qg.outcome"]
        self.assertIsInstance(answers, list)
        self.assertEqual(len(answers), 3)
        self.assertIn(answers[1], (2, None))

    def test_a_contradiction_on_one_answer_is_never(self):
        for gated in (False, True):
            with self.subTest(gated=gated):
                builder = _group_gated("qg.outcome[0] == 4", gated=gated)

                self.assertEqual(_status(builder), "NEVER")
                self.assertTrue(_exact(builder, "qg.outcome[0] == 4"))
                self.assertEqual(builder.coverage_gaps, {})

    def test_a_fold_over_the_answers_is_proven(self):
        builder = _group_gated("sum(qg.outcome[i] for i in range(3)) > 9")

        self.assertEqual(_status(builder), "NEVER")
        # A read inside a comprehension may not raise where the comparison
        # does, so the fold lowers wide (#1815), which still proves NEVER.
        self.assertEqual(
            [g for gaps in builder.coverage_gaps.values() for g in gaps if "wide_items" not in g], []
        )

    def test_reads_the_model_does_not_hold_are_gaps_naming_the_group(self):
        """A whole group read as a value and a set of its answers."""
        for predicate in ("qg.outcome == 1", "len(set([qg.outcome[0], qg.outcome[1]])) == 2"):
            with self.subTest(predicate=predicate):
                builder = _group_gated(predicate)

                self.assertEqual(_group_gap_items(builder), [["qg"]])
                self.assertNotEqual(_status(builder), "NEVER")

    def test_a_group_in_a_capped_group_is_a_gap(self):
        state = QMLState(
            {
                "title": "Capped",
                "blocks": [{"id": "b", "title": "B", "kind": "Group", "count": 1}, {"id": "b2", "title": "B2"}],
                "items": [
                    {"id": "qg", "blockId": "b", "_group_block_id": "b", "_group_count": 1,
                     "kind": "QuestionGroup", "title": "G",
                     "questions": ["A", "B"], "input": _RADIO_1_3},
                    {"id": "q_x", "blockId": "b", "_group_block_id": "b", "_group_count": 1,
                     "kind": "Question", "title": "X", "input": _RADIO_1_3},
                    {"id": "q_c", "blockId": "b2", "kind": "Question", "title": "C",
                     "precondition": [{"predicate": "qg.outcome[0] == 4"}]},
                ],
            }
        )
        builder = StaticBuilder(state)

        self.assertEqual(_group_gap_items(builder), [["qg"]])
        self.assertNotEqual(_status(builder), "NEVER")

    def test_a_codeblock_write_to_a_group_is_a_gap(self):
        for code in (
            "qg.outcome[1] = 3",
            "qg.outcome = [1, 2, 3]",
            "qg.outcome = 5",
            "qg.outcome[1] += 1",
            "qg.outcome += [1]",
            "qg.outcome[0], x = 1, 2",
            "for qg.outcome[1] in [1]:\n    pass",
            "qg.outcome[0]: int = 1",
        ):
            with self.subTest(code=code):
                builder = _group_gated("q_a.outcome == 1", group_code=code)

                self.assertEqual(
                    [g["group_items"] for g in builder.coverage_gaps["qg"] if g["kind"] == "codeBlock"],
                    [["qg"]],
                )
                self.assertIn("qg", builder._code_written_items())

    def test_a_group_a_codeblock_writes_is_not_proven(self):
        """A write between two conditions can put any value in a group, so a
        condition that reads a code-written group is a gap, not a proof."""
        builder = _group_gated("qg.outcome[0] == 9", group_code="qg.outcome = [9, 9, 9]")

        self.assertNotEqual(_status(builder), "NEVER")
        self.assertEqual(_group_gap_items(builder), [["qg"]])

    def test_a_codeblock_read_of_a_group_binds_nothing(self):
        """A codeBlock adding answers raises at runtime on an unanswered
        slot and leaves the variable as it was, so it is not proven."""
        builder = _group_gated(
            "score == 0",
            kind="postcondition",
            code_init="score = 0",
            group_code="score = qg.outcome[0] + qg.outcome[1]",
        )

        self.assertNotEqual(_invariant(builder), "INFEASIBLE")

    def test_an_unanswered_or_skipped_group_fails_a_not_equal_gate(self):
        """``!= 9`` holds for every answer and for an unanswered slot, but
        a group that is None (skipped, or shown and left blank) raises."""
        for gated in (False, True):
            with self.subTest(gated=gated):
                builder = _group_gated("qg.outcome[0] != 9", gated=gated)

                self.assertEqual(_status(builder), "CONDITIONAL")
                self.assertTrue(_exact(builder, "qg.outcome[0] != 9"))

    def test_an_ordering_read_raises_on_an_unanswered_slot(self):
        """``None > 0`` raises, so the gate is not ALWAYS; under ``and``
        the lowering stays exact."""
        builder = _group_gated(
            "qg.outcome[0] > 0", group_input={"control": "Editbox", "min": 1, "max": 366}
        )

        self.assertEqual(_status(builder), "CONDITIONAL")
        self.assertTrue(_exact(builder, "qg.outcome[0] > 0 and q_a.outcome == 1"))

    def test_a_postcondition_a_none_slot_waives_is_not_infeasible(self):
        builder = _group_gated(
            "qg.outcome[0] > 400",
            group_input={"control": "Editbox", "min": 0, "max": 366},
            kind="postcondition",
            owner="qg",
        )

        self.assertNotEqual(_invariant(builder, "qg"), "INFEASIBLE")
        self.assertTrue(_exact(builder, "qg.outcome[0] > 400", owner="qg", kind="postcondition"))

    def test_an_unanswered_slot_alone_waives_a_guarded_postcondition(self):
        """The guard rules out a None group; an empty answer in an answered
        group still raises on ``>`` and waives the check."""
        builder = _group_gated(
            "qg.outcome is not None and qg.outcome[0] > 400",
            group_input={"control": "Editbox", "min": 0, "max": 366},
            kind="postcondition",
        )

        self.assertNotEqual(_invariant(builder), "INFEASIBLE")

    def test_a_fold_a_none_slot_waives_is_not_infeasible(self):
        builder = _group_gated(
            "all(qg.outcome[i] > 400 for i in range(3))",
            group_input={"control": "Editbox", "min": 0, "max": 366},
            kind="postcondition",
            owner="qg",
        )

        self.assertNotEqual(_invariant(builder, "qg"), "INFEASIBLE")

    def test_an_answer_read_through_a_ternary_branch_is_a_gap(self):
        """``None`` passes through a ternary into ``!=`` without raising, so the
        branch read is neither None-safe nor certainly raising."""
        builder = _group_gated(
            "(1 if q_a.outcome == 1 else qg.outcome[0]) != 1",
            group_input={"control": "Radio", "labels": {1: "Y"}},
        )

        self.assertNotEqual(_status(builder), "NEVER")
        self.assertEqual(_group_gap_items(builder), [["qg"]])

    def test_a_lowerable_range_end_in_a_dropped_condition_is_no_range_gap(self):
        builder = _group_gated(
            "min(qg.outcome[0].low, 2) > 1", group_input={"control": "Range", "min": 0, "max": 10}
        )

        gaps = builder.coverage_gaps["q_c"]
        self.assertEqual([g.get("range_items") for g in gaps], [None])

    def test_the_witness_shows_a_range_answer_as_a_pair(self):
        from askalot_qml.z3.global_formula import GlobalFormula

        builder = _group_gated(
            "qg.outcome[1].high - qg.outcome[1].low >= 2",
            group_input={"control": "Range", "min": 0, "max": 4},
            kind="postcondition",
            owner="qg",
        )
        answers = GlobalFormula(builder).check().witness["qg.outcome"]

        if answers is not None:
            for answer in answers:
                self.assertTrue(answer is None or (len(answer) == 2 and answer[0] <= answer[1]), answer)

    def test_range_group_ends_are_proven_and_a_none_end_raises(self):
        """``None.low`` raises whatever the operator."""
        rng = {"control": "Range", "min": 0, "max": 10}
        self.assertEqual(_status(_group_gated("qg.outcome[1].low > 10", group_input=rng)), "NEVER")
        self.assertEqual(_status(_group_gated("qg.outcome[1].low != 3", group_input=rng)), "CONDITIONAL")
        builder = _group_gated("qg.outcome[0].low >= 0 and q_a.outcome == 1", group_input=rng)
        self.assertTrue(_exact(builder, "qg.outcome[0].low >= 0 and q_a.outcome == 1"))
        self.assertEqual(builder.coverage_gaps, {})
        gap = _group_gated("qg.outcome[1][0] > 1", group_input=rng)
        self.assertEqual([g.get("range_items") for g in gap.coverage_gaps["q_c"]], [["qg"]])

    def test_a_range_end_read_fails_the_gate_on_an_unanswered_slot(self):
        """``None.low != 11`` raises, so the gate never holds on an
        unanswered slot, though ``!=`` alone would read ``None`` safely."""
        predicate = "qg.outcome is not None and qg.outcome[1].low != 11"
        builder = _group_gated(predicate, group_input={"control": "Range", "min": 0, "max": 10})
        formula, exact = builder.compile_conditions_exactly("q_c", [{"predicate": predicate}], kind="precondition")

        s = Solver(ctx=builder.ctx)
        s.add(builder.get_domain_base(), formula, builder.slot_choice("qg", 1))
        self.assertEqual(s.check(), unsat)
        self.assertTrue(exact)

    def test_a_none_guard_on_a_group_keeps_the_gate_exact(self):
        predicate = "qg.outcome is not None and qg.outcome[0] != 9"
        for gated in (False, True):
            with self.subTest(gated=gated):
                builder = _group_gated(predicate, gated=gated)

                self.assertEqual(_status(builder), "CONDITIONAL")
                self.assertTrue(_exact(builder, predicate))
                self.assertEqual(builder.coverage_gaps, {})

    def test_two_unanswered_slots_compare_as_none(self):
        """``None != 1`` lets two slots differ though the one label forces
        every answer to 1."""
        builder = _group_gated(
            "qg.outcome[0] != qg.outcome[1]", group_input={"control": "Radio", "labels": {1: "Y"}}
        )

        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_a_membership_test_is_none_safe_on_a_slot(self):
        builder = _group_gated("qg.outcome[0] not in [1, 2, 3]")

        self.assertEqual(_status(builder), "CONDITIONAL")
        self.assertTrue(_exact(builder, "qg.outcome[0] not in [1, 2, 3]"))


@pytest.mark.unit
@pytest.mark.z3
class TestQuestionGroupBlank(unittest.TestCase):
    """#1784 (KTD5): a QuestionGroup shown and left blank makes the leaf that
    reads it unknown, like a Question, so an ungated group's blank rides the
    ``blank`` choice. The whole-answer skip choice (a read raises on a
    ``None`` group) stays for a gated group and for the group's own reads in
    its own postcondition, which the runtime evaluates the Python way."""

    def _gate(self, builder: StaticBuilder, predicate: str):
        return builder.compile_conditions("q_c", [{"predicate": predicate}], kind="precondition")

    def test_an_ungated_group_under_an_earlier_or_operand_is_exact(self):
        """A blank ``qg`` makes the first leaf unknown and ``q_a == 1`` still
        settles the ``or``: no raise sits in a non-last operand."""
        predicate = "qg.outcome[0] != 9 or q_a.outcome == 1"
        builder = _group_gated(predicate)
        gate = self._gate(builder, predicate)

        self.assertTrue(_exact(builder, predicate))
        self.assertIsNone(builder.skip_choice("qg"))
        base = builder.get_reachability_base()
        self.assertTrue(_sat(base, Not(gate), builder.blank_choice("qg")))
        self.assertFalse(
            _sat(base, Not(gate), Not(builder.blank_choice("q_a")), builder.item_vars["q_a"] == 1)
        )
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_a_gated_group_still_raises_on_skip(self):
        predicate = "qg.outcome[0] != 9"
        builder = _group_gated(predicate, gated=True)
        gate = self._gate(builder, predicate)

        base = builder.get_reachability_base()
        self.assertFalse(_sat(base, gate, builder.skip_choice("qg")))
        self.assertFalse(_sat(base, gate, builder.blank_choice("qg")))
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_a_none_guard_on_an_ungated_group_carries_its_blank(self):
        """The guard lowers to the blank choice alone, and the gate is exact."""
        predicate = "qg.outcome is not None and qg.outcome[0] != 9"
        builder = _group_gated(predicate)
        gate = self._gate(builder, predicate)

        self.assertTrue(_exact(builder, predicate))
        self.assertIsNone(builder.skip_choice("qg"))
        self.assertFalse(_sat(builder.get_reachability_base(), gate, builder.blank_choice("qg")))
        self.assertTrue(_sat(builder.get_reachability_base(), gate))

    def test_a_group_whose_postcondition_refuses_none_is_never_blank(self):
        """``qg.outcome is not None`` as its own check keeps an ungated
        group answered, so a gate an unanswered slot also passes is ALWAYS."""
        builder = _group_gated("qg.outcome[0] != 9", group_post="qg.outcome is not None")

        self.assertEqual(_status(builder), "ALWAYS")
        self.assertFalse(_sat(builder.get_reachability_base(), builder.blank_choice("qg")))


def _matrix_gated(
    predicate: str,
    *,
    matrix_input: dict | None = None,
    gated: bool = False,
    kind: str = "precondition",
    owner: str = "q_c",
    rows: int = 1,
    cols: int = 1,
    matrix_code: str = "",
) -> StaticBuilder:
    """``q_a`` (Radio 1/2), a MatrixQuestion ``m`` of *rows* x *cols* cells
    (Radio 1–3 unless *matrix_input*; asked only when ``q_a == 1`` when
    *gated*), and ``q_c``. *predicate* is the *kind* condition of *owner*."""
    condition = {kind: [{"predicate": predicate}]}
    return StaticBuilder(
        create_questionnaire(
            [
                {"id": "q_a", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                {
                    "id": "m",
                    "kind": "MatrixQuestion",
                    "rows": [f"R{r}" for r in range(rows)],
                    "columns": [f"C{c}" for c in range(cols)],
                    "input": matrix_input or _RADIO_1_3,
                    **({"precondition": [{"predicate": "q_a.outcome == 1"}]} if gated else {}),
                    **({"codeBlock": matrix_code} if matrix_code else {}),
                    **(condition if owner == "m" else {}),
                },
                {
                    "id": "q_c",
                    "input": {"control": "Editbox", "min": 0, "max": 99},
                    **(condition if owner == "q_c" else {}),
                },
            ]
        )
    )


@pytest.mark.unit
@pytest.mark.z3
class TestGatedMatrixSkip(unittest.TestCase):
    """#1780 / KTD5: a MatrixQuestion reads like a QuestionGroup in a
    condition. A gated matrix is ``None`` when skipped, so a cell read raises
    (a precondition fails); an ungated one left blank makes its leaf unknown;
    an answered matrix may hold a ``None`` cell (``unanswered@m@r@c``), read
    the #1769 way. A scoped or code-written matrix gets no new choice."""

    def _gate(self, builder: StaticBuilder, predicate: str):
        return builder.compile_conditions("q_c", [{"predicate": predicate}], kind="precondition")

    def test_a_gate_on_a_gated_matrix_cell_is_not_always(self):
        """AE8: everyone who never saw ``m`` skips the gate."""
        predicate = "m.outcome[0][0] != 9"
        builder = _matrix_gated(predicate, gated=True)

        self.assertEqual(_status(builder), "CONDITIONAL")
        self.assertTrue(
            _sat(builder.get_reachability_base(), Not(self._gate(builder, predicate)), builder.skip_choice("m"))
        )
        self.assertTrue(_exact(builder, predicate))

    def test_a_blank_cell_of_an_answered_matrix_reads_none(self):
        """``None != 9`` holds, ``None > 2`` raises and fails the gate."""
        builder = _matrix_gated("m.outcome[0][0] != 9", rows=2, cols=2)
        answered = Not(builder.blank_choice("m"))
        none_cell = builder.slot_choice("m", 0, 0)
        base = builder.get_reachability_base()

        self.assertFalse(_sat(base, Not(self._gate(builder, "m.outcome[0][0] != 9")), answered, none_cell))
        ordering = self._gate(builder, "m.outcome[0][0] > 2")
        self.assertFalse(_sat(base, ordering, builder.slot_choice("m", 0, 0)))
        self.assertTrue(_sat(base, ordering, Not(builder.slot_choice("m", 0, 0))))

    def test_an_ungated_matrix_is_none_only_when_blank(self):
        predicate = "m.outcome[0][0] != 9"
        builder = _matrix_gated(predicate)
        gate = self._gate(builder, predicate)

        self.assertIsNone(builder.skip_choice("m"))
        self.assertTrue(_sat(builder.get_reachability_base(), Not(gate), builder.blank_choice("m")))
        self.assertFalse(_sat(builder.get_reachability_base(), Not(gate), Not(builder.blank_choice("m"))))
        self.assertEqual(_status(builder), "CONDITIONAL")
        self.assertTrue(_exact(builder, predicate))

    def test_a_none_guard_on_a_matrix_carries_its_skip_and_blank(self):
        predicate = "m.outcome is not None and m.outcome[0][0] != 9"
        builder = _matrix_gated(predicate, gated=True)
        gate = self._gate(builder, predicate)
        base = builder.get_reachability_base()

        self.assertFalse(_sat(base, gate, builder.skip_choice("m")))
        self.assertFalse(_sat(base, gate, builder.blank_choice("m")))
        self.assertTrue(_exact(builder, predicate))

    def test_a_range_cell_end_raises_on_a_none_cell(self):
        """``None.low`` raises whatever the operator."""
        predicate = "m.outcome is not None and m.outcome[0][0].low != 11"
        builder = _matrix_gated(predicate, matrix_input={"control": "Range", "min": 0, "max": 10}, cols=2)

        self.assertFalse(_sat(builder.get_reachability_base(), self._gate(builder, predicate), builder.slot_choice("m", 0, 0)))
        self.assertTrue(_exact(builder, predicate))
        self.assertEqual(_status(builder), "CONDITIONAL")

    def test_comprehension_indices_resolve_their_own_cell(self):
        """Each ``(r, c)`` the fold binds raises on its own cell's ``None``."""
        predicate = "all(m.outcome[r][c] > 0 for r in range(2) for c in range(3))"
        builder = _matrix_gated(predicate, rows=2, cols=3)
        gate = self._gate(builder, predicate)
        base = builder.get_reachability_base()

        cells = [builder.slot_choice("m", r, c) for r in range(2) for c in range(3)]
        self.assertTrue(_sat(base, gate, *[Not(cell) for cell in cells]))
        for r in range(2):
            for c in range(3):
                with self.subTest(cell=(r, c)):
                    others = [Not(builder.slot_choice("m", i, j)) for i in range(2) for j in range(3) if (i, j) != (r, c)]
                    self.assertFalse(_sat(base, gate, builder.slot_choice("m", r, c), *others))

    def test_the_witness_shows_an_unanswered_cell_as_none(self):
        """A check only an empty cell passes shows that cell ``None`` and the
        rest of the matrix as answered (R5)."""
        from askalot_qml.z3.global_formula import GlobalFormula

        builder = _matrix_gated(
            "m.outcome is not None and m.outcome[0][1] not in [1, 2, 3]",
            kind="postcondition",
            owner="m",
            cols=2,
        )
        result = GlobalFormula(builder).check()

        self.assertTrue(result.satisfiable)
        cells = result.witness["m.outcome"]
        self.assertIsNone(cells[0][1])
        self.assertIn(cells[0][0], (1, 2, 3, None))

    def test_the_witness_shows_a_none_matrix_as_none(self):
        """Skipped or left blank, a matrix the check reads as ``None`` shows so."""
        from askalot_qml.z3.global_formula import GlobalFormula

        builder = _matrix_gated(
            "m.outcome is None or m.outcome[0][0] == 9", gated=True, kind="postcondition"
        )
        result = GlobalFormula(builder).check()

        self.assertTrue(result.satisfiable)
        self.assertIsNone(result.witness["m.outcome"])

    def test_a_code_written_matrix_gets_no_new_choice(self):
        predicate = "m.outcome[0][0] != 9"
        builder = _matrix_gated(predicate, gated=True, matrix_code="m.outcome[0][0] = 1")
        self._gate(builder, predicate)

        self.assertEqual(_status(builder), "ALWAYS")
        self.assertIsNone(builder.skip_choice("m"))
        self.assertIsNone(builder.blank_choice("m"))
        self.assertIsNone(builder.slot_choice("m", 0, 0))

    def test_a_scoped_matrix_gets_no_new_choice(self):
        state = QMLState(
            {
                "title": "Capped",
                "blocks": [{"id": "b", "title": "B", "kind": "Group", "count": 1}, {"id": "b2", "title": "B2"}],
                "items": [
                    {"id": "m", "blockId": "b", "_group_block_id": "b", "_group_count": 1,
                     "kind": "MatrixQuestion", "title": "M", "rows": ["R"], "columns": ["C"],
                     "input": _RADIO_1_3},
                    {"id": "q_x", "blockId": "b", "_group_block_id": "b", "_group_count": 1,
                     "kind": "Question", "title": "X", "input": _RADIO_1_3},
                    {"id": "q_c", "blockId": "b2", "kind": "Question", "title": "C",
                     "precondition": [{"predicate": "m.outcome[0][0] != 9"}]},
                ],
            }
        )
        builder = StaticBuilder(state)
        self._gate(builder, "m.outcome[0][0] != 9")

        self.assertEqual(_status(builder), "ALWAYS")
        self.assertIsNone(builder.skip_choice("m"))
        self.assertIsNone(builder.blank_choice("m"))
        self.assertIsNone(builder.slot_choice("m", 0, 0))


    def test_a_cell_read_through_a_ternary_branch_is_a_gap(self):
        """``None`` passes through a ternary into the comparison without
        raising: an empty cell makes ``None != 1`` hold, ``None in [...]``
        fail. The in-domain cell alone would call the first NEVER and the
        second ALWAYS, so the condition is not lowered and the gap names ``m``."""
        sole = {"control": "Radio", "labels": {1: "Y"}}
        for predicate, matrix_input in (
            ("m.outcome is not None and (m.outcome[0][0] if True else 1) != 1", sole),
            ("(m.outcome[0][0] if True else 0) in [0, 1, 2]", {"control": "Editbox", "min": 0, "max": 2}),
        ):
            with self.subTest(predicate=predicate):
                builder = _matrix_gated(predicate, matrix_input=matrix_input)

                self.assertEqual(_status(builder), "CONDITIONAL")
                self.assertEqual(_matrix_gap_items(builder), [["m"]])

    def test_a_set_of_cells_is_no_distinct(self):
        """An empty cell is a ``None`` member of the set: ``[[1, None]]`` has two
        distinct members over the one label, so the gate is reachable."""
        predicate = "m.outcome is not None and len(set([m.outcome[0][0], m.outcome[0][1]])) == 2"
        builder = _matrix_gated(predicate, matrix_input={"control": "Radio", "labels": {1: "Y"}}, cols=2)

        self.assertEqual(_status(builder), "CONDITIONAL")
        self.assertEqual(_matrix_gap_items(builder), [["m"]])


@pytest.mark.unit
@pytest.mark.z3
class TestOwnPostconditionJudgedOnAnswers(unittest.TestCase):
    """#1839 (owner decision 2026-10-24): an item's own postcondition that no
    real answer satisfies is INFEASIBLE for a Question, a QuestionGroup and a
    MatrixQuestion alike. A blank still reaches the runtime's waiver (its own
    read raises on ``None``), so the blank stays admissible; the verdict just
    does not count it as an answer."""

    def test_an_unsatisfiable_own_postcondition_is_infeasible_for_every_kind(self):
        question = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q",
                        "input": {"control": "Radio", "labels": {i: str(i) for i in range(1, 6)}},
                        "postcondition": [{"predicate": "q.outcome > 5"}],
                    }
                ]
            )
        )
        group = _group_gated("qg.outcome[0] == 9", group_input=_RADIO_1_5, kind="postcondition", owner="qg")
        gated_group = _group_gated(
            "qg.outcome[0] == 9", group_input=_RADIO_1_5, kind="postcondition", owner="qg", gated=True
        )
        matrix = _matrix_gated("m.outcome[0][0] == 9", kind="postcondition", owner="m")
        gated_matrix = _matrix_gated("m.outcome[0][0] == 9", kind="postcondition", owner="m", gated=True)

        for name, builder, item_id in (
            ("question", question, "q"),
            ("group", group, "qg"),
            ("gated group", gated_group, "qg"),
            ("matrix", matrix, "m"),
            ("gated matrix", gated_matrix, "m"),
        ):
            with self.subTest(kind=name):
                self.assertEqual(_invariant(builder, item_id), "INFEASIBLE")
        # The blank is still waived at runtime, so it stays admissible.
        self.assertTrue(_sat(group.get_reachability_base(), group.blank_choice("qg")))

    def test_a_satisfiable_own_postcondition_stays_constraining(self):
        """Precision: a check some answer passes keeps its verdict, and one
        a None test lets a blank through stays CONSTRAINING."""
        for predicate in ("qg.outcome[0] == 2", "qg.outcome is None or qg.outcome[0] == 9"):
            with self.subTest(predicate=predicate):
                builder = _group_gated(predicate, kind="postcondition", owner="qg")
                self.assertEqual(_invariant(builder, "qg"), "CONSTRAINING")
        builder = _matrix_gated("m.outcome[0][0] == 2", kind="postcondition", owner="m")
        self.assertEqual(_invariant(builder, "m"), "CONSTRAINING")


def _matrix_gap_items(builder: StaticBuilder, item_id: str = "q_c") -> list[list[str]]:
    return [gap.get("matrix_items", []) for gap in builder.coverage_gaps.get(item_id, [])]


@pytest.mark.unit
@pytest.mark.z3
class TestRangeNamedEnds(unittest.TestCase):
    """#1755 (D89): a Range answer's ends are named. ``q.outcome.low`` /
    ``.high`` and ``m.outcome[j][k].low`` / ``.high`` lower onto the pair's two
    variables; a positional read is a coverage gap that names ``.low`` /
    ``.high``, since there is no positional alias at runtime either."""

    def test_question_ends_are_proven(self):
        builder = _range_builder(
            [
                _RANGE_0_4,
                {"id": "a", "precondition": [{"predicate": "q.outcome.low > q.outcome.high"}]},
                {"id": "b", "precondition": [{"predicate": "q.outcome.high >= 5"}]},
                {"id": "c", "precondition": [{"predicate": "q.outcome.high - q.outcome.low <= 1"}]},
            ]
        )

        status = _reachability(builder)
        self.assertEqual((status["a"], status["b"], status["c"]), ("NEVER", "NEVER", "CONDITIONAL"))
        self.assertEqual(builder.coverage_gaps, {})

    def test_matrix_cell_ends_are_proven(self):
        builder = _range_builder(
            [
                _RANGE_MATRIX_0_4,
                {"id": "a", "precondition": [{"predicate": "m.outcome[0][1].low <= 2"}]},
                {"id": "b", "precondition": [{"predicate": "m.outcome[1][0].high > 4"}]},
                {
                    "id": "c",
                    "precondition": [{"predicate": "m.outcome[1][1].low > m.outcome[1][1].high"}],
                },
            ]
        )

        status = _reachability(builder)
        self.assertEqual((status["a"], status["b"], status["c"]), ("CONDITIONAL", "NEVER", "NEVER"))
        self.assertEqual(builder.coverage_gaps, {})

    def test_a_positional_read_is_a_gap_naming_the_ends(self):
        for predicate, range_item in (
            ("q.outcome[1] >= 5", "q"),
            ("m.outcome[0][1][0] <= 2", "m"),
        ):
            with self.subTest(predicate=predicate):
                state = create_questionnaire(
                    [
                        _RANGE_0_4,
                        _RANGE_MATRIX_0_4,
                        {"id": "r", "precondition": [{"predicate": predicate}]},
                    ]
                )
                builder = StaticBuilder(state)

                self.assertEqual(
                    [g["range_items"] for g in builder.coverage_gaps.get("r") or []], [[range_item]]
                )
                self.assertNotEqual(_reachability(builder)["r"], "NEVER")
                skipped = [
                    i
                    for i in ValidationProcessor(state).to_issues()
                    if i["type"] == "skipped_condition" and i["item_id"] == "r"
                ]
                self.assertEqual(len(skipped), 1)
                self.assertIn("'q.outcome.low' / 'q.outcome.high'", skipped[0]["suggestion"])

    def test_the_lowered_names_are_the_runtime_value_fields(self):
        from dataclasses import fields

        from askalot_qml.core.controls import RangeValue
        from askalot_qml.z3.static_builder import _RANGE_ENDS

        self.assertEqual(_RANGE_ENDS, tuple(f.name for f in fields(RangeValue)))

    def test_another_attribute_of_a_range_is_not_an_end(self):
        builder = _range_builder(
            [_RANGE_0_4, {"id": "r", "precondition": [{"predicate": "q.outcome.mid > 1"}]}]
        )

        self.assertEqual([g["range_items"] for g in builder.coverage_gaps["r"]], [["q"]])


def _gate_status(predicate: str) -> tuple[str, dict]:
    """The reachability of an item gated on *predicate* over ``q`` (Editbox
    0–10) and the codeInit constant ``risk = 1``, plus the builder's gaps."""
    builder = _range_builder(
        [
            {"id": "q", "input": {"control": "Editbox", "min": 0, "max": 10}},
            {"id": "r", "precondition": [{"predicate": predicate}]},
        ],
        code_init="risk = 1",
    )
    return _reachability(builder)["r"], builder.coverage_gaps


@pytest.mark.unit
@pytest.mark.z3
class TestLoweringCoversEveryExpressionNode(unittest.TestCase):
    """#1660 deleted ``PragmaticZ3Compiler``, the second AST → Z3 lowering,
    with the seven test files that exercised it. This class holds the
    constructs those files covered against the one lowering left: each gate
    below is false on every answer in the domain, so it classifies NEVER only
    if ``StaticBuilder`` lowered the construct exactly. A construct it dropped
    would leave a coverage gap and an ALWAYS / CONDITIONAL gate instead."""

    NEVER_GATES = {
        "Add": "q.outcome + 1 > 11",
        "Sub": "q.outcome - 1 < -1",
        "Mult": "q.outcome * 2 > 20",
        "FloorDiv": "q.outcome // 2 > 5",
        "Mod": "q.outcome % 3 > 2",
        "USub": "-q.outcome > 0",
        "UAdd": "+q.outcome > 10",
        "IfExp": "(1 if q.outcome > 5 else 0) > 1",
        "Eq": "q.outcome == 11",
        "NotEq": "q.outcome != q.outcome",
        "Lt": "q.outcome < 0",
        "LtE": "q.outcome <= -1",
        "Gt": "q.outcome > 10",
        "GtE": "q.outcome >= 11",
        "chained Compare": "10 < q.outcome < 20",
        "In": "q.outcome in [11, 12]",
        "NotIn": "q.outcome not in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]",
        "And": "q.outcome > 5 and q.outcome < 3",
        "Or": "q.outcome > 10 or q.outcome < 0",
        "Not": "not (q.outcome <= 10)",
        "Constant": "False",
        "Name (codeInit constant)": "risk == 2",
        "int()": "int(q.outcome > 5) > 1",
        "bool()": "bool(q.outcome) and q.outcome == 0",
        "abs()": "abs(q.outcome) > 10",
        "sum()": "sum([q.outcome, q.outcome]) > 20",
        "all()": "all([q.outcome > 5, q.outcome < 3])",
        "any()": "any([q.outcome > 10, q.outcome < 0])",
    }

    def test_each_construct_lowers_exactly(self):
        for construct, predicate in self.NEVER_GATES.items():
            with self.subTest(construct=construct, predicate=predicate):
                status, gaps = _gate_status(predicate)
                self.assertEqual(gaps, {})
                self.assertEqual(status, "NEVER")

    def test_a_satisfiable_gate_is_not_never(self):
        """The control: the same harness does not call everything NEVER."""
        status, gaps = _gate_status("q.outcome * 2 + 1 > 19")
        self.assertEqual((status, gaps), ("CONDITIONAL", {}))

    def test_division_lowers_only_where_z3_agrees_with_python(self):
        """#1767: Python's ``/`` is true division and its ``//`` / ``%`` follow
        the divisor's sign, while Z3's Int ``/`` truncates and its div / mod are
        Euclidean. Each gate below holds for some answer at runtime; lowered,
        it would be proven NEVER. It stays out, as a gap naming the operator."""
        for predicate, operator in (
            ("q.outcome / 2 == 0.5", "Div"),
            ("q.outcome > 0 and q.outcome / 2 < 1 and q.outcome / 2 > 0", "Div"),
            ("q.outcome == 1 and q.outcome // -2 == -1", "FloorDiv"),
            ("q.outcome == 1 and q.outcome % -2 == -1", "Mod"),
            ("q.outcome == 1 and q.outcome // (q.outcome - 2) == -1", "FloorDiv"),
        ):
            with self.subTest(predicate=predicate):
                status, gaps = _gate_status(predicate)
                self.assertNotEqual(status, "NEVER")
                self.assertEqual(
                    [g["unsupported_nodes"] for g in gaps.get("r", [])], [[operator]]
                )

    def test_augmented_division_follows_the_same_rule(self):
        for code, gate in (("x = 1\nx //= -2", "x == -1"), ("x = 1\nx %= -2", "x == -1")):
            with self.subTest(code=code):
                builder = _range_builder(
                    [{"id": "r", "precondition": [{"predicate": gate}]}], code_init=code
                )
                self.assertNotEqual(_reachability(builder)["r"], "NEVER")

    def test_int_counts_a_boolean_expression_but_never_reads_an_or_value_as_one(self):
        """``int(a and b)`` over comparisons counts a condition; ``int(q or 1)``
        is the value of an operand (2 when the answer is 2), so it is never
        lowered as a truth value, which would wrongly prove ``== 2`` NEVER."""
        status, gaps = _gate_status("int(q.outcome > 5 and q.outcome < 3) > 0")
        self.assertEqual((status, gaps), ("NEVER", {}))
        status, _gaps = _gate_status("int(q.outcome or 1) == 2")
        self.assertNotEqual(status, "NEVER")


_RADIO_1_5 = {"control": "Radio", "labels": {i: str(i) for i in range(1, 6)}}


@pytest.mark.unit
@pytest.mark.z3
class TestZ3NameAliasing(unittest.TestCase):
    """Every derived Z3 name separates the item id with ``@`` (#1783): Z3
    ``Int``s of one name in one context are one variable, and an item id may
    hold ``_``, so ``item_m_0_0`` would be matrix ``m``'s cell and Question
    ``m_0_0`` at once."""

    def test_a_matrix_cell_never_aliases_an_item_named_after_it(self):
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {"id": "m", "kind": "MatrixQuestion", "rows": ["r"], "columns": ["c"], "input": _RADIO_1_5},
                    {"id": "m_0_0", "input": _RADIO_1_5},
                    {
                        "id": "r",
                        "input": _RADIO_1_5,
                        "postcondition": [{"predicate": "m.outcome[0][0] != m_0_0.outcome"}],
                    },
                ]
            )
        )

        cell = builder.item_cells["m"][(0, 0)]
        self.assertEqual(str(cell), "item_m@0@0")
        self.assertFalse(cell.eq(builder.item_vars["m_0_0"]))
        result = ItemClassifier(builder).classify_all_items()["r"]
        self.assertEqual(result["postcondition"]["invariant"], "CONSTRAINING")

    def test_a_variable_never_aliases_an_item_answer(self):
        """#1798: a codeInit variable ``item_q`` and a Question ``q_0`` (labels
        7/8) are two variables, so ``q_0.outcome == 7 and item_q == 1`` is a
        real gate; as one symbol their domains clash and it was ALWAYS."""
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {"id": "q_0", "input": {"control": "Radio", "labels": {7: "a", 8: "b"}}},
                    {
                        "id": "z",
                        "input": _RADIO_1_3,
                        "precondition": [{"predicate": "q_0.outcome == 7 and item_q == 1"}],
                    },
                ],
                code_init="item_q = 1",
            )
        )

        self.assertFalse(builder.z3_vars["item_q_0"].eq(builder.item_vars["q_0"]))
        self.assertEqual(_reachability(builder)["z"], "CONDITIONAL")

    def test_a_capped_group_outcome_never_aliases_an_item_named_after_it(self):
        """A capped-Group member ``q`` (labels 1–3) beside a Question
        ``q_group0`` (labels 7–9): one shared variable would hold both
        domains, so ``q`` could never be drawn."""
        state = QMLState(
            {
                "title": "Alias",
                "blocks": [
                    {"id": "g", "title": "G", "kind": "Group", "count": 1},
                    {"id": "b1", "title": "B"},
                ],
                "items": [
                    {
                        "id": "q",
                        "blockId": "g",
                        "_group_block_id": "g",
                        "_group_count": 1,
                        "kind": "Question",
                        "title": "Q",
                        "input": _RADIO_1_3,
                    },
                    {
                        "id": "q_group0",
                        "blockId": "b1",
                        "kind": "Question",
                        "title": "Q0",
                        "input": {"control": "Radio", "labels": {7: "a", 8: "b", 9: "c"}},
                    },
                ],
            }
        )
        builder = StaticBuilder(state)

        s = Solver(ctx=builder.ctx)
        s.add(builder.get_domain_base(), builder._present_var("q", 0))
        self.assertEqual(s.check(), sat)
        self.assertTrue(any("item_q@group0" in str(c) for c in builder.domain_constraints))


_RADIO_1_5 = {"control": "Radio", "labels": {i: str(i) for i in range(1, 6)}}


def _blank_gated(
    predicate: str,
    *,
    kind: str = "precondition",
    q_post: str | None = None,
    extra: list | None = None,
    code_init: str = "",
) -> StaticBuilder:
    """Ungated Radios ``q`` and ``q2`` (1-5) and ``r`` carrying *predicate* as
    its *kind* condition; ``q`` gets *q_post* as its own postcondition."""
    return StaticBuilder(
        create_questionnaire(
            [
                {
                    "id": "q",
                    "input": _RADIO_1_5,
                    **({"postcondition": [{"predicate": q_post}]} if q_post else {}),
                },
                {"id": "q2", "input": _RADIO_1_5},
                *(extra or []),
                {
                    "id": "r",
                    kind: [{"predicate": predicate}],
                    "input": {"control": "Editbox", "min": 0, "max": 9},
                },
            ],
            code_init=code_init,
        )
    )


def _sat(*constraints) -> bool:
    solver = Solver(ctx=constraints[0].ctx)
    solver.add(*constraints)
    return solver.check() == sat


@pytest.mark.unit
@pytest.mark.z3
class TestBlankAnswer(unittest.TestCase):
    """#1784: a Question shown and left blank makes every leaf that reads it
    unknown (Kleene logic, #1023), so a precondition fails and a postcondition
    is waived; the model gives each item a ``blank`` choice wrapped around the
    leaves below the condition's ``and`` / ``or`` / ``not``.

    Witnesses are direct solver checks over the base and ``blank_choice``.
    The precision tests (AE6, AE7, AE9, AE2's exactness) pass without the wrap
    too: they fail when the blank is modelled too wide.
    """

    def _gate(self, builder: StaticBuilder, predicate: str, kind: str = "precondition"):
        return builder.compile_conditions(
            "r", [{"predicate": predicate}], kind=kind
        )

    def test_a_gate_on_an_ungated_question_is_not_always(self):
        """AE1: blank ``q`` makes ``q.outcome != 9`` unknown, and the gate fails."""
        predicate = "q.outcome != 9"
        builder = _blank_gated(predicate)

        self.assertEqual(_status(builder, "r"), "CONDITIONAL")
        self.assertTrue(
            _sat(builder.get_reachability_base(), Not(self._gate(builder, predicate)), builder.blank_choice("q"))
        )

    def test_an_answered_part_still_decides_an_or(self):
        """AE2: one answered 1 settles the ``or`` whatever the other holds, and
        the lowering is exact."""
        predicate = "q.outcome == 1 or q2.outcome == 1"
        builder = _blank_gated(predicate)
        gate = self._gate(builder, predicate)
        base = builder.get_reachability_base()

        for answered, other in (("q", "q2"), ("q2", "q")):
            with self.subTest(answered=answered):
                self.assertFalse(
                    _sat(
                        base,
                        Not(gate),
                        Not(builder.blank_choice(answered)),
                        builder.item_vars[answered] == 1,
                        builder.blank_choice(other),
                    )
                )
        self.assertTrue(_exact(builder, predicate, owner="r"))
        self.assertEqual(_status(builder, "r"), "CONDITIONAL")

    def test_not_over_a_blank_leaf_is_still_false(self):
        """AE3: ``not`` of an unknown is unknown, so the precondition fails."""
        predicate = "not (q.outcome == 1)"
        builder = _blank_gated(predicate)

        self.assertFalse(
            _sat(builder.get_reachability_base(), self._gate(builder, predicate), builder.blank_choice("q"))
        )
        self.assertEqual(_status(builder, "r"), "CONDITIONAL")

    def test_a_postcondition_true_only_by_waiver_is_not_tautological(self):
        """AE4: blank ``q`` waives ``q.outcome != 9``: accepted, never INFEASIBLE,
        but not TAUTOLOGICAL either."""
        predicate = "q.outcome != 9"
        builder = _blank_gated(predicate, kind="postcondition")
        accepted = self._gate(builder, predicate, kind="postcondition")

        self.assertFalse(_sat(builder.get_full_base(), builder.blank_choice("q"), Not(accepted)))
        post = ItemClassifier(builder).classify_item("r")["postcondition"]
        self.assertEqual(post["invariant"], "CONSTRAINING")
        self.assertFalse(post["global"]["q_globally_true"])

    def test_a_none_guard_and_settles_a_blank_item_false(self):
        """AE5: the guard leaf carries the blank state and the ``and`` is exact."""
        predicate = "q.outcome is not None and q.outcome != 9"
        builder = _blank_gated(predicate)

        self.assertEqual(_status(builder, "r"), "CONDITIONAL")
        self.assertTrue(_exact(builder, predicate, owner="r"))

    def test_a_none_guard_or_keeps_the_gate_always(self):
        """AE6: the guard carries the blank state (its free ``answered``), so
        neither the guard leaf nor the read it guards is wrapped in a blank."""
        predicate = "q.outcome is None or q.outcome != 9"
        builder = _blank_gated(predicate)
        self.assertEqual(_status(builder, "r"), "ALWAYS")
        self.assertTrue(_exact(builder, predicate, owner="r"))

        isolated = "q.outcome is None or q.outcome == 1"
        builder = _blank_gated(isolated)
        self._gate(builder, isolated)
        self.assertIsNone(builder.blank_choice("q"))

    def test_an_item_whose_postcondition_refuses_none_is_never_blank(self):
        """AE7: ``None in [1, 2]`` is False, so ``q`` cannot be submitted blank
        and the gate keeps its ALWAYS."""
        builder = _blank_gated("q.outcome != 9", q_post="q.outcome in [1, 2]")

        self.assertEqual(_status(builder, "r"), "ALWAYS")
        self.assertFalse(_sat(builder.get_reachability_base(), builder.blank_choice("q")))

    def test_a_postcondition_that_raises_on_none_admits_a_blank(self):
        """A raise waives the item's own postcondition, so it admits a blank."""
        builder = _blank_gated("q.outcome != 9", q_post="q.outcome > 1")

        self.assertEqual(_status(builder, "r"), "CONDITIONAL")

    def test_a_gate_on_constants_and_variables_keeps_its_verdict(self):
        """AE9: a gate that reads no item has no blank to model."""
        builder = _blank_gated("x == 1", code_init="x = 1")

        self.assertEqual(_status(builder, "r"), "ALWAYS")
        self.assertIsNone(builder.blank_choice("q"))

    def test_any_over_two_reads_is_one_leaf(self):
        """AE10: ``any([...])`` is one runtime leaf, so a blank ``q`` makes it
        unknown even where the other member is True."""
        predicate = "any([q.outcome == 1, q2.outcome == 2])"
        builder = _blank_gated(predicate)

        self.assertFalse(
            _sat(
                builder.get_reachability_base(),
                self._gate(builder, predicate),
                builder.blank_choice("q"),
                builder.item_vars["q2"] == 2,
            )
        )

    def test_a_code_written_item_gets_a_fresh_blank_per_predicate(self):
        """A codeBlock can answer ``q`` between two gates, so one may read it
        blank while the other reads it answered."""
        builder = _blank_gated(
            "q.outcome != 9",
            extra=[
                {"id": "w", "input": _RADIO_1_5, "codeBlock": "q.outcome = 1"},
                {
                    "id": "r2",
                    "precondition": [{"predicate": "q.outcome != 9"}],
                    "input": {"control": "Editbox", "min": 0, "max": 9},
                },
            ],
        )
        first = self._gate(builder, "q.outcome != 9")
        second = builder.compile_conditions("r2", [{"predicate": "q.outcome != 9"}], kind="precondition")

        self.assertTrue(_sat(builder.get_reachability_base(), first, Not(second)))

    def test_a_witness_reports_a_blank_item_as_none(self):
        """A completion that holds only because ``q`` was left blank shows it
        ``None`` (R5)."""
        from askalot_qml.z3.global_formula import GlobalFormula

        builder = _blank_gated(
            " and ".join(f"q.outcome != {label}" for label in range(1, 6)), kind="postcondition"
        )
        result = GlobalFormula(builder).check()

        self.assertTrue(result.satisfiable)
        self.assertIsNone(result.witness["q.outcome"])

    def test_a_codeblock_if_guard_reads_no_blank(self):
        """A codeBlock runs plain Python: ``None != 9`` assigns ``v``, so the
        later reader of ``v`` is no ``uninitialized_read`` (the guard is
        compiled with ``code_guard``, which models no blank)."""
        state = create_questionnaire(
            [
                {"id": "q", "input": _RADIO_1_5},
                {
                    "id": "a",
                    "input": {"control": "Editbox", "min": 0, "max": 9},
                    "codeBlock": "if q.outcome != 9:\n    v = 1",
                },
                {
                    "id": "s",
                    "input": {"control": "Editbox", "min": 0, "max": 9},
                    "codeBlock": "w = v + 1",
                },
            ]
        )

        issues = ValidationProcessor(state).to_issues()
        self.assertNotIn("uninitialized_read", [i["type"] for i in issues])


    def test_a_codeblock_read_of_a_blank_item_raises_too(self):
        """#1776: an always-asked q_b submitted blank is ``None`` in q_c's
        codeBlock, so ``None + 10`` raises there as it does on a skip, and the
        block stops: ``after`` keeps 0 (it reads nothing blank, so the #1044
        mark does not touch it), and ``r``'s check on it is not INFEASIBLE.
        Precision: a q_b whose own postcondition refuses ``None`` is never
        blank, so the block always runs through."""
        code = "flag = q_b.outcome + 10\nafter = 1"
        q_b_input = {"control": "Editbox", "min": 1, "max": 5}
        builder = _code_reader(code, "after == 0", code_init="flag = 0\nafter = 0", q_b_input=q_b_input, gated=False)
        self.assertEqual(_invariant(builder, "r"), "CONSTRAINING")
        always = _code_reader(
            code, "after == 0", code_init="flag = 0\nafter = 0", q_b_input=q_b_input, gated=False, never_blank=True
        )
        self.assertEqual(_invariant(always, "r"), "INFEASIBLE")

    def test_a_variable_computed_from_a_blank_answer_is_free_in_the_model(self):
        """#1776 / #1044: the runtime marks ``flag`` unknown when q_b (Radio
        {1}, ungated) was left blank, so ``flag == 0 and q_b.outcome != 1``
        is waived on that walk. Python's ``None != 1`` would force
        ``flag == 1`` and a false INFEASIBLE; the model leaves ``flag`` free
        under the blank instead (a skip keeps Python's value)."""
        code = "flag = 1 if q_b.outcome != 1 else 0"
        post = "flag == 0 and q_b.outcome != 1"
        self.assertEqual(_invariant(_code_reader(code, post, gated=False), "r"), "CONSTRAINING")
        self.assertEqual(
            _invariant(_code_reader(code, post, gated=False, never_blank=True), "r"), "INFEASIBLE"
        )

    def test_a_blank_admitted_before_its_codeblock_stays_admissible(self):
        """The runtime checks ``qg``'s postcondition before its codeBlock runs:
        ``x`` is still 1 there, so a blank ``qg`` is accepted and ``q_c``'s
        check on it is waived. Read against the final ``x == 2``, the blank
        would be refused and ``q_c`` INFEASIBLE."""
        builder = _group_gated(
            "qg.outcome[0] == 9",
            group_input={"control": "Radio", "labels": {1: "A", 2: "B"}},
            kind="postcondition",
            code_init="x = 1",
            group_code="x = 2",
            group_post="qg.outcome is not None or x == 1",
        )

        self.assertTrue(_sat(builder.get_reachability_base(), builder.blank_choice("qg")))
        self.assertEqual(_invariant(builder), "CONSTRAINING")

    def test_an_items_own_postcondition_reads_variables_before_its_codeblock(self):
        """#1838: the classifier judges ``q``'s own check where the runtime
        runs it, before ``q``'s codeBlock: ``x`` is still 1 there, so
        ``x == 1`` holds for every answer (TAUTOLOGICAL), not INFEASIBLE as
        read against the final ``x == 2``. A later item reads the final ``x``."""
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q",
                        "input": {"control": "Radio", "labels": {1: "A", 2: "B"}},
                        "postcondition": [{"predicate": "x == 1"}],
                        "codeBlock": "x = 2",
                    },
                    {
                        "id": "r",
                        "input": {"control": "Radio", "labels": {1: "A", 2: "B"}},
                        "postcondition": [{"predicate": "x == 1"}],
                    },
                ],
                code_init="x = 1",
            )
        )

        self.assertEqual(_invariant(builder, "q"), "TAUTOLOGICAL")
        self.assertEqual(_invariant(builder, "r"), "INFEASIBLE")
        issues = {(i["type"], i["item_id"]) for i in ValidationProcessor(builder.state).to_issues()}
        self.assertNotIn(("infeasible_postcondition", "q"), issues)
        self.assertNotIn(("globally_false_postcondition", "q"), issues)


    def test_an_items_own_postcondition_reads_variables_in_navigation_order(self):
        """Codex on PR #1986: ``q`` reads ``x``, which ``t`` writes later in the
        file, so the walk asks ``t`` first and ``x`` is 1 when ``q``'s check
        runs: TAUTOLOGICAL, not the INFEASIBLE that the file-order snapshot
        (``x`` still 0) gave."""
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {
                        "id": "q",
                        "input": {"control": "Radio", "labels": {1: "A", 2: "B"}},
                        "postcondition": [{"predicate": "x == 1"}],
                    },
                    {"id": "t", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}, "codeBlock": "x = 1"},
                ],
                code_init="x = 0",
            )
        )

        self.assertEqual(_invariant(builder, "q"), "TAUTOLOGICAL")

    def test_an_open_variable_is_one_value_for_all_of_an_items_conditions(self):
        """PR #1986 review: ``s`` and ``a`` write ``x`` in an order the walk
        reverses, so no SSA version is ``x``'s value at ``q`` and ``q`` reads a
        fresh Int. Its precondition and postcondition read the SAME one, so
        ``x > 5`` then ``x < 3`` is INFEASIBLE, not CONSTRAINING."""
        state = create_questionnaire(
            [
                {"id": "a", "codeBlock": "x = 9", "precondition": [{"predicate": "q.outcome == 1"}],
                 "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                {"id": "q", "precondition": [{"predicate": "x > 5"}], "postcondition": [{"predicate": "x < 3"}],
                 "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
                {"id": "s", "codeBlock": "x = 1", "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}},
            ],
            code_init="x = 0",
        )
        builder = StaticBuilder(state)

        self.assertIn("x", builder._runtime_versions("q")[1])
        self.assertEqual(_invariant(builder, "q"), "INFEASIBLE")

    def test_the_engine_reads_the_builders_one_topology(self):
        """The navigation order the builder judges against is the engine's:
        one ``QMLTopology``, built once."""
        state = create_questionnaire([{"id": "q", "input": {"control": "Radio", "labels": {1: "A"}}}])
        engine = ValidationProcessor(state).engine

        self.assertIs(engine.topology, engine.static_builder.topology)

    @staticmethod
    def _marked(code: str, gate: str = "flag < 5 or flag >= 5", *, required: bool = False,
                later_code: str | None = None) -> str:
        """#1844: Radio ``q_a`` (blank admissible unless *required*) with
        codeBlock *code*, an optional ``q_b`` with *later_code*, then ``r``
        gated on *gate*; the status of ``r``'s precondition."""
        q_a = {"id": "q_a", "codeBlock": code, "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}}
        if required:
            q_a["postcondition"] = [{"predicate": "q_a.outcome is not None"}]
        items = [q_a]
        if later_code:
            items.append({"id": "q_b", "codeBlock": later_code,
                          "postcondition": [{"predicate": "q_b.outcome is not None"}],
                          "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}})
        items.append({"id": "r", "precondition": [{"predicate": gate}], "input": {"control": "Radio", "labels": {1: "OK"}}})
        return _status(StaticBuilder(create_questionnaire(items, code_init="flag = 0\ng = 0")), "r")

    def test_a_variable_computed_from_a_blank_answer_makes_its_gate_unknown(self):
        """The runtime marks ``flag`` unknown when q_a is blank (#1044), so a
        gate true for every number is undecided there and r is skipped:
        CONDITIONAL, not ALWAYS. Required, q_a is never blank: ALWAYS."""
        code = "flag = 1 if q_a.outcome == 1 else 2"
        self.assertEqual(self._marked(code), "CONDITIONAL")
        self.assertEqual(self._marked(code, required=True), "ALWAYS")

    def test_an_assignment_under_a_blank_branch_test_is_marked(self):
        """Which branch ran was decided by the blank, so even an assignment
        that did not run marks its target (``_unknown_after``)."""
        self.assertEqual(self._marked("if q_a.outcome == 1:\n    flag = 1"), "CONDITIONAL")

    def test_a_none_tested_read_marks_nothing(self):
        """``q_a.outcome if q_a.outcome is not None else 0`` handles the blank
        itself: no mark, the gate stays ALWAYS."""
        self.assertEqual(self._marked("flag = q_a.outcome if q_a.outcome is not None else 0"), "ALWAYS")

    def test_a_clean_reassignment_that_changes_the_value_clears_the_mark(self):
        self.assertEqual(self._marked("flag = 1 if q_a.outcome == 1 else 2\nflag = 3"), "ALWAYS")

    def test_a_clean_branch_keeps_the_mark_where_it_left_the_value(self):
        """q_b's ``if q_b.outcome == 1: flag = 5`` clears flag statically, but
        the runtime drops the mark only where the value changed: on q_b = 2 it
        did not, so flag stays unknown."""
        code = "flag = 1 if q_a.outcome == 1 else 2"
        self.assertEqual(self._marked(code, later_code="if q_b.outcome == 1:\n    flag = 5"), "CONDITIONAL")

    def test_the_mark_travels_through_a_variable_into_a_later_block(self):
        """``g = flag`` in q_b reads a marked variable, so g is marked too."""
        code = "flag = 1 if q_a.outcome == 1 else 2"
        self.assertEqual(self._marked(code, "g < 5 or g >= 5", later_code="g = flag"), "CONDITIONAL")
        self.assertEqual(self._marked(code, "g < 5 or g >= 5", later_code="g = 4"), "ALWAYS")

    def test_a_widened_write_the_mark_walk_does_not_follow_keeps_the_mark(self):
        """``_unknown_after`` walks no ``match`` body and no walrus, so the
        runtime keeps flag's mark through them; the fresh version the build
        widens them to carries it on (``_settle_marks``)."""
        code = "flag = 1 if q_a.outcome == 1 else 2"
        match = "match q_b.outcome:\n    case 1:\n        flag = 3"
        self.assertEqual(self._marked(code, later_code=match), "CONDITIONAL")
        self.assertEqual(self._marked(code, later_code="g = (flag := 3) + 0"), "CONDITIONAL")

    def test_the_mark_never_makes_a_gate_never(self):
        """A mark is a possibility, never a certainty (``_variable_mark``): a
        satisfiable gate stays reachable and an impossible one stays NEVER."""
        code = "flag = 1 if q_a.outcome == 1 else 2"
        self.assertEqual(self._marked(code, "flag == 1"), "CONDITIONAL")
        self.assertEqual(self._marked(code, "flag < 0 and flag > 0"), "NEVER")
        # Even where q_a is blank, a world without the mark remains: a mirror
        # rule wider than the runtime costs a CONDITIONAL, never a refusal.
        builder = StaticBuilder(create_questionnaire(
            [{"id": "q_a", "codeBlock": code, "input": {"control": "Radio", "labels": {1: "A", 2: "B"}}}],
            code_init="flag = 0",
        ))
        mark = builder._variable_mark("flag")
        self.assertTrue(_sat(builder.blank_choice("q_a"), mark))
        self.assertTrue(_sat(builder.blank_choice("q_a"), Not(mark)))


@pytest.mark.unit
@pytest.mark.z3
class TestDistinctOverSkippable(unittest.TestCase):
    """``len(set([...])) == k`` over gated Questions is no ``Distinct`` (#1785):
    a skipped Question is a ``None`` member, so ``[None, 1, 2, 3]`` has four
    distinct members over three labels."""

    _GATE = "len(set([q1.outcome, q2.outcome, q3.outcome, q4.outcome])) == 4"

    def _builder(self, *, gated: bool) -> StaticBuilder:
        gate = {"precondition": [{"predicate": "g.outcome == 1"}]} if gated else {}
        return StaticBuilder(
            create_questionnaire(
                [
                    {"id": "g", "input": {"control": "Radio", "labels": {1: "y", 2: "n"}}},
                    *({"id": f"q{i}", "input": _RADIO_1_3, **gate} for i in range(1, 5)),
                    {"id": "r", "input": _RADIO_1_3, "precondition": [{"predicate": self._GATE}]},
                ]
            )
        )

    def test_over_skippable_items_it_is_not_never(self):
        builder = self._builder(gated=True)
        self.assertEqual(_reachability(builder)["r"], "CONDITIONAL")
        self.assertTrue(builder.coverage_gaps.get("r"))

    def test_over_always_asked_items_it_stays_never(self):
        builder = self._builder(gated=False)
        self.assertEqual(_reachability(builder)["r"], "NEVER")
        self.assertFalse(builder.coverage_gaps.get("r"))


def _counter_statuses(state: QMLState) -> dict[str, str]:
    results = ItemClassifier(StaticBuilder(state)).classify_all_items()
    return {item: r["precondition"]["status"] for item, r in results.items() if item.startswith("q")}


@pytest.mark.unit
@pytest.mark.z3
class TestCounterGateIsVerified(unittest.TestCase):
    """An accumulator's precondition reads the version its earlier writers
    produce (#1891): the article's ``negative_count < 3`` is proven for the
    first three items, conditional after, and impossible gates are NEVER;
    a writer that may be skipped does not run its codeBlock, so its update is
    only one possibility, never a certainty."""

    def test_the_first_three_items_are_always_asked(self):
        """With every answer required, as only the counter decides the gate."""
        self.assertEqual(
            _counter_statuses(counter_questionnaire(6, required=True)),
            {"q1": "ALWAYS", "q2": "ALWAYS", "q3": "ALWAYS",
             "q4": "CONDITIONAL", "q5": "CONDITIONAL", "q6": "CONDITIONAL"},
        )

    def test_a_blank_earlier_answer_makes_the_counter_unknown(self):
        """#1844: the article's items do not require an answer. A blank q1
        makes ``if q1.outcome == 0`` read unanswered data, so the runtime marks
        ``negative_count`` unknown (#1044) and the gate skips q2 onwards: only
        q1 is always asked."""
        self.assertEqual(
            _counter_statuses(counter_questionnaire(4)),
            {"q1": "ALWAYS", "q2": "CONDITIONAL", "q3": "CONDITIONAL", "q4": "CONDITIONAL"},
        )

    def test_an_impossible_counter_gate_is_never(self):
        statuses = _counter_statuses(counter_questionnaire(4, block_gate="negative_count < 0"))

        self.assertEqual(set(statuses.values()), {"NEVER"})

    def test_item_level_counter_gates_are_verified(self):
        """Every item carries its own ``negative_count < 3``: only the counter
        model proves q1–q3 (a free counter leaves them CONDITIONAL)."""
        self.assertEqual(
            _counter_statuses(counter_questionnaire(6, block_gate=None, item_gate_from=1, required=True)),
            {"q1": "ALWAYS", "q2": "ALWAYS", "q3": "ALWAYS",
             "q4": "CONDITIONAL", "q5": "CONDITIONAL", "q6": "CONDITIONAL"},
        )

    def test_a_textarea_writer_counts(self):
        """A Textarea's codeBlock runs, and the build lowers it (#2003): the
        always-asked ``q_t`` sets ``n = -1`` before ``q_r``, so its gate
        ``n < 0`` is ALWAYS, never a false NEVER (before #2003 the writer was
        invisible and ``_unmodelled_writers`` left the counter open)."""
        def item(item_id, control, precondition=None, code=None):
            entry = {"id": item_id, "blockId": "b1", "kind": "Question", "title": item_id,
                     "input": NO_YES if control == "Radio" else {"control": "Textarea"}}
            if precondition:
                entry["precondition"] = [{"predicate": precondition}]
            if code:
                entry["codeBlock"] = code
            return entry

        state = QMLState(
            {
                "title": "Counter",
                "codeInit": "n = 0",
                "blocks": [{"id": "b1", "title": "B"}],
                "items": [
                    item("q1", "Radio", "n < 3", "n = n + 1"),
                    item("q2", "Radio", "n < 3", "n = n + 1"),
                    item("q_t", "Textarea", code="n = -1"),
                    item("q_r", "Radio", "n < 0"),
                ],
            }
        )

        self.assertEqual(_counter_statuses(state)["q_r"], "ALWAYS")

    def test_a_deleted_counter_leaves_the_counter_open(self):
        """``del negative_count`` in q2 unbinds the counter, so q3's gate raises
        and skips it: the model, which keeps the previous version, must not
        prove q3 ALWAYS."""
        state = counter_questionnaire(4)
        state.get_item("q2")["codeBlock"] += "del negative_count\n"

        self.assertEqual(_counter_statuses(state)["q3"], "CONDITIONAL")

    def test_a_value_read_from_another_counter_out_of_walk_order_stays_open(self):
        """w1 adds counter z to counter x, but waits for z3's answer, so the
        walk asks it after the z block while its codeBlock reads z at its file
        position (0): x >= 2 is reachable (z = 2, then z3 answered Yes) and
        must not be proven NEVER."""
        def item(item_id, block_id, code, precondition=None):
            entry = {"id": item_id, "blockId": block_id, "kind": "Question", "title": item_id,
                     "input": NO_YES, "codeBlock": code}
            if precondition:
                entry["precondition"] = [{"predicate": precondition}]
            return entry

        state = QMLState(
            {
                "title": "Two counters",
                "codeInit": "x = 0\nz = 0",
                "blocks": [
                    {"id": "bx", "title": "X", "precondition": [{"predicate": "x < 5"}]},
                    {"id": "bz", "title": "Z", "precondition": [{"predicate": "z < 3"}]},
                    {"id": "br", "title": "R"},
                ],
                "items": [
                    item("w1", "bx", "x = x + z\n", "z3.outcome == 1"),
                    item("w2", "bx", "if w2.outcome == 0:\n    x = x + 1\n"),
                    *(item(f"z{n}", "bz", f"if z{n}.outcome == 0:\n    z = z + 1\n") for n in (1, 2, 3)),
                    {"id": "qr", "blockId": "br", "kind": "Question", "title": "R", "input": NO_YES,
                     "precondition": [{"predicate": "x >= 2"}]},
                ],
            }
        )

        self.assertEqual(_counter_statuses(state)["qr"], "CONDITIONAL")

    @staticmethod
    def _counted_before_the_gates(first_writer_gate: str | None) -> QMLState:
        """q1 always counts; q2 and q3 count too and are gated ``negative_count < 1``
        (a counter they read and write, so an accumulator); q1 may carry a gate."""
        def item(item_id, block_id, precondition=None, code="negative_count = negative_count + 1\n"):
            entry = {"id": item_id, "blockId": block_id, "kind": "Question", "title": item_id, "input": NO_YES}
            if code:
                entry["codeBlock"] = code
            if precondition:
                entry["precondition"] = [{"predicate": precondition}]
            return entry

        return QMLState(
            {
                "title": "Counter",
                "codeInit": "negative_count = 0",
                "blocks": [{"id": "b0", "title": "Screen"}, {"id": "b1", "title": "Concepts"}],
                "items": [
                    item("q_z", "b0", code=None),
                    item("q1", "b1", first_writer_gate),
                    item("q2", "b1", "negative_count < 1"),
                    item("q3", "b1", "negative_count < 1"),
                ],
            }
        )

    def test_an_ungated_writer_always_counts(self):
        """q1's codeBlock always runs, so q2 sees 1 and its gate is never true."""
        self.assertEqual(_counter_statuses(self._counted_before_the_gates(None))["q2"], "NEVER")

    def test_a_skippable_writer_may_leave_the_counter_as_it_was(self):
        """When q1's own gate skips it its codeBlock does not run, so q2 may
        still see 0: modelling the write as certain would refuse q2 falsely."""
        statuses = _counter_statuses(self._counted_before_the_gates("q_z.outcome == 1"))

        self.assertEqual(statuses["q2"], "CONDITIONAL")

    def test_only_accumulators_are_modelled_for_reachability(self):
        """A counter read only after all its writers keeps its free versions,
        so a questionnaire with no cycle keeps today's verdicts."""
        state = QMLState(
            {
                "title": "Later reader",
                "codeInit": "n = 0",
                "blocks": [{"id": "b1", "title": "B"}],
                "items": [
                    {"id": "q1", "blockId": "b1", "kind": "Question", "title": "Q1", "input": NO_YES,
                     "codeBlock": "n = n + 1\n"},
                    {"id": "q2", "blockId": "b1", "kind": "Question", "title": "Q2", "input": NO_YES,
                     "precondition": [{"predicate": "n == 5"}]},
                ],
            }
        )

        self.assertEqual(_counter_statuses(state)["q2"], "CONDITIONAL")


@pytest.mark.unit
@pytest.mark.z3
class TestCompilesAfterTheBuildAreMemoised(unittest.TestCase):
    """A condition is lowered once after the build, whoever asks (#2246).

    The classifier, the lints (``is_guaranteed`` in ``_condition_reference_issues``)
    and the Global and Path-based formulas each compile the same item's
    conditions, and a hit answers the kept lowering with fresh symbols of its
    own. The cases spy on ``_lower_predicate`` from the end of the build
    through a full ``to_issues(deep=True)``, compare with a builder that keeps
    nothing, and conjoin two compiles of one key.
    """

    FIXTURES = (
        "inline",
        "code_written",
        "roster_household_labour.qml",
        "lint_hygiene.qml",
        "lint_authoring_559.qml",
        "defect_dead_end.qml",
        "thesis_dead_code_income.qml",
    )

    @staticmethod
    def _state(fixture: str) -> QMLState:
        if fixture == "code_written":
            # Every per-compile mint: a code-written item's skip, blank and
            # text choices, an answeredness test, a raise the lowering cannot
            # place (``loose@``) and a blank acceptance read through them.
            return create_questionnaire(
                [
                    {"id": "q_s", "input": NO_YES, "codeBlock": "q_w.outcome = 1\nq_t.outcome = 'x'\n"},
                    {"id": "q_w", "input": {"control": "Editbox", "min": 0, "max": 9},
                     "precondition": [{"predicate": "q_s.outcome == 1"}],
                     # Its blank acceptance, which a compile reading q_w's
                     # blank computes, mints an answeredness test of its own.
                     "postcondition": [{"predicate": "q_a.outcome is None or q_w.outcome in [1, 2]", "hint": "h"}]},
                    {"id": "q_t", "input": {"control": "Textarea"}},
                    {"id": "q_a", "input": {"control": "Editbox", "min": 0, "max": 9}},
                    {"id": "q_c", "input": NO_YES,
                     "precondition": [
                         {"predicate": "q_w.outcome != 2 or abs(q_w.outcome) > 3"},
                         {"predicate": "q_a.outcome is not None and q_a.outcome > 1"},
                         {"predicate": "q_t.outcome == 'x' or q_w.outcome == 1"},
                     ],
                     # No build-time acceptance reads q_w, so the first
                     # compile of q_c's gate computes q_w's acceptance.
                     "postcondition": [{"predicate": "q_c.outcome == 1 or q_a.outcome != 1", "hint": "h"}]},
                ]
            )
        if fixture != "inline":
            return _state_from_fixture(fixture)
        # Orderings on a gated answer (``none_unsafe_reference`` asks
        # ``is_guaranteed`` per reference), relational postconditions and a
        # codeBlock writer read by a later gate.
        return create_questionnaire(
            [
                {"id": "q_g", "input": NO_YES},
                {"id": "q_a", "input": {"control": "Editbox", "min": 0, "max": 9},
                 "precondition": [{"predicate": "q_g.outcome == 1"}],
                 "postcondition": [{"predicate": "q_a.outcome < 8 or q_g.outcome == 0", "hint": "h"}],
                 "codeBlock": "n = q_a.outcome + 1\n"},
                {"id": "q_c", "input": NO_YES,
                 "precondition": [{"predicate": "q_a.outcome > 3"}, {"predicate": "n >= 2"}],
                 "postcondition": [{"predicate": "q_c.outcome == 1 or q_a.outcome < 5", "hint": "h"}]},
                {"id": "q_d", "input": NO_YES,
                 "precondition": [{"predicate": "q_a.outcome > 3 and q_c.outcome == 1"}]},
            ],
            code_init="n = 0",
        )

    def _lowerings_after_the_build(self, fixture: str) -> tuple[ValidationProcessor, dict, list]:
        processor = ValidationProcessor(self._state(fixture))
        lowered: dict[tuple[str, str, str, bool, str | None], int] = {}
        original = StaticBuilder._lower_predicate

        def spy(builder, tree, context, kind, *, blank=True):
            # A blank acceptance lowers an item's postcondition with its own
            # outcome None (``_own_none``): another lowering, kept apart.
            key = (context, kind, ast.unparse(tree), blank, builder._own_none)
            lowered[key] = lowered.get(key, 0) + 1
            return original(builder, tree, context, kind, blank=blank)

        with unittest.mock.patch.object(StaticBuilder, "_lower_predicate", spy):
            issues = processor.to_issues(deep=True)
            processor.get_item_classifications()
        return processor, lowered, issues

    def test_each_condition_is_lowered_at_most_once(self):
        for fixture in self.FIXTURES:
            with self.subTest(fixture=fixture):
                _, lowered, _ = self._lowerings_after_the_build(fixture)
                self.assertTrue(lowered, "the spy saw no lowering, so it proves nothing")
                repeated = {key: n for key, n in lowered.items() if n > 1}
                self.assertEqual(repeated, {})

    def test_memoised_compiles_answer_as_uncached_ones_do(self):
        # The verdicts and the findings equal those of a processor whose cache
        # never stores, where every compile is a first one.
        class _NeverStores(dict):
            def __setitem__(self, key, value):
                pass

        for fixture in self.FIXTURES:
            with self.subTest(fixture=fixture):
                processor, _, issues = self._lowerings_after_the_build(fixture)
                uncached = ValidationProcessor(self._state(fixture))
                uncached.engine.static_builder._compiled_conditions = _NeverStores()
                self.assertEqual(issues, uncached.to_issues(deep=True))
                self.assertEqual(
                    json.dumps(processor.get_item_classifications(), sort_keys=True, default=str),
                    json.dumps(uncached.get_item_classifications(), sort_keys=True, default=str),
                )

    def test_repeated_compiles_share_exactly_what_uncached_ones_share(self):
        # A hit mints its own fresh symbols and keeps the shared ones (a
        # world choice, a cached blank acceptance, an item's open reads), so
        # every pair of same-key compiles has the same symbols in common, and
        # as many of its own, as two uncached compiles.
        class _NeverStores(dict):
            def __setitem__(self, key, value):
                pass

        for fixture in self.FIXTURES:
            with self.subTest(fixture=fixture):
                records = []
                for cache in (True, False):
                    built = ValidationProcessor(self._state(fixture)).engine.static_builder
                    if not cache:
                        built._compiled_conditions = _NeverStores()
                    record = []
                    for item_id, details in built.item_details.items():
                        for kind in ("precondition", "postcondition"):
                            conditions = details[f"{kind}s"]
                            one, two = (
                                {str(v) for v in get_vars(built.compile_conditions(item_id, conditions, kind=kind))}
                                for _ in range(2)
                            )
                            record.append((item_id, kind, sorted(one & two), len(one - two), len(two - one)))
                    records.append(record)
                self.assertEqual(records[0], records[1])
                if fixture == "code_written":
                    self.assertTrue(any(own for *_, own, _ in records[0]), "no compile minted anything")

    def test_two_compiles_conjoined_stay_independent(self):
        # An answeredness test mints a fresh Bool per compile (#1250): the two
        # compiles of one gate may see X answered and unanswered, so
        # ``P ∧ ¬P'`` holds, as it does for two uncached compiles.
        class _NeverStores(dict):
            def __setitem__(self, key, value):
                pass

        def builder(cache: bool) -> StaticBuilder:
            built = StaticBuilder(
                create_questionnaire(
                    [
                        {"id": "q_a", "input": {"control": "Editbox", "min": 0, "max": 9}},
                        {"id": "q_c", "input": NO_YES,
                         "precondition": [{"predicate": "q_a.outcome is not None and q_a.outcome > 3"}]},
                    ]
                )
            )
            if not cache:
                built._compiled_conditions = _NeverStores()
            return built

        for cache in (True, False):
            with self.subTest(cache=cache):
                built = builder(cache)
                conditions = built.item_details["q_c"]["preconditions"]
                first = built.compile_conditions("q_c", conditions, kind="precondition")
                second = built.compile_conditions("q_c", conditions, kind="precondition")
                fresh = [
                    {str(symbol) for symbol in get_vars(formula) if "#" in str(symbol)}
                    for formula in (first, second)
                ]
                self.assertTrue(fresh[0] and fresh[1])
                self.assertFalse(fresh[0] & fresh[1])
                self.assertTrue(all(built.answered_mint(name) == ("q_a", "q_c") for name in fresh[1]))
                solver = Solver(ctx=built.ctx)
                solver.add(built.get_domain_base(), first, Not(second))
                self.assertEqual(solver.check(), sat)

    def test_a_cache_hit_still_records_the_wide_gap(self):
        # compile_conditions (record_wide=False) fills the cache first; the
        # exact compile after it must still surface the inexact condition.
        builder = StaticBuilder(
            create_questionnaire(
                [
                    {"id": "q_g", "input": NO_YES},
                    {"id": "q_a", "input": {"control": "Editbox", "min": 0, "max": 9},
                     "precondition": [{"predicate": "q_g.outcome == 1"}]},
                    {"id": "q_c", "input": NO_YES, "precondition": [{"predicate": "abs(q_a.outcome) > 3"}]},
                ]
            )
        )
        conditions = builder.item_details["q_c"]["preconditions"]
        builder.coverage_gaps.pop("q_c", None)
        builder.compile_conditions("q_c", conditions, kind="precondition")
        self.assertNotIn("q_c", builder.coverage_gaps)
        _, exact = builder.compile_conditions_exactly("q_c", conditions, kind="precondition")
        self.assertFalse(exact)
        self.assertTrue(any(gap.get("wide_items") for gap in builder.coverage_gaps["q_c"]))


@pytest.mark.unit
@pytest.mark.z3
class TestStaticBuilderImportOrder(unittest.TestCase):
    """``askalot_qml.z3`` must import on its own, before ``askalot_qml.core``.

    ``askalot_qml.core``'s package __init__ imports the engine, which imports
    ``static_builder``. A module-level ``askalot_qml.core`` import in
    ``static_builder`` therefore fails whenever the z3 package loads first — and
    no in-process test can see it, because a neighbouring test has already
    imported ``core``. Each case runs in a fresh interpreter (#1140).
    """

    def _imports_cleanly(self, module: str) -> None:
        result = subprocess.run(
            [sys.executable, "-c", f"import {module}"],
            capture_output=True,
            text=True,
            timeout=120,
        )
        self.assertEqual(result.returncode, 0, result.stderr[-2000:])

    def test_z3_package_imports_first(self):
        self._imports_cleanly("askalot_qml.z3")

    def test_static_builder_imports_first(self):
        self._imports_cleanly("askalot_qml.z3.static_builder")


if __name__ == "__main__":
    unittest.main()
