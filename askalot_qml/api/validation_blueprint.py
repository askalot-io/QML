"""Validation API blueprint for QML processing and validation.

Two routes over questionnaire content sent in the request body, for an editor
whose buffer may be saved nowhere yet. Neither reads a directory or a stored
document, and neither writes anything. A response's ``content_origin`` is the
label the registering service supplies for that content, so a verdict states
which copy it judged.

- ``POST /validation`` answers the validation (``validation_answer``): the
  diagram IR, the classifications and the graded findings. It runs no guard
  tree: the editor validates on every edit and the diagram opens on the spine.
- ``POST /guard-tree`` answers the guard tree (``guard_tree_answer``,
  ``core/qml_guard_tree.py``), which the diagram's Tree view asks for when it
  is shown; its solver checks are paid only then.

Each answer is a JSON body and status for one text, with no Flask in it. The
routes are the HTTP wrappers around them, and a server-rendered page that shows
the same diagram (Armiger's template diagram) calls them directly, so the
editor's diagram and that page are fed by one pipeline and one load-fault
ladder.
"""

import ast
import logging
import re
from collections.abc import Callable

import yaml
from flask import Blueprint, jsonify, request
from jsonschema import ValidationError
from werkzeug.exceptions import RequestEntityTooLarge

from askalot_qml.core import QMLLoader
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState

#: The largest request body ``POST /validation`` reads. A questionnaire is tens
#: of kilobytes; the services in front of this blueprint set no limit of their
#: own, so the route states one.
MAX_POSTED_BODY_BYTES = 1_048_576

#: A quoted fragment of a PyYAML problem that is not a ``<token class>``: text
#: the parser copied out of the file (an alias name, a tag, a stray character).
_QUOTED_FILE_TEXT = re.compile(r"'(?!<)[^']*'|\"[^\"]*\"")


def _blank_file_text(match: re.Match[str]) -> str:
    """Blank one quoted fragment unless it is a single character.

    A lone character (``'\\t'``, ``'@'``) carries none of the file's content
    and is the whole diagnosis — "found character '\\t' that cannot start any
    token" is how an author learns the line is indented with a tab. Anything
    longer (an alias or tag name) is author text and is replaced.
    """
    fragment = match.group(0)
    try:
        value = ast.literal_eval(fragment)
    except ValueError, SyntaxError:
        return "'…'"
    return fragment if isinstance(value, str) and len(value) == 1 else "'…'"


logger = logging.getLogger(__name__)


def _fault(qml_name: str, e: Exception, loader, origin: str) -> tuple[dict, int]:
    """The one answer to a load fault (#1136). ``origin`` is the copy that
    was being validated when it faulted."""
    if isinstance(e, (yaml.MarkedYAMLError, yaml.reader.ReaderError)):
        return _parse_error(qml_name, e, loader.qml_content if loader else None, origin)
    if isinstance(e, ValidationError):
        return _schema_invalid(qml_name, e, origin)
    if isinstance(e, ValueError):
        return _author_facing(e)
    return _load_fault(e)


def _schema_invalid(qml_name: str, e: ValidationError, origin: str) -> tuple[dict, int]:
    """The structured 400 for a document that fails the QML schema."""
    logger.warning(f"QML schema validation failed for {qml_name}: {e.message}")
    return {
        "qml_name": qml_name,
        "content_origin": origin,
        "valid": False,
        "validation_error": {
            "message": e.message,
            "path": list(e.absolute_path),
            "schema_path": list(e.absolute_schema_path),
        },
    }, 400


def _author_facing(e: ValueError) -> tuple[dict, int]:
    """The loader's own ``ValueError`` messages are sentences for the author
    (a reserved item id, a bad Group count), so they are returned as said."""
    logger.warning(f"QML load refused: {e}")
    return {"error": str(e)}, 400


def _load_fault(e: Exception) -> tuple[dict, int]:
    """Any other fault: LOGGED in full and not returned. A parse fault
    carries a fragment of whatever was parsed, so echoing it would quote
    the content back in a 500."""
    logger.error(f"Error analysing a questionnaire: {e}", exc_info=True)
    return {"error": "Could not analyse this questionnaire"}, 500


