"""Where a questionnaire's QML and its item inventory disagree, as validation-shaped issues.

``inventory_warnings`` is a pure function over a loaded QML (the dict
``QMLLoader.load_from_string`` returns) and a parsed inventory. Every caller
that holds both computes it for itself; it is deliberately no part of the
publish gate, whose verdicts are cached on the QML text alone and would go
stale when only the inventory changes. Nothing here blocks a save or a publish.

Issue types:

- ``item_without_entry``: the QML asks an item the inventory has no entry for.
  Items of kind ``Question``, ``QuestionGroup`` and ``MatrixQuestion`` need an
  entry, wherever they sit (a roster's inner items included); a ``Comment``
  asks nothing and never needs one.
- ``entry_without_item``: an entry names an item the QML does not ask, or
  states facts for a row position its item does not have.
- ``intent_missing``: an entry states no kind of measure, or neither a
  construct nor a purpose. A KPI is not required. A battery is judged row by
  row, each row on its own facts laid over its item's, so a row stating only a
  reverse mark inherits the rest; when every row lacks the same thing the item
  is reported once, otherwise each lacking row is.
- ``rows_changed``: an entry states row facts and the item's rows are not the
  rows they were stated against (their digest differs, or none was recorded
  because the item did not exist yet), so a position may now name another
  statement.
- ``unknown_kpi``: an entry of an asked item, or one of its rows, names a KPI
  the project's paper does not number. It is raised once per item and token,
  and only when the caller passes the paper's KPI tokens: a caller that holds
  no paper passes ``None`` and raises nothing of the kind.
- ``no_inventory``: the questionnaire has no inventory. It is a notice
  (severity ``info``) and the only issue then: a questionnaire that never had
  an inventory is not reported item by item.

Wording never raises anything: the inventory holds none, so an item reworded
in the QML agrees with its entry as before. Only the row texts of an entry
that states row facts are compared, through the digest.

Issues carry the validator's shape (``item_id``, ``severity``, ``type``,
``message``, ``suggestion``) so every reader of validation issues can show
them; the type's label for a page is in ``publish_gate.ISSUE_TYPE_LABELS``.
A message states what is the case and names no remedy, because the people who
read it cannot edit the inventory themselves; ``suggestion`` is empty. Issues
come in the QML's document order, entries without an item last.
"""

from __future__ import annotations

from collections import Counter
from collections.abc import Sequence
from typing import Any

from askalot_qml.inventory.model import ItemEntry, ItemInventory, row_texts, rows_digest

#: The QML item kinds that ask something, and so need an inventory entry.
ENTRY_ITEM_KINDS: tuple[str, ...] = ("Question", "QuestionGroup", "MatrixQuestion")

#: The facts an entry and a row state, in the order an answer lists them.
INVENTORY_FACTS: tuple[str, ...] = ("construct", "kind", "kpis", "purpose", "reversed", "origin")


def asking_items(qml: dict[str, Any]) -> list[dict[str, Any]]:
    """The loaded QML's items that need an inventory entry, in document order."""
    return [item for item in qml.get("items", []) if item.get("kind") in ENTRY_ITEM_KINDS]


def effective_facts(entry: ItemEntry, position: int | None = None) -> dict[str, Any]:
    """The facts of an entry, or of its row at ``position`` laid over them, as plain data."""
    facts = entry.model_dump(mode="json", include=set(INVENTORY_FACTS))
    row = entry.rows.get(position) if position is not None else None
    if row is not None:
        facts.update(row.model_dump(mode="json", exclude_none=True))
    return {name: facts[name] for name in INVENTORY_FACTS}


def stated_kpis(entry: ItemEntry, row_count: int) -> list[tuple[int | None, list[str]]]:
    """The KPIs an asked item states, as ``(position, tokens)`` pairs that name at least one.

    An item without rows answers under position ``None``. A battery answers row
    by row, each row's own KPIs laid over its item's, so a row that states none
    carries the item's; facts for a position the item does not have are left out.
    """
    positions: list[int | None] = list(range(1, row_count + 1)) if row_count else [None]
    stated = [(position, effective_facts(entry, position)["kpis"]) for position in positions]
    return [(position, list(kpis)) for position, kpis in stated if kpis]


