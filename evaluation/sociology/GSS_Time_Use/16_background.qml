qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Background Characteristics (Section S)"
  codeInit: |
    # Extern variable: multilingual path indicator from Section F
    lang_path: {1, 2, 3, 4, 5, 6}

  blocks:
    # =========================================================================
    # BLOCK 1: ETHNIC, RELIGIOUS, AND COMMUNITY BACKGROUND
    # =========================================================================
    # S1: Ethnic group (multi-select)
    # S2: Religion (dropdown). If "No religion" → skip S3
    # S3: Attendance (only if has religion)
    # S4: Community size
    # S5: Town name
    # S6: Postal code
    # S7: Dwelling type
    # S8: Owned/rented
    # =========================================================================
    - id: b_background
      title: "Background Characteristics"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # S1: Ethnic or cultural group
        - id: q_s1
          kind: Question
          title: "To which ethnic or cultural group do you or did your ancestors belong?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Irish"
              8: "Scottish"
              16: "German"
              32: "Italian"
              64: "Ukrainian"
              128: "Don't know"
              256: "Other"

        # S2: Religion
        - id: q_s2
          kind: Question
          title: "What, if any, is your religion?"
          input:
            control: Dropdown
            labels:
              0: "No religion"
              1: "Roman Catholic"
              2: "United Church"
              3: "Anglican"
              4: "Presbyterian"
              5: "Lutheran"
              6: "Baptist"
              7: "Eastern Orthodox"
              8: "Jewish"
              9: "Other"

        # S3: Religious attendance (only if has religion, S2 != 0)
        - id: q_s3
          kind: Question
          title: "Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?"
          precondition:
            - predicate: q_s2.outcome != 0
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least once a year"
              4: "Less than once a year"
              5: "Never"

        # S4: Community size
        - id: q_s4
          kind: Question
          title: "What is the approximate size of the community in which you are now living? By community I mean city, town or rural area."
          input:
            control: Radio
            labels:
              1: "Less than 5,000 population or a rural area"
              2: "5,000 to less than 25,000 population"
              3: "25,000 to less than 100,000 population"
              4: "100,000 to 1 million population"
              5: "Over 1 million population"

        # S5: Town name
        - id: q_s5
          kind: Question
          title: "What is the name of that town or nearest town?"
          input:
            control: Textarea
            placeholder: "Enter town name and province"

        # S6: Postal code
        - id: q_s6
          kind: Question
          title: "What are the first three characters of your postal code?"
          input:
            control: Textarea
            placeholder: "Enter first 3 characters"
            maxLength: 3

        # S7: Dwelling type
        - id: q_s7
          kind: Question
          title: "What type of dwelling are you now living in? Is it..."
          input:
            control: Dropdown
            labels:
              1: "Single detached house"
              2: "Semi-detached or double (side-by-side)"
              3: "Garden house, town-house or row house"
              4: "Duplex (one above the other)"
              5: "Low-rise apartment (less than five stories)"
              6: "High-rise apartment (five or more stories)"
              7: "Other"

        # S8: Owned or rented
        - id: q_s8
          kind: Question
          title: "Is this dwelling owned or rented by a member of this household?"
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"

    # =========================================================================
    # BLOCK 2: TELEPHONE DETAILS
    # =========================================================================
    # S9: Number of telephones. If 1 → skip to S14.
    # S10: Same number? If Yes → skip to S14.
    # S11: How many different numbers?
    # S12: Any business use only? If No → skip to S14.
    # S13: How many business only?
    # =========================================================================
    - id: b_telephone
      title: "Telephone Details"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # S9: Number of telephones
        - id: q_s9
          kind: Question
          title: "How many telephones, counting extensions, are there in your dwelling?"
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two or more"

        # S10: Same telephone number (only if S9 = 2, two or more)
        - id: q_s10
          kind: Question
          title: "Do all the telephones have the same number?"
          precondition:
            - predicate: q_s9.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # S11: How many different numbers (only if S10 = 0, No)
        - id: q_s11
          kind: Question
          title: "How many different numbers are there?"
          precondition:
            - predicate: q_s9.outcome == 2
            - predicate: q_s10.outcome == 0
          input:
            control: Editbox
            min: 2
            max: 20
            right: "numbers"

        # S12: Any business use only (only if S10 = 0, No)
        - id: q_s12
          kind: Question
          title: "Are any of these numbers for business use only?"
          precondition:
            - predicate: q_s9.outcome == 2
            - predicate: q_s10.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # S13: How many business only (only if S12 = 1, Yes)
        - id: q_s13
          kind: Question
          title: "How many are for business use only?"
          precondition:
            - predicate: q_s12.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "numbers"

    # =========================================================================
    # BLOCK 3: INCOME
    # =========================================================================
    # S14: Wages/salary/self-employment income
    # S15: Government income
    # S16: Investment/pension income
    # S17: Household income cascading brackets
    #
    # The original S14 and S16 have conditional numeric entry for amounts.
    # Since QML integer inputs cannot elegantly combine a category selector
    # with an open-ended dollar amount, these are modeled as Radio selectors
    # for the category, with separate Editbox items for amounts when applicable.
    # =========================================================================
    - id: b_income
      title: "Income"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # S14: Wages/salary/self-employment income type
        - id: q_s14
          kind: Question
          title: "What was your income before taxes, from wages, salaries and self-employment during the last 12 months?"
          input:
            control: Radio
            labels:
              1: "Income (had earnings)"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        # S14_amount: Dollar amount (if income or loss)
        - id: q_s14_amount
          kind: Question
          title: "What was the dollar amount?"
          precondition:
            - predicate: q_s14.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # S15: Government income type
        - id: q_s15
          kind: Question
          title: "What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security?"
          input:
            control: Radio
            labels:
              1: "Income (had government income)"
              2: "No income from government"
              3: "Don't know"

        # S15_amount: Dollar amount (if government income)
        - id: q_s15_amount
          kind: Question
          title: "What was the dollar amount from government sources?"
          precondition:
            - predicate: q_s15.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # S16: Investment/pension income type
        - id: q_s16
          kind: Question
          title: "What was your income from investments or private pensions?"
          input:
            control: Radio
            labels:
              1: "Income (had investment income)"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        # S16_amount: Dollar amount (if income or loss)
        - id: q_s16_amount
          kind: Question
          title: "What was the dollar amount from investments or private pensions?"
          precondition:
            - predicate: q_s16.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # =================================================================
        # S17: HOUSEHOLD INCOME — CASCADING BRACKETS
        # =================================================================
        # The original instrument uses an unfolding binary tree:
        #   S17a: <$20K or $20K+?
        #     If <$20K → S17b: <$10K or $10K+?
        #       If <$10K → S17c: <$5K or $5K+?
        #       If $10K+ → S17d: <$15K or $15K+?
        #     If $20K+ → S17e: <$40K or $40K+?
        #       If <$40K → S17f: <$30K or $30K+?
        #       If $40K+ → S17g: <$60K or $60K+?
        # =================================================================

        # S17a: First bracket split
        - id: q_s17a
          kind: Question
          title: "What is your best estimate of the total income of all household members from all sources during the last 12 months? Was the total household income..."
          input:
            control: Radio
            labels:
              1: "Less than $20,000"
              2: "$20,000 and more"
              3: "No income"
              4: "Don't know"

        # S17b: Under $20K split (S17a = 1)
        - id: q_s17b
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $10,000"
              2: "$10,000 and more"

        # S17c: Under $10K split (S17b = 1)
        - id: q_s17c
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17b.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $5,000"
              2: "$5,000 and more"

        # S17d: $10K+ split (S17b = 2)
        - id: q_s17d
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17b.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $15,000"
              2: "$15,000 and more"

        # S17e: $20K+ split (S17a = 2)
        - id: q_s17e
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17a.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $40,000"
              2: "$40,000 and more"

        # S17f: Under $40K split (S17e = 1)
        - id: q_s17f
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $30,000"
              2: "$30,000 and more"

        # S17g: $40K+ split (S17e = 2)
        - id: q_s17g
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17e.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $60,000"
              2: "$60,000 and more"
