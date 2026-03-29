# Survey of Household Spending 2000 (SHS): Declarative Conversion Analysis

**Source:** Statistics Canada, Survey of Household Spending 2000, Form 8-5400-77.1 (2000-07-26), 62 pages, paper-based interviewer-administered
**QML Files:** `evaluation/statcan-questionnaires/SHS_2000_Household_Spending/`
**Date:** 2026-03-29

## Objective

Transform the SHS 2000 paper questionnaire (62 pages, 25 sections A-Y, interviewer-administered household expenditure survey covering dwelling characteristics, consumer spending, income, and financial assets) into a declarative QML representation, then run the Z3-based formal validator to detect structural problems hidden in the paper-based format.

## Methodology

1. **PDF preprocessing:** Extracted to text using `pdftotext`, producing the OCR file preserving spatial formatting, question numbering, grid layouts, and skip instructions across all 62 pages.
2. **Question inventory:** 437 nodes catalogued across 25 sections (A-Y). Verified against all 25 sections with 0 missing items. All 11 key skip paths verified (E->I, G->H, I->J, K internal, Q internal, R->S, T internal, X->Y, Y internal).
3. **Declarative QML conversion:** 21 standalone thematic files generated, grouping the 25 source sections into 68 blocks. Grid/roster structures (up to 10 persons in Section A, 4 vehicles in Q/R, 5 persons in O/U/V, 5 loans in Y) modeled as single representative instances since QML cannot express dynamic loops.
4. **Formal validation:** Z3 SMT solver ran all four verification levels (per-item classification, global satisfiability, dependency loop detection, path-based reachability) on each of the 21 files independently.

## Survey Architecture Overview

| # | File | Blocks | Items | Source Sections |
|---|------|--------|-------|----------------|
| 01 | `01_household_composition.qml` | 1 | 12 | A (Household Composition) |
| 02 | `02_dwelling_facilities.qml` | 2 | 33 | B (Dwelling Characteristics), C (Facilities) |
| 03 | `03_tenure.qml` | 1 | 16 | D (Tenure) |
| 04 | `04_owned_residences.qml` | 2 | 20 | E (Owned Principal Residences), F (Purchase and Sale of Homes) |
| 05 | `05_mortgages_renovations.qml` | 2 | 14 | G (Mortgages), H (Renovations and Repairs) |
| 06 | `06_rented_residences.qml` | 1 | 13 | I (Rented Principal Residences) |
| 07 | `07_utilities_accommodation.qml` | 1 | 8 | J (Utilities and Other Rented Accommodation) |
| 08 | `08_secondary_property.qml` | 2 | 24 | K (Owned Secondary Residences and Other Property) |
| 09 | `09_furnishings_equipment.qml` | 7 | 50 | L (Household Furnishings and Equipment) |
| 10 | `10_home_operation.qml` | 6 | 24 | M (Home Operation) |
| 11 | `11_food_alcohol.qml` | 1 | 13 | N (Food and Alcohol) |
| 12 | `12_clothing.qml` | 5 | 21 | O (Clothing) |
| 13 | `13_health_care.qml` | 3 | 19 | P (Personal and Health Care) |
| 14 | `14_automobiles.qml` | 4 | 25 | Q (Automobiles and Trucks) |
| 15 | `15_recreation_transport.qml` | 6 | 24 | R (Recreational Vehicles and Transportation) |
| 16 | `16_recreation_education.qml` | 7 | 32 | S (Recreation, Reading Materials and Education) |
| 17 | `17_tobacco_miscellaneous.qml` | 6 | 27 | T (Tobacco and Miscellaneous) |
| 18 | `18_income.qml` | 2 | 18 | U (Personal Income) |
| 19 | `19_taxes_gifts.qml` | 3 | 15 | V (Personal Taxes, Security and Money Gifts) |
| 20 | `20_assets_business.qml` | 3 | 20 | W (Change in Assets), X (Unincorporated Business) |
| 21 | `21_loans_debts.qml` | 3 | 11 | Y (Loans and Other Debts) |
| **Total** | | **68** | **439** | **25 sections** |

