"""
Quality Scorecard — deterministic "soft quality" metrics over validation artifacts.

Z3 validation proves consistency (reachability, satisfiability, no cycles);
this module measures *design quality* — the degree-questions validation cannot
answer: how constraining the gates are, how much of the logic is inside Z3's
reach, how tailored the flow is, how coherent the authored order is, and how
burdensome the instrument is. A questionnaire with zero postconditions and zero
branching validates exactly as cleanly as a disciplined one; the scorecard is
the layer that tells them apart.

Architectural constraints (plan 2026-07-06-002):

- **Deterministic and derived.** Every number is computed from artifacts the
  validation pipeline already builds (StaticBuilder census / coverage gaps /
  postcondition analysis, QMLTopology, ItemClassifier statuses). No new Z3
  passes, no re-parsing, no LLM — two runs over the same file return identical
  reports (the MCP tool's determinism contract).
- **Advisory, never gating.** Scorecard grades are Designer-loop feedback; they
  never feed ``is_valid`` or the publish gate, which stays soundness-only.
- **Per-dimension grades, no composite.** A blended score would let one
  dimension be gamed against another and hide which one failed; consumers get
  a vector of grades with raw metrics and worst-offender evidence attached.
- **Policy reuse, not re-derivation.** Dead-weight variables (D2) are counted
  from ``ValidationProcessor.to_issues()`` output so the hygiene exemptions
  (self-only accumulators, two-producer consolidations) stay single-sited in
  the issue policy rather than being re-implemented here.

Dimension ids D2–D8 match the plan's numbering. D1 (KPI coverage) is
deliberately absent: it comes from the answerability chain, which needs
LLM-supplied goal association and therefore lives with the calling agent,
not in this LLM-free layer. D9/D10 are reviewer judgment, also not here.

Grade bands are module-level constants calibrated against the 12-file
conversion corpus (plan U2); each band records its rationale beside it.
"""

import logging
from collections.abc import Mapping, Sequence
from typing import Any

from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.static_builder import StaticBuilder

logger = logging.getLogger(__name__)

# Grade vocabulary — the only values a dimension's ``grade`` field may take.
GRADE_STRONG = "strong"
GRADE_ADEQUATE = "adequate"
GRADE_WEAK = "weak"
GRADE_NA = "not_applicable"

# Worst-offender lists are capped so the report stays readable; the
# ``truncated`` flag makes the cap explicit (no silent truncation).
OFFENDER_CAP = 10

# ---------------------------------------------------------------------------
# Grade bands — calibrated on the 12-file conversion corpus (plan U2).
# Each constant is the *lower* threshold of the named grade unless noted.
# ---------------------------------------------------------------------------

# D2: share of censused variables that are dead weight (write-only or
# pass-through alias). 0 dead weight is the disciplined baseline; the corpus
# pathological files carry 30-60% dead variables.
ECONOMY_ADEQUATE_MAX_DEAD_SHARE = 0.25

# D3: share of classified items whose postcondition is CONSTRAINING. The
# corpus audit found seven of twelve files at exactly 0 constraining share;
# SLID — regenerated under the 2026-07-05 generation-discipline rules and the
# corpus's disciplined exemplar — sits at 0.207, which anchors the strong band.
GATE_STRONG_MIN_CONSTRAINING_SHARE = 0.20
GATE_ADEQUATE_MIN_CONSTRAINING_SHARE = 0.10

# D4: share of authored predicates fully lowered to Z3 (no runtime fallback,
# no textarea sentinel, no phantom). The "formally verified" claim should
# cover (nearly) everything; a file living off runtime fallbacks isn't
# verified in any meaningful sense.
VERIFICATION_STRONG_MIN_COVERAGE = 0.95
VERIFICATION_ADEQUATE_MIN_COVERAGE = 0.80

# D5: decision-point density (precondition predicates per item). Zero means
# no adaptive logic at all; far above 1.5/item the skip pattern is denser
# than the content and maintainability suffers (Fagan & Greenberg's
# decision-point counting is the underlying measure).
COMPLEXITY_STRONG_MIN_DENSITY = 0.05
COMPLEXITY_STRONG_MAX_DENSITY = 1.00
COMPLEXITY_WEAK_MAX_DENSITY = 2.00

