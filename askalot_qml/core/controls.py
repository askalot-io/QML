"""
Shared control-value helpers: outcome coercion, label-key extraction, Checkbox mask.

One canonical definition of small operations several consumers need, so the
logic is not copy-pasted across ``ItemProxy``, the external-input domain
validator, the external-item enumerator, and the Z3 domain builder:

- ``coerce_scalar(value, control)`` — coerce a JSON/attribute string to int/float
  for non-text controls (Textarea preserves strings). JSON/MCP round-trips turn
  numeric outcomes into strings; comparisons like ``q_age.outcome >= 18`` then
  raise ``TypeError`` unless the string is coerced back.
- ``label_keys(input_spec)`` — the integer keys of a choice control's ``labels``
  map, coercing string keys (JSONB round-trips stringify object keys) and
  skipping bool keys (a ``bool`` is not a valid domain code even though it is an
  ``int`` subclass).
- ``checkbox_mask(input_spec)`` — the bitwise OR of a Checkbox's keys, which
  bounds its bitmask outcome for the runtime domain validator and the Z3
  Checkbox domain alike.
- ``range_pair(value)`` — the shape of one non-None Range cell, a list
  ``[low, high]`` of two finite numbers with ``low <= high`` (#1474), each end
  coerced like a scalar. ``ItemProxy`` refuses anything else; the domain
  validator then checks the pair against ``min``/``max``. It never builds a
  pair from a scalar: a single number and a paired encoding cannot be told
  apart, so only the input boundaries produce a pair.
- ``RangeValue`` / ``range_value(value)`` — the same cell as conditions and
  codeBlocks read it: the ends are named, ``q.outcome.low`` / ``q.outcome.high``
  (#1755, D89). Storage keeps the list; ``RangeValue.as_pair()`` turns the
  value back into it, so a Range answer has one stored shape and one read shape;
  ``stored_shape(value)`` does that for every ``RangeValue`` nested in a value
  bound for the JSON survey state (variables, a non-Range item's outcome).
- ``answer_shape(item)`` — the declared size of a QuestionGroup / MatrixQuestion
  answer, read from the item's own ``questions`` / ``rows`` / ``columns`` keys;
  the one reading ``ItemProxy`` and the domain validator share (#1616).

This module stays Z3-free, so importing it never pulls Z3 into the runtime path.
``StaticBuilder._domain_constraint_builders`` (z3/) imports ``checkbox_mask``
function-locally (``askalot_qml.core``'s package ``__init__`` imports the engine,
which imports the builder), and keeps its own inline label-key loop for the
Radio/Dropdown/Switch enumeration, which does not skip bool keys.
"""

import math
import re
from dataclasses import dataclass
from typing import Any

# Controls whose outcome is intentional free text — never coerced to a number.
_TEXT_CONTROLS = frozenset({"textarea"})


#: The largest whole number a browser holds exactly (`Number.MAX_SAFE_INTEGER`),
#: and beyond which a JavaScript number, so the survey's Editbox, has lost
#: digits: an answer past it is out of every numeric domain (#1824).
MAX_SAFE_INTEGER = 2**53 - 1

#: The number notation an answer may arrive in as text: what the survey's
#: Editbox reads (`EditboxControl.js`'s DECIMAL_NOTATION), ASCII digits only.
DECIMAL_NOTATION = re.compile(r"[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?", re.ASCII)


def coerce_scalar(value: Any, control: str | None) -> Any:
    """Coerce a string ``value`` to int or float for non-text controls.

    Non-strings pass through unchanged. Textarea (any-case) preserves strings.
    A string in plain ASCII decimal notation (``DECIMAL_NOTATION``: an optional
    sign, digits with an optional point, an optional exponent; surrounding
    whitespace ignored) becomes an int, else a float; anything else stays a
    string, which no numeric domain admits. This is the single definition
    ``ItemProxy._coerce_outcome`` and the domain validator both use.

    Python's own ``int()`` / ``float()`` also read ``1_0``, Unicode digits
    (``１２``), ``inf`` and ``nan``; the survey's Editbox marks those invalid
    and sends them as text for this side to refuse (#1824), so both sides read
    the same notation.
    """
    if not isinstance(value, str):
        return value
    if control and control.lower() in _TEXT_CONTROLS:
        return value
    text = value.strip()
    if not DECIMAL_NOTATION.fullmatch(text):
        return value
    try:
        return int(text)
    except ValueError:
        number = float(text)
    # A whole number written as '1e1' or '4.0' is the int the box would send,
    # so one item's stored answers do not mix 10 and 10.0.
    return int(number) if number.is_integer() else number


