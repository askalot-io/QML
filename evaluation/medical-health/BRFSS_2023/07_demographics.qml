qmlVersion: "1.0"

questionnaire:
  title: "BRFSS 2023 - Core Section 8: Demographics"

  codeInit: |
    sex_at_birth: {1, 2}
    interview_mode: {1, 2}

  blocks:
    - id: b_demographics
      title: "Demographics"
      items:
        # CDEM.01: Age in years
        - id: q_cdem_01
          kind: Question
          title: "What is your age?"
          input:
            control: Editbox
            min: 18
            max: 99

        # CDEM.02: Hispanic/Latino origin — multi-select
        - id: q_cdem_02
          kind: Question
          title: "Are you Hispanic, Latino/a, or Spanish origin? (Select all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Mexican, Mexican American, Chicano/a"
              2: "Puerto Rican"
              4: "Cuban"
              8: "Another Hispanic, Latino/a, or Spanish origin"
              16: "No"

        # CDEM.03: Race — multi-select (simplified to main categories)
        - id: q_cdem_03
          kind: Question
          title: "Which one or more of the following would you say is your race? (Select all that apply)"
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African American"
              4: "American Indian or Alaska Native"
              8: "Asian"
              16: "Pacific Islander"
              32: "Other"

        # CDEM.04: Marital status — 6 options → Dropdown
        - id: q_cdem_04
          kind: Question
          title: "Are you...?"
          input:
            control: Dropdown
            labels:
              1: "Married"
              2: "Divorced"
              3: "Widowed"
              4: "Separated"
              5: "Never married"
              6: "Member of an unmarried couple"

        # CDEM.05: Education level — 6 options → Dropdown
        - id: q_cdem_05
          kind: Question
          title: "What is the highest grade or year of school you completed?"
          input:
            control: Dropdown
            labels:
              1: "Never attended school or only attended kindergarten"
              2: "Grades 1 through 8 (Elementary)"
              3: "Grades 9 through 11 (Some high school)"
              4: "Grade 12 or GED (High school graduate)"
              5: "College 1 year to 3 years (Some college or technical school)"
              6: "College 4 years or more (College graduate)"

        # CDEM.06: Home ownership — 3 options → Radio
        - id: q_cdem_06
          kind: Question
          title: "Do you own or rent your home?"
          input:
            control: Radio
            labels:
              1: "Own"
              2: "Rent"
              3: "Other arrangement"

        # CDEM.07: County ANSI code
        - id: q_cdem_07
          kind: Question
          title: "In what county do you currently live?"
          input:
            control: Editbox
            min: 1
            max: 999

        # CDEM.08: ZIP code
        - id: q_cdem_08
          kind: Question
          title: "What is the ZIP Code where you currently live?"
          input:
            control: Editbox
            min: 1
            max: 99999

        # CDEM.09: Multiple landline numbers — landline interviews only
        - id: q_cdem_09
          kind: Question
          title: "Not including cell phones or numbers used for computers, fax machines, or security systems, do you have more than one landline telephone number in your household?"
          precondition:
            - predicate: "interview_mode == 1"
          input:
            control: Switch

        # CDEM.10: Number of residential landline numbers — only if CDEM.09=Yes
        - id: q_cdem_10
          kind: Question
          title: "How many of these landline telephone numbers are residential numbers?"
          precondition:
            - predicate: "interview_mode == 1"
            - predicate: "q_cdem_09.outcome == 1"
          input:
            control: Editbox
            min: 1
            max: 6

        # CDEM.11: Number of personal cell phones
        - id: q_cdem_11
          kind: Question
          title: "How many cell phones do you have for personal use?"
          input:
            control: Editbox
            min: 0
            max: 6

        # CDEM.12: Military service
        - id: q_cdem_12
          kind: Question
          title: "Have you ever served on active duty in the United States Armed Forces, either in the regular military or in a National Guard or military reserve unit?"
          input:
            control: Switch

        # CDEM.13: Employment status — 8 options → Dropdown
        - id: q_cdem_13
          kind: Question
          title: "Are you currently...?"
          input:
            control: Dropdown
            labels:
              1: "Employed for wages"
              2: "Self-employed"
              3: "Out of work for 1 year or more"
              4: "Out of work for less than 1 year"
              5: "A homemaker"
              6: "A student"
              7: "Retired"
              8: "Unable to work"

        # CDEM.14: Children under 18 in household (88 = none)
        - id: q_cdem_14
          kind: Question
          title: "How many children less than 18 years of age live in your household?"
          input:
            control: Editbox
            min: 0
            max: 88

        # CDEM.15: Annual household income — 11 categories → Dropdown
        - id: q_cdem_15
          kind: Question
          title: "Is your annual household income from all sources—?"
          input:
            control: Dropdown
            labels:
              1: "Less than $10,000"
              2: "$10,000 to less than $15,000"
              3: "$15,000 to less than $20,000"
              4: "$20,000 to less than $25,000"
              5: "$25,000 to less than $35,000"
              6: "$35,000 to less than $50,000"
              7: "$50,000 to less than $75,000"
              8: "$75,000 to less than $100,000"
              9: "$100,000 to less than $150,000"
              10: "$150,000 to less than $200,000"
              11: "$200,000 or more"

        # CDEM.16: Pregnancy — only for females age ≤ 49
        - id: q_cdem_16
          kind: Question
          title: "To your knowledge, are you now pregnant?"
          precondition:
            - predicate: "sex_at_birth == 2 and q_cdem_01.outcome <= 49"
          input:
            control: Switch

        # CDEM.17: Weight in pounds
        - id: q_cdem_17
          kind: Question
          title: "About how much do you weigh without shoes? (pounds)"
          input:
            control: Editbox
            min: 50
            max: 999

        # CDEM.18: Height in inches
        - id: q_cdem_18
          kind: Question
          title: "About how tall are you without shoes? (inches)"
          input:
            control: Editbox
            min: 36
            max: 95
