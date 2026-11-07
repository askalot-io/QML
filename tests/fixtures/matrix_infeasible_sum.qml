# Matrix Constraint Pattern — Deliberately Infeasible Postcondition
# Reference: docs/plans/2026-05-05-002-feat-z3-listcomp-matrix-plan.md (R9)
#
# A 2x2 budget matrix with cell range 0..10, whose postcondition demands every
# cell be 999. Z3 should classify this as INFEASIBLE (negative-test fixture
# proving the validator reasons about matrix postconditions, rather than
# silently dropping them).
#
# The check must refuse a blank matrix and an empty cell too, or the runtime
# waives it (#1780, #1784): ``is not None`` refuses the blank matrix and
# ``None == 999`` is False. A row sum would raise on an empty cell, and a
# raise waives a postcondition, so a sum check is never infeasible.
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
          title: "Allocate per cell (0..10) — each must be 999"
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
                impossible_budget.outcome is not None and all([impossible_budget.outcome[j][k] == 999
                                                               for j in range(2) for k in range(2)])
              hint: "Each cell must be 999 (impossible — cells max out at 10)"
