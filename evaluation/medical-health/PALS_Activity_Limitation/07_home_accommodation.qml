qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 (Children) — Section G: Home Accommodation"

  codeInit: |
    # Extern variable: child_under_5 == 1 means section G is skipped
    child_under_5: {0, 1}

  blocks:
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
