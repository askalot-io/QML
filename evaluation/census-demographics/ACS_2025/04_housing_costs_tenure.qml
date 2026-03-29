qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Housing Costs and Tenure (Q17-Q27)"

  codeInit: |
    building_type: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

  blocks:
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
