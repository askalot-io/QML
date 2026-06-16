"""
FlowProcessor - Flow Mode Implementation for QML Navigation

This processor handles runtime navigation for survey flow:
- Uses pre-computed topological order from QMLTopology for navigation path
- Evaluates preconditions dynamically at runtime (NOT using Z3)
- Optimized for performance (no expensive Z3 item classification during navigation)
- Tracks full navigation history for robust backward navigation
- Skips visited items when unvisited items remain ahead

Architecture:
1. Z3 Usage (initialization only):
   - Builds dependency graph via StaticBuilder
   - Detects cycles via QMLTopology
   - Computes stable topological order (Kahn's algorithm)

2. Runtime Navigation (no Z3):
   - Iterates through pre-computed navigation path
   - Evaluates preconditions via Python expressions
   - Tracks visited/isLast state attributes
   - Returns first item with satisfied preconditions

Uses the common QMLEngine pipeline for topology analysis.
"""

import copy
import logging
from typing import Any

from askalot_qml.core.python_runner import PythonRunner
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.item_proxy import ItemProxy
from askalot_qml.models.qml_state import QMLState


class FlowProcessor:
    """
    Flow mode processor for runtime survey navigation.

    Provides:
    - Pre-computed topological navigation path
    - Graph data generation for flow visualization
    - Current item tracking and bidirectional navigation
    - Performance-optimized (no Z3 during navigation)

    Navigation strategy:
    1. Initialization (uses Z3 once):
       - Builds dependency graph from preconditions/postconditions/code blocks
       - Detects cycles via Z3 satisfiability checking
       - Computes stable topological order (Kahn's algorithm preserving QML order)

    2. Forward Navigation (no Z3):
       - Iterates through pre-computed navigation path
       - Skips visited items if unvisited items remain ahead
       - Evaluates preconditions dynamically via Python eval
       - Returns first item with satisfied preconditions

    3. Backward Navigation:
       - Uses navigation history stack (list of visited item IDs)
       - Pops current item and marks as unvisited
       - Returns to previous item from history

    State attributes:
    - visited: Item has been completed by user
    - isLast: Last item in survey (completion marker)
    """

    def __init__(self, questionnaire_state: QMLState):
        """
        Initialize flow processor with questionnaire state.

        This constructor creates a full QMLEngine (which includes Z3 topology analysis).
        For already-initialized surveys, use from_cached_state() instead to skip Z3.

        Args:
            questionnaire_state: The questionnaire to process
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state
        self.python_runner = PythonRunner()
        self.topology: QMLTopology | None = None

        # Use unified engine for common pipeline
        self.engine = QMLEngine(questionnaire_state)
        self.topology = self.engine.topology

        # Only initialize the questionnaire if it hasn't been initialized yet
        # Check if navigation_path exists as a marker of initialization
        if not questionnaire_state.get_navigation_path():
            self._initialize_questionnaire(questionnaire_state)
            self.logger.info("Questionnaire initialized for the first time")
        else:
            self.logger.debug("Questionnaire already initialized, skipping initialization")

        self.logger.info(f"FlowProcessor initialized for {len(self.engine.get_items())} items")

    @classmethod
    def from_cached_state(cls, questionnaire_state: QMLState) -> "FlowProcessor":
        """Create a lightweight FlowProcessor without Z3/QMLEngine initialization.

        Use this when the survey is already initialized (has navigation_path cached).
        Skips QMLEngine/StaticBuilder/QMLTopology creation entirely, avoiding Z3 overhead.

        Runtime navigation (get_current_item, process_item) only needs:
        - PythonRunner for precondition/postcondition evaluation
        - The cached navigation path from questionnaire_state

        Args:
            questionnaire_state: Already-initialized QMLState with cached navigation path
        """
        instance = cls.__new__(cls)
        instance.logger = logging.getLogger(__name__)
        instance.state = questionnaire_state
        instance.python_runner = PythonRunner()
        instance.topology = None
        instance.engine = None
        instance.logger.debug("FlowProcessor created from cached state (no Z3)")
        return instance

    def _evaluate_condition(
        self,
        condition_expr: str,
        context: dict[str, Any],
        item_id: str = None,
        condition_type: str = "condition",
    ) -> bool:
        """
        Evaluate a condition expression in the given context.

        Args:
            condition_expr: The Python expression to evaluate
            context: Variables and item proxies available for evaluation
            item_id: Optional item ID for warning collection
            condition_type: Type of condition ('precondition', 'postcondition')

        Returns:
            - True if condition expression evaluates to truthy value
            - True if expression cannot be evaluated (unsupported AST constructs,
              missing variables, type errors, etc.) - a warning is logged to
              QMLState for data analysis
            - False if condition expression evaluates to falsy value

        Design rationale:
            When evaluation fails due to unsupported Python features or runtime errors,
            we "fail open" by returning True. This ensures items are shown even with
            evaluation errors, allowing data collection. Warnings are recorded in
            QMLState.warnings for post-survey analysis.
        """
        if not condition_expr:
            return True  # If no condition, it's always satisfied

        try:
            return self.python_runner.eval_expr(expr=condition_expr, **context)
        except Exception as e:
            # Warning because this indicates malfunction or unrecognized Python elements
            # Assume True to show the item anyway - better to collect data than skip
            warning_msg = (
                f"Unable to evaluate {condition_type} '{condition_expr}': {e}. "
                f"Assuming condition is True."
            )
            self.logger.warning(warning_msg)

            # Collect warning in QMLState for data processing analysis
            if item_id:
                self.state.add_warning(item_id, condition_type, warning_msg)

            return True

    def _execute_code_block(
        self, code_block: str, context: dict[str, Any], item_id: str = None
    ) -> dict[str, Any]:
        """
        Execute a code block in the given context and return the updated context.

        Args:
            code_block: Python code to execute
            context: Variables and item proxies available for execution
            item_id: Optional item ID for warning collection

        Returns:
            Updated context dictionary. On error, returns original context unchanged
            and logs a warning (collected in QMLState for data analysis).
        """
        if not code_block:
            return context  # No code block means no changes to context

        try:
            # Execute code and get the updated context
            result = self.python_runner.run_code(code=code_block, **context)
            return result
        except Exception as e:
            warning_msg = f"Error executing code block: {e}. Context unchanged."
            self.logger.warning(warning_msg)

            # Collect warning in QMLState for data processing analysis
            if item_id:
                self.state.add_warning(item_id, "codeblock", warning_msg)

            return context

    def _initialize_questionnaire(self, questionnaire_state: QMLState) -> None:
        """
        Initialize questionnaire state and build topology.
        This should only be called once when first loading a questionnaire.

        Args:
            questionnaire_state: The questionnaire state object
        """
        # Topological order is always available (cycle members linearized in file order)
        questionnaire_state.set_navigation_path(self.topology.topological_order)
        self.logger.info(f"Stored navigation path ({len(self.topology.topological_order)} items)")

        # Check for cycles
        if self.topology.has_cycles:
            cycles_str = ", ".join([" -> ".join(cycle) for cycle in self.topology.cycles])
            self.logger.warning(f"Questionnaire has cycles: {cycles_str}")

        # Create initial context with item proxies
        init_context = {}

        all_items = questionnaire_state.get_all_items()

        # Create ItemProxy for each item in the context (roster items get the
        # dict-shaped `outcomes` accessor when their block has any persisted
        # roster_outcomes — typically empty during init).
        for item in all_items:
            item_proxy = self._build_item_proxy(item)
            init_context[item["id"]] = item_proxy

        # Execute questionnaire initialization code block
        init_context = self._execute_code_block(questionnaire_state.get_code_init(), init_context)

        # update the outcomes of all the items from the init context
        variables = {k: v for k, v in init_context.items() if not isinstance(v, ItemProxy)}
        for item in all_items:
            item_proxy = init_context[item["id"]]
            # Convert the simplified outcome back to the storage format
            item["outcome"] = item_proxy.to_outcome()
            # Ensure visited field is always present
            item["visited"] = False

            context = {}  # create a context for the item

            # copy the variables from the init context to the item's context.
            for var_key, var_value in variables.items():
                context[var_key] = copy.deepcopy(var_value)

            item["context"] = context

    def _build_item_proxy(self, item: dict[str, Any]) -> ItemProxy:
        """
        Construct an ItemProxy, threading roster outcomes through if applicable.

        For items that belong to a Roster (`_roster_block_id` tag set by U1
        loader), pass the per-iteration outcomes dict for the block so the proxy
        can expose the dict-shaped `outcomes` attribute used by outside-roster
        reads (e.g. `q_satisfaction.outcomes[4]` from a post-roster codeBlock).
        Inner-roster reads of `q.outcome` (singular) work via the snapshot/restore
        layer below — `item['outcome']` is set to the current iteration's value
        before any precondition or codeBlock runs.
        """
        block_id = item.get("_roster_block_id")
        if block_id:
            roster_block = self.state.get("roster_outcomes", {}).get(block_id, {})
            return ItemProxy(item, roster_outcomes_for_block=roster_block)
        return ItemProxy(item)

    def _decorate_with_roster_progress(self, item: dict[str, Any]) -> dict[str, Any]:
        """
        Attach current-iteration metadata to a roster item before returning it
        to a caller (MCP `get_survey_current_item`, HTTP flow blueprint).

        Adds three fields when the item belongs to a roster:
          - `_roster_current_key`: the bit-value label key for the active iteration
          - `_roster_current_label`: the human-readable label from `_roster_labels`
          - `_roster_iteration_index`: 1-based ordinal among active keys
          - `_roster_iteration_count`: total active iterations for this pass

        Non-roster items are returned unchanged. Mutates `item` in place and
        returns it for call-site ergonomics.

        These fields are advisory — they let a UI render "Breakfast (1 of 2)"
        without the client re-fetching `roster_active_keys` from state. Not
        stored in the DB (items never serialize the runtime state again after
        the caller receives them); the authoritative roster state is still
        `state['roster_iter']` / `state['roster_active_keys']`.
        """
        block_id = item.get("_roster_block_id")
        if not block_id:
            return item
        iter_key = self.state.get_current_roster_iter(block_id)
        if iter_key is None:
            return item
        active_keys = self.state.get_roster_active_keys(block_id) or []
        # Coerce label keys to int for lookup (JSON roundtrip turns them into
        # strings — same reason the _enter_roster_pass coercion exists).
        raw_labels = item.get("_roster_labels", {})
        labels = {int(k): v for k, v in raw_labels.items()}
        item["_roster_current_key"] = iter_key
        item["_roster_current_label"] = labels.get(iter_key)
        try:
            item["_roster_iteration_index"] = active_keys.index(iter_key) + 1
        except ValueError:
            # iter_key should always be in active_keys — defensive guard for
            # state corruption (e.g., a codeBlock mutated active_keys directly).
            item["_roster_iteration_index"] = None
        item["_roster_iteration_count"] = len(active_keys)
        return item

    def _restore_roster_outcomes_for_iter(self, block_id: str, iter_key: int) -> None:
        """
        Restore item['outcome'] for every roster item in a block to its stored
        value for `iter_key` (or None if the iteration hasn't been visited yet).

        Called at roster entry, on iter advancement, and on backward-navigation
        re-entry. Together with the snapshot in `_snapshot_roster_outcomes`, this
        keeps the canonical `process_item` flow oblivious to roster semantics —
        it always sees a single coherent outcome per item.
        """
        iter_outcomes = self.state.get_roster_outcomes_for_iter(block_id, iter_key)
        for roster_item in self.state.get_items_by_block(block_id):
            item_id = roster_item["id"]
            canonical = iter_outcomes.get(item_id)
            if canonical is None:
                roster_item["outcome"] = None
            else:
                # Wrap canonical → storage via the ItemProxy roundtrip.
                proxy = ItemProxy(roster_item)
                proxy.outcome = canonical
                roster_item["outcome"] = proxy.to_outcome()

    def _snapshot_roster_outcomes(self, block_id: str, iter_key: int) -> None:
        """
        Capture every roster item's current outcome into roster_outcomes for the
        given iter_key. Called after process_item to persist the user's response
        AND any sibling items mutated by the codeBlock.
        """
        for roster_item in self.state.get_items_by_block(block_id):
            storage = roster_item.get("outcome")
            if storage is None:
                # Skip empty cells — get_roster_outcomes_for_item drops them anyway.
                continue
            proxy = ItemProxy(roster_item)
            self.state.set_roster_outcome(block_id, iter_key, roster_item["id"], proxy.outcome)

    def _enter_roster_pass(
        self, item: dict[str, Any], all_items: list[dict[str, Any]]
    ) -> list[int] | None:
        """
        Evaluate iterateOver, freeze active_keys, and prime the roster pass.

        Returns the active_keys list if the pass is entered (possibly with
        zero iterations to traverse if mask=0), or None if iterateOver
        evaluation hit an unrecoverable error (a warning is logged in that
        case and the caller should mark all roster items visited so the
        navigation walk skips past them).

        Implements the "iterateOver evaluated exactly once per roster entry,
        not between iterations" invariant from the plan: result is frozen in
        `state['roster_active_keys'][block_id]` for the duration of the pass.
        """
        block_id = item["_roster_block_id"]
        iterate_over_expr = item.get("_roster_iterate_over", "")

        # Coerce label keys to int. They arrive as ints in-memory (from the QML
        # loader) but after a DB roundtrip they come back as strings because
        # JSON object keys are always strings. Coercing here keeps the rest of
        # the method (mask & k, sorted(...)) working with native ints.
        raw_labels = item.get("_roster_labels", {})
        labels = {int(k): v for k, v in raw_labels.items()}

        # Evaluate iterateOver in the current item's context (with all ItemProxies bound).
        eval_context = copy.deepcopy(item.get("context", {}))
        for other_item in all_items:
            eval_context[other_item["id"]] = self._build_item_proxy(other_item)

        try:
            # Use eval_value (raw) — eval_expr applies bool() coercion which would
            # turn a perfectly good int-bitmask like 7 into True.
            mask = self.python_runner.eval_value(expr=iterate_over_expr, **eval_context)
        except Exception as e:
            warning = (
                f"iterateOver expression {iterate_over_expr!r} raised: {e}; skipping roster pass."
            )
            self.logger.warning(warning)
            self.state.add_warning(item["id"], "roster_iterate_over", warning)
            return None

        if not isinstance(mask, int) or isinstance(mask, bool) or mask < 0:
            warning = (
                f"iterateOver expression {iterate_over_expr!r} resolved to {mask!r} "
                f"(must be a non-negative int); skipping roster pass."
            )
            self.logger.warning(warning)
            self.state.add_warning(item["id"], "roster_iterate_over", warning)
            return None

        # Walk set bits low-to-high, intersect with declared labels.
        # (Bits set in mask but NOT in labels are silently ignored — defensive,
        # since loader validation typically prevents this in v1.)
        active_keys = sorted(k for k in labels.keys() if mask & k)
        self.state.set_roster_active_keys(block_id, active_keys)

        if active_keys:
            self.state.set_current_roster_iter(block_id, active_keys[0])
            self._restore_roster_outcomes_for_iter(block_id, active_keys[0])
            # Mark all roster items unvisited so the navigation walk picks them up.
            for ri in self.state.get_items_by_block(block_id):
                ri["visited"] = False

        return active_keys

    def _effective_conditions(self, item: dict[str, Any], field: str) -> list[dict[str, Any]]:
        """Compose block-level and item-level conditions for evaluation.

        Since R25 (2026-05-14) the loader no longer prepends block
        pre/postconditions onto items. Consumers that need the merged
        view assemble it at evaluation time: block conditions take effect
        BEFORE item conditions, mirroring the historical merge order.

        ``field`` is either ``'precondition'`` or ``'postcondition'``.
        Returns an empty list when neither scope declares anything.
        """
        block_id = item.get("blockId")
        block = self.state.get_block(block_id) if block_id else None
        block_conds: list[dict[str, Any]] = list(block.get(field) or []) if block else []
        item_conds: list[dict[str, Any]] = list(item.get(field) or [])
        return block_conds + item_conds

    def _sample_canonical_order(self, block_id: str, block_item_ids: set[str]) -> list[str]:
        """Build the single canonical contiguous-tree-block order for a Sample
        block — IDENTICAL construction to U4's validation-time ordering.

        Reproduces ``StaticBuilder._emit_sample_conditional_presence``:
          1. block-scoped connected components over the *real* StaticBuilder
             dependency graph (``get_block_scoped_components`` — cross-block
             edges do NOT merge components);
          2. components ordered by their earliest member's index in the
             questionnaire-wide topological order;
          3. intra-component order = that same cycle-tolerant topo
             linearization, emitted contiguously.

        This is exactly U4's ``orderings[0]`` for ``is_random=false``/``T<=1``
        and the IDENTITY permutation for ``is_random=true``. Every
        `is_random=true` permutation this method's caller produces is therefore
        one of U4's validated orderings (U4 enumerates every component
        permutation; the runtime freezes one of them).

        Topology is needed only at FIRST entry (when the order is frozen and
        persisted). A throwaway ``QMLTopology`` over the same state/StaticBuilder
        is built when the lightweight cached-state processor has no engine —
        byte-identical graph to the one ``QMLEngine`` builds.
        """
        topology = self.topology
        if topology is None:
            # Lightweight (from_cached_state) path with no engine: rebuild the
            # same dependency graph U4 / QMLEngine build. Local import: same
            # circular-import idiom static_builder uses for qml_topology.
            from askalot_qml.core.qml_topology import QMLTopology
            from askalot_qml.z3.static_builder import StaticBuilder

            builder = StaticBuilder(self.state)
            topology = QMLTopology(self.state, builder)
            # Cache so _randomize_sample_order (called immediately after for
            # is_random=True blocks) short-circuits the topology rebuild.
            self.topology = topology

        topo_index = {iid: idx for idx, iid in enumerate(topology.get_topological_order())}
        components = topology.get_block_scoped_components(block_item_ids)
        ordered_components = sorted(
            components,
            key=lambda c: min(topo_index.get(i, len(topo_index)) for i in c),
        ) if components else []
        return [
            iid
            for comp in ordered_components
            for iid in topology.linearize_component(comp, topo_index)
        ]

    def _enter_sample_pass(
        self, item: dict[str, Any], all_items: list[dict[str, Any]]
    ) -> list[str]:
        """Freeze the Sample traversal order and compute this pass's drawn set.

        Mirrors ``_enter_roster_pass`` structurally; diverges only where the
        plan mandates: the ``is_random`` order is frozen for the WHOLE survey
        execution (persisted in ``state['sample_order'][block_id]``) and is
        NOT re-evaluated on re-entry — unlike Roster's iterateOver, which is
        re-evaluated every pass.

        Two-phase per the plan's chosen re-entry rule:

          * **Order** (``sample_order``): frozen at FIRST entry only. For
            ``is_random=false``/single-component it is the canonical
            contiguous-tree-block order; for ``is_random=true`` it is one
            per-execution permutation of the components (intra-component order
            still the fixed topo linearization). Either way it is one of U4's
            validated orderings — same component extraction + topo
            linearization, then (for random) a component-level permutation.

          * **Drawn set** (``sample_asked``): RE-DERIVED every entry. Walk the
            frozen order; an item whose precondition holds consumes an N slot;
            a precondition-False item is passed over for FREE (does not consume
            a slot — R2 / AE1). Stop when N slots are filled or the frozen
            order is exhausted. Eligibility is thus recomputed against current
            answers even though the order slot is frozen (the plan's explicit
            precondition-flip-on-re-entry rule).

        Returns the drawn item_ids (possibly empty — degenerate pass, handled
        by the caller like a Roster empty pass: skip silently, do NOT mark
        visited, preserve last-visited recap).
        """
        block_id = item["_sample_block_id"]
        n = item.get("_sample_n")
        is_random = bool(item.get("_sample_is_random", False))

        block_items = self.state.get_items_by_block(block_id)
        block_item_ids = {bi["id"] for bi in block_items}

        # --- Order: freeze once, persist forever (deliberate divergence) ---
        order = self.state.get_sample_order(block_id)
        if order is None:
            canonical = self._sample_canonical_order(block_id, block_item_ids)
            if is_random and len(block_item_ids) > 0:
                order = self._randomize_sample_order(block_id, canonical)
            else:
                order = canonical
            self.state.set_sample_order(block_id, order)

        # --- Drawn set: re-derive every entry against current eligibility ---
        # `n` is a positive int from U1's loader (schema enforces count>=1);
        # synthesized N<=0 is tolerated → empty draw (no negative-index math).
        drawn: list[str] = []
        if isinstance(n, int) and n > 0:
            for item_id in order:
                if len(drawn) >= n:
                    break
                inner = self.state.get_item(item_id)
                if inner is None:
                    continue
                # Precondition-False items are passed over for FREE — they do
                # NOT consume an N slot (R2). eval via the shared precondition
                # path (block + item conditions, same as every other item).
                if self._check_preconditions(inner, all_items):
                    drawn.append(item_id)
        self.state.set_sample_asked(block_id, drawn)

        if drawn:
            # Mark all inner Sample items unvisited so the forward walk picks
            # up the drawn ones (mirrors the roster entry unvisit).
            for bi in block_items:
                bi["visited"] = False

        return drawn

    def _randomize_sample_order(self, block_id: str, canonical: list[str]) -> list[str]:
        """Permute the contiguous tree-blocks of the canonical order.

        Re-derives the components from the canonical layout (each maximal run
        whose split points are component boundaries is recoverable because the
        canonical order emits each component contiguously), then shuffles the
        BLOCK order while keeping each block's internal order fixed. The
        resulting order is exactly one of U4's enumerated component
        permutations (intra-component order is the fixed topo linearization),
        so it is always one of the orderings U4 proved sound.

        Seeded by ``random`` (per-execution randomisation, plan R3). Frozen by
        the caller into ``sample_order`` so it is reproducible across
        backward-nav and re-entry for the rest of the survey execution.
        """
        import random

        block_items = self.state.get_items_by_block(block_id)
        block_item_ids = {bi["id"] for bi in block_items}
        # Re-extract components so we permute exactly the units U4 enumerated
        # (a list[set]); then map each component to its fixed canonical
        # sub-sequence (its slice of the canonical order, which already is the
        # topo linearization emitted contiguously).
        # _sample_canonical_order (the only caller path) is always invoked
        # immediately before this method and caches self.topology on the
        # from_cached_state path, so it is guaranteed non-None here.
        assert self.topology is not None, (
            "_randomize_sample_order requires self.topology; "
            "_sample_canonical_order must be called first to populate it"
        )
        components = self.topology.get_block_scoped_components(block_item_ids)
        comp_of = {iid: idx for idx, comp in enumerate(components) for iid in comp}
        # Group the canonical order into contiguous component runs.
        runs: list[list[str]] = []
        for iid in canonical:
            cidx = comp_of.get(iid)
            if runs and cidx is not None and comp_of.get(runs[-1][0]) == cidx:
                runs[-1].append(iid)
            else:
                runs.append([iid])
        random.shuffle(runs)
        return [iid for run in runs for iid in run]

    def _check_preconditions(self, item: dict[str, Any], all_items: list[dict[str, Any]]) -> bool:
        """
        Check if item's preconditions are satisfied.

        Block-level preconditions (declared on the item's enclosing block)
        evaluate BEFORE the item's own preconditions — same effective
        semantics as the pre-R25 loader merge. An item is shown only if
        ALL preconditions (block + item) evaluate to True.

        Returns:
            True if all preconditions are satisfied, no preconditions exist,
            or any precondition cannot be evaluated (assumes True on error).
            False only if a precondition explicitly evaluates to False.

            When a precondition cannot be evaluated (unrecognized Python, missing vars),
            a warning is logged and the item is shown anyway to allow data collection.
        """
        effective = self._effective_conditions(item, "precondition")
        if not effective:
            return True  # No preconditions

        # Clone context and add item proxies
        context = copy.deepcopy(item.get("context", {}))
        for other_item in all_items:
            item_proxy = self._build_item_proxy(other_item)
            context[other_item["id"]] = item_proxy

        # Evaluate all preconditions - ALL must be satisfied
        item_id = item.get("id")
        for condition in effective:
            if not self._evaluate_condition(
                condition.get("predicate", ""),
                context,
                item_id=item_id,
                condition_type="precondition",
            ):
                return False

        return True

    def get_current_item(
        self, questionnaire_state: QMLState, backward: bool = False
    ) -> dict[str, Any] | None:
        """
        Get the current item based on preconditions and navigation history.

        Forward navigation strategy:
        1. Iterates through pre-computed navigation path (topological order)
        2. Skips visited items if unvisited items remain ahead
        3. Evaluates preconditions dynamically via Python expressions (NOT Z3)
        4. Items with unsatisfied preconditions are skipped (not shown to user)
        5. Returns first item with satisfied preconditions
        6. Tracks item in navigation history for backward navigation

        Backward navigation strategy:
        1. Pops current item from navigation history
        2. Marks current item as unvisited
        3. Returns to previous item from history stack

        Args:
            questionnaire_state: Current questionnaire state
            backward: Whether to navigate backward

        Returns:
            Item data dict or None if survey is complete
        """
        if not questionnaire_state.get_navigation_path():
            self.logger.error(
                "Navigation path not initialized. Call initialize_questionnaire first."
            )
            return None

        all_items = questionnaire_state.get_all_items()

        # Handle backward navigation
        if backward:
            return self._backward_navigate(questionnaire_state, all_items)

        # Forward navigation - use stored navigation path.
        # For Roster items the path entry is visited once *per active iteration*;
        # the visited flag is reset between iterations (see process_item's iter
        # advancement) so the same path entry serves multiple presentations.
        navigation_path = questionnaire_state.get_navigation_path()

        def is_item_visited(item):
            """Check if an item has been visited by the user.

            Note: We only check the visited flag, NOT outcome values.
            Items may have non-empty outcomes from default values in QML,
            but they're not "visited" until the user has actually seen them.
            """
            if not item:
                return True  # Missing items don't block completion
            return item.get("visited", False)

        def is_item_done(item):
            """Check if an item is done: either visited, in an empty roster pass,
            or has unsatisfied preconditions.

            Items in a Roster whose pass was determined empty (active_keys=[])
            are implicitly done — we recorded the empty pass but never showed them.
            Items with unsatisfied preconditions are implicitly skipped.
            """
            if not item:
                return True
            if item.get("visited"):
                return True
            block_id = item.get("_roster_block_id")
            if block_id is not None:
                active_keys = questionnaire_state.get_roster_active_keys(block_id)
                if active_keys is not None and len(active_keys) == 0:
                    return True  # empty pass already established
            # Sample items: once the pass is entered, an item NOT in the drawn
            # set is implicitly done — it was never shown (precondition-skipped
            # or beyond the N cap). This is the per-item analogue of Roster's
            # empty-pass sentinel; like Roster it does NOT flip the visited
            # flag (preserves the survey's "last item actually visited" recap).
            # A drawn-but-unvisited Sample item is NOT done. Before pass entry
            # (sample_order is None) a Sample item is NOT done so the forward
            # walk proceeds to _enter_sample_pass.
            sample_block_id = item.get("_sample_block_id")
            if sample_block_id is not None:
                if questionnaire_state.has_sample_pass(sample_block_id):
                    if item.get("id") not in questionnaire_state.get_sample_asked(
                        sample_block_id
                    ):
                        return True  # not drawn this pass → implicitly done
                    return False  # drawn + unvisited → still pending
                return False  # pass not entered yet → must enter it
            # Item with unsatisfied preconditions is implicitly done (skipped)
            if not self._check_preconditions(item, all_items):
                return True
            return False

        # Check if all items are already done (survey complete)
        # In this case, return the last item rather than looping
        all_done = all(
            is_item_done(questionnaire_state.get_item(item_id)) for item_id in navigation_path
        )

        if all_done:
            # All items done - return last visited item with isLast flag
            for item_id in reversed(navigation_path):
                item = questionnaire_state.get_item(item_id)
                if item and item.get("visited"):
                    item["isLast"] = True
                    return self._decorate_with_roster_progress(item)
            return None

        # Navigate using the pre-computed path - find next item that needs attention
        for item_id in navigation_path:
            item = questionnaire_state.get_item(item_id)
            if not item:
                continue

            # Skip items already visited
            if is_item_visited(item):
                continue

            # Roster items have an extra preflight: enter the pass on first
            # encounter (eval iterateOver, freeze active_keys, snapshot-restore).
            # If the pass turns out to be empty (mask=0 or no overlapping bits)
            # we record `active_keys=[]` as the sentinel and skip silently —
            # critically WITHOUT marking inner items visited, since they were
            # never shown to the respondent (preserves the survey's "last item
            # actually visited" recap behavior).
            if item.get("_roster_block_id"):
                block_id = item["_roster_block_id"]
                if questionnaire_state.get_roster_active_keys(block_id) is None:
                    active_keys = self._enter_roster_pass(item, all_items)
                    if active_keys is None:
                        # Eval error: record as empty pass and skip.
                        questionnaire_state.set_roster_active_keys(block_id, [])
                        active_keys = []
                if not questionnaire_state.get_roster_active_keys(block_id):
                    # Empty pass — skip silently. is_item_done() below treats
                    # these as done so the all-done check still terminates.
                    continue

            # Sample items: a structurally identical preflight to Roster, but
            # presentation is driven by the FROZEN `sample_order` (which may
            # differ from topological order for is_random=true), not the
            # navigation_path index. On the first encounter of an unvisited
            # Sample inner item we enter the pass (freeze order once, re-derive
            # the drawn set for this pass). We then REDIRECT to the first
            # drawn-and-unvisited item in frozen order so the user sees the
            # block in its frozen sequence. A degenerate pass (zero drawn —
            # all precondition-skipped or N=0) is skipped silently WITHOUT
            # marking inner items visited (Roster empty-pass parity).
            if item.get("_sample_block_id"):
                sblock_id = item["_sample_block_id"]
                if not questionnaire_state.has_sample_pass(sblock_id):
                    self._enter_sample_pass(item, all_items)
                drawn = questionnaire_state.get_sample_asked(sblock_id)
                if not drawn:
                    # Degenerate pass — skip silently. is_item_done() treats
                    # these as done so the all-done check still terminates.
                    continue
                # Redirect to the first drawn item not yet visited, honouring
                # the frozen order rather than the topo navigation_path order.
                frozen = questionnaire_state.get_sample_order(sblock_id) or []
                next_id = next(
                    (
                        iid
                        for iid in frozen
                        if iid in drawn
                        and not (questionnaire_state.get_item(iid) or {}).get("visited")
                    ),
                    None,
                )
                if next_id is None:
                    # Every drawn item visited — block exhausted; skip.
                    continue
                if next_id != item_id:
                    # The topo entry we're on is not the frozen-order next.
                    # Re-resolve to the frozen-order item and present it.
                    item = questionnaire_state.get_item(next_id)
                    item_id = next_id
                    if not item:
                        continue

            # Check preconditions — items with unsatisfied preconditions are skipped
            if self._check_preconditions(item, all_items):
                # Track navigation in questionnaire state. Roster items legitimately
                # appear multiple times in history (once per iteration), so the
                # non-roster uniqueness check (`item_id not in history`) would drop
                # them. Instead, dedup on the (item_id, iter_key) pair against the
                # *last* history entry — that blocks the repeated push caused by
                # idempotent get_current_item calls within a single turn without
                # preventing legitimate cross-iteration re-entries.
                iter_key = None
                block_id = item.get("_roster_block_id")
                if block_id:
                    iter_key = questionnaire_state.get_current_roster_iter(block_id)

                history = questionnaire_state.get_history()
                history_keys = questionnaire_state.get("history_iter_key", [])
                last_entry = (history[-1], history_keys[-1]) if history else (None, None)
                if last_entry != (item_id, iter_key):
                    # Non-roster items also get a stricter "not anywhere in history"
                    # check — they must appear at most once, period.
                    if item.get("_roster_block_id") or item_id not in history:
                        questionnaire_state.add_to_history(item_id, iter_key=iter_key)
                # Defensively clear any stale isLast flag — once we're handing back
                # an item from the active forward walk it is, by definition, not
                # the survey-complete recap. The flag is only set in the all_done
                # / end-of-path branches above.
                item.pop("isLast", None)
                return self._decorate_with_roster_progress(item)
            # else: precondition not satisfied — skip silently

        # Return last visited item if no more items
        visited_items = [item for item in all_items if item.get("visited")]
        if visited_items:
            last_item = visited_items[-1]
            last_item["isLast"] = True
            return self._decorate_with_roster_progress(last_item)

        return None

    def process_item(
        self,
        questionnaire_state: QMLState,
        item_id: str,
        outcome: Any,
        skip_postcondition: bool = False,
    ) -> dict[str, Any]:
        """
        Process an item with the given outcome and return the updated context.
        Updates the item's outcome and context in the questionnaire state.

        Args:
            questionnaire_state: The questionnaire state object
            item_id: The ID of the item to process
            outcome: The outcome value for the item
            skip_postcondition: If True, skip postcondition validation.
                Used for backward navigation where:
                - The item will be marked as unvisited anyway
                - The saved answer is just for convenience (restored when user returns)
                - Real validation happens when user leaves the item going forward

        Returns:
            Dictionary with success status and optional error message or output
        """
        all_items = questionnaire_state.get_all_items()

        # Find the item in the questionnaire state
        current_item = questionnaire_state.get_item(item_id)
        if not current_item:
            self.logger.error(f"Item {item_id} not found in questionnaire state")
            return {"success": False, "message": f"Item {item_id} not found"}

        # Clone the current context to avoid modifying the original
        new_context = copy.deepcopy(current_item["context"])

        # Fill in the new context with the ItemProxies. Roster items get the
        # dict-shaped `outcomes` attribute via _build_item_proxy so that
        # post-roster code (and any inner codeBlock that legitimately reads
        # other iterations) can resolve `q_satisfaction.outcomes[K]`.
        for item in all_items:
            item_proxy = self._build_item_proxy(item)
            if item["id"] == item_id:
                item_proxy.from_outcome(outcome)
            new_context[item["id"]] = item_proxy

        # Validate postcondition (unless skipped for backward navigation)
        # When navigating backward, the item will be marked unvisited and the user
        # must re-validate when leaving forward again. Block-level postconditions
        # (declared on the item's enclosing block) evaluate BEFORE the item's
        # own postconditions — same effective semantics as the pre-R25 merge.
        if not skip_postcondition:
            effective_post = self._effective_conditions(current_item, "postcondition")
            for condition in effective_post:
                if not self._evaluate_condition(
                    condition.get("predicate", ""),
                    new_context,
                    item_id=item_id,
                    condition_type="postcondition",
                ):
                    # Return the hint message instead of just False
                    hint = condition.get("hint", "Postcondition failed")
                    return {"success": False, "message": hint}

        # Execute the code block
        new_context = self._execute_code_block(
            current_item.get("codeBlock"), new_context, item_id=item_id
        )

        # Extract captured output if any
        output_messages = new_context.pop("__output__", [])

        # Update outcomes for all items that may have been modified in the code block
        # and mark them as visited if they now have outcomes
        for item in all_items:
            item_proxy = new_context[item["id"]]
            updated_outcome = item_proxy.to_outcome()

            # If the outcome has changed or is newly set, update it and mark as visited
            if updated_outcome != item.get("outcome"):
                item["outcome"] = updated_outcome
                if updated_outcome is not None:
                    item["visited"] = True

        # The current item is always marked as visited since it was actively processed
        current_item["visited"] = True

        # Propagate variables to all subsequent items
        variables = {k: v for k, v in new_context.items() if not isinstance(v, ItemProxy)}
        found_current_item = False
        for item in all_items:
            # find the current item
            if item["id"] == item_id:
                found_current_item = True
            # if the current item has been found, propagate the variables to the subsequent items
            elif found_current_item:
                for var_name, var_value in variables.items():
                    item["context"][var_name] = copy.deepcopy(var_value)

        # ------------------------------------------------------------------
        # Roster post-processing: snapshot all roster items in the block
        # to roster_outcomes[block_id][iter_key], then advance iter_key if the
        # current iteration is exhausted.
        #
        # Non-roster items: clear active_keys for ALL roster blocks so the next
        # forward encounter re-evaluates iterateOver. This implements the plan's
        # "iterateOver re-evaluated only on roster ENTRY/RE-ENTRY" rule for the
        # mid-survey-mask-change case (e.g., user goes back to q_meals_eaten,
        # picks different meals, then walks the roster again with the new mask).
        # ------------------------------------------------------------------
        roster_block_id = current_item.get("_roster_block_id")
        sample_block_id = current_item.get("_sample_block_id")
        if not roster_block_id:
            # Invalidate all cached roster passes so subsequent forward entries
            # re-evaluate iterateOver against the (potentially modified) state.
            # get_blocks_by_kind returns [] when there are no Roster blocks —
            # the loop is then a constant-time short-circuit.
            for block in questionnaire_state.get_blocks_by_kind("Roster"):
                block_id = block.get("id")
                if block_id:
                    questionnaire_state.clear_roster_iter_state(block_id)
        if not sample_block_id:
            # A non-Sample item was processed: invalidate every Sample block's
            # per-pass DRAWN set so the next forward entry re-derives
            # eligibility against the (potentially modified) state — this is
            # the plan's precondition-flip-on-re-entry rule. The FROZEN ORDER
            # (`sample_order`) is deliberately NOT cleared here: it survives
            # backward-nav and re-entry for the whole survey execution
            # (divergence from Roster). Only reset() wipes it.
            for block in questionnaire_state.get_blocks_by_kind("Sample"):
                sblock = block.get("id")
                if sblock:
                    questionnaire_state.clear_sample_pass_state(sblock)
        if roster_block_id:
            iter_key = questionnaire_state.get_current_roster_iter(roster_block_id)
            if iter_key is not None:
                # Snapshot the current item AND any sibling roster items the
                # codeBlock may have written through (plan: "captures both the
                # directly-processed item AND any sibling roster items whose
                # outcomes were modified by the codeBlock").
                self._snapshot_roster_outcomes(roster_block_id, iter_key)

                # Has the user (or the codeBlock) finished every still-relevant
                # roster item for this iteration? An item is "relevant" if it's
                # unvisited AND its preconditions are satisfied; one with failing
                # preconditions is implicitly skipped.
                roster_items = questionnaire_state.get_items_by_block(roster_block_id)
                any_pending = any(
                    (not ri.get("visited")) and self._check_preconditions(ri, all_items)
                    for ri in roster_items
                )
                if not any_pending:
                    # Iteration exhausted — try to advance.
                    active_keys = questionnaire_state.get_roster_active_keys(roster_block_id) or []
                    try:
                        current_idx = active_keys.index(iter_key)
                    except ValueError:
                        current_idx = -1

                    if current_idx >= 0 and current_idx + 1 < len(active_keys):
                        # Move to next active iter_key.
                        new_iter = active_keys[current_idx + 1]
                        questionnaire_state.set_current_roster_iter(roster_block_id, new_iter)
                        # Reset visited so each item can be re-presented for the
                        # new iteration; restore outcomes from any prior visit.
                        for ri in roster_items:
                            ri["visited"] = False
                        self._restore_roster_outcomes_for_iter(roster_block_id, new_iter)
                    else:
                        # All iterations done. Mark roster items permanently
                        # visited so the navigation walk advances past them, and
                        # clear pass state so a future re-entry (after backward
                        # navigation) re-evaluates iterateOver.
                        for ri in roster_items:
                            ri["visited"] = True
                        questionnaire_state.clear_roster_iter_state(roster_block_id)

        # ------------------------------------------------------------------
        # Sample post-processing. Sample items are asked at most ONCE (no
        # per-iteration repeat), so there is no snapshot/restore sibling map
        # for outcomes — the item's single outcome lives on item['outcome']
        # via the canonical flow. The only pass bookkeeping is completion:
        # once every drawn item is visited, mark ALL inner Sample items
        # visited (drawn AND non-drawn) so the navigation walk advances past
        # the block and a trailing non-Sample item processed afterwards does
        # NOT re-open the completed pass via clear_sample_pass_state. This
        # mirrors Roster's "all iterations done → mark visited permanently".
        # Pass state is cleared on completion so a future backward-nav
        # re-entry re-derives the drawn set (frozen ORDER persists; only
        # eligibility is recomputed — the plan's re-entry rule).
        # ------------------------------------------------------------------
        if sample_block_id:
            drawn = questionnaire_state.get_sample_asked(sample_block_id)
            sample_items = questionnaire_state.get_items_by_block(sample_block_id)
            all_drawn_visited = all(
                (questionnaire_state.get_item(iid) or {}).get("visited") for iid in drawn
            )
            if all_drawn_visited:
                for si in sample_items:
                    si["visited"] = True
                questionnaire_state.clear_sample_pass_state(sample_block_id)

        # Add output messages to the result if any
        result = {"success": True}
        if output_messages:
            result["output"] = output_messages

        return result

    def _backward_navigate(
        self,
        questionnaire_state: QMLState,
        all_items: list[dict[str, Any]],
    ) -> dict[str, Any] | None:
        """
        Pop one history entry and return the prior item (or None if at start).

        Roster-aware: history entries carry an `iter_key` (None for non-roster).
        - When the popped item is a roster item, its visited flag is reset and
          we ensure pass state matches the iter_key we're returning to.
        - When popping the FIRST entry of a roster pass, the pass is exited
          (state cleared) so a future forward step re-enters via _enter_roster_pass
          and re-evaluates iterateOver.
        - When the new top-of-history is a roster item from a different (or
          re-entered) pass, restore that pass's iter_key and outcomes context.

        Sample-aware: Sample items also use iter_key=None, so the Roster guard
        does not fire for them. A parallel branch checks _sample_block_id: when
        backward-nav pops the last remaining Sample item out of history,
        clear_sample_pass_state wipes sample_asked so the next forward entry
        re-evaluates eligibility from current precondition values. sample_order
        is intentionally preserved (frozen-per-execution rule — R3/R6).
        """
        popped = questionnaire_state.pop_history()
        if popped is None:
            self.logger.warning("No navigation history for backward navigation")
            return None

        current_id, current_iter = popped
        current_item = next((item for item in all_items if item["id"] == current_id), None)
        if current_item:
            current_item["visited"] = False
            # Roster items: also clear pass state if this was the only roster
            # entry for the block (forward will re-enter via _enter_roster_pass).
            if current_iter is not None:
                block_id = current_item.get("_roster_block_id")
                if block_id and not self._block_has_history_entries(questionnaire_state, block_id):
                    # Reset all roster items in the block to unvisited so a fresh
                    # pass entry doesn't get confused; clear pass state.
                    for ri in questionnaire_state.get_items_by_block(block_id):
                        ri["visited"] = False
                    questionnaire_state.clear_roster_iter_state(block_id)
            # Sample items: iter_key is always None, so the Roster guard above
            # never fires. Clear sample_asked so the next forward entry
            # re-derives eligibility from the current precondition values
            # (sample_order is preserved — frozen-per-execution rule).
            sample_block_id = current_item.get("_sample_block_id")
            if sample_block_id and not self._block_has_sample_history_entries(
                questionnaire_state, sample_block_id
            ):
                questionnaire_state.clear_sample_pass_state(sample_block_id)

        # Determine the previous item to return.
        new_history = questionnaire_state.get_history_with_iter()
        if not new_history:
            return None

        prev_id, prev_iter = new_history[-1]
        prev_item = next((item for item in all_items if item["id"] == prev_id), None)
        if not prev_item:
            return None

        # Re-establish roster pass state if the previous item lives in one.
        prev_block_id = prev_item.get("_roster_block_id")
        if prev_iter is not None and prev_block_id:
            # Make sure the pass is active. If it's not (e.g., we exited to a
            # non-roster item and are now navigating back into the roster),
            # re-enter using the same iterateOver eval.
            if questionnaire_state.get_roster_active_keys(prev_block_id) is None:
                self._enter_roster_pass(prev_item, all_items)
            questionnaire_state.set_current_roster_iter(prev_block_id, prev_iter)
            self._restore_roster_outcomes_for_iter(prev_block_id, prev_iter)

        self.logger.debug(f"Backward navigation to: {prev_id} (iter_key={prev_iter})")
        return prev_item

    @staticmethod
    def _block_has_history_entries(state: QMLState, block_id: str) -> bool:
        """True if any remaining history entry belongs to the given roster block."""
        for item_id, iter_key in state.get_history_with_iter():
            if iter_key is None:
                continue
            item = state.get_item(item_id)
            if item and item.get("_roster_block_id") == block_id:
                return True
        return False

    @staticmethod
    def _block_has_sample_history_entries(state: QMLState, block_id: str) -> bool:
        """True if any remaining history entry belongs to the given Sample block.

        Sample items carry iter_key=None (no per-iteration identity), so we
        discriminate by _sample_block_id on the item, not by iter_key.
        """
        for item_id, _iter_key in state.get_history_with_iter():
            item = state.get_item(item_id)
            if item and item.get("_sample_block_id") == block_id:
                return True
        return False

    def get_navigation_path(self) -> list[str]:
        """
        Get the pre-computed navigation path (topological order).

        Returns:
            List of item IDs in topological order (cycle members linearized in file order)
        """
        return self.engine.get_topological_order()

    def get_statistics(self) -> dict[str, Any]:
        """
        Get flow-specific statistics.

        Returns:
            Statistics about the questionnaire flow
        """
        stats = self.engine.get_statistics()

        # Add flow-specific information
        navigation_path = self.get_navigation_path()
        stats.update(
            {
                "flow_mode": True,
                "navigation_path_length": len(navigation_path),
                "navigation_path": navigation_path,
                "can_use_topological_order": not self.engine.has_cycles(),
            }
        )

        return stats

    def debug_dump(self) -> str:
        """Generate debug output for flow processor."""
        lines = []
        lines.append("=" * 60)
        lines.append("FLOW PROCESSOR DEBUG DUMP")
        lines.append("=" * 60)

        stats = self.get_statistics()
        lines.append("\n📊 Flow Summary:")
        lines.append(f"  Navigation path length: {stats['navigation_path_length']}")
        lines.append(f"  Using topological order: {stats['can_use_topological_order']}")
        lines.append(f"  Has cycles: {self.engine.has_cycles()}")

        if self.engine.has_cycles():
            cycles = self.engine.get_cycles()
            lines.append(f"  Number of cycles: {len(cycles)}")

        lines.append("\n📋 Navigation Path:")
        navigation_path = stats["navigation_path"]
        if len(navigation_path) <= 10:
            lines.append(f"  {' → '.join(navigation_path)}")
        else:
            lines.append(
                f"  {' → '.join(navigation_path[:5])} ... {' → '.join(navigation_path[-5:])}"
            )

        # Include engine debug info
        lines.append("\n" + self.engine.debug_dump())

        return "\n".join(lines)
