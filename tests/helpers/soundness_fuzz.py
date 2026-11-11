"""A seeded generator of small questionnaires that mix text and numbers, the
runtime oracle that walks every answer combination, and the soundness check
of the static verdicts against what the walks saw.

The static validator (``ValidationProcessor``) may be wider than the runtime,
never narrower: an item it calls NEVER (or ``unreachable_item``) must be
reached by no run, a postcondition it calls INFEASIBLE must be met by no
answer, and an item it calls ALWAYS must be skipped by no run unless it says
the verdict is inexact or skipped. The oracle is the real runtime
(``FlowProcessor``): it answers each item with every value of a small domain
(two codes, three numbers, two texts, four matrix fills), branching on a
copy of the state, so every combination of those answers is walked.

The generator draws what the string model has to get right: Radio, Editbox,
Textarea and matrix answers; codeInit and codeBlock stores of text, ``None``,
numbers, calls (``str``, ``sorted(...)[0]``), aliases, comprehensions and
ternaries, into variables, answers, matrix cells and rows; and conditions
comparing them with ``==`` / ``!=``, ``in``, orderings, chains and truth
tests. A case is the seed: ``case(seed)`` is the same questionnaire on every
machine.
"""

from __future__ import annotations

import ast
import copy
import logging
import random
from dataclasses import dataclass, field
from typing import Any

from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import SOURCE_RESPONDENT, QMLState

_TEXTS = ['"a"', '""', '"b"']
_NUMBERS = ["0", "1", "2"]
_LITERALS = [*_TEXTS, *_NUMBERS]
_VARIABLES = ["v", "w"]

#: Each control's answers the oracle tries.
_CONTROLS: dict[str, tuple[dict[str, Any], list[Any]]] = {
    "radio": ({"control": "Radio", "labels": {1: "one", 2: "two"}}, [1, 2]),
    "editbox": ({"control": "Editbox", "min": 0, "max": 2}, [0, 1, 2]),
    "textarea": ({"control": "Textarea"}, ["a", "zz"]),
    "matrix": ({"control": "Radio", "labels": {1: "one", 2: "two"}}, [[[1], [1]], [[1], [2]], [[2], [1]], [[2], [2]]]),
}

#: The findings that say an ALWAYS verdict is withheld or may not hold: the
#: two inexact kinds, a read of a name that may be unbound there, and a
#: dependency cycle (the walk's order is then not the model's).
_WITHHELD = {"inexact_condition", "skipped_condition", "undefined_name", "uninitialized_read", "dependency_cycle"}


@dataclass
class Case:
    """One generated questionnaire and the answers the oracle tries per item."""

    seed: int
    doc: dict[str, Any]
    answers: dict[str, list[Any]]


@dataclass
class Facts:
    """What the walks saw."""

    reached: set[str] = field(default_factory=set)
    skipped: set[str] = field(default_factory=set)
    accepted: set[str] = field(default_factory=set)
    runs: int = 0


