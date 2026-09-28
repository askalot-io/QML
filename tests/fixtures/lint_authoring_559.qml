# Lint fixture — the three #559 authoring warnings, each with its negatives.
#
# self_assignment: q_building assigns its own outcome to itself (the ACS
# shape), and q_nested does the same inside an `if`; q_rescaled's
# `x = x + 0`-style statement and q_copy's plain copy are real statements and
# must not warn.
#
# mandated_answer_postcondition: q_consent (Switch) and q_outsourced (Radio,
# two options) each admit one answer, and q_tier's two postconditions together
# admit one of three. q_region admits two of three, q_age is a
# numeric control, and q_match and q_confirm relate two answers — none may
# warn. q_confirm admits only 1 unless q_building is 3, so it reads as a
# mandate to a lint that mistakes the other item's outcome for its own.
#
# combinable_none_option: q_cover's "No health insurance" can be ticked beside
# a plan, and q_cover_leaky's guard still admits "None" + Medicare (5).
# q_cover_guarded refuses the combination in a Z3-lowerable form,
# q_cover_relational has a postcondition the lint cannot read (so it stays
# silent), q_unsure's "Not sure" is not a denial, q_cover_block is guarded by
# its BLOCK's postcondition, and q_group_cover is a QuestionGroup whose list
# outcome the suggested guard cannot test.
qmlVersion: "2.0"

questionnaire:
  title: "Lint: #559 authoring warnings"
  blocks:
    - id: b_main
      title: "Main"
      items:
        - id: q_building
          kind: Question
          title: "Which best describes this building?"
          input:
            control: Radio
            labels:
              1: "A mobile home"
              2: "A one-family house"
              3: "An apartment building"
          codeBlock: |
            q_building.outcome = q_building.outcome
        - id: q_rescaled
          kind: Question
          title: "How many rooms?"
          input:
            control: Editbox
            min: 1
            max: 20
          codeBlock: |
            rooms = q_rescaled.outcome
            rooms = rooms + 0
        - id: q_copy
          kind: Question
          title: "How many bedrooms?"
          precondition:
            - predicate: "rooms > 1"
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            bedrooms = q_copy.outcome
        - id: q_consent
          kind: Question
          title: "Do you consent to the SSN disclosure?"
          postcondition:
            - predicate: "q_consent.outcome == 1"
              hint: "You must consent to continue."
          input:
            control: Switch
            on: "Yes"
            off: "No"
        - id: q_outsourced
          kind: Question
          title: "Is card processing fully outsourced?"
          postcondition:
            - predicate: "q_outsourced.outcome == 1"
              hint: "This survey applies to fully outsourced merchants only."
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_region
          kind: Question
          title: "Which region?"
          postcondition:
            - predicate: "q_region.outcome in (1, 2)"
              hint: "Region 3 is not covered."
          input:
            control: Radio
            labels:
              1: "North"
              2: "South"
              3: "Overseas"
        - id: q_age
          kind: Question
          title: "How old are you?"
          postcondition:
            - predicate: "q_age.outcome == 30"
              hint: "Only thirty-year-olds."
          input:
            control: Editbox
            min: 18
            max: 99
        - id: q_match
          kind: Question
          title: "Confirm the building type"
          postcondition:
            - predicate: "q_match.outcome == q_building.outcome"
              hint: "Must match your earlier answer."
          input:
            control: Radio
            labels:
              1: "A mobile home"
              2: "A one-family house"
              3: "An apartment building"
        - id: q_confirm
          kind: Question
          title: "Is the building owner-occupied?"
          postcondition:
            - predicate: "q_confirm.outcome == 1 or q_building.outcome == 3"
              hint: "Only an apartment building may be rented out."
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_cover
          kind: Question
          title: "Which health coverage do you have?"
          input:
            control: Checkbox
            labels:
              1: "Employer plan"
              2: "Medicare"
              4: "No health insurance or health coverage plan"
        - id: q_cover_guarded
          kind: Question
          title: "Which health coverage does your partner have?"
          postcondition:
            - predicate: "(q_cover_guarded.outcome // 4) % 2 == 0 or q_cover_guarded.outcome == 4"
              hint: "Untick the other options if your partner has no coverage."
          input:
            control: Checkbox
            labels:
              1: "Employer plan"
              2: "Medicare"
              4: "None of the above"
        - id: q_cover_leaky
          kind: Question
          title: "Which health coverage did your parents have?"
          postcondition:
            - predicate: "(q_cover_leaky.outcome // 4) % 2 == 0 or q_cover_leaky.outcome >= 4"
              hint: "A guard with a hole in it."
          input:
            control: Checkbox
            labels:
              1: "Employer plan"
              2: "Medicare"
              4: "None of the above"
        - id: q_cover_relational
          kind: Question
          title: "Which coverage did you have last year?"
          postcondition:
            - predicate: "q_cover_relational.outcome != q_cover.outcome or q_cover.outcome == 4"
              hint: "Tell us if it changed."
          input:
            control: Checkbox
            labels:
              1: "Employer plan"
              2: "Medicare"
              4: "Neither"
        - id: q_unsure
          kind: Question
          title: "Which symptoms did you notice?"
          input:
            control: Checkbox
            labels:
              1: "Cough"
              2: "Fever"
              4: "Not sure"
        - id: q_nested
          kind: Question
          title: "How many floors?"
          input:
            control: Editbox
            min: 1
            max: 50
          codeBlock: |
            if q_nested.outcome > 1:
                q_nested.outcome = q_nested.outcome
        - id: q_tier
          kind: Question
          title: "Which tier applies?"
          postcondition:
            - predicate: "q_tier.outcome != 1"
              hint: "Tier 1 is closed."
            - predicate: "q_tier.outcome != 2"
              hint: "Tier 2 is closed."
          input:
            control: Radio
            labels:
              1: "Tier 1"
              2: "Tier 2"
              3: "Tier 3"
        - id: q_group_cover
          kind: QuestionGroup
          title: "Which coverage does each child have?"
          questions:
            - "First child"
            - "Second child"
          input:
            control: Checkbox
            labels:
              1: "Employer plan"
              2: "Medicare"
              4: "None of the above"
    - id: b_guarded
      title: "Guarded on the block"
      postcondition:
        - predicate: "(q_cover_block.outcome // 4) % 2 == 0 or q_cover_block.outcome == 4"
          hint: "Untick the other options if you have no coverage."
      items:
        - id: q_cover_block
          kind: Question
          title: "Which coverage did you have as a student?"
          input:
            control: Checkbox
            labels:
              1: "Employer plan"
              2: "Medicare"
              4: "None of the above"
