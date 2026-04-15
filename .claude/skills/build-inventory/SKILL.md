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

## Step 1: Produce the text intermediate

Do **not** hand-roll OCR with `pdftotext` or `tesseract` yourself. The
repository ships a Python CLI that rasterizes each PDF page with
`pdftoppm` and extracts verbatim text via **Claude Sonnet 4.6 vision on
AWS Bedrock**, with parallel per-page calls and a cached system prompt.
It is the single authoritative preprocessor.

### 1a. First, always check for an existing intermediate

Before running anything, check whether the intermediate already exists:

```bash
ls "$(dirname "$PDF")"/*_text.md 2>/dev/null
```

If a `_text.md` file is already present next to the source PDF, **use
it directly** — skip straight to Step 2. Re-running the preprocessor
when a valid `_text.md` exists wastes Bedrock spend and burns cycles.
Only invoke `askalot-inventory` when the intermediate is missing.

`_text.md` is the single canonical text intermediate. Ignore any other
extension variants that might be sitting next to the PDF — the only
input you work from is `_text.md`.

**Prior inventory iterations:** If a sibling file such as
`<SURVEY>_question_inventory_v2.md` (or any other `_vN.md` variant)
exists alongside the canonical inventory, read it before rebuilding
from scratch. These are almost always fix-up iterations that already
patched issues you would otherwise rediscover, and inheriting from
them saves a full rebuild cycle.

### 1b. Run the preprocessor (only if no intermediate exists)

```bash
uv run askalot-inventory evaluation/<category>/<SURVEY>/source.pdf
```

This writes one artifact next to the source PDF and a copy in the cache:

```
evaluation/<category>/SURVEY_NAME/
  source.pdf                         # Original PDF (kept)
  SURVEY_NAME_text.md                # Claude-vision text extraction (THIS is the text you work from)
  SURVEY_NAME_question_inventory.md  # Inventory (Step 2-3)
  SURVEY_NAME.md                     # Analysis report (later)

~/.cache/askalot_qml/inventory/<sha256>/
  source.sha256
  text.md                            # Authoritative cached copy of SURVEY_NAME_text.md
```

The run is cached by SHA-256 of the source bytes. The first run on a
66-page questionnaire costs ~$1 in Bedrock spend and takes ~30s with the
default `--concurrency 8`. Re-runs on the same file are near-instant —
the cached `text.md` is reused without any Bedrock calls.

**Prerequisites (verify before running):**
- `pdftoppm -v` succeeds (`apt install poppler-utils` if not)
- `aws sts get-caller-identity` returns credentials with
  `bedrock:InvokeModel` permission on
  `us.anthropic.claude-sonnet-4-6`. If the user has not yet run
  `aws sso login`, stop and ask them to do so.
- `AWS_REGION` is set, or pass `--aws-region us-west-2` explicitly.

Useful flags:
- `--max-pages 3` — only extract the first N pages, for quick wiring
  tests before burning budget on a full run.
- `--dpi 200` — higher resolution if text-dense pages come out sparse
  (default 150 is enough for almost every CATI instrument).
- `--concurrency 4` — lower concurrency if you hit Bedrock throttling.
- `--skip-cache` — bypass the cache and re-extract from scratch.

### Work from `_text.md`, never from the PDF

Two reasons:
1. **Agent latency** — large questionnaires (130+ pages) make PDF-level
   reads slow and unreliable.
2. **Searchability** — the extracted markdown is plain UTF-8 text, so
   `grep`, `rg`, line-ranges, and per-section slicing all work normally.

After the intermediate is in place, locate section boundaries from the
markdown directly:

```bash
grep -n "^--- page \|^# \|^## \|SECTION [A-Z]\|_BEG" \
  "$(dirname "$PDF")/SURVEY_NAME_text.md"
```

The extractor emits `--- page N ---` separators between pages and
preserves the source document's textual section headers. Use those as
the primary section boundary signal, and fall back to in-body markers
(`SECTION`, `_BEG`) when the source questionnaire doesn't carry
explicit headings.

### When things go wrong

- **Bedrock throttling** — re-run with `--concurrency 4` (or lower) and
  `--log-level DEBUG` to see per-page timings.
- **Sparse extraction on a dense page** — bump `--dpi 200` or `--dpi 225`
  and re-run with `--skip-cache`.
