# Defect fixture — DEAD END (Level 1 `infeasible_postcondition` ERROR +
# Level 4 `accumulated_dead_code` WARNING).
#
# Two distinct shapes of "the flow cannot go on":
#   q_trap  — its own postcondition is self-contradictory, so no answer the
#             control admits can satisfy the gate. The respondent is stuck on
#             the item itself. Diagram: fill turns soft red (#ffd6d6).
#   q_dead  — reachable read in isolation (its guard is SAT), but the
#             accumulated postcondition of q_income makes the conjunction
#             UNSAT, so no surviving path ever arrives. Diagram: no dedicated
#             treatment — it renders as an ordinary CONDITIONAL item.
#
# The claim this comment makes is ASSERTED in
# tests/integration/test_defect_fixture_corpus.py (EXPECTED_FINDING). Until
# #762 it lived only here, where nothing executed it — so a fixture whose
# defect was accidentally repaired went on being described as one.
qmlVersion: "2.0"

questionnaire:
  title: "Defect: Dead End"
  blocks:
    - id: b_income
      kind: Group
      title: "Income"
      items:
        - id: q_trap
          kind: Question
          title: "Trap — postcondition no answer can satisfy"
          input:
            control: Editbox
            min: 1
            max: 100
          postcondition:
            - predicate: "q_trap.outcome > 90 and q_trap.outcome < 20"
              hint: "Above 90 and below 20 at the same time"
        - id: q_income
          kind: Question
          title: "Monthly income, in hundreds"
          input:
            control: Editbox
            min: 1
            max: 100
          postcondition:
            - predicate: "q_income.outcome > 80"
              hint: "Only high earners pass this gate"
        - id: q_dead
          kind: Question
          title: "Dead code — asked only of low earners, who never get here"
          precondition:
            - predicate: "q_income.outcome < 50"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
