"""The living item inventory of a questionnaire: its stored model and its patch operations.

An inventory states what each item of one questionnaire is meant to measure. It
sits between the Research Paper, which holds the goals, and the QML, which
holds the asking, and refers to both by id: an entry is keyed by the QML item
id and names KPIs by the token the paper numbers them with. It is stored as
JSON in a ``questionnaire_item_inventory`` document; this model validates that
JSON on every write and read.

What an entry holds: the construct the item measures (free text), its kind of
measure (a fixed list), the KPIs it serves, a purpose for an item that serves
none (a fixed list), whether it is reverse-worded, and where its wording comes
from.

What a "row" is. A battery is one QML item with several statements, and an
entry may state any of its facts again for one statement where that statement
differs (one reverse-worded statement, say):

- ``QuestionGroup``: a row is one entry of the item's ``questions`` list.
- ``MatrixQuestion``: a row is one entry of the item's ``rows`` list (its
  ``columns`` are not rows).
- ``Question``: has no rows.

Rows carry no ids in QML, so a row fact is keyed by the row's position, counted
from 1 in document order.

Decisions:

- **Meaning only.** Wording, labels, codes, scales, answer types and conditions
  live in the QML and nowhere else, so a key that belongs there is refused by
  name instead of being stored as a second copy that could disagree.
- **Closed shape.** Any other unknown key is refused too, so a misspelt field
  fails at the write instead of vanishing.
- **Written as a patch of whole entries.** ``apply_patch`` takes renames,
  removes and upserts; an upsert replaces that item's entry whole, so a field
  the new entry leaves out is gone. Renames apply first, then removes, then
  upserts. The patch applies entirely or not at all, and a refused patch
  answers every refusal at once.
- **The QML is not consulted for acceptance.** An entry for an item the QML
  does not ask (yet) is accepted, as are an entry with no kind and one with no
  construct and no purpose: stating meaning comes before writing the item, and
  those states are warnings (``warnings``), never refusals. KPI tokens are
  stored as given.
- **A re-id is never guessed.** ``rename`` moves an entry whole to a new id; it
  is refused when the old id has no entry or the new id already has one.
- **Row facts remember the rows they were stated against.** An entry with row
  facts records a digest of the item's row texts as they stood when the facts
  were stated (``rows_digest``), so a later reorder, insert or rewording of
  the rows can be told from the rows the positions were chosen for. It is
  computed here and never accepted from the caller, from the QML the writer
  read: ``rows_qml`` when the caller passes one, else ``qml``. It is ``None``
  when the item is not in that QML.
- **Only stating row facts stamps the digest.** An upsert whose ``rows`` equal
  the stored entry's (same positions, same facts) keeps the stored digest,
  whatever else of the entry it changes: a new KPI says nothing about which
  statement a position names, so it never hides rows that changed. Such rows
  are confirmed on purpose, with ``rows_confirmed: true`` on the upserted
  entry, which stamps the digest although the row facts are the same.
  ``rows_confirmed`` is a word of the patch and never stored; on an entry
  without row facts it is refused.
- **Constructs group by name.** Two names equal after trimming and case
  folding are one construct (``construct_key``); there is no construct
  registry to keep in step.
"""

from __future__ import annotations

import hashlib
import html
import json
import re
import warnings
from dataclasses import dataclass
from typing import Any, Literal, get_args

from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

#: The stored format tag of a living item inventory.
INVENTORY_SCHEMA = "item-inventory/v1"

MeasureKind = Literal[
    "opinion", "feeling", "behaviour", "evaluation", "intention", "knowledge", "fact"
]
Purpose = Literal["screening", "demographics", "routing", "administrative"]
OriginMode = Literal["new", "verbatim", "adapted"]

#: What an item can measure.
MEASURE_KINDS: tuple[str, ...] = get_args(MeasureKind)

#: Why an item that serves no KPI is asked.
PURPOSES: tuple[str, ...] = get_args(Purpose)

