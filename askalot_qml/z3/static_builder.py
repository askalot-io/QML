"""
StaticBuilder - Z3-Driven Static Analysis for QML Questionnaires

This module provides Static Single Assignment (SSA) versioning and Z3 constraint
generation for questionnaire analysis. It builds formal models from preconditions,
postconditions, and code blocks to enable dependency discovery and verification.

Moved from processor/ to z3/ as it belongs with other Z3 constraint solving utilities.
"""

import ast
import enum
import functools
import itertools
import logging
from collections.abc import Callable
from dataclasses import dataclass
from typing import Any, Literal

from askalot_common.profiling import profile_block
from z3 import (
    And,
    Bool,
    BoolRef,
    BoolVal,
    Context,
    Distinct,
    ExprRef,
    If,
    Implies,
    Int,
    IntVal,
    Not,
    Or,
    Sum,
    is_false,
    is_true,
    simplify,
    substitute,
)

from askalot_qml.models.qml_state import QMLState
from askalot_qml.predicate_ast import (
    name_reads,
    none_guarded_outcomes,
    none_test_of,
    none_test_operands,
    none_tested_names,
    none_tested_outcomes,
    outcome_reads,
    outcome_ref_name,
)

#: The prefix of the Bool a None test mints per predicate (``_lower_none_test``):
#: ``answered@{item_id}#{n}``; ``StaticBuilder.answered_mint`` says what each was minted for.
ANSWERED_PREFIX = "answered@"


def _is_str_literal(node: ast.AST) -> bool:
    """Whether ``node`` is a string constant."""
    return isinstance(node, ast.Constant) and isinstance(node.value, str)


#: What a value may hold at runtime (``_StringModel``): a number, ``None``
#: (the None model holds it), one of the questionnaire's string literals, or
#: anything (a call, an unpacking, a loop target, a name no code assigns).
_NUM, _NONE, _STR, _ANY = "num", "none", "str", "any"

#: What a store or a read holds where nothing is known of it.
_UNKNOWN = frozenset({_ANY})

#: Builtins that answer a number or raise, whatever they are given.
_NUMERIC_CALLS = frozenset({"abs", "bool", "int", "len", "round", "sum"})


class _Operand(enum.Enum):
    """How a comparison with a string literal lowers through its operand
    (``_StringModel.operand``)."""

    #: It holds no string: ``==`` a string is False, ``!=`` True.
    DECIDED = "decided"
    #: A variable that may hold text, its value encoded (``_StringModel``):
    #: compared exactly.
    ENCODED = "encoded"
    #: Its value is not held exactly: the comparison is a free Bool.
    UNDECIDED = "undecided"
    #: A Textarea's text (``_text_leaf``).
    TEXT = "text"


class _CompareKind(enum.Enum):
    """What ``StaticBuilder._string_comparison`` found."""

    #: No text involved: the comparison lowers as numbers.
    NONE = "none"
    #: Text involved in a way the model does not lower; reported (``Str``).
    REFUSED = "refused"
    #: Two literals: ``truth`` is Python's answer.
    FOLDED = "folded"
    #: A comparison of ``operand`` with ``texts`` (and ``members``).
    COMPARE = "compare"
    #: A chain holding text: the conjunction of its ``parts``, one
    #: comparison per pair of neighbouring operands, as Python reads it.
    CHAIN = "chain"


@dataclass(frozen=True)
class _StringComparison:
    """One reading of a comparison involving text, shared by the lowering and
    the report (``StaticBuilder._string_comparison``)."""

    kind: _CompareKind
    truth: bool = False
    negated: bool = False
    operand: ast.AST | None = None
    members: tuple[ast.expr, ...] = ()
    texts: frozenset[str] = frozenset()
    how: _Operand | None = None
    parts: tuple[ast.Compare, ...] = ()


_NO_STRING = _StringComparison(_CompareKind.NONE)
_REFUSED_COMPARISON = _StringComparison(_CompareKind.REFUSED)


class _StringModel:
    """Text in the Z3 model, read once from the questionnaire's code.

    No bound separates text from numbers. A variable that may hold text (its
    profile holds ``_STR``) carries its value encoded in its Int: the number
    ``n`` as ``2 * n`` and the questionnaire's ``k``-th string literal (in
    sorted order) as ``2 * k + 1``. So a string never equals a number, two
    strings are equal exactly when their text is, ``""`` is the one falsy
    string, and nothing depends on ``hash()`` or on how large a number gets.
    Arithmetic, a call or an ordering over such a value does not lower
    (``StaticBuilder._carries_string``): Python raises there or computes text.
    A value that may hold anything is never encoded: copied into such a
    variable it leaves that version unconstrained (``StaticBuilder._encode``).

    What each variable, and each answer a codeBlock or codeInit stores into,
    may hold is read off the code, flow-insensitively: every store once, then
    a fixed point over those stores while a name no code assigns adds nothing,
    then another where it holds anything. ``None`` is a kind of its own: the
    None model holds it, so storing it frees nothing. An answer, or one matrix
    cell (by its literal subscript path), that a store may put text or
    anything unknown into (``text_stored``) is no longer bound by its domain:
    every read of it is one free Int (``StaticBuilder._unmodelled_read``). A
    store through a path that is no literal reaches every cell of the item.

    ``degraded`` is the model when reading the code failed. It reads nothing
    but the item ids, so it cannot fail the same way again: no variable is
    encoded and every answer is ``text_stored``, so every comparison with text
    is undecided and every read of an answer free, each reported.
    """

    def __init__(self, builder: StaticBuilder, *, degraded: bool = False) -> None:
        self.degraded = degraded
        self._items = set(builder.item_details)
        self._variables: dict[str, set[str]] = {}
        self._outcomes: dict[str, set[str]] = {}
        # item -> literal subscript path -> what stores put into that cell
        self._cells: dict[str, dict[tuple[int, ...], set[str]]] = {}
        if degraded:
            self._texts: set[str] = set()
            self._index = {"": 0}
            self._outcomes = {item_id: set(_UNKNOWN) for item_id in self._items}
            self._freeze()
            self._bound: frozenset[str] = frozenset()
            return
        self._texts = {item_id for item_id in self._items if builder._is_textarea(item_id)}
        trees = builder._code_trees()
        strings = {""}
        for tree in trees:
            for node in ast.walk(tree):
                if _is_str_literal(node):
                    strings.add(node.value)  # type: ignore[attr-defined]
        self._index = {text: i for i, text in enumerate(sorted(strings))}
        self._profile(trees, builder)
        self._freeze()
        self._bound = self._bound_from_the_start(builder, trees)

    def text_value(self, text: str) -> int:
        """The encoded Int of string literal ``text`` (``2 * k + 1``)."""
        if text not in self._index:
            self._index[text] = len(self._index)
        return 2 * self._index[text] + 1

    def encoded(self, name: str) -> bool:
        """Whether variable ``name`` carries its value encoded."""
        return _STR in self._variables.get(name, ())

    def text_stored(self, item_id: str, path: tuple[int, ...] | None = None) -> bool:
        """Whether a store may put text, or anything not known to be a number
        or ``None``, into ``item_id``'s answer: into the part at ``path`` (a
        store at a prefix of it, a whole row, reaches it, and so does one
        below it, for a read of a row), or, for ``None``, into any part of it.
        Read from the sets ``_freeze`` computes once."""
        if item_id in self._stored_items:
            return True
        return any(path is None or _overlaps(stored, path) for stored in self._stored_cells.get(item_id, ()))

    def always_bound(self, name: str) -> bool:
        """Whether variable ``name`` is bound wherever a condition reads it:
        codeInit assigns it in its leading run of top-level assignments that
        cannot raise, and no code deletes it."""
        return name in self._bound

    def assigned(self, name: str) -> bool:
        """Whether some code assigns variable ``name``."""
        return name in self._variables

    def number_only(self, node: ast.AST, local: Any = frozenset()) -> bool:
        """Whether ``node`` provably holds a number or ``None``, never text."""
        return self._kinds(node, local, complete=True) <= {_NUM, _NONE}

    @staticmethod
    def _bound_from_the_start(builder: StaticBuilder, trees: list[ast.AST]) -> frozenset[str]:
        """The names ``always_bound`` holds: codeInit's leading top-level
        assignments of literals (or of a name already bound), which cannot
        raise, less any name code deletes."""
        bound: set[str] = set()
        init = builder._parsed(builder.state.get_code_init() or "", "exec")

        def safe(value: ast.AST) -> bool:
            if isinstance(value, ast.Name):
                return value.id in bound
            if isinstance(value, (ast.List, ast.Tuple, ast.Set)):
                return all(safe(elt) for elt in value.elts)
            try:
                ast.literal_eval(value)
            except (ValueError, TypeError, SyntaxError, MemoryError, RecursionError):
                return False
            return True

        for statement in getattr(init, "body", []):
            targets = statement.targets if isinstance(statement, ast.Assign) else [getattr(statement, "target", None)]
            value = getattr(statement, "value", None)
            if (
                not isinstance(statement, (ast.Assign, ast.AnnAssign))
                or value is None
                or not all(isinstance(t, ast.Name) for t in targets)
                or not safe(value)
            ):
                break
            bound.update(t.id for t in targets)  # type: ignore[union-attr]
        deleted = {
            node.id for tree in trees for node in ast.walk(tree) if isinstance(node, ast.Name) and isinstance(node.ctx, ast.Del)
        }
        return frozenset(bound - deleted)

    def _held_at(self, item_id: str, path: tuple[int, ...] | None) -> set[str]:
        """What the profiles so far put into ``item_id``'s answer at ``path``
        (``text_stored``'s reading while the fixed point grows them)."""
        held = set(self._outcomes.get(item_id, ()))
        for stored, kinds in self._cells.get(item_id, {}).items():
            if path is None or _overlaps(stored, path):
                held |= kinds
        return held

    def _freeze(self) -> None:
        """The items and cell paths text may be stored into, once the
        profiles are complete."""
        self._stored_items = frozenset(
            item_id for item_id, kinds in self._outcomes.items() if kinds & {_STR, _ANY}
        )
        self._stored_cells = {
            item_id: tuple(path for path, kinds in cells.items() if kinds & {_STR, _ANY})
            for item_id, cells in self._cells.items()
        }

    def holds_any(self, node: ast.AST, local: Any = frozenset()) -> bool:
        """Whether ``node`` may hold a value the model knows nothing of."""
        return _ANY in self._kinds(node, local, complete=True)

    @staticmethod
    def read_path(node: ast.AST, local: Any = frozenset()) -> tuple[int, ...] | None:
        """The literal subscript path of an answer read (a comprehension index
        resolves through ``local`` when it holds values), or ``None`` for a
        read of the whole answer or where an index is not known."""
        while isinstance(node, ast.Attribute) and node.attr in _RANGE_ENDS:
            node = node.value
        path: list[int] = []
        while isinstance(node, ast.Subscript):
            index = node.slice
            value = _int_literal(index)
            if value is None and isinstance(index, ast.Name) and isinstance(local, dict):
                bound = local.get(index.id)
                value = bound if type(bound) is int else None
            if value is None:
                return None
            path.append(value)
            node = node.value
        return tuple(reversed(path)) if path else None

    def _profile(self, trees: list[ast.AST], builder: StaticBuilder) -> None:
        """What each variable, answer and literal-path cell may hold."""
        # (table, key, the stored value or None for anything): table "var"
        # keys a name, "item" an item id (None for every item), "cell" an
        # (item id, path) pair.
        stores: list[tuple[str, Any, ast.AST | None]] = []

        def target(node: ast.AST, value: ast.AST | None) -> None:
            if isinstance(node, (ast.Tuple, ast.List)):
                # ``a, b = 1, x`` pairs element by element; any other
                # unpacking stores what the model cannot see.
                paired = (
                    isinstance(value, (ast.Tuple, ast.List))
                    and len(value.elts) == len(node.elts)
                    and not any(isinstance(e, ast.Starred) for e in [*node.elts, *value.elts])
                )
                for i, elt in enumerate(node.elts):
                    target(elt, value.elts[i] if paired else None)  # type: ignore[union-attr]
                return
            if isinstance(node, ast.Starred):
                target(node.value, None)
                return
            if isinstance(node, ast.Subscript):
                item, indices = builder._outcome_subscript(node)
                if item is not None and item in self._items:
                    path = tuple(_int_literal(index) for index in indices)
                    if None in path:
                        stores.append(("item", item, value))
                    else:
                        stores.append(("cell", (item, path), value))
                    return
            items = builder._stored_outcomes(node)
            if items:
                # A store through anything but an item id may write any item.
                stores.extend(("item", item if item in self._items else None, value) for item in items)
                return
            if isinstance(node, ast.Name):
                stores.append(("var", node.id, value))
                return
            while isinstance(node, (ast.Subscript, ast.Attribute)):
                node = node.value
            if isinstance(node, ast.Name):
                stores.append(("var", node.id, None))

        for tree in trees:
            for node in ast.walk(tree):
                if isinstance(node, ast.Assign):
                    for each in node.targets:
                        target(each, node.value)
                elif isinstance(node, ast.AnnAssign) and node.value is not None:
                    target(node.target, node.value)
                elif isinstance(node, ast.AugAssign):
                    target(node.target, ast.BinOp(left=node.target, op=node.op, right=node.value))
                elif isinstance(node, ast.NamedExpr):
                    target(node.target, node.value)
                elif isinstance(node, (ast.For, ast.AsyncFor)):
                    target(node.target, None)
                elif isinstance(node, ast.withitem) and node.optional_vars is not None:
                    target(node.optional_vars, None)
                elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
                    stores.append(("var", node.name, None))
                elif isinstance(node, (ast.ExceptHandler, ast.MatchAs, ast.MatchStar)) and node.name:
                    stores.append(("var", node.name, None))
                elif isinstance(node, ast.MatchMapping) and node.rest:
                    stores.append(("var", node.rest, None))

        def holders(table: str, key: Any) -> list[set[str]]:
            if table == "var":
                return [self._variables.setdefault(key, set())]
            if table == "cell":
                item, path = key
                return [self._cells.setdefault(item, {}).setdefault(path, set())]
            return [self._outcomes.setdefault(each, set()) for each in ([key] if key is not None else sorted(self._items))]

        for complete in (False, True):
            changed = True
            while changed:
                changed = False
                for table, key, value in stores:
                    kinds = set(_UNKNOWN) if value is None else self._kinds(value, complete=complete)
                    for held in holders(table, key):
                        if not kinds <= held:
                            held |= kinds
                            changed = True

    def _kinds(self, node: ast.AST, local: Any = frozenset(), *, complete: bool) -> set[str]:
        """What ``node`` may hold at runtime, as the profiles know it so far. A
        name no code assigns holds nothing while they grow (``complete``
        False) and anything once they are complete."""
        if isinstance(node, ast.Constant):
            if isinstance(node.value, str):
                return {_STR}
            return {_NONE} if node.value is None else {_NUM}
        if isinstance(node, ast.Name):
            if node.id in local:
                return {_NUM}
            held = self._variables.get(node.id)
            if not held:
                return set(_UNKNOWN) if complete else set()
            return set(held)
        item = _answer_root(node)
        if item is not None and item in self._items:
            if item in self._texts:
                return set(_UNKNOWN)
            held = self._held_at(item, self.read_path(node, local))
            return {_NUM} | (set(_UNKNOWN) if held & {_STR, _ANY} else set())
        recurse = functools.partial(self._kinds, local=local, complete=complete)
        if isinstance(node, ast.IfExp):
            return recurse(node.body) | recurse(node.orelse)
        if isinstance(node, ast.BoolOp):
            return set().union(*(recurse(v) for v in node.values))
        if isinstance(node, ast.Compare) or (isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.Not)):
            return {_NUM}
        if isinstance(node, (ast.BinOp, ast.UnaryOp)):
            parts = [node.left, node.right] if isinstance(node, ast.BinOp) else [node.operand]
            held = set().union(*(recurse(p) for p in parts))
            return set(_UNKNOWN) if held & {_STR, _ANY} else {_NUM}
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id in ("min", "max"):
            # One of its arguments (or of the one list it is given).
            args = [e for a in node.args for e in (a.elts if isinstance(a, (ast.List, ast.Tuple)) else [a])]
            return set().union(*(recurse(a) for a in args)) if args else set(_UNKNOWN)
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id in _NUMERIC_CALLS:
            return {_NUM}
        if (
            isinstance(node, ast.Call)
            and isinstance(node.func, ast.Attribute)
            and isinstance(node.func.value, ast.Name)
            and node.func.value.id == "math"
        ):
            return {_NUM}
        return set(_UNKNOWN)

    def operand(self, node: ast.AST, local: Any = frozenset()) -> _Operand | None:
        """How a comparison of ``node`` with a string literal lowers, or
        ``None`` for an operand that is no name, answer read or arithmetic
        over those, which does not lower."""
        item = _answer_root(node)
        if item is not None and item in self._texts:
            return _Operand.TEXT
        if item is not None and item in self._items:
            return _Operand.UNDECIDED if self.text_stored(item, self.read_path(node, local)) else _Operand.DECIDED
        if isinstance(node, ast.Name):
            if node.id in local:
                return _Operand.DECIDED
            held = self._variables.get(node.id) or _UNKNOWN
            if _STR in held:
                return _Operand.ENCODED
            return _Operand.UNDECIDED if _ANY in held else _Operand.DECIDED
        if isinstance(node, (ast.BinOp, ast.UnaryOp)):
            return None if self._kinds(node, local, complete=True) & {_STR, _ANY} else _Operand.DECIDED
        return None


def _overlaps(stored: tuple[int, ...], read: tuple[int, ...]) -> bool:
    """Whether a store at subscript path ``stored`` reaches a read at
    ``read``: one is a prefix of the other."""
    n = min(len(stored), len(read))
    return stored[:n] == read[:n]


def _answer_root(node: ast.AST) -> str | None:
    """The item whose answer ``node`` reads: X for ``X.outcome``, a subscript
    of it (a matrix cell, a QuestionGroup answer) or a Range end of either;
    else ``None``."""
    while (isinstance(node, ast.Attribute) and node.attr in _RANGE_ENDS) or isinstance(node, ast.Subscript):
        node = node.value
    return outcome_ref_name(node)


def _int_literal(node: ast.AST) -> int | None:
    """The value of an integer literal (not a bool), else ``None``."""
    if isinstance(node, ast.Constant) and type(node.value) is int:
        return node.value
    return None


def _z3_division_agrees(op: ast.operator, divisor: ast.AST) -> bool:
    """Whether Z3's Int reading of ``op`` agrees with Python's (#1767).

    Python's ``//`` / ``%`` floor toward the divisor's sign while Z3's div /
    mod are Euclidean (``1 // -2`` is -1 in Python, 0 in Z3); the two agree
    only for a positive divisor, so they lower only by a positive integer
    literal. ``/`` never lowers: the loader refuses it (#1813), and a model
    built without the loader reports it as a gap rather than reading it as
    Int division. Every other operator is no division and agrees.
    """
    if isinstance(op, ast.Div):
        return False
    if isinstance(op, (ast.FloorDiv, ast.Mod)):
        value = _int_literal(divisor)
        return value is not None and value > 0
    return True



def _masked(value: ExprRef, mask: int) -> ExprRef:
    """``value & mask`` for a non-negative ``mask``, as linear arithmetic
    (#2037): the sum over the mask's set bits ``j`` of
    ``((value / 2**j) % 2) * 2**j``. Z3's div / mod by a positive literal
    floor as Python does, so each term reads the bit Python's two's-complement
    ``&`` reads, also for a negative ``value``."""
    weights = [1 << j for j in range(mask.bit_length()) if mask >> j & 1]
    return Sum([((value / w) % 2) * w for w in weights]) if weights else IntVal(0, value.ctx)


def _gated_write(
    current: ExprRef, value: ExprRef | None, before: ExprRef | None, ran: BoolRef
) -> list[BoolRef]:
    """One codeBlock write of SSA version ``current`` as the walk sees it
    (#1994): ``value`` where the block ran, ``before`` (the version it found)
    where it did not. A side the model does not know (an unlowered value, no
    earlier version) is left free; an ungated writer (``ran`` True) always
    writes. Shared by the full base and ``_accumulator_reachability``."""
    if is_true(ran):
        return [current == value] if value is not None else []
    if value is not None and before is not None:
        return [current == If(ran, value, before)]
    if value is not None:
        return [Implies(ran, current == value)]
    if before is not None:
        return [Implies(Not(ran), current == before)]
    return []


def _scoped_name(item_id: str, *scope: object) -> str:
    """Z3 name of one part of an item's answer: ``item_{id}@{scope…}``.

    ``@`` cannot appear in a Python identifier, and the loader refuses any
    other item id (``_validate_reserved_item_ids``). Separating the id and
    every scope part with it keeps every derived name apart from every item's
    own scalar ``item_{id}`` and from every other item's derived names: a
    matrix ``m``'s cell ``item_m@0@0`` cannot alias a Question ``m_0_0``
    (``item_m_0_0``), nor a Roster ``q``'s iteration
    ``item_q@iter2`` a Question ``q_iter2`` (#1783). The forms are
    ``item_m@{r}@{c}`` (matrix cell), ``item_qg@{i}`` (QuestionGroup answer),
    ``item_q@iter{K}`` (Roster iteration) and ``item_q@group0`` (capped Group).
    """
    return "@".join(["item_" + item_id, *(str(part) for part in scope)])


# The declared list an item attribute names, and the ``item_details`` key
# holding its length: what ``len(m.rows)`` is at build time. ItemProxy exposes
# the same three lists at runtime (#1782), only on the kind that declares them.
_DECLARED_LIST_LENGTHS = {"rows": "rows_len", "columns": "cols_len", "questions": "questions_len"}


def _ssa_symbol(var_name: str, version: int) -> str:
    """Z3 name of one SSA version of a codeInit / codeBlock variable:
    ``var@{name}@{n}``.

    Z3 ``Int``s of one name are one variable, and a variable may be named
    anything an identifier can be, ``item_q`` included, so ``{name}_{n}`` would
    make version 0 of a variable ``item_q`` Question ``q_0``'s answer
    ``item_q_0`` (#1798). ``@`` cannot occur in an identifier. ``z3_vars``
    stays keyed ``{name}_{n}``, the name a witness shows the author.
    """
    return f"var@{var_name}@{version}"


def _ssa_key(var_name: str, version: int) -> str:
    """``z3_vars`` key of one SSA version, ``{name}_{n}``: what a witness
    shows the author, never a Z3 name (``_ssa_symbol``)."""
    return f"{var_name}_{version}"


def _range_end_names(item_id: str, *scope: object) -> tuple[str, str]:
    """Z3 names of a Range pair's two ends: ``item_{id}@{scope…}@lo`` / ``@hi``.

    The pair of ``_scoped_name``: ``item_q@lo`` (Question), ``item_q@iter2@lo``
    (Roster iteration), ``item_q@group0@lo`` (capped Group), ``item_m@1@2@lo``
    (matrix cell), so a Range end aliases neither an independent item ``q_lo``
    nor the ends of another Range shape.
    """
    base = _scoped_name(item_id, *scope)
    return f"{base}@lo", f"{base}@hi"


class _UnmodelledAnswerRead(Exception):
    """A QuestionGroup answer (#184), matrix cell (#1780) or skippable scalar
    Question (#1867) read the None model cannot place: the predicate is left
    unlowered, a coverage gap (``_unlowered_group_reads`` /
    ``_unlowered_matrix_reads`` / ``_ternary_refusals``)."""


class _CodeReads:
    """How one item's codeBlock reads the items that may be ``None`` when it
    runs (#1776): a gated or scoped Question it was skipped
    (``_skipped_choice``), any Question left blank (``_blank_choice``, the
    block's own item included: it runs after the item was submitted). Both
    read Python's ``None`` there, but the runtime marks a variable computed
    from a blank item unknown (#1044, ``_unknown_after``), so a later leaf
    reading it is unknown: under the blank choice such a variable is a fresh
    unconstrained Int (``guarded``, #1848), and the mark itself is modelled
    by ``_UnknownMarks`` (#1844). A world with both choices true is blank, as in
    conditions. A Textarea's text is opaque here (no Int holds it), but it is
    ``None`` when blank or skipped, so its reads are classed too, under a free
    choice: ``len(t.outcome)`` may stop the block. An annotation
    (``x: <expr> = v``) is never evaluated (deferred on Python 3.14, stripped
    by the runner), so it reads nothing.

    Each read of such an item is classed by what Python does with its
    ``None`` (``_effect``):

    - ``safe``: ``==`` / ``!=`` / ``in`` a literal list / a truth test, which
      the value's lowering answers with the item's None choice
      (``choices``, read by ``_skip_aware_equality`` / ``_skipped_operand``);
    - ``copy``: the read is (a ternary branch of) the assigned value, so the
      target may hold ``None``;
    - ``raise``: an ordering or arithmetic read, which raises
      ``CodeExecutionError``; the block stops there and keeps what it
      assigned before (``FlowProcessor._execute_code_block``);
    - ``other``: the ``None`` flows into a call, a container, a subscript or
      a comprehension, which may raise or not; a ternary branch whose value
      is read the ``safe`` way is ``other`` too, since only a direct read's
      ``None`` is lowered Python's way (#1847).
    - ``flow``: a variable this block assigned a ``None`` (``_none_vars``)
      read the ``safe`` way: Python compares the ``None`` (``None == None``
      holds), the model an unconstrained Int, so the value is not trusted.

    A variable assigned a ``copy`` / ``other`` read may hold ``None``
    (``_none_vars``, #1847), so a later read of it in this block is classed
    like an item read, under the choices that put the ``None`` there.

    An assignment then lowers as ``If(stop, old, If(flows, unknown, value))``
    (``guarded``), inside ``If(tainted, unknown, ...)`` for a variable target:
    ``tainted`` is a blank choice of an item its value or an enclosing
    ``if`` / ``while`` / ``for`` test reads, what ``_unknown_after`` marks
    (a mark is set even when the assignment raised). ``stop`` is a raise in an earlier top-level statement or
    in its own; ``flows`` a ``copy`` / ``other`` read in its value, whose
    ``None`` no Int holds, so the target is a fresh unconstrained Int there.
    A raise is exact (its Bool is the reads' None choices) only for a read in
    a simple top-level statement that is certainly evaluated
    (``_certainly_evaluated``); anywhere else its statement gets a free Bool
    bounded by the choices that may cause it, wider and never narrower. A
    raise is ordered by the top-level statement holding it; which branch of a
    compound statement ran is the builder's path condition (#1843,
    ``_lower_code_statements``), not this class's.

    codeInit gets no model: no item is answered when it runs.
    """

    _COMPOUND = (ast.If, ast.For, ast.AsyncFor, ast.While, ast.With, ast.AsyncWith, ast.Try, ast.Match)
    _TRUTH_STATEMENTS = (ast.If, ast.While, ast.Assert)

    def __init__(self, builder: StaticBuilder, tree: ast.Module, context_id: str, parents: dict):
        self._builder = builder
        self._context = context_id
        self._parents = parents
        self.choices: dict[str, BoolRef] = {}
        self._blank: dict[str, BoolRef] = {}
        # id(statement) -> [(read, effect, certainly evaluated, None choice)]
        self._reads: dict[int, list[tuple[ast.AST, str, bool, BoolRef]]] = {}
        # Variables this block assigned a value that may be ``None`` -> when.
        self._none_vars: dict[str, BoolRef] = {}
        # id(nested marking statement) -> the Bool its branch path is tied to.
        self._mark_ran: dict[int, BoolRef] = {}
        self._top: dict[int, int] = {}
        self._raised: dict[int, BoolRef | None] = {}
        # id(compound statement) -> whether it raised (``_top_level_raise``).
        self._compound_raised: dict[int, BoolRef | None] = {}
        self._top_level = {id(statement) for statement in tree.body}
        if context_id == "__init__":
            self._halted_before: list[BoolRef | None] = [None] * len(tree.body)
            return
        none_tested = {id(operand) for operand in none_test_operands(tree)}
        loads = [
            (node, item_id)
            for node in ast.walk(tree)
            if (item_id := outcome_ref_name(node)) is not None
            and isinstance(node.ctx, ast.Load)
            and (item_id in builder.item_vars or builder._is_textarea(item_id))
            and id(node) not in none_tested
            and not self._in_annotation(node)
        ]
        for item_id in sorted({item_id for _, item_id in loads}):
            choice = self._none_choice(item_id)
            if choice is not None:
                self.choices[item_id] = choice
        for index, statement in enumerate(tree.body):
            for node in ast.walk(statement):
                self._top[id(node)] = index
        for node, item_id in loads:
            if item_id not in self.choices:
                continue
            statement = self._statement_of(node)
            self._reads.setdefault(id(statement), []).append(
                (node, self._effect(node), self._certainly_evaluated(node), self.choices[item_id])
            )
        if self.choices:
            self._read_none_vars(tree, none_tested)
        halted: list[BoolRef | None] = []
        before: BoolRef | None = None
        for statement in tree.body:
            halted.append(before)
            raised = self._top_level_raise(statement)
            if raised is not None:
                before = raised if before is None else Or(before, raised)
        self._halted_before = halted

    def _read_none_vars(self, tree: ast.Module, none_tested: set[int]) -> None:
        """Record, in source order, the variables a statement assigns a value
        that may be ``None`` (a ``copy`` / ``other`` read in it), and every
        later read of one in this block as a read under the choices that put
        the ``None`` there (#1847), a nested one only on the path it ran
        (``mark_ran``). A top-level reassignment from a value that
        carries no ``None`` clears the mark (it always runs once reached, and a
        block that raised before it runs nothing later); one nested in a
        branch or loop keeps it, since which branch ran is not tracked here.
        An augmented assignment reads its target: a raise where it may be
        ``None``, and the mark stays."""
        statements = sorted(
            (n for n in ast.walk(tree) if isinstance(n, ast.stmt)), key=lambda n: (n.lineno, n.col_offset)
        )
        for statement in statements:
            if self._none_vars:
                for node in ast.walk(statement):
                    if (
                        isinstance(node, ast.Name)
                        and isinstance(node.ctx, ast.Load)
                        and node.id in self._none_vars
                        and id(node) not in none_tested
                        and self._statement_of(node) is statement
                        and not self._in_annotation(node)
                    ):
                        effect = self._effect(node)
                        self._reads.setdefault(id(statement), []).append(
                            (
                                node,
                                "flow" if effect == "safe" else effect,
                                self._certainly_evaluated(node),
                                self._none_vars[node.id],
                            )
                        )
            if not isinstance(statement, (ast.Assign, ast.AnnAssign, ast.AugAssign)) or statement.value is None:
                continue
            if isinstance(statement, ast.AugAssign):
                # ``x += 1`` reads ``x``: on a ``None`` it raises (the block
                # stops), and on success ``x`` is a number again only where it
                # was one, so the mark stays.
                target = statement.target
                if isinstance(target, ast.Name) and target.id in self._none_vars:
                    self._reads.setdefault(id(statement), []).append(
                        (target, "raise", True, self._none_vars[target.id])
                    )
                continue
            carried = [
                choice
                for node, effect, _, choice in self._reads.get(id(statement), [])
                if effect in ("copy", "other") and self._within(node, statement.value)
            ]
            targets = statement.targets if isinstance(statement, ast.Assign) else [statement.target]
            names = [name.id for target in targets for name in ast.walk(target) if isinstance(name, ast.Name)]
            if not carried:
                if id(statement) in self._top_level:
                    for name in names:
                        self._none_vars.pop(name, None)
                continue
            mark = self._builder._disjoin(carried)
            if id(statement) not in self._top_level:
                # Nested: the mark holds only where the assignment ran, its
                # branch path, which the lowering ties to ``ran`` once it is
                # known (``mark_ran``); never lowered (inside a loop), ``ran``
                # stays free, wider.
                self._builder._code_raise_count += 1
                ran = Bool(f"marked@{self._context}#{self._builder._code_raise_count}", self._builder.ctx)
                self._mark_ran[id(statement)] = ran
                mark = And(ran, mark)
            for name in names:
                earlier = self._none_vars.get(name)
                self._none_vars[name] = mark if earlier is None else Or(earlier, mark)

    def mark_ran(self, statement: ast.stmt, path: BoolRef | None) -> None:
        """Tie a nested statement's ``None`` mark to the path it ran on
        (``_lower_code_statements``): ``if False: x = q.outcome`` marks nothing."""
        ran = self._mark_ran.get(id(statement))
        if ran is not None:
            self._builder.codeblock_constraints.append(ran == (path if path is not None else BoolVal(True, self._builder.ctx)))

    def _none_choice(self, item_id: str) -> BoolRef | None:
        """When ``item_id`` reads ``None`` in this block: skipped or blank. A
        Textarea's text is opaque (no Int stands for it, ``_ast_to_z3``), so only
        its raises need the choice: a free Bool, the block's own Textarea
        included (it may be submitted blank)."""
        builder = self._builder
        if builder._is_textarea(item_id):
            builder._code_raise_count += 1
            # ``@`` cannot occur in an item id, so no item or variable shares the name.
            return Bool(f"none@{item_id}#{builder._code_raise_count}", builder.ctx)
        parts = []
        if builder._may_be_skipped(item_id, self._context):
            parts.append(builder._skipped_choice(item_id))
        if builder._blank_candidate(item_id):
            self._blank[item_id] = builder._blank_choice(item_id)
            parts.append(self._blank[item_id])
        return builder._disjoin(parts) if parts else None

    def _in_annotation(self, node: ast.AST) -> bool:
        """Whether ``node`` is inside an ``AnnAssign`` annotation."""
        child, parent = node, self._parents.get(node)
        while parent is not None:
            if isinstance(parent, ast.AnnAssign) and parent.annotation is child:
                return True
            child, parent = parent, self._parents.get(parent)
        return False

    def _statement_of(self, node: ast.AST) -> ast.stmt:
        while not isinstance(node, ast.stmt):
            node = self._parents[node]
        return node

    def _effect(self, node: ast.AST) -> str:
        """``safe`` / ``copy`` / ``raise`` / ``other``: what Python does with
        ``node``'s ``None`` (see the class docstring)."""
        parent = self._parents.get(node)
        if isinstance(parent, ast.BinOp) or (isinstance(parent, ast.UnaryOp) and not isinstance(parent.op, ast.Not)):
            return "raise"
        if isinstance(parent, ast.AugAssign):
            return "raise" if parent.value is node else "other"
        if isinstance(parent, (ast.Assign, ast.AnnAssign)):
            return "copy" if parent.value is node else "other"
        if isinstance(parent, self._TRUTH_STATEMENTS):
            return "safe" if parent.test is node else "other"
        if isinstance(parent, ast.IfExp) and parent.test is not node:
            # A branch's value is the ternary's; only a direct read's None is
            # lowered Python's way, so one compared or truth-tested through
            # the ternary is not (#1847).
            effect = self._effect(parent)
            return "other" if effect == "safe" else effect
        if isinstance(parent, ast.BoolOp):
            # ``a or b`` yields an operand's value unless its truth is all that is read.
            top = parent
            while isinstance(self._parents.get(top), ast.BoolOp):
                top = self._parents[top]
            holder = self._parents.get(top)
            truth = (
                (isinstance(holder, (ast.IfExp, *self._TRUTH_STATEMENTS)) and holder.test is top)
                or (isinstance(holder, ast.UnaryOp) and isinstance(holder.op, ast.Not))
            )
            return "safe" if truth else "other"
        if isinstance(parent, ast.stmt):
            return "other"
        if StaticBuilder._none_safe_read(node, self._parents):
            return "safe"
        if isinstance(parent, ast.Compare):
            chain = [parent.left, *parent.comparators]
            position = next(i for i, operand in enumerate(chain) if operand is node)
            touching = parent.ops[max(position - 1, 0) : position + 1]
            if all(isinstance(op, (ast.Lt, ast.LtE, ast.Gt, ast.GtE)) for op in touching):
                return "raise"
        return "other"

    def _certainly_evaluated(self, node: ast.AST) -> bool:
        """Whether Python evaluates ``node`` whenever its statement runs: not
        in a ternary branch, a later ``and`` / ``or`` operand, a later link of
        a comparison chain, a comprehension or a lambda."""
        child, parent = node, self._parents.get(node)
        while parent is not None and not isinstance(parent, ast.stmt):
            if isinstance(parent, ast.IfExp) and parent.test is not child:
                return False
            if isinstance(parent, ast.BoolOp) and parent.values[0] is not child:
                return False
            if isinstance(parent, ast.Compare) and child is not parent.left and child is not parent.comparators[0]:
                return False
            if isinstance(
                parent, (ast.comprehension, ast.ListComp, ast.SetComp, ast.DictComp, ast.GeneratorExp, ast.Lambda)
            ):
                return False
            child, parent = parent, self._parents.get(parent)
        return True

    def _bounded_raise(self, certain: list[BoolRef], possible: list[BoolRef]) -> BoolRef | None:
        """A raise that holds whenever ``certain`` does and only when one of
        ``certain + possible`` does: their disjunction when ``possible`` is
        empty (exact), else a fresh Bool between the two."""
        builder = self._builder
        if not possible:
            return builder._disjoin(certain) if certain else None
        builder._code_raise_count += 1
        # ``@`` cannot occur in an item id, so no item or variable shares the name.
        raised = Bool(f"raised@{self._context}#{builder._code_raise_count}", builder.ctx)
        if certain:
            builder.codeblock_constraints.append(Implies(builder._disjoin(certain), raised))
        builder.codeblock_constraints.append(Implies(raised, builder._disjoin(certain + possible)))
        return raised

    def _statement_raise(self, statement: ast.stmt) -> BoolRef | None:
        """Whether a simple statement raised on a ``None`` read."""
        if id(statement) not in self._raised:
            certain_ok = id(statement) in self._top_level
            certain, possible = [], []
            for _, effect, evaluated, choice in self._reads.get(id(statement), []):
                if effect == "raise" and evaluated and certain_ok:
                    certain.append(choice)
                elif effect in ("raise", "other"):
                    possible.append(choice)
            self._raised[id(statement)] = self._bounded_raise(certain, possible)
        return self._raised[id(statement)]

    def _top_level_raise(self, statement: ast.stmt) -> BoolRef | None:
        """Whether top-level ``statement`` stopped the block: its own raise for
        a simple one; for a compound one, a free Bool bounded by every read
        inside it that may raise (which of its statements ran is not
        modelled)."""
        if not isinstance(statement, self._COMPOUND):
            return self._statement_raise(statement)
        if id(statement) not in self._compound_raised:
            possible = [
                choice
                for node_statement in ast.walk(statement)
                if isinstance(node_statement, ast.stmt)
                for _, effect, _, choice in self._reads.get(id(node_statement), [])
                if effect in ("raise", "other")
            ]
            self._compound_raised[id(statement)] = self._bounded_raise([], possible)
        return self._compound_raised[id(statement)]

    def _halted_within(self, statement: ast.stmt) -> list[BoolRef]:
        """The raises of the statements that run before ``statement`` inside the
        compound statements holding it: its earlier siblings in each enclosing
        body (a raise aborts the whole block, ``CodeExecutionError``, so a
        statement after a raising one in the same branch does not run). The
        enclosing ``if`` test's own raise needs nothing here: a test that may
        raise is a free branch Bool (``_code_branch_test``)."""
        raises: list[BoolRef] = []
        child, parent = statement, self._parents.get(statement)
        while isinstance(parent, ast.stmt):
            for field in ("body", "orelse", "finalbody", "handlers"):
                siblings = getattr(parent, field, None)
                if isinstance(siblings, list) and any(sibling is child for sibling in siblings):
                    for sibling in siblings:
                        if sibling is child:
                            break
                        if isinstance(sibling, ast.stmt):
                            raised = self._top_level_raise(sibling)
                            if raised is not None:
                                raises.append(raised)
                    break
            child, parent = parent, self._parents.get(parent)
        return raises

    def old_value(self, var_name: str) -> ExprRef | None:
        """The value variable ``var_name`` keeps when the assignment is not
        reached: its current version, or a fresh Int when it has none yet (an
        unbound name; no version is created, so the numbering stays).
        ``None`` when the block reads no item that may be ``None``."""
        builder = self._builder
        if not self.choices:
            return None
        if var_name in builder.version_map:
            return builder._get_current_z3_var(var_name)
        return self._unknown()

    def _unknown(self) -> ExprRef:
        builder = self._builder
        builder._code_raise_count += 1
        return Int(f"unknown@{self._context}#{builder._code_raise_count}", builder.ctx)

    def guarded(
        self, statement: ast.stmt, value: ExprRef | None, old: ExprRef | None, *, variable: bool = True
    ) -> ExprRef | None:
        """``value`` as the assignment ``statement`` leaves its target:
        ``old`` where the block stopped before it or at it, a fresh Int where
        its value reads a ``None`` no Int holds or, for a ``variable`` target
        (an outcome write carries no #1044 mark), where it is computed from a
        blank item; ``value`` itself when none can happen."""
        if value is None or old is None or not self.choices:
            return value
        stops = [
            part
            for part in (
                self._halted_before[self._top[id(statement)]],
                *self._halted_within(statement),
                self._statement_raise(statement),
            )
            if part is not None
        ]
        stop = self._builder._disjoin(stops) if stops else None
        value_node = statement.value
        flowing = [
            choice
            for node, effect, _, choice in self._reads.get(id(statement), [])
            if effect in ("copy", "other", "flow") and self._within(node, value_node)
        ]
        tainted = self._tainting_blanks(statement) if variable else []
        if (stop is not None or flowing or tainted) and value.sort() != old.sort():
            return None
        if flowing:
            value = If(self._builder._disjoin(flowing), self._unknown(), value)
        if stop is not None:
            value = If(stop, old, value)
        if tainted:
            value = If(self._builder._disjoin(tainted), self._unknown(), value)
        return value

    def _tainting_blanks(self, statement: ast.stmt) -> list[BoolRef]:
        """The blank choices that make ``statement``'s target unknown at
        runtime (``_unknown_after``): of the items its value reads, and those
        the test of an enclosing ``if`` / ``while`` (or a ``for`` iterable)
        reads."""
        sources = [(statement, statement.value)]
        child, parent = statement, self._parents.get(statement)
        while parent is not None:
            if isinstance(parent, (ast.If, ast.While)) and child is not parent.test:
                sources.append((parent, parent.test))
            elif isinstance(parent, (ast.For, ast.AsyncFor)) and child is not parent.iter:
                sources.append((parent, parent.iter))
            child, parent = parent, self._parents.get(parent)
        items = {
            outcome_ref_name(node)
            for holder, root in sources
            for node, _, _, _ in self._reads.get(id(holder), [])
            if self._within(node, root)
        }
        return [self._blank[item_id] for item_id in sorted(items - {None}) if item_id in self._blank]

    def _within(self, node: ast.AST, root: ast.AST) -> bool:
        while node is not None:
            if node is root:
                return True
            node = self._parents.get(node)
        return False


def _any(*parts: BoolRef | None) -> BoolRef | None:
    """Disjunction with ``None`` as False (``_UnknownMarks``)."""
    kept = [part for part in parts if part is not None and not is_false(part)]
    for part in kept:
        if is_true(part):
            return part
    if not kept:
        return None
    return kept[0] if len(kept) == 1 else Or(*kept)


def _all(*parts: BoolRef | None) -> BoolRef | None:
    """Conjunction with ``None`` as False (``_UnknownMarks``)."""
    if any(part is None or is_false(part) for part in parts):
        return None
    kept = [part for part in parts if not is_true(part)]
    if not kept:
        return parts[0]
    return kept[0] if len(kept) == 1 else And(*kept)


class _UnknownMarks:
    """Which variables one item's codeBlock marks unknown (#1044, #1844), as
    formulas: ``FlowProcessor``'s ``_unknown_after`` rule for rule, each of
    its sets replaced by a formula over the world's blank choices and the
    marks the variables carry into the block (``None`` is False, so a block
    that reads nothing that may be blank builds no formula at all).

    The runtime walks the statements statically, in order: a name assigned
    from an expression reading a blank item's ``.outcome`` or a marked
    variable (neither tested against None) is marked, any other assignment
    clears it; an assignment under an ``if`` / ``while`` test or a ``for``
    iterable reading such data is marked too; the bodies of an ``if`` /
    ``while`` / ``for`` / ``try`` are walked from the same marks and merged, a
    mark in ANY body staying whichever ran; a container mutated with such data
    is marked, never cleared. ``marked`` / ``cleared`` are the block's result;
    the caller keeps an incoming mark unless the block cleared it AND changed
    the value (``StaticBuilder._settle_marks``), as the runtime does.
    """

    def __init__(
        self,
        tree: ast.Module,
        entry: Callable[[str], BoolRef | None],
        blank: Callable[[str], BoolRef | None],
        true: BoolRef,
    ):
        self._entry = entry
        self._blank = blank
        self._true = true
        self.current: dict[str, BoolRef | None] = {}
        self.marked: dict[str, BoolRef | None] = {}
        self.cleared: dict[str, BoolRef | None] = {}
        self._walk(tree.body, None)

    def _not(self, part: BoolRef | None) -> BoolRef | None:
        if part is None or is_false(part):
            return self._true
        return None if is_true(part) else Not(part)

    def _current(self, name: str) -> BoolRef | None:
        return self.current[name] if name in self.current else self._entry(name)

    def _tainted(self, expr: ast.AST) -> BoolRef | None:
        items = outcome_reads(expr) - none_tested_outcomes(expr)
        names = name_reads(expr) - none_tested_names(expr)
        return _any(*(self._blank(item) for item in sorted(items)), *(self._current(n) for n in sorted(names)))

    @staticmethod
    def _stores(node: ast.AST) -> set[str]:
        return {n.id for n in ast.walk(node) if isinstance(n, ast.Name) and isinstance(n.ctx, ast.Store)}

    @staticmethod
    def _mutated(node: ast.AST) -> set[str]:
        while isinstance(node, (ast.Subscript, ast.Attribute)):
            node = node.value
        return {node.id} if isinstance(node, ast.Name) else set()

    def _assign(self, names: set[str], tainted: BoolRef | None) -> None:
        for name in names:
            self.current[name] = tainted
            self.marked[name] = tainted
            self.cleared[name] = self._not(tainted)

    def _mutate(self, names: set[str], tainted: BoolRef | None) -> None:
        if tainted is None:
            return
        for name in names:
            self.current[name] = _any(self._current(name), tainted)
            self.marked[name] = _any(self.marked.get(name), tainted)
            self.cleared[name] = _all(self.cleared.get(name), self._not(tainted))

    def _alternatives(self, bodies: list[list[ast.stmt]], under: BoolRef | None) -> None:
        start = (dict(self.current), dict(self.marked), dict(self.cleared))
        results = []
        for body in bodies:
            self.current, self.marked, self.cleared = dict(start[0]), dict(start[1]), dict(start[2])
            self._walk(body, under)
            results.append((self.current, self.marked, self.cleared))
        names = set().union(*(set(r[0]) | set(r[1]) | set(r[2]) for r in results))
        current, marked, cleared = {}, {}, {}
        for name in names:
            current[name] = _any(*(r[0][name] if name in r[0] else self._entry(name) for r in results))
            marked[name] = _any(*(r[1].get(name) for r in results))
            cleared[name] = _all(_any(*(r[2].get(name) for r in results)), self._not(marked[name]))
        self.current, self.marked, self.cleared = current, marked, cleared

    def _walk(self, statements: list[ast.stmt], under: BoolRef | None) -> None:
        for st in statements:
            if isinstance(st, (ast.Assign, ast.AnnAssign)):
                targets = st.targets if isinstance(st, ast.Assign) else [st.target]
                tainted = _any(under, self._tainted(st.value) if st.value is not None else None)
                self._assign(set().union(*(self._stores(t) for t in targets)), tainted)
                self._mutate(set().union(*(self._mutated(t) for t in targets)), tainted)
            elif isinstance(st, ast.AugAssign):
                names = self._stores(st.target)
                self._assign(names, _any(under, *(self._current(n) for n in sorted(names)), self._tainted(st.value)))
                self._mutate(self._mutated(st.target), _any(under, self._tainted(st.value)))
            elif isinstance(st, ast.Expr) and isinstance(st.value, ast.Call) and isinstance(st.value.func, ast.Attribute):
                self._mutate(self._mutated(st.value.func.value), _any(under, self._tainted(st.value)))
            elif isinstance(st, (ast.If, ast.While)):
                self._alternatives([st.body, st.orelse], _any(under, self._tainted(st.test)))
            elif isinstance(st, ast.For):
                branch = _any(under, self._tainted(st.iter))
                self._assign(self._stores(st.target), branch)
                self._alternatives([st.body, st.orelse], branch)
            elif isinstance(st, ast.With):
                self._walk(st.body, under)
            elif isinstance(st, ast.Try):
                self._alternatives([st.body + st.orelse, *(handler.body for handler in st.handlers)], under)
                self._walk(st.finalbody, under)


def _safe_eval_names() -> frozenset[str]:
    """The builtin + module names the ``PythonRunner`` sandbox exposes, so the
    undefined-name lint's known names never drift from what the runner binds."""
    # Local import avoids a core↔z3 import cycle at module load; by the time
    # a build runs, both packages are fully imported.
    from askalot_qml.core.python_runner import sandbox_names

    return sandbox_names()


# The two named ends of a Range answer, in pair order (#1755): the fields of
# ``core.controls.RangeValue``, which this module cannot import at load time
# (``askalot_qml.core`` imports the engine, which imports this builder).
# ``TestRangeNamedEnds`` holds the two in step.
_RANGE_ENDS = ("low", "high")

# A condition's kind decides how a raise on a skipped item's None counts:
# False for a precondition, waived for a postcondition (#1775).
ConditionKind = Literal["precondition", "postcondition"]


_ORDERING_OPS = (ast.Lt, ast.LtE, ast.Gt, ast.GtE)


@dataclass(frozen=True)
class _Outcome:
    """How one node of a condition evaluates at runtime, two-valued (#1779).

    The runtime (``FlowProcessor._evaluate_three_valued``) gives each node one
    of four results: True, False, unknown (a leaf reads a blank item, #1784)
    or a raise (a read of a skipped item's None, #1775). ``true`` and
    ``accepted`` (not False: True, unknown or a raise) say which, with
    ``raises`` the raise itself (``None``: the node cannot raise). A part
    reached only after an unknown sibling does not raise there, it is unknown
    too, so a junction that may raise also carries ``lenient``: its
    ``(true, accepted)`` evaluated that way; ``None`` when it equals the strict
    pair (a leaf, or nothing below can raise).

    The kind applies once, at the root: a precondition holds on ``true``
    (unknown and a raise fail it), a postcondition on ``accepted`` (both waive it).
    """

    true: BoolRef
    accepted: BoolRef
    raises: BoolRef | None = None
    lenient: tuple[BoolRef, BoolRef] | None = None

    @property
    def lenient_true(self) -> BoolRef:
        return self.true if self.lenient is None else self.lenient[0]

    @property
    def lenient_accepted(self) -> BoolRef:
        return self.accepted if self.lenient is None else self.lenient[1]


def _outcome_not(operand: _Outcome) -> _Outcome:
    """``not A``: True and False swap, a raise passes through."""
    lenient = None
    if operand.lenient is not None:
        lenient = (Not(operand.lenient_accepted), Not(operand.lenient_true))
    return _Outcome(Not(operand.accepted), Not(operand.true), operand.raises, lenient)


def _outcome_junction(is_and: bool, parts: list[_Outcome]) -> _Outcome:
    """``and`` / ``or`` over ``parts``, left to right as the runtime
    short-circuits: a raise ends the evaluation, a part reached after an
    unknown one is evaluated leniently (its raise is unknown too), and
    ``and`` is settled by a False part, ``or`` by a True one, after an
    unknown part as well (Kleene)."""
    if all(part.raises is None and part.lenient is None for part in parts):
        join = And if is_and else Or
        return _Outcome(join(*[p.true for p in parts]), join(*[p.accepted for p in parts]))
    acc = parts[0]
    for part in parts[1:]:
        acc = _outcome_pair(is_and, acc, part)
    return acc


def _outcome_pair(is_and: bool, a: _Outcome, b: _Outcome) -> _Outcome:
    """``a and b`` / ``a or b`` (``_outcome_junction``). With F = not accepted
    and U = neither True, False nor a raise: ``and`` is True on T(a) ∧ T(b),
    False on F(a) ∨ (T(a) ∧ F(b)) ∨ (U(a) ∧ lenient F(b)), and raises on
    R(a) ∨ (T(a) ∧ R(b)); ``or`` is the dual (True on T(a) ∨ (F(a) ∧ T(b)) ∨
    (U(a) ∧ lenient T(b)), False on F(a) ∧ F(b), raising on R(a) ∨ (F(a) ∧ R(b)))."""
    ctx = a.true.ctx
    a_raises = a.raises if a.raises is not None else BoolVal(False, ctx)
    a_unknown = And(Not(a.true), a.accepted, Not(a_raises))
    if is_and:
        true = And(a.true, b.true)
        false = Or(Not(a.accepted), And(a.true, Not(b.accepted)), And(a_unknown, Not(b.lenient_accepted)))
        accepted = Not(false)
        continued = a.true
        lenient = (And(a.lenient_true, b.lenient_true), And(a.lenient_accepted, b.lenient_accepted))
    else:
        true = Or(a.true, And(Not(a.accepted), b.true), And(a_unknown, b.lenient_true))
        accepted = Or(a.accepted, b.accepted)
        continued = Not(a.accepted)
        lenient = (Or(a.lenient_true, b.lenient_true), Or(a.lenient_accepted, b.lenient_accepted))
    raised = [r for r in (a.raises, None if b.raises is None else And(continued, b.raises)) if r is not None]
    raises = None if not raised else raised[0] if len(raised) == 1 else Or(*raised)
    return _Outcome(true, accepted, raises, lenient)


def _require_condition_kind(kind: str) -> None:
    """Refuse an unknown condition kind. Called outside the lowering's
    ``except Exception`` guards, which would turn it into a silent drop."""
    if kind not in ("precondition", "postcondition"):
        raise ValueError(f"unknown condition kind {kind!r}")


def _is_call_to(node: ast.Call, names: tuple[str, ...]) -> bool:
    """Whether ``node`` calls one of the builtins ``names`` by its bare name."""
    return isinstance(node.func, ast.Name) and node.func.id in names and not node.keywords


def _is_boolean_valued(node: ast.AST) -> bool:
    """Whether Python evaluates ``node`` to a bool: a comparison, a ``not``, a
    bool literal, or ``and`` / ``or`` over those (which otherwise return an operand)."""
    if isinstance(node, ast.Compare) or (
        isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.Not)
    ):
        return True
    if isinstance(node, ast.Constant):
        return isinstance(node.value, bool)
    if isinstance(node, ast.BoolOp):
        return all(_is_boolean_valued(value) for value in node.values)
    return False


class StaticBuilder:
    """
    Manages Static Single Assignment versioning and Z3 constraint generation.

    This class provides the foundation for Z3-driven questionnaire analysis by:
    1. Creating SSA versions for all variable assignments
    2. Building Z3 constraints from preconditions, postconditions, and code blocks
    3. Discovering item dependencies through constraint analysis
    4. Providing compatibility interface for ItemClassifier

    Used by QMLTopology for dependency discovery and topological sorting.
    """

    def __init__(self, questionnaire_state: QMLState):
        """Initialize StaticBuilder with questionnaire state and build constraints."""
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state
        # Both depend on the questionnaire alone, so they outlive a rebuild
        # (``_reset_build_state``): author code parsed once (``_parsed``), and
        # the string model, read once the first build pass knows the items
        # (``_read_string_model``).
        self._parse_cache: dict[tuple[str, str], ast.AST | None] = {}
        # Per-node readings (``_memoised``), kept for the builder's lifetime.
        self._node_memo: dict[tuple[str, int, frozenset[Any] | None], tuple[ast.AST, Any]] = {}
        self._runner: Any = None
        self._string_model: _StringModel | None = None
        self._reset_build_state()
        self._build()

    def _reset_build_state(self) -> None:
        """Every field one build fills, empty. ``_build`` calls it again before
        a second build in navigation order (#1989), so nothing of the first
        build (its Z3 context, versions, constraints, graph) survives into it."""
        # Isolated Z3 context for thread safety.
        # Z3's global context (main_ctx) is not thread-safe — background threads
        # (watchdog, IPC) can trigger Python GC which corrupts shared AST state.
        # Each StaticBuilder gets its own context so all Z3 objects are isolated.
        self.ctx = Context()

        # SSA version tracking: variable_name -> current_version
        self.version_map: dict[str, int] = {}

        # SSA variable history: variable_name -> [(version, context_item_id)]
        self.version_history: dict[str, list[tuple[int, str]]] = {}

        # Z3 variables for SSA versions
        self.z3_vars: dict[str, ExprRef] = {}  # "var_name_version" -> z3_var

        # Item outcome variables (special handling)
        self.item_vars: dict[str, ExprRef] = {}  # item_id -> z3_var

        # Per-answer variables of a list outcome; such an item has NO scalar in
        # self.item_vars. A MatrixQuestion holds one Z3 Int per (row, col),
        # read by ``X.outcome[j][k]``; a QuestionGroup one per question,
        # ``item_{id}@{i}`` keyed (i,), read by ``X.outcome[i]`` (#184). A
        # Range answer is a [low, high] pair (#1474), so a Range matrix cell is
        # keyed (row, col, end) and a Range group answer (i, end), with end
        # 0 / 1 named by ``_range_end_names``; a read that stops at the pair
        # finds no cell, which is what makes a bare Range cell (or a fold over
        # Range cells) a coverage gap.
        self.item_cells: dict[str, dict[tuple[int, ...], ExprRef]] = {}
        self.question_groups: set[str] = set()
        # MatrixQuestion ids, so ``_unlowered_matrix_reads`` walks only when one exists.
        self.matrices: set[str] = set()
        # Questions a refused ``len(set([...])) == k`` held that may read
        # ``None`` (#1785), per condition owner, for the coverage gap (#1799).
        self._distinct_refusals: dict[str, list[str]] = {}
        # Skippable Questions a refused condition read through a ternary branch
        # (#1867, ``_skippable_reads``), per condition owner, for the coverage gap.
        self._ternary_refusals: dict[str, list[str]] = {}

        # Range Question ends (#1474). A Range answer is a ``[low, high]``
        # pair, so a Range Question holds two Ints, ``item_{id}@lo`` and
        # ``item_{id}@hi`` (see ``_range_end_names``), here instead of a scalar in ``item_vars``. Only
        # ``X.outcome.low`` / ``X.outcome.high`` lower onto them (#1755); a bare
        # ``X.outcome`` has no number to stand for and stays unlowered.
        self.item_pairs: dict[str, tuple[ExprRef, ExprRef]] = {}


        # The visited-sentinel floor of each Range Question: ``lo >= min``
        # when the control declares a numeric ``min`` (see _visited_sentinel).
        self._pair_floor: dict[str, int | float] = {}

        # Answeredness (#1250), see ``_lower_none_test``: the items the predicate
        # being lowered may None-test, and its answered Bool per item.
        self._none_guarded: set[str] = set()
        self._predicate_answered: dict[str, BoolRef] = {}
        self._predicate_reads_variables = False
        self._answered_count = 0
        # Each minted ``answered@X#n``: (X, the item whose condition minted it),
        # for ``answered_mint``; and ``answered_by_world`` per (item, skippable).
        self._answered_minted: dict[str, tuple[str, str]] = {}
        self._answered_by_world: dict[tuple[str, bool], BoolRef | None] = {}
        # The item whose condition ``_lower_predicate`` is lowering.
        self._predicate_context = ""
        # Skipped reads (#1769), see ``_lower_predicate``: the items whose
        # unasked ``None`` the predicate being lowered can see, with their skip
        # choice, and the one choice per item (``_skipped_choice``).
        self._predicate_skipped: dict[str, BoolRef] = {}
        # #1775: the skip choices each comparison of the precondition being
        # lowered raises on, and (#184, #1780) the answer-list reads whose
        # unanswered slot it raises on, for the raises the two-sided lowering
        # cannot place (``_wrap_unplaced``).
        self._predicate_raising: dict[int, tuple[list[BoolRef], list[ast.AST]]] = {}
        # #184 / #1780: whether a predicate is being lowered (a QuestionGroup
        # answer lowers only there, ``_group_cells``); the answer-list reads
        # of the predicate that are None-safe on an unanswered slot; the
        # QuestionGroups and matrices its None tests may model, with their
        # None choice; and the one unanswered choice per group answer or
        # matrix cell (``_slot_choice``).
        self._lowering_predicate = False
        self._predicate_slot_safe: set[int] = set()
        self._predicate_list_none: dict[str, BoolRef] = {}
        self._slot_choices: dict[tuple[str | int, ...], BoolRef] = {}
        self._skip_choices: dict[str, BoolRef] = {}
        self._skipped_count = 0
        self._fresh_skip_choices: dict[str, list[BoolRef]] = {}
        self._code_written: set[str] | None = None
        # Blank answers (#1784), see ``_blank_choice``: the one choice per item,
        # a code-written item's per-predicate choices, the choices of the
        # predicate being lowered, and whether that predicate models a blank at
        # all (a codeBlock ``if`` guard runs plain Python and does not).
        self._blank_choices: dict[str, BoolRef] = {}
        self._fresh_blank_choices: dict[str, list[BoolRef]] = {}
        self._blank_count = 0
        self._predicate_blank: dict[str, BoolRef] = {}
        self._model_blank = True
        # Admissibility of a blank (``_blank_acceptance``): the item whose own
        # postconditions are being lowered with its outcome ``None``, and each
        # item's acceptance formula (``None`` while it is being computed).
        self._own_none: str | None = None
        self._blank_acceptances: dict[str, BoolRef | None] = {}
        # Each item's ``version_map`` at its submission, before its own
        # codeBlock runs: the variable versions its postconditions read, at
        # the build and in its acceptance. Acceptance is computed only once the
        # build is complete.
        self._submission_versions: dict[str, dict[str, int]] = {}
        # Variables an own-condition compile reads as a fresh Int, and the
        # navigation order it judges against (``_runtime_versions``).
        self._open_reads: dict[str, ExprRef] = {}
        self._navigation_positions: dict[str, int] | None = None
        # Per item, computed once: an open variable is one Int for every
        # compile of that item's conditions (its pre- and postcondition alike).
        self._runtime_version_cache: dict[str, tuple[dict[str, int], dict[str, ExprRef]]] = {}
        # Each compile after the build (``_compile_conditions``), keyed by what
        # it reads: ``(item_id, predicates in order, kind, blank)`` -> ``(formula,
        # exact, the (index, wide items) of each wide condition, what the
        # lowering minted fresh with its makers)``.
        self._compiled_conditions: dict[
            tuple[str, tuple[str, ...], str, bool],
            tuple[
                BoolRef, bool, tuple[tuple[int, list[str]], ...], tuple[tuple[Any, Callable[[], Any]], ...]
            ],
        ] = {}
        # The fresh symbols a cached compile's lowering mints (``_mint``), while
        # one is recording; ``None`` otherwise.
        self._minting: list[tuple[Any, Callable[[], Any]]] | None = None
        self._topology = None
        self._built = False
        # #1844: per SSA version (``_ssa_key``), when the runtime may mark it
        # unknown (computed from a blank answer, #1044), as ``_UnknownMarks``
        # builds it; a version missing here is never marked.
        self._marks: dict[str, BoolRef] = {}
        # Fresh raise Bools and unknown Ints of codeBlock reads (#1776, ``_CodeReads``).
        self._code_raise_count = 0
        # Fresh lenient outcomes of condition leaves holding a raise the
        # two-sided lowering cannot place (#1779, ``_lower_kleene``).
        self._loose_count = 0
        # Truths of condition leaves comparing a Textarea's text (#2241,
        # ``_text_leaf``): one per (item, literal set), and the fresh ones of
        # a Textarea code writes.
        self._text_choices: dict[str, dict[frozenset[str | None], BoolRef]] = {}
        self._text_count = 0
        # Truths of comparisons of a value the model may not know to be a
        # number with string literals (#2243, ``_string_choice``): one per
        # (variable version, literal set), and fresh ones for any other value.
        self._string_choices: dict[str, dict[frozenset[str], BoolRef]] = {}
        self._string_count = 0
        # The names a condition being compiled leaves undecided
        # (``_note_undecided``, ``_compile_conditions``); the variables some
        # version of which is unconstrained (``_register_variable_assignment``);
        # one reading per node (``_memoised``).
        self._undecided_reads: list[str] | None = None
        self._free_variables: set[str] = set()
        # Variables a codeBlock assigned after minting a free value
        # (``_process_code_block``), and what they are copied into
        # (``_register_variable_assignment``): a condition reading one is
        # undecided. ``_code_mints`` counts the free values minted in code.
        self._undecided_variables: set[str] = set()
        self._code_mints = 0
        # The one free Int of each answer or matrix cell a store may put text into
        # (``_unmodelled_read``).
        self._stored_reads: dict[str, ExprRef] = {}
        # Whether the predicate being compiled failed (``_compile_predicate``).
        self._compile_failed = False
        # What the last ``_compile_predicate`` left undecided and whether it failed.
        self._last_compile: tuple[list[str], bool] = ([], False)

        # Domain constraints D_i(S_i) - only min/max and enumeration constraints
        # These define the valid value space for each item variable
        # This is B as defined in the thesis: B := ∧_i D_i(S_i)
        self.domain_constraints: list[BoolRef] = []

        # CodeBlock constraints - SSA assignments from codeBlock execution
        # These define relationships between computed variables and item outcomes
        # e.g., var1 = q1.outcome + q2.outcome
        self.codeblock_constraints: list[BoolRef] = []

        # U2: per-variable codeInit constant constraints (``var_i == literal``),
        # keyed by variable name. A subset of ``codeblock_constraints`` — the
        # unconditional codeInit assignments only (never the ``Implies(item >= 0,
        # …)``-guarded codeBlock ones). ``get_reachability_base`` conjoins the
        # entries of *frozen* variables (assigned only in codeInit, never in a
        # codeBlock) into the precondition-reachability base so a gate on a
        # never-reassigned constant is statically decidable (NEVER / ALWAYS)
        # instead of a free symbol (CONDITIONAL). Populated in
        # ``_register_variable_assignment``; frozen-ness resolved lazily against
        # ``version_history`` at accessor time (a later codeBlock assignment to
        # the same name un-freezes it).
        self.codeinit_constant_constraints: dict[str, list[BoolRef]] = {}

        # Behavioral constraints from preconditions and postconditions
        # Used for dependency discovery and constraint verification
        # NOTE: These are kept separate from codeblock_constraints for validation
        self.constraints: list[BoolRef] = []

        # Comprehensive dependency graph (items and variables as nodes)
        # Keys: item_id or "var:variable_name"
        # Values: set of dependencies (items or variables)
        self.dependency_graph: dict[str, set[str]] = {}

        # The same ``var:`` edges split by writer (#1891): per variable, each
        # assignment's context (``"__init__"`` or the item id) and the
        # dependencies of the value it assigns. An accumulator is resolved
        # through the writers before its reader in file order only
        # (``get_item_dependencies``), and its versions are modelled at each
        # position for precondition reachability (``_accumulator_reachability``).
        self._variable_writers: dict[str, list[tuple[str, frozenset[str]]]] = {}
        self._assignment_values: list[tuple[str, int, str, ExprRef | None, frozenset[str]]] = []
        self._accumulators: set[str] | None = None
        self._accumulator_constraints: list[BoolRef] | None = None

        # Track which item defines each variable version
        self.variable_definitions: dict[tuple[str, int], str] = {}

        # ItemClassifier compatibility - item details and order
        self.item_details: dict[str, dict[str, Any]] = {}  # Maps item_id to item details
        self.item_order: list[str] = []  # Processing order for ItemClassifier

        # R13: coverage gaps. When ``_ast_to_z3_bool`` returns ``None`` on a
        # condition whose AST contains a clearly-intended-as-constraint node
        # (Call / ListComp / GeneratorExp / Subscript), we record the gap so
        # ``ItemClassifier`` can surface it in its per-item classification and
        # ``validate_qml_file`` can pass it through to authors.
        # Shape: ``{item_id: [{"kind": str, "condition_idx": int, "unsupported_nodes": List[str]}, ...]}``
        #
        # The U1 undefined-name lint reuses this same channel (as
        # ``group_dependency`` already does): a phantom identifier is recorded as
        # ``{"kind": "undefined_name", "identifier": str, "condition_kind":
        # "precondition"|"postcondition"|"codeBlock", "suggested_outcome":
        # str | None}`` under the owning item_id (or block_id for block-level
        # conditions), so it flows builder → ItemClassifier → to_issues unchanged.
        self.coverage_gaps: dict[str, list[dict[str, Any]]] = {}

        # U1 → U3 handoff: per-variable read/write census, keyed by variable name
        # (codeInit/codeBlock assignment targets; never item ids or phantom
        # names). Populated by the ``_detect_undefined_names_and_census`` post-pass.
        # Shape per variable:
        #   {"assignments": [{"context": "codeInit"|item_id,
        #                     "bare_outcome_item": item_id | None}, ...],
        #    "reads": int}   # Load references across predicates + code
        # ``bare_outcome_item`` is the item X when the assignment is exactly
        # ``var = X.outcome`` (the pass-through-alias signal U3 keys on); any
        # transformation or a second assignment leaves it None / exempts the var.
        self.variable_census: dict[str, dict[str, Any]] = {}

        # ------------------------------------------------------------------
        # U2: shared conditionally-present Z3 primitive.
        #
        # ``present(item, k)`` is a per-(item, selection/iteration-index ``k``)
        # Bool that gates that (item, k)'s domain/precondition/postcondition
        # constraints. It models *item absence* — "this item may or may not be
        # asked for selection index k" — which is a strictly different
        # question from ``_visited_sentinel`` (which gates conditions on
        # *visitation*, i.e. "given the item was reached, its conditions
        # hold"). Both gates compose: an item that is present AND visited
        # carries its conditions; an absent item carries none.
        #
        # **Sort decision (deferred-to-implementation, settled here against
        # the ``_visited_sentinel`` precedent):** ``_visited_sentinel``
        # returns a single ``BoolRef`` for both scalar and matrix items —
        # ``item_var >= 0`` for scalars, ``BoolVal(True)`` for matrices — and
        # does *not* split into two sorts. It splits *values* only because its
        # antecedent is *derived from the item's scalar outcome var*, which
        # matrix items lack. ``present`` is an INDEPENDENT gating Bool, not
        # derived from any outcome var, so the scalar/matrix distinction is
        # irrelevant to it. We therefore use ONE Bool sort across scalar and
        # matrix items: ``Bool(f"present_{item_id}_k{k}", ctx)``. This is the
        # cleaner choice and introduces zero sort-mixing surface (consistent
        # with the no-BitVec / Int-only decision in the plan).
        #
        # ``_present_vars`` is the lazily-populated cache of these Bools.
        # ``_conditionally_present`` is the classification-safety tag set:
        # any (item_id, k) registered here is "absent because not drawn / bit
        # unset" — ItemClassifier / PathBasedValidator MUST NOT report it
        # NEVER / dead-code. With no registrations (every path off a capped Group /
        # Roster, i.e. all of U2 standalone) the antecedent degrades to the
        # literal True and the primitive is a proven no-op.
        #
        # ``k is None`` is the canonical "single, unconditional selection"
        # key — used by the dedicated wrapping pass below so Group and Roster
        # items share one code path. The Roster bit-guard unroll calls
        # ``mark_conditionally_present(item_id, k)`` with a concrete int
        # ``k`` to wire per-iteration constraints; off that path this is
        # inert.
        self._present_vars: dict[tuple[str, int | None], BoolRef] = {}
        self._conditionally_present: set[tuple[str, int | None]] = set()
        # Fast O(1) item_id-only lookup for is_conditionally_present. Kept in
        # sync with _conditionally_present by mark_conditionally_present.
        self._conditionally_present_item_ids: set[str] = set()

        # Per-item domain constraints, collected during pass-1 and flushed
        # (present-gated) into ``self.domain_constraints`` by the dedicated
        # ``_emit_present_gated_domain`` pass. See that method for why this is
        # a separate pass rather than an inline append.
        #
        # U3: the bucket value is a list of *var-parameterized builders*, not
        # pre-bound ``BoolRef``s. Each builder is ``(var) -> BoolRef`` so the
        # SAME domain spec can be re-emitted against the canonical
        # ``item_var`` (``k is None`` — the U2 no-op path, byte-equivalent
        # logically to pre-U2) AND against per-iteration Roster vars
        # (``item_{id}@iter{K}``) without re-extracting min/max/enum from the
        # input spec. The single extraction site stays
        # ``_extract_domain_constraints``; only the binding target varies.
        self._pending_domain_constraints: dict[
            str, list[Callable[[ExprRef], BoolRef]]
        ] = {}
        # The pair form of the same bucket, for Range Questions:
        # ``(lo, hi) -> BoolRef``. A separate map, so a scalar control can
        # never be bound to a pair or a pair to one variable.
        self._pending_pair_domain_constraints: dict[
            str, list[Callable[[ExprRef, ExprRef], BoolRef]]
        ] = {}

    def _domain_constraint_builders(
        self, item_id: str, item: dict[str, Any]
    ) -> list[Callable[[ExprRef], BoolRef]]:
        """Extract domain constraints D_i(S_i) as *var-parameterized builders*.

        Domain constraints define the valid value space for each item:
        - For Editbox/Slider: min <= S_i <= max
        - For Radio/Dropdown: S_i ∈ {v1, v2, ...}
        - For Checkbox: S_i is a sum of distinct label keys (a bitmask, 0 included)

        These constraints form B (base constraint) as defined in the thesis:
        B := ∧_i D_i(S_i)

        Returns builders ``(var) -> BoolRef`` rather than pre-bound
        ``BoolRef``s so the SAME spec can be bound to the canonical scalar
        ``item_var`` (U2 ``k is None`` path), to each Roster per-iteration var
        ``item_{id}@iter{K}`` (U3), or to a matrix cell var — without
        re-reading min/max/enum from the input spec at every binding site.
        This is the single domain-extraction site; only the bind target and
        the present-gate vary across callers.
        """
        input_spec = item.get("input", {})
        control = input_spec.get("control", "")
        builders: list[Callable[[ExprRef], BoolRef]] = []

        if control in ("Editbox", "Slider"):
            # Min/max constraints for numeric controls. Range is not here: its
            # answer is a pair, bound by ``_pair_domain_builders``.
            min_val, max_val = self._numeric_bounds(item_id, input_spec)
            if min_val is not None:
                builders.append(lambda v, _m=min_val: v >= _m)
            if max_val is not None:
                builders.append(lambda v, _m=max_val: v <= _m)

        elif control == "Checkbox":
            # A Checkbox answers the SUM of its ticked keys (the loader holds
            # every key to a positive power of 2), not one key: labels
            # {1, 2, 4} answer any of 0..7, and 0 is "nothing ticked", which
            # the control submits as its initial value. Modelled as
            # 0 <= S <= mask with every UNDECLARED bit below the top key clear,
            # tested by constant division and modulus as the Roster unroll
            # does, so it stays linear integer arithmetic (no BitVec). An
            # enumeration of the keys (the Radio branch) would classify a gate
            # on a real combination, ``q.outcome == 3``, NEVER.
            # Imported here, not at module level: ``askalot_qml.core``'s
            # package __init__ imports the engine, which imports this module,
            # so a top-level import breaks ``import askalot_qml.z3`` whenever
            # it runs before ``askalot_qml.core``.
            from askalot_qml.core.controls import checkbox_mask

            mask = checkbox_mask(input_spec)
            if mask:
                # One ``(S / lo) % 2**run == 0`` per RUN of undeclared bits,
                # not per bit: keys {1, 2**20} cost one term, not nineteen.
                clear: list[tuple[int, int]] = []
                bit = 0
                while (1 << bit) <= mask:
                    if mask >> bit & 1:
                        bit += 1
                        continue
                    run = bit
                    while (1 << run) <= mask and not mask >> run & 1:
                        run += 1
                    clear.append((1 << bit, 1 << (run - bit)))
                    bit = run
                builders.append(
                    lambda v, _mask=mask, _clear=tuple(clear): And(
                        v >= 0,
                        v <= _mask,
                        *[(v / lo) % span == 0 for lo, span in _clear],
                    )
                )

        elif control in ("Radio", "Dropdown", "Switch"):
            # Enumeration constraint for choice controls
            # labels = {1: "Yes", 2: "No"} → valid values are integer keys
            valid_values: list[int] = []

            labels = input_spec.get("labels")
            if isinstance(labels, dict):
                for k in labels.keys():
                    if isinstance(k, int):
                        valid_values.append(k)
                    else:
                        try:
                            valid_values.append(int(k))
                        except (TypeError, ValueError):
                            pass

            if valid_values:
                # D_i(S_i) = S_i ∈ {v1, v2, ...}
                builders.append(
                    lambda v, _vals=tuple(valid_values): Or(*[v == val for val in _vals])
                )

        return builders

    def _numeric_bounds(
        self, item_id: str, input_spec: dict[str, Any]
    ) -> tuple[int | float | None, int | float | None]:
        """The control's numeric ``(min, max)``; a missing or non-numeric bound is None.

        A non-numeric bound is logged and left out of the domain rather than
        guessed at.
        """
        return (
            self._numeric_bound(item_id, input_spec, "min"),
            self._numeric_bound(item_id, input_spec, "max"),
        )

    def _numeric_bound(
        self, item_id: str, input_spec: dict[str, Any], key: str
    ) -> int | float | None:
        """One numeric bound of the control, or None when missing or non-numeric."""
        value = input_spec.get(key)
        if value is not None and not isinstance(value, (int, float)):
            self.logger.warning(f"Unsupported {key} value type for {item_id}: {type(value).__name__}")
            return None
        return value

    def _pair_domain_builders(
        self, item_id: str, item: dict[str, Any]
    ) -> list[Callable[[ExprRef, ExprRef], BoolRef]]:
        """The domain of a Range answer, ``min <= lo <= hi <= max``, as pair builders.

        A Range answer is a ``[low, high]`` pair (#1474), so its domain binds
        two variables. ``lo <= hi`` holds whether or not the control declares
        bounds: the engine refuses a pair whose low end exceeds its high end.
        Same ``(lo, hi) -> BoolRef`` shape for the canonical pair, a Roster
        iteration's pair, a capped-Group pair and a Range matrix cell.
        """
        min_val, max_val = self._numeric_bounds(item_id, item.get("input", {}))
        builders: list[Callable[[ExprRef, ExprRef], BoolRef]] = [lambda lo, hi: lo <= hi]
        if min_val is not None:
            builders.append(lambda lo, hi, _m=min_val: lo >= _m)
        if max_val is not None:
            builders.append(lambda lo, hi, _m=max_val: hi <= _m)
        return builders

    def _range_cell(
        self, item_id: str, pair_builders: list[Callable[[ExprRef, ExprRef], BoolRef]], *scope: int
    ) -> tuple[ExprRef, ExprRef]:
        """A Range cell's two ends (``_range_end_names``), bound unconditionally
        by *pair_builders*: a matrix cell or a QuestionGroup answer."""
        lo_name, hi_name = _range_end_names(item_id, *scope)
        lo, hi = Int(lo_name, self.ctx), Int(hi_name, self.ctx)
        for build in pair_builders:
            self.domain_constraints.append(build(lo, hi))
        return lo, hi

    def _question_group_cells(
        self, item_id: str, item: dict[str, Any], questions_len: int, control: str
    ) -> dict[tuple[int, ...], ExprRef]:
        """One variable per answer of a QuestionGroup (#184), bound by the
        group's one control domain: ``item_{id}@{i}`` keyed ``(i,)``, or for a
        Range group the pair ``_range_end_names(id, i)`` keyed ``(i, 0)`` /
        ``(i, 1)``. The ``@`` keeps a cell from aliasing the scalar of an item
        named ``{id}_{i}``."""
        cells: dict[tuple[int, ...], ExprRef] = {}
        if control == "Range":
            pair_builders = self._pair_domain_builders(item_id, item)
            for i in range(questions_len):
                cells[(i, 0)], cells[(i, 1)] = self._range_cell(item_id, pair_builders, i)
            return cells
        for i in range(questions_len):
            cell = cells[(i,)] = Int(_scoped_name(item_id, i), self.ctx)
            self._extract_domain_constraints(item_id, cell, item, is_cell=True)
        return cells

    def _extract_domain_constraints(
        self,
        item_id: str,
        item_var: ExprRef,
        item: dict[str, Any],
        is_cell: bool = False,
    ):
        """Bind this item's domain builders to ``item_var`` and emit them.

        Two distinct callers, two distinct emission policies:

        - **Matrix cells (pass-1, one call per cell, ``is_cell=True``):** the
          cell var is concrete and matrix cells are NEVER conditionally-
          present in U3/U4 scope, so bind immediately and append straight to
          ``self.domain_constraints`` (unconditional — exactly the pre-U2
          behavior for matrices). ``is_cell`` is an explicit flag rather than
          an ``item_id in self.item_cells`` probe because pass-1 calls this
          per-cell *before* ``self.item_cells[item_id]`` is populated.
        - **Scalar items (pass-1, one call per item, ``is_cell=False``):**
          stash the *builders* in ``self._pending_domain_constraints`` so the
          dedicated ``_emit_present_gated_domain`` pass can bind them
          present-gated against the canonical var, and
          ``_emit_roster_bit_guarded_unroll`` can re-bind them against
          per-iteration vars. The scalar bucket key is ``item_id``; matrix
          items never populate it.
        """
        builders = self._domain_constraint_builders(item_id, item)
        if is_cell:
            # Matrix cell binding — concrete cell var, unconditional emit.
            for build in builders:
                self.domain_constraints.append(build(item_var))
        else:
            # Scalar item — defer to the present-gated flush pass.
            self._pending_domain_constraints.setdefault(item_id, []).extend(builders)

    def _emit_present_gated_domain(self) -> None:
        """Dedicated U2 pass: flush per-item domain constraints into the flat
        ``self.domain_constraints`` list, each gated by ``_wrap_present``.

        A SEPARATE pass (not inline append in ``_extract_domain_constraints``)
        for the same reason Pass-3 is separate (see the roster learning): the
        gate key for an item is only knowable after every item is registered,
        and a dedicated pass keeps the gating uniform across scalar / matrix /
        Textarea-adjacent items without threading the present-key through the
        domain extractor. With nothing marked conditionally-present the
        antecedent is the literal True, so ``Implies(True, c) ≡ c`` and the
        flat list is logically identical to the pre-U2 model — the proven
        no-op the plan mandates.

        U3: this emits ONLY the canonical (``k is None``) binding against the
        item's own scalar var. Roster per-iteration domain re-binding (one
        copy per label-key, gated by the bit-guard ``present``) is done
        additively by ``_emit_roster_bit_guarded_unroll`` — keeping this pass
        a pure no-op for every non-Roster item."""
        for item_id, builders in self._pending_domain_constraints.items():
            item_var = self.item_vars.get(item_id)
            if item_var is None:
                # Matrix / Textarea items have no scalar var; their cell-level
                # domain (matrix) was already emitted inline in pass-1 and
                # Textarea has no numeric domain. Nothing to bind here.
                continue
            for build in builders:
                self.domain_constraints.append(
                    self._wrap_present(item_id, None, build(item_var))
                )
        for item_id, pair_builders in self._pending_pair_domain_constraints.items():
            lo, hi = self.item_pairs[item_id]
            for build in pair_builders:
                self.domain_constraints.append(
                    self._wrap_present(item_id, None, build(lo, hi))
                )

    def _visited_sentinel(self, item_id: str) -> BoolRef:
        """Return the antecedent for 'item has been visited' in pre/postcondition implications.

        For scalar items (Editbox, Slider, Radio, …) the visit signal is
        ``item_var >= 0`` — the same antecedent the codebase has used since the
        Z3 work began. For MatrixQuestion items there is no single scalar
        outcome to compare against, so the antecedent collapses to BoolVal(True):
        the implication degenerates to its consequent, which matches the
        runtime semantics that a matrix's pre/postcondition is checked once at
        item processing time, not once per cell.

        A Range Question (#1474) is visited when its low end sits on the
        scale, ``lo >= min``; with no numeric ``min`` there is nothing to
        compare, so it is unconditional like a matrix.
        """
        if item_id in self.item_vars:
            return self.item_vars[item_id] >= 0
        if item_id in self.item_pairs and item_id in self._pair_floor:
            return self.item_pairs[item_id][0] >= self._pair_floor[item_id]
        # Matrix and QuestionGroup items (cells) and a Range Question without
        # a min: unconditional.
        return BoolVal(True, self.ctx)

    def _answerable(self, item_id: str) -> bool:
        """Whether a None test on ``item_id`` can be modelled (#1250): a scalar
        or Textarea Question that is always present. A matrix, QuestionGroup or
        Range item holds a list or a pair whatever variable the model gives it,
        and a Roster or capped-Group member's presence is per iteration or draw.
        """
        details = self.item_details.get(item_id)
        item = self.state.get_item(item_id)
        if details is None or item is None or details.get("kind") != "Question":
            return False
        if item_id not in self.item_vars and details.get("control") != "Textarea":
            return False
        return not self._is_scoped(item_id)

    def _lower_none_test(self, node: ast.Compare) -> BoolRef | None:
        """``X.outcome is None`` / ``is not None`` (and ``== None`` / ``!= None``,
        either operand order) as ``Not(answered)`` / ``answered``, #1250.

        ``answered`` is a fresh Bool per predicate (``_lower_predicate``),
        shared by that predicate's tests on X and tied to nothing else. A
        predicate is evaluated at one moment, so its tests agree with each
        other; across predicates X's answeredness can change (code sets it, an
        undecided gate lets an answer through, X's own gate runs before it is
        answered and its postcondition after), so nothing is carried over. Nor
        is ``answered ⇒ P_X`` (#1768): an out-of-order API answer to an item
        P_X reads can falsify it after X was answered, without taking X off
        the path.

        ``None`` when the comparison is not one such test, when the predicate
        reads X's value, or any variable, where X may be unanswered
        (``none_guarded_outcomes``: the model holds an unanswered X, and a
        variable computed from it, as an in-domain number), or when X is not
        ``_answerable``.
        """
        found = none_test_of(node)
        if found is not None and found[0] == self._own_none:
            # The item whose blank is being admitted reads ``None`` for certain.
            return BoolVal(not found[1], self.ctx)
        if found is None or found[0] not in self._none_guarded:
            return None
        item_id, tests_answered = found
        list_none = self._predicate_list_none.get(item_id)
        if list_none is not None:
            # A QuestionGroup or matrix is None when skipped or left blank
            # (``_answer_list_none``).
            return Not(list_none) if tests_answered else list_none
        if not self._answerable(item_id):
            return None
        # A variable may hold the text or a value computed from it, which the
        # model does not tie to the Textarea's answeredness (#1250), so a
        # predicate reading a variable keeps the None test unlowered. The
        # text's own reads lower leaf by leaf (``_text_leaf``).
        if self._is_textarea(item_id) and self._predicate_reads_variables:
            return None
        answered = self._predicate_answered.get(item_id)
        if answered is None:
            context = self._predicate_context

            def mint() -> BoolRef:
                self._answered_count += 1
                # ``@`` cannot occur in an item id, so no item or variable shares the name.
                symbol = Bool(f"{ANSWERED_PREFIX}{item_id}#{self._answered_count}", self.ctx)
                self._answered_minted[symbol.decl().name()] = (item_id, context)
                return symbol

            answered = self._predicate_answered[item_id] = self._mint(mint)
        return answered if tests_answered else Not(answered)

    def _has_outcome_model(self, item_id: str) -> bool:
        """Whether the model holds ``item_id``'s outcome in any form.

        True for a scalar item, a Range Question's pair, and a matrix's or a
        QuestionGroup's cells. Only Textarea items and
        non-items are left out. Every site that once asked ``item_id in
        self.item_vars`` to decide whether an item's conditions, codeBlock or
        dependency edges count asks this instead, so a Range item's
        conditions and codeBlock never vanish from the model.
        """
        return item_id in self.item_vars or item_id in self.item_pairs or item_id in self.item_cells

    def _is_range_item(self, item_id: str) -> bool:
        """Whether ``item_id`` is a Range item of any kind (Question, matrix, group)."""
        details = self.item_details.get(item_id)
        return details is not None and details.get("control") == "Range"

    # ------------------------------------------------------------------
    # U2: shared conditionally-present primitive
    #
    # Public API consumed by U3 (Roster bit-guarded unroll) and U4 (capped-Group
    # conditional-presence + ordering). U2 itself only wires the always-True
    # degrade path, proving the primitive is a no-op off a capped Group/Roster.
    # ------------------------------------------------------------------

    def _present_var(self, item_id: str, k: int | None) -> BoolRef:
        """Return the per-(item, k) ``present`` Z3 Bool, creating it lazily.

        One Bool sort across scalar and matrix items (see ``__init__`` for the
        sort rationale vs the ``_visited_sentinel`` precedent). Stable
        identity: the same ``(item_id, k)`` always yields the same Bool, so
        repeated wiring (domain, every precondition, every postcondition)
        shares one gate. ``k is None`` is the unconditional-selection key.
        """
        key = (item_id, k)
        var = self._present_vars.get(key)
        if var is None:
            suffix = "all" if k is None else str(k)
            var = Bool(f"present_{item_id}_k{suffix}", self.ctx)
            self._present_vars[key] = var
        return var

    def mark_conditionally_present(self, item_id: str, k: int | None = None) -> None:
        """Register ``(item_id, k)`` as conditionally-present (R5/R7).

        Called by U3/U4 for items whose presence is gated by a Roster bit or
        a capped-Group draw. Two effects:

        1. ``_present_antecedent`` stops degrading to True for this key — the
           gating Bool becomes the real antecedent, so domain/pre/post
           constraints only bind when the item is actually drawn.
        2. ``is_conditionally_present`` reports True, the classification-safety
           tag that keeps ItemClassifier / PathBasedValidator from flagging a
           reachable-but-not-drawn item as NEVER / dead-code.
        """
        self._conditionally_present.add((item_id, k))
        self._conditionally_present_item_ids.add(item_id)

    def is_conditionally_present(self, item_id: str) -> bool:
        """True iff ANY (item_id, k) was marked conditionally-present.

        The classification-safety query. ItemClassifier and
        PathBasedValidator call this to decide whether an unsatisfiable
        precondition means "dead code" (normal item) or "merely not drawn in
        this selection" (capped-Group/Roster item — must not be NEVER/dead-code).
        Keyed on item_id only: an item that is conditionally-present for any
        selection index is sampling-absent, never dead.
        """
        return item_id in self._conditionally_present_item_ids

    def _present_antecedent(self, item_id: str, k: int | None) -> BoolRef:
        """Return the presence antecedent for an (item, k) constraint.

        - If ``(item_id, k)`` was marked conditionally-present → the gating
          ``present`` Bool: the constraint binds only when the item is drawn.
        - Otherwise → ``BoolVal(True)``: ``Implies(True, C) ≡ C``, so the
          model is byte-identical to the unconditional one. This is the
          proven no-op for every uncapped-Group path — the only kind that
          registers no presence keys.
        """
        if (item_id, k) in self._conditionally_present:
            return self._present_var(item_id, k)
        return BoolVal(True, self.ctx)

    def _wrap_present(
        self, item_id: str, k: int | None, constraint: BoolRef
    ) -> BoolRef:
        """Gate ``constraint`` behind the (item, k) presence antecedent.

        ``Implies(present(item, k), constraint)``. When the antecedent
        degrades to True (no registration) this is logically just
        ``constraint`` — the primitive contributes nothing off a capped Group/Roster.
        """
        return Implies(self._present_antecedent(item_id, k), constraint)

    def _emit_pre_post_under_present(
        self,
        item_id: str,
        k: int,
        effective_pre: list,
        effective_post: list,
        scoped: ExprRef | tuple[ExprRef, ExprRef],
    ) -> None:
        """Emit per-iteration pre/postcondition constraints, present-gated.

        Roster bit-guarded unroll (Pass 3.5) and capped-Group conditional-presence
        (Pass 3.6) both re-emit each inner item's preconditions and
        postconditions per (item, k) selection, swapping ``self.item_vars[item_id]``
        to a per-iteration var so ``self.outcome`` references in predicates
        lower to the right Z3 variable, and gating the resulting ``Implies``
        behind the presence antecedent. The two call sites were verbatim
        duplicates of each other; this helper holds the shared body.

        ``scoped`` is the per-iteration outcome to swap in for the duration of
        the emit: one variable for a scalar item (swapped into ``item_vars``),
        a ``(lo, hi)`` pair for a Range Question (swapped into ``item_pairs``,
        so ``self.outcome.low`` / ``.high`` lower to this iteration's ends). The
        canonical entry is restored in ``finally`` so the canonical
        single-pass model the caller's outer loop assumes is unchanged on exit.
        """
        outcomes: dict[str, Any] = self.item_pairs if item_id in self.item_pairs else self.item_vars
        canonical = outcomes[item_id]
        outcomes[item_id] = scoped
        try:
            for idx, cond in enumerate(effective_pre):
                predicate = cond.get("predicate", "")
                if not predicate:
                    continue
                constraint, _deps = self._build_precondition_constraint(
                    predicate, item_id, idx
                )
                if constraint is not None:
                    self.constraints.append(
                        self._wrap_present(
                            item_id,
                            k,
                            Implies(self._visited_sentinel(item_id), constraint),
                        )
                    )
            for idx, cond in enumerate(effective_post):
                predicate = cond.get("predicate", "")
                if not predicate:
                    continue
                constraint, _deps = self._build_postcondition_constraint(
                    predicate, item_id, idx
                )
                if constraint is not None:
                    self.constraints.append(
                        self._wrap_present(
                            item_id,
                            k,
                            Implies(self._visited_sentinel(item_id), constraint),
                        )
                    )
        finally:
            outcomes[item_id] = canonical

    def _extract_dependencies_from_ast(self, node: ast.AST) -> set[str]:
        """Extract all dependency references (items AND variables) from AST.

        Returns a set of dependency node names:
        - item_id for item outcome references (e.g., q1.outcome, q1)
        - "var:variable_name" for variable references
        """
        dependencies = set()
        for child in ast.walk(node):
            if isinstance(child, ast.Attribute):
                # Handle q1.outcome pattern (scalar items AND matrix items)
                if isinstance(child.value, ast.Name) and child.attr == "outcome":
                    name = child.value.id
                    if self._has_outcome_model(name):
                        dependencies.add(name)
            elif isinstance(child, ast.Name):
                name = child.id
                if self._has_outcome_model(name):
                    # Direct item reference (scalar, Range, or matrix)
                    dependencies.add(name)
                elif name in self.version_map:
                    # Variable reference - track as var: node
                    dependencies.add(f"var:{name}")
        return dependencies

    @staticmethod
    def _compose_effective_conditions(
        block: dict[str, Any] | None, item: dict[str, Any]
    ) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
        """Compose block + item pre/postconditions into ``(effective_pre, effective_post)``.

        R25: the loader no longer prepends block conditions onto items, so each
        constraint-emitting pass composes them here at build time — block
        conditions take effect BEFORE item conditions, mirroring the historical
        merge order. Shared by Pass-2, the Roster bit-guarded unroll, and the
        capped-Group conditional-presence pass (all three resolve their block
        differently, then hand it here). ``block`` may be ``None`` (no enclosing
        block / block lookup miss), in which case only the item's own conditions
        are returned.
        """
        block_pre = list((block.get("precondition") if block else None) or [])
        block_post = list((block.get("postcondition") if block else None) or [])
        effective_pre = block_pre + list(item.get("precondition", []) or [])
        effective_post = block_post + list(item.get("postcondition", []) or [])
        return effective_pre, effective_post

    def condition_owner(self, item_id: str, kind: str, condition_idx: int) -> tuple[str, str]:
        """``(owner id, "block" | "item")`` of condition ``condition_idx`` of
        ``item_id``'s composed ``kind`` list (#1817).

        Block conditions come first in every composed list
        (``_compose_effective_conditions``), so an index below the block's own
        count is the block's condition, shared by each of its items: a finding
        about it belongs to the block, once. ``kind`` is ``"precondition"`` or
        ``"postcondition"``; anything else is the item's.
        """
        if kind not in ("precondition", "postcondition"):
            return item_id, "item"
        item = self.state.get_item(item_id) or {}
        block_id = item.get("blockId")
        block = self.state.get_block(block_id) if block_id else None
        if block is not None and condition_idx < len(block.get(kind) or []):
            return block_id, "block"
        return item_id, "item"

    def block_condition_reads(self) -> dict[tuple[str, str, int], dict[str, list[str]]]:
        """``{(block id, kind, condition_idx): {field: items}}``: for each block
        condition with a coverage gap, the union over its items of the items
        each gap names in ``wide_items``, ``skippable_items``,
        ``ternary_items`` and ``undecided_reads`` (#1817).

        The block predicate lowers in each item's own context, where the item's
        own outcome is answered and another member's may not be, so each item's
        gap names a different subset. The one finding reported against the
        block names them all, or the guard it suggests leaves a read unguarded.
        """
        merged: dict[tuple[str, str, int], dict[str, list[str]]] = {}
        for item_id, gaps in self.coverage_gaps.items():
            for gap in gaps:
                idx = gap.get("condition_idx", 0)
                owner, scope = self.condition_owner(item_id, gap.get("kind", ""), idx)
                if scope != "block":
                    continue
                reads = merged.setdefault((owner, gap["kind"], idx), {})
                for field in ("wide_items", "skippable_items", "ternary_items", "undecided_reads"):
                    names = reads.setdefault(field, [])
                    names.extend(n for n in gap.get(field) or [] if n not in names)
        return merged

    def _build(self):
        """Build SSA versioning and Z3 constraints from questionnaire state.

        Conditions and codeBlocks are lowered in the walk's navigation order
        (#1989): SSA versions are numbered in the order the build lowers
        assignments, and a read sees the version current at that point, so a
        build in file order would give an item the stale value of a variable
        a later-in-file item writes but the walk asks first. The order is
        ``topology``'s, which needs the dependency graph the build itself
        produces, so the first build runs in file order and, only when the
        navigation order puts the code-state items in a different order
        (``_navigation_build_order``), the state is reset and the build runs
        again in that order. One lowering produces the graph in both builds,
        so no second description of reads and writes can drift from it.

        The second build reproduces the first one's order: Kahn's min-heap on
        file index yields the lexicographically smallest topological order,
        and the second build can only add edges that order already satisfies
        (a reader now sees a variable its writer set before it). Removing an
        edge would need a cycle, and a graph with cycles keeps file order.
        """
        with profile_block("z3_static_builder_build"):
            self._build_internal(None)
            order = self._navigation_build_order()
            if order is not None:
                self._reset_build_state()
                self._build_internal(order)

    def _navigation_build_order(self) -> list[str] | None:
        """The item order the second build lowers in, or ``None`` when the file
        order already is the walk's order for every item that touches code
        state (a codeBlock, or a condition reading a variable): only their
        relative order numbers SSA versions, so a questionnaire whose other
        items move builds exactly as before. ``None`` too on a dependency
        cycle: the topology is only an order of an acyclic graph, and a cycle
        keeps its refusal (#1979) on the file-order build."""
        code_state = [
            item_id
            for item_id in self.item_order
            if self.item_details[item_id].get("code_block")
            or any(dep.startswith("var:") for dep in self.dependency_graph.get(item_id, ()))
        ]
        if len(code_state) < 2:
            return None
        topology = self.topology
        if topology.has_cycles:
            return None
        order = topology.get_topological_order()
        members = set(code_state)
        if [item_id for item_id in order if item_id in members] == code_state:
            return None
        return order

    def _build_internal(self, order: list[str] | None):
        """Internal build implementation; ``order`` is the item order of the
        condition and codeBlock pass (``None``: file order, see ``_build``)."""
        # First pass: create item outcome variables, extract domain constraints, populate item details
        # Textarea controls have string outcomes — no Z3 integer variable is created for them.
        for item in self.state.get_all_items():
            item_id = item.get("id")
            if item_id:
                # Check if this is a Textarea control (string outcome, not integer)
                input_spec = item.get("input", {})
                control = input_spec.get("control", "")
                kind = item.get("kind", "")

                rows_len: int | None = None
                cols_len: int | None = None
                questions_len: int | None = None

                if control == "Textarea":
                    # Text items have string outcomes — skip Z3 variable creation
                    self.dependency_graph[item_id] = set()
                elif kind == "MatrixQuestion":
                    # Matrix outcome is List[List[Any]] — one Z3 Int per cell.
                    # No scalar item_var: the matrix has no single outcome to constrain.
                    # rows/columns are top-level item keys, not under input_spec.
                    rows = item.get("rows", []) or []
                    columns = item.get("columns", []) or []
                    rows_len = len(rows)
                    cols_len = len(columns)
                    cells: dict[tuple[int, ...], ExprRef] = {}
                    pair_builders = (
                        self._pair_domain_builders(item_id, item) if control == "Range" else []
                    )
                    for r in range(rows_len):
                        for c in range(cols_len):
                            if control == "Range":
                                # A Range cell is a [low, high] pair: two
                                # Ints keyed (r, c, end), bound unconditionally
                                # like every matrix cell.
                                cells[(r, c, 0)], cells[(r, c, 1)] = self._range_cell(
                                    item_id, pair_builders, r, c
                                )
                                continue
                            cell_var = Int(_scoped_name(item_id, r, c), self.ctx)
                            cells[(r, c)] = cell_var
                            # Apply cell-level domain constraints (min/max or labels)
                            self._extract_domain_constraints(
                                item_id, cell_var, item, is_cell=True
                            )
                    self.item_cells[item_id] = cells
                    self.matrices.add(item_id)
                    self.dependency_graph[item_id] = set()
                elif kind == "QuestionGroup":
                    # A list with one answer per question (#184): one Int per
                    # answer, or a Range pair, bound unconditionally like a
                    # matrix cell. Whether the group or one answer is None is
                    # a choice of the predicate that reads it (skip, blank or
                    # slot, ``_answer_list_reads``), never a value of the cell.
                    # Imported here, like ``checkbox_mask``: ``askalot_qml.core``
                    # imports the engine, which imports this module.
                    from askalot_qml.core.controls import answer_shape

                    shape = answer_shape(item)
                    questions_len = shape[0] if shape else 0
                    self.item_cells[item_id] = self._question_group_cells(
                        item_id, item, questions_len, control
                    )
                    self.question_groups.add(item_id)
                    self.dependency_graph[item_id] = set()
                elif control == "Range":
                    # A Range answer is a [low, high] pair (#1474): two Ints in
                    # item_pairs, bound by the pair domain in the present-gated
                    # flush, and no scalar in item_vars.
                    lo_name, hi_name = _range_end_names(item_id)
                    self.item_pairs[item_id] = (Int(lo_name, self.ctx), Int(hi_name, self.ctx))
                    self.dependency_graph[item_id] = set()
                    self._pending_pair_domain_constraints[item_id] = self._pair_domain_builders(
                        item_id, item
                    )
                    floor, _ = self._numeric_bounds(item_id, input_spec)
                    if floor is not None:
                        self._pair_floor[item_id] = floor
                else:
                    # Item outcomes are integers (representing selected option/value)
                    item_var = Int(f"item_{item_id}", self.ctx)
                    self.item_vars[item_id] = item_var
                    self.dependency_graph[item_id] = set()

                    # Extract domain constraints D_i(S_i) from input specification
                    self._extract_domain_constraints(item_id, item_var, item)

                # R25: item_details feeds ItemClassifier (per-item Z3 W_i
                # formulas). The classifier needs the SAME composed view
                # the constraint emitter uses — block + item conditions —
                # otherwise items inheriting a block precondition would
                # be classified ALWAYS even when the block precondition
                # never holds. Compose here at population time.
                block_id_for_details = item.get("blockId")
                block_for_details = (
                    self.state.get_block(block_id_for_details) if block_id_for_details else None
                )
                composed_pre = list(
                    (block_for_details.get("precondition") if block_for_details else None) or []
                ) + list(item.get("precondition", []) or [])
                composed_post = list(
                    (block_for_details.get("postcondition") if block_for_details else None) or []
                ) + list(item.get("postcondition", []) or [])

                # Store item details for ItemClassifier compatibility
                self.item_details[item_id] = {
                    "preconditions": composed_pre,
                    "postconditions": composed_post,
                    "code_block": item.get("codeBlock", ""),
                    "control": control,
                    "kind": kind,
                    "rows_len": rows_len,
                    "cols_len": cols_len,
                    "questions_len": questions_len,
                }
                self.item_order.append(item_id)

        # U2 dedicated pass: flush per-item domain constraints into the flat
        # list, each present-gated. Runs after pass-1 (every item registered)
        # and before init/pass-2 so ``get_domain_base()`` already reflects the
        # gating when constraints are emitted.
        self._emit_present_gated_domain()

        # The string model reads the code once, with the items pass 1 just
        # registered (``_is_textarea``); a rebuild keeps it.
        if self._string_model is None:
            self._string_model = self._read_string_model()

        # Process initialization code
        init_code = self.state.get_code_init()
        if init_code:
            self._process_code_block("__init__", init_code)

        # Process each item in the build order (``_build``; Textarea items
        # have no Z3 variable to constrain).
        items = self.state.get_all_items() if order is None else [self.state.get_item(i) for i in order]
        for item in items:
            item_id = item.get("id")
            if not item_id:
                continue

            # Textarea controls have string outcomes: no Z3 constraint for their
            # conditions. Their codeBlock still runs at runtime, so it is
            # lowered (#2003), every Textarea's text opaque in it. MatrixQuestion
            # and QuestionGroup items (item_cells) and Range Questions
            # (item_pairs) hold no scalar in item_vars but still need
            # precondition/postcondition/codeBlock processing.
            if not self._has_outcome_model(item_id):
                # Its conditions are still classified at this point of the walk.
                self._submission_versions[item_id] = dict(self.version_map)
                if item.get("codeBlock"):
                    self._process_code_block(item_id, item["codeBlock"])
                continue

            # R25: block-level pre/postconditions are no longer prepended to
            # items by the loader. Compose them here at constraint-build time
            # — block conditions take effect BEFORE item conditions, mirroring
            # the historical merge order. ``idx`` indexes the composed list
            # so block-vs-item conds within the same item get distinct
            # constraint identifiers downstream.
            block_id = item.get("blockId")
            block = self.state.get_block(block_id) if block_id else None
            effective_pre, effective_post = self._compose_effective_conditions(block, item)

            # Process preconditions (path constraints)
            for idx, cond in enumerate(effective_pre):
                predicate = cond.get("predicate", "")
                if predicate:
                    constraint, deps = self._build_precondition_constraint(predicate, item_id, idx)
                    if constraint is not None:
                        # Precondition implies item can be reached.
                        # U2: outer-gated by ``present`` — Implies(present,
                        # Implies(visited, P)). present composes with the
                        # existing visited sentinel; off a capped Group/Roster present
                        # degrades to True so this is exactly the pre-U2
                        # ``Implies(visited, P)``.
                        self.constraints.append(
                            self._wrap_present(
                                item_id,
                                None,
                                Implies(
                                    self._visited_sentinel(item_id),  # Item is visited
                                    constraint,  # Precondition must be true
                                ),
                            )
                        )
                        # Dependencies are already added to dependency_graph in _build_precondition_constraint

            # Process postconditions BEFORE code blocks to match the runtime
            # lifecycle: precondition → collect outcome → postcondition → codeBlock.
            # This ensures postconditions reference variable versions from PRIOR
            # items' code blocks, not from the current item's code block (which
            # hasn't executed yet at postcondition evaluation time).
            for idx, cond in enumerate(effective_post):
                predicate = cond.get("predicate", "")
                if predicate:
                    constraint, deps = self._build_postcondition_constraint(predicate, item_id, idx)
                    if constraint is not None:
                        # If item is completed, postcondition must hold.
                        # U2: outer-gated by ``present`` (see precondition
                        # site above for the composition rationale).
                        self.constraints.append(
                            self._wrap_present(
                                item_id,
                                None,
                                Implies(
                                    self._visited_sentinel(item_id),  # Item has outcome
                                    constraint,  # Postcondition must be true
                                ),
                            )
                        )

            self._submission_versions[item_id] = dict(self.version_map)

            # Process code blocks (state transitions) — AFTER postconditions
            if "codeBlock" in item and item["codeBlock"]:
                self._process_code_block(item_id, item["codeBlock"])

        # ------------------------------------------------------------------
        # Pass 3: Roster iterateOver dependency wiring.
        #
        # Done as a SEPARATE post-pass — after pass 2's per-item loop — for
        # two reasons:
        #
        # 1. Pass 2 lowers no condition of a Textarea-controlled item (no Z3
        #    var to constrain). But roster inner items can still be Textarea (see
        #    Canonical Example A's `q_notes`), and they need their iterateOver
        #    dependency registered for topology to order them correctly.
        # 2. Doing the walk after the full pass 2 guarantees `version_map`
        #    contains every variable defined by any codeBlock in the
        #    questionnaire — even codeBlocks that live later in source order
        #    than the roster (the plan's "forward reference" requirement).
        # ------------------------------------------------------------------
        for item in self.state.get_all_items():
            item_id = item.get("id")
            iterate_over = item.get("_roster_iterate_over") if item_id else None
            if not iterate_over:
                continue
            expr_tree = self._parsed(iterate_over, "eval")
            if expr_tree is None:
                # Malformed iterateOver — surface elsewhere; don't poison the
                # dep graph silently. FlowProcessor's runtime eval will surface
                # the same error via the roster_iterate_over warning channel.
                continue
            iter_deps = self._extract_dependencies_from_ast(expr_tree)
            self.dependency_graph.setdefault(item_id, set()).update(iter_deps)

        # ------------------------------------------------------------------
        # Pass 3.5 (U3): Roster bit-guarded unroll.
        #
        # Runs AFTER Pass 3 so ``version_map`` / ``item_vars`` are fully
        # populated (the iterateOver expression may reference a variable
        # written by a codeBlock that lives later in source order than the
        # roster). Purely ADDITIVE: it appends per-iteration domain/pre/post
        # copies gated by the bit-guard ``present`` Bool, and leaves the
        # canonical single-pass emission, ``item_order``, ``item_details``,
        # ``item_vars[item_id]`` and the dependency graph byte-identical — so
        # ItemClassifier / PathBasedValidator and topology see exactly what
        # they saw pre-U3 (only the constraint *set* grows). With no Roster
        # blocks present, nothing here fires (the U2 no-op invariant holds).
        # ------------------------------------------------------------------
        self._emit_roster_bit_guarded_unroll()

        # ------------------------------------------------------------------
        # Pass 3.6: capped-Group conditional-presence.
        #
        # SIBLING of Pass 3.5 — runs immediately after it, over the same
        # fully-built dependency graph / item_vars. Pass 3.5 keys solely on
        # ``_roster_*`` tags; this pass keys solely on ``_group_*`` tags (a
        # ``count``-capped Group; an uncapped Group carries no tag and is
        # modeled unconditionally by the canonical single-pass emission). The
        # two tag families are mutually exclusive (a block has exactly one
        # kind), so no item is processed by both. Purely additive: appends
        # one conditional-presence-gated domain/pre/post copy per inner item,
        # leaving the canonical single-pass emission, item_order, item_details,
        # item_vars and the dependency graph byte-identical. With no capped
        # Group present nothing fires (the U2 no-op invariant holds).
        # ------------------------------------------------------------------
        self._emit_capped_group_conditional_presence()

        # ------------------------------------------------------------------
        # Pass 4 (U8): capped-Group inner-item independence check.
        #
        # Runs LAST, after every dependency edge is wired (Pass 2 pre/post
        # references + Pass 3 roster iterateOver + codeBlock variable
        # assignments), so the resolved item-to-item graph it reads is
        # complete. It is the validation-time half of the two-layer R10
        # enforcement: the loader catches DIRECT sibling references
        # (``_validate_group_independence``); this pass catches the transitive /
        # variable-mediated edges the loader's AST name-match cannot see (item
        # A writes a var in its codeBlock, item B's precondition reads it).
        # Records a structured ``group_dependency`` coverage gap per offending
        # edge — surfaced loudly through the same block-id-keyed
        # ``coverage_gaps`` channel ``ItemClassifier.classify_all_items``
        # already reads. With no capped Group present nothing fires.
        # ------------------------------------------------------------------
        self._emit_capped_group_independence_gaps()

        # ------------------------------------------------------------------
        # Pass 5 (U1): undefined-name lint + variable read/write census.
        #
        # Runs LAST, after SSA is complete: ``version_history`` only holds every
        # real assignment target once every codeInit/codeBlock has been
        # processed, and definedness is file-scoped (a name assigned by a
        # codeBlock LATER in source order than the predicate that reads it is
        # still defined — ordering is the topology pass's concern, not this
        # one's). A purely additive walk of stored predicate / codeBlock ASTs:
        # it records ``undefined_name`` coverage gaps and fills
        # ``variable_census``, touching no constraint, dependency edge, or
        # existing classification.
        # ------------------------------------------------------------------
        self._detect_undefined_names_and_census()

        # Pass 6 (#1784): a blank answer is admitted only where the item's own
        # postconditions accept its None, read at its submission versions
        # (recorded per item in pass 2), so it runs once the build is done.
        self._built = True
        self._emit_blank_admissibility()

    def _roster_label_keys(self, raw_labels: Any) -> list[int]:
        """Return the sorted power-of-2 label-key universe for a Roster item.

        ``_roster_labels`` is a ``{power-of-2 int : display str}`` map. YAML/
        JSON round-trips may stringify integer keys (the same coercion the
        FlowProcessor roster pass does — see ``_decorate_with_roster_progress``
        / ``_enter_roster_pass``), so keys are coerced to ``int`` here. Keys
        that are not positive powers of 2 are dropped silently: the U1 loader
        already loud-rejects malformed Roster ``labels``, so by Pass 3.5 the
        universe is well-formed; this is defence-in-depth for callers that
        bypass schema/loader validation. Sorted ascending so iteration order
        is deterministic (low bit first), matching the runtime walk.
        """
        keys: list[int] = []
        if isinstance(raw_labels, dict):
            for k in raw_labels:
                try:
                    ki = int(k)
                except (TypeError, ValueError):
                    continue
                # Positive power of two (1, 2, 4, …): n > 0 and n & (n-1) == 0.
                if ki > 0 and (ki & (ki - 1)) == 0:
                    keys.append(ki)
        return sorted(set(keys))

    def _emit_roster_bit_guarded_unroll(self) -> None:
        """U3: emit ``len(labels)`` bit-guarded copies of each Roster inner
        item's domain/pre/post constraints (R4, R7, R8).

        For a Roster inner item with label-key universe ``{2^j ...}`` and
        iterateOver expression ``E``:

        - For each label-key ``K`` (a compile-time literal power of 2) a
          per-iteration outcome var ``item_{id}@iter{K}`` is created and
          ``(item_id, K)`` is registered conditionally-present (U2 primitive
          — keeps ItemClassifier / PathBasedValidator from flagging a
          bit-unset iteration NEVER / dead-code).
        - The presence Bool is *defined* by the *literal power-of-2 mask*
          bit-test ``present(item, K)  ⇔  (E / K) % 2 == 1``. ``K`` is a
          compile-time constant, so ``/`` and ``%`` are div/mod-by-constant —
          decidable linear integer arithmetic, NO BitVec (plan Key Technical
          Decision: integer model retained).
        - The item's domain builders and its composed (block+item)
          precondition / postcondition predicates are re-emitted bound to the
          per-iteration var, each wrapped ``Implies(present(item,K), …)`` via
          ``_wrap_present``. Self ``.outcome`` references inside the
          predicates resolve to the per-iteration var by a scoped swap of
          ``self.item_vars[item_id]`` (restored in a ``finally``), mirroring
          how comprehension unrolling scopes ``local_bindings``.

        R8: bits of ``E`` beyond ``len(labels)`` are silently ignored — the
        unroll universe is exactly the declared label keys; ``E`` is never
        magnitude-validated or capped (matches runtime behavior).

        This deliberately makes the constraint count scale linearly with
        ``len(labels)`` (vs the prior flat single-pass) — that linear growth
        is the whole point of the unit; a worse-than-linear blow-up would be
        a bug (see the timing-shape assertion in the test suite).
        """
        # Track (block_id, iterate_over) pairs whose non-negativity constraint
        # has already been emitted — one constraint per Roster block is enough;
        # the expression is identical for every inner item in the same block.
        _roster_nonneg_emitted: set[tuple[str, str]] = set()

        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue
            block_id = item.get("_roster_block_id")
            iterate_over = item.get("_roster_iterate_over")
            if not block_id or not iterate_over:
                continue

            label_keys = self._roster_label_keys(item.get("_roster_labels"))
            if not label_keys:
                # No declared iteration universe → nothing to unroll. The
                # canonical single-pass emission still covers the item.
                continue

            # Lower the iterateOver expression to a Z3 int ONCE. ``E`` may be
            # a bare variable (``family_mask``) or an item outcome
            # (``q_meals_eaten.outcome``); both lower via _ast_to_z3. A
            # malformed / unsupported expression yields None — skip the
            # unroll silently (the Pass-3 dependency walk + FlowProcessor's
            # runtime eval already surface the author-facing error; emitting
            # nothing here just falls back to the canonical single-pass
            # model, never a crash).
            expr_tree = self._parsed(iterate_over, "eval")
            if expr_tree is None:
                continue
            iter_z3 = self._ast_to_z3(expr_tree.body, item_id)
            if iter_z3 is None:
                continue

            # Non-negativity invariant: the bit-guard formula (E / K) % 2 == 1
            # relies on T-division semantics matching floor-division for
            # non-negative E. A codeBlock-computed iterateOver could be
            # negative; assert >= 0 explicitly so Z3 never explores that
            # branch and produces wrong bit interpretations.
            # Emitted once per (block_id, iterate_over) — every inner item in
            # the same block re-parses the same expression, so one constraint
            # is sufficient.
            nonneg_key = (block_id, iterate_over)
            if nonneg_key not in _roster_nonneg_emitted:
                self.constraints.append(iter_z3 >= IntVal(0, self.ctx))
                _roster_nonneg_emitted.add(nonneg_key)

            # Composed (block + item) conditions — same composition order
            # Pass-2 uses (block conditions take effect BEFORE item
            # conditions). Recomputed here rather than threaded from Pass-2
            # because Pass-2's loop scope does not persist.
            block = self.state.get_block(block_id) if block_id else None
            effective_pre, effective_post = self._compose_effective_conditions(block, item)

            for k in label_keys:
                # Register the (item, k) presence gate (U2 primitive). This
                # flips ``_present_antecedent`` from True to the real Bool for
                # this key and tags the item classification-safe.
                self.mark_conditionally_present(item_id, k)

                # Bit-guard definition via the LITERAL power-of-2 mask ``k``.
                # ``(E / k) % 2 == 1`` is exactly "bit log2(k) of E is set":
                # integer division by the constant ``k`` shifts that bit to
                # the units position, ``% 2`` isolates it. Div/mod by a
                # compile-time constant stays in linear integer arithmetic
                # (decidable, cheap) — the explicit no-BitVec decision.
                bit_set = ((iter_z3 / k) % 2) == 1
                self.constraints.append(self._present_var(item_id, k) == bit_set)

                # Per-iteration outcome, its domain re-emitted present-gated:
                # a fresh Int for a scalar item, a fresh (lo, hi) pair for a
                # Range Question. Textarea / matrix / QuestionGroup inner
                # roster items have neither (no self-outcome predicate
                # lowering) — the presence gate + dependency edges still
                # apply, but there is nothing to bind, so skip the emit.
                iter_outcome = self._bind_scoped_outcome(item_id, k, f"iter{k}")
                if iter_outcome is None:
                    continue

                # Re-emit pre/post for this iteration via the shared helper:
                # scoped swap of the canonical outcome → ``self.outcome``
                # references lower to THIS iteration's var(s); restored in
                # ``finally`` so Pass-3.5 leaves the canonical model untouched.
                self._emit_pre_post_under_present(
                    item_id, k, effective_pre, effective_post, iter_outcome
                )

    def _capped_group_blocks(self) -> dict[str, list[dict[str, Any]]]:
        """Group ``count``-capped Group inner items by their block, in stable
        file order.

        Returns ``{block_id: [item, ...]}``. Items are collected in
        ``get_all_items()`` order for determinism. A capped-Group item carries
        the ``_group_block_id`` tag (set by the loader only when the Group
        declares ``count``); an uncapped Group adds no tag, so its items never
        appear here and stay on the canonical unconditional path. Group tags
        are mutually exclusive with Roster tags (a block has exactly one
        kind), so a Roster item never appears here.
        """
        blocks: dict[str, list[dict[str, Any]]] = {}
        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue
            block_id = item.get("_group_block_id")
            if not block_id:
                continue
            blocks.setdefault(block_id, []).append(item)
        return blocks

    def _emit_capped_group_conditional_presence(self) -> None:
        """Validate ``count``-capped Group blocks via the shared U2
        conditional-presence primitive — single-presence-per-item, no ordering
        enumeration (R12, R14).

        A capped Group asks at most ``count`` of its inner items in canonical
        order; any inner item can be left undrawn (precondition-skipped, or
        beyond the cap). Each inner item is therefore modeled as
        **conditionally present**: classification-safe (a not-drawn item is not
        NEVER / dead-code) and its domain/pre/post bind only when it is drawn.

        There is exactly ONE presence variable per inner item (``k = 0``): the
        item is marked conditionally-present once, and its domain/pre/post bind
        only under that present var. No ordering enumeration and no component
        permutation — a single presence var per item, emitted in canonical
        order; the inner-item independence rule is enforced in U8, out of this
        pass's scope.

        An **uncapped** Group carries no ``_group_*`` tag, so its items never
        reach this pass — they stay on the canonical unconditional single-pass
        emission, which is what keeps a genuinely unreachable item in an
        uncapped Group classifying NEVER / dead-code rather than masking it as
        CONDITIONAL (R13).

        Composition mirrors Pass-2 and the Roster unroll: the block
        precondition gates the whole block (prepended to each item's
        precondition, block-before-item order); the block postcondition
        applies to drawn items only (prepended to each item's postcondition).
        Both compose with the visited sentinel and are wrapped under the
        ``present`` gate.

        Selection-index ``k`` is always ``0`` — a single presence per item.
        Roster uses power-of-2 label keys; capped-Group items never carry
        Roster tags, so the keyspaces never collide.
        """
        for block_id, items in self._capped_group_blocks().items():
            block = self.state.get_block(block_id)

            for item in items:
                item_id = item["id"]

                # Register (item, 0) conditionally-present: flips the U2
                # antecedent from True to the real present Bool AND tags the
                # item classification-safe (a beyond-count / not-drawn item is
                # not NEVER / dead-code). Called exactly once per inner item.
                self.mark_conditionally_present(item_id, 0)

                effective_pre, effective_post = self._compose_effective_conditions(block, item)

                # Per-item presence-scoped outcome (one var, or a Range pair)
                # so the drawn item's typing/feasibility check is independent
                # of its unconditional canonical-pass outcome.
                sel_outcome = self._bind_scoped_outcome(item_id, 0, "group0")
                if sel_outcome is None:
                    # Textarea / matrix / QuestionGroup capped-Group
                    # item: nothing to bind. The presence registration above
                    # still tags it classification-safe; self.outcome-free
                    # predicates lower without a per-selection var, so skip
                    # the emit (mirrors the Roster Textarea branch in Pass 3.5).
                    continue

                # Re-emit pre/post present-gated via the shared helper. Block
                # precondition gates the whole block; composed with the item
                # precondition and the visited sentinel under the present gate
                # — block postcondition applies to drawn items only by the same
                # gate (``effective_pre``/``effective_post`` already include the
                # block-level conditions per the composition above).
                self._emit_pre_post_under_present(
                    item_id, 0, effective_pre, effective_post, sel_outcome
                )

    def _bind_scoped_outcome(
        self, item_id: str, k: int, suffix: str
    ) -> ExprRef | tuple[ExprRef, ExprRef] | None:
        """Create the ``(item, k)``-scoped copy of an item's outcome and emit
        its domain gated by ``present(item, k)``.

        Shared by the Roster unroll (``suffix`` ``iter{K}``) and the
        capped-Group pass (``group0``). A scalar item gets one Int,
        ``item_{id}@{suffix}``, bound by its scalar domain builders; a Range
        Question gets a pair, ``item_{id}@{suffix}@lo`` / ``@hi``, bound by its
        pair builders. Anything else (Textarea, matrix, QuestionGroup) has no
        scoped outcome and returns None: a condition that reads a scoped
        QuestionGroup is a coverage gap instead (``_unlowered_group_reads``).
        """
        if item_id in self.item_pairs:
            lo_name, hi_name = _range_end_names(item_id, suffix)
            pair = (Int(lo_name, self.ctx), Int(hi_name, self.ctx))
            for build in self._pending_pair_domain_constraints.get(item_id, []):
                self.domain_constraints.append(self._wrap_present(item_id, k, build(*pair)))
            return pair
        if item_id in self.item_vars:
            var = Int(_scoped_name(item_id, suffix), self.ctx)
            for build in self._pending_domain_constraints.get(item_id, []):
                self.domain_constraints.append(self._wrap_present(item_id, k, build(var)))
            return var
        return None

    def _emit_capped_group_independence_gaps(self) -> None:
        """U8 validation-time layer: flag intra-Group dependency edges in
        ``count``-capped Groups as ``group_dependency`` coverage gaps (R10).

        A capped Group asks at most ``count`` of its inner items; the draw can
        evict any of them. If one inner item depends on a SIBLING inner item of
        the same Group, the dependant's precondition / postcondition / codeBlock
        may evaluate against the undrawn sibling's ``None`` outcome at runtime.
        The runtime ``FlowProcessor`` never validates, so this — together with
        the loader's direct-reference check — is the rule's only enforcement.

        Soundness over the loader's name-match: this reads the REAL resolved
        item-to-item dependency graph (``get_item_dependencies()`` resolves
        transitive / variable-mediated edges — q_b → var:x → q_a collapses to
        q_b → q_a), so it catches the variable-mediated case the loader's AST
        name view structurally cannot. Cross-block edges are allowed: an edge is
        flagged ONLY when BOTH endpoints are inner items of the SAME capped
        Group (the dependant's ``_group_block_id`` equals the dependency's).

        Surfacing follows the existing block-level coverage-gap mechanism: the
        gap is recorded under the BLOCK id key in ``self.coverage_gaps`` (a key
        disjoint from ``item_order``), which ``ItemClassifier.classify_all_items``
        surfaces once as a synthetic block-keyed result entry. ``validate_qml_file``
        reads those gaps from ``issues[]`` (the ``group_dependency`` → issue
        mapping is wired in U10's Portor tool). No swallowed ``None`` — each
        offending edge is recorded explicitly and a loud WARNING is emitted, per
        the silent-drop learning that governs this module.

        Gap shape (one per offending edge)::

            {"kind": "group_dependency", "block_id": <id>,
             "item_id": <dependant inner item>, "depends_on": <sibling inner item>}
        """
        capped_blocks = self._capped_group_blocks()
        if not capped_blocks:
            # No capped Group → nothing to check (the common case). Avoid the
            # cost of resolving the full transitive dependency graph.
            return

        # Map every capped-Group inner item id to its block id so an edge's
        # endpoints can be tested for same-Group membership in O(1).
        item_to_block: dict[str, str] = {}
        for block_id, items in capped_blocks.items():
            for item in items:
                item_id = item.get("id")
                if item_id:
                    item_to_block[item_id] = block_id

        # Resolved item-to-item dependencies (transitive through variables).
        resolved_deps = self.get_item_dependencies()

        for item_id, block_id in item_to_block.items():
            for dep_id in sorted(resolved_deps.get(item_id, set())):
                # Flag only intra-Group edges: the dependency must be a SIBLING
                # inner item of the SAME capped Group. Cross-block edges (and
                # edges into items of a *different* capped Group) are allowed.
                if item_to_block.get(dep_id) != block_id:
                    continue
                # `get_item_dependencies` already discards self-edges, but guard
                # defensively — a self-reference is not an independence breach.
                if dep_id == item_id:
                    continue
                self._record_group_dependency_gap(block_id, item_id, dep_id)

    def _record_group_dependency_gap(
        self, block_id: str, item_id: str, depends_on: str
    ) -> None:
        """Record one capped-Group intra-dependency gap (U8) and WARN once.

        Keyed by ``block_id`` (disjoint from ``item_order``) so
        ``ItemClassifier.classify_all_items`` surfaces it as a synthetic
        block-level entry. Duplicate ``(item_id, depends_on)`` edges under the
        same block are a no-op so a re-resolved graph never double-reports.
        """
        gaps = self.coverage_gaps.setdefault(block_id, [])
        for existing in gaps:
            if (
                existing.get("kind") == "group_dependency"
                and existing.get("item_id") == item_id
                and existing.get("depends_on") == depends_on
            ):
                return
        gaps.append(
            {
                "kind": "group_dependency",
                "block_id": block_id,
                "item_id": item_id,
                "depends_on": depends_on,
            }
        )
        self.logger.warning(
            "capped Group '%s' inner item '%s' depends on sibling inner item "
            "'%s' — inner items of a count-capped Group must be independent "
            "(the draw can leave '%s' undrawn, so its outcome may be None at "
            "evaluation time). Move the dependency to a separate block or remove "
            "the count cap.",
            block_id,
            item_id,
            depends_on,
            depends_on,
        )

    def _process_code_block(self, context_id: str, code: str):
        """Process code block and create SSA versions for assignments.

        Handles ast.Assign, ast.AugAssign, and ast.Attribute targets, in
        statement order under the path of the branches holding them (#1843,
        ``_lower_code_statements``). Tracks Variable → Item/Variable
        dependencies in the dependency graph, including those from enclosing
        if-conditions for nested assignments.

        An item's codeBlock reads an item that may be ``None`` the way Python
        does (#1776, ``_CodeReads``): each assigned value is lowered with the
        item's None choice, and an assignment the block may not reach (a read
        raised first) keeps its target's old value.
        """
        tree = self._parsed(code, "exec")
        if tree is None:
            self.logger.error(f"Syntax error in code block for {context_id}")
            return
        # Build parent map so we can find enclosing if-conditions
        parent_map = self._build_parent_map(tree)
        outer_blank, self._predicate_blank = self._predicate_blank, {}
        try:
            reads = _CodeReads(self, tree, context_id, parent_map)
            entry = dict(self.version_map)
            marks = None
            if context_id != "__init__":
                marks = _UnknownMarks(
                    tree, self._version_mark, lambda item_id: self._code_blank(item_id, reads), BoolVal(True, self.ctx)
                )
            self._lower_code_assignments(tree, context_id, parent_map, reads)
            if marks is not None:
                self._settle_marks(marks, entry)
        finally:
            self._predicate_skipped, self._predicate_blank = {}, outer_blank

        for item_id in self._stored_outcomes(tree):
            if item_id is not None and self._is_question_group(item_id):
                self._record_group_write(item_id, context_id)

    def _code_blank(self, item_id: str, reads: _CodeReads) -> BoolRef | None:
        """When ``item_id`` is blank as a codeBlock reads it, for the #1044
        mark (``_UnknownMarks``): the choice the block's values read (a scalar
        Question, ``_CodeReads``), else the item's blank choice when it may be
        left blank at all (``_blank_candidate``)."""
        choice = reads._blank.get(item_id)
        if choice is None and self._blank_candidate(item_id):
            choice = self._blank_choice(item_id)
        return choice

    def _version_mark(self, var_name: str) -> BoolRef | None:
        """When the version of ``var_name`` the build reads now is marked
        unknown (``_marks``), ``None`` when never."""
        version = self.version_map.get(var_name)
        return None if version is None else self._marks.get(_ssa_key(var_name, version))

    def _settle_marks(self, marks: _UnknownMarks, entry: dict[str, int]) -> None:
        """Record the marks one codeBlock leaves (#1844), as the runtime
        settles ``_unknown_after``'s result: a variable it marked is marked;
        one it cleared keeps its incoming mark unless its value changed (the
        runtime compares the value before and after the block). A mark on a
        variable the block gave no new version (a container it mutated) joins
        that version's mark: wider for a read before the block, never
        narrower. A new version the walk neither marked nor cleared (a
        ``match`` body, a walrus: ``_unknown_after`` does not walk them, so
        the runtime keeps the mark) carries its incoming mark on."""
        versioned = {name for name, version in self.version_map.items() if entry.get(name) != version}
        for name in sorted(set(marks.marked) | set(marks.cleared) | versioned):
            before, after = entry.get(name), self.version_map.get(name)
            incoming = None if before is None else self._marks.get(_ssa_key(name, before))
            if after is None:
                continue
            if after == before:
                mark = _any(incoming, marks.marked.get(name))
            else:
                changed: BoolRef | None = BoolVal(True, self.ctx)
                if before is not None:
                    old, new = self.z3_vars.get(_ssa_key(name, before)), self.z3_vars.get(_ssa_key(name, after))
                    # Values of two sorts cannot be compared; keeping the
                    # incoming mark is the wider reading.
                    changed = None if old is None or new is None or old.sort() != new.sort() else old != new
                cleared = marks.cleared.get(name)
                kept = _all(incoming, marks._not(_all(cleared, changed)))
                mark = _any(marks.marked.get(name), kept)
            if mark is not None:
                self._marks[_ssa_key(name, after)] = mark

    def _variable_mark(self, var_name: str) -> BoolRef | None:
        """Whether a condition leaf reading ``var_name`` now reads a value the
        runtime marked unknown (#1044, #1844): a fresh ``mark@`` Bool under the
        version's mark formula, or ``None`` when it is never marked.

        The fresh Bool makes the mark a possibility, never a certainty, so a
        world without it always remains: the mark only withholds ALWAYS /
        TAUTOLOGICAL (the runtime may skip the item, or waive the check), and
        never produces NEVER / INFEASIBLE where the model without it had none.
        An open read (``_runtime_versions``) may be any version, so it takes
        any version's mark."""
        if var_name in self._open_reads:
            upper = _any(
                *(self._marks.get(_ssa_key(var_name, version)) for version, _ in self.version_history.get(var_name, []))
            )
            label = f"{var_name}@{self._open_reads[var_name]}"
        else:
            version = self.version_map.get(var_name)
            if version is None:
                return None
            upper = self._marks.get(_ssa_key(var_name, version))
            label = f"{var_name}@{version}"
        if upper is None:
            return None
        # ``@`` cannot occur in an item id, so no item or variable shares the name.
        return And(Bool(f"mark@{label}", self.ctx), upper)

    # Statements whose control flow the codeBlock lowering does not follow: a
    # variable they assign is widened to a fresh unconstrained version (#1843).
    _UNFOLLOWED_STATEMENTS = (
        ast.For,
        ast.AsyncFor,
        ast.While,
        ast.With,
        ast.AsyncWith,
        ast.Try,
        ast.TryStar,
        ast.Match,
        ast.FunctionDef,
        ast.AsyncFunctionDef,
        ast.ClassDef,
    )

    def _lower_code_assignments(
        self, tree: ast.Module, context_id: str, parent_map: dict, reads: _CodeReads
    ) -> None:
        """Lower one codeBlock's assignments in statement order, each under the
        path condition of the ``if`` / ``elif`` / ``else`` branches holding it
        (#1843), its value read through ``reads`` (#1776)."""
        self._lower_code_statements(tree.body, None, context_id, parent_map, reads)

    def _lower_code_statements(
        self,
        statements: list[ast.stmt],
        path: BoolRef | None,
        context_id: str,
        parent_map: dict,
        reads: _CodeReads,
    ) -> None:
        """Lower ``statements`` in order under ``path`` (``None``: always run).

        An assignment under a path is ``new == If(path, value, old)``: where the
        path is not taken the variable keeps its version, so an ``if`` / ``else``
        pair needs no join (the ``else`` assignment's ``old`` is the ``if``
        one's, equal to the version before both off its path) and ``if False:``
        changes nothing. A branch test is lowered as the codeBlock reads it
        (``_code_branch_test``). A loop, ``with``, ``try``, ``match`` or nested
        definition is not followed: every variable assigned in it gets a fresh
        unconstrained version (``_widen_code_statement``), wider than the
        runtime, never a wrong constant."""
        for statement in statements:
            self._widen_walrus_targets(statement, context_id, parent_map)
            if isinstance(statement, ast.Assign) or (isinstance(statement, ast.AnnAssign) and statement.value is not None):
                self._lower_code_assign(statement, path, context_id, parent_map, reads)
            elif isinstance(statement, ast.AugAssign):
                self._lower_code_aug_assign(statement, path, context_id, parent_map, reads)
            elif isinstance(statement, ast.If):
                mints = self._code_mints
                test = self._code_branch_test(statement, context_id, reads)
                if self._code_mints > mints:
                    # A test the block cannot decide (text it does not hold
                    # exactly): what either branch assigns is undecided
                    # wherever a condition reads it.
                    self._undecided_variables.update(
                        n.id
                        for branch in (*statement.body, *statement.orelse)
                        for n in ast.walk(branch)
                        if isinstance(n, ast.Name) and isinstance(n.ctx, ast.Store)
                    )
                # A test that raises runs neither branch (the block stops,
                # ``CodeExecutionError``); later statements see it through
                # ``_CodeReads`` (``_halted_within`` / ``_halted_before``).
                raised = reads._statement_raise(statement)
                ran = [p for p in (path, Not(raised) if raised is not None else None) if p is not None]
                taken = And(*ran, test) if ran else test
                skipped = And(*ran, Not(test)) if ran else Not(test)
                self._lower_code_statements(statement.body, taken, context_id, parent_map, reads)
                self._lower_code_statements(statement.orelse, skipped, context_id, parent_map, reads)
            elif isinstance(statement, self._UNFOLLOWED_STATEMENTS):
                self._widen_code_statement(statement, context_id, parent_map)

    def _code_branch_test(self, statement: ast.If, context_id: str, reads: _CodeReads) -> BoolRef:
        """An ``if`` test as the codeBlock reads it: lowered with the items'
        None choices (``_skip_aware_equality``), so ``if q.outcome != 1:`` is
        taken for everyone who skipped ``q``. A free Bool where it does not
        lower, or where a read in it may raise or carries a ``None`` the
        lowering does not hold (``_CodeReads``: ``raise`` / ``other`` /
        ``flow``): either branch may then be taken, wider than the runtime."""
        unheld = any(
            effect in ("raise", "other", "flow") and reads._within(node, statement.test)
            for node, effect, _, _ in reads._reads.get(id(statement), [])
        )
        test = None
        if not unheld:
            self._predicate_skipped = reads.choices
            try:
                test = self._ast_to_z3_bool(statement.test, context_id)
            finally:
                self._predicate_skipped = {}
        if test is None:
            if self._text_left_unlowered(statement.test, frozenset()):
                # A test on text the block cannot decide leaves what it assigns
                # undecided, and that is said where a condition reads it.
                self._note_undecided(None)
            self._code_raise_count += 1
            # ``@`` cannot occur in an item id, so no item or variable shares the name.
            test = Bool(f"branch@{context_id}#{self._code_raise_count}", self.ctx)
        return test

    def _text_left_unlowered(self, node: ast.AST, bound: frozenset[str]) -> bool:
        """Whether a comparison with text in ``node`` is one the model cannot
        decide (refused, a Textarea's text, or an operand it does not hold
        exactly), each read with the names the comprehensions around it bind
        (``bound``), so a test that does not lower for another reason (a
        comparison it decides beside a call) mints nothing
        (``_code_branch_test``)."""
        if isinstance(node, ast.Compare):
            found = self._string_comparison(node, bound)
            if found.kind is _CompareKind.REFUSED or found.how in (_Operand.TEXT, _Operand.UNDECIDED):
                return True
            if any(self._text_left_unlowered(part, bound) for part in found.parts):
                return True
        if isinstance(node, (ast.ListComp, ast.SetComp, ast.GeneratorExp, ast.DictComp)):
            inner = set(bound)
            for generator in node.generators:
                if self._text_left_unlowered(generator.iter, frozenset(inner)):
                    return True
                inner.update(n.id for n in ast.walk(generator.target) if isinstance(n, ast.Name))
                if any(self._text_left_unlowered(test, frozenset(inner)) for test in generator.ifs):
                    return True
            parts = [node.key, node.value] if isinstance(node, ast.DictComp) else [node.elt]
            return any(self._text_left_unlowered(part, frozenset(inner)) for part in parts)
        return any(self._text_left_unlowered(child, bound) for child in ast.iter_child_nodes(node))

    @staticmethod
    def _on_path(path: BoolRef | None, value: ExprRef | None, old: ExprRef) -> ExprRef | None:
        """``value`` where ``path`` holds, ``old`` elsewhere (``_lower_code_statements``);
        ``None`` (unconstrained) when the two cannot be one variable's value."""
        if path is None or value is None:
            return value
        if value.sort() != old.sort():
            return None
        return If(path, value, old)

    def _path_old_value(self, var_name: str, context_id: str) -> ExprRef:
        """What ``var_name`` holds off an assignment's path: its current version,
        or a fresh Int when it has none (unbound there; no version 0 is seeded,
        so the SSA numbering does not move)."""
        if var_name in self.version_map:
            return self._get_current_z3_var(var_name)
        self._code_raise_count += 1
        return Int(f"unbound@{context_id}#{self._code_raise_count}", self.ctx)

    def _lower_code_assign(
        self,
        node: ast.Assign | ast.AnnAssign,
        path: BoolRef | None,
        context_id: str,
        parent_map: dict,
        reads: _CodeReads,
    ) -> None:
        """One ``=`` statement of a codeBlock under ``path`` (an annotated one,
        ``x: int = v``, binds like ``x = v``; its annotation is never
        evaluated): a variable target gets a new SSA version, an
        ``item.outcome`` target a write constraint, and each name an unpacking
        target binds is widened."""
        enclosing_deps = self._get_enclosing_if_deps(node, parent_map)
        reads.mark_ran(node, path)
        for target in node.targets if isinstance(node, ast.Assign) else [node.target]:
            if isinstance(target, ast.Name):
                var_name = target.id
                if var_name not in self.item_vars:
                    rhs_deps = self._extract_dependencies_from_ast(node.value)
                    rhs_deps.update(enclosing_deps)
                    old = reads.old_value(var_name)
                    mints = self._code_mints
                    value = self._lower_code_value(
                        node.value, context_id, reads, encoded=self._string_model.encoded(var_name)
                    )
                    if self._code_mints > mints:
                        # Computed from a value the block cannot decide.
                        self._undecided_variables.add(var_name)
                    z3_value = reads.guarded(node, value, old)
                    if path is not None:
                        z3_value = self._on_path(path, z3_value, self._path_old_value(var_name, context_id))
                    self._register_variable_assignment(var_name, z3_value, rhs_deps, context_id)
            elif isinstance(target, ast.Attribute) and target.attr == "outcome":
                # Handle item.outcome = expr (e.g., q_total.outcome = q1.outcome + q2.outcome)
                if isinstance(target.value, ast.Name):
                    self._register_outcome_assignment(
                        target.value.id, node.value, enclosing_deps, context_id, reads, node, path
                    )
            elif isinstance(target, (ast.Tuple, ast.List)):
                # Unpacking is not lowered: each name it binds is widened.
                deps = self._extract_dependencies_from_ast(node.value) | enclosing_deps
                for name in ast.walk(target):
                    if isinstance(name, ast.Name) and name.id not in self.item_vars:
                        self._register_variable_assignment(name.id, None, set(deps), context_id)

    def _lower_code_aug_assign(
        self, node: ast.AugAssign, path: BoolRef | None, context_id: str, parent_map: dict, reads: _CodeReads
    ) -> None:
        """One augmented assignment (``score += q1.outcome``) under ``path``."""
        enclosing_deps = self._get_enclosing_if_deps(node, parent_map)
        target = node.target
        if isinstance(target, ast.Name):
            var_name = target.id
            if var_name not in self.item_vars:
                # Dependencies: RHS + current variable value + enclosing conditions
                rhs_deps = self._extract_dependencies_from_ast(node.value)
                rhs_deps.update(enclosing_deps)
                if var_name in self.version_map:
                    rhs_deps.add(f"var:{var_name}")
                # Build Z3 value: old_value OP rhs
                mints = self._code_mints
                rhs_z3 = self._lower_code_value(node.value, context_id, reads)
                if self._code_mints > mints:
                    # Computed from a value the block cannot decide.
                    self._undecided_variables.add(var_name)
                if self._carries_string(target) or self._carries_string(node.value):
                    # ``s += 1`` raises on a string, ``s += "a"`` makes one.
                    rhs_z3 = None
                old_z3 = self._get_current_z3_var(var_name)
                z3_value = reads.guarded(node, self._apply_aug_op(node.op, old_z3, rhs_z3, node.value), old_z3)
                z3_value = self._on_path(path, z3_value, old_z3)
                self._register_variable_assignment(var_name, z3_value, rhs_deps, context_id)
        elif isinstance(target, ast.Attribute) and target.attr == "outcome":
            # Handle item.outcome += expr
            if isinstance(target.value, ast.Name):
                item_id = target.value.id
                if item_id in self.item_vars:
                    rhs_deps = self._extract_dependencies_from_ast(node.value)
                    rhs_deps.update(enclosing_deps)
                    rhs_deps.add(item_id)
                    self._add_code_write_dependencies(context_id, rhs_deps)

    def _add_code_write_dependencies(self, context_id: str, deps: set[str]) -> None:
        """The item whose codeBlock writes an outcome depends on the items the
        written value reads."""
        if context_id in self.dependency_graph:
            self.dependency_graph[context_id].update(
                d for d in deps if not d.startswith("var:") and d != context_id
            )

    def _widen_code_statement(self, statement: ast.stmt, context_id: str, parent_map: dict) -> None:
        """Every variable ``statement`` may assign (an assignment, augmented
        assignment or loop target anywhere in it) gets one fresh unconstrained
        version, in place of what it computes (#1843); an outcome it writes
        keeps only its dependency edges."""
        widened: dict[str, set[str]] = {}
        for node in ast.walk(statement):
            if isinstance(node, (ast.Assign, ast.AugAssign, ast.AnnAssign)):
                targets = node.targets if isinstance(node, ast.Assign) else [node.target]
                value_deps = (
                    self._extract_dependencies_from_ast(node.value) if node.value is not None else set()
                ) | self._get_enclosing_if_deps(node, parent_map)
                for target in targets:
                    if isinstance(target, ast.Attribute) and target.attr == "outcome" and isinstance(target.value, ast.Name):
                        self._add_code_write_dependencies(context_id, value_deps)
                    for name in ast.walk(target):
                        if isinstance(name, ast.Name):
                            widened.setdefault(name.id, set()).update(value_deps)
            elif isinstance(node, (ast.For, ast.AsyncFor)):
                widened_deps = self._extract_dependencies_from_ast(node.iter)
                for name in ast.walk(node.target):
                    if isinstance(name, ast.Name):
                        widened.setdefault(name.id, set()).update(widened_deps)
        for name in self._bound_names(statement):
            widened.setdefault(name, set())
        for var_name, deps in widened.items():
            if var_name not in self.item_vars:
                self._register_variable_assignment(var_name, None, deps, context_id)

    @staticmethod
    def _bound_names(node: ast.AST) -> set[str]:
        """Every name ``node`` may bind: a store-context name (any target,
        ``with … as``, a walrus, a comprehension target), an ``except … as``
        name, a ``match`` capture, and a nested definition's own name."""
        names: set[str] = set()
        for child in ast.walk(node):
            if isinstance(child, ast.Name) and isinstance(child.ctx, ast.Store):
                names.add(child.id)
            elif isinstance(child, ast.ExceptHandler) and child.name:
                names.add(child.name)
            elif isinstance(child, (ast.MatchAs, ast.MatchStar)) and child.name:
                names.add(child.name)
            elif isinstance(child, ast.MatchMapping) and child.rest:
                names.add(child.rest)
            elif isinstance(child, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
                names.add(child.name)
        return names

    def _widen_walrus_targets(self, statement: ast.stmt, context_id: str, parent_map: dict) -> None:
        """A walrus (``(y := v)``) in a statement's own expressions binds ``y``
        before the statement completes; it is not lowered, so ``y`` gets a
        fresh unconstrained version. Expressions of nested statements are
        theirs (``_lower_code_statements`` reaches them)."""
        own = [
            child
            for field, value in ast.iter_fields(statement)
            if field not in ("body", "orelse", "finalbody", "handlers", "cases")
            for child in (value if isinstance(value, list) else [value])
            if isinstance(child, ast.AST)
        ]
        names = {
            node.target.id
            for expression in own
            for node in ast.walk(expression)
            if isinstance(node, ast.NamedExpr) and isinstance(node.target, ast.Name)
        }
        for name in sorted(names - set(self.item_vars)):
            self._register_variable_assignment(name, None, set(), context_id)

    def _lower_code_value(
        self, node: ast.AST, context_id: str, reads: _CodeReads, *, encoded: bool = False
    ) -> ExprRef | None:
        """Lower one codeBlock value with the None choices of the items it
        reads (#1776): ``==`` / ``!=`` / ``in`` / truth tests see ``None``
        under them (``_skip_aware_equality``, ``_skipped_operand``). For a
        variable that may hold text (``encoded``) the value is encoded
        (``_encode``); any other target takes no value built from text."""
        self._predicate_skipped = reads.choices
        try:
            if encoded:
                return self._encode(node, context_id)
            if self._carries_string(node):
                return None
            return self._ast_to_z3(node, context_id)
        finally:
            self._predicate_skipped = {}

    def _register_variable_assignment(
        self, var_name: str, z3_value: ExprRef | None, deps: set[str], context_id: str
    ):
        """Register an SSA variable assignment with dependencies and Z3 constraint."""
        before_version = self.version_map.get(var_name)
        new_version = self._get_next_version(var_name)
        versioned_name = _ssa_key(var_name, new_version)
        var_node = f"var:{var_name}"

        # Create Z3 variable for this version
        z3_var = Int(_ssa_symbol(var_name, new_version), self.ctx)
        self.z3_vars[versioned_name] = z3_var

        # Initialize variable node in dependency graph if needed
        if var_node not in self.dependency_graph:
            self.dependency_graph[var_node] = set()

        # Add dependencies from RHS to the variable node
        self.dependency_graph[var_node].update(deps)
        self._variable_writers.setdefault(var_name, []).append((context_id, frozenset(deps)))
        self._assignment_values.append((var_name, new_version, context_id, z3_value, frozenset(deps)))

        # Track definition source
        self.variable_definitions[(var_name, new_version)] = context_id
        # A version with no value, or one a Roster / capped-Group writer
        # leaves free below, holds anything (``_lower_string_compare``).
        if z3_value is None or (context_id != "__init__" and not self._plain_writer(context_id)):
            self._free_variables.add(var_name)
        # A value computed from an undecided variable is undecided too.
        if any(dep.startswith("var:") and dep[4:] in self._undecided_variables for dep in deps):
            self._undecided_variables.add(var_name)

        # Variable depends on the item that defines it
        # (if defined in an item's codeBlock, not in __init__)
        if self._item_code(context_id):
            self.dependency_graph[var_node].add(context_id)

        # Update version tracking AFTER evaluating RHS
        self.version_map[var_name] = new_version
        if var_name not in self.version_history:
            self.version_history[var_name] = []
        self.version_history[var_name].append((new_version, context_id))

        # Build constraint for assignment - store in codeblock_constraints.
        if context_id != "__init__":
            # A Roster member's codeBlock runs once per iteration (any number of
            # times) and a capped-Group member's only when drawn; one SSA
            # version holds neither, so such a write stays free (wider, never a
            # false INFEASIBLE), as ``_accumulator_reachability`` leaves it.
            if self._plain_writer(context_id):
                before = self.z3_vars[_ssa_key(var_name, before_version)] if before_version is not None else None
                self.codeblock_constraints.extend(
                    _gated_write(z3_var, z3_value, before, self._code_visited(context_id))
                )
        elif z3_value is not None:
            # codeInit assignment: unconditional ``var_i == value``. Recorded
            # separately (U2) so ``get_reachability_base`` can propagate the
            # constant IFF this variable turns out to be frozen (no codeBlock
            # ever reassigns it — decided at accessor time against
            # ``version_history``).
            init_constraint = z3_var == z3_value
            self.codeblock_constraints.append(init_constraint)
            self.codeinit_constant_constraints.setdefault(var_name, []).append(init_constraint)

    def _register_outcome_assignment(
        self,
        item_id: str,
        value_node: ast.AST,
        enclosing_deps: set[str],
        context_id: str,
        reads: _CodeReads,
        statement: ast.stmt,
        path: BoolRef | None = None,
    ):
        """Register item.outcome = expr, tracking dependencies without creating SSA.

        Under a branch ``path`` (#1843) the write holds only where the path does.

        The dependency edges count for any modelled target. The value is
        equated for a scalar target, and for a Range Question when the RHS is
        a two-element list/tuple literal whose elements lower: each end is
        equated with its element. Any other write to a Range item (another
        RHS shape, a Range matrix or QuestionGroup target) is recorded as a
        ``codeBlock`` coverage gap naming the Range item — the runtime still
        writes the pair, so dropping it silently would leave later conditions
        on it proven against a wider model than the real one. A non-Range
        matrix target stays unconstrained.
        """
        if not self._has_outcome_model(item_id):
            return

        rhs_deps = self._extract_dependencies_from_ast(value_node)
        rhs_deps.update(enclosing_deps)

        # The item that contains this codeBlock depends on the RHS items
        self._add_code_write_dependencies(context_id, rhs_deps)

        # Build Z3 constraint for the outcome assignment
        if self._is_question_group(item_id):
            return
        if self._is_range_item(item_id):
            self._register_range_outcome_assignment(item_id, value_node, context_id, reads, statement, path)
            return
        if item_id not in self.item_vars:
            return
        target = self.item_vars[item_id]
        # A value that may be text does not lower (``_lower_code_value``):
        # the answer is then ``text_stored``, and each read of it is its free
        # Int (``_unmodelled_read``).
        lowered = self._lower_code_value(value_node, context_id, reads)
        z3_value = reads.guarded(statement, lowered, target, variable=False)
        if z3_value is not None and self._item_code(context_id):
            self.codeblock_constraints.append(
                Implies(self._code_ran(context_id, path), self.item_vars[item_id] == z3_value)
            )

    def _code_ran(self, context_id: str, path: BoolRef | None) -> BoolRef:
        """When a write of ``context_id``'s codeBlock happens: the item was
        visited and, inside a branch, its path was taken (#1843)."""
        sentinel = self._code_visited(context_id)
        return sentinel if path is None else And(sentinel, path)

    def _item_code(self, context_id: str) -> bool:
        """Whether ``context_id`` is an item's codeBlock (not codeInit): every
        item's, a Textarea's included (#2003), since the runtime runs them all."""
        return context_id in self.item_details

    def _code_visited(self, context_id: str) -> BoolRef:
        """When ``context_id``'s codeBlock runs, the antecedent of its writes.

        An item asked at most once per walk (``_plain_writer``) runs its
        codeBlock on every walk when it has no effective precondition, and
        otherwise only when its gate let it through: ``_writer_ran``, a free
        ``ran@{id}`` Bool (#1994). The visited sentinel cannot stand for that:
        the answer domain makes ``item >= 0`` hold for every choice, so it
        would model a gated writer's codeBlock as always running, and a check
        holding exactly when the writer was skipped as INFEASIBLE.
        Only the outcome writes of a Roster or capped-Group member ask here
        (its variable writes stay free, ``_register_variable_assignment``):
        one with an outcome model keeps its visited sentinel, one without (a
        Textarea, #2003) gets a free ``ran@{id}``."""
        if self._plain_writer(context_id):
            return self._writer_ran(context_id)
        if self._has_outcome_model(context_id):
            return self._visited_sentinel(context_id)
        # ``@`` cannot occur in an item id, so no item or variable shares the name.
        return Bool(f"ran@{context_id}", self.ctx)

    def _record_group_write(self, item_id: str, context_id: str) -> None:
        """A codeBlock write to a QuestionGroup outcome (the list, one answer,
        or anything else) is a ``codeBlock`` coverage gap naming the group
        (#184, KD3): nothing writes one today, and conditions read later are
        proven without it."""
        for gap in self.coverage_gaps.get(context_id, []):
            if gap.get("kind") == "codeBlock":
                if item_id not in gap.setdefault("group_items", []):
                    gap["group_items"].append(item_id)
                return
        self._record_coverage_gap(context_id, "codeBlock", 0, [], group_items=[item_id])

    def _register_range_outcome_assignment(
        self,
        item_id: str,
        value_node: ast.AST,
        context_id: str,
        reads: _CodeReads,
        statement: ast.stmt,
        path: BoolRef | None = None,
    ) -> None:
        """Equate a Range Question's ends with a ``[a, b]`` literal write, or
        record the write as a coverage gap when the model cannot hold it.

        Under the same gate as the scalar path: a codeBlock of an item with no
        outcome model (codeInit included) contributes no constraint.
        """
        ends: list[ExprRef | None] = []
        if (
            item_id in self.item_pairs
            and isinstance(value_node, (ast.List, ast.Tuple))
            and len(value_node.elts) == 2
        ):
            lo, hi = self.item_pairs[item_id]
            ends = [
                reads.guarded(statement, self._lower_code_value(elt, context_id, reads), old, variable=False)
                for elt, old in ((value_node.elts[0], lo), (value_node.elts[1], hi))
            ]
        if len(ends) == 2 and all(end is not None for end in ends):
            if self._item_code(context_id):
                lo, hi = self.item_pairs[item_id]
                sentinel = self._code_ran(context_id, path)
                self.codeblock_constraints.append(Implies(sentinel, lo == ends[0]))
                self.codeblock_constraints.append(Implies(sentinel, hi == ends[1]))
            return
        for gap in self.coverage_gaps.get(context_id, []):
            if gap.get("kind") == "codeBlock":
                if item_id not in gap["range_items"]:
                    gap["range_items"].append(item_id)
                return
        self._record_coverage_gap(context_id, "codeBlock", 0, [], [item_id])

    @staticmethod
    def _apply_aug_op(
        op: ast.operator, left: ExprRef | None, right: ExprRef | None, right_node: ast.AST
    ) -> ExprRef | None:
        """Apply augmented assignment operator to Z3 expressions, under the
        same rule as ``_ast_to_z3``: ``//=`` and ``%=`` only by a positive
        literal, ``/=`` never (#1767) and ``&=`` only by a literal (#2037); the
        caller refuses text (``_carries_string``, #2048)."""
        if left is None or right is None:
            return None
        if isinstance(op, ast.Add):
            return left + right
        elif isinstance(op, ast.Sub):
            return left - right
        elif isinstance(op, ast.Mult):
            return left * right
        elif isinstance(op, ast.FloorDiv) and _z3_division_agrees(op, right_node):
            return left / right
        elif isinstance(op, ast.Mod) and _z3_division_agrees(op, right_node):
            return left % right
        elif isinstance(op, ast.BitAnd) and (mask := _int_literal(right_node)) is not None:
            return _masked(left, mask)
        return None

    @staticmethod
    def _build_parent_map(tree: ast.AST) -> dict:
        """Build a mapping from child nodes to their parent nodes."""
        parent_map = {}
        for node in ast.walk(tree):
            for child in ast.iter_child_nodes(node):
                parent_map[child] = node
        return parent_map

    def _get_enclosing_if_deps(self, node: ast.AST, parent_map: dict) -> set[str]:
        """Extract dependencies from all enclosing if-conditions of a node."""
        deps = set()
        current = node
        while current in parent_map:
            parent = parent_map[current]
            if isinstance(parent, ast.If):
                deps.update(self._extract_dependencies_from_ast(parent.test))
            current = parent
        return deps

    def _get_next_version(self, var_name: str) -> int:
        """Get next SSA version number for a variable."""
        current = self.version_map.get(var_name, -1)
        return current + 1

    def _get_current_z3_var(self, var_name: str) -> ExprRef | None:
        """Get current Z3 variable for a given variable name."""
        if var_name in self.item_vars:
            return self.item_vars[var_name]
        if var_name in self._open_reads:
            return self._open_reads[var_name]

        current_version = self.version_map.get(var_name)
        if current_version is not None:
            versioned_name = _ssa_key(var_name, current_version)
            return self.z3_vars.get(versioned_name)

        # Variable not yet defined - create version 0
        z3_var = Int(_ssa_symbol(var_name, 0), self.ctx)
        self.z3_vars[_ssa_key(var_name, 0)] = z3_var
        self.version_map[var_name] = 0
        return z3_var

    def _unsupported_node_kinds(self, tree: ast.AST) -> list[str]:
        """Return AST node-type names of nodes the static translator can't lower.

        Empty list means "the predicate body is fully within the supported
        subset" — used as the silent-drop guard so we only WARN when the
        predicate clearly intended a real constraint (some Call / ListComp /
        GeneratorExp / Subscript was present, or a None test the author can
        make provable by moving it first, #1250: ``Is``).

        ``Is`` is reported only for a test on an item ``_answerable`` that
        ``none_guarded_outcomes`` rejected, because that is the one a rewrite
        clears; a None test on a variable or on a list or pair item was never
        modelled, and a warning there could not be cleared.

        A use of a string the lowering refuses is ``Str`` (``_string_refusal``).
        A division Z3 reads differently from Python is reported by its operator
        (``Div``, ``FloorDiv``, ``Mod``; ``_z3_division_agrees``). No variable
        can hold a fraction: the loader refuses every construct that makes one
        (#1813).
        """
        unsupported: list[str] = []
        guarded = none_guarded_outcomes(tree)
        # A comprehension's own names hold its iteration values, numbers.
        local = self._collect_bound_names(tree)
        for node in ast.walk(tree):
            if isinstance(node, (ast.Call, ast.ListComp, ast.GeneratorExp, ast.Subscript)):
                kind_name = type(node).__name__
            elif self._string_refusal(node, local):
                kind_name = "Str"
            elif isinstance(node, ast.BinOp) and not _z3_division_agrees(node.op, node.right):
                kind_name = type(node.op).__name__
            elif (
                (found := none_test_of(node)) is not None
                and found[0] not in guarded
                and self._answerable(found[0])
            ):
                kind_name = "Is"
            else:
                continue
            if kind_name not in unsupported:
                unsupported.append(kind_name)
        return unsupported

    def _record_coverage_gap(
        self,
        item_id: str,
        kind: str,
        condition_idx: int,
        unsupported_nodes: list[str],
        range_items: list[str] | None = None,
        group_items: list[str] | None = None,
        matrix_items: list[str] | None = None,
        skippable_items: list[str] | None = None,
        wide_items: list[str] | None = None,
        ternary_items: list[str] | None = None,
        undecided_reads: list[str] | None = None,
    ) -> None:
        """Record a coverage gap (R13) and emit a one-shot WARNING (R7).

        ``kind`` is ``"precondition"``, ``"postcondition"`` or ``"codeBlock"``
        (a Range outcome write the model cannot hold). WARNING is
        emitted exactly once per (item_id, kind, condition_idx) — duplicate
        calls for the same triple are a no-op. ``range_items`` names the Range
        items the condition read in a form the model does not represent; the
        gap carries the key only when there are any, so the message can name
        the Range cause. ``group_items`` likewise names the QuestionGroups it
        read, or a codeBlock wrote, in a form the model does not hold (#184),
        ``matrix_items`` the MatrixQuestions it read other than cell by
        cell (#1781), and ``skippable_items`` the Questions a refused
        ``len(set([...])) == k`` holds that may read ``None`` (#1799), and
        ``ternary_items`` the skippable Questions it read through a ternary
        branch (#1867).
        ``wide_items`` marks a condition that DID lower, but wider than it is:
        the items whose raise on ``None`` the lowering could not place (#1775),
        so the classifier withholds the verdicts only a narrower formula proves
        (#1815). ``undecided_reads`` names the variables and items a condition
        that did lower compares with a string through a free Bool
        (``_string_choice``): what it decides about them is not proven.
        """
        gaps = self.coverage_gaps.setdefault(item_id, [])
        # Deduplicate by (kind, condition_idx) — same condition shouldn't log twice.
        for existing in gaps:
            if existing.get("kind") == kind and existing.get("condition_idx") == condition_idx:
                return
        gap: dict[str, Any] = {
            "kind": kind,
            "condition_idx": condition_idx,
            "unsupported_nodes": list(unsupported_nodes),
        }
        if range_items:
            gap["range_items"] = list(range_items)
        if group_items:
            gap["group_items"] = list(group_items)
        if matrix_items:
            gap["matrix_items"] = list(matrix_items)
        if skippable_items:
            gap["skippable_items"] = list(skippable_items)
        if ternary_items:
            gap["ternary_items"] = list(ternary_items)
        if wide_items:
            gap["wide_items"] = list(wide_items)
        if undecided_reads:
            gap["undecided_reads"] = list(undecided_reads)
        gaps.append(gap)
        if undecided_reads and not wide_items:
            self.logger.warning(
                "static validator left a comparison of %s with a string undecided in %s on %s #%d",
                undecided_reads,
                kind,
                item_id,
                condition_idx,
            )
            return
        if wide_items:
            self.logger.warning(
                "static validator lowered %s on %s #%d wider than it is: a raise on None of %s "
                "is not placed, so only NEVER / INFEASIBLE are proven",
                kind,
                item_id,
                condition_idx,
                wide_items,
            )
            return
        self.logger.warning(
            "static validator skipped %s on %s #%d: unsupported AST node(s) %s, "
            "Range outcome(s) the model does not hold %s — runtime enforcement still applies, but "
            "classification falls back to NONE",
            kind,
            item_id,
            condition_idx,
            unsupported_nodes,
            range_items or [],
        )

    # ------------------------------------------------------------------
    # U1: undefined-name lint + variable read/write census
    # ------------------------------------------------------------------

    def _known_name_set(self) -> set[str]:
        """Names that legitimately resolve in a predicate / codeBlock.

        The closed evaluation namespace: every item id (scalar, matrix,
        Textarea, Comment — all carry an ``item_details`` entry), every name any
        codeInit/codeBlock binds at runtime, and every safe builtin/module the
        sandbox exposes.

        Two deliberate choices in the variable half:
        - ``version_history`` — NOT ``version_map`` — is the SSA oracle:
          ``_get_current_z3_var`` seeds ``version_map`` with a version-0 entry
          for every phantom it lowers, so ``version_map`` would mask exactly the
          defect this lint targets; ``version_history`` only ever grows through
          ``_register_variable_assignment`` (genuine assignments).
        - ``_all_bound_code_names`` additionally covers names the SSA layer does
          not model but the runtime still binds — tuple-unpacking / for-loop /
          walrus / with-as targets — so those are never mis-flagged as phantoms.
          It is a superset of the ``version_history`` Name-target assignments;
          both are unioned for clarity of intent.
        """
        return (
            set(self.item_details.keys())
            | set(self.version_history.keys())
            | self._all_bound_code_names()
            | _safe_eval_names()
        )

    def _all_bound_code_names(self, include_init: bool = True) -> set[str]:
        """Every name a codeInit / codeBlock binds *in a scope that leaks*.

        File-scoped by design: definedness does not depend on source order, and a
        name a codeBlock binds is valid to read in any predicate. A genuine
        phantom — never a binding target anywhere — is absent from this set and
        stays flagged.

        Crucially this counts only names bound at code-unit (module) scope —
        assignment / augmented-assignment / for-target / ``with ... as`` /
        walrus / import / def / class targets that actually persist after the
        code unit runs. Comprehension, generator, and lambda locals do NOT leak
        in Python 3, so a name used only as a comprehension loop variable in one
        unit must never define (or un-freeze) a same-named variable in an
        unrelated unit. Using the scope-flattened ``_collect_bound_names`` here
        instead would let an unrelated ``[… for X in …]`` silently suppress a
        real undefined_name / frozen-gate / write-only finding elsewhere in the
        document (the file-wide-union suppression class).

        ``include_init=False`` restricts the walk to item codeBlocks (excludes
        codeInit): the set of names any codeBlock re-binds at leaking scope, used
        by ``_frozen_variable_names`` to un-freeze a codeInit constant a codeBlock
        rebinds through a construct SSA does not model (tuple/list unpack,
        for-loop target, walrus, ``with ... as``). Frozenness must not be
        defeated by codeInit's own bindings, so those are dropped here.
        """
        names: set[str] = set()
        code_units: list[str | None] = [self.state.get_code_init()] if include_init else []
        code_units.extend(item.get("codeBlock") for item in self.state.get_all_items())
        for code in code_units:
            if not code:
                continue
            tree = self._parsed(code, "exec")
            if tree is not None:
                names |= self._collect_leaking_bound_names(tree)
        return names

    @staticmethod
    def _collect_leaking_bound_names(tree: ast.AST) -> set[str]:
        """Names bound at the code unit's own (module-level) scope — the names
        that persist after the unit runs and are therefore visible to any other
        predicate / codeBlock in the document.

        Unlike ``_collect_bound_names`` (a scope-flattened over-approximation
        that is correct only as a *per-unit local mask*), this deliberately does
        NOT descend into comprehensions, generator expressions, or lambdas: their
        loop variables and parameters are local to that expression and never leak
        (Python 3 comprehension scoping). Walking those in a file-wide union is
        exactly what let an unrelated ``[… for X in …]`` suppress a real finding
        for a same-named module-scope variable elsewhere.

        Covers the leaking binders: assignment / augmented-assignment / annotated
        targets, ``for`` / ``async for`` targets (statement loops, not
        comprehensions), ``with ... as`` / ``except ... as``, statement-level
        walrus, ``import`` / ``from … import`` aliases, and ``def`` / ``async
        def`` / ``class`` names. Nested function/lambda *bodies* are not
        descended into — a name bound only inside a nested def does not leak to
        the code unit either.
        """
        leaking: set[str] = set()

        def _add_target(target: ast.AST) -> None:
            # Assignment / for / with-as targets: a Name (possibly nested in
            # Tuple/List/Starred unpacking) binds at this scope. Attribute and
            # Subscript targets bind nothing new.
            if isinstance(target, ast.Name):
                leaking.add(target.id)
            elif isinstance(target, (ast.Tuple, ast.List)):
                for elt in target.elts:
                    _add_target(elt)
            elif isinstance(target, ast.Starred):
                _add_target(target.value)

        def _walk_stmt(node: ast.AST) -> None:
            for child in ast.iter_child_nodes(node):
                if isinstance(child, ast.Assign):
                    for tgt in child.targets:
                        _add_target(tgt)
                    _walk_stmt(child)  # a walrus can hide in the RHS value
                elif isinstance(child, (ast.AugAssign, ast.AnnAssign)):
                    _add_target(child.target)
                    _walk_stmt(child)
                elif isinstance(child, (ast.For, ast.AsyncFor)):
                    _add_target(child.target)
                    _walk_stmt(child)
                elif isinstance(child, (ast.With, ast.AsyncWith)):
                    for item in child.items:
                        if item.optional_vars is not None:
                            _add_target(item.optional_vars)
                    _walk_stmt(child)
                elif isinstance(child, ast.NamedExpr):
                    # Statement-level walrus (``(x := …)``); the target leaks.
                    _add_target(child.target)
                    _walk_stmt(child)
                elif isinstance(child, ast.ExceptHandler):
                    if child.name:
                        leaking.add(child.name)
                    _walk_stmt(child)
                elif isinstance(child, (ast.Import, ast.ImportFrom)):
                    for alias in child.names:
                        leaking.add(alias.asname or alias.name.split(".")[0])
                elif isinstance(child, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
                    # The def/class name leaks; its body's local bindings do not.
                    leaking.add(child.name)
                elif isinstance(child, (ast.Lambda, ast.ListComp, ast.SetComp, ast.DictComp, ast.GeneratorExp)):
                    # A comprehension / lambda introduces its own non-leaking
                    # scope: descend for a statement-level walrus (which DOES
                    # leak to the enclosing scope) but never treat its loop vars
                    # or params as bindings.
                    for named in ast.walk(child):
                        if isinstance(named, ast.NamedExpr):
                            _add_target(named.target)
                else:
                    _walk_stmt(child)

        _walk_stmt(tree)
        return leaking

    @staticmethod
    def _collect_bound_names(tree: ast.AST) -> set[str]:
        """Names bound *locally* within an expression or code block.

        A conservative over-approximation (whole-subtree, scope-flattened): any
        such name is treated as defined so a locally-binding construct never
        produces a false undefined_name. Covers comprehension / for-loop targets
        (Store-context ``Name``), assignment and walrus targets, ``with ... as``
        and ``except ... as`` bindings, and lambda / def parameters. Flattening
        scopes only widens the "defined" set, so it can never over-flag; it can
        under-flag a shadowed sibling scope, which is the safe direction.
        """
        bound: set[str] = set()
        for node in ast.walk(tree):
            if isinstance(node, ast.Name) and isinstance(node.ctx, (ast.Store, ast.Del)):
                bound.add(node.id)
            elif isinstance(node, ast.arg):
                bound.add(node.arg)
            elif isinstance(node, ast.ExceptHandler) and node.name:
                bound.add(node.name)
            elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
                bound.add(node.name)
            elif isinstance(node, (ast.Import, ast.ImportFrom)):
                for alias in node.names:
                    bound.add(alias.asname or alias.name.split(".")[0])
        return bound

    @staticmethod
    def _bare_outcome_item(value_node: ast.AST, item_details: dict[str, Any]) -> str | None:
        """Return item X iff ``value_node`` is exactly ``X.outcome`` for a known
        item X (the pass-through-alias RHS shape U3 keys on); else None."""
        name = outcome_ref_name(value_node)
        return name if name in item_details else None

    def _record_undefined_name(
        self, owner_id: str, identifier: str, condition_kind: str
    ) -> None:
        """Record one undefined-name gap under ``owner_id`` and WARN once.

        Deduplicated by ``(identifier, condition_kind)`` so a name referenced
        several times in one predicate/codeBlock yields a single finding. The
        suggestion targets ``q_<identifier>.outcome`` when that item exists — the
        dominant corpus phantom pattern (bare ``smk_status`` → ``q_smk_status``).
        """
        gaps = self.coverage_gaps.setdefault(owner_id, [])
        for existing in gaps:
            if (
                existing.get("kind") == "undefined_name"
                and existing.get("identifier") == identifier
                and existing.get("condition_kind") == condition_kind
            ):
                return
        candidate = f"q_{identifier}"
        suggested = f"{candidate}.outcome" if candidate in self.item_details else None
        gaps.append(
            {
                "kind": "undefined_name",
                "identifier": identifier,
                "condition_kind": condition_kind,
                "suggested_outcome": suggested,
            }
        )
        self.logger.warning(
            "undefined name '%s' referenced in the %s of '%s' — it resolves to no "
            "item id, codeInit/codeBlock variable, or safe builtin. At runtime the "
            "predicate raises and Z3 sees a free symbol, so the logic enforces "
            "nothing.%s",
            identifier,
            condition_kind,
            owner_id,
            f" Did you mean '{suggested}'?" if suggested else "",
        )

    def _record_textarea_in_predicate(
        self, owner_id: str, item_name: str, condition_kind: str
    ) -> None:
        """Record one ``textarea_in_predicate`` gap under ``owner_id`` and WARN once.

        A Textarea item has a string outcome for which no Z3 integer variable is
        created. In a condition a leaf comparing the text with literals lowers
        on its own (``_text_leaf``, #2241): decided where no text satisfies it,
        else free, and the rest of the condition still lowers. Any other read
        of the text (a call, an ordering, a method) does not lower
        (``_ast_to_z3``), so the condition is left out whole; a call there is
        also a ``skipped_condition`` on another item's condition (the build pass
        records no gap for a Textarea's own conditions). What a codeBlock
        computes from the text is unconstrained. Deduplicated by
        ``(item_name, condition_kind)`` so a Textarea outcome referenced several
        times in one location yields a single finding. WARNING, not error — a
        stored file that already does this must still save.
        """
        gaps = self.coverage_gaps.setdefault(owner_id, [])
        for existing in gaps:
            if (
                existing.get("kind") == "textarea_in_predicate"
                and existing.get("item") == item_name
                and existing.get("condition_kind") == condition_kind
            ):
                return
        gaps.append(
            {
                "kind": "textarea_in_predicate",
                "item": item_name,
                "condition_kind": condition_kind,
            }
        )
        self.logger.warning(
            "Textarea outcome '%s.outcome' referenced in the %s of '%s' — a "
            "free-text outcome has no Z3 model, so logic on it is outside the "
            "verified envelope.",
            item_name,
            condition_kind,
            owner_id,
        )

    def _is_textarea_outcome_ref(self, node: ast.AST) -> str | None:
        """The item name X iff ``node`` is ``X.outcome`` for a Textarea-controlled
        item; else None. The shape check reuses ``predicate_ast.outcome_ref_name``; the control
        lookup reads ``item_details`` (populated in pass 1)."""
        name = outcome_ref_name(node)
        return name if name is not None and self._is_textarea(name) else None

    def _is_textarea(self, item_id: str) -> bool:
        """Whether ``item_id`` is a Textarea-controlled item (a string outcome, no Z3 Int)."""
        return self.item_details.get(item_id, {}).get("control") == "Textarea"

    def _census_read(self, name: str) -> None:
        """Count a Load reference to ``name`` if it is a tracked variable."""
        entry = self.variable_census.get(name)
        if entry is not None:
            entry["reads"] += 1

    def _count_census_reads(self, tree: ast.AST) -> None:
        """Count every Load reference to a tracked variable in ``tree``, scoped.

        A Load whose name is bound by an *enclosing* comprehension / generator /
        lambda scope refers to that expression-local, not to a same-named
        module-scope variable, so it does NOT count as a read of a tracked
        variable — that is exactly what let an unrelated ``[… for path in …]``
        mask a genuine write-only ``path`` elsewhere. A Load of the same name
        *outside* that expression (e.g. a real ``x = x + 1`` self-accumulator, or
        a read that follows the comprehension in the same unit) still counts.

        Scope-accurate by construction: the walk carries the set of names shadowed
        by the comprehension/lambda scopes currently enclosing the node, so only
        Loads genuinely bound to an expression-local are skipped.
        """

        def _recurse(node: ast.AST, shadowed: frozenset[str]) -> None:
            # An augmented assignment (``x += 1``) reads its target's prior value,
            # but the target carries a Store ctx so the Load branch below misses
            # it. Count it as a read (unless shadowed) so a self-only accumulator
            # stays off the write-only lint — matching the ``x = x + 1`` form,
            # whose RHS Load is counted normally.
            if isinstance(node, ast.AugAssign):
                tgt = node.target
                if isinstance(tgt, ast.Name) and tgt.id not in shadowed:
                    self._census_read(tgt.id)
            if isinstance(node, (ast.ListComp, ast.SetComp, ast.DictComp, ast.GeneratorExp)):
                inner = set(shadowed)
                for gen in node.generators:
                    for name_node in ast.walk(gen.target):
                        if isinstance(name_node, ast.Name):
                            inner.add(name_node.id)
                child_shadow = frozenset(inner)
                for child in ast.iter_child_nodes(node):
                    _recurse(child, child_shadow)
                return
            if isinstance(node, ast.Lambda):
                inner = set(shadowed)
                for arg in ast.walk(node.args):
                    if isinstance(arg, ast.arg):
                        inner.add(arg.arg)
                child_shadow = frozenset(inner)
                for child in ast.iter_child_nodes(node):
                    _recurse(child, child_shadow)
                return
            if (
                isinstance(node, ast.Name)
                and isinstance(node.ctx, ast.Load)
                and node.id not in shadowed
            ):
                self._census_read(node.id)
            for child in ast.iter_child_nodes(node):
                _recurse(child, shadowed)

        _recurse(tree, frozenset())

    def _census_iterate_over(self, expr: str) -> None:
        """Count variable reads inside a Roster ``iterateOver`` expression.

        Census-only: undefined-name detection deliberately does NOT run here —
        adding it would change U1's shipped undefined-name behavior, and an
        ``iterateOver`` phantom already surfaces through the Pass-3 dependency
        walk and the FlowProcessor runtime roster channel. This exists purely so
        a variable consumed only by a Roster (``family_mask`` → ``iterateOver``)
        is not mis-flagged write-only by the U3 hygiene lint.
        """
        tree = self._parsed(expr, "eval")
        if tree is None:
            return
        for node in ast.walk(tree):
            if isinstance(node, ast.Name) and isinstance(node.ctx, ast.Load):
                self._census_read(node.id)

    def _scan_predicate(
        self, predicate: str, owner_id: str, condition_kind: str, known: set[str]
    ) -> None:
        """Walk one precondition/postcondition string: flag undefined Load names
        (attributed to ``owner_id``) and count variable reads for the census."""
        tree = self._parsed(predicate, "eval")
        if tree is None:
            # Unparseable predicate — the runtime warning channel and the R13
            # coverage-gap path already surface it; nothing to lint here.
            return
        bound = self._collect_bound_names(tree)
        # Census reads: scope-aware, so a comprehension/lambda-local Load is not
        # counted as a read of a same-named tracked variable.
        self._count_census_reads(tree)
        # A None test reads answeredness, which is modelled (#1250), not the text.
        none_tested = {id(operand) for operand in none_test_operands(tree)}
        for node in ast.walk(tree):
            # A Textarea outcome reference has no verified Z3 model — flag it
            # (WARNING) regardless of the Name-Load census/undefined-name path.
            textarea = self._is_textarea_outcome_ref(node)
            if textarea is not None and id(node) not in none_tested:
                self._record_textarea_in_predicate(owner_id, textarea, condition_kind)
            if not (isinstance(node, ast.Name) and isinstance(node.ctx, ast.Load)):
                continue
            name = node.id
            # ``bound`` (scope-flattened, per-unit) masks only the undefined-name
            # check: a comprehension local read here is legitimately defined.
            if name in bound:
                continue
            if name not in known:
                self._record_undefined_name(owner_id, name, condition_kind)

    def _scan_code(self, code: str, item_id: str | None, known: set[str]) -> None:
        """Walk one codeInit / codeBlock string: record variable assignments
        (with context + bare-outcome shape) and reads for the census, and flag
        undefined Load names for an item's codeBlock.

        ``item_id`` is ``None`` for codeInit (census only — codeInit has no item
        to attribute an undefined_name to and runs before any item); otherwise it
        is both the assignment context label and the undefined-name owner.
        """
        tree = self._parsed(code, "exec")
        if tree is None:
            return
        context = item_id if item_id is not None else "codeInit"
        bound = self._collect_bound_names(tree)

        # Assignments: one census record per tracked target. Plain ``x = …``
        # carries the bare-outcome shape (for the pass-through-alias lint); every
        # other producing form (augmented assign, tuple/list unpack, for-target,
        # ``with ... as``, walrus) records a non-bare assignment so the variable
        # is seen as *produced*. Missing the non-Name forms is what let a real
        # second producer look like a single-assignment alias, and a
        # non-Name-only producer escape the write-only lint entirely.
        self._record_census_assignments(tree, context)

        # Reads (scope-aware): a comprehension/lambda-local Load is not a read of
        # a same-named tracked variable.
        self._count_census_reads(tree)

        # Undefined names (Load context). ``bound`` (scope-flattened, per-unit)
        # masks locally-bound names so a comprehension local is not mis-flagged.
        for node in ast.walk(tree):
            # A codeBlock read of a Textarea outcome is flagged (WARNING); as with
            # undefined_name, only real codeBlocks own a finding, not codeInit.
            if item_id is not None:
                textarea = self._is_textarea_outcome_ref(node)
                if textarea is not None:
                    self._record_textarea_in_predicate(item_id, textarea, "codeBlock")
            if not (isinstance(node, ast.Name) and isinstance(node.ctx, ast.Load)):
                continue
            name = node.id
            if name in bound:
                continue
            if item_id is not None and name not in known:
                self._record_undefined_name(item_id, name, "codeBlock")

    def _record_census_assignments(self, tree: ast.AST, context: str) -> None:
        """Record one census assignment per tracked target bound in ``tree``.

        Covers every producing form so the census sees a variable as *produced*
        regardless of how it is bound: a plain ``x = <X.outcome>`` records the
        bare-outcome item (the only pass-through-alias candidate); augmented
        assignment, tuple/list unpacking, ``for`` targets, ``with ... as``, and
        statement-level walrus all record a non-bare (``bare_outcome_item=None``)
        assignment. A ``for``/aug-assign target that also reads its prior value is
        counted as a read via ``_count_census_reads`` over the same tree, so a
        self-accumulator stays off the write-only lint.

        Comprehension / generator / lambda loop-locals are deliberately NOT
        recorded — they never leak, so they are neither a producer nor a reader
        of a same-named tracked variable.
        """

        def _record_target(target: ast.AST, bare_outcome_item: str | None) -> None:
            if isinstance(target, ast.Name):
                if target.id in self.variable_census:
                    self.variable_census[target.id]["assignments"].append(
                        {"context": context, "bare_outcome_item": bare_outcome_item}
                    )
            elif isinstance(target, (ast.Tuple, ast.List)):
                # Unpacking splits one RHS across targets — no single target is a
                # bare ``X.outcome`` alias.
                for elt in target.elts:
                    _record_target(elt, None)
            elif isinstance(target, ast.Starred):
                _record_target(target.value, None)

        def _walk(node: ast.AST) -> None:
            for child in ast.iter_child_nodes(node):
                if isinstance(child, ast.Assign):
                    bare = self._bare_outcome_item(child.value, self.item_details)
                    for tgt in child.targets:
                        _record_target(tgt, bare)
                    _walk(child)
                elif isinstance(child, (ast.AugAssign, ast.AnnAssign)):
                    if child.target is not None:
                        _record_target(child.target, None)
                    _walk(child)
                elif isinstance(child, (ast.For, ast.AsyncFor)):
                    _record_target(child.target, None)
                    _walk(child)
                elif isinstance(child, (ast.With, ast.AsyncWith)):
                    for item in child.items:
                        if item.optional_vars is not None:
                            _record_target(item.optional_vars, None)
                    _walk(child)
                elif isinstance(child, ast.NamedExpr):
                    _record_target(child.target, None)
                    _walk(child)
                elif isinstance(child, (ast.Lambda, ast.ListComp, ast.SetComp, ast.DictComp, ast.GeneratorExp)):
                    # Non-leaking scope: only a statement-level walrus inside it
                    # produces a leaking binding.
                    for named in ast.walk(child):
                        if isinstance(named, ast.NamedExpr):
                            _record_target(named.target, None)
                else:
                    _walk(child)

        _walk(tree)

    def _detect_undefined_names_and_census(self) -> None:
        """Pass 5 (U1): populate ``variable_census`` and record undefined-name
        coverage gaps across every stored predicate and code block.

        Purely additive — no constraint, dependency edge, or classification is
        touched. Definedness is file-scoped: the known-name set is fixed once
        (after full SSA) and applied uniformly, so a predicate that reads a
        variable a later codeBlock produces is not flagged.
        """
        known = self._known_name_set()
        # Census keys are every assigned variable; seed them all so a write-only
        # variable (0 reads) still has an entry. ``version_history`` covers plain
        # ``ast.Name`` assignment targets (all SSA models); union in the leaking
        # code-bound names so a variable produced ONLY via tuple-unpack / for /
        # walrus / with-as (which SSA never records) is still censused — else a
        # non-Name-only unread producer escapes the write-only lint entirely.
        #
        # Seeded in a stable order, because the hygiene lints iterate this dict
        # and a set's order follows ``PYTHONHASHSEED`` (#1138): SSA names in the
        # order the builder met them (file order), then the non-SSA bound names
        # by name.
        ssa_names = list(self.version_history)
        other_bound = sorted(self._all_bound_code_names() - set(ssa_names))
        self.variable_census = {
            var: {"assignments": [], "reads": 0} for var in [*ssa_names, *other_bound]
        }

        # codeInit is a code unit for the census (assignments + reads) but has no
        # item to own an undefined_name, so pass item_id=None.
        init_code = self.state.get_code_init()
        if init_code:
            self._scan_code(init_code, None, known)

        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue
            for cond in item.get("precondition", []) or []:
                predicate = cond.get("predicate", "")
                if predicate:
                    self._scan_predicate(predicate, item_id, "precondition", known)
            for cond in item.get("postcondition", []) or []:
                predicate = cond.get("predicate", "")
                if predicate:
                    self._scan_predicate(predicate, item_id, "postcondition", known)
            code_block = item.get("codeBlock")
            if code_block:
                self._scan_code(code_block, item_id, known)

        # Roster ``iterateOver`` expressions read a variable / item outcome that
        # the roster consumes — a genuine read the predicate/codeBlock scans above
        # miss. Count those reads (once per Roster block) so a variable that
        # exists only to drive a Roster is not mis-classified write-only by U3.
        # Census-only: this deliberately does NOT run undefined-name detection
        # (see _census_iterate_over) so U1's shipped behavior is unchanged.
        seen_roster_blocks: set[str] = set()
        for item in self.state.get_all_items():
            block_id = item.get("_roster_block_id")
            iterate_over = item.get("_roster_iterate_over")
            if block_id and iterate_over and block_id not in seen_roster_blocks:
                seen_roster_blocks.add(block_id)
                self._census_iterate_over(iterate_over)

        # Block-level conditions (kept on the block per R25, not copied onto
        # items): attribute findings to the block_id, mirroring the block-keyed
        # group_dependency gap so classify_all_items surfaces them as a synthetic
        # block entry.
        for block in self.state.get_blocks():
            block_id = block.get("id")
            if not block_id:
                continue
            for cond in block.get("precondition", []) or []:
                predicate = cond.get("predicate", "")
                if predicate:
                    self._scan_predicate(predicate, block_id, "precondition", known)
            for cond in block.get("postcondition", []) or []:
                predicate = cond.get("predicate", "")
                if predicate:
                    self._scan_predicate(predicate, block_id, "postcondition", known)

    def get_variable_census(self) -> dict[str, dict[str, Any]]:
        """Return the per-variable read/write census (U3 hygiene lints).

        See ``self.variable_census`` for the shape. Read-only view intent: the
        returned dict is the live structure — callers must not mutate it.
        """
        return self.variable_census

    # ------------------------------------------------------------------
    # U3: postcondition coverage analysis (relational vs local) + the
    # duplicate-input-bound hygiene signal. Pure read-only analysis over
    # stored postcondition ASTs — it records nothing and mutates no state;
    # the issue/severity policy and the statistics keys live in
    # ``ValidationProcessor`` (the single home of that policy), which consumes
    # these records alongside ``get_variable_census``.
    # ------------------------------------------------------------------

    def analyze_postconditions(self) -> list[dict[str, Any]]:
        """Classify every item-level postcondition for R12 coverage stats and the
        duplicate-input-bound lint.

        One record per (item, postcondition predicate)::

            {"item_id": str, "condition_idx": int, "predicate": str,
             "relational": bool,             # deps include another item's
                                             # outcome OR any variable (else LOCAL)
             "duplicate_input_bound": bool}  # restates the item's own control
                                             # min/max exactly, references nothing
                                             # else

        Block-level postconditions are intentionally excluded: they have no
        single owning item to test "own outcome" against, and the coverage metric
        (relational cross-question constraints) is an item-level notion.
        """
        records: list[dict[str, Any]] = []
        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue
            input_spec = item.get("input", {}) or {}
            control = input_spec.get("control", "")
            # Range is not here: its answer is a pair (#1474), so a scalar
            # restatement of its bounds (`own.outcome >= min`) is no
            # restatement at all. GATEABLE_CONTROLS still keeps Range.
            numeric = control in ("Editbox", "Slider")
            lo = input_spec.get("min")
            hi = input_spec.get("max")
            for idx, cond in enumerate(item.get("postcondition", []) or []):
                predicate = cond.get("predicate", "")
                if not predicate:
                    continue
                tree = self._parsed(predicate, "eval")
                if tree is None:
                    continue
                deps = self._extract_dependencies_from_ast(tree.body)
                # Relational iff any dependency is a variable (``var:`` node) or
                # a DIFFERENT item's outcome. A postcondition that references only
                # its own outcome (or nothing) is local.
                relational = any(d.startswith("var:") or d != item_id for d in deps)
                duplicate = (
                    numeric
                    and not relational
                    and self._restates_input_bounds(tree.body, item_id, lo, hi)
                )
                records.append(
                    {
                        "item_id": item_id,
                        "condition_idx": idx,
                        "predicate": predicate,
                        "relational": relational,
                        "duplicate_input_bound": duplicate,
                    }
                )
        return records

    @staticmethod
    def _is_own_outcome(node: ast.AST, item_id: str) -> bool:
        """True iff ``node`` is exactly ``<item_id>.outcome``."""
        return outcome_ref_name(node) == item_id

    @staticmethod
    def _literal_int(node: ast.AST) -> int | None:
        """Resolve ``node`` to a Python int literal (optionally unary-signed).

        Conservative on purpose: floats and any non-literal (a name, a BinOp)
        return ``None`` so the duplicate-input-bound check only ever fires on an
        exact integer restatement of an integer control bound.
        """
        if (
            isinstance(node, ast.Constant)
            and isinstance(node.value, int)
            and not isinstance(node.value, bool)
        ):
            return node.value
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.USub, ast.UAdd)):
            inner = StaticBuilder._literal_int(node.operand)
            if inner is None:
                return None
            return -inner if isinstance(node.op, ast.USub) else inner
        return None

    @staticmethod
    def _flatten_and_comparisons(node: ast.AST) -> list[ast.Compare] | None:
        """Flatten an ``And`` tree of ``Compare`` nodes into a flat list.

        Returns ``None`` if any leaf is not a ``Compare`` — an ``Or`` / ``Not`` /
        call / bare name means the predicate is doing more than restating bounds,
        so it is not a duplicate-input-bound candidate.
        """
        if isinstance(node, ast.Compare):
            return [node]
        if isinstance(node, ast.BoolOp) and isinstance(node.op, ast.And):
            out: list[ast.Compare] = []
            for value in node.values:
                sub = StaticBuilder._flatten_and_comparisons(value)
                if sub is None:
                    return None
                out.extend(sub)
            return out
        return None

    def _bound_kind(
        self,
        left: ast.AST,
        op: ast.cmpop,
        right: ast.AST,
        item_id: str,
        lo: Any,
        hi: Any,
    ) -> str | None:
        """Classify one binary comparison as restating ``"min"`` / ``"max"``, else
        ``None``.

        Exact-constant, own-outcome only: ``own.outcome >= lo`` (or ``lo <=
        own.outcome``) restates the min; ``own.outcome <= hi`` (or ``hi >=
        own.outcome``) restates the max. Any tighter constant, a different
        operator (``>``, ``==``), or a non-own-outcome operand returns ``None``,
        which disqualifies the whole predicate.
        """
        if self._is_own_outcome(left, item_id):
            const = self._literal_int(right)
            if const is None:
                return None
            if isinstance(op, ast.GtE) and lo is not None and const == lo:
                return "min"
            if isinstance(op, ast.LtE) and hi is not None and const == hi:
                return "max"
            return None
        if self._is_own_outcome(right, item_id):
            const = self._literal_int(left)
            if const is None:
                return None
            if isinstance(op, ast.LtE) and lo is not None and const == lo:
                return "min"
            if isinstance(op, ast.GtE) and hi is not None and const == hi:
                return "max"
            return None
        return None

    def _restates_input_bounds(
        self, node: ast.AST, item_id: str, lo: Any, hi: Any
    ) -> bool:
        """True iff every comparison in ``node`` restates the item's own control
        min/max exactly and at least one bound is restated.

        Handles a single (possibly chained) ``Compare`` and ``And`` conjunctions
        of them; a single disqualifying comparison fails the whole predicate.
        """
        comparisons = self._flatten_and_comparisons(node)
        if not comparisons:
            return False
        restated_min = False
        restated_max = False
        for cmp_node in comparisons:
            operands = [cmp_node.left, *cmp_node.comparators]
            for i, op in enumerate(cmp_node.ops):
                kind = self._bound_kind(
                    operands[i], op, operands[i + 1], item_id, lo, hi
                )
                if kind is None:
                    return False
                if kind == "min":
                    restated_min = True
                else:
                    restated_max = True
        return restated_min or restated_max

    def _build_condition_constraint(
        self, kind: ConditionKind, predicate: str, item_id: str, condition_idx: int = 0
    ) -> tuple[BoolRef | None, set[str]]:
        """Build a Z3 constraint for one pre/postcondition AND track dependencies.

        ``kind`` is ``"precondition"`` or ``"postcondition"``: it labels the
        coverage gap (R7/R13) and the error log, and it decides how a read that
        raises on a skipped item lowers (``_lower_predicate``, #1775); the
        parse → extract deps → wire dependency graph → lower-to-Z3 →
        record-gap-on-None body is otherwise identical for both. Self-references are excluded from the
        dependency graph for both kinds: a precondition self-loop is invalid,
        and a postcondition validating its own item's outcome (``q1.outcome > 0``)
        is legitimate and not a dependency.

        Returns ``(constraint_or_None, item_dependencies)``; ``var:`` nodes are
        stripped from the returned dep set for backward compatibility.
        """
        _require_condition_kind(kind)
        tree = self._parsed(predicate, "eval")
        if tree is None:
            # ``unsafe_code`` reports a predicate that does not parse.
            return None, set()
        try:
            # Extract ALL dependencies (items AND variables)
            all_deps = self._extract_dependencies_from_ast(tree.body)

            # Add to dependency graph (excluding self-references)
            for dep in all_deps:
                if dep != item_id:  # Exclude self-reference
                    self.dependency_graph[item_id].add(dep)

            # Drop refusals a re-lowering outside the build left behind.
            self._distinct_refusals.pop(item_id, None)
            self._ternary_refusals.pop(item_id, None)
            constraint, _ = self._lower_predicate(tree.body, item_id, kind)
            skippable_items = self._distinct_refusals.pop(item_id, [])
            ternary_items = self._ternary_refusals.pop(item_id, [])

            # R7/R13: surface silent drops on constraint-bearing predicates.
            # A Range read the model cannot represent is a gap even when it
            # carries no Subscript / Call node (a bare ``q.outcome >= 3``).
            if constraint is None:
                unsupported = self._unsupported_node_kinds(tree.body)
                range_items = self._unlowered_range_reads(tree.body)
                group_items = self._unlowered_group_reads(tree.body)
                matrix_items = self._unlowered_matrix_reads(tree.body)
                if unsupported or range_items or group_items or matrix_items or skippable_items or ternary_items:
                    self._record_coverage_gap(
                        item_id,
                        kind,
                        condition_idx,
                        unsupported,
                        range_items,
                        group_items,
                        matrix_items,
                        skippable_items,
                        ternary_items=ternary_items,
                    )

            # Return only item dependencies for backward compatibility
            item_deps = {d for d in all_deps if not d.startswith("var:")}
            return constraint, item_deps
        except Exception as e:
            self.logger.error(f"Error building {kind} constraint for {item_id}: {type(e).__name__}")
            # A fault in the lowering is a skipped condition, never a silent
            # one, unless ``unsafe_code`` already reports the predicate.
            if not self._reported_unsafe(predicate):
                self._record_coverage_gap(item_id, kind, condition_idx, ["Error"])
            return None, set()

    def _build_precondition_constraint(
        self, predicate: str, item_id: str, condition_idx: int = 0
    ) -> tuple[BoolRef | None, set[str]]:
        """Build a Z3 precondition constraint (thin wrapper over
        ``_build_condition_constraint``)."""
        return self._build_condition_constraint("precondition", predicate, item_id, condition_idx)

    def _build_postcondition_constraint(
        self, predicate: str, item_id: str, condition_idx: int = 0
    ) -> tuple[BoolRef | None, set[str]]:
        """Build a Z3 postcondition constraint (thin wrapper over
        ``_build_condition_constraint``)."""
        return self._build_condition_constraint("postcondition", predicate, item_id, condition_idx)

    # ------------------------------------------------------------------
    # Helpers for matrix postcondition lowering
    # ------------------------------------------------------------------

    def _resolve_int_const(self, node: ast.AST, local_bindings: dict[str, int]) -> int | None:
        """Resolve an AST node to a Python int at build time.

        Accepts integer literals, names bound via ``local_bindings``, and the
        compile-time-known forms ``len(<item>.rows)`` / ``len(<item>.columns)``
        where ``<item>`` is a MatrixQuestion and ``len(<item>.questions)`` where
        it is a QuestionGroup in the questionnaire. Anything
        else (BinOp, arbitrary calls, runtime variables) returns ``None``.
        """
        if (
            isinstance(node, ast.Constant)
            and isinstance(node.value, int)
            and not isinstance(node.value, bool)
        ):
            return node.value
        if isinstance(node, ast.Name) and node.id in local_bindings:
            return local_bindings[node.id]
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.USub, ast.UAdd)):
            inner = self._resolve_int_const(node.operand, local_bindings)
            if inner is None:
                return None
            return -inner if isinstance(node.op, ast.USub) else inner
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id == "len":
            # len(<matrix>.rows) / len(<matrix>.columns) / len(<group>.questions)
            # only: the declared lists ItemProxy exposes at runtime (#1782).
            if len(node.args) != 1:
                return None
            arg = node.args[0]
            if (
                isinstance(arg, ast.Attribute)
                and isinstance(arg.value, ast.Name)
                and arg.attr in _DECLARED_LIST_LENGTHS
            ):
                item_id = arg.value.id
                if item_id in self.item_details:
                    val = self.item_details[item_id].get(_DECLARED_LIST_LENGTHS[arg.attr])
                    if isinstance(val, int):
                        return val
        return None

    def _resolve_range_call(
        self, call_node: ast.AST, local_bindings: dict[str, int]
    ) -> range | None:
        """Resolve a ``range(...)`` call to a Python ``range`` object at build time.

        Bounds policy: no upper cap, ``len(<item>.rows|columns)`` accepted.

        Returns ``None`` if the call shape is unsupported (e.g., 3-arg range
        with non-trivial step, non-resolvable bounds, BinOp on the start arg).
        """
        if not (
            isinstance(call_node, ast.Call)
            and isinstance(call_node.func, ast.Name)
            and call_node.func.id == "range"
        ):
            return None
        args = call_node.args
        if len(args) == 1:
            stop = self._resolve_int_const(args[0], local_bindings)
            if stop is None or stop < 0:
                return None
            return range(stop)
        if len(args) == 2:
            start = self._resolve_int_const(args[0], local_bindings)
            stop = self._resolve_int_const(args[1], local_bindings)
            if start is None or stop is None:
                return None
            return range(start, stop)
        return None

    def _lower_subscript(
        self, node: ast.Subscript, context: str, local_bindings: dict[str, int]
    ) -> ExprRef | None:
        """Lower a subscripted outcome read to the variable it names.

        - ``X.outcome[j][k]`` on a non-Range matrix → ``item_cells[X][(j, k)]``;
          ``j`` / ``k`` may be literals or comprehension loop variables.

        - ``qg.outcome[i]`` on a non-Range QuestionGroup → ``item_cells[qg][(i,)]``
          (#184), in a predicate only (``_group_cells``).

        A Range item never lowers here (#1755): its ends are named, so a Range
        read lowers through ``_lower_range_end`` from ``X.outcome.low``,
        ``X.outcome[j][k].low`` or ``qg.outcome[i].low``, and a positional read
        (``q.outcome[0]``) is a coverage gap like any other Range read the
        model does not hold. One-index reads of a matrix (a row slice only
        lowers inside a fold, via ``_unroll_list_arg``), two-index reads of a
        group, a scalar item and a Python variable return ``None`` too.
        """
        item_id, indices = self._outcome_subscript(node)
        if item_id is None or self._is_range_item(item_id):
            return None
        if self._is_question_group(item_id):
            cells = self._group_cells(item_id)
            if cells is None or len(indices) != 1:
                return None
            i = self._resolve_int_const(indices[0], local_bindings)
            return None if i is None else cells.get((i,))
        cells = self.item_cells.get(item_id)
        if cells is None or len(indices) != 2:
            return None
        j = self._resolve_int_const(indices[0], local_bindings)
        k = self._resolve_int_const(indices[1], local_bindings)
        if j is None or k is None:
            return None
        return cells.get((j, k))

    def _is_question_group(self, item_id: str) -> bool:
        return item_id in self.question_groups

    def _group_cells(self, item_id: str) -> dict[tuple[int, ...], ExprRef] | None:
        """A QuestionGroup's answer cells, where a read of them may lower: in
        a predicate (``_lower_predicate``) and outside a Roster or capped
        Group. A codeBlock read stays unlowered: a sum over an unanswered
        slot raises and leaves its variable as it was, and the codeBlock None
        model (``_CodeReads``, #1776) covers scalar Question reads only. A scoped
        group has no cells per iteration or draw, so one canonical cell would
        tie answers the runtime keeps apart, and a group a codeBlock writes can
        hold any value between two conditions, which one cell per answer
        cannot (``_unlowered_group_reads``)."""
        if not self._lowering_predicate or self._is_scoped(item_id) or item_id in self._code_written_items():
            return None
        return self.item_cells.get(item_id)

    def _is_scoped(self, item_id: str) -> bool:
        item = self.state.get_item(item_id)
        return bool(item and (item.get("_roster_block_id") or item.get("_group_block_id")))

    def _answer_read(self, node: ast.AST) -> tuple[str, list[ast.expr]] | None:
        """``(item, index nodes)`` iff ``node`` is one answer read of an
        answer list: ``qg.outcome[i]`` of a QuestionGroup or ``m.outcome[r][c]``
        of a MatrixQuestion, or its ``.low`` / ``.high`` on a Range item (the
        whole read node, so a raise walks from it)."""
        if isinstance(node, ast.Attribute) and node.attr in _RANGE_ENDS:
            inner = node.value
            if not isinstance(inner, ast.Subscript):
                return None
            item_id, indices = self._outcome_subscript(inner)
            ok = item_id is not None and self._is_range_item(item_id)
        elif isinstance(node, ast.Subscript):
            item_id, indices = self._outcome_subscript(node)
            ok = item_id is not None and not self._is_range_item(item_id)
        else:
            return None
        if not ok:
            return None
        if self._is_question_group(item_id):
            return (item_id, indices) if len(indices) == 1 else None
        if item_id in self.matrices:
            return (item_id, indices) if len(indices) == 2 else None
        return None

    @staticmethod
    def _outcome_subscript(node: ast.Subscript) -> tuple[str | None, list[ast.expr]]:
        """``(X, [i, j, ...])`` for ``X.outcome[i][j]...``; ``(None, [])`` otherwise."""
        indices: list[ast.expr] = []
        base: ast.expr = node
        while isinstance(base, ast.Subscript):
            indices.append(base.slice)
            base = base.value
        indices.reverse()
        item_id = outcome_ref_name(base)
        return (item_id, indices) if item_id is not None else (None, [])

    def _lower_range_end(self, node: ast.Attribute) -> ExprRef | None:
        """Lower a named Range end to its variable (#1755, D89).

        - ``X.outcome.low`` / ``.high`` on a Range Question → ``item_pairs[X]``'s
          end (the current Roster iteration's or capped-Group presence's pair
          while those are emitted, since they swap ``item_pairs``).
        - ``m.outcome[j][k].low`` / ``.high`` on a Range matrix →
          ``item_cells[m][(j, k, end)]``, with literal ``j`` / ``k`` only: a fold
          over Range cells is not modelled and stays a coverage gap.
        - ``qg.outcome[i].low`` / ``.high`` on a Range QuestionGroup →
          ``item_cells[qg][(i, end)]`` (#184), with a literal ``i``, in a
          predicate only (``_group_cells``).

        Anything else (a non-Range item, another attribute) returns ``None``.
        """
        if node.attr not in _RANGE_ENDS:
            return None
        end = _RANGE_ENDS.index(node.attr)
        item_id = outcome_ref_name(node.value)
        if item_id is not None:
            pair = self.item_pairs.get(item_id)
            return pair[end] if pair is not None else None
        if not isinstance(node.value, ast.Subscript):
            return None
        item_id, indices = self._outcome_subscript(node.value)
        if item_id is None or not self._is_range_item(item_id):
            return None
        if self._is_question_group(item_id):
            cells = self._group_cells(item_id)
            i = self._resolve_int_const(indices[0], {}) if len(indices) == 1 else None
            return None if cells is None or i is None else cells.get((i, end))
        if len(indices) != 2:
            return None
        cells = self.item_cells.get(item_id)
        if cells is None:
            return None
        j = self._resolve_int_const(indices[0], {})
        k = self._resolve_int_const(indices[1], {})
        return None if j is None or k is None else cells.get((j, k, end))

    def _unlowered_range_reads(self, tree: ast.AST) -> list[str]:
        """Range items the tree reads in a form the model does not represent.

        A Range outcome lowers only as ``X.outcome.low|high`` (Range Question)
        or ``X.outcome[j][k].low|high`` (Range matrix) with constant indices
        (#1755). Every other read of a Range item's outcome — bare ``X.outcome``
        compared as a number, a positional ``X.outcome[0]``, any Range
        QuestionGroup read, a whole Range cell, a fold over Range cells — has no
        variable to lower to. Naming those items lets a dropped condition's
        coverage gap say it was the Range read (R7, #1474), including a bare
        read, which carries no Subscript / Call node.
        """
        parents = self._build_parent_map(tree)
        found: list[str] = []
        # Asked about a condition, so a Range QuestionGroup end of the
        # lowerable shape is not named (``_group_cells``).
        outer, self._lowering_predicate = self._lowering_predicate, True
        try:
            for node in ast.walk(tree):
                item_id = outcome_ref_name(node)
                if item_id is None or not self._is_range_item(item_id) or item_id in found:
                    continue
                top, _ = self._subscript_top(node, parents)
                end = parents.get(top)
                lowered = (
                    isinstance(end, ast.Attribute)
                    and end.value is top
                    and self._lower_range_end(end) is not None
                )
                if not lowered:
                    found.append(item_id)
        finally:
            self._lowering_predicate = outer
        return found

    def _unlowered_group_reads(self, tree: ast.AST) -> list[str]:
        """QuestionGroups a condition reads in a form the model does not hold
        (#184): the whole list as a value (``qg.outcome == 1``; a None test is
        modelled), a set of answers (an unanswered slot is a ``None`` member),
        an answer passed through a ternary branch, any read of a group inside a
        Roster or capped Group or written by a codeBlock, and a read with other
        than one index. A bare read carries no Subscript or Call node, so
        without this name the dropped condition would record no gap at all."""
        found: list[str] = []
        if not self.question_groups:
            return found
        parents = self._build_parent_map(tree)
        none_operands = {id(operand) for operand in none_test_operands(tree)}
        for node in ast.walk(tree):
            item_id = outcome_ref_name(node)
            if item_id is None or not self._is_question_group(item_id) or item_id in found:
                continue
            top, depth = self._subscript_top(node, parents)
            in_set = self._in_set(top, parents)
            bare = depth == 0 and id(node) not in none_operands
            through_ternary = depth == 1 and self._slot_through_ternary(top, parents)
            if (
                self._is_scoped(item_id)
                or item_id in self._code_written_items()
                or in_set
                or bare
                or depth > 1
                or (through_ternary and not self._is_range_item(item_id))
            ):
                found.append(item_id)
        return found

    def _unlowered_matrix_reads(self, tree: ast.AST) -> list[str]:
        """MatrixQuestions a condition reads other than one cell at a time
        (#1781): the whole answer as a value (``m.outcome == 1``,
        ``if m.outcome:``; a None test is not a value read) and a whole row
        (``m.outcome[0] == 1``, ``set(m.outcome[0])``). The model holds a
        matrix as one variable per cell and nothing for the list or a row, and
        a bare read carries no Subscript or Call node, so without this name the
        dropped condition would record no gap at all. Where a cell may be
        ``None`` (``_matrix_has_choices``), a cell read through a ternary
        branch or into a set is named too: ``None`` flows on untouched, and a
        set counts it as a member (``_answer_list_reads``,
        ``_try_distinct_pattern``). A Range matrix is named by
        ``_unlowered_range_reads`` instead."""
        found: list[str] = []
        if not self.matrices:
            return found
        parents = self._build_parent_map(tree)
        none_operands = {id(operand) for operand in none_test_operands(tree)}
        for node in ast.walk(tree):
            item_id = outcome_ref_name(node)
            if (
                item_id is None
                or item_id in found
                or item_id not in self.matrices
                or self._is_range_item(item_id)
            ):
                continue
            top, depth = self._subscript_top(node, parents)
            nullable_cell = (
                depth == 2
                and self._matrix_has_choices(item_id)
                and (self._slot_through_ternary(top, parents) or self._in_set(top, parents))
            )
            if nullable_cell or (depth != 2 and not (depth == 0 and id(node) in none_operands)):
                found.append(item_id)
        return found

    @staticmethod
    def _subscript_top(node: ast.AST, parents: dict[ast.AST, ast.AST]) -> tuple[ast.AST, int]:
        """``(the outermost Subscript over node, how many indices it takes)``:
        ``(m.outcome[0][1], 2)`` for the ``m.outcome`` inside it."""
        top, depth = node, 0
        while isinstance(parents.get(top), ast.Subscript) and parents[top].value is top:
            top, depth = parents[top], depth + 1
        return top, depth

    @classmethod
    def _in_set(cls, node: ast.AST, parents: dict[ast.AST, ast.AST]) -> bool:
        """Whether ``node`` is (inside) an argument of ``set(...)``."""
        return any(
            isinstance(holder, ast.Call) and _is_call_to(holder, ("set",))
            for holder in cls._ancestors(node, parents)
        )

    @staticmethod
    def _ancestors(node: ast.AST, parents: dict[ast.AST, ast.AST]) -> list[ast.AST]:
        chain: list[ast.AST] = []
        while (node := parents.get(node)) is not None:
            chain.append(node)
        return chain

    def _try_distinct_pattern(
        self, node: ast.Compare, context: str, local_bindings: dict[str, int]
    ) -> BoolRef | None:
        """Pattern: ``len(set(<list-like>)) == <int>`` → ``Distinct(*xs)``.

        Recognized shapes (LHS first, then comparator op + Constant):
            len(set([...])) == k
            len({...}) == k                       (set literal — unimplemented)

        Only the equality form is recognized; ``!=``, ``>=``, etc., fall
        through. The integer ``k`` must equal ``len(xs)`` after unrolling
        (Distinct only has Python-set semantics for the "all distinct" case).
        """
        if len(node.ops) != 1 or not isinstance(node.ops[0], ast.Eq):
            return None
        if len(node.comparators) != 1:
            return None
        lhs = node.left
        rhs = node.comparators[0]

        # LHS must be: len(set(<arg>))  with one positional arg
        if not (
            isinstance(lhs, ast.Call)
            and isinstance(lhs.func, ast.Name)
            and lhs.func.id == "len"
            and len(lhs.args) == 1
        ):
            return None
        inner = lhs.args[0]
        if not (
            isinstance(inner, ast.Call)
            and isinstance(inner.func, ast.Name)
            and inner.func.id == "set"
            and len(inner.args) == 1
        ):
            return None
        list_arg = inner.args[0]
        if any(
            (found := self._answer_read(n)) is not None
            and (
                self._is_question_group(found[0])
                or (found[0] in self.matrices and self._matrix_has_choices(found[0]))
            )
            for n in ast.walk(list_arg)
        ):
            # An unanswered slot or empty cell is a ``None`` member of the set,
            # not a raise, and ``Distinct`` over the answers cannot hold it
            # (#184, #1780); the gap names the item (``_unlowered_group_reads``,
            # ``_unlowered_matrix_reads``).
            return None
        # RHS must be a constant int we can resolve at build time.
        k = self._resolve_int_const(rhs, local_bindings)
        if k is None:
            return None

        xs = self._unroll_list_arg(list_arg, context, local_bindings, bool_elements=False)
        if xs is None:
            return None
        if len(xs) != k:
            # ``len(set([a, b, c])) == 2`` is satisfiable but is not "all
            # distinct" — Z3's Distinct doesn't model "exactly N distinct
            # values out of M". Refuse the translation; caller logs WARNING.
            return None
        skippable = list(
            dict.fromkeys(
                read
                for n in ast.walk(list_arg)
                if (read := outcome_ref_name(n)) is not None and self._may_be_skipped(read, context)
            )
        )
        if skippable:
            # A skipped Question is a ``None`` member of the set too (#1785):
            # ``[None, 1, 2, 3]`` has four distinct members over three labels.
            # Recorded so the gap names them (#1799), only after the shape
            # checks above and only when every one takes a None guard that
            # lowers (``_answerable``: not a Roster / capped-Group member), so
            # the suggested guard does prove this check.
            if all(self._answerable(read) for read in skippable):
                named = self._distinct_refusals.setdefault(context, [])
                named.extend(read for read in skippable if read not in named)
            return None
        if len(xs) <= 1:
            return BoolVal(True, self.ctx)
        return Distinct(*xs)

    def _lower_call_value(
        self, node: ast.Call, context: str, local_bindings: dict[str, int]
    ) -> ExprRef | None:
        """Value-context calls: ``sum(xs)``, ``int(x)``, ``bool(x)``, ``abs(x)``.

        ``len(...)`` is intentionally NOT lowered here — its only meaningful
        shape inside a Z3 expression is part of the ``len(set(...)) == k``
        Distinct pattern, which is matched at the Compare-node level. None
        lowers over a value that may hold a string (``_carries_string``):
        ``int("a")`` raises and ``sum`` of strings too.
        """
        if not isinstance(node.func, ast.Name):
            return None
        if self._string_refusal(node, local_bindings):
            return None
        fname = node.func.id

        if fname == "sum" and len(node.args) == 1:
            xs = self._unroll_list_arg(node.args[0], context, local_bindings, bool_elements=False)
            if xs is None:
                return None
            if not xs:
                return IntVal(0, self.ctx)
            return Sum(*xs)

        if fname == "int" and len(node.args) == 1:
            # ``int(<comparison>)`` counts a condition (``int(a < 5) + int(b < 5)``):
            # a boolean-valued expression is no value, so it lowers in bool
            # context. Only one that is boolean in Python too: ``a or 1`` returns
            # an operand, and reading it as a truth value would change the gate.
            arg = self._ast_to_z3(node.args[0], context, local_bindings)
            if arg is None and _is_boolean_valued(node.args[0]):
                arg = self._ast_to_z3_bool(node.args[0], context, local_bindings)
            if arg is None:
                return None
            if isinstance(arg, BoolRef):
                return If(arg, IntVal(1, self.ctx), IntVal(0, self.ctx))
            return arg

        if fname == "abs" and len(node.args) == 1:
            arg = self._ast_to_z3(node.args[0], context, local_bindings)
            if arg is None:
                return None
            return If(arg >= 0, arg, -arg)

        # range(...) only makes sense as a comprehension generator iterable;
        # outside that it has no Z3 meaning.
        return None

    def _lower_call_bool(
        self, node: ast.Call, context: str, local_bindings: dict[str, int]
    ) -> BoolRef | None:
        """Bool-context calls: ``all(xs)`` / ``any(xs)`` / ``bool(x)``."""
        if not isinstance(node.func, ast.Name):
            return None
        fname = node.func.id

        if fname in ("all", "any") and len(node.args) == 1:
            xs = self._unroll_list_arg(node.args[0], context, local_bindings, bool_elements=True)
            if xs is None:
                return None
            if not xs:
                # all([]) == True ; any([]) == False — Python semantics.
                return BoolVal(fname == "all", self.ctx)
            if len(xs) == 1:
                return xs[0]  # type: ignore[return-value]
            return And(*xs) if fname == "all" else Or(*xs)

        if fname == "bool" and len(node.args) == 1:
            arg = self._ast_to_z3(node.args[0], context, local_bindings)
            if arg is None:
                return None
            if isinstance(arg, BoolRef):
                return arg
            # ``bool(None)`` is False (#1769).
            skipped = self._skipped_operand(node.args[0], local_bindings)
            return arg != 0 if skipped is None else And(Not(skipped), arg != 0)

        return None

    def _unroll_list_arg(
        self,
        node: ast.AST,
        context: str,
        local_bindings: dict[str, int],
        bool_elements: bool = False,
    ) -> list[ExprRef] | None:
        """Unroll a list-shaped argument to a Python list of Z3 exprs.

        Accepts ``ast.ListComp``, ``ast.GeneratorExp``, or an explicit
        ``ast.List`` / ``ast.Tuple`` literal. ``bool_elements=True`` lowers
        each element via ``_ast_to_z3_bool``; otherwise via ``_ast_to_z3``.
        Returns ``None`` if any element fails to lower or the shape is
        unsupported.
        """
        if isinstance(node, (ast.ListComp, ast.GeneratorExp)):
            return self._unroll_comprehension(
                node, context, local_bindings, bool_elements=bool_elements
            )
        if isinstance(node, (ast.List, ast.Tuple)):
            results: list[ExprRef] = []
            for elt in node.elts:
                lowered = (
                    self._ast_to_z3_bool(elt, context, local_bindings)
                    if bool_elements
                    else self._ast_to_z3(elt, context, local_bindings)
                )
                if lowered is None:
                    return None
                results.append(lowered)  # type: ignore[arg-type]
            return results
        return None

    def _unroll_comprehension(
        self, node, context: str, local_bindings: dict[str, int], bool_elements: bool = False
    ) -> list[ExprRef] | None:
        """Statically unroll a ``ListComp`` / ``GeneratorExp`` into a Python list of Z3 exprs.

        Each generator's ``iter`` must be a ``range(...)`` call resolvable at
        build time (integer literals OR ``len(<item>.rows|columns)`` via
        ``_resolve_range_call``). Multiple generators compose via
        ``itertools.product``. ``if`` filters are evaluated per-combination
        with ``_ast_to_z3_bool``; resolvable ``False`` skips the combo,
        unresolvable (None) propagates upward as None.
        """
        # Resolve every generator's iterable into a concrete range.
        ranges: list[tuple[str, range, list[ast.expr]]] = []
        for gen in node.generators:
            if not isinstance(gen.target, ast.Name):
                # ``for j, k in …`` — tuple targets unsupported.
                return None
            r = self._resolve_range_call(gen.iter, local_bindings)
            if r is None:
                return None
            ranges.append((gen.target.id, r, gen.ifs))

        results: list[ExprRef] = []
        # Cartesian product over the resolved ranges.
        target_names = [t for t, _, _ in ranges]
        value_lists = [list(vals) for _, vals, _ in ranges]
        guard_lists = [ifs for _, _, ifs in ranges]

        for combo in itertools.product(*value_lists):
            # Build a fresh local binding scope including the outer one and
            # this combo's loop-variable values.
            scope = dict(local_bindings)
            scope.update(dict(zip(target_names, combo, strict=False)))

            # Evaluate guards in scope. Each guard must reduce to a build-time
            # constant after simplification — loop variables are bound to int
            # literals, so any guard like ``k > j`` with both names in scope
            # simplifies to ``True`` / ``False``. Non-constant guards (e.g.,
            # references to a runtime item outcome) are unsupported for the
            # pattern set this unroller targets and propagate None.
            keep = True
            for ifs in guard_lists:
                for guard_expr in ifs:
                    guard_val = self._ast_to_z3_bool(guard_expr, context, scope)
                    if guard_val is None:
                        return None
                    simplified = simplify(guard_val)
                    if is_true(simplified):
                        continue
                    if is_false(simplified):
                        keep = False
                        break
                    # Non-constant guard — unsupported for this pattern set.
                    return None
                if not keep:
                    break
            if not keep:
                continue

            elt = (
                self._ast_to_z3_bool(node.elt, context, scope)
                if bool_elements
                else self._ast_to_z3(node.elt, context, scope)
            )
            if elt is None:
                return None
            results.append(elt)  # type: ignore[arg-type]
        return results

    def _ast_to_z3(
        self, node: ast.AST, context: str, local_bindings: dict[str, int] | None = None
    ) -> ExprRef | None:
        """Convert AST node to Z3 expression.

        ``local_bindings`` carries comprehension loop-variable values during
        unrolling (e.g., ``{'j': 0, 'k': 1}``). Loop variables resolve to
        ``IntVal`` literals; they are checked BEFORE ``self.item_vars`` /
        ``version_map`` to avoid masking item names. ``local_bindings`` is
        scope-local — never written back to ``self.version_map``.
        """
        if local_bindings is None:
            local_bindings = {}
        if isinstance(node, ast.Constant):
            if isinstance(node.value, bool):
                return IntVal(1 if node.value else 0, self.ctx)
            elif isinstance(node.value, int):
                return IntVal(node.value, self.ctx)
            # A string has no Int of its own: a comparison with one lowers in
            # ``_lower_string_compare``, an assignment of one in ``_encode``.

        elif isinstance(node, ast.Name):
            # Comprehension loop variables shadow everything else.
            if node.id in local_bindings:
                return IntVal(local_bindings[node.id], self.ctx)
            if node.id in self._undecided_variables:
                self._note_undecided(node.id)
            return self._get_current_z3_var(node.id)

        elif isinstance(node, ast.Attribute):
            if node.attr in _RANGE_ENDS:
                return self._lower_range_end(node)
            if isinstance(node.value, ast.Name) and node.attr == "outcome":
                item_id = node.value.id
                if item_id in self.item_vars:
                    if self._string_model.text_stored(item_id):
                        # Keyed by the Int read now, which a Roster iteration
                        # or capped-Group presence swaps in (``item_vars``).
                        return self._unmodelled_read(item_id, self.item_vars[item_id])
                    return self.item_vars[item_id]
                # Free text has no Int (``textarea_in_predicate``): a
                # condition leaf comparing it with literals lowers in
                # ``_text_leaf`` (#2241), any other read leaves the condition
                # unlowered, and in a codeBlock what it computes is
                # unconstrained (#2003).
                if self._is_textarea(item_id):
                    return None
                # Matrix items: bare .outcome (no subscript) is unsupported.
                # Caller's WARNING-on-None machinery surfaces this to the author.
                if item_id in self.item_cells:
                    return None

        elif isinstance(node, ast.Subscript):
            # X.outcome[j][k]   →  item_cells[X][(j, k)] (non-Range matrix)
            # X.outcome[j]      →  None (one-level subscript on a matrix has no
            #                       scalar lowering; only fold-context unrolling
            #                       handles row-slice reads — see _unroll_list_arg)
            # arr[i] for non-matrix arr → None (no Python list semantics in Z3)
            cell = self._lower_subscript(node, context, local_bindings)
            root = _answer_root(node)
            path = self._string_model.read_path(node, local_bindings)
            if cell is not None and root is not None and self._string_model.text_stored(root, path):
                return self._unmodelled_read(root, cell)
            return cell

        elif isinstance(node, ast.BinOp):
            if self._string_refusal(node, local_bindings):
                # ``"a" - 1`` raises and ``"a" * 2`` is a string (#2048), so
                # arithmetic over what may hold one has no Int.
                return None
            left = self._ast_to_z3(node.left, context, local_bindings)
            right = self._ast_to_z3(node.right, context, local_bindings)
            if left is not None and right is not None:
                if isinstance(node.op, ast.Add):
                    return left + right
                elif isinstance(node.op, ast.Sub):
                    return left - right
                elif isinstance(node.op, ast.Mult):
                    return left * right
                elif isinstance(node.op, (ast.FloorDiv, ast.Mod)) and _z3_division_agrees(
                    node.op, node.right
                ):
                    # Any other division, lowered, would prove a gate narrower
                    # than the one that runs (``_z3_division_agrees``, #1767).
                    return left / right if isinstance(node.op, ast.FloorDiv) else left % right
                elif isinstance(node.op, ast.BitAnd):
                    return self._lower_bit_and(node, left, right)

        elif isinstance(node, ast.UnaryOp):
            operand = None if self._string_refusal(node, local_bindings) else self._ast_to_z3(
                node.operand, context, local_bindings
            )
            if operand is not None:
                if isinstance(node.op, ast.USub):
                    return -operand
                elif isinstance(node.op, ast.UAdd):
                    return operand

        elif isinstance(node, ast.IfExp):
            # Ternary operator: a if condition else b. A branch carrying text
            # has no Int beside a number's (``_encode`` lowers it for a
            # variable that may hold text); the test is a truth test.
            if self._string_refusal(node, local_bindings):
                return None
            test = self._ast_to_z3_bool(node.test, context, local_bindings)
            body = self._ast_to_z3(node.body, context, local_bindings)
            orelse = self._ast_to_z3(node.orelse, context, local_bindings)
            if test is not None and body is not None and orelse is not None:
                return If(test, body, orelse)

        elif isinstance(node, ast.Call):
            return self._lower_call_value(node, context, local_bindings)

        elif isinstance(node, (ast.ListComp, ast.GeneratorExp)):
            # In a value (non-bool) context, a comprehension only makes sense
            # when wrapped by a fold (sum/all/any/len(set(...))). The fold
            # lowering invokes _unroll_list_arg directly; bare comprehension
            # here is unsupported.
            return None

        return None

    @staticmethod
    def _lower_bit_and(node: ast.BinOp, left: ExprRef, right: ExprRef) -> ExprRef | None:
        """``x & K`` (``_masked``) when either operand is a non-negative integer
        literal ``K``, so the Checkbox mask idiom (``q.outcome & 32 > 0``) is
        exact. Any other ``&`` does not lower: two variables, or a negative
        mask, which parses as a unary minus rather than a literal (it would
        have infinitely many set bits)."""
        if (mask := _int_literal(node.right)) is not None:
            return _masked(left, mask)
        if (mask := _int_literal(node.left)) is not None:
            return _masked(right, mask)
        return None

    def _ast_to_z3_bool(
        self, node: ast.AST, context: str, local_bindings: dict[str, int] | None = None
    ) -> BoolRef | None:
        """Convert AST node to Z3 boolean expression.

        ``local_bindings`` is the comprehension-loop substitution dict (see
        ``_ast_to_z3``).
        """
        if local_bindings is None:
            local_bindings = {}
        if isinstance(node, ast.Compare) and id(node) in self._predicate_raising:
            return self._raise_on_skip(node, context, local_bindings)
        if isinstance(node, ast.Compare):
            # Pattern-match the ranking-distinctness shape BEFORE general
            # comparison handling, so the LHS ``len(set([…]))`` doesn't fall
            # through into bare scalar lowering.
            distinct = self._try_distinct_pattern(node, context, local_bindings)
            if distinct is not None:
                return distinct
            none_test = self._lower_none_test(node)
            if none_test is not None:
                return none_test
            found = self._string_comparison(node, local_bindings)
            if found.kind is not _CompareKind.NONE:
                return self._lower_string_compare(found, context, local_bindings)

            # Support chained comparisons: a < b < c → (a < b) and (b < c)
            if len(node.ops) != len(node.comparators):
                return None
            clauses: list[BoolRef] = []
            lhs = self._ast_to_z3(node.left, context, local_bindings)
            if lhs is None:
                return None
            lhs_node = node.left
            for op, comp in zip(node.ops, node.comparators, strict=False):
                # In/NotIn need the raw AST comparator (list/tuple/set), not Z3 value
                if isinstance(op, (ast.In, ast.NotIn)):
                    if not isinstance(comp, (ast.List, ast.Tuple, ast.Set)) or not comp.elts:
                        return None
                    membership = self._lower_membership(lhs, lhs_node, comp.elts, context, local_bindings)
                    if membership is None:
                        return None
                    clauses.append(membership if isinstance(op, ast.In) else Not(membership))
                    # For chained comparisons after In/NotIn, lhs stays the same
                    continue

                rhs = self._ast_to_z3(comp, context, local_bindings)
                if rhs is None:
                    return None
                if isinstance(op, (ast.Eq, ast.NotEq)):
                    equal = self._equality(lhs, lhs_node, rhs, comp, local_bindings)
                    if equal is None:
                        return None
                    clauses.append(equal if isinstance(op, ast.Eq) else Not(equal))
                elif isinstance(op, ast.Lt):
                    clauses.append(lhs < rhs)
                elif isinstance(op, ast.LtE):
                    clauses.append(lhs <= rhs)
                elif isinstance(op, ast.Gt):
                    clauses.append(lhs > rhs)
                elif isinstance(op, ast.GtE):
                    clauses.append(lhs >= rhs)
                else:
                    # ast.Is / ast.IsNot outside a modelled None test
                    # (``_lower_none_test``): unsupported.
                    return None
                lhs, lhs_node = rhs, comp  # Next comparison uses current comparator as left
            return And(*clauses) if len(clauses) > 1 else clauses[0] if clauses else None

        elif isinstance(node, ast.BoolOp):
            # All operands or nothing (#1164). Dropping an unlowerable operand
            # would verify a different predicate: a dropped ``and`` operand
            # widens the gate (an item reads as reachable where it is not), a
            # dropped ``or`` operand narrows it (a reachable item can classify
            # NEVER and block publication), and a ``not`` over either inverts
            # the error. ``None`` for the whole gate is what the caller already
            # reports as a coverage gap and leaves to runtime enforcement.
            clauses = [self._ast_to_z3_bool(v, context, local_bindings) for v in node.values]
            if any(c is None for c in clauses):
                return None
            if isinstance(node.op, ast.And):
                return And(*clauses)
            if isinstance(node.op, ast.Or):
                return Or(*clauses)

        elif isinstance(node, ast.UnaryOp):
            if isinstance(node.op, ast.Not):
                operand = self._ast_to_z3_bool(node.operand, context, local_bindings)
                return Not(operand) if operand is not None else None

        elif isinstance(node, ast.Constant):
            if isinstance(node.value, bool):
                return BoolVal(node.value, self.ctx)

        elif isinstance(node, ast.Call):
            # all(xs) / any(xs) lower to z3.And / z3.Or over an unrolled list.
            return self._lower_call_bool(node, context, local_bindings)

        # Try to interpret as expression and check truthiness
        expr = self._ast_to_z3(node, context, local_bindings)
        if expr is not None:
            if isinstance(expr, BoolRef):
                return expr
            # Non-zero is true; a skipped item's None is false (#1769); so is
            # the empty string, the one falsy string.
            truthy = expr != 0
            if self._is_encoded(node, local_bindings):
                truthy = And(truthy, expr != IntVal(self._string_model.text_value(""), self.ctx))
            skipped = self._skipped_operand(node, local_bindings)
            return truthy if skipped is None else And(Not(skipped), truthy)

        return None

    def _read_string_model(self) -> _StringModel:
        """The questionnaire's string model, or, when reading its code fails,
        the degraded one (logged; every comparison with text is then
        undecided and reported, never dropped)."""
        try:
            return _StringModel(self)
        except Exception as error:
            self.logger.error(
                "string model could not be read (%s): comparisons with text are left undecided",
                type(error).__name__,
            )
            return _StringModel(self, degraded=True)

    def _parsed(self, source: str, mode: str) -> ast.AST | None:
        """``source`` parsed once per builder, so every reading of one unit
        meets the same nodes (``_memoised``); ``None`` when it does not parse
        (``unsafe_code`` reports that)."""
        key = (source, mode)
        if key not in self._parse_cache:
            try:
                self._parse_cache[key] = ast.parse(source, mode=mode)
            except SyntaxError:
                self._parse_cache[key] = None
        return self._parse_cache[key]

    def _reported_unsafe(self, predicate: str) -> bool:
        """Whether ``unsafe_code`` reports ``predicate`` (it does not parse,
        or the sandbox refuses it), so a fault lowering it is reported there,
        once, and not again as a skipped condition."""
        if self._runner is None:
            # Imported here: ``askalot_qml.core`` imports the engine, which
            # imports this module.
            from askalot_qml.core.python_runner import PythonRunner

            self._runner = PythonRunner()
        return bool(self._runner.validate_expr(predicate))

    def _code_trees(self) -> list[ast.AST]:
        """Every unit of author code, parsed (``_parsed``): codeInit, each
        codeBlock, each ``iterateOver`` and each condition."""
        sources: list[tuple[str, str]] = [(self.state.get_code_init() or "", "exec")]
        for owner in [*self.state.get_all_items(), *self.state.get_blocks()]:
            sources.append((owner.get("codeBlock") or "", "exec"))
            sources.append((owner.get("iterateOver") or "", "eval"))
            for kind in ("precondition", "postcondition"):
                sources.extend((condition.get("predicate") or "", "eval") for condition in owner.get(kind) or [])
        trees = (self._parsed(source, mode) for source, mode in sources if source)
        return [tree for tree in trees if tree is not None]

    def _memoised(self, tag: str, node: ast.AST, local_bindings: Any, compute: Callable[[], Any]) -> Any:
        """``compute()`` once per (``tag``, node, comprehension bindings): the
        bound names with their values where they have them, since an unrolled
        index decides which cell a read is (``_StringModel.read_path``). What
        is memoised reads only the string model, which is fixed for the
        builder, so the memo lives as long as the builder; it holds each node
        it keys on (the parse cache pins the trees too), so an id is never
        reused while it lives."""
        if isinstance(local_bindings, dict):
            bound: frozenset[Any] | None = frozenset(local_bindings.items()) if local_bindings else None
        else:
            bound = frozenset(local_bindings) if local_bindings else None
        key = (tag, id(node), bound)
        hit = self._node_memo.get(key)
        if hit is not None and hit[0] is node:
            return hit[1]
        value = compute()
        self._node_memo[key] = (node, value)
        return value

    def _note_undecided(self, name: str | None) -> None:
        """Record ``name`` as read undecided by the condition being compiled
        (``_compile_conditions``), or, while a codeBlock is lowered, count the
        free value so what that block assigns is undecided too
        (``_process_code_block``)."""
        if self._undecided_reads is None:
            self._code_mints += 1
        elif name is not None and name not in self._undecided_reads:
            self._undecided_reads.append(name)

    def _unmodelled_read(self, item_id: str, own: ExprRef) -> ExprRef:
        """A read of an answer, or of one matrix cell, a store may put text
        into: one free Int per Int the read would otherwise be (``own``: the
        answer's, a Roster iteration's or capped-Group presence's, a cell's),
        the same term at every read of it, since ``own`` is bound by its
        domain and the text is not (``_StringModel.text_stored``)."""
        self._note_undecided(item_id)
        key = str(own)
        read = self._stored_reads.get(key)
        if read is None:
            # ``@`` cannot occur in an item id, so no item, cell or variable
            # shares the name.
            read = self._stored_reads[key] = Int(f"stored@{key}", self.ctx)
        return read

    def _is_encoded(self, node: ast.AST, local_bindings: Any = frozenset()) -> bool:
        """Whether ``node`` is a variable carrying its value encoded
        (``_StringModel``)."""
        return isinstance(node, ast.Name) and node.id not in local_bindings and self._string_model.encoded(node.id)

    def _carries_string(self, node: ast.AST, local_bindings: Any = frozenset()) -> bool:
        """Whether ``node``'s value may be built from text (a string literal,
        a variable that may hold text or anything, an answer text may be
        stored into) other than through a comparison, which yields a bool.
        Arithmetic, a call or an ordering over such a value does not lower:
        Python raises on text there or computes text."""

        def compute() -> bool:
            if _is_str_literal(node):
                return True
            if isinstance(node, ast.Name):
                # A name no code assigns (a builtin, an item id) holds no text here.
                return (
                    node.id not in local_bindings
                    and self._string_model.assigned(node.id)
                    and not self._string_model.number_only(node, local_bindings)
                )
            item = _answer_root(node)
            if item is not None and item in self.item_details:
                return self._string_model.text_stored(item, self._string_model.read_path(node, local_bindings))
            if isinstance(node, (ast.Compare, ast.BoolOp)) or (
                isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.Not)
            ):
                return False
            return any(self._carries_string(child, local_bindings) for child in ast.iter_child_nodes(node))

        return self._memoised("carries", node, local_bindings, compute)

    def _encode(self, node: ast.AST, context: str, local_bindings: dict[str, int] | None = None) -> ExprRef | None:
        """``node``'s value encoded for a variable that may hold text
        (``_StringModel``): a string literal as its text value, an encoded
        variable as it is, a ternary branch by branch, any other value that
        lowers as ``2 * value``. A value that may hold anything
        (``_StringModel.holds_any``) is ``None``: it may be text, so it is no
        doubled number, and the version it writes is unconstrained, which a
        condition reading it says (``_free_variables``)."""
        local_bindings = local_bindings or {}
        if _is_str_literal(node):
            return IntVal(self._string_model.text_value(node.value), self.ctx)  # type: ignore[attr-defined]
        if self._is_encoded(node, local_bindings):
            return self._ast_to_z3(node, context, local_bindings)
        if isinstance(node, ast.IfExp):
            test = self._ast_to_z3_bool(node.test, context, local_bindings)
            body = self._encode(node.body, context, local_bindings)
            orelse = self._encode(node.orelse, context, local_bindings)
            return None if test is None or body is None or orelse is None else If(test, body, orelse)
        if self._carries_string(node, local_bindings) or self._string_model.holds_any(node, local_bindings):
            return None
        value = self._ast_to_z3(node, context, local_bindings)
        return None if value is None else IntVal(2, self.ctx) * value

    def _equality(
        self, lhs: ExprRef, lhs_node: ast.AST, rhs: ExprRef, rhs_node: ast.AST, local_bindings: dict[str, int]
    ) -> BoolRef:
        """``lhs == rhs`` as Python answers it: skip-aware (#1769), and an
        encoded side against a value that is provably a number (or ``None``,
        which equals no text and no number: ``_StringModel.number_only``)
        compares the number's encoding. Against anything else (a call's
        result, an answer text may be stored into) the comparison is
        undecided (``_undecided_equality``): never a doubled guess."""
        encoded_l, encoded_r = self._is_encoded(lhs_node, local_bindings), self._is_encoded(rhs_node, local_bindings)
        if encoded_l != encoded_r:
            other = rhs_node if encoded_l else lhs_node
            if not self._string_model.number_only(other, local_bindings):
                equal = self._undecided_equality(lhs, lhs_node, rhs, rhs_node)
                return self._skip_aware_equality(equal, lhs_node, rhs_node, local_bindings)
            if encoded_l:
                rhs = IntVal(2, self.ctx) * rhs
            else:
                lhs = IntVal(2, self.ctx) * lhs
        return self._skip_aware_equality(lhs == rhs, lhs_node, rhs_node, local_bindings)

    def _undecided_equality(self, lhs: ExprRef, lhs_node: ast.AST, rhs: ExprRef, rhs_node: ast.AST) -> BoolRef:
        """``lhs == rhs`` where the model cannot tell text from a number on
        one side: one free Bool per pair of terms (so ``a == b or a != b``
        holds), noted where it is minted (``_note_undecided``)."""
        for node in (lhs_node, rhs_node):
            self._note_undecided(node.id if isinstance(node, ast.Name) else _answer_root(node))
        key = "eq@" + "|".join(sorted([str(lhs), str(rhs)]))
        choices = self._string_choices.setdefault(key, {})
        choice = choices.get(frozenset())
        if choice is None:
            # ``@`` cannot occur in an item id or variable name, so nothing
            # shares the name.
            choice = choices[frozenset()] = Bool(f"str@{key}", self.ctx)
        return choice

    def _lower_membership(
        self,
        lhs: ExprRef,
        lhs_node: ast.AST,
        elts: list[ast.expr] | tuple[ast.expr, ...],
        context: str,
        local_bindings: dict[str, int],
    ) -> BoolRef | None:
        """``lhs in [elts]`` as ``==`` against each member (``_equality``);
        ``None`` when a member does not lower, since dropping it would narrow
        ``in`` and widen ``not in`` (#1164)."""
        parts = []
        for elt in elts:
            value = self._ast_to_z3(elt, context, local_bindings)
            if value is None:
                return None
            parts.append(self._equality(lhs, lhs_node, value, elt, local_bindings))
        return Or(*parts)

    def _string_comparison(self, node: ast.Compare, local_bindings: Any) -> _StringComparison:
        """How a comparison involving text lowers, once per node: the one
        reading the lowering (``_lower_string_compare``) and the report
        (``_string_refusal``) share.

        A string literal on either side of ``==`` / ``!=``, or a member of a
        literal list tested with ``in`` / ``not in``, makes a string
        comparison; so does an ordering of anything that may hold text (it
        raises against a number). A chain holding text is the conjunction of
        its pairs (``CHAIN``), each read on its own. Refused: an ordering,
        ``in`` a string, a string ``in`` a list that is not all literals, a
        list member that is a literal other than a whole number or a string
        (the model holds no ``None`` value), and an operand the string model
        cannot place (``_StringModel.operand``)."""
        return self._memoised("compare", node, local_bindings, lambda: self._read_string_comparison(node, local_bindings))

    def _read_string_comparison(self, node: ast.Compare, local_bindings: Any) -> _StringComparison:
        operands = [node.left, *node.comparators]
        strings = False
        for i, op in enumerate(node.ops):
            left, right = operands[i], operands[i + 1]
            if isinstance(op, _ORDERING_OPS):
                if self._carries_string(left, local_bindings) or self._carries_string(right, local_bindings):
                    return _REFUSED_COMPARISON
            elif _is_str_literal(left) or _is_str_literal(right):
                strings = True
            elif isinstance(op, (ast.In, ast.NotIn)) and isinstance(right, (ast.List, ast.Tuple, ast.Set)):
                strings = strings or any(_is_str_literal(elt) for elt in right.elts)
        if not strings:
            return _NO_STRING
        if len(node.ops) != 1:
            parts = tuple(
                ast.copy_location(ast.Compare(left=operands[i], ops=[op], comparators=[operands[i + 1]]), node)
                for i, op in enumerate(node.ops)
            )
            return _StringComparison(_CompareKind.CHAIN, parts=parts)
        op, left, right = node.ops[0], node.left, node.comparators[0]
        negated = isinstance(op, (ast.NotEq, ast.NotIn))
        if isinstance(op, (ast.Eq, ast.NotEq)):
            if _is_str_literal(left):
                left, right = right, left
            literal = self._literal_values(left, scalar=True)
            if literal is not None:
                return _StringComparison(_CompareKind.FOLDED, truth=literal[0] == right.value, negated=negated)  # type: ignore[attr-defined]
            members: tuple[ast.expr, ...] = ()
            texts = frozenset([right.value])  # type: ignore[attr-defined]
        elif isinstance(op, (ast.In, ast.NotIn)) and isinstance(right, (ast.List, ast.Tuple, ast.Set)):
            literal = self._literal_values(left, scalar=True)
            listed = self._literal_values(right, scalar=False)
            if literal is not None and listed is not None:
                return _StringComparison(_CompareKind.FOLDED, truth=literal[0] in listed, negated=negated)
            if _is_str_literal(left):
                return _REFUSED_COMPARISON
            members = tuple(elt for elt in right.elts if not _is_str_literal(elt))
            if any(isinstance(elt, ast.Constant) and not isinstance(elt.value, int) for elt in members):
                return _REFUSED_COMPARISON
            texts = frozenset(elt.value for elt in right.elts if _is_str_literal(elt))  # type: ignore[attr-defined]
        else:
            return _REFUSED_COMPARISON
        how = self._string_model.operand(left, local_bindings)
        if how is None:
            return _REFUSED_COMPARISON
        return _StringComparison(_CompareKind.COMPARE, negated=negated, operand=left, members=members, texts=texts, how=how)

    def _lower_string_compare(
        self, found: _StringComparison, context: str, local_bindings: dict[str, int]
    ) -> BoolRef | None:
        """A comparison with a string literal (``_string_comparison``) as
        Python answers it, or ``None`` where it does not lower.

        Two literals fold (``1 == "1"`` is False). The operand's class decides
        the strings (``_StringModel.operand``): an operand holding no string
        equals none (``q.outcome in [1, "x"]`` is ``q.outcome in [1]``); an
        encoded variable compares exactly with each string's text value (and
        is noted undecided where some version of it is unconstrained); any
        other is a free Bool (``_string_choice``), noted where it is minted.
        The list's other members compare as ``==`` (``_equality``). A
        Textarea's text is ``_text_leaf``'s (#2241) and does not lower here.
        """
        if found.kind is _CompareKind.REFUSED:
            return None
        if found.kind is _CompareKind.CHAIN:
            # Every operand of a chain is a read without side effects here, so
            # reading a middle one twice is reading it once.
            parts = [self._ast_to_z3_bool(part, context, local_bindings) for part in found.parts]
            return None if any(part is None for part in parts) else And(*parts)
        if found.kind is _CompareKind.FOLDED:
            return BoolVal(found.truth != found.negated, self.ctx)
        if found.how is _Operand.TEXT or found.operand is None:
            return None
        value = self._ast_to_z3(found.operand, context, local_bindings)
        if value is None:
            return None
        parts: list[BoolRef] = []
        if found.members:
            numbers = self._lower_membership(value, found.operand, found.members, context, local_bindings)
            if numbers is None:
                return None
            parts.append(numbers)
        if found.how is _Operand.ENCODED:
            operand = found.operand
            if isinstance(operand, ast.Name) and (operand.id in self._free_variables or operand.id in self._open_reads):
                # An unconstrained version holds anything: exact where it is
                # pinned, undecided where it is not, and said so.
                self._note_undecided(operand.id)
            parts.extend(value == IntVal(self._string_model.text_value(text), self.ctx) for text in sorted(found.texts))
        elif found.how is _Operand.UNDECIDED or (
            isinstance(found.operand, ast.Name)
            and found.operand.id not in local_bindings
            and not self._string_model.always_bound(found.operand.id)
        ):
            # A name that may be unbound here raises (NameError), which no
            # constant answers for both condition kinds: undecided.
            parts.append(self._string_choice(found.operand, value, found.texts))
        truth = Or(*parts) if len(parts) > 1 else parts[0] if parts else BoolVal(False, self.ctx)
        return Not(truth) if found.negated else truth

    def _string_choice(self, node: ast.AST, value: ExprRef, texts: frozenset[str]) -> BoolRef:
        """Whether ``node`` (lowered to ``value``) equals one of ``texts``,
        for a value the model does not hold exactly (``_Operand.UNDECIDED``),
        noted where it is minted (``_note_undecided``).

        A variable read at one SSA version, and an answer or cell a store may
        put text into (``_unmodelled_read``), is one term wherever it is read,
        so the comparison is one Bool per (term, literal set) and ``x == "a"
        or x != "a"`` always holds; two cells are two terms. An open read of a
        variable gets a fresh Bool per comparison."""
        self._note_undecided(node.id if isinstance(node, ast.Name) else _answer_root(node))
        shared = (isinstance(node, ast.Name) and node.id not in self._open_reads) or (
            _answer_root(node) is not None
        )
        if shared:
            key = str(value)
            choices = self._string_choices.setdefault(key, {})
            choice = choices.get(texts)
            if choice is None:
                # ``@`` cannot occur in an item id or variable name, so nothing
                # shares the name; no ``#``, since one Bool serves every lowering.
                choice = choices[texts] = Bool(f"str@{key}@{len(choices)}", self.ctx)
            return choice

        def mint() -> BoolRef:
            self._string_count += 1
            return Bool(f"str@#{self._string_count}", self.ctx)

        return self._mint(mint)

    def _string_refusal(self, node: ast.AST, local: Any) -> bool:
        """Whether ``node`` is a use of text the lowering refuses: the one
        predicate the lowering (``_ast_to_z3``, ``_lower_call_value``) and the
        report (``_unsupported_node_kinds``, ``Str``) both ask, so a node is
        never left out without being reported. Arithmetic, a ternary branch
        or a call argument over a value that may hold text
        (``_carries_string``), and a refused string comparison
        (``_string_comparison``). A comparison whose operand holds a call or a
        subscript is reported under that node's kind instead."""
        if isinstance(node, ast.BinOp):
            return self._carries_string(node.left, local) or self._carries_string(node.right, local)
        if isinstance(node, ast.UnaryOp) and not isinstance(node.op, ast.Not):
            return self._carries_string(node.operand, local)
        if isinstance(node, ast.IfExp):
            return self._carries_string(node.body, local) or self._carries_string(node.orelse, local)
        if isinstance(node, ast.Call):
            return any(self._carries_string(arg, local) for arg in [*node.args, *(k.value for k in node.keywords)])
        if isinstance(node, ast.Compare) and self._string_comparison(node, local).kind is _CompareKind.CHAIN:
            return any(self._string_refusal(part, local) for part in self._string_comparison(node, local).parts)
        if isinstance(node, ast.Compare) and self._string_comparison(node, local).kind is _CompareKind.REFUSED:
            return not any(
                isinstance(n, (ast.Call, ast.Subscript, ast.ListComp, ast.GeneratorExp)) for n in ast.walk(node)
            )
        return False

    def _raise_on_skip(
        self, node: ast.Compare, context: str, local_bindings: dict[str, int]
    ) -> BoolRef | None:
        """A precondition comparison that raises when one of its items was
        skipped, where the raise cannot be placed: False then (``_wrap_unplaced``, #1775)."""
        raising = self._predicate_raising.pop(id(node))
        try:
            lowered = self._ast_to_z3_bool(node, context, local_bindings)
        finally:
            self._predicate_raising[id(node)] = raising
        if lowered is None:
            return None
        choices, slot_reads = raising
        skipped = list(choices)
        for read in slot_reads:
            slot = self._slot_of(read, local_bindings)
            if slot is None:
                return None
            skipped.append(slot)
        return And(*[Not(choice) for choice in skipped], lowered)

    def _skipped_operand(self, node: ast.AST, local_bindings: dict[str, int] | None = None) -> BoolRef | None:
        """The Bool under which ``node`` reads ``None``, iff it is ``Y.outcome``
        for an item the predicate being lowered models as possibly skipped
        (#1769), or a QuestionGroup answer or matrix cell read in a position
        that does not raise on an unanswered slot (#184, #1780)."""
        if id(node) in self._predicate_slot_safe:
            return self._slot_of(node, local_bindings or {})
        item_id = outcome_ref_name(node)
        return self._predicate_skipped.get(item_id) if item_id is not None else None

    def _skip_aware_equality(
        self, equal: BoolRef, left: ast.AST, right: ast.AST, local_bindings: dict[str, int] | None = None
    ) -> BoolRef:
        """``left == right`` as Python answers it when either side may be a
        skipped item's ``None`` (#1769): ``None == None`` is True, and ``None``
        equals no number."""
        left_skipped = self._skipped_operand(left, local_bindings)
        right_skipped = self._skipped_operand(right, local_bindings)
        if left_skipped is None and right_skipped is None:
            return equal
        if left_skipped is None or right_skipped is None:
            skipped = left_skipped if right_skipped is None else right_skipped
            return And(Not(skipped), equal)
        return Or(
            And(left_skipped, right_skipped),
            And(Not(left_skipped), Not(right_skipped), equal),
        )

    def _skippable_reads(
        self, tree: ast.AST, context: str
    ) -> tuple[set[str], list[tuple[str, ast.AST]], dict[ast.AST, ast.AST]]:
        """``(items read where Python sees their None, (item, node) of each
        read that raises on it, the tree's parent map)``, #1769 / #1775.

        An item asked under a precondition, or drawn into a Roster iteration or
        a capped Group, reads ``None`` once it was not asked. Python answers
        ``None == c``, ``!= c``, ``in``, ``not in`` and truthiness without
        raising (``q.outcome != 1`` holds for everyone who skipped ``q``, and
        an ``==`` / ``!=`` chain likewise), and raises on an ordering or
        arithmetic read (``None > 1``). Both
        kinds are modelled with the item's skip choice (``_skipped_choice``):
        the first in the comparison itself, the second as the raise of the
        leaf that holds it (``_place_raises``, ``_leaf_raise``).

        Not modelled: the predicate's own item (it is being asked), an item the
        predicate None-guards (``_lower_none_test`` models it), and anything
        without a scalar variable.

        Refused (#1867): a read whose value a ternary branch passes on
        (``_value_through_ternary``). Its ``None`` reaches whatever encloses
        the ternary untouched, which may read it without raising (``in`` a
        list, ``==``), so it is neither a raise to place nor a value the
        in-domain Int stands for: lowering it would prove a gate NEVER that a
        skip makes True. The predicate is left unlowered
        (``_UnmodelledAnswerRead``) and the gap names the item, as a
        QuestionGroup or matrix read through a ternary is.
        """
        parents = self._build_parent_map(tree)
        none_operands = {id(operand) for operand in none_test_operands(tree)}
        safe: set[str] = set()
        raising: list[tuple[str, ast.AST]] = []
        refused: list[str] = []
        for node in ast.walk(tree):
            item_id = outcome_ref_name(node)
            if item_id is None or id(node) in none_operands or not self._may_be_skipped(item_id, context):
                continue
            if self._none_safe_read(node, parents):
                safe.add(item_id)
            elif self._value_through_ternary(node, parents) and not self._ternary_certainly_raises(node, parents):
                if item_id not in refused:
                    refused.append(item_id)
            else:
                raising.append((item_id, node))
        if refused:
            named = self._ternary_refusals.setdefault(context, [])
            named.extend(item for item in refused if item not in named)
            raise _UnmodelledAnswerRead(refused[0])
        return safe, raising, parents

    @staticmethod
    def _value_through_ternary(node: ast.AST, parents: dict[ast.AST, ast.AST]) -> bool:
        """Whether ``node`` is itself a branch of a ternary (``q.outcome if c
        else 0``), so a ``None`` there flows on past the ternary untouched.
        Arithmetic inside a branch (``q.outcome + 1 if c else 0``) raises on
        ``None`` before it leaves, so it stays a raise the wide lowering covers."""
        parent = parents.get(node)
        return isinstance(parent, ast.IfExp) and parent.test is not node

    @staticmethod
    def _ternary_certainly_raises(node: ast.AST, parents: dict[ast.AST, ast.AST]) -> bool:
        """Whether the ``None`` a ternary branch passes on certainly raises
        where the ternary's value lands: through (nested ternaries and)
        arithmetic, or as an operand of an ordering on both sides. There the
        read is an unplaced raise the wide lowering covers soundly
        (``(q.outcome if c else 0) > 99`` stays provable NEVER); anywhere
        else the ``None`` may be read without raising and is refused."""
        child, parent = node, parents.get(node)
        while isinstance(parent, ast.IfExp) and parent.test is not child:
            child, parent = parent, parents.get(parent)
        if isinstance(parent, ast.BinOp) or (isinstance(parent, ast.UnaryOp) and not isinstance(parent.op, ast.Not)):
            return True
        if isinstance(parent, ast.Compare):
            chain = [parent.left, *parent.comparators]
            position = next(i for i, operand in enumerate(chain) if operand is child)
            touching = parent.ops[max(position - 1, 0) : position + 1]
            return all(isinstance(op, _ORDERING_OPS) for op in touching)
        return False

    def _place_raises(
        self,
        raising: list[tuple[str, ast.AST]],
        list_raising: list[tuple[str, ast.AST]],
        slot_reads: list[ast.AST],
        choices: dict[str, BoolRef],
        parents: dict[ast.AST, ast.AST],
    ) -> tuple[dict[int, list[tuple[int | None, bool, BoolRef]]], set[int], list[tuple[str | None, ast.AST]]]:
        """``(the raise each condition leaf certainly makes, the ids of the
        slot reads placed, the reads whose raise cannot be placed)``, #1775 / #1779.

        A raising read is placed on the leaf the runtime evaluates it in
        (``_raise_site``), with the operand of the comparison that holds it and
        whether evaluating that operand raises (arithmetic, a subscript of a
        skipped QuestionGroup or matrix, a Range end) or only an ordering on it does (a bare
        ``None``): ``(operand index or None for a truth-tested leaf, evaluated,
        choice)``, which ``_leaf_raise`` turns into the leaf's raise, so the
        two-sided lowering (``_Outcome``) is exact wherever the leaf sits. A
        chained comparison holding ``in`` / ``is`` is not placed (it evaluates
        its clauses the way ``_ast_to_z3_bool`` does not split), nor is a slot
        read whose index does not resolve.

        A read with no such leaf (through a call, a container, a subscript, a
        ternary, a comprehension) may not raise, or not there; it keeps the
        wide lowering (``_wrap_unplaced`` / ``_waive_unplaced``).
        """
        by_leaf: dict[int, tuple[ast.AST, list[tuple[str | None, ast.AST, int | None, bool, BoolRef]]]] = {}
        unplaced: list[tuple[str | None, ast.AST]] = []
        reads = [
            *((key, node, False) for key, node in raising),
            *((key, node, True) for key, node in list_raising),
            # A Range end (``None.low``) raises whatever the operator.
            *((None, node, self._is_range_item(self._answer_read(node)[0])) for node in slot_reads),
        ]
        for key, node, whole_list in reads:
            site = self._raise_site(node, parents)
            choice = choices[key] if key is not None else self._slot_of(node, {})
            if site is None or choice is None:
                unplaced.append((key, node))
                continue
            leaf, operand, evaluated = site
            by_leaf.setdefault(id(leaf), (leaf, []))[1].append((key, node, operand, evaluated or whole_list, choice))
        placed: dict[int, list[tuple[int | None, bool, BoolRef]]] = {}
        placed_slots: set[int] = set()
        allowed = (ast.Eq, ast.NotEq, *_ORDERING_OPS)
        for leaf_id, (leaf, entries) in by_leaf.items():
            if isinstance(leaf, ast.Compare) and len(leaf.ops) > 1 and not all(isinstance(op, allowed) for op in leaf.ops):
                unplaced.extend((key, node) for key, node, *_ in entries)
                continue
            placed[leaf_id] = [(operand, evaluated, choice) for _, _, operand, evaluated, choice in entries]
            placed_slots |= {id(node) for key, node, *_ in entries if key is None}
        return placed, placed_slots, unplaced

    @staticmethod
    def _condition_leaf(node: ast.AST, parents: dict[ast.AST, ast.AST]) -> ast.AST:
        """The condition leaf ``node`` sits in: the outermost ancestor-or-self
        that is not an ``and`` / ``or`` / ``not`` and has only those above it,
        the leaf ``FlowProcessor._parse_condition`` splits off and
        ``_lower_kleene`` lowers whole. A junction inside a call, a list or a
        ternary belongs to that call's leaf."""
        path = [node]
        while (parent := parents.get(path[-1])) is not None:
            path.append(parent)
        for candidate in reversed(path):
            if not (
                isinstance(candidate, ast.BoolOp)
                or (isinstance(candidate, ast.UnaryOp) and isinstance(candidate.op, ast.Not))
            ):
                return candidate
        return node

    @classmethod
    def _raise_site(cls, node: ast.AST, parents: dict[ast.AST, ast.AST]) -> tuple[ast.AST, int | None, bool] | None:
        """Where a raising read raises, if certainly there: ``(leaf, operand
        index of the comparison it is, or None for a truth-tested leaf,
        whether evaluating the operand raises)``. The read must reach the leaf
        through arithmetic alone (``_comparison_raising_on``), and the leaf
        must be one the runtime splits the condition into (``_parse_condition``:
        only ``and`` / ``or`` / ``not`` above it)."""
        child, parent = node, parents.get(node)
        while isinstance(parent, ast.BinOp) or (isinstance(parent, ast.UnaryOp) and not isinstance(parent.op, ast.Not)):
            child, parent = parent, parents.get(parent)
        if isinstance(parent, ast.Compare):
            leaf: ast.AST = parent
            operands = [parent.left, *parent.comparators]
            operand = next((i for i, o in enumerate(operands) if o is child), None)
            if operand is None:
                return None
        elif parent is None or isinstance(parent, (ast.BoolOp, ast.UnaryOp)):
            leaf, operand = child, None
        else:
            return None
        if cls._condition_leaf(leaf, parents) is not leaf:
            return None
        return leaf, operand, child is not node or operand is None

    def _leaf_raise(
        self, leaf: ast.AST, reads: list[tuple[int | None, bool, BoolRef]], context: str
    ) -> BoolRef | None:
        """When ``leaf`` raises, Python's way (``_place_raises``); ``None``
        when a clause of its chain does not lower.

        A truth-tested leaf raises on any read in it. A comparison ``o0 op0
        o1 op1 o2 …`` evaluates ``o0``, ``o1``, compares, and only while each
        clause holds evaluates the next operand and the next clause, so a read
        raises once the clauses before it hold: evaluating its operand
        (arithmetic, a skipped list's subscript), or a bare ``None`` meeting
        an ordering clause (``1 == None < 5`` stops at ``1 == None``)."""
        if not isinstance(leaf, ast.Compare):
            return self._disjoin([choice for _, _, choice in reads])
        operands = [leaf.left, *leaf.comparators]
        on_evaluation: list[list[BoolRef]] = [[] for _ in operands]
        on_ordering: list[list[BoolRef]] = [[] for _ in operands]
        for operand, evaluated, choice in reads:
            (on_evaluation if evaluated else on_ordering)[operand].append(choice)
        steps: list[BoolRef] = []
        reached: list[BoolRef] = []
        for i, op in enumerate(leaf.ops):
            parts = [c for j in ((0, 1) if i == 0 else (i + 1,)) for c in on_evaluation[j]]
            if isinstance(op, _ORDERING_OPS):
                parts += on_ordering[i] + on_ordering[i + 1]
            if parts:
                steps.append(And(*reached, self._disjoin(parts)) if reached else self._disjoin(parts))
            if i + 1 < len(leaf.ops):
                clause = self._ast_to_z3_bool(
                    ast.Compare(left=operands[i], ops=[op], comparators=[operands[i + 1]]), context
                )
                if clause is None:
                    return None
                reached.append(clause)
        return self._disjoin(steps) if steps else BoolVal(False, self.ctx)

    def _wrap_unplaced(
        self,
        unplaced: list[tuple[str | None, ast.AST]],
        choices: dict[str, BoolRef],
        parents: dict[ast.AST, ast.AST],
    ) -> tuple[dict[int, tuple[list[BoolRef], list[ast.AST]]], list[str]]:
        """A precondition's raises ``_place_raises`` could not place: ``(the
        comparisons holding one and the skip choices each raises on, the items
        whose raise leaves the lowering wider than the gate)``, #1775.

        A precondition that raises is False, so such a comparison lowers as
        ``And(Not(skipped), comparison)`` (``_raise_on_skip``): never narrower
        than the runtime (a raise is the gate's bottom), but wide, since a
        comparison inside a call, a ternary or a comprehension can be negated
        or outweighed by what encloses it. A read outside any comparison it
        certainly raises in (``len(set([None, 2])) == 2`` and ``str(None) ==
        "None"`` raise nothing) is not wrapped (wrapping would claim a raise
        that may not happen). A slot read's slot is resolved when the
        comparison is lowered, since a comprehension variable may name it.
        """
        by_compare: dict[int, tuple[set[str], list[ast.AST]]] = {}
        wide: set[str] = set()
        for key, node in unplaced:
            wide |= {key} if key is not None else outcome_reads(node)
            compare = self._comparison_raising_on(node, parents)
            if compare is None:
                continue
            items, reads = by_compare.setdefault(id(compare), (set(), []))
            if key is None:
                reads.append(node)
            else:
                items.add(key)
        return {
            key: ([choices[i] for i in sorted(items)], reads) for key, (items, reads) in by_compare.items()
        }, sorted(wide)

    def _waive_unplaced(
        self, unplaced: list[tuple[str | None, ast.AST]], choices: dict[str, BoolRef]
    ) -> tuple[list[BoolRef], list[str]]:
        """A postcondition's raises ``_place_raises`` could not place: ``(the
        choices any of which waives it, the items they read)``. A postcondition
        that raises is waived, so the whole predicate is widened by them at its
        root, a slot read by every slot it may take (#1775)."""
        waived: list[BoolRef] = []
        items: set[str] = set()
        for key, node in unplaced:
            if key is not None:
                waived.append(choices[key])
                items.add(key)
                continue
            slots = self._slots_a_read_may_take(node)
            waived.extend(slots)
            if slots:
                items |= outcome_reads(node)
        return waived, sorted(items)

    @staticmethod
    def _comparison_raising_on(node: ast.AST, parents: dict[ast.AST, ast.AST]) -> ast.Compare | None:
        """The comparison that certainly raises when ``node`` reads ``None``,
        or ``None``: the read must reach it through arithmetic alone (``None
        + 1`` and ``-None`` raise); anything else between them (a call, a
        container, a subscript, a ternary, ``and`` / ``or``, a comprehension)
        may evaluate the read without raising, or not at all."""
        parent = parents.get(node)
        while isinstance(parent, ast.BinOp) or (
            isinstance(parent, ast.UnaryOp) and not isinstance(parent.op, ast.Not)
        ):
            parent = parents.get(parent)
        return parent if isinstance(parent, ast.Compare) else None

    @staticmethod
    def _none_safe_read(node: ast.AST, parents: dict[ast.AST, ast.AST]) -> bool:
        """Whether Python reads ``node`` without raising when it is ``None``:
        an operand of ``==`` / ``!=`` (chained too), the left of a lone ``in`` /
        ``not in`` a literal list or a member of that list, or a truth value
        (including ``bool(x)`` and a member or comprehension element of
        ``any(...)`` / ``all(...)``)."""
        parent = parents.get(node)
        if isinstance(parent, (ast.List, ast.Tuple, ast.Set)):
            holder = parents.get(parent)
            if isinstance(holder, ast.Call):
                return _is_call_to(holder, ("any", "all")) and holder.args == [parent]
            return (
                isinstance(holder, ast.Compare)
                and len(holder.ops) == 1
                and isinstance(holder.ops[0], (ast.In, ast.NotIn))
                and holder.comparators[0] is parent
            )
        if isinstance(parent, ast.Call):
            return _is_call_to(parent, ("bool",)) and parent.args == [node]
        if isinstance(parent, (ast.GeneratorExp, ast.ListComp)) and parent.elt is node:
            holder = parents.get(parent)
            return isinstance(holder, ast.Call) and _is_call_to(holder, ("any", "all")) and holder.args == [parent]
        if isinstance(parent, ast.Compare):
            chain = [parent.left, *parent.comparators]
            position = next(i for i, operand in enumerate(chain) if operand is node)
            touching = parent.ops[max(position - 1, 0) : position + 1]
            if all(isinstance(op, (ast.Eq, ast.NotEq)) for op in touching):
                return True  # ``1 != None != 2`` does not raise.
            if len(parent.ops) != 1:
                return False
            op = parent.ops[0]
            return (
                isinstance(op, (ast.In, ast.NotIn))
                and parent.left is node
                and isinstance(parent.comparators[0], (ast.List, ast.Tuple, ast.Set))
            )
        if isinstance(parent, ast.UnaryOp):
            return isinstance(parent.op, ast.Not)
        if isinstance(parent, ast.IfExp):
            return parent.test is node
        return parent is None or isinstance(parent, ast.BoolOp)

    def _may_be_skipped(self, item_id: str, context: str) -> bool:
        if item_id == self._own_none and item_id == context:
            # Admitting a blank (``_blank_acceptance``): the item's own reads see
            # its ``None`` the Python way, unless its None guard decides them.
            return item_id not in self._none_guarded
        if item_id == context or item_id in self._none_guarded or item_id not in self.item_vars:
            return False
        item = self.state.get_item(item_id)
        details = self.item_details.get(item_id)
        if item is None or details is None or details.get("kind") != "Question":
            return False
        return bool(
            details.get("preconditions") or self._is_scoped(item_id)
        )

    def _skipped_choice(self, item_id: str) -> BoolRef:
        """Whether item Y reads as skipped: one free Bool per item (#1769).

        It is not tied to Y's own gate being false. A gate that reads an item
        shown and left empty is undecided at runtime and skips (#1023), where
        the model holds that item as an answer and the gate can hold, so
        ``Not(P_Y)`` would be narrower than the runtime and prove gates NEVER.
        Nor does a false gate force the skip: an API submit or a codeBlock write
        answers an item whatever its gate. The choice belongs to the world, not
        the predicate: a solver asking whether a gate can fail chooses it as
        freely as one asking whether it can hold, so a gate and its negation
        are both exact. It is one per item, like the item's value (one Int for
        every predicate): the walk does not revisit a skip. An item a codeBlock
        writes is the exception: the write can answer it between two
        predicates, so each predicate gets its own choice. #1250's
        ``answered`` is per predicate instead because an item's own gate runs
        before it is answered and its postcondition after. An item with no
        gate, outside a Roster or capped Group, is never skipped and gets none
        (``_may_be_skipped``).

        Skipped is not blank (#1784): a skipped item reads ``None`` the Python
        way (``q.outcome != 1`` holds), while one shown and left blank makes
        the whole leaf that reads it unknown (``_blank_choice``). A gated item
        has both choices; a world with both true lowers like the blank one.
        While a blank is being admitted, the item itself is ``None`` for
        certain, so its choice is the constant True (``_blank_acceptance``).
        """
        if item_id == self._own_none:
            return BoolVal(True, self.ctx)
        if item_id in self._code_written_items():
            # A codeBlock may answer it between two predicates, so each gets its own.
            def mint() -> BoolRef:
                self._skipped_count += 1
                fresh = Bool(f"skipped@{item_id}#{self._skipped_count}", self.ctx)
                self._fresh_skip_choices.setdefault(item_id, []).append(fresh)
                return fresh

            return self._mint(mint)
        choice = self._skip_choices.get(item_id)
        if choice is None:
            # ``@`` cannot occur in an item id, so no item or variable shares the name.
            choice = self._skip_choices[item_id] = Bool(f"skipped@{item_id}", self.ctx)
        return choice

    def answered_mint(self, name: str) -> tuple[str, str] | None:
        """``(X, context)`` for a per-predicate ``answered@X#n`` symbol: the item
        X it tests and the item whose condition was being lowered when it was
        minted (the guard's own item, or another item whose blank acceptance a
        lowering conjoins). ``None`` for any other name."""
        return self._answered_minted.get(name)

    def answered_by_world(self, item_id: str, *, skippable: bool) -> BoolRef | None:
        """Whether ``item_id`` holds an answer, as the world's choices state it
        once the walk is past it (#2046): neither skipped (``_skipped_choice``,
        a gated item) nor left blank (``_blank_choice``, whose admissibility is
        in the domain base). ``None`` for an item those choices do not settle:
        one a codeBlock or codeInit writes (the write can answer it mid-walk),
        one a None test does not model (``_answerable``), and, unless
        ``skippable``, a gated one.

        The choices are wider than the walk, so the result is sound for a
        claim that no world satisfies a formula (``unsat``). The skip choice
        is not tied to the item's gate (``_skipped_choice``), so a world that
        satisfies a formula through it need not be a real walk: a reader that
        claims a world exists passes ``skippable=False``. It reads the shared
        choices without registering them, so ``skip_choice`` / ``blank_choice``
        (a witness) still name only what a predicate modelled.
        """
        key = (item_id, skippable)
        if key not in self._answered_by_world:
            self._answered_by_world[key] = self._world_answered(item_id, skippable)
        return self._answered_by_world[key]

    def _world_answered(self, item_id: str, skippable: bool) -> BoolRef | None:
        if not self._answerable(item_id) or item_id in self._code_written_items():
            return None
        unanswered = []
        if self.item_details[item_id].get("preconditions"):
            if not skippable:
                return None
            # The same constant as the shared choice, by name, whether or not a
            # predicate registered it.
            unanswered.append(Bool(f"skipped@{item_id}", self.ctx))
        if self._blank_candidate(item_id):
            unanswered.append(Bool(f"blank@{item_id}", self.ctx))
        if not unanswered:
            return BoolVal(True, self.ctx)
        return Not(self._disjoin(unanswered))

    def skip_choice(self, item_id: str) -> BoolRef | None:
        """Whether ``item_id`` read as skipped anywhere, if any predicate
        modelled its skip (``_skipped_choice``): its one choice, or any of a
        code-written item's per-predicate choices. A witness reads it to report
        the item unasked."""
        return self._any_choice(item_id, self._fresh_skip_choices, self._skip_choices)

    def _any_choice(
        self, item_id: str, fresh: dict[str, list[BoolRef]], shared: dict[str, BoolRef]
    ) -> BoolRef | None:
        """``item_id``'s per-predicate choices then its shared one, disjoined;
        ``None`` when no predicate made either."""
        choices = list(fresh.get(item_id, []))
        if item_id in shared:
            choices.append(shared[item_id])
        return self._disjoin(choices) if choices else None

    def _blank_candidate(self, item_id: str) -> bool:
        """Whether a read of ``item_id`` gets a blank choice (#1784): a
        Question, whatever its control, a QuestionGroup, and a MatrixQuestion
        whose ``None`` states are modelled (``_matrix_has_choices``). Every
        channel can submit an item blank (owner decision on #1784)."""
        details = self.item_details.get(item_id)
        if details is None:
            return False
        if details.get("kind") == "MatrixQuestion":
            return self._matrix_has_choices(item_id)
        return details.get("kind") in ("Question", "QuestionGroup")

    def _blank_choice(self, item_id: str) -> BoolRef:
        """Whether ``item_id`` was shown and left blank (#1784), as the
        predicate being lowered sees it.

        A blank answer makes every leaf that reads it unknown at runtime
        (#1023), which ``_lower_kleene`` lowers around the leaf. It is one Bool
        per item (``blank@{id}``), a world variable like ``_skipped_choice``;
        its admissibility (``_blank_acceptance``) is in the domain base. An
        item a codeBlock writes gets a fresh choice per predicate (the write
        can answer it between two predicates), whose admissibility cannot join
        a base asserted before the predicate is compiled, so it is conjoined
        into the choice itself: ``And(blank@{id}#n, acceptance)``.
        """
        choice = self._predicate_blank.get(item_id)
        if choice is not None:
            return choice
        if item_id in self._code_written_items():
            accept = self._blank_acceptance(item_id) if self._built else None

            # ``accept`` is ``None`` while the build is still running (its
            # conditions only feed the dependency graph), or while the
            # acceptance is being computed (a cycle through postconditions); a
            # free choice is wider, never narrower.
            def mint() -> BoolRef:
                self._blank_count += 1
                symbol = Bool(f"blank@{item_id}#{self._blank_count}", self.ctx)
                self._fresh_blank_choices.setdefault(item_id, []).append(
                    symbol if accept is None else And(symbol, accept)
                )
                return symbol

            fresh = self._mint(mint)
            choice = fresh if accept is None else And(fresh, accept)
        else:
            choice = self._shared_blank_choice(item_id)
        self._predicate_blank[item_id] = choice
        return choice

    def _shared_blank_choice(self, item_id: str) -> BoolRef:
        choice = self._blank_choices.get(item_id)
        if choice is None:
            # ``@`` cannot occur in an item id, so no item or variable shares the name.
            choice = self._blank_choices[item_id] = Bool(f"blank@{item_id}", self.ctx)
        return choice

    def blank_choice(self, item_id: str) -> BoolRef | None:
        """Whether ``item_id`` read as blank anywhere, if any predicate
        modelled its blank (``_blank_choice``): its one choice, or any of a
        code-written item's per-predicate choices. A witness reads it to report
        the item ``None``."""
        return self._any_choice(item_id, self._fresh_blank_choices, self._blank_choices)

    def _enter_submission(self, item_id: str) -> tuple[dict[str, int], dict[str, ExprRef]]:
        """Point ``version_map`` at the versions ``item_id``'s own conditions
        read (``_runtime_versions``) and return the state it replaced, for
        ``_leave_submission``.

        An item's own conditions run before its own codeBlock (precondition,
        postcondition, then codeBlock), so they read every variable as it is
        when the walk reaches the item, never at the final version a compile
        after the build would otherwise see (#1838). A copy, because a phantom
        read seeds version 0 into the map it reads.
        """
        outer = (self.version_map, self._open_reads)
        if item_id not in self._runtime_version_cache:
            self._runtime_version_cache[item_id] = self._runtime_versions(item_id)
        versions, open_reads = self._runtime_version_cache[item_id]
        # A copy: a phantom read seeds version 0 into the map it reads.
        self.version_map, self._open_reads = dict(versions), open_reads
        return outer

    def _leave_submission(self, outer: tuple[dict[str, int], dict[str, ExprRef]]) -> None:
        self.version_map, self._open_reads = outer

    def _runtime_versions(self, item_id: str) -> tuple[dict[str, int], dict[str, ExprRef]]:
        """``(version map, variables read as a fresh Int)`` when the walk
        reaches ``item_id``.

        SSA versions are numbered in the build's order (``_submission_versions``),
        the walk's navigation order (``QMLTopology``) wherever it orders code
        state differently from the file (#1989, ``_build``); a build with a
        dependency cycle keeps file order, where an item a condition depends on
        can come first even when it is written later. So a variable reads the last version of
        the longest prefix of its versions whose writers (codeInit, or an item
        before ``item_id`` in navigation order; never its own codeBlock) all
        run first, in the same order as they run on the walk. A variable whose earlier writers are not such a prefix
        (some run after ``item_id``, a later one before it) has no version
        that is its value there, and reads a fresh unconstrained Int: wider,
        never a wrong constant. Before the build is complete the snapshot is
        all there is."""
        versions = dict(self._submission_versions[item_id])
        open_reads: dict[str, ExprRef] = {}
        position = self._navigation_index()
        here = position.get(item_id)
        if here is None:
            return versions, open_reads
        for var_name, history in self.version_history.items():
            ran = [
                context == "__init__" or (context != item_id and position.get(context, here) < here)
                for _, context in history
            ]
            prefix = ran.index(False) if False in ran else len(ran)
            # The chain is the build's order; it is the value only if those
            # writers also run in that order on the walk.
            walked = [position.get(context, -1) for _, context in history[:prefix] if context != "__init__"]
            if any(ran[prefix:]) or walked != sorted(walked):
                self._code_raise_count += 1
                # ``@`` cannot occur in an item id, so no item or variable shares the name.
                open_reads[var_name] = Int(f"open@{var_name}#{self._code_raise_count}", self.ctx)
            elif prefix:
                versions[var_name] = history[prefix - 1][0]
            else:
                versions.pop(var_name, None)
        return versions, open_reads

    def _navigation_index(self) -> dict[str, int]:
        """Each item's position in the walk's navigation order (the stable
        topological order ``QMLTopology`` gives ``FlowProcessor``), computed
        once from the complete dependency graph."""
        if self._navigation_positions is None:
            order = self.topology.get_topological_order()
            self._navigation_positions = {item: index for index, item in enumerate(order)}
        return self._navigation_positions

    @property
    def topology(self):
        """The questionnaire's ``QMLTopology`` over this builder's dependency
        graph, built once (``QMLEngine`` reads this one, so Kahn's order and
        its cycle warnings are computed a single time). Only after the build:
        the graph is complete then."""
        if not self._built:
            raise RuntimeError("the topology is read only after the StaticBuilder build completes")
        if self._topology is None:
            # Local import: ``askalot_qml.core`` imports the engine, which imports this module.
            from askalot_qml.core.qml_topology import QMLTopology

            self._topology = QMLTopology(self.state, self)
        return self._topology

    def _blank_acceptance(self, item_id: str) -> BoolRef | None:
        """Where ``item_id`` may be submitted blank (#1784): its effective
        postconditions (block, then item) accept its ``None``. ``None`` while
        it is being computed.

        The runtime evaluates an item's own postcondition with its own outcome
        excluded from the unknowns (``FlowProcessor._unanswered``), so a blank
        answer reads Python's ``None``: each postcondition is lowered as an
        acceptance (a raise waives, another item's blank waives its leaf) with
        the item's own reads skipped for certain (``_own_none``). ``q.outcome
        in [1, 2]`` refuses a blank, ``q.outcome > 1`` raises and admits it.
        A QuestionGroup's or matrix's own answer reads raise on its ``None``
        and waive (``_answer_list_reads``), so only a None test can refuse its
        blank. A Range
        or Textarea Question has no scalar the skip lowering can stand on, and
        a postcondition that does not lower is no refusal, so each admits a
        blank everywhere: wider, never narrower.

        The runtime checks the postconditions before the item's codeBlock
        runs, so a variable they read is the version current at submission
        (``_submission_versions``), as the build's own postcondition
        constraint reads it, not the final one a later compile would see.
        """
        if item_id in self._blank_acceptances:
            return self._blank_acceptances[item_id]
        self._blank_acceptances[item_id] = None
        parts: list[BoolRef] = []
        if item_id in self.item_vars or self._is_question_group(item_id) or item_id in self.matrices:
            outer = self._own_none
            self._own_none = item_id
            outer_versions = self._enter_submission(item_id)
            # The acceptance is computed once and shared by every compile that
            # reads it, so what its lowering mints belongs to no compile.
            outer_minting, self._minting = self._minting, None
            try:
                for condition in self.item_details[item_id]["postconditions"]:
                    predicate = condition.get("predicate", "")
                    if not predicate:
                        continue
                    lowered, _ = self._compile_predicate(predicate, item_id, "postcondition")
                    if lowered is None:
                        parts = []
                        break
                    parts.append(lowered)
            finally:
                self._minting = outer_minting
                self._own_none = outer
                self._leave_submission(outer_versions)
        accept = self._conjoin(parts)
        self._blank_acceptances[item_id] = accept
        return accept

    def _emit_blank_admissibility(self) -> None:
        """``Implies(blank@{id}, acceptance)`` for every blank-candidate item
        (``_blank_candidate``) whose own postconditions may refuse a blank,
        into the domain base, so every verdict sees it (``_blank_acceptance``).
        Code-written items carry it in each fresh choice instead
        (``_blank_choice``)."""
        for item_id in self.item_order:
            if not self._blank_candidate(item_id) or item_id in self._code_written_items():
                continue
            if not self.item_details[item_id]["postconditions"]:
                continue
            accept = self._blank_acceptance(item_id)
            if accept is not None:
                self.domain_constraints.append(Implies(self._shared_blank_choice(item_id), accept))

    def _answer_list_reads(
        self, tree: ast.AST, context: str, parents: dict[ast.AST, ast.AST]
    ) -> tuple[list[tuple[str, ast.AST]], list[ast.AST], set[int], set[str]]:
        """The answer-list reads of a predicate: one answer of a QuestionGroup
        (#184) or one cell of a MatrixQuestion (#1780), ``(reads that raise on
        a None list, reads that raise on an unanswered slot, ids of reads
        None-safe on an unanswered slot, items whose None test lowers)``.

        The list is ``None`` until answered: its gate skipped it, or it was
        shown and left blank. Skipped, subscripting its ``None`` raises
        whatever the operator, so a read raises on the item's skip choice
        (``_skipped_choice``) where it may be skipped
        (``_whole_answer_skippable``). Blank, the leaf that reads it is unknown
        (#1784): its blank choice, which ``_lower_kleene`` wraps around the
        leaf. Not for an item the predicate None-guards: its None test lowers
        to whichever of the two it has (``_answer_list_none``) and the reads it
        guards cannot raise.

        An answered list holds ``None`` in a slot left unanswered, read the
        #1769 way: None-safe where ``_none_safe_read`` says so, raising
        elsewhere. A Range answer's ``None.low`` raises whatever the operator.
        A read the model gives no choices (``_answer_cells``) needs none. A
        group answer or matrix cell read that reaches its comparison through a
        ternary branch is neither: ``None`` passes through untouched, so such a
        predicate is not lowered at all (``_slot_through_ternary``) and its
        coverage gap names the item.
        """
        list_raising: list[tuple[str, ast.AST]] = []
        slot_raising: list[ast.AST] = []
        slot_safe: set[int] = set()
        if not self.question_groups and not self.matrices:
            return list_raising, slot_raising, slot_safe, set()
        for node in ast.walk(tree):
            found = self._answer_read(node)
            if found is None or self._answer_cells(found[0]) is None:
                continue
            item_id = found[0]
            if (
                item_id not in self._none_guarded
                and not self._judged_on_answers(item_id, context)
                and self._whole_answer_skippable(item_id, context)
            ):
                list_raising.append((item_id, node))
            if not self._is_range_item(item_id) and self._none_safe_read(node, parents):
                slot_safe.add(id(node))
            elif not self._is_range_item(item_id) and self._slot_through_ternary(node, parents):
                raise _UnmodelledAnswerRead(item_id)
            else:
                slot_raising.append(node)
        none_tested = {
            found[0]
            for node in ast.walk(tree)
            if (found := none_test_of(node)) is not None
            and found[0] in self._none_guarded
            and self._answer_cells(found[0]) is not None
        }
        return list_raising, slot_raising, slot_safe, none_tested

    def _answer_cells(self, item_id: str) -> dict[tuple[int, ...], ExprRef] | None:
        """The cells of an answer-list item whose ``None`` states a predicate
        models (``_answer_list_reads``): a QuestionGroup's where its reads
        lower (``_group_cells``); a MatrixQuestion's in a condition (not a
        codeBlock ``if`` guard or assigned value: ``_CodeReads`` models scalar
        Question reads only), outside a Roster or capped Group and when no
        codeBlock writes it. Anywhere else a matrix cell lowers in-domain,
        with no choice."""
        if self._is_question_group(item_id):
            return self._group_cells(item_id)
        if (
            item_id not in self.matrices
            or not self._lowering_predicate
            or not self._model_blank
            or not self._matrix_has_choices(item_id)
        ):
            return None
        return self.item_cells.get(item_id)

    def _matrix_has_choices(self, item_id: str) -> bool:
        """A matrix outside a Roster or capped Group that no codeBlock writes:
        one cell variable stands for its answer everywhere, so its ``None``
        states are modelled. A scoped matrix has no cells per iteration
        or draw, and a written one can change between two conditions."""
        return not self._is_scoped(item_id) and item_id not in self._code_written_items()

    def _judged_on_answers(self, item_id: str, context: str) -> bool:
        """Whether an answer-list read is the item's own, in its own condition
        as the classifier judges it: on real answers only, so the read does not
        raise on a ``None`` list (owner decision on #1839, 2026-10-24). A blank
        is waived at runtime with a ``critical`` warning that drops the survey
        from datasets, so a check that refuses every real answer is INFEASIBLE
        for a QuestionGroup or MatrixQuestion as for a scalar Question
        (``_may_be_skipped``). Admitting a blank (``_blank_acceptance``) and a
        codeBlock ``if`` guard still read the Python ``None``; a None test on
        the item keeps its choice (``_whole_answer_skippable``), as a scalar's
        keeps its free ``answered``."""
        return item_id == context and item_id != self._own_none and self._model_blank

    def _whole_answer_skippable(self, item_id: str, context: str) -> bool:
        """Whether an answer-list read in the predicate being lowered may see
        the whole list ``None`` the Python way, so a subscript raises on it:
        a gated item (its gate skipped it), the item's own reads in
        its own condition (the runtime excludes the condition's item from the
        unknowns, so a blank one is Python's ``None`` there too), and a
        codeBlock ``if`` guard, which runs plain Python (``_model_blank``).
        Anywhere else a ``None`` list is one left blank, whose leaf is unknown
        instead (``_blank_choice``)."""
        if item_id == context or not self._model_blank:
            return True
        details = self.item_details.get(item_id)
        return bool(details and details.get("preconditions"))

    @staticmethod
    def _slot_through_ternary(node: ast.AST, parents: dict[ast.AST, ast.AST]) -> bool:
        """Whether ``node`` is (inside) a branch of a ternary, so its value,
        ``None`` included, flows on unchanged."""
        child, parent = node, parents.get(node)
        while parent is not None:
            if isinstance(parent, ast.IfExp) and parent.test is not child:
                return True
            child, parent = parent, parents.get(parent)
        return False

    def _slot_of(self, read: ast.AST, local_bindings: dict[str, int]) -> BoolRef | None:
        """The unanswered choice of the slot an answer-list read names;
        ``None`` when an index does not resolve."""
        found = self._answer_read(read)
        if found is None:
            return None
        index = [self._resolve_int_const(node, local_bindings) for node in found[1]]
        if any(i is None for i in index):
            return None
        return self._slot_choice(found[0], *index)

    def _slots_a_read_may_take(self, read: ast.AST) -> list[BoolRef]:
        """The slots a read may name: its literal one, or, along an index a
        comprehension variable picks, every slot of the group or matrix."""
        found = self._answer_read(read)
        if found is None:
            return []
        item_id, nodes = found
        details = self.item_details[item_id]
        extents = (
            [details.get("questions_len") or 0]
            if self._is_question_group(item_id)
            else [details.get("rows_len") or 0, details.get("cols_len") or 0]
        )
        axes = []
        for node, extent in zip(nodes, extents, strict=True):
            i = self._resolve_int_const(node, {})
            axes.append([i] if i is not None else range(extent))
        return [self._slot_choice(item_id, *index) for index in itertools.product(*axes)]

    def _slot_choice(self, item_id: str, *index: int) -> BoolRef:
        """Whether answer ``index`` of QuestionGroup ``item_id`` (one index),
        or cell ``(row, col)`` of MatrixQuestion ``item_id``, is unanswered:
        a free Bool like ``_skipped_choice``, one per slot (an item a codeBlock
        writes gets none, ``_answer_cells``)."""
        key = (item_id, *index)
        choice = self._slot_choices.get(key)
        if choice is None:
            # ``@`` cannot occur in an item id, so no item or variable shares the name.
            name = "@".join(["unanswered", item_id, *(str(i) for i in index)])
            choice = self._slot_choices[key] = Bool(name, self.ctx)
        return choice

    def slot_choice(self, item_id: str, *index: int) -> BoolRef | None:
        """Whether a QuestionGroup answer ``(i)`` or a matrix cell ``(r, c)``
        read as unanswered anywhere, if any predicate modelled it
        (``_slot_choice``). A witness reads it to report the slot ``None``."""
        return self._slot_choices.get((item_id, *index))

    def _stored_outcomes(self, tree: ast.AST) -> list[str | None]:
        """The base name of every outcome store in ``tree``: ``X.outcome`` as a
        target of any kind (``=``, ``+=``, annotated, a tuple or ``for``
        target), or one answer of it, ``X.outcome[i]`` (#184). ``None`` for a
        store whose base is no bare name."""
        names: list[str | None] = []
        for node in ast.walk(tree):
            if isinstance(node, ast.Subscript) and isinstance(node.ctx, ast.Store):
                name, _ = self._outcome_subscript(node)
                if name is not None:
                    names.append(name)
            elif isinstance(node, ast.Attribute) and node.attr == "outcome" and isinstance(node.ctx, ast.Store):
                names.append(outcome_ref_name(node))
        return names

    def _code_written_items(self) -> set[str]:
        """Items whose outcome codeInit or a codeBlock stores to (any ``X.outcome``
        target: ``=``, ``+=``, a tuple or ``for`` target, or one answer of it,
        ``X.outcome[i] = v``), computed once: their
        None-ness can change mid-walk. A store through anything but an item id
        (``alias.outcome = 1``) could write any item, so then every item counts."""
        if self._code_written is None:
            written: set[str] = set()
            for code in [self.state.get_code_init() or ""] + [
                item.get("codeBlock") or "" for item in self.state.get_all_items()
            ]:
                tree = self._parsed(code, "exec")
                if tree is None:
                    continue
                for name in self._stored_outcomes(tree):
                    if name not in self.item_details:
                        self._code_written = set(self.item_details)
                        return self._code_written
                    written.add(name)
            self._code_written = written
        return self._code_written

    def get_constraints(self) -> list[BoolRef]:
        """Get all Z3 constraints."""
        return self.constraints

    def _resolve_item_dependencies(self, node: str, visited: set[str]) -> set[str]:
        """Get all item dependencies, following variable paths transitively.

        Walks the dependency graph, following var: nodes to find the ultimate
        item dependencies. For example:
        - q2 → var:score → q1 resolves to q2 → q1

        Args:
            node: Starting node (item_id or "var:variable_name")
            visited: Set of already visited nodes (to prevent infinite loops)

        Returns:
            Set of item IDs that this node ultimately depends on
        """
        if node in visited:
            return set()
        visited.add(node)

        item_deps = set()
        for dep in self.dependency_graph.get(node, set()):
            if dep.startswith("var:"):
                # Follow var: edges with a SHARED visited set (not a per-branch
                # copy). The top-level return is the union of reachable items:
                # once a var node is explored, its full contribution is unioned
                # up to the root caller, so a later branch re-reaching it adds
                # nothing new. Sharing the set turns the walk from O(depth^2)
                # copies into a single O(V+E) DFS while returning the same set.
                item_deps.update(self._resolve_item_dependencies(dep, visited))
            else:
                # Direct item dependency
                item_deps.add(dep)
        return item_deps

    def get_item_dependencies(self) -> dict[str, set[str]]:
        """Get item-to-item dependencies (resolved through variables).

        Returns a dictionary mapping each item to the set of items it depends on,
        with transitive dependencies through variables resolved.

        For example, if:
        - q1 has codeBlock: score = q1.outcome
        - q2 has precondition: score > 5

        Then get_item_dependencies() returns {'q2': {'q1'}, ...} because q2
        depends on q1 transitively through var:score.

        Includes Textarea items (no Z3 var) when they carry dependency_graph
        entries — e.g. a Textarea inner roster item inheriting iterateOver
        deps from its Roster. Topology needs these entries to compute
        a correct evaluation order even when the item itself isn't constrained.
        """
        item_ids = self._dependency_item_ids()
        result = self._dependency_order_resolution(item_ids)
        accumulators = self._accumulators_of(result)
        if not accumulators:
            return result
        return self._file_order_dependencies(item_ids, accumulators)

    def _dependency_item_ids(self) -> set[str]:
        """Union of items with Z3 vars and items registered in dependency_graph
        (the latter covers Textarea items that get deps via roster inheritance
        or precondition/codeBlock references), without the ``var:`` nodes."""
        item_ids = set(self.item_vars.keys()) | set(self.dependency_graph.keys())
        return {i for i in item_ids if not i.startswith("var:")}

    def _dependency_order_resolution(self, item_ids: set[str]) -> dict[str, set[str]]:
        """Every item's dependencies with each variable read through all its writers."""
        result = {}
        for item_id in item_ids:
            deps = self._resolve_item_dependencies(item_id, set())
            # An item cannot depend on itself. Direct self-references in
            # preconditions/postconditions are already filtered, but indirect
            # paths through variables can create false self-dependencies
            # (e.g., postcondition reads var:x, codeBlock writes var:x with
            # self.outcome → transitive self-dep). This is a false positive
            # because the runtime lifecycle is: precondition → outcome →
            # postcondition → codeBlock. A postcondition CAN reference any
            # variable, but it sees the prior value — the current item's
            # codeBlock hasn't run yet, so it cannot affect the postcondition.
            deps.discard(item_id)
            result[item_id] = deps
        return result

    def _file_positions(self) -> dict[str, int]:
        """Each item's index in file order (the order ``QMLTopology`` breaks ties by)."""
        return {item["id"]: index for index, item in enumerate(self.state.get_all_items()) if item.get("id")}

    def _variable_readers(self, var_name: str) -> set[str]:
        """Items whose own or block conditions (or Roster ``iterateOver``) read ``var_name``."""
        node = f"var:{var_name}"
        return {
            node_id
            for node_id, deps in self.dependency_graph.items()
            if not node_id.startswith("var:") and node in deps
        }

    def _variable_item_writers(self, var_name: str) -> list[str]:
        """Items whose codeBlock assigns ``var_name`` (codeInit excluded), each once."""
        writers: list[str] = []
        for context, _ in self._variable_writers.get(var_name, []):
            if self._item_code(context) and context not in writers:
                writers.append(context)
        return writers

    def _accumulators_of(self, resolved: dict[str, set[str]]) -> set[str]:
        """Variables read in a circle under dependency order: accumulators (#1891, D91).

        A variable is one when an item that both reads it in a condition (its
        own or its block's) and writes it in its codeBlock lies on a common
        dependency cycle of ``resolved`` (one strongly connected component)
        with an item writing it LATER in file order, the founding article's
        block counter being the canonical case: every item's codeBlock
        increments ``negative_count`` and the block precondition reads it, so
        every item would wait for every other. Only there is "before"
        ambiguous, and D91 settles it with file order: a reader sees the
        writers that precede it in the file. A variable read only after its
        writers, or read before a later writer with no cycle (the walk then
        asks the writer first), is not one and keeps dependency order, so a
        questionnaire without a cycle resolves through every writer; nor
        is a variable only read by items that do not write it, so two items
        each gated on what the other writes stay a ``dependency_cycle``.
        """
        if not self._variable_writers:
            return set()
        component = self._strongly_connected_components(resolved)
        position = self._file_positions()
        accumulators: set[str] = set()
        for var_name in self._variable_writers:
            writers = self._variable_item_writers(var_name)
            # Only an item that reads AND writes it makes a variable an
            # accumulator: two items each reading what only the other writes
            # (``pa`` / ``pb``) is a real cycle and stays one.
            for reader in self._variable_readers(var_name) & set(writers):
                here = position.get(reader)
                if here is None or reader not in component:
                    continue
                if any(
                    position.get(writer, -1) > here and component.get(writer) == component.get(reader)
                    for writer in writers
                ):
                    accumulators.add(var_name)
                    break
        return accumulators

    @staticmethod
    def _strongly_connected_components(graph: dict[str, set[str]]) -> dict[str, int]:
        """Tarjan's algorithm, iterative: each node's component number.

        Only nodes that belong to a component of two or more get a number, so
        a node missing from the result sits on no cycle."""
        index: dict[str, int] = {}
        low: dict[str, int] = {}
        on_stack: set[str] = set()
        stack: list[str] = []
        component: dict[str, int] = {}
        counter = 0
        for root in sorted(graph):
            if root in index:
                continue
            work = [(root, iter(sorted(graph.get(root, ()))))]
            index[root] = low[root] = counter
            counter += 1
            stack.append(root)
            on_stack.add(root)
            while work:
                node, successors = work[-1]
                advanced = False
                for nxt in successors:
                    if nxt not in graph:
                        continue
                    if nxt not in index:
                        index[nxt] = low[nxt] = counter
                        counter += 1
                        stack.append(nxt)
                        on_stack.add(nxt)
                        work.append((nxt, iter(sorted(graph.get(nxt, ())))))
                        advanced = True
                        break
                    if nxt in on_stack:
                        low[node] = min(low[node], index[nxt])
                if advanced:
                    continue
                work.pop()
                if work:
                    parent = work[-1][0]
                    low[parent] = min(low[parent], low[node])
                if low[node] == index[node]:
                    members = []
                    while True:
                        member = stack.pop()
                        on_stack.discard(member)
                        members.append(member)
                        if member == node:
                            break
                    if len(members) > 1:
                        number = len(set(component.values()))
                        for member in members:
                            component[member] = number
        return component

    def _file_order_dependencies(self, item_ids: set[str], accumulators: set[str]) -> dict[str, set[str]]:
        """Item dependencies when ``accumulators`` are read in file order (D91).

        A reader of an accumulator depends only on its writers before the
        reader in file order (codeInit always runs first); a writer's own
        reads resolve at the writer's position; every other variable resolves
        through all its writers, as ``_resolve_item_dependencies`` does.

        Each item writer of an accumulator also waits for every earlier item
        that reads or writes it (an ordering edge), so the walk's topological
        order keeps file order among them even where another dependency would
        let Kahn's order ask a later writer first: a reader then never sees a
        later writer's update at runtime, and its versions in Z3 are the file
        order prefix ``_runtime_versions`` reads. A reader that needs a later
        writer's ANSWER as well closes a real cycle and stays refused.
        """
        position = self._file_positions()
        result: dict[str, set[str]] = {}
        for item_id in item_ids:
            here = position.get(item_id, len(position))
            found: set[str] = set()
            seen: set[tuple[str, int]] = set()
            stack = [(dep, here) for dep in self.dependency_graph.get(item_id, ())]
            while stack:
                dep, bound = stack.pop()
                if (dep, bound) in seen:
                    continue
                seen.add((dep, bound))
                if not dep.startswith("var:"):
                    found.add(dep)
                    continue
                var_name = dep[len("var:"):]
                ordered = var_name in accumulators
                for context, value_deps in self._variable_writers.get(var_name, []):
                    at = -1
                    if context != "__init__":
                        at = position.get(context, len(position))
                        if ordered and at >= bound:
                            continue
                        if self._item_code(context):
                            found.add(context)
                    stack.extend((value_dep, at) for value_dep in value_deps)
            found.discard(item_id)
            result[item_id] = found

        for var_name in sorted(accumulators):
            participants = self._variable_readers(var_name) | set(self._variable_item_writers(var_name))
            for writer in self._variable_item_writers(var_name):
                at = position.get(writer, len(position))
                result.setdefault(writer, set()).update(
                    other for other in participants if position.get(other, len(position)) < at
                )
        return result

    def accumulator_variables(self) -> set[str]:
        """Variables read in file order (``_accumulators_of``), for the
        reachability model; only after the build, when the graph is complete."""
        if not self._built:
            raise RuntimeError("accumulators are read only after the StaticBuilder build completes")
        if self._accumulators is None:
            self._accumulators = self._accumulators_of(
                self._dependency_order_resolution(self._dependency_item_ids())
            )
        return self._accumulators

    def get_dependency_graph(self) -> dict[str, set[str]]:
        """Get full dependency graph including variable nodes.

        Returns the raw dependency graph with both item nodes and var: nodes.
        Useful for debugging and visualization.
        """
        return {k: v.copy() for k, v in self.dependency_graph.items()}

    def get_all_z3_vars(self) -> dict[str, ExprRef]:
        """Get all Z3 variables (SSA versions, scalar item outcomes, Range ends, matrix cells).

        Every entry is keyed by its Z3 name (``var@{name}@{n}``, ``item_{id}``,
        ``item_{id}@lo`` / ``@hi``, ``item_{id}@{r}@{c}``, …), which no two
        variables share (#1783, #1798). The ``z3_vars`` / ``item_vars`` keys
        would collide: variable ``q`` version 0 and Question ``q_0`` are both
        ``q_0``.
        """
        all_vars = {str(var): var for var in self.z3_vars.values()}
        all_vars.update((str(var), var) for var in self.item_vars.values())
        for pair in self.item_pairs.values():
            for end in pair:
                all_vars[str(end)] = end
        for cells in self.item_cells.values():
            for cell_var in cells.values():
                all_vars[str(cell_var)] = cell_var
        return all_vars

    def _conjoin(self, exprs: list[BoolRef]) -> BoolRef:
        """Conjoin a list of Z3 booleans into one expression.

        Empty → ``BoolVal(True, ctx)`` (the identity of conjunction); a single
        element is returned as-is (no redundant ``And`` wrapper); otherwise
        ``And(*exprs)``. Centralizes the repeated empty/single/many shape used
        by ``get_domain_base`` / ``get_full_base`` / ``compile_conditions``.
        """
        if not exprs:
            return BoolVal(True, self.ctx)
        if len(exprs) == 1:
            return exprs[0]
        return And(*exprs)

    @staticmethod
    def _disjoin(exprs: list[BoolRef]) -> BoolRef:
        """Disjoin a non-empty list of Z3 booleans: a single element as-is,
        otherwise ``Or(*exprs)``. Callers handle the empty list themselves."""
        return exprs[0] if len(exprs) == 1 else Or(*exprs)

    def get_domain_base(self) -> BoolRef:
        """
        Get domain-only base constraint B as defined in the thesis.

        B := ∧_i D_i(S_i) where D_i(S_i) are domain constraints:
        - min/max for Editbox/Slider controls
        - enumeration for Radio/Dropdown controls
        - a bitmask (sum of distinct keys) for Checkbox controls

        This is the correct B for use in:
        - Global validation: F = B ∧ ∧(P_i ⇒ Q_i)
        - Path-based validation: A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)

        Per-item *precondition reachability* uses ``get_reachability_base``
        instead (B plus frozen-variable constants); ``get_full_base`` drives the
        postcondition / global-Q checks.
        """
        return self._conjoin(self.domain_constraints)

    def _frozen_variable_names(self) -> set[str]:
        """Names of *frozen* variables: assigned in codeInit and never
        reassigned by any codeBlock.

        The primary oracle is ``version_history`` — every genuine SSA assignment
        records its ``context_id`` there (``"__init__"`` for codeInit, else the
        owning item id). A variable is a frozen candidate iff it has at least one
        recorded assignment and every one is a codeInit assignment: it then holds
        its initializer constant for the entire run. A single codeBlock ``Name``
        assignment (any non-``__init__`` context) un-freezes it — the variable is
        *produced* and its runtime value is not statically a constant.

        SSA only records plain ``ast.Name`` assignment targets, so a codeInit
        variable a codeBlock rebinds ONLY through a tuple/list unpack, for-loop
        target, walrus, or ``with ... as`` leaves ``version_history`` all
        ``__init__`` and would look frozen — pinning a stale constant into
        ``get_reachability_base`` and misclassifying its gates. To close that,
        any name bound by any codeBlock (``_all_bound_code_names`` excluding
        codeInit) is additionally excluded: it too is produced, not frozen.
        """
        codeblock_bound = self._all_bound_code_names(include_init=False)
        return {
            var_name
            for var_name, history in self.version_history.items()
            if history
            and all(context_id == "__init__" for _, context_id in history)
            and var_name not in codeblock_bound
        }

    def get_reachability_base(self) -> BoolRef:
        """Reachability base for precondition classification: B ∧ frozen-var
        constants.

        Domain base B conjoined with the codeInit constant constraints of every
        *frozen* variable (see ``_frozen_variable_names``). A frozen variable is
        a compile-time constant for the whole run, so a gate referencing it is
        statically decidable — ``get_domain_base`` alone leaves it a free symbol,
        which is why a permanently-false gate (e.g. ``has_partner == 1`` over a
        frozen ``has_partner = 0``) would classify CONDITIONAL under the
        domain-only base.

        Only frozen variables contribute: a *produced* variable (any codeBlock
        assignment) keeps a free codeInit version so its gate stays CONDITIONAL,
        exactly as before. The constants themselves already live in
        ``codeblock_constraints`` (hence the full base) — this accessor conjoins
        only the frozen subset onto the domain base, leaving ``get_full_base``
        untouched.
        """
        frozen = self._frozen_variable_names()
        frozen_constraints: list[BoolRef] = []
        for var_name in frozen:
            frozen_constraints.extend(self.codeinit_constant_constraints.get(var_name, []))
        return self._conjoin(
            list(self.domain_constraints) + frozen_constraints + self._accumulator_reachability()
        )

    def _accumulator_reachability(self) -> list[BoolRef]:
        """Each accumulator version as its writers produce it, for precondition
        reachability (#1891): a counter-bounded gate is verified, so the
        article's ``negative_count < 3`` is ALWAYS on items 1–3, CONDITIONAL
        from item 4, and ``negative_count < 0`` is NEVER everywhere.

        A precondition reads an accumulator at the file-order prefix its item
        sees (``_runtime_versions``; ``_file_order_dependencies`` keeps the
        walk in that order). Version ``x@j`` written by item ``W`` is
        ``If(ran@W, value, x@before)``, ``x@before`` being the version at
        ``W``'s submission: a skipped item's codeBlock does not run, so
        ``ran@W`` is a free Bool for an item with any effective precondition
        and True for an ungated one; codeInit versions are their constants.
        Only for an accumulator whose item writers are all plain items (no
        Roster, capped-Group or otherwise conditionally present writer, whose
        codeBlock runs per iteration or per draw) and that no codeBlock the
        build leaves unlowered assigns or that a codeBlock deletes
        (``_unmodelled_writers``, a ``del``): any other keeps its free versions, wider,
        never a false NEVER. A value that reads ANOTHER accumulator its writer
        takes no part in is left free too: the codeBlock read that accumulator
        at its file-order version, but nothing keeps the walk in file order
        between that writer and the other accumulator's writers, so the version
        it read need not be the one the walk gives it. Other produced variables
        stay out: their verdicts do not move. Computed once, after the build.
        """
        if not self._built:
            return []
        if self._accumulator_constraints is not None:
            return self._accumulator_constraints
        accumulators = self.accumulator_variables()
        participants = {
            name: self._variable_readers(name) | set(self._variable_item_writers(name)) for name in accumulators
        }
        constraints: list[BoolRef] = []
        for var_name in sorted(accumulators):
            if self._unmodelled_writers(var_name) or not all(
                self._plain_writer(writer) for writer in self._variable_item_writers(var_name)
            ):
                continue
            for name, version, context, value, deps in self._assignment_values:
                if name != var_name:
                    continue
                current = self.z3_vars[_ssa_key(var_name, version)]
                if value is not None and value.sort() != current.sort():
                    value = None
                if value is not None and context != "__init__" and any(
                    dep.startswith("var:")
                    and dep[len("var:"):] in accumulators
                    and dep[len("var:"):] != var_name
                    and context not in participants[dep[len("var:"):]]
                    for dep in deps
                ):
                    value = None
                if context == "__init__":
                    if value is not None:
                        constraints.append(current == value)
                    continue
                before_version = self._submission_versions.get(context, {}).get(var_name)
                before = (
                    self.z3_vars.get(_ssa_key(var_name, before_version)) if before_version is not None else None
                )
                constraints.extend(_gated_write(current, value, before, self._writer_ran(context)))
        self._accumulator_constraints = constraints
        return constraints

    def _unmodelled_writers(self, var_name: str) -> list[str]:
        """Items whose codeBlock changes ``var_name`` in a way no SSA version
        records: a codeBlock binding it that the build did not lower (every
        item's is lowered since #2003, a Textarea's included, so this is a
        safety net for any writer a later change leaves out), or any
        codeBlock deleting it (``del x`` unbinds it, so a later read raises,
        while the model keeps the previous version). The model cannot see such
        a change, so an accumulator it touches is left open, never bounded."""
        modelled = set(self._variable_item_writers(var_name))
        unseen: list[str] = []
        for item in self.state.get_all_items():
            item_id, code = item.get("id"), item.get("codeBlock")
            if not item_id or not code:
                continue
            tree = self._parsed(code, "exec")
            if tree is None:
                continue
            deleted = any(
                isinstance(node, ast.Name) and isinstance(node.ctx, ast.Del) and node.id == var_name
                for node in ast.walk(tree)
            )
            if deleted or (item_id not in modelled and var_name in self._collect_leaking_bound_names(tree)):
                unseen.append(item_id)
        return unseen

    def _plain_writer(self, item_id: str) -> bool:
        """An item asked at most once per walk: not a Roster or capped-Group member."""
        item = self.state.get_item(item_id) or {}
        return not (
            self.is_conditionally_present(item_id)
            or item.get("_roster_block_id")
            or item.get("_group_block_id")
        )

    def _writer_ran(self, item_id: str) -> BoolRef:
        """Whether ``item_id``'s codeBlock ran: True for an ungated item, else a
        free choice (its gate may skip it, and then its codeBlock does not run)."""
        if not self.item_details.get(item_id, {}).get("preconditions"):
            return BoolVal(True, self.ctx)
        # ``@`` cannot occur in an item id, so no item or variable shares the name.
        return Bool(f"ran@{item_id}", self.ctx)

    def get_frozen_variable_gates(self) -> dict[str, list[str]]:
        """Frozen variables that GATE logic: those read by ≥1 predicate.

        A frozen variable (``_frozen_variable_names``: assigned in codeInit,
        never reassigned by any codeBlock) is a compile-time constant, so any
        precondition/postcondition referencing it is statically decided — always
        true or always false — while looking conditional. Returns
        ``{var_name: [location_id, ...]}`` for every frozen variable named in at
        least one item- or block-level predicate, where each ``location_id`` is
        the owning item id (or the block id for a block-level condition).

        Structural only — no solver call. The polarity (always-true vs
        always-false) is irrelevant to the defect: either way the gate enforces
        nothing conditional, so the lint fires symmetrically. Precondition
        reachability (``get_reachability_base``) already CONSUMES the frozen
        constants to classify the always-false gates NEVER; this method is the
        source for the corresponding root-cause lint the issue channel emits.

        Scope: a frozen variable read ONLY inside codeBlocks (never in a
        predicate) is a plain constant, not a decided gate, and is excluded — a
        codeBlock-only dead constant is the write-only / pass-through hygiene
        lints' concern, not this one.
        """
        frozen = self._frozen_variable_names()
        if not frozen:
            return {}

        gates: dict[str, list[str]] = {}

        def _scan(location_id: str, conditions: list[dict[str, Any]] | None) -> None:
            for cond in conditions or []:
                predicate = cond.get("predicate", "")
                if not predicate:
                    continue
                tree = self._parsed(predicate, "eval")
                if tree is None:
                    continue
                names = {n.id for n in ast.walk(tree) if isinstance(n, ast.Name)}
                for var_name in frozen & names:
                    locs = gates.setdefault(var_name, [])
                    if location_id not in locs:
                        locs.append(location_id)

        # Block-level conditions stay on the block (R25); attribute to block id.
        for block in self.state.get_blocks():
            block_id = block.get("id", "")
            _scan(block_id, block.get("precondition"))
            _scan(block_id, block.get("postcondition"))
        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue
            _scan(item_id, item.get("precondition"))
            _scan(item_id, item.get("postcondition"))
        return gates

    def get_full_base(self) -> BoolRef:
        """
        Get full base constraint B_full = B ∧ codeblock_constraints.

        This includes:
        - Domain constraints D_i(S_i) from get_domain_base()
        - CodeBlock constraints from codeBlock assignments (SSA)

        Does NOT include precondition/postcondition implications from self.constraints,
        as those are what we're validating against.

        Use this for postcondition validation when postconditions reference
        computed variables (not just item outcomes). The codeBlock constraints
        establish the relationship between computed variables and item outcomes,
        enabling proper bounds checking.

        Example: If var1 = q1.outcome + q2.outcome (from codeBlocks),
        and q1 ∈ [0,10], q2 ∈ [10,20], then var1 ∈ [10,30].
        Without codeBlock constraints, var1 would be unconstrained.
        """
        all_constraints = list(self.domain_constraints) + list(self.codeblock_constraints)
        return self._conjoin(all_constraints)

    def compile_conditions(
        self,
        item_id: str,
        conditions: list[dict[str, Any]],
        *,
        kind: ConditionKind,
        code_guard: bool = False,
    ) -> BoolRef:
        """The conjunction of the conditions that lowered (see :meth:`compile_conditions_exactly`).

        Records no coverage gap: a caller that discards exactness may compile a
        condition that is not ``item_id``'s own (the ``uninitialized_read`` lint
        compiles a codeBlock ``if`` guard), which would land as a gap against the
        item's own condition of the same index.

        ``code_guard`` compiles a codeBlock ``if`` test rather than a
        condition: a codeBlock runs plain Python, where a blank answer is
        ``None`` and not unknown, so no blank is modelled (#1784). The guard
        still sees a skip but reads a blank item in-domain, unlike the
        assignments it guards (``_CodeReads``, #1776).
        """
        return self._compile_conditions(
            item_id, conditions, kind, record_wide=False, blank=not code_guard
        )[0]

    def compile_conditions_exactly(
        self, item_id: str, conditions: list[dict[str, Any]], *, kind: ConditionKind
    ) -> tuple[BoolRef, bool]:
        """``(conjunction of the conditions that lowered, whether every one did)``.

        ``kind`` is ``"precondition"`` or ``"postcondition"``: a read that raises
        on a skipped item's None fails a precondition and waives a postcondition
        (#1775), so the two lower it differently, and so does a leaf reading a
        blank answer (#1784): a precondition lowers to its truth, a
        postcondition to its acceptance (see :meth:`compile_postcondition_truth`
        for the truth of a postcondition).

        A condition Z3 cannot express lowers to ``None`` and is left out of the
        conjunction, and one whose raise on a skipped item the model cannot
        place on a condition leaf (``_place_raises``: a read through a call, a
        container, a subscript, a ternary or a comprehension) lowers wide
        (#1775, #1779), so the formula is
        WIDER than the real one whenever the flag is ``False``. Its consumers
        must then refuse any verdict that only a narrower formula could prove: ``ItemClassifier`` claims no ALWAYS
        precondition and no TAUTOLOGICAL / globally-true postcondition on an
        inexact formula (#1164), while NEVER and INFEASIBLE, which a wider
        formula still proves, stand. A wide condition is recorded as a coverage
        gap carrying ``wide_items`` here, so the withheld verdict surfaces as an
        ``inexact_condition`` warning (#1815). Where an inexact P is an ASSUMPTION rather
        than the thing classified, see :meth:`item_implication`.
        """
        return self._compile_conditions(item_id, conditions, kind, record_wide=True)

    def compile_postcondition_truth(self, item_id: str, conditions: list[dict[str, Any]]) -> BoolRef:
        """The postconditions all evaluate True (not merely accepted).

        TAUTOLOGICAL needs truth, not acceptance (#1784): a postcondition that
        holds only because a blank leaf or a raise waived it is not one the
        answer satisfies. Being True is what a precondition lowers to (an
        unknown leaf or a raise is not True), so the postconditions are lowered
        under the precondition rule, in the owner's context.

        Its exactness is the acceptance's (:meth:`compile_conditions_exactly`):
        both are exact exactly when every raise is placed (``_place_raises``
        does not depend on the kind). Records no
        gap; the acceptance records the postcondition's own.
        """
        return self._compile_conditions(item_id, conditions, "precondition", record_wide=False)[0]

    def _compile_conditions(
        self,
        item_id: str,
        conditions: list[dict[str, Any]],
        kind: ConditionKind,
        *,
        record_wide: bool,
        blank: bool = True,
    ) -> tuple[BoolRef, bool]:
        """The body of :meth:`compile_conditions_exactly`; ``record_wide`` records
        each wide condition as a ``wide_items`` coverage gap of ``item_id``;
        ``blank`` models blank answers (``_lower_kleene``).

        The lowering is memoised once the build is complete (#2246), because
        the classifier, the lints, the guard tree and the Global and
        Path-based formulas each compile the same item's conditions, and the
        lowering is the costly part. After the build the lowering depends only
        on the key (``_compiled_conditions``): the versions an item's own
        conditions read are fixed per item (``_enter_submission``), any other
        compile reads the final ones, and the shared choices are one per item.
        What a compile mints fresh (``_mint``: ``answered@X#n``, a code-written
        item's ``skipped@`` / ``blank@`` / ``text@`` and the ``loose@`` pair)
        is minted again on every hit and substituted into the cached formula,
        so each compile answers a formula over its own fresh symbols, as an
        uncached compile does, and two compiles conjoined stay independent.
        Only a top-level compile is cached, never one made while another
        predicate is being lowered. A hit still records the gaps when
        ``record_wide`` asks for them (wide items, undecided reads, a fault
        while lowering), so a ``record_wide=False`` compile that filled the
        cache first never hides one (``_record_coverage_gap`` is
        de-duplicated, so a repeat records nothing twice). The text model's
        shared symbols (``str@`` per term and literal set, ``eq@``, an answer's
        ``stored@`` Int) are one per builder, like the item Ints they stand
        beside, so they are kept; only the fresh ``str@#n`` of an open read is
        minted (``_mint``)."""
        _require_condition_kind(kind)
        predicates = tuple(condition.get("predicate", "") for condition in conditions)
        key = (item_id, predicates, kind, blank)
        cacheable = self._built and not self._lowering_predicate
        cached = self._compiled_conditions.get(key) if cacheable else None
        if cached is None:
            outer_minting = self._minting
            if cacheable:
                self._minting = []
            try:
                formula, exact, gaps = self._lower_conditions(item_id, predicates, kind, blank)
                minted = tuple(self._minting) if cacheable else ()
            finally:
                self._minting = outer_minting
            if cacheable:
                self._compiled_conditions[key] = (formula, exact, gaps, minted)
        else:
            formula, exact, gaps, minted = cached
            formula = self._remint(formula, minted)
        if record_wide:
            for idx, wide, undecided, failed in gaps:
                if failed:
                    # A fault in the lowering is a skipped condition, never a silent one.
                    self._record_coverage_gap(item_id, kind, idx, ["Error"])
                else:
                    # Recorded where exactness is decided, so every owner the
                    # classifier judges is covered, Textarea items included (the
                    # build pass skips them): a withheld verdict is never silent
                    # (#1815), and neither is a comparison with text left
                    # undecided (``_note_undecided``).
                    self._record_coverage_gap(item_id, kind, idx, [], wide_items=wide, undecided_reads=undecided)
        return formula, exact

    def _mint(self, make: Callable[[], Any]) -> Any:
        """A symbol (or a tuple of them) a lowering mints fresh, made by
        ``make``, which also keeps its bookkeeping (``_answered_minted``,
        ``_fresh_skip_choices``, ``_fresh_blank_choices``). While a cached
        compile lowers (``_compile_conditions``) the maker is kept with what
        it made, so a cache hit makes its own (``_remint``)."""
        made = make()
        if self._minting is not None:
            self._minting.append((made, make))
        return made

    def _remint(self, formula: BoolRef, minted: tuple[tuple[Any, Callable[[], Any]], ...]) -> BoolRef:
        """``formula`` over symbols minted for this compile in place of the
        ones its first lowering minted (``_mint``)."""
        if not minted:
            return formula
        pairs = []
        for made, make in minted:
            fresh = make()
            olds = made if isinstance(made, tuple) else (made,)
            news = fresh if isinstance(fresh, tuple) else (fresh,)
            pairs.extend(zip(olds, news, strict=True))
        return substitute(formula, *pairs)

    def _lower_conditions(
        self, item_id: str, predicates: tuple[str, ...], kind: ConditionKind, blank: bool
    ) -> tuple[BoolRef, bool, tuple[tuple[int, list[str] | None, list[str] | None, bool], ...]]:
        """Lower ``item_id``'s ``predicates`` (``_compile_conditions``):
        ``(conjunction of those that lowered, whether every one lowered exact,
        each condition's gap: (index, wide items, undecided reads, whether its
        lowering failed))``."""
        compiled_conditions = []
        gaps: list[tuple[int, list[str] | None, list[str] | None, bool]] = []
        exact = True
        # After the build, an item's own conditions read the versions of its
        # submission, not the final ones (#1838, ``_enter_submission``).
        at_submission = self._built and item_id in self._submission_versions
        outer_versions = self._enter_submission(item_id) if at_submission else None
        try:
            for idx, predicate in enumerate(predicates):
                if predicate:
                    compiled, wide = self._compile_predicate(predicate, item_id, kind, blank=blank)
                    undecided, failed = self._last_compile
                    # An undecided read leaves the condition wider than it is:
                    # its consumers claim only what a wider formula proves.
                    if compiled is None or wide or undecided:
                        exact = False
                    if compiled is not None:
                        compiled_conditions.append(compiled)
                    if failed or (compiled is not None and (wide or undecided)):
                        gaps.append((idx, wide or None, list(undecided) or None, failed))
        finally:
            if outer_versions is not None:
                self._leave_submission(outer_versions)

        return self._conjoin(compiled_conditions), exact, tuple(gaps)

    def item_implication(self, item_id: str) -> BoolRef:
        """``P_i ⇒ Q_i`` for one item, or ``True`` when its precondition did not
        lower whole.

        ``GlobalFormula`` and ``PathBasedValidator`` ASSUME these implications
        and then claim UNSAT (``global_unsat``, accumulated dead code). An
        inexact P_i is wider than the real gate, so its implication would demand
        Q_i where the real gate is false: a STRONGER assumption, and a false
        conflict. Leaving it out only weakens the assumption, so every UNSAT
        verdict stays sound (#1164). An inexact Q_i is wider and needs no guard.
        """
        details = self.item_details[item_id]
        P_i, P_exact = self.compile_conditions_exactly(item_id, details["preconditions"], kind="precondition")
        if not P_exact:
            return BoolVal(True, self.ctx)
        return Implies(P_i, self.compile_conditions(item_id, details["postconditions"], kind="postcondition"))

    def _lower_predicate(
        self, tree: ast.AST, context: str, kind: ConditionKind, *, blank: bool = True
    ) -> tuple[BoolRef | None, list[str]]:
        """Lower one predicate, with the None tests it may model (``_lower_none_test``),
        the skipped items it can see (``_skippable_reads``) and, when ``blank``,
        the items it may read blank (``_lower_kleene``): ``(formula, the items
        whose raise on None leaves it wider than the gate)``; an empty list
        means the formula is exact.

        Each node lowers two-sided (``_Outcome``, #1779), so a raise on a
        skipped item's None (#1775) is exact wherever it sits, and the kind
        applies once at the root: a precondition lowers to the condition being
        True (a blank leaf, like a raise, fails it); a postcondition to its
        acceptance, not False (a blank leaf, like a raise, waives it), #1784.
        Only a raise ``_place_raises`` cannot place widens it.

        Re-entrant through the helpers it calls; the state it sets is restored.
        """
        outer = (
            self._none_guarded,
            self._predicate_answered,
            self._predicate_reads_variables,
            self._predicate_skipped,
            self._predicate_raising,
            self._lowering_predicate,
            self._predicate_slot_safe,
            self._predicate_list_none,
            self._predicate_blank,
            self._model_blank,
            self._predicate_context,
        )
        try:
            self._predicate_context = context
            self._none_guarded, self._predicate_answered = none_guarded_outcomes(tree), {}
            self._predicate_reads_variables = bool(name_reads(tree) - outcome_reads(tree))
            self._lowering_predicate = True
            self._predicate_blank, self._model_blank = {}, blank
            try:
                safe, raising, parents = self._skippable_reads(tree, context)
                list_raising, slot_raising, self._predicate_slot_safe, none_tested = self._answer_list_reads(
                    tree, context, parents
                )
            except _UnmodelledAnswerRead:
                return None, []
            scalar_raised = {item_id for item_id, _ in raising}
            raised = sorted(scalar_raised | {item_id for item_id, _ in list_raising})
            skippable_lists = {item for item in none_tested if self._whole_answer_skippable(item, context)}
            choices = {
                item_id: self._skipped_choice(item_id)
                for item_id in sorted(safe | set(raised) | skippable_lists)
            }
            # A raising read's item is skip-aware wherever Python reads it
            # without raising too (a chain's ``==`` clause, ``_leaf_raise``).
            self._predicate_skipped = {item_id: choices[item_id] for item_id in safe | scalar_raised}
            self._predicate_list_none = {
                item: self._answer_list_none(item, context, choices) for item in none_tested
            }
            placed, placed_slots, unplaced = self._place_raises(
                raising, list_raising, slot_raising, choices, parents
            )
            self._predicate_slot_safe = self._predicate_slot_safe | placed_slots
            waived: list[BoolRef] = []
            if kind == "precondition":
                self._predicate_raising, wide = self._wrap_unplaced(unplaced, choices, parents)
            else:
                self._predicate_raising = {}
                waived, wide = self._waive_unplaced(unplaced, choices)
            loose = self._loose_leaves(unplaced, choices, parents)
            lowered = self._lower_kleene(tree, context, placed, loose)
            if lowered is None:
                return None, wide
            if kind == "precondition":
                return lowered.true, wide
            return (Or(lowered.accepted, *waived) if waived else lowered.accepted), wide
        finally:
            (
                self._none_guarded,
                self._predicate_answered,
                self._predicate_reads_variables,
                self._predicate_skipped,
                self._predicate_raising,
                self._lowering_predicate,
                self._predicate_slot_safe,
                self._predicate_list_none,
                self._predicate_blank,
                self._model_blank,
                self._predicate_context,
            ) = outer

    def _answer_list_none(self, item_id: str, context: str, choices: dict[str, BoolRef]) -> BoolRef:
        """When a None-tested QuestionGroup or MatrixQuestion is ``None``: skipped
        (``_whole_answer_skippable``), or shown and left blank
        (``_blank_choice``; never the condition's own item, which the runtime
        reads the Python way). Each has at least one of the two."""
        parts = [choices[item_id]] if item_id in choices else []
        if self._model_blank and item_id != context:
            parts.append(self._blank_choice(item_id))
        return self._disjoin(parts)

    def _loose_leaves(
        self,
        unplaced: list[tuple[str | None, ast.AST]],
        choices: dict[str, BoolRef],
        parents: dict[ast.AST, ast.AST],
    ) -> dict[int, list[BoolRef]]:
        """The condition leaves holding a raise ``_place_raises`` could not
        place, with the skip choices under which it may happen.

        Such a raise is lowered wide only for the strict evaluation, where a
        raise is fatal (a precondition fails, a postcondition is waived at its
        root): any value the leaf takes there is wider than the runtime. Reached
        after an unknown operand the runtime reads it as unknown instead, and a
        False there could settle an ``and`` or make a later raise fatal, so
        ``_lower_kleene`` frees the leaf's lenient outcome under these choices.
        """
        loose: dict[int, list[BoolRef]] = {}
        for key, node in unplaced:
            skips = [choices[key]] if key is not None else self._slots_a_read_may_take(node)
            if skips:
                loose.setdefault(id(self._condition_leaf(node, parents)), []).extend(skips)
        return loose

    def _lower_kleene(
        self,
        node: ast.AST,
        context: str,
        placed: dict[int, list[tuple[int | None, bool, BoolRef]]],
        loose: dict[int, list[BoolRef]],
    ) -> _Outcome | None:
        """Lower ``node`` to its runtime outcome (``_Outcome``) with Kleene
        semantics for blank answers (#1784) and Python's for raises (#1779).

        Mirrors ``FlowProcessor._parse_condition`` / ``_evaluate_three_valued``:
        the runtime splits a condition through its top-level ``and`` / ``or`` /
        ``not`` only, and a leaf (anything else, an ``any([...])`` or a
        comprehension included) that reads an item shown and left blank is
        unknown. So this recurses through exactly those nodes and lowers each
        leaf once with ``_ast_to_z3_bool``, never wrapping inside it.

        A leaf ``L`` with blank operands ``B`` and raise ``R`` (``placed``,
        ``_leaf_raise``) is True on ``Not(B) ∧ Not(R) ∧ L``, accepted (not
        False) on ``B ∨ R ∨ L``, and raises on ``Not(B) ∧ R``: a blank leaf is
        unknown before anything is evaluated. Junctions combine as the runtime
        short-circuits (``_outcome_junction``, ``_outcome_not``). A leaf
        holding a raise that cannot be placed (``loose``, ``_loose_leaves``)
        takes any lenient outcome where that raise may happen: fresh Bools,
        wider, never narrower.
        """
        if isinstance(node, ast.BoolOp):
            parts = [self._lower_kleene(value, context, placed, loose) for value in node.values]
            # All operands or nothing (#1164, see ``_ast_to_z3_bool``).
            if any(part is None for part in parts):
                return None
            return _outcome_junction(isinstance(node.op, ast.And), parts)  # type: ignore[arg-type]
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.Not):
            operand = self._lower_kleene(node.operand, context, placed, loose)
            return None if operand is None else _outcome_not(operand)
        leaf = self._text_leaf(node)
        if leaf is None:
            leaf = self._ast_to_z3_bool(node, context)
        if leaf is None:
            return None
        raises = None
        if id(node) in placed:
            raises = self._leaf_raise(node, placed[id(node)], context)
            if raises is None:
                return None
        blanks = [self._blank_choice(item_id) for item_id in sorted(self._blank_operands(node, context))]
        if self._model_blank:
            # A variable the runtime marked unknown makes the leaf unknown as a
            # blank answer does (#1044, #1844): FlowProcessor's leaf variables.
            leaf_variables = name_reads(node) - outcome_reads(node) - none_tested_names(node)
            blanks.extend(
                mark for name in sorted(leaf_variables) if (mark := self._variable_mark(name)) is not None
            )
        any_blank = self._disjoin(blanks) if blanks else None
        fails = [f for f in (any_blank, raises) if f is not None]
        if not fails:
            outcome = _Outcome(leaf, leaf)
        else:
            if raises is not None and any_blank is not None:
                raises = And(Not(any_blank), raises)
            outcome = _Outcome(And(*[Not(f) for f in fails], leaf), Or(*fails, leaf), raises)
        if id(node) not in loose:
            return outcome
        may_raise = self._disjoin(loose[id(node)])

        def mint() -> tuple[BoolRef, BoolRef]:
            self._loose_count += 1
            # ``@`` cannot occur in an item id, so no item or variable shares the name.
            return (
                Bool(f"loose@true@{context}#{self._loose_count}", self.ctx),
                Bool(f"loose@accepted@{context}#{self._loose_count}", self.ctx),
            )

        free_true, free_accepted = self._mint(mint)
        lenient = (If(may_raise, free_true, outcome.true), If(may_raise, free_accepted, outcome.accepted))
        return _Outcome(outcome.true, outcome.accepted, outcome.raises, lenient)

    def _text_leaf(self, leaf: ast.AST) -> BoolRef | None:
        """The truth of a condition leaf that compares a Textarea's text with
        literals (#2241), or None when ``leaf`` is not that shape.

        Free text has no Int (``_ast_to_z3``), so such a leaf is lowered on its
        own and the rest of the condition still lowers: a contradiction on a
        coded answer beside it stays provable. The shape is one ``==`` / ``!=``
        with a literal, or ``in`` / ``not in`` a literal list, on
        ``t.outcome`` (``_literal_values``: a negative number or a list of
        them is a literal too): neither raises on a string or on ``None``, so
        the leaf is True or False and nothing else. Any other leaf reading the
        text (a call, an ordering, arithmetic, a method) is not this shape and
        does not lower.

        An answer to a Textarea is a string (``domain_validator``) and a
        skipped one is ``None``; neither equals a number. So for a Textarea no
        code writes, the numbers in the literals are dropped, and a leaf with
        none left is decided: ``t.outcome == 1`` and ``t.outcome in [1, 2]``
        are False, ``!=`` / ``not in`` True (so is ``in []`` whatever writes
        it). What is left is one Bool per (Textarea, literal set),
        ``_text_choice``, shared by every condition, and ``!=`` / ``not in``
        is its negation: the same comparison in two gates (a block's
        precondition composed into each member) is one fact, and
        ``t == "a" or t != "a"`` always holds. A blank answer still makes the
        leaf unknown (``_lower_kleene``). A Textarea a codeBlock or codeInit
        stores into gets a fresh Bool per leaf instead, since the write can
        change it between two conditions (as ``_skipped_choice`` does), and
        is never decided by the numbers.
        """
        if not (isinstance(leaf, ast.Compare) and len(leaf.ops) == 1):
            return None
        op, (left, right) = leaf.ops[0], (leaf.left, leaf.comparators[0])
        if isinstance(op, (ast.Eq, ast.NotEq)):
            item_id = self._is_textarea_outcome_ref(left)
            other = right
            if item_id is None:
                item_id, other = self._is_textarea_outcome_ref(right), left
            values = self._literal_values(other, scalar=True) if item_id is not None else None
            # ``t.outcome == None`` is a None test (``_lower_none_test``).
            if values is None or values == [None]:
                return None
        elif isinstance(op, (ast.In, ast.NotIn)):
            item_id = self._is_textarea_outcome_ref(left)
            values = self._literal_values(right, scalar=False) if item_id is not None else None
            if values is None:
                return None
        else:
            return None
        negated = isinstance(op, (ast.NotEq, ast.NotIn))
        if not values:
            return BoolVal(negated, self.ctx)
        if item_id in self._code_written_items():
            def mint() -> BoolRef:
                self._text_count += 1
                # ``@`` cannot occur in an item id, so no item or variable shares the name.
                return Bool(f"text@{item_id}#{self._text_count}", self.ctx)

            fresh = self._mint(mint)
            return Not(fresh) if negated else fresh
        texts = frozenset(v for v in values if v is None or isinstance(v, str))
        if not texts:
            return BoolVal(negated, self.ctx)
        choice = self._text_choice(item_id, texts)  # type: ignore[arg-type]
        return Not(choice) if negated else choice

    @staticmethod
    def _literal_values(node: ast.AST, *, scalar: bool) -> list[Any] | None:
        """The values ``node`` evaluates to as a literal: one value when
        ``scalar``, else the members of a list, tuple or set literal; None for
        anything else. Each value is a string, a number or None (anything else,
        a nested list included, is no literal here). ``ast.literal_eval``
        folds what Python folds at parse time, so ``-1`` and ``[-1, 99]`` count."""
        if not scalar and not isinstance(node, (ast.List, ast.Tuple, ast.Set)):
            return None
        try:
            value = ast.literal_eval(node)
        except (ValueError, TypeError, SyntaxError, MemoryError, RecursionError):
            return None
        members = [value] if scalar else list(value)
        if not all(m is None or isinstance(m, (str, int, float)) for m in members):
            return None
        return members

    def _text_choice(self, item_id: str, texts: frozenset[str | None]) -> BoolRef:
        """Whether Textarea ``item_id``'s outcome is one of ``texts``: one Bool
        per (item, literal set) for the whole questionnaire (``_text_leaf``),
        like an answer's one Int."""
        choices = self._text_choices.setdefault(item_id, {})
        choice = choices.get(texts)
        if choice is None:
            # ``@`` cannot occur in an item id, so no item or variable shares
            # the name; no ``#``, since one Bool serves every lowering.
            choice = choices[texts] = Bool(f"text@{item_id}@{len(choices)}", self.ctx)
        return choice

    def _blank_operands(self, leaf: ast.AST, context: str) -> set[str]:
        """The items whose blank answer makes ``leaf`` unknown (#1784): what it
        reads as ``X.outcome`` (``FlowProcessor``'s leaf operands), less what
        the leaf tests against None (it says what None means), what the
        predicate None-guards (its guard leaf carries the blank and settles
        the predicate as Kleene does), and the condition's own item (the
        runtime excludes it from the unknowns)."""
        if not self._model_blank:
            return set()
        reads = outcome_reads(leaf) - none_tested_outcomes(leaf) - self._none_guarded - {context}
        return {item_id for item_id in reads if self._blank_candidate(item_id)}

    def _compile_predicate(
        self, predicate: str, context: str, kind: ConditionKind, *, blank: bool = True
    ) -> tuple[BoolRef | None, list[str]]:
        """Compile a predicate string: ``(Z3 formula or None, the items that leave it
        wider than the condition)`` (``_lower_predicate``).

        What it reads undecided and whether it failed are its own, left in
        ``_last_compile``: a compile nested in another (a postcondition's
        blank acceptance, ``_blank_acceptance``) restores the outer one's on
        the way out, adding its undecided reads to them, since its formula is
        part of the outer one, but never its failure."""
        outer_reads, outer_failed = self._undecided_reads, self._compile_failed
        self._undecided_reads, self._compile_failed = [], False
        try:
            tree = self._parsed(predicate, "eval")
            if tree is None:
                # ``unsafe_code`` reports a predicate that does not parse.
                return None, []
            return self._lower_predicate(tree.body, context, kind, blank=blank)
        except Exception as e:
            self.logger.error(f"Error compiling a predicate in context {context}: {type(e).__name__}")
            self._compile_failed = not self._reported_unsafe(predicate)
            return None, []
        finally:
            # The build already reported this condition's refusals (#1799, #1867).
            self._distinct_refusals.pop(context, None)
            self._ternary_refusals.pop(context, None)
            reads, failed = self._undecided_reads or [], self._compile_failed
            self._last_compile = (reads, failed)
            if outer_reads is not None:
                outer_reads.extend(name for name in reads if name not in outer_reads)
            self._undecided_reads, self._compile_failed = outer_reads, outer_failed

    def debug_dump(self) -> str:
        """Generate debug output."""
        lines = []
        lines.append("=" * 60)
        lines.append("SSA BUILDER DEBUG DUMP")
        lines.append("=" * 60)

        lines.append(f"\n📊 SSA Versions ({len(self.version_map)} variables):")
        for var, version in sorted(self.version_map.items()):
            lines.append(f"  {var}: current version = {version}")
            if var in self.version_history:
                for v, ctx in self.version_history[var]:
                    lines.append(f"    v{v} at {ctx}")

        lines.append(f"\n📦 Item Variables ({len(self.item_vars)} items):")
        resolved_deps = self.get_item_dependencies()
        for item_id in sorted(self.item_vars.keys()):
            deps = resolved_deps.get(item_id, set())
            if deps:
                lines.append(f"  {item_id} depends on: {', '.join(sorted(deps))}")
            else:
                lines.append(f"  {item_id} (no dependencies)")

        lines.append(f"\n🔗 Dependency Graph ({len(self.dependency_graph)} nodes):")
        for node, deps in sorted(self.dependency_graph.items()):
            if deps:
                lines.append(f"  {node} → {', '.join(sorted(deps))}")

        lines.append(f"\n🔗 CodeBlock Constraints: {len(self.codeblock_constraints)}")
        lines.append(f"🔗 Pre/Post Constraints: {len(self.constraints)}")

        lines.append(f"\n🔍 All Z3 Variables: {len(self.get_all_z3_vars())}")

        return "\n".join(lines)
