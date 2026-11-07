# #1779: A raise under 'not' fails the gate.
# Runtime: Never shown: answered, not (age >= 0) is False; skipped, the comparison raises and the
# precondition is False.
# Why: Each node lowers to whether it holds and whether it raises, so the raise passes through
# 'not' and fails the precondition at the root: Z3 proves the item dead (NEVER).
qmlVersion: "2.6.2"
questionnaire:
  title: Raise under not
  blocks:
    - id: b1
      title: Main
      items:
        - id: q_a
          kind: Question
          title: Do you drive?
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: q_age
          kind: Question
          title: Age of your car (years)
          precondition:
            - predicate: q_a.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 120
        - id: r
          kind: Question
          title: Never shown
          precondition:
            - predicate: not (q_age.outcome >= 0)
          input:
            control: Switch
