# PALS 2001 (Children under 15): Declarative Conversion Analysis

**Source:** Statistics Canada, Participation and Activity Limitation Survey -- 2001 (Children -- under 15), FORM 03, 57 pages
**QML Files:** `evaluation/statcan-questionnaires/PALS_Activity_Limitation/` (9 section files)
**Date:** 2026-03-29

## Objective

Transform the PALS 2001 Children questionnaire (57 pages, 267 nodes across 9 sections plus follow-up, GOTO-based interviewer-administered paper survey with an external Profile Sheet tracking device) into a declarative QML representation consisting of 9 standalone section files, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. **PDF preprocessing**: Extracted text with `pdftotext -layout -nodiag`. The survey is a paper-based interviewer-administered instrument (PAPI) collected under the authority of the Statistics Act, Statutes of Canada, 1985, Chapter S19. Section boundaries identified via heading patterns (SECTION A through SECTION I) and question ID prefixes (A1, B1, C1, etc.).
2. **Question inventory**: 267 nodes catalogued across 9 sections plus a follow-up contact item, with full routing annotations including Profile Sheet checkbox operations. Judgement agent verified coverage: 10/10 sections, 0 missing items, 134/148 GOTO annotations captured (14 absorbed into filter node descriptions). One routing bug found and fixed (E2 routing). Status: READY FOR QML.
3. **Declarative QML conversion**: Per-section standalone QML files generated. Each section file is independently validatable with its own `qmlVersion` and `codeInit`. The critical Profile Sheet mechanism was modeled using 24 flag variables (9 limitation flags, 7 USE-aid flags, 7 NEED-aid flags, plus an aggregate limitation counter). Cross-section variables (`child_under_5`, `limitation_general`) declared as extern annotations.
4. **Formal validation**: Z3 SMT solver run on all 9 section files independently. All sections pass all four validation levels (per-item classification, global satisfiability, cycle detection, path-based reachability).

## Survey Architecture Overview

The PALS 2001 (Children) questionnaire surveys the activity limitations and participation barriers of Canadian children under 15 with disabilities. It was conducted as a post-censal survey following the 2001 Census. The survey uses two primary routing mechanisms: a **date-of-birth age gate** (born after May 15, 1996 = under age 5) and a **Profile Sheet** (an external administrative tracking device where the interviewer marks limitation and aid-use checkboxes throughout Section B).

### Section Structure

| Section | Pages | Items | Purpose |
|---------|-------|-------|---------|
| A -- Filter Questions | 1-2 | 4 | Activity difficulty and limitation screening |
| B -- Activity Limitations | 2-21 | 110 | Hearing, seeing, communication, walking, hands/fingers, learning, developmental, emotional/psychological, chronic conditions, diagnosis/cause, health, medications, health professionals, aids/costs |
| C -- Help with Everyday Activities | 22-26 | 29 | Personal care, mobility help, housework, care coordination, work impact |
| D -- Child Care | 26-27 | 8 | Child care arrangements, refusals |
| E -- Education | 28-38 | 39 | School attendance, grade level (province-specific), special education, school accommodations, aids, assessment |
| F -- Leisure and Recreation | 39-44 | 38 | Activity frequency/hours, summer camp, barriers, computer/Internet use |
| G -- Home Accommodation | 45-46 | 11 | Special features entering/leaving and inside residence |
| H -- Transportation | 47-50 | 17 | Car features, specialized bus, taxi, expenses |
| I -- Economic Characteristics | 50-52 | 10 | Insurance, tax credits, household income |
| Follow-up | 52 | 1 | Re-contact permission |

**Age gate coverage**: Sections E, F, G, and H are skipped entirely for children under 5. Within Section B, the age gate appears at 7 filter points (B6.edit, B13.edit, B15.edit, B16.edit, B51.edit, B53.edit, B87.edit) to skip aids subsections for under-5 children. Section C applies the age gate to personal care questions (C1-C11). Section D applies it at exit (D8.edit) to route under-5 children directly to Section I.

## Semantic Equivalence

| Metric | Count |
|--------|-------|
| Source questions (substantive) | 223 |
| QML items | 247 |
| Matched | 223 |
| Filter/routing nodes modeled | 22 |
| Justified omissions | 2 |

