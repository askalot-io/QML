---
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent, WebSearch, WebFetch
description: Convert a PDF questionnaire to QML and produce a validation analysis report
---

# Evaluate Questionnaire

Evaluate the questionnaire at `$ARGUMENTS` by running the three-phase pipeline:
build inventory, generate QML, write analysis report.

## Input

The argument is a path to either:
- A **PDF file** — starts the full pipeline from scratch
- An **evaluation directory** (e.g., `evaluation/statcan-questionnaires/SURVEY_NAME/`) — resumes from the appropriate phase based on existing artifacts

If a relative path is given, resolve it relative to the working directory.

## Phase Detection

Before starting, check what artifacts already exist in the evaluation directory to
determine which phase to resume from:

1. **Check for the QML file** (`SURVEY_NAME.qml` in the directory):
   - If the QML file exists → first re-run the validator on it
     (`.claude/skills/generate-qml/scripts/validate_qml.py`). If it reports
     error-severity issues (undefined names, unreachable items, infeasible
     postconditions), fix the QML per the `inventory-to-qml` skill before
     anything else. Once it exits 0 → resume from **Phase 3: Write Analysis Report**
   - Read the `write-analysis` skill and proceed to report generation
   - Note: if a directory still contains multiple `NN_section_name.qml` files
     from the retired multi-file pipeline, merge them into one
     `SURVEY_NAME.qml` first (see "Merging legacy multi-file questionnaires"
     in the `generate-qml` skill), then validate

2. **Check for question inventory** (`*_question_inventory.md` in the directory):
   - If inventory exists with `READY FOR QML` status → resume from **Phase 2: Inventory to QML**
   - If inventory exists but status is not `READY FOR QML` → re-run the judgement agent from `build-inventory` to verify, then proceed
   - Read the `inventory-to-qml` skill and proceed

3. **No artifacts found** (or input is a PDF file):
   - Check for an existing text intermediate next to the source:
     `<stem>_text.md` (current), `<stem>_docling.md` (legacy, Docling),
     `<stem>_ocr.md` (legacy, pdftotext). If `_text.md` exists, reuse it
     directly. Otherwise start from **Phase 1: Build Inventory** which
     regenerates `_text.md` via Claude vision on Bedrock.
   - Read the `build-inventory` skill and proceed from the beginning

Report which phase you are starting from and why.

## Phase 1: Build Inventory

**Skill:** `.claude/skills/build-inventory/SKILL.md`

Read the PDF, extract all questions/routing into a structured inventory, and run the
judgement agent to verify completeness. Gate: Verification Status shows `READY FOR QML`.

## Phase 2: Inventory to QML

**Skill:** `.claude/skills/inventory-to-qml/SKILL.md`

Also read the QML language references:
- `.claude/skills/generate-qml/SKILL.md`
- `.claude/skills/generate-qml/references/qml-full-reference.md`
- `.claude/skills/generate-qml/references/goto-conversion-guide.md`

Convert the inventory into a single `SURVEY_NAME.qml` file (the survey's original
sections become ordered blocks inside it), validate it with Z3, and run the
judgement agent to verify fidelity. A questionnaire is never split across multiple
QML files. Gate: 0 unjustified missing items, validator exit code 0 (formal
hierarchy AND lint channel — zero undefined names, zero frozen-variable
unreachable items), every External input from the inventory materialized as a
preamble admin question, every remaining warning explained.

## Phase 3: Write Analysis Report

**Skill:** `.claude/skills/write-analysis/SKILL.md`

Run Z3 validation, draft the report, and run the judgement agent to verify every
finding exists in the original questionnaire. Gate: all problems confirmed by
judgement agent.

## Output

All artifacts go in `evaluation/<category>/SURVEY_NAME/`:

| Artifact | File | Phase |
|----------|------|-------|
| Question inventory | `SURVEY_NAME_question_inventory.md` | 1 |
| QML file | `SURVEY_NAME.qml` | 2 |
| Analysis report | `SURVEY_NAME.md` | 3 |

## Phase 4: Process Feedback Report

After all phases complete, write a **Process Feedback Report** to the user (not to a
file — output it directly). This is a reflective assessment of how the pipeline
performed on this specific questionnaire.

