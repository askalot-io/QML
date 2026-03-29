qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health - Stress and Work Stress"
  codeInit: |
    # Extern variables from prior sections
    age: range(0, 120)
    marital_status: {1, 2, 3, 4, 5, 6, 7}
    lfs_work: {0, 1}

    # Variable produced by this section
    has_children = 0

  blocks:
    # =========================================================================
    # BLOCK 1: ONGOING PROBLEMS (CSTRESS)
    # =========================================================================
    # Age >= 18 and non-proxy only.
    #
    # CSTRESS-Q1: R --> skip entire Ongoing Problems section
    # CSTRESS-MARITAL check:
    #   married/common-law/living-with-partner (1/2/3) --> Q5-Q7
    #   otherwise --> Q8 (single/widowed/separated/divorced/unknown)
    # CSTRESS-Q7 --> GO TO Q9 (skip Q8)
    # CSTRESS-Q9: children? No/DK/R --> GO TO Q12
    # Q10-Q11: precondition has_children == 1
    # Q12-Q18: always shown (within age >= 18 gate)
    # =========================================================================
    - id: b_ongoing_problems
      title: "Ongoing Problems"
      precondition:
        - predicate: age >= 18
      items:
        # STRESS-INT: section introduction (no response)
        - id: q_stress_intro
          kind: Comment
          title: "The next portion of the questionnaire deals with different kinds of stress. Although the questions may seem repetitive, they are related to various aspects of a person's physical, emotional and mental health."

        # CSTRESS-INT: instruction text (no response)
        - id: q_cstress_intro
          kind: Comment
          title: "I'll start by describing situations that sometimes come up in people's lives. I'd like you to tell me if these things are true for you at this time by answering 'true' if it applies to you now or 'false' if it does not."

        # CSTRESS-Q1 / ST_4_C1: "You are trying to take on too many things at once."
        # R --> GO TO next section (Recent Life Events); modeled as Switch True/False.
        # No codeBlock needed — subsequent items gate on q_cstress_q1.outcome != 9
        # (R is not expressible as a value in Switch; the R-skip is a CATI
        # interviewer-level abort. In self-administered QML we treat all
        # Q1-Q18 as always shown when age >= 18, which is the intent.)
        - id: q_cstress_q1
          kind: Question
          title: "You are trying to take on too many things at once."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q2 / ST_4_C2
        - id: q_cstress_q2
          kind: Question
          title: "There is too much pressure on you to be like other people."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q3 / ST_4_C3
        - id: q_cstress_q3
          kind: Question
          title: "Too much is expected of you by others."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q4 / ST_4_C4
        - id: q_cstress_q4
          kind: Question
          title: "You don't have enough money to buy the things you need."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-MARITAL check:
        # married/common-law/living-with-partner → Q5, Q6, Q7 (then GO TO Q9)
        # single/widowed/separated/divorced/unknown → Q8 (then continue to Q9)

        # CSTRESS-Q5 / ST_4_C5 — only if married/common-law/partner
        - id: q_cstress_q5
          kind: Question
          title: "Your partner doesn't understand you."
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q6 / ST_4_C6
        - id: q_cstress_q6
          kind: Question
          title: "Your partner doesn't show enough affection."
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q7 / ST_4_C7 — after this, GO TO Q9 (skip Q8)
        # Q8 has precondition marital_status not in [1,2,3], so it is
        # naturally skipped when Q7 is shown.
        - id: q_cstress_q7
          kind: Question
          title: "Your partner is not committed enough to your relationship."
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q8 / ST_4_C8 — only if NOT married/common-law/partner
        - id: q_cstress_q8
          kind: Question
          title: "You find it is very difficult to find someone compatible with you."
          precondition:
            - predicate: marital_status not in [1, 2, 3]
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q9 / ST_4_C9: "Do you have any children?"
        # No/DK/R --> GO TO Q12 (skip Q10, Q11)
        # codeBlock sets has_children for downstream use (RECENT-Q10).
        - id: q_cstress_q9
          kind: Question
          title: "Do you have any children?"
          codeBlock: |
            has_children = 1 if q_cstress_q9.outcome == 1 else 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CSTRESS-Q10 / ST_4_C10 — only if has children
        - id: q_cstress_q10
          kind: Question
          title: "One of your children seems very unhappy."
          precondition:
            - predicate: q_cstress_q9.outcome == 1
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q11 / ST_4_C11
        - id: q_cstress_q11
          kind: Question
          title: "A child's behaviour is a source of serious concern to you."
          precondition:
            - predicate: q_cstress_q9.outcome == 1
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q12 / ST_4_C12 — always asked (within age >= 18 gate)
        - id: q_cstress_q12
          kind: Question
          title: "Your work around the home is not appreciated."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q13 / ST_4_C13
        - id: q_cstress_q13
          kind: Question
          title: "Your friends are a bad influence."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q14 / ST_4_C14
        - id: q_cstress_q14
          kind: Question
          title: "You would like to move but you cannot."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q15 / ST_4_C15
        - id: q_cstress_q15
          kind: Question
          title: "Your neighbourhood or community is too noisy or too polluted."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q16 / ST_4_C16
        - id: q_cstress_q16
          kind: Question
          title: "You have a parent, a child or partner who is in very bad health and may die."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q17 / ST_4_C17
        - id: q_cstress_q17
          kind: Question
          title: "Someone in your family has an alcohol or drug problem."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q18 / ST_4_C18
        - id: q_cstress_q18
          kind: Question
          title: "People are too critical of you or what you do."
          input:
            control: Switch
            off: "False"
            on: "True"

    # =========================================================================
    # BLOCK 2: RECENT LIFE EVENTS (RECENT)
    # =========================================================================
    # Age >= 18 and non-proxy only.
    #
    # RECENT-Q1: R --> skip entire section (CATI abort; modeled as always shown)
    # RECENT-Q2 through Q5: always asked (within gate)
    # RECENT-Q6, Q7: always asked
    # RECENT-MARITAL check: married/common-law/partner --> ask Q8
    # RECENT-Q9: always asked
    # RECENT-CHILDREN check: has_children == 1 --> ask Q10
    # =========================================================================
    - id: b_recent_life_events
      title: "Recent Life Events"
      precondition:
        - predicate: age >= 18
      items:
        # RECENT-INTa: introduction (no response)
        - id: q_recent_inta
          kind: Comment
          title: "Now I'd like to ask you about some things that may have happened in the past 12 months. First, I'd like to ask about yourself or anyone close to you (spouse/partner, children, relatives or close friends)."

        # RECENT-Q1 / ST_4_R1: "In the past 12 months, was any one of you beaten up or physically attacked?"
        # R --> GO TO next section (Childhood Stressors); CATI abort; modeled without skip.
        - id: q_recent_q1
          kind: Question
          title: "In the past 12 months, was any one of you beaten up or physically attacked?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-INTb: instruction (no response)
        - id: q_recent_intb
          kind: Comment
          title: "Now I'd like you to think just about your family (yourself and your spouse/partner or children, if any)."

        # RECENT-Q2 / ST_4_R2
        - id: q_recent_q2
          kind: Question
          title: "In the past 12 months, did you or someone in your family have an unwanted pregnancy?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q3 / ST_4_R3
        - id: q_recent_q3
          kind: Question
          title: "In the past 12 months, did you or someone in your family have an abortion or miscarriage?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q4 / ST_4_R4
        - id: q_recent_q4
          kind: Question
          title: "In the past 12 months, did you or someone in your family have a major financial crisis?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q5 / ST_4_R5
        - id: q_recent_q5
          kind: Question
          title: "In the past 12 months, did you or someone in your family fail school or a training program?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-INTc: instruction (no response)
        - id: q_recent_intc
          kind: Comment
          title: "Now I'd like you to think just about yourself and your spouse or partner."

        # RECENT-Q6 / ST_4_R6
        - id: q_recent_q6
          kind: Question
          title: "In the past 12 months, did you (or your partner) experience a change of job for a worse one?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q7 / ST_4_R7
        - id: q_recent_q7
          kind: Question
          title: "In the past 12 months, were you (or your partner) demoted at work or did you/either of you take a cut in pay?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-MARITAL check: married/common-law/partner --> ask Q8
        # RECENT-Q8 / ST_4_R8
        - id: q_recent_q8
          kind: Question
          title: "In the past 12 months, did you have increased arguments with your partner?"
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q9 / ST_4_R9 — always asked
        - id: q_recent_q9
          kind: Question
          title: "Now, just you personally, in the past 12 months, did you go on Welfare?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-CHILDREN check: has_children == 1 --> ask Q10
        # RECENT-Q10 / ST_4_R10
        - id: q_recent_q10
          kind: Question
          title: "In the past 12 months, did you have a child move back into the house?"
          precondition:
            - predicate: has_children == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 3: CHILDHOOD AND ADULT STRESSORS (TRAUM)
    # =========================================================================
    # Age >= 18 and non-proxy only.
    #
    # TRAUM-Q1: R --> GO TO Work Stress section (CATI abort; modeled without skip)
    # TRAUM-Q2 through Q7: always asked (within gate)
    # =========================================================================
    - id: b_childhood_stressors
      title: "Childhood and Adult Stressors"
      precondition:
        - predicate: age >= 18
      items:
        # TRAUM-INTa: introduction (no response)
        - id: q_traum_inta
          kind: Comment
          title: "The next few questions ask about some things that may have happened to you while you were a child or a teenager, before you moved out of the house."

        # TRAUM-Q1 / ST_4_T1: R --> GO TO Work Stress section
        - id: q_traum_q1
          kind: Question
          title: "Did you spend 2 weeks or more in the hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q2 / ST_4_T2
        - id: q_traum_q2
          kind: Question
          title: "Did your parents get a divorce?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q3 / ST_4_T3
        - id: q_traum_q3
          kind: Question
          title: "Did your father or mother not have a job for a long time when they wanted to be working?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q4 / ST_4_T4
        - id: q_traum_q4
          kind: Question
          title: "Did something happen that scared you so much you thought about it for years after?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q5 / ST_4_T5
        - id: q_traum_q5
          kind: Question
          title: "Were you sent away from home because you did something wrong?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q6 / ST_4_T6
        - id: q_traum_q6
          kind: Question
          title: "Did either of your parents drink or use drugs so often that it caused problems for the family?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q7 / ST_4_T7
        - id: q_traum_q7
          kind: Question
          title: "Were you ever physically abused by someone close to you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 4: WORK STRESS (WSTRESS)
    # =========================================================================
    # Age >= 15 and currently employed (lfs_work == 1), non-proxy only.
    # If more than one job, ask for the main job.
    #
    # WSTRESS-Q1: 12-item Likert scale (a through l).
    #   R on first item (index 0) --> GO TO next section (CATI abort;
    #   modeled as always shown within gate).
    # WSTRESS-Q2: Job satisfaction. Always asked (within gate).
    # =========================================================================
    - id: b_work_stress
      title: "Work Stress"
      precondition:
        - predicate: age >= 15 and lfs_work == 1
      items:
        # WSTRESS-Q1 / ST_4_W1A–ST_4_W1L: 12-item job stress Likert scale.
        # Sub-question index mapping:
        #   [0]  W1A: Your job requires that you learn new things
        #   [1]  W1B: Your job requires a high level of skill
        #   [2]  W1C: Your job allows you freedom to decide how you do your job
        #   [3]  W1D: Your job requires that you do things over and over
        #   [4]  W1E: Your job is very hectic
        #   [5]  W1F: You are free from conflicting demands that others make
        #   [6]  W1G: Your job security is good
        #   [7]  W1H: Your job requires a lot of physical effort
        #   [8]  W1I: You have a lot to say about what happens in your job
        #   [9]  W1J: You are exposed to hostility or conflict from the people you work with
        #   [10] W1K: Your supervisor is helpful in getting the job done
        #   [11] W1L: The people you work with are helpful in getting the job done
        - id: qg_wstress_q1
          kind: QuestionGroup
          title: "Now I'm going to read you a series of statements that might describe your job situation. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE, or STRONGLY DISAGREE with each of the following:"
          questions:
            - "(a) Your job requires that you learn new things."
            - "(b) Your job requires a high level of skill."
            - "(c) Your job allows you freedom to decide how you do your job."
            - "(d) Your job requires that you do things over and over."
            - "(e) Your job is very hectic."
            - "(f) You are free from conflicting demands that others make."
            - "(g) Your job security is good."
            - "(h) Your job requires a lot of physical effort."
            - "(i) You have a lot to say about what happens in your job."
            - "(j) You are exposed to hostility or conflict from the people you work with."
            - "(k) Your supervisor is helpful in getting the job done."
            - "(l) The people you work with are helpful in getting the job done."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Strongly disagree"

        # WSTRESS-Q2 / ST_4_W2: Job satisfaction
        - id: q_wstress_q2
          kind: Question
          title: "How satisfied are you with your job?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Not too satisfied"
              4: "Not at all satisfied"
