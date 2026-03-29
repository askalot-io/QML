qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 11: Indoor Tanning / Module 12: Sun Exposure / Module 13: Cognitive Decline"

  codeInit: |
    age: range(18, 99)

  blocks:
    # =========================================================================
    # MODULE 11: INDOOR TANNING (MNTAN)
    # =========================================================================
    # Single item, no entry filter, no skip logic.
    # MNTAN.01: Number of indoor tanning sessions in past 12 months (0–365).
    # =========================================================================
    - id: b_indoor_tanning
      title: "Module 11: Indoor Tanning"
      items:
        # MNTAN.01: Indoor tanning device use in past 12 months
        - id: q_mntan_01
          kind: Question
          title: "Not including spray-on tans, during the past 12 months, how many times have you used an indoor tanning device such as a sunlamp, tanning bed, or booth?"
          input:
            control: Editbox
            min: 0
            max: 365
            right: "times (0–365)"

    # =========================================================================
    # MODULE 12: EXCESS SUN EXPOSURE (MSUN)
    # =========================================================================
    # No entry filter. All four items are asked sequentially.
    #
    # MSUN.01: Number of sunburns in past 12 months (0–365).
    # MSUN.02: Frequency of sun protection. Dropdown (7 options — includes
    #   "Don't stay outside 1+ hour" and "Don't go outside at all").
    # MSUN.03: Weekday outdoor time in summer (10am–4pm). Dropdown (7 ranges).
    # MSUN.04: Weekend outdoor time in summer (10am–4pm). Dropdown (7 ranges).
    # =========================================================================
    - id: b_sun_exposure
      title: "Module 12: Excess Sun Exposure"
      items:
        # MSUN.01: Number of sunburns in past 12 months
        - id: q_msun_01
          kind: Question
          title: "During the past 12 months, how many times have you had a sunburn?"
          input:
            control: Editbox
            min: 0
            max: 365
            right: "times (0–365)"

        # MSUN.02: Frequency of sun protection on warm sunny days
        - id: q_msun_02
          kind: Question
          title: "When you go outside on a warm sunny day for more than one hour, how often do you protect yourself from the sun?"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Most of the time"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"
              6: "Don't stay outside 1 hour or longer"
              8: "Don't go outside at all on warm sunny days"

        # MSUN.03: Weekday outdoor time (summer, 10am–4pm)
        - id: q_msun_03
          kind: Question
          title: "On weekdays, in the summer, how long are you outside per day between 10am and 4pm?"
          input:
            control: Dropdown
            labels:
              1: "Less than 30 minutes"
              2: "30 minutes to less than 1 hour"
              3: "1 to less than 2 hours"
              4: "2 to less than 3 hours"
              5: "3 to less than 4 hours"
              6: "4 to less than 5 hours"
              7: "5 to less than 6 hours"

        # MSUN.04: Weekend outdoor time (summer, 10am–4pm)
        - id: q_msun_04
          kind: Question
          title: "On weekends in the summer, how long are you outside each day between 10am and 4pm?"
          input:
            control: Dropdown
            labels:
              1: "Less than 30 minutes"
              2: "30 minutes to less than 1 hour"
              3: "1 to less than 2 hours"
              4: "2 to less than 3 hours"
              5: "3 to less than 4 hours"
              6: "4 to less than 5 hours"
              7: "5 to less than 6 hours"

    # =========================================================================
    # MODULE 13: COGNITIVE DECLINE (MCOG)
    # =========================================================================
    # Entry filter: age >= 45 (source filter excludes respondents 18–44).
    # Block precondition enforces this.
    #
    # MCOG.01: Experienced worsening thinking/memory difficulties. Switch.
    #   Yes (1) → MCOG.02–05; No/DK/R → skip to next module.
    # MCOG.02–05: Precondition: MCOG.01 == 1. All Switch items.
    # =========================================================================
    - id: b_cognitive_decline
      title: "Module 13: Cognitive Decline"
      precondition:
        - predicate: age >= 45
      items:
        # MCOG.01: Worsening thinking or memory difficulties in past 12 months
        - id: q_mcog_01
          kind: Question
          title: "During the past 12 months, have you experienced difficulties with thinking or memory that are happening more often or are getting worse?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOG.02: Worried about these difficulties
        # Precondition: MCOG.01 = Yes (1)
        - id: q_mcog_02
          kind: Question
          title: "Are you worried about these difficulties with thinking or memory?"
          precondition:
            - predicate: q_mcog_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOG.03: Discussed with health care provider
        # Precondition: MCOG.01 = Yes (1)
        - id: q_mcog_03
          kind: Question
          title: "Have you or anyone else discussed your difficulties with thinking or memory with a health care provider?"
          precondition:
            - predicate: q_mcog_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOG.04: Interfered with day-to-day activities
        # Precondition: MCOG.01 = Yes (1)
        - id: q_mcog_04
          kind: Question
          title: "During the past 12 months, have your difficulties with thinking or memory interfered with day-to-day activities?"
          precondition:
            - predicate: q_mcog_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOG.05: Interfered with ability to work or volunteer
        # Precondition: MCOG.01 = Yes (1)
        - id: q_mcog_05
          kind: Question
          title: "During the past 12 months, have your difficulties with thinking or memory interfered with your ability to work or volunteer?"
          precondition:
            - predicate: q_mcog_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
