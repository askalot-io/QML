qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Landline Introduction (LL01–LL10)"
  codeInit: |
    # Variables PRODUCED by this section (read by later sections)
    # gender_identity: 1=Male, 2=Female, 3=Unspecified/another
    # sex_at_birth: 1=Male, 2=Female (only set when gender_identity=3)
    gender_identity = 0
    sex_at_birth = 0

  blocks:
    # =========================================================================
    # BLOCK 1: PHONE AND RESIDENCE SCREENING (LL01–LL05)
    # =========================================================================
    # LL01: Confirm phone number
    # LL02: Private residence? (2=No, non-business → LL03; 3=Business → TERMINATE)
    #        Note: response code 3 (business) is a TERMINATE path not modeled.
    #        Labels here reflect substantive respondent choices only.
    # LL03: College housing? (only asked if LL02=2); 2→TERMINATE not modeled
    # LL04: Currently live in [STATE]? 2→TERMINATE not modeled
    # LL05: Is this a cell phone? 1→TERMINATE not modeled
    # =========================================================================
    - id: b_phone_screening
      title: "Phone and Residence Screening"
      items:
        # LL01: Confirm the dialled number
        - id: q_ll01
          kind: Question
          title: "Is this [PHONE NUMBER]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LL02: Private residence check
        # Routing: 1 (Yes, private) → LL04 (skip LL03)
        #          2 (No, not private) → LL03
        #          3 (No, business) → TERMINATE (not modeled)
        # Precondition: LL01 = Yes
        - id: q_ll02
          kind: Question
          title: "Is this a private residence?"
          precondition:
            - predicate: q_ll01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, this is a private residence"
              2: "No, this is not a private residence"

        # LL03: College housing check
        # Only asked when LL02 = 2 (not a private residence, not a business)
        # Routing: 1 (Yes, college housing) → LL04
        #          2 (No) → TERMINATE (not modeled)
        - id: q_ll03
          kind: Question
          title: "Do you live in college housing?"
          precondition:
            - predicate: q_ll02.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LL04: Currently live in [STATE]?
        # Routing: 1 → LL05; 2 → TERMINATE (not modeled)
        # Precondition: arrived via LL02=1 (private) OR LL03=1 (college housing)
        - id: q_ll04
          kind: Question
          title: "Do you currently live in [STATE]?"
          precondition:
            - predicate: q_ll02.outcome == 1 or q_ll03.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LL05: Is this a cell phone?
        # Routing: 1 (Yes, cell) → TERMINATE (not modeled); 2 → LL06
        # Precondition: LL04 = Yes
        - id: q_ll05
          kind: Question
          title: "Is this a cell phone?"
          precondition:
            - predicate: q_ll04.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, it is a cell phone"
              2: "Not a cell phone"

    # =========================================================================
    # BLOCK 2: AGE VERIFICATION AND HOUSEHOLD SELECTION (LL06–LL08)
    # =========================================================================
    # LL06: 18 years of age or older?
    #        Yes + LL03=Yes (college housing) → skip LL07/LL08, go to LL09
    #        Yes + LL03≠Yes → LL07 (count household adults)
    #        No  + LL03=Yes (college housing) → TERMINATE (not modeled)
    #        No  + LL03≠Yes → LL07
    # LL07: How many adults in household? (1 → LL09; 2+ → LL08)
    #        Note: Asked only when not in college housing
    # LL08: Most recent birthday selection
    #        Note: Original loops if respondent is not MRB person (ask again
    #        after transfer). QML cannot model loops; Yes/No is recorded.
    # =========================================================================
    - id: b_household_selection
      title: "Age Verification and Household Selection"
      items:
        # LL06: Age verification
        # Precondition: LL05 = 2 (not a cell phone)
        - id: q_ll06
          kind: Question
          title: "Are you 18 years of age or older?"
          precondition:
            - predicate: q_ll05.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LL07: Household adult count
        # Asked only when: LL06 was reached AND respondent is NOT in college housing
        # (college housing: LL03=1 → skip directly to LL09 when LL06=1)
        # Routing: 1 → LL09; 2–6 or more → LL08
        # Note: In the original CATI, values 2–97 route to LL08. Values 98+ are
        # treated as DK/R system codes.
        - id: q_ll07
          kind: Question
          title: "Excluding adults living away from home, such as students away at college, how many members of your household, including yourself, are 18 years of age or older?"
          precondition:
            - predicate: q_ll05.outcome == 2 and q_ll03.outcome != 1
          input:
            control: Editbox
            min: 1
            max: 97
            left: "Number of adults:"

        # LL08: Most recent birthday (MRB) selection
        # Routing: 1 (Yes) → LL09; 2 (No) → correct respondent sought, re-ask LL08
        # Note: In original CATI, answering No causes the interviewer to ask for
        # the adult with the most recent birthday and re-ask LL08. QML cannot
        # model loops; Yes/No is recorded here. The loop logic is noted for
        # reference.
        # Precondition: LL07 was asked AND LL07 ≥ 2 (multiple adults in household)
        - id: q_ll08
          kind: Question
          title: "The person in your household that I need to speak with is the adult with the most recent birthday. Are you the adult with the most recent birthday?"
          precondition:
            - predicate: q_ll07.outcome >= 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 3: GENDER IDENTITY AND SEX AT BIRTH (LL09–LL10)
    # =========================================================================
    # LL09: Gender identity
    #        1 (Male) or 2 (Female) → proceed to Section 1
    #        3 (Unspecified/another) → LL10
    # LL10: Sex at birth (asked only when LL09=3)
    #        7 (DK) and 9 (R) are system codes → TERMINATE (not modeled)
    # =========================================================================
    - id: b_gender_identity
      title: "Gender Identity and Sex at Birth"
      items:
        # LL09: Gender identity
        # Reached when:
        #   (a) LL06=1 AND LL03=1 (18+ in college housing → skip household count)
        #   (b) LL07=1 (only one adult → go directly here)
        #   (c) LL08=1 (this person is the MRB adult)
        - id: q_ll09
          kind: Question
          title: "Are you?"
          precondition:
            - predicate: (q_ll06.outcome == 1 and q_ll03.outcome == 1) or q_ll07.outcome == 1 or q_ll08.outcome == 1
          codeBlock: |
            gender_identity = q_ll09.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
              3: "Unspecified or another gender identity"

        # LL10: Sex at birth
        # Asked only when LL09 = 3 (Unspecified or another gender identity)
        # DK (7) and Refused (9) are system exit codes → TERMINATE (not modeled here)
        - id: q_ll10
          kind: Question
          title: "What was your sex at birth? Was it male or female?"
          precondition:
            - predicate: q_ll09.outcome == 3
          codeBlock: |
            sex_at_birth = q_ll10.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
