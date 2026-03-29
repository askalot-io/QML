qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section K: Owned Secondary Residences and Other Property"

  blocks:
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
