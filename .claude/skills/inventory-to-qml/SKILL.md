---
name: inventory-to-qml
description: >
  Convert a verified question inventory into declarative QML section files.
  Transforms imperative GOTO-based routing into preconditions, postconditions,
  and code blocks. Produces one standalone QML file per section with independent
  Z3 validation. Includes a judgement agent that verifies the QML faithfully
  represents the inventory. Trigger on: inventory to QML, QML generation from
  inventory, section QML files, GOTO conversion, declarative conversion.
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

## Step 1: Per-Section QML Generation (Subagents)

For large questionnaires, launch **subagents per section** to generate independent QML
files in parallel. Each subagent receives:

1. The relevant inventory section(s) for its block(s)
2. QML language rules (from the `generate-qml` skill: controls, preconditions,
   postconditions, code block constraints, execution order)
3. A list of variables it may **read** (produced by prior sections)
4. A list of variables it should **produce** (needed by subsequent sections)

Each subagent outputs a **complete, standalone `.qml` file** — not a YAML fragment:

```yaml
qmlVersion: "1.0"
questionnaire:
  title: "Section Title"
  codeInit: |
    # ONLY variables this section reads or writes
    var1 = 0
    var2 = 0
  blocks:
    - id: b_section_name
      title: "Section Title"
      items:
        - id: q_item_1
          kind: Question
          ...
```

Each section file must be a valid QML file on its own. Along with the file, each
subagent returns a variable manifest listing all variables it **reads** and **writes**
in codeBlocks.

### Section File Naming

Section files live directly in the questionnaire subdirectory with zero-padded sequential
prefixes for sort ordering:

```
SURVEY_NAME/
  01_demographics.qml
  02_health.qml
  03_labour_force.qml
  ...
```

The name after the prefix should be a short, lowercase, snake_case identifier derived
from the section title in the source. The prefix determines the intended flow order.

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

## Step 2: Validate Each Section

After all section subagents complete, validate each section file independently:

```bash
cd /root/QML && \
uv run python .claude/skills/generate-qml/scripts/validate_qml.py \
  evaluation/<category>/SURVEY_NAME/NN_section.qml
```

Fix any structural errors. Cross-section variable references (variables set in one
section, read in another) will appear as free variables — that is expected at the
per-section level.

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

## Step 3: Judgement Agent — Verify QML Fidelity

After validation passes, launch a **judgement subagent** that independently verifies
the QML against the inventory. The judgement agent receives:

- The inventory file path
- All section QML file paths
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
