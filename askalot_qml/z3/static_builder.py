"""
StaticBuilder - Z3-Driven Static Analysis for QML Questionnaires

This module provides Static Single Assignment (SSA) versioning and Z3 constraint
generation for questionnaire analysis. It builds formal models from preconditions,
postconditions, and code blocks to enable dependency discovery and verification.

Moved from processor/ to z3/ as it belongs with other Z3 constraint solving utilities.
"""

import ast
import itertools
import logging
from collections.abc import Callable
from typing import Any

from z3 import (
    And,
    Bool,
    BoolRef,
    BoolVal,
    Context,
    Distinct,
    ExprRef,
    If,
    Implies,
    Int,
    IntVal,
    Not,
    Or,
    Sum,
    is_false,
    is_true,
    simplify,
)

from askalot_qml.models.qml_state import QMLState

# Import profiling - graceful fallback if not available
try:
    from askalot_common.profiling import profile_block
except ImportError:
    from contextlib import contextmanager

    @contextmanager
    def profile_block(name, tags=None):
        yield


class StaticBuilder:
    """
    Manages Static Single Assignment versioning and Z3 constraint generation.

    This class provides the foundation for Z3-driven questionnaire analysis by:
    1. Creating SSA versions for all variable assignments
    2. Building Z3 constraints from preconditions, postconditions, and code blocks
    3. Discovering item dependencies through constraint analysis
    4. Providing compatibility interface for ItemClassifier

    Used by QMLTopology for dependency discovery and topological sorting.
    """

    def __init__(self, questionnaire_state: QMLState):
        """Initialize StaticBuilder with questionnaire state and build constraints."""
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state

        # Isolated Z3 context for thread safety.
        # Z3's global context (main_ctx) is not thread-safe — background threads
        # (watchdog, IPC) can trigger Python GC which corrupts shared AST state.
        # Each StaticBuilder gets its own context so all Z3 objects are isolated.
        self.ctx = Context()

        # SSA version tracking: variable_name -> current_version
        self.version_map: dict[str, int] = {}

        # SSA variable history: variable_name -> [(version, context_item_id)]
        self.version_history: dict[str, list[tuple[int, str]]] = {}

        # Z3 variables for SSA versions
        self.z3_vars: dict[str, ExprRef] = {}  # "var_name_version" -> z3_var

        # Item outcome variables (special handling)
        self.item_vars: dict[str, ExprRef] = {}  # item_id -> z3_var

        # MatrixQuestion per-cell variables — flat per-cell Int representation.
        # Matrix items have NO scalar in self.item_vars; their outcome is
        # the List[List[Any]] of cell values, one Z3 Int per (row, col).
        # Subscript lowering (X.outcome[j][k]) reads from this dict.
        self.item_cells: dict[str, dict[tuple[int, int], ExprRef]] = {}

        # Domain constraints D_i(S_i) - only min/max and enumeration constraints
        # These define the valid value space for each item variable
        # This is B as defined in the thesis: B := ∧_i D_i(S_i)
        self.domain_constraints: list[BoolRef] = []

        # CodeBlock constraints - SSA assignments from codeBlock execution
        # These define relationships between computed variables and item outcomes
        # e.g., var1 = q1.outcome + q2.outcome
        self.codeblock_constraints: list[BoolRef] = []

        # Behavioral constraints from preconditions and postconditions
        # Used for dependency discovery and constraint verification
        # NOTE: These are kept separate from codeblock_constraints for validation
        self.constraints: list[BoolRef] = []

        # Comprehensive dependency graph (items and variables as nodes)
        # Keys: item_id or "var:variable_name"
        # Values: set of dependencies (items or variables)
        self.dependency_graph: dict[str, set[str]] = {}

        # Track which item defines each variable version
        self.variable_definitions: dict[tuple[str, int], str] = {}

        # ItemClassifier compatibility - item details and order
        self.item_details: dict[str, dict[str, Any]] = {}  # Maps item_id to item details
        self.item_order: list[str] = []  # Processing order for ItemClassifier

        # R13: coverage gaps. When ``_ast_to_z3_bool`` returns ``None`` on a
        # condition whose AST contains a clearly-intended-as-constraint node
        # (Call / ListComp / GeneratorExp / Subscript), we record the gap so
        # ``ItemClassifier`` can surface it in its per-item classification and
        # ``validate_qml_file`` can pass it through to authors.
        # Shape: ``{item_id: [{"kind": str, "condition_idx": int, "unsupported_nodes": List[str]}, ...]}``
        self.coverage_gaps: dict[str, list[dict[str, Any]]] = {}

        # ------------------------------------------------------------------
        # U2: shared conditionally-present Z3 primitive.
        #
        # ``present(item, k)`` is a per-(item, selection/iteration-index ``k``)
        # Bool that gates that (item, k)'s domain/precondition/postcondition
        # constraints. It models *item absence* — "this item may or may not be
        # asked for selection index k" — which is a strictly different
        # question from ``_visited_sentinel`` (which gates conditions on
        # *visitation*, i.e. "given the item was reached, its conditions
        # hold"). Both gates compose: an item that is present AND visited
        # carries its conditions; an absent item carries none.
        #
        # **Sort decision (deferred-to-implementation, settled here against
        # the ``_visited_sentinel`` precedent):** ``_visited_sentinel``
        # returns a single ``BoolRef`` for both scalar and matrix items —
        # ``item_var >= 0`` for scalars, ``BoolVal(True)`` for matrices — and
        # does *not* split into two sorts. It splits *values* only because its
        # antecedent is *derived from the item's scalar outcome var*, which
        # matrix items lack. ``present`` is an INDEPENDENT gating Bool, not
        # derived from any outcome var, so the scalar/matrix distinction is
        # irrelevant to it. We therefore use ONE Bool sort across scalar and
        # matrix items: ``Bool(f"present_{item_id}_k{k}", ctx)``. This is the
        # cleaner choice and introduces zero sort-mixing surface (consistent
        # with the no-BitVec / Int-only decision in the plan).
        #
        # ``_present_vars`` is the lazily-populated cache of these Bools.
        # ``_conditionally_present`` is the classification-safety tag set:
        # any (item_id, k) registered here is "absent because not drawn / bit
        # unset" — ItemClassifier / PathBasedValidator MUST NOT report it
        # NEVER / dead-code. With no registrations (every path off Sample /
        # Roster, i.e. all of U2 standalone) the antecedent degrades to the
        # literal True and the primitive is a proven no-op.
        #
        # ``k is None`` is the canonical "single, unconditional selection"
        # key — used by the dedicated wrapping pass below so Sequence/Roster/
        # Sample items share one code path. U3 (Roster) and U4 (Sample) will
        # call ``mark_conditionally_present(item_id, k)`` with concrete int
        # ``k`` and re-wire per-iteration constraints; until then this is
        # inert.
        self._present_vars: dict[tuple[str, int | None], BoolRef] = {}
        self._conditionally_present: set[tuple[str, int | None]] = set()
        # Fast O(1) item_id-only lookup for is_conditionally_present. Kept in
        # sync with _conditionally_present by mark_conditionally_present.
        self._conditionally_present_item_ids: set[str] = set()

        # Per-item domain constraints, collected during pass-1 and flushed
        # (present-gated) into ``self.domain_constraints`` by the dedicated
        # ``_emit_present_gated_domain`` pass. See that method for why this is
        # a separate pass rather than an inline append.
        #
        # U3: the bucket value is a list of *var-parameterized builders*, not
        # pre-bound ``BoolRef``s. Each builder is ``(var) -> BoolRef`` so the
        # SAME domain spec can be re-emitted against the canonical
        # ``item_var`` (``k is None`` — the U2 no-op path, byte-equivalent
        # logically to pre-U2) AND against per-iteration Roster vars
        # (``item_{id}_iter{K}``) without re-extracting min/max/enum from the
        # input spec. The single extraction site stays
        # ``_extract_domain_constraints``; only the binding target varies.
        self._pending_domain_constraints: dict[
            str, list[Callable[[ExprRef], BoolRef]]
        ] = {}

        # Build SSA and constraints
        self._build()

    def _domain_constraint_builders(
        self, item_id: str, item: dict[str, Any]
    ) -> list[Callable[[ExprRef], BoolRef]]:
        """Extract domain constraints D_i(S_i) as *var-parameterized builders*.

        Domain constraints define the valid value space for each item:
        - For Editbox/Slider: min <= S_i <= max
        - For Radio/Dropdown: S_i ∈ {v1, v2, ...}

        These constraints form B (base constraint) as defined in the thesis:
        B := ∧_i D_i(S_i)

        Returns builders ``(var) -> BoolRef`` rather than pre-bound
        ``BoolRef``s so the SAME spec can be bound to the canonical scalar
        ``item_var`` (U2 ``k is None`` path), to each Roster per-iteration var
        ``item_{id}_iter{K}`` (U3), or to a matrix cell var — without
        re-reading min/max/enum from the input spec at every binding site.
        This is the single domain-extraction site; only the bind target and
        the present-gate vary across callers.
        """
        input_spec = item.get("input", {})
        control = input_spec.get("control", "")
        builders: list[Callable[[ExprRef], BoolRef]] = []

        if control in ("Editbox", "Slider", "Range"):
            # Min/max constraints for numeric controls
            min_val = input_spec.get("min")
            max_val = input_spec.get("max")

            if min_val is not None and isinstance(min_val, (int, float)):
                builders.append(lambda v, _m=min_val: v >= _m)
            elif min_val is not None:
                self.logger.warning(
                    f"Unsupported min value type for {item_id}: {type(min_val).__name__}"
                )
            if max_val is not None and isinstance(max_val, (int, float)):
                builders.append(lambda v, _m=max_val: v <= _m)
            elif max_val is not None:
                self.logger.warning(
                    f"Unsupported max value type for {item_id}: {type(max_val).__name__}"
                )

        elif control in ("Radio", "Dropdown", "Checkbox", "Switch"):
            # Enumeration constraint for choice controls
            # labels = {1: "Yes", 2: "No"} → valid values are integer keys
            valid_values: list[int] = []

            labels = input_spec.get("labels")
            if isinstance(labels, dict):
                for k in labels.keys():
                    if isinstance(k, int):
                        valid_values.append(k)
                    else:
                        try:
                            valid_values.append(int(k))
                        except (TypeError, ValueError):
                            pass

            if valid_values:
                # D_i(S_i) = S_i ∈ {v1, v2, ...}
                builders.append(
                    lambda v, _vals=tuple(valid_values): Or(*[v == val for val in _vals])
                )

        return builders

    def _extract_domain_constraints(
        self,
        item_id: str,
        item_var: ExprRef,
        item: dict[str, Any],
        is_cell: bool = False,
    ):
        """Bind this item's domain builders to ``item_var`` and emit them.

        Two distinct callers, two distinct emission policies:

        - **Matrix cells (pass-1, one call per cell, ``is_cell=True``):** the
          cell var is concrete and matrix cells are NEVER conditionally-
          present in U3/U4 scope, so bind immediately and append straight to
          ``self.domain_constraints`` (unconditional — exactly the pre-U2
          behavior for matrices). ``is_cell`` is an explicit flag rather than
          an ``item_id in self.item_cells`` probe because pass-1 calls this
          per-cell *before* ``self.item_cells[item_id]`` is populated.
        - **Scalar items (pass-1, one call per item, ``is_cell=False``):**
          stash the *builders* in ``self._pending_domain_constraints`` so the
          dedicated ``_emit_present_gated_domain`` pass can bind them
          present-gated against the canonical var, and
          ``_emit_roster_bit_guarded_unroll`` can re-bind them against
          per-iteration vars. The scalar bucket key is ``item_id``; matrix
          items never populate it.
        """
        builders = self._domain_constraint_builders(item_id, item)
        if is_cell:
            # Matrix cell binding — concrete cell var, unconditional emit.
            for build in builders:
                self.domain_constraints.append(build(item_var))
        else:
            # Scalar item — defer to the present-gated flush pass.
            self._pending_domain_constraints.setdefault(item_id, []).extend(builders)

    def _emit_present_gated_domain(self) -> None:
        """Dedicated U2 pass: flush per-item domain constraints into the flat
        ``self.domain_constraints`` list, each gated by ``_wrap_present``.

        A SEPARATE pass (not inline append in ``_extract_domain_constraints``)
        for the same reason Pass-3 is separate (see the roster learning): the
        gate key for an item is only knowable after every item is registered,
        and a dedicated pass keeps the gating uniform across scalar / matrix /
        Textarea-adjacent items without threading the present-key through the
        domain extractor. With nothing marked conditionally-present the
        antecedent is the literal True, so ``Implies(True, c) ≡ c`` and the
        flat list is logically identical to the pre-U2 model — the proven
        no-op the plan mandates.

        U3: this emits ONLY the canonical (``k is None``) binding against the
        item's own scalar var. Roster per-iteration domain re-binding (one
        copy per label-key, gated by the bit-guard ``present``) is done
        additively by ``_emit_roster_bit_guarded_unroll`` — keeping this pass
        a pure no-op for every non-Roster item."""
        for item_id, builders in self._pending_domain_constraints.items():
            item_var = self.item_vars.get(item_id)
            if item_var is None:
                # Matrix / Textarea items have no scalar var; their cell-level
                # domain (matrix) was already emitted inline in pass-1 and
                # Textarea has no numeric domain. Nothing to bind here.
                continue
            for build in builders:
                self.domain_constraints.append(
                    self._wrap_present(item_id, None, build(item_var))
                )

    def _visited_sentinel(self, item_id: str) -> BoolRef:
        """Return the antecedent for 'item has been visited' in pre/postcondition implications.

        For scalar items (Editbox, Slider, Radio, …) the visit signal is
        ``item_var >= 0`` — the same antecedent the codebase has used since the
        Z3 work began. For MatrixQuestion items there is no single scalar
        outcome to compare against, so the antecedent collapses to BoolVal(True):
        the implication degenerates to its consequent, which matches the
        runtime semantics that a matrix's pre/postcondition is checked once at
        item processing time, not once per cell.
        """
        if item_id in self.item_vars:
            return self.item_vars[item_id] >= 0
        # Matrix items (and any future kind without a scalar var): unconditional.
        return BoolVal(True, self.ctx)

    # ------------------------------------------------------------------
    # U2: shared conditionally-present primitive
    #
    # Public API consumed by U3 (Roster bit-guarded unroll) and U4 (Sample
    # conditional-presence + ordering). U2 itself only wires the always-True
    # degrade path, proving the primitive is a no-op off Sample/Roster.
    # ------------------------------------------------------------------

    def _present_var(self, item_id: str, k: int | None) -> BoolRef:
        """Return the per-(item, k) ``present`` Z3 Bool, creating it lazily.

        One Bool sort across scalar and matrix items (see ``__init__`` for the
        sort rationale vs the ``_visited_sentinel`` precedent). Stable
        identity: the same ``(item_id, k)`` always yields the same Bool, so
        repeated wiring (domain, every precondition, every postcondition)
        shares one gate. ``k is None`` is the unconditional-selection key.
        """
        key = (item_id, k)
        var = self._present_vars.get(key)
        if var is None:
            suffix = "all" if k is None else str(k)
            var = Bool(f"present_{item_id}_k{suffix}", self.ctx)
            self._present_vars[key] = var
        return var

    def mark_conditionally_present(self, item_id: str, k: int | None = None) -> None:
        """Register ``(item_id, k)`` as conditionally-present (R5/R7).

        Called by U3/U4 for items whose presence is gated by a Roster bit or
        a Sample draw. Two effects:

        1. ``_present_antecedent`` stops degrading to True for this key — the
           gating Bool becomes the real antecedent, so domain/pre/post
           constraints only bind when the item is actually drawn.
        2. ``is_conditionally_present`` reports True, the classification-safety
           tag that keeps ItemClassifier / PathBasedValidator from flagging a
           reachable-but-not-drawn item as NEVER / dead-code.
        """
        self._conditionally_present.add((item_id, k))
        self._conditionally_present_item_ids.add(item_id)

    def is_conditionally_present(self, item_id: str) -> bool:
        """True iff ANY (item_id, k) was marked conditionally-present.

        The classification-safety query. ItemClassifier and
        PathBasedValidator call this to decide whether an unsatisfiable
        precondition means "dead code" (normal item) or "merely not drawn in
        this selection" (Sample/Roster item — must not be NEVER/dead-code).
        Keyed on item_id only: an item that is conditionally-present for any
        selection index is sampling-absent, never dead.
        """
        return item_id in self._conditionally_present_item_ids

    def _present_antecedent(self, item_id: str, k: int | None) -> BoolRef:
        """Return the presence antecedent for an (item, k) constraint.

        - If ``(item_id, k)`` was marked conditionally-present → the gating
          ``present`` Bool: the constraint binds only when the item is drawn.
        - Otherwise → ``BoolVal(True)``: ``Implies(True, C) ≡ C``, so the
          model is byte-identical to the pre-U2 unconditional one. This is
          the proven no-op for every Sequence path (and every Roster/Sample
          path until U3/U4 register keys).
        """
        if (item_id, k) in self._conditionally_present:
            return self._present_var(item_id, k)
        return BoolVal(True, self.ctx)

    def _wrap_present(
        self, item_id: str, k: int | None, constraint: BoolRef
    ) -> BoolRef:
        """Gate ``constraint`` behind the (item, k) presence antecedent.

        ``Implies(present(item, k), constraint)``. When the antecedent
        degrades to True (no registration) this is logically just
        ``constraint`` — the primitive contributes nothing off Sample/Roster.
        """
        return Implies(self._present_antecedent(item_id, k), constraint)

    def _emit_pre_post_under_present(
        self,
        item_id: str,
        k: int,
        effective_pre: list,
        effective_post: list,
        scoped_var,
        canonical_var,
    ) -> None:
        """Emit per-iteration pre/postcondition constraints, present-gated.

        Roster bit-guarded unroll (Pass 3.5) and Sample conditional-presence
        (Pass 3.6) both re-emit each inner item's preconditions and
        postconditions per (item, k) selection, swapping ``self.item_vars[item_id]``
        to a per-iteration var so ``self.outcome`` references in predicates
        lower to the right Z3 variable, and gating the resulting ``Implies``
        behind the presence antecedent. The two call sites were verbatim
        duplicates of each other; this helper holds the shared body.

        ``scoped_var`` is the per-iteration variable to swap in for the
        duration of the emit; ``canonical_var`` is restored in ``finally`` so
        the canonical single-pass model the caller's outer loop assumes is
        unchanged on exit.
        """
        self.item_vars[item_id] = scoped_var
        try:
            for idx, cond in enumerate(effective_pre):
                predicate = cond.get("predicate", "")
                if not predicate:
                    continue
                constraint, _deps = self._build_precondition_constraint(
                    predicate, item_id, idx
                )
                if constraint is not None:
                    self.constraints.append(
                        self._wrap_present(
                            item_id,
                            k,
                            Implies(self._visited_sentinel(item_id), constraint),
                        )
                    )
            for idx, cond in enumerate(effective_post):
                predicate = cond.get("predicate", "")
                if not predicate:
                    continue
                constraint, _deps = self._build_postcondition_constraint(
                    predicate, item_id, idx
                )
                if constraint is not None:
                    self.constraints.append(
                        self._wrap_present(
                            item_id,
                            k,
                            Implies(self._visited_sentinel(item_id), constraint),
                        )
                    )
        finally:
            self.item_vars[item_id] = canonical_var

    def _extract_dependencies_from_ast(self, node: ast.AST) -> set[str]:
        """Extract all dependency references (items AND variables) from AST.

        Returns a set of dependency node names:
        - item_id for item outcome references (e.g., q1.outcome, q1)
        - "var:variable_name" for variable references
        """
        dependencies = set()
        for child in ast.walk(node):
            if isinstance(child, ast.Attribute):
                # Handle q1.outcome pattern (scalar items AND matrix items)
                if isinstance(child.value, ast.Name) and child.attr == "outcome":
                    name = child.value.id
                    if name in self.item_vars or name in self.item_cells:
                        dependencies.add(name)
            elif isinstance(child, ast.Name):
                name = child.id
                if name in self.item_vars or name in self.item_cells:
                    # Direct item reference (scalar or matrix)
                    dependencies.add(name)
                elif name in self.version_map:
                    # Variable reference - track as var: node
                    dependencies.add(f"var:{name}")
        return dependencies

    def _build(self):
        """Build SSA versioning and Z3 constraints from questionnaire state."""
        with profile_block("z3_static_builder_build"):
            self._build_internal()

    def _build_internal(self):
        """Internal build implementation."""
        # First pass: create item outcome variables, extract domain constraints, populate item details
        # Textarea controls have string outcomes — no Z3 integer variable is created for them.
        for item in self.state.get_all_items():
            item_id = item.get("id")
            if item_id:
                # Check if this is a Textarea control (string outcome, not integer)
                input_spec = item.get("input", {})
                control = input_spec.get("control", "")
                kind = item.get("kind", "")

                rows_len: int | None = None
                cols_len: int | None = None

                if control == "Textarea":
                    # Text items have string outcomes — skip Z3 variable creation
                    self.dependency_graph[item_id] = set()
                elif kind == "MatrixQuestion":
                    # Matrix outcome is List[List[Any]] — one Z3 Int per cell.
                    # No scalar item_var: the matrix has no single outcome to constrain.
                    # rows/columns are top-level item keys (NOT under input_spec; see
                    # item_proxy.py:62-65 for a latent bug that uses input_config —
                    # do not copy that pattern here).
                    rows = item.get("rows", []) or []
                    columns = item.get("columns", []) or []
                    rows_len = len(rows)
                    cols_len = len(columns)
                    cells: dict[tuple[int, int], ExprRef] = {}
                    for r in range(rows_len):
                        for c in range(cols_len):
                            cell_var = Int(f"item_{item_id}_{r}_{c}", self.ctx)
                            cells[(r, c)] = cell_var
                            # Apply cell-level domain constraints (min/max or labels)
                            self._extract_domain_constraints(
                                item_id, cell_var, item, is_cell=True
                            )
                    self.item_cells[item_id] = cells
                    self.dependency_graph[item_id] = set()
                else:
                    # Item outcomes are integers (representing selected option/value)
                    item_var = Int(f"item_{item_id}", self.ctx)
                    self.item_vars[item_id] = item_var
                    self.dependency_graph[item_id] = set()

                    # Extract domain constraints D_i(S_i) from input specification
                    self._extract_domain_constraints(item_id, item_var, item)

                # R25: item_details feeds ItemClassifier (per-item Z3 W_i
                # formulas). The classifier needs the SAME composed view
                # the constraint emitter uses — block + item conditions —
                # otherwise items inheriting a block precondition would
                # be classified ALWAYS even when the block precondition
                # never holds. Compose here at population time.
                block_id_for_details = item.get("blockId")
                block_for_details = (
                    self.state.get_block(block_id_for_details) if block_id_for_details else None
                )
                composed_pre = list(
                    (block_for_details.get("precondition") if block_for_details else None) or []
                ) + list(item.get("precondition", []) or [])
                composed_post = list(
                    (block_for_details.get("postcondition") if block_for_details else None) or []
                ) + list(item.get("postcondition", []) or [])

                # Store item details for ItemClassifier compatibility
                self.item_details[item_id] = {
                    "preconditions": composed_pre,
                    "postconditions": composed_post,
                    "code_block": item.get("codeBlock", ""),
                    "control": control,
                    "kind": kind,
                    "rows_len": rows_len,
                    "cols_len": cols_len,
                }
                self.item_order.append(item_id)

        # U2 dedicated pass: flush per-item domain constraints into the flat
        # list, each present-gated. Runs after pass-1 (every item registered)
        # and before init/pass-2 so ``get_domain_base()`` already reflects the
        # gating when constraints are emitted.
        self._emit_present_gated_domain()

        # Process initialization code
        init_code = self.state.get_code_init()
        if init_code:
            self._process_code_block("__init__", init_code)

        # Process each item (skip Text items — no Z3 variables to constrain)
        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue

            # Textarea controls have string outcomes — skip Z3 constraint processing.
            # MatrixQuestion items have NO scalar in item_vars but DO have item_cells;
            # they still need precondition/postcondition processing.
            if item_id not in self.item_vars and item_id not in self.item_cells:
                continue

            # R25: block-level pre/postconditions are no longer prepended to
            # items by the loader. Compose them here at constraint-build time
            # — block conditions take effect BEFORE item conditions, mirroring
            # the historical merge order. ``idx`` indexes the composed list
            # so block-vs-item conds within the same item get distinct
            # constraint identifiers downstream.
            block_id = item.get("blockId")
            block = self.state.get_block(block_id) if block_id else None
            block_pre = list((block.get("precondition") if block else None) or [])
            block_post = list((block.get("postcondition") if block else None) or [])
            effective_pre = block_pre + list(item.get("precondition", []) or [])
            effective_post = block_post + list(item.get("postcondition", []) or [])

            # Process preconditions (path constraints)
            for idx, cond in enumerate(effective_pre):
                predicate = cond.get("predicate", "")
                if predicate:
                    constraint, deps = self._build_precondition_constraint(predicate, item_id, idx)
                    if constraint is not None:
                        # Precondition implies item can be reached.
                        # U2: outer-gated by ``present`` — Implies(present,
                        # Implies(visited, P)). present composes with the
                        # existing visited sentinel; off Sample/Roster present
                        # degrades to True so this is exactly the pre-U2
                        # ``Implies(visited, P)``.
                        self.constraints.append(
                            self._wrap_present(
                                item_id,
                                None,
                                Implies(
                                    self._visited_sentinel(item_id),  # Item is visited
                                    constraint,  # Precondition must be true
                                ),
                            )
                        )
                        # Dependencies are already added to dependency_graph in _build_precondition_constraint

            # Process postconditions BEFORE code blocks to match the runtime
            # lifecycle: precondition → collect outcome → postcondition → codeBlock.
            # This ensures postconditions reference variable versions from PRIOR
            # items' code blocks, not from the current item's code block (which
            # hasn't executed yet at postcondition evaluation time).
            for idx, cond in enumerate(effective_post):
                predicate = cond.get("predicate", "")
                if predicate:
                    constraint, deps = self._build_postcondition_constraint(predicate, item_id, idx)
                    if constraint is not None:
                        # If item is completed, postcondition must hold.
                        # U2: outer-gated by ``present`` (see precondition
                        # site above for the composition rationale).
                        self.constraints.append(
                            self._wrap_present(
                                item_id,
                                None,
                                Implies(
                                    self._visited_sentinel(item_id),  # Item has outcome
                                    constraint,  # Postcondition must be true
                                ),
                            )
                        )

            # Process code blocks (state transitions) — AFTER postconditions
            if "codeBlock" in item and item["codeBlock"]:
                self._process_code_block(item_id, item["codeBlock"])

        # ------------------------------------------------------------------
        # Pass 3: Roster iterateOver dependency wiring.
        #
        # Done as a SEPARATE post-pass — after pass 2's per-item loop — for
        # two reasons:
        #
        # 1. Pass 2 skips Textarea-controlled items entirely (no Z3 var to
        #    constrain). But roster inner items can still be Textarea (see
        #    Canonical Example A's `q_notes`), and they need their iterateOver
        #    dependency registered for topology to order them correctly.
        # 2. Doing the walk after the full pass 2 guarantees `version_map`
        #    contains every variable defined by any codeBlock in the
        #    questionnaire — even codeBlocks that live later in source order
        #    than the roster (the plan's "forward reference" requirement).
        # ------------------------------------------------------------------
        for item in self.state.get_all_items():
            item_id = item.get("id")
            iterate_over = item.get("_roster_iterate_over") if item_id else None
            if not iterate_over:
                continue
            try:
                expr_tree = ast.parse(iterate_over, mode="eval")
                iter_deps = self._extract_dependencies_from_ast(expr_tree)
            except SyntaxError:
                # Malformed iterateOver — surface elsewhere; don't poison the
                # dep graph silently. FlowProcessor's runtime eval will surface
                # the same error via the roster_iterate_over warning channel.
                continue
            self.dependency_graph.setdefault(item_id, set()).update(iter_deps)

        # ------------------------------------------------------------------
        # Pass 3.5 (U3): Roster bit-guarded unroll.
        #
        # Runs AFTER Pass 3 so ``version_map`` / ``item_vars`` are fully
        # populated (the iterateOver expression may reference a variable
        # written by a codeBlock that lives later in source order than the
        # roster). Purely ADDITIVE: it appends per-iteration domain/pre/post
        # copies gated by the bit-guard ``present`` Bool, and leaves the
        # canonical single-pass emission, ``item_order``, ``item_details``,
        # ``item_vars[item_id]`` and the dependency graph byte-identical — so
        # ItemClassifier / PathBasedValidator and topology see exactly what
        # they saw pre-U3 (only the constraint *set* grows). With no Roster
        # blocks present, nothing here fires (the U2 no-op invariant holds).
        # ------------------------------------------------------------------
        self._emit_roster_bit_guarded_unroll()

        # ------------------------------------------------------------------
        # Pass 3.6 (U4): Sample conditional-presence + ordering enumeration.
        #
        # SIBLING of Pass 3.5 — runs immediately after it, over the same
        # fully-built dependency graph / item_vars. Pass 3.5 keys solely on
        # ``_roster_*`` tags and skips ``_sample_*`` items; this pass keys
        # solely on ``_sample_*`` tags (the two tag families are mutually
        # exclusive per U1, so no item is processed by both). Purely additive:
        # appends conditional-presence-gated domain/pre/post copies and the
        # per-ordering present-definition constraints, leaving the canonical
        # single-pass emission, item_order, item_details, item_vars and the
        # dependency graph byte-identical. With no Sample blocks present
        # nothing fires (the U2 no-op invariant holds).
        # ------------------------------------------------------------------
        self._emit_sample_conditional_presence()

    def _roster_label_keys(self, raw_labels: Any) -> list[int]:
        """Return the sorted power-of-2 label-key universe for a Roster item.

        ``_roster_labels`` is a ``{power-of-2 int : display str}`` map. YAML/
        JSON round-trips may stringify integer keys (the same coercion the
        FlowProcessor roster pass does — see ``_decorate_with_roster_progress``
        / ``_enter_roster_pass``), so keys are coerced to ``int`` here. Keys
        that are not positive powers of 2 are dropped silently: the U1 loader
        already loud-rejects malformed Roster ``labels``, so by Pass 3.5 the
        universe is well-formed; this is defence-in-depth for callers that
        bypass schema/loader validation. Sorted ascending so iteration order
        is deterministic (low bit first), matching the runtime walk.
        """
        keys: list[int] = []
        if isinstance(raw_labels, dict):
            for k in raw_labels:
                try:
                    ki = int(k)
                except (TypeError, ValueError):
                    continue
                # Positive power of two (1, 2, 4, …): n > 0 and n & (n-1) == 0.
                if ki > 0 and (ki & (ki - 1)) == 0:
                    keys.append(ki)
        return sorted(set(keys))

    def _emit_roster_bit_guarded_unroll(self) -> None:
        """U3: emit ``len(labels)`` bit-guarded copies of each Roster inner
        item's domain/pre/post constraints (R4, R7, R8).

        For a Roster inner item with label-key universe ``{2^j ...}`` and
        iterateOver expression ``E``:

        - For each label-key ``K`` (a compile-time literal power of 2) a
          per-iteration outcome var ``item_{id}_iter{K}`` is created and
          ``(item_id, K)`` is registered conditionally-present (U2 primitive
          — keeps ItemClassifier / PathBasedValidator from flagging a
          bit-unset iteration NEVER / dead-code).
        - The presence Bool is *defined* by the *literal power-of-2 mask*
          bit-test ``present(item, K)  ⇔  (E / K) % 2 == 1``. ``K`` is a
          compile-time constant, so ``/`` and ``%`` are div/mod-by-constant —
          decidable linear integer arithmetic, NO BitVec (plan Key Technical
          Decision: integer model retained).
        - The item's domain builders and its composed (block+item)
          precondition / postcondition predicates are re-emitted bound to the
          per-iteration var, each wrapped ``Implies(present(item,K), …)`` via
          ``_wrap_present``. Self ``.outcome`` references inside the
          predicates resolve to the per-iteration var by a scoped swap of
          ``self.item_vars[item_id]`` (restored in a ``finally``), mirroring
          how comprehension unrolling scopes ``local_bindings``.

        R8: bits of ``E`` beyond ``len(labels)`` are silently ignored — the
        unroll universe is exactly the declared label keys; ``E`` is never
        magnitude-validated or capped (matches runtime behavior).

        This deliberately makes the constraint count scale linearly with
        ``len(labels)`` (vs the prior flat single-pass) — that linear growth
        is the whole point of the unit; a worse-than-linear blow-up would be
        a bug (see the timing-shape assertion in the test suite).
        """
        # Track (block_id, iterate_over) pairs whose non-negativity constraint
        # has already been emitted — one constraint per Roster block is enough;
        # the expression is identical for every inner item in the same block.
        _roster_nonneg_emitted: set[tuple[str, str]] = set()

        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue
            block_id = item.get("_roster_block_id")
            iterate_over = item.get("_roster_iterate_over")
            if not block_id or not iterate_over:
                continue

            label_keys = self._roster_label_keys(item.get("_roster_labels"))
            if not label_keys:
                # No declared iteration universe → nothing to unroll. The
                # canonical single-pass emission still covers the item.
                continue

            # Lower the iterateOver expression to a Z3 int ONCE. ``E`` may be
            # a bare variable (``family_mask``) or an item outcome
            # (``q_meals_eaten.outcome``); both lower via _ast_to_z3. A
            # malformed / unsupported expression yields None — skip the
            # unroll silently (the Pass-3 dependency walk + FlowProcessor's
            # runtime eval already surface the author-facing error; emitting
            # nothing here just falls back to the canonical single-pass
            # model, never a crash).
            try:
                expr_tree = ast.parse(iterate_over, mode="eval")
            except SyntaxError:
                continue
            iter_z3 = self._ast_to_z3(expr_tree.body, item_id)
            if iter_z3 is None:
                continue

            # Non-negativity invariant: the bit-guard formula (E / K) % 2 == 1
            # relies on T-division semantics matching floor-division for
            # non-negative E. A codeBlock-computed iterateOver could be
            # negative; assert >= 0 explicitly so Z3 never explores that
            # branch and produces wrong bit interpretations.
            # Emitted once per (block_id, iterate_over) — every inner item in
            # the same block re-parses the same expression, so one constraint
            # is sufficient.
            nonneg_key = (block_id, iterate_over)
            if nonneg_key not in _roster_nonneg_emitted:
                self.constraints.append(iter_z3 >= IntVal(0, self.ctx))
                _roster_nonneg_emitted.add(nonneg_key)

            # Composed (block + item) conditions — same composition order
            # Pass-2 uses (block conditions take effect BEFORE item
            # conditions). Recomputed here rather than threaded from Pass-2
            # because Pass-2's loop scope does not persist.
            block = self.state.get_block(block_id) if block_id else None
            block_pre = list((block.get("precondition") if block else None) or [])
            block_post = list((block.get("postcondition") if block else None) or [])
            effective_pre = block_pre + list(item.get("precondition", []) or [])
            effective_post = block_post + list(item.get("postcondition", []) or [])

            domain_builders = self._pending_domain_constraints.get(item_id, [])
            canonical_var = self.item_vars.get(item_id)

            for k in label_keys:
                # Register the (item, k) presence gate (U2 primitive). This
                # flips ``_present_antecedent`` from True to the real Bool for
                # this key and tags the item classification-safe.
                self.mark_conditionally_present(item_id, k)

                # Bit-guard definition via the LITERAL power-of-2 mask ``k``.
                # ``(E / k) % 2 == 1`` is exactly "bit log2(k) of E is set":
                # integer division by the constant ``k`` shifts that bit to
                # the units position, ``% 2`` isolates it. Div/mod by a
                # compile-time constant stays in linear integer arithmetic
                # (decidable, cheap) — the explicit no-BitVec decision.
                bit_set = ((iter_z3 / k) % 2) == 1
                self.constraints.append(self._present_var(item_id, k) == bit_set)

                # Per-iteration outcome var. Scalar items get a fresh Int;
                # Textarea / matrix inner roster items have no scalar var (no
                # numeric domain, no self-outcome predicate lowering) — the
                # presence gate + dependency edges still apply, but there is
                # no per-iteration var to bind, so skip the var-bound emit.
                if canonical_var is None:
                    continue
                iter_var = Int(f"item_{item_id}_iter{k}", self.ctx)

                # Re-emit domain for this iteration, present-gated.
                for build in domain_builders:
                    self.domain_constraints.append(
                        self._wrap_present(item_id, k, build(iter_var))
                    )

                # Re-emit pre/post for this iteration via the shared helper:
                # scoped swap of the canonical item var → ``self.outcome``
                # references lower to THIS iteration's var; restored in
                # ``finally`` so Pass-3.5 leaves item_vars untouched on exit.
                self._emit_pre_post_under_present(
                    item_id, k, effective_pre, effective_post, iter_var, canonical_var
                )

    # R9: a single Sample block with > SAMPLE_COMPONENT_CAP independent
    # components in its block-scoped dependency forest would require
    # (cap+1)! ≥ 40320 distinct orderings to validate exhaustively. Capping
    # at 7 bounds the enumeration at 7! = 5040 orderings — the value
    # user-confirmed in planning (plan Key Technical Decisions / Open
    # Questions: "Cap value: ≤ 7 independent trees").
    SAMPLE_COMPONENT_CAP = 7

    def _record_sample_cap_gap(
        self, block_id: str, component_count: int
    ) -> None:
        """Record the R9 validation-time cap reject as a structured coverage
        gap (loud, once per block, no solve).

        Mirrors ``_record_coverage_gap`` but keyed by ``block_id`` rather than
        an item_id, with a distinct ``kind: "sample_cap"`` shape so authors
        (and the diagram / validation report, via
        ``ItemClassifier.classify_all_items``) see exactly which Sample block
        exceeded the randomization cap and by how much. Deduplicated by
        block_id — re-recording for the same block is a no-op. The WARNING is
        emitted exactly once per block.

        Shape::

            {
              "kind": "sample_cap",
              "block_id": <str>,
              "component_count": <int>,   # T, the independent-component count
              "cap": <int>,               # SAMPLE_COMPONENT_CAP (7)
            }

        This is the structured loud-surface the no-silent-fallbacks rule
        mandates: the block is NOT validated for any ordering (no solve), and
        the gap is the only thing the pipeline emits for it.
        """
        gaps = self.coverage_gaps.setdefault(block_id, [])
        for existing in gaps:
            if existing.get("kind") == "sample_cap":
                return
        gaps.append(
            {
                "kind": "sample_cap",
                "block_id": block_id,
                "component_count": component_count,
                "cap": self.SAMPLE_COMPONENT_CAP,
            }
        )
        self.logger.warning(
            "static validator rejected Sample block '%s': %d independent "
            "components exceed the randomization cap of %d (%d! orderings) — "
            "no ordering validated; split the block or set is_random=false",
            block_id,
            component_count,
            self.SAMPLE_COMPONENT_CAP,
            component_count,
        )

    def _sample_blocks(self) -> dict[str, dict[str, Any]]:
        """Group Sample inner items by their block, in stable file order.

        Returns ``{block_id: {"items": [item, ...], "n": int,
        "is_random": bool}}``. Items are collected in ``get_all_items()``
        order so the block-scoped component enumeration is deterministic and
        matches the runtime freeze (U5). Sample tags are mutually exclusive
        with Roster tags (U1), so a Roster item never appears here.
        """
        blocks: dict[str, dict[str, Any]] = {}
        for item in self.state.get_all_items():
            item_id = item.get("id")
            if not item_id:
                continue
            block_id = item.get("_sample_block_id")
            if not block_id:
                continue
            entry = blocks.setdefault(
                block_id,
                {
                    "items": [],
                    "n": item.get("_sample_n"),
                    "is_random": bool(item.get("_sample_is_random", False)),
                },
            )
            entry["items"].append(item)
        return blocks

    def _emit_sample_conditional_presence(self) -> None:
        """U4: validate Sample blocks via the U2 conditional-presence
        primitive, enumerating contiguous-tree-block orderings when
        ``is_random=true`` and rejecting > 7 components loudly (R5, R6, R9,
        R10).

        Per Sample block:

        1. **Block-scoped component extraction.** Restrict
           ``QMLTopology.get_block_scoped_components`` to the block's inner
           items over the *real* StaticBuilder dependency graph (the same
           transitively variable-resolved item→item graph Z3 enumerates — see
           that helper's docstring for the same-graph proof). The throwaway
           ``QMLTopology(self.state, self)`` is built here, AFTER Pass 3.6's
           predecessor passes, so ``get_item_dependencies()`` is fully
           populated — byte-identical to the graph ``QMLEngine`` builds in its
           step 2.

        2. **Count T, gate on > 7 WITHOUT materializing orderings (R9).**
           ``T = len(components)`` is read directly from the component list;
           the ``T > 7`` decision is taken on that integer *before* any
           ``itertools.permutations`` call. An over-cap block records a
           structured ``sample_cap`` coverage gap and is NOT solved — no
           ordering is ever generated for it (the gate is an ``int``
           comparison, never ``len(list(permutations(...)))``).

        3. **is_random=false OR T ≤ 1 → single canonical order (R10).** No
           enumeration, no cap. Every inner item is registered
           conditionally-present at one selection index and its
           domain/pre/post are present-gated via U2.

        4. **is_random=true, 2 ≤ T ≤ 7 → enumerate the T! orderings.** Each
           ordering is a permutation of the *components*; every component is
           emitted contiguously in its fixed stable-Kahn linearization
           (intra-component order is the topology's existing cycle-tolerant
           order — valid even for cyclic/diamond components, no forest
           restriction). Each (item, ordering-index k) is registered
           conditionally-present and its constraints present-gated. Distinct
           ``k`` per ordering keeps every ordering's typing check independent.

        Composition: the block precondition gates the whole block (prepended
        to each item's precondition, same order Pass-2 uses); the block
        postcondition applies to drawn items only (prepended to each item's
        postcondition, present-gated like every other constraint). Static
        enumeration only — NO Z3 quantifiers.

        Selection-index ``k`` scheme: Sample uses small *sequential* integers
        ``0, 1, 2, …`` (one per enumerated ordering; ``0`` for the single
        canonical order). U3/Roster uses power-of-2 label keys. Sample items
        never carry Roster tags (U1), so the keyspaces never collide; the
        distinct scheme keeps the convention readable.
        """
        sample_blocks = self._sample_blocks()
        if not sample_blocks:
            # No Sample blocks → pure no-op (U2 invariant). Do NOT build the
            # throwaway topology in this common case.
            return

        # Local import: qml_topology imports static_builder at module scope,
        # so importing it at this module's top would be circular. Mirrors the
        # validation_processor → qml_diagram_ir local-import idiom.
        from askalot_qml.core.qml_topology import QMLTopology

        # ONE throwaway topology over the fully-built dependency graph — the
        # exact graph QMLEngine builds next (and Z3 enumerates). Built once
        # and shared across every Sample block.
        topology = QMLTopology(self.state, self)
        topo_index = {iid: idx for idx, iid in enumerate(topology.get_topological_order())}

        for block_id, info in sample_blocks.items():
            items = info["items"]
            item_by_id = {it["id"]: it for it in items}
            block_item_ids = set(item_by_id.keys())
            is_random = info["is_random"]

            components = topology.get_block_scoped_components(block_item_ids)
            # T is read straight off the component list — an int. The cap gate
            # below compares this int; it NEVER materializes T! orderings to
            # count them (R9: "count components first, reject, only then
            # enumerate").
            t = len(components)

            if is_random and t > self.SAMPLE_COMPONENT_CAP:
                # R9 loud reject — structured gap, NO solve. We return before
                # any permutation is generated and emit ZERO inner
                # constraints for this block.
                self._record_sample_cap_gap(block_id, t)
                continue

            # Linearize each component using the questionnaire-wide topological
            # order (cycle-tolerant; identical to what the runtime walks).
            # Components are ordered by their earliest member's topo index so
            # the component sequence itself is deterministic.

            ordered_components = sorted(
                components, key=lambda c: min(topo_index.get(i, len(topo_index)) for i in c)
            ) if components else []
            linearized = [topology.linearize_component(c, topo_index) for c in ordered_components]

            if not is_random or t <= 1:
                # R10 single canonical order: components emitted in their
                # fixed order, intra-component order fixed. Exactly one
                # ordering (k=0). Empty block → linearized == [] → the
                # per-item loop body runs zero times: base case = 1 (empty)
                # ordering, no divide-by-zero, no permutation call.
                orderings = [[iid for comp in linearized for iid in comp]]
            else:
                # is_random, 2 ≤ T ≤ 7: permute the COMPONENTS (each
                # contiguous, intra-order fixed). itertools.permutations is
                # only ever reached here — strictly after the T > cap gate, so
                # at most 7! = 5040 orderings are materialized.
                orderings = [
                    [iid for comp in perm for iid in comp]
                    for perm in itertools.permutations(linearized)
                ]

            block = self.state.get_block(block_id)
            block_pre = list((block.get("precondition") if block else None) or [])
            block_post = list((block.get("postcondition") if block else None) or [])

            for k, ordering in enumerate(orderings):
                for item_id in ordering:
                    item = item_by_id[item_id]

                    # Register (item, k) conditionally-present: flips the U2
                    # antecedent from True to the real present Bool AND tags
                    # the item classification-safe (a not-drawn-in-this-
                    # ordering item is not NEVER / dead-code).
                    self.mark_conditionally_present(item_id, k)

                    canonical_var = self.item_vars.get(item_id)
                    domain_builders = self._pending_domain_constraints.get(item_id, [])

                    effective_pre = block_pre + list(item.get("precondition", []) or [])
                    effective_post = block_post + list(item.get("postcondition", []) or [])

                    if canonical_var is None:
                        # Textarea / matrix Sample item: no scalar var to
                        # bind. Presence registration above still tags it
                        # classification-safe and self.outcome-free
                        # predicates lower without a per-selection var; skip
                        # the var-bound emit (mirrors the Roster Textarea
                        # branch in Pass 3.5).
                        continue

                    # Per-(item, ordering) outcome var so each ordering's
                    # typing/feasibility check is independent.
                    sel_var = Int(f"item_{item_id}_sample{k}", self.ctx)

                    for build in domain_builders:
                        self.domain_constraints.append(
                            self._wrap_present(item_id, k, build(sel_var))
                        )

                    # Re-emit pre/post for this selection via the shared
                    # helper. Block precondition gates the whole block;
                    # composed with the item precondition and the visited
                    # sentinel, all under the present gate — block
                    # postcondition applies to drawn items only by the same
                    # gate (`effective_pre`/`effective_post` already include
                    # block-level conditions per the composition above).
                    self._emit_pre_post_under_present(
                        item_id, k, effective_pre, effective_post, sel_var, canonical_var
                    )

    def _process_code_block(self, context_id: str, code: str):
        """Process code block and create SSA versions for assignments.

        Handles ast.Assign, ast.AugAssign, and ast.Attribute targets.
        Tracks Variable → Item/Variable dependencies in the dependency graph.
        Also tracks dependencies from enclosing if-conditions for nested assignments.
        """
        try:
            tree = ast.parse(code)

            # Build parent map so we can find enclosing if-conditions
            parent_map = self._build_parent_map(tree)

            for node in ast.walk(tree):
                if isinstance(node, ast.Assign):
                    # Collect dependencies from enclosing if-conditions
                    enclosing_deps = self._get_enclosing_if_deps(node, parent_map)

                    for target in node.targets:
                        if isinstance(target, ast.Name):
                            var_name = target.id
                            if var_name not in self.item_vars:
                                rhs_deps = self._extract_dependencies_from_ast(node.value)
                                rhs_deps.update(enclosing_deps)
                                z3_value = self._ast_to_z3(node.value, context_id)
                                self._register_variable_assignment(
                                    var_name, z3_value, rhs_deps, context_id
                                )
                        elif isinstance(target, ast.Attribute) and target.attr == "outcome":
                            # Handle item.outcome = expr (e.g., q_total.outcome = q1.outcome + q2.outcome)
                            if isinstance(target.value, ast.Name):
                                self._register_outcome_assignment(
                                    target.value.id, node.value, enclosing_deps, context_id
                                )

                elif isinstance(node, ast.AugAssign):
                    # Handle augmented assignments: score += q1.outcome
                    enclosing_deps = self._get_enclosing_if_deps(node, parent_map)
                    target = node.target

                    if isinstance(target, ast.Name):
                        var_name = target.id
                        if var_name not in self.item_vars:
                            # Dependencies: RHS + current variable value + enclosing conditions
                            rhs_deps = self._extract_dependencies_from_ast(node.value)
                            rhs_deps.update(enclosing_deps)
                            if var_name in self.version_map:
                                rhs_deps.add(f"var:{var_name}")

                            # Build Z3 value: old_value OP rhs
                            rhs_z3 = self._ast_to_z3(node.value, context_id)
                            old_z3 = self._get_current_z3_var(var_name)
                            z3_value = self._apply_aug_op(node.op, old_z3, rhs_z3)

                            self._register_variable_assignment(
                                var_name, z3_value, rhs_deps, context_id
                            )
                    elif isinstance(target, ast.Attribute) and target.attr == "outcome":
                        # Handle item.outcome += expr
                        if isinstance(target.value, ast.Name):
                            item_id = target.value.id
                            if item_id in self.item_vars:
                                rhs_deps = self._extract_dependencies_from_ast(node.value)
                                rhs_deps.update(enclosing_deps)
                                rhs_deps.add(item_id)
                                # Track dependency: context_id depends on the items in RHS
                                if context_id in self.dependency_graph:
                                    self.dependency_graph[context_id].update(
                                        d
                                        for d in rhs_deps
                                        if not d.startswith("var:") and d != context_id
                                    )

        except SyntaxError as e:
            self.logger.error(f"Syntax error in code block for {context_id}: {e}")

    def _register_variable_assignment(
        self, var_name: str, z3_value: ExprRef | None, deps: set[str], context_id: str
    ):
        """Register an SSA variable assignment with dependencies and Z3 constraint."""
        new_version = self._get_next_version(var_name)
        versioned_name = f"{var_name}_{new_version}"
        var_node = f"var:{var_name}"

        # Create Z3 variable for this version
        z3_var = Int(versioned_name, self.ctx)
        self.z3_vars[versioned_name] = z3_var

        # Initialize variable node in dependency graph if needed
        if var_node not in self.dependency_graph:
            self.dependency_graph[var_node] = set()

        # Add dependencies from RHS to the variable node
        self.dependency_graph[var_node].update(deps)

        # Track definition source
        self.variable_definitions[(var_name, new_version)] = context_id

        # Variable depends on the item that defines it
        # (if defined in an item's codeBlock, not in __init__)
        if context_id != "__init__" and context_id in self.item_vars:
            self.dependency_graph[var_node].add(context_id)

        # Update version tracking AFTER evaluating RHS
        self.version_map[var_name] = new_version
        if var_name not in self.version_history:
            self.version_history[var_name] = []
        self.version_history[var_name].append((new_version, context_id))

        # Build constraint for assignment - store in codeblock_constraints.
        if z3_value is not None:
            if context_id != "__init__":
                self.codeblock_constraints.append(
                    Implies(self.item_vars[context_id] >= 0, z3_var == z3_value)
                )
            else:
                self.codeblock_constraints.append(z3_var == z3_value)

    def _register_outcome_assignment(
        self, item_id: str, value_node: ast.AST, enclosing_deps: set[str], context_id: str
    ):
        """Register item.outcome = expr, tracking dependencies without creating SSA."""
        if item_id not in self.item_vars:
            return

        rhs_deps = self._extract_dependencies_from_ast(value_node)
        rhs_deps.update(enclosing_deps)

        # The item that contains this codeBlock depends on the RHS items
        if context_id in self.dependency_graph:
            self.dependency_graph[context_id].update(
                d for d in rhs_deps if not d.startswith("var:") and d != context_id
            )

        # Build Z3 constraint for the outcome assignment
        z3_value = self._ast_to_z3(value_node, context_id)
        if z3_value is not None and context_id in self.item_vars:
            self.codeblock_constraints.append(
                Implies(self.item_vars[context_id] >= 0, self.item_vars[item_id] == z3_value)
            )

    @staticmethod
    def _apply_aug_op(
        op: ast.operator, left: ExprRef | None, right: ExprRef | None
    ) -> ExprRef | None:
        """Apply augmented assignment operator to Z3 expressions."""
        if left is None or right is None:
            return None
        if isinstance(op, ast.Add):
            return left + right
        elif isinstance(op, ast.Sub):
            return left - right
        elif isinstance(op, ast.Mult):
            return left * right
        elif isinstance(op, ast.FloorDiv):
            return left / right
        elif isinstance(op, ast.Mod):
            return left % right
        return None

    @staticmethod
    def _build_parent_map(tree: ast.AST) -> dict:
        """Build a mapping from child nodes to their parent nodes."""
        parent_map = {}
        for node in ast.walk(tree):
            for child in ast.iter_child_nodes(node):
                parent_map[child] = node
        return parent_map

    def _get_enclosing_if_deps(self, node: ast.AST, parent_map: dict) -> set[str]:
        """Extract dependencies from all enclosing if-conditions of a node."""
        deps = set()
        current = node
        while current in parent_map:
            parent = parent_map[current]
            if isinstance(parent, ast.If):
                deps.update(self._extract_dependencies_from_ast(parent.test))
            current = parent
        return deps

    def _get_next_version(self, var_name: str) -> int:
        """Get next SSA version number for a variable."""
        current = self.version_map.get(var_name, -1)
        return current + 1

    def _get_current_z3_var(self, var_name: str) -> ExprRef | None:
        """Get current Z3 variable for a given variable name."""
        if var_name in self.item_vars:
            return self.item_vars[var_name]

        current_version = self.version_map.get(var_name)
        if current_version is not None:
            versioned_name = f"{var_name}_{current_version}"
            return self.z3_vars.get(versioned_name)

        # Variable not yet defined - create version 0
        z3_var = Int(f"{var_name}_0", self.ctx)
        self.z3_vars[f"{var_name}_0"] = z3_var
        self.version_map[var_name] = 0
        return z3_var

    def _unsupported_node_kinds(self, tree: ast.AST) -> list[str]:
        """Return AST node-type names of nodes the static translator can't lower.

        Empty list means "the predicate body is fully within the supported
        subset" — used as the silent-drop guard so we only WARN when the
        predicate clearly intended a real constraint (some Call / ListComp /
        GeneratorExp / Subscript was present).
        """
        unsupported: list[str] = []
        for node in ast.walk(tree):
            if isinstance(node, (ast.Call, ast.ListComp, ast.GeneratorExp, ast.Subscript)):
                kind_name = type(node).__name__
                if kind_name not in unsupported:
                    unsupported.append(kind_name)
        return unsupported

    def _record_coverage_gap(
        self, item_id: str, kind: str, condition_idx: int, unsupported_nodes: list[str]
    ) -> None:
        """Record a coverage gap (R13) and emit a one-shot WARNING (R7).

        ``kind`` is ``"precondition"`` or ``"postcondition"``. WARNING is
        emitted exactly once per (item_id, kind, condition_idx) — duplicate
        calls for the same triple are a no-op.
        """
        gaps = self.coverage_gaps.setdefault(item_id, [])
        # Deduplicate by (kind, condition_idx) — same condition shouldn't log twice.
        for existing in gaps:
            if existing.get("kind") == kind and existing.get("condition_idx") == condition_idx:
                return
        gaps.append(
            {
                "kind": kind,
                "condition_idx": condition_idx,
                "unsupported_nodes": list(unsupported_nodes),
            }
        )
        self.logger.warning(
            "static validator skipped %s on %s #%d: unsupported AST node(s) %s — "
            "runtime enforcement still applies, but classification falls back to NONE",
            kind,
            item_id,
            condition_idx,
            unsupported_nodes,
        )

    def _build_precondition_constraint(
        self, predicate: str, item_id: str, condition_idx: int = 0
    ) -> tuple[BoolRef | None, set[str]]:
        """Build Z3 constraint for precondition AND track dependencies.

        Extracts ALL dependencies (items AND variables) and adds them to the
        dependency graph for proper transitive chain resolution.

        Note: Self-references are excluded - an item referencing itself
        is not a dependency (would create invalid self-loops).
        """
        try:
            tree = ast.parse(predicate, mode="eval")

            # Extract ALL dependencies (items AND variables)
            all_deps = self._extract_dependencies_from_ast(tree.body)

            # Add to dependency graph (excluding self-references)
            for dep in all_deps:
                if dep != item_id:  # Exclude self-reference
                    self.dependency_graph[item_id].add(dep)

            constraint = self._ast_to_z3_bool(tree.body, item_id)

            # R7/R13: surface silent drops on constraint-bearing predicates.
            if constraint is None:
                unsupported = self._unsupported_node_kinds(tree.body)
                if unsupported:
                    self._record_coverage_gap(item_id, "precondition", condition_idx, unsupported)

            # Return only item dependencies for backward compatibility
            item_deps = {d for d in all_deps if not d.startswith("var:")}
            return constraint, item_deps
        except Exception as e:
            self.logger.error(f"Error building precondition constraint for {item_id}: {e}")
            return None, set()

    def _build_postcondition_constraint(
        self, predicate: str, item_id: str, condition_idx: int = 0
    ) -> tuple[BoolRef | None, set[str]]:
        """Build Z3 constraint for postcondition AND track dependencies.

        Postconditions can also create dependencies! For example, if q2 has a
        postcondition referencing q1.outcome, q2 depends on q1.

        Note: Self-references ARE allowed in postconditions - an item's postcondition
        validating its own outcome (e.g., `q1.outcome > 0`) is valid and not a dependency.
        Self-references are excluded from the dependency graph.
        """
        try:
            tree = ast.parse(predicate, mode="eval")

            # Extract ALL dependencies (items AND variables)
            all_deps = self._extract_dependencies_from_ast(tree.body)

            # Add to dependency graph (excluding self-references - postconditions validating
            # their own item's outcome don't create dependencies)
            for dep in all_deps:
                if dep != item_id:  # Exclude self-reference
                    self.dependency_graph[item_id].add(dep)

            constraint = self._ast_to_z3_bool(tree.body, item_id)

            # R7/R13: surface silent drops on constraint-bearing predicates.
            if constraint is None:
                unsupported = self._unsupported_node_kinds(tree.body)
                if unsupported:
                    self._record_coverage_gap(item_id, "postcondition", condition_idx, unsupported)

            # Return only item dependencies for backward compatibility
            item_deps = {d for d in all_deps if not d.startswith("var:")}
            return constraint, item_deps
        except Exception as e:
            self.logger.error(f"Error building postcondition constraint for {item_id}: {e}")
            return None, set()

    # ------------------------------------------------------------------
    # Helpers for matrix postcondition lowering
    # ------------------------------------------------------------------

    def _resolve_int_const(self, node: ast.AST, local_bindings: dict[str, int]) -> int | None:
        """Resolve an AST node to a Python int at build time.

        Accepts integer literals, names bound via ``local_bindings``, and the
        compile-time-known forms ``len(<item>.rows)`` / ``len(<item>.columns)``
        where ``<item>`` is a MatrixQuestion in the questionnaire. Anything
        else (BinOp, arbitrary calls, runtime variables) returns ``None``.
        """
        if (
            isinstance(node, ast.Constant)
            and isinstance(node.value, int)
            and not isinstance(node.value, bool)
        ):
            return node.value
        if isinstance(node, ast.Name) and node.id in local_bindings:
            return local_bindings[node.id]
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, (ast.USub, ast.UAdd)):
            inner = self._resolve_int_const(node.operand, local_bindings)
            if inner is None:
                return None
            return -inner if isinstance(node.op, ast.USub) else inner
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id == "len":
            # len(<matrix_id>.rows) / len(<matrix_id>.columns) only.
            if len(node.args) != 1:
                return None
            arg = node.args[0]
            if (
                isinstance(arg, ast.Attribute)
                and isinstance(arg.value, ast.Name)
                and arg.attr in ("rows", "columns")
            ):
                item_id = arg.value.id
                if item_id in self.item_details:
                    detail_key = "rows_len" if arg.attr == "rows" else "cols_len"
                    val = self.item_details[item_id].get(detail_key)
                    if isinstance(val, int):
                        return val
        return None

    def _resolve_range_call(
        self, call_node: ast.AST, local_bindings: dict[str, int]
    ) -> range | None:
        """Resolve a ``range(...)`` call to a Python ``range`` object at build time.

        Static-builder bounds policy: no upper-cap, ``len(<item>.rows|columns)``
        accepted. (The pragmatic_compiler's ``visit_For`` keeps its own stricter
        policy — caps at 0–20, no len() — and is not changed by this plan.)

        Returns ``None`` if the call shape is unsupported (e.g., 3-arg range
        with non-trivial step, non-resolvable bounds, BinOp on the start arg).
        """
        if not (
            isinstance(call_node, ast.Call)
            and isinstance(call_node.func, ast.Name)
            and call_node.func.id == "range"
        ):
            return None
        args = call_node.args
        if len(args) == 1:
            stop = self._resolve_int_const(args[0], local_bindings)
            if stop is None or stop < 0:
                return None
            return range(stop)
        if len(args) == 2:
            start = self._resolve_int_const(args[0], local_bindings)
            stop = self._resolve_int_const(args[1], local_bindings)
            if start is None or stop is None:
                return None
            return range(start, stop)
        return None

    def _lower_subscript(
        self, node: ast.Subscript, context: str, local_bindings: dict[str, int]
    ) -> ExprRef | None:
        """Lower ``X.outcome[j][k]`` to ``item_cells[X][(j, k)]``.

        Two-level subscript over a matrix: lowered to the cell variable.
        One-level subscript over a matrix: returns ``None`` here — the only
        supported one-level form is inside a fold, which goes through
        ``_unroll_list_arg`` and bypasses this scalar lowering.
        Anything else (subscripting a scalar item, a Python variable, etc.)
        returns ``None``.
        """
        # Check for X.outcome[j][k] (two-level)
        outer = node
        # outer.value should be another Subscript: X.outcome[j]
        # outer.slice is the inner index: k
        if isinstance(outer.value, ast.Subscript):
            inner = outer.value
            # inner.value should be X.outcome
            if (
                isinstance(inner.value, ast.Attribute)
                and isinstance(inner.value.value, ast.Name)
                and inner.value.attr == "outcome"
            ):
                item_id = inner.value.value.id
                cells = self.item_cells.get(item_id)
                if cells is None:
                    return None
                j = self._resolve_int_const(inner.slice, local_bindings)
                k = self._resolve_int_const(outer.slice, local_bindings)
                if j is None or k is None:
                    return None
                return cells.get((j, k))
        # Single-level subscript on X.outcome (no fold context) is unsupported.
        return None

    def _try_distinct_pattern(
        self, node: ast.Compare, context: str, local_bindings: dict[str, int]
    ) -> BoolRef | None:
        """Pattern: ``len(set(<list-like>)) == <int>`` → ``Distinct(*xs)``.

        Recognized shapes (LHS first, then comparator op + Constant):
            len(set([...])) == k
            len({...}) == k                       (set literal — unimplemented)

        Only the equality form is recognized; ``!=``, ``>=``, etc., fall
        through. The integer ``k`` must equal ``len(xs)`` after unrolling
        (Distinct only has Python-set semantics for the "all distinct" case).
        """
        if len(node.ops) != 1 or not isinstance(node.ops[0], ast.Eq):
            return None
        if len(node.comparators) != 1:
            return None
        lhs = node.left
        rhs = node.comparators[0]

        # LHS must be: len(set(<arg>))  with one positional arg
        if not (
            isinstance(lhs, ast.Call)
            and isinstance(lhs.func, ast.Name)
            and lhs.func.id == "len"
            and len(lhs.args) == 1
        ):
            return None
        inner = lhs.args[0]
        if not (
            isinstance(inner, ast.Call)
            and isinstance(inner.func, ast.Name)
            and inner.func.id == "set"
            and len(inner.args) == 1
        ):
            return None
        list_arg = inner.args[0]

        # RHS must be a constant int we can resolve at build time.
        k = self._resolve_int_const(rhs, local_bindings)
        if k is None:
            return None

        xs = self._unroll_list_arg(list_arg, context, local_bindings, bool_elements=False)
        if xs is None:
            return None
        if len(xs) != k:
            # ``len(set([a, b, c])) == 2`` is satisfiable but is not "all
            # distinct" — Z3's Distinct doesn't model "exactly N distinct
            # values out of M". Refuse the translation; caller logs WARNING.
            return None
        if len(xs) <= 1:
            return BoolVal(True, self.ctx)
        return Distinct(*xs)

    def _lower_call_value(
        self, node: ast.Call, context: str, local_bindings: dict[str, int]
    ) -> ExprRef | None:
        """Value-context calls: ``sum(xs)``, ``int(x)``, ``bool(x)``, ``abs(x)``.

        ``len(...)`` is intentionally NOT lowered here — its only meaningful
        shape inside a Z3 expression is part of the ``len(set(...)) == k``
        Distinct pattern, which is matched at the Compare-node level.
        """
        if not isinstance(node.func, ast.Name):
            return None
        fname = node.func.id

        if fname == "sum" and len(node.args) == 1:
            xs = self._unroll_list_arg(node.args[0], context, local_bindings, bool_elements=False)
            if xs is None:
                return None
            if not xs:
                return IntVal(0, self.ctx)
            return Sum(*xs)

        if fname == "int" and len(node.args) == 1:
            arg = self._ast_to_z3(node.args[0], context, local_bindings)
            if arg is None:
                return None
            if isinstance(arg, BoolRef):
                return If(arg, IntVal(1, self.ctx), IntVal(0, self.ctx))
            return arg

        if fname == "abs" and len(node.args) == 1:
            arg = self._ast_to_z3(node.args[0], context, local_bindings)
            if arg is None:
                return None
            return If(arg >= 0, arg, -arg)

        # range(...) only makes sense as a comprehension generator iterable;
        # outside that it has no Z3 meaning.
        return None

    def _lower_call_bool(
        self, node: ast.Call, context: str, local_bindings: dict[str, int]
    ) -> BoolRef | None:
        """Bool-context calls: ``all(xs)`` / ``any(xs)`` / ``bool(x)``."""
        if not isinstance(node.func, ast.Name):
            return None
        fname = node.func.id

        if fname in ("all", "any") and len(node.args) == 1:
            xs = self._unroll_list_arg(node.args[0], context, local_bindings, bool_elements=True)
            if xs is None:
                return None
            if not xs:
                # all([]) == True ; any([]) == False — Python semantics.
                return BoolVal(fname == "all", self.ctx)
            if len(xs) == 1:
                return xs[0]  # type: ignore[return-value]
            return And(*xs) if fname == "all" else Or(*xs)

        if fname == "bool" and len(node.args) == 1:
            arg = self._ast_to_z3(node.args[0], context, local_bindings)
            if arg is None:
                return None
            if isinstance(arg, BoolRef):
                return arg
            return arg != 0

        return None

    def _unroll_list_arg(
        self,
        node: ast.AST,
        context: str,
        local_bindings: dict[str, int],
        bool_elements: bool = False,
    ) -> list[ExprRef] | None:
        """Unroll a list-shaped argument to a Python list of Z3 exprs.

        Accepts ``ast.ListComp``, ``ast.GeneratorExp``, or an explicit
        ``ast.List`` / ``ast.Tuple`` literal. ``bool_elements=True`` lowers
        each element via ``_ast_to_z3_bool``; otherwise via ``_ast_to_z3``.
        Returns ``None`` if any element fails to lower or the shape is
        unsupported.
        """
        if isinstance(node, (ast.ListComp, ast.GeneratorExp)):
            return self._unroll_comprehension(
                node, context, local_bindings, bool_elements=bool_elements
            )
        if isinstance(node, (ast.List, ast.Tuple)):
            results: list[ExprRef] = []
            for elt in node.elts:
                lowered = (
                    self._ast_to_z3_bool(elt, context, local_bindings)
                    if bool_elements
                    else self._ast_to_z3(elt, context, local_bindings)
                )
                if lowered is None:
                    return None
                results.append(lowered)  # type: ignore[arg-type]
            return results
        return None

    def _unroll_comprehension(
        self, node, context: str, local_bindings: dict[str, int], bool_elements: bool = False
    ) -> list[ExprRef] | None:
        """Statically unroll a ``ListComp`` / ``GeneratorExp`` into a Python list of Z3 exprs.

        Each generator's ``iter`` must be a ``range(...)`` call resolvable at
        build time (integer literals OR ``len(<item>.rows|columns)`` via
        ``_resolve_range_call``). Multiple generators compose via
        ``itertools.product``. ``if`` filters are evaluated per-combination
        with ``_ast_to_z3_bool``; resolvable ``False`` skips the combo,
        unresolvable (None) propagates upward as None.
        """
        # Resolve every generator's iterable into a concrete range.
        ranges: list[tuple[str, range, list[ast.expr]]] = []
        for gen in node.generators:
            if not isinstance(gen.target, ast.Name):
                # ``for j, k in …`` — tuple targets unsupported.
                return None
            r = self._resolve_range_call(gen.iter, local_bindings)
            if r is None:
                return None
            ranges.append((gen.target.id, r, gen.ifs))

        results: list[ExprRef] = []
        # Cartesian product over the resolved ranges.
        target_names = [t for t, _, _ in ranges]
        value_lists = [list(vals) for _, vals, _ in ranges]
        guard_lists = [ifs for _, _, ifs in ranges]

        for combo in itertools.product(*value_lists):
            # Build a fresh local binding scope including the outer one and
            # this combo's loop-variable values.
            scope = dict(local_bindings)
            scope.update(dict(zip(target_names, combo, strict=False)))

            # Evaluate guards in scope. Each guard must reduce to a build-time
            # constant after simplification — loop variables are bound to int
            # literals, so any guard like ``k > j`` with both names in scope
            # simplifies to ``True`` / ``False``. Non-constant guards (e.g.,
            # references to a runtime item outcome) are unsupported for the
            # pattern set this unroller targets and propagate None.
            keep = True
            for ifs in guard_lists:
                for guard_expr in ifs:
                    guard_val = self._ast_to_z3_bool(guard_expr, context, scope)
                    if guard_val is None:
                        return None
                    simplified = simplify(guard_val)
                    if is_true(simplified):
                        continue
                    if is_false(simplified):
                        keep = False
                        break
                    # Non-constant guard — unsupported for this pattern set.
                    return None
                if not keep:
                    break
            if not keep:
                continue

            elt = (
                self._ast_to_z3_bool(node.elt, context, scope)
                if bool_elements
                else self._ast_to_z3(node.elt, context, scope)
            )
            if elt is None:
                return None
            results.append(elt)  # type: ignore[arg-type]
        return results

    def _ast_to_z3(
        self, node: ast.AST, context: str, local_bindings: dict[str, int] | None = None
    ) -> ExprRef | None:
        """Convert AST node to Z3 expression.

        ``local_bindings`` carries comprehension loop-variable values during
        unrolling (e.g., ``{'j': 0, 'k': 1}``). Loop variables resolve to
        ``IntVal`` literals; they are checked BEFORE ``self.item_vars`` /
        ``version_map`` to avoid masking item names. ``local_bindings`` is
        scope-local — never written back to ``self.version_map``.
        """
        if local_bindings is None:
            local_bindings = {}
        if isinstance(node, ast.Constant):
            if isinstance(node.value, bool):
                return IntVal(1 if node.value else 0, self.ctx)
            elif isinstance(node.value, int):
                return IntVal(node.value, self.ctx)
            elif isinstance(node.value, str):
                return IntVal(hash(node.value) % 1000000, self.ctx)

        elif isinstance(node, ast.Name):
            # Comprehension loop variables shadow everything else.
            if node.id in local_bindings:
                return IntVal(local_bindings[node.id], self.ctx)
            return self._get_current_z3_var(node.id)

        elif isinstance(node, ast.Attribute):
            if isinstance(node.value, ast.Name) and node.attr == "outcome":
                item_id = node.value.id
                if item_id in self.item_vars:
                    return self.item_vars[item_id]
                # Text items have string outcomes — return sentinel 0
                if (
                    item_id in self.item_details
                    and self.item_details[item_id].get("control") == "Textarea"
                ):
                    return IntVal(0, self.ctx)
                # Matrix items: bare .outcome (no subscript) is unsupported.
                # Caller's WARNING-on-None machinery surfaces this to the author.
                if item_id in self.item_cells:
                    return None

        elif isinstance(node, ast.Subscript):
            # X.outcome[j][k]   →  item_cells[X][(j, k)]
            # X.outcome[j]      →  None (one-level subscript on a matrix has no
            #                       scalar lowering; only fold-context unrolling
            #                       handles row-slice reads — see _unroll_list_arg)
            # arr[i] for non-matrix arr → None (no Python list semantics in Z3)
            return self._lower_subscript(node, context, local_bindings)

        elif isinstance(node, ast.BinOp):
            left = self._ast_to_z3(node.left, context, local_bindings)
            right = self._ast_to_z3(node.right, context, local_bindings)
            if left is not None and right is not None:
                if isinstance(node.op, ast.Add):
                    return left + right
                elif isinstance(node.op, ast.Sub):
                    return left - right
                elif isinstance(node.op, ast.Mult):
                    return left * right
                elif isinstance(node.op, ast.Div):
                    return left / right  # Integer division in Z3
                elif isinstance(node.op, ast.FloorDiv):
                    return left / right
                elif isinstance(node.op, ast.Mod):
                    return left % right

        elif isinstance(node, ast.UnaryOp):
            operand = self._ast_to_z3(node.operand, context, local_bindings)
            if operand is not None:
                if isinstance(node.op, ast.USub):
                    return -operand
                elif isinstance(node.op, ast.UAdd):
                    return operand

        elif isinstance(node, ast.IfExp):
            # Ternary operator: a if condition else b
            test = self._ast_to_z3_bool(node.test, context, local_bindings)
            body = self._ast_to_z3(node.body, context, local_bindings)
            orelse = self._ast_to_z3(node.orelse, context, local_bindings)
            if test is not None and body is not None and orelse is not None:
                return If(test, body, orelse)

        elif isinstance(node, ast.Call):
            return self._lower_call_value(node, context, local_bindings)

        elif isinstance(node, (ast.ListComp, ast.GeneratorExp)):
            # In a value (non-bool) context, a comprehension only makes sense
            # when wrapped by a fold (sum/all/any/len(set(...))). The fold
            # lowering invokes _unroll_list_arg directly; bare comprehension
            # here is unsupported.
            return None

        return None

    def _ast_to_z3_bool(
        self, node: ast.AST, context: str, local_bindings: dict[str, int] | None = None
    ) -> BoolRef | None:
        """Convert AST node to Z3 boolean expression.

        ``local_bindings`` is the comprehension-loop substitution dict (see
        ``_ast_to_z3``).
        """
        if local_bindings is None:
            local_bindings = {}
        if isinstance(node, ast.Compare):
            # Pattern-match the ranking-distinctness shape BEFORE general
            # comparison handling, so the LHS ``len(set([…]))`` doesn't fall
            # through into bare scalar lowering.
            distinct = self._try_distinct_pattern(node, context, local_bindings)
            if distinct is not None:
                return distinct

            # Support chained comparisons: a < b < c → (a < b) and (b < c)
            if len(node.ops) != len(node.comparators):
                return None
            clauses: list[BoolRef] = []
            lhs = self._ast_to_z3(node.left, context, local_bindings)
            if lhs is None:
                return None
            for op, comp in zip(node.ops, node.comparators, strict=False):
                # In/NotIn need the raw AST comparator (list/tuple/set), not Z3 value
                if isinstance(op, (ast.In, ast.NotIn)):
                    if isinstance(comp, (ast.List, ast.Tuple, ast.Set)):
                        member_vals = [
                            self._ast_to_z3(elt, context, local_bindings) for elt in comp.elts
                        ]
                        member_vals = [v for v in member_vals if v is not None]
                        if not member_vals:
                            return None
                        membership = Or(*[lhs == v for v in member_vals])
                        if isinstance(op, ast.In):
                            clauses.append(membership)
                        else:
                            clauses.append(Not(membership))
                    else:
                        return None
                    # For chained comparisons after In/NotIn, lhs stays the same
                    continue

                rhs = self._ast_to_z3(comp, context, local_bindings)
                if rhs is None:
                    return None
                if isinstance(op, ast.Eq):
                    clauses.append(lhs == rhs)
                elif isinstance(op, ast.NotEq):
                    clauses.append(lhs != rhs)
                elif isinstance(op, ast.Lt):
                    clauses.append(lhs < rhs)
                elif isinstance(op, ast.LtE):
                    clauses.append(lhs <= rhs)
                elif isinstance(op, ast.Gt):
                    clauses.append(lhs > rhs)
                elif isinstance(op, ast.GtE):
                    clauses.append(lhs >= rhs)
                else:
                    # ast.Is, ast.IsNot, etc. - unsupported, return None
                    return None
                lhs = rhs  # Next comparison uses current comparator as left
            return And(*clauses) if len(clauses) > 1 else clauses[0] if clauses else None

        elif isinstance(node, ast.BoolOp):
            if isinstance(node.op, ast.And):
                clauses = [self._ast_to_z3_bool(v, context, local_bindings) for v in node.values]
                clauses = [c for c in clauses if c is not None]
                return And(*clauses) if len(clauses) > 1 else clauses[0] if clauses else None
            elif isinstance(node.op, ast.Or):
                clauses = [self._ast_to_z3_bool(v, context, local_bindings) for v in node.values]
                clauses = [c for c in clauses if c is not None]
                return Or(*clauses) if len(clauses) > 1 else clauses[0] if clauses else None

        elif isinstance(node, ast.UnaryOp):
            if isinstance(node.op, ast.Not):
                operand = self._ast_to_z3_bool(node.operand, context, local_bindings)
                return Not(operand) if operand is not None else None

        elif isinstance(node, ast.Constant):
            if isinstance(node.value, bool):
                return BoolVal(node.value, self.ctx)

        elif isinstance(node, ast.Call):
            # all(xs) / any(xs) lower to z3.And / z3.Or over an unrolled list.
            return self._lower_call_bool(node, context, local_bindings)

        # Try to interpret as expression and check truthiness
        expr = self._ast_to_z3(node, context, local_bindings)
        if expr is not None:
            if isinstance(expr, BoolRef):
                return expr
            # Non-zero is true
            return expr != 0

        return None

    def get_constraints(self) -> list[BoolRef]:
        """Get all Z3 constraints."""
        return self.constraints

    def _resolve_item_dependencies(self, node: str, visited: set[str]) -> set[str]:
        """Get all item dependencies, following variable paths transitively.

        Walks the dependency graph, following var: nodes to find the ultimate
        item dependencies. For example:
        - q2 → var:score → q1 resolves to q2 → q1

        Args:
            node: Starting node (item_id or "var:variable_name")
            visited: Set of already visited nodes (to prevent infinite loops)

        Returns:
            Set of item IDs that this node ultimately depends on
        """
        if node in visited:
            return set()
        visited.add(node)

        item_deps = set()
        for dep in self.dependency_graph.get(node, set()):
            if dep.startswith("var:"):
                # Recursively resolve variable dependencies
                item_deps.update(self._resolve_item_dependencies(dep, visited.copy()))
            else:
                # Direct item dependency
                item_deps.add(dep)
        return item_deps

    def get_item_dependencies(self) -> dict[str, set[str]]:
        """Get item-to-item dependencies (resolved through variables).

        Returns a dictionary mapping each item to the set of items it depends on,
        with transitive dependencies through variables resolved.

        For example, if:
        - q1 has codeBlock: score = q1.outcome
        - q2 has precondition: score > 5

        Then get_item_dependencies() returns {'q2': {'q1'}, ...} because q2
        depends on q1 transitively through var:score.

        Includes Textarea items (no Z3 var) when they carry dependency_graph
        entries — e.g. a Textarea inner roster item inheriting iterateOver
        deps from its Roster. Topology needs these entries to compute
        a correct evaluation order even when the item itself isn't constrained.
        """
        # Union of items with Z3 vars and items registered in dependency_graph
        # (the latter covers Textarea items that get deps via roster inheritance
        # or precondition/codeBlock references).
        item_ids = set(self.item_vars.keys()) | set(self.dependency_graph.keys())
        # Filter out non-item nodes (e.g., var:NAME entries that share the dict).
        item_ids = {i for i in item_ids if not i.startswith("var:")}

        result = {}
        for item_id in item_ids:
            deps = self._resolve_item_dependencies(item_id, set())
            # An item cannot depend on itself. Direct self-references in
            # preconditions/postconditions are already filtered, but indirect
            # paths through variables can create false self-dependencies
            # (e.g., postcondition reads var:x, codeBlock writes var:x with
            # self.outcome → transitive self-dep). This is a false positive
            # because the runtime lifecycle is: precondition → outcome →
            # postcondition → codeBlock. A postcondition CAN reference any
            # variable, but it sees the prior value — the current item's
            # codeBlock hasn't run yet, so it cannot affect the postcondition.
            deps.discard(item_id)
            result[item_id] = deps
        return result

    def get_dependency_graph(self) -> dict[str, set[str]]:
        """Get full dependency graph including variable nodes.

        Returns the raw dependency graph with both item nodes and var: nodes.
        Useful for debugging and visualization.
        """
        return {k: v.copy() for k, v in self.dependency_graph.items()}

    def get_all_z3_vars(self) -> dict[str, ExprRef]:
        """Get all Z3 variables (SSA versions, scalar item outcomes, matrix cells)."""
        all_vars = dict(self.z3_vars)
        all_vars.update(self.item_vars)
        # Matrix cells: flatten ``item_cells[id][(r, c)]`` to ``item_{id}_{r}_{c}``
        for item_id, cells in self.item_cells.items():
            for (r, c), cell_var in cells.items():
                all_vars[f"item_{item_id}_{r}_{c}"] = cell_var
        return all_vars

    def get_domain_base(self) -> BoolRef:
        """
        Get domain-only base constraint B as defined in the thesis.

        B := ∧_i D_i(S_i) where D_i(S_i) are domain constraints:
        - min/max for Editbox/Slider controls
        - enumeration for Radio/Dropdown controls

        This is the correct B for use in:
        - Per-item validation: W_i = B ∧ P_i ∧ ¬Q_i
        - Global validation: F = B ∧ ∧(P_i ⇒ Q_i)
        - Path-based validation: A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)
        """
        if not self.domain_constraints:
            return BoolVal(True, self.ctx)
        elif len(self.domain_constraints) == 1:
            return self.domain_constraints[0]
        else:
            return And(*self.domain_constraints)

    def get_full_base(self) -> BoolRef:
        """
        Get full base constraint B_full = B ∧ codeblock_constraints.

        This includes:
        - Domain constraints D_i(S_i) from get_domain_base()
        - CodeBlock constraints from codeBlock assignments (SSA)

        Does NOT include precondition/postcondition implications from self.constraints,
        as those are what we're validating against.

        Use this for postcondition validation when postconditions reference
        computed variables (not just item outcomes). The codeBlock constraints
        establish the relationship between computed variables and item outcomes,
        enabling proper bounds checking.

        Example: If var1 = q1.outcome + q2.outcome (from codeBlocks),
        and q1 ∈ [0,10], q2 ∈ [10,20], then var1 ∈ [10,30].
        Without codeBlock constraints, var1 would be unconstrained.
        """
        all_constraints = list(self.domain_constraints) + list(self.codeblock_constraints)
        if not all_constraints:
            return BoolVal(True, self.ctx)
        elif len(all_constraints) == 1:
            return all_constraints[0]
        else:
            return And(*all_constraints)

    def compile_conditions(self, item_id: str, conditions: list[dict[str, Any]]) -> BoolRef:
        """Compile a list of conditions to a single Z3 boolean expression (ItemClassifier compatibility)."""
        if not conditions:
            return BoolVal(True, self.ctx)

        compiled_conditions = []

        for condition in conditions:
            predicate = condition.get("predicate", "")
            if predicate:
                compiled = self._compile_predicate_to_z3(predicate, item_id)
                if compiled is not None:
                    compiled_conditions.append(compiled)

        if not compiled_conditions:
            return BoolVal(True, self.ctx)
        elif len(compiled_conditions) == 1:
            return compiled_conditions[0]
        else:
            return And(*compiled_conditions)

    def _compile_predicate_to_z3(self, predicate: str, context: str) -> BoolRef | None:
        """Compile a predicate string to Z3 boolean expression."""
        try:
            tree = ast.parse(predicate, mode="eval")
            return self._ast_to_z3_bool(tree.body, context)
        except Exception as e:
            self.logger.error(f"Error compiling predicate '{predicate}' in context {context}: {e}")
            return None

    def debug_dump(self) -> str:
        """Generate debug output."""
        lines = []
        lines.append("=" * 60)
        lines.append("SSA BUILDER DEBUG DUMP")
        lines.append("=" * 60)

        lines.append(f"\n📊 SSA Versions ({len(self.version_map)} variables):")
        for var, version in sorted(self.version_map.items()):
            lines.append(f"  {var}: current version = {version}")
            if var in self.version_history:
                for v, ctx in self.version_history[var]:
                    lines.append(f"    v{v} at {ctx}")

        lines.append(f"\n📦 Item Variables ({len(self.item_vars)} items):")
        resolved_deps = self.get_item_dependencies()
        for item_id in sorted(self.item_vars.keys()):
            deps = resolved_deps.get(item_id, set())
            if deps:
                lines.append(f"  {item_id} depends on: {', '.join(sorted(deps))}")
            else:
                lines.append(f"  {item_id} (no dependencies)")

        lines.append(f"\n🔗 Dependency Graph ({len(self.dependency_graph)} nodes):")
        for node, deps in sorted(self.dependency_graph.items()):
            if deps:
                lines.append(f"  {node} → {', '.join(sorted(deps))}")

        lines.append(f"\n🔗 CodeBlock Constraints: {len(self.codeblock_constraints)}")
        lines.append(f"🔗 Pre/Post Constraints: {len(self.constraints)}")

        lines.append(f"\n🔍 All Z3 Variables: {len(self.get_all_z3_vars())}")

        return "\n".join(lines)
