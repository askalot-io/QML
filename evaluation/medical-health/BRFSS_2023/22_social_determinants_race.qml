qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 29: Social Determinants and Health Equity / Module 30: Reactions to Race"

  codeInit: |
    # Extern variable from Core Section 8 (CDEM.13): employment status
    # 1=Employed for wages, 2=Self-employed, 3=Out of work 1+ year,
    # 4=Out of work <1 year, 5=Homemaker, 6=Student, 7=Retired, 8=Unable to work
    employment_status: {1, 2, 3, 4, 5, 6, 7, 8}

  blocks:
    # =========================================================================
    # MODULE 29: SOCIAL DETERMINANTS AND HEALTH EQUITY (MSDHE)
    # =========================================================================
    # All 10 items are sequential with no branching; all respondents are asked
    # every item regardless of prior responses.
    # =========================================================================
    - id: b_social_determinants
      title: "Module 29: Social Determinants and Health Equity"
      items:
        # MSDHE.01: Overall life satisfaction
        - id: q_msdhe_01
          kind: Question
          title: "In general, how satisfied are you with your life?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Satisfied"
              3: "Dissatisfied"
              4: "Very dissatisfied"

        # MSDHE.02: Frequency of receiving needed social and emotional support
        - id: q_msdhe_02
          kind: Question
          title: "How often do you get the social and emotional support that you need?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # MSDHE.03: Frequency of feeling lonely
        - id: q_msdhe_03
          kind: Question
          title: "How often do you feel lonely?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # MSDHE.04: Lost employment or had hours reduced in past 12 months
        - id: q_msdhe_04
          kind: Question
          title: "In the past 12 months have you lost employment or had hours reduced?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.05: Received SNAP (food stamps) in past 12 months
        - id: q_msdhe_05
          kind: Question
          title: "During the past 12 months, have you received food stamps, also called SNAP?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.06: Frequency of food running out before able to get more
        - id: q_msdhe_06
          kind: Question
          title: "During the past 12 months how often did the food that you bought not last, and you didn't have money to get more?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # MSDHE.07: Unable to pay mortgage, rent, or utility bills in past 12 months
        - id: q_msdhe_07
          kind: Question
          title: "During the last 12 months, was there a time when you were not able to pay your mortgage, rent or utility bills?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.08: Utility shutoff threatened in past 12 months
        - id: q_msdhe_08
          kind: Question
          title: "During the last 12 months was there a time when an electric, gas, oil, or water company threatened to shut off services?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.09: Lack of reliable transportation affected daily activities in past 12 months
        - id: q_msdhe_09
          kind: Question
          title: "During the past 12 months has a lack of reliable transportation kept you from medical appointments, meetings, work, or from getting things needed for daily living?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MSDHE.10: Frequency of stress in past 30 days
        - id: q_msdhe_10
          kind: Question
          title: "Within the last 30 days, how often have you felt stress?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

    # =========================================================================
    # MODULE 30: REACTIONS TO RACE (MRTR)
    # =========================================================================
    # MRTR.01–MRTR.03: Asked of all respondents.
    # MRTR.04: Asked only if employed or out of work < 1 year (CDEM.13=1,2,4).
    # MRTR.05–MRTR.06: Asked of all respondents.
    # =========================================================================
    - id: b_reactions_race
      title: "Module 30: Reactions to Race"
      items:
        # MRTR.01: How other people usually classify respondent by race
        - id: q_mrtr_01
          kind: Question
          title: "How do other people usually classify you in this country?"
          input:
            control: Dropdown
            labels:
              1: "White"
              2: "Black or African American"
              3: "Hispanic or Latino"
              4: "Asian"
              5: "Native Hawaiian or Other Pacific Islander"
              6: "American Indian or Alaska Native"
              7: "Mixed Race"
              8: "Some other group"

        # MRTR.02: How often respondent thinks about their race
        - id: q_mrtr_02
          kind: Question
          title: "How often do you think about your race?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "Once a year"
              3: "Once a month"
              4: "Once a week"
              5: "Once a day"
              6: "Once an hour"
              8: "Constantly"

        # MRTR.03: Racial treatment in general in past 12 months
        - id: q_mrtr_03
          kind: Question
          title: "Within the past 12 months, do you feel that in general you were treated worse than, the same as, or better than people of other races?"
          input:
            control: Dropdown
            labels:
              1: "Worse"
              2: "The same"
              3: "Better"
              4: "Worse than some, better than others"
              5: "Only encountered people of same race"

        # MRTR.04: Racial treatment at work in past 12 months
        # Precondition: CDEM.13 = 1 (employed for wages), 2 (self-employed),
        #               or 4 (out of work less than 1 year)
        - id: q_mrtr_04
          kind: Question
          title: "Within the past 12 months at work, do you feel you were treated worse than, the same as, or better than people of other races?"
          precondition:
            - predicate: employment_status in [1, 2, 4]
          input:
            control: Dropdown
            labels:
              1: "Worse"
              2: "The same"
              3: "Better"
              4: "Worse than some, better than others"
              5: "Only encountered people of same race"

        # MRTR.05: Racial treatment when seeking health care in past 12 months
        - id: q_mrtr_05
          kind: Question
          title: "Within the past 12 months, when seeking health care, do you feel your experiences were worse than, the same as, or better than for people of other races?"
          input:
            control: Dropdown
            labels:
              1: "Worse"
              2: "The same"
              3: "Better"
              4: "Worse than some, better than others"
              5: "Only encountered people of same race"

        # MRTR.06: Physical symptoms from race-based treatment in past 30 days
        - id: q_mrtr_06
          kind: Question
          title: "Within the past 30 days, have you experienced any physical symptoms as a result of how you were treated based on your race?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
