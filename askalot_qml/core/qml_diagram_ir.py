"""
QMLDiagramIR - Positions-free structural IR for QML questionnaires.

Emits a typed intermediate representation consumed by the React + React Flow
webview in the QML Explorer extension. The webview runs ELK.js client-side
for layout — this module never computes positions.

IR shape (top-level arrays, no flat `nodes[]` with a `type` discriminator):

    {
      "blocks":     [{id, title, kind, iterate_over?, labels?, label_count?,
                      count?,
                      classification?, precondition_count, postcondition_count}, ...],
                      # Roster: iterate_over/labels/label_count.
                      # Group (capped): count (the N draw cap) — drives the
                      #         count badge in the diagram-viewer. An uncapped
                      #         Group omits count entirely.
      "items":      [{id, block_id, title, kind, control_type, classification}, ...],
      "conditions": [{id, owner_id, owner_kind, kind, predicate_label,
                      predicate, source_index,
                      references: [{kind, target_id}]}, ...],  # kind: "pre"|"post"
                      # references: "item_outcome" → item_id;
                      #             "variable_read" → var_<name>_v<latest_version>
      "variables":  [{id, name, version, anchor_item_id}, ...],
      "edges":      [{source, target, kind}],
                    # kind: "topology"|"cycle"|"version_chain"|"condition_ref"
                    #       |"bitmask_source"
                    # condition_ref edges connect a condition chiclet to each
                    # item/variable its predicate reads — one edge per reference.
                    # bitmask_source edges run from a Roster block id to the
                    # item/variable supplying its `iterateOver` bitmask (one
                    # edge per resolved reference). Source is the block id;
                    # target is an item id (item-outcome read) or
                    # var_<name>_v<latest_version> (variable read).
      "metadata":   {has_cycles, topological_order, cycle_nodes, cycle_edges}
    }

`apply_validation_coloring()` inlines classification onto block/item entries
directly (no separate `classes` map) — single-pass consumption for the client.
"""

import ast
import logging
from typing import Any

from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.qml_state import QMLState