def missing_intent(facts: dict[str, Any]) -> str | None:
    """What ``facts`` leave unstated that intent needs, as a clause, or ``None``."""
    no_kind = not facts["kind"]
    no_aim = not is_stated(facts["construct"]) and not facts["purpose"]
    if no_kind and no_aim:
        return "states no kind of measure, and neither a construct nor a purpose"
    if no_kind:
        return "states no kind of measure"
    if no_aim:
        return "states neither a construct nor a purpose"
    return None


def entry_lacks_intent(entry: ItemEntry, row_count: int) -> bool:
    """Whether the entry, or any of its item's ``row_count`` rows, is missing intent."""
    return bool(_intent_gaps(entry, row_count))


def inventory_warnings(
    qml: dict, inventory: ItemInventory | None, *, kpi_tokens: Sequence[str] | None = None
) -> list[dict]:
    """Every disagreement between ``qml`` and ``inventory``, in document order.

    ``kpi_tokens`` are the KPIs the project's paper numbers; ``None`` means the
    caller holds no paper to compare with, and no ``unknown_kpi`` is raised.
    """
    if inventory is None:
        return [_issue(None, "no_inventory", "This questionnaire has no item inventory.", "info")]

    known = set(kpi_tokens) if kpi_tokens is not None else None
    issues: list[dict] = []
    asked: set[str] = set()
    for item in asking_items(qml):
        item_id = item["id"]
        asked.add(item_id)
        entry = inventory.items.get(item_id)
        if entry is None:
            issues.append(
                _issue(item_id, "item_without_entry", f"The inventory has no entry for item `{item_id}`.")
            )
            continue
        rows = row_texts(item)
        for position, gap in _intent_gaps(entry, len(rows)):
            where = f" for row {position}" if position is not None else ""
            issues.append(
                _issue(
                    item_id,
                    "intent_missing",
                    f"The inventory entry for item `{item_id}` {gap}{where}.",
                )
            )
        for position in sorted(entry.rows):
            if position > len(rows):
                has = f"{len(rows)} rows" if rows else "no rows"
                issues.append(
                    _issue(
                        item_id,
                        "entry_without_item",
                        f"The inventory entry for item `{item_id}` states facts for row {position}, "
                        f"and the item has {has}.",
                    )
                )
        if entry.rows and entry.rows_digest != rows_digest(rows):
            issues.append(
                _issue(
                    item_id,
                    "rows_changed",
                    f"The rows of item `{item_id}` are not the rows its inventory entry "
                    "states row facts for.",
                )
            )
        if known is not None:
            named = dict.fromkeys(kpi for _, kpis in stated_kpis(entry, len(rows)) for kpi in kpis)
            for kpi in named:
                if kpi not in known:
                    issues.append(
                        _issue(
                            item_id,
                            "unknown_kpi",
                            f"The inventory entry for item `{item_id}` names `{kpi}`, "
                            "which the paper does not number.",
                        )
                    )

    for item_id in inventory.items:
        if item_id not in asked:
            issues.append(
                _issue(
                    item_id,
                    "entry_without_item",
                    f"The inventory has an entry for `{item_id}`, which the questionnaire does not ask.",
                )
            )
    return issues


def warning_counts(issues: list[dict]) -> dict[str, int]:
    """How many issues there are of each type."""
    return dict(Counter(issue["type"] for issue in issues))


def _intent_gaps(entry: ItemEntry, row_count: int) -> list[tuple[int | None, str]]:
    """What intent is missing, per row position, or once under ``None`` when it is the whole item's."""
    if row_count == 0:
        gap = missing_intent(effective_facts(entry))
        return [(None, gap)] if gap else []
    gaps = {
        position: missing_intent(effective_facts(entry, position))
        for position in range(1, row_count + 1)
    }
    shared = set(gaps.values())
    if len(shared) == 1:
        gap = shared.pop()
        return [(None, gap)] if gap else []
    return [(position, gap) for position, gap in gaps.items() if gap]


def is_stated(text: str | None) -> bool:
    """Whether ``text`` says anything: it is neither missing nor blank."""
    return bool(text and text.strip())


def _issue(item_id: str | None, issue_type: str, message: str, severity: str = "warning") -> dict:
    return {
        "item_id": item_id,
        "severity": severity,
        "type": issue_type,
        "message": message,
        "suggestion": "",
    }
