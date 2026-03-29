qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section D: Tenure"

  codeInit: |
    # Extern from Section A: whether household has a spouse
    has_spouse: {0, 1}

    # Routing variables for this section
    moved_in_2000 = 0
    moved_before_1995 = 0
    prev_owned = 0

  blocks:
    # =========================================================================
    # BLOCK: TENURE AND PREVIOUS DWELLING (Section D)
    # =========================================================================
    # D_Q01: tenure type, D_Q02: year moved, D_Q03-Q04: previous dwelling,
    # D_Q05-Q05.1: 52-week check, D_Q06.1-Q06.4: previous dwelling types,
    # D_Q07.1-Q07.4: disposition of previously owned dwellings.
    #
    # Key routing:
    #   D_Q02 < 1995 -> skip D_Q03 onward (go to Section E instructions)
    #   D_Q04 gated on has_spouse
    #   D_Q05 gated on moved_in_2000
    #   D_Q06.x gated on D_Q05=Yes or D_Q05.1=Yes
    #   D_Q07.x gated on D_Q06.1=Yes or D_Q06.2=Yes (previously owned)
    # =========================================================================
    - id: b_tenure
      title: "Tenure"
      items:
        # D_Q01: Dwelling tenure status
        - id: q_d_q01
          kind: Question
          title: "On December 31, 2000 was your dwelling:"
          input:
            control: Radio
            labels:
              1: "Owned without mortgage"
              2: "Owned with mortgage(s)"
              3: "Rented"
              4: "Occupied rent-free"

        # D_Q02: Year moved to this dwelling
        - id: q_d_q02
          kind: Question
          title: "In what year did your household move to this dwelling?"
          input:
            control: Editbox
            min: 1900
            max: 2001
          codeBlock: |
            if q_d_q02.outcome < 1995:
                moved_before_1995 = 1
            if q_d_q02.outcome == 2000:
                moved_in_2000 = 1

        # D_Q03: Reference person's previous dwelling
        # Skipped if moved before 1995
        - id: q_d_q03
          kind: Question
          title: "Did the reference person own or rent their previous dwelling?"
          precondition:
            - predicate: moved_before_1995 == 0
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"
              3: "Did not maintain their own dwelling"

        # D_Q04: Spouse's previous dwelling
        # Gated on having a spouse AND not moved before 1995
        - id: q_d_q04
          kind: Question
          title: "Did the spouse of the reference person own or rent their previous dwelling?"
          precondition:
            - predicate: moved_before_1995 == 0
            - predicate: has_spouse == 1
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"
              3: "Did not maintain their own dwelling"

        # D_Q05: 52-week check
        # Gated on moved in 2000
        - id: q_d_q05
          kind: Question
          title: "Did anyone in this household report TOTAL WEEKS equal to 52? (Section A, Q.9 plus Q.10)"
          precondition:
            - predicate: moved_in_2000 == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q05.1: Lived in another dwelling
        # Gated on D_Q05 = No
        - id: q_d_q05_1
          kind: Question
          title: "For the total weeks reported earlier, did anyone live in another dwelling?"
          precondition:
            - predicate: q_d_q05.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q06.1: Previously owned with mortgage
        # Gated on D_Q05=Yes OR D_Q05.1=Yes
        - id: q_d_q06_1
          kind: Question
          title: "Were any previously occupied dwellings in 2000: Owned with mortgage(s)?"
          precondition:
            - predicate: q_d_q05.outcome == 1 or q_d_q05_1.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q06.2: Previously owned without mortgage
        - id: q_d_q06_2
          kind: Question
          title: "Were any previously occupied dwellings in 2000: Owned without a mortgage?"
          precondition:
            - predicate: q_d_q05.outcome == 1 or q_d_q05_1.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q06.3: Previously rented
        - id: q_d_q06_3
          kind: Question
          title: "Were any previously occupied dwellings in 2000: Rented?"
          precondition:
            - predicate: q_d_q05.outcome == 1 or q_d_q05_1.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q06.4: Previously occupied rent-free
        - id: q_d_q06_4
          kind: Question
          title: "Were any previously occupied dwellings in 2000: Occupied rent-free?"
          precondition:
            - predicate: q_d_q05.outcome == 1 or q_d_q05_1.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.1: Previously owned dwelling - Sold?
        # Gated on D_Q06.1=Yes OR D_Q06.2=Yes
        - id: q_d_q07_1
          kind: Question
          title: "Were any previously owned dwellings in 2000: Sold?"
          precondition:
            - predicate: q_d_q06_1.outcome == 1 or q_d_q06_2.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.2: Rented to others
        - id: q_d_q07_2
          kind: Question
          title: "Were any previously owned dwellings in 2000: Rented to others?"
          precondition:
            - predicate: q_d_q06_1.outcome == 1 or q_d_q06_2.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.3: Left vacant
        - id: q_d_q07_3
          kind: Question
          title: "Were any previously owned dwellings in 2000: Left vacant?"
          precondition:
            - predicate: q_d_q06_1.outcome == 1 or q_d_q06_2.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.4: Other disposition
        - id: q_d_q07_4
          kind: Question
          title: "Were any previously owned dwellings in 2000: Other?"
          precondition:
            - predicate: q_d_q06_1.outcome == 1 or q_d_q06_2.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.4 specify
        - id: q_d_q07_4_specify
          kind: Question
          title: "Please specify the other disposition."
          precondition:
            - predicate: q_d_q07_4.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify other disposition..."

        # D_INSTRUCTIONS: Read instructions for expenditure questions
        - id: q_d_instructions
          kind: Comment
          title: "Instructions for the Expenditure Questions: Report expenditures for part-year members according to the data collection code. Follow expenditure reporting rules and insurance settlement guidelines."
