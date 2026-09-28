"""The instrument's shape, reduced from the item-level diagram IR.

**Block level, deliberately.** The IR is item level — a real instrument here is
136 items behind 85 conditions, and a graph of that is a hairball a reader of a
paper cannot use. A reader reaching the Appendix has one question: *what shape
is this instrument, and how much of it is conditional?* Thirty block rows answer
it; a hundred and thirty-six item nodes bury it.

This module produces only the FACTS. The drawing lives in
``askalot_common.documents.figures`` and works from the dict returned here,
which is what keeps the split honest in both directions: the reduction needs
QML knowledge (block membership, topology edges, precondition counts) and the
drawing needs none, while ``askalot_common`` may not import ``askalot_qml`` at
all (#150).

It is also the same contract the quality figures already follow — the snapshot
is the record and the SVG is a view of it — which is what lets the structure be
STORED with the paper unit while the SVG is drawn fresh at every read. The
paper's write boundary refuses SVG outright, so a stored drawing was never an
option; a stored measurement always was.
"""

from __future__ import annotations

import logging
from typing import Any

logger = logging.getLogger(__name__)


def block_structure(ir: dict[str, Any]) -> dict[str, Any]:
    """Reduce the item-level diagram IR to the block-level facts the figure draws.

    Separated from the drawing so the reduction is testable without parsing
    SVG. Block transitions are DERIVED: the IR's topology edges run item to
    item, so a transition is an edge whose endpoints sit in different blocks.
    """
    blocks = [b for b in ir.get("blocks", []) if isinstance(b, dict) and b.get("id")]
    order = [b["id"] for b in blocks]
    index = {bid: i for i, bid in enumerate(order)}

    counts: dict[str, int] = dict.fromkeys(order, 0)
    block_of: dict[str, str] = {}
    for item in ir.get("items", []):
        bid = item.get("block_id")
        if bid in counts:
            counts[bid] += 1
            if item.get("id"):
                block_of[item["id"]] = bid

    transitions: set[tuple[str, str]] = set()
    for edge in ir.get("edges", []):
        if edge.get("kind") != "topology":
            continue
        a, b = block_of.get(edge.get("source")), block_of.get(edge.get("target"))
        if a and b and a != b:
            transitions.add((a, b))

    # Is the block graph a single chain? Every transition stepping exactly one
    # position forward means the column layout below tells the whole truth; a
    # skip or a jump means it does not, and the caption says so rather than
    # drawing a diagram that quietly omits an edge.
    skips = sorted(
        (a, b) for a, b in transitions if index.get(b, 0) - index.get(a, 0) != 1
    )

    rows = [
        {
            "id": b["id"],
            "title": str(b.get("title") or b["id"]),
            "items": counts.get(b["id"], 0),
            "gated": int(b.get("precondition_count") or 0),
        }
        for b in blocks
    ]
    return {
        "rows": rows,
        "skips": skips,
        "total_items": sum(counts.values()),
        "gated_blocks": sum(1 for r in rows if r["gated"]),
    }


__all__ = ["block_structure"]
