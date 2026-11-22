"""Text-only translations of a QML questionnaire: keys, validation, carry-forward, overlay.

A translation is a flat map from a *text key* to the translated string. It
replaces respondent-visible text and nothing else: ids, option codes,
conditions, code blocks and numeric bounds stay those of the source, so the
flow, every Z3 verdict and every stored answer code are the source's whatever
language a respondent reads. This module is the judging half: ``askalot_common``
stores the map and the untranslated list computed here, and cannot parse QML
itself. Every function but ``seed_translations`` is pure; that one reads a
seed plan through the repository, computes carry-forward here and hands the
rows back to be inserted.

Every function takes the parsed document ``QMLLoader`` returns (the flattened
shape: ``title``, block metadata in ``blocks``, every item in ``items`` with its
``blockId``), the shape the flow service materializes a walk from.

Key format (a plain string, so a map serializes into JSONB as is)::

    <scope>/<field>[/<code-or-index>][/hint]

    questionnaire/title
    block:<block id>/title
    block:<block id>/labels/<code>              Roster display labels
    block:<block id>/postcondition/<n>/hint
    item:<item id>/title
    item:<item id>/labels/<code>                option labels (Radio, Checkbox,
                                                Dropdown, Slider, Range); of a
                                                declared scale, authored ones only
    item:<item id>/on | off | left | right | placeholder
    item:<item id>/questions/<n>                QuestionGroup statements
    item:<item id>/rows/<n> | columns/<n>       MatrixQuestion
    item:<item id>/postcondition/<n>/hint       shown as the rejection message

Ids are identifiers and codes are integers, so neither can hold the ``/``
separator. Precondition hints are not keys: nothing shows them to a respondent.
A postcondition's ``invented`` marker is not text either, so it has no key and
a translator never receives it; the check's hint is keyed like any other.

Two key families behave differently:

- **Coded** (``labels``): keyed by the option's code, which is stable across
  edits. A partial map is untranslated text, not an error. A map that names a
  code the source lacks is a changed code, and the refusal names both the
  foreign code and every source code it left out.
- **Positional** (``rows``, ``columns``, ``questions``, postcondition hints):
  keyed by index, which an insertion shifts. Such a list is translated whole or
  not at all, so a partial list is refused as a length mismatch, and
  carry-forward copies it only when the whole source list is unchanged.

**Declared rating scales.** An item that declares a scale holds, after
loading, a label for every code of the scale, but only the codes in its
``_scale_authored_codes`` carry the author's text; the rest are the scale
catalog's, in the language the document was loaded in (empty in a codes-only
load). Only an authored label is a ``labels/<code>`` key: a catalog label is
already translated by the catalog, so requiring it of every translation would
make each existing translation incomplete the moment a scale is declared, and
a key for one is refused (``catalog_label``). The key set reads the record,
never the label text, so it is the same whatever language the document was
loaded in. A walk in another language takes its catalog labels by being
loaded in that language; ``apply_translation`` then lays the authored labels
on top and copies every label into the item's ordered ``input.options``.

The translated text is not sanitized here: the save path checks markup before
storing, so an overlay never fails on what it applies.

**Source-level appliers.** Everything above reads the loaded (flattened)
document. ``apply_source_translation`` instead rewrites the raw parsed QML file
(``yaml.safe_load`` of the text, ``questionnaire.blocks[].items[]``), walked
with the same key scheme, so a translated *file* can be written: the template
library's build materializes each language's copy of a template this way, and
``dump_source`` writes it back as YAML. The file's precondition hints, which
are not text keys, have a pair of their own (``source_precondition_hints``,
``apply_source_precondition_hints``), keyed like the postcondition hints::

    block:<block id>/precondition/<n>/hint
    item:<item id>/precondition/<n>/hint

``<n>`` is the condition's position in its ``precondition`` list; a condition
with no hint has no key. They live beside a translation, never inside one: a
stored translation holds text keys only.
"""

from __future__ import annotations

