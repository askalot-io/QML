"""
QMLGuardTree - the branching structure of a questionnaire, proved by Z3 (#1970).

The diagram's spine shows every item in navigation order with its conditions as
chiclets beside it; the guard tree shows the same items as branches. It is
built on demand (``ValidationProcessor.get_guard_tree``, served by
``POST /guard-tree`` of the validation blueprint), never on the validation
answer itself, and drawn by QML Explorer's tree layout.

Construction:

1. **Effective guard.** An item's effective guard is its block's preconditions
   followed by its own, the composition the runtime and ``StaticBuilder`` gate
   on (``item_details[...]["preconditions"]``). Every gated item's guard is
   lowered in its own context, so it reads each variable at the version current
   at its submission (#1838) and records a coverage gap at the condition index
   the classifier uses. Items whose lowerings have the same predicate texts AND
   the same formula, up to renaming the symbols a lowering mints for itself
   (``_canonical``), form one node; the same text reading another version of a
   variable (a codeBlock between the items rewrites it) is a node of its own.
   Items with no guard form the trunk.
2. **Nesting.** Node A nests under node B only when Z3 proves A ⇒ B under the
   reachability base. Its parent is the most specific proven ancestor: among the
   proven ancestors none of the others nests under, the deepest (ties: the
   earliest in navigation order). The others are listed in ``also_under``: the
   tree has one parent per node, so a DAG join is never drawn twice.
   Equivalent guards (each implies the other) nest the later under the earlier.
3. **Siblings.** Children of one parent (the trunk's children included) are
   marked pairwise ``exclusive_with`` (A ∧ B unsatisfiable: alternative
   branches) or ``overlaps_with`` (satisfiable: parallel optional runs).

**What a solver answer proves across two guards.** The guards are lowered
separately, and a lowering stands for its own moment of the walk, so the
symbols it mints for itself (``answered@X#n``, ``branch@…#n``, ``unbound@…#n``,
a code-written item's ``skipped@X#n``: every name holding ``#``) are tied to
nothing in another lowering; nor is a code-state version (``var@x@n``,
``ran@…``, ``mark@…``) tied to what the codeBlocks really compute, unless the
base pins it. Only the world's choices are shared: answers (``item_…``) and the
per-item skip, blank and slot choices. So:

- ``unsat`` is sound whatever those symbols are: a proof over free symbols holds
  for every value they take (nesting, either/or, never, always).
- One minted symbol is tied back to the world (#2046): ``answered@X#n``, for
  an X no code writes, becomes "X is neither skipped nor blank"
  (``StaticBuilder.answered_by_world``) where X comes before the item whose
  condition minted the symbol (``StaticBuilder.answered_mint``: the guard's
  own item, or another item whose blank acceptance a lowering conjoins). The
  walk is past X there and does not revisit a skip or a blank. A guard that
  reads X follows X in the walk except across a dependency cycle, where the
  symbol is kept, as it is for a code-written X. Each guard carries two
  formulas. ``formula`` ties every such X and serves the ``unsat`` claims: the
  skip and blank choices are wider than the walk, so a refutation over them
  holds for every walk. ``witness`` ties only an X with no gate and serves
  the ``sat`` confirmations below: a gated X's skip choice is free of its gate
  (#1769), so a world that holds through it need not be a walk, and there the
  per-lowering symbol stays an abstraction.
- ``sat`` across guards proves something only when it holds for every value of
  the abstraction symbols: the plain check stands when neither guard holds one,
  and otherwise a second check asks for answers that satisfy the pair under
  ``ForAll(abstractions, base ⇒ pair)`` (``_sat_for_every_abstraction``). Where
  that is not shown, "not nested" and "parallel" are undecided. Sharing the
  symbols instead would be unsound the other way: X answered at one guard and
  unanswered at a later one is a real walk.

Undecided is never a silent default ("every undecided case must be visible").
A check that times out, answers ``unknown``, or runs past the build's budget is
undecided, and so is one whose verdict an inexact lowering keeps from being
sound: a guard that did not lower whole is WIDER than the real one, so
``unsat(A ∧ ¬B)`` proves A ⇒ B only when B is exact, ``sat`` refutes it only
when A is exact, and ``sat(A ∧ B)`` shows an overlap only when both are exact
(``unsat`` is sound either way). An undecided nesting leaves the node where it
is proved and lists the guard in ``undecided_parents``; an undecided sibling
pair is listed in ``undecided_with``; a guard whose never / always check is
undecided has ``status: "undecided"``. Each counts in ``checks.undecided``.

The claims are about the model the classifier judges reachability in (declared
answer domains, skip and blank choices, the reachability base); a postcondition
coupling two answers is not part of it, as it is not part of a precondition's
ALWAYS / NEVER.

Degenerate guards stay off the implication order, because they would make
everything nest under or inside them: a guard the base makes unsatisfiable
(``status: "never"``) implies every guard, and a guard valid under the base
(``status: "always"``, claimed only for an exact lowering) is implied by every
guard. Both hang from the trunk, and nothing nests under them. A ``never``
guard takes no sibling marks: it is exclusive with every guard, which would
mark every branch beside it an alternative. A ``conditional`` guard is one
neither check settled as never or always (an inexact guard is never claimed
always).

Bounds: one ``Solver`` holds the base, each check is a ``push``/``pop`` with a
per-check timeout, checks run only over distinct guards, and a total budget per
build caps the whole pass, its clock started before the guards are grouped
(the lowering is linear and runs whole). Past it every remaining check is
undecided and ``budget_exhausted`` is set, and no term is built for one
(``_check`` takes its assertions unbuilt and asks ``_spent`` first): building
the terms of the O(n²) pairs that remain can cost more than the budget itself
(#2113). A pair answered inside the budget keeps its answer.
``ValidationProcessor`` builds the tree at most once per build.
"""