def range_pair(value: Any) -> list[int | float]:
    """Return ``value`` as a coerced Range pair ``[low, high]``, or raise.

    Accepts only a list of exactly two ends, each a finite int or float after
    ``coerce_scalar`` (a bool is not a number), with ``low <= high``. Raises
    ``ValueError`` with the reason; the caller names the item. The message
    never quotes the value, which is respondent data. ``None`` (an unanswered
    cell) is the caller's to handle.
    """
    if not isinstance(value, list) or len(value) != 2:
        size = f" of {len(value)}" if isinstance(value, list) else ""
        raise ValueError(
            f"a Range answer must be a list [low, high]; got a {type(value).__name__}{size}"
        )
    ends = [coerce_scalar(end, "Range") for end in value]
    for end in ends:
        # Only a float can be non-finite; `math.isfinite` on an int too large
        # for a float raises OverflowError, which no caller catches.
        if (
            isinstance(end, bool)
            or not isinstance(end, (int, float))
            or (isinstance(end, float) and not math.isfinite(end))
        ):
            raise ValueError(
                f"a Range answer's ends must be finite numbers; got a {type(end).__name__}"
            )
    low, high = ends
    if low > high:
        raise ValueError("a Range answer's low end exceeds its high end")
    return ends


@dataclass(frozen=True, slots=True)
class RangeValue:
    """One answered Range cell as conditions and codeBlocks read it (#1755, D89).

    The two ends are named, ``low`` and ``high``, because a positional read is
    ambiguous in a matrix: ``m.outcome[r][c][0]`` reads like a third dimension.
    There is deliberately no positional alias. ``q.outcome[0]`` raises with a
    message naming ``.low`` / ``.high``, so a condition written in the old form
    is an unevaluatable gate (skip, ``degraded``) rather than a silent read.
    A codeBlock still writes a Range answer as the list literal
    ``q.outcome = [a, b]``; the proxy turns either shape into the stored pair.
    """

    low: int | float
    high: int | float

    def as_pair(self) -> list[int | float]:
        """The stored shape, ``[low, high]``."""
        return [self.low, self.high]

    def __getitem__(self, _index: Any) -> Any:
        raise TypeError("a Range answer's ends are read as .low / .high, not by index")

    def __eq__(self, other: object) -> bool:
        """Equal to another ``RangeValue`` with the same ends.

        Comparing with a list (the stored shape, ``q.outcome == [2, 8]``)
        raises rather than answering False: a silent False would turn a gate
        written against the stored shape into one that never holds.
        """
        if isinstance(other, (list, tuple)):
            raise TypeError("a Range answer is compared by its ends, .low / .high, not as a list")
        if isinstance(other, RangeValue):
            return (self.low, self.high) == (other.low, other.high)
        return NotImplemented


def range_value(value: Any) -> RangeValue:
    """Return ``value`` (a stored pair or a ``RangeValue``) as a ``RangeValue``, or raise.

    The shape rule is ``range_pair``'s: a ``RangeValue`` is re-checked through
    it too, so nothing reaches storage with ``low > high``.
    """
    pair = range_pair(value.as_pair() if isinstance(value, RangeValue) else value)
    return RangeValue(pair[0], pair[1])


def stored_shape(value: Any) -> Any:
    """``value`` with every ``RangeValue`` in it (nested in lists, tuples and
    dicts too) turned into its stored pair, so nothing that reaches the JSON
    survey state is a dataclass: a variable holding a Range answer, or a
    non-Range item a codeBlock assigned one to."""
    if isinstance(value, RangeValue):
        return value.as_pair()
    if isinstance(value, list):
        return [stored_shape(v) for v in value]
    if isinstance(value, tuple):
        return tuple(stored_shape(v) for v in value)
    if isinstance(value, dict):
        return {k: stored_shape(v) for k, v in value.items()}
    return value


def answer_shape(item: dict[str, Any]) -> tuple[int, ...] | None:
    """The declared size of a list answer (#1616), read from the item's own keys.

    ``(len(questions),)`` for a QuestionGroup and ``(len(rows), len(columns))``
    for a MatrixQuestion; None for every other kind, or when the item declares
    no such list. The keys sit on the item, never under ``input``.
    """
    kind = item.get("kind")
    if kind == "QuestionGroup":
        questions = item.get("questions")
        return (len(questions),) if isinstance(questions, list) else None
    if kind == "MatrixQuestion":
        rows, columns = item.get("rows"), item.get("columns")
        if isinstance(rows, list) and isinstance(columns, list):
            return (len(rows), len(columns))
    return None


def label_keys(input_spec: dict[str, Any]) -> list[int]:
    """The integer domain codes declared by a choice control's ``labels`` map.

    Coerces string keys (JSONB round-trips stringify object keys) and skips
    bool keys. Returns an empty list when there is no usable ``labels`` map.
    """
    keys: list[int] = []
    labels = input_spec.get("labels")
    if isinstance(labels, dict):
        for k in labels.keys():
            if isinstance(k, bool):
                continue
            if isinstance(k, int):
                keys.append(k)
            else:
                try:
                    keys.append(int(k))
                except (TypeError, ValueError):
                    pass
    return keys


def checkbox_mask(input_spec: dict[str, Any]) -> int:
    """The bitwise OR of a Checkbox's declared keys: every bit an answer may set.

    A Checkbox answers the sum of its ticked keys (the loader holds each key to
    a positive power of 2), so its domain is every value in ``0..mask`` whose
    set bits lie inside ``mask``. The runtime validator and the Z3 domain both
    read it from here. 0 when no key is declared.
    """
    mask = 0
    for key in label_keys(input_spec):
        mask |= key
    return mask
