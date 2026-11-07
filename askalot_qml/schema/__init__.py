"""QML schema definitions bundled with the askalot_qml package.

The QML schema is a *consumed contract* (authors, the AI questionnaire
generator, the loader, and the qml-explorer frontend all depend on its
shape). It is versioned with Major.Minor.Patch **compatibility** semantics,
deliberately decoupled from the askalot_qml package version:

- MAJOR — breaking: existing valid QML may stop loading, or an existing
  construct's meaning changes. Authors/AI must migrate.
- MINOR — backward-compatible addition: a new optional capability; every
  older document remains valid (e.g. the optional Roster ``subjectFrom``
  key at 2.1.0).
- PATCH — no contract change: clarified text, a schema-bug fix, or
  tightening a constraint that was already de-facto enforced.

The canonical version is the top-level ``version`` field of
``qml-schema.json`` — the single source of truth. ``QML_SCHEMA_VERSION`` is
read from that file at import (no hardcoded copy that could drift; loud
failure if the field is missing, per the no-silent-fallbacks rule).

``schema_refusal`` is the one choice of which schema error a refusal reports,
shared by the loader and Portor's save-time warning.
"""

import json
from collections.abc import Iterable
from pathlib import Path

from jsonschema.exceptions import ValidationError, best_match

SCHEMA_PATH = Path(__file__).parent / "qml-schema.json"


def _read_schema_version() -> str:
    """Return the canonical schema version from the bundled qml-schema.json.

    Raises loudly (KeyError / FileNotFoundError) rather than defaulting — the
    schema version is a required contract signal, not an optional setting.
    """
    with open(SCHEMA_PATH, encoding="utf-8") as schema_file:
        schema = json.load(schema_file)
    return schema["version"]


QML_SCHEMA_VERSION = _read_schema_version()


def schema_refusal(errors: Iterable[ValidationError]) -> ValidationError | None:
    """The schema error that names the defect, or ``None`` when there is none.

    ``best_match`` prefers the shallowest error, and a closed object reports a
    property whose own subschema failed as unevaluated: a Radio's misspelt
    ``lables`` fails ``$defs.Input``, so the Item also reports "'input' was
    unexpected", and that shallower error wins. An author (or the Designer
    agent) told to drop ``input`` deletes the wrong key (#186). So an
    ``unevaluatedProperties`` error is set aside whenever another error lies
    beneath it — it is that error's cascade — and ``best_match`` chooses among
    the rest.
    """
    errors = list(errors)
    paths = [tuple(e.absolute_path) for e in errors]

    def is_cascade(error: ValidationError, path: tuple) -> bool:
        return error.validator == "unevaluatedProperties" and any(
            len(other) > len(path) and other[: len(path)] == path for other in paths
        )

    return best_match(e for e, path in zip(errors, paths, strict=True) if not is_cascade(e, path))
