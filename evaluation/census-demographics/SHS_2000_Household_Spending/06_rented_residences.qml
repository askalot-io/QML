qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section I: Rented Principal Residences"

  codeInit: |
    # No extern variables needed; routing is self-contained.

  blocks:
    # =========================================================================
    # BLOCK: RENTED PRINCIPAL RESIDENCES (Section I)
    # =========================================================================
    # I_Q01: months rented, I_Q02: total rent paid, I_Q03-Q06: additional
    # amounts, I_Q07-Q07.1: business charge, I_Q08-Q08.1.2: rooms rented.
    # If I_Q01 = 0 -> skip to Section J.
    # =========================================================================
    - id: b_rented_residences
      title: "Rented Principal Residences"
      items:
        # I_Q01: Months rented in 2000
        - id: q_i_q01
          kind: Question
          title: "For how many months in 2000 did your household occupy a rented dwelling? (If none, enter 0 to skip to Section J.)"
          input:
            control: Editbox
            min: 0
            max: 12

        # I_Q02: Total rent paid
        - id: q_i_q02
          kind: Question
          title: "Enter total rent paid in 2000."
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q03: Additional amount paid to landlord
        - id: q_i_q03
          kind: Question
          title: "Additional amount paid to landlord not included in rent (e.g., security deposits)?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q04: Rent returned
        - id: q_i_q04
          kind: Question
          title: "How much rent was returned to your household (e.g., overpayment, damage deposit)?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q05: Reduced rent
        - id: q_i_q05
          kind: Question
          title: "Did your household pay reduced rent?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Radio
            labels:
              1: "Government subsidized housing"
              2: "Other reasons (services to landlord, company housing)"
              3: "No reduced rent"

        # I_Q06.1: Additions, renovations, repairs for rented dwelling
        - id: q_i_q06_1
          kind: Question
          title: "Additions, renovations, repairs for rented dwelling(s)?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q06.2: Tenants insurance
        - id: q_i_q06_2
          kind: Question
          title: "Tenants' insurance?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q06.3: Parking at place of residence
        - id: q_i_q06_3
          kind: Question
          title: "Parking at place of residence?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q07: Business charge on rent
        - id: q_i_q07
          kind: Question
          title: "Was any part of rent charged against business income?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # I_Q07.1: Business charge amount
        - id: q_i_q07_1
          kind: Question
          title: "Amount charged against business income?"
          precondition:
            - predicate: q_i_q07.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q08: Rooms rented to others
        - id: q_i_q08
          kind: Question
          title: "Was any part of rent charged against income from rooms rented to others?"
          precondition:
            - predicate: q_i_q01.outcome > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # I_Q08.1.1: Amount from rooms rented to household members
        - id: q_i_q08_1_1
          kind: Question
          title: "Amount from rooms rented to household members (excl. relatives)?"
          precondition:
            - predicate: q_i_q08.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # I_Q08.1.2: Amount from rooms rented to non-members
        - id: q_i_q08_1_2
          kind: Question
          title: "Amount from rooms rented to non-members?"
          precondition:
            - predicate: q_i_q08.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
