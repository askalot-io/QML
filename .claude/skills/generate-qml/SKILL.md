---
name: generate-qml
description: >
  Write QML (Questionnaire Markup Language) files for the Askalot survey platform.
  Use this skill when the user wants to create, write, generate, or design a NEW
  survey or questionnaire in QML format from requirements or specifications. This
  includes: designing new questionnaires from scratch, modifying or extending existing
  QML files, fixing validation errors in QML files, and translating regulations or
  compliance rules into survey form. For converting existing imperative questionnaires
  (PDF, CATI, paper surveys with GOTO-based routing) into QML, use the
  build-inventory, inventory-to-qml, and write-analysis skills instead. Trigger on: QML writing, new questionnaire
  design, survey creation from requirements, QML modification, QML syntax questions,
  or extending an existing QML file.
---

# Writing QML Questionnaires

QML is a declarative, YAML-based language for formally verified questionnaires. A Z3 SMT
solver validates all logic automatically. Your job is to translate requirements into
constraints — the solver handles consistency checking.

## Core Philosophy: Declare Constraints, Not Flow

This is the single most important concept. Do NOT think in terms of "if the user answers X,
go to question Y." Instead think:

- **Preconditions**: "Question Y is relevant when X is true"
- **Postconditions**: "Answer Z must satisfy this constraint"
- **Code blocks**: "After this answer, update this classification variable"

The Z3 solver verifies that all paths are reachable, all constraints are satisfiable, and
there are no logical contradictions. You define **what must be true**, not **how to get there**.

## QML Structure

Every QML file follows this skeleton:

```yaml
qmlVersion: "1.0"
questionnaire:
  title: "Survey Title"
  codeInit: |
    # Initialize ALL global variables here
    score = 0
    category = 0
  blocks:
    - id: b_section_name
      title: "Section Title"
      items:
        - id: q_item_id
          kind: Question
          title: "Question text?"
          input:
            control: Radio
            labels:
              1: "Option A"
              2: "Option B"
```

Key structural rules:
- `qmlVersion: "1.0"` is required at root level
- At least one block, each block has at least one item
- All IDs must be unique across the entire questionnaire
- Convention: block IDs start with `b_`, question IDs with `q_`

### One questionnaire = one QML file

A questionnaire is **never** split across multiple QML files. Each questionnaire
is a single file with one `qmlVersion`, one `questionnaire`, one `codeInit`, and
one ordered `blocks:` list. The original survey's sections become blocks inside
that one file — they are not separate files.

There is **no `extern`, no `import`, no `include`** mechanism for sharing state
across files. Cross-file variable sharing was prototyped briefly and removed;
any pattern that looks like a Python type-annotation in `codeInit`
(`age: range(0, 120)`, `sex: {1, 2}`) is the dead remnant of that prototype and
**must not be used** — Python annotations do not assign a value, so the variable
is undefined at runtime, and Z3 cannot infer its domain.

If you encounter a legacy questionnaire stored as numbered section files
(`01_foo.qml`, `02_bar.qml`, ...) in older corpus folders, that is a historical
artifact from an earlier pipeline. The fix is to **merge the sections into one
file**, not to extend the split. See "Merging legacy multi-file questionnaires"
at the end of this skill.

## Item Kinds

| Kind | Purpose | Requires | Outcome Type |
|------|---------|----------|-------------|
| Comment | Display text, no response | Nothing extra | None |
| Question | Single answer | `input` block | Single integer |
| QuestionGroup | List of same-type questions | `questions` list + `input` | Vector of integers |
| MatrixQuestion | Grid of answers | `rows`, `columns` + `input` | Matrix of integers |

For QuestionGroup and MatrixQuestion details with examples, see `references/qml-full-reference.md`.

## Input Controls

Choose the right control for the data type:

| Use Case | Control | Required Properties |
|----------|---------|-------------------|
| Yes/No binary | Switch | `on`, `off` (label strings) |
| Precise number (age, count) | Editbox | `min`, `max` (integers) |
| Subjective scale (1-10) | Slider | `min`, `max`, optional `step` |
| Numeric interval (price range) | Range | `min`, `max`, optional `step` |
| Multiple selection | Checkbox | `labels` with **power-of-2 keys** |
| Single choice, 2-5 options | Radio | `labels` (int-to-string map) |
| Single choice, 6+ options | Dropdown | `labels` (int-to-string map) |
| Open-ended text | Textarea | optional `placeholder`, `maxLength` |

