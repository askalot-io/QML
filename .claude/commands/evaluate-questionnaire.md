---
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent
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

1. **Check for QML section files** (`*.qml` in the directory):
   - If QML files exist → resume from **Phase 3: Write Analysis Report**
   - Read the `write-analysis` skill and proceed directly to report generation

2. **Check for question inventory** (`*_question_inventory.md` in the directory):
   - If inventory exists with `READY FOR QML` status → resume from **Phase 2: Inventory to QML**
   - If inventory exists but status is not `READY FOR QML` → re-run the judgement agent from `build-inventory` to verify, then proceed
   - Read the `inventory-to-qml` skill and proceed

3. **No artifacts found** (or input is a PDF file):
   - Start from **Phase 1: Build Inventory**
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

Convert the inventory into per-section QML files, validate each with Z3, and run the
judgement agent to verify fidelity. Gate: 0 unjustified missing items, all sections
pass validation.

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
| Section QML files | `NN_section_name.qml` | 2 |
| Analysis report | `SURVEY_NAME.md` | 3 |

## Existing Evaluation Corpus

The `evaluation/` directory contains 18 completed conversions for reference:

- `ICS-hun/` — Hungarian emergency dispatch protocol
- `reference-questionnaires/` — International surveys (ACS, BRFSS, DHS-8, ESS)
- `statcan-questionnaires/` — 10 Statistics Canada CATI questionnaires

Use these as reference for format, depth, and problem categorization.
