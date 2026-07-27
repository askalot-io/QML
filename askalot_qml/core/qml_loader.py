"""Modern QML file loader with type safety and no Flask dependencies."""

import ast
import json
import logging
import re
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


def _ast_referenced_names(expression: str, mode: str = "eval") -> set[str]:
    """
    Walk a Python AST and return the set of bare names AND
    `<name>.outcome` / `<name>.outcomes` attribute bases it references.

    ``mode`` selects the parse mode (``ast.parse(expression, mode=mode)``):

    - ``"eval"`` (default) for a single-expression predicate — Roster
      self-cycle validation: an iterateOver expression must not reference any
      item inside the same Roster block.
    - ``"exec"`` for a multi-statement codeBlock body — the capped-Group
      independence check, where a sibling reference may be a read OR a write
      target (``sibling.outcome = …``); ``ast.Name`` / ``ast.Attribute`` walking
      captures both load and store contexts uniformly. The eval-only mode would
      raise on a statement body and silently return nothing.

    Returns the empty set if the source cannot be parsed (defensive — runtime
    eval / the runner will surface the syntax error with a clearer message).
    """
    try:
        tree = ast.parse(expression, mode=mode)
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
    Load and parse QML documents into dictionary structures.

    Modern implementation without Flask dependencies, using pathlib
    and comprehensive type hints.

    Where the bytes come from is a seam. Pass ``content_source`` (a
    ``askalot_qml.core.qml_source.QMLContentSource`` — in production the
    document-store-backed ``RepositoryQMLSource``) and ``load_from_file`` /
    ``list_available_files`` resolve names through it instead of the
    filesystem. Everything above the load call — parse, schema validation,
    kind/reserved-id checks, flattening — is identical either way, so a caller
    swapping storage changes one constructor argument and nothing else. Without
    a source the loader reads ``qml_dir``; that path serves fixtures, the CLI,
    and Armiger's ephemeral workspace trees, which are real files by design.

    There is no environment-derived default for ``qml_dir``. A caller that
    resolves names by path knows which tree it means (a workspace, a fixture
    directory), and inventing a plausible-looking one for a caller that did not
    say would silently resolve into a directory holding no QML at all.
    """

    def __init__(
        self,
        qml_dir: str | Path | None = None,
        schema_path: str | Path | None = _UNSET,
        logger: logging.Logger | None = None,
        content_source: Any | None = None,
    ):
        """
        Initialize QML loader.

        Args:
            qml_dir: Directory ``load_from_file`` resolves relative names
                     against. Ignored when ``content_source`` is given; unset
                     when neither is given, in which case ``load_from_file``
                     refuses rather than guessing a directory.
            schema_path: Omit to use the bundled schema from askalot_qml.
                         Pass None to disable schema validation.
                         Pass a Path to use a custom schema.
            logger: Optional logger instance
            content_source: Optional name→content resolver. When set, it — not
                the filesystem — answers ``load_from_file`` and
                ``list_available_files``.
        """
        self.logger = logger or logging.getLogger(__name__)
        self.content_source = content_source
        self.qml_dir = Path(qml_dir) if qml_dir else None

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

    def load_from_file(self, filename: str) -> dict[str, Any]:
        """
        Load and parse a QML document by name.

        Args:
            filename: QML name — a document name when ``content_source`` is
                set, otherwise a path relative to ``qml_dir``.

        Returns:
            Parsed questionnaire dictionary

        Raises:
            FileNotFoundError: nothing backs that name (the document-store
                source raises ``QMLDocumentMissingError``, a subclass)
            ValueError: neither a ``content_source`` nor a ``qml_dir`` was
                given, so the name resolves against nothing
            ValidationError: If QML doesn't match schema
        """
        if self.content_source is not None:
            self.logger.debug(f"Resolving QML document: {filename}")
            return self.load_from_string(self.content_source.read(filename))

        if self.qml_dir is None:
            raise ValueError(
                f"Cannot resolve QML name {filename!r}: this loader has neither a "
                "content_source nor a qml_dir. Pass RepositoryQMLSource to read the "
                "document store, or a qml_dir to read a workspace/fixture tree."
            )
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

        # Parse YAML, then run the shared post-parse pipeline.
        self.parsed_yaml = yaml.safe_load(self.qml_content)
        return self._process_parsed(missing_section_label="QML file")

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
        return self._process_parsed(missing_section_label="QML content")

    def _process_parsed(self, missing_section_label: str) -> dict[str, Any]:
        """Run the shared post-parse pipeline on ``self.parsed_yaml``.

        Both ``load_from_path`` and ``load_from_string`` acquire their input
        (file read vs. raw string) and parse it into ``self.parsed_yaml``, then
        delegate here. The exact ordering is contractually fixed:

        1. qmlVersion gate (BEFORE schema validation, so a legacy document gets
           a clear version error rather than a cryptic enum failure on the
           removed kinds)
        2. predicate normalization (BEFORE schema validation, so bare
           True/False predicates pass)
        3. JSON-Schema validation (when a schema is available)
        4. default missing ``kind`` to "Group" (the JSON-Schema ``default`` is
           not injected during validation)
        5. loader-level kind validation (legacy-kind rejection) + reserved
           item-id rejection (``__init__`` / ``codeInit`` collide with Z3
           static-builder sentinels)
        6. Roster/Checkbox power-of-2 label keys + Group ``count`` positivity +
           iterateOver self-cycle
        7. capped-Group inner-item independence (direct sibling references)
        8. flatten the nested structure

        ``missing_section_label`` distinguishes the two callers' error text
        ("QML file" vs "QML content") on a missing ``questionnaire`` section.
        """
        # 1. Reject an incompatible declared qmlVersion before schema validation.
        self._validate_qml_version()

        # 2. Normalize predicates BEFORE schema validation so QML authors can
        # write bare boolean/numeric predicates (like `predicate: True`).
        if "questionnaire" in self.parsed_yaml:
            self._normalize_all_predicates(self.parsed_yaml["questionnaire"])

        # 3. Validate against schema if available.
        if self.schema_path and self.schema_path.exists():
            self._validate_against_schema()
        else:
            self.logger.debug("Schema validation skipped (no schema available)")

        if "questionnaire" not in self.parsed_yaml:
            raise ValueError(f"{missing_section_label} must contain 'questionnaire' section")

        # 4. Default a missing `kind` to "Group" BEFORE any kind-specific work.
        self._default_block_kinds(self.parsed_yaml["questionnaire"])

        # 5-7. Loader-level validation that JSON Schema can't express cleanly.
        self._validate_block_kinds(self.parsed_yaml["questionnaire"])
        self._validate_reserved_item_ids(self.parsed_yaml["questionnaire"])
        self._validate_roster_and_checkbox_constraints(self.parsed_yaml["questionnaire"])
        self._validate_group_independence(self.parsed_yaml["questionnaire"])

        # 8. Flatten the structure before returning.
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

    def _validate_qml_version(self) -> None:
        """
        Reject a document whose declared `qmlVersion` is an incompatible MAJOR.

        The schema contract uses Major.Minor.Patch compatibility semantics
        (askalot_qml.schema.QML_SCHEMA_VERSION). A declared MAJOR other than the
        supported one can no longer load — e.g. a legacy `qmlVersion: "1.0"`
        document built on the removed Sequence/Sample kinds. An absent
        `qmlVersion` is advisory here (the schema's own `required` list catches
        it on the validated path); only a declared mismatch is gated, and it is
        gated before schema validation so the author sees a version error rather
        than a cryptic enum failure.

        The declared value must be a dotted numeric version (``^\\d+(\\.\\d+)*$``
        — e.g. ``"2"``, ``"2.0"``, ``"2.0.0"``); a malformed value such as
        ``"2.x"``, ``"2."`` or ``""`` is rejected loudly rather than silently
        truncated by a bare ``split(".")[0]`` (which would accept ``"2.x"`` as
        major ``2``).
        """
        if not self.parsed_yaml:
            return
        declared = self.parsed_yaml.get("qmlVersion")
        if declared is None:
            return
        from askalot_qml.schema import QML_SCHEMA_VERSION

        declared_str = str(declared)
        if not re.fullmatch(r"\d+(\.\d+)*", declared_str):
            raise ValueError(
                f"Malformed qmlVersion '{declared}': expected a dotted numeric "
                f"version such as '2' or '2.0' (current schema "
                f"{QML_SCHEMA_VERSION})."
            )

        supported_major = QML_SCHEMA_VERSION.split(".")[0]
        if declared_str.split(".")[0] != supported_major:
            raise ValueError(
                f"Unsupported qmlVersion '{declared}': this engine supports QML "
                f"schema major version {supported_major} (current "
                f"{QML_SCHEMA_VERSION}). Migrate the document to "
                f"qmlVersion '{supported_major}.0'."
            )

    def list_available_files(self) -> list[str]:
        """
        List every QML name this loader can resolve.

        Answered by ``content_source`` when one is set (the organization's QML
        documents), otherwise by scanning ``qml_dir``.

        Returns:
            Sorted list of QML names
        """
        if self.content_source is not None:
            return self.content_source.list_names()

        if self.qml_dir is None:
            raise ValueError(
                "Cannot list QML names: this loader has neither a content_source "
                "nor a qml_dir."
            )

        if not self.qml_dir.exists():
            self.logger.warning(f"QML directory does not exist: {self.qml_dir}")
            return []

        qml_files = [f.name for f in self.qml_dir.glob("*.qml")]
        self.logger.info(f"Found {len(qml_files)} QML files")

        return sorted(qml_files)

    # Recognized block kinds, all wired into the engine:
    #   - 'Group':  visit each in-scope inner item once in canonical
    #               (stable-Kahn topological) order; an optional `count` caps
    #               the block to the first N eligible items. Default kind.
    #   - 'Roster': repeat inner items per set bit in an `iterateOver` bitmask.
    # `kind` is optional and defaults to 'Group' (the loader injects it before
    # propagation/validation run). No reserved-future kinds remain.
    SUPPORTED_BLOCK_KINDS = ("Group", "Roster")
    RESERVED_BLOCK_KINDS = ()

    # Item ids that collide with internal sentinels in the Z3 static builder:
    # ``__init__`` is the codeInit assignment context (an item so named would be
    # treated as codeInit — its codeBlock assignment goes in unconditionally
    # instead of ``Implies``-gated, corrupting full-base soundness and the
    # frozen-variable oracle), and ``codeInit`` is the census/hygiene owner label
    # for "assigned in codeInit, not an item" (an item so named misroutes its
    # hygiene findings to item_id=None). Both are rejected at load time so the
    # collision can never reach the builder. See docs/plans review findings #3/#5.
    RESERVED_ITEM_IDS = ("__init__", "codeInit")

    def _default_block_kinds(self, questionnaire: dict[str, Any]) -> None:
        """
        Inject the default ``kind: "Group"`` onto any block that omits `kind`.

        `kind` is optional in the schema with a declared ``default`` of
        ``Group``, but JSON-Schema defaults are *not* applied during validation
        — the validator never mutates the instance. So the loader owns the
        default: it runs before kind-validation and ``_propagate_block_inheritance``
        so every downstream consumer sees a concrete `kind` and never has to
        re-derive "absent means Group". Mutates the nested questionnaire in place.

        Args:
            questionnaire: Nested questionnaire dictionary (pre-flatten).
        """
        for block in questionnaire.get("blocks", []):
            if "kind" not in block:
                block["kind"] = "Group"

    def _validate_block_kinds(self, questionnaire: dict[str, Any]) -> None:
        """
        Reject any block whose `kind` is not one the loader supports.

        `kind` is optional and defaults to ``Group`` (the default is injected by
        ``_flatten_questionnaire_structure`` before this check runs, and again by
        the schema; see the absent-kind handling in ``_default_block_kinds``).
        By the time this runs every block therefore carries an explicit `kind`,
        so a missing `kind` is no longer an error.

        This is defence-in-depth for callers that bypass schema validation
        (``schema_path=None``): the legacy ``Sequence``/``Sample`` kinds and any
        other unrecognized literal are rejected loudly here even when the JSON
        schema enum never runs. ``Sequence`` collapsed into ``Group`` and
        ``Sample`` became the optional ``count`` attribute on ``Group`` — there
        is no back-compat alias, so the author must migrate.

        Raises:
            ValueError: when `kind` is unknown (including the retired
                ``Sequence``/``Sample`` literals).
        """
        for block in questionnaire.get("blocks", []):
            block_id = block.get("id", "<unknown>")
            # The default is injected upstream; fall back here too so a caller
            # that hands a raw nested dict to this method directly is consistent.
            kind = block.get("kind", "Group")
            if kind not in self.SUPPORTED_BLOCK_KINDS:
                # Schema enum should already have caught this, but defend in
                # depth for callers that bypass schema validation. Name the two
                # supported kinds and the migration for the retired literals so
                # the message is author-actionable.
                hint = ""
                if kind == "Sequence":
                    hint = " ('Sequence' is now 'Group' — rename it or omit kind)."
                elif kind == "Sample":
                    hint = (
                        " ('Sample' is removed — use 'Group' with an optional "
                        "'count' to ask the first N items)."
                    )
                raise ValueError(
                    f"Block '{block_id}': unknown kind {kind!r}. Allowed: "
                    f"{list(self.SUPPORTED_BLOCK_KINDS)}.{hint}"
                )

    def _validate_reserved_item_ids(self, questionnaire: dict[str, Any]) -> None:
        """Reject any item whose id collides with a Z3 static-builder sentinel.

        ``__init__`` and ``codeInit`` (see ``RESERVED_ITEM_IDS``) are used
        internally as the codeInit assignment context and the codeInit hygiene
        owner label. The JSON schema places no reserved-word constraint on
        ``Item.id``, so an item legally named either string would silently
        corrupt full-base soundness / the frozen-variable oracle (``__init__``)
        or misroute hygiene findings to ``item_id=None`` (``codeInit``). Fail
        loud at load time so the collision can never reach the builder.

        Raises:
            ValueError: when an item id is a reserved sentinel string.
        """
        for block in questionnaire.get("blocks", []):
            for item in block.get("items", []):
                item_id = item.get("id")
                if item_id in self.RESERVED_ITEM_IDS:
                    raise ValueError(
                        f"Item id {item_id!r} is reserved: it collides with an "
                        f"internal Z3 static-builder sentinel. Rename the item "
                        f"(reserved ids: {list(self.RESERVED_ITEM_IDS)})."
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
        4. Group `count` (the N cap) is OPTIONAL — omitted means "ask all
           in-scope items". But when present it must be a positive integer
           literal. The JSON schema's `minimum: 1` only fires for genuine
           integers; YAML may parse a quoted/expression value as a string, so we
           re-validate here and fail loud on a non-positive / non-integer / bool
           value — there is NO silent default that turns a malformed `count`
           into a 0-draw or full Group (monorepo "No Silent Fallbacks" rule).
           `count` only ever flows from the loader as an integer; runtime "ask up
           to N" semantics (asking fewer when the pool exhausts) are a U5
           concern, not a load-time one. A Roster must NOT carry `count` (the
           schema rejects it; mirrored here for the schema-less load path).

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

                # A Roster's repetition universe is `labels`, not `count`. The
                # schema rejects `count` on a Roster; mirror that on the
                # schema-less path so a stray `count` never silently flows.
                if "count" in block:
                    raise ValueError(
                        f"Roster block '{block_id}': 'count' is a Group-only "
                        f"attribute and must not appear on a Roster. A Roster's "
                        f"iteration universe is its 'labels' bitmask, not a draw "
                        f"cap."
                    )

            # Rule 4 — Group `count` (the optional N cap) must be a positive
            # integer literal WHEN PRESENT. Omitting `count` is legal (ask all
            # in-scope items), so a missing `count` is NOT an error. But a
            # present `count` that is 0 / negative / non-int / bool fails loud
            # here so a malformed cap never silently behaves like a 0-draw or a
            # full Group. bool is an int subclass in Python (and YAML `true` →
            # True), so it is rejected explicitly — `count: true` is an
            # authoring error.
            if kind == "Group" and "count" in block:
                count = block.get("count")
                if isinstance(count, bool) or not isinstance(count, int) or count < 1:
                    raise ValueError(
                        f"Group block '{block_id}': 'count' must be a positive "
                        f"integer (got {count!r}). It caps the block to the first "
                        f"N eligible items; it cannot be zero, negative, or a "
                        f"non-integer. Omit 'count' entirely to ask all items."
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

    def _validate_group_independence(self, questionnaire: dict[str, Any]) -> None:
        """Reject a ``count``-capped Group whose inner items are NOT independent
        (layer 1 of the two-layer R10 enforcement — the cheap structural case).

        A capped Group asks at most ``count`` of its inner items, drawn
        deterministically from the eligible pool; the draw can leave any inner
        item undrawn (``outcome=None``). If one inner item's precondition,
        postcondition, or codeBlock references a SIBLING inner item of the same
        Group, that reference may be evaluated against an undrawn sibling's
        ``None`` outcome at runtime. The runtime ``FlowProcessor`` draw path
        never invokes validation, so this rule must be enforced at the loader —
        the universal chokepoint — or a malformed capped Group reaches the draw
        and silently evaluates a predicate against an absent sibling.

        This is a STRUCTURAL name-match check: it parses each inner item's
        predicates / codeBlock with the same AST-name helper the loader already
        uses for the Roster self-cycle check (``_ast_referenced_names``) and
        flags any referenced name that equals a sibling inner item id. It only
        catches the common DIRECT-reference case; transitive / variable-mediated
        dependencies (item A writes a var in its codeBlock, item B reads it) are
        invisible to a name-match and are caught by the sound validation-time
        layer on the real ``StaticBuilder`` dependency graph
        (``_emit_capped_group_independence_gaps`` in ``z3/static_builder.py``).

        Scope notes:
        - Only ``count``-capped Groups are checked. An uncapped Group asks every
          in-scope item, so no item is ever drawn away — its inner items may
          depend on one another freely.
        - Cross-block dependencies (an inner item referencing an item OUTSIDE
          this Group) remain allowed and are intentionally not flagged here: the
          name must equal a SIBLING inner item id to trip the check.
        - Runs on the UN-flattened questionnaire so each block's ``items`` are
          still nested and a Group's sibling-id universe is exactly its own
          ``items`` (not the whole flat item list).

        Args:
            questionnaire: Nested questionnaire dictionary (pre-flatten).

        Raises:
            ValueError: when a capped-Group inner item directly references a
                sibling inner item, naming the offending item and the sibling.
        """
        for block in questionnaire.get("blocks", []):
            block_id = block.get("id", "<unknown>")
            # Only `count`-capped Groups enforce independence. `kind` is already
            # defaulted to "Group" upstream and `count` is loud-validated as a
            # positive int by `_validate_roster_and_checkbox_constraints`, which
            # runs before this method.
            if block.get("kind") != "Group" or "count" not in block:
                continue

            items = block.get("items", []) or []
            inner_item_ids = {item.get("id") for item in items if item.get("id")}

            for item in items:
                item_id = item.get("id")
                if not item_id:
                    continue

                # Collect every identifier name this inner item references in
                # its precondition predicates, postcondition predicates, and
                # codeBlock. Predicates parse as `eval`-mode expressions; the
                # codeBlock is a statement body, so it is parsed in `exec` mode
                # (the default eval mode would raise on a multi-statement body
                # and silently return nothing).
                referenced: set[str] = set()
                for condition_key in ("precondition", "postcondition"):
                    for condition in item.get(condition_key, []) or []:
                        predicate = condition.get("predicate")
                        if isinstance(predicate, str) and predicate:
                            referenced |= _ast_referenced_names(predicate)
                code_block = item.get("codeBlock")
                if isinstance(code_block, str) and code_block:
                    referenced |= _ast_referenced_names(code_block, mode="exec")

                # A sibling reference is any referenced name that is the id of
                # ANOTHER inner item in the same Group (self-references are not
                # dependencies — an item may read its own outcome).
                sibling_refs = (referenced & inner_item_ids) - {item_id}
                if sibling_refs:
                    raise ValueError(
                        f"Capped Group '{block_id}': inner item '{item_id}' "
                        f"references sibling inner item(s) "
                        f"{sorted(sibling_refs)!r} of the same Group. A "
                        f"`count`-capped Group draws at most {block['count']} of "
                        f"its items, so any inner item may be left undrawn — its "
                        f"siblings must be independent (no precondition / "
                        f"postcondition / codeBlock reference between them). Move "
                        f"the dependency to a separate block, or remove `count` "
                        f"to ask every item."
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
          - Inner items in a ``count``-capped ``Group`` block get
            ``_group_block_id`` and ``_group_count``.

        so FlowProcessor / Z3 / Bronze schema build can detect roster /
        capped-group items without re-walking the block tree. An **uncapped**
        Group (no ``count``) adds nothing — its items are asked unconditionally,
        so they need no draw-cap tag. The two tag families are mutually
        exclusive (a block has exactly one kind), so no item ever carries both.

        Mutates ``item`` in place; the caller is responsible for cloning
        before calling if isolation is required.
        """
        kind = block.get("kind")
        # Roster metadata propagation. Additive — non-roster items unaffected.
        if kind == "Roster":
            item["_roster_block_id"] = block["id"]
            item["_roster_iterate_over"] = block.get("iterateOver", "")
            item["_roster_labels"] = block.get("labels", {})
            # subjectFrom (optional): id of the inner item whose per-iteration
            # answer becomes the iteration's display subject (F-001). None when
            # the roster keeps the static labels.
            item["_roster_subject_from"] = block.get("subjectFrom")
        # Capped-Group metadata propagation, mirroring the Roster branch. Only a
        # Group that declares `count` tags its items — an uncapped Group asks
        # all items, so there is no draw cap to carry. `count` is already
        # loud-validated as a positive int by
        # `_validate_roster_and_checkbox_constraints`, so `block["count"]` is a
        # safe direct index (no `.get` default — that would reintroduce a
        # silent fallback).
        elif kind == "Group" and "count" in block:
            item["_group_block_id"] = block["id"]
            item["_group_count"] = block["count"]

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
