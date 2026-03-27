# NLSCY Children and Youth Survey: Declarative Conversion Analysis

**Source:** Statistics Canada, National Longitudinal Survey of Children and Youth (NLSCY), Cycle 1, 1994-95, Catalogue no. 89F0077XIE, 161 pages
**QML File:** `evaluation/statcan-questionnaires/NLSCY_Children_Youth/NLSCY_Children_Youth.qml`
**Date:** 2026-03-27 (revised)

## Objective

Transform the NLSCY CAPI questionnaire (161 pages, ~843 question nodes across 25 sections with complex age-tiered routing for children aged 0-11) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. PDF extraction to text file using `pdftotext -layout -nodiag`
2. Question inventory: 843 nodes catalogued across 24 sections (Household, General Questionnaire, Parent Questionnaire, Children's Questionnaire)
3. Inventory verification: cross-referenced against source text with coverage table per section
4. Declarative QML conversion using parallel subagents per block group
5. Formal validation using the Askalot Z3 QML validator at all 4 levels

## Survey Architecture Overview

The NLSCY questionnaire has three major parts and uses **child age** (0-11 years) as the primary routing variable, with **child age in months** (0-47) for the Motor and Social Development section.

### Part 1: General Questionnaire (adults 15+)

| Section | Pages | Items | Purpose |
|---------|-------|-------|---------|
| Household Record | 3-8 | 23 | Contact, demographics, dwelling |
| Restriction of Activities | 9-10 | 3 | Health limitations (age 12+) |
| Chronic Conditions | 11-12 | 6 | Long-term health conditions |
| Socio-demographics | 12-14 | 10 | Country of birth, ethnicity, language, religion |
| Education | 15-16 | 8 | Schooling, degrees (age 12+) |
| Labour Force | 17-21 | 31 | Employment, hours, earnings (parents only) |
| Income | 22-24 | 6 | Household and personal income |
| Administration | 25-26 | 2 | Interview mode and language |

### Part 2: Parent Questionnaire (PMK and/or spouse)

| Section | Pages | Items | Purpose |
|---------|-------|-------|---------|
| Adult Health (CHLT) | 29-32 | 26 | General health, smoking, alcohol, maternal history, CES-D depression scale |
| Family Functioning (FNC) | 33-34 | 17 | McMaster FAD-12 family assessment |
| Neighbourhood (SAF) | 35-37 | 21 | Safety, social cohesion, neighbourhood problems |
| Social Support (SUP) | 38-40 | 12 | Personal support network, professional help |

### Part 3: Children's Questionnaire

| Section | Pages | Items | Age Range | Purpose |
|---------|-------|-------|-----------|---------|
| Child Demographics (DVS) | 43 | 3 | All | Relationship, sibling verification |
| Health (HLT) | 44-60 | 85 | All (tiered) | Vision, hearing, speech, mobility, pain, injuries, conditions |
| Medical/Biological (MED) | 61-67 | 42 | 0-3 | Prenatal, birth, postnatal, breastfeeding |
| Temperament (TMP) | 68-83 | 68 | 3-47 months | ICQ temperament scale (age-variant pairs) |
| Education (EDU) | 84-100 | 62 | 4+ | Grade, performance, school quality (province-specific) |
| Literacy (LIT) | 101-104 | 25 | All (tiered) | Reading, writing, homework |
| Activities (ACT) | 105-108 | 28 | All (tiered) | Sports, clubs, TV, chores |
| Behaviour (BEH) | 109-116 | 99 | All (tiered) | Sleep, prosocial, hyperactivity, emotional, conduct |
| Motor/Social Dev (MSD) | 117-121 | 57 | 0-47 months | Developmental milestones (sliding window) |
| Relationships (REL) | 122-124 | 15 | 4+ | Friends, teachers, parents, siblings |
| Parenting (PAR) | 125-129 | 38 | All (tiered) | Praise, discipline, food security, media exposure |
| Custody (CUS) | 130-155 | 118 | All | Family history, separation, custody, contact |
| Child Care (CAR) | 156-161 | 38 | All (tiered) | Care arrangements, changes, summer care |

**Total inventory:** 843 nodes. **QML items:** 362 (compression via QuestionGroups for battery items).

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 362 |
| Blocks | 15 |
| Preconditions | 330 |
| Postconditions | 0 |
| Variables | 66 |
| Dependencies | 637 |
| Connected Components | 29 |
| Cycles | **0** |
| Global Status | **SAT** |
| Dead Code | **0** |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count | Meaning |
|----------------|-------|---------|
| Precondition ALWAYS | 32 | Items shown regardless of child age or respondent type |
| Precondition CONDITIONAL | 330 | Items gated by age, respondent type, or prior responses |
| Precondition NEVER | 0 | No dead code detected |
| Postcondition NONE | 362 | No postcondition constraints defined |

The 32 ALWAYS items are the entry-point demographics (DVS), universal health questions (HLT-Q1 through Q4), and items with no age or respondent gates. All 330 CONDITIONAL items have at least one valid path confirmed by the path-based reachability check.

### Key Structural Finding: No Dependency Cycles

The NLSCY questionnaire has **no dependency cycles** because the primary routing variable (`child_age`) is set once at the beginning and is never modified by downstream items. The age-tiered routing is strictly one-directional: age determines which sections and questions to show, but no downstream answer modifies the age variable. This contrasts with questionnaires like the LFS where the PATH variable creates feedback loops.

## Problems in the Original PDF (Exposed by Declarative Conversion)

### P1: Contradictory Age Boundaries in Health Status Section

**Severity:** HIGH
**PDF evidence:** p44 (HLT NOTE), p44 (HLT-C5), p45 (HLT-C6, HLT-C6A)

**Problem:** The Health section uses **three different, contradictory age boundaries** for the same logical decision (skip to injury questions):

| Gate | Boundary | Effect |
|------|----------|--------|
| HLT NOTE (p44) | "AGE 0-1 YEAR" | Groups ages 0-1 separately from 2-3 |
| HLT-C5 (p44) | "IF AGE < 2" | Excludes age 2+ from skip |
| HLT-C6 (p45) | "IF AGE = 0-3" | Excludes age 4+ from skip |

A 2-year-old passes HLT-C5 (age >= 2, proceeds to Q5) but is then stopped at HLT-C6 (age 0-3, skips to injuries). This means 2-3 year olds get the physical activity question (Q5) but skip the entire Health Status subsection (vision, hearing, speech, mobility). The NOTE confirms this, but the two sequential gates use different thresholds.

Furthermore, HLT-C6A says "IF AGE > 6 → GO TO HLT-Q6A" but the NOTE assigns Q6A (storybook vision) to ages 4-5, not 7+. The GOTO routing and the section NOTE contradict each other on which vision question variant ages 4-5 receive.

**In the imperative version:** The interviewer follows the GOTO at C6A without noticing the NOTE conflict.

**In the declarative version:** The QML forces explicit preconditions: `child_age >= 4 and child_age <= 5` for Q6A and `child_age >= 6` for Q6. The Z3 solver confirms both are reachable with non-overlapping ranges, but the mapping decision had to be made manually — the PDF doesn't give a consistent answer.

### P2: Motor and Social Development Sliding Window — Impedance Mismatch with Declarative Model

**Severity:** HIGH
**PDF evidence:** p117 (MSD age bands)

**Problem:** The MSD section uses 8 overlapping age bands where each band starts at a different entry question and ends at a different exit question:

| Band | Months | Questions | Overlap with next band |
|------|--------|-----------|----------------------|
| 0-3m | Q1-Q15 | 15 items | Q8-Q15 shared with 4-6m |
| 4-6m | Q8-Q22 | 15 items | Q12-Q22 shared with 7-9m |
| 7-9m | Q12-Q26 | 15 items | Q18-Q26 shared with 10-12m |
| ... | ... | ... | ... |

Question MSD-Q22 ("Has he/she ever waved good-bye?") is asked across **four** age bands (4-6m, 7-9m, 10-12m, 13-15m). In the imperative version, each band has a single GOTO entry point and hard exit. In the declarative version, this must be expressed as `child_age_months >= 4 and child_age_months <= 15`.

**The structural problem:** The sliding window design means the same milestone question can be reached through multiple entry points. The GOTO-based exit points (`MSD-C23: IF AGE IN MONTHS = 4 TO 6 → GO TO RELATIONSHIPS`) create different path lengths for different ages. A 5-month-old stops at Q22; a 10-month-old continues to Q32. The declarative version requires computing the union of all age bands that include each question — a transformation that is not needed in the imperative model.

This design pattern is **inherently imperative** and reveals that the MSD section was designed as a sliding window state machine, not a constraint system.

### P3: Behaviour Section Age Gate Inconsistency — Months vs Years

**Severity:** MEDIUM
**PDF evidence:** p109 (BEH NOTE), p110 (BEH-C5)

**Problem:** The NOTE uses "AGE 0-11 MONTHS" (month-based) but BEH-C5 uses "IF AGE < 1" (year-based). For a child exactly at the 12-month boundary, these criteria could diverge depending on how age is recorded (truncated vs rounded).

The NOTE lists "AGE 1 YEAR" as getting Q1-Q5, confirming age 1 should get Q5 (new foods reaction), not Q5A (difficult to feed). But the transition between "0-11 MONTHS" and "1 YEAR" depends on the age recording precision — a systemic ambiguity in a survey where developmental milestones change rapidly.

### P4: Custody Section — Dead Conditional Branch in CUS-C1A

**Severity:** MEDIUM
**PDF evidence:** p130 (CUS-C1A)

**Problem:** CUS-C1A has a 4-way conditional where the first condition ("IF ELDEST SELECTED CHILD AND CUS-Q1A = YES → GO TO CUS-Q1D") and the third condition ("ELSE IF CUS-Q1A = YES → GO TO CUS-Q1D") both route to the same target when CUS-Q1A = YES. Since the third is an ELSE-IF (only reached when the first fails), the first condition is redundant — the third catches all CUS-Q1A=YES cases that the first misses. Removing the first condition would not change the routing.

### P5: Custody Section — Phantom Variable References in CUS-C10

**Severity:** MEDIUM
**PDF evidence:** p141 (CUS-Q9A), p142 (CUS-Q9B, CUS-C10)

**Problem:** CUS-C10 references both CUS-Q9A and CUS-Q9B with compound logic, but these two questions are on **mutually exclusive paths**. Q9A is asked when the child's parents lived together at birth; Q9B is asked when they did not. The condition "CUS-Q9A OR CUS-Q9B = 3" assumes both could have values simultaneously, which is impossible in a single interview.

**In the declarative version:** The QML uses separate flag variables (`parent_died_mother`, `parent_died_father`, `both_parents_died`) set by whichever death question is reached, avoiding the phantom reference.

### P6: Asymmetric REFUSAL Routing Across Sections

**Severity:** LOW
**PDF evidence:** Throughout (FNC p33, SUP p38, SAF p35, PAR p125, CUS p130, BEH p109)

**Problem:** REFUSAL responses are routed inconsistently:

| Section | REFUSAL effect |
|---------|---------------|
| Family Functioning (FNC) | Skips **entire section** |
| Social Support (SUP) | Skips to second subsection only |
| Neighbourhood (SAF) | Skips entire section |
| Parenting (PAR) | Skips to Custody section |
| Custody (CUS) | Skips to Child Care section |
| Behaviour (BEH) | Skips within section |

A single REFUSAL at FNC-Q1A (one of 12 family functioning items) causes the entire 12-item battery plus the marital satisfaction question to be skipped. But in SUP, a REFUSAL at SUP-Q1A only skips to SUP-Q2A (preserving the professional help subsection).

**In the declarative version:** REFUSAL is not a valid QML response code. These hidden skip paths are invisible to the validator, meaning the inconsistent treatment of refusals cannot be formally verified.

### P7: Literacy Section — Conditional Path Contradicts Section NOTE

**Severity:** MEDIUM
**PDF evidence:** p101 (LIT NOTE), p102 (LIT-Q6A, LIT-C7A)

**Problem:** The NOTE states: "AGE 5 YEARS: LIT-Q1 - Q3; LIT-Q6A - Q7A; LIT-Q8; LIT-Q12 - Q14" — implying Q7A is always asked for age 5.

But the actual routing makes Q7A **conditional on Q6A**: if Q6A = NO ("never read aloud to child regularly"), the child skips Q7A entirely and goes to Q8. The NOTE lists Q7A as unconditional for age 5, but the routing makes it depend on Q6A.

### P8: Province-Specific Grade Questions — Structural Redundancy

**Severity:** LOW
**PDF evidence:** pp84-100 (EDU section)

**Problem:** The Education section maintains **6 province-specific variants** of three questions (current grade, skipped grade, repeated grade):

| Question | Variants | Reason |
|----------|----------|--------|
| Grade level | Q1, Q1A-Q1E | Different grade naming (NF: "Level 1 Secondary", QC: "Secondary I", ON: "OAC Grade 13") |
| Skipped grade | Q5, Q5A-Q5E | Same province-specific names |
| Repeated grade | Q7, Q7A-Q7E | Same province-specific names |

This creates **18 question variants** (6 provinces x 3 questions) where the underlying data is identical — an ordinal grade number. The province variants exist solely because grade naming conventions differ across Canadian provinces, not because the data collected differs.

**In the declarative version:** The QML models these with mutually exclusive preconditions on `province`, making the 6-way duplication explicit. The Z3 solver confirms all variants are CONDITIONAL with non-overlapping province ranges, but the structural waste (18 items instead of 3 + a lookup table) is visible.

### P9: Temperament Section — 16 Age-Variant Question Pairs with Subtle Wording Differences

**Severity:** LOW
**PDF evidence:** pp68-83 (TMP section)

**Problem:** The Temperament section has **16 question pairs** (e.g., TMP-Q2/Q2A, Q4/Q4A, Q8/Q8A/Q8B) where the same developmental construct is measured but with age-appropriate wording:

- Q8 (< 1 year): "when he/she gets upset (e.g., before feeding, during diapering)"
- Q8A (1-2 years): "when he/she gets upset" (drops examples)
- Q8B (3 years): "when he/she gets upset" (changes "cry and fuss" to "cry and whine")

These create 53 items from 33 underlying constructs. In the imperative version, the GOTO routing automatically selects the age-appropriate variant. In the declarative version, each variant requires explicit mutually exclusive preconditions on `child_age_months`, making the 16 pairs visible as redundant measurement of the same construct.

## Cross-Check Fixes (QML Authoring Errors)

| # | Item(s) | Error | Fix | Source |
|---|---------|-------|-----|--------|
| 1 | HLT vision items | HLT-C6A routing direction ambiguity (NOTE says ages 4-5 get Q6A, but GOTO sends ages 7+ to Q6A) | Used NOTE interpretation: Q6A for ages 4-5 (storybook), Q6 for ages 6+ (newsprint) | p44-45 |
| 2 | MSD sliding window | Each question appeared in multiple age bands requiring union-of-bands preconditions | Computed minimum and maximum month ranges across all bands for each question | p117 |
| 3 | BEH battery compression | 48 behaviour items (Q6A-Q6UU) had identical 3-point scale | Compressed to QuestionGroup with 48 sub-questions | p110-114 |
| 4 | CUS routing complexity | CUS-C1A/C1B/C1D/C1E elder-child/sibling shortcuts not fully modeled | Simplified to run full custody path for all respondents; noted as limitation | p130 |
| 5 | Province routing | 6 province variants per grade question (EDU) | Modeled with mutually exclusive preconditions on `province` variable | pp84-100 |

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Age gate contradictions** | Hidden by sequential GOTO — interviewer follows routing without seeing NOTE conflicts | Forced into explicit preconditions — must resolve NOTE vs GOTO conflicts |
| **Sliding window (MSD)** | Each age band has a single GOTO entry point — overlap is implicit | Must compute union of all bands for each question — overlap explicit |
| **Unit inconsistency (BEH)** | Years vs months used interchangeably in routing | Forces choice of single unit in preconditions |
| **Dead conditionals (CUS)** | Multi-way IFs with redundant conditions execute correctly but contain dead logic | Z3 can detect when conditions are subsumed |
| **REFUSAL asymmetry** | Each REFUSAL has its own GOTO target — inconsistency spread across 161 pages | Refusals outside QML model — asymmetry invisible but also unverifiable |
| **Province variants (EDU)** | 6 province-specific GOTO paths — duplication hidden by separate pages | 6-way precondition branching makes duplication explicit |
| **Age-variant pairs (TMP)** | Automatic variant selection via GOTO | Requires explicit mutually exclusive preconditions — 16 pairs visible |
| **Inventory completeness** | 843 nodes across 25 sections — no way to verify coverage without page-by-page review | Automated coverage table verifies against source text |

## Conclusion

The Z3 QML validator found the NLSCY questionnaire to be **structurally valid** with no dependency cycles (0 cycles), no unreachable items (0 NEVER), no dead code (0 path-based dead items), and at least one valid completion path (SAT). The 362-item QML representation covers 15 blocks spanning the full children's questionnaire, parent questionnaire, and key general questionnaire sections.

The declarative conversion exposed **9 categories of design issues** in the original 161-page CAPI questionnaire:

1. **P1 (HIGH):** Age boundary contradictions in the Health section — NOTE, HLT-C5, and HLT-C6 use three different age thresholds for the same skip logic; HLT-C6A routing contradicts the NOTE on which vision variant ages 4-5 receive
2. **P2 (HIGH):** MSD sliding window design is inherently imperative — 8 overlapping age bands with shared questions cannot be cleanly expressed as declarative constraints
3. **P3 (MEDIUM):** Behaviour section uses months in NOTE but years in routing for the same gate
4. **P4 (MEDIUM):** Dead conditional branch in CUS-C1A — first condition is subsumed by third
5. **P5 (MEDIUM):** CUS-C10 references questions on mutually exclusive paths as if both could have values
6. **P6 (LOW):** REFUSAL routing is asymmetric — some sections skip entirely, others only partially
7. **P7 (MEDIUM):** Literacy section NOTE lists Q7A as always asked for age 5, but routing makes it conditional
8. **P8 (LOW):** Province-specific grade questions create 18 variants where 3 + a lookup table would suffice
9. **P9 (LOW):** 16 temperament age-variant pairs measure the same constructs with minor wording differences

The NLSCY's structural soundness (no cycles, no dead code) stems from its use of **child age as a one-directional routing variable** — set once and never modified downstream. This is a strong design pattern that avoids the feedback loops found in employment-based surveys (e.g., LFS PATH variable). However, the age-tiered design creates substantial structural redundancy (province variants, temperament age pairs, MSD sliding window) that is invisible in the imperative format but becomes explicit in declarative form.
