qmlVersion: "1.0"
questionnaire:
  title: "Canadian Labour Force Survey"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    interview_type = 0    # 1=birth in person, 2=birth CATI, 3=subsequent
    dwelling_type = 0   # 1-10 dwelling classification (from DW_Q01/DW_N02)
    tenure = 0          # 0=owned, 1=not owned (from TN_Q01)
    addresses_match = 1  # 1=match, 0=differ
    respondent_age = 0    # consolidated age from ANC_Q01 or ANC_Q03
    sex = 0               # 1=Male, 2=Female
    armed_forces = 0      # 1=Yes, 2=No (from CAF_Q01; 0 if skipped by age filter)
    recent_immigrant = 0  # 1 if immigration year within 5 years, 0 otherwise
    has_postsecondary = 0 # 1 if ED_Q04 was answered (post-secondary obtained), 0 otherwise
    path = 0
    usual_hours = 0
    actual_hours = 0
    last_work_recent = 0
    is_temp_layoff = 0
    search_status = 0

  blocks:

    # ===================================================================
    # SECTION: contact
    # ===================================================================
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

    # ===================================================================
    # SECTION: household
    # ===================================================================
    # =========================================================================
    # BLOCK 1: ADDRESS CONFIRMATION FILTER
    # =========================================================================
    # LA_N01: Router based on interview_type
    #   birth CATI (2) → MA_Q01
    #   subsequent in person (interview_type==3 but in-person variant) → CMA_Q01
    #   subsequent telephone (3) → SD_Q01
    #   birth in person (1) → MA_Q01
    #
    # Note: The original distinguishes "subsequent in person" vs "subsequent
    # telephone" but the interview_type extern only has 3 values. We treat
    # interview_type==3 as subsequent telephone (the dominant case); birth
    # interviews (1,2) go to MA_Q01.
    # =========================================================================
    - id: b_address_filter
      title: "Address Confirmation Filter"
      items:
        # LA_N01: Confirm listing address — interviewer filter
        - id: q_la_n01
          kind: Comment
          title: "Confirm the listing address. (Interviewer: routing depends on interview type. Birth CATI or in-person → mailing address. Subsequent telephone → address confirmation.)"

    # =========================================================================
    # BLOCK 2: ADDRESS CONFIRMATION — SUBSEQUENT TELEPHONE
    # =========================================================================
    # SD_Q01–SD_Q05: Only for subsequent telephone interviews (type 3).
    # SD_Q02–SD_Q05 are terminal paths that end the call; they are modeled
    # for completeness but represent interview termination.
    # =========================================================================
    - id: b_address_subsequent
      title: "Address Confirmation (Subsequent Telephone)"
      precondition:
        - predicate: interview_type == 3
      items:
        # SD_Q01: Still living at address?
        # 1 + addresses match → CHM_Q01; 1 + differ → CMA_Q01; 2 → SD_Q02; 3 → SD_Q05
        - id: q_sd_q01
          kind: Question
          title: "I would like to confirm your address. Are you still living at the address we have on file?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Respondent never lived there"

        # SD_Q02: Anyone still at that address?
        # Precondition: SD_Q01 = 2 (No, respondent moved)
        # Yes → SD_Q03; No → end call (terminal)
        - id: q_sd_q02
          kind: Question
          title: "Does anyone who was living with you at that address still live there?"
          precondition:
            - predicate: q_sd_q01.outcome == 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SD_Q03: Can provide new telephone number?
        # Precondition: SD_Q02 = 1 (Yes, someone still there)
        # Yes → SD_Q04; No → end call (terminal)
        - id: q_sd_q03
          kind: Question
          title: "Can you provide me with the current telephone number for that address?"
          precondition:
            - predicate: q_sd_q02.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SD_Q04: Collect telephone number
        # Precondition: SD_Q03 = 1 (Yes, can provide number)
        # Terminal: end call after collection
        - id: q_sd_q04
          kind: Question
          title: "What is that telephone number, including the area code?"
          precondition:
            - predicate: q_sd_q03.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter telephone number with area code"

        # SD_Q05: Confirm dialled number
        # Precondition: SD_Q01 = 3 (Respondent never lived there)
        # Terminal: end call regardless of answer
        - id: q_sd_q05
          kind: Question
          title: "I would like to make sure I've dialled the right number. Is this the number we have on file?"
          precondition:
            - predicate: q_sd_q01.outcome == 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 3: MAILING ADDRESS CONFIRMATION
    # =========================================================================
    # CHM_Q01: Subsequent telephone, SD_Q01=1, addresses match
    # CMA_Q01: Subsequent telephone SD_Q01=1 addresses differ, OR birth CATI
    # MA_Q01: Collect new mailing address (multiple entry paths)
    # =========================================================================
    - id: b_mailing_address
      title: "Mailing Address Confirmation"
      items:
        # CHM_Q01: Is listing address also mailing address?
        # Precondition: subsequent telephone (3), confirmed still living (SD_Q01=1),
        #               and addresses match
        # Yes → TN_Q01; No → MA_Q01
        - id: q_chm_q01
          kind: Question
          title: "Is this also your mailing address?"
          precondition:
            - predicate: interview_type == 3 and q_sd_q01.outcome == 1 and addresses_match == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CMA_Q01: Confirm mailing address
        # Precondition: (subsequent with SD_Q01=1 and addresses differ) OR
        #               (birth in person, interview_type==1 — needs CMA path)
        # Yes → TN_Q01; No → MA_Q01
        - id: q_cma_q01
          kind: Question
          title: "I would like to confirm your mailing address. Is the address we have on file correct?"
          precondition:
            - predicate: (interview_type == 3 and q_sd_q01.outcome == 1 and addresses_match == 0) or interview_type == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MA_Q01: Collect correct mailing address
        # Reached when: birth CATI (type 2), OR CHM_Q01=No, OR CMA_Q01=No
        # After MA_Q01: birth in person → DW_N02; birth CATI → DW_Q01;
        #               subsequent → TN_Q01
        - id: q_ma_q01
          kind: Question
          title: "What is your correct mailing address?"
          precondition:
            - predicate: interview_type == 2 or (interview_type == 3 and q_sd_q01.outcome == 1 and addresses_match == 1 and q_chm_q01.outcome == 0) or (interview_type == 3 and q_sd_q01.outcome == 1 and addresses_match == 0 and q_cma_q01.outcome == 0) or (interview_type == 1 and q_cma_q01.outcome == 0)
          input:
            control: Textarea
            placeholder: "Enter full mailing address"

    # =========================================================================
    # BLOCK 4: DWELLING TYPE
    # =========================================================================
    # DW_Q01: Birth CATI telephone interview (type 2) — interviewer asks
    # DW_N02: Birth in-person interview (type 1) — interviewer selects
    # These are mutually exclusive by interview_type.
    # Both produce dwelling_type variable.
    # =========================================================================
    - id: b_dwelling
      title: "Dwelling Type"
      precondition:
        - predicate: interview_type == 1 or interview_type == 2
      items:
        # DW_Q01: Dwelling type — telephone birth interview
        - id: q_dw_q01
          kind: Question
          title: "What type of dwelling do you live in? Is it a:"
          precondition:
            - predicate: interview_type == 2
          codeBlock: |
            dwelling_type = q_dw_q01.outcome
          input:
            control: Dropdown
            labels:
              1: "Single detached"
              2: "Double"
              3: "Row or terrace"
              4: "Duplex"
              5: "Low-rise apartment"
              6: "High-rise apartment"
              7: "Institution"
              8: "Hotel/rooming/lodging house/camp"
              9: "Mobile home"
              10: "Other"

        # DW_N02: Dwelling type — in-person birth interview (interviewer selects)
        - id: q_dw_n02
          kind: Question
          title: "Select the dwelling type. (Interviewer observation — in-person birth interview.)"
          precondition:
            - predicate: interview_type == 1
          codeBlock: |
            dwelling_type = q_dw_n02.outcome
          input:
            control: Dropdown
            labels:
              1: "Single detached"
              2: "Double"
              3: "Row or terrace"
              4: "Duplex"
              5: "Low-rise apartment"
              6: "High-rise apartment"
              7: "Institution"
              8: "Hotel/rooming/lodging house/camp"
              9: "Mobile home"
              10: "Other"

    # =========================================================================
    # BLOCK 5: TENURE
    # =========================================================================
    # TN_Q01: Asked for all interview types that reach this point.
    # Subsequent telephone interviews that confirmed address (CHM/CMA=Yes)
    # skip dwelling type and come directly here. Birth interviews come
    # after DW_Q01/DW_N02.
    # =========================================================================
    - id: b_tenure
      title: "Tenure"
      items:
        # TN_Q01: Dwelling owned by household member?
        # Switch: on="Yes" (1=owned), off="No" (0=not owned)
        # tenure: 0=owned, 1=not owned (inverted from Switch outcome)
        - id: q_tn_q01
          kind: Question
          title: "Is this dwelling owned by a member of this household?"
          codeBlock: |
            if q_tn_q01.outcome == 1:
              tenure = 0
            else:
              tenure = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 6: HOUSEHOLD ROSTER — BIRTH INTERVIEWS
    # =========================================================================
    # RS_R01: Introduction (always shown)
    # Birth interviews (type 1 or 2): USU_Q01 → RS_Q02 → TEM_Q01 → RS_Q04 → OTH1_Q01
    # QML cannot model dynamic roster loops; roster items use Textarea.
    # =========================================================================
    - id: b_roster_birth
      title: "Household Roster (Birth Interview)"
      precondition:
        - predicate: interview_type == 1 or interview_type == 2
      items:
        # RS_R01: Roster introduction
        - id: q_rs_r01_birth
          kind: Comment
          title: "The next few questions ask for important basic information about the people in your household."

        # USU_Q01: Usual household members
        # Original: roster loop; modeled as Textarea
        - id: q_usu_q01
          kind: Question
          title: "What are the names of all persons who usually live here? Begin with adults who have responsibility for the care or support of the family."
          input:
            control: Textarea
            placeholder: "Enter names of all usual household members..."

        # RS_Q02: Anyone staying temporarily?
        # Yes → TEM_Q01; No → RS_Q04
        - id: q_rs_q02
          kind: Question
          title: "Is anyone staying here temporarily?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # TEM_Q01: Temporary residents roster
        # Precondition: RS_Q02 = Yes (1)
        - id: q_tem_q01
          kind: Question
          title: "What are the names of all persons staying here temporarily? Add a person only if he/she has no other usual residence elsewhere."
          precondition:
            - predicate: q_rs_q02.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter names of temporary residents..."

        # RS_Q04: Others usually here but away?
        # Yes → OTH1_Q01; No → next section
        - id: q_rs_q04
          kind: Question
          title: "Are there any other persons who usually live here but are now away at school, in hospital, or somewhere else?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # OTH1_Q01: Absent household members roster
        # Precondition: RS_Q04 = Yes (1)
        - id: q_oth1_q01
          kind: Question
          title: "What are the names of the other people who live or stay here? Add a person only if he/she has no other usual residence elsewhere."
          precondition:
            - predicate: q_rs_q04.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter names of absent household members..."

    # =========================================================================
    # BLOCK 7: HOUSEHOLD ROSTER — SUBSEQUENT INTERVIEWS
    # =========================================================================
    # PV2_Q01: Confirm existing household members still live here
    # RES_Q02: If not, determine reason (no longer member vs deceased)
    # RS_Q05: Anyone else now live here?
    # OTH2_Q01: New household members roster
    # =========================================================================
    - id: b_roster_subsequent
      title: "Household Roster (Subsequent Interview)"
      precondition:
        - predicate: interview_type == 3
      items:
        # RS_R01: Roster introduction (subsequent variant)
        - id: q_rs_r01_subseq
          kind: Comment
          title: "The next few questions ask for important basic information about the people in your household."

        # PV2_Q01: Do listed people still live here?
        # Yes → RS_Q05; No → RES_Q02
        - id: q_pv2_q01
          kind: Question
          title: "Do the following people still live or stay in this dwelling?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # RES_Q02: Reason for departure
        # Precondition: PV2_Q01 = No (0)
        # Note: In original CATI, loops back to PV2_Q01 for next person;
        # QML cannot model dynamic loops.
        - id: q_res_q02
          kind: Question
          title: "Is the person no longer a member of the household or deceased?"
          precondition:
            - predicate: q_pv2_q01.outcome == 0
          input:
            control: Radio
            labels:
              1: "No longer a member"
              2: "Deceased"

        # RS_Q05: Anyone else now live here?
        # Yes → OTH2_Q01; No → next section
        - id: q_rs_q05
          kind: Question
          title: "Does anyone else now live or stay here?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # OTH2_Q01: New household members roster
        # Precondition: RS_Q05 = Yes (1)
        - id: q_oth2_q01
          kind: Question
          title: "What are the names of the other people who live or stay here? Add a person only if he/she has no other usual residence elsewhere."
          precondition:
            - predicate: q_rs_q05.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter names of new household members..."

    # ===================================================================
    # SECTION: individual_demographics
    # ===================================================================
    # =========================================================================
    # BLOCK 1: AGE AND DATE OF BIRTH
    # =========================================================================
    # ANC_Q01: Date of birth modeled as age (Editbox 0-120)
    # ANC_Q02: Confirm calculated age (Yes/No)
    # ANC_Q03: Manual age correction (only if ANC_Q02=No)
    #
    # The codeBlock on ANC_Q01 sets respondent_age. If ANC_Q02 says No,
    # ANC_Q03 overrides respondent_age.
    # =========================================================================
    - id: b_age
      title: "Age and Date of Birth"
      items:
        # ANC_Q01: Date of birth (modeled as age in years)
        - id: q_anc_q01
          kind: Question
          title: "What is ...'s date of birth? (Modeled as age in years since QML has no date control.)"
          codeBlock: |
            respondent_age = q_anc_q01.outcome
          input:
            control: Editbox
            min: 0
            max: 120
            left: "Age:"
            right: "years"

        # ANC_Q02: Confirm age
        # Yes -> SEX_Q01 (skip ANC_Q03); No -> ANC_Q03
        - id: q_anc_q02
          kind: Question
          title: "So ...'s age on the reference date was the value entered above. Is that correct?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ANC_Q03: Manual age correction
        # Only asked if ANC_Q02 = No (outcome 0)
        - id: q_anc_q03
          kind: Question
          title: "What is ...'s age?"
          precondition:
            - predicate: q_anc_q02.outcome == 0
          codeBlock: |
            respondent_age = q_anc_q03.outcome
          input:
            control: Editbox
            min: 0
            max: 120
            left: "Age:"
            right: "years"

    # =========================================================================
    # BLOCK 2: SEX
    # =========================================================================
    - id: b_sex
      title: "Sex"
      items:
        # SEX_Q01: Enter sex
        - id: q_sex_q01
          kind: Question
          title: "Enter ...'s sex."
          codeBlock: |
            sex = q_sex_q01.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

    # =========================================================================
    # BLOCK 3: MARITAL STATUS
    # =========================================================================
    # MSNC_Q01: Marital status
    # Filter: age < 16 -> skip to FI_N01 (precondition gates this question)
    # =========================================================================
    - id: b_marital
      title: "Marital Status"
      items:
        # MSNC_Q01: Marital status (only if age >= 16)
        - id: q_msnc_q01
          kind: Question
          title: "What is ...'s marital status? Is he/she:"
          precondition:
            - predicate: respondent_age >= 16
          input:
            control: Dropdown
            labels:
              1: "Married"
              2: "Living common-law"
              3: "Widowed"
              4: "Separated"
              5: "Divorced"
              6: "Single, never married"

    # =========================================================================
    # BLOCK 4: FAMILY AND RELATIONSHIP
    # =========================================================================
    # FI_N01: Family identifier (A-Z, modeled as numeric 1-26)
    # RR_N01: Relationship to reference person (10 options -> Dropdown)
    # =========================================================================
    - id: b_family
      title: "Family and Relationship"
      items:
        # FI_N01: Family identifier
        - id: q_fi_n01
          kind: Question
          title: "Enter ...'s family identifier: A to Z. Assign the same letter to all persons related by blood, marriage or adoption. (A=1, B=2, ... Z=26)"
          input:
            control: Editbox
            min: 1
            max: 26
            left: "Family ID:"

        # RR_N01: Relationship to reference person
        - id: q_rr_n01
          kind: Question
          title: "Determine a reference person for the family and select ...'s relationship to that reference person."
          input:
            control: Dropdown
            labels:
              1: "Reference person"
              2: "Spouse"
              3: "Son or daughter"
              4: "Grandchild"
              5: "Son-in-law or daughter-in-law"
              6: "Foster child (under 18)"
              7: "Parent"
              8: "Parent-in-law"
              9: "Brother or sister"
              10: "Other relative"

    # =========================================================================
    # BLOCK 5: IMMIGRATION
    # =========================================================================
    # IMM_Q01: Country of birth (13 options -> Dropdown)
    #   Canada (1) -> skip to ABO_Q01
    #   Other (2-13) -> IMM_Q02
    # IMM_Q02: Landed immigrant? Yes -> IMM_Q03; No -> ABO_Q01
    # IMM_Q03: Year of immigration
    # IMM_Q04: Month of immigration (only if within 5 years)
    # =========================================================================
    - id: b_immigration
      title: "Immigration"
      items:
        # IMM_Q01: Country of birth
        - id: q_imm_q01
          kind: Question
          title: "In what country was ... born? Specify country of birth according to current boundaries."
          input:
            control: Dropdown
            labels:
              1: "Canada"
              2: "United States"
              3: "United Kingdom"
              4: "Germany"
              5: "Italy"
              6: "Poland"
              7: "Portugal"
              8: "China"
              9: "Hong Kong"
              10: "India"
              11: "Philippines"
              12: "Vietnam"
              13: "Other"

        # IMM_Q02: Landed immigrant?
        # Only if not born in Canada (IMM_Q01 != 1)
        - id: q_imm_q02
          kind: Question
          title: "Is ... now, or has he/she ever been, a landed immigrant in Canada?"
          precondition:
            - predicate: q_imm_q01.outcome != 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # IMM_Q03: Year of immigration
        # Only if landed immigrant (IMM_Q02 = Yes = 1)
        - id: q_imm_q03
          kind: Question
          title: "In what year did ... first become a landed immigrant?"
          precondition:
            - predicate: q_imm_q01.outcome != 1
            - predicate: q_imm_q02.outcome == 1
          codeBlock: |
            if q_imm_q03.outcome >= 2021:
              recent_immigrant = 1
            else:
              recent_immigrant = 0
          input:
            control: Editbox
            min: 1900
            max: 2026
            left: "Year:"

        # IMM_Q04: Month of immigration
        # Only if recent immigrant (within 5 years)
        - id: q_imm_q04
          kind: Question
          title: "In what month did ... become a landed immigrant?"
          precondition:
            - predicate: q_imm_q01.outcome != 1
            - predicate: q_imm_q02.outcome == 1
            - predicate: recent_immigrant == 1
          postcondition:
            - predicate: q_imm_q04.outcome >= 1 and q_imm_q04.outcome <= 12
              hint: "Month must be between 1 and 12."
          input:
            control: Editbox
            min: 1
            max: 12
            left: "Month:"

    # =========================================================================
    # BLOCK 6: ABORIGINAL IDENTITY
    # =========================================================================
    # ABO_Q01: Aboriginal person? (Yes/No)
    #   Filter: If country of birth not Canada (1) or USA (2) -> skip to ED_Q01
    #   Yes -> ABO_Q02; No -> ED_Q01
    # ABO_Q02: North American Indian, Metis, or Inuit (Checkbox, power-of-2)
    # =========================================================================
    - id: b_aboriginal
      title: "Aboriginal Identity"
      items:
        # ABO_Q01: Is person an Aboriginal person?
        # Only asked if born in Canada or USA
        - id: q_abo_q01
          kind: Question
          title: "Is ... an Aboriginal person, that is, North American Indian, Metis or Inuit?"
          precondition:
            - predicate: q_imm_q01.outcome == 1 or q_imm_q01.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ABO_Q02: Aboriginal group (mark all that apply)
        # Only if ABO_Q01 = Yes (1)
        - id: q_abo_q02
          kind: Question
          title: "Is ... a North American Indian, Metis or Inuit? Mark all that apply."
          precondition:
            - predicate: q_imm_q01.outcome == 1 or q_imm_q01.outcome == 2
            - predicate: q_abo_q01.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "North American Indian"
              2: "Metis"
              4: "Inuit"

    # =========================================================================
    # BLOCK 7: EDUCATION
    # =========================================================================
    # ED_Q01: Highest grade of elementary/high school
    #   Filter: age < 14 -> skip to CAF_Q01
    #   1 or 2 -> ED_Q03; 3 -> ED_Q02
    # ED_Q02: High school graduate? (only if Grade 11-13)
    # ED_Q03: Other education? Yes -> ED_Q04; No -> CAF_Q01
    # ED_Q04: Highest degree/certificate/diploma
    # CHE_Q01: Country of highest education
    #   Filter: born in Canada OR not landed immigrant OR no post-secondary
    # =========================================================================
    - id: b_education
      title: "Education"
      precondition:
        - predicate: respondent_age >= 14
      items:
        # ED_Q01: Highest grade of elementary or high school
        - id: q_ed_q01
          kind: Question
          title: "What is the highest grade of elementary or high school ... ever completed?"
          input:
            control: Radio
            labels:
              1: "Grade 8 or lower"
              2: "Grade 9-10"
              3: "Grade 11-13"

        # ED_Q02: Did person graduate from high school?
        # Only if ED_Q01 = 3 (Grade 11-13)
        - id: q_ed_q02
          kind: Question
          title: "Did ... graduate from high school (secondary school)?"
          precondition:
            - predicate: q_ed_q01.outcome == 3
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ED_Q03: Has person received other education?
        # Asked for all ED_Q01 outcomes (after ED_Q02 if applicable)
        - id: q_ed_q03
          kind: Question
          title: "Has ... received any other education that could be counted towards a degree, certificate or diploma from an educational institution?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ED_Q04: Highest degree, certificate or diploma
        # Only if ED_Q03 = Yes (1)
        - id: q_ed_q04
          kind: Question
          title: "What is the highest degree, certificate or diploma ... has obtained?"
          precondition:
            - predicate: q_ed_q03.outcome == 1
          codeBlock: |
            has_postsecondary = 1
          input:
            control: Dropdown
            labels:
              1: "No postsecondary degree, certificate or diploma"
              2: "Trade certificate or diploma"
              3: "Non-university certificate or diploma"
              4: "University certificate below bachelor's"
              5: "Bachelor's degree"
              6: "University degree above bachelor's"

        # CHE_Q01: Country of highest education
        # Only asked if: not born in Canada AND is landed immigrant AND has post-secondary
        - id: q_che_q01
          kind: Question
          title: "In what country did ... complete his/her highest degree, certificate or diploma?"
          precondition:
            - predicate: q_ed_q03.outcome == 1
            - predicate: q_imm_q01.outcome != 1
            - predicate: q_imm_q02.outcome == 1
            - predicate: has_postsecondary == 1
          input:
            control: Dropdown
            labels:
              1: "Canada"
              2: "United States"
              3: "United Kingdom"
              4: "Germany"
              5: "Italy"
              6: "Poland"
              7: "Portugal"
              8: "China"
              9: "Hong Kong"
              10: "India"
              11: "Philippines"
              12: "Vietnam"
              13: "Other"

    # =========================================================================
    # BLOCK 8: CANADIAN ARMED FORCES
    # =========================================================================
    # CAF_Q01: Full-time member of regular Canadian Armed Forces?
    #   Filter: age < 16 or age > 65 -> skip (end demographics)
    #   Yes -> next person (end demographics)
    #   No -> Labour Force section
    # =========================================================================
    - id: b_armed_forces
      title: "Canadian Armed Forces"
      precondition:
        - predicate: respondent_age >= 16
        - predicate: respondent_age <= 65
      items:
        # CAF_Q01: Canadian Armed Forces membership
        - id: q_caf_q01
          kind: Question
          title: "Is ... a full-time member of the regular Canadian Armed Forces?"
          codeBlock: |
            armed_forces = q_caf_q01.outcome
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: rent
    # ===================================================================
    # =========================================================================
    # BLOCK 1: RENT INTRODUCTION
    # =========================================================================
    # RRF_R01: Introduction read to respondent.
    # Block-level precondition: tenure == 1 (dwelling is rented).
    # =========================================================================
    - id: b_rent_intro
      title: "Rent Introduction"
      precondition:
        - predicate: tenure == 1
      items:
        # RRF_R01: Introduction
        - id: q_rrf_r01
          kind: Comment
          title: "The next few questions are about your rent. The information collected is used to calculate the rent portion of the Consumer Price Index."

    # =========================================================================
    # BLOCK 2: DWELLING CHARACTERISTICS
    # =========================================================================
    # RM_Q01: Floor number (apartments only, no previous rent info)
    # RM_Q02: Building age
    # RM_Q03: Number of bedrooms
    #
    # Routing:
    #   RM_Q01: asked only if apartment AND no previous rent info
    #   If has_previous_rent=1 -> skip to RM_Q04
    #   If not apartment -> RM_Q02
    #   RM_Q02 -> RM_Q03 -> RM_Q04
    # =========================================================================
    - id: b_dwelling_chars
      title: "Dwelling Characteristics"
      precondition:
        - predicate: tenure == 1
        - predicate: has_previous_rent == 0
      items:
        # RM_Q01: Floor number (apartments only)
        - id: q_rm_q01
          kind: Question
          title: "On which floor do you live?"
          precondition:
            - predicate: dwelling_type == 5 or dwelling_type == 6
          input:
            control: Editbox
            min: 0
            max: 99

        # RM_Q02: Building age
        - id: q_rm_q02
          kind: Question
          title: "To the best of your knowledge, how old is your building?"
          input:
            control: Radio
            labels:
              1: "No more than 5 years old"
              2: "More than 5 but no more than 10 years"
              3: "More than 10 but no more than 20 years"
              4: "More than 20 but no more than 40 years"
              5: "More than 40 years old"

        # RM_Q03: Number of bedrooms
        - id: q_rm_q03
          kind: Question
          title: "How many bedrooms are there in your dwelling?"
          input:
            control: Editbox
            min: 0
            max: 20

    # =========================================================================
    # BLOCK 3: RENT SUBSIDY AND BUSINESS USE
    # =========================================================================
    # RM_Q04: Is rent subsidized?
    # RM_Q04A: Manner of subsidy (if Yes)
    # RM_Q05: Rent for both living and business?
    # RM_Q05A: Does business affect rent? (if Yes)
    # =========================================================================
    - id: b_subsidy_business
      title: "Rent Subsidy and Business Use"
      precondition:
        - predicate: tenure == 1
      items:
        # RM_Q04: Rent subsidized?
        - id: q_rm_q04
          kind: Question
          title: "This month, is the rent for your dwelling subsidized by government or an employer, or a relative?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q04A: Manner of subsidy
        - id: q_rm_q04a
          kind: Question
          title: "In what manner is the rent for your dwelling subsidized?"
          precondition:
            - predicate: q_rm_q04.outcome == 1
          input:
            control: Radio
            labels:
              1: "Income-related/Government"
              2: "Employer"
              3: "Owned by a relative"
              4: "Other"

        # RM_Q05: Rent for both living and business?
        - id: q_rm_q05
          kind: Question
          title: "This month, is the rent for your dwelling applied to both living and business accommodation?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q05A: Does business affect rent amount?
        - id: q_rm_q05a
          kind: Question
          title: "Does the business affect the amount of rent paid?"
          precondition:
            - predicate: q_rm_q05.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 4: RENT AMOUNT AND CHANGES
    # =========================================================================
    # RM_Q06: Total monthly rent
    # RM_Q07: Reason rent is $0 (if rent=0)
    # RM_Q08: Changes in rent since last month
    # RM_Q08A: Reason for rent change (if Yes)
    #
    # Routing:
    #   RM_Q06: if $0 -> RM_Q07; if >$0 -> RM_Q08
    #   RM_Q07: if subsidized -> end; else -> RM_Q08
    #   RM_Q08: filters skip to RM_Q09B; Yes -> RM_Q08A; No -> RM_Q09B
    #   RM_Q08A -> RM_Q09B
    # =========================================================================
    - id: b_rent_amount
      title: "Rent Amount and Changes"
      precondition:
        - predicate: tenure == 1
      items:
        # RM_Q06: Total monthly rent
        - id: q_rm_q06
          kind: Question
          title: "How much is the total monthly rent for your dwelling?"
          input:
            control: Editbox
            min: 0
            max: 99999

        # RM_Q07: Reason rent is $0
        # Asked only when rent is zero
        - id: q_rm_q07
          kind: Question
          title: "What is the reason that the rent is $0?"
          precondition:
            - predicate: q_rm_q06.outcome == 0
          input:
            control: Textarea
            placeholder: "Explain why rent is $0..."

        # RM_Q08: Changes in rent since last month
        # Filter: skip if no previous info, complete membership change,
        # or rent is subsidized. Also skip if rent is $0 and subsidized
        # (those paths end after RM_Q07).
        # When rent is $0 and not subsidized, fall through to RM_Q08.
        - id: q_rm_q08
          kind: Question
          title: "Since last month, have there been any changes in the amount of rent paid?"
          precondition:
            - predicate: has_previous_rent == 1
            - predicate: membership_change == 0
            - predicate: q_rm_q04.outcome == 0
            - predicate: q_rm_q06.outcome >= 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q08A: Reason for rent change (multi select)
        # Power-of-2 keys: 1=Utilities, 2=Parking, 4=New Lease, 8=Other
        - id: q_rm_q08a
          kind: Question
          title: "What is the reason for the change in rent since last month? Mark all that apply."
          precondition:
            - predicate: q_rm_q08.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Change in utilities/services/appliances/furnishings"
              2: "Change in parking facilities"
              4: "New lease"
              8: "Other"

    # =========================================================================
    # BLOCK 5: PARKING FACILITIES
    # =========================================================================
    # RM_Q09B: Does rent include parking?
    # RM_Q09S: Changes in parking since last month?
    # RM_Q10: Types of parking included
    # RM_Q11-Q13: Number of parking spaces by type
    #
    # Routing:
    #   RM_Q09B: non-apartment -> RM_Q14; has previous & no membership
    #     change -> RM_Q09S; Yes -> RM_Q10; No -> RM_Q14
    #   RM_Q09S: Yes -> RM_Q10; No -> RM_Q14
    #   RM_Q10 -> RM_Q11 (if indoor) -> RM_Q12 (if plug-in) -> RM_Q13
    #     (if no plug-in) -> RM_Q14
    # =========================================================================
    - id: b_parking
      title: "Parking Facilities"
      precondition:
        - predicate: tenure == 1
        - predicate: dwelling_type == 5 or dwelling_type == 6
      items:
        # RM_Q09B: Does rent include parking?
        # Asked of apartments. If $0 rent and subsidized, the survey
        # ends before reaching here (modeled via block precondition
        # and the flow from block 4).
        - id: q_rm_q09b
          kind: Question
          title: "Does this month's rent include parking facilities?"
          precondition:
            - predicate: "has_previous_rent == 0 or membership_change == 1"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q09S: Changes in parking since last month?
        # Asked when there is previous rent info and no membership change
        - id: q_rm_q09s
          kind: Question
          title: "Since last month, have there been any changes in the parking facilities?"
          precondition:
            - predicate: has_previous_rent == 1
            - predicate: membership_change == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q10: Types of parking included in rent
        # Asked when: RM_Q09B=Yes OR RM_Q09S=Yes
        # Power-of-2 keys: 1=Indoor, 2=Outside w/ plug-in, 4=Outside w/o plug-in
        - id: q_rm_q10
          kind: Question
          title: "What types of parking facilities are included in your rent? Mark all that apply."
          precondition:
            - predicate: q_rm_q09b.outcome == 1 or q_rm_q09s.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Closed garage or indoor parking"
              2: "Outside parking with plug-in"
              4: "Outside parking without plug-in"

        # RM_Q11: Indoor parking spaces
        # Bit 0 set = indoor parking selected (outcome % 2 >= 1)
        - id: q_rm_q11
          kind: Question
          title: "How many closed garage or indoor parking spaces are included in your rent?"
          precondition:
            - predicate: q_rm_q10.outcome % 2 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # RM_Q12: Outside parking with plug-in spaces
        # Bit 1 set = outside plug-in selected (outcome % 4 >= 2)
        - id: q_rm_q12
          kind: Question
          title: "How many outside parking spaces with plug-in are included in your rent?"
          precondition:
            - predicate: q_rm_q10.outcome % 4 >= 2
          input:
            control: Editbox
            min: 1
            max: 10

        # RM_Q13: Outside parking without plug-in spaces
        # Bit 2 set = outside no plug-in selected (outcome % 8 >= 4)
        - id: q_rm_q13
          kind: Question
          title: "How many outside parking spaces without plug-in are included in your rent?"
          precondition:
            - predicate: q_rm_q10.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1
            max: 10

    # =========================================================================
    # BLOCK 6: UTILITIES AND FURNISHINGS
    # =========================================================================
    # RM_Q14: Changes in utilities/furnishings since last month
    # RM_Q15: Which utilities/services included in rent
    #
    # Routing:
    #   RM_Q14: if no previous info -> RM_Q15; if membership change ->
    #     RM_Q15; if RM_Q08A includes utilities -> RM_Q15; Yes -> RM_Q15;
    #     No -> end
    #   RM_Q15 -> end of Rent Component
    # =========================================================================
    - id: b_utilities
      title: "Utilities and Furnishings"
      precondition:
        - predicate: tenure == 1
      items:
        # RM_Q14: Changes in utilities/furnishings since last month
        # Filter: always goes to RM_Q15 if no previous info, membership
        # change, or RM_Q08A includes utilities (bit 0). Only asked when
        # there is previous info, no membership change, and no utility
        # change already reported.
        # When No -> end of component (RM_Q15 is skipped).
        - id: q_rm_q14
          kind: Question
          title: "Since last month, have there been any changes in the utilities, services, appliances, or furnishings included in the rent?"
          precondition:
            - predicate: has_previous_rent == 1
            - predicate: membership_change == 0
            - predicate: q_rm_q08a.outcome % 2 == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q15: Utilities/services/furnishings included in rent
        # Asked when: RM_Q14=Yes, or RM_Q14 was skipped (no previous
        # info, membership change, or RM_Q08A includes utilities).
        # Power-of-2 keys for 12 options.
        - id: q_rm_q15
          kind: Question
          title: "Which of the following utilities, services, appliances, or furnishings are included as part of the monthly rent? Read list to respondent. Mark all that apply."
          precondition:
            - predicate: "q_rm_q14.outcome == 1 or has_previous_rent == 0 or membership_change == 1 or q_rm_q08a.outcome % 2 >= 1"
          input:
            control: Checkbox
            labels:
              1: "Heat - Electric"
              2: "Heat - Natural Gas"
              4: "Heat - Other"
              8: "Electricity"
              16: "Cablevision"
              32: "Refrigerator"
              64: "Range"
              128: "Washer"
              256: "Dryer"
              512: "Other major appliance"
              1024: "Furniture"
              2048: "None of the above"

    # ===================================================================
    # SECTION: labour_force
    # ===================================================================
    # =========================================================================
    # BLOCK 1: JOB ATTACHMENT
    # =========================================================================
    # Q100: Worked last week? Sets PATH=1 (yes) or PATH=7 (permanently unable)
    # Q101: Had a job but absent? (only if Q100=No)
    # Q102: More than one job? (if worked or had job)
    # Q103: Changing employers? (if Q102=Yes)
    # Q104: Ever worked? (if Q100=No and Q101=No)
    # Q105: When last worked? (if Q104=Yes) — routing depends on recency
    # =========================================================================
    - id: b_job_attachment
      title: "Job Attachment"
      items:
        # Q100: Last week, did person work at a job or business?
        - id: q_100
          kind: Question
          title: "Last week, did ... work at a job or business? (Regardless of the number of hours.)"
          codeBlock: |
            if q_100.outcome == 1:
              path = 1
            if q_100.outcome == 3:
              path = 7
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Permanently unable to work"

        # Q101: Had a job from which absent?
        # Only if Q100=No (outcome 2)
        - id: q_101
          kind: Question
          title: "Last week, did ... have a job or business from which he/she was absent?"
          precondition:
            - predicate: q_100.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q102: More than one job last week?
        # Reached if Q100=Yes or Q101=Yes
        - id: q_102
          kind: Question
          title: "Did he/she have more than one job or business last week?"
          precondition:
            - predicate: q_100.outcome == 1 or q_101.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q103: Was this a result of changing employers?
        # Only if Q102=Yes
        - id: q_103
          kind: Question
          title: "Was this a result of changing employers?"
          precondition:
            - predicate: q_100.outcome == 1 or q_101.outcome == 1
            - predicate: q_102.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q104: Has ever worked?
        # Only if Q100=No and Q101=No
        - id: q_104
          kind: Question
          title: "Has he/she ever worked at a job or business?"
          precondition:
            - predicate: q_100.outcome == 2
            - predicate: q_101.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q105: When did last work?
        # Only if Q104=Yes. Modeled as months since last worked (0-600).
        # Routing: if within past year (<=12) and not permanently unable -> job description;
        #   if permanently unable (q_100.outcome==3) -> absence/separation;
        #   if not recent -> job search.
        - id: q_105
          kind: Question
          title: "When did he/she last work? (Enter months since last employment, 0-600.)"
          precondition:
            - predicate: q_100.outcome == 2
            - predicate: q_101.outcome == 0
            - predicate: q_104.outcome == 1
          codeBlock: |
            if q_105.outcome <= 12:
              last_work_recent = 1
            else:
              last_work_recent = 0
          input:
            control: Editbox
            min: 0
            max: 600
            left: "Months:"

    # =========================================================================
    # BLOCK 2: JOB DESCRIPTION
    # =========================================================================
    # Q110-Q118: Employer type, business details, job description, start date.
    # Reached from: Q100=Yes (PATH=1), Q101=Yes, or Q105 recent and not PATH=7.
    # =========================================================================
    - id: b_job_description
      title: "Job Description"
      precondition:
        - predicate: "q_100.outcome == 1 or q_101.outcome == 1 or (q_104.outcome == 1 and last_work_recent == 1 and q_100.outcome != 3)"
      items:
        # Q110: Employee or self-employed?
        - id: q_110
          kind: Question
          title: "Was he/she an employee or self-employed?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Working in a family business without pay"

        # Q111: Incorporated business? (only if self-employed)
        - id: q_111
          kind: Question
          title: "Did he/she have an incorporated business?"
          precondition:
            - predicate: q_110.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q112: Any employees? (only if self-employed)
        - id: q_112
          kind: Question
          title: "Did he/she have any employees?"
          precondition:
            - predicate: q_110.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q113: Name of business (only if self-employed)
        - id: q_113
          kind: Question
          title: "What was the name of his/her business?"
          precondition:
            - predicate: q_110.outcome == 2
          input:
            control: Textarea
            placeholder: "Enter business name"

        # Q114: For whom did person work? (if employee or unpaid family)
        - id: q_114
          kind: Question
          title: "For whom did he/she work? (Enter employer name.)"
          precondition:
            - predicate: q_110.outcome != 2
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # Q115: What kind of business/industry?
        - id: q_115
          kind: Question
          title: "What kind of business, industry or service was this?"
          input:
            control: Textarea
            placeholder: "Describe the business or industry"

        # Q116: What kind of work?
        - id: q_116
          kind: Question
          title: "What kind of work was he/she doing?"
          input:
            control: Textarea
            placeholder: "Describe the kind of work"

        # Q117: Most important activities or duties?
        - id: q_117
          kind: Question
          title: "What were his/her most important activities or duties?"
          input:
            control: Textarea
            placeholder: "Describe main duties"

        # Q118: When did person start working for this employer?
        # Modeled as months employed (0-600)
        - id: q_118
          kind: Question
          title: "When did he/she start working for this employer? (Enter months employed, 0-600.)"
          input:
            control: Editbox
            min: 0
            max: 600
            left: "Months:"

    # =========================================================================
    # BLOCK 3: ABSENCE — SEPARATION
    # =========================================================================
    # Q130: Main reason absent (employed but absent). Sets path=2 for non-layoff.
    # Q131: Main reason stopped working (PATH=7, recent work, from Q105)
    # Q132: More specific reason for job loss (Q131=7)
    # Q133: Expect to return? (Q132=6, not PATH=7 — actually NEVER reachable
    #        from Q131 path since Q131 requires PATH=7; included for completeness)
    # Q134: Employer given date to return? (Q130=8 temp layoff)
    # Q135: Indication of recall? (Q134=No)
    # Q136: Weeks on layoff (Q130=9 seasonal, or Q134/Q135 chain)
    #        Sets is_temp_layoff=1 when recall expected within 52 weeks.
    # Q137: Usually work >=30 or <30 hours?
    # =========================================================================
    - id: b_absence
      title: "Absence and Separation"
      items:
        # Q130: Main reason absent from work last week
        # Shown when: Q101=Yes (had job but absent, Q100=2)
        # PATH=1 workers skip directly to work hours block.
        - id: q_130
          kind: Question
          title: "What was the main reason ... was absent from work last week?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
          codeBlock: |
            if q_130.outcome not in [8, 9, 10]:
              path = 2
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Maternity or parental leave"
              5: "Other personal or family responsibilities"
              6: "Vacation"
              7: "Labour dispute"
              8: "Temporary layoff due to business conditions"
              9: "Seasonal layoff"
              10: "Casual job, no work available"
              11: "Work schedule"
              12: "Self-employed, no work available"
              13: "Seasonal business"
              14: "Other"

        # Q131: Main reason stopped working
        # Reached from Q105 path: ever worked, recent, permanently unable (Q100=3).
        - id: q_131
          kind: Question
          title: "What was the main reason ... stopped working at that job or business?"
          precondition:
            - predicate: q_100.outcome == 3
            - predicate: q_104.outcome == 1
            - predicate: last_work_recent == 1
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Pregnancy"
              5: "Other personal or family responsibilities"
              6: "Going to school"
              7: "Lost job, laid off or job ended"
              8: "Business sold or closed down"
              9: "Changed residence"
              10: "Dissatisfied with job"
              11: "Retired"
              12: "Other"

        # Q132: More specific reason for job loss
        # Only if Q131=7 (lost job)
        - id: q_132
          kind: Question
          title: "Can you be more specific about the main reason for his/her job loss?"
          precondition:
            - predicate: q_100.outcome == 3
            - predicate: q_104.outcome == 1
            - predicate: last_work_recent == 1
            - predicate: q_131.outcome == 7
          input:
            control: Dropdown
            labels:
              1: "End of seasonal job"
              2: "End of temporary/term/contract job"
              3: "Casual job"
              4: "Company moved"
              5: "Company went out of business"
              6: "Business conditions"
              7: "Dismissal by employer"
              8: "Other"

        # Q133: Expect to return to job?
        # Per inventory: Q132=6 (business conditions) and PATH!=7 -> Q133.
        # But Q131/Q132 path requires Q100=3 (PATH=7), so Q133 is structurally
        # unreachable from the Q131 chain. It would only be reachable if there
        # were a non-PATH=7 route to Q132, which doesn't exist.
        # Included for completeness; Z3 will classify as NEVER reachable.
        - id: q_133
          kind: Question
          title: "Does he/she expect to return to that job?"
          precondition:
            - predicate: q_131.outcome == 7
            - predicate: q_132.outcome == 6
            - predicate: q_100.outcome != 3
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not sure"

        # Q134: Employer given date to return?
        # Reached from Q130=8 (temporary layoff due to business conditions)
        - id: q_134
          kind: Question
          title: "Has ...'s employer given him/her a date to return?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
            - predicate: q_130.outcome == 8
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q135: Any indication of recall within 6 months?
        # Only if Q134=No
        - id: q_135
          kind: Question
          title: "Has he/she been given any indication that he/she will be recalled within the next 6 months?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
            - predicate: q_130.outcome == 8
            - predicate: q_134.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q136: How many weeks on layoff?
        # Reached from: Q130=9 (seasonal), Q134=Yes, or Q135 (either answer)
        # After: sets is_temp_layoff=1 and path=3 when conditions met
        - id: q_136
          kind: Question
          title: "As of last week, how many weeks had ... been on layoff?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
            - predicate: q_130.outcome == 8 or q_130.outcome == 9
          codeBlock: |
            if q_130.outcome != 9:
              if q_134.outcome == 1:
                if q_136.outcome <= 52:
                  is_temp_layoff = 1
                  path = 3
              elif q_135.outcome == 1:
                if q_136.outcome <= 52:
                  is_temp_layoff = 1
                  path = 3
          input:
            control: Editbox
            min: 0
            max: 520
            left: "Weeks:"

        # Q137: Usually work more or less than 30 hours?
        # Reached from various absence/separation paths:
        # - Q130=10 (casual, no work)
        # - Q131 chain (all Q131 outcomes except Q131=7 which goes to Q132 first,
        #   then Q132 leads back to Q137 for most outcomes)
        # - Q136 chain (after layoff weeks question)
        # If is_temp_layoff=1 -> Q190 (availability); otherwise -> Q170 (job search)
        - id: q_137
          kind: Question
          title: "Did he/she usually work more or less than 30 hours per week?"
          precondition:
            - predicate: "(q_100.outcome == 2 and q_101.outcome == 1 and q_130.outcome in [8, 9, 10]) or (q_100.outcome == 3 and q_104.outcome == 1 and last_work_recent == 1)"
          input:
            control: Radio
            labels:
              1: "30 or more hours per week"
              2: "Less than 30 hours per week"

    # =========================================================================
    # BLOCK 4: WORK HOURS — MAIN JOB
    # =========================================================================
    # Q150-Q163: Hours worked, overtime, absence from job, part-time reasons.
    # Reached when: Q100=1 (at work, PATH=1) or
    #   Q130 answered with non-layoff reason (PATH=2, i.e., q_130 not in [8,9,10])
    # =========================================================================
    - id: b_work_hours
      title: "Work Hours - Main Job"
      precondition:
        - predicate: "q_100.outcome == 1 or (q_100.outcome == 2 and q_101.outcome == 1 and q_130.outcome not in [8, 9, 10])"
      items:
        # Q150: Does the number of paid hours vary week to week?
        - id: q_150
          kind: Question
          title: "Does the number of paid hours ... works vary from week to week? (Excluding overtime for employees.)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q151: How many paid hours per week? (if hours don't vary)
        - id: q_151
          kind: Question
          title: "Excluding overtime, how many paid hours does ... work per week?"
          precondition:
            - predicate: q_150.outcome == 0
          codeBlock: |
            usual_hours = q_151.outcome
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q152: Average paid hours per week? (if hours vary)
        - id: q_152
          kind: Question
          title: "Excluding overtime, on average, how many paid hours does ... usually work per week?"
          precondition:
            - predicate: q_150.outcome == 1
          codeBlock: |
            usual_hours = q_152.outcome
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q153: Hours away from job last week
        # Only for employees (Q110=1) and PATH=1 (at work)
        # PATH=2 means absent, skip employee absence details to Q158
        - id: q_153
          kind: Question
          title: "Last week, how many hours was he/she away from this job because of vacation, illness, or any other reason?"
          precondition:
            - predicate: q_110.outcome == 1
            - predicate: q_100.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q154: Main reason for absence
        # Only if Q153 > 0
        - id: q_154
          kind: Question
          title: "What was the main reason for that absence?"
          precondition:
            - predicate: q_110.outcome == 1
            - predicate: q_100.outcome == 1
            - predicate: q_153.outcome > 0
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Maternity or parental leave"
              5: "Other personal or family responsibilities"
              6: "Vacation"
              7: "Labour dispute"
              8: "Temporary layoff due to business conditions"
              9: "Holiday"
              10: "Weather"
              11: "Job started or ended during week"
              12: "Working short-time"
              13: "Other"

        # Q155: Paid overtime hours last week
        # Only for employees and PATH=1
        - id: q_155
          kind: Question
          title: "Last week, how many hours of paid overtime did he/she work at this job?"
          precondition:
            - predicate: q_110.outcome == 1
            - predicate: q_100.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q156: Extra unpaid hours last week
        # Only for employees and PATH=1
        # Computes actual_hours when Q150=No (fixed hours)
        - id: q_156
          kind: Question
          title: "Last week, how many extra hours without pay did he/she work at this job?"
          precondition:
            - predicate: q_110.outcome == 1
            - predicate: q_100.outcome == 1
          codeBlock: |
            if q_150.outcome == 0:
              actual_hours = q_151.outcome - q_153.outcome + q_155.outcome + q_156.outcome
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q157: Actual hours worked last week
        # Shown when: Q150=Yes (hours vary) or not employee (self-employed/family)
        # Not shown when PATH=2 (absent, those skip to Q158)
        - id: q_157
          kind: Question
          title: "Last week, how many hours did he/she actually work at this job or business?"
          precondition:
            - predicate: q_100.outcome == 1
            - predicate: q_150.outcome == 1 or q_110.outcome != 1
          codeBlock: |
            actual_hours = q_157.outcome
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q158: Want to work >=30 hours?
        # Filter: if usual_hours >= 30 and PATH=2 -> Q162 (weeks absent)
        # Filter: if usual_hours >= 30 and PATH=1 -> Q200 (earnings)
        # Only shown when usual_hours < 30
        - id: q_158
          kind: Question
          title: "Does he/she want to work 30 or more hours per week at a single job?"
          precondition:
            - predicate: usual_hours < 30
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q159: Reason not wanting >=30 hours
        # Only if Q158=No
        - id: q_159
          kind: Question
          title: "What is the main reason ... does not want to work 30 or more hours per week?"
          precondition:
            - predicate: usual_hours < 30
            - predicate: q_158.outcome == 0
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Personal preference"
              7: "Other"

        # Q160: Reason working <30 hours
        # Only if Q158=Yes (wants >=30 but works <30)
        - id: q_160
          kind: Question
          title: "What is the main reason ... usually works less than 30 hours per week at his/her main job?"
          precondition:
            - predicate: usual_hours < 30
            - predicate: q_158.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Business conditions"
              7: "Could not find work with 30 or more hours"
              8: "Other"

        # Q161: Looked for full-time work?
        # Only if Q160=6 or Q160=7 (involuntary part-time)
        - id: q_161
          kind: Question
          title: "At any time in the 4 weeks ending last Saturday, did he/she look for full-time work?"
          precondition:
            - predicate: usual_hours < 30
            - predicate: q_158.outcome == 1
            - predicate: q_160.outcome == 6 or q_160.outcome == 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q162: Weeks continuously absent from work
        # Only if PATH=2 (employed, absent = Q101=Yes and Q130 non-layoff)
        - id: q_162
          kind: Question
          title: "As of last week, how many weeks had ... been continuously absent from work?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 520
            left: "Weeks:"

        # Q163: Getting wages for time off?
        # Only if PATH=2 and (employee or incorporated self-employed)
        - id: q_163
          kind: Question
          title: "Is he/she getting any wages or salary from his/her employer or business for any time off last week?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
            - predicate: q_110.outcome == 1 or (q_110.outcome == 2 and q_111.outcome == 1)
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 5: JOB SEARCH — FUTURE START
    # =========================================================================
    # Reached when person has no current job:
    # - Q104=No (never worked) -> Q170
    # - Q137 answered and not temp layoff -> Q170
    # - Q105 not recent (last_work_recent=0) -> Q170
    # - Q100=3 and Q104=No -> Q170 (but Q100=3 PATH=7 filter skips to Q500)
    #
    # Q170: Did anything to find work?
    # Q171-Q173: Job search details
    # Q174-Q175: Future job start
    # Q176-Q178: Want a job, reason not looking
    # =========================================================================
    - id: b_job_search
      title: "Job Search and Future Start"
      items:
        # Q170: Did anything to find work in past 4 weeks?
        # Filter: if PATH=7 (q_100.outcome==3) -> skip to Q500
        # Reached from: Q104=No (never worked), Q137 (not temp layoff),
        #   Q105 (not recent work)
        - id: q_170
          kind: Question
          title: "In the 4 weeks ending last Saturday, did ... do anything to find work?"
          precondition:
            - predicate: q_100.outcome != 3
            - predicate: "(q_100.outcome == 2 and q_101.outcome == 0 and q_104.outcome == 0) or (q_100.outcome == 2 and q_101.outcome == 0 and q_104.outcome == 1 and last_work_recent == 0) or (q_137.outcome in [1, 2] and is_temp_layoff == 0)"
          codeBlock: |
            if q_170.outcome == 1:
              path = 4
              search_status = 1
            if q_170.outcome == 0 and respondent_age >= 65:
              path = 6
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q171: What did to find work? (multi-select, power-of-2 keys)
        # Only if Q170=Yes (seeking work)
        - id: q_171
          kind: Question
          title: "What did he/she do to find work in those 4 weeks? (Mark all that apply.)"
          precondition:
            - predicate: q_170.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Public employment agency"
              2: "Private employment agency"
              4: "Union"
              8: "Employers directly"
              16: "Friends or relatives"
              32: "Placed or answered ads"
              64: "Looked at job ads"
              128: "Other"

        # Q172: Weeks looking for work
        # Only if Q170=Yes
        - id: q_172
          kind: Question
          title: "As of last week, how many weeks had he/she been looking for work?"
          precondition:
            - predicate: q_170.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 520
            left: "Weeks:"

        # Q173: Main activity before looking for work
        # Only if Q170=Yes
        - id: q_173
          kind: Question
          title: "What was his/her main activity before he/she started looking for work?"
          precondition:
            - predicate: q_170.outcome == 1
          input:
            control: Radio
            labels:
              1: "Working"
              2: "Managing a home"
              3: "Going to school"
              4: "Other"

        # Q174: Have a future job to start?
        # Only if Q170=No and age < 65
        - id: q_174
          kind: Question
          title: "Last week, did ... have a job to start at a definite date in the future?"
          precondition:
            - predicate: q_170.outcome == 0
            - predicate: respondent_age < 65
          codeBlock: |
            if q_174.outcome == 0:
              path = 6
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q175: Start before or after 4-week date?
        # Only if Q174=Yes
        - id: q_175
          kind: Question
          title: "Will he/she start that job before or after 4 weeks from now?"
          precondition:
            - predicate: q_170.outcome == 0
            - predicate: respondent_age < 65
            - predicate: q_174.outcome == 1
          codeBlock: |
            if q_175.outcome == 1:
              path = 5
              search_status = 2
            else:
              path = 6
          input:
            control: Radio
            labels:
              1: "Before (within 4 weeks)"
              2: "On or after (more than 4 weeks)"

        # Q176: Want a job last week?
        # Only if Q174=No (no future job, PATH=6)
        - id: q_176
          kind: Question
          title: "Did he/she want a job last week?"
          precondition:
            - predicate: q_170.outcome == 0
            - predicate: respondent_age < 65
            - predicate: q_174.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q177: Want >=30 or <30 hours?
        # Reached from: Q173 (job seekers) or Q176=Yes (want a job)
        - id: q_177
          kind: Question
          title: "Did he/she want a job with 30 or more hours per week, or less than 30 hours?"
          precondition:
            - predicate: q_170.outcome == 1 or (q_174.outcome == 0 and q_176.outcome == 1)
          input:
            control: Radio
            labels:
              1: "30 or more hours per week"
              2: "Less than 30 hours per week"

        # Q178: Reason not looking for work
        # Reached from Q177 when not a job seeker (i.e., Q176=Yes path only)
        # Filter: if PATH=4 (Q170=Yes, job seeker) -> Q190 directly
        - id: q_178
          kind: Question
          title: "What was the main reason he/she did not look for work last week?"
          precondition:
            - predicate: q_170.outcome == 0
            - predicate: q_174.outcome == 0 and q_176.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Waiting for recall"
              7: "Waiting for replies from employers"
              8: "Believes no work available"
              9: "No reason given"
              10: "Other"

    # =========================================================================
    # BLOCK 6: AVAILABILITY
    # =========================================================================
    # Q190: Could have worked last week?
    # Q191: Reason not available
    #
    # Reached from: is_temp_layoff=1 (PATH=3 via Q137),
    #   search_status=1 (PATH=4, job seeker via Q170=Yes),
    #   search_status=2 (PATH=5, future start via Q175=1),
    #   Q178=8 (believes no work available, discouraged worker)
    # =========================================================================
    - id: b_availability
      title: "Availability"
      precondition:
        - predicate: "is_temp_layoff == 1 or search_status in [1, 2] or q_178.outcome == 8"
      items:
        # Q190: Could have worked last week?
        - id: q_190
          kind: Question
          title: "Could he/she have worked last week if recalled or if a suitable job had been offered?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q191: Reason not available
        # Only if Q190=No
        - id: q_191
          kind: Question
          title: "What was the main reason ... was not available to work last week?"
          precondition:
            - predicate: q_190.outcome == 0
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Vacation"
              7: "Already has a job"
              8: "Other"

    # =========================================================================
    # BLOCK 7: EARNINGS — UNION — PERMANENCE
    # =========================================================================
    # Q200-Q262: Only for employees (Q110=1) on the employed path.
    # Reached from work hours block (PATH=1 or PATH=2).
    # =========================================================================
    - id: b_earnings
      title: "Earnings, Union, and Permanence"
      precondition:
        - predicate: "q_100.outcome == 1 or (q_100.outcome == 2 and q_101.outcome == 1 and q_130.outcome not in [8, 9, 10])"
        - predicate: q_110.outcome == 1
      items:
        # Q200: Paid by the hour?
        - id: q_200
          kind: Question
          title: "Is he/she paid by the hour?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q201: Receive tips or commissions?
        - id: q_201
          kind: Question
          title: "Does he/she usually receive tips or commissions?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q202: Hourly rate of pay
        # Only if Q200=Yes (paid by hour)
        - id: q_202
          kind: Question
          title: "Including tips and commissions, what is his/her hourly rate of pay?"
          precondition:
            - predicate: q_200.outcome == 1
          postcondition:
            - predicate: q_202.outcome >= 1
              hint: "Hourly rate must be at least $1."
          input:
            control: Editbox
            min: 0
            max: 999
            left: "$"
            right: "per hour"

        # Q204: Easiest way to report wage
        # Only if Q200=No (not paid by hour)
        - id: q_204
          kind: Question
          title: "What is the easiest way for you to tell us his/her wage or salary, including tips and commissions, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
          input:
            control: Dropdown
            labels:
              1: "Yearly"
              2: "Monthly"
              3: "Semi-monthly"
              4: "Bi-weekly"
              5: "Weekly"
              6: "Other"

        # Q205: Weekly wage
        # Only if Q204=5 (weekly) or Q204=6 (other)
        - id: q_205
          kind: Question
          title: "Including tips and commissions, what is his/her weekly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 5 or q_204.outcome == 6
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "per week"

        # Q206: Bi-weekly wage
        # Only if Q204=4
        - id: q_206
          kind: Question
          title: "Including tips and commissions, what is his/her bi-weekly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 4
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "bi-weekly"

        # Q207: Semi-monthly wage
        # Only if Q204=3
        - id: q_207
          kind: Question
          title: "Including tips and commissions, what is his/her semi-monthly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 3
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "semi-monthly"

        # Q208: Monthly wage
        # Only if Q204=2
        - id: q_208
          kind: Question
          title: "Including tips and commissions, what is his/her monthly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "per month"

        # Q209: Yearly wage
        # Only if Q204=1
        - id: q_209
          kind: Question
          title: "Including tips and commissions, what is his/her yearly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"
            right: "per year"

        # Q220: Union member?
        - id: q_220
          kind: Question
          title: "Is he/she a union member at this employer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q221: Covered by union contract?
        # Only if Q220=No (not a member)
        - id: q_221
          kind: Question
          title: "Is he/she covered by a union contract or collective agreement?"
          precondition:
            - predicate: q_220.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q240: Is job permanent?
        - id: q_240
          kind: Question
          title: "Is ...'s job at this employer permanent, or is there some way that it is not permanent?"
          input:
            control: Radio
            labels:
              1: "Permanent"
              2: "Not permanent"

        # Q241: How not permanent?
        # Only if Q240=2
        - id: q_241
          kind: Question
          title: "In what way is his/her job not permanent?"
          precondition:
            - predicate: q_240.outcome == 2
          input:
            control: Radio
            labels:
              1: "Seasonal job"
              2: "Temporary/term/contract job"
              3: "Casual job"
              5: "Other"

        # Q260: Persons at work location
        - id: q_260
          kind: Question
          title: "About how many persons are employed at the location where ... works? Would it be:"
          input:
            control: Radio
            labels:
              1: "Less than 20"
              2: "20 to 99"
              3: "100 to 500"
              4: "Over 500"

        # Q261: Employer has multiple locations?
        - id: q_261
          kind: Question
          title: "Does this employer operate at more than one location?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q262: Persons at all locations
        # Only if Q261=Yes and Q260 != 4 (not already >500)
        - id: q_262
          kind: Question
          title: "In total, about how many persons are employed at all locations?"
          precondition:
            - predicate: q_261.outcome == 1
            - predicate: q_260.outcome != 4
          input:
            control: Radio
            labels:
              1: "Less than 20"
              2: "20 to 99"
              3: "100 to 500"
              4: "Over 500"

    # =========================================================================
    # BLOCK 8: CLASS OF WORKER — OTHER JOB
    # =========================================================================
    # Q300-Q321: Details about other/second job.
    # Filter: Q102=No (only one job) -> skip to Q400/Q500
    # =========================================================================
    - id: b_other_job
      title: "Class of Worker - Other Job"
      precondition:
        - predicate: "q_100.outcome == 1 or (q_100.outcome == 2 and q_101.outcome == 1 and q_130.outcome not in [8, 9, 10])"
        - predicate: q_102.outcome == 1
      items:
        # Q300: Employee or self-employed (other job)?
        - id: q_300
          kind: Question
          title: "At his/her other job, was he/she an employee or self-employed?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Working in a family business without pay"

        # Q301: Incorporated business (other)?
        # Only if Q300=2 (self-employed)
        - id: q_301
          kind: Question
          title: "Did he/she have an incorporated business at the other job?"
          precondition:
            - predicate: q_300.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q302: Any employees (other)?
        # Only if Q300=2 (self-employed)
        - id: q_302
          kind: Question
          title: "Did he/she have any employees at the other job?"
          precondition:
            - predicate: q_300.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q320: Usual hours at other job
        - id: q_320
          kind: Question
          title: "Excluding overtime, how many paid hours does ... usually work per week at this other job?"
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q321: Actual hours at other job last week
        # Not asked if PATH=2 (absent from work: Q100=2 and Q101=1)
        - id: q_321
          kind: Question
          title: "Last week, how many hours did ... actually work at this other job or business?"
          precondition:
            - predicate: q_100.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

    # =========================================================================
    # BLOCK 9: TEMPORARY LAYOFF JOB SEARCH
    # =========================================================================
    # Q400: Did person look for a job with a different employer?
    # Filter: Only if is_temp_layoff=1 (PATH=3 equivalent)
    # =========================================================================
    - id: b_layoff_search
      title: "Temporary Layoff Job Search"
      precondition:
        - predicate: is_temp_layoff == 1
      items:
        # Q400: Look for different employer job?
        - id: q_400
          kind: Question
          title: "In the 4 weeks ending last Saturday, did ... look for a job with a different employer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 10: SCHOOL ATTENDANCE
    # =========================================================================
    # Q500-Q521: School attendance and student status.
    # Filter: age >= 65 -> END (block precondition)
    # =========================================================================
    - id: b_school
      title: "School Attendance"
      precondition:
        - predicate: respondent_age < 65
      items:
        # Q500: Attending school, college, or university?
        - id: q_500
          kind: Question
          title: "Last week, was ... attending a school, college or university?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q501: Full-time or part-time?
        # Only if Q500=Yes
        - id: q_501
          kind: Question
          title: "Was he/she enrolled as a full-time or part-time student?"
          precondition:
            - predicate: q_500.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        # Q502: What kind of school?
        # Only if Q500=Yes
        - id: q_502
          kind: Question
          title: "What kind of school was this?"
          precondition:
            - predicate: q_500.outcome == 1
          input:
            control: Radio
            labels:
              1: "Elementary/junior high/high school"
              2: "Community college/CEGEP"
              3: "University"
              4: "Other"

        # Q520: Full-time student in March?
        # Filter: Only during May-August and age 15-24
        # Modeled with age constraint only (survey month is runtime metadata)
        - id: q_520
          kind: Question
          title: "Was ... a full-time student in March of this year? (Asked during May-August for ages 15-24 only.)"
          precondition:
            - predicate: respondent_age >= 15
            - predicate: respondent_age <= 24
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q521: Expect full-time student this fall?
        # Only if Q520=Yes
        - id: q_521
          kind: Question
          title: "Does ... expect to be a full-time student this fall?"
          precondition:
            - predicate: respondent_age >= 15
            - predicate: respondent_age <= 24
            - predicate: q_520.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not sure"

    # ===================================================================
    # SECTION: exit
    # ===================================================================
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
