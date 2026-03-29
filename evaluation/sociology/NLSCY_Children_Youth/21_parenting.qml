qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Parenting (PAR)"
  codeInit: |
    # Variables READ from prior sections
    relationship_to_child = 0  # 1=biological, 2=step, 3=adoptive, 4=foster
    is_pmk_or_spouse = 0       # 1=PMK or PMK's spouse/partner, 0=other
    child_age = 0              # child's age from demographics section

  blocks:
    # =========================================================================
    # BLOCK 1: POSITIVE INTERACTION (PAR-Q1 through PAR-Q7/Q7A)
    # =========================================================================
    # PAR-C1: IF foster parent → skip entire section.
    #         IF PMK or PMK's spouse → show; OTHERWISE → skip.
    # Modeled as block precondition on is_pmk_or_spouse and not foster.
    # PAR-I1: Intro
    # PAR-Q1-Q6: 6 positive interaction items (5-point frequency)
    # PAR-C7: IF age < 3 → Q7A; ELSE → Q7. Mutually exclusive variants.
    # =========================================================================
    - id: b_par_positive
      title: "Parenting - Positive Interaction"
      precondition:
        - predicate: is_pmk_or_spouse == 1
        - predicate: relationship_to_child != 4
      items:
        # PAR-I1: Intro
        - id: q_par_intro
          kind: Comment
          title: "The following questions have to do with things that the child does and ways that you react to him/her."

        # PAR-Q1 through PAR-Q6: Positive interaction frequency
        # Index mapping:
        #   [0] Q1 - Praise
        #   [1] Q2 - Talk/play together
        #   [2] Q3 - Laugh together
        #   [3] Q4 - Get annoyed
        #   [4] Q5 - Tell bad/not as good
        #   [5] Q6 - Do something special
        - id: qg_par_positive
          kind: QuestionGroup
          title: "How often do you do each of the following with the child?"
          questions:
            - "(1) Praise him/her, by saying something like \"Good for you!\" or \"What a nice thing you did!\" or \"That's good going!\"?"
            - "(2) Talk or play with each other, focusing attention on each other for five minutes or more, just for fun?"
            - "(3) Laugh together?"
            - "(4) Get annoyed with him/her for saying or doing something he/she is not supposed to?"
            - "(5) Tell him/her that he/she is bad or not as good as others?"
            - "(6) Do something special with him/her that he/she enjoys?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        # PAR-Q7: Play sports/hobbies (age 3+)
        # PAR-C7: IF age < 3 → Q7A; ELSE → Q7
        - id: q_par_q7
          kind: Question
          title: "How often do you play sports, hobbies or games with him/her?"
          precondition:
            - predicate: child_age >= 3
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        # PAR-Q7A: Play games (age 0-2)
        - id: q_par_q7a
          kind: Question
          title: "How often do you play games with him/her?"
          precondition:
            - predicate: child_age < 3
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

    # =========================================================================
    # BLOCK 2: DISCIPLINE EFFECTIVENESS (PAR-Q8 through PAR-Q18)
    # =========================================================================
    # PAR-C8: IF age < 2 → skip to custody section. Modeled as block
    #         precondition child_age >= 2.
    # PAR-I8A: Intro
    # PAR-Q8-Q18: 11 discipline items (5-point proportion scale)
    # =========================================================================
    - id: b_par_discipline
      title: "Parenting - Discipline Effectiveness"
      precondition:
        - predicate: is_pmk_or_spouse == 1
        - predicate: relationship_to_child != 4
        - predicate: child_age >= 2
      items:
        # PAR-I8A: Intro
        - id: q_par_discipline_intro
          kind: Comment
          title: "Now, we know that when parents spend time together with their children, some of the time things go well and some of the time they don't go well. For the following questions, I would like you to tell me what proportion of the time things turn out in different ways."

        # PAR-Q8 through PAR-Q18: Discipline proportion items
        # Index mapping:
        #   [0]  Q8  - Proportion of talk that is praise
        #   [1]  Q9  - Proportion of talk that is disapproval
        #   [2]  Q10 - Make sure commands are followed
        #   [3]  Q11 - Follow through on punishment threats
        #   [4]  Q12 - Gets away with things deserving punishment
        #   [5]  Q13 - Get angry when punishing
        #   [6]  Q14 - Punishment depends on mood
        #   [7]  Q15 - Problems managing in general
        #   [8]  Q16 - Able to get out of punishment
        #   [9]  Q17 - Ignores punishment
        #   [10] Q18 - Discipline repeatedly for same thing
        - id: qg_par_discipline
          kind: QuestionGroup
          title: "For each of the following, please indicate what proportion of the time this happens:"
          questions:
            - "(8) Of all the times that you talk to him/her about his/her behaviour, what proportion is praise?"
            - "(9) Of all the times that you talk to him/her about his/her behaviour, what proportion is disapproval?"
            - "(10) When you give him/her a command or order to do something, what proportion of the time do you make sure that he/she does it?"
            - "(11) If you tell him/her he/she will get punished if he/she doesn't stop doing something, and he/she keeps doing it, how often will you punish him/her?"
            - "(12) How often does he/she get away with things that you feel should have been punished?"
            - "(13) How often do you get angry when you punish him/her?"
            - "(14) How often do you think that the kind of punishment you give him/her depends on your mood?"
            - "(15) How often do you feel you are having problems managing him/her in general?"
            - "(16) How often is he/she able to get out of a punishment when he/she really sets his/her mind to it?"
            - "(17) How often when you discipline him/her, does he/she ignore the punishment?"
            - "(18) How often do you have to discipline him/her repeatedly for the same thing?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than half the time"
              3: "About half the time"
              4: "More than half the time"
              5: "All the time"

    # =========================================================================
    # BLOCK 3: REACTIONS TO RULE-BREAKING (PAR-Q19 through PAR-Q25)
    # =========================================================================
    # PAR-I19A: Intro
    # PAR-Q19-Q25: 7 reaction items (5-point frequency, Always to Never)
    # Same age >= 2 gate as block 2.
    # =========================================================================
    - id: b_par_reactions
      title: "Parenting - Reactions to Rule-Breaking"
      precondition:
        - predicate: is_pmk_or_spouse == 1
        - predicate: relationship_to_child != 4
        - predicate: child_age >= 2
      items:
        # PAR-I19A: Intro
        - id: q_par_reactions_intro
          kind: Comment
          title: "Just about all children break the rules or do things that they are not supposed to. Also, parents react in different ways. Please tell me how often you do each of the following when the child breaks the rules or does things that he/she is not supposed to."

        # PAR-Q19 through PAR-Q25: Reaction items
        # Index mapping:
        #   [0] Q19 - Tell to stop
        #   [1] Q20 - Ignore / do nothing
        #   [2] Q21 - Raise voice / scold / yell
        #   [3] Q22 - Calmly discuss
        #   [4] Q23 - Use physical punishment
        #   [5] Q24 - Describe acceptable alternatives
        #   [6] Q25 - Take away privileges / put in room
        - id: qg_par_reactions
          kind: QuestionGroup
          title: "How often do you do each of the following when the child breaks the rules or does things that he/she is not supposed to?"
          questions:
            - "(19) Tell him/her to stop?"
            - "(20) Ignore it, do nothing?"
            - "(21) Raise your voice, scold or yell at him/her?"
            - "(22) Calmly discuss the problem?"
            - "(23) Use physical punishment?"
            - "(24) Describe alternative ways of behaving that are acceptable?"
            - "(25) Take away privileges or put in room?"
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

    # =========================================================================
    # BLOCK 4: FOOD SECURITY AND EXPOSURE (PAR-Q26A through PAR-Q28)
    # =========================================================================
    # PAR-I26A: Intro
    # PAR-Q26A: Food insecurity (Switch)
    # PAR-Q26B: Frequency (only if Q26A = YES)
    # PAR-Q26C: Coping strategies (Checkbox, only if Q26A = YES)
    # PAR-Q27: TV violence exposure
    # PAR-Q28: Household physical fighting
    # Same age >= 2 gate as blocks 2-3.
    # =========================================================================
    - id: b_par_food_exposure
      title: "Parenting - Food Security and Exposure"
      precondition:
        - predicate: is_pmk_or_spouse == 1
        - predicate: relationship_to_child != 4
        - predicate: child_age >= 2
      items:
        # PAR-I26A: Intro
        - id: q_par_food_intro
          kind: Comment
          title: "Sometimes different situations or circumstances arise which may affect family life. The next few questions are about some of these possible situations."

        # PAR-Q26A: Food insecurity
        - id: q_par_q26a
          kind: Question
          title: "Has he/she ever experienced being hungry because the family has run out of food or money to buy food?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # PAR-Q26B: How often hungry (only if Q26A = YES)
        - id: q_par_q26b
          kind: Question
          title: "How often?"
          precondition:
            - predicate: q_par_q26a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Regularly, end of the month"
              2: "More often than end of each month"
              3: "Every few months"
              4: "Occasionally, not a regular occurrence"

        # PAR-Q26C: Coping strategies (only if Q26A = YES)
        - id: q_par_q26c
          kind: Question
          title: "How do you cope with feeding him/her when this happens? (Mark all that apply.)"
          precondition:
            - predicate: q_par_q26a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Parent/guardian skips meals or eats less"
              2: "Children skip meals or eat less"
              4: "Cut down on variety of food family usually eats"
              8: "Seek help from relatives"
              16: "Seek help from friends"
              32: "Seek help from social worker/government office"
              64: "Seek help from food bank (emergency food program)"
              128: "Use school meal program"
              256: "Other"

        # PAR-Q27: TV violence exposure
        - id: q_par_q27
          kind: Question
          title: "How often does he/she see television shows or movies that have a lot of violence in them?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # PAR-Q28: Household physical fighting
        - id: q_par_q28
          kind: Question
          title: "How often does he/she see adults or teenagers in your house physically fighting, hitting or otherwise trying to hurt others?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"
