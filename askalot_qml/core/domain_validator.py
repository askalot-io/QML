"""
Per-control runtime domain validator for injected external-input values.

`outcome_in_domain(item, value)` answers a single question: is `value` a valid
answer for `item`'s declared `input` control? It is the runtime companion to
`StaticBuilder._domain_constraint_builders` — that builder produces Z3
`BoolRef` expressions for static classification and cannot be reused to check a
concrete Python value, and no other runtime respondent-answer domain check
exists (`FlowProcessor.process_item` validates only the postcondition;
`submit_survey_response` never range-checks the outcome — a live respondent is
constrained by the client control). External inputs (QML External Inputs plan,
U2) are injected server-side with no client control in the loop, so this is the
only guard against writing an out-of-domain value (R11 / AE3).

Semantics per control (single-control `Question` items only — see below):

| Control                | Valid value                                             |
|------------------------|---------------------------------------------------------|
| Radio / Dropdown       | equals one of the integer `labels` keys                 |
| Switch                 | 0 or 1 (or the bool equivalent)                         |
| Checkbox               | a bitmask: an int ≥ 0 whose set bits are all label keys |
| Editbox / Slider / Range | `min <= v <= max` (each bound checked only if declared) |
| Textarea               | any string (free text — unconstrained)                  |

Deliberate departures from the Z3 model, both correct for a *runtime answer*:
- **Checkbox** is a bitmask at runtime (the sum of selected power-of-2 keys),
  whereas `_domain_constraint_builders` enumerates it as a single-choice
  control — a known static/runtime asymmetry the plan calls out ("Checkbox
  bitmask"). We use the true runtime domain here so a legitimate multi-select
  bitmask is not rejected.
- **Switch** carries no `labels` in the schema (it has `on`/`off`), so the Z3
  builder emits no domain constraint for it; the real runtime domain is {0, 1}.

Only `Question` items are injectable in v1. `QuestionGroup` / `MatrixQuestion`
(list / nested-list outcomes) and `Comment` return False, so an external flag
on such an item is fail-safe — the item is simply asked in the normal flow
rather than risk injecting a malformed shape.
"""

from typing import Any

from askalot_qml.core.controls import coerce_scalar, label_keys

_NUMERIC_CONTROLS = frozenset({"Editbox", "Slider", "Range"})
_SINGLE_CHOICE_CONTROLS = frozenset({"Radio", "Dropdown"})


def _is_int(value: Any) -> bool:
    """True for a genuine int (bool excluded — a bool is not a domain code)."""
    return isinstance(value, int) and not isinstance(value, bool)


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
    control = input_spec.get("control", "")

    coerced = coerce_scalar(value, control)

    if control in _NUMERIC_CONTROLS:
        if not isinstance(coerced, (int, float)) or isinstance(coerced, bool):
            return False
        min_val = input_spec.get("min")
        max_val = input_spec.get("max")
        if isinstance(min_val, (int, float)) and coerced < min_val:
            return False
        if isinstance(max_val, (int, float)) and coerced > max_val:
            return False
        return True

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
        keys = label_keys(input_spec)
        if not keys:
            # No declared labels → fail CLOSED, matching Radio/Dropdown/Switch:
            # a label-less choice control has an empty domain, so nothing is
            # injectable (the injected value is asked in the flow instead). This
            # is the only runtime domain guard, so it must not accept an
            # arbitrary integer for a degenerate item.
            return False
        mask = 0
        for k in keys:
            mask |= k
        return (coerced & ~mask) == 0

    if control == "Textarea":
        return isinstance(coerced, str)

    # Unknown / unsupported control → not injectable (fail-safe).
    return False