- **AWS credentials expired** — run `aws sso login` again.
- **boto3 dependency missing** — run `uv sync`.

## Step 2: Per-Section Extraction (Subagents)

For questionnaires with multiple sections/modules, launch **subagents per section** to
build inventory entries in parallel:

1. **Coordinator** reads the full text file, runs the **scope enumeration pass**
   (below), and identifies section boundaries (line ranges)
2. **Subagents** (one per section) each receive:
   - The text file path and their assigned line range
   - The node type reference table (below)
   - The inventory entry format specification (below)
3. Each subagent produces a Markdown fragment for its section
4. **Coordinator** assembles all fragments into `SURVEY_NAME_question_inventory.md`
   with the document header, scope declaration, and verification status section

### Scope enumeration (do this first — it is the contract against silent omissions)

Before spawning any subagents, the coordinator enumerates **every** top-level
unit in the text file: main sections, sub-modules, appendices, alternate-form
questionnaires, teacher/principal/proxy instruments, self-report forms, admin
pages, code sheets, and anything else that carries questions. Produce this
list by scanning headers and table-of-contents markers:

```bash
grep -nE "^(# |## |### |APPENDIX [A-Z]|SECTION [A-Z]|MODULE |PART )" \
  "$(dirname "$PDF")/SURVEY_NAME_text.md"
```

Cross-check the result against any table of contents that appears near the
start of the text file — TOCs often mention modules that don't announce
themselves with consistent headers later on.

**Default: every enumerated unit is IN SCOPE.** Appendices, teacher/principal
questionnaires, proxy forms, and supplementary modules all contain questions
that downstream QML generation needs. Excluding them silently is the single
biggest failure mode of this skill — it happened to the NLSCY conversion,
which lost ~100 items across five appendices because the builder decided
mid-flight that appendices were "out of scope".

