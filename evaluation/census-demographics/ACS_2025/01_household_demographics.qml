qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Household Demographics & Person Roster"

  codeInit: |
    person_count = 0
    person_age = 0
    person_sex = 0

  blocks:
    - id: b_household
      title: "Cover & Household"
      items:
        # COVER_CONTACT: Administrative contact info
        - id: q_cover_contact
          kind: Comment
          title: "Please print the name and telephone number of the person who is filling out this form."

        # COVER_COUNT: Household size
        - id: q_cover_count
          kind: Question
          title: "How many people, including yourself, live or stay at this address?"
          input:
            control: Editbox
            min: 1
            max: 12
          codeBlock: |
            person_count = q_cover_count.outcome

    - id: b_person_roster
      title: "Person Roster"
      items:
        # P_Q1: Person name (administrative text field — modeled as Comment)
        - id: q_p1_name
          kind: Comment
          title: "What is this person's name? (Last name, First name, MI)"

        # P_Q2: Relationship to Person 1 (for Person 2+; Person 1 is self-identified)
        - id: q_p2_relationship
          kind: Question
          title: "How is this person related to Person 1?"
          input:
            control: Dropdown
            labels:
              1: "Opposite-sex husband/wife/spouse"
              2: "Opposite-sex unmarried partner"
              3: "Same-sex husband/wife/spouse"
              4: "Same-sex unmarried partner"
              5: "Biological son or daughter"
              6: "Adopted son or daughter"
              7: "Stepson or stepdaughter"
              8: "Brother or sister"
              9: "Father or mother"
              10: "Grandchild"
              11: "Parent-in-law"
              12: "Son-in-law or daughter-in-law"
              13: "Other relative"
              14: "Roommate or housemate"
              15: "Foster child"
              16: "Other nonrelative"

        # P_Q3: Sex
        - id: q_p3_sex
          kind: Question
          title: "What is this person's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"
          codeBlock: |
            person_sex = q_p3_sex.outcome

        # P_Q4: Age
        - id: q_p4_age
          kind: Question
          title: "What is this person's age and what is this person's date of birth?"
          input:
            control: Editbox
            min: 0
            max: 120
          codeBlock: |
            person_age = q_p4_age.outcome

        # P_Q5: Hispanic origin
        - id: q_p5_hispanic
          kind: Question
          title: "Is this person of Hispanic, Latino, or Spanish origin?"
          input:
            control: Radio
            labels:
              0: "No, not of Hispanic, Latino, or Spanish origin"
              1: "Yes, Mexican, Mexican Am., Chicano"
              2: "Yes, Puerto Rican"
              3: "Yes, Cuban"
              4: "Yes, another Hispanic, Latino, or Spanish origin"

        # P_Q5 follow-up: Specify other Hispanic origin
        - id: q_p5_hispanic_specify
          kind: Question
          title: "Please print origin, for example, Salvadoran, Dominican, Colombian, Guatemalan, Spaniard, Ecuadorian, etc."
          precondition:
            - predicate: "q_p5_hispanic.outcome == 4"
          input:
            control: Textarea
            placeholder: "Specify origin"

        # P_Q6: Race (multi-select with power-of-2 keys)
        - id: q_p6_race
          kind: Question
          title: "What is this person's race? Mark one or more boxes AND print origins."
          input:
            control: Checkbox
            labels:
              1: "White"
              2: "Black or African Am."
              4: "American Indian or Alaska Native"
              8: "Chinese"
              16: "Filipino"
              32: "Asian Indian"
              64: "Other Asian"
              128: "Vietnamese"
              256: "Korean"
              512: "Japanese"
              1024: "Native Hawaiian"
              2048: "Samoan"
              4096: "Chamorro"
              8192: "Other Pacific Islander"
              16384: "Some other race"
