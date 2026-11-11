"""The survey flow engine's steps, free of Flask, shared by every walk driver.

SirWay's flow blueprint (``flow_blueprint.py``) and Portor's respondent lane
both walk a survey through these functions, so a flow fix lands on every walk
a person takes. The blueprint keeps only what is HTTP: request parsing,
the flow-session check, and response shaping. Nothing here touches ``flask``,
``g`` or ``request``; the functions run outside any application context.

Each step is split into three phases, because the respondent lane runs on an
event loop and must keep the CPU-bound part off it:

1. **Load** — repository reads: the walk itself (``FlowStore.load``) and, when
   the walk has no state yet, its instrument text (``load_instrument``).
2. **Compute** — ``compute_*``: QML parse, ``FlowProcessor`` work (including
   the Z3 initialization of a first item) and timing seams, all on the
   in-memory walk. A compute function takes no repository and no store; what
   it decides to write comes back on the returned ``FlowStep``.
3. **Persist** — ``persist_step``: the one walk write and the audit events the
   compute phase asked for.

The composed functions (``present_current_item``, ``evaluate_item``, ...) run
the three phases in order for a synchronous caller such as the blueprint.

One exception to "compute takes no repository": the service-supplied
``external_input_resolver`` runs during initialization (it needs the processor
the parse just built) and SirWay's resolver reads the survey's campaign and
respondent through the repository. It is fail-safe and runs once per walk.

Reading is split from presenting. ``present_current_item`` opens the item's
timing event; ``read_current_state`` never does, so a caller that only needs
to know where the walk stands (a view remounting from an old transcript, a
stale iframe) records no answer time. Presenting is what the web
survey does on every render, and the event's idempotence keeps a refresh from
resetting the respondent's clock.

Every presenting step takes the answer ``source`` (who answers) and the
``channel`` (which surface presented the item, ``web`` or ``ai``) from its
caller. Neither has a default: only the driver knows them. The channel is
written on the timing event, so a survey that switches channel can be
analysed answer by answer.

Constraints carried over unchanged from the blueprint and pinned by its tests:
timing opens at presentation and closes in ``process_item``; a step that moves
the answerer off an unanswered item closes its event uncommitted; the
``skip_postcondition`` back path saves an answer without validating it; and
answering an earlier item rewinds the walk (B256), which ``process_item`` does
for every driver. Items handed back to callers are shallow copies, so the
per-response decoration (navigation progress, roster banner fields) never
lands in the stored state.

A survey's language is chosen before its first answer (``choose_language``).
The pick re-materializes the walk from the campaign's current pin with the
translation's text overlaid (``apply_translation``), so every later text exit
reads translated text from state and a re-pin never changes what a survey in
progress shows. It records the translation row it copied in
``qml_state[LANGUAGE_PICK_KEY]``, which the repository compares at the first
answer (see ``askalot_common.repository.mixins.survey``). The first committed
answer locks the pick; only a complete translation is offered
(``offered_languages``), so nothing falls back to source text item by item.
The languages offered are the version's own: its source language, supported
or "other" (any well-formed BCP-47 code), and its complete translations.

An answer names the pick it was shown under (``pick_token``, the record's id
from ``language_pick_token``, ``None`` for a walk no pick re-materialized).
Every presentation carries it to the driver's page or view, and
``compute_evaluate_item`` refuses an answer whose token is not the stored
walk's (``PICK_CHANGED``, nothing written): another tab picked a language
after this page rendered, and the answer would otherwise land on, and freeze,
text the respondent never saw (#2127).
"""

from __future__ import annotations

import logging
from collections.abc import Callable
from dataclasses import dataclass, field
from enum import StrEnum
from typing import Any

from askalot_common.campaign_admission import has_committed_answer
from askalot_common.i18n.locale import require_questionnaire_language
from askalot_common.repository.mixins.survey import (
    LANGUAGE_PICK_KEY,
    SurveyLanguageLockedError,
    SurveyLanguageNotOfferedError,
    SurveyLanguagePinMovedError,
    language_pick_record,
    language_pick_token,
)

from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_source import load_fielded_qml_content, load_qml_content
from askalot_qml.core.qml_translation import apply_translation, seed_translations
from askalot_qml.models.qml_state import (
    SOURCE_INTERVIEWER,
    SOURCE_RESPONDENT,
    TIMING_CHANNELS,
    QMLState,
)

logger = logging.getLogger(__name__)

#: ``audit_callback(entity_type, entity_id, action, context_extra)`` — the
#: service supplies it so askalot_qml stays free of the audit transport.
AuditCallback = Callable[[str, str, str, dict[str, Any] | None], None]

#: ``resolver(walk, processor) -> None`` applying external-input prefill at
#: initialization (QML External Inputs plan, U5). The service reads the walk's
#: campaign mapping and respondent and calls
#: ``processor.apply_external_inputs``. Must never raise: prefill is an
#: optimization, never a blocker.
ExternalInputResolver = Callable[[Any, Any], None]


