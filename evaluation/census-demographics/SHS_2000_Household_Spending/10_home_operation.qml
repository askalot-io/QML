qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section M: Home Operation"

  blocks:
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
