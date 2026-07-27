questionnaire:
  title: "Quality Scorecard - Runtime-Degraded Predicate"
  blocks:
    - id: main
      title: "Main"
      items:
        - id: q_start
          kind: Question
          title: "Choose a track"
          input:
            control: Radio
            labels:
              1: First
              2: Second
        # Subscript is outside the Z3-lowerable subset: the static validator
        # records a coverage gap and falls back to runtime enforcement — the
        # D4 verification-coverage dimension must count this as degraded.
        - id: q_degraded
          kind: Question
          title: "Track-dependent question"
          precondition:
            - predicate: "[1, 2][q_start.outcome - 1] == 1"
              hint: "First track only"
          input:
            control: Radio
            labels:
              1: A
              2: B
        - id: q_verified
          kind: Question
          title: "Statically verified question"
          precondition:
            - predicate: "q_start.outcome == 2"
              hint: "Second track only"
          input:
            control: Radio
            labels:
              1: A
              2: B