# D6: normalized inversion share between authored order and the stable-Kahn
# topological order. Stable Kahn tiebreaks on file order, so zero inversions
# holds iff the authored order is already topologically consistent.
ORDER_ADEQUATE_MAX_INVERSION_SHARE = 0.05

# D7: share of items that are CONDITIONAL, and the minimum number of distinct
# gate sources for a flow to count as genuinely scenario-tailored.
DIVERSITY_STRONG_MIN_CONDITIONAL_SHARE = 0.20
DIVERSITY_STRONG_MIN_GATE_SOURCES = 2

# D8: worst-case / guaranteed burden spread. A spread of ~3x reads as healthy
# tailoring; past ~6x one branch is an entirely different (and much longer)
# interview than another.
BURDEN_STRONG_MAX_SPREAD = 3.0
BURDEN_ADEQUATE_MAX_SPREAD = 6.0

# D8 item-cost table: relative respondent effort per item kind/control.
# Precision is not the goal — discriminating a 10-minute instrument from a
# 60-minute one is. Matrix rows each cost one answer; free text costs several
# closed answers; comments are read, not answered.
COST_COMMENT = 0.0
COST_TEXTAREA = 3.0
COST_DEFAULT = 1.0


def compute_quality_report(
    state: QMLState,
    topology: QMLTopology,
    builder: StaticBuilder,
    classifications: dict[str, Any],
    postcondition_records: list[dict[str, Any]],
    issues: list[dict[str, Any]],
) -> dict[str, Any]:
    """Compute the D2–D8 mechanical scorecard from validation artifacts.

    Args:
        state: The loaded questionnaire (authored item order).
        topology: Built topology (dependencies, stable topological order).
        builder: The StaticBuilder that produced the Z3 model (census, gaps).
        classifications: ``ValidationProcessor.get_item_classifications()``.
        postcondition_records: ``StaticBuilder.analyze_postconditions()``.
        issues: ``ValidationProcessor.to_issues()`` — reused for hygiene
            policy (D2) so exemptions stay single-sited.

    Returns:
        ``{"dimensions": {<name>: {"id", "grade", "metrics", "offenders",
        "truncated"}}, "item_count": int, "notes": [str, ...]}``
    """
    items = [item for item in state.get_all_items() if item.get("id")]
    notes: list[str] = []
    if topology.has_cycles:
        notes.append(
            "dependency cycles present — the topological order is approximate, "
            "so order-coherence (D6) reads as a best-effort measure"
        )

    dimensions = {
        "instrument_economy": _instrument_economy(builder, issues),
        "quality_gate_density": _quality_gate_density(
            classifications, postcondition_records
        ),
        "verification_coverage": _verification_coverage(state, builder),
        "structural_complexity": _structural_complexity(state, topology, items),
        "order_coherence": _order_coherence(items, topology),
        "path_diversity": _path_diversity(classifications, topology),
        "burden_balance": _burden_balance(items, classifications, topology),
    }

    return {
        "dimensions": dimensions,
        "item_count": len(items),
        "notes": notes,
    }


def _dimension(
    dim_id: str,
    grade: str,
    metrics: dict[str, Any],
    offenders: list[dict[str, Any]],
) -> dict[str, Any]:
    """Assemble one dimension entry, applying the offender cap explicitly."""
    truncated = len(offenders) > OFFENDER_CAP
    return {
        "id": dim_id,
        "grade": grade,
        "metrics": metrics,
        "offenders": offenders[:OFFENDER_CAP],
        "truncated": truncated,
    }


# ---------------------------------------------------------------------------
# D2 — instrument economy (dead weight)
# ---------------------------------------------------------------------------


