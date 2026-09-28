# Defect fixture — SYNTAX ERROR (the file never becomes a questionnaire).
#
# Two deliberate YAML faults: the title's opening quote is never closed, and
# `items:` sits at an indentation the parent sequence cannot admit. yaml.safe_load
# raises before any QML rule runs, so there is no graph, no Z3 pass and no item
# to colour — the diagram can only show the failure itself.
#
# The claim this comment makes is ASSERTED in
# tests/integration/test_defect_fixture_corpus.py (EXPECTED_FINDING). Until
# #762 it lived only here, where nothing executed it — so a fixture whose
# defect was accidentally repaired went on being described as one.
qmlVersion: "2.0"

questionnaire:
  title: "Defect: Syntax Error
  blocks:
    - id: b_main
      kind: Group
      title: "Main"
       items:
        - id: q_one
          kind: Question
          title: "A question"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
