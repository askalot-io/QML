"""Flow API blueprint for QML survey navigation and evaluation.

The HTTP face of the flow engine. The step logic (current item, evaluate,
previous, navigate, finish, resume) lives in ``flow_service`` so the respondent
lane walks surveys on the same engine; this module owns only what is HTTP —
the credential check, request parsing, the request-scoped store on ``g``, and
response shaping. Every presenting step passes channel ``web``.
"""

import logging
from collections.abc import Callable

from askalot_common.repository.exceptions import (
    OrganizationSealedError,
    SurveyStateConflictError,
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
_WALK_CLOSED = (
    "This survey is closed. Its organization has been sealed, so it is no "
    "longer accepting responses."
)


def _sealed_walk_response():
    """The legible refusal a sealed organization's fielded walk returns.

    Carries the same ``org_sealed`` code the request guard uses, so a client
    that already distinguishes a seal refusal from an RBAC 403 keeps working.
    """
    return jsonify({"error": "org_sealed", "detail": _WALK_CLOSED}), 403


def _conflict_walk_response():
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
                "message": "This survey changed in another window. Reload to continue.",
            }
        ),
        409,
    )


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
    logger = logging.getLogger(__name__)

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

    def _requested_survey_ids() -> set[str]:
        """EVERY survey this request names, from both places an endpoint reads.

        Collected as a set rather than resolved to one value, because the two
        sources do not agree about which one wins. This helper used to prefer
        the query argument and fall back to the body — but the endpoints split
        the other way: the GET routes read `request.args` while
        `evaluate-item`, `navigate-to-item`, `reset`, `finish` and `resume`
        read `data.get("survey_id")` from the body alone. So a request carrying
        a MATCHING query argument and a MISMATCHING body satisfied this check
        and was then served against the body's survey — the precedence gap was
        the bypass.

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
            from_body = (request.get_json(silent=True) or {}).get("survey_id")
            if from_body:
                ids.add(str(from_body))
        return ids

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

        Raises:
            FlowSessionError: 401 when nothing authorized the request, 403 when
                a valid session was presented for a survey it does not name.
        """
        from askalot_common.repository import get_organization_context, set_organization_context

        # Skip if org context already set (returns OrganizationContext object or None)
        if get_organization_context():
            return

        # Try to get org context from JWT token first (authenticated users)
        try:
            from askalot_common.auth import extract_jwt_token, get_auth_config, verify_jwt_token

            token = extract_jwt_token()
            if token:
                config = get_auth_config()
                payload = verify_jwt_token(token, config)
                if payload:
                    organization_id = payload.get("organization_id")
                    organization_slug = payload.get("organization_slug")
                    if organization_id and organization_slug:
                        set_organization_context(organization_id, organization_slug)
                        logger.debug(f"Set org context from JWT: {organization_slug}")
                        return
        except OrganizationSealedError:
            return _sealed_walk_response()
        except Exception as e:
            logger.debug(f"Could not get org from JWT: {e}")

        session = session_resolver() if session_resolver else None
        if session is None:
            raise FlowSessionError(
                "This request carries no credential the flow API accepts. "
                "Open the survey through its link, or sign in."
            )

        organization_id, organization_slug, session_survey_id = session
        requested_survey_ids = _requested_survey_ids()
        if any(str(session_survey_id) != rid for rid in requested_survey_ids):
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

            survey = _store().load(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)

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
                        "message": "Survey completed",
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
                        "message": "Survey completed",
                        "isCompleted": True,
                    }
                ), 200

            item_data = step.item
            item_data["survey_id"] = survey_id
            item_data["isCompleted"] = step.was_completed

            logger.info("survey.navigate survey_id=%s item_id=%s", survey_id, item_data.get("id"))
            return jsonify(item_data), 200
        except OrganizationSealedError:
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error getting current item: {e}")
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

            survey = _store().load(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)

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
                audit_callback=audit_callback,
                external_input_resolver=external_input_resolver,
            )

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
        except OrganizationSealedError:
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error evaluating item: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/previous-item", methods=["GET"])
    def previous_item():
        """Get the previous item from the survey history."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _store().load(survey_id)
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
                return jsonify({"error": "No previous item available"}), 404

            item_data = step.item
            item_data["survey_id"] = survey_id

            logger.info("survey.back survey_id=%s item_id=%s", survey_id, item_data.get("id"))
            return jsonify(item_data), 200
        except OrganizationSealedError:
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error getting previous item: {e}")
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

            survey = _store().load(survey_id)
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
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error building stepper data: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/navigation-path", methods=["GET"])
    def get_navigation_path():
        """Get the pre-computed navigation path for the survey."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = _store().load(survey_id)
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
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error getting navigation path: {e}")
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

            survey = _store().load(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)

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
                    {"error": "Cannot navigate to this item", "reason": step.message}
                ), 400

            target_item = step.item
            target_item["survey_id"] = survey_id

            logger.info("survey.jump survey_id=%s target=%s", survey_id, target_item_id)
            return jsonify(target_item), 200

        except OrganizationSealedError:
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error navigating to item: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/reset", methods=["POST"])
    def reset_survey():
        """Reset a survey to its initial state.

        Clears all outcomes, history, and runtime state, and returns the first
        item so the UI can display it. Web-only: the respondent lane has no
        reset, so this stays here rather than in ``flow_service``.

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

            survey = _store().load(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)

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
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error resetting survey: {e}")
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

            survey = _store().load(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)

            step = flow_service.finish(_store(), survey, audit_callback=audit_callback)
            if step.outcome is FlowOutcome.ALREADY_COMPLETED:
                return jsonify(
                    {
                        "status": "already_completed",
                        "survey_id": survey_id,
                        "message": "Survey is already completed",
                    }
                ), 200

            logger.info(f"Survey {survey_id} finished early (aborted)")
            return jsonify(
                {
                    "status": "success",
                    "survey_id": survey_id,
                    "message": "Survey finished successfully",
                }
            ), 200

        except OrganizationSealedError:
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error finishing survey: {e}")
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

            survey = _store().load(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            survey = flow_service.prepare_walk(survey)

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
                        "message": "Survey is not completed, cannot resume",
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
                        "message": "Survey resumed successfully",
                    }
                ), 200
            # All items were already visited
            return jsonify(
                {
                    "status": "success",
                    "survey_id": survey_id,
                    "message": "Survey resumed but all items are completed",
                }
            ), 200

        except OrganizationSealedError:
            return _sealed_walk_response()
        except SurveyStateConflictError:
            return _conflict_walk_response()
        except Exception as e:
            logger.error(f"Error resuming survey: {e}")
            return jsonify({"error": str(e)}), 500

    return blueprint
