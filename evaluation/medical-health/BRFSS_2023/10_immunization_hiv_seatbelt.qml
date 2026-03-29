qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Core Sections 13-15: Immunization / HIV-AIDS / Seat Belt + Emerging Core: COVID"

  codeInit: |
    age: range(18, 99)
    alcohol_days: range(0, 30)

  blocks:
    # =========================================================================
    # CORE 13: IMMUNIZATION (CIMM.01–CIMM.04)
    # =========================================================================
    # CIMM.01: Flu vaccine in past 12 months.
    #   1 (Yes) → ask CIMM.02 (flu vaccine date)
    #   2 (No)  → skip CIMM.02, go to CIMM.03
    #
    # CIMM.02: Month of most recent flu vaccine. Precondition: CIMM.01 == 1.
    #   Date collected as month (1–12) since the source instrument collects MM/YYYY;
    #   year is not modeled here as it is always within the past 12 months.
    #
    # CIMM.03: Ever had pneumonia / pneumococcal vaccine — always asked.
    #
    # CIMM.04: Ever had shingles / zoster vaccine.
    #   Precondition: age >= 50 (only relevant for respondents 50 or older).
    # =========================================================================
    - id: b_immunization
      title: "Core Section 13: Immunization"
      items:
        # CIMM.01: Flu vaccine in past 12 months
        - id: q_cimm_01
          kind: Question
          title: "During the past 12 months, have you had either a flu vaccine that was sprayed in your nose or a flu shot injected into your arm?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CIMM.02: Month of most recent flu vaccine
        # Precondition: CIMM.01 = Yes (1)
        - id: q_cimm_02
          kind: Question
          title: "During what month did you receive your most recent flu vaccine?"
          precondition:
            - predicate: q_cimm_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 12
            right: "month (1 = January, 12 = December)"

        # CIMM.03: Ever had pneumonia / pneumococcal vaccine
        # No skip routing; always asked after CIMM.01 (or CIMM.02 if flu shot).
        - id: q_cimm_03
          kind: Question
          title: "Have you ever had a pneumonia shot also known as a pneumococcal vaccine?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CIMM.04: Ever had shingles / zoster vaccine
        # Precondition: age >= 50 (instrument routes age < 50 to next section)
        - id: q_cimm_04
          kind: Question
          title: "Have you ever had the shingles or zoster vaccine?"
          precondition:
            - predicate: age >= 50
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # CORE 14: H.I.V. / AIDS (CHIV.01–CHIV.02)
    # =========================================================================
    # CHIV.01: Ever been tested for HIV.
    #   1 (Yes) → ask CHIV.02 (date of last test)
    #   2 (No)  → skip CHIV.02, go to next section
    #
    # CHIV.02: Month of most recent HIV test. Precondition: CHIV.01 == 1.
    # =========================================================================
    - id: b_hiv
      title: "Core Section 14: H.I.V./AIDS"
      items:
        # CHIV.01: Ever been tested for HIV (excluding blood donation tests)
        - id: q_chiv_01
          kind: Question
          title: "Including fluid testing from your mouth, but not including tests you may have had for blood donation, have you ever been tested for H.I.V?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHIV.02: Month of most recent HIV test
        # Precondition: CHIV.01 = Yes (1)
        - id: q_chiv_02
          kind: Question
          title: "Not including blood donations, in what month was your last H.I.V. test?"
          precondition:
            - predicate: q_chiv_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 12
            right: "month (1 = January, 12 = December)"

    # =========================================================================
    # CORE 15: SEAT BELT / DRINKING AND DRIVING (CSBD.01–CSBD.02)
    # =========================================================================
    # CSBD.01: Seat belt use frequency.
    #   8 (Never drive or ride in a car) → skip CSBD.02, go to next section
    #   All other responses → CSBD.FILTER
    #
    # CSBD.FILTER: If alcohol_days == 0 (no drinks in past 30 days) →
    #              skip CSBD.02, go to next section.
    #
    # CSBD.02: Driving after drinking too much.
    #   Precondition: CSBD.01 != 8 (respondent drives or rides)
    #             AND alcohol_days > 0 (drank in past 30 days)
    # =========================================================================
    - id: b_seatbelt
      title: "Core Section 15: Seat Belt Use / Drinking and Driving"
      items:
        # CSBD.01: Seat belt use frequency
        - id: q_csbd_01
          kind: Question
          title: "How often do you use seat belts when you drive or ride in a car? Would you say—"
          input:
            control: Dropdown
            labels:
              1: "Always"
              2: "Nearly always"
              3: "Sometimes"
              4: "Seldom"
              5: "Never"
              8: "Never drive or ride in a car"

        # CSBD.02: Times driven after perhaps too much to drink (past 30 days)
        # Precondition: respondent drives/rides AND drank in past 30 days
        - id: q_csbd_02
          kind: Question
          title: "During the past 30 days, how many times have you driven when you've had perhaps too much to drink?"
          precondition:
            - predicate: q_csbd_01.outcome != 8
            - predicate: alcohol_days > 0
          input:
            control: Editbox
            min: 0
            max: 76
            right: "times (0 = none)"

    # =========================================================================
    # EMERGING CORE: LONG-TERM COVID EFFECTS (COVID.01–COVID.03)
    # =========================================================================
    # COVID.01: Ever tested positive for COVID-19 or diagnosed by provider.
    #   1 (Yes) → ask COVID.02
    #   2 (No)  → skip COVID.02 and COVID.03, go to closing/modules
    #
    # COVID.02: Currently have long-term symptoms (3+ months).
    #   Precondition: COVID.01 == 1
    #   1 (Yes) → ask COVID.03
    #   2 (No)  → skip COVID.03, go to closing/modules
    #
    # COVID.03: Long-term symptoms reduce day-to-day activities.
    #   Precondition: COVID.01 == 1 AND COVID.02 == 1
    # =========================================================================
    - id: b_covid
      title: "Emerging Core: Long-term COVID Effects"
      items:
        # COVID.01: Ever diagnosed with / tested positive for COVID-19
        - id: q_covid_01
          kind: Question
          title: "Have you ever tested positive for COVID-19 or been told by a doctor or other health care provider that you have or had COVID-19?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # COVID.02: Currently experiencing long-term COVID symptoms (3+ months)
        # Precondition: COVID.01 = Yes (1)
        - id: q_covid_02
          kind: Question
          title: "Do you currently have symptoms lasting 3 months or longer that you did not have prior to having coronavirus or COVID-19?"
          precondition:
            - predicate: q_covid_01.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # COVID.03: Extent to which long-term symptoms limit day-to-day activities
        # Precondition: COVID.01 = Yes (1) AND COVID.02 = Yes (1)
        - id: q_covid_03
          kind: Question
          title: "Do these long-term symptoms reduce your ability to carry out day-to-day activities compared with the time before you had COVID-19?"
          precondition:
            - predicate: q_covid_01.outcome == 1
            - predicate: q_covid_02.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, a lot"
              2: "Yes, a little"
              3: "Not at all"