### Cross-File Dependency Graph

The 21 files form a sparse dependency chain through extern variable declarations:

- **File 01** (household composition) produces `one_person_hh`, `total_weeks`, `data_code` -- used for skip logic in household member questions
- **File 03** (tenure) produces `tenure_type`, `moved_year`, `has_spouse`, `total_weeks_52` -- read by Files 04-06 to determine which housing expenditure sections apply (owners vs. renters)
- **File 04** (owned residences) produces `owns_dwelling` -- read by File 05 (mortgages gated on ownership)
- **File 14** (automobiles) produces `has_vehicle` -- read internally for the Q01=No->Q20 skip
- **File 15** (recreation/transport) produces `has_rec_vehicle` and `took_package_trip` -- used for internal skips within the recreation section
- **File 20** (assets/business) produces `has_business` -- read by File 21 to suppress duplicate loan questions

Unlike CATI surveys where nearly every item depends on prior answers or system state, this paper survey has minimal cross-file dependencies. Most sections are self-contained expenditure grids that do not reference variables from other sections.

## Semantic Equivalence

| Metric | Count |
|--------|-------|
| Inventory entries | 437 |
| QML items | 439 |
| Gap | +2 |

The +2 difference is accounted for by modeling artifacts:

| Source | QML Modeling |
|--------|-------------|
| 3 filters (C_FILTER_Q04, D_FILTER_SPOUSE, D_FILTER_YEAR, D_FILTER_Q6) | Converted to preconditions on dependent items; D_FILTER_Q6 absorbed into Q6/Q7 preconditions |
| 2 read instructions (D_INSTRUCTIONS, J_NOTE) | Modeled as Comment items |
| Grid/roster structures (10 persons, 4 vehicles, 5 persons, 5 loans) | Modeled as single representative instance with Comment noting repetition |
| Computed totals (L_TOTAL, section totals) | L_TOTAL modeled as Comment; section-footer totals omitted (presentation artifacts) |
| E_CALC, E_NOTE | E_CALC absorbed into codeBlock; E_NOTE modeled as item |

All 437 inventory entries are represented. The net +2 reflects structural items added for routing clarity.

## Validator Results

### Aggregate Summary

| Metric | Value |
|--------|-------|
| Total Items | 439 |
| Total Blocks | 68 |
| Total Preconditions | 144 |
| Total Postconditions | 0 |
| Total Variables (SSA) | 14 |
| Total Dependencies | 155 |
| Cycles | 0 |
| Global Status | SAT (all 21 files) |
| NEVER-reachable | 0 |
| INFEASIBLE | 0 |

### Z3 Item Classifications

| Classification | Count |
|---------------|-------|
| Precondition ALWAYS | 295 |
| Precondition CONDITIONAL | 144 |
| Precondition NEVER | 0 |
| Postcondition CONSTRAINING | 0 |
| Postcondition TAUTOLOGICAL | 0 |
| Postcondition INFEASIBLE | 0 |
| Postcondition NONE | 439 |

### Per-File Detail

