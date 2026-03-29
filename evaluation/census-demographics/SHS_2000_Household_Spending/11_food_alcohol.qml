qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section N: Food and Alcohol"

  blocks:
    # =========================================================================
    # BLOCK: FOOD AND ALCOHOL EXPENDITURES
    # =========================================================================
    # N_Q01-Q07.2: Food from stores, alcohol from stores, restaurant
    # meals and alcohol, board payments.
    # No routing — all sequential expenditure items.
    # =========================================================================
    - id: b_food_alcohol
      title: "Food and Alcohol"
      items:
        # N_Q01: Food and groceries
        - id: q_n_q01
          kind: Question
          title: "How much did your household spend in 2000 on food and groceries from stores (average weekly/monthly multiplied by number of periods)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q01.1: Non-food deduction
        - id: q_n_q01_1
          kind: Question
          title: "Of this amount, how much was spent on non-food items? (This will be deducted from the food total)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q02.1: Additional bulk food
        - id: q_n_q02_1
          kind: Question
          title: "Additional bulk food purchases?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q02.2: Prepared food for events
        - id: q_n_q02_2
          kind: Question
          title: "Prepared food for parties, weddings, etc.?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q02.3: Food from stores while away
        - id: q_n_q02_3
          kind: Question
          title: "Food purchased from stores while away overnight or longer?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q03: Alcohol from stores
        - id: q_n_q03
          kind: Question
          title: "Alcoholic beverages from stores?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q04: Self-made alcohol supplies
        - id: q_n_q04
          kind: Question
          title: "Supplies and fees for self-made beer, wine or liquor?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q05: Restaurant meals
        - id: q_n_q05
          kind: Question
          title: "Meals and snacks from restaurants?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q05.1: Restaurant meals — provincial share
        - id: q_n_q05_1
          kind: Question
          title: "Of the restaurant meals amount, how much was spent in this province?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q06: Restaurant alcohol
        - id: q_n_q06
          kind: Question
          title: "Alcoholic beverages from bars and restaurants?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q06.1: Restaurant alcohol — provincial share
        - id: q_n_q06_1
          kind: Question
          title: "Of the restaurant alcohol amount, how much was spent in this province?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q07.1: Board — day board and children's lunches
        - id: q_n_q07_1
          kind: Question
          title: "Board paid for day board and children's lunches?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # N_Q07.2: Board — away overnight
        - id: q_n_q07_2
          kind: Question
          title: "Board while away from home overnight or longer?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
