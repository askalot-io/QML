questionnaire:
  title: "Quality Scorecard - Inverted Authoring Order"
  blocks:
    - id: main
      title: "Main"
      items:
        # Authored FIRST but depends on q_gate (authored later) — the stable
        # topological sort delivers q_gate before q_detail, producing a
        # detectable inversion for the D6 order-coherence metric.
        - id: q_detail
          kind: Question
          title: "How many hours per week do you work?"
          precondition:
            - predicate: "q_gate.outcome == 1"
              hint: "Shown when employed"
          input:
            control: Editbox
            min: 0
            max: 100
        - id: q_gate
          kind: Question
          title: "Are you currently employed?"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
        - id: q_closing
          kind: Question
          title: "How satisfied are you overall?"
          input:
            control: Radio
            labels:
              1: Satisfied
              2: Neutral
              3: Dissatisfied
