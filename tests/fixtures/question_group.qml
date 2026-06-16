# Item-count fixture: one QuestionGroup, one standalone Question, and a Comment.
# TOP-LEVEL items each count as 1, regardless of kind; composites are NOT
# expanded into sub-questions (plan 2026-06-14-001 R7 / KTD3):
#   1 QuestionGroup (5 sub-questions) -> 1 item
#   1 Question                        -> 1 item
#   1 Comment                         -> 1 item
# Total expected top-level items: 3.
qmlVersion: "1.0"

questionnaire:
  title: "Question Group Item Count"

  blocks:
    - id: block1
      kind: Sequence
      title: "Satisfaction battery"
      items:
        - id: satisfaction
          kind: QuestionGroup
          title: "Rate your satisfaction with each aspect"
          questions:
            - "Pricing"
            - "Support"
            - "Reliability"
            - "Features"
            - "Documentation"
          input:
            control: Radio
            labels:
              1: "Poor"
              2: "Fair"
              3: "Good"
        - id: q_overall
          kind: Question
          title: "Overall, how likely are you to recommend us?"
          input:
            control: Slider
            min: 0
            max: 10
        - id: q_thanks
          kind: Comment
          title: "Thank you for completing this section."
