qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Neighbourhood Safety"

  blocks:
    # =========================================================================
    # BLOCK 1: NEIGHBOURHOOD SAFETY (SAF)
    # =========================================================================
    # SAF-C1: "IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD
    #          MEMBER → SKIP" — system-level check; modeled as always shown.
    # SAF-Q2 option 9 (REFUSAL) and SAF-Q3 option 9 (REFUSAL) trigger
    # GO TO NEXT SECTION in the original CATI. Modeled by excluding DK/REF
    # options: respondents who refuse simply don't continue, and downstream
    # items have no precondition gating (straightforward sequential flow).
    # =========================================================================
    - id: b_neighbourhood
      title: "Neighbourhood Safety"
      items:
        # SAF-C1: System-level check — modeled as introductory comment
        - id: q_saf_c1
          kind: Comment
          title: "This section asks questions about your neighbourhood."

        # SAF-Q1: Years at current address
        - id: q_saf_q1
          kind: Question
          title: "How many years have you lived at this address? (Enter 0 if less than 1 year.)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years"

        # SAF-Q2: Neighbourhood as place for children
        - id: q_saf_q2
          kind: Question
          title: "How do you feel about your neighbourhood as a place to bring up children? Is it..."
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Good"
              3: "Average"
              4: "Poor"
              5: "Very poor"

        # SAF-Q3: Involvement in voluntary organizations
        - id: q_saf_q3
          kind: Question
          title: "Are you involved in any local voluntary organizations such as school groups, church groups, community or ethnic associations?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SAF-I5A / Q5A-Q5C: Safety perceptions (4-point agree/disagree)
        - id: qg_saf_q5
          kind: QuestionGroup
          title: "Please tell me whether you strongly agree, agree, disagree, or strongly disagree with these statements about your neighbourhood."
          questions:
            - "(a) It is safe to walk alone in this neighbourhood after dark."
            - "(b) It is safe for children to play outside during the day."
            - "(c) There are good parks, playgrounds and play spaces in this neighbourhood."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # SAF-I6A / Q6A-Q6E: Social cohesion (4-point agree/disagree)
        - id: qg_saf_q6
          kind: QuestionGroup
          title: "The following statements are about people in your neighbourhood. Please tell me whether you strongly agree, agree, disagree, or strongly disagree."
          questions:
            - "(a) If there is a problem around here, the neighbours get together to deal with it."
            - "(b) There are adults in the neighbourhood that children can look up to."
            - "(c) People around here are willing to help their neighbours."
            - "(d) You can count on adults in this neighbourhood to watch out that children are safe and don't get in trouble."
            - "(e) When I'm away from home, I know that my neighbours will keep their eyes open for possible trouble."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # SAF-I7A / Q7A-Q7F: Neighbourhood problems (3-point scale)
        - id: qg_saf_q7
          kind: QuestionGroup
          title: "How much of a problem is each of the following in this neighbourhood?"
          questions:
            - "(a) Litter, broken glass or garbage in the street or road, on the sidewalk, or in yards."
            - "(b) Selling or using drugs."
            - "(c) Alcoholics and excessive drinking in public."
            - "(d) Groups of young people who cause trouble."
            - "(e) Burglary of homes and apartments."
            - "(f) Unrest due to ethnic or religious differences."
          input:
            control: Radio
            labels:
              1: "A big problem"
              2: "Somewhat of a problem"
              3: "No problem"
