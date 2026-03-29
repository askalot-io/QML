qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Core Section 9: Disability / Core Section 10: Falls"

  codeInit: |
    age: range(18, 99)

  blocks:
    # =========================================================================
    # CORE 9: DISABILITY (CDIS.01–CDIS.06)
    # =========================================================================
    # All six disability questions are asked sequentially with no skip routing.
    # DK (7) and Refused (9) route identically to the next item, so no
    # preconditions are needed within this block.
    # =========================================================================
    - id: b_disability
      title: "Core Section 9: Disability"
      items:
        # CDIS.01: Hearing difficulty
        - id: q_cdis_01
          kind: Question
          title: "Are you deaf or do you have serious difficulty hearing?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CDIS.02: Vision difficulty
        - id: q_cdis_02
          kind: Question
          title: "Are you blind or do you have serious difficulty seeing, even when wearing glasses?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CDIS.03: Cognitive difficulty
        - id: q_cdis_03
          kind: Question
          title: "Because of a physical, mental, or emotional condition, do you have serious difficulty concentrating, remembering, or making decisions?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CDIS.04: Mobility difficulty
        - id: q_cdis_04
          kind: Question
          title: "Do you have serious difficulty walking or climbing stairs?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CDIS.05: Self-care difficulty
        - id: q_cdis_05
          kind: Question
          title: "Do you have difficulty dressing or bathing?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CDIS.06: Independent living difficulty
        - id: q_cdis_06
          kind: Question
          title: "Because of a physical, mental, or emotional condition, do you have difficulty doing errands alone such as visiting a doctor's office or shopping?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # CORE 10: FALLS (CFAL.01–CFAL.02)
    # =========================================================================
    # CFAL.FILTER: Skip entire section if age 18–44 (i.e., age < 45).
    # Block precondition applies to all items in this block.
    #
    # CFAL.01: Number of falls in past 12 months.
    #   0 or 88 (None) → skip CFAL.02 (coded as 0, no further injury question)
    #   >0           → ask CFAL.02
    #
    # CFAL.02: Falls causing limiting injury. Precondition: CFAL.01 > 0.
    # =========================================================================
    - id: b_falls
      title: "Core Section 10: Falls"
      precondition:
        - predicate: age >= 45
      items:
        # CFAL.01: Number of falls in past 12 months
        # 0–76 = count (76 = 76 or more), 88 = None (no falls)
        - id: q_cfal_01
          kind: Question
          title: "In the past 12 months, how many times have you fallen?"
          input:
            control: Editbox
            min: 0
            max: 76
            right: "times (0–76, or 76 for 76+; enter 0 for none)"

        # CFAL.02: Falls causing a limiting injury
        # Precondition: at least one fall reported (CFAL.01 > 0)
        - id: q_cfal_02
          kind: Question
          title: "How many of these falls caused an injury that limited your regular activities for at least a day or caused you to go to see a doctor?"
          precondition:
            - predicate: q_cfal_01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 76
            right: "times (0–76, or 76 for 76+)"