class QMLDiagramIR:
    """Generate positions-free structural IR for QML questionnaires."""

    def __init__(self, topology: QMLTopology, questionnaire_state: QMLState):
        self.topology = topology
        self.state = questionnaire_state
        self.logger = logging.getLogger(__name__)
        self.items_by_id = {
            item["id"]: item for item in self.state.get_all_items() if item.get("id")
        }
        # Pre-group items by their owning block. Without this, _emit_blocks
        # and _emit_conditions both call self.state.get_items_by_block(id)
        # for every block, which is a full-list scan each time — O(blocks ×
        # items) on a flat questionnaire.
        self.items_by_block: dict[str, list[dict]] = {}
        for item in self.state.get_items():
            block_id = item.get("blockId")
            if block_id:
                self.items_by_block.setdefault(block_id, []).append(item)

    # ------------------------------------------------------------------
    # Base IR — cacheable structure, no classification.
    # ------------------------------------------------------------------

    def generate_base_graph(self) -> dict:
        """Build the positions-free IR from the current topology and state."""
        topological_order: list[str] = list(self.topology.topological_order or [])
        has_cycles = bool(self.topology.has_cycles)
        topology_items = set(self.topology.items or [])

        blocks = self._emit_blocks(topology_items)
        items = self._emit_items(topology_items, topological_order)
        variables = self._emit_variables()
        # Conditions need the variable index to resolve `Name(x)` references
        # to the latest emitted version `var_<x>_v<n>` — build the index here
        # and pass it down.
        latest_variable_ids = _build_latest_variable_index(variables)
        item_ids = set(self.items_by_id.keys())
        conditions = self._emit_conditions(
            topology_items,
            item_ids=item_ids,
            latest_variable_ids=latest_variable_ids,
        )

        chain = topological_order if topological_order else list(topology_items)
        edges = self._emit_topology_edges(chain)
        edges.extend(self._emit_version_chain_edges())
        edges.extend(self._emit_condition_ref_edges(conditions))
        edges.extend(
            self._emit_bitmask_source_edges(
                topology_items,
                item_ids=item_ids,
                latest_variable_ids=latest_variable_ids,
            )
        )
        cycle_edges, cycle_members = self._emit_cycle_edges(chain)
        edges.extend(cycle_edges)

        # Mark topology edges that straddle cycle membership — the React layer
        # uses this to style them as in-cycle even though the edge kind stays
        # "topology" (the edge itself is not a cycle-closing arc).
        for edge in edges:
            if edge["kind"] == "topology":
                if edge["source"] in cycle_members and edge["target"] in cycle_members:
                    edge["in_cycle"] = True

        return {
            "blocks": blocks,
            "items": items,
            "conditions": conditions,
            "variables": variables,
            "edges": edges,
            "metadata": {
                "has_cycles": has_cycles,
                "topological_order": topological_order,
                "cycle_nodes": sorted(cycle_members),
                "cycle_edges": [
                    {"source": e["source"], "target": e["target"]} for e in cycle_edges
                ],
            },
        }

    def _emit_blocks(self, topology_items: set) -> list[dict]:
        """Emit one entry per block that contains at least one topology item."""
        out: list[dict] = []
        for block in self.state.get_blocks():
            block_id = block.get("id", "")
            if not block_id:
                continue
            block_items = self.items_by_block.get(block_id, [])
            if not any(item.get("id") in topology_items for item in block_items):
                continue

            kind = block.get("kind", "Group")
            entry: dict[str, Any] = {
                "id": block_id,
                "title": block.get("title", block_id),
                "kind": kind,
                "precondition_count": len(block.get("precondition", []) or []),
                "postcondition_count": len(block.get("postcondition", []) or []),
            }
            if kind == "Roster":
                labels = block.get("labels", {}) or {}
                entry["iterate_over"] = block.get("iterateOver", "")
                entry["labels"] = labels
                entry["label_count"] = len(labels)
            elif kind == "Group" and "count" in block:
                # A `count`-capped Group asks at most N of its inner items in
                # canonical order (the loader validates `count` as a positive
                # int — see qml_loader). `count` surfaces in the Group block
                # header in the diagram-viewer so authors see the draw cap.
                # An uncapped Group omits `count` entirely, so the badge only
                # renders when the block actually caps its draw.
                entry["count"] = block.get("count")
            out.append(entry)
        return out

    def _emit_items(
        self,
        topology_items: set,
        topological_order: list[str],
    ) -> list[dict]:
        """Emit item entries in topological order."""
        order = topological_order if topological_order else list(topology_items)
        out: list[dict] = []
        for item_id in order:
            item = self.items_by_id.get(item_id)
            if not item:
                continue
            kind = item.get("kind", "") or ""
            input_config = item.get("input", {}) if isinstance(item.get("input"), dict) else {}
            control_type = input_config.get("control", "") or ""
            out.append(
                {
                    "id": item_id,
                    "block_id": item.get("blockId", ""),
                    "title": item.get("title", "No title"),
                    "kind": kind,
                    "control_type": control_type,
                }
            )
        return out

    def _emit_conditions(
        self,
        topology_items: set,
        item_ids: set | None = None,
        latest_variable_ids: dict[str, str] | None = None,
    ) -> list[dict]:
        """Emit chiclet entries for block-level AND item-level pre/postconditions.

        Block-level conditions own ``owner_kind='block'`` and reference the
        block id. Item-level conditions reference the item id. Each scope's
        conditions live ONLY on their owner (R25, 2026-05-14) — the QML
        loader no longer prepends block conditions onto items at load time.
        The Z3 builder and runtime FlowProcessor compose block + item at
        evaluation time; the diagram renders them at their natural scope.

        Each condition also carries a `references` list — `{kind, target_id}`
        entries derived from the predicate AST. `kind='item_outcome'` points at
        the item whose `.outcome` is read; `kind='variable_read'` points at the
        latest emitted variable version with that name. See
        `_extract_predicate_references` for the parser.
        """
        if item_ids is None:
            item_ids = set(self.items_by_id.keys())
        if latest_variable_ids is None:
            latest_variable_ids = {}

        out: list[dict] = []

        # Block-level conditions — emitted once per block. R24/R25 (2026-05-14):
        # the loader no longer merges block conds into items, so the diagram
        # simply walks block.precondition / block.postcondition here and the
        # item-level branch below walks the item's own lists directly. Full
        # predicate text is used as the label — no truncation, no AND-split.
        for block in self.state.get_blocks():
            block_id = block.get("id", "")
            if not block_id:
                continue
            block_items = self.items_by_block.get(block_id, [])
            if not any(item.get("id") in topology_items for item in block_items):
                continue
            self._emit_condition_list(
                owner=block,
                owner_id=block_id,
                owner_kind="block",
                id_prefix=f"block_{block_id}",
                item_ids=item_ids,
                latest_variable_ids=latest_variable_ids,
                out=out,
            )

        # Item-level conditions — these are ONLY the item's own conds (the
        # loader no longer prepends block conds into the item lists, so no
        # skip-slicing is required).
        for item_id in self.topology.items or []:
            item = self.items_by_id.get(item_id)
            if not item:
                continue
            self._emit_condition_list(
                owner=item,
                owner_id=item_id,
                owner_kind="item",
                id_prefix=item_id,
                item_ids=item_ids,
                latest_variable_ids=latest_variable_ids,
                out=out,
            )

        return out

    @staticmethod
    def _emit_condition_list(
        owner: dict,
        owner_id: str,
        owner_kind: str,
        id_prefix: str,
        item_ids: set,
        latest_variable_ids: dict[str, str],
        out: list[dict],
    ) -> None:
        """Append one chiclet entry per pre/postcondition declared on ``owner``.

        Shared by the block-level and item-level passes of ``_emit_conditions``
        — the two differ only in ``owner_kind`` and the chiclet ``id`` prefix
        (``block_<id>`` vs the bare item id). Chiclet id is
        ``f"{id_prefix}_{kind}_{idx}"`` (pre/post + source index), matching the
        pre-extraction format exactly.
        """
        for field, kind in (("precondition", "pre"), ("postcondition", "post")):
            for idx, cond in enumerate(owner.get(field, []) or []):
                predicate = cond.get("predicate", "") or ""
                out.append(
                    {
                        "id": f"{id_prefix}_{kind}_{idx}",
                        "owner_id": owner_id,
                        "owner_kind": owner_kind,
                        "kind": kind,
                        "predicate": predicate,
                        "predicate_label": predicate,
                        "source_index": idx,
                        "references": _extract_predicate_references(
                            predicate,
                            item_ids,
                            latest_variable_ids,
                        ),
                    }
                )

    def _emit_variables(self) -> list[dict]:
        """Emit one entry per (variable_name, version) from SSA history.

        Each entry carries `anchor_item_id` (the item whose codeBlock defined
        this version, or the literal `'__init__'` for codeInit-defined versions).
        The React layer renders `__init__` versions adjacent to the first block.

        Silent-drop guard: if `version_history` refers to a context_id that is
        not a known item and is not `'__init__'`, emit a WARNING (not an
        exception) and skip the entry — follows the `_record_coverage_gap`
        discipline used elsewhere in this module family.
        """
        out: list[dict] = []
        history = self.topology.static_builder.version_history or {}
        item_ids = set(self.items_by_id.keys())
        for var_name in sorted(history.keys()):
            for version, context_id in history[var_name]:
                if context_id != "__init__" and context_id not in item_ids:
                    self.logger.warning(
                        "variable %s version %d anchored to unknown context %r — skipping",
                        var_name,
                        version,
                        context_id,
                    )
                    continue
                out.append(
                    {
                        "id": f"var_{var_name}_v{version}",
                        "name": var_name,
                        "version": version,
                        "anchor_item_id": context_id,
                    }
                )
        return out

    def _emit_condition_ref_edges(self, conditions: list[dict]) -> list[dict]:
        """Emit one edge per condition→reference pair.

        Source is the condition chiclet id; target is the item id (for
        `item_outcome` refs) or the version-node id (for `variable_read` refs).
        Edges with no resolved target are skipped silently — only references
        that landed in `conditions[i].references` are emitted here.

        Carries ``source_kind`` (``'pre'``/``'post'``) and ``ref_kind``
        (``'item_outcome'``/``'variable_read'``) so the diagram front-end
        can pick the right ``sourceHandle`` / ``targetHandle`` for each
        edge — PRE chiclets emit from their right side, POST chiclets from
        the side facing the target. Without these the React Flow default
        picks the first declared handle which makes arrows land on the
        item's top edge instead of its side.
        """
        out: list[dict] = []
        for cond in conditions:
            for ref in cond.get("references", []) or []:
                target = ref.get("target_id")
                if not target:
                    continue
                out.append(
                    {
                        "source": cond["id"],
                        "target": target,
                        "kind": "condition_ref",
                        "source_kind": cond.get("kind"),
                        "ref_kind": ref.get("kind"),
                    }
                )
        return out

    def _emit_bitmask_source_edges(
        self,
        topology_items: set,
        item_ids: set,
        latest_variable_ids: dict[str, str],
    ) -> list[dict]:
        """Emit one ``bitmask_source`` edge per Roster block → iterateOver reference (R11).

        The Roster ``iterateOver`` expression resolves to the integer bitmask
        driving the block's repeated iterations. This edge makes the data
        provenance visible: the block node points at the item whose
        ``.outcome`` (a Checkbox feeding the mask) or the variable (a
        codeBlock-computed mask) supplies that bitmask.

        Source is the block id; target resolution reuses the same predicate
        AST walker the condition chiclets use (`_extract_predicate_references`)
        so ``q_meals.outcome`` → the item id and bare ``family_mask`` → the
        latest emitted ``var_family_mask_v<N>``. A reference that resolves to
        neither (Python builtin, not-yet-emitted variable) yields no edge —
        same silent-skip discipline as ``_emit_condition_ref_edges``. Blocks
        with no topology items, non-Roster blocks, and empty/blank
        ``iterateOver`` contribute nothing.
        """
        out: list[dict] = []
        for block in self.state.get_blocks():
            if block.get("kind") != "Roster":
                continue
            block_id = block.get("id", "")
            if not block_id:
                continue
            block_items = self.items_by_block.get(block_id, [])
            if not any(item.get("id") in topology_items for item in block_items):
                continue
            iterate_over = block.get("iterateOver", "") or ""
            for ref in _extract_predicate_references(
                iterate_over, item_ids, latest_variable_ids
            ):
                target = ref.get("target_id")
                if not target:
                    continue
                out.append(
                    {
                        "source": block_id,
                        "target": target,
                        "kind": "bitmask_source",
                        "ref_kind": ref.get("kind"),
                    }
                )
        return out

    def _emit_topology_edges(self, chain: list[str]) -> list[dict]:
        """Pairwise topology edges along the stable Kahn ordering."""
        if not chain or len(chain) < 2:
            return []
        return [
            {"source": chain[i], "target": chain[i + 1], "kind": "topology"}
            for i in range(len(chain) - 1)
        ]

    def _emit_version_chain_edges(self) -> list[dict]:
        """Emit v_n → v_{n+1} edges for every (name, version) pair."""
        out: list[dict] = []
        history = self.topology.static_builder.version_history or {}
        for var_name, versions in history.items():
            sorted_versions = sorted(v for v, _ in versions)
            for i in range(len(sorted_versions) - 1):
                out.append(
                    {
                        "source": f"var_{var_name}_v{sorted_versions[i]}",
                        "target": f"var_{var_name}_v{sorted_versions[i + 1]}",
                        "kind": "version_chain",
                    }
                )
        return out

    def _emit_cycle_edges(self, chain: list[str]) -> tuple[list[dict], set]:
        """Emit cycle edges + collect member set.

        Overlapping cycles merge (union-find) into a single group. Members are
        sorted by file-order position in the stable Kahn chain; forward edges
        connect consecutive members; one backward arc closes the group.
        """
        cycle_members: set = set()
        cycle_edges: list[dict] = []
        if not self.topology.has_cycles:
            return cycle_edges, cycle_members

        chain_index = {item_id: i for i, item_id in enumerate(chain)}
        chain_pairs = {(chain[i], chain[i + 1]) for i in range(len(chain) - 1)}

        cycle_sets = [set(c[:-1]) for c in (self.topology.cycles or [])]
        for group in self._merge_overlapping_sets(cycle_sets):
            cycle_members.update(group)
            if len(group) < 2:
                continue
            sorted_members = sorted(group, key=lambda x: chain_index.get(x, 0))
            for j in range(len(sorted_members) - 1):
                pair = (sorted_members[j], sorted_members[j + 1])
                if pair not in chain_pairs:
                    cycle_edges.append(
                        {
                            "source": sorted_members[j],
                            "target": sorted_members[j + 1],
                            "kind": "cycle",
                        }
                    )
            cycle_edges.append(
                {
                    "source": sorted_members[-1],
                    "target": sorted_members[0],
                    "kind": "cycle",
                }
            )
        return cycle_edges, cycle_members

    # ------------------------------------------------------------------
    # Validation coloring — inline classifications onto item/block entries.
    # ------------------------------------------------------------------

    def apply_validation_coloring(
        self,
        base_graph: dict,
        classifications: dict[str, Any] | None = None,
    ) -> dict:
        """Inline per-item classification into the IR.

        Three fields are written onto each item entry:

        * ``classification`` – the single semantic label used by the legacy
          renderer and the icon resolver (``always`` / ``conditional`` /
          ``never`` / ``tautological`` / ``infeasible`` / ``visited`` /
          ``pending`` / ``cycle``).
        * ``precondition_status`` – the raw Z3 reachability axis
          (``ALWAYS`` / ``CONDITIONAL`` / ``NEVER``) or ``None`` when no
          classification is available. Used by the diagram front-end to
          colour the item border independently of postcondition.
        * ``postcondition_invariant`` – the raw Z3 postcondition axis
          (``TAUTOLOGICAL`` / ``CONSTRAINING`` / ``INFEASIBLE`` / ``NONE``)
          or ``None``. Used to colour the item fill.

        Items inside a detected cycle keep their raw axes but the semantic
        ``classification`` is forced to ``cycle`` — Z3 classification is
        unreliable for cycle-involved items, and the cycle is the primary
        issue to fix.
        """
        cycle_nodes = set(base_graph.get("metadata", {}).get("cycle_nodes", []) or [])
        for item in base_graph.get("items", []):
            item_id = item["id"]
            pre_status, post_invariant = self._raw_axes(item_id, classifications)
            item["precondition_status"] = pre_status
            item["postcondition_invariant"] = post_invariant
            if item_id in cycle_nodes:
                item["classification"] = "cycle"
            else:
                item["classification"] = self._classify(item_id, classifications)
        return base_graph

    @staticmethod
    def _raw_axes(
        item_id: str,
        classifications: dict[str, Any] | None,
    ) -> tuple[str | None, str | None]:
        """Return the raw (precondition.status, postcondition.invariant) for ``item_id``.

        Either component may be ``None`` when classifications are unavailable
        or the item has no postcondition. The diagram front-end uses these
        directly to drive the two orthogonal colour axes (border = pre,
        fill = post) without re-deriving them from the collapsed semantic
        label.
        """
        if not classifications:
            return None, None
        entry = classifications.get(item_id)
        if not entry:
            return None, None
        pre = (entry.get("precondition") or {}).get("status")
        post = (entry.get("postcondition") or {}).get("invariant")
        return pre, post

    def _classify(
        self,
        item_id: str,
        classifications: dict[str, Any] | None,
    ) -> str:
        """Map a single item's Z3 classification to a semantic class name."""
        if not classifications:
            return "pending"
        classification = classifications.get(item_id)
        if not classification:
            return "pending"

        precond = classification.get("precondition", {}) or {}
        postcond = classification.get("postcondition", {}) or {}
        pre_status = precond.get("status", "UNKNOWN")
        post_invariant = postcond.get("invariant", "UNKNOWN")
        is_vacuous = postcond.get("vacuous", False)

        if pre_status == "ALWAYS":
            if post_invariant == "CONSTRAINING" and not is_vacuous:
                return "always"
            if post_invariant in ("TAUTOLOGICAL", "INFEASIBLE"):
                return post_invariant.lower()
            if post_invariant == "NONE":
                return "always"
            return "visited"
        if pre_status == "CONDITIONAL":
            if post_invariant in ("TAUTOLOGICAL", "INFEASIBLE"):
                return post_invariant.lower()
            return "conditional"
        if pre_status == "NEVER":
            return "never"
        return "pending"

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------

    @staticmethod
    def _merge_overlapping_sets(sets: list[set]) -> list[set]:
        """Union-find merge: sets sharing any element fuse into one group."""
        merged: list[set] = []
        for s in sets:
            overlapping = [i for i, m in enumerate(merged) if m & s]
            if not overlapping:
                merged.append(s.copy())
            else:
                target = merged[overlapping[0]]
                target.update(s)
                for i in reversed(overlapping[1:]):
                    target.update(merged.pop(i))
        return merged

    # ------------------------------------------------------------------
    # Validation report — text output, unchanged contract for callers.
    # ------------------------------------------------------------------

    def generate_validation_report(self) -> str:
        """Generate a concise text report of the validation."""
        lines = []
        lines.append("=" * 60)
        lines.append("QML VALIDATION REPORT")
        lines.append("=" * 60)

        lines.append("\n📊 Summary:")
        lines.append(f"  Items: {len(self.items_by_id)}")

        precond_count = sum(
            len(item.get("precondition", []) or []) for item in self.items_by_id.values()
        )
        postcond_count = sum(
            len(item.get("postcondition", []) or []) for item in self.items_by_id.values()
        )
        if precond_count > 0:
            lines.append(f"  Preconditions: {precond_count}")
        if postcond_count > 0:
            lines.append(f"  Postconditions: {postcond_count}")

        used_vars = {
            name: count
            for name, count in (self.topology.static_builder.version_map or {}).items()
            if count > 0
        }
        if used_vars:
            lines.append(f"  Variables: {len(used_vars)}")

        if self.topology:
            if self.topology.has_cycles:
                lines.append(f"  ⚠️  Cycles: {len(self.topology.cycles)}")
            else:
                lines.append("  ✅ No cycles")

            lines.append("\n🔄 Flow:")
            if self.topology.topological_order:
                preview = " → ".join(self.topology.topological_order[:3])
                lines.append(f"  Order: {preview}...")

            components = self.topology.get_components()
            if len(components) > 1:
                lines.append(f"  Components: {len(components)}")

        interesting_items = []
        for item_id in self.topology.items or []:
            item = self.items_by_id.get(item_id)
            if not item:
                continue
            has_preconds = bool(item.get("precondition"))
            has_postconds = bool(item.get("postcondition"))
            has_code = "codeBlock" in item
            if has_preconds or has_postconds or has_code:
                interesting_items.append((item_id, item, has_preconds, has_postconds, has_code))

        if interesting_items:
            lines.append("\n📦 Key Items:")
            for item_id, item, has_preconds, has_postconds, has_code in interesting_items:
                title = item.get("title", "No title")
                props = []
                if has_preconds:
                    props.append(f"{len(item.get('precondition', []))} preconds")
                if has_postconds:
                    props.append(f"{len(item.get('postcondition', []))} postconds")
                if has_code:
                    props.append("code")
                prop_str = f" ({', '.join(props)})" if props else ""
                lines.append(f"  {item_id}: {title}{prop_str}")

        return "\n".join(lines)


