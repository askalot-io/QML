qmlVersion: "1.0"
questionnaire:
  title: "Survey of Household Spending 2000 - Sections W & X: Change in Assets and Unincorporated Business"

  codeInit: |
    has_business = 0

  blocks:
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
