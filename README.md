# Questionnaire Markup Language Compiler and Validator

[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)

## Overview

The **askalot_qml** module provides Z3-driven questionnaire validation capabilities with two distinct processors:

- **FlowProcessor**: Runtime questionnaire traversal for conducting interviews
- **ValidationProcessor**: Offline static validation for questionnaire design

Both processors share a common pipeline through QMLEngine that handles dependency graph construction and topological sorting.

## Module Structure

```
askalot_qml/
├── api/                           # Flask blueprints for web services
│   ├── validation_blueprint.py    # Static validation endpoints
│   └── flow_blueprint.py         # Flow navigation endpoints
├── core/                          # Core processing engines
│   ├── validation_processor.py    # Static validation with Z3 classification
│   ├── flow_processor.py         # Runtime navigation
│   ├── python_runner.py          # Safe Python code execution
│   ├── qml_diagram.py            # Graph IR generation for visualization
│   ├── qml_engine.py             # Common pipeline orchestrator
│   ├── qml_layout.py             # Server-side Graphviz layout
│   ├── qml_loader.py             # QML file loading
│   └── qml_topology.py           # Dependency graph and topological sort
├── models/                        # Data models
│   ├── item_proxy.py             # Runtime item wrapper for code blocks
│   ├── qml_state.py              # Survey state management
│   └── table.py                  # Matrix question support
├── schema/                        # QML schema definitions
│   └── qml-schema.json           # JSON Schema for QML validation
└── z3/                           # Z3 constraint solving
    ├── global_formula.py         # Global satisfiability check (Level 2)
    ├── item_classifier.py        # Per-item Z3 classification (Level 1)
    ├── path_based_validation.py  # Accumulated reachability / dead code (Level 3)
    ├── pragmatic_compiler.py     # AST to Z3 constraint compilation
    └── static_builder.py         # SSA versioning and constraint generation
```

## Formal Foundation

The module implements formal verification concepts from the thesis [docs/thesis/chapters/comprehensive_validation.tex](docs/thesis/chapters/comprehensive_validation.tex):

### Questionnaire Definition

A questionnaire is a tuple G = (I, S, D, P, Q, I_start) where:
- **I**: Finite set of items
- **S**: Vector of outcome variables
- **D**: Domain constraints for each outcome
- **P**: Preconditions (Boolean formulas determining item visibility)
- **Q**: Postconditions (Boolean formulas constraining valid responses)

### Base Constraint

B := conjunction of all domain constraints D_i(S_i)

### Validation Hierarchy

Three levels of increasing thoroughness, implemented in the `z3/` module:

| Level | Formula | Implementation | Purpose |
|-------|---------|----------------|---------|
| **Per-item** | W_i = B ∧ P_i ∧ ¬Q_i | [item_classifier.py](askalot_qml/z3/item_classifier.py) | Detect NEVER reachable and INFEASIBLE items |
| **Global** | F = B ∧ ∧(P_i ⇒ Q_i) | [global_formula.py](askalot_qml/z3/global_formula.py) | Detect conflicting postconditions |
| **Path-based** | A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j) | [path_based_validation.py](askalot_qml/z3/path_based_validation.py) | Detect dead code (unreachable items) |

**Relationships between levels:**
- **Per-item passes → Global passes**: If all W_i are UNSAT, then SAT(F) is guaranteed (Theorem: Soundness)
- **Global fails → Path-based fails**: If UNSAT(F), no execution path is valid (Theorem: Global Necessary)
- **Global passes ↛ All paths valid**: SAT(F) doesn't guarantee all items reachable (Theorem: Global Not Sufficient)

**When each level suffices:**
- **Per-item** suffices when all postconditions are TAUTOLOGICAL
- **Global** suffices when you only need to verify some valid completion exists
- **Path-based** is needed to detect dead code (CONDITIONAL items made unreachable by accumulated constraints)

## Z3 Thread Safety

Z3's global context (`main_ctx()`) is **not thread-safe**. In multi-threaded environments (e.g., Armiger's watchdog Observer thread, gunicorn with threads), garbage collection of Z3 wrapper objects on background threads races with solver operations on the main thread, causing `ast.cpp:388` assertion violations and segfaults.

**Solution**: Each `StaticBuilder` creates a per-analysis `z3.Context()` and propagates it to all Z3 consumers:

```
StaticBuilder (owns ctx = z3.Context())
    ├── PragmaticZ3Compiler (receives ctx)
    ├── ItemClassifier (reads builder.ctx)
    ├── GlobalFormula (receives ctx)
    └── PathBasedValidator (receives ctx)
```

**Context propagation rules**:
- Leaf constructors (`Int`, `IntVal`, `BoolVal`, `Bool`, `Solver`) require explicit `ctx` parameter
- Compound functions (`And`, `Or`, `Not`, `Implies`, `If`) infer context from their arguments automatically

