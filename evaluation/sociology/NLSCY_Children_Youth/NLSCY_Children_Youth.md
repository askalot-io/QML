# NLSCY Cycle 1 (1994-95): Declarative Conversion Analysis

**Source:** Statistics Canada / Human Resources Development Canada, National Longitudinal Survey of Children -- Survey Instruments for 1994-95 Data Collection, Cycle 1, Catalogue No. 89F0077XIE, February 1995, 161 pages
**QML Files:** `evaluation/statcan-questionnaires/NLSCY_Children_Youth/` (23 section files)
**Date:** 2026-03-28

## Objective

Transform the NLSCY CAPI questionnaire (161 pages, ~843 question nodes across 24 sections, GOTO-based age-tiered routing for children aged 0-11) into a declarative QML representation consisting of 23 standalone section files, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. **PDF preprocessing**: Extracted text with `pdftotext -layout -nodiag`. Section boundaries identified via heading patterns (HHLD, RESTR, CHRON, SOCIO, EDUC, LFS, INCOM, CHLT, FNC, SAF, SUP, DVS, HLT, MED, TMP, EDU, LIT, ACT, BEH, MSD, REL, PAR, CUS, CAR) and question ID prefixes.
2. **Question inventory**: 843 nodes catalogued across 24 sections with full routing annotations. Judgement agent verified coverage: 24/24 sections, 0 missing items, all ~933 GOTO references accounted for. Status: READY FOR QML.
3. **Declarative QML conversion**: Per-section standalone QML files generated using parallel subagents. Each section file is independently validatable with its own `qmlVersion` and `codeInit`. Cross-section variables (child_age, respondent_age, is_parent, etc.) declared in each file's `codeInit` as read-from-prior-section annotations.
4. **Formal validation**: Z3 SMT solver run on all 23 section files independently. All sections pass all four validation levels (per-item classification, global satisfiability, cycle detection, path-based reachability).

## Survey Architecture Overview

The NLSCY Cycle 1 questionnaire has four major parts and uses **child age** (0-11 years) as the primary routing variable, with **child age in months** (0-47) for the Motor and Social Development and Temperament sections.

### Part 1: Household Record (pp. 3-8)

| Section | Pages | Items | Purpose |
|---------|-------|-------|---------|
| Contact & Household (CONT/DEMO/HHLD) | 3-8 | 23 | Contact intro, demographics, dwelling, household roster |

### Part 2: General Questionnaire (adults 15+, pp. 9-26)

| Section | Pages | Items | Purpose |
|---------|-------|-------|---------|
| Restriction of Activities (RESTR) | 9-10 | 3 | Health limitations (respondent age 12+) |
| Chronic Conditions (CHRON) | 11-12 | 6 | Long-term conditions (parent only, age 12+) |
| Socio-demographics (SOCIO) | 12-14 | 10 | Country of birth, ethnicity, language, religion |
| Education (EDUC) | 15-16 | 8 | Schooling, degrees (age 12+) |
| Labour Force (LFS) | 17-21 | 31 | Employment, hours, earnings (parents only) |
| Income (INCOM) | 22-24 | 6 | Household and personal income |

### Part 3: Parent Questionnaire (PMK and/or spouse, pp. 27-40)

| Section | Pages | Items | Purpose |
|---------|-------|-------|---------|
| Adult Health (CHLT) | 29-32 | 26 | Health, smoking, alcohol, maternal history, CES-D depression |
| Family Functioning (FNC) | 33-34 | 17 | McMaster FAD-12 family assessment |
| Neighbourhood (SAF) | 35-37 | 21 | Safety, social cohesion, problems |
| Social Support (SUP) | 38-40 | 12 | Personal support, professional help |

### Part 4: Children's Questionnaire (pp. 43-161)

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

**Total inventory:** 843 nodes across 24 sections. **QML items:** 536 (compression via QuestionGroups for battery items), expanding to ~687 with sub-question accounting.

## Semantic Equivalence

