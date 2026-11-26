"""The facts a readable inventory is drawn from: an inventory joined with its QML's items.

This module produces plain, JSON-able data only. The drawing (the HTML table a
person reads, the hint the editor shows on an item) lives with the callers,
which cannot load QML themselves; here the QML's own facts (item kind, wording,
rows) meet the entry's.

``inventory_view_facts`` answers three lists, each item appearing in exactly one,
and ``coverage``: the goal coverage ``coverage.goal_coverage`` computes when
the caller passes the KPI tokens the project's paper numbers, ``None`` when it
passes none or there is no inventory.

- ``constructs``: one group per construct, in order of first appearance in the
  QML. Names equal after trimming and case folding are one construct, shown
  with the spelling met first.
- ``purposes``: one group per purpose, in order of first appearance, for items
  that state a purpose and no construct.
- ``without_intent``: items with no entry, and items whose entry is missing
  intent as ``warnings`` judges it.

A battery whose entry names no construct or purpose of its own, because its
rows state theirs, is placed by the first row that states one. Items keep the
QML's document order inside every list. A ``Comment`` asks nothing and appears
nowhere, and an entry whose item the QML does not ask has no wording to show:
it is a warning, not a row of the view.

Wording is the QML's, as plain text. Each row of a battery is listed with its
wording and its facts laid over the item's, so a reverse-worded statement
reads as reversed and its neighbours do not.
"""

from __future__ import annotations

from collections.abc import Sequence
from typing import Any

from askalot_qml.inventory.coverage import goal_coverage
from askalot_qml.inventory.model import (
    ItemEntry,
    ItemInventory,
    construct_key,
    plain_text,
    row_texts,
)
from askalot_qml.inventory.warnings import (
    asking_items,
    effective_facts,
    entry_lacks_intent,
    is_stated,
)

_HINT_FACTS = ("construct", "kind", "kpis", "purpose", "reversed")


def inventory_view_facts(
    qml: dict, inventory: ItemInventory | None, *, kpi_tokens: Sequence[str] | None = None
) -> dict:
    """The grouped item facts of ``qml`` under ``inventory``; every item is without intent when it is ``None``."""
    constructs: dict[str, dict[str, Any]] = {}
    purposes: dict[str, dict[str, Any]] = {}
    without_intent: list[dict[str, Any]] = []

    for qml_item in asking_items(qml):
        entry = inventory.items.get(qml_item["id"]) if inventory is not None else None
        facts = _item_facts(qml_item, entry or ItemEntry())
        if entry is None or entry_lacks_intent(entry, len(facts["rows"])):
            without_intent.append(facts)
            continue
        stated = [facts, *facts["rows"]]
        construct = next((f["construct"] for f in stated if is_stated(f["construct"])), None)
        if construct is not None:
            group = constructs.setdefault(
                construct_key(construct), {"name": construct.strip(), "items": []}
            )
        else:
            purpose = next(f["purpose"] for f in stated if f["purpose"])
            group = purposes.setdefault(purpose, {"purpose": purpose, "items": []})
        group["items"].append(facts)

    return {
        "exists": inventory is not None,
        "constructs": list(constructs.values()),
        "purposes": list(purposes.values()),
        "without_intent": without_intent,
        "coverage": goal_coverage(qml, inventory, kpi_tokens) if kpi_tokens is not None else None,
    }


def item_hints(qml: dict, inventory: ItemInventory | None) -> dict[str, dict[str, Any]]:
    """The entry's own facts for each item of ``qml`` that has an entry, in document order.

    ``reversed_rows`` counts the item's rows marked reverse-worded, so a battery
    whose item is not reversed can still say that some of its statements are.
    """
    if inventory is None:
        return {}
    hints: dict[str, dict[str, Any]] = {}
    for qml_item in asking_items(qml):
        entry = inventory.items.get(qml_item["id"])
        if entry is not None:
            facts = effective_facts(entry)
            row_count = len(row_texts(qml_item))
            hints[qml_item["id"]] = {
                **{name: facts[name] for name in _HINT_FACTS},
                "reversed_rows": sum(
                    1
                    for position in range(1, row_count + 1)
                    if effective_facts(entry, position)["reversed"]
                ),
            }
    return hints


def _item_facts(qml_item: dict[str, Any], entry: ItemEntry) -> dict[str, Any]:
    """One item of the view: the QML's facts, the entry's, and every row with its effective facts."""
    title = qml_item.get("title")
    return {
        "item_id": qml_item["id"],
        "item_kind": qml_item["kind"],
        "wording": plain_text(title) if isinstance(title, str) else "",
        **effective_facts(entry),
        "rows": [
            {"position": position, "wording": wording, **effective_facts(entry, position)}
            for position, wording in enumerate(row_texts(qml_item), start=1)
        ],
    }
