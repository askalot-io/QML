qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Language and Background Characteristics (Section Q)"
  codeInit: |
    # Extern variable: multilingual path indicator from Section F
    lang_path: {1, 2, 3, 4, 5, 6}

    # Computed variables for routing
    worked_12m = 0
    home_lang_count = 0

  blocks:
    # =========================================================================
    # BLOCK 1: HOME LANGUAGE USE
    # =========================================================================
    # Q1: Languages spoken at home (multi-select)
    #   If "Live alone" selected → skip to Q4
    #   Otherwise → Q2 (filter check)
    # Q2: Interviewer filter — if only one language → skip to Q4
    # Q3: Which languages do you yourself speak at home (if multiple)
    # Q4: Languages with friends
    # =========================================================================
    - id: b_home_language
      title: "Home Language Use"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # Q1: Languages at home
        - id: q_q1
          kind: Question
          title: "Think about the people you live with. Which languages do you speak amongst yourselves at home?"
          codeBlock: |
            # Count languages selected (excluding "Live alone" bit 1)
            v = q_q1.outcome & 14
            count = 0
            if v % 4 >= 2:
              count = count + 1
            if v % 8 >= 4:
              count = count + 1
            if v % 16 >= 8:
              count = count + 1
            home_lang_count = count
          input:
            control: Checkbox
            labels:
              1: "Live alone"
              2: "English"
              4: "French"
              8: "Other"

        # Q3: Languages you yourself speak at home
        # Shown only when multiple languages reported AND not living alone
        - id: q_q3
          kind: Question
          title: "Which languages do you yourself speak at home?"
          precondition:
            - predicate: q_q1.outcome % 2 == 0
            - predicate: home_lang_count >= 2
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q3_most: Most often spoken at home
        - id: q_q3_most
          kind: Question
          title: "Which of these do you speak most often at home?"
          precondition:
            - predicate: q_q1.outcome % 2 == 0
            - predicate: home_lang_count >= 2
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # Q3_90: Speak most-often language more than 90% of the time?
        - id: q_q3_90
          kind: Question
          title: "Do you speak this language at home more than 90% of the time?"
          precondition:
            - predicate: q_q1.outcome % 2 == 0
            - predicate: home_lang_count >= 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q4: Languages with friends
        - id: q_q4
          kind: Question
          title: "Which languages do you yourself speak with your friends outside your home?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q4_most: Most often spoken with friends
        - id: q_q4_most
          kind: Question
          title: "Which of these do you speak most often with your friends?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

    # =========================================================================
    # BLOCK 2: MAIN ACTIVITY AND WORK STATUS
    # =========================================================================
    # Q5: Main activity last 7 days
    # Q6: Main activity last 12 months
    #   If Q6=1 (working) → set worked_12m=1, skip Q7, go to Q8
    # Q7: Had a job in last 12 months? (only if Q6 != 1)
    #   If Q7=1 → set worked_12m=1, go to Q8
    #   If Q7=0 → worked_12m stays 0, skip to Section R
    # =========================================================================
    - id: b_main_activity
      title: "Main Activity"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # Q5: Main activity last 7 days
        - id: q_q5
          kind: Question
          title: "Which of the following best describes your main activity during the last 7 days? Were you mainly..."
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        # Q6: Main activity last 12 months
        - id: q_q6
          kind: Question
          title: "What about your main activity during the last 12 months? Were you mainly..."
          codeBlock: |
            if q_q6.outcome == 1:
              worked_12m = 1
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        # Q7: Had job in last 12 months (only if Q6 != 1)
        - id: q_q7
          kind: Question
          title: "Did you have a job at any time during the last 12 months?"
          precondition:
            - predicate: q_q6.outcome != 1
          codeBlock: |
            if q_q7.outcome == 1:
              worked_12m = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 3: EMPLOYMENT DETAILS
    # =========================================================================
    # Q8-Q13: Work details, all gated on worked_12m == 1
    # Q9: Employee vs self-employed
    # Q10: Full-time/part-time (only if Q9=1, employee)
    # Q11: Employer name (only if Q9=1, employee)
    # Q12-Q13: Business/work description
    # =========================================================================
    - id: b_employment_details
      title: "Employment Details"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
        - predicate: worked_12m == 1
      items:
        # Q8: Weeks worked in last 12 months
        - id: q_q8
          kind: Question
          title: "For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave)"
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        # Q9: Employee or self-employed
        - id: q_q9
          kind: Question
          title: "During those weeks of work were you mainly..."
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"

        # Q10: Full-time or part-time (employee only)
        - id: q_q10
          kind: Question
          title: "During those weeks of work were you mostly full-time or part-time?"
          precondition:
            - predicate: q_q9.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        # Q11: Employer name (employee only)
        - id: q_q11
          kind: Question
          title: "For whom do you/did you last work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_q9.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # Q12: Kind of business
        - id: q_q12
          kind: Question
          title: "What was the main kind of business, industry or service?"
          input:
            control: Textarea
            placeholder: "Enter business description"

        # Q13: Kind of work
        - id: q_q13
          kind: Question
          title: "What kind of work were you doing?"
          input:
            control: Textarea
            placeholder: "Enter work description"

    # =========================================================================
    # BLOCK 4: LANGUAGE AT WORK
    # =========================================================================
    # Q14-Q17: Languages used at work, gated on worked_12m == 1
    # Q16: Writing at work? If No → skip Q17
    # Q17: Languages for writing (only if Q16=1)
    # =========================================================================
    - id: b_work_language
      title: "Language at Work"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
        - predicate: worked_12m == 1
      items:
        # Q14: Languages spoken at work by contacts
        - id: q_q14
          kind: Question
          title: "Which languages are/were spoken at work by people with whom you have/had regular contact?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q15: Languages you yourself speak at work
        - id: q_q15
          kind: Question
          title: "Considering the last 12 months, which languages have you yourself spoken at work?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q15_most: Most often spoken at work
        - id: q_q15_most
          kind: Question
          title: "Which of these do you speak most often at work?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # Q15_90: Speak most-often language more than 90% of time at work?
        - id: q_q15_90
          kind: Question
          title: "Do you speak this language at work more than 90% of the time?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q16: Writing at work
        - id: q_q16
          kind: Question
          title: "During the last 12 months have you done any writing at work?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q17: Languages for writing at work (Q16 = Yes)
        - id: q_q17
          kind: Question
          title: "Over this period, which languages did you yourself use for writing at work?"
          precondition:
            - predicate: q_q16.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q17_most: Most often used for writing
        - id: q_q17_most
          kind: Question
          title: "Which of these did you use most often for writing at work?"
          precondition:
            - predicate: q_q16.outcome == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # Q17_90: Use most-often language for writing more than 90%?
        - id: q_q17_90
          kind: Question
          title: "Did you use this language for writing at work more than 90% of the time?"
          precondition:
            - predicate: q_q16.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"
