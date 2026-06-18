# Matrix Constraint Pattern — Deliberately Infeasible Postcondition
# Reference: docs/plans/2026-05-05-002-feat-z3-listcomp-matrix-plan.md (R9)
#
# A 2x2 budget matrix with cell range 0..10 — max possible row sum is 20 —
# but the postcondition demands every row sum to 999. Z3 should classify
# this as INFEASIBLE under the new validator (negative-test fixture proving
# the validator now reasons about matrix postconditions, rather than
# silently dropping them).
#
# Lives only in tests/fixtures/ — never as a Designer pattern, since
# "deliberately infeasible" is not something Designer should ever emit.

qmlVersion: "2.0"

questionnaire:
  title: "Infeasible Sum (Negative Test)"

  blocks:
    - id: block1
      kind: Group
      title: "Impossible budget"
      items:
        - id: impossible_budget
          kind: MatrixQuestion
          title: "Allocate per row (cells 0..10) — must sum to 999"
          rows:
            - "Row1"
            - "Row2"
          columns:
            - "ColA"
            - "ColB"
          input:
            control: Editbox
            min: 0
            max: 10
          postcondition:
            - predicate: |
                all([sum([impossible_budget.outcome[j][k] for k in range(2)]) == 999
                     for j in range(2)])
              hint: "Each row must sum to 999 (impossible — cells max out at 10)"