def _instrument_economy(
    builder: StaticBuilder, issues: list[dict[str, Any]]
) -> dict[str, Any]:
    """Variables that gate nothing: write-only + pass-through aliases.

    Counts come from the issue list, not a re-derivation of the census, so
    the hygiene exemptions (self-only accumulators, two-producer
    consolidations) apply identically here and in ``to_issues``.
    """
    census = builder.get_variable_census()
    total_variables = len(census)

    dead_issues = [
        issue
        for issue in issues
        if issue.get("type") in ("write_only_variable", "pass_through_alias")
    ]
    dead_count = len(dead_issues)
    offenders = [
        {"item_id": issue.get("item_id"), "detail": issue.get("message", "")}
        for issue in dead_issues
    ]

    if total_variables == 0:
        # No state variables at all: nothing wasted, nothing to grade.
        return _dimension(
            "D2",
            GRADE_NA,
            {"total_variables": 0, "dead_weight_variables": 0, "dead_share": 0.0},
            [],
        )

    dead_share = dead_count / total_variables
    if dead_count == 0:
        grade = GRADE_STRONG
    elif dead_share <= ECONOMY_ADEQUATE_MAX_DEAD_SHARE:
        grade = GRADE_ADEQUATE
    else:
        grade = GRADE_WEAK

    return _dimension(
        "D2",
        grade,
        {
            "total_variables": total_variables,
            "dead_weight_variables": dead_count,
            "dead_share": round(dead_share, 4),
        },
        offenders,
    )


# ---------------------------------------------------------------------------
# D3 — quality-gate density
# ---------------------------------------------------------------------------


def _quality_gate_density(
    classifications: dict[str, Any],
    postcondition_records: list[dict[str, Any]],
) -> dict[str, Any]:
    """How many items carry a postcondition that actually filters responses.

    The metric is CONSTRAINING share, not raw postcondition count — the
    corpus audit's tautological postconditions validate cleanly while
    enforcing nothing, which is exactly the blind spot this dimension closes.
    """
    if not classifications:
        return _dimension("D3", GRADE_NA, {"reason": "no Z3 classifications"}, [])

    invariant_counts: dict[str, int] = {}
    weak_gate_offenders: list[dict[str, Any]] = []
    for item_id, classification in classifications.items():
        invariant = classification.get("postcondition", {}).get("invariant", "UNKNOWN")
        invariant_counts[invariant] = invariant_counts.get(invariant, 0) + 1
        if invariant in ("TAUTOLOGICAL", "INFEASIBLE"):
            weak_gate_offenders.append(
                {"item_id": item_id, "detail": f"postcondition is {invariant}"}
            )

    duplicate_bounds = [r for r in postcondition_records if r["duplicate_input_bound"]]
    weak_gate_offenders.extend(
        {
            "item_id": record["item_id"],
            "detail": "postcondition restates the control's own min/max",
        }
        for record in duplicate_bounds
    )

    total_items = len(classifications)
    constraining = invariant_counts.get("CONSTRAINING", 0)
    relational = sum(1 for r in postcondition_records if r["relational"])
    local = len(postcondition_records) - relational
    constraining_share = constraining / total_items

    if constraining_share >= GATE_STRONG_MIN_CONSTRAINING_SHARE:
        grade = GRADE_STRONG
    elif constraining_share >= GATE_ADEQUATE_MIN_CONSTRAINING_SHARE:
        grade = GRADE_ADEQUATE
    else:
        grade = GRADE_WEAK

    return _dimension(
        "D3",
        grade,
        {
            "items_total": total_items,
            "constraining_postcondition_items": constraining,
            "constraining_share": round(constraining_share, 4),
            "relational_postconditions": relational,
            "local_postconditions": local,
            "postcondition_invariants": invariant_counts,
            "duplicate_input_bounds": len(duplicate_bounds),
        },
        weak_gate_offenders,
    )


# ---------------------------------------------------------------------------
# D4 — verification coverage
# ---------------------------------------------------------------------------


