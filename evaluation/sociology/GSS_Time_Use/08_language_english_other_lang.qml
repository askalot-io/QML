qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language (English and Other)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {1, 2, 3, 4, 5, 6, 7}

  blocks:
    # =========================================================================
    # BLOCK: SECTION J — English and Other language
    # =========================================================================
    # Routing summary:
    #   J1 → J2
    #   J2 = Yes (1) → J3 → J4 → J5 → J6 → J7 → Section N
    #   J2 = No  (0) → J7 → Section N
    # =========================================================================
    - id: b_section_j
      title: "Language — English and Other"
      precondition:
        - predicate: lang_path == 3
      items:
        # J1: English change compared to 5 years ago (Know, Use)
        - id: qg_j1
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

        # J2: French knowledge
        - id: q_j2
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J3: Last French conversation
        # Precondition: knows French (J2 = 1)
        - id: q_j3
          kind: Question
          title: "When was the last time that you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: q_j2.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # J4: French proficiency (Reading, Understanding, Speaking)
        # Precondition: knows French (J2 = 1)
        - id: qg_j4
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: q_j2.outcome == 1
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

        # J5: French knowledge sources
        # Precondition: knows French (J2 = 1)
        - id: q_j5
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: q_j2.outcome == 1
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

        # J5_other: Specify other source
        # Precondition: knows French and "Other" selected in J5
        - id: q_j5_other
          kind: Question
          title: "Please specify the other source of French knowledge:"
          precondition:
            - predicate: q_j2.outcome == 1
            - predicate: q_j5.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # J6: French change compared to 5 years ago (Know, Use)
        # Precondition: knows French (J2 = 1)
        - id: qg_j6
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          precondition:
            - predicate: q_j2.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # J7: Other languages count
        - id: q_j7
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          input:
            control: Editbox
            min: 1
            max: 20
            right: "language(s)"

        # J8 is routing only (GO TO SECTION N) — omitted
