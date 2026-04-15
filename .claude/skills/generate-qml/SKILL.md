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