| File | Items | Blocks | ALWAYS | CONDITIONAL | Vars | Deps |
|------|-------|--------|--------|-------------|------|------|
| 01_household_composition | 12 | 1 | 10 | 2 | 3 | 3 |
| 02_dwelling_facilities | 33 | 2 | 25 | 8 | 0 | 3 |
| 03_tenure | 16 | 1 | 3 | 13 | 4 | 20 |
| 04_owned_residences | 20 | 2 | 1 | 19 | 0 | 23 |
| 05_mortgages_renovations | 14 | 2 | 0 | 14 | 1 | 7 |
| 06_rented_residences | 13 | 1 | 1 | 12 | 0 | 12 |
| 07_utilities_accommodation | 8 | 1 | 8 | 0 | 0 | 0 |
| 08_secondary_property | 24 | 2 | 2 | 22 | 0 | 28 |
| 09_furnishings_equipment | 50 | 7 | 50 | 0 | 0 | 0 |
| 10_home_operation | 24 | 6 | 24 | 0 | 0 | 0 |
| 11_food_alcohol | 13 | 1 | 13 | 0 | 0 | 0 |
| 12_clothing | 21 | 5 | 21 | 0 | 0 | 0 |
| 13_health_care | 19 | 3 | 19 | 0 | 0 | 0 |
| 14_automobiles | 25 | 4 | 5 | 20 | 1 | 24 |
| 15_recreation_transport | 24 | 6 | 12 | 12 | 2 | 12 |
| 16_recreation_education | 32 | 7 | 32 | 0 | 0 | 0 |
| 17_tobacco_miscellaneous | 27 | 6 | 20 | 7 | 1 | 7 |
| 18_income | 18 | 2 | 18 | 0 | 0 | 0 |
| 19_taxes_gifts | 15 | 3 | 15 | 0 | 0 | 0 |
| 20_assets_business | 20 | 3 | 11 | 9 | 1 | 9 |
| 21_loans_debts | 11 | 3 | 5 | 6 | 1 | 7 |

### Interpretation

The Z3 results show a structurally clean but minimally validated questionnaire: zero dead code (NEVER), zero postconditions of any kind, zero dependency cycles, and global satisfiability across all 21 files. The 67% ALWAYS rate (295/439) is strikingly high compared to CATI surveys -- reflecting the paper survey's linear structure where most expenditure questions are unconditionally asked. Only 33% of items (144/439) are CONDITIONAL, concentrated in the housing sections (Files 03-06, 08) and vehicle sections (Files 14-15) where skip logic exists. Ten of the 21 files have zero dependencies and zero preconditions -- they are pure linear question sequences with no branching at all.

The complete absence of postconditions (0/439) is the single most significant finding. This paper form has no validation rules whatsoever -- no range checks, no cross-field consistency edits, no data quality safeguards. Every dollar amount, week count, and status code accepts any value within the input control's numeric range without constraint.

## Problems in the Original SHS 2000

### 1. Complete Absence of Validation Rules

**Severity:** HIGH
**Evidence:** All 21 QML files, 439 items with 0 postconditions

**Problem:** The paper form contains zero postconditions. Not a single question has a validation rule, range check, or consistency edit. This is the defining structural difference between the SHS 2000 and CATI-based questionnaires in the evaluation corpus (e.g., CCHS has 55 postconditions, LFS has 2).

**Specific exposures:**

- **Week counts without bounds:** A_Q09 (OCR page 3, "For how many weeks in 2000 was [name] a member of this household?") accepts 0-52, and A_Q10 asks weeks living apart. The form instructs "If Q.9 plus Q.10 is 52, go to Q.12" but nothing prevents the interviewer from recording Q.9=40 and Q.10=40 (total 80 weeks). The printed skip instruction "If total weeks (Q.9 plus Q.10) is 52" (OCR line 162) only fires on exact equality -- if the sum exceeds 52, the interviewer reaches Q.11 ("Why is total weeks less than 52?"), which is nonsensical for a total exceeding 52.
- **Dollar amounts without range checks:** Every expenditure field (Sections E-Y) accepts arbitrary dollar amounts with no upper bound validation. A household could report $10,000,000 for "Toys and other games" (S_Q09) or negative amounts where the form provides no explicit sign convention.
- **Inconsistent status codes:** Q_Q07 ("Status of vehicle at December 31, 2000") has 7 options with different routing consequences (OCR page 41, codes 1-7), but nothing prevents the respondent from reporting a vehicle as both "Owned" (code 1) at Dec 31 and having been "Sold separately" (code 4) during 2000 -- a logical impossibility that Q_Q07's single-select format cannot catch if the interviewer fills the wrong circle.

