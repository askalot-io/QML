# #1776: A codeBlock reads a skipped item as a number.
# Runtime: Accepted at runtime: q_b is skipped, so flag = 1, and with q_c = Yes the postcondition
# holds.
# Why: Skip semantics lived in condition lowering only. The codeBlock read q_b as its only
# label, 1, so the model forced flag = 0.
qmlVersion: "2.6.2"
questionnaire:
  title: codeBlock reads a skipped item
  codeInit: |
    flag = 0
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
        - id: q_b
          kind: Question
          title: Is it electric?
          precondition:
            - predicate: q_a.outcome == 1
          input:
            control: Radio
            labels:
              1: 'Yes'
        - id: q_c
          kind: Question
          title: Any other vehicle?
          codeBlock: flag = 1 if q_b.outcome != 1 else 0
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: r
          kind: Question
          title: Confirm a non-electric extra vehicle
          input:
            control: Radio
            labels:
              1: Confirm
          postcondition:
            - predicate: q_c.outcome == 1 and flag == 1
              hint: Only for a non-electric extra vehicle
