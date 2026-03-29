qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Contact with Federal Government (Section R)"
  codeInit: |
    # Extern variable: multilingual path indicator from Section F
    lang_path: {1, 2, 3, 4, 5, 6}

    # Computed variable: count of federal agencies contacted
    any_federal_contact = 0

  blocks:
    # =========================================================================
    # BLOCK 1: FEDERAL AGENCY CONTACT ROSTER
    # =========================================================================
    # R1: Have you talked with employees of 11 federal agencies?
    # Modeled as a QuestionGroup with 11 Switch sub-questions (Yes/No per
    # agency). A codeBlock counts how many agencies had contact.
    #
    # R2-R5: Per-agency follow-up (language of service, preferred language,
    # did you ask). The original instrument repeats R2-R5 for each agency
    # where R1=Yes. QML cannot dynamically show questions per roster row,
    # so R2-R5 are modeled as QuestionGroups covering all 11 agencies.
    # The respondent answers only for agencies they contacted; unused
    # rows default to the initial value.
    # =========================================================================
    - id: b_federal_contacts
      title: "Contact with Federal Government"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # R1: Contact with each federal agency (11 agencies)
        - id: qg_r1
          kind: QuestionGroup
          title: "During this period, have you talked with employees of the following federal agencies in connection with the services they provide?"
          questions:
            - "Post Office (excluding letter carriers)"
            - "Canada Employment or Immigration Centres"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs at border crossings only"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          codeBlock: |
            any_federal_contact = 0
            for i in range(11):
              if qg_r1.outcome[i] == 1:
                any_federal_contact = any_federal_contact + 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # R2: Language of service (per agency contacted)
        # Asked only if at least one agency was contacted.
        - id: qg_r2
          kind: QuestionGroup
          title: "In your last contact with each agency, in which language did you obtain service?"
          precondition:
            - predicate: any_federal_contact > 0
          questions:
            - "Post Office"
            - "Canada Employment or Immigration"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # R3: Was this your preferred language? (per agency contacted)
        - id: qg_r3
          kind: QuestionGroup
          title: "Was this your preferred language?"
          precondition:
            - predicate: any_federal_contact > 0
          questions:
            - "Post Office"
            - "Canada Employment or Immigration"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # R4: Preferred language (per agency where R3 = No)
        # NOTE: The original instrument asks R4 only for agencies where
        # R3=No. QML QuestionGroup shows all rows unconditionally. This
        # is a known simplification; the respondent should answer only
        # for agencies where they did not receive preferred language.
        - id: qg_r4
          kind: QuestionGroup
          title: "What was your preferred language? (Answer for each agency where service was not in your preferred language)"
          precondition:
            - predicate: any_federal_contact > 0
          questions:
            - "Post Office"
            - "Canada Employment or Immigration"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # R5: Did you ask for service in that language? (per agency where R3 = No)
        - id: qg_r5
          kind: QuestionGroup
          title: "Did you ask for service in that language? (Answer for each agency where service was not in your preferred language)"
          precondition:
            - predicate: any_federal_contact > 0
          questions:
            - "Post Office"
            - "Canada Employment or Immigration"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: GENERAL LANGUAGE QUESTIONS
    # =========================================================================
    # R6: Federal services availability in preferred official language
    # R7: TV watching languages (multi-select with most-often and 90%)
    # R8: Doctor language
    # =========================================================================
    - id: b_general_language
      title: "General Language Questions"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # R6: Federal services available in preferred language
        - id: q_r6
          kind: Question
          title: "Would you say that, in your area, federal services are generally available in your preferred official language?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        # R7: TV watching languages
        - id: q_r7
          kind: Question
          title: "In which languages are the television programs you watch?"
          input:
            control: Checkbox
            labels:
              1: "Never watch television"
              2: "English"
              4: "French"
              8: "Other"

        # R7_most: Most often watched language
        - id: q_r7_most
          kind: Question
          title: "In which language do you watch television most often?"
          precondition:
            - predicate: q_r7.outcome % 2 == 0
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # R7_90: Watch most-often language more than 90%?
        - id: q_r7_90
          kind: Question
          title: "Do you watch programs in this language more than 90% of the time?"
          precondition:
            - predicate: q_r7.outcome % 2 == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # R8: Doctor language
        - id: q_r8
          kind: Question
          title: "Which language did the doctor use during your last visit?"
          input:
            control: Radio
            labels:
              1: "Never visited doctor"
              2: "English"
              3: "French"
              4: "Other"