class FlowStore:
    """Where a walk's state lives — surveys, or the preview store.

    A preview is a design-time walk of an instrument, so it is not a case and
    its state does not belong in ``surveys``. Both kinds run this same engine
    — same navigation, same postcondition ordering, same timing log, same
    degradation warnings — and only the destination differs; a second engine
    for previews would mean a flow fix could land on only half of walks, which
    is the failure ``preview.py`` already warns about for its own launch path.

    The kind is resolved from the id the caller's credential named, on the
    first read, and remembered for the life of this object. It is NOT taken
    from a caller-supplied parameter: a caller able to name its own store
    could ask for a survey to be served through the store that skips the
    sealed-organization write refusal. One instance serves one request, so a
    process serving preview and fielded walks concurrently never mixes kinds.

    Both lookups are organization-scoped, so an id belonging to another
    organization resolves to nothing in either store — the probe cannot be
    used to learn that a row exists elsewhere.
    """

    def __init__(self, repository):
        self.repository = repository
        self.kind: str | None = None

    def load(self, run_id):
        """Read the walk, resolving which store holds it on the first call."""
        if self.kind == "survey":
            return self.repository.get_survey(run_id)
        if self.kind == "preview":
            return self.repository.get_preview_run(run_id)

        # Surveys are probed first because fielded interviews are the volume
        # path — a campaign has thousands of them where an organization has a
        # handful of live previews — so the common request pays no extra
        # lookup and only a preview pays one. Either order is safe: both
        # lookups are org-scoped and the ids are UUIDs from separate tables.
        walk = self.repository.get_survey(run_id)
        if walk is not None:
            self.kind = "survey"
            return walk
        self.kind = "preview"
        return self.repository.get_preview_run(run_id)

    def save(self, walk) -> None:
        """Persist the advanced walk to whichever store it came from.

        A preview writes only the state the walk moved — the expiry belongs to
        the credential that minted the run, so answering must not extend it. A
        survey is written whole through ``save_survey_walk``, which refuses one
        in a sealed organization (how the seal reaches every step here) and
        raises ``SurveyStateConflictError`` when the row changed since this
        walk was read: two steps overlapping on one survey must not let the
        later write restore what it had read over what the earlier one saved.
        """
        if self.kind == "preview":
            self.repository.update_preview_run_state(
                walk.id,
                qml_state=walk.qml_state,
                current_block_id=walk.current_block_id,
                current_item_id=walk.current_item_id,
                status=walk.status,
            )
            return
        self.repository.save_survey_walk(walk)


class FlowOutcome(StrEnum):
    """What a step concluded — the caller maps it onto its own transport."""

    ITEM = "item"  # An item is in front of the answerer (``FlowStep.item``)
    JUST_COMPLETED = "just_completed"  # This step found the walk finished and completed it
    COMPLETED = "completed"  # The walk was already completed (``item``: its last item, if any)
    AT_END = "at_end"  # Nothing left to present, walk not completed (reading only)
    ACCEPTED = "accepted"  # The answer was recorded
    REJECTED = "rejected"  # The answer was refused (``message`` holds the hint)
    PICK_CHANGED = "pick_changed"  # The answer was shown under an earlier language pick
    NO_PREVIOUS = "no_previous"  # Backward navigation from the first item
    ITEM_NOT_FOUND = "item_not_found"  # The navigation target is not in the instrument
    NAVIGATION_REFUSED = "navigation_refused"  # The target is not reachable yet
    FINISHED = "finished"  # Finished early
    ALREADY_COMPLETED = "already_completed"  # Finish on a completed walk
    NOT_COMPLETED = "not_completed"  # Resume on a walk that is not completed
    RESUMED = "resumed"  # Resumed (``item``: the re-presented item, if any)


@dataclass
class FlowStep:
    """The compute phase's verdict, and what the persist phase must write.

    ``persist`` and ``audit_actions`` are instructions, not history: the
    compute phase has already changed the in-memory walk, and nothing reaches
    the store or the audit trail until ``persist_step`` runs.
    """

    outcome: FlowOutcome
    item: dict[str, Any] | None = None
    #: The walk's status was ``completed`` when the step began.
    was_completed: bool = False
    message: str | None = None
    #: Print output of the answered item's codeBlock, when it produced any.
    output: list[str] | None = None
    #: Whether a reachable unvisited item remains — set after persist, see
    #: ``has_next_item``.
    has_next: bool | None = None
    persist: bool = False
    audit_actions: list[str] = field(default_factory=list)
    processor: FlowProcessor | None = field(default=None, repr=False)


# ---------------------------------------------------------------------------
# Load phase
# ---------------------------------------------------------------------------


#: The ``qml_state`` key ``close_walk`` sets: this walk was completed at least once.
WALK_ONCE_COMPLETED = "completed_once"


def prepare_walk(walk):
    """Wrap a loaded walk's ``qml_state`` dict in ``QMLState``.

    The repository returns the state as a plain dict (askalot_common depends on
    no askalot_* module, #150); wrapping happens at this flow boundary.
    Reassigned on the walk so in-place mutations reach what the store writes.
    """
    if walk.qml_state and not isinstance(walk.qml_state, QMLState):
        walk.qml_state = QMLState(walk.qml_state)
    return walk


def needs_instrument(walk, *, itemless_counts: bool) -> bool:
    """Whether the step about to run must initialize the walk first.

    ``itemless_counts`` is True only for the current-item steps, which also
    initialize a state that exists but holds no items; every other step
    initializes only a walk with no state at all. The two rules are the
    blueprint's, kept as they were.
    """
    if not walk.qml_state:
        return True
    return itemless_counts and not walk.qml_state.get("items")


def load_instrument(repository, walk) -> str:
    """Read the QML text the walk is fielded on (a repository read).

    Content comes from the document store through the campaign's pin
    (``load_fielded_qml_content``), not the questionnaire's head: a survey
    started before a publish keeps its instrument for its whole life, and only
    a campaign-less walk (a preview) reads head.
    """
    questionnaire = repository.get_questionnaire(walk.questionnaire_id)
    if not questionnaire:
        message = f"Cannot find questionnaire {walk.questionnaire_id} for survey {walk.id}"
        logger.error(message)
        raise ValueError(message)
    return load_fielded_qml_content(repository, walk, questionnaire)


