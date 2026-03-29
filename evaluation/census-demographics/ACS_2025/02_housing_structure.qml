qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Housing Structure"

  codeInit: |
    building_type = 0

  blocks:
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
