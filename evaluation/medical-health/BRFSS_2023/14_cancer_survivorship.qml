qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 8: Cancer Type / Module 9: Cancer Treatment / Module 10: Cancer Pain"

  codeInit: |
    has_skin_cancer: {0, 1}
    has_other_cancer: {0, 1}

  blocks:
    # =========================================================================
    # MODULE 8: CANCER SURVIVORSHIP — TYPE OF CANCER (MTOC)
    # =========================================================================
    # Entry filter: respondent reported skin cancer (CCHC.06=1) OR other
    # cancer (CCHC.07=1).  Block precondition enforces this.
    #
    # MTOC.01: How many cancer types (1/2/3+). DK/R → skip to next module.
    # MTOC.02: Age at (first) cancer diagnosis. Editbox 0–97 (97=97+).
    # MTOC.03: Type of cancer. Dropdown of 30 types.
    # =========================================================================
    - id: b_cancer_type
      title: "Module 8: Cancer Survivorship — Type of Cancer"
      precondition:
        - predicate: has_skin_cancer == 1 or has_other_cancer == 1
      items:
        # MTOC.01: Number of cancer types
        - id: q_mtoc_01
          kind: Question
          title: "How many different types of cancer have you had?"
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two"
              3: "Three or more"

        # MTOC.02: Age at (first) cancer diagnosis
        # All MTOC.01 responses (1–3) continue to MTOC.02.
        - id: q_mtoc_02
          kind: Question
          title: "At what age were you (first) told that you had cancer?"
          input:
            control: Editbox
            min: 0
            max: 97
            right: "years (enter 97 for 97 or older)"

        # MTOC.03: Type of cancer (30 categories)
        - id: q_mtoc_03
          kind: Question
          title: "What type of cancer was it?"
          input:
            control: Dropdown
            labels:
              1: "Bladder"
              2: "Blood"
              3: "Bone"
              4: "Brain"
              5: "Breast"
              6: "Cervix"
              7: "Colon"
              8: "Esophagus"
              9: "Gallbladder"
              10: "Kidney"
              11: "Larynx-trachea"
              12: "Leukemia"
              13: "Liver"
              14: "Lung"
              15: "Lymphoma"
              16: "Melanoma"
              17: "Mouth/tongue/lip"
              18: "Ovary"
              19: "Pancreas"
              20: "Prostate"
              21: "Rectum"
              22: "Skin (non-melanoma)"
              23: "Skin (unknown type)"
              24: "Soft tissue"
              25: "Stomach"
              26: "Testis"
              27: "Throat-pharynx"
              28: "Thyroid"
              29: "Uterus"
              30: "Other"

    # =========================================================================
    # MODULE 9: CANCER SURVIVORSHIP — COURSE OF TREATMENT (MCOT)
    # =========================================================================
    # Entry filter: same as Module 8 — respondent had skin or other cancer.
    #
    # MCOT.01: Treatment status. Option 3 (refused treatment) → skip to next
    #   module. All others → MCOT.02.
    # MCOT.02: Primary doctor type. Dropdown 10 options.
    # MCOT.03: Written treatment summary received. Switch.
    # MCOT.04: Instructions for follow-up check-ups. Switch.
    #   Yes (1) → MCOT.05; No/DK/R → MCOT.06.
    # MCOT.05: Instructions were written. Switch.
    #   Precondition: MCOT.04 == 1.
    # MCOT.06: Health insurance covered treatment. Switch.
    # MCOT.07: Denied insurance due to cancer. Switch.
    # MCOT.08: Participated in clinical trial. Switch.
    # =========================================================================
    - id: b_cancer_treatment
      title: "Module 9: Cancer Survivorship — Course of Treatment"
      precondition:
        - predicate: has_skin_cancer == 1 or has_other_cancer == 1
      items:
        # MCOT.01: Current treatment status
        # Option 3 (refused treatment) ends the module; all others continue.
        - id: q_mcot_01
          kind: Question
          title: "Are you currently receiving treatment for cancer?"
          input:
            control: Dropdown
            labels:
              1: "Yes, currently receiving treatment"
              2: "No, completed treatment"
              3: "No, refused treatment"
              4: "No, haven't started treatment"
              5: "Treatment not necessary"

        # MCOT.02–08: Only asked if treatment was not refused (MCOT.01 != 3)
        # MCOT.02: Primary doctor type
        - id: q_mcot_02
          kind: Question
          title: "What type of doctor provides the majority of your health care?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Dropdown
            labels:
              1: "Cancer Surgeon"
              2: "Family Practitioner"
              3: "General Surgeon"
              4: "Gynecologic Oncologist"
              5: "Internist"
              6: "Plastic/Reconstructive Surgeon"
              7: "Medical Oncologist"
              8: "Radiation Oncologist"
              9: "Urologist"
              10: "Other"

        # MCOT.03: Written treatment summary received
        - id: q_mcot_03
          kind: Question
          title: "Did any doctor, nurse, or other health professional ever give you a written summary of all the cancer treatments that you received?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.04: Instructions for routine follow-up check-ups
        - id: q_mcot_04
          kind: Question
          title: "Have you ever received instructions about where you should return or who you should see for routine cancer check-ups after completing treatment?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.05: Instructions were written/printed
        # Precondition: MCOT.04 = Yes (1)
        - id: q_mcot_05
          kind: Question
          title: "Were these instructions written down or printed on paper for you?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
            - predicate: q_mcot_04.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.06: Health insurance covered cancer treatment
        - id: q_mcot_06
          kind: Question
          title: "With your most recent diagnosis of cancer, did you have health insurance that paid for all or part of your cancer treatment?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.07: Denied insurance due to cancer
        - id: q_mcot_07
          kind: Question
          title: "Were you ever denied health insurance or life insurance coverage because of your cancer?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCOT.08: Participated in a clinical trial
        - id: q_mcot_08
          kind: Question
          title: "Did you participate in a clinical trial as part of your cancer treatment?"
          precondition:
            - predicate: q_mcot_01.outcome != 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # MODULE 10: CANCER SURVIVORSHIP — PAIN MANAGEMENT (MCPM)
    # =========================================================================
    # Entry filter: same as Modules 8 & 9 — respondent had skin or other cancer.
    #
    # MCPM.01: Currently experiencing cancer-related pain. Switch.
    #   Yes (1) → MCPM.02; No/DK/R → end of module.
    # MCPM.02: Pain control status. Radio (4 options).
    #   Precondition: MCPM.01 == 1.
    # =========================================================================
    - id: b_cancer_pain
      title: "Module 10: Cancer Survivorship — Pain Management"
      precondition:
        - predicate: has_skin_cancer == 1 or has_other_cancer == 1
      items:
        # MCPM.01: Currently has cancer-related pain
        - id: q_mcpm_01
          kind: Question
          title: "Do you currently have physical pain caused by your cancer or cancer treatment?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MCPM.02: Pain control status
        # Precondition: MCPM.01 = Yes (1)
        - id: q_mcpm_02
          kind: Question
          title: "Would you say your pain is currently under control?"
          precondition:
            - predicate: q_mcpm_01.outcome == 1
          input:
            control: Radio
            labels:
              1: "With medication"
              2: "Without medication"
              3: "Not under control, with medication"
              4: "Not under control, without medication"
