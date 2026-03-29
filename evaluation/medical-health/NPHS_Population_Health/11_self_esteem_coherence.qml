qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Self-Esteem, Mastery, and Sense of Coherence"
  codeInit: |
    # Extern variable from household section
    age: range(0, 120)

  blocks:
    # =========================================================================
    # BLOCK 1: SELF-ESTEEM (ESTEEM-Q1)
    # =========================================================================
    # Age >= 12, non-proxy only.
    # ESTEEM-Q1: 6-item Rosenberg-style self-esteem battery on 5-point Likert.
    # R on first sub-item in original CATI --> skip to Sense of Coherence.
    # Modeled as QuestionGroup with Radio (forced response 1-5; refusal omitted).
    # Index mapping:
    #   [0] PY_4_E1A - You feel that you have a number of good qualities
    #   [1] PY_4_E1B - You feel that you're a person of worth at least equal to others
    #   [2] PY_4_E1C - You are able to do things as well as most other people
    #   [3] PY_4_E1D - You take a positive attitude toward yourself
    #   [4] PY_4_E1E - On the whole you are satisfied with yourself
    #   [5] PY_4_E1F - All in all, you're inclined to feel you're a failure
    # =========================================================================
    - id: b_self_esteem
      title: "Self-Esteem"
      precondition:
        - predicate: age >= 12
      items:
        # ESTEEM-Q1 / PY_4_E1A-PY_4_E1F: Self-esteem battery
        - id: qg_esteem_q1
          kind: QuestionGroup
          title: "Now, I am going to read you a series of statements that people might use to describe themselves. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE or STRONGLY DISAGREE with each of the following:"
          questions:
            - "(a) You feel that you have a number of good qualities."
            - "(b) You feel that you're a person of worth at least equal to others."
            - "(c) You are able to do things as well as most other people."
            - "(d) You take a positive attitude toward yourself."
            - "(e) On the whole you are satisfied with yourself."
            - "(f) All in all, you're inclined to feel you're a failure."
          input:
            control: Radio
            labels:
              1: "Strongly Agree"
              2: "Agree"
              3: "Neither Agree Nor Disagree"
              4: "Disagree"
              5: "Strongly Disagree"

    # =========================================================================
    # BLOCK 2: MASTERY (MAST-Q1)
    # =========================================================================
    # Age >= 12, non-proxy only.
    # MAST-Q1: 7-item Pearlin Mastery Scale on 5-point Likert.
    # R on first sub-item in original CATI --> skip to Sense of Coherence.
    # Modeled as QuestionGroup with Radio (forced response 1-5; refusal omitted).
    # Index mapping:
    #   [0] PY_4_M1A - You have little control over the things that happen to you
    #   [1] PY_4_M1B - There is really no way you can solve some of the problems you have
    #   [2] PY_4_M1C - There is little you can do to change many of the important things in your life
    #   [3] PY_4_M1D - You often feel helpless in dealing with problems of life
    #   [4] PY_4_M1E - Sometimes you feel that you are being pushed around in life
    #   [5] PY_4_M1F - What happens to you in the future mostly depends on you
    #   [6] PY_4_M1G - You can do just about anything you really set your mind to
    # =========================================================================
    - id: b_mastery
      title: "Mastery"
      precondition:
        - predicate: age >= 12
      items:
        # MAST-Q1 / PY_4_M1A-PY_4_M1G: Mastery battery
        - id: qg_mast_q1
          kind: QuestionGroup
          title: "Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE or STRONGLY DISAGREE with each of the following:"
          questions:
            - "(a) You have little control over the things that happen to you."
            - "(b) There is really no way you can solve some of the problems you have."
            - "(c) There is little you can do to change many of the important things in your life."
            - "(d) You often feel helpless in dealing with problems of life."
            - "(e) Sometimes you feel that you are being pushed around in life."
            - "(f) What happens to you in the future mostly depends on you."
            - "(g) You can do just about anything you really set your mind to."
          input:
            control: Radio
            labels:
              1: "Strongly Agree"
              2: "Agree"
              3: "Neither Agree Nor Disagree"
              4: "Disagree"
              5: "Strongly Disagree"

    # =========================================================================
    # BLOCK 3: SENSE OF COHERENCE (SCOH)
    # =========================================================================
    # Age >= 18, non-proxy only.
    # SCOH-INT: Interviewer instruction (Comment).
    # SCOH-Q1 through Q13: 13 individual questions on 7-point semantic scale.
    # DK/R on SCOH-Q1 in original CATI --> skip to Health Status section.
    # Modeled with individual Radio questions (forced response 1-7).
    # Each question has unique anchor text incorporated into the title.
    # =========================================================================
    - id: b_sense_of_coherence
      title: "Sense of Coherence"
      precondition:
        - predicate: age >= 18
      items:
        # SCOH-INT: Interviewer instruction
        - id: q_scoh_int
          kind: Comment
          title: "Next is a series of questions relating to various aspects of people's lives. For each question please answer with a number between 1 and 7."

        # SCOH-Q1 / PY_4_H1: Feeling of indifference
        # DK/R --> skip to Health Status section (modeled as forced response)
        - id: q_scoh_q1
          kind: Question
          title: "How often do you have the feeling that you don't really care about what goes on around you? (1 = Very seldom or never, 7 = Very often)"
          input:
            control: Radio
            labels:
              1: "1 - Very seldom or never"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very often"

        # SCOH-Q2 / PY_4_H2: Surprised by behaviour of known people
        - id: q_scoh_q2
          kind: Question
          title: "How often in the past were you surprised by the behaviour of people whom you thought you knew well? (1 = Never happened, 7 = Always happened)"
          input:
            control: Radio
            labels:
              1: "1 - Never happened"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Always happened"

        # SCOH-Q3 / PY_4_H3: Disappointed by people counted on
        - id: q_scoh_q3
          kind: Question
          title: "How often have people you counted on disappointed you? (1 = Never happened, 7 = Always happened)"
          input:
            control: Radio
            labels:
              1: "1 - Never happened"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Always happened"

        # SCOH-Q4 / PY_4_H4: Feeling of unfair treatment
        - id: q_scoh_q4
          kind: Question
          title: "How often do you have the feeling you're being treated unfairly? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q5 / PY_4_H5: Feeling of unfamiliar situation
        - id: q_scoh_q5
          kind: Question
          title: "How often do you have the feeling you are in an unfamiliar situation and don't know what to do? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q6 / PY_4_H6: Mixed-up feelings and ideas
        - id: q_scoh_q6
          kind: Question
          title: "How often do you have very mixed-up feelings and ideas? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q7 / PY_4_H7: Unwanted feelings inside
        - id: q_scoh_q7
          kind: Question
          title: "How often do you have feelings inside that you would rather not feel? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q8 / PY_4_H8: Feeling like a sad sack / loser
        - id: q_scoh_q8
          kind: Question
          title: "Many people -- even those with a strong character -- sometimes feel like sad sacks (losers) in certain situations. How often have you felt this way in the past? (1 = Very seldom or never, 7 = Very often)"
          input:
            control: Radio
            labels:
              1: "1 - Very seldom or never"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very often"

        # SCOH-Q9 / PY_4_H9: Little meaning in daily activities
        - id: q_scoh_q9
          kind: Question
          title: "How often do you have the feeling that there's little meaning in the things you do in your daily life? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q10 / PY_4_H10: Feelings out of control
        - id: q_scoh_q10
          kind: Question
          title: "How often do you have feelings that you're not sure you can keep under control? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q11 / PY_4_H11: Life goals and purpose
        - id: q_scoh_q11
          kind: Question
          title: "Until now your life has had no clear goals or purpose or has it had very clear goals and purpose? (1 = No clear goals or no purpose at all, 7 = Very clear goals and purpose)"
          input:
            control: Radio
            labels:
              1: "1 - No clear goals or no purpose at all"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very clear goals and purpose"

        # SCOH-Q12 / PY_4_H12: Perspective on importance of events
        - id: q_scoh_q12
          kind: Question
          title: "When something happens, you generally find that you overestimate or underestimate its importance or you see things in the right proportion? (1 = Overestimate or underestimate, 7 = See things in the right proportion)"
          input:
            control: Radio
            labels:
              1: "1 - Overestimate or underestimate"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - See things in the right proportion"

        # SCOH-Q13 / PY_4_H13: Daily activities as pleasure or burden
        - id: q_scoh_q13
          kind: Question
          title: "Is doing the things you do every day a source of great pleasure and satisfaction or a source of pain and boredom? (1 = A great deal of pleasure and satisfaction, 7 = A source of pain and boredom)"
          input:
            control: Radio
            labels:
              1: "1 - A great deal of pleasure and satisfaction"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - A source of pain and boredom"
