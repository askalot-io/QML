qmlVersion: "1.0"
questionnaire:
  title: "Survey of Household Spending 2000 - Section Y: Loans and Other Debts"

  codeInit: |
    has_loans = 0

  blocks:
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