Critical rules:
- Checkbox keys MUST be powers of 2: `1, 2, 4, 8, 16, 32...` (bit mask encoding)
- Editbox/Slider/Range MUST have `min` and `max`
- Radio/Dropdown/Checkbox MUST have `labels`
- For MatrixQuestion cells: use Radio for 2-3 options, Dropdown for 4+
- All `labels` maps use integer keys, string values: `{1: "Yes", 2: "No"}`

Optional properties: `default` (preset value), `left`/`right` (prefix/suffix text for
Editbox, Slider, Dropdown).

## Conditional Logic

### Preconditions — When to Show an Item

```yaml
precondition:
  - predicate: q_age.outcome >= 18
  - predicate: q_consent.outcome == 1
```

Both preconditions and postconditions are lists of predicates, semantically equivalent
to a single conjunction. The reason for using a list instead of one big `and` expression
is that each predicate carries its own `hint` — when a predicate fails, only its
specific hint is shown. This lets you give targeted feedback for each condition.

Multiple predicates are AND-ed — all must be true. Use `and`/`or` within a single
predicate for complex logic:

```yaml
precondition:
  - predicate: q_age.outcome >= 18 and (q_employed.outcome == 1 or q_student.outcome == 1)
```

Blocks can also have preconditions — use this when an entire section should be skipped.

### Postconditions — Validation After Response

```yaml
postcondition:
  - predicate: q_children.outcome < q_household.outcome
    hint: "Number of children must be less than total household size"
  - predicate: q_end_date.outcome >= q_start_date.outcome
    hint: "End date must be on or after start date"
```

The `hint` is shown to the respondent when validation fails. Make hints specific and helpful.

## Code Blocks

### codeInit — Global Variable Setup

Runs once before the questionnaire starts. Initialize variables here — but **only variables
that store computed, aggregated, or maintained state**:

```yaml
questionnaire:
  codeInit: |
    total_score = 0
    risk_level = 0
    path = 0
    is_eligible = 0
```

`codeInit` only accepts plain Python statements. Do **not** use Python's
type-annotation syntax (`age: range(0, 120)`, `sex: {1, 2}`) — these are
no-op annotations that never assign a value, leaving the variable
undefined when later code reads it. Use ordinary assignments
(`age = 0`, `sex = 0`) and let Z3 infer the domain from the producer
item's input control (see "Cross-block state" below).

**Do NOT create variables that merely copy an item's outcome.** Every item's outcome is
always accessible via `q_item.outcome` in preconditions and codeBlocks. A variable like
`smoking_status = q_smoking.outcome` is redundant — use `q_smoking.outcome` directly.

Variables are justified ONLY when they:
- **Compute or derive** a value from multiple inputs (e.g., `actual_hours = q_151.outcome - q_153.outcome + q_155.outcome`)
- **Aggregate or count** across items (e.g., `symptom_count = symptom_count + 1`)
- **Classify** based on conditional logic (e.g., `if q_100.outcome == 1: path = 1`)
- **Consolidate** outcomes from mutually exclusive items (e.g., `respondent_age` set by either `q_age_dob` or `q_age_manual`)

```yaml
# WRONG: variable just copies the outcome
codeBlock: |
  smoking_status = q_smoking.outcome   # redundant!

# Later precondition uses the copy:
precondition:
  - predicate: smoking_status == 1     # should be q_smoking.outcome == 1

# RIGHT: use the outcome directly
precondition:
  - predicate: q_smoking.outcome == 1
```

### Cross-block state

A QML file has **one** `codeInit` scope and **one** dependency graph. Every
variable initialized in `codeInit` is visible to every block that comes after
its producer. There is nothing else to do — no extern declarations, no
imports, no namespace markers. The shared scope is the mechanism.

The canonical pattern for a variable that one block produces and a later
block consumes:

```yaml
codeInit: |
  age = 0       # neutral default; producer reassigns below

blocks:
  - id: b_demographics
    items:
      - id: q_demo_age
        kind: Question
        title: "What is your age?"
        codeBlock: |
          age = q_demo_age.outcome
        input:
          control: Editbox
          min: 0
          max: 120

  - id: b_health
    items:
      - id: q_smoke
        kind: Question
        title: "Do you smoke?"
        precondition:
          - predicate: age >= 12     # reads the variable set above
        input:
          control: Switch
          on: "Yes"
          off: "No"
```

