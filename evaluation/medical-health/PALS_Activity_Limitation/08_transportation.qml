qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 (Children) — Section H: Transportation"
  codeInit: |
    child_under_5: {0, 1}

  blocks:
    # =========================================================================
    # BLOCK 1: SECTION H — TRANSPORTATION (items H1–H16)
    # =========================================================================
    # H1   → Car features? Radio 5-way (Yes/No/No car/DK/R). 1/DK/R→H3; 3→H2; 5→H5.
    # H2   → Need other features? Radio Yes/No/DK. 1→H4; 3→H3; DK/R→H5.
    # H3   → Need any features? Radio Yes/No/DK. 1/3→H4; DK/R→H5.
    # H4   → Why not have features? QuestionGroup 4 sub-items Switch. →H5.
    # H5   → Specialized bus service available? Radio Yes/No/DK. 1→H7; 3/DK/R→H6.
    # H6   → Does child need this service? Radio Yes/No/DK. 1→H7; 3/DK/R→H11.
    # H7   → Does child use this service? Radio Yes/No/DK. 1/3→H8; DK/R→H11.
    # H8   → How often? Radio 4-point. →H9.
    # H9   → Had difficulty? Radio Yes/No/DK. 1/3→H10/H11; DK/R→H11.
    # H10  → What difficulty? QuestionGroup 5 sub-items Switch. →H11.
    # H11  → Had to use taxi? Radio Yes/No/DK. 1/3→H12; DK/R→H13.
    # H12  → How often taxi? Radio 4-point. →H13.
    # H13  → Cancel/reschedule activities? Radio Yes/No. →H14.
    # H14  → Out-of-pocket transport expenses? Radio Yes/No/DK. 1/3→H15; DK/R→end.
    # H15  → Estimated dollar amount (0=DK/R). Editbox 0–999999. 0→H16; >0→end.
    # H16  → Expense group. Radio 7 options. →end.
    # =========================================================================
    - id: b_transportation
      title: "Transportation"
      precondition:
        - predicate: child_under_5 == 0
      items:

        # H1: Car has special features/equipment?
        # 1=Yes → H3; 3=No → H2; 5=No car → H5; 8=DK → H3; 9=R → H3
        - id: q_h1
          kind: Question
          title: "I would like to ask you about the means of transportation that ..... uses for local travel on his/her own or with someone else. This includes trips to the doctor, recreational events or any other local trips under 80 km (50 miles). Because of .....'s condition, does your car have special features or equipment, such as a lift device or a large trunk to carry a wheelchair?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              5: "Do not own a car"
              8: "Don't know"
              9: "Refusal"

        # H2: Need any other special features for car?
        # Precondition: H1 = No (3 only)
        # 1=Yes → H4; 3=No → H3; 8=DK → H5; 9=R → H5
        - id: q_h2
          kind: Question
          title: "Do you NEED ANY OTHER special features or equipment for your car because of .....'s condition?"
          precondition:
            - predicate: q_h1.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H3: Need any special features for car?
        # Precondition: H1 in {1,8,9} (Yes/DK/R) OR H2 = No (3)
        # 1=Yes → H4; 3=No → H4; 8=DK → H5; 9=R → H5
        - id: q_h3
          kind: Question
          title: "Because of .....'s condition, do you NEED any special features or equipment (for your car)?"
          precondition:
            - predicate: (q_h1.outcome in [1, 8, 9]) or (q_h1.outcome == 3 and q_h2.outcome == 3)
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H4: Why not have special features for car? (4 sub-items)
        # Precondition: H2 = Yes (1), OR H3 in {1, 3}
        # Always → H5
        - id: qg_h4
          kind: QuestionGroup
          title: "Why do you not have these special features or equipment for your car? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: (q_h2.outcome == 1) or (q_h3.outcome in [1, 3])
          questions:
            - "Not covered by insurance"
            - "Too expensive"
            - "Only needed occasionally"
            - "Other reason, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H5: Specialized bus service available in area?
        # No item-level precondition (reached from all car-feature paths and from H1=5)
        # 1=Yes → H7; 3=No → H6; 8=DK → H6; 9=R → H6
        - id: q_h5
          kind: Question
          title: "Some communities have a specialized bus service for people who have difficulty using regular transportation services. (To use this service, people can call ahead and ask to be picked up). Is this service available in your area?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H6: Does child need this specialized bus service?
        # Precondition: H5 in {3, 8, 9} (No/DK/R — service not confirmed available)
        # 1=Yes → H7; 3=No → H11; 8=DK → H11; 9=R → H11
        - id: q_h6
          kind: Question
          title: "Does ..... NEED this service?"
          precondition:
            - predicate: q_h5.outcome in [3, 8, 9]
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H7: Does child use this specialized bus service?
        # Precondition: H5 = Yes (1) OR H6 = Yes (1)
        # 1=Yes → H8; 3=No → H8; 8=DK → H11; 9=R → H11
        - id: q_h7
          kind: Question
          title: "Does ..... use this service?"
          precondition:
            - predicate: (q_h5.outcome == 1) or (q_h6.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H8: How often does child use specialized bus service?
        # Precondition: H7 in {1, 3} (Yes or No — not DK/R)
        # Always → H9
        - id: q_h8
          kind: Question
          title: "How often does he/she use this service?"
          precondition:
            - predicate: q_h7.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Almost everyday for at least some part of the year"
              2: "Frequently"
              3: "Occasionally"
              4: "Seldom"
              8: "Don't know"
              9: "Refusal"

        # H9: Had difficulty using specialized bus service in past 12 months?
        # Precondition: H7 in {1, 3} (H8 was shown, so H9 follows H8)
        # 1=Yes → H10; 3=No → H11; 8=DK → H11; 9=R → H11
        - id: q_h9
          kind: Question
          title: "IN THE PAST 12 MONTHS, did ..... have any difficulty using this service?"
          precondition:
            - predicate: q_h7.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H10: What kind of difficulty? (5 sub-items)
        # Precondition: H9 = Yes (1)
        # Always → H11
        - id: qg_h10
          kind: QuestionGroup
          title: "What kind of difficulty did he/she have? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_h9.outcome == 1
          questions:
            - "Service is needed more often than currently offered"
            - "Impractical scheduling for child's needs"
            - "Booking rules don't allow for last minute arrangements"
            - "Too expensive"
            - "Other reason, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H11: Had to use taxi service in past 12 months?
        # No item-level precondition (convergence point from all bus-service paths)
        # 1=Yes → H12; 3=No → H12; 8=DK → H13; 9=R → H13
        - id: q_h11
          kind: Question
          title: "IN THE PAST 12 MONTHS has ..... had to use a taxi service because of his/her condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H12: How often did child use taxi service?
        # Precondition: H11 in {1, 3} (Yes or No — not DK/R)
        # Always → H13
        - id: q_h12
          kind: Question
          title: "How often did he/she use a taxi service?"
          precondition:
            - predicate: q_h11.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Almost everyday for at least some part of the year"
              2: "Frequently"
              3: "Occasionally"
              4: "Seldom"
              8: "Don't know"
              9: "Refusal"

        # H13: Had to cancel/reschedule activities due to transportation problems?
        # No item-level precondition (universal convergence point)
        # Always → H14
        - id: q_h13
          kind: Question
          title: "IN THE PAST 12 MONTHS, for local trips which you must take with ....., have you had to cancel or reschedule some activities because of problems with transportation services?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H14: Out-of-pocket transportation expenses in past 12 months?
        # Always follows H13
        # 1=Yes → H15; 3=No → H15; 8=DK → end of section; 9=R → end of section
        - id: q_h14
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses for .....'s transportation, for example, his/her travel to and from treatment, therapy or other medical or rehabilitation services?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # H15: Best estimate of out-of-pocket transportation costs?
        # Precondition: H14 in {1, 3} (Yes or No — not DK/R)
        # Valid amount (>0) → end of section; 0 (DK/R proxy) → H16
        - id: q_h15
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? (Enter 0 if you don't know or refuse to answer)"
          precondition:
            - predicate: q_h14.outcome in [1, 3]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # H16: Expense group (best estimate of direct costs)?
        # Precondition: H15 = 0 (Don't know / Refusal proxy)
        # Always → end of section
        - id: q_h16
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: q_h14.outcome in [1, 3] and q_h15.outcome == 0
          input:
            control: Radio
            labels:
              1: "Less than $100"
              2: "$100 to less than $200"
              3: "$200 to less than $500"
              4: "$500 to less than $1000"
              5: "$1000 to less than $2000"
              6: "$2000 to less than $5000"
              7: "$5000 or more"
              8: "Don't know"
              9: "Refusal"
