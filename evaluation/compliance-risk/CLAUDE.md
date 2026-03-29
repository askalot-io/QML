# Compliance, Audit & Risk Assessment

Regulatory compliance checklists, self-assessment questionnaires, due diligence instruments, and risk evaluation forms. These questionnaires determine conformance with standards, identify gaps, and assess organizational risk posture.

## Typical design patterns

- **Clause-by-clause audit**: one section per standard requirement (ISO, NIST, PCI DSS)
- **Yes/No/N-A with evidence**: binary compliance + free-text for evidence or compensating controls
- **Maturity models**: responses map to maturity levels (1-5 capability scale)
- **Cascading applicability**: early questions determine which later sections apply
- **Scoring and weighting**: responses produce a composite risk score
- **Conditional depth**: a "No" answer triggers follow-up remediation questions
- **Multi-party**: separate sections for different organizational roles (IT, legal, management)

## Topics covered

- Payment card security (PCI DSS SAQ variants)
- Cybersecurity frameworks (NIST CSF, CIS Controls, ISO 27001)
- Data protection and privacy (GDPR, HIPAA)
- Financial crime compliance (AML/KYC, Wolfsberg questionnaires)
- Vendor/third-party risk management (SIG questionnaire)
- ESG and sustainability reporting (CDP, GRI, SASB)
- Corporate governance self-evaluation (OECD Principles)
- IT governance (COBIT)
- Operational risk (Basel III)
- SOC 2 trust service criteria
- Internal audit self-assessment

## Instruments in this category

*(Empty -- candidates for future addition)*

- PCI DSS v4.0 SAQs (9 variants, all freely downloadable)
- NIST SP 800-53 Rev 5 assessment procedures
- Wolfsberg CBDDQ v1.4 and FCCQ v1.2
- CNIL PIA tool (GDPR impact assessment)
- CIS CSAT (Controls Self-Assessment Tool)
- GRI Standards, SASB Navigator
- ISO 45001 / ISO 9001 audit checklists
- HHS SRA Tool (HIPAA)

## QML conversion notes

Compliance questionnaires are the strongest test case for QML's postcondition system. A "Yes" to "Do you store cardholder data?" must trigger follow-up questions about encryption -- this is exactly the precondition/postcondition pattern QML formalizes. The challenge is that compliance instruments are often very large (PCI DSS SAQ D has hundreds of questions) and deeply hierarchical. Cross-check postconditions can catch contradictions like claiming to have no internet access while also reporting use of cloud services.