class _Draw:
    """The grammar, drawing from one ``random.Random``."""

    def __init__(self, rng: random.Random, kinds: dict[str, str]):
        self.rng = rng
        self.kinds = kinds

    def pick(self, options: list[Any]) -> Any:
        return self.rng.choice(options)

    def answer_operand(self, visible: list[str]) -> str | None:
        """A read of a visible answer: a scalar's, or a matrix cell's."""
        if not visible:
            return None
        item = self.pick(visible)
        if self.kinds[item] == "matrix":
            return f"{item}.outcome[{self.pick(['0', '1'])}][0]"
        return f"{item}.outcome"

    def operand(self, visible: list[str]) -> str:
        if visible and self.rng.random() < 0.55:
            read = self.answer_operand(visible)
            if read is not None:
                return read
        return self.pick(_VARIABLES)

    def atom(self, visible: list[str]) -> str:
        o = self.operand(visible)
        shape = self.rng.randrange(9)
        if shape == 0:
            return f"{o} == {self.pick(_LITERALS)}"
        if shape == 1:
            return f"{o} != {self.pick(_LITERALS)}"
        if shape == 2:
            return f"{self.pick(_LITERALS)} == {o}"
        if shape == 3:
            members = ", ".join(self.rng.sample(_LITERALS, 2))
            return f"{o} {self.pick(['in', 'not in'])} [{members}]"
        if shape == 4:
            return f"{o} {self.pick(['<', '>', '>='])} {self.pick(_NUMBERS)}"
        if shape == 5:
            return f"{o} == {self.operand(visible)}"
        if shape == 6:
            return self.pick([o, f"not {o}"])
        if shape == 7:
            return f"0 < {o} == {self.pick(_LITERALS)}"
        return f"{o} {self.pick(['==', '!='])} {self.pick(_TEXTS)}"

    def condition(self, visible: list[str], depth: int = 0) -> str:
        roll = self.rng.random()
        if depth < 1 and roll < 0.2:
            return f"{self.condition(visible, depth + 1)} and {self.condition(visible, depth + 1)}"
        if depth < 1 and roll < 0.35:
            return f"{self.condition(visible, depth + 1)} or {self.condition(visible, depth + 1)}"
        if depth < 1 and roll < 0.42:
            return f"not ({self.condition(visible, depth + 1)})"
        return self.atom(visible)

    def value(self, visible: list[str]) -> str:
        shape = self.rng.randrange(10)
        read = self.answer_operand(visible)
        if shape <= 2 or read is None:
            return self.pick(_LITERALS)
        if shape == 3:
            return f"str({read})"
        if shape == 4:
            return 'sorted(["a", "b"])[0]'
        if shape == 5:
            return read
        if shape == 6:
            return f"{read} + 1"
        if shape == 7:
            return self.pick(_VARIABLES)
        if shape == 8:
            return f"{self.pick(_LITERALS)} if {self.atom(visible)} else {self.pick(_LITERALS)}"
        return f"[k for k in [{read}]][0]"

    def target(self, visible: list[str]) -> str:
        stores = [item for item in visible if self.kinds[item] != "textarea"]
        if stores and self.rng.random() < 0.4:
            item = self.pick(stores)
            if self.kinds[item] == "matrix":
                return self.pick([f"{item}.outcome[{self.pick(['0', '1'])}][0]", f"{item}.outcome[{self.pick(['0', '1'])}]"])
            return f"{item}.outcome"
        return self.pick(_VARIABLES)

    def answer_value(self, item: str, visible: list[str]) -> str:
        """A value stored into ``item``'s answer that may be text: a string
        literal, ``None``, a call's result, or a ternary of a string and a
        number of the item's domain. A store that is only ever a number is
        left out until the model holds one: the model asserts it on the
        answer's one Int, against the item's own postcondition and any other
        write (#2257), and a number outside the domain contradicts it (#2255)."""
        numbers = ["0", "1", "2"] if self.kinds[item] == "editbox" else ["1", "2"]
        read = self.answer_operand(visible)
        shape = self.rng.randrange(4)
        if shape == 0:
            return self.pick([*_TEXTS, "None"])
        if shape == 1 and read is not None:
            return f"str({read})"
        if shape == 2:
            return 'sorted(["a", "b"])[0]'
        branches = [self.pick(_TEXTS), self.pick(numbers)]
        self.rng.shuffle(branches)
        return f"{branches[0]} if {self.atom(visible)} else {branches[1]}"

    def store(self, visible: list[str]) -> str:
        target = self.target(visible)
        if target in _VARIABLES:
            return f"{target} = {self.value(visible)}"
        value = self.answer_value(target.split(".")[0], visible)
        if target.endswith("]") and target.count("[") == 1:
            value = f"[{value}]"  # a whole matrix row
        return f"{target} = {value}"

    def code(self, visible: list[str]) -> str:
        lines: list[str] = []
        for _ in range(self.rng.randint(1, 2)):
            if self.rng.random() < 0.35:
                lines.append(f"if {self.condition(visible)}:")
                lines.append(f"    {self.store(visible)}")
                if self.rng.random() < 0.4:
                    lines.append("else:")
                    lines.append(f"    {self.store(visible)}")
            else:
                lines.append(self.store(visible))
        return "\n".join(lines)


