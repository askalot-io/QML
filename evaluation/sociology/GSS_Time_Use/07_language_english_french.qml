qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language (English and French Bilingual)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {1, 2, 3, 4, 5, 6, 7}

  blocks:
    # =========================================================================
    # BLOCK: SECTION H — English and French bilingual
    # =========================================================================
    # Routing summary:
    #   H1 → H2 → H3
    #   H3 = Yes (1) → H3a → H4 → H5 → Section N
    #   H3 = No  (0) → Section N
    # =========================================================================
    - id: b_section_h
      title: "Language — English and French Bilingual"
      precondition:
        - predicate: lang_path == 2
      items:
        # H1: English change compared to 5 years ago (Know, Use)
        - id: qg_h1
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

        # H2: French change compared to 5 years ago (Know, Use)
        - id: qg_h2
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

        # H3: Other language knowledge (besides English and French)
        - id: q_h3
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H3a: How many other languages
        # Precondition: knows other language (H3 = 1)
        - id: q_h3a
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: q_h3.outcome == 1
          input:
            control: Radio
            labels:
              1: "One language"
              2: "Multiple languages (report best known)"

        # H3a_spec: Specify language(s)
        # Precondition: knows other language (H3 = 1)
        - id: q_h3a_spec
          kind: Question
          title: "Please specify the language(s):"
          precondition:
            - predicate: q_h3.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # H4: Last conversation in other language
        # Precondition: knows other language (H3 = 1)
        - id: q_h4
          kind: Question
          title: "When was the last time you had a conversation in that language, excluding language courses?"
          precondition:
            - predicate: q_h3.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # H5: Other language proficiency (Reading, Understanding, Speaking)
        # Precondition: knows other language (H3 = 1)
        - id: qg_h5
          kind: QuestionGroup
          title: "In that language, how would you rate yourself in the following abilities?"
          precondition:
            - predicate: q_h3.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Dropdown
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # H6 is routing only (GO TO SECTION N) — omitted
