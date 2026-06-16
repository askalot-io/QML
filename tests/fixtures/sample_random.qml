qmlVersion: "1.0"
questionnaire:
  title: "Sample Random — randomised order, N larger than item count"
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

    # is_random: true → per-execution randomised order (preserving dependencies).
    # count=5 deliberately exceeds the 2 inner items: this loads fine; the
    # "ask up to N" clamp is a U5 runtime concern, not a load-time error (AE1).
    - id: topic_sample
      kind: Sample
      title: "Random topics"
      count: 5
      is_random: true
      items:
        - id: q_topic_a
          kind: Question
          title: "Topic A interest"
          input:
            control: Slider
            min: 0
            max: 10
        - id: q_topic_b
          kind: Question
          title: "Topic B interest"
          input:
            control: Slider
            min: 0
            max: 10
