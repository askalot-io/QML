# NLSCY Cycle 1 (1994-95): Declarative Conversion Analysis

**Source:** Statistics Canada / Human Resources Development Canada, National Longitudinal Survey of Children — Survey Instruments for 1994-95 Data Collection, Cycle 1, Catalogue No. 89F0077XIE, February 1995, 244 pages (main questionnaire pp. 3-161 + Appendices A-F pp. 161-244)
**QML File:** `evaluation/sociology/NLSCY_Children_Youth/NLSCY_Children_Youth.qml` (single consolidated file, qmlVersion 2.0)
**Date:** 2026-07-19 (supersedes the 2026-03-28 report, which covered a retired 23-file layout and the main questionnaire only)

## Objective

Transform the full NLSCY CAPI questionnaire package — the 161-page main instrument (GOTO-based, age-tiered routing for children aged 0-11) **plus its five question-bearing appendices** (child self-report booklet, Teacher's and Principal's mail-back questionnaires, NPHS health module, and administrative KCON/OBS/PPVT sections) — into one declarative QML file, then run the Z3-based formal validator to detect structural problems hidden in the imperative version.

## Methodology

1. **PDF preprocessing**: canonical text intermediate `NLSCY_Children_Youth_text.md` produced by the `askalot-inventory` preprocessor (Claude Sonnet vision on AWS Bedrock, page-parallel extraction). Page-coverage audit (2026-07-19): all 244 pages present, no extraction loss.
2. **Question inventory**: 849 main-body entries across 24 sections plus ~303 appendix entries across 5 appendices, with full routing annotations, a Scope table (Appendix B — the Informed Consent Form — recorded OUT as a procedural signature document), and dedicated **External-input entries** (child sex from the household roster, consent outcome, NPHS/KCON data-collection-period flag). Judgement-verified coverage per section.
3. **Declarative QML conversion**: single consolidated file; the survey's sections and appendices are ordered blocks sharing one `codeInit` scope and one dependency graph. Questionnaire-external values are materialized as admin questions (`b_appendix_admin`, plus the age/PMK/relationship admin items in the main body) pending first-class external-input support (askalot-io/askalot#171).
4. **Formal validation**: full four-level hierarchy (per-item classification + lint channel, global satisfiability, cycle detection, path-based accumulated reachability) via `validate_qml.py`. Exit code 0.
5. **History**: the 2026-06 QML 2.0 consolidation dropped extern wiring (9 frozen variables, 188 statically-dead items) — repaired 2026-07-19 by rewiring gates to producing questions/admin items. The appendices, absent from both the original inventory and QML (a recurrence of the historically documented appendix loss), were inventoried and converted 2026-07-19. Both defect classes are conversion-side, not source defects.

## Survey Architecture Overview

The package has five major parts. **Child age** (0-11 years) is the primary routing variable, with **child age in months** (0-47) for Motor/Social Development and Temperament, and separate-respondent instruments in the appendices.

### Part 1-4: Main questionnaire (pp. 3-161)

| Part | Sections | Pages* | Purpose |
|------|----------|-------|---------|
| Household Record | CONT/DEMO/HHLD | 6-9 | Contact, demographics, dwelling, roster |
| General Questionnaire (adults 15+) | RESTR (11), CHRON (13), SOCIO (14-16), EDUC (17-18), LFS (19-23), INCOM (24-26) | 11-26 | Health limitations, conditions, socio-demographics, education, employment, income |
| Parent Questionnaire (PMK/spouse) + Administration | H05 (27), CHLT (30-33), FNC (34-35), SAF (36-38), SUP (39-40) | 27-40 | Administration, adult health incl. CES-D, family functioning (FAD-12), neighbourhood, social support |
| Children's Questionnaire | DVS (42), HLT (43-50), PAR (51-53), CUS (54-70), LIT (76-78), ACT (79-82), BEH (83-90), MSD (91-95), REL (96-98), TMP (101-107), EDU (108-124), MED (135-141), CAR (155-160) | 42-160 | Child health, parenting, custody, literacy, activities, behaviour, development, relationships, temperament, education, medical/biological, child care |

\* Pages are canonical `--- page N ---` markers of the vision extraction (1:1 with PDF
pages). The Children's Questionnaire sections are **interleaved** in the source in the
order shown — not the reading order a printed TOC suggests. The 2026-03 report's page
map did not match this order; all citations below were re-anchored by question ID
against the canonical extraction (2026-07-19 judgement pass).

### Part 5: Appendices (pp. 161-244)

