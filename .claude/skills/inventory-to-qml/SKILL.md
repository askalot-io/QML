---
name: inventory-to-qml
description: >
  Convert a verified question inventory into a single declarative QML file. The
  survey's original sections become ordered blocks inside one QML file, with
  imperative GOTO-based routing transformed into preconditions, postconditions,
  and code blocks. The file passes Z3 validation as a whole. Includes a
  judgement agent that verifies the QML faithfully represents the inventory.
  Trigger on: inventory to QML, QML generation from inventory, GOTO conversion,
  declarative conversion.
---

# Inventory to QML

## Purpose

Transform a verified question inventory into a single declarative QML file for
the whole questionnaire. The inventory's GOTO annotations become preconditions,
postconditions, and code blocks. Every original survey section becomes a block
inside this one file, and the file must pass Z3 validation as a whole.

**A questionnaire is never split across multiple QML files.** All variables,
item outcomes, and dependency edges live in one shared scope so Z3 can reason
about reachability end-to-end. If a large questionnaire seems to "need"
splitting, that is a symptom of weak block ordering — fix the order, don't
split the file.

## Input

A completed question inventory at
`evaluation/<category>/SURVEY_NAME/SURVEY_NAME_question_inventory.md`
with Verification Status showing `READY FOR QML`.

## Output

A single QML file at `evaluation/<category>/SURVEY_NAME/SURVEY_NAME.qml`.

## Reference Files

For QML language syntax, controls, code blocks, and execution order rules:
- `.claude/skills/generate-qml/SKILL.md` — QML language reference
- `.claude/skills/generate-qml/references/qml-full-reference.md` — Complete syntax
- `.claude/skills/generate-qml/references/goto-conversion-guide.md` — GOTO-to-declarative
  conversion patterns with real-world examples and pitfall frequencies

---

## Step 1: Plan Block Ordering

Before generating any QML, plan how the inventory's sections map to **blocks**
inside the single output file, and in what order those blocks appear. The output
is ONE `SURVEY_NAME.qml` file with many blocks — never multiple files.

### Ordering Criteria

Blocks must be ordered so that each block's preconditions reference only
variables and item outcomes produced by *earlier* blocks. Use these criteria
(in priority order):

1. **Screeners and gates first** — eligibility filters and opt-outs come before
   anything conditional on them.
2. **Demographics early** — age, sex, and other universal classifiers come
   before any block that branches on them. Almost every questionnaire ends up
   with a demographics block near the top.
3. **Thematic grouping** — sections on the same topic stay adjacent (e.g.,
   mammography + breast exam + breast self-exam as three consecutive blocks
   inside one "breast screening" region).
4. **Conditional dependency** — a block that only activates based on another
   block's outcome comes *after* its parent (e.g., diabetes care block after
   the chronic-conditions checklist block that gates it).
5. **Structural similarity** — sections that follow the same pattern (e.g.,
   11 preventive screening modules that all use "ever had? → when? → why not?")
   stay together so a reader can eyeball them as a group.

### Variable Scope Rules

Because there is only one QML file:

- Variables set in one block's codeBlocks are directly available to all
  subsequent blocks — no declarations needed beyond the single `codeInit`
- Item outcomes (`q_item.outcome`) are directly referenceable in any later
  precondition or codeBlock
- `codeInit` initializes every global variable the questionnaire uses
  (scores, counters, classification flags)
- There are no extern variables and no cross-file hand-overs. If an ordering
  issue looks like it needs one, the fix is to move the producer block earlier
  in the file

### Block Naming

Blocks inside the single file use the convention `b_<topic>` with a short
snake_case topic name:

```yaml
blocks:
  - id: b_screening
  - id: b_demographics_general_health
  - id: b_lifestyle
  - id: b_chronic_conditions
  - id: b_diabetes_care
  - id: b_preventive_screening
  - id: b_smoking_tobacco
  ...
```

