qmlVersion: "1.0"
questionnaire:
  title: "Sample Over Cap — > 7 independent components, is_random (AE4)"
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

    # is_random=true with EIGHT mutually-independent inner items. No item
    # references another, so the block-scoped dependency forest has T = 8
    # singleton components. 8 > SAMPLE_COMPONENT_CAP (7) → R9 validation-time
    # reject: a structured `sample_cap` coverage gap is recorded for
    # 'big_sample' and the block is NOT solved (no ordering enumerated). The
    # 8! = 40320 orderings are NEVER materialized — the gate is an int
    # comparison taken before any permutation.
    - id: big_sample
      kind: Sample
      title: "Too many independent topics"
      count: 4
      is_random: true
      items:
        - id: q_s1
          kind: Question
          title: "S1"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_s2
          kind: Question
          title: "S2"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_s3
          kind: Question
          title: "S3"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_s4
          kind: Question
          title: "S4"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_s5
          kind: Question
          title: "S5"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_s6
          kind: Question
          title: "S6"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_s7
          kind: Question
          title: "S7"
          input: { control: Slider, min: 1, max: 5 }
        - id: q_s8
          kind: Question
          title: "S8"
          input: { control: Slider, min: 1, max: 5 }