def _parse_error(
    qml_name: str,
    e: yaml.MarkedYAMLError | yaml.reader.ReaderError,
    content: str | None,
    origin: str,
) -> tuple[dict, int]:
    """The refusal for content that is not YAML, naming where it broke (#759).

    Carries the parser's own ``problem`` and the 1-based line and column of
    its mark, and nothing else. ``context`` and the snippet PyYAML prints
    under ``str(e)`` quote the content, which is why the catch-all returns
    no text at all. The problem text mostly names a token
    class ("expected <block end>, but found '<scalar>'"), but some problems
    quote what they found (``found undefined alias 'x'``, a stray
    character), so every quoted fragment except a ``<token class>`` or a
    single character is blanked before it leaves. A ``ReaderError`` (a
    control character the YAML reader refuses) carries no mark, only an
    offset into ``content``, which is turned into the same line and column.
    It is a 400 because the author can fix it, and the QML Explorer shows
    it in place of a bare status.
    """
    if isinstance(e, yaml.reader.ReaderError):
        problem = f"unacceptable character #x{e.character:04x}: {e.reason}"
        line = column = None
        if content is not None:
            line = content.count("\n", 0, e.position) + 1
            column = e.position - (content.rfind("\n", 0, e.position) + 1) + 1
    else:
        mark = e.problem_mark
        problem = _QUOTED_FILE_TEXT.sub(_blank_file_text, e.problem or "could not parse")
        line = mark.line + 1 if mark else None
        column = mark.column + 1 if mark else None
    logger.warning("QML is not parseable YAML (%s): %s", qml_name, problem)
    return {
        "qml_name": qml_name,
        "content_origin": origin,
        "valid": False,
        "parse_error": {"problem": problem, "line": line, "column": column},
    }, 400


def _validation_payload(
    qml_name: str, questionnaire_data: dict, origin: str, language: str | None = None
) -> dict:
    """The full validation answer for a loaded questionnaire.

    ``qml_name`` is the name echoed back (and the title's stand-in),
    ``origin`` the copy the content came from, ``language`` the
    questionnaire's language when the host knows it (``ValidationProcessor``).
    """
    # Human-readable title sourced from the QML top-level field.
    # Fallback to the filename so the client's tab title always has
    # *something* to display; this mirrors the old UUID-basename behavior.
    questionnaire_title = questionnaire_data.get("title") or qml_name

    # Create questionnaire state
    state = QMLState(questionnaire_data)

    logger.debug(f"Starting validation processing for {qml_name}")

    # Initialize ValidationProcessor
    processor = ValidationProcessor(state, language=language)

    # Get topology statistics from the engine
    topology_stats = processor.engine.get_statistics()

    # Get components information
    components = []
    for i, component in enumerate(processor.engine.topology.get_components()):
        # Order items within component by topology order
        ordered_items = [item for item in processor.engine.get_items() if item in component]
        components.append(
            {
                "component_id": i,
                "size": len(component),
                "items": ordered_items,
                "is_isolated": len(component) == 1,
            }
        )

    # Get dependency layers
    layers = processor.engine.topology.get_dependency_layers()
    dependency_layers = []
    for i, layer in enumerate(layers):
        dependency_layers.append({"layer": i, "items": sorted(layer), "count": len(layer)})

    # Generate positions-free structural IR with classifications inlined.
    # Layout runs client-side in the QML Explorer React webview (ELK.js).
    graph_data = processor.generate_validation_graph(enable_z3_validation=True)

    # Get per-item Z3 classifications (already computed by generate_validation_graph)
    classifications = processor.get_item_classifications()
    item_classifications = {
        item_id: {
            "precondition": c.get("precondition", {}).get("status", "UNKNOWN"),
            "postcondition": c.get("postcondition", {}).get("invariant", "UNKNOWN"),
        }
        for item_id, c in classifications.items()
    }

    # Generate comprehensive validation report
    validation_report = processor.generate_validation_report()

    # The graded findings themselves (#728). The diagram's two Z3 axes
    # colour three of the twenty finding types; without this list the
    # other seventeen would render as a healthy diagram to the author,
    # while the MCP tool and the publish gate both see them.
    #
    # `deep` stays at its default. Level 4 accumulated dead code is
    # O(items^2) solver work and this is the interactive edit-validate
    # loop, not the gate; the gate passes deep=True on its own path.
    validation_issues = processor.to_issues()

    logger.debug(f"Validation completed for {qml_name}")

    return {
        "qml_name": qml_name,
        "content_origin": origin,
        "questionnaire_title": questionnaire_title,
        "topology_stats": topology_stats,
        "components": components,
        "dependency_layers": dependency_layers,
        "graph_data": graph_data,
        "item_classifications": item_classifications,
        "validation_report": validation_report,
        "validation_issues": validation_issues,
    }


def guard_tree_answer(content: str, name: str, *, content_origin: str) -> tuple[dict, int]:
    """The guard tree of one questionnaire text: the body and status ``POST /guard-tree`` answers.

    ``(body, 200)`` with ``qml_name``, ``content_origin`` and ``guard_tree``
    (``ValidationProcessor.get_guard_tree``: the tree, or ``{"error": ...}``
    when it could not be built), or the load fault's body and status from the
    one ladder ``validation_answer`` uses.
    """
    loader = QMLLoader(logger=logger)
    try:
        processor = ValidationProcessor(QMLState(loader.load_from_string(content)))
        return {
            "qml_name": name,
            "content_origin": content_origin,
            "guard_tree": processor.get_guard_tree(),
        }, 200
    except Exception as e:
        return _fault(name, e, loader, content_origin)


