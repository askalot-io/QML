qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Section T: Language — Contact with Federal Government (English-Only)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {7}

    # Tracks whether respondent contacted any federal agency in T1
    any_federal_contact_t = 0

  blocks:
    # =========================================================================
    # BLOCK: SECTION T — Federal Government Contacts (English-only path)
    # =========================================================================
    # Routing summary:
    #   T1: 11-agency contact roster (QuestionGroup Switch)
    #       codeBlock sets any_federal_contact_t = count of agencies contacted
    #   T2: Service in English for all contacts? (Switch)
    #       Pre: any_federal_contact_t > 0
    #       Yes (1) → skip T3 → T4
    #       No  (0) → T3
    #   T3: Asked for English service per agency? (QuestionGroup Switch)
    #       Pre: T2 == 0 (not all in English)
    #   T4: Federal services available in English? (Radio)
    #   T5: TV watching — languages, most often, 90%
    #       q_t5_watch: Switch (watch TV?)
    #       q_t5_languages: Checkbox (which languages)
    #       q_t5_most_often: Radio (most often language)
    #       q_t5_ninety_pct: Switch (>90% one language?)
    #   T6: Doctor visit language (Radio)
    # =========================================================================
    - id: b_section_t
      title: "Language — Contact with Federal Government"
      precondition:
        - predicate: lang_path == 7
      items:
        # T1: Contact with federal agencies
        - id: qg_t1
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
            any_federal_contact_t = 0
            for i in range(11):
              any_federal_contact_t = any_federal_contact_t + qg_t1.outcome[i]
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T2: Service in English for all contacts?
        # Pre: at least one contact made
        # Yes (1) → skip T3, go to T4; No (0) → T3
        - id: q_t2
          kind: Question
          title: "Did you obtain service in English for all these contacts?"
          precondition:
            - predicate: any_federal_contact_t > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T3: Asked for English service per agency?
        # Pre: T2 == 0 (did NOT get English for all)
        # Only agencies where contact was made would be asked in the original;
        # modeled as full roster with block-level precondition from T2.
        - id: qg_t3
          kind: QuestionGroup
          title: "Did you ask for service in English at each of these agencies?"
          precondition:
            - predicate: any_federal_contact_t > 0
            - predicate: q_t2.outcome == 0
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
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T4: Federal services available in English?
        - id: q_t4
          kind: Question
          title: "Would you say that, in your area, federal services are generally available in English?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        # T5: Television watching languages
        # Decomposed into sub-questions:
        #   q_t5_watch: Do you watch television?
        #   q_t5_languages: In which languages?
        #   q_t5_most_often: Which language most often?
        #   q_t5_ninety_pct: More than 90% of the time?

        # T5a: Watch television?
        - id: q_t5_watch
          kind: Question
          title: "Do you watch television?"
          input:
            control: Switch
            off: "Never watch television"
            on: "Yes, I watch television"

        # T5b: Languages of television programs watched
        # Pre: watches TV
        - id: q_t5_languages
          kind: Question
          title: "In which languages are the television programs you watch?"
          precondition:
            - predicate: q_t5_watch.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # T5c: Most often language
        # Pre: watches TV
        - id: q_t5_most_often
          kind: Question
          title: "Which language do you watch most often?"
          precondition:
            - predicate: q_t5_watch.outcome == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # T5d: Watch in that language more than 90% of the time?
        # Pre: watches TV
        - id: q_t5_ninety_pct
          kind: Question
          title: "Do you watch programs in that language more than 90% of the time?"
          precondition:
            - predicate: q_t5_watch.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T6: Doctor visit language
        - id: q_t6
          kind: Question
          title: "Which language did the doctor use during your last visit?"
          input:
            control: Radio
            labels:
              1: "Never visited doctor"
              2: "English"
              3: "French"
              4: "Other"
