qmlVersion: "1.0"
questionnaire:
  title: "SAEP - Remaining Children Savings"
  codeInit: |
    # Extern: number of children in household (section E only applies when >3)
    num_children: range(4, 20)
    # Gating variable for investment and RESP details
    has_remaining_plan = 0
  blocks:
    # =========================================================================
    # SECTION E: REMAINING CHILDREN — SAVINGS FOR POST-SECONDARY EDUCATION
    # =========================================================================
    # This section applies to children 4+ (beyond the 3 selected for detailed
    # questioning in Sections B-D). It collects aggregate savings information
    # for all remaining children as a group.
    #
    # Routing:
    #   E1=Yes -> E2; E1=No/DK/R -> END
    #   E2=0 -> END; E2>=1 -> E3..E6 -> E7a..E7d
    #   E7d: if ALL E7a-d not Yes -> END; otherwise -> E8a..E8e -> E9
    #   E9 (filter): E7a=Yes -> E10..E11b; otherwise -> END
    # =========================================================================
    - id: b_remaining_savings
      title: "Savings for Remaining Children"
      items:
        # E1: Have you saved for remaining children's PSE?
        - id: q_e1_saved
          kind: Question
          title: "Now I'd like to ask you some questions about saving for the post-secondary education of the other children in your household who are 18 years of age or younger. Have you or anyone else living in your household ever saved money for the post-secondary education of these children?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E2: For how many children is money being saved?
        - id: q_e2_how_many
          kind: Question
          title: "For how many of these children is money being saved?"
          precondition:
            - predicate: q_e1_saved.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 17

        # E3: Amount saved in 1998
        - id: q_e3_saved_1998
          kind: Question
          title: "How much money was saved for these children's post-secondary education in 1998? Do not include any earnings or interest."
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E4: Amount saved so far in 1999
        - id: q_e4_saved_1999
          kind: Question
          title: "How much money has been saved for these children's post-secondary education so far in 1999?"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E5: Amount to be saved rest of 1999
        - id: q_e5_save_rest_1999
          kind: Question
          title: "How much money will be saved for these children in the rest of 1999?"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E6: Total saved since starting
        - id: q_e6_total_saved
          kind: Question
          title: "Since starting to save for these children, how much in total has been saved for their post-secondary education?"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E7a: Savings plan — RESPs
        - id: q_e7a_resp
          kind: Question
          title: "What types of savings plans are being used to save for these children's post-secondary education? a) RESPs (Registered Education Savings Plans)"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E7b: Savings plan — RRSPs
        - id: q_e7b_rrsp
          kind: Question
          title: "b) RRSPs (Registered Retirement Savings Plans)"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E7c: Savings plan — In-trust-for accounts
        - id: q_e7c_trust
          kind: Question
          title: "c) 'In-trust for' accounts"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E7d: Savings plan — Other
        # After E7d: if ALL E7a-d are NOT Yes, skip investment details
        - id: q_e7d_other
          kind: Question
          title: "d) Other"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
          codeBlock: |
            if q_e7a_resp.outcome == 1 or q_e7b_rrsp.outcome == 1 or q_e7c_trust.outcome == 1 or q_e7d_other.outcome == 1:
                has_remaining_plan = 1

        # E8a: Investment type — Mutual funds
        - id: q_e8a_mutual
          kind: Question
          title: "Within these plans, how are the savings invested? a) Mutual funds"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E8b: Investment type — Shares of corporations
        - id: q_e8b_shares
          kind: Question
          title: "b) Shares of corporations"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E8c: Investment type — Savings or chequing accounts
        - id: q_e8c_savings
          kind: Question
          title: "c) Savings or chequing accounts"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E8d: Investment type — Savings bonds
        - id: q_e8d_bonds
          kind: Question
          title: "d) Savings bonds"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E8e: Investment type — Other
        - id: q_e8e_other
          kind: Question
          title: "e) Other"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E10: RESP total contributions
        # E9 (filter): if E7a=Yes -> E10; otherwise end
        - id: q_e10_resp_total
          kind: Question
          title: "For the RESP only, how much money in total has been contributed to RESPs for these children by people living in your household?"
          precondition:
            - predicate: q_e7a_resp.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E11a: RESP type — Individual plan
        - id: q_e11a_individual
          kind: Question
          title: "Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)"
          precondition:
            - predicate: q_e7a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E11b: RESP type — Group plan
        - id: q_e11b_group
          kind: Question
          title: "b) Group plan (education scholarship trust or foundation)"
          precondition:
            - predicate: q_e7a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