| Metric | Count |
|--------|-------|
| Source questions (substantive) | ~686 |
| QML items (expanded) | ~687 |
| Matched | ~677 |
| Justified omissions | 10 |

### Justified Omissions (10 items)

| Category | Items | Reason |
|----------|-------|--------|
| Dynamic roster loop | DEMO-Q1 through DEMO-Q3 person-loop | Household roster construction requiring N-person iterative loops; QML models the roster summary, not the per-person iteration |
| Procedural/admin | H05-P1 (interview mode), H05-P2 (interview language) | Interviewer metadata duplicating CONT-Q2 and HHLD-Q8 |
| CAPI system fields | DEMO-Q7 (family ID code), HHLD-Q6 (dwelling observation), HHLD-Q7 (information source), PICKRESP (PMK selection) | System-internal fields with no respondent-facing question |
| Section-complete checks | FNC-C1, SAF-C1, SUP-C1 | "If this section has been completed for another household member, skip" -- runtime state not expressible in declarative model |

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Total items | 536 |
| Total blocks | 112 |
| Preconditions | 477 |
| Postconditions | 2 |
| Variables (SSA) | 52 |
| Dependencies | 573 |
| Cycles | **0** |
| Global Status | **SAT** (all 23 sections) |
| Dead Code | **0** |
| Issues | **0** |

### Z3 Item Classifications

| Classification | Count | Meaning |
|----------------|-------|---------|
| Precondition ALWAYS | 62 | Items shown regardless of child age or respondent type |
| Precondition CONDITIONAL | 474 | Items gated by age, respondent type, or prior responses |
| Precondition NEVER | 0 | No dead code detected |
| Postcondition TAUTOLOGICAL | 2 | Postcondition always true when item is reached |
| Postcondition CONSTRAINING | 0 | No active filtering postconditions |
| Postcondition INFEASIBLE | 0 | No impossible validation rules |

**Interpretation**: The 62 ALWAYS items are unconditional entry points in each section -- introductions, universal health questions (HLT-Q1 through Q4), child demographics, and items with no age or respondent gates. All 474 CONDITIONAL items have at least one valid path confirmed by the path-based reachability check. The 2 TAUTOLOGICAL postconditions indicate input constraints that duplicate control-level domain restrictions.

### Per-Section Validation

| Section | Items | Blocks | Pre | Post | Vars | Deps | Cycles | Status |
|---------|-------|--------|-----|------|------|------|--------|--------|
| 01_contact_household | 19 | 5 | 1 | 1 | 3 | 1 | 0 | VALID |
| 02_general_health | 7 | 2 | 7 | 0 | 2 | 2 | 0 | VALID |
| 03_socio_demographics | 15 | 5 | 9 | 0 | 0 | 7 | 0 | VALID |
| 04_education_adult | 6 | 1 | 6 | 0 | 1 | 7 | 0 | VALID |
| 05_labour_force | 26 | 4 | 26 | 0 | 2 | 57 | 0 | VALID |
| 06_income | 9 | 3 | 8 | 0 | 5 | 13 | 0 | VALID |
| 07_adult_health | 13 | 4 | 9 | 1 | 3 | 6 | 0 | VALID |
| 08_family_functioning | 3 | 1 | 1 | 0 | 1 | 0 | 0 | VALID |
| 09_neighbourhood | 7 | 1 | 0 | 0 | 0 | 0 | 0 | VALID |
| 10_social_support | 3 | 1 | 0 | 0 | 0 | 0 | 0 | VALID |
| 11_child_demographics | 3 | 1 | 0 | 0 | 1 | 0 | 0 | VALID |
| 12_child_health | 65 | 16 | 54 | 0 | 1 | 47 | 0 | VALID |
| 13_medical_biological | 35 | 6 | 35 | 0 | 4 | 18 | 0 | VALID |
| 14_temperament | 53 | 10 | 53 | 0 | 2 | 0 | 0 | VALID |
| 15_education_child | 26 | 9 | 26 | 0 | 4 | 29 | 0 | VALID |
| 16_literacy | 19 | 8 | 18 | 0 | 2 | 6 | 0 | VALID |
| 17_activities | 19 | 5 | 18 | 0 | 1 | 5 | 0 | VALID |
| 18_behaviour | 13 | 6 | 13 | 0 | 1 | 0 | 0 | VALID |
| 19_motor_social_development | 49 | 1 | 49 | 0 | 2 | 0 | 0 | VALID |
| 20_relationships | 8 | 2 | 8 | 0 | 2 | 3 | 0 | VALID |
| 21_parenting | 14 | 4 | 14 | 0 | 3 | 2 | 0 | VALID |
| 22_custody | 93 | 13 | 93 | 0 | 11 | 326 | 0 | VALID |
| 23_child_care | 31 | 6 | 29 | 0 | 1 | 44 | 0 | VALID |

