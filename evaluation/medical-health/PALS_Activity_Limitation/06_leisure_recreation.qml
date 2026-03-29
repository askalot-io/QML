qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 (Children) — Section F: Leisure and Recreation Activities"

  codeInit: |
    # Extern variable from earlier sections
    child_under_5: {0, 1}

  blocks:
    # =========================================================================
    # SECTION F — Leisure and Recreation Activities
    # Entire section skipped if child_under_5 == 1
    # =========================================================================
    # F1a–F1e: Organized activity frequency + hours (outside school hours)
    # F2a–F2c: Passive/home activity frequency + hours
    # F3: Reading frequency + hours (Everyday only triggers hours)
    # F4: Unorganized play frequency (4-point scale, no hours)
    # F5: Summer camp attendance → F6 (camp type) if Yes
    # F7: Prevented from leisure activities → F8 (barrier list) if Yes
    # F9: Getting along with other children (5-point)
    # F10: Computers in home
    #   None → F11 (no-computer barriers) → end
    #   1+   → F12 (Internet?)
    #     No  → F13 (no-internet barriers) → end
    #     Yes → F14 (child uses Internet?)
    #       No  → F15 (non-use barriers) → end
    #       Yes → F16a–F16d (Internet usage frequency + hours)
    # =========================================================================
    - id: b_leisure_recreation
      title: "Leisure and Recreation Activities"
      precondition:
        - predicate: child_under_5 == 0
      items:

        # -----------------------------------------------------------------
        # F1a: Organized sports with coach/instructor
        # -----------------------------------------------------------------
        - id: q_f1a
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in sports with a coach or instructor (except dance or gymnastics)?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1a_hrs: Hours per day — only if F1a not Never
        - id: q_f1a_hrs
          kind: Question
          title: "How many hours a day does he/she take part in sports with a coach or instructor?"
          precondition:
            - predicate: q_f1a.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F1b: Organized lessons in dance, gymnastics, martial arts, etc.
        # -----------------------------------------------------------------
        - id: q_f1b
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken lessons or instruction in other organized physical activities with a coach or instructor, such as dance, gymnastics or martial arts?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1b_hrs: Hours per day — only if F1b not Never
        - id: q_f1b_hrs
          kind: Question
          title: "How many hours a day does he/she take lessons or instruction in other organized physical activities?"
          precondition:
            - predicate: q_f1b.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F1c: Unorganized sports/physical activities
        # -----------------------------------------------------------------
        - id: q_f1c
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in unorganized sports or physical activities without a coach or instructor?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1c_hrs: Hours per day — only if F1c not Never
        - id: q_f1c_hrs
          kind: Question
          title: "How many hours a day does he/she take part in unorganized sports or physical activities?"
          precondition:
            - predicate: q_f1c.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F1d: Lessons in music, art, or other non-sport activities
        # -----------------------------------------------------------------
        - id: q_f1d
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken lessons or instruction in music, art or other non-sport activities?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1d_hrs: Hours per day — only if F1d not Never
        - id: q_f1d_hrs
          kind: Question
          title: "How many hours a day does he/she take lessons or instruction in music, art or other non-sport activities?"
          precondition:
            - predicate: q_f1d.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F1e: Clubs, groups, community programs
        # -----------------------------------------------------------------
        - id: q_f1e
          kind: Question
          title: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in clubs, groups or community programs, such as church groups, Girl or Boy Scouts?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F1e_hrs: Hours per day — only if F1e not Never
        - id: q_f1e_hrs
          kind: Question
          title: "How many hours a day does he/she take part in clubs, groups or community programs?"
          precondition:
            - predicate: q_f1e.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F2a: Watch TV
        # -----------------------------------------------------------------
        - id: q_f2a
          kind: Question
          title: "How often does he/she watch T.V.?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F2a_hrs: Hours per day — only if F2a not Never
        - id: q_f2a_hrs
          kind: Question
          title: "How many hours a day does he/she watch T.V.?"
          precondition:
            - predicate: q_f2a.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F2b: Computer or video games
        # -----------------------------------------------------------------
        - id: q_f2b
          kind: Question
          title: "How often does he/she play computer or video games?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F2b_hrs: Hours per day — only if F2b not Never
        - id: q_f2b_hrs
          kind: Question
          title: "How many hours a day does he/she play computer or video games?"
          precondition:
            - predicate: q_f2b.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F2c: Talk on phone with friends
        # -----------------------------------------------------------------
        - id: q_f2c
          kind: Question
          title: "How often does he/she talk on the phone with friends?"
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F2c_hrs: Hours per day — only if F2c not Never
        - id: q_f2c_hrs
          kind: Question
          title: "How many hours a day does he/she talk on the phone with friends?"
          precondition:
            - predicate: q_f2c.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F3: Reading for pleasure
        # Note: inventory says 1 → F3_hrs; 2–5 → F4
        # i.e., only "Everyday" triggers the hours follow-up
        # -----------------------------------------------------------------
        - id: q_f3
          kind: Question
          title: "How often does ..... read or have books read to him/her (for pleasure)? Please do not include reading that is required for school."
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F3_hrs: Hours per day — only if F3 = Everyday
        - id: q_f3_hrs
          kind: Question
          title: "How many hours a day does he/she read or have books read to him/her?"
          precondition:
            - predicate: q_f3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F4: Playing alone
        # 4-point scale (Often/Sometimes/Seldom/Never) — no hours follow-up
        # -----------------------------------------------------------------
        - id: q_f4
          kind: Question
          title: "Outside of school hours, how often does he/she play alone, for example, riding a bike or doing a craft?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # -----------------------------------------------------------------
        # F5: Summer camp attendance
        # -----------------------------------------------------------------
        - id: q_f5
          kind: Question
          title: "Has ..... ever gone to summer camps (including regular or special camps)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F6: Camp for children with health problem — only if F5 = Yes
        - id: q_f6
          kind: Question
          title: "Was this a camp for children with a health problem or condition?"
          precondition:
            - predicate: q_f5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # -----------------------------------------------------------------
        # F7: Prevented from leisure activities
        # -----------------------------------------------------------------
        - id: q_f7
          kind: Question
          title: "Because of a condition or health problem, is ..... prevented from taking part in any social or physical leisure activities?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # F8: Barriers to leisure — only if F7 = Yes
        # 8 sub-items, Yes/No per item → QuestionGroup with Switch
        - id: qg_f8
          kind: QuestionGroup
          title: "What prevents ..... from doing more social or physical leisure activities? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_f7.outcome == 1
          questions:
            - "Recreational facilities or programs not available locally"
            - "Buildings and equipment not physically accessible"
            - "Inadequate transportation services"
            - "Too expensive"
            - "Child is physically unable to do more"
            - "Child needs someone's assistance"
            - "Child needs specialized aids or equipment, but he/she doesn't have them"
            - "Other reason"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # F9: Getting along with other children
        # -----------------------------------------------------------------
        - id: q_f9
          kind: Question
          title: "DURING THE PAST SIX MONTHS, how well has ..... gotten along with other children, such as friends or classmates (excluding brothers or sisters)?"
          input:
            control: Radio
            labels:
              1: "Very well (or no problems)"
              2: "Quite well (or hardly any problems)"
              3: "Pretty well (or occasional problems)"
              4: "Not too well (or frequent problems)"
              5: "Not well at all (or constant problems)"

        # -----------------------------------------------------------------
        # F10: Personal computers in home
        # -----------------------------------------------------------------
        - id: q_f10
          kind: Question
          title: "How many personal computers are there in your home?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "One"
              3: "Two"
              4: "Three or more"

        # -----------------------------------------------------------------
        # F11: No-computer barriers — only if F10 = None (1)
        # Multi-select: Why no computer?
        # -----------------------------------------------------------------
        - id: qg_f11
          kind: QuestionGroup
          title: "What are the reasons that keep you from purchasing a personal computer? (Please answer yes or no to each)"
          precondition:
            - predicate: q_f10.outcome == 1
          questions:
            - "Cost"
            - "Not needed at home"
            - "Not interested"
            - "Lack of computer skills or training"
            - "Fear of technology"
            - "Disability"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # F12: Internet connection — only if F10 = 1+ computer (2, 3, or 4)
        # -----------------------------------------------------------------
        - id: q_f12
          kind: Question
          title: "Is your household connected to the Internet?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # -----------------------------------------------------------------
        # F13: No-internet barriers — only if F12 = No (3)
        # Multi-select: Why no Internet at home?
        # -----------------------------------------------------------------
        - id: qg_f13
          kind: QuestionGroup
          title: "What are the reasons that keep you from getting Internet access for your HOME? (Please answer yes or no to each)"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 3
          questions:
            - "Cost"
            - "Not needed at home"
            - "Not interested"
            - "Lack of computer skills or training"
            - "Fear of technology"
            - "Disability"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # F14: Child uses Internet at home — only if F12 = Yes (1)
        # -----------------------------------------------------------------
        - id: q_f14
          kind: Question
          title: "Does ..... use the Internet AT HOME?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"

        # -----------------------------------------------------------------
        # F15: Child non-use barriers — only if F14 = No (3)
        # Multi-select: Why doesn't child use Internet?
        # -----------------------------------------------------------------
        - id: qg_f15
          kind: QuestionGroup
          title: "What are the reasons that keep ..... from using the Internet at home? (Please answer yes or no to each)"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 3
          questions:
            - "Child too young or not ready to use it"
            - "Child does not need it"
            - "Child is not interested"
            - "Child does not have the computer skills or training"
            - "Child's condition or health problem"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # F16a: Internet newsgroups/chat — only if F14 = Yes (1)
        # -----------------------------------------------------------------
        - id: q_f16a
          kind: Question
          title: "AT HOME, how often does he/she use Internet to participate in newsgroups or chat groups?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F16a_hrs: Hours per day — only if F16a not Never
        - id: q_f16a_hrs
          kind: Question
          title: "How many hours a day does he/she use Internet for newsgroups or chat groups?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
            - predicate: q_f16a.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F16b: Internet for school work
        # -----------------------------------------------------------------
        - id: q_f16b
          kind: Question
          title: "AT HOME, how often does he/she use Internet for school work?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F16b_hrs: Hours per day — only if F16b not Never
        - id: q_f16b_hrs
          kind: Question
          title: "How many hours a day does he/she use Internet for school work?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
            - predicate: q_f16b.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F16c: Internet for personal interest/entertainment
        # -----------------------------------------------------------------
        - id: q_f16c
          kind: Question
          title: "AT HOME, how often does he/she use Internet for personal interest or entertainment?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F16c_hrs: Hours per day — only if F16c not Never
        - id: q_f16c_hrs
          kind: Question
          title: "How many hours a day does he/she use Internet for personal interest or entertainment?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
            - predicate: q_f16c.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"

        # -----------------------------------------------------------------
        # F16d: Internet e-mail to stay in touch with friends
        # -----------------------------------------------------------------
        - id: q_f16d
          kind: Question
          title: "AT HOME, how often does he/she use E-mail to stay in touch with friends?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
          input:
            control: Radio
            labels:
              1: "Everyday"
              2: "At least once a week"
              3: "At least once a month"
              4: "Less than once a month"
              5: "Never"

        # F16d_hrs: Hours per day — only if F16d not Never
        - id: q_f16d_hrs
          kind: Question
          title: "How many hours a day does he/she use E-mail to stay in touch with friends?"
          precondition:
            - predicate: q_f10.outcome in [2, 3, 4]
            - predicate: q_f12.outcome == 1
            - predicate: q_f14.outcome == 1
            - predicate: q_f16d.outcome in [1, 2, 3, 4]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours per day"
