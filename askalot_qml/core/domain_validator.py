"""
Per-control domain validator: injected external-input values, every answer, and every control default.

`outcome_in_domain(item, value)` answers a single question: is `value` a valid
answer for `item`'s declared `input` control? It is the runtime companion to
`StaticBuilder._domain_constraint_builders` — that builder produces Z3
`BoolRef` expressions for static classification and cannot be reused to check a
concrete Python value. `answer_refusal` judges every answer `FlowProcessor.process_item`
receives (#1757), whatever its driver, and `outcome_in_domain` lets the
external-input prefill (QML External Inputs plan, U2) decline an out-of-domain
value before it reaches `process_item` (R11 / AE3).

Semantics per control (single-control `Question` items only — see below):

| Control                | Valid value                                             |
|------------------------|---------------------------------------------------------|
| Radio / Dropdown       | equals one of the integer `labels` keys                 |
| Switch                 | 0 or 1 (or the bool equivalent)                         |
| Checkbox               | a bitmask: an int ≥ 0 whose set bits are all label keys |
| Editbox / Slider       | a finite whole number, `min <= v <= max` (each bound checked only if declared). The schema gives both integer bounds and no fractional `step`, and Z3 models them as Int (D90) |
| Range                  | a pair `[low, high]` of whole numbers with `min <= low <= high <= max` (Z3 models both ends as Int) |
| Textarea               | any string (free text — unconstrained)                  |

A **Range** answer is a pair (#1474): its shape (two finite numbers, `low <=
high`, each end coerced) is `core.controls.range_pair`, the same rule ItemProxy
enforces; each end must be whole (D90, the schema's Range bounds and `step` are
integers like a Slider's, #1801) and in bounds. A single number is not a
Range answer however in-bounds it is, so a scalar prefill is declined.
`None` is refused here like for every control: it is no value to inject.

A **Checkbox** is a bitmask here and in the Z3 model alike
(`_domain_constraint_builders`, #1140): any sum of distinct declared keys,
0 included. One deliberate departure from the Z3 model remains, correct for a
*runtime answer*:
- **Switch** carries no `labels` in the schema (it has `on`/`off`), so the Z3
  builder emits no domain constraint for it; the real runtime domain is {0, 1}.

Only `Question` items are injectable in v1. `QuestionGroup` / `MatrixQuestion`
(list / nested-list outcomes) and `Comment` return False, so an external flag
on such an item is fail-safe — the item is simply asked in the normal flow
rather than risk injecting a malformed shape.

`answer_refusal(item, value)` is the same per-control rule applied to an
**answer** (#1757): `FlowProcessor.process_item` asks it before accepting one.
Browsers only emit in-domain values, but an MCP or REST submit and the
AI-assisted respondent lane pass the caller's value through, and an answer
outside the declared domain walks the respondent onto items the static
validator proved unreachable. It differs from the prefill gate where an answer
differs from an injection:
- `None` is allowed (no answer); a Comment takes no other value.
- A QuestionGroup answer is a list of at most one cell per entry of the item's
  `questions` (a shorter list leaves the rest unanswered, as ItemProxy pads it),
  and a MatrixQuestion answer is `rows` × `columns` (#1616); each non-None cell
  is judged by the item's one control.
- An item with no `input`, or a control this module does not know, is not
  judged (the schema closes the control set; refusing what cannot be judged
  would trap a respondent).
- The caller decides what a refusal means: `process_item` refuses a forward
  answer, and ignores one sent as the backward convenience save (whose flag the
  client sets), leaving the item as it was.
- A number's refusal names the declared bounds ("enter a whole number between
  0 and 100"), which a respondent can act on; the bounds are the author's, not data.
The reason it returns never quotes the value, which is respondent data.

`default_refusal(input_spec)` applies the same rule to a control's `default`
(#1823): the loader refuses a resting hint no answer could match, and the
phrase it returns names the domain the default lies outside.
"""

import math
from typing import Any

from askalot_qml.core.controls import (
    MAX_SAFE_INTEGER,
    answer_shape,
    checkbox_mask,
    coerce_scalar,
    label_keys,
    range_pair,
)

_NUMERIC_CONTROLS = frozenset({"Editbox", "Slider"})
_SINGLE_CHOICE_CONTROLS = frozenset({"Radio", "Dropdown"})


