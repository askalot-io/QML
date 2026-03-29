qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language (Childhood and Adolescence)"
  codeInit: |
    # Extern: language path from Section F
    lang_path: {1, 2, 3, 4, 5, 6, 7}
    # Track whether multiple languages reported in N1
    n1_multiple = 0

  blocks:
    # =========================================================================
    # BLOCK: SECTION N — Childhood and adolescence language
    # =========================================================================
    # Routing summary:
    #   N1 → N2 (filter)
    #   If only one language in N1 → N4
    #   If multiple languages in N1 → N3 → N4
    #   N4 → N5 → Section P
    #
    # Block precondition: all multilingual respondents (lang_path != 7)
    # lang_path == 7 means English-only, routed to Section T instead
    # =========================================================================
    - id: b_section_n
      title: "Language — Childhood and Adolescence"
      precondition:
        - predicate: lang_path != 7
      items:
        # N1: Languages spoken at home before age 6
        - id: q_n1
          kind: Question
          title: "Before you were six years old, which languages were spoken in your home by people living there?"
          codeBlock: |
            # Check if multiple languages selected (more than one bit set)
            val = q_n1.outcome
            count = 0
            if val % 2 >= 1:
                count = count + 1
            if val % 4 >= 2:
                count = count + 1
            if val % 8 >= 4:
                count = count + 1
            if count >= 2:
                n1_multiple = 1
            else:
                n1_multiple = 0
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # N1_other: Specify other language
        # Precondition: "Other" selected in N1
        - id: q_n1_other
          kind: Question
          title: "Please specify the other language(s) spoken at home:"
          precondition:
            - predicate: q_n1.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

        # N2 is a filter: if only one language in N1 → skip N3
        # Modeled as precondition on N3

        # N3: Which languages did you yourself speak at home (multiple from N1)
        # Precondition: multiple languages in N1
        - id: q_n3_spoke
          kind: Question
          title: "Which languages did you yourself speak at home?"
          precondition:
            - predicate: n1_multiple == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # N3_most: Most often spoken language at home
        # Precondition: multiple languages in N1
        - id: q_n3_most
          kind: Question
          title: "Which of those languages did you speak most often at home?"
          precondition:
            - predicate: n1_multiple == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # N3_90pct: Did you speak this language more than 90% of the time?
        # Precondition: multiple languages in N1
        - id: q_n3_90pct
          kind: Question
          title: "Did you speak this language at home more than 90% of the time?"
          precondition:
            - predicate: n1_multiple == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # N4: Languages spoken at home at age 15
        - id: q_n4
          kind: Question
          title: "When you were fifteen years old, which languages did you yourself speak at home?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # N4_other: Specify other language at 15
        # Precondition: "Other" selected in N4
        - id: q_n4_other
          kind: Question
          title: "Please specify the other language(s) spoken at home at age 15:"
          precondition:
            - predicate: q_n4.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

        # N4_most: Most often spoken language at home at 15
        - id: q_n4_most
          kind: Question
          title: "Which of those languages did you speak most often at home at age 15?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # N5: Languages spoken with friends at 15
        - id: q_n5
          kind: Question
          title: "At that time, which languages did you speak with your friends?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # N5_other: Specify other language with friends
        # Precondition: "Other" selected in N5
        - id: q_n5_other
          kind: Question
          title: "Please specify the other language(s) spoken with friends:"
          precondition:
            - predicate: q_n5.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

        # N5_most: Most often spoken language with friends
        - id: q_n5_most
          kind: Question
          title: "Which of those languages did you speak most often with your friends?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # N6 is routing only (GO TO SECTION P) — omitted
