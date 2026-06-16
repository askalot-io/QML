qmlVersion: "1.0"
questionnaire:
  title: "Sample Traversal — N=3, five eligible, two precondition-gated"
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

    # count=3, is_random false (declared topological order). Two inner items
    # carry preconditions referencing the OUTER q_age. Precondition-skipped
    # items do NOT consume an N slot (R2 / AE1): with q_age >= 18 all five are
    # eligible → exactly 3 asked (declared order). With q_age < 18 only three
    # are eligible (two skipped) → still 3 asked. With q_age < 13 only one is
    # eligible → exactly 1 asked, not an error.
    - id: lifestyle_sample
      kind: Sample
      title: "Lifestyle questions"
      count: 3
      is_random: false
      items:
        - id: q_s1
          kind: Question
          title: "Sleep hours?"
          input:
            control: Slider
            min: 0
            max: 12
        - id: q_s2
          kind: Question
          title: "Alcohol units per week (adults only)?"
          input:
            control: Editbox
            min: 0
            max: 100
          precondition:
            - predicate: "q_age.outcome >= 18"
              hint: "Adults only"
        - id: q_s3
          kind: Question
          title: "Exercise sessions per week?"
          input:
            control: Slider
            min: 0
            max: 7
        - id: q_s4
          kind: Question
          title: "Screen time hours (teens+)?"
          input:
            control: Slider
            min: 0
            max: 24
          precondition:
            - predicate: "q_age.outcome >= 13"
              hint: "13 and older"
        - id: q_s5
          kind: Question
          title: "Coffee cups per day?"
          input:
            control: Editbox
            min: 0
            max: 30

    - id: outro_block
      kind: Sequence
      title: "Outro"
      items:
        - id: q_thanks
          kind: Question
          title: "Anything else to add?"
          input:
            control: Textarea
