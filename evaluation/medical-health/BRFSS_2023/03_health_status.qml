qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Core Sections 1-3: Health Status, Healthy Days, Health Care Access"
  codeInit: |
    # No extern variables required for this section

  blocks:
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
