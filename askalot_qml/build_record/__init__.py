"""The build record of an imported or designed questionnaire (#1972).

A build record lists a questionnaire's source questions before any QML exists,
each with the id the source prints. This package holds what reads and checks
it: ``model`` is the ``inventory/v1`` schema (and the validation-problem text
every caller reports), ``report`` the import report it
carries, and ``ids`` maps a source id to the QML item id the questionnaire
asks it under.
"""

from askalot_qml.build_record.ids import map_source_ids
from askalot_qml.build_record.model import (
    BUILD_RECORD_SCHEMA,
    BuildRecord,
    Code,
    InventedCheck,
    PresumedPostcondition,
    PresumedPrecondition,
    Provenance,
    Question,
    ScaleUndeclaredReason,
    ScopeEntry,
    Section,
    normalized_scale,
    parse_build_record,
    scale_statement_problem,
    serialize_build_record,
    validation_problems,
)
from askalot_qml.build_record.report import (
    ImportReport,
    RemainingProblem,
    UndeclaredScale,
    report_summary,
)

__all__ = [
    "BUILD_RECORD_SCHEMA",
    "Code",
    "ImportReport",
    "InventedCheck",
    "BuildRecord",
    "PresumedPostcondition",
    "PresumedPrecondition",
    "Provenance",
    "Question",
    "RemainingProblem",
    "ScaleUndeclaredReason",
    "ScopeEntry",
    "Section",
    "UndeclaredScale",
    "map_source_ids",
    "normalized_scale",
    "parse_build_record",
    "report_summary",
    "scale_statement_problem",
    "serialize_build_record",
    "validation_problems",
]