from __future__ import annotations

import logging
import time
from collections.abc import Callable
from typing import Any

from z3 import (
    Z3_OP_UNINTERPRETED,
    And,
    BoolRef,
    BoolVal,
    CheckSatResult,
    Const,
    ExprRef,
    ForAll,
    Implies,
    Not,
    Solver,
    is_and,
    is_const,
    sat,
    substitute,
    unsat,
)

from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.static_builder import StaticBuilder

logger = logging.getLogger(__name__)

# One check's wall-clock cap. A guard pair a solver cannot settle in this time
# is reported undecided rather than stalling the diagram.
CHECK_TIMEOUT_MS = 250
# The whole build's cap, grouping the guards included. The pair checks grow
# with the square of the distinct guards, so past a mid-size questionnaire a
# longer budget settles little more: on the dev heads (2026-11-05) 10 s let an
# 83-guard questionnaire finish (8,017 undecided at 3 s, 1,471 at 10 s) while a
# 520-guard one went from 404,820 to 404,300. The Tree view shows the request
# as busy, with the seconds elapsed, for as long as it takes.
BUILD_BUDGET_MS = 10_000

YES = "yes"
NO = "no"
UNDECIDED = "undecided"

# The prefixes of the world's own choices, shared by every lowering: an answer
# (``item_{id}`` and the names ``_scoped_name`` / ``_range_end_names`` derive
# from it) and an item's one skip, blank or slot choice. A name holding ``#``
# is minted per lowering, so it is never one of them.
_WORLD_PREFIXES = ("item_", "skipped@", "blank@", "unanswered@")


def _is_world(name: str) -> bool:
    return "#" not in name and name.startswith(_WORLD_PREFIXES)


def _constants(expr: ExprRef) -> dict[str, ExprRef]:
    """The uninterpreted constants of ``expr`` by name, in first-seen preorder.

    Iterative, with each shared sub-term walked once: a reachability base is a
    large DAG, and the order is what ``_canonical`` renames by.
    """
    found: dict[str, ExprRef] = {}
    seen: set[int] = set()
    stack = [expr]
    while stack:
        node = stack.pop()
        node_id = node.get_id()
        if node_id in seen:
            continue
        seen.add(node_id)
        if is_const(node) and node.decl().kind() == Z3_OP_UNINTERPRETED:
            found.setdefault(node.decl().name(), node)
            continue
        stack.extend(reversed(node.children()))
    return found


def _conjuncts(expr: BoolRef) -> list[BoolRef]:
    """``expr``'s top-level conjuncts, nested ``And`` flattened."""
    out: list[BoolRef] = []
    stack = [expr]
    while stack:
        node = stack.pop()
        if is_and(node):
            stack.extend(reversed(node.children()))
        else:
            out.append(node)
    return out


