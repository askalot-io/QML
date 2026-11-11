"""The questionnaire inventory, schema ``inventory/v1`` (#1972).

An inventory is the one intermediate form between a source and its QML: an
imported printed questionnaire and a questionnaire the Designer builds are both
written as an inventory first, and the first QML version is generated from it.
It is stored as JSON in a ``questionnaire_inventory`` document beside the
questionnaire it produced; this model is what validates that JSON on every
write and read.

What it holds: sections with their purpose and mode; every question with the id
the source prints, the QML item id it is asked under, its answer type and
codes; routing as presumed preconditions; checks as presumed postconditions,
each marked when it is invented; external inputs (prefills, sample flags) as
``external`` questions; the scope table; and, for an import, the report.

Decisions:

- **The loader's id rule is checked here.** Every ``qml_id`` must be one the
  loader accepts (``qml_loader.is_readable_item_id`` and not a reserved id) and
  no two may be equal in lower case, the rule ``map_source_ids`` produces. The
  model does not re-derive ids: it refuses an inventory whose ids the
  questionnaire could not use, whoever assigned them.
- **Source ids are verbatim and may repeat.** Two printed questions numbered
  alike are two questions; the QML id is what tells them apart, so the scope
  table names a question by its ``qml_id``.
- **Nothing is dropped silently.** Every question appears in the scope table as
  ``in``, every ``in`` row that names a question names one that exists, and
  every ``out`` row says why. A source unit that is not a question (an
  instruction turned into a check, a scoring table) is a row without a
  ``qml_id``.
- **Provenance is optional.** A designed questionnaire has no pages and no
  printed jump text, so its inventory carries none.
- **Which QML version it describes is not in the content.** The record is
  written in the same transaction as version 1, whose id does not exist until
  then; the repository records it on the inventory document and its reader
  returns it beside this content.
- **Closed shape.** Unknown keys are refused, so a field renamed by a producer
  fails at the write instead of vanishing.
"""

from __future__ import annotations

from collections.abc import Iterator
from typing import Literal

from askalot_common.i18n import require_questionnaire_language
from pydantic import (
    BaseModel,
    ConfigDict,
    Field,
    ValidationError,
    field_validator,
    model_validator,
)

from askalot_qml.core.qml_loader import QMLLoader, is_readable_item_id
from askalot_qml.inventory.report import ImportReport

#: The schema tag every stored inventory carries.
INVENTORY_SCHEMA = "inventory/v1"

#: How an answer is given, before a QML control is chosen for it.
AnswerType = Literal[
    "single_choice",
    "multiple_choice",
    "yes_no",
    "number",
    "number_range",
    "short_text",
    "long_text",
]

#: Who completes a section: an interviewer reading it out, or the respondent.
SectionMode = Literal["interviewer", "self_completed"]

class _Closed(BaseModel):
    model_config = ConfigDict(extra="forbid")


class Provenance(_Closed):
    """Where in the source something was read: page and the printed text it came from."""

    page: int | None = Field(default=None, ge=1)
    source_text: str | None = None


class Code(_Closed):
    """One answer option: the code the source prints and its label."""

    value: int
    label: str = Field(min_length=1)


class PresumedPrecondition(_Closed):
    """Routing read from the source, as a QML predicate over earlier answers."""

    predicate: str = Field(min_length=1)
    hint: str | None = None
    provenance: Provenance | None = None


class PresumedPostcondition(_Closed):
    """An answer check. ``invented`` when the source does not state it as a hard rule."""

    predicate: str = Field(min_length=1)
    hint: str | None = None
    invented: bool
    provenance: Provenance | None = None


class Question(_Closed):
    """One source question and the QML item it becomes."""

    source_id: str = Field(min_length=1)
    qml_id: str
    text: str = Field(min_length=1)
    answer_type: AnswerType
    codes: list[Code] = Field(default_factory=list)
    min: float | None = None
    max: float | None = None
    external: bool = False
    preconditions: list[PresumedPrecondition] = Field(default_factory=list)
    postconditions: list[PresumedPostcondition] = Field(default_factory=list)
    provenance: Provenance | None = None

    @field_validator("qml_id")
    @classmethod
    def _loader_accepts(cls, value: str) -> str:
        if value in QMLLoader.RESERVED_ITEM_IDS or not is_readable_item_id(value):
            raise ValueError(f"qml_id {value!r} is not an item id the QML loader accepts")
        return value

    @model_validator(mode="after")
    def _codes_are_distinct(self) -> Question:
        values = [code.value for code in self.codes]
        if len(values) != len(set(values)):
            raise ValueError(f"question {self.qml_id!r} lists an answer code twice")
        return self


