qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 31: Random Child Selection / Module 32: Childhood Asthma / Asthma Call-Back"

  codeInit: |
    # Extern variable from Core Section 8 (CDEM.14): number of children in household
    # 0–87 = actual count; 88 = none (coded as 88 to avoid ambiguity with 0)
    num_children: range(0, 88)

  blocks:
    # =========================================================================
    # MODULE 31: RANDOM CHILD SELECTION (MRCS)
    # =========================================================================
    # Module filter: Ask only if household has at least one child under 18
    # (num_children 1–87; 88 = none, 0 = not reported).
    #
    # MRCS.01: Birth month of selected child (MM only; year not collected here).
    # MRCS.02: Gender identity of child.
    #   1 (Boy) → skip MRCS.03, go to MRCS.04
    #   2 (Girl) or 3 (Nonbinary/other) → ask MRCS.03 (birth certificate sex)
    # MRCS.03: Sex on original birth certificate. Precondition: MRCS.02 in [2, 3].
    # MRCS.04: Hispanic origin of child (single select).
    # MRCS.05: Race of child (multi-select, power-of-2 keys).
    # MRCS.06: Relationship of respondent to child.
    # =========================================================================
    - id: b_child_selection
      title: "Module 31: Random Child Selection"
      precondition:
        - predicate: num_children >= 1 and num_children <= 87
      items:
        # MRCS.01: Birth month of randomly selected child
        - id: q_mrcs_01
          kind: Question
          title: "What is the birth month of the selected child?"
          input:
            control: Editbox
            min: 1
            max: 12
            right: "month (1 = January, 12 = December)"

        # MRCS.02: Child's gender identity
        - id: q_mrcs_02
          kind: Question
          title: "Is the child a boy or a girl?"
          input:
            control: Radio
            labels:
              1: "Boy"
              2: "Girl"
              3: "Nonbinary or other"

        # MRCS.03: Child's sex on original birth certificate
        # Precondition: MRCS.02 = Girl (2) or Nonbinary/other (3)
        - id: q_mrcs_03
          kind: Question
          title: "What was the child's sex on their original birth certificate?"
          precondition:
            - predicate: q_mrcs_02.outcome in [2, 3]
          input:
            control: Radio
            labels:
              1: "Boy"
              2: "Girl"

        # MRCS.04: Child's Hispanic or Latino origin
        - id: q_mrcs_04
          kind: Question
          title: "Is the child Hispanic, Latino/a, or Spanish origin?"
          input:
            control: Dropdown
            labels:
              1: "Mexican, Mexican American, or Chicano/a"
              2: "Puerto Rican"
              3: "Cuban"
              4: "Another Hispanic, Latino/a, or Spanish origin"
              5: "No, not of Hispanic, Latino/a, or Spanish origin"

        # MRCS.05: Child's race (multi-select)
        # Power-of-2 keys enable bitwise combination of multiple selections.
        - id: q_mrcs_05
          kind: Question
          title: "Which one or more of the following would you say is the race of the child?"
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African American"
              4: "American Indian or Alaska Native"
              8: "Asian"
              16: "Native Hawaiian or Other Pacific Islander"
              32: "Some other race"

        # MRCS.06: Respondent's relationship to selected child
        - id: q_mrcs_06
          kind: Question
          title: "How are you related to the child?"
          input:
            control: Dropdown
            labels:
              1: "Parent"
              2: "Grandparent"
              3: "Foster parent or guardian"
              4: "Sibling"
              5: "Other relative"
              6: "Not related"

    # =========================================================================
    # MODULE 32: CHILDHOOD ASTHMA PREVALENCE (MCAP)
    # =========================================================================
    # Module filter: Ask only if household has at least one child under 18.
    # MCAP.01: Child ever diagnosed with asthma by health professional.
    #   1 (Yes) → ask MCAP.02 (child still has asthma)
    #   2 (No) → go to next module / Asthma Call-Back section
    #
    # MCAP.02: Child still has asthma. Precondition: MCAP.01 == 1.
    # =========================================================================
    - id: b_childhood_asthma
      title: "Module 32: Childhood Asthma Prevalence"
      precondition:
        - predicate: num_children >= 1 and num_children <= 87
      items:
        # MCAP.01: Child ever told by health professional they have asthma
        - id: q_mcap_01
          kind: Question
          title: "Has a doctor, nurse or other health professional EVER said that the child has asthma?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCAP.02: Child still has asthma
        # Precondition: MCAP.01 = Yes (1)
        - id: q_mcap_02
          kind: Question
          title: "Does the child still have asthma?"
          precondition:
            - predicate: q_mcap_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # ASTHMA CALL-BACK PERMISSION SCRIPT (CB01)
    # =========================================================================
    # CB01.01: Consent to call back for additional asthma questions.
    #   1 (Yes) → ask CB01.02 and CB01.03 (focus of call-back and contact name)
    #   2 (No) → end
    #
    # CB01.02: Which household person is the focus of the call-back.
    #   Precondition: CB01.01 == 1
    #
    # CB01.03: First name or initials for the call-back contact.
    #   Precondition: CB01.01 == 1
    # =========================================================================
    - id: b_asthma_callback
      title: "Asthma Call-Back Permission Script"
      items:
        # CB01.01: Consent for asthma call-back interview
        - id: q_cb01_01
          kind: Question
          title: "Would it be okay if we called you back to ask additional asthma-related questions at a later time?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CB01.02: Which household person is the focus of the asthma call-back
        # Precondition: CB01.01 = Yes (1)
        - id: q_cb01_02
          kind: Question
          title: "Which person in the household was selected as the focus of the asthma call-back?"
          precondition:
            - predicate: q_cb01_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Adult"
              2: "Child"

        # CB01.03: First name or initials for call-back contact
        # Precondition: CB01.01 = Yes (1)
        - id: q_cb01_03
          kind: Question
          title: "Can I please have either your or your child's first name or initials, so we will know who to ask for when we call back?"
          precondition:
            - predicate: q_cb01_01.outcome == 1
          input:
            control: Textarea
