# #1769: A skipped item's None satisfies !=.
# Runtime: Shown to everyone who answered No to q_a: q_b is skipped, and None != 1 and None != 2
# are both True.
# Why: Z3 gave q_b a whole number in its domain {1, 2} even when q_b was never asked, so no value
# could satisfy the gate. At runtime a skipped item reads None.
qmlVersion: "2.6.2"
questionnaire:
  title: Skipped item reads None
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
          title: Car or van?
          precondition:
            - predicate: q_a.outcome == 1
          input:
            control: Radio
            labels:
              1: Car
              2: Van
        - id: r
          kind: Question
          title: Neither car nor van
          precondition:
            - predicate: q_b.outcome != 1 and q_b.outcome != 2
          input:
            control: Switch
