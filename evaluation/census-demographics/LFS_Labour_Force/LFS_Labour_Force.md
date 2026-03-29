# Labour Force Survey (LFS): Declarative Conversion Analysis

**Source:** Statistics Canada, Guide to the Labour Force Survey, Appendix B (pages 48-77)
**QML Files:** `evaluation/statcan-questionnaires/LFS_Labour_Force/`
**Date:** 2026-03-28

## Objective

Transform the Labour Force Survey questionnaire (30 pages, CATI-based with GOTO routing and a 7-value PATH classification variable) into a declarative QML representation split across 6 section files, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. PDF extracted to text via `pdftotext -layout -nodiag` (1833 lines)
2. Question inventory: 163 nodes catalogued across 6 sections with parallel subagents, verified by independent judgement agent (6/6 sections, 0 missing items)
3. Declarative QML conversion with per-section subagents, PATH variable decomposition for cycle avoidance, and extern variable handover between sections
4. Formal validation using the Askalot Z3 QML validator (4-level verification on all 6 files)

## Survey Architecture Overview

| # | Section File | Block(s) | Items | Purpose |
|---|---|---|---|---|
| 01 | `01_contact.qml` | 6 blocks | 14 | Call introduction, respondent identification, language preference |
| 02 | `02_household.qml` | 7 blocks | 23 | Address confirmation, dwelling type, household roster |
| 03 | `03_individual_demographics.qml` | 8 blocks | 19 | Age, sex, marital status, immigration, aboriginal identity, education, armed forces |
| 04 | `04_rent.qml` | 6 blocks | 20 | Rent amount, subsidies, parking, utilities (conditional on renting) |
| 05 | `05_labour_force.qml` | 10 blocks | 75 | Job attachment, description, absence, hours, search, availability, earnings, union, permanence, school |
| 06 | `06_exit.qml` | 8 blocks | 14 | Future contact scheduling, telephone confirmation, farewell |

## Semantic Equivalence

| Metric | Count |
|--------|-------|
| PDF questions (substantive) | 163 |
| QML items | 165 |
| Matched | 163 |
| Justified additions | 2 |

- **q_interview_type** (01_contact): System metadata (birth/subsequent, CATI/in-person) modeled as an explicit classification question since QML has no system metadata concept
- **q_rs_r01_birth / q_rs_r01_subseq** (02_household): Single inventory item RS_R01 split into two QML Comment items for block-level routing (birth vs subsequent paths in separate blocks)

Roster items (USU_Q01, TEM_Q01, OTH1_Q01, OTH2_Q01) modeled as Textarea since QML cannot represent dynamic person loops. Date fields (ANC_Q01, items 105, 118) modeled as numeric Editbox since QML has no Date control.

## Validator Results

### Summary

| Metric | 01 Contact | 02 Household | 03 Demographics | 04 Rent | 05 Labour Force | 06 Exit | **Total** |
|--------|-----------|-------------|----------------|---------|----------------|---------|-----------|
| Items | 14 | 23 | 19 | 20 | 75 | 14 | **165** |
| Blocks | 6 | 7 | 8 | 6 | 10 | 8 | **45** |
| Preconditions | 11 | 21 | 13 | 20 | 74 | 14 | **153** |
| Postconditions | 0 | 0 | 1 | 0 | 1 | 0 | **2** |
| Variables | 1 | 4 | 5 | 4 | 8 | 5 | **27** |
| Dependencies | 22 | 6 | 30 | 13 | 268 | 4 | **343** |
| Components | 3 | 17 | 4 | 8 | 8 | 11 | — |
| Cycles | 0 | 0 | 0 | 0 | 0 | 0 | **0** |
| Global | SAT | SAT | SAT | SAT | SAT | SAT | **SAT** |
| Issues | 0 | 0 | 0 | 0 | 0 | 0 | **0** |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | 12 |
| Precondition CONDITIONAL | 153 |
| Precondition NEVER | 0 |
| Postcondition CONSTRAINING | 1 |
| Postcondition TAUTOLOGICAL | 1 |
| Postcondition NONE | 163 |

The overwhelming majority of items (153/165 = 93%) are CONDITIONAL — expected for a heavily branched CATI questionnaire where nearly every question depends on prior answers or system state. Only 12 items (entry points and always-shown demographics) are ALWAYS reachable. Zero NEVER-reachable items confirms no dead code.

The single CONSTRAINING postcondition (on item 202, hourly wage rate) validates that the wage is within a reasonable range. The single TAUTOLOGICAL postcondition (on IMM_Q04, immigration month) confirms the month range constraint is always satisfiable when the question is reached.

## Section Files