### Key Structural Finding: No Dependency Cycles

The NLSCY questionnaire has **no dependency cycles** because the primary routing variable (`child_age`) is set once at the beginning and is never modified by downstream items. The age-tiered routing is strictly one-directional: age determines which sections and questions to show, but no downstream answer modifies the age variable. This contrasts with questionnaires like the LFS where the PATH variable creates feedback loops.

## Section Files

| # | File | Block(s) | Items | Variables Read | Variables Written |
|---|------|----------|-------|----------------|-------------------|
| 01 | `01_contact_household.qml` | 5 | 19 | -- | child_age, respondent_sex, marital_status |
| 02 | `02_general_health.qml` | 2 | 7 | respondent_age, is_parent | -- |
| 03 | `03_socio_demographics.qml` | 5 | 15 | -- | -- |
| 04 | `04_education_adult.qml` | 1 | 6 | respondent_age | -- |
| 05 | `05_labour_force.qml` | 4 | 26 | is_parent | has_gaps |
| 06 | `06_income.qml` | 3 | 9 | -- | household_income_known, personal_income_known |
| 07 | `07_adult_health.qml` | 4 | 13 | is_pmk, is_bio_mother_young_child | cesd_score |
| 08 | `08_family_functioning.qml` | 1 | 3 | marital_status | -- |
| 09 | `09_neighbourhood.qml` | 1 | 7 | -- | -- |
| 10 | `10_social_support.qml` | 1 | 3 | -- | -- |
| 11 | `11_child_demographics.qml` | 1 | 3 | -- | relationship_to_child |
| 12 | `12_child_health.qml` | 16 | 65 | child_age | -- |
| 13 | `13_medical_biological.qml` | 6 | 35 | child_age, child_age_months, is_bio_mother, is_bio_father | -- |
| 14 | `14_temperament.qml` | 10 | 53 | child_age, child_age_months | -- |
| 15 | `15_education_child.qml` | 9 | 26 | child_age, province | in_school, school_grade |
| 16 | `16_literacy.qml` | 8 | 19 | child_age, child_age_months | -- |
| 17 | `17_activities.qml` | 5 | 19 | child_age | -- |
| 18 | `18_behaviour.qml` | 6 | 13 | child_age | -- |
| 19 | `19_motor_social_development.qml` | 1 | 49 | child_age, child_age_months | -- |
| 20 | `20_relationships.qml` | 2 | 8 | child_age, has_siblings | -- |
| 21 | `21_parenting.qml` | 4 | 14 | relationship_to_child, is_pmk_or_spouse, child_age | -- |
| 22 | `22_custody.qml` | 13 | 93 | relationship_to_child, child_age | parents_together, parents_separated, parent_died, parents_were_married, mother_new_union, father_new_union, child_lived_with_respondent, custody_type, parents_lived_together_ever |
| 23 | `23_child_care.qml` | 6 | 31 | child_age | -- |

## Problems in the Original Questionnaire (Exposed by Declarative Conversion)

### P1: Ambiguous Age-Reference Scope in General Questionnaire Gates

