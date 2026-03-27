---
name: evaluate-questionnaire
description: >
  Convert imperative questionnaires (PDF, CATI, paper surveys) into declarative QML
  and produce a formal validation analysis report that exposes design problems. Use this
  skill when the user wants to evaluate, convert, analyze, or audit an existing
  questionnaire. The pipeline discovers problems hidden in imperative routing through
  Z3 formal verification. Trigger on: questionnaire evaluation, CATI conversion,
  GOTO-based questionnaire analysis, survey conversion, questionnaire audit,
  PDF-to-QML conversion, skip pattern analysis, or any request to find structural
  problems in an existing survey design.
---

# Questionnaire Evaluation Pipeline

## Purpose

Find design problems in original questionnaires that are hidden by their imperative
(GOTO-based) representation. Converting to declarative QML makes every routing decision
explicit, and the Z3 SMT solver formally verifies structural consistency — exposing
contradictions, dead code, unreachable items, and logic gaps invisible in flowchart form.

The conversion is the means. The analysis report is the end.

## Pipeline Overview

```
PDF (imperative) --> Question Inventory --> QML (declarative) --> Analysis Report
     Phase 1             Phase 2              Phase 3              Phase 4
  Build inventory    Verify completeness    Generate QML        Validate & report
```

Each phase has a clear deliverable and gate condition. Do NOT skip phases.

## Output Artifacts

For a questionnaire named `SURVEY_NAME`, the pipeline produces these files in a
per-questionnaire subdirectory under `evaluation/<category>/SURVEY_NAME/`:

| Artifact | File | Phase |
|----------|------|-------|
| Question inventory | `SURVEY_NAME_question_inventory.md` | 1-2 |
| Section QML files | `NN_section_name.qml` | 3 |
| Analysis report | `SURVEY_NAME.md` | 4 |

---

## Phase 1: Build Question Inventory

The question inventory is the critical intermediate representation. It captures every
question, response option, and routing target from the source in a flat, verifiable list.
Every precondition, postcondition, and codeBlock in the eventual QML is derived from a
GOTO annotation in the inventory. An inventory without routing is useless for conversion.

### PDF Preprocessing

For large PDFs (50+ pages), **always extract to text first**:

```bash
pdftotext -layout -nodiag source.pdf /tmp/source.txt
```

- `-layout` preserves spatial formatting (question IDs, response codes, indentation)
- `-nodiag` discards diagonal text (watermarks that pollute output)

Work from the text file, not the PDF. This avoids:
1. **Non-linear PDF page ordering** — some PDFs have pages in non-sequential order
2. **Agent timeouts** — large PDFs (130+ pages) cause processing failures
3. **Searchability** — text files support grep for systematic verification

After extraction, locate section boundaries:
```bash
grep -n "_BEG\|SECTION [A-Z]" /tmp/source.txt
```

### Subagent Strategy: Per-Section Discovery

For questionnaires with multiple sections/modules, launch **subagents per section** to
build inventory entries in parallel:

1. **Coordinator** reads the full text file and identifies section boundaries (line ranges)
2. **Subagents** (one per section) each receive:
   - The text file path and their assigned line range
   - The node type reference table (below)
   - The inventory entry format specification (below)
3. Each subagent produces a Markdown fragment for its section
4. **Coordinator** assembles all fragments into `SURVEY_NAME_question_inventory.md`
   with the document header and verification status section

### Node Types to Capture

There are **five node types** — missing any type creates gaps that block QML generation:

| Node Type | ID Pattern | Purpose | QML Mapping |
|-----------|-----------|---------|-------------|
| **Question** | Q## | Asked of respondent | Question/QuestionGroup item |
| **Check** | C## | Silent routing gate | Precondition or block precondition |
| **CATI Edit** | CATI-XXXe | Validation/flag-setting | Postcondition or codeBlock |
| **Read** | R## | Interviewer instruction | Comment item or intro text |
| **Internal** | N##, E## | Computed routing | codeBlock logic |

