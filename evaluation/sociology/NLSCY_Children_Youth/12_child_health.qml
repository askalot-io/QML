qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth Survey - Child Health (HLT)"
  codeInit: |
    # Cross-section variable READ by this section
    child_age = 0       # child's age from demographics section (0-11)

  blocks:
    # =========================================================================
    # BLOCK 1: GENERAL HEALTH (HLT-Q1 to HLT-Q5)
    # =========================================================================
    # All ages: Q1-Q4. Q5 for age 2+.
    # Q1: General health rating
    # Q2: Frequency in good health (skip if Q1=DK/REF)
    # Q3: Height
    # Q4: Weight
    # Q5: Physical activity (age 2+)
    # =========================================================================
    - id: b_general_health
      title: "General Health"
      items:
        # HLT-Q1: General health rating
        - id: q_hlt_q1
          kind: Question
          title: "In general, would you say the child's health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q2: Frequency in good health
        # GOTO: Q1=8(DK) or Q1=9(REF) -> skip to Q3
        - id: q_hlt_q2
          kind: Question
          title: "Over the past few months, how often has he/she been in good health?"
          precondition:
            - predicate: q_hlt_q1.outcome <= 5
          input:
            control: Radio
            labels:
              1: "Almost all the time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"
              8: "Don't know"

        # HLT-Q3: Height
        - id: q_hlt_q3
          kind: Question
          title: "What is his/her height in feet and inches or in metres/centimetres (without shoes on)?"
          input:
            control: Editbox
            min: 0
            max: 200
            right: "cm"

        # HLT-Q4: Weight
        - id: q_hlt_q4
          kind: Question
          title: "What is his/her weight in kilograms (and grams) or in pounds (and ounces)?"
          input:
            control: Editbox
            min: 0
            max: 200
            right: "kg"

        # HLT-Q5: Physical activity (age 2+)
        # C5: IF AGE < 2 -> skip to I37
        - id: q_hlt_q5
          kind: Question
          title: "In your opinion, how physically active is the child compared to other children the same age and sex?"
          precondition:
            - predicate: child_age >= 2
          input:
            control: Radio
            labels:
              1: "Much more active"
              2: "Moderately more active"
              3: "Equally active"
              4: "Moderately less active"
              5: "Much less active"

    # =========================================================================
    # BLOCK 2: VISION (HLT-Q6 to HLT-Q10)
    # =========================================================================
    # Age 0-3: skip entire block (routed to I37 by C6)
    # Age 4-5: Q6A -> Q7A -> Q8 -> Q9 -> Q10
    # Age 6-11: Q6 -> Q7 -> Q8 -> Q9 -> Q10
    # Chain dependencies with various skip patterns based on answers.
    # =========================================================================
    - id: b_vision
      title: "Vision"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-I6: Introduction to day-to-day health questions
        - id: q_hlt_i6
          kind: Comment
          title: "The next set of questions ask about the child's day to day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with his/her abilities relative to other children the same age. You may feel that some of these questions do not apply to him/her, but it is important that we ask the same questions of everyone."

        # HLT-Q6: Vision (newsprint) - age 6+
        # YES(1) -> Q9, NO(2) -> Q7, DK(8) -> Q7, REF(9) -> Q11
        - id: q_hlt_q6
          kind: Question
          title: "Is he/she usually able to see well enough to read ordinary newsprint without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q6A: Vision (storybook) - age 4-5
        # YES(1) -> Q9, NO(2) -> Q7A, DK(8) -> Q7A, REF(9) -> Q11
        - id: q_hlt_q6a
          kind: Question
          title: "Is he/she usually able to see clearly, and without distortion, the words in a story book without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q7: Vision with correction (newsprint) - age 6+
        # Shown when Q6 answered NO(2) or DK(8)
        # YES(1)->Q9, NO(2)->Q8, DOESN'T WEAR(3)->Q8, DK(8)->Q8, REF(9)->Q11
        - id: q_hlt_q7
          kind: Question
          title: "Is he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 6
            - predicate: q_hlt_q6.outcome == 2 or q_hlt_q6.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q7A: Vision with correction (storybook) - age 4-5
        # Shown when Q6A answered NO(2) or DK(8)
        # YES(1)->Q9, NO(2)->Q8, DOESN'T WEAR(3)->Q8, DK(8)->Q8, REF(9)->Q11
        - id: q_hlt_q7a
          kind: Question
          title: "Is he/she usually able to see clearly, and without distortion, the words in a story book with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
            - predicate: q_hlt_q6a.outcome == 2 or q_hlt_q6a.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q8: Can see at all?
        # Reached when Q7=NO/DOESN'T WEAR/DK or Q7A=NO/DOESN'T WEAR/DK
        # YES(1)->Q9, NO(2)->Q11, DK(8)->Q11, REF(9)->Q11
        - id: q_hlt_q8
          kind: Question
          title: "Is he/she able to see at all?"
          precondition:
            - predicate: (child_age >= 6 and q_hlt_q7.outcome in [2, 3, 8]) or (child_age >= 4 and child_age <= 5 and q_hlt_q7a.outcome in [2, 3, 8])
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q9: Distance vision without correction
        # Reached from Q6=YES, Q6A=YES, Q7=YES, Q7A=YES, or Q8=YES
        # YES(1)->Q11, NO(2)->Q10, DK(8)->Q10, REF(9)->Q11
        - id: q_hlt_q9
          kind: Question
          title: "Is he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: (child_age >= 6 and (q_hlt_q6.outcome == 1 or q_hlt_q7.outcome == 1)) or (child_age >= 4 and child_age <= 5 and (q_hlt_q6a.outcome == 1 or q_hlt_q7a.outcome == 1)) or q_hlt_q8.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q10: Distance vision with correction
        # Reached when Q9=NO(2) or Q9=DK(8)
        - id: q_hlt_q10
          kind: Question
          title: "Is he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: q_hlt_q9.outcome == 2 or q_hlt_q9.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contacts"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 3: HEARING (HLT-Q11 to HLT-Q15)
    # =========================================================================
    # Age 0-3: skip (block inherits from vision block age gate, but hearing
    #   is also age 4+ per the routing table)
    # Q11: Hear in group without aid
    # Chain: Q11->Q12->Q13, Q12->Q14->Q15
    # =========================================================================
    - id: b_hearing
      title: "Hearing"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q11: Hearing in group without aid
        # YES(1)->Q16, NO(2)->Q12, DK(8)->Q12, REF(9)->Q16
        - id: q_hlt_q11
          kind: Question
          title: "Is the child usually able to hear what is said in a group conversation with at least three other people without a hearing aid?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q12: Hearing in group with aid
        # YES(1)->Q14, NO(2)->Q13, DOESN'T WEAR(3)->Q13, DK(8)->Q13, REF(9)->Q16
        - id: q_hlt_q12
          kind: Question
          title: "Is he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?"
          precondition:
            - predicate: q_hlt_q11.outcome == 2 or q_hlt_q11.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q13: Can hear at all?
        # YES(1)->Q14, NO(2)->Q16, DK(8)->Q16, REF(9)->Q16
        - id: q_hlt_q13
          kind: Question
          title: "Is he/she able to hear at all?"
          precondition:
            - predicate: q_hlt_q12.outcome in [2, 3, 8]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q14: Hearing one-on-one without aid
        # Reached from Q12=YES(1) or Q13=YES(1)
        # YES(1)->Q16, NO(2)->Q15, DK(8)->Q15, REF(9)->Q16
        - id: q_hlt_q14
          kind: Question
          title: "Is he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: q_hlt_q12.outcome == 1 or q_hlt_q13.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q15: Hearing one-on-one with aid
        # Reached when Q14=NO(2) or Q14=DK(8)
        - id: q_hlt_q15
          kind: Question
          title: "Is he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?"
          precondition:
            - predicate: q_hlt_q14.outcome == 2 or q_hlt_q14.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 4: SPEECH (HLT-Q16 to HLT-Q19)
    # =========================================================================
    # Age 4+ only.
    # Q16: Understood by strangers
    # Chain: Q16->Q17->Q18->Q19
    # =========================================================================
    - id: b_speech
      title: "Speech"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q16: Understood by strangers
        # YES(1)->C20(mobility), NO(2)->Q17, DK(8)->Q18, REF(9)->C20
        - id: q_hlt_q16
          kind: Question
          title: "Is the child usually able to be understood completely when speaking with strangers in his/her own language?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q17: Partially understood by strangers
        # Reached when Q16=NO(2)
        # YES(1)->C20, NO(2)->Q18, DK(8)->Q18, REF(9)->C20
        - id: q_hlt_q17
          kind: Question
          title: "Is he/she able to be understood partially when speaking with strangers in his/her own language?"
          precondition:
            - predicate: q_hlt_q16.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q18: Understood by familiar people
        # Reached when Q16=DK(8), Q17=NO(2), or Q17=DK(8)
        # YES(1)->C20, NO(2)->Q19, DK(8)->C20, REF(9)->C20
        - id: q_hlt_q18
          kind: Question
          title: "Is he/she able to be understood completely when speaking with those who know him/her well?"
          precondition:
            - predicate: q_hlt_q16.outcome == 8 or q_hlt_q17.outcome == 2 or q_hlt_q17.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q19: Partially understood by familiar people
        # Reached when Q18=NO(2)
        - id: q_hlt_q19
          kind: Question
          title: "Is he/she able to be understood partially when speaking with those who know him/her well?"
          precondition:
            - predicate: q_hlt_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 5: MOBILITY / GETTING AROUND (HLT-Q20 to HLT-Q26)
    # =========================================================================
    # Age 4+ only.
    # Age 4-5: Q20A variant, Q22A variant
    # Age 6-11: Q20 variant, Q22 variant
    # Complex chain with wheelchair sub-path.
    # =========================================================================
    - id: b_mobility
      title: "Getting Around"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q20: Walk around neighbourhood (age 6+)
        # YES(1)->Q27, NO(2)->Q21, DK(8)->Q21, REF(9)->Q27
        - id: q_hlt_q20
          kind: Question
          title: "Is the child usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q20A: Walk without difficulty (age 4-5)
        # YES(1)->Q27, NO(2)->Q21, DK(8)->Q21, REF(9)->Q27
        - id: q_hlt_q20a
          kind: Question
          title: "Is he/she usually able to walk without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q21: Can walk at all?
        # Reached when Q20=NO/DK or Q20A=NO/DK
        # YES(1)->Q22/Q22A, NO(2)->Q24, DK(8)->Q24, REF(9)->Q27
        - id: q_hlt_q21
          kind: Question
          title: "Is he/she able to walk at all?"
          precondition:
            - predicate: (child_age >= 6 and q_hlt_q20.outcome in [2, 8]) or (child_age >= 4 and child_age <= 5 and q_hlt_q20a.outcome in [2, 8])
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q22: Requires mechanical support - neighbourhood (age 6+)
        # Reached when Q21=YES(1) and age 6+
        # All answers -> Q23 except REF(9)->Q27
        - id: q_hlt_q22
          kind: Question
          title: "Does he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?"
          precondition:
            - predicate: child_age >= 6
            - predicate: q_hlt_q21.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q22A: Requires mechanical support - walk (age 4-5)
        # Reached when Q21=YES(1) and age 4-5
        # YES/NO/DK -> Q23, REF(9)->Q27
        - id: q_hlt_q22a
          kind: Question
          title: "Does he/she require mechanical support such as braces, a cane or crutches to be able to walk?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
            - predicate: q_hlt_q21.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q23: Requires help of another person to walk
        # Reached from Q22 (not REF) or Q22A (not REF)
        # All answers go to Q27 except we just continue
        - id: q_hlt_q23
          kind: Question
          title: "Does he/she require the help of another person to be able to walk?"
          precondition:
            - predicate: (child_age >= 6 and q_hlt_q22.outcome in [1, 2, 8]) or (child_age >= 4 and child_age <= 5 and q_hlt_q22a.outcome in [1, 2, 8])
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q24: Wheelchair required
        # Reached when Q21=NO(2) or Q21=DK(8)
        # YES(1)->Q25, NO(2)->Q27, DK(8)->Q27, REF(9)->Q27
        - id: q_hlt_q24
          kind: Question
          title: "Does he/she require a wheelchair to get around?"
          precondition:
            - predicate: q_hlt_q21.outcome == 2 or q_hlt_q21.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q25: How often uses wheelchair
        # Reached when Q24=YES(1)
        # All answers -> Q26 except REF(9)->Q27
        - id: q_hlt_q25
          kind: Question
          title: "How often does he/she use a wheelchair?"
          precondition:
            - predicate: q_hlt_q24.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q26: Needs help in wheelchair
        # Reached when Q25 answered (not REF)
        - id: q_hlt_q26
          kind: Question
          title: "Does he/she need the help of another person to get around in the wheelchair?"
          precondition:
            - predicate: q_hlt_q25.outcome in [1, 2, 3, 4, 8]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 6: DEXTERITY / HANDS AND FINGERS (HLT-Q27 to HLT-Q30)
    # =========================================================================
    # Age 4+ only.
    # Q27: Grasp small objects
    # Chain: Q27->Q28->Q29, Q28->Q30
    # =========================================================================
    - id: b_dexterity
      title: "Hands and Fingers"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q27: Grasp and handle small objects
        # YES(1)->Q31, NO(2)->Q28, DK(8)->Q31, REF(9)->Q31
        - id: q_hlt_q27
          kind: Question
          title: "Is the child usually able to grasp and handle small objects such as a pencil or scissors?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q28: Requires help due to hand/finger limitations
        # Reached when Q27=NO(2)
        # YES(1)->Q29, NO(2)->Q30, DK(8)->Q30, REF(9)->Q31
        - id: q_hlt_q28
          kind: Question
          title: "Does he/she require the help of another person because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_hlt_q27.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q29: Level of help needed
        # Reached when Q28=YES(1)
        - id: q_hlt_q29
          kind: Question
          title: "Does he/she require the help of another person with:"
          precondition:
            - predicate: q_hlt_q28.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some tasks"
              2: "Most tasks"
              3: "Almost all tasks"
              4: "All tasks"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q30: Requires special equipment
        # Reached when Q28=NO(2) or Q28=DK(8)
        - id: q_hlt_q30
          kind: Question
          title: "Does he/she require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_hlt_q28.outcome == 2 or q_hlt_q28.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 7: COGNITION / FEELINGS (HLT-Q31 to HLT-Q33)
    # =========================================================================
    # Age 4+ only. Sequential, no skip patterns.
    # =========================================================================
    - id: b_cognition
      title: "Cognition and Feelings"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q31: Happiness / interest in life
        - id: q_hlt_q31
          kind: Question
          title: "Would you describe the child as being usually:"
          input:
            control: Radio
            labels:
              1: "Happy and interested in life"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Unhappy with little interest in life"
              5: "So unhappy that life is not worthwhile"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q32: Memory ability
        - id: q_hlt_q32
          kind: Question
          title: "How would you describe his/her usual ability to remember things? Is he/she:"
          input:
            control: Radio
            labels:
              1: "Able to remember most things"
              2: "Somewhat forgetful"
              3: "Very forgetful"
              4: "Unable to remember anything at all"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q33: Thinking / problem solving
        - id: q_hlt_q33
          kind: Question
          title: "How would you describe his/her usual ability to think and solve day-to-day problems? Is he/she:"
          input:
            control: Radio
            labels:
              1: "Able to think clearly and solve problems"
              2: "Having a little difficulty"
              3: "Having some difficulty"
              4: "Having a great deal of difficulty"
              5: "Unable to think or solve problems"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 8: PAIN AND DISCOMFORT (HLT-Q34 to HLT-Q36)
    # =========================================================================
    # Age 4+ only.
    # Q34: Free of pain? YES->I37, NO->Q35->Q36
    # =========================================================================
    - id: b_pain
      title: "Pain and Discomfort"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q34: Usually free of pain?
        # YES(1)->I37, NO(2)->Q35, DK(8)->I37, REF(9)->I37
        - id: q_hlt_q34
          kind: Question
          title: "Is the child usually free of pain or discomfort?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q35: Pain intensity
        # Reached when Q34=NO(2)
        # All answers -> Q36 except REF(9)->I37
        - id: q_hlt_q35
          kind: Question
          title: "How would you describe the usual intensity of his/her pain or discomfort:"
          precondition:
            - predicate: q_hlt_q34.outcome == 2
          input:
            control: Radio
            labels:
              1: "Mild"
              2: "Moderate"
              3: "Severe"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q36: Activities prevented by pain
        # Reached when Q35 answered (not REF)
        - id: q_hlt_q36
          kind: Question
          title: "How many activities does his/her pain or discomfort prevent?"
          precondition:
            - predicate: q_hlt_q35.outcome in [1, 2, 3, 8]
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Some"
              4: "Most"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 9: INJURIES (HLT-I37 to HLT-Q42)
    # =========================================================================
    # All ages. Q37 gates Q38-Q42.
    # Q39 is a checkbox for injury type, Q40 for body part (if Q39 in 1-5).
    # Q41: cause of injury, Q42: location of injury.
    # =========================================================================
    - id: b_injuries
      title: "Injuries"
      items:
        # HLT-I37: Intro about injuries
        - id: q_hlt_i37
          kind: Comment
          title: "The following questions refer to injuries, such as a broken bone, bad cut or burn, head injury, poisoning, or a sprained ankle, which occurred in the past 12 months, and were serious enough to require medical attention by a doctor, nurse, or dentist."

        # HLT-Q37: Was child injured in past 12 months?
        # YES(1)->Q38, NO(2)->Q43A, DK(8)->Q43A, REF(9)->Q43A
        - id: q_hlt_q37
          kind: Question
          title: "In the past 12 months was the child injured?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q38: How many times injured
        # Reached when Q37=YES(1)
        - id: q_hlt_q38
          kind: Question
          title: "How many times was he/she injured?"
          precondition:
            - predicate: q_hlt_q37.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        # HLT-Q39: Type of most serious injury
        # Reached when Q37=YES(1)
        # Uses Checkbox for multiple injury types; REF(99)->Q43A
        - id: q_hlt_q39
          kind: Question
          title: "For the most serious injury, what type of injury did he/she have?"
          precondition:
            - predicate: q_hlt_q37.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Broken or fractured bones"
              2: "Burn or scald"
              3: "Dislocation"
              4: "Sprain or strain"
              5: "Cut, scrape, or bruise"
              6: "Concussion"
              7: "Poisoning by substance or liquid"
              8: "Internal injury"
              9: "Dental injury"
              10: "Other"
              11: "Multiple injuries"
              98: "Don't know"
              99: "Refusal"

        # HLT-Q40: Body part injured
        # C40: IF Q39 in 1-5 -> Q40, otherwise -> Q41
        # Reached when Q39 answered with codes 1-5 (bone/burn/dislocation/sprain/cut)
        - id: q_hlt_q40
          kind: Question
          title: "What part of his/her body was injured?"
          precondition:
            - predicate: q_hlt_q39.outcome >= 1 and q_hlt_q39.outcome <= 5
          input:
            control: Dropdown
            labels:
              1: "Eyes"
              2: "Face or scalp (excluding eyes)"
              3: "Head or neck (excluding eyes and face or scalp)"
              4: "Arms or hands"
              5: "Legs or feet"
              6: "Back or spine"
              7: "Trunk (excluding back or spine)"
              8: "Shoulder"
              9: "Hip"
              10: "Multiple sites"
              98: "Don't know"
              99: "Refusal"

        # HLT-Q41: Cause of injury
        # Reached when Q37=YES and Q39 not REF(99)
        - id: q_hlt_q41
          kind: Question
          title: "What happened, for example, was the injury the result of a fall, motor vehicle collision, a physical assault, etc.?"
          precondition:
            - predicate: q_hlt_q37.outcome == 1
            - predicate: q_hlt_q39.outcome != 99
          input:
            control: Dropdown
            labels:
              1: "Motor vehicle collision - passenger"
              2: "Motor vehicle collision - pedestrian"
              3: "Motor vehicle collision - riding bicycle"
              4: "Other bicycle accident"
              5: "Fall (excluding bicycle or sports)"
              6: "Sports (excluding bicycle)"
              7: "Physical assault"
              8: "Scalded by hot liquids or food"
              9: "Accidental poisoning"
              10: "Self-inflicted poisoning"
              11: "Other intentionally self-inflicted injuries"
              12: "Natural/environmental factors"
              13: "Fire/flames or resulting fumes"
              14: "Near drowning"
              15: "Other"
              98: "Don't know"
              99: "Refusal"

        # HLT-Q42: Location where injury happened
        # Reached when Q37=YES and Q39 not REF(99)
        - id: q_hlt_q42
          kind: Question
          title: "Where did the injury happen, for example at home, on the street, in a playground, at school, etc.?"
          precondition:
            - predicate: q_hlt_q37.outcome == 1
            - predicate: q_hlt_q39.outcome != 99
          input:
            control: Dropdown
            labels:
              1: "Inside respondent's own home/apartment"
              2: "Outside respondent's home including yard, driveway, parking lot"
              3: "In or around other private residence"
              4: "Inside school/daycare centre or on school/centre grounds"
              5: "At an indoor or outdoor sports facility (other than school)"
              6: "Other building used by general public"
              7: "On sidewalk/street/highway in respondent's neighbourhood"
              8: "On any other sidewalk/street/highway"
              9: "Other"
              98: "Don't know"
              99: "Refusal"

    # =========================================================================
    # BLOCK 10: ASTHMA (HLT-Q43A to HLT-Q44)
    # =========================================================================
    # All ages. Q43A gates Q43B/Q43C.
    # Q44: wheezing (asked if Q43A=NO or after Q43C)
    # =========================================================================
    - id: b_asthma
      title: "Asthma"
      items:
        # HLT-Q43A: Ever had asthma diagnosed?
        # YES(1)->Q43B, NO(2)->Q44, DK(8)->Q43B, REF(9)->C45
        - id: q_hlt_q43a
          kind: Question
          title: "The following questions are about asthma. Has the child ever had asthma that was diagnosed by a health professional?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q43B: Does asthma limit participation?
        # Reached when Q43A=YES(1) or Q43A=DK(8)
        - id: q_hlt_q43b
          kind: Question
          title: "Does this condition or health problem prevent or limit his/her participation in school, at play or any other activity normal for a child his/her age?"
          precondition:
            - predicate: q_hlt_q43a.outcome == 1 or q_hlt_q43a.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q43C: Asthma attack in last 12 months?
        # Reached when Q43A=YES(1) or Q43A=DK(8)
        - id: q_hlt_q43c
          kind: Question
          title: "Has he/she had an attack of asthma in the last 12 months?"
          precondition:
            - predicate: q_hlt_q43a.outcome == 1 or q_hlt_q43a.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q44: Wheezing in last 12 months?
        # Asked when Q43A=NO(2) or after Q43C (i.e., Q43A=YES/DK path completed)
        # REF on Q43A(9) skips to C45, so exclude that
        - id: q_hlt_q44
          kind: Question
          title: "Has he/she had wheezing or whistling in the chest at any time in the last 12 months?"
          precondition:
            - predicate: q_hlt_q43a.outcome != 9
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 11: LONG-TERM CONDITIONS (HLT-Q45, Q45A, Q45B)
    # =========================================================================
    # C45: Age < 6 -> Q45, Age 6+ -> Q45A
    # Q45: conditions list (age 0-5)
    # Q45A: conditions list (age 6-11, includes learning disability etc.)
    # Q45B: conditions limiting participation (all ages)
    # =========================================================================
    - id: b_longterm
      title: "Long-term Conditions"
      items:
        # HLT-Q45: Long-term conditions (age 0-5)
        - id: q_hlt_q45
          kind: Question
          title: "In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does the child have any of the following long-term conditions that have been diagnosed by a health professional?"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Checkbox
            labels:
              1: "Allergies"
              2: "Bronchitis"
              4: "Heart condition or disease"
              8: "Epilepsy"
              16: "Cerebral Palsy"
              32: "Kidney condition or disease"
              64: "Mental handicap"
              128: "Any other long term condition"
              256: "None"

        # HLT-Q45A: Long-term conditions (age 6-11)
        - id: q_hlt_q45a
          kind: Question
          title: "In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does the child have any of the following long-term conditions that have been diagnosed by a health professional?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Checkbox
            labels:
              1: "Allergies"
              2: "Bronchitis"
              4: "Heart condition or disease"
              8: "Epilepsy"
              16: "Cerebral Palsy"
              32: "Kidney condition or disease"
              64: "Mental handicap"
              128: "Learning disability"
              256: "Emotional, psychological or nervous difficulties"
              512: "Any other long term condition"
              1024: "None"

        # HLT-Q45B: Conditions limiting participation
        - id: q_hlt_q45b
          kind: Question
          title: "Does the child have any long term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 12: INFECTIONS (HLT-Q46 to HLT-Q47B)
    # =========================================================================
    # C46: IF AGE > 3 -> skip to I48. Only age 0-3.
    # Q46: Nose/throat infections
    # Q47A: Ear infection -> Q47B (if YES)
    # =========================================================================
    - id: b_infections
      title: "Infections"
      precondition:
        - predicate: child_age <= 3
      items:
        # HLT-Q46: Nose/throat infections frequency
        - id: q_hlt_q46
          kind: Question
          title: "How often does the child have nose or throat infections?"
          input:
            control: Radio
            labels:
              1: "Almost all the time"
              2: "Often"
              3: "From time to time"
              4: "Rarely"
              5: "Never"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q47A: Ever had ear infection?
        # YES(1)->Q47B, NO(2)->I48, DK(8)->I48, REF(9)->I48
        - id: q_hlt_q47a
          kind: Question
          title: "Since his/her birth, has he/she had an ear infection (otitis)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q47B: How many times ear infection
        # Reached when Q47A=YES(1)
        - id: q_hlt_q47b
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_hlt_q47a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Once"
              2: "2 times"
              3: "3 times"
              4: "4 or more times"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 13: HEALTH PROFESSIONALS (HLT-I48 to HLT-Q48I)
    # =========================================================================
    # All ages (age 4+ per routing: age 0-3 come here after infections block,
    # age 4+ come here after long-term conditions block).
    # QuestionGroup with Editbox for visit counts.
    # =========================================================================
    - id: b_health_professionals
      title: "Health Professionals"
      items:
        # HLT-I48: Intro
        - id: q_hlt_i48
          kind: Comment
          title: "In the past year, how many times have you seen or talked on the telephone with any of the following about the child's physical or mental health? (Exclude at time of birth for babies.)"

        # HLT-Q48A through Q48I: Health professional visit counts
        # NOTE: CATI source has REFUSAL on Q48A → GO TO HLT-Q49 (skip Q48B-I).
        # In QML, QuestionGroup presents all sub-questions together, so per-item
        # refusal routing cannot be modeled. The respondent answers all visit
        # counts or none.
        - id: qg_hlt_q48
          kind: QuestionGroup
          title: "Number of visits to health professionals in the past year:"
          questions:
            - "A general practitioner, family physician"
            - "A pediatrician"
            - "Another medical doctor (such as an orthopedist, or eye specialist)"
            - "A public health nurse or nurse practitioner"
            - "A dentist or orthodontist"
            - "A psychiatrist or psychologist"
            - "Child welfare worker or children's aid worker"
            - "Any other person trained to provide treatment or counsel (e.g., speech therapist, social worker)"
          input:
            control: Editbox
            min: 0
            max: 99

    # =========================================================================
    # BLOCK 14: HOSPITALIZATION (HLT-Q49 to HLT-Q50)
    # =========================================================================
    # All ages. Q49 gates Q50.
    # =========================================================================
    - id: b_hospitalization
      title: "Hospitalization"
      items:
        # HLT-Q49: Overnight hospital patient?
        # YES(1)->Q50, NO(2)->Q51A, DK(8)->Q51A
        - id: q_hlt_q49
          kind: Question
          title: "In the past 12 months, was the child ever an overnight patient in a hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        # HLT-Q50: Reason for hospitalization
        # Reached when Q49=YES(1)
        - id: q_hlt_q50
          kind: Question
          title: "For what reason?"
          precondition:
            - predicate: q_hlt_q49.outcome == 1
          input:
            control: Radio
            labels:
              1: "Respiratory illness or disease"
              2: "Gastrointestinal illness or disease"
              3: "Injuries"
              4: "Other"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 15: MEDICATION (HLT-Q51A to HLT-Q51E)
    # =========================================================================
    # All ages. QuestionGroup with Switch for prescribed medications.
    # =========================================================================
    - id: b_medication
      title: "Medication"
      items:
        # HLT-Q51A through Q51E: Prescribed medications
        - id: qg_hlt_q51
          kind: QuestionGroup
          title: "Does the child take any of the following prescribed medication on a regular basis?"
          questions:
            - "Ventolin or other inhalants"
            - "Ritalin"
            - "Tranquilizers or nerve pills"
            - "Anti-convulsants or anti-epileptic pills"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 16: STRESSFUL EVENTS (HLT-Q52A to HLT-Q52B)
    # =========================================================================
    # C52: IF AGE < 4 -> next section; age 4+ only.
    # Q52A gates Q52B.
    # =========================================================================
    - id: b_stressful_events
      title: "Stressful Events"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q52A: Experienced stressful event?
        # YES(1)->Q52B, NO(2)->next section
        - id: q_hlt_q52a
          kind: Question
          title: "Has the child ever experienced any event or situation that has caused him/her a great amount of worry or unhappiness?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q52B: What was the stressful event?
        # Reached when Q52A=YES(1)
        - id: q_hlt_q52b
          kind: Question
          title: "What was this?"
          precondition:
            - predicate: q_hlt_q52a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Death of parents"
              2: "Death in family (other than parents)"
              4: "Divorce/separation of parents"
              8: "Move"
              16: "Stay in hospital"
              32: "Stay in foster home"
              64: "Other separation from parents"
              128: "Illness/injury of child"
              256: "Illness/injury of a family member"
              512: "Abuse/fear of abuse"
              1024: "Change in household members"
              2048: "Alcoholism or mental health disorder in family"
              4096: "Conflict between parents"
              8192: "Other"
