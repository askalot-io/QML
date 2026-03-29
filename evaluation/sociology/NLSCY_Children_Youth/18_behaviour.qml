qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Behaviour (BEH)"
  codeInit: |
    # Variables READ from prior sections
    child_age = 0   # age of child in years (0-11)

  blocks:
    # =========================================================================
    # BLOCK 1: SLEEP PATTERNS (Age 0-3)
    # =========================================================================
    # BEH-C1: IF AGE > 3 -> skip to Q6A block
    # BEH-Q1 through BEH-Q4: Sleep pattern questions on 5-point frequency scale
    # =========================================================================
    - id: b_beh_sleep
      title: "Sleep Patterns"
      precondition:
        - predicate: child_age <= 3
      items:
        # BEH-Q1: Trouble falling asleep
        - id: q_beh_q1
          kind: Question
          title: "The following questions relate to the child's sleep patterns. When you put him/her to bed, how often does he/she have trouble falling asleep?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # BEH-Q2: Long bedtime routine
        - id: q_beh_q2
          kind: Question
          title: "Does he/she have a particular and long routine (more than 30 minutes) to go to bed (rocking, songs, nursery rhymes, etc.) that he/she cannot go to sleep without?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # BEH-Q3: Wakes up several times
        - id: q_beh_q3
          kind: Question
          title: "Does the child wake up several times during his/her sleep?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # BEH-Q4: Restless sleep
        - id: q_beh_q4
          kind: Question
          title: "Does he/she have a restless sleep?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

    # =========================================================================
    # BLOCK 2: INFANT FEEDING — Q5 (Age 1-3)
    # =========================================================================
    # BEH-C5: IF AGE < 1 -> Q5A; OTHERWISE -> Q5
    # BEH-Q5: Reaction to new foods (age 1-3)
    # =========================================================================
    - id: b_beh_feeding
      title: "Infant Feeding Reactions"
      precondition:
        - predicate: child_age >= 1 and child_age <= 3
      items:
        # BEH-Q5: Reaction to new foods
        - id: q_beh_q5
          kind: Question
          title: "The following are a few examples of how infants react to new foods (orange juice, apple puree, porridge, vegetables, etc.). Which of the following is the best approximation of how the child reacts?"
          input:
            control: Radio
            labels:
              1: "He/she swallows everything without complaining"
              2: "The first time he/she made faces or spit out the food, but after a few tries, he/she got used to it"
              3: "The same reaction after several attempts, he/she continued to refuse most of the new foods"

    # =========================================================================
    # BLOCK 3: INFANT FEEDING — Q5A (Age 0-11 months)
    # =========================================================================
    # BEH-Q5A: Feeding difficulty (age 0-11 months only)
    # =========================================================================
    - id: b_beh_feeding_infant
      title: "Infant Feeding Difficulty"
      precondition:
        - predicate: child_age == 0
      items:
        # BEH-Q5A: How often difficult to feed
        - id: q_beh_q5a
          kind: Question
          title: "How often do you find him/her difficult to feed?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

    # =========================================================================
    # BLOCK 4: CHILD BEHAVIOUR AGE 4-11 (Q6A-Q6UU)
    # =========================================================================
    # BEH-I6A: Intro. Precondition: child_age >= 4
    # BEH-Q6A through BEH-Q6UU: 47 behaviour items on 3-point scale
    # All items share the same scale so modeled as one QuestionGroup.
    # Index mapping:
    #   [0]  Q6A  - Shows sympathy to someone who made a mistake
    #   [1]  Q6B  - Can't sit still, restless, hyperactive
    #   [2]  Q6C  - Destroys own things
    #   [3]  Q6D  - Will try to help someone who has been hurt
    #   [4]  Q6E  - Steals at home
    #   [5]  Q6F  - Seems unhappy, sad, or depressed
    #   [6]  Q6G  - Gets into many fights
    #   [7]  Q6H  - Volunteers to help clear up a mess
    #   [8]  Q6I  - Distractible, trouble sticking to activity
    #   [9]  Q6J  - When mad, tries to get others to dislike that person
    #   [10] Q6K  - Not as happy as other children
    #   [11] Q6L  - Destroys things belonging to family/others
    #   [12] Q6M  - Tries to stop quarrel or dispute
    #   [13] Q6N  - Fidgets
    #   [14] Q6O  - Disobedient at school
    #   [15] Q6P  - Can't concentrate, can't pay attention for long
    #   [16] Q6Q  - Too fearful or anxious
    #   [17] Q6R  - When mad, becomes friends with another as revenge
    #   [18] Q6S  - Impulsive, acts without thinking
    #   [19] Q6T  - Tells lies or cheats
    #   [20] Q6U  - Offers to help other children with a task
    #   [21] Q6V  - Is worried
    #   [22] Q6W  - Has difficulty awaiting turn
    #   [23] Q6X  - Assumes accidental hurt was intentional, reacts with anger
    #   [24] Q6Y  - Tends to do things alone, rather solitary
    #   [25] Q6Z  - When mad, says bad things behind the other's back
    #   [26] Q6AA - Physically attacks people
    #   [27] Q6BB - Comforts a child who is crying or upset
    #   [28] Q6CC - Cries a lot
    #   [29] Q6DD - Vandalizes
    #   [30] Q6EE - Gives up easily
    #   [31] Q6FF - Threatens people
    #   [32] Q6GG - Helps pick up objects another child dropped
    #   [33] Q6HH - Cannot settle to anything for more than a few moments
    #   [34] Q6II - Appears miserable, unhappy, tearful, distressed
    #   [35] Q6JJ - Cruel, bullies or is mean to others
    #   [36] Q6KK - Stares into space
    #   [37] Q6LL - When mad, says let's not be with him/her
    #   [38] Q6MM - Nervous, highstrung or tense
    #   [39] Q6NN - Kicks, bites, hits other children
    #   [40] Q6OO - Will invite bystanders to join in a game
    #   [41] Q6PP - Steals outside the home
    #   [42] Q6QQ - Is inattentive
    #   [43] Q6RR - Has trouble enjoying him/herself
    #   [44] Q6SS - Helps other children who are feeling sick
    #   [45] Q6TT - When mad, tells secrets to a third person
    #   [46] Q6UU - Praises the work of less able children
    # =========================================================================
    - id: b_beh_child_4_11
      title: "Child Behaviour Assessment (Age 4-11)"
      precondition:
        - predicate: child_age >= 4
      items:
        # BEH-I6A: Intro
        - id: q_beh_i6a
          kind: Comment
          title: "Now I'd like to ask you questions about how the child seems to feel or act."

        # BEH-Q6A through BEH-Q6UU: 47 behaviour items
        - id: qg_beh_4_11
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that the child:"
          questions:
            - "(Q6A) Shows sympathy to someone who has made a mistake?"
            - "(Q6B) Can't sit still, is restless, or hyperactive?"
            - "(Q6C) Destroys his/her own things?"
            - "(Q6D) Will try to help someone who has been hurt?"
            - "(Q6E) Steals at home?"
            - "(Q6F) Seems to be unhappy, sad, or depressed?"
            - "(Q6G) Gets into many fights?"
            - "(Q6H) Volunteers to help clear up a mess someone else has made?"
            - "(Q6I) Is distractible, has trouble sticking to any activity?"
            - "(Q6J) When mad at someone, tries to get others to dislike that person?"
            - "(Q6K) Is not as happy as other children?"
            - "(Q6L) Destroys things belonging to his/her family, or other children?"
            - "(Q6M) If there is a quarrel or dispute, will try to stop it?"
            - "(Q6N) Fidgets?"
            - "(Q6O) Is disobedient at school?"
            - "(Q6P) Can't concentrate, can't pay attention for long?"
            - "(Q6Q) Is too fearful or anxious?"
            - "(Q6R) When mad at someone, becomes friends with another as revenge?"
            - "(Q6S) Is impulsive, acts without thinking?"
            - "(Q6T) Tells lies or cheats?"
            - "(Q6U) Offers to help other children (friend, brother or sister) who are having difficulty with a task?"
            - "(Q6V) Is worried?"
            - "(Q6W) Has difficulty awaiting turn in games or groups?"
            - "(Q6X) When another child accidentally hurts him/her, assumes that the other child meant to do it, and then reacts with anger and fighting?"
            - "(Q6Y) Tends to do things on his/her own - is rather solitary?"
            - "(Q6Z) When mad at someone, says bad things behind the other's back?"
            - "(Q6AA) Physically attacks people?"
            - "(Q6BB) Comforts a child (friend, brother, or sister) who is crying or upset?"
            - "(Q6CC) Cries a lot?"
            - "(Q6DD) Vandalizes?"
            - "(Q6EE) Gives up easily?"
            - "(Q6FF) Threatens people?"
            - "(Q6GG) Spontaneously helps to pick up objects which another child has dropped (e.g. pencils, books, etc.)?"
            - "(Q6HH) Cannot settle to anything for more than a few moments?"
            - "(Q6II) Appears miserable, unhappy, tearful, or distressed?"
            - "(Q6JJ) Is cruel, bullies or is mean to others?"
            - "(Q6KK) Stares into space?"
            - "(Q6LL) When mad at someone, says to others: let's not be with him/her?"
            - "(Q6MM) Is nervous, highstrung or tense?"
            - "(Q6NN) Kicks, bites, hits other children?"
            - "(Q6OO) Will invite bystanders to join in a game?"
            - "(Q6PP) Steals outside the home?"
            - "(Q6QQ) Is inattentive?"
            - "(Q6RR) Has trouble enjoying him/herself?"
            - "(Q6SS) Helps other children (friends, brother or sister) who are feeling sick?"
            - "(Q6TT) When mad at someone, tells the other one's secrets to a third person?"
            - "(Q6UU) Takes the opportunity to praise the work of less able children?"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

    # =========================================================================
    # BLOCK 5: DELINQUENT BEHAVIOURS (Age 10-11)
    # =========================================================================
    # BEH-C7A: IF AGE < 10 -> skip
    # BEH-I7A: Intro
    # BEH-Q7A through BEH-Q7E: 5 items on 4-point frequency scale
    # BEH-Q7F: Run away from home (Yes/No)
    # =========================================================================
    - id: b_beh_delinquent
      title: "Delinquent Behaviours (Age 10-11)"
      precondition:
        - predicate: child_age >= 10
      items:
        # BEH-I7A: Intro
        - id: q_beh_i7a
          kind: Comment
          title: "Now I'd like to ask you some questions about certain difficult behaviours which some children may show at this age. These may or may not apply to the child."

        # BEH-Q7A through BEH-Q7E: Delinquent behaviours on 4-point scale
        # Index mapping:
        #   [0] Q7A - Stayed out later than allowed
        #   [1] Q7B - Stayed out all night without permission
        #   [2] Q7C - Skipped a day of school without permission
        #   [3] Q7D - Gotten drunk
        #   [4] Q7E - Questioned by police
        - id: qg_beh_delinquent
          kind: QuestionGroup
          title: "In the past year, about how many times has the child:"
          questions:
            - "(Q7A) Stayed out later than you said he/she should?"
            - "(Q7B) Stayed out all night without permission?"
            - "(Q7C) Skipped a day of school without permission?"
            - "(Q7D) Gotten drunk?"
            - "(Q7E) Been questioned by the police about anything he/she might have done such as stealing, damaging property, or something else?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "Twice"
              4: "More than twice"

        # BEH-Q7F: Run away from home
        - id: q_beh_q7f
          kind: Question
          title: "Has he/she ever run away from home?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 6: TODDLER BEHAVIOUR (Age 2-3)
    # =========================================================================
    # BEH-I8A: Intro. Precondition: child_age >= 2 and child_age <= 3
    # BEH-Q8B through BEH-Q8UU: 33 items on 3-point scale
    # Index mapping:
    #   [0]  Q8B   - Can't sit still, restless, hyperactive
    #   [1]  Q8D   - Will try to help someone who has been hurt
    #   [2]  Q8E1  - Is defiant
    #   [3]  Q8F   - Seems unhappy, sad, or depressed
    #   [4]  Q8G   - Gets into many fights
    #   [5]  Q8I   - Distractible, trouble sticking to activity
    #   [6]  Q8J1  - Doesn't seem to feel guilty after misbehaving
    #   [7]  Q8K   - Not as happy as other children
    #   [8]  Q8N   - Fidgets
    #   [9]  Q8P   - Can't concentrate, can't pay attention for long
    #   [10] Q8Q   - Too fearful or anxious
    #   [11] Q8R1  - Punishment doesn't change behaviour
    #   [12] Q8S   - Impulsive, acts without thinking
    #   [13] Q8T1  - Has temper tantrums or hot temper
    #   [14] Q8U   - Offers to help other children with a task
    #   [15] Q8V   - Is worried
    #   [16] Q8W   - Has difficulty awaiting turn
    #   [17] Q8X   - Assumes accidental hurt was intentional
    #   [18] Q8Z1  - Has angry moods
    #   [19] Q8BB  - Comforts a child who is crying or upset
    #   [20] Q8CC  - Cries a lot
    #   [21] Q8DD1 - Clings to adults or too dependent
    #   [22] Q8EE  - Gives up easily
    #   [23] Q8HH  - Cannot settle to anything
    #   [24] Q8KK  - Stares into space
    #   [25] Q8LL1 - Constantly seeks help
    #   [26] Q8MM  - Nervous, highstrung or tense
    #   [27] Q8NN  - Kicks, bites, hits other children
    #   [28] Q8PP1 - Doesn't want to sleep alone
    #   [29] Q8QQ  - Is inattentive
    #   [30] Q8RR  - Has trouble enjoying him/herself
    #   [31] Q8SS  - Helps other children who are feeling sick
    #   [32] Q8TT  - Gets too upset when separated from parents
    #   [33] Q8UU  - Praises the work of less able children
    # =========================================================================
    - id: b_beh_toddler
      title: "Toddler Behaviour Assessment (Age 2-3)"
      precondition:
        - predicate: child_age >= 2 and child_age <= 3
      items:
        # BEH-I8A: Intro
        - id: q_beh_i8a
          kind: Comment
          title: "Now I'd like to ask you questions about how the child seems to feel or act."

        # BEH-Q8B through BEH-Q8UU: 34 toddler behaviour items
        - id: qg_beh_toddler
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that the child:"
          questions:
            - "(Q8B) Can't sit still, is restless, or hyperactive?"
            - "(Q8D) Will try to help someone who has been hurt?"
            - "(Q8E1) Is defiant?"
            - "(Q8F) Seems to be unhappy, sad, or depressed?"
            - "(Q8G) Gets into many fights?"
            - "(Q8I) Is distractible, has trouble sticking to any activity?"
            - "(Q8J1) Doesn't seem to feel guilty after misbehaving?"
            - "(Q8K) Is not as happy as other children?"
            - "(Q8N) Fidgets?"
            - "(Q8P) Can't concentrate, can't pay attention for long?"
            - "(Q8Q) Is too fearful or anxious?"
            - "(Q8R1) Punishment doesn't change his/her behaviour?"
            - "(Q8S) Is impulsive, acts without thinking?"
            - "(Q8T1) Has temper tantrums or hot temper?"
            - "(Q8U) Offers to help other children (friend, brother or sister) who are having difficulty with a task?"
            - "(Q8V) Is worried?"
            - "(Q8W) Has difficulty awaiting turn in games or groups?"
            - "(Q8X) When another child accidentally hurts him/her, assumes that the other child meant to do it, and then reacts with anger and fighting?"
            - "(Q8Z1) Has angry moods?"
            - "(Q8BB) Comforts a child (friend, brother, or sister) who is crying or upset?"
            - "(Q8CC) Cries a lot?"
            - "(Q8DD1) Clings to adults or is too dependent?"
            - "(Q8EE) Gives up easily?"
            - "(Q8HH) Cannot settle to anything for more than a few moments?"
            - "(Q8KK) Stares into space?"
            - "(Q8LL1) Constantly seeks help?"
            - "(Q8MM) Is nervous, highstrung or tense?"
            - "(Q8NN) Kicks, bites, hits other children?"
            - "(Q8PP1) Doesn't want to sleep alone?"
            - "(Q8QQ) Is inattentive?"
            - "(Q8RR) Has trouble enjoying him/herself?"
            - "(Q8SS) Helps other children (friends, brother or sister) who are feeling sick?"
            - "(Q8TT) Gets too upset when separated from parents?"
            - "(Q8UU) Takes the opportunity to praise the work of less able children?"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"