**Commonly missed node types** (from auditing 10 StatCan questionnaires):
- **Check items (C-prefixed)**: Missed in 4/10 inventories. Silent routing gates like
  `CCC_C01A: If age < 12, go to CCC_END`. They become block-level preconditions.
  Omitting them loses entire skip paths.
- **CATI edit blocks**: Missed in 6/10 inventories. Flag-setting nodes like
  `CATI-D10e: Set SPABUSE = sum(D1..D10)`. Without them, section-to-section routing
  (e.g., "If SPABUSE=0, skip Section L") cannot be modeled.
- **DK/Refusal routing**: Missed in 5/10 inventories. Almost every question has implicit
  `DK-->GO TO X, R-->GO TO Y` branches.

### Inventory Entry Format

For each node, record:
1. Sequential number and original ID
2. Question text
3. Input type and response options with codes
4. **GOTO/skip routing for every response option** (e.g.,
   `1=Yes-->GO TO Q9, 2=No, 8=Don't know-->GO TO Q11`)
5. Interviewer notes or filter checkpoints

Example entry:
```
42. Q_SMK_Q01: "At the present time, do you smoke cigarettes daily, occasionally or not
    at all?" - Choice: 1=Daily-->GO TO Q_SMK_Q02, 2=Occasionally-->GO TO Q_SMK_Q05,
    3=Not at all-->GO TO Q_SMK_Q10, DK-->GO TO Q_SMK_END, R-->GO TO Q_SMK_END
```

**Preserve original section prefixes.** Never rename question IDs (e.g., RESTR to GEN,
CHLT to AHL). Renaming destroys traceability between the inventory and source document,
making verification impossible and confusing domain reviewers.

### Inventory Document Structure

```markdown
# Survey Name - Question Inventory

## Verification Status
- **Coverage**: [pending / X/Y sections verified], Z items total
- **Routing**: [pending / A/B GOTO annotations captured]
- **Status**: [PENDING VERIFICATION / READY FOR QML / NEEDS REPAIR]
- **Missing**: [none / list any gaps]

## Document Overview
- **Title**: ...
- **Organization**: ...
- **Pages**: ...
- **Language**: ...
- **Type**: ...

## Structure
[High-level section organization]

## Question Inventory by Section

### Section Name - N questions

1. Q_ID: "Question text" - **Control**: Options - GOTO annotations
2. ...
```

---

## Phase 2: Verify Inventory Completeness

Cross-reference the inventory against the source text file section by section. Check
three things:

### (a) Question Coverage

For each section, count question IDs in the source vs the inventory:
```bash
grep -c "^CCC_Q" /tmp/source.txt    # count source questions in CCC section
```

Include appendices, alternate-form sections, child/proxy modules, and age-specific
sub-sections — these are commonly missed.

### (b) Routing Coverage

Count items with GOTO/skip in the source vs items with routing annotations in the
inventory. Every `GO TO`, `IF...GO TO`, and filter checkpoint must appear.

### (c) Node Type Coverage

Verify all five node types are captured (Q, C, CATI, R, N/E). The most common
omissions:
- Check items (C-prefixed): caused entire skip paths to vanish in 4/10 inventories
- CATI edits: lost flag variables needed for section routing in 6/10 inventories
- DK/Refusal branches: created incomplete routing graphs in 5/10 inventories

### Update Verification Status

Update the `## Verification Status` section at the top of the inventory document:

```markdown
## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Source GOTOs | Inv. GOTOs | Missing |
|---------|----------|-------------|---------|-------------|-----------|---------|
| Health  | 55       | 55          | 0       | 23          | 23        | 0       |
| Labour  | 42       | 42          | 0       | 38          | 38        | 0       |
| ...     | ...      | ...         | ...     | ...         | ...       | ...     |

- **Coverage**: 10/10 sections verified, 337 items total
- **Routing**: 92/92 GOTO annotations captured
- **Status**: READY FOR QML
```

### Gate Condition

