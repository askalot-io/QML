qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Section A: Social Mobility (Respondent)"
  codeInit: |
    # No cross-section variables needed for Section A

  blocks:
    # =========================================================================
    # BLOCK: SOCIAL MOBILITY - RESPONDENT
    # =========================================================================
    # A1: Country of birth (Canada with province, or outside Canada)
    # A2: Immigration year (if born outside Canada)
    # A3: Date of birth (day, month, year as separate Editboxes)
    # A4: Same community from birth to age 15?
    # A5: Number of communities (if A4=No)
    # A6: Years in longest community (if A4=No)
    # A7: Community size (if A4=Yes or No, not DK)
    # A8: Community location (Canada or elsewhere)
    # =========================================================================
    - id: b_social_mobility_respondent
      title: "Social Mobility (Respondent)"
      items:
        # A1: Country of birth
        # Original: If Canada (01), show province sub-question {02-13};
        # if province selected -> GO TO A3; if 14 -> GO TO A2.
        # Modeled as single Dropdown with all provinces + outside Canada.
        # Selecting a province (2-13) implies born in Canada.
        # Selecting 1 = born in Canada (province unspecified).
        # Selecting 14 = born outside Canada -> A2 immigration year.
        - id: q_a1
          kind: Question
          title: "In what country were you born? (If born in Canada, select the province.)"
          input:
            control: Dropdown
            labels:
              1: "Canada (province not specified)"
              2: "Newfoundland"
              3: "Prince Edward Island"
              4: "Nova Scotia"
              5: "New Brunswick"
              6: "Quebec"
              7: "Ontario"
              8: "Manitoba"
              9: "Saskatchewan"
              10: "Alberta"
              11: "British Columbia"
              12: "Yukon Territory"
              13: "Northwest Territories"
              14: "Country outside Canada"

        # A1_SPECIFY: Specify country (if born outside Canada)
        - id: q_a1_specify
          kind: Question
          title: "Please specify the country."
          precondition:
            - predicate: q_a1.outcome == 14
          input:
            control: Textarea
            placeholder: "Enter country name..."

        # A2: Immigration year (if born outside Canada)
        # Original: Numeric year; also includes "Canadian citizen by birth" option.
        # Precondition: A1 == 14 (born outside Canada).
        - id: q_a2
          kind: Question
          title: "In what year did you first immigrate to Canada?"
          precondition:
            - predicate: q_a1.outcome == 14
          input:
            control: Editbox
            min: 1800
            max: 1986
            right: "year"

        # A3: Date of birth -- modeled as 3 separate Editboxes
        # A3_DAY
        - id: q_a3_day
          kind: Question
          title: "What is your date of birth? (Day)"
          input:
            control: Editbox
            min: 1
            max: 31
            left: "Day:"

        # A3_MONTH
        - id: q_a3_month
          kind: Question
          title: "What is your date of birth? (Month)"
          input:
            control: Editbox
            min: 1
            max: 12
            left: "Month:"

        # A3_YEAR
        - id: q_a3_year
          kind: Question
          title: "What is your date of birth? (Year)"
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # A4: Same community from birth to age 15?
        # 1 (Yes) -> GO TO A7; 2 (No) -> GO TO A5; 3 (DK) -> GO TO SECTION B
        - id: q_a4
          kind: Question
          title: "Did you live in the same community from birth up to age 15? By community I mean city, town or rural area."
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        # A5: Number of communities lived in (if A4=No)
        # Original: 98 = Don't know -> GO TO SECTION B.
        # Modeled with range 1-98 (98 for DK).
        # Precondition: A4 == 2 (No)
        - id: q_a5
          kind: Question
          title: "In how many different communities did you live during this time?"
          precondition:
            - predicate: q_a4.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 98
            left: "Communities:"
          postcondition:
            - predicate: q_a5.outcome >= 1
              hint: "Please enter the number of communities (1-97) or 98 for Don't know."

        # A6: Years in longest community (if A4=No and A5 is not DK)
        # Precondition: A4 == 2 and A5 != 98 (not DK)
        - id: q_a6
          kind: Question
          title: "Think about the community you lived in for the longest time from when you were born until you were 15 years old. For how many of those 15 years did you live there?"
          precondition:
            - predicate: q_a4.outcome == 2
            - predicate: q_a5.outcome != 98
          input:
            control: Editbox
            min: 0
            max: 15
            right: "years"

        # A7: Community size
        # Precondition: A4 in [1, 2] (Yes or No; not DK=3)
        - id: q_a7
          kind: Question
          title: "What was the approximate size of that community?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              1: "Less than 5,000 population or a rural area"
              2: "5,000 to less than 25,000 population"
              3: "25,000 to less than 100,000 population"
              4: "100,000 to 1 million population"
              5: "Over 1 million population"

        # A8: Was community in Canada or elsewhere?
        # Precondition: same as A7
        - id: q_a8
          kind: Question
          title: "Was this place in Canada or elsewhere?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
          input:
            control: Radio
            labels:
              1: "In Canada"
              2: "Elsewhere"

        # A8_TOWN: Town name (if in Canada)
        - id: q_a8_town
          kind: Question
          title: "What was the name of that town or nearest town?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
            - predicate: q_a8.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter town name..."

        # A8_PROVINCE: Province (if in Canada)
        - id: q_a8_province
          kind: Question
          title: "In which province?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
            - predicate: q_a8.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter province..."

        # A8_COUNTRY: Country (if elsewhere)
        - id: q_a8_country
          kind: Question
          title: "Which country?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
            - predicate: q_a8.outcome == 2
          input:
            control: Textarea
            placeholder: "Enter country name..."
