# #1838: An item's own postcondition is judged after its own codeBlock.
# Runtime: Accepted at runtime: the postcondition runs before q's codeBlock, while x is still 1,
# so every answer passes.
# Why: The classifier compiled q's own check at the final variable versions (x = 2), so it
# was INFEASIBLE (publish refused); it now reads the versions current at q's submission.
qmlVersion: "2.6.2"
questionnaire:
  title: own check before own codeBlock
  codeInit: |
    x = 1
  blocks:
    - id: b1
      title: Main
      items:
        - id: q
          kind: Question
          title: Pick one
          postcondition:
            - predicate: x == 1
              hint: Always holds here
          codeBlock: x = 2
          input:
            control: Radio
            labels:
              1: A
              2: B