The file itself is `evaluation/<category>/SURVEY_NAME/SURVEY_NAME.qml`.

## Step 2: Per-Block QML Generation (Subagents)

For large questionnaires, launch **subagents per block** to draft block YAML
fragments in parallel. Each subagent receives:

1. The relevant inventory sections for its assigned block(s)
2. QML language rules (from the `generate-qml` skill: controls, preconditions,
   postconditions, code block constraints, execution order)
3. The list of variables already defined (in `codeInit` or earlier blocks) that
   it may read
4. The list of variables it must produce for later blocks to read

Each subagent outputs one or more **block YAML fragments** — never a complete
standalone QML file. The coordinator assembles all block fragments into the
single output file with one shared `codeInit`, one `qmlVersion: "1.0"`, and one
`questionnaire:` wrapper.

Example block fragment returned by a subagent:

```yaml
- id: b_chronic_conditions
  title: "Chronic Conditions Checklist"
  items:
    - id: q_ccc_food_allergies
      kind: Question
      ...

- id: b_diabetes_care
  title: "Diabetes Care"
  precondition:
    - predicate: q_ccc_diabetes.outcome == 1
  items:
    - id: q_dia_a1c_test
      kind: Question
      ...
```

The coordinator assembles these into:

```yaml
qmlVersion: "1.0"
questionnaire:
  title: "Survey Name"
  codeInit: |
    # All global variables for the entire questionnaire
    total_score = 0
    has_skin_cancer = 0
    spabuse = 0
  blocks:
    - id: b_screening
      ...
    - id: b_demographics_general_health
      ...
    - id: b_chronic_conditions
      ...
    - id: b_diabetes_care
      ...
```

Each block within the file maps to one original survey section. Block-level
preconditions gate entire sections (e.g., diabetes care is only shown if the
respondent reported having diabetes in the chronic conditions block above it).

Variables set in earlier blocks' codeBlocks are directly available to later
blocks — everything shares one `codeInit` scope.

### Conversion Patterns: GOTO to Declarative

Apply these patterns when converting imperative routing. For detailed examples, read
`.claude/skills/generate-qml/references/goto-conversion-guide.md`.

| # | Pattern | Imperative | Declarative |
|---|---------|-----------|------------|
| 1 | Simple routing | "If X, go to Y" | Precondition on Y: `q_x.outcome == value` |
| 2 | PATH variable | Routing variable directs to sections | `codeBlock` sets path; preconditions read it |
| 3 | Skip to section end | "Skip to end of section" | Block-level precondition |
| 4 | Cross-checks | "CATI CHECK: Q5 <= Q3" | Postcondition with hint |
| 5 | Converging paths | Multiple GOTOs to same target | No precondition (everyone) or OR predicate |
| 6 | Flag routing | Edit block sets flag, later section tests it | `codeBlock` increments counter; block precondition tests it |
| 7 | Parallel sections | Identical sections for different subjects | Separate blocks, each fully spelled out |
| 8 | Filter gates | "If count < N, skip section" | Counter variable + precondition |

**Pattern 1** — most common. Instead of routing FROM the gate, put a precondition ON the
target:
```yaml
- id: q_cigarettes
  precondition:
    - predicate: q_smoke.outcome == 1
```

**Pattern 2** — routing variable. Watch for feedback loops: if item A reads `path` in its
precondition and downstream item B writes back to `path`, Z3 detects a cycle.

**Pattern 6** — flag routing across blocks:
```yaml
codeInit: |
  spabuse = 0

- id: q_d1_threatened
  codeBlock: |
    if q_d1_threatened.outcome == 1:
        spabuse = spabuse + 1

- id: b_abuse_report
  precondition:
    - predicate: spabuse > 0
```

**Pattern 8** — commonly missed. Hidden filter checks appear as interviewer instructions,
not GOTO statements:
```yaml
codeInit: |
  symptom_count = 0

- id: q_severity
  precondition:
    - predicate: symptom_count >= 5
```

