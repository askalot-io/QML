qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Household Record Variables"
  codeInit: |
    # Variables PRODUCED by this section (read by later sections)
    age = 0               # respondent's age (from DEMO_Q4)
    sex = 0               # respondent's sex: 1=Male, 2=Female (from DEMO_Q5)
    marital_status = 0    # marital status code 1-7 (from DEMO_Q6)

  blocks:
    # =========================================================================
    # BLOCK 1: HOUSEHOLD ROSTER INTRODUCTION
    # =========================================================================
    # DEMO_INT: Section introduction (no response collected)
    # DEMO_Q1: Roster name entry (open text)
    # DEMO_Q2/Q3: Loop-based roster questions — modeled as simple Yes/No.
    #   In the original CATI, Yes routes back to DEMO_Q1 to collect another
    #   name; QML cannot model dynamic loops so these are recorded as Yes/No
    #   gates only; the loop behaviour is noted here for reference.
    # =========================================================================
    - id: b_roster
      title: "Household Roster"
      items:
        # DEMO_INT: Interviewer introduction
        - id: q_demo_int
          kind: Comment
          title: "The next few questions will provide important basic information on the people in your household."

        # DEMO_Q1: Roster name entry
        # Original: collect first and last names of all household members
        # Modeled as a text entry for the household size count proxy.
        - id: q_demo_q1
          kind: Question
          title: "What are the names of all persons now living or staying here who have no usual place of residence elsewhere?"
          input:
            control: Textarea
            placeholder: "Enter names of all usual household members..."

        # DEMO_Q2 / DHC4_3A: Persons away but usually here?
        # Original: Yes → GO TO DEMO_Q1 (loop to add more names).
        # QML cannot model loops; recorded as Yes/No only.
        # Note: In the original CATI, answering Yes causes a loop back to
        # DEMO_Q1 to record the away person's name; this loop is not
        # modelled in QML.
        - id: q_demo_q2
          kind: Question
          title: "Are there any persons away from this household attending school, visiting, travelling or in hospital who usually live here?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # DEMO_Q3 / DHC4_3B: Anyone else live here?
        # Original: Yes → GO TO DEMO_Q1 (loop to add more names).
        # QML cannot model loops; recorded as Yes/No only.
        # Note: In the original CATI, answering Yes causes a loop back to
        # DEMO_Q1 to record the additional person; this loop is not
        # modelled in QML.
        - id: q_demo_q3
          kind: Question
          title: "Does anyone else live at this dwelling such as young children, relatives, roomers, boarders or employees?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 2: INDIVIDUAL DEMOGRAPHICS (per household member)
    # =========================================================================
    # DEMO_Q4: Date of birth → calculate age (modeled as age Editbox 0-120)
    # DEMO_Q5: Sex → sets cross-section variable sex
    # DEMO_Q6: Marital status → sets cross-section variable marital_status
    #          Note: age < 15 → automatically Single (handled in codeBlock)
    # DEMO_Q7: Family ID code (A-Z text entry; modeled as numeric 1-26)
    # DEMO_Q8: Relationships grid — modeled as Comment (captured at
    #          household level in original; QML does not support matrices
    #          spanning multiple household members)
    # =========================================================================
    - id: b_individual_demographics
      title: "Individual Demographics"
      items:
        # DEMO_Q4 / DHC4_DAT / DHC4_DOB / DHC4_AGE: Date of birth → age
        # Original: date entry (DD/MM/YY); age calculated and confirmed.
        # Modeled as age in years (0-120) since QML has no date control.
        - id: q_demo_q4
          kind: Question
          title: "What is ...'s age? (Original question asks date of birth; age is calculated from DD/MM/YY and confirmed with respondent.)"
          codeBlock: |
            age = q_demo_q4.outcome
          input:
            control: Editbox
            min: 0
            max: 120
            left: "Age:"
            right: "years"

        # DEMO_Q5 / DHC4_SEX: Sex
        - id: q_demo_q5
          kind: Question
          title: "Enter or ask ...'s sex."
          codeBlock: |
            sex = q_demo_q5.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # DEMO_Q6 / DHC4_MAR: Marital status
        # Note: If age < 15, marital status is automatically Single (code 4).
        # This is handled in the codeBlock: if the entered outcome is not
        # Single but age < 15, marital_status is forced to Single (4).
        - id: q_demo_q6
          kind: Question
          title: "What is ...'s current marital status? (Note: if age is under 15, marital status is automatically recorded as Single.)"
          codeBlock: |
            if age < 15:
              marital_status = 4
            else:
              marital_status = q_demo_q6.outcome
          input:
            control: Radio
            labels:
              1: "Now married"
              2: "Common-law"
              3: "Living with a partner"
              4: "Single (never married)"
              5: "Widowed"
              6: "Separated"
              7: "Divorced"

        # DEMO_Q7 / DHC4_FID: Family ID code (A-Z)
        # Original: text entry of a single letter A-Z; legal household check
        # follows; selection criteria applied.
        # Modeled as numeric 1-26 (1=A, 2=B, ... 26=Z).
        - id: q_demo_q7
          kind: Question
          title: "Enter ...'s family Id code. (A=1, B=2, ... Z=26; legal household check and selection criteria applied after entry.)"
          input:
            control: Editbox
            min: 1
            max: 26

        # DEMO_Q8: Relationships grid
        # Original: matrix capturing relationships of every household member
        # to every other (birth parent, step parent, foster parent, etc.).
        # QML does not support multi-respondent relationship matrices;
        # this item is recorded as a Comment for documentation.
        - id: q_demo_q8
          kind: Comment
          title: "Record relationships of everyone to everyone else in the household. (Original: Grid/Matrix — Birth Parent, Step Parent, Foster Parent, Birth Child, Step Child, Foster Child, Sister/Brother, Grandparent, Grandchild, Common-law Partner, In-law, Other Related, Unrelated, Husband/Wife, Adopted Child, Adoptive Parent, Same-sex Partner. QML does not support multi-respondent relationship matrices; captured at the household level in the original CATI system.)"

    # =========================================================================
    # BLOCK 3: DWELLING CHARACTERISTICS
    # =========================================================================
    # HHLD_Q1: Dwelling owned?
    # (HHLD_Q2 is not in inventory — omitted)
    # HHLD_Q3: Number of bedrooms
    # HHLD_Q4: Pet in household? (No → skip to HHLD_Q6)
    # HHLD_Q5: What kind of pet? (precondition: HHLD_Q4=Yes)
    # HHLD_Q5a: Pet lives mainly indoors? (precondition: HHLD_Q4=Yes)
    # HHLD_Q6: Type of dwelling (interviewer-coded)
    # =========================================================================
    - id: b_dwelling
      title: "Dwelling Characteristics"
      items:
        # HHLD_Q1 / DHC4_OWN: Dwelling owned?
        - id: q_hhld_q1
          kind: Question
          title: "Now a few questions about your dwelling. Is this dwelling owned by a member of this household (even if being paid for)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD_Q3 / DHC4_BED: Number of bedrooms
        # Note: if no separate, enclosed bedroom enter "00"
        - id: q_hhld_q3
          kind: Question
          title: "How many bedrooms are there in this dwelling? (If no separate, enclosed bedroom, enter 0.)"
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Bedrooms:"

        # HHLD_Q4 / DH_4_P1: Pet in household?
        # No → GO TO HHLD_Q6 (skip HHLD_Q5 and HHLD_Q5a)
        - id: q_hhld_q4
          kind: Question
          title: "Is there a pet in this household?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD_Q5 / DH_4DP2: What kind of pet?
        # Precondition: HHLD_Q4 = Yes (1)
        # Original: Checkbox — do not read list, mark all that apply
        - id: q_hhld_q5
          kind: Question
          title: "What kind of pet? (Do not read list; mark all that apply.)"
          precondition:
            - predicate: q_hhld_q4.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Dog"
              2: "Cat"
              4: "Other"

        # HHLD_Q5a / DH_4_P3: Pet lives mainly indoors?
        # Precondition: HHLD_Q4 = Yes (1)
        - id: q_hhld_q5a
          kind: Question
          title: "Does this pet or do any of these pets live mainly indoors?"
          precondition:
            - predicate: q_hhld_q4.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD_Q6 / DHC4_DWE: Type of dwelling (interviewer-coded by observation)
        - id: q_hhld_q6
          kind: Question
          title: "Record type of dwelling (by interviewer observation)."
          input:
            control: Radio
            labels:
              1: "Single detached house"
              2: "Semi-detached or double"
              3: "Garden house/town-house/row house"
              4: "Duplex"
              5: "Low-rise apartment (less than 5 stories)"
              6: "High-rise apartment (5 or more stories)"
              7: "Institution"
              8: "Hotel/rooming/lodging house/camp/Hutterite Colony"
              9: "Mobile home"
              10: "Other (Specify)"

    # =========================================================================
    # BLOCK 4: ADMINISTRATION
    # =========================================================================
    # HHLD_Q7: Information source indicator (interviewer-recorded)
    # HHLD_Q8: Language of interview (interviewer-recorded)
    # =========================================================================
    - id: b_administration
      title: "Administration"
      items:
        # HHLD_Q7 / AM34_SRC: Information source indicator
        # Interviewer-coded: who is providing the information
        - id: q_hhld_q7
          kind: Question
          title: "Information Source Indicator — who is providing the information. (Interviewer-recorded.)"
          input:
            control: Radio
            labels:
              1: "Self (respondent)"
              2: "Proxy (another household member)"
              3: "Other"

        # HHLD_Q8 / AM34_LNG: Language of interview (interviewer-recorded)
        - id: q_hhld_q8
          kind: Question
          title: "Record language of interview. (Interviewer-recorded.)"
          input:
            control: Radio
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
