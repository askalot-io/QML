qmlVersion: "1.0"
questionnaire:
  title: "Survey of Household Spending 2000 - Section V: Personal Taxes, Security and Money Gifts"

  # NOTE: Section V is a per-person grid that repeats for up to 5 household
  # members aged 15 or over on December 31, 2000. Since QML cannot model
  # dynamic person loops, this file represents ONE representative person.
  # In the original paper questionnaire, columns A through E each collect
  # the same 15 items for each eligible person.

  blocks:
    # =========================================================================
    # BLOCK: PERSONAL TAXES
    # =========================================================================
    # V_Q01: Income tax on 2000 income
    # V_Q02: Income tax on prior years
    # V_Q03: Other personal taxes
    # =========================================================================
    - id: b_personal_taxes
      title: "Personal Taxes"
      items:
        - id: q_v_q01
          kind: Question
          title: "Income tax on 2000 income?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q02
          kind: Question
          title: "Income tax on income for years prior to 2000?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q03
          kind: Question
          title: "Other personal taxes (e.g., gift tax)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: SECURITY AND EMPLOYMENT PAYMENTS
    # =========================================================================
    # V_Q04 through V_Q10: Insurance, pension, and professional dues
    # =========================================================================
    - id: b_security_payments
      title: "Security and Employment Payments"
      items:
        - id: q_v_q04
          kind: Question
          title: "Premiums on life, term and endowment insurance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q05
          kind: Question
          title: "Annuity contracts and transfers to RRIFs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q06
          kind: Question
          title: "Employment insurance (deductions from pay)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q07
          kind: Question
          title: "Government retirement or pension fund?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q08
          kind: Question
          title: "Canada/Quebec Pension Plan?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q09
          kind: Question
          title: "Other retirement or pension funds?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q10
          kind: Question
          title: "Dues to unions and professional associations?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: GIFTS AND CONTRIBUTIONS
    # =========================================================================
    # V_Q11: Support payments to former spouse
    # V_Q12.1-Q12.2: Money gifts to persons
    # V_Q13.1-Q13.2: Charitable contributions
    # =========================================================================
    - id: b_gifts_contributions
      title: "Money Gifts, Contributions and Support"
      items:
        - id: q_v_q11
          kind: Question
          title: "Support payments to former spouse or partner?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q12_1
          kind: Question
          title: "Money given to persons living in Canada?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q12_2
          kind: Question
          title: "Money given to persons living outside Canada?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q13_1
          kind: Question
          title: "Charitable contributions to religious organizations?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        - id: q_v_q13_2
          kind: Question
          title: "Charitable contributions to other organizations?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