def _is_int(value: Any) -> bool:
    """True for a genuine int (bool excluded — a bool is not a domain code)."""
    return isinstance(value, int) and not isinstance(value, bool)


def _within_bounds(number: int | float, input_spec: dict[str, Any]) -> bool:
    """``min <= number <= max``, each bound checked only if declared, and never
    past ``MAX_SAFE_INTEGER`` either way: the survey's Editbox marks such a
    number invalid, so an undeclared bound must not let the server take it."""
    if abs(number) > MAX_SAFE_INTEGER:
        return False
    min_val = input_spec.get("min")
    max_val = input_spec.get("max")
    if isinstance(min_val, (int, float)) and number < min_val:
        return False
    if isinstance(max_val, (int, float)) and number > max_val:
        return False
    return True


# Every control ``_in_control_domain`` judges; a control outside this set is
# not judged by ``answer_refusal`` (the schema closes the set).
_JUDGED_CONTROLS = (
    _NUMERIC_CONTROLS | _SINGLE_CHOICE_CONTROLS | {"Switch", "Checkbox", "Range", "Textarea"}
)
_OUT_OF_DOMAIN = "the answer is not one of this item's allowed values"


def answer_refusal(item: dict[str, Any], value: Any) -> str | None:
    """Why ``value`` is no valid answer for ``item``, or None when it is (#1757).

    See the module docstring for how this differs from ``outcome_in_domain``.
    """
    if value is None:
        return None
    kind = item.get("kind")
    if kind == "Comment":
        return "a Comment takes no answer"
    input_spec = item.get("input")
    if not isinstance(input_spec, dict) or input_spec.get("control") not in _JUDGED_CONTROLS:
        return None
    if kind == "Question":
        return None if _in_control_domain(input_spec, value) else _out_of_domain(input_spec)
    shape = answer_shape(item)
    if kind == "QuestionGroup":
        # A short list is unanswered questions (ItemProxy pads it with None);
        # only more cells than questions is a wrong shape.
        size = shape[0] if shape else 0
        if not isinstance(value, list) or len(value) > size:
            return f"a QuestionGroup answer lists at most one value per question ({size})"
        where = "question {}"
        cells = (((i,), cell) for i, cell in enumerate(value))
    elif kind == "MatrixQuestion":
        rows, columns = shape if shape else (0, 0)
        if not (
            isinstance(value, list)
            and len(value) == rows
            and all(isinstance(row, list) and len(row) == columns for row in value)
        ):
            return f"a MatrixQuestion answer is {rows} rows of {columns} values"
        where = "row {}, column {}"
        cells = (((r, c), cell) for r, row in enumerate(value) for c, cell in enumerate(row))
    else:
        return None
    # The cell's position is formatted only for the refusal, not for every cell.
    for index, cell in cells:
        if cell is not None and not _in_control_domain(input_spec, cell):
            return f"{_out_of_domain(input_spec)} ({where.format(*(n + 1 for n in index))})"
    return None


def _out_of_domain(input_spec: dict[str, Any]) -> str:
    """The refusal a respondent reads: the declared bounds for a number (an
    author's range, never the answer), the generic wording otherwise."""
    if input_spec.get("control") not in _NUMERIC_CONTROLS:
        return _OUT_OF_DOMAIN
    return f"enter {_whole_number_phrase(input_spec)}"


def _whole_number_phrase(input_spec: dict[str, Any]) -> str:
    """The phrase "a whole number between 0 and 10", naming each declared bound."""
    lo, hi = input_spec.get("min"), input_spec.get("max")
    if isinstance(lo, (int, float)) and isinstance(hi, (int, float)):
        return f"a whole number between {lo} and {hi}"
    if isinstance(lo, (int, float)):
        return f"a whole number of at least {lo}"
    if isinstance(hi, (int, float)):
        return f"a whole number of at most {hi}"
    return "a whole number"