def timing_source(walk) -> str:
    """Which kind of person answers this walk on a presenting surface (R9).

    ``walk.mode`` is derived from whether an interviewer is assigned, and that
    is the whole distinction the timing log needs: an interviewer-paced answer
    and a self-administered one have different duration distributions, so
    mixing them would make either look anomalous against the other.
    """
    return SOURCE_INTERVIEWER if walk.mode == "field_interview" else SOURCE_RESPONDENT


# ---------------------------------------------------------------------------
# Compute phase — no repository, no store
# ---------------------------------------------------------------------------


def processor_for(state, force_full: bool = False) -> FlowProcessor:
    """A ``FlowProcessor`` over existing state.

    Uses the lightweight cached-state initialization (no Z3) when the state
    already has a navigation path, and full initialization otherwise or when
    ``force_full`` asks for the engine's diagnostics.
    """
    if not isinstance(state, QMLState):
        state = QMLState(state)
    if not force_full and state.get_navigation_path():
        return FlowProcessor.from_cached_state(state)
    return FlowProcessor(state)


def materialize_walk_state(
    walk,
    instrument: str,
    external_input_resolver: ExternalInputResolver | None,
    translation: dict[str, str] | None = None,
) -> FlowProcessor:
    """Build ``walk.qml_state`` from the instrument text and return a processor.

    Parses the QML, overlays ``translation`` (a translation row's ``texts``)
    when given, runs the full (Z3) initialization, and applies the
    external-input prefill. The overlay changes text only, so the flow and
    the answer codes are the source's. No write and no audit event: a first
    initialization records ``started``, while a preview's reset (which also
    re-materializes) records ``reset``.
    """
    parsed = QMLLoader(logger=logger).load_from_string(instrument)
    logger.info("QML loaded and validated successfully.")
    if translation:
        parsed = apply_translation(parsed, translation)
    walk.qml_state = QMLState(parsed)
    processor = processor_for(walk.qml_state)
    # Pre-answer external items from the respondent record before the flow is
    # walked. Idempotent (the resolver's own sentinel guards re-entry) and
    # fail-safe (never raises).
    if external_input_resolver is not None:
        external_input_resolver(walk, processor)
    return processor


class LanguageChoiceOutcome(StrEnum):
    """What a language pick concluded."""

    CHOSEN = "chosen"  # The walk is materialized in the language and the pick stored
    LOCKED = "locked"  # The survey already holds a committed answer
    NOT_OFFERED = "not_offered"  # The campaign's pin does not offer it (``offered``)


@dataclass
class LanguageChoice:
    outcome: LanguageChoiceOutcome
    #: The languages the campaign's current pin offers, source first.
    offered: list[str] = field(default_factory=list)


def walk_pin(walk, campaign) -> str | None:
    """The pinned version a walk's translations come from, or None when it has none.

    None for no campaign, an unpinned campaign, or a campaign since rebound to
    another questionnaire (``update_campaign_questionnaire`` leaves existing
    surveys on the old one): the pin is a version of the campaign's
    questionnaire, so it holds no translation of this walk's.
    """
    version_id = getattr(campaign, "qml_version_id", None) if campaign else None
    if not version_id or str(campaign.questionnaire_id) != str(walk.questionnaire_id):
        return None
    return version_id


def offered_languages(repository, walk) -> list[str]:
    """The languages a fielded walk may be answered in, its source language first.

    Read from the campaign's current pin (``offered_locales``: the source and
    every complete translation). A walk with no pin of its own (``walk_pin``)
    offers only the source, since a translation belongs to a version.
    """
    questionnaire = repository.get_questionnaire(walk.questionnaire_id)
    campaign = repository.get_campaign(walk.campaign_id) if walk.campaign_id else None
    version_id = walk_pin(walk, campaign)
    if not version_id:
        return [questionnaire.language]
    return list(repository.offered_locales(walk.questionnaire_id, version_id))


@dataclass(frozen=True)
class LanguagePick:
    """What a pick re-materializes a walk from: read on the caller's thread, no Z3."""

    locale: str
    version_id: str
    #: The pinned version's QML content.
    instrument: str
    #: The translation row's texts, ``None`` for the source language.
    texts: dict | None
    #: The translation row's ``updated_at``, ``None`` for the source language.
    updated_at: Any


def read_language_pick(
    repository, walk, questionnaire, version_id: str, locale: str
) -> LanguagePick | None:
    """Read the pinned version and, for a translated ``locale``, its translation row.

    None when that row is gone or incomplete (deleted, or a text emptied, after
    the offered set was read): the locale is no longer offered, and a pick of a
    partial row would show mixed languages and then freeze it at the first answer.
    """
    texts = None
    updated_at = None
    if locale != questionnaire.language:
        row = repository.get_qml_translation(walk.questionnaire_id, version_id, locale)
        if row is None or row.untranslated:
            return None
        texts, updated_at = row.texts, row.updated_at
    instrument = load_qml_content(repository, questionnaire, version_id=version_id)
    return LanguagePick(locale, version_id, instrument, texts, updated_at)


