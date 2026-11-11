"""Flow API blueprint for QML survey navigation and evaluation.

The HTTP face of the flow engine. The step logic (current item, evaluate,
previous, navigate, finish, resume) lives in ``flow_service`` so the respondent
lane walks surveys on the same engine; this module owns only what is HTTP —
the credential check, request parsing, the request-scoped store on ``g``, and
response shaping. Every presenting step passes channel ``web``.

The sentences the respondent's page shows (``message``, and the ``error`` /
``reason`` of a refusal it puts in its modal) are rendered in the page's chrome
locale, as every respondent-facing render is (``respondent_locale``): the
walk's content language (a survey's, a preview run's questionnaire's) when it
is a supported locale; for an "other" content language the respondent's
preferred language, else the browser's (never on an interviewer-assisted
survey, whose browser is the interviewer's), else English; and the browser's
language only when no walk was read. The locale is resolved only on those paths, so a step
that answers an item pays no extra read. Error codes and developer-facing
diagnostics (a missing ``survey_id``, an unknown id) stay English.

Language picker. While a fielded survey holds no committed answer and its
campaign's pin offers more than one language, the current item carries
``offered_languages`` (``[{code, name}]``, the name the language's own, source
first, named by ``questionnaire_native_name`` so an "other" source language
is named too), ``preselected`` and ``language`` (the pick so far, or None).
``POST /choose-language`` picks one (``flow_service.choose_language``). A pick
the walk can no longer take answers ``409`` with an error code the page acts on
and no sentence: ``language_locked`` (an answer is already stored: reload into
the locked language), ``language_not_offered`` (the pin moved: a fresh picker,
whose fields the body carries), and on ``evaluate-item``
``translation_changed`` (the picked text changed after it was shown, or another
tab picked a language after this page rendered: the answer was refused, and the
body carries a fresh picker). Every ``current-item`` answer carries ``pick_token``
(``language_pick_token``, null when no pick re-materialized the walk; the page
keeps it across ``previous-item`` and ``navigate-to-item``, whose answers do not
carry it, because no pick can land once an answer locked the language), and
``evaluate-item`` takes it back as ``pick_token``: an answer naming another pick
than the stored one is refused before anything is written, as
``translation_changed`` while the language is still open and ``language_locked``
once another tab's answer locked it (#2127). Preselection follows the
respondent's preferred language, then the browser's, then the source; an
interviewer-assisted survey ignores the browser, which is the interviewer's.
"""

import logging
import os
import traceback
import uuid
from collections.abc import Callable

from askalot_common.campaign_admission import (
    FIELDING_STATUSES,
    campaign_takes_answers,
    has_committed_answer,
    not_taking_answers,
)
from askalot_common.i18n import (
    UnsupportedQuestionnaireLanguage,
    gettext,
    respondent_locale,
)
from askalot_common.i18n.language_names import questionnaire_native_name
from askalot_common.i18n.locale import preselect_language
from askalot_common.repository.exceptions import (
    OrganizationSealedError,
    SurveyStateConflictError,
)
from askalot_common.repository.mixins.survey import (
    SurveyTranslationChangedError,
    language_pick_token,
)
from flask import Blueprint, g, jsonify, request

from askalot_qml.api import flow_service
from askalot_qml.api.flow_service import (
    AuditCallback,
    ExternalInputResolver,
    FlowOutcome,
    FlowStore,
)
from askalot_qml.models.qml_state import CHANNEL_WEB

logger = logging.getLogger(__name__)

#: The organization + survey one anonymous session may drive, as the service
#: resolves it. ``askalot_qml`` stays repository-free and cookie-format-free:
#: it asks the service who this request is, and the service answers from
#: whatever credential it minted (a survey magic link, a preview share link, or
#: a campaign open link). Returning ``None`` means "no anonymous session here",
#: which is not the same as an invalid one — an unauthenticated request simply
#: has nothing to resolve.
FlowSession = tuple[str, str, str]  # (organization_id, organization_slug, survey_id)
FlowSessionResolver = Callable[[], FlowSession | None]


class FlowSessionError(Exception):
    """No credential authorized this flow request, or the wrong one did.

    Raised rather than returned because it fires inside a helper every endpoint
    calls first. Carries an HTTP status so the two cases stay distinguishable:
    401 for "nothing authorized you", 403 for "your session is for a different
    survey" — the second is a real credential being used out of scope, and
    collapsing them would hide that.
    """

    def __init__(self, message: str, status: int = 401):
        super().__init__(message)
        self.status = status


