qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Person: Education & Migration"

  codeInit: |
    highest_degree = 0

  blocks:
    - id: b_migration
      title: "Place of Birth & Citizenship"
      items:
        # P_Q7: Where was this person born?
        - id: q_p_q7
          kind: Question
          title: "Where was this person born?"
          input:
            control: Radio
            labels:
              1: "In the United States"
              2: "Outside the United States"

        # P_Q8: Citizenship status
        - id: q_p_q8
          kind: Question
          title: "Is this person a citizen of the United States?"
          input:
            control: Dropdown
            labels:
              1: "Yes, born in the United States"
              2: "Yes, born in Puerto Rico, Guam, the U.S. Virgin Islands, or Northern Marianas"
              3: "Yes, born abroad of U.S. citizen parent or parents"
              4: "Yes, U.S. citizen by naturalization"
              5: "No, not a U.S. citizen"

        # P_Q8_YEAR: When did this person come to live in the US?
        - id: q_p_q8_year
          kind: Question
          title: "When did this person come to live in the United States? If this person came to live in the United States more than once, print latest year."
          precondition:
            - predicate: "q_p_q8.outcome != 1"
          input:
            control: Editbox
            min: 1900
            max: 2026

    - id: b_education
      title: "School Enrollment & Educational Attainment"
      items:
        # P_Q10a: School attendance in last 3 months
        - id: q_p_q10a
          kind: Question
          title: "At any time IN THE LAST 3 MONTHS, has this person attended school or college?"
          input:
            control: Radio
            labels:
              0: "No, has not attended in the last 3 months"
              1: "Yes, public school, public college"
              2: "Yes, private school, private college, home school"

        # P_Q10b: Grade or level attending
        - id: q_p_q10b
          kind: Question
          title: "What grade or level was this person attending?"
          precondition:
            - predicate: "q_p_q10a.outcome in [1, 2]"
          input:
            control: Dropdown
            labels:
              1: "Nursery school, preschool"
              2: "Kindergarten"
              3: "Grade 1 through 12"
              4: "College undergraduate years (freshman to senior)"
              5: "Graduate or professional school beyond a bachelor's degree"

        # P_Q11: Highest degree completed
        - id: q_p_q11
          kind: Question
          title: "What is the highest grade of school or degree this person has COMPLETED?"
          input:
            control: Dropdown
            labels:
              1: "Less than grade 1"
              2: "Grade 1 through 11"
              3: "12th grade - NO DIPLOMA"
              4: "Regular high school diploma"
              5: "GED or alternative credential"
              6: "Some college credit, but less than 1 year"
              7: "1 or more years of college credit, no degree"
              8: "Associate's degree (AA, AS)"
              9: "Bachelor's degree (BA, BS)"
              10: "Master's degree (MA, MS, MEng, MEd, MSW, MBA)"
              11: "Professional degree beyond bachelor's (MD, DDS, DVM, LLB, JD)"
              12: "Doctorate degree (PhD, EdD)"
          codeBlock: |
            highest_degree = q_p_q11.outcome

        # P_Q12: Bachelor's degree major (Filter F: bachelor's or higher)
        - id: q_p_q12
          kind: Question
          title: "This question focuses on this person's BACHELOR'S DEGREE. Please print below the specific major(s) of any BACHELOR'S DEGREES this person has received."
          precondition:
            - predicate: "highest_degree >= 9"
          input:
            control: Textarea
            placeholder: "e.g., Economics, Civil Engineering, Nursing"
