qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section T: Tobacco and Miscellaneous"

  codeInit: |
    has_direct_sales = 0

  blocks:
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