**Do NOT proceed to Phase 3 until every section shows 0 missing in both columns.**

If the source uses different section prefixes or question numbering than expected,
flag immediately — the inventory may have been built against a different version.

---

## Phase 3: Generate QML

Transform the verified inventory into a declarative QML file. For QML language syntax,
controls, code blocks, and execution order rules, refer to the **`write-qml` skill**.

### Subagent Strategy: Per-Section QML Files

For large questionnaires, launch **subagents per section** to generate independent QML
files in parallel. Each subagent receives:

1. The relevant inventory section(s) for its block(s)
2. QML language rules (from the `write-qml` skill: controls, preconditions, postconditions,
   code block constraints, execution order)
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

Each section file must be a valid QML file on its own. This allows independent validation
and parallel development. Along with the file, each subagent returns a variable manifest
listing all variables it **reads** and **writes** in codeBlocks.

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
from the section title in the source PDF. The prefix determines the intended flow order.

Each section file is a **standalone deliverable** — the final output is the set of
section files, not a merged file. This enables:
- Independent validation per section
- Parallel subagent generation
- Easier review and maintenance
- Clear mapping from PDF sections to QML files

### Coordinator: Validate and Report

After all section subagents complete, the coordinator:

1. **Validates each section file independently**:
   ```bash
   cd /root/QML && \
   uv run python .claude/skills/write-qml/scripts/validate_qml.py \
     evaluation/<category>/SURVEY_NAME/NN_section.qml
   ```
   Fix any structural errors. Cross-section variable references (variables set
   in one section, read in another) will appear as free variables — that is
   expected at the per-section level.

2. **Collects validation results** from all section files: item counts, classifications,
   cycles, and any issues found.

3. **Produces aggregate statistics** for the report: total items across all sections,
   total variables, total preconditions, etc.

4. **Runs the validation checklist** (see below) across all section files

### Conversion Patterns: GOTO to Declarative

Apply these patterns when converting imperative routing. For detailed examples from
10 Statistics Canada CATI questionnaires, read
`.claude/skills/write-qml/references/goto-conversion-guide.md`.

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

### QML Validation Checklist

Before completing Phase 3, verify every point:

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

---

## Phase 4: Validate and Report

### Run Z3 Validator

```bash
cd /root/QML && \
uv run python .claude/skills/write-qml/scripts/validate_qml.py <path-to-qml-file> [--json]
```

The validator runs four formal verification steps (always in order):

1. **Per-item classification** — W_i = B AND P_i AND NOT Q_i
   Classifies reachability (ALWAYS/CONDITIONAL/NEVER) and postcondition invariant
   (TAUTOLOGICAL/CONSTRAINING/INFEASIBLE/NONE).
2. **Global satisfiability** — F = B AND conjunction(P_i => Q_i)
   Checks at least one valid completion exists. UNSAT = no valid path.
3. **Dependency loops** — Kahn's algorithm with cycle detection
4. **Path-based reachability** — accumulated predecessor postconditions detect dead code

Exit code 0 = valid, 1 = issues found, 2 = error.

### Analysis Report Structure

Write the report as `SURVEY_NAME.md`:

```markdown
# Survey Title: Declarative Conversion Analysis

**Source:** Organization, Survey Name, N pages
**QML File:** `evaluation/path/SURVEY_NAME.qml`
**Date:** YYYY-MM-DD

## Objective

Transform the [description] questionnaire ([pages], [routing style]) into a declarative
QML representation, then run the Z3-based formal validator to detect structural problems
hidden in the imperative version.

## Methodology

1. [How the source was read/preprocessed]
2. Question inventory: N nodes catalogued across M sections
3. Declarative QML conversion with [routing approach]
4. Formal validation using the Askalot Z3 QML validator

## Survey Architecture Overview

[Block structure table with block IDs, PDF pages, item counts, purposes]

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | N |
| Blocks | N |
| Preconditions | N |
| Postconditions | N |
| Variables | N |
| Cycles | N |
| Global Status | SAT/UNSAT |
| Issues | N |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | N |
| Precondition CONDITIONAL | N |
| Precondition NEVER | N |
| Postcondition CONSTRAINING | N |
| Postcondition INFEASIBLE | N |
| Postcondition TAUTOLOGICAL | N |

[Interpretation of classifications]

## Section Files

| # | File | Block(s) | Items | Variables Read | Variables Written |
|---|------|----------|-------|----------------|-------------------|
| 01 | `sections/01_demographics.qml` | b_demographics | N | — | age, sex |
| 02 | `sections/02_health.qml` | b_health | N | age, sex | health_flag |
| ... | ... | ... | ... | ... | ... |

**Unified file:** `SURVEY_NAME.qml` (N items total, M blocks, K variables)

## Problems in the Original [Source] (Exposed by Declarative Conversion)

### P1: [Problem Title]

**Severity:** HIGH / MEDIUM / LOW
**PDF evidence:** [Page numbers, question IDs]

**Problem:** [Description of the design issue]

**In the imperative version:** [Why it was hidden or tolerable]

**In the declarative version:** [How the conversion made it visible]

### P2: ...

## Cross-Check Fixes (QML Authoring Errors)

[Table of errors introduced during conversion that were caught and corrected.
These are NOT problems in the original — they are conversion mistakes.]

| # | Item(s) | Error | Fix | PDF Reference |
|---|---------|-------|-----|---------------|
| 1 | ... | ... | ... | ... |

## Impact Assessment

[Comparison of paper/CATI form vs QML representation — what the conversion reveals
about the original design]

## Conclusion

[Summary of findings and implications for the questionnaire's design quality]
```

### What Constitutes a "Problem"

Focus on issues that are **properties of the original questionnaire design**, not
artifacts of the QML conversion:

- **Unreachable items** (NEVER classification) — dead code; questions that can never be shown
- **Infeasible postconditions** — validation rules that can never be satisfied
- **Dependency cycles** — variable feedback loops creating ambiguous routing
- **Asymmetric gates** — inconsistent application of age/sex/proxy exclusions across modules
- **Phantom dependencies** — external variables never defined within the questionnaire
- **Redundant structures** — parallel sections that are structurally identical
- **Missing gates** — filter checkpoints implied but not explicit in routing
- **Routing opacity** — logic that depends on undocumented external systems
- **Cross-reference inconsistencies** — e.g., asymmetric severity thresholds in parallel
  screening pathways

Conversion artifacts (e.g., "QML lacks loop construct for person roster") should be
documented in Cross-Check Fixes or noted as limitations, not listed as Problems.

---

## Existing Evaluation Corpus

The `evaluation/` directory contains 18 completed conversions organized in per-questionnaire
subfolders:

- **`ICS-hun/ICS_kerdezesi_protokoll/`** — Hungarian emergency dispatch protocol (66 pages,
  242 items, 46 cycles — waterfall "first YES wins" pattern)
- **`reference-questionnaires/{NAME}/`** — International surveys: ACS 2025, BRFSS 2023,
  DHS-8 (M/W), ESS Round 12, Demographics module
- **`statcan-questionnaires/{NAME}/`** — 10 Statistics Canada CATI questionnaires (33-303
  pages, 154-1153 items) with complete inventories, QML files, and analysis reports

Each subfolder contains the source PDF, question inventory, QML file(s), and analysis
report. Use these as reference for format, depth, and problem categorization.

## Reference Files

- **`write-qml` skill** — QML language syntax, item kinds, input controls, code blocks,
  execution order rules
- **`.claude/skills/write-qml/references/goto-conversion-guide.md`** — Detailed
  GOTO-to-declarative conversion patterns with real-world examples from 10 Statistics
  Canada CATI questionnaires, including pitfalls and their frequencies
- **`.claude/skills/write-qml/references/qml-full-reference.md`** — Complete QML syntax
  reference with QuestionGroup, MatrixQuestion, and all control properties