import copy
import logging
import re
from collections.abc import Iterable, Iterator
from dataclasses import dataclass
from enum import StrEnum
from typing import Any

import yaml

QUESTIONNAIRE_SCOPE = "questionnaire"

#: Item ``input`` fields holding one string each.
_INPUT_TEXT_FIELDS = ("on", "off", "left", "right", "placeholder")
#: Item fields holding a positional list of strings.
_ITEM_LIST_FIELDS = ("questions", "rows", "columns")

logger = logging.getLogger(__name__)

_KEY_PATTERN = re.compile(r"^(?:questionnaire|(?P<kind>block|item):(?P<id>[^/]+))/(?P<rest>.+)$")


class RefusalKind(StrEnum):
    """Why one key of a translation cannot be saved."""

    UNKNOWN_SCOPE = "unknown_scope"
    UNKNOWN_FIELD = "unknown_field"
    UNKNOWN_CODE = "unknown_code"
    MISSING_CODE = "missing_code"
    INDEX_OUT_OF_RANGE = "index_out_of_range"
    LIST_LENGTH_MISMATCH = "list_length_mismatch"
    NON_STRING_VALUE = "non_string_value"
    CATALOG_LABEL = "catalog_label"


@dataclass(frozen=True)
class TranslationRefusal:
    """One reason a translation is refused, naming the key it concerns.

    ``key`` is a text key, or for a length mismatch the list's prefix
    (``item:m1/rows``). ``message`` is a sentence for the author.
    """

    kind: RefusalKind
    key: str
    message: str


@dataclass
class _Slot:
    """One respondent-visible string in a document and where it lives."""

    key: str
    value: str
    container: dict | list
    field: Any
    #: The coded map's or positional list's key prefix, None for a lone field.
    group: str | None = None
    positional: bool = False


@dataclass
class _Document:
    """The text slots of a document plus the shape the validator compares against."""

    slots: dict[str, _Slot]
    #: Positional list prefix → the whole source list (None where a
    #: postcondition carries no hint), compared whole by carry-forward.
    positional_groups: dict[str, tuple[str | None, ...]]
    #: Positional list prefix → the source list's length (conditions for hints).
    list_lengths: dict[str, int]
    #: Coded map prefix → the source's codes as key strings.
    coded_groups: dict[str, list[str]]
    #: Coded map prefix of a declared scale → (its family, the codes whose
    #: label the scale catalog supplies, as key strings).
    catalog_groups: dict[str, tuple[str, set[str]]]
    scopes: set[str]


def _walk(qml: dict[str, Any]) -> _Document:
    """The text slots of a loaded (flattened) document."""
    items_by_block: dict[str, list[dict[str, Any]]] = {}
    for item in qml.get("items", []):
        items_by_block.setdefault(item.get("blockId"), []).append(item)
    return _walk_blocks(
        qml, ((block, items_by_block.get(block["id"], [])) for block in qml.get("blocks", []))
    )


def _walk_source(document: dict[str, Any]) -> _Document:
    """The text slots of a raw parsed QML file, whose items sit inside their blocks."""
    questionnaire = document["questionnaire"]
    return _walk_blocks(
        questionnaire,
        ((block, block.get("items") or []) for block in questionnaire.get("blocks") or []),
    )


