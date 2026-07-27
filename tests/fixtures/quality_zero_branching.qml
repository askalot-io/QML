questionnaire:
  title: "Quality Scorecard - Zero Branching"
  blocks:
    - id: main
      title: "Main"
      items:
        # No preconditions, no postconditions, no variables: every respondent
        # answers everything. Sound per Z3, but D5 (no decision points) and
        # D7 (no tailoring) must grade weak.
        - id: q_one
          kind: Question
          title: "Question one?"
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_two
          kind: Question
          title: "Question two?"
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_three
          kind: Question
          title: "Question three?"
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_four
          kind: Question
          title: "Question four?"
          input:
            control: Radio
            labels:
              1: A
              2: B
