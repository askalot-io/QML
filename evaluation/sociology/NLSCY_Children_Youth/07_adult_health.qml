qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Adult Health (CHLT)"
  codeInit: |
    # Variables READ from prior sections
    is_pmk = 0                    # 1=Person Most Knowledgeable about child
    is_bio_mother_young_child = 0 # 1=biological mother of child under 2

    # Variables PRODUCED by this section
    cesd_score = 0                # CES-D Depression Scale score

  blocks:
    # =========================================================================
    # BLOCK 1: GENERAL HEALTH AND SMOKING (CHLT-Q1 to CHLT-Q3)
    # =========================================================================
    - id: b_general_health
      title: "General Health and Smoking"
      items:
        # CHLT-Q1: General health rating
        - id: q_chlt_q1
          kind: Question
          title: "In general, would you say your health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # CHLT-Q2: Smoking frequency
        - id: q_chlt_q2
          kind: Question
          title: "At the present time, do you smoke cigarettes daily, occasionally, or not at all?"
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Occasionally"
              3: "Not at all"

        # CHLT-Q3: Cigarettes per day
        # Precondition: daily smoker only (Q2 == 1)
        # If occasionally or not at all → skip to alcohol section
        - id: q_chlt_q3
          kind: Question
          title: "How many cigarettes do you smoke each day now?"
          precondition:
            - predicate: q_chlt_q2.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 100
            right: "cigarettes"

    # =========================================================================
    # BLOCK 2: ALCOHOL CONSUMPTION (CHLT-I4 to CHLT-Q7)
    # =========================================================================
    - id: b_alcohol
      title: "Alcohol Consumption"
      items:
        # CHLT-I4: Introduction to alcohol questions
        - id: q_chlt_i4
          kind: Comment
          title: "Now, some questions about alcohol consumption."

        # CHLT-Q4: Drank in past 12 months
        - id: q_chlt_q4
          kind: Question
          title: "During the past 12 months, have you had a drink of beer, wine, liquor, or any other alcoholic beverage?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CHLT-Q5: Drinking frequency
        # Precondition: drank in past 12 months (Q4 == 1)
        - id: q_chlt_q5
          kind: Question
          title: "During the past 12 months, how often did you drink alcoholic beverages?"
          precondition:
            - predicate: q_chlt_q4.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Every day"
              2: "4 to 6 times a week"
              3: "2 to 3 times a week"
              4: "Once a week"
              5: "2 to 3 times a month"
              6: "Once a month"
              7: "Less than once a month"

        # CHLT-Q6: Binge drinking occasions
        # Precondition: drank in past 12 months (Q4 == 1)
        - id: q_chlt_q6
          kind: Question
          title: "How many times in the past 12 months have you had 5 or more drinks on one occasion?"
          precondition:
            - predicate: q_chlt_q4.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 365
            right: "times"

        # CHLT-Q7: Highest number of drinks on one occasion
        # Precondition: drank in past 12 months (Q4 == 1)
        # NOTE: IF Q6 == 0 (no binge occasions) → GO TO CHLT-C8 (skip Q7)
        - id: q_chlt_q7
          kind: Question
          title: "In the past 12 months, what is the highest number of drinks you had on one occasion?"
          precondition:
            - predicate: q_chlt_q4.outcome == 1
            - predicate: q_chlt_q6.outcome != 0
          input:
            control: Editbox
            min: 1
            max: 50
            right: "drinks"

    # =========================================================================
    # BLOCK 3: MATERNAL HISTORY (CHLT-Q8 to CHLT-Q11)
    # =========================================================================
    # CHLT-C8: IF biological mother of child under 2, AND non-proxy
    #          → maternal questions; OTHERWISE → CES-D
    # Modeled as block precondition: is_bio_mother_young_child == 1
    # =========================================================================
    - id: b_maternal
      title: "Maternal History"
      precondition:
        - predicate: is_bio_mother_young_child == 1
      items:
        # CHLT-Q8: Number of pregnancies
        - id: q_chlt_q8
          kind: Question
          title: "How many times throughout your life have you been pregnant, including any pregnancies which did not go full term?"
          input:
            control: Editbox
            min: 1
            max: 30
            right: "pregnancies"

        # CHLT-Q9: Number of babies
        - id: q_chlt_q9
          kind: Question
          title: "How many babies have you had?"
          input:
            control: Editbox
            min: 1
            max: 20
            right: "babies"
          postcondition:
            - predicate: q_chlt_q9.outcome <= q_chlt_q8.outcome
              hint: "Number of babies cannot exceed number of pregnancies."

        # CHLT-Q11: Age at first baby
        - id: q_chlt_q11
          kind: Question
          title: "At what age did you have your first baby?"
          input:
            control: Editbox
            min: 10
            max: 55
            right: "years old"

    # =========================================================================
    # BLOCK 4: CES-D DEPRESSION SCALE (CHLT-Q12A to CHLT-Q12L)
    # =========================================================================
    # CHLT-C12: IF respondent is PMK → CES-D; OTHERWISE → next section
    # Modeled as block precondition: is_pmk == 1
    # =========================================================================
    - id: b_cesd
      title: "CES-D Depression Scale"
      precondition:
        - predicate: is_pmk == 1
      items:
        # CHLT-I12: Introduction
        - id: q_chlt_i12
          kind: Comment
          title: "The next set of statements describe feelings or behaviours. For each one, please tell me how often you felt or behaved this way during the past week."

        # CHLT-Q12A through Q12L: 12 CES-D items
        # Items F (index 5), H (index 7), J (index 9) are reverse-scored
        # (positive affect items scored inversely).
        # Scale: 1=Rarely, 2=Some of the time, 3=Occasionally, 4=Most of the time
        - id: qg_cesd
          kind: QuestionGroup
          title: "How often have you felt or behaved this way during the past week:"
          questions:
            - "(A) I did not feel like eating; my appetite was poor."
            - "(B) I felt that I could not shake off the blues even with help from my family or friends."
            - "(C) I had trouble keeping my mind on what I was doing."
            - "(D) I felt depressed."
            - "(E) I felt that everything I did was an effort."
            - "(F) I felt hopeful about the future."
            - "(G) My sleep was restless."
            - "(H) I was happy."
            - "(I) I felt lonely."
            - "(J) I enjoyed life."
            - "(K) I had crying spells."
            - "(L) I felt that people disliked me."
          input:
            control: Radio
            labels:
              1: "Rarely or none of the time (less than 1 day)"
              2: "Some or a little of the time (1-2 days)"
              3: "Occasionally or a moderate amount of time (3-4 days)"
              4: "Most or all of the time (5-7 days)"
          codeBlock: |
            # CES-D scoring: items are scored 0-3 (subtract 1 from each response)
            # Items F (index 5), H (index 7), J (index 9) are reverse-scored:
            #   reverse = 4 - response  (so 1→3, 2→2, 3→1, 4→0)
            # Regular items: score = response - 1  (so 1→0, 2→1, 3→2, 4→3)
            #
            # Regular items: A(0), B(1), C(2), D(3), E(4), G(6), I(8), K(10), L(11)
            cesd_score = (qg_cesd.outcome[0] - 1) + (qg_cesd.outcome[1] - 1) + (qg_cesd.outcome[2] - 1) + (qg_cesd.outcome[3] - 1) + (qg_cesd.outcome[4] - 1) + (qg_cesd.outcome[6] - 1) + (qg_cesd.outcome[8] - 1) + (qg_cesd.outcome[10] - 1) + (qg_cesd.outcome[11] - 1)
            # Reverse-scored items: F(5), H(7), J(9)
            cesd_score = cesd_score + (4 - qg_cesd.outcome[5]) + (4 - qg_cesd.outcome[7]) + (4 - qg_cesd.outcome[9])