def _walk_blocks(
    qml: dict[str, Any], blocks: Iterable[tuple[dict[str, Any], list[dict[str, Any]]]]
) -> _Document:
    """Walk ``qml``'s title, then each block with its items, in document order."""
    doc = _Document(
        slots={},
        positional_groups={},
        list_lengths={},
        coded_groups={},
        catalog_groups={},
        scopes=set(),
    )

    def add(key: str, container: dict | list, field: Any, **kwargs: Any) -> None:
        value = container[field]
        if isinstance(value, str):
            doc.slots[key] = _Slot(key, value, container, field, **kwargs)

    def add_labels(scope: str, labels: Any, owner: dict[str, Any] | None = None) -> None:
        if not isinstance(labels, dict):
            return
        group = f"{scope}/labels"
        codes = list(labels)
        authored = owner.get("_scale_authored_codes") if owner is not None else None
        if authored is not None:
            # A declared scale: only the author's labels are text keys.
            written = {str(code) for code in authored}
            doc.catalog_groups[group] = (
                owner["scale"]["family"],
                {str(code) for code in codes if str(code) not in written},
            )
            codes = [code for code in codes if str(code) in written]
        doc.coded_groups[group] = [str(code) for code in codes]
        for code in codes:
            add(f"{group}/{code}", labels, code, group=group)

    def add_list(group: str, values: Any) -> None:
        if not isinstance(values, list):
            return
        doc.positional_groups[group] = tuple(v if isinstance(v, str) else None for v in values)
        doc.list_lengths[group] = len(values)
        for index in range(len(values)):
            add(f"{group}/{index}", values, index, group=group, positional=True)

    def add_hints(scope: str, owner: dict[str, Any]) -> None:
        conditions = owner.get("postcondition")
        if not isinstance(conditions, list):
            return
        group = f"{scope}/postcondition"
        doc.positional_groups[group] = tuple(
            c.get("hint") if isinstance(c, dict) else None for c in conditions
        )
        doc.list_lengths[group] = len(conditions)
        for index, condition in enumerate(conditions):
            if isinstance(condition, dict) and "hint" in condition:
                add(f"{group}/{index}/hint", condition, "hint", group=group, positional=True)

    doc.scopes.add(QUESTIONNAIRE_SCOPE)
    if "title" in qml:
        add(f"{QUESTIONNAIRE_SCOPE}/title", qml, "title")

    for block, items in blocks:
        scope = f"block:{block['id']}"
        doc.scopes.add(scope)
        if "title" in block:
            add(f"{scope}/title", block, "title")
        add_labels(scope, block.get("labels"))
        add_hints(scope, block)
        for item in items:
            item_scope = f"item:{item['id']}"
            doc.scopes.add(item_scope)
            if "title" in item:
                add(f"{item_scope}/title", item, "title")
            for field in _ITEM_LIST_FIELDS:
                add_list(f"{item_scope}/{field}", item.get(field))
            spec = item.get("input")
            if isinstance(spec, dict):
                add_labels(item_scope, spec.get("labels"), item)
                for field in _INPUT_TEXT_FIELDS:
                    if field in spec:
                        add(f"{item_scope}/{field}", spec, field)
            add_hints(item_scope, item)
    return doc


def text_keys(qml: dict[str, Any]) -> dict[str, str]:
    """Every respondent-visible string of ``qml``, key → source text, in document order."""
    return {key: slot.value for key, slot in _walk(qml).slots.items()}


def _scope_name(scope: str) -> str:
    return scope.split(":", 1)[-1]


def _unknown_key_refusal(doc: _Document, key: str) -> TranslationRefusal:
    """Classify a key the source does not hold."""
    match = _KEY_PATTERN.match(key)
    if match is None:
        return TranslationRefusal(
            RefusalKind.UNKNOWN_FIELD,
            key,
            f"{key!r} is not a translatable text key.",
        )
    scope = f"{match['kind']}:{match['id']}" if match["kind"] else QUESTIONNAIRE_SCOPE
    if scope not in doc.scopes:
        return TranslationRefusal(
            RefusalKind.UNKNOWN_SCOPE,
            key,
            f"The source has no {match['kind']} {match['id']!r}; a translation cannot add one.",
        )
    parts = match["rest"].split("/")
    group = f"{scope}/{parts[0]}"
    name = _scope_name(scope)
    if group in doc.catalog_groups and len(parts) == 2 and parts[1] in doc.catalog_groups[group][1]:
        family = doc.catalog_groups[group][0]
        return TranslationRefusal(
            RefusalKind.CATALOG_LABEL,
            key,
            f"{name} code {parts[1]} shows the {family} scale catalog's label, which is "
            "already in every supported language; a translation translates only labels "
            "the questionnaire words itself.",
        )
    if group in doc.coded_groups and len(parts) == 2 and re.fullmatch(r"-?\d+", parts[1]):
        return TranslationRefusal(
            RefusalKind.UNKNOWN_CODE,
            key,
            f"{name} has no option code {parts[1]}; a translation cannot change codes.",
        )
    if group in doc.list_lengths and len(parts) >= 2 and parts[1].isdigit():
        if int(parts[1]) >= doc.list_lengths[group]:
            return TranslationRefusal(
                RefusalKind.INDEX_OUT_OF_RANGE,
                key,
                f"{name} has {doc.list_lengths[group]} {parts[0]} entries; "
                f"index {parts[1]} is out of range.",
            )
    return TranslationRefusal(
        RefusalKind.UNKNOWN_FIELD,
        key,
        f"{key!r} names no text of {name}; a translation changes text only.",
    )


