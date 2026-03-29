qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language (French Main)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {1, 2, 3, 4, 5, 6, 7}

  blocks:
    # =========================================================================
    # BLOCK: SECTION K — French main language
    # =========================================================================
    # Routing summary:
    #   K1 → K2 → K3 → K4
    #   K4 = Yes (1) → K4a → K5 → K6 → K7 → Section N
    #   K4 = No  (0) → K7 → Section N
    # =========================================================================
    - id: b_section_k
      title: "Language — French Main"
      precondition:
        - predicate: lang_path == 4
      items:
        # K1: English reading ability
        - id: q_k1
          kind: Question
          title: "How would you rate your ability to read in English? Is it..."
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # K2: English knowledge sources
        - id: q_k2
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

        # K2_other: Specify other source
        # Precondition: "Other" selected in K2
        - id: q_k2_other
          kind: Question
          title: "Please specify the other source of English knowledge:"
          precondition:
            - predicate: q_k2.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # K3: English and French change compared to 5 years ago
        # 4 rows: English Know, English Use, French Know, French Use
        - id: qg_k3
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more or less English and French, or about the same?"
          questions:
            - "Know English"
            - "Use English"
            - "Know French"
            - "Use French"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # K4: Other language knowledge (besides English and French)
        - id: q_k4
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # K4a: How many other languages
        # Precondition: knows other language (K4 = 1)
        - id: q_k4a
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: q_k4.outcome == 1
          input:
            control: Radio
            labels:
              1: "One language"
              2: "Multiple languages (report best known)"

        # K4a_spec: Specify language(s)
        # Precondition: knows other language (K4 = 1)
        - id: q_k4a_spec
          kind: Question
          title: "Please specify the language(s):"
          precondition:
            - predicate: q_k4.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # K5: Last conversation in other language
        # Precondition: knows other language (K4 = 1)
        - id: q_k5
          kind: Question
          title: "When was the last time you had a conversation in that language, excluding language courses?"
          precondition:
            - predicate: q_k4.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # K6: Other language proficiency (Reading, Understanding, Speaking)
        # Precondition: knows other language (K4 = 1)
        - id: qg_k6
          kind: QuestionGroup
          title: "In that language, how would you rate yourself in the following abilities?"
          precondition:
            - predicate: q_k4.outcome == 1
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

        # K7: French use change
        - id: q_k7
          kind: Question
          title: "Compared to five years ago, would you say that you now use more French, less French, or about the same?"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # K8 is routing only (GO TO SECTION N) — omitted
