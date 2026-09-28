# YAML-boolean-in-predicate fixture (#201).
#
# Reproduces the shape found fielded in two live dev campaigns (both DORA
# ICT-Maturity questionnaires): a branch written with the YAML spellings of the
# boolean literals.
#
#   precondition: q_simplified_eligible.outcome == false
#   precondition: q_simplified_eligible.outcome == true
#
# A QML `predicate:` is a YAML *string* holding a **Python** expression, so
# `true` / `false` are undefined names, not booleans. Consequences:
#
#   - At runtime the predicate fails open, so BOTH the full and the simplified
#     branch are shown — the branch does not branch.
#   - Under Z3 the free symbol makes the branch prove nothing, so formal
#     verification silently covers an empty constraint.
#
# The existing undefined_name lint already fires here; what this fixture pins is
# that the SUGGESTION names the actual fix ('True' / 'False') instead of the
# generic "reference an item's outcome or add a codeBlock that produces it"
# advice, which nobody can act on when the phantom is a misspelled literal.
qmlVersion: "2.0"

questionnaire:
  title: "YAML Boolean Predicate Fixture"
  blocks:
    - id: b_eligibility
      kind: Group
      title: "Eligibility"
      items:
        - id: q_simplified_eligible
          kind: Question
          title: "Does the simplified assessment apply?"
          input:
            control: Switch
            labels:
              1: "Yes"
              2: "No"
        - id: q_pillar1_full
          kind: Question
          title: "Pillar 1 — full assessment"
          precondition:
            - predicate: "q_simplified_eligible.outcome == false"
              hint: "Only when the simplified assessment does not apply"
          input:
            control: Editbox
            min: 0
            max: 100
        - id: q_pillar1_simplified
          kind: Question
          title: "Pillar 1 — simplified assessment"
          precondition:
            - predicate: "q_simplified_eligible.outcome == true"
              hint: "Only when the simplified assessment applies"
          input:
            control: Editbox
            min: 0
            max: 100