def apply_language_pick(
    walk, pick: LanguagePick, external_input_resolver: ExternalInputResolver | None
) -> None:
    """Re-materialize ``walk`` from ``pick`` (QML parse plus Z3), record it and clear the position.

    Touches no repository, so a caller on an event loop runs it on a worker thread.
    """
    materialize_walk_state(walk, pick.instrument, external_input_resolver, translation=pick.texts)
    walk.qml_state[LANGUAGE_PICK_KEY] = language_pick_record(
        pick.locale, pick.version_id, pick.updated_at
    )
    update_position(walk, None)


def choose_language(
    repository,
    walk,
    locale: str,
    *,
    external_input_resolver: ExternalInputResolver | None,
) -> LanguageChoice:
    """Pick the language a fielded survey is answered in, before its first answer.

    Re-reads the campaign's pin, and when it offers ``locale``,
    re-materializes the walk from that version with the translation's text,
    records the row copied (``LANGUAGE_PICK_KEY``: locale, version, the row's
    ``updated_at``; ``None`` for the source language) and stores both through
    ``choose_survey_language``, which refuses under the survey row's lock once
    an answer is committed or when the pin moved since it was read here. The
    walk's position is cleared, so the next presentation starts from its first
    item. ``locale`` is checked against what the version offers, so a
    questionnaire's "other" source language is a valid pick; a code that is
    not a well-formed language tag raises ``UnsupportedQuestionnaireLanguage``.
    """
    locale = require_questionnaire_language(locale)
    if has_committed_answer(walk.qml_state):
        return LanguageChoice(LanguageChoiceOutcome.LOCKED)
    questionnaire = repository.get_questionnaire(walk.questionnaire_id)
    campaign = repository.get_campaign(walk.campaign_id)
    version_id = walk_pin(walk, campaign)
    if not version_id:
        offered = [questionnaire.language]
    else:
        # A version can be pinned before the verdict job carried its
        # translations forward; seeding is idempotent.
        seed_translations(repository, walk.questionnaire_id, version_id)
        offered = list(repository.offered_locales(walk.questionnaire_id, version_id))
    if locale not in offered:
        return LanguageChoice(LanguageChoiceOutcome.NOT_OFFERED, offered)

    pick = read_language_pick(repository, walk, questionnaire, version_id, locale)
    if pick is None:
        return LanguageChoice(LanguageChoiceOutcome.NOT_OFFERED, offered_languages(repository, walk))
    apply_language_pick(walk, pick, external_input_resolver)
    try:
        stored = repository.choose_survey_language(
            walk.id, locale, qml_state=walk.qml_state, version_id=version_id
        )
    except SurveyLanguageLockedError:
        return LanguageChoice(LanguageChoiceOutcome.LOCKED)
    except (SurveyLanguagePinMovedError, SurveyLanguageNotOfferedError):
        return LanguageChoice(LanguageChoiceOutcome.NOT_OFFERED, offered_languages(repository, walk))
    walk.language = locale
    walk.modified_at = stored.modified_at
    return LanguageChoice(LanguageChoiceOutcome.CHOSEN, offered)


def update_position(walk, item: dict[str, Any] | None) -> None:
    """Point the walk's position at ``item``, or clear it when the walk is done."""
    if item:
        walk.current_item_id = item.get("id")
        walk.current_block_id = item.get("blockId")
    else:
        walk.current_item_id = None
        walk.current_block_id = None


def close_open_timing_event(walk) -> None:
    """Close the item being left as uncommitted, if its event is still open.

    Called by the steps that move the answerer off an item without an answer
    being accepted. The time was genuinely spent, so the event stays in the
    log (and in visit totals); marking it uncommitted is what keeps it out of
    attempt counts (KTD4). Guarded on an event actually being open because the
    web UI normally saves what is on screen before stepping back, and that save
    already closed the event.
    """
    item_id = walk.current_item_id
    if not item_id:
        return
    iter_key = walk.qml_state.current_iter_key(item_id)
    if walk.qml_state.has_open_timing_event(item_id, iter_key):
        walk.qml_state.close_timing_event(item_id, iter_key, committed=False)


def _require_channel(channel: str) -> None:
    """Refuse a presenting step whose caller did not name a known channel."""
    if channel not in TIMING_CHANNELS:
        raise ValueError(
            f"Unknown timing channel {channel!r}; expected one of {sorted(TIMING_CHANNELS)}"
        )


def _open_presentation(walk, item_id: str | None, source: str, channel: str) -> None:
    """The presentation seam (R7): stamp the moment ``item_id`` is put on screen.

    Idempotent per open (item, iteration), so a re-render keeps the original
    moment (KTD2, AE6).
    """
    if item_id:
        walk.qml_state.open_timing_event(
            item_id, walk.qml_state.current_iter_key(item_id), source, channel=channel
        )


def _with_navigation_progress(walk, item: dict[str, Any]) -> dict[str, Any]:
    """Add the 1-based position of ``item`` within the navigation path."""
    navigation_path = walk.qml_state.get_navigation_path()
    item_id = item.get("id")
    if item_id and navigation_path:
        try:
            item["navigationPosition"] = navigation_path.index(item_id) + 1
        except ValueError:
            item["navigationPosition"] = None
        item["navigationTotal"] = len(navigation_path)
    return item


