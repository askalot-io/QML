qmlVersion: "2.0"
# U3 edge case: a Roster with exactly ONE label key → exactly one
# bit-guarded copy must be emitted (len(labels) == 1 lower bound of the
# linear-in-len(labels) unroll). iterateOver references an outer Checkbox
# outcome whose only power-of-2 label is 1.
questionnaire:
  title: "Single-Label Roster"
  blocks:
    - id: pick_block
      kind: Group
      title: "Pick"
      items:
        - id: q_pick
          kind: Question
          title: "Include the optional section?"
          input:
            control: Checkbox
            labels:
              1: "Yes"

    - id: per_pick
      kind: Roster
      title: "Optional section"
      iterateOver: "q_pick.outcome"
      labels:
        1: "Only iteration"
      items:
        - id: q_detail
          kind: Question
          title: "Detail?"
          input:
            control: Editbox
            min: 0
            max: 50
