"""
The founding article's block counter (#1891) as a QMLState, shared by the
topology and the Z3 tests: each item increments ``negative_count`` on a "No",
and a precondition reads it.
"""

from askalot_qml.models.qml_state import QMLState

NO_YES = {"control": "Radio", "labels": {0: "No", 1: "Yes"}}


def counter_questionnaire(
    count: int,
    *,
    block_gate: str | None = "negative_count < 3",
    item_gate_from: int | None = None,
    extra_blocks: list | None = None,
    extra_items: list | None = None,
    required: bool = False,
) -> QMLState:
    """The founding article's block counter (#1891): each of ``count`` items
    increments ``negative_count`` on a "No"; the block precondition (or, from
    item ``item_gate_from`` on, each item's own) reads it. ``required`` gives
    each item ``outcome is not None``: an answer left blank marks the counter
    unknown at runtime (#1044), which skips the rest of the block (#1844)."""
    items = []
    for n in range(1, count + 1):
        item = {
            "id": f"q{n}",
            "blockId": "b1",
            "kind": "Question",
            "title": f"Concept {n}?",
            "input": NO_YES,
            "codeBlock": f"if q{n}.outcome == 0:\n    negative_count = negative_count + 1\n",
        }
        if required:
            item["postcondition"] = [{"predicate": f"q{n}.outcome is not None"}]
        if item_gate_from is not None and n >= item_gate_from:
            item["precondition"] = [{"predicate": "negative_count < 3"}]
        items.append(item)
    block = {"id": "b1", "title": "Concepts"}
    if block_gate:
        block["precondition"] = [{"predicate": block_gate}]
    return QMLState(
        {
            "title": "Counter",
            "codeInit": "negative_count = 0",
            "blocks": [block, *(extra_blocks or [])],
            "items": items + list(extra_items or []),
        }
    )
