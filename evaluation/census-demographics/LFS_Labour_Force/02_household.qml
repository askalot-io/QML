qmlVersion: "1.0"
questionnaire:
  title: "LFS Labour Force Survey - Household Component"
  codeInit: |
    # Extern variable from Contact section
    # 1=birth in person, 2=birth CATI, 3=subsequent telephone
    interview_type: {1, 2, 3}

    # Variables PRODUCED by this section (read by later sections)
    dwelling_type = 0   # 1-10 dwelling classification (from DW_Q01/DW_N02)
    tenure = 0          # 0=owned, 1=not owned (from TN_Q01)

    # Internal: tracks whether addresses match for SD_Q01 routing
    # In the original CATI, the system compares listing vs mailing address;
    # modeled as a binary flag the interviewer sets.
    addresses_match = 1  # 1=match, 0=differ

  blocks:
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
