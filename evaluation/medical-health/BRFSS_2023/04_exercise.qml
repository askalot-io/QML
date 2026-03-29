qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Core Section 4: Exercise / Physical Activity"
  codeInit: |
    # No extern variables required for this section

  blocks:
    # =========================================================================
    # BLOCK 1: CORE SECTION 4 - EXERCISE / PHYSICAL ACTIVITY (CEXP.01–CEXP.08)
    # =========================================================================
    - id: b_exercise
      title: "Core Section 4: Exercise / Physical Activity"
      items:
        # CEXP.01: Any physical activity past month (besides regular job)
        # 1 (Yes) → CEXP.02; 2 (No) / DK / R → CEXP.08
        - id: q_cexp_01
          kind: Question
          title: "During the past month, other than your regular job, did you participate in any physical activities or exercises such as running, calisthenics, golf, gardening, or walking for exercise?"
          input:
            control: Switch

        # CEXP.02: Type of primary physical activity (activity code from list)
        # Precondition: CEXP.01 = Yes (on)
        # DK / R → CEXP.08 (modeled: if DK/R are not captured, flow continues to CEXP.03)
        # Coded as numeric activity code (1–99)
        - id: q_cexp_02
          kind: Question
          title: "What type of physical activity or exercise did you spend the most time doing during the past month? (Enter the activity code from the Physical Activity Coding List)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99
            right: "activity code"

        # CEXP.03: Frequency of primary activity (times per week or per month)
        # Precondition: CEXP.01 = Yes
        # 1XX = per week (101–176), 2XX = per month (201–230)
        # Modeled as 0–299
        - id: q_cexp_03
          kind: Question
          title: "How many times per week or per month did you take part in this activity during the past month? (Enter 1XX for times per week, e.g. 103 = 3 times/week; or 2XX for times per month, e.g. 212 = 12 times/month)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 299
            right: "frequency code"

        # CEXP.04: Duration of primary activity (minutes per session)
        # Precondition: CEXP.01 = Yes
        - id: q_cexp_04
          kind: Question
          title: "And when you took part in this activity, for how many minutes or hours did you usually keep at it? (Enter minutes)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999
            right: "minutes"

        # CEXP.05: Second most-exercised activity type (or 88 = no other activity)
        # Precondition: CEXP.01 = Yes
        # 88 (No other) / DK / R → CEXP.08
        # Coded as numeric activity code (1–99) or 88
        - id: q_cexp_05
          kind: Question
          title: "What other type of physical activity gave you the next most exercise during the past month? (Enter the activity code, or 88 for no other activity)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99
            right: "activity code (or 88 = none)"

        # CEXP.06: Frequency of second activity
        # Precondition: CEXP.01 = Yes AND CEXP.05 is a valid activity (not 88)
        - id: q_cexp_06
          kind: Question
          title: "How many times per week or per month did you take part in this activity during the past month? (Enter 1XX for times per week or 2XX for times per month)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
            - predicate: q_cexp_05.outcome != 88
          input:
            control: Editbox
            min: 0
            max: 299
            right: "frequency code"

        # CEXP.07: Duration of second activity (minutes per session)
        # Precondition: CEXP.01 = Yes AND CEXP.05 is a valid activity (not 88)
        - id: q_cexp_07
          kind: Question
          title: "And when you took part in this activity, for how many minutes or hours did you usually keep at it? (Enter minutes)"
          precondition:
            - predicate: q_cexp_01.outcome == 1
            - predicate: q_cexp_05.outcome != 88
          input:
            control: Editbox
            min: 0
            max: 999
            right: "minutes"

        # CEXP.08: Muscle-strengthening activity frequency
        # Asked of all respondents (no precondition)
        # 1XX = per week, 2XX = per month, 888 = Never
        - id: q_cexp_08
          kind: Question
          title: "During the past month, how many times per week or per month did you do physical activities or exercises to strengthen your muscles? (Enter 1XX for times per week, 2XX for times per month, or 888 for never)"
          input:
            control: Editbox
            min: 0
            max: 999
            right: "frequency code (or 888 = never)"
