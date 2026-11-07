# #1847: A None copied into a variable is compared as a number in a codeBlock.
# Runtime: Accepted at runtime: q_b is skipped, x = None, and None == None sets flag = 1, so r's
# postcondition holds.
# Why: The copy became an unconstrained Int, compared against the skipped q_b's None as False,
# so the model forced flag = 0 and r's check INFEASIBLE.
qmlVersion: "2.6.2"
questionnaire:
  title: codeBlock None copy
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
          postcondition:
            - predicate: q_b.outcome is not None
              hint: Please answer
          input:
            control: Radio
            labels:
              1: 'Yes'
        - id: q_c
          kind: Question
          title: Any other vehicle?
          codeBlock: |
            x = q_b.outcome
            flag = 1 if x == q_b.outcome else 0
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: r
          kind: Question
          title: Confirm no electric car
          input:
            control: Radio
            labels:
              1: Confirm
          postcondition:
            - predicate: q_b.outcome != 1 and flag == 1
              hint: Only without an electric car
