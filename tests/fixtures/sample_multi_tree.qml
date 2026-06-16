qmlVersion: "1.0"
questionnaire:
  title: "Sample Multi-Tree — contiguous-tree-block randomization (AE2)"
  blocks:
    - id: intro_block
      kind: Sequence
      title: "Intro"
      items:
        - id: q_consent
          kind: Question
          title: "Proceed?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # is_random=true Sample with TWO independent components in its
    # block-scoped dependency forest:
    #   - component [q_a → q_b]: q_b's precondition references q_a.outcome,
    #     so q_b depends on q_a → they form ONE component, intra-order fixed
    #     (q_a before q_b in every ordering).
    #   - component [q_c]: no dependency edge to q_a/q_b → its own component.
    # T = 2 → 2! = 2 distinct contiguous-block orderings:
    #   {q_a, q_b, q_c}  and  {q_c, q_a, q_b}
    # Both must validate; q_c stays contiguous; a-before-b preserved.
    - id: topic_sample
      kind: Sample
      title: "Topic battery"
      count: 3
      is_random: true
      items:
        - id: q_a
          kind: Question
          title: "Rate topic A"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_b
          kind: Question
          title: "Why that rating for A?"
          precondition:
            - predicate: "q_a.outcome >= 1"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_c
          kind: Question
          title: "Rate topic C"
          input:
            control: Slider
            min: 1
            max: 5