def _with_roster_banner(walk, item: dict[str, Any]) -> dict[str, Any]:
    """Surface a Roster item's iteration so the UI can label it ("2 of 4 · Lunch").

    Item titles render verbatim — no template substitution.
    """
    roster_block_id = item.get("_roster_block_id")
    if not roster_block_id:
        return item
    iter_key = walk.qml_state.get_current_roster_iter(roster_block_id)
    active_keys = walk.qml_state.get_roster_active_keys(roster_block_id) or []
    labels = item.get("_roster_labels") or {}
    if iter_key is not None:
        item["iterationKey"] = iter_key
        # Prefer the engine-resolved subject (dynamic subjectFrom, or the static
        # label — FlowProcessor._resolve_roster_subject). Label keys may arrive
        # as strings after a JSONB round trip; try both.
        item["iterationLabelText"] = (
            item.get("_roster_current_label")
            or labels.get(iter_key)
            or labels.get(str(iter_key))
            or ""
        )
        if iter_key in active_keys:
            item["iterationPosition"] = active_keys.index(iter_key) + 1
        item["iterationTotal"] = len(active_keys)
    return item


def presented_item(walk, item: dict[str, Any]) -> dict[str, Any]:
    """A stored item as every step returns one: a copy with position and Roster banner.

    For a driver that re-shows an item outside a step (the respondent lane
    after a postcondition rejection), so it carries what a step's item does.
    """
    return _with_roster_banner(walk, _with_navigation_progress(walk, dict(item)))


def _initialize_if_needed(
    walk,
    instrument: str | None,
    external_input_resolver: ExternalInputResolver | None,
    *,
    itemless_counts: bool,
) -> tuple[FlowProcessor, bool]:
    """The walk's processor, initializing the walk first when it has no state.

    Returns ``(processor, initialized)``. A caller that initialized owes a
    ``started`` audit event and a write, whatever else the step concludes.
    """
    if needs_instrument(walk, itemless_counts=itemless_counts):
        if instrument is None:
            raise ValueError(
                f"Walk {walk.id} has no state yet; load its instrument before computing"
            )
        return materialize_walk_state(walk, instrument, external_input_resolver), True
    return processor_for(walk.qml_state), False


def _current_item(
    walk,
    instrument: str | None,
    external_input_resolver: ExternalInputResolver | None,
    presentation: tuple[str, str] | None,
) -> FlowStep:
    """Shared body of reading and presenting the current item.

    ``presentation`` is ``(source, channel)`` when the item is being put on
    screen, None when the caller only reads. Presenting also completes a walk
    that has nothing left to ask; reading reports ``AT_END`` and leaves the
    completion to an explicit step.
    """
    was_completed = walk.status == "completed"
    processor, initialized = _initialize_if_needed(
        walk, instrument, external_input_resolver, itemless_counts=True
    )
    audit_actions = ["started"] if initialized else []

    item = processor.get_current_item(walk.qml_state, backward=False)

    if not item:
        if not was_completed:
            if presentation is None:
                return FlowStep(
                    FlowOutcome.AT_END,
                    was_completed=was_completed,
                    persist=initialized,
                    audit_actions=audit_actions,
                )
            close_walk(walk)
            return FlowStep(
                FlowOutcome.JUST_COMPLETED,
                was_completed=was_completed,
                persist=True,
                audit_actions=[*audit_actions, "completed"],
            )
        # Already completed: hand back the last item answered, if any.
        last_item = None
        history = walk.qml_state.get_history()
        if history:
            stored = walk.qml_state.get_item(history[-1])
            last_item = dict(stored) if stored else None
        return FlowStep(
            FlowOutcome.COMPLETED,
            item=last_item,
            was_completed=was_completed,
            persist=initialized,
            audit_actions=audit_actions,
        )

    update_position(walk, item)
    if presentation is not None:
        source, channel = presentation
        # Called unconditionally on every presentation: the web survey re-runs
        # it on every render, refresh and resume, and the event's idempotence
        # is what keeps a refresh from resetting the clock. A guard here would
        # be a second place for that rule to live.
        _open_presentation(walk, item.get("id"), source, channel)

    shown = _with_roster_banner(walk, _with_navigation_progress(walk, dict(item)))
    return FlowStep(
        FlowOutcome.ITEM,
        item=shown,
        was_completed=was_completed,
        persist=presentation is not None or initialized,
        audit_actions=audit_actions,
    )


