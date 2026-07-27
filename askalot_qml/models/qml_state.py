import logging
import time
from collections.abc import Iterable
from typing import Any, NotRequired, TypedDict


def _now_ms() -> int:
    """Wall-clock epoch milliseconds — the timing log's only clock.

    Module-level so the whole log shares one time source (and so tests can
    drive it deterministically). Wall clock, not a monotonic counter: the
    presentation and submission moments of one answer are stamped in two
    separate HTTP requests, potentially served by different Gunicorn workers,
    so a per-process monotonic reference would not be comparable.
    """
    return int(time.time() * 1000)


# Degradation-warning severities, ordered by data consequence (see add_warning).
WARNING_SEVERITIES = frozenset({"critical", "degraded", "informational"})

# The same vocabulary ranked least-to-most consequential. `add_warning`
# validates writes against the unordered WARNING_SEVERITIES; this orders that
# set so every consumer ranks 'critical' worst without re-hardcoding the scale.
# A severity added to WARNING_SEVERITIES but not here fails loudly at import —
# RuntimeError, not assert, because `python -O` strips asserts and an invariant
# that vanishes under an optimisation flag is the silent fallback this guards.
_SEVERITY_BY_CONSEQUENCE = ("informational", "degraded", "critical")
if set(_SEVERITY_BY_CONSEQUENCE) != WARNING_SEVERITIES:
    raise RuntimeError(
        f"SEVERITY_RANK is out of sync with WARNING_SEVERITIES: "
        f"ranked {sorted(_SEVERITY_BY_CONSEQUENCE)}, "
        f"vocabulary is {sorted(WARNING_SEVERITIES)}"
    )
SEVERITY_RANK: dict[str, int] = {
    severity: rank for rank, severity in enumerate(_SEVERITY_BY_CONSEQUENCE)
}


def worst_severity(severities: Iterable[str]) -> str | None:
    """The highest-consequence severity in an iterable, or None if empty.

    The single source for "which of these warnings matters most": the
    per-visit marker, the campaign rollup, and the Bronze ``_degradation``
    column all rank through here rather than re-deriving the scale.
    """
    return max(severities, key=SEVERITY_RANK.__getitem__, default=None)

# Timing-event source discriminators (R9) — what produced the answer being
# timed. Declared here, beside the log that validates them, so the drivers
# (SirWay's flow blueprint, Portor's survey capabilities, the mass-fill job,
# the external-input prefill) all spell the same four values.
#
# The distinction is what keeps a duration distribution interpretable: a
# synthetic fill answers in milliseconds and a prefill in none at all, so a
# median computed over an untagged log describes the filler, not the people.
SOURCE_RESPONDENT = "respondent"  # A person answering for themselves
SOURCE_INTERVIEWER = "interviewer"  # A person answering with an interviewer facilitating
SOURCE_EXTERNAL_PREFILL = "external_prefill"  # Injected from the respondent record at init
SOURCE_SYNTHETIC = "synthetic"  # Machine-produced (mass fill, API-driven completion)

