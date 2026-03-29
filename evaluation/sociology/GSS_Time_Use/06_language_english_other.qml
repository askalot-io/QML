qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language (English Main, With Other Language Knowledge)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {1, 2, 3, 4, 5, 6, 7}

  blocks:
    # =========================================================================
    # BLOCK: SECTION G — English main, other language knowledge
    # =========================================================================
    # Routing summary:
    #   G1 = Yes (1) → G2 → G3 → G4 → G5 → G6
    #   G1 = No  (0) → G6
    #   G6 = Yes (1) → G6a → G7 → G8 → G9 check
    #   G6 = No  (0) → G9 check
    #   G9: if G1=No AND G6=No → Section N (skips G10)
    #        otherwise → G10 → Section N
    #   G10: asked if respondent knows French or another language
    # =========================================================================
    - id: b_section_g
      title: "Language — English Main"
      precondition:
        - predicate: lang_path == 1
      items:
        # G1: French knowledge
        - id: q_g1
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G2: Last French conversation
        # Precondition: knows French (G1 = 1)
        - id: q_g2
          kind: Question
          title: "When was the last time that you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: q_g1.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # G3: French proficiency (Reading, Understanding, Speaking)
        # Precondition: knows French (G1 = 1)
        - id: qg_g3
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: q_g1.outcome == 1
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

        # G4: French knowledge sources
        # Precondition: knows French (G1 = 1)
        - id: q_g4
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: q_g1.outcome == 1
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

        # G4_other: Specify other source
        # Precondition: "Other" selected in G4 (bit 64)
        - id: q_g4_other
          kind: Question
          title: "Please specify the other source of French knowledge:"
          precondition:
            - predicate: q_g1.outcome == 1
            - predicate: q_g4.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # G5: French change compared to 5 years ago (Know, Use)
        # Precondition: knows French (G1 = 1)
        - id: qg_g5
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          precondition:
            - predicate: q_g1.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # G6: Other language knowledge (besides English and French)
        - id: q_g6
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G6a: How many other languages
        # Precondition: knows other language (G6 = 1)
        - id: q_g6a
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: q_g6.outcome == 1
          input:
            control: Radio
            labels:
              1: "One language"
              2: "Multiple languages (report best known)"

        # G6a_spec: Specify language(s)
        # Precondition: knows other language (G6 = 1)
        - id: q_g6a_spec
          kind: Question
          title: "Please specify the language(s):"
          precondition:
            - predicate: q_g6.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # G7: Last conversation in other language
        # Precondition: knows other language (G6 = 1)
        - id: q_g7
          kind: Question
          title: "When was the last time you had a conversation in that language, excluding language courses?"
          precondition:
            - predicate: q_g6.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # G8: Other language proficiency (Reading, Understanding, Speaking)
        # Precondition: knows other language (G6 = 1)
        - id: qg_g8
          kind: QuestionGroup
          title: "In that language, how would you rate yourself in the following abilities?"
          precondition:
            - predicate: q_g6.outcome == 1
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

        # G9 is a filter: if G1=No AND G6=No → skip to Section N (skip G10)
        # Modeled as precondition on G10: shown only if G1=Yes OR G6=Yes

        # G10: English use change
        # Precondition: respondent knows French or another language
        - id: q_g10
          kind: Question
          title: "Compared to five years ago, would you say that you now use more English, less English, or about the same?"
          precondition:
            - predicate: q_g1.outcome == 1 or q_g6.outcome == 1
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # G11 is routing only (GO TO SECTION N) — omitted
