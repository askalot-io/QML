qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Core 5: Hypertension Awareness / Core 6: Cholesterol Awareness"

  codeInit: |
    # No extern variables required for this section

  blocks:
    # =========================================================================
    # CORE 5: HYPERTENSION AWARENESS (CHYPA)
    # =========================================================================
    # CHYPA.01: Always asked.
    # CHYPA.02: Asked only if CHYPA.01 == 1 (Yes) or == 4 (Borderline/pre-hypertensive)
    #           All other outcomes (2, 3, DK=7, R=9) skip to next section.
    # =========================================================================
    - id: b_hypertension
      title: "Hypertension Awareness"
      items:
        # CHYPA.01: Ever told have high blood pressure
        - id: q_chypa_01
          kind: Question
          title: "Have you ever been told by a doctor, nurse, or other health professional that you have high blood pressure?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, but only told during pregnancy"
              3: "No"
              4: "Told borderline high or pre-hypertensive"

        # CHYPA.02: Currently taking prescription medicine for high blood pressure
        # Precondition: CHYPA.01 = Yes (1) or Borderline (4)
        - id: q_chypa_02
          kind: Question
          title: "Are you currently taking prescription medicine for your high blood pressure?"
          precondition:
            - predicate: q_chypa_01.outcome == 1 or q_chypa_01.outcome == 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # CORE 6: CHOLESTEROL AWARENESS (CCHLA)
    # =========================================================================
    # CCHLA.01: Always asked.
    #   1 (Never) → skip to next section (CCHLA.02 and CCHLA.03 not shown)
    #   2–6, 8 → ask CCHLA.02
    #   9 (R) → ask CCHLA.02 (Refused treated same as checked)
    #   7 (DK) → skip to next section
    # CCHLA.02 → CCHLA.03: Always asked if precondition met (no skip within).
    # =========================================================================
    - id: b_cholesterol
      title: "Cholesterol Awareness"
      items:
        # CCHLA.01: Time since last cholesterol check
        - id: q_cchla_01
          kind: Question
          title: "Cholesterol is a fatty substance found in the blood. About how long has it been since you last had your cholesterol checked?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "Within past year (less than 12 months ago)"
              3: "Within past 2 years (1 year but less than 2 years ago)"
              4: "Within past 3 years (2 years but less than 3 years ago)"
              5: "Within past 4 years (3 years but less than 4 years ago)"
              6: "Within past 5 years (4 years but less than 5 years ago)"
              8: "5 or more years ago"

        # CCHLA.02: Ever told blood cholesterol is high
        # Precondition: CCHLA.01 != 1 (not Never)
        # Note: Refused (9) on CCHLA.01 is also routed here per instrument routing.
        - id: q_cchla_02
          kind: Question
          title: "Have you ever been told by a doctor, nurse or other health professional that your blood cholesterol is high?"
          precondition:
            - predicate: q_cchla_01.outcome != 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CCHLA.03: Currently taking prescribed cholesterol medicine
        # Precondition: CCHLA.01 != 1 (not Never) — same gate as CCHLA.02
        - id: q_cchla_03
          kind: Question
          title: "Are you currently taking medicine prescribed by your doctor or other health professional for your cholesterol?"
          precondition:
            - predicate: q_cchla_01.outcome != 1
          input:
            control: Switch
            on: "Yes"
            off: "No"