**Severity:** MEDIUM
**PDF evidence:** p. 9 (RESTR-CINT: "IF AGE<12, GO TO NEXT SECTION"), p. 11 (CHRON-CINT: "IF AGE<12 OR RESPONDENT IS NOT THE PARENT GO TO NEXT SECTION")

**Problem:** RESTR-CINT and CHRON-CINT say "IF AGE<12" but do not specify whose age. In the NLSCY context -- where surveyed children are aged 0-11 and household respondents are 15+ -- these gates refer to the respondent's age (household members are screened for the General Questionnaire, which covers adults). But the child age variable is also present in the CAPI environment, and the phrase "IF AGE<12" is ambiguous when two age variables coexist.

**In the imperative version:** The CAPI system implicitly resolves this by knowing which person's record is currently active. The routing instruction is interpreted by the system, not by the interviewer.

**In the declarative version:** The QML requires an explicit variable reference. The conversion must choose `respondent_age >= 12` rather than `child_age >= 12`. This choice is not self-evident from the source text alone; it requires knowledge of the survey's administration design. The ambiguity is invisible in the imperative format because the system resolves it automatically.

### P2: Province-Specific Question Proliferation in Education (Child)

**Severity:** LOW
**PDF evidence:** pp. 84-100 (EDU section: Q1, Q1A-Q1E for grade level; Q5, Q5A-Q5E for skipped grade; Q7, Q7A-Q7E for repeated grade)

**Problem:** The Education (Child) section maintains **6 province-specific variants** of three questions:

| Question | Variants | Reason |
|----------|----------|--------|
| Current grade | Q1, Q1A-Q1E | Different naming: NF "Level 1 Secondary", QC "Secondary I", ON "OAC Grade 13" |
| Skipped grade | Q5, Q5A-Q5E | Same province-specific names |
| Repeated grade | Q7, Q7A-Q7E | Same province-specific names |

This creates **18 near-identical question variants** that differ only in grade naming conventions across Canadian provinces. The underlying data is the same -- an ordinal grade number. A single parameterized question with province-appropriate display labels would eliminate the structural redundancy entirely.

**In the imperative version:** Each province variant lives on a separate page, and the GOTO routing sends the interviewer to the correct page based on province. The duplication is hidden by physical page separation.

**In the declarative version:** The QML models these with mutually exclusive preconditions on a `province` variable, making the 6-way duplication structurally explicit. The Z3 solver confirms all variants are CONDITIONAL with non-overlapping province ranges, but the waste (18 items instead of 3 + a lookup table) is immediately visible.

### P3: Phantom Cross-Section Variables

**Severity:** MEDIUM
**PDF evidence:** Throughout -- RESTR-CINT references "AGE" (p. 9), LFS-C1 references "NOT PARENT" (p. 17), CHLT-C8 references "FEMALE BIOLOGICAL PARENT" (p. 30), CHLT-C12 references "PERSON MOST KNOWLEDGEABLE" (p. 31), FNC-C2 references "MARRIED, LIVING COMMON-LAW OR LIVING WITH A PARTNER" (p. 33), MSD-C1 references age in months (p. 117), EDU-C1 references child_age (p. 84)

**Problem:** Multiple sections reference variables produced by other sections -- `child_age`, `respondent_age`, `is_parent`, `is_pmk`, `marital_status`, `is_bio_mother_young_child`, `province`, `relationship_to_child`, `child_age_months`, `has_siblings`, `is_pmk_or_spouse`, `is_bio_mother`, `is_bio_father` -- but these are never formally declared in the source questionnaire. The CAPI system maintains implicit state across sections. The system "knows" who the PMK is, what province the household is in, and the child's exact age, but this knowledge exists in the runtime environment, not in the questionnaire text.

**In the imperative version:** The CAPI system resolves variable references against its internal data model. The questionnaire author writes "IF RESPONDENT IS THE FEMALE BIOLOGICAL PARENT" and the system evaluates this against pre-loaded roster data.

