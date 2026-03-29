qmlVersion: "1.0"
questionnaire:
  title: "NLSCY - Education (Adult)"
  codeInit: |
    # Variable READ from prior sections
    respondent_age = 0  # from Demographics: respondent's age

  blocks:
    # =========================================================================
    # EDUCATION (ADULT)
    # =========================================================================
    # EDUC-C1: IF AGE < 12, skip entire section.
    # EDUC-Q1 -> EDUC-Q2 -> EDUC-Q3 -> EDUC-Q4 -> EDUC-Q5 -> EDUC-Q6
    #
    # Q1: Years of schooling. If 0 (no schooling) -> skip rest of section.
    # Q3: Post-secondary attendance. If NO -> skip Q4, go to C5/Q5.
    # C5: IF AGE >= 65 -> skip Q5 and Q6.
    # Q5: Currently attending school. If NO -> skip Q6.
    # Q6: Full-time or part-time (only if currently attending).
    # =========================================================================
    - id: b_education_adult
      title: "Education"
      precondition:
        - predicate: respondent_age >= 12
      items:
        # EDUC-Q1: Years of elementary and high school completed
        - id: q_educ_q1
          kind: Question
          title: "Excluding kindergarten, how many years of elementary and high school have you successfully completed?"
          input:
            control: Dropdown
            labels:
              0: "No schooling"
              1: "1-5 years"
              2: "6 years"
              3: "7 years"
              4: "8 years"
              5: "9 years"
              6: "10 years"
              7: "11 years"
              8: "12 years"
              9: "13 years"

        # EDUC-Q2: High school graduation
        # Skipped if no schooling (Q1 == 0 -> GO TO NEXT SECTION)
        # EDUC-C1A: IF AGE < 15 -> GO TO NEXT SECTION (only Q1 asked for ages 12-14)
        - id: q_educ_q2
          kind: Question
          title: "Have you graduated from high school?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUC-Q3: Post-secondary attendance
        # Skipped if no schooling or age < 15
        - id: q_educ_q3
          kind: Question
          title: "Have you ever attended any other kind of school such as a university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUC-Q4: Highest level of education attained
        # Only if attended post-secondary (Q3 == YES)
        - id: q_educ_q4
          kind: Question
          title: "What is the highest level of education that you have attained?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
            - predicate: q_educ_q3.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Some trade, technical or vocational school, or business college"
              2: "Some community college, CEGEP, or nursing school"
              3: "Some university"
              4: "Diploma or certificate from trade, technical or vocational school, or business college"
              5: "Diploma or certificate from community college, CEGEP or nursing school"
              6: "Bachelor or undergraduate degree, or teacher's college (e.g. B.A., B.Sc., LL.B.)"
              7: "Master's (e.g. M.A., M.Sc., M.Ed.)"
              8: "Degree in medicine, dentistry, veterinary medicine, law, optometry, or divinity"
              9: "Earned doctorate"

        # EDUC-Q5: Currently attending school
        # EDUC-C1A: IF AGE < 15, skip to next section
        # EDUC-C5: IF AGE >= 65, skip to next section
        # Also skipped if no schooling
        - id: q_educ_q5
          kind: Question
          title: "Are you currently attending a school, college or university?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
            - predicate: respondent_age < 65
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUC-Q6: Full-time or part-time
        # Only if currently attending school (Q5 == YES)
        - id: q_educ_q6
          kind: Question
          title: "Are you enrolled as a full-time or part-time student?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
            - predicate: respondent_age < 65
            - predicate: q_educ_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"