# A fielded walk in a sealed organization is CLOSED, and says so.
#
# Every survey write in this blueprint funnels through ``FlowStore.save``, and
# ``save_survey_walk`` refuses one in a sealed organization. Without this, that
# refusal met the handlers' blanket ``except Exception`` and left the client a
# 500 carrying the raw database message -- including on ``current-item`` and
# ``previous-item``, which LOOK like reads but write a timing event before
# rendering.
#
# Closed rather than silently not-recording, because the write on those read
# paths is paradata: measurement data the seal exists to refuse. Skipping it
# would render a page that quietly records nothing, and the respondent's next
# answer would be refused anyway -- a false promise is worse than a closed door.
#
# A PREVIEW walk is unaffected: it writes ``preview_runs``, which the seal
# admits, so reviewing an instrument in a sealed organization still works.


def requested_survey_ids() -> set[str]:
    """EVERY survey this request names, from both places an endpoint reads.

    Collected as a set rather than resolved to one value, because the two
    sources do not agree about which one wins: the GET routes read
    `request.args` while `evaluate-item`, `navigate-to-item`, `reset`,
    `finish` and `resume` read `data.get("survey_id")` from the body alone.
    A check that preferred one source would admit a request carrying a
    MATCHING value there and a MISMATCHING one in the other, which the
    endpoint would then serve against the mismatching survey.

    The binding check has to happen BEFORE the endpoint reaches its own
    read; a check after it would run with organization context already set
    from someone else's session. Nothing here decides which id the endpoint
    will honour — it refuses unless every id the request carries is the one
    the session names, so the precedence question cannot arise.
    """
    ids: set[str] = set()
    from_args = request.args.get("survey_id")
    if from_args:
        ids.add(from_args)
    if request.is_json:
        body = request.get_json(silent=True)
        # A JSON body that is not an object (a bare list) names no survey.
        from_body = body.get("survey_id") if isinstance(body, dict) else None
        if from_body:
            ids.add(str(from_body))
    return ids


def _loggable_id(value: str) -> str:
    """``value`` when it is a UUID, else ``<invalid>``: an id field is caller text too."""
    try:
        return str(uuid.UUID(value))
    except (ValueError, TypeError, AttributeError):
        return "<invalid>"


def _log_failure(action: str, error: Exception) -> None:
    """Log a flow endpoint's unexpected failure by its class, where it was raised, and the surveys it named.

    Never the exception's text, nor a traceback (``logger.exception`` prints
    the text too): an answer that failed validation or coercion, or a
    codeBlock's error, can quote what the respondent supplied, and Loki cannot
    be scrubbed (#2193; the rule warnings follow, #2190). The raising frame's
    file and line are code, never data, and are what makes the line
    diagnosable without the text. The survey ids are the request's own
    (``requested_survey_ids``), and only a value that is a UUID is written: the
    caller sends that field too, and any other text in it (a value, a forged
    line) reads as ``<invalid>``.
    """
    where = "-"
    for frame, lineno in traceback.walk_tb(error.__traceback__):
        where = f"{os.path.basename(frame.f_code.co_filename)}:{lineno}"
    surveys = sorted(_loggable_id(value) for value in requested_survey_ids())
    logger.error(
        "flow.%s_failed survey_ids=%s error=%s at=%s",
        action,
        ",".join(surveys) or "-",
        type(error).__name__,
        where,
    )


def session_binds(session: FlowSession | None, survey_ids: set[str]) -> bool:
    """Whether *session* is bound to every survey in *survey_ids*, and there is one.

    The one rule for "this session authorizes this request". The blueprint uses
    it to let a bound session outrank a JWT, and a host's seal-guard resolver
    uses it to judge the same request in the same organization, so the two
    cannot disagree.
    """
    return (
        session is not None
        and bool(survey_ids)
        and all(str(session[2]) == rid for rid in survey_ids)
    )


def _sealed_walk_response(locale: str):
    """The legible refusal a sealed organization's fielded walk returns.

    Carries the same ``org_sealed`` code the request guard uses, so a client
    that already distinguishes a seal refusal from an RBAC 403 keeps working.
    The sentence is also ``message``, the field SirWay's survey page shows in
    its modal (it reads ``message`` before ``error``, never ``detail``).
    """
    detail = gettext(
        locale,
        "This survey is closed. Its organization has been sealed, so it is no "
        "longer accepting responses.",
    )
    return jsonify({"error": "org_sealed", "detail": detail, "message": detail}), 403


