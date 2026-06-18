import logging
from typing import Any, NotRequired, TypedDict


class Condition(TypedDict):
    """
    Condition structure for preconditions and postconditions.

    For preconditions: hint describes when the item is intended to show
    (useful for questionnaire design, not shown to respondents).

    For postconditions: hint contains the message shown to users when
    their answer doesn't satisfy the validation constraint.
    """

    predicate: str
    hint: NotRequired[str]


class ItemOption(TypedDict):
    """Option structure for radio/checkbox items."""

    value: Any
    label: str


class QuestionnaireItem(TypedDict):
    """
    Type structure for a questionnaire item.
    Items are the primary execution units in the functional flow.
    """

    # Core item properties
    id: str
    blockId: str  # Reference to the enclosing block
    kind: str  # 'Question', 'Comment', etc.
    title: str

    # Input configuration
    input: NotRequired[dict[str, Any]]  # Control type and configuration

    # Flow control
    precondition: NotRequired[list[Condition]]
    postcondition: NotRequired[list[Condition]]
    codeBlock: NotRequired[str]

    # Runtime state (added during execution)
    outcome: NotRequired[Any]  # User's answer/selection
    visited: NotRequired[bool]  # Has been shown to user
    context: NotRequired[dict[str, Any]]  # Variable state AFTER this item's execution


class QuestionnaireBlock(TypedDict):
    """
    Type structure for a questionnaire block.
    Blocks are logical groupings of items for organization.

    Block-level pre/postconditions stay on the block (R25, 2026-05-14) — the
    QMLLoader no longer copies them onto items during flattening. Consumers
    compose block + item conditions at evaluation time: FlowProcessor and
    StaticBuilder gate each item on (block conditions BEFORE item conditions),
    and qml_diagram_ir renders them at their natural scope.

    Roster kind extends Block with an integer bitmask `iterateOver` expression
    and a `labels` map (power-of-2 keys → display strings). The engine walks set
    bits in iterateOver from low to high, running inner items once per active bit
    whose key appears in labels. See docs/plans/2026-05-04-001-feat-roster-block-plan.md.

    Group kind (the default) asks each in-scope inner item once in canonical
    stable-Kahn order. An optional `count` (positive integer N — the loader
    rejects a non-positive value loudly) caps the block to the first N eligible
    items: a deterministic, precondition-gated first-N draw, not random
    selection. The draw order derives from the global navigation_path filtered to
    the block's members, so no per-block order is stored on the state.
    """

    id: str
    kind: NotRequired[str]  # 'Group' (default) or 'Roster'
    title: NotRequired[str]
    precondition: NotRequired[list[Condition]]
    postcondition: NotRequired[list[Condition]]
    # Roster-only fields:
    iterateOver: NotRequired[str]  # Python expression resolving to an int bitmask
    labels: NotRequired[dict[int, str]]  # power-of-2 keys → display strings
    # Group-only field:
    count: NotRequired[int]  # Group-only: optional positive integer N (first-N cap)


