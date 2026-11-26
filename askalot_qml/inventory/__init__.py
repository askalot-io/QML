"""The living item inventory of a questionnaire: what each item is meant to measure.

``model`` is the closed ``item-inventory/v1`` schema with its patch operations
and the row rules of a battery; ``warnings`` compares an inventory with a
loaded QML and answers the disagreements; ``coverage`` reads goal coverage off
the KPIs the entries name; ``view`` joins the two into the plain facts a
readable document is drawn from. Those four are pure functions over content
the caller holds. ``project`` alone reads stored rows: it answers the
instrument tables and KPI collection modes of a whole project.
"""

from askalot_qml.inventory.coverage import collection_modes, covering_links, goal_coverage
from askalot_qml.inventory.model import (
    INVENTORY_SCHEMA,
    MEASURE_KINDS,
    ORIGIN_MODES,
    PURPOSES,
    QML_OWNED_KEYS,
    ItemEntry,
    ItemInventory,
    Origin,
    PatchResult,
    RowFacts,
    apply_patch,
    construct_key,
    empty_inventory,
    parse_inventory,
    plain_text,
    row_texts,
    rows_digest,
    serialize_inventory,
    without_kpis,
)
from askalot_qml.inventory.project import (
    gather_instrument_sources,
    instrument_design_from_sources,
    instrument_tables_from_sources,
    project_instrument_design,
    project_instrument_tables,
)
from askalot_qml.inventory.view import inventory_view_facts, item_hints
from askalot_qml.inventory.warnings import (
    ENTRY_ITEM_KINDS,
    INVENTORY_FACTS,
    asking_items,
    inventory_warnings,
    warning_counts,
)

__all__ = [
    "ENTRY_ITEM_KINDS",
    "INVENTORY_FACTS",
    "INVENTORY_SCHEMA",
    "MEASURE_KINDS",
    "ORIGIN_MODES",
    "PURPOSES",
    "QML_OWNED_KEYS",
    "ItemEntry",
    "ItemInventory",
    "Origin",
    "PatchResult",
    "RowFacts",
    "apply_patch",
    "asking_items",
    "collection_modes",
    "construct_key",
    "covering_links",
    "empty_inventory",
    "gather_instrument_sources",
    "goal_coverage",
    "instrument_design_from_sources",
    "instrument_tables_from_sources",
    "inventory_view_facts",
    "inventory_warnings",
    "item_hints",
    "parse_inventory",
    "plain_text",
    "project_instrument_design",
    "project_instrument_tables",
    "row_texts",
    "rows_digest",
    "serialize_inventory",
    "warning_counts",
    "without_kpis",
]