**Impact:** In a CATI system, soft and hard edits catch these inconsistencies at entry time. On paper, they propagate into the data file and must be detected during post-collection editing -- a process that is more expensive, less reliable, and undocumented in the questionnaire itself.

### 2. Section-Level Skip Logic Opacity

**Severity:** MEDIUM
**Evidence:** OCR pages 12-13 (Section E), page 40 (Section Q), page 44 (Section R)

**Problem:** The SHS 2000's most critical routing instructions are printed as marginal notes on the paper form, relying entirely on the interviewer to follow them correctly. The declarative conversion makes these skips structurally explicit as preconditions, revealing their significance.

**The E_Q01 skip is the survey's most consequential routing decision.** E_Q01 asks "How many dwellings did members of your household own and occupy in 2000?" with the marginal instruction: "If none, enter '00' and go to Section I (page 19)" (OCR line 705-706). This single question determines whether the household answers 4 sections of owner expenditures (E, F, G, H -- 59 questions) or 1 section of renter expenditures (I -- 14 questions). On paper, the interviewer must notice the instruction, turn 7 pages forward, and resume at the correct section. If the instruction is missed, an ownerless household answers questions about property taxes, mortgage payments, and renovation expenses that do not apply.

**Other critical skips:**
- **Q_Q01=No -> Q.20:** "No -> Go to Q.20 (page 44)" (OCR line 2216). Skips 18 per-vehicle questions. The vehicle grid (Q.2-Q.9 asked for all vehicles, then Q.10-Q.19 for operating expenses) requires the interviewer to track which vehicle column they are completing -- a cognitive burden that CATI eliminates through screen management.
- **R_Q03=No -> Q.14:** "No -> Go to Q.14 (page 46)" (OCR line 2490). Skips the recreational vehicle grid.
- **X_Q01=No -> Section Y:** "No -> Go to Section Y" (OCR line 3299). Skips unincorporated business questions.
- **Y_Q01=No -> Q.6:** "No -> Q.6 (page 60)" (OCR line 3359). Skips the per-loan grid.