### Justified Omissions (2 items)

| Category | Items | Reason |
|----------|-------|--------|
| Profile Sheet (administrative) | Profile Sheet tracking checkboxes | External paper device replaced by 24 computed flag variables in `codeInit`; the checkbox tallying function is preserved, but the physical device is not a survey question |
| Follow-up contact details | FU1 address/phone collection fields | Contact information collection (name, address, telephone of alternate contact) is administrative; the Yes/No consent gate is modeled but the data entry fields are not QML questions |

### Additional QML items (24 over source count)

The 247 QML items exceed the 223 source questions by 24 because:
- 22 filter/age-gate nodes (B6.edit, B13.edit, B15.edit, B16.edit, B45.edit, B51.edit, B53.edit, B60.edit, B62.edit, B81.edit, B87.edit, B89.edit, B95.edit, C_AGE.edit, C9.edit, C12.edit, C17.edit, C22.edit, D8.edit, E10.edit, G_AGE.edit, H_AGE.edit) are modeled as Comment items with `codeBlock` or as block-level preconditions rather than separate items
- Frequency+hours paired questions in Section F (F1a/F1a_hrs, F1b/F1b_hrs, etc.) expand the 16 source items into 38 QML items because each frequency question and its conditional hours question become separate QML items
- Profile Sheet checkpoint (B62.edit) is modeled as a Comment item that computes the aggregate limitation count

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Total items | 247 |
| Total blocks | 25 |
| Preconditions | 225 |
| Postconditions | 0 |
| Variables (SSA) | 62 |
| Dependencies | 860 |
| Cycles | **0** |
| Global Status | **SAT** (all 9 sections) |
| Dead Code | **0** |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count | Meaning |
|----------------|-------|---------|
| Precondition ALWAYS | 22 | Items shown regardless of age or prior responses |
| Precondition CONDITIONAL | 225 | Items gated by age, limitation flags, or prior responses |
| Precondition NEVER | 0 | No dead code detected |
| Postcondition CONSTRAINING | 0 | No active filtering postconditions |
| Postcondition INFEASIBLE | 0 | No impossible validation rules |
| Postcondition TAUTOLOGICAL | 0 | No postconditions defined |

**Interpretation**: The 22 ALWAYS items are unconditional entry points in each section: the 4 filter questions (Section A), the first question in each disability subsection (B1, B11, B43, B44, B56, B59), health/medication lead items (B68, B69), and first items in Sections D and I. All 225 CONDITIONAL items have at least one valid path confirmed by the path-based reachability check. The complete absence of postconditions (0 across all 247 items) is a noteworthy property of the original questionnaire -- see P4 below.

### Per-Section Validation

| Section | Items | Blocks | Pre | Post | Vars | Deps | Cycles | Status |
|---------|-------|--------|-----|------|------|------|--------|--------|
| 01_filter_questions | 4 | 1 | 0 | 0 | 1 | 0 | 0 | VALID |
| 02_activity_limitations | 100 | 14 | 95 | 0 | 39 | 684 | 0 | VALID |
| 03_everyday_help | 24 | 4 | 18 | 0 | 6 | 20 | 0 | VALID |
| 04_child_care | 7 | 1 | 5 | 0 | 0 | 6 | 0 | VALID |
| 05_education | 38 | 1 | 38 | 0 | 12 | 76 | 0 | VALID |
| 06_leisure_recreation | 38 | 1 | 38 | 0 | 1 | 48 | 0 | VALID |
| 07_home_accommodation | 10 | 1 | 10 | 0 | 1 | 6 | 0 | VALID |
| 08_transportation | 16 | 1 | 16 | 0 | 1 | 15 | 0 | VALID |
| 09_economic_characteristics | 10 | 1 | 5 | 0 | 1 | 5 | 0 | VALID |

### Key Structural Finding: Section B Dependency Density

Section B (Activity Limitations) accounts for **684 of 860 total dependencies (80%)** across 100 items in 14 blocks. This density arises from the Profile Sheet mechanism: each disability subsection (hearing, seeing, communication, walking, hands/fingers, learning, developmental, emotional/psychological, chronic conditions) writes to limitation and aid-use flag variables that are read by later subsections (B62.edit reads all 10 limitation flags; B89.edit reads all 7 USE-aid flags; B95.edit reads all 7 NEED-aid flags). The Z3 solver confirms the entire dependency graph is acyclic because all flag variables flow strictly forward through the subsection order.