class Section(_Closed):
    """A part of the questionnaire, with what it is for and who completes it."""

    id: str = Field(min_length=1)
    title: str = Field(min_length=1)
    purpose: str = Field(min_length=1)
    mode: SectionMode
    preconditions: list[PresumedPrecondition] = Field(default_factory=list)
    questions: list[Question] = Field(default_factory=list)
    provenance: Provenance | None = None


class ScopeEntry(_Closed):
    """One unit of the source, kept (``in``) or left out (``out``) with the reason."""

    unit: str = Field(min_length=1)
    status: Literal["in", "out"]
    qml_id: str | None = None
    reason: str | None = None
    provenance: Provenance | None = None

    @model_validator(mode="after")
    def _out_says_why(self) -> ScopeEntry:
        if self.status == "out":
            if not (self.reason and self.reason.strip()):
                raise ValueError(f"scope unit {self.unit!r} is out and gives no reason")
            if self.qml_id is not None:
                raise ValueError(
                    f"scope unit {self.unit!r} is out yet names qml_id {self.qml_id!r}"
                )
        return self


class InventedCheck(_Closed):
    """An invented postcondition and the question it checks."""

    qml_id: str
    predicate: str
    hint: str | None


class Inventory(_Closed):
    """A whole questionnaire inventory (``inventory/v1``)."""

    schema_: Literal["inventory/v1"] = Field(alias="schema", default=INVENTORY_SCHEMA)
    source_language: str
    sections: list[Section] = Field(min_length=1)
    scope: list[ScopeEntry]
    report: ImportReport | None = None

    model_config = ConfigDict(extra="forbid", populate_by_name=True)

    @field_validator("source_language")
    @classmethod
    def _is_a_questionnaire_language(cls, value: str) -> str:
        """The one rule a questionnaire's language obeys, in its canonical spelling."""
        return require_questionnaire_language(value)

    def questions(self) -> Iterator[Question]:
        """Every question, in section order."""
        for section in self.sections:
            yield from section.questions

    def invented_checks(self) -> list[InventedCheck]:
        """Every invented postcondition, in question order."""
        return [
            InventedCheck(qml_id=question.qml_id, predicate=check.predicate, hint=check.hint)
            for question in self.questions()
            for check in question.postconditions
            if check.invented
        ]

    @model_validator(mode="after")
    def _ids_and_scope_agree(self) -> Inventory:
        section_ids = [section.id for section in self.sections]
        if len(section_ids) != len(set(section_ids)):
            raise ValueError("two sections share an id")

        qml_ids: set[str] = set()
        for question in self.questions():
            folded = question.qml_id.lower()
            if folded in qml_ids:
                raise ValueError(
                    f"qml_id {question.qml_id!r} is used twice (ids are compared in lower case)"
                )
            qml_ids.add(folded)

        units = [entry.unit for entry in self.scope]
        if len(units) != len(set(units)):
            raise ValueError("the scope table lists a unit twice")

        scoped: dict[str, int] = {}
        for entry in self.scope:
            if entry.qml_id is None:
                continue
            if entry.qml_id.lower() not in qml_ids:
                raise ValueError(
                    f"scope unit {entry.unit!r} names qml_id {entry.qml_id!r}, which no question has"
                )
            scoped[entry.qml_id.lower()] = scoped.get(entry.qml_id.lower(), 0) + 1

        for question in self.questions():
            count = scoped.get(question.qml_id.lower(), 0)
            if count == 0:
                raise ValueError(
                    f"question {question.qml_id!r} (source {question.source_id!r}) is missing from the scope table"
                )
            if count > 1:
                raise ValueError(
                    f"question {question.qml_id!r} is in the scope table more than once"
                )
        return self


def parse_inventory(content: str) -> Inventory:
    """Validate stored inventory JSON. Raises ``pydantic.ValidationError`` on any defect."""
    return Inventory.model_validate_json(content)


def serialize_inventory(inventory: Inventory) -> str:
    """The JSON a ``questionnaire_inventory`` document stores."""
    return inventory.model_dump_json(by_alias=True)


def validation_problems(exc: ValidationError, *, root: str, limit: int | None = None) -> str:
    """Where a model failed validation, as ``loc: msg`` pairs joined by ``; ``.

    The text names locations and Pydantic's messages only, never the values it
    would quote, so it is safe to show or store. ``root`` labels an error on
    the whole object (an empty ``loc``); ``limit`` keeps the first that many.
    """
    errors = exc.errors(include_input=False, include_url=False)
    return "; ".join(
        f"{'.'.join(str(part) for part in error['loc']) or root}: {error['msg']}"
        for error in errors[:limit]
    )
