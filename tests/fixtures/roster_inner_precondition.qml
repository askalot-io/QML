qmlVersion: "2.0"
questionnaire:
  title: "Family Roster With Conditional Inner Item"
  blocks:
    - id: count_block
      kind: Group
      title: "Family"
      items:
        - id: q_family_count
          kind: Question
          title: "How many family members do you have?"
          input:
            control: Editbox
            min: 1
            max: 4
          codeBlock: |
            family_mask = 2 ** q_family_count.outcome - 1

    - id: per_member
      kind: Roster
      title: "Family member details"
      iterateOver: "family_mask"
      labels:
        1: "Member 1"
        2: "Member 2"
        4: "Member 3"
        8: "Member 4"
      items:
        - id: q_member_name
          kind: Question
          title: "Name?"
          input:
            control: Editbox
            min: 0
            max: 100
        # q_member_age has a precondition referencing the OUTER q_family_count.
        # When count=1, only one member; we still ask age (precondition trivially true).
        # The point is to exercise outer-item references resolving correctly inside roster context.
        - id: q_member_age
          kind: Question
          title: "Age?"
          input:
            control: Editbox
            min: 0
            max: 120
          precondition:
            - predicate: "q_family_count.outcome > 0"
              hint: "Skip age for empty households"
