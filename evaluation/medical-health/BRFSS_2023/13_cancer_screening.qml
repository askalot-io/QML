qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Modules 4-7: Cancer Screening"

  codeInit: |
    # Extern variables from Core Sections
    # sex_at_birth: 1=Male, 2=Female (from CDEM or MSAB module)
    sex_at_birth: {1, 2}
    # age in years (from CDEM.01)
    age: range(18, 99)
    # smoked_100: 1=Yes smoked 100+ cigarettes, 0=No (from CTOB.01)
    smoked_100: {0, 1}
    # smoking_status: 1=Every day, 2=Some days, 3=Not at all (from CTOB.02)
    smoking_status: {1, 2, 3}
    # is_pregnant: 1=Yes currently pregnant, 0=No (from CDEM.16)
    is_pregnant: {0, 1}

  blocks:
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
