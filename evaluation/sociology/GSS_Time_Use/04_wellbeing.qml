qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Well-being (Section E)"

  # No extern variables needed; no routing into or within this section.
  # All 11 items are shown to every respondent unconditionally.

  blocks:
    # =========================================================================
    # BLOCK: WELL-BEING
    # =========================================================================
    # E1: General happiness
    # E2a-E2i: Satisfaction across 9 life domains
    # E3: Overall life satisfaction
    # No routing/preconditions — all items shown to everyone.
    # =========================================================================
    - id: b_wellbeing
      title: "Well-being"
      items:
        # E1: General happiness
        - id: q_e1
          kind: Question
          title: "Presently, would you describe yourself as..."
          input:
            control: Radio
            labels:
              1: "Very happy"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Very unhappy"
              5: "No opinion"

        # E2a: Satisfaction — health
        - id: q_e2a
          kind: Question
          title: "I am going to ask you to rate certain areas of your life. Please rate your feelings about them as very satisfied, somewhat satisfied, somewhat dissatisfied or very dissatisfied. Your health:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2b: Satisfaction — job or main activity
        - id: q_e2b
          kind: Question
          title: "Your job or main activity:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2c: Satisfaction — spare time
        - id: q_e2c
          kind: Question
          title: "The way you spend your other time:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2d: Satisfaction — finances
        - id: q_e2d
          kind: Question
          title: "Your finances:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2e: Satisfaction — housing
        - id: q_e2e
          kind: Question
          title: "Your housing:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2f: Satisfaction — friendships
        - id: q_e2f
          kind: Question
          title: "Your friendships:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2g: Satisfaction — living partner or single status
        - id: q_e2g
          kind: Question
          title: "Living partner or single status:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2h: Satisfaction — family relationships
        - id: q_e2h
          kind: Question
          title: "Your relationship with other family members:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2i: Satisfaction — self-esteem
        - id: q_e2i
          kind: Question
          title: "Yourself (self-esteem):"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E3: Overall life satisfaction
        - id: q_e3
          kind: Question
          title: "Now, using the same scale, how do you feel about your life as a whole right now?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"