| # | File | Block(s) | Items | Variables Read | Variables Written |
|---|------|----------|-------|----------------|-------------------|
| 01 | `01_contact.qml` | b_interview_type, b_initial_contact, b_adult_contact, b_appointments, b_address_confirm, b_survey_intro | 14 | — | interview_type |
| 02 | `02_household.qml` | b_address_filter, b_address_subsequent, b_mailing_address, b_dwelling, b_tenure, b_roster_birth, b_roster_subsequent | 23 | interview_type | dwelling_type, tenure, addresses_match |
| 03 | `03_individual_demographics.qml` | b_age, b_sex, b_marital, b_family, b_immigration, b_aboriginal, b_education, b_armed_forces | 19 | — | respondent_age, sex, armed_forces, recent_immigrant, has_postsecondary |
| 04 | `04_rent.qml` | b_rent_intro, b_dwelling_chars, b_subsidy_business, b_rent_amount, b_parking, b_utilities | 20 | dwelling_type, tenure, has_previous_rent, membership_change | — |
| 05 | `05_labour_force.qml` | b_job_attachment, b_job_description, b_absence_separation, b_work_hours, b_job_search, b_availability, b_earnings, b_other_job, b_temp_layoff, b_school | 75 | respondent_age, is_subsequent | path, usual_hours, actual_hours, last_work_recent, is_temp_layoff, search_status |
| 06 | `06_exit.qml` | b_exit_intro, b_future_contact, b_telephone, b_interview_mode, b_call_time, b_living_quarters, b_thankyou_continue, b_thankyou_rotateout | 14 | interview_type, dwelling_type, is_rotate_out, has_phone, has_previous_call_time | — |

## Problems in the Original LFS Questionnaire (Exposed by Declarative Conversion)

### P1: PATH Variable Creates Routing Opacity

**Severity:** MEDIUM
**PDF evidence:** Pages 57-67, items 100-521

**Problem:** The PATH variable (values 1-7: Employed at work, Employed absent, Temporary layoff, Job seeker, Future start, Not in labour force able, Not in labour force permanently unable) serves as both a respondent classification AND a flow routing mechanism. It is written at 6 different items (100, 130, 136, 170, 174, 175) and read at 14+ items (105, 130, 132, 137, 151, 152, 158, 159, 160, 161, 170, 178, 320, 400) to control which sub-sections a respondent visits.

**In the imperative version:** The dual-use pattern works because GOTO instructions carry the respondent forward — the PATH value and the jump target are set simultaneously. An interviewer following the script never encounters the variable in an undefined state.

**In the declarative version:** Converting to preconditions exposed that PATH=0 (unclassified) is an implicit intermediate state that multiple items could theoretically encounter. The declarative conversion required decomposing PATH into separate classification variables (`path`, `is_temp_layoff`, `search_status`) to avoid dependency cycles where items both read and write the same variable. This reveals that the original routing conflates two distinct concerns: (1) what the respondent's labour force status IS, and (2) which questions to ask next.

### P2: Phantom Longitudinal Dependencies

**Severity:** MEDIUM
**PDF evidence:** Pages 55-56 (RM_Q08, RM_Q09B, RM_Q14), page 57 (item 105), page 64 (item 200), page 68 (PTC_Q01), page 67 (item 520)

**Problem:** The questionnaire references "previous month" interview data at 7+ points without specifying fallback behavior when this data is missing:
- Item 105: "if subsequent interview and no change in 105" — assumes item 105's response from last month exists
- Item 200: "if subsequent interview and no change in 110, 114-118" — assumes 6 prior responses exist
- RM_Q08: "if rent information does not exist from the previous month" — one of three filter conditions
- RM_Q09B: similar previous month filter
- RM_Q14: similar previous month filter
- PTC_Q01: "if preferred time to call information does not exist from the previous month"
- Item 520: "if subsequent interview and 520 in previous month was..."

**In the imperative version:** The CATI application manages longitudinal state through its database. Missing data is handled by the software infrastructure, not the questionnaire logic. The questionnaire document leaves this behavior undocumented.

**In the declarative version:** Each longitudinal dependency required an explicit extern variable (e.g., `has_previous_rent`, `is_subsequent`, `has_previous_call_time`) with domain constraints. The conversion forces these hidden dependencies to be declared explicitly, revealing that the questionnaire's logic is incomplete without its surrounding CATI infrastructure.

### P3: Asymmetric Age Threshold Application

**Severity:** LOW
**PDF evidence:** Pages 52-54 (Demographics), pages 57-67 (Labour Force)

**Problem:** Different modules apply age-based eligibility gates using different thresholds without a unified framework:

| Gate | Threshold | Items Affected |
|------|-----------|----------------|
| Marital status | age >= 16 | MSNC_Q01 |
| Education | age >= 14 | ED_Q01 |
| Armed forces screener | 16 <= age <= 65 | CAF_Q01 |
| Labour force eligibility | age 15+ (implied by "each person aged 15 or over") | All of section 05 |
| School attendance | age < 65 | Item 500 |
| Returning student | 15 <= age <= 24 | Item 520 |

This creates an inconsistency: the Labour Force section header states "For each person aged 15 or over" but the CAF_Q01 routing gate at age < 16 sends under-16s to the next household member, effectively excluding 15-year-olds from the Labour Force component entirely. The documented eligibility (15+) contradicts the actual routing (16+). Additionally, the education threshold (age >= 14) differs from both the marital status threshold (age >= 16) and the school attendance cut-off (age < 65) without documented rationale.

