qmlVersion: "1.0"
questionnaire:
  title: "SLID 1994 Preliminary Interview - Education (EDUPRE)"

  codeInit: |
    # Extern variables from earlier sections
    age: range(0, 120)
    current_year: range(1990, 2100)

  blocks:
    # =========================================================================
    # BLOCK: EDUCATION (EDUPRE)
    # =========================================================================
    # Q1-Q3: Elementary/high school
    # Q4-Q11: Non-university education (college, trade, CEGEP)
    # Q12-Q16: University education
    # Q17-Q18: Parents' education level
    # =========================================================================
    - id: b_edupre
      title: "Educational Attainment"
      items:
        # Q1: Years of elementary and high school
        - id: q_q1
          kind: Question
          title: "How many years of elementary and high school did the respondent complete?"
          postcondition:
            - predicate: q_q1.outcome <= age - 5
              hint: "Years of schooling should not exceed age minus 5. Please verify."
          input:
            control: Editbox
            min: 0
            max: 15
            right: "years"

        # Q2: Province of education
        # Reached if Q1 >= 1 (Q1=0 skips to Q17)
        - id: q_q2
          kind: Question
          title: "In which province or territory did the respondent get most of his/her elementary and high school education?"
          precondition:
            - predicate: q_q1.outcome >= 1
          input:
            control: Dropdown
            labels:
              1: "Newfoundland"
              2: "Prince Edward Island"
              3: "Nova Scotia"
              4: "New Brunswick"
              5: "Quebec"
              6: "Ontario"
              7: "Manitoba"
              8: "Saskatchewan"
              9: "Alberta"
              10: "British Columbia"
              11: "Yukon"
              12: "Northwest Territories"
              13: "Outside Canada"

        # Q3: Completed high school?
        # Only asked if Q1 >= 10 (EVAL-Q1: Q1=1-9 skips to Q4)
        - id: q_q3
          kind: Question
          title: "Did the respondent complete high school?"
          precondition:
            - predicate: q_q1.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q4: Ever enrolled in non-university school?
        # Reached if Q1 >= 1 (either from Q3 or from EVAL-Q1 skip)
        - id: q_q4
          kind: Question
          title: "Excluding university, has the respondent ever been enrolled in any other kind of school, for example, a community college, business school, trade or vocational school, or CEGEP?"
          precondition:
            - predicate: q_q1.outcome >= 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q5: Received certificates or diplomas?
        # Only if Q4 = Yes
        - id: q_q5
          kind: Question
          title: "Has the respondent received any certificates or diplomas as a result of this education?"
          precondition:
            - predicate: q_q4.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q6: Type of school for most recent certificate
        # Only if Q5 = Yes
        - id: q_q6
          kind: Question
          title: "Thinking of the most recent certificate or diploma (excluding university), what type of school or college did the respondent attend?"
          precondition:
            - predicate: q_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Community college or institute of applied arts and technology"
              2: "Business or commercial school"
              3: "Trade or vocational school"
              4: "CEGEP"
              5: "Some other type (specify)"

        # Q6 follow-up: Specify other type of school
        - id: q_q6_other
          kind: Question
          title: "Please specify the type of school:"
          precondition:
            - predicate: q_q6.outcome == 5
          input:
            control: Textarea
            placeholder: "Type of school..."
            maxLength: 200

        # Q7: How long to complete program — months or years?
        # Only if Q5 = Yes (same gate as Q6)
        - id: q_q7
          kind: Question
          title: "How long did it take the respondent to complete this program?"
          precondition:
            - predicate: q_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Answer given in months"
              2: "Answer given in years"

        # Q7A: Number of months
        # Only if Q7 = Months
        - id: q_q7a
          kind: Question
          title: "Enter the number of months it took to complete this program:"
          precondition:
            - predicate: q_q7.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99
            right: "months"

        # Q7B: Number of years
        # Only if Q7 = Years
        - id: q_q7b
          kind: Question
          title: "Enter the number of years it took to complete this program:"
          precondition:
            - predicate: q_q7.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 9
            right: "years"

        # Q8: Full-time, part-time, or some of each?
        # Only if Q5 = Yes (same gate as Q6)
        - id: q_q8
          kind: Question
          title: "Was this full-time, part-time, or some of each?"
          precondition:
            - predicate: q_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"
              3: "Some of each"

        # Q9: Year received diploma
        # Only if Q5 = Yes
        - id: q_q9
          kind: Question
          title: "In what year did the respondent receive his/her certificate or diploma?"
          precondition:
            - predicate: q_q5.outcome == 1
          postcondition:
            - predicate: q_q9.outcome >= current_year - age + 14
              hint: "Year of diploma seems too early given the respondent's age. Please verify."
          input:
            control: Editbox
            min: 1900
            max: 2100
            left: "Year:"

        # Q10: Major field of study (non-university)
        # Only if Q5 = Yes
        - id: q_q10
          kind: Question
          title: "What was the major subject or field of study?"
          precondition:
            - predicate: q_q5.outcome == 1
          input:
            control: Textarea
            placeholder: "Major field of study..."
            maxLength: 300

        # Q11: Total years of non-university schooling
        # Reached if Q4 = Yes (enrolled in non-university school)
        - id: q_q11
          kind: Question
          title: "In total, how many years of schooling did the respondent complete at a community college, technical institute, trade or vocational school, or CEGEP? (Enter 0 if less than one year)"
          precondition:
            - predicate: q_q4.outcome == 1
          postcondition:
            - predicate: q_q11.outcome <= age - 14
              hint: "Years of non-university schooling cannot exceed age minus 14. Please verify."
          input:
            control: Editbox
            min: 0
            max: 20
            right: "years"

        # Q12: Ever enrolled in university?
        # Reached if Q1 >= 1 (everyone with schooling)
        # Entry paths: Q4=No, or after Q11 (Q4=Yes path)
        - id: q_q12
          kind: Question
          title: "Has the respondent ever been enrolled in a university?"
          precondition:
            - predicate: q_q1.outcome >= 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q13: Years of university
        # Only if Q12 = Yes
        - id: q_q13
          kind: Question
          title: "How many years of university has the respondent completed? (Enter 0 if attended university but didn't complete the year)"
          precondition:
            - predicate: q_q12.outcome == 1
          postcondition:
            - predicate: q_q13.outcome <= age - 14
              hint: "Years of university cannot exceed age minus 14. Please verify."
          input:
            control: Editbox
            min: 0
            max: 20
            right: "years"

        # Q14: University degrees received?
        # Only if Q12 = Yes
        - id: q_q14
          kind: Question
          title: "What degrees, certificates, or diplomas has the respondent received from a university?"
          precondition:
            - predicate: q_q12.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Specify degrees"
              3: "Don't know / Refused"

        # Q14A: Specify degrees (multi-select)
        # Only if Q14 = Specify degrees
        # Checkbox keys must be powers of 2
        - id: q_q14a
          kind: Question
          title: "Specify degrees, certificates, or diplomas the respondent has received from a university. Mark all that apply."
          precondition:
            - predicate: q_q14.outcome == 2
          input:
            control: Checkbox
            labels:
              1: "University certificate/diploma below Bachelor level"
              2: "Bachelor's degree(s)"
              4: "University certificate/diploma above Bachelor level"
              8: "Master's degree(s)"
              16: "Degree in medicine, dentistry, veterinary medicine, or optometry"
              32: "Doctorate (PhD)"

        # Q15: Year received highest degree
        # Reached from Q14A (Specify Degrees path) or Q14=DK/R directly
        - id: q_q15
          kind: Question
          title: "What year did the respondent receive his/her highest degree?"
          precondition:
            - predicate: q_q14.outcome >= 2
          input:
            control: Editbox
            min: 1900
            max: 2100
            left: "Year:"

        # Q16: Major field of study (university)
        # Only if Q14 = Specify degrees
        - id: q_q16
          kind: Question
          title: "What was the major field of study?"
          precondition:
            - predicate: q_q14.outcome == 2
          input:
            control: Textarea
            placeholder: "Major field of study..."
            maxLength: 300

        # Q17: Mother's highest education level
        # Reached by everyone (all paths converge here)
        - id: q_q17
          kind: Question
          title: "What was the highest level of education completed by the respondent's mother?"
          input:
            control: Dropdown
            labels:
              1: "Elementary school (includes no schooling)"
              2: "Some high school"
              3: "Completed high school"
              4: "Trade/vocational school"
              5: "Post-secondary certificate or diploma"
              6: "University degree"

        # Q18: Father's highest education level
        # Always shown — final item in questionnaire
        - id: q_q18
          kind: Question
          title: "What was the highest level of education completed by the respondent's father?"
          input:
            control: Dropdown
            labels:
              1: "Elementary school (includes no schooling)"
              2: "Some high school"
              3: "Completed high school"
              4: "Trade/vocational school"
              5: "Post-secondary certificate or diploma"
              6: "University degree"
