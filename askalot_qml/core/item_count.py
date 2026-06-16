"""
Shared questionnaire item-count helper.

One canonical definition of "questionnaire item count" so every cap surface
(Targetor UI, Portor REST/MCP capability layer, and thus the simulation
orchestrator) agrees on the number. Derived from the QML on disk at gate time —
never persisted — because a stored count goes stale the moment Armiger edits the
QML out-of-band (plan 2026-06-14-001 KTD3).

Definition of an "item" (product-owner decision): the count is the number of
TOP-LEVEL items. Every top-level item counts as exactly 1, regardless of kind:

  - ``Comment``        → 1
  - ``Question``       → 1
  - ``QuestionGroup``  → 1 (NOT expanded into its sub-questions)
  - ``MatrixQuestion`` → 1 (NOT expanded into its rows or grid cells)

The flat ``items`` list that ``QMLLoader`` produces (``qml_loader.py``
``_flatten_questionnaire_structure``) flattens *blocks* away but keeps each
composite question — a ``QuestionGroup`` or a ``MatrixQuestion`` — as a SINGLE
entry. So this count is simply ``len(items)``; no per-kind expansion is needed.
"""

import logging
from pathlib import Path

from askalot_qml.core.qml_loader import QMLLoader


def questionnaire_item_count(
    qml_dir: str | Path,
    qml_name: str,
    logger: logging.Logger | None = None,
) -> int:
    """
    Count the top-level items in a QML questionnaire.

    Loads ``qml_name`` from ``qml_dir`` exactly the way the rest of the codebase
    does (mirrors ``QMLLoader.load_from_file``; see
    ``portor .../mcp_tools/questionnaire_tools.py``), then returns the number of
    top-level items. Every item — Comment, Question, QuestionGroup,
    MatrixQuestion — counts as exactly 1; composites are NOT expanded into their
    sub-questions, rows, or cells. This equals ``len(parsed_qml["items"])``
    because the loader's flat ``items`` list already keeps each composite as a
    single entry.

    Args:
        qml_dir:  Directory containing the QML file.
        qml_name: QML filename relative to ``qml_dir`` (e.g. ``demographic.qml``).
        logger:   Optional logger passed through to ``QMLLoader``.

    Returns:
        The number of top-level items.

    Raises:
        FileNotFoundError: the QML file does not exist.
        ValidationError / ValueError: the QML is malformed (schema or loader
            validation failure). This helper fails loud — it never silently
            returns 0 for missing or broken QML (monorepo "No Silent Fallbacks"
            rule). A genuinely empty-but-valid questionnaire returns 0.
    """
    loader = QMLLoader(qml_dir=str(qml_dir), logger=logger)
    parsed_qml = loader.load_from_file(qml_name)
    return len(parsed_qml.get("items", []))
