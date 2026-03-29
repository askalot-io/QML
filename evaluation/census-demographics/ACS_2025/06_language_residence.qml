qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Person: Language, Ancestry & Residence"

  blocks:
    - id: b_ancestry_language
      title: "Ancestry & Language"
      items:
        # P_Q13: Ancestry or ethnic origin
        - id: q_p_q13
          kind: Question
          title: "What is this person's ancestry or ethnic origin? (For example: Italian, Jamaican, African Am., Cambodian, Cape Verdean, Norwegian, Dominican, French Canadian, Haitian, Korean, Lebanese, Polish, Nigerian, Mexican, Taiwanese, Ukrainian, and so on.)"
          input:
            control: Textarea
            placeholder: "e.g., Italian, Jamaican, African Am."

        # P_Q14a: Speaks language other than English at home?
        - id: q_p_q14a
          kind: Question
          title: "Does this person speak a language other than English at home?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P_Q14b: What language?
        - id: q_p_q14b
          kind: Question
          title: "What is this language?"
          precondition:
            - predicate: "q_p_q14a.outcome == 1"
          input:
            control: Textarea
            placeholder: "e.g., Korean, Italian, Spanish, Vietnamese"

        # P_Q14c: How well does this person speak English?
        - id: q_p_q14c
          kind: Question
          title: "How well does this person speak English?"
          precondition:
            - predicate: "q_p_q14a.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Not well"
              4: "Not at all"

    - id: b_residence
      title: "Residence 1 Year Ago"
      items:
        # P_Q15a: Did this person live in this house 1 year ago?
        - id: q_p_q15a
          kind: Question
          title: "Did this person live in this house or apartment 1 year ago?"
          input:
            control: Radio
            labels:
              0: "Person is under 1 year old"
              1: "Yes, this house"
              2: "No, outside the United States and Puerto Rico"
              3: "No, different house in the United States or Puerto Rico"

        # P_Q15b: Where did this person live 1 year ago?
        - id: q_p_q15b
          kind: Question
          title: "Where did this person live 1 year ago? (Address, city, county, state, ZIP)"
          precondition:
            - predicate: "q_p_q15a.outcome == 3"
          input:
            control: Textarea
            placeholder: "Address, city, county, state, ZIP code"
