"""The import report: the section of an imported questionnaire's build record that says what happened (#1972).

An import's report is stored inside the build record it produced, not as a
document of its own, so the reader that returns the build record returns the
report with it. This module holds the two halves:

- :class:`ImportReport` is what only the import run knows and stores: whether
  filled-in answers were discarded, whether a Markdown source was assumed blank,
  which pages went to vision, the judgement agent's unresolved objections and
  the problems Z3 still reports.
- :func:`report_summary` derives the rest from the build record itself (the scope
  table's counts and OUT reasons, the invented checks, the source-id mapping,
  the printed rating scales left undeclared and why), so nothing is stored
  twice and the two can never disagree.

Nothing here may carry source answers: a report holds counts, page numbers,
ids and the engine's own messages.
"""

from __future__ import annotations

from typing import TYPE_CHECKING, Any

from pydantic import BaseModel, ConfigDict, Field

if TYPE_CHECKING:
    from askalot_qml.build_record.model import BuildRecord


class RemainingProblem(BaseModel):
    """A problem the QML still has when the correction loop ends, explained."""

    model_config = ConfigDict(extra="forbid")

    type: str = Field(min_length=1)
    message: str = Field(min_length=1)
    item_id: str | None = None


class UndeclaredScale(BaseModel):
    """A question whose source prints a rating scale that carries no declaration.

    ``reason`` is the build record's ``scale_undeclared_reason``: how the printed
    codes differ from a declarable scale. The questionnaire keeps the source's
    codes; nothing re-codes them.
    """

    model_config = ConfigDict(extra="forbid")

    qml_id: str
    source_id: str
    reason: str = Field(min_length=1)


class ImportReport(BaseModel):
    """What an import run records about itself."""

    model_config = ConfigDict(extra="forbid")

    answers_discarded: bool
    markdown_assumed_blank: bool = False
    vision_pages: list[int] = Field(default_factory=list)
    gate_objections: list[str] = Field(default_factory=list)
    remaining_problems: list[RemainingProblem] = Field(default_factory=list)


def report_summary(build_record: BuildRecord) -> dict[str, Any]:
    """The report as a reader shows it: stored facts plus what the build record implies.

    ``scope`` counts the units kept and left out and lists each OUT unit with
    its reason; ``invented_checks`` lists every invented postcondition;
    ``id_mapping`` pairs each source id with its QML item id, in question
    order; ``undeclared_scales`` lists each question that states why its
    printed rating scale is not declared. ``import`` is the stored
    :class:`ImportReport`, or ``None`` for a build record no import wrote.
    """
    out = [entry for entry in build_record.scope if entry.status == "out"]
    return {
        "scope": {
            "in": len(build_record.scope) - len(out),
            "out": len(out),
            "out_units": [{"unit": entry.unit, "reason": entry.reason} for entry in out],
        },
        "invented_checks": [check.model_dump() for check in build_record.invented_checks()],
        "id_mapping": [
            {"source_id": question.source_id, "qml_id": question.qml_id}
            for question in build_record.questions()
        ],
        "undeclared_scales": [
            UndeclaredScale(
                qml_id=question.qml_id,
                source_id=question.source_id,
                reason=question.scale_undeclared_reason,
            ).model_dump()
            for question in build_record.questions()
            if question.scale_undeclared_reason is not None
        ],
        "import": build_record.report.model_dump() if build_record.report is not None else None,
    }