If the user has explicitly asked for a narrower scope (e.g. "just the core
questionnaire, skip the teacher form"), or a unit is genuinely not a
questionnaire (e.g. a coding manual, a data dictionary, a list of interviewer
codes with no questions attached), mark it as OUT OF SCOPE — but **record
the exclusion and its reason in the inventory header**:

```markdown
## Scope

| Unit | Pages | Status | Reason |
|---|---:|---|---|
| Main Questionnaire (Sections A–G) | 1–160 | IN | core questionnaire |
| Appendix A: 10–11 year olds self-report | 162–170 | IN | contains 30+ items |
| Appendix C: Teacher questionnaire | 172–212 | IN | TCH-* items |
| Appendix D: Principal questionnaire | 213–228 | IN | OBS-* items |
| Appendix B: Interviewer code sheet | 161 | OUT | not a questionnaire (coding reference only) |
```

The judgement agent (Step 3) uses this table as the ground truth for module
coverage — anything marked IN must have inventory entries, and anything
marked OUT must have a stated reason.

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

**Preserve source annotations verbatim.** Several kinds of parenthetical and
inline markers carry real semantics and must be kept inside the question or
option text:

- **Version markers** such as `***NEW***`, `(new 2023)`, `(retained from 2019)`
  — these tell a future analyst when an item entered or left the instrument.
  BRFSS_2023 MMU.05 ("dab it") and MMU.06 ("use it in some other way") are
  2023 additions flagged this way; an inventory that drops the marker hides
  a version-break.
- **Regional / jurisdiction variants** such as
  `Grade 9–10 (Quebec: Secondary II or lower)` or
  `(Newfoundland and Labrador: 1st year of secondary)` — these are
  interviewer mapping instructions, not stylistic flourishes. Dropping them
  makes the code semantically ambiguous for respondents in those
  jurisdictions.
- **Historical / legacy labels** such as `Inuit (Eskimo)` — the parenthetical
  is the term the questionnaire explicitly preserves for longitudinal data
  alignment. Silently modernising the label breaks comparability across
  waves.
- **Interviewer instructions and administration hints** such as
  `(READ CATEGORIES)`, `(DO NOT READ)`, `(MARK ONE ONLY)`,
  `(PROBE IF NECESSARY)`, `(IF RESPONDENT HESITATES, ADD ...)`,
  "INTERVIEWER: confirm the address before proceeding",
  "Ask only if respondent is over 18", "Do not read aloud unless asked",
  consistency checks like "If Q5 > Q4, probe and correct", and any
  other verbal guidance from the source. **Keep all of these.** They are
  not cosmetic — they are the raw material for precondition and
  postcondition generation downstream. A hint like "Ask only if
  respondent is over 18" becomes a precondition on the item; a consistency
  check like "If Q5 > Q4, probe" becomes a postcondition; a
  `(DO NOT READ)` on response option 99 tells the QML generator the
  option is interviewer-only and should not appear in the respondent UI.
  Dropping these turns a routable instrument into a flat list of
  unreachable questions.

When in doubt, keep the annotation. The cost of an extra parenthetical is
zero; the cost of a silently lost interviewer hint, version marker, or
regional variant is a precondition that never gets written, a
postcondition that never fires, or an analysis bug that surfaces months
later.

**Defend against OCR transcription artifacts.** The `_text.md` file is
usually very clean, but vision-model extraction occasionally produces
typos in question IDs or routing targets (e.g. `EMPPRE-J1-Q7E` where every
neighbouring item in the same section uses the dotted form `EMPPRE-J1.Q7B`).
When an ID in a GOTO target doesn't match the canonical pattern used
elsewhere in the same section, and no such ID is defined anywhere in the
text file, treat it as a transcription artifact: verify against
neighbouring items, use the canonical form, and leave a short note in the
inventory entry so a reviewer can audit the decision. Do not blindly copy
a malformed ID into the inventory and do not silently drop the routing —
both make the inventory worse than the text it was built from.

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

- The `_text.md` intermediate file path (primary source for grep-based verification)
- The completed inventory file path
- Instructions to run the five checks below (module coverage, question
  coverage, routing coverage, node type coverage, annotation preservation)

**Important**: The judgement agent should always work from the `_text.md`
file, not the PDF. This ensures grep-based counts are accurate and reproducible.

The judgement agent must NOT have written the inventory — it acts as an independent
reviewer.

### (a) Module Coverage (gate — run this first)

Before counting IDs inside sections, verify that **every enumerated unit is
represented**. This is the single most important check, because the most
expensive failure mode of this skill is silently dropping an entire module
or appendix — not losing individual items within a module that is otherwise
present. Counting IDs inside a section that was never extracted will not
flag the gap.

Build a module manifest from the source and compare it to the inventory:

```bash
# 1. What does the text file contain?
grep -nE "^(# |## |### |APPENDIX [A-Z]|SECTION [A-Z]|MODULE |PART )" \
  "$(dirname "$PDF")/SURVEY_NAME_text.md"

# 2. What does the inventory claim to cover?
grep -nE "^### |^## Section|^## Appendix|^## Module" \
  SURVEY_NAME_question_inventory.md
```

Every unit marked IN SCOPE in the Step 2 scope table must have an
inventory section. If a unit marked IN is missing, flag it immediately and
block — do not proceed to (b) or (c) until the gap is closed. If a unit
is marked OUT, verify the stated reason is sound (the unit really isn't a
questionnaire — it's a coding manual, a data dictionary, an interviewer
code sheet, etc.). Silent exclusions — a unit missing from both IN and OUT
— are never acceptable; the scope table must be exhaustive.

### (b) Question Coverage

For each in-scope section, count question IDs in the source vs the inventory:
```bash
grep -c "^CCC_Q\|CCC_Q" SURVEY_NAME_text.md    # count source questions in CCC section
```

Include appendices, alternate-form sections, child/proxy modules, and age-specific
sub-sections — these are commonly missed.

### (c) Routing Coverage

Count items with GOTO/skip in the source vs items with routing annotations in the
inventory. Every `GO TO`, `IF...GO TO`, and filter checkpoint must appear.

### (d) Node Type Coverage

Verify all three node types are captured (questions, checks/filters, constraints).
The most common omissions:
- Checks/filters: caused entire skip paths to vanish in 4/10 inventories
- Constraints: lost validation rules and derived variables needed for section routing in 6/10 inventories
- DK/Refusal branches: created incomplete routing graphs in 5/10 inventories

### (e) Annotation Preservation

Spot-check a handful of items carrying source annotations (version markers,
regional variants, interviewer instructions, historical labels — see the
"Preserve source annotations verbatim" rule in Step 2) and confirm the
annotations survived into the inventory text. Missing annotations are
usually systematic — if one is dropped, dozens probably are.

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
