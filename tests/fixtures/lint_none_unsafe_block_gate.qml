# One block-level gate that orders on a conditional item (#659).
#
# The gate is declared ONCE on b_gated, but static_builder composes block and
# item conditions onto every member, so a naive scan reports it once per member
# — three findings keyed to three items that declare no condition at all. The
# lint must report it once, against the block that declares it.
questionnaire:
  title: Block-level none-unsafe gate
  blocks:
    - id: b_screen
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
    - id: b_gated
      kind: Group
      precondition:
        - predicate: q_dx_age.outcome >= 40
          hint: Diagnosed at 40 or later
      items:
        - id: q_m1
          kind: Question
          title: "Member one"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_m2
          kind: Question
          title: "Member two"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_m3
          kind: Question
          title: "Member three"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
