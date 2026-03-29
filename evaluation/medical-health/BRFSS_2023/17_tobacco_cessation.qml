qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 15: Tobacco Cessation / Module 16: Other Tobacco Use"

  codeInit: |
    smoked_100: {0, 1}
    smoking_status: {1, 2, 3}
    ecig_status: {1, 2, 3, 4}

  blocks:
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
