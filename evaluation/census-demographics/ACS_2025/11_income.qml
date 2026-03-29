qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Income (Person Q43-Q44)"

  codeInit: |
    # Extern: person age from demographics section
    person_age: range(0, 120)

  blocks:
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
