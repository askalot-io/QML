qmlVersion: "1.0"
questionnaire:
  title: "NPHS - Smoking and Alcohol"
  codeInit: |
    # No cross-section variables read or produced by this section
    pass

  blocks:
    # =========================================================================
    # BLOCK 1: SMOKING (SMOK-INT to SMOK-Q8)
    # =========================================================================
    # Routing summary:
    #   SMOK-Q2 = 1 (Daily)        → Q3 → Q4 → Alcohol
    #   SMOK-Q2 = 2 (Occasionally) → Q5 → [Q6 → Q7 → Q8 if Yes] → Alcohol
    #   SMOK-Q2 = 3 (Not at all)   → Q4a → [Q5 → Q6 → Q7 → Q8 if Yes] → Alcohol
    #   SMOK-Q2 = DK/R             → skip to Alcohol
    # =========================================================================
    - id: b_smoking
      title: "Smoking"
      items:
        # SMOK-INT: Section introduction (no response)
        - id: q_smok_int
          kind: Comment
          title: "The next few questions are about smoking."

        # SMOK-Q1 / SMC4_1: Household smoking
        # Always asked
        - id: q_smok_q1
          kind: Question
          title: "Does anyone in this household smoke regularly inside the house?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SMOK-Q2 / SMC4_2: Current smoking status
        # 1=Daily → Q3 → Q4
        # 2=Occasionally → Q5
        # 3=Not at all → Q4a
        # DK/R → skip to Alcohol section
        - id: q_smok_q2
          kind: Question
          title: "At the present time, does ... smoke cigarettes daily, occasionally or not at all?"
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Occasionally"
              3: "Not at all"

        # SMOK-Q3 / SMC4_3: Age began smoking daily
        # Precondition: daily smoker (Q2 = 1)
        - id: q_smok_q3
          kind: Question
          title: "At what age did ... begin to smoke cigarettes daily?"
          precondition:
            - predicate: q_smok_q2.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years old"

        # SMOK-Q4 / SMC4_4: Cigarettes per day (current daily smoker)
        # Precondition: daily smoker (Q2 = 1)
        # After Q4 → GO TO Alcohol section
        - id: q_smok_q4
          kind: Question
          title: "How many cigarettes does ... smoke each day now?"
          precondition:
            - predicate: q_smok_q2.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 200
            right: "cigarettes"

        # SMOK-Q4a / SMC4_4A: Ever smoked at all?
        # Precondition: not at all (Q2 = 3)
        # Yes (1) → Q5; No (2) → Alcohol; DK/R → Alcohol
        - id: q_smok_q4a
          kind: Question
          title: "Has ... ever smoked cigarettes at all?"
          precondition:
            - predicate: q_smok_q2.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # SMOK-Q5 / SMC4_5: Ever smoked daily?
        # Precondition: occasionally (Q2=2) OR (not at all AND Q4a=Yes)
        # Yes (1) → Q6 → Q7 → Q8; No (2) → Alcohol; DK/R → Alcohol
        - id: q_smok_q5
          kind: Question
          title: "Has ... ever smoked cigarettes daily?"
          precondition:
            - predicate: q_smok_q2.outcome == 2 or (q_smok_q2.outcome == 3 and q_smok_q4a.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # SMOK-Q6 / SMC4_6: Age began smoking daily (former daily smoker)
        # Precondition: ever smoked daily (Q5 = 1)
        - id: q_smok_q6
          kind: Question
          title: "At what age did ... begin to smoke cigarettes daily?"
          precondition:
            - predicate: q_smok_q2.outcome == 2 or (q_smok_q2.outcome == 3 and q_smok_q4a.outcome == 1)
            - predicate: q_smok_q5.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years old"

        # SMOK-Q7 / SMC4_7: Cigarettes per day when smoked daily
        # Precondition: ever smoked daily (Q5 = 1)
        - id: q_smok_q7
          kind: Question
          title: "How many cigarettes did ... usually smoke each day?"
          precondition:
            - predicate: q_smok_q2.outcome == 2 or (q_smok_q2.outcome == 3 and q_smok_q4a.outcome == 1)
            - predicate: q_smok_q5.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 200
            right: "cigarettes"

        # SMOK-Q8 / SMC4_8: Age stopped smoking daily
        # Precondition: ever smoked daily (Q5 = 1)
        - id: q_smok_q8
          kind: Question
          title: "At what age did ... stop smoking cigarettes daily?"
          precondition:
            - predicate: q_smok_q2.outcome == 2 or (q_smok_q2.outcome == 3 and q_smok_q4a.outcome == 1)
            - predicate: q_smok_q5.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years old"

    # =========================================================================
    # BLOCK 2: ALCOHOL (ALCO-INT to ALCO-Q7)
    # =========================================================================
    # Routing summary:
    #   ALCO-Q1 = 1 (Yes) → Q2 → Q3 → Q4 → Q5
    #     ALCO-Q5 = 1 (Yes) → Q5A → done
    #     ALCO-Q5 = 2/DK/R  → done
    #   ALCO-Q1 = 2 (No)  → Q5B
    #     ALCO-Q5B = 1 (Yes) → Q6
    #       ALCO-Q6 = 1 (Yes) → Q7
    #     ALCO-Q5B = 2/DK/R  → done
    #   ALCO-Q1 = DK/R    → skip section (Physical Activities)
    # Note: ALCO-Q4 is non-proxy only; we include it unconditionally
    #       since proxy status is not modelled in this section.
    # =========================================================================
    - id: b_alcohol
      title: "Alcohol"
      items:
        # ALCO-INT: Section introduction (no response)
        - id: q_alco_int
          kind: Comment
          title: "Now, some questions about ...(r/'s) alcohol consumption. When we use the word drink it means: one bottle or can of beer or a glass of draft / one glass of wine or a wine cooler / one straight or mixed drink with one and a half ounces of hard liquor."

        # ALCO-Q1 / ALC4_1: Had a drink in past 12 months?
        # Yes (1) → Q2 onwards; No (2) → Q5B; DK/R → skip section
        - id: q_alco_q1
          kind: Question
          title: "During the past 12 months, has ... had a drink of beer, wine, liquor or any other alcoholic beverage?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # ALCO-Q2 / ALC4_2: Drinking frequency in past 12 months
        # Precondition: drank in past 12 months (Q1 = 1)
        - id: q_alco_q2
          kind: Question
          title: "During the past 12 months, how often did ... drink alcoholic beverages? (Do not read list. Mark one only.)"
          precondition:
            - predicate: q_alco_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "4 to 6 times a week"
              3: "2 to 3 times a week"
              4: "Once a week"
              5: "2 to 3 times a month"
              6: "Once a month"
              7: "Less than once a month"

        # ALCO-Q3 / ALC4_3: Times had 5+ drinks on one occasion
        # Precondition: drank in past 12 months (Q1 = 1)
        - id: q_alco_q3
          kind: Question
          title: "How many times in the past 12 months has ... had 5 or more drinks on one occasion?"
          precondition:
            - predicate: q_alco_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 365
            right: "times"

        # ALCO-Q4 / ALC4_4: Highest number of drinks on one occasion
        # Non-proxy only (proxy → skip to Q5); proxy not modelled, included unconditionally
        # Precondition: drank in past 12 months (Q1 = 1)
        - id: q_alco_q4
          kind: Question
          title: "In the past 12 months, what is the highest number of drinks ... had on one occasion?"
          precondition:
            - predicate: q_alco_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 100
            right: "drinks"

        # ALCO-Q5 / ALC4_5: Drank in past week?
        # Precondition: drank in past 12 months (Q1 = 1)
        # Yes (1) → Q5A; No (2) or DK/R → done (Physical Activities)
        - id: q_alco_q5
          kind: Question
          title: "Thinking back over the past week, that is, from last Monday to yesterday, did ... have a drink of beer, wine, liquor or any other alcoholic beverage?"
          precondition:
            - predicate: q_alco_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # ALCO-Q5A / ALC4_5A1-ALC4_5A7: Drinks per day of week
        # Precondition: drank in past week (Q5 = 1)
        # One Editbox sub-item per day (Monday through Sunday)
        - id: qg_alco_q5a
          kind: QuestionGroup
          title: "Starting with yesterday, how many drinks did ... have on:"
          precondition:
            - predicate: q_alco_q5.outcome == 1
          questions:
            - "Monday"
            - "Tuesday"
            - "Wednesday"
            - "Thursday"
            - "Friday"
            - "Saturday"
            - "Sunday"
          input:
            control: Editbox
            min: 0
            max: 50
            right: "drinks"

        # ALCO-Q5B / ALC4_5B: Ever had a drink at all?
        # Precondition: did NOT drink in past 12 months (Q1 = 2)
        # Yes (1) → Q6; No (2) or DK/R → done
        - id: q_alco_q5b
          kind: Question
          title: "Did ... ever have a drink?"
          precondition:
            - predicate: q_alco_q1.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # ALCO-Q6 / ALC4_6: Ever regularly drink more than 12 drinks/week?
        # Precondition: ever had a drink (Q5B = 1)
        # Yes (1) → Q7; No (2) or DK/R → done
        - id: q_alco_q6
          kind: Question
          title: "Did ... ever regularly drink more than 12 drinks a week?"
          precondition:
            - predicate: q_alco_q1.outcome == 2
            - predicate: q_alco_q5b.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # ALCO-Q7 / ALC4_7A-ALC4_7M: Why reduced or quit drinking
        # Precondition: ever regularly drank heavily (Q6 = 1)
        # Checkbox with power-of-2 keys (mark all that apply)
        - id: q_alco_q7
          kind: Question
          title: "Why did ... reduce or quit drinking altogether? (Do not read list. Mark all that apply.)"
          precondition:
            - predicate: q_alco_q1.outcome == 2
            - predicate: q_alco_q5b.outcome == 1
            - predicate: q_alco_q6.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Dieting"
              2: "Athletic training"
              4: "Pregnancy"
              8: "Getting older"
              16: "Drinking too much / drinking problem"
              32: "Affected work / studies / employment"
              64: "Interfered with family / home life"
              128: "Affected physical health"
              256: "Affected friendships / social relationships"
              512: "Affected financial position"
              1024: "Affected outlook on life / happiness"
              2048: "Influence of family / friends"
              4096: "Other (specify)"
