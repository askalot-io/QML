qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth Survey - Temperament (TMP)"
  codeInit: |
    # Cross-section variables READ by this section
    child_age = 0           # child's age in years (from demographics)
    child_age_months = 0    # child's age in months (from demographics)

  blocks:
    # =========================================================================
    # BLOCK 1: TEMPERAMENT INTRODUCTION
    # =========================================================================
    # TMP-C1 gate: only children aged 3-47 months
    # TMP-I1 introduction text, TMP-Q1 general soothing difficulty
    # =========================================================================
    - id: b_tmp_intro
      title: "Temperament"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-I1: Introduction
        - id: q_tmp_i1
          kind: Comment
          title: "The following questions are about how your child behaves. Please answer them in comparison to others. 'About average' means how you think the typical child would be scored."

        # TMP-Q1: Soothing difficulty
        - id: q_tmp_q1
          kind: Question
          title: "How easy or difficult is it for you to calm or soothe your child when he/she is upset?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Difficult"

    # =========================================================================
    # BLOCK 2: PREDICTABILITY AND ROUTINES
    # =========================================================================
    # Q2/Q2A (sleep), Q3/Q3A (eating) - age-variant pairs at 12 months
    # =========================================================================
    - id: b_tmp_predictability
      title: "Predictability and Routines"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q2: Sleep predictability (age < 12 months)
        - id: q_tmp_q2
          kind: Question
          title: "How easy or difficult is it for you to predict when he/she will go to sleep and wake up?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Difficult"

        # TMP-Q2A: Sleep routine consistency (age >= 12 months)
        - id: q_tmp_q2a
          kind: Question
          title: "How consistent is he/she in sticking with his/her sleeping routine?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very consistent; little or no variability"
            right: "Very inconsistent; highly variable"

        # TMP-Q3: Eating predictability (age < 12 months)
        - id: q_tmp_q3
          kind: Question
          title: "How easy or difficult is it for you to predict when he/she will become hungry?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Difficult"

        # TMP-Q3A: Eating routine consistency (age >= 12 months)
        - id: q_tmp_q3a
          kind: Question
          title: "How consistent is he/she in sticking with his/her eating routine?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very consistent; little or no variability"
            right: "Very inconsistent; highly variable"

    # =========================================================================
    # BLOCK 3: FUSSINESS AND CRYING
    # =========================================================================
    # Q4/Q4A (knowing what's wrong), Q5/Q5A (fussiness frequency),
    # Q6/Q6A (crying amount), Q7 (upset ease), Q8/Q8A/Q8B (upset intensity)
    # Age splits: Q4/Q5/Q6 at 36 months, Q8 three-way at 12/36 months
    # =========================================================================
    - id: b_tmp_fussiness
      title: "Fussiness and Crying"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q4: Knowing what's bothering (age < 36 months)
        - id: q_tmp_q4
          kind: Question
          title: "How easy or difficult is it for you to know what's bothering him/her when he/she cries or fusses?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Very difficult"

        # TMP-Q4A: Knowing what's bothering (age >= 36 months)
        - id: q_tmp_q4a
          kind: Question
          title: "How easy or difficult is it for you to know what's bothering him/her when he/she is irritable?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Very difficult"

        # TMP-Q5: Fussiness frequency (age < 36 months)
        - id: q_tmp_q5
          kind: Question
          title: "How many times per day, on average, does your child get fussy and irritable - for either short or long periods of time?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "1-2 times per day"
              3: "3-4 times per day"
              4: "5-6 times per day"
              5: "7-9 times per day"
              6: "10-14 times per day"
              7: "15 times per day or more"

        # TMP-Q5A: Crankiness frequency (age >= 36 months)
        - id: q_tmp_q5a
          kind: Question
          title: "How many times per day on average does your child get cranky and irritable - for either short or long periods of time?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "1-2 times per day"
              3: "3-4 times per day"
              4: "5-6 times per day"
              5: "7-9 times per day"
              6: "10-14 times per day"
              7: "15 times per day or more"

        # TMP-Q6: Crying amount (age < 36 months)
        - id: q_tmp_q6
          kind: Question
          title: "How much does he/she cry and fuss in general?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very little; much less than the average baby/child"
            right: "A lot; much more than the average baby/child"

        # TMP-Q6A: Crying/fussing/whining amount (age >= 36 months)
        - id: q_tmp_q6a
          kind: Question
          title: "How much does he/she cry, fuss or whine in general?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very little; much less than the average child"
            right: "A lot; much more than the average child"

        # TMP-Q7: How easily upset (all ages)
        - id: q_tmp_q7
          kind: Question
          title: "How easily does he/she get upset?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very hard to upset"
            right: "Very easily upset by things that wouldn't bother most babies/children"

        # TMP-Q8: Upset intensity (age < 12 months)
        - id: q_tmp_q8
          kind: Question
          title: "When he/she gets upset (e.g., before feeding, during diapering, etc.), how vigorously or loudly does he/she cry and fuss?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very mild intensity or loudness"
            right: "Very loud or intense, really cuts loose"

        # TMP-Q8A: Upset intensity (age 12-35 months)
        - id: q_tmp_q8a
          kind: Question
          title: "When he/she gets upset, how vigorously or loudly does he/she cry and fuss?"
          precondition:
            - predicate: child_age_months >= 12
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very mild intensity or loudness"
            right: "Very loud or intense, really cuts loose"

        # TMP-Q8B: Upset intensity (age >= 36 months)
        - id: q_tmp_q8b
          kind: Question
          title: "When he/she gets upset, how vigorously or loudly does he/she cry and whine?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very mild intensity or loudness"
            right: "Very loud or intense, really cuts loose"

    # =========================================================================
    # BLOCK 4: DAILY CARE REACTIONS
    # =========================================================================
    # Q9/Q9A (dressing/hairwashing), Q10 (activity level)
    # Age split at 12 months for Q9
    # =========================================================================
    - id: b_tmp_daily_care
      title: "Daily Care Reactions"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q9: Reaction to dressing (age < 12 months)
        - id: q_tmp_q9
          kind: Question
          title: "How does he/she react when you are dressing him/her?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q9A: Reaction to hairwashing (age >= 12 months)
        - id: q_tmp_q9a
          kind: Question
          title: "How does he/she react during hairwashing?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q10: Activity level (all ages)
        - id: q_tmp_q10
          kind: Question
          title: "How active is your child in general?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very calm and quiet"
            right: "Very active and vigorous"

    # =========================================================================
    # BLOCK 5: MOOD AND SOCIABILITY
    # =========================================================================
    # Q11/Q11A (smiling), Q12 (mood), Q13/Q13A (playing enjoyment),
    # Q14/Q14A (wanting to be held/cuddled), Q15 (routine disruptions)
    # =========================================================================
    - id: b_tmp_mood
      title: "Mood and Sociability"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q11: Smiling and happy sounds (age < 36 months)
        - id: q_tmp_q11
          kind: Question
          title: "How much does he/she smile and make happy sounds?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal, much more than most infants/children"
            right: "Very little, much less than most infants/children"

        # TMP-Q11A: Smiling and laughing (age >= 36 months)
        - id: q_tmp_q11a
          kind: Question
          title: "How much does he/she smile and laugh?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal, much more than most children"
            right: "Very little, much less than most children"

        # TMP-Q12: General mood (all ages)
        - id: q_tmp_q12
          kind: Question
          title: "What kind of mood is he/she generally in?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very happy and cheerful"
            right: "Serious"

        # TMP-Q13: Playing games enjoyment (age 6-11 months only)
        - id: q_tmp_q13
          kind: Question
          title: "How much does he/she enjoy playing little games with you?"
          precondition:
            - predicate: child_age_months >= 6
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal -- really loves it"
            right: "Very little -- doesn't like it very much"

        # TMP-Q13A: Playing enjoyment (age >= 12 months)
        - id: q_tmp_q13a
          kind: Question
          title: "How much does he/she enjoy playing with you?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal -- really loves it"
            right: "Very little -- doesn't like it very much"

        # TMP-Q14: Wanting to be held (age < 36 months)
        - id: q_tmp_q14
          kind: Question
          title: "How much does he/she want to be held?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Wants to be free most of the time"
            right: "A great deal -- wants to be held almost all the time"

        # TMP-Q14A: Wanting to be cuddled (age >= 36 months)
        - id: q_tmp_q14a
          kind: Question
          title: "How much does he/she want to be cuddled?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Wants to be free most of the time"
            right: "A great deal -- wants to be cuddled almost all the time"

        # TMP-Q15: Response to routine disruptions (all ages)
        - id: q_tmp_q15
          kind: Question
          title: "How does he/she respond to disruptions and changes in everyday routine, such as when you go to church, a meeting, on trips, etc.?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very favourably, doesn't get upset"
            right: "Very unfavourably, gets quite upset"

    # =========================================================================
    # BLOCK 6: PREDICTABILITY AND MOOD CHANGE
    # =========================================================================
    # Q16 (diaper prediction, age < 12m only), Q17 (mood changeability, age >= 12m),
    # Q18 (excitement with people), Q19/Q19A (attention needs),
    # Q20 (playing alone)
    # =========================================================================
    - id: b_tmp_predict_mood
      title: "Predictability and Mood Changes"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q16: Diaper prediction (age 3-11 months only)
        - id: q_tmp_q16
          kind: Question
          title: "How easy is it for you to predict when he/she will need a diaper change?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Very difficult"

        # TMP-Q17: Mood changeability (age >= 12 months)
        - id: q_tmp_q17
          kind: Question
          title: "How changeable is your child's mood?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Changes seldom and changes slowly when he/she does change"
            right: "Changes often and rapidly"

        # TMP-Q18: Excitement with people (all ages)
        - id: q_tmp_q18
          kind: Question
          title: "How excited does he/she become when people play with or talk to him/her?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very excited"
            right: "Not at all"

        # TMP-Q19: Attention needs (age < 36 months)
        - id: q_tmp_q19
          kind: Question
          title: "On the average, how much attention does he/she require, other than for caregiving (feeding, bathing, diaper changes, etc.)?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very little -- much less than the average baby/child"
            right: "A lot -- much more than the average baby/child"

        # TMP-Q19A: Attention needs (age >= 36 months)
        - id: q_tmp_q19a
          kind: Question
          title: "On the average, how much attention does he/she require, other than for caregiving (bathing, eating, etc.)?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very little -- much less than the average child"
            right: "A lot -- much more than the average child"

        # TMP-Q20: Playing alone (all ages)
        - id: q_tmp_q20
          kind: Question
          title: "When left alone, he/she plays well by him/herself?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Almost always"
            right: "Almost never -- won't play by self"

    # =========================================================================
    # BLOCK 7: CONFINEMENT AND CUDDLING
    # =========================================================================
    # Q21/Q21A/Q21B (confinement reaction, three-way age split),
    # Q22/Q22A (cuddling)
    # Age 3-11m skip Q21 entirely; Q21 12-23m, Q21A 24-35m, Q21B 36-47m
    # =========================================================================
    - id: b_tmp_confinement
      title: "Confinement and Cuddling"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q21: Confinement reaction (age 12-23 months)
        - id: q_tmp_q21
          kind: Question
          title: "How does he/she react to being confined (as in a carseat, infant seat, playpen, etc.)?"
          precondition:
            - predicate: child_age_months >= 12
            - predicate: child_age_months <= 23
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q21A: Confinement reaction (age 24-35 months)
        - id: q_tmp_q21a
          kind: Question
          title: "How does he/she react to being confined (as in a carseat, bedroom, crib, etc.)?"
          precondition:
            - predicate: child_age_months >= 24
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q21B: Confinement reaction (age 36-47 months)
        - id: q_tmp_q21b
          kind: Question
          title: "How does he/she react to being confined (as in a boosterseat, seatbelt, bedroom, bed, etc.)?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q22: Cuddling when held (age < 12 months)
        - id: q_tmp_q22
          kind: Question
          title: "How much does he/she cuddle and snuggle when held?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal -- almost every time"
            right: "Very little -- seldom cuddles"

        # TMP-Q22A: Cuddling when close (age >= 12 months)
        - id: q_tmp_q22a
          kind: Question
          title: "How much does he/she cuddle and snuggle when close to you?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal -- almost every time"
            right: "Very little -- seldom cuddles"

    # =========================================================================
    # BLOCK 8: NOVELTY RESPONSES
    # =========================================================================
    # Q23 (first bath, age 3-11m only), Q23A (new playthings, age >= 12m),
    # Q24 (first solid food, age 6-11m), Q24A (new foods, age >= 12m),
    # Q25 (new person), Q26 (new place), Q27/Q27A (adaptation)
    # Note: age 3-5m skip from Q23 directly to Q33 in original;
    # here we handle via preconditions on Q24 (requires 6-11m).
    # =========================================================================
    - id: b_tmp_novelty
      title: "Novelty Responses"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q23: First bath response (age 3-11 months)
        - id: q_tmp_q23
          kind: Question
          title: "How did he/she respond to his/her first bath?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- baby loved it"
            right: "Terribly -- didn't like it"

        # TMP-Q23A: New playthings response (age >= 12 months)
        - id: q_tmp_q23a
          kind: Question
          title: "How does he/she typically respond to new playthings?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Always responds favourably"
            right: "Always responds negatively or fearfully"

        # TMP-Q24: First solid food response (age 6-11 months)
        - id: q_tmp_q24
          kind: Question
          title: "How did he/she respond to his/her first solid food?"
          precondition:
            - predicate: child_age_months >= 6
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very favourably -- liked it immediately"
            right: "Very negatively -- did not like it at all"

        # TMP-Q24A: New food response (age >= 12 months)
        - id: q_tmp_q24a
          kind: Question
          title: "How does he/she typically respond to new foods?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Always responds favourably"
            right: "Very negatively -- does not like it at all"

        # TMP-Q25: New person response (all ages)
        - id: q_tmp_q25
          kind: Question
          title: "How does he/she typically respond to a new person?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Almost always responds favourably"
            right: "Almost always responds negatively at first"

        # TMP-Q26: New place response (all ages)
        - id: q_tmp_q26
          kind: Question
          title: "How does he/she typically respond to being in a new place?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Almost always responds favourably"
            right: "Almost always responds negatively at first"

        # TMP-Q27: Adaptation (age < 12 months)
        - id: q_tmp_q27
          kind: Question
          title: "How well does he/she adapt to things (such as baths, new people and new places) eventually?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- always likes it eventually"
            right: "Almost always dislikes it in the end"

        # TMP-Q27A: Adaptation to new experiences (age >= 12 months)
        - id: q_tmp_q27a
          kind: Question
          title: "How well does he/she adapt to new experiences (such as new playthings, new foods, new persons, etc.) eventually?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- always likes it eventually"
            right: "Almost always dislikes it in the end"

    # =========================================================================
    # BLOCK 9: PERSISTENCE AND COMPLIANCE
    # =========================================================================
    # Q28 (taking places, age >= 12m), Q29 (object persistence, age >= 12m),
    # Q30/Q30A (disobedience persistence), Q31 (removal upset, age >= 12m),
    # Q32 (attention persistence, age >= 12m)
    # =========================================================================
    - id: b_tmp_persistence
      title: "Persistence and Compliance"
      precondition:
        - predicate: child_age_months >= 12
        - predicate: child_age_months <= 47
      items:
        # TMP-Q28: Ease of taking places (age >= 12 months)
        - id: q_tmp_q28
          kind: Question
          title: "How easy or difficult is it to take him/her places?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Easy; fun to take baby/child with me"
            right: "Difficult; baby/child is usually disruptive"

        # TMP-Q29: Object persistence (age >= 12 months)
        - id: q_tmp_q29
          kind: Question
          title: "Does he/she persist in playing with objects when he/she is told to leave them alone?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Rarely or never persists"
            right: "Almost always persists"

        # TMP-Q30: Disobedience persistence (age 12-35 months)
        - id: q_tmp_q30
          kind: Question
          title: "Does he/she continue to go someplace even when you told him/her something like 'stop', 'come here', or 'no-no'?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Rarely or never"
            right: "Almost always"

        # TMP-Q30A: Disobedience persistence (age >= 36 months)
        - id: q_tmp_q30a
          kind: Question
          title: "Does he/she continue to go someplace even when you told him/her something like 'stop', 'come here', or 'please don't'?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Rarely or never"
            right: "Almost always"

        # TMP-Q31: Upset when removed from interest (age >= 12 months)
        - id: q_tmp_q31
          kind: Question
          title: "When removed from something he/she is interested in but should not be getting into, he/she gets upset."
          input:
            control: Slider
            min: 1
            max: 7
            left: "Never"
            right: "Always gets very upset"

        # TMP-Q32: Persistence in getting attention (age >= 12 months)
        - id: q_tmp_q32
          kind: Question
          title: "How persistent is he/she in trying to get your attention when you are busy?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Doesn't persist at all"
            right: "Very persistent -- will do anything to get attention"

    # =========================================================================
    # BLOCK 10: OVERALL DIFFICULTY RATING
    # =========================================================================
    # Q33: Overall difficulty rating (all ages 3-47 months)
    # =========================================================================
    - id: b_tmp_overall
      title: "Overall Difficulty"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q33: Overall difficulty rating
        - id: q_tmp_q33
          kind: Question
          title: "Please rate the overall degree of difficulty your child would present for the average parent."
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Highly difficult to deal with"
