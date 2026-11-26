"""Goal coverage read off an item inventory: which KPIs the asked items name, and which they leave out.

Everything here is computed from the links an inventory states and nothing is
judged: an item, or a battery row, covers a KPI exactly when its entry names
that KPI's token. The caller supplies the tokens the project's paper numbers,
because nothing in this package reads a stored row.

- ``covering_links`` lists the asked items and battery rows that name a KPI.
  Only items the QML asks are walked, so an entry whose item is gone covers
  nothing. A battery is listed row by row with each row's own KPIs laid over
  its item's, so a three-row battery naming one KPI is three links: it collects
  that KPI with several items. An item is open-ended when its control is
  ``Textarea``, the only control that collects free text.
- ``goal_coverage`` answers the three lists a reader acts on: the paper's KPIs
  no link names (in the paper's order), the asked items that serve nothing
  stated (in the QML's order), and the named KPIs the paper does not number. An
  item serves nothing stated when it, or any one of its rows, names no KPI and
  states no purpose; an item with a purpose and no KPI is covered. Without an
  inventory there is no coverage to state, and the answer is ``None``.
- ``collection_modes`` says how each KPI is collected, over the links of one
  questionnaire or of several.
"""

from __future__ import annotations

from collections.abc import Iterable, Sequence
from typing import Any

from askalot_qml.inventory.model import ItemEntry, ItemInventory, row_texts
from askalot_qml.inventory.warnings import asking_items, effective_facts, stated_kpis

#: The one input control whose answer is free text.
_OPEN_ENDED_CONTROL = "Textarea"


def covering_links(qml: dict, inventory: ItemInventory | None) -> list[dict]:
    """One link per asked item or battery row that names a KPI, in document order.

    Each link is ``{"item_id", "position", "kpis", "open_ended"}``; ``position``
    is the row's, counted from 1, and ``None`` for an item without rows.
    """
    if inventory is None:
        return []
    links: list[dict] = []
    for qml_item in asking_items(qml):
        entry = inventory.items.get(qml_item["id"])
        if entry is None:
            continue
        open_ended = (qml_item.get("input") or {}).get("control") == _OPEN_ENDED_CONTROL
        for position, kpis in stated_kpis(entry, len(row_texts(qml_item))):
            links.append(
                {
                    "item_id": qml_item["id"],
                    "position": position,
                    "kpis": kpis,
                    "open_ended": open_ended,
                }
            )
    return links


def goal_coverage(
    qml: dict, inventory: ItemInventory | None, kpi_tokens: Sequence[str]
) -> dict[str, Any] | None:
    """What ``inventory`` leaves uncovered of ``kpi_tokens`` and of ``qml``'s items; ``None`` without an inventory."""
    if inventory is None:
        return None
    links = covering_links(qml, inventory)
    named = {kpi for link in links for kpi in link["kpis"]}
    known = set(kpi_tokens)
    unknown = dict.fromkeys(
        (link["item_id"], kpi) for link in links for kpi in link["kpis"] if kpi not in known
    )
    return {
        "kpis_without_items": [kpi for kpi in dict.fromkeys(kpi_tokens) if kpi not in named],
        "items_without_kpi_or_purpose": [
            qml_item["id"]
            for qml_item in asking_items(qml)
            if _serves_nothing_stated(qml_item, inventory.items.get(qml_item["id"]))
        ],
        "unknown_kpis": [{"item_id": item_id, "kpi": kpi} for item_id, kpi in unknown],
    }


def collection_modes(links: Iterable[dict], kpi_tokens: Sequence[str]) -> dict[str, str]:
    """How each of ``kpi_tokens`` is collected by ``links``.

    ``not_collected`` when no link names it, ``open_ended`` when every link
    that does is open-ended, ``one_item`` for exactly one link, and
    ``several_items`` otherwise.
    """
    naming: dict[str, list[bool]] = {kpi: [] for kpi in kpi_tokens}
    for link in links:
        for kpi in link["kpis"]:
            if kpi in naming:
                naming[kpi].append(bool(link["open_ended"]))
    return {kpi: _mode(open_ended) for kpi, open_ended in naming.items()}


def _mode(open_ended: list[bool]) -> str:
    if not open_ended:
        return "not_collected"
    if all(open_ended):
        return "open_ended"
    return "one_item" if len(open_ended) == 1 else "several_items"


def _serves_nothing_stated(qml_item: dict[str, Any], entry: ItemEntry | None) -> bool:
    """Whether the item, or any one of its rows, names no KPI and states no purpose."""
    if entry is None:
        return True
    row_count = len(row_texts(qml_item))
    positions: list[int | None] = list(range(1, row_count + 1)) if row_count else [None]
    for position in positions:
        facts = effective_facts(entry, position)
        if not facts["kpis"] and not facts["purpose"]:
            return True
    return False
