# Questionnaire Markup Language Compiler and Validator

> License & usage posture. This repository is source-available, **not
> OSI-approved**, and licensed under PolyForm Noncommercial 1.0.0 — a
> non-commercial license. You may read, run, modify, and cite the code
> for any non-commercial purpose (research, teaching, evaluation, personal
> use). Commercial use requires a separate license from Askalot. This
> replaces the prior CC BY-NC 4.0 statement. See [LICENSE](./LICENSE).

## Authorship & Intellectual Property

The **QML language specification** — and the underlying concept of a
**declarative questionnaire with formal validation by an SMT solver** — are the
intellectual property of **Peter Saghelyi**, the author and originator of this
work.

A peer-reviewed scientific paper describing the language and its
formal-validation model is currently **under review** and will be published
soon; full citation details will be added here on publication. Until then,
please attribute the QML language and its SMT-based validation model to the
author and link back to this repository.

This authorship/IP notice is distinct from the code license above: the PolyForm
Noncommercial 1.0.0 license governs use of the source code, while the design of
the QML language and its formal-validation method remain the author's
intellectual property.

**Author:** Peter Saghelyi · [psaghelyi@askalot.io](mailto:psaghelyi@askalot.io) · [LinkedIn](https://www.linkedin.com/in/psaghelyi/)

## Overview

The **askalot_qml** module provides Z3-driven questionnaire validation capabilities with two distinct processors:

- **FlowProcessor**: Runtime questionnaire traversal for conducting interviews
- **ValidationProcessor**: Offline static validation for questionnaire design

Both processors share a common pipeline through QMLEngine that handles dependency graph construction and topological sorting.

## Examples & Evaluation

### Worked examples — `tests/fixtures/`

[`tests/fixtures/`](tests/fixtures/) holds 38 runnable `.qml` files that
showcase the language's capabilities (and double as the test suite). Highlights:

- **Core flow** — `basic.qml`, `branching_flow.qml`, `dependencies.qml`, `scoring.qml`, `question_group.qml`
- **Matrix questions** — `matrix_ranking.qml`, `matrix_symmetry.qml`, `matrix_fixed_sum.qml`, `matrix_infeasible_sum.qml`
- **Group blocks** (single-pass, the default `kind`, optionally `count`-capped) — a Group asks each in-scope inner item once in canonical order; an optional `count: N` caps it to a deterministic, precondition-gated **first-N** draw (not random selection)
- **Roster blocks** (repeat-over-entities) — `roster_numeric.qml`, `roster_multiselect.qml`, `roster_inner_precondition.qml`, `roster_single_label.qml`
- **Formal-validation cases** — `cycles.qml`, `classification.qml`, and the `thesis_*.qml` set (dead-code and conflicting-postcondition detection drawn from the paper).

### Evaluation corpus — `evaluation/`

[`evaluation/`](evaluation/) evaluates QML against **real-world, publicly
available questionnaires** rather than toy inputs — established instruments such
as **AUDIT, BRFSS, CCHS, DHS, NHIS** and Malaria Surveillance, alongside
national censuses and sociology/education surveys, each converted to QML and
organized by domain. The curated source catalog — provenance and download links
across 13 domains (health, demographics, sociology, market research, compliance,
education, safety-critical, legal, infrastructure, and more) — is in
[`evaluation/questionnaire_sources.md`](evaluation/questionnaire_sources.md).

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
│   ├── qml_diagram_ir.py         # Positions-free graph IR for the QML Explorer webview
│   ├── qml_engine.py             # Common pipeline orchestrator
│   ├── qml_loader.py             # QML file loading + block flattening
│   ├── qml_topology.py           # Dependency graph and topological sort
│   └── item_count.py             # Canonical top-level item-count helper
├── models/                        # Data models
│   ├── item_proxy.py             # Runtime item wrapper (incl. MatrixQuestion outcomes)
│   └── qml_state.py              # Survey state management
├── schema/                        # QML schema + grammar contract (see "QML Schema & Grammar")
│   ├── qml-schema.json           # Authoritative JSON Schema (dialect 2020-12)
│   └── qml-grammar.w3c.ebnf      # W3C-EBNF rendering for railroad-diagram tools
└── z3/                           # Z3 constraint solving
    ├── global_formula.py         # Global satisfiability check (Level 2)
    ├── item_classifier.py        # Per-item Z3 classification (Level 1)
    ├── path_based_validation.py  # Accumulated reachability / dead code (Level 3)
    ├── pragmatic_compiler.py     # AST to Z3 constraint compilation
    └── static_builder.py         # SSA versioning and constraint generation
```

## Formal Foundation

The module implements the formal-verification model described in the forthcoming peer-reviewed paper (see [Authorship & Intellectual Property](#authorship--intellectual-property)):

### Questionnaire Definition

A questionnaire is a tuple $G = (I, S, D, P, Q, I_{start})$ where:
- $I$ — finite set of items
- $S$ — vector of outcome variables
- $D$ — domain constraints for each outcome
- $P$ — preconditions (Boolean formulas determining item visibility)
- $Q$ — postconditions (Boolean formulas constraining valid responses)

### Base Constraint

$$B := \bigwedge_i D_i(S_i)$$

the conjunction of all per-outcome domain constraints.

### Validation Hierarchy

Three levels of increasing thoroughness, implemented in the `z3/` module:

| Level | Formula | Implementation | Purpose |
|-------|---------|----------------|---------|
| **Per-item** | $W_i = B \wedge P_i \wedge \neg Q_i$ | [item_classifier.py](askalot_qml/z3/item_classifier.py) | Detect NEVER reachable and INFEASIBLE items |
| **Global** | $F = B \wedge \bigwedge_i (P_i \Rightarrow Q_i)$ | [global_formula.py](askalot_qml/z3/global_formula.py) | Detect conflicting postconditions |
| **Path-based** | $A_i = B \wedge \bigwedge_{j \in \mathrm{Pred}(i)} (P_j \Rightarrow Q_j)$ | [path_based_validation.py](askalot_qml/z3/path_based_validation.py) | Detect dead code (unreachable items) |

**Relationships between levels:**
- **Per-item passes → Global passes**: if all $W_i$ are UNSAT, then $\mathrm{SAT}(F)$ is guaranteed (Theorem: Soundness)
- **Global fails → Path-based fails**: if $\mathrm{UNSAT}(F)$, no execution path is valid (Theorem: Global Necessary)
- **Global passes ↛ All paths valid**: $\mathrm{SAT}(F)$ doesn't guarantee all items reachable (Theorem: Global Not Sufficient)

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
| ALWAYS | $\mathrm{UNSAT}(B \wedge \neg P)$ | Item always shown |
| CONDITIONAL | $\mathrm{SAT}(B \wedge P)$ and $\mathrm{SAT}(B \wedge \neg P)$ | Item sometimes shown |
| NEVER | $\mathrm{UNSAT}(B \wedge P)$ | Item never reachable (dead code) |

**Postcondition Invariant** (relative to precondition $P$):
| Status | Condition | Meaning |
|--------|-----------|---------|
| TAUTOLOGICAL | $\mathrm{UNSAT}(B \wedge P \wedge \neg Q)$ | Postcondition always holds when reached |
| CONSTRAINING | both $\mathrm{SAT}(B \wedge P \wedge Q)$ and $\mathrm{SAT}(B \wedge P \wedge \neg Q)$ | Postcondition filters some responses |
| INFEASIBLE | $\mathrm{UNSAT}(B \wedge P \wedge Q)$ | Postcondition can never be satisfied (design error) |
| NONE | no postcondition defined | No validation constraints |

### Validation Diagram Coloring

| Color | Class | Meaning |
|-------|-------|---------|
| 🟢 Green | always | ALWAYS reachable |
| 🟡 Yellow | conditional | CONDITIONAL reachability |
| 🔴 Red | never | NEVER reachable |
| 🟣 Purple | infeasible | INFEASIBLE postcondition |
| 🔵 Blue | tautological | TAUTOLOGICAL postcondition |

## Common Pipeline

Both processors share the QMLEngine ([core/qml_engine.py](askalot_qml/core/qml_engine.py)) which provides:

### StaticBuilder

**File**: [z3/static_builder.py](askalot_qml/z3/static_builder.py)

- Parses preconditions, postconditions, and code blocks
- Generates Z3 constraints using SSA (Static Single Assignment) versioning
- Discovers item dependencies through constraint analysis
- Creates frozen base constraint $B$ for classification

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

### QMLDiagramIR

**File**: [core/qml_diagram_ir.py](askalot_qml/core/qml_diagram_ir.py)

Emits a **positions-free** structural intermediate representation (IR) — top-level `blocks`, `items`, and `conditions` arrays — consumed by the React + React Flow webview in the QML Explorer. Layout is computed **client-side by ELK.js**; this module never computes node positions.

1. **Structure**: blocks (incl. Roster `iterate_over`/`labels` and Group `count`), items (kind, control, classification), and conditions (pre/post predicates with item-outcome and variable references)
2. **Classification**: per-item flow/validation classification is attached to the IR for the viewer to color

## QML Language

QML files are YAML-based questionnaire specifications. See [Examples & Evaluation](#examples--evaluation) and [`tests/fixtures/`](tests/fixtures/) for examples.

Key elements:
- **codeInit**: Global initialization code block
- **blocks**: Logical groupings of items (can have block-level `precondition`)
- **items**: Questions, comments, or groups with:
  - **precondition**: List of predicates determining visibility
  - **postcondition**: List of predicates with hints for validation
  - **codeBlock**: Python code executed after response

### Block-Level Preconditions

Blocks can define preconditions (and postconditions) that apply to all items within them. The block's `precondition`/`postcondition` lists stay **on the block** — they are not copied onto items. Consumers compose them at evaluation time: `FlowProcessor` (and `StaticBuilder`, when emitting Z3 constraints) gate each item on `(block.precondition or []) + (item.precondition or [])`. During flattening, `QMLLoader` propagates only block-*kind* metadata onto inner items — `_roster_block_id` / `_roster_iterate_over` / `_roster_labels` for Roster blocks, and `_group_block_id` / `_group_count` for the inner items of a `count`-capped Group (an uncapped Group adds no tags) — so downstream code can detect roster/Group membership without re-walking the block tree.

### Domain Constraints for Z3

StaticBuilder extracts domain constraints $D_i(S_i)$ from item input specs for base constraint $B$. Supports:
- **Numeric controls** (Editbox, Slider, Range): `min`/`max` bounds
- **Choice controls** (Radio, Dropdown, Checkbox, Switch): Enumeration via `labels` (e.g. `{1: "Yes", 2: "No"}`)

## QML Schema & Grammar

The `askalot_qml/schema/` folder holds the canonical contract for **QML** — the
YAML/JSON document format that authors, the AI generator, the loader, and the
qml-explorer frontend all agree on.

| File | Role |
|------|------|
| `askalot_qml/schema/qml-schema.json` | **Authoritative** JSON Schema (dialect `2020-12`), schema version **2.0.0**. Single source of truth. |
| `askalot_qml/schema/qml-grammar.w3c.ebnf` | A **W3C-EBNF rendering** of the same contract, for railroad-diagram tools. Derived from the schema; not authoritative. |
| `askalot_qml/schema/__init__.py` | Exposes `QML_SCHEMA_VERSION`, read from `qml-schema.json` at import (no hardcoded copy). |

The schema is the source of truth. The EBNF is a human-readable, diagrammable
view of it — when the two disagree, the schema wins, and the EBNF should be
regenerated.

### What QML describes

A QML document is `{ qmlVersion, questionnaire }`. A `questionnaire` has an
ordered list of `blocks`; each block has `items`; questions carry an `input`
control. Items and blocks may carry `precondition` / `postcondition` lists
(predicates over prior answers) and Python `codeBlock` / `codeInit` snippets.
Three discriminators shape almost everything:

- **`Block.kind`** — `Group` | `Roster` (optional; defaults to `Group`)
- **`Item.kind`** — `Comment` | `Question` | `QuestionGroup` | `MatrixQuestion`
- **`Input.control`** — `Switch` | `Radio` | `Dropdown` | `Checkbox` | `Editbox` | `Textarea` | `Slider` | `Range`

In the schema these are encoded as `allOf` / `if`-`then` conditional
requirements (each discriminator value pulls in its own required and forbidden
fields). **Those conditionals are the heart of the language**, and they are
exactly what the grammar turns into alternation forks.

### How to read `qml-grammar.w3c.ebnf`

It is an **abstract field-structure grammar**, not a byte-level JSON/YAML
grammar. Read it with these conventions in mind:

- **Punctuation is elided.** Object braces, colons, commas, and string quoting
  do not appear — only field structure does.
- **A field is `"key" ValueType`.** For example `"id" String`, or the optional
  `( "title" String )?`. Repeated array values use `*` / `+`
  (e.g. `Condition*`, `Block+`).
- **Field order is canonical-only.** QML objects are *unordered* mappings, so a
  railroad's left-to-right sequence overstates ordering. Treat the order as a
  reading convenience, not a rule.
- **Discriminators are alternation forks.** `Block`, `Item`, and `Input` each
  branch one way per `kind` / `control`, with that branch's required fields
  inline. This is the payoff of deriving from the conditional requirements.
- **Start symbol:** `QMLDocument`.
- **`String` / `Integer` / `Number` are intentionally undefined** — they are
  opaque lexical scalars. Expanding them into character-class railroads would
  only add noise, so diagram tools list them as undefined non-terminals (and
  still render every diagram). This is expected, not an error.

The grammar uses the **W3C EBNF dialect**: `::=` for productions, `|`
alternation, `?` `*` `+` quantifiers, `( )` grouping, `"lit"` terminals, and
`/* … */` comments.

### Visualize the grammar (railroad / syntax diagrams)

Paste the **whole** `qml-grammar.w3c.ebnf` file in, start symbol `QMLDocument`:

- **[bottlecaps.de/rr/ui](https://www.bottlecaps.de/rr/ui)** — the de-facto
  standard. *Edit Grammar* tab → paste → *View Diagram*. IPv4 mirror:
  **[rr.red-dove.com/ui](https://rr.red-dove.com/ui)**.
- **[ebnf2railroad](https://matthijsgroen.github.io/ebnf2railroad/)** — EBNF +
  `(* *)` comments → an HTML page of diagrams.
- **[DrawGrammar](https://jacquev6.github.io/DrawGrammar/)** — quick paste-and-draw.
- **[EBNF-Visualizer (JKU)](http://dotnet.jku.at/applications/visualizer/)** —
  exports `.gif`.

### Validate / test the grammar (accept-reject)

These tools check formal validity and let you test whether sample strings
conform — useful when sanity-checking that the grammar accepts and rejects what
you intend:

- **[BNF Playground](https://bnfplayground.pauliankline.com/)** — define the
  grammar, generate valid strings, and validate input (green = matches).
- **[EBNF Lab](https://thomasgassmann.com/blog/ebnf-lab)** — verifier + word producer.
- **[icosaedro.it/bnf_chk](https://www.icosaedro.it/bnf_chk/)** — pure formal-validity checker.

> Dialects differ between tools (BNF vs ISO-EBNF vs W3C-EBNF), so the file may
> need small syntactic tweaks to load outside the bottlecaps family.

### Schema-vs-grammar gaps

A context-free grammar cannot express everything the schema and loader enforce,
and in a few places the grammar is deliberately *stricter* than the live schema.
Know these before trusting the diagram as the full contract:

1. **Open vs closed.** `qml-schema.json` sets `unevaluatedProperties: false`
   **on `Block`** (as of `2.0.0`) — it composes across the kind-conditional
   `allOf`/`if`-`then` branches, so a misplaced key on a block (`iterateOvr`, a
   `count` on a `Roster`, a stray `is_random`) is now **rejected**. The other
   object types (`Item`, `Input`, `Condition`, `Questionnaire`) still set neither
   `additionalProperties: false` nor `unevaluatedProperties: false`, so they
   **silently accept unknown, misspelled, or misplaced keys** today
   (`precondtion`). The grammar models the *intended, closed* language — it lists
   only declared members. Broader `unevaluatedProperties: false` adoption beyond
   `Block` is deferred follow-up.
2. **Vestigial Roster guard.** The schema's Roster branch forbids `as` and
   `maxEntries` via `not`/`anyOf`, but those properties are declared nowhere, so
   the guard is dead weight. The grammar simply omits them.
3. **Value constraints** (below) are enforced by the loader / Z3 validator, not
   by structure, so they cannot appear in the grammar.

#### Value constraints not expressible in the grammar

| Construct / field | Constraint | Enforced by |
|---|---|---|
| `Group.count` | optional positive integer ≥ 1 (omitted = ask all in-scope items; no silent default) | schema (`minimum: 1`) + loader |
| `Group.count` inner-item independence | inner items of a `count`-capped Group must not depend on one another | loader (AST sibling-ref) + Z3 validator (transitive dep graph) |
| `Roster.labels` keys | must be powers of two (1, 2, 4, …) | loader / code |
| `Checkbox.labels` keys | must be powers of two | loader / code |
| `Switch.default` | `0` or `1` | schema (`enum`) |
| `Radio.default`, `Dropdown.default` | must be an existing key of `labels` | code / UI |
| `Editbox.default`, `Slider.default`, `Range.default` | `min ≤ default ≤ max` | code / UI |
| `qmlVersion` | a **declared** MAJOR != 2 is rejected loudly (e.g. `qmlVersion: "1.0"` fails to load); an **absent** `qmlVersion` stays advisory | loader |

### Why the grammar is hand-derived

Off-the-shelf JSON-Schema → grammar converters
([llama.cpp json-schema-to-grammar](https://github.com/ggml-org/llama.cpp),
[json-schema-to-gbnf](https://github.com/adrienbrault/json-schema-to-gbnf),
[XGrammar](https://deepwiki.com/mlc-ai/xgrammar/5.2-regular-expression-to-ebnf-conversion))
exist, but they target **GBNF over the JSON wire syntax** to constrain LLM
decoding. They are verbose and — critically — they flatten or drop the
`if`/`then`/`allOf`/`oneOf` conditional requirements, which is exactly the
`kind`→fields and `control`→fields structure that makes QML QML. So the
EBNF here was derived by hand to keep those discriminators as first-class
alternation forks. (See also the open
[transformers-CFG feature request](https://github.com/epfl-dlab/transformers-CFG/issues/2)
and the [json-schema.org grammar discussion](https://github.com/orgs/json-schema-org/discussions/201).)

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