# ---------------------------------------------------------------------------
# Module-level helpers: predicate reference extraction.
#
# Kept at module scope (not on QMLDiagramIR) so the parser is pure and easy to
# test in isolation. The condition emitter passes `item_ids` and
# `latest_variable_ids` so the parser doesn't need to know about QMLDiagramIR's
# internal state shape.
# ---------------------------------------------------------------------------


def _build_latest_variable_index(variables: list[dict]) -> dict[str, str]:
    """Map variable name → id of the highest-version emitted node.

    The backbone diagram resolves bare `Name(x)` references in a predicate to
    the latest emitted version of `x` because the IR does not (yet) carry
    per-condition in-scope analysis. Higher version numbers win; ties (which
    shouldn't occur — SSA versions are unique per name) keep the first seen.
    """
    out: dict[str, str] = {}
    best_version: dict[str, int] = {}
    for v in variables:
        name = v.get("name")
        version = v.get("version")
        vid = v.get("id")
        if not name or vid is None or version is None:
            continue
        if name not in best_version or version > best_version[name]:
            best_version[name] = version
            out[name] = vid
    return out


def _extract_predicate_references(
    predicate: str,
    item_ids: set,
    latest_variable_ids: dict[str, str],
) -> list[dict]:
    """Walk the predicate AST and collect references to items and variables.

    Returns a deduped list of `{kind, target_id}` dicts:
      - kind='item_outcome', target_id=<item_id>     for `item_id.outcome`
      - kind='variable_read', target_id=<var_x_vN>   for bare `Name(x)` where
        `x` is in the variables index

    Names that match neither an item id nor a known variable are ignored —
    they're typically Python builtins (`max`, `len`, `True`) or references to
    names not yet realised in the IR (e.g. a not-yet-emitted variable in a
    cycle-broken graph). Unparseable predicates also return an empty list
    rather than raising — the diagram should still render around them.
    """
    if not predicate or not predicate.strip():
        return []
    try:
        tree = ast.parse(predicate, mode="eval")
    except SyntaxError:
        return []

    seen: set = set()
    refs: list[dict] = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Attribute) and node.attr == "outcome":
            if isinstance(node.value, ast.Name) and node.value.id in item_ids:
                key = ("item_outcome", node.value.id)
                if key not in seen:
                    seen.add(key)
                    refs.append({"kind": "item_outcome", "target_id": node.value.id})
        elif isinstance(node, ast.Name):
            name = node.id
            target_id = latest_variable_ids.get(name)
            if target_id is None:
                continue
            key = ("variable_read", target_id)
            if key not in seen:
                seen.add(key)
                refs.append({"kind": "variable_read", "target_id": target_id})
    return refs