def _verification_coverage(state: QMLState, builder: StaticBuilder) -> dict[str, Any]:
    """Share of authored predicates fully inside Z3's reach.

    A predicate that fell back to runtime enforcement (unsupported AST node),
    references a Textarea sentinel, or contains a phantom name is authored
    logic the formal layer does not verify. ``group_dependency`` gaps are
    excluded — those are structural errors, not verification degradation.
    """
    total_predicates = 0
    for item in state.get_all_items():
        total_predicates += len(item.get("precondition", []) or [])
        total_predicates += len(item.get("postcondition", []) or [])
    for block in state.get_blocks():
        total_predicates += len(block.get("precondition") or [])
        total_predicates += len(block.get("postcondition") or [])

    degraded: list[dict[str, Any]] = []
    for owner_id, gaps in builder.coverage_gaps.items():
        for gap in gaps:
            kind = gap.get("kind", "")
            if kind == "group_dependency":
                continue
            detail = kind
            if gap.get("unsupported_nodes"):
                detail = f"{kind} fell back to runtime: {', '.join(gap['unsupported_nodes'])}"
            elif kind == "undefined_name":
                detail = f"phantom identifier '{gap.get('identifier', '?')}'"
            elif kind == "textarea_in_predicate":
                detail = "free-text outcome in predicate (no Z3 variable)"
            degraded.append({"item_id": owner_id, "detail": detail})

    if total_predicates == 0:
        return _dimension(
            "D4",
            GRADE_NA,
            {"total_predicates": 0, "degraded_predicates": 0, "coverage_share": 1.0},
            [],
        )

    # A single predicate can carry several gap records; coverage is bounded
    # below at 0 rather than pretending negative coverage means something.
    coverage_share = max(0.0, 1.0 - len(degraded) / total_predicates)
    if coverage_share >= VERIFICATION_STRONG_MIN_COVERAGE:
        grade = GRADE_STRONG
    elif coverage_share >= VERIFICATION_ADEQUATE_MIN_COVERAGE:
        grade = GRADE_ADEQUATE
    else:
        grade = GRADE_WEAK

    return _dimension(
        "D4",
        grade,
        {
            "total_predicates": total_predicates,
            "degraded_predicates": len(degraded),
            "coverage_share": round(coverage_share, 4),
        },
        degraded,
    )


# ---------------------------------------------------------------------------
# D5 — structural complexity
# ---------------------------------------------------------------------------


def _structural_complexity(
    state: QMLState, topology: QMLTopology, items: Sequence[Mapping[str, Any]]
) -> dict[str, Any]:
    """Complexity vector: decision points, cyclomatic V(G), depth, constructs.

    Reported as a vector because a single number hides which axis is heavy.
    The grade keys on decision-point density alone: both extremes are the
    smell (0 = no adaptive logic; far above 1.5/item the skip pattern
    dominates the content).
    """
    decision_points = 0
    for item in state.get_all_items():
        decision_points += len(item.get("precondition", []) or [])
    for block in state.get_blocks():
        decision_points += len(block.get("precondition") or [])

    total_items = len(items)
    edges = sum(len(deps) for deps in topology.dependencies.values())
    components = len(topology.get_components())
    # Cyclomatic complexity over the dependency graph: V(G) = E - N + 2P.
    cyclomatic = edges - total_items + 2 * components
    depth = len(topology.get_dependency_layers())

    roster_blocks = state.get_blocks_by_kind("Roster")
    roster_iterations = sum(len(b.get("labels") or {}) for b in roster_blocks)
    # ``kind`` is optional and defaults to Group, so capped groups are found
    # by ``count`` over ALL blocks, not via the kind index.
    capped_groups = [b for b in state.get_blocks() if b.get("count") is not None]

    if total_items == 0:
        return _dimension("D5", GRADE_NA, {"items_total": 0}, [])

    density = decision_points / total_items
    if COMPLEXITY_STRONG_MIN_DENSITY <= density <= COMPLEXITY_STRONG_MAX_DENSITY:
        grade = GRADE_STRONG
    elif density == 0 or density > COMPLEXITY_WEAK_MAX_DENSITY:
        grade = GRADE_WEAK
    else:
        grade = GRADE_ADEQUATE

    return _dimension(
        "D5",
        grade,
        {
            "items_total": total_items,
            "decision_points": decision_points,
            "decision_density": round(density, 4),
            "dependency_edges": edges,
            "connected_components": components,
            "cyclomatic_complexity": cyclomatic,
            "dependency_depth": depth,
            "roster_blocks": len(roster_blocks),
            "roster_iterations_declared": roster_iterations,
            "capped_groups": len(capped_groups),
        },
        [],
    )


# ---------------------------------------------------------------------------
# D6 — order coherence
# ---------------------------------------------------------------------------


