# #1867: A skipped item read through a ternary into `in` is held as an answer.
# Runtime: Shown at runtime: with q_a = Yes and q_b skipped (or its gate run before q_a was
# answered through the API), None in [0, 1, 2] is False, so r's gate is True.
# Why: The ternary passes q_b's None on untouched; the model held q_b as one of its labels and
# proved r unreachable. The condition is now refused as a coverage gap naming q_b.
qmlVersion: "2.6.2"
questionnaire:
  title: ternary skip into in
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
          title: Is it electric?
          precondition:
            - predicate: q_a.outcome == 1
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: r
          kind: Question
          title: Why not?
          precondition:
            - predicate: not ((q_b.outcome if q_a.outcome == 1 else 0) in [0, 1, 2])
          input:
            control: Radio
            labels:
              1: Cost
              2: Range
