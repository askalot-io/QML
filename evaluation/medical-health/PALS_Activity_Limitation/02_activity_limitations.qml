qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 (Children) — Section B: Activity Limitations"
  codeInit: |
    # Extern variables from Section A and survey setup
    limitation_general: {0, 1}
    child_under_5: {0, 1}

    # Limitation flags (Profile Sheet)
    limitation_hearing = 0
    limitation_seeing = 0
    limitation_communicating = 0
    limitation_walking = 0
    limitation_hands = 0
    limitation_learning = 0
    limitation_developmental = 0
    limitation_emotional = 0
    limitation_chronic = 0

    # USE Aid flags (Profile Sheet)
    use_aid_hearing = 0
    use_aid_seeing = 0
    use_aid_communicating = 0
    use_aid_walking = 0
    use_aid_hands = 0
    use_aid_learning = 0
    use_aid_chronic = 0

    # NEED Aid flags (Profile Sheet)
    need_aid_hearing = 0
    need_aid_seeing = 0
    need_aid_communicating = 0
    need_aid_walking = 0
    need_aid_hands = 0
    need_aid_learning = 0
    need_aid_chronic = 0

    # Aggregate counters (computed at B62.edit)
    limitation_count = 0
    use_aid_count = 0
    need_aid_count = 0

    # Routing helper: tracks whether hearing limitation was found
    # (needed to determine if hearing aids subsection is reached)
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

  blocks:
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
