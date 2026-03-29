qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - General Health: Restriction of Activities & Chronic Conditions"
  codeInit: |
    # Variables READ from prior sections
    respondent_age = 0  # respondent's age from demographics section
    is_parent = 0       # 1=respondent is the parent, 0=otherwise

  blocks:
    # =========================================================================
    # BLOCK 1: RESTRICTION OF ACTIVITIES (RESTR)
    # =========================================================================
    # RESTR-CINT: IF AGE<12, GO TO NEXT SECTION
    # "AGE" refers to the respondent's age (General Questionnaire for HH members 12+)
    # Modeled as block-level precondition: respondent_age >= 12
    # =========================================================================
    - id: b_restriction
      title: "Restriction of Activities"
      precondition:
        - predicate: respondent_age >= 12
      items:
        # RESTR-INT: Introduction
        - id: q_restr_int
          kind: Comment
          title: "The next few questions deal with any health limitations which affect daily activities. In these questions, \"long-term conditions\" refer to conditions that have lasted or are expected to last 6 months or more."

        # RESTR-Q1: Activity limitations (a through e)
        # Sub-parts share Radio with Yes/No/Not Applicable.
        # Items (a) At home and (d) Other activities use only Yes/No,
        # but the 3-option scale accommodates all sub-parts uniformly.
        - id: qg_restr_q1
          kind: QuestionGroup
          title: "Because of a long-term physical or mental condition or a health problem, is the child limited in the kind or amount of activity they can do:"
          questions:
            - "(a) At home?"
            - "(b) At school?"
            - "(c) At work?"
            - "(d) In other activities such as transportation to or from work or leisure time activities?"
            - "(e) In caring for children?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"

    # =========================================================================
    # BLOCK 2: CHRONIC CONDITIONS (CHRON)
    # =========================================================================
    # CHRON-CINT: IF AGE<12 OR RESPONDENT IS NOT THE PARENT,
    #             GO TO NEXT SECTION
    # Modeled as block-level precondition: respondent_age >= 12 AND is_parent == 1
    # =========================================================================
    - id: b_chronic
      title: "Chronic Conditions"
      precondition:
        - predicate: respondent_age >= 12
        - predicate: is_parent == 1
      items:
        # CHRON-INT: Introduction
        - id: q_chron_int
          kind: Comment
          title: "Now I'd like to ask about any chronic health conditions the child may have. Again, \"long-term conditions\" refer to conditions that have lasted or are expected to last 6 months or more."

        # CHRON-Q1: Long-term conditions checklist
        # Modeled as QuestionGroup with Switch (Yes/No per condition)
        # rather than Checkbox, because 18+ options make power-of-2
        # encoding impractical.
        # Index mapping:
        #   [0] Food allergies    [1] Other allergies     [2] Asthma
        #   [3] Arthritis         [4] Back problems       [5] High blood pressure
        #   [6] Migraine          [7] Bronchitis/emphysema [8] Sinusitis
        #   [9] Diabetes          [10] Epilepsy           [11] Heart disease
        #   [12] Cancer           [13] Stomach ulcers     [14] Effects of stroke
        #   [15] Urinary incont.  [16] Alzheimer's/dementia [17] Cataracts
        - id: qg_chron_q1
          kind: QuestionGroup
          title: "Does the child have any of the following long-term conditions that have been diagnosed by a health professional:"
          questions:
            - "(a) Food allergies?"
            - "(b) Other allergies?"
            - "(c) Asthma?"
            - "(d) Arthritis or rheumatism?"
            - "(e) Back problems excluding arthritis?"
            - "(f) High blood pressure?"
            - "(g) Migraine headaches?"
            - "(h) Chronic bronchitis or emphysema?"
            - "(i) Sinusitis?"
            - "(j) Diabetes?"
            - "(k) Epilepsy?"
            - "(l) Heart disease?"
            - "(m) Cancer?"
            - "(n) Stomach or intestinal ulcers?"
            - "(o) Effects of stroke?"
            - "(p) Urinary incontinence?"
            - "(r) Alzheimer's disease or other dementia?"
            - "(s) Cataracts?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # CHRON-Q1mm: Cancer type specification (open text)
        # Precondition: cancer [index 12] was selected in CHRON-Q1
        - id: q_chron_q1mm
          kind: Question
          title: "What type(s) of cancer is this? For example, skin, lung or colon cancer."
          precondition:
            - predicate: qg_chron_q1.outcome[12] == 1
          input:
            control: Textarea
            placeholder: "Specify type of cancer..."
            maxLength: 500

        # CHRON-Q1cc1: Asthma attack in past 12 months
        # Precondition: asthma [index 2] was selected in CHRON-Q1
        - id: q_chron_q1cc1
          kind: Question
          title: "Has the child had an attack of asthma in the past 12 months?"
          precondition:
            - predicate: qg_chron_q1.outcome[2] == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CHRON-Q1cc2: Wheezing in past 12 months
        # Precondition: asthma [index 2] was selected in CHRON-Q1
        - id: q_chron_q1cc2
          kind: Question
          title: "Has the child had wheezing or whistling in the chest at any time in the past 12 months?"
          precondition:
            - predicate: qg_chron_q1.outcome[2] == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
