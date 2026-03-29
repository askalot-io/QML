qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Core 7: Chronic Health Conditions"

  codeInit: |
    # No extern variables required for this section

  blocks:
    # =========================================================================
    # CORE 7: CHRONIC HEALTH CONDITIONS (CCHC)
    # =========================================================================
    # CCHC.01–03: Always asked, sequential, no skip logic.
    # CCHC.04: Always asked.
    #   1 (Yes) → ask CCHC.05; 2 (No) / 7 (DK) / 9 (R) → skip CCHC.05
    # CCHC.05: Precondition: CCHC.04 == 1 (Yes).
    # CCHC.06–11: Always asked, sequential, no skip logic.
    # CCHC.12: Always asked.
    #   1 (Yes) → ask CCHC.13; 2 / 3 / 4 / 7 / 9 → skip CCHC.13
    # CCHC.13: Precondition: CCHC.12 == 1 (Yes — active diabetes).
    # =========================================================================
    - id: b_chronic_conditions
      title: "Chronic Health Conditions"
      items:
        # CCHC.01: Heart attack / myocardial infarction
        - id: q_cchc_01
          kind: Question
          title: "(Ever told) you had a heart attack also called a myocardial infarction?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.02: Angina or coronary heart disease
        - id: q_cchc_02
          kind: Question
          title: "(Ever told) (you had) angina or coronary heart disease?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.03: Stroke
        - id: q_cchc_03
          kind: Question
          title: "(Ever told) (you had) a stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.04: Asthma (ever told)
        - id: q_cchc_04
          kind: Question
          title: "(Ever told) (you had) asthma?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.05: Still have asthma
        # Precondition: CCHC.04 = Yes (1)
        - id: q_cchc_05
          kind: Question
          title: "Do you still have asthma?"
          precondition:
            - predicate: q_cchc_04.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.06: Skin cancer (non-melanoma)
        - id: q_cchc_06
          kind: Question
          title: "(Ever told) (you had) skin cancer that is not melanoma?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.07: Melanoma or other cancer
        - id: q_cchc_07
          kind: Question
          title: "(Ever told) (you had) any melanoma or any other types of cancer?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.08: COPD / emphysema / chronic bronchitis
        - id: q_cchc_08
          kind: Question
          title: "(Ever told) (you had) C.O.P.D., emphysema or chronic bronchitis?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.09: Depressive disorder
        - id: q_cchc_09
          kind: Question
          title: "(Ever told) (you had) a depressive disorder (including depression, major depression, dysthymia, or minor depression)?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.10: Kidney disease (excluding stones, bladder infection, incontinence)
        - id: q_cchc_10
          kind: Question
          title: "Not including kidney stones, bladder infection or incontinence, were you ever told you had kidney disease?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.11: Arthritis / rheumatoid arthritis / gout / lupus / fibromyalgia
        - id: q_cchc_11
          kind: Question
          title: "(Ever told) (you had) some form of arthritis, rheumatoid arthritis, gout, lupus, or fibromyalgia?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHC.12: Diabetes
        - id: q_cchc_12
          kind: Question
          title: "(Ever told) (you had) diabetes?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, but only during pregnancy"
              3: "No"
              4: "No, pre-diabetes or borderline diabetes"

        # CCHC.13: Age first told had diabetes
        # Precondition: CCHC.12 = Yes (1) — active diabetes diagnosis only
        - id: q_cchc_13
          kind: Question
          title: "How old were you when you were first told you had diabetes?"
          precondition:
            - predicate: q_cchc_12.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 97
