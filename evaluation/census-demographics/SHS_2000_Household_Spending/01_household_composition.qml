qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section A: Household Composition"

  codeInit: |
    # Routing variables for household composition logic
    one_person_hh = 0
    total_weeks = 0
    data_code = 0

  blocks:
    # =========================================================================
    # BLOCK: HOUSEHOLD COMPOSITION ROSTER
    # =========================================================================
    # Section A asks Q1-Q12 for each household member (up to 10 persons).
    # QML cannot model dynamic loops, so this file represents the structure
    # for ONE representative person. In a real deployment, this block would
    # repeat for each household member up to Person 10.
    # Person 01 is pre-coded as the household reference person (A_Q02=1).
    # =========================================================================
    - id: b_household_composition
      title: "Household Composition"
      items:
        # A_Q01: Roster instruction
        - id: q_a_q01
          kind: Comment
          title: "What are the first names of all members of your household? Include everyone who currently lives here and anyone who was part of your household at any time during 2000. List the household reference person first. (This roster repeats for up to 10 persons.)"

        # A_Q02: Relationship to reference person
        - id: q_a_q02
          kind: Question
          title: "What is this person's relationship to the household reference person?"
          input:
            control: Radio
            labels:
              1: "Reference Person"
              2: "Spouse"
              3: "Son/Daughter"
              4: "Other relative"
              5: "Not related"

        # A_Q03: Birth year
        - id: q_a_q03
          kind: Question
          title: "In what year was this person born? (If born in 1900 or earlier, enter 1900)"
          input:
            control: Editbox
            min: 1900
            max: 2001

        # A_Q04: Sex
        - id: q_a_q04
          kind: Question
          title: "Is this person male or female?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # A_Q05: Marital status on December 31, 2000
        - id: q_a_q05
          kind: Question
          title: "What was this person's marital status on December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Married spouse of a household member"
              2: "Common-law spouse of a household member"
              3: "Never married (single)"
              4: "Other (separated, divorced or widowed)"

        # A_Q06: Economic family code
        - id: q_a_q06
          kind: Question
          title: "Economic Family Code (at time of interview or last day the person was a member of the household). Enter a letter code."
          input:
            control: Textarea
            placeholder: "Enter economic family code..."

        # A_Q07: Member on December 31, 2000
        - id: q_a_q07
          kind: Question
          title: "Was this person a member of this household on December 31, 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A_Q08: Member today
        - id: q_a_q08
          kind: Question
          title: "Is this person a member of this household today?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A_Q09: Weeks as member in 2000
        # Routing: if one-person household -> Q11; if Q09=52 -> Q12; else -> Q10
        - id: q_a_q09
          kind: Question
          title: "For how many weeks in 2000 was this person a member of this household?"
          input:
            control: Editbox
            min: 0
            max: 52
          codeBlock: |
            total_weeks = q_a_q09.outcome

        # A_Q10: Weeks apart in 2000
        # Precondition: not a one-person household AND Q09 < 52
        - id: q_a_q10
          kind: Question
          title: "For how many weeks in 2000 did this person live apart from this household, either as a one-person household, or in another household that no longer exists elsewhere?"
          precondition:
            - predicate: one_person_hh == 0
            - predicate: q_a_q09.outcome < 52
          input:
            control: Editbox
            min: 0
            max: 52
          codeBlock: |
            total_weeks = q_a_q09.outcome + q_a_q10.outcome

        # A_Q11: Why total weeks < 52
        # Precondition: total_weeks < 52 AND not skipped by one-person household
        - id: q_a_q11
          kind: Question
          title: "Why is total weeks (Q.9 plus Q.10) less than 52?"
          precondition:
            - predicate: total_weeks < 52
          input:
            control: Radio
            labels:
              1: "Child born in 2000 or 2001"
              2: "Immigrated in 2000 or 2001"
              3: "Belonged to a household in existence elsewhere"
              4: "Other - Explain in notes"

        # A_Q12: Data collection code
        # Derived from Q08, Q09, Q10
        - id: q_a_q12
          kind: Question
          title: "Use questions 8, 9 and 10 to determine the data collection code and the procedure to follow for each person."
          input:
            control: Radio
            labels:
              1: "Report data for total weeks (Q8=Yes, Q9 not 00)"
              2: "Report data for weeks in this household only (Q8=No, Q9 not 00)"
              3: "Report data for weeks apart only (Q8=Yes, Q9=00, Q10 not 00)"
              4: "End questions - member after 2000 (Q8=Yes, Q9=00, Q10=00)"
              5: "End questions - not a member (Q8=No, Q9=00, Q10=00)"
