qmlVersion: "1.0"

questionnaire:
  title: "ESS Round 12 - Section F: Survey Experience"

  blocks:
    # ── Survey Experience (F1-F6) ──
    # SC WEB and PAPER only
    - id: b_survey_experience
      title: "Survey Experience"
      items:
        # F1: Understanding of questions
        - id: q_f1
          kind: Question
          title: "Overall, how well did you feel you understood the questions?"
          input:
            control: Radio
            labels:
              1: "Understood only a few of the questions"
              2: "Understood some of the questions"
              3: "Understood most of the questions"
              4: "Understood all or nearly all of the questions"

        # F2: Reluctance to answer
        - id: q_f2
          kind: Question
          title: "Did you feel reluctant to answer any questions?"
          input:
            control: Radio
            labels:
              1: "None of the questions"
              2: "A few of the questions"
              3: "Some of the questions"
              4: "Most of the questions"
              5: "All or nearly all of the questions"

        # F3: Assistance received — 1 (Yes) → F4, F5; 0 (No) → F6
        - id: q_f3
          kind: Question
          title: "Did anyone else assist you in completing this questionnaire?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # F4: Who assisted (only if F3 = Yes)
        - id: q_f4
          kind: Question
          title: "Who assisted you in completing the questionnaire? Please choose all that apply."
          precondition:
            - predicate: "q_f3.outcome == 1"
          input:
            control: Checkbox
            labels:
              1: "Husband, wife, or partner"
              2: "Son or daughter"
              4: "Parent, parent-in-law, step-parent, or partner's parent"
              8: "Other relative"
              16: "Other non-relative"
              32: "The person who delivered the questionnaire"

        # F5: Kind of assistance (only if F3 = Yes)
        - id: q_f5
          kind: Question
          title: "What kind of assistance was given to you in completing the questionnaire? Please choose all that apply."
          precondition:
            - predicate: "q_f3.outcome == 1"
          input:
            control: Checkbox
            labels:
              1: "Understanding the invitation letter and getting started"
              2: "Accessing the online survey"
              4: "Reading the questions aloud to me"
              8: "Providing information for questions about relatives or household members"
              16: "Helping me decide answers to other questions"
              32: "Returning my completed paper questionnaire"
              64: "Other"

        # F6: Further comments
        - id: q_f6
          kind: Question
          title: "Do you have any further comments on this survey or its questions?"
          input:
            control: Textarea
            placeholder: "Type your comments here..."