def _conflict_walk_response(locale: str):
    """409 when this step lost a race with another step on the same survey.

    ``FlowStore.save`` refuses a write over a row that changed since the walk
    was read (another tab, the respondent's AI channel), so nothing was
    recorded. The client re-fetches the current item and the respondent
    carries on from what the survey actually holds.
    """
    return (
        jsonify(
            {
                "error": "survey_state_conflict",
                # ``message`` is what SirWay's survey page shows in its modal.
                "message": gettext(
                    locale, "This survey changed in another window. Reload to continue."
                ),
            }
        ),
        409,
    )


def _not_fielding_walk_response(locale: str):
    """403 when the survey's campaign is not taking answers (#1285).

    ``message`` is what SirWay's survey page shows; nothing was recorded. The
    sentence is ``campaign_admission.not_taking_answers``, shared with SirWay's
    entry pages, so it is rendered there rather than re-marked here.
    """
    message = not_taking_answers(locale)
    return jsonify({"error": "campaign_not_fielding", "message": message}), 403


def create_flow_blueprint(
    repository,
    url_prefix: str = "/api/flow",
    audit_callback: AuditCallback | None = None,
    external_input_resolver: ExternalInputResolver | None = None,
    session_resolver: FlowSessionResolver | None = None,
) -> Blueprint:
    """
    Create QML flow API blueprint.

    Args:
        repository: Repository instance for survey persistence — also the
            source of QML content (the document store), so the blueprint needs
            no filesystem location
        url_prefix: URL prefix for the blueprint
        audit_callback: Optional callback for audit logging with signature:
            audit_callback(entity_type, entity_id, action, context_extra)
        external_input_resolver: Optional service-supplied callback
            ``resolver(survey, processor) -> None`` invoked once at survey init
            (QML External Inputs plan, U5). Keeps askalot_qml repository-free:
            the service resolves external-input sources from the survey's
            campaign + respondent and applies them via
            ``processor.apply_external_inputs``. Absent → no prefill (external
            items are asked in the normal flow).
        session_resolver: Optional service-supplied callback ``() -> FlowSession
            | None`` naming the organization and the ONE survey this request's
            anonymous credential may drive (R21/R37). Absent → only a JWT can
            authorize a flow request; there is no parameter fallback, and a
            service registering this blueprint without a resolver serves
            authenticated callers only.

    Returns:
        Flask blueprint with flow endpoints
    """
    blueprint = Blueprint("qml_flow", __name__, url_prefix=url_prefix)

    def _store() -> FlowStore:
        """This request's store (``flow_service.FlowStore``), created once per request.

        Request-scoped rather than blueprint-scoped: one process serves preview
        and fielded walks concurrently, so a store remembered on the blueprint
        would serve one request's state under another's kind. The kind is
        resolved from the id the request's credential named, never from a
        caller-supplied parameter (see ``_set_org_context_from_request``).
        """
        if not hasattr(g, "_askalot_flow_store"):
            g._askalot_flow_store = FlowStore(repository)
        return g._askalot_flow_store

    def _set_org_context_from_request():
        """
        Set organization context for flow API requests.

        Flow API endpoints are excluded from JWT middleware, so this is the
        whole of their authorization. Exactly two credentials can supply it:

        1. A JWT — an authenticated researcher or interviewer.
        2. The service's anonymous session, via ``session_resolver`` — whatever
           the entry route minted after validating a magic link, a preview share
           link or a campaign open link.

        **There is deliberately no third source.** This used to fall back to an
        ``organization_id`` request parameter, which meant any unauthenticated
        caller could name the tenant it wanted to act in and be believed; a
        survey id was then the only remaining secret. Both new public surfaces
        ride these endpoints, so shipping them over a parameter-trusting API
        would have multiplied that exposure rather than inherited it (KTD4/R37).

        The session names ONE survey. A request for a different survey in the
        same organization is refused rather than served, so a leaked survey id
        is not enough on its own.

        When both are present, a session bound to every survey the request
        names is used and the JWT is not: the survey was opened through a link
        into the link's organization, which a signed-in visitor's active
        organization need not be (#1605).

        Raises:
            FlowSessionError: 401 when nothing authorized the request, 403 when
                a valid session was presented for a survey it does not name.
        """
        from askalot_common.repository import get_organization_context, set_organization_context

        # A session bound to the survey this request names wins over everything
        # else, a JWT included (#1605). The session was minted by a door after it
        # validated a link, and it authorizes exactly that one survey in the
        # link's organization; a signed-in visitor's JWT names THEIR active
        # organization, which need not be the link's, and reading the survey
        # there finds nothing. Only a session that binds every id the request
        # names qualifies, so a stale cookie for another survey changes nothing.
        session = session_resolver() if session_resolver else None
        requested = requested_survey_ids()
        if session_binds(session, requested):
            set_organization_context(session[0], session[1])
            logger.debug("Set org context from the flow session bound to this survey")
            return

        # Skip if org context already set (returns OrganizationContext object or None)
        if get_organization_context():
            return

        # Try to get org context from JWT token first (authenticated users).
        # The whole session check, not the signature alone: a logged-out or
        # deleted account's token must not choose the organization (#2184).
        try:
            from askalot_common.auth import extract_jwt_token, get_auth_config
            from askalot_common.auth.middleware import verified_session
            from askalot_common.auth.user_service import get_user_service

            token = extract_jwt_token()
            if token:
                payload, _user, _refusal = verified_session(token, get_auth_config(), get_user_service())
                if payload:
                    organization_id = payload.get("organization_id")
                    organization_slug = payload.get("organization_slug")
                    if organization_id and organization_slug:
                        set_organization_context(organization_id, organization_slug)
                        logger.debug(f"Set org context from JWT: {organization_slug}")
                        return
        except Exception as e:
            logger.debug("Could not get org from JWT: %s", type(e).__name__)

        if session is None:
            raise FlowSessionError(
                "This request carries no credential the flow API accepts. "
                "Open the survey through its link, or sign in."
            )

        organization_id, organization_slug, session_survey_id = session
        if any(str(session_survey_id) != rid for rid in requested):
            raise FlowSessionError("This session is not valid for that survey.", status=403)

        set_organization_context(organization_id, organization_slug)
        logger.debug("Set org context from anonymous flow session: %s", organization_slug)

    @blueprint.before_request
    def _authorize_flow_request():
        """Resolve organization context before any endpoint body runs.

        A ``before_request`` rather than a call inside each endpoint, and that
        placement is load-bearing twice over. Every endpoint wraps its body in a
        broad ``except Exception`` that renders a 500, so a refusal raised
        inside one would reach the caller as a server error rather than as a
        401. And a per-endpoint call is one a new endpoint can forget — a flow
        endpoint that forgot it would run under whatever organization context
        happened to be set, which is exactly the failure this closes.
        """
        try:
            _set_org_context_from_request()
        except FlowSessionError as error:
            return jsonify({"error": str(error)}), error.status
        return None

    def _load_walk(survey_id):
        """Read the walk this request names, remembering it for ``_locale``."""
        walk = _store().load(survey_id)
        g._askalot_flow_walk = walk
        return walk

    def _locale() -> str:
        """The chrome locale of this request's respondent-facing sentences.

        ``respondent_locale``'s rule over the walk read for this request: its
        content language when supported; for an "other" one the respondent's
        preferred language (read only then, the one case it decides), else the
        browser's, except on an interviewer-assisted survey, where the browser
        is the interviewer's and says nothing about the respondent, else
        English. Before a walk is read (or when the id named none) the
        browser's language decides. Called only where a sentence is about to be
        rendered, never on the answering path.
        """
        return respondent_locale(
            repository,
            survey=getattr(g, "_askalot_flow_walk", None),
            accept_language=request.headers.get("Accept-Language"),
        )

    def _fielded_campaign(survey):
        """The fielded survey's campaign, read fresh so a pause lands on the next
        step; ``None`` for a survey without one."""
        return repository.get_campaign(survey.campaign_id) if survey.campaign_id else None

    def _refuses_answers(survey) -> bool:
        """Whether this fielded survey's campaign takes no answer from this step.

        ``campaign_admission.campaign_takes_answers`` is the rule every lane
        shares: a paused or closed campaign takes nothing, except from a survey
        a person has already answered in, which may finish. A preview has no
        campaign and is never refused.
        """
        if _store().kind == "preview":
            return False
        return not campaign_takes_answers(_fielded_campaign(survey), survey)

    def _language_picker(survey, offered: list[str]) -> dict:
        """The picker fields for ``survey`` over ``offered`` (source first)."""
        if survey.language in offered:
            preselected = survey.language
        else:
            respondent = (
                repository.get_respondent(survey.respondent_id) if survey.respondent_id else None
            )
            preselected = preselect_language(
                offered,
                getattr(respondent, "preferred_language", None),
                # An interviewer's browser says nothing about the respondent.
                None
                if survey.mode == "field_interview"
                else request.headers.get("Accept-Language"),
                offered[0],
            )
        return {
            "offered_languages": [
                {"code": code, "name": questionnaire_native_name(code)} for code in offered
            ],
            "preselected": preselected,
            "language": survey.language,
        }

    def _open_language_picker(survey) -> dict:
        """The picker fields while the survey's language is still open, else nothing."""
        if _store().kind != "survey" or has_committed_answer(survey.qml_state):
            return {}
        # A translation belongs to a version, so a survey with no pin of its own
        # (an unpinned campaign, or one rebound to another questionnaire)
        # offers only its source language and shows no picker.
        version_id = flow_service.walk_pin(survey, _fielded_campaign(survey))
        if not version_id:
            return {}
        offered = repository.offered_locales(survey.questionnaire_id, version_id)
        return _language_picker(survey, list(offered)) if len(offered) > 1 else {}

    def _initialize_survey_state(survey):
        """Initialize a walk that has no state, write it, and record ``started``.

        Used by the two endpoints that are not flow steps (``navigation-path``
        and ``reset``); the steps initialize inside ``flow_service``.
        """
        instrument = flow_service.load_instrument(repository, survey)
        processor = flow_service.materialize_walk_state(survey, instrument, external_input_resolver)
        _store().save(survey)
        flow_service.emit_audit(audit_callback, survey, "started")
        return processor

    @blueprint.route("/current-item", methods=["GET"])
    def current_item():
        """Present the current item in the survey flow (opens its timing event)."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)
            # Presenting opens a timing event and may record ``started``, so a
            # paused campaign's unbegun survey is refused here too; a completed
            # survey still reads its end screen.
            if survey.status != "completed" and _refuses_answers(survey):
                return _not_fielding_walk_response(_locale())

            step = flow_service.present_current_item(
                _store(),
                survey,
                source=flow_service.timing_source(survey),
                channel=CHANNEL_WEB,
                audit_callback=audit_callback,
                external_input_resolver=external_input_resolver,
            )

            if step.outcome is FlowOutcome.JUST_COMPLETED:
                return jsonify(
                    {
                        "status": "complete",
                        "survey_id": survey_id,
                        "message": gettext(_locale(), "Survey completed"),
                        "isCompleted": True,
                        "justCompleted": True,
                    }
                ), 200

            if step.outcome is FlowOutcome.COMPLETED:
                # Already completed - show the last item from history, if any
                if step.item:
                    item_data = step.item
                    item_data["survey_id"] = survey_id
                    item_data["isCompleted"] = True
                    item_data["isLast"] = True
                    return jsonify(item_data), 200
                return jsonify(
                    {
                        "status": "complete",
                        "survey_id": survey_id,
                        "message": gettext(_locale(), "Survey completed"),
                        "isCompleted": True,
                    }
                ), 200

            item_data = step.item
            item_data["survey_id"] = survey_id
            item_data["isCompleted"] = step.was_completed
            item_data["pick_token"] = language_pick_token(survey.qml_state)
            item_data.update(_open_language_picker(survey))

            logger.info("survey.navigate survey_id=%s item_id=%s", survey_id, item_data.get("id"))
            return jsonify(item_data), 200
        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("current_item", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/evaluate-item", methods=["POST"])
    def evaluate_item():
        """Evaluate current item and record answer without changing position.

        When skip_postcondition is True, the answer is saved but postcondition
        validation is skipped. This is used for backward navigation where:
        - The item will be marked as unvisited anyway
        - The saved answer is just for convenience (restored when user returns)
        - Real validation happens when user leaves the item going forward
        """
        try:
            data = request.get_json() or {}
            # Get survey_id from request body (client must always provide it)
            survey_id = data.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)
            if _refuses_answers(survey):
                return _not_fielding_walk_response(_locale())

            item_id = data.get("item_id")
            if not item_id:
                return jsonify({"error": "No item_id provided"}), 400

            step = flow_service.evaluate_item(
                _store(),
                survey,
                item_id=item_id,
                outcome=data.get("outcome"),
                skip_postcondition=data.get("skip_postcondition", False),
                source=flow_service.timing_source(survey),
                channel=CHANNEL_WEB,
                pick_token=data.get("pick_token"),
                audit_callback=audit_callback,
                external_input_resolver=external_input_resolver,
            )

            if step.outcome is FlowOutcome.PICK_CHANGED:
                # Another tab picked a language after this page rendered;
                # nothing was written.
                if has_committed_answer(survey.qml_state):
                    return jsonify({"error": "language_locked", "language": survey.language}), 409
                fresh = flow_service.offered_languages(repository, survey)
                return jsonify(
                    {"error": "translation_changed", **_language_picker(survey, fresh)}
                ), 409
            if step.outcome is FlowOutcome.REJECTED:
                return jsonify({"message": step.message}), 400

            # If there was code output, return it for display in the modal
            if step.output:
                output_text = "<br>".join(step.output)
                return jsonify(
                    {
                        "status": "success",
                        "survey_id": survey_id,
                        "message": f"Print: {output_text}",
                    }
                ), 200

            logger.info(
                "survey.evaluate survey_id=%s item_id=%s has_next=%s",
                survey_id,
                item_id,
                step.has_next,
            )
            return jsonify(
                {"status": "success", "survey_id": survey_id, "hasNextItem": step.has_next}
            ), 200
        except SurveyTranslationChangedError:
            # Nothing was written: the answer and the freeze rolled back together.
            fresh = flow_service.offered_languages(repository, survey)
            return jsonify(
                {"error": "translation_changed", **_language_picker(survey, fresh)}
            ), 409
        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("evaluate_item", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/choose-language", methods=["POST"])
    def choose_language():
        """Pick the language a fielded survey is answered in, before its first answer.

        Request body: ``survey_id``, ``language`` (a supported locale). 200 with
        the language on success; 409 ``language_locked`` once an answer is
        stored; 409 ``language_not_offered`` with a fresh picker when the
        campaign's pin does not offer it. A preview has no picker.
        """
        try:
            data = request.get_json() or {}
            survey_id = data.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400
            language = data.get("language")
            if not language:
                return jsonify({"error": "No language provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            if _store().kind != "survey":
                return jsonify({"error": "A preview is walked in its questionnaire's language"}), 400
            survey = flow_service.prepare_walk(survey)
            if _refuses_answers(survey):
                return _not_fielding_walk_response(_locale())

            try:
                choice = flow_service.choose_language(
                    repository, survey, language, external_input_resolver=external_input_resolver
                )
            except UnsupportedQuestionnaireLanguage:
                return jsonify({"error": f"Unsupported language {language!r}"}), 400

            if choice.outcome is flow_service.LanguageChoiceOutcome.LOCKED:
                return jsonify({"error": "language_locked", "language": survey.language}), 409
            if choice.outcome is flow_service.LanguageChoiceOutcome.NOT_OFFERED:
                return jsonify(
                    {"error": "language_not_offered", **_language_picker(survey, choice.offered)}
                ), 409
            logger.info("survey.language survey_id=%s language=%s", survey_id, survey.language)
            return jsonify(
                {"status": "success", "survey_id": survey_id, "language": survey.language}
            ), 200
        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("choose_language", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/previous-item", methods=["GET"])
    def previous_item():
        """Get the previous item from the survey history."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)

            step = flow_service.previous_item(
                _store(),
                survey,
                source=flow_service.timing_source(survey),
                channel=CHANNEL_WEB,
                audit_callback=audit_callback,
                external_input_resolver=external_input_resolver,
            )
            if step.outcome is FlowOutcome.NO_PREVIOUS:
                return jsonify({"error": gettext(_locale(), "No previous item available")}), 404

            item_data = step.item
            item_data["survey_id"] = survey_id

            logger.info("survey.back survey_id=%s item_id=%s", survey_id, item_data.get("id"))
            return jsonify(item_data), 200
        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("previous_item", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/stepper", methods=["GET"])
    def get_stepper():
        """Get stepper progress data for the survey sidebar.

        Returns visited/current items from the navigation history
        so the UI can render a progress stepper with jump-back support.
        """
        try:
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            survey = flow_service.prepare_walk(survey)
            current_item_id = survey.current_item_id
            navigation_history = survey.qml_state.get_history()
            navigable_nodes = set(navigation_history)

            # Build stepper items from navigation history (only visited + current)
            stepper_items = []
            for item_id in navigation_history:
                item = survey.qml_state.get_item(item_id)
                if not item:
                    continue
                status = "current" if item_id == current_item_id else "visited"
                stepper_items.append(
                    {
                        "id": item_id,
                        "title": item.get("title", item_id),
                        "status": status,
                        "navigable": item_id in navigable_nodes or item_id == current_item_id,
                    }
                )
            # If current item is not yet in history (just navigated forward), add it
            if current_item_id and current_item_id not in navigable_nodes:
                item = survey.qml_state.get_item(current_item_id)
                if item:
                    stepper_items.append(
                        {
                            "id": current_item_id,
                            "title": item.get("title", current_item_id),
                            "status": "current",
                            "navigable": True,
                        }
                    )

            return jsonify({"currentItemId": current_item_id, "stepperItems": stepper_items}), 200
        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("stepper", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/navigation-path", methods=["GET"])
    def get_navigation_path():
        """Get the pre-computed navigation path for the survey."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)

            # Initialize processor if needed (force_full=True for engine diagnostics)
            if not survey.qml_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = flow_service.processor_for(survey.qml_state, force_full=True)

            # Get the navigation path from FlowProcessor
            navigation_path = processor.get_navigation_path()

            # Return path information
            return jsonify(
                {
                    "survey_id": survey_id,
                    "navigation_path": navigation_path,
                    "total_items": len(navigation_path),
                    "has_cycles": processor.engine.has_cycles(),
                    "cycles": processor.engine.get_cycles()
                    if processor.engine.has_cycles()
                    else [],
                    "topological_order": processor.engine.get_topological_order(),
                }
            ), 200
        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("navigation_path", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/navigate-to-item", methods=["POST"])
    def navigate_to_item():
        """Navigate directly to a specific item in the survey.

        Navigation is only allowed if:
        1. The target item is in the navigation history (previously visited), OR
        2. The target item has a valid path (all prerequisite items have been answered)

        Request body:
            survey_id: ID of the survey
            target_item_id: ID of the item to navigate to

        Returns:
            Item data if navigation is valid, error otherwise
        """
        try:
            data = request.get_json() or {}
            survey_id = data.get("survey_id")
            target_item_id = data.get("target_item_id")

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400
            if not target_item_id:
                return jsonify({"error": "No target_item_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)
            if _refuses_answers(survey):
                return _not_fielding_walk_response(_locale())

            step = flow_service.navigate_to_item(
                _store(),
                survey,
                target_item_id=target_item_id,
                source=flow_service.timing_source(survey),
                channel=CHANNEL_WEB,
                audit_callback=audit_callback,
                external_input_resolver=external_input_resolver,
            )
            if step.outcome is FlowOutcome.ITEM_NOT_FOUND:
                return jsonify({"error": f"Item {target_item_id} not found in questionnaire"}), 404
            if step.outcome is FlowOutcome.NAVIGATION_REFUSED:
                return jsonify(
                    {
                        "error": gettext(_locale(), "Cannot navigate to this item"),
                        "reason": step.message,
                    }
                ), 400

            target_item = step.item
            target_item["survey_id"] = survey_id

            logger.info("survey.jump survey_id=%s target=%s", survey_id, target_item_id)
            return jsonify(target_item), 200

        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("navigate_to_item", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/reset", methods=["POST"])
    def reset_survey():
        """Reset a survey to its initial state.

        Clears all outcomes, history, and runtime state, and returns the first
        item so the UI can display it. Web-only: the respondent lane has no
        reset, so this stays here rather than in ``flow_service``.

        A fielded survey may be reset before completion by whoever is walking
        it and by nobody after (409 ``survey_completed``); a preview always.

        What it clears and what it KEEPS differ by arrival. For a fielded
        survey the parsed questionnaire is kept — the instrument is pinned for
        the life of the interview. For a **preview** it is re-read from the
        document store instead, so a designer's Reset picks up their own edits
        (#534).

        Request body:
            survey_id: ID of the survey to reset

        Returns:
            First item data with survey_id
        """
        try:
            data = request.get_json() or {}
            survey_id = data.get("survey_id")

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)
            # A reset erases the answers that let a respondent continue after a
            # pause, so it is judged on fielding alone: outside fielding it
            # would only strand them.
            if _store().kind != "preview":
                campaign = _fielded_campaign(survey)
                if campaign is None or campaign.status not in FIELDING_STATUSES:
                    return _not_fielding_walk_response(_locale())
            # A fielded survey that was ever completed is never reset (#1293,
            # D30), a resumed one included: it may already be in a dataset, and
            # its AI channel was revoked on completion. Resume and Back are how
            # a respondent changes answers.
            if _store().kind != "preview" and flow_service.walk_was_completed(survey):
                return jsonify(
                    {
                        "error": "survey_completed",
                        "message": gettext(
                            _locale(),
                            "This survey was completed and cannot be reset. "
                            "Use Back or Resume to change an answer.",
                        ),
                    }
                ), 409

            # Initialize if needed (shouldn't happen but be safe)
            if not survey.qml_state:
                processor = _initialize_survey_state(survey)
            elif _store().kind == "preview":
                # A preview is a design-time walk of an instrument someone is
                # actively editing, so its Reset re-reads the document rather
                # than replaying the copy captured at first render. Without
                # this the designer edits the QML, resets, and still walks the
                # old instrument — with nothing on the page saying so (#534).
                #
                # A fielded survey must NOT do this: its instrument is pinned
                # for the life of the interview, which is what stops a save
                # from changing the questions mid-interview (R11/KTD6, see
                # load_fielded_qml_content).
                #
                # Nothing is carried across: a fresh QMLState drops outcomes,
                # visited flags, history and roster state alike. That is the
                # reset semantic already, and it is why re-reading here needs
                # no answer-migration — a Comment, whose only per-item state is
                # `visited`, has no outcome to reconstruct it from.
                processor = flow_service.materialize_walk_state(
                    survey,
                    flow_service.load_instrument(repository, survey),
                    external_input_resolver,
                )
            else:
                # Reset the questionnaire state
                survey.qml_state.reset()
                processor = flow_service.processor_for(survey.qml_state)
                # reset() cleared the external-input sentinel + provenance, so
                # re-run the resolver to re-prefill external items — otherwise a
                # reset would leave an external item to be asked directly,
                # defeating its "auto-answered, not presented" contract.
                if external_input_resolver is not None:
                    external_input_resolver(survey, processor)

            # Reset survey status
            survey.status = "in_progress"

            # Get the first item
            first_item = processor.get_current_item(survey.qml_state)

            # Update survey position and save
            flow_service.update_position(survey, first_item)
            _store().save(survey)

            if first_item:
                first_item["survey_id"] = survey_id

            flow_service.emit_audit(audit_callback, survey, "reset")

            logger.info(f"Survey {survey_id} reset successfully")
            return jsonify({"status": "success", "item": first_item}), 200

        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("reset", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/finish", methods=["POST"])
    def finish_survey():
        """Mark a survey as completed early (abort).

        This allows users to finish a survey before answering all questions.
        The survey status is set to 'completed' and all progress is preserved.

        Request body:
            survey_id: ID of the survey to finish

        Returns:
            Success status with survey_id
        """
        try:
            data = request.get_json() or {}
            survey_id = data.get("survey_id")

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)
            if _refuses_answers(survey):
                return _not_fielding_walk_response(_locale())

            step = flow_service.finish(_store(), survey, audit_callback=audit_callback)
            if step.outcome is FlowOutcome.ALREADY_COMPLETED:
                return jsonify(
                    {
                        "status": "already_completed",
                        "survey_id": survey_id,
                        "message": gettext(_locale(), "Survey is already completed"),
                    }
                ), 200

            logger.info(f"Survey {survey_id} finished early (aborted)")
            return jsonify(
                {
                    "status": "success",
                    "survey_id": survey_id,
                    "message": gettext(_locale(), "Survey finished successfully"),
                }
            ), 200

        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("finish", e)
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/resume", methods=["POST"])
    def resume_survey():
        """Resume a completed survey, bringing it back to in_progress.

        This allows users to continue a completed survey from where they left off.
        The survey status is set back to 'in_progress' and navigation resumes.

        Request body:
            survey_id: ID of the survey to resume

        Returns:
            Current item data if available, or success status
        """
        try:
            data = request.get_json() or {}
            survey_id = data.get("survey_id")

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _load_walk(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)
            if _refuses_answers(survey):
                return _not_fielding_walk_response(_locale())

            step = flow_service.resume(
                _store(),
                survey,
                source=flow_service.timing_source(survey),
                channel=CHANNEL_WEB,
                audit_callback=audit_callback,
                external_input_resolver=external_input_resolver,
            )
            if step.outcome is FlowOutcome.NOT_COMPLETED:
                return jsonify(
                    {
                        "status": "not_completed",
                        "survey_id": survey_id,
                        "message": gettext(_locale(), "Survey is not completed, cannot resume"),
                    }
                ), 400

            logger.info(f"Survey {survey_id} resumed from completed state")

            if step.item:
                item_data = step.item
                item_data["survey_id"] = survey_id
                return jsonify(
                    {
                        "status": "success",
                        "survey_id": survey_id,
                        "item": item_data,
                        "message": gettext(_locale(), "Survey resumed successfully"),
                    }
                ), 200
            # All items were already visited
            return jsonify(
                {
                    "status": "success",
                    "survey_id": survey_id,
                    "message": gettext(_locale(), "Survey resumed but all items are completed"),
                }
            ), 200

        except OrganizationSealedError:
            return _sealed_walk_response(_locale())
        except SurveyStateConflictError:
            return _conflict_walk_response(_locale())
        except Exception as e:
            _log_failure("resume", e)
            return jsonify({"error": str(e)}), 500

    return blueprint
