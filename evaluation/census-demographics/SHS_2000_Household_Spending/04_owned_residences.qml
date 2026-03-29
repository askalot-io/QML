qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Sections E & F: Owned Residences and Home Purchase/Sale"

  codeInit: |
    # E_Q01 sets the number of dwellings owned; subsequent questions
    # are gated on this being > 0.

  blocks:
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
