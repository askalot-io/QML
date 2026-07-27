"""
Publish gate — the shared soundness check run before QML content can be fielded.

Pinning a questionnaire version to a campaign is the act that puts an instrument
in front of a respondent, and ``core.qml_publish`` runs this gate immediately
before it. ``core.merge_gate`` runs the same gate over a synthesised 3-way merge
candidate — content no human typed — and downgrades a failing merge to a
conflict. Those two are the doors; the invariant "questionnaires are formally
verified before fielding" is therefore structural, not prompt discipline.

The gate is deliberately NOT applied at save time: a work-in-progress QML
(sketches, pasted fragments, half-finished logic) may be saved freely with
warnings; only *publication* requires soundness.

Severity policy: the gate blocks on ``error``-severity issues only (undefined
names, frozen-gate dead code, infeasible postconditions, load/schema
failures). ``warning``-severity hygiene findings (write-only variables,
pass-through aliases, duplicate input bounds) pass the gate — they are
surfaced in the result for the caller to display. The gate fails CLOSED: if
the content cannot be loaded or the analysis itself crashes, the result is a
refusal, never a silent pass.

One entry point, and it takes CONTENT. ``evaluate_publish_gate_content`` is the
whole gate: QML is canonical in Postgres, and a merge candidate is synthesised
in memory and never belongs on disk at all, so neither caller holds a path.
Everything that defines "sound" — the severity policy, the ``deep=True``
hierarchy choice, the fail-closed branches, the advisory scorecard — lives in
``_analyze``, reached only from here, so there is no second definition of
soundness to drift against.
"""

import logging
from dataclasses import dataclass, field
from typing import Any

from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models import QMLState


def error_issues(issues: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """The blocking (error-severity) subset of a graded issue list.

    One definition of "which issues block", shared by every gate verdict that
    exposes an ``errors`` view (``PublishGateResult``, ``MergeGateVerdict``) so
    the severity filter cannot drift between them.
    """
    return [i for i in issues if i.get("severity") == "error"]


@dataclass(frozen=True)
class PublishGateResult:
    """Outcome of a publish-gate evaluation.

    ``ok`` is True iff no error-severity issue was found; ``issues`` carries
    the full graded list (same shape as ``ValidationProcessor.to_issues``:
    ``item_id`` / ``severity`` / ``type`` / ``message`` / ``suggestion``) so
    callers can render warnings even on a passing gate.

    ``quality_report`` is the advisory D2–D8 design-quality scorecard computed
    from the same validation artifacts (``compute_quality_report`` shape). It
    is ``None`` exactly when the gate failed CLOSED before analysis produced
    artifacts (missing file, load/schema failure, analysis crash) — the
    "no artifacts" signal publish doors persist as "not assessed". A file that
    loads and analyzes carries a report even when ``ok`` is False (an
    error-severity issue), because the scorecard is soundness-independent.
    """

    ok: bool
    issues: list[dict[str, Any]] = field(default_factory=list)
    quality_report: dict[str, Any] | None = None

    @property
    def errors(self) -> list[dict[str, Any]]:
        """The blocking (error-severity) subset of ``issues``."""
        return error_issues(self.issues)


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


def _analyze(
    qml_dict: dict[str, Any],
    source_label: str,
    log: logging.Logger,
) -> PublishGateResult:
    """Run Z3 static analysis on already-loaded QML and grade the result.

    The single definition of "sound". Both entry points reach it with a parsed
    document, so the verdict cannot depend on where the bytes came from.
    ``source_label`` only names the source in messages and logs.
    """
    try:
        processor = ValidationProcessor(QMLState(qml_dict))
        # deep=True runs the full validation hierarchy, including the O(items²)
        # Level 4 accumulated-dead-code pass. Publication is a deliberate,
        # infrequent action where soundness matters more than latency; the
        # interactive validate_qml_file tool keeps the default fast path.
        issues = processor.to_issues(deep=True)
    except Exception as e:
        # Fail closed: an analysis crash means soundness is unproven.
        log.error(f"Publish-gate Z3 analysis failed for {source_label}: {e}")
        return _load_failure(
            "validation_error",
            f"Static validation of '{source_label}' failed: {e}",
            "Check the file structure; run validate_qml_file for details.",
        )

    # Advisory design-quality scorecard, derived from the SAME processor's
    # artifacts (no second load/Z3 pass) and reusing the ``issues`` already
    # computed above (no redundant to_issues() walk). It never gates
    # publication, so a scorecard failure degrades to None (not assessed)
    # rather than failing an otherwise-sound gate.
    try:
        quality_report = processor.get_quality_report(issues=issues)
    except Exception as e:
        log.warning(f"Publish-gate quality report failed for {source_label}: {e}")
        quality_report = None

    ok = not any(i.get("severity") == "error" for i in issues)
    return PublishGateResult(ok=ok, issues=issues, quality_report=quality_report)


def evaluate_publish_gate_content(
    qml_content: str,
    *,
    source_label: str = "QML content",
    logger: logging.Logger | None = None,
) -> PublishGateResult:
    """Run the full publish gate on QML text held in memory.

    The real gate. Callers that already have content — a DB-canonical document,
    a synthesised merge candidate — reach soundness without a filesystem round
    trip.

    Args:
        qml_content: The QML YAML document.
        source_label: How the source is named in issue messages and logs.
        logger: Optional logger threaded into the loader/processor.

    Returns:
        PublishGateResult — ``ok=False`` when publication must be refused.
    """
    log = logger or logging.getLogger(__name__)

    # Refuse a non-string before PyYAML sees it. PyYAML duck-types any object
    # exposing ``read`` as a *stream* and calls it until it returns empty — an
    # object that answers every attribute (a test double, a lazy proxy) never
    # does, so the reader grows its buffer without bound and exhausts memory
    # instead of raising. A type error must fail closed and loudly.
    if not isinstance(qml_content, str):
        return _load_failure(
            "load_error",
            f"{source_label} is {type(qml_content).__name__}, not QML text",
            "Pass the document's content as a string.",
        )

    try:
        # No qml_dir: a string load does no relative lookups, so the gate is
        # bound to no directory at all.
        loader = QMLLoader(logger=log)
        qml_dict = loader.load_from_string(qml_content)
    except Exception as e:
        # YAML syntax, JSON-schema, and qmlVersion failures all land here — a
        # structurally broken document is saveable but never publishable.
        return _load_failure(
            "load_error",
            f"{source_label} failed to load: {e}",
            "Fix the YAML/schema errors, then run validate_qml_file until clean.",
        )

    return _analyze(qml_dict, source_label, log)
