qmlVersion: "1.0"
questionnaire:
  title: "Labour Force Survey - Contact Component"

  codeInit: |
    # Variables PRODUCED by this section (read by later sections)
    interview_type = 0    # 1=birth in person, 2=birth CATI, 3=subsequent

  blocks:
    # =========================================================================
    # BLOCK 1: INTERVIEW TYPE CLASSIFICATION
    # =========================================================================
    # The original CATI system uses metadata to determine interview type
    # (birth in person, birth by telephone, subsequent by telephone).
    # This is modeled as an explicit interviewer classification question
    # since QML has no system metadata. The entire Contact Component's
    # routing hinges on this value.
    # =========================================================================
    - id: b_interview_type
      title: "Interview Type"
      items:
        - id: q_interview_type
          kind: Question
          title: "What is the interview type? (System metadata in original CATI.)"
          codeBlock: |
            interview_type = q_interview_type.outcome
          input:
            control: Radio
            labels:
              1: "Birth interview in person"
              2: "Birth interview by telephone (CATI)"
              3: "Subsequent interview by telephone"

    # =========================================================================
    # BLOCK 2: INITIAL INTRODUCTION AND RESPONDENT CONTACT
    # =========================================================================
    # II_R01A: Opening script (all telephone interviews)
    # SR_Q01: Subsequent interview — locate named respondent
    # II_R01B: Re-introduction after respondent becomes available
    # TC_Q01: Wrong number verification (from SR_Q01=5)
    #
    # Routing:
    #   interview_type=1 (in person) -> skip to IC_R01
    #   interview_type=2 (birth CATI) -> II_R01A then AR_Q01
    #   interview_type=3 (subsequent) -> II_R01A then SR_Q01
    #   SR_Q01: 1->IC_R01, 2->II_R01B->IC_R01, 3,4->AR_Q01, 5->TC_Q01
    #   TC_Q01: Yes->AR_Q01, No->call_ended
    # =========================================================================
    - id: b_initial_contact
      title: "Initial Introduction and Respondent Contact"
      precondition:
        - predicate: interview_type == 2 or interview_type == 3
      items:
        # II_R01A: Opening script for all telephone interviews
        - id: q_ii_r01a
          kind: Comment
          title: "Hello, I'm calling from Statistics Canada. My name is .... (Opening introduction for telephone interviews.)"

        # SR_Q01: Subsequent interview — locate named respondent
        - id: q_sr_q01
          kind: Question
          title: "May I speak with ...? (Named respondent from previous rotation.)"
          precondition:
            - predicate: interview_type == 3
          input:
            control: Radio
            labels:
              1: "Yes, speaking to respondent"
              2: "Yes, respondent available"
              3: "No, respondent not available"
              4: "No, respondent no longer a household member"
              5: "Wrong number"

        # II_R01B: Re-introduction after respondent becomes available
        # Precondition: SR_Q01=2 (respondent available, someone went to get them)
        - id: q_ii_r01b
          kind: Comment
          title: "Hello, I'm calling from Statistics Canada. My name is .... (Re-introduction to respondent after transfer.)"
          precondition:
            - predicate: q_sr_q01.outcome == 2

        # TC_Q01: Wrong number verification
        # Precondition: SR_Q01=5 (wrong number)
        # Yes -> proceed to AR_Q01; No -> call ends (modeled as terminal)
        - id: q_tc_q01
          kind: Question
          title: "I would like to make sure I've dialled the right number. Is this ...? (If No, thank person and end call.)"
          precondition:
            - predicate: q_sr_q01.outcome == 5
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 3: ADULT CONTACT
    # =========================================================================
    # AR_Q01: Locate an adult household member
    # II_R01C: Re-introduction after adult becomes available
    #
    # Reached when:
    #   - Birth CATI interview (interview_type=2, directly after II_R01A)
    #   - SR_Q01=3 or 4 (respondent not available / no longer member)
    #   - TC_Q01=Yes (confirmed number, need adult)
    #
    # AR_Q01 routing:
    #   1 and birth CATI -> TFCC_Q01
    #   1 and not birth CATI -> IC_R01
    #   2 -> II_R01C (then same as 1 path)
    #   3 -> appointment scheduling (SRA/ARA block)
    # =========================================================================
    - id: b_adult_contact
      title: "Adult Contact"
      items:
        # AR_Q01: May I speak with an adult?
        # Reached by: birth CATI (after II_R01A), SR_Q01 in {3,4}, TC_Q01=Yes
        - id: q_ar_q01
          kind: Question
          title: "May I speak with an adult member of the household?"
          precondition:
            - predicate: "interview_type == 2 or (interview_type == 3 and (q_sr_q01.outcome == 3 or q_sr_q01.outcome == 4 or q_tc_q01.outcome == 1))"
          input:
            control: Radio
            labels:
              1: "Yes, speaking to an adult member"
              2: "Yes, an adult member is available"
              3: "No, an adult member is not available"

        # II_R01C: Re-introduction after adult becomes available
        # Precondition: AR_Q01=2 (adult available, someone went to get them)
        - id: q_ii_r01c
          kind: Comment
          title: "Hello, I'm calling from Statistics Canada. My name is .... (Re-introduction to adult household member after transfer.)"
          precondition:
            - predicate: q_ar_q01.outcome == 2

    # =========================================================================
    # BLOCK 4: APPOINTMENT SCHEDULING (TERMINAL PATHS)
    # =========================================================================
    # SRA_Q01: Schedule appointment for named respondent
    #   Reached: AR_Q01=3 and interview_type=3 and SR_Q01=3
    # ARA_Q01: Schedule appointment for any adult
    #   Reached: SRA_Q01=3, or AR_Q01=3 and (birth or SR_Q01 in {4,5})
    #
    # All paths in this block end the call (terminal).
    # =========================================================================
    - id: b_appointments
      title: "Appointment Scheduling"
      items:
        # SRA_Q01: Schedule appointment for specific respondent
        # Reached: subsequent interview, respondent not available, adult not available
        - id: q_sra_q01
          kind: Question
          title: "I would like to contact .... When would he/she be available? (Terminal: appointment made or proceed to ARA_Q01.)"
          precondition:
            - predicate: q_ar_q01.outcome == 3
            - predicate: interview_type == 3
            - predicate: q_sr_q01.outcome == 3
          input:
            control: Radio
            labels:
              1: "Hard appointment"
              2: "Soft appointment"
              3: "Not available"

        # ARA_Q01: Schedule appointment for any adult
        # Reached: SRA_Q01=3, or AR_Q01=3 for birth interview,
        #   or AR_Q01=3 for subsequent with SR_Q01=4 or SR_Q01=5
        - id: q_ara_q01
          kind: Question
          title: "When would an adult member of the household be available? (Terminal: appointment made or call ends.)"
          precondition:
            - predicate: "(q_ar_q01.outcome == 3 and interview_type == 2) or (q_ar_q01.outcome == 3 and interview_type == 3 and (q_sr_q01.outcome == 4 or q_sr_q01.outcome == 5)) or q_sra_q01.outcome == 3"
          input:
            control: Radio
            labels:
              1: "Hard appointment"
              2: "Soft appointment"
              3: "Not available"

    # =========================================================================
    # BLOCK 5: ADDRESS CONFIRMATION (BIRTH CATI ONLY)
    # =========================================================================
    # TFCC_Q01: Confirm address for first-time CATI households
    # TFCC_Q02: Confirm phone number if address wrong (terminal)
    #
    # Reached: birth CATI interview (interview_type=2) and AR_Q01=1 or
    #   AR_Q01=2 (via II_R01C)
    # =========================================================================
    - id: b_address_confirm
      title: "Address Confirmation"
      precondition:
        - predicate: interview_type == 2
      items:
        # TFCC_Q01: Confirm address
        # Reached: birth CATI and adult is speaking (AR_Q01=1 or 2)
        - id: q_tfcc_q01
          kind: Question
          title: "In order to make sure I've reached the correct household, I need to confirm your address. Is it ...?"
          precondition:
            - predicate: q_ar_q01.outcome == 1 or q_ar_q01.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # TFCC_Q02: Confirm phone number if address is wrong (terminal)
        - id: q_tfcc_q02
          kind: Question
          title: "I would like to make sure I've dialled the right number. Is this ...? (Terminal: thank person and end call regardless of answer.)"
          precondition:
            - predicate: q_tfcc_q01.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 6: SURVEY INTRODUCTION AND LANGUAGE PREFERENCE
    # =========================================================================
    # IC_R01: Survey introduction script
    # LP_Q01: Language of interview preference
    # MON_R01: Monitoring notice (CATI only)
    #
    # IC_R01 reached by many paths:
    #   - interview_type=1 (in person, directly)
    #   - SR_Q01=1 (speaking to respondent)
    #   - II_R01B shown (SR_Q01=2, respondent transferred)
    #   - AR_Q01=1 and not birth CATI
    #   - II_R01C shown and not birth CATI
    #   - TFCC_Q01=Yes (address confirmed for birth CATI)
    #
    # All non-terminal paths converge here. The precondition excludes
    # terminal paths: call_ended scenarios (TC_Q01=No, TFCC_Q02,
    # appointments) are excluded by requiring none of the terminal
    # conditions to be the final state.
    # =========================================================================
    - id: b_survey_intro
      title: "Survey Introduction and Language Preference"
      items:
        # IC_R01: Survey introduction
        - id: q_ic_r01
          kind: Comment
          title: "I'm calling regarding the Labour Force Survey. (Survey introduction read to respondent.)"

        # LP_Q01: Language preference
        - id: q_lp_q01
          kind: Question
          title: "Would you prefer to be interviewed in English or in French?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # MON_R01: Monitoring notice (CATI interviews only)
        - id: q_mon_r01
          kind: Comment
          title: "My supervisor may listen to this call for the purpose of quality control. (Read for CATI interviews only; proceed to Household Component.)"
          precondition:
            - predicate: interview_type == 2 or interview_type == 3
