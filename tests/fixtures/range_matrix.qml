# Range MatrixQuestion — each cell is a [low, high] pair with named ends (#1474, #1755)
#
# A 2x3 Range matrix on 0..10. The static model holds every cell as two
# variables, item_m@{r}@{c}@lo / @hi, bound by 0 <= lo <= hi <= 10, and lowers
# m.outcome[j][k].low / m.outcome[j][k].high with literal indices onto them.
#
#   q_inverted  gates on low > high in one cell        -> NEVER
#   q_low_high  gates on that cell's high end <= 3     -> CONDITIONAL
#   q_fold      sums low ends across a row             -> coverage gap (a fold
#               over Range cells is not modelled)
#   q_bare      compares a whole cell as a number      -> coverage gap
#   q_positional reads an end by index (m...[1][2][0])  -> coverage gap (#1755:
#               the ends are named; there is no positional alias)
#
# Lives only in tests/fixtures/: it exercises the validator, not a pattern.

qmlVersion: "2.5"

questionnaire:
  title: "Range Matrix Ends"

  blocks:
    - id: block1
      kind: Group
      title: "Ranges"
      items:
        - id: m
          kind: MatrixQuestion
          title: "Give a range for each cell"
          rows:
            - "Row1"
            - "Row2"
          columns:
            - "ColA"
            - "ColB"
            - "ColC"
          input:
            control: Range
            min: 0
            max: 10

        - id: q_inverted
          kind: Question
          title: "Asked when a cell's low end exceeds its high end"
          precondition:
            - predicate: "m.outcome[1][2].low > m.outcome[1][2].high"
          input:
            control: Switch

        - id: q_low_high
          kind: Question
          title: "Asked when the Row2/ColC high end is at most 3"
          precondition:
            - predicate: "m.outcome[1][2].high <= 3"
          input:
            control: Switch

        - id: q_fold
          kind: Question
          title: "Asked when the Row1 low ends sum above 5"
          precondition:
            - predicate: "sum([m.outcome[0][k].low for k in range(3)]) > 5"
          input:
            control: Switch

        - id: q_bare
          kind: Question
          title: "Asked when a whole cell is compared as a number"
          precondition:
            - predicate: "m.outcome[1][2] > 2"
          input:
            control: Switch

        - id: q_positional
          kind: Question
          title: "Asked when a cell's end is read by index"
          precondition:
            - predicate: "m.outcome[1][2][0] > 5"
          input:
            control: Switch
