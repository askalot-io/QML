qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Health Status (HSTAT)"
  codeInit: |
    # No cross-section variables read or produced by this section.
    pass

  blocks:
    # =========================================================================
    # BLOCK 1: SECTION INTRODUCTION
    # =========================================================================
    # HSTAT-INT: Interviewer instruction introducing the section.
    # =========================================================================
    - id: b_intro
      title: "Section Introduction"
      items:
        # HSTAT-INT: Section introduction — no response collected
        - id: q_hstat_int
          kind: Comment
          title: "The next set of questions ask about ...(r/'s) day to day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with a person's usual abilities."

    # =========================================================================
    # BLOCK 2: VISION (HSTAT-Q1 to HSTAT-Q5)
    # =========================================================================
    # Q1: See newsprint without glasses? Yes→Q4, No→Q2
    # Q2: See newsprint with glasses? Yes→Q4, No→Q3
    # Q3: Able to see at all? Yes→continues, No→Q6 (end of vision)
    # Q4: Recognize friend across street without glasses? Yes→Q6, No→Q5
    # Q5: Recognize friend with glasses? (shown when Q4=No)
    #
    # Precondition cascade:
    #   Q2: Q1=No
    #   Q3: Q1=No AND Q2=No
    #   Q4: Q1=Yes OR Q2=Yes
    #   Q5: (Q1=Yes OR Q2=Yes) AND Q4=No
    # =========================================================================
    - id: b_vision
      title: "Vision"
      items:
        # HSTAT-Q1 / HSC4_1: See newsprint without glasses?
        # Yes(1) → skip to Q4; No(0) → continue to Q2
        - id: q_hstat_q1
          kind: Question
          title: "Are/Is ... usually able to see well enough to read ordinary newsprint without glasses or contact lenses?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q2 / HSC4_2: See newsprint with glasses?
        # Shown only when Q1=No (cannot read without glasses)
        # Yes(1) → skip to Q4; No(0) → continue to Q3
        - id: q_hstat_q2
          kind: Question
          title: "Are/Is you/he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?"
          precondition:
            - predicate: q_hstat_q1.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q3 / HSC4_3: Able to see at all?
        # Shown only when Q1=No AND Q2=No (cannot read even with glasses)
        # Yes(1) → continue to Q4; No(0) → skip to Q6 (end of vision block)
        - id: q_hstat_q3
          kind: Question
          title: "Are/Is you/he/she able to see at all?"
          precondition:
            - predicate: q_hstat_q1.outcome == 0 and q_hstat_q2.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q4 / HSC4_4: Recognize friend across street without glasses?
        # Shown when Q1=Yes OR Q2=Yes (able to read newsprint at some level)
        # Yes(1) → skip to Q6; No(0) → continue to Q5
        - id: q_hstat_q4
          kind: Question
          title: "Are/Is you/he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: q_hstat_q1.outcome == 1 or q_hstat_q2.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q5 / HSC4_5: Recognize friend with glasses?
        # Shown when Q4 was asked (Q1=Yes or Q2=Yes) AND Q4=No
        - id: q_hstat_q5
          kind: Question
          title: "Are/Is you/he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: (q_hstat_q1.outcome == 1 or q_hstat_q2.outcome == 1) and q_hstat_q4.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 3: HEARING (HSTAT-Q6 to HSTAT-Q9)
    # =========================================================================
    # Q6: Hear group conversation without hearing aid? Yes→Q10, No→Q7
    # Q7: Hear group conversation with hearing aid? Yes→Q8, No→Q7a
    # Q7a: Able to hear at all? Yes→continues, No→Q10 (end of hearing)
    # Q8: Hear one person in quiet room without aid? Yes→Q10, No→Q9
    # Q9: Hear one person in quiet room with aid? (shown when Q8=No)
    #
    # Precondition cascade:
    #   Q7: Q6=No
    #   Q7a: Q6=No AND Q7=No
    #   Q8: Q6=No AND Q7=Yes
    #   Q9: Q6=No AND Q7=Yes AND Q8=No
    # =========================================================================
    - id: b_hearing
      title: "Hearing"
      items:
        # HSTAT-Q6 / HSC4_6: Hear group conversation without hearing aid?
        # Yes(1) → skip to Q10 (Speech block); No(0) → continue to Q7
        - id: q_hstat_q6
          kind: Question
          title: "Are/Is ... usually able to hear what is said in a group conversation with at least three other people without a hearing aid?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q7 / HSC4_7: Hear group conversation with hearing aid?
        # Shown when Q6=No (cannot hear group without aid)
        # Yes(1) → skip to Q8 (one-on-one check); No(0) → Q7a (can hear at all?)
        - id: q_hstat_q7
          kind: Question
          title: "Are/Is you/he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?"
          precondition:
            - predicate: q_hstat_q6.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q7a / HSC4_7A: Able to hear at all?
        # Shown when Q6=No AND Q7=No (cannot hear group even with aid)
        # Yes(1) → continues to Q8; No(0) → skip to Q10 (Speech block)
        - id: q_hstat_q7a
          kind: Question
          title: "Are/Is you/he/she able to hear at all?"
          precondition:
            - predicate: q_hstat_q6.outcome == 0 and q_hstat_q7.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q8 / HSC4_8: Hear one person in quiet room without hearing aid?
        # Shown when Q6=No AND Q7=Yes (can hear group with aid but Q8 checks
        # finer-grained one-on-one hearing without aid)
        # Yes(1) → skip to Q10; No(0) → continue to Q9
        - id: q_hstat_q8
          kind: Question
          title: "Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: q_hstat_q6.outcome == 0 and q_hstat_q7.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q9 / HSC4_9: Hear one person in quiet room with hearing aid?
        # Shown when Q8 was asked (Q6=No, Q7=Yes) AND Q8=No
        - id: q_hstat_q9
          kind: Question
          title: "Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?"
          precondition:
            - predicate: q_hstat_q6.outcome == 0 and q_hstat_q7.outcome == 1 and q_hstat_q8.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 4: SPEECH (HSTAT-Q10 to HSTAT-Q13)
    # =========================================================================
    # Q10: Completely understood by strangers? Yes→Q14, No→Q11
    # Q11: Partially understood by strangers? Yes or No → Q12
    # Q12: Completely understood by people who know you? Yes→Q14, No→Q13
    # Q13: Partially understood by people who know you? Yes or No → Q14
    #
    # Precondition cascade:
    #   Q11: Q10=No
    #   Q12: Q10=No (asked after Q11 regardless of Q11 outcome)
    #   Q13: Q10=No AND Q12=No
    # =========================================================================
    - id: b_speech
      title: "Speech"
      items:
        # HSTAT-Q10 / HSC4_10: Completely understood by strangers?
        # Yes(1) → skip to Q14 (Getting Around); No(0) → continue to Q11
        - id: q_hstat_q10
          kind: Question
          title: "Are/Is ... usually able to be understood completely when speaking with strangers in your own language?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q11 / HSC4_11: Partially understood by strangers?
        # Shown when Q10=No (cannot be completely understood by strangers)
        - id: q_hstat_q11
          kind: Question
          title: "Are/Is you/he/she able to be understood partially when speaking with strangers?"
          precondition:
            - predicate: q_hstat_q10.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q12 / HSC4_12: Completely understood by those who know you?
        # Shown when Q10=No (continues speech capability assessment)
        # Yes(1) → skip to Q14; No(0) → continue to Q13
        - id: q_hstat_q12
          kind: Question
          title: "Are/Is you/he/she able to be understood completely when speaking with those who know you/him/her well?"
          precondition:
            - predicate: q_hstat_q10.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q13 / HSC4_13: Partially understood by those who know you?
        # Shown when Q10=No AND Q12=No (cannot be completely understood even
        # by people who know respondent well)
        - id: q_hstat_q13
          kind: Question
          title: "Are/Is you/he/she able to be understood partially when speaking with those who know you/him/her well?"
          precondition:
            - predicate: q_hstat_q10.outcome == 0 and q_hstat_q12.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 5: GETTING AROUND (HSTAT-Q14 to HSTAT-Q20)
    # =========================================================================
    # Q14: Walk around neighbourhood without difficulty or mechanical support?
    #      Yes→Q21 (Hands block), No→Q15
    # Q15: Able to walk at all? Yes→Q16, No→Q18
    # Q16: Require mechanical support (braces, cane, crutches) to walk?
    #      (shown when Q15=Yes)
    # Q17: Require help from another person to walk? (shown when Q15=Yes)
    # Q18: Require wheelchair? Yes→Q19, No→Q21
    # Q19: How often use wheelchair? (shown when Q18=Yes)
    # Q20: Need help of another person in wheelchair? (shown when Q18=Yes)
    #
    # Precondition cascade:
    #   Q15: Q14=No
    #   Q16: Q14=No AND Q15=Yes
    #   Q17: Q14=No AND Q15=Yes
    #   Q18: Q14=No AND Q15=No
    #   Q19: Q14=No AND Q15=No AND Q18=Yes
    #   Q20: Q14=No AND Q15=No AND Q18=Yes
    # =========================================================================
    - id: b_getting_around
      title: "Getting Around"
      items:
        # HSTAT-Q14 / HSC4_14: Walk around neighbourhood without difficulty?
        # Yes(1) → skip to Q21 (Hands block); No(0) → continue to Q15
        - id: q_hstat_q14
          kind: Question
          title: "Are/Is ... usually able to walk around the neighbourhood without difficulty and without mechanical support?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q15 / HSC4_15: Able to walk at all?
        # Shown when Q14=No (some difficulty walking)
        # Yes(1) → continue to Q16 (needs mechanical support check)
        # No(0) → skip to Q18 (wheelchair check)
        - id: q_hstat_q15
          kind: Question
          title: "Are/Is you/he/she able to walk at all?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q16 / HSC4_16: Require mechanical support to walk?
        # Shown when Q14=No AND Q15=Yes (can walk but with some difficulty)
        - id: q_hstat_q16
          kind: Question
          title: "Do/Does you/he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q17 / HSC4_17: Require help of another person to walk?
        # Shown when Q14=No AND Q15=Yes (can walk but with some difficulty)
        - id: q_hstat_q17
          kind: Question
          title: "Do/Does you/he/she require the help of another person to be able to walk?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q18 / HSC4_18: Require a wheelchair to get around?
        # Shown when Q14=No AND Q15=No (cannot walk at all)
        # Yes(1) → continue to Q19; No(0) → skip to Q21 (Hands block)
        - id: q_hstat_q18
          kind: Question
          title: "Do/Does you/he/she require a wheelchair to get around?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q19 / HSC4_19: How often use wheelchair?
        # Shown when Q14=No AND Q15=No AND Q18=Yes
        - id: q_hstat_q19
          kind: Question
          title: "How often do/does you/he/she use a wheelchair?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 0 and q_hstat_q18.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Never"

        # HSTAT-Q20 / HSC4_20: Need help of another person in wheelchair?
        # Shown when Q14=No AND Q15=No AND Q18=Yes
        - id: q_hstat_q20
          kind: Question
          title: "Do/Does you/he/she need the help of another person to get around in the wheelchair?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 0 and q_hstat_q18.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 6: HANDS AND FINGERS (HSTAT-Q21 to HSTAT-Q24)
    # =========================================================================
    # Q21: Usually able to grasp/handle small objects? Yes→Q25, No→Q22
    # Q22: Require help of another person due to hand/finger limitations?
    #      Yes→Q23, No→Q24
    # Q23: Help with which tasks? (shown when Q22=Yes)
    # Q24: Require special equipment due to hand/finger limitations?
    #      (shown when Q21=No, after Q23 if applicable)
    #
    # Precondition cascade:
    #   Q22: Q21=No
    #   Q23: Q21=No AND Q22=Yes
    #   Q24: Q21=No (shown regardless of Q22 outcome, after Q23 if applicable)
    # =========================================================================
    - id: b_hands_fingers
      title: "Hands and Fingers"
      items:
        # HSTAT-Q21 / HSC4_21: Usually able to grasp and handle small objects?
        # Yes(1) → skip to Q25 (Feelings block); No(0) → continue to Q22
        - id: q_hstat_q21
          kind: Question
          title: "Are/Is ... usually able to grasp and handle small objects such as a pencil and scissors?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q22 / HSC4_22: Require help of another person due to hand/finger limitations?
        # Shown when Q21=No
        # Yes(1) → continue to Q23; No(0) → skip to Q24
        - id: q_hstat_q22
          kind: Question
          title: "Do/Does you/he/she require the help of another person because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_hstat_q21.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q23 / HSC4_23: Help with which tasks?
        # Shown when Q21=No AND Q22=Yes
        - id: q_hstat_q23
          kind: Question
          title: "Do/Does you/he/she require the help of another person with:"
          precondition:
            - predicate: q_hstat_q21.outcome == 0 and q_hstat_q22.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some tasks"
              2: "Most tasks"
              3: "Almost all tasks"
              4: "All tasks"

        # HSTAT-Q24 / HSC4_24: Require special equipment due to hand/finger limitations?
        # Shown when Q21=No (regardless of Q22 outcome)
        - id: q_hstat_q24
          kind: Question
          title: "Do/Does you/he/she require special equipment because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_hstat_q21.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 7: FEELINGS (HSTAT-Q25)
    # =========================================================================
    # Q25: Single question — always asked; no branching.
    # =========================================================================
    - id: b_feelings
      title: "Feelings"
      items:
        # HSTAT-Q25 / HSC4_25: Usual emotional state
        - id: q_hstat_q25
          kind: Question
          title: "Would you describe yourself/... as being usually:"
          input:
            control: Radio
            labels:
              1: "Happy and interested in life"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Unhappy with little interest in life"
              5: "So unhappy that life is not worthwhile"

    # =========================================================================
    # BLOCK 8: MEMORY (HSTAT-Q26)
    # =========================================================================
    # Q26: Single question — always asked; no branching.
    # =========================================================================
    - id: b_memory
      title: "Memory"
      items:
        # HSTAT-Q26 / HSC4_26: Usual ability to remember things
        - id: q_hstat_q26
          kind: Question
          title: "How would you describe your/his/her usual ability to remember things?"
          input:
            control: Radio
            labels:
              1: "Able to remember most things"
              2: "Somewhat forgetful"
              3: "Very forgetful"
              4: "Unable to remember anything at all"

    # =========================================================================
    # BLOCK 9: THINKING (HSTAT-Q27)
    # =========================================================================
    # Q27: Single question — always asked; no branching.
    # =========================================================================
    - id: b_thinking
      title: "Thinking"
      items:
        # HSTAT-Q27 / HSC4_27: Usual ability to think and solve problems
        - id: q_hstat_q27
          kind: Question
          title: "How would you describe your/his/her usual ability to think and solve day to day problems?"
          input:
            control: Radio
            labels:
              1: "Able to think clearly and solve problems"
              2: "Having a little difficulty"
              3: "Having some difficulty"
              4: "Having a great deal of difficulty"
              5: "Unable to think or solve problems"

    # =========================================================================
    # BLOCK 10: PAIN AND DISCOMFORT (HSTAT-Q28 to HSTAT-Q30)
    # =========================================================================
    # Q28: Usually free of pain? Yes→Drug Use section (end), No→Q29
    # Q29: Pain intensity (shown when Q28=No)
    # Q30: Activities prevented by pain (shown when Q28=No)
    # =========================================================================
    - id: b_pain
      title: "Pain and Discomfort"
      items:
        # HSTAT-Q28 / HSC4_28: Usually free of pain or discomfort?
        # Yes(1) → end of section (skip Q29/Q30); No(0) → continue to Q29
        - id: q_hstat_q28
          kind: Question
          title: "Are/Is ... usually free of pain or discomfort?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q29 / HSC4_29: Usual intensity of pain or discomfort
        # Shown when Q28=No (not free of pain)
        - id: q_hstat_q29
          kind: Question
          title: "How would you describe the usual intensity of your/his/her pain or discomfort?"
          precondition:
            - predicate: q_hstat_q28.outcome == 0
          input:
            control: Radio
            labels:
              1: "Mild"
              2: "Moderate"
              3: "Severe"

        # HSTAT-Q30 / HSC4_30: How many activities does pain prevent?
        # Shown when Q28=No (not free of pain)
        - id: q_hstat_q30
          kind: Question
          title: "How many activities does your/his/her pain or discomfort prevent?"
          precondition:
            - predicate: q_hstat_q28.outcome == 0
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Some"
              4: "Most"
