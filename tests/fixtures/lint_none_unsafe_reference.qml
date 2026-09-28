# Fixture for the none_unsafe_reference lint (#659), modelled on the BRFSS shape
# that excluded 58 of 60 demo surveys from Bronze.
#
# q_dx_age is asked only of diabetics, so for everyone else its outcome is None:
#   q_age        — postcondition ORDERS on it            -> flagged
#   q_gated      — precondition ORDERS on it             -> flagged
#   q_equality   — precondition tests EQUALITY           -> silent (None-safe)
#   q_guarded    — precondition guards with 'is not None' -> silent
#   q_always     — orders on an ALWAYS-reachable item     -> silent
questionnaire:
  title: None-unsafe reference lint
  blocks:
    - id: main
      kind: Group
      items:
        - id: q_diabetes
          kind: Question
          title: "Have you ever been told you have diabetes?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_dx_age
          kind: Question
          title: "How old were you when you were told?"
          precondition:
            - predicate: q_diabetes.outcome == 1
              hint: Diabetics only
          input:
            control: Editbox
            min: 0
            max: 99
        - id: q_age
          kind: Question
          title: "What is your age?"
          postcondition:
            - predicate: q_age.outcome >= q_dx_age.outcome
              hint: Cannot be younger than at diagnosis
          input:
            control: Editbox
            min: 18
            max: 99
        - id: q_gated
          kind: Question
          title: "Ordering gate on a conditional item"
          precondition:
            - predicate: q_dx_age.outcome >= 40
              hint: Diagnosed at 40 or later
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_equality
          kind: Question
          title: "Equality gate on the same conditional item"
          precondition:
            - predicate: q_dx_age.outcome != 1
              hint: Equality against None is clean
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_guarded
          kind: Question
          title: "Guarded ordering gate"
          precondition:
            - predicate: q_dx_age.outcome is not None and q_dx_age.outcome >= 40
              hint: The author acknowledged the unasked case
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_always
          kind: Question
          title: "Ordering gate on an always-asked item"
          precondition:
            - predicate: q_age.outcome >= 18
              hint: q_age is asked on every path
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
