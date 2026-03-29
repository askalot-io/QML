qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 (Children) — Section A: Filter Questions"
  codeInit: |
    limitation_general = 0

  blocks:
    - id: b_filter_questions
      title: "Filter Questions"
      items:
        - id: q_a1
          kind: Question
          title: "Does ..... have any DIFFICULTY hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"

        - id: q_a2a
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do at home?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"

        - id: q_a2b
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do at work or at school?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"
              5: "Not applicable"

        - id: q_a2c
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do in other activities, for example, transportation or leisure?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"
          codeBlock: |
            if q_a1.outcome == 1 or q_a1.outcome == 2:
                limitation_general = 1
            if q_a2a.outcome == 1 or q_a2a.outcome == 2:
                limitation_general = 1
            if q_a2b.outcome == 1 or q_a2b.outcome == 2:
                limitation_general = 1
            if q_a2c.outcome == 1 or q_a2c.outcome == 2:
                limitation_general = 1
