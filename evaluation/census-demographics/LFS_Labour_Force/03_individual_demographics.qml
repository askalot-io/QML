qmlVersion: "1.0"
questionnaire:
  title: "Labour Force Survey - Individual Demographics"

  codeInit: |
    # Variables PRODUCED by this section (read by later sections)
    respondent_age = 0    # consolidated age from ANC_Q01 or ANC_Q03
    sex = 0               # 1=Male, 2=Female
    armed_forces = 0      # 1=Yes, 2=No (from CAF_Q01; 0 if skipped by age filter)

    # Internal computed variables
    recent_immigrant = 0  # 1 if immigration year within 5 years, 0 otherwise
    has_postsecondary = 0 # 1 if ED_Q04 was answered (post-secondary obtained), 0 otherwise

  blocks:
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