class QMLState(dict):
    """
    QML execution state with flat item structure and exposed types.

    Items reference their blocks rather than being nested inside them.
    Maintains functional approach where context flows through items without mutation.
    Each item's context represents the variable state after that item's execution.

    This class inherits from dict to maintain JSON serialization compatibility
    while providing type-safe access methods.
    """

    def __init__(self, state: dict[str, Any] = None):
        """
        Initialize QML state from dictionary.

        Args:
            state: Dictionary containing questionnaire data (from QML or saved state)
        """
        self.logger = logging.getLogger(__name__)
        super().__init__(state or {})

        # Ensure required fields exist
        self.setdefault("history", [])
        self.setdefault("visited_items", [])  # All items ever visited (never truncated)
        self.setdefault("blocks", [])
        self.setdefault("items", [])
        self.setdefault("variables", {})

        # O(1) lookups by id — items and blocks are loader-immutable after
        # construction (consumers mutate fields, not the lists). Each get_item
        # / get_block / get_items_by_block call previously did a full O(N)
        # scan; with N items called inside per-item loops (classify_all_items,
        # is_item_done's all_done check, the Group drawn-set walk,
        # process_item's all_drawn_visited check) the cost compounded to
        # O(N^2). The indices are rebuilt by reset() and any callsite that
        # replaces the items/blocks lists wholesale must also call
        # _rebuild_indices().
        self._rebuild_indices()

        # Warnings collected during flow processing (for data analysis)
        # Each warning has: item_id, type ('precondition'|'postcondition'|'codeblock'), message
        self.setdefault("warnings", [])

        # Roster support (added in plan 2026-05-04-001 / U2).
        #
        # Storage choices, summarized:
        #
        #  * `roster_outcomes`  Per-iteration outcomes for items inside a Roster.
        #                       Shape: {block_id: {label_key: {item_id: value}}}.
        #                       label_key is the power-of-2 bit value (e.g. 1, 2, 4, 8).
        #                       Single keying scheme — no numeric-vs-list mode distinction.
        #                       Sibling map (NOT synthetic items in state['items']) so the
        #                       precomputed navigation_path invariant stays intact.
        #
        #  * `roster_iter`      Transient: which label_key the respondent is currently
        #                       answering for each block they're mid-pass on. Cleared
        #                       when the roster pass completes or on backward-exit.
        #
        #  * `roster_active_keys` The frozen sorted-low-to-high active label_keys for
        #                       the current pass. Computed once at roster entry (per
        #                       the iterateOver-evaluation invariant in the plan):
        #                       inner codeBlocks may modify outer variables, but the
        #                       active set for the current pass is fixed until exit.
        #
        #  * `history_iter_key` Parallel list to `history`, lockstep-indexed. Element
        #                       is the label_key for roster items, None for non-roster.
        #                       Chosen over a single dict-form history list (option c
        #                       in the plan's "Deferred to Implementation" section)
        #                       because get_history() can stay unchanged → all four
        #                       enumerated callsites (flow_blueprint stepper, navigate-
        #                       to-item, targetor path_data builder, survey_extractor
        #                       outcome-extraction loop) keep iterating List[str]
        #                       without any change. Legacy persisted state with
        #                       `history` but no `history_iter_key` is back-filled
        #                       below with [None]*len(history) so length stays in
        #                       lockstep without an Alembic migration.
        self.setdefault("roster_outcomes", {})
        self.setdefault("roster_iter", {})
        self.setdefault("roster_active_keys", {})
        self.setdefault("history_iter_key", [None] * len(self.get("history", [])))

        # Group `count`-cap pass state.
        #
        #  * `group_asked`    The inner item_ids that have CONSUMED an N slot
        #                     this pass (i.e. were actually presented because
        #                     their precondition held), in draw order.
        #                     Precondition-skipped items are passed over for
        #                     free and never appear here. The pass ends when
        #                     len(group_asked) == N or the eligible pool is
        #                     exhausted. Re-derived every pass — eligibility is
        #                     recomputed against current answers. There is NO
        #                     frozen per-block order: draw order comes from the
        #                     block's projection of the global navigation_path
        #                     (filter-to-block-members, preserving global
        #                     stable-Kahn order), so nothing here needs to
        #                     persist across passes.
        #                     Shape: {block_id: [item_id, ...]}.
        #
        # A Group has no per-iteration identity (unlike Roster's label-key),
        # so Group history entries use iter_key=None — `history_iter_key`
        # stays Roster-only and the parallel-list contract is unchanged.
        self.setdefault("group_asked", {})

        # Restore int keys for roster_outcomes after a JSON roundtrip. JSON
        # object keys are always strings, so a state that was persisted with
        # `{block_id: {1: {...}}}` comes back as `{block_id: {"1": {...}}}`.
        # Accessors and direct-dict callers (tests, FlowProcessor snapshot/
        # restore) expect native int keys, so re-key once at construction.
        # Non-digit keys are left untouched so we don't mangle unrelated data.
        for block_id, iter_map in list(self.get("roster_outcomes", {}).items()):
            if not isinstance(iter_map, dict):
                continue
            rekeyed: dict[Any, Any] = {}
            for k, v in iter_map.items():
                if isinstance(k, str) and k.lstrip("-").isdigit():
                    rekeyed[int(k)] = v
                else:
                    rekeyed[k] = v
            self["roster_outcomes"][block_id] = rekeyed

        # Repair length drift defensively. If a future bug ever stores history without
        # updating history_iter_key (or vice versa) we'd silently misattribute
        # iter_keys; keep both in lockstep here so all downstream callers can rely
        # on `history[i]` and `history_iter_key[i]` being paired.
        history_len = len(self.get("history", []))
        if len(self["history_iter_key"]) < history_len:
            self["history_iter_key"].extend([None] * (history_len - len(self["history_iter_key"])))
        elif len(self["history_iter_key"]) > history_len:
            self["history_iter_key"] = self["history_iter_key"][:history_len]

    def _rebuild_indices(self) -> None:
        """Rebuild the id→item / id→block / blockId→[items] / kind→[blocks]
        indices.

        Call after any wholesale replacement of ``self["items"]`` or
        ``self["blocks"]``; field-level mutation on already-indexed dicts is
        safe because the indices store references, not copies.
        """
        self._item_index: dict[str, QuestionnaireItem] = {
            item["id"]: item for item in self.get_items() if "id" in item
        }
        self._block_index: dict[str, QuestionnaireBlock] = {
            block["id"]: block for block in self.get_blocks() if "id" in block
        }
        self._items_by_block: dict[str, list[QuestionnaireItem]] = {}
        for item in self.get_items():
            block_id = item.get("blockId")
            if block_id is not None:
                self._items_by_block.setdefault(block_id, []).append(item)
        # Cache by kind so process_item's pass-state-clearing loop can skip
        # whole branches when no Roster/Group blocks exist.
        self._blocks_by_kind: dict[str, list[QuestionnaireBlock]] = {}
        for block in self.get_blocks():
            kind = block.get("kind")
            if kind is not None:
                self._blocks_by_kind.setdefault(kind, []).append(block)

    def get_blocks_by_kind(self, kind: str) -> list[QuestionnaireBlock]:
        """Get blocks of a specific kind. O(1) via _blocks_by_kind.

        Returns an empty list when no blocks of that kind exist; callers can
        rely on the empty-list short-circuit to skip whole-pass branches
        (process_item's pass-state-clearing loop is the canonical caller).
        """
        return list(self._blocks_by_kind.get(kind, ()))

    def __str__(self) -> str:
        """String representation of the state."""
        return f"QMLState(items={len(self.get_items())}, blocks={len(self.get_blocks())})"

    def __repr__(self) -> str:
        """Detailed representation of the state."""
        return f"QMLState({super().__repr__()})"

    # Block access methods
    def get_blocks(self) -> list[QuestionnaireBlock]:
        """Get all block definitions."""
        return self.get("blocks", [])

    def get_block(self, block_id: str) -> QuestionnaireBlock | None:
        """Get a block by its ID. O(1) via _block_index."""
        return self._block_index.get(block_id)

    # Item access methods
    def get_items(self) -> list[QuestionnaireItem]:
        """
        Get all items in flat structure.

        Returns:
            List of all items with their blockId references
        """
        return self.get("items", [])

    def get_all_items(self) -> list[QuestionnaireItem]:
        """
        Alias for get_items() — returns the flat list of all items.

        Returns:
            List of all items
        """
        return self.get_items()

    def get_item(self, item_id: str) -> QuestionnaireItem | None:
        """Get an item by its ID. O(1) via _item_index."""
        return self._item_index.get(item_id)

    def get_items_by_block(self, block_id: str) -> list[QuestionnaireItem]:
        """Get items in the specified block. O(1) via _items_by_block.

        Returns a fresh list so callers can mutate it without disturbing the
        index; the items themselves remain shared references.
        """
        return list(self._items_by_block.get(block_id, ()))

    # Code access
    def get_code_init(self) -> str:
        """Get the initialization code for the questionnaire."""
        return self.get("codeInit", "")

    # Runtime state methods
    def add_to_history(self, item_id: str, iter_key: int | None = None) -> None:
        """
        Add an item to navigation history.

        Roster-aware: pass `iter_key` (the active Roster label-key, a positive
        power of 2) when the item is being shown inside a roster iteration. The
        value is stored in the parallel `history_iter_key` list keyed lockstep
        with `history`. Non-roster items get `iter_key=None` (the default).

        Args:
            item_id: The item identifier to add
            iter_key: Roster label-key for this iteration, or None for non-roster
        """
        self.setdefault("history", []).append(item_id)
        self.setdefault("history_iter_key", []).append(iter_key)

    def pop_history(self) -> tuple | None:
        """
        Pop the last (item_id, iter_key) pair from history.

        Returns the tuple `(item_id, iter_key)` for the popped entry, or None
        if history is empty. Centralized here so backward-navigation callers
        can't drift out of lockstep between `history` and `history_iter_key`.
        """
        history = self.get("history", [])
        iter_keys = self.get("history_iter_key", [])
        if not history:
            return None
        item_id = history.pop()
        iter_key = iter_keys.pop() if iter_keys else None
        return (item_id, iter_key)

    def get_history(self) -> list[str]:
        """
        Get navigation history (item IDs only, lockstep with `history_iter_key`).

        Backward-compat shape: returns List[str]. Roster-aware consumers that need
        the iteration context for each entry should call `get_history_with_iter()`.
        """
        return self.get("history", [])

    def get_history_with_iter(self) -> list[tuple]:
        """
        Get navigation history paired with iteration keys.

        Returns a list of `(item_id, iter_key)` tuples. Non-roster entries carry
        `iter_key=None`. Used by FlowProcessor for roster-aware backward navigation
        (it needs to know which iteration to restore when popping a roster entry).
        """
        history = self.get("history", [])
        iter_keys = self.get("history_iter_key", [])
        return [
            (item_id, iter_keys[i] if i < len(iter_keys) else None)
            for i, item_id in enumerate(history)
        ]

    # Visited items methods (for direct navigation)
    def add_to_visited(self, item_id: str) -> None:
        """
        Add an item to the visited items set.
        Unlike history, visited_items is never truncated.

        Args:
            item_id: The item identifier to add
        """
        if "visited_items" not in self:
            self["visited_items"] = []
        if item_id not in self["visited_items"]:
            self["visited_items"].append(item_id)

    def get_visited_items(self) -> list[str]:
        """Get all visited items (never truncated, unlike history)."""
        return self.get("visited_items", [])

    def is_item_visited(self, item_id: str) -> bool:
        """Check if an item has ever been visited."""
        return item_id in self.get_visited_items()

    def reset(self) -> None:
        """
        Reset the QML state to its initial state.

        Clears all runtime state including:
        - Navigation path (triggers re-initialization with initCode)
        - Navigation history
        - Visited items
        - Warnings
        - Cached diagrams
        - Item outcomes, visited status, and context

        After reset, the FlowProcessor will re-initialize the questionnaire,
        including re-running the initCode block with fresh context.
        """
        # Clear navigation state
        self["history"] = []
        self["history_iter_key"] = []
        self["visited_items"] = []
        self["warnings"] = []

        # Clear roster runtime state. `roster_outcomes` is per-iteration answer
        # storage; `roster_iter` and `roster_active_keys` are transient pass state.
        self["roster_outcomes"] = {}
        self["roster_iter"] = {}
        self["roster_active_keys"] = {}

        # Clear Group `count`-cap runtime state. `group_asked` is the per-pass
        # drawn-slot list — wholly transient.
        self["group_asked"] = {}

        # Clear navigation_path to trigger re-initialization in FlowProcessor
        # This ensures initCode is re-run with empty outcomes and fresh context
        self.pop("navigation_path", None)

        # Clear runtime state from all items
        for item in self.get_items():
            # Remove runtime fields
            item.pop("outcome", None)
            item.pop("visited", None)
            item.pop("context", None)

    def set_current_item(self, item_id: str) -> None:
        """
        Set the current active item.

        Args:
            item_id: The item identifier
        """
        self["current_item_id"] = item_id

    def get_current_item_id(self) -> str | None:
        """Get the current active item ID."""
        return self.get("current_item_id")

    # Navigation path methods
    def set_navigation_path(self, path: list[str]) -> None:
        """
        Set the pre-computed navigation path from Z3 topology analysis.

        Args:
            path: List of item IDs in topological order
        """
        self["navigation_path"] = path

    def get_navigation_path(self) -> list[str]:
        """Get the pre-computed navigation path."""
        return self.get("navigation_path", [])

    def get_navigation_index(self) -> dict[str, int]:
        """Return an ``{item_id: position}`` map for the navigation path.

        Cached and invalidated by the navigation_path list identity, so a
        wholesale path replacement (set_navigation_path / re-init) rebuilds it
        but field mutations on items do not. Callers that previously did
        ``nav_path.index(item_id)`` (O(N), making a full survey O(N^2)) use
        this for an O(1) position lookup with identical semantics — the index
        of the FIRST occurrence (``dict`` keeps the first write per key, and
        navigation_path entries are unique).
        """
        path = self.get_navigation_path()
        cached = getattr(self, "_nav_index", None)
        if cached is not None and self.__dict__.get("_nav_index_path_id") == id(path):
            return cached
        index = {item_id: pos for pos, item_id in enumerate(path)}
        self._nav_index = index
        self._nav_index_path_id = id(path)
        return index

    # ------------------------------------------------------------------
    # Roster outcome storage
    # ------------------------------------------------------------------
    #
    # Per-iteration outcomes for items inside a Roster are kept in a sibling
    # `roster_outcomes` map (NOT mixed into `state['items']`). The accessors below
    # are the ONLY way FlowProcessor / SurveyExtractor / ItemProxy should touch
    # roster_outcomes — direct dict mutation risks silent shape drift.

    def set_roster_outcome(self, block_id: str, iter_key: int, item_id: str, value: Any) -> None:
        """Record an inner-roster item's outcome for a specific iteration."""
        block_bucket = self.setdefault("roster_outcomes", {}).setdefault(block_id, {})
        iter_bucket = block_bucket.setdefault(iter_key, {})
        iter_bucket[item_id] = value

    def get_roster_outcome(self, block_id: str, iter_key: int, item_id: str) -> Any:
        """Read one (block, iter, item) cell. Returns None if any level is missing."""
        return self.get("roster_outcomes", {}).get(block_id, {}).get(iter_key, {}).get(item_id)

    def get_roster_outcomes_for_iter(self, block_id: str, iter_key: int) -> dict[str, Any]:
        """All inner-item outcomes for one iteration of one block. Empty dict if absent."""
        return self.get("roster_outcomes", {}).get(block_id, {}).get(iter_key, {})

    def get_roster_outcomes_for_item(self, block_id: str, item_id: str) -> dict[int, Any]:
        """
        All iterations' outcomes for a single inner item, keyed by label_key.

        This is the dict-shape ItemProxy exposes via `q.outcomes` for outside-roster
        reads (e.g., `q_satisfaction.outcomes[4]` from a post-roster codeBlock to
        read the Dinner iteration's value).
        """
        block_bucket = self.get("roster_outcomes", {}).get(block_id, {})
        return {
            label_key: per_iter.get(item_id)
            for label_key, per_iter in block_bucket.items()
            if item_id in per_iter
        }

    def clear_roster_iter_state(self, block_id: str) -> None:
        """Clear transient pass state (current iter + frozen active keys) on roster exit."""
        self.get("roster_iter", {}).pop(block_id, None)
        self.get("roster_active_keys", {}).pop(block_id, None)

    def get_current_roster_iter(self, block_id: str) -> int | None:
        """Which label_key the respondent is currently answering, if mid-pass on this block."""
        return self.get("roster_iter", {}).get(block_id)

    def set_current_roster_iter(self, block_id: str, iter_key: int) -> None:
        """Record the active label_key for the current roster iteration in progress."""
        self.setdefault("roster_iter", {})[block_id] = iter_key

    def get_roster_active_keys(self, block_id: str) -> list[int] | None:
        """Frozen sorted-low-to-high active label_keys for the current pass, or None if not yet entered."""
        return self.get("roster_active_keys", {}).get(block_id)

    def set_roster_active_keys(self, block_id: str, keys: list[int]) -> None:
        """Freeze the active-keys list at roster entry (per the iterateOver-evaluation invariant)."""
        self.setdefault("roster_active_keys", {})[block_id] = list(keys)

    # ------------------------------------------------------------------
    # Group `count`-cap pass state
    # ------------------------------------------------------------------
    #
    # `group_asked` is the per-pass list of inner items that consumed an N slot
    # (precondition-true at draw time). There is NO frozen per-block order:
    # draw order derives from the block's projection of the global
    # navigation_path. These accessors are the ONLY supported way FlowProcessor
    # / cross-consumers touch the map.

    def get_group_asked(self, block_id: str) -> list[str]:
        """Inner item_ids that consumed an N slot this pass (draw order). Empty if none."""
        return self.get("group_asked", {}).get(block_id, [])

    def has_group_pass(self, block_id: str) -> bool:
        """True if a Group `count`-cap pass is currently ACTIVE for this block.

        Distinguishes "pass entered, drawn set computed (possibly empty —
        degenerate pass)" from "pass not entered / cleared on exit". This is
        the per-pass sentinel — the analogue of Roster's
        ``get_roster_active_keys(...) is not None``.
        """
        return block_id in self.get("group_asked", {})

    def set_group_asked(self, block_id: str, item_ids: list[str]) -> None:
        """Record the per-pass drawn-slot list (re-derived each pass from the
        navigation_path projection)."""
        self.setdefault("group_asked", {})[block_id] = list(item_ids)

    def clear_group_pass_state(self, block_id: str) -> None:
        """Clear the per-pass drawn-slot list on Group exit."""
        self.get("group_asked", {}).pop(block_id, None)

    # Warning collection methods (for data analysis)
    def add_warning(self, item_id: str, warning_type: str, message: str) -> None:
        """
        Add a warning encountered during flow processing.

        Warnings are collected for later analysis during data processing.
        They indicate issues like unevaluatable preconditions/postconditions
        or code block errors that were handled gracefully at runtime.

        Args:
            item_id: The item where the warning occurred
            warning_type: Type of warning ('precondition', 'postcondition', 'codeblock')
            message: Description of the warning
        """
        if "warnings" not in self:
            self["warnings"] = []
        self["warnings"].append({"item_id": item_id, "type": warning_type, "message": message})

    def get_warnings(self) -> list[dict[str, str]]:
        """Get all warnings collected during flow processing."""
        return self.get("warnings", [])

    def has_warnings(self) -> bool:
        """Check if any warnings were collected."""
        return len(self.get("warnings", [])) > 0
