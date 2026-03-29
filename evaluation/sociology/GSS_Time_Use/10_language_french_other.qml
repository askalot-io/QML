qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language (French and Other)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {1, 2, 3, 4, 5, 6, 7}

  blocks:
    # =========================================================================
    # BLOCK: SECTION L — French and Other language
    # =========================================================================
    # Routing summary:
    #   L1 → L2 → L3 → L4 → L5 → Section N
    #   All items always asked (no conditional branching within section)
    # =========================================================================
    - id: b_section_l
      title: "Language — French and Other"
      precondition:
        - predicate: lang_path == 5
      items:
        # L1: French change compared to 5 years ago (Know, Use)
        - id: qg_l1
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # L2: English reading ability
        - id: q_l2
          kind: Question
          title: "How would you rate your ability to read in English? Is it..."
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # L3: English knowledge sources
        - id: q_l3
          kind: Question
          title: "What would you say contributed the most to your present knowledge of English?"
          input:
            control: Checkbox
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              4: "Speaking with family"
              8: "Speaking with friends"
              16: "Speaking at work"
              32: "Watching television"
              64: "Other"

        # L3_other: Specify other source
        # Precondition: "Other" selected in L3
        - id: q_l3_other
          kind: Question
          title: "Please specify the other source of English knowledge:"
          precondition:
            - predicate: q_l3.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # L4: English change compared to 5 years ago (Know, Use)
        - id: qg_l4
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more English, less English, or about the same?"
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # L5: Other languages count
        - id: q_l5
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          input:
            control: Editbox
            min: 1
            max: 20
            right: "language(s)"

        # L6 is routing only (GO TO SECTION N) — omitted