**In the imperative version:** The GOTO chain at CAF_Q01 naturally routes under-16s to next person. The inconsistency between the section header ("15 or over") and the actual gate (age >= 16) is invisible in the linear flow.

**In the declarative version:** The block-level preconditions make the different thresholds explicit and visually distinct, revealing both the header/routing inconsistency and the asymmetric boundary application across modules.

### P4: Terminal Interview Paths Without Recovery Logic

**Severity:** LOW
**PDF evidence:** Pages 48-51 (Contact), page 50 (Household)

**Problem:** Nine interview paths end with "thank person and end call" without any documented recovery or retry mechanism:
1. TC_Q01 = No (wrong number confirmed)
2. SD_Q02 = No (no one at old address)
3. SD_Q03 = No (can't provide new number)
4. SD_Q04 (phone number collected, end)
5. SD_Q05 (wrong number confirmed, end)
6. SRA_Q01 = 3 → ARA_Q01 = 3 (no one available)
7. ARA_Q01 = 3 (no one available, no further options)
8. TFCC_Q02 (wrong household confirmed, end)
9. SR_Q01 = 5 → TC_Q01 = No (wrong number chain)

**In the imperative version:** The CATI system handles these as disposition codes — the interviewer can call back later with a new attempt. The recovery mechanism is external to the questionnaire.

**In the declarative version:** These become dead-end nodes — items that are reachable but lead to no further questions. While the Z3 validator correctly classifies them as CONDITIONAL (not dead code), the questionnaire document provides no logic for what happens after these terminations.

### P5: Redundant Modality-Variant Questions

**Severity:** LOW
**PDF evidence:** Page 50 (DW_Q01, DW_N02)

**Problem:** DW_Q01 ("What type of dwelling do you live in?", asked during telephone birth interviews) and DW_N02 ("Select the dwelling type", interviewer-observed during in-person birth interviews) use identical response options ({1: "Single detached", ..., 10: "Other"}). The only difference is the presentation modality — DW_Q01 reads categories to the respondent while DW_N02 is interviewer-selected. Similarly, birth and subsequent interview paths duplicate RS_R01 introduction text.

**In the imperative version:** The modality split is natural for CATI — different screens for different interview modes.

**In the declarative version:** The conversion required a `dwelling_type` consolidation variable to merge the two mutually exclusive items' outcomes, adding a codeBlock to each. A single parametric question with a modality flag would eliminate this structural redundancy.

## Cross-Check Fixes (QML Authoring Errors)

| # | Item(s) | Error | Fix | PDF Reference |
|---|---------|-------|-----|---------------|
| 1 | q_interview_type | Not in original questionnaire | Added as system metadata classification; QML requires explicit item for interview type routing | System-level metadata |
| 2 | RS_R01 | Single item in inventory | Split into q_rs_r01_birth and q_rs_r01_subseq for block-level routing; identical content | Page 51, RS_R01 |
| 3 | ANC_Q01 | Date of birth in source | Modeled as age Editbox (0-120) since QML has no Date control | Page 52, ANC_Q01 |
| 4 | Items 105, 118 | Temporal dates in source | Modeled as numeric Editbox (months since/years) | Pages 58-59 |
| 5 | Roster items | Dynamic person loops in source | Modeled as Textarea since QML has no loop construct; loop semantics documented in comments | Pages 51-52 |
| 6 | Province filter | Rent component excludes Yukon/NWT/Nunavut | Cannot model without a province variable; limitation documented in QML comments | Page 54 |

## Impact Assessment

The LFS is a well-structured monthly panel survey with relatively clean routing logic. The formal conversion reveals that its complexity comes primarily from:

1. **Scale of conditional branching** (153 of 165 items are CONDITIONAL) — nearly every question depends on prior answers, interview type, or longitudinal state
2. **The PATH variable pattern** — a single classification variable controlling 10 sub-sections across 75 items
3. **Longitudinal state dependencies** — the questionnaire is designed as part of a 6-month panel and relies heavily on its CATI infrastructure for state management

The zero NEVER-reachable items and zero dependency cycles indicate that the original LFS design is logically sound — there are no dead questions or contradictory routing. The 5 problems identified are structural design observations (routing opacity, phantom dependencies, threshold asymmetries) rather than data-quality defects.

The Labour Force section's 268 dependencies (vs 4-30 for other sections) confirm it is the structural heart of the questionnaire, with the densest branching logic in the entire survey.

## Conclusion

The LFS converts cleanly to 6 declarative QML files totaling 165 items with 153 preconditions, 27 variables, and zero validation issues. The Z3 solver confirms global satisfiability across all sections with no unreachable items, no infeasible postconditions, and no dependency cycles. The five identified problems are properties of the original questionnaire design — routing opacity from the PATH variable's dual classification/routing role, undocumented longitudinal dependencies, asymmetric age thresholds, terminal paths without recovery logic, and redundant modality-variant questions. None represent data-quality defects; all are typical of well-engineered CATI instruments where the application infrastructure compensates for what the questionnaire document leaves implicit.
