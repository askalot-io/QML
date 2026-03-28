---
name: write-analysis
description: >
  Run Z3 formal validation on QML section files and write an analysis report that
  exposes design problems in the original questionnaire. Includes a judgement agent
  that verifies every reported finding actually exists in the source document.
  Trigger on: analysis report, Z3 validation, questionnaire analysis, validation
  report, structural analysis, finding verification.
---

# Write Analysis Report

## Purpose

Run the Z3 SMT solver on the generated QML, interpret the results, and write an
analysis report that exposes design problems in the original questionnaire. Every
finding in the report must be grounded in the source document — the judgement agent
ensures no hallucinated problems make it into the final report.

## Input

- Section QML files at `evaluation/<category>/SURVEY_NAME/NN_section_name.qml`
- The question inventory at `evaluation/<category>/SURVEY_NAME/SURVEY_NAME_question_inventory.md`
- The source text file or PDF

## Output

An analysis report at `evaluation/<category>/SURVEY_NAME/SURVEY_NAME.md`.

---

## Step 1: Run Z3 Validator

Run the validator on each section file:

```bash
cd /root/QML && \
uv run python .claude/skills/generate-qml/scripts/validate_qml.py \
  evaluation/<category>/SURVEY_NAME/NN_section.qml --level 2 --json
```

The validator runs four formal verification steps:

1. **Per-item classification** — W_i = B AND P_i AND NOT Q_i
   Classifies reachability (ALWAYS/CONDITIONAL/NEVER) and postcondition invariant
   (TAUTOLOGICAL/CONSTRAINING/INFEASIBLE/NONE).
2. **Global satisfiability** — F = B AND conjunction(P_i => Q_i)
   Checks at least one valid completion exists. UNSAT = no valid path.
3. **Dependency loops** — Kahn's algorithm with cycle detection
4. **Path-based reachability** — accumulated predecessor postconditions detect dead code

Exit code 0 = valid, 1 = issues found, 2 = error.

Also run without `--json` to get human-readable output for the report.

Collect results from all section files: item counts, classifications, cycles, issues.
Produce aggregate statistics across all sections.

## Step 2: Draft the Report

Write the report as `SURVEY_NAME.md` following this structure:

```markdown
# Survey Title: Declarative Conversion Analysis

**Source:** Organization, Survey Name, N pages
**QML Files:** `evaluation/<category>/SURVEY_NAME/`
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

## Semantic Equivalence

| Metric | Count |
|--------|-------|
| PDF questions (substantive) | {N} |
| QML items | {M} |
| Matched | {X} |
| Justified omissions | {Z} |

{List each justified omission with its reason}

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
| 01 | `01_demographics.qml` | b_demographics | N | — | age, sex |
| 02 | `02_health.qml` | b_health | N | age, sex | health_flag |
| ... | ... | ... | ... | ... | ... |

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

## Step 3: Judgement Agent — Verify Findings

After drafting the report, launch a **judgement subagent** that independently verifies
every problem cited in the report actually exists in the original questionnaire. The
judgement agent receives:

- The draft report file path
- The source text file or PDF path
- The inventory file path
- All section QML file paths

The judgement agent must NOT have written the report — it acts as an independent reviewer.

### What the Judgement Agent Checks

For each problem (P1, P2, ...) in the report:

1. **Evidence exists:** The cited PDF page numbers and question IDs actually contain
   what the report claims. Read the source at those locations and verify.

2. **Problem is real:** The described issue (unreachable item, contradictory logic,
   missing gate, etc.) is a genuine property of the original questionnaire, not an
   artifact introduced during QML conversion.

3. **Severity is proportionate:** HIGH should be reserved for problems that would
   cause data loss or make questions permanently unreachable. MEDIUM for logic gaps
   that affect subsets of respondents. LOW for ambiguities or redundancies.

4. **No hallucinated findings:** If a problem cannot be confirmed in the source,
   flag it for removal from the report.

### Judgement Agent Output

The judgement agent produces a verification table:

```markdown
| Problem | Verdict | Notes |
|---------|---------|-------|
| P1: [title] | CONFIRMED | Evidence verified at page X, question Y |
| P2: [title] | DOWNGRADE to LOW | Issue exists but affects edge case only |
| P3: [title] | REMOVE | Cannot reproduce in source — conversion artifact |
```

### After Judgement

The coordinator updates the report based on the judgement agent's verdicts:
- CONFIRMED problems stay as-is
- DOWNGRADED problems get their severity adjusted
- REMOVED problems are deleted from the Problems section (move to Cross-Check Fixes
  if they reveal a conversion mistake, otherwise drop entirely)

### Gate Condition

**The report is final when every problem in it has been CONFIRMED by the judgement agent.**