def break_parent_loops(parent: dict[str, str | None], also_under: dict[str, list[str]]) -> None:
    """Break every parent loop to the trunk, in place, at a guard on the loop.

    Proved implications are transitive, but a mix of proved and undecided data
    need not be, so the parent links can close a loop. Each guard is walked in
    order; a guard whose own chain returns to it is on a loop and is moved to
    the trunk (losing its ``also_under``). A guard whose chain only runs into a
    loop keeps its parent: the loop is broken when one of its members is walked.
    """
    for guard_id in parent:
        seen = {guard_id}
        cursor = parent[guard_id]
        while cursor is not None:
            if cursor == guard_id:
                parent[guard_id] = None
                also_under[guard_id] = []
                break
            if cursor in seen:
                break
            seen.add(cursor)
            cursor = parent[cursor]


class QMLGuardTree:
    """Build the guard tree of one questionnaire from its ``StaticBuilder``."""

    def __init__(
        self,
        builder: StaticBuilder,
        state: QMLState,
        navigation_order: list[str],
        *,
        check_timeout_ms: int = CHECK_TIMEOUT_MS,
        budget_ms: int = BUILD_BUDGET_MS,
    ):
        self.builder = builder
        self.state = state
        self.navigation_order = navigation_order
        self.check_timeout_ms = check_timeout_ms
        self.budget_ms = budget_ms
        self._deadline = 0.0
        self._solver: Solver | None = None
        self._base_abstract: BoolRef | None = None
        self._base_abstractions: dict[str, ExprRef] = {}
        self._both_hold_results: dict[frozenset[str], CheckSatResult | None] = {}
        self._holds_for_every_abstraction: dict[str, bool] = {}
        self._checks_run = 0
        self._checks_undecided = 0
        self._budget_exhausted = False

    # ------------------------------------------------------------------
    # Effective guards
    # ------------------------------------------------------------------

    def _effective_conditions(self, item_id: str) -> list[dict[str, Any]]:
        """Block preconditions, then the item's own, as the condition entries.

        The entries are the composed list itself, so a lowering of them records
        a coverage gap at the same condition index the classifier uses.
        """
        details = self.builder.item_details.get(item_id)
        if details is not None:
            return list(details["preconditions"])
        item = self.state.get_item(item_id) or {}
        block_id = item.get("blockId")
        block = self.state.get_block(block_id) if block_id else None
        return list((block.get("precondition") if block else None) or []) + list(
            item.get("precondition") or []
        )

    @staticmethod
    def _predicate_key(conditions: list[dict[str, Any]]) -> tuple[str, ...]:
        """The guard's text: its non-empty predicate texts, in order."""
        return tuple(
            str(c.get("predicate", "")).strip()
            for c in conditions
            if str(c.get("predicate", "")).strip()
        )

    @staticmethod
    def _canonical(formula: BoolRef, constants: dict[str, ExprRef]) -> BoolRef:
        """``formula`` with each symbol minted for its lowering (a name holding
        ``#``) renamed by first occurrence, so two lowerings that differ only
        in those names compare equal (``eq``) and one reading another version
        of a variable does not. ``constants`` is ``_constants(formula)``."""
        minted = [c for name, c in constants.items() if "#" in name]
        if not minted:
            return formula
        return substitute(
            formula, *[(c, Const(f"guard_tree@{i}", c.sort())) for i, c in enumerate(minted)]
        )

    def _answered_by_world(self, formula: BoolRef, position: dict[str, int], *, skippable: bool) -> BoolRef:
        """``formula`` with each ``answered@X#n`` a lowering minted replaced by
        X's answeredness as the world's choices state it
        (``StaticBuilder.answered_by_world``), for an X that comes before the
        item whose condition minted it (``StaticBuilder.answered_mint``) in
        navigation order and that no code writes (#2046); and, unless
        ``skippable``, for an X with no gate. Every other minted symbol is kept
        (module docstring).
        """
        replacements = []
        for name, symbol in _constants(formula).items():
            mint = self.builder.answered_mint(name)
            if mint is None:
                continue
            read, context = mint
            if read not in position or context not in position or position[read] >= position[context]:
                continue
            answered = self.builder.answered_by_world(read, skippable=skippable)
            if answered is not None:
                replacements.append((symbol, answered))
        return substitute(formula, *replacements) if replacements else formula

    def _ordered_items(self) -> list[str]:
        """Item ids in navigation order, then any item the order does not list."""
        item_ids = [i["id"] for i in self.state.get_items() if i.get("id")]
        known = set(item_ids)
        seen: set[str] = set()
        ordered: list[str] = []
        for item_id in list(self.navigation_order) + item_ids:
            if item_id in known and item_id not in seen:
                seen.add(item_id)
                ordered.append(item_id)
        return ordered

    # ------------------------------------------------------------------
    # Bounded Z3 checks
    # ------------------------------------------------------------------

    def _start_solver(self) -> None:
        """One solver holding the reachability base, and the base's conjuncts
        that mention an abstraction symbol, for ``_sat_for_every_abstraction``."""
        base = self.builder.get_reachability_base()
        self._solver = Solver(ctx=self.builder.ctx)
        self._solver.add(base)
        parts: list[BoolRef] = []
        for conjunct in _conjuncts(base):
            abstract = {n: c for n, c in _constants(conjunct).items() if not _is_world(n)}
            if abstract:
                parts.append(conjunct)
                self._base_abstractions.update(abstract)
        self._base_abstract = And(*parts) if parts else BoolVal(True, self.builder.ctx)

    def _spent(self) -> bool:
        """Whether the build's budget has run out (and ``budget_exhausted`` set).

        Asked before a check's terms are built, not only before it is solved:
        past the deadline every remaining relation is undecided, and building
        ``Not`` / ``And`` / ``ForAll`` terms for the O(n²) pairs that remain
        cost more than the budget itself on a large questionnaire (#2113).
        """
        if self._budget_exhausted:
            return True
        if time.monotonic() >= self._deadline:
            self._budget_exhausted = True
        return self._budget_exhausted

    def _check(self, assertions: Callable[[], tuple[BoolRef, ...]]) -> Any | None:
        """``sat`` / ``unsat`` / ``unknown`` of base ∧ ``assertions()``, or None
        past the budget, when the assertions are not built (``_spent``)."""
        if self._spent():
            return None
        return self._solve(*assertions())

    def _solve(self, *assertions: BoolRef) -> Any | None:
        """One bounded solver call under what is left of the budget."""
        remaining_ms = int((self._deadline - time.monotonic()) * 1000)
        if remaining_ms <= 0:
            self._budget_exhausted = True
            return None
        assert self._solver is not None
        self._solver.set("timeout", max(1, min(self.check_timeout_ms, remaining_ms)))
        self._solver.push()
        try:
            self._solver.add(*assertions)
            self._checks_run += 1
            return self._solver.check()
        finally:
            self._solver.pop()

    def _sat_for_every_abstraction(self, guards: tuple[dict, ...], *parts: BoolRef) -> bool:
        """Whether some answers make ``parts`` hold whatever the abstraction
        symbols are (module docstring), given a plain ``sat`` of them.

        True at once when no guard holds an abstraction symbol: the plain model
        is then a choice of answers alone. Otherwise every abstraction symbol of
        the guards and of the base is bound, under the base's conjuncts that
        mention one, so a code-state version the base pins (a frozen variable,
        an accumulator) keeps its value and every other is any value. Anything
        but ``sat`` (``unsat``, ``unknown``, a timeout, the budget) is False.
        """
        bound: dict[str, ExprRef] = {}
        for guard in guards:
            bound.update(guard["abstractions"])
        if not bound:
            return True
        bound.update(self._base_abstractions)
        assert self._base_abstract is not None
        base = self._base_abstract
        return self._check(lambda: (ForAll(list(bound.values()), Implies(base, And(*parts))),)) == sat

    def _implies(self, a: dict, b: dict) -> str:
        """Does guard ``a`` imply guard ``b``? (Soundness rules: module docstring.)"""
        result = self._check(lambda: (a["formula"], Not(b["formula"])))
        if result == unsat and b["exact"]:
            return YES
        if (
            result == sat
            and a["exact"]
            and self._sat_for_every_abstraction((a, b), a["witness"], Not(b["witness"]))
        ):
            return NO
        if self._exclusive_refutes(a, b):
            return NO
        self._checks_undecided += 1
        return UNDECIDED

    def _exclusive_refutes(self, a: dict, b: dict) -> bool:
        """Whether ``a`` provably does not imply ``b`` because the two can never
        both hold (#2045): ``unsat(a ∧ b)`` is sound over any symbols, so where
        ``a`` itself holds, ``b`` does not. That needs ``a`` exact and shown
        satisfiable (``status`` conditional), for every value of the
        abstraction symbols; an inexact or abstract ``a`` keeps the pair
        undecided, since a wider ``sat`` does not prove ``a`` satisfiable."""
        if not a["exact"] or a.get("status") != "conditional":
            return False
        if self._both_hold(a, b) != unsat:
            return False
        if a["id"] not in self._holds_for_every_abstraction:
            # b's minted symbols do not occur in a, so this depends on a alone.
            self._holds_for_every_abstraction[a["id"]] = self._sat_for_every_abstraction((a,), a["witness"])
        return self._holds_for_every_abstraction[a["id"]]

    def _both_hold(self, a: dict, b: dict) -> CheckSatResult | None:
        """``check(a ∧ b)``, once per unordered pair: the nesting fallback and
        the sibling marks both ask it. A pair answered inside the budget keeps
        its answer past it; one not yet asked is None (undecided) there."""
        key = frozenset((a["id"], b["id"]))
        if key not in self._both_hold_results:
            self._both_hold_results[key] = self._check(lambda: (a["formula"], b["formula"]))
        return self._both_hold_results[key]

    def _exclusive(self, a: dict, b: dict) -> str:
        """Can guards ``a`` and ``b`` never both hold?"""
        result = self._both_hold(a, b)
        if result == unsat:
            return YES
        if (
            result == sat
            and a["exact"]
            and b["exact"]
            and self._sat_for_every_abstraction((a, b), a["witness"], b["witness"])
        ):
            return NO
        self._checks_undecided += 1
        return UNDECIDED

    def _status(self, guard: dict) -> str:
        """``never`` when the base refutes it, ``always`` when it is exact and
        valid, ``undecided`` when a check that would settle either did not
        answer, else ``conditional``."""
        holds = self._check(lambda: (guard["formula"],))
        if holds == unsat:
            return "never"
        if holds != sat:
            self._checks_undecided += 1
            return UNDECIDED
        if not guard["exact"]:
            return "conditional"
        fails = self._check(lambda: (Not(guard["formula"]),))
        if fails == unsat:
            return "always"
        if fails != sat:
            self._checks_undecided += 1
            return UNDECIDED
        return "conditional"

    # ------------------------------------------------------------------
    # The tree
    # ------------------------------------------------------------------

    def _group(self) -> tuple[list[str], list[dict[str, Any]]]:
        """The trunk and the distinct guards, each with the items it gates."""
        trunk: list[str] = []
        guards: list[dict[str, Any]] = []
        by_text: dict[tuple[str, ...], list[dict[str, Any]]] = {}
        ordered_items = self._ordered_items()
        position = {item_id: i for i, item_id in enumerate(ordered_items)}
        for item_id in ordered_items:
            conditions = self._effective_conditions(item_id)
            key = self._predicate_key(conditions)
            if not key:
                trunk.append(item_id)
                continue
            formula, exact = self.builder.compile_conditions_exactly(
                item_id, conditions, kind="precondition"
            )
            proof = self._answered_by_world(formula, position, skippable=True)
            witness = self._answered_by_world(formula, position, skippable=False)
            constants = _constants(proof)
            canonical = self._canonical(proof, constants)
            same_text = by_text.setdefault(key, [])
            guard = next(
                (g for g in same_text if g["exact"] == exact and g["canonical"].eq(canonical)),
                None,
            )
            if guard is None:
                guard = {
                    "id": f"guard_{len(guards) + 1}",
                    "predicates": list(key),
                    "items": [],
                    "formula": proof,
                    "witness": witness,
                    "canonical": canonical,
                    "exact": exact,
                    "abstractions": {
                        n: c for n, c in _constants(witness).items() if not _is_world(n)
                    },
                    "position": len(guards),
                }
                same_text.append(guard)
                guards.append(guard)
            guard["items"].append(item_id)
        return trunk, guards

    def build(self) -> dict[str, Any]:
        """The guard tree (shape in ``qml_diagram_ir``'s module docstring)."""
        self._deadline = time.monotonic() + self.budget_ms / 1000
        trunk, guards = self._group()
        self._start_solver()

        for guard in guards:
            guard["status"] = self._status(guard)
        ordered = [g for g in guards if g["status"] not in ("never", "always")]

        # below[a][b]: a nests strictly under b (proved implication; for an
        # equivalent pair, the later guard under the earlier).
        implication: dict[tuple[str, str], str] = {}
        for a in ordered:
            for b in ordered:
                if a is not b:
                    implication[a["id"], b["id"]] = self._implies(a, b)

        def below(a: dict, b: dict) -> bool:
            if implication[a["id"], b["id"]] != YES:
                return False
            return implication[b["id"], a["id"]] != YES or a["position"] > b["position"]

        ancestors = {a["id"]: [b for b in ordered if b is not a and below(a, b)] for a in ordered}
        parent: dict[str, str | None] = {g["id"]: None for g in guards}
        also_under: dict[str, list[str]] = {g["id"]: [] for g in guards}
        for a in ordered:
            candidates = ancestors[a["id"]]
            minimal = [p for p in candidates if not any(c is not p and below(c, p) for c in candidates)]
            if not minimal:
                continue
            minimal.sort(key=lambda p: (-len(ancestors[p["id"]]), p["position"]))
            parent[a["id"]] = minimal[0]["id"]
            also_under[a["id"]] = [p["id"] for p in minimal[1:]]

        break_parent_loops(parent, also_under)

        def depth(guard_id: str) -> int:
            d, cursor = 1, parent[guard_id]
            while cursor is not None:
                d, cursor = d + 1, parent[cursor]
            return d

        # Undecided nesting: a guard it might nest under, other than where it sits.
        placed_under: dict[str, set[str]] = {}
        for guard in guards:
            chain: set[str] = set()
            cursor = parent[guard["id"]]
            while cursor is not None:
                chain.add(cursor)
                cursor = parent[cursor]
            placed_under[guard["id"]] = chain
        undecided_parents = {
            a["id"]: [
                b["id"]
                for b in ordered
                if b is not a
                and implication[a["id"], b["id"]] == UNDECIDED
                and b["id"] not in placed_under[a["id"]]
            ]
            for a in ordered
        }

        # A guard that never holds is exclusive with everything; marking it would
        # call every trunk branch an alternative, so it carries only its status.
        siblings: dict[str | None, list[dict]] = {}
        for guard in guards:
            if guard["status"] != "never":
                siblings.setdefault(parent[guard["id"]], []).append(guard)
        marks: dict[str, dict[str, list[str]]] = {
            g["id"]: {"exclusive_with": [], "overlaps_with": [], "undecided_with": []} for g in guards
        }
        for group in siblings.values():
            for i, a in enumerate(group):
                for b in group[i + 1 :]:
                    verdict = self._exclusive(a, b)
                    field = {
                        YES: "exclusive_with",
                        NO: "overlaps_with",
                        UNDECIDED: "undecided_with",
                    }[verdict]
                    marks[a["id"]][field].append(b["id"])
                    marks[b["id"]][field].append(a["id"])

        if self._budget_exhausted:
            logger.warning(
                "Guard tree budget of %d ms exhausted after %d checks; the rest are undecided",
                self.budget_ms,
                self._checks_run,
            )

        return {
            "trunk": trunk,
            "nodes": [
                {
                    "id": g["id"],
                    "predicates": g["predicates"],
                    "label": " and ".join(
                        p if len(g["predicates"]) == 1 else f"({p})" for p in g["predicates"]
                    ),
                    "parent": parent[g["id"]],
                    "items": g["items"],
                    "depth": depth(g["id"]),
                    "exact": g["exact"],
                    "status": g["status"],
                    **marks[g["id"]],
                    "undecided_parents": undecided_parents.get(g["id"], []),
                    "also_under": also_under[g["id"]],
                }
                for g in guards
            ],
            "budget_exhausted": self._budget_exhausted,
            "checks": {"run": self._checks_run, "undecided": self._checks_undecided},
        }
