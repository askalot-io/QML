# Accumulated Reachability — sibling-mediated dead code
# Reference: icai2026.tex, Example "ex:income" (Accumulated Reachability)
#
# I_1: "Annual income"        with S_1 ∈ [0, 1000000], P_1 = true,            Q_1 = true
# I_2: "Tax bracket"          with S_2 ∈ {1, 2, 3},     P_2 = true,            Q_2 = (S_1 >= S_2 * 10000)
# I_3: "Low-income assistance" with S_3 ∈ {0, 1},       P_3 = (S_1 < 10000),   Q_3 = true
#
# Dependency graph: I_1 → I_2 (Q_2 references S_1) and I_1 → I_3 (P_3 references S_1).
# I_2 and I_3 are independent siblings — neither references the other's outcome,
# so there is no edge between them. The stable topological order follows QML file
# order: I_1, I_2, I_3.
#
# Expected results:
# - Per-item:
#   - P_3 = (S_1 < 10000) is CONDITIONAL: SAT(B ∧ S_1 < 10000) holds (e.g. S_1 = 5000)
#   - No item is INFEASIBLE; the global formula F is SAT
# - Accumulated reachability for I_3:
#   - Pred(3) = {1, 2} — every item preceding I_3 in the topological order, not
#     only its data-flow ancestors. I_2 is always-present (P_2 = true), so its
#     postcondition Q_2 is enforced on every execution that reaches I_3.
#   - A_3 = B ∧ (true => true) ∧ (true => S_1 >= S_2 * 10000) = B ∧ (S_1 >= S_2 * 10000)
#   - A_3 ∧ P_3 = B ∧ (S_1 >= S_2 * 10000) ∧ (S_1 < 10000) = UNSAT
#     (since S_2 >= 1, Q_2 forces S_1 >= 10000, contradicting P_3)
# - I_3 is DEAD CODE: I_2's postcondition smuggles a lower bound on S_1 through an
#   intermediate sibling, making the low-income branch unreachable even though
#   per-item analysis sees no problem.

qmlVersion: "2.0"

questionnaire:
  title: "Income Survey with Dead Code"

  blocks:
    - id: block1
      kind: Group
      title: "Financial Information"
      items:
        - id: q_income
          kind: Question
          title: "What is your annual income?"
          input:
            control: Editbox
            min: 0
            max: 1000000

        - id: q_tax_bracket
          kind: Question
          title: "Select your tax bracket"
          input:
            control: Radio
            labels:
              1: "Low"
              2: "Medium"
              3: "High"
          postcondition:
            - predicate: q_income.outcome >= q_tax_bracket.outcome * 10000
              hint: "Income must cover the tax bracket's lower bound"

        - id: q_low_income_assist
          kind: Question
          title: "Would you like information about low-income assistance programs?"
          input:
            control: Radio
            labels:
              0: "No"
              1: "Yes"
          precondition:
            - predicate: q_income.outcome < 10000
