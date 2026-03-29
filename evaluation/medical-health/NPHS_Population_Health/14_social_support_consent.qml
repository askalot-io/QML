qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Social Support, Health Number, and Agreement to Share"
  codeInit: |
    # No cross-section variables read or produced.
    # This section is non-proxy only (asked of the respondent directly).

  blocks:
    # =========================================================================
    # BLOCK 1: SOCIAL SUPPORT (SOCSUP — 9 items)
    # =========================================================================
    # SOCSUP-INT   → intro comment (always)
    # SOCSUP-Q1    → Member of voluntary organizations? Switch. No/DK/R → skip Q2, go to Q2a.
    # SOCSUP-Q2    → Participation frequency (precondition: Q1 = Yes, i.e. == 1)
    # SOCSUP-Q2a   → Religious service attendance (always)
    # SOCSUP-Q3    → Someone to confide in (always) Switch
    # SOCSUP-Q4    → Someone to count on in crisis (always) Switch
    # SOCSUP-Q5    → Someone to give advice (always) Switch
    # SOCSUP-Q6    → Someone who makes you feel loved (always) Switch
    # SOCSUP-Q7    → Contact frequency grid (always) QuestionGroup with 8 sub-items Radio 8 options
    # =========================================================================
    - id: b_social_support
      title: "Social Support"
      items:
        # SOCSUP-INT: Interviewer introduction
        - id: q_socsup_int
          kind: Comment
          title: "Now, a few questions about your contact with different groups and support from family and friends."

        # SOCSUP-Q1 / SSC4_1: Member of voluntary organizations?
        # No/DK/R → GO TO SOCSUP-Q2a (skip Q2)
        - id: q_socsup_q1
          kind: Question
          title: "Are you a member of any voluntary organizations or associations such as school groups, church social groups, community centres, ethnic associations or social, civic or fraternal clubs?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q2 / SSC4_2: Participation frequency
        # Precondition: Q1 = Yes (outcome == 1)
        - id: q_socsup_q2
          kind: Question
          title: "How often did you participate in meetings or activities sponsored by these groups in the past 12 months?"
          precondition:
            - predicate: q_socsup_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least 3 or 4 times a year"
              4: "At least once a year"
              5: "Not at all"

        # SOCSUP-Q2a / SSC4_2A: Religious attendance (always asked)
        - id: q_socsup_q2a
          kind: Question
          title: "Other than on special occasions (weddings, funerals, baptisms), how often did you attend religious services or religious meetings in the past 12 months?"
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least 3 or 4 times a year"
              4: "At least once a year"
              5: "Not at all"

        # SOCSUP-Q3 / SSC4_3: Someone to confide in (always asked)
        - id: q_socsup_q3
          kind: Question
          title: "Do you have someone you can confide in, or talk to about your private feelings or concerns?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q4 / SSC4_4: Someone to count on in crisis (always asked)
        - id: q_socsup_q4
          kind: Question
          title: "Do you have someone you can really count on to help you out in a crisis situation?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q5 / SSC4_5: Someone to give advice (always asked)
        - id: q_socsup_q5
          kind: Question
          title: "Do you have someone you can really count on to give you advice when you are making important personal decisions?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q6 / SSC4_6: Someone who makes you feel loved (always asked)
        - id: q_socsup_q6
          kind: Question
          title: "Do you have someone that makes you feel loved and cared for?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q7 / SSC4_7A-7H: Contact frequency grid (always asked)
        # 8 sub-items, each with 8-option Radio scale.
        # Options: 1=Don't have any, 2=Every day, 3=At least once a week,
        #          4=2 or 3 times a month, 5=Once a month, 6=A few times a year,
        #          7=Once a year, 8=Never
        - id: qg_socsup_q7
          kind: QuestionGroup
          title: "The next few questions are about your contact in the past 12 months with persons who do not live with you. How often did you have contact with:"
          questions:
            - "Your parents or parents-in-law"
            - "Your grandparents"
            - "Your daughters or daughters-in-law"
            - "Your sons or sons-in-law"
            - "Your brothers or sisters"
            - "Other relatives (including in-laws)"
            - "Your close friends"
            - "Your neighbours"
          input:
            control: Radio
            labels:
              1: "Don't have any"
              2: "Every day"
              3: "At least once a week"
              4: "2 or 3 times a month"
              5: "Once a month"
              6: "A few times a year"
              7: "Once a year"
              8: "Never"

    # =========================================================================
    # BLOCK 2: HEALTH NUMBER (H06-HLTH# — 2 items)
    # =========================================================================
    # H06-HLTH#   → Permission to link health info. Switch. No/DK/R → skip H06-HLTH#1.
    # H06-HLTH#1  → Provincial health number. Textarea. Precondition: H06-HLTH# = Yes.
    # =========================================================================
    - id: b_health_number
      title: "Health Number"
      items:
        # H06-HLTH# / AM64_LNK: Permission to link health information
        # No/DK/R → GO TO Agreement to Share section (skip H06-HLTH#1)
        - id: q_h06_hlth_link
          kind: Question
          title: "We are seeking your permission to link information collected during this interview with provincial health information. Do we have your permission?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H06-HLTH#1 / HNC4_nn: Provincial health number
        # Precondition: H06-HLTH# = Yes (outcome == 1)
        - id: q_h06_hlth1
          kind: Question
          title: "What is your/his/her provincial health number?"
          precondition:
            - predicate: q_h06_hlth_link.outcome == 1
          input:
            control: Textarea

    # =========================================================================
    # BLOCK 3: AGREEMENT TO SHARE (H06-SHARE — 5 items)
    # =========================================================================
    # H06-SHARE  → Permission to share survey data (always)
    # H06-TEL    → Interview mode: telephone/in person/both (always)
    # H06-CTEXT  → Respondent alone? Switch. Yes → skip H06-CTEXT1, go to H06-P2.
    # H06-CTEXT1 → Answers affected by someone? Precondition: H06-CTEXT = No.
    # H06-P2     → Language of interview. Dropdown 19 options (always).
    # =========================================================================
    - id: b_agreement_to_share
      title: "Agreement to Share"
      items:
        # H06-SHARE / AM64_SHA: Permission to share survey information
        - id: q_h06_share
          kind: Question
          title: "To avoid duplication Statistics Canada intends to share the information from this survey with provincial ministries of health, Health Canada, and Employment and Immigration Canada. Do you agree to share the information you have provided?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H06-TEL / AM64_TEL: Interview mode
        - id: q_h06_tel
          kind: Question
          title: "Was this interview conducted on the telephone or in person?"
          input:
            control: Radio
            labels:
              1: "On telephone"
              2: "In person"
              3: "Both (Specify reason)"

        # H06-CTEXT / AM64_ALO: Was respondent alone?
        # Yes → GO TO H06-P2 (skip H06-CTEXT1)
        - id: q_h06_ctext
          kind: Question
          title: "Was the respondent alone when you asked this health questionnaire?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H06-CTEXT1 / AM64_AFF: Were answers affected by someone else?
        # Precondition: H06-CTEXT = No (outcome == 0)
        - id: q_h06_ctext1
          kind: Question
          title: "Do you think that the answers of the respondent were affected by someone else being there?"
          precondition:
            - predicate: q_h06_ctext.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H06-P2 / AM64_LNG: Language of interview (always asked)
        # 19 options
        - id: q_h06_p2
          kind: Question
          title: "Record language of interview"
          input:
            control: Dropdown
            labels:
              1: "English"
              2: "French"
              3: "Arabic"
              4: "Chinese"
              5: "Cree"
              6: "German"
              7: "Greek"
              8: "Hungarian"
              9: "Italian"
              10: "Korean"
              11: "Persian (Farsi)"
              12: "Polish"
              13: "Portuguese"
              14: "Punjabi"
              15: "Spanish"
              16: "Tagalog (Filipino)"
              17: "Ukrainian"
              18: "Vietnamese"
              19: "Other (Specify)"
