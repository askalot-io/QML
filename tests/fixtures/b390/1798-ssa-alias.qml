# #1798: A variable named item_q aliased q_0's answer.
# Runtime: Shown when q_0 is 7.
# Why: The SSA version of variable item_q was named item_q_0, the same Z3 name as Question q_0's
# answer, which must be 7 or 8.
qmlVersion: "2.6.2"
questionnaire:
  title: Variable named like an item
  codeInit: |
    item_q = 1
  blocks:
    - id: b1
      title: Main
      items:
        - id: q_0
          kind: Question
          title: Pick one
          input:
            control: Radio
            labels:
              7: Seven
              8: Eight
        - id: z
          kind: Question
          title: Seven and the flag set
          precondition:
            - predicate: q_0.outcome == 7 and item_q == 1
          input:
            control: Switch