def validation_answer(
    content: str, name: str, *, content_origin: str, language: str | None = None
) -> tuple[dict, int]:
    """Validate one questionnaire text: the JSON body and HTTP status ``POST /validation`` answers.

    Args:
        content: The questionnaire's QML text.
        name: Display name, echoed as ``qml_name`` and used as the title when
            the questionnaire states none. It addresses nothing.
        content_origin: The ``content_origin`` the answer reports, so a
            verdict states which copy it judged.
        language: The questionnaire's language when the host knows it; an
            "other" one reports ``language_not_judged`` in place of the
            word-list lints (``ValidationProcessor``).

    Returns:
        ``(body, 200)`` with the validation payload (``_validation_payload``:
        the name, ``content_origin``, title, topology statistics, components,
        dependency layers, the diagram IR, per-item Z3 classifications, the
        text report and the graded ``validation_issues``), or a load fault's
        body and status from the one ladder (``_fault``): a 400 for content
        the author can fix, a 500 that quotes nothing for anything else.
    """
    loader = QMLLoader(logger=logger)
    try:
        questionnaire_data = loader.load_from_string(content)
        return _validation_payload(name, questionnaire_data, content_origin, language), 200
    except Exception as e:
        return _fault(name, e, loader, content_origin)


def create_validation_blueprint(
    url_prefix: str = "/api/qml",
    *,
    posted_content_origin: str,
    language_of: Callable[[dict], str | None] | None = None,
) -> Blueprint:
    """
    Create the QML validation API blueprint.

    Args:
        url_prefix: URL prefix for the blueprint
        posted_content_origin: The ``content_origin`` reported for content
                               validated from a request body. Required: a
                               verdict states which copy it judged.
        language_of: The host's reading of the questionnaire's language from
                     the posted body (Armiger reads ``questionnaire_id``
                     through its repository), or ``None`` when it states none.
                     This module reads no stored row itself.

    Returns:
        Flask blueprint with the validation endpoint
    """
    blueprint = Blueprint("qml_validation", __name__, url_prefix=url_prefix)

    def _posted() -> tuple[dict | None, tuple | None]:
        """The posted ``content`` and ``name``, or the refusal to answer instead."""
        # Bounds the read itself, so a body sent without a Content-Length
        # is cut off at the cap too.
        request.max_content_length = MAX_POSTED_BODY_BYTES
        try:
            body = request.get_json(silent=True)
        except RequestEntityTooLarge:
            return None, (
                jsonify(
                    {
                        "error": "too_large",
                        "detail": f"The request body exceeds {MAX_POSTED_BODY_BYTES} bytes.",
                    }
                ),
                413,
            )
        if not isinstance(body, dict):
            body = {}
        for field in ("content", "name"):
            value = body.get(field)
            if not isinstance(value, str) or not value.strip():
                return None, (
                    jsonify(
                        {
                            "error": f"{field}_required",
                            "detail": f"The JSON body must carry a non-empty string {field!r}.",
                        }
                    ),
                    400,
                )
        return body, None

    @blueprint.route("/validation", methods=["POST"])
    def post_validation():
        """
        Validate QML content sent in the request body.

        JSON body:
            content: The questionnaire's QML text
            name: Display name, echoed as ``qml_name`` and used as the title
                  when the questionnaire states none. It addresses nothing.
            Any other field is the host's: ``language_of`` reads it (Armiger's
            reads ``questionnaire_id``).

        Returns:
            JSON with the validation payload (``validation_answer``: the
            name, ``content_origin``, title, topology statistics, components,
            dependency layers, the diagram IR, per-item Z3 classifications,
            the text report and the graded ``validation_issues``). A body over
            ``MAX_POSTED_BODY_BYTES`` is refused with 413 ``too_large``
            before any of it is parsed, a body without ``content`` or
            ``name`` with a 400 naming the field.
        """
        body, refusal = _posted()
        if refusal is not None:
            return refusal
        answer, status = validation_answer(
            body["content"],
            body["name"],
            content_origin=posted_content_origin,
            language=language_of(body) if language_of is not None else None,
        )
        return jsonify(answer), status

    @blueprint.route("/guard-tree", methods=["POST"])
    def post_guard_tree():
        """
        The guard tree of QML content sent in the request body
        (``guard_tree_answer``), for the diagram's Tree view. The body and its
        refusals are ``POST /validation``'s.
        """
        body, refusal = _posted()
        if refusal is not None:
            return refusal
        answer, status = guard_tree_answer(
            body["content"], body["name"], content_origin=posted_content_origin
        )
        return jsonify(answer), status

    return blueprint
