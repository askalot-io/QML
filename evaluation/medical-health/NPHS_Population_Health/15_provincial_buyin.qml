qmlVersion: "1.0"
questionnaire:
  title: "NPHS - Provincial Buy-in (Manitoba and Alberta)"
  codeInit: |
    # Extern variable from household section
    age: range(0, 120)

    # Note: In the original questionnaire, only one of these blocks
    # would be administered depending on province of residence
    # (Manitoba = SPR6, Alberta = SPR8). In QML, both blocks are
    # included and gated by age >= 18.

  blocks:
    # =========================================================================
    # BLOCK 1: MANITOBA BUY-IN (SPR6-INTA to SPR6-Q13)
    # =========================================================================
    # Routing summary:
    #   All items: age >= 18 (non-proxy)
    #   SPR6-INTA: Introduction
    #   SPR6-INTB: Instructions for Yes/No questions
    #   SPR6-Q1 to Q11: Rational/emotional relating style (Switch Yes/No each)
    #   SPR6-INTQ12: Scenario intro
    #   SPR6-Q12: Dentist coping scenario (Checkbox, 9 options)
    #   SPR6-Q13: Layoff coping scenario (Checkbox, 9 options)
    # =========================================================================
    - id: b_manitoba
      title: "Manitoba Buy-in"
      precondition:
        - predicate: age >= 18
      items:
        # SPR6-INTA: Section introduction (no response)
        - id: q_spr6_inta
          kind: Comment
          title: "The next questions are being asked for your provincial government. They deal with the day-to-day demands in your life."

        # SPR6-INTB: Instructions for Yes/No questions (no response)
        - id: q_spr6_intb
          kind: Comment
          title: "When relating to people, some people rely heavily on their thinking, rational side. Others rely much more on their emotional side. Please answer either 'Yes' or 'No' to each question."

        # SPR6-Q1 / RTP4_1
        - id: q_spr6_q1
          kind: Question
          title: "Do you always try to do what is reasonable and logical?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q2 / RTP4_2
        - id: q_spr6_q2
          kind: Question
          title: "Do you always try to understand people and their behaviour, to avoid responding emotionally?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q3 / RTP4_3
        - id: q_spr6_q3
          kind: Question
          title: "When dealing with other people do you always try to act rationally?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q4 / RTP4_4
        - id: q_spr6_q4
          kind: Question
          title: "Do you try to overcome all conflicts with other people by intelligence and reason, trying hard not to show your emotions?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q5 / RTP4_5
        - id: q_spr6_q5
          kind: Question
          title: "If someone deeply hurts your feelings, do you nevertheless try to treat him or her rationally and to understand his or her way of behaving?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q6 / RTP4_6
        - id: q_spr6_q6
          kind: Question
          title: "Do you succeed in avoiding most conflicts with other people by relying on your reason and logic, even if this is not how you feel at the time?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q7 / RTP4_7
        - id: q_spr6_q7
          kind: Question
          title: "If someone acts against your needs and desires, do you nevertheless try to understand that person?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q8 / RTP4_8
        - id: q_spr6_q8
          kind: Question
          title: "Do you behave so rationally in most life situations that your behaviour is rarely influenced by only your emotions?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q9 / RTP4_9
        - id: q_spr6_q9
          kind: Question
          title: "Do your emotions frequently influence your behaviour to such a degree that your behaviour might be considered harmful to yourself and others?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q10 / RTP4_10
        - id: q_spr6_q10
          kind: Question
          title: "Do you try to understand others even if you don't like them?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q11 / RTP4_11
        - id: q_spr6_q11
          kind: Question
          title: "Does your rationality prevent you from verbally attacking or criticizing others, even if there are sufficient reasons for doing so?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-INTQ12: Scenario introduction (no response)
        - id: q_spr6_intq12
          kind: Comment
          title: "In the next few questions, you will be asked to imagine yourself in a particular situation."

        # SPR6-Q12 / RTP4_12A-12I: Dentist coping scenario
        # Checkbox — powers of 2: 1,2,4,8,16,32,64,128,256
        - id: q_spr6_q12
          kind: Question
          title: "Imagine you are afraid of the dentist and you have to get some dental work done. Which of the following things would you do to help you overcome your fears?"
          input:
            control: Checkbox
            labels:
              1: "Ask the dentist exactly what he is doing"
              2: "Take a tranquilizer or have a drink before going"
              4: "Try to think about other things"
              8: "Have the dentist tell you when you would feel pain"
              16: "Try to sleep"
              32: "Watch all the dentist's movements and listen for the sound of the drill"
              64: "Watch the flow of water from your mouth"
              128: "Do mental puzzles in your mind"
              256: "Other (Specify)"

        # SPR6-Q13 / RTP4_13A-13I: Layoff coping scenario
        # Checkbox — powers of 2: 1,2,4,8,16,32,64,128,256
        - id: q_spr6_q13
          kind: Question
          title: "Imagine that you are a salesperson and get along well with your fellow workers. It has been rumoured that several people will be laid off. Which of the following would you do?"
          input:
            control: Checkbox
            labels:
              1: "Talk to fellow workers about supervisor's evaluation"
              2: "Review list of duties"
              4: "Watch TV/go to movies to distract"
              8: "Try to remember disagreements with supervisor"
              16: "Push all thoughts of being laid off out of mind"
              32: "Rather not discuss chances of being laid off"
              64: "Think which employees might be evaluated more poorly"
              128: "Continue doing work as if nothing was happening"
              256: "Other (Specify)"

    # =========================================================================
    # BLOCK 2: ALBERTA BUY-IN (SPR8-INT to SPR8-Q4)
    # =========================================================================
    # Routing summary:
    #   All items: age >= 18 (non-proxy)
    #   SPR8-INT: Introduction
    #   SPR8-Q1: Day-to-day coping ability (Radio 1-5)
    #   SPR8-Q2: Day-to-day stress strategies (Checkbox, 9 options)
    #   SPR8-Q3: Unexpected problems ability (Radio 1-5)
    #   SPR8-Q4: Unexpected stress strategies (Checkbox, 9 options)
    # =========================================================================
    - id: b_alberta
      title: "Alberta Buy-in"
      precondition:
        - predicate: age >= 18
      items:
        # SPR8-INT: Section introduction (no response)
        - id: q_spr8_int
          kind: Comment
          title: "The next questions are being asked for your provincial government. They deal with the day-to-day demands in your life."

        # SPR8-Q1 / COP4_1: Day-to-day coping ability
        - id: q_spr8_q1
          kind: Question
          title: "How would you rate your ability to handle the day-to-day demands in your life, for example, work, family and volunteer responsibilities?"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very Good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # SPR8-Q2 / COP4_2A-2I: Day-to-day stress strategies
        # Checkbox — powers of 2: 1,2,4,8,16,32,64,128,256
        - id: q_spr8_q2
          kind: Question
          title: "If the day-to-day demands in your life were causing you to feel under stress, which of the following would you do?"
          input:
            control: Checkbox
            labels:
              1: "Try not to think about situation/keep busy"
              2: "See situation in different light"
              4: "Think about ways to change situation/solve problem"
              8: "Express emotions to reduce tension"
              16: "Admit stressful but do nothing"
              32: "Talk about it with others"
              64: "Do something enjoyable to relax"
              128: "Pray/seek comfort through faith"
              256: "Do something else (Specify)"

        # SPR8-Q3 / COP4_3: Unexpected problems ability
        - id: q_spr8_q3
          kind: Question
          title: "How would you rate your ability to handle unexpected and difficult problems, for example, family or personal crisis?"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very Good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # SPR8-Q4 / COP4_4A-4I: Unexpected stress strategies
        # Checkbox — powers of 2: 1,2,4,8,16,32,64,128,256
        - id: q_spr8_q4
          kind: Question
          title: "If an unexpected problem or situation was causing you to feel under stress, which of the following would you do?"
          input:
            control: Checkbox
            labels:
              1: "Try not to think about situation/keep busy"
              2: "See situation in different light"
              4: "Think about ways to solve problem"
              8: "Express emotions to reduce tension"
              16: "Admit stressful but do nothing"
              32: "Talk about it with others"
              64: "Do something enjoyable to relax"
              128: "Pray/seek comfort through faith"
              256: "Do something else (Specify)"
