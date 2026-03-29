qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Sections B & C: Dwelling Characteristics and Facilities"

  codeInit: |
    # No extern variables needed; all routing is within this file.

  blocks:
    # =========================================================================
    # BLOCK: DWELLING CHARACTERISTICS (Section B)
    # =========================================================================
    # B_Q01-B_Q11: dwelling type, age, repairs, rooms, heating, fuel.
    # "Other (Specify)" follow-ups for B_Q01, B_Q07, B_Q09, B_Q10, B_Q11.
    # =========================================================================
    - id: b_dwelling
      title: "Dwelling Characteristics"
      items:
        # B_Q01: Dwelling type
        - id: q_b_q01
          kind: Question
          title: "What type of dwelling did your household live in on December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Single detached"
              2: "Double"
              3: "Row or terrace"
              4: "Duplex"
              5: "Apartment less than 5 storeys"
              6: "Apartment 5 or more storeys"
              7: "Hotel/rooming/lodging house/camp"
              8: "Mobile home"
              9: "Other (Specify)"

        # B_Q01 specify
        - id: q_b_q01_specify
          kind: Question
          title: "Please specify the other dwelling type."
          precondition:
            - predicate: q_b_q01.outcome == 9
          input:
            control: Textarea
            placeholder: "Specify dwelling type..."

        # B_Q02: Year built
        - id: q_b_q02
          kind: Question
          title: "When was this dwelling originally built?"
          input:
            control: Radio
            labels:
              1: "1920 or before"
              2: "1921-1945"
              3: "1946-1960"
              4: "1961-1970"
              5: "1971-1980"
              6: "1981-1990"
              7: "1991-1999"
              8: "2000"

        # B_Q03: Repairs needed
        - id: q_b_q03
          kind: Question
          title: "Was this dwelling in need of any repairs on December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Yes, major repairs"
              2: "Yes, minor repairs"
              3: "No, only regular maintenance"

        # B_Q04: Number of rooms
        - id: q_b_q04
          kind: Question
          title: "How many rooms were there in this dwelling?"
          input:
            control: Editbox
            min: 1
            max: 99

        # B_Q05: Number of bedrooms
        - id: q_b_q05
          kind: Question
          title: "How many bedrooms were there in this dwelling? (If bachelor apartment, enter 0)"
          input:
            control: Editbox
            min: 0
            max: 99

        # B_Q06: Number of bathrooms
        - id: q_b_q06
          kind: Question
          title: "How many bathrooms with a bathtub or shower were there in this dwelling?"
          input:
            control: Editbox
            min: 0
            max: 99

        # B_Q07: Principal heating equipment
        - id: q_b_q07
          kind: Question
          title: "What was the principal heating equipment for this dwelling?"
          input:
            control: Radio
            labels:
              1: "Steam/hot water furnace"
              2: "Forced hot air furnace"
              3: "Other hot air furnace"
              4: "Heating stove (incl. wood)"
              5: "Electric heating (incl. baseboard)"
              6: "Cookstove"
              7: "Other (Specify)"

        # B_Q07 specify
        - id: q_b_q07_specify
          kind: Question
          title: "Please specify the other heating equipment."
          precondition:
            - predicate: q_b_q07.outcome == 7
          input:
            control: Textarea
            placeholder: "Specify heating equipment..."

        # B_Q08: Heating equipment age
        - id: q_b_q08
          kind: Question
          title: "How old was this heating equipment?"
          input:
            control: Radio
            labels:
              1: "5 years or less (1995-2000)"
              2: "6-10 years (1990-1994)"
              3: "11-15 years (1985-1989)"
              4: "16-20 years (1980-1984)"
              5: "Over 20 years (before 1980)"

        # B_Q09: Principal heating fuel
        - id: q_b_q09
          kind: Question
          title: "What was the principal fuel for this heating equipment?"
          input:
            control: Radio
            labels:
              1: "Oil/liquid fuel"
              2: "Piped gas (natural gas)"
              3: "Bottled gas (propane)"
              4: "Electricity"
              5: "Wood"
              6: "Other (Specify)"

        # B_Q09 specify
        - id: q_b_q09_specify
          kind: Question
          title: "Please specify the other heating fuel."
          precondition:
            - predicate: q_b_q09.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify heating fuel..."

        # B_Q10: Hot water fuel
        - id: q_b_q10
          kind: Question
          title: "What was the principal fuel for the hot water supply?"
          input:
            control: Radio
            labels:
              1: "Oil/liquid fuel"
              2: "Piped gas"
              3: "Bottled gas"
              4: "Electricity"
              5: "Wood"
              6: "Other (Specify)"
              7: "No running hot water"

        # B_Q10 specify
        - id: q_b_q10_specify
          kind: Question
          title: "Please specify the other hot water fuel."
          precondition:
            - predicate: q_b_q10.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify hot water fuel..."

        # B_Q11: Cooking fuel
        - id: q_b_q11
          kind: Question
          title: "What was the main fuel used for cooking?"
          input:
            control: Radio
            labels:
              1: "Oil/liquid fuel"
              2: "Piped gas"
              3: "Bottled gas"
              4: "Electricity"
              5: "Wood"
              6: "Other (Specify)"

        # B_Q11 specify
        - id: q_b_q11_specify
          kind: Question
          title: "Please specify the other cooking fuel."
          precondition:
            - predicate: q_b_q11.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify cooking fuel..."

    # =========================================================================
    # BLOCK: FACILITIES ASSOCIATED WITH THE DWELLING (Section C)
    # =========================================================================
    # C_Q01-C_Q17: equipment counts and yes/no facilities.
    # C_Q05 gated on C_Q04 > 0 (telephone count).
    # C_Q12 gated on C_Q11=Yes (home computer).
    # C_Q13 gated on C_Q12=Yes (modem).
    # =========================================================================
    - id: b_facilities
      title: "Facilities Associated with the Dwelling"
      items:
        # C_Q01: Refrigerators
        - id: q_c_q01
          kind: Question
          title: "How many refrigerators?"
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q02: Colour TVs
        - id: q_c_q02
          kind: Question
          title: "How many colour TV sets?"
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q03: VCRs
        - id: q_c_q03
          kind: Question
          title: "How many VCRs?"
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q04: Telephones (excluding cellular)
        - id: q_c_q04
          kind: Question
          title: "How many telephones? (Include business phones, exclude cellular)"
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q05: Telephone numbers (gated on having telephones)
        - id: q_c_q05
          kind: Question
          title: "How many telephone numbers for this dwelling?"
          precondition:
            - predicate: q_c_q04.outcome > 0
          input:
            control: Editbox
            min: 0
            max: 9

        # C_Q06: Cellular phone
        - id: q_c_q06
          kind: Question
          title: "Did you have a cellular phone for personal use?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q07: Microwave oven
        - id: q_c_q07
          kind: Question
          title: "Did you have a microwave oven?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q08: Separate freezer
        - id: q_c_q08
          kind: Question
          title: "Did you have a freezer separate from the refrigerator?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q09: Cable TV
        - id: q_c_q09
          kind: Question
          title: "Did you have cable TV?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q10: CD player
        - id: q_c_q10
          kind: Question
          title: "Did you have a CD player?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q11: Home computer
        - id: q_c_q11
          kind: Question
          title: "Did you have a home computer? (Exclude business-only)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q12: Modem (gated on having home computer)
        - id: q_c_q12
          kind: Question
          title: "Did you have a modem?"
          precondition:
            - predicate: q_c_q11.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q13: Internet from home (gated on having modem)
        - id: q_c_q13
          kind: Question
          title: "Did you use the Internet from home?"
          precondition:
            - predicate: q_c_q12.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # C_Q14: Air conditioning
        - id: q_c_q14
          kind: Question
          title: "Did you have air conditioning?"
          input:
            control: Radio
            labels:
              1: "Window-type"
              2: "Central"
              3: "None"

        # C_Q15: Dishwasher
        - id: q_c_q15
          kind: Question
          title: "Did you have a dishwasher?"
          input:
            control: Radio
            labels:
              1: "Built-in automatic"
              2: "Portable automatic"
              3: "None"

        # C_Q16: Washing machine
        - id: q_c_q16
          kind: Question
          title: "Did you have a washing machine (inside dwelling)?"
          input:
            control: Radio
            labels:
              1: "Automatic"
              2: "Other kind"
              3: "None"

        # C_Q17: Clothes dryer
        - id: q_c_q17
          kind: Question
          title: "Did you have a clothes dryer (inside dwelling)?"
          input:
            control: Radio
            labels:
              1: "Electric"
              2: "Gas"
              3: "None"
