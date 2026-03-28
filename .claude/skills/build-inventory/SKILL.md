---
name: build-inventory
description: >
  Convert a PDF/CATI questionnaire into a structured question inventory with full
  routing annotations. Extracts every question, response option, and GOTO/skip
  instruction into a flat, verifiable Markdown document. Includes a judgement agent
  that verifies semantic coverage and structural completeness against the source.
  Trigger on: question inventory, PDF extraction, questionnaire cataloguing,
  survey node extraction, routing annotation.
---

# Build Question Inventory

## Purpose

The question inventory is the critical intermediate representation between a source
questionnaire (PDF, CATI script) and declarative QML. It captures every question,
response option, and routing target in a flat, verifiable list. Every precondition,
postcondition, and codeBlock in the eventual QML is derived from a GOTO annotation
in the inventory. An inventory without routing is useless for conversion.

## Input

A path to a PDF questionnaire file (or a pre-extracted text file).

## Output

A Markdown file at `evaluation/<category>/SURVEY_NAME/SURVEY_NAME_question_inventory.md`
with verification status showing 0 missing items across all sections.

---

## Step 1: PDF Preprocessing

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

## Step 2: Per-Section Extraction (Subagents)

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

There are **three node types** — missing any type creates gaps that block QML generation:

| Node Type | Examples | Purpose | QML Mapping |
|-----------|----------|---------|-------------|
| **Question** | Q##, q_## | Asked of respondent | Item with outcome |
| **Check / Filter** | C##, CHECK, IF..., routing gates | Controls question visibility | Precondition |
| **Constraint** | Hard/soft edit, cross-check, consistency rule, interviewer instruction | Validates answers, enforces consistency | Postcondition |

Node type labels vary across questionnaire traditions (StatCan uses C-prefixed checks
and CATI-XXXe edits; DHS uses CHECK filters; other formats use different conventions).
Look for the **function**, not the label.

**Commonly missed** (from auditing 10 StatCan questionnaires):
- **Checks/filters**: Missed in 4/10 inventories. Silent routing gates like
  "If age < 12, skip to end of section." They become preconditions.
  Omitting them loses entire skip paths.
- **Constraints**: Missed in 6/10 inventories. Cross-validation rules like
  "If Q5=Yes and Q8=No, flag contradiction" become postconditions. Also watch for
  derived variables (e.g., "Set SPABUSE = sum(D1..D10)") — these are maintained via
  codeBlocks on the items that produce them, and later referenced in preconditions
  or postconditions. Without them, section-to-section routing cannot be modeled.
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

## Step 3: Judgement Agent — Verify Completeness

After assembling the inventory, launch a **judgement subagent** that independently
verifies the inventory against the source. The judgement agent receives:

- The source text file path
- The completed inventory file path
- Instructions to check the three dimensions below

The judgement agent must NOT have written the inventory — it acts as an independent
reviewer.

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

Verify all three node types are captured (questions, checks/filters, constraints).
The most common omissions:
- Checks/filters: caused entire skip paths to vanish in 4/10 inventories
- Constraints: lost validation rules and derived variables needed for section routing in 6/10 inventories
- DK/Refusal branches: created incomplete routing graphs in 5/10 inventories

### Judgement Agent Output

The judgement agent updates the `## Verification Status` section at the top of the
inventory document:

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

If the judgement agent finds gaps, it flags them and the coordinator fixes the
inventory. Repeat until every section shows 0 missing in both columns.

### Gate Condition

**The inventory is complete when the Verification Status shows READY FOR QML.**

If the source uses different section prefixes or question numbering than expected,
flag immediately — the inventory may have been built against a different version.
