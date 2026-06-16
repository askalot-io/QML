qmlVersion: "1.0"
questionnaire:
  title: "Sample Basic — ask up to N, declared order"
  blocks:
    - id: intro_block
      kind: Sequence
      title: "Intro"
      items:
        - id: q_consent
          kind: Question
          title: "Do you consent to the brand block?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # Sample with count=2, is_random omitted → defaults to false (declared order).
    # Three eligible items; runtime asks up to 2 (U5 concern, not load-time).
    - id: brand_sample
      kind: Sample
      title: "Brand impressions"
      count: 2
      items:
        - id: q_brand_a
          kind: Question
          title: "Rate brand A"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_brand_b
          kind: Question
          title: "Rate brand B"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_brand_c
          kind: Question
          title: "Rate brand C"
          input:
            control: Slider
            min: 1
            max: 5
