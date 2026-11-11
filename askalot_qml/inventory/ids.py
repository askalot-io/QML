"""Map a printed questionnaire's question ids to QML item ids (#1972).

An imported questionnaire keeps every source question's id verbatim in its
inventory and asks it under a QML item id. A source id is rarely one the loader
accepts (``1``, ``Q1a.``, ``2.3 (b)``), so this module derives one, and the
inventory records the pair.

Decisions:

- **The loader's rule is the judge.** Every output passes
  ``qml_loader.is_readable_item_id`` and is not one of
  ``QMLLoader.RESERVED_ITEM_IDS``, the same checks the loader runs; nothing
  here copies them.
- **Recognisable first.** The id keeps the source's characters that may
  continue a Python identifier (after NFKC), joins every other run with one
  ``_``, and starts with ``Q`` when it would start with a digit or be empty:
  ``1`` -> ``Q1``, ``Q1a.`` -> ``Q1a``. A name the loader refuses as a
  keyword, a sandbox name (``len``, ``math``) or a reserved id (``codeInit``)
  is prefixed ``Q_``.
- **Distinct in lower case.** Two ids equal in lower case are taken as a
  collision, because the dataset layers compare column names that way (Silver
  refuses names equal under ``str.lower``). The later source gets the
  smallest free ``_<n>`` suffix, ``n`` from 2.
- **Deterministic.** The result depends only on the source ids and their
  order: the same inventory maps to the same ids on every call.
"""

from __future__ import annotations

import unicodedata
from collections.abc import Sequence

from askalot_qml.core.qml_loader import QMLLoader, is_readable_item_id

#: Starts an id that would otherwise start with a digit or be empty.
_PREFIX = "Q"
#: Starts an id whose base the loader refuses as a name (keyword, sandbox name, reserved id).
_SAFE_PREFIX = "Q_"


def _accepted(item_id: str) -> bool:
    return item_id not in QMLLoader.RESERVED_ITEM_IDS and is_readable_item_id(item_id)


def _base_id(source_id: str) -> str:
    """The id a source id reads as, before collisions are resolved."""
    pieces: list[str] = []
    gap = False
    for char in unicodedata.normalize("NFKC", source_id):
        if f"_{char}".isidentifier():
            if gap and pieces:
                pieces.append("_")
            pieces.append(char)
            gap = False
        else:
            gap = True
    base = "".join(pieces).strip("_")
    if not base.isidentifier():
        base = f"{_PREFIX}{base}"
    if not _accepted(base):
        base = f"{_SAFE_PREFIX}{base}"
    if not _accepted(base):
        raise ValueError(f"source id {source_id!r} maps to no item id the loader accepts")
    return base


def map_source_ids(source_ids: Sequence[str]) -> list[str]:
    """Return one QML item id per source id, in the same order.

    Every id is accepted by the loader, and no two are equal in lower case.
    A source id listed twice gets two ids, as two questions numbered alike do.

    Raises:
        ValueError: when a source id yields no id the loader accepts, which
            the prefixes rule out for every string; it is the guard that a
            changed loader rule cannot pass unnoticed.
    """
    taken: set[str] = set()
    mapped: list[str] = []
    for source_id in source_ids:
        base = _base_id(source_id)
        candidate = base
        suffix = 2
        while candidate.lower() in taken:
            candidate = f"{base}_{suffix}"
            suffix += 1
        taken.add(candidate.lower())
        mapped.append(candidate)
    return mapped
