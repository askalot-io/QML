qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Cell Phone Introduction (CP01–CP12)"
  codeInit: |
    # Variables PRODUCED by this section (read by later sections)
    # gender_identity: 1=Male, 2=Female, 3=Unspecified/another
    # sex_at_birth: 1=Male, 2=Female (only set when gender_identity=3)
    # household_adults: count of adults 18+ in household
    # has_landline: 1=Yes, 2=No (dual-frame overlap flag)
    gender_identity = 0
    sex_at_birth = 0
    household_adults = 0
    has_landline = 0

  blocks:
    # =========================================================================
    # BLOCK 1: SAFETY AND DEVICE VERIFICATION (CP01–CP04)
    # =========================================================================
    # CP01: Safe to talk? 2→TERMINATE (not modeled)
    # CP02: Confirm phone number. 2→TERMINATE (not modeled)
    # CP03: Is this a cell phone? 2→TERMINATE (not modeled)
    # CP04: 18 years of age or older? 2→TERMINATE (not modeled)
    # =========================================================================
    - id: b_safety_device
      title: "Safety and Device Verification"
      items:
        # CP01: Safe to talk
        # Routing: 1 (Yes) → CP02; 2 (No) → TERMINATE (set appointment if possible)
        - id: q_cp01
          kind: Question
          title: "Is this a safe time to talk with you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CP02: Confirm the dialled number
        # Routing: 1 → CP03; 2 → TERMINATE (not modeled)
        # Precondition: CP01 = Yes
        - id: q_cp02
          kind: Question
          title: "Is this [PHONE NUMBER]?"
          precondition:
            - predicate: q_cp01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CP03: Confirm cell phone
        # Routing: 1 → CP04; 2 → TERMINATE (not modeled)
        # Precondition: CP02 = Yes
        - id: q_cp03
          kind: Question
          title: "Is this a cell phone?"
          precondition:
            - predicate: q_cp02.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CP04: Age verification
        # Routing: 1 (Yes, 18+) → CP05; 2 (No) → TERMINATE (not modeled)
        # Precondition: CP03 = Yes (confirmed cell phone)
        - id: q_cp04
          kind: Question
          title: "Are you 18 years of age or older?"
          precondition:
            - predicate: q_cp03.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 2: GENDER IDENTITY AND SEX AT BIRTH (CP05–CP06)
    # =========================================================================
    # CP05: Gender identity
    #        1 (Male) or 2 (Female) → CP07 (skip CP06)
    #        3 (Unspecified/another) → CP06
    # CP06: Sex at birth
    #        1 or 2 → CP07
    #        7 (DK) or 9 (R) → TERMINATE (not modeled)
    # =========================================================================
    - id: b_gender_identity
      title: "Gender Identity and Sex at Birth"
      items:
        # CP05: Gender identity
        # Precondition: CP04 = Yes (18+)
        - id: q_cp05
          kind: Question
          title: "Are you?"
          precondition:
            - predicate: q_cp04.outcome == 1
          codeBlock: |
            gender_identity = q_cp05.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
              3: "Unspecified or another gender identity"

        # CP06: Sex at birth
        # Asked only when CP05 = 3 (Unspecified or another gender identity)
        # DK (7) and Refused (9) are system exit codes → TERMINATE (not modeled)
        - id: q_cp06
          kind: Question
          title: "What was your sex at birth? Was it male or female?"
          precondition:
            - predicate: q_cp05.outcome == 3
          codeBlock: |
            sex_at_birth = q_cp06.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

    # =========================================================================
    # BLOCK 3: RESIDENCE VERIFICATION (CP07–CP10)
    # =========================================================================
    # CP07: Private residence? 2 → CP08 (college housing check)
    # CP08: College housing? (only if CP07=2); 2→TERMINATE (not modeled)
    # CP09: Currently in [STATE]? 2 → CP10 (ask which state)
    # CP10: What state? Valid state → CP11; 77 (outside US) / 99 (R) → TERMINATE
    #        Note: Modeled as Editbox for US state/territory FIPS codes (1-78).
    #        Ineligible codes (77, 99) are TERMINATE paths not modeled.
    # =========================================================================
    - id: b_residence
      title: "Residence Verification"
      items:
        # CP07: Private residence
        # Routing: 1 (Yes, private) → CP09 (skip CP08)
        #          2 (No, not private) → CP08
        # Precondition: Respondent has passed gender section
        #   (CP05 asked AND (CP05 in {1,2} OR CP06 in {1,2}))
        - id: q_cp07
          kind: Question
          title: "Do you live in a private residence?"
          precondition:
            - predicate: q_cp05.outcome == 1 or q_cp05.outcome == 2 or q_cp06.outcome == 1 or q_cp06.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CP08: College housing check
        # Asked only when CP07 = 2 (not a private residence)
        # Routing: 1 (Yes, college housing) → CP09; 2 (No) → TERMINATE (not modeled)
        - id: q_cp08
          kind: Question
          title: "Do you live in college housing?"
          precondition:
            - predicate: q_cp07.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CP09: Currently in [STATE]?
        # Routing: 1 → CP11 (skip CP10); 2 → CP10
        # Precondition: arrived via CP07=1 (private) OR CP08=1 (college housing)
        - id: q_cp09
          kind: Question
          title: "Do you currently live in [STATE]?"
          precondition:
            - predicate: q_cp07.outcome == 1 or q_cp08.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CP10: What state do you currently live in?
        # Asked only when CP09 = 2 (not in the sampled state)
        # Original: single-select from US states and territories (FIPS codes 1-56, 66, 72, 78)
        # Modeled as Editbox; ineligible codes (77=outside US, 99=Refused) are
        # TERMINATE paths not captured here.
        - id: q_cp10
          kind: Question
          title: "In what state do you currently live? (Enter the state/territory FIPS code: 1=Alabama … 56=Wyoming, 66=Guam, 72=Puerto Rico, 78=Virgin Islands.)"
          precondition:
            - predicate: q_cp09.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 78
            left: "State FIPS code:"

    # =========================================================================
    # BLOCK 4: LANDLINE OVERLAP AND HOUSEHOLD SIZE (CP11–CP12)
    # =========================================================================
    # CP11: Also have a landline? (dual-frame deduplication flag)
    #        All responses (including DK/R) → CP12
    # CP12: How many adults in household?
    #        Note: If CP08=Yes (college housing), adults is automatically 1.
    #        DK (77) and Refused (99) proceed to Section 1 (system codes).
    # =========================================================================
    - id: b_household
      title: "Landline Overlap and Household Size"
      items:
        # CP11: Landline telephone in home?
        # Asked when: CP09=1 (in sampled state) OR CP10 was answered (valid state)
        # All responses proceed to CP12
        - id: q_cp11
          kind: Question
          title: "Do you also have a landline telephone in your home that is used to make and receive calls?"
          precondition:
            - predicate: q_cp09.outcome == 1 or q_cp10.outcome >= 1
          codeBlock: |
            has_landline = q_cp11.outcome
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CP12: Number of adults in household (18+)
        # Note: When CP08=Yes (college housing), household adult count is
        # automatically 1 per BRFSS protocol. This is handled in codeBlock.
        # DK (77) and Refused (99) proceed to Section 1 as system codes;
        # they are not offered as respondent choices.
        - id: q_cp12
          kind: Question
          title: "How many members of your household, including yourself, are 18 years of age or older?"
          precondition:
            - predicate: q_cp11.outcome >= 1
          codeBlock: |
            if q_cp08.outcome == 1:
              household_adults = 1
            else:
              household_adults = q_cp12.outcome
          input:
            control: Editbox
            min: 1
            max: 97
            left: "Number of adults:"
