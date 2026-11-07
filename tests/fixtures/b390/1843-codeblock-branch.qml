# #1843: A codeBlock assignment inside an if branch is modelled as always running.
# Runtime: Accepted at runtime: a respondent who answers q_a = No skips the branch, so flag
# stays 0 and r's postcondition holds.
# Why: The builder lowered every assignment with ast.walk, ignoring control flow, so the model
# forced flag = 1 and r's check INFEASIBLE (publish refused).
qmlVersion: "2.6.2"
questionnaire:
  title: codeBlock branch assignment
  codeInit: |
    flag = 0
  blocks:
    - id: b1
      title: Main
      items:
        - id: q_a
          kind: Question
          title: Do you drive?
          postcondition:
            - predicate: q_a.outcome is not None
              hint: Please answer
          codeBlock: |
            if q_a.outcome == 1:
                flag = 1
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: r
          kind: Question
          title: Confirm you do not drive
          input:
            control: Radio
            labels:
              1: Confirm
          postcondition:
            - predicate: flag == 0
              hint: Only for non-drivers
