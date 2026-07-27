"""
Shared questionnaire item-count helper.

One canonical definition of "questionnaire item count" so every cap surface
(Targetor UI, Portor REST/MCP capability layer, and thus the simulation
orchestrator) agrees on the number.

Takes QML *content*: the canonical store is Postgres, so callers resolve the
questionnaire's document text (``qml_source.load_qml_content``) and pass it
here. Derived at gate time and never persisted — a stored count goes stale the
moment the questionnaire's head advances (plan 2026-06-14-001 KTD3).

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

from askalot_qml.core.qml_loader import QMLLoader


def questionnaire_item_count(
    qml_content: str,
    logger: logging.Logger | None = None,
) -> int:
    """
    Count the top-level items in a QML questionnaire.

    Parses ``qml_content`` through the real ``QMLLoader`` — the same pipeline
    every other consumer runs — then returns the number of top-level items.
    Every item — Comment, Question, QuestionGroup, MatrixQuestion — counts as
    exactly 1; composites are NOT expanded into their sub-questions, rows, or
    cells. This equals ``len(parsed_qml["items"])`` because the loader's flat
    ``items`` list already keeps each composite as a single entry.

    Args:
        qml_content: The questionnaire's QML YAML.
        logger:      Optional logger passed through to ``QMLLoader``.

    Returns:
        The number of top-level items.

    Raises:
        ValidationError / ValueError: the QML is malformed (schema or loader
            validation failure). This helper fails loud — it never silently
            returns 0 for broken QML (monorepo "No Silent Fallbacks" rule). A
            genuinely empty-but-valid questionnaire returns 0.
    """
    loader = QMLLoader(logger=logger)
    parsed_qml = loader.load_from_string(qml_content)
    return len(parsed_qml.get("items", []))
