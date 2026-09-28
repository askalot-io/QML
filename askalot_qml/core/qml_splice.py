"""
Text-preserving edits to an authored QML document — set or remove one key.

QML is authored YAML, and the document store keeps every version of it, so a
machine edit must not round-trip through ``yaml.safe_load`` → ``yaml.safe_dump``:
that parse is semantically lossless and *documentarily* destructive. Measured on
``tests/fixtures/roster_household_labour.qml``, it turned 35 author comments into
3 and re-emitted multi-line ``codeInit`` bodies as folded single-quoted scalars
with blank lines standing in for newlines (#373). ``sort_keys=False`` preserves
the author's key *order* and nothing else on that list.

What this module does instead: ``yaml.compose`` yields a node tree whose marks
carry byte offsets into the original text, so every edit is a splice at one of
those offsets and bytes outside the spliced spans are identical by construction.
Splices are applied last-first, so an earlier edit cannot invalidate a later
offset.

Two anchoring rules make the splices safe, and both are asymmetric in a way that
is easy to get backwards:

* **Insertion anchors to the end of the last pair's physical LINE**, not to the
  end of its value. Anchoring to the value would leave ``rows: 4`` in place and
  push ``# tuned on the pilot`` onto the newly inserted key.
* **Removal takes the whole physical line including its newline**, so a trailing
  comment that belongs to the removed key leaves with it instead of being
  orphaned onto whatever follows. A comment on the line *above* is deliberately
  left alone — it may annotate the key, the mapping, or the block, and nothing
  in the node tree says which.

Removal is therefore not the inverse of insertion, and one more case separates
them: removing the *last* pair would leave a block mapping with no pairs, which
block YAML cannot spell. Such a mapping is respelled ``{}`` in place rather than
left as a key with no value, which loads as ``None`` — a different document, and
one that would fail a caller's "the only delta is the removed key" check.

A **flow** mapping (``input: {control: Textarea}``) is refused rather than
rewritten, because converting it to block style is a whole-node reformat: the
class of change this module exists to not make. Every refusal is a reported
outcome — not an exception, not a silent skip — because a caller that cannot see
it reports a document as edited when it was not.

Deliberately free of any database or ORM import. The callers are content
migrations that read QML out of Postgres themselves; the splicing is text in,
text out, and stays testable and reusable without a driver installed.
"""

from __future__ import annotations

from collections.abc import Iterable, Iterator
from dataclasses import dataclass
from typing import NamedTuple

import yaml


class Splice(NamedTuple):
    """One replacement of ``text[start:end]``. An insert is a zero-width span."""

    start: int
    end: int
    replacement: str


@dataclass(frozen=True)
class SpliceOutcome:
    """What a splice request produced — an edit, nothing to do, or a refusal.

    Three states rather than an optional ``Splice``, because "the document
    already says what you asked for" and "this mapping cannot be edited safely"
    are opposite facts that a caller reports differently: the first is a quiet
    success, the second is something an operator must see before a migration is
    read as complete.
    """

    splice: Splice | None = None
    refusal: str | None = None

    @property
    def refused(self) -> bool:
        return self.refusal is not None


def line_end(text: str, index: int) -> int:
    """Offset of the newline ending the physical line that *index* sits on.

    Returns ``len(text)`` for a final line with no trailing newline.
    """
    nl = text.find("\n", index)
    return len(text) if nl == -1 else nl


def _line_start(text: str, index: int) -> int:
    """Offset of the first character of the physical line that *index* sits on."""
    return text.rfind("\n", 0, index) + 1


def _value_line_end(text: str, value: yaml.Node) -> int:
    """End-of-line offset for the last physical line a value node occupies.

    A block scalar's ``end_mark`` lands at column 0 of the *following* line.
    Uncorrected, an insert would skip a line and land inside the next key, and a
    removal would swallow that key's first line.
    """
    end = value.end_mark
    index = end.index
    if end.column == 0 and index > 0:
        index -= 1
    return line_end(text, index)


def insertion_point(text: str, mapping: yaml.MappingNode) -> tuple[int, int] | None:
    """Where to splice a new key into an existing block mapping, and at what column.

    Returns ``(offset, indent)`` or ``None`` when the mapping cannot take a
    block-style insert — a flow mapping or an empty one.

    The anchor is the **last** pair, not the first: a comment above the first key
    annotates that key, and inserting above it would separate the two.
    """
    if mapping.flow_style or not mapping.value:
        return None
    return _value_line_end(text, mapping.value[-1][1]), mapping.value[0][0].start_mark.column


def find_pair(mapping: yaml.MappingNode, key: str) -> tuple[yaml.ScalarNode, yaml.Node] | None:
    """The ``(key node, value node)`` for *key*, or ``None`` when it is absent."""
    for key_node, value_node in mapping.value:
        if isinstance(key_node, yaml.ScalarNode) and key_node.value == key:
            return key_node, value_node
    return None


