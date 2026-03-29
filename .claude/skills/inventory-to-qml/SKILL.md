---
name: inventory-to-qml
description: >
  Convert a verified question inventory into declarative QML files. Groups
  related survey sections into thematic files (10–25 per questionnaire), with
  each section as a block within its file. Transforms imperative GOTO-based
  routing into preconditions, postconditions, and code blocks. Each file passes
  Z3 validation independently. Includes a judgement agent that verifies the QML
  faithfully represents the inventory. Trigger on: inventory to QML, QML
  generation from inventory, section QML files, GOTO conversion, declarative
  conversion.
---

# Inventory to QML

## Purpose

Transform a verified question inventory into declarative QML files — one standalone
file per section. The inventory's GOTO annotations become preconditions, postconditions,
and code blocks. Each section file must pass Z3 validation independently.

## Input

A completed question inventory at
`evaluation/<category>/SURVEY_NAME/SURVEY_NAME_question_inventory.md`
with Verification Status showing `READY FOR QML`.

## Output

Section QML files at `evaluation/<category>/SURVEY_NAME/NN_section_name.qml`.

## Reference Files

For QML language syntax, controls, code blocks, and execution order rules:
- `.claude/skills/generate-qml/SKILL.md` — QML language reference
- `.claude/skills/generate-qml/references/qml-full-reference.md` — Complete syntax
- `.claude/skills/generate-qml/references/goto-conversion-guide.md` — GOTO-to-declarative
  conversion patterns with real-world examples and pitfall frequencies

---

## Step 1: Plan Section Grouping

Before generating any QML, plan how to group the inventory's sections into QML files.
Each QML file contains **multiple blocks** — one block per original survey section.
The goal is to produce a manageable number of thematic files (typically 10–25 for a
large questionnaire), not one file per section.

### Grouping Criteria

Group sections that share any of these characteristics:

1. **Thematic relatedness** — sections on the same health topic belong together
   (e.g., mammography + breast exam + breast self-exam → one "breast screening" file)
2. **Shared variables** — sections that read each other's outcomes should be in the
   same file. This eliminates cross-file extern declarations and gives Z3 full
   visibility into the dependency chain.
3. **Structural similarity** — sections that follow the same pattern (e.g., 11
   preventive screening modules that all use "ever had? → when? → why not?") belong
   in one file with one block per module.
4. **Conditional dependency** — a section that only activates based on another
   section's outcome should be with its parent (e.g., diabetes care with chronic
   conditions, since diabetes care is gated on the chronic conditions checklist).

### Variable Scope Rules

When sections are grouped into the **same QML file**:
- Variables set by one block's codeBlocks are directly available to later blocks
- Item outcomes (`q_item.outcome`) are directly referenceable in preconditions
- No extern declarations needed — everything shares one `codeInit` scope

When sections are in **different QML files**:
- Use extern variable declarations (type annotations without values) in `codeInit`:
  ```yaml
  codeInit: |
    age: range(12, 120)
    sex: {1, 2}
  ```
- This gives Z3 domain constraints instead of fixed values

**Grouping decisions should minimize cross-file externs.** If section B reads 5
variables from section A, they should be in the same file. Universal variables like
`age`, `sex`, and `is_proxy` will always be cross-file externs (they come from the
demographics file).

### Example Grouping (CCHS 2005 — 74 sections → 20 files)

| File | Sections | Rationale |
|------|----------|-----------|
| `01_demographics_general_health` | ANC, GEN, HWT, SDC | Who the person is |
| `02_lifestyle` | ORG, SLP, CIH | Daily habits and improvement |
| `03_chronic_conditions` | CCC, DIA | DIA depends entirely on CCC |
| `07_preventive_screening` | FLU, BPC, PAP, MAM, BRX, BSX, EYX, PCU, PSA, CCS, DEN | 11 modules, same pattern |
| `10_smoking_tobacco` | SSB, SMK, SCH, NDE, SCA, SPC, YSM, ETS | All share SMK outcomes |

### File Naming

Files use zero-padded sequential prefixes with short snake_case topic names:

```
SURVEY_NAME/
  01_demographics_general_health.qml
  02_lifestyle.qml
  03_chronic_conditions.qml
  ...
```

## Step 2: Per-File QML Generation (Subagents)

For large questionnaires, launch **subagents per grouped file** to generate QML files
in parallel. Each subagent receives:

1. The relevant inventory sections for all blocks in its file
2. QML language rules (from the `generate-qml` skill: controls, preconditions,
   postconditions, code block constraints, execution order)
3. The list of extern variables it needs from other files
4. The list of variables it produces that other files will need

Each subagent outputs a **complete, standalone `.qml` file** with multiple blocks:

```yaml
qmlVersion: "1.0"
questionnaire:
  title: "Chronic Conditions"
  codeInit: |
    age: range(12, 120)
    sex: {1, 2}
    has_skin_cancer = 0
  blocks:
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

Each block within the file maps to one original survey section. Block-level
preconditions gate entire sections (e.g., diabetes care is only shown if the
respondent reported having diabetes in the chronic conditions block above it).

Variables set in earlier blocks' codeBlocks are directly available to later blocks
— no extern declarations needed within the same file.

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

**Pattern 6** — flag routing across sections:
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

## Step 3: Validate Each File

After all subagents complete, validate each grouped QML file independently:

```bash
cd /root/QML && \
uv run python .claude/skills/generate-qml/scripts/validate_qml.py \
  evaluation/<category>/SURVEY_NAME/NN_section.qml
```

Fix any structural errors. Cross-section variable references (variables set in one
section, read in another) should be declared as **extern variables** using type
annotations in `codeInit`:

```yaml
codeInit: |
  age: range(0, 120)
  sex: {1, 2}
```

This gives Z3 domain constraints instead of fixed values, so preconditions like
`age >= 18` classify as CONDITIONAL (not NEVER). See the `generate-qml` skill for
full extern variable syntax.

### QML Validation Checklist

Before proceeding to the judgement agent, verify every point:

1. Every Question/QuestionGroup/MatrixQuestion has an `input` block
2. Every Editbox/Slider/Range has `min` and `max`
3. Every Radio/Dropdown/Checkbox has `labels`
4. Every Checkbox uses power-of-2 keys (1, 2, 4, 8, 16...)
5. All IDs are unique across the entire questionnaire
6. All variables in predicates are initialized in `codeInit`
7. Producer items appear before consumer items in topological order
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

## Step 4: Judgement Agent — Verify QML Fidelity

After validation passes, launch a **judgement subagent** that independently verifies
the QML against the inventory. The judgement agent receives:

- The inventory file path
- All grouped QML file paths
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
and all section files pass Z3 validation.**