**In the declarative version:** Each standalone QML file must declare these cross-section dependencies in its `codeInit`. Across the 23 files, 15+ undocumented cross-section variables had to be reconstructed. This is the single largest source of conversion complexity: the questionnaire has no variable dictionary, no formal data model, and no cross-reference between sections.

### P4: Extremely Complex Custody Routing

**Severity:** HIGH
**PDF evidence:** pp. 130-155 (CUS section: 118 items, 25 routing checks, ~326 dependencies)

**Problem:** The CUS section implements a routing tree covering family history from birth through current custody arrangements. The routing depends on a cascade of prior answers across 13 sub-sections:

1. Living arrangement at birth (Q1A-Q1G)
2. Whether parents were together (Q2-Q2B)
3. Whether parents were married (Q3)
4. Death of a parent (Q9A/Q9B)
5. Separation details (Q10-Q10D)
6. Custody arrangements (Q11A-Q11F)
7. Child's living arrangements since separation (Q12-Q14)
8. Mother's new relationships (Q15-Q17D)
9. Father's new relationships (Q18-Q20D)
10. Multiple separations and reunions

Additionally, the questionnaire includes system-level optimization checks -- "IF ELDEST SELECTED CHILD" shortcuts that allow sibling data to be copied rather than re-collected. These efficiency shortcuts conflate routing logic with data management optimization, making the routing tree harder to verify.

**In the imperative version:** The 25 routing checks (CUS-C1A, C1B, C1D, C1E, C3, C4, C6, C8, C10, etc.) are executed sequentially by the CAPI system. Each check is locally simple but the accumulated routing creates 326 inter-item dependencies.

**In the declarative version:** The QML expresses this as 93 items with 93 preconditions and 9 routing variables (parents_together, parents_separated, parent_died, parents_were_married, mother_new_union, father_new_union, child_lived_with_respondent, custody_type, parents_lived_together_ever). The Z3 solver confirms all items are reachable (0 NEVER), but the dependency count (326) is by far the highest of any section -- nearly 60% of all dependencies in the entire questionnaire. The opacity of this routing makes it impossible to verify completeness from the source document alone without running formal analysis.

### P5: Missing Explicit Filter Gates in Age-Tiered Sections

**Severity:** MEDIUM
**PDF evidence:** p. 44 (HLT NOTE with age-tier table), p. 109 (BEH NOTE), p. 117 (MSD age bands), p. 68 (TMP age bands)

**Problem:** The HLT, BEH, MSD, and TMP sections use implicit age-band routing where the "GOTO NEXT SECTION" at band boundaries is the only guard. There are no explicit screener questions -- the CAPI system routes based on pre-loaded age data. A 4-year-old entering the BEH section is routed past the 0-3 battery directly to the 4-9 battery via BEH-C1 ("IF AGE > 3 -> GO TO BEH-I6A"), but this check is a system-internal node, not a question shown to the interviewer.

The Health section is particularly complex, with the NOTE on p. 44 defining four age tiers (0-1, 2-3, 4-5, 6-11), each receiving a different subset of HLT questions. These tiers are enforced entirely through GOTO chains (HLT-C5, HLT-C6, HLT-C6A, HLT-C20, HLT-C22, HLT-C45, HLT-C46, HLT-C52), none of which are visible questions.

**In the imperative version:** The CAPI system silently evaluates age at each check node and routes accordingly. The interviewer sees only the questions appropriate to the child's age.

**In the declarative version:** Every age gate must be injected as an explicit precondition (`child_age >= 4`, `child_age_months >= 22 and child_age_months <= 47`, etc.). The questionnaire has no self-documenting filter mechanism; the declarative version must externally inject the age variable and reconstruct the tier boundaries from the routing instructions.

### P6: Redundant Administration Items

**Severity:** LOW
**PDF evidence:** pp. 25-26 (H05-P1: interview mode, H05-P2: interview language), pp. 3-4 (CONT-Q2: language preference), p. 8 (HHLD-Q8: interview language)