def set_pair(text: str, mapping: yaml.MappingNode, key: str, value: str) -> SpliceOutcome:
    """Set ``key: value`` on a mapping — retargeting the value, or inserting the pair.

    *value* is spliced verbatim, so callers pass a scalar that needs no quoting.

    An existing key is retargeted over its **whole value span**, quoting
    included, so ``coding: 'none'`` becomes ``coding: semantic`` rather than
    ``semantic`` nested inside the stale quotes. That path works on a flow
    mapping too — replacing a scalar inside one reformats nothing — which is why
    the flow refusal is reached only when a new pair would have to be inserted.
    """
    pair = find_pair(mapping, key)
    if pair is not None:
        existing = pair[1]
        if existing.value == value:
            return SpliceOutcome()
        return SpliceOutcome(Splice(existing.start_mark.index, existing.end_mark.index, value))

    point = insertion_point(text, mapping)
    if point is None:
        return SpliceOutcome(refusal="cannot insert into a flow or empty mapping")
    offset, indent = point
    return SpliceOutcome(Splice(offset, offset, f"\n{' ' * indent}{key}: {value}"))


def remove_pair(text: str, mapping: yaml.MappingNode, key: str) -> SpliceOutcome:
    """Remove ``key`` and its value from a block mapping, physical line and all.

    An absent key is a no-op rather than an error: a migration sweeping a corpus
    meets documents that never declared the key, and those are not failures.

    The span runs from the start of the key's line to just past the newline
    ending its value's last line, so a trailing comment on that line leaves with
    the key. A comment on the line *above* stays — see the module docstring.

    Two cases do not reduce to deleting a line:

    * The key is the mapping's **only** pair. An empty block mapping has no
      block spelling, so the pair is replaced in place by ``{}`` rather than
      leaving a parent key with no value, which loads as ``None``.
    * The key's line carries something other than whitespace before it — the
      ``- `` of a sequence item whose first pair this is. Deleting that line
      would lift every remaining pair out of the sequence, so the removal is
      refused instead of quietly corrupting the document.
    """
    if mapping.flow_style:
        return SpliceOutcome(refusal="cannot remove from a flow mapping")

    pair = find_pair(mapping, key)
    if pair is None:
        return SpliceOutcome()
    key_node, value_node = pair

    key_start = key_node.start_mark.index
    value_end = _value_line_end(text, value_node)

    if len(mapping.value) == 1:
        return SpliceOutcome(Splice(key_start, value_end, "{}"))

    start = _line_start(text, key_start)
    if text[start:key_start].strip():
        return SpliceOutcome(refusal="the key shares its physical line with other content")
    return SpliceOutcome(Splice(start, min(len(text), value_end + 1), ""))


def apply_splices(text: str, splices: Iterable[Splice]) -> str:
    """Apply splices to *text*, last-first so earlier offsets stay valid.

    Identical splices collapse to one. ``yaml.compose`` resolves a YAML alias to
    the *same node object* the anchor produced, so an ``input`` node written
    once as ``&open_text`` and reused as ``*open_text`` is reachable at two
    points in the tree and a walk over it yields one node twice, with one set of
    marks. Applying that span twice removes it twice — which a caller's
    "the only delta is the removed key" check then reports as an over-wide
    removal, aborting a whole batch over a document that is fine.

    Two splices that share a span but not a replacement are NOT collapsed: that
    is a genuine disagreement about what the span should say, and the last-first
    application would silently pick one. It stays whatever the caller's own
    verification makes of it.
    """
    updated = text
    for start, end, replacement in sorted(set(splices), reverse=True):
        updated = updated[:start] + replacement + updated[end:]
    return updated


def iter_item_inputs(root: yaml.Node) -> Iterator[tuple[str, yaml.Node]]:
    """Every ``(item id, its ``input`` value node)`` in a composed QML tree.

    Pre-order, so ids come out in document order. The ``input`` node is yielded
    whatever its kind: ``input: null`` is an authoring mistake a migration must
    *report*, and a walk that filtered it out here would leave the caller unable
    to tell it from an item that was never in the document.
    """
    if isinstance(root, yaml.MappingNode):
        keyed = {key.value: value for key, value in root.value if isinstance(key, yaml.ScalarNode)}
        item_id, spec = keyed.get("id"), keyed.get("input")
        if isinstance(item_id, yaml.ScalarNode) and spec is not None:
            yield str(item_id.value), spec
        for _, value in root.value:
            yield from iter_item_inputs(value)
    elif isinstance(root, yaml.SequenceNode):
        for value in root.value:
            yield from iter_item_inputs(value)


__all__ = [
    "Splice",
    "SpliceOutcome",
    "apply_splices",
    "find_pair",
    "insertion_point",
    "iter_item_inputs",
    "line_end",
    "remove_pair",
    "set_pair",
]
