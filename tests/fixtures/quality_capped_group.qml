questionnaire:
  title: "Quality Scorecard - Capped Group Burden"
  blocks:
    - id: intro
      title: "Intro"
      items:
        - id: q_consent
          kind: Question
          title: "Do you agree to participate?"
          input:
            control: Radio
            labels:
              1: Yes
              2: No
    # count: 2 caps the draw — D8's worst case must take the two costliest
    # members (Textarea 3 + Radio 1 = 4), not all three (5). Inner items are
    # independent per the capped-Group rule.
    - id: topics
      kind: Group
      count: 2
      title: "Topics"
      items:
        - id: q_topic_open
          kind: Question
          title: "Describe your main concern"
          input:
            control: Textarea
        - id: q_topic_a
          kind: Question
          title: "Rate topic A"
          input:
            control: Radio
            labels:
              1: Low
              2: High
        - id: q_topic_b
          kind: Question
          title: "Rate topic B"
          input:
            control: Radio
            labels:
              1: Low
              2: High