def validate_translation(qml: dict[str, Any], texts: dict[str, Any]) -> list[TranslationRefusal]:
    """Every reason ``texts`` cannot be a translation of ``qml``; empty when it can.

    A translation may be partial (see ``untranslated``), except that a
    positional list is translated whole, and a coded map naming a foreign code
    also has every source code it omits named, since together they read as a
    changed code.
    """
    doc = _walk(qml)
    refusals: list[TranslationRefusal] = []
    foreign_code_groups: set[str] = set()
    for key, value in texts.items():
        slot = doc.slots.get(key)
        if slot is None:
            refusal = _unknown_key_refusal(doc, key)
            refusals.append(refusal)
            if refusal.kind is RefusalKind.UNKNOWN_CODE:
                foreign_code_groups.add(key.rsplit("/", 1)[0])
        elif not isinstance(value, str):
            refusals.append(
                TranslationRefusal(
                    RefusalKind.NON_STRING_VALUE,
                    key,
                    f"The translation of {key!r} is a {type(value).__name__}, not text.",
                )
            )

    for group in sorted(foreign_code_groups):
        name = _scope_name(group.rsplit("/", 1)[0])
        for code in doc.coded_groups[group]:
            key = f"{group}/{code}"
            if key not in texts:
                refusals.append(
                    TranslationRefusal(
                        RefusalKind.MISSING_CODE,
                        key,
                        f"{name} code {code} is missing while the translation names a code "
                        "the source lacks; a translation cannot change codes.",
                    )
                )

    for group in doc.positional_groups:
        members = [key for key, slot in doc.slots.items() if slot.group == group]
        present = sum(1 for key in members if key in texts)
        if 0 < present < len(members):
            refusals.append(
                TranslationRefusal(
                    RefusalKind.LIST_LENGTH_MISMATCH,
                    group,
                    f"{group!r} has {len(members)} texts in the source and {present} in the "
                    "translation; a list is translated whole.",
                )
            )
    return refusals


def untranslated(qml: dict[str, Any], texts: dict[str, Any]) -> list[str]:
    """The text keys of ``qml`` that ``texts`` does not translate, in document order.

    Empty exactly when the translation is complete, the only state a
    translation is offered to respondents in.
    """
    return [key for key in _walk(qml).slots if key not in texts]


def carry_forward(
    old_qml: dict[str, Any], old_texts: dict[str, str], new_qml: dict[str, Any]
) -> dict[str, str]:
    """The part of ``old_texts`` still true of ``new_qml``.

    A key's text is copied only when its source text is unchanged between the
    two versions; a positional list only when the whole source list is
    unchanged, since an insertion shifts every later index. Changed and new
    keys are left out, which makes them untranslated. ``old_texts`` is not
    modified.
    """
    old = _walk(old_qml)
    new = _walk(new_qml)
    carried: dict[str, str] = {}
    for key, slot in new.slots.items():
        if key not in old_texts or key not in old.slots:
            continue
        if slot.positional:
            unchanged = old.positional_groups.get(slot.group) == new.positional_groups[slot.group]
        else:
            unchanged = old.slots[key].value == slot.value
        if unchanged:
            carried[key] = old_texts[key]
    return carried


