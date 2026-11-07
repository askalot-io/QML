# #1785: A skipped answer is an extra set member.
# Runtime: Shown when q_a is No: q4 is skipped, and set([1, 2, 3, None]) has four members.
# Why: Z3 lowered len(set(...)) == 4 to Distinct over four numbers in {1, 2, 3}, which is
# impossible. At runtime None is a fourth value.
qmlVersion: "2.6.2"
questionnaire:
  title: Distinct over skippable
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
        - id: q1
          kind: Question
          title: Rank item 1
          input:
            control: Radio
            labels:
              1: 1st
              2: 2nd
              3: 3rd
        - id: q2
          kind: Question
          title: Rank item 2
          input:
            control: Radio
            labels:
              1: 1st
              2: 2nd
              3: 3rd
        - id: q3
          kind: Question
          title: Rank item 3
          input:
            control: Radio
            labels:
              1: 1st
              2: 2nd
              3: 3rd
        - id: q4
          kind: Question
          title: Rank item 4
          precondition:
            - predicate: q_a.outcome == 1
          input:
            control: Radio
            labels:
              1: 1st
              2: 2nd
              3: 3rd
        - id: r
          kind: Question
          title: All four ranks differ
          precondition:
            - predicate: len(set([q1.outcome, q2.outcome, q3.outcome, q4.outcome])) == 4
          input:
            control: Switch
