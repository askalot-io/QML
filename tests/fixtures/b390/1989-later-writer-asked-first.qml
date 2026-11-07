# #1989: A variable written by an item later in the file that the walk asks first.
# Runtime: q's gate reads x, which t writes, so the walk asks t before q; t sets x, q copies
# its answer into flag, and r's postcondition flag == 1 holds for a cyclist.
# Why: The builder numbered SSA versions in file order, so q read codeInit's x = 0 and r's check
# was INFEASIBLE (publish refused); the build now lowers in the walk's navigation order.
qmlVersion: "2.6.2"
questionnaire:
  title: later writer asked first
  codeInit: |
    x = 0
    flag = 0
  blocks:
    - id: b1
      title: Main
      items:
        - id: q
          kind: Question
          title: Do you drive?
          precondition:
            - predicate: x >= 0
              hint: Asked once x is set
          codeBlock: |
            flag = x
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: t
          kind: Question
          title: Do you cycle?
          codeBlock: |
            x = t.outcome
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: r
          kind: Question
          title: Confirm
          postcondition:
            - predicate: flag == 1
              hint: Only once flag is set
          input:
            control: Radio
            labels:
              1: Confirm
