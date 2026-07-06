# Hygiene lints + postcondition-coverage fixture (U3).
#
# Exercises the three WARNING-severity hygiene lints and the relational-vs-local
# postcondition coverage counts in one questionnaire. Every finding here is a
# warning — the file has zero error-severity issues, so it stays is_valid=True
# through Portor's error-only gate.
#
# State-variable hygiene (from the U1 read/write census):
#   - `num_children = q_a1_num_children.outcome` on q_a1_num_children — a single
#     bare-outcome assignment read once by q_kids_detail → pass_through_alias WARN
#     (reference q_a1_num_children.outcome directly instead).
#   - `months = q_age.outcome * 12` on q_age — a TRANSFORMED derivation, read by
#     q_adult → NOT an alias (bare_outcome_item is None), no warning.
#   - `path` assigned in two codeBlocks (q_p1, q_p2), never read anywhere →
#     write_only WARN.
#   - `status` written by two mutually exclusive producers (q_s1, q_s2) and read
#     by q_status_detail → consolidation, NOT an alias (two assignments), no
#     warning.
#
# Postcondition coverage (item-level postconditions only):
#   - q_falls: `q_falls.outcome <= q_total_falls.outcome` → RELATIONAL (references
#     another item's outcome).
#   - q_diag_age: `q_diag_age.outcome <= months` → RELATIONAL (references a
#     variable).
#   - q_pct: `q_pct.outcome >= 0 and q_pct.outcome <= 100` → LOCAL, and it merely
#     restates the Slider's own min/max → duplicate_input_bound WARN.
#   => relational: 2, local: 1.
qmlVersion: "2.0"

questionnaire:
  title: "Hygiene Lints Fixture"
  blocks:
    - id: b_derive
      kind: Group
      title: "Derived variables"
      items:
        - id: q_a1_num_children
          kind: Question
          title: "How many children live in your household?"
          input:
            control: Editbox
            min: 0
            max: 10
          codeBlock: |
            num_children = q_a1_num_children.outcome
        - id: q_kids_detail
          kind: Question
          title: "Do any children attend school?"
          precondition:
            - predicate: "num_children >= 1"
              hint: "Only asked when there is at least one child"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_age
          kind: Question
          title: "What is your age in years?"
          input:
            control: Editbox
            min: 0
            max: 120
          codeBlock: |
            months = q_age.outcome * 12
        - id: q_adult
          kind: Question
          title: "Are you legally an adult?"
          precondition:
            - predicate: "months >= 216"
              hint: "Asked once the respondent is at least 18 (216 months)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
    - id: b_state
      kind: Group
      title: "Routing state"
      items:
        - id: q_p1
          kind: Question
          title: "Are you currently employed?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            path = 1
        - id: q_p2
          kind: Question
          title: "Are you currently studying?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            path = 2
        - id: q_s1
          kind: Question
          title: "Do you own your home?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            status = 1
        - id: q_s2
          kind: Question
          title: "Do you rent your home?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            status = 2
        - id: q_status_detail
          kind: Question
          title: "How long have you held this housing status?"
          precondition:
            - predicate: "status == 1"
              hint: "Only asked for owners"
          input:
            control: Radio
            labels:
              1: "Under a year"
              2: "A year or more"
    - id: b_bounds
      kind: Group
      title: "Bounded measures"
      items:
        - id: q_total_falls
          kind: Question
          title: "How many times did you fall in the past year?"
          input:
            control: Editbox
            min: 0
            max: 50
        - id: q_falls
          kind: Question
          title: "Of those, how many caused an injury?"
          input:
            control: Editbox
            min: 0
            max: 50
          postcondition:
            - predicate: "q_falls.outcome <= q_total_falls.outcome"
              hint: "Injurious falls cannot exceed total falls"
        - id: q_diag_age
          kind: Question
          title: "At what age were you first diagnosed?"
          input:
            control: Editbox
            min: 0
            max: 120
          postcondition:
            - predicate: "q_diag_age.outcome <= months"
              hint: "Diagnosis age cannot exceed your current age"
        - id: q_pct
          kind: Question
          title: "What percentage of your income do you save?"
          input:
            control: Slider
            min: 0
            max: 100
          postcondition:
            - predicate: "q_pct.outcome >= 0 and q_pct.outcome <= 100"
              hint: "Enter a value between 0 and 100"
