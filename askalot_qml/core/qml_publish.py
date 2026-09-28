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
    blocking saves would have bricked them. A door that already graded the
    version it wrote (Portor's save, Armiger's merge promotion) records that
    verdict through :func:`record_questionnaire_verdict` instead of stamping
    again.

Publishing (:func:`pin_validated_version`)
    Pin ``campaigns.qml_version_id`` to a version a stamp already passed. It
    takes the :class:`PublishTicket` the stamp returned rather than a
    questionnaire, because the two halves run at different moments: a campaign
    row must exist before it can be pinned, and an unsound questionnaire must be
    refused *before* that row is written. Publishing is therefore the ONLY door
    where unsound QML is turned away — it is the only moment unsound QML would
    reach a respondent — but the refusal happens at the stamp, and the pin
    redeems a ticket that has already passed.

    :func:`publish_questionnaire_to_campaign` composes the two for the callers
    that publish against an already-existing campaign and have nothing to write
    in between.

Why a ticket rather than "just stamp again inside the pin": the gate is the
O(items²) Level-4 Z3 pass, and every campaign create / edit / rebind ran it
TWICE over byte-identical content because the pin re-derived what the caller had
already computed (issue #212). The ticket also removes a TOCTOU the second stamp
introduced — the pinned version is now provably the one whose verdict the caller
was shown, not whatever became head while the campaign row was being written.

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
from askalot_qml.core.qml_source import QMLDocumentMissingError

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class PublishTicket:
    """A recorded verdict, bound to the exact version it judged.

    What :func:`stamp_questionnaire_validation` hands back so a caller can pin
    later without re-running the gate. ``version_id`` is the version the verdict
    was written onto, which is what makes the ticket redeemable: the pin's
    fail-closed floor reads that row's stored verdict, so a ticket cannot be
    used to field content the gate never judged.

    A ticket is only meaningful within the request that minted it. Nothing
    persists or transports one — a later publish takes a fresh stamp, because
    head may have moved.
    """

    gate: PublishGateResult
    version_id: str

    @property
    def ok(self) -> bool:
        """Whether the gate passed — i.e. whether this ticket may be pinned."""
        return self.gate.ok


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


def record_questionnaire_verdict(
    questionnaire: Any,
    *,
    ok: bool,
    checked_at: str | None,
    quality_report: dict[str, Any] | None,
    version_id: str,
) -> None:
    """Write one gate run's verdict onto a questionnaire row. Does not persist.

    The single writer of the row's verdict columns, so they move together:
    the scorecard names the version it graded (#540), and a gate that failed
    CLOSED (unparseable content, no scorecard) clears the stored report to "not
    assessed" rather than leaving a stale one standing (R7). ``version_id`` must
    be the version whose bytes the gate judged; the caller upserts.
    """
    graded = quality_report is not None
    questionnaire.logic_validated = ok
    questionnaire.logic_validated_at = checked_at
    questionnaire.quality_report = quality_report
    questionnaire.quality_report_at = checked_at if graded else None
    questionnaire.quality_report_version_id = str(version_id) if graded else None


def stamp_questionnaire_validation(repository: Any, questionnaire: Any) -> PublishTicket:
    """Re-evaluate a questionnaire's head and record the verdict. Never refuses.

    Grades exactly the version it stamps: the head is read once, and both the
    gate run and the recorded ids come from that read.

    Writes in two places on purpose: the version row keeps the verdict bound to
    the exact bytes judged, while the questionnaire row keeps the "is this
    fieldable" answer the listing UI reads without walking versions.

    Returns a :class:`PublishTicket` rather than the bare verdict so a caller
    that must refuse *before* writing a campaign row can then pin the version it
    actually judged, instead of paying for a second gate run that would resolve
    head again (#212).
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
    gate = evaluate_publish_gate_content(
        version.content,
        source_label=f"questionnaire {getattr(questionnaire, 'id', '<unknown>')}",
        logger=logger,
    )
    checked_at = datetime.now(UTC).isoformat()
    repository.stamp_qml_version_validation(version.id, validation_record(gate, checked_at=checked_at))
    record_questionnaire_verdict(
        questionnaire,
        ok=gate.ok,
        checked_at=checked_at,
        quality_report=gate.quality_report,
        version_id=version.id,
    )
    repository.upsert_questionnaire(questionnaire)
    return PublishTicket(gate=gate, version_id=version.id)


def pin_validated_version(
    repository: Any,
    *,
    campaign_id: str,
    ticket: PublishTicket,
) -> str:
    """Field the ticket's version on the campaign (R17, AE6). Returns its id.

    The publish half, split out so a caller can refuse an unsound questionnaire
    before writing the campaign row the pin needs (Portor's ``create_campaign``,
    Targetor's new/edit forms) without re-running the gate afterwards.

    A ticket whose verdict did not pass is a caller-ordering bug, not a runtime
    outcome — the refusal belongs at the stamp, where there is still no campaign
    row to leave behind — so this raises rather than returning a soft failure a
    caller might not check. ``pin_campaign_qml_version``'s own fail-closed floor
    (it re-reads the version's stored verdict) is the backstop underneath.
    """
    if not ticket.ok:
        raise ValueError(
            f"refusing to pin version {ticket.version_id!r} to campaign {campaign_id!r}: "
            f"its recorded verdict has {len(ticket.gate.errors)} error(s). A failing "
            "verdict must be refused at the stamp, before the campaign row is written."
        )
    repository.pin_campaign_qml_version(campaign_id, ticket.version_id)
    return ticket.version_id


def publish_questionnaire_to_campaign(
    repository: Any,
    *,
    campaign_id: str,
    questionnaire: Any,
) -> PublishResult:
    """Validate the questionnaire's head and pin it to an existing campaign.

    The one-shot composition of the two verbs, for callers publishing against a
    campaign that already exists and having nothing to write in between (the
    ``publish_qml_file`` MCP tool). Callers that must create or update the
    campaign row between the refusal and the pin stamp and pin separately —
    doing both here would gate the same bytes twice (#212).

    Order is load-bearing: stamp first (so the verdict is durable even when the
    publish is refused and the user goes back to fix the QML), refuse second,
    pin last. A refusal writes no pin at all — the campaign keeps whatever it
    was fielding, which for a live campaign is the previously validated version
    and for a new one is nothing.
    """
    ticket = stamp_questionnaire_validation(repository, questionnaire)

    if not ticket.ok:
        logger.info(
            "publish refused: campaign=%s questionnaire=%s errors=%d",
            campaign_id,
            getattr(questionnaire, "id", "<unknown>"),
            len(ticket.gate.errors),
        )
        return PublishResult(
            ok=False, gate=ticket.gate, version_id=ticket.version_id, pinned=False
        )

    pin_validated_version(repository, campaign_id=campaign_id, ticket=ticket)
    return PublishResult(ok=True, gate=ticket.gate, version_id=ticket.version_id, pinned=True)


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
