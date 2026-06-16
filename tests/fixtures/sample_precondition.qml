qmlVersion: "1.0"
questionnaire:
  title: "Sample With Precondition — skips do not consume an N slot"
  blocks:
    - id: screen_block
      kind: Sequence
      title: "Screening"
      items:
        - id: q_age
          kind: Question
          title: "How old are you?"
          input:
            control: Editbox
            min: 0
            max: 120

    # count=2, is_random false (explicit). One inner item carries a precondition
    # referencing the OUTER q_age. Precondition-skipped items do NOT consume an
    # N slot (R2) — that semantic is enforced at runtime (U5); here we only
    # exercise that a Sample block with an inner precondition LOADS and that the
    # outer reference resolves into Sample context the same way it does for
    # Roster inner items.
    - id: lifestyle_sample
      kind: Sample
      title: "Lifestyle questions"
      count: 2
      is_random: false
      items:
        - id: q_exercise
          kind: Question
          title: "How often do you exercise?"
          input:
            control: Slider
            min: 0
            max: 7
        - id: q_alcohol
          kind: Question
          title: "Units of alcohol per week?"
          input:
            control: Editbox
            min: 0
            max: 100
          precondition:
            - predicate: "q_age.outcome >= 18"
              hint: "Alcohol question only for adults"
        - id: q_sleep
          kind: Question
          title: "Hours of sleep per night?"
          input:
            control: Slider
            min: 0
            max: 12
