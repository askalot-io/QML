questionnaire:
  title: "Quality Scorecard - Tautological Gates and Dead Weight"
  codeInit: |
    unused_var = 5
  blocks:
    - id: main
      title: "Main"
      items:
        # Postcondition restates the Radio domain (labels are 1..2, so
        # ``>= 1`` always holds) — classifies TAUTOLOGICAL, enforcing nothing.
        - id: q_choice
          kind: Question
          title: "Pick one"
          postcondition:
            - predicate: "q_choice.outcome >= 1"
              hint: "Always true"
          input:
            control: Radio
            labels:
              1: A
              2: B
        # Postcondition restates the control's own min/max exactly — the
        # duplicate_input_bound hygiene signal.
        - id: q_num
          kind: Question
          title: "Pick a number"
          postcondition:
            - predicate: "q_num.outcome >= 0 and q_num.outcome <= 10"
              hint: "Within range"
          codeBlock: |
            alias_val = q_num.outcome
          input:
            control: Editbox
            min: 0
            max: 10
        # Reads alias_val so the alias is not write-only — it fires the
        # pass_through_alias lint instead (single bare outcome copy).
        - id: q_follow
          kind: Question
          title: "Follow-up"
          precondition:
            - predicate: "alias_val >= 5"
              hint: "High number chosen"
          input:
            control: Radio
            labels:
              1: A
              2: B