def case(seed: int) -> Case:
    """The questionnaire of ``seed``: 2-4 items in one block."""
    rng = random.Random(seed)
    ids = ["a", "b", "c", "d"][: rng.randint(2, 4)]
    kinds: dict[str, str] = {}
    for item in ids:
        options = ["radio", "radio", "editbox"]
        if "textarea" not in kinds.values():
            options.append("textarea")
        if "matrix" not in kinds.values():
            options.append("matrix")
        kinds[item] = rng.choice(options)
    draw = _Draw(rng, kinds)
    doc: dict[str, Any] = {"title": f"fuzz {seed}", "blocks": [{"id": "b1", "kind": "Group", "title": "B"}], "items": []}
    # Both variables are bound from the start and never hold ``None``: an
    # ordering or arithmetic on an unbound or ``None`` variable raises at
    # runtime, which the model does not hold for numbers either (#2258).
    init = [f"{var} = {draw.pick(_LITERALS)}" for var in _VARIABLES]
    init += [draw.store([]) for _ in range(rng.randint(0, 1))]
    if init:
        doc["codeInit"] = "\n".join(init)
    answers: dict[str, list[Any]] = {}
    for i, item in enumerate(ids):
        control, domain = _CONTROLS[kinds[item]]
        entry: dict[str, Any] = {"id": item, "blockId": "b1", "title": item, "input": copy.deepcopy(control)}
        if kinds[item] == "matrix":
            entry.update({"kind": "MatrixQuestion", "rows": ["r1", "r2"], "columns": ["c1"]})
        else:
            entry["kind"] = "Question"
        earlier = ids[:i]
        # A matrix is never gated: a cell read of a gated matrix a codeBlock
        # writes is #2256's, which the model does not hold yet.
        if i > 0 and kinds[item] != "matrix" and rng.random() < 0.7:
            entry["precondition"] = [{"predicate": draw.condition(earlier)}]
        if kinds[item] != "matrix" and rng.random() < 0.3:
            own = f"{item}.outcome"
            entry["postcondition"] = [{"predicate": draw.pick([f"{own} != {draw.pick(_LITERALS)}", f"{own} == {draw.operand(earlier)}", draw.condition([*earlier, item]).replace(draw.answer_operand([item]) or own, own)])}]
        if kinds[item] != "textarea" and rng.random() < 0.5:
            entry["codeBlock"] = draw.code(ids[: i + 1])
        doc["items"].append(entry)
        answers[item] = list(domain)
    _keep_to_the_walk(doc)
    return Case(seed, doc, answers)


def _uses(source: str, mode: str) -> tuple[set[str], set[str], set[str], set[str]]:
    """``(answers read, answers stored, variables read, variables stored)``."""
    reads, stores, names, assigned = set(), set(), set(), set()
    for node in ast.walk(ast.parse(source, mode=mode)):
        if isinstance(node, ast.Attribute) and node.attr == "outcome" and isinstance(node.value, ast.Name):
            reads.add(node.value.id)
        if isinstance(node, (ast.Attribute, ast.Subscript)) and isinstance(node.ctx, ast.Store):
            base = node
            while isinstance(base, (ast.Attribute, ast.Subscript)):
                base = base.value
            if isinstance(base, ast.Name):
                stores.add(base.id)
        if isinstance(node, ast.Name):
            (assigned if isinstance(node.ctx, ast.Store) else names).add(node.id)
    return reads, stores, names, assigned


def _keep_to_the_walk(doc: dict[str, Any]) -> None:
    """Drop what makes the walk's order, not text, decide a verdict, until
    nothing is left to drop: a condition reading an answer asked after its
    item, or a variable a codeBlock after it writes (the runtime asks a
    skipped item again once that write makes its gate true, #2260), and a
    codeBlock that reads or stores an answer asked after it (an answer code
    stores before the item is reached is never asked, #2259). The order is
    the runtime's own (``navigation_path``)."""
    for _ in range(6):
        state = QMLState(copy.deepcopy(doc))
        FlowProcessor(state)
        position = {item_id: i for i, item_id in enumerate(state.get_navigation_path())}
        items = {item["id"]: item for item in doc["items"]}
        writes = {
            item_id: _uses(item["codeBlock"], "exec")[3] for item_id, item in items.items() if item.get("codeBlock")
        }
        changed = False
        for item_id, item in items.items():
            later_writes = set().union(*(names for other, names in writes.items() if position[other] > position[item_id]))
            for kind in ("precondition", "postcondition"):
                for condition in item.get(kind) or []:
                    reads, _, names, _ = _uses(condition["predicate"], "eval")
                    late = any(position.get(r, -1) > position[item_id] for r in reads)
                    if late or names & later_writes:
                        item.pop(kind)
                        changed = True
                        break
            if item.get("codeBlock"):
                reads, stores, _, _ = _uses(item["codeBlock"], "exec")
                if any(position.get(r, -1) > position[item_id] for r in reads | stores):
                    item.pop("codeBlock")
                    changed = True
        if not changed:
            return


