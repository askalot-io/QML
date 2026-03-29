qmlVersion: "1.0"

questionnaire:
  title: "ESS Round 12 - Section J: Interviewer Questionnaire"

  blocks:
    # ── Interview Mode and Respondent Behaviour (J1-J5) ──
    - id: b_interview_mode
      title: "Interview Mode and Respondent Behaviour"
      items:
        # J1: Interview mode
        - id: q_j1
          kind: Question
          title: "Please select how the interview was conducted from the list below."
          input:
            control: Radio
            labels:
              1: "In person inside respondent's home"
              2: "In person outside of respondent's home"
              3: "By video"

        # J2: Respondent asked for clarification
        - id: q_j2
          kind: Question
          title: "Did the respondent ask for clarification on any questions?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Almost never"
              3: "Now and then"
              4: "Often"
              5: "Very often"

        # J3: Respondent reluctance
        - id: q_j3
          kind: Question
          title: "Did you feel that the respondent was reluctant to answer any questions?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Almost never"
              3: "Now and then"
              4: "Often"
              5: "Very often"

        # J4: Respondent effort
        - id: q_j4
          kind: Question
          title: "Did you feel that the respondent tried to answer the questions to the best of his or her ability?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Almost never"
              3: "Now and then"
              4: "Often"
              5: "Very often"

        # J5: Respondent understanding
        - id: q_j5
          kind: Question
          title: "Overall, did you feel that the respondent understood the questions?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Almost never"
              3: "Now and then"
              4: "Often"
              5: "Very often"

    # ── Interference (J6-J7) ──
    - id: b_interference
      title: "Interference"
      items:
        # J6: Interference during interview — 1 (Yes) → J7; 0 (No) → J8
        - id: q_j6
          kind: Question
          title: "Was anyone else present, who interfered with the interview?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # J7: Who interfered (only if J6 = Yes)
        - id: q_j7
          kind: Question
          title: "Who was this? Code all that apply."
          precondition:
            - predicate: "q_j6.outcome == 1"
          input:
            control: Checkbox
            labels:
              1: "Husband/wife/partner"
              2: "Son/daughter"
              4: "Parent/parent-in-law/step-parent/partner's parent"
              8: "Other relative"
              16: "Other non-relative"

    # ── Interview Details (J8-J10) ──
    - id: b_interview_details
      title: "Interview Details"
      items:
        # J8: Interview language (country-specific; placeholder options)
        - id: q_j8
          kind: Question
          title: "In which language was the interview conducted?"
          input:
            control: Dropdown
            labels:
              1: "Main national language"
              2: "Second national language"
              3: "Third national language"
              4: "Minority language"
              5: "Other language"

        # J9: Interviewer ID
        - id: q_j9
          kind: Question
          title: "Please enter your interviewer ID."
          input:
            control: Textarea
            placeholder: "Interviewer ID"

        # J10: Additional comments
        - id: q_j10
          kind: Question
          title: "If you have any additional comments on the interview, please type them in the space below."
          input:
            control: Textarea
            placeholder: "Additional comments"
