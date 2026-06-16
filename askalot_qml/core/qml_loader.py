"""Modern QML file loader with type safety and no Flask dependencies."""

import ast
import json
import logging
import os
from pathlib import Path
from typing import Any

import yaml
from jsonschema import ValidationError, validate


def _is_power_of_two(value: Any) -> bool:
    """
    True iff value is a positive integer that is a power of 2 (1, 2, 4, 8, …).

    Used by Roster block label validation and Checkbox label-key tightening.
    The bit-trick `n & (n - 1) == 0` matches all powers of 2 (including
    edge cases like 1 = 2**0); the `n > 0` guard rejects 0 and negatives.
    """
    return (
        isinstance(value, int)
        and not isinstance(value, bool)
        and value > 0
        and (value & (value - 1)) == 0
    )


def _ast_referenced_names(expression: str) -> set[str]:
    """
    Walk a Python expression AST and return the set of bare names AND
    `<name>.outcome` / `<name>.outcomes` attribute targets it references.

    Used by Roster self-cycle validation: an iterateOver expression must
    not reference any item that lives inside the same Roster block.

    Returns the empty set if the expression cannot be parsed (defensive —
    runtime eval will surface the syntax error with a clearer message).
    """
    try:
        tree = ast.parse(expression, mode="eval")
    except SyntaxError:
        return set()

    names: set[str] = set()
    for node in ast.walk(tree):
        if isinstance(node, ast.Name):
            names.add(node.id)
        elif isinstance(node, ast.Attribute) and isinstance(node.value, ast.Name):
            # Capture the base name of `q_foo.outcome` / `q_foo.outcomes` etc.
            names.add(node.value.id)
    return names


_UNSET = object()


