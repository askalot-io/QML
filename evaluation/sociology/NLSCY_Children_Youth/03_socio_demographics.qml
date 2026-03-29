qmlVersion: "1.0"
questionnaire:
  title: "NLSCY - Socio-demographic Characteristics"
  codeInit: |
    # No cross-section variables needed
    # No computed variables needed — all routing uses q_item.outcome directly

  blocks:
    # =========================================================================
    # INTRODUCTION
    # =========================================================================
    - id: b_socio_intro
      title: "Socio-demographic Characteristics"
      items:
        # SOCIO-INT: Section introduction
        - id: q_socio_int
          kind: Comment
          title: "Now I'd like to ask some general background questions."

    # =========================================================================
    # COUNTRY OF BIRTH AND IMMIGRATION
    # =========================================================================
    # Q1 -> (if not Canada) Q2a -> (if not citizen by birth) Q2b -> (if Yes) Q3
    # =========================================================================
    - id: b_socio_birth
      title: "Country of Birth and Immigration"
      items:
        # SOCIO-Q1: Country of birth
        # If CANADA (1) -> GO TO NEXT SECTION (skip all remaining socio questions)
        - id: q_socio_q1
          kind: Question
          title: "In what country were/was ... born?"
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

        # SOCIO-Q1 Other specify
        - id: q_socio_q1_other
          kind: Question
          title: "Please specify the country of birth."
          precondition:
            - predicate: q_socio_q1.outcome == 19
          input:
            control: Textarea
            placeholder: "Specify country..."

        # SOCIO-Q2a: Citizenship
        # If CANADA, CITIZEN BY BIRTH (1) -> GO TO NEXT SECTION
        - id: q_socio_q2a
          kind: Question
          title: "Of what country are/is ... a citizen?"
          precondition:
            - predicate: q_socio_q1.outcome != 1
          input:
            control: Checkbox
            labels:
              1: "Canada, citizen by birth"
              2: "Canada, by naturalization"
              4: "Same as country of birth"
              8: "Other country"

        # SOCIO-Q2b: Landed immigrant status
        # Asked only if not born in Canada AND not citizen by birth
        # Citizen by birth = bit 0 (value 1) selected -> q_socio_q2a.outcome % 2 == 1
        - id: q_socio_q2b
          kind: Question
          title: "Are/Is ... now, or have/has ... ever been a landed immigrant?"
          precondition:
            - predicate: q_socio_q1.outcome != 1
            - predicate: q_socio_q2a.outcome % 2 == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # SOCIO-Q3: Immigration year
        # Asked only if landed immigrant (Q2b = Yes)
        - id: q_socio_q3
          kind: Question
          title: "In what year did ... first immigrate to Canada?"
          precondition:
            - predicate: q_socio_q1.outcome != 1
            - predicate: q_socio_q2a.outcome % 2 == 0
            - predicate: q_socio_q2b.outcome == 1
          input:
            control: Editbox
            min: 1900
            max: 2026

    # =========================================================================
    # ETHNICITY
    # =========================================================================
    # Q4: Mark all that apply (19 groups + Other specify)
    # No skip logic — always asked regardless of Q1
    # =========================================================================
    - id: b_socio_ethnicity
      title: "Ethnicity"
      items:
        # SOCIO-Q4: Ethnic/cultural groups
        - id: qg_socio_q4
          kind: QuestionGroup
          title: "To which ethnic or cultural group(s) did your/...'s ancestors belong? (For example: French, British, Chinese)"
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
            - "Other"
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
    # LANGUAGES
    # =========================================================================
    # Q5: Languages for conversation (mark all)
    # Q6: Mother tongue (mark all)
    # =========================================================================
    - id: b_socio_languages
      title: "Languages"
      items:
        # SOCIO-Q5: Languages for conversation
        - id: qg_socio_q5
          kind: QuestionGroup
          title: "In what language(s) can ... conduct a conversation?"
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
            - "Other"
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

        # SOCIO-Q6: Mother tongue
        - id: qg_socio_q6
          kind: QuestionGroup
          title: "What is the language that ... first learned at home in childhood and can still understand? (If ... can no longer understand the first language learned, choose the second language learned.)"
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
            - "Other"
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
    # RELIGION
    # =========================================================================
    # Q8: Religion. If NO RELIGION (1) -> GO TO NEXT SECTION (skip Q9)
    # Q9: Religious attendance — only if has a religion
    # =========================================================================
    - id: b_socio_religion
      title: "Religion"
      items:
        # SOCIO-Q8: Religion
        - id: q_socio_q8
          kind: Question
          title: "What, if any, is your/...'s religion?"
          input:
            control: Dropdown
            labels:
              1: "No religion"
              2: "Roman Catholic"
              3: "United Church"
              4: "Anglican"
              5: "Presbyterian"
              6: "Lutheran"
              7: "Baptist"
              8: "Eastern Orthodox"
              9: "Jewish"
              10: "Islam (Muslim)"
              11: "Buddhist"
              12: "Hindu"
              13: "Sikh"
              14: "Jehovah's Witness"
              15: "Other (specify)"

        # SOCIO-Q8 Other specify
        - id: q_socio_q8_other
          kind: Question
          title: "Please specify the religion."
          precondition:
            - predicate: q_socio_q8.outcome == 15
          input:
            control: Textarea
            placeholder: "Specify religion..."

        # SOCIO-Q9: Religious attendance
        # Skipped if NO RELIGION (Q8 = 1)
        - id: q_socio_q9
          kind: Question
          title: "Other than on special occasions (such as weddings, funerals or baptisms), how often did ... attend religious services or meetings in the past 12 months?"
          precondition:
            - predicate: q_socio_q8.outcome != 1
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least 3 or 4 times a year"
              4: "At least once a year"
              5: "Not at all"
