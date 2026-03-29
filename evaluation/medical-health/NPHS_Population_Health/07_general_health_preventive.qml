qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - General Health and Preventive Health Practices"
  codeInit: |
    # Extern variables from household section
    age: range(0, 120)
    sex: {1, 2}

    # Variable produced by this section
    is_pregnant = 0

  blocks:
    # =========================================================================
    # BLOCK 1: ADMINISTRATION (H05-P1, H05-P2, H06-P1)
    # =========================================================================
    - id: b_administration
      title: "Administration"
      items:
        # H05-P1 / AM54_TEL: Interview mode
        - id: q_h05_p1
          kind: Question
          title: "Was this interview conducted on the telephone or in person?"
          input:
            control: Radio
            labels:
              1: "On telephone"
              2: "In person"
              3: "Both (Specify in comments)"

        # H05-P2 / AM54_LNG: Language of interview
        - id: q_h05_p2
          kind: Question
          title: "Record language of interview."
          input:
            control: Dropdown
            labels:
              1: "English"
              2: "French"
              3: "Arabic"
              4: "Chinese"
              5: "Cree"
              6: "German"
              7: "Greek"
              8: "Hungarian"
              9: "Italian"
              10: "Korean"
              11: "Persian (Farsi)"
              12: "Polish"
              13: "Portuguese"
              14: "Punjabi"
              15: "Spanish"
              16: "Tagalog (Filipino)"
              17: "Ukrainian"
              18: "Vietnamese"
              19: "Other (Specify)"

        # H06-P1 / AM64_SRC: Information source
        # Form H06 is for selected respondent aged 12+; proxy permitted for
        # those unable to answer themselves.
        - id: q_h06_p1
          kind: Question
          title: "Who is providing the information for this person's form?"
          input:
            control: Textarea
            placeholder: "Record name/relationship of person providing information..."

    # =========================================================================
    # BLOCK 2: GENERAL HEALTH (GENHLT-Q1 to GENHLT-Q3)
    # =========================================================================
    - id: b_general_health
      title: "General Health"
      items:
        # GENHLT-Q1 / GHC4_1: Self-rated health
        - id: q_genhlt_q1
          kind: Question
          title: "In general, would you say your health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # GENHLT-C2: Check/Filter
        # If sex = female AND age >= 15 AND age <= 49 → ask GENHLT-Q2
        # Otherwise → go to Height/Weight section
        # Modeled as precondition on GENHLT-Q2.

        # GENHLT-Q2 / HWC4_1: Pregnancy question
        # Precondition: female (sex==2) AND age 15-49
        # 1=Yes → ask GENHLT-Q3; 2=No or DK/R → skip to Height/Weight
        - id: q_genhlt_q2
          kind: Question
          title: "It is important to know when analyzing health whether or not the person is pregnant. Are you pregnant?"
          precondition:
            - predicate: sex == 2 and age >= 15 and age <= 49
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refused"
          codeBlock: |
            is_pregnant = 1 if q_genhlt_q2.outcome == 1 else 0

        # GENHLT-Q3 / GHC4_3: Physician/midwife planning
        # Precondition: pregnant (Q2 == 1)
        - id: q_genhlt_q3
          kind: Question
          title: "Are you planning to use the services of a physician, midwife or both?"
          precondition:
            - predicate: q_genhlt_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Physician only"
              2: "Midwife only"
              3: "Both physician and midwife"
              4: "Neither"

    # =========================================================================
    # BLOCK 3: HEIGHT / WEIGHT (HTWT-Q1, HTWT-Q2)
    # =========================================================================
    - id: b_height_weight
      title: "Height and Weight"
      items:
        # HTWT-Q1 / HWC4_2HT: Height
        # Note: Original records in feet+inches OR centimetres; modeled as
        # centimetres (single numeric entry) for QML simplicity.
        - id: q_htwt_q1
          kind: Question
          title: "How tall are you without shoes on? (Enter height in centimetres)"
          input:
            control: Editbox
            min: 0
            max: 300
            right: "cm"

        # HTWT-Q2 / HWC4_3LB / HWC4_3KG: Weight
        # Note: Original records in pounds OR kilograms.
        - id: q_htwt_q2
          kind: Question
          title: "How much do you weigh? (Enter weight in pounds or kilograms — note unit used)"
          input:
            control: Editbox
            min: 0
            max: 500
            right: "lbs/kg"

    # =========================================================================
    # BLOCK 4: PREVENTIVE HEALTH PRACTICES (PHP-Q1 to PHP-Q3a)
    # =========================================================================
    # Non-proxy only section.
    # PHP-C2 routing:
    #   Female age >= 35       → ask PHP-Q2 (mammogram), then PHP-Q3 (PAP)
    #   Female age 18-34       → skip PHP-Q2, ask PHP-Q3 (PAP)
    #   Male OR female age <=17 → skip entire section (go to Smoking)
    # Modeled via individual item preconditions.
    # =========================================================================
    - id: b_preventive_health
      title: "Preventive Health Practices"
      items:
        # PHP-Q1 / BPC4_1: Blood pressure check timing
        # R (refused, code 9) → skip rest of Preventive Health section
        - id: q_php_q1
          kind: Question
          title: "When did you last have your blood pressure checked by a health professional?"
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than a year ago"
              3: "1 year to less than 2 years ago"
              4: "2 years to less than 5 years ago"
              5: "5 years or more ago"
              6: "Never"
              9: "Refused"

        # PHP-Q2 / WHC4_30: Mammogram ever
        # Precondition: female (sex==2) AND age >= 35
        # PHP-C2: female age >= 35 → ask Q2
        # 1=Yes → ask PHP-Q2a and PHP-Q2b; 2=No or DK → ask PHP-Q3; R → skip section
        - id: q_php_q2
          kind: Question
          title: "Have you ever had a mammogram, that is, a breast X-ray?"
          precondition:
            - predicate: q_php_q1.outcome != 9
            - predicate: sex == 2 and age >= 35
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refused"

        # PHP-Q2a / WHC4_32: When last mammogram
        # Precondition: Q2 == Yes
        - id: q_php_q2a
          kind: Question
          title: "When was the last time you had a mammogram?"
          precondition:
            - predicate: q_php_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than one year ago"
              3: "1 year to less than 2 years ago"
              4: "2 years or more ago"

        # PHP-Q2b / WHC4_33: Why last mammogram
        # Precondition: Q2 == Yes
        - id: q_php_q2b
          kind: Question
          title: "Why did you have your last mammogram?"
          precondition:
            - predicate: q_php_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Breast problem"
              2: "Check-up, no particular problem"
              3: "Other (specify)"

        # PHP-Q3 / WHC4_20: PAP smear ever
        # Precondition: female (sex==2) AND age >= 18
        # PHP-C2: female age >= 35 also gets Q3 (after Q2); female age 18-34 gets Q3 directly
        # No/DK/R → skip PHP-Q3a
        - id: q_php_q3
          kind: Question
          title: "Have you ever had a PAP smear test?"
          precondition:
            - predicate: q_php_q1.outcome != 9
            - predicate: sex == 2 and age >= 18
            - predicate: q_php_q2.outcome != 9 or age < 35
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refused"

        # PHP-Q3a / WHC4_22: When last PAP smear
        # Precondition: Q3 == Yes
        - id: q_php_q3a
          kind: Question
          title: "When was the last time you had a PAP smear test?"
          precondition:
            - predicate: q_php_q3.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than one year ago"
              3: "1 year to less than 3 years ago"
              4: "3 years to less than 5 years ago"
              5: "5 years or more ago"
