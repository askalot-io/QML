qmlVersion: "1.0"
questionnaire:
  title: "Sample No-Random Many — 20 independent items, no cap (AE5)"
  blocks:
    - id: intro_block
      kind: Sequence
      title: "Intro"
      items:
        - id: q_start
          kind: Question
          title: "Begin?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # is_random=false with 20 mutually-independent inner items. T = 20
    # singleton components, but R10 applies: is_random=false → NO enumeration,
    # NO cap. Exactly ONE canonical order (k=0); all 20 items
    # conditionally-present. Accepted even though 20 > 7 (the cap is
    # is_random-only).
    - id: many_sample
      kind: Sample
      title: "Twenty independent topics"
      count: 5
      is_random: false
      items:
        - id: q_n1
          kind: Question
          title: "Item 1"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n2
          kind: Question
          title: "Item 2"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n3
          kind: Question
          title: "Item 3"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n4
          kind: Question
          title: "Item 4"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n5
          kind: Question
          title: "Item 5"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n6
          kind: Question
          title: "Item 6"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n7
          kind: Question
          title: "Item 7"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n8
          kind: Question
          title: "Item 8"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n9
          kind: Question
          title: "Item 9"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n10
          kind: Question
          title: "Item 10"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n11
          kind: Question
          title: "Item 11"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n12
          kind: Question
          title: "Item 12"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n13
          kind: Question
          title: "Item 13"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n14
          kind: Question
          title: "Item 14"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n15
          kind: Question
          title: "Item 15"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n16
          kind: Question
          title: "Item 16"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n17
          kind: Question
          title: "Item 17"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n18
          kind: Question
          title: "Item 18"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n19
          kind: Question
          title: "Item 19"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_n20
          kind: Question
          title: "Item 20"
          input: { control: Slider, min: 1, max: 5 }
