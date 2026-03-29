qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 1: Prediabetes and Module 2: Diabetes"

  codeInit: |
    # Extern variable from Core Section 7 (CCHC.12)
    # 1=Yes (has diabetes), 2=Yes during pregnancy, 3=No, 4=Prediabetes/borderline
    diabetes_status: {1, 2, 3, 4}

  blocks:
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
