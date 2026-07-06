# Frozen-gate reachability fixture.
#
# Reproduces the corpus "frozen variable" pattern (ESS12 `has_partner`, SHS
# `one_person_hh`): a codeInit variable is initialized to a constant and never
# reassigned by any codeBlock, so it holds that constant for the whole run. Items
# gated on the variable are therefore statically decidable. Against a domain-only
# base `has_partner` is a free symbol, so a permanently-false gate would classify
# CONDITIONAL and its item's dead code would go unreported.
#
# The reachability base propagates a frozen variable's initializer constant, so:
#   - `q_partner_age`  (gated `has_partner == 1`) → NEVER  → unreachable_item error
#   - `q_living_alone` (gated `has_partner == 0`) → ALWAYS → no error
# `q_household_size` is the always-shown anchor. The only validation error this
# fixture yields is the single unreachable_item on `q_partner_age`.
qmlVersion: "2.0"

questionnaire:
  title: "Frozen Gate Lint Fixture"
  codeInit: |
    has_partner = 0
  blocks:
    - id: b_household
      kind: Group
      title: "Household composition"
      items:
        - id: q_household_size
          kind: Question
          title: "How many people live in your household?"
          input:
            control: Editbox
            min: 1
            max: 20
        - id: q_partner_age
          kind: Question
          title: "How old is your partner?"
          precondition:
            - predicate: "has_partner == 1"
              hint: "Only asked when the respondent has a partner"
          input:
            control: Editbox
            min: 16
            max: 120
        - id: q_living_alone
          kind: Question
          title: "Do you live alone?"
          precondition:
            - predicate: "has_partner == 0"
              hint: "Asked whenever the respondent has no partner"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
