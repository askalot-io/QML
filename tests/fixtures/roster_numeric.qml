qmlVersion: "2.0"
questionnaire:
  title: "Family Roster"
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
            # Build a bitmask of N consecutive low bits using plain math (no <<).
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
        - id: q_member_age
          kind: Question
          title: "Age?"
          input:
            control: Editbox
            min: 0
            max: 120
