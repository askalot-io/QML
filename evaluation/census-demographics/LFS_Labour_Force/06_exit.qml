qmlVersion: "1.0"
questionnaire:
  title: "Labour Force Survey - Exit Component"

  codeInit: |
    # Cross-section variables READ by this section
    interview_type: {1, 2, 3}
    dwelling_type: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    # Extern state flags
    # 1 = respondent is rotating out (final month), 0 = continuing
    is_rotate_out: {0, 1}
    # 1 = telephone number on file, 0 = no phone on file
    has_phone: {0, 1}
    # 1 = previous preferred call time exists, 0 = none
    has_previous_call_time: {0, 1}

  blocks:
    # =========================================================================
    # BLOCK 1: EXIT INTRODUCTION
    # =========================================================================
    # EI_R01: Transition read. Shown only for continuing respondents
    # (not rotate-out). Rotate-out respondents skip directly to TY_R02.
    # =========================================================================
    - id: b_exit_intro
      title: "Exit Introduction"
      precondition:
        - predicate: is_rotate_out == 0
      items:
        # EI_R01: Transition statement before scheduling questions
        - id: q_ei_r01
          kind: Comment
          title: "Before we finish, I would like to ask you a few other questions."

    # =========================================================================
    # BLOCK 2: FUTURE CONTACT SCHEDULING
    # =========================================================================
    # FC_R01: Inform respondent about next contact
    # HC_Q01: Best person to contact next month
    # Only for continuing respondents (not rotate-out).
    # =========================================================================
    - id: b_future_contact
      title: "Future Contact Scheduling"
      precondition:
        - predicate: is_rotate_out == 0
      items:
        # FC_R01: Next month contact information
        - id: q_fc_r01
          kind: Comment
          title: "We will contact your household next month during the week of [date]. This dwelling has [N] interview(s) left."

        # HC_Q01: Best person to contact
        - id: q_hc_q01
          kind: Question
          title: "Who would be the best person to contact for the next interview?"
          input:
            control: Textarea
            placeholder: "Enter name of best contact person"

    # =========================================================================
    # BLOCK 3: TELEPHONE CONFIRMATION
    # =========================================================================
    # TEL_Q01: Confirm existing phone number (only if phone on file)
    # TEL_Q02: Collect phone number (if no phone on file or TEL_Q01=No)
    # Only for continuing respondents.
    # =========================================================================
    - id: b_telephone
      title: "Telephone Confirmation"
      precondition:
        - predicate: is_rotate_out == 0
      items:
        # TEL_Q01: Confirm phone number on file
        # Only shown if a phone number already exists
        - id: q_tel_q01
          kind: Question
          title: "I would like to confirm your telephone number. Is it [number on file]?"
          precondition:
            - predicate: has_phone == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # TEL_Q02: Collect phone number
        # Shown if no phone on file, or if TEL_Q01 = No (outcome 0)
        - id: q_tel_q02
          kind: Question
          title: "What is your telephone number, including the area code?"
          precondition:
            - predicate: has_phone == 0 or q_tel_q01.outcome == 0
          input:
            control: Textarea
            placeholder: "Enter telephone number with area code"

    # =========================================================================
    # BLOCK 4: INTERVIEW MODE FOR NEXT MONTH
    # =========================================================================
    # PC_Q01: Permission for telephone interview next month
    #   Skipped if already CATI (interview_type 2 or 3) — already by phone.
    #   Yes → PTC_Q01 (call time); No → PV_R01 (personal visit)
    # PV_R01: Personal visit confirmation (only if PC_Q01 = No)
    # Only for continuing respondents.
    # =========================================================================
    - id: b_interview_mode
      title: "Interview Mode for Next Month"
      precondition:
        - predicate: is_rotate_out == 0
      items:
        # PC_Q01: May we conduct next interview by telephone?
        # Only for in-person interviews (type 1); CATI interviews skip this
        - id: q_pc_q01
          kind: Question
          title: "May we conduct the next interview by telephone?"
          precondition:
            - predicate: interview_type == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # PV_R01: Personal visit notification
        # Shown when PC_Q01 = No (outcome 0, in-person respondent declined phone)
        - id: q_pv_r01
          kind: Comment
          title: "We will make a personal visit next month."
          precondition:
            - predicate: q_pc_q01.outcome == 0

    # =========================================================================
    # BLOCK 5: PREFERRED CALL TIME
    # =========================================================================
    # PTC_Q01: Confirm previous preferred call time (if info exists)
    # PTC_Q02: Select preferred call time (if no info or PTC_Q01=No)
    # PTC_N03: Additional notes on preferred call time
    #
    # Reached when conducting next interview by phone:
    #   - CATI interviews (type 2 or 3) always reach this block
    #   - In-person interviews only if PC_Q01 = Yes (outcome 1)
    # =========================================================================
    - id: b_call_time
      title: "Preferred Call Time"
      precondition:
        - predicate: is_rotate_out == 0
        - predicate: interview_type == 2 or interview_type == 3 or q_pc_q01.outcome == 1
      items:
        # PTC_Q01: Confirm preferred call time from previous month
        # Only shown if previous call time information exists
        - id: q_ptc_q01
          kind: Question
          title: "Confirm preferred call time. Is [previous time] still a good time?"
          precondition:
            - predicate: has_previous_call_time == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # PTC_Q02: Select preferred call time
        # Shown if no previous info, or if PTC_Q01 = No (outcome 0)
        - id: q_ptc_q02
          kind: Question
          title: "What time of day would you prefer to be called? (Select all that apply.)"
          precondition:
            - predicate: has_previous_call_time == 0 or q_ptc_q01.outcome == 0
          input:
            control: Checkbox
            labels:
              1: "Any time"
              2: "Morning"
              4: "Afternoon"
              8: "Evening"
              16: "Not morning"
              32: "Not afternoon"
              64: "Not evening"

        # PTC_N03: Additional call time notes
        - id: q_ptc_n03
          kind: Question
          title: "Enter any other information about preferred call time."
          input:
            control: Textarea
            placeholder: "Enter additional call time preferences or notes"

    # =========================================================================
    # BLOCK 6: LIVING QUARTERS CHECK
    # =========================================================================
    # LQ_Q01: Check for additional living quarters in structure
    # LQ_N02: Reminder to verify cluster list
    #
    # Only shown for birth in-person interviews (type 1) at single/double/
    # row/duplex dwellings (types 1-4). CATI and subsequent interviews skip.
    # =========================================================================
    - id: b_living_quarters
      title: "Living Quarters Check"
      precondition:
        - predicate: is_rotate_out == 0
        - predicate: interview_type == 1
        - predicate: dwelling_type >= 1 and dwelling_type <= 4
      items:
        # LQ_Q01: Any other living quarters in this structure?
        - id: q_lq_q01
          kind: Question
          title: "Is there another set of living quarters within this structure?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # LQ_N02: Reminder to check cluster list
        - id: q_lq_n02
          kind: Comment
          title: "Remember to verify the cluster list for additional dwelling units."

    # =========================================================================
    # BLOCK 7: THANK YOU — CONTINUING RESPONDENTS
    # =========================================================================
    # TY_R01: Farewell for respondents who will be contacted again.
    # Shown only for non-rotate-out respondents.
    # =========================================================================
    - id: b_thankyou_continue
      title: "Thank You (Continuing)"
      precondition:
        - predicate: is_rotate_out == 0
      items:
        - id: q_ty_r01
          kind: Comment
          title: "Thank you for your participation."

    # =========================================================================
    # BLOCK 8: THANK YOU — ROTATE-OUT RESPONDENTS
    # =========================================================================
    # TY_R02: Farewell for respondents completing their final rotation.
    # Shown only for rotate-out respondents.
    # =========================================================================
    - id: b_thankyou_rotateout
      title: "Thank You (Rotate-Out)"
      precondition:
        - predicate: is_rotate_out == 1
      items:
        - id: q_ty_r02
          kind: Comment
          title: "Thank you. Your six months of participation in the Labour Force Survey are now complete."
