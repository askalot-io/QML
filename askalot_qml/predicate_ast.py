"""
AST shape primitives for reading a QML predicate, shared by the runtime and
the validator.

Two layers have to agree about what a predicate says about an item's outcome:
the ``none_unsafe_reference`` lint tells an author which ``None`` guard to
write, and ``FlowProcessor`` has to honour that same guard when an item was
left unanswered (#1023). Defining "reads ``X.outcome``" and "tests ``X.outcome``
against ``None``" once is what keeps the advice and the engine from drifting.
"""

from __future__ import annotations

import ast
from collections.abc import Callable

#: Operators that TEST for None rather than raising on it. An operand compared
#: with a None literal under one of these is the author's own acknowledgement
#: that the item may have no answer.
NONE_TEST_OPS = (ast.Is, ast.IsNot, ast.Eq, ast.NotEq)


def outcome_ref_name(node: ast.AST) -> str | None:
    """The base name X iff ``node`` is exactly ``X.outcome``; else None."""
    if (
        isinstance(node, ast.Attribute)
        and node.attr == "outcome"
        and isinstance(node.value, ast.Name)
    ):
        return node.value.id
    return None


def is_none_literal(node: ast.AST) -> bool:
    return isinstance(node, ast.Constant) and node.value is None


def none_tested_outcomes(tree: ast.AST) -> set[str]:
    """Items whose ``.outcome`` the tree compares directly with ``None``.

    Walked operator by operator along a chained comparison, so only the
    operand adjacent to the ``None`` under an ``is`` / ``is not`` / ``==`` /
    ``!=`` counts — ``a.outcome == b.outcome == None`` guards ``b`` alone.
    """
    return _none_tested(tree, outcome_ref_name)


def none_tested_names(tree: ast.AST) -> set[str]:
    """Bare names (variables) the tree compares directly with ``None`` —
    ``none_tested_outcomes``' rule applied to ``v`` instead of ``X.outcome``."""
    return _none_tested(tree, lambda node: node.id if isinstance(node, ast.Name) else None)


def _none_tested(tree: ast.AST, ref: Callable[[ast.AST], str | None]) -> set[str]:
    return {owner for probe in none_test_operands(tree) if (owner := ref(probe))}


def none_test_operands(tree: ast.AST) -> list[ast.AST]:
    """Every operand the tree compares directly with a ``None`` literal under
    ``is`` / ``is not`` / ``==`` / ``!=``, either side, operator by operator."""
    operands: list[ast.AST] = []
    for node in ast.walk(tree):
        if not isinstance(node, ast.Compare):
            continue
        chain = [node.left, *node.comparators]
        for index, op in enumerate(node.ops):
            if not isinstance(op, NONE_TEST_OPS):
                continue
            left, right = chain[index], chain[index + 1]
            for probe, other in ((left, right), (right, left)):
                if is_none_literal(other):
                    operands.append(probe)
    return operands


def none_test_of(node: ast.AST) -> tuple[str, bool] | None:
    """``(X, tests_answered)`` iff ``node`` is a one-operator None test on
    ``X.outcome`` (``is not None`` / ``!= None`` test that X is answered)."""
    if not (isinstance(node, ast.Compare) and len(node.ops) == 1):
        return None
    op = node.ops[0]
    if not isinstance(op, NONE_TEST_OPS):
        return None
    left, right = node.left, node.comparators[0]
    if is_none_literal(left):
        left, right = right, left
    name = outcome_ref_name(left)
    if name is None or not is_none_literal(right):
        return None
    return name, isinstance(op, (ast.IsNot, ast.NotEq))


def none_guarded_outcomes(tree: ast.AST) -> set[str]:
    """Items whose None test in ``tree`` is the guard of every other read the
    predicate makes.

    X qualifies when it has a one-operator None test and each other
    ``X.outcome`` read, and each variable read (a variable may hold X's
    value: ``v = X.outcome``), sits in a later operand of an ``and`` that holds
    ``X is not None`` or of an ``or`` that holds ``X is None``, so Python
    reaches the read only while X is answered. A read anywhere else (before
    the test, or under ``X is None and …``) may read an unanswered X.
    """
    tested = {found[0] for node in ast.walk(tree) if (found := none_test_of(node)) is not None}
    if not tested:
        return set()

    parents: dict[int, ast.AST] = {}
    for node in ast.walk(tree):
        for child in ast.iter_child_nodes(node):
            parents[id(child)] = node
    test_operands = {
        id(operand)
        for node in ast.walk(tree)
        if none_test_of(node) is not None
        for operand in (node.left, *node.comparators)
    }

    def guarded(read: ast.AST, name: str) -> bool:
        child, parent = read, parents.get(id(read))
        while parent is not None:
            if isinstance(parent, ast.BoolOp):
                wanted = isinstance(parent.op, ast.And)
                index = next(i for i, value in enumerate(parent.values) if value is child)
                if any(
                    none_test_of(value) == (name, wanted) for value in parent.values[:index]
                ):
                    return True
            child, parent = parent, parents.get(id(parent))
        return False

    def is_variable_read(node: ast.AST) -> bool:
        if not (isinstance(node, ast.Name) and isinstance(node.ctx, ast.Load)):
            return False
        parent = parents.get(id(node))
        # ``X.outcome`` / ``math.floor`` bases and called names are not values.
        if isinstance(parent, ast.Attribute) or (isinstance(parent, ast.Call) and parent.func is node):
            return False
        return True

    qualified = set(tested)
    for node in ast.walk(tree):
        if id(node) in test_operands:
            continue
        owner = outcome_ref_name(node)
        readers = {owner} & tested if owner else (tested if is_variable_read(node) else set())
        for name in readers:
            if not guarded(node, name):
                qualified.discard(name)
    return qualified


def outcome_value_reads(tree: ast.AST) -> set[str]:
    """Items whose ``.outcome`` the tree reads as a value, outside a None test."""
    operands = {id(operand) for operand in none_test_operands(tree)}
    return {
        name
        for node in ast.walk(tree)
        if id(node) not in operands and (name := outcome_ref_name(node))
    }


def name_reads(tree: ast.AST) -> set[str]:
    """Every bare name the tree loads — variables, and item ids used as ``X.outcome`` bases."""
    return {
        node.id
        for node in ast.walk(tree)
        if isinstance(node, ast.Name) and isinstance(node.ctx, ast.Load)
    }


def outcome_reads(tree: ast.AST) -> set[str]:
    """Every item whose ``.outcome`` the tree reads."""
    return {name for node in ast.walk(tree) if (name := outcome_ref_name(node))}