| Appendix | Blocks | Pages | Items | Respondent | Gating |
|----------|--------|-------|-------|-----------|--------|
| A: 10-11 year old self-report | 8 `b_sr_*` | 162-184 | 135 | the child | child age 10-11 + informed consent (admin) |
| B: Informed Consent Form | — | 185-187 | 0 | — | OUT of scope (procedural); consent outcome = `q_adm_consent_selfreport` |
| C: Teacher's Questionnaire | 6 `b_tq_*` | 188-212 | 58 | child's teacher (mail-back) | child in school + form returned (admin) |
| D: Principal's Questionnaire | 5 `b_pq_*` | 213-228 | 42 | school principal (mail-back) | child in school + form returned (admin) |
| E: NPHS Questions (TWOWK/UTIL) | 3 `b_nphs_*` | 229-233 | 22 | PMK about child | integrated NLSC+NPHS collection period (admin) |
| F: Administrative (KCON/TCH/OBS/PPVT) | 4 blocks | 234-244 | ~41 | PMK / interviewer | KCON period-variant selection; PPVT ages 4-5 |

**Totals:** 141 blocks, 786 items (main 540 + appendices ~246 after QuestionGroup compression and justified omissions).

## Semantic Equivalence

| Metric | Count |
|--------|-------|
| Inventory entries (main + appendices) | 849 + ~303 |
| QML items | 786 (batteries compressed into QuestionGroups) |
| Appendix entries matched | all, per independent fidelity judgement (2026-07-19: five appendices CONFIRMED, zero unjustified missing) |
| Justified omissions | see below |

### Justified Omissions

| Category | Items | Reason |
|----------|-------|--------|
| Dynamic roster loop | DEMO-Q1..Q3 person-loop | Household roster construction requires N-person iteration; QML models the roster summary |
| Procedural/admin | H05-P1/P2, Appendix B consent form, Appendix D/C cover identifiers (D-PRINLANG, D-OPNUM, sample-ID header block) | Interviewer metadata / signature form / pre-printed identifiers referenced by no routing |
| Section-complete checks | FNC-C1, SAF-C1, SUP-C1 | "Completed for another household member" — runtime state |
| Provably-unreachable module | UTIL-Q9/Q10 (NPHS adult home-care) | UTIL-C9 gates on age ≥ 18; the selected child is 0-11, so the module can never be administered (see P8) |
| Free-text specify fields | Q27(l)/Q28(r)/Q33 "Other (specify)" (Principal), KCON contact name/address DK/REF codes | Coded capture is primary; Textarea carries no DK/REF code (see P7) |

## Validator Results

### Summary

| Metric | Value |
|--------|-------|
| Items | 786 |
| Blocks | 141 |
| Items with preconditions | 380 (491 predicate lists incl. block-level and multi-predicate items) |
| Items with postconditions | 23 |
| Variables (SSA) | 18 |
| Dependencies | 1,520 |
| Cycles | **0** |
| Global Status | **SAT** |
| Dead Code (accumulated reachability) | **0** |
| Errors | **0** (exit code 0) |

### Z3 Item Classifications

| Classification | Count | Meaning |
|----------------|-------|---------|
| Precondition ALWAYS | 83 | Unconditional entry points (intros, universal items, admin block) |
| Precondition CONDITIONAL | 703 | Gated by age, respondent type, admin flags, or prior answers — all confirmed reachable |
| Precondition NEVER | 0 | No dead code |
| Postcondition CONSTRAINING | 22 | Statically verified relational checks |
| Postcondition TAUTOLOGICAL | 1 | Documented static gap (see Conversion Integrity) |
| Postcondition INFEASIBLE | 0 | No impossible validation rules |

### Conversion Integrity (Lint Channel)

| Check | Result |
|-------|--------|
| undefined_name (fail-open gates) | 0 |
| unreachable_item from frozen variables | 0 (188 in the pre-repair file — conversion defect, fixed 2026-07-19) |
| write_only_variable / pass_through_alias | 0 |
| duplicate_input_bound | 0 |
| tautological_postcondition | 1 (documented, below) |

