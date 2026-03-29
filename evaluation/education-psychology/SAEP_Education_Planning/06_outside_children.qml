qmlVersion: "1.0"
questionnaire:
  title: "SAEP - Children Outside Household"
  codeInit: |
    # Gating variable for investment and RESP details
    has_outside_plan = 0
  blocks:
    # =========================================================================
    # SECTION F: CHILDREN OUTSIDE HOUSEHOLD — SAVINGS
    # =========================================================================
    # Collects savings information for children under 18 who do NOT live in
    # the respondent's household but for whom household members are saving.
    #
    # Routing:
    #   F1=Yes -> F2..F7 -> F8a..F8d
    #   F1=No -> END
    #   F8d: if ALL F8a-d not Yes -> END; otherwise -> F9a..F9e -> F10
    #   F10 (filter): F8a=Yes -> F11..F12b; otherwise -> END
    # =========================================================================
    - id: b_outside_savings
      title: "Savings for Children Outside Household"
      items:
        # F1: Are you saving for children outside household?
        - id: q_f1_saving
          kind: Question
          title: "Are you or anyone else living in your household saving for the post-secondary education of any children 18 years of age or younger who do not live in your household?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # F2: For how many children?
        - id: q_f2_how_many
          kind: Question
          title: "For how many children is money being saved?"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # F3: Relationship of children to savers
        - id: q_f3_relationship
          kind: Question
          title: "What is the relationship of these children to the people saving money for them? (Mark all that apply)"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Son"
              2: "Daughter"
              4: "Grandson"
              8: "Granddaughter"
              16: "Brother"
              32: "Sister"
              64: "Niece"
              128: "Nephew"
              256: "Other family member or relative"
              512: "Unrelated"

        # F4: Amount saved in 1998
        - id: q_f4_saved_1998
          kind: Question
          title: "How much money was saved for these children's education in 1998 by you or anyone else living in your household? Do not include any earnings or interest."
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F5: Amount saved so far in 1999
        - id: q_f5_saved_1999
          kind: Question
          title: "How much money was saved for these children's education so far in 1999?"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F6: Amount to be saved rest of 1999
        - id: q_f6_save_rest_1999
          kind: Question
          title: "How much money will you or anyone else in your household save for these children in the rest of 1999?"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F7: Total saved since starting
        - id: q_f7_total_saved
          kind: Question
          title: "Since starting to save for these children, how much money in total has been saved by you or anyone else in your household for their education? Do not include any earnings or interest."
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F8a: Savings plan — RESPs
        - id: q_f8a_resp
          kind: Question
          title: "What types of savings plans are being used? a) RESPs (Registered Education Savings Plans)"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F8b: Savings plan — RRSPs
        - id: q_f8b_rrsp
          kind: Question
          title: "b) RRSPs (Registered Retirement Savings Plans)"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F8c: Savings plan — In-trust-for accounts
        - id: q_f8c_trust
          kind: Question
          title: "c) 'In-trust for' accounts"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F8d: Savings plan — Other
        # After F8d: if ALL F8a-d are NOT Yes, skip investment details
        - id: q_f8d_other
          kind: Question
          title: "d) Other"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
          codeBlock: |
            if q_f8a_resp.outcome == 1 or q_f8b_rrsp.outcome == 1 or q_f8c_trust.outcome == 1 or q_f8d_other.outcome == 1:
                has_outside_plan = 1

        # F9a: Investment type — Mutual funds
        - id: q_f9a_mutual
          kind: Question
          title: "Within these plans, how are the savings invested? a) Mutual funds"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F9b: Investment type — Shares of corporations
        - id: q_f9b_shares
          kind: Question
          title: "b) Shares of corporations"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F9c: Investment type — Savings or chequing accounts
        - id: q_f9c_savings
          kind: Question
          title: "c) Savings or chequing accounts"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F9d: Investment type — Savings bonds
        - id: q_f9d_bonds
          kind: Question
          title: "d) Savings bonds"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F9e: Investment type — Other
        - id: q_f9e_other
          kind: Question
          title: "e) Other"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F11: RESP total contributions
        # F10 (filter): if F8a=Yes -> F11; otherwise end
        - id: q_f11_resp_total
          kind: Question
          title: "For the RESPs only, how much money in total has been contributed to RESPs for these children by people living in your household?"
          precondition:
            - predicate: q_f8a_resp.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F12a: RESP type — Individual plan
        - id: q_f12a_individual
          kind: Question
          title: "Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)"
          precondition:
            - predicate: q_f8a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F12b: RESP type — Group plan
        - id: q_f12b_group
          kind: Question
          title: "b) Group plan (education scholarship trust or foundation)"
          precondition:
            - predicate: q_f8a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
