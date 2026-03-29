qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 3: Arthritis"

  codeInit: |
    # Extern variable from Core Section 7 (CCHC.11)
    # 1=Yes (has arthritis), 0=No
    has_arthritis: {0, 1}

  blocks:
    # =========================================================================
    # MODULE 3: ARTHRITIS (MARTH)
    # =========================================================================
    # Module filter: Ask only if CCHC.11=1 (respondent has arthritis).
    # =========================================================================
    - id: b_arthritis
      title: "Module 3: Arthritis"
      precondition:
        - predicate: has_arthritis == 1
      items:
        # MARTH.01: Physical activity suggested
        - id: q_marth_01
          kind: Question
          title: "Has a doctor or other health professional ever suggested physical activity or exercise to help your arthritis or joint symptoms?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MARTH.02: Educational course for arthritis management
        - id: q_marth_02
          kind: Question
          title: "Have you ever taken an educational course or class to teach you how to manage problems related to your arthritis or joint symptoms?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MARTH.03: Limited in usual activities due to arthritis
        - id: q_marth_03
          kind: Question
          title: "Are you now limited in any way in any of your usual activities because of arthritis or joint symptoms?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MARTH.04: Arthritis affects work
        - id: q_marth_04
          kind: Question
          title: "Do arthritis or joint symptoms now affect whether you work, the type of work you do or the amount of work you do?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MARTH.05: Joint pain scale (0–10) in past 30 days
        - id: q_marth_05
          kind: Question
          title: "During the past 30 days, how bad was your joint pain on average on a scale of 0 to 10 where 0 is no pain and 10 is pain as bad as it can be?"
          input:
            control: Editbox
            min: 0
            max: 10
