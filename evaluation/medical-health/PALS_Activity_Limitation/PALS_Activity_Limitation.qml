qmlVersion: "1.0"
questionnaire:
  title: "Participation and Activity Limitation Survey"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    limitation_general = 0
    limitation_hearing = 0
    limitation_seeing = 0
    limitation_communicating = 0
    limitation_walking = 0
    limitation_hands = 0
    limitation_learning = 0
    limitation_developmental = 0
    limitation_emotional = 0
    limitation_chronic = 0
    use_aid_hearing = 0
    use_aid_seeing = 0
    use_aid_communicating = 0
    use_aid_walking = 0
    use_aid_hands = 0
    use_aid_learning = 0
    use_aid_chronic = 0
    need_aid_hearing = 0
    need_aid_seeing = 0
    need_aid_communicating = 0
    need_aid_walking = 0
    need_aid_hands = 0
    need_aid_learning = 0
    need_aid_chronic = 0
    limitation_count = 0
    use_aid_count = 0
    need_aid_count = 0
    hearing_has_limitation = 0
    seeing_has_limitation = 0
    seeing_a_lot = 0
    comm_has_difficulty_speaking = 0
    comm_cannot_speak = 0
    comm_has_limitation = 0
    has_any_chronic = 0
    b80_any_seen = 0
    b76_gave_amount = 0
    b82_gave_amount = 0
    b91_gave_amount = 0
    c9_any_yes = 0
    c12_any_yes = 0
    c17_any_yes = 0
    c22_any_yes = 0
    c15_dk = 0
    e1_path = 0
    e4_ever_school = 0
    e6_special_school = 0
    e7_class_type = 0
    e8_ever_special = 0
    e13_province = 0
    is_kindergarten = 0
    e25_used_features = 0
    e27_needed_features = 0
    e30_unmet_aids = 0
    e37_assessment = 0
    dk_i9 = 0

  blocks:

    # ===================================================================
    # SECTION: filter_questions
    # ===================================================================
    - id: b_filter_questions
      title: "Filter Questions"
      items:
        - id: q_a1
          kind: Question
          title: "Does ..... have any DIFFICULTY hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"

        - id: q_a2a
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do at home?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"

        - id: q_a2b
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do at work or at school?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"
              5: "Not applicable"

        - id: q_a2c
          kind: Question
          title: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do in other activities, for example, transportation or leisure?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often"
              3: "No"
          codeBlock: |
            if q_a1.outcome == 1 or q_a1.outcome == 2:
                limitation_general = 1
            if q_a2a.outcome == 1 or q_a2a.outcome == 2:
                limitation_general = 1
            if q_a2b.outcome == 1 or q_a2b.outcome == 2:
                limitation_general = 1
            if q_a2c.outcome == 1 or q_a2c.outcome == 2:
                limitation_general = 1

    # ===================================================================
    # SECTION: activity_limitations
    # ===================================================================
    # =====================================================================
    # HEARING SUBSECTION (B1–B10)
    # =====================================================================
    - id: b_hearing
      title: "Hearing"
      items:
        # B1: Uses hearing aid?
        - id: q_b1
          kind: Question
          title: "I'm going to ask you about the child's ability to do certain activities. Please tell me only about those difficulties that have lasted, or are expected to last six months or more. Does the child use a hearing aid or hearing aids?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B2: WITH hearing aid, ability to hear?
        # Shown if B1=Yes(1) or B1=No(3) — i.e., not DK/R
        - id: q_b2
          kind: Question
          title: "WITH HEARING AID(S), how would you describe the child's ability to hear?"
          precondition:
            - predicate: q_b1.outcome == 1 or q_b1.outcome == 3
          input:
            control: Radio
            labels:
              1: "Child has no problem hearing"
              2: "Child has difficulty hearing"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b2.outcome == 2:
                limitation_hearing = 1
                hearing_has_limitation = 1

        # B3: How much difficulty? (follows B2=difficulty)
        - id: q_b3
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: q_b2.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"
              8: "Don't know"
              9: "Refusal"

        # B4: WITHOUT hearing aid, ability to hear?
        # Shown if B1=DK(8) or B1=Refusal(9) — skipped to B4
        - id: q_b4
          kind: Question
          title: "How would you describe the child's ability to hear?"
          precondition:
            - predicate: q_b1.outcome == 8 or q_b1.outcome == 9
          input:
            control: Radio
            labels:
              1: "Child has no problem hearing"
              2: "Child has difficulty hearing"
              3: "Child cannot hear"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b4.outcome == 2 or q_b4.outcome == 3:
                limitation_hearing = 1
                hearing_has_limitation = 1

        # B5: How much difficulty? (follows B4=difficulty)
        - id: q_b5
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: q_b4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"
              8: "Don't know"
              9: "Refusal"

        # B6: USE aids for hearing? (age >= 5 only, and hearing limitation found)
        # B6.edit: if child_under_5, skip to B11
        # Reaches B6 only if hearing limitation was marked (B2=2 or B4=2/3)
        - id: q_b6
          kind: Question
          title: "Does the child USE any aids, specialized equipment or services for children with hearing difficulties, for example, a volume control telephone or T.V. decoder?"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: hearing_has_limitation == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b6.outcome == 1:
                use_aid_hearing = 1

        # B7: Which aids does child USE? (hearing)
        - id: qg_b7
          kind: QuestionGroup
          title: "Does the child now use:"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: hearing_has_limitation == 1
            - predicate: q_b6.outcome == 1 or q_b6.outcome == 3
          questions:
            - "A volume control telephone"
            - "A closed caption TV or decoder"
            - "A TTY or TDD"
            - "An amplifier, such as FM or infrared"
            - "A computer to communicate (e.g. e-mail or chat service)"
            - "A Sign language interpreter"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B8: NEED aids for hearing?
        - id: q_b8
          kind: Question
          title: "Are there any aids or services for children with hearing difficulties that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: hearing_has_limitation == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b8.outcome == 1:
                need_aid_hearing = 1

        # B9: Which aids does child NEED? (hearing)
        - id: qg_b9
          kind: QuestionGroup
          title: "Which aids or services does the child NEED, but does not have?"
          precondition:
            - predicate: q_b8.outcome == 1
          questions:
            - "A hearing aid or hearing aids"
            - "A volume control telephone"
            - "A closed caption T.V. or decoder"
            - "A TTY or TDD"
            - "An amplifier, such as FM or infrared"
            - "A computer to communicate (e.g. e-mail or chat service)"
            - "A Sign language interpreter"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B10: Communication skills (sign language, lip reading)
        - id: qg_b10
          kind: QuestionGroup
          title: "This question deals with certain communication skills. Does the child:"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: hearing_has_limitation == 1
          questions:
            - "Use Sign Language, such as ASL or LSQ"
            - "Speech read or lip read"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # VISION SUBSECTION (B11–B20)
    # =====================================================================
    - id: b_vision
      title: "Vision"
      items:
        # B11: Wears glasses/contacts?
        - id: q_b11
          kind: Question
          title: "Does the child wear glasses or contact lenses to see up close or at a distance?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B12: WITH glasses, vision ability?
        - id: q_b12
          kind: Question
          title: "WITH GLASSES or CONTACT LENSES, how would you describe the child's vision ability?"
          precondition:
            - predicate: q_b11.outcome == 1 or q_b11.outcome == 3
          input:
            control: Radio
            labels:
              1: "Child has no problem seeing"
              2: "Child has difficulty seeing"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b12.outcome == 2:
                limitation_seeing = 1
                seeing_has_limitation = 1

        # B13: How much difficulty? (with glasses)
        - id: q_b13
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: q_b12.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b13.outcome == 2:
                seeing_a_lot = 1

        # B14: WITHOUT glasses, vision ability?
        - id: q_b14
          kind: Question
          title: "How would you describe the child's vision ability?"
          precondition:
            - predicate: q_b11.outcome == 8 or q_b11.outcome == 9
          input:
            control: Radio
            labels:
              1: "Child has no problem seeing"
              2: "Child has difficulty seeing"
              3: "Child cannot see"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b14.outcome == 2 or q_b14.outcome == 3:
                limitation_seeing = 1
                seeing_has_limitation = 1
            if q_b14.outcome == 3:
                seeing_a_lot = 1

        # B15: How much difficulty? (without glasses)
        - id: q_b15
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: q_b14.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b15.outcome == 2:
                seeing_a_lot = 1

        # B16: Legally blind diagnosis?
        # Reached only with seeing limitation AND "a lot of difficulty" or "cannot see"
        # AND not under 5
        # B13.edit/B15.edit: under-5 → B51; B16.edit: under-5 → B51
        # B13 some difficulty → B13.edit (under-5→B51, else→B21)
        # B13 a lot → B16.edit (under-5→B51, else→B16)
        # So B16 is reached only when seeing_a_lot==1 AND child_under_5==0
        - id: q_b16
          kind: Question
          title: "Has the child been diagnosed by an eye specialist as being legally blind?"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: seeing_a_lot == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B17: USE aids for vision?
        # Shown when seeing limitation exists AND not under 5 AND a lot of difficulty
        - id: q_b17
          kind: Question
          title: "Does the child USE any aids or specialized equipment for children with vision difficulties, for example, magnifiers or Braille reading materials?"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: seeing_a_lot == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b17.outcome == 1:
                use_aid_seeing = 1

        # B18: Which aids does child USE? (vision)
        - id: qg_b18
          kind: QuestionGroup
          title: "Does the child now use:"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: seeing_a_lot == 1
            - predicate: q_b17.outcome == 1 or q_b17.outcome == 3
          questions:
            - "Magnifiers"
            - "Braille reading materials"
            - "Large print reading materials"
            - "Talking books"
            - "Recording equipment"
            - "A closed circuit TV"
            - "A computer with Braille, large print, or speech access"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B19: NEED aids for vision?
        - id: q_b19
          kind: Question
          title: "Are there any aids or specialized equipment for children with vision difficulties that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: seeing_a_lot == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b19.outcome == 1:
                need_aid_seeing = 1

        # B20: Which aids does child NEED? (vision)
        - id: qg_b20
          kind: QuestionGroup
          title: "Which aids does the child NEED, but does not have?"
          precondition:
            - predicate: q_b19.outcome == 1
          questions:
            - "Glasses or contact lenses"
            - "Magnifiers"
            - "Braille reading materials"
            - "Large print reading materials"
            - "Talking books"
            - "Recording equipment"
            - "A closed circuit TV"
            - "A computer with Braille, large print, or speech access"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # COMMUNICATION SUBSECTION (B21–B30)
    # Routing: under-5 children skip this entirely (B13.edit/B15.edit → B51)
    # For age >= 5: from vision subsection, reach B21 when:
    #   - no seeing limitation (B12=1/DK/R → B13.edit → B21)
    #   - some seeing difficulty not a lot (B13=1 → B13.edit → B21)
    #   - B14=1/DK/R → B15.edit → B21
    #   - B15=1 → B15.edit → B21
    #   - after B16-B20 vision aids section → B21
    # So for age >= 5, everyone reaches B21 eventually
    # =====================================================================
    - id: b_communication
      title: "Communication"
      precondition:
        - predicate: child_under_5 == 0
      items:
        # B21: Difficulty speaking?
        - id: q_b21
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty speaking?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b21.outcome == 1:
                limitation_communicating = 1
                comm_has_limitation = 1
                comm_has_difficulty_speaking = 1

        # B22: Difficulty making understood? (only if B21=No/DK/R)
        # B21=Yes → skip to B23
        - id: q_b22
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty making himself/herself understood when speaking?"
          precondition:
            - predicate: q_b21.outcome != 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b22.outcome == 1:
                limitation_communicating = 1
                comm_has_limitation = 1

        # B23: How much difficulty speaking?
        # Shown if B21=Yes (has difficulty speaking)
        - id: q_b23
          kind: Question
          title: "How much difficulty does the child have speaking?"
          precondition:
            - predicate: q_b21.outcome == 1
          input:
            control: Radio
            labels:
              1: "Child has some difficulty"
              2: "Child has a lot of difficulty"
              3: "Child cannot speak"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b23.outcome == 3:
                comm_cannot_speak = 1

        # B24: Difficulty making understood? (after B23, if child can speak)
        # B23=cannot speak(3) → skip to B26
        - id: q_b24
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty making himself/herself understood when speaking?"
          precondition:
            - predicate: q_b21.outcome == 1
            - predicate: q_b23.outcome != 3 and q_b23.outcome != 8 and q_b23.outcome != 9
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B25: How well understood when speaking? (sub-items: family, friends, others)
        # Reached if: B22=Yes(1) → B25, or B24=Yes(1) → B25
        - id: qg_b25
          kind: QuestionGroup
          title: "How well do you feel the child is able to make himself/herself understood when speaking with:"
          precondition:
            - predicate: (q_b21.outcome != 1 and q_b22.outcome == 1) or (q_b21.outcome == 1 and q_b23.outcome != 3 and q_b23.outcome != 8 and q_b23.outcome != 9 and q_b24.outcome == 1)
          questions:
            - "Family members"
            - "Friends"
            - "Other people"
          input:
            control: Radio
            labels:
              1: "Completely"
              2: "Partially"
              3: "Not at all"

        # B26: Uses sign language or other communication?
        # Reached by all children with communication limitation
        # (B21=Yes path OR B22=Yes path OR B23=cannot speak)
        - id: qg_b26
          kind: QuestionGroup
          title: "Does the child use:"
          precondition:
            - predicate: comm_has_limitation == 1
          questions:
            - "Sign language, such as ASL or LSQ"
            - "Other form of communication"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B27: USE aids for communication?
        - id: q_b27
          kind: Question
          title: "Does the child USE any aids or specialized equipment for children who have difficulty speaking or making themselves understood, for example, a voice amplifier or Blissboard?"
          precondition:
            - predicate: comm_has_limitation == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b27.outcome == 1:
                use_aid_communicating = 1

        # B28: Which aids does child USE? (communication)
        - id: qg_b28
          kind: QuestionGroup
          title: "Does the child now use:"
          precondition:
            - predicate: q_b27.outcome == 1 or q_b27.outcome == 3
          questions:
            - "A voice amplifier"
            - "A computer or keyboard device to communicate"
            - "A communication board, such as a Blissboard"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B29: NEED aids for communication?
        - id: q_b29
          kind: Question
          title: "Are there any aids or specialized equipment for children who have difficulty speaking or making themselves understood that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: comm_has_limitation == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b29.outcome == 1:
                need_aid_communicating = 1

        # B30: Which aids does child NEED? (communication)
        - id: qg_b30
          kind: QuestionGroup
          title: "Which aids does the child NEED, but does not have?"
          precondition:
            - predicate: q_b29.outcome == 1
          questions:
            - "A voice amplifier"
            - "A computer or keyboard device to communicate"
            - "A communication board, such as a Blissboard"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # WALKING/MOBILITY SUBSECTION (B31–B36)
    # Everyone age >= 5 reaches B31; under-5 are in b_communication block
    # which is gated, but B31 is in its own block with same gate
    # =====================================================================
    - id: b_walking
      title: "Walking / Mobility"
      precondition:
        - predicate: child_under_5 == 0
      items:
        # B31: Difficulty walking?
        - id: q_b31
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty walking? This means walking on a flat firm surface, such as a sidewalk or floor."
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b31.outcome == 1 or q_b31.outcome == 2:
                limitation_walking = 1

        # B32: How much difficulty walking?
        - id: q_b32
          kind: Question
          title: "How much difficulty does the child have walking?"
          precondition:
            - predicate: q_b31.outcome == 1 or q_b31.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"
              3: "Child cannot walk"
              8: "Don't know"
              9: "Refusal"

        # B33: USE aids for walking?
        - id: q_b33
          kind: Question
          title: "Does the child USE any aids or specialized equipment for children who have difficulty walking or moving around, such as a cane or crutches?"
          precondition:
            - predicate: q_b31.outcome == 1 or q_b31.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b33.outcome == 1:
                use_aid_walking = 1

        # B34: Which aids does child USE? (walking)
        - id: qg_b34
          kind: QuestionGroup
          title: "Does the child now use:"
          precondition:
            - predicate: q_b33.outcome == 1 or q_b33.outcome == 3
          questions:
            - "Orthopaedic or medically prescribed shoes"
            - "A cane or crutches"
            - "A walker"
            - "A manual wheelchair"
            - "An electric wheelchair"
            - "Braces, such as a leg brace (exclude dental braces)"
            - "Lift devices, such as a bed lift device"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B35: NEED aids for walking?
        - id: q_b35
          kind: Question
          title: "Are there any aids or specialized equipment for children who have difficulty walking or moving around that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: q_b31.outcome == 1 or q_b31.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b35.outcome == 1:
                need_aid_walking = 1

        # B36: Which aids does child NEED? (walking)
        - id: qg_b36
          kind: QuestionGroup
          title: "Which aids does the child NEED, but does not have?"
          precondition:
            - predicate: q_b35.outcome == 1
          questions:
            - "Orthopaedic or medically prescribed shoes"
            - "A cane or crutches"
            - "A walker"
            - "A manual wheelchair"
            - "An electric wheelchair"
            - "Braces, such as a leg brace (exclude dental braces)"
            - "Lift devices, such as a bed lift device"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # HANDS/FINGERS SUBSECTION (B37–B42)
    # =====================================================================
    - id: b_hands
      title: "Hands / Fingers"
      precondition:
        - predicate: child_under_5 == 0
      items:
        # B37: Difficulty using hands/fingers?
        - id: q_b37
          kind: Question
          title: "Because of a condition or health problem, does the child have any difficulty USING his/her HANDS or FINGERS to grasp or hold small objects, such as a pencil or scissors?"
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b37.outcome == 1 or q_b37.outcome == 2:
                limitation_hands = 1

        # B38: How much difficulty?
        - id: q_b38
          kind: Question
          title: "How much difficulty?"
          precondition:
            - predicate: q_b37.outcome == 1 or q_b37.outcome == 2
          input:
            control: Radio
            labels:
              1: "Some difficulty"
              2: "A lot of difficulty"
              3: "Completely unable"
              8: "Don't know"
              9: "Refusal"

        # B39: USE aids for hands/fingers?
        - id: q_b39
          kind: Question
          title: "Does the child USE any aids or specialized equipment designed to support, replace or assist in the use of hands or fingers, such as a hand or arm brace, or grasping tools?"
          precondition:
            - predicate: q_b37.outcome == 1 or q_b37.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b39.outcome == 1:
                use_aid_hands = 1

        # B40: Which aids does child USE? (hands)
        - id: qg_b40
          kind: QuestionGroup
          title: "Does the child now use:"
          precondition:
            - predicate: q_b39.outcome == 1
          questions:
            - "A hand or arm brace"
            - "Grasping tools or reach extenders"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B41: NEED aids for hands/fingers?
        - id: q_b41
          kind: Question
          title: "Are there any aids or specialized equipment designed to support, replace or assist in the use of hands or fingers that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: q_b37.outcome == 1 or q_b37.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b41.outcome == 1:
                need_aid_hands = 1

        # B42: Which aids does child NEED? (hands)
        - id: qg_b42
          kind: QuestionGroup
          title: "Which aids does the child NEED, but does not have?"
          precondition:
            - predicate: q_b41.outcome == 1
          questions:
            - "A hand or arm brace"
            - "Grasping tools or reach extenders"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # LEARNING DISABILITY SUBSECTION (B43–B50)
    # =====================================================================
    - id: b_learning
      title: "Learning Disability"
      precondition:
        - predicate: child_under_5 == 0
      items:
        # B43: Think child has learning disability?
        - id: q_b43
          kind: Question
          title: "Do you think that the child has a learning disability, such as dyslexia, hyperactivity or attention problems?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b43.outcome == 1:
                limitation_learning = 1

        # B44: Professional ever said learning disability?
        - id: q_b44
          kind: Question
          title: "Has a teacher, doctor or other health professional ever said that the child had a learning disability?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b44.outcome == 1:
                limitation_learning = 1

        # B45: Does condition reduce activities?
        # B45.edit: only if B43=Yes OR B44=Yes
        - id: q_b45
          kind: Question
          title: "Does this condition reduce the amount or the kind of activities the child can do?"
          precondition:
            - predicate: q_b43.outcome == 1 or q_b44.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B46: How many activities prevented? (3 sub-items)
        - id: qg_b46
          kind: QuestionGroup
          title: "How many ACTIVITIES does this condition USUALLY prevent the child from doing:"
          precondition:
            - predicate: q_b45.outcome == 1 or q_b45.outcome == 2 or q_b45.outcome == 3
          questions:
            - "At home"
            - "At school"
            - "At play or recreational activities"
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Many"
              4: "Most"

        # B47: USE aids for learning?
        - id: q_b47
          kind: Question
          title: "Does the child USE any aids, specialized equipment or services to help with the learning difficulty?"
          precondition:
            - predicate: q_b43.outcome == 1 or q_b44.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b47.outcome == 1:
                use_aid_learning = 1

        # B48: Which aids does child USE? (learning)
        - id: qg_b48
          kind: QuestionGroup
          title: "Does the child now use:"
          precondition:
            - predicate: q_b47.outcome == 1 or q_b47.outcome == 3
          questions:
            - "A computer as a learning aid"
            - "Voice activated or voice synthesis computer software"
            - "Talking books"
            - "Recording equipment"
            - "A tutor"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B49: NEED aids for learning?
        - id: q_b49
          kind: Question
          title: "Are there any learning aids, specialized equipment or services that the child CURRENTLY needs, but does not have?"
          precondition:
            - predicate: q_b43.outcome == 1 or q_b44.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b49.outcome == 1:
                need_aid_learning = 1

        # B50: Which aids does child NEED? (learning)
        - id: qg_b50
          kind: QuestionGroup
          title: "Which aids or services does the child NEED, but does not have?"
          precondition:
            - predicate: q_b49.outcome == 1
          questions:
            - "A computer as a learning aid"
            - "Voice activated or voice synthesis computer software"
            - "Talking books"
            - "Recording equipment"
            - "A tutor"
            - "Other aid"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # DEVELOPMENTAL DELAY SUBSECTION (B51–B55)
    # B51.edit: under-5 → B51; age >= 5 → B53
    # B53.edit: under-5 → B59; age >= 5 → B53
    # So B51-B52 are for UNDER-5 children only
    # B53-B55 are for age >= 5 children only
    # =====================================================================
    - id: b_developmental
      title: "Developmental Delay / Disability"
      items:
        # B51: Delay in development? (under-5 only)
        - id: q_b51
          kind: Question
          title: "Because of a condition or health problem, does the child have a delay in his/her development, either a physical, intellectual or another type of delay?"
          precondition:
            - predicate: child_under_5 == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b51.outcome == 1:
                limitation_developmental = 1

        # B52: What kind of delay? (under-5 only, B51=Yes or No)
        - id: qg_b52
          kind: QuestionGroup
          title: "What kind of delay is this? Please answer yes or no to each."
          precondition:
            - predicate: child_under_5 == 1
            - predicate: q_b51.outcome == 1 or q_b51.outcome == 3
          questions:
            - "A delay in his/her PHYSICAL development"
            - "A delay in his/her INTELLECTUAL development"
            - "Other type of delay"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B53: Professional said developmental disability? (age >= 5 only)
        # B53.edit: under-5 → B59, age >= 5 → B53
        - id: q_b53
          kind: Question
          title: "Has a doctor, psychologist or other health professional ever said that the child has a developmental disability or disorder? These may include autism, Down syndrome, or mental impairment due to a lack of oxygen at birth."
          precondition:
            - predicate: child_under_5 == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b53.outcome == 1:
                limitation_developmental = 1

        # B54: Does condition reduce activities? (age >= 5)
        - id: q_b54
          kind: Question
          title: "Does this condition reduce the amount or the kind of activities the child can do?"
          precondition:
            - predicate: child_under_5 == 0
            - predicate: q_b53.outcome == 1 or q_b53.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B55: How many activities prevented? (age >= 5)
        - id: qg_b55
          kind: QuestionGroup
          title: "How many ACTIVITIES does this condition USUALLY prevent the child from doing:"
          precondition:
            - predicate: q_b54.outcome == 1 or q_b54.outcome == 2 or q_b54.outcome == 3
          questions:
            - "At home"
            - "At school"
            - "At play or recreational activities"
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Many"
              4: "Most"

    # =====================================================================
    # EMOTIONAL/PSYCHOLOGICAL SUBSECTION (B56–B58)
    # =====================================================================
    - id: b_emotional
      title: "Emotional / Psychological"
      items:
        # B56: Any emotional/psychological/behavioural conditions?
        - id: q_b56
          kind: Question
          title: "Does the child have any emotional, psychological or behavioural conditions that have lasted or are expected to last six months or more?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B57: Does condition reduce activities?
        - id: q_b57
          kind: Question
          title: "Does this condition reduce the amount or the kind of activities the child can do?"
          precondition:
            - predicate: q_b56.outcome == 1 or q_b56.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b57.outcome == 1 or q_b57.outcome == 2:
                limitation_emotional = 1

        # B58: How many activities prevented?
        - id: qg_b58
          kind: QuestionGroup
          title: "How many ACTIVITIES does this condition USUALLY prevent the child from doing:"
          precondition:
            - predicate: q_b57.outcome == 1 or q_b57.outcome == 2
          questions:
            - "At home"
            - "At school"
            - "At play or recreational activities"
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Many"
              4: "Most"

    # =====================================================================
    # CHRONIC CONDITIONS SUBSECTION (B59–B61)
    # =====================================================================
    - id: b_chronic
      title: "Chronic Conditions"
      items:
        # B59: Long-term diagnosed conditions checklist (20 sub-items)
        - id: qg_b59
          kind: QuestionGroup
          title: "Does the child have any of the following LONG-TERM conditions which have been DIAGNOSED by a health professional?"
          questions:
            - "Asthma or severe allergies"
            - "Heart condition or disease"
            - "Kidney condition or disease"
            - "Cancer"
            - "Diabetes"
            - "Epilepsy"
            - "Autism"
            - "Cerebral Palsy"
            - "Spina Bifida"
            - "Cystic Fibrosis"
            - "Muscular Dystrophy"
            - "Migraines"
            - "Arthritis or rheumatism"
            - "Paralysis of any kind"
            - "Missing or malformed arms, legs, fingers or toes"
            - "Fetal Alcohol Syndrome"
            - "Attention Deficit Disorder (ADD) or ADHD"
            - "Down syndrome"
            - "Complex medical care needs"
            - "Any other long-term condition diagnosed by a health professional"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            has_any_chronic = 0
            if qg_b59.outcome[0] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[1] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[2] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[3] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[4] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[5] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[6] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[7] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[8] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[9] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[10] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[11] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[12] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[13] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[14] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[15] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[16] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[17] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[18] == 1:
                has_any_chronic = 1
            if qg_b59.outcome[19] == 1:
                has_any_chronic = 1

        # B60: Does condition reduce activities?
        # B60.edit: only if any B59 = Yes
        - id: q_b60
          kind: Question
          title: "Does this condition (do these conditions) reduce the amount or the kind of activities the child can do?"
          precondition:
            - predicate: has_any_chronic == 1
          input:
            control: Radio
            labels:
              1: "Yes, sometimes"
              2: "Yes, often or always"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b60.outcome == 1 or q_b60.outcome == 2:
                limitation_chronic = 1

        # B61: How many activities prevented?
        - id: qg_b61
          kind: QuestionGroup
          title: "How many ACTIVITIES does this condition (do these conditions) USUALLY prevent the child from doing:"
          precondition:
            - predicate: q_b60.outcome == 1 or q_b60.outcome == 2
          questions:
            - "At home"
            - "At school"
            - "At play or recreational activities"
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Many"
              4: "Most"

    # =====================================================================
    # PROFILE SHEET CHECK (B62.edit)
    # Compute limitation_count. If 0, skip to end (follow-up).
    # =====================================================================
    - id: b_profile_check
      title: "Profile Sheet Check"
      items:
        # Compute aggregate counts using a Comment with codeBlock
        - id: q_profile_check
          kind: Comment
          title: "Interviewer: Checking Profile Sheet for limitations."
          codeBlock: |
            limitation_count = limitation_general + limitation_hearing + limitation_seeing + limitation_communicating + limitation_walking + limitation_hands + limitation_learning + limitation_developmental + limitation_emotional + limitation_chronic

    # =====================================================================
    # DIAGNOSIS AND CAUSE SUBSECTION (B62–B67)
    # B62.edit: if limitation_count > 0, continue; else end section
    # =====================================================================
    - id: b_diagnosis
      title: "Diagnosis and Cause"
      precondition:
        - predicate: limitation_count > 0
      items:
        # B62: Age when condition suspected
        - id: q_b62
          kind: Question
          title: "You mentioned earlier that because of a physical condition, mental condition or health problem the child has difficulties or activity limitations. How old was the child when you suspected that he/she has a long-term condition or health problem?"
          input:
            control: Editbox
            min: 0
            max: 14
            right: "years (enter 0 if less than 1 year)"

        # B63: Main condition causing limitations
        - id: q_b63
          kind: Question
          title: "What is the MAIN condition or health problem which causes the child difficulties or activity limitations?"
          input:
            control: Textarea
            placeholder: "Specify one condition"
            maxLength: 200

        # B64: Cause of condition
        - id: q_b64
          kind: Question
          title: "Which one of the following best describes the CAUSE of this condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Existed at birth, was due to premature birth or accident at birth"
              2: "A disease or illness"
              3: "Accident at home or at school"
              4: "Motor vehicle accident"
              5: "Other"
              8: "Don't know"
              9: "Refusal"

        # B65: Got a diagnosis?
        - id: q_b65
          kind: Question
          title: "Did you get a diagnosis for the child's condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B66: Age at diagnosis
        - id: q_b66
          kind: Question
          title: "How old was the child when you obtained a diagnosis for his/her condition or health problem?"
          precondition:
            - predicate: q_b65.outcome == 1 or q_b65.outcome == 3
          input:
            control: Editbox
            min: 0
            max: 14
            right: "years (enter 0 if less than 1 year)"

        # B67: Difficulties getting diagnosis?
        - id: qg_b67
          kind: QuestionGroup
          title: "Did you experience any of the following situations when you were trying to obtain a diagnosis for the child's condition or health problem?"
          precondition:
            - predicate: q_b65.outcome == 1 or q_b65.outcome == 3
          questions:
            - "Doctor or health professional took a wait and see approach"
            - "Long waiting period to get the diagnosis"
            - "Difficulty getting referrals or appointments"
            - "Doctor or health professional not available locally"
            - "Too expensive"
            - "Did not know where to get the diagnosis"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # GENERAL HEALTH AND MEDICATIONS SUBSECTION (B68–B79)
    # =====================================================================
    - id: b_health_meds
      title: "General Health and Medications"
      precondition:
        - predicate: limitation_count > 0
      items:
        # B68: General health
        - id: q_b68
          kind: Question
          title: "How would you describe the child's general health? Would you say that his/her health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # B69: Uses medications regularly?
        - id: q_b69
          kind: Question
          title: "Does the child USE any prescription or non-prescription medications on a regular basis, that is, AT LEAST ONCE A WEEK?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B70: How many PRESCRIPTION meds daily?
        - id: q_b70
          kind: Question
          title: "How many kinds of PRESCRIPTION medications does the child take EVERYDAY?"
          precondition:
            - predicate: q_b69.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "1-3 kinds"
              3: "4 kinds or more"

        # B71: How many NON-PRESCRIPTION meds daily?
        - id: q_b71
          kind: Question
          title: "How many kinds of NON-PRESCRIPTION medications does the child take EVERYDAY?"
          precondition:
            - predicate: q_b69.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "1-3 kinds"
              3: "4 kinds or more"

        # B72: Uses medications regularly but NOT daily?
        - id: q_b72
          kind: Question
          title: "Does the child USE any medications regularly, but NOT DAILY?"
          precondition:
            - predicate: q_b69.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B73: How many PRESCRIPTION meds not daily?
        - id: q_b73
          kind: Question
          title: "How many kinds of PRESCRIPTION medications does the child take (regularly, but NOT DAILY)?"
          precondition:
            - predicate: q_b72.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "1-3 kinds"
              3: "4 kinds or more"

        # B74: How many NON-PRESCRIPTION meds not daily?
        - id: q_b74
          kind: Question
          title: "How many kinds of NON-PRESCRIPTION medications does the child take (regularly, but NOT DAILY)?"
          precondition:
            - predicate: q_b72.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "1-3 kinds"
              3: "4 kinds or more"

        # B75: Out-of-pocket expenses for medications?
        - id: q_b75
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses, that are not reimbursed by any sources, for the child's prescription or non-prescription medications?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B76: Estimate of medication costs
        - id: q_b76
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed."
          precondition:
            - predicate: q_b75.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"
          codeBlock: |
            if q_b76.outcome > 0:
                b76_gave_amount = 1

        # B77: Expense group for medications (if B76 amount not given)
        - id: q_b77
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: q_b75.outcome == 1
            - predicate: b76_gave_amount == 0
          input:
            control: Radio
            labels:
              1: "Less than $100"
              2: "$100 to less than $200"
              3: "$200 to less than $500"
              4: "$500 to less than $1,000"
              5: "$1,000 to less than $2,000"
              6: "$2,000 to less than $5,000"
              7: "$5,000 or more"

        # B78: Currently needs medications not having?
        - id: q_b78
          kind: Question
          title: "Because of a condition or health problem, does the child CURRENTLY need any prescription or non-prescription medications on a regular basis, which he/she does not have?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B79: Why doesn't child have needed medications?
        - id: qg_b79
          kind: QuestionGroup
          title: "Why doesn't the child have these medications?"
          precondition:
            - predicate: q_b78.outcome == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Not approved or recommended by health professionals"
            - "Other reason"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # HEALTH PROFESSIONAL CONTACTS AND COSTS (B80–B86)
    # =====================================================================
    - id: b_health_prof
      title: "Health Professional Contacts and Costs"
      precondition:
        - predicate: limitation_count > 0
      items:
        # B80: Frequency of health professional visits (8 sub-items)
        - id: qg_b80
          kind: QuestionGroup
          title: "IN THE PAST 12 MONTHS, how OFTEN has the child seen or received care from:"
          questions:
            - "Family doctor or general practitioner"
            - "Medical specialist (such as a heart specialist)"
            - "Nurse"
            - "Speech therapist"
            - "Physiotherapist"
            - "Psychologist or psychotherapist"
            - "Chiropractor"
            - "Other health professional"
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "Less than once a month"
              4: "Never"
          codeBlock: |
            b80_any_seen = 0
            if qg_b80.outcome[0] == 1 or qg_b80.outcome[0] == 2 or qg_b80.outcome[0] == 3:
                b80_any_seen = 1
            if qg_b80.outcome[1] == 1 or qg_b80.outcome[1] == 2 or qg_b80.outcome[1] == 3:
                b80_any_seen = 1
            if qg_b80.outcome[2] == 1 or qg_b80.outcome[2] == 2 or qg_b80.outcome[2] == 3:
                b80_any_seen = 1
            if qg_b80.outcome[3] == 1 or qg_b80.outcome[3] == 2 or qg_b80.outcome[3] == 3:
                b80_any_seen = 1
            if qg_b80.outcome[4] == 1 or qg_b80.outcome[4] == 2 or qg_b80.outcome[4] == 3:
                b80_any_seen = 1
            if qg_b80.outcome[5] == 1 or qg_b80.outcome[5] == 2 or qg_b80.outcome[5] == 3:
                b80_any_seen = 1
            if qg_b80.outcome[6] == 1 or qg_b80.outcome[6] == 2 or qg_b80.outcome[6] == 3:
                b80_any_seen = 1
            if qg_b80.outcome[7] == 1 or qg_b80.outcome[7] == 2 or qg_b80.outcome[7] == 3:
                b80_any_seen = 1

        # B81: Out-of-pocket expenses for health professionals?
        # B81.edit: only if any B80 seen (col 1, 2, or 3)
        - id: q_b81
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses, that are not reimbursed by any sources, for the services that the child received from health professionals?"
          precondition:
            - predicate: b80_any_seen == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B82: Estimate of health professional costs
        - id: q_b82
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed."
          precondition:
            - predicate: q_b81.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"
          codeBlock: |
            if q_b82.outcome > 0:
                b82_gave_amount = 1

        # B83: Expense group for health professional costs
        - id: q_b83
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: q_b81.outcome == 1
            - predicate: b82_gave_amount == 0
          input:
            control: Radio
            labels:
              1: "Less than $200"
              2: "$200 to less than $500"
              3: "$500 to less than $1,000"
              4: "$1,000 to less than $2,000"
              5: "$2,000 to less than $5,000"
              6: "$5,000 or more"

        # B84: Ever needed health services but didn't receive?
        - id: q_b84
          kind: Question
          title: "IN THE PAST 12 MONTHS, was there ever a time when the child needed health services because of his/her condition, but did not receive them?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B85: What kind of services needed but not received?
        - id: qg_b85
          kind: QuestionGroup
          title: "What kind of health services did the child NEED, but did not receive?"
          precondition:
            - predicate: q_b84.outcome == 1
          questions:
            - "Family doctor or general practitioner"
            - "Medical specialist (such as a heart specialist)"
            - "Nurse for care"
            - "Speech therapist"
            - "Physiotherapist"
            - "Psychologist or psychotherapist"
            - "Chiropractor"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B86: Why didn't child receive services?
        - id: qg_b86
          kind: QuestionGroup
          title: "Why didn't the child receive the health service that he/she needed?"
          precondition:
            - predicate: q_b84.outcome == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Not available locally"
            - "Long waiting period"
            - "Other reason"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =====================================================================
    # AIDS USAGE AND COSTS SUBSECTION (B87–B97)
    # B87.edit: under-5 → skip to Section C (end of this file)
    # =====================================================================
    - id: b_aids_costs
      title: "Aids Usage and Costs"
      precondition:
        - predicate: limitation_count > 0
        - predicate: child_under_5 == 0
      items:
        # B87: USE any other aids not already mentioned?
        - id: q_b87
          kind: Question
          title: "Because of a condition or health problem, does the child USE any aids or specialized equipment that you have not already mentioned?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b87.outcome == 1:
                use_aid_chronic = 1

        # B88: Which other aids does child USE?
        - id: qg_b88
          kind: QuestionGroup
          title: "Does the child now use:"
          precondition:
            - predicate: q_b87.outcome == 1
          questions:
            - "Respiratory aids, such as inhalers, puffers, oxygen"
            - "Pain management aids, such as a TENS machine"
            - "Other aid or specialized equipment"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Compute use_aid_count before B89.edit check
        - id: q_use_aid_check
          kind: Comment
          title: "Interviewer: Checking Profile Sheet for USE Aid flags."
          codeBlock: |
            use_aid_count = use_aid_hearing + use_aid_seeing + use_aid_communicating + use_aid_walking + use_aid_hands + use_aid_learning + use_aid_chronic

        # B89: Funding for aids (if any USE Aid checked)
        - id: qg_b89
          kind: QuestionGroup
          title: "I would like you to think about all the aids and specialized equipment that the child currently uses. What kind of funding was used to get these aids?"
          precondition:
            - predicate: use_aid_count > 0
          questions:
            - "Your own money"
            - "Friends and family members"
            - "Private health insurance"
            - "Government program"
            - "Other funding"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B90: Out-of-pocket expenses for aids?
        - id: q_b90
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for the purchase or maintenance of aids or specialized equipment that the child uses?"
          precondition:
            - predicate: use_aid_count > 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B91: Estimate of aids costs
        - id: q_b91
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed."
          precondition:
            - predicate: q_b90.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"
          codeBlock: |
            if q_b91.outcome > 0:
                b91_gave_amount = 1

        # B92: Expense group for aids costs
        - id: q_b92
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: q_b90.outcome == 1
            - predicate: b91_gave_amount == 0
          input:
            control: Radio
            labels:
              1: "Less than $200"
              2: "$200 to less than $500"
              3: "$500 to less than $1,000"
              4: "$1,000 to less than $2,000"
              5: "$2,000 to less than $5,000"
              6: "$5,000 or more"

        # B93: CURRENTLY need any other aids not mentioned?
        - id: q_b93
          kind: Question
          title: "Does the child CURRENTLY need any aids or specialized equipment that you have not already mentioned?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_b93.outcome == 1:
                need_aid_chronic = 1

        # B94: Which aids does child NEED?
        - id: qg_b94
          kind: QuestionGroup
          title: "Which aids does the child NEED, but does not have?"
          precondition:
            - predicate: q_b93.outcome == 1
          questions:
            - "Respiratory aids, such as inhalers, puffers, oxygen"
            - "Pain management aids, such as a TENS machine"
            - "Other aid or specialized equipment"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Compute need_aid_count before B95.edit check
        - id: q_need_aid_check
          kind: Comment
          title: "Interviewer: Checking Profile Sheet for NEED Aid flags."
          codeBlock: |
            need_aid_count = need_aid_hearing + need_aid_seeing + need_aid_communicating + need_aid_walking + need_aid_hands + need_aid_learning + need_aid_chronic

        # B95: Why doesn't child have needed aids? (if any NEED Aid checked)
        - id: qg_b95
          kind: QuestionGroup
          title: "I would like you to think about all the aids the child CURRENTLY needs, but does not have. Why doesn't the child have these aids or specialized equipment?"
          precondition:
            - predicate: need_aid_count > 0
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Not available locally"
            - "Do not know where to obtain the aid"
            - "Child's condition is not serious enough"
            - "Only needed occasionally"
            - "Other reason"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B96: Impact of not having aids?
        - id: q_b96
          kind: Question
          title: "Now, I would like you to think about all the aids or specialized equipment that the child NEEDS, but does not have. Do you think that there is an impact on the child because he/she does not have these aids?"
          precondition:
            - predicate: need_aid_count > 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # B97: What is the impact?
        - id: qg_b97
          kind: QuestionGroup
          title: "What is the impact of not having these aids or specialized equipment?"
          precondition:
            - predicate: q_b96.outcome == 1
          questions:
            - "Child's participation in regular everyday activity is reduced"
            - "Child is frustrated"
            - "Child's self-esteem is affected"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: everyday_help
    # ===================================================================
    # =========================================================================
    # BLOCK 1: PERSONAL CARE AND MOBILITY HELP (C1-C11)
    # =========================================================================
    # C_AGE.edit: children under 5 skip this entire block → go to C12 block
    # C1: receive personal care help? Yes → C2, No/DK/R → C5
    # C2: condition-related? Yes → C3, No/DK/R → C5
    # C3: how much help?  → C4
    # C4: who provides?   → C5
    # C5: moving about help? Yes → C6, No/DK/R → C9
    # C6: condition-related? Yes → C7, No/DK/R → C9
    # C7: how much help? → C8
    # C8: who provides?  → C9
    # C9: need MORE help? (2 sub-items) → C9.edit (codeBlock sets c9_any_yes)
    # C9.edit: c9_any_yes == 1 → C10, else → C12 block
    # C10: hours of help needed → C11
    # C11: why not receiving (8 sub-items) → C12 block
    # =========================================================================
    - id: b_personal_mobility
      title: "Personal Care and Mobility Help"
      precondition:
        - predicate: child_under_5 == 0

      items:
        # C1: Personal care help
        - id: q_c1
          kind: Question
          title: "Does ..... USUALLY receive help with personal care, such as bathing, toiletting, dressing or feeding?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C2: Condition-related personal care
        # Precondition: C1 = Yes
        - id: q_c2
          kind: Question
          title: "Is this because of his/her condition or health problem?"
          precondition:
            - predicate: q_c1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C3: Amount of personal care help needed
        # Precondition: C1=Yes AND C2=Yes
        - id: q_c3
          kind: Question
          title: "How much help does he/she need?"
          precondition:
            - predicate: q_c1.outcome == 1
            - predicate: q_c2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some help"
              2: "A lot of help"
              8: "Don't know"
              9: "Refusal"

        # C4: Who provides personal care help
        # Precondition: C1=Yes AND C2=Yes (follows C3)
        - id: q_c4
          kind: Question
          title: "Who provides most of the help to ..... for his/her personal care?"
          precondition:
            - predicate: q_c1.outcome == 1
            - predicate: q_c2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # C5: Moving about help
        - id: q_c5
          kind: Question
          title: "Does ..... USUALLY receive help with moving about inside his/her residence, such as moving from one room to another?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C6: Condition-related mobility help
        # Precondition: C5 = Yes
        - id: q_c6
          kind: Question
          title: "Is this because of his/her condition or health problem?"
          precondition:
            - predicate: q_c5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C7: Amount of mobility help needed
        # Precondition: C5=Yes AND C6=Yes
        - id: q_c7
          kind: Question
          title: "How much help does he/she need?"
          precondition:
            - predicate: q_c5.outcome == 1
            - predicate: q_c6.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some help"
              2: "A lot of help"
              8: "Don't know"
              9: "Refusal"

        # C8: Who provides mobility help
        # Precondition: C5=Yes AND C6=Yes (follows C7)
        - id: q_c8
          kind: Question
          title: "Who provides most of the help to ..... for moving about inside his/her residence?"
          precondition:
            - predicate: q_c5.outcome == 1
            - predicate: q_c6.outcome == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # C9: Need more help (2 sub-items: personal care, moving about)
        # codeBlock sets c9_any_yes routing flag
        - id: qg_c9
          kind: QuestionGroup
          title: "Because of .....'s condition, do you CURRENTLY need help or additional help with:"
          questions:
            - "His/her personal care?"
            - "Moving him/her about inside his/her residence?"
          codeBlock: |
            if qg_c9.outcome[0] == 1 or qg_c9.outcome[1] == 1:
              c9_any_yes = 1
            else:
              c9_any_yes = 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C10: Hours of help needed per week
        # Precondition: any C9 = Yes
        - id: q_c10
          kind: Question
          title: "How many hours per week of help or additional help do you need?"
          precondition:
            - predicate: c9_any_yes == 1
          input:
            control: Radio
            labels:
              1: "1–4 hours per week"
              2: "5–10 hours per week"
              3: "More than 10 hours per week"
              8: "Don't know"
              9: "Refusal"

        # C11: Why not receiving needed help (8 sub-items)
        # Precondition: any C9 = Yes (follows C10)
        - id: qg_c11
          kind: QuestionGroup
          title: "Why do you not receive this help? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: c9_any_yes == 1
          questions:
            - "It is too expensive"
            - "Help from family and friends is not available"
            - "Services or special programs (for help) are not available locally"
            - "Child is presently on a waiting list"
            - "Do not know where to look for help"
            - "Child's condition is not serious enough"
            - "You have not asked for help"
            - "Other, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: HOUSEWORK / FAMILY HELP — RECEIPT (C12-C16)
    # =========================================================================
    # Everyone reaches C12 (children under 5 skip block 1 but reach here)
    # C12: receive help with housework/family/personal? (3 sub-items)
    #   codeBlock sets c12_any_yes
    # C12.edit: c12_any_yes == 1 → C13, else → C17 block
    # C13: who provides (7 sub-items) → C14
    # C14: out-of-pocket expenses? Yes → C15, No/DK/R → C17 block
    # C15: dollar amount (Editbox; DK routes to C16 via c15_dk flag)
    # C16: expense group (if C15 DK/R) → C17 block
    # =========================================================================
    - id: b_housework_received
      title: "Help with Housework and Family Activities (Received)"

      items:
        # C12: Receive help with housework/family/personal (3 sub-items)
        - id: qg_c12
          kind: QuestionGroup
          title: "Because of .....'s condition, do you USUALLY receive help with the following:"
          questions:
            - "Help with everyday housework, such as house cleaning or meal preparation"
            - "Help to allow you to attend to other family responsibilities"
            - "Help to allow you to take time off for personal activities"
          codeBlock: |
            if qg_c12.outcome[0] == 1 or qg_c12.outcome[1] == 1 or qg_c12.outcome[2] == 1:
              c12_any_yes = 1
            else:
              c12_any_yes = 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C13: Who provides help (7 sub-items)
        # Precondition: any C12 = Yes
        - id: qg_c13
          kind: QuestionGroup
          title: "Who USUALLY provides you this help? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: c12_any_yes == 1
          questions:
            - "Family living with you"
            - "Family not living with you"
            - "Friends or neighbours"
            - "Government organization or agency"
            - "Private organization or agency"
            - "Voluntary organization or agency"
            - "Other, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C14: Out-of-pocket expenses in past 12 months?
        # Precondition: any C12 = Yes (follows C13)
        - id: q_c14
          kind: Question
          title: "You mentioned earlier that you usually receive help with everyday housework or help to allow you to attend to other family or personal activities. IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for this help?"
          precondition:
            - predicate: c12_any_yes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C15: Dollar amount of out-of-pocket costs
        # Precondition: C14 = Yes
        # codeBlock: if outcome == 0 (used as sentinel for DK/R) set c15_dk=1
        # Note: 0 is out of range (range 1-999999), so 0 = respondent chose DK/R
        - id: q_c15
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program."
          precondition:
            - predicate: q_c14.outcome == 1
          codeBlock: |
            if q_c15.outcome == 0:
              c15_dk = 1
            else:
              c15_dk = 0
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"
            default: 0

        # C16: Expense group estimate (if C15 DK/R)
        # Precondition: C14=Yes AND C15 was DK/R (c15_dk == 1)
        - id: q_c16
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: q_c14.outcome == 1
            - predicate: c15_dk == 1
          input:
            control: Radio
            labels:
              1: "Less than $200"
              2: "$200 to less than $500"
              3: "$500 to less than $1,000"
              4: "$1,000 to less than $2,000"
              5: "$2,000 to less than $5,000"
              6: "$5,000 or more"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 3: HOUSEWORK / FAMILY HELP — UNMET NEED (C17-C18)
    # =========================================================================
    # C17: currently need MORE help (3 sub-items); codeBlock sets c17_any_yes
    # C17.edit: c17_any_yes == 1 → C18, else → C19
    # C18: why not receiving (8 sub-items) → C19
    # =========================================================================
    - id: b_housework_needed
      title: "Help with Housework and Family Activities (Unmet Need)"

      items:
        # C17: Need more help (3 sub-items)
        - id: qg_c17
          kind: QuestionGroup
          title: "Because of .....'s condition, do you CURRENTLY need help or additional help with the following:"
          questions:
            - "Help with everyday housework, such as house cleaning or meal preparation"
            - "Help to allow you to attend to other family responsibilities"
            - "Help to allow you to take time off for personal activities"
          codeBlock: |
            if qg_c17.outcome[0] == 1 or qg_c17.outcome[1] == 1 or qg_c17.outcome[2] == 1:
              c17_any_yes = 1
            else:
              c17_any_yes = 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C18: Why not receiving help (8 sub-items)
        # Precondition: any C17 = Yes
        - id: qg_c18
          kind: QuestionGroup
          title: "Why do you not receive this help or additional help? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: c17_any_yes == 1
          questions:
            - "It is too expensive"
            - "Help from family and friends is not available"
            - "Services or special programs (for help) are not available locally"
            - "Child is presently on a waiting list"
            - "Do not know where to look for help"
            - "Child's condition is not serious enough"
            - "You have not asked for help"
            - "Other, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 4: CARE COORDINATION AND WORK IMPACT (C19-C24)
    # =========================================================================
    # C19: difficulty coordinating care? Yes → C20, No/DK/R → C21
    # C20: what difficulty (7 sub-items) → C21
    # C21: who coordinates care → C22
    # C22: work impact (5 sub-items); codeBlock sets c22_any_yes
    # C22.edit: c22_any_yes == 1 → C23, else → C24
    # C23: who most affected → C24
    # C24: financial problems → Section D
    # =========================================================================
    - id: b_coordination_work
      title: "Care Coordination and Work Impact"

      items:
        # C19: Difficulty coordinating care
        - id: q_c19
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you have any difficulty with coordinating the care of ....., for example, making appointments, phoning or visiting health professionals and specialists?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C20: What kind of difficulty (7 sub-items)
        # Precondition: C19 = Yes
        - id: qg_c20
          kind: QuestionGroup
          title: "What kind of difficulty did you have? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_c19.outcome == 1
          questions:
            - "Difficulty obtaining appointments"
            - "Health professional or specialist not available locally"
            - "A lack of communication between health professionals"
            - "Difficulty getting information"
            - "Your lack of time to coordinate the care"
            - "Work conflicts"
            - "Other difficulty, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C21: Who coordinates care
        - id: q_c21
          kind: Question
          title: "Who USUALLY coordinates the care of .....?"
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the father and the mother"
              4: "Other family members"
              5: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # C22: Work impact (5 sub-items)
        # codeBlock sets c22_any_yes routing flag
        - id: qg_c22
          kind: QuestionGroup
          title: "Because of .....'s condition or health problem, has anyone in your family EVER:"
          questions:
            - "Not taken a job in order to take care of the child?"
            - "Quit working (other than normal maternity or paternity leave)?"
            - "Changed work hours to different time of day (or night)?"
            - "Turned down a promotion or a better job?"
            - "Worked fewer hours?"
          codeBlock: |
            if qg_c22.outcome[0] == 1 or qg_c22.outcome[1] == 1 or qg_c22.outcome[2] == 1 or qg_c22.outcome[3] == 1 or qg_c22.outcome[4] == 1:
              c22_any_yes = 1
            else:
              c22_any_yes = 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C23: Who most affected by work-related issues
        # Precondition: any C22 = Yes
        - id: q_c23
          kind: Question
          title: "Who was most affected by these work-related issues?"
          precondition:
            - predicate: c22_any_yes == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # C24: Financial problems due to child's condition
        - id: q_c24
          kind: Question
          title: "DURING THE PAST 12 MONTHS, has your family had financial problems because of .....'s condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

    # ===================================================================
    # SECTION: child_care
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SECTION D — CHILD CARE (items D1–D7)
    # =========================================================================
    # D1   → Currently use child care? Radio (Yes/No/DK). DK → skip to D6.
    # D2   → Main child care arrangement? Radio 8 options. DK → skip to D6.
    # D3   → Hours per week (main arrangement)? Editbox. Always follows D2.
    # D4   → Any other child care arrangement? Radio (Yes/No/DK). DK/No → D6.
    # D5   → Hours per week (other arrangement)? Editbox. Precondition: D4 = Yes.
    # D6   → Child care program ever refused child? Radio (Yes/No/DK). DK → skip D7.
    # D7   → Types of programs that refused (6 sub-items, Switch). Precondition: D6 = Yes.
    # =========================================================================
    - id: b_child_care
      title: "Child Care"
      items:

        # D1: Currently using child care?
        # 1=Yes, 3=No → D2; x=Don't know → GO TO D6; r=Refusal → D2
        # Model: code 8 = Don't know to gate D2–D5
        - id: q_d1
          kind: Question
          title: "Now, I'd like to ask you some questions about child care arrangements for ..... . Do you CURRENTLY use child care such as day care, babysitting or a before and after school program for ..... while you (or your spouse/partner) are at work or studying?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"

        # D2: Main child care arrangement?
        # Precondition: D1 answered and not DK (i.e. outcome != 8)
        # x=Don't know → GO TO D6; r → D3 (both treated as code 9 here)
        - id: q_d2
          kind: Question
          title: "What is your MAIN child care arrangement for .....?"
          precondition:
            - predicate: q_d1.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Before and after school program"
              2: "Nursery school"
              3: "Day care centre"
              4: "Care in someone else's home by a non-relative"
              5: "Care in someone else's home by a relative"
              6: "Care in child's home by a non-relative"
              7: "Care in child's home by a relative"
              8: "Other, specify"
              9: "Don't know"

        # D3: Hours per week for main arrangement?
        # Precondition: D2 answered (not DK, i.e. outcome != 9) AND D1 not DK
        - id: q_d3
          kind: Question
          title: "Approximately how many hours per WEEK is that? (Main child care arrangement)"
          precondition:
            - predicate: q_d1.outcome in [1, 3]
            - predicate: q_d2.outcome in [1, 2, 3, 4, 5, 6, 7, 8]
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

        # D4: Any other child care arrangement?
        # Precondition: D1 not DK
        # 1=Yes → D5; 3=No/x=DK → D6
        - id: q_d4
          kind: Question
          title: "Do you use any other child care arrangement for .....?"
          precondition:
            - predicate: q_d1.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"

        # D5: Hours per week for other arrangement?
        # Precondition: D4 = Yes (outcome == 1)
        - id: q_d5
          kind: Question
          title: "Approximately how many hours per WEEK is that? (Other child care arrangement)"
          precondition:
            - predicate: q_d4.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

        # D6: Has a child care program ever refused to take child?
        # 1=Yes → D7; 3=No → D7; x=DK → GO TO D8.edit (skip D7); r → D7
        - id: q_d6
          kind: Question
          title: "Has a child care program or service ever refused to take care of ..... because of his/her condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"

        # D7: Types of programs that refused (multi-select Yes/No per sub-item)
        # Precondition: D6 = Yes (outcome == 1)
        # 6 sub-items: (a) Before/after school; (b) Nursery school; (c) Day care centre;
        #              (d) Care in someone else's home; (e) Care in child's home; (f) Other
        - id: qg_d7
          kind: QuestionGroup
          title: "What type of child care programs or services refused to provide care to .....? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_d6.outcome == 1
          questions:
            - "Before and after school program"
            - "Nursery school"
            - "Day care centre"
            - "Care in someone else's home"
            - "Care in child's home"
            - "Other, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: education
    # ===================================================================
    # =========================================================================
    # SECTION E — EDUCATION
    # Entire section skipped for children under 5 (child_under_5 == 1)
    #
    # E1 routing (3-way):
    #   1 (Going to school)     → E6
    #   2 (Tutored at home)     → E2 → GO TO E37
    #   3 (Neither)             → E3 → E4
    #   DK/R                   → E4
    #
    # E4: Did child ever go to school?
    #   1 Yes → GO TO E37
    #   3 No  → E5 → GO TO E37
    #   DK/R  → GO TO E37
    #
    # E6=1 (special ed school) → GO TO E10
    # E6=2/3/4/DK → E7 → E8
    #   E8=1 (Yes) → E9 → E10
    #   E8=3/DK/R  → E10.edit filter: E7==1 → E11; otherwise → E10
    #
    # E10 → E11 → E12(if E11=1) → E13 → province-specific grade
    # Grade questions E14-E19 set is_kindergarten; → E20 or E24
    # E20-E23 → E24 → E25 → E26(if E25=1) → E27 → E28(if E27=1) → E29
    # → E30 → E31(if E30=1) → E32 → E33 → E34 → E35 → E36 → E37
    # E37 → E38(if E37=1) → end
    # =========================================================================
    - id: b_education
      title: "Section E — Education"
      precondition:
        - predicate: child_under_5 == 0

      items:
        # -------------------------------------------------------------------
        # E1: School attendance status in April 2001
        # -------------------------------------------------------------------
        - id: q_e1
          kind: Question
          title: "The next few questions are about education. In APRIL 2001 was .....:"
          input:
            control: Radio
            labels:
              1: "Going to school or kindergarten"
              2: "Being tutored at home through the school system"
              3: "Neither of the above"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e1.outcome == 1:
                e1_path = 1
            elif q_e1.outcome == 2:
                e1_path = 2
            elif q_e1.outcome == 3:
                e1_path = 3
            else:
                e1_path = 0

        # -------------------------------------------------------------------
        # E2: Reason for home tutoring (E1=2 only) → then GO TO E37
        # -------------------------------------------------------------------
        - id: qg_e2
          kind: QuestionGroup
          title: "Why was ..... being tutored at home through the school system? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 2
          questions:
            - "(a) Personal care such as feeding and toiletting needed, but not available at school"
            - "(b) Teacher's aides or special education classes not available in REGULAR SCHOOL"
            - "(c) SPECIAL EDUCATION SCHOOL not available locally"
            - "(d) Child's condition or health problem prevented him/her from going to school"
            - "(e) Parents preferred home tutoring for the child"
            - "(f) Other reason, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E3: Reason for not attending school (E1=3 only) → then E4
        # -------------------------------------------------------------------
        - id: qg_e3
          kind: QuestionGroup
          title: "Why was ..... not attending school in April 2001? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 3
          questions:
            - "(a) Personal care such as feeding and toiletting needed, but not available at school"
            - "(b) Teacher's aides or special education classes not available in REGULAR SCHOOL"
            - "(c) SPECIAL EDUCATION SCHOOL not available locally"
            - "(d) Child's condition or health problem prevented him/her from going to school"
            - "(e) Child not ready or too young to attend school"
            - "(f) Other reason, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E4: Did child ever go to school? (E1=3 or E1=DK/R)
        # -------------------------------------------------------------------
        - id: q_e4
          kind: Question
          title: "Did ..... ever go to school?"
          precondition:
            - predicate: e1_path == 3 or e1_path == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e4.outcome == 1 or q_e4.outcome == 8 or q_e4.outcome == 9:
                e4_ever_school = 1
            else:
                e4_ever_school = 0

        # -------------------------------------------------------------------
        # E5: Why never attended school (E4=3 No only) → then GO TO E37
        # -------------------------------------------------------------------
        - id: q_e5
          kind: Question
          title: "Why did ..... never attend school?"
          precondition:
            - predicate: e1_path == 3 or e1_path == 0
            - predicate: e4_ever_school == 0
          input:
            control: Checkbox
            labels:
              1: "(a) Personal care such as feeding and toiletting needed, but not available at school"
              2: "(b) Teacher's aides or special education classes not available in REGULAR SCHOOL"
              4: "(c) SPECIAL EDUCATION SCHOOL not available locally"
              8: "(d) Child's condition or health problem prevented him/her from going to school"
              16: "(e) Child not ready or too young to attend school"
              32: "(f) Other reason, specify"
              64: "Don't know"
              128: "Refusal"

        # -------------------------------------------------------------------
        # E6: Type of school attended in April 2001 (E1=1 only)
        # -------------------------------------------------------------------
        - id: q_e6
          kind: Question
          title: "In APRIL 2001, what type of school was ..... attending?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Special education school"
              2: "Regular school"
              3: "Regular school with special education classes"
              4: "Other, specify"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e6.outcome == 1:
                e6_special_school = 1
            else:
                e6_special_school = 0

        # -------------------------------------------------------------------
        # E7: Type of classes at school (E6=2/3/4/DK/R — not special ed school)
        # -------------------------------------------------------------------
        - id: q_e7
          kind: Question
          title: "At this school, what type of classes was ..... attending?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e6_special_school == 0
          input:
            control: Radio
            labels:
              1: "Only regular classes"
              2: "Some regular classes and some special education classes"
              3: "Only special education classes"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            e7_class_type = q_e7.outcome

        # -------------------------------------------------------------------
        # E8: Ever attended a special education school
        # Shown after E7 (E6 != 1) OR directly after E6=1 (special school)
        # i.e. shown when e1_path == 1
        # -------------------------------------------------------------------
        - id: q_e8
          kind: Question
          title: "Did ..... ever attend a special education school?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e8.outcome == 1:
                e8_ever_special = 1
            else:
                e8_ever_special = 0

        # -------------------------------------------------------------------
        # E9: Why not attending special ed school now (E8=1 Yes)
        # -------------------------------------------------------------------
        - id: q_e9
          kind: Question
          title: "Why didn't he/she attend a special education school in April 2001?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e8_ever_special == 1
          input:
            control: Checkbox
            labels:
              1: "(a) Special education school no longer available locally"
              2: "(b) Child has moved into regular school"
              4: "(c) Other reason, specify"
              8: "Don't know"
              16: "Refusal"

        # -------------------------------------------------------------------
        # E10: Main condition requiring special education services
        # Shown when: came via special ed school (E6=1)
        #   OR came via E7 != 1 (not "only regular classes")
        # i.e. e6_special_school==1 OR (e1_path==1 AND e7_class_type != 1)
        # -------------------------------------------------------------------
        - id: qg_e10
          kind: QuestionGroup
          title: "What is the MAIN condition or health problem which required ..... to receive special education services? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: e6_special_school == 1 or e7_class_type != 1
          questions:
            - "(a) Learning disabilities"
            - "(b) Developmental disability or disorder"
            - "(c) Speech or language difficulties"
            - "(d) Emotional, psychological or behavioural conditions"
            - "(e) Hearing difficulties, including deafness"
            - "(f) Vision difficulties, including blindness"
            - "(g) Difficulty with walking or moving around"
            - "(h) Other condition, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E11: Difficulty getting special education services (all going to school)
        # -------------------------------------------------------------------
        - id: q_e11
          kind: Question
          title: "Did you ever have any difficulty in trying to get special education services for .....?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E12: Kind of difficulty (E11=1 Yes)
        # -------------------------------------------------------------------
        - id: qg_e12
          kind: QuestionGroup
          title: "What kind of difficulty did you have? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: q_e11.outcome == 1
          questions:
            - "(a) Special education services not available locally"
            - "(b) Insufficient level of staffing or special education services"
            - "(c) Communication problems with school"
            - "(d) Difficulty to have the child tested for special education services"
            - "(e) Other difficulty, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E13: Province or territory where child attended school
        # -------------------------------------------------------------------
        - id: q_e13
          kind: Question
          title: "In APRIL 2001, in which province or territory did ..... attend school?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Dropdown
            labels:
              1: "Newfoundland"
              2: "Prince Edward Island"
              3: "Nova Scotia"
              4: "New Brunswick"
              5: "Quebec"
              6: "Ontario"
              7: "Manitoba"
              8: "Saskatchewan"
              9: "Alberta"
              10: "British Columbia"
              11: "Northwest Territory"
              12: "Nunavut"
              13: "Yukon"
              14: "Other, specify"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            e13_province = q_e13.outcome

        # -------------------------------------------------------------------
        # E14: Grade — Newfoundland (E13=1)
        # Kindergarten (01) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e14
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Newfoundland)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 1
          input:
            control: Dropdown
            labels:
              1: "Kindergarten"
              2: "Grade 1"
              3: "Grade 2"
              4: "Grade 3"
              5: "Grade 4"
              6: "Grade 5"
              7: "Grade 6"
              8: "Grade 7"
              9: "Grade 8"
              10: "Grade 9"
              11: "Level 1 Secondary"
              12: "Level 2 Secondary"
              13: "Level 3 Secondary"
              14: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e14.outcome == 1:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E15: Grade — Prince Edward Island (E13=2)
        # No kindergarten option — always → E20
        # -------------------------------------------------------------------
        - id: q_e15
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Prince Edward Island)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 2
          input:
            control: Dropdown
            labels:
              1: "Grade 1"
              2: "Grade 2"
              3: "Grade 3"
              4: "Grade 4"
              5: "Grade 5"
              6: "Grade 6"
              7: "Grade 7"
              8: "Grade 8"
              9: "Grade 9"
              10: "Grade 10"
              11: "Grade 11"
              12: "Grade 12"
              13: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            is_kindergarten = 0

        # -------------------------------------------------------------------
        # E16: Grade — Nova Scotia (E13=3)
        # Primary (01) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e16
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Nova Scotia)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 3
          input:
            control: Dropdown
            labels:
              1: "Primary"
              2: "Grade 1"
              3: "Grade 2"
              4: "Grade 3"
              5: "Grade 4"
              6: "Grade 5"
              7: "Grade 6"
              8: "Grade 7"
              9: "Grade 8"
              10: "Grade 9"
              11: "Grade 10"
              12: "Grade 11"
              13: "Grade 12"
              14: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e16.outcome == 1:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E17: Grade — Quebec (E13=5)
        # Junior Kindergarten/Kindergarten (01-02) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e17
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Quebec)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 5
          input:
            control: Dropdown
            labels:
              1: "Junior Kindergarten"
              2: "Kindergarten"
              3: "Grade 1 Elementary"
              4: "Grade 2 Elementary"
              5: "Grade 3 Elementary"
              6: "Grade 4 Elementary"
              7: "Grade 5 Elementary"
              8: "Grade 6 Elementary"
              9: "Secondary I"
              10: "Secondary II"
              11: "Secondary III"
              12: "Secondary IV"
              13: "Secondary V"
              14: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e17.outcome == 1 or q_e17.outcome == 2:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E18: Grade — Ontario (E13=6)
        # Junior Kindergarten/Kindergarten (01-02) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e18
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Ontario)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 6
          input:
            control: Dropdown
            labels:
              1: "Junior Kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7"
              10: "Grade 8"
              11: "Grade 9"
              12: "Grade 10"
              13: "Grade 11"
              14: "Grade 12"
              15: "OAC"
              16: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e18.outcome == 1 or q_e18.outcome == 2:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E19: Grade — All other provinces/territories (E13 not in 1,2,3,5,6)
        # Kindergarten (01) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e19
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province not in [1, 2, 3, 5, 6]
          input:
            control: Dropdown
            labels:
              1: "Kindergarten"
              2: "Grade 1"
              3: "Grade 2"
              4: "Grade 3"
              5: "Grade 4"
              6: "Grade 5"
              7: "Grade 6"
              8: "Grade 7"
              9: "Grade 8"
              10: "Grade 9"
              11: "Grade 10"
              12: "Grade 11"
              13: "Grade 12"
              14: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e19.outcome == 1:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E20: Type of education/training/therapy at school (non-kindergarten only)
        # -------------------------------------------------------------------
        - id: qg_e20
          kind: QuestionGroup
          title: "In APRIL 2001, what type of education, training or therapy was ..... receiving at school? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: is_kindergarten == 0
          questions:
            - "(a) Academic subjects"
            - "(b) Life skills"
            - "(c) Speech and language therapy"
            - "(d) Mental health or counselling services"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E21: Academic performance during last school year (non-kindergarten)
        # -------------------------------------------------------------------
        - id: q_e21
          kind: Question
          title: "Based on your knowledge of his/her school work, including his/her report cards, how did ..... do during the last school year?"
          precondition:
            - predicate: e1_path == 1
            - predicate: is_kindergarten == 0
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Average"
              4: "Poorly"
              5: "Very poorly"
              6: "Not applicable"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E22: Homework help frequency (non-kindergarten)
        # -------------------------------------------------------------------
        - id: q_e22
          kind: Question
          title: "How often did you (or your spouse/partner) check .....''s homework or provide help with his/her homework during the last school year?"
          precondition:
            - predicate: e1_path == 1
            - predicate: is_kindergarten == 0
          input:
            control: Radio
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "At least once a month"
              4: "At least once a week"
              5: "A few times a week"
              6: "Every day"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E23: Education impacts (non-kindergarten)
        # -------------------------------------------------------------------
        - id: qg_e23
          kind: QuestionGroup
          title: "Because of a condition or health problem:"
          precondition:
            - predicate: e1_path == 1
            - predicate: is_kindergarten == 0
          questions:
            - "(a) Did ..... have to leave his/her community to attend school?"
            - "(b) Was his/her schooling interrupted for long periods of time?"
            - "(c) Did ..... take fewer courses or academic subjects at school?"
            - "(d) Did it take ..... longer to achieve his/her present level of education?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E24: School activity limitations (all going to school, including kindergarten)
        # -------------------------------------------------------------------
        - id: qg_e24
          kind: QuestionGroup
          title: "Did a condition or health problem limit .....''s participation in any of the following SCHOOL ACTIVITIES during the last school year (which ended in June 2001)?"
          precondition:
            - predicate: e1_path == 1
          questions:
            - "(a) Taking part in physical education or organized games requiring physical activity"
            - "(b) Playing with others during recess or lunch hour"
            - "(c) Taking part in school outings, such as visits to a museum"
            - "(d) Classroom participation"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E25: Use of special building features at school
        # -------------------------------------------------------------------
        - id: q_e25
          kind: Question
          title: "Because of a condition or health problem, did ..... USE any special building features or equipment, such as ramps or automatic door openers AT SCHOOL?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e25.outcome == 1:
                e25_used_features = 1
            else:
                e25_used_features = 0

        # -------------------------------------------------------------------
        # E26: Which special features used at school (E25=1)
        # -------------------------------------------------------------------
        - id: qg_e26
          kind: QuestionGroup
          title: "Which kind of special features did he/she USE at school? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: e25_used_features == 1
          questions:
            - "(a) Ramps or street level entrances"
            - "(b) Widened doorways or hallways"
            - "(c) Automatic or easy to open doors"
            - "(d) An elevator or lift device"
            - "(e) Special railings in washrooms"
            - "(f) Other feature, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E27: Need for special features not available at school
        # -------------------------------------------------------------------
        - id: q_e27
          kind: Question
          title: "Because of a condition or a health problem, did ..... NEED any special features or equipment, such as ramps or automatic door openers AT SCHOOL, which were not available?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e27.outcome == 1:
                e27_needed_features = 1
            else:
                e27_needed_features = 0

        # -------------------------------------------------------------------
        # E28: What features needed but not available (E27=1)
        # -------------------------------------------------------------------
        - id: qg_e28
          kind: QuestionGroup
          title: "What kind of special features or equipment did he/she need AT SCHOOL, but did not have?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e27_needed_features == 1
          questions:
            - "(a) Ramps or street level entrances"
            - "(b) Widened doorways or hallways"
            - "(c) Automatic or easy to open doors"
            - "(d) An elevator or lift device"
            - "(e) Special railings in washrooms"
            - "(f) Other feature, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E29: Assistive aids/devices/services used at school
        # -------------------------------------------------------------------
        - id: qg_e29
          kind: QuestionGroup
          title: "During the last school year, did ..... USE any assistive aids, devices or services AT SCHOOL? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
          questions:
            - "(a) Tutors or teacher's aides"
            - "(b) Note takers or readers"
            - "(c) Sign language interpreters"
            - "(d) Attendant care services"
            - "(e) Amplifiers, such as FM or infrared"
            - "(f) Talking books"
            - "(g) Magnifiers"
            - "(h) Recording equipment"
            - "(i) A computer with Braille or speech access"
            - "(j) Other aid or service, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E30: Unmet assistive aid needs at school
        # -------------------------------------------------------------------
        - id: q_e30
          kind: Question
          title: "Were there any assistive aids, devices or services that ..... needed AT SCHOOL, but did not have?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e30.outcome == 1:
                e30_unmet_aids = 1
            else:
                e30_unmet_aids = 0

        # -------------------------------------------------------------------
        # E31: What aids needed but not available (E30=1)
        # -------------------------------------------------------------------
        - id: qg_e31
          kind: QuestionGroup
          title: "What kind of assistive aids or services did he/she need AT SCHOOL, but did not have?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e30_unmet_aids == 1
          questions:
            - "(a) Tutors or teacher's aides"
            - "(b) Note takers or readers"
            - "(c) Sign language interpreters"
            - "(d) Attendant care services"
            - "(e) Amplifiers, such as FM or infrared"
            - "(f) Talking books"
            - "(g) Magnifiers"
            - "(h) Recording equipment"
            - "(i) A computer with Braille or speech access"
            - "(j) Other aid or service, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E32: Why aids not available (shown after E31)
        # -------------------------------------------------------------------
        - id: qg_e32
          kind: QuestionGroup
          title: "Why didn't ..... have these aids or services AT SCHOOL? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: e30_unmet_aids == 1
          questions:
            - "(a) School funding cutbacks or lack of funding in the school system"
            - "(b) School did not think child needed assistive aids or services"
            - "(c) Child did not want to use assistive aids or services"
            - "(d) Other reason, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E33: Parental involvement activities during last school year
        # -------------------------------------------------------------------
        - id: qg_e33
          kind: QuestionGroup
          title: "During the last school year, have you (or your partner/spouse) done any of the following for .....? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
          questions:
            - "(a) Spoken to, visited or corresponded with child's teacher"
            - "(b) Attended a school event in which child participated"
            - "(c) Volunteered in child's class or helped with a class trip"
            - "(d) Helped elsewhere in the school"
            - "(e) Attended a parent-school association meeting"
            - "(f) Fundraising for school"
            - "(g) Other activity, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E34: Agreement with descriptions of school (3 sub-items, 4-point scale)
        # -------------------------------------------------------------------
        - id: qg_e34
          kind: QuestionGroup
          title: "Do you strongly agree, agree, disagree, or strongly disagree with the following descriptions of the school that ..... attended during the last school year?"
          precondition:
            - predicate: e1_path == 1
          questions:
            - "(a) The school offered parents many opportunities to be involved in the school activities"
            - "(b) Parents were made to feel welcome in the school"
            - "(c) Overall, the school accommodated the child's condition or health problem"
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E35: How often child looked forward to school
        # -------------------------------------------------------------------
        - id: q_e35
          kind: Question
          title: "With regard to how he/she feels about school, how often did ..... look forward to going to school during the last school year?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Almost never"
              2: "Rarely"
              3: "Sometimes"
              4: "Often"
              5: "Almost always"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E36: Transportation to school
        # -------------------------------------------------------------------
        - id: q_e36
          kind: Question
          title: "During the last school year, what was the method of transportation ..... used MOST OFTEN to get to school?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Was driven to school by family motor vehicle"
              2: "School bus"
              3: "Regular city bus"
              4: "Specialized bus services for persons with disabilities"
              5: "Walked or biked to school"
              6: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E37: Professional assessment for educational needs
        # Convergence point — reached from all paths:
        #   e1_path==2 (after E2)
        #   e1_path==3 AND e4_ever_school==1 (E4=Yes/DK/R)
        #   e1_path==0 AND e4_ever_school==1 (E4=Yes/DK/R, came from DK/R on E1)
        #   e1_path==3 AND e4_ever_school==0 (after E5)
        #   e1_path==1 (after E36)
        # So: shown to everyone in the section
        # -------------------------------------------------------------------
        - id: q_e37
          kind: Question
          title: "Has a professional assessment ever been done to determine .....''s educational needs?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e37.outcome == 1:
                e37_assessment = 1
            else:
                e37_assessment = 0

        # -------------------------------------------------------------------
        # E38: Who completed the professional assessment (E37=1)
        # -------------------------------------------------------------------
        - id: qg_e38
          kind: QuestionGroup
          title: "Who completed this assessment? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e37_assessment == 1
          questions:
            - "(a) Psychologist or psychiatrist"
            - "(b) Social worker"
            - "(c) Special education consultant"
            - "(d) Speech or language therapist"
            - "(e) Other professional or specialist, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: leisure_recreation
    # ===================================================================
    # =========================================================================
    # SECTION F — Leisure and Recreation Activities
    # Entire section skipped if child_under_5 == 1
    # =========================================================================
    # F1a–F1e: Organized activity frequency + hours (outside school hours)
    # F2a–F2c: Passive/home activity frequency + hours
    # F3: Reading frequency + hours (Everyday only triggers hours)
    # F4: Unorganized play frequency (4-point scale, no hours)
    # F5: Summer camp attendance → F6 (camp type) if Yes
    # F7: Prevented from leisure activities → F8 (barrier list) if Yes
    # F9: Getting along with other children (5-point)
    # F10: Computers in home
    #   None → F11 (no-computer barriers) → end
    #   1+   → F12 (Internet?)
    #     No  → F13 (no-internet barriers) → end
    #     Yes → F14 (child uses Internet?)
    #       No  → F15 (non-use barriers) → end
    #       Yes → F16a–F16d (Internet usage frequency + hours)
    # =========================================================================
    - id: b_leisure_recreation
      title: "Leisure and Recreation Activities"
      precondition:
        - predicate: child_under_5 == 0
      items:

        # -----------------------------------------------------------------
        # F1a: Organized sports with coach/instructor
        # -----------------------------------------------------------------
        - id: q_f1a
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in sports with a coach or instructor (except dance or gymnastics)?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1a_hrs: Hours per day — only if F1a not Never
        - id: q_f1a_hrs
          kind: Question
          title: "How many hours a day does he/she take part in sports with a coach or instructor?"
          precondition:
            - predicate: q_f1a.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F1b: Organized lessons in dance, gymnastics, martial arts, etc.
        # -----------------------------------------------------------------
        - id: q_f1b
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken lessons or instruction in other organized physical activities with a coach or instructor, such as dance, gymnastics or martial arts?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1b_hrs: Hours per day — only if F1b not Never
        - id: q_f1b_hrs
          kind: Question
          title: "How many hours a day does he/she take lessons or instruction in other organized physical activities?"
          precondition:
            - predicate: q_f1b.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F1c: Unorganized sports/physical activities
        # -----------------------------------------------------------------
        - id: q_f1c
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in unorganized sports or physical activities without a coach or instructor?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1c_hrs: Hours per day — only if F1c not Never
        - id: q_f1c_hrs
          kind: Question
          title: "How many hours a day does he/she take part in unorganized sports or physical activities?"
          precondition:
            - predicate: q_f1c.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F1d: Lessons in music, art, or other non-sport activities
        # -----------------------------------------------------------------
        - id: q_f1d
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken lessons or instruction in music, art or other non-sport activities?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1d_hrs: Hours per day — only if F1d not Never
        - id: q_f1d_hrs
          kind: Question
          title: "How many hours a day does he/she take lessons or instruction in music, art or other non-sport activities?"
          precondition:
            - predicate: q_f1d.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F1e: Clubs, groups, community programs
        # -----------------------------------------------------------------
        - id: q_f1e
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in clubs, groups or community programs, such as church groups, Girl or Boy Scouts?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1e_hrs: Hours per day — only if F1e not Never
        - id: q_f1e_hrs
          kind: Question
          title: "How many hours a day does he/she take part in clubs, groups or community programs?"
          precondition:
            - predicate: q_f1e.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F2a: Watch TV
        # -----------------------------------------------------------------
        - id: q_f2a
          kind: Question
          title: "How often does he/she watch T.V.?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F2a_hrs: Hours per day — only if F2a not Never
        - id: q_f2a_hrs
          kind: Question
          title: "How many hours a day does he/she watch T.V.?"
          precondition:
            - predicate: q_f2a.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F2b: Computer or video games
        # -----------------------------------------------------------------
        - id: q_f2b
          kind: Question
          title: "How often does he/she play computer or video games?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F2b_hrs: Hours per day — only if F2b not Never
        - id: q_f2b_hrs
          kind: Question
          title: "How many hours a day does he/she play computer or video games?"
          precondition:
            - predicate: q_f2b.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F2c: Talk on phone with friends
        # -----------------------------------------------------------------
        - id: q_f2c
          kind: Question
          title: "How often does he/she talk on the phone with friends?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F2c_hrs: Hours per day — only if F2c not Never
        - id: q_f2c_hrs
          kind: Question
          title: "How many hours a day does he/she talk on the phone with friends?"
          precondition:
            - predicate: q_f2c.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F3: Reading for pleasure
        # Note: inventory says 1 → F3_hrs; 2–5 → F4
        # i.e., only "Everyday" triggers the hours follow-up
        # -----------------------------------------------------------------
        - id: q_f3
          kind: Question
          title: "How often does ..... read or have books read to him/her (for pleasure)? Please do not include reading that is required for school."
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F3_hrs: Hours per day — only if F3 = Everyday
        - id: q_f3_hrs
          kind: Question
          title: "How many hours a day does he/she read or have books read to him/her?"
          precondition:
            - predicate: q_f3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F4: Playing alone
        # 4-point scale (Often/Sometimes/Seldom/Never) — no hours follow-up
        # -----------------------------------------------------------------
        - id: q_f4
          kind: Question
          title: "Outside of school hours, how often does he/she play alone, for example, riding a bike or doing a craft?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # -----------------------------------------------------------------
        # F5: Summer camp attendance
        # -----------------------------------------------------------------
        - id: q_f5
          kind: Question
          title: "Has ..... ever gone to summer camps (including regular or special camps)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F6: Camp for children with health problem — only if F5 = Yes
        - id: q_f6
          kind: Question
          title: "Was this a camp for children with a health problem or condition?"
          precondition:
            - predicate: q_f5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # -----------------------------------------------------------------
        # F7: Prevented from leisure activities
        # -----------------------------------------------------------------
        - id: q_f7
          kind: Question
          title: "Because of a condition or health problem, is ..... prevented from taking part in any social or physical leisure activities?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F8: Barriers to leisure — only if F7 = Yes
        # 8 sub-items, Yes/No per item → QuestionGroup with Switch
        - id: qg_f8
          kind: QuestionGroup
          title: "What prevents ..... from doing more social or physical leisure activities? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_f7.outcome == 1
          questions:
            - "Recreational facilities or programs not available locally"
            - "Buildings and equipment not physically accessible"
            - "Inadequate transportation services"
            - "Too expensive"
            - "Child is physically unable to do more"
            - "Child needs someone's assistance"
            - "Child needs specialized aids or equipment, but he/she doesn't have them"
            - "Other reason"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # F9: Getting along with other children
        # -----------------------------------------------------------------
        - id: q_f9
          kind: Question
          title: "DURING THE PAST SIX MONTHS, how well has ..... gotten along with other children, such as friends or classmates (excluding brothers or sisters)?"
          input:
            control: Radio
            labels:
              1: "Very well (or no problems)"
              2: "Quite well (or hardly any problems)"
              3: "Pretty well (or occasional problems)"
              4: "Not too well (or frequent problems)"
              5: "Not well at all (or constant problems)"

        # -----------------------------------------------------------------
        # F10: Personal computers in home
        # -----------------------------------------------------------------
        - id: q_f10
          kind: Question
          title: "How many personal computers are there in your home?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "One"
              3: "Two"
              4: "Three or more"

        # -----------------------------------------------------------------
        # F11: No-computer barriers — only if F10 = None (1)
        # Multi-select: Why no computer?
        # -----------------------------------------------------------------
        - id: qg_f11
          kind: QuestionGroup
          title: "What are the reasons that keep you from purchasing a personal computer? (Please answer yes or no to each)"
          precondition:
            - predicate: q_f10.outcome == 1
          questions:
            - "Cost"
            - "Not needed at home"
            - "Not interested"
            - "Lack of computer skills or training"
            - "Fear of technology"
            - "Disability"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # F12: Internet connection — only if F10 = 1+ computer (2, 3, or 4)
        # -----------------------------------------------------------------
        - id: q_f12
          kind: Question
          title: "Is your household connected to the Internet?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # -----------------------------------------------------------------
        # F13: No-internet barriers — only if F12 = No (3)
        # Multi-select: Why no Internet at home?
        # -----------------------------------------------------------------
        - id: qg_f13
          kind: QuestionGroup
          title: "What are the reasons that keep you from getting Internet access for your HOME? (Please answer yes or no to each)"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 3
          questions:
            - "Cost"
            - "Not needed at home"
            - "Not interested"
            - "Lack of computer skills or training"
            - "Fear of technology"
            - "Disability"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # F14: Child uses Internet at home — only if F12 = Yes (1)
        # -----------------------------------------------------------------
        - id: q_f14
          kind: Question
          title: "Does ..... use the Internet AT HOME?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # -----------------------------------------------------------------
        # F15: Child non-use barriers — only if F14 = No (3)
        # Multi-select: Why doesn't child use Internet?
        # -----------------------------------------------------------------
        - id: qg_f15
          kind: QuestionGroup
          title: "What are the reasons that keep ..... from using the Internet at home? (Please answer yes or no to each)"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 3
          questions:
            - "Child too young or not ready to use it"
            - "Child does not need it"
            - "Child is not interested"
            - "Child does not have the computer skills or training"
            - "Child's condition or health problem"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # F16a: Internet newsgroups/chat — only if F14 = Yes (1)
        # -----------------------------------------------------------------
        - id: q_f16a
          kind: Question
          title: "AT HOME, how often does he/she use Internet to participate in newsgroups or chat groups?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F16a_hrs: Hours per day — only if F16a not Never
        - id: q_f16a_hrs
          kind: Question
          title: "How many hours a day does he/she use Internet for newsgroups or chat groups?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
            - predicate: q_f16a.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F16b: Internet for school work
        # -----------------------------------------------------------------
        - id: q_f16b
          kind: Question
          title: "AT HOME, how often does he/she use Internet for school work?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F16b_hrs: Hours per day — only if F16b not Never
        - id: q_f16b_hrs
          kind: Question
          title: "How many hours a day does he/she use Internet for school work?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
            - predicate: q_f16b.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F16c: Internet for personal interest/entertainment
        # -----------------------------------------------------------------
        - id: q_f16c
          kind: Question
          title: "AT HOME, how often does he/she use Internet for personal interest or entertainment?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F16c_hrs: Hours per day — only if F16c not Never
        - id: q_f16c_hrs
          kind: Question
          title: "How many hours a day does he/she use Internet for personal interest or entertainment?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
            - predicate: q_f16c.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F16d: Internet e-mail to stay in touch with friends
        # -----------------------------------------------------------------
        - id: q_f16d
          kind: Question
          title: "AT HOME, how often does he/she use E-mail to stay in touch with friends?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F16d_hrs: Hours per day — only if F16d not Never
        - id: q_f16d_hrs
          kind: Question
          title: "How many hours a day does he/she use E-mail to stay in touch with friends?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
            - predicate: q_f16d.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

    # ===================================================================
    # SECTION: home_accommodation
    # ===================================================================
    # =========================================================================
    # SECTION G — HOME ACCOMMODATION
    # =========================================================================
    # G_AGE.edit: Section G is NOT asked if child was born AFTER May 15, 1996
    # (captured via extern child_under_5 == 1 → skip entire block).
    #
    # ENTERING/LEAVING subsection:
    #   G1 (use?) → Yes → G2 (which?); No/DK/R → G3
    #   G2 multi-select (Yes/No per sub-item) → G3
    #   G3 (need?) → Yes → G4; No/DK/R → G6
    #   G4 multi-select → G5
    #   G5 multi-select (Yes/No per sub-item, why not) → G6
    #
    # INSIDE residence subsection:
    #   G6 (use?) → Yes → G7; No/DK/R → G8
    #   G7 multi-select (Yes/No per sub-item) → G8
    #   G8 (need?) → Yes → G9; No/DK/R → end
    #   G9 multi-select → G10
    #   G10 multi-select (Yes/No per sub-item, why not) → end
    # =========================================================================
    - id: b_home_accommodation
      title: "Home Accommodation"
      precondition:
        - predicate: child_under_5 == 0

      items:

        # ------------------------------------------------------------------
        # ENTERING / LEAVING RESIDENCE
        # ------------------------------------------------------------------

        # G1: Does child USE special features to enter/leave residence?
        - id: q_g1
          kind: Question
          title: "Because of a condition or health problem, does ..... USE any special features, such as access ramps or automatic door openers to ENTER or LEAVE his/her residence?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # G2: Which entering/leaving features does child USE?
        # Asked only if G1 = Yes (1)
        - id: qg_g2
          kind: QuestionGroup
          title: "Which special features does he/she use? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_g1.outcome == 1
          questions:
            - "Ramps or street level entrances"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "An elevator or lift device"
            - "Other feature, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G3: Does child NEED special features to enter/leave that he/she does not have?
        # Asked after G2 (always) or after G1 No/DK/R
        - id: q_g3
          kind: Question
          title: "Does ..... CURRENTLY need any special features to enter or leave his/her residence, which he/she does not have?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # G4: Which entering/leaving features does child NEED but not have?
        # Asked only if G3 = Yes (1)
        - id: qg_g4
          kind: QuestionGroup
          title: "Which special features does ..... NEED, but does not have?"
          precondition:
            - predicate: q_g3.outcome == 1
          questions:
            - "Ramps or street level entrances"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "An elevator or lift device"
            - "Other feature, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G5: Why doesn't child have the needed entering/leaving features?
        # Asked only if G3 = Yes (1)
        - id: qg_g5
          kind: QuestionGroup
          title: "Why doesn't ..... have these special features that he/she needs to enter or leave his/her residence? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_g3.outcome == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Landlord/landlady not willing"
            - "Only needed occasionally"
            - "Other reason, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # ------------------------------------------------------------------
        # INSIDE RESIDENCE
        # ------------------------------------------------------------------

        # G6: Does child USE special features inside residence?
        - id: q_g6
          kind: Question
          title: "Because of a condition or health problem, does ..... USE any special features, such as special railings, grab bars or lift devices INSIDE his/her residence?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # G7: Which inside features does child USE?
        # Asked only if G6 = Yes (1)
        - id: qg_g7
          kind: QuestionGroup
          title: "Which special features does ..... use INSIDE his/her residence? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_g6.outcome == 1
          questions:
            - "Grab bars or bath lift device in the bathroom"
            - "Lowered counters, sinks or switches in the kitchen"
            - "An elevator or lift device"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "Visual or flashing alarms"
            - "Audio warning devices"
            - "Other feature, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G8: Does child NEED special features inside that he/she does not have?
        # Asked after G7 (always) or after G6 No/DK/R
        - id: q_g8
          kind: Question
          title: "Does ..... CURRENTLY need any special features INSIDE his/her residence, which he/she does not have?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # G9: Which inside features does child NEED but not have?
        # Asked only if G8 = Yes (1)
        - id: qg_g9
          kind: QuestionGroup
          title: "Which special features does ..... NEED, but does not have?"
          precondition:
            - predicate: q_g8.outcome == 1
          questions:
            - "Grab bars or bath lift device in the bathroom"
            - "Lowered counters, sinks or switches in the kitchen"
            - "An elevator or lift device"
            - "Widened doorways or hallways"
            - "Automatic or easy to open doors"
            - "Visual or flashing alarms"
            - "Audio warning devices"
            - "Other feature, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G10: Why doesn't child have the needed inside features?
        # Asked only if G8 = Yes (1)
        - id: qg_g10
          kind: QuestionGroup
          title: "Why doesn't ..... have these special features INSIDE his/her residence? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_g8.outcome == 1
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Landlord/landlady not willing"
            - "Only needed occasionally"
            - "Other reason, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: transportation
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SECTION H — TRANSPORTATION (items H1–H16)
    # =========================================================================
    # H1   → Car features? Radio 5-way (Yes/No/No car/DK/R). 1/DK/R→H3; 3→H2; 5→H5.
    # H2   → Need other features? Radio Yes/No/DK. 1→H4; 3→H3; DK/R→H5.
    # H3   → Need any features? Radio Yes/No/DK. 1/3→H4; DK/R→H5.
    # H4   → Why not have features? QuestionGroup 4 sub-items Switch. →H5.
    # H5   → Specialized bus service available? Radio Yes/No/DK. 1→H7; 3/DK/R→H6.
    # H6   → Does child need this service? Radio Yes/No/DK. 1→H7; 3/DK/R→H11.
    # H7   → Does child use this service? Radio Yes/No/DK. 1/3→H8; DK/R→H11.
    # H8   → How often? Radio 4-point. →H9.
    # H9   → Had difficulty? Radio Yes/No/DK. 1/3→H10/H11; DK/R→H11.
    # H10  → What difficulty? QuestionGroup 5 sub-items Switch. →H11.
    # H11  → Had to use taxi? Radio Yes/No/DK. 1/3→H12; DK/R→H13.
    # H12  → How often taxi? Radio 4-point. →H13.
    # H13  → Cancel/reschedule activities? Radio Yes/No. →H14.
    # H14  → Out-of-pocket transport expenses? Radio Yes/No/DK. 1/3→H15; DK/R→end.
    # H15  → Estimated dollar amount (0=DK/R). Editbox 0–999999. 0→H16; >0→end.
    # H16  → Expense group. Radio 7 options. →end.
    # =========================================================================
    - id: b_transportation
      title: "Transportation"
      precondition:
        - predicate: child_under_5 == 0
      items:

        # H1: Car has special features/equipment?
        # 1=Yes → H3; 3=No → H2; 5=No car → H5; 8=DK → H3; 9=R → H3
        - id: q_h1
          kind: Question
          title: "I would like to ask you about the means of transportation that ..... uses for local travel on his/her own or with someone else. This includes trips to the doctor, recreational events or any other local trips under 80 km (50 miles). Because of .....'s condition, does your car have special features or equipment, such as a lift device or a large trunk to carry a wheelchair?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Do not own a car"
              8: "Don't know"
              9: "Refusal"

        # H2: Need any other special features for car?
        # Precondition: H1 = No (3 only)
        # 1=Yes → H4; 3=No → H3; 8=DK → H5; 9=R → H5
        - id: q_h2
          kind: Question
          title: "Do you NEED ANY OTHER special features or equipment for your car because of .....'s condition?"
          precondition:
            - predicate: q_h1.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H3: Need any special features for car?
        # Precondition: H1 in {1,8,9} (Yes/DK/R) OR H2 = No (3)
        # 1=Yes → H4; 3=No → H4; 8=DK → H5; 9=R → H5
        - id: q_h3
          kind: Question
          title: "Because of .....'s condition, do you NEED any special features or equipment (for your car)?"
          precondition:
            - predicate: (q_h1.outcome in [1, 8, 9]) or (q_h1.outcome == 3 and q_h2.outcome == 3)
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H4: Why not have special features for car? (4 sub-items)
        # Precondition: H2 = Yes (1), OR H3 in {1, 3}
        # Always → H5
        - id: qg_h4
          kind: QuestionGroup
          title: "Why do you not have these special features or equipment for your car? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: (q_h2.outcome == 1) or (q_h3.outcome in [1, 3])
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Only needed occasionally"
            - "Other reason, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H5: Specialized bus service available in area?
        # No item-level precondition (reached from all car-feature paths and from H1=5)
        # 1=Yes → H7; 3=No → H6; 8=DK → H6; 9=R → H6
        - id: q_h5
          kind: Question
          title: "Some communities have a specialized bus service for people who have difficulty using regular transportation services. (To use this service, people can call ahead and ask to be picked up). Is this service available in your area?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H6: Does child need this specialized bus service?
        # Precondition: H5 in {3, 8, 9} (No/DK/R — service not confirmed available)
        # 1=Yes → H7; 3=No → H11; 8=DK → H11; 9=R → H11
        - id: q_h6
          kind: Question
          title: "Does ..... NEED this service?"
          precondition:
            - predicate: q_h5.outcome in [3, 8, 9]
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H7: Does child use this specialized bus service?
        # Precondition: H5 = Yes (1) OR H6 = Yes (1)
        # 1=Yes → H8; 3=No → H8; 8=DK → H11; 9=R → H11
        - id: q_h7
          kind: Question
          title: "Does ..... use this service?"
          precondition:
            - predicate: (q_h5.outcome == 1) or (q_h6.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H8: How often does child use specialized bus service?
        # Precondition: H7 in {1, 3} (Yes or No — not DK/R)
        # Always → H9
        - id: q_h8
          kind: Question
          title: "How often does he/she use this service?"
          precondition:
            - predicate: q_h7.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Almost everyday for at least some part of the year"
              2: "Frequently"
              3: "Occasionally"
              4: "Seldom"
              8: "Don't know"
              9: "Refusal"

        # H9: Had difficulty using specialized bus service in past 12 months?
        # Precondition: H7 in {1, 3} (H8 was shown, so H9 follows H8)
        # 1=Yes → H10; 3=No → H11; 8=DK → H11; 9=R → H11
        - id: q_h9
          kind: Question
          title: "IN THE PAST 12 MONTHS, did ..... have any difficulty using this service?"
          precondition:
            - predicate: q_h7.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H10: What kind of difficulty? (5 sub-items)
        # Precondition: H9 = Yes (1)
        # Always → H11
        - id: qg_h10
          kind: QuestionGroup
          title: "What kind of difficulty did he/she have? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_h9.outcome == 1
          questions:
            - "Service is needed more often than currently offered"
            - "Impractical scheduling for child's needs"
            - "Booking rules don't allow for last minute arrangements"
            - "Too expensive"
            - "Other reason, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H11: Had to use taxi service in past 12 months?
        # No item-level precondition (convergence point from all bus-service paths)
        # 1=Yes → H12; 3=No → H12; 8=DK → H13; 9=R → H13
        - id: q_h11
          kind: Question
          title: "IN THE PAST 12 MONTHS has ..... had to use a taxi service because of his/her condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H12: How often did child use taxi service?
        # Precondition: H11 in {1, 3} (Yes or No — not DK/R)
        # Always → H13
        - id: q_h12
          kind: Question
          title: "How often did he/she use a taxi service?"
          precondition:
            - predicate: q_h11.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Almost everyday for at least some part of the year"
              2: "Frequently"
              3: "Occasionally"
              4: "Seldom"
              8: "Don't know"
              9: "Refusal"

        # H13: Had to cancel/reschedule activities due to transportation problems?
        # No item-level precondition (universal convergence point)
        # Always → H14
        - id: q_h13
          kind: Question
          title: "IN THE PAST 12 MONTHS, for local trips which you must take with ....., have you had to cancel or reschedule some activities because of problems with transportation services?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H14: Out-of-pocket transportation expenses in past 12 months?
        # Always follows H13
        # 1=Yes → H15; 3=No → H15; 8=DK → end of section; 9=R → end of section
        - id: q_h14
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses for .....'s transportation, for example, his/her travel to and from treatment, therapy or other medical or rehabilitation services?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H15: Best estimate of out-of-pocket transportation costs?
        # Precondition: H14 in {1, 3} (Yes or No — not DK/R)
        # Valid amount (>0) → end of section; 0 (DK/R proxy) → H16
        - id: q_h15
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? (Enter 0 if you don't know or refuse to answer)"
          precondition:
            - predicate: q_h14.outcome in [1, 3]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # H16: Expense group (best estimate of direct costs)?
        # Precondition: H15 = 0 (Don't know / Refusal proxy)
        # Always → end of section
        - id: q_h16
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: q_h14.outcome in [1, 3] and q_h15.outcome == 0
          input:
            control: Radio
            labels:
              1: "Less than $100"
              2: "$100 to less than $200"
              3: "$200 to less than $500"
              4: "$500 to less than $1000"
              5: "$1000 to less than $2000"
              6: "$2000 to less than $5000"
              7: "$5000 or more"
              8: "Don't know"
              9: "Refusal"

    # ===================================================================
    # SECTION: economic_characteristics
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SECTION I — ECONOMIC CHARACTERISTICS (items I1–I10)
    # =========================================================================
    # I1   → Insurance coverage (3 sub-items: meds, glasses, hospital). QuestionGroup Switch.
    # I2   → Child Care Expenses tax credit claimed? Radio (Yes/No/DK/R).
    #         Yes → I3; No/DK/R → I4.
    # I3   → Did you receive it? (Child care credit) Radio (Yes/No/DK/R). → I4.
    # I4   → Medical Expenses tax credit claimed? Radio (Yes/No/DK/R).
    #         Yes → I5; No/DK/R → I6.
    # I5   → Did you receive it? (Medical expenses credit) Radio (Yes/No/DK/R). → I6.
    # I6   → Disability Tax Credit claimed? Radio (Yes/No/DK/R).
    #         Yes → I7; No → I8; DK/R → I9.
    # I7   → Did you receive it? (Disability tax credit) Radio (Yes/No/DK/R). → I9.
    # I8   → Why not claimed DTC? (4 sub-items, Yes/No grid). → I9.
    # I9   → Total household income (Editbox 0–999999). If answered → Follow-up.
    #         DK/R (coded 0) → sets dk_i9=1 → I10.
    # I10  → Income bracket Radio (10 groups). Precondition: dk_i9 == 1.
    # =========================================================================
    - id: b_economic
      title: "Economic Characteristics"
      items:

        # I1: Insurance coverage — 3 sub-items (a) meds, (b) glasses, (c) hospital
        # All respondents.
        - id: qg_i1
          kind: QuestionGroup
          title: "Do you have insurance that covers all or part of: (a) the cost of .....'s prescription medications? (b) the cost of .....'s eye glasses or contact lenses? (c) hospital charges for a private or semi-private room?"
          questions:
            - "(a) Prescription medications"
            - "(b) Eye glasses or contact lenses"
            - "(c) Hospital charges for a private or semi-private room"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # I2: Child Care Expenses tax credit claimed?
        # 1=Yes → I3; 3=No → I4; 8=DK → I4; 9=Refusal → I4
        - id: q_i2
          kind: Question
          title: "Did you claim Child Care Expenses for ..... with your 2000 income tax return?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I3: Did you receive the Child Care Expenses tax credit?
        # Precondition: I2 = Yes (outcome == 1)
        # → I4
        - id: q_i3
          kind: Question
          title: "Did you receive it? (Child Care Expenses tax credit)"
          precondition:
            - predicate: q_i2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I4: Medical Expenses tax credit claimed?
        # 1=Yes → I5; 3=No → I6; 8=DK → I6; 9=Refusal → I6
        - id: q_i4
          kind: Question
          title: "Did you claim Medical Expenses for ..... with your 2000 income tax return?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I5: Did you receive the Medical Expenses tax credit?
        # Precondition: I4 = Yes (outcome == 1)
        # → I6
        - id: q_i5
          kind: Question
          title: "Did you receive it? (Medical Expenses tax credit)"
          precondition:
            - predicate: q_i4.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I6: Disability Tax Credit claimed?
        # 1=Yes → I7; 3=No → I8; 8=DK → I9; 9=Refusal → I9
        - id: q_i6
          kind: Question
          title: "Did you claim a Disability Tax Credit for ..... with your 2000 income tax return?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I7: Did you receive the Disability Tax Credit?
        # Precondition: I6 = Yes (outcome == 1)
        # → GO TO I9 (skip I8)
        - id: q_i7
          kind: Question
          title: "Did you receive it? (Disability Tax Credit)"
          precondition:
            - predicate: q_i6.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # I8: Why did you not claim the Disability Tax Credit?
        # 4 sub-items (a)–(d), Yes/No per sub-item.
        # Precondition: I6 = No (outcome == 3)
        # (a) Did not know it existed
        # (b) Did not think child would meet eligibility requirements
        # (c) Not able to obtain the disability certificate (Form T2201)
        # (d) Other reason
        # → I9
        - id: qg_i8
          kind: QuestionGroup
          title: "Why did you not claim the Disability Tax Credit? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_i6.outcome == 3
          questions:
            - "(a) You did not know it existed"
            - "(b) You did not think that ..... would meet the eligibility requirements"
            - "(c) You were not able to obtain the disability certificate (Form T2201) from your doctor"
            - "(d) Other reason, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # I9: Total household income before taxes and deductions (year ending Dec 31, 2000)
        # Amount → GO TO Follow-up; 0 treated as DK/R → I10.
        # If respondent cannot give a precise amount (DK/R), they enter 0 which triggers I10.
        # codeBlock sets dk_i9 = 1 when outcome == 0 to gate I10.
        - id: q_i9
          kind: Question
          title: "For the year ending December 31, 2000, what is your best estimate of the total income, before taxes and deductions, of all household members, including yourself, from all sources? (Enter 0 if no income, a loss, or if unable to estimate)"
          codeBlock: |
            if q_i9.outcome == 0:
                dk_i9 = 1
            else:
                dk_i9 = 0
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # I10: Household income bracket
        # Precondition: I9 respondent could not give precise amount (dk_i9 == 1)
        # → GO TO Follow-up
        - id: q_i10
          kind: Question
          title: "Can you estimate in which of the following groups your HOUSEHOLD INCOME fell?"
          precondition:
            - predicate: dk_i9 == 1
          input:
            control: Radio
            labels:
              1: "$1 to less than $5,000"
              2: "$5,000 to less than $10,000"
              3: "$10,000 to less than $15,000"
              4: "$15,000 to less than $20,000"
              5: "$20,000 to less than $30,000"
              6: "$30,000 to less than $40,000"
              7: "$40,000 to less than $50,000"
              8: "$50,000 to less than $60,000"
              9: "$60,000 to less than $80,000"
              10: "$80,000 or more"
              11: "Don't know"
              12: "Refusal"

    # ===================================================================
    # SECTION: follow_up
    # ===================================================================
    # FU1 — longitudinal follow-up contact capture (inventory item 267)
    # ===================================================================
    - id: b_follow_up
      title: "Follow-up"
      items:
        - id: q_fu1
          kind: Question
          title: "That's the end of our questions. Someone from Statistics Canada may contact you in a year or two to find out more about this topic. In case there are difficulties reaching you, could you please give the name, address and telephone number of a family member or friend we could contact?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              7: "Refusal"

        - id: q_fu1_contact
          kind: Question
          title: "Please provide the name, address, and telephone number of the alternate contact."
          precondition:
            - predicate: q_fu1.outcome == 1
          input:
            control: Textarea
            placeholder: "Name, address, phone number"
