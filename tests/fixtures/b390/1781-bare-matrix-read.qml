# #1781: A whole-matrix read vanished silently.
# Runtime: Never shown: a list never equals 1.
# Why: m.outcome compared with a number has no Z3 form, but no gap was recorded, so nobody was
# told.
qmlVersion: "2.6.2"
questionnaire:
  title: Bare matrix read
  blocks:
    - id: b1
      title: Main
      items:
        - id: m
          kind: MatrixQuestion
          title: Rate
          rows:
            - A
          columns:
            - B
          input:
            control: Radio
            labels:
              1: '1'
              2: '2'
        - id: r
          kind: Question
          title: Whole matrix compared with a number
          precondition:
            - predicate: m.outcome == 1
          input:
            control: Switch
