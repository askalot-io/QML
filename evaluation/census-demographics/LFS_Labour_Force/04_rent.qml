qmlVersion: "1.0"
questionnaire:
  title: "Labour Force Survey - Rent Component"

  codeInit: |
    # Cross-section variables READ by this section (from Household Component)
    dwelling_type: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    tenure: {0, 1}

    # Extern state variables for longitudinal context
    # 0 = no previous rent info (birth interview), 1 = has previous info
    has_previous_rent: {0, 1}
    # 0 = no complete membership change, 1 = complete change
    membership_change: {0, 1}

    # NOTE: The original questionnaire also conditions entry on
    # province not being Yukon/NWT/Nunavut. This cannot be modeled
    # without a province variable; the limitation is noted here.

  blocks:
    # =========================================================================
    # BLOCK 1: RENT INTRODUCTION
    # =========================================================================
    # RRF_R01: Introduction read to respondent.
    # Block-level precondition: tenure == 1 (dwelling is rented).
    # =========================================================================
    - id: b_rent_intro
      title: "Rent Introduction"
      precondition:
        - predicate: tenure == 1
      items:
        # RRF_R01: Introduction
        - id: q_rrf_r01
          kind: Comment
          title: "The next few questions are about your rent. The information collected is used to calculate the rent portion of the Consumer Price Index."

    # =========================================================================
    # BLOCK 2: DWELLING CHARACTERISTICS
    # =========================================================================
    # RM_Q01: Floor number (apartments only, no previous rent info)
    # RM_Q02: Building age
    # RM_Q03: Number of bedrooms
    #
    # Routing:
    #   RM_Q01: asked only if apartment AND no previous rent info
    #   If has_previous_rent=1 -> skip to RM_Q04
    #   If not apartment -> RM_Q02
    #   RM_Q02 -> RM_Q03 -> RM_Q04
    # =========================================================================
    - id: b_dwelling_chars
      title: "Dwelling Characteristics"
      precondition:
        - predicate: tenure == 1
        - predicate: has_previous_rent == 0
      items:
        # RM_Q01: Floor number (apartments only)
        - id: q_rm_q01
          kind: Question
          title: "On which floor do you live?"
          precondition:
            - predicate: dwelling_type == 5 or dwelling_type == 6
          input:
            control: Editbox
            min: 0
            max: 99

        # RM_Q02: Building age
        - id: q_rm_q02
          kind: Question
          title: "To the best of your knowledge, how old is your building?"
          input:
            control: Radio
            labels:
              1: "No more than 5 years old"
              2: "More than 5 but no more than 10 years"
              3: "More than 10 but no more than 20 years"
              4: "More than 20 but no more than 40 years"
              5: "More than 40 years old"

        # RM_Q03: Number of bedrooms
        - id: q_rm_q03
          kind: Question
          title: "How many bedrooms are there in your dwelling?"
          input:
            control: Editbox
            min: 0
            max: 20

    # =========================================================================
    # BLOCK 3: RENT SUBSIDY AND BUSINESS USE
    # =========================================================================
    # RM_Q04: Is rent subsidized?
    # RM_Q04A: Manner of subsidy (if Yes)
    # RM_Q05: Rent for both living and business?
    # RM_Q05A: Does business affect rent? (if Yes)
    # =========================================================================
    - id: b_subsidy_business
      title: "Rent Subsidy and Business Use"
      precondition:
        - predicate: tenure == 1
      items:
        # RM_Q04: Rent subsidized?
        - id: q_rm_q04
          kind: Question
          title: "This month, is the rent for your dwelling subsidized by government or an employer, or a relative?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q04A: Manner of subsidy
        - id: q_rm_q04a
          kind: Question
          title: "In what manner is the rent for your dwelling subsidized?"
          precondition:
            - predicate: q_rm_q04.outcome == 1
          input:
            control: Radio
            labels:
              1: "Income-related/Government"
              2: "Employer"
              3: "Owned by a relative"
              4: "Other"

        # RM_Q05: Rent for both living and business?
        - id: q_rm_q05
          kind: Question
          title: "This month, is the rent for your dwelling applied to both living and business accommodation?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q05A: Does business affect rent amount?
        - id: q_rm_q05a
          kind: Question
          title: "Does the business affect the amount of rent paid?"
          precondition:
            - predicate: q_rm_q05.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 4: RENT AMOUNT AND CHANGES
    # =========================================================================
    # RM_Q06: Total monthly rent
    # RM_Q07: Reason rent is $0 (if rent=0)
    # RM_Q08: Changes in rent since last month
    # RM_Q08A: Reason for rent change (if Yes)
    #
    # Routing:
    #   RM_Q06: if $0 -> RM_Q07; if >$0 -> RM_Q08
    #   RM_Q07: if subsidized -> end; else -> RM_Q08
    #   RM_Q08: filters skip to RM_Q09B; Yes -> RM_Q08A; No -> RM_Q09B
    #   RM_Q08A -> RM_Q09B
    # =========================================================================
    - id: b_rent_amount
      title: "Rent Amount and Changes"
      precondition:
        - predicate: tenure == 1
      items:
        # RM_Q06: Total monthly rent
        - id: q_rm_q06
          kind: Question
          title: "How much is the total monthly rent for your dwelling?"
          input:
            control: Editbox
            min: 0
            max: 99999

        # RM_Q07: Reason rent is $0
        # Asked only when rent is zero
        - id: q_rm_q07
          kind: Question
          title: "What is the reason that the rent is $0?"
          precondition:
            - predicate: q_rm_q06.outcome == 0
          input:
            control: Textarea
            placeholder: "Explain why rent is $0..."

        # RM_Q08: Changes in rent since last month
        # Filter: skip if no previous info, complete membership change,
        # or rent is subsidized. Also skip if rent is $0 and subsidized
        # (those paths end after RM_Q07).
        # When rent is $0 and not subsidized, fall through to RM_Q08.
        - id: q_rm_q08
          kind: Question
          title: "Since last month, have there been any changes in the amount of rent paid?"
          precondition:
            - predicate: has_previous_rent == 1
            - predicate: membership_change == 0
            - predicate: q_rm_q04.outcome == 0
            - predicate: q_rm_q06.outcome >= 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q08A: Reason for rent change (multi select)
        # Power-of-2 keys: 1=Utilities, 2=Parking, 4=New Lease, 8=Other
        - id: q_rm_q08a
          kind: Question
          title: "What is the reason for the change in rent since last month? Mark all that apply."
          precondition:
            - predicate: q_rm_q08.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Change in utilities/services/appliances/furnishings"
              2: "Change in parking facilities"
              4: "New lease"
              8: "Other"

    # =========================================================================
    # BLOCK 5: PARKING FACILITIES
    # =========================================================================
    # RM_Q09B: Does rent include parking?
    # RM_Q09S: Changes in parking since last month?
    # RM_Q10: Types of parking included
    # RM_Q11-Q13: Number of parking spaces by type
    #
    # Routing:
    #   RM_Q09B: non-apartment -> RM_Q14; has previous & no membership
    #     change -> RM_Q09S; Yes -> RM_Q10; No -> RM_Q14
    #   RM_Q09S: Yes -> RM_Q10; No -> RM_Q14
    #   RM_Q10 -> RM_Q11 (if indoor) -> RM_Q12 (if plug-in) -> RM_Q13
    #     (if no plug-in) -> RM_Q14
    # =========================================================================
    - id: b_parking
      title: "Parking Facilities"
      precondition:
        - predicate: tenure == 1
        - predicate: dwelling_type == 5 or dwelling_type == 6
      items:
        # RM_Q09B: Does rent include parking?
        # Asked of apartments. If $0 rent and subsidized, the survey
        # ends before reaching here (modeled via block precondition
        # and the flow from block 4).
        - id: q_rm_q09b
          kind: Question
          title: "Does this month's rent include parking facilities?"
          precondition:
            - predicate: "has_previous_rent == 0 or membership_change == 1"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q09S: Changes in parking since last month?
        # Asked when there is previous rent info and no membership change
        - id: q_rm_q09s
          kind: Question
          title: "Since last month, have there been any changes in the parking facilities?"
          precondition:
            - predicate: has_previous_rent == 1
            - predicate: membership_change == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q10: Types of parking included in rent
        # Asked when: RM_Q09B=Yes OR RM_Q09S=Yes
        # Power-of-2 keys: 1=Indoor, 2=Outside w/ plug-in, 4=Outside w/o plug-in
        - id: q_rm_q10
          kind: Question
          title: "What types of parking facilities are included in your rent? Mark all that apply."
          precondition:
            - predicate: q_rm_q09b.outcome == 1 or q_rm_q09s.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Closed garage or indoor parking"
              2: "Outside parking with plug-in"
              4: "Outside parking without plug-in"

        # RM_Q11: Indoor parking spaces
        # Bit 0 set = indoor parking selected (outcome % 2 >= 1)
        - id: q_rm_q11
          kind: Question
          title: "How many closed garage or indoor parking spaces are included in your rent?"
          precondition:
            - predicate: q_rm_q10.outcome % 2 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # RM_Q12: Outside parking with plug-in spaces
        # Bit 1 set = outside plug-in selected (outcome % 4 >= 2)
        - id: q_rm_q12
          kind: Question
          title: "How many outside parking spaces with plug-in are included in your rent?"
          precondition:
            - predicate: q_rm_q10.outcome % 4 >= 2
          input:
            control: Editbox
            min: 1
            max: 10

        # RM_Q13: Outside parking without plug-in spaces
        # Bit 2 set = outside no plug-in selected (outcome % 8 >= 4)
        - id: q_rm_q13
          kind: Question
          title: "How many outside parking spaces without plug-in are included in your rent?"
          precondition:
            - predicate: q_rm_q10.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1
            max: 10

    # =========================================================================
    # BLOCK 6: UTILITIES AND FURNISHINGS
    # =========================================================================
    # RM_Q14: Changes in utilities/furnishings since last month
    # RM_Q15: Which utilities/services included in rent
    #
    # Routing:
    #   RM_Q14: if no previous info -> RM_Q15; if membership change ->
    #     RM_Q15; if RM_Q08A includes utilities -> RM_Q15; Yes -> RM_Q15;
    #     No -> end
    #   RM_Q15 -> end of Rent Component
    # =========================================================================
    - id: b_utilities
      title: "Utilities and Furnishings"
      precondition:
        - predicate: tenure == 1
      items:
        # RM_Q14: Changes in utilities/furnishings since last month
        # Filter: always goes to RM_Q15 if no previous info, membership
        # change, or RM_Q08A includes utilities (bit 0). Only asked when
        # there is previous info, no membership change, and no utility
        # change already reported.
        # When No -> end of component (RM_Q15 is skipped).
        - id: q_rm_q14
          kind: Question
          title: "Since last month, have there been any changes in the utilities, services, appliances, or furnishings included in the rent?"
          precondition:
            - predicate: has_previous_rent == 1
            - predicate: membership_change == 0
            - predicate: q_rm_q08a.outcome % 2 == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # RM_Q15: Utilities/services/furnishings included in rent
        # Asked when: RM_Q14=Yes, or RM_Q14 was skipped (no previous
        # info, membership change, or RM_Q08A includes utilities).
        # Power-of-2 keys for 12 options.
        - id: q_rm_q15
          kind: Question
          title: "Which of the following utilities, services, appliances, or furnishings are included as part of the monthly rent? Read list to respondent. Mark all that apply."
          precondition:
            - predicate: "q_rm_q14.outcome == 1 or has_previous_rent == 0 or membership_change == 1 or q_rm_q08a.outcome % 2 >= 1"
          input:
            control: Checkbox
            labels:
              1: "Heat - Electric"
              2: "Heat - Natural Gas"
              4: "Heat - Other"
              8: "Electricity"
              16: "Cablevision"
              32: "Refrigerator"
              64: "Range"
              128: "Washer"
              256: "Dryer"
              512: "Other major appliance"
              1024: "Furniture"
              2048: "None of the above"
