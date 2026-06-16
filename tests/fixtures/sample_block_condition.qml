qmlVersion: "1.0"
questionnaire:
  title: "Sample Block Condition — block pre/postcondition composition"
  blocks:
    - id: gate_block
      kind: Sequence
      title: "Gate"
      items:
        - id: q_gate
          kind: Question
          title: "Eligible? (1=yes)"
          input:
            control: Editbox
            min: 0
            max: 1

    # Block-level precondition gates the WHOLE Sample block: when
    # q_gate.outcome == 0 no inner Sample constraint applies. Block-level
    # postcondition applies to DRAWN items only (present-gated like every
    # other inner constraint). is_random=false → single canonical order
    # (R10). Two independent inner items.
    - id: gated_sample
      kind: Sample
      title: "Gated battery"
      count: 2
      is_random: false
      precondition:
        - predicate: "q_gate.outcome == 1"
          hint: "Block only for eligible respondents"
      postcondition:
        - predicate: "True"
          hint: "Trivially-true block postcondition (drawn items only)"
      items:
        - id: q_p
          kind: Question
          title: "P"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_q
          kind: Question
          title: "Q"
          input:
            control: Slider
            min: 1
            max: 5
