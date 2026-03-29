qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Two-Week Disability"

  codeInit: |
    # No cross-section variables for this section

  blocks:
    # =========================================================================
    # TWO-WEEK DISABILITY
    # =========================================================================
    # TWOWK-INT -> TWOWK-Q1 -> TWOWK-Q2 -> TWOWK-Q3 -> TWOWK-Q4 -> TWOWK-Q5
    #
    # Routing summary:
    #   Q1: Yes -> Q2, No -> Q3, DK/R -> Q5
    #   Q2: If 14 days -> Q5, else -> Q3  (DK/R -> Q5)
    #   Q3: Yes -> Q4, No -> Q5, DK/R -> Q5
    #   Q4: -> Q5
    #   Q5: always asked
    #
    # DK/R general rule (TWOWK-END check): DK and R are allowed on every
    # question throughout the General Component (Form H05). Modelled by
    # routing only the primary (non-DK/R) path via preconditions.
    # =========================================================================
    - id: b_two_week_disability
      title: "Two-Week Disability"
      items:
        # TWOWK-INT: Interviewer introduction
        - id: q_twowk_int
          kind: Comment
          title: "The first few questions ask about ...(r/'s) health during the past 14 days."

        # TWOWK-Q1 / TWC4_1
        - id: q_twowk_q1
          kind: Question
          title: "It is important for you to refer to the 14-day period from %2WKSAGO% to %YESTERDAY%. During that period, did ... stay in bed at all because of illness or injury including any nights spent as a patient in a hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              0: "No"

        # TWOWK-Q2 / TWC4_2
        # Asked only when Q1 = Yes (stayed in bed).
        # Routing: If = 14 days --> GO TO TWOWK-Q5; DK/R --> GO TO TWOWK-Q5
        - id: q_twowk_q2
          kind: Question
          title: "How many days did ... stay in bed for all or most of the day? (Enter 0 if less than a day.)"
          precondition:
            - predicate: q_twowk_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 14

        # TWOWK-Q3 / TWC4_3
        # Asked when NOT (stayed in bed all 14 days):
        #   - Q1 = No (did not stay in bed at all), OR
        #   - Q1 = Yes AND Q2 < 14 (stayed in bed but fewer than all 14 days)
        # Routing: Yes -> Q4, No -> Q5, DK/R -> Q5
        - id: q_twowk_q3
          kind: Question
          title: "(Not counting days spent in bed) During those 14 days, were there any days that ... cut down on things you/he/she normally do/does because of illness or injury?"
          precondition:
            - predicate: (q_twowk_q1.outcome == 0) or (q_twowk_q1.outcome == 1 and q_twowk_q2.outcome < 14)
          input:
            control: Radio
            labels:
              1: "Yes"
              0: "No"

        # TWOWK-Q4 / TWC4_4
        # Asked only when Q3 = Yes (cut down on activities).
        - id: q_twowk_q4
          kind: Question
          title: "How many days did ... cut down on things for all or most of the day? (Enter 0 if less than a day.)"
          precondition:
            - predicate: q_twowk_q3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 14

        # TWOWK-Q5 / TWC4_5
        # Always asked (no precondition).
        - id: q_twowk_q5
          kind: Question
          title: "Do(es) ... have a regular medical doctor?"
          input:
            control: Radio
            labels:
              1: "Yes"
              0: "No"

        # CHECK TWOWK-END: DK and R are allowed on every question throughout
        # the General Component (Form H05). No filtering action required here.
        - id: q_twowk_end
          kind: Comment
          title: "CHECK: DK and R are allowed on every question throughout the General Component (Form H05)."
