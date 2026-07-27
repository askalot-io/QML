"""
Z3 validation gate in front of canonical QML merges (plan 2026-07-21-001, R16/KTD3).

A merge result is content no human ever typed: diff3 stitched two authors'
edits into a third document that neither of them reviewed. Two individually
sound edits can compose into an unsound instrument — head gates an item on
``q_region`` while the other workspace renames ``q_region`` in a distant block,
and the merge is textually spotless yet references a name that no longer
exists. Promoting that would field a questionnaire whose skip graph is broken,
silently violating the product's "formally verified before fielding" invariant.

So every synthesised merge runs the existing publish gate, and a gate failure
**downgrades the merge to a conflict**. There is no "clean but unvalidated"
outcome: a candidate that cannot be validated — unloadable YAML, schema
failure, an analysis crash — is a conflict too, inheriting the publish gate's
fail-CLOSED policy verbatim.

The asymmetry (R16): a **fast-forward** and a **no-op** skip the gate. A
fast-forward is the content the user just wrote and is looking at, promoted
unchanged — gating it would apply publication-strength soundness to an ordinary
save, which the publish gate deliberately does not do (a work-in-progress file
is saveable with warnings; only publication requires soundness). A caller that
wants a recorded verdict for such a save calls ``evaluate_merge_gate`` on the
content directly and stamps the result itself.

The gate itself is not re-implemented here: ``evaluate_publish_gate_content``
owns the severity policy, the ``deep=True`` hierarchy choice, the fail-closed
branches, and the advisory quality report. Re-deriving any of that would fork
the definition of "sound", which is exactly what a shared gate exists to
prevent. This module only decides *when* the gate runs and what a failure
means for a merge.
"""

import logging
from dataclasses import dataclass, field, replace
from typing import Any

from askalot_common.documents.merge import MergeOutcome, MergeStatus, merge_document

from askalot_qml.core.publish_gate import error_issues, evaluate_publish_gate_content
from askalot_qml.core.qml_publish import validation_record

#: How the candidate is named in fail-closed issue messages, so a refusal reads
#: as what it is rather than as an anonymous blob.
_CANDIDATE_LABEL = "Merge candidate"


@dataclass(frozen=True)
class MergeGateVerdict:
    """Soundness judgement on one merge candidate.

    Mirrors ``PublishGateResult`` (``ok`` / ``issues`` / ``quality_report``) and
    adds ``validation`` — the per-version JSONB the document store stamps on a
    version row (R16), in the ONE canonical ``validation_record`` shape
    (``{"ok": bool, "errors": n, "warnings": n, "checked_at": iso, "source":
    "merge_gate"}``) so the pin floor's ``.get("ok")`` reads a merge-origin
    verdict exactly like a publish-door one. It is never empty here; an empty
    dict in storage means "not evaluated", which is legal for a user-authored
    save and illegal for a merge result.
    """

    ok: bool
    issues: list[dict[str, Any]] = field(default_factory=list)
    quality_report: dict[str, Any] | None = None
    validation: dict[str, Any] = field(default_factory=dict)

    @property
    def errors(self) -> list[dict[str, Any]]:
        """The blocking (error-severity) subset of ``issues``."""
        return error_issues(self.issues)


@dataclass(frozen=True)
class GatedMergeOutcome:
    """A merge outcome plus the QML verdict that may have downgraded it.

    ``merge`` is the generic outcome, already downgraded: when the gate refuses
    a textually clean merge, its status is CONFLICT while ``conflict_count``
    stays 0 and ``content`` holds the merged candidate rather than
    marker-annotated text — nothing collided *textually*, so there are no
    markers to show. ``reason`` is the diagnostic to surface in that case.

    ``verdict`` is ``None`` exactly when the gate did not run: a fast-forward, a
    no-op, or a textual conflict (running Z3 on marker-annotated text would
    only produce a misleading second diagnosis).
    """

    merge: MergeOutcome
    verdict: MergeGateVerdict | None = None
    reason: str | None = None

    @property
    def promotable(self) -> bool:
        """True iff this outcome may become the new canonical head."""
        return self.merge.is_clean


def evaluate_merge_gate(
    content: str,
    logger: logging.Logger | None = None,
) -> MergeGateVerdict:
    """Run the publish gate against in-memory QML content.

    Args:
        content: The candidate document text (a full QML file, not a fragment).
        logger: Optional logger threaded into the loader/processor.

    Returns:
        MergeGateVerdict — ``ok=False`` when the candidate is unsound or could
        not be analysed at all.
    """
    if not isinstance(content, str):
        raise TypeError(f"merge candidate must be str, got {type(content).__name__}")

    gate = evaluate_publish_gate_content(
        content, source_label=_CANDIDATE_LABEL, logger=logger
    )

    return MergeGateVerdict(
        ok=gate.ok,
        issues=gate.issues,
        quality_report=gate.quality_report,
        validation=validation_record(gate, source="merge_gate"),
    )


def _refusal_reason(verdict: MergeGateVerdict) -> str:
    """One-line, user-facing explanation of why a merge was refused."""
    errors = verdict.errors
    head = "; ".join(str(i.get("message", "")) for i in errors[:3])
    suffix = f" (+{len(errors) - 3} more)" if len(errors) > 3 else ""
    return f"Merged content failed logic validation: {head}{suffix}"


def merge_qml(
    *,
    base: str,
    head: str,
    workspace: str,
    logger: logging.Logger | None = None,
) -> GatedMergeOutcome:
    """Merge QML content 3-way and gate the result on Z3 soundness.

    Args:
        base: Content of the version the workspace materialized from.
        head: Current canonical content.
        workspace: Content the workspace is trying to promote.
        logger: Optional logger threaded into the gate.

    Returns:
        GatedMergeOutcome — ``promotable`` is True only for a no-op, a
        fast-forward, or a merge that both reconciled textually and passed the
        gate.
    """
    outcome = merge_document(base=base, head=head, workspace=workspace)

    # R16 asymmetry plus the no-gate-on-markers rule: only a synthesised merge
    # is machine-generated content that needs proving.
    if outcome.status is MergeStatus.CONFLICT or outcome.fast_forward or outcome.no_op:
        return GatedMergeOutcome(merge=outcome)

    verdict = evaluate_merge_gate(outcome.content, logger=logger)
    if verdict.ok:
        return GatedMergeOutcome(merge=outcome, verdict=verdict)

    return GatedMergeOutcome(
        merge=replace(outcome, status=MergeStatus.CONFLICT),
        verdict=verdict,
        reason=_refusal_reason(verdict),
    )