def compute_present_current_item(
    walk,
    instrument: str | None,
    *,
    source: str,
    channel: str,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Put the current item on screen: position it and open its timing event.

    A walk with nothing left to ask is completed here (``JUST_COMPLETED``),
    which is the web survey's end-of-walk behaviour.
    """
    _require_channel(channel)
    return _current_item(walk, instrument, external_input_resolver, (source, channel))


def compute_current_state(
    walk,
    instrument: str | None,
    *,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Where the walk stands, without presenting anything.

    Opens no timing event and completes nothing. It still initializes a walk
    with no state (and asks for that to be written, with ``started``), because
    the initialization is the expensive Z3 step and every later step needs it.
    """
    return _current_item(walk, instrument, external_input_resolver, None)


def compute_evaluate_item(
    walk,
    instrument: str | None,
    *,
    item_id: str,
    outcome: Any,
    skip_postcondition: bool,
    source: str,
    channel: str,
    pick_token: str | None,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Record an answer for ``item_id`` without moving the walk's position.

    ``pick_token`` is the language pick the answerer was shown the item under
    (module docstring); another than the walk's is ``PICK_CHANGED``, with
    nothing computed or written.

    ``skip_postcondition`` is the backward-navigation convenience save: the
    answer is kept so it is restored when the answerer returns, validation is
    deferred to the forward pass, and the timing event closes uncommitted
    (KTD4) — all of which ``process_item`` decides from the flag. Answering an
    item that later entries were built on rewinds the walk to it (B256).
    """
    _require_channel(channel)
    if pick_token != language_pick_token(walk.qml_state):
        return FlowStep(FlowOutcome.PICK_CHANGED)
    processor, initialized = _initialize_if_needed(
        walk, instrument, external_input_resolver, itemless_counts=False
    )
    audit_actions = ["started"] if initialized else []

    result = processor.process_item(
        walk.qml_state,
        item_id,
        outcome,
        source=source,
        channel=channel,
        skip_postcondition=skip_postcondition,
    )
    if not result.get("success", False):
        return FlowStep(
            FlowOutcome.REJECTED,
            message=result.get("message", "Failed to process item"),
            persist=initialized,
            audit_actions=audit_actions,
            processor=processor,
        )
    return FlowStep(
        FlowOutcome.ACCEPTED,
        output=result.get("output") or None,
        persist=True,
        audit_actions=audit_actions,
        processor=processor,
    )


def has_next_item(walk, processor: FlowProcessor) -> bool:
    """Whether a reachable unvisited item remains after an accepted answer.

    Read-only towards navigation (no history change, no visited flag), but a
    gate it evaluates may record a degradation warning. It runs after the
    answer's write, as it always has in the blueprint, so this step never
    writes such a warning; the step that later presents the gated item
    evaluates the same gate and records it then. ``evaluate_item`` keeps that
    order, and a caller running the phases itself calls this after
    ``persist_step``.
    """
    all_items = walk.qml_state.get_all_items()
    for nav_item_id in walk.qml_state.get_navigation_path():
        nav_item = walk.qml_state.get_item(nav_item_id)
        if not nav_item or nav_item.get("visited"):
            continue
        if processor._check_preconditions(nav_item, all_items):
            return True
    return False


def compute_previous_item(
    walk,
    instrument: str | None,
    *,
    source: str,
    channel: str,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Step back to the previous item in history and present it."""
    _require_channel(channel)
    processor, initialized = _initialize_if_needed(
        walk, instrument, external_input_resolver, itemless_counts=False
    )
    audit_actions = ["started"] if initialized else []

    # Close the item being left before the walk moves — backward navigation
    # rewrites the Roster pass state, so the iteration key this event belongs
    # to is only resolvable from here.
    close_open_timing_event(walk)

    item = processor.get_current_item(walk.qml_state, backward=True)
    if not item:
        return FlowStep(FlowOutcome.NO_PREVIOUS, persist=initialized, audit_actions=audit_actions)

    update_position(walk, item)
    # The item landed on is presented anew. The web client renders this
    # response directly and does not re-fetch the current item, so without
    # this a re-answer would be timed only from process_item's own open and
    # close and read ~0s.
    _open_presentation(walk, item.get("id"), source, channel)

    return FlowStep(
        FlowOutcome.ITEM,
        item=_with_roster_banner(walk, _with_navigation_progress(walk, dict(item))),
        persist=True,
        audit_actions=audit_actions,
    )


def compute_reenter_last_item(
    walk,
    instrument: str | None,
    *,
    source: str,
    channel: str,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Present the item on top of history again, in its Roster iteration.

    For a driver whose end screen sits past the last item (the respondent
    lane): Back from it re-presents that item without popping it, so every
    answer stays where it is. ``NO_PREVIOUS`` when nothing was walked yet.
    """
    _require_channel(channel)
    processor, initialized = _initialize_if_needed(
        walk, instrument, external_input_resolver, itemless_counts=False
    )
    audit_actions = ["started"] if initialized else []

    close_open_timing_event(walk)
    item = processor.reenter_top_of_history(walk.qml_state)
    if not item:
        return FlowStep(FlowOutcome.NO_PREVIOUS, persist=initialized, audit_actions=audit_actions)

    update_position(walk, item)
    _open_presentation(walk, item.get("id"), source, channel)
    return FlowStep(
        FlowOutcome.ITEM,
        item=_with_roster_banner(walk, _with_navigation_progress(walk, dict(item))),
        persist=True,
        audit_actions=audit_actions,
    )


def compute_navigate_to_item(
    walk,
    instrument: str | None,
    *,
    target_item_id: str,
    source: str,
    channel: str,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Jump to ``target_item_id`` when the rules allow it, and present it.

    Allowed when the target is in history (a jump back), or when every item
    before it in the navigation path is visited, gated out or left out by a
    full capped-Group draw, and the target's own gate holds and no full draw
    leaves it out (a jump forward over a path already settled, onto an item
    the walk would present, #1809), and a Roster target is inside its pass
    (#1846). A forward jump puts the target in history, under its live
    Roster iteration, a capped-Group target with its slot of the draw
    (#1845), and ``process_item`` judges no gate of an item already there
    (#1768). A jump
    back lands on the target's first history entry, in that entry's Roster
    iteration (#1808).
    """
    _require_channel(channel)
    processor, initialized = _initialize_if_needed(
        walk, instrument, external_input_resolver, itemless_counts=False
    )
    audit_actions = ["started"] if initialized else []

    target_item = walk.qml_state.get_item(target_item_id)
    if not target_item:
        return FlowStep(
            FlowOutcome.ITEM_NOT_FOUND, persist=initialized, audit_actions=audit_actions
        )

    navigation_history = walk.qml_state.get_history()
    is_in_history = target_item_id in navigation_history

    has_valid_path = False
    if not is_in_history:
        navigation_path = walk.qml_state.get_navigation_path()
        all_items = walk.qml_state.get_all_items()
        if target_item_id in navigation_path:
            target_index = navigation_path.index(target_item_id)
            has_valid_path = True
            for i in range(target_index):
                preceding_item = walk.qml_state.get_item(navigation_path[i])
                if preceding_item:
                    is_visited = preceding_item.get("visited", False)
                    # Skipped by its gate, or a capped-Group member the full
                    # draw left out (#1809): the walk passes over both.
                    is_skipped = processor.is_undrawn_past_cap(
                        preceding_item
                    ) or not processor._check_preconditions(preceding_item, all_items)
                    if not is_visited and not is_skipped:
                        has_valid_path = False
                        break
            if has_valid_path and (
                processor.is_undrawn_past_cap(target_item)
                or not processor._check_preconditions(target_item, all_items)
            ):
                has_valid_path = False
            # The walk presents a Roster item only inside its pass, so a
            # forward jump onto one with no live iteration would put it on
            # the path under none (#1846).
            if (
                has_valid_path
                and target_item.get("_roster_block_id")
                and walk.qml_state.current_iter_key(target_item_id) is None
            ):
                has_valid_path = False

    if not is_in_history and not has_valid_path:
        return FlowStep(
            FlowOutcome.NAVIGATION_REFUSED,
            message=(
                "Item is not in history and the walk would not present it now "
                "(an earlier item is unanswered, its own condition is not met, "
                "its group already asked as many questions as it asks, or it "
                "repeats per iteration and none of its iterations is in progress)"
            ),
            persist=initialized,
            audit_actions=audit_actions,
        )

    # Close the item being left before the jump rewrites history.
    close_open_timing_event(walk)

    if is_in_history:
        # Truncate history to end at the target's FIRST entry, which for a
        # Roster item undoes every later iteration. The state chain goes with
        # it: the target's successors' variables and codeBlock-written
        # outcomes (Roster cells included) are rolled back (#1021). The
        # target is re-entered the way Back does: a Roster item gets its
        # pass, that entry's iteration, its outcomes and its visited flags
        # back (#1808), so a re-answer stays one `(item, iteration)` entry.
        processor.rewind_to_first_entry(walk.qml_state, target_item_id)
    else:
        # A forward jump: the target joins the path in its live Roster
        # iteration (None outside a Roster), and a capped-Group target takes
        # its slot of the draw, as the walk's own reach does (#1845).
        walk.qml_state.add_to_history(
            target_item_id, iter_key=walk.qml_state.current_iter_key(target_item_id)
        )
        processor.draw_group_member(target_item)

    update_position(walk, target_item)
    # The jump re-presents the target, and the web client renders this
    # response without re-fetching the current item.
    _open_presentation(walk, target_item.get("id"), source, channel)

    return FlowStep(
        FlowOutcome.ITEM,
        item=_with_roster_banner(walk, _with_navigation_progress(walk, dict(target_item))),
        persist=True,
        audit_actions=audit_actions,
    )


def close_walk(walk) -> None:
    """End the walk: the one sequence every driver completes a walk with (#1294).

    The order is load-bearing. An item still on screen is being left
    unanswered, so its event is closed while the position still says which
    item that was; clearing the position first would strand the event open,
    and a later resume would then measure the whole absence as answer time.
    Pure state manipulation, so a driver may run it off its event loop.

    It also records ``WALK_ONCE_COMPLETED`` in the walk's state, which a Resume
    does not clear: a fielded survey that was ever completed is never reset
    (#1293), even after it was reopened.
    """
    walk.status = "completed"
    close_open_timing_event(walk)
    update_position(walk, None)
    if walk.qml_state is not None:
        walk.qml_state[WALK_ONCE_COMPLETED] = True


def walk_was_completed(walk) -> bool:
    """Whether the walk is completed now or was before a Resume reopened it."""
    return walk.status == "completed" or bool((walk.qml_state or {}).get(WALK_ONCE_COMPLETED))


def compute_finish(walk, *, at_end: bool) -> FlowStep:
    """Complete the walk, keeping every answer given so far.

    ``at_end`` says the driver found every reachable item answered: that is a
    completion (``completed``), as the respondent lane's Finish on its end
    screen is. Otherwise the walk ends early (``finished_early``), as the web's
    Finish button may at any item.
    """
    if walk.status == "completed":
        return FlowStep(FlowOutcome.ALREADY_COMPLETED, was_completed=True)

    close_walk(walk)
    if at_end:
        return FlowStep(FlowOutcome.JUST_COMPLETED, persist=True, audit_actions=["completed"])
    return FlowStep(FlowOutcome.FINISHED, persist=True, audit_actions=["finished_early"])


def compute_resume(
    walk,
    instrument: str | None,
    *,
    source: str,
    channel: str,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Bring a completed walk back to in-progress and re-present its current item."""
    _require_channel(channel)
    if walk.status != "completed":
        return FlowStep(FlowOutcome.NOT_COMPLETED)

    walk.status = "in_progress"
    processor, initialized = _initialize_if_needed(
        walk, instrument, external_input_resolver, itemless_counts=False
    )
    audit_actions = ["started"] if initialized else []

    # Any event still open was left open by the departure. Close it
    # uncommitted and start a fresh one for the item now re-presented: two
    # events, one of which spans the absence, instead of a single event whose
    # duration silently includes it.
    close_open_timing_event(walk)

    item = processor.get_current_item(walk.qml_state, backward=False)
    update_position(walk, item)
    if item:
        _open_presentation(walk, item.get("id"), source, channel)

    return FlowStep(
        FlowOutcome.RESUMED,
        item=dict(item) if item else None,
        was_completed=True,
        persist=True,
        audit_actions=[*audit_actions, "resumed"],
    )


# ---------------------------------------------------------------------------
# Persist phase
# ---------------------------------------------------------------------------


def emit_audit(audit_callback: AuditCallback | None, walk, action: str) -> None:
    """Record one survey event, never failing the step that caused it."""
    if audit_callback is None:
        return
    try:
        audit_callback(
            "survey",
            walk.id,
            action,
            {"questionnaire_id": walk.questionnaire_id, "campaign_id": walk.campaign_id},
        )
    except Exception as error:
        # The class, never the text: the step that failed may carry an answer (#2193).
        logger.warning("Failed to log audit event (survey.%s): %s", action, type(error).__name__)


def persist_step(
    store: FlowStore, walk, step: FlowStep, audit_callback: AuditCallback | None
) -> None:
    """Write what the compute phase changed, then record its audit events.

    Write first: a refused write (a sealed organization) raises before any
    event claims the step happened.
    """
    if step.persist:
        store.save(walk)
    for action in step.audit_actions:
        emit_audit(audit_callback, walk, action)


# ---------------------------------------------------------------------------
# Composed steps — load, compute, persist, for a synchronous caller
# ---------------------------------------------------------------------------


def _instrument_if_needed(store: FlowStore, walk, *, itemless_counts: bool) -> str | None:
    if needs_instrument(walk, itemless_counts=itemless_counts):
        return load_instrument(store.repository, walk)
    return None


def present_current_item(
    store: FlowStore,
    walk,
    *,
    source: str,
    channel: str,
    audit_callback: AuditCallback | None,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Present the walk's current item (opens its timing event)."""
    _require_channel(channel)
    instrument = _instrument_if_needed(store, walk, itemless_counts=True)
    step = compute_present_current_item(
        walk,
        instrument,
        source=source,
        channel=channel,
        external_input_resolver=external_input_resolver,
    )
    persist_step(store, walk, step, audit_callback)
    return step


def read_current_state(
    store: FlowStore,
    walk,
    *,
    audit_callback: AuditCallback | None,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Read where the walk stands without presenting anything (no timing event)."""
    instrument = _instrument_if_needed(store, walk, itemless_counts=True)
    step = compute_current_state(walk, instrument, external_input_resolver=external_input_resolver)
    persist_step(store, walk, step, audit_callback)
    return step


def evaluate_item(
    store: FlowStore,
    walk,
    *,
    item_id: str,
    outcome: Any,
    skip_postcondition: bool,
    source: str,
    channel: str,
    pick_token: str | None,
    audit_callback: AuditCallback | None,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Record an answer; on acceptance without output, report ``has_next``."""
    _require_channel(channel)
    instrument = _instrument_if_needed(store, walk, itemless_counts=False)
    step = compute_evaluate_item(
        walk,
        instrument,
        item_id=item_id,
        outcome=outcome,
        skip_postcondition=skip_postcondition,
        source=source,
        channel=channel,
        pick_token=pick_token,
        external_input_resolver=external_input_resolver,
    )
    persist_step(store, walk, step, audit_callback)
    if step.outcome is FlowOutcome.ACCEPTED and not step.output:
        step.has_next = has_next_item(walk, step.processor)
    return step


def previous_item(
    store: FlowStore,
    walk,
    *,
    source: str,
    channel: str,
    audit_callback: AuditCallback | None,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Step back one item and present it."""
    _require_channel(channel)
    instrument = _instrument_if_needed(store, walk, itemless_counts=False)
    step = compute_previous_item(
        walk,
        instrument,
        source=source,
        channel=channel,
        external_input_resolver=external_input_resolver,
    )
    persist_step(store, walk, step, audit_callback)
    return step


def navigate_to_item(
    store: FlowStore,
    walk,
    *,
    target_item_id: str,
    source: str,
    channel: str,
    audit_callback: AuditCallback | None,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Jump to an item the rules allow and present it."""
    _require_channel(channel)
    instrument = _instrument_if_needed(store, walk, itemless_counts=False)
    step = compute_navigate_to_item(
        walk,
        instrument,
        target_item_id=target_item_id,
        source=source,
        channel=channel,
        external_input_resolver=external_input_resolver,
    )
    persist_step(store, walk, step, audit_callback)
    return step


def finish(store: FlowStore, walk, *, audit_callback: AuditCallback | None) -> FlowStep:
    """Complete the walk early (emits ``finished_early``): the web's Finish button."""
    step = compute_finish(walk, at_end=False)
    persist_step(store, walk, step, audit_callback)
    return step


def resume(
    store: FlowStore,
    walk,
    *,
    source: str,
    channel: str,
    audit_callback: AuditCallback | None,
    external_input_resolver: ExternalInputResolver | None,
) -> FlowStep:
    """Reopen a completed walk and re-present its current item (emits ``resumed``)."""
    _require_channel(channel)
    # Resume only initializes a walk it is actually reopening; a walk that is
    # not completed is refused before anything is read.
    instrument = (
        _instrument_if_needed(store, walk, itemless_counts=False)
        if walk.status == "completed"
        else None
    )
    step = compute_resume(
        walk,
        instrument,
        source=source,
        channel=channel,
        external_input_resolver=external_input_resolver,
    )
    persist_step(store, walk, step, audit_callback)
    return step
