# #1782: len(m.rows) worked in Z3 but not at runtime.
# Runtime: Shown when the cell is 2. Before, ItemProxy had no rows, so the gate raised and r was
# skipped for everyone.
# Why: Z3 resolved len(m.rows) at build time; the runtime proxy did not expose the list.
qmlVersion: "2.6.2"
questionnaire:
  title: len(m.rows)
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
          title: Uses the matrix size
          precondition:
            - predicate: any([m.outcome[j][0] == 2 for j in range(len(m.rows))])
          input:
            control: Switch
