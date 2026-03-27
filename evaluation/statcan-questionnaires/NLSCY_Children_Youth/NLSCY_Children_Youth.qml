qmlVersion: "1.0"
questionnaire:
  title: "National Longitudinal Survey of Children and Youth (NLSCY) - Children's Questionnaire"
  codeInit: |
    # Child age in years (0-11) - the primary routing variable
    child_age = 0
    # Child age in months (0-47) for Motor/Social Development
    child_age_months = 0
    # Respondent relationship to child (from DVS-Q1)
    is_birth_parent = 0
    is_step_parent = 0
    is_adoptive_parent = 0
    is_foster_parent = 0
    is_parent_type = 0
    # Whether respondent is PMK (Person Most Knowledgeable)
    is_pmk = 1
    # Whether parents lived together at birth
    parents_together = 0
    # Whether parents broke up
    parents_broke_up = 0
    # Family status
    is_married_or_partner = 0
    is_female_bio_parent = 0
    # Section completed flags
    section_completed_another = 0
    # Has siblings in household
    has_siblings = 0
    # Vision routing
    vision_done = 0
    # Hearing routing
    hearing_done = 0
    # Smoking daily
    smokes_daily = 0
    # Alcohol consumed
    drinks_alcohol = 0
    # Binge drinking count
    binge_count = 0
    # Custody section routing
    custody_section_reached = 0
    # Parent death tracking
    parent_died = 0
    both_parents_died = 0
    parent_died_mother = 0
    parent_died_father = 0
    # Whether parents ever lived together (non-birth-together path)
    parents_ever_lived_together = 0
    # Whether parents were married (for divorce question gate)
    parents_married = 0
    # Mother / father new union tracking
    mother_new_union = 0
    father_new_union = 0
    # Second union broke up
    second_union_broke = 0
    # Court order and custody classification
    has_court_order = 0
    custody_type = 0
    # Contact type with other parent
    contact_type = 0
    # Child care routing
    uses_childcare = 0
    ever_used_childcare = 0
    num_care_changes = 0
    # Medical/Biological section (MED)
    respondent_relationship = 0
    is_bio_mother = 0
    is_bio_father = 0
    birth_premature = 0
    received_special_care = 0
    was_breastfed = 0
    smoked_during_pregnancy = 0
    drank_during_pregnancy = 0
    took_prescription_meds = 0
    took_otc_meds = 0
    postpartum_depression = 0
    # Temperament section (TMP) - no additional variables needed (uses child_age_months)
    # Health section additional variables
    has_asthma = 0
    injured_past_year = 0
    has_pain = 0
    hospitalized_past_year = 0
    has_stressful_event = 0
    vision_ok_no_glasses = 0
    hearing_ok_no_aid = 0
    speech_understood = 0
    walks_ok = 0
    grasps_ok = 0
    has_ear_infection = 0

  blocks:
    # =========================================================================
    # BLOCK 1: CHILD DEMOGRAPHICS (DVS) - p43
    # =========================================================================
    - id: b_child_demographics
      title: "Child Demographics Verification"
      items:
        - id: dvs_intro
          kind: Comment
          title: "I need to confirm some of the information that we collected earlier, since it is important in determining which questions we need to ask you about the child."

        - id: dvs_q1
          kind: Question
          title: "What is your relationship to the child?"
          codeBlock: |
            if dvs_q1.outcome == 1:
                is_birth_parent = 1
                is_parent_type = 1
            elif dvs_q1.outcome == 2:
                is_step_parent = 1
                is_parent_type = 1
            elif dvs_q1.outcome == 3:
                is_adoptive_parent = 1
                is_parent_type = 1
            elif dvs_q1.outcome == 4:
                is_foster_parent = 1
                is_parent_type = 1
            else:
                is_parent_type = 0
          input:
            control: Radio
            labels:
              1: "Birth parent"
              2: "Step parent (including common-law parent)"
              3: "Adoptive parent"
              4: "Foster parent"
              5: "Sister/Brother"
              6: "Grandparent"
              7: "In-law"
              8: "Other related"
              9: "Unrelated"

        - id: dvs_child_age
          kind: Question
          title: "What is the child's age in years? (0 for under 1 year)"
          codeBlock: |
            child_age = dvs_child_age.outcome
          input:
            control: Editbox
            min: 0
            max: 11

        - id: dvs_child_age_months
          kind: Question
          title: "What is the child's age in months? (For children under 4 years)"
          precondition:
            - predicate: child_age < 4
          codeBlock: |
            child_age_months = dvs_child_age_months.outcome
          input:
            control: Editbox
            min: 0
            max: 47

        - id: dvs_child_sex
          kind: Question
          title: "What is the child's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: dvs_has_siblings
          kind: Question
          title: "Does the child have brothers or sisters living in the household?"
          codeBlock: |
            if dvs_has_siblings.outcome == 1:
                has_siblings = 1
            else:
                has_siblings = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 2: CHILD HEALTH (HLT) - p44-57
    # NOTE p44: Age-tiered routing:
    #   AGE 0-1: HLT-Q1-Q4; HLT-QI37-Q45; HLT-Q45B-Q51E
    #   AGE 2-3: HLT-Q1-Q5; HLT-QI37-Q45; HLT-Q45B-Q51E
    #   AGE 4-5: HLT-Q1-Q5; HLT-Q6A,Q7A; HLT-Q8-Q19; HLT-Q20A,Q21,Q22A;
    #            HLT-Q23-Q45; HLT-Q45B; HLT-Q48A-Q52B
    #   AGE 6-11: HLT-Q1-HLT-Q5; HLT-Q6,Q7; HLT-Q8-Q19; HLT-Q20,Q21,Q22;
    #             HLT-Q23-Q44; HLT-Q45A,Q45B; HLT-Q48A-Q52B
    # =========================================================================
    - id: b_child_health
      title: "Child Health"
      items:
        - id: hlt_q1
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

        - id: hlt_q2
          kind: Question
          title: "Over the past few months, how often has he/she been in good health?"
          input:
            control: Radio
            labels:
              1: "Almost all the time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        - id: hlt_q3
          kind: Question
          title: "What is his/her height in feet and inches or in metres/centimetres (without shoes on)?"
          input:
            control: Editbox
            min: 1
            max: 200

        - id: hlt_q4
          kind: Question
          title: "What is his/her weight in kilograms (and grams) or in pounds (and ounces)?"
          input:
            control: Editbox
            min: 1
            max: 200

        # HLT-C5 p45: IF AGE < 2 YEARS --> GO TO HLT-I37, OTHERWISE --> GO TO HLT-Q5
        - id: hlt_q5
          kind: Question
          title: "In your opinion, how physically active is the child compared to other children the same age and sex?"
          precondition:
            - predicate: child_age >= 2
          input:
            control: Radio
            labels:
              1: "Much more"
              2: "Moderately more"
              3: "Equally"
              4: "Moderately less"
              5: "Much less"

        # HLT-C6 p45: IF AGE = 0-3 --> GO TO HLT-I37, OTHERWISE --> GO TO HLT-I6
        # HEALTH STATUS section - ages 4+
        - id: hlt_i6
          kind: Comment
          title: "The next set of questions ask about the child's day to day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with his/her abilities relative to other children the same age."
          precondition:
            - predicate: child_age >= 4

        # VISION - p45-46
        # HLT-C6A: IF AGE > 6 --> GO TO HLT-Q6A, OTHERWISE --> GO TO HLT-Q6
        - id: hlt_q6
          kind: Question
          title: "Is he/she usually able to see well enough to read ordinary newsprint without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 6
          codeBlock: |
            if hlt_q6.outcome == 1:
                vision_done = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HLT-Q6A p46 - for ages 4-5
        - id: hlt_q6a
          kind: Question
          title: "Is he/she usually able to see clearly, and without distortion, the words in a story book without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          codeBlock: |
            if hlt_q6a.outcome == 1:
                vision_done = 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: hlt_q7
          kind: Question
          title: "Is he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 6 and hlt_q6.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"

        # HLT-Q7A p46 - for ages 4-5
        - id: hlt_q7a
          kind: Question
          title: "Is he/she usually able to see clearly, and without distortion, the words in a story book with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5 and hlt_q6a.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"

        - id: hlt_q8
          kind: Question
          title: "Is he/she able to see at all?"
          precondition:
            - predicate: child_age >= 4 and vision_done == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q9
          kind: Question
          title: "Is he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and vision_done == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q10
          kind: Question
          title: "Is he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and hlt_q9.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contacts"

        # HEARING - p47
        - id: hlt_q11
          kind: Question
          title: "Is the child usually able to hear what is said in a group conversation with at least three other people without a hearing aid?"
          precondition:
            - predicate: child_age >= 4
          codeBlock: |
            if hlt_q11.outcome == 1:
                hearing_done = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q12
          kind: Question
          title: "Is he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?"
          precondition:
            - predicate: child_age >= 4 and hlt_q11.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"

        - id: hlt_q13
          kind: Question
          title: "Is he/she able to hear at all?"
          precondition:
            - predicate: child_age >= 4 and hlt_q11.outcome == 0 and hlt_q12.outcome != 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q14
          kind: Question
          title: "Is he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: child_age >= 4 and hearing_done == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q15
          kind: Question
          title: "Is he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?"
          precondition:
            - predicate: child_age >= 4 and hlt_q14.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"

        # SPEECH - p48
        - id: hlt_q16
          kind: Question
          title: "Is the child usually able to be understood completely when speaking with strangers in his/her own language?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q17
          kind: Question
          title: "Is he/she able to be understood partially when speaking with strangers in his/her own language?"
          precondition:
            - predicate: child_age >= 4 and hlt_q16.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q18
          kind: Question
          title: "Is he/she able to be understood completely when speaking with those who know him/her well?"
          precondition:
            - predicate: child_age >= 4 and hlt_q16.outcome == 0 and hlt_q17.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q19
          kind: Question
          title: "Is he/she able to be understood partially when speaking with those who know him/her well?"
          precondition:
            - predicate: child_age >= 4 and hlt_q16.outcome == 0 and hlt_q17.outcome == 0 and hlt_q18.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # GETTING AROUND - p49-50
        # HLT-C20 p49: IF AGE < 6 --> GO TO HLT-Q20A, OTHERWISE --> GO TO HLT-Q20
        - id: hlt_q20
          kind: Question
          title: "Is the child usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q20a
          kind: Question
          title: "Is he/she usually able to walk without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q21
          kind: Question
          title: "Is he/she able to walk at all?"
          precondition:
            - predicate: child_age >= 4 and ((child_age >= 6 and hlt_q20.outcome == 0) or (child_age <= 5 and hlt_q20a.outcome == 0))
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HLT-C22 p49: IF AGE < 6 --> GO TO HLT-Q22A, OTHERWISE --> GO TO HLT-Q22
        - id: hlt_q22
          kind: Question
          title: "Does he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?"
          precondition:
            - predicate: child_age >= 6 and hlt_q21.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q22a
          kind: Question
          title: "Does he/she require mechanical support such as braces, a cane or crutches to be able to walk?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5 and hlt_q21.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q23
          kind: Question
          title: "Does he/she require the help of another person to be able to walk?"
          precondition:
            - predicate: child_age >= 4 and hlt_q21.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q24
          kind: Question
          title: "Does he/she require a wheelchair to get around?"
          precondition:
            - predicate: child_age >= 4 and hlt_q21.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q25
          kind: Question
          title: "How often does he/she use a wheelchair?"
          precondition:
            - predicate: child_age >= 4 and hlt_q24.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Never"

        - id: hlt_q26
          kind: Question
          title: "Does he/she need the help of another person to get around in the wheelchair?"
          precondition:
            - predicate: child_age >= 4 and hlt_q24.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HANDS AND FINGERS - p51
        - id: hlt_q27
          kind: Question
          title: "Is the child usually able to grasp and handle small objects such as a pencil or scissors?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q28
          kind: Question
          title: "Does he/she require the help of another person because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: child_age >= 4 and hlt_q27.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q29
          kind: Question
          title: "Does he/she require the help of another person with:"
          precondition:
            - predicate: child_age >= 4 and hlt_q28.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some tasks"
              2: "Most tasks"
              3: "Almost all tasks"
              4: "All tasks"

        - id: hlt_q30
          kind: Question
          title: "Does he/she require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: child_age >= 4 and hlt_q27.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRONIC CONDITIONS - p52 (HLT-Q31 onwards)
        - id: hlt_q31
          kind: Question
          title: "Does the child have any of the following long-term conditions that have been diagnosed by a health professional: Asthma?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q32
          kind: Question
          title: "Allergies (food/other)?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q33
          kind: Question
          title: "Bronchitis?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q34
          kind: Question
          title: "Heart condition or disease?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q35
          kind: Question
          title: "Epilepsy?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q36
          kind: Question
          title: "Cerebral palsy?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # INJURY AND MEDICAL - HLT-I37 onwards - ALL AGES
        - id: hlt_i37
          kind: Comment
          title: "The next questions are about injuries and medical conditions."

        - id: hlt_q37
          kind: Question
          title: "Since birth/in the past 12 months, has the child been injured seriously enough to require medical attention?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: hlt_q38
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: hlt_q37.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        - id: hlt_q39
          kind: Question
          title: "Thinking of the most recent injury, what type of injury was it?"
          precondition:
            - predicate: hlt_q37.outcome == 1
          input:
            control: Radio
            labels:
              1: "Broken bone/fracture"
              2: "Burn/scald"
              3: "Accidental poisoning"
              4: "Other"

    # =========================================================================
    # BLOCK 3: BEHAVIOUR (BEH) - p109-116
    # NOTE p109: Age-tiered:
    #   AGE 0-11 MONTHS: BEH-Q1-4, BEH-Q5A
    #   AGE 1 YEAR: BEH-Q1-Q5
    #   AGE 2-3 YEARS: BEH-Q1-Q5, BEH-I8A-Q8UU
    #   AGE 4-9 YEARS: BEH-I6A-Q6UU
    #   AGE 10-11 YEARS: BEH-I6A-Q7F
    # =========================================================================
    - id: b_behaviour
      title: "Child Behaviour"
      items:
        # BEH-C1 p109: IF AGE > 3 --> GO TO BEH-I6A, OTHERWISE --> GO TO BEH-Q1

        # AGE 0-3 YEARS: Sleep patterns
        - id: beh_q1
          kind: Question
          title: "The following questions relate to the child's sleep patterns. When you put him/her to bed, how often does he/she have trouble falling asleep?"
          precondition:
            - predicate: child_age <= 3
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        - id: beh_q2
          kind: Question
          title: "Does he/she have a particular and long routine (more than 30 minutes) to go to bed that he/she cannot go to sleep without?"
          precondition:
            - predicate: child_age <= 3
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        - id: beh_q3
          kind: Question
          title: "Does the child wake up several times during his/her sleep?"
          precondition:
            - predicate: child_age <= 3
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        - id: beh_q4
          kind: Question
          title: "Does he/she have a restless sleep?"
          precondition:
            - predicate: child_age <= 3
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # BEH-C5 p110: IF AGE < 1 --> GO TO BEH-Q5A, OTHERWISE --> GO TO BEH-Q5
        - id: beh_q5
          kind: Question
          title: "How does the child react to new foods (orange juice, apple puree, porridge, vegetables, etc.)?"
          precondition:
            - predicate: child_age >= 1 and child_age <= 3
          input:
            control: Radio
            labels:
              1: "Swallows everything without complaining"
              2: "Made faces first but after a few tries, got used to it"
              3: "Continued to refuse most of the new foods"

        - id: beh_q5a
          kind: Question
          title: "How often do you find him/her difficult to feed?"
          precondition:
            - predicate: child_age == 0
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # AGE 4-11 YEARS: Behaviour scale (BEH-I6A/Q6A-Q6UU) p111-113
        - id: beh_i6a
          kind: Comment
          title: "Now I'd like to ask you questions about how the child seems to feel or act."
          precondition:
            - predicate: child_age >= 4

        - id: beh_q6_behaviour
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that the child:"
          precondition:
            - predicate: child_age >= 4
          questions:
            - "Shows sympathy to someone who has made a mistake"
            - "Can't sit still, is restless, or hyperactive"
            - "Destroys his/her own things"
            - "Will try to help someone who has been hurt"
            - "Steals at home"
            - "Seems to be unhappy, sad, or depressed"
            - "Gets into many fights"
            - "Volunteers to help clear up a mess someone else has made"
            - "Is distractible, has trouble sticking to any activity"
            - "When mad at someone, tries to get others to dislike that person"
            - "Is not as happy as other children"
            - "Destroys things belonging to his/her family, or other children"
            - "If there is a quarrel or dispute, will try to stop it"
            - "Fidgets"
            - "Is disobedient at school"
            - "Can't concentrate, can't pay attention for long"
            - "Is too fearful or anxious"
            - "When mad at someone, becomes friends with another as revenge"
            - "Is impulsive, acts without thinking"
            - "Tells lies or cheats"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        - id: beh_q6_prosocial
          kind: QuestionGroup
          title: "How often would you say the child:"
          precondition:
            - predicate: child_age >= 4
          questions:
            - "Offers to help other children who are having difficulty with a task"
            - "Is worried"
            - "Has difficulty awaiting turn in games or groups"
            - "Assumes another child meant to hurt when it was accidental, reacts with anger"
            - "Tends to do things on his/her own - is rather solitary"
            - "Says bad things about others behind their back"
            - "Physically attacks people"
            - "Comforts a child who is crying or upset"
            - "Cries a lot"
            - "Vandalizes"
            - "Gives up easily"
            - "Threatens people"
            - "Spontaneously helps to pick up objects dropped by others"
            - "Cannot settle to anything for more than a few moments"
            - "Appears miserable, unhappy, tearful, or distressed"
            - "Is cruel, bullies or is mean to others"
            - "Stares into space"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        - id: beh_q6_ext
          kind: QuestionGroup
          title: "How often would you say the child:"
          precondition:
            - predicate: child_age >= 4
          questions:
            - "When mad at someone, says: let's not be with him/her"
            - "Is nervous, highstrung or tense"
            - "Kicks, bites, hits other children"
            - "Will invite bystanders to join in a game"
            - "Steals outside the home"
            - "Is inattentive"
            - "Has trouble enjoying him/herself"
            - "Helps other children who are feeling sick"
            - "When mad at someone, tells the other one's secrets to a third person"
            - "Takes the opportunity to praise the work of less able children"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        # BEH-C7A p113: IF AGE < 10 --> GO TO MOTOR AND SOCIAL DEVELOPMENT SECTION
        # OTHERWISE --> GO TO BEH-I7A
        # AGE 10-11: Difficult behaviours
        - id: beh_i7a
          kind: Comment
          title: "Now I'd like to ask you about certain difficult behaviours which some children may show at this age."
          precondition:
            - predicate: child_age >= 10

        - id: beh_q7_difficult
          kind: QuestionGroup
          title: "In the past year, about how many times has the child:"
          precondition:
            - predicate: child_age >= 10
          questions:
            - "Stayed out later than you said he/she should"
            - "Stayed out all night without permission"
            - "Skipped a day of school without permission"
            - "Gotten drunk"
            - "Been questioned by the police"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "Twice"
              4: "More than twice"

        - id: beh_q7f
          kind: Question
          title: "Has he/she ever run away from home?"
          precondition:
            - predicate: child_age >= 10
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 2-3 YEARS: Toddler behaviour scale (BEH-I8A/Q8B-Q8UU) p114-116
        - id: beh_i8a
          kind: Comment
          title: "Now I'd like to ask you questions about how the child seems to feel or act."
          precondition:
            - predicate: child_age >= 2 and child_age <= 3

        - id: beh_q8_toddler
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that the child:"
          precondition:
            - predicate: child_age >= 2 and child_age <= 3
          questions:
            - "Can't sit still, is restless, or hyperactive"
            - "Will try to help someone who has been hurt"
            - "Is defiant"
            - "Seems to be unhappy, sad, or depressed"
            - "Gets into many fights"
            - "Is distractible, has trouble sticking to any activity"
            - "Doesn't seem to feel guilty after misbehaving"
            - "Is not as happy as other children"
            - "Fidgets"
            - "Can't concentrate, can't pay attention for long"
            - "Is too fearful or anxious"
            - "Punishment doesn't change his/her behaviour"
            - "Is impulsive, acts without thinking"
            - "Has temper tantrums or hot temper"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        - id: beh_q8_toddler2
          kind: QuestionGroup
          title: "How often would you say the child:"
          precondition:
            - predicate: child_age >= 2 and child_age <= 3
          questions:
            - "Offers to help other children having difficulty with a task"
            - "Is worried"
            - "Has difficulty awaiting turn in games or groups"
            - "Assumes accidental hurt was intentional, reacts with anger"
            - "Has angry moods"
            - "Comforts a child who is crying or upset"
            - "Cries a lot"
            - "Clings to adults or is too dependent"
            - "Gives up easily"
            - "Cannot settle to anything for more than a few moments"
            - "Stares into space"
            - "Constantly seeks help"
            - "Is nervous, highstrung or tense"
            - "Kicks, bites, hits other children"
            - "Doesn't want to sleep alone"
            - "Is inattentive"
            - "Has trouble enjoying him/herself"
            - "Helps other children who are feeling sick"
            - "Gets too upset when separated from parents"
            - "Takes the opportunity to praise the work of less able children"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

    # =========================================================================
    # BLOCK 4: MOTOR AND SOCIAL DEVELOPMENT (MSD) - p117-121
    # NOTE p117: Asked for children 0 to 47 months only
    # Age-tiered by month ranges with progressive milestones
    # =========================================================================
    - id: b_motor_social_dev
      title: "Motor and Social Development"
      items:
        # MSD-C1 p117: IF AGE > 3 YEARS --> GO TO RELATIONSHIPS SECTION
        - id: msd_i1
          kind: Comment
          title: "The following questions are about the child's motor and social development."
          precondition:
            - predicate: child_age <= 3

        # AGE 0-3 MONTHS: MSD-Q1 to Q15
        - id: msd_q_0_3
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months <= 3 and child_age <= 3
          questions:
            - "Turned his/her head from side to side when lying on stomach"
            - "Eyes followed a moving object"
            - "Lifted head off the surface when on stomach"
            - "Eyes followed moving object all the way from one side to the other"
            - "Smiled at someone when that person talked to or smiled at him/her"
            - "Raised head and chest from surface while resting on lower arms or hands"
            - "Turned his/her head around to look at something"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 4-6 MONTHS: MSD-Q8 to Q22
        - id: msd_q_4_15
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 4 and child_age_months <= 15 and child_age <= 3
          questions:
            - "Held head steady when pulled to sitting position"
            - "Laughed out loud without being tickled or touched"
            - "Held in one hand a moderate size object such as a block or a rattle"
            - "Rolled over on his/her own on purpose"
            - "Seemed to enjoy looking in the mirror at him/herself"
            - "Pulled from sitting to standing and supported own weight"
            - "Looked around for a toy which was lost or not nearby"
            - "Sat alone with no help"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 7-12 MONTHS: MSD-Q12 to Q32
        - id: msd_q_7_21
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 7 and child_age_months <= 21 and child_age <= 3
          questions:
            - "Sat for 10 minutes without any support at all"
            - "Pulled him/herself to standing position without help"
            - "Crawled when left lying on his/her stomach"
            - "Said any recognizable words such as mama or dada"
            - "Picked up small objects using only thumb and first finger"
            - "Walked at least 2 steps with one hand held or holding on to something"
            - "Waved good-bye without help from another person"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 10-21 MONTHS additional milestones
        - id: msd_q_10_32
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 10 and child_age_months <= 32 and child_age <= 3
          questions:
            - "Shown by behavior that he/she knows the names of common objects"
            - "Shown wanting something by pointing, pulling, or making pleasant sounds"
            - "Stood alone on feet for 10 seconds or more without holding on"
            - "Walked at least 2 steps without holding on to anything"
            - "Crawled up at least 2 stairs or steps"
            - "Said 2 recognizable words besides mama or dada"
            - "Run"
            - "Said the name of a familiar object, such as a ball"
            - "Made a line with a crayon or pencil"
            - "Walked up at least 2 stairs with one hand held or holding the railing"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 13-47 MONTHS advanced milestones
        - id: msd_q_13_48
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 13 and child_age_months <= 47 and child_age <= 3
          questions:
            - "Fed him/herself with a spoon or fork without spilling much"
            - "Let someone know wearing wet pants or diapers bothered him/her"
            - "Spoken a partial sentence of 3 words or more"
            - "Walked up stairs by him/herself without holding on to a rail"
            - "Washed and dried his/her hands without any help except for turning the water"
            - "Counted 3 objects correctly"
            - "Gone to the toilet alone"
            - "Walked upstairs by him/herself with no help stepping on each step with one foot"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # AGE 19-47 MONTHS advanced milestones
        - id: msd_q_19_48
          kind: QuestionGroup
          title: "Has the child ever done the following?"
          precondition:
            - predicate: child_age_months >= 19 and child_age_months <= 47 and child_age <= 3
          questions:
            - "Knows his/her own age and sex"
            - "Said the names of at least 4 colors"
            - "Pedaled a tricycle at least 10 feet"
            - "Done a somersault without help from anybody"
            - "Dressed him/herself without any help except for tying shoes and buttoning backs"
            - "Said his/her first and last name together without someone's help"
            - "Counted out loud up to 10"
            - "Drawn a picture of a person with at least 2 parts of the body besides head"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 5: RELATIONSHIPS (REL) - p122-124
    # NOTE p122: Asked of children 4-11 only
    # Age-tiered: 4-5, 6-7, 8-11
    # =========================================================================
    - id: b_relationships
      title: "Relationships"
      items:
        # REL-C1 p122: IF AGE < 4 --> GO TO PARENTING SECTION
        - id: rel_i1
          kind: Comment
          title: "The next few questions are about the child's relationships with friends, family and others."
          precondition:
            - predicate: child_age >= 4

        - id: rel_q1
          kind: Question
          title: "About how many days a week does he/she do things with friends?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 day a week"
              3: "2-3 days a week"
              4: "4-5 days a week"
              5: "6-7 days a week"

        # REL-C2 p122: IF AGE < 6 --> GO TO REL-Q6, OTHERWISE --> GO TO REL-Q2
        - id: rel_q2
          kind: Question
          title: "About how many close friends does he/she have?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Radio
            labels:
              1: "None"
              2: "1"
              3: "2 or 3"
              4: "4 or 5"
              5: "6 or more"

        # REL-C3 p123: IF AGE < 8 --> GO TO REL-Q6
        - id: rel_q3
          kind: Question
          title: "How many of his/her close friends do you know by sight and by first and last name?"
          precondition:
            - predicate: child_age >= 8
          input:
            control: Radio
            labels:
              1: "All"
              2: "Most"
              3: "About half"
              4: "Only a few"
              5: "None"

        # REL-C4 p123: IF AGE < 8 --> GO TO REL-Q6
        - id: rel_q4
          kind: Question
          title: "When it comes to meeting new children and making new friends is he/she:"
          precondition:
            - predicate: child_age >= 8
          input:
            control: Radio
            labels:
              1: "Somewhat shy"
              2: "About average"
              3: "Very outgoing - makes friends easily"

        - id: rel_q5
          kind: Question
          title: "How often does he/she hang around with kids you think are frequently in trouble?"
          precondition:
            - predicate: child_age >= 8
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        - id: rel_q6
          kind: Question
          title: "During the past 6 months, how well has the child gotten along with other kids, such as friends or classmates (excluding brothers or sisters)?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Not applicable"

        - id: rel_q7
          kind: Question
          title: "Since starting school in the fall, how well has he/she gotten along with his/her teacher(s) at school?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Not applicable"

        - id: rel_q8
          kind: Question
          title: "During the past 6 months, how well has he/she gotten along with his/her parent(s)?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"

        # REL-C9 p124: IF NO BROTHERS OR SISTERS IN HOUSEHOLD --> GO TO PARENTING
        - id: rel_q9
          kind: Question
          title: "During the past 6 months, how well has the child gotten along with his/her brother(s)/sister(s)?"
          precondition:
            - predicate: child_age >= 4 and has_siblings == 1
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"

    # =========================================================================
    # BLOCK 6: PARENTING (PAR) - p125-129
    # NOTE p125: Only if respondent is birth, step or adoptive parent
    # AGE 0-23 MONTHS: PAR-I1-Q7A
    # AGE 2-11 YEARS: PAR-I1-Q28
    # =========================================================================
    - id: b_parenting
      title: "Parenting"
      items:
        # PAR-C1 p125: IF FOSTER PARENT --> GO TO CUSTODY SECTION
        # ELSE IF PMK OR SPOUSE/PARTNER --> GO TO PAR-I1
        # OTHERWISE --> GO TO CUSTODY SECTION
        - id: par_i1
          kind: Comment
          title: "The following questions have to do with things that the child does and ways that you react to him/her."
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0

        - id: par_q1
          kind: Question
          title: "How often do you praise the child, by saying something like 'Good for you!' or 'That's good going!'?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q2
          kind: Question
          title: "How often do you and he/she talk or play with each other, focusing attention on each other for five minutes or more, just for fun?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q3
          kind: Question
          title: "How often do you and he/she laugh together?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q4
          kind: Question
          title: "How often do you get annoyed with the child for saying or doing something he/she is not supposed to?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q5
          kind: Question
          title: "How often do you tell him/her that he/she is bad or not as good as others?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q6
          kind: Question
          title: "How often do you do something special with him/her that he/she enjoys?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        # PAR-C7 p126: IF AGE < 3 --> GO TO PAR-Q7A, OTHERWISE --> GO TO PAR-Q7
        - id: par_q7
          kind: Question
          title: "How often do you play sports, hobbies or games with him/her?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 3
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        - id: par_q7a
          kind: Question
          title: "How often do you play games with him/her?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age < 3
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        # PAR-C8 p126: IF AGE < 2 --> GO TO CUSTODY SECTION, OTHERWISE --> GO TO PAR-I8A
        - id: par_i8a
          kind: Comment
          title: "Now, we know that when parents spend time together with their children, some of the time things go well and some of the time they don't go well. For the following questions, I would like you to tell me what proportion of the time things turn out in different ways."
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2

        - id: par_q8
          kind: Question
          title: "Of all the times that you talk to the child about his/her behaviour, what proportion is praise?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than half the time"
              3: "About half the time"
              4: "More than half the time"
              5: "All the time"

        - id: par_q9
          kind: Question
          title: "Of all the times that you talk to him/her about his/her behaviour, what proportion is disapproval?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than half the time"
              3: "About half the time"
              4: "More than half the time"
              5: "All the time"

        - id: par_q10
          kind: Question
          title: "When you give him/her a command or order to do something, what proportion of the time do you make sure that he/she does it?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than half the time"
              3: "About half the time"
              4: "More than half the time"
              5: "All the time"

        # PAR-I19A p128: Discipline methods
        - id: par_i19a
          kind: Comment
          title: "Just about all children break the rules or do things that they are not supposed to. Also, parents react in different ways. Please tell me how often you do each of the following when the child breaks the rules."
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2

        - id: par_discipline
          kind: QuestionGroup
          title: "How often do you:"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          questions:
            - "Tell him/her to stop"
            - "Ignore it, do nothing"
            - "Raise your voice, scold or yell at him/her"
            - "Calmly discuss the problem"
            - "Use physical punishment"
            - "Describe alternative ways of behaving that are acceptable"
            - "Take away privileges or put in room"
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # PAR-Q26A p128 - Food security
        - id: par_q26a
          kind: Question
          title: "Has he/she ever experienced being hungry because the family has run out of food or money to buy food?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: par_q26b
          kind: Question
          title: "How often?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2 and par_q26a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Regularly, end of the month"
              2: "More often than end of each month"
              3: "Every few months"
              4: "Occasionally, not a regular occurrence"

        # PAR-Q27 p129 - Violence exposure
        - id: par_q27
          kind: Question
          title: "How often does he/she see television shows or movies that have a lot of violence in them?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        - id: par_q28
          kind: Question
          title: "How often does he/she see adults or teenagers in your house physically fighting, hitting or otherwise trying to hurt others?"
          precondition:
            - predicate: is_parent_type == 1 and is_foster_parent == 0 and child_age >= 2
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # =========================================================================
    # BLOCK 7: FAMILY AND CUSTODY HISTORY (CUS) - pp. 130-155 - 118 questions
    # CUS-C1: IF FOSTER PARENT (DVS-Q1=4) --> SKIP (block precondition)
    # ELSE IF PMK OR SPOUSE/PARTNER --> GO TO CUS-I1
    # Major routing paths:
    #   Birth path:     Q1A(yes)->Q1D->Q2->Q3A...
    #   Non-birth path: Q1A(no)->Q1B->Q1C->Q1D...
    #   Not-together:   Q2(no)->Q4->Q5A...
    #   Separation:     Q10B(yes)->Q11A->Q11B...
    #   Death:          Q9A/Q9B->Q9C->Q9D->C10...
    #   Mother new union: Q20A->Q20B/Q20C->Q20D...
    #   Father new union: Q21A->Q21B/Q21C->Q21D...
    #   Second separation: Q22A->Q22B->Q22C->Q23
    # =========================================================================
    - id: b_custody
      title: "Family and Custody History"
      precondition:
        - predicate: is_foster_parent == 0 and is_parent_type == 1
      items:
        # ---------------------------------------------------------------
        # CUS-I1 / CUS-Q1A: Did child live with respondent at birth?
        # ---------------------------------------------------------------
        - id: cus_i1
          kind: Comment
          title: "I would now like to ask you some questions about the family history of the child."

        # CUS-Q1A p130
        - id: cus_q1a
          kind: Question
          title: "Did the child live with you when he/she was born?"
          codeBlock: |
            if cus_q1a.outcome == 1:
                lived_with_at_birth = 1
            else:
                lived_with_at_birth = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # ---------------------------------------------------------------
        # NON-BIRTH PATH: Q1B, Q1B2, Q1C (child did NOT live with respondent at birth)
        # CUS-C1A: IF Q1A=YES --> skip to Q1D; IF Q1A=NO --> GO TO Q1B
        # ---------------------------------------------------------------

        # CUS-Q1B p131: Age at which child started living with respondent
        - id: cus_q1b
          kind: Question
          title: "At what age did the child start living with you?"
          precondition:
            - predicate: lived_with_at_birth == 0
          input:
            control: Dropdown
            labels:
              1: "Less than one year old"
              2: "One year old"
              3: "Two years old"
              4: "Three years old"
              5: "Four years old"
              6: "Five years old"
              7: "Six years old"
              8: "Seven years old"
              9: "Eight years old"
              10: "Nine years old"
              11: "Ten years old"
              12: "Eleven years old"

        # CUS-Q1B2 p131: Age in months (if less than one year at entry)
        - id: cus_q1b2
          kind: Question
          title: "Enter the age in months."
          precondition:
            - predicate: lived_with_at_birth == 0 and cus_q1b.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 11

        # CUS-Q1C p131: Reason child did not live with respondent from birth
        - id: cus_q1c
          kind: Question
          title: "What was the reason the child did not live with you right from birth?"
          precondition:
            - predicate: lived_with_at_birth == 0
          input:
            control: Dropdown
            labels:
              1: "You have adopted him/her"
              2: "He/she is a stepchild"
              3: "He/she was put in your care by a child welfare agency (foster care)"
              4: "He/she was put in your care by another type of agency"
              5: "He/she was sick and had to remain in a hospital or other institution"
              6: "You had to leave him/her in the care of someone else for a while"
              7: "Child was in care of a child welfare agency (foster care) for a time"
              8: "Other"

        # ---------------------------------------------------------------
        # CUS-Q1D: Brothers/sisters not living in the household
        # (reached from both birth and non-birth paths after CUS-C1A/C1D)
        # ---------------------------------------------------------------

        - id: cus_q1d
          kind: Question
          title: "Does the child have any brothers or sisters who do not regularly live in this household, excluding step and half brothers and sisters?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q1E p131
        - id: cus_q1e
          kind: Question
          title: "How many brothers/sisters do not regularly live in the household?"
          precondition:
            - predicate: cus_q1d.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q1F p131
        - id: cus_q1f
          kind: Question
          title: "What is the age of the youngest one? (Enter age in years; if less than one year enter 0.)"
          precondition:
            - predicate: cus_q1d.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 30

        # CUS-Q1G p131: Oldest sibling age (only if more than one sibling)
        - id: cus_q1g
          kind: Question
          title: "What is the age of the oldest one? (Enter age in years; if less than one year enter 0.)"
          precondition:
            - predicate: cus_q1d.outcome == 1 and cus_q1e.outcome > 1
          input:
            control: Editbox
            min: 0
            max: 30

        # ---------------------------------------------------------------
        # CUS-I2: Interviewer note (adopted child wording)
        # CUS-Q2: Were parents living together at birth/adoption?
        # ---------------------------------------------------------------

        - id: cus_i2
          kind: Comment
          title: "INTERVIEWER: If adopted, use suitable wording for questions CUS-Q2 and CUS-Q3A, then consider adoptive parents as mother and father for the rest of this section. In questions referring to the time of birth, substitute time of adoption."

        # CUS-Q2 p133
        - id: cus_q2
          kind: Question
          title: "When the child was born/adopted, were his/her parents (biological/adoptive) living together?"
          codeBlock: |
            if cus_q2.outcome == 1:
                parents_together = 1
            else:
                parents_together = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # ---------------------------------------------------------------
        # TOGETHER PATH: CUS-Q3A, Q3B, Q3C, Q3D (parents were together)
        # CUS-Q3A p134
        # ---------------------------------------------------------------

        - id: cus_q3a
          kind: Question
          title: "When the child was born/adopted, were his/her parents married, were they living together in a common-law relationship, or were they living together and eventually got married?"
          precondition:
            - predicate: parents_together == 1
          codeBlock: |
            if cus_q3a.outcome == 1 or cus_q3a.outcome == 3:
                parents_married = 1
                is_married_or_partner = 1
            else:
                parents_married = 0
                is_married_or_partner = 0
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Common law"
              3: "Common-law, but married later"

        # CUS-Q3B p134: Had they lived together before getting married?
        # Shown only if married (Q3A=1)
        - id: cus_q3b
          kind: Question
          title: "Had they been living together before getting married?"
          precondition:
            - predicate: parents_together == 1 and cus_q3a.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q3C p134: Marriage date (shown when common-law but married later Q3A=3)
        - id: cus_q3c
          kind: Question
          title: "What date were they married? (Enter year)"
          precondition:
            - predicate: parents_together == 1 and cus_q3a.outcome == 3
          input:
            control: Editbox
            min: 1940
            max: 2010

        # CUS-Q3D p134: Since when had they been living together
        # Shown for common-law (Q3A=2) or common-law-then-married (Q3A=3),
        # or married-but-lived-together-before (Q3A=1 and Q3B=1)
        - id: cus_q3d
          kind: Question
          title: "Approximately since when had they been living together? (Enter year)"
          precondition:
            - predicate: parents_together == 1 and (cus_q3a.outcome == 2 or cus_q3a.outcome == 3 or (cus_q3a.outcome == 1 and cus_q3b.outcome == 1))
          input:
            control: Editbox
            min: 1940
            max: 2010

        # ---------------------------------------------------------------
        # NOT-TOGETHER PATH: CUS-Q4, Q5A, Q5B-Q5F (parents were NOT together)
        # CUS-Q4 p135: With whom did child live at birth?
        # ---------------------------------------------------------------

        - id: cus_q4
          kind: Question
          title: "Did the child live with his/her:"
          precondition:
            - predicate: parents_together == 0
          input:
            control: Radio
            labels:
              1: "Mother alone"
              2: "Father alone"
              3: "Mother and other"
              4: "Father and other"
              5: "Other"

        # CUS-Q5A p135: Have parents ever lived together?
        - id: cus_q5a
          kind: Question
          title: "Have the child's parents ever lived together as a couple?"
          precondition:
            - predicate: parents_together == 0
          codeBlock: |
            if cus_q5a.outcome == 1:
                parents_ever_lived_together = 1
            else:
                parents_ever_lived_together = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q5B p135: Before or after child's birth?
        - id: cus_q5b
          kind: Question
          title: "Was that before or after his/her birth?"
          precondition:
            - predicate: parents_together == 0 and parents_ever_lived_together == 1
          input:
            control: Radio
            labels:
              1: "Before"
              2: "After"
              3: "Both before and after"

        # CUS-Q5C p135: Were parents ever married?
        - id: cus_q5c
          kind: Question
          title: "Were the child's parents ever married?"
          precondition:
            - predicate: parents_together == 0 and parents_ever_lived_together == 1
          codeBlock: |
            if cus_q5c.outcome == 1:
                parents_married = 1
            else:
                parents_married = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q5D p135: When did they marry?
        - id: cus_q5d
          kind: Question
          title: "When did they marry? (Enter year)"
          precondition:
            - predicate: parents_together == 0 and parents_ever_lived_together == 1 and cus_q5c.outcome == 1
          input:
            control: Editbox
            min: 1940
            max: 2010

        # CUS-Q5E p135: Since when had parents stopped living together (at time of child's birth)?
        # Shown only if parents lived together BEFORE child's birth (Q5B=1)
        - id: cus_q5e
          kind: Question
          title: "At the time the child was born, since when had his/her parents stopped living together? (Enter year)"
          precondition:
            - predicate: parents_together == 0 and parents_ever_lived_together == 1 and cus_q5b.outcome == 1
          input:
            control: Editbox
            min: 1940
            max: 2010

        # CUS-Q5F p136: Steady relationship without living together at time of birth
        - id: cus_q5f
          kind: Question
          title: "Without living together, did the child's parents have a steady relationship at the time of his/her birth?"
          precondition:
            - predicate: parents_together == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # ---------------------------------------------------------------
        # MOTHER'S PRIOR UNIONS: CUS-Q6A through Q6I
        # CUS-Q6A p136: Mother's prior common-law/marriage relationships
        # ---------------------------------------------------------------

        - id: cus_q6a
          kind: Question
          title: "Had the child's mother been in any common-law relationships or been married before the union with the child's father? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q6B p136: How many times? (if yes to Q6A)
        - id: cus_q6b
          kind: Question
          title: "How many times had the child's mother been in such a relationship before?"
          precondition:
            - predicate: cus_q6a.outcome != 8
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q6C p136: Prior to child's birth, any relationships with someone other than child's father?
        # Asked when parents were NOT together (not-together path)
        - id: cus_q6c
          kind: Question
          title: "Before the child's birth, had his/her mother been in any common-law relationships or been married to a person other than the child's father? (Mark all that apply)"
          precondition:
            - predicate: parents_together == 0
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q6D p136: How many times? (if yes to Q6C)
        - id: cus_q6d
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: parents_together == 0 and cus_q6c.outcome != 8
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q6E p136: Did mother have children before entering union with father?
        # (together path only)
        - id: cus_q6e
          kind: Question
          title: "Did the child's mother have any children before entering into union with the child's father?"
          precondition:
            - predicate: parents_together == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q6F p136: How many children?
        - id: cus_q6f
          kind: Question
          title: "How many children did the child's mother have before entering into union?"
          precondition:
            - predicate: parents_together == 1 and cus_q6e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 15

        # CUS-Q6G p136: Did those children live in the household when child was born?
        - id: cus_q6g
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born? (Mark all that apply)"
          precondition:
            - predicate: parents_together == 1 and cus_q6e.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              4: "Yes, some of them full-time"
              8: "Yes, some of them part-time"
              16: "No, none of them"

        # CUS-Q6H p137: How many children did mother have before child?
        # (not-together path)
        - id: cus_q6h
          kind: Question
          title: "How many children did the child's mother have before him/her?"
          precondition:
            - predicate: parents_together == 0
          input:
            control: Editbox
            min: 0
            max: 15

        # CUS-Q6I p137: Did those children live in the household?
        - id: cus_q6i
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born? (Mark all that apply)"
          precondition:
            - predicate: parents_together == 0 and cus_q6h.outcome > 0
          input:
            control: Checkbox
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              4: "Yes, some of them full-time"
              8: "Yes, some of them part-time"
              16: "No, none of them"

        # ---------------------------------------------------------------
        # FATHER'S PRIOR UNIONS: CUS-Q7A through Q7I
        # CUS-Q7A p137: Father's prior unions (together path - after Q6E/Q6F)
        # ---------------------------------------------------------------

        - id: cus_q7a
          kind: Question
          title: "Had the child's father been in any common-law relationships or been married before the union with the child's mother? (Mark all that apply)"
          precondition:
            - predicate: parents_together == 1
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q7B p137: How many times?
        - id: cus_q7b
          kind: Question
          title: "How many times had the child's father been in such a relationship before?"
          precondition:
            - predicate: parents_together == 1 and cus_q7a.outcome != 8
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q7C p137: Father's prior relationships before child's birth (both paths converge here
        # when parents_ever_lived_together == 1 or parents_together == 1)
        - id: cus_q7c
          kind: Question
          title: "Before the child's birth, had his/her father been in any common-law relationships or been married to a person other than the child's mother? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q7D p138: How many times?
        - id: cus_q7d
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: cus_q7c.outcome != 8
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q7E p138: Did father have children before entering union with mother?
        - id: cus_q7e
          kind: Question
          title: "Did the child's father have any children before entering into union with the child's mother?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q7F p138: How many?
        - id: cus_q7f
          kind: Question
          title: "How many children did the child's father have before entering into union?"
          precondition:
            - predicate: cus_q7e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 15

        # CUS-Q7G p138: Did those children live in the household?
        - id: cus_q7g
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born? (Mark all that apply)"
          precondition:
            - predicate: cus_q7e.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              4: "Yes, some of them full-time"
              8: "Yes, some of them part-time"
              16: "No, none of them"

        # CUS-Q7H p138: How many children did father have before child? (not-together path)
        - id: cus_q7h
          kind: Question
          title: "How many children did the child's father have before him/her?"
          precondition:
            - predicate: parents_together == 0
          input:
            control: Editbox
            min: 0
            max: 15

        # CUS-Q7I p138: Did those children live in the household?
        - id: cus_q7i
          kind: Question
          title: "Did that child/any of those children (father's prior children) live at least part time in the household when the child was born? (Mark all that apply)"
          precondition:
            - predicate: parents_together == 0 and cus_q7h.outcome > 0
          input:
            control: Checkbox
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              4: "Yes, some of them full-time"
              8: "Yes, some of them part-time"
              16: "No, none of them"

        # ---------------------------------------------------------------
        # CUS-Q8A: Was father declared on birth certificate?
        # CUS-Q8B-Q8E: Initial contact type with other parent
        # (for not-together-at-birth path)
        # ---------------------------------------------------------------

        # CUS-Q8A p139
        - id: cus_q8a
          kind: Question
          title: "Was the child's father declared on his/her birth certificate?"
          precondition:
            - predicate: parents_together == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q8B p139: First contact type with other parent
        - id: cus_q8b
          kind: Question
          title: "What kind of contact did the child first have with his/her other parent?"
          precondition:
            - predicate: parents_together == 0
          input:
            control: Dropdown
            labels:
              1: "Sharing living arrangements on an equal time basis"
              2: "Sharing living arrangements with most time with mother"
              3: "Sharing living arrangements with most time with father"
              4: "Regular visiting"
              5: "Irregular visiting"
              6: "Telephone or letter contact only"
              7: "No contact at all"
              8: "Other"

        # CUS-Q8C p139: How many times has contact situation changed?
        - id: cus_q8c
          kind: Question
          title: "How many times would you say this situation has changed over time?"
          precondition:
            - predicate: parents_together == 0
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q8D p139: Age at last change (if changed)
        - id: cus_q8d
          kind: Question
          title: "How old was the child when the last change happened? (Enter age in years; if less than one year enter 0.)"
          precondition:
            - predicate: parents_together == 0 and cus_q8c.outcome > 1
          input:
            control: Editbox
            min: 0
            max: 15

        # CUS-Q8E p140: Current contact type with other parent
        - id: cus_q8e
          kind: Question
          title: "What type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: parents_together == 0
          codeBlock: |
            contact_type = cus_q8e.outcome
          input:
            control: Dropdown
            labels:
              1: "Sharing living arrangements on an equal time basis"
              2: "Sharing living arrangements with most time with mother"
              3: "Sharing living arrangements with most time with father"
              4: "Regular visiting"
              5: "Irregular visiting"
              6: "Telephone or letter contact only"
              7: "Both parents now living with the child"
              8: "No contact at all"
              9: "Other"

        # ---------------------------------------------------------------
        # CUS-Q9A/Q9B: Has a parent died?
        # CUS-Q9A p141: For together-at-birth path (parents lived together)
        # CUS-Q9B p142: For not-together path
        # ---------------------------------------------------------------

        # CUS-Q9A p141: Parent death - together-at-birth path
        - id: cus_q9a
          kind: Question
          title: "Between the child's birth and now, has one of his/her parents died?"
          precondition:
            - predicate: parents_together == 1
          codeBlock: |
            if cus_q9a.outcome == 1:
                parent_died = 1
                parent_died_mother = 1
            elif cus_q9a.outcome == 2:
                parent_died = 1
                parent_died_father = 1
            elif cus_q9a.outcome == 3:
                parent_died = 1
                both_parents_died = 1
                parent_died_mother = 1
                parent_died_father = 1
            else:
                parent_died = 0
          input:
            control: Radio
            labels:
              1: "Yes, mother"
              2: "Yes, father"
              3: "Yes, both"
              4: "No"

        # CUS-Q9B p142: Parent death - not-together path
        - id: cus_q9b
          kind: Question
          title: "Has one of the child's parents died?"
          precondition:
            - predicate: parents_together == 0
          codeBlock: |
            if cus_q9b.outcome == 1:
                parent_died = 1
                parent_died_mother = 1
            elif cus_q9b.outcome == 2:
                parent_died = 1
                parent_died_father = 1
            elif cus_q9b.outcome == 3:
                parent_died = 1
                both_parents_died = 1
                parent_died_mother = 1
                parent_died_father = 1
            else:
                parent_died = 0
          input:
            control: Radio
            labels:
              1: "Yes, mother"
              2: "Yes, father"
              3: "Yes, both"
              4: "No"

        # CUS-Q9C p142: When did the parent die?
        - id: cus_q9c
          kind: Question
          title: "When did it happen? (Date of first death, if both) - Enter year"
          precondition:
            - predicate: parent_died == 1 and both_parents_died == 0
          input:
            control: Editbox
            min: 1980
            max: 2010

        # CUS-Q9D p142: With whom did child go on living after parent died?
        - id: cus_q9d
          kind: Question
          title: "With whom did the child go on living at the time it happened?"
          precondition:
            - predicate: parent_died == 1 and both_parents_died == 0
          input:
            control: Radio
            labels:
              1: "Mother"
              2: "Father"
              3: "Other"

        # ---------------------------------------------------------------
        # CUS-Q10A (pre-death separation check) and CUS-Q10B (main separation question)
        # CUS-C10: IF BOTH PARENTS DIED --> skip to child care
        #          IF parent died and parents had lived together --> Q10A
        #          OTHERWISE --> Q10B
        # ---------------------------------------------------------------

        # CUS-Q10A p143: Did parents break up BEFORE the parent died?
        - id: cus_q10a
          kind: Question
          title: "Prior to the death of the child's parent, did his/her parents break up and stop living together?"
          precondition:
            - predicate: both_parents_died == 0 and parent_died == 1 and parents_together == 1
          codeBlock: |
            if cus_q10a.outcome == 1:
                parents_broke_up = 1
            else:
                parents_broke_up = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q10B p143: Since child's birth, did parents break up?
        - id: cus_q10b
          kind: Question
          title: "Since the child's birth, did his/her parents break up and stop living together?"
          precondition:
            - predicate: both_parents_died == 0 and parent_died == 0
          codeBlock: |
            if cus_q10b.outcome == 1:
                parents_broke_up = 1
            else:
                parents_broke_up = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # ---------------------------------------------------------------
        # SEPARATION PATH: CUS-Q11A through CUS-Q19C
        # ---------------------------------------------------------------

        # CUS-Q11A p143: When did the separation happen?
        - id: cus_q11a
          kind: Question
          title: "When did the separation happen? (Enter year)"
          precondition:
            - predicate: parents_broke_up == 1
          input:
            control: Editbox
            min: 1980
            max: 2010

        # CUS-Q11B p143: Did parents eventually divorce?
        # CUS-C11B: Only if parents were married (Q3A=1 or 3, or Q5C=yes)
        - id: cus_q11b
          kind: Question
          title: "Did the child's parents eventually divorce?"
          precondition:
            - predicate: parents_broke_up == 1 and parents_married == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q11C p144: When was divorce pronounced?
        - id: cus_q11c
          kind: Question
          title: "When was the divorce pronounced? (Enter year)"
          precondition:
            - predicate: parents_broke_up == 1 and parents_married == 1 and cus_q11b.outcome == 1
          input:
            control: Editbox
            min: 1980
            max: 2010

        # CUS-Q11D p144: Was there a court order concerning custody?
        - id: cus_q11d
          kind: Question
          title: "Was there a court order concerning the child's custody when his/her parents separated or divorced?"
          precondition:
            - predicate: parents_broke_up == 1
          codeBlock: |
            if cus_q11d.outcome == 1:
                has_court_order = 1
            else:
                has_court_order = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, in progress"
              3: "No"

        # CUS-Q11E p144: What did the court order say about custody?
        - id: cus_q11e
          kind: Question
          title: "Did the court order the child to be put into:"
          precondition:
            - predicate: parents_broke_up == 1 and has_court_order == 1
          codeBlock: |
            custody_type = cus_q11e.outcome
          input:
            control: Radio
            labels:
              1: "Sole custody of mother"
              2: "Sole custody of father"
              3: "Shared physical custody of both parents"
              4: "Other"

        # CUS-Q11F p144: Support/maintenance payment agreement
        - id: cus_q11f
          kind: Question
          title: "What type of agreement was made regarding support/maintenance payments when the child's parents separated or divorced?"
          precondition:
            - predicate: parents_broke_up == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Private agreement between spouses"
              3: "Court-ordered agreement in progress"
              4: "Court-ordered agreement"

        # CUS-Q11G p144: Was agreement for child support, spousal support, or both?
        - id: cus_q11g
          kind: Question
          title: "Was this:"
          precondition:
            - predicate: parents_broke_up == 1 and cus_q11f.outcome == 4
          input:
            control: Radio
            labels:
              1: "For child support only"
              2: "For spousal support only"
              3: "For both"

        # CUS-Q11H p145: How regular have maintenance payments been?
        - id: cus_q11h
          kind: Question
          title: "How regular have the maintenance/support payments been?"
          precondition:
            - predicate: parents_broke_up == 1 and cus_q11f.outcome == 4
          input:
            control: Dropdown
            labels:
              1: "Regular and on time"
              2: "Regular but late sometimes"
              3: "Irregular"
              4: "No payments for the last 6 months"
              5: "No payments for the last year"
              6: "No payments for the last few years"
              7: "Payments never been received"
              8: "Payments stopped due to a change in circumstances"

        # ---------------------------------------------------------------
        # POST-SEPARATION LIVING ARRANGEMENTS: CUS-Q12 through Q18B
        # CUS-C12: IF custody = sole (Q11E=1 or 2) --> Q13; ELSE --> Q12
        # ---------------------------------------------------------------

        # CUS-Q12 p145: With whom did child go on living at time of separation?
        # (not sole custody, or no court order)
        - id: cus_q12
          kind: Question
          title: "With whom did the child go on living at the time of the separation?"
          precondition:
            - predicate: parents_broke_up == 1 and (has_court_order == 0 or (custody_type != 1 and custody_type != 2))
          input:
            control: Radio
            labels:
              1: "Mother only"
              2: "Father only"
              3: "Shared time basis, mostly mother"
              4: "Shared time basis, mostly father"
              5: "Equally shared time, mother and father"
              6: "Other"

        # CUS-Q13 p145: Contact type with other parent (sole custody path)
        - id: cus_q13
          kind: Question
          title: "At that time, what type of contact did the child have with his/her other parent?"
          precondition:
            - predicate: parents_broke_up == 1 and has_court_order == 1 and (custody_type == 1 or custody_type == 2)
          input:
            control: Dropdown
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "No contact at all"
              8: "Other"

        # CUS-Q14 p146: How many times has contact type changed? (sole custody path)
        - id: cus_q14
          kind: Question
          title: "Since then, how many times has the type of contact changed?"
          precondition:
            - predicate: parents_broke_up == 1 and has_court_order == 1 and (custody_type == 1 or custody_type == 2)
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q15A p146: Current contact type (sole custody, contact changed)
        # CUS-C15A: Skip if parent died
        - id: cus_q15a
          kind: Question
          title: "What type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: parents_broke_up == 1 and has_court_order == 1 and (custody_type == 1 or custody_type == 2) and parent_died == 0 and cus_q14.outcome > 1
          input:
            control: Dropdown
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "Lost contact completely"
              8: "Child now shares living arrangements with other parent"
              9: "Parents now living together again"
              10: "Child now lives with other parent only"

        # CUS-Q15B p147: How much time at other parent's home? (if now sharing)
        - id: cus_q15b
          kind: Question
          title: "How much time does the child live at his/her other parent's home? (Mark all that apply)"
          precondition:
            - predicate: parents_broke_up == 1 and has_court_order == 1 and (custody_type == 1 or custody_type == 2) and cus_q15a.outcome == 8
          input:
            control: Checkbox
            labels:
              1: "On weekdays not weekends"
              2: "Every other night"
              4: "One week out of two"
              8: "Two weeks alternately"
              16: "Every weekend"
              32: "One weekend out of two"
              64: "Less than two days every month"
              128: "Some holidays"
              256: "Never"
              512: "All the time"
              1024: "Other"

        # CUS-Q16 p147: Time at other parent's home at separation (shared path)
        - id: cus_q16
          kind: Question
          title: "At that time, how much time did the child live at his/her other parent's home? (Mark all that apply)"
          precondition:
            - predicate: parents_broke_up == 1 and (has_court_order == 0 or (custody_type != 1 and custody_type != 2)) and (cus_q12.outcome == 3 or cus_q12.outcome == 4 or cus_q12.outcome == 5)
          input:
            control: Checkbox
            labels:
              1: "On weekdays not weekends"
              2: "Every other night"
              4: "One week out of two"
              8: "Two weeks alternately"
              16: "Every weekend"
              32: "One weekend out of two"
              64: "Less than two days every month"
              128: "Some holidays"
              256: "Other"

        # CUS-Q17 p147: How many times have living arrangements changed? (shared path)
        - id: cus_q17
          kind: Question
          title: "How many times would you say these living arrangements have changed over time?"
          precondition:
            - predicate: parents_broke_up == 1 and (has_court_order == 0 or (custody_type != 1 and custody_type != 2))
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q18A p148: Current time at other parent's home (shared path, if changed)
        # CUS-C18A: Skip if parent died
        - id: cus_q18a
          kind: Question
          title: "Currently, how much time does the child live at his/her other parent's home? (Mark all that apply)"
          precondition:
            - predicate: parents_broke_up == 1 and (has_court_order == 0 or (custody_type != 1 and custody_type != 2)) and parent_died == 0 and cus_q17.outcome > 1
          input:
            control: Checkbox
            labels:
              1: "On weekdays not weekends"
              2: "Every other night"
              4: "One week out of two"
              8: "Two weeks alternately"
              16: "Every weekend"
              32: "One weekend out of two"
              64: "Less than two days every month"
              128: "Some holidays"
              256: "Visits or letter or telephone calls only"
              512: "No contact"
              1024: "All the time"
              2048: "Parents now living together again"
              4096: "Other"

        # CUS-Q18B p148: Contact type if visits-only selected in Q18A
        - id: cus_q18b
          kind: Question
          title: "Which type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: parents_broke_up == 1 and (has_court_order == 0 or (custody_type != 1 and custody_type != 2)) and parent_died == 0 and cus_q17.outcome > 1 and cus_q18a.outcome == 256
          input:
            control: Radio
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "Other"

        # ---------------------------------------------------------------
        # CUS-Q19A/Q19B/Q19C: Court order modification and tension
        # ---------------------------------------------------------------

        # CUS-Q19A p149: Has court order modified custody since separation?
        - id: cus_q19a
          kind: Question
          title: "Has a court order modified the custody of the child since his/her parents separated (or divorced)?"
          precondition:
            - predicate: parents_broke_up == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q19B p149: New custody arrangement per court order
        - id: cus_q19b
          kind: Question
          title: "Is he/she now in:"
          precondition:
            - predicate: parents_broke_up == 1 and cus_q19a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Sole custody of mother"
              2: "Sole custody of father"
              3: "Shared physical custody of both parents"
              4: "Other"

        # CUS-Q19C p149: Tension about living arrangements/visiting rights
        - id: cus_q19c
          kind: Question
          title: "Between the child's parents, has the question of living arrangements or visiting rights been:"
          precondition:
            - predicate: parents_broke_up == 1
          input:
            control: Radio
            labels:
              1: "A great source of tension"
              2: "Some source of tension"
              3: "Very little source of tension"
              4: "No source of tension at all"

        # ---------------------------------------------------------------
        # NEW UNIONS: CUS-Q20A (mother) and CUS-Q21A (father)
        # CUS-C20B routing logic:
        #   IF mother died --> skip Q20A --> C21
        #   IF Q2=1 AND Q9A=4 AND Q10B=2 (parents together, no death, no separation) --> C25A
        #   OTHERWISE --> Q20A
        # ---------------------------------------------------------------

        # CUS-Q20A p150: Mother's new relationship
        - id: cus_q20a
          kind: Question
          title: "Has the child's mother entered into another marriage, common-law relationship, or common-law relationship that resulted in marriage? (Mark all that apply)"
          precondition:
            - predicate: parent_died_mother == 0 and (parents_broke_up == 1 or parent_died_father == 1)
          codeBlock: |
            if cus_q20a.outcome == 1 or cus_q20a.outcome == 2 or cus_q20a.outcome == 4:
                mother_new_union = 1
            else:
                mother_new_union = 0
          input:
            control: Checkbox
            labels:
              1: "Yes, a marriage"
              2: "Yes, a common-law relationship"
              4: "Yes, a common-law relationship that resulted in marriage"
              8: "No"

        # CUS-Q20B p150: When did mother start living with new partner?
        # (common-law or common-law-then-married: Q20A has bit 2 or 4)
        - id: cus_q20b
          kind: Question
          title: "When did the child's mother start living with her new partner? (Enter year)"
          precondition:
            - predicate: mother_new_union == 1 and (cus_q20a.outcome == 2 or cus_q20a.outcome == 4 or cus_q20a.outcome == 6)
          input:
            control: Editbox
            min: 1980
            max: 2010

        # CUS-Q20C p150: When did the marriage take place?
        - id: cus_q20c
          kind: Question
          title: "When did the marriage take place? (Enter year)"
          precondition:
            - predicate: mother_new_union == 1 and cus_q20a.outcome == 1
          input:
            control: Editbox
            min: 1980
            max: 2010

        # CUS-Q20D p150: Did child live with mother's new partner?
        - id: cus_q20d
          kind: Question
          title: "When they started living together, did the child live in the household with his/her mother's new partner?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes, full-time"
              2: "Yes, part-time"
              3: "No"

        # CUS-Q20E p150: Did mother's new partner have children of his own?
        - id: cus_q20e
          kind: Question
          title: "Did the mother's new partner have any children of his own?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q20F p151: How many children?
        - id: cus_q20f
          kind: Question
          title: "How many children did the mother's new partner have?"
          precondition:
            - predicate: mother_new_union == 1 and cus_q20e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 15

        # CUS-Q20G p151: Did those children live in the household with their father?
        - id: cus_q20g
          kind: Question
          title: "Did he/she/they live in the household with their father? (Mark all that apply)"
          precondition:
            - predicate: mother_new_union == 1 and cus_q20e.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              4: "Yes, some of them full-time"
              8: "Yes, some of them part-time"
              16: "No, none of them"

        # CUS-Q20H p151: Did mother have children with new spouse/partner?
        - id: cus_q20h
          kind: Question
          title: "Did the child's mother have any children with this new spouse/partner?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q20I p151: How many children?
        - id: cus_q20i
          kind: Question
          title: "How many children did the child's mother have with this new spouse/partner?"
          precondition:
            - predicate: mother_new_union == 1 and cus_q20h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 15

        # ---------------------------------------------------------------
        # CUS-Q21A: Father's new relationship
        # CUS-C21: Skip Q21A if father died and mother entered new union
        # ---------------------------------------------------------------

        # CUS-Q21A p151: Father's new relationship
        - id: cus_q21a
          kind: Question
          title: "Has the child's father entered into another marriage, common-law relationship, or common-law relationship that resulted in marriage? (Mark all that apply)"
          precondition:
            - predicate: parent_died_father == 0 and (parents_broke_up == 1 or parent_died_mother == 1)
          codeBlock: |
            if cus_q21a.outcome == 1 or cus_q21a.outcome == 2 or cus_q21a.outcome == 4:
                father_new_union = 1
            else:
                father_new_union = 0
          input:
            control: Checkbox
            labels:
              1: "Yes, a marriage"
              2: "Yes, a common-law relationship"
              4: "Yes, a common-law relationship that resulted in marriage"
              8: "No"

        # CUS-Q21B p151: When did father start living with new partner?
        - id: cus_q21b
          kind: Question
          title: "When did the child's father start living with his new partner? (Enter year)"
          precondition:
            - predicate: father_new_union == 1 and (cus_q21a.outcome == 2 or cus_q21a.outcome == 4 or cus_q21a.outcome == 6)
          input:
            control: Editbox
            min: 1980
            max: 2010

        # CUS-Q21C p152: When did the marriage take place?
        - id: cus_q21c
          kind: Question
          title: "When did the marriage take place? (Enter year)"
          precondition:
            - predicate: father_new_union == 1 and cus_q21a.outcome == 1
          input:
            control: Editbox
            min: 1980
            max: 2010

        # CUS-Q21D p152: Did child live in household with father's new partner?
        - id: cus_q21d
          kind: Question
          title: "When they started living together, did the child live in the household with his/her father's new partner?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes, full-time"
              2: "Yes, part-time"
              3: "No"

        # CUS-Q21E p152: Did father's new partner have children of her own?
        - id: cus_q21e
          kind: Question
          title: "Did the father's new partner have any children of her own?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q21F p152: How many children?
        - id: cus_q21f
          kind: Question
          title: "How many children did the father's new partner have?"
          precondition:
            - predicate: father_new_union == 1 and cus_q21e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 15

        # CUS-Q21G p152: Did those children live in the household with their mother?
        - id: cus_q21g
          kind: Question
          title: "Did he/she/they live in the household with their mother? (Mark all that apply)"
          precondition:
            - predicate: father_new_union == 1 and cus_q21e.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              4: "Yes, some of them full-time"
              8: "Yes, some of them part-time"
              16: "No, none of them"

        # CUS-Q21H p152: Did father have children with new spouse/partner?
        - id: cus_q21h
          kind: Question
          title: "Did the child's father have any children with this new spouse/partner?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CUS-Q21I p152: How many children?
        - id: cus_q21i
          kind: Question
          title: "How many children did the child's father have with this new spouse/partner?"
          precondition:
            - predicate: father_new_union == 1 and cus_q21h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 15

        # ---------------------------------------------------------------
        # SECOND SEPARATION: CUS-Q22A through CUS-Q23
        # CUS-C22: If mother OR father entered new relationship --> Q22A
        # ---------------------------------------------------------------

        # CUS-Q22A p153: Has the other union of mother or father broken up?
        - id: cus_q22a
          kind: Question
          title: "Has this other union of the child's mother or father broken up?"
          precondition:
            - predicate: mother_new_union == 1 or father_new_union == 1
          codeBlock: |
            if cus_q22a.outcome == 1 or cus_q22a.outcome == 2 or cus_q22a.outcome == 3:
                second_union_broke = 1
            else:
                second_union_broke = 0
          input:
            control: Radio
            labels:
              1: "Yes, mother's union"
              2: "Yes, father's union"
              3: "Yes, both unions"
              4: "No"

        # CUS-Q22B p153: When did that happen?
        - id: cus_q22b
          kind: Question
          title: "When did that happen? (If both unions have broken up, use date of first event.) Enter year."
          precondition:
            - predicate: second_union_broke == 1
          input:
            control: Editbox
            min: 1980
            max: 2010

        # CUS-Q22C p153: With whom did child go on living after second separation?
        - id: cus_q22c
          kind: Question
          title: "With whom did the child go on living after it happened?"
          precondition:
            - predicate: second_union_broke == 1
          input:
            control: Radio
            labels:
              1: "Mother full-time"
              2: "Father full-time"
              3: "Part-time with mother and father"

        # CUS-Q23 p153: Any other family reconstitution since then?
        - id: cus_q23
          kind: Question
          title: "Did the child live through any other family reconstitution between then and now?"
          precondition:
            - predicate: second_union_broke == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 7B: CHILD CARE (CAR) - pp. 156-161 - 38 questions
    # CAR-Q1A: Uses child care? YES --> details; NO --> CAR-C6 (age gate)
    # CAR-C1H: age < 4 --> skip school programs (Q1H)
    # CAR-C1I: age < 6 --> skip own-care (Q1I)
    # CAR-C3: age > 5 --> skip provider quality (Q3)
    # CAR-C5/E5: num_care_changes=NONE AND age < 1 --> end
    # CAR-C6: age < 1 --> end; otherwise --> Q6
    # CAR-C8: age < 6 --> skip summer care (Q8)
    # =========================================================================
    - id: b_childcare
      title: "Child Care"
      items:
        # CAR-I1 p156
        - id: car_i1
          kind: Comment
          title: "Now I'd like to ask you some questions regarding your child care arrangements for the child."

        # CAR-Q1A p156: Currently uses child care?
        - id: car_q1a
          kind: Question
          title: "Do you currently use child care such as daycare or babysitting while you (and your spouse/partner) are at work or studying?"
          codeBlock: |
            if car_q1a.outcome == 1:
                uses_childcare = 1
            else:
                uses_childcare = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # ---------------------------------------------------------------
        # CURRENTLY USES CHILD CARE: Q1B through Q1J - care method sub-items
        # ---------------------------------------------------------------

        # CAR-Q1B p156: Care in someone else's home by a non-relative
        - id: car_q1b
          kind: Question
          title: "Which of the following methods of child care do you currently use? Care provided in someone else's home by a non-relative?"
          precondition:
            - predicate: uses_childcare == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1b1
          kind: Question
          title: "For about how many hours per week is care provided in someone else's home by a non-relative?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1b.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        - id: car_q1b2
          kind: Question
          title: "Is the person providing this care licensed by the government or approved by a family daycare agency?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1b.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CAR-Q1C p157: Care in someone else's home by a relative
        - id: car_q1c
          kind: Question
          title: "Care in someone else's home by a relative?"
          precondition:
            - predicate: uses_childcare == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1c1
          kind: Question
          title: "For about how many hours per week is care provided in someone else's home by a relative?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1c.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        - id: car_q1c2
          kind: Question
          title: "Is the person providing this care licensed by the government or approved by a family daycare agency?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1c.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CAR-Q1D p157: Care in own home by brother or sister of the child
        - id: car_q1d
          kind: Question
          title: "Care in own home by brother or sister of the child?"
          precondition:
            - predicate: uses_childcare == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1d1
          kind: Question
          title: "For about how many hours per week is care provided in own home by a brother or sister?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1d.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        # CAR-Q1E p157: Care in own home by a relative other than sibling
        - id: car_q1e
          kind: Question
          title: "Care in own home by a relative other than a sister or brother of the child?"
          precondition:
            - predicate: uses_childcare == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1e1
          kind: Question
          title: "For about how many hours per week is care provided in own home by another relative?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        # CAR-Q1F p157: Care in own home by a non-relative
        - id: car_q1f
          kind: Question
          title: "Care in own home by a non-relative?"
          precondition:
            - predicate: uses_childcare == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1f1
          kind: Question
          title: "For about how many hours per week is care provided in own home by a non-relative?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1f.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        # CAR-Q1G p157: Care in a daycare centre (including at workplace)
        - id: car_q1g
          kind: Question
          title: "Care in a daycare centre (including at workplace)?"
          precondition:
            - predicate: uses_childcare == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1g1
          kind: Question
          title: "For about how many hours per week is care provided at a daycare centre?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1g.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        - id: car_q1g2
          kind: Question
          title: "Is the child care program or daycare centre operated on a profit or non-profit basis (include government sponsored care)?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1g.outcome == 1
          input:
            control: Radio
            labels:
              1: "Profit"
              2: "Non-profit"

        # CAR-Q1H p158: Before or after school program
        # CAR-C1H: age < 4 --> skip Q1H
        - id: car_q1h
          kind: Question
          title: "Care in a before or after school program?"
          precondition:
            - predicate: uses_childcare == 1 and child_age >= 4
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1h1
          kind: Question
          title: "For about how many hours per week is care provided in a before or after school program?"
          precondition:
            - predicate: uses_childcare == 1 and child_age >= 4 and car_q1h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        # CAR-Q1I p158: Child in own care (self-care, before/after school)
        # CAR-C1I: Only for ages 6+
        - id: car_q1i
          kind: Question
          title: "Is the child in his/her own care (e.g. before/after school)?"
          precondition:
            - predicate: uses_childcare == 1 and child_age >= 6
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1i1
          kind: Question
          title: "For about how many hours per week is the child in his/her own care?"
          precondition:
            - predicate: uses_childcare == 1 and child_age >= 6 and car_q1i.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        # CAR-Q1J p158: Other child care arrangements
        - id: car_q1j
          kind: Question
          title: "Do you currently use other child care arrangements?"
          precondition:
            - predicate: uses_childcare == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: car_q1j1
          kind: Question
          title: "For about how many hours per week is that?"
          precondition:
            - predicate: uses_childcare == 1 and car_q1j.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 80

        # ---------------------------------------------------------------
        # MAIN ARRANGEMENT DETAILS: CAR-Q2 through CAR-Q7
        # ---------------------------------------------------------------

        # CAR-I2 p158
        - id: car_i2
          kind: Comment
          title: "In the following questions we will be asking about your main child care arrangement, that is, the one used for the most hours."
          precondition:
            - predicate: uses_childcare == 1

        # CAR-Q2 p159: When did current main arrangement start?
        - id: car_q2
          kind: Question
          title: "When did you start using this child care arrangement? (Enter year)"
          precondition:
            - predicate: uses_childcare == 1
          input:
            control: Editbox
            min: 1990
            max: 2010

        # CAR-Q3 p159: Child-provider relationship quality
        # CAR-C3: age > 5 --> skip Q3
        - id: car_q3
          kind: Question
          title: "During the past 6 months, how well has he/she gotten along with his/her main child care provider?"
          precondition:
            - predicate: uses_childcare == 1 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"

        # CAR-Q4 p159: How many times changed main arrangement in past 12 months?
        - id: car_q4
          kind: Question
          title: "In the past 12 months, how many times have you changed your main child care arrangement and/or caregiver, excluding periods of care by yourself (or spouse/partner)?"
          precondition:
            - predicate: uses_childcare == 1
          codeBlock: |
            num_care_changes = car_q4.outcome
          input:
            control: Radio
            labels:
              1: "None"
              2: "1"
              3: "2"
              4: "3 or 4"
              5: "5 or more"

        # CAR-Q5 p159: Reasons for changing
        # CAR-C5: if NONE (Q4=1) and age < 1 --> skip to end; if NONE and age > 0 --> Q7
        - id: car_q5
          kind: Question
          title: "What were the reasons for changing? (Mark all that apply)"
          precondition:
            - predicate: uses_childcare == 1 and num_care_changes > 1
          input:
            control: Checkbox
            labels:
              1: "Dissatisfaction with caregiver/program"
              2: "Caregiver/program no longer available"
              4: "Family or child moved; parental work status or custody arrangement changed"
              8: "Changes in child or child's needs (e.g. special care, child's age)"
              16: "A preferred arrangement became available (e.g. subsidized space)"
              32: "Cost"
              64: "Other"

        # ---------------------------------------------------------------
        # NOT USING CHILD CARE: CAR-Q6 (ever used?) - age gate >= 1
        # CAR-C6: age < 1 --> end; otherwise --> Q6
        # ---------------------------------------------------------------

        # CAR-Q6 p160: Have you ever used child care? (for non-users, ages 1+)
        - id: car_q6
          kind: Question
          title: "Have you ever used child care for the child while you (and your spouse/partner) were at work or studying?"
          precondition:
            - predicate: uses_childcare == 0 and child_age >= 1
          codeBlock: |
            if car_q6.outcome == 1:
                ever_used_childcare = 1
            else:
                ever_used_childcare = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CAR-Q7 p160: Total changes since starting child care (current and past users, ages 1+)
        - id: car_q7
          kind: Question
          title: "Overall, how many changes in child care arrangements has the child experienced since you began using child care, excluding periods of care by yourself (or spouse/partner)?"
          precondition:
            - predicate: (uses_childcare == 1 and child_age >= 1 and num_care_changes == 1) or (uses_childcare == 0 and ever_used_childcare == 1 and child_age >= 1)
          input:
            control: Editbox
            min: 0
            max: 20

        # CAR-Q8 p160: Summer child care arrangement
        # CAR-C8: age < 6 --> skip Q8
        - id: car_q8
          kind: Question
          title: "Last summer while the child was not in school, what type of child care arrangement did you use while you (and your spouse/partner) were at work/studying? (Mark all that apply)"
          precondition:
            - predicate: (uses_childcare == 1 or ever_used_childcare == 1) and child_age >= 6
          input:
            control: Checkbox
            labels:
              1: "Day care centre"
              2: "Care in someone else's home by a non-relative"
              4: "Care in someone else's home by a relative"
              8: "Care in own home by a non-relative"
              16: "Care in own home by brother/sister"
              32: "Care in own home by other relative"
              64: "Child in own care"
              128: "Structured summer program"
              256: "Other"
              512: "Not applicable"

    # =========================================================================
    # BLOCK 8: ACTIVITIES (ACT) - p105-108
    # NOTE p105: Age-tiered:
    #   AGE 0-3: ACT-Q1-Q2B
    #   AGE 4-5: ACT-Q1-Q3D1, ACT-Q3E-Q5
    #   AGE 6-7: ACT-Q3A-Q3C, ACT-Q3D2, ACT-Q3E-Q5, ACT-Q7A-Q8B
    #   AGE 8-9: ACT-Q3A-Q3C, ACT-Q3D2, ACT-Q3E-Q5, ACT-Q7A-Q8B
    #   AGE 10-11: ACT-Q3A-Q3C, ACT-Q3D3-Q8B
    # =========================================================================
    - id: b_medical
      title: "Medical / Biological History"
      precondition:
        - predicate: child_age <= 3
      items:

        # Gate: only bio mother or bio father proceed
        - id: med_intro
          kind: Comment
          title: "The following questions concern the child's medical and biological history."
          precondition:
            - predicate: is_bio_mother == 1 or is_bio_father == 1

        # ---------------------------------------------------------------
        # PRENATAL — MED-Q1A to MED-Q10B
        # Shown only to bio mother AND child age <= 23 months
        # ---------------------------------------------------------------
        - id: med_q1a
          kind: Question
          title: "The following are prenatal questions concerning the child. During the pregnancy with the child, did you suffer from: pregnancy diabetes?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q1b
          kind: Question
          title: "High blood pressure during pregnancy?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q1c
          kind: Question
          title: "Other physical problems during pregnancy?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q2
          kind: Question
          title: "From whom did you receive pre-natal care?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23
          input:
            control: Radio
            labels:
              1: "A doctor"
              2: "A nurse"
              3: "A midwife"
              4: "Other"
              5: "Nobody"

        # MED-Q3: Smoking during pregnancy
        - id: med_q3
          kind: Question
          title: "Did you smoke during your pregnancy with the child?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23
          codeBlock: |
            if med_q3.outcome == 1:
                smoked_during_pregnancy = 1
            else:
                smoked_during_pregnancy = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q4
          kind: Question
          title: "How many cigarettes per day did you smoke during your pregnancy with the child?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23 and smoked_during_pregnancy == 1
          input:
            control: Editbox
            min: 1
            max: 60
            right: "cigarettes/day"

        - id: med_q5
          kind: Question
          title: "At what stage in your pregnancy did you smoke this amount? (Select all that apply)"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23 and smoked_during_pregnancy == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q6: Alcohol during pregnancy
        - id: med_q6
          kind: Question
          title: "How frequently did you consume alcohol during your pregnancy with the child? (e.g. beer, wine, liquor)"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23
          codeBlock: |
            if med_q6.outcome >= 2 and med_q6.outcome <= 7:
                drank_during_pregnancy = 1
            else:
                drank_during_pregnancy = 0
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "1–3 times a month"
              4: "Once a week"
              5: "2–3 times a week"
              6: "4–6 times a week"
              7: "Every day"

        - id: med_q7
          kind: Question
          title: "On the days when you drank, how many drinks did you usually have?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23 and drank_during_pregnancy == 1
          input:
            control: Radio
            labels:
              1: "1 to 2"
              2: "3 to 4"
              3: "5 or more"

        - id: med_q8
          kind: Question
          title: "At what stage in your pregnancy did you consume this quantity of alcohol? (Select all that apply)"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23 and drank_during_pregnancy == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q9A: Prescription medications during pregnancy
        - id: med_q9a
          kind: Question
          title: "Did you take any prescription medications during your pregnancy with the child?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23
          codeBlock: |
            if med_q9a.outcome == 1:
                took_rx_during_pregnancy = 1
            else:
                took_rx_during_pregnancy = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q9b
          kind: Question
          title: "At what stage in your pregnancy did you take these prescription medications? (Select all that apply)"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23 and took_rx_during_pregnancy == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q10A: Over-the-counter drugs during pregnancy
        - id: med_q10a
          kind: Question
          title: "Did you take any over-the-counter drugs during your pregnancy with the child?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23 and took_rx_during_pregnancy == 0
          codeBlock: |
            if med_q10a.outcome == 1:
                took_otc_during_pregnancy = 1
            else:
                took_otc_during_pregnancy = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q10b
          kind: Question
          title: "At what stage in your pregnancy did you take these over-the-counter drugs? (Select all that apply)"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 23 and took_rx_during_pregnancy == 0 and took_otc_during_pregnancy == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # ---------------------------------------------------------------
        # BIRTH — MED-Q12A onwards
        # Bio mother (all ages ≤3) OR bio father (all ages ≤3)
        # ---------------------------------------------------------------
        - id: med_q12a
          kind: Question
          title: "The following are questions concerning the child's birth. Was he/she born before or after the due date?"
          precondition:
            - predicate: is_bio_mother == 1 or is_bio_father == 1
          codeBlock: |
            if med_q12a.outcome == 1:
                birth_premature = 1
            else:
                birth_premature = 0
          input:
            control: Radio
            labels:
              1: "Before the due date (premature)"
              2: "After the due date"
              3: "On the due date"

        - id: med_q12b
          kind: Question
          title: "How many days or weeks before or after the due date was he/she born?"
          precondition:
            - predicate: (is_bio_mother == 1 or is_bio_father == 1) and (med_q12a.outcome == 1 or med_q12a.outcome == 2)
          input:
            control: Editbox
            min: 1
            max: 120
            right: "days"

        - id: med_q13a
          kind: Question
          title: "What was his/her birth weight in kilograms and grams?"
          precondition:
            - predicate: is_bio_mother == 1 or is_bio_father == 1
          input:
            control: Editbox
            min: 500
            max: 6000
            right: "grams"

        - id: med_q14a
          kind: Question
          title: "What was his/her length at birth in centimetres?"
          precondition:
            - predicate: is_bio_mother == 1 or is_bio_father == 1
          input:
            control: Editbox
            min: 20
            max: 65
            right: "cm"

        - id: med_q15
          kind: Question
          title: "Was this a single birth or twins, or triplets?"
          precondition:
            - predicate: is_bio_mother == 1 or is_bio_father == 1
          codeBlock: |
            if med_q15.outcome == 1:
                single_birth = 1
            else:
                single_birth = 0
          input:
            control: Radio
            labels:
              1: "Single birth"
              2: "Twins"
              3: "Triplets"
              4: "More than triplets"

        # ---------------------------------------------------------------
        # DELIVERY — MED-Q16 to MED-Q20
        # MED-C16: IF age_months 12-23 --> skip delivery, go to Q21A
        #          The prenatal block already handles age_months > 23 skip.
        #          So delivery is shown to bio mother with age_months < 12 only.
        # ---------------------------------------------------------------
        - id: med_q16
          kind: Question
          title: "Was the delivery vaginal or caesarian?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11
          codeBlock: |
            if med_q16.outcome == 1:
                vaginal_delivery = 1
            else:
                vaginal_delivery = 0
          input:
            control: Radio
            labels:
              1: "Vaginal"
              2: "Caesarian"

        - id: med_q17
          kind: Question
          title: "Was the child born head first?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11 and vaginal_delivery == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q18
          kind: Question
          title: "Were birthing aids used?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11 and vaginal_delivery == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Forceps"
              3: "Cupping glass (suction cup)"

        # ---------------------------------------------------------------
        # SPECIAL CARE AFTER BIRTH — MED-Q21A to MED-Q24B
        # Bio mother: age_months ≤23 (delivery skipped for 12-23, but Q21A shown)
        # Bio father: only birth questions (Q12A-Q15, Q21A-Q22)
        # ---------------------------------------------------------------
        - id: med_q21a
          kind: Question
          title: "Did the child receive special medical care following his/her birth?"
          precondition:
            - predicate: (is_bio_mother == 1 and child_age_months <= 23) or is_bio_father == 1
          codeBlock: |
            if med_q21a.outcome == 1:
                had_special_care_at_birth = 1
            else:
                had_special_care_at_birth = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q21b
          kind: Question
          title: "What type of special medical care was received? (Select all that apply)"
          precondition:
            - predicate: ((is_bio_mother == 1 and child_age_months <= 23) or is_bio_father == 1) and had_special_care_at_birth == 1
          input:
            control: Checkbox
            labels:
              1: "Intensive care"
              2: "Ventilation or oxygen"
              4: "Transfer to a specialized hospital"
              8: "Other"

        - id: med_q21c
          kind: Question
          title: "For how many days, in total, was this care received?"
          precondition:
            - predicate: ((is_bio_mother == 1 and child_age_months <= 23) or is_bio_father == 1) and had_special_care_at_birth == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "days"

        - id: med_q22
          kind: Question
          title: "Compared to other babies in general, would you say that the child's health at birth was:"
          precondition:
            - predicate: (is_bio_mother == 1 and child_age_months <= 23) or is_bio_father == 1
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # ---------------------------------------------------------------
        # POSTNATAL (MOTHER ONLY, age_months < 12) — MED-Q23A to MED-Q24B
        # MED-C23A: IF age_months 12-23 --> skip postnatal, go to Q25
        # ---------------------------------------------------------------
        - id: med_q23a
          kind: Question
          title: "The following are postnatal questions concerning the child. After the child's delivery, did you suffer from: postpartum haemorrhage?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q23b
          kind: Question
          title: "Postpartum infection?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q23c1
          kind: Question
          title: "Postpartum depression?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11
          codeBlock: |
            if med_q23c1.outcome == 1:
                had_postpartum_depression = 1
            else:
                had_postpartum_depression = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q23c2
          kind: Question
          title: "For how long did the postpartum depression last?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11 and had_postpartum_depression == 1
          input:
            control: Editbox
            min: 1
            max: 730
            right: "days"

        - id: med_q23d
          kind: Question
          title: "Postpartum hypertension?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q24a
          kind: Question
          title: "Were you hospitalized for special medical care for any period immediately following the birth of the child?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11
          codeBlock: |
            if med_q24a.outcome == 1:
                mother_hospitalized_postpartum = 1
            else:
                mother_hospitalized_postpartum = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q24b
          kind: Question
          title: "For how many days were you hospitalized?"
          precondition:
            - predicate: is_bio_mother == 1 and child_age_months <= 11 and mother_hospitalized_postpartum == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "days"

        # ---------------------------------------------------------------
        # BREASTFEEDING — MED-Q25 to MED-Q28
        # Bio mother, all ages ≤3
        # ---------------------------------------------------------------
        - id: med_q25
          kind: Question
          title: "Are you currently breast-feeding the child?"
          precondition:
            - predicate: is_bio_mother == 1
          codeBlock: |
            if med_q25.outcome == 1:
                currently_breastfeeding = 1
            else:
                currently_breastfeeding = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MED-Q26: Ever breastfed? (only if not currently breastfeeding)
        - id: med_q26
          kind: Question
          title: "Did you breast-feed him/her even if only for a short time?"
          precondition:
            - predicate: is_bio_mother == 1 and currently_breastfeeding == 0
          codeBlock: |
            if med_q26.outcome == 1:
                was_breastfed = 1
            else:
                was_breastfed = 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: med_q27
          kind: Question
          title: "For how long did you breast-feed him/her?"
          precondition:
            - predicate: is_bio_mother == 1 and currently_breastfeeding == 0 and was_breastfed == 1
          input:
            control: Dropdown
            labels:
              1: "Less than 1 week"
              2: "1–4 weeks"
              3: "5–8 weeks"
              4: "9–12 weeks"
              5: "3–6 months"
              6: "7–9 months"
              7: "10–12 months"
              8: "13–16 months"
              9: "More than 16 months"

        - id: med_q28
          kind: Question
          title: "What was the main reason you stopped breast-feeding him/her? (Select all that apply)"
          precondition:
            - predicate: is_bio_mother == 1 and currently_breastfeeding == 0 and was_breastfed == 1
          input:
            control: Checkbox
            labels:
              1: "Not enough milk or hungry baby"
              2: "Inconvenienced or fatigue"
              4: "Difficulty with breastfeeding techniques"
              8: "Sore nipples or engorged breast"
              16: "Mother's illness"
              32: "Planned to stop at this time"
              64: "Baby weaned himself or herself"
              128: "Physician told me to stop"
              256: "Returned to work or school"
              512: "Partner or father wanted me to stop"
              1024: "Formula feeding preferable"
              2048: "Wanted to drink alcohol"
              4096: "Other"

    # =========================================================================
    # BLOCK 4: TEMPERAMENT (TMP) — pp. 68–83 — 68 questions
    # Block precondition: child_age_months >= 3 and child_age_months <= 47
    # Age-variant question pairs modelled as separate items with mutually
    # exclusive preconditions on child_age or child_age_months.
    # =========================================================================
    - id: b_temperament
      title: "Temperament"
      precondition:
        - predicate: child_age_months >= 3 and child_age_months <= 47
      items:

        - id: tmp_i1
          kind: Comment
          title: "The following questions are about how the child behaves. Please answer them for him/her in comparison to others. 'About average' means how you think the typical child would be scored."

        # TMP-Q1: Ease of calming / soothing (all ages 3-47 months)
        - id: tmp_q1
          kind: Question
          title: "How easy or difficult is it for you to calm or soothe the child when he/she is upset?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very easy"
            right: "7 = Difficult"

        # TMP-C2: IF AGE < 12 months --> Q2 (predict sleep/wake); else Q2A (routine consistency)
        - id: tmp_q2
          kind: Question
          title: "How easy or difficult is it for you to predict when he/she will go to sleep and wake up?"
          precondition:
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very easy"
            right: "7 = Difficult"

        - id: tmp_q2a
          kind: Question
          title: "How consistent is he/she in sticking with his/her sleeping routine?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very consistent; little or no variability"
            right: "7 = Very inconsistent; highly variable"

        # TMP-Q3: Predict hunger (all ages — shown before the age check for Q3A)
        - id: tmp_q3
          kind: Question
          title: "How easy or difficult is it for you to predict when he/she will become hungry?"
          precondition:
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very easy"
            right: "7 = Difficult"

        - id: tmp_q3a
          kind: Question
          title: "How consistent is he/she in sticking with his/her eating routine?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very consistent; little or no variability"
            right: "7 = Very inconsistent; highly variable"

        # TMP-C4: IF AGE < 36 months --> Q4 (crying/fussing); else Q4A (irritable)
        - id: tmp_q4
          kind: Question
          title: "How easy or difficult is it for you to know what's bothering him/her when he/she cries or fusses?"
          precondition:
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very easy"
            right: "7 = Very difficult"

        - id: tmp_q4a
          kind: Question
          title: "How easy or difficult is it for you to know what's bothering him/her when he/she is irritable?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very easy"
            right: "7 = Very difficult"

        # TMP-Q5: Fussy/irritable frequency (age < 36 months)
        - id: tmp_q5
          kind: Question
          title: "How many times per day, on average, does the child get fussy and irritable — for either short or long periods of time?"
          precondition:
            - predicate: child_age_months <= 35
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1–2 times per day"
              3: "3–4 times per day"
              4: "5–6 times per day"
              5: "7–9 times per day"
              6: "10–14 times per day"
              7: "15 times per day or more"

        # TMP-Q5A: Cranky/irritable frequency (age 36-47 months)
        - id: tmp_q5a
          kind: Question
          title: "How many times per day on average does the child get cranky and irritable — for either short or long periods of time?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1–2 times per day"
              3: "3–4 times per day"
              4: "5–6 times per day"
              5: "7–9 times per day"
              6: "10–14 times per day"
              7: "15 times per day or more"

        # TMP-Q6: Cry and fuss in general (age < 36 months)
        - id: tmp_q6
          kind: Question
          title: "How much does he/she cry and fuss in general?"
          precondition:
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very little; much less than the average baby"
            right: "7 = A lot; much more than the average baby"

        # TMP-Q6A: Cry, fuss or whine (age 36-47 months)
        - id: tmp_q6a
          kind: Question
          title: "How much does he/she cry, fuss or whine in general?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very little; much less than the average child"
            right: "7 = A lot; much more than the average child"

        # TMP-Q7: How easily upset (all ages 3-47 months)
        - id: tmp_q7
          kind: Question
          title: "How easily does he/she get upset?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very hard to upset — even by things that upset most babies/children"
            right: "7 = Very easily upset by things that wouldn't bother most babies/children"

        # TMP-C8: IF age < 12 months --> Q8; IF age 12-35 months --> Q8A; else --> Q8B
        - id: tmp_q8
          kind: Question
          title: "When he/she gets upset (e.g., before feeding, during diapering, etc.), how vigorously or loudly does he/she cry and fuss?"
          precondition:
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very mild intensity or loudness"
            right: "7 = Very loud or intense; really cuts loose"

        - id: tmp_q8a
          kind: Question
          title: "When he/she gets upset, how vigorously or loudly does he/she cry and fuss?"
          precondition:
            - predicate: child_age_months >= 12 and child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very mild intensity or loudness"
            right: "7 = Very loud or intense; really cuts loose"

        - id: tmp_q8b
          kind: Question
          title: "When he/she gets upset, how vigorously or loudly does he/she cry and whine?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very mild intensity or loudness"
            right: "7 = Very loud or intense"

        # TMP-Q9: Reaction during dressing (all ages 3-47 months)
        - id: tmp_q9
          kind: Question
          title: "How does he/she react when you are dressing him/her?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very well — likes it"
            right: "7 = Doesn't like it at all"

        # TMP-Q9A: Reaction during hairwashing (all ages 3-47 months)
        - id: tmp_q9a
          kind: Question
          title: "How does he/she react during hairwashing?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very well — likes it"
            right: "7 = Doesn't like it at all"

        # TMP-Q10: Activity level in general (all ages)
        - id: tmp_q10
          kind: Question
          title: "How active is the child in general?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very calm and quiet"
            right: "7 = Very active and vigorous"

        # TMP-C11: IF age < 36 months --> Q11 (smile/happy sounds); else Q11A
        - id: tmp_q11
          kind: Question
          title: "How much does he/she smile and make happy sounds?"
          precondition:
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = A great deal; much more than most infants"
            right: "7 = Very little; much less than most infants"

        - id: tmp_q11a
          kind: Question
          title: "How much does he/she smile and laugh?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = A great deal; much more than most children"
            right: "7 = Very little; much less than most children"

        # TMP-Q12: General mood (all ages 3-47 months)
        - id: tmp_q12
          kind: Question
          title: "What kind of mood is he/she generally in?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very happy and cheerful"
            right: "7 = Serious"

        # TMP-C13: IF age_months < 6 --> Q14; IF age_months 6-11 --> Q13; else Q13A
        - id: tmp_q13
          kind: Question
          title: "How much does he/she enjoy playing little games with you?"
          precondition:
            - predicate: child_age_months >= 6 and child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = A great deal — really loves it"
            right: "7 = Very little — doesn't like it very much"

        - id: tmp_q13a
          kind: Question
          title: "How much does he/she enjoy playing with you?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = A great deal — really loves it"
            right: "7 = Very little — doesn't like it very much"

        # TMP-C14: IF age < 36 months --> Q14 (wants to be held); else Q14A (cuddled)
        - id: tmp_q14
          kind: Question
          title: "How much does he/she want to be held?"
          precondition:
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Wants to be free most of the time"
            right: "7 = A great deal — wants to be held almost all the time"

        - id: tmp_q14a
          kind: Question
          title: "How much does he/she want to be cuddled?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Wants to be free most of the time"
            right: "7 = A great deal — wants to be cuddled almost all the time"

        # TMP-Q15: Response to disruptions and routine changes (all ages)
        - id: tmp_q15
          kind: Question
          title: "How does he/she respond to disruptions and changes in everyday routine, such as when you go to church, a meeting, on trips, etc.?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very favourably; doesn't get upset"
            right: "7 = Very unfavourably; gets quite upset"

        # TMP-C16: IF age_months < 12 --> Q16; else Q17
        - id: tmp_q16
          kind: Question
          title: "How easy is it for you to predict when he/she will need a diaper change?"
          precondition:
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very easy"
            right: "7 = Very difficult"

        # TMP-Q17: Mood changeability (age 12-47 months)
        - id: tmp_q17
          kind: Question
          title: "How changeable is the child's mood?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Changes seldom and slowly when he/she does change"
            right: "7 = Changes often and rapidly"

        # TMP-Q18: Excitement when played with or talked to (all ages)
        - id: tmp_q18
          kind: Question
          title: "How excited does he/she become when people play with or talk to him/her?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very excited"
            right: "7 = Not at all"

        # TMP-C19: IF age == 36-47 months --> Q19A; else Q19
        - id: tmp_q19
          kind: Question
          title: "On the average, how much attention does he/she require, other than for caregiving (feeding, bathing, diaper changes, etc.)?"
          precondition:
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very little — much less than the average baby"
            right: "7 = A lot — much more than the average baby"

        - id: tmp_q19a
          kind: Question
          title: "On the average, how much attention does he/she require, other than for caregiving (bathing, eating, etc.)?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very little — much less than the average child"
            right: "7 = A lot — much more than the average child"

        # TMP-Q20: Plays well alone (all ages 3-47 months)
        - id: tmp_q20
          kind: Question
          title: "When left alone, he/she plays well by him/herself?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Almost always"
            right: "7 = Almost never — won't play by self"

        # TMP-C21 routing for confinement reactions:
        #   age_months 3-11  --> Q23 (skips Q21/Q21A/Q21B)
        #   age_months 12-23 --> Q21
        #   age_months 24-35 --> Q21A
        #   age_months 36-47 --> Q21B
        - id: tmp_q21
          kind: Question
          title: "How does he/she react to being confined (as in a carseat, infant seat, playpen, etc.)?"
          precondition:
            - predicate: child_age_months >= 12 and child_age_months <= 23
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very well — likes it"
            right: "7 = Doesn't like it at all"

        - id: tmp_q21a
          kind: Question
          title: "How does he/she react to being confined (as in a carseat, bedroom, crib, etc.)?"
          precondition:
            - predicate: child_age_months >= 24 and child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very well — likes it"
            right: "7 = Doesn't like it at all"

        - id: tmp_q21b
          kind: Question
          title: "How does he/she react to being confined (as in a boosterseat, seatbelt, bedroom, bed, etc.)?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very well — likes it"
            right: "7 = Doesn't like it at all"

        # TMP-Q22: Cuddling/snuggling when held (age_months 12-23 only, per C21 routing)
        - id: tmp_q22
          kind: Question
          title: "How much does he/she cuddle and snuggle when held?"
          precondition:
            - predicate: child_age_months >= 12 and child_age_months <= 23
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = A great deal — almost every time"
            right: "7 = Very little — seldom cuddles"

        # TMP-Q22A: Cuddling/snuggling when close (age_months 24-47)
        - id: tmp_q22a
          kind: Question
          title: "How much does he/she cuddle and snuggle when close to you?"
          precondition:
            - predicate: child_age_months >= 24
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = A great deal — almost every time"
            right: "7 = Very little — seldom cuddles"

        # TMP-Q23: First bath response (age_months 3-11; C23A routes age 3-5 to Q33)
        - id: tmp_q23
          kind: Question
          title: "How did he/she respond to his/her first bath?"
          precondition:
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very well — baby loved it"
            right: "7 = Terribly — didn't like it"

        # TMP-Q23A: Response to new playthings (age_months 6-47; follows C23A)
        - id: tmp_q23a
          kind: Question
          title: "How does he/she typically respond to new playthings?"
          precondition:
            - predicate: child_age_months >= 6
          input:
            control: Radio
            labels:
              1: "Always responds favourably"
              2: "Responds favourably about half the time, or is always neutral"
              3: "Always responds negatively or fearfully"

        # TMP-Q24: First solid food response (age_months 3-35; no Q24 for 36+)
        - id: tmp_q24
          kind: Question
          title: "How did he/she respond to his/her first solid food?"
          precondition:
            - predicate: child_age_months >= 3 and child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very favourably — liked it immediately"
            right: "7 = Very negatively — did not like it at all"

        # TMP-Q24A: Response to new foods (age_months 36-47)
        - id: tmp_q24a
          kind: Question
          title: "How does he/she typically respond to new foods?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Radio
            labels:
              1: "Always responds favourably"
              2: "Responds favourably about half the time, or is always neutral"
              3: "Very negatively — does not like it at all"

        # TMP-Q25: Response to new person (all ages 3-47 months)
        - id: tmp_q25
          kind: Question
          title: "How does he/she typically respond to a new person?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Almost always responds favourably"
            right: "7 = Almost always responds negatively at first"

        # TMP-Q26: Response to new place (all ages 3-47 months)
        - id: tmp_q26
          kind: Question
          title: "How does he/she typically respond to being in a new place?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Almost always responds favourably"
            right: "7 = Almost always responds negatively at first"

        # TMP-C27: IF age < 12 months --> Q27; else Q27A
        - id: tmp_q27
          kind: Question
          title: "How well does he/she adapt to things (such as baths, new people, and new places) eventually?"
          precondition:
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very well — always likes it eventually"
            right: "7 = Almost always dislikes it in the end"

        - id: tmp_q27a
          kind: Question
          title: "How well does he/she adapt to new experiences (such as new playthings, new foods, new persons, etc.) eventually?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very well — always likes it eventually"
            right: "7 = Almost always dislikes it in the end"

        # TMP-C28: IF age < 12 months --> Q33 (skips Q28-Q32); else Q28
        # TMP-Q28: Ease of taking places (age 12-47 months)
        - id: tmp_q28
          kind: Question
          title: "How easy or difficult is it to take him/her places?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Easy; fun to take baby/child with me"
            right: "7 = Difficult; baby/child is usually disruptive"

        # TMP-Q29: Persists with forbidden objects (age 12-47 months)
        - id: tmp_q29
          kind: Question
          title: "Does he/she persist in playing with objects when he/she is told to leave them alone?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Rarely or never persists"
            right: "7 = Almost always persists"

        # TMP-C30: IF age < 36 months --> Q30; else Q30A
        - id: tmp_q30
          kind: Question
          title: "Does he/she continue to go someplace even when you told him/her something like 'stop', 'come here', or 'no-no'?"
          precondition:
            - predicate: child_age_months >= 12 and child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Rarely or never"
            right: "7 = Almost always"

        - id: tmp_q30a
          kind: Question
          title: "Does he/she continue to go someplace even when you told him/her something like 'stop', 'come here', or 'please don't'?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Rarely or never"
            right: "7 = Almost always"

        # TMP-Q31: Gets upset when removed from interesting/forbidden thing (age 12-47 months)
        - id: tmp_q31
          kind: Question
          title: "When removed from something he/she is interested in but should not be getting into, he/she gets upset."
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Never"
            right: "7 = Always gets very upset"

        # TMP-Q32: Persistence in getting attention (age 12-47 months)
        - id: tmp_q32
          kind: Question
          title: "How persistent is he/she in trying to get your attention when you are busy?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Doesn't persist at all"
            right: "7 = Very persistent — will do anything to get attention"

        # TMP-Q33: Overall difficulty for average parent (all ages 3-47 months)
        - id: tmp_q33
          kind: Question
          title: "Please rate the overall degree of difficulty the child would present for the average parent."
          input:
            control: Slider
            min: 1
            max: 7
            left: "1 = Very easy"
            right: "7 = Highly difficult to deal with"

# =============================================================================
    - id: b_activities
      title: "Activities"
      items:
        - id: act_i1
          kind: Comment
          title: "The next few questions are about the child's interests and activities."

        # ACT-C1 p105: IF AGE > 5 --> GO TO ACT-Q3A, OTHERWISE --> GO TO ACT-Q1
        - id: act_q1
          kind: Question
          title: "Does he/she currently attend any nursery school, play group or other early childhood program or activity?"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: act_q2b
          kind: Question
          title: "For about how many hours a week does he/she attend these in total?"
          precondition:
            - predicate: child_age <= 5 and act_q1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 60

        # ACT-C3: IF AGE < 4 YEARS --> GO TO BEHAVIOUR SECTION
        # Sports and activities - ages 4+
        - id: act_q3a
          kind: Question
          title: "In the last 12 months, outside of school hours, how often has the child taken part in any sports which involved coaching or instruction?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3b
          kind: Question
          title: "Taken part in unorganized sports or physical activities?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3c
          kind: Question
          title: "Taken lessons or instruction in music, dance, art or other non-sport activities?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-C3D: Age-specific club question
        # IF AGE 4-5 --> ACT-Q3D1 (Beavers/Sparks)
        # IF AGE 6-9 --> ACT-Q3D2 (Brownies/Cubs)
        # IF AGE 10-11 --> ACT-Q3D3 (Boys and Girls Clubs/Scouts/Guides)
        - id: act_q3d1
          kind: Question
          title: "Taken part in any clubs, groups or community programs with leadership, such as Beavers, Sparks or church groups?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3d2
          kind: Question
          title: "Taken part in any clubs, groups or community programs with leadership, such as Brownies, Cubs or church groups?"
          precondition:
            - predicate: child_age >= 6 and child_age <= 9
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3d3
          kind: Question
          title: "Taken part in any clubs, groups or community programs with leadership, such as Boys and Girls Clubs, Scouts, Guides or church groups?"
          precondition:
            - predicate: child_age >= 10
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q3e
          kind: Question
          title: "Played computer or video games?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        - id: act_q4a
          kind: Question
          title: "About how many days a week on average does the child watch T.V. or videos at home?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Editbox
            min: 0
            max: 7

        - id: act_q4b
          kind: Question
          title: "On those days, how many hours on average does he/she spend watching T.V. or videos?"
          precondition:
            - predicate: child_age >= 4 and act_q4a.outcome >= 1
          input:
            control: Editbox
            min: 1
            max: 16

        - id: act_q5
          kind: Question
          title: "How often does he/she play alone (e.g., riding a bike, doing a craft or hobby, playing ball)?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # ACT-C6 p107: IF AGE < 6 --> GO TO BEHAVIOUR SECTION
        # IF AGE 6-9 --> GO TO ACT-Q7A
        # OTHERWISE --> GO TO ACT-Q6A
        # Home responsibilities - ages 10-11
        - id: act_responsibilities
          kind: QuestionGroup
          title: "How often does he/she:"
          precondition:
            - predicate: child_age >= 10
          questions:
            - "Make his/her own bed"
            - "Clean his/her own room"
            - "Pick up after him/herself"
            - "Help keep shared living areas clean and straight"
            - "Do routine chores such as mow the lawn, help with dinner, wash dishes, etc."
            - "Help manage his/her own time (get up on time, be ready for school, etc.)"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # Camps - ages 6+
        - id: act_q7a
          kind: Question
          title: "Did the child attend an overnight camp last summer?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: act_q7b
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: child_age >= 6 and act_q7a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 90

        - id: act_q8a
          kind: Question
          title: "Last summer, did the child attend a day camp or recreational or skill-building activity that ran for half days or full days?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: act_q8b
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: child_age >= 6 and act_q8a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 90

    # =========================================================================
    # BLOCK 9: ADULT HEALTH (CHLT) - p29-32
    # NOTE p29: Asked for the PMK about the selected child,
    # and the spouse/partner of that person (if applicable)
    # =========================================================================
    - id: b_adult_health
      title: "Adult Health (Person Most Knowledgeable)"
      items:
        - id: chlt_q1
          kind: Question
          title: "In general, would you say your/his/her health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        - id: chlt_q2
          kind: Question
          title: "At the present time do you/does ... smoke cigarettes daily, occasionally or not at all?"
          codeBlock: |
            if chlt_q2.outcome == 1:
                smokes_daily = 1
            else:
                smokes_daily = 0
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Occasionally"
              3: "Not at all"

        - id: chlt_q3
          kind: Question
          title: "How many cigarettes do you/does ... smoke each day now?"
          precondition:
            - predicate: smokes_daily == 1
          input:
            control: Editbox
            min: 1
            max: 97

        # Alcohol section - CHLT-I4 p30
        - id: chlt_i4
          kind: Comment
          title: "Now, some questions about alcohol consumption."

        - id: chlt_q4
          kind: Question
          title: "During the past 12 months, have you/has ... had a drink of beer, wine, liquor or any other alcoholic beverage?"
          codeBlock: |
            if chlt_q4.outcome == 1:
                drinks_alcohol = 1
            else:
                drinks_alcohol = 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: chlt_q5
          kind: Question
          title: "During the past 12 months, how often did you/he/she drink alcoholic beverages?"
          precondition:
            - predicate: drinks_alcohol == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "4-6 times a week"
              3: "2-3 times a week"
              4: "Once a week"
              5: "2-3 times a month"
              6: "Once a month"
              7: "Less than once a month"

        - id: chlt_q6
          kind: Question
          title: "How many times in the past 12 months have you/has he/she had 5 or more drinks on one occasion?"
          precondition:
            - predicate: drinks_alcohol == 1
          codeBlock: |
            binge_count = chlt_q6.outcome
          input:
            control: Editbox
            min: 0
            max: 365

        - id: chlt_q7
          kind: Question
          title: "In the past 12 months, what is the highest number of drinks you/he/she had on one occasion?"
          precondition:
            - predicate: drinks_alcohol == 1 and binge_count >= 1
          input:
            control: Editbox
            min: 5
            max: 50

        # Maternal history - CHLT-C8 p31
        # IF female biological parent with children < 2 years, non-proxy --> pregnancy questions
        - id: chlt_q8
          kind: Question
          title: "How many times throughout your life have you been pregnant including any pregnancies which did not go full term?"
          precondition:
            - predicate: is_female_bio_parent == 1 and child_age < 2
          input:
            control: Editbox
            min: 0
            max: 20

        - id: chlt_q9
          kind: Question
          title: "How many babies have you had?"
          precondition:
            - predicate: is_female_bio_parent == 1 and child_age < 2
          input:
            control: Editbox
            min: 0
            max: 20

        - id: chlt_q11
          kind: Question
          title: "At what age did you have your first baby?"
          precondition:
            - predicate: is_female_bio_parent == 1 and child_age < 2
          input:
            control: Editbox
            min: 10
            max: 60

        # Depression scale - CHLT-Q12A-L p32 (if PMK)
        - id: chlt_i12
          kind: Comment
          title: "The next set of statements describe feelings or behaviours. For each one, please tell me how often you felt or behaved this way during the past week."

        - id: chlt_depression
          kind: QuestionGroup
          title: "How often have you felt or behaved this way during the past week:"
          questions:
            - "I did not feel like eating; my appetite was poor."
            - "I felt that I could not shake off the blues even with help from my family or friends."
            - "I had trouble keeping my mind on what I was doing."
            - "I felt depressed."
            - "I felt that everything I did was an effort."
            - "I felt hopeful about the future."
            - "My sleep was restless."
            - "I was happy."
            - "I felt lonely."
            - "I enjoyed life."
            - "I had crying spells."
            - "I felt that people disliked me."
          input:
            control: Radio
            labels:
              1: "Rarely or none of the time (less than 1 day)"
              2: "Some or a little of the time (1-2 days)"
              3: "Occasionally or a moderate amount of time (3-4 days)"
              4: "Most or all of the time (5-7 days)"

    # =========================================================================
    # BLOCK 10: FAMILY FUNCTIONING (FNC) - p33-34
    # NOTE p33: Asked only of PMK or spouse/partner
    # FNC-C1: If already completed for another household member --> skip
    # =========================================================================
    - id: b_family_functioning
      title: "Family Functioning"
      items:
        - id: fnc_i1
          kind: Comment
          title: "The following statements are about families and family relationships. For each one, please indicate which response best describes your family: strongly agree, agree, disagree or strongly disagree."

        - id: fnc_family_scale
          kind: QuestionGroup
          title: "Please indicate how much you agree or disagree:"
          questions:
            - "Planning family activities is difficult because we misunderstand each other."
            - "In times of crisis we can turn to each other for support."
            - "We cannot talk to each other about sadness we feel."
            - "Individuals (in the family) are accepted for what they are."
            - "We avoid discussing our fears or concerns."
            - "We express feelings to each other."
            - "There are lots of bad feelings in our family."
            - "We feel accepted for what we are."
            - "Making decisions is a problem for our family."
            - "We are able to make decisions about how to solve problems."
            - "We don't get along well together."
            - "We confide in each other."
            - "Drinking is a source of tension or disagreement in our family."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # FNC-C2 p33: IF married/common-law/living with partner --> FNC-Q2
        - id: fnc_q2
          kind: Question
          title: "All things considered, how satisfied or dissatisfied are you with your marriage or relationship with your partner?"
          precondition:
            - predicate: is_married_or_partner == 1
          input:
            control: Slider
            min: 1
            max: 11
            labels:
              1: "Completely dissatisfied"
              6: "Neutral"
              11: "Completely satisfied"

    # =========================================================================
    # BLOCK 11: NEIGHBOURHOOD (SAF) - p35-37
    # =========================================================================
    - id: b_neighbourhood
      title: "Neighbourhood"
      items:
        - id: saf_q1
          kind: Question
          title: "How many years have you lived at this address? (Enter 0 if less than 1 year.)"
          input:
            control: Editbox
            min: 0
            max: 99

        - id: saf_q2
          kind: Question
          title: "How do you feel about your neighbourhood as a place to bring up children? Is it..."
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Good"
              3: "Average"
              4: "Poor"
              5: "Very poor"

        - id: saf_q3
          kind: Question
          title: "Are you involved in any local voluntary organizations such as school groups, church groups, community or ethnic associations?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: saf_neighbourhood_safety
          kind: QuestionGroup
          title: "Please tell me whether you strongly agree, agree, disagree, or strongly disagree with these statements about your neighbourhood."
          questions:
            - "It is safe to walk alone in this neighbourhood after dark."
            - "It is safe for children to play outside during the day."
            - "There are good parks, playgrounds and play spaces in this neighbourhood."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        - id: saf_neighbours
          kind: QuestionGroup
          title: "Please tell me whether you strongly agree, agree, disagree, or strongly disagree about the following when thinking of your neighbours."
          questions:
            - "If there is a problem around here, the neighbours get together to deal with it."
            - "There are adults in the neighbourhood that children can look up to."
            - "People around here are willing to help their neighbours."
            - "You can count on adults in this neighbourhood to watch out that children are safe."
            - "When I'm away from home, I know that my neighbours will keep their eyes open for possible trouble."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        - id: saf_problems
          kind: QuestionGroup
          title: "How much of a problem is the following in this neighbourhood:"
          questions:
            - "Litter, broken glass or garbage in the street or road, on the sidewalk, or in yards"
            - "Selling or using drugs"
            - "Alcoholics and excessive drinking in public"
            - "Groups of young people who cause trouble"
            - "Burglary of homes and apartments"
            - "Unrest due to ethnic or religious differences"
          input:
            control: Radio
            labels:
              1: "A big problem"
              2: "Somewhat of a problem"
              3: "No problem"

    # =========================================================================
    # BLOCK 12: SOCIAL SUPPORT (SUP) - p38-39
    # =========================================================================
    - id: b_social_support
      title: "Social Support"
      items:
        - id: sup_i1
          kind: Comment
          title: "The following statements are about relationships and the support which you get from others. For each of the following, please tell me whether you strongly disagree, disagree, agree, or strongly agree."

        - id: sup_support_scale
          kind: QuestionGroup
          title: "Please indicate how much you agree or disagree:"
          questions:
            - "If something went wrong, no one would help me."
            - "I have family and friends who help me feel safe, secure and happy."
            - "There is someone I trust whom I would turn to for advice if I were having problems."
            - "There is no one I feel comfortable talking about problems with."
            - "I lack a feeling of closeness with another person."
            - "There are people I can count on in an emergency."
          input:
            control: Radio
            labels:
              1: "Strongly disagree"
              2: "Disagree"
              3: "Agree"
              4: "Strongly agree"

        - id: sup_q2a
          kind: Question
          title: "Besides your friends and family, did any of the following help with your personal problems during the past 12 months: Community or social service professionals?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        - id: sup_help_sources
          kind: QuestionGroup
          title: "Did the following help with your personal problems during the past 12 months:"
          questions:
            - "Health professionals"
            - "Religious or spiritual leaders or communities"
            - "Books or magazines"
          input:
            control: Switch
            on: "Yes"
            off: "No"
