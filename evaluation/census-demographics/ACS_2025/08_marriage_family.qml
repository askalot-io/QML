qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Marriage, Family & Grandchildren (Person Q21-Q26)"

  codeInit: |
    person_age: range(0, 120)
    person_sex: {1, 2}

  blocks:
    # ── Marital Status & History (Q21-Q24) — age >= 15 ──
    - id: b_marital_status
      title: "Marital Status"
      precondition:
        - predicate: "person_age >= 15"
      items:
        # P_Q21: Current marital status
        - id: q_p_q21
          kind: Question
          title: "What is this person's marital status?"
          input:
            control: Radio
            labels:
              1: "Now married"
              2: "Widowed"
              3: "Divorced"
              4: "Separated"
              5: "Never married"

        # P_Q22a: Married in past 12 months
        - id: q_p_q22a
          kind: Question
          title: "In the PAST 12 MONTHS did this person get married?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q22b: Widowed in past 12 months
        - id: q_p_q22b
          kind: Question
          title: "In the PAST 12 MONTHS did this person get widowed?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q22c: Divorced in past 12 months
        - id: q_p_q22c
          kind: Question
          title: "In the PAST 12 MONTHS did this person get divorced?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q23: Times married
        - id: q_p_q23
          kind: Question
          title: "How many times has this person been married?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Radio
            labels:
              1: "Once"
              2: "Two times"
              3: "Three or more times"

        # P_Q24: Year last married
        - id: q_p_q24
          kind: Question
          title: "In what year did this person last get married?"
          precondition:
            - predicate: "q_p_q21.outcome in [1, 2, 3, 4]"
          input:
            control: Editbox
            min: 1940
            max: 2026

    # ── Fertility (Q25) — Filter J: female age 15-50 ──
    - id: b_fertility
      title: "Fertility"
      precondition:
        - predicate: "person_sex == 2 and person_age >= 15 and person_age <= 50"
      items:
        # P_Q25: Given birth in past 12 months
        - id: q_p_q25
          kind: Question
          title: "In the PAST 12 MONTHS, has this person given birth to any children?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ── Grandchildren (Q26a-c) — age >= 15 ──
    - id: b_grandchildren
      title: "Grandchildren"
      precondition:
        - predicate: "person_age >= 15"
      items:
        # P_Q26a: Grandchildren under 18 in household
        - id: q_p_q26a
          kind: Question
          title: "Does this person have any of his/her own grandchildren under the age of 18 living in this house or apartment?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q26b: Responsible for grandchildren
        - id: q_p_q26b
          kind: Question
          title: "Is this grandparent currently responsible for most of the basic needs of any grandchildren under the age of 18 who live in this house or apartment?"
          precondition:
            - predicate: "q_p_q26a.outcome == 1"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q26c: Duration of responsibility
        - id: q_p_q26c
          kind: Question
          title: "How long has this grandparent been responsible for these grandchildren?"
          precondition:
            - predicate: "q_p_q26b.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Less than 6 months"
              2: "6 to 11 months"
              3: "1 or 2 years"
              4: "3 or 4 years"
              5: "5 or more years"