## Step 3: Validate the QML File

After the coordinator assembles all block fragments into one file, validate it:

```bash
cd /root/QML && \
uv run python .claude/skills/generate-qml/scripts/validate_qml.py \
  evaluation/<category>/SURVEY_NAME/SURVEY_NAME.qml
```

Fix any structural errors. If the validator reports variables referenced
before they are defined, the fix is to reorder blocks so producers come
before consumers — not to split the file or introduce any form of extern
declaration.

### QML Validation Checklist

Before proceeding to the judgement agent, verify every point:

1. Every Question/QuestionGroup/MatrixQuestion has an `input` block
2. Every Editbox/Slider/Range has `min` and `max`
3. Every Radio/Dropdown/Checkbox has `labels`
4. Every Checkbox uses power-of-2 keys (1, 2, 4, 8, 16...)
5. All IDs are unique across the entire questionnaire
6. All variables in predicates are initialized in `codeInit`
7. Producer items appear before consumer items in topological order, and
   producer blocks appear before consumer blocks in file order
8. No unsupported Python in code blocks (no `len`, `sum`, `max`, `min`, `append`)
9. Postcondition hints are specific and user-friendly
10. Multiple precondition predicates express AND (use `or` within a single predicate for OR)
11. Filter/screener gates are modeled with counter variables and preconditions
12. "Other (specify)" options have a Textarea follow-up with precondition
13. PATH variables are not both read in preconditions AND written downstream
    (use separate variables for initial and refined classification)
14. Age boundaries match the source exactly (watch off-by-one: >= 15 vs >= 16)
15. Waterfall/cascade patterns use direct outcome references, NOT shared routing variables
16. **No redundant outcome-copying variables** — use `q_item.outcome` directly in preconditions
    instead of creating variables like `q156_outcome = q_156.outcome`. Variables are only for
    computation, aggregation, counting, conditional classification, or consolidating outcomes
    from mutually exclusive items
17. **No type annotations in `codeInit`** — declarations like `age: range(0, 120)` or
    `sex: {1, 2}` are not supported. Every variable in `codeInit` must be a plain assignment
    (`score = 0`, `path = 0`). If you think you need an annotation, reorder blocks so the
    producer runs first

## Step 4: Judgement Agent — Verify QML Fidelity

After validation passes, launch a **judgement subagent** that independently verifies
the QML against the inventory. The judgement agent receives:

- The inventory file path
- The single QML file path
- The source text file path (for cross-referencing routing)

The judgement agent must NOT have generated the QML — it acts as an independent reviewer.

### What the Judgement Agent Checks

1. **Completeness:** For each inventory entry, confirm a corresponding QML item exists.
   If any are missing, flag them for the coordinator to add.

2. **Response options:** Verify every response option and its code matches the inventory.
   Missing options or wrong codes break data compatibility.

3. **Skip logic:** For each GOTO/CHECK annotation in the inventory, verify the
   corresponding precondition exists in the QML and is logically equivalent.

4. **Coverage summary:**
   ```
   Inventory items: {N}
   QML items: {M}
   Matched: {X}
   Missing (flagged for addition): {Y}
   Justified omissions: {Z} (list each with reason)
   ```

   **Justified omissions** are ONLY:
   - Procedural elements: interviewer visit logs, consent signatures, cover page fields
   - Dynamic roster loops where the same questions repeat N times for N household members
     (document which questions are templated and that they represent a per-person loop)
   - Iterative calendar/history grids that require dynamic row generation
   - TERMINATE/END paths (QML represents qualified respondents)

   Everything else must be present.

### After Judgement

If the judgement agent flags missing items or incorrect logic, the coordinator fixes
the QML and re-validates. Repeat until the judgement agent confirms full coverage.

### Gate Condition

**The QML is complete when the judgement agent reports 0 unjustified missing items
and the single `SURVEY_NAME.qml` file passes Z3 validation.**
