qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth Survey - Contact and Household Component"
  codeInit: |
    # Variables PRODUCED by this section (for downstream sections)
    child_age = 0           # age of the selected child (0-11)
    respondent_sex = 0      # 1=Male, 2=Female
    marital_status = 0      # 1=Married, 2=Common-law, 3=Partner, 4=Single, 5=Widowed, 6=Separated, 7=Divorced

  blocks:
    # =========================================================================
    # BLOCK 1: CONTACT INTRODUCTION
    # =========================================================================
    # CONT-Q1A, CONT-Q2, CONT-Q3A, CONT-Q4A, CONT-Q7
    # Introductory scripts and language preference.
    # =========================================================================
    - id: b_contact
      title: "Contact Introduction"
      items:
        # CONT-Q1A: Interviewer introduction
        - id: q_cont_q1a
          kind: Comment
          title: "Hello, I'm calling from Statistics Canada. I am contacting you about the National Longitudinal Survey of Children."

        # CONT-Q2: Language preference
        - id: q_cont_q2
          kind: Question
          title: "Would you prefer to be interviewed in English or French?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Either"

        # CONT-Q3A: Survey purpose
        - id: q_cont_q3a
          kind: Comment
          title: "We are conducting this survey to collect information on children, their development, family and school experiences."

        # CONT-Q4A: Confidentiality notice
        - id: q_cont_q4a
          kind: Comment
          title: "Your answers will be kept strictly confidential and used only for statistical purposes. While participation is voluntary, your assistance is essential if the results are to be accurate."

        # CONT-Q7: Transition to household questions
        - id: q_cont_q7
          kind: Comment
          title: "The next few questions will provide important basic information on the people in your household."

    # =========================================================================
    # BLOCK 2: DEMOGRAPHICS
    # =========================================================================
    # DEMO-Q1 through DEMO-Q3 are household roster questions involving
    # dynamic looping over household members (add names, ask if anyone else
    # is away/living here, loop back). QML cannot model dynamic rosters.
    #
    # DEMO-Q7 (family ID code) and DEMO-Q8 (relationships of everyone to
    # everyone else) are also roster/internal items that cannot be modeled.
    #
    # Modeled items:
    #   DEMO-Q4: Date of birth (modeled as respondent age + child age)
    #   DEMO-Q5: Sex
    #   DEMO-Q6: Marital status
    # =========================================================================
    - id: b_demographics
      title: "Demographics"
      items:
        # Roster omission notice
        - id: q_roster_notice
          kind: Comment
          title: "Household roster collection (DEMO-Q1 through Q3: names, persons away, others living here) is conducted externally via roster management. DEMO-Q7 (family ID) and DEMO-Q8 (inter-person relationships) are also collected through the roster system."

        # DEMO-Q4: Date of birth
        # The original asks for date of birth. Since QML does not support date
        # inputs, we model the respondent's age and the selected child's age
        # as separate Editbox items.
        - id: q_respondent_age
          kind: Question
          title: "What is the respondent's age?"
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years"

        - id: q_child_age
          kind: Question
          title: "What is the age of the selected child?"
          postcondition:
            - predicate: q_child_age.outcome <= 11
              hint: "The NLSCY covers children aged 0 to 11."
          codeBlock: |
            child_age = q_child_age.outcome
          input:
            control: Editbox
            min: 0
            max: 11
            right: "years"

        # DEMO-Q5: Sex of respondent
        - id: q_demo_q5
          kind: Question
          title: "Enter or confirm the respondent's sex."
          codeBlock: |
            respondent_sex = q_demo_q5.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # DEMO-Q6: Marital status
        - id: q_demo_q6
          kind: Question
          title: "What is the respondent's marital status?"
          codeBlock: |
            marital_status = q_demo_q6.outcome
          input:
            control: Dropdown
            labels:
              1: "Now married"
              2: "Common-law"
              3: "Living with a partner"
              4: "Single (never married)"
              5: "Widowed"
              6: "Separated"
              7: "Divorced"

    # =========================================================================
    # BLOCK 3: HOUSEHOLD DWELLING
    # =========================================================================
    # HHLD-Q1: Dwelling owned?
    # HHLD-C1A routing: if owned (HHLD-Q1=Yes), skip HHLD-Q2
    # HHLD-Q2: Subsidized housing? (only if NOT owned)
    # HHLD-Q2B: Dwelling repairs needed?
    # HHLD-Q3: Number of bedrooms
    # HHLD-Q6: Dwelling type (interviewer observation) - modeled as Dropdown
    # HHLD-Q7: Information source indicator - omitted (procedural)
    # HHLD-Q8: Language of interview - omitted (procedural, duplicates CONT-Q2)
    # =========================================================================
    - id: b_dwelling
      title: "Household Dwelling"
      items:
        # HHLD-Q1: Dwelling owned?
        - id: q_hhld_q1
          kind: Question
          title: "Now a few questions about your dwelling. Is this dwelling owned by a member of this household (even if being paid for)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD-Q2: Subsidized housing?
        # HHLD-C1A routing: if HHLD-Q1=Yes (owned), skip this question
        - id: q_hhld_q2
          kind: Question
          title: "Is this dwelling subsidized by the government for any reason? (e.g., low income housing project, co-operative housing project, public housing)"
          precondition:
            - predicate: q_hhld_q1.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD-Q2B: Dwelling repairs needed?
        - id: q_hhld_q2b
          kind: Question
          title: "Is this dwelling in need of any repairs?"
          input:
            control: Radio
            labels:
              1: "Yes, minor repairs (missing or loose floor tiles, bricks or shingles, defective steps, railing or siding, etc.)"
              2: "Yes, major repairs (defective plumbing or electrical wiring, structural repairs to walls, floors or ceilings, etc.)"
              3: "No, only regular maintenance is needed (painting, furnace cleaning, etc.)"

        # HHLD-Q3: Number of bedrooms
        - id: q_hhld_q3
          kind: Question
          title: "How many bedrooms are there in this dwelling? (If no separate enclosed bedroom, enter 0.)"
          input:
            control: Editbox
            min: 0
            max: 20

        # HHLD-Q6: Dwelling type (interviewer observation)
        - id: q_hhld_q6
          kind: Question
          title: "Record type of dwelling (by interviewer observation)."
          input:
            control: Dropdown
            labels:
              1: "Single detached house"
              2: "Semi-detached or double (side-by-side)"
              3: "Garden home, town-house or row house"
              4: "Duplex (one above the other)"
              5: "Low-rise apartment (less than 5 stories)"
              6: "High-rise apartment (5 or more stories)"
              7: "Institution"
              8: "Hotel, rooming or lodging house, logging or construction camp, Hutterite colony"
              9: "Mobile home"
              10: "Other"

    # =========================================================================
    # BLOCK 4: CHILD SELECTION AND RESPONDENT IDENTIFICATION
    # =========================================================================
    # CAID-INT-1 and PICKRESP: Identify who is most knowledgeable about
    # the selected child (PMK) and who is providing information.
    # Modeled as Comment + Dropdown for respondent type.
    # =========================================================================
    - id: b_child_selection
      title: "Child Selection and Respondent Identification"
      items:
        # CAID-INT-1: PMK identification intro
        - id: q_caid_int1
          kind: Comment
          title: "Who is the person most knowledgeable (PMK) about the selected child?"

        # PICKRESP: Who is providing information?
        - id: q_pickresp
          kind: Question
          title: "Who is providing the information for this child's form?"
          input:
            control: Radio
            labels:
              1: "PMK (person most knowledgeable)"
              2: "Spouse/partner of PMK"
              3: "Other household member"

    # =========================================================================
    # BLOCK 5: ADMINISTRATION
    # =========================================================================
    # H05-P1: Interview mode
    # H05-P2: Language of interview
    # =========================================================================
    - id: b_administration
      title: "Administration"
      items:
        # H05-P1: Interview mode
        - id: q_h05_p1
          kind: Question
          title: "Was this interview conducted on the telephone or in person?"
          input:
            control: Radio
            labels:
              1: "On telephone"
              2: "In person"
              3: "Both"

        # H05-P2: Language of interview
        - id: q_h05_p2
          kind: Question
          title: "Record the language of interview."
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
              19: "Other"
