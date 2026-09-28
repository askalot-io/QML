# Defect fixture — UNSUPPORTED PYTHON in a codeBlock.
#
# PythonRunner's sandbox admits a fixed allowlist (see python_runner.py):
# `ast.Import` is a forbidden node, and `eval` / `open` / `os` match the
# forbidden-attribute patterns. Every construct below is refused by
# `validate_code`, and `risk_flag` is produced by a block that therefore never
# runs — so the precondition that reads it is gated on a variable no reachable
# code assigns.
#
# The claim this comment makes is ASSERTED in
# tests/integration/test_defect_fixture_corpus.py (EXPECTED_FINDING). Until
# #762 it lived only here, where nothing executed it — so a fixture whose
# defect was accidentally repaired went on being described as one.
qmlVersion: "2.0"

questionnaire:
  title: "Defect: Unsupported Python"
  codeInit: |
    risk_score = 0
  blocks:
    - id: b_risk
      kind: Group
      title: "Risk scoring"
      items:
        - id: q_age
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 18
            max: 100
          codeBlock: |
            import os
            risk_score = eval("q_age.outcome * 2")
            with open("/etc/passwd") as fh:
                leaked = fh.read()
            risk_flag = os.environ.get("SECRET")
        - id: q_followup
          kind: Question
          title: "Follow-up — gated on a variable the refused block never sets"
          precondition:
            - predicate: "risk_flag == 1"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