## Section Files

| # | File | Block(s) | Items | Variables Read | Variables Written |
|---|------|----------|-------|----------------|-------------------|
| 01 | `01_filter_questions.qml` | b_filter_questions | 4 | -- | limitation_general |
| 02 | `02_activity_limitations.qml` | 14 blocks (hearing, vision, communication, walking, hands, learning, developmental, emotional, chronic, profile_check, diagnosis, health_meds, health_prof, aids_costs) | 100 | limitation_general, child_under_5 | limitation_hearing, limitation_seeing, limitation_communicating, limitation_walking, limitation_hands, limitation_learning, limitation_developmental, limitation_emotional, limitation_chronic, use_aid_hearing through use_aid_chronic, need_aid_hearing through need_aid_chronic, limitation_count, use_aid_count, need_aid_count |
| 03 | `03_everyday_help.qml` | 4 blocks (personal_mobility, family_help, care_coordination, work_impact) | 24 | child_under_5 | c9_any_yes, c12_any_yes, c17_any_yes, c22_any_yes, c15_dk |
| 04 | `04_child_care.qml` | b_child_care | 7 | -- | -- |
| 05 | `05_education.qml` | b_education | 38 | child_under_5 | e1_path, e4_ever_school, e6_special_school, e7_class_type, e8_ever_special, e13_province, is_kindergarten, e25_used_features, e27_needed_features, e30_unmet_aids, e37_assessment |
| 06 | `06_leisure_recreation.qml` | b_leisure_recreation | 38 | child_under_5 | -- |
| 07 | `07_home_accommodation.qml` | b_home_accommodation | 10 | child_under_5 | -- |
| 08 | `08_transportation.qml` | b_transportation | 16 | child_under_5 | -- |
| 09 | `09_economic_characteristics.qml` | b_economic | 10 | -- | dk_i9 |

## Problems in the Original Questionnaire (Exposed by Declarative Conversion)

### P1: Profile Sheet -- External Administrative Device as Critical Routing Logic

**Severity:** HIGH
**PDF evidence:** pp. 1-21, Profile Sheet instructions appear at A1, A2A, A2B, A2C (p. 1-2), B2 (p. 3), B4 (p. 3), B6 (p. 4), B8 (p. 4), B17 (p. 5), B19 (p. 5), B21 (p. 6), B22 (p. 6), B27 (p. 7), B29 (p. 7), B31 (p. 8), B33 (p. 8), B35 (p. 8), B37 (p. 9), B39 (p. 9), B41 (p. 9), B43 (p. 10), B44 (p. 10), B47 (p. 11), B49 (p. 11), B53 (p. 12), B57 (p. 13), B60 (p. 13), B62.edit (p. 15), B87 (p. 20), B89.edit (p. 20), B93 (p. 21), B95.edit (p. 21)

**Problem:** The questionnaire depends on a Profile Sheet -- a separate physical document that the interviewer must maintain alongside the questionnaire form. Throughout Section B (approximately 60 questions), the interviewer is instructed to "Check box [Category] -- Limitation on Profile Sheet" or "Check box [Category] -- USE Aid on Profile Sheet" whenever specific answers are given. The Profile Sheet accumulates checkbox tallies across three columns (Limitation, USE Aid, NEED Aid) and ten rows (General, Hearing, Seeing, Communicating, Walking, Hands/Fingers, Learning, Developmental, Emotional/Psychological, Chronic). At three critical routing checkpoints -- B62.edit (p. 15), B89.edit (p. 20), and B95.edit (p. 21) -- the interviewer must consult the Profile Sheet to determine routing:

- **B62.edit**: "If any box is checked in the 'Limitation Column' on the Profile Sheet, go to B62. Otherwise, go to the Follow-up Question (page 52)." This is the single most consequential routing decision in the entire questionnaire. If the interviewer fails to mark any limitation checkbox, the respondent is routed past the entire diagnosis, health, medications, and aids subsections (B62-B97) -- a loss of 36 questions of substantive data.
- **B89.edit**: "If any box is checked in the 'USE -- Aid' column on the Profile Sheet, continue. Otherwise, go to B93." Controls access to the aids funding and costs subsection.
- **B95.edit**: "If any box is checked in the 'NEED Aid' column on the Profile Sheet, continue. Otherwise, go to C1." Controls access to the unmet aids impact subsection.

