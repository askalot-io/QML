"""
Publish gate — the shared soundness check run before a QML file becomes fieldable.

Creating a questionnaire entity is the act that makes a QML file fieldable
(campaigns and surveys reference the entity, not the file). Every door that
performs that act — Portor's ``publish_qml_file`` MCP tool and
``create_questionnaire`` capability, Armiger's QML Explorer publish/move
routes, Targetor's questionnaire form — must run this gate first so the
"questionnaires are formally verified before fielding" product invariant is
structural rather than prompt discipline.

The gate is deliberately NOT applied at save time: a work-in-progress QML
(sketches, pasted fragments, half-finished logic) may be saved freely with
warnings; only *publication* requires soundness.

Severity policy: the gate blocks on ``error``-severity issues only (undefined
names, frozen-gate dead code, infeasible postconditions, load/schema
failures). ``warning``-severity hygiene findings (write-only variables,
pass-through aliases, duplicate input bounds) pass the gate — they are
surfaced in the result for the caller to display. The gate fails CLOSED: if
the file cannot be loaded or the analysis itself crashes, the result is a
refusal, never a silent pass.
"""

import logging
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models import QMLState


@dataclass(frozen=True)
class PublishGateResult:
    """Outcome of a publish-gate evaluation.

    ``ok`` is True iff no error-severity issue was found; ``issues`` carries
    the full graded list (same shape as ``ValidationProcessor.to_issues``:
    ``item_id`` / ``severity`` / ``type`` / ``message`` / ``suggestion``) so
    callers can render warnings even on a passing gate.
    """

    ok: bool
    issues: list[dict[str, Any]] = field(default_factory=list)

    @property
    def errors(self) -> list[dict[str, Any]]:
        """The blocking (error-severity) subset of ``issues``."""
        return [i for i in self.issues if i.get("severity") == "error"]


def _load_failure(kind: str, message: str, suggestion: str) -> PublishGateResult:
    """Build a fail-closed refusal for a file that never reached Z3 analysis."""
    return PublishGateResult(
        ok=False,
        issues=[
            {
                "item_id": None,
                "severity": "error",
                "type": kind,
                "message": message,
                "suggestion": suggestion,
            }
        ],
    )


def evaluate_publish_gate(
    qml_dir: str | Path,
    qml_name: str,
    logger: logging.Logger | None = None,
) -> PublishGateResult:
    """Run the full publish gate (load + schema + Z3 static analysis) on a file.

    Args:
        qml_dir: Base directory the file is resolved against (org directory
            for Portor/Targetor, workspace directory for Armiger).
        qml_name: File path relative to ``qml_dir``.
        logger: Optional logger threaded into the loader/processor.

    Returns:
        PublishGateResult — ``ok=False`` when publication must be refused.
    """
    log = logger or logging.getLogger(__name__)

    try:
        loader = QMLLoader(qml_dir=str(qml_dir), logger=log)
        qml_dict = loader.load_from_file(qml_name)
    except FileNotFoundError:
        return _load_failure(
            "file_not_found",
            f"QML file '{qml_name}' not found.",
            "Save the file before publishing it.",
        )
    except Exception as e:
        # YAML syntax, JSON-schema, and qmlVersion failures all land here —
        # a structurally broken file is saveable but never publishable.
        return _load_failure(
            "load_error",
            f"QML file '{qml_name}' failed to load: {e}",
            "Fix the YAML/schema errors, then run validate_qml_file until clean.",
        )

    try:
        processor = ValidationProcessor(QMLState(qml_dict))
        issues = processor.to_issues()
    except Exception as e:
        # Fail closed: an analysis crash means soundness is unproven.
        log.error(f"Publish-gate Z3 analysis failed for {qml_name}: {e}")
        return _load_failure(
            "validation_error",
            f"Static validation of '{qml_name}' failed: {e}",
            "Check the file structure; run validate_qml_file for details.",
        )

    ok = not any(i.get("severity") == "error" for i in issues)
    return PublishGateResult(ok=ok, issues=issues)
