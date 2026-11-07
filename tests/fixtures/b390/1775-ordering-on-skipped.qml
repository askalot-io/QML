# #1775: An ordering on a skipped item raises.
# Runtime: Skipped for everyone who answered No to q_a: None >= 0 raises, and a precondition that
# raises is False.
# Why: Z3 held q_age as a number 0–120 for everyone, so q_age >= 0 always held.
qmlVersion: "2.6.2"
questionnaire:
  title: Ordering on a skipped item
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
          title: Car age follow-up
          precondition:
            - predicate: q_age.outcome >= 0
          input:
            control: Switch
