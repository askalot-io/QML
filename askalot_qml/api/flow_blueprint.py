"""Flow API blueprint for QML survey navigation and evaluation."""

import logging
from collections.abc import Callable
from typing import Any

from flask import Blueprint, jsonify, request

from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.core.qml_source import load_fielded_qml_content
from askalot_qml.models.qml_state import SOURCE_INTERVIEWER, SOURCE_RESPONDENT, QMLState

# Type alias for audit callback function
AuditCallback = Callable[[str, str, str, dict[str, Any] | None], None]

# Type alias for the external-input resolver callback (QML External Inputs, U5).
# The service supplies this so askalot_qml stays repository-free: the shared
# module calls back into the service to resolve external-input sources and apply
# them at survey init. Signature: resolver(survey, processor) -> None. The
# service reads the survey's campaign mapping + respondent, builds the injection
# map, and calls processor.apply_external_inputs(survey.qml_state, map). Must be
# fail-safe (never raise) — prefill is an optimization, never a blocker.
ExternalInputResolver = Callable[[Any, Any], None]


def create_flow_blueprint(
    repository,
    url_prefix: str = "/api/flow",
    audit_callback: AuditCallback | None = None,
    external_input_resolver: ExternalInputResolver | None = None,
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

    Returns:
        Flask blueprint with flow endpoints
    """
    blueprint = Blueprint("qml_flow", __name__, url_prefix=url_prefix)
    logger = logging.getLogger(__name__)

    def _set_org_context_from_request():
        """
        Set organization context for flow API requests.

        Flow API endpoints are excluded from JWT middleware to support magic link access.
        This function handles org context for both authenticated users (JWT) and
        magic link users (request params).

        Priority:
        1. JWT token (if present and valid) - for authenticated users
        2. Request params (organization_id) - fallback for magic link access
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
        except Exception as e:
            logger.debug(f"Could not get org from JWT: {e}")

        # Fallback: get organization_id from request params (magic link access)
        organization_id = request.args.get("organization_id")
        if not organization_id and request.is_json:
            data = request.get_json(silent=True) or {}
            organization_id = data.get("organization_id")

        if organization_id:
            # Look up organization by ID to get slug for context
            org = repository.get_organization(organization_id)
            if org:
                set_organization_context(org.id, org.slug)
                logger.debug(f"Set org context from request params (org_id): {org.slug}")

    def _log_audit(
        entity_type: str,
        entity_id: str,
        action: str,
        context_extra: dict[str, Any] | None = None,
    ) -> None:
        """Log audit event if callback is provided."""
        if audit_callback:
            try:
                audit_callback(entity_type, entity_id, action, context_extra)
            except Exception as e:
                logger.warning(f"Failed to log audit event ({entity_type}.{action}): {e}")

    def _ensure_qml_state(survey):
        """Ensure survey.qml_state is a QMLState object, not a plain dict.

        When surveys are loaded from the database, qml_state is deserialized as
        a plain dict. This function wraps it in a QMLState object if needed.

        Args:
            survey: Survey entity with qml_state field

        Returns:
            The survey with qml_state properly wrapped in QMLState
        """
        if survey.qml_state and not isinstance(survey.qml_state, QMLState):
            survey.qml_state = QMLState(survey.qml_state)
        return survey

    def _get_flow_processor(questionnaire_state, force_full: bool = False) -> FlowProcessor:
        """Get FlowProcessor for the given questionnaire state.

        Uses lightweight cached-state initialization (no Z3) when the survey
        already has a navigation path. Falls back to full initialization for
        first-time setup or when force_full=True.

        Args:
            questionnaire_state: QMLState object or dict (from database deserialization)
            force_full: Force full Z3 initialization even if nav path exists

        Returns:
            FlowProcessor instance with properly initialized QMLState
        """
        # Ensure questionnaire_state is a QMLState object (not a plain dict)
        # When loaded from database, qml_state is a plain dict and needs wrapping
        if not isinstance(questionnaire_state, QMLState):
            questionnaire_state = QMLState(questionnaire_state)

        # Use lightweight initialization when navigation path is already cached
        if not force_full and questionnaire_state.get_navigation_path():
            return FlowProcessor.from_cached_state(questionnaire_state)

        return FlowProcessor(questionnaire_state)

    def _load_fielded_questionnaire(survey, questionnaire) -> QMLState:
        """Build the survey's initial state from the version it is fielded on.

        Content comes from the document store, resolved through the campaign's
        pin (``load_fielded_qml_content``) — not from the questionnaire's head.
        A survey started before a publish keeps its instrument for its whole
        life; only a campaign-less ad-hoc survey reads head.
        """
        qml_content = load_fielded_qml_content(repository, survey, questionnaire)
        parsed_qml = QMLLoader(logger=logger).load_from_string(qml_content)
        logger.info("QML loaded and validated successfully.")
        return QMLState(parsed_qml)

    def _update_survey_position(survey, item_data: dict[str, Any] | None) -> None:
        """Update survey's current position tracking fields.

        Args:
            survey: The survey object to update
            item_data: Current item data containing 'id' and 'blockId', or None if survey complete
        """
        if item_data:
            survey.current_item_id = item_data.get("id")
            survey.current_block_id = item_data.get("blockId")
        else:
            # Survey is complete - clear position
            survey.current_item_id = None
            survey.current_block_id = None

    def _timing_source(survey) -> str:
        """Which kind of person is answering this survey (R9).

        ``survey.mode`` is derived from whether an interviewer is assigned, and
        that is the whole distinction the timing log needs: an interviewer-paced
        answer and a self-administered one have different duration
        distributions, so mixing them would make either look anomalous against
        the other.
        """
        return SOURCE_INTERVIEWER if survey.mode == "field_interview" else SOURCE_RESPONDENT

    def _close_open_timing_event(survey) -> None:
        """Close the item being left as uncommitted, if its event is still open.

        Called by the navigation endpoints, which move the answerer off an item
        without an answer being accepted. The time was genuinely spent, so the
        event stays in the log (and in visit totals); marking it uncommitted is
        what keeps it out of attempt counts (KTD4).

        Guarded on an event actually being open because the UI normally saves
        what is on screen before stepping back, and that save already closed
        the event — an unconditional close would warn on every ordinary step.
        """
        item_id = survey.current_item_id
        if not item_id:
            return
        iter_key = survey.qml_state.current_iter_key(item_id)
        if survey.qml_state.has_open_timing_event(item_id, iter_key):
            survey.qml_state.close_timing_event(item_id, iter_key, committed=False)

    def _initialize_survey_state(survey):
        """Initialize a survey with a questionnaire state."""
        # Get the questionnaire from the database to find its QML name
        questionnaire = repository.get_questionnaire(survey.questionnaire_id)
        if not questionnaire:
            logger.error(
                f"Cannot find questionnaire {survey.questionnaire_id} for survey {survey.id}"
            )
            raise ValueError(
                f"Cannot find questionnaire {survey.questionnaire_id} for survey {survey.id}"
            )

        # Load the questionnaire content the campaign pinned at publish time
        survey.qml_state = _load_fielded_questionnaire(survey, questionnaire)

        # Initialize FlowProcessor with questionnaire state
        processor = _get_flow_processor(survey.qml_state)

        # Pre-answer external items from the respondent record before the flow
        # is walked (QML External Inputs plan, U5). The service supplies this
        # callback so askalot_qml stays repository-free; it is idempotent (the
        # resolver's own sentinel guards re-entry) and fail-safe (never raises).
        if external_input_resolver is not None:
            external_input_resolver(survey, processor)

        repository.upsert_survey(survey)

        # Log audit event for survey started
        _log_audit(
            "survey",
            survey.id,
            "started",
            {"questionnaire_id": survey.questionnaire_id, "campaign_id": survey.campaign_id},
        )

        return processor

    @blueprint.route("/current-item", methods=["GET"])
    def current_item():
        """Get the current item in the survey flow based on preconditions."""
        try:
            # Set org context from request params (for magic link access)
            _set_org_context_from_request()

            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Ensure qml_state is a QMLState object (not a plain dict from database)
            survey = _ensure_qml_state(survey)

            # Check if survey is already completed
            is_completed = survey.status == "completed"

            # Lazy initialization if questionnaire_state is missing or empty
            # Check for actual items since QMLState defaults to empty lists
            if not survey.qml_state or not survey.qml_state.get("items"):
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.qml_state)

            # Get current item using FlowProcessor
            item_data = processor.get_current_item(survey.qml_state, backward=False)

            if not item_data:
                # No more items - survey is complete
                if not is_completed:
                    # First time completing - update position and save
                    _update_survey_position(survey, None)
                    survey.status = "completed"
                    repository.upsert_survey(survey)

                    # Log audit event for survey completed
                    _log_audit(
                        "survey",
                        survey_id,
                        "completed",
                        {
                            "questionnaire_id": survey.questionnaire_id,
                            "campaign_id": survey.campaign_id,
                        },
                    )

                    return jsonify(
                        {
                            "status": "complete",
                            "survey_id": survey_id,
                            "message": "Survey completed",
                            "isCompleted": True,
                            "justCompleted": True,
                        }
                    ), 200
                else:
                    # Already completed - try to get the last item from history
                    navigation_history = survey.qml_state.get_history()
                    if navigation_history:
                        last_item_id = navigation_history[-1]
                        item_data = survey.qml_state.get_item(last_item_id)
                        if item_data:
                            item_data["survey_id"] = survey_id
                            item_data["isCompleted"] = True
                            item_data["isLast"] = True
                            return jsonify(item_data), 200

                    # No history available
                    return jsonify(
                        {
                            "status": "complete",
                            "survey_id": survey_id,
                            "message": "Survey completed",
                            "isCompleted": True,
                        }
                    ), 200

            # Update survey position tracking and save
            _update_survey_position(survey, item_data)

            # Presentation seam of the timing log (R7). Called unconditionally:
            # this endpoint is a GET that re-runs on every page render, refresh
            # and resume, and the idempotence of open_timing_event is what keeps
            # a refresh from resetting the respondent's clock (KTD2, AE6). A
            # guard here would be a second place for that rule to live.
            item_id = item_data.get("id")
            if item_id:
                survey.qml_state.open_timing_event(
                    item_id, survey.qml_state.current_iter_key(item_id), _timing_source(survey)
                )

            repository.upsert_survey(survey)

            # Add survey_id and completion status to response
            item_data["survey_id"] = survey_id
            item_data["isCompleted"] = is_completed

            # Add navigation progress (current position / total in path)
            navigation_path = survey.qml_state.get_navigation_path()
            current_item_id = item_data.get("id")
            if current_item_id and navigation_path:
                try:
                    # Position is 1-based for display
                    item_data["navigationPosition"] = navigation_path.index(current_item_id) + 1
                    item_data["navigationTotal"] = len(navigation_path)
                except ValueError:
                    # Item not in path (shouldn't happen, but be safe)
                    item_data["navigationPosition"] = None
                    item_data["navigationTotal"] = len(navigation_path)

            # Roster items: surface iteration metadata so the UI can
            # render the per-iteration label banner (e.g., "2 of 4 · Lunch").
            # Item titles render verbatim — no template substitution.
            roster_block_id = item_data.get("_roster_block_id")
            if roster_block_id:
                iter_key = survey.qml_state.get_current_roster_iter(roster_block_id)
                active_keys = survey.qml_state.get_roster_active_keys(roster_block_id) or []
                labels = item_data.get("_roster_labels") or {}
                if iter_key is not None:
                    item_data["iterationKey"] = iter_key
                    # Prefer the engine-resolved subject (dynamic subjectFrom, or
                    # the static label — FlowProcessor._resolve_roster_subject).
                    # Labels keys may arrive as strings after JSONB roundtrip; try both.
                    item_data["iterationLabelText"] = (
                        item_data.get("_roster_current_label")
                        or labels.get(iter_key)
                        or labels.get(str(iter_key))
                        or ""
                    )
                    if iter_key in active_keys:
                        item_data["iterationPosition"] = active_keys.index(iter_key) + 1
                    item_data["iterationTotal"] = len(active_keys)

            # Return the item data
            logger.info("survey.navigate survey_id=%s item_id=%s", survey_id, item_data.get("id"))
            return jsonify(item_data), 200
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
            # Set org context from request body (for magic link access)
            _set_org_context_from_request()

            data = request.get_json() or {}
            # Get survey_id from request body (client must always provide it)
            survey_id = data.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Ensure qml_state is a QMLState object (not a plain dict from database)
            survey = _ensure_qml_state(survey)

            # Get item_id and outcome from the request
            item_id = data.get("item_id")
            if not item_id:
                return jsonify({"error": "No item_id provided"}), 400

            outcome = data.get("outcome")

            # skip_postcondition: Skip validation when navigating backward
            # The item will be marked unvisited, so validation is deferred to forward navigation
            skip_postcondition = data.get("skip_postcondition", False)

            # Initialize processor if needed
            if not survey.qml_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.qml_state)

            # Process the item using FlowProcessor. The submission half of the
            # timing event happens inside process_item, which reads
            # skip_postcondition for the committed flag — a backward-navigation
            # convenience save is timed but is not an attempt (KTD4).
            result = processor.process_item(
                survey.qml_state,
                item_id,
                outcome,
                source=_timing_source(survey),
                skip_postcondition=skip_postcondition,
            )

            if not result.get("success", False):
                return jsonify({"message": result.get("message", "Failed to process item")}), 400

            # Save the updated survey state (position is updated by navigation endpoints only)
            repository.upsert_survey(survey)

            # If there was code output, return it for display in the modal
            if "output" in result and result["output"]:
                output_text = "<br>".join(result["output"])
                return jsonify(
                    {
                        "status": "success",
                        "survey_id": survey_id,
                        "message": f"Print: {output_text}",
                    }
                ), 200

            # Check if there are reachable unvisited items after codeBlock execution
            # (read-only check — does NOT modify navigation history or item flags)
            all_items = survey.qml_state.get_all_items()
            navigation_path = survey.qml_state.get_navigation_path()
            has_next = False
            for nav_item_id in navigation_path:
                nav_item = survey.qml_state.get_item(nav_item_id)
                if not nav_item or nav_item.get("visited"):
                    continue
                if processor._check_preconditions(nav_item, all_items):
                    has_next = True
                    break

            response_data = {"status": "success", "survey_id": survey_id, "hasNextItem": has_next}

            logger.info(
                "survey.evaluate survey_id=%s item_id=%s has_next=%s", survey_id, item_id, has_next
            )
            return jsonify(response_data), 200
        except Exception as e:
            logger.error(f"Error evaluating item: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/previous-item", methods=["GET"])
    def previous_item():
        """Get the previous item from the survey history."""
        try:
            # Set org context from request params (for magic link access)
            _set_org_context_from_request()

            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Ensure qml_state is a QMLState object (not a plain dict from database)
            survey = _ensure_qml_state(survey)

            # Initialize processor if needed
            if not survey.qml_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.qml_state)

            # Close the item being left before the walk moves — backward
            # navigation rewrites the Roster pass state, so the iteration key
            # this event belongs to is only resolvable from here.
            _close_open_timing_event(survey)

            # Get the previous item using FlowProcessor
            item_data = processor.get_current_item(survey.qml_state, backward=True)
            if not item_data:
                return jsonify({"error": "No previous item available"}), 404

            # Update survey position tracking and save after backward navigation
            _update_survey_position(survey, item_data)

            # Presentation seam (R7): the item the respondent lands on is being
            # presented anew, so open its timing event — mirroring /current-item
            # and /resume. The client renders this response directly and does not
            # re-fetch /current-item, so without this a later re-answer would be
            # timed only from process_item's own open+close and read ~0s. The
            # open is idempotent per (item, iteration), so a subsequent
            # /current-item render does not reset the clock (KTD2).
            back_item_id = item_data.get("id")
            if back_item_id:
                survey.qml_state.open_timing_event(
                    back_item_id,
                    survey.qml_state.current_iter_key(back_item_id),
                    _timing_source(survey),
                )

            repository.upsert_survey(survey)

            # Add survey_id to response for client convenience
            item_data["survey_id"] = survey_id

            # Add navigation progress (current position / total in path)
            navigation_path = survey.qml_state.get_navigation_path()
            current_item_id = item_data.get("id")
            if current_item_id and navigation_path:
                try:
                    item_data["navigationPosition"] = navigation_path.index(current_item_id) + 1
                    item_data["navigationTotal"] = len(navigation_path)
                except ValueError:
                    item_data["navigationPosition"] = None
                    item_data["navigationTotal"] = len(navigation_path)

            # Return the item data
            logger.info("survey.back survey_id=%s item_id=%s", survey_id, item_data.get("id"))
            return jsonify(item_data), 200
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
            _set_org_context_from_request()

            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            survey = _ensure_qml_state(survey)
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
        except Exception as e:
            logger.error(f"Error building stepper data: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/navigation-path", methods=["GET"])
    def get_navigation_path():
        """Get the pre-computed navigation path for the survey."""
        try:
            # Set org context from request params (for magic link access)
            _set_org_context_from_request()

            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get("survey_id")
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Ensure qml_state is a QMLState object (not a plain dict from database)
            survey = _ensure_qml_state(survey)

            # Initialize processor if needed (force_full=True for engine diagnostics)
            if not survey.qml_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.qml_state, force_full=True)

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
            # Set org context from request body (for magic link access)
            _set_org_context_from_request()

            data = request.get_json() or {}
            survey_id = data.get("survey_id")
            target_item_id = data.get("target_item_id")

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400
            if not target_item_id:
                return jsonify({"error": "No target_item_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Ensure qml_state is a QMLState object (not a plain dict from database)
            survey = _ensure_qml_state(survey)

            # Initialize processor if needed
            if not survey.qml_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.qml_state)

            # Get the target item
            target_item = survey.qml_state.get_item(target_item_id)
            if not target_item:
                return jsonify({"error": f"Item {target_item_id} not found in questionnaire"}), 404

            # Check navigation validity
            navigation_history = survey.qml_state.get_history()
            is_in_history = target_item_id in navigation_history

            # Check if item has valid path (all prerequisites answered)
            has_valid_path = False
            if not is_in_history:
                # Check if all items before this in the navigation path have outcomes
                navigation_path = survey.qml_state.get_navigation_path()
                all_items = survey.qml_state.get_all_items()
                if target_item_id in navigation_path:
                    target_index = navigation_path.index(target_item_id)
                    # All preceding items must be visited or have unsatisfied preconditions
                    has_valid_path = True
                    for i in range(target_index):
                        preceding_item = survey.qml_state.get_item(navigation_path[i])
                        if preceding_item:
                            # Item is done if visited or if preconditions are not met (skipped)
                            is_visited = preceding_item.get("visited", False)
                            is_precondition_skipped = not processor._check_preconditions(
                                preceding_item, all_items
                            )
                            if not is_visited and not is_precondition_skipped:
                                has_valid_path = False
                                break

            if not is_in_history and not has_valid_path:
                return jsonify(
                    {
                        "error": "Cannot navigate to this item",
                        "reason": "Item is not in history and does not have a valid path (prerequisites not completed)",
                    }
                ), 400

            # Close the item being left before the jump rewrites history.
            _close_open_timing_event(survey)

            # Perform navigation
            if is_in_history:
                # Navigate backward through history to reach the target
                history_index = navigation_history.index(target_item_id)
                # Truncate history to include only up to target item
                new_history = navigation_history[: history_index + 1]

                # Mark items after target as unvisited
                for item_id in navigation_history[history_index + 1 :]:
                    item = survey.qml_state.get_item(item_id)
                    if item:
                        item["visited"] = False

                # Update history in questionnaire state
                survey.qml_state["history"] = new_history
            else:
                # Add target to history (forward navigation with valid path)
                if target_item_id not in navigation_history:
                    survey.qml_state.add_to_history(target_item_id)

            # Update survey position
            _update_survey_position(survey, target_item)

            # Presentation seam (R7): the stepper jump re-presents the target
            # item, so open its timing event — mirroring /current-item, /resume
            # and /previous-item. The client renders this response directly
            # without re-fetching /current-item; without this a re-answer on the
            # jumped-to item would be timed only from process_item's own
            # open+close and read ~0s. Idempotent per (item, iteration).
            jump_item_id = target_item.get("id")
            if jump_item_id:
                survey.qml_state.open_timing_event(
                    jump_item_id,
                    survey.qml_state.current_iter_key(jump_item_id),
                    _timing_source(survey),
                )

            repository.upsert_survey(survey)

            # Add survey_id to response
            target_item["survey_id"] = survey_id

            # Add navigation progress (current position / total in path)
            navigation_path = survey.qml_state.get_navigation_path()
            if target_item_id and navigation_path:
                try:
                    target_item["navigationPosition"] = navigation_path.index(target_item_id) + 1
                    target_item["navigationTotal"] = len(navigation_path)
                except ValueError:
                    target_item["navigationPosition"] = None
                    target_item["navigationTotal"] = len(navigation_path)

            logger.info("survey.jump survey_id=%s target=%s", survey_id, target_item_id)
            return jsonify(target_item), 200

        except Exception as e:
            logger.error(f"Error navigating to item: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route("/reset", methods=["POST"])
    def reset_survey():
        """Reset a survey to its initial state.

        Clears all outcomes, history, and runtime state.
        Returns the first item so the UI can display it.

        Request body:
            survey_id: ID of the survey to reset

        Returns:
            First item data with survey_id
        """
        try:
            # Set org context from request body (for magic link access)
            _set_org_context_from_request()

            data = request.get_json() or {}
            survey_id = data.get("survey_id")

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Ensure qml_state is a QMLState object (not a plain dict from database)
            survey = _ensure_qml_state(survey)

            # Initialize if needed (shouldn't happen but be safe)
            if not survey.qml_state:
                processor = _initialize_survey_state(survey)
            else:
                # Reset the questionnaire state
                survey.qml_state.reset()
                processor = _get_flow_processor(survey.qml_state)
                # reset() cleared the external-input sentinel + provenance, so
                # re-run the resolver to re-prefill external items — otherwise a
                # reset would leave an external item to be asked directly,
                # defeating its "auto-answered, not presented" contract. Only
                # _initialize_survey_state calls the resolver on the first-init
                # path; the reset path must call it too.
                if external_input_resolver is not None:
                    external_input_resolver(survey, processor)

            # Reset survey status
            survey.status = "in_progress"

            # Get the first item
            first_item = processor.get_current_item(survey.qml_state)

            # Update survey position and save
            _update_survey_position(survey, first_item)
            repository.upsert_survey(survey)

            if first_item:
                first_item["survey_id"] = survey_id

            # Log audit event for survey reset
            _log_audit(
                "survey",
                survey_id,
                "reset",
                {"questionnaire_id": survey.questionnaire_id, "campaign_id": survey.campaign_id},
            )

            logger.info(f"Survey {survey_id} reset successfully")
            return jsonify({"status": "success", "item": first_item}), 200

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
            # Set org context from request body (for magic link access)
            _set_org_context_from_request()

            data = request.get_json() or {}
            survey_id = data.get("survey_id")

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Ensure qml_state is a QMLState object (not a plain dict from database)
            survey = _ensure_qml_state(survey)

            # Check if already completed
            if survey.status == "completed":
                return jsonify(
                    {
                        "status": "already_completed",
                        "survey_id": survey_id,
                        "message": "Survey is already completed",
                    }
                ), 200

            # Mark survey as completed
            survey.status = "completed"

            # The item on screen is being left unanswered — close its event
            # here, while the position still says which item that was. Clearing
            # the position first would strand the event open, and a later
            # /resume would then measure the whole absence as answer time.
            _close_open_timing_event(survey)

            # Clear current position (survey is done)
            _update_survey_position(survey, None)
            repository.upsert_survey(survey)

            # Log audit event for survey finished early
            _log_audit(
                "survey",
                survey_id,
                "finished_early",
                {"questionnaire_id": survey.questionnaire_id, "campaign_id": survey.campaign_id},
            )

            logger.info(f"Survey {survey_id} finished early (aborted)")
            return jsonify(
                {
                    "status": "success",
                    "survey_id": survey_id,
                    "message": "Survey finished successfully",
                }
            ), 200

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
            # Set org context from request body (for magic link access)
            _set_org_context_from_request()

            data = request.get_json() or {}
            survey_id = data.get("survey_id")

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Ensure qml_state is a QMLState object (not a plain dict from database)
            survey = _ensure_qml_state(survey)

            # Check if survey is completed
            if survey.status != "completed":
                return jsonify(
                    {
                        "status": "not_completed",
                        "survey_id": survey_id,
                        "message": "Survey is not completed, cannot resume",
                    }
                ), 400

            # Set survey back to in_progress
            survey.status = "in_progress"

            # Initialize processor if needed
            if not survey.qml_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.qml_state)

            # A survey is resumed after it was abandoned or finished early, so
            # any event still open was left open by that departure. Close it
            # uncommitted and start a fresh one for the item now being
            # re-presented: two events, one of which spans the absence, instead
            # of a single event whose duration silently includes it.
            _close_open_timing_event(survey)

            # Get the current item (will find first unvisited or last in path)
            item_data = processor.get_current_item(survey.qml_state, backward=False)

            # Update survey position and save
            _update_survey_position(survey, item_data)

            if item_data and item_data.get("id"):
                resumed_item_id = item_data["id"]
                survey.qml_state.open_timing_event(
                    resumed_item_id,
                    survey.qml_state.current_iter_key(resumed_item_id),
                    _timing_source(survey),
                )

            repository.upsert_survey(survey)

            # Log audit event for survey resumed
            _log_audit(
                "survey",
                survey_id,
                "resumed",
                {"questionnaire_id": survey.questionnaire_id, "campaign_id": survey.campaign_id},
            )

            logger.info(f"Survey {survey_id} resumed from completed state")

            if item_data:
                item_data["survey_id"] = survey_id
                return jsonify(
                    {
                        "status": "success",
                        "survey_id": survey_id,
                        "item": item_data,
                        "message": "Survey resumed successfully",
                    }
                ), 200
            else:
                # All items were already visited - return last item
                return jsonify(
                    {
                        "status": "success",
                        "survey_id": survey_id,
                        "message": "Survey resumed but all items are completed",
                    }
                ), 200

        except Exception as e:
            logger.error(f"Error resuming survey: {e}")
            return jsonify({"error": str(e)}), 500

    return blueprint
