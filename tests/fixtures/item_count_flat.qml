# Item-count fixture: a flat questionnaire of standalone Questions and a Comment.
# TOP-LEVEL items each count as 1, regardless of kind (plan 2026-06-14-001 R7 /
# KTD3):
#   3 Questions -> 3 items
#   1 Comment   -> 1 item
# Total expected top-level items: 4.
qmlVersion: "2.0"

questionnaire:
  title: "Flat Item Count"

  blocks:
    - id: block1
      kind: Group
      title: "Three simple questions"
      items:
        - id: q_age
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 18
            max: 120
        - id: q_gender
          kind: Question
          title: "What is your gender?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
              3: "Other"
        - id: q_recommend
          kind: Question
          title: "How likely are you to recommend us?"
          input:
            control: Slider
            min: 0
            max: 10
        - id: q_thanks
          kind: Comment
          title: "Thank you for participating."