def unsound(doc: dict[str, Any]) -> list[str]:
    """The violations of a hand-written one-block questionnaire of Radio
    (codes 1, 2), Editbox (0..2), Textarea and 2x1 Radio matrix items: the
    regression tests' oracle."""
    answers = {}
    for item in doc["items"]:
        control = item["input"]["control"]
        kind = "matrix" if item.get("kind") == "MatrixQuestion" else {"Radio": "radio", "Editbox": "editbox", "Textarea": "textarea"}[control]
        answers[item["id"]] = list(_CONTROLS[kind][1])
    previous = logging.root.manager.disable
    logging.disable(logging.CRITICAL)
    try:
        c = Case(-1, doc, answers)
        return violations(c, explore(c))
    finally:
        logging.disable(previous)


def explore(c: Case, max_runs: int = 400) -> Facts:
    """Walk every combination of ``c``'s answers through the runtime."""
    facts = Facts()
    state = QMLState(copy.deepcopy(c.doc))
    FlowProcessor(state)
    order = [item["id"] for item in c.doc["items"]]

    def walk(current: QMLState, presented: list[str]) -> None:
        if facts.runs >= max_runs:
            return
        item = FlowProcessor.from_cached_state(current).get_current_item(current, backward=False)
        # ``isLast`` is the end-of-walk recap of a visited item (a codeBlock
        # write marks one visited too), never a presentation.
        if item is None or item.get("isLast") or item["id"] in presented:
            facts.runs += 1
            facts.skipped.update(i for i in order if i not in presented)
            return
        item_id = item["id"]
        facts.reached.add(item_id)
        for answer in c.answers[item_id]:
            branch = copy.deepcopy(current)
            result = FlowProcessor.from_cached_state(branch).process_item(
                branch, item_id, copy.deepcopy(answer), source=SOURCE_RESPONDENT
            )
            if result.get("success"):
                facts.accepted.add(item_id)
                walk(branch, [*presented, item_id])

    walk(state, [])
    return facts


def violations(c: Case, facts: Facts) -> list[str]:
    """Each static verdict on ``c`` the walks refute."""
    processor = ValidationProcessor(QMLState(copy.deepcopy(c.doc)))
    issues = processor.to_issues()
    classes = processor.get_item_classifications()
    found: list[str] = []
    for entry in c.doc["items"]:
        item = entry["id"]
        types = {i["type"] for i in issues if i.get("item_id") == item}
        pre = (classes.get(item, {}).get("precondition") or {}).get("status")
        post = (classes.get(item, {}).get("postcondition") or {}).get("invariant")
        if item in facts.reached and (pre == "NEVER" or "unreachable_item" in types):
            found.append(f"{item}: reached, but the validator says it never is ({pre})")
        if entry.get("postcondition") and item in facts.accepted and (
            post == "INFEASIBLE" or types & {"infeasible_postcondition", "globally_false_postcondition"}
        ):
            found.append(f"{item}: an answer meets its postcondition, but the validator says none does ({post})")
        if pre == "ALWAYS" and item in facts.skipped and not types & _WITHHELD:
            found.append(f"{item}: skipped by a run, but the validator says it is always asked")
    return found


def check(seed: int) -> list[str]:
    """The violations of case ``seed`` (logging silenced while it runs)."""
    previous = logging.root.manager.disable
    logging.disable(logging.CRITICAL)
    try:
        c = case(seed)
        return violations(c, explore(c))
    finally:
        logging.disable(previous)
