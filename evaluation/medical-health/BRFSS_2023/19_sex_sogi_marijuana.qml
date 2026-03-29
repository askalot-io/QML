qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 21: Sex at Birth / Module 22: Sexual Orientation and Gender Identity / Module 23: Marijuana Use"

  codeInit: |
    # Extern variable: sex as recorded in intro sections (LL09/CP05)
    # 1=Male, 2=Female, 3=Unspecified (not yet recorded in intro)
    sex_from_intro: {1, 2, 3}

    # Extern variable: sex at birth (resolved from intro or MSAB.01)
    # 1=Male, 2=Female
    sex_at_birth: {1, 2}

    # Counter for number of marijuana use methods answered Yes (MMU.02–06)
    method_count = 0

  blocks:
    # =========================================================================
    # MODULE 21: SEX AT BIRTH (MSAB)
    # =========================================================================
    # Module filter: If LL10 or CP06 already coded sex as 1 or 2, auto-code
    # MSAB.01 and skip the question. In QML this is modelled as:
    # ask only when sex_from_intro == 3 (not yet specified in intro).
    # =========================================================================
    - id: b_sex_at_birth
      title: "Module 21: Sex at Birth"
      items:
        # MSAB.01: Sex at birth — asked only when intro sex was unspecified
        - id: q_msab_01
          kind: Question
          title: "What was your sex at birth? Was it male or female?"
          precondition:
            - predicate: sex_from_intro == 3
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

    # =========================================================================
    # MODULE 22: SEXUAL ORIENTATION AND GENDER IDENTITY (SOGI)
    # =========================================================================
    # MSOGI.FILTER1 routes by sex:
    #   Male (sex_at_birth == 1) → ask MSOGI.01 (male version), skip MSOGI.02
    #   Female (sex_at_birth == 2) → skip MSOGI.01, ask MSOGI.02 (female version)
    # MSOGI.03: Always asked (transgender question), no routing condition.
    # =========================================================================
    - id: b_sogi
      title: "Module 22: Sexual Orientation and Gender Identity"
      items:
        # MSOGI.01: Sexual orientation — male version
        # Precondition: sex at birth is Male
        - id: q_msogi_01
          kind: Question
          title: "Which of the following best represents how you think of yourself?"
          precondition:
            - predicate: sex_at_birth == 1
          input:
            control: Radio
            labels:
              1: "Gay"
              2: "Straight, that is, not gay"
              3: "Bisexual"
              4: "Something else"

        # MSOGI.02: Sexual orientation — female version
        # Precondition: sex at birth is Female
        - id: q_msogi_02
          kind: Question
          title: "Which of the following best represents how you think of yourself?"
          precondition:
            - predicate: sex_at_birth == 2
          input:
            control: Radio
            labels:
              1: "Lesbian or Gay"
              2: "Straight, that is, not gay"
              3: "Bisexual"
              4: "Something else"

        # MSOGI.03: Transgender identity — always asked
        - id: q_msogi_03
          kind: Question
          title: "Do you consider yourself to be transgender?"
          input:
            control: Radio
            labels:
              1: "Yes, male-to-female"
              2: "Yes, female-to-male"
              3: "Yes, gender nonconforming"
              4: "No"

    # =========================================================================
    # MODULE 23: MARIJUANA USE (MMU)
    # =========================================================================
    # MMU.01: Days of use in past 30 days (0 = none → skip rest of module).
    #   0 → skip MMU.02–07
    #   1–30 → ask MMU.02 onward
    #   Note: original codes 88=None (skip) and 77=DK (ask); modelled as:
    #   0 skips follow-up questions; >0 proceeds to method questions.
    #
    # MMU.02–06: Use method questions (Switch). Each increments method_count
    #   via codeBlock when answered Yes.
    #
    # MMU.07: Most-used method — asked only when >1 method was used (method_count > 1).
    # =========================================================================
    - id: b_marijuana
      title: "Module 23: Marijuana Use"
      items:
        # MMU.01: Days used marijuana in past 30 days (0 = none)
        - id: q_mmu_01
          kind: Question
          title: "During the past 30 days, on how many days did you use marijuana or cannabis?"
          input:
            control: Editbox
            min: 0
            max: 30
            right: "days (0 = none)"

        # MMU.02: Method — smoked (joint, bong, pipe, blunt)
        # Precondition: used marijuana at least once
        - id: q_mmu_02
          kind: Question
          title: "During the past 30 days, did you smoke marijuana (for example, in a joint, bong, pipe, or blunt)?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_02.outcome == 1:
              method_count = method_count + 1

        # MMU.03: Method — eaten or drunk (brownies, candy, tea, etc.)
        # Precondition: used marijuana at least once
        - id: q_mmu_03
          kind: Question
          title: "During the past 30 days, did you eat or drink marijuana (for example, in brownies, cakes, cookies, or candy, or in tea, cola, or alcohol)?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_03.outcome == 1:
              method_count = method_count + 1

        # MMU.04: Method — vaporized (e-cigarette-like vaporizer)
        # Precondition: used marijuana at least once
        - id: q_mmu_04
          kind: Question
          title: "During the past 30 days, did you vaporize marijuana (for example, in an e-cigarette-like vaporizer or another vaporizing device)?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_04.outcome == 1:
              method_count = method_count + 1

        # MMU.05: Method — dabbed (dabbing rig, knife, dab pen)
        # Precondition: used marijuana at least once
        - id: q_mmu_05
          kind: Question
          title: "During the past 30 days, did you dab marijuana (for example, using a dabbing rig, knife, or dab pen)?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_05.outcome == 1:
              method_count = method_count + 1

        # MMU.06: Method — some other way
        # Precondition: used marijuana at least once
        - id: q_mmu_06
          kind: Question
          title: "During the past 30 days, did you use marijuana in some other way?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
          input:
            control: Switch
            on: "Yes"
            off: "No"
          codeBlock: |
            if q_mmu_06.outcome == 1:
              method_count = method_count + 1

        # MMU.07: Most-used method — asked only when more than one method used
        # Precondition: used marijuana at least once AND more than one method reported Yes
        - id: q_mmu_07
          kind: Question
          title: "During the past 30 days, which one of the following ways did you use marijuana the most often?"
          precondition:
            - predicate: q_mmu_01.outcome > 0
            - predicate: method_count > 1
          input:
            control: Dropdown
            labels:
              1: "Smoke it"
              2: "Eat or drink it"
              3: "Vaporize it"
              4: "Dab it"
              5: "Use some other way"
