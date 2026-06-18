# Matrix Constraint Pattern 1 — Matrix Symmetry
# Reference: askalot_ai/agents/designer/.claude/skills/qml-syntax/matrix-constraint-patterns.md
#
# A 4x4 factor-relationship matrix where S[j][k] == S[k][j] must hold for all
# j < k. Runtime-enforced via postcondition using list comprehension + all().
# Static Z3 validation silently drops this constraint — covered by xfail test
# in test_matrix_static_gap.py.

qmlVersion: "2.0"

questionnaire:
  title: "Factor Relationship Survey"

  blocks:
    - id: block1
      kind: Group
      title: "Pairwise factor relationships"
      items:
        - id: factor_relationships
          kind: MatrixQuestion
          title: "Rate the relationship strength between each pair of factors (0-10)"
          rows:
            - "Price"
            - "Quality"
            - "Brand"
            - "Service"
          columns:
            - "Price"
            - "Quality"
            - "Brand"
            - "Service"
          input:
            control: Slider
            min: 0
            max: 10
          postcondition:
            - predicate: |
                all([factor_relationships.outcome[j][k] == factor_relationships.outcome[k][j]
                     for j in range(4) for k in range(4) if k > j])
              hint: "The relationship between A and B must equal the relationship between B and A"
