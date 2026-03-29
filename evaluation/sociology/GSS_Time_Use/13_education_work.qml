qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Education and Work (Section P)"
  codeInit: |
    # Extern variable: multilingual path indicator from Section F
    lang_path: {1, 2, 3, 4, 5, 6}

  blocks:
    # =========================================================================
    # BLOCK: EDUCATION AND FIRST JOB
    # =========================================================================
    # Section P collects respondent's education history, first full-time job,
    # and language courses. Complex routing based on years of schooling (P1):
    #   P1=00          → GO TO P14 (no schooling, skip all education/work)
    #   P1=05-08       → ask P1a (primary languages), then GO TO P4
    #   P1=09-10       → GO TO P2 (primary languages for grade 9+)
    #   P1=11-13       → ask P1b (secondary graduation), then GO TO P2
    # =========================================================================
    - id: b_education_work
      title: "Education and Work"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # P1: Years of elementary/secondary education
        - id: q_p1
          kind: Question
          title: "How many years of elementary and secondary education have you completed?"
          codeBlock: |
            if q_p1.outcome == 0:
              p1_no_school = 1
            else:
              p1_no_school = 0
          input:
            control: Radio
            labels:
              0: "No schooling"
              5: "One to five years"
              6: "Six"
              7: "Seven"
              8: "Eight"
              9: "Nine"
              10: "Ten"
              11: "Eleven"
              12: "Twelve"
              13: "Thirteen"

        # P1a: Primary school teaching languages (P1 = 5-8 only)
        - id: q_p1a
          kind: Question
          title: "Which languages were used for teaching your courses at primary school, excluding language courses?"
          precondition:
            - predicate: q_p1.outcome in [5, 6, 7, 8]
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P1b: Secondary school graduation (P1 = 11-13 only)
        - id: q_p1b
          kind: Question
          title: "Have you graduated from secondary school?"
          precondition:
            - predicate: q_p1.outcome in [11, 12, 13]
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P2: Primary school teaching languages (P1 = 9-13)
        # After P1a (P1=5-8) routing goes to P4, so P2 is only for P1=9+.
        - id: q_p2
          kind: Question
          title: "Which languages were used for teaching your courses at primary school, excluding language courses?"
          precondition:
            - predicate: q_p1.outcome in [9, 10, 11, 12, 13]
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P3: Secondary school teaching languages (P1 = 9-13)
        - id: q_p3
          kind: Question
          title: "What about languages used for teaching your courses at secondary school, excluding language courses?"
          precondition:
            - predicate: q_p1.outcome in [9, 10, 11, 12, 13]
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P4: Further schooling beyond elementary/secondary
        # Shown for anyone with some schooling (P1 != 0)
        - id: q_p4
          kind: Question
          title: "Have you had any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: p1_no_school == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P5: Post-secondary teaching languages (P4 = Yes)
        - id: q_p5
          kind: Question
          title: "Which languages were/are used for teaching your courses at these levels, excluding language courses?"
          precondition:
            - predicate: q_p4.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P6: Highest level attained (P4 = Yes)
        - id: q_p6
          kind: Question
          title: "What is the highest level you attained?"
          precondition:
            - predicate: q_p4.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"

        # P7: Year of highest level of education
        # Shown for anyone with some schooling
        - id: q_p7
          kind: Question
          title: "In which year did you reach your highest level of education?"
          precondition:
            - predicate: p1_no_school == 0
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # P8: First full-time job type
        # Shown for anyone with some schooling
        - id: q_p8
          kind: Question
          title: "Think about the first full-time job you had after reaching your highest level of education. Were you an employee working for someone else or self-employed?"
          precondition:
            - predicate: p1_no_school == 0
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"
              3: "Never had a full-time job after this date"

        # P9: Employer name (P8 = 1, employee)
        - id: q_p9
          kind: Question
          title: "For whom did you work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_p8.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # P10: Kind of business/industry (P8 = 1 or 2)
        - id: q_p10
          kind: Question
          title: "What was the main kind of business, industry or service? (Give a full description)"
          precondition:
            - predicate: q_p8.outcome in [1, 2]
          input:
            control: Textarea
            placeholder: "Enter business description"

        # P11: Kind of work (P8 = 1 or 2)
        - id: q_p11
          kind: Question
          title: "What kind of work were you doing? (Give a full description)"
          precondition:
            - predicate: q_p8.outcome in [1, 2]
          input:
            control: Textarea
            placeholder: "Enter work description"

        # P12: Year began working (P8 = 1 or 2)
        - id: q_p12
          kind: Question
          title: "In what year did you begin working at this job?"
          precondition:
            - predicate: q_p8.outcome in [1, 2]
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # P13: Language courses in school
        # Shown for anyone with some schooling
        - id: q_p13
          kind: Question
          title: "Have you ever taken any language courses as part of full-time school?"
          precondition:
            - predicate: p1_no_school == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P13a: Which languages (P13 = Yes)
        - id: q_p13a
          kind: Question
          title: "Which languages?"
          precondition:
            - predicate: q_p13.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P14: Language courses outside school
        # Asked of everyone (including those with no schooling)
        - id: q_p14
          kind: Question
          title: "Have you ever taken any language courses outside of full-time school?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P14a: Which languages (P14 = Yes)
        - id: q_p14a
          kind: Question
          title: "Which languages?"
          precondition:
            - predicate: q_p14.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"
