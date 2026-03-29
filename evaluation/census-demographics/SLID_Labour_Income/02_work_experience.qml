qmlVersion: "1.0"
questionnaire:
  title: "SLID 1994 Preliminary Interview - Work Experience (EXPRE)"

  codeInit: |
    # Extern variable from prior sections
    age: range(0, 120)

  blocks:
    # =========================================================================
    # BLOCK: EXPRE — Work Experience History
    # =========================================================================
    # N1 filter: age > 69 skips the entire module → block precondition age <= 69
    #
    # Q1A: Ever worked full-time?  Yes → Q1B; Otherwise → end
    # Q1B: Years ago first started full-time. 0/DK → end; 1 → Q3; 2+ → Q2A
    # Q2A: Any years not working?  Yes → Q2B → Q5A path; No → Q3
    # Q3: Worked 6+ months every year?  Yes → Q4 series; No → Q5A
    # Q4A/Q4B/Q4C: Full-time / part-time / mixed years (sum must = Q1B)
    # Q4D: Sum-check warning (Comment) if Q4A+Q4B+Q4C != Q1B
    # Q5A: Years working 6+ months. 0 → end; Otherwise → Q6 series
    # Q6A/Q6B/Q6C: Full-time / part-time / mixed years (sum must = Q5A)
    # Q6D: Sum-check warning (Comment) if Q6A+Q6B+Q6C != Q5A
    # =========================================================================
    - id: b_expre
      title: "Work Experience"
      precondition:
        - predicate: age <= 69
      items:
        # Q1A: Did respondent ever work full-time?
        - id: q_q1a
          kind: Question
          title: "The next few questions are about work experience, thinking back to when first started working at a job or business. Did the respondent ever work full-time? (Exclude summer jobs while in school)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No, never worked full-time"
              3: "No, only worked full-time at summer jobs while in school"

        # Q1B: How many years ago did respondent first start working full-time?
        # Shown only if Q1A = Yes (1)
        # Routes: 0 → end section; 1 → Q3 (skip Q2A/Q2B); 2+ → Q2A
        - id: q_q1b
          kind: Question
          title: "How many years ago did the respondent first start working full-time? (Exclude summer jobs while in school. Enter 00 if less than one year.)"
          precondition:
            - predicate: q_q1a.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q2A: Were there any years when respondent did not work?
        # Shown only if Q1B >= 2
        - id: q_q2a
          kind: Question
          title: "In those years, were there any years when the respondent did not work at a job or business?"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q2B: How many years did respondent not work?
        # Shown only if Q2A = Yes (1)
        # After Q2B → skip to Q5A (Q3/Q4 series not reached)
        - id: q_q2b
          kind: Question
          title: "How many years did the respondent not work at a job or business?"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 2
            - predicate: q_q2a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 60
            right: "years"

        # Q3: Worked at least 6 months each and every year?
        # Reached when Q1B = 1 (skip Q2A/Q2B) OR Q1B >= 2 and Q2A = No (0)
        # Yes → Q4A series; No → Q5A
        - id: q_q3
          kind: Question
          title: "In those years, did the respondent work at least 6 months each and every year?"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q4A: How many years worked only full-time?
        # Shown if Q3 = Yes (1)
        - id: q_q4a
          kind: Question
          title: "How many years did the respondent work only full-time? (By full-time I mean 30 or more hours per week. If none, enter 00.)"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_q3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q4B: How many years worked only part-time?
        - id: q_q4b
          kind: Question
          title: "How many years did the respondent work only part-time? (If none, enter 00.)"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_q3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q4C: How many years worked some of each?
        - id: q_q4c
          kind: Question
          title: "How many years did the respondent work some of each (full-time and part-time)? (If none, enter 00.)"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_q3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q4D: Sum-check warning (N4 filter → Q4D comment)
        # Shown when Q4A + Q4B + Q4C does not equal Q1B
        - id: q_q4d
          kind: Comment
          title: "The years of full-time, part-time, and mixed work do not sum to the total years working full-time. Please verify and correct if necessary."
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_q3.outcome == 1
            - predicate: q_q4a.outcome + q_q4b.outcome + q_q4c.outcome != q_q1b.outcome

        # Q5A: How many years did respondent work at least 6 months of the year?
        # Reached via two paths:
        #   1. Q2B answered (Q2A = Yes) → skip Q3/Q4, go to Q5A
        #   2. Q3 = No (0) → go to Q5A
        # Routes: 0 → end section; Otherwise → Q6 series
        - id: q_q5a
          kind: Question
          title: "Since the respondent first started working, how many years did he/she work at least 6 months of the year? (If none, enter 00.)"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_q3.outcome == 0
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6A: In those years, how many worked only full-time?
        # Shown if Q5A >= 1
        - id: q_q6a
          kind: Question
          title: "In those years, how many did the respondent work only full-time? (By full-time I mean 30 or more hours per week. If none, enter 00.)"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6B: In those years, how many worked only part-time?
        - id: q_q6b
          kind: Question
          title: "In those years, how many did the respondent work only part-time? (If none, enter 00.)"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6C: In those years, how many worked some of each?
        - id: q_q6c
          kind: Question
          title: "In those years, how many did the respondent work some of each (full-time and part-time)? (If none, enter 00.)"
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6D: Sum-check warning (N6 filter → Q6D comment)
        # Shown when Q6A + Q6B + Q6C does not equal Q5A
        - id: q_q6d
          kind: Comment
          title: "The years of full-time, part-time, and mixed work do not sum to the total years working 6 or more months. Please verify and correct if necessary."
          precondition:
            - predicate: q_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
            - predicate: q_q6a.outcome + q_q6b.outcome + q_q6c.outcome != q_q5a.outcome
