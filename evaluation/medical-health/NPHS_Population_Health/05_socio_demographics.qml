qmlVersion: "1.0"
questionnaire:
  title: "NPHS - Socio-demographic Characteristics"
  codeInit: |
    # Extern variable from household section
    age: range(0, 120)

  blocks:
    # =========================================================================
    # INTRODUCTION
    # =========================================================================
    - id: b_socio_intro
      title: "Introduction"
      items:
        # SOCIO-INT: Section introduction (interviewer instruction, no response)
        - id: q_socio_int
          kind: Comment
          title: "Now I'd like to ask some general background questions about the characteristics of people in your household."

    # =========================================================================
    # COUNTRY OF BIRTH AND IMMIGRATION
    # =========================================================================
    # SOCIO-Q1: Canada (1) or DK/R (20) -> skip to Q4 (ethnicity)
    #           Other country -> ask Q3 (immigration year)
    # SOCIO-Q3: Always ends at Q4 (DK/R included)
    # =========================================================================
    - id: b_socio_birth
      title: "Country of Birth and Immigration"
      items:
        # SOCIO-Q1 / SDC4_1: Country of birth
        # Canada=1, DK/R=20 -> GO TO SOCIO-Q4
        # Any other country -> proceed to SOCIO-Q3
        - id: q_socio_q1
          kind: Question
          title: "In what country were/was ... born? (Do not read list. Mark one only.)"
          input:
            control: Dropdown
            labels:
              1: "Canada"
              2: "China"
              3: "France"
              4: "Germany"
              5: "Greece"
              6: "Guyana"
              7: "Hong Kong"
              8: "Hungary"
              9: "India"
              10: "Italy"
              11: "Jamaica"
              12: "Netherlands"
              13: "Philippines"
              14: "Poland"
              15: "Portugal"
              16: "United Kingdom"
              17: "United States"
              18: "Viet Nam"
              19: "Other (specify)"
              20: "Don't know / Refused"

        # SOCIO-Q1 Other specify
        - id: q_socio_q1_other
          kind: Question
          title: "Please specify the country of birth."
          precondition:
            - predicate: q_socio_q1.outcome == 19
          input:
            control: Textarea
            placeholder: "Specify country..."

        # SOCIO-Q3 / SDC4_3: Year of immigration
        # Only asked if born outside Canada AND not DK/R
        # (Canada=1, DK/R=20 both route to Q4)
        - id: q_socio_q3
          kind: Question
          title: "In what year did ... first immigrate to Canada?"
          precondition:
            - predicate: q_socio_q1.outcome != 1 and q_socio_q1.outcome != 20
          input:
            control: Editbox
            min: 1800
            max: 1999

    # =========================================================================
    # ETHNICITY
    # =========================================================================
    # SOCIO-Q4: Always asked (19 options — use QuestionGroup of Switch items)
    # =========================================================================
    - id: b_socio_ethnicity
      title: "Ethnicity"
      items:
        # SOCIO-Q4 / SDC4_4A-SDC4_4S: Ethnic or cultural groups (mark all that apply)
        - id: qg_socio_q4
          kind: QuestionGroup
          title: "To which ethnic or cultural group(s) did your/his/her ancestors belong? (Do not read list. Mark all that apply.)"
          questions:
            - "Canadian"
            - "French"
            - "English"
            - "German"
            - "Scottish"
            - "Irish"
            - "Italian"
            - "Ukrainian"
            - "Dutch (Netherlands)"
            - "Chinese"
            - "Jewish"
            - "Polish"
            - "Portuguese"
            - "South Asian"
            - "Black"
            - "North American Indian"
            - "Metis"
            - "Inuit/Eskimo"
            - "Other (specify)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q4 Other specify
        - id: q_socio_q4_other
          kind: Question
          title: "Please specify the other ethnic or cultural group."
          precondition:
            - predicate: qg_socio_q4.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify ethnic or cultural group..."

    # =========================================================================
    # LANGUAGE
    # =========================================================================
    # SOCIO-Q5: Languages for conversation (19 options)
    # SOCIO-Q6: Mother tongue (19 options)
    # =========================================================================
    - id: b_socio_language
      title: "Language"
      items:
        # SOCIO-Q5 / SDC4_5A-SDC4_5S: Languages for conversation (mark all that apply)
        - id: qg_socio_q5
          kind: QuestionGroup
          title: "In which languages can ... conduct a conversation? (Do not read list. Mark all that apply.)"
          questions:
            - "English"
            - "French"
            - "Arabic"
            - "Chinese"
            - "Cree"
            - "German"
            - "Greek"
            - "Hungarian"
            - "Italian"
            - "Korean"
            - "Persian (Farsi)"
            - "Polish"
            - "Portuguese"
            - "Punjabi"
            - "Spanish"
            - "Tagalog (Filipino)"
            - "Ukrainian"
            - "Vietnamese"
            - "Other (specify)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q5 Other specify
        - id: q_socio_q5_other
          kind: Question
          title: "Please specify the other language(s) for conversation."
          precondition:
            - predicate: qg_socio_q5.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # SOCIO-Q6 / SDC4_6A-SDC4_6S: Mother tongue (mark all that apply)
        - id: qg_socio_q6
          kind: QuestionGroup
          title: "What is the language that ... first learned at home in childhood and can still understand? (Do not read list. Mark all that apply.)"
          questions:
            - "English"
            - "French"
            - "Arabic"
            - "Chinese"
            - "Cree"
            - "German"
            - "Greek"
            - "Hungarian"
            - "Italian"
            - "Korean"
            - "Persian (Farsi)"
            - "Polish"
            - "Portuguese"
            - "Punjabi"
            - "Spanish"
            - "Tagalog (Filipino)"
            - "Ukrainian"
            - "Vietnamese"
            - "Other (specify)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q6 Other specify
        - id: q_socio_q6_other
          kind: Question
          title: "Please specify the other mother tongue language."
          precondition:
            - predicate: qg_socio_q6.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

    # =========================================================================
    # RACE
    # =========================================================================
    # SOCIO-Q7: 11 options — use QuestionGroup of Switch items
    # =========================================================================
    - id: b_socio_race
      title: "Race"
      items:
        # SOCIO-Q7 / SDC4_7A-SDC4_7L: Race or colour (mark all that apply)
        - id: qg_socio_q7
          kind: QuestionGroup
          title: "How would you best describe ...(r/'s) race or colour? (Do not read list. Mark all that apply.)"
          questions:
            - "White"
            - "Chinese"
            - "South Asian"
            - "Black"
            - "Filipino"
            - "West Asian or North African"
            - "South East Asian"
            - "Japanese"
            - "Korean"
            - "Native/Aboriginal Peoples of North America"
            - "Other (specify)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q7 Other specify
        - id: q_socio_q7_other
          kind: Question
          title: "Please specify the other race or colour."
          precondition:
            - predicate: qg_socio_q7.outcome[10] == 1
          input:
            control: Textarea
            placeholder: "Specify race or colour..."

    # =========================================================================
    # EDUCATION
    # =========================================================================
    # EDUC-C1: age < 12 -> skip entire education block
    # EDUC-Q1: No schooling (0) -> skip rest; age < 15 -> skip rest; DK/R (10) -> skip rest
    # EDUC-Q2: Asked if Q1 has a schooling value (> 0 and != 10) and age >= 15
    # EDUC-Q3: Post-secondary. No (2) -> skip to C5/Q5. DK/R (3) -> skip all.
    # EDUC-Q4: Highest level. Only if Q3 = Yes (1).
    # EDUC-C5: age >= 65 -> skip Q5 and Q6
    # EDUC-Q5: Currently attending school. No/DK/R -> skip Q6.
    # EDUC-Q6: Full/part time. Only if Q5 = Yes (1).
    # =========================================================================
    - id: b_education
      title: "Education"
      precondition:
        - predicate: age >= 12
      items:
        # EDUC-Q1 / EDC4_4: Years of elementary and high school completed
        # 0=No schooling (->skip rest), 1-9=years 1-9, 10=DK/R (->skip rest)
        # Note: age < 15 also routes to Labour Force (skip rest of education)
        - id: q_educ_q1
          kind: Question
          title: "Excluding kindergarten, how many years of elementary and high school have/has ... successfully completed? (Do not read list. Mark one only.)"
          input:
            control: Radio
            labels:
              0: "No schooling"
              1: "One to five years"
              2: "Six"
              3: "Seven"
              4: "Eight"
              5: "Nine"
              6: "Ten"
              7: "Eleven"
              8: "Twelve"
              9: "Thirteen"
              10: "Don't know / Refused"

        # EDUC-Q2 / EDC4_5: High school graduation
        # Skipped if: No schooling (0), DK/R (10), or age < 15
        - id: q_educ_q2
          kind: Question
          title: "Have/has ... graduated from high school?"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUC-Q3 / EDC4_6: Post-secondary attendance
        # Skipped if: No schooling, DK/R on Q1, or age < 15
        # No (2) -> skip to EDUC-C5/Q5; DK/R (3) -> skip all remaining education
        - id: q_educ_q3
          kind: Question
          title: "Have/has ... ever attended any other kind of school such as university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution?"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # EDUC-Q4 / EDC4_7: Highest education level
        # Only if Q3 = Yes (1)
        - id: q_educ_q4
          kind: Question
          title: "What is the highest level of education that ... have/has attained? (Do not read list. Mark one only.)"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
            - predicate: q_educ_q3.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Some trade/technical/vocational school or business college"
              2: "Some community college/CEGEP/nursing school"
              3: "Some university"
              4: "Diploma/certificate from trade/technical/vocational school or business college"
              5: "Diploma/certificate from community college/CEGEP/nursing school"
              6: "Bachelor's or undergraduate degree or teacher's college"
              7: "Master's degree"
              8: "Degree in medicine/dentistry/veterinary medicine/optometry"
              9: "Earned doctorate"
              10: "Other (specify)"

        # EDUC-Q4 Other specify
        - id: q_educ_q4_other
          kind: Question
          title: "Please specify the highest level of education attained."
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
            - predicate: q_educ_q3.outcome == 1
            - predicate: q_educ_q4.outcome == 10
          input:
            control: Textarea
            placeholder: "Specify education level..."

        # EDUC-Q5 / EDC4_1: Currently attending school
        # Skipped if: age >= 65, or Q1 issues, or Q3 = DK/R (3)
        # No (2) or DK/R (3) -> skip Q6
        - id: q_educ_q5
          kind: Question
          title: "Are/Is ... currently attending a school, college or university?"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
            - predicate: q_educ_q3.outcome != 3
            - predicate: age < 65
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # EDUC-Q6 / EDC4_2: Full-time or part-time enrollment
        # Only if Q5 = Yes (1)
        - id: q_educ_q6
          kind: Question
          title: "Are/Is ... enrolled as a full-time or part-time student?"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
            - predicate: q_educ_q3.outcome != 3
            - predicate: age < 65
            - predicate: q_educ_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"