def default_refusal(input_spec: dict[str, Any]) -> str | None:
    """The domain an input's ``default`` lies outside, as a phrase, or None (#1823).

    A default is a hint, never an answer (#1166): the control rests there and
    nothing is recorded until the respondent acts. A hint no answer could
    match is still an authoring error, because a respondent who confirms the
    resting position submits a value the answer check refuses. So the default
    is judged by the same per-control rule as an answer (``_in_control_domain``),
    and only that: an input with no default, or a control this module does not
    judge, is not refused. The loader names the item; the phrase names the
    domain in the author's own terms (bounds, label keys).
    """
    default = input_spec.get("default")
    control = input_spec.get("control")
    if default is None or control not in _JUDGED_CONTROLS:
        return None
    if _in_control_domain(input_spec, default):
        return None
    if control == "Range":
        lo, hi = input_spec.get("min"), input_spec.get("max")
        return (
            f"a pair [low, high] of whole numbers with {lo} <= low <= high <= {hi}"
            if isinstance(lo, (int, float)) and isinstance(hi, (int, float))
            else "a pair [low, high] of whole numbers with low <= high"
        )
    if control in _NUMERIC_CONTROLS:
        return _whole_number_phrase(input_spec)
    keys = ", ".join(str(key) for key in label_keys(input_spec))
    if control in _SINGLE_CHOICE_CONTROLS:
        return f"one of its label keys ({keys})"
    if control == "Checkbox":
        return f"a sum of distinct label keys ({keys}), or 0"
    if control == "Switch":
        return "0 (off) or 1 (on)"
    return "text"


def outcome_in_domain(item: dict[str, Any], value: Any) -> bool:
    """Return True iff ``value`` is a valid answer for ``item``'s control domain.

    Fail-safe by design: any shape the validator cannot positively confirm
    (None, a non-Question kind, an unknown control, a missing `input` spec)
    returns False, so the caller (the U2 resolver) leaves the item unresolved
    and it is asked in the normal flow.
    """
    if value is None:
        return False
    # Only single-control Question items are injectable in v1.
    if item.get("kind") != "Question":
        return False

    input_spec = item.get("input")
    if not isinstance(input_spec, dict):
        return False
    return _in_control_domain(input_spec, value)


def _in_control_domain(input_spec: dict[str, Any], value: Any) -> bool:
    """Whether a non-None ``value`` is in the domain of ``input_spec``'s control."""
    control = input_spec.get("control", "")

    if control == "Range":
        try:
            low, high = range_pair(value)
        except ValueError:
            return False
        # D90: Z3 models both ends as Int, like an Editbox / Slider answer.
        if low != int(low) or high != int(high):
            return False
        return _within_bounds(low, input_spec) and _within_bounds(high, input_spec)

    coerced = coerce_scalar(value, control)

    if control in _NUMERIC_CONTROLS:
        if not isinstance(coerced, (int, float)) or isinstance(coerced, bool):
            return False
        # NaN compares False with every bound, so it would pass _within_bounds;
        # it is no number on any scale (and JSONB cannot store it). Only a
        # float can be non-finite: an int is not converted, so one too large
        # for a float is judged by its bounds rather than raising (#1824).
        if isinstance(coerced, float) and not math.isfinite(coerced):
            return False
        # D90: Z3 models these answers as Int, and the schema allows no
        # fractional step (#1801), so a fraction is out of the domain.
        if coerced != int(coerced):
            return False
        return _within_bounds(coerced, input_spec)

    if control in _SINGLE_CHOICE_CONTROLS:
        return _is_int(coerced) and coerced in label_keys(input_spec)

    if control == "Switch":
        # Switch domain is {off=0, on=1}; accept the bool equivalents too.
        if isinstance(value, bool):
            return True
        return _is_int(coerced) and coerced in (0, 1)

    if control == "Checkbox":
        # Bitmask: non-negative int whose set bits are all declared label keys.
        if not _is_int(coerced) or coerced < 0:
            return False
        mask = checkbox_mask(input_spec)
        if not mask:
            # No declared labels → fail CLOSED, matching Radio/Dropdown/Switch:
            # a label-less choice control has an empty domain, so nothing is
            # injectable (the injected value is asked in the flow instead). This
            # is the only runtime domain guard, so it must not accept an
            # arbitrary integer for a degenerate item.
            return False
        return (coerced & ~mask) == 0

    if control == "Textarea":
        return isinstance(coerced, str)

    # Unknown / unsupported control → not injectable (fail-safe).
    return False