**In the imperative version:** The Profile Sheet is a manual bookkeeping device. The interviewer must remember to mark checkboxes at each of the approximately 30 checkpoint instructions scattered across 20 pages. A single missed checkbox at any limitation-marking point (B2=2, B4=2/3, B21=1, B22=1, B31=1/2, B37=1/2, B43=1, B44=1, B53=1, B57=1/2, B60=1/2) could cause the B62.edit routing check to fail, silently skipping the entire second half of Section B. There is no built-in error correction mechanism.

**In the declarative version:** The Profile Sheet was modeled as 24 computed flag variables (9 limitation, 7 USE-aid, 7 NEED-aid, plus an aggregate counter) in the `codeInit` of `02_activity_limitations.qml`. Each flag is set via `codeBlock` at the corresponding question. The B62.edit checkpoint becomes a `precondition: limitation_count > 0` on the diagnosis block. This makes the accumulation logic auditable and error-free -- the Z3 solver verifies that the `limitation_count` variable is reachable with a positive value (SAT), confirming that at least one valid path populates the Profile Sheet. The conversion exposed that the paper form's integrity depends entirely on interviewer diligence in maintaining an external tracking device.

### P2: Scattered Age Gate with No Centralized Filter

**Severity:** MEDIUM
**PDF evidence:** B6.edit (p. 3: "If child was born AFTER May 15, 1996, go to B11"), B13.edit (p. 5), B15.edit (p. 5), B16.edit (p. 5), B51.edit (p. 12), B53.edit (p. 12), B87.edit (p. 19), C header (p. 22: "If child was born AFTER May 15, 1996, go to C12"), D8.edit (p. 27), Section E header (p. 28, implied), Section F header (p. 39, implied), Section G header (p. 45), Section H header (p. 47)

**Problem:** The "born after May 15, 1996" filter (meaning child is under 5 years old at the time of the 2001 survey) appears at 13+ distinct points throughout the questionnaire. In Section B alone, it appears at 7 filter edit points (B6.edit, B13.edit, B15.edit, B16.edit, B51.edit, B53.edit, B87.edit), each requiring the interviewer to check the child's date of birth against the May 15, 1996 threshold. In the later sections, the age gate controls access to entire sections (E, F, G, H) and to the personal care subsection of Section C.

The scattered nature of this filter creates two issues:
1. The interviewer must repeatedly perform the same date comparison at each checkpoint. There is no single screening point where the age determination is made and recorded for subsequent use.
2. The age gate is asymmetrically applied within Section B. For hearing (B6.edit), the gate skips only the aids subsection (B6-B10). For vision (B13.edit/B15.edit), it skips the aids subsection AND the entire communication-through-mobility sequence, routing directly to B51 (developmental). This means under-5 children are assessed for hearing difficulty (B1-B5) but not for speaking difficulty (B21-B30), walking difficulty (B31-B36), or hand/finger difficulty (B37-B42), even though these capabilities exist in children under 5.

**In the imperative version:** The interviewer checks "born AFTER May 15, 1996" at each filter point. The scattered placement and asymmetric application are hidden by the sequential page-by-page flow. The interviewer follows each instruction locally without seeing the overall pattern of what is skipped for under-5 children versus what is not.

