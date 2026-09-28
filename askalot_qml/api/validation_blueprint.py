"""Validation API blueprint for QML processing and validation.

``qml_name`` on these routes is a path relative to the blueprint's QML
directory — on Armiger, the caller's workspace — and NOT the document address
``projects/<project_id>/questionnaires/<questionnaire_id>.qml`` that every
other surface hands out (#415). The two share a parameter name, so a document
address that misses here is refused with a 400 that names the two address
spaces, rather than a 404 that reads as "that questionnaire does not exist".
The response's ``content_origin`` says which copy was validated.
"""

import ast
import logging
import re
from collections.abc import Callable
from pathlib import Path

import yaml
from flask import Blueprint, jsonify, request
from jsonschema import ValidationError

from askalot_qml.core import QMLLoader
from askalot_qml.core.qml_source import CANONICAL_QML_REL_PATH
from askalot_qml.core.validation_processor import ValidationProcessor
from askalot_qml.models.qml_state import QMLState

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


def create_validation_blueprint(
    qml_dir: str | Path | None = None,
    url_prefix: str = "/api/qml",
    qml_dir_resolver: Callable[[], str | Path | None] | None = None,
    *,
    content_origin: str,
) -> Blueprint:
    """
    Create QML validation API blueprint.

    Args:
        qml_dir: Static directory containing QML files (used if qml_dir_resolver not provided)
        url_prefix: URL prefix for the blueprint
        qml_dir_resolver: Optional callable that returns the QML directory based on request context.
                          Called per-request to support organization-scoped QML paths.
                          If provided, takes precedence over static qml_dir.
        content_origin: Required. Which copy of the questionnaire the directory holds, echoed
                        on every validation response so a verdict states its
                        provenance. Armiger passes ``"workspace"``: the editor's
                        copy, which can differ from the promoted document head.

    Returns:
        Flask blueprint with validation endpoints
    """
    blueprint = Blueprint("qml_validation", __name__, url_prefix=url_prefix)
    logger = logging.getLogger(__name__)

    def _get_loader() -> QMLLoader:
        """Build the request's QML loader over the resolved directory.

        A resolver that returns None means "I could not tell which tree this
        request is about" — that is a bad request, not a directory to guess.
        The loader itself refuses a name it cannot resolve; raising here makes
        the refusal say *why* instead of surfacing as a missing file.
        """
        resolved_qml_dir = qml_dir_resolver() if qml_dir_resolver else qml_dir
        if resolved_qml_dir is None:
            raise ValueError(
                "No QML directory for this request — the caller could not be "
                "resolved to a workspace."
            )
        return QMLLoader(qml_dir=resolved_qml_dir, logger=logger)

    def _not_found(qml_name: str):
        """The refusal for a name the directory does not hold.

        A document address cannot be a path here, so it gets a 400 naming both
        address spaces; anything else is an ordinary missing file.
        """
        if CANONICAL_QML_REL_PATH.match(qml_name):
            # A caller mistake, not a server fault: warning, not error.
            logger.warning("QML document address sent as a %s path: %s", content_origin, qml_name)
            return jsonify(
                {
                    "error": "qml_name_is_a_document_address",
                    "detail": (
                        f"{qml_name!r} is a questionnaire document address, but this "
                        f"endpoint validates the {content_origin} copy by its path "
                        "relative to that directory. Pass the path, or validate the "
                        "document itself with the validate_qml_file MCP tool."
                    ),
                }
            ), 400
        logger.error(f"QML file not found: {qml_name}")
        return jsonify({"error": f"QML file not found: {qml_name}"}), 404

    def _parse_error(
        qml_name: str, e: yaml.MarkedYAMLError | yaml.reader.ReaderError, content: str | None
    ):
        """The refusal for a file that is not YAML, naming where it broke (#759).

        Carries the parser's own ``problem`` and the 1-based line and column of
        its mark, and nothing else. ``context`` and the snippet PyYAML prints
        under ``str(e)`` quote the file, which is why ``/validation``'s
        catch-all returns no text at all. The problem text mostly names a token
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
        return jsonify(
            {
                "qml_name": qml_name,
                "content_origin": content_origin,
                "valid": False,
                "parse_error": {"problem": problem, "line": line, "column": column},
            }
        ), 400

    @blueprint.route("/validation", methods=["GET"])
    def get_validation():
        """
        Get validation for a QML file using the topology-based approach.

        Query parameters:
            qml_name: Path of the QML file relative to the QML directory (on
                      Armiger, the workspace path — not a document address)

        Returns:
            JSON with validation data including:
            - qml_name: The path as given
            - content_origin: Which copy was validated (Armiger: "workspace")
            - questionnaire_title: Human-readable title from the QML top-level
                                    `questionnaire.title` YAML field (falls back
                                    to qml_name when the field is missing)
            - topology_stats: Dependency graph statistics
            - components: Connected components information
            - dependency_layers: Items grouped by dependency depth
            - graph_data: Positions-free structural IR with typed top-level
                          arrays (blocks, items, conditions, variables, edges).
                          Consumed by the QML Explorer React webview; layout
                          is computed client-side via ELK.js.
            - item_classifications: Per-item Z3 precondition/postcondition status
            - validation_report: Comprehensive text report of questionnaire structure
        """
        try:
            qml_name = request.args.get("qml_name")
            if not qml_name:
                return jsonify({"error": "qml_name parameter is required"}), 400

            # Load questionnaire
            loader = _get_loader()
            questionnaire_data = loader.load_from_file(qml_name)

            # Human-readable title sourced from the QML top-level field.
            # Fallback to the filename so the client's tab title always has
            # *something* to display; this mirrors the old UUID-basename behavior.
            questionnaire_title = questionnaire_data.get("title") or qml_name

            # Create questionnaire state
            state = QMLState(questionnaire_data)

            logger.debug(f"Starting validation processing for {qml_name}")

            # Initialize ValidationProcessor
            processor = ValidationProcessor(state)

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

            # The graded findings themselves (#728). Until now this endpoint
            # returned the two Z3 axes and a text summary, so a human editing
            # QML in code-server could see three of the twenty finding types —
            # the three that happen to get a colour — and the other seventeen
            # rendered as a healthy diagram. The MCP tool and the publish gate
            # both had them; the author did not.
            #
            # `deep` stays at its default. Level 4 accumulated dead code is
            # O(items^2) solver work and this is the interactive edit-validate
            # loop, not the gate; the gate passes deep=True on its own path.
            validation_issues = processor.to_issues()

            logger.debug(f"Validation completed for {qml_name}")

            return jsonify(
                {
                    "qml_name": qml_name,
                    "content_origin": content_origin,
                    "questionnaire_title": questionnaire_title,
                    "topology_stats": topology_stats,
                    "components": components,
                    "dependency_layers": dependency_layers,
                    "graph_data": graph_data,
                    "item_classifications": item_classifications,
                    "validation_report": validation_report,
                    "validation_issues": validation_issues,
                }
            ), 200

        except FileNotFoundError:
            return _not_found(qml_name)
        except (yaml.MarkedYAMLError, yaml.reader.ReaderError) as e:
            return _parse_error(qml_name, e, loader.qml_content)
        except ValidationError as e:
            logger.warning(f"QML schema validation failed for {qml_name}: {e.message}")
            return jsonify(
                {
                    "qml_name": qml_name,
                    "content_origin": content_origin,
                    "valid": False,
                    "validation_error": {
                        "message": e.message,
                        "path": list(e.absolute_path),
                        "schema_path": list(e.absolute_schema_path),
                    },
                }
            ), 400
        except ValueError as e:
            logger.warning(f"Cannot resolve a QML source for this request: {e}")
            return jsonify({"error": str(e)}), 400
        except Exception as e:
            # The message is LOGGED in full and not returned. A loader fault
            # carries the offending path, and a parse fault carries a fragment
            # of whatever was parsed — so echoing it turned a 500 into a read
            # of the file the caller named ("'str' object has no attribute
            # 'get'" for a one-line text file) and into an existence oracle
            # (500 for a file that is there, 404 for one that is not).
            logger.error(f"Error generating validation: {e}", exc_info=True)
            return jsonify({"error": "Could not analyse this questionnaire"}), 500

    @blueprint.route("/validate", methods=["GET"])
    def validate_qml():
        """
        Validate QML file against schema.

        Query parameters:
            qml_name: Path of the QML file relative to the QML directory (on
                      Armiger, the workspace path — not a document address)

        Returns:
            JSON with validation result
        """
        try:
            qml_name = request.args.get("qml_name")
            if not qml_name:
                return jsonify({"error": "qml_name parameter is required"}), 400

            # Load and validate
            loader = _get_loader()
            loader.load_from_file(qml_name)

            return jsonify(
                {
                    "qml_name": qml_name,
                    "content_origin": content_origin,
                    "valid": True,
                    "message": "QML validation successful",
                }
            ), 200

        except FileNotFoundError:
            return _not_found(qml_name)
        except (yaml.MarkedYAMLError, yaml.reader.ReaderError) as e:
            return _parse_error(qml_name, e, loader.qml_content)
        except Exception as e:
            logger.error(f"QML validation failed: {e}")
            return jsonify(
                {"qml_name": qml_name, "content_origin": content_origin, "valid": False, "error": str(e)}
            ), 400

    @blueprint.route("/files", methods=["GET"])
    def list_files():
        """
        List available QML files.

        Returns:
            JSON with list of QML filenames
        """
        try:
            loader = _get_loader()
            files = loader.list_available_files()

            return jsonify({"files": files, "count": len(files)}), 200

        except ValueError as e:
            logger.warning(f"Cannot resolve a QML source for this request: {e}")
            return jsonify({"error": str(e)}), 400
        except Exception as e:
            # Logged, not returned — same reason as the validation route above.
            logger.error(f"Error listing QML files: {e}", exc_info=True)
            return jsonify({"error": "Could not list questionnaires"}), 500

    return blueprint
