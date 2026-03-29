qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth Survey - Education (Children)"
  codeInit: |
    # Variables READ from prior sections
    child_age = 0       # from Contact/Household: child's age
    province = 0        # from Contact/Household: province code

    # Variables PRODUCED by this section
    in_school = 0       # 0=not in school, 1=in school
    school_grade = 0    # consolidated grade value (0=not in school, 16=ungraded)

  blocks:
    # =========================================================================
    # BLOCK 1: SCHOOL GRADE AND ATTENDANCE
    # =========================================================================
    # EDU-C1: IF AGE < 4 -> skip entire section (to Literacy)
    # EDU-Q1/Q1A-Q1E: Province-specific grade question — modeled as ONE
    #   generic Dropdown covering all province grade labels.
    # EDU-Q2: Junior kindergarten attendance
    # EDU-Q3: Kindergarten attendance (if not currently in kindergarten)
    # =========================================================================
    - id: b_edu_grade
      title: "School Grade and Attendance"
      precondition:
        - predicate: child_age >= 4
      items:
        # EDU-I1: Introduction
        - id: q_edu_intro
          kind: Comment
          title: "The next section is about the child's experiences at school."

        # EDU-Q1 (unified): What school grade is the child in?
        # Consolidates Q1, Q1A-Q1E (6 province variants) into one generic
        # Dropdown. All provinces map to the same ordinal grade structure;
        # province-specific labels (e.g. "Grade 7 Elementary", "Secondary I")
        # are minor naming differences, not distinct data.
        - id: q_edu_q1
          kind: Question
          title: "What school grade is the child in?"
          input:
            control: Dropdown
            labels:
              1: "Not in school"
              2: "Junior Kindergarten"
              3: "Kindergarten / Primary"
              4: "Grade 1"
              5: "Grade 2"
              6: "Grade 3"
              7: "Grade 4"
              8: "Grade 5"
              9: "Grade 6"
              10: "Grade 7"
              11: "Grade 8"
              12: "Grade 9"
              13: "Grade 10"
              14: "Grade 11"
              15: "Grade 12"
              16: "OAC / Grade 13"
              17: "Ungraded"
          codeBlock: |
            if q_edu_q1.outcome == 1:
                in_school = 0
                school_grade = 0
            else:
                in_school = 1
                school_grade = q_edu_q1.outcome
            if q_edu_q1.outcome == 17:
                school_grade = 17

        # EDU-Q2: Junior kindergarten attendance
        # Shown only if child is in school and NOT "Not in school"
        - id: q_edu_q2
          kind: Question
          title: "Did the child attend junior kindergarten?"
          precondition:
            - predicate: in_school == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # EDU-Q3: Kindergarten attendance
        # Skip if currently in kindergarten/primary (grade 3) or junior kindergarten (grade 2)
        - id: q_edu_q3
          kind: Question
          title: "Did the child attend kindergarten or primary?"
          precondition:
            - predicate: in_school == 1
            - predicate: q_edu_q1.outcome != 2
            - predicate: q_edu_q1.outcome != 3
            - predicate: q_edu_q1.outcome != 17
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: GRADE SKIPPING AND REPEATING
    # =========================================================================
    # EDU-Q4: Ever skipped a grade -> if YES -> Q5 (which grade)
    # EDU-Q6: Ever repeated a grade -> if YES -> Q7 (which grade)
    # Q5 and Q7 use unified grade Dropdowns (consolidating province variants).
    # =========================================================================
    - id: b_edu_skip_repeat
      title: "Grade Skipping and Repeating"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
        - predicate: q_edu_q1.outcome != 17
      items:
        # EDU-Q4: Ever skipped a grade
        - id: q_edu_q4
          kind: Question
          title: "Has the child ever skipped a grade at school? (Include kindergarten)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # EDU-Q5 (unified): Which grade was skipped
        # Consolidates Q5, Q5A-Q5E into one generic Dropdown
        - id: q_edu_q5
          kind: Question
          title: "What grade has the child skipped? (If more than one, mark the most recent.)"
          precondition:
            - predicate: q_edu_q4.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Kindergarten"
              2: "Grade 1"
              3: "Grade 2"
              4: "Grade 3"
              5: "Grade 4"
              6: "Grade 5"
              7: "Grade 6"
              8: "Grade 7"
              9: "Grade 8"
              10: "Grade 9"
              11: "Grade 10"
              12: "Grade 11"
              13: "Grade 12"
              14: "OAC / Grade 13"

        # EDU-Q6: Ever repeated a grade
        - id: q_edu_q6
          kind: Question
          title: "Has the child ever repeated a grade at school? (Include kindergarten)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # EDU-Q7 (unified): Which grade was repeated
        # Consolidates Q7, Q7A-Q7E into one generic Dropdown
        - id: q_edu_q7
          kind: Question
          title: "What grade has the child repeated? (If more than one, mark the most recent.)"
          precondition:
            - predicate: q_edu_q6.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Kindergarten"
              2: "Grade 1"
              3: "Grade 2"
              4: "Grade 3"
              5: "Grade 4"
              6: "Grade 5"
              7: "Grade 6"
              8: "Grade 7"
              9: "Grade 8"
              10: "Grade 9"
              11: "Grade 10"
              12: "Grade 11"
              13: "Grade 12"
              14: "OAC / Grade 13"

    # =========================================================================
    # BLOCK 3: SCHOOL TYPE AND CHANGES
    # =========================================================================
    # EDU-Q8: School type (public, catholic, private, other)
    # EDU-Q9A: Ever changed schools (non-natural progression)
    # EDU-Q9B: How many times changed (if yes)
    # EDU-Q10: Reason for most recent change (if yes)
    # EDU-Q11: Number of residential moves
    # =========================================================================
    - id: b_edu_school_type
      title: "School Type and Changes"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q8: School type
        # Shown to all in-school children (including ungraded)
        - id: q_edu_q8
          kind: Question
          title: "What type of school is the child currently in?"
          input:
            control: Radio
            labels:
              1: "Public school"
              2: "Catholic school, publicly funded"
              3: "Private school"
              4: "Other"

        # EDU-Q9A: Ever changed schools
        - id: q_edu_q9a
          kind: Question
          title: "Other than natural progression through the school system in your area, has the child ever changed schools?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"

        # EDU-Q9B: Number of school changes
        - id: q_edu_q9b
          kind: Question
          title: "How many times has the child changed schools?"
          precondition:
            - predicate: q_edu_q9a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "times"

        # EDU-Q10: Reason for most recent school change
        - id: q_edu_q10
          kind: Question
          title: "For the most recent change in schools, what was the reason for changing?"
          precondition:
            - predicate: q_edu_q9a.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Family or child moved"
              2: "Child not progressing well academically"
              3: "Child not progressing well in language of instruction"
              4: "Child not getting along well with others at school"
              5: "Concerns about school's academic standards or quality"
              6: "Concerns about school safety or discipline"
              7: "Concerns about school facilities or resources"
              8: "Other"

        # EDU-Q11: Number of residential moves
        - id: q_edu_q11
          kind: Question
          title: "Aside from school changes, how many times in the child's life has he/she moved, that is, changed his/her usual place of residence?"
          input:
            control: Editbox
            min: 0
            max: 50
            right: "times"

    # =========================================================================
    # BLOCK 4: LANGUAGE AND ABSENCES
    # =========================================================================
    # EDU-Q12A: Language of instruction
    # EDU-Q12B: Language at home (age 4-5 only)
    # EDU-Q13: Days absent since school started
    # =========================================================================
    - id: b_edu_language
      title: "Language and Absences"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q12A: Language of instruction
        - id: q_edu_q12a
          kind: Question
          title: "In what language is the child mainly taught?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Both English and French"
              4: "Other"

        # EDU-Q12B: Language spoken at home
        # EDU-C12B: Only for age 4-5 (IF AGE > 5 -> skip to Q13)
        - id: q_edu_q12b
          kind: Question
          title: "What language does the child speak most often at home? (Mark all that apply.)"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # EDU-Q13: Days absent from school
        - id: q_edu_q13
          kind: Question
          title: "Since the child started school in the fall, about how many days has he/she been away from school for any reason?"
          input:
            control: Editbox
            min: 0
            max: 200
            right: "days"

    # =========================================================================
    # BLOCK 5: ACADEMIC PERFORMANCE
    # =========================================================================
    # EDU-C14A: Skip if in kindergarten/primary/junior kindergarten/ungraded
    # Shown only for children in grade 1 or higher (school_grade >= 4 means
    # grade 1+, since 2=JK, 3=K/Primary, 17=ungraded are excluded).
    # EDU-Q14A-D: Performance in reading, math, writing, overall
    # =========================================================================
    - id: b_edu_performance
      title: "Academic Performance"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
        - predicate: school_grade >= 4
        - predicate: school_grade <= 16
      items:
        # EDU-Q14A-D: Academic performance ratings
        - id: qg_edu_q14
          kind: QuestionGroup
          title: "Based on your knowledge of the child's school work, including report cards, how is the child doing in the following areas at school this year?"
          questions:
            - "Reading"
            - "Mathematics"
            - "Written work such as composition"
            - "Overall"
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Average"
              4: "Poorly"
              5: "Very poorly"

    # =========================================================================
    # BLOCK 6: TUTORING
    # =========================================================================
    # EDU-Q15A: Received tutoring outside school?
    # EDU-Q15B: How often? (only if YES)
    # =========================================================================
    - id: b_edu_tutoring
      title: "Tutoring"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q15A: Received tutoring
        - id: q_edu_q15a
          kind: Question
          title: "Since the child started school in the fall, has he/she received any help or tutoring outside of school?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # EDU-Q15B: Tutoring frequency
        - id: q_edu_q15b
          kind: Question
          title: "How often does the child receive tutoring?"
          precondition:
            - predicate: q_edu_q15a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Once a week or less often"
              2: "Twice a week"
              3: "More than twice a week"

    # =========================================================================
    # BLOCK 7: SCHOOL ATTITUDES AND EXPECTATIONS
    # =========================================================================
    # EDU-Q16: School contact about behaviour
    # EDU-Q17: Looks forward to school
    # EDU-C18: IF AGE < 8 -> Q18B; OTHERWISE -> Q18A
    # EDU-Q18A: Importance of good grades (age 8+)
    # EDU-Q18B: Educational hopes (all ages)
    # =========================================================================
    - id: b_edu_attitudes
      title: "School Attitudes and Expectations"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q16: School contact about behaviour
        - id: q_edu_q16
          kind: Question
          title: "Since the child started school in the fall, how many times have you been contacted by his/her school regarding his/her behaviour at school?"
          input:
            control: Radio
            labels:
              1: "None or once"
              2: "Two or three times"
              3: "Four or more times"

        # EDU-Q17: Looks forward to school
        - id: q_edu_q17
          kind: Question
          title: "With regard to how the child feels about school, how often does he/she look forward to going to school?"
          input:
            control: Radio
            labels:
              1: "Almost never"
              2: "Rarely"
              3: "Sometimes"
              4: "Often"
              5: "Almost always"

        # EDU-Q18A: Importance of good grades (age 8+)
        # EDU-C18: IF AGE < 8 -> skip to Q18B
        - id: q_edu_q18a
          kind: Question
          title: "How important is it to you that the child have good grades in school?"
          precondition:
            - predicate: child_age >= 8
          input:
            control: Radio
            labels:
              1: "Very important"
              2: "Important"
              3: "Somewhat important"
              4: "Not important at all"

        # EDU-Q18B: Educational hopes
        - id: q_edu_q18b
          kind: Question
          title: "How far do you hope the child will go in school?"
          input:
            control: Dropdown
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college, or CEGEP"
              4: "University"
              5: "Learn a trade"
              6: "Other"

    # =========================================================================
    # BLOCK 8: SCHOOL DESCRIPTORS
    # =========================================================================
    # EDU-C19A: Skip if in kindergarten/primary/junior kindergarten/ungraded
    #   (same condition as academic performance block)
    # EDU-I19A: Introduction
    # EDU-Q19A-D: School descriptor ratings
    # =========================================================================
    - id: b_edu_descriptors
      title: "School Descriptors"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
        - predicate: school_grade >= 4
        - predicate: school_grade <= 16
      items:
        # EDU-I19A: Introduction to school descriptors
        - id: q_edu_i19a
          kind: Comment
          title: "The following are possible descriptions of the child's present school. For each, please indicate whether you strongly agree, agree, disagree, or strongly disagree."

        # EDU-Q19A-D: School descriptors
        - id: qg_edu_q19
          kind: QuestionGroup
          title: "Please rate the following descriptions of the child's school:"
          questions:
            - "Academic progress is very important at this school"
            - "Most children in this school enjoy being there"
            - "Parents are made to feel welcome in this school"
            - "School spirit is very high"
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

    # =========================================================================
    # BLOCK 9: SPECIAL EDUCATION
    # =========================================================================
    # EDU-Q20: Special education
    # =========================================================================
    - id: b_edu_special
      title: "Special Education"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q20: Special education
        - id: q_edu_q20
          kind: Question
          title: "Does the child receive special education because a physical, emotional, behavioural, or some other problem limits the kind or amount of school work he/she can do?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
