questionnaire:
  title: "Quality Scorecard - Zero Guaranteed Burden"
  codeInit: |
    mask = 3
  blocks:
    # Every item lives inside the Roster: a roster can run zero iterations,
    # so nothing is guaranteed — D8's spread_ratio must be None (not a
    # ZeroDivisionError) and the grade falls to the adequate-by-fiat branch.
    - id: members
      kind: Roster
      title: "Household members"
      iterateOver: "mask"
      labels:
        1: First
        2: Second
      items:
        - id: q_member_age
          kind: Question
          title: "How old is this member?"
          input:
            control: Editbox
            min: 0
            max: 120
        - id: q_member_role
          kind: Question
          title: "What is their role?"
          input:
            control: Radio
            labels:
              1: Adult
              2: Child
