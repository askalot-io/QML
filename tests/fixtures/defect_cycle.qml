# Defect fixture — CIRCULAR DEPENDENCY (Level 3, `dependency_cycle`, ERROR).
#
# q_a's precondition reads q_c, q_b reads q_a, q_c reads q_b. No topological
# order exists, so the flow engine has no defensible evaluation sequence and
# QMLTopology reports the back-edge. Diagram treatment: the back-edge renders
# as a `cycle` edge (animated red dash) and every item on the cycle takes the
# coral `cycle` fill, overriding both colour axes.
#
# The claim this comment makes is ASSERTED in
# tests/integration/test_defect_fixture_corpus.py (EXPECTED_FINDING). Until
# #762 it lived only here, where nothing executed it — so a fixture whose
# defect was accidentally repaired went on being described as one.
qmlVersion: "2.0"

questionnaire:
  title: "Defect: Circular Dependency"
  blocks:
    - id: b_cycle
      kind: Group
      title: "Three questions that gate each other"
      items:
        - id: q_a
          kind: Question
          title: "A — asked only if C said yes"
          precondition:
            - predicate: "q_c.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_b
          kind: Question
          title: "B — asked only if A said yes"
          precondition:
            - predicate: "q_a.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_c
          kind: Question
          title: "C — asked only if B said yes"
          precondition:
            - predicate: "q_b.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