def apply_translation(qml: dict[str, Any], texts: dict[str, str]) -> dict[str, Any]:
    """A deep copy of ``qml`` with every key ``texts`` holds replaced by its text.

    Only text moves: ids, codes, conditions, code blocks and bounds are those of
    ``qml``. Keys the document lacks are ignored, so call ``validate_translation``
    before storing a map. A Roster's inner items carry a copy of its labels
    (``_roster_labels``), and a declared scale's ordered ``input.options`` a
    copy of each label, so both take the translated labels too. A declared
    scale's catalog labels are not keys: they stay the text of the language
    ``qml`` was loaded in, so a walk in another language loads in it first.
    """
    translated = copy.deepcopy(qml)
    for key, slot in _walk(translated).slots.items():
        if key in texts:
            slot.container[slot.field] = texts[key]
    blocks = {block["id"]: block for block in translated.get("blocks", [])}
    for item in translated.get("items", []):
        if "_roster_block_id" in item:
            item["_roster_labels"] = blocks[item["_roster_block_id"]].get("labels", {})
        spec = item.get("input")
        if isinstance(spec, dict) and isinstance(spec.get("options"), list):
            for option in spec["options"]:
                option["label"] = spec["labels"][option["code"]]
    return translated


def _normalized_copy(document: dict[str, Any]) -> dict[str, Any]:
    """A deep copy of a raw QML file with each Switch's ``on``/``off`` keys named.

    YAML reads a bare ``on:`` key as ``True``; the loader names it back
    (``normalize_switch_input``), and so must a source-level walk, or the
    ``item:<id>/on`` key would find nothing to replace.
    """
    # Imported here: qml_loader is not needed by the pure functions above.
    from askalot_qml.core.qml_loader import normalize_switch_input

    normalized = copy.deepcopy(document)
    for block in normalized["questionnaire"].get("blocks") or []:
        for item in block.get("items") or []:
            normalize_switch_input(item.get("input"))
    return normalized


def apply_source_translation(document: dict[str, Any], texts: dict[str, str]) -> dict[str, Any]:
    """A copy of the raw QML file ``document`` with every key ``texts`` holds replaced.

    ``document`` is ``yaml.safe_load`` of the file, not the loader's output.
    The keys are those ``text_keys`` gives the loaded file, and as with
    ``apply_translation`` only text moves and keys the file lacks are ignored,
    so validate the map against the loaded file first. ``document`` is not
    modified.
    """
    translated = _normalized_copy(document)
    for key, slot in _walk_source(translated).slots.items():
        if key in texts:
            slot.container[slot.field] = texts[key]
    return translated


def _precondition_hint_slots(document: dict[str, Any]) -> Iterator[tuple[str, dict[str, Any]]]:
    """Each hinted precondition of a raw QML file: its key and the condition holding the hint."""
    for block in document["questionnaire"].get("blocks") or []:
        owners = [(f"block:{block['id']}", block)]
        owners += [(f"item:{item['id']}", item) for item in block.get("items") or []]
        for scope, owner in owners:
            conditions = owner.get("precondition")
            if not isinstance(conditions, list):
                continue
            for index, condition in enumerate(conditions):
                if isinstance(condition, dict) and isinstance(condition.get("hint"), str):
                    yield f"{scope}/precondition/{index}/hint", condition


def source_precondition_hints(document: dict[str, Any]) -> dict[str, str]:
    """Every precondition hint of the raw QML file ``document``, key → hint, in document order."""
    return {key: condition["hint"] for key, condition in _precondition_hint_slots(document)}


def apply_source_precondition_hints(
    document: dict[str, Any], hints: dict[str, str]
) -> dict[str, Any]:
    """A copy of the raw QML file ``document`` with every hint ``hints`` keys replaced.

    Keys the file lacks are ignored, so compare the map's keys with
    ``source_precondition_hints`` first. ``document`` is not modified.
    """
    hinted = copy.deepcopy(document)
    for key, condition in _precondition_hint_slots(hinted):
        if key in hints:
            condition["hint"] = hints[key]
    return hinted


