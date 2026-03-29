qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Core Section 11: Tobacco Use / Core Section 12: Alcohol Consumption"

  codeInit: |
    # No extern variables required for this section

  blocks:
    # =========================================================================
    # CORE 11: TOBACCO USE (CTOB.01–CTOB.04)
    # =========================================================================
    # CTOB.01: Have you smoked 100+ cigarettes in your entire life?
    #   1 (Yes) → ask CTOB.02
    #   2 (No)  → skip CTOB.02, go to CTOB.03
    #
    # CTOB.02: Current cigarette smoking frequency. Precondition: CTOB.01 == 1.
    # CTOB.03: Smokeless tobacco use — always asked (no skip routing).
    # CTOB.04: E-cigarette / vaping use — always asked.
    # =========================================================================
    - id: b_tobacco
      title: "Core Section 11: Tobacco Use"
      items:
        # CTOB.01: 100+ cigarettes smoked in lifetime
        - id: q_ctob_01
          kind: Question
          title: "Have you smoked at least 100 cigarettes in your entire life?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CTOB.02: Current cigarette smoking frequency
        # Precondition: CTOB.01 = Yes (1)
        - id: q_ctob_02
          kind: Question
          title: "Do you now smoke cigarettes every day, some days, or not at all?"
          precondition:
            - predicate: q_ctob_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"

        # CTOB.03: Smokeless tobacco use (chewing tobacco, snuff, snus)
        # No skip routing; always asked regardless of prior answers.
        - id: q_ctob_03
          kind: Question
          title: "Do you currently use chewing tobacco, snuff, or snus every day, some days, or not at all?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Some days"
              3: "Not at all"

        # CTOB.04: E-cigarette / electronic vaping product use
        - id: q_ctob_04
          kind: Question
          title: "Would you say you have never used e-cigarettes or other electronic vaping products in your entire life, or now use them every day, use them some days, or used them in the past but do not currently use them at all?"
          input:
            control: Radio
            labels:
              1: "Never used"
              2: "Use every day"
              3: "Use some days"
              4: "Not at all right now"

    # =========================================================================
    # CORE 12: ALCOHOL CONSUMPTION (CALC.01–CALC.04)
    # =========================================================================
    # CALC.PROLOGUE is a read/instruction node (no response captured).
    #
    # CALC.01: Drinking days in past 30 days.
    #   0 (no drinks) → skip CALC.02–CALC.04, go to next section.
    #   >0            → ask CALC.02 onward.
    #   Note: Original instrument codes "days per week" as 1XX and "days per
    #   month" as 2XX. This file uses a simplified Editbox (0–30 days per month)
    #   consistent with the 30-day reference frame used in follow-up questions.
    #
    # CALC.02: Average drinks per drinking day. Precondition: CALC.01 > 0.
    # CALC.03: Binge drinking occasions. Precondition: CALC.01 > 0.
    #   Threshold varies by sex (5+ drinks for men, 4+ for women); the label
    #   reflects this variation as it appears in the administered instrument.
    # CALC.04: Largest number of drinks on any single occasion. Precondition: CALC.01 > 0.
    # =========================================================================
    - id: b_alcohol
      title: "Core Section 12: Alcohol Consumption"
      items:
        # CALC.PROLOGUE: Introductory instruction (no response captured)
        - id: q_calc_prologue
          kind: Comment
          title: "The next questions concern alcohol consumption. One drink of alcohol is equivalent to a 12-ounce beer, a 5-ounce glass of wine, or a drink with one shot of liquor."

        # CALC.01: Drinking days in past 30 days
        # 0 = no drinks in past 30 days; 1–30 = number of days
        - id: q_calc_01
          kind: Question
          title: "During the past 30 days, how many days per week or per month did you have at least one drink of any alcoholic beverage?"
          input:
            control: Editbox
            min: 0
            max: 30
            right: "days in past 30 days (0 = none)"

        # CALC.02: Average drinks per drinking day
        # Precondition: reported at least one drinking day
        - id: q_calc_02
          kind: Question
          title: "During the past 30 days, on the days when you drank, about how many drinks did you drink on the average?"
          precondition:
            - predicate: q_calc_01.outcome > 0
          input:
            control: Editbox
            min: 1
            max: 76
            right: "drinks"

        # CALC.03: Binge drinking occasions (5+ drinks for men, 4+ for women)
        # Precondition: reported at least one drinking day
        - id: q_calc_03
          kind: Question
          title: "Considering all types of alcoholic beverages, how many times during the past 30 days did you have 5 or more drinks on an occasion (4 or more for women)?"
          precondition:
            - predicate: q_calc_01.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 76
            right: "times (0 = none)"

        # CALC.04: Largest number of drinks on any single occasion
        # Precondition: reported at least one drinking day
        - id: q_calc_04
          kind: Question
          title: "During the past 30 days, what is the largest number of drinks you had on any occasion?"
          precondition:
            - predicate: q_calc_01.outcome > 0
          input:
            control: Editbox
            min: 1
            max: 76
            right: "drinks"
