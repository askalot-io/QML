"""
QMLTopology - Dependency Analysis and Topological Sorting

This module uses StaticBuilder's dependency graph to build topology:
- Dependency chains resolved transitively through variables
- Cycle detection via Kahn's algorithm (O(V+E))
- Cycle path discovery via DFS (for diagram visualization)
- Topological ordering with stable priority queue for deterministic output
"""

import heapq
import logging
from collections import deque

from askalot_qml.models.qml_state import QMLState
from askalot_qml.z3.static_builder import StaticBuilder


class QMLTopology:
    """
    Topology analysis for questionnaire items.

    Uses StaticBuilder's SSA-based dependency graph to:
    1. Build item-to-item dependency graph (variables resolved transitively)
    2. Compute topological ordering with cycle-tolerant Kahn's algorithm
    3. Detect all cycles incrementally (find cycle, break backward edge, resume)
    """

    def __init__(self, questionnaire_state: QMLState, static_builder: StaticBuilder):
        """
        Initialize topology analysis with Z3.

        Args:
            questionnaire_state: The questionnaire to analyze
            static_builder: Pre-built StaticBuilder with Z3 constraints
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state
        self.static_builder = static_builder

        # Get item list for ordering
        self.items = [item["id"] for item in self.state.get_all_items() if item.get("id")]

        # Dependency graph from SSA analysis
        self.dependencies: dict[str, set[str]] = {}

        # Reverse dependency graph
        self.reverse_dependencies: dict[str, set[str]] = {}

        # Topological order — always populated. When cycles exist, cycle
        # members are linearized in QML file order at their natural position.
        self.topological_order: list[str] = []

        # Cycle detection results
        self.cycles: list[list[str]] = []
        self.has_cycles: bool = False

        # Build topology — cycle detection is integrated into Kahn's algorithm
        self._build_dependency_graph()
        self._compute_topological_order()

    def _build_dependency_graph(self):
        """Build dependency graph from Z3 constraint analysis."""
        # Initialize dependency sets
        for item_id in self.items:
            self.dependencies[item_id] = set()
            self.reverse_dependencies[item_id] = set()

        # Get dependencies discovered by SSA builder
        item_deps = self.static_builder.get_item_dependencies()

        # Build both forward and reverse dependency graphs
        for item_id, deps in item_deps.items():
            self.dependencies[item_id] = deps.copy()
            for dep_id in deps:
                if dep_id in self.reverse_dependencies:
                    self.reverse_dependencies[dep_id].add(item_id)

        self.logger.debug(f"Built dependency graph with {len(self.dependencies)} items")
        for item_id, deps in self.dependencies.items():
            if deps:
                self.logger.debug(f"  {item_id} depends on: {', '.join(sorted(deps))}")

    def _find_cycle_among(
        self, remaining: set[str], working_deps: dict[str, set[str]]
    ) -> list[str] | None:
        """Find one cycle among the stuck items using DFS.

        All items in `remaining` have non-zero in-degree within the
        remaining subgraph, so following dependency edges from any
        starting node will always find a cycle.

        Returns:
            Cycle as list of item IDs (without closing duplicate), or None.
        """
        visited: set[str] = set()
        rec_stack: set[str] = set()

        def dfs(node: str, path: list[str]) -> list[str] | None:
            visited.add(node)
            rec_stack.add(node)
            path.append(node)

            for neighbor in sorted(working_deps.get(node, set())):
                if neighbor not in remaining:
                    continue
                if neighbor not in visited:
                    result = dfs(neighbor, path)
                    if result is not None:
                        return result
                elif neighbor in rec_stack:
                    cycle_start = path.index(neighbor)
                    return path[cycle_start:]

            rec_stack.remove(node)
            path.pop()
            return None

        # Start from the first remaining item in file order for determinism
        for item_id in self.items:
            if item_id in remaining and item_id not in visited:
                cycle = dfs(item_id, [])
                if cycle is not None:
                    return cycle

        return None

    def _compute_topological_order(self):
        """Compute topological order using cycle-tolerant Kahn's algorithm.

        Uses a min-heap keyed by original QML file order to ensure that when
        multiple items are available (in_degree = 0), the one appearing first
        in the original QML file is processed first.

        When Kahn's gets stuck (all remaining items have non-zero in-degree),
        a cycle is found via DFS. The backward edge (last→first in file order)
        is removed to break the cycle, and Kahn's resumes. This repeats until
        all items are processed, producing a complete topological order where
        cycle members are linearized in QML file order.
        """
        item_index = {item_id: idx for idx, item_id in enumerate(self.items)}

        # Working copies — mutated during cycle breaking.
        # Original self.dependencies/self.reverse_dependencies stay intact.
        working_deps = {item_id: deps.copy() for item_id, deps in self.dependencies.items()}
        working_rev = {item_id: deps.copy() for item_id, deps in self.reverse_dependencies.items()}
        in_degree = {item_id: len(working_deps[item_id]) for item_id in self.items}

        result = []
        remaining = set(self.items)

        # Safety limit: each iteration either processes items or breaks a cycle
        # (removing an edge). Total iterations bounded by items + edges.
        max_iterations = len(self.items) + sum(len(d) for d in self.dependencies.values()) + 1

        # Seed the heap with all initial zero-in-degree items
        heap = []
        for item_id in self.items:
            if in_degree[item_id] == 0:
                heapq.heappush(heap, (item_index[item_id], item_id))

        for _ in range(max_iterations):
            if not remaining:
                break

            # Phase 1: Drain the heap — process all items with zero in-degree
            while heap:
                _, current = heapq.heappop(heap)
                if current not in remaining:
                    continue
                result.append(current)
                remaining.remove(current)

                for dependent in working_rev.get(current, set()):
                    if dependent in remaining:
                        in_degree[dependent] -= 1
                        if in_degree[dependent] == 0:
                            heapq.heappush(heap, (item_index[dependent], dependent))

            if not remaining:
                break

            # Phase 2: Stuck — find and break a cycle
            cycle = self._find_cycle_among(remaining, working_deps)
            if cycle is None:
                self.logger.error(f"No cycle found among {len(remaining)} stuck items — aborting")
                break

            # Record the cycle (closed path: [..., first_item])
            self.cycles.append(cycle + [cycle[0]])
            self.logger.warning(f"  Cycle {len(self.cycles)}: {' -> '.join(cycle + [cycle[0]])}")

            # Break the backward edge: last → first in file order
            sorted_cycle = sorted(cycle, key=lambda x: item_index[x])
            back_src = sorted_cycle[-1]
            back_tgt = sorted_cycle[0]

            working_deps[back_tgt].discard(back_src)
            working_rev[back_src].discard(back_tgt)
            in_degree[back_tgt] -= 1
            if in_degree[back_tgt] == 0:
                heapq.heappush(heap, (item_index[back_tgt], back_tgt))

        self.topological_order = result
        self.has_cycles = len(self.cycles) > 0

        if self.has_cycles:
            self.logger.warning(
                f"Found {len(self.cycles)} cycle(s), topological order computed "
                f"for all {len(result)}/{len(self.items)} items"
            )
        else:
            self.logger.info(f"Computed topological order for {len(result)} items")

    def get_topological_order(self) -> list[str]:
        """Get the topological order of items.

        Always returns an ordering. When cycles exist, cycle members are
        linearized in QML file order. Check has_cycles to know if the
        ordering is exact or approximate.
        """
        return self.topological_order.copy()

    def get_cycles(self) -> list[list[str]]:
        """Get all detected cycles."""
        return self.cycles.copy()

    def get_dependency_chains(self) -> dict[str, set[str]]:
        """
        Get dependency chains for each item.
        Returns a dict mapping each item to its dependencies.
        """
        return {item_id: deps.copy() for item_id, deps in self.dependencies.items()}

    def get_components(self) -> list[set[str]]:
        """
        Get connected components in the dependency graph.
        Each component is a set of interdependent items.
        """
        visited = set()
        components = []

        def explore_component(start_item: str) -> set[str]:
            """Explore a component using BFS."""
            component = set()
            queue = deque([start_item])

            while queue:
                current = queue.popleft()
                if current in visited:
                    continue

                visited.add(current)
                component.add(current)

                # Add items this depends on
                for dep in self.dependencies.get(current, set()):
                    if dep not in visited:
                        queue.append(dep)

                # Add items that depend on this
                for dep in self.reverse_dependencies.get(current, set()):
                    if dep not in visited:
                        queue.append(dep)

            return component

        # Process items
        for item_id in self.items:
            if item_id not in visited:
                component = explore_component(item_id)
                components.append(component)

        self.logger.debug(f"Found {len(components)} connected components")
        return components

    def get_block_scoped_components(self, block_item_ids: set[str]) -> list[set[str]]:
        """Connected components restricted to a Sample block's own items (U4).

        This is the block-local analogue of ``get_components``: it partitions
        ONLY the items in ``block_item_ids`` into connected components, walking
        edges of ``self.dependencies`` / ``self.reverse_dependencies`` but
        traversing an edge only when BOTH endpoints are inside the block. An
        edge crossing the block boundary (a Sample item depending on an item
        outside the block, or vice versa) does NOT merge components — that
        external dependency is a fixed predecessor the runtime evaluates
        before the block is entered, never a reason to fuse two Sample
        components into one randomizable unit.

        **Same graph Z3 enumerates (R9 — the whole reason the cap is
        validation-time).** ``self.dependencies`` / ``self.reverse_dependencies``
        are built in ``_build_dependency_graph`` directly from
        ``static_builder.get_item_dependencies()`` — the transitively
        variable-resolved item→item graph the StaticBuilder constructs and that
        every Z3 consumer (ItemClassifier, PathBasedValidator) sees. Restricting
        that exact graph to the block's items therefore counts components over
        precisely the dependency structure Z3 enumerates, including
        variable-mediated transitive edges. A loader-time syntactic pre-parse
        would partition a *different* graph → unsound; this is why R9 moved to
        validation time.

        Args:
            block_item_ids: item IDs of one Sample block's inner items.

        Returns:
            List of components (each a set of item IDs ⊆ ``block_item_ids``),
            in stable QML file order of their first member. An empty block
            yields ``[]`` (the caller treats ``T == 0`` as the base case of
            exactly one — empty — ordering, no divide-by-zero).
        """
        scope = {i for i in block_item_ids if i in self.dependencies}
        visited: set[str] = set()
        components: list[set[str]] = []

        def explore_component(start_item: str) -> set[str]:
            component: set[str] = set()
            queue = deque([start_item])
            while queue:
                current = queue.popleft()
                if current in visited:
                    continue
                visited.add(current)
                component.add(current)
                # Only traverse edges whose neighbour is also in this block:
                # cross-block edges are fixed external predecessors, not a
                # reason to fuse two independent Sample components.
                for dep in self.dependencies.get(current, set()):
                    if dep in scope and dep not in visited:
                        queue.append(dep)
                for dep in self.reverse_dependencies.get(current, set()):
                    if dep in scope and dep not in visited:
                        queue.append(dep)
            return component

        # Iterate in stable QML file order (self.items) so component order is
        # deterministic — the contiguous-tree-block permutation enumerated by
        # U4 must be reproducible across runs and match the runtime freeze.
        for item_id in self.items:
            if item_id in scope and item_id not in visited:
                components.append(explore_component(item_id))

        self.logger.debug(
            f"Block-scoped components: {len(components)} over {len(scope)} items"
        )
        return components

    def linearize_component(
        self, component: set[str], topo_index: dict[str, int] | None = None
    ) -> list[str]:
        """Order a component's items by their position in the topological sort.

        The Sample contiguous-tree-block model emits each component in its fixed
        intra-component order — the topology's stable-Kahn linearization (which
        is also the cycle-tolerant ordering for cyclic components). Both
        ``static_builder._emit_sample_conditional_presence`` (validation-time
        ordering enumeration) and ``flow_processor._sample_canonical_order``
        (runtime canonical order) call this so the runtime freeze is provably
        one of the orderings Z3 enumerated.

        ``topo_index`` may be precomputed by the caller (when it would otherwise
        be rebuilt on every call); when ``None`` it is derived from the current
        topological order. Items not in the topology fall to the end in stable
        membership order, matching the prior inline implementations.
        """
        if topo_index is None:
            topo_index = {iid: idx for idx, iid in enumerate(self.get_topological_order())}
        return sorted(component, key=lambda i: topo_index.get(i, len(topo_index)))

    def get_statistics(self) -> dict[str, any]:
        """Get statistics about the dependency topology."""
        components = self.get_components()
        stats = {
            "total_items": len(self.items),
            "total_components": len(components),
            "has_cycles": self.has_cycles,
            "num_cycles": len(self.cycles),
            "cycles": self.get_cycles() if self.has_cycles else [],
            "topological_order_exists": True,
            "topological_order": self.topological_order,
        }

        # Component sizes
        stats["component_sizes"] = [len(c) for c in components]
        stats["isolated_items"] = len([c for c in components if len(c) == 1])

        # Dependency stats
        total_dependencies = sum(len(deps) for deps in self.dependencies.values())
        stats["total_dependencies"] = total_dependencies
        stats["items_with_dependencies"] = len(
            [item for item, deps in self.dependencies.items() if deps]
        )

        # Find most dependent items
        if self.dependencies:
            most_dependent = max(self.dependencies.items(), key=lambda x: len(x[1]))
            if most_dependent[1]:  # Has dependencies
                stats["most_dependent_item"] = (most_dependent[0], len(most_dependent[1]))

        # Find most depended upon items
        if self.reverse_dependencies:
            most_depended_upon = max(self.reverse_dependencies.items(), key=lambda x: len(x[1]))
            if most_depended_upon[1]:  # Has dependents
                stats["most_depended_upon_item"] = (
                    most_depended_upon[0],
                    len(most_depended_upon[1]),
                )

        return stats

    def get_dependency_layers(self) -> list[set[str]]:
        """
        Group items into layers based on their dependencies.
        Items in the same layer have no dependencies on each other.
        """
        if self.has_cycles:
            # If there are cycles, we can't create proper layers
            # Return all items in a single layer
            return [set(self.items)]

        layers = []
        remaining = set(self.items)
        processed = set()

        while remaining:
            # Find items that have no unprocessed dependencies
            current_layer = set()

            for item_id in remaining:
                dependencies = self.dependencies.get(item_id, set())
                # Check if all dependencies have been processed
                if dependencies.issubset(processed):
                    current_layer.add(item_id)

            if not current_layer:
                # No progress possible - should not happen if cycle detection works
                self.logger.warning("Cannot create dependency layers - possible undetected cycles")
                # Add remaining items as a final layer
                layers.append(remaining)
                break

            layers.append(current_layer)
            processed.update(current_layer)
            remaining -= current_layer

        return layers

    def can_reach(self, from_item: str, to_item: str) -> bool:
        """Check if one item can reach another through dependencies using Z3."""
        if from_item == to_item:
            return True

        # Use BFS to check reachability
        visited = set()
        queue = deque([from_item])

        while queue:
            current = queue.popleft()
            if current == to_item:
                return True

            if current in visited:
                continue

            visited.add(current)

            # Add items that current depends on
            for dep in self.dependencies.get(current, set()):
                if dep not in visited:
                    queue.append(dep)

        return False

    def debug_dump(self) -> str:
        """Generate debug output."""
        lines = []
        lines.append("=" * 60)
        lines.append("QML TOPOLOGY DEBUG DUMP")
        lines.append("=" * 60)

        lines.append("\n📊 Summary:")
        lines.append(f"  Total items: {len(self.items)}")
        lines.append(f"  Has cycles: {self.has_cycles}")
        lines.append(f"  Number of cycles: {len(self.cycles)}")
        lines.append(f"  Z3 constraints: {len(self.static_builder.get_constraints())}")

        if self.cycles:
            lines.append("\n⚠️  Cycles Detected by Z3:")
            for i, cycle in enumerate(self.cycles):
                lines.append(f"  Cycle {i + 1}: {' -> '.join(cycle)}")

        lines.append("\n🔗 Dependencies (from Z3 analysis):")
        for item_id in self.items:
            deps = self.dependencies.get(item_id, set())
            if deps:
                lines.append(f"  {item_id} depends on: {', '.join(sorted(deps))}")

        lines.append("\n🔄 Reverse Dependencies:")
        for item_id in self.items:
            rev_deps = self.reverse_dependencies.get(item_id, set())
            if rev_deps:
                lines.append(f"  {item_id} is depended on by: {', '.join(sorted(rev_deps))}")

        if self.topological_order:
            lines.append("\n📋 Topological Order (Kahn's Algorithm):")
            lines.append(f"  {' -> '.join(self.topological_order)}")

        # Components
        components = self.get_components()
        lines.append(f"\n🏝️  Connected Components ({len(components)}):")
        for i, component in enumerate(components):
            lines.append(f"  Component {i + 1}: {', '.join(sorted(component))}")

        # SSA information
        lines.append("\n" + self.static_builder.debug_dump())

        return "\n".join(lines)
