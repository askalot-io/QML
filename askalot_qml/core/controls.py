"""
Shared control-value helpers: outcome coercion and label-key extraction.

One canonical definition of two small operations several runtime consumers need,
so the logic is not copy-pasted across ``ItemProxy``, the external-input domain
validator, and the external-item enumerator:

- ``coerce_scalar(value, control)`` — coerce a JSON/attribute string to int/float
  for non-text controls (Textarea preserves strings). JSON/MCP round-trips turn
  numeric outcomes into strings; comparisons like ``q_age.outcome >= 18`` then
  raise ``TypeError`` unless the string is coerced back.
- ``label_keys(input_spec)`` — the integer keys of a choice control's ``labels``
  map, coercing string keys (JSONB round-trips stringify object keys) and
  skipping bool keys (a ``bool`` is not a valid domain code even though it is an
  ``int`` subclass).

``StaticBuilder._domain_constraint_builders`` (z3/) keeps its OWN inline copy of
the label-key loop by design — it is a Z3-only concern and this ``core`` helper
must not pull a Z3 dependency into the runtime path; the two are allowed to
diverge because they serve different layers (KTD1: the verified envelope is
untouched).
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
