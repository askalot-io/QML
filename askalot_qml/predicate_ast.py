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
    guarded: set[str] = set()
    for node in ast.walk(tree):
        if not isinstance(node, ast.Compare):
            continue
        chain = [node.left, *node.comparators]
        for index, op in enumerate(node.ops):
            if not isinstance(op, NONE_TEST_OPS):
                continue
            left, right = chain[index], chain[index + 1]
            for probe, other in ((left, right), (right, left)):
                if is_none_literal(other) and (owner := ref(probe)):
                    guarded.add(owner)
    return guarded


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