def _order_coherence(
    items: Sequence[Mapping[str, Any]], topology: QMLTopology
) -> dict[str, Any]:
    """Kendall-tau inversion share between authored order and delivered order.

    The FlowProcessor navigates ``topological_order``, so every inversion is
    an item the respondent sees somewhere other than where the author wrote
    it. Stable Kahn tiebreaks on file order, which makes zero inversions
    equivalent to "the authored order is already topologically consistent".
    """
    authored = [item["id"] for item in items]
    topo_rank = {item_id: idx for idx, item_id in enumerate(topology.topological_order)}
    # Items missing from the topological order (shouldn't happen — the
    # topology covers all ids) are dropped defensively rather than crashing.
    authored = [item_id for item_id in authored if item_id in topo_rank]
    n = len(authored)
    total_pairs = n * (n - 1) // 2

    if total_pairs == 0:
        return _dimension(
            "D6",
            GRADE_NA,
            {"items_total": n, "inversions": 0, "inversion_share": 0.0},
            [],
        )

    inversions = 0
    for i in range(n):
        rank_i = topo_rank[authored[i]]
        for j in range(i + 1, n):
            if rank_i > topo_rank[authored[j]]:
                inversions += 1

    inversion_share = inversions / total_pairs

    # Offenders: items displaced furthest from their authored position.
    displacements = [
        {
            "item_id": item_id,
            "detail": (
                f"authored at position {authored_idx}, delivered at "
                f"{topo_rank[item_id]}"
            ),
            "_displacement": abs(authored_idx - topo_rank[item_id]),
        }
        for authored_idx, item_id in enumerate(authored)
        if authored_idx != topo_rank[item_id]
    ]
    displacements.sort(key=lambda d: (-d["_displacement"], d["item_id"]))
    offenders = [
        {"item_id": d["item_id"], "detail": d["detail"]} for d in displacements
    ]

    if inversions == 0:
        grade = GRADE_STRONG
    elif inversion_share <= ORDER_ADEQUATE_MAX_INVERSION_SHARE:
        grade = GRADE_ADEQUATE
    else:
        grade = GRADE_WEAK

    return _dimension(
        "D6",
        grade,
        {
            "items_total": n,
            "inversions": inversions,
            "inversion_share": round(inversion_share, 4),
            "max_displacement": (
                displacements[0]["_displacement"] if displacements else 0
            ),
        },
        offenders,
    )


# ---------------------------------------------------------------------------
# D7 — path diversity
# ---------------------------------------------------------------------------


def _path_diversity(
    classifications: dict[str, Any], topology: QMLTopology
) -> dict[str, Any]:
    """How tailored the flow is: conditional share and distinct gate sources.

    Deliberately NOT an exact path count — enumerating satisfiable paths is
    exponential (model counting), so the honest report is the branching
    inputs: how many items branch, and how many independent sources gate them.
    """
    if not classifications:
        return _dimension("D7", GRADE_NA, {"reason": "no Z3 classifications"}, [])

    status_counts: dict[str, int] = {}
    conditional_items: list[str] = []
    for item_id, classification in classifications.items():
        status = classification.get("precondition", {}).get("status", "UNKNOWN")
        status_counts[status] = status_counts.get(status, 0) + 1
        if status == "CONDITIONAL":
            conditional_items.append(item_id)

    gate_sources = sorted(
        {
            dep
            for item_id in conditional_items
            for dep in topology.dependencies.get(item_id, set())
        }
    )

    total_items = len(classifications)
    conditional_share = len(conditional_items) / total_items

    if (
        conditional_share >= DIVERSITY_STRONG_MIN_CONDITIONAL_SHARE
        and len(gate_sources) >= DIVERSITY_STRONG_MIN_GATE_SOURCES
    ):
        grade = GRADE_STRONG
    elif conditional_items:
        grade = GRADE_ADEQUATE
    else:
        grade = GRADE_WEAK

    return _dimension(
        "D7",
        grade,
        {
            "items_total": total_items,
            "reachability_statuses": status_counts,
            "conditional_share": round(conditional_share, 4),
            "gate_source_count": len(gate_sources),
            "gate_sources": gate_sources[:OFFENDER_CAP],
        },
        [],
    )


# ---------------------------------------------------------------------------
# D8 — burden & balance
# ---------------------------------------------------------------------------