class _SourceDumper(yaml.SafeDumper):
    """The safe dumper, writing a multi-line string (a code block) as a literal block."""


def _represent_str(dumper: yaml.SafeDumper, value: str) -> yaml.ScalarNode:
    return dumper.represent_scalar(
        "tag:yaml.org,2002:str", value, style="|" if "\n" in value else None
    )


_SourceDumper.add_representer(str, _represent_str)


def dump_source(document: dict[str, Any]) -> str:
    """A raw QML file as YAML text, keys in their own order and text unescaped.

    The comments and quoting of the original file are not kept (PyYAML does
    not round-trip them); what is kept is every value, so the text loads to the
    same document. Lines are not folded, so a long title stays one line.
    """
    return yaml.dump(
        document, Dumper=_SourceDumper, sort_keys=False, allow_unicode=True, width=4096
    )


def seed_translations(repository: Any, questionnaire_id: str, version_id: str) -> list[str]:
    """Carry each ancestor translation the version lacks onto it; the locales inserted.

    For every locale the version has no row in, the nearest ancestor along
    ``parent_version_id`` holding one is carried forward (``carry_forward``)
    and the version's untranslated keys are computed against its own QML.
    Idempotent: the insert never overwrites a row, so a saved translation, a
    second run and a concurrent run all leave what is stored. Run wherever a
    version's translations are about to be read or a version is about to be
    fielded (the verdict job, the publish stamp, the translation verbs), since
    a version can be stamped and pinned without the verdict job reaching it.

    A version whose QML cannot be loaded has no text keys and can never be
    fielded (the publish gate fails closed on it), so it is seeded nothing; an
    ancestor that cannot be loaded is skipped for the same reason.
    """
    from askalot_common.repository.mixins.qml_translation import SeededTranslation

    # Imported here: qml_loader is not needed by the pure functions above.
    from askalot_qml.core.qml_loader import QMLLoader

    plan = repository.qml_translation_seed_plan(questionnaire_id, version_id)
    if not plan.sources:
        return []
    # The loader reads any object with ``read`` as a YAML stream, so content
    # that is not text (a mocked repository's attribute) would never end;
    # refuse it here instead of parsing it.
    for content in (plan.version_content, *(s.ancestor_content for s in plan.sources)):
        if content is not None and not isinstance(content, str):
            raise TypeError(f"QML content must be text, got {type(content).__name__}")

    loader = QMLLoader(logger=logger)
    try:
        new_qml = loader.load_from_string(plan.version_content)
    except Exception as exc:
        # The publish gate's own reading of unloadable content: a document
        # with no keys, never fieldable.
        logger.info("seed_translations.unloadable version=%s err=%s", version_id, exc)
        return []

    ancestors: dict[str, dict[str, Any] | None] = {}
    rows: list[SeededTranslation] = []
    for source in plan.sources:
        if source.ancestor_version_id not in ancestors:
            try:
                ancestors[source.ancestor_version_id] = loader.load_from_string(
                    source.ancestor_content
                )
            except Exception as exc:
                logger.warning(
                    "seed_translations.unloadable_ancestor version=%s ancestor=%s err=%s",
                    version_id,
                    source.ancestor_version_id,
                    exc,
                )
                ancestors[source.ancestor_version_id] = None
        old_qml = ancestors[source.ancestor_version_id]
        if old_qml is None:
            continue
        carried = carry_forward(old_qml, source.texts, new_qml)
        rows.append(
            SeededTranslation(
                locale=source.locale,
                texts=carried,
                untranslated=untranslated(new_qml, carried),
                human_edited_at=source.human_edited_at,
            )
        )
    if not rows:
        return []
    return repository.insert_seeded_translations(questionnaire_id, version_id, rows)
