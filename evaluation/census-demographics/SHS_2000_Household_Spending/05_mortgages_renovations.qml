qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Sections G & H: Mortgages and Renovations"

  codeInit: |
    # Extern from Section E: number of dwellings owned
    num_dwellings_owned: range(0, 99)

  blocks:
    # =========================================================================
    # BLOCK: MORTGAGES ON OWNED PRINCIPAL RESIDENCES (Section G)
    # =========================================================================
    # G_Q01: have mortgages, G_Q02.1-Q02.2: payment rosters (up to 3),
    # G_Q03.1-Q03.3: mortgage includes taxes/insurance, G_Q04-Q04.1d: amounts
    # added to mortgage.
    # Entire block gated on owning at least one dwelling.
    # =========================================================================
    - id: b_mortgages
      title: "Mortgages on Owned Principal Residences"
      precondition:
        - predicate: num_dwellings_owned > 0
      items:
        # G_Q01: Have mortgages?
        - id: q_g_q01
          kind: Question
          title: "In 2000, did your household have any mortgages on dwellings it owned and occupied?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G_Q02.1: Regular mortgage payments (up to 3 mortgages)
        - id: qg_g_q02_1
          kind: QuestionGroup
          title: "Regular mortgage payments in 2000? (Amount per payment period for each mortgage)"
          precondition:
            - predicate: q_g_q01.outcome == 1
          questions:
            - "Mortgage 1 - Amount"
            - "Mortgage 2 - Amount"
            - "Mortgage 3 - Amount"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # G_Q02.2: Irregular and lump sum payments (up to 3 mortgages)
        - id: qg_g_q02_2
          kind: QuestionGroup
          title: "Irregular and lump sum payments including payments to close mortgage?"
          precondition:
            - predicate: q_g_q01.outcome == 1
          questions:
            - "Mortgage 1 - Lump sum"
            - "Mortgage 2 - Lump sum"
            - "Mortgage 3 - Lump sum"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # G_Q03.1: Did mortgage payments include property taxes?
        - id: q_g_q03_1
          kind: Question
          title: "Did mortgage payments include property taxes?"
          precondition:
            - predicate: q_g_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G_Q03.2: Did mortgage payments include mortgage life/disability insurance?
        - id: q_g_q03_2
          kind: Question
          title: "Did mortgage payments include mortgage life/disability insurance?"
          precondition:
            - predicate: q_g_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G_Q03.3: Total premium for mortgage life/disability insurance
        - id: q_g_q03_3
          kind: Question
          title: "Total premium paid for mortgage life/disability insurance in 2000?"
          precondition:
            - predicate: q_g_q03_2.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # G_Q04: Amounts added to mortgage
        - id: q_g_q04
          kind: Question
          title: "Were any amounts added to your mortgage(s) in 2000?"
          precondition:
            - predicate: q_g_q01.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G_Q04.1a-d: Amounts added (up to 4)
        - id: qg_g_q04_1
          kind: QuestionGroup
          title: "Amounts added to mortgage(s):"
          precondition:
            - predicate: q_g_q04.outcome == 1
          questions:
            - "Amount added (first)"
            - "Amount added (second)"
            - "Amount added (third)"
            - "Amount added (fourth)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK: RENOVATIONS AND REPAIRS (Section H)
    # =========================================================================
    # H_Q01-Q03: additions/renovations, installations, repairs/maintenance.
    # Each is a roster of up to 3 entries with specify + cost.
    # Entire block gated on owning at least one dwelling.
    # =========================================================================
    - id: b_renovations
      title: "Renovations and Repairs of Owned Principal Residences"
      precondition:
        - predicate: num_dwellings_owned > 0
      items:
        # H_Q01: Additions, renovations and other alterations
        - id: qg_h_q01
          kind: QuestionGroup
          title: "How much spent on additions, renovations and other alterations? (Up to 3 entries)"
          questions:
            - "Entry 1 - Total cost"
            - "Entry 2 - Total cost"
            - "Entry 3 - Total cost"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # H_Q01 specify
        - id: q_h_q01_specify
          kind: Question
          title: "Specify the additions, renovations or alterations."
          input:
            control: Textarea
            placeholder: "Describe renovation work..."

        # H_Q02: Installations of equipment, appliances and fixtures
        - id: qg_h_q02
          kind: QuestionGroup
          title: "How much spent on installations of built-in equipment, appliances and fixtures? (Up to 3 entries: replacement cost and new installation cost)"
          questions:
            - "Entry 1 - Replacement cost"
            - "Entry 1 - New installation cost"
            - "Entry 2 - Replacement cost"
            - "Entry 2 - New installation cost"
            - "Entry 3 - Replacement cost"
            - "Entry 3 - New installation cost"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # H_Q02 specify
        - id: q_h_q02_specify
          kind: Question
          title: "Specify the installations."
          input:
            control: Textarea
            placeholder: "Describe installation work..."

        # H_Q03: Repairs and maintenance
        - id: qg_h_q03
          kind: QuestionGroup
          title: "How much spent on repairs and maintenance? (Up to 3 entries)"
          questions:
            - "Entry 1 - Total cost"
            - "Entry 2 - Total cost"
            - "Entry 3 - Total cost"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # H_Q03 specify
        - id: q_h_q03_specify
          kind: Question
          title: "Specify the repairs and maintenance."
          input:
            control: Textarea
            placeholder: "Describe repair work..."