def _item_cost(item: Mapping[str, Any]) -> float:
    """Relative respondent effort for one authored item (cost table above)."""
    kind = item.get("kind", "Question")
    if kind == "Comment":
        return COST_COMMENT
    if kind == "MatrixQuestion":
        # Each matrix row is one answer; rows/columns are top-level item keys
        # on MatrixQuestion (never `questions`, which belongs to QuestionGroup).
        return float(max(1, len(item.get("rows", []) or [])))
    control = (item.get("input", {}) or {}).get("control", "")
    if control == "Textarea":
        return COST_TEXTAREA
    return COST_DEFAULT


def _burden_balance(
    items: Sequence[Mapping[str, Any]],
    classifications: dict[str, Any],
    topology: QMLTopology,
) -> dict[str, Any]:
    """Cost-weighted burden bounds and screening economy.

    Guaranteed burden = items every respondent answers (ALWAYS, outside
    Roster/capped-Group constructs — a Roster can run zero iterations and a
    capped-Group item can go undrawn). Worst case = every reachable item at
    full construct width (Roster at all declared labels, capped Groups at
    their costliest ``count`` members). Screening economy is the weighted
    normalized delivered position of the gate-producing items: lower means
    screen-out decisions fire early and waste less answered time.
    """
    if not items:
        return _dimension("D8", GRADE_NA, {"items_total": 0}, [])

    def status_of(item_id: str) -> str:
        return (
            classifications.get(item_id, {})
            .get("precondition", {})
            .get("status", "UNKNOWN")
        )

    guaranteed = 0.0
    worst_case = 0.0
    capped_group_costs: dict[str, list[float]] = {}
    capped_group_counts: dict[str, int] = {}

    for item in items:
        item_id = item["id"]
        status = status_of(item_id)
        if status == "NEVER":
            continue
        cost = _item_cost(item)

        if item.get("_roster_block_id"):
            # Worst case: one pass per declared label; guaranteed: a roster
            # bitmask can be 0, so roster items are never guaranteed.
            worst_case += cost * max(1, len(item.get("_roster_labels") or {}))
            continue

        group_id = item.get("_group_block_id")
        if group_id and item.get("_group_count") is not None:
            # Capped Group: at most ``count`` members are asked; worst case
            # takes the costliest ``count``. Never guaranteed per item (the
            # draw can pass any specific item over).
            capped_group_costs.setdefault(group_id, []).append(cost)
            capped_group_counts[group_id] = item["_group_count"]
            continue

        worst_case += cost
        if status == "ALWAYS":
            guaranteed += cost

    for group_id, costs in capped_group_costs.items():
        costs.sort(reverse=True)
        worst_case += sum(costs[: capped_group_counts[group_id]])

    # Screening economy: weighted mean normalized delivered position of the
    # items that gate CONDITIONAL items, weighted by how many items each gates.
    topo_order = topology.topological_order
    topo_rank = {item_id: idx for idx, item_id in enumerate(topo_order)}
    denominator = max(1, len(topo_order) - 1)
    gate_weights: dict[str, int] = {}
    for item_id, deps in topology.dependencies.items():
        if status_of(item_id) == "CONDITIONAL":
            for dep in deps:
                gate_weights[dep] = gate_weights.get(dep, 0) + 1
    weighted_positions = [
        (topo_rank[gate] / denominator) * weight
        for gate, weight in gate_weights.items()
        if gate in topo_rank
    ]
    total_weight = sum(
        weight for gate, weight in gate_weights.items() if gate in topo_rank
    )
    screening_position = (
        round(sum(weighted_positions) / total_weight, 4) if total_weight else None
    )

    spread_ratio = round(worst_case / guaranteed, 2) if guaranteed > 0 else None

    if spread_ratio is None:
        # Nothing is guaranteed (fully conditional instrument) — spread is
        # undefined rather than infinite; the reviewer contextualizes.
        grade = GRADE_ADEQUATE
    elif spread_ratio <= BURDEN_STRONG_MAX_SPREAD:
        grade = GRADE_STRONG
    elif spread_ratio <= BURDEN_ADEQUATE_MAX_SPREAD:
        grade = GRADE_ADEQUATE
    else:
        grade = GRADE_WEAK

    return _dimension(
        "D8",
        grade,
        {
            "items_total": len(items),
            "guaranteed_burden": round(guaranteed, 2),
            "worst_case_burden": round(worst_case, 2),
            "burden_spread_ratio": spread_ratio,
            "screening_position": screening_position,
        },
        [],
    )