**Problem:** H05-P1 (interview mode: telephone/in person) and H05-P2 (interview language) duplicate information already present in the questionnaire. CONT-Q2 asks the respondent's language preference at the start; HHLD-Q8 records the language of interview in the household section. H05-P2 records the same information a third time in the Administration section. Similarly, the interview mode (telephone vs. in person) is implicitly known from the survey design (CAPI means in-person).

These are interviewer metadata fields appearing in separate locations without cross-referencing. There is no routing instruction that says "IF ALREADY RECORDED, SKIP."

**In the declarative version:** These items appear as standalone questions with no precondition linking them to their earlier counterparts. The structural duplication is visible but not flagged by the Z3 solver because the items are independent (no shared postconditions or mutual exclusivity constraints).

### P7: Inconsistent DK/Refusal Routing Across Sections

**Severity:** MEDIUM
**PDF evidence:** p. 33 (FNC-Q1A: "9=REFUSAL GO TO NEXT SECTION"), p. 38 (SUP-Q1A: "9=REFUSAL GO TO SUP-Q2A"), p. 35 (SAF-Q5A: "9=REFUSAL GO TO NEXT SECTION"), p. 109 (BEH-Q1: "9=REFUSAL GO TO BEH-C5"), p. 130 (CUS throughout), p. 31 (CHLT-Q12A: "9=REFUSAL GO TO CHLT-STOP")

**Problem:** REFUSAL responses are routed inconsistently across sections:

| Section | First REFUSAL Point | Effect |
|---------|---------------------|--------|
| Family Functioning (FNC) | FNC-Q1A | Skips **entire** 12-item FAD battery + marital satisfaction |
| Social Support (SUP) | SUP-Q1A | Skips to SUP-Q2A only (preserves professional help subsection) |
| Neighbourhood (SAF) | SAF-Q5A | Skips **entire** safety/cohesion/problems batteries |
| Behaviour (BEH) | BEH-Q1 | Skips within section (to next age-appropriate sub-battery) |
| Adult Health (CHLT) | CHLT-Q12A | Skips CES-D depression scale only |
| Custody (CUS) | Various | Skips to child care section |

A single REFUSAL at FNC-Q1A (one of 12 family functioning items) causes the entire 12-item battery plus the marital satisfaction question to be skipped, while in SUP a REFUSAL at the first item only skips the personal support sub-battery, preserving the professional help questions. There is no documented rationale for why some sections treat REFUSAL as "abandon this topic entirely" and others treat it as "skip to next sub-topic."

**In the declarative version:** REFUSAL is not a standard QML response code. These hidden skip paths are invisible to the validator, meaning the inconsistent treatment of refusals cannot be formally verified. The asymmetry becomes visible only through manual comparison of GOTO annotations in the inventory.

## Cross-Check Fixes (QML Authoring Errors)

