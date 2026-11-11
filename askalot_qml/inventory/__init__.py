"""The inventory of an imported or designed questionnaire (#1972).

An inventory lists a questionnaire's source questions before any QML exists,
each with the id the source prints. This package holds what reads and checks
it: ``model`` is the ``inventory/v1`` schema (and the validation-problem text
every caller reports), ``report`` the import report it
carries, and ``ids`` maps a source id to the QML item id the questionnaire
asks it under.
"""

from askalot_qml.inventory.ids import map_source_ids
from askalot_qml.inventory.model import (
    INVENTORY_SCHEMA,
    Code,
    InventedCheck,
    Inventory,
    PresumedPostcondition,
    PresumedPrecondition,
    Provenance,
    Question,
    ScopeEntry,
    Section,
    parse_inventory,
    serialize_inventory,
    validation_problems,
)
from askalot_qml.inventory.report import ImportReport, RemainingProblem, report_summary

__all__ = [
    "INVENTORY_SCHEMA",
    "Code",
    "ImportReport",
    "InventedCheck",
    "Inventory",
    "PresumedPostcondition",
    "PresumedPrecondition",
    "Provenance",
    "Question",
    "RemainingProblem",
    "ScopeEntry",
    "Section",
    "map_source_ids",
    "parse_inventory",
    "report_summary",
    "serialize_inventory",
    "validation_problems",
]
