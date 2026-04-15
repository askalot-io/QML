qmlVersion: "1.0"
questionnaire:
  title: "Survey of Household Spending 2000"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    one_person_hh = 0
    total_weeks = 0
    data_code = 0
    moved_in_2000 = 0
    moved_before_1995 = 0
    prev_owned = 0
    has_vehicle = 0
    has_rec_vehicle = 0
    has_package_trip = 0
    has_direct_sales = 0
    has_business = 0
    has_loans = 0

  blocks:

    # ===================================================================
    # SECTION: household_composition
    # ===================================================================
    # =========================================================================
    # BLOCK: HOUSEHOLD COMPOSITION ROSTER
    # =========================================================================
    # Section A asks Q1-Q12 for each household member (up to 10 persons).
    # QML cannot model dynamic loops, so this file represents the structure
    # for ONE representative person. In a real deployment, this block would
    # repeat for each household member up to Person 10.
    # Person 01 is pre-coded as the household reference person (A_Q02=1).
    # =========================================================================
    - id: b_household_composition
      title: "Household Composition"
      items:
        # A_Q01: Roster instruction
        - id: q_a_q01
          kind: Comment
          title: "What are the first names of all members of your household? Include everyone who currently lives here and anyone who was part of your household at any time during 2000. List the household reference person first. (This roster repeats for up to 10 persons.)"

        # A_Q02: Relationship to reference person
        - id: q_a_q02
          kind: Question
          title: "What is this person's relationship to the household reference person?"
          input:
            control: Radio
            labels:
              1: "Reference Person"
              2: "Spouse"
              3: "Son/Daughter"
              4: "Other relative"
              5: "Not related"

        # A_Q03: Birth year
        - id: q_a_q03
          kind: Question
          title: "In what year was this person born? (If born in 1900 or earlier, enter 1900)"
          input:
            control: Editbox
            min: 1900
            max: 2001

        # A_Q04: Sex
        - id: q_a_q04
          kind: Question
          title: "Is this person male or female?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # A_Q05: Marital status on December 31, 2000
        - id: q_a_q05
          kind: Question
          title: "What was this person's marital status on December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Married spouse of a household member"
              2: "Common-law spouse of a household member"
              3: "Never married (single)"
              4: "Other (separated, divorced or widowed)"

        # A_Q06: Economic family code
        - id: q_a_q06
          kind: Question
          title: "Economic Family Code (at time of interview or last day the person was a member of the household). Enter a letter code."
          input:
            control: Textarea
            placeholder: "Enter economic family code..."

        # A_Q07: Member on December 31, 2000
        - id: q_a_q07
          kind: Question
          title: "Was this person a member of this household on December 31, 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A_Q08: Member today
        - id: q_a_q08
          kind: Question
          title: "Is this person a member of this household today?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A_Q09: Weeks as member in 2000
        # Routing: if one-person household -> Q11; if Q09=52 -> Q12; else -> Q10
        - id: q_a_q09
          kind: Question
          title: "For how many weeks in 2000 was this person a member of this household?"
          input:
            control: Editbox
            min: 0
            max: 52
          codeBlock: |
            total_weeks = q_a_q09.outcome

        # A_Q10: Weeks apart in 2000
        # Precondition: not a one-person household AND Q09 < 52
        - id: q_a_q10
          kind: Question
          title: "For how many weeks in 2000 did this person live apart from this household, either as a one-person household, or in another household that no longer exists elsewhere?"
          precondition:
            - predicate: one_person_hh == 0
            - predicate: q_a_q09.outcome < 52
          input:
            control: Editbox
            min: 0
            max: 52
          codeBlock: |
            total_weeks = q_a_q09.outcome + q_a_q10.outcome

        # A_Q11: Why total weeks < 52
        # Precondition: total_weeks < 52 AND not skipped by one-person household
        - id: q_a_q11
          kind: Question
          title: "Why is total weeks (Q.9 plus Q.10) less than 52?"
          precondition:
            - predicate: total_weeks < 52
          input:
            control: Radio
            labels:
              1: "Child born in 2000 or 2001"
              2: "Immigrated in 2000 or 2001"
              3: "Belonged to a household in existence elsewhere"
              4: "Other - Explain in notes"

        # A_Q12: Data collection code
        # Derived from Q08, Q09, Q10
        - id: q_a_q12
          kind: Question
          title: "Use questions 8, 9 and 10 to determine the data collection code and the procedure to follow for each person."
          input:
            control: Radio
            labels:
              1: "Report data for total weeks (Q8=Yes, Q9 not 00)"
              2: "Report data for weeks in this household only (Q8=No, Q9 not 00)"
              3: "Report data for weeks apart only (Q8=Yes, Q9=00, Q10 not 00)"
              4: "End questions - member after 2000 (Q8=Yes, Q9=00, Q10=00)"
              5: "End questions - not a member (Q8=No, Q9=00, Q10=00)"

    # ===================================================================
    # SECTION: dwelling_facilities
    # ===================================================================
    # =========================================================================
    # BLOCK: DWELLING CHARACTERISTICS (Section B)
    # =========================================================================
    # B_Q01-B_Q11: dwelling type, age, repairs, rooms, heating, fuel.
    # "Other (Specify)" follow-ups for B_Q01, B_Q07, B_Q09, B_Q10, B_Q11.
    # =========================================================================
    - id: b_dwelling
      title: "Dwelling Characteristics"
      items:
        # B_Q01: Dwelling type
        - id: q_b_q01
          kind: Question
          title: "What type of dwelling did your household live in on December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Single detached"
              2: "Double"
              3: "Row or terrace"
              4: "Duplex"
              5: "Apartment less than 5 storeys"
              6: "Apartment 5 or more storeys"
              7: "Hotel/rooming/lodging house/camp"
              8: "Mobile home"
              9: "Other (Specify)"

        # B_Q01 specify
        - id: q_b_q01_specify
          kind: Question
          title: "Please specify the other dwelling type."
          precondition:
            - predicate: q_b_q01.outcome == 9
          input:
            control: Textarea
            placeholder: "Specify dwelling type..."

        # B_Q02: Year built
        - id: q_b_q02
          kind: Question
          title: "When was this dwelling originally built?"
          input:
            control: Radio
            labels:
              1: "1920 or before"
              2: "1921-1945"
              3: "1946-1960"
              4: "1961-1970"
              5: "1971-1980"
              6: "1981-1990"
              7: "1991-1999"
              8: "2000"

        # B_Q03: Repairs needed
        - id: q_b_q03
          kind: Question
          title: "Was this dwelling in need of any repairs on December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Yes, major repairs"
              2: "Yes, minor repairs"
              3: "No, only regular maintenance"

        # B_Q04: Number of rooms
        - id: q_b_q04
          kind: Question
          title: "How many rooms were there in this dwelling?"
          input:
            control: Editbox
            min: 1
            max: 99

        # B_Q05: Number of bedrooms
        - id: q_b_q05
          kind: Question
          title: "How many bedrooms were there in this dwelling? (If bachelor apartment, enter 0)"
          input:
            control: Editbox
            min: 0
            max: 99

        # B_Q06: Number of bathrooms
        - id: q_b_q06
          kind: Question
          title: "How many bathrooms with a bathtub or shower were there in this dwelling?"
          input:
            control: Editbox
            min: 0
            max: 99

        # B_Q07: Principal heating equipment
        - id: q_b_q07
          kind: Question
          title: "What was the principal heating equipment for this dwelling?"
          input:
            control: Radio
            labels:
              1: "Steam/hot water furnace"
              2: "Forced hot air furnace"
              3: "Other hot air furnace"
              4: "Heating stove (incl. wood)"
              5: "Electric heating (incl. baseboard)"
              6: "Cookstove"
              7: "Other (Specify)"

        # B_Q07 specify
        - id: q_b_q07_specify
          kind: Question
          title: "Please specify the other heating equipment."
          precondition:
            - predicate: q_b_q07.outcome == 7
          input:
            control: Textarea
            placeholder: "Specify heating equipment..."

        # B_Q08: Heating equipment age
        - id: q_b_q08
          kind: Question
          title: "How old was this heating equipment?"
          input:
            control: Radio
            labels:
              1: "5 years or less (1995-2000)"
              2: "6-10 years (1990-1994)"
              3: "11-15 years (1985-1989)"
              4: "16-20 years (1980-1984)"
              5: "Over 20 years (before 1980)"

        # B_Q09: Principal heating fuel
        - id: q_b_q09
          kind: Question
          title: "What was the principal fuel for this heating equipment?"
          input:
            control: Radio
            labels:
              1: "Oil/liquid fuel"
              2: "Piped gas (natural gas)"
              3: "Bottled gas (propane)"
              4: "Electricity"
              5: "Wood"
              6: "Other (Specify)"

        # B_Q09 specify
        - id: q_b_q09_specify
          kind: Question
          title: "Please specify the other heating fuel."
          precondition:
            - predicate: q_b_q09.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify heating fuel..."

        # B_Q10: Hot water fuel
        - id: q_b_q10
          kind: Question
          title: "What was the principal fuel for the hot water supply?"
          input:
            control: Radio
            labels:
              1: "Oil/liquid fuel"
              2: "Piped gas"
              3: "Bottled gas"
              4: "Electricity"
              5: "Wood"
              6: "Other (Specify)"
              7: "No running hot water"

        # B_Q10 specify
        - id: q_b_q10_specify
          kind: Question
          title: "Please specify the other hot water fuel."
          precondition:
            - predicate: q_b_q10.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify hot water fuel..."

        # B_Q11: Cooking fuel
        - id: q_b_q11
          kind: Question
          title: "What was the main fuel used for cooking?"
          input:
            control: Radio
            labels:
              1: "Oil/liquid fuel"
              2: "Piped gas"
              3: "Bottled gas"
              4: "Electricity"
              5: "Wood"
              6: "Other (Specify)"

        # B_Q11 specify
        - id: q_b_q11_specify
          kind: Question
          title: "Please specify the other cooking fuel."
          precondition:
            - predicate: q_b_q11.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify cooking fuel..."

    # =========================================================================
    # BLOCK: FACILITIES ASSOCIATED WITH THE DWELLING (Section C)
    # =========================================================================
    # C_Q01-C_Q17: equipment counts and yes/no facilities.
    # C_Q05 gated on C_Q04 > 0 (telephone count).
    # C_Q12 gated on C_Q11=Yes (home computer).
    # C_Q13 gated on C_Q12=Yes (modem).
    # =========================================================================
    - id: b_facilities
      title: "Facilities Associated with the Dwelling"
      items:
        # C_Q01: Refrigerators
        - id: q_c_q01
          kind: Question
          title: "How many refrigerators?"
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q02: Colour TVs
        - id: q_c_q02
          kind: Question
          title: "How many colour TV sets?"
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q03: VCRs
        - id: q_c_q03
          kind: Question
          title: "How many VCRs?"
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q04: Telephones (excluding cellular)
        - id: q_c_q04
          kind: Question
          title: "How many telephones? (Include business phones, exclude cellular)"
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q05: Telephone numbers (gated on having telephones)
        - id: q_c_q05
          kind: Question
          title: "How many telephone numbers for this dwelling?"
          precondition:
            - predicate: q_c_q04.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q06: Cellular phone
        - id: q_c_q06
          kind: Question
          title: "Did you have a cellular phone for personal use?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q07: Microwave oven
        - id: q_c_q07
          kind: Question
          title: "Did you have a microwave oven?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q08: Separate freezer
        - id: q_c_q08
          kind: Question
          title: "Did you have a freezer separate from the refrigerator?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q09: Cable TV
        - id: q_c_q09
          kind: Question
          title: "Did you have cable TV?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q10: CD player
        - id: q_c_q10
          kind: Question
          title: "Did you have a CD player?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q11: Home computer
        - id: q_c_q11
          kind: Question
          title: "Did you have a home computer? (Exclude business-only)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q12: Modem (gated on having home computer)
        - id: q_c_q12
          kind: Question
          title: "Did you have a modem?"
          precondition:
            - predicate: q_c_q11.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q13: Internet from home (gated on having modem)
        - id: q_c_q13
          kind: Question
          title: "Did you use the Internet from home?"
          precondition:
            - predicate: q_c_q12.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q14: Air conditioning
        - id: q_c_q14
          kind: Question
          title: "Did you have air conditioning?"
          input:
            control: Radio
            labels:
              1: "Window-type"
              2: "Central"
              3: "None"

        # C_Q15: Dishwasher
        - id: q_c_q15
          kind: Question
          title: "Did you have a dishwasher?"
          input:
            control: Radio
            labels:
              1: "Built-in automatic"
              2: "Portable automatic"
              3: "None"

        # C_Q16: Washing machine
        - id: q_c_q16
          kind: Question
          title: "Did you have a washing machine (inside dwelling)?"
          input:
            control: Radio
            labels:
              1: "Automatic"
              2: "Other kind"
              3: "None"

        # C_Q17: Clothes dryer
        - id: q_c_q17
          kind: Question
          title: "Did you have a clothes dryer (inside dwelling)?"
          input:
            control: Radio
            labels:
              1: "Electric"
              2: "Gas"
              3: "None"

    # ===================================================================
    # SECTION: tenure
    # ===================================================================
    # =========================================================================
    # BLOCK: TENURE AND PREVIOUS DWELLING (Section D)
    # =========================================================================
    # D_Q01: tenure type, D_Q02: year moved, D_Q03-Q04: previous dwelling,
    # D_Q05-Q05.1: 52-week check, D_Q06.1-Q06.4: previous dwelling types,
    # D_Q07.1-Q07.4: disposition of previously owned dwellings.
    #
    # Key routing:
    #   D_Q02 < 1995 -> skip D_Q03 onward (go to Section E instructions)
    #   D_Q04 gated on has_spouse
    #   D_Q05 gated on moved_in_2000
    #   D_Q06.x gated on D_Q05=Yes or D_Q05.1=Yes
    #   D_Q07.x gated on D_Q06.1=Yes or D_Q06.2=Yes (previously owned)
    # =========================================================================
    - id: b_tenure
      title: "Tenure"
      items:
        # D_Q01: Dwelling tenure status
        - id: q_d_q01
          kind: Question
          title: "On December 31, 2000 was your dwelling:"
          input:
            control: Radio
            labels:
              1: "Owned without mortgage"
              2: "Owned with mortgage(s)"
              3: "Rented"
              4: "Occupied rent-free"

        # D_Q02: Year moved to this dwelling
        - id: q_d_q02
          kind: Question
          title: "In what year did your household move to this dwelling?"
          input:
            control: Editbox
            min: 1900
            max: 2001
          codeBlock: |
            if q_d_q02.outcome < 1995:
                moved_before_1995 = 1
            if q_d_q02.outcome == 2000:
                moved_in_2000 = 1

        # D_Q03: Reference person's previous dwelling
        # Skipped if moved before 1995
        - id: q_d_q03
          kind: Question
          title: "Did the reference person own or rent their previous dwelling?"
          precondition:
            - predicate: moved_before_1995 == 0
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"
              3: "Did not maintain their own dwelling"

        # D_Q04: Spouse's previous dwelling
        # Gated on having a spouse AND not moved before 1995
        - id: q_d_q04
          kind: Question
          title: "Did the spouse of the reference person own or rent their previous dwelling?"
          precondition:
            - predicate: moved_before_1995 == 0
            - predicate: has_spouse == 1
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"
              3: "Did not maintain their own dwelling"

        # D_Q05: 52-week check
        # Gated on moved in 2000
        - id: q_d_q05
          kind: Question
          title: "Did anyone in this household report TOTAL WEEKS equal to 52? (Section A, Q.9 plus Q.10)"
          precondition:
            - predicate: moved_in_2000 == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q05.1: Lived in another dwelling
        # Gated on D_Q05 = No
        - id: q_d_q05_1
          kind: Question
          title: "For the total weeks reported earlier, did anyone live in another dwelling?"
          precondition:
            - predicate: q_d_q05.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q06.1: Previously owned with mortgage
        # Gated on D_Q05=Yes OR D_Q05.1=Yes
        - id: q_d_q06_1
          kind: Question
          title: "Were any previously occupied dwellings in 2000: Owned with mortgage(s)?"
          precondition:
            - predicate: q_d_q05.outcome == 1 or q_d_q05_1.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q06.2: Previously owned without mortgage
        - id: q_d_q06_2
          kind: Question
          title: "Were any previously occupied dwellings in 2000: Owned without a mortgage?"
          precondition:
            - predicate: q_d_q05.outcome == 1 or q_d_q05_1.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q06.3: Previously rented
        - id: q_d_q06_3
          kind: Question
          title: "Were any previously occupied dwellings in 2000: Rented?"
          precondition:
            - predicate: q_d_q05.outcome == 1 or q_d_q05_1.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q06.4: Previously occupied rent-free
        - id: q_d_q06_4
          kind: Question
          title: "Were any previously occupied dwellings in 2000: Occupied rent-free?"
          precondition:
            - predicate: q_d_q05.outcome == 1 or q_d_q05_1.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.1: Previously owned dwelling - Sold?
        # Gated on D_Q06.1=Yes OR D_Q06.2=Yes
        - id: q_d_q07_1
          kind: Question
          title: "Were any previously owned dwellings in 2000: Sold?"
          precondition:
            - predicate: q_d_q06_1.outcome == 1 or q_d_q06_2.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.2: Rented to others
        - id: q_d_q07_2
          kind: Question
          title: "Were any previously owned dwellings in 2000: Rented to others?"
          precondition:
            - predicate: q_d_q06_1.outcome == 1 or q_d_q06_2.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.3: Left vacant
        - id: q_d_q07_3
          kind: Question
          title: "Were any previously owned dwellings in 2000: Left vacant?"
          precondition:
            - predicate: q_d_q06_1.outcome == 1 or q_d_q06_2.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.4: Other disposition
        - id: q_d_q07_4
          kind: Question
          title: "Were any previously owned dwellings in 2000: Other?"
          precondition:
            - predicate: q_d_q06_1.outcome == 1 or q_d_q06_2.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # D_Q07.4 specify
        - id: q_d_q07_4_specify
          kind: Question
          title: "Please specify the other disposition."
          precondition:
            - predicate: q_d_q07_4.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify other disposition..."

        # D_INSTRUCTIONS: Read instructions for expenditure questions
        - id: q_d_instructions
          kind: Comment
          title: "Instructions for the Expenditure Questions: Report expenditures for part-year members according to the data collection code. Follow expenditure reporting rules and insurance settlement guidelines."

    # ===================================================================
    # SECTION: owned_residences
    # ===================================================================
    # =========================================================================
    # BLOCK: OWNED PRINCIPAL RESIDENCES (Section E)
    # =========================================================================
    # E_Q01: how many owned, E_Q02: months occupied, E_Q03.x: taxes/insurance/
    # condo, E_Q04-Q04.1: business charge, E_Q05-Q05.1.2: rooms rented.
    # If E_Q01 = 0 -> skip to Section I (rented residences).
    # =========================================================================
    - id: b_owned_residences
      title: "Owned Principal Residences"
      items:
        # E_Q01: Number of dwellings owned and occupied
        - id: q_e_q01
          kind: Question
          title: "How many dwellings did members of your household own and occupy in 2000? (If none, enter 0 and skip to Section I.)"
          input:
            control: Editbox
            min: 0
            max: 99

        # E_Q02: Months owned and occupied
        - id: q_e_q02
          kind: Question
          title: "For how many months in 2000 did your household own and occupy the dwelling(s)?"
          precondition:
            - predicate: q_e_q01.outcome > 0
          input:
            control: Editbox
            min: 1
            max: 12

        # E_Q03.1: Property taxes
        - id: q_e_q03_1
          kind: Question
          title: "Total amount billed for property taxes in 2000?"
          precondition:
            - predicate: q_e_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # E_Q03.2: Homeowners insurance
        - id: q_e_q03_2
          kind: Question
          title: "Total premiums paid in 2000 for homeowners' insurance (fire, theft, perils)?"
          precondition:
            - predicate: q_e_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # E_Q03.3: Condominium charges
        - id: q_e_q03_3
          kind: Question
          title: "Amount paid for condominium charges? (Include special levies)"
          precondition:
            - predicate: q_e_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # E_Q04: Business charge
        - id: q_e_q04
          kind: Question
          title: "Were any of these expenses charged against income from businesses?"
          precondition:
            - predicate: q_e_q01.outcome > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # E_Q04.1: Business charge amount
        - id: q_e_q04_1
          kind: Question
          title: "What amount was charged against business income?"
          precondition:
            - predicate: q_e_q04.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # E_Q05: Rooms rented
        - id: q_e_q05
          kind: Question
          title: "Were any of these expenses charged against income from rooms rented out?"
          precondition:
            - predicate: q_e_q01.outcome > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # E_Q05.1.1: Amount from rooms rented to household members
        - id: q_e_q05_1_1
          kind: Question
          title: "Amount from rooms rented to household members (excl. relatives)?"
          precondition:
            - predicate: q_e_q05.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # E_Q05.1.2: Amount from rooms rented to non-members
        - id: q_e_q05_1_2
          kind: Question
          title: "Amount from rooms rented to non-members?"
          precondition:
            - predicate: q_e_q05.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: PURCHASE AND SALE OF HOMES (Section F)
    # =========================================================================
    # F_Q01-Q01.3: home purchase, F_Q02-Q02.2: home sale,
    # F_Q03-Q04: legal and other expenses.
    # Entire block gated on owning at least one dwelling.
    # =========================================================================
    - id: b_home_purchase_sale
      title: "Purchase and Sale of Homes"
      precondition:
        - predicate: q_e_q01.outcome > 0
      items:
        # F_Q01: Purchased a home?
        - id: q_f_q01
          kind: Question
          title: "Did your household purchase a home in 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # F_Q01.1: First-time buyer
        - id: q_f_q01_1
          kind: Question
          title: "Was this purchase by person(s) who never previously owned an occupied dwelling?"
          precondition:
            - predicate: q_f_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # F_Q01.2: Purchase price
        - id: q_f_q01_2
          kind: Question
          title: "What was the purchase price?"
          precondition:
            - predicate: q_f_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # F_Q01.3: Land transfer taxes and registration fees
        - id: q_f_q01_3
          kind: Question
          title: "How much for land transfer taxes and registration fees?"
          precondition:
            - predicate: q_f_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # F_Q02: Sold a home?
        - id: q_f_q02
          kind: Question
          title: "Did your household sell a home in 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # F_Q02.1: Selling price
        - id: q_f_q02_1
          kind: Question
          title: "What was the selling price?"
          precondition:
            - predicate: q_f_q02.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # F_Q02.2: Real estate commissions
        - id: q_f_q02_2
          kind: Question
          title: "How much for real estate commissions?"
          precondition:
            - predicate: q_f_q02.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # F_Q03: Legal charges
        - id: q_f_q03
          kind: Question
          title: "How much spent on legal charges related to dwelling(s)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # F_Q04: Other dwelling expenses
        - id: q_f_q04
          kind: Question
          title: "How much spent on other dwelling-related expenses (surveying, appraisals, mortgage fees)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # F_Q04 specify
        - id: q_f_q04_specify
          kind: Question
          title: "Specify other expenses."
          input:
            control: Textarea
            placeholder: "Specify other dwelling expenses..."

    # ===================================================================
    # SECTION: mortgages_renovations
    # ===================================================================
    # =========================================================================
    # BLOCK: MORTGAGES ON OWNED PRINCIPAL RESIDENCES (Section G)
    # =========================================================================
    # G_Q01: have mortgages, G_Q02.1-Q02.2: payment rosters (up to 3),
    # G_Q03.1-Q03.3: mortgage includes taxes/insurance, G_Q04-Q04.1d: amounts
    # added to mortgage.
    # Entire block gated on owning at least one dwelling.
    # =========================================================================
    - id: b_mortgages
      title: "Mortgages on Owned Principal Residences"
      precondition:
        - predicate: num_dwellings_owned > 0
      items:
        # G_Q01: Have mortgages?
        - id: q_g_q01
          kind: Question
          title: "In 2000, did your household have any mortgages on dwellings it owned and occupied?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G_Q02.1: Regular mortgage payments (up to 3 mortgages)
        - id: qg_g_q02_1
          kind: QuestionGroup
          title: "Regular mortgage payments in 2000? (Amount per payment period for each mortgage)"
          precondition:
            - predicate: q_g_q01.outcome == 1
          questions:
            - "Mortgage 1 - Amount"
            - "Mortgage 2 - Amount"
            - "Mortgage 3 - Amount"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # G_Q02.2: Irregular and lump sum payments (up to 3 mortgages)
        - id: qg_g_q02_2
          kind: QuestionGroup
          title: "Irregular and lump sum payments including payments to close mortgage?"
          precondition:
            - predicate: q_g_q01.outcome == 1
          questions:
            - "Mortgage 1 - Lump sum"
            - "Mortgage 2 - Lump sum"
            - "Mortgage 3 - Lump sum"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # G_Q03.1: Did mortgage payments include property taxes?
        - id: q_g_q03_1
          kind: Question
          title: "Did mortgage payments include property taxes?"
          precondition:
            - predicate: q_g_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G_Q03.2: Did mortgage payments include mortgage life/disability insurance?
        - id: q_g_q03_2
          kind: Question
          title: "Did mortgage payments include mortgage life/disability insurance?"
          precondition:
            - predicate: q_g_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G_Q03.3: Total premium for mortgage life/disability insurance
        - id: q_g_q03_3
          kind: Question
          title: "Total premium paid for mortgage life/disability insurance in 2000?"
          precondition:
            - predicate: q_g_q03_2.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # G_Q04: Amounts added to mortgage
        - id: q_g_q04
          kind: Question
          title: "Were any amounts added to your mortgage(s) in 2000?"
          precondition:
            - predicate: q_g_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G_Q04.1a-d: Amounts added (up to 4)
        - id: qg_g_q04_1
          kind: QuestionGroup
          title: "Amounts added to mortgage(s):"
          precondition:
            - predicate: q_g_q04.outcome == 1
          questions:
            - "Amount added (first)"
            - "Amount added (second)"
            - "Amount added (third)"
            - "Amount added (fourth)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: RENOVATIONS AND REPAIRS (Section H)
    # =========================================================================
    # H_Q01-Q03: additions/renovations, installations, repairs/maintenance.
    # Each is a roster of up to 3 entries with specify + cost.
    # Entire block gated on owning at least one dwelling.
    # =========================================================================
    - id: b_renovations
      title: "Renovations and Repairs of Owned Principal Residences"
      precondition:
        - predicate: num_dwellings_owned > 0
      items:
        # H_Q01: Additions, renovations and other alterations
        - id: qg_h_q01
          kind: QuestionGroup
          title: "How much spent on additions, renovations and other alterations? (Up to 3 entries)"
          questions:
            - "Entry 1 - Total cost"
            - "Entry 2 - Total cost"
            - "Entry 3 - Total cost"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # H_Q01 specify
        - id: q_h_q01_specify
          kind: Question
          title: "Specify the additions, renovations or alterations."
          input:
            control: Textarea
            placeholder: "Describe renovation work..."

        # H_Q02: Installations of equipment, appliances and fixtures
        - id: qg_h_q02
          kind: QuestionGroup
          title: "How much spent on installations of built-in equipment, appliances and fixtures? (Up to 3 entries: replacement cost and new installation cost)"
          questions:
            - "Entry 1 - Replacement cost"
            - "Entry 1 - New installation cost"
            - "Entry 2 - Replacement cost"
            - "Entry 2 - New installation cost"
            - "Entry 3 - Replacement cost"
            - "Entry 3 - New installation cost"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # H_Q02 specify
        - id: q_h_q02_specify
          kind: Question
          title: "Specify the installations."
          input:
            control: Textarea
            placeholder: "Describe installation work..."

        # H_Q03: Repairs and maintenance
        - id: qg_h_q03
          kind: QuestionGroup
          title: "How much spent on repairs and maintenance? (Up to 3 entries)"
          questions:
            - "Entry 1 - Total cost"
            - "Entry 2 - Total cost"
            - "Entry 3 - Total cost"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # H_Q03 specify
        - id: q_h_q03_specify
          kind: Question
          title: "Specify the repairs and maintenance."
          input:
            control: Textarea
            placeholder: "Describe repair work..."

    # ===================================================================
    # SECTION: rented_residences
    # ===================================================================
    # =========================================================================
    # BLOCK: RENTED PRINCIPAL RESIDENCES (Section I)
    # =========================================================================
    # I_Q01: months rented, I_Q02: total rent paid, I_Q03-Q06: additional
    # amounts, I_Q07-Q07.1: business charge, I_Q08-Q08.1.2: rooms rented.
    # If I_Q01 = 0 -> skip to Section J.
    # =========================================================================
    - id: b_rented_residences
      title: "Rented Principal Residences"
      items:
        # I_Q01: Months rented in 2000
        - id: q_i_q01
          kind: Question
          title: "For how many months in 2000 did your household occupy a rented dwelling? (If none, enter 0 to skip to Section J.)"
          input:
            control: Editbox
            min: 0
            max: 12

        # I_Q02: Total rent paid
        - id: q_i_q02
          kind: Question
          title: "Enter total rent paid in 2000."
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q03: Additional amount paid to landlord
        - id: q_i_q03
          kind: Question
          title: "Additional amount paid to landlord not included in rent (e.g., security deposits)?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q04: Rent returned
        - id: q_i_q04
          kind: Question
          title: "How much rent was returned to your household (e.g., overpayment, damage deposit)?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q05: Reduced rent
        - id: q_i_q05
          kind: Question
          title: "Did your household pay reduced rent?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Radio
            labels:
              1: "Government subsidized housing"
              2: "Other reasons (services to landlord, company housing)"
              3: "No reduced rent"

        # I_Q06.1: Additions, renovations, repairs for rented dwelling
        - id: q_i_q06_1
          kind: Question
          title: "Additions, renovations, repairs for rented dwelling(s)?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q06.2: Tenants insurance
        - id: q_i_q06_2
          kind: Question
          title: "Tenants' insurance?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q06.3: Parking at place of residence
        - id: q_i_q06_3
          kind: Question
          title: "Parking at place of residence?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q07: Business charge on rent
        - id: q_i_q07
          kind: Question
          title: "Was any part of rent charged against business income?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # I_Q07.1: Business charge amount
        - id: q_i_q07_1
          kind: Question
          title: "Amount charged against business income?"
          precondition:
            - predicate: q_i_q07.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q08: Rooms rented to others
        - id: q_i_q08
          kind: Question
          title: "Was any part of rent charged against income from rooms rented to others?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # I_Q08.1.1: Amount from rooms rented to household members
        - id: q_i_q08_1_1
          kind: Question
          title: "Amount from rooms rented to household members (excl. relatives)?"
          precondition:
            - predicate: q_i_q08.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q08.1.2: Amount from rooms rented to non-members
        - id: q_i_q08_1_2
          kind: Question
          title: "Amount from rooms rented to non-members?"
          precondition:
            - predicate: q_i_q08.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: utilities_accommodation
    # ===================================================================
    # =========================================================================
    # BLOCK: UTILITIES AND ACCOMMODATION
    # =========================================================================
    # J_Q01.1-Q01.4: Utility expenses (water, electricity, fuel, heating rental)
    # J_Q02.1-Q02.3: Travel accommodation expenses
    # J_NOTE: Interviewer instruction about non-owned dwellings
    #
    # No routing — all items sequential.
    # Ask both owners and renters. Exclude vacation/secondary residence
    # expenses (reported in Section K).
    # =========================================================================
    - id: b_utilities_accommodation
      title: "Utilities and Other Rented Accommodation"
      items:
        # J_Q01.1: Water and sewage
        - id: q_j_q01_1
          kind: Question
          title: "How much did your household spend in 2000 on water and sewage charges not included in the property tax bill?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q01.2: Electricity
        - id: q_j_q01_2
          kind: Question
          title: "How much did your household spend in 2000 on electricity?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q01.3: Other fuel
        - id: q_j_q01_3
          kind: Question
          title: "How much did your household spend in 2000 on other fuel for heating and cooking (oil, gas, propane, wood)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q01.4: Heating equipment rental
        - id: q_j_q01_4
          kind: Question
          title: "How much did your household spend in 2000 on rental of heating equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q02.1: Hotels and motels
        - id: q_j_q02_1
          kind: Question
          title: "How much did your household spend in 2000 on hotels and motels while away overnight or longer?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q02.2: Other accommodation
        - id: q_j_q02_2
          kind: Question
          title: "How much did your household spend in 2000 on other accommodation (e.g., cottage or cabin rental while away overnight or longer)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q02.3: Provincial share
        - id: q_j_q02_3
          kind: Question
          title: "Of the total accommodation amount (Q02.1 + Q02.2), how much was spent in this province?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_NOTE: Interviewer instruction
        - id: q_j_note
          kind: Comment
          title: "NOTE TO INTERVIEWER: For expenses on dwellings not owned by household members, report amounts paid for utilities, fuel, and heating equipment rental in this section. Report rent and other tenant expenses in Section I."

    # ===================================================================
    # SECTION: secondary_property
    # ===================================================================
    # =========================================================================
    # BLOCK 1: VACATION HOMES AND SECONDARY RESIDENCES
    # =========================================================================
    # K_Q01: Own vacation home? (gate for rest of block)
    # K_Q02: Purchased? K_Q02.1: Purchase price (if purchased)
    # K_Q03-Q04: Borrowing and mortgage amounts
    # K_Q05: Sold? K_Q05.1-Q05.2: Sale details (if sold)
    # K_Q06.1-Q06.6: Expenditure items (gated on K_Q01=Yes)
    # =========================================================================
    - id: b_vacation_homes
      title: "Vacation Homes and Secondary Residences"
      items:
        # K_Q01: Own vacation home?
        - id: q_k_q01
          kind: Question
          title: "In 2000, did any member of your household own a vacation home or other secondary residence?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # K_Q02: Purchased in 2000?
        - id: q_k_q02
          kind: Question
          title: "Did any member purchase a vacation home or secondary residence in 2000?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # K_Q02.1: Purchase price
        - id: q_k_q02_1
          kind: Question
          title: "What was the purchase price?"
          precondition:
            - predicate: q_k_q01.outcome == 1
            - predicate: q_k_q02.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q03: Money borrowed
        - id: q_k_q03
          kind: Question
          title: "How much money was borrowed in 2000 for expenses associated with the vacation home or secondary residence?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q04: Mortgage payments
        - id: q_k_q04
          kind: Question
          title: "How much were the mortgage payments in 2000 for the vacation home or secondary residence?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q05: Sold in 2000?
        - id: q_k_q05
          kind: Question
          title: "Was the vacation home or secondary residence sold in 2000?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # K_Q05.1: Selling price
        - id: q_k_q05_1
          kind: Question
          title: "What was the selling price?"
          precondition:
            - predicate: q_k_q01.outcome == 1
            - predicate: q_k_q05.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q05.2: Net amount received
        - id: q_k_q05_2
          kind: Question
          title: "What was the net amount received from the sale?"
          precondition:
            - predicate: q_k_q01.outcome == 1
            - predicate: q_k_q05.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q06.1: Additions, renovations and new installations
        - id: q_k_q06_1
          kind: Question
          title: "How much did your household spend in 2000 on additions, renovations and new installations for the vacation home or secondary residence?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q06.2: Repairs, maintenance and replacements
        - id: q_k_q06_2
          kind: Question
          title: "How much on repairs, maintenance and replacements?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q06.3: Property taxes and sewage
        - id: q_k_q06_3
          kind: Question
          title: "How much on property taxes and sewage charges?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q06.4: Insurance
        - id: q_k_q06_4
          kind: Question
          title: "How much on insurance?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q06.5: Electricity, water and fuel
        - id: q_k_q06_5
          kind: Question
          title: "How much on electricity, water and fuel?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q06.6: Other expenses
        - id: q_k_q06_6
          kind: Question
          title: "How much on other expenses (condominium charges, survey costs, legal fees, mortgage insurance)?"
          precondition:
            - predicate: q_k_q01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: OTHER PROPERTY
    # =========================================================================
    # K_Q07: Own other property? (gate for rest of block)
    # K_Q08: Purchased? K_Q08.1: Purchase price (if purchased)
    # K_Q09-Q12: Borrowing, mortgage, alterations, other expenses
    # K_Q13: Sold? K_Q13.1-Q13.2: Sale details (if sold)
    # =========================================================================
    - id: b_other_property
      title: "Other Property"
      items:
        # K_Q07: Own other property?
        - id: q_k_q07
          kind: Question
          title: "In 2000, did any member of your household own any other property (not including principal residence or vacation home)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # K_Q08: Purchased in 2000?
        - id: q_k_q08
          kind: Question
          title: "Did any member purchase any other property in 2000?"
          precondition:
            - predicate: q_k_q07.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # K_Q08.1: Purchase price
        - id: q_k_q08_1
          kind: Question
          title: "What was the purchase price?"
          precondition:
            - predicate: q_k_q07.outcome == 1
            - predicate: q_k_q08.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q09: Money borrowed
        - id: q_k_q09
          kind: Question
          title: "How much money was borrowed for the property?"
          precondition:
            - predicate: q_k_q07.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q10: Mortgage payments
        - id: q_k_q10
          kind: Question
          title: "How much were the mortgage payments in 2000?"
          precondition:
            - predicate: q_k_q07.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q11: Additions or major alterations
        - id: q_k_q11
          kind: Question
          title: "How much was spent on additions or major alterations (e.g., servicing of land)?"
          precondition:
            - predicate: q_k_q07.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q12: Other expenses
        - id: q_k_q12
          kind: Question
          title: "How much was spent on other expenses (property taxes, survey costs, appraisal fees, utilities)?"
          precondition:
            - predicate: q_k_q07.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q13: Property sold in 2000?
        - id: q_k_q13
          kind: Question
          title: "Was any other property sold in 2000?"
          precondition:
            - predicate: q_k_q07.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # K_Q13.1: Selling price
        - id: q_k_q13_1
          kind: Question
          title: "What was the selling price?"
          precondition:
            - predicate: q_k_q07.outcome == 1
            - predicate: q_k_q13.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # K_Q13.2: Net amount received
        - id: q_k_q13_2
          kind: Question
          title: "What was the net amount received from the sale?"
          precondition:
            - predicate: q_k_q07.outcome == 1
            - predicate: q_k_q13.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: furnishings_equipment
    # ===================================================================
    # =========================================================================
    # BLOCK 1: FURNISHINGS, ART AND ANTIQUES (L_Q01-Q08)
    # =========================================================================
    # No routing — all sequential expenditure items.
    # Include purchases for vacation homes. Include sales taxes.
    # Exclude business expenses.
    # =========================================================================
    - id: b_furnishings_art
      title: "Furnishings, Art and Antiques"
      items:
        # L_Q01: Furniture
        - id: q_l_q01
          kind: Question
          title: "How much did your household spend in 2000 on furniture for indoor or outdoor use? (Include mattresses)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q02: Mirrors and frames
        - id: q_l_q02
          kind: Question
          title: "Glass mirrors, and mirror and picture frames?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q03: Lamps
        - id: q_l_q03
          kind: Question
          title: "Lamps and lampshades?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q04: Rugs
        - id: q_l_q04
          kind: Question
          title: "Rugs, mats and underpadding?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q05: Window coverings and textiles
        - id: q_l_q05
          kind: Question
          title: "Window coverings and household textiles (curtains, blinds, bedding, towels)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q06: Art
        - id: q_l_q06
          kind: Question
          title: "Works of art, carvings and vases?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q07: Antiques
        - id: q_l_q07
          kind: Question
          title: "Antiques (100+ years old)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q08: Maintenance/repair of furniture
        - id: q_l_q08
          kind: Question
          title: "Maintenance and repair of furniture, carpeting and textiles?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: HOME ENTERTAINMENT EQUIPMENT (L_Q09-Q13)
    # =========================================================================
    # Net purchase price after trade-in.
    # =========================================================================
    - id: b_entertainment_equipment
      title: "Home Entertainment Equipment"
      items:
        # L_Q09: Audio equipment
        - id: q_l_q09
          kind: Question
          title: "Audio equipment (tape players, CD players, receivers, speakers)? (Net purchase price after trade-in)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q10: TVs, VCRs, camcorders
        - id: q_l_q10
          kind: Question
          title: "TVs, VCRs, camcorders and video components?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q11: Pre-recorded media
        - id: q_l_q11
          kind: Question
          title: "CDs, pre-recorded audiotapes, videos and videodiscs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q12: Blank media
        - id: q_l_q12
          kind: Question
          title: "Blank audio and video tapes?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q13: Other entertainment equipment
        - id: q_l_q13
          kind: Question
          title: "Other home entertainment equipment (satellite dishes, headphones, etc.)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: COMPUTER EQUIPMENT (L_Q14.1-Q16)
    # =========================================================================
    - id: b_computer_equipment
      title: "Computer Equipment"
      items:
        # L_Q14.1: Computer hardware (new)
        - id: q_l_q14_1
          kind: Question
          title: "Computer hardware purchased new?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q14.2: Computer hardware (used)
        - id: q_l_q14_2
          kind: Question
          title: "Computer hardware purchased used?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q14.3: Sale of computer hardware (Category B)
        - id: q_l_q14_3
          kind: Question
          title: "Amount received from sale of computer hardware? (Category B — deducted from total)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q15: Computer software
        - id: q_l_q15
          kind: Question
          title: "Computer software?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q16: Computer supplies
        - id: q_l_q16
          kind: Question
          title: "Computer supplies and other equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: HOME ENTERTAINMENT SERVICES (L_Q17-Q20)
    # =========================================================================
    - id: b_entertainment_services
      title: "Home Entertainment Services"
      items:
        # L_Q17: Video rentals
        - id: q_l_q17
          kind: Question
          title: "Rental of videos and videodiscs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q18: Maintenance/repair of entertainment equipment
        - id: q_l_q18
          kind: Question
          title: "Maintenance and repair of home entertainment equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q19: Cablevision/satellite
        - id: q_l_q19
          kind: Question
          title: "Rental of cablevision and satellite services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q20: Rental of entertainment equipment
        - id: q_l_q20
          kind: Question
          title: "Rental of home entertainment equipment and other services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: MAJOR HOUSEHOLD APPLIANCES (L_Q21-Q31)
    # =========================================================================
    # Net purchase price after trade-in.
    # =========================================================================
    - id: b_major_appliances
      title: "Major Household Appliances"
      items:
        # L_Q21: Refrigerators/freezers
        - id: q_l_q21
          kind: Question
          title: "Refrigerators and freezers? (Net purchase price after trade-in)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q22: Stoves/ranges
        - id: q_l_q22
          kind: Question
          title: "Cooking stoves and ranges?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q23: Microwave/convection ovens
        - id: q_l_q23
          kind: Question
          title: "Microwave and convection ovens?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q24: Washers/dryers
        - id: q_l_q24
          kind: Question
          title: "Washers and dryers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q25: Vacuum cleaners
        - id: q_l_q25
          kind: Question
          title: "Vacuum cleaners and rug cleaning equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q26: Sewing machines
        - id: q_l_q26
          kind: Question
          title: "Sewing machines?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q27: Portable dishwashers
        - id: q_l_q27
          kind: Question
          title: "Portable dishwashers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q28: Gas barbecues
        - id: q_l_q28
          kind: Question
          title: "Gas barbecues?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q29: Air conditioners, humidifiers
        - id: q_l_q29
          kind: Question
          title: "Room air conditioners, humidifiers and dehumidifiers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q30.1: Attachments and parts
        - id: q_l_q30_1
          kind: Question
          title: "Attachments and parts for major appliances?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q30.2: Maintenance/repair of appliances
        - id: q_l_q30_2
          kind: Question
          title: "Maintenance and repair of major appliances?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q31: Sale of major appliances (Category B)
        - id: q_l_q31
          kind: Question
          title: "Amount received from sale of major appliances? (Category B — deducted from total)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 6: SMALL APPLIANCES AND FOOD EQUIPMENT (L_Q32-Q36)
    # =========================================================================
    - id: b_small_appliances
      title: "Small Electrical Appliances and Food Equipment"
      items:
        # L_Q32: Electric food preparation
        - id: q_l_q32
          kind: Question
          title: "Electric food preparation appliances?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q33: Electric personal care
        - id: q_l_q33
          kind: Question
          title: "Electric hairstyling and personal care appliances?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q34: Other electric appliances
        - id: q_l_q34
          kind: Question
          title: "All other electric appliances and equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q35: Tableware
        - id: q_l_q35
          kind: Question
          title: "Tableware, flatware and knives?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q36: Non-electric kitchen equipment
        - id: q_l_q36
          kind: Question
          title: "Non-electric kitchen and cooking equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 7: TOOLS AND OTHER EQUIPMENT (L_Q37-Q47)
    # =========================================================================
    - id: b_tools_equipment
      title: "Tools, Equipment and Services"
      items:
        # L_Q37: Power lawn/garden equipment
        - id: q_l_q37
          kind: Question
          title: "Power lawn and garden equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q38: Snow blowers
        - id: q_l_q38
          kind: Question
          title: "Snow blowers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q39: Other lawn/garden/snow tools
        - id: q_l_q39
          kind: Question
          title: "Other lawn, garden and snow removal tools?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q40: Power tools
        - id: q_l_q40
          kind: Question
          title: "Power tools and equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q41: Other tools
        - id: q_l_q41
          kind: Question
          title: "Other tools?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q42: Non-electric cleaning equipment
        - id: q_l_q42
          kind: Question
          title: "Non-electric cleaning equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q43: Luggage
        - id: q_l_q43
          kind: Question
          title: "Luggage?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q44: Home security equipment
        - id: q_l_q44
          kind: Question
          title: "Home security equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q45: Other household equipment
        - id: q_l_q45
          kind: Question
          title: "Other household equipment, parts and accessories?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q46: Maintenance/repair of household equipment
        - id: q_l_q46
          kind: Question
          title: "Maintenance and repair of household equipment (not previously reported)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q47: Other furnishings/equipment services
        - id: q_l_q47
          kind: Question
          title: "Other services related to furnishings and equipment (security services, key-making, installations, rentals)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: home_operation
    # ===================================================================
    # =========================================================================
    # BLOCK 1: COMMUNICATIONS (M_Q01.1-Q01.5, M_Q02)
    # =========================================================================
    # No routing — all sequential expenditure items.
    # =========================================================================
    - id: b_communications
      title: "Communications"
      items:
        # M_Q01.1: Telephone services
        - id: q_m_q01_1
          kind: Question
          title: "How much did your household spend in 2000 on telephone services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q01.2: Cellular services
        - id: q_m_q01_2
          kind: Question
          title: "Cellular services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q01.3: Communication equipment
        - id: q_m_q01_3
          kind: Question
          title: "Purchase of communication equipment (phones, fax machines, answering machines)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q01.4: Internet services
        - id: q_m_q01_4
          kind: Question
          title: "Internet services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q01.5: Other communication charges
        - id: q_m_q01_5
          kind: Question
          title: "Other charges (wiring, installation, repairs)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q02: Postage and postal services
        - id: q_m_q02
          kind: Question
          title: "Postage stamps and postal services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: CHILD CARE (M_Q03-Q05)
    # =========================================================================
    - id: b_child_care
      title: "Child Care"
      items:
        # M_Q03: Day care centres
        - id: q_m_q03
          kind: Question
          title: "How much did your household spend in 2000 on day care centres?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q04: Other child care outside the home
        - id: q_m_q04
          kind: Question
          title: "Other child care outside the home?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q05: Child care in the home
        - id: q_m_q05
          kind: Question
          title: "Child care in the home?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: HOME AND GARDEN SERVICES (M_Q06-Q07)
    # =========================================================================
    - id: b_home_garden_services
      title: "Home and Garden Services"
      items:
        # M_Q06: Domestic help
        - id: q_m_q06
          kind: Question
          title: "How much did your household spend in 2000 on domestic help (housekeepers, cleaners, companions)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q07: Horticultural services
        - id: q_m_q07
          kind: Question
          title: "Horticultural services, snow and garbage removal?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: GARDEN SUPPLIES (M_Q08-Q10)
    # =========================================================================
    - id: b_garden_supplies
      title: "Flowers and Garden Supplies"
      items:
        # M_Q08: Nursery stock and flowers
        - id: q_m_q08
          kind: Question
          title: "How much did your household spend in 2000 on nursery stock, cut flowers, floral arrangements, decorative plants?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q09: Fertilizers
        - id: q_m_q09
          kind: Question
          title: "Fertilizers, weed controls, herbicides, soils?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q10: Insecticides
        - id: q_m_q10
          kind: Question
          title: "Insecticides, pesticides and insect repellents?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: PET EXPENSES (M_Q11-Q14)
    # =========================================================================
    - id: b_pet_expenses
      title: "Pet Expenses"
      items:
        # M_Q11: Pet food
        - id: q_m_q11
          kind: Question
          title: "How much did your household spend in 2000 on pet food?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q12: Pet purchase
        - id: q_m_q12
          kind: Question
          title: "Pet purchase?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q13: Pet related goods
        - id: q_m_q13
          kind: Question
          title: "Pet related goods?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q14: Veterinarian and kennels
        - id: q_m_q14
          kind: Question
          title: "Veterinarian services and kennels?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 6: CLEANING SUPPLIES AND HOUSEHOLD SUPPLIES (M_Q15-Q20)
    # =========================================================================
    - id: b_cleaning_supplies
      title: "Cleaning and Household Supplies"
      items:
        # M_Q15: Laundry/dry-cleaning services
        - id: q_m_q15
          kind: Question
          title: "How much did your household spend in 2000 on laundry and dry-cleaning services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q16: Coin-operated washers/dryers
        - id: q_m_q16
          kind: Question
          title: "Coin-operated washers/dryers, self-service dry-cleaning?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q17: Household cleaning supplies
        - id: q_m_q17
          kind: Question
          title: "Household cleaning supplies (detergent, cleaners, waxes, bleach, fabric softeners, drain cleaners)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q18: Stationery supplies
        - id: q_m_q18
          kind: Question
          title: "Stationery supplies (giftwrap, greeting cards, writing paper, pens, markers, binders, tape)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q19: Paper and plastic supplies
        - id: q_m_q19
          kind: Question
          title: "Other paper and plastic supplies (facial tissue, paper towels, waxed paper, napkins, foil, plastic wraps, garbage bags, disposable cutlery)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # M_Q20: Other household supplies
        - id: q_m_q20
          kind: Question
          title: "Other household supplies (light bulbs, dry cell batteries, candles, ice, road salt, adhesives, string)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: food_alcohol
    # ===================================================================
    # =========================================================================
    # BLOCK: FOOD AND ALCOHOL EXPENDITURES
    # =========================================================================
    # N_Q01-Q07.2: Food from stores, alcohol from stores, restaurant
    # meals and alcohol, board payments.
    # No routing — all sequential expenditure items.
    # =========================================================================
    - id: b_food_alcohol
      title: "Food and Alcohol"
      items:
        # N_Q01: Food and groceries
        - id: q_n_q01
          kind: Question
          title: "How much did your household spend in 2000 on food and groceries from stores (average weekly/monthly multiplied by number of periods)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q01.1: Non-food deduction
        - id: q_n_q01_1
          kind: Question
          title: "Of this amount, how much was spent on non-food items? (This will be deducted from the food total)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q02.1: Additional bulk food
        - id: q_n_q02_1
          kind: Question
          title: "Additional bulk food purchases?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q02.2: Prepared food for events
        - id: q_n_q02_2
          kind: Question
          title: "Prepared food for parties, weddings, etc.?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q02.3: Food from stores while away
        - id: q_n_q02_3
          kind: Question
          title: "Food purchased from stores while away overnight or longer?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q03: Alcohol from stores
        - id: q_n_q03
          kind: Question
          title: "Alcoholic beverages from stores?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q04: Self-made alcohol supplies
        - id: q_n_q04
          kind: Question
          title: "Supplies and fees for self-made beer, wine or liquor?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q05: Restaurant meals
        - id: q_n_q05
          kind: Question
          title: "Meals and snacks from restaurants?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q05.1: Restaurant meals — provincial share
        - id: q_n_q05_1
          kind: Question
          title: "Of the restaurant meals amount, how much was spent in this province?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q06: Restaurant alcohol
        - id: q_n_q06
          kind: Question
          title: "Alcoholic beverages from bars and restaurants?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q06.1: Restaurant alcohol — provincial share
        - id: q_n_q06_1
          kind: Question
          title: "Of the restaurant alcohol amount, how much was spent in this province?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q07.1: Board — day board and children's lunches
        - id: q_n_q07_1
          kind: Question
          title: "Board paid for day board and children's lunches?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q07.2: Board — away overnight
        - id: q_n_q07_2
          kind: Question
          title: "Board while away from home overnight or longer?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: clothing
    # ===================================================================
    # =========================================================================
    # BLOCK 1: WOMEN'S AND GIRLS' CLOTHING (O_Q01-Q04)
    # =========================================================================
    # The original questionnaire collects per-person amounts for up to 5
    # women/girls aged 4+. Since QML cannot model dynamic person loops,
    # each category is modeled as a single household-total dollar amount.
    # Interviewers should sum amounts across all persons in each category.
    # =========================================================================
    - id: b_womens_clothing
      title: "Women and Girls 4 Years and Over"
      items:
        # Explanatory comment
        - id: q_o_womens_note
          kind: Comment
          title: "Report the TOTAL household amount for each category below, summed across all women and girls aged 4 and over in the household."

        # O_Q01: Clothing
        - id: q_o_q01
          kind: Question
          title: "Clothing (outerwear, suits, dresses, skirts, slacks, sweaters, hosiery) for women and girls 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q02: Footwear
        - id: q_o_q02
          kind: Question
          title: "Footwear for women and girls 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q03: Accessories
        - id: q_o_q03
          kind: Question
          title: "Accessories (gloves, hats, purses, umbrellas) for women and girls 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q04: Jewellery and watches
        - id: q_o_q04
          kind: Question
          title: "Jewellery and watches for women and girls 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: MEN'S AND BOYS' CLOTHING (O_Q05-Q08)
    # =========================================================================
    - id: b_mens_clothing
      title: "Men and Boys 4 Years and Over"
      items:
        # Explanatory comment
        - id: q_o_mens_note
          kind: Comment
          title: "Report the TOTAL household amount for each category below, summed across all men and boys aged 4 and over in the household."

        # O_Q05: Clothing
        - id: q_o_q05
          kind: Question
          title: "Clothing (outerwear, suits, pants, shirts, sweaters, socks) for men and boys 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q06: Footwear
        - id: q_o_q06
          kind: Question
          title: "Footwear for men and boys 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q07: Accessories
        - id: q_o_q07
          kind: Question
          title: "Accessories (gloves, hats, ties, belts, wallets) for men and boys 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q08: Jewellery and watches
        - id: q_o_q08
          kind: Question
          title: "Jewellery and watches for men and boys 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: CHILDREN'S CLOTHING (O_Q09-Q11)
    # =========================================================================
    - id: b_childrens_clothing
      title: "Children Under 4 Years"
      items:
        # Explanatory comment
        - id: q_o_childrens_note
          kind: Comment
          title: "Report the TOTAL household amount for each category below, summed across all children under 4 in the household."

        # O_Q09: Outerwear, daywear, sleepwear
        - id: q_o_q09
          kind: Question
          title: "Outerwear, daywear, sleepwear and cloth diapers for children under 4?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q10: Disposable diapers
        - id: q_o_q10
          kind: Question
          title: "Disposable diapers for children under 4?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q11: Footwear
        - id: q_o_q11
          kind: Question
          title: "Footwear for children under 4?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: CLOTHING GIFTS (O_Q12.1-Q12.3)
    # =========================================================================
    - id: b_clothing_gifts
      title: "Gifts of Clothing"
      items:
        # O_Q12.1: Gifts for women/girls
        - id: q_o_q12_1
          kind: Question
          title: "Gifts of clothing for women and girls 4+ who are not household members?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q12.2: Gifts for men/boys
        - id: q_o_q12_2
          kind: Question
          title: "Gifts of clothing for men and boys 4+ who are not household members?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q12.3: Gifts for children under 4
        - id: q_o_q12_3
          kind: Question
          title: "Gifts of clothing for children under 4 who are not household members?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: CLOTHING SERVICES (O_Q13-Q16)
    # =========================================================================
    - id: b_clothing_services
      title: "Clothing Materials and Services"
      items:
        # O_Q13: Clothing material
        - id: q_o_q13
          kind: Question
          title: "Clothing material?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q14: Notions
        - id: q_o_q14
          kind: Question
          title: "Notions (patterns, buttons, zippers, needles)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q15: Dressmaking, tailoring, storage
        - id: q_o_q15
          kind: Question
          title: "Dressmaking, tailoring, clothing storage and services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q16: Maintenance, repair and alteration
        - id: q_o_q16
          kind: Question
          title: "Maintenance, repair and alteration of clothing, footwear and watches?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: health_care
    # ===================================================================
    # =========================================================================
    # BLOCK 1: PERSONAL CARE (P_Q01-Q04)
    # =========================================================================
    # No routing — all sequential expenditure items.
    # =========================================================================
    - id: b_personal_care
      title: "Personal Care"
      items:
        # P_Q01: Hair grooming
        - id: q_p_q01
          kind: Question
          title: "How much did your household spend in 2000 on hair grooming services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q02: Other personal services
        - id: q_p_q02
          kind: Question
          title: "Other personal services (hair removal, manicures, facials)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q03: Personal care preparations
        - id: q_p_q03
          kind: Question
          title: "Personal care preparations (soap, shampoo, makeup, sunscreen)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q04: Personal care supplies and equipment
        - id: q_p_q04
          kind: Question
          title: "Personal care supplies and equipment (brushes, wigs, razors)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: HEALTH INSURANCE PREMIUMS (P_Q05.1-Q05.4)
    # =========================================================================
    - id: b_health_insurance
      title: "Health Insurance Premiums"
      items:
        # P_Q05.1: Provincial/territorial plans
        - id: q_p_q05_1
          kind: Question
          title: "How much did your household spend in 2000 on provincial/territorial hospital, medical and drug plans?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q05.2: Private health insurance
        - id: q_p_q05_2
          kind: Question
          title: "Private health insurance plans?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q05.3: Dental plans
        - id: q_p_q05_3
          kind: Question
          title: "Dental plans (separate policies)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q05.4: Accident and disability insurance
        - id: q_p_q05_4
          kind: Question
          title: "Accident and disability insurance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: DIRECT HEALTH COSTS (P_Q06-Q16)
    # =========================================================================
    - id: b_direct_health
      title: "Direct Health Costs"
      items:
        # P_Q06: Prescription eye wear
        - id: q_p_q06
          kind: Question
          title: "How much did your household spend in 2000 on prescription eye wear?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q07: Other eye care goods
        - id: q_p_q07
          kind: Question
          title: "Other eye care goods?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q08: Eye care services
        - id: q_p_q08
          kind: Question
          title: "Eye exams, eye surgery and other eye care services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q09: Dental services
        - id: q_p_q09
          kind: Question
          title: "Dental services and orthodontic/periodontal procedures?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q10: Physicians' care
        - id: q_p_q10
          kind: Question
          title: "Physicians' care?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q11: Other health care practitioners
        - id: q_p_q11
          kind: Question
          title: "Other health care practitioners?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q12: Hospital care
        - id: q_p_q12
          kind: Question
          title: "Hospital care?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q13: Other medical services
        - id: q_p_q13
          kind: Question
          title: "Weight control, quit-smoking, other medical services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q14: Prescribed medicines
        - id: q_p_q14
          kind: Question
          title: "Prescribed medicines, drugs and pharmaceuticals?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q15: OTC medicines
        - id: q_p_q15
          kind: Question
          title: "Other medicines, drugs and pharmaceuticals (over-the-counter, vitamins)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q16: Health care supplies
        - id: q_p_q16
          kind: Question
          title: "Health care supplies and goods (first aid, hearing aids, wheelchairs)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: automobiles
    # ===================================================================
    # =========================================================================
    # BLOCK 1: VEHICLE SCREENER
    # =========================================================================
    - id: b_vehicle_screener
      title: "Vehicle Ownership Screener"
      items:
        # Q_Q01: Own/lease/operate a vehicle?
        - id: q_q_q01
          kind: Question
          title: "In 2000, did anyone in your household own, lease or operate a car, van or truck for private use?"
          codeBlock: |
            if q_q_q01.outcome == 1:
                has_vehicle = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: VEHICLE DETAILS (per-vehicle grid)
    # =========================================================================
    # The original questionnaire repeats Q.2-Q.9 for up to 4 vehicles (A-D).
    # QML cannot dynamically loop, so ONE representative vehicle is modeled.
    # =========================================================================
    - id: b_vehicle_details
      title: "Vehicle Details"
      precondition:
        - predicate: has_vehicle == 1
      items:
        - id: q_q_vehicle_note
          kind: Comment
          title: "The following questions apply to each vehicle owned, leased or operated by household members. In the original paper questionnaire, questions 2-9 repeat in a grid for up to 4 vehicles (A through D). One representative vehicle is modeled here."

        # Q_Q02: Vehicle type
        - id: q_q_q02
          kind: Question
          title: "Which best describes this vehicle?"
          input:
            control: Radio
            labels:
              1: "Car"
              2: "Van/mini-van"
              3: "Truck/SUV"

        # Q_Q03: New or used
        - id: q_q_q03
          kind: Question
          title: "When this vehicle was bought or leased, was it new or used?"
          input:
            control: Radio
            labels:
              1: "New"
              2: "Used"

        # Q_Q04: Bought in 2000?
        - id: q_q_q04
          kind: Question
          title: "Did you buy this vehicle in 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q_Q05: Purchase price
        - id: q_q_q05
          kind: Question
          title: "What was the purchase price after trade-in allowance?"
          precondition:
            - predicate: q_q_q04.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q06: Leased?
        - id: q_q_q06
          kind: Question
          title: "Was this vehicle leased in 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q_Q06.1: Lease cost
        - id: q_q_q06_1
          kind: Question
          title: "What was the total leasing cost paid in 2000?"
          precondition:
            - predicate: q_q_q06.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q07: Status at Dec 31
        - id: q_q_q07
          kind: Question
          title: "What was the status of this vehicle at December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Leased"
              3: "Returned to lessor"
              4: "Sold/traded-in on lease"
              5: "Traded-in on purchase"
              6: "Owned by non-member"
              7: "Other"

        # Q_Q08: Sale amount (if sold/traded on lease)
        - id: q_q_q08
          kind: Question
          title: "If sold or traded-in on lease, what was the net amount received?"
          precondition:
            - predicate: q_q_q07.outcome == 4
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q09: Trade-in value (if traded on purchase)
        - id: q_q_q09
          kind: Question
          title: "If traded-in on purchase, what was the trade-in value?"
          precondition:
            - predicate: q_q_q07.outcome == 5
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: VEHICLE OPERATING EXPENSES
    # =========================================================================
    - id: b_vehicle_operation
      title: "Vehicle Operating Expenses"
      precondition:
        - predicate: has_vehicle == 1
      items:
        # Q_Q10: Gas and fuels
        - id: q_q_q10
          kind: Question
          title: "How much was spent on gas and other fuels?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q11: Accessories and attachments
        - id: q_q_q11
          kind: Question
          title: "How much was spent on accessories and attachments (radios, heaters, baby seats)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q12: Tires, batteries, parts
        - id: q_q_q12
          kind: Question
          title: "How much was spent on tires, batteries and other parts and supplies?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q13: Other maintenance and repair
        - id: q_q_q13
          kind: Question
          title: "How much was spent on other maintenance and repair?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q14: Registration fees
        - id: q_q_q14
          kind: Question
          title: "How much was spent on vehicle registration fees?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q15: Insurance premiums
        - id: q_q_q15
          kind: Question
          title: "How much was spent on vehicle insurance premiums?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q16: Parking costs
        - id: q_q_q16
          kind: Question
          title: "How much was spent on parking costs (work, school, park-and-ride, meters)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q17: Other operation services
        - id: q_q_q17
          kind: Question
          title: "How much was spent on other operation services (auto association, towing, tolls)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q18: Business percentage
        - id: q_q_q18
          kind: Question
          title: "What amount or percentage of operating expenses was charged to business?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q19: Insurance repairs
        - id: q_q_q19
          kind: Question
          title: "What was the value of repair jobs covered by insurance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: RENTED VEHICLES
    # =========================================================================
    - id: b_rented_vehicles
      title: "Rented Vehicles"
      items:
        # Q_Q20.1: Rented cars
        - id: q_q_q20_1
          kind: Question
          title: "How much was spent on rented cars (rental fees, gas, other expenses)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q20.2: Rented trucks
        - id: q_q_q20_2
          kind: Question
          title: "How much was spent on rented trucks or vans (rental fees, gas, other expenses)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q21: Licences and tests
        - id: q_q_q21
          kind: Question
          title: "How much was spent on drivers' licences and tests?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q22: Driving lessons
        - id: q_q_q22
          kind: Question
          title: "How much was spent on driving lessons?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: recreation_transport
    # ===================================================================
    # =========================================================================
    # BLOCK 1: BICYCLES
    # =========================================================================
    - id: b_bicycles
      title: "Bicycles"
      items:
        # R_Q01: Bicycle purchase
        - id: q_r_q01
          kind: Question
          title: "How much was spent on purchase of bicycles, parts and accessories?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q02: Bicycle maintenance
        - id: q_r_q02
          kind: Question
          title: "How much was spent on bicycle maintenance and repairs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: RECREATIONAL VEHICLE SCREENER
    # =========================================================================
    - id: b_rec_vehicle_screener
      title: "Recreational Vehicle Screener"
      items:
        # R_Q03: Own rec vehicle?
        - id: q_r_q03
          kind: Question
          title: "In 2000, did anyone in your household own or operate a recreational vehicle for private use? (Motorcycle, snowmobile, tent/travel trailer, truck camper, boat/canoe, outboard motor, motor home, other)"
          codeBlock: |
            if q_r_q03.outcome == 1:
                has_rec_vehicle = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 3: RECREATIONAL VEHICLE DETAILS (per-vehicle grid)
    # =========================================================================
    # The original questionnaire repeats Q.4-Q.13 for up to 4 vehicles (A-D).
    # QML cannot dynamically loop, so ONE representative vehicle is modeled.
    # =========================================================================
    - id: b_rec_vehicle_details
      title: "Recreational Vehicle Details"
      precondition:
        - predicate: has_rec_vehicle == 1
      items:
        - id: q_r_vehicle_note
          kind: Comment
          title: "The following questions apply to each recreational vehicle owned or operated by household members. In the original paper questionnaire, questions 4-13 repeat in a grid for up to 4 vehicles (A through D). One representative vehicle is modeled here."

        # R_Q04: Vehicle type
        - id: q_r_q04
          kind: Question
          title: "What type of recreational vehicle is this? (Enter code from list)"
          input:
            control: Radio
            labels:
              1: "Motorcycle"
              2: "Snowmobile"
              3: "Tent trailer"
              4: "Travel trailer"
              5: "Truck camper"
              6: "Boat/canoe"
              7: "Outboard motor"
              8: "Motor home"
              9: "Other"

        # R_Q05: Purchase price
        - id: q_r_q05
          kind: Question
          title: "If purchased in 2000, what was the price after trade-in allowance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q06: Accessories, parts for maintenance/repair
        - id: q_r_q06
          kind: Question
          title: "How much was spent on accessories and parts for maintenance and repair?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q07: Gasoline, diesel fuel
        - id: q_r_q07
          kind: Question
          title: "How much was spent on gasoline and diesel fuel?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q08: Maintenance and repair
        - id: q_r_q08
          kind: Question
          title: "How much was spent on maintenance and repair not covered by insurance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q09: Vehicle insurance premiums
        - id: q_r_q09
          kind: Question
          title: "How much was spent on vehicle insurance premiums?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q10: Registration fees and licences
        - id: q_r_q10
          kind: Question
          title: "How much was spent on registration fees and licences?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q11: Other expenses
        - id: q_r_q11
          kind: Question
          title: "How much was spent on other expenses (parking, hangar, mooring, storage)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q12: Business percentage
        - id: q_r_q12
          kind: Question
          title: "What amount or percentage of operating expenses was charged to business?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q13: Sale amount
        - id: q_r_q13
          kind: Question
          title: "If sold separately in 2000, what was the net amount received?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: RENTED RECREATIONAL VEHICLES
    # =========================================================================
    - id: b_rented_rec_vehicles
      title: "Rented Recreational Vehicles"
      items:
        # R_Q14: Rented rec vehicles
        - id: q_r_q14
          kind: Question
          title: "How much was spent on rented or leased recreational vehicles?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: TRANSPORTATION SERVICES
    # =========================================================================
    - id: b_transportation
      title: "Transportation Services"
      items:
        # R_Q15.1: City transit
        - id: q_r_q15_1
          kind: Question
          title: "How much was spent on city bus, subway, streetcar, commuter train?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.2: Taxi
        - id: q_r_q15_2
          kind: Question
          title: "How much was spent on taxi?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.3: Airplane
        - id: q_r_q15_3
          kind: Question
          title: "How much was spent on airplane?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.4: Train
        - id: q_r_q15_4
          kind: Question
          title: "How much was spent on train?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.5: Highway bus
        - id: q_r_q15_5
          kind: Question
          title: "How much was spent on highway bus?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.6: Other passenger transportation
        - id: q_r_q15_6
          kind: Question
          title: "How much was spent on other passenger transportation (ferry, sightseeing, travel insurance)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q16: Moving services
        - id: q_r_q16
          kind: Question
          title: "How much was spent on household moving, storage and delivery services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 6: PACKAGE TRIPS
    # =========================================================================
    - id: b_package_trips
      title: "Package Trips"
      items:
        # R_Q17: Package trip?
        - id: q_r_q17
          kind: Question
          title: "Did any member of your household take a package trip in 2000?"
          codeBlock: |
            if q_r_q17.outcome == 1:
                has_package_trip = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # R_Q17.1: Cost
        - id: q_r_q17_1
          kind: Question
          title: "What was the total cost of package trips?"
          precondition:
            - predicate: has_package_trip == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: recreation_education
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SPORTS AND CAMPING EQUIPMENT
    # =========================================================================
    - id: b_sports_camping
      title: "Sports and Camping Equipment"
      items:
        # S_Q01: Sports equipment
        - id: q_s_q01
          kind: Question
          title: "How much was spent on sports and athletic equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q02: Camping equipment
        - id: q_s_q02
          kind: Question
          title: "How much was spent on camping and picnic equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: PHOTOGRAPHIC
    # =========================================================================
    - id: b_photographic
      title: "Photographic"
      items:
        # S_Q03: Cameras
        - id: q_s_q03
          kind: Question
          title: "How much was spent on cameras, parts, accessories and photographic goods?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q04: Film and processing
        - id: q_s_q04
          kind: Question
          title: "How much was spent on film, processing, prints and enlargements?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q05: Photographers' services
        - id: q_s_q05
          kind: Question
          title: "How much was spent on photographers' services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: MUSIC AND RECREATION EQUIPMENT
    # =========================================================================
    - id: b_music_recreation
      title: "Music and Other Recreation Equipment"
      items:
        # S_Q06: Musical instruments
        - id: q_s_q06
          kind: Question
          title: "How much was spent on musical instruments, parts and accessories?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q07: Artists' materials
        - id: q_s_q07
          kind: Question
          title: "How much was spent on artists' materials, handicraft and hobbycraft supplies?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q08: Electronic games
        - id: q_s_q08
          kind: Question
          title: "How much was spent on electronic games and parts?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q09: Toys and games
        - id: q_s_q09
          kind: Question
          title: "How much was spent on toys and other games?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q10: Playground equipment
        - id: q_s_q10
          kind: Question
          title: "How much was spent on playground equipment and swimming pool accessories?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q11: Collectors' items
        - id: q_s_q11
          kind: Question
          title: "How much was spent on collectors' items (stamps, coins)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q12: Parts and supplies
        - id: q_s_q12
          kind: Question
          title: "How much was spent on parts and supplies for recreation equipment (camp fuels, pool chemicals, ammunition)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q13: Rental of video games
        - id: q_s_q13
          kind: Question
          title: "How much was spent on rental of video games?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q14: Rental, maintenance and repair
        - id: q_s_q14
          kind: Question
          title: "How much was spent on rental, maintenance and repair of recreation and sports equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: ADMISSIONS
    # =========================================================================
    - id: b_admissions
      title: "Admissions"
      items:
        # S_Q15.1: Movie theatres
        - id: q_s_q15_1
          kind: Question
          title: "How much was spent on admission to movie theatres?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q15.2: Live performing arts
        - id: q_s_q15_2
          kind: Question
          title: "How much was spent on admission to live performing arts (plays, concerts, festivals)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q15.3: Heritage facilities
        - id: q_s_q15_3
          kind: Question
          title: "How much was spent on admission to heritage facilities (museums, zoos, fairs, historic sites)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q15.4: Live sports events
        - id: q_s_q15_4
          kind: Question
          title: "How much was spent on admission to live sports events?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: RECREATION SERVICES
    # =========================================================================
    - id: b_recreation_services
      title: "Recreation Services"
      items:
        # S_Q16: Coin-operated and carnival games
        - id: q_s_q16
          kind: Question
          title: "How much was spent on coin-operated and carnival games?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q17: Membership fees
        - id: q_s_q17
          kind: Question
          title: "How much was spent on membership fees for sports, recreation and health clubs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q18: Single usage fees
        - id: q_s_q18
          kind: Question
          title: "How much was spent on single usage fees for sports, recreation and health clubs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q19: Children's camps
        - id: q_s_q19
          kind: Question
          title: "How much was spent on children's camps (day camps, summer camps)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q20: Other cultural/recreational services
        - id: q_s_q20
          kind: Question
          title: "How much was spent on other cultural and recreational services (fishing/hunting licences, party planning)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 6: READING MATERIALS
    # =========================================================================
    - id: b_reading
      title: "Reading Materials"
      items:
        # S_Q21: Newspapers
        - id: q_s_q21
          kind: Question
          title: "How much was spent on newspapers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q22: Magazines and periodicals
        - id: q_s_q22
          kind: Question
          title: "How much was spent on magazines and periodicals?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q23: Books and pamphlets
        - id: q_s_q23
          kind: Question
          title: "How much was spent on books and pamphlets?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q24: Maps, sheet music
        - id: q_s_q24
          kind: Question
          title: "How much was spent on maps, sheet music and other printed matter?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q25: Services
        - id: q_s_q25
          kind: Question
          title: "How much was spent on services (duplicating, library charges, book rentals, bookbinding)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 7: EDUCATION
    # =========================================================================
    - id: b_education
      title: "Education"
      items:
        # S_Q26: Elementary/secondary education (tuition, books, supplies)
        - id: qg_s_q26
          kind: QuestionGroup
          title: "How much was spent on elementary and secondary education?"
          questions:
            - "Tuition"
            - "Books"
            - "Supplies"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q27: Post-secondary education (tuition, books, supplies)
        - id: qg_s_q27
          kind: QuestionGroup
          title: "How much was spent on post-secondary education?"
          questions:
            - "Tuition"
            - "Books"
            - "Supplies"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q28: Other courses and lessons
        - id: q_s_q28
          kind: Question
          title: "How much was spent on other courses and lessons (music, dancing, sports, crafts)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q29: Other educational services
        - id: q_s_q29
          kind: Question
          title: "How much was spent on other educational services (rental of school books/equipment)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: tobacco_miscellaneous
    # ===================================================================
    # =========================================================================
    # BLOCK 1: TOBACCO
    # =========================================================================
    - id: b_tobacco
      title: "Tobacco"
      items:
        # T_Q01: Cigarettes
        - id: q_t_q01
          kind: Question
          title: "How much was spent on cigarettes, tobacco, cigars and similar products?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q02: Smokers' supplies
        - id: q_t_q02
          kind: Question
          title: "How much was spent on smokers' supplies (matches, pipes, lighters, ashtrays)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: FINANCIAL SERVICES
    # =========================================================================
    - id: b_financial_services
      title: "Financial Services"
      items:
        # T_Q03.1: Bank charges
        - id: q_t_q03_1
          kind: Question
          title: "How much was spent on service charges for banks and financial institutions?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q03.2: Commissions
        - id: q_t_q03_2
          kind: Question
          title: "How much was spent on stock and bond commissions?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q03.3: Administration fees
        - id: q_t_q03_3
          kind: Question
          title: "How much was spent on administration fees for brokers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q03.4: Other financial services
        - id: q_t_q03_4
          kind: Question
          title: "How much was spent on other financial services (planning, tax preparation, accounting)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: GAMBLING
    # =========================================================================
    # Each gambling type has expenses and winnings sub-columns.
    # =========================================================================
    - id: b_gambling
      title: "Gambling"
      items:
        # T_Q04.1: Government-run lotteries
        - id: qg_t_q04_1
          kind: QuestionGroup
          title: "Government-run lotteries:"
          questions:
            - "Expenses"
            - "Winnings"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q04.2: Bingos
        - id: qg_t_q04_2
          kind: QuestionGroup
          title: "Bingos:"
          questions:
            - "Expenses"
            - "Winnings"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q04.3: Non-government lotteries and games of chance
        - id: qg_t_q04_3
          kind: QuestionGroup
          title: "Non-government lotteries and games of chance:"
          questions:
            - "Expenses"
            - "Winnings"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q04.4: Casinos, slot machines and VLTs
        - id: qg_t_q04_4
          kind: QuestionGroup
          title: "Casinos, slot machines and VLTs:"
          questions:
            - "Expenses"
            - "Winnings"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: MISCELLANEOUS
    # =========================================================================
    - id: b_miscellaneous
      title: "Miscellaneous"
      items:
        # T_Q05: Fines and losses
        - id: q_t_q05
          kind: Question
          title: "How much was lost to deposits, fines, money lost or stolen?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q06: Clubs and organizations
        - id: q_t_q06
          kind: Question
          title: "How much was spent on contributions and dues for social clubs, co-operatives and political organizations?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q07: Tools for work
        - id: q_t_q07
          kind: Question
          title: "How much was spent on tools and equipment purchased for work (wage/salaried workers)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q08: Legal services
        - id: q_t_q08
          kind: Question
          title: "How much was spent on legal services not related to dwellings?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # T_Q09: Other goods (with specify)
        - id: q_t_q09
          kind: Question
          title: "How much was spent on other expenses for goods? (Specify below)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_t_q09_specify
          kind: Question
          title: "Please specify other goods:"
          input:
            control: Textarea
            placeholder: "Describe other goods..."

        # T_Q10: Other services (with specify)
        - id: q_t_q10
          kind: Question
          title: "How much was spent on other expenses for services (passports, funerals, hall rentals)? (Specify below)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_t_q10_specify
          kind: Question
          title: "Please specify other services:"
          input:
            control: Textarea
            placeholder: "Describe other services..."

    # =========================================================================
    # BLOCK 5: DIRECT SALES
    # =========================================================================
    - id: b_direct_sales
      title: "Direct Sales"
      items:
        # T_Q11: Direct sales screener
        - id: q_t_q11
          kind: Question
          title: "Did your household purchase goods through direct sales (door-to-door, mail order, catalogue, Internet)?"
          codeBlock: |
            if q_t_q11.outcome == 1:
                has_direct_sales = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T_Q11.1.1: Food and beverages
        - id: q_t_q11_1_1
          kind: Question
          title: "Food and beverages through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T_Q11.1.2: Books, newspapers, magazines
        - id: q_t_q11_1_2
          kind: Question
          title: "Books, newspapers and magazines through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T_Q11.1.3: Clothing, cosmetics, jewellery
        - id: q_t_q11_1_3
          kind: Question
          title: "Clothing, cosmetics and jewellery through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T_Q11.1.4: Home entertainment
        - id: q_t_q11_1_4
          kind: Question
          title: "Home entertainment products through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T_Q11.1.5: Other products inside home
        - id: q_t_q11_1_5
          kind: Question
          title: "Other products used inside the home through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T_Q11.1.6: Other products outside home
        - id: q_t_q11_1_6
          kind: Question
          title: "Other products used outside the home through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T_Q11.2: Amount spent
        - id: q_t_q11_2
          kind: Question
          title: "How much was spent on goods through direct sales?"
          precondition:
            - predicate: has_direct_sales == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 6: PURCHASES OUTSIDE CANADA
    # =========================================================================
    - id: b_outside_canada
      title: "Purchases Outside Canada"
      items:
        # T_Q12: Purchases outside Canada
        - id: q_t_q12
          kind: Question
          title: "How much was spent on goods and services purchased outside Canada?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: income
    # ===================================================================
    # =========================================================================
    # BLOCK: EMPLOYMENT
    # =========================================================================
    # U_Q01.1: Weeks worked full-time
    # U_Q01.2: Weeks worked part-time
    # =========================================================================
    - id: b_employment
      title: "Employment"
      items:
        - id: q_u_q01_1
          kind: Question
          title: "How many weeks did this person work full-time in 2000 (including holidays with pay)?"
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        - id: q_u_q01_2
          kind: Question
          title: "How many weeks did this person work part-time in 2000?"
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

    # =========================================================================
    # BLOCK: INCOME
    # =========================================================================
    # U_Q02 through U_Q16: Income from 15 different sources.
    # All amounts are in dollars for the year 2000.
    # =========================================================================
    - id: b_income
      title: "Income Sources"
      items:
        - id: q_u_q02
          kind: Question
          title: "Wages and salaries before deductions (include bonuses, tips, commissions)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q03
          kind: Question
          title: "NET income from farm and non-farm self-employment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q04_1
          kind: Question
          title: "GROSS income from roomers/boarders who were household members (non-relatives)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q04_2
          kind: Question
          title: "GROSS income from roomers/boarders who were NOT household members?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q05
          kind: Question
          title: "Dividends, interest on bonds/accounts/GICs, other investment income?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q06
          kind: Question
          title: "Child Tax Benefit (including Quebec Family Allowance)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q07
          kind: Question
          title: "Old Age Security Pension, Guaranteed Income Supplement, Spouse's Allowance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q08
          kind: Question
          title: "Canada or Quebec Pension Plan Benefits?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q09
          kind: Question
          title: "Employment Insurance Benefits (before deductions)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q10
          kind: Question
          title: "Goods and Services Tax Credit (received in 2000)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q11
          kind: Question
          title: "Provincial Tax Credits (claimed on 1999 returns)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q12
          kind: Question
          title: "Social Assistance, Workers' Compensation, Veterans' Pensions, other government income?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q13
          kind: Question
          title: "Retirement Pensions, Superannuation, Annuities and RRIF Withdrawals?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q14
          kind: Question
          title: "Personal Income Tax Refunds?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q15
          kind: Question
          title: "Other Money Income (alimony, child support, scholarships, etc.)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_u_q16
          kind: Question
          title: "Other Money Receipts (gifts, inheritances, life insurance settlements)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: taxes_gifts
    # ===================================================================
    # =========================================================================
    # BLOCK: PERSONAL TAXES
    # =========================================================================
    # V_Q01: Income tax on 2000 income
    # V_Q02: Income tax on prior years
    # V_Q03: Other personal taxes
    # =========================================================================
    - id: b_personal_taxes
      title: "Personal Taxes"
      items:
        - id: q_v_q01
          kind: Question
          title: "Income tax on 2000 income?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q02
          kind: Question
          title: "Income tax on income for years prior to 2000?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q03
          kind: Question
          title: "Other personal taxes (e.g., gift tax)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: SECURITY AND EMPLOYMENT PAYMENTS
    # =========================================================================
    # V_Q04 through V_Q10: Insurance, pension, and professional dues
    # =========================================================================
    - id: b_security_payments
      title: "Security and Employment Payments"
      items:
        - id: q_v_q04
          kind: Question
          title: "Premiums on life, term and endowment insurance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q05
          kind: Question
          title: "Annuity contracts and transfers to RRIFs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q06
          kind: Question
          title: "Employment insurance (deductions from pay)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q07
          kind: Question
          title: "Government retirement or pension fund?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q08
          kind: Question
          title: "Canada/Quebec Pension Plan?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q09
          kind: Question
          title: "Other retirement or pension funds?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q10
          kind: Question
          title: "Dues to unions and professional associations?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: GIFTS AND CONTRIBUTIONS
    # =========================================================================
    # V_Q11: Support payments to former spouse
    # V_Q12.1-Q12.2: Money gifts to persons
    # V_Q13.1-Q13.2: Charitable contributions
    # =========================================================================
    - id: b_gifts_contributions
      title: "Money Gifts, Contributions and Support"
      items:
        - id: q_v_q11
          kind: Question
          title: "Support payments to former spouse or partner?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q12_1
          kind: Question
          title: "Money given to persons living in Canada?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q12_2
          kind: Question
          title: "Money given to persons living outside Canada?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q13_1
          kind: Question
          title: "Charitable contributions to religious organizations?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q13_2
          kind: Question
          title: "Charitable contributions to other organizations?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: assets_business
    # ===================================================================
    # =========================================================================
    # BLOCK: CHANGE IN ASSETS (Section W)
    # =========================================================================
    # W_Q01.1 through W_Q03.3: Changes in household financial assets.
    # Report as household totals. Report changes, not levels.
    # Each net-change item has an increase and decrease column.
    # =========================================================================
    - id: b_change_in_assets
      title: "Change in Assets"
      items:
        # W_Q01.1: Cash in banks, trust companies, cash on hand
        - id: q_w_q01_1_inc
          kind: Question
          title: "NET CHANGE (increase) in cash in banks, trust companies, cash on hand (including GICs, excluding RRSPs)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_w_q01_1_dec
          kind: Question
          title: "NET CHANGE (decrease) in cash in banks, trust companies, cash on hand (including GICs, excluding RRSPs)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # W_Q01.2: Money owed to household
        - id: q_w_q01_2_inc
          kind: Question
          title: "NET CHANGE (increase) in money owed to household?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_w_q01_2_dec
          kind: Question
          title: "NET CHANGE (decrease) in money owed to household?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # W_Q01.3: Money deposited as pledge for future purchases
        - id: q_w_q01_3_inc
          kind: Question
          title: "NET CHANGE (increase) in money deposited as pledge for future purchases?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_w_q01_3_dec
          kind: Question
          title: "NET CHANGE (decrease) in money deposited as pledge for future purchases?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # W_Q02: RRSPs
        - id: qg_w_q02
          kind: QuestionGroup
          title: "Registered Retirement Savings Plans (RRSPs):"
          questions:
            - "Contributions in 2000"
            - "Withdrawals in 2000"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # W_Q03.1: Savings bonds and treasury bills
        - id: qg_w_q03_1
          kind: QuestionGroup
          title: "Savings bonds and treasury bills:"
          questions:
            - "Purchases in 2000"
            - "Sales in 2000"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # W_Q03.2: Publicly traded stocks, mutual funds, investment club shares
        - id: qg_w_q03_2
          kind: QuestionGroup
          title: "Publicly traded stocks, mutual funds, investment club shares:"
          questions:
            - "Purchases in 2000"
            - "Sales in 2000"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # W_Q03.3: Sales of personal property not traded in on new items
        - id: q_w_q03_3
          kind: Question
          title: "Sales of personal property not traded in on new items?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: BUSINESS SCREENER (Section X)
    # =========================================================================
    # X_Q01: Did any member have investments in unincorporated businesses,
    # farms or rental property?
    # =========================================================================
    - id: b_business_screener
      title: "Unincorporated Business Screener"
      items:
        - id: q_x_q01
          kind: Question
          title: "In 2000, did any member have investments in unincorporated businesses, farms or rental property?"
          codeBlock: |
            if q_x_q01.outcome == 1:
                has_business = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK: BUSINESS FINANCES (Section X continued)
    # =========================================================================
    # X_Q01.1 through X_Q02.2: Business financial details.
    # Only asked if has_business == 1.
    # =========================================================================
    - id: b_business_finances
      title: "Business Financial Details"
      precondition:
        - predicate: has_business == 1
      items:
        - id: q_x_q01_1
          kind: Question
          title: "Principal repayment on mortgage(s) or loan(s)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_x_q01_2
          kind: Question
          title: "Payment to purchase assets (machinery, trucks, buildings)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_x_q01_3
          kind: Question
          title: "Amount borrowed for business or farm?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_x_q01_4
          kind: Question
          title: "Amount received from sale of assets?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_x_q01_5
          kind: Question
          title: "Capital cost allowance (depreciation) estimate?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # X_Q02.1: Accounts receivable change
        - id: q_x_q02_1_inc
          kind: Question
          title: "NET CHANGE (increase) in accounts receivable?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_x_q02_1_dec
          kind: Question
          title: "NET CHANGE (decrease) in accounts receivable?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # X_Q02.2: Accounts payable change
        - id: q_x_q02_2_inc
          kind: Question
          title: "NET CHANGE (increase) in accounts payable?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_x_q02_2_dec
          kind: Question
          title: "NET CHANGE (decrease) in accounts payable?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # ===================================================================
    # SECTION: loans_debts
    # ===================================================================
    # =========================================================================
    # BLOCK: LOAN SCREENER
    # =========================================================================
    # Y_Q01: Does the household have any loans with regular payments?
    # =========================================================================
    - id: b_loan_screener
      title: "Loan Screener"
      items:
        - id: q_y_q01
          kind: Question
          title: "In 2000, did your household have any loans with regular payments? (Include installment plans, student loans if repaying. Exclude lines of credit and credit cards.)"
          codeBlock: |
            if q_y_q01.outcome == 1:
                has_loans = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK: LOAN DETAILS
    # =========================================================================
    # Per-loan grid (Loan A through E in the original questionnaire).
    # Since QML cannot model dynamic loan loops, this block represents
    # ONE representative loan. In the paper form, columns A through E
    # each collect the same 6 items (Y_Q02 through Y_Q05.1).
    #
    # Y_Q02: Description of loan
    # Y_Q03: Was this loan taken out in 2000?
    # Y_Q03.1: Amount of the loan (if Y_Q03 = Yes)
    # Y_Q04: Total payments made in 2000
    # Y_Q05: Additional amount borrowed?
    # Y_Q05.1: Additional amount (if Y_Q05 = Yes)
    # =========================================================================
    - id: b_loan_details
      title: "Loan Details"
      precondition:
        - predicate: has_loans == 1
      items:
        - id: q_y_q02
          kind: Question
          title: "Description of loan (e.g., car, boat, student loan)?"
          input:
            control: Textarea
            placeholder: "Describe the loan..."

        - id: q_y_q03
          kind: Question
          title: "Was this loan taken out in 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_y_q03_1
          kind: Question
          title: "What was the amount of the loan?"
          precondition:
            - predicate: q_y_q03.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_y_q04
          kind: Question
          title: "Total payments made on this loan in 2000 (including lump sum payments)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_y_q05
          kind: Question
          title: "Was there an additional amount borrowed in 2000 on this loan?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_y_q05_1
          kind: Question
          title: "What was the additional amount borrowed?"
          precondition:
            - predicate: q_y_q05.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: OTHER DEBTS
    # =========================================================================
    # Y_Q06 through Y_Q09: Each debt category tracks amount owed on
    # January 1, amount owed on December 31, and interest charges.
    # Modeled as QuestionGroups with 3 sub-questions each.
    # =========================================================================
    - id: b_other_debts
      title: "Other Money Owed"
      items:
        - id: qg_y_q06
          kind: QuestionGroup
          title: "Loans from financial institutions (including lines of credit, student loans not yet being repaid):"
          questions:
            - "Amount owed January 1, 2000"
            - "Amount owed December 31, 2000"
            - "Interest charges in 2000"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: qg_y_q07
          kind: QuestionGroup
          title: "Credit cards from financial institutions:"
          questions:
            - "Amount owed January 1, 2000"
            - "Amount owed December 31, 2000"
            - "Interest charges in 2000"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: qg_y_q08
          kind: QuestionGroup
          title: "Credit cards and debts with stores, service stations, retail:"
          questions:
            - "Amount owed January 1, 2000"
            - "Amount owed December 31, 2000"
            - "Interest charges in 2000"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: qg_y_q09
          kind: QuestionGroup
          title: "Rents, taxes and other bills (e.g., hospital):"
          questions:
            - "Amount owed January 1, 2000"
            - "Amount owed December 31, 2000"
            - "Interest charges in 2000"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
