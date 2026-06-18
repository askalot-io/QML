qmlVersion: "2.0"
questionnaire:
  title: "Mixed Roster + capped Group — state-key collision regression"
  # Cross-consumer regression fixture. One survey carries BOTH a Roster block
  # (writes the sibling state['roster_outcomes'] map + paired
  # state['history_iter_key']) and a capped Group block (writes transient
  # state['group_asked'], with Group history entries carrying iter_key=None).
  # The two state shapes must round-trip through QMLState serialization without
  # colliding, and the Bronze extractor must produce a well-formed row where
  # Roster cells are bit-keyed columns and drawn Group items are plain scalar
  # columns while non-drawn Group items are ABSENT (no spurious blank cell).
  blocks:
    - id: count_block
      kind: Group
      title: "Household"
      items:
        - id: q_family_count
          kind: Question
          title: "How many family members do you have?"
          input:
            control: Editbox
            min: 1
            max: 4
          codeBlock: |
            # Low-N-bits bitmask via plain math (no shift operator).
            family_mask = 2 ** q_family_count.outcome - 1

    - id: per_member
      kind: Roster
      title: "Family member details"
      iterateOver: "family_mask"
      labels:
        1: "Member 1"
        2: "Member 2"
        4: "Member 3"
        8: "Member 4"
      items:
        - id: q_member_name
          kind: Question
          title: "Name?"
          input:
            control: Editbox
            min: 0
            max: 100
        - id: q_member_age
          kind: Question
          title: "Age?"
          input:
            control: Editbox
            min: 0
            max: 120

    # count=2 capped Group → exactly the first two items in canonical order
    # are drawn (q_pref_a, q_pref_b); q_pref_c is NEVER drawn → it must be
    # absent from the Bronze row, not a blank-answered cell.
    - id: pref_sample
      kind: Group
      title: "Preference questions"
      count: 2
      items:
        - id: q_pref_a
          kind: Question
          title: "Preferred contact channel?"
          input:
            control: Radio
            labels:
              1: "Email"
              2: "Phone"
        - id: q_pref_b
          kind: Question
          title: "Preferred contact time?"
          input:
            control: Radio
            labels:
              1: "Morning"
              2: "Evening"
        - id: q_pref_c
          kind: Question
          title: "Preferred language?"
          input:
            control: Radio
            labels:
              1: "EN"
              2: "HU"

    - id: outro_block
      kind: Group
      title: "Outro"
      items:
        - id: q_thanks
          kind: Question
          title: "Anything else?"
          input:
            control: Textarea
