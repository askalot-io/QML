qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 14: Caregiver"

  codeInit: |
    # No extern variables required for this section

  blocks:
    # =========================================================================
    # MODULE 14: CAREGIVER (MCARE)
    # =========================================================================
    # MCARE.01: Provided care in past 30 days.
    #   1 (Yes)  → MCARE.02–08
    #   2 (No)   → MCARE.09
    #   7 (DK)   → MCARE.09
    #   8 (Died) → end of module (skip MCARE.09)
    #   9 (R)    → MCARE.09
    #
    # MCARE.02–08: Precondition: MCARE.01 == 1
    # MCARE.02: Relationship. Dropdown (15 options).
    # MCARE.03: Duration of caregiving. Radio (5 ranges).
    # MCARE.04: Hours per week of care. Radio (4 ranges).
    # MCARE.05: Main health condition of care recipient. Dropdown (15 options).
    #   05 (Alzheimer's/dementia) → SKIP MCARE.06 → MCARE.07
    #   all others / DK / R → MCARE.06
    # MCARE.06: Recipient also has Alzheimer's/dementia. Switch.
    #   Precondition: MCARE.01==1 AND MCARE.05 != 5
    # MCARE.07: Managed personal care tasks. Switch. Precondition: MCARE.01==1
    # MCARE.08: Managed household tasks. Switch. Precondition: MCARE.01==1
    #   After MCARE.08, skip MCARE.09 (already a caregiver).
    #
    # MCARE.09: Expects to provide care in next 2 years. Switch.
    #   Precondition: MCARE.01 != 1 AND MCARE.01 != 3
    #   (i.e., not a current caregiver and recipient did not die)
    # =========================================================================
    - id: b_caregiver
      title: "Module 14: Caregiver"
      items:
        # MCARE.01: Provided care or assistance in past 30 days
        - id: q_mcare_01
          kind: Question
          title: "During the past 30 days, did you provide regular care or assistance to a friend or family member who has a health problem or disability?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Caregiving recipient died in past 30 days"

        # MCARE.02: Relationship to care recipient
        # Precondition: MCARE.01 = Yes (1)
        - id: q_mcare_02
          kind: Question
          title: "What is his or her relationship to you?"
          precondition:
            - predicate: q_mcare_01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Mother"
              2: "Father"
              3: "Mother-in-law"
              4: "Father-in-law"
              5: "Child"
              6: "Husband"
              7: "Wife"
              8: "Live-in partner"
              9: "Brother/brother-in-law"
              10: "Sister/sister-in-law"
              11: "Grandmother"
              12: "Grandfather"
              13: "Grandchild"
              14: "Other relative"
              15: "Non-relative/family friend"

        # MCARE.03: Duration of caregiving
        # Precondition: MCARE.01 = Yes (1)
        - id: q_mcare_03
          kind: Question
          title: "For how long have you provided care for that person?"
          precondition:
            - predicate: q_mcare_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 30 days"
              2: "1 to less than 6 months"
              3: "6 months to less than 2 years"
              4: "2 to less than 5 years"
              5: "5 or more years"

        # MCARE.04: Average hours per week providing care
        # Precondition: MCARE.01 = Yes (1)
        - id: q_mcare_04
          kind: Question
          title: "In an average week, how many hours do you provide care or assistance?"
          precondition:
            - predicate: q_mcare_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Up to 8 hours per week"
              2: "9 to 19 hours per week"
              3: "20 to 39 hours per week"
              4: "40 or more hours per week"

        # MCARE.05: Main health problem/disability of care recipient
        # Precondition: MCARE.01 = Yes (1)
        # If Alzheimer's/dementia (5) → skip MCARE.06 directly to MCARE.07.
        - id: q_mcare_05
          kind: Question
          title: "What is the main health problem, long-term illness, or disability that the person you care for has?"
          precondition:
            - predicate: q_mcare_01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Arthritis"
              2: "Asthma"
              3: "Cancer"
              4: "Chronic respiratory disease/COPD"
              5: "Alzheimer's disease or dementia"
              6: "Developmental disabilities"
              7: "Diabetes"
              8: "Heart disease/hypertension/stroke"
              9: "HIV"
              10: "Mental illness"
              11: "Other organ failure"
              12: "Substance abuse"
              13: "Injuries"
              14: "Old age/infirmity"
              15: "Other"

        # MCARE.06: Recipient also has Alzheimer's/dementia/cognitive impairment
        # Precondition: MCARE.01==1 AND MCARE.05 != 5
        # (If primary condition is already Alzheimer's, this question is skipped.)
        - id: q_mcare_06
          kind: Question
          title: "Does the person you care for also have Alzheimer's disease, dementia or other cognitive impairment disorder?"
          precondition:
            - predicate: q_mcare_01.outcome == 1
            - predicate: q_mcare_05.outcome != 5
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCARE.07: Managed personal care (medications, feeding, dressing, bathing)
        # Precondition: MCARE.01 = Yes (1)
        - id: q_mcare_07
          kind: Question
          title: "In the past 30 days, did you provide care by managing personal care such as giving medications, feeding, dressing, or bathing?"
          precondition:
            - predicate: q_mcare_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCARE.08: Managed household tasks (cleaning, managing money, preparing meals)
        # Precondition: MCARE.01 = Yes (1)
        # After this item, current caregivers skip MCARE.09.
        - id: q_mcare_08
          kind: Question
          title: "In the past 30 days, did you provide care by managing household tasks such as cleaning, managing money, or preparing meals?"
          precondition:
            - predicate: q_mcare_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCARE.09: Expects to provide care in the next 2 years
        # Precondition: MCARE.01 != 1 (not a current caregiver)
        #           AND MCARE.01 != 3 (recipient did not die)
        # Covers respondents who answered No (2), DK (7), or Refused (9).
        - id: q_mcare_09
          kind: Question
          title: "In the next 2 years, do you expect to provide care or assistance to a friend or family member who has a health problem or disability?"
          precondition:
            - predicate: q_mcare_01.outcome != 1 and q_mcare_01.outcome != 8
          input:
            control: Switch
            on: "Yes"
            off: "No"