#: Whether a wording was written new, taken verbatim from an instrument, or adapted from one.
ORIGIN_MODES: tuple[str, ...] = get_args(OriginMode)

#: Keys whose only home is the QML; an entry or a row carrying one is refused by name.
QML_OWNED_KEYS: tuple[str, ...] = (
    "text",
    "title",
    "label",
    "labels",
    "codes",
    "scale",
    "answer_type",
    "preconditions",
    "postconditions",
)

#: The key of an upserted entry that confirms its row facts against the rows as
#: they now stand. It belongs to the patch: the stored model has no such field.
ROWS_CONFIRMED_KEY = "rows_confirmed"

#: The QML item kinds that hold rows, with the list each keeps them in.
_ROW_FIELDS = {"QuestionGroup": "questions", "MatrixQuestion": "rows"}

_TAG = re.compile(r"</?[A-Za-z][^>]*>")
_LINK = re.compile(r"!?\[([^\]]*)\]\([^)]*\)")
_STRONG = re.compile(r"(\*\*|__)(.+?)\1")
_EMPHASIS = re.compile(r"(?<!\w)\*(?!\s)(.+?)(?<!\s)\*(?!\w)")
_CODE = re.compile(r"`([^`]*)`")


class _Closed(BaseModel):
    model_config = ConfigDict(extra="forbid", frozen=True)


class Origin(_Closed):
    """Where an item's wording comes from: written new, or a named instrument's item."""

    mode: OriginMode
    instrument: str | None = None
    item: str | None = None

    @model_validator(mode="after")
    def _a_borrowed_wording_names_its_instrument(self) -> Origin:
        if self.mode != "new" and not (self.instrument and self.instrument.strip()):
            raise ValueError(f"states an origin of mode '{self.mode}' that names no instrument")
        return self


# ``construct`` is the fact's name in the stored format and on every reader; it
# takes the name of a deprecated pydantic classmethod, which pydantic reports
# with a warning as each class is built.
with warnings.catch_warnings():
    warnings.filterwarnings("ignore", message='Field name "construct"', category=UserWarning)

    class RowFacts(_Closed):
        """The facts one row of a battery states for itself; an unstated fact is its item's."""

        construct: str | None = None
        kind: MeasureKind | None = None
        kpis: list[str] | None = None
        purpose: Purpose | None = None
        reversed: bool | None = None
        origin: Origin | None = None


    class ItemEntry(_Closed):
        """What one QML item is meant to measure."""

        construct: str | None = None
        kind: MeasureKind | None = None
        kpis: list[str] = Field(default_factory=list)
        purpose: Purpose | None = None
        reversed: bool = False
        origin: Origin | None = None
        rows: dict[int, RowFacts] = Field(default_factory=dict)
        rows_digest: str | None = None

        @field_validator("rows")
        @classmethod
        def _positions_start_at_one(cls, value: dict[int, RowFacts]) -> dict[int, RowFacts]:
            below = sorted(position for position in value if position < 1)
            if below:
                raise ValueError(
                    f"states row position {', '.join(str(p) for p in below)}, and row positions start at 1"
                )
            return value


class ItemInventory(_Closed):
    """One questionnaire's inventory: an entry per item id."""

    schema_: Literal["item-inventory/v1"] = Field(alias="schema")
    items: dict[str, ItemEntry]


@dataclass(frozen=True)
class PatchResult:
    """The outcome of ``apply_patch``.

    ``refusals`` is empty when the patch applied, and ``inventory`` is then the
    new inventory. Otherwise ``inventory`` is the one passed in, unchanged, and
    each refusal is ``{"item_id", "problem"}``: the id the refused operation
    names (``None`` when it names none that is a string) and one sentence
    saying what is wrong.
    """

    inventory: ItemInventory
    refusals: list[dict[str, Any]]


def empty_inventory() -> ItemInventory:
    """An inventory with no entries."""
    return ItemInventory(schema=INVENTORY_SCHEMA, items={})


