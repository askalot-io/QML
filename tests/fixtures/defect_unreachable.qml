# Defect fixture — UNREACHABLE ITEM (Level 1, `unreachable_item`, ERROR).
#
# q_never's precondition demands two mutually exclusive outcomes of the same
# single-answer Radio, so Z3 proves the guard UNSAT under every model: the
# item can never be shown. q_orphan is unreachable for the second reason the
# lint distinguishes — it depends on the item that is itself never asked.
# Diagram treatment: precondition status NEVER paints the item's rim the error
# red (#c0392b) at 2px, against the hairline green of a reachable item. It is
# the same red as the cycle back-edge, and a cycle item is still told apart by
# its fill: resolveItemBorder short-circuits to the coral #ff6b6b before the
# precondition map is read.
#
# The claim this comment makes is ASSERTED in
# tests/integration/test_defect_fixture_corpus.py (EXPECTED_FINDING). Until
# #762 it lived only here, where nothing executed it — so a fixture whose
# defect was accidentally repaired went on being described as one.
qmlVersion: "2.0"

questionnaire:
  title: "Defect: Unreachable Items"
  blocks:
    - id: b_screen
      kind: Group
      title: "Screening"
      items:
        - id: q_employment
          kind: Question
          title: "What is your employment status?"
          input:
            control: Radio
            labels:
              1: "Employed"
              2: "Unemployed"
              3: "Retired"
        - id: q_reachable
          kind: Question
          title: "Reachable — asked of employed respondents"
          precondition:
            - predicate: "q_employment.outcome == 1"
          input:
            control: Editbox
            min: 0
            max: 80
        - id: q_never
          kind: Question
          title: "Unreachable — employed AND retired at once"
          precondition:
            - predicate: "q_employment.outcome == 1 and q_employment.outcome == 3"
              hint: "Contradictory guard — no respondent satisfies it"
          input:
            control: Radio
            labels:
              1: "A"
              2: "B"
        - id: q_orphan
          kind: Question
          title: "Unreachable — gated on an item that is never asked"
          precondition:
            - predicate: "q_never.outcome == 1"
          input:
            control: Radio
            labels:
              1: "A"
              2: "B"