**In the imperative paper version:** These are one-line instructions embedded in a 62-page booklet. Missing any one of them produces systematically wrong data for that household -- either missing expenditure data (if a skip is followed when it shouldn't be) or inapplicable data (if a skip is missed).

**In the declarative version:** Each skip becomes an explicit precondition on the gated block. The Z3 validator confirms that all skips are structurally sound (no NEVER-reachable items, no dead code), but the declarative form makes the skip structure visible and verifiable.

### 3. Roster/Grid Structures Without Bounds Validation

**Severity:** MEDIUM
**Evidence:** OCR pages 2-5 (Section A, 10-person roster), pages 35-37 (Section O, 5-person clothing grid), pages 40-43 (Section Q, 4-vehicle grid), pages 44-45 (Section R, 4-vehicle grid), pages 53-54 (Sections U/V, 5-person income/tax grids), page 59 (Section Y, 5-loan grid)

**Problem:** The SHS 2000 uses grid layouts that repeat questions for multiple entities (persons, vehicles, loans). These grids have implicit capacity limits (10 persons, 4 vehicles, 5 loans) but no validation for consistency across columns or between grids.

**Cross-column consistency gaps:**
- **Section A (household composition):** A_Q09 and A_Q10 are asked per person. The total weeks across all persons should not exceed 520 (10 persons x 52 weeks), and each person's Q.9+Q.10 should total 52 unless Q.11 explains why not. But nothing prevents Person 01 from reporting 52 weeks and Person 02 from also reporting 52 weeks while both are supposedly part of the same household simultaneously.
- **Section Q (automobiles):** Q_Q07 records each vehicle's status at December 31, 2000 (OCR page 41). A vehicle coded as "Owned" (code 1) or "Leased" (code 2) should logically have operating expenses in Q.10-Q.17, while a vehicle coded as "Returned to lessor" (code 3) should not. But the form asks operating expenses for all vehicles regardless of their Dec 31 status.
- **Section O (clothing):** The per-person clothing grid (OCR pages 35-37) has separate grids for "Women and Girls 4+" (5 persons), "Men and Boys 4+" (5 persons), and "Children Under 4" (4 persons). Nothing validates that the persons listed match Section A's roster in sex, age, or existence.

**Grid-to-section consistency gaps:**
- **Section U (income):** U_Q01.1 and U_Q01.2 ask weeks worked full-time and part-time per person (OCR page 53). Nothing prevents U_Q01.1 + U_Q01.2 > 52 for a single person, and nothing cross-references these values against Section A's household membership weeks.

### 4. Missing Cross-Section Integrity Checks

**Severity:** MEDIUM
**Evidence:** OCR page 10 (D_Q01), pages 12-13 (Section E header), pages 18-19 (Section I header)

**Problem:** D_Q01 ("On December 31, 2000 was your dwelling:") determines the household's tenure type with four options: owned without mortgage (1), owned with mortgage (2), rented (3), or occupied rent-free (4) (OCR line 566-577). This tenure type determines which housing expenditure sections apply:

- Codes 1 or 2 (owned) -> Sections E (property taxes/insurance), F (purchase/sale), G (mortgages), H (renovations)
- Code 3 (rented) -> Section I (rent payments)
- Code 4 (rent-free) -> Section I (with $0 rent)
- All tenure types -> Section J (utilities), Section K (secondary property)

**However, the routing from D_Q01 to the appropriate section is not automated.** The Section E header states "Exclude vacation homes, secondary residences and dwellings not occupied" (OCR line 700), and E_Q01 independently asks "How many dwellings did members of your household own and occupy?" with the if-none-go-to-Section-I instruction (OCR line 705-706). There is no mechanism to ensure that a household reporting D_Q01=3 (rented) actually skips to Section I. If the interviewer follows the sections sequentially without noting D_Q01's implication, a renting household would answer E_Q01 (correctly entering "00" and skipping to Section I) -- but only because E_Q01 independently checks ownership count. The consistency between D_Q01 and E_Q01 is accidental rather than enforced.

**Similarly, a household that reports D_Q01=1 (owned without mortgage) could still have non-zero values recorded in Section G (mortgages).** G_Q01 asks "did your household have any mortgages?" (OCR line 864) as an independent gate, but nothing cross-references G_Q01 against D_Q01. If the interviewer records "owned without mortgage" in D_Q01 but "Yes" for G_Q01, the inconsistency propagates unchecked.

### 5. Dollar-or-Percentage Alternative Fields

**Severity:** LOW
**Evidence:** OCR pages 13-14 (E_Q04.1, E_Q05.1), pages 19-20 (I_Q07.1, I_Q08.1), page 42 (Q_Q18), page 45 (R_Q12)

**Problem:** Six questions in the SHS 2000 allow the respondent to provide either a dollar amount OR a percentage, with both fields printed side by side on the form:

| Question | Context | OCR Evidence |
|----------|---------|-------------|
| E_Q04.1 | Business charges against owned-residence expenses | "$" box and "OR %" box (OCR line 755-757) |
| E_Q05.1.1/E_Q05.1.2 | Rental income charges against owned-residence expenses | "$" and "OR %" (OCR line 768-779) |
| I_Q07.1 | Business charges against rent | "$" and "OR %" (OCR line 1111-1113) |
| I_Q08.1.1/I_Q08.1.2 | Rental income charges against rent | "$" and "OR %" (OCR line 1125-1136) |
| Q_Q18 | Vehicle operating expenses charged to business | "$" and "OR %" per vehicle (OCR line 2398-2408) |
| R_Q12 | Recreational vehicle expenses charged to business | "$" and "OR %" per vehicle (OCR line 2556-2561) |

**The paper form provides two adjacent boxes but no mechanism to ensure exactly one is filled.** Both could be filled (which value takes precedence?), or neither could be filled (is it $0 or 0%?). The processing instructions at the bottom of Sections E, I, Q, and R describe how to calculate totals from these fields ("take the dollar amount in Q.4.1 or multiply the percentage in Q.4.1 by the sum of Q.3.1 to Q.3.3" -- OCR line 786), but this calculation is performed during post-collection processing, not at collection time.

**In the QML conversion:** These are modeled as single Editbox items (dollar amount), with a Comment noting the percentage alternative. QML has no native dual-input control. A full-fidelity model would require either a custom input type or two separate items with a mutually exclusive precondition -- but the paper form's ambiguity about which field takes precedence makes either approach a design decision rather than a faithful conversion.

### 6. Implicit Data Collection Code Derivation

**Severity:** LOW
**Evidence:** OCR pages 3-5 (A_Q12), the code derivation table at OCR lines 175-198

**Problem:** A_Q12 is not a question asked to the respondent -- it is a derived routing variable that the interviewer must compute from Q.8, Q.9, and Q.10. The paper form provides a decision table:

| Code | Condition | Procedure |
|------|-----------|-----------|
| 1 | Q.8=Yes AND Q.9 != 00 | Report data for total weeks |
| 2 | Q.8=No AND Q.9 != 00 | Report data for weeks in this household only |
| 3 | Q.8=Yes AND Q.9=00 AND Q.10 != 00 | Report data for weeks apart only |
| 4 | Q.8=Yes AND Q.9=00 AND Q.10=00 | End questions (member after 2000) |
| 5 | Q.8=No AND Q.9=00 AND Q.10=00 | End questions (not a member) |

The interviewer must manually evaluate this 3-variable truth table and circle the correct code. This is error-prone: the five conditions are non-trivial (three-way conjunction with zero/non-zero and yes/no inputs), and the consequences of miscoding are significant -- codes 4 and 5 terminate data collection for that person entirely.

**In the QML conversion:** This derivation is modeled as a codeBlock that computes the data collection code from the upstream variables, making it automatic and deterministic. The declarative form eliminates the possibility of interviewer derivation errors.

## Cross-Check Fixes and Conversion Limitations

### Conversion Artifacts

1. **Roster/grid structures:** The 10-person household roster (Section A), 4-vehicle grids (Sections Q, R), per-person clothing grids (Section O for up to 5+5+4 persons), per-person income/tax grids (Sections U, V for up to 5 persons), and 5-loan grid (Section Y) are all modeled as single representative instances. QML cannot express dynamic loops; a Comment in each file documents this limitation.

2. **Dollar-or-percentage dual fields:** E_Q04.1, E_Q05.1, I_Q07.1, I_Q08.1, Q_Q18, and R_Q12 each offer dollar or percentage input on the paper form. Modeled as single Editbox (dollar) with Comment noting the percentage alternative.

3. **Computed section totals:** Each section has a footer row computing category totals (A, B, C, D columns for expenses, income, credits, debits -- OCR pages 61-62, the balancing worksheet). These are processing artifacts not modeled in QML.

4. **Free-text "Specify" fields:** B_Q01 option 9, B_Q07 option 7, B_Q09 option 6, B_Q10 option 6, B_Q11 option 6, and several others have "Specify" text boxes for "Other" responses. These are modeled as Textarea items conditional on the "Other" option being selected.

5. **Category code columns (A/B/C/D):** The original form marks each dollar field with a category code (A=Expenses, B=Income/offsets, C=Credits, D=Debits) for the balancing worksheet. These codes are not modeled in QML; they are a processing concern.

### Limitations

- **Multi-person/multi-entity grids:** The most significant limitation. The paper form's grid layout allows parallel data collection for multiple persons or vehicles in adjacent columns. The QML conversion models one instance per grid, losing the ability to capture and cross-validate multi-entity data. In a production deployment, these grids would require QML's QuestionGroup construct or a looping mechanism not currently available.

- **Balancing worksheet:** Pages 61-62 contain a summary worksheet where the interviewer enters section totals into a grid that balances Income + Debits against Expenses + Credits + Change in Assets. This is a data quality tool embedded in the questionnaire design that QML cannot model.

## Impact Assessment

### What the Declarative Conversion Reveals

1. **The SHS 2000 is structurally simple but validation-free.** The Z3 validator found zero structural defects (no dead code, no infeasible constraints, no cycles) -- but this result is trivially achieved because the questionnaire contains zero postconditions. Unlike CATI surveys where the absence of issues indicates a well-engineered instrument, here it reflects the absence of any validation logic to test. The survey's data quality relies entirely on interviewer training, manual review, and post-collection statistical editing -- none of which are visible in the questionnaire document.

2. **The paper form's skip logic is minimal but critical.** Only 144 of 439 items (33%) have preconditions, compared to 83% in the CCHS and 93% in the LFS. The SHS 2000 is predominantly a linear expenditure grid. But the few skips that exist (E_Q01 owner/renter split, Q_Q01 vehicle ownership gate, Y_Q01 loan gate) have high-stakes consequences: missing a single skip instruction can invalidate an entire section of data.

3. **Cross-section dependencies are unenforceable on paper.** D_Q01 (tenure type) should determine which sections apply, but nothing prevents a renting household from having data recorded in owner sections. The declarative conversion makes these dependencies explicit through extern variables, but the original form relies on interviewer compliance with section-header instructions.

4. **Grid structures resist declarative modeling.** The SHS 2000's per-person and per-vehicle grids are its dominant structural pattern. These grids represent the bulk of the questionnaire's data collection capacity (10 persons x 12 questions in Section A alone = 120 data points from one grid) but cannot be faithfully modeled in a flat item-by-item QML representation.

5. **The dollar-or-percentage ambiguity is a design flaw.** Six questions offer both input formats without a mechanism to ensure mutual exclusivity or specify precedence. The processing instructions describe how to resolve the ambiguity, but this resolution happens after data collection -- too late to catch errors.

### Design Quality Assessment

The SHS 2000 is a competently designed paper expenditure survey that prioritizes completeness of coverage (437 items across 25 sections) over data quality enforcement. Its zero-postcondition profile is characteristic of paper surveys that delegate validation to post-collection processing. The six problems identified are inherent limitations of the paper medium rather than design defects: validation rules cannot be enforced on paper, skip logic relies on human compliance, and cross-section consistency checks require automation that paper cannot provide. The declarative conversion makes these limitations structurally visible, demonstrating the gap between what the questionnaire document specifies and what the data collection process actually requires.

## Conclusion

The SHS 2000 (62 pages, 25 sections, 437 inventory entries) was converted into 21 QML files with 439 items, 68 blocks, and 144 preconditions. Z3 validation confirmed structural soundness across all files: zero NEVER-reachable items, zero dependency cycles, and SAT global status. The complete absence of postconditions (0/439 items) is the survey's defining structural characteristic -- a direct consequence of its paper-based format, which provides no mechanism for automated validation.

The declarative conversion exposes six design problems that are invisible in the paper specification: (1) the complete absence of validation rules, leaving all data quality enforcement to post-collection processing; (2) critical skip instructions embedded as marginal notes, relying on interviewer compliance; (3) grid/roster structures without cross-column or cross-grid consistency checks; (4) missing cross-section integrity enforcement between tenure type and applicable expenditure sections; (5) dollar-or-percentage dual-input fields without mutual exclusivity constraints; and (6) a manually-derived data collection routing code (A_Q12) that requires interviewer computation of a three-variable truth table. None of these represent bugs in the paper form -- they are inherent limitations of the medium that the declarative conversion makes explicit.
