# Matrix Constraint Pattern 2 — Fixed-Sum Allocation
# Reference: askalot_ai/agents/designer/.claude/skills/qml-syntax/matrix-constraint-patterns.md
#
# A 4x4 quarterly budget matrix where each row must sum to exactly 100.
# Runtime-enforced via postcondition using sum() + list comprehension + all().
# Static Z3 validation silently drops this constraint — covered by xfail test
# in test_matrix_static_gap.py.

qmlVersion: "1.0"

questionnaire:
  title: "Quarterly Budget Allocation"

  blocks:
    - id: block1
      kind: Sequence
      title: "Budget by quarter"
      items:
        - id: quarterly_budget
          kind: MatrixQuestion
          title: "Allocate 100 points across departments for each quarter (must sum to 100 per row)"
          rows:
            - "Q1"
            - "Q2"
            - "Q3"
            - "Q4"
          columns:
            - "Engineering"
            - "Marketing"
            - "Sales"
            - "Operations"
          input:
            control: Editbox
            min: 0
            max: 100
          postcondition:
            - predicate: |
                all([sum([quarterly_budget.outcome[j][k] for k in range(4)]) == 100
                     for j in range(4)])
              hint: "Each quarter's allocations must sum to exactly 100"
