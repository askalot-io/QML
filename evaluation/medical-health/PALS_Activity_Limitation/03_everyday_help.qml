qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 Children - Section C: Help with Everyday Activities"

  codeInit: |
    # Extern variable from Section A age-gate processing
    child_under_5: {0, 1}

    # Routing flag: any C9 sub-item = Yes (need more personal care/mobility help)
    c9_any_yes = 0

    # Routing flag: any C12 sub-item = Yes (receive help with housework/family/personal)
    c12_any_yes = 0

    # Routing flag: any C17 sub-item = Yes (need additional housework/family/personal help)
    c17_any_yes = 0

    # Routing flag: any C22 sub-item = Yes (work impact)
    c22_any_yes = 0

    # C15 cost known flag: 0 = amount known or not reached, 1 = DK/R on C15
    c15_dk = 0

  blocks:
    # =========================================================================
    # BLOCK 1: PERSONAL CARE AND MOBILITY HELP (C1-C11)
    # =========================================================================
    # C_AGE.edit: children under 5 skip this entire block → go to C12 block
    # C1: receive personal care help? Yes → C2, No/DK/R → C5
    # C2: condition-related? Yes → C3, No/DK/R → C5
    # C3: how much help?  → C4
    # C4: who provides?   → C5
    # C5: moving about help? Yes → C6, No/DK/R → C9
    # C6: condition-related? Yes → C7, No/DK/R → C9
    # C7: how much help? → C8
    # C8: who provides?  → C9
    # C9: need MORE help? (2 sub-items) → C9.edit (codeBlock sets c9_any_yes)
    # C9.edit: c9_any_yes == 1 → C10, else → C12 block
    # C10: hours of help needed → C11
    # C11: why not receiving (8 sub-items) → C12 block
    # =========================================================================
    - id: b_personal_mobility
      title: "Personal Care and Mobility Help"
      precondition:
        - predicate: child_under_5 == 0

      items:
        # C1: Personal care help
        - id: q_c1
          kind: Question
          title: "Does ..... USUALLY receive help with personal care, such as bathing, toiletting, dressing or feeding?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C2: Condition-related personal care
        # Precondition: C1 = Yes
        - id: q_c2
          kind: Question
          title: "Is this because of his/her condition or health problem?"
          precondition:
            - predicate: q_c1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C3: Amount of personal care help needed
        # Precondition: C1=Yes AND C2=Yes
        - id: q_c3
          kind: Question
          title: "How much help does he/she need?"
          precondition:
            - predicate: q_c1.outcome == 1
            - predicate: q_c2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some help"
              2: "A lot of help"
              8: "Don't know"
              9: "Refusal"

        # C4: Who provides personal care help
        # Precondition: C1=Yes AND C2=Yes (follows C3)
        - id: q_c4
          kind: Question
          title: "Who provides most of the help to ..... for his/her personal care?"
          precondition:
            - predicate: q_c1.outcome == 1
            - predicate: q_c2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # C5: Moving about help
        - id: q_c5
          kind: Question
          title: "Does ..... USUALLY receive help with moving about inside his/her residence, such as moving from one room to another?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C6: Condition-related mobility help
        # Precondition: C5 = Yes
        - id: q_c6
          kind: Question
          title: "Is this because of his/her condition or health problem?"
          precondition:
            - predicate: q_c5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C7: Amount of mobility help needed
        # Precondition: C5=Yes AND C6=Yes
        - id: q_c7
          kind: Question
          title: "How much help does he/she need?"
          precondition:
            - predicate: q_c5.outcome == 1
            - predicate: q_c6.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some help"
              2: "A lot of help"
              8: "Don't know"
              9: "Refusal"

        # C8: Who provides mobility help
        # Precondition: C5=Yes AND C6=Yes (follows C7)
        - id: q_c8
          kind: Question
          title: "Who provides most of the help to ..... for moving about inside his/her residence?"
          precondition:
            - predicate: q_c5.outcome == 1
            - predicate: q_c6.outcome == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # C9: Need more help (2 sub-items: personal care, moving about)
        # codeBlock sets c9_any_yes routing flag
        - id: qg_c9
          kind: QuestionGroup
          title: "Because of .....'s condition, do you CURRENTLY need help or additional help with:"
          questions:
            - "His/her personal care?"
            - "Moving him/her about inside his/her residence?"
          codeBlock: |
            if qg_c9.outcome[0] == 1 or qg_c9.outcome[1] == 1:
              c9_any_yes = 1
            else:
              c9_any_yes = 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C10: Hours of help needed per week
        # Precondition: any C9 = Yes
        - id: q_c10
          kind: Question
          title: "How many hours per week of help or additional help do you need?"
          precondition:
            - predicate: c9_any_yes == 1
          input:
            control: Radio
            labels:
              1: "1–4 hours per week"
              2: "5–10 hours per week"
              3: "More than 10 hours per week"
              8: "Don't know"
              9: "Refusal"

        # C11: Why not receiving needed help (8 sub-items)
        # Precondition: any C9 = Yes (follows C10)
        - id: qg_c11
          kind: QuestionGroup
          title: "Why do you not receive this help? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: c9_any_yes == 1
          questions:
            - "It is too expensive"
            - "Help from family and friends is not available"
            - "Services or special programs (for help) are not available locally"
            - "Child is presently on a waiting list"
            - "Do not know where to look for help"
            - "Child's condition is not serious enough"
            - "You have not asked for help"
            - "Other, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: HOUSEWORK / FAMILY HELP — RECEIPT (C12-C16)
    # =========================================================================
    # Everyone reaches C12 (children under 5 skip block 1 but reach here)
    # C12: receive help with housework/family/personal? (3 sub-items)
    #   codeBlock sets c12_any_yes
    # C12.edit: c12_any_yes == 1 → C13, else → C17 block
    # C13: who provides (7 sub-items) → C14
    # C14: out-of-pocket expenses? Yes → C15, No/DK/R → C17 block
    # C15: dollar amount (Editbox; DK routes to C16 via c15_dk flag)
    # C16: expense group (if C15 DK/R) → C17 block
    # =========================================================================
    - id: b_housework_received
      title: "Help with Housework and Family Activities (Received)"

      items:
        # C12: Receive help with housework/family/personal (3 sub-items)
        - id: qg_c12
          kind: QuestionGroup
          title: "Because of .....'s condition, do you USUALLY receive help with the following:"
          questions:
            - "Help with everyday housework, such as house cleaning or meal preparation"
            - "Help to allow you to attend to other family responsibilities"
            - "Help to allow you to take time off for personal activities"
          codeBlock: |
            if qg_c12.outcome[0] == 1 or qg_c12.outcome[1] == 1 or qg_c12.outcome[2] == 1:
              c12_any_yes = 1
            else:
              c12_any_yes = 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C13: Who provides help (7 sub-items)
        # Precondition: any C12 = Yes
        - id: qg_c13
          kind: QuestionGroup
          title: "Who USUALLY provides you this help? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: c12_any_yes == 1
          questions:
            - "Family living with you"
            - "Family not living with you"
            - "Friends or neighbours"
            - "Government organization or agency"
            - "Private organization or agency"
            - "Voluntary organization or agency"
            - "Other, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C14: Out-of-pocket expenses in past 12 months?
        # Precondition: any C12 = Yes (follows C13)
        - id: q_c14
          kind: Question
          title: "You mentioned earlier that you usually receive help with everyday housework or help to allow you to attend to other family or personal activities. IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for this help?"
          precondition:
            - predicate: c12_any_yes == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C15: Dollar amount of out-of-pocket costs
        # Precondition: C14 = Yes
        # codeBlock: if outcome == 0 (used as sentinel for DK/R) set c15_dk=1
        # Note: 0 is out of range (range 1-999999), so 0 = respondent chose DK/R
        - id: q_c15
          kind: Question
          title: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program."
          precondition:
            - predicate: q_c14.outcome == 1
          codeBlock: |
            if q_c15.outcome == 0:
              c15_dk = 1
            else:
              c15_dk = 0
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"
            default: 0

        # C16: Expense group estimate (if C15 DK/R)
        # Precondition: C14=Yes AND C15 was DK/R (c15_dk == 1)
        - id: q_c16
          kind: Question
          title: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?"
          precondition:
            - predicate: q_c14.outcome == 1
            - predicate: c15_dk == 1
          input:
            control: Radio
            labels:
              1: "Less than $200"
              2: "$200 to less than $500"
              3: "$500 to less than $1,000"
              4: "$1,000 to less than $2,000"
              5: "$2,000 to less than $5,000"
              6: "$5,000 or more"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 3: HOUSEWORK / FAMILY HELP — UNMET NEED (C17-C18)
    # =========================================================================
    # C17: currently need MORE help (3 sub-items); codeBlock sets c17_any_yes
    # C17.edit: c17_any_yes == 1 → C18, else → C19
    # C18: why not receiving (8 sub-items) → C19
    # =========================================================================
    - id: b_housework_needed
      title: "Help with Housework and Family Activities (Unmet Need)"

      items:
        # C17: Need more help (3 sub-items)
        - id: qg_c17
          kind: QuestionGroup
          title: "Because of .....'s condition, do you CURRENTLY need help or additional help with the following:"
          questions:
            - "Help with everyday housework, such as house cleaning or meal preparation"
            - "Help to allow you to attend to other family responsibilities"
            - "Help to allow you to take time off for personal activities"
          codeBlock: |
            if qg_c17.outcome[0] == 1 or qg_c17.outcome[1] == 1 or qg_c17.outcome[2] == 1:
              c17_any_yes = 1
            else:
              c17_any_yes = 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C18: Why not receiving help (8 sub-items)
        # Precondition: any C17 = Yes
        - id: qg_c18
          kind: QuestionGroup
          title: "Why do you not receive this help or additional help? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: c17_any_yes == 1
          questions:
            - "It is too expensive"
            - "Help from family and friends is not available"
            - "Services or special programs (for help) are not available locally"
            - "Child is presently on a waiting list"
            - "Do not know where to look for help"
            - "Child's condition is not serious enough"
            - "You have not asked for help"
            - "Other, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 4: CARE COORDINATION AND WORK IMPACT (C19-C24)
    # =========================================================================
    # C19: difficulty coordinating care? Yes → C20, No/DK/R → C21
    # C20: what difficulty (7 sub-items) → C21
    # C21: who coordinates care → C22
    # C22: work impact (5 sub-items); codeBlock sets c22_any_yes
    # C22.edit: c22_any_yes == 1 → C23, else → C24
    # C23: who most affected → C24
    # C24: financial problems → Section D
    # =========================================================================
    - id: b_coordination_work
      title: "Care Coordination and Work Impact"

      items:
        # C19: Difficulty coordinating care
        - id: q_c19
          kind: Question
          title: "IN THE PAST 12 MONTHS, did you have any difficulty with coordinating the care of ....., for example, making appointments, phoning or visiting health professionals and specialists?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # C20: What kind of difficulty (7 sub-items)
        # Precondition: C19 = Yes
        - id: qg_c20
          kind: QuestionGroup
          title: "What kind of difficulty did you have? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_c19.outcome == 1
          questions:
            - "Difficulty obtaining appointments"
            - "Health professional or specialist not available locally"
            - "A lack of communication between health professionals"
            - "Difficulty getting information"
            - "Your lack of time to coordinate the care"
            - "Work conflicts"
            - "Other difficulty, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C21: Who coordinates care
        - id: q_c21
          kind: Question
          title: "Who USUALLY coordinates the care of .....?"
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the father and the mother"
              4: "Other family members"
              5: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # C22: Work impact (5 sub-items)
        # codeBlock sets c22_any_yes routing flag
        - id: qg_c22
          kind: QuestionGroup
          title: "Because of .....'s condition or health problem, has anyone in your family EVER:"
          questions:
            - "Not taken a job in order to take care of the child?"
            - "Quit working (other than normal maternity or paternity leave)?"
            - "Changed work hours to different time of day (or night)?"
            - "Turned down a promotion or a better job?"
            - "Worked fewer hours?"
          codeBlock: |
            if qg_c22.outcome[0] == 1 or qg_c22.outcome[1] == 1 or qg_c22.outcome[2] == 1 or qg_c22.outcome[3] == 1 or qg_c22.outcome[4] == 1:
              c22_any_yes = 1
            else:
              c22_any_yes = 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C23: Who most affected by work-related issues
        # Precondition: any C22 = Yes
        - id: q_c23
          kind: Question
          title: "Who was most affected by these work-related issues?"
          precondition:
            - predicate: c22_any_yes == 1
          input:
            control: Radio
            labels:
              1: "Mostly the mother"
              2: "Mostly the father"
              3: "Both the mother and the father"
              4: "Other family members"
              5: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # C24: Financial problems due to child's condition
        - id: q_c24
          kind: Question
          title: "DURING THE PAST 12 MONTHS, has your family had financial problems because of .....'s condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
