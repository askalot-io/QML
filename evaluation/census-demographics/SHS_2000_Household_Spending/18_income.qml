qmlVersion: "1.0"
questionnaire:
  title: "Survey of Household Spending 2000 - Section U: Personal Income"

  # NOTE: Section U is a per-person grid that repeats for up to 5 household
  # members aged 15 or over on December 31, 2000. Since QML cannot model
  # dynamic person loops, this file represents ONE representative person.
  # In the original paper questionnaire, columns A through E each collect
  # the same 18 items for each eligible person.

  blocks:
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
