# Matrix Constraint Pattern 3 — Ranking (Distinct-Value) Constraint
# Reference: askalot_ai/agents/designer/.claude/skills/qml-syntax/matrix-constraint-patterns.md
#
# A 3x4 ranking matrix where each row must be a permutation of [1..4]:
# every rank used exactly once per row (no ties).
# Runtime-enforced via postcondition using set() + len() + list comprehension.
# Static Z3 validation silently drops this constraint — covered by xfail test
# in test_matrix_static_gap.py.

qmlVersion: "1.0"

questionnaire:
  title: "Product Attribute Ranking"

  blocks:
    - id: block1
      kind: Sequence
      title: "Ranking attributes per product"
      items:
        - id: product_attribute_ranks
          kind: MatrixQuestion
          title: "For each product, rank the attributes 1-4 (1 = most important, 4 = least)"
          rows:
            - "Smartphone"
            - "Laptop"
            - "Tablet"
          columns:
            - "Price"
            - "Performance"
            - "Battery"
            - "Design"
          input:
            control: Dropdown
            labels:
              1: "1 (most important)"
              2: "2"
              3: "3"
              4: "4 (least important)"
          postcondition:
            - predicate: |
                all([len(set([product_attribute_ranks.outcome[j][k] for k in range(4)])) == 4
                     for j in range(3)])
              hint: "Each rank (1-4) must be used exactly once per product"
