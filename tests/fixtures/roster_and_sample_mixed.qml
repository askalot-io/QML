qmlVersion: "1.0"
questionnaire:
  title: "Mixed Roster + Sample — state-key collision regression"
  # U6 cross-consumer regression fixture. One survey carries BOTH a Roster
  # block (writes the sibling state['roster_outcomes'] map + paired
  # state['history_iter_key']) and a Sample block (writes the FROZEN
  # state['sample_order'] + transient state['sample_asked'], with Sample
  # history entries carrying iter_key=None). The two state shapes must
  # round-trip through QMLState serialization without colliding, and the
  # Bronze extractor must produce a well-formed row where Roster cells are
  # bit-keyed columns and Sample drawn items are plain scalar columns while
  # non-drawn Sample items are ABSENT (no spurious blank cell).
  blocks:
    - id: count_block
      kind: Sequence
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

    # count=2, is_random false → exactly the first two declared inner items
    # are drawn (q_pref_a, q_pref_b); q_pref_c is NEVER drawn → it must be
    # absent from the Bronze row, not a blank-answered cell.
    - id: pref_sample
      kind: Sample
      title: "Preference questions"
      count: 2
      is_random: false
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
      kind: Sequence
      title: "Outro"
      items:
        - id: q_thanks
          kind: Question
          title: "Anything else?"
          input:
            control: Textarea