| # | Item(s) | Error | Fix | PDF Reference |
|---|---------|-------|-----|---------------|
| 1 | RESTR/CHRON blocks | Initially used `child_age >= 12` instead of `respondent_age >= 12` for RESTR-CINT and CHRON-CINT gates | Corrected after judgement agent review to `respondent_age >= 12`; these gates filter adult respondents, not children | pp. 9, 11 |
| 2 | HLT vision items | HLT-C6A routing direction ambiguity -- NOTE says ages 4-5 get Q6A (storybook), but GOTO sends ages "< 6" to Q6A | Resolved using NOTE interpretation: Q6A for ages 4-5, Q6 for ages 6+ | pp. 44-45 |
| 3 | MSD sliding window | Each milestone question appeared in multiple overlapping age bands requiring union-of-bands preconditions | Computed minimum and maximum month ranges across all 8 bands for each question | p. 117 |
| 4 | BEH battery compression | 48 behaviour items (Q6A-Q6UU) all use identical 3-point scale | Compressed into QuestionGroup with 48 sub-questions in a single QML item | pp. 110-114 |
| 5 | CUS elder-child shortcuts | CUS-C1A/C1B/C1D/C1E "eldest selected child" sibling shortcuts not fully modelable | Simplified to run full custody path for all respondents; noted as limitation since sibling data copying is a runtime optimization | p. 130 |
| 6 | Province routing (EDU) | 6 province variants per grade question required mutual exclusivity | Modeled with mutually exclusive preconditions on `province` variable | pp. 84-100 |

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| **Age-reference ambiguity** | CAPI system resolves "IF AGE<12" against current-person context | Must choose explicit variable (`respondent_age` vs `child_age`); ambiguity forced into the open |
| **Cross-section variables** | CAPI maintains implicit state -- PMK identity, province, child age in months all "just work" | Each of 23 files must declare its dependencies in `codeInit`; 15+ undocumented variables reconstructed |
| **Custody complexity** | 25 sequential GOTO checks evaluated by system; locally simple | 326 dependencies exposed in dependency graph; verified reachable but opacity confirmed |
| **Age-tier routing** | Silent GOTO at band boundaries; interviewer sees only relevant questions | Explicit preconditions per item; age tiers become a design artifact visible in the precondition structure |
| **Province variants (EDU)** | 6 province-specific GOTO paths on separate pages | 6-way precondition branching makes duplication explicit; 18 items where 3 would suffice |
| **REFUSAL asymmetry** | Each REFUSAL has its own GOTO target; inconsistency spread across 161 pages | Not expressible in QML; asymmetry invisible to formal verification but documented in inventory |
| **Sliding window (MSD)** | Each age band has single GOTO entry/exit; overlap implicit | Must compute union of all bands per question; overlap made explicit in preconditions |
| **Section isolation** | Sections appear independent but share implicit state | 23 standalone files make cross-section dependencies structurally visible through `codeInit` declarations |

## Conclusion

The Z3 QML validator found the NLSCY Cycle 1 questionnaire to be **structurally valid** across all 23 section files: no dependency cycles (0 cycles), no unreachable items (0 NEVER), no infeasible postconditions (0 INFEASIBLE), and at least one valid completion path (SAT) in every section. The 536-item QML representation across 112 blocks covers the full scope of the 161-page CAPI questionnaire.

The declarative conversion exposed **7 categories of design issues** in the original questionnaire:

1. **P1 (MEDIUM):** Ambiguous age-reference scope -- "IF AGE<12" is ambiguous when both child age and respondent age coexist; the CAPI system resolves this implicitly but the declarative model cannot
2. **P2 (LOW):** Province-specific grade questions create 18 variants where 3 parameterized questions would suffice
3. **P3 (MEDIUM):** 15+ phantom cross-section variables that exist only in the CAPI runtime environment, never formally declared in the questionnaire
4. **P4 (HIGH):** Custody section routing (326 dependencies, 93 items, 9 routing variables) is too opaque to verify from the source document alone without formal analysis
5. **P5 (MEDIUM):** Four age-tiered sections (HLT, BEH, MSD, TMP) rely on implicit CAPI age-band routing with no self-documenting filter gates
6. **P6 (LOW):** Redundant administration items record interview language in three separate locations without cross-referencing
7. **P7 (MEDIUM):** REFUSAL routing is asymmetric across sections -- some skip entire batteries, others skip only sub-sections, with no documented rationale for the inconsistency

The NLSCY's structural soundness (no cycles, no dead code) stems from its use of **child age as a one-directional routing variable** -- set once at household record completion and never modified by downstream items. This is a strong design pattern that avoids the feedback loops found in employment-based surveys (e.g., the LFS PATH variable). However, the age-tiered design creates substantial structural complexity: 474 of 536 items (88%) are CONDITIONAL, the custody section alone accounts for 326 of 573 total dependencies (57%), and the questionnaire's reliance on implicit CAPI state means 15+ cross-section variables had to be reverse-engineered from routing instructions during conversion.
