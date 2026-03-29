qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 (Children) — Section I: Economic Characteristics"
  codeInit: |
    # No extern variables required — Section I is asked of everyone.
    dk_i9 = 0

  blocks:
    # =========================================================================
    # BLOCK 1: SECTION I — ECONOMIC CHARACTERISTICS (items I1–I10)
    # =========================================================================
    # I1   → Insurance coverage (3 sub-items: meds, glasses, hospital). QuestionGroup Switch.
    # I2   → Child Care Expenses tax credit claimed? Radio (Yes/No/DK/R).
    #         Yes → I3; No/DK/R → I4.
    # I3   → Did you receive it? (Child care credit) Radio (Yes/No/DK/R). → I4.
    # I4   → Medical Expenses tax credit claimed? Radio (Yes/No/DK/R).
    #         Yes → I5; No/DK/R → I6.
    # I5   → Did you receive it? (Medical expenses credit) Radio (Yes/No/DK/R). → I6.
    # I6   → Disability Tax Credit claimed? Radio (Yes/No/DK/R).
    #         Yes → I7; No → I8; DK/R → I9.
    # I7   → Did you receive it? (Disability tax credit) Radio (Yes/No/DK/R). → I9.
    # I8   → Why not claimed DTC? (4 sub-items, Yes/No grid). → I9.
    # I9   → Total household income (Editbox 0–999999). If answered → Follow-up.
    #         DK/R (coded 0) → sets dk_i9=1 → I10.
    # I10  → Income bracket Radio (10 groups). Precondition: dk_i9 == 1.
    # =========================================================================
    - id: b_economic
      title: "Economic Characteristics"
      items:

        # I1: Insurance coverage — 3 sub-items (a) meds, (b) glasses, (c) hospital
        # All respondents.
        - id: qg_i1
          kind: QuestionGroup
          title: "Do you have insurance that covers all or part of: (a) the cost of .....'s prescription medications? (b) the cost of .....'s eye glasses or contact lenses? (c) hospital charges for a private or semi-private room?"
          questions:
            - "(a) Prescription medications"
            - "(b) Eye glasses or contact lenses"
            - "(c) Hospital charges for a private or semi-private room"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # I2: Child Care Expenses tax credit claimed?
        # 1=Yes → I3; 3=No → I4; 8=DK → I4; 9=Refusal → I4
        - id: q_i2
          kind: Question
          title: "Did you claim Child Care Expenses for ..... with your 2000 income tax return?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I3: Did you receive the Child Care Expenses tax credit?
        # Precondition: I2 = Yes (outcome == 1)
        # → I4
        - id: q_i3
          kind: Question
          title: "Did you receive it? (Child Care Expenses tax credit)"
          precondition:
            - predicate: q_i2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I4: Medical Expenses tax credit claimed?
        # 1=Yes → I5; 3=No → I6; 8=DK → I6; 9=Refusal → I6
        - id: q_i4
          kind: Question
          title: "Did you claim Medical Expenses for ..... with your 2000 income tax return?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I5: Did you receive the Medical Expenses tax credit?
        # Precondition: I4 = Yes (outcome == 1)
        # → I6
        - id: q_i5
          kind: Question
          title: "Did you receive it? (Medical Expenses tax credit)"
          precondition:
            - predicate: q_i4.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I6: Disability Tax Credit claimed?
        # 1=Yes → I7; 3=No → I8; 8=DK → I9; 9=Refusal → I9
        - id: q_i6
          kind: Question
          title: "Did you claim a Disability Tax Credit for ..... with your 2000 income tax return?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I7: Did you receive the Disability Tax Credit?
        # Precondition: I6 = Yes (outcome == 1)
        # → GO TO I9 (skip I8)
        - id: q_i7
          kind: Question
          title: "Did you receive it? (Disability Tax Credit)"
          precondition:
            - predicate: q_i6.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I8: Why did you not claim the Disability Tax Credit?
        # 4 sub-items (a)–(d), Yes/No per sub-item.
        # Precondition: I6 = No (outcome == 3)
        # (a) Did not know it existed
        # (b) Did not think child would meet eligibility requirements
        # (c) Not able to obtain the disability certificate (Form T2201)
        # (d) Other reason
        # → I9
        - id: qg_i8
          kind: QuestionGroup
          title: "Why did you not claim the Disability Tax Credit? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_i6.outcome == 3
          questions:
            - "(a) You did not know it existed"
            - "(b) You did not think that ..... would meet the eligibility requirements"
            - "(c) You were not able to obtain the disability certificate (Form T2201) from your doctor"
            - "(d) Other reason, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # I9: Total household income before taxes and deductions (year ending Dec 31, 2000)
        # Amount → GO TO Follow-up; 0 treated as DK/R → I10.
        # If respondent cannot give a precise amount (DK/R), they enter 0 which triggers I10.
        # codeBlock sets dk_i9 = 1 when outcome == 0 to gate I10.
        - id: q_i9
          kind: Question
          title: "For the year ending December 31, 2000, what is your best estimate of the total income, before taxes and deductions, of all household members, including yourself, from all sources? (Enter 0 if no income, a loss, or if unable to estimate)"
          codeBlock: |
            if q_i9.outcome == 0:
                dk_i9 = 1
            else:
                dk_i9 = 0
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # I10: Household income bracket
        # Precondition: I9 respondent could not give precise amount (dk_i9 == 1)
        # → GO TO Follow-up
        - id: q_i10
          kind: Question
          title: "Can you estimate in which of the following groups your HOUSEHOLD INCOME fell?"
          precondition:
            - predicate: dk_i9 == 1
          input:
            control: Radio
            labels:
              1: "$1 to less than $5,000"
              2: "$5,000 to less than $10,000"
              3: "$10,000 to less than $15,000"
              4: "$15,000 to less than $20,000"
              5: "$20,000 to less than $30,000"
              6: "$30,000 to less than $40,000"
              7: "$40,000 to less than $50,000"
              8: "$50,000 to less than $60,000"
              9: "$60,000 to less than $80,000"
              10: "$80,000 or more"
              11: "Don't know"
              12: "Refusal"
