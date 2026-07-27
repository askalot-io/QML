"""
Shared helper: enumerate the ``external: true`` items of a QML questionnaire.

Targetor's external-input mapping admin UI (QML External Inputs plan, U6) needs
the list of prefill-eligible items for a questionnaire, plus each item's
declared domain codes so the operator can author a coercion (source label →
domain code) that surfaces the valid targets. Loading + flattening the QML is
the loader's job, so this helper mirrors ``questionnaire_item_count`` exactly —
one canonical load path, no per-service reimplementation — and like it takes
QML *content*, since Postgres is the canonical store.
"""

import logging
from typing import Any

from askalot_qml.core.controls import label_keys
from askalot_qml.core.qml_loader import QMLLoader


def _domain_codes(item: dict[str, Any]) -> list[Any]:
    """The item's declared domain codes for the coercion editor.

    Choice controls (Radio/Dropdown/Checkbox/Switch): the integer ``labels``
    keys. Switch without labels: {0, 1}. Numeric / Textarea controls have no
    discrete code set, so return an empty list (the editor then offers a free
    value)."""
    input_spec = item.get("input") or {}
    codes = label_keys(input_spec)
    if codes:
        return codes
    if input_spec.get("control", "") == "Switch":
        return [0, 1]
    return []


def list_external_items(
    qml_content: str,
    logger: logging.Logger | None = None,
) -> list[dict[str, Any]]:
    """Return the ``external: true`` items of a questionnaire, in document order.

    Each entry: ``{"id", "title", "control", "domain_codes", "labels"}``. Only
    items flagged ``external`` are returned — a questionnaire with none yields
    an empty list (the mapping panel then shows an empty state).

    Parses ``qml_content`` via ``QMLLoader`` (the canonical path, mirroring
    ``questionnaire_item_count``). Fails loud on malformed QML — it never
    silently returns [] for a broken document.
    """
    loader = QMLLoader(logger=logger)
    parsed_qml = loader.load_from_string(qml_content)
    external: list[dict[str, Any]] = []
    for item in parsed_qml.get("items", []):
        if not item.get("external"):
            continue
        input_spec = item.get("input") or {}
        external.append(
            {
                "id": item.get("id"),
                "title": item.get("title", item.get("id")),
                "control": input_spec.get("control", ""),
                "domain_codes": _domain_codes(item),
                "labels": input_spec.get("labels") or {},
            }
        )
    return external
