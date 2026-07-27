"""The QML publish door — validate the head, stamp it, pin it (plan U7).

Two verbs, and the asymmetry between them is the whole product rule (R16/AE6):

Stamping (:func:`stamp_questionnaire_validation`)
    Run the Z3 publish gate over a questionnaire's head content and record the
    verdict — on the version row (``document_versions.validation``, so a pinned
    version's soundness stays answerable after the head moves on) and on the
    questionnaire row (``logic_validated`` / ``quality_report``, what the UI
    reads). This NEVER refuses. A save that breaks the logic still becomes head,
    marked invalid; work in progress must be savable, and a corpus sweep of dev
    found 13 of 45 questionnaires currently failing this gate (issue #201) —
    blocking saves would have bricked them.

Publishing (:func:`publish_questionnaire_to_campaign`)
    Stamp, then refuse unless the verdict passed, then pin
    ``campaigns.qml_version_id`` to that exact version. This is the ONLY door
    where unsound QML is turned away, because it is the only moment unsound QML
    would reach a respondent.

Why this lives in ``askalot_qml`` rather than the repository: the Z3 evaluation
is this module's, and ``askalot_common`` must not depend on it (the module
dependency direction is one-way). The *storage* half stays in
``askalot_common.repository.mixins.qml_document`` — including a fail-closed
floor in ``pin_campaign_qml_version`` that refuses a version whose recorded
verdict is not ``ok``, so bypassing this module cannot field unsound content.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass
from datetime import UTC, datetime
from typing import Any

from askalot_qml.core.publish_gate import PublishGateResult, evaluate_publish_gate_content
from askalot_qml.core.qml_source import QMLDocumentMissingError, load_qml_content

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class PublishResult:
    """Outcome of a publish attempt.

    ``pinned`` is the only success signal a caller needs; ``gate`` carries the
    graded issue list either way, so a refusal can render exactly what to fix.
    """

    ok: bool
    gate: PublishGateResult
    version_id: str
    pinned: bool = False

    @property
    def errors(self) -> list[dict[str, Any]]:
        return self.gate.errors


def validation_record(
    gate: PublishGateResult, *, checked_at: str | None = None, source: str = "publish_gate"
) -> dict[str, Any]:
    """The verdict shape stored in ``document_versions.validation``.

    Deliberately a summary, not the full issue list: the row records *whether*
    this exact content was sound and when it was judged, which is what the pin
    gate and any later audit need. The issues themselves are re-derivable from
    the immutable content at any time, so storing them would duplicate a
    recomputable artifact into every version row.

    This function is the ONE producer of the shape — every gate that stamps a
    version (publish door, merge gate) must build its record here, identified
    by ``source``, so ``pin_campaign_qml_version``'s ``.get("ok")`` floor can
    read any version's verdict regardless of which gate produced it.
    """
    errors = gate.errors
    return {
        "ok": bool(gate.ok),
        "errors": len(errors),
        "warnings": len(gate.issues) - len(errors),
        "checked_at": checked_at or datetime.now(UTC).isoformat(),
        "source": source,
    }


def evaluate_qml_content(content: str, *, source_label: str) -> tuple[PublishGateResult, dict]:
    """Gate ``content`` and return ``(gate, validation_record)`` together.

    The save doors' entry point: they hold content that is about to become head
    and need the verdict to hand to ``save_questionnaire_qml(validation=...)``
    in the same call, so the version lands already stamped rather than
    momentarily unjudged.
    """
    gate = evaluate_publish_gate_content(content, source_label=source_label, logger=logger)
    return gate, validation_record(gate)


def stamp_questionnaire_validation(
    repository: Any,
    questionnaire: Any,
    *,
    content: str | None = None,
) -> PublishGateResult:
    """Re-evaluate a questionnaire's head and record the verdict. Never refuses.

    ``content`` may be supplied when the caller already holds the head bytes
    (it just wrote them), saving a read. Otherwise the head is resolved from the
    document store.

    Writes in two places on purpose: the version row keeps the verdict bound to
    the exact bytes judged, while the questionnaire row keeps the "is this
    fieldable" answer the listing UI reads without walking versions.
    """
    document_id = getattr(questionnaire, "document_id", None)
    if not document_id:
        raise QMLDocumentMissingError(
            f"Questionnaire {getattr(questionnaire, 'id', '<unknown>')!r} has no QML document"
        )

    version = repository.get_document_content(str(document_id))
    if version is None:
        raise QMLDocumentMissingError(
            f"QML document {document_id!r} has no content to validate"
        )
    body = content if content is not None else version.content

    gate = evaluate_publish_gate_content(
        body,
        source_label=f"questionnaire {getattr(questionnaire, 'id', '<unknown>')}",
        logger=logger,
    )
    checked_at = datetime.now(UTC).isoformat()
    repository.stamp_qml_version_validation(version.id, validation_record(gate, checked_at=checked_at))

    questionnaire.logic_validated = gate.ok
    questionnaire.logic_validated_at = checked_at
    # Assigned unconditionally: a gate that failed CLOSED (unparseable content)
    # produces no scorecard, and that must clear the stored one to "not
    # assessed" rather than leave a stale report standing (R7).
    questionnaire.quality_report = gate.quality_report
    questionnaire.quality_report_at = checked_at if gate.quality_report is not None else None
    repository.upsert_questionnaire(questionnaire)
    return gate


def publish_questionnaire_to_campaign(
    repository: Any,
    *,
    campaign_id: str,
    questionnaire: Any,
) -> PublishResult:
    """Validate the questionnaire's head and pin it to the campaign (R17, AE6).

    Order is load-bearing: stamp first (so the verdict is durable even when the
    publish is refused and the user goes back to fix the QML), refuse second,
    pin last. A refusal writes no pin at all — the campaign keeps whatever it
    was fielding, which for a live campaign is the previously validated version
    and for a new one is nothing.
    """
    head_content = load_qml_content(repository, questionnaire)
    gate = stamp_questionnaire_validation(repository, questionnaire, content=head_content)
    version = repository.get_document_content(str(questionnaire.document_id))

    if not gate.ok:
        logger.info(
            "publish refused: campaign=%s questionnaire=%s errors=%d",
            campaign_id,
            getattr(questionnaire, "id", "<unknown>"),
            len(gate.errors),
        )
        return PublishResult(ok=False, gate=gate, version_id=version.id, pinned=False)

    repository.pin_campaign_qml_version(campaign_id, version.id)
    return PublishResult(ok=True, gate=gate, version_id=version.id, pinned=True)


def publish_refusal_message(gate: PublishGateResult, *, limit: int = 5) -> str:
    """One human sentence naming what must be fixed before fielding.

    Takes the gate verdict directly — a refusal is decided by the error list
    the gate carries, and a caller that has only run the gate (no pin, no
    version yet) has no ``PublishResult`` to hand over. Callers holding a full
    ``PublishResult`` pass its ``.gate``.
    """
    errors = gate.errors
    preview = "; ".join(f"[{i.get('type')}] {i.get('message')}" for i in errors[:limit])
    more = " (more issues truncated)" if len(errors) > limit else ""
    return (
        f"Publish gate failed — {len(errors)} error-severity issue(s): {preview}{more}. "
        "Fix them (validate_qml_file shows the full report), then publish again."
    )