**When writing new Z3 code**: Always pass `self.ctx` (or the builder's context) to `Int()`, `IntVal()`, `BoolVal()`, `Bool()`, and `Solver()` constructors. Never rely on the global context.

## FlowProcessor - Runtime Navigation

**Purpose**: Conduct interactive interviews by traversing the questionnaire graph.

**File**: [core/flow_processor.py](askalot_qml/core/flow_processor.py)

### Responsibilities

1. **Initialize questionnaire state** - Execute codeInit, create ItemProxy instances, set up navigation path
2. **Navigate forward/backward** - Follow topological order, evaluate preconditions, track history
3. **Process item responses** - Validate postconditions, execute code blocks, propagate state

### State Management Architecture

The QMLState ([models/qml_state.py](askalot_qml/models/qml_state.py)) maintains:

- **items[]**: Flat list of all questionnaire items
- **history[]**: Navigation history (item IDs visited in order)
- **navigation_path[]**: Pre-computed topological order from Z3 analysis
- **Per-item context**: Variable state AFTER each item's execution

Each item stores:
- **outcome**: User's response value
- **visited**: Whether item has been completed
- **context**: Dictionary of Python variables at this execution point

This architecture enables **pause/resume** of interviews: by storing the context at each item, we can restore the exact Python state when resuming a survey.

### Navigation Strategy

**Forward Navigation** (no Z3 at runtime):
1. Iterate through pre-computed navigation_path (topological order)
2. Skip visited items (unless last in path)
3. Evaluate preconditions via Python eval (NOT Z3)
4. Items with unsatisfied preconditions are silently skipped
5. Return first item with satisfied preconditions
6. Track item in history for backward navigation

**Backward Navigation**:
1. Pop current item from history stack
2. Mark item as unvisited
3. Restore previous item's context
4. Return to previous item

**Item Processing** (strict order — postcondition BEFORE codeBlock):
1. Clone current item's context
2. Populate context with ItemProxy instances for all items
3. Assign outcome from user response
4. Validate postcondition — return hint message if failed
5. Execute codeBlock via PythonRunner (only after postcondition passes)
6. Update outcomes for modified items
7. Propagate variables to subsequent items' contexts

**Dependency consequences of this order**:
- Preconditions can reference other items' outcomes and variables from prior items
- Postconditions can reference the current item's outcome and any variable — but variables still hold their prior values (the current item's codeBlock hasn't run yet)
- CodeBlocks can read/write the current item's and previous items' outcomes and update variables for subsequent items

### Performance Characteristics

- Z3 used **once** at initialization for dependency graph
- Preconditions evaluated via Python eval (fast)
- No Z3 classification during navigation
- Base diagram cached for reuse

## ValidationProcessor - Static Validation

**Purpose**: Validate questionnaire design by detecting structural problems before deployment.

**File**: [core/validation_processor.py](askalot_qml/core/validation_processor.py)

### Responsibilities

1. **Per-item classification** - Determine reachability and postcondition effects
2. **Global formula check** - Verify at least one valid completion exists
3. **Path-based validation** - Detect dead code from accumulated constraints
4. **Generate validation diagrams** - Visualize classification results with semantic coloring

### Per-Item Classification

The ItemClassifier ([z3/item_classifier.py](askalot_qml/z3/item_classifier.py)) computes:

**Precondition Reachability**:
| Status | Condition | Meaning |
|--------|-----------|---------|
| ALWAYS | UNSAT(B ∧ ¬P) | Item always shown |
| CONDITIONAL | SAT(B ∧ P) and SAT(B ∧ ¬P) | Item sometimes shown |
| NEVER | UNSAT(B ∧ P) | Item never reachable (dead code) |

**Postcondition Invariant** (relative to precondition P):
| Status | Condition | Meaning |
|--------|-----------|---------|
| TAUTOLOGICAL | UNSAT(B ∧ P ∧ ¬Q) | Postcondition always holds when reached |
| CONSTRAINING | Both SAT for (B ∧ P ∧ Q) and (B ∧ P ∧ ¬Q) | Postcondition filters some responses |
| INFEASIBLE | UNSAT(B ∧ P ∧ Q) | Postcondition can never be satisfied (design error) |
| NONE | No postcondition defined | No validation constraints |

### Validation Diagram Coloring

| Color | Class | Meaning |
|-------|-------|---------|
| Green | always | ALWAYS reachable |
| Yellow | conditional | CONDITIONAL reachability |
| Red | never | NEVER reachable |
| Purple | infeasible | INFEASIBLE postcondition |
| Blue | tautological | TAUTOLOGICAL postcondition |

## Common Pipeline

Both processors share the QMLEngine ([core/qml_engine.py](askalot_qml/core/qml_engine.py)) which provides:

### StaticBuilder

**File**: [z3/static_builder.py](askalot_qml/z3/static_builder.py)

- Parses preconditions, postconditions, and code blocks
- Generates Z3 constraints using SSA (Static Single Assignment) versioning
- Discovers item dependencies through constraint analysis
- Creates frozen base constraint (B) for classification

### QMLTopology

**File**: [core/qml_topology.py](askalot_qml/core/qml_topology.py)

- Builds dependency graph from StaticBuilder's constraint analysis
- Computes topological order via Kahn's algorithm with priority queue
- Provides dependency layers and connected components

**Stable Topological Ordering**: Uses a min-heap keyed by original QML file index. When multiple items are available (in_degree = 0), the one appearing earliest in the QML file is always processed first. This ensures deterministic ordering that respects the author's intended item sequence.

**Cycle-Tolerant Topological Ordering**: Always produces a complete ordering, even when cycles exist:

1. **Kahn's algorithm** processes all zero-in-degree items
2. When stuck (all remaining items have non-zero in-degree), **DFS finds one cycle**
3. The backward edge (last→first in file order) is removed to break the cycle
4. Kahn's resumes — repeat until all items are processed

Cycle members are linearized in QML file order at their natural position. The original dependency graph (`self.dependencies`) is preserved; only working copies are mutated during cycle breaking. `get_topological_order()` always returns a list (never `None`); check `has_cycles` to know if the ordering is exact or approximate.

### QMLDiagram

**File**: [core/qml_diagram.py](askalot_qml/core/qml_diagram.py)

Generates a JSON graph intermediate representation (IR) consumed by QMLLayout for server-side Graphviz positioning and rendered as SVG DOM elements in the browser (Armiger QML Explorer).

1. **Base graph** (cacheable): Structure only - items, variables, preconditions, postconditions, dependency and topological edges, cycle highlighting
2. **Dynamic coloring**: Applied at runtime based on mode (flow or validation)

### QMLLayout

**File**: [core/qml_layout.py](askalot_qml/core/qml_layout.py)

Computes node positions and edge routes for the graph IR using pygraphviz. Supports multiple Graphviz layout engines (dot, neato, fdp, sfdp, twopi, circo). The browser receives pre-positioned data — rendering is instant with no client-side layout library needed.

## QML Language

QML files are YAML-based questionnaire specifications. See [docs/thesis/presentation/slides.md](docs/thesis/presentation/slides.md) for examples.

Key elements:
- **codeInit**: Global initialization code block
- **blocks**: Logical groupings of items (can have block-level `precondition`)
- **items**: Questions, comments, or groups with:
  - **precondition**: List of predicates determining visibility
  - **postcondition**: List of predicates with hints for validation
  - **codeBlock**: Python code executed after response

### Block-Level Precondition Inheritance

Blocks can define preconditions that apply to all items within them. During QMLLoader flattening (`_flatten_blocks`), block-level preconditions are prepended to each item's own preconditions with `_source: 'block'` and `_block_id` tags for tracking. Items also get `_block_precondition_count` to indicate how many inherited preconditions they carry. This eliminates repetitive per-item preconditions when an entire section is conditional.

### Domain Constraints for Z3

StaticBuilder extracts domain constraints D_i(S_i) from item input specs for base constraint B. Supports:
- **Numeric controls** (Editbox, Slider, Range): `min`/`max` bounds
- **Choice controls** (Radio, RadioButton, Dropdown, Checkbox, Switch): Enumeration via `labels` (schema format: `{1: "Yes", 2: "No"}`) or `options` (legacy: `[{value: 1, label: "Yes"}, ...]`)

## API Endpoints

### Flow Blueprint

- `GET /api/flow/current-item` - Get current item in navigation
- `POST /api/flow/evaluate-item` - Process user response
- `GET /api/flow/previous-item` - Navigate backward
- `GET /api/flow/navigation-path` - Get complete navigation path

### Validation Blueprint

- `GET /api/qml/validation` - Full validation with Z3 classification
- `GET /api/qml/validate` - Validate QML structure
- `GET /api/qml/files` - List available QML files

## Security

The PythonRunner ([core/python_runner.py](askalot_qml/core/python_runner.py)) provides sandboxed code execution:

- **Allowed modules**: math, random, statistics, itertools, functools, collections, re
- **Forbidden constructs**: Import, AsyncFunctionDef, ClassDef, eval, exec, compile, open, os, sys
- **AST validation**: Code is validated before execution

## Testing

Test files are located in `tests/unit/` and `tests/integration/`. Run with:

```bash
make test           # All tests
make test-unit      # Unit tests only
make test-integration  # Integration tests only
```

## Development Notes

### Import Patterns

```python
# Top-level imports (recommended)
from askalot_qml.core import FlowProcessor, ValidationProcessor
from askalot_qml.models import QMLState

# Explicit imports
from askalot_qml.core import FlowProcessor, ValidationProcessor
from askalot_qml.z3 import StaticBuilder, ItemClassifier
```

### Debugging

Both processors provide `debug_dump()` methods for diagnostic output.
