qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Section U: Background Characteristics (English-Only)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {7}

    # Tracks whether respondent worked in past 12 months (U28/U29)
    worked_12m_u = 0

  blocks:
    # =========================================================================
    # BLOCK 1: EDUCATION (U1–U12a)
    # =========================================================================
    # Routing summary:
    #   U1: Years of education
    #       0 → skip to U12; 5-10 → skip to U3; 11-13 → U2
    #   U2: Graduated secondary? Pre: U1 in [11,12,13]
    #   U3: Further schooling? Pre: U1 != 0
    #       Yes (1) → U4; No (0) → U5
    #   U4: Highest level. Pre: U3 == 1
    #   U5: Year of highest education. Pre: U1 != 0
    #   U6: First job type. Pre: U1 != 0
    #       1 (employee) → U7; 2 (self-employed) → U8; 3 (never) → U11
    #   U7: Employer. Pre: U6 == 1
    #   U8: Business type. Pre: U6 in [1, 2]
    #   U9: Work description. Pre: U6 in [1, 2]
    #   U10: Year began. Pre: U6 in [1, 2]
    #   U11: Language courses in school. Pre: U1 != 0
    #   U11a: Which languages. Pre: U11 == 1
    #   U12: Language courses outside school (always asked)
    #   U12a: Which languages. Pre: U12 == 1
    # =========================================================================
    - id: b_u_education
      title: "Education and Language Training"
      precondition:
        - predicate: lang_path == 7
      items:
        # U1: Years of elementary and secondary education
        - id: q_u1
          kind: Question
          title: "How many years of elementary and secondary education have you completed?"
          input:
            control: Radio
            labels:
              0: "No schooling"
              5: "One to five years"
              6: "Six"
              7: "Seven"
              8: "Eight"
              9: "Nine"
              10: "Ten"
              11: "Eleven"
              12: "Twelve"
              13: "Thirteen"

        # U2: Graduated from secondary school?
        # Pre: U1 in [11, 12, 13]
        - id: q_u2
          kind: Question
          title: "Have you graduated from secondary school?"
          precondition:
            - predicate: q_u1.outcome in [11, 12, 13]
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U3: Further schooling beyond elementary/secondary?
        # Pre: U1 != 0 (has some schooling)
        - id: q_u3
          kind: Question
          title: "Have you had any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: q_u1.outcome != 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U4: Highest level of further education
        # Pre: U3 == 1 (Yes, further schooling)
        - id: q_u4
          kind: Question
          title: "What is the highest level you attained?"
          precondition:
            - predicate: q_u3.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"

        # U5: Year of highest education
        # Pre: U1 != 0
        - id: q_u5
          kind: Question
          title: "In which year did you reach your highest level of education?"
          precondition:
            - predicate: q_u1.outcome != 0
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # U6: First full-time job type after highest education
        # Pre: U1 != 0
        # 1 → U7; 2 → U8; 3 → U11
        - id: q_u6
          kind: Question
          title: "Think about the first full-time job you had after reaching your highest level of education. Were you an employee working for someone else or self-employed?"
          precondition:
            - predicate: q_u1.outcome != 0
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"
              3: "Never had a full-time job after this date"

        # U7: Employer name
        # Pre: U6 == 1 (employee)
        - id: q_u7
          kind: Question
          title: "For whom did you work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_u6.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name..."

        # U8: Kind of business/industry
        # Pre: U6 in [1, 2] (employee or self-employed)
        - id: q_u8
          kind: Question
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: q_u6.outcome in [1, 2]
          input:
            control: Textarea
            placeholder: "Give a full description..."

        # U9: Kind of work
        # Pre: U6 in [1, 2]
        - id: q_u9
          kind: Question
          title: "What kind of work were you doing?"
          precondition:
            - predicate: q_u6.outcome in [1, 2]
          input:
            control: Textarea
            placeholder: "Give a full description..."

        # U10: Year began working at that job
        # Pre: U6 in [1, 2]
        - id: q_u10
          kind: Question
          title: "In what year did you begin working at this job?"
          precondition:
            - predicate: q_u6.outcome in [1, 2]
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # U11: Language courses in full-time school?
        # Pre: U1 != 0
        - id: q_u11
          kind: Question
          title: "Have you ever taken any language courses as part of full-time school?"
          precondition:
            - predicate: q_u1.outcome != 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U11a: Which languages (in school)?
        # Pre: U11 == 1
        - id: q_u11a
          kind: Question
          title: "Which languages did you study in school?"
          precondition:
            - predicate: q_u11.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # U12: Language courses outside school?
        # Always asked (even if U1 == 0, since the original routes here from U1=0)
        - id: q_u12
          kind: Question
          title: "Have you ever taken any language courses outside of full-time school?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U12a: Which languages (outside school)?
        # Pre: U12 == 1
        - id: q_u12a
          kind: Question
          title: "Which languages did you study outside of school?"
          precondition:
            - predicate: q_u12.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

    # =========================================================================
    # BLOCK 2: DEMOGRAPHICS (U13–U21a)
    # =========================================================================
    # U13: Religion. 0 → skip U14
    # U14: Attendance. Pre: U13 != 0
    # U15: Ethnic group (Checkbox)
    # U16: Community size
    # U17: Town name (Textarea)
    # U18: Postal code (Textarea)
    # U19: Dwelling type
    # U20: Owned or rented
    # U21: Other language at home. 2 → U21a
    # U21a: Which languages. Pre: U21 == 2
    # =========================================================================
    - id: b_u_demographics
      title: "Demographics"
      precondition:
        - predicate: lang_path == 7
      items:
        # U13: Religion
        - id: q_u13
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

        # U14: Religious attendance
        # Pre: U13 != 0 (has a religion)
        - id: q_u14
          kind: Question
          title: "Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?"
          precondition:
            - predicate: q_u13.outcome != 0
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least once a year"
              4: "Less than once a year"
              5: "Never"

        # U15: Ethnic or cultural group
        - id: q_u15
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
              128: "Other"
              256: "Don't know"

        # U16: Community size
        - id: q_u16
          kind: Question
          title: "What is the approximate size of the community in which you are now living? By community I mean city, town or rural area."
          input:
            control: Radio
            labels:
              1: "Less than 5,000 or rural"
              2: "5,000 to 25,000"
              3: "25,000 to 100,000"
              4: "100,000 to 1 million"
              5: "Over 1 million"

        # U17: Town name
        - id: q_u17
          kind: Question
          title: "What is the name of that town or nearest town? (Include province.)"
          input:
            control: Textarea
            placeholder: "Town and province..."

        # U18: Postal code (first 3 characters)
        - id: q_u18
          kind: Question
          title: "What are the first three characters of your postal code?"
          input:
            control: Textarea
            placeholder: "e.g., K1A"

        # U19: Dwelling type
        - id: q_u19
          kind: Question
          title: "What type of dwelling are you now living in?"
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

        # U20: Owned or rented
        - id: q_u20
          kind: Question
          title: "Is this dwelling owned or rented by a member of this household?"
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"

        # U21: Other language spoken at home
        # 2 (Yes) → U21a
        - id: q_u21
          kind: Question
          title: "Is there a language, other than English, spoken in your home by the people living there?"
          input:
            control: Radio
            labels:
              1: "Person lives alone"
              2: "Yes"
              3: "No"

        # U21a: Which other languages at home
        # Pre: U21 == 2
        - id: q_u21a
          kind: Question
          title: "Which languages are spoken at home besides English?"
          precondition:
            - predicate: q_u21.outcome == 2
          input:
            control: Checkbox
            labels:
              1: "French"
              2: "Other"

    # =========================================================================
    # BLOCK 3: TELEPHONES (U22–U26)
    # =========================================================================
    # U22: How many phones? 1 → skip to U27; 2 → U23
    # U23: Same number? Pre: U22 == 2. Yes (1) → skip to U27; No (0) → U24
    # U24: How many different numbers? Pre: U22 == 2 and U23 == 0
    # U25: Business use? Pre: U22 == 2 and U23 == 0. No (0) → skip to U27
    # U26: How many business? Pre: U25 == 1
    # =========================================================================
    - id: b_u_telephones
      title: "Telephone Details"
      precondition:
        - predicate: lang_path == 7
      items:
        # U22: Number of telephones
        - id: q_u22
          kind: Question
          title: "How many telephones, counting extensions, are there in your dwelling?"
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two or more"

        # U23: Same number for all phones?
        # Pre: U22 == 2 (two or more phones)
        - id: q_u23
          kind: Question
          title: "Do all the telephones have the same number?"
          precondition:
            - predicate: q_u22.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U24: How many different numbers?
        # Pre: U22 == 2 and U23 == 0 (different numbers)
        - id: q_u24
          kind: Question
          title: "How many different numbers are there?"
          precondition:
            - predicate: q_u22.outcome == 2
            - predicate: q_u23.outcome == 0
          input:
            control: Editbox
            min: 2
            max: 20
            right: "numbers"

        # U25: Any numbers for business use only?
        # Pre: U22 == 2 and U23 == 0
        - id: q_u25
          kind: Question
          title: "Are any of these numbers for business use only?"
          precondition:
            - predicate: q_u22.outcome == 2
            - predicate: q_u23.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U26: How many for business use?
        # Pre: U25 == 1 (yes, some business)
        - id: q_u26
          kind: Question
          title: "How many are for business use only?"
          precondition:
            - predicate: q_u25.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "numbers"

    # =========================================================================
    # BLOCK 4: EMPLOYMENT AND INCOME (U27–U41)
    # =========================================================================
    # U27: Main activity last 7 days (Radio)
    # U28: Main activity last 12 months
    #       1 (working) → skip to U31; else → U29
    #       codeBlock: if U28==1, worked_12m_u = 1
    # U29: Job in last 12 months? Pre: U28 != 1
    #       Yes (1) → U31; No (0) → U30
    #       codeBlock: if U29==1, worked_12m_u = 1
    # U30: Income from wages? Pre: U29 == 0 (no job)
    # U30_amount: Dollar amount. Pre: U30 in [1, 2]
    #       Then skip to U39 (modeled via preconditions on U31-U38)
    # U31: Weeks worked. Pre: worked_12m_u == 1
    # U32: Employee or self-employed. Pre: worked_12m_u == 1
    # U33: Full/part-time. Pre: U32 == 1 (employee)
    # U34: Employer. Pre: U32 == 1
    # U35: Business type. Pre: worked_12m_u == 1
    # U36: Work description. Pre: worked_12m_u == 1
    # U37: Languages at work. Pre: worked_12m_u == 1
    # U38: Income from wages (workers). Pre: worked_12m_u == 1
    # U38_amount: Dollar amount. Pre: U38 in [1, 2]
    # U39: Government income (always asked)
    # U40: Investment income
    # U40_amount: Dollar amount. Pre: U40 in [1, 2]
    # U41: Household income bracket (cascading → single Dropdown)
    # =========================================================================
    - id: b_u_employment
      title: "Employment and Income"
      precondition:
        - predicate: lang_path == 7
      items:
        # U27: Main activity last 7 days
        - id: q_u27
          kind: Question
          title: "Which of the following best describes your main activity during the last 7 days? Were you mainly..."
          input:
            control: Dropdown
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        # U28: Main activity last 12 months
        # 1 → worked_12m_u = 1, skip to U31
        - id: q_u28
          kind: Question
          title: "What about your main activity during the last 12 months? Were you mainly..."
          codeBlock: |
            if q_u28.outcome == 1:
              worked_12m_u = 1
          input:
            control: Dropdown
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        # U29: Had a job in last 12 months?
        # Pre: U28 != 1 (not mainly working)
        - id: q_u29
          kind: Question
          title: "Did you have a job at any time during the last 12 months?"
          precondition:
            - predicate: q_u28.outcome != 1
          codeBlock: |
            if q_u29.outcome == 1:
              worked_12m_u = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U30: Income from wages (for those who did NOT work)
        # Pre: U28 != 1 and U29 == 0 (no job at all in 12 months)
        - id: q_u30
          kind: Question
          title: "Did you have any income from wages, salaries and self-employment during the last 12 months?"
          precondition:
            - predicate: q_u28.outcome != 1
            - predicate: q_u29.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes - Income"
              2: "Yes - Loss"
              3: "No income"
              4: "Don't know"

        # U30_amount: Dollar amount of income/loss (non-workers)
        # Pre: U30 in [1, 2]
        - id: q_u30_amount
          kind: Question
          title: "What was the amount?"
          precondition:
            - predicate: q_u30.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # U31: Weeks worked in last 12 months
        # Pre: worked_12m_u == 1
        - id: q_u31
          kind: Question
          title: "For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave.)"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        # U32: Employee or self-employed
        # Pre: worked_12m_u == 1
        - id: q_u32
          kind: Question
          title: "During those weeks of work were you mainly..."
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"

        # U33: Full-time or part-time
        # Pre: U32 == 1 (employee)
        - id: q_u33
          kind: Question
          title: "During those weeks of work were you mostly full-time or part-time?"
          precondition:
            - predicate: q_u32.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        # U34: Employer name
        # Pre: U32 == 1 (employee)
        - id: q_u34
          kind: Question
          title: "For whom do you/did you last work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_u32.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name..."

        # U35: Kind of business/industry
        # Pre: worked_12m_u == 1
        - id: q_u35
          kind: Question
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Textarea
            placeholder: "Give a full description..."

        # U36: Kind of work
        # Pre: worked_12m_u == 1
        - id: q_u36
          kind: Question
          title: "What kind of work were you doing?"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Textarea
            placeholder: "Give a full description..."

        # U37: Languages spoken at work
        # Pre: worked_12m_u == 1
        - id: q_u37
          kind: Question
          title: "Which languages are/were spoken at work by people with whom you have/had regular contact?"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # U38: Income from wages (workers)
        # Pre: worked_12m_u == 1
        - id: q_u38
          kind: Question
          title: "What was your income before taxes, from wages, salaries and self-employment during the last 12 months?"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Radio
            labels:
              1: "Income"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        # U38_amount: Dollar amount (workers with income/loss)
        # Pre: U38 in [1, 2]
        - id: q_u38_amount
          kind: Question
          title: "What was the dollar amount?"
          precondition:
            - predicate: q_u38.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # U39: Government income
        # Radio for no income / don't know, Editbox for amount.
        # Modeled as Radio first, then conditional Editbox.
        - id: q_u39
          kind: Question
          title: "What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security?"
          input:
            control: Radio
            labels:
              1: "Had government income"
              2: "No income from government"
              3: "Don't know"

        # U39_amount: Dollar amount of government income
        # Pre: U39 == 1
        - id: q_u39_amount
          kind: Question
          title: "What was the dollar amount from government sources?"
          precondition:
            - predicate: q_u39.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # U40: Investment or private pension income
        - id: q_u40
          kind: Question
          title: "What was your income from investments or private pensions?"
          input:
            control: Radio
            labels:
              1: "Income"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        # U40_amount: Dollar amount of investment income
        # Pre: U40 in [1, 2]
        - id: q_u40_amount
          kind: Question
          title: "What was the dollar amount from investments or private pensions?"
          precondition:
            - predicate: q_u40.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # U41: Total household income bracket
        # Original uses cascading binary tree of yes/no sub-questions to arrive
        # at one of 11 final brackets. Simplified to a single Dropdown listing
        # all final brackets.
        - id: q_u41
          kind: Question
          title: "What is your best estimate of the total income of all household members from all sources during the last 12 months?"
          input:
            control: Dropdown
            labels:
              1: "No income"
              2: "Less than $5,000"
              3: "$5,000 to $9,999"
              4: "$10,000 to $14,999"
              5: "$15,000 to $19,999"
              6: "$20,000 to $29,999"
              7: "$30,000 to $39,999"
              8: "$40,000 to $59,999"
              9: "$60,000 or more"
              10: "Don't know"
