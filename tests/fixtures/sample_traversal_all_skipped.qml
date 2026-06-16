qmlVersion: "1.0"
questionnaire:
  title: "Sample Traversal — every inner item precondition-skipped"
  blocks:
    - id: gate_block
      kind: Sequence
      title: "Gate"
      items:
        - id: q_gate
          kind: Question
          title: "Pick a gate value"
          input:
            control: Editbox
            min: 0
            max: 100

    # count=2, but every inner item's precondition is unsatisfiable when
    # q_gate == 0. The whole pass completes with zero asked; the block must
    # behave like a Roster empty pass (skip silently, do NOT mark visited,
    # preserve last-visited recap).
    - id: skip_sample
      kind: Sample
      title: "All gated"
      count: 2
      is_random: false
      items:
        - id: q_g1
          kind: Question
          title: "Gated one"
          input:
            control: Slider
            min: 0
            max: 5
          precondition:
            - predicate: "q_gate.outcome >= 50"
              hint: "Only if gate high"
        - id: q_g2
          kind: Question
          title: "Gated two"
          input:
            control: Slider
            min: 0
            max: 5
          precondition:
            - predicate: "q_gate.outcome >= 50"
              hint: "Only if gate high"

    - id: tail_block
      kind: Sequence
      title: "Tail"
      items:
        - id: q_tail
          kind: Question
          title: "Tail item"
          input:
            control: Editbox
            min: 0
            max: 9
