qmlVersion: "1.0"
questionnaire:
  title: "Sample Single Component — is_random with one component"
  blocks:
    - id: intro_block
      kind: Sequence
      title: "Intro"
      items:
        - id: q_init
          kind: Question
          title: "Init?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # is_random=true but ONE connected component: q_d2 depends on q_d1 (its
    # precondition references q_d1.outcome), so the block-scoped forest has
    # T = 1. T <= 1 short-circuits the permutation branch → exactly ONE
    # ordering, behaving identically to is_random=false (edge case).
    - id: chain_sample
      kind: Sample
      title: "Dependent pair"
      count: 2
      is_random: true
      items:
        - id: q_d1
          kind: Question
          title: "D1"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_d2
          kind: Question
          title: "D2 (depends on D1)"
          precondition:
            - predicate: "q_d1.outcome >= 1"
          input:
            control: Slider
            min: 1
            max: 5
