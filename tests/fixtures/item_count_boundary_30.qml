# Item-count boundary fixture: TOP-LEVEL items total EXACTLY 30 (the free-tier
# gate boundary, plan 2026-06-14-001 R7). Every item counts as 1, regardless of
# kind; composites are NOT expanded. Composition:
#   1 MatrixQuestion (3 rows x 4 columns) -> 1 item
#   1 QuestionGroup (5 sub-questions)     -> 1 item
#   1 Comment                             -> 1 item
#   27 standalone Questions               -> 27 items
#   Total                                 -> 30 top-level items
qmlVersion: "2.0"

questionnaire:
  title: "Boundary Thirty Items"

  blocks:
    - id: block1
      kind: Group
      title: "Thirty top-level items of mixed kinds"
      items:
        - id: matrix1
          kind: MatrixQuestion
          title: "Rate each brand on each dimension"
          rows:
            - "Brand A"
            - "Brand B"
            - "Brand C"
          columns:
            - "Quality"
            - "Value"
            - "Trust"
            - "Service"
          input:
            control: Dropdown
            labels:
              1: "Low"
              2: "Medium"
              3: "High"
        - id: group1
          kind: QuestionGroup
          title: "Rate satisfaction with each feature"
          questions:
            - "Feature 1"
            - "Feature 2"
            - "Feature 3"
            - "Feature 4"
            - "Feature 5"
          input:
            control: Radio
            labels:
              1: "Unhappy"
              2: "Neutral"
              3: "Happy"
        - id: c1
          kind: Comment
          title: "A short note before the remaining questions."
        - id: q01
          kind: Question
          title: "Question 1"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q02
          kind: Question
          title: "Question 2"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q03
          kind: Question
          title: "Question 3"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q04
          kind: Question
          title: "Question 4"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q05
          kind: Question
          title: "Question 5"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q06
          kind: Question
          title: "Question 6"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q07
          kind: Question
          title: "Question 7"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q08
          kind: Question
          title: "Question 8"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q09
          kind: Question
          title: "Question 9"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q10
          kind: Question
          title: "Question 10"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q11
          kind: Question
          title: "Question 11"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q12
          kind: Question
          title: "Question 12"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q13
          kind: Question
          title: "Question 13"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q14
          kind: Question
          title: "Question 14"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q15
          kind: Question
          title: "Question 15"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q16
          kind: Question
          title: "Question 16"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q17
          kind: Question
          title: "Question 17"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q18
          kind: Question
          title: "Question 18"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q19
          kind: Question
          title: "Question 19"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q20
          kind: Question
          title: "Question 20"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q21
          kind: Question
          title: "Question 21"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q22
          kind: Question
          title: "Question 22"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q23
          kind: Question
          title: "Question 23"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q24
          kind: Question
          title: "Question 24"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q25
          kind: Question
          title: "Question 25"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q26
          kind: Question
          title: "Question 26"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q27
          kind: Question
          title: "Question 27"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
