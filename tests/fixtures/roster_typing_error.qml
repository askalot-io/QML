qmlVersion: "1.0"
# U3 fixture: a Roster inner item carries a postcondition that is INFEASIBLE
# against its own declared domain (outcome ∈ [0, 5] but the postcondition
# demands outcome > 100). The single-canonical-iteration model would catch
# this once; U3's bit-guarded unroll re-emits it under EVERY label-key's
# present gate, so the typing error is independently detectable for each
# labelled iteration (the whole point of the unit). 4 label keys exercise
# the AE3 "≤2 bits settable, 4 copies" path: count ∈ [1,2] → family_mask is
# 1 or 3, so at most bits 0 and 1 are ever set, yet 4 copies are emitted and
# the 2 impossible iterations contribute constraints without raising.
questionnaire:
  title: "Roster With Per-Iteration Typing Error"
  blocks:
    - id: count_block
      kind: Sequence
      title: "Count"
      items:
        - id: q_count
          kind: Question
          title: "How many?"
          input:
            control: Editbox
            min: 1
            max: 2
          codeBlock: |
            family_mask = 2 ** q_count.outcome - 1

    - id: per_item
      kind: Roster
      title: "Per-item rating"
      iterateOver: "family_mask"
      labels:
        1: "Slot 1"
        2: "Slot 2"
        4: "Slot 3"
        8: "Slot 4"
      items:
        - id: q_rating
          kind: Question
          title: "Rate it"
          input:
            control: Slider
            min: 0
            max: 5
          postcondition:
            - predicate: "q_rating.outcome > 100"
              hint: "Impossible: rating domain is 0..5"