What the static builder sees:
1. `codeInit` defines `age = 0`.
2. The codeBlock on `q_demo_age` reassigns `age` from an `Editbox` outcome
   whose declared domain is `[0, 120]`. The Z3 SSA tracker propagates that
   domain into `age`, so subsequent preconditions reason about
   `age ∈ [0, 120]`.
3. The precondition `age >= 12` on `q_smoke` is then classified as
   CONDITIONAL — Z3 knows both `age >= 12` and `age < 12` are reachable
   completions.

Two rules fall out of this:

- **Initialize every cross-block variable in `codeInit`** with a neutral
  default (`0`, `-1`, whatever fits). Without the initialization, the
  static builder cannot construct a base constraint for the variable and
  will report the consumer's precondition as unsatisfiable.
- **The producer block must come before the consumer block** in the
  ordered `blocks:` list. The dependency graph is built from the textual
  order plus the data-flow edges; an out-of-order producer creates a
  cycle or a missing definition. When converting a survey, this is
  usually free — the original presentation order already respects data
  flow — but if the source instrument asks demographics last and uses
  them in early branching, you must reorder the blocks so demographics
  comes first.

### codeBlock — Per-Item Logic

Runs after an item's postcondition passes. Updates computed/aggregated variables:

```yaml
- id: q_smoking
  kind: Question
  title: "Do you smoke?"
  input:
    control: Switch
    off: "No"
    on: "Yes"
  codeBlock: |
    if q_smoking.outcome == 1:
        risk_level = risk_level + 3
```

### Z3-Verifiable Python Subset

Code blocks are analyzed by the Z3 SMT solver. Only use these features:

**Allowed:**
- Arithmetic: `+`, `-`, `*`, `//`, `%`
- Comparisons: `<`, `<=`, `>`, `>=`, `==`, `!=`
- Boolean: `and`, `or`, `not`
- Control: `if`/`elif`/`else`, `for` with `range(n)` where n <= 20
- Ternary: `x = 1 if condition else 0`
- Assignment: `=`, `+=`, `-=`, `*=`, `//=`
- Tuple unpacking: `a, b = 1, 0`
- Membership: `in`, `not in` with literal containers like `[1, 2, 3]`
- Built-ins: `range()`, `int()`, `bool()`, `abs()` only
- Outcome access: `q_item.outcome`, `qg_item.outcome[i]`, `mq_item.outcome[i][j]`

**NOT allowed — these silently return 0 in the solver, creating unverifiable logic:**
- `len()`, `sum()`, `max()`, `min()` — all return 0
- `list.append()`, any method calls — return 0
- List comprehensions, lambda, dict literals
- String methods, subscript on regular variables
- `while` loops, `break`, `continue`
- Functions, classes, imports

Instead of `sum()`, add values explicitly:
```yaml
codeBlock: |
  total = qg_ratings.outcome[0] + qg_ratings.outcome[1] + qg_ratings.outcome[2]
```

### Execution Order (Important)

For each item, processing happens in this strict sequence:
1. **Precondition** evaluated — can reference prior outcomes and variables
2. **Outcome collected** — respondent answers
3. **Postcondition** evaluated — can reference current item's outcome, but variables
   still hold values from BEFORE this item's codeBlock
4. **CodeBlock** executed — updates variables for subsequent items

This means: a postcondition on the same item whose codeBlock updates a variable will see
the variable's OLD value, not the updated one.

## Validation Checklist

Before outputting the QML, verify every point:

1. Every Question, QuestionGroup, MatrixQuestion has an `input` block
2. Every Editbox, Slider, Range has `min` and `max`
3. Every Radio, Dropdown, Checkbox has `labels`
4. Every Checkbox uses power-of-2 keys (1, 2, 4, 8, 16...)
5. All item and block IDs are unique
6. All variables referenced in predicates are initialized in `codeInit` or prior codeBlocks
7. Producer items appear before consumer items (items that set a variable come before items
   that reference it in preconditions)
8. No unsupported Python features in code blocks (no len, sum, max, min, append, etc.)
9. Postcondition hints are specific and user-friendly
10. Multiple precondition predicates correctly express AND logic (use `or` within a single
    predicate for OR logic)
11. **No redundant outcome-copying variables** — every variable in `codeInit` must serve a
    purpose beyond copying `q_item.outcome`. If a precondition can reference `q_item.outcome`
    directly, do NOT create a variable for it
12. **One file** — the questionnaire lives in a single `<SURVEY>.qml`, not multiple
    section files. The original survey's sections become blocks within that file.
