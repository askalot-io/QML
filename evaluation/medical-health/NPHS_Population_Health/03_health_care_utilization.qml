qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health - Health Care Utilization"
  codeInit: |
    # Extern variable from household section
    age: range(0, 120)

  blocks:
    # =========================================================================
    # BLOCK 1: HEALTH PROFESSIONAL CONTACTS (Q1, Q1a, Q2)
    # =========================================================================
    # UTIL-CINT: IF age < 12, GO TO NEXT SECTION — block-level precondition.
    #
    # UTIL-INT: Interviewer introduction (no response) — modeled as Comment.
    #
    # UTIL-Q1: Overnight hospital patient?
    #   Yes       -> Q1a (nights), then Q2
    #   No        -> GO TO Q2 (skip Q1a)
    #   DK        -> GO TO Q2 (skip Q1a)
    #   R         -> GO TO NEXT SECTION
    #
    # UTIL-Q1a: Number of nights — only if Q1 = Yes (1).
    #
    # UTIL-Q2: QuestionGroup with 10 sub-items (a–j), each Editbox min=0 max=366.
    # =========================================================================
    - id: b_professional_contacts
      title: "Contacts with Health Professionals"
      precondition:
        - predicate: age >= 12
      items:
        # UTIL-INT: Interviewer introduction
        - id: q_util_int
          kind: Comment
          title: "Now I'd like to ask about your/his/her contacts with health professionals during the past 12 months."

        # UTIL-Q1: Overnight hospital patient?
        # No/DK -> skip Q1a, go to Q2
        # R     -> go to next section (modeled: remaining items precondition q_util_q1.outcome != 9)
        - id: q_util_q1
          kind: Question
          title: "In the past 12 months, have/has you/he/she been a patient overnight in a hospital, nursing home or convalescent home?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # UTIL-Q1a: Number of nights — only if Q1 = Yes
        - id: q_util_q1a
          kind: Question
          title: "For how many nights in the past 12 months?"
          precondition:
            - predicate: q_util_q1.outcome != 9
            - predicate: q_util_q1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 366
            right: "nights"

        # UTIL-Q2 (HCC4_2A–HCC4_2J): Times seen/talked with each type of provider.
        # All 10 sub-items share Editbox min=0, max=366.
        # Not counting overnight stays.
        - id: qg_util_q2
          kind: QuestionGroup
          title: "(Not counting when you/he/she were/was an overnight patient) In the past 12 months, how many times have/has you/he/she seen or talked on the telephone with the following about your/his/her physical, emotional or mental health:"
          precondition:
            - predicate: q_util_q1.outcome != 9
          questions:
            - "a) General practitioner or family physician"
            - "b) Eye specialist (ophthalmologist or optometrist)"
            - "c) Other medical doctor (surgeon, allergist, gynaecologist, psychiatrist, etc.)"
            - "d) A nurse for care or advice"
            - "e) Dentist or orthodontist"
            - "f) Chiropractor"
            - "g) Physiotherapist"
            - "h) Social worker or counsellor"
            - "i) Psychologist"
            - "j) Speech, audiology or occupational therapist"
          input:
            control: Editbox
            min: 0
            max: 366
            right: "times"

    # =========================================================================
    # BLOCK 2: LOCATION OF MOST RECENT CONTACT (Q3)
    # =========================================================================
    # UTIL-C2: IF Q2a > 0 OR Q2c > 0 OR Q2d > 0 THEN ask Q3; otherwise skip.
    #
    # UTIL-Q3: Where did the most recent contact take place?
    # =========================================================================
    - id: b_contact_location
      title: "Location of Most Recent Contact"
      precondition:
        - predicate: age >= 12
        - predicate: q_util_q1.outcome != 9
        - predicate: qg_util_q2.outcome[0] > 0 or qg_util_q2.outcome[2] > 0 or qg_util_q2.outcome[3] > 0
      items:
        # UTIL-Q3: Location of most recent contact
        - id: q_util_q3
          kind: Question
          title: "Where did the most recent contact take place?"
          input:
            control: Radio
            labels:
              1: "Walk-in clinic"
              2: "Outpatient clinic in hospital"
              3: "Hospital emergency room"
              4: "Health professional's office"
              5: "Community health centre / CLSC"
              6: "At home"
              7: "Telephone consultation only"
              8: "Other (Specify)"

    # =========================================================================
    # BLOCK 3: ALTERNATIVE HEALTH CARE (Q4, Q5)
    # =========================================================================
    # UTIL-Q4: Used alternative health care provider?
    #   Yes       -> Q5 (who)
    #   No/DK/R   -> GO TO Q6 (skip Q5)
    #
    # UTIL-Q5: Who did they see? (Checkbox, 13 options, powers of 2)
    # =========================================================================
    - id: b_alternative_care
      title: "Alternative Health Care"
      precondition:
        - predicate: age >= 12
        - predicate: q_util_q1.outcome != 9
      items:
        # UTIL-Q4: Alternative health care provider?
        - id: q_util_q4
          kind: Question
          title: "People may also use alternative health care services. In the past 12 months, have/has you/he/she seen or talked to an alternative health care provider such as an acupuncturist, naturopath, homeopath or massage therapist about your/his/her physical, emotional or mental health?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # UTIL-Q5: Who did they see? (only if Q4 = Yes)
        # UTIL-Q4: No/DK/R -> GO TO Q6 (skip Q5) => precondition: Q4 == 1
        - id: q_util_q5
          kind: Question
          title: "Who did you/he/she see or talk to? (Mark all that apply)"
          precondition:
            - predicate: q_util_q4.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Massage therapist"
              2: "Acupuncturist"
              4: "Homeopath or naturopath"
              8: "Feldenkrais or Alexander teacher"
              16: "Relaxation therapist"
              32: "Biofeedback teacher"
              64: "Rolfer"
              128: "Herbalist"
              256: "Reflexologist"
              512: "Spiritual healer"
              1024: "Religious healer"
              2048: "Self-help group (AA, cancer therapy, etc.)"
              4096: "Other (Specify)"

    # =========================================================================
    # BLOCK 4: UNMET HEALTH CARE NEEDS (Q6, Q7, Q8)
    # =========================================================================
    # UTIL-Q6: Needed health care but did not receive it?
    #   Yes       -> Q7, Q8
    #   No/DK/R   -> GO TO UTIL-C9 (skip Q7, Q8)
    #
    # UTIL-Q7: Why not get care? (Radio, coded + open text)
    # UTIL-Q8: Type of care needed? (Checkbox, 5 options, powers of 2)
    # =========================================================================
    - id: b_unmet_needs
      title: "Unmet Health Care Needs"
      precondition:
        - predicate: age >= 12
        - predicate: q_util_q1.outcome != 9
      items:
        # UTIL-Q6: Unmet health care need?
        - id: q_util_q6
          kind: Question
          title: "During the past 12 months, was there ever a time when you/he/she needed health care or advice but did not receive it?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # UTIL-Q7: Reason for not getting care (only if Q6 = Yes)
        # UTIL-Q6: No/DK/R -> GO TO C9 (skip Q7, Q8)
        - id: q_util_q7
          kind: Question
          title: "Thinking of the most recent time, why did you/he/she not get care?"
          precondition:
            - predicate: q_util_q6.outcome == 1
          input:
            control: Radio
            labels:
              1: "Difficulty getting access to health professional"
              2: "Financial constraints"
              3: "Felt health care provided inadequate"
              4: "Chose not to see health professional"
              5: "Other"

        # UTIL-Q8: Type of care needed (only if Q6 = Yes)
        - id: q_util_q8
          kind: Question
          title: "Again, thinking of the most recent time, what was the type of care that was needed? (Mark all that apply)"
          precondition:
            - predicate: q_util_q6.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Treatment of a physical health problem"
              2: "Treatment of an emotional or mental health problem"
              4: "A regular check-up (or for regular pre-natal care)"
              8: "Care of an injury"
              16: "Any other reason (Specify)"

    # =========================================================================
    # BLOCK 5: HOME CARE SERVICES (Q9, Q10)
    # =========================================================================
    # UTIL-C9: IF age < 18 THEN GO TO NEXT SECTION.
    # Q9 and Q10 have additional precondition: age >= 18.
    #
    # UTIL-Q9: Received home care services in past 12 months?
    #   Yes       -> Q10 (types)
    #   No/DK/R   -> GO TO NEXT SECTION (skip Q10)
    #
    # UTIL-Q10: What type of home care services? (Checkbox, 7 options, powers of 2)
    # =========================================================================
    - id: b_home_care
      title: "Home Care Services"
      precondition:
        - predicate: age >= 12
        - predicate: age >= 18
        - predicate: q_util_q1.outcome != 9
      items:
        # UTIL-Q9: Home care services?
        - id: q_util_q9
          kind: Question
          title: "Home care services are health care or homemaker services received at home, with the cost being entirely or partially covered by government. Examples are: nursing care; help with bathing; help around the home; physiotherapy; counselling; and meal delivery. Have/Has you/he/she received any home care services in the past 12 months?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # UTIL-Q10: Type of home care services (only if Q9 = Yes)
        # UTIL-Q9: No/DK/R -> GO TO NEXT SECTION (skip Q10)
        - id: q_util_q10
          kind: Question
          title: "What type of services have/has you/he/she received? (Mark all that apply)"
          precondition:
            - predicate: q_util_q9.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Nursing care"
              2: "Personal care"
              4: "Housework"
              8: "Meal preparation"
              16: "Shopping"
              32: "Other"
