qmlVersion: "1.0"
questionnaire:
  title: "American Community Survey 2025"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    person_count = 0
    person_age = 0
    person_sex = 0
    building_type = 0
    highest_degree = 0
    worked_last_week = 0
    worked_past_5_years = 0

  blocks:

    # ===================================================================
    # SECTION: household_demographics
    # ===================================================================
    - id: b_household
      title: "Cover & Household"
      items:
        # COVER_CONTACT: Administrative contact info
        - id: q_cover_contact
          kind: Comment
          title: "Please print the name and telephone number of the person who is filling out this form."

        # COVER_COUNT: Household size
        - id: q_cover_count
          kind: Question
          title: "How many people, including yourself, live or stay at this address?"
          input:
            control: Editbox
            min: 1
            max: 12
          codeBlock: |
            person_count = q_cover_count.outcome

    - id: b_person_roster
      title: "Person Roster"
      items:
        # P_Q1: Person name (administrative text field — modeled as Comment)
        - id: q_p1_name
          kind: Comment
          title: "What is this person's name? (Last name, First name, MI)"

        # P_Q2: Relationship to Person 1 (for Person 2+; Person 1 is self-identified)
        - id: q_p2_relationship
          kind: Question
          title: "How is this person related to Person 1?"
          input:
            control: Dropdown
            labels:
              1: "Opposite-sex husband/wife/spouse"
              2: "Opposite-sex unmarried partner"
              3: "Same-sex husband/wife/spouse"
              4: "Same-sex unmarried partner"
              5: "Biological son or daughter"
              6: "Adopted son or daughter"
              7: "Stepson or stepdaughter"
              8: "Brother or sister"
              9: "Father or mother"
              10: "Grandchild"
              11: "Parent-in-law"
              12: "Son-in-law or daughter-in-law"
              13: "Other relative"
              14: "Roommate or housemate"
              15: "Foster child"
              16: "Other nonrelative"

        # P_Q3: Sex
        - id: q_p3_sex
          kind: Question
          title: "What is this person's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
          codeBlock: |
            person_sex = q_p3_sex.outcome

        # P_Q4: Age
        - id: q_p4_age
          kind: Question
          title: "What is this person's age and what is this person's date of birth?"
          input:
            control: Editbox
            min: 0
            max: 120
          codeBlock: |
            person_age = q_p4_age.outcome

        # P_Q5: Hispanic origin
        - id: q_p5_hispanic
          kind: Question
          title: "Is this person of Hispanic, Latino, or Spanish origin?"
          input:
            control: Radio
            labels:
              0: "No, not of Hispanic, Latino, or Spanish origin"
              1: "Yes, Mexican, Mexican Am., Chicano"
              2: "Yes, Puerto Rican"
              3: "Yes, Cuban"
              4: "Yes, another Hispanic, Latino, or Spanish origin"

        # P_Q5 follow-up: Specify other Hispanic origin
        - id: q_p5_hispanic_specify
          kind: Question
          title: "Please print origin, for example, Salvadoran, Dominican, Colombian, Guatemalan, Spaniard, Ecuadorian, etc."
          precondition:
            - predicate: "q_p5_hispanic.outcome == 4"
          input:
            control: Textarea
            placeholder: "Specify origin"

        # P_Q6: Race (multi-select with power-of-2 keys)
        - id: q_p6_race
          kind: Question
          title: "What is this person's race? Mark one or more boxes AND print origins."
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African Am."
              4: "American Indian or Alaska Native"
              8: "Chinese"
              16: "Filipino"
              32: "Asian Indian"
              64: "Other Asian"
              128: "Vietnamese"
              256: "Korean"
              512: "Japanese"
              1024: "Native Hawaiian"
              2048: "Samoan"
              4096: "Chamorro"
              8192: "Other Pacific Islander"
              16384: "Some other race"

    # ===================================================================
    # SECTION: housing_structure
    # ===================================================================
    - id: b_housing_structure
      title: "Housing Characteristics"
      items:
        # H_Q1: Building type
        - id: q_h1_building
          kind: Question
          title: "Which best describes this building? Include all apartments, flats, etc., even if vacant."
          input:
            control: Dropdown
            labels:
              1: "A mobile home"
              2: "A one-family house detached from any other house"
              3: "A one-family house attached to one or more houses"
              4: "A building with 2 apartments"
              5: "A building with 3 or 4 apartments"
              6: "A building with 5 to 9 apartments"
              7: "A building with 10 to 19 apartments"
              8: "A building with 20 to 49 apartments"
              9: "A building with 50 or more apartments"
              10: "Boat, RV, van, etc."
          codeBlock: |
            building_type = q_h1_building.outcome

        # H_Q2: Year built
        - id: q_h2_year_built
          kind: Question
          title: "About when was this building first built?"
          input:
            control: Dropdown
            labels:
              1: "2020 or later"
              2: "2010 to 2019"
              3: "2000 to 2009"
              4: "1990 to 1999"
              5: "1980 to 1989"
              6: "1970 to 1979"
              7: "1960 to 1969"
              8: "1950 to 1959"
              9: "1940 to 1949"
              10: "1939 or earlier"

        # H_Q3: Move-in date (modeled as year for QML numeric)
        - id: q_h3_move_in
          kind: Question
          title: "When did Person 1 move into this house, apartment, or mobile home? (Enter year)"
          input:
            control: Editbox
            min: 1900
            max: 2025

        # FILTER A: House or mobile home → show Q4-Q5
        # H_Q4: Acreage (gated on building_type in {1,2,3})
        - id: q_h4_acreage
          kind: Question
          title: "How many acres is this house or mobile home on?"
          precondition:
            - predicate: "building_type in [1, 2, 3]"
          input:
            control: Radio
            labels:
              1: "Less than 1 acre"
              2: "1 to 9.9 acres"
              3: "10 or more acres"

        # H_Q5: Agricultural sales (gated on acreage >= 2, i.e., 1+ acres)
        - id: q_h5_ag_sales
          kind: Question
          title: "IN THE PAST 12 MONTHS, what were the actual sales of all agricultural products from this property?"
          precondition:
            - predicate: "building_type in [1, 2, 3]"
            - predicate: "q_h4_acreage.outcome >= 2"
          input:
            control: Dropdown
            labels:
              0: "None"
              1: "$1 to $999"
              2: "$1,000 to $2,499"
              3: "$2,500 to $4,999"
              4: "$5,000 to $9,999"
              5: "$10,000 or more"

        # H_Q6a: Number of rooms
        - id: q_h6a_rooms
          kind: Question
          title: "How many separate rooms are in this house, apartment, or mobile home?"
          input:
            control: Editbox
            min: 1
            max: 30

        # H_Q6b: Number of bedrooms
        - id: q_h6b_bedrooms
          kind: Question
          title: "How many of these rooms are bedrooms?"
          input:
            control: Editbox
            min: 0
            max: 30
          postcondition:
            - predicate: "q_h6b_bedrooms.outcome <= q_h6a_rooms.outcome"
              hint: "Number of bedrooms cannot exceed the total number of rooms."

        # H_Q7a-e: Utilities (QuestionGroup)
        - id: qg_h7_utilities
          kind: QuestionGroup
          title: "Does this house, apartment, or mobile home have —"
          questions:
            - "Hot and cold running water?"
            - "A bathtub or shower?"
            - "A sink with a faucet?"
            - "A stove or range?"
            - "A refrigerator?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q8: Sewer connection
        - id: q_h8_sewer
          kind: Question
          title: "Is this house, apartment, or mobile home connected to a public sewer?"
          input:
            control: Radio
            labels:
              1: "Yes, connected to public sewer"
              2: "No, connected to septic tank"
              3: "No, use other type of system"

        # H_Q9: Phone capability
        - id: q_h9_phone
          kind: Question
          title: "Can you or any member of this household both make and receive phone calls when at this house, apartment, or mobile home?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: housing_technology
    # ===================================================================
    - id: b_housing_technology
      title: "Technology, Vehicles & Energy"
      items:
        # H_Q10a-c: Computer types (QuestionGroup for uniform Yes/No items)
        - id: qg_h10_computers
          kind: QuestionGroup
          title: "At this house, apartment, or mobile home — do you or any member of this household own or use:"
          questions:
            - "A desktop or laptop?"
            - "A smartphone?"
            - "A tablet or other portable wireless computer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q10d: Other computer type (separate to allow specify follow-up)
        - id: q_h10d_other_computer
          kind: Question
          title: "Do you or any member of this household own or use some other type of computer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q10d follow-up: Specify other computer
        - id: q_h10d_specify
          kind: Question
          title: "Please specify the other type of computer."
          precondition:
            - predicate: "q_h10d_other_computer.outcome == 1"
          input:
            control: Textarea
            placeholder: "Specify type of computer"

        # H_Q11: Internet access
        - id: q_h11_internet
          kind: Question
          title: "At this house, apartment, or mobile home — do you or any member of this household have access to the Internet?"
          input:
            control: Radio
            labels:
              1: "Yes, by paying a cell phone company or Internet service provider"
              2: "Yes, without paying a cell phone company or Internet service provider"
              3: "No access to the Internet at this house, apartment, or mobile home"

        # H_Q12a-e: Internet service types (gated on paying for internet)
        - id: qg_h12_internet_types
          kind: QuestionGroup
          title: "Do you or any member of this household have access to the Internet using —"
          precondition:
            - predicate: "q_h11_internet.outcome == 1"
          questions:
            - "A cellular data plan for a smartphone or other mobile device?"
            - "Broadband (high speed) Internet service such as cable, fiber optic, or DSL?"
            - "Satellite Internet service?"
            - "Dial-up Internet service?"
            - "Some other service?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q13: Number of vehicles
        - id: q_h13_vehicles
          kind: Question
          title: "How many automobiles, vans, and trucks of one-ton capacity or less are kept at home for use by members of this household?"
          input:
            control: Dropdown
            labels:
              0: "None"
              1: "1"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6 or more"

        # H_Q14: Electric vehicle (gated on having at least 1 vehicle)
        - id: q_h14_ev
          kind: Question
          title: "Do you or any member of this household own or lease an electric vehicle? Include both all-electric and plug-in hybrid electric vehicles."
          precondition:
            - predicate: "q_h13_vehicles.outcome >= 1"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q15: Heating fuel
        - id: q_h15_fuel
          kind: Question
          title: "Which FUEL is used MOST for heating this house, apartment, or mobile home?"
          input:
            control: Dropdown
            labels:
              1: "Gas: Natural gas from underground pipes"
              2: "Gas: Bottled or tank (propane, butane, etc.)"
              3: "Electricity"
              4: "Fuel oil, kerosene, etc."
              5: "Coal or coke"
              6: "Wood"
              7: "Solar energy"
              8: "Other fuel"
              9: "No fuel used"

        # H_Q16: Solar panels
        - id: q_h16_solar
          kind: Question
          title: "Does this house, apartment, or mobile home use solar panels that generate electricity?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: housing_costs_tenure
    # ===================================================================
    # --- Utility Costs (Q17a-d) ---
    - id: b_utility_costs
      title: "Utility Costs"
      items:
        # H_Q17a: Electricity cost
        - id: q_h_q17a_type
          kind: Question
          title: "LAST MONTH, what was the cost of electricity for this house, apartment, or mobile home?"
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "Included in rent or condominium fee"
              3: "No charge or electricity not used"

        - id: q_h_q17a_amount
          kind: Question
          title: "Electricity cost last month (dollars)"
          precondition:
            - predicate: "q_h_q17a_type.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 9999
            right: "$"

        # H_Q17b: Gas cost
        - id: q_h_q17b_type
          kind: Question
          title: "LAST MONTH, what was the cost of gas for this house, apartment, or mobile home?"
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "Included in rent or condominium fee"
              3: "Included in electricity payment entered above"
              4: "No charge or gas not used"

        - id: q_h_q17b_amount
          kind: Question
          title: "Gas cost last month (dollars)"
          precondition:
            - predicate: "q_h_q17b_type.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 9999
            right: "$"

        # H_Q17c: Water and sewer cost
        - id: q_h_q17c_type
          kind: Question
          title: "IN THE PAST 12 MONTHS, what was the cost of water and sewer for this house, apartment, or mobile home?"
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "Included in rent or condominium fee"
              3: "No charge"

        - id: q_h_q17c_amount
          kind: Question
          title: "Water and sewer cost in the past 12 months (dollars)"
          precondition:
            - predicate: "q_h_q17c_type.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 99999
            right: "$"

        # H_Q17d: Oil, coal, kerosene, wood cost
        - id: q_h_q17d_type
          kind: Question
          title: "IN THE PAST 12 MONTHS, what was the cost of oil, coal, kerosene, wood, etc., for this house, apartment, or mobile home?"
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "Included in rent or condominium fee"
              3: "No charge or these fuels not used"

        - id: q_h_q17d_amount
          kind: Question
          title: "Oil, coal, kerosene, wood cost in the past 12 months (dollars)"
          precondition:
            - predicate: "q_h_q17d_type.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 99999
            right: "$"

    # --- Benefits (Q18-Q19) ---
    - id: b_benefits
      title: "Food Stamps and HOA"
      items:
        # H_Q18: Food Stamps / SNAP
        - id: q_h_q18
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or any member of this household receive benefits from the Food Stamp Program or SNAP (Supplemental Nutrition Assistance Program)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q19: HOA/condominium membership
        - id: q_h_q19
          kind: Question
          title: "Is this house, apartment, or mobile home part of a homeowners association or condominium?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q19 follow-up: Monthly HOA/condo fee type
        - id: q_h_q19_fee_type
          kind: Question
          title: "What is the monthly homeowners association or condominium fee?"
          precondition:
            - predicate: "q_h_q19.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "None"

        # H_Q19 follow-up: HOA/condo fee amount
        - id: q_h_q19_fee_amount
          kind: Question
          title: "Monthly HOA or condominium fee (dollars)"
          precondition:
            - predicate: "q_h_q19.outcome == 1"
            - predicate: "q_h_q19_fee_type.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 99999
            right: "$"

    # --- Tenure (Q20) ---
    - id: b_tenure
      title: "Tenure"
      items:
        # H_Q20: Own or rent
        - id: q_h_q20
          kind: Question
          title: "Is this house, apartment, or mobile home —"
          input:
            control: Radio
            labels:
              1: "Owned by you or someone in this household with a mortgage or loan?"
              2: "Owned by you or someone in this household free and clear (without a mortgage or loan)?"
              3: "Rented?"
              4: "Occupied without payment of rent?"

    # --- Renter Block (Q21a-b) — Filter B: rented only ---
    - id: b_renter
      title: "Renter Costs"
      precondition:
        - predicate: "q_h_q20.outcome == 3"
      items:
        # H_Q21a: Monthly rent
        - id: q_h_q21a
          kind: Question
          title: "What is the monthly rent for this house, apartment, or mobile home?"
          input:
            control: Editbox
            min: 1
            max: 99999
            right: "$"

        # H_Q21b: Meals included in rent
        - id: q_h_q21b
          kind: Question
          title: "Does the monthly rent include any meals?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # --- Owner Block (Q22-Q26) — Filter C: owned only ---
    - id: b_owner
      title: "Owner Costs"
      precondition:
        - predicate: "q_h_q20.outcome in [1, 2]"
      items:
        # H_Q22: Property value
        - id: q_h_q22
          kind: Question
          title: "About how much do you think this house and lot, apartment, or mobile home (and lot, if owned) would sell for if it were for sale?"
          input:
            control: Editbox
            min: 1
            max: 99999999
            right: "$"

        # H_Q23: Real estate taxes — amount or none
        - id: q_h_q23_type
          kind: Question
          title: "What are the annual real estate taxes on THIS property?"
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "None"

        - id: q_h_q23_amount
          kind: Question
          title: "Annual real estate taxes (dollars)"
          precondition:
            - predicate: "q_h_q23_type.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "$"

        # H_Q24: Insurance — amount or none
        - id: q_h_q24_type
          kind: Question
          title: "What is the annual payment for fire, hazard, and flood insurance on THIS property?"
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "None"

        - id: q_h_q24_amount
          kind: Question
          title: "Annual fire, hazard, and flood insurance (dollars)"
          precondition:
            - predicate: "q_h_q24_type.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "$"

        # H_Q25a: Mortgage status
        - id: q_h_q25a
          kind: Question
          title: "Do you or any member of this household have a mortgage, deed of trust, contract to purchase, or similar debt on THIS property?"
          input:
            control: Radio
            labels:
              1: "Yes, mortgage, deed of trust, or similar debt"
              2: "Yes, contract to purchase"
              3: "No"

        # H_Q25b: Monthly mortgage payment — type (amount or no regular payment)
        - id: q_h_q25b_type
          kind: Question
          title: "How much is the regular monthly mortgage payment on THIS property?"
          precondition:
            - predicate: "q_h_q25a.outcome in [1, 2]"
          input:
            control: Radio
            labels:
              1: "Enter dollar amount"
              2: "No regular payment required"

        # H_Q25b: Monthly mortgage payment — amount
        - id: q_h_q25b_amount
          kind: Question
          title: "Regular monthly mortgage payment (dollars)"
          precondition:
            - predicate: "q_h_q25a.outcome in [1, 2]"
            - predicate: "q_h_q25b_type.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "$"

        # H_Q25c: Taxes included in mortgage
        - id: q_h_q25c
          kind: Question
          title: "Does the regular monthly mortgage payment include payments for real estate taxes on THIS property?"
          precondition:
            - predicate: "q_h_q25a.outcome in [1, 2]"
            - predicate: "q_h_q25b_type.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Yes, taxes included in mortgage payment"
              2: "No, taxes paid separately or taxes not required"

        # H_Q25d: Insurance included in mortgage
        - id: q_h_q25d
          kind: Question
          title: "Does the regular monthly mortgage payment include payments for fire, hazard, or flood insurance on THIS property?"
          precondition:
            - predicate: "q_h_q25a.outcome in [1, 2]"
            - predicate: "q_h_q25b_type.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Yes, insurance included in mortgage payment"
              2: "No, insurance paid separately or no insurance"

        # H_Q26a: Second mortgage / home equity loan
        - id: q_h_q26a
          kind: Question
          title: "Do you or any member of this household have a second mortgage or a home equity loan on THIS property?"
          input:
            control: Radio
            labels:
              1: "Yes, a home equity loan"
              2: "Yes, a second mortgage"
              3: "Yes, both a second mortgage and a home equity loan"
              4: "No"

        # H_Q26b: Second mortgage payment
        - id: q_h_q26b
          kind: Question
          title: "How much is the regular monthly payment on all second or junior mortgages and all home equity loans on THIS property?"
          precondition:
            - predicate: "q_h_q26a.outcome in [1, 2, 3]"
          input:
            control: Editbox
            min: 0
            max: 999999
            right: "$"

    # --- Mobile Home Costs (Q27) — Filter D: mobile home + owned ---
    - id: b_mobile_home
      title: "Mobile Home Costs"
      precondition:
        - predicate: "q_h_q20.outcome in [1, 2]"
        - predicate: "building_type == 1"
      items:
        # H_Q27: Mobile home annual costs
        - id: q_h_q27
          kind: Question
          title: "What are the total annual costs for personal property taxes, site rent, registration fees, and license fees on THIS mobile home and its site? Exclude real estate taxes."
          input:
            control: Editbox
            min: 0
            max: 999999
            right: "$"

    # ===================================================================
    # SECTION: education_migration
    # ===================================================================
    - id: b_migration
      title: "Place of Birth & Citizenship"
      items:
        # P_Q7: Where was this person born?
        - id: q_p_q7
          kind: Question
          title: "Where was this person born?"
          input:
            control: Radio
            labels:
              1: "In the United States"
              2: "Outside the United States"

        # P_Q8: Citizenship status
        - id: q_p_q8
          kind: Question
          title: "Is this person a citizen of the United States?"
          input:
            control: Dropdown
            labels:
              1: "Yes, born in the United States"
              2: "Yes, born in Puerto Rico, Guam, the U.S. Virgin Islands, or Northern Marianas"
              3: "Yes, born abroad of U.S. citizen parent or parents"
              4: "Yes, U.S. citizen by naturalization"
              5: "No, not a U.S. citizen"

        # P_Q8_YEAR: When did this person come to live in the US?
        - id: q_p_q8_year
          kind: Question
          title: "When did this person come to live in the United States? If this person came to live in the United States more than once, print latest year."
          precondition:
            - predicate: "q_p_q8.outcome != 1"
          input:
            control: Editbox
            min: 1900
            max: 2026

    - id: b_education
      title: "School Enrollment & Educational Attainment"
      items:
        # P_Q10a: School attendance in last 3 months
        - id: q_p_q10a
          kind: Question
          title: "At any time IN THE LAST 3 MONTHS, has this person attended school or college?"
          input:
            control: Radio
            labels:
              0: "No, has not attended in the last 3 months"
              1: "Yes, public school, public college"
              2: "Yes, private school, private college, home school"

        # P_Q10b: Grade or level attending
        - id: q_p_q10b
          kind: Question
          title: "What grade or level was this person attending?"
          precondition:
            - predicate: "q_p_q10a.outcome in [1, 2]"
          input:
            control: Dropdown
            labels:
              1: "Nursery school, preschool"
              2: "Kindergarten"
              3: "Grade 1 through 12"
              4: "College undergraduate years (freshman to senior)"
              5: "Graduate or professional school beyond a bachelor's degree"

        # P_Q11: Highest degree completed
        - id: q_p_q11
          kind: Question
          title: "What is the highest grade of school or degree this person has COMPLETED?"
          input:
            control: Dropdown
            labels:
              1: "Less than grade 1"
              2: "Grade 1 through 11"
              3: "12th grade - NO DIPLOMA"
              4: "Regular high school diploma"
              5: "GED or alternative credential"
              6: "Some college credit, but less than 1 year"
              7: "1 or more years of college credit, no degree"
              8: "Associate's degree (AA, AS)"
              9: "Bachelor's degree (BA, BS)"
              10: "Master's degree (MA, MS, MEng, MEd, MSW, MBA)"
              11: "Professional degree beyond bachelor's (MD, DDS, DVM, LLB, JD)"
              12: "Doctorate degree (PhD, EdD)"
          codeBlock: |
            highest_degree = q_p_q11.outcome

        # P_Q12: Bachelor's degree major (Filter F: bachelor's or higher)
        - id: q_p_q12
          kind: Question
          title: "This question focuses on this person's BACHELOR'S DEGREE. Please print below the specific major(s) of any BACHELOR'S DEGREES this person has received."
          precondition:
            - predicate: "highest_degree >= 9"
          input:
            control: Textarea
            placeholder: "e.g., Economics, Civil Engineering, Nursing"

    # ===================================================================
    # SECTION: language_residence
    # ===================================================================
    - id: b_ancestry_language
      title: "Ancestry & Language"
      items:
        # P_Q13: Ancestry or ethnic origin
        - id: q_p_q13
          kind: Question
          title: "What is this person's ancestry or ethnic origin? (For example: Italian, Jamaican, African Am., Cambodian, Cape Verdean, Norwegian, Dominican, French Canadian, Haitian, Korean, Lebanese, Polish, Nigerian, Mexican, Taiwanese, Ukrainian, and so on.)"
          input:
            control: Textarea
            placeholder: "e.g., Italian, Jamaican, African Am."

        # P_Q14a: Speaks language other than English at home?
        - id: q_p_q14a
          kind: Question
          title: "Does this person speak a language other than English at home?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P_Q14b: What language?
        - id: q_p_q14b
          kind: Question
          title: "What is this language?"
          precondition:
            - predicate: "q_p_q14a.outcome == 1"
          input:
            control: Textarea
            placeholder: "e.g., Korean, Italian, Spanish, Vietnamese"

        # P_Q14c: How well does this person speak English?
        - id: q_p_q14c
          kind: Question
          title: "How well does this person speak English?"
          precondition:
            - predicate: "q_p_q14a.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Not well"
              4: "Not at all"

    - id: b_residence
      title: "Residence 1 Year Ago"
      items:
        # P_Q15a: Did this person live in this house 1 year ago?
        - id: q_p_q15a
          kind: Question
          title: "Did this person live in this house or apartment 1 year ago?"
          input:
            control: Radio
            labels:
              0: "Person is under 1 year old"
              1: "Yes, this house"
              2: "No, outside the United States and Puerto Rico"
              3: "No, different house in the United States or Puerto Rico"

        # P_Q15b: Where did this person live 1 year ago?
        - id: q_p_q15b
          kind: Question
          title: "Where did this person live 1 year ago? (Address, city, county, state, ZIP)"
          precondition:
            - predicate: "q_p_q15a.outcome == 3"
          input:
            control: Textarea
            placeholder: "Address, city, county, state, ZIP code"

    # ===================================================================
    # SECTION: health_disability
    # ===================================================================
    # ── Health Insurance (Q16, Filter G, Q17a-b) ──
    - id: b_health_insurance
      title: "Health Insurance Coverage"
      items:
        # P_Q16: Health insurance coverage types
        - id: q_p_q16
          kind: Question
          title: "Is this person CURRENTLY covered by any of the following types of health insurance or health coverage plans? Mark all that apply."
          input:
            control: Checkbox
            labels:
              1: "Insurance through a current or former employer, union, or professional association"
              2: "Medicare"
              4: "Medicaid, CHIP, or government-assistance plan"
              8: "Insurance purchased directly from an insurance company, broker, or Marketplace"
              16: "VA health care (enrolled for VA)"
              32: "TRICARE or other military health care"
              64: "Indian Health Service"
              128: "Any other type of health insurance or health coverage plan"
              256: "No health insurance or health coverage plan"

        # Filter G: insured → Q17a; uninsured (only 256 selected) → skip to Q18a
        # P_Q17a: Premium for health plan
        - id: q_p_q17a
          kind: Question
          title: "Is there a premium for this plan?"
          precondition:
            - predicate: "q_p_q16.outcome != 256"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q17b: Tax credit or subsidy
        - id: q_p_q17b
          kind: Question
          title: "Does this person or another family member receive a tax credit or subsidy based on family income to help pay the premium?"
          precondition:
            - predicate: "q_p_q16.outcome != 256"
            - predicate: "q_p_q17a.outcome == 1"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ── Disability: Hearing & Vision (Q18a-b) — asked of everyone ──
    - id: b_disability_hearing_vision
      title: "Disability - Hearing and Vision"
      items:
        # P_Q18a: Hearing difficulty
        - id: q_p_q18a
          kind: Question
          title: "Is this person deaf or does he/she have serious difficulty hearing?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q18b: Vision difficulty
        - id: q_p_q18b
          kind: Question
          title: "Is this person blind or does he/she have serious difficulty seeing even when wearing glasses?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ── Disability: Cognitive, Walking, Dressing (Q19a-c) — Filter H: age >= 5 ──
    - id: b_disability_cognitive
      title: "Disability - Cognitive, Ambulatory, Self-Care"
      precondition:
        - predicate: "person_age >= 5"
      items:
        # P_Q19a: Cognitive difficulty
        - id: q_p_q19a
          kind: Question
          title: "Because of a physical, mental, or emotional condition, does this person have serious difficulty concentrating, remembering, or making decisions?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q19b: Walking/climbing difficulty
        - id: q_p_q19b
          kind: Question
          title: "Does this person have serious difficulty walking or climbing stairs?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q19c: Dressing/bathing difficulty
        - id: q_p_q19c
          kind: Question
          title: "Does this person have difficulty dressing or bathing?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ── Disability: Errands (Q20) — Filter I: age >= 15 ──
    - id: b_disability_errands
      title: "Disability - Independent Living"
      precondition:
        - predicate: "person_age >= 15"
      items:
        # P_Q20: Errands difficulty
        - id: q_p_q20
          kind: Question
          title: "Because of a physical, mental, or emotional condition, does this person have difficulty doing errands alone such as visiting a doctor's office or shopping?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: marriage_family
    # ===================================================================
    # ── Marital Status & History (Q21-Q24) — age >= 15 ──
    - id: b_marital_status
      title: "Marital Status"
      precondition:
        - predicate: "person_age >= 15"
      items:
        # P_Q21: Current marital status
        - id: q_p_q21
          kind: Question
          title: "What is this person's marital status?"
          input:
            control: Radio
            labels:
              1: "Now married"
              2: "Widowed"
              3: "Divorced"
              4: "Separated"
              5: "Never married"

        # P_Q22a: Married in past 12 months
        - id: q_p_q22a
          kind: Question
          title: "In the PAST 12 MONTHS did this person get married?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q22b: Widowed in past 12 months
        - id: q_p_q22b
          kind: Question
          title: "In the PAST 12 MONTHS did this person get widowed?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q22c: Divorced in past 12 months
        - id: q_p_q22c
          kind: Question
          title: "In the PAST 12 MONTHS did this person get divorced?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q23: Times married
        - id: q_p_q23
          kind: Question
          title: "How many times has this person been married?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Radio
            labels:
              1: "Once"
              2: "Two times"
              3: "Three or more times"

        # P_Q24: Year last married
        - id: q_p_q24
          kind: Question
          title: "In what year did this person last get married?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Editbox
            min: 1940
            max: 2026

    # ── Fertility (Q25) — Filter J: female age 15-50 ──
    - id: b_fertility
      title: "Fertility"
      precondition:
        - predicate: "person_sex == 2 and person_age >= 15 and person_age <= 50"
      items:
        # P_Q25: Given birth in past 12 months
        - id: q_p_q25
          kind: Question
          title: "In the PAST 12 MONTHS, has this person given birth to any children?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ── Grandchildren (Q26a-c) — age >= 15 ──
    - id: b_grandchildren
      title: "Grandchildren"
      precondition:
        - predicate: "person_age >= 15"
      items:
        # P_Q26a: Grandchildren under 18 in household
        - id: q_p_q26a
          kind: Question
          title: "Does this person have any of his/her own grandchildren under the age of 18 living in this house or apartment?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q26b: Responsible for grandchildren
        - id: q_p_q26b
          kind: Question
          title: "Is this grandparent currently responsible for most of the basic needs of any grandchildren under the age of 18 who live in this house or apartment?"
          precondition:
            - predicate: "q_p_q26a.outcome == 1"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q26c: Duration of responsibility
        - id: q_p_q26c
          kind: Question
          title: "How long has this grandparent been responsible for these grandchildren?"
          precondition:
            - predicate: "q_p_q26b.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Less than 6 months"
              2: "6 to 11 months"
              3: "1 or 2 years"
              4: "3 or 4 years"
              5: "5 or more years"

    # ===================================================================
    # SECTION: military
    # ===================================================================
    # ── Military Service (Q27-Q29) — age >= 15 ──
    - id: b_military
      title: "Military Service"
      precondition:
        - predicate: "person_age >= 15"
      items:
        # P_Q27: Military service status
        - id: q_p_q27
          kind: Question
          title: "Has this person ever served on active duty in the U.S. Armed Forces, Reserves, or National Guard?"
          input:
            control: Radio
            labels:
              1: "Never served in the military"
              2: "Only on active duty for training in the Reserves or National Guard"
              3: "Now on active duty"
              4: "On active duty in the past, but not now"

        # P_Q28: Service periods — Checkbox with power-of-2 keys
        - id: q_p_q28
          kind: Question
          title: "When did this person serve on active duty in the U.S. Armed Forces? Mark all that apply."
          precondition:
            - predicate: "q_p_q27.outcome in [3, 4]"
          input:
            control: Checkbox
            labels:
              1: "September 2001 or later"
              2: "August 1990 to August 2001 (including Persian Gulf War)"
              4: "June 1975 to July 1990"
              8: "August 1964 to May 1975 (including Vietnam era)"
              16: "February 1955 to July 1964"
              32: "June 1950 to January 1955 (including Korean War)"
              64: "January 1947 to May 1950"
              128: "December 1941 to December 1946 (including World War II)"
              256: "November 1941 or earlier"

        # P_Q29a: VA disability rating
        - id: q_p_q29a
          kind: Question
          title: "Does this person have a VA service-connected disability rating?"
          precondition:
            - predicate: "q_p_q27.outcome in [2, 3, 4]"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q29b: Disability rating percentage
        - id: q_p_q29b
          kind: Question
          title: "What is this person's service-connected disability rating?"
          precondition:
            - predicate: "q_p_q29a.outcome == 1"
          input:
            control: Radio
            labels:
              1: "0 percent"
              2: "10 or 20 percent"
              3: "30 or 40 percent"
              4: "50 or 60 percent"
              5: "70 percent or higher"

    # ===================================================================
    # SECTION: employment
    # ===================================================================
    # =========================================================================
    # BLOCK 1: WORK STATUS — Q30a, Q30b
    # Determines worked_last_week classification variable
    # All items gated on person_age >= 15 (Filter I)
    # =========================================================================
    - id: b_work_status
      title: "Work Status Last Week"
      precondition:
        - predicate: person_age >= 15
      items:
        # Q30a: Worked for pay last week?
        - id: q_p_q30a
          kind: Question
          title: "LAST WEEK, did this person work for pay at a job (or business)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_p_q30a.outcome == 1:
                worked_last_week = 1
                worked_past_5_years = 1

        # Q30b: Any work even 1 hour? (only if Q30a = No)
        - id: q_p_q30b
          kind: Question
          title: "LAST WEEK, did this person do ANY work for pay, even for as little as one hour?"
          precondition:
            - predicate: q_p_q30a.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_p_q30b.outcome == 1:
                worked_last_week = 1
                worked_past_5_years = 1

    # =========================================================================
    # BLOCK 2: WORK LOCATION — Q31a-f
    # Gated on worked_last_week == 1
    # =========================================================================
    - id: b_work_location
      title: "Work Location"
      precondition:
        - predicate: person_age >= 15
        - predicate: worked_last_week == 1
      items:
        # Q31a: Work address
        - id: q_p_q31a
          kind: Question
          title: "At what location did this person work LAST WEEK? (Number and street name)"
          input:
            control: Textarea
            placeholder: "Street address"
            maxLength: 200

        # Q31b: City/town
        - id: q_p_q31b
          kind: Question
          title: "Name of city, town, or post office"
          input:
            control: Textarea
            placeholder: "City or town"
            maxLength: 100

        # Q31c: Inside city limits?
        - id: q_p_q31c
          kind: Question
          title: "Is the work location inside the limits of that city or town?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q31d: County
        - id: q_p_q31d
          kind: Question
          title: "Name of county"
          input:
            control: Textarea
            placeholder: "County"
            maxLength: 100

        # Q31e: State or foreign country
        - id: q_p_q31e
          kind: Question
          title: "Name of U.S. state or foreign country"
          input:
            control: Textarea
            placeholder: "State or country"
            maxLength: 100

        # Q31f: ZIP Code
        - id: q_p_q31f
          kind: Question
          title: "ZIP Code"
          input:
            control: Editbox
            min: 0
            max: 99999

    # =========================================================================
    # BLOCK 3: COMMUTE — Q32, Q33, Q34, Q35
    # Gated on worked_last_week == 1
    # Q32 option 11 (Worked from home) → skip Q33-Q35, go to Q40a
    # Filter K: Q32 == 1 (car/truck/van) → Q33 carpool
    # =========================================================================
    - id: b_commute
      title: "Commuting to Work"
      precondition:
        - predicate: person_age >= 15
        - predicate: worked_last_week == 1
      items:
        # Q32: Transport mode — 12 options → Dropdown
        - id: q_p_q32
          kind: Question
          title: "How did this person usually get to work LAST WEEK? If this person usually used more than one method of transportation during the trip, mark the one used for most of the distance."
          input:
            control: Dropdown
            labels:
              1: "Car, truck, or van"
              2: "Bus"
              3: "Subway or elevated rail"
              4: "Long-distance train or commuter rail"
              5: "Light rail, streetcar, or trolley"
              6: "Ferryboat"
              7: "Taxi or ride-hailing services"
              8: "Motorcycle"
              9: "Bicycle"
              10: "Walked"
              11: "Worked from home"
              12: "Other method"

        # Q33: Carpool count — Filter K: only if Q32 == 1 (car/truck/van)
        - id: q_p_q33
          kind: Question
          title: "How many people, including this person, usually rode to work in the car, truck, or van LAST WEEK?"
          precondition:
            - predicate: q_p_q32.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 10

        # Q34: Trip start time — gated on not working from home
        - id: q_p_q34
          kind: Question
          title: "What time did this person usually leave home to go to work LAST WEEK? (Hour, 0-23)"
          precondition:
            - predicate: q_p_q32.outcome != 11
          input:
            control: Editbox
            min: 0
            max: 23

        # Q35: Commute duration — gated on not working from home
        - id: q_p_q35
          kind: Question
          title: "How many minutes did it usually take this person to get from home to work LAST WEEK?"
          precondition:
            - predicate: q_p_q32.outcome != 11
          input:
            control: Editbox
            min: 1
            max: 200

    # =========================================================================
    # BLOCK 4: JOB SEARCH — Q36a-c, Q37, Q38, Q39
    # Filter L: Only if NOT worked last week
    # Complex chain: Q36a → Q36b/Q36c → Q37 → Q38 → Q39
    # =========================================================================
    - id: b_job_search
      title: "Job Search and Layoff Status"
      precondition:
        - predicate: person_age >= 15
        - predicate: worked_last_week == 0
      items:
        # Q36a: On layoff?
        - id: q_p_q36a
          kind: Question
          title: "LAST WEEK, was this person on layoff from a job?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q36b: Temporarily absent? — only if NOT on layoff
        # Yes → skip to Q39; No → go to Q37
        - id: q_p_q36b
          kind: Question
          title: "LAST WEEK, was this person TEMPORARILY absent from a job or business?"
          precondition:
            - predicate: q_p_q36a.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes — on vacation, temporary illness, maternity leave, other family/personal reasons, bad weather, etc."
              2: "No"

        # Q36c: Recall within 6 months? — only if on layoff (Q36a=Yes)
        # Yes → skip to Q38; No → go to Q37
        - id: q_p_q36c
          kind: Question
          title: "Has this person been informed that he or she will be recalled to work within the next 6 months OR been given a date to return to work?"
          precondition:
            - predicate: q_p_q36a.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q37: Actively looking for work?
        # Reached when: (not on layoff AND not temporarily absent) OR (on layoff AND no recall)
        # i.e., (Q36a=No and Q36b=No/2) OR (Q36a=Yes and Q36c=No)
        - id: q_p_q37
          kind: Question
          title: "During the LAST 4 WEEKS, has this person been ACTIVELY looking for work?"
          precondition:
            - predicate: (q_p_q36a.outcome == 0 and q_p_q36b.outcome == 2) or (q_p_q36a.outcome == 1 and q_p_q36c.outcome == 0)
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q38: Could start a job?
        # Reached when: Q37=Yes (actively looking) OR (Q36a=Yes and Q36c=Yes — on layoff with recall)
        - id: q_p_q38
          kind: Question
          title: "LAST WEEK, could this person have started a job if offered one, or returned to work if recalled?"
          precondition:
            - predicate: q_p_q37.outcome == 1 or (q_p_q36a.outcome == 1 and q_p_q36c.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes, could have gone to work"
              2: "No, because of own temporary illness"
              3: "No, because of all other reasons (in school, etc.)"

        # Q39: When last worked?
        # Asked of all non-workers (worked_last_week == 0), except those
        # temporarily absent (Q36b=Yes/1) who skip directly here from the
        # source but don't need Q39 since they have a job. In the ACS paper
        # form, Q36b=Yes routes to Q39. We model this: Q39 is shown when
        # NOT temporarily absent, or when temporarily absent (converging path).
        # Actually per inventory: Q36b=1 → SKIP TO Q39, Q36b=2 → SKIP TO Q37
        # and Q37=No → SKIP TO Q39. So Q39 is reached by multiple paths.
        # Simplest: show Q39 to all non-workers.
        - id: q_p_q39
          kind: Question
          title: "When did this person last work for pay, even for a few days?"
          input:
            control: Radio
            labels:
              1: "Within the past 12 months"
              2: "1 to 5 years ago"
              3: "Over 5 years ago or never worked"
          codeBlock: |
            if q_p_q39.outcome == 1 or q_p_q39.outcome == 2:
                worked_past_5_years = 1

    # =========================================================================
    # BLOCK 5: WORK HISTORY — Q40a, Q40b, Q41
    # Worked in past 12 months: either worked last week OR Q39 == 1
    # =========================================================================
    - id: b_work_history
      title: "Work History (Past 12 Months)"
      precondition:
        - predicate: person_age >= 15
      items:
        # Q40a: Worked every week in past 12 months?
        # Shown when: worked last week OR last worked within past 12 months
        - id: q_p_q40a
          kind: Question
          title: "During the PAST 12 MONTHS (52 weeks), did this person work EVERY week? Include paid vacation, paid sick leave, and military service."
          precondition:
            - predicate: worked_last_week == 1 or q_p_q39.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q40b: Weeks worked — only if Q40a = No
        - id: q_p_q40b
          kind: Question
          title: "During the PAST 12 MONTHS (52 weeks), how many WEEKS did this person work for at least one day? Include paid time off."
          precondition:
            - predicate: worked_last_week == 1 or q_p_q39.outcome == 1
            - predicate: q_p_q40a.outcome == 0
          input:
            control: Editbox
            min: 0
            max: 52

        # Q41: Hours per week
        - id: q_p_q41
          kind: Question
          title: "During the PAST 12 MONTHS, for the weeks worked, how many HOURS did this person usually work each WEEK?"
          precondition:
            - predicate: worked_last_week == 1 or q_p_q39.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

    # =========================================================================
    # BLOCK 6: EMPLOYER DETAILS — Q42a-f
    # Filter M: worked in past 5 years
    # Workers (worked_last_week==1) set worked_past_5_years in Q30a/Q30b
    # Non-workers with Q39 in {1,2} set it in Q39 codeBlock
    # =========================================================================
    - id: b_employer
      title: "Employer and Occupation Details"
      precondition:
        - predicate: person_age >= 15
        - predicate: worked_past_5_years == 1
      items:
        # Q42a: Employment type — 9 options → Dropdown
        - id: q_p_q42a
          kind: Question
          title: "Which one of the following best describes this person's employment last week or the most recent employment in the past 5 years?"
          input:
            control: Dropdown
            labels:
              1: "For-profit company or organization"
              2: "Non-profit organization (including tax-exempt and charitable)"
              3: "Local government (city, county, etc.)"
              4: "State government"
              5: "Active duty U.S. Armed Forces or Commissioned Corps"
              6: "Federal government civilian employee"
              7: "Owner of non-incorporated business, professional practice, or farm"
              8: "Owner of incorporated business, professional practice, or farm"
              9: "Worked without pay in a for-profit family business or farm for 15 hours or more per week"

        # Q42b: Employer name
        - id: q_p_q42b
          kind: Question
          title: "What was the name of this person's employer, business, agency, or branch of the Armed Forces?"
          input:
            control: Textarea
            placeholder: "Employer name"
            maxLength: 200

        # Q42c: Business/industry
        - id: q_p_q42c
          kind: Question
          title: "What kind of business or industry was this? Describe the activity at the location where employed. (For example: hospital, newspaper publishing, mail order house, auto engine manufacturing, bank)"
          input:
            control: Textarea
            placeholder: "Type of business or industry"
            maxLength: 200

        # Q42d: Mainly manufacturing/wholesale/retail/other — 4 options → Radio
        - id: q_p_q42d
          kind: Question
          title: "Was this mainly —"
          input:
            control: Radio
            labels:
              1: "Manufacturing?"
              2: "Wholesale trade?"
              3: "Retail trade?"
              4: "Other (agriculture, construction, service, government, etc.)?"

        # Q42e: Main occupation
        - id: q_p_q42e
          kind: Question
          title: "What was this person's main occupation? Describe the kind of work this person did. (For example: 4th grade teacher, entry-level plumber, concrete mason, or stock clerk)"
          input:
            control: Textarea
            placeholder: "Occupation title"
            maxLength: 200

        # Q42f: Duties description
        - id: q_p_q42f
          kind: Question
          title: "Describe this person's most important activities or duties. (For example: instruct and evaluate students, install water pipes and fixtures, mix and pour concrete, keep records of parts and supplies)"
          input:
            control: Textarea
            placeholder: "Main duties"
            maxLength: 200

    # ===================================================================
    # SECTION: income
    # ===================================================================
    # =========================================================================
    # INCOME — Q43a-h paired switches + amounts, Q44 total
    # All gated on person_age >= 15 (Filter I from disability section)
    # =========================================================================
    - id: b_income
      title: "Income"
      precondition:
        - predicate: person_age >= 15
      items:
        # --- Q43a: Wages, salary, commissions, bonuses, tips ---
        - id: q_p_q43a
          kind: Question
          title: "IN THE PAST 12 MONTHS, did this person receive wages, salary, commissions, bonuses, or tips from all jobs?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_p_q43a_amount
          kind: Question
          title: "Amount of wages, salary, commissions, bonuses, or tips (past 12 months)."
          precondition:
            - predicate: q_p_q43a.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # --- Q43b: Self-employment income ---
        - id: q_p_q43b
          kind: Question
          title: "IN THE PAST 12 MONTHS, did this person receive self-employment income from own nonfarm businesses or farm businesses, including proprietorships and partnerships?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_p_q43b_amount
          kind: Question
          title: "Net self-employment income after business expenses (past 12 months)."
          precondition:
            - predicate: q_p_q43b.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # --- Q43c: Interest, dividends, rental income ---
        - id: q_p_q43c
          kind: Question
          title: "IN THE PAST 12 MONTHS, did this person receive interest, dividends, net rental income, royalty income, or income from estates and trusts?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_p_q43c_amount
          kind: Question
          title: "Amount of interest, dividends, net rental income, royalty income, or income from estates and trusts (past 12 months)."
          precondition:
            - predicate: q_p_q43c.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # --- Q43d: Social Security or Railroad Retirement ---
        - id: q_p_q43d
          kind: Question
          title: "IN THE PAST 12 MONTHS, did this person receive Social Security or Railroad Retirement?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_p_q43d_amount
          kind: Question
          title: "Amount of Social Security or Railroad Retirement (past 12 months)."
          precondition:
            - predicate: q_p_q43d.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # --- Q43e: Supplemental Security Income (SSI) ---
        - id: q_p_q43e
          kind: Question
          title: "IN THE PAST 12 MONTHS, did this person receive Supplemental Security Income (SSI)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_p_q43e_amount
          kind: Question
          title: "Amount of Supplemental Security Income (past 12 months)."
          precondition:
            - predicate: q_p_q43e.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # --- Q43f: Public assistance or welfare ---
        - id: q_p_q43f
          kind: Question
          title: "IN THE PAST 12 MONTHS, did this person receive any public assistance or welfare payments from the state or local welfare office?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_p_q43f_amount
          kind: Question
          title: "Amount of public assistance or welfare payments (past 12 months)."
          precondition:
            - predicate: q_p_q43f.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # --- Q43g: Retirement income, pensions ---
        - id: q_p_q43g
          kind: Question
          title: "IN THE PAST 12 MONTHS, did this person receive retirement income, pensions, survivor or disability income? Include income from a previous employer or union, or any regular withdrawals from IRA, Roth IRA, 401(k), 403(b)."
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_p_q43g_amount
          kind: Question
          title: "Amount of retirement income, pensions, survivor or disability income (past 12 months)."
          precondition:
            - predicate: q_p_q43g.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # --- Q43h: Other regular income ---
        - id: q_p_q43h
          kind: Question
          title: "IN THE PAST 12 MONTHS, did this person receive any other sources of income received regularly such as Veterans' (VA) payments, unemployment compensation, child support, or alimony?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_p_q43h_amount
          kind: Question
          title: "Amount of other regular income (past 12 months)."
          precondition:
            - predicate: q_p_q43h.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # --- Q44: Total income ---
        - id: q_p_q44
          kind: Question
          title: "What was this person's total income during the PAST 12 MONTHS? Add entries in questions 43a to 43h; subtract any losses."
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