The single warning is the screener-consistency postcondition on `qg_pq_q27_days` (Principal Q27: a support service answered "not available" must show 0 days/week of use). It uses QuestionGroup outcome subscripts, which the static builder does not lower — the rule **is enforced at runtime** but is outside the static envelope (upstream: askalot-io/askalot#165). All other originally-QuestionGroup constraints (Q7, Q9, Q10, Q32) were scalarized so their checks classify CONSTRAINING.

### Postcondition Audit

| Region | Postcondition items | Constraining | Mined patterns | No-constraint justification |
|--------|--------------------:|-------------:|----------------|------------------------------|
| Main body (24 sections) | 1 (`q_chlt_q9`, adult-health consistency) | 1 | source edit | remainder: attitude/temperament/behaviour batteries (subjective) + CATI sentinel edits not transcribed |
| App. A self-report | 1 (`q_sr_g02`) | 1 | screener-consistency (never-smoked → frequency 0) | Likert batteries subjective; write-in age items carry sentinel escapes |
| App. C Teacher | 8 (grade-range, class counts, experience) | 8 | counts-vs-capacity (Q34/Q35 ≤ Q33 enrolment), temporal-ordering (Q54 at-school ≤ total, grade high ≥ low) | rating batteries subjective |
| App. D Principal | 12 (11 + 1 runtime-only) | 11 | physical-budget (Q7 percentages == 100), counts-vs-capacity (Q9/Q10 ≤ Q8 enrolment; Q23 ≤ Q22 teachers), temporal-ordering (Q32 at-school ≤ total), screener-consistency (Q27, runtime-only) | perception batteries subjective; mid-year flows Q11/Q12 not bounded by the January snapshot (documented in-file) |
| App. E NPHS | 1 (`q_twowk_q4`) | 1 | part-whole (bed days + cut-down days ≤ 14-day window; exclusive per TWOWK-Q3 wording) | utilization counts unrelated |
| App. F | 0 | 0 | — | consent/contact admin, interviewer observations, PPVT ratings (subjective) |
| **Total** | **23** | **22** | | |

22 constraining postconditions across 786 items (2.8%). Note the distribution: **21 of 22 live in the appendices**, and of those, all but two were *mined* from implied relationships (enrolment bounds, experience arithmetic, percentage budgets) rather than transcribed from explicit edits — the original instruments carry almost no machine-checkable consistency rules (the paper-era pattern of deferring consistency to post-collection cleaning).

## Problems in the Original Questionnaire (Exposed by Declarative Conversion)

### P1: Ambiguous Age-Reference Scope in General Questionnaire Gates

**Severity:** MEDIUM
**PDF evidence:** p. 11 (RESTR-CINT: "IF AGE<12, GO TO NEXT SECTION"), p. 13 (CHRON-CINT: "IF AGE<12 OR RESPONDENT IS NOT THE PARENT GO TO NEXT SECTION")

**Problem:** "IF AGE<12" does not specify whose age. In the NLSCY context — surveyed children aged 0-11, household respondents 15+ — these gates refer to the *respondent's* age, but the child-age variable coexists in the CAPI environment, so the phrase is ambiguous on paper. The imperative system resolves it implicitly via the active person record; the declarative model must choose an explicit variable (`q_respondent_age.outcome >= 12`), a choice not derivable from the source text alone.

### P2: Province-Specific Question Proliferation in Education (Child)

**Severity:** LOW
**PDF evidence:** pp. 108-124 (EDU: province routing EDU-C1A p. 108, grade variants Q1/Q1A-Q1E from p. 109, plus Q5/Q5A-Q5E and Q7/Q7A-Q7E variants)

**Problem:** 18 near-identical province variants of three grade questions, differing only in provincial grade naming. Physical page separation hides the duplication in the imperative version; mutually exclusive province preconditions make it structurally explicit in QML. Three parameterized questions with display-label lookup would suffice.

### P3: Undeclared Cross-Section and Cross-Instrument State

**Severity:** MEDIUM
**PDF evidence:** routing throughout references values no question in the flow collects — respondent/child age (p. 11, p. 43), PMK identity (pp. 9, 11), "FEMALE BIOLOGICAL PARENT" (p. 30), marital status (p. 34), province (p. 108), child age in months (p. 91); in the appendices: child sex for the puberty section (pp. 178-179), informed consent (p. 163), pre-printed cover identifiers (pp. 188, 213), and the data-collection-period flag (pp. 230, 235)

**Problem:** The questionnaire has no variable dictionary and no formal data model — the CAPI runtime "just knows" 15+ values that the routing depends on, and the appendix instruments add externally-sourced state (roster sex, consent outcomes, sampling-period flags). None of this is declared anywhere in the source. In the declarative conversion, every such value had to be reverse-engineered and materialized as an explicit admin/preamble question so that gates stay inside the verified envelope; a first-class external-input construct is the proper fix (askalot-io/askalot#171). This was the single largest source of conversion complexity — and the class of state whose mis-wiring caused the (conversion-side) 2026-06 frozen-variable regression.

### P4: Extremely Complex Custody Routing

**Severity:** MEDIUM (downgraded from HIGH on 2026-07-19 judgement review: the validator proves every custody item reachable, so the issue is verification opacity, not data loss or unreachable content)
**PDF evidence:** pp. 54-70 (CUS: 91 CUS-Q question items plus 25 CUS-C routing checks)

**Problem:** The custody section's routing tree spans family history from birth to current arrangements across 13 sub-sections, with "eldest selected child" data-copying shortcuts conflating routing with optimization. In the QML it accounts for by far the largest share of the dependency graph. The Z3 solver confirms every item reachable, but completeness of this routing is impossible to verify from the source document alone — formal analysis is the only practical audit.

### P5: Missing Explicit Filter Gates in Age-Tiered Sections

**Severity:** MEDIUM
**PDF evidence:** pp. 43-44 (HLT age-tier NOTE and HLT-C6), pp. 101-107 (TMP bands), pp. 83-87 (BEH checks, e.g. BEH-C7A "IF AGE < 10"), pp. 91-95 (MSD sliding bands), p. 79 (ACT-C3 "IF AGE < 4")

**Problem:** HLT, BEH, MSD, and TMP route via silent system-internal age checks at band boundaries; there is no self-documenting filter mechanism. The declarative conversion must reconstruct the tier boundaries as explicit preconditions (including union-of-bands ranges for MSD's overlapping windows).

### P6: Redundant Administration Items

**Severity:** LOW
**PDF evidence:** p. 6 (CONT-Q2), p. 9 (HHLD-Q8), p. 27 (H05-P2 "Record language of interview")

**Problem:** Interview language is recorded in three separate places with no cross-referencing or "if already recorded, skip" instruction. (H05-P1, adjacent on p. 27, records interview *mode* — telephone vs in person — which is separately redundant with the survey's CAPI administration design.)

### P7: Inconsistent DK/Refusal Routing Across Sections

**Severity:** MEDIUM
**PDF evidence:** p. 34 (FNC-Q1A: "9=REFUSAL GO TO NEXT SECTION"), p. 39 (SUP-Q1A: "9=REFUSAL GO TO SUP-Q2A"), pp. 36-38 (SAF-Q5A), pp. 83-84 (BEH-Q1), pp. 32-33 (CHLT-Q12A); appendices: KCON DK/REF → NEXT SECTION (pp. 235-236) vs TCH/PPVT 7/8 codes vs KCON/OBS 8/9 codes (pp. 235-243)

**Problem:** REFUSAL at a battery's first item sometimes abandons the whole topic (FNC, SAF), sometimes only a sub-topic (SUP, CHLT), with no documented rationale. The appendices add a second inconsistency: DK/REF code *values* differ by module (KCON/OBS use 8/9; TCH/PPVT use 7/8). These hidden skip paths are not expressible as standard QML response codes, so the asymmetry is documented in the inventory rather than formally verified.

### P8: Copied NPHS Adult Module Contains Provably Dead Routing

**Severity:** LOW (2 items) — but a clean specimen of statically-provable dead code
**PDF evidence:** pp. 232-233 (UTIL-C9: "IF AGE < 18 THEN GO TO NEXT SECTION", followed by UTIL-Q9/Q10 home-care items)

**Problem:** Appendix E imports NPHS questions wholesale, including the adult home-care sub-module. Its entry check UTIL-C9 routes past the module whenever the subject is under 18 — and the NLSCY subject is *always* a child aged 0-11, so UTIL-Q9/Q10 can never be administered in this instrument. The module was copied without pruning inapplicable items: the questions carry full text, response options, and routing, yet no respondent can ever reach them. In the imperative version this is invisible (the check silently always fires); in the declarative model the gate `age >= 18` over a domain of [0, 11] is UNSAT — exactly the dead-code class the validator's reachability analysis proves. The QML omits the two items with a source-cited comment rather than shipping intentionally-unreachable content.

### P9: Calendar-Dependent Question Variants Routed on Undeclared Sampling State

**Severity:** LOW
**PDF evidence:** p. 230 (Appendix E header), p. 235 (KCON-Q1A/Q1B selection note)

**Problem:** Whether Appendix E is administered at all, and which of two differently-worded data-sharing consents (KCON-Q1A vs Q1B) is asked, depends on the data-collection period (integrated NLSC+NPHS in Nov 1994/Mar 1995 vs NLSC-only in Dec 1994/Feb 1995). This period flag is pure sampling-system state: it appears only in capitalized interviewer notes, has no question, no variable name, and no value domain in the instrument. Two consent variants with different legal wording selected by an undeclared external condition is a routing-opacity risk — a field error in period assignment silently administers the wrong consent text. The QML materializes the flag as an explicit admin question so both variants and their mutual exclusivity are formally verified.

## Cross-Check Fixes (QML Authoring Errors)

These are conversion-side errors caught and corrected — NOT problems in the original.

| # | Item(s) | Error | Fix | Reference |
|---|---------|-------|-----|-----------|
| 1 | RESTR/CHRON gates | Initially `child_age >= 12` instead of respondent age | Corrected per P1 resolution | pp. 9, 11 |
| 2 | HLT-C6A vision routing | NOTE vs GOTO direction ambiguity | Resolved per NOTE (Q6A ages 4-5) | pp. 44-45 |
| 3 | MSD sliding windows | Overlapping bands | Union-of-bands preconditions | p. 117 |
| 4 | CUS eldest-child shortcuts | Sibling data-copy optimization unmodelable | Full custody path for all; noted | p. 130 |
| 5 | 2026-06 consolidation | 9 frozen codeInit variables (respondent_age, is_parent, child_age_months, ...) left 188 items statically unreachable | Rewired to producing questions / admin items; frozen vars deleted (2026-07-19) | — |
| 6 | Historical appendix loss | Appendices A-F absent from inventory and QML (~163-210 items) | Appendices inventoried (+303 entries) and converted (+30 blocks, +246 items), fidelity-judged CONFIRMED (2026-07-19) | pp. 161-244 |
| 7 | Principal Q7/Q9/Q10/Q32 | QuestionGroup-subscript postconditions classify TAUTOLOGICAL (static builder does not lower QG subscripts — askalot-io/askalot#165) | Scalarized the constraint-bearing numeric batteries; constraints now CONSTRAINING. Q27 kept as QG with documented runtime-only rule | — |
| 8 | Teacher Q32 fall-through | Initial reading gated Q33-46 on codes 1-5 | Corrected to code 5 only (domain is {5..9}; 5 is the sole fall-through) | p. 200 |

## Impact Assessment

| Category | Imperative (PDF) | Declarative (QML) |
|----------|------------------|-------------------|
| Undeclared runtime state | CAPI resolves 15+ variables + appendix externals implicitly | Every value materialized as an explicit, domain-bounded admin question; gates verified by Z3 (#171 tracks first-class support) |
| Dead code | UTIL-C9 silently always fires; unreachable module invisible | `age >= 18` over [0,11] is provably UNSAT; module omission documented (P8) |
| Consistency checks | ~1 machine-checkable edit in 161 pages; consistency deferred to post-collection cleaning | 22 statically-verified constraining postconditions, mostly mined from implied relationships (enrolment bounds, experience arithmetic, percentage budgets) |
| Separate-respondent instruments | Teacher/principal/child booklets linked only by pre-printed IDs | Explicit administration gates; single dependency graph proves no cross-instrument contradiction |
| Custody complexity | 25 sequential checks, locally simple | Full dependency graph exposed and verified reachable |
| Period-variant consents | Undeclared sampling flag selects KCON-Q1A/Q1B | Explicit admin question; variant mutual exclusivity proven (P9) |

## Conclusion

The extended NLSCY conversion — 786 items in 141 blocks covering the full 244-page package including all five question-bearing appendices — passes the complete validation hierarchy: **0 errors, globally SAT, 0 cycles, 0 dead code**, with one documented runtime-only postcondition. An independent fidelity judgement confirmed all five appendices against the inventory with zero unjustified omissions.

The conversion exposes **9 categories of design issues** in the original: the seven previously confirmed (age-reference ambiguity, province proliferation, undeclared cross-section state, custody opacity, silent age-tier routing, redundant administration items, inconsistent refusal routing — the latter two now with appendix-side evidence) plus two new appendix findings: a **provably-dead imported NPHS adult module** (P8) — the corpus's cleanest specimen of statically-provable dead code in a production instrument — and **calendar-dependent consent variants routed on undeclared sampling state** (P9).

The instrument's structural soundness rests on one-directional age routing (set once, never modified downstream). Its main data-quality gap is the near-total absence of machine-checkable consistency rules: of the 22 constraining postconditions in the QML, all but two were *mined* from relationships the source implies but never states (counts bounded by enrolment, at-this-school experience bounded by total experience, percentages summing to 100). Formalizing these moves a large class of impossible answers from post-collection cleaning to point-of-collection prevention — the concrete value-add of the declarative model for a 1994-era paper/CAPI package.
