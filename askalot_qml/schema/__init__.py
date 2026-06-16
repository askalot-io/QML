"""QML schema definitions bundled with the askalot_qml package.

The QML schema is a *consumed contract* (authors, the AI questionnaire
generator, the loader, and the qml-explorer frontend all depend on its
shape). It is versioned with Major.Minor.Patch **compatibility** semantics,
deliberately decoupled from the askalot_qml package version:

- MAJOR — breaking: existing valid QML may stop loading, or an existing
  construct's meaning changes. Authors/AI must migrate.
- MINOR — backward-compatible addition: a new optional capability; every
  older document remains valid (e.g. the additive `Sample` block kind).
- PATCH — no contract change: clarified text, a schema-bug fix, or
  tightening a constraint that was already de-facto enforced.

The canonical version is the top-level ``version`` field of
``qml-schema.json`` — the single source of truth. ``QML_SCHEMA_VERSION`` is
read from that file at import (no hardcoded copy that could drift; loud
failure if the field is missing, per the no-silent-fallbacks rule).
"""

import json
from pathlib import Path

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
