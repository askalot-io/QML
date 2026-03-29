qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language (Other Main Language)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {1, 2, 3, 4, 5, 6, 7}

  blocks:
    # =========================================================================
    # BLOCK: SECTION M — Other main language
    # =========================================================================
    # Routing summary:
    #   M1 → M2 → M3 → M4
    #   M4 = Yes (1) → M5 → M6 → M7 → M8 → M9 → Section N
    #   M4 = No  (0) → M9 → Section N
    # =========================================================================
    - id: b_section_m
      title: "Language — Other Main Language"
      precondition:
        - predicate: lang_path == 6
      items:
        # M1: English reading ability
        - id: q_m1
          kind: Question
          title: "How would you rate your ability to read in English? Is it..."
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # M2: English knowledge sources
        - id: q_m2
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

        # M2_other: Specify other source
        # Precondition: "Other" selected in M2
        - id: q_m2_other
          kind: Question
          title: "Please specify the other source of English knowledge:"
          precondition:
            - predicate: q_m2.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # M3: English change compared to 5 years ago (Know, Use)
        - id: qg_m3
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

        # M4: French knowledge
        - id: q_m4
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # M5: Last French conversation
        # Precondition: knows French (M4 = 1)
        - id: q_m5
          kind: Question
          title: "When was the last time you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: q_m4.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # M6: French proficiency (Reading, Understanding, Speaking)
        # Precondition: knows French (M4 = 1)
        - id: qg_m6
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: q_m4.outcome == 1
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

        # M7: French knowledge sources
        # Precondition: knows French (M4 = 1)
        - id: q_m7
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: q_m4.outcome == 1
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

        # M7_other: Specify other source
        # Precondition: knows French and "Other" selected in M7
        - id: q_m7_other
          kind: Question
          title: "Please specify the other source of French knowledge:"
          precondition:
            - predicate: q_m4.outcome == 1
            - predicate: q_m7.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # M8: French change compared to 5 years ago (Know, Use)
        # Precondition: knows French (M4 = 1)
        - id: qg_m8
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          precondition:
            - predicate: q_m4.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # M9: Other languages count
        - id: q_m9
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          input:
            control: Editbox
            min: 1
            max: 20
            right: "language(s)"
