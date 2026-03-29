# Legal & Regulatory

Court forms, immigration applications, regulatory investigation instruments, law enforcement protocols, and governmental compliance forms. These questionnaires operate within strict legal frameworks where completeness, consistency, and eligibility determination are paramount.

## Typical design patterns

- **Eligibility cascades**: early answers determine whether the applicant qualifies at all (USCIS N-400 naturalization requirements)
- **Declarations with conditional explanations**: "Have you ever...?" Yes triggers a detailed follow-up section
- **Means testing**: income/expense calculations that determine which legal pathway applies (bankruptcy Chapter 7 vs. 13)
- **Multi-section conditional applicability**: entire sections activate based on case type, jurisdiction, or party role
- **Sworn statement structure**: every answer is legally binding; contradictions have legal consequences
- **Referral/escalation triggers**: certain answers automatically escalate to a different process

## Topics covered

- Immigration: naturalization (N-400), permanent residence (I-485), asylum (I-589), employment authorization
- Court/civil: case information statements, civil cover sheets, financial disclosure affidavits
- Bankruptcy: statement of financial affairs, means test calculation, Chapter 7/13 forms
- Regulatory enforcement: SEC investigation forms, FTC merger review (Model Second Request), EPA RCRA/NPDES checklists
- Law enforcement: crime scene investigation guides, witness statements, digital evidence collection
- Workplace: EEOC discrimination charges, harassment investigation intake forms
- Tax: IRS information document requests (Form 4564), voluntary disclosure applications
- Human rights: Istanbul Protocol (torture investigation), ICC victim application forms, OHCHR fact-finding
- Insurance: fraud referral forms, claim investigation questionnaires
- IP/M&A: patent due diligence checklists, IP assessment questionnaires
- E-discovery: litigation hold checklists, document production forms

## Instruments in this category

*(Empty -- candidates for future addition)*

- USCIS Form N-400 (14 pages, eligibility cascades)
- USCIS Form I-485 (24 pages, conditional sections by visa category)
- USCIS Form I-589 (asylum application with persecution-type branching)
- U.S. Courts Form 107 (bankruptcy statement of financial affairs)
- U.S. Courts Form 122A-2 (Chapter 7 means test -- computed eligibility)
- SEC Form 1662 (enforcement investigation supplemental info)
- FTC Model Second Request (merger investigation, comprehensive)
- EEOC Form 5 (charge of discrimination)
- EPA RCRA inspection checklists (SQG/LQG variants)
- ICC victim application form (fillable, multi-section)

## QML conversion notes

Legal forms are an outstanding test case for QML postconditions because contradictions in legal documents have real consequences. Cross-checking declarations ("Have you been outside the US?" vs. travel history details) maps perfectly to postconditions. Means testing (bankruptcy) involves computed thresholds that determine which path the respondent follows -- ideal for codeBlock + precondition patterns. The main challenge is representing the legal concept of "sworn completeness" -- every applicable section must be answered, not just visited.
