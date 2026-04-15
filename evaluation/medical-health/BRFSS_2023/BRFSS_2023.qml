qmlVersion: "1.0"
questionnaire:
  title: "Behavioral Risk Factor Surveillance System 2023"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    gender_identity = 0
    sex_at_birth = 0
    household_adults = 0
    has_landline = 0
    method_count = 0

  blocks:

    # ===================================================================
    # SECTION: landline_intro
    # ===================================================================
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

    # ===================================================================
    # SECTION: cell_phone_intro
    # ===================================================================
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
    - id: b_cell_phone_intro_gender_identity
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

    # ===================================================================
    # SECTION: health_status
    # ===================================================================
    # =========================================================================
    # BLOCK 1: CORE SECTION 1 - HEALTH STATUS (CHS.01)
    # =========================================================================
    - id: b_health_status
      title: "Core Section 1: Health Status"
      items:
        # CHS.01: Self-rated general health
        - id: q_chs_01
          kind: Question
          title: "Would you say that in general your health is—"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

    # =========================================================================
    # BLOCK 2: CORE SECTION 2 - HEALTHY DAYS (CHD.01–CHD.03)
    # =========================================================================
    - id: b_healthy_days
      title: "Core Section 2: Healthy Days"
      items:
        # CHD.01: Days physical health not good (past 30 days)
        # 01–30 = number of days, 88 = None
        - id: q_chd_01
          kind: Question
          title: "Now thinking about your physical health, which includes physical illness and injury, for how many days during the past 30 days was your physical health not good?"
          input:
            control: Editbox
            min: 0
            max: 88
            right: "days (0–30, or 88 for none)"

        # CHD.02: Days mental health not good (past 30 days)
        # 01–30 = number of days, 88 = None
        - id: q_chd_02
          kind: Question
          title: "Now thinking about your mental health, which includes stress, depression, and problems with emotions, for how many days during the past 30 days was your mental health not good?"
          input:
            control: Editbox
            min: 0
            max: 88
            right: "days (0–30, or 88 for none)"

        # CHD.03: Days poor health limited usual activities (past 30 days)
        # CHD.FILTER: Skip CHD.03 if CHD.01=88 AND CHD.02=88 (both "none")
        # 01–30 = number of days, 88 = None
        - id: q_chd_03
          kind: Question
          title: "During the past 30 days, for about how many days did poor physical or mental health keep you from doing your usual activities, such as self-care, work, or recreation?"
          precondition:
            - predicate: not (q_chd_01.outcome == 88 and q_chd_02.outcome == 88)
          input:
            control: Editbox
            min: 0
            max: 88
            right: "days (0–30, or 88 for none)"

    # =========================================================================
    # BLOCK 3: CORE SECTION 3 - HEALTH CARE ACCESS (CHCA.01–CHCA.04)
    # =========================================================================
    - id: b_health_care_access
      title: "Core Section 3: Health Care Access"
      items:
        # CHCA.01: Primary health insurance source
        # 10+ options → Dropdown
        - id: q_chca_01
          kind: Question
          title: "What is the current source of your primary health insurance?"
          input:
            control: Dropdown
            labels:
              1: "Employer/union plan"
              2: "Private nongovernmental plan"
              3: "Medicare"
              4: "Medigap"
              5: "Medicaid"
              6: "CHIP"
              7: "Military/TRICARE/VA/CHAMP-VA"
              8: "Indian Health Service"
              9: "State sponsored health plan"
              10: "Other government program"
              88: "No coverage of any type"

        # CHCA.02: Personal health care provider
        - id: q_chca_02
          kind: Question
          title: "Do you have one person or a group of doctors that you think of as your personal health care provider?"
          input:
            control: Radio
            labels:
              1: "Yes, only one"
              2: "More than one"
              3: "No"

        # CHCA.03: Could not afford doctor visit in past 12 months
        - id: q_chca_03
          kind: Question
          title: "Was there a time in the past 12 months when you needed to see a doctor but could not because you could not afford it?"
          input:
            control: Switch

        # CHCA.04: Time since last routine checkup
        - id: q_chca_04
          kind: Question
          title: "About how long has it been since you last visited a doctor for a routine checkup?"
          input:
            control: Radio
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 5 years"
              4: "5 or more years ago"
              8: "Never"

    # ===================================================================
    # SECTION: exercise
    # ===================================================================
    # =========================================================================
    # BLOCK 1: CORE SECTION 4 - EXERCISE / PHYSICAL ACTIVITY (CEXP.01–CEXP.08)
    # =========================================================================
    - id: b_exercise
      title: "Core Section 4: Exercise / Physical Activity"
      items:
        # CEXP.01: Any physical activity past month (besides regular job)
        # 1 (Yes) → CEXP.02; 2 (No) / DK / R → CEXP.08
        - id: q_cexp_01
          kind: Question
          title: "During the past month, other than your regular job, did you participate in any physical activities or exercises such as running, calisthenics, golf, gardening, or walking for exercise?"
          input:
            control: Switch

        # CEXP.02: Type of primary physical activity (activity code from list)
        # Precondition: CEXP.01 = Yes (on)
        # DK / R → CEXP.08 (modeled: if DK/R are not captured, flow continues to CEXP.03)
        # Coded as numeric activity code (1–99)
        - id: q_cexp_02
          kind: Question
          title: "What type of physical activity or exercise did you spend the most time doing during the past month? (Enter the activity code from the Physical Activity Coding List)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99
            right: "activity code"

        # CEXP.03: Frequency of primary activity (times per week or per month)
        # Precondition: CEXP.01 = Yes
        # 1XX = per week (101–176), 2XX = per month (201–230)
        # Modeled as 0–299
        - id: q_cexp_03
          kind: Question
          title: "How many times per week or per month did you take part in this activity during the past month? (Enter 1XX for times per week, e.g. 103 = 3 times/week; or 2XX for times per month, e.g. 212 = 12 times/month)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 299
            right: "frequency code"

        # CEXP.04: Duration of primary activity (minutes per session)
        # Precondition: CEXP.01 = Yes
        - id: q_cexp_04
          kind: Question
          title: "And when you took part in this activity, for how many minutes or hours did you usually keep at it? (Enter minutes)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999
            right: "minutes"

        # CEXP.05: Second most-exercised activity type (or 88 = no other activity)
        # Precondition: CEXP.01 = Yes
        # 88 (No other) / DK / R → CEXP.08
        # Coded as numeric activity code (1–99) or 88
        - id: q_cexp_05
          kind: Question
          title: "What other type of physical activity gave you the next most exercise during the past month? (Enter the activity code, or 88 for no other activity)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99
            right: "activity code (or 88 = none)"

        # CEXP.06: Frequency of second activity
        # Precondition: CEXP.01 = Yes AND CEXP.05 is a valid activity (not 88)
        - id: q_cexp_06
          kind: Question
          title: "How many times per week or per month did you take part in this activity during the past month? (Enter 1XX for times per week or 2XX for times per month)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
            - predicate: q_cexp_05.outcome != 88
          input:
            control: Editbox
            min: 0
            max: 299
            right: "frequency code"

        # CEXP.07: Duration of second activity (minutes per session)
        # Precondition: CEXP.01 = Yes AND CEXP.05 is a valid activity (not 88)
        - id: q_cexp_07
          kind: Question
          title: "And when you took part in this activity, for how many minutes or hours did you usually keep at it? (Enter minutes)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
            - predicate: q_cexp_05.outcome != 88
          input:
            control: Editbox
            min: 0
            max: 999
            right: "minutes"

        # CEXP.08: Muscle-strengthening activity frequency
        # Asked of all respondents (no precondition)
        # 1XX = per week, 2XX = per month, 888 = Never
        - id: q_cexp_08
          kind: Question
          title: "During the past month, how many times per week or per month did you do physical activities or exercises to strengthen your muscles? (Enter 1XX for times per week, 2XX for times per month, or 888 for never)"
          input:
            control: Editbox
            min: 0
            max: 999
            right: "frequency code (or 888 = never)"

    # ===================================================================
    # SECTION: cardiovascular
    # ===================================================================
    # =========================================================================
    # CORE 5: HYPERTENSION AWARENESS (CHYPA)
    # =========================================================================
    # CHYPA.01: Always asked.
    # CHYPA.02: Asked only if CHYPA.01 == 1 (Yes) or == 4 (Borderline/pre-hypertensive)
    #           All other outcomes (2, 3, DK=7, R=9) skip to next section.
    # =========================================================================
    - id: b_hypertension
      title: "Hypertension Awareness"
      items:
        # CHYPA.01: Ever told have high blood pressure
        - id: q_chypa_01
          kind: Question
          title: "Have you ever been told by a doctor, nurse, or other health professional that you have high blood pressure?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, but only told during pregnancy"
              3: "No"
              4: "Told borderline high or pre-hypertensive"

        # CHYPA.02: Currently taking prescription medicine for high blood pressure
        # Precondition: CHYPA.01 = Yes (1) or Borderline (4)
        - id: q_chypa_02
          kind: Question
          title: "Are you currently taking prescription medicine for your high blood pressure?"
          precondition:
            - predicate: q_chypa_01.outcome == 1 or q_chypa_01.outcome == 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # CORE 6: CHOLESTEROL AWARENESS (CCHLA)
    # =========================================================================
    # CCHLA.01: Always asked.
    #   1 (Never) → skip to next section (CCHLA.02 and CCHLA.03 not shown)
    #   2–6, 8 → ask CCHLA.02
    #   9 (R) → ask CCHLA.02 (Refused treated same as checked)
    #   7 (DK) → skip to next section
    # CCHLA.02 → CCHLA.03: Always asked if precondition met (no skip within).
    # =========================================================================
    - id: b_cholesterol
      title: "Cholesterol Awareness"
      items:
        # CCHLA.01: Time since last cholesterol check
        - id: q_cchla_01
          kind: Question
          title: "Cholesterol is a fatty substance found in the blood. About how long has it been since you last had your cholesterol checked?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "Within past year (less than 12 months ago)"
              3: "Within past 2 years (1 year but less than 2 years ago)"
              4: "Within past 3 years (2 years but less than 3 years ago)"
              5: "Within past 4 years (3 years but less than 4 years ago)"
              6: "Within past 5 years (4 years but less than 5 years ago)"
              8: "5 or more years ago"

        # CCHLA.02: Ever told blood cholesterol is high
        # Precondition: CCHLA.01 != 1 (not Never)
        # Note: Refused (9) on CCHLA.01 is also routed here per instrument routing.
        - id: q_cchla_02
          kind: Question
          title: "Have you ever been told by a doctor, nurse or other health professional that your blood cholesterol is high?"
          precondition:
            - predicate: q_cchla_01.outcome != 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHLA.03: Currently taking prescribed cholesterol medicine
        # Precondition: CCHLA.01 != 1 (not Never) — same gate as CCHLA.02
        - id: q_cchla_03
          kind: Question
          title: "Are you currently taking medicine prescribed by your doctor or other health professional for your cholesterol?"
          precondition:
            - predicate: q_cchla_01.outcome != 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: chronic_conditions
    # ===================================================================
    # =========================================================================
    # CORE 7: CHRONIC HEALTH CONDITIONS (CCHC)
    # =========================================================================
    # CCHC.01–03: Always asked, sequential, no skip logic.
    # CCHC.04: Always asked.
    #   1 (Yes) → ask CCHC.05; 2 (No) / 7 (DK) / 9 (R) → skip CCHC.05
    # CCHC.05: Precondition: CCHC.04 == 1 (Yes).
    # CCHC.06–11: Always asked, sequential, no skip logic.
    # CCHC.12: Always asked.
    #   1 (Yes) → ask CCHC.13; 2 / 3 / 4 / 7 / 9 → skip CCHC.13
    # CCHC.13: Precondition: CCHC.12 == 1 (Yes — active diabetes).
    # =========================================================================
    - id: b_chronic_conditions
      title: "Chronic Health Conditions"
      items:
        # CCHC.01: Heart attack / myocardial infarction
        - id: q_cchc_01
          kind: Question
          title: "(Ever told) you had a heart attack also called a myocardial infarction?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.02: Angina or coronary heart disease
        - id: q_cchc_02
          kind: Question
          title: "(Ever told) (you had) angina or coronary heart disease?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.03: Stroke
        - id: q_cchc_03
          kind: Question
          title: "(Ever told) (you had) a stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.04: Asthma (ever told)
        - id: q_cchc_04
          kind: Question
          title: "(Ever told) (you had) asthma?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.05: Still have asthma
        # Precondition: CCHC.04 = Yes (1)
        - id: q_cchc_05
          kind: Question
          title: "Do you still have asthma?"
          precondition:
            - predicate: q_cchc_04.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.06: Skin cancer (non-melanoma)
        - id: q_cchc_06
          kind: Question
          title: "(Ever told) (you had) skin cancer that is not melanoma?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.07: Melanoma or other cancer
        - id: q_cchc_07
          kind: Question
          title: "(Ever told) (you had) any melanoma or any other types of cancer?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.08: COPD / emphysema / chronic bronchitis
        - id: q_cchc_08
          kind: Question
          title: "(Ever told) (you had) C.O.P.D., emphysema or chronic bronchitis?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.09: Depressive disorder
        - id: q_cchc_09
          kind: Question
          title: "(Ever told) (you had) a depressive disorder (including depression, major depression, dysthymia, or minor depression)?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.10: Kidney disease (excluding stones, bladder infection, incontinence)
        - id: q_cchc_10
          kind: Question
          title: "Not including kidney stones, bladder infection or incontinence, were you ever told you had kidney disease?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.11: Arthritis / rheumatoid arthritis / gout / lupus / fibromyalgia
        - id: q_cchc_11
          kind: Question
          title: "(Ever told) (you had) some form of arthritis, rheumatoid arthritis, gout, lupus, or fibromyalgia?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.12: Diabetes
        - id: q_cchc_12
          kind: Question
          title: "(Ever told) (you had) diabetes?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, but only during pregnancy"
              3: "No"
              4: "No, pre-diabetes or borderline diabetes"

        # CCHC.13: Age first told had diabetes
        # Precondition: CCHC.12 = Yes (1) — active diabetes diagnosis only
        - id: q_cchc_13
          kind: Question
          title: "How old were you when you were first told you had diabetes?"
          precondition:
            - predicate: q_cchc_12.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 97

    # ===================================================================
    # SECTION: demographics
    # ===================================================================
    - id: b_demographics
      title: "Demographics"
      items:
        # CDEM.01: Age in years
        - id: q_cdem_01
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 18
            max: 99

        # CDEM.02: Hispanic/Latino origin — multi-select
        - id: q_cdem_02
          kind: Question
          title: "Are you Hispanic, Latino/a, or Spanish origin? (Select all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Mexican, Mexican American, Chicano/a"
              2: "Puerto Rican"
              4: "Cuban"
              8: "Another Hispanic, Latino/a, or Spanish origin"
              16: "No"

        # CDEM.03: Race — multi-select (simplified to main categories)
        - id: q_cdem_03
          kind: Question
          title: "Which one or more of the following would you say is your race? (Select all that apply)"
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African American"
              4: "American Indian or Alaska Native"
              8: "Asian"
              16: "Pacific Islander"
              32: "Other"

        # CDEM.04: Marital status — 6 options → Dropdown
        - id: q_cdem_04
          kind: Question
          title: "Are you...?"
          input:
            control: Dropdown
            labels:
              1: "Married"
              2: "Divorced"
              3: "Widowed"
              4: "Separated"
              5: "Never married"
              6: "Member of an unmarried couple"

        # CDEM.05: Education level — 6 options → Dropdown
        - id: q_cdem_05
          kind: Question
          title: "What is the highest grade or year of school you completed?"
          input:
            control: Dropdown
            labels:
              1: "Never attended school or only attended kindergarten"
              2: "Grades 1 through 8 (Elementary)"
              3: "Grades 9 through 11 (Some high school)"
              4: "Grade 12 or GED (High school graduate)"
              5: "College 1 year to 3 years (Some college or technical school)"
              6: "College 4 years or more (College graduate)"

        # CDEM.06: Home ownership — 3 options → Radio
        - id: q_cdem_06
          kind: Question
          title: "Do you own or rent your home?"
          input:
            control: Radio
            labels:
              1: "Own"
              2: "Rent"
              3: "Other arrangement"

        # CDEM.07: County ANSI code
        - id: q_cdem_07
          kind: Question
          title: "In what county do you currently live?"
          input:
            control: Editbox
            min: 1
            max: 999

        # CDEM.08: ZIP code
        - id: q_cdem_08
          kind: Question
          title: "What is the ZIP Code where you currently live?"
          input:
            control: Editbox
            min: 1
            max: 99999

        # CDEM.09: Multiple landline numbers — landline interviews only
        - id: q_cdem_09
          kind: Question
          title: "Not including cell phones or numbers used for computers, fax machines, or security systems, do you have more than one landline telephone number in your household?"
          precondition:
            - predicate: "interview_mode == 1"
          input:
            control: Switch

        # CDEM.10: Number of residential landline numbers — only if CDEM.09=Yes
        - id: q_cdem_10
          kind: Question
          title: "How many of these landline telephone numbers are residential numbers?"
          precondition:
            - predicate: "interview_mode == 1"
            - predicate: "q_cdem_09.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 6

        # CDEM.11: Number of personal cell phones
        - id: q_cdem_11
          kind: Question
          title: "How many cell phones do you have for personal use?"
          input:
            control: Editbox
            min: 0
            max: 6

        # CDEM.12: Military service
        - id: q_cdem_12
          kind: Question
          title: "Have you ever served on active duty in the United States Armed Forces, either in the regular military or in a National Guard or military reserve unit?"
          input:
            control: Switch

        # CDEM.13: Employment status — 8 options → Dropdown
        - id: q_cdem_13
          kind: Question
          title: "Are you currently...?"
          input:
            control: Dropdown
            labels:
              1: "Employed for wages"
              2: "Self-employed"
              3: "Out of work for 1 year or more"
              4: "Out of work for less than 1 year"
              5: "A homemaker"
              6: "A student"
              7: "Retired"
              8: "Unable to work"

        # CDEM.14: Children under 18 in household (88 = none)
        - id: q_cdem_14
          kind: Question
          title: "How many children less than 18 years of age live in your household?"
          input:
            control: Editbox
            min: 0
            max: 88

        # CDEM.15: Annual household income — 11 categories → Dropdown
        - id: q_cdem_15
          kind: Question
          title: "Is your annual household income from all sources—?"
          input:
            control: Dropdown
            labels:
              1: "Less than $10,000"
              2: "$10,000 to less than $15,000"
              3: "$15,000 to less than $20,000"
              4: "$20,000 to less than $25,000"
              5: "$25,000 to less than $35,000"
              6: "$35,000 to less than $50,000"
              7: "$50,000 to less than $75,000"
              8: "$75,000 to less than $100,000"
              9: "$100,000 to less than $150,000"
              10: "$150,000 to less than $200,000"
              11: "$200,000 or more"

        # CDEM.16: Pregnancy — only for females age ≤ 49
        - id: q_cdem_16
          kind: Question
          title: "To your knowledge, are you now pregnant?"
          precondition:
            - predicate: "sex_at_birth == 2 and q_cdem_01.outcome <= 49"
          input:
            control: Switch

        # CDEM.17: Weight in pounds
        - id: q_cdem_17
          kind: Question
          title: "About how much do you weigh without shoes? (pounds)"
          input:
            control: Editbox
            min: 50
            max: 999

        # CDEM.18: Height in inches
        - id: q_cdem_18
          kind: Question
          title: "About how tall are you without shoes? (inches)"
          input:
            control: Editbox
            min: 36
            max: 95

    # ===================================================================
    # SECTION: disability_falls
    # ===================================================================
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

    # ===================================================================
    # SECTION: tobacco_alcohol
    # ===================================================================
    # =========================================================================
    # CORE 11: TOBACCO USE (CTOB.01–CTOB.04)
    # =========================================================================
    # CTOB.01: Have you smoked 100+ cigarettes in your entire life?
    #   1 (Yes) → ask CTOB.02
    #   2 (No)  → skip CTOB.02, go to CTOB.03
    #
    # CTOB.02: Current cigarette smoking frequency. Precondition: CTOB.01 == 1.
    # CTOB.03: Smokeless tobacco use — always asked (no skip routing).
    # CTOB.04: E-cigarette / vaping use — always asked.
    # =========================================================================
    - id: b_tobacco
      title: "Core Section 11: Tobacco Use"
      items:
        # CTOB.01: 100+ cigarettes smoked in lifetime
        - id: q_ctob_01
          kind: Question
          title: "Have you smoked at least 100 cigarettes in your entire life?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CTOB.02: Current cigarette smoking frequency
        # Precondition: CTOB.01 = Yes (1)
        - id: q_ctob_02
          kind: Question
          title: "Do you now smoke cigarettes every day, some days, or not at all?"
          precondition:
            - predicate: q_ctob_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"

        # CTOB.03: Smokeless tobacco use (chewing tobacco, snuff, snus)
        # No skip routing; always asked regardless of prior answers.
        - id: q_ctob_03
          kind: Question
          title: "Do you currently use chewing tobacco, snuff, or snus every day, some days, or not at all?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"

        # CTOB.04: E-cigarette / electronic vaping product use
        - id: q_ctob_04
          kind: Question
          title: "Would you say you have never used e-cigarettes or other electronic vaping products in your entire life, or now use them every day, use them some days, or used them in the past but do not currently use them at all?"
          input:
            control: Radio
            labels:
              1: "Never used"
              2: "Use every day"
              3: "Use some days"
              4: "Not at all right now"

    # =========================================================================
    # CORE 12: ALCOHOL CONSUMPTION (CALC.01–CALC.04)
    # =========================================================================
    # CALC.PROLOGUE is a read/instruction node (no response captured).
    #
    # CALC.01: Drinking days in past 30 days.
    #   0 (no drinks) → skip CALC.02–CALC.04, go to next section.
    #   >0            → ask CALC.02 onward.
    #   Note: Original instrument codes "days per week" as 1XX and "days per
    #   month" as 2XX. This file uses a simplified Editbox (0–30 days per month)
    #   consistent with the 30-day reference frame used in follow-up questions.
    #
    # CALC.02: Average drinks per drinking day. Precondition: CALC.01 > 0.
    # CALC.03: Binge drinking occasions. Precondition: CALC.01 > 0.
    #   Threshold varies by sex (5+ drinks for men, 4+ for women); the label
    #   reflects this variation as it appears in the administered instrument.
    # CALC.04: Largest number of drinks on any single occasion. Precondition: CALC.01 > 0.
    # =========================================================================
    - id: b_alcohol
      title: "Core Section 12: Alcohol Consumption"
      items:
        # CALC.PROLOGUE: Introductory instruction (no response captured)
        - id: q_calc_prologue
          kind: Comment
          title: "The next questions concern alcohol consumption. One drink of alcohol is equivalent to a 12-ounce beer, a 5-ounce glass of wine, or a drink with one shot of liquor."

        # CALC.01: Drinking days in past 30 days
        # 0 = no drinks in past 30 days; 1–30 = number of days
        - id: q_calc_01
          kind: Question
          title: "During the past 30 days, how many days per week or per month did you have at least one drink of any alcoholic beverage?"
          input:
            control: Editbox
            min: 0
            max: 30
            right: "days in past 30 days (0 = none)"

        # CALC.02: Average drinks per drinking day
        # Precondition: reported at least one drinking day
        - id: q_calc_02
          kind: Question
          title: "During the past 30 days, on the days when you drank, about how many drinks did you drink on the average?"
          precondition:
            - predicate: q_calc_01.outcome > 0
          input:
            control: Editbox
            min: 1
            max: 76
            right: "drinks"

        # CALC.03: Binge drinking occasions (5+ drinks for men, 4+ for women)
        # Precondition: reported at least one drinking day
        - id: q_calc_03
          kind: Question
          title: "Considering all types of alcoholic beverages, how many times during the past 30 days did you have 5 or more drinks on an occasion (4 or more for women)?"
          precondition:
            - predicate: q_calc_01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 76
            right: "times (0 = none)"

        # CALC.04: Largest number of drinks on any single occasion
        # Precondition: reported at least one drinking day
        - id: q_calc_04
          kind: Question
          title: "During the past 30 days, what is the largest number of drinks you had on any occasion?"
          precondition:
            - predicate: q_calc_01.outcome > 0
          input:
            control: Editbox
            min: 1
            max: 76
            right: "drinks"

    # ===================================================================
    # SECTION: immunization_hiv_seatbelt
    # ===================================================================
    # =========================================================================
    # CORE 13: IMMUNIZATION (CIMM.01–CIMM.04)
    # =========================================================================
    # CIMM.01: Flu vaccine in past 12 months.
    #   1 (Yes) → ask CIMM.02 (flu vaccine date)
    #   2 (No)  → skip CIMM.02, go to CIMM.03
    #
    # CIMM.02: Month of most recent flu vaccine. Precondition: CIMM.01 == 1.
    #   Date collected as month (1–12) since the source instrument collects MM/YYYY;
    #   year is not modeled here as it is always within the past 12 months.
    #
    # CIMM.03: Ever had pneumonia / pneumococcal vaccine — always asked.
    #
    # CIMM.04: Ever had shingles / zoster vaccine.
    #   Precondition: age >= 50 (only relevant for respondents 50 or older).
    # =========================================================================
    - id: b_immunization
      title: "Core Section 13: Immunization"
      items:
        # CIMM.01: Flu vaccine in past 12 months
        - id: q_cimm_01
          kind: Question
          title: "During the past 12 months, have you had either a flu vaccine that was sprayed in your nose or a flu shot injected into your arm?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CIMM.02: Month of most recent flu vaccine
        # Precondition: CIMM.01 = Yes (1)
        - id: q_cimm_02
          kind: Question
          title: "During what month did you receive your most recent flu vaccine?"
          precondition:
            - predicate: q_cimm_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 12
            right: "month (1 = January, 12 = December)"

        # CIMM.03: Ever had pneumonia / pneumococcal vaccine
        # No skip routing; always asked after CIMM.01 (or CIMM.02 if flu shot).
        - id: q_cimm_03
          kind: Question
          title: "Have you ever had a pneumonia shot also known as a pneumococcal vaccine?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CIMM.04: Ever had shingles / zoster vaccine
        # Precondition: age >= 50 (instrument routes age < 50 to next section)
        - id: q_cimm_04
          kind: Question
          title: "Have you ever had the shingles or zoster vaccine?"
          precondition:
            - predicate: age >= 50
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # CORE 14: H.I.V. / AIDS (CHIV.01–CHIV.02)
    # =========================================================================
    # CHIV.01: Ever been tested for HIV.
    #   1 (Yes) → ask CHIV.02 (date of last test)
    #   2 (No)  → skip CHIV.02, go to next section
    #
    # CHIV.02: Month of most recent HIV test. Precondition: CHIV.01 == 1.
    # =========================================================================
    - id: b_hiv
      title: "Core Section 14: H.I.V./AIDS"
      items:
        # CHIV.01: Ever been tested for HIV (excluding blood donation tests)
        - id: q_chiv_01
          kind: Question
          title: "Including fluid testing from your mouth, but not including tests you may have had for blood donation, have you ever been tested for H.I.V?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHIV.02: Month of most recent HIV test
        # Precondition: CHIV.01 = Yes (1)
        - id: q_chiv_02
          kind: Question
          title: "Not including blood donations, in what month was your last H.I.V. test?"
          precondition:
            - predicate: q_chiv_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 12
            right: "month (1 = January, 12 = December)"

    # =========================================================================
    # CORE 15: SEAT BELT / DRINKING AND DRIVING (CSBD.01–CSBD.02)
    # =========================================================================
    # CSBD.01: Seat belt use frequency.
    #   8 (Never drive or ride in a car) → skip CSBD.02, go to next section
    #   All other responses → CSBD.FILTER
    #
    # CSBD.FILTER: If alcohol_days == 0 (no drinks in past 30 days) →
    #              skip CSBD.02, go to next section.
    #
    # CSBD.02: Driving after drinking too much.
    #   Precondition: CSBD.01 != 8 (respondent drives or rides)
    #             AND alcohol_days > 0 (drank in past 30 days)
    # =========================================================================
    - id: b_seatbelt
      title: "Core Section 15: Seat Belt Use / Drinking and Driving"
      items:
        # CSBD.01: Seat belt use frequency
        - id: q_csbd_01
          kind: Question
          title: "How often do you use seat belts when you drive or ride in a car? Would you say—"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Nearly always"
              3: "Sometimes"
              4: "Seldom"
              5: "Never"
              8: "Never drive or ride in a car"

        # CSBD.02: Times driven after perhaps too much to drink (past 30 days)
        # Precondition: respondent drives/rides AND drank in past 30 days
        - id: q_csbd_02
          kind: Question
          title: "During the past 30 days, how many times have you driven when you've had perhaps too much to drink?"
          precondition:
            - predicate: q_csbd_01.outcome != 8
            - predicate: alcohol_days > 0
          input:
            control: Editbox
            min: 0
            max: 76
            right: "times (0 = none)"

    # =========================================================================
    # EMERGING CORE: LONG-TERM COVID EFFECTS (COVID.01–COVID.03)
    # =========================================================================
    # COVID.01: Ever tested positive for COVID-19 or diagnosed by provider.
    #   1 (Yes) → ask COVID.02
    #   2 (No)  → skip COVID.02 and COVID.03, go to closing/modules
    #
    # COVID.02: Currently have long-term symptoms (3+ months).
    #   Precondition: COVID.01 == 1
    #   1 (Yes) → ask COVID.03
    #   2 (No)  → skip COVID.03, go to closing/modules
    #
    # COVID.03: Long-term symptoms reduce day-to-day activities.
    #   Precondition: COVID.01 == 1 AND COVID.02 == 1
    # =========================================================================
    - id: b_covid
      title: "Emerging Core: Long-term COVID Effects"
      items:
        # COVID.01: Ever diagnosed with / tested positive for COVID-19
        - id: q_covid_01
          kind: Question
          title: "Have you ever tested positive for COVID-19 or been told by a doctor or other health care provider that you have or had COVID-19?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # COVID.02: Currently experiencing long-term COVID symptoms (3+ months)
        # Precondition: COVID.01 = Yes (1)
        - id: q_covid_02
          kind: Question
          title: "Do you currently have symptoms lasting 3 months or longer that you did not have prior to having coronavirus or COVID-19?"
          precondition:
            - predicate: q_covid_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # COVID.03: Extent to which long-term symptoms limit day-to-day activities
        # Precondition: COVID.01 = Yes (1) AND COVID.02 = Yes (1)
        - id: q_covid_03
          kind: Question
          title: "Do these long-term symptoms reduce your ability to carry out day-to-day activities compared with the time before you had COVID-19?"
          precondition:
            - predicate: q_covid_01.outcome == 1
            - predicate: q_covid_02.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, a lot"
              2: "Yes, a little"
              3: "Not at all"

    # ===================================================================
    # SECTION: diabetes
    # ===================================================================
    # =========================================================================
    # MODULE 1: PREDIABETES (MPDIAB)
    # =========================================================================
    # Module filter: Skip if CCHC.12=1 (respondent already has diabetes).
    # If CCHC.12=4 (prediabetes), auto-code MPDIAB.02=1 (Yes) — modelled by
    # block precondition; when diabetes_status==4 the interviewer reads
    # MPDIAB.01 but MPDIAB.02 is not needed (already confirmed prediabetes).
    # For QML we include MPDIAB.02 for all non-diabetic respondents since the
    # auto-code case (diabetes_status==4) would simply produce outcome 1.
    # =========================================================================
    - id: b_prediabetes
      title: "Module 1: Prediabetes"
      precondition:
        - predicate: diabetes_status != 1
      items:
        # MPDIAB.01: Last blood sugar / diabetes test
        - id: q_mpdiab_01
          kind: Question
          title: "When was the last time you had a blood test for high blood sugar or diabetes by a doctor, nurse, or other health professional?"
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 3 years"
              4: "Within past 5 years"
              5: "Within past 10 years"
              6: "10 or more years ago"
              8: "Never"

        # MPDIAB.02: Ever told prediabetes or borderline diabetes
        # Auto-coded to 1 when diabetes_status==4; asked otherwise
        - id: q_mpdiab_02
          kind: Question
          title: "Has a doctor or other health professional ever told you that you had prediabetes or borderline diabetes?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, during pregnancy"
              3: "No"

    # =========================================================================
    # MODULE 2: DIABETES (MDIAB)
    # =========================================================================
    # Module filter: Ask only if CCHC.12=1 (respondent has diabetes).
    # =========================================================================
    - id: b_diabetes
      title: "Module 2: Diabetes"
      precondition:
        - predicate: diabetes_status == 1
      items:
        # MDIAB.01: Type of diabetes
        - id: q_mdiab_01
          kind: Question
          title: "According to your doctor or other health professional, what type of diabetes do you have?"
          input:
            control: Radio
            labels:
              1: "Type 1"
              2: "Type 2"

        # MDIAB.02: Currently taking insulin
        - id: q_mdiab_02
          kind: Question
          title: "Insulin can be taken by shot or pump. Are you now taking insulin?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MDIAB.03: Number of A1C checks in past 12 months
        - id: q_mdiab_03
          kind: Question
          title: "About how many times in the past 12 months has a doctor, nurse, or other health professional checked you for A-one-C?"
          input:
            control: Editbox
            min: 0
            max: 76

        # MDIAB.04: Last dilated eye exam
        - id: q_mdiab_04
          kind: Question
          title: "When was the last time you had an eye exam in which the pupils were dilated?"
          input:
            control: Dropdown
            labels:
              1: "Within past month"
              2: "Within past year"
              3: "Within past 2 years"
              4: "2 or more years ago"
              8: "Never"

        # MDIAB.05: Last retinal photo
        - id: q_mdiab_05
          kind: Question
          title: "When was the last time a doctor, nurse or other health professional took a photo of the back of your eye with a specialized camera?"
          input:
            control: Dropdown
            labels:
              1: "Within past month"
              2: "Within past year"
              3: "Within past 2 years"
              4: "2 or more years ago"
              8: "Never"

        # MDIAB.06: Last diabetes self-management course
        - id: q_mdiab_06
          kind: Question
          title: "When was the last time you took a course or class in how to manage your diabetes yourself?"
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 3 years"
              4: "Within past 5 years"
              5: "Within past 10 years"
              6: "10 or more years ago"
              8: "Never"

        # MDIAB.07: Foot sores taking more than 4 weeks to heal
        - id: q_mdiab_07
          kind: Question
          title: "Have you ever had any sores or irritations on your feet that took more than four weeks to heal?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: arthritis
    # ===================================================================
    # =========================================================================
    # MODULE 3: ARTHRITIS (MARTH)
    # =========================================================================
    # Module filter: Ask only if CCHC.11=1 (respondent has arthritis).
    # =========================================================================
    - id: b_arthritis
      title: "Module 3: Arthritis"
      precondition:
        - predicate: has_arthritis == 1
      items:
        # MARTH.01: Physical activity suggested
        - id: q_marth_01
          kind: Question
          title: "Has a doctor or other health professional ever suggested physical activity or exercise to help your arthritis or joint symptoms?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MARTH.02: Educational course for arthritis management
        - id: q_marth_02
          kind: Question
          title: "Have you ever taken an educational course or class to teach you how to manage problems related to your arthritis or joint symptoms?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MARTH.03: Limited in usual activities due to arthritis
        - id: q_marth_03
          kind: Question
          title: "Are you now limited in any way in any of your usual activities because of arthritis or joint symptoms?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MARTH.04: Arthritis affects work
        - id: q_marth_04
          kind: Question
          title: "Do arthritis or joint symptoms now affect whether you work, the type of work you do or the amount of work you do?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MARTH.05: Joint pain scale (0–10) in past 30 days
        - id: q_marth_05
          kind: Question
          title: "During the past 30 days, how bad was your joint pain on average on a scale of 0 to 10 where 0 is no pain and 10 is pain as bad as it can be?"
          input:
            control: Editbox
            min: 0
            max: 10

    # ===================================================================
    # SECTION: cancer_screening
    # ===================================================================
    # =========================================================================
    # MODULE 4: LUNG CANCER SCREENING (MLCS)
    # =========================================================================
    # Module filter: If CTOB.01=1 (smoked 100+ cigarettes) AND
    #   CTOB.02=1,2,or 3 (current or former smoker) → ask MLCS.01;
    #   else → skip to MLCS.04.
    # MLCS.04 onward asked for all respondents regardless of smoking history.
    # =========================================================================
    - id: b_lung_cancer_smokers
      title: "Module 4: Lung Cancer Screening - Smoking History"
      precondition:
        - predicate: smoked_100 == 1
      items:
        # MLCS.01: Age when first started smoking regularly
        - id: q_mlcs_01
          kind: Question
          title: "How old were you when you first started to smoke cigarettes regularly?"
          input:
            control: Editbox
            min: 5
            max: 99

        # MLCS.02: Age when last smoked regularly (skip if everyday smoker)
        - id: q_mlcs_02
          kind: Question
          title: "How old were you when you last smoked cigarettes regularly?"
          precondition:
            - predicate: smoking_status != 1
          input:
            control: Editbox
            min: 5
            max: 99

        # MLCS.03: Average cigarettes per day
        - id: q_mlcs_03
          kind: Question
          title: "On average, when you smoked regularly, about how many cigarettes did you usually smoke each day?"
          input:
            control: Editbox
            min: 1
            max: 200

    - id: b_lung_cancer_all
      title: "Module 4: Lung Cancer Screening - CT Scan"
      items:
        # MLCS.04: Ever had CT or CAT scan of chest
        - id: q_mlcs_04
          kind: Question
          title: "Have you ever had a CT or CAT scan of your chest area?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MLCS.05: CT scan done mainly for lung cancer screening
        - id: q_mlcs_05
          kind: Question
          title: "Were any of the CT or CAT scans of your chest area done mainly to check or screen for lung cancer?"
          precondition:
            - predicate: q_mlcs_04.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MLCS.06: When was most recent lung cancer CT scan
        - id: q_mlcs_06
          kind: Question
          title: "When did you have your most recent CT or CAT scan of your chest area mainly to check or screen for lung cancer?"
          precondition:
            - predicate: q_mlcs_04.outcome == 1 and q_mlcs_05.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 3 years"
              4: "Within past 5 years"
              5: "Within past 10 years"
              6: "10 or more years ago"

    # =========================================================================
    # MODULE 5: BREAST AND CERVICAL CANCER SCREENING (MBCCS)
    # =========================================================================
    # Module filter: Skip entire module if male (sex_at_birth == 1).
    # =========================================================================
    - id: b_breast_cervical
      title: "Module 5: Breast and Cervical Cancer Screening"
      precondition:
        - predicate: sex_at_birth == 2
      items:
        # MBCCS.01: Ever had a mammogram
        - id: q_mbccs_01
          kind: Question
          title: "Have you ever had a mammogram?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MBCCS.02: How long since last mammogram
        - id: q_mbccs_02
          kind: Question
          title: "How long has it been since you had your last mammogram?"
          precondition:
            - predicate: q_mbccs_01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 3 years"
              4: "Within past 5 years"
              5: "5 or more years ago"

        # MBCCS.03: Ever had a cervical cancer screening test
        - id: q_mbccs_03
          kind: Question
          title: "Have you ever had a cervical cancer screening test?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MBCCS.04: How long since last cervical cancer screening
        - id: q_mbccs_04
          kind: Question
          title: "How long has it been since you had your last cervical cancer screening test?"
          precondition:
            - predicate: q_mbccs_03.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 3 years"
              4: "Within past 5 years"
              5: "5 or more years ago"

        # MBCCS.05: Pap test at most recent cervical screening
        - id: q_mbccs_05
          kind: Question
          title: "At your most recent cervical cancer screening, did you have a Pap test?"
          precondition:
            - predicate: q_mbccs_03.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MBCCS.06: HPV test at most recent cervical screening
        - id: q_mbccs_06
          kind: Question
          title: "At your most recent cervical cancer screening, did you have an H.P.V. test?"
          precondition:
            - predicate: q_mbccs_03.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MBCCS.07: Ever had a hysterectomy (skip if currently pregnant)
        # MBCCS.FILTER: If CDEM.16=1 (pregnant) → skip to next module
        - id: q_mbccs_07
          kind: Question
          title: "Have you had a hysterectomy?"
          precondition:
            - predicate: is_pregnant == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # MODULE 6: PROSTATE CANCER SCREENING (MPCS)
    # =========================================================================
    # Module filter: Skip if female OR age < 39.
    # =========================================================================
    - id: b_prostate
      title: "Module 6: Prostate Cancer Screening"
      precondition:
        - predicate: sex_at_birth == 1 and age >= 39
      items:
        # MPCS.01: Ever had a PSA test
        - id: q_mpcs_01
          kind: Question
          title: "Have you ever had a P.S.A. test?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MPCS.02: How long since most recent PSA test
        - id: q_mpcs_02
          kind: Question
          title: "About how long has it been since your most recent P.S.A. test?"
          precondition:
            - predicate: q_mpcs_01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 3 years"
              4: "Within past 5 years"
              5: "5 or more years ago"

        # MPCS.03: Main reason for PSA test
        - id: q_mpcs_03
          kind: Question
          title: "What was the main reason you had this P.S.A. test — was it part of a routine exam, because of a problem, or some other reason?"
          precondition:
            - predicate: q_mpcs_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Part of routine exam"
              2: "Because of a problem"
              3: "Other reason"

        # MPCS.04: Who suggested the PSA test
        - id: q_mpcs_04
          kind: Question
          title: "Who first suggested this P.S.A. test: you, your doctor, or someone else?"
          precondition:
            - predicate: q_mpcs_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Self"
              2: "Doctor, nurse, or other health professional"
              3: "Someone else"

        # MPCS.05: Doctor discussed PSA advantages/disadvantages (asked for all)
        - id: q_mpcs_05
          kind: Question
          title: "Did a doctor, nurse, or other health professional EVER talk about the advantages, disadvantages, or both of the P.S.A. test?"
          input:
            control: Dropdown
            labels:
              1: "Advantages only"
              2: "Disadvantages only"
              3: "Both advantages and disadvantages"
              4: "Neither"

    # =========================================================================
    # MODULE 7: COLORECTAL CANCER SCREENING (MCCS)
    # =========================================================================
    # Module filter: Skip if CDEM.01 (age) < 45.
    #
    # Routing summary:
    # MCCS.01 Yes → MCCS.02; No/DK/R → MCCS.06
    # MCCS.02: 1(colonoscopy)→MCCS.03; 2(sigmoid)→MCCS.04;
    #          3(both)→MCCS.03; DK→MCCS.05; R→MCCS.06
    # MCCS.03: if MCCS.02==3 → MCCS.04; else → MCCS.06
    # MCCS.04 → MCCS.06
    # MCCS.05 → MCCS.06
    # MCCS.06 Yes → MCCS.07; No/DK/R → end of module
    # MCCS.07 Yes → MCCS.08; No/DK/R → MCCS.09
    # MCCS.08 → MCCS.09
    # MCCS.09 Yes → MCCS.10; No/DK/R → MCCS.11
    # MCCS.10 → MCCS.11
    # MCCS.11 Yes → MCCS.12; No/DK/R → end
    # MCCS.12 → MCCS.13
    # =========================================================================
    - id: b_colorectal
      title: "Module 7: Colorectal Cancer Screening"
      precondition:
        - predicate: age >= 45
      items:
        # MCCS.01: Ever had colonoscopy or sigmoidoscopy
        - id: q_mccs_01
          kind: Question
          title: "Have you ever had a colonoscopy or sigmoidoscopy?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCCS.02: Which procedure(s) — colonoscopy, sigmoidoscopy, or both
        - id: q_mccs_02
          kind: Question
          title: "Have you had a colonoscopy, a sigmoidoscopy, or both?"
          precondition:
            - predicate: q_mccs_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Colonoscopy"
              2: "Sigmoidoscopy"
              3: "Both"

        # MCCS.03: How long since most recent colonoscopy
        # Asked when MCCS.02=1 (colonoscopy) or MCCS.02=3 (both)
        - id: q_mccs_03
          kind: Question
          title: "How long has it been since your most recent colonoscopy?"
          precondition:
            - predicate: q_mccs_01.outcome == 1 and (q_mccs_02.outcome == 1 or q_mccs_02.outcome == 3)
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 5 years"
              4: "Within past 10 years"
              5: "10 or more years ago"

        # MCCS.04: How long since most recent sigmoidoscopy
        # Asked when MCCS.02=2 (sigmoidoscopy) or MCCS.02=3 (both, after MCCS.03)
        - id: q_mccs_04
          kind: Question
          title: "How long has it been since your most recent sigmoidoscopy?"
          precondition:
            - predicate: q_mccs_01.outcome == 1 and (q_mccs_02.outcome == 2 or q_mccs_02.outcome == 3)
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 5 years"
              4: "Within past 10 years"
              5: "10 or more years ago"

        # MCCS.05: How long since most recent colonoscopy or sigmoidoscopy (DK path)
        # In CATI source: asked when MCCS.02=DK (respondent doesn't know which type).
        # DK/R are not modelled as labelled options, so this item is unreachable
        # through normal Radio outcome values {1, 2, 3}. Represented as a Comment
        # to preserve the routing documentation without creating a dead node.
        - id: q_mccs_05
          kind: Comment
          title: "ROUTING NOTE: If respondent did not know which scope type (MCCS.02=DK), ask: How long has it been since your most recent colonoscopy or sigmoidoscopy? {1=Within past year, 2=Within past 2 years, 3=Within past 5 years, 4=Within past 10 years, 5=10+ years ago}"

        # MCCS.06: Ever had other colorectal cancer test (all respondents reach this)
        - id: q_mccs_06
          kind: Question
          title: "Have you ever had any other kind of test for colorectal cancer, such as virtual colonoscopy, CT colonography, blood stool test, FIT DNA, or Cologuard test?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCCS.07: Ever had virtual colonoscopy
        - id: q_mccs_07
          kind: Question
          title: "Have you ever had a virtual colonoscopy?"
          precondition:
            - predicate: q_mccs_06.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCCS.08: When was most recent CT colonography / virtual colonoscopy
        - id: q_mccs_08
          kind: Question
          title: "When was your most recent CT colonography or virtual colonoscopy?"
          precondition:
            - predicate: q_mccs_06.outcome == 1 and q_mccs_07.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 5 years"
              4: "Within past 10 years"
              5: "10 or more years ago"

        # MCCS.09: Ever had blood stool test or FIT test at home
        - id: q_mccs_09
          kind: Question
          title: "Have you ever had a blood stool test or FIT test using a special kit at home?"
          precondition:
            - predicate: q_mccs_06.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCCS.10: How long since blood stool / FIT test
        - id: q_mccs_10
          kind: Question
          title: "How long has it been since you had this test?"
          precondition:
            - predicate: q_mccs_06.outcome == 1 and q_mccs_09.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 3 years"
              4: "Within past 5 years"
              5: "5 or more years ago"

        # MCCS.11: Ever had Cologuard or FIT-DNA stool test at home
        - id: q_mccs_11
          kind: Question
          title: "Have you ever had a Cologuard or FIT-DNA stool test using a special kit at home?"
          precondition:
            - predicate: q_mccs_06.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCCS.12: Was the blood stool or FIT done as part of Cologuard
        - id: q_mccs_12
          kind: Question
          title: "Was the blood stool or FIT you reported earlier conducted as part of a Cologuard test?"
          precondition:
            - predicate: q_mccs_06.outcome == 1 and q_mccs_11.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCCS.13: How long since Cologuard / FIT-DNA test
        - id: q_mccs_13
          kind: Question
          title: "How long has it been since you had this test?"
          precondition:
            - predicate: q_mccs_06.outcome == 1 and q_mccs_11.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Within past year"
              2: "Within past 2 years"
              3: "Within past 3 years"
              4: "Within past 5 years"
              5: "5 or more years ago"

    # ===================================================================
    # SECTION: cancer_survivorship
    # ===================================================================
    # =========================================================================
    # MODULE 8: CANCER SURVIVORSHIP — TYPE OF CANCER (MTOC)
    # =========================================================================
    # Entry filter: respondent reported skin cancer (CCHC.06=1) OR other
    # cancer (CCHC.07=1).  Block precondition enforces this.
    #
    # MTOC.01: How many cancer types (1/2/3+). DK/R → skip to next module.
    # MTOC.02: Age at (first) cancer diagnosis. Editbox 0–97 (97=97+).
    # MTOC.03: Type of cancer. Dropdown of 30 types.
    # =========================================================================
    - id: b_cancer_type
      title: "Module 8: Cancer Survivorship — Type of Cancer"
      precondition:
        - predicate: has_skin_cancer == 1 or has_other_cancer == 1
      items:
        # MTOC.01: Number of cancer types
        - id: q_mtoc_01
          kind: Question
          title: "How many different types of cancer have you had?"
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two"
              3: "Three or more"

        # MTOC.02: Age at (first) cancer diagnosis
        # All MTOC.01 responses (1–3) continue to MTOC.02.
        - id: q_mtoc_02
          kind: Question
          title: "At what age were you (first) told that you had cancer?"
          input:
            control: Editbox
            min: 0
            max: 97
            right: "years (enter 97 for 97 or older)"

        # MTOC.03: Type of cancer (30 categories)
        - id: q_mtoc_03
          kind: Question
          title: "What type of cancer was it?"
          input:
            control: Dropdown
            labels:
              1: "Bladder"
              2: "Blood"
              3: "Bone"
              4: "Brain"
              5: "Breast"
              6: "Cervix"
              7: "Colon"
              8: "Esophagus"
              9: "Gallbladder"
              10: "Kidney"
              11: "Larynx-trachea"
              12: "Leukemia"
              13: "Liver"
              14: "Lung"
              15: "Lymphoma"
              16: "Melanoma"
              17: "Mouth/tongue/lip"
              18: "Ovary"
              19: "Pancreas"
              20: "Prostate"
              21: "Rectum"
              22: "Skin (non-melanoma)"
              23: "Skin (unknown type)"
              24: "Soft tissue"
              25: "Stomach"
              26: "Testis"
              27: "Throat-pharynx"
              28: "Thyroid"
              29: "Uterus"
              30: "Other"

    # =========================================================================
    # MODULE 9: CANCER SURVIVORSHIP — COURSE OF TREATMENT (MCOT)
    # =========================================================================
    # Entry filter: same as Module 8 — respondent had skin or other cancer.
    #
    # MCOT.01: Treatment status. Option 3 (refused treatment) → skip to next
    #   module. All others → MCOT.02.
    # MCOT.02: Primary doctor type. Dropdown 10 options.
    # MCOT.03: Written treatment summary received. Switch.
    # MCOT.04: Instructions for follow-up check-ups. Switch.
    #   Yes (1) → MCOT.05; No/DK/R → MCOT.06.
    # MCOT.05: Instructions were written. Switch.
    #   Precondition: MCOT.04 == 1.
    # MCOT.06: Health insurance covered treatment. Switch.
    # MCOT.07: Denied insurance due to cancer. Switch.
    # MCOT.08: Participated in clinical trial. Switch.
    # =========================================================================
    - id: b_cancer_treatment
      title: "Module 9: Cancer Survivorship — Course of Treatment"
      precondition:
        - predicate: has_skin_cancer == 1 or has_other_cancer == 1
      items:
        # MCOT.01: Current treatment status
        # Option 3 (refused treatment) ends the module; all others continue.
        - id: q_mcot_01
          kind: Question
          title: "Are you currently receiving treatment for cancer?"
          input:
            control: Dropdown
            labels:
              1: "Yes, currently receiving treatment"
              2: "No, completed treatment"
              3: "No, refused treatment"
              4: "No, haven't started treatment"
              5: "Treatment not necessary"

        # MCOT.02–08: Only asked if treatment was not refused (MCOT.01 != 3)
        # MCOT.02: Primary doctor type
        - id: q_mcot_02
          kind: Question
          title: "What type of doctor provides the majority of your health care?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Dropdown
            labels:
              1: "Cancer Surgeon"
              2: "Family Practitioner"
              3: "General Surgeon"
              4: "Gynecologic Oncologist"
              5: "Internist"
              6: "Plastic/Reconstructive Surgeon"
              7: "Medical Oncologist"
              8: "Radiation Oncologist"
              9: "Urologist"
              10: "Other"

        # MCOT.03: Written treatment summary received
        - id: q_mcot_03
          kind: Question
          title: "Did any doctor, nurse, or other health professional ever give you a written summary of all the cancer treatments that you received?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.04: Instructions for routine follow-up check-ups
        - id: q_mcot_04
          kind: Question
          title: "Have you ever received instructions about where you should return or who you should see for routine cancer check-ups after completing treatment?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.05: Instructions were written/printed
        # Precondition: MCOT.04 = Yes (1)
        - id: q_mcot_05
          kind: Question
          title: "Were these instructions written down or printed on paper for you?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
            - predicate: q_mcot_04.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.06: Health insurance covered cancer treatment
        - id: q_mcot_06
          kind: Question
          title: "With your most recent diagnosis of cancer, did you have health insurance that paid for all or part of your cancer treatment?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.07: Denied insurance due to cancer
        - id: q_mcot_07
          kind: Question
          title: "Were you ever denied health insurance or life insurance coverage because of your cancer?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.08: Participated in a clinical trial
        - id: q_mcot_08
          kind: Question
          title: "Did you participate in a clinical trial as part of your cancer treatment?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # MODULE 10: CANCER SURVIVORSHIP — PAIN MANAGEMENT (MCPM)
    # =========================================================================
    # Entry filter: same as Modules 8 & 9 — respondent had skin or other cancer.
    #
    # MCPM.01: Currently experiencing cancer-related pain. Switch.
    #   Yes (1) → MCPM.02; No/DK/R → end of module.
    # MCPM.02: Pain control status. Radio (4 options).
    #   Precondition: MCPM.01 == 1.
    # =========================================================================
    - id: b_cancer_pain
      title: "Module 10: Cancer Survivorship — Pain Management"
      precondition:
        - predicate: has_skin_cancer == 1 or has_other_cancer == 1
      items:
        # MCPM.01: Currently has cancer-related pain
        - id: q_mcpm_01
          kind: Question
          title: "Do you currently have physical pain caused by your cancer or cancer treatment?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCPM.02: Pain control status
        # Precondition: MCPM.01 = Yes (1)
        - id: q_mcpm_02
          kind: Question
          title: "Would you say your pain is currently under control?"
          precondition:
            - predicate: q_mcpm_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "With medication"
              2: "Without medication"
              3: "Not under control, with medication"
              4: "Not under control, without medication"

    # ===================================================================
    # SECTION: sun_cognitive
    # ===================================================================
    # =========================================================================
    # MODULE 11: INDOOR TANNING (MNTAN)
    # =========================================================================
    # Single item, no entry filter, no skip logic.
    # MNTAN.01: Number of indoor tanning sessions in past 12 months (0–365).
    # =========================================================================
    - id: b_indoor_tanning
      title: "Module 11: Indoor Tanning"
      items:
        # MNTAN.01: Indoor tanning device use in past 12 months
        - id: q_mntan_01
          kind: Question
          title: "Not including spray-on tans, during the past 12 months, how many times have you used an indoor tanning device such as a sunlamp, tanning bed, or booth?"
          input:
            control: Editbox
            min: 0
            max: 365
            right: "times (0–365)"

    # =========================================================================
    # MODULE 12: EXCESS SUN EXPOSURE (MSUN)
    # =========================================================================
    # No entry filter. All four items are asked sequentially.
    #
    # MSUN.01: Number of sunburns in past 12 months (0–365).
    # MSUN.02: Frequency of sun protection. Dropdown (7 options — includes
    #   "Don't stay outside 1+ hour" and "Don't go outside at all").
    # MSUN.03: Weekday outdoor time in summer (10am–4pm). Dropdown (7 ranges).
    # MSUN.04: Weekend outdoor time in summer (10am–4pm). Dropdown (7 ranges).
    # =========================================================================
    - id: b_sun_exposure
      title: "Module 12: Excess Sun Exposure"
      items:
        # MSUN.01: Number of sunburns in past 12 months
        - id: q_msun_01
          kind: Question
          title: "During the past 12 months, how many times have you had a sunburn?"
          input:
            control: Editbox
            min: 0
            max: 365
            right: "times (0–365)"

        # MSUN.02: Frequency of sun protection on warm sunny days
        - id: q_msun_02
          kind: Question
          title: "When you go outside on a warm sunny day for more than one hour, how often do you protect yourself from the sun?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Most of the time"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"
              6: "Don't stay outside 1 hour or longer"
              8: "Don't go outside at all on warm sunny days"

        # MSUN.03: Weekday outdoor time (summer, 10am–4pm)
        - id: q_msun_03
          kind: Question
          title: "On weekdays, in the summer, how long are you outside per day between 10am and 4pm?"
          input:
            control: Dropdown
            labels:
              1: "Less than 30 minutes"
              2: "30 minutes to less than 1 hour"
              3: "1 to less than 2 hours"
              4: "2 to less than 3 hours"
              5: "3 to less than 4 hours"
              6: "4 to less than 5 hours"
              7: "5 to less than 6 hours"

        # MSUN.04: Weekend outdoor time (summer, 10am–4pm)
        - id: q_msun_04
          kind: Question
          title: "On weekends in the summer, how long are you outside each day between 10am and 4pm?"
          input:
            control: Dropdown
            labels:
              1: "Less than 30 minutes"
              2: "30 minutes to less than 1 hour"
              3: "1 to less than 2 hours"
              4: "2 to less than 3 hours"
              5: "3 to less than 4 hours"
              6: "4 to less than 5 hours"
              7: "5 to less than 6 hours"

    # =========================================================================
    # MODULE 13: COGNITIVE DECLINE (MCOG)
    # =========================================================================
    # Entry filter: age >= 45 (source filter excludes respondents 18–44).
    # Block precondition enforces this.
    #
    # MCOG.01: Experienced worsening thinking/memory difficulties. Switch.
    #   Yes (1) → MCOG.02–05; No/DK/R → skip to next module.
    # MCOG.02–05: Precondition: MCOG.01 == 1. All Switch items.
    # =========================================================================
    - id: b_cognitive_decline
      title: "Module 13: Cognitive Decline"
      precondition:
        - predicate: age >= 45
      items:
        # MCOG.01: Worsening thinking or memory difficulties in past 12 months
        - id: q_mcog_01
          kind: Question
          title: "During the past 12 months, have you experienced difficulties with thinking or memory that are happening more often or are getting worse?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOG.02: Worried about these difficulties
        # Precondition: MCOG.01 = Yes (1)
        - id: q_mcog_02
          kind: Question
          title: "Are you worried about these difficulties with thinking or memory?"
          precondition:
            - predicate: q_mcog_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOG.03: Discussed with health care provider
        # Precondition: MCOG.01 = Yes (1)
        - id: q_mcog_03
          kind: Question
          title: "Have you or anyone else discussed your difficulties with thinking or memory with a health care provider?"
          precondition:
            - predicate: q_mcog_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOG.04: Interfered with day-to-day activities
        # Precondition: MCOG.01 = Yes (1)
        - id: q_mcog_04
          kind: Question
          title: "During the past 12 months, have your difficulties with thinking or memory interfered with day-to-day activities?"
          precondition:
            - predicate: q_mcog_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOG.05: Interfered with ability to work or volunteer
        # Precondition: MCOG.01 = Yes (1)
        - id: q_mcog_05
          kind: Question
          title: "During the past 12 months, have your difficulties with thinking or memory interfered with your ability to work or volunteer?"
          precondition:
            - predicate: q_mcog_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: caregiver
    # ===================================================================
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

    # ===================================================================
    # SECTION: tobacco_cessation
    # ===================================================================
    # =========================================================================
    # MODULE 15: TOBACCO CESSATION (MTC)
    # =========================================================================
    # Source variables:
    #   smoked_100    ← CTOB.01: smoked at least 100 cigarettes in lifetime
    #                   1=Yes, 0=No
    #   smoking_status ← CTOB.02: current smoking status
    #                   1=every day, 2=some days, 3=not at all (former)
    #
    # MTC.01 precondition: smoked_100==1 AND smoking_status==3 (former smoker)
    # MTC.02 precondition: smoking_status in [1, 2] (current smoker)
    #
    # MTC.01: Time since last cigarette. Dropdown (8 time ranges).
    # MTC.02: Quit attempt in past 12 months. Switch.
    # =========================================================================
    - id: b_tobacco_cessation
      title: "Module 15: Tobacco Cessation"
      items:
        # MTC.01: Time since last cigarette (former smokers only)
        # Precondition: smoked 100+ cigarettes AND now a former smoker
        - id: q_mtc_01
          kind: Question
          title: "How long has it been since you last smoked a cigarette, even one or two puffs?"
          precondition:
            - predicate: smoked_100 == 1 and smoking_status == 3
          input:
            control: Dropdown
            labels:
              1: "Within the past month"
              2: "Within the past 3 months"
              3: "Within the past 6 months"
              4: "Within the past year"
              5: "Within the past 5 years"
              6: "Within the past 10 years"
              7: "10 or more years ago"
              8: "Never smoked regularly"

        # MTC.02: Quit attempt in past 12 months (current smokers only)
        # Precondition: currently smoking every day or some days
        - id: q_mtc_02
          kind: Question
          title: "During the past 12 months, have you stopped smoking for one day or longer because you were trying to quit smoking?"
          precondition:
            - predicate: smoking_status == 1 or smoking_status == 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # MODULE 16: OTHER TOBACCO USE (MOTU)
    # =========================================================================
    # Source variables:
    #   smoking_status ← CTOB.02: 1=every day, 2=some days, 3=not at all
    #   ecig_status    ← CTOB.04: 1=every day, 2=some days, 3=not at all,
    #                              4=never used
    #
    # MOTU.01 precondition: smoking_status in [1, 2] (current cigarette smoker)
    # MOTU.02 precondition: ecig_status in [2, 3] (current e-cigarette user —
    #   some days or not at all but formerly; source filter: CTOB.04=2 or 3)
    # MOTU.03: No precondition (asked of all respondents).
    # =========================================================================
    - id: b_other_tobacco
      title: "Module 16: Other Tobacco Use"
      items:
        # MOTU.01: Currently smokes menthol cigarettes (current smokers only)
        - id: q_motu_01
          kind: Question
          title: "Currently, when you smoke cigarettes, do you usually smoke menthol cigarettes?"
          precondition:
            - predicate: smoking_status == 1 or smoking_status == 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MOTU.02: Currently uses menthol e-cigarettes (current e-cig users only)
        # Precondition: ecig_status in [2, 3] per source filter MOTU.FILTER2
        # (CTOB.04=2: some days; CTOB.04=3: not at all [former daily user])
        - id: q_motu_02
          kind: Question
          title: "Currently, when you use e-cigarettes, do you usually use menthol e-cigarettes?"
          precondition:
            - predicate: ecig_status == 2 or ecig_status == 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MOTU.03: Heard of heated tobacco products (asked of all respondents)
        - id: q_motu_03
          kind: Question
          title: "Before today, have you heard of heated tobacco products?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: firearm_industry_heart
    # ===================================================================
    # =========================================================================
    # MODULE 17: FIREARM SAFETY (MFS)
    # =========================================================================
    # MFS.01: Always asked.
    #   1 (Yes) → ask MFS.02
    #   2 (No), 7 (DK), 9 (R) → skip to Module 18
    #
    # MFS.02: Precondition: MFS.01 == 1 (firearms in home)
    #   1 (Yes) → ask MFS.03
    #   2 (No), 7 (DK), 9 (R) → skip to Module 18
    #
    # MFS.03: Precondition: MFS.02 == 1 (loaded firearms present)
    #   Always routes to next module after response.
    # =========================================================================
    - id: b_firearm
      title: "Module 17: Firearm Safety"
      items:
        # MFS.01: Firearms in or around home
        - id: q_mfs_01
          kind: Question
          title: "Are any firearms now kept in or around your home?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MFS.02: Are any of the firearms loaded
        # Precondition: MFS.01 = Yes (1)
        - id: q_mfs_02
          kind: Question
          title: "Are any of these firearms now loaded?"
          precondition:
            - predicate: q_mfs_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MFS.03: Are any loaded firearms also unlocked
        # Precondition: MFS.02 = Yes (1)
        - id: q_mfs_03
          kind: Question
          title: "Are any of these loaded firearms also unlocked?"
          precondition:
            - predicate: q_mfs_02.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # MODULE 18: INDUSTRY AND OCCUPATION (MIO)
    # =========================================================================
    # Module filter: Ask only if CDEM.13 = 1 (employed for wages), 2 (self-employed),
    # or 4 (out of work for less than 1 year).
    #
    # MIO.01 and MIO.02: Both asked when module filter is met; no internal routing.
    # =========================================================================
    - id: b_industry
      title: "Module 18: Industry and Occupation"
      precondition:
        - predicate: employment_status in [1, 2, 4]
      items:
        # MIO.01: Type of work / job title
        - id: q_mio_01
          kind: Question
          title: "What kind of work do you do?"
          input:
            control: Textarea
            placeholder: "Describe your type of work or job title"

        # MIO.02: Business or industry type
        - id: q_mio_02
          kind: Question
          title: "What kind of business or industry do you work in?"
          input:
            control: Textarea
            placeholder: "Describe the business or industry"

    # =========================================================================
    # MODULE 19: HEART ATTACK AND STROKE (MHAS)
    # =========================================================================
    # MHAS.01–06: Heart attack symptom knowledge — all Switch, no internal routing.
    # MHAS.07–12: Stroke symptom knowledge — all Switch, no internal routing.
    # MHAS.13: First action if witnessing heart attack or stroke — Dropdown.
    #
    # All 13 items are always asked (no skip logic within this module).
    # =========================================================================
    - id: b_heart_attack_stroke
      title: "Module 19: Heart Attack and Stroke"
      items:
        # MHAS.01: Jaw/neck/back pain as heart attack symptom
        - id: q_mhas_01
          kind: Question
          title: "Do you think pain or discomfort in the jaw, neck, or back are symptoms of a heart attack?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.02: Weakness/lightheadedness/faintness as heart attack symptom
        - id: q_mhas_02
          kind: Question
          title: "Do you think feeling weak, lightheaded, or faint are symptoms of a heart attack?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.03: Chest pain or discomfort as heart attack symptom
        - id: q_mhas_03
          kind: Question
          title: "Do you think chest pain or discomfort are symptoms of a heart attack?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.04: Sudden trouble seeing as heart attack symptom
        - id: q_mhas_04
          kind: Question
          title: "Do you think sudden trouble seeing in one or both eyes are symptoms of a heart attack?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.05: Arm/shoulder pain as heart attack symptom
        - id: q_mhas_05
          kind: Question
          title: "Do you think pain or discomfort in the arms or shoulder are symptoms of a heart attack?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.06: Shortness of breath as heart attack symptom
        - id: q_mhas_06
          kind: Question
          title: "Do you think shortness of breath is a symptom of a heart attack?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.07: Sudden confusion/trouble speaking as stroke symptom
        - id: q_mhas_07
          kind: Question
          title: "Do you think sudden confusion or trouble speaking are symptoms of a stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.08: Sudden numbness/weakness of face, arm, or leg as stroke symptom
        - id: q_mhas_08
          kind: Question
          title: "Do you think sudden numbness or weakness of face, arm, or leg, especially on one side, are symptoms of a stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.09: Sudden trouble seeing as stroke symptom
        - id: q_mhas_09
          kind: Question
          title: "Do you think sudden trouble seeing in one or both eyes is a symptom of a stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.10: Sudden chest pain as stroke symptom
        - id: q_mhas_10
          kind: Question
          title: "Do you think sudden chest pain or discomfort are symptoms of a stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.11: Sudden trouble walking/dizziness/loss of balance as stroke symptom
        - id: q_mhas_11
          kind: Question
          title: "Do you think sudden trouble walking, dizziness, or loss of balance is a symptom of a stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.12: Severe headache with no known cause as stroke symptom
        - id: q_mhas_12
          kind: Question
          title: "Do you think a severe headache with no known cause are symptoms of a stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MHAS.13: First action if witnessing heart attack or stroke
        - id: q_mhas_13
          kind: Question
          title: "If you thought someone was having a heart attack or a stroke, what is the first thing you would do?"
          input:
            control: Dropdown
            labels:
              1: "Take them to the hospital"
              2: "Tell them to call their doctor"
              3: "Call 911"
              4: "Call their spouse or family member"
              5: "Do something else"

    # =========================================================================
    # MODULE 20: ASPIRIN FOR CVD PREVENTION (MASPRN)
    # =========================================================================
    # MASPRN.01: Always asked (no module filter or internal routing).
    # =========================================================================
    - id: b_aspirin
      title: "Module 20: Aspirin for CVD Prevention"
      items:
        # MASPRN.01: Frequency of aspirin use for heart disease prevention
        - id: q_masprn_01
          kind: Question
          title: "How often do you take an aspirin to prevent or control heart disease, heart attacks or stroke?"
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Some days"
              3: "Used to take it but stopped due to side effects"
              4: "Do not take it"

    # ===================================================================
    # SECTION: sex_sogi_marijuana
    # ===================================================================
    # =========================================================================
    # MODULE 21: SEX AT BIRTH (MSAB)
    # =========================================================================
    # Module filter: If LL10 or CP06 already coded sex as 1 or 2, auto-code
    # MSAB.01 and skip the question. In QML this is modelled as:
    # ask only when sex_from_intro == 3 (not yet specified in intro).
    # =========================================================================
    - id: b_sex_at_birth
      title: "Module 21: Sex at Birth"
      items:
        # MSAB.01: Sex at birth — asked only when intro sex was unspecified
        - id: q_msab_01
          kind: Question
          title: "What was your sex at birth? Was it male or female?"
          precondition:
            - predicate: sex_from_intro == 3
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

    # =========================================================================
    # MODULE 22: SEXUAL ORIENTATION AND GENDER IDENTITY (SOGI)
    # =========================================================================
    # MSOGI.FILTER1 routes by sex:
    #   Male (sex_at_birth == 1) → ask MSOGI.01 (male version), skip MSOGI.02
    #   Female (sex_at_birth == 2) → skip MSOGI.01, ask MSOGI.02 (female version)
    # MSOGI.03: Always asked (transgender question), no routing condition.
    # =========================================================================
    - id: b_sogi
      title: "Module 22: Sexual Orientation and Gender Identity"
      items:
        # MSOGI.01: Sexual orientation — male version
        # Precondition: sex at birth is Male
        - id: q_msogi_01
          kind: Question
          title: "Which of the following best represents how you think of yourself?"
          precondition:
            - predicate: sex_at_birth == 1
          input:
            control: Radio
            labels:
              1: "Gay"
              2: "Straight, that is, not gay"
              3: "Bisexual"
              4: "Something else"

        # MSOGI.02: Sexual orientation — female version
        # Precondition: sex at birth is Female
        - id: q_msogi_02
          kind: Question
          title: "Which of the following best represents how you think of yourself?"
          precondition:
            - predicate: sex_at_birth == 2
          input:
            control: Radio
            labels:
              1: "Lesbian or Gay"
              2: "Straight, that is, not gay"
              3: "Bisexual"
              4: "Something else"

        # MSOGI.03: Transgender identity — always asked
        - id: q_msogi_03
          kind: Question
          title: "Do you consider yourself to be transgender?"
          input:
            control: Radio
            labels:
              1: "Yes, male-to-female"
              2: "Yes, female-to-male"
              3: "Yes, gender nonconforming"
              4: "No"

    # =========================================================================
    # MODULE 23: MARIJUANA USE (MMU)
    # =========================================================================
    # MMU.01: Days of use in past 30 days (0 = none → skip rest of module).
    #   0 → skip MMU.02–07
    #   1–30 → ask MMU.02 onward
    #   Note: original codes 88=None (skip) and 77=DK (ask); modelled as:
    #   0 skips follow-up questions; >0 proceeds to method questions.
    #
    # MMU.02–06: Use method questions (Switch). Each increments method_count
    #   via codeBlock when answered Yes.
    #
    # MMU.07: Most-used method — asked only when >1 method was used (method_count > 1).
    # =========================================================================
    - id: b_marijuana
      title: "Module 23: Marijuana Use"
      items:
        # MMU.01: Days used marijuana in past 30 days (0 = none)
        - id: q_mmu_01
          kind: Question
          title: "During the past 30 days, on how many days did you use marijuana or cannabis?"
          input:
            control: Editbox
            min: 0
            max: 30
            right: "days (0 = none)"

        # MMU.02: Method — smoked (joint, bong, pipe, blunt)
        # Precondition: used marijuana at least once
        - id: q_mmu_02
          kind: Question
          title: "During the past 30 days, did you smoke marijuana (for example, in a joint, bong, pipe, or blunt)?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_02.outcome == 1:
              method_count = method_count + 1

        # MMU.03: Method — eaten or drunk (brownies, candy, tea, etc.)
        # Precondition: used marijuana at least once
        - id: q_mmu_03
          kind: Question
          title: "During the past 30 days, did you eat or drink marijuana (for example, in brownies, cakes, cookies, or candy, or in tea, cola, or alcohol)?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_03.outcome == 1:
              method_count = method_count + 1

        # MMU.04: Method — vaporized (e-cigarette-like vaporizer)
        # Precondition: used marijuana at least once
        - id: q_mmu_04
          kind: Question
          title: "During the past 30 days, did you vaporize marijuana (for example, in an e-cigarette-like vaporizer or another vaporizing device)?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_04.outcome == 1:
              method_count = method_count + 1

        # MMU.05: Method — dabbed (dabbing rig, knife, dab pen)
        # Precondition: used marijuana at least once
        - id: q_mmu_05
          kind: Question
          title: "During the past 30 days, did you dab marijuana (for example, using a dabbing rig, knife, or dab pen)?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_05.outcome == 1:
              method_count = method_count + 1

        # MMU.06: Method — some other way
        # Precondition: used marijuana at least once
        - id: q_mmu_06
          kind: Question
          title: "During the past 30 days, did you use marijuana in some other way?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_06.outcome == 1:
              method_count = method_count + 1

        # MMU.07: Most-used method — asked only when more than one method used
        # Precondition: used marijuana at least once AND more than one method reported Yes
        - id: q_mmu_07
          kind: Question
          title: "During the past 30 days, which one of the following ways did you use marijuana the most often?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
            - predicate: method_count > 1
          input:
            control: Dropdown
            labels:
              1: "Smoke it"
              2: "Eat or drink it"
              3: "Vaporize it"
              4: "Dab it"
              5: "Use some other way"

    # ===================================================================
    # SECTION: adverse_childhood
    # ===================================================================
    # =========================================================================
    # MODULE 24: ADVERSE CHILDHOOD EXPERIENCES (MACE)
    # =========================================================================
    # All 13 items are always asked when this module is selected.
    # No internal skip routing exists within the module.
    #
    # MACE.01–04: Household dysfunction (Switch Yes/No)
    # MACE.05:    Parental separation (Radio — 3 options including "not married")
    # MACE.06–11: Exposure to violence and abuse (Radio — Never/Once/More than once)
    # MACE.12–13: Protective adult presence (Dropdown — 5-point frequency scale)
    # =========================================================================
    - id: b_adverse_childhood
      title: "Module 24: Adverse Childhood Experiences"
      items:
        # MACE.01: Lived with someone who was depressed, mentally ill, or suicidal
        - id: q_mace_01
          kind: Question
          title: "When you were growing up, did you live with anyone who was depressed, mentally ill, or suicidal?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MACE.02: Lived with a problem drinker or alcoholic
        - id: q_mace_02
          kind: Question
          title: "When you were growing up, did you live with anyone who was a problem drinker or alcoholic?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MACE.03: Lived with someone who used illegal street drugs or abused prescription medications
        - id: q_mace_03
          kind: Question
          title: "When you were growing up, did you live with anyone who used illegal street drugs or who abused prescription medications?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MACE.04: Lived with someone who served time in prison, jail, or correctional facility
        - id: q_mace_04
          kind: Question
          title: "When you were growing up, did you live with anyone who served time or was sentenced to serve time in a prison, jail, or other correctional facility?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MACE.05: Parents separated or divorced (3 options — includes "not married")
        - id: q_mace_05
          kind: Question
          title: "When you were growing up, were your parents separated or divorced?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Parents not married"

        # MACE.06: Witnessed domestic violence between parents/adults in home
        - id: q_mace_06
          kind: Question
          title: "How often did your parents or adults in your home ever slap, hit, kick, punch, or beat each other up?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.07: Physically hurt by parent or adult in home (not spanking)
        - id: q_mace_07
          kind: Question
          title: "Not including spanking, how often did a parent or adult in your home ever hit, beat, kick, or physically hurt you in any way?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.08: Verbally abused by parent or adult in home
        - id: q_mace_08
          kind: Question
          title: "How often did a parent or adult in your home ever swear at you, insult you, or put you down?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.09: Touched sexually by someone 5+ years older or an adult
        - id: q_mace_09
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, ever touch you sexually?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.10: Made to touch someone sexually by someone 5+ years older or an adult
        - id: q_mace_10
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, try to make you touch them sexually?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.11: Forced to have sex by someone 5+ years older or an adult
        - id: q_mace_11
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, force you to have sex?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.12: Protective adult who made respondent feel safe (5-point scale)
        - id: q_mace_12
          kind: Question
          title: "For how much of your childhood was there an adult in your household who made you feel safe and protected?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "A little of the time"
              3: "Some of the time"
              4: "Most of the time"
              5: "All of the time"

        # MACE.13: Adult who tried hard to meet respondent's basic needs (5-point scale)
        - id: q_mace_13
          kind: Question
          title: "For how much of your childhood was there an adult in your household who tried hard to make sure your basic needs were met?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "A little of the time"
              3: "Some of the time"
              4: "Most of the time"
              5: "All of the time"

    # ===================================================================
    # SECTION: vaccination_modules
    # ===================================================================
    # =========================================================================
    # MODULE 25: PLACE OF FLU VACCINATION (MFP)
    # =========================================================================
    # Module filter: Ask only if CIMM.01=1 (respondent had flu vaccine in past
    # 12 months).
    # MFP.01: Where respondent received most recent flu shot/vaccine.
    # =========================================================================
    - id: b_flu_place
      title: "Module 25: Place of Flu Vaccination"
      precondition:
        - predicate: had_flu_vaccine == 1
      items:
        # MFP.01: Place where most recent flu vaccine was received
        - id: q_mfp_01
          kind: Question
          title: "At what kind of place did you get your last flu shot or vaccine?"
          input:
            control: Dropdown
            labels:
              1: "Doctor's office or HMO"
              2: "Health department"
              3: "Clinic or health center"
              4: "Senior, recreation, or community center"
              5: "Store (supermarket or drug store)"
              6: "Hospital"
              7: "Emergency room"
              8: "Workplace"
              9: "Some other kind of place"
              10: "Received in Canada or Mexico"
              11: "School"

    # =========================================================================
    # MODULE 26: HPV VACCINATION (MHPV)
    # =========================================================================
    # Module filter: Ask only if age is 18–49 years.
    # MHPV.01: Ever had an HPV vaccination.
    #   1 (Yes) → ask MHPV.02 (number of HPV shots)
    #   2 (No) or 3 (Doctor refused) → skip MHPV.02, go to next module
    #
    # MHPV.02: How many HPV shots received. Precondition: MHPV.01 == 1.
    #   Editbox min 1 max 3 (source captures 1, 2, or 3/all shots).
    # =========================================================================
    - id: b_hpv
      title: "Module 26: HPV Vaccination"
      precondition:
        - predicate: age >= 18 and age <= 49
      items:
        # MHPV.01: Ever had an HPV vaccination
        - id: q_mhpv_01
          kind: Question
          title: "Have you ever had an H.P.V. vaccination?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doctor refused when asked"

        # MHPV.02: Number of HPV shots received
        # Precondition: MHPV.01 = Yes (1)
        - id: q_mhpv_02
          kind: Question
          title: "How many HPV shots did you receive?"
          precondition:
            - predicate: q_mhpv_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 3
            right: "doses (1, 2, or 3 for all shots)"

    # =========================================================================
    # MODULE 27: TETANUS DIPHTHERIA / TDAP (MTDAP)
    # =========================================================================
    # MTDAP.01: Tetanus shot in past 10 years, with type differentiation.
    #   All responses → go to next module (no branching).
    # =========================================================================
    - id: b_tdap
      title: "Module 27: Tetanus Diphtheria / Tdap Vaccination"
      items:
        # MTDAP.01: Tetanus shot in past 10 years
        - id: q_mtdap_01
          kind: Question
          title: "Have you received a tetanus shot in the past 10 years?"
          input:
            control: Radio
            labels:
              1: "Yes, received Tdap (combined tetanus and whooping cough vaccine)"
              2: "Yes, tetanus shot but not Tdap"
              3: "Yes, tetanus shot but not sure what type"
              4: "No, did not receive any tetanus shot"

    # =========================================================================
    # MODULE 28: COVID VACCINATION (MCOV)
    # =========================================================================
    # MCOV.01: Received at least one dose of COVID-19 vaccine.
    #   1 (Yes) → ask MCOV.03 (number of doses); skip MCOV.02
    #   2 (No)  → ask MCOV.02 (intent to vaccinate); skip MCOV.03
    #
    # MCOV.02: Intent to get COVID vaccine. Precondition: MCOV.01 == 0 (No).
    #   All responses → go to next module.
    #
    # MCOV.03: Number of COVID vaccinations received. Precondition: MCOV.01 == 1 (Yes).
    #   All responses → go to next module.
    # =========================================================================
    - id: b_covid_vaccination
      title: "Module 28: COVID Vaccination"
      items:
        # MCOV.01: Received at least one dose of COVID-19 vaccine
        - id: q_mcov_01
          kind: Question
          title: "Have you received at least one dose of a COVID-19 vaccination?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOV.02: Intent to receive COVID vaccination
        # Precondition: MCOV.01 = No (0)
        - id: q_mcov_02
          kind: Question
          title: "Would you say you will definitely get a vaccine, will probably get a vaccine, will probably not get a vaccine, or will definitely not get a vaccine?"
          precondition:
            - predicate: q_mcov_01.outcome == 0
          input:
            control: Radio
            labels:
              1: "Will definitely get"
              2: "Will probably get"
              3: "Will probably not get"
              4: "Will definitely not get"

        # MCOV.03: Number of COVID vaccinations received
        # Precondition: MCOV.01 = Yes (1)
        - id: q_mcov_03
          kind: Question
          title: "How many COVID-19 vaccinations have you received?"
          precondition:
            - predicate: q_mcov_01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "One"
              2: "Two"
              3: "Three"
              4: "Four"
              5: "Five or more"

    # ===================================================================
    # SECTION: social_determinants_race
    # ===================================================================
    # =========================================================================
    # MODULE 29: SOCIAL DETERMINANTS AND HEALTH EQUITY (MSDHE)
    # =========================================================================
    # All 10 items are sequential with no branching; all respondents are asked
    # every item regardless of prior responses.
    # =========================================================================
    - id: b_social_determinants
      title: "Module 29: Social Determinants and Health Equity"
      items:
        # MSDHE.01: Overall life satisfaction
        - id: q_msdhe_01
          kind: Question
          title: "In general, how satisfied are you with your life?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Satisfied"
              3: "Dissatisfied"
              4: "Very dissatisfied"

        # MSDHE.02: Frequency of receiving needed social and emotional support
        - id: q_msdhe_02
          kind: Question
          title: "How often do you get the social and emotional support that you need?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # MSDHE.03: Frequency of feeling lonely
        - id: q_msdhe_03
          kind: Question
          title: "How often do you feel lonely?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # MSDHE.04: Lost employment or had hours reduced in past 12 months
        - id: q_msdhe_04
          kind: Question
          title: "In the past 12 months have you lost employment or had hours reduced?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.05: Received SNAP (food stamps) in past 12 months
        - id: q_msdhe_05
          kind: Question
          title: "During the past 12 months, have you received food stamps, also called SNAP?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.06: Frequency of food running out before able to get more
        - id: q_msdhe_06
          kind: Question
          title: "During the past 12 months how often did the food that you bought not last, and you didn't have money to get more?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # MSDHE.07: Unable to pay mortgage, rent, or utility bills in past 12 months
        - id: q_msdhe_07
          kind: Question
          title: "During the last 12 months, was there a time when you were not able to pay your mortgage, rent or utility bills?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.08: Utility shutoff threatened in past 12 months
        - id: q_msdhe_08
          kind: Question
          title: "During the last 12 months was there a time when an electric, gas, oil, or water company threatened to shut off services?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.09: Lack of reliable transportation affected daily activities in past 12 months
        - id: q_msdhe_09
          kind: Question
          title: "During the past 12 months has a lack of reliable transportation kept you from medical appointments, meetings, work, or from getting things needed for daily living?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.10: Frequency of stress in past 30 days
        - id: q_msdhe_10
          kind: Question
          title: "Within the last 30 days, how often have you felt stress?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

    # =========================================================================
    # MODULE 30: REACTIONS TO RACE (MRTR)
    # =========================================================================
    # MRTR.01–MRTR.03: Asked of all respondents.
    # MRTR.04: Asked only if employed or out of work < 1 year (CDEM.13=1,2,4).
    # MRTR.05–MRTR.06: Asked of all respondents.
    # =========================================================================
    - id: b_reactions_race
      title: "Module 30: Reactions to Race"
      items:
        # MRTR.01: How other people usually classify respondent by race
        - id: q_mrtr_01
          kind: Question
          title: "How do other people usually classify you in this country?"
          input:
            control: Dropdown
            labels:
              1: "White"
              2: "Black or African American"
              3: "Hispanic or Latino"
              4: "Asian"
              5: "Native Hawaiian or Other Pacific Islander"
              6: "American Indian or Alaska Native"
              7: "Mixed Race"
              8: "Some other group"

        # MRTR.02: How often respondent thinks about their race
        - id: q_mrtr_02
          kind: Question
          title: "How often do you think about your race?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "Once a year"
              3: "Once a month"
              4: "Once a week"
              5: "Once a day"
              6: "Once an hour"
              8: "Constantly"

        # MRTR.03: Racial treatment in general in past 12 months
        - id: q_mrtr_03
          kind: Question
          title: "Within the past 12 months, do you feel that in general you were treated worse than, the same as, or better than people of other races?"
          input:
            control: Dropdown
            labels:
              1: "Worse"
              2: "The same"
              3: "Better"
              4: "Worse than some, better than others"
              5: "Only encountered people of same race"

        # MRTR.04: Racial treatment at work in past 12 months
        # Precondition: CDEM.13 = 1 (employed for wages), 2 (self-employed),
        #               or 4 (out of work less than 1 year)
        - id: q_mrtr_04
          kind: Question
          title: "Within the past 12 months at work, do you feel you were treated worse than, the same as, or better than people of other races?"
          precondition:
            - predicate: employment_status in [1, 2, 4]
          input:
            control: Dropdown
            labels:
              1: "Worse"
              2: "The same"
              3: "Better"
              4: "Worse than some, better than others"
              5: "Only encountered people of same race"

        # MRTR.05: Racial treatment when seeking health care in past 12 months
        - id: q_mrtr_05
          kind: Question
          title: "Within the past 12 months, when seeking health care, do you feel your experiences were worse than, the same as, or better than for people of other races?"
          input:
            control: Dropdown
            labels:
              1: "Worse"
              2: "The same"
              3: "Better"
              4: "Worse than some, better than others"
              5: "Only encountered people of same race"

        # MRTR.06: Physical symptoms from race-based treatment in past 30 days
        - id: q_mrtr_06
          kind: Question
          title: "Within the past 30 days, have you experienced any physical symptoms as a result of how you were treated based on your race?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: child_asthma
    # ===================================================================
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
