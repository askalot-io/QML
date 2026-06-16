qmlVersion: "1.0"
questionnaire:
  title: "Sample Traversal — is_random, two trees, intra-tree order fixed"
  blocks:
    - id: intro_block
      kind: Sequence
      title: "Intro"
      items:
        - id: q_warmup
          kind: Question
          title: "How are you today?"
          input:
            control: Slider
            min: 1
            max: 5

    # is_random: true, count=5 (>= pool of 4) so all eligible are asked but the
    # ORDER is the variable under test. Two independent components:
    #   tree A: q_a1 -> q_a2 (q_a2 precondition references q_a1.outcome, so an
    #           item->item dependency edge fixes a1-before-a2 intra-tree)
    #   tree B: q_b1 -> q_b2 (same shape)
    # The two trees are permuted as contiguous blocks; intra-tree order is the
    # topology's fixed Kahn linearization. Frozen per execution.
    - id: topic_sample
      kind: Sample
      title: "Random topics"
      count: 5
      is_random: true
      items:
        - id: q_a1
          kind: Question
          title: "Tree A — first"
          input:
            control: Slider
            min: 0
            max: 10
        - id: q_a2
          kind: Question
          title: "Tree A — second (depends on A1)"
          input:
            control: Slider
            min: 0
            max: 10
          precondition:
            - predicate: "q_a1.outcome >= 0"
              hint: "A1 answered"
        - id: q_b1
          kind: Question
          title: "Tree B — first"
          input:
            control: Slider
            min: 0
            max: 10
        - id: q_b2
          kind: Question
          title: "Tree B — second (depends on B1)"
          input:
            control: Slider
            min: 0
            max: 10
          precondition:
            - predicate: "q_b1.outcome >= 0"
              hint: "B1 answered"

    - id: outro_block
      kind: Sequence
      title: "Outro"
      items:
        - id: q_done
          kind: Question
          title: "Done?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
