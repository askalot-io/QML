# #1250: The None guard the lint recommends.
# Runtime: Shown to everyone: blank → the first test holds; answered → the second or third does.
# Why: 'is None' had no Z3 lowering, so following the none_unsafe_reference lint's own advice
# dropped the gate from verification.
qmlVersion: "2.6.2"
questionnaire:
  title: None guard
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
        - id: r
          kind: Question
          title: Shown to everyone
          precondition:
            - predicate: q_a.outcome is None or q_a.outcome != 2 or q_a.outcome == 2
          input:
            control: Switch
