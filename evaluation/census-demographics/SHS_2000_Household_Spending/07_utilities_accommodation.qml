qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section J: Utilities and Other Rented Accommodation"

  blocks:
    # =========================================================================
    # BLOCK: UTILITIES AND ACCOMMODATION
    # =========================================================================
    # J_Q01.1-Q01.4: Utility expenses (water, electricity, fuel, heating rental)
    # J_Q02.1-Q02.3: Travel accommodation expenses
    # J_NOTE: Interviewer instruction about non-owned dwellings
    #
    # No routing — all items sequential.
    # Ask both owners and renters. Exclude vacation/secondary residence
    # expenses (reported in Section K).
    # =========================================================================
    - id: b_utilities_accommodation
      title: "Utilities and Other Rented Accommodation"
      items:
        # J_Q01.1: Water and sewage
        - id: q_j_q01_1
          kind: Question
          title: "How much did your household spend in 2000 on water and sewage charges not included in the property tax bill?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q01.2: Electricity
        - id: q_j_q01_2
          kind: Question
          title: "How much did your household spend in 2000 on electricity?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q01.3: Other fuel
        - id: q_j_q01_3
          kind: Question
          title: "How much did your household spend in 2000 on other fuel for heating and cooking (oil, gas, propane, wood)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q01.4: Heating equipment rental
        - id: q_j_q01_4
          kind: Question
          title: "How much did your household spend in 2000 on rental of heating equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q02.1: Hotels and motels
        - id: q_j_q02_1
          kind: Question
          title: "How much did your household spend in 2000 on hotels and motels while away overnight or longer?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q02.2: Other accommodation
        - id: q_j_q02_2
          kind: Question
          title: "How much did your household spend in 2000 on other accommodation (e.g., cottage or cabin rental while away overnight or longer)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_Q02.3: Provincial share
        - id: q_j_q02_3
          kind: Question
          title: "Of the total accommodation amount (Q02.1 + Q02.2), how much was spent in this province?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # J_NOTE: Interviewer instruction
        - id: q_j_note
          kind: Comment
          title: "NOTE TO INTERVIEWER: For expenses on dwellings not owned by household members, report amounts paid for utilities, fuel, and heating equipment rental in this section. Report rent and other tenant expenses in Section I."