def parse_inventory(text: str) -> ItemInventory:
    """Parse and validate stored inventory JSON; raises ``pydantic.ValidationError``."""
    return ItemInventory.model_validate_json(text)


def serialize_inventory(inventory: ItemInventory) -> str:
    """The JSON to store: keys sorted, unstated facts left out, so equal inventories give equal text."""
    data = inventory.model_dump(mode="json", by_alias=True, exclude_defaults=True)
    return json.dumps(data, ensure_ascii=False, sort_keys=True)


def without_kpis(inventory: ItemInventory) -> ItemInventory:
    """``inventory`` with no KPI named: every entry's list emptied, and every row's that states one.

    Everything else stays as stated, the rows digests included: which KPI an
    item serves says nothing about which statement a row position names. A
    row that states no KPI list of its own keeps stating none, so it goes on
    following its item. It is the inventory to store for a copy whose paper
    numbers other goals than the ones these entries were linked to.
    """
    items = {
        item_id: entry.model_copy(
            update={
                "kpis": [],
                "rows": {
                    position: row if row.kpis is None else row.model_copy(update={"kpis": []})
                    for position, row in entry.rows.items()
                },
            }
        )
        for item_id, entry in inventory.items.items()
    }
    return inventory.model_copy(update={"items": items})


def construct_key(name: str) -> str:
    """The key two construct names share when they differ only by case and surrounding space."""
    return name.strip().casefold()


def plain_text(text: str) -> str:
    """Wording without its markup (HTML tags, Markdown emphasis and links), whitespace collapsed."""
    text = _TAG.sub("", text)
    text = _LINK.sub(r"\1", text)
    text = _STRONG.sub(r"\2", text)
    text = _EMPHASIS.sub(r"\1", text)
    text = _CODE.sub(r"\1", text)
    return " ".join(html.unescape(text).split())


def row_texts(qml_item: dict[str, Any]) -> list[str]:
    """The rows of a loaded QML item as plain text, in document order; ``[]`` for an item without rows."""
    field = _ROW_FIELDS.get(qml_item.get("kind"))
    rows = qml_item.get(field) if field else None
    if not isinstance(rows, list):
        return []
    return [plain_text(row) if isinstance(row, str) else "" for row in rows]


def rows_digest(texts: list[str]) -> str:
    """A digest of a row list that changes when a row is added, removed, moved or reworded."""
    return hashlib.sha256(json.dumps(texts, ensure_ascii=False).encode("utf-8")).hexdigest()


