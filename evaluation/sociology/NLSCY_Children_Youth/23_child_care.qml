qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Child Care (CAR)"
  codeInit: |
    # Variables READ from prior sections
    child_age = 0       # child's age from demographics section (0-11)

  blocks:
    # =========================================================================
    # BLOCK 1: CHILD CARE USAGE (CAR-I1, CAR-Q1A)
    # =========================================================================
    # Determines whether the family currently uses child care.
    # Q1A=NO skips to the "ever used" block (Q6).
    # =========================================================================
    - id: b_car_usage
      title: "Child Care Usage"
      items:
        # CAR-I1: Introduction
        - id: q_car_intro
          kind: Comment
          title: "Now I'd like to ask you some questions regarding your child care arrangements for this child."

        # CAR-Q1A: Currently use child care
        - id: q_car_q1a
          kind: Question
          title: "Do you currently use child care such as daycare or babysitting while you (and your spouse/partner) are at work or studying?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: CARE TYPES (CAR-Q1B through CAR-Q1J)
    # =========================================================================
    # Each care type: Y/N switch, then conditional hours and licensing.
    # Block-level precondition: only shown when currently using care.
    # CAR-C1H: Before/after school (Q1H) requires age >= 4.
    # CAR-C1I: Self-care (Q1I) requires age >= 6.
    # =========================================================================
    - id: b_car_types
      title: "Types of Child Care"
      precondition:
        - predicate: q_car_q1a.outcome == 1
      items:
        # --- Q1B: Non-relative in their home ---
        - id: q_car_q1b
          kind: Question
          title: "Which of the following methods of child care do you currently use? Care provided in someone else's home by a non-relative?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1b1
          kind: Question
          title: "For about how many hours per week is that? (Non-relative in their home)"
          precondition:
            - predicate: q_car_q1b.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        - id: q_car_q1b2
          kind: Question
          title: "Is the person providing this care licensed by the government or approved by a family daycare agency?"
          precondition:
            - predicate: q_car_q1b.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # --- Q1C: Relative in their home ---
        - id: q_car_q1c
          kind: Question
          title: "Care in someone else's home by a relative?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1c1
          kind: Question
          title: "For about how many hours per week is that? (Relative in their home)"
          precondition:
            - predicate: q_car_q1c.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        - id: q_car_q1c2
          kind: Question
          title: "Is the person providing this care licensed by the government or approved by a family daycare agency?"
          precondition:
            - predicate: q_car_q1c.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # --- Q1D: Sibling in own home ---
        - id: q_car_q1d
          kind: Question
          title: "Care in own home by brother or sister of the child?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1d1
          kind: Question
          title: "For about how many hours per week is that? (Sibling in own home)"
          precondition:
            - predicate: q_car_q1d.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1E: Other relative in own home ---
        - id: q_car_q1e
          kind: Question
          title: "Care in own home by a relative other than a sister or brother of the child?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1e1
          kind: Question
          title: "For about how many hours per week is that? (Other relative in own home)"
          precondition:
            - predicate: q_car_q1e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1F: Non-relative in own home ---
        - id: q_car_q1f
          kind: Question
          title: "Care in own home by a non-relative?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1f1
          kind: Question
          title: "For about how many hours per week is that? (Non-relative in own home)"
          precondition:
            - predicate: q_car_q1f.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1G: Daycare centre ---
        - id: q_car_q1g
          kind: Question
          title: "Care in a daycare centre (including at workplace)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1g1
          kind: Question
          title: "For about how many hours per week is that? (Daycare centre)"
          precondition:
            - predicate: q_car_q1g.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        - id: q_car_q1g2
          kind: Question
          title: "Is the child care program or daycare centre operated on a profit or non-profit basis (include government sponsored care)?"
          precondition:
            - predicate: q_car_q1g.outcome == 1
          input:
            control: Radio
            labels:
              1: "Profit"
              2: "Non-profit"

        # --- Q1H: Before/after school program (age 4+) ---
        # CAR-C1H: IF AGE < 4 → skip Q1H
        - id: q_car_q1h
          kind: Question
          title: "Care in a before or after school program?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1h1
          kind: Question
          title: "For about how many hours per week is that? (Before/after school program)"
          precondition:
            - predicate: child_age >= 4
            - predicate: q_car_q1h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1I: Self-care (age 6+) ---
        # CAR-C1I: IF AGE 4-5 → skip Q1I
        - id: q_car_q1i
          kind: Question
          title: "Is the child in his/her own care (e.g. before/after school)?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1i1
          kind: Question
          title: "For about how many hours per week is that? (Self-care)"
          precondition:
            - predicate: child_age >= 6
            - predicate: q_car_q1i.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1J: Other arrangements ---
        - id: q_car_q1j
          kind: Question
          title: "Do you currently use other child care arrangements?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1j1
          kind: Question
          title: "For about how many hours per week is that? (Other arrangements)"
          precondition:
            - predicate: q_car_q1j.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

    # =========================================================================
    # BLOCK 3: MAIN ARRANGEMENT DETAILS (CAR-I2, CAR-Q2, CAR-Q3, CAR-Q4)
    # =========================================================================
    # Asked of all current care users.
    # I2: Intro about main arrangement
    # Q2: When started arrangement (year)
    # CAR-C3: IF AGE > 5 → skip Q3
    # Q3: How well child gets along with caregiver (age 0-5 only)
    # Q4: Number of changes in past 12 months
    # =========================================================================
    - id: b_car_main
      title: "Main Child Care Arrangement"
      precondition:
        - predicate: q_car_q1a.outcome == 1
      items:
        # CAR-I2: Introduction about main arrangement
        - id: q_car_i2
          kind: Comment
          title: "In the following questions we will be asking about your main child care arrangement, that is, the one used for the most hours."

        # CAR-Q2: When started arrangement
        - id: q_car_q2
          kind: Question
          title: "When did you start using this child care arrangement? (Enter year)"
          input:
            control: Editbox
            min: 1980
            max: 2000
            right: "year"

        # CAR-Q3: How well child gets along with caregiver (age 0-5)
        # CAR-C3: IF AGE > 5 → skip Q3
        - id: q_car_q3
          kind: Question
          title: "During the past 6 months, how well has he/she gotten along with his/her main child care provider?"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"

        # CAR-Q4: Changes in past 12 months
        - id: q_car_q4
          kind: Question
          title: "In the past 12 months, how many times have you changed your main child care arrangement and/or caregiver, excluding periods of care by yourself (or spouse/partner)?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "1"
              3: "2"
              4: "3 or 4"
              5: "5 or more"

    # =========================================================================
    # BLOCK 4: REASONS FOR CHANGING (CAR-Q5)
    # =========================================================================
    # CAR-C5: IF Q4=NONE(1) AND AGE<1 → END. IF Q4=NONE(1) AND AGE>=1 → Q7.
    #         OTHERWISE → Q5.
    # Q5 only asked when there were changes (Q4 != NONE).
    # =========================================================================
    - id: b_car_changes
      title: "Reasons for Changing Care"
      precondition:
        - predicate: q_car_q1a.outcome == 1
        - predicate: q_car_q4.outcome != 1
      items:
        # CAR-Q5: Reasons for changing
        - id: q_car_q5
          kind: Question
          title: "What were the reasons for changing? (Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Dissatisfaction with caregiver/program"
              2: "Caregiver/program no longer available"
              4: "Family or child moved, parental work status or custody arrangement changed"
              8: "Changes in child or child's needs (e.g. special care, child's age)"
              16: "A preferred arrangement became available (e.g. subsidized space)"
              32: "Cost"
              64: "Other"

    # =========================================================================
    # BLOCK 5: EVER USED CARE (CAR-Q6)
    # =========================================================================
    # CAR-C6: Only asked when Q1A=NO (not currently using care) AND age >= 1.
    # If age < 1 and not using care → end of section.
    # Q6=NO → end of section.
    # Q6=YES → continues to Q7.
    # =========================================================================
    - id: b_car_ever
      title: "Previous Child Care"
      precondition:
        - predicate: q_car_q1a.outcome == 0
        - predicate: child_age >= 1
      items:
        # CAR-Q6: Ever used child care
        - id: q_car_q6
          kind: Question
          title: "Have you ever used child care for this child while you (and your spouse/partner) were at work or studying?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 6: TOTAL CHANGES AND SUMMER CARE (CAR-Q7, CAR-Q8)
    # =========================================================================
    # Q7 reached from two paths:
    #   Path A: Currently using care (Q1A=YES) AND age >= 1
    #           (via C5 when Q4=NONE, or via E5 after Q5)
    #   Path B: Not using care (Q1A=NO) AND Q6=YES (ever used)
    # Q8: Summer care, only age 6+ (CAR-C8)
    # =========================================================================
    - id: b_car_total
      title: "Overall Child Care Changes"
      precondition:
        - predicate: (q_car_q1a.outcome == 1 and child_age >= 1) or (q_car_q1a.outcome == 0 and child_age >= 1 and q_car_q6.outcome == 1)
      items:
        # CAR-Q7: Total changes overall
        - id: q_car_q7
          kind: Question
          title: "Overall, how many changes in child care arrangements has this child experienced since you began using child care, excluding periods of care by yourself (or spouse/partner)?"
          input:
            control: Editbox
            min: 0
            max: 99

        # CAR-Q8: Summer care arrangements (age 6+)
        # CAR-C8: IF AGE < 6 → END
        - id: q_car_q8
          kind: Question
          title: "Last summer while this child was not in school, what type of child care arrangement did you use while you (and your spouse/partner) were at work/studying? (Mark all that apply.)"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Checkbox
            labels:
              1: "Day care centre"
              2: "Care in someone else's home by a non-relative"
              4: "Care in someone else's home by a relative"
              8: "Care in own home by a non-relative"
              16: "Care in own home by brother/sister"
              32: "Care in own home by other relative"
              64: "Child in own care"
              128: "Structured summer program"
              256: "Other"