class QMLLoader:
    """
    Load and parse QML files into dictionary structures.

    Modern implementation without Flask dependencies, using pathlib
    and comprehensive type hints.

    Environment Variables:
        ORGANIZATIONS_DIR: Root directory containing organization data
    """

    def __init__(
        self,
        qml_dir: str | Path | None = None,
        schema_path: str | Path | None = _UNSET,
        logger: logging.Logger | None = None,
    ):
        """
        Initialize QML loader.

        Args:
            qml_dir: Directory containing QML files. Falls back to ORGANIZATIONS_DIR env var.
            schema_path: Omit to use the bundled schema from askalot_qml.
                         Pass None to disable schema validation.
                         Pass a Path to use a custom schema.
            logger: Optional logger instance
        """
        self.logger = logger or logging.getLogger(__name__)
        self.qml_dir = Path(qml_dir) if qml_dir else self._get_qml_dir_from_env()

        if schema_path is _UNSET:
            from askalot_qml.schema import SCHEMA_PATH

            self.schema_path = SCHEMA_PATH
        elif schema_path is None:
            self.schema_path = None
        else:
            self.schema_path = Path(schema_path)

        self.qml_content: str | None = None
        self.parsed_yaml: dict[str, Any] | None = None

        self.logger.info(
            f"QMLLoader initialized with qml_dir={self.qml_dir}, schema_path={self.schema_path}"
        )

    def _get_qml_dir_from_env(self) -> Path:
        """Get QML directory from ORGANIZATIONS_DIR environment variable."""
        qml_dir = os.environ.get("ORGANIZATIONS_DIR")
        if qml_dir:
            return Path(qml_dir)
        self.logger.warning("ORGANIZATIONS_DIR environment variable not set")
        return Path("data/organizations")

    def load_from_file(self, filename: str) -> dict[str, Any]:
        """
        Load and parse QML file.

        Args:
            filename: Name of QML file (relative to qml_dir)

        Returns:
            Parsed questionnaire dictionary

        Raises:
            FileNotFoundError: If file doesn't exist
            ValidationError: If QML doesn't match schema
        """
        file_path = self.qml_dir / filename
        return self.load_from_path(file_path)

    def load_from_path(self, file_path: str | Path) -> dict[str, Any]:
        """
        Load and parse QML from absolute path.

        Args:
            file_path: Full path to QML file

        Returns:
            Parsed questionnaire dictionary

        Raises:
            FileNotFoundError: If file doesn't exist
            ValidationError: If QML doesn't match schema
        """
        file_path = Path(file_path)

        if not file_path.exists():
            raise FileNotFoundError(f"QML file not found: {file_path}")

        # Load file content
        self.qml_content = file_path.read_text(encoding="utf-8")
        self.logger.info(f"Loaded QML file: {file_path}")

        # Parse YAML
        self.parsed_yaml = yaml.safe_load(self.qml_content)

        # Normalize predicates BEFORE schema validation
        # This allows QML authors to use bare True/False without quotes
        if "questionnaire" in self.parsed_yaml:
            self._normalize_all_predicates(self.parsed_yaml["questionnaire"])

        # Validate against schema if available
        if self.schema_path and self.schema_path.exists():
            self._validate_against_schema()
        else:
            self.logger.debug("Schema validation skipped (no schema available)")

        # Return questionnaire section
        if "questionnaire" not in self.parsed_yaml:
            raise ValueError("QML file must contain 'questionnaire' section")

        # Loader-level validation that JSON Schema can't express cleanly
        # (mandatory kind + reserved-kind rejection; power-of-2 label keys on
        # Roster + Checkbox; iterateOver self-cycle).
        self._validate_block_kinds(self.parsed_yaml["questionnaire"])
        self._validate_roster_and_checkbox_constraints(self.parsed_yaml["questionnaire"])

        # Flatten the structure before returning
        return self._flatten_questionnaire_structure(self.parsed_yaml["questionnaire"])

    def load_from_string(self, qml_content: str) -> dict[str, Any]:
        """
        Load and parse QML from string content.

        Args:
            qml_content: QML YAML content as string

        Returns:
            Parsed questionnaire dictionary

        Raises:
            ValidationError: If QML doesn't match schema
        """
        self.qml_content = qml_content
        self.parsed_yaml = yaml.safe_load(qml_content)

        # Normalize predicates BEFORE schema validation
        # This allows QML authors to use bare True/False without quotes
        if "questionnaire" in self.parsed_yaml:
            self._normalize_all_predicates(self.parsed_yaml["questionnaire"])

        # Validate against schema if available
        if self.schema_path and self.schema_path.exists():
            self._validate_against_schema()

        if "questionnaire" not in self.parsed_yaml:
            raise ValueError("QML content must contain 'questionnaire' section")

        # Loader-level validation that JSON Schema can't express cleanly
        self._validate_block_kinds(self.parsed_yaml["questionnaire"])
        self._validate_roster_and_checkbox_constraints(self.parsed_yaml["questionnaire"])

        # Flatten the structure before returning
        return self._flatten_questionnaire_structure(self.parsed_yaml["questionnaire"])

    def _validate_against_schema(self) -> None:
        """
        Validate loaded QML against JSON schema.

        Raises:
            ValidationError: If validation fails
        """
        if not self.parsed_yaml:
            raise ValueError("No QML content loaded")

        if not self.schema_path or not self.schema_path.exists():
            self.logger.warning(f"Schema file not found: {self.schema_path}")
            return

        # Load schema
        with open(self.schema_path, encoding="utf-8") as schema_file:
            schema = json.load(schema_file)

        try:
            validate(instance=self.parsed_yaml, schema=schema)
            self.logger.info("QML validation successful")
        except ValidationError as e:
            self.logger.error(f"QML validation failed: {e}")
            raise

    def list_available_files(self) -> list[str]:
        """
        List all available QML files in qml_dir.

        Returns:
            Sorted list of QML filenames
        """
        if not self.qml_dir.exists():
            self.logger.warning(f"QML directory does not exist: {self.qml_dir}")
            return []

        qml_files = [f.name for f in self.qml_dir.glob("*.qml")]
        self.logger.info(f"Found {len(qml_files)} QML files")

        return sorted(qml_files)

    def get_file_path(self, filename: str) -> Path:
        """
        Get full path for a QML file.

        Args:
            filename: QML filename

        Returns:
            Full path to file
        """
        return self.qml_dir / filename

    # Recognized block kinds, all wired into the engine:
    #   - 'Sequence': visit inner items once in declared/topological order.
    #   - 'Roster':   repeat inner items per set bit in an `iterateOver` bitmask.
    #   - 'Sample':   ask up to `count` (N) inner items from the eligible pool;
    #                 `is_random` (default false) toggles canonical vs.
    #                 per-execution randomised order.
    # No reserved-future kinds remain — `Random` was never a kind (randomisation
    # is the Sample `is_random` flag, not a separate kind).
    SUPPORTED_BLOCK_KINDS = ("Sequence", "Roster", "Sample")
    RESERVED_BLOCK_KINDS = ()

    def _validate_block_kinds(self, questionnaire: dict[str, Any]) -> None:
        """
        Enforce that every block declares a `kind` and that the kind is one the
        loader actually supports. JSON schema makes `kind` mandatory and
        restricts the enum; this is defence-in-depth for callers that bypass
        schema validation (``schema_path=None``).

        The reserved-kind branch is retained for forward safety — if a future
        kind is added to the schema enum before the engine wires it, listing it
        in ``RESERVED_BLOCK_KINDS`` makes the loader reject it loudly instead of
        silently treating it as Sequence. ``RESERVED_BLOCK_KINDS`` is currently
        empty (Sequence, Roster, and Sample are all wired).

        Raises:
            ValueError: when `kind` is missing or unknown.
            NotImplementedError: when `kind` is a reserved-future literal.
        """
        for block in questionnaire.get("blocks", []):
            block_id = block.get("id", "<unknown>")
            kind = block.get("kind")
            if kind is None:
                raise ValueError(
                    f"Block '{block_id}': 'kind' is required. Use one of "
                    f"{list(self.SUPPORTED_BLOCK_KINDS)}."
                )
            if kind in self.RESERVED_BLOCK_KINDS:
                raise NotImplementedError(
                    f"Block '{block_id}': kind '{kind}' is reserved for a future "
                    f"flow mode and is not yet implemented. Use one of "
                    f"{list(self.SUPPORTED_BLOCK_KINDS)}."
                )
            if kind not in self.SUPPORTED_BLOCK_KINDS:
                # Schema enum should already have caught this, but defend in
                # depth for callers that bypass schema validation.
                raise ValueError(
                    f"Block '{block_id}': unknown kind {kind!r}. Allowed: "
                    f"{list(self.SUPPORTED_BLOCK_KINDS + self.RESERVED_BLOCK_KINDS)}."
                )

    def _validate_roster_and_checkbox_constraints(self, questionnaire: dict[str, Any]) -> None:
        """
        Enforce loader-level invariants the JSON schema cannot express cleanly:

        1. Roster `labels` keys must be positive powers of 2 (1, 2, 4, 8, …).
           This is the universe of possible iterations; the bitmask design relies
           on each key being a unique bit position.
        2. Checkbox `input.labels` keys must be positive powers of 2 (forward-tightening
           — see plan 2026-05-04-001 Key Technical Decisions). Aligns Checkbox
           outcome (sum of selected keys = bitmask integer) with Roster
           iterateOver, so a Checkbox outcome flows directly into a sibling
           Roster with no decode codeBlock.
        3. Roster `iterateOver` expression must NOT reference any item id that
           lives inside the same Roster — that would be a self-cycle that
           topology cycle-tolerance cannot reason about (it would produce vacuous
           SAT or silent INFEASIBLE in Z3 classification).
        4. Sample `count` (N) must be a positive integer literal. The JSON
           schema's `minimum: 1` only fires for genuine integers; YAML may parse
           a quoted/expression value as a string, so we re-validate here and
           fail loud — there is NO silent default for a missing/invalid count
           (monorepo "No Silent Fallbacks" rule). `count` only ever flows from
           the loader as an integer; runtime "ask up to N" semantics (asking
           fewer when the pool exhausts) are a U5 concern, not a load-time one.

        Args:
            questionnaire: Nested questionnaire dictionary (pre-flatten)

        Raises:
            ValueError: with a clear, author-actionable error message
        """
        for block in questionnaire.get("blocks", []):
            block_id = block.get("id", "<unknown>")
            kind = block.get("kind")

            # Rule 1 + 3 — Roster-specific constraints.
            if kind == "Roster":
                labels = block.get("labels") or {}
                for key in labels.keys():
                    if not _is_power_of_two(key):
                        raise ValueError(
                            f"Roster block '{block_id}': label key {key!r} is not a positive "
                            f"power of 2. Allowed keys: 1, 2, 4, 8, 16, 32, ... "
                            f"(each iteration corresponds to one bit position in iterateOver)."
                        )

                iterate_over = block.get("iterateOver", "")
                inner_item_ids = {
                    item.get("id") for item in block.get("items", []) if item.get("id")
                }
                referenced = _ast_referenced_names(iterate_over)
                self_refs = referenced & inner_item_ids
                if self_refs:
                    raise ValueError(
                        f"Roster block '{block_id}': iterateOver expression references inner item(s) "
                        f"{sorted(self_refs)!r}. iterateOver must depend on items OUTSIDE the roster — "
                        f"a self-reference creates a cycle that static analysis cannot resolve."
                    )

            # Rule 4 — Sample count must be a positive integer literal.
            # `0`/negatives/non-int/missing all fail loud here so a malformed
            # Sample never silently behaves like a 0-draw or full Sequence.
            # bool is an int subclass in Python (and YAML `true` → True), so it
            # is rejected explicitly — `count: true` is an authoring error.
            if kind == "Sample":
                count = block.get("count")
                if count is None:
                    raise ValueError(
                        f"Sample block '{block_id}': 'count' is required (the N in "
                        f"'ask up to N items'). There is no default — declare an "
                        f"explicit positive integer."
                    )
                if isinstance(count, bool) or not isinstance(count, int) or count < 1:
                    raise ValueError(
                        f"Sample block '{block_id}': 'count' must be a positive "
                        f"integer (got {count!r}). N is the number of inner items "
                        f"to ask; it cannot be zero, negative, or a non-integer."
                    )

            # Rule 2 — Checkbox label-key tightening on every item, regardless of block kind.
            for item in block.get("items", []):
                input_spec = item.get("input") or {}
                if input_spec.get("control") != "Checkbox":
                    continue
                checkbox_labels = input_spec.get("labels") or {}
                item_id = item.get("id", "<unknown>")
                for key in checkbox_labels.keys():
                    if not _is_power_of_two(key):
                        raise ValueError(
                            f"Checkbox control '{item_id}': label key {key!r} is not a positive "
                            f"power of 2. Allowed keys: 1, 2, 4, 8, 16, 32, ... "
                            f"(Checkbox outcome is the bitmask sum of selected keys, so each "
                            f"key must occupy a unique bit position)."
                        )

    def _normalize_all_predicates(self, questionnaire: dict[str, Any]) -> None:
        """
        Normalize predicates in the nested questionnaire structure (before flattening).

        This method walks through the nested block/item structure and normalizes
        all predicates BEFORE schema validation. This allows QML authors to write
        bare boolean/numeric predicates (like `predicate: True`) without quotes.

        Normalizes both block-level and item-level predicates.

        Args:
            questionnaire: Nested questionnaire dictionary (modified in place)
        """
        for block in questionnaire.get("blocks", []):
            # Normalize block-level predicates
            self._normalize_predicates(block)
            for item in block.get("items", []):
                self._normalize_predicates(item)

    def _flatten_questionnaire_structure(self, questionnaire: dict[str, Any]) -> dict[str, Any]:
        """
        Flatten the nested block/item structure to a flat list of items.

        Transforms from:
            blocks: [{id: 'b1', items: [{id: 'q1', ...}, ...]}, ...]

        To:
            blocks: [{id: 'b1', ...}]  # Just block metadata
            items: [{id: 'q1', blockId: 'b1', ...}, ...]  # Flat list with blockId

        Args:
            questionnaire: Original questionnaire dictionary with nested structure

        Returns:
            Questionnaire dictionary with flat item structure
        """
        # Create a copy to avoid modifying the original
        result = dict(questionnaire)

        # Extract and flatten items
        flat_items = []
        flat_blocks = []

        for block in questionnaire.get("blocks", []):
            # Create block metadata without items
            block_metadata = {k: v for k, v in block.items() if k != "items"}
            flat_blocks.append(block_metadata)

            for item in block.get("items", []):
                item_with_block = dict(item)
                item_with_block["blockId"] = block["id"]
                self._propagate_block_inheritance(item_with_block, block)
                self._normalize_predicates(item_with_block)
                flat_items.append(item_with_block)

        # Update the result with flat structure
        result["blocks"] = flat_blocks
        result["items"] = flat_items

        self.logger.debug(
            f"Flattened questionnaire: {len(flat_blocks)} blocks, {len(flat_items)} items"
        )

        return result

    def _propagate_block_inheritance(self, item: dict[str, Any], block: dict[str, Any]) -> None:
        """
        Propagate block-level metadata onto a child item during flattening.

        Block-level pre/postconditions are intentionally NOT copied onto items
        anymore (R25, 2026-05-14). The block's ``precondition`` and
        ``postcondition`` lists stay where the author wrote them — on the
        block object. Downstream consumers compose block + item at evaluation
        time:

          - ``FlowProcessor`` walks ``(block.precondition or []) +
            (item.precondition or [])`` when gating an item.
          - ``StaticBuilder`` does the same when emitting Z3 constraints.
          - ``qml_diagram_ir`` renders block chiclets on the block and item
            chiclets on the item — no de-duplication required.

        The only thing this method still propagates is block-kind metadata:

          - Inner items in a ``Roster`` block get ``_roster_block_id``,
            ``_roster_iterate_over``, and ``_roster_labels``.
          - Inner items in a ``Sample`` block get ``_sample_block_id``,
            ``_sample_n``, and ``_sample_is_random``.

        so FlowProcessor / Z3 / Bronze schema build can detect roster/sample
        items without re-walking the block tree. ``Sequence`` blocks add
        nothing. The two branches are mutually exclusive (a block has exactly
        one kind), so no item ever carries both tag families.

        Mutates ``item`` in place; the caller is responsible for cloning
        before calling if isolation is required.
        """
        kind = block.get("kind")
        # Roster metadata propagation. Additive — non-roster items unaffected.
        if kind == "Roster":
            item["_roster_block_id"] = block["id"]
            item["_roster_iterate_over"] = block.get("iterateOver", "")
            item["_roster_labels"] = block.get("labels", {})
        # Sample metadata propagation, mirroring the Roster branch. `count` is
        # already loud-validated as a positive int by
        # `_validate_roster_and_checkbox_constraints`, so `block["count"]` is a
        # safe direct index (no `.get` default — that would reintroduce a
        # silent fallback). `is_random` is schema-optional → default False.
        elif kind == "Sample":
            item["_sample_block_id"] = block["id"]
            item["_sample_n"] = block["count"]
            item["_sample_is_random"] = bool(block.get("is_random", False))

    def _normalize_predicates(self, item: dict[str, Any]) -> None:
        """
        Normalize predicates in preconditions and postconditions.

        YAML parses certain values as non-string types, but predicates must be
        strings for ast.parse() in the Python runner. This method converts
        scalar predicates to their string representation.

        Supported conversions:
        - bool: True/False → "True"/"False"
        - int: 123 → "123"
        - float: 1.5 → "1.5"

        Complex types (list, dict) raise ValueError as they likely indicate
        a QML authoring error.

        Args:
            item: Item dictionary to normalize (modified in place)

        Raises:
            ValueError: If predicate is a complex type (list, dict)
        """
        for condition_key in ("precondition", "postcondition"):
            conditions = item.get(condition_key)
            if conditions:
                for condition in conditions:
                    predicate = condition.get("predicate")
                    if predicate is None:
                        continue
                    if isinstance(predicate, str):
                        continue
                    if isinstance(predicate, (bool, int, float)):
                        condition["predicate"] = str(predicate)
                        self.logger.debug(
                            f"Normalized {type(predicate).__name__} predicate in "
                            f"{item.get('id', 'unknown')}.{condition_key}: "
                            f"{predicate!r} -> '{condition['predicate']}'"
                        )
                    else:
                        raise ValueError(
                            f"Invalid predicate type in {item.get('id', 'unknown')}.{condition_key}: "
                            f"expected string or scalar, got {type(predicate).__name__}: {predicate!r}"
                        )