def apply_patch(
    inventory: ItemInventory,
    *,
    upsert: list[dict],
    remove: list[str],
    rename: list[dict],
    qml: dict | None,
    rows_qml: dict | None = None,
) -> PatchResult:
    """Apply renames, then removes, then upserts to ``inventory``, entirely or not at all.

    Each upsert is ``{"item_id": ..., <entry fields>}`` and replaces that
    item's entry whole; each rename is ``{"from": id, "to": id}``; a remove of
    an id that has no entry changes nothing. ``qml`` is the loaded QML the
    entries describe (``QMLLoader.load_from_string``). It is read only to
    record the rows digest of an upserted entry that states row facts, and
    ``rows_qml`` takes its place for that when the row facts were stated
    against another QML than ``qml``. An entry whose row facts equal the stored
    entry's keeps the stored digest unless it carries ``rows_confirmed: true``.
    """
    items = dict(inventory.items)
    refusals: list[dict[str, Any]] = []

    def refuse(item_id: Any, problem: str) -> None:
        refusals.append({"item_id": item_id if isinstance(item_id, str) else None, "problem": problem})

    for number, operation in enumerate(rename, start=1):
        source = operation.get("from") if isinstance(operation, dict) else None
        target = operation.get("to") if isinstance(operation, dict) else None
        if not isinstance(operation, dict) or set(operation) != {"from", "to"}:
            refuse(source, f"Rename {number} is not a pair of `from` and `to`.")
        elif not (_is_item_id(source) and _is_item_id(target)):
            refuse(source, f"Rename {number} names an item id that is empty or not a string.")
        elif source not in items:
            refuse(source, f"`{source}` cannot be renamed, because it has no entry.")
        elif target in items:
            refuse(source, f"`{source}` cannot be renamed to `{target}`, which already has an entry.")
        else:
            items[target] = items.pop(source)

    for number, item_id in enumerate(remove, start=1):
        if not _is_item_id(item_id):
            refuse(item_id, f"Remove {number} names an item id that is empty or not a string.")
        else:
            items.pop(item_id, None)

    read = rows_qml if rows_qml is not None else qml
    row_items = {item.get("id"): item for item in (read or {}).get("items", [])}
    for number, operation in enumerate(upsert, start=1):
        if not isinstance(operation, dict):
            refuse(None, f"Upsert {number} is not an entry.")
            continue
        item_id = operation.get("item_id")
        if not _is_item_id(item_id):
            refuse(item_id, f"Upsert {number} names an item id that is empty or not a string.")
            continue
        facts = {key: value for key, value in operation.items() if key != "item_id"}
        if "rows_digest" in facts:
            refuse(
                item_id,
                f"The entry for `{item_id}` states `rows_digest`, "
                "which is computed from the QML and cannot be supplied.",
            )
            del facts["rows_digest"]
        confirmed = facts.pop(ROWS_CONFIRMED_KEY, False)
        if not isinstance(confirmed, bool):
            refuse(
                item_id,
                f"The entry for `{item_id}` states `{ROWS_CONFIRMED_KEY}` as {confirmed!r}, "
                "which is not true or false.",
            )
            confirmed = False
        try:
            entry = ItemEntry.model_validate(facts)
        except ValidationError as exc:
            for error in exc.errors(include_url=False):
                refuse(item_id, _problem(item_id, error))
            continue
        if confirmed and not entry.rows:
            refuse(
                item_id,
                f"The entry for `{item_id}` states `{ROWS_CONFIRMED_KEY}` and no row facts, "
                "so it has no rows to confirm.",
            )
            continue
        stored = items.get(item_id)
        if not entry.rows:
            digest = None
        elif stored is not None and stored.rows == entry.rows and not confirmed:
            digest = stored.rows_digest
        else:
            row_item = row_items.get(item_id)
            digest = rows_digest(row_texts(row_item)) if row_item is not None else None
        items[item_id] = entry.model_copy(update={"rows_digest": digest})

    if refusals:
        return PatchResult(inventory=inventory, refusals=refusals)
    return PatchResult(inventory=inventory.model_copy(update={"items": items}), refusals=[])


def _is_item_id(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def _problem(item_id: str, error: dict[str, Any]) -> str:
    """One sentence for one validation error of the entry upserted for ``item_id``.

    The sentence quotes the refused value: it is the caller's own input, said
    back to the caller.
    """
    loc = error["loc"]
    in_row = len(loc) >= 2 and loc[0] == "rows"
    subject = f"Row {loc[1]} of `{item_id}`" if in_row else f"The entry for `{item_id}`"
    field = loc[-1]
    kind = error["type"]
    if kind == "extra_forbidden":
        if field in QML_OWNED_KEYS:
            return (
                f"{subject} states `{field}`, which belongs to the QML: the inventory holds "
                "no wording, labels, codes, scale, answer type or conditions."
            )
        return f"{subject} states `{field}`, which is not a key of the inventory."
    if kind == "literal_error":
        return (
            f"{subject} states the {field} {error['input']!r}, "
            f"which is not one of {error['ctx']['expected']}."
        )
    if kind == "value_error":
        return f"{subject} {error['ctx']['error']}."
    if kind == "int_parsing" and in_row:
        return f"The entry for `{item_id}` states row position {loc[1]!r}, which is not a whole number."
    path = ".".join(str(part) for part in loc)
    return f"{subject} is not valid at `{path}`: {error['msg']}."
