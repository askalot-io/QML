# #1783: A matrix cell and an item shared one Z3 name.
# Runtime: Accepted: m's cell is 1 and m_0_0 is 2.
# Why: Z3 names were joined with '_' (item_m_0_0), which an item id can also contain.
qmlVersion: "2.6.2"
questionnaire:
  title: Matrix cell vs item m_0_0
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
              3: '3'
        - id: m_0_0
          kind: Question
          title: A separate question
          input:
            control: Radio
            labels:
              1: '1'
              2: '2'
              3: '3'
          postcondition:
            - predicate: m.outcome[0][0] != m_0_0.outcome
              hint: Pick a different value