**In the declarative version:** The age gate was modeled as a single `child_under_5` extern variable. All 7 Section B filter points and all section-level gates use this same variable. The asymmetric application becomes structurally visible: the QML for hearing has `child_under_5 == 0` only on the aids subsection (B6-B10), while blocks for communication (B21-B30), walking (B31-B36), and hands/fingers (B37-B42) have `child_under_5 == 0` as a block-level precondition, skipping the entire capability assessment for under-5 children. Whether this asymmetry is intentional (young children's hearing is assessed earlier than other capabilities) or an oversight is not documented in the source.

### P3: Province-Specific Grade Structure Creating Structural Redundancy

**Severity:** LOW
**PDF evidence:** pp. 31-35 (E13: province selection, E14: Newfoundland grades, E15: Prince Edward Island grades, E16: Nova Scotia grades, E17: Quebec grades, E18: Ontario grades, E19: default grades for remaining provinces/territories)

**Problem:** The Education section (E) implements 6 parallel grade-level questions, one for each of the following province groupings:

| Question | Province | Grade Range | Kindergarten Route |
|----------|----------|-------------|-------------------|
| E14 | Newfoundland | K, Gr 1-9, Level 1-3 Secondary, Ungraded | K -> E24 |
| E15 | Prince Edward Island | Gr 1-12, Ungraded | No kindergarten option |
| E16 | Nova Scotia | Primary, Gr 1-12, Ungraded | Primary -> E24 |
| E17 | Quebec | Jr K, K, Gr 1-6, Sec I-V, Ungraded | Jr K/K -> E24 |
| E18 | Ontario | Jr K, K, Gr 1-8, Gr 9-12, OAC, Ungraded | Jr K/K -> E24 |
| E19 | All others | K, Gr 1-12, Ungraded | K -> E24 |

All 6 variants ask the same conceptual question ("In what grade was the child enrolled?") and route identically: kindergarten-level responses skip to E24 (school activities), while all other grades proceed to E20 (education type). The only difference is the provincial naming convention for grade levels (e.g., Newfoundland uses "Level 1 Secondary" while Ontario uses "Grade 9"; Quebec uses "Secondary I-V").

**In the imperative version:** E13 routes the interviewer to the correct page based on province. Each province variant occupies a separate physical page, so the redundancy is hidden by page boundaries. The interviewer sees only one version.

**In the declarative version:** All 6 variants must be modeled with mutually exclusive preconditions on the `e13_province` variable. The QML makes the structural redundancy explicit: 6 items where a single parameterized question with province-appropriate labels would suffice. The Z3 solver confirms all 6 are CONDITIONAL with non-overlapping province ranges. Additionally, Prince Edward Island (E15) notably lacks a kindergarten option, meaning PEI children in kindergarten have no valid response -- they must select "Ungraded" and proceed to E20, missing the E24 kindergarten shortcut available to children in all other provinces.

### P4: Complete Absence of Cross-Field Validation (Zero Postconditions)

**Severity:** MEDIUM
**PDF evidence:** Entire questionnaire (57 pages) -- no range checks, consistency checks, or conditional validation instructions appear anywhere in the source

**Problem:** Across all 247 QML items derived from 223 source questions, there are **zero postconditions**. The original questionnaire contains no instructions for the interviewer to validate that responses are internally consistent. Specific examples where postconditions would be expected:

1. **B62 (p. 15)**: "How old was the child when you suspected the condition?" accepts 0-14 but has no check against the child's actual age. An interviewer could record "suspected at age 12" for a 3-year-old.
2. **B66 (p. 15)**: "How old was the child when you obtained a diagnosis?" has no check that diagnosis age <= suspected age (B62), nor that diagnosis age <= current age.
3. **B76/B82/B91 (pp. 17-20)**: Out-of-pocket expense amounts accept $1-$999,999 with no reasonableness check. There is no validation that costs are positive or that the expense group (B77/B83/B92) is consistent with the specific amount if one was provided.
4. **D3/D5 (p. 27)**: Child care hours per week are unconstrained. There is no check that total hours across main and other arrangements do not exceed 168 (hours in a week).
5. **F1a_hrs through F16d_hrs (pp. 39-44)**: "How many hours a day?" for each activity accepts any numeric value. An answer of "24 hours a day" for an activity done "less than once a month" is structurally allowed.

**In the imperative version:** The paper form relies entirely on interviewer judgment to catch implausible responses. There is no built-in validation mechanism because a paper form cannot perform runtime checks. This is a fundamental limitation of PAPI (paper-and-pencil interviewing) compared to CAPI or CATI systems.

**In the declarative version:** The QML faithfully reproduces the original design by omitting postconditions. The Z3 solver correctly reports all postcondition classifications as NONE. The absence of validation constraints means the questionnaire cannot prevent logically inconsistent data from being recorded. A CAPI implementation would be expected to add edit checks, but the source instrument provides no specification for what those checks should be.

### P5: DK/Refusal Routing Asymmetry Across Parallel Subsections

**Severity:** MEDIUM
**PDF evidence:** B1 (p. 2: DK/R -> "Go to B4"), B11 (p. 4: DK/R -> "Go to B14"), B6 (p. 4: DK/R -> "Go to B8"), B8 (p. 4: DK/R -> "Go to B10"), B17 (p. 5: DK/R -> "Go to B19"), B19 (p. 5: DK/R -> "Go to B21"), B27 (p. 7: DK/R -> "Go to B29"), B29 (p. 7: DK/R -> "Go to B31"), B33 (p. 8: DK/R -> "Go to B35"), B35 (p. 8: DK/R -> "Go to B37"), B39 (p. 9: DK/R -> "Go to B41"), B41 (p. 9: DK/R -> "Go to B43"), B47 (p. 11: DK/R -> "Go to B49"), B49 (p. 11: DK/R -> "Go to B51.edit")

**Problem:** The five disability subsections in Section B (Hearing, Seeing, Communication, Walking, Hands/Fingers) follow a parallel structure: screen -> severity -> USE aids -> which aids -> NEED aids -> which aids needed. However, DK/Refusal routing is inconsistent at the initial screening questions:

| Subsection | Initial Screen | DK/R Route | Effect |
|------------|---------------|------------|--------|
| Hearing | B1 (uses hearing aid?) | DK/R -> B4 (ability without aid) | Child still assessed for hearing difficulty via alternate path |
| Vision | B11 (wears glasses?) | DK/R -> B14 (ability without glasses) | Child still assessed for vision difficulty via alternate path |
| Communication | B21 (difficulty speaking?) | No DK/R routing specified | DK/R responses have no explicit routing instruction |
| Walking | B31 (difficulty walking?) | DK/R -> "Go to B37" | Child skips entire walking subsection (severity, USE aids, NEED aids) |
| Hands/Fingers | B37 (difficulty using hands?) | DK/R -> "Go to B43" | Child skips entire hands/fingers subsection |

For Hearing and Vision, DK/Refusal at the initial screening still allows the child to be assessed via an alternate path (B4 "How would you describe ability to hear?" or B14 "How would you describe vision ability?"). For Walking and Hands/Fingers, DK/Refusal at the initial screening causes the child to skip the entire subsection, including the severity and aids questions. This means a DK response at B31 results in no walking data at all, while a DK response at B1 still produces hearing assessment data.

The Communication subsection (B21) has no explicit DK/R routing at the initial screen. The source document shows response codes `{1: "Yes", 3: "No", x: "Don't know", r: "Refusal"}` but only specifies routing for Yes (-> B23) and No/DK/R (-> B22). This conflates "No difficulty" with "Don't know" by sending both down the same path.

**In the imperative version:** The inconsistency is spread across 20 pages and is not apparent to the interviewer, who simply follows the routing instruction at each question. The parallel structure of the subsections creates an expectation of parallel DK/R handling that is not fulfilled.

**In the declarative version:** The QML preconditions make the asymmetry visible. B4 has `precondition: q_b1.outcome == 8 or q_b1.outcome == 9` (DK/R route to alternate assessment), while B32 and B38 have `precondition: q_b31.outcome == 1 or q_b31.outcome == 2` (only Yes answers proceed; DK/R is silently dropped). The Z3 solver confirms all items are reachable but cannot detect the semantic inconsistency in DK handling across parallel subsections.

### P6: Unbounded Hours-Per-Day Fields in Frequency/Duration Pairs

**Severity:** LOW
**PDF evidence:** pp. 39-44 (F1a-F1e frequency+hours pairs, F2a-F2c frequency+hours pairs, F3 frequency+hours, F16a-F16d frequency+hours); p. 27 (D3/D5 child care hours per week)

**Problem:** Section F contains 13 frequency/duration question pairs where a frequency question (5-point scale from "Everyday" to "Never") is followed by a conditional "How many hours a day?" question. The hours questions have no upper bound validation and no cross-check against the frequency response. Specifically:

- A respondent can report "Less than once a month" (F1a=4) for organized sports and then report "24 hours a day" for the same activity. The source provides no instruction to flag this as implausible.
- The instruction "Round to the nearest full hour" (pp. 39-40) establishes that fractional hours should be rounded, but provides no maximum. The QML models these with `max: 24` (hours in a day), but this constraint was added during conversion -- it does not exist in the source.
- For Section F reading (F3), the hours question is triggered only for "Everyday" (F3=1), unlike all other frequency questions which trigger hours for any non-Never response. This inconsistency means reading hours are collected only for daily readers, not for weekly or monthly readers, while all other activities collect hours regardless of frequency.

**In the imperative version:** The interviewer rounds to the nearest hour and writes the number. There is no mechanism to enforce that hours are reasonable given the frequency.

**In the declarative version:** The QML adds `min: 0, max: 24` constraints on the Editbox controls for hours questions, which provides basic domain bounding not present in the original. The reading-specific routing difference (F3: hours only for "Everyday") is faithfully preserved via `precondition: q_f3.outcome == 1`, making this asymmetry structurally visible.

### P7: Silent Exit Path for Children with No Confirmed Limitations

**Severity:** LOW
**PDF evidence:** B62.edit (p. 15: "If any box is checked in the 'Limitation Column' on the Profile Sheet, go to B62. Otherwise, go to the Follow-up Question (page 52)")

**Problem:** At B62.edit, children whose responses did not trigger any of the 10 limitation checkbox conditions on the Profile Sheet are routed directly to the follow-up question on page 52, skipping the remainder of Section B (B62-B97: diagnosis, health, medications, health professional contacts, aids costs), all of Section C (everyday help), Section D (child care), Sections E-H (education, leisure, home, transportation), and Section I (economic characteristics). This means the questionnaire collects essentially no substantive data for these children beyond the initial screening (A1-B61).

This is a defensible design decision -- the PALS targets children with activity limitations, and children without confirmed limitations are not the survey's population of interest. However, the exit path is undocumented in the sense that there is no explicit instruction saying "end the interview." The routing says "go to the Follow-up Question (page 52)" which is a single re-contact consent question, after which the interview ends. A child who enters the survey (having been selected based on Census responses indicating disability) but who does not confirm any limitation during the in-depth Section B screening is collected out of the survey via this silent path.

**In the imperative version:** The interviewer follows the routing instruction and turns to page 52. The extent of what is being skipped (40 pages of substantive content) is not stated at the routing checkpoint.

**In the declarative version:** The `precondition: limitation_count > 0` on blocks b_diagnosis, b_health_meds, b_health_prof, and b_aids_costs makes the gate explicit. The QML also makes it clear that Sections C through I depend on the questionnaire reaching their entry points; the silent exit at B62.edit terminates the flow for the entire remaining questionnaire. The Z3 solver confirms this by classifying all items in blocks gated by `limitation_count > 0` as CONDITIONAL.

## Cross-Check Fixes (QML Authoring Errors)

| # | Item(s) | Error | Fix | PDF Reference |
|---|---------|-------|-----|---------------|
| 1 | E2 routing | Initially routed E2 -> E4 (continuing to "Did child ever go to school?") | Corrected to E2 -> GO TO E37 after identifying E3.edit filter between E2 and E3 in source; children tutored at home skip the school-attendance questions | p. 28 (E2 -> E3.edit -> E37) |
| 2 | Section header counts | Inventory initially had incorrect item counts for C (27, actual 29), E (38, actual 39), F (32, actual 38), H (16, actual 17), I (12, actual 10) | Corrected all counts after item-by-item audit against source pages | Throughout |
| 3 | B2 precondition | Initially modeled B2 as always-shown after B1 | Corrected: B1=DK/R routes to B4 (without-aid path), so B2 requires `q_b1.outcome == 1 or q_b1.outcome == 3` | p. 2 (B1 DK/R -> B4) |
| 4 | B40 precondition | Initially required B39=Yes to show B40 (which aids used) | Corrected: source shows B39=Yes OR B39=No both proceed to B40; only DK/R skips to B41 | p. 9 (B39 routing) |
| 5 | Profile Sheet flag accumulation | Initially used separate counter variables; missed that limitation_general from Section A feeds into the B62.edit check | Added `limitation_general` as extern variable in Section B codeInit; included in limitation_count sum | p. 1-2 (A1/A2A/A2B/A2C), p. 15 (B62.edit) |
| 6 | F3 hours trigger | Initially triggered hours for all non-Never responses (consistent with F1a-F2c pattern) | Corrected: source shows F3 hours only for "Everyday" (response 1), unlike all other frequency items | p. 40 (F3: only "Everyday" has hours row) |

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Profile Sheet** | External paper tracking device requiring ~30 manual checkbox operations across 20 pages; interviewer error at any point can corrupt routing | 24 computed flag variables with deterministic `codeBlock` logic; B62.edit check is a verifiable precondition; Z3 confirms SAT |
| **Age gate** | "Born AFTER May 15, 1996" checked at 13+ scattered points by interviewer date comparison | Single `child_under_5` extern variable applied uniformly; asymmetric application across subsections becomes visible |
| **Province-specific grades** | 6 province variants on separate pages selected by GOTO | 6 mutually exclusive preconditions on `e13_province`; structural redundancy and PEI kindergarten gap exposed |
| **Validation constraints** | None (paper form cannot enforce runtime checks); interviewer judgment only | Faithfully modeled as 0 postconditions; absence of validation made structurally explicit |
| **DK/Refusal handling** | Each subsection's DK/R routing follows local GOTO instructions; inconsistency across subsections invisible | Precondition patterns make asymmetric DK handling visible across structurally parallel subsections |
| **Frequency/hours pairing** | Sequential questions on same page; hours follow frequency implicitly | Separate items with conditional preconditions; F3 reading asymmetry and absence of cross-field validation exposed |
| **Dependency complexity** | ~150 GOTO instructions spread across 57 pages; interviewer follows one instruction at a time | 860 dependencies captured in graph; 80% concentrated in Section B; all verified acyclic and reachable |

## Conclusion

The Z3 QML validator found the PALS 2001 (Children under 15) questionnaire to be **structurally valid** across all 9 section files: no dependency cycles (0 cycles), no unreachable items (0 NEVER), no infeasible postconditions (0 INFEASIBLE), and at least one valid completion path (SAT) in every section. The 247-item QML representation across 25 blocks covers the full scope of the 57-page paper questionnaire.

The declarative conversion exposed **7 categories of design issues** in the original questionnaire:

1. **P1 (HIGH):** The Profile Sheet -- an external paper tracking device requiring ~30 manual checkbox operations -- serves as the sole mechanism for the questionnaire's most consequential routing decision (B62.edit). A single missed checkbox can silently route a respondent past 36 questions of substantive data. The QML replacement (24 computed flag variables) eliminates this single point of failure.
2. **P2 (MEDIUM):** The "born after May 15, 1996" age gate appears at 13+ scattered filter points with no centralized determination. Its asymmetric application means under-5 children are assessed for hearing difficulty but silently excluded from communication, walking, and hands/fingers assessment.
3. **P3 (LOW):** Province-specific grade questions (E14-E19) create 6 parallel variants where a single parameterized question would suffice. Prince Edward Island's variant lacks a kindergarten option present in all other provinces.
4. **P4 (MEDIUM):** Zero postconditions across 247 items means the questionnaire has no cross-field validation: ages can exceed the child's actual age, expense amounts have no reasonableness bounds, and hours-per-day are unconstrained.
5. **P5 (MEDIUM):** DK/Refusal routing is asymmetric across structurally parallel disability subsections -- hearing and vision provide alternate assessment paths for DK responses, while walking and hands/fingers skip the entire subsection.
6. **P6 (LOW):** Frequency/duration pairs in Section F lack cross-validation (24 hours/day at "less than once a month" is structurally valid), and reading (F3) has a unique hours-trigger rule different from all other activities.
7. **P7 (LOW):** Children with no confirmed limitations exit silently at B62.edit, skipping 40 pages of substantive content with no explicit "end of interview" instruction.

The PALS 2001's structural soundness (no cycles, no dead code) reflects its straightforward top-to-bottom design. The primary routing complexity is concentrated in Section B, where the Profile Sheet mechanism creates 684 of 860 total dependencies (80%). The conversion revealed that the questionnaire's integrity depends critically on an external administrative device (the Profile Sheet) and on consistent interviewer execution of a scattered age gate -- both of which are eliminated as error sources in the declarative QML representation.
