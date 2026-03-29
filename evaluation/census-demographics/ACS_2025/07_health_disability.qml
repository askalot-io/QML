qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Health Insurance & Disability (Person Q16-Q20)"

  codeInit: |
    person_age: range(0, 120)

  blocks:
    # ── Health Insurance (Q16, Filter G, Q17a-b) ──
    - id: b_health_insurance
      title: "Health Insurance Coverage"
      items:
        # P_Q16: Health insurance coverage types
        - id: q_p_q16
          kind: Question
          title: "Is this person CURRENTLY covered by any of the following types of health insurance or health coverage plans? Mark all that apply."
          input:
            control: Checkbox
            labels:
              1: "Insurance through a current or former employer, union, or professional association"
              2: "Medicare"
              4: "Medicaid, CHIP, or government-assistance plan"
              8: "Insurance purchased directly from an insurance company, broker, or Marketplace"
              16: "VA health care (enrolled for VA)"
              32: "TRICARE or other military health care"
              64: "Indian Health Service"
              128: "Any other type of health insurance or health coverage plan"
              256: "No health insurance or health coverage plan"

        # Filter G: insured → Q17a; uninsured (only 256 selected) → skip to Q18a
        # P_Q17a: Premium for health plan
        - id: q_p_q17a
          kind: Question
          title: "Is there a premium for this plan?"
          precondition:
            - predicate: "q_p_q16.outcome != 256"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q17b: Tax credit or subsidy
        - id: q_p_q17b
          kind: Question
          title: "Does this person or another family member receive a tax credit or subsidy based on family income to help pay the premium?"
          precondition:
            - predicate: "q_p_q16.outcome != 256"
            - predicate: "q_p_q17a.outcome == 1"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ── Disability: Hearing & Vision (Q18a-b) — asked of everyone ──
    - id: b_disability_hearing_vision
      title: "Disability - Hearing and Vision"
      items:
        # P_Q18a: Hearing difficulty
        - id: q_p_q18a
          kind: Question
          title: "Is this person deaf or does he/she have serious difficulty hearing?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q18b: Vision difficulty
        - id: q_p_q18b
          kind: Question
          title: "Is this person blind or does he/she have serious difficulty seeing even when wearing glasses?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ── Disability: Cognitive, Walking, Dressing (Q19a-c) — Filter H: age >= 5 ──
    - id: b_disability_cognitive
      title: "Disability - Cognitive, Ambulatory, Self-Care"
      precondition:
        - predicate: "person_age >= 5"
      items:
        # P_Q19a: Cognitive difficulty
        - id: q_p_q19a
          kind: Question
          title: "Because of a physical, mental, or emotional condition, does this person have serious difficulty concentrating, remembering, or making decisions?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q19b: Walking/climbing difficulty
        - id: q_p_q19b
          kind: Question
          title: "Does this person have serious difficulty walking or climbing stairs?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q19c: Dressing/bathing difficulty
        - id: q_p_q19c
          kind: Question
          title: "Does this person have difficulty dressing or bathing?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ── Disability: Errands (Q20) — Filter I: age >= 15 ──
    - id: b_disability_errands
      title: "Disability - Independent Living"
      precondition:
        - predicate: "person_age >= 15"
      items:
        # P_Q20: Errands difficulty
        - id: q_p_q20
          kind: Question
          title: "Because of a physical, mental, or emotional condition, does this person have difficulty doing errands alone such as visiting a doctor's office or shopping?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
