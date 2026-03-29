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

### OCR text file (`_ocr.md`)

Each questionnaire folder may already contain a pre-extracted text file with the
`_ocr.md` suffix (e.g., `BRFSS_2023_ocr.md` alongside `BRFSS_2023.pdf`). **Always
check for this file first** — if it exists, use it as the primary source instead of
re-extracting from the PDF.

```bash
ls "$(dirname "$PDF")/"*_ocr.md
```

If no `_ocr.md` file exists, create one using the two-tier extraction below.

### Tier 1: `pdftotext` (digital PDFs)

```bash
pdftotext -layout -nodiag source.pdf SURVEY_NAME_ocr.md
```

- `-layout` preserves spatial formatting (question IDs, response codes, indentation)
- `-nodiag` discards diagonal text (watermarks/holograms that pollute output)

**Quality check** — verify extraction produced usable output:
```bash
pages=$(pdfinfo source.pdf | grep "^Pages:" | awk '{print $2}')
lines=$(wc -l < SURVEY_NAME_ocr.md)
ratio=$(echo "scale=1; $lines / $pages" | bc)
echo "lines/page = $ratio"
```

If `lines/page < 5`, the PDF is scanned/image-based and pdftotext failed. Fall
back to Tier 2.

### Tier 2: Tesseract OCR (scanned PDFs)

For scanned or image-based PDFs where pdftotext produces near-empty output:

```bash
mkdir -p /tmp/ocr_pages
pdftoppm -png -r 300 source.pdf /tmp/ocr_pages/page
for img in $(ls /tmp/ocr_pages/page-*.png | sort); do
  tesseract "$img" stdout 2>/dev/null
  echo -e "\n---PAGE BREAK---\n"
done > SURVEY_NAME_ocr.md
rm -rf /tmp/ocr_pages
```

Tesseract output may contain checkbox artifacts (`O` for circles, `L` for form
lines) but question text, routing instructions, and response options are readable.

### Place the `_ocr.md` next to the source PDF

The extracted text file lives in the same directory as the PDF:
```
evaluation/<category>/SURVEY_NAME/
  source.pdf                         # Original PDF
  SURVEY_NAME_ocr.md                 # Text extraction (this step)
  SURVEY_NAME_question_inventory.md  # Inventory (Step 2-3)
  SURVEY_NAME.md                     # Analysis report (later)
```

Work from the `_ocr.md` file, not the PDF. This avoids:
1. **Non-linear PDF page ordering** — some PDFs have pages in non-sequential order
2. **Agent timeouts** — large PDFs (130+ pages) cause processing failures
3. **Searchability** — text files support grep for systematic verification

After extraction, locate section boundaries:
```bash
grep -n "_BEG\|SECTION [A-Z]" SURVEY_NAME_ocr.md
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

### Input Type Vocabulary

Use these abstract types in the **Control** field. They describe the input format
visible in the source questionnaire — **never use QML control names** (Radio,
Switch, Slider, Editbox, Dropdown, Checkbox, Textarea) in the inventory. The
inventory captures *what the source shows*; the QML generator decides *which
control to use*.

| Input Type | When to use | Notation |
|------------|-------------|----------|
| **Yes/No** | Exactly two options, binary | `Yes/No` |
| **Single select** | Pick one from an enumerated list (3+ options) | `Single select {1: "Label", ...}` |
| **Multi select** | "Mark all that apply", pick several | `Multi select {1: "Label", ...}` |
| **Numeric** | Number entry, optionally bounded | `Numeric` or `Numeric (min–max)` |
| **Scale** | Labeled continuum with endpoint semantics | `Scale (min–max): "low" to "high"` |
| **Text** | Free text or open-ended write-in | `Text` or `Text (qualifier)` |
| **Date** | Date components (day, month, year) | `Date` or `Date (format)` |
| **Roster** | Open-ended list of entries | `Roster (what is listed)` |
| **Read** | Interviewer reads text, no response expected | `Read` |
| **Filter** | Routing gate, no respondent interaction | `Filter` |

**Disambiguation rules:**

- **Yes/No vs Single select**: Yes/No is strictly binary (yes/no, male/female).
  If there are 3+ options — even Yes / No / Don't know — use Single select.
- **Numeric vs Scale**: Use Scale when the source provides semantic endpoint
  labels (e.g., "Not at all" → "Completely"). Use Numeric for plain number entry
  with or without bounds.
- **Single select vs Multi select**: "Choose one" / "Circle one" → Single select.
  "Mark all that apply" / "Select all" → Multi select.
- **Roster**: Records the *kind* of list (e.g., household members, medications).
  QML mapping for rosters requires separate design — the inventory just captures
  that the source uses one.

### Inventory Entry Format

For each node, record:
1. Sequential number and **original ID** (never rename)
2. Question text (quoted)
3. Input type from the vocabulary above, with response options and codes
4. **GOTO/skip routing for every response option** — including DK/Refusal branches
5. Filter conditions or interviewer notes where present

Example entries:
```
42. Q_SMK_Q01: "At the present time, do you smoke cigarettes daily, occasionally
    or not at all?" — Single select {1: "Daily", 2: "Occasionally",
    3: "Not at all"} — 1 → GO TO Q_SMK_Q02; 2 → GO TO Q_SMK_Q05;
    3 → GO TO Q_SMK_Q10; DK → GO TO Q_SMK_END; R → GO TO Q_SMK_END

9. TFCC_Q01: "I need to confirm your address. Is it ...?" — Yes/No —
    Yes → GO TO IC_R01; No → GO TO TFCC_Q02

36. ANC_Q01: "What is ...'s date of birth?" — Date (day/month/year) —
    GO TO ANC_Q02

38. ANC_Q03: "What is ...'s age?" — Numeric (0–120) — GO TO SEX_Q01

48. ABO_Q02: "Is ... North American Indian, Metis or Inuit? Mark all that
    apply." — Multi select {1: "North American Indian", 2: "Metis",
    3: "Inuit"} — GO TO ED_Q01

A3. "How much do you feel you belong to your local area?" — Scale (0–6):
    "Not at all" to "A great deal" — GO TO A4

27. USU_Q01: "What are the names of all persons who usually live here?" —
    Roster (household members) — GO TO RS_Q02

11. IC_R01: "I'm calling regarding the Labour Force Survey." — Read —
    GO TO LP_Q01

14. LA_N01: "Confirm the listing address." — Filter — If birth →
    GO TO MA_Q01; If subsequent in person → GO TO CMA_Q01;
    If subsequent by telephone → GO TO SD_Q01
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

- The `_ocr.md` text file path (primary source for grep-based verification)
- The completed inventory file path
- Instructions to check the three dimensions below

**Important**: The judgement agent should always work from the `_ocr.md` file, not
the PDF. This ensures grep-based counts are accurate and reproducible.

The judgement agent must NOT have written the inventory — it acts as an independent
reviewer.

### (a) Question Coverage

For each section, count question IDs in the source vs the inventory:
```bash
grep -c "^CCC_Q" SURVEY_NAME_ocr.md    # count source questions in CCC section
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