**Context**: Every questionnaire is different. Some were designed 20+ years ago with
entirely different methodological assumptions — paper-first CATI instruments with
imperative GOTO routing, no cross-validation, interviewer-dependent error handling.
Modern survey methodology emphasizes declarative logic, built-in consistency checks,
respondent-adaptive flows, and formal verifiability. Our goal is to bridge that gap:
turn any questionnaire — regardless of era or design philosophy — into a modern,
declarative QML specification with postcondition-based cross-checks that make the
instrument more error-resistant than the original.

Be honest and specific — vague praise is not useful. Ground your observations in
survey methodology research where applicable.

### Research step

Before writing the report, use **WebSearch** to look up relevant scientific literature
on the specific challenges you encountered during this conversion. Search for:
- Survey methodology papers addressing the particular design patterns you found
  (e.g., complex skip logic, roster-based loops, dependent interviewer instructions)
- Best practices for the questionnaire's domain (health surveys, labour force,
  household spending, etc.)
- Known critiques or improvements for the specific survey program if it is a
  well-known instrument (e.g., BRFSS, DHS, CCHS, ESS)
- Academic work on questionnaire formalization, declarative survey specification,
  or computer-assisted survey design validation

Cite specific papers, books, or standards where they inform your recommendations.
If you cannot find relevant literature for a point, say so — do not fabricate
citations.

### Report sections

Address each of these areas:

#### 1. Questionnaire era and design philosophy
Characterize the original questionnaire: when was it designed, what paradigm does it
follow (paper PAPI, CATI, CAPI, web-first), what assumptions does it make about the
interviewing process? How does this context explain the design patterns you encountered?

#### 2. What went well
Which phases produced good results on the first pass? Where did the QML language
handle the questionnaire's constructs naturally? What patterns from this era translated
cleanly into declarative form?

#### 3. Imperative-to-declarative translation challenges
What GOTO patterns, interviewer instructions, or procedural logic was hardest to
convert into precondition/postcondition form? Were there constructs that have no clean
declarative equivalent? How does the survey methodology literature address these
patterns — are there known better formulations?

#### 4. QML language gaps
Were there questionnaire constructs that QML cannot express, or that required awkward
workarounds? Suggest concrete language enhancements, grounded in what the literature
says about survey specification languages (e.g., DDI, Triple-S, Blaise).

#### 5. Cross-check and postcondition opportunities
Where did adding postconditions catch real design flaws in the original? Where could
additional cross-checks improve data quality beyond what the original instrument
provided? Reference data quality literature where applicable.

#### 6. Pipeline step coverage
Were there aspects of the questionnaire that fell through the cracks between phases?
Would additional intermediate steps (e.g., a routing-graph normalization pass, a
domain-specific validation step) improve output quality?

#### 7. Checkpoint adequacy
Were the existing gates sufficient? Were there points where an earlier check would
have caught a problem sooner? Should we introduce validation between sub-phases?

#### 8. Hard decisions and ambiguities
Flag any points where you had to make a judgement call without clear guidance. What
assumptions did you make? Where would clarification about the QML language, the
pipeline goals, or the questionnaire domain have helped?

#### 9. Suggested improvements
Concrete, actionable recommendations for improving:
- The `/evaluate-questionnaire` command and its skills
- The QML language itself
- The Z3 validation approach
- The overall methodology for modernizing legacy questionnaires

Prioritize by impact. Reference literature where it supports a recommendation.

## Existing Evaluation Corpus

The `evaluation/` directory contains **12 completed conversions** (inventory + QML +
analysis report), all large national instruments:

- `census-demographics/` — ACS_2025, LFS_Labour_Force, SHS_2000_Household_Spending, SLID_Labour_Income
- `medical-health/` — BRFSS_2023, CCHS_2005_Health, NPHS_Population_Health, PALS_Activity_Limitation
- `sociology/` — ESS12, GSS_Time_Use, NLSCY_Children_Youth
- `education-psychology/` — SAEP_Education_Planning

Use these as reference for format, depth, and problem categorization —
`SLID_Labour_Income` is the reference conversion (preamble block for external
inputs, state-variable contract comments, relational postconditions).

The remaining domain folders (`compliance-risk/`, `safety-critical/`,
`legal-regulatory/`, `infrastructure-inspection/`, `market-research/`,
`format-samples/`) hold extracted sources (`_text.md`) or raw platform exports with
NO conversions yet — a `_text.md` there means Phase 1 can start from the existing
intermediate. Do not cite them as completed conversions.