TIMING_SOURCES = frozenset(
    {SOURCE_RESPONDENT, SOURCE_INTERVIEWER, SOURCE_EXTERNAL_PREFILL, SOURCE_SYNTHETIC}
)


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

        # Degradation warnings collected during flow processing (R14, R19, R20).
        # One entry per (item, roster iteration, type) — see add_warning for the
        # record's fields and the severity scale.
        self.setdefault("warnings", [])

        # Per-answer response timing (R7-R10, R12).
        #
        #  * `response_timing`  Append-only list of timing events, one per
        #                       presentation-and-answer of an item. Written at
        #                       two different moments (presentation, then
        #                       submission) by open_timing_event /
        #                       close_timing_event below.
        #
        # Keyed by CONTENT, not by position: every event carries its own item id
        # and iteration key rather than being lockstep-indexed against
        # `history` (the way `history_iter_key` is). `pop_history` truncates
        # `history` on backward navigation while this log keeps growing, so a
        # positional pairing would misattribute every event after the first
        # back-navigation.
        #
        # Compact encoding is deliberate, not stylistic. The whole qml_state
        # JSONB column is rewritten by `upsert_survey` on EVERY navigation step,
        # so the per-event encoding is write amplification: at ~100 events a
        # verbose shape (ISO-8601 strings, spelled-out keys) costs ~23 KB per
        # survey against ~9 KB for this one. Hence epoch-millisecond integers
        # and single-letter keys:
        #
        #     i    item_id     the item that was presented
        #     k    iter_key    Roster iteration key (power-of-2 bit), None outside a Roster
        #     p    presented   epoch ms when the item was put in front of the answerer
        #     s    submitted   epoch ms when the answer came back; None while the event is open
        #     c    committed   True for an answer attempt, False when the answerer left the
        #                      item via backward navigation (time was spent, but it is not an
        #                      attempt); None while the event is open
        #     src  source      what drove the answer (R9) — respondent, interviewer,
        #                      external prefill, synthetic fill
        #
        # `k` is a list ELEMENT, not a dict key, so JSON persistence preserves
        # its int type — no string-key coercion pass is needed here (contrast
        # `roster_outcomes` below).
        self.setdefault("response_timing", [])

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

        # External-input prefill state (QML External Inputs plan, U2).
        #
        #  * `external_provenance`  Per-item provenance marker for outcomes the
        #                           platform AUTO-ANSWERED at survey init from
        #                           an external source (respondent demographics
        #                           / custom_attributes). Shape:
        #                           {item_id: {"source": "<label>"}}. Read by
        #                           the Bronze extractor (U3) so an injected
        #                           value is distinguishable from a respondent's
        #                           own answer (R12). A normal answer is absent
        #                           here (unmarked). The `source` is a
        #                           human-readable mapping label (e.g.
        #                           "custom_attributes.rotate_out"), NOT the PII
        #                           value itself.
        #  * `external_inputs_applied`  One-shot sentinel: True once the U2
        #                           resolver has run for this survey. Both
        #                           runtimes re-construct the FlowProcessor on
        #                           every call, so the resolver checks this
        #                           before applying to avoid re-injecting (and
        #                           re-running external codeBlocks) on a
        #                           re-entrant init.
        self.setdefault("external_provenance", {})

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
        - Response timing log
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
        self["response_timing"] = []

        # Clear roster runtime state. `roster_outcomes` is per-iteration answer
        # storage; `roster_iter` and `roster_active_keys` are transient pass state.
        self["roster_outcomes"] = {}
        self["roster_iter"] = {}
        self["roster_active_keys"] = {}

        # Clear Group `count`-cap runtime state. `group_asked` is the per-pass
        # drawn-slot list — wholly transient.
        self["group_asked"] = {}

        # Clear external-input prefill state so a reset re-injects from source
        # (the sentinel and per-item provenance markers must not survive a
        # wholesale outcome reset — the resolver re-runs on the next init).
        self["external_provenance"] = {}
        self.pop("external_inputs_applied", None)

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

    # ------------------------------------------------------------------
    # External-input prefill state (QML External Inputs plan, U2)
    # ------------------------------------------------------------------

    def set_external_provenance(self, item_id: str, source: str) -> None:
        """Mark an item's outcome as externally supplied, recording its source.

        Called at the auto-answer seam (U2 resolver) after a successful
        ``process_item``. ``source`` is a non-PII mapping label — the respondent
        field / ``custom_attributes`` key the value came from — never the value.
        """
        self.setdefault("external_provenance", {})[item_id] = {"source": source}

    def get_external_provenance(self, item_id: str) -> dict[str, Any] | None:
        """The provenance marker for an item, or None if it was not prefilled."""
        return self.get("external_provenance", {}).get(item_id)

    def is_externally_supplied(self, item_id: str) -> bool:
        """True iff this item's outcome was auto-answered from an external source."""
        return item_id in self.get("external_provenance", {})

    def external_inputs_applied(self) -> bool:
        """True once the U2 resolver has run for this survey (re-entrancy guard)."""
        return bool(self.get("external_inputs_applied", False))

    def mark_external_inputs_applied(self) -> None:
        """Set the one-shot sentinel so a re-entrant init does not re-inject."""
        self["external_inputs_applied"] = True

    # ------------------------------------------------------------------
    # Per-answer response timing (R7-R10, R12)
    # ------------------------------------------------------------------
    #
    # The log is APPEND-ONLY: backward navigation closes an event as
    # uncommitted, it never removes one. An item answered, revisited, and
    # re-answered therefore carries several events, which is what makes
    # per-attempt durations and attempt counts recoverable. See the
    # `response_timing` block in __init__ for the event encoding.

    def current_iter_key(self, item_id: str) -> int | None:
        """The Roster iteration this item is currently being answered for.

        None outside a Roster pass, and for an item the state has no record of.
        Single-sited because every timing seam — the presentation endpoints, the
        navigation endpoints, and ``process_item`` — must derive the event's key
        the same way; a seam that derived it differently would open an event no
        other seam could ever close.
        """
        item = self.get_item(item_id)
        block_id = item.get("blockId") if item else None
        return self.get_current_roster_iter(block_id) if block_id else None

    def _find_open_timing_event(self, item_id: str, iter_key: int | None) -> dict[str, Any] | None:
        """The still-open event for this (item, iteration), or None.

        Open means presented but not yet submitted (``s`` is None). Scans from
        the end because the event being looked for is, in every runtime path,
        the most recent one for that pair.
        """
        for event in reversed(self.get("response_timing", [])):
            if event["i"] == item_id and event["k"] == iter_key and event["s"] is None:
                return event
        return None

    def open_timing_event(self, item_id: str, iter_key: int | None, source: str) -> None:
        """Stamp the presentation moment for an item — once per (item, iteration).

        Idempotent by design, and that is load-bearing: the flow's current-item
        endpoint is a GET that re-runs on every page render, refresh, and
        resume. A second call while the pair is still open keeps the ORIGINAL
        presentation moment, so a respondent who refreshes twice does not have
        their own clock reset under them. Re-stamping would systematically
        under-report duration while still producing entirely plausible numbers,
        which is why this guard lives here rather than in each caller.

        Args:
            item_id: The item being presented.
            iter_key: Roster iteration key (power-of-2 bit); None outside a Roster.
            source: What drives this answer (R9), one of ``TIMING_SOURCES``.
                Required — the caller's driver knows it and there is no
                defensible default.
        """
        if source not in TIMING_SOURCES:
            # Loud, for the same reason add_warning refuses an unknown severity:
            # source is what separates human timing from machine timing, so a
            # typo would quietly pull synthetic fills into a respondent-duration
            # median that still looks entirely plausible.
            raise ValueError(
                f"Unknown timing source {source!r}; expected one of {sorted(TIMING_SOURCES)}"
            )

        if self._find_open_timing_event(item_id, iter_key) is not None:
            return
        self.setdefault("response_timing", []).append(
            {
                "i": item_id,
                "k": iter_key,
                "p": _now_ms(),
                "s": None,
                "c": None,
                "src": source,
            }
        )

    def close_timing_event(self, item_id: str, iter_key: int | None, committed: bool) -> None:
        """Stamp the submission moment on this (item, iteration)'s open event.

        Timestamps are recorded verbatim (R8) — no cap, trim, or idle
        adjustment. A long span is a real observation about the respondent, and
        deciding what counts as implausible belongs to the analysis layer that
        can see the distribution, not to the capture point.

        Args:
            item_id: The item being left.
            iter_key: Roster iteration key (power-of-2 bit); None outside a Roster.
            committed: True when this was an answer attempt; False when the
                answerer left via backward navigation — the time was genuinely
                spent (so the event stays, feeding visit totals) but it does not
                count as an attempt.
        """
        event = self._find_open_timing_event(item_id, iter_key)
        if event is None:
            # No open event means a submission seam fired without a matching
            # presentation seam. Nothing to stamp, and inventing a presentation
            # moment would fabricate a duration — log it so the gap is
            # detectable rather than silently absent from the log.
            self.logger.warning(
                "close_timing_event: no open timing event for item=%s iter_key=%s",
                item_id,
                iter_key,
            )
            return
        event["s"] = _now_ms()
        event["c"] = committed

    def install_synthetic_timing(
        self,
        pairs: list[tuple[str, int | None]],
        spans_ms: list[int],
        end_at_ms: int | None = None,
    ) -> None:
        """Replace the timing log with a coherent synthetic timeline.

        Generated answers get generated durations. The live seams cannot supply
        them: a machine driver opens and closes an event inside one call, so
        every span it records is zero — honest, but it leaves a mass-filled
        tenant unable to show what the timeline looks like at all.

        Spans are laid end-to-end backwards from ``end_at_ms`` (normally the
        survey's completion moment), so the events read as one sitting rather
        than as overlapping intervals that no respondent could have produced.

        Refuses to touch a log containing any non-synthetic event. That is the
        load-bearing guard: without it this method could overwrite a real
        respondent's measured timing with invented numbers that look exactly as
        plausible, and nothing downstream could tell the difference. Every event
        it writes is tagged ``SOURCE_SYNTHETIC``, which keeps the analysis layer
        excluding them from speeder detection and duration medians.

        Args:
            pairs: (item_id, iter_key) in the order they were answered.
            spans_ms: Duration for each pair; must be the same length.
            end_at_ms: Epoch ms the last span ends at; defaults to now, which
                is what a fill job wants. A backfill of historical surveys
                passes the survey's own completion moment instead, so the
                timeline does not claim the answers were given during the
                backfill run.

        Raises:
            ValueError: On a length mismatch, or when the existing log holds an
                event from any source other than synthetic.
        """
        if len(pairs) != len(spans_ms):
            raise ValueError(
                f"pairs and spans_ms must align; got {len(pairs)} pairs, {len(spans_ms)} spans"
            )

        existing = self.get("response_timing", [])
        foreign = {event.get("src") for event in existing} - {SOURCE_SYNTHETIC}
        if foreign:
            raise ValueError(
                f"refusing to synthesize timing over measured events from {sorted(foreign)}"
            )

        events = []
        cursor = _now_ms() if end_at_ms is None else end_at_ms
        for (item_id, iter_key), span in zip(reversed(pairs), reversed(spans_ms), strict=True):
            events.append(
                {
                    "i": item_id,
                    "k": iter_key,
                    "p": cursor - span,
                    "s": cursor,
                    "c": True,
                    "src": SOURCE_SYNTHETIC,
                }
            )
            cursor -= span
        events.reverse()
        self["response_timing"] = events

    def has_open_timing_event(self, item_id: str, iter_key: int | None) -> bool:
        """True while this (item, iteration) is presented but not yet submitted.

        Read by the navigation seams, which close an event only *if* one is
        open: a respondent who steps back has usually already had their answer
        saved (and the event closed) by the convenience save that precedes the
        step, so an unconditional close there would log a missing-event warning
        on every ordinary back navigation and drown the real signal.
        """
        return self._find_open_timing_event(item_id, iter_key) is not None

    def get_timing_events(self) -> list[dict[str, Any]]:
        """Every timing event, in the order they were opened."""
        return self.get("response_timing", [])

    def get_timing_events_for_item(self, item_id: str) -> list[dict[str, Any]]:
        """This item's timing events, in order, across every iteration.

        Consumers that need one Roster iteration's attempts filter the result on
        the event's ``k``; the same item under two iteration keys is two
        independent answers, not two attempts at one.
        """
        return [event for event in self.get("response_timing", []) if event["i"] == item_id]

    def count_timing_attempts(self, item_id: str, iter_key: int | None) -> int:
        """How many times this (item, iteration) was actually answered (R12).

        Counts committed events only, so a pass-through on backward navigation
        and a still-open event are both excluded — the single place the
        committed rule is applied, so consumers cannot each decide differently.
        """
        return sum(
            1
            for event in self.get("response_timing", [])
            if event["i"] == item_id and event["k"] == iter_key and event["c"]
        )

    def drop_timing_events_for_item(self, item_id: str) -> None:
        """Remove every timing event for an item, across all iterations.

        Called when a capped-Group draw evicts a previously-asked item: the log
        is append-only for the ordinary answer path, but an evicted item's
        answer is dropped from the record entirely (its outcome and history
        entry are cleared too), so its timing must go with it. Left behind, the
        orphaned events would be double-counted when the same item is re-drawn —
        both in per-visit totals and in the per-answer durations Bronze carries.
        A capped-Group item has no per-iteration identity (iter_key is always
        None), so dropping by item id removes all of its events.
        """
        self["response_timing"] = [
            event for event in self.get("response_timing", []) if event["i"] != item_id
        ]

    # ------------------------------------------------------------------
    # Degradation warnings (R14, R19, R20)
    # ------------------------------------------------------------------
    #
    # A warning records a point where the engine degraded instead of failing:
    # it kept an answer, a path, or a half-built variable state that its own
    # rules would have rejected. Severity is keyed on the DATA consequence, not
    # on which subsystem raised it, so a cosmetic label drop never ranks beside
    # a corrupted branch.

    def add_warning(self, item_id: str, warning_type: str, message: str, *, severity: str) -> None:
        """
        Record a degradation the engine absorbed during flow processing.

        Deduplicates on ``(item_id, iter_key, type)``: a repeat increments
        ``count`` and moves ``last_seen`` rather than appending. A re-answered
        item re-raises the same evaluation error on every pass, so without this
        one defect reads as several.

        ``block_id`` and ``iter_key`` are derived here from the state rather
        than passed in — every call site would otherwise have to re-derive the
        same two lookups, and a site that got them wrong would misattribute a
        warning to the wrong Roster iteration.

        Args:
            item_id: The item where the degradation occurred.
            warning_type: What degraded — 'precondition', 'postcondition',
                'codeblock', 'roster_iterate_over', 'roster_mask_undeclared',
                'item_missing', or an 'external_prefill_<gate>' decline.
            message: Human-readable description; never carries a respondent's
                answer value.
            severity: Data consequence, one of ``WARNING_SEVERITIES``.
                'critical' — the accepted data may be wrong (a code block that
                raised part-way); this is what excludes a survey from dataset
                construction. 'degraded' — the engine kept an answer or a path
                its own rules would have rejected. 'informational' — the
                dataset is unaffected.
        """
        if severity not in WARNING_SEVERITIES:
            # Loud, because severity is what a dataset-exclusion gate reads: a
            # typo would silently downgrade a corrupted survey to noise.
            raise ValueError(
                f"Unknown warning severity {severity!r}; expected one of {sorted(WARNING_SEVERITIES)}"
            )

        item = self.get_item(item_id)
        block_id = item.get("blockId") if item else None
        # A Roster item's warning belongs to the iteration it happened in — the
        # same error under two iterations is two distinct occurrences, not one
        # repeated. None outside a Roster pass, and for an item the state has
        # no record of at all.
        iter_key = self.get_current_roster_iter(block_id) if block_id else None

        now = _now_ms()
        warnings = self.setdefault("warnings", [])
        for existing in warnings:
            if (
                existing["item_id"] == item_id
                and existing["iter_key"] == iter_key
                and existing["type"] == warning_type
            ):
                existing["count"] += 1
                existing["last_seen"] = now
                return

        warnings.append(
            {
                "item_id": item_id,
                "block_id": block_id,
                "iter_key": iter_key,
                "type": warning_type,
                "severity": severity,
                "message": message,
                "count": 1,
                "first_seen": now,
                "last_seen": now,
            }
        )

    def get_warnings(self) -> list[dict[str, Any]]:
        """Get all warnings collected during flow processing."""
        return self.get("warnings", [])

    def has_warnings(self) -> bool:
        """Check if any warnings were collected."""
        return len(self.get("warnings", [])) > 0
