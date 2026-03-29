qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Military Service (Person Q27-Q29)"

  codeInit: |
    person_age: range(0, 120)

  blocks:
    # ── Military Service (Q27-Q29) — age >= 15 ──
    - id: b_military
      title: "Military Service"
      precondition:
        - predicate: "person_age >= 15"
      items:
        # P_Q27: Military service status
        - id: q_p_q27
          kind: Question
          title: "Has this person ever served on active duty in the U.S. Armed Forces, Reserves, or National Guard?"
          input:
            control: Radio
            labels:
              1: "Never served in the military"
              2: "Only on active duty for training in the Reserves or National Guard"
              3: "Now on active duty"
              4: "On active duty in the past, but not now"

        # P_Q28: Service periods — Checkbox with power-of-2 keys
        - id: q_p_q28
          kind: Question
          title: "When did this person serve on active duty in the U.S. Armed Forces? Mark all that apply."
          precondition:
            - predicate: "q_p_q27.outcome in [3, 4]"
          input:
            control: Checkbox
            labels:
              1: "September 2001 or later"
              2: "August 1990 to August 2001 (including Persian Gulf War)"
              4: "June 1975 to July 1990"
              8: "August 1964 to May 1975 (including Vietnam era)"
              16: "February 1955 to July 1964"
              32: "June 1950 to January 1955 (including Korean War)"
              64: "January 1947 to May 1950"
              128: "December 1941 to December 1946 (including World War II)"
              256: "November 1941 or earlier"

        # P_Q29a: VA disability rating
        - id: q_p_q29a
          kind: Question
          title: "Does this person have a VA service-connected disability rating?"
          precondition:
            - predicate: "q_p_q27.outcome in [2, 3, 4]"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # P_Q29b: Disability rating percentage
        - id: q_p_q29b
          kind: Question
          title: "What is this person's service-connected disability rating?"
          precondition:
            - predicate: "q_p_q29a.outcome == 1"
          input:
            control: Radio
            labels:
              1: "0 percent"
              2: "10 or 20 percent"
              3: "30 or 40 percent"
              4: "50 or 60 percent"
              5: "70 percent or higher"
