qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Modules 25-28: Flu Vaccination Place / HPV / Tdap / COVID Vaccination"

  codeInit: |
    # Extern variable from Core Section 13 (CIMM.01)
    # 1=Yes (had flu vaccine in past 12 months), 0=No
    had_flu_vaccine: {0, 1}
    # Extern variable from Core Section 8 (CDEM): respondent age
    age: range(18, 99)

  blocks:
    # =========================================================================
    # MODULE 25: PLACE OF FLU VACCINATION (MFP)
    # =========================================================================
    # Module filter: Ask only if CIMM.01=1 (respondent had flu vaccine in past
    # 12 months).
    # MFP.01: Where respondent received most recent flu shot/vaccine.
    # =========================================================================
    - id: b_flu_place
      title: "Module 25: Place of Flu Vaccination"
      precondition:
        - predicate: had_flu_vaccine == 1
      items:
        # MFP.01: Place where most recent flu vaccine was received
        - id: q_mfp_01
          kind: Question
          title: "At what kind of place did you get your last flu shot or vaccine?"
          input:
            control: Dropdown
            labels:
              1: "Doctor's office or HMO"
              2: "Health department"
              3: "Clinic or health center"
              4: "Senior, recreation, or community center"
              5: "Store (supermarket or drug store)"
              6: "Hospital"
              7: "Emergency room"
              8: "Workplace"
              9: "Some other kind of place"
              10: "Received in Canada or Mexico"
              11: "School"

    # =========================================================================
    # MODULE 26: HPV VACCINATION (MHPV)
    # =========================================================================
    # Module filter: Ask only if age is 18–49 years.
    # MHPV.01: Ever had an HPV vaccination.
    #   1 (Yes) → ask MHPV.02 (number of HPV shots)
    #   2 (No) or 3 (Doctor refused) → skip MHPV.02, go to next module
    #
    # MHPV.02: How many HPV shots received. Precondition: MHPV.01 == 1.
    #   Editbox min 1 max 3 (source captures 1, 2, or 3/all shots).
    # =========================================================================
    - id: b_hpv
      title: "Module 26: HPV Vaccination"
      precondition:
        - predicate: age >= 18 and age <= 49
      items:
        # MHPV.01: Ever had an HPV vaccination
        - id: q_mhpv_01
          kind: Question
          title: "Have you ever had an H.P.V. vaccination?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doctor refused when asked"

        # MHPV.02: Number of HPV shots received
        # Precondition: MHPV.01 = Yes (1)
        - id: q_mhpv_02
          kind: Question
          title: "How many HPV shots did you receive?"
          precondition:
            - predicate: q_mhpv_01.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 3
            right: "doses (1, 2, or 3 for all shots)"

    # =========================================================================
    # MODULE 27: TETANUS DIPHTHERIA / TDAP (MTDAP)
    # =========================================================================
    # MTDAP.01: Tetanus shot in past 10 years, with type differentiation.
    #   All responses → go to next module (no branching).
    # =========================================================================
    - id: b_tdap
      title: "Module 27: Tetanus Diphtheria / Tdap Vaccination"
      items:
        # MTDAP.01: Tetanus shot in past 10 years
        - id: q_mtdap_01
          kind: Question
          title: "Have you received a tetanus shot in the past 10 years?"
          input:
            control: Radio
            labels:
              1: "Yes, received Tdap (combined tetanus and whooping cough vaccine)"
              2: "Yes, tetanus shot but not Tdap"
              3: "Yes, tetanus shot but not sure what type"
              4: "No, did not receive any tetanus shot"

    # =========================================================================
    # MODULE 28: COVID VACCINATION (MCOV)
    # =========================================================================
    # MCOV.01: Received at least one dose of COVID-19 vaccine.
    #   1 (Yes) → ask MCOV.03 (number of doses); skip MCOV.02
    #   2 (No)  → ask MCOV.02 (intent to vaccinate); skip MCOV.03
    #
    # MCOV.02: Intent to get COVID vaccine. Precondition: MCOV.01 == 0 (No).
    #   All responses → go to next module.
    #
    # MCOV.03: Number of COVID vaccinations received. Precondition: MCOV.01 == 1 (Yes).
    #   All responses → go to next module.
    # =========================================================================
    - id: b_covid_vaccination
      title: "Module 28: COVID Vaccination"
      items:
        # MCOV.01: Received at least one dose of COVID-19 vaccine
        - id: q_mcov_01
          kind: Question
          title: "Have you received at least one dose of a COVID-19 vaccination?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOV.02: Intent to receive COVID vaccination
        # Precondition: MCOV.01 = No (0)
        - id: q_mcov_02
          kind: Question
          title: "Would you say you will definitely get a vaccine, will probably get a vaccine, will probably not get a vaccine, or will definitely not get a vaccine?"
          precondition:
            - predicate: q_mcov_01.outcome == 0
          input:
            control: Radio
            labels:
              1: "Will definitely get"
              2: "Will probably get"
              3: "Will probably not get"
              4: "Will definitely not get"

        # MCOV.03: Number of COVID vaccinations received
        # Precondition: MCOV.01 = Yes (1)
        - id: q_mcov_03
          kind: Question
          title: "How many COVID-19 vaccinations have you received?"
          precondition:
            - predicate: q_mcov_01.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "One"
              2: "Two"
              3: "Three"
              4: "Four"
              5: "Five or more"
