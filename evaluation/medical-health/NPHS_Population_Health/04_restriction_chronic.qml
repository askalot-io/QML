qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Restriction of Activities and Chronic Conditions"

  codeInit: |
    # Extern variable from household section
    age: range(0, 120)

  blocks:
    # =========================================================================
    # RESTRICTION OF ACTIVITIES
    # =========================================================================
    # RESTR-CINT: If age < 12, skip entire block
    # RESTR-INT -> RESTR-Q1(a-d) -> RESTR-Q2 -> CHECK RESTR-C3:
    #   Any Q1 Yes  -> RESTR-Q3 -> RESTR-Q5
    #   Q2 Yes only -> RESTR-Q4 -> RESTR-Q5
    #   Otherwise   -> RESTR-Q6
    # RESTR-Q6: Always asked within section
    #
    # DK/R handling: DK/R on any Q1 sub-item or Q2 routes to next section.
    # Modelled by routing only the primary (Yes=1, No=2, Not applicable=3) path
    # via preconditions; DK/R paths are absorbed by the block-level age gate.
    # =========================================================================
    - id: b_restriction
      title: "Restriction of Activities"
      precondition:
        - predicate: age >= 12
      items:
        # RESTR-INT: Interviewer introduction
        - id: q_restr_int
          kind: Comment
          title: "The next few questions deal with any health limitations which affect ...(r/'s) daily activities. In these questions, 'long-term conditions' refer to conditions that have lasted or are expected to last 6 months or more."

        # RESTR-Q1a / RAC4_1A: Limitation at home
        - id: q_restr_q1a
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do at home?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Refused"

        # RESTR-Q1b / RAC4_1B: Limitation at school
        - id: q_restr_q1b
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do at school?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"
              7: "Refused"

        # RESTR-Q1c / RAC4_1C: Limitation at work
        - id: q_restr_q1c
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do at work?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"
              7: "Refused"

        # RESTR-Q1d / RAC4_1D: Limitation in other activities
        - id: q_restr_q1d
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do in other activities such as transportation to or from work or leisure time activities?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Refused"

        # RESTR-Q2 / RAC4_2: Long-term disabilities
        - id: q_restr_q2
          kind: Question
          title: "Do(es) ... have any long term disabilities or handicaps?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Refused"

        # RESTR-Q3 / RAC4_3C: Main condition causing activity limitation
        # CHECK RESTR-C3: Asked if any Q1 sub-item = Yes
        - id: q_restr_q3
          kind: Question
          title: "What is the main condition or health problem causing ... to be limited in your/his/her activities?"
          precondition:
            - predicate: q_restr_q1a.outcome == 1 or q_restr_q1b.outcome == 1 or q_restr_q1c.outcome == 1 or q_restr_q1d.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe the main condition (up to 25 characters)"
            maxLength: 25

        # RESTR-Q4 / RAC4_3C: Main condition causing disability
        # CHECK RESTR-C3: Asked if Q2 = Yes but NO Q1 sub-item = Yes
        - id: q_restr_q4
          kind: Question
          title: "What is the main condition or health problem causing ... to have a long term disability or handicap?"
          precondition:
            - predicate: q_restr_q1a.outcome != 1 and q_restr_q1b.outcome != 1 and q_restr_q1c.outcome != 1 and q_restr_q1d.outcome != 1 and q_restr_q2.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe the main condition (up to 25 characters)"
            maxLength: 25

        # RESTR-Q5 / RAC4_5: Cause description
        # Asked after Q3 or Q4 — i.e., when Q3 was shown OR Q4 was shown
        - id: q_restr_q5
          kind: Question
          title: "Which one of the following is the best description of the cause of this condition?"
          precondition:
            - predicate: q_restr_q1a.outcome == 1 or q_restr_q1b.outcome == 1 or q_restr_q1c.outcome == 1 or q_restr_q1d.outcome == 1 or (q_restr_q1a.outcome != 1 and q_restr_q1b.outcome != 1 and q_restr_q1c.outcome != 1 and q_restr_q1d.outcome != 1 and q_restr_q2.outcome == 1)
          input:
            control: Dropdown
            labels:
              1: "Injury - at home"
              2: "Injury - sports or recreation"
              3: "Injury - motor vehicle"
              4: "Injury - work-related"
              5: "Existed at birth"
              6: "Work environment"
              7: "Disease or illness"
              8: "Natural aging process"
              9: "Psychological or physical abuse"
              10: "Other (Specify)"

        # RESTR-Q6 / RAC4_6A-RAC4_6G: Help needed (Checkbox — always asked)
        - id: q_restr_q6
          kind: Question
          title: "The next question asks about help received. Because of any condition or health problem, do(es) ... need the help of another person in any of the following? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Preparing meals"
              2: "Shopping for groceries or other necessities"
              4: "Doing normal everyday housework"
              8: "Doing heavy household chores such as washing walls, yard work, etc."
              16: "Personal care such as washing, dressing or eating"
              32: "Moving about inside the house"
              64: "None of the above"

    # =========================================================================
    # CHRONIC CONDITIONS
    # =========================================================================
    # CHRON-CINT: If age < 12, skip entire block
    # CHRON-INT -> CHRON-Q1 (individual Switch per condition)
    #   -> CHRON-Q1mm  if cancer = Yes
    #   -> CHRON-Q1cc1 if asthma = Yes
    #   -> CHRON-Q1cc2 if asthma = Yes
    #
    # Age-conditional item:
    #   CCC4_1W (acne): only if age < 30
    #   CCC4_1R, CCC4_1S, CCC4_1T (Alzheimer's, cataracts, glaucoma): age >= 18
    # =========================================================================
    - id: b_chronic
      title: "Chronic Conditions"
      precondition:
        - predicate: age >= 12
      items:
        # CHRON-INT: Interviewer introduction
        - id: q_chron_int
          kind: Comment
          title: "Now I'd like to ask about any chronic health conditions ... may have. Again, 'long-term conditions' refer to conditions that have lasted or are expected to last 6 months or more."

        # CHRON-Q1a / CCC4_1A: Food allergies
        - id: q_chron_q1a
          kind: Question
          title: "Do(es) ... have any of the following long-term conditions diagnosed by a health professional — Food allergies?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1b / CCC4_1B: Other allergies
        - id: q_chron_q1b
          kind: Question
          title: "Do(es) ... have — Other allergies?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1c / CCC4_1C: Asthma
        - id: q_chron_q1c
          kind: Question
          title: "Do(es) ... have — Asthma?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1d / CCC4_1D: Arthritis or rheumatism
        - id: q_chron_q1d
          kind: Question
          title: "Do(es) ... have — Arthritis or rheumatism?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1e / CCC4_1E: Back problems
        - id: q_chron_q1e
          kind: Question
          title: "Do(es) ... have — Back problems excluding arthritis?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1f / CCC4_1F: High blood pressure
        - id: q_chron_q1f
          kind: Question
          title: "Do(es) ... have — High blood pressure?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1g / CCC4_1G: Migraine headaches
        - id: q_chron_q1g
          kind: Question
          title: "Do(es) ... have — Migraine headaches?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1h / CCC4_1H: Chronic bronchitis or emphysema
        - id: q_chron_q1h
          kind: Question
          title: "Do(es) ... have — Chronic bronchitis or emphysema?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1i / CCC4_1I: Sinusitis
        - id: q_chron_q1i
          kind: Question
          title: "Do(es) ... have — Sinusitis?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1j / CCC4_1J: Diabetes
        - id: q_chron_q1j
          kind: Question
          title: "Do(es) ... have — Diabetes?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1k / CCC4_1K: Epilepsy
        - id: q_chron_q1k
          kind: Question
          title: "Do(es) ... have — Epilepsy?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1l / CCC4_1L: Heart disease
        - id: q_chron_q1l
          kind: Question
          title: "Do(es) ... have — Heart disease?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1m / CCC4_1M: Cancer
        - id: q_chron_q1m
          kind: Question
          title: "Do(es) ... have — Cancer?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1n / CCC4_1N: Stomach or intestinal ulcers
        - id: q_chron_q1n
          kind: Question
          title: "Do(es) ... have — Stomach or intestinal ulcers?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1o / CCC4_1O: Effects of stroke
        - id: q_chron_q1o
          kind: Question
          title: "Do(es) ... have — Effects of stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1p / CCC4_1P: Urinary incontinence
        - id: q_chron_q1p
          kind: Question
          title: "Do(es) ... have — Urinary incontinence?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1w / CCC4_1W: Acne requiring prescription medication (age < 30 only)
        - id: q_chron_q1w
          kind: Question
          title: "Do(es) ... have — Acne requiring prescription medication?"
          precondition:
            - predicate: age < 30
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1r / CCC4_1R: Alzheimer's disease or other dementia (age >= 18 only)
        - id: q_chron_q1r
          kind: Question
          title: "Do(es) ... have — Alzheimer's disease or other dementia?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1s / CCC4_1S: Cataracts (age >= 18 only)
        - id: q_chron_q1s
          kind: Question
          title: "Do(es) ... have — Cataracts?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1t / CCC4_1T: Glaucoma (age >= 18 only)
        - id: q_chron_q1t
          kind: Question
          title: "Do(es) ... have — Glaucoma?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1v / CCC4_1V: Any other long term condition
        - id: q_chron_q1v
          kind: Question
          title: "Do(es) ... have — Any other long term condition? (Specify)"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1mm / CCC4_M1: Cancer type follow-up
        # Precondition: cancer = Yes (Switch on = 1)
        - id: q_chron_q1mm
          kind: Question
          title: "What type(s) of cancer is this? For example, skin, lung or colon cancer."
          precondition:
            - predicate: q_chron_q1m.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe the type(s) of cancer (up to 50 characters)"
            maxLength: 50

        # CHRON-Q1cc1 / CCC4_C7: Asthma attack in past 12 months
        # Precondition: asthma = Yes
        - id: q_chron_q1cc1
          kind: Question
          title: "Have/Has ... had an attack of asthma in the past 12 months?"
          precondition:
            - predicate: q_chron_q1c.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CHRON-Q1cc2 / CCC4_C8: Wheezing or whistling in chest in past 12 months
        # Precondition: asthma = Yes
        - id: q_chron_q1cc2
          kind: Question
          title: "Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months?"
          precondition:
            - predicate: q_chron_q1c.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
