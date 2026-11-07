qmlVersion: "2.5"
# A Range Question inside a Roster (#1474). Each labelled iteration gets its
# own pair, item_q_span@iter{K}@lo / @hi, bound by 0 <= lo <= hi <= 10 under
# that iteration's present gate. The postcondition demands a low end above
# the high end, which no pair satisfies, so every iteration — including the
# second (K = 2) — is independently contradictory.
questionnaire:
  title: "Roster With A Range Inner Item"
  blocks:
    - id: count_block
      kind: Group
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
            member_mask = 2 ** q_count.outcome - 1

    - id: per_member
      kind: Roster
      title: "Per member"
      iterateOver: member_mask
      labels:
        1: "Member 1"
        2: "Member 2"
      items:
        - id: q_span
          kind: Question
          title: "Which range of hours?"
          input:
            control: Range
            min: 0
            max: 10
          postcondition:
            - predicate: "q_span.outcome.low > q_span.outcome.high"
              hint: "Impossible: a Range answer's low end never exceeds its high end"
