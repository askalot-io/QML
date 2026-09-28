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

This module stays Z3-free, so importing it never pulls Z3 into the runtime path.
``StaticBuilder._domain_constraint_builders`` (z3/) imports ``checkbox_mask``
function-locally (``askalot_qml.core``'s package ``__init__`` imports the engine,
which imports the builder), and keeps its own inline label-key loop for the
Radio/Dropdown/Switch enumeration, which does not skip bool keys.
"""

from typing import Any

# Controls whose outcome is intentional free text — never coerced to a number.
_TEXT_CONTROLS = frozenset({"textarea"})


def coerce_scalar(value: Any, control: str | None) -> Any:
    """Coerce a string ``value`` to int or float for non-text controls.

    Non-strings pass through unchanged. Textarea (any-case) preserves strings.
    A string that parses as an int becomes an int, else a float, else stays a
    string. This is the single definition ``ItemProxy._coerce_outcome`` and the
    external-input domain validator both use.
    """
    if not isinstance(value, str):
        return value
    if control and control.lower() in _TEXT_CONTROLS:
        return value
    try:
        return int(value)
    except (ValueError, TypeError):
        pass
    try:
        return float(value)
    except (ValueError, TypeError):
        pass
    return value


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
