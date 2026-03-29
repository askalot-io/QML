qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 17: Firearm Safety / Module 18: Industry and Occupation / Module 19: Heart Attack and Stroke / Module 20: Aspirin for CVD Prevention"

  codeInit: |
    # Extern variable from Core Section 8 (CDEM.13)
    # Employment status: 1=Employed for wages, 2=Self-employed, 3=Out of work >=1yr,
    # 4=Out of work <1yr, 5=Homemaker, 6=Student, 7=Retired, 8=Unable to work
    employment_status: {1, 2, 3, 4, 5, 6, 7, 8}

  blocks:
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