13. **No annotation-style declarations in `codeInit`** — `age: range(0, 120)` is a
    no-op Python annotation, not an assignment. Use `age = 0`.
14. **Producer blocks come before consumer blocks** in the `blocks:` list. If a
    block's precondition reads a variable, the block that writes that variable
    must be ordered earlier.

## Workflow

1. **Understand requirements** — Ask clarifying questions about the survey's purpose,
   target audience, and conditional logic
2. **Design block structure** — Group related questions into logical sections
3. **Choose controls** — Match each question to the right input control type
4. **Write items** — Create each item with appropriate kind and input
5. **Add preconditions** — Define when each conditional question appears
6. **Add postconditions** — Define validation constraints with helpful hints
7. **Add code blocks** — Implement scoring, classification, or routing variables
8. **Initialize variables** — Ensure all variables are declared in `codeInit`
9. **Validate** — Run the validator and check against the checklist
10. **Save** — Use `save_qml_file` (Askalot MCP) or write the file locally

## Validation

After writing a QML file, validate it:

```bash
cd /root/QML && \
uv run python .claude/skills/generate-qml/scripts/validate_qml.py <path-to-qml-file> [--json]
```

Exit code 0 = valid, 1 = issues found, 2 = error. For detailed Z3 analysis and
interpreting classifications, see the `write-analysis` skill.

### Platform Validation via MCP

When working with the Askalot platform:

- `list_qml_files` — See available QML definitions
- `inspect_qml_file` — Quick summary of a QML file
- `get_qml_content` — Read the full YAML source
- `save_qml_file` — Save a new or updated QML file
- `validate_qml_file` — Run Z3 validation to check for structural problems
- `publish_qml_file` / `unpublish_qml_file` — Control questionnaire availability

## Reference Files

- **`references/qml-full-reference.md`** — Complete syntax reference with all control
  properties, QuestionGroup/MatrixQuestion examples, and the full JSON schema summary.
  Read this when working with complex item types or unusual control configurations.

- **`references/goto-conversion-guide.md`** — Detailed GOTO-to-declarative conversion
  patterns with real-world examples. Read this when you need to understand how imperative
  routing maps to QML preconditions and code blocks.

## Merging legacy multi-file questionnaires

If the user asks you to fix or extend a questionnaire that exists as numbered
section files (`01_household.qml`, `02_two_week_disability.qml`, ...), the
right answer is almost always to merge them into one file first. The split
came from an extern-variable prototype that was reverted; the files are no
longer a supported configuration.

The merge is a textual concatenation, not a YAML round-trip — round-tripping
through a YAML loader strips the comments and the per-item ordering hints
that domain reviewers rely on. Procedure:

1. **Inventory cross-section variables.** For every section file, look at its
   `codeInit`. Variables initialized to a literal (`age = 0`) are produced
   downstream; variables shown with annotation syntax (`age: range(0, 120)`)
   are extern declarations that need to disappear — record the variable name
   and its expected domain. The producer sections are the ones that assign
   the variable in an item's `codeBlock`.

2. **Check for ID collisions.** Block IDs and item IDs must be unique across
   the entire merged file. Run `grep -hE '^    - id: ' *.qml | sort | uniq -d`
   for blocks and the equivalent at item-indent level. Collisions are common
   for generic IDs like `b_administration` or `b_intro`. Rename one side
   before merging — if the renamed block is referenced from a precondition or
   codeBlock, update those references too.

3. **Build the merged header.** Write a fresh top-level `qmlVersion`,
   `questionnaire`, `title`, and `codeInit`. The merged `codeInit` initializes
   every cross-section variable with a neutral literal (no annotation
   syntax). Order the initializers by which producer block sets them.

4. **Concatenate the blocks.** For each section file in producer-before-consumer
   order, take everything after the `  blocks:` marker line and append it to
   the merged file under the single `blocks:` list. A short section header
   comment (`# === SECTION 03: Health Care Utilization ===`) at each boundary
   makes the merged file navigable.

5. **Validate.** Run the validator on the merged file. The most common
   failures after a merge are: (a) a variable that some section was reading
   via the dead extern syntax was never initialized in the merged
   `codeInit`; (b) a block was placed before its producer; (c) an ID
   collision was missed. All three surface as either Z3 unsat or a topology
   error.

6. **Delete the old section files.** Once the merged file validates, `git rm`
   the numbered section files. Leaving them in place invites future Claudes
   to edit the wrong artifact.
