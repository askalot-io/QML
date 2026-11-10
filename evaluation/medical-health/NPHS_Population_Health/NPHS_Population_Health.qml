qmlVersion: '2.7'
questionnaire:
  title: National Population Health Survey Content For Main Survey
  blocks:
  - id: b_s1_preamble
    title: Household Record Setup
    items:
    - id: DHC4_AGE
      kind: Question
      title: Age of the person, calculated from the date of birth in DEMO_Q4 and confirmed with the respondent (variable DHC4_AGE); read by the age gates (age<12, age<15, age<18)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s1_roster
    title: Household Roster
    items:
    - id: DEMO_Q1
      kind: Question
      title: What are the names of all persons now living or staying here who have no usual place of residence elsewhere? (First and last names )
      input:
        control: Textarea
    - id: DEMO_Q2
      kind: Question
      title: Are there any persons away from this household attending school, visiting, travelling or in hospital who usually live here?
      input:
        control: Radio
        labels:
          1: Yes (go to DEMO-Q1)
          2: 'No'
    - id: DEMO_Q3
      kind: Question
      title: Does anyone else live at this dwelling such as young children, relatives, roomers, boarders or employees?
      input:
        control: Radio
        labels:
          1: Yes (go to DEMO-Q1)
          2: 'No'
    - id: DEMO_Q4
      kind: Question
      title: What is ... 's date of birth? DD/MM/YY (Age is calculated and confirmed with respondent.)
      input:
        control: Textarea
    - id: DEMO_Q5
      kind: Question
      title: Enter or ask ... 's sex.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: DEMO_Q6
      kind: Question
      title: 'What is ... current marital status? (Note: if age < 15, marital status is automatically = single)'
      postcondition:
      - predicate: not (DHC4_AGE.outcome < 15) or DEMO_Q6.outcome == 4
        hint: Marital status (DEMO_Q6) must be Single (never married) when the age (DHC4_AGE) is under 15.
        invented: true
      input:
        control: Radio
        labels:
          1: Now married
          2: Common-law
          3: Living with a partner
          4: Single (never married)
          5: Widowed
          6: Separated
          7: Divorced
    - id: DEMO_Q7
      kind: Question
      title: Enter ... 's family Id code. (A to Z)
      input:
        control: Textarea
    - id: DEMO_Q8
      kind: Question
      title: Relationships of everyone to everyone else
      input:
        control: Dropdown
        labels:
          1: Birth Parent
          2: Step Parent
          3: Foster Parent
          4: Birth Child
          5: Step Child
          6: Foster Child
          7: Sister/brother
          8: Grandparent
          9: Grandchild
          10: Common law partner
          11: In-law
          12: Other Related
          13: Unrelated
          14: Husband/Wife
          15: Adopted Child
          16: Adoptive Parent
          17: Same-sex Partner
  - id: b_s1_dwelling
    title: Dwelling
    items:
    - id: HHLD_Q1
      kind: Question
      title: Now a few questions about your dwelling. Is this dwelling owned by a member of this household (even if being paid for)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: HHLD_Q3
      kind: Question
      title: How many bedrooms are there in this dwelling? (If no separate, enclosed bedroom enter "00".)
      input:
        control: Editbox
        min: 0
        max: 99
    - id: HHLD_Q4
      kind: Question
      title: Is there a pet in this household?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to HHLD-Q6)
  - id: b_s1_pets
    title: Pets
    precondition:
    - predicate: not (HHLD_Q4.outcome == 2)
      hint: Asked only when question HHLD_Q4 is not "No (Go to HHLD-Q6)".
    items:
    - id: HHLD_Q5
      kind: Question
      title: What kind of pet? (Do not read list. Mark all that apply)
      input:
        control: Checkbox
        labels:
          1: Dog
          2: Cat
          4: Other (Go to HHLD-Q6)
    - id: HHLD_Q5a
      kind: Question
      title: Does this pet or do any of these pets live mainly indoors?
      precondition:
      - predicate: not (HHLD_Q5.outcome & 4 > 0)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s1_interview
    title: Dwelling Type and Interview Record
    items:
    - id: HHLD_Q6
      kind: Question
      title: Record type of dwelling (by interviewer observation)
      input:
        control: Dropdown
        labels:
          1: Single detached house
          2: Semi-detached or double (side-by-side)
          3: Garden house, town-house or row house
          4: Duplex (one above the other)
          5: Low-rise apartment (less than 5 stories)
          6: High-rise apartment (5 or more stories)
          7: Institution
          8: Hotel, rooming or lodging house, logging or construction camp, Hutterite Colony
          9: Mobile home
          10: Other (Specify _____________)
    - id: HHLD_Q7
      kind: Question
      title: Information Source Indicator i.e. who is providing the information
      input:
        control: Textarea
    - id: HHLD_Q8
      kind: Question
      title: Record language of interview
      input:
        control: Dropdown
        labels:
          1: English
          2: French
          3: Arabic
          4: Chinese
          5: Cree
          6: German
          7: Greek
          8: Hungarian
          9: Italian
          10: Korean
          11: Persian (Farsi)
          12: Polish
          13: Portuguese
          14: Punjabi
          15: Spanish
          16: Tagalog (Filipino)
          17: Ukrainian
          18: Vietnamese
          19: Other (Specify_________)
  - id: b_s2_intro
    title: Two-Week Disability
    items:
    - id: H05_P1
      kind: Question
      title: Who is providing the information for this person's form?
      input:
        control: Textarea
    - id: TWOWK_Q1
      kind: Question
      title: It is important for you to refer to the 14-day period from %2WKSAGO% to %YESTERDAY%. During that period, did ... stay in bed at all because of illness or injury including any nights spent as a patient in a hospital?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to TWOWK-Q3)
          97: DK (Go to TWOWK-Q5)
          98: R (Go to TWOWK-Q5)
    - id: TWOWK_Q2
      kind: Question
      title: How many days did ... stay in bed for all or most of the day? (Enter <0> if less than a day.) (If = 14 days go to TWOWK-Q5)
      precondition:
      - predicate: not (TWOWK_Q1.outcome == 2)
        hint: Asked only when question TWOWK-Q1 is not "No (Go to TWOWK-Q3)".
      - predicate: not (TWOWK_Q1.outcome in [97, 98])
        hint: Asked only when question TWOWK-Q1 is none of "DK (Go to TWOWK-Q5)", "R (Go to TWOWK-Q5)".
      input:
        control: Editbox
        min: -8
        max: 14
        right: days (-7 = DK, -8 = R)
  - id: b_s2_cutdown
    title: Days of Reduced Activity
    precondition:
    - predicate: not (TWOWK_Q1.outcome in [97, 98])
      hint: Asked only when question TWOWK-Q1 is none of "DK (Go to TWOWK-Q5)", "R (Go to TWOWK-Q5)".
    - predicate: not (TWOWK_Q2.outcome == 14)
      hint: Asked only when question TWOWK-Q2 is not 14.
    - predicate: not (TWOWK_Q2.outcome in [-7, -8])
      hint: Asked only when question TWOWK-Q2 is none of "DK (Go to TWOWK-Q5)", "R (Go to TWOWK-Q5)".
    items:
    - id: TWOWK_Q3
      kind: Question
      title: (Not counting days spent in bed) During those 14 days, were there any days that ... cut down on things you/he/she normally do/does because of illness or injury?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to TWOWK-Q5)
          97: DK (Go to TWOWK-Q5)
          98: R (Go to TWOWK-Q5)
    - id: TWOWK_Q4
      kind: Question
      title: How many days did ... cut down on things for all or most of the day? (Enter <0> if less than a day.)
      precondition:
      - predicate: not (TWOWK_Q3.outcome in [2, 97, 98])
        hint: Asked only when question TWOWK-Q3 is none of "No (Go to TWOWK-Q5)", "DK (Go to TWOWK-Q5)", "R (Go to TWOWK-Q5)".
      postcondition:
      - predicate: TWOWK_Q2.outcome < 0 or TWOWK_Q4.outcome < 0 or TWOWK_Q2.outcome + TWOWK_Q4.outcome <= 14
        hint: Days in bed (TWOWK-Q2) plus days of cutting down on activities (TWOWK-Q4) cannot exceed 14. Please correct TWOWK-Q2 or TWOWK-Q4.
        invented: true
      input:
        control: Editbox
        min: -8
        max: 14
        right: days (-7 = DK, -8 = R)
  - id: b_s2_doctor
    title: Regular Doctor
    items:
    - id: TWOWK_Q5
      kind: Question
      title: Do(es) ... have a regular medical doctor?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
  - id: b_s3_hospital
    title: Health Care Utilization
    precondition:
    - predicate: not (DHC4_AGE.outcome < 12)
      hint: Asked of respondents aged 12 or over
    items:
    - id: UTIL_Q1
      kind: Question
      title: In the past 12 months, have/has ... been a patient overnight in a hospital, nursing home or convalescent home?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to UTIL-Q2)
          97: DK (Go to UTIL-Q2)
          98: R (Go to next section)
    - id: UTIL_Q1a
      kind: Question
      title: For how many nights in the past 12 months?
      precondition:
      - predicate: not (UTIL_Q1.outcome in [2, 97])
        hint: Asked only when question UTIL-Q1 is none of No or DK.
      - predicate: not (UTIL_Q1.outcome == 98)
        hint: Asked only when question UTIL-Q1 is not R.
      input:
        control: Editbox
        min: 0
        max: 366
        right: nights
  - id: b_s3_contacts
    title: Contacts with health professionals
    precondition:
    - predicate: not (DHC4_AGE.outcome < 12)
      hint: Asked of respondents aged 12 or over
    - predicate: not (UTIL_Q1.outcome == 98)
      hint: Asked only when question UTIL-Q1 is not R (Go to next section).
    items:
    - id: UTIL_Q2a
      kind: Question
      title: '(Not counting when ... were/was an overnight patient) In the past 12 months, how many times have/has ... seen or talked on the telephone with [fill category] about your/his/her physical, emotional or mental health: a) General practitioner or family physician'
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2b
      kind: Question
      title: b) Eye specialist (such as an ophthalmologist or optometrist)
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2c
      kind: Question
      title: c) Other medical doctor (such as surgeon, allergist, gynaecologist, psychiatrist, etc.)
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2d
      kind: Question
      title: d) A nurse for care or advice
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2e
      kind: Question
      title: e) Dentist or orthodontist
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2f
      kind: Question
      title: f) Chiropractor
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2g
      kind: Question
      title: g) Physiotherapist
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2h
      kind: Question
      title: h) Social worker or counsellor
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2i
      kind: Question
      title: i) Psychologist
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q2j
      kind: Question
      title: j) Speech, audiology or occupational therapist
      input:
        control: Editbox
        min: 0
        max: 365
        right: times
    - id: UTIL_Q3
      kind: Question
      title: Where did the most recent contact take place? (Read list. Mark one only.)
      precondition:
      - predicate: UTIL_Q2a.outcome > 0 or UTIL_Q2c.outcome > 0 or UTIL_Q2d.outcome > 0
        hint: Asked only when a general practitioner, other medical doctor or nurse was seen in the past 12 months.
      input:
        control: Dropdown
        labels:
          1: Walk-in clinic
          2: Outpatient clinic in hospital
          3: Hospital emergency room
          4: Health professional's office
          5: Community health centre /CLSC
          6: At home
          7: Telephone consultation only
          8: Other (Specify_____________)
          97: DK
          98: R
    - id: UTIL_Q4
      kind: Question
      title: People may also use alternative health care services. In the past 12 months, have/has ... seen or talked to an alternative health care provider such as an acupuncturist, naturopath, homeopath or massage therapist about your/his/her physical, emotional or mental health?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to UTIL-Q6)
          97: DK (Go to UTIL-Q6)
          98: R (Go to UTIL-Q6)
    - id: UTIL_Q5
      kind: Question
      title: Who did ... see or talk to? (Do not read list. Mark all that apply.)
      precondition:
      - predicate: not (UTIL_Q4.outcome in [2, 97, 98])
        hint: Asked only when question UTIL-Q4 is none of No, DK or R.
      input:
        control: Checkbox
        labels:
          1: Massage therapist
          2: Acupuncturist
          4: Homeopath or naturopath
          8: Feldenkrais or Alexander teacher
          16: Relaxation therapist
          32: Biofeedback teacher
          64: Rolfer
          128: Herbalist
          256: Reflexologist
          512: Spiritual healer
          1024: Religious healer
          2048: Self help group (such as AA, cancer therapy, etc.)
          4096: Other (Specify _____________________)
    - id: UTIL_Q6
      kind: Question
      title: During the past 12 months, was there ever a time when you/he/she needed health care or advice but did not receive it?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to UTIL-C9)
          97: DK (Go to UTIL-C9)
          98: R (Go to UTIL-C9)
  - id: b_s3_unmet_need
    title: Unmet health care needs
    precondition:
    - predicate: not (DHC4_AGE.outcome < 12)
      hint: Asked of respondents aged 12 or over
    - predicate: not (UTIL_Q1.outcome == 98)
      hint: Asked only when question UTIL-Q1 is not R (Go to next section).
    - predicate: not (UTIL_Q6.outcome in [2, 97, 98] and DHC4_AGE.outcome >= 18)
      hint: Adults who did not report an unmet need skip this.
    - predicate: not (UTIL_Q6.outcome in [2, 97, 98] and DHC4_AGE.outcome < 18)
      hint: Minors who did not report an unmet need skip this.
    items:
    - id: UTIL_Q7
      kind: Question
      title: Thinking of the most recent time, why did ... not get care?
      input:
        control: Radio
        labels:
          1: Difficulty getting access to health professional
          2: Financial constraints
          3: Felt health care provided inadequate
          4: Chose not to see health professional
          5: Other
          97: DK
          98: R
    - id: UTIL_Q8
      kind: Question
      title: Again, thinking of the most recent time, what was the type of care that was needed? (Do not read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: Treatment of a physical health problem
          2: Treatment of an emotional or mental health problem
          4: A regular check-up (or for regular pre-natal care)
          8: Care of an injury
          16: Any other reason (Specify______________)
  - id: b_s3_home_care
    title: Home care
    precondition:
    - predicate: not (DHC4_AGE.outcome < 12)
      hint: Asked of respondents aged 12 or over
    - predicate: not (UTIL_Q1.outcome == 98)
      hint: Asked only when question UTIL-Q1 is not R (Go to next section).
    - predicate: not (UTIL_Q6.outcome in [2, 97, 98] and DHC4_AGE.outcome < 18)
      hint: Minors who did not report an unmet need skip this.
    - predicate: not (DHC4_AGE.outcome < 18)
      hint: Asked of respondents aged 18 or over
    items:
    - id: UTIL_Q9
      kind: Question
      title: 'Home care services are health care or homemaker services received at home, with the cost being entirely or partially covered by government. Examples are: nursing care; help with bathing; help around the home; physiotherapy; counselling; and meal delivery. Have/Has ... received any home care services in the past 12 months?'
      precondition:
      - predicate: DHC4_AGE.outcome >= 18
        hint: Asked of respondents aged 18 or over
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          97: DK (Go to next section)
          98: R (Go to next section)
    - id: UTIL_Q10
      kind: Question
      title: What type of services have/has ... received? (Specify______________________)
      precondition:
      - predicate: not (UTIL_Q9.outcome in [2, 97, 98])
        hint: Asked only when question UTIL-Q9 is none of No, DK or R.
      input:
        control: Checkbox
        labels:
          1: Nursing care
          2: Personal care
          4: Housework
          8: Meal preparation
          16: Shopping
          32: Other
  - id: b_s4_limits
    title: Restriction of Activities
    precondition:
    - predicate: not (DHC4_AGE.outcome < 12)
      hint: Asked of respondents aged 12 or older
    items:
    - id: RESTR_Q1a
      kind: Question
      title: 'Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do: a) at home?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R (Go to next section)
    - id: RESTR_Q1b
      kind: Question
      title: b) at school?
      precondition:
      - predicate: not (RESTR_Q1a.outcome == 98)
        hint: Asked only when question RESTR-Q1a is not "R (Go to next section)".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not applicable
          97: DK
          98: R (Go to next section)
    - id: RESTR_Q1c
      kind: Question
      title: c) at work?
      precondition:
      - predicate: not (RESTR_Q1a.outcome == 98)
        hint: Asked only when question RESTR-Q1a is not "R (Go to next section)".
      - predicate: not (RESTR_Q1b.outcome == 98)
        hint: Asked only when question RESTR-Q1b is not "R (Go to next section)".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not applicable
          97: DK
          98: R (Go to next section)
    - id: RESTR_Q1d
      kind: Question
      title: d) in other activities such as transportation to or from work or leisure time activities?
      precondition:
      - predicate: not (RESTR_Q1a.outcome == 98)
        hint: Asked only when question RESTR-Q1a is not "R (Go to next section)".
      - predicate: not (RESTR_Q1b.outcome == 98)
        hint: Asked only when question RESTR-Q1b is not "R (Go to next section)".
      - predicate: not (RESTR_Q1c.outcome == 98)
        hint: Asked only when question RESTR-Q1c is not "R (Go to next section)".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R (Go to next section)
    - id: RESTR_Q2
      kind: Question
      title: Do(es) ... have any long term disabilities or handicaps?
      precondition:
      - predicate: not (RESTR_Q1a.outcome == 98)
        hint: Asked only when question RESTR-Q1a is not "R (Go to next section)".
      - predicate: not (RESTR_Q1b.outcome == 98)
        hint: Asked only when question RESTR-Q1b is not "R (Go to next section)".
      - predicate: not (RESTR_Q1c.outcome == 98)
        hint: Asked only when question RESTR-Q1c is not "R (Go to next section)".
      - predicate: not (RESTR_Q1d.outcome == 98)
        hint: Asked only when question RESTR-Q1d is not "R (Go to next section)".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R (Go to next section)
  - id: b_s4_followup
    title: Cause of limitation and need for help
    precondition:
    - predicate: not (DHC4_AGE.outcome < 12)
      hint: Asked of respondents aged 12 or older
    - predicate: not (RESTR_Q1a.outcome == 98)
      hint: Asked only when question RESTR-Q1a is not "R (Go to next section)".
    - predicate: not (RESTR_Q1b.outcome == 98)
      hint: Asked only when question RESTR-Q1b is not "R (Go to next section)".
    - predicate: not (RESTR_Q1c.outcome == 98)
      hint: Asked only when question RESTR-Q1c is not "R (Go to next section)".
    - predicate: not (RESTR_Q1d.outcome == 98)
      hint: Asked only when question RESTR-Q1d is not "R (Go to next section)".
    - predicate: not (RESTR_Q2.outcome == 98)
      hint: Asked only when question RESTR-Q2 is not "R (Go to next section)".
    items:
    - id: RESTR_Q3
      kind: Question
      title: What is the main condition or health problem causing ... to be limited in your/his/her activities? (25 spaces) (Go to RESTR-Q5)
      precondition:
      - predicate: RESTR_Q1a.outcome == 1 or RESTR_Q1b.outcome == 1 or RESTR_Q1c.outcome == 1 or RESTR_Q1d.outcome == 1
        hint: Asked only when a limitation was reported in RESTR-Q1a to RESTR-Q1d.
      - predicate: not (not (RESTR_Q1a.outcome == 1 or RESTR_Q1b.outcome == 1 or RESTR_Q1c.outcome == 1 or RESTR_Q1d.outcome == 1) and RESTR_Q2.outcome != 1)
        hint: Not asked when neither a limitation nor a long term disability was reported.
      input:
        control: Textarea
        maxLength: 25
    - id: RESTR_Q4
      kind: Question
      title: What is the main condition or health problem causing ... to have a long term disability or handicap? (25 spaces)
      precondition:
      - predicate: RESTR_Q2.outcome == 1 and not (RESTR_Q1a.outcome == 1 or RESTR_Q1b.outcome == 1 or RESTR_Q1c.outcome == 1 or RESTR_Q1d.outcome == 1)
        hint: Asked only for a long term disability without an activity limitation.
      - predicate: not (not (RESTR_Q1a.outcome == 1 or RESTR_Q1b.outcome == 1 or RESTR_Q1c.outcome == 1 or RESTR_Q1d.outcome == 1) and RESTR_Q2.outcome != 1)
        hint: Not asked when neither a limitation nor a long term disability was reported.
      - predicate: not (RESTR_Q1a.outcome == 1 or RESTR_Q1b.outcome == 1 or RESTR_Q1c.outcome == 1 or RESTR_Q1d.outcome == 1)
        hint: Not asked when a limitation was reported (see RESTR-Q3).
      input:
        control: Textarea
        maxLength: 25
    - id: RESTR_Q5
      kind: Question
      title: Which one of the following is the best description of the cause of this condition? (Read list. Mark one only.)
      precondition:
      - predicate: not (not (RESTR_Q1a.outcome == 1 or RESTR_Q1b.outcome == 1 or RESTR_Q1c.outcome == 1 or RESTR_Q1d.outcome == 1) and RESTR_Q2.outcome != 1)
        hint: Not asked when neither a limitation nor a long term disability was reported.
      input:
        control: Dropdown
        labels:
          1: Injury - at home
          2: Injury - sports or recreation
          3: Injury - motor vehicle
          4: Injury - work-related
          5: Existed at birth
          6: Work environment
          7: Disease or illness
          8: Natural aging process
          9: Psychological or physical abuse
          10: Other (Specify____________________)
          97: DK
          98: R
    - id: RESTR_Q6
      kind: Question
      title: 'The next question asks about help received. This may not apply to ... , but we need to ask the same question of everyone. Because of any condition or health problem, do(es) ... need the help of another person in: (Read list. Mark all that apply.)'
      postcondition:
      - predicate: not (RESTR_Q6.outcome & 64 > 0) or RESTR_Q6.outcome == 64
        hint: '"None of the above" in RESTR-Q6 cannot be combined with any other kind of help. Please correct the answer.'
        invented: true
      input:
        control: Checkbox
        labels:
          1: Preparing meals?
          2: Shopping for groceries or other necessities?
          4: Doing normal everyday housework?
          8: Doing heavy household chores such as washing walls, yard work, etc.?
          16: Personal care such as washing, dressing or eating?
          32: Moving about inside the house?
          64: None of the above
  - id: b_s5_chron_list
    title: Chronic Conditions
    precondition:
    - predicate: not (DHC4_AGE.outcome < 12)
      hint: Asked of persons aged 12 and over
    items:
    - id: CHRON_Q1
      kind: Question
      title: 'Do(es) ... have any of the following long-term conditions that have been diagnosed by a health professional: (Read list. Mark all that apply.) (q) Acne requiring prescription medication? (Ask if age<30) For persons aged < 18 years go to (u).'
      input:
        control: Checkbox
        labels:
          1: (a) Food allergies?
          2: (b) Other allergies?
          4: (c) Asthma?(If YES ask CHRON-Q1cc1)
          8: (d) Arthritis or rheumatism?
          16: (e) Back problems excluding arthritis?
          32: (f) High blood pressure?
          64: (g) Migraine headaches?
          128: (h) Chronic bronchitis or emphysema?
          256: (i) Sinusitis?
          512: (j) Diabetes?
          1024: (k) Epilepsy?
          2048: (l) Heart disease?
          4096: (m) Cancer? (If yes ask CHRON-Q1mm)
          8192: (n) Stomach or intestinal ulcers?
          16384: (o) Effects of stroke?
          32768: (p) Urinary incontinence?
          65536: (q) Acne requiring prescription medication? (Ask if age<30)
          131072: (r) Alzheimer's disease or other dementia?
          262144: (s) Cataracts?
          524288: (t) Glaucoma?
          1048576: (u) Any other long term condition? (Specify ______________)
          2097152: (v) None
          4194304: DK (Go to next section)
          8388608: R (Go to next section)
      postcondition:
      - predicate: not (CHRON_Q1.outcome & 2097152 > 0) or CHRON_Q1.outcome == 2097152
        hint: '"None" in CHRON-Q1 cannot be combined with any other condition. Please correct the answer.'
        invented: true
      - predicate: DHC4_AGE.outcome < 30 or not (CHRON_Q1.outcome & 65536 > 0)
        hint: Item (q) acne requiring prescription medication in CHRON-Q1 is asked only if age (DHC4_AGE) is under 30. Please correct the answer.
      - predicate: DHC4_AGE.outcome >= 18 or not (CHRON_Q1.outcome & 917504 > 0)
        hint: Items (r), (s) and (t) in CHRON-Q1 are not asked of persons under 18 (DHC4_AGE). Please correct the answer.
  - id: b_s5_chron_followups
    title: Chronic Conditions Follow-ups
    precondition:
    - predicate: not (DHC4_AGE.outcome < 12)
      hint: Asked of persons aged 12 and over
    - predicate: not (CHRON_Q1.outcome & 4194304 > 0 or CHRON_Q1.outcome & 8388608 > 0)
      hint: Not asked when CHRON-Q1 is Don't know or Refused
    items:
    - id: CHRON_Q1mm
      kind: Question
      title: What type(s) of cancer is this? For example, skin, lung or colon cancer.
      precondition:
      - predicate: CHRON_Q1.outcome & 4096 > 0
        hint: Asked only if cancer was reported in CHRON-Q1
      input:
        control: Textarea
    - id: CHRON_Q1cc1
      kind: Question
      title: Have/Has ... had an attack of asthma in the past 12 months?
      precondition:
      - predicate: CHRON_Q1.outcome & 4 > 0
        hint: Asked only if asthma was reported in CHRON-Q1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
    - id: CHRON_Q1cc2
      kind: Question
      title: Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
  - id: b_s6_origin
    title: 'Socio-demographic Characteristics: Birthplace and Immigration'
    items:
    - id: SOCIO_Q1
      kind: Question
      title: In what country were/was ... born? (Do not read list. Mark one only.)
      input:
        control: Dropdown
        labels:
          1: Canada (Go to next section)
          2: China
          3: France
          4: Germany
          5: Greece
          6: Guyana
          7: Hong Kong
          8: Hungary
          9: India
          10: Italy
          11: Jamaica
          12: Netherlands
          13: Philippines
          14: Poland
          15: Portugal
          16: United Kingdom
          17: United States
          18: Viet Nam
          19: Other (Specify___)
          97: DK (Go to SOCIO-Q4)
          98: R (Go to SOCIO-Q4)
    - id: SOCIO_Q3
      kind: Question
      title: In what year did ... first immigrate to Canada? (Enter <1999> if Canadian citizen by birth.)
      precondition:
      - predicate: not (SOCIO_Q1.outcome in [97, 98])
        hint: Asked only when question SOCIO-Q1 is none of "DK (Go to SOCIO-Q4)", "R (Go to SOCIO-Q4)".
      input:
        control: Editbox
        min: -8
        max: 2026
        right: (-7 = DK, -8 = R)
  - id: b_s6_ethnicity_language
    title: 'Socio-demographic Characteristics: Ethnicity and Languages'
    items:
    - id: SOCIO_Q4
      kind: Question
      title: 'To which ethnic or cultural group(s) did your/his/her ancestors belong? (For example: French, British, Chinese, etc.) (Do not read list. Mark all that apply.)'
      input:
        control: Checkbox
        labels:
          1: Canadian
          2: French
          4: English
          8: German
          16: Scottish
          32: Irish
          64: Italian
          128: Ukrainian
          256: Dutch (Netherlands)
          512: Chinese
          1024: Jewish
          2048: Polish
          4096: Portuguese
          8192: South Asian
          16384: Black
          32768: North American Indian
          65536: Métis
          131072: Inuit/Eskimo
          262144: Other ethnic or cultural group(s) (Specify___)
    - id: SOCIO_Q5
      kind: Question
      title: In which languages can ... conduct a conversation? (Do not read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Arabic
          8: Chinese
          16: Cree
          32: German
          64: Greek
          128: Hungarian
          256: Italian
          512: Korean
          1024: Persian (Farsi)
          2048: Polish
          4096: Portuguese
          8192: Punjabi
          16384: Spanish
          32768: Tagalog (Filipino)
          65536: Ukrainian
          131072: Vietnamese
          262144: Other (Specify______)
  - id: b_s7_preamble
    title: External values
    items:
    - id: age
      kind: Question
      title: Age of the person (from the household roster / sample file; read by EDUC-C1, EDUC-C5, LFS-C1, GENHLT-C2, PHP-C2, H06 header)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: sex
      kind: Question
      title: Sex of the person (from the household roster / sample file; read by GENHLT-C2 and PHP-C2)
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: PROXY
      kind: Question
      title: 'Proxy flag: whether another person answers on behalf of the selected respondent (read by ALCO-Q3 ''If PROXY=yes'' and the ''(Non-proxy only)'' sections)'
      external: true
      input:
        control: Radio
        labels:
          1: Yes (proxy)
          2: No (non-proxy)
    - id: LFS_GAPS
      kind: Question
      title: 'Number of gaps greater than 6 days found when checking the employment calendar (LFS-C17: ''Check the calendar for gaps > 6 days'')'
      external: true
      input:
        control: Editbox
        min: 0
        max: 100
  - id: b_s7_mother_tongue
    title: Mother tongue
    items:
    - id: SOCIO_Q6
      kind: Question
      title: What is the language that ... first learned at home in childhood and can still understand? (If ... can no longer understand the first language learned, choose the second language learned.) (Do not read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Arabic
          8: Chinese
          16: Cree
          32: German
          64: Greek
          128: Hungarian
          256: Italian
          512: Korean
          1024: Persian (Farsi)
          2048: Polish
          4096: Portuguese
          8192: Punjabi
          16384: Spanish
          32768: Tagalog (Filipino)
          65536: Ukrainian
          131072: Vietnamese
          262144: Other (Specify______)
  - id: b_s8_race
    title: Race
    items:
    - id: SOCIO_Q7
      kind: Question
      title: How would you best describe ...(r/'s) race or colour? (Do not read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: White (e.g. British, French, European, Latin/South American of European background)
          2: Black
          4: Korean
          8: Filipino
          16: Japanese
          32: Chinese
          64: Native/Aboriginal Peoples of North America (North American Indian, Métis, Inuit/Eskimo)
          128: South Asian (e.g. Indian from India or Uganda, Pakistani, Punjabi, Tamil)
          256: South East Asian (e.g. Vietnamese, Thai, Laotian)
          512: West East Asian or North African (e.g. Armenian, Syrian, Moroccan)
          1024: Other (Specify ____________)
  - id: b_s9_schooling
    title: Education
    items:
    - id: EDUC_Q1
      kind: Question
      title: Excluding kindergarten, how many years of elementary and high school have/has ... successfully completed? (Do not read list. Mark one only.)
      precondition:
      - predicate: age.outcome >= 12
        hint: Asked only of persons aged 12 or older
      input:
        control: Dropdown
        labels:
          1: No schooling (Go to next section)
          2: One to five years
          3: Six
          4: Seven
          5: Eight
          6: Nine
          7: Ten
          8: Eleven
          9: Twelve
          10: Thirteen
          11: DK
          12: R
  - id: b_s9_education
    title: Education attained and attendance
    precondition:
    - predicate: age.outcome >= 15
      hint: Asked only of persons aged 15 or older
    - predicate: not (EDUC_Q1.outcome in [1, 11, 12])
      hint: Asked only when question EDUC-Q1 is none of No schooling, DK, R
    items:
    - id: EDUC_Q2
      kind: Question
      title: Have/has ... graduated from high school? (Asked only if age >= 15)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: EDUC_Q3
      kind: Question
      title: Have/has ... ever attended any other kind of school such as university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to EDUC-C5)
          3: DK
          4: R
    - id: EDUC_Q4
      kind: Question
      title: What is the highest level of education that ... have/has attained? (Do not read list. Mark one only.)
      precondition:
      - predicate: not (EDUC_Q3.outcome == 2 and age.outcome < 65)
        hint: Not asked when EDUC-Q3 is No and age is under 65
      - predicate: not (EDUC_Q3.outcome == 2 and age.outcome >= 65)
        hint: Not asked when EDUC-Q3 is No and age is 65 or older
      - predicate: not (EDUC_Q3.outcome in [3, 4])
        hint: Asked only when question EDUC-Q3 is none of DK, R
      input:
        control: Dropdown
        labels:
          1: Some trade, technical, vocational school or business college
          2: Some community college, CEGEP or nursing school
          3: Some university
          4: Diploma or certificate from trade, technical or vocational school, or business college
          5: Diploma or certificate from community college, CEGEP, or nursing school)
          6: Bachelor's or undergraduate degree or teacher's college (e.g., B.A., B.Sc., LL.B.)
          7: Master's (e.g. M.A., M. Sc., M.Ed.)
          8: Degree in medicine, dentistry, veterinary medicine or optometry (M.D., D.D.S., D.M.D., D.V.M., O.D.)
          9: Earned doctorate (e.g. Ph.D., D.Sc., D.Ed.)
          10: Other (Specify_____)
    - id: EDUC_Q5
      kind: Question
      title: Are/Is ... currently attending a school, college or university?
      precondition:
      - predicate: age.outcome < 65
        hint: Asked only of persons under 65
      - predicate: not (EDUC_Q3.outcome == 2 and age.outcome >= 65)
        hint: Not asked when EDUC-Q3 is No and age is 65 or older
      - predicate: not (EDUC_Q3.outcome in [3, 4])
        hint: Asked only when question EDUC-Q3 is none of DK, R
      - predicate: not (age.outcome >= 65)
        hint: Not asked of persons aged 65 or older
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
    - id: EDUC_Q6
      kind: Question
      title: Are/Is ... enrolled as a full-time or part-time student?
      precondition:
      - predicate: not (EDUC_Q3.outcome == 2 and age.outcome >= 65)
        hint: Not asked when EDUC-Q3 is No and age is 65 or older
      - predicate: not (EDUC_Q3.outcome in [3, 4])
        hint: Asked only when question EDUC-Q3 is none of DK, R
      - predicate: not (age.outcome >= 65)
        hint: Not asked of persons aged 65 or older
      - predicate: not (EDUC_Q5.outcome in [2, 3, 4])
        hint: Asked only when question EDUC-Q5 is none of No, DK, R
      input:
        control: Radio
        labels:
          1: full-time
          2: part-time
  - id: b_s10_main_activity
    title: 'Labour Force: Main Activity'
    items:
    - id: LFS_Q1
      kind: Question
      title: What do/does ... consider to be your/his/her current main activity? (For example, working for pay, caring for family.) (Do not read list. Mark one only.)
      precondition:
      - predicate: age.outcome >= 15
        hint: Asked only of persons aged 15 or older
      input:
        control: Radio
        labels:
          1: Caring for family
          2: Working for pay or profit
          3: Caring for family and working for pay or profit
          4: Going to school
          5: Recovering from illness/on disability
          6: Looking for work
          7: Retired
          8: Other (Specify)
  - id: b_s10_work_past_year
    title: 'Labour Force: Work in the Past 12 Months'
    items:
    - id: LFS_Q2
      kind: Question
      title: Have/has you/he/she worked for pay or profit at any time in the past 12 months?
      precondition:
      - predicate: not (LFS_Q1.outcome in [2, 3])
        hint: Asked only when question LFS-Q1 is none of "Working for pay or profit", "Caring for family and working for pay or profit".
      input:
        control: Radio
        labels:
          1: Yes (Go to LFS-Q3.1)
          2: 'No'
          3: DK
          4: R
  - id: b_s10_job_start
    title: 'Labour Force: Job Held and Start Date'
    precondition:
    - predicate: not (LFS_Q2.outcome in [3, 4])
      hint: Asked only when question LFS-Q2 is none of "DK", "R".
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome == 7)
      hint: Not asked of retired persons who did not work in the past 12 months
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome != 7)
      hint: Not asked of persons who did not work in the past 12 months
    items:
    - id: LFS_Q3_n
      kind: Question
      title: 'For whom/whom else have/has you/he/she worked for pay or profit in the past 12 months? _____________________ (50 chars) [roster: up to 6 jobs, LFS-Q3 to LFS-Q11]'
      input:
        control: Textarea
        maxLength: 50
    - id: LFS_Q4_n
      kind: Question
      title: Did you/he/she have that job 1 year ago, that is, on %12MOSAGO% without a break in employment since then?
      input:
        control: Radio
        labels:
          1: Yes (Go to LFS-Q6.n)
          2: 'No'
          3: DK
          4: R
    - id: LFS_Q5_n
      kind: Question
      title: 'When did you/he/she start working at this job or business? MM/DD/YY (DK, R: Go to next section)'
      precondition:
      - predicate: not (LFS_Q4_n.outcome == 1)
        hint: Asked only when question LFS-Q4.n is not "Yes (Go to LFS-Q6.n)".
      - predicate: not (LFS_Q4_n.outcome in [3, 4])
        hint: Asked only when question LFS-Q4.n is none of "DK", "R".
      input:
        control: Textarea
        maxLength: 20
    - id: LFS_Q6_n
      kind: Question
      title: Do/Does you/he/she now have that job?
      precondition:
      - predicate: not (LFS_Q4_n.outcome in [3, 4])
        hint: Asked only when question LFS-Q4.n is none of "DK", "R".
      - predicate: not (LFS_Q5_n.outcome in [-1, -2])
        hint: Asked only when question LFS-Q5.n is none of -1, -2.
      input:
        control: Radio
        labels:
          1: Yes (Go to LFS-Q8.n)
          2: 'No'
          3: DK
          4: R
    - id: LFS_Q7_n
      kind: Question
      title: 'When did you/he/she stop working at this job or business? MM/DD/YY (DK, R: Go to next section)'
      precondition:
      - predicate: not (LFS_Q4_n.outcome in [3, 4])
        hint: Asked only when question LFS-Q4.n is none of "DK", "R".
      - predicate: not (LFS_Q5_n.outcome in [-1, -2])
        hint: Asked only when question LFS-Q5.n is none of -1, -2.
      - predicate: not (LFS_Q6_n.outcome == 1)
        hint: Asked only when question LFS-Q6.n is not "Yes (Go to LFS-Q8.n)".
      - predicate: not (LFS_Q6_n.outcome in [3, 4])
        hint: Asked only when question LFS-Q6.n is none of "DK", "R".
      input:
        control: Textarea
        maxLength: 20
  - id: b_s10_job_details
    title: 'Labour Force: Job Characteristics'
    precondition:
    - predicate: not (LFS_Q2.outcome in [3, 4])
      hint: Asked only when question LFS-Q2 is none of "DK", "R".
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome == 7)
      hint: Not asked of retired persons who did not work in the past 12 months
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome != 7)
      hint: Not asked of persons who did not work in the past 12 months
    - predicate: not (LFS_Q4_n.outcome in [3, 4])
      hint: Asked only when question LFS-Q4.n is none of "DK", "R".
    - predicate: not (LFS_Q5_n.outcome in [-1, -2])
      hint: Asked only when question LFS-Q5.n is none of -1, -2.
    - predicate: not (LFS_Q6_n.outcome in [3, 4])
      hint: Asked only when question LFS-Q6.n is none of "DK", "R".
    - predicate: not (LFS_Q7_n.outcome in [-1, -2])
      hint: Asked only when question LFS-Q7.n is none of -1, -2.
    items:
    - id: LFS_Q8_n
      kind: Question
      title: About how many hours per week do/does/did you/he/she usually work at this job? |_|_| HOURS
      input:
        control: Editbox
        min: 0
        max: 99
        right: hours
    - id: LFS_Q9_n
      kind: Question
      title: Which of the following best describes the hours you/he/she usually work/works/worked at this job? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Regular daytime schedule or shift
          2: Regular evening shift
          3: Regular night
          4: Rotating shift (change from days to evenings to nights)
          5: Split shift
          6: On call
          7: Irregular schedule
          8: Other (Specify_______)
    - id: LFS_Q10_n
      kind: Question
      title: Do/Does/Did you/he/she usually work on weekends at this job?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: LFS_Q11_n
      kind: Question
      title: Did you/he/she do any other work for pay or profit in the past 12 months?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: 'R (DK, R: Go to LFS-Q12)'
    - id: LFS_Q12
      kind: Question
      title: Which was the main job? (Answer will be chosen from roster of jobs.) (Definition of main job will be supplied in the interviewers manual.)
      precondition:
      - predicate: not (LFS_Q11_n.outcome == 2)
        hint: Asked only when question LFS-Q11.n is not "No".
      input:
        control: Editbox
        min: 1
        max: 6
    - id: LFS_Q13
      kind: Question
      title: Thinking about this/the main job, what kind of business, service or industry is this? (For example, wheat farm, trapping, road maintenance, retail shoe store, secondary school.) _____________________ (50 chars)
      input:
        control: Textarea
        maxLength: 50
    - id: LFS_Q14
      kind: Question
      title: Again, thinking about this/the main job, what kind of work was/were ... doing? (For example, medical lab technician, accounting clerk, secondary school teacher, supervisor of data entry unit, food processing labourer.) _____________________ (50 chars)
      input:
        control: Textarea
        maxLength: 50
    - id: LFS_Q15
      kind: Question
      title: In this work, what were your/his/her most important duties or activities? (For example, analysis of blood samples, verifying invoices, teaching mathematics, organizing work schedules, cleaning vegetables.) _____________________ (50 chars)
      input:
        control: Textarea
        maxLength: 50
    - id: LFS_Q16
      kind: Question
      title: Did you/he/she work mainly for others for wages or commission or in your/his/her own business, farm or practice? (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: For others for wages, salary or commission
          2: In own business, farm or professional practice
          3: Unpaid family worker
    - id: LFS_Q17A
      kind: Question
      title: What was the reason that ... were/was not working for pay or profit during the most recent period away from work in the past year? (Do not read list. Mark one only.)
      precondition:
      - predicate: not (LFS_GAPS.outcome == 0)
        hint: Asked only when question LFS-GAPS is not 0.
      - predicate: not (LFS_GAPS.outcome != 0 and LFS_Q6_n.outcome != 1)
        hint: Asked only when the person still has that job
      input:
        control: Dropdown
        labels:
          1: Own illness or disability
          2: Pregnancy
          3: Caring for own children
          4: Caring for elder relative(s)
          5: Other personal or family responsibilities
          6: School or educational leave
          7: Labour dispute
          8: Temporary layoff due to seasonal conditions
          9: Temporary layoff - non-seasonal
          10: Permanent layoff
          11: Unpaid or partially paid vacation
          12: Other (Specify________)
          13: No period not working for pay or profit in the past year
  - id: b_s10_current_not_working
    title: 'Labour Force: Reason for Currently Not Working'
    precondition:
    - predicate: not (LFS_Q2.outcome in [3, 4])
      hint: Asked only when question LFS-Q2 is none of "DK", "R".
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome == 7)
      hint: Not asked of retired persons who did not work in the past 12 months
    - predicate: not (LFS_Q4_n.outcome in [3, 4])
      hint: Asked only when question LFS-Q4.n is none of "DK", "R".
    - predicate: not (LFS_Q5_n.outcome in [-1, -2])
      hint: Asked only when question LFS-Q5.n is none of -1, -2.
    - predicate: not (LFS_Q6_n.outcome in [3, 4])
      hint: Asked only when question LFS-Q6.n is none of "DK", "R".
    - predicate: not (LFS_Q7_n.outcome in [-1, -2])
      hint: Asked only when question LFS-Q7.n is none of -1, -2.
    - predicate: not (LFS_GAPS.outcome == 0)
      hint: Asked only when question LFS-GAPS is not 0.
    - predicate: not (LFS_Q17A.outcome is not None and LFS_Q17A.outcome >= 1)
      hint: Asked only when LFS-Q17A was not answered
    items:
    - id: LFS_Q17B
      kind: Question
      title: What is the reason that ... are/is currently not working for pay or profit? (Do not read list. Mark one only.)
      input:
        control: Dropdown
        labels:
          1: Own illness or disability
          2: Pregnancy
          3: Caring for own children
          4: Caring for elder relative(s)
          5: Other personal or family responsibilities
          6: School or educational leave
          7: Labour dispute
          8: Temporary layoff due to seasonal conditions
          9: Temporary layoff - non-seasonal
          10: Permanent layoff
          11: Unpaid or partially paid vacation
          12: Other (Specify_______)
          13: No period not working for pay or profit in the past year
  - id: b_s11_sources
    title: Income sources
    items:
    - id: INCOM_Q1
      kind: Question
      title: Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (Ask from knowledgeable person only) (Read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: Wages and salaries
          2: Income from self-employment
          4: Dividends and interest on bonds, deposits and savings, stocks, mutual funds, etc.
          8: Unemployment insurance
          16: Worker's compensation
          32: Benefits from Canada or Quebec Pension Plan
          64: Retirement pensions, superannuation and annuities
          128: Old Age Security and Guaranteed Income Supplement
          256: Child Tax Benefit
          512: Provincial or municipal social assistance or welfare
          1024: Child Support
          2048: Alimony
          4096: Other Income (eg. rental income, scholarships, other government income, etc.)
          8192: None (Go to next section)
          16384: DK
          32768: R
      postcondition:
      - predicate: INCOM_Q1.outcome & 8192 == 0 or INCOM_Q1.outcome == 8192
        hint: 'INCOM-Q1: ''None'' cannot be combined with an income source; untick ''None'' or the other sources.'
        invented: true
  - id: b_s11_amounts
    title: Main source and total household income
    precondition:
    - predicate: not (INCOM_Q1.outcome & 8192 > 0)
    - predicate: not (INCOM_Q1.outcome & 16384 > 0 or INCOM_Q1.outcome & 32768 > 0)
    items:
    - id: INCOM_Q2
      kind: Question
      title: What was the main source of income? (Do not read list. Mark one only.)
      precondition:
      - predicate: not (INCOM_Q1.outcome in [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768])
      - predicate: not (INCOM_Q1.outcome in [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096])
        hint: Asked only when question INCOM-Q1 is none of "Wages and salaries", "Income from self-employment", "Dividends and interest on bonds, deposits and savings, stocks, mutual funds, etc.", "Unemployment insurance", "Worker's compensation", "Benefits from Canada or Quebec Pension Plan", "Retirement pensions, superannuation and annuities", "Old Age Security and Guaranteed Income Supplement", "Child Tax Benefit", "Provincial or municipal social assistance or welfare", "Child Support", "Alimony", "Other Income (eg. rental income, scholarships, other government income, etc.)".
      input:
        control: Dropdown
        labels:
          1: Wages and salaries
          2: Income from self-employment
          3: Dividends and interest on bonds, deposits and savings, stocks, mutual funds, etc.
          4: Unemployment insurance
          5: Worker's compensation
          6: Benefits from Canada or Quebec Pension Plan
          7: Retirement pensions, superannuation and annuities
          8: Old Age Security and Guaranteed Income Supplement
          9: Child Tax Benefit
          10: Provincial or Municipal Social Assistance or Welfare
          11: Child Support
          12: Alimony
          13: Other Income (eg. rental income, scholarships, other government income, etc.)
      postcondition:
      - predicate: (INCOM_Q2.outcome == 1 and INCOM_Q1.outcome & 1 > 0) or (INCOM_Q2.outcome == 2 and INCOM_Q1.outcome & 2 > 0) or (INCOM_Q2.outcome == 3 and INCOM_Q1.outcome & 4 > 0) or (INCOM_Q2.outcome == 4 and INCOM_Q1.outcome & 8 > 0) or (INCOM_Q2.outcome == 5 and INCOM_Q1.outcome & 16 > 0) or (INCOM_Q2.outcome == 6 and INCOM_Q1.outcome & 32 > 0) or (INCOM_Q2.outcome == 7 and INCOM_Q1.outcome & 64 > 0) or (INCOM_Q2.outcome == 8 and INCOM_Q1.outcome & 128 > 0) or (INCOM_Q2.outcome == 9 and INCOM_Q1.outcome & 256 > 0) or (INCOM_Q2.outcome == 10 and INCOM_Q1.outcome & 512 > 0) or (INCOM_Q2.outcome == 11 and INCOM_Q1.outcome & 1024 > 0) or (INCOM_Q2.outcome == 12 and INCOM_Q1.outcome & 2048 > 0) or (INCOM_Q2.outcome == 13 and INCOM_Q1.outcome & 4096 > 0)
        hint: 'INCOM-Q2: the main source of income must be one of the sources ticked in INCOM-Q1.'
        invented: true
    - id: INCOM_Q3
      kind: Question
      title: 'What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months? Was the total household income:'
      input:
        control: Dropdown
        labels:
          1: Less than $20,000?
          2: Less than $10,000?
          3: Less than $5,000? (go to next section)
          4: $5,000 and more? (go to next section)
          5: $10,000 and more?
          6: Less than $15,000? (go to next section)
          7: $15,000 and more? (go to next section)
          8: $20,000 and more?
          9: Less than $40,000?
          10: Less than $30,000? (go to next section)
          11: $30,000 and more? (go to next section)
          12: $40,000 and more?
          13: Less than $50,000 (go to next section)
          14: $50,000 to less than $60,000? (go to next section)
          15: $60,000 to less than $80,000? (go to next section)
          16: $80,000 and more? (go to next section)
          17: No income
          18: DK
          19: R
  - id: b_s12_administration
    title: Administration
    items:
    - id: H05_P1_2
      kind: Question
      title: Was this interview conducted on the telephone or in person?
      input:
        control: Radio
        labels:
          1: On telephone
          2: In person
          3: Both (Specify in comments)
    - id: H05_P2
      kind: Question
      title: Record language of interview
      input:
        control: Dropdown
        labels:
          1: English
          2: French
          3: Arabic
          4: Chinese
          5: Cree
          6: German
          7: Greek
          8: Hungarian
          9: Italian
          10: Korean
          11: Persian (Farsi)
          12: Polish
          13: Portuguese
          14: Punjabi
          15: Spanish
          16: Tagalog (Filipino)
          17: Ukrainian
          18: Vietnamese
          19: Other (Specify_______________)
  - id: b_s13_health_proxy
    title: Health Component for Respondents Aged 12 Years and Older (Form H06)
    items:
    - id: H06_P1
      kind: Question
      title: Who is providing the information for this person's form? (To be completed for selected respondent only and age>=12) (Proxy for those unable to answer due to special circumstances)
      precondition:
      - predicate: age.outcome >= 12
        hint: Asked only of respondents aged 12 years and older
      input:
        control: Textarea
  - id: b_s14_self_rated_health
    title: General Health
    items:
    - id: GENHLT_Q1
      kind: Question
      title: 'In general, would you say ... r/''s health is: (Read list. Mark one only.)'
      input:
        control: Radio
        labels:
          1: Excellent?
          2: Very good?
          3: Good?
          4: Fair?
          5: Poor?
  - id: b_s14_pregnancy
    title: Pregnancy
    precondition:
    - predicate: sex.outcome == 2 and age.outcome >= 15 and age.outcome <= 49
      hint: Asked only of females aged 15 to 49
    - predicate: not (not (sex.outcome == 2 and age.outcome >= 15 and age.outcome <= 49))
      hint: Asked only of females aged 15 to 49
    items:
    - id: GENHLT_Q2
      kind: Question
      title: It is important to know when analyzing health whether or not the person is pregnant. Are/Is ... pregnant?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
    - id: GENHLT_Q3
      kind: Question
      title: Are/Is you/she planning to use the services of a physician, midwife or both? (Do not read list. Mark one only.)
      precondition:
      - predicate: not (GENHLT_Q2.outcome in [2, 3, 4])
        hint: Asked only when question GENHLT-Q2 is none of "No (Go to next section)", "DK", "R".
      input:
        control: Radio
        labels:
          1: Physician only
          2: Midwife only
          3: Both physician and midwife
          4: Neither
  - id: b_s15_height_weight
    title: Height/Weight
    items:
    - id: HTWT_Q1
      kind: Question
      title: How tall are/is ... without shoes on? ___ feet ___ inches OR ___ centimetres
      input:
        control: Editbox
        min: 50
        max: 250
        right: centimetres
    - id: HTWT_Q2
      kind: Question
      title: How much do/does you/he/she weigh? ___ pounds OR ___ kilograms
      input:
        control: Editbox
        min: 10
        max: 300
        right: kilograms
  - id: b_s16_bp
    title: Preventive Health Practices
    precondition:
    - predicate: PROXY.outcome == 2
      hint: Asked only when question PROXY is "No (non-proxy)".
    items:
    - id: PHP_Q1
      kind: Question
      title: When did you last have your blood pressure checked by a health professional? (Non-proxy only) (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Less than 6 months ago
          2: 6 months to less than a year ago
          3: 1 year to less than 2 years ago
          4: 2 years to less than 5 years ago
          5: 5 years or more ago
          6: Never
          7: R
  - id: b_s16_mammo_screen
    title: Mammogram
    precondition:
    - predicate: PROXY.outcome == 2
      hint: Asked only when question PROXY is "No (non-proxy)".
    items:
    - id: PHP_Q2
      kind: Question
      title: Have you ever had a mammogram, that is, a breast X-ray?
      precondition:
      - predicate: sex.outcome == 2 and age.outcome >= 35
        hint: Asked only of women aged 35 or older.
      - predicate: not (PHP_Q1.outcome == 7)
        hint: Asked only when question PHP-Q1 is not "R".
      - predicate: not (sex.outcome == 2 and age.outcome >= 18 and age.outcome < 35)
        hint: Not asked of women aged 18 to 34.
      - predicate: not (sex.outcome == 1 or (sex.outcome == 2 and age.outcome <= 17))
        hint: Not asked of men or of girls aged 17 or younger.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to PHP-Q3)
          3: DK (Go to PHP-Q3)
          4: R (Go to next section)
  - id: b_s16_mammo_detail
    title: Last mammogram
    precondition:
    - predicate: PROXY.outcome == 2
      hint: Asked only when question PROXY is "No (non-proxy)".
    - predicate: not (PHP_Q1.outcome == 7)
      hint: Asked only when question PHP-Q1 is not "R".
    - predicate: not (sex.outcome == 2 and age.outcome >= 18 and age.outcome < 35)
      hint: Not asked of women aged 18 to 34.
    - predicate: not (sex.outcome == 1 or (sex.outcome == 2 and age.outcome <= 17))
      hint: Not asked of men or of girls aged 17 or younger.
    - predicate: not (PHP_Q2.outcome in [2, 3])
      hint: Asked only when question PHP-Q2 is none of "No (Go to PHP-Q3)", "DK (Go to PHP-Q3)".
    - predicate: not (PHP_Q2.outcome == 4)
      hint: Asked only when question PHP-Q2 is not "R (Go to next section)".
    items:
    - id: PHP_Q2a
      kind: Question
      title: When was the last time? (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Less than 6 months ago
          2: 6 months to less than one year ago
          3: 1 year to less than 2 years ago
          4: 2 years or more ago
    - id: PHP_Q2b
      kind: Question
      title: Why did you have your last mammogram? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Breast problem
          2: Check-up, no particular problem
          3: Other (specify_____________)
  - id: b_s16_pap_screen
    title: PAP smear
    precondition:
    - predicate: PROXY.outcome == 2
      hint: Asked only when question PROXY is "No (non-proxy)".
    items:
    - id: PHP_Q3
      kind: Question
      title: Have you ever had a PAP smear test?
      precondition:
      - predicate: sex.outcome == 2 and age.outcome >= 18
        hint: Asked only of women aged 18 or older.
      - predicate: not (PHP_Q1.outcome == 7)
        hint: Asked only when question PHP-Q1 is not "R".
      - predicate: not (sex.outcome == 1 or (sex.outcome == 2 and age.outcome <= 17))
        hint: Not asked of men or of girls aged 17 or younger.
      - predicate: not (PHP_Q2.outcome == 4)
        hint: Asked only when question PHP-Q2 is not "R (Go to next section)".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
  - id: b_s16_pap_detail
    title: Last PAP smear
    precondition:
    - predicate: PROXY.outcome == 2
      hint: Asked only when question PROXY is "No (non-proxy)".
    - predicate: not (PHP_Q1.outcome == 7)
      hint: Asked only when question PHP-Q1 is not "R".
    - predicate: not (sex.outcome == 1 or (sex.outcome == 2 and age.outcome <= 17))
      hint: Not asked of men or of girls aged 17 or younger.
    - predicate: not (PHP_Q2.outcome == 4)
      hint: Asked only when question PHP-Q2 is not "R (Go to next section)".
    - predicate: not (PHP_Q3.outcome in [2, 3, 4])
      hint: Asked only when question PHP-Q3 is none of "No (Go to next section)", "DK", "R".
    items:
    - id: PHP_Q3a
      kind: Question
      title: When was the last time? (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Less than 6 months ago
          2: 6 months to less than one year ago
          3: 1 year to less than 3 years ago
          4: 3 years to less than 5 years ago
          5: 5 years or more ago
  - id: b_s17_household
    title: Smoking
    items:
    - id: SMOK_Q1
      kind: Question
      title: Does anyone in this household smoke regularly inside the house?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SMOK_Q2
      kind: Question
      title: At the present time do/does ... smoke cigarettes daily, occasionally or not at all?
      input:
        control: Radio
        labels:
          1: Daily
          2: Occasionally (Go to SMOK-Q5)
          3: Not at all (Go to SMOK-Q4a)
          4: DK
          5: R
  - id: b_s17_daily
    title: Current daily smoking
    precondition:
    - predicate: not (SMOK_Q2.outcome == 2)
      hint: Asked only when question SMOK-Q2 is not "Occasionally (Go to SMOK-Q5)".
    - predicate: not (SMOK_Q2.outcome == 3)
      hint: Asked only when question SMOK-Q2 is not "Not at all (Go to SMOK-Q4a)".
    - predicate: not (SMOK_Q2.outcome in [4, 5])
      hint: Asked only when question SMOK-Q2 is none of "DK", "R".
    items:
    - id: SMOK_Q3
      kind: Question
      title: At what age did you/he/she begin to smoke cigarettes daily? ___ Age
      postcondition:
      - predicate: SMOK_Q3.outcome <= age.outcome
        hint: 'SMOK-Q3: the age at which daily smoking began cannot exceed the person''s current age.'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 120
        right: Age
    - id: SMOK_Q4
      kind: Question
      title: How many cigarettes do/does you/he/she smoke each day now? ___ Number of cigarettes
      input:
        control: Editbox
        min: 0
        max: 200
        right: Number of cigarettes
  - id: b_s17_ever_smoked
    title: Ever smoked cigarettes
    items:
    - id: SMOK_Q4a
      kind: Question
      title: Have/has you/he/she ever smoked cigarettes at all?
      precondition:
      - predicate: not (SMOK_Q2.outcome == 2)
        hint: Asked only when question SMOK-Q2 is not "Occasionally (Go to SMOK-Q5)".
      - predicate: not (SMOK_Q2.outcome in [4, 5])
        hint: Asked only when question SMOK-Q2 is none of "DK", "R".
      - predicate: SMOK_Q4.outcome is None or not (SMOK_Q4.outcome >= 0)
        hint: Asked only when SMOK-Q4 was not answered.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
    - id: SMOK_Q5
      kind: Question
      title: Have/has you/he/she ever smoked cigarettes daily?
      precondition:
      - predicate: not (SMOK_Q2.outcome in [4, 5])
        hint: Asked only when question SMOK-Q2 is none of "DK", "R".
      - predicate: SMOK_Q4.outcome is None or not (SMOK_Q4.outcome >= 0)
        hint: Asked only when SMOK-Q4 was not answered.
      - predicate: not (SMOK_Q4a.outcome in [2, 3, 4])
        hint: Asked only when question SMOK-Q4a is none of "No (Go to next section)", "DK", "R".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
  - id: b_s17_past_daily
    title: Past daily smoking
    precondition:
    - predicate: not (SMOK_Q2.outcome in [4, 5])
      hint: Asked only when question SMOK-Q2 is none of "DK", "R".
    - predicate: SMOK_Q4.outcome is None or not (SMOK_Q4.outcome >= 0)
      hint: Asked only when SMOK-Q4 was not answered.
    - predicate: not (SMOK_Q4a.outcome in [2, 3, 4])
      hint: Asked only when question SMOK-Q4a is none of "No (Go to next section)", "DK", "R".
    - predicate: not (SMOK_Q5.outcome in [2, 3, 4])
      hint: Asked only when question SMOK-Q5 is none of "No (Go to next section)", "DK", "R".
    items:
    - id: SMOK_Q6
      kind: Question
      title: At what age did you/he/she begin to smoke (cigarettes) daily? ___ Age
      postcondition:
      - predicate: SMOK_Q6.outcome <= age.outcome
        hint: 'SMOK-Q6: the age at which daily smoking began cannot exceed the person''s current age.'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 120
        right: Age
    - id: SMOK_Q7
      kind: Question
      title: How many cigarettes did you/he/she usually smoke each day? ___ Number of cigarettes
      input:
        control: Editbox
        min: 0
        max: 200
        right: Number of cigarettes
    - id: SMOK_Q8
      kind: Question
      title: At what age did you/he/she stop smoking (cigarettes) daily? ___ Age
      postcondition:
      - predicate: SMOK_Q6.outcome <= SMOK_Q8.outcome
        hint: 'SMOK-Q8: the age at which daily smoking stopped cannot be earlier than the age at which it began (SMOK-Q6).'
        invented: true
      - predicate: SMOK_Q8.outcome <= age.outcome
        hint: 'SMOK-Q8: the age at which daily smoking stopped cannot exceed the person''s current age.'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 120
        right: Age
  - id: b_s18_screen
    title: Alcohol
    items:
    - id: ALCO_Q1
      kind: Question
      title: During the past 12 months2, have/has ... had a drink of beer, wine, liquor or any other alcoholic beverage?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to ALCO-Q5B)
          3: DK
          4: R
  - id: b_s18_past12
    title: Alcohol use in the past 12 months and past week
    precondition:
    - predicate: not (ALCO_Q1.outcome == 2)
      hint: Asked only when question ALCO-Q1 is not "No (Go to ALCO-Q5B)".
    - predicate: not (ALCO_Q1.outcome in [3, 4])
      hint: Asked only when question ALCO-Q1 is none of "DK", "R".
    items:
    - id: ALCO_Q2
      kind: Question
      title: During the past 12 months, how often did you/he/she drink alcoholic beverages? (Do not read list. Mark one only.)
      input:
        control: Dropdown
        labels:
          1: Every day
          2: 4-6 times a week
          3: 2-3 times a week
          4: Once a week
          5: 2-3 times a month
          6: Once a month
          7: Less than once a month
    - id: ALCO_Q3
      kind: Question
      title: How many times in the past 12 months have/has you/he/she had 5 or more drinks on one occasion? ___ Number of times
      input:
        control: Editbox
        min: 0
        max: 366
        right: Number of times
    - id: ALCO_Q4
      kind: Question
      title: In the past 12 months, what is the highest number of drinks you had on one occasion? ___ Number of drinks
      precondition:
      - predicate: PROXY.outcome == 2
        hint: Asked only when question PROXY is "No (non-proxy)".
      - predicate: not (PROXY.outcome == 1)
        hint: Asked only when question PROXY is not "Yes (proxy)".
      postcondition:
      - predicate: ALCO_Q3.outcome == 0 or ALCO_Q4.outcome >= 5
        hint: 'ALCO-Q4: if you reported occasions of 5 or more drinks in ALCO-Q3, the highest number of drinks on one occasion must be at least 5.'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
        right: Number of drinks
    - id: ALCO_Q5
      kind: Question
      title: Thinking back over the past week, that is, from %1WKAGO% to yesterday, did ... have a drink of beer, wine, liquor or any other alcoholic beverage?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
    - id: ALCO_Q5A
      kind: Question
      title: 'Starting with yesterday, how many drinks did ... have on: Monday? (R on first day: Go to next section) Tuesday? Wednesday? Thursday? Friday? Saturday? Sunday? [seven daily counts, ALC4_5A1 to ALC4_5A7]'
      precondition:
      - predicate: not (ALCO_Q5.outcome in [2, 3, 4])
        hint: Asked only when question ALCO-Q5 is none of "No (Go to next section)", "DK", "R".
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s18_lifetime
    title: Past drinking and reasons for reducing or quitting
    precondition:
    - predicate: not (ALCO_Q1.outcome in [3, 4])
      hint: Asked only when question ALCO-Q1 is none of "DK", "R".
    - predicate: not (ALCO_Q5.outcome in [2, 3, 4])
      hint: Asked only when question ALCO-Q5 is none of "No (Go to next section)", "DK", "R".
    items:
    - id: ALCO_Q5B
      kind: Question
      title: Did you/he/she ever have a drink?
      precondition:
      - predicate: ALCO_Q5A.outcome is None or not (ALCO_Q5A.outcome >= 0)
        hint: Asked only when no weekly drink counts were collected in ALCO-Q5A.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
    - id: ALCO_Q6
      kind: Question
      title: Did you/he/she ever regularly drink more than 12 drinks a week?
      precondition:
      - predicate: ALCO_Q5A.outcome is None or not (ALCO_Q5A.outcome >= 0)
        hint: Asked only when no weekly drink counts were collected in ALCO-Q5A.
      - predicate: not (ALCO_Q5B.outcome in [2, 3, 4])
        hint: Asked only when question ALCO-Q5B is none of "No (Go to next section)", "DK", "R".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
    - id: ALCO_Q7
      kind: Question
      title: Why did you/he/she reduce or quit drinking altogether? (Do not read list. Mark all that apply.)
      precondition:
      - predicate: ALCO_Q5A.outcome is None or not (ALCO_Q5A.outcome >= 0)
        hint: Asked only when no weekly drink counts were collected in ALCO-Q5A.
      - predicate: not (ALCO_Q5B.outcome in [2, 3, 4])
        hint: Asked only when question ALCO-Q5B is none of "No (Go to next section)", "DK", "R".
      - predicate: not (ALCO_Q6.outcome in [2, 3, 4])
        hint: Asked only when question ALCO-Q6 is none of "No (Go to next section)", "DK", "R".
      input:
        control: Checkbox
        labels:
          1: Dieting
          2: Athletic training
          4: Pregnancy
          8: Getting older
          16: Drinking too much/drinking problem
          32: Affected work, studies, employment opportunities
          64: Interfered with family or home life
          128: Affected physical health
          256: Affected friendships or social relationships
          512: Affected financial position
          1024: Affected outlook on life, happiness
          2048: Because of influence of family or friends
          4096: Other (specify______________)
  - id: b_s19_activities
    title: Physical Activities
    precondition:
    - predicate: PROXY.outcome == 2
      hint: Asked only when question PROXY is "No (non-proxy)".
    items:
    - id: PHYS_Q1
      kind: Question
      title: Have you done any of the following in the past 3 months3? (Read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: Walking for exercise
          2: Gardening, yard work
          4: Swimming
          8: Bicycling
          16: Popular or social dance
          32: Home exercises
          64: Ice hockey
          128: Skating
          256: Downhill skiing
          512: Jogging/running
          1024: Golfing
          2048: Exercise class/aerobics
          4096: Cross-country skiing
          8192: Bowling
          16384: Baseball/softball
          32768: Tennis
          65536: Weight-training
          131072: Fishing
          262144: Volleyball
          524288: Yoga or tai-chi
          1048576: Other (specify) [1st]
          2097152: Other (specify) [2nd]
          4194304: Other (specify) [3rd]
          8388608: None
          16777216: DK
          33554432: R
      postcondition:
      - predicate: PHYS_Q1.outcome & 8388608 == 0 or PHYS_Q1.outcome == 8388608
        hint: 'PHYS-Q1: ''None'' cannot be combined with an activity; untick ''None'' or the listed activities.'
        invented: true
  - id: b_s19_participation
    title: Participation in Activities
    precondition:
    - predicate: PROXY.outcome == 2
      hint: Asked only when question PROXY is "No (non-proxy)".
    - predicate: not (PHYS_Q1.outcome & 8388608 > 0)
    - predicate: not (PHYS_Q1.outcome & 16777216 > 0 or PHYS_Q1.outcome & 33554432 > 0)
    items:
    - id: PHYS_Q2
      kind: Question
      title: 'In the past 3 months, how many times did you participate in %ACTIVITY%? ___ Number of times (asked for each activity ticked in PHYS-Q1; DK, R: Go to next activity)'
      input:
        control: Editbox
        min: 0
        max: 999
        right: times
    - id: PHYS_Q3
      kind: Question
      title: About how much time did you usually spend on each occasion? (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: 1 to 15 minutes
          2: 16 to 30 minutes
          3: 31 to 60 minutes
          4: More than one hour
  - id: b_s19_daily
    title: Daily Activities
    precondition:
    - predicate: PROXY.outcome == 2
      hint: Asked only when question PROXY is "No (non-proxy)".
    - predicate: not (PHYS_Q1.outcome & 16777216 > 0 or PHYS_Q1.outcome & 33554432 > 0)
    items:
    - id: PHYS_Q4a
      kind: Question
      title: In a typical week in the past 3 months, how many hours did you usually spend walking to work or to school or while doing errands? (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: None
          2: Less than 1 hour
          3: From 1 to 5 hours
          4: From 6 to 10 hours
          5: From 11 to 20 hours
          6: More than 20 hours
    - id: PHYS_Q4b
      kind: Question
      title: In a typical week, how much time did you usually spend bicycling to work or to school or while doing errands? (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: None
          2: Less than 1 hour
          3: From 1 to 5 hours
          4: From 6 to 10 hours
          5: From 11 to 20 hours
          6: More than 20 hours
    - id: PHYS_Q5
      kind: Question
      title: When riding a bicycle how often did you wear a helmet? (Read list. Mark one only.)
      precondition:
      - predicate: PHYS_Q1.outcome & 8 > 0 or PHYS_Q4b.outcome != 1
      - predicate: not (PHYS_Q1.outcome & 8 == 0 and PHYS_Q4b.outcome == 1)
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: PHYS_Q6
      kind: Question
      title: Thinking back over the past 3 months, which of the following best describes your usual daily activities or work habits? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Usually sit during day and do not walk about very much
          2: Stand or walk about quite a lot during the day but do not have to carry or lift things very often
          3: Usually lift or carry light loads, or have to climb stairs or hills often
          4: Do heavy work or carry very heavy loads
  - id: b_s20_screen
    title: Injuries
    items:
    - id: INJ_Q1
      kind: Question
      title: In the past 12 months, did ... have any injuries that were serious enough to limit your/his/her normal activities?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next section)
          3: DK
          4: R
  - id: b_s20_injuries
    title: Injury details
    precondition:
    - predicate: INJ_Q1.outcome == 1
      hint: Asked only when the respondent reported an injury in the past 12 months
    items:
    - id: INJ_Q2
      kind: Question
      title: 'How many times were/was you/he/she injured? ___ times (DK, R: Go to next section)'
      postcondition:
      - predicate: INJ_Q1.outcome != 1 or INJ_Q2.outcome >= 1
        hint: 'INJ-Q2: you answered Yes to INJ-Q1, so the number of times injured must be at least 1.'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
        right: times
    - id: INJ_Q3
      kind: Question
      title: Thinking about the most serious injury, what type of injury did you/he/she have? For example, a broken bone or burn. (Do not read list. Mark one only.)
      postcondition:
      - predicate: INJ_Q3.outcome != 1 or INJ_Q2.outcome >= 2
        hint: 'INJ-Q3: ''Multiple injuries'' requires at least 2 injuries in INJ-Q2; correct the number of injuries or the type of injury.'
        invented: true
      input:
        control: Dropdown
        labels:
          1: Multiple injuries
          2: Broken or fractured bones
          3: Burn or scald
          4: Dislocation
          5: Sprain or strain
          6: Cut or scrape
          7: Bruise or abrasion
          8: Concussion
          9: Poisoning by substance or liquid
          10: Internal injury
          11: Other (specify________________)
    - id: INJ_Q4
      kind: Question
      title: What part of your/his/her body was injured? (Do not read list. Mark one only.)
      input:
        control: Dropdown
        labels:
          1: Multiple sites
          2: Eyes
          3: Head (excluding eyes)
          4: Neck
          5: Shoulder
          6: Arms or hands
          7: Hip
          8: Legs or feet
          9: Back or spine
          10: Trunk (excluding back or spine) (including chest, internal organs, etc.)
    - id: INJ_Q5
      kind: Question
      title: Where did the injury happen? (Do not read list. Mark one only.)
      input:
        control: Dropdown
        labels:
          1: Home and surrounding area
          2: Farm
          3: Place for recreation or sport (e.g. golf course, basketball court, playground (including school))
          4: Street or highway
          5: Building used by general public (e.g. hotel, shopping plaza, restaurant, office building, school)
          6: Residential institution (e.g. hospital, jail, etc.)
          7: Mine
          8: Industrial place or premise (e.g. dockyard)
          9: Other (specify _______________)
  - id: b_s21_external
    title: External inputs
    items:
    - id: AGE_2
      kind: Question
      title: Respondent age (from the sample file / earlier part of the questionnaire; read by the age gates 'Age >= 18', 'Age >= 15', 'Age >= 12' and the drug check items)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: PROXY_2
      kind: Question
      title: Proxy flag (from the interview setup; 'non-proxy only' gates)
      external: true
      input:
        control: Radio
        labels:
          0: Non-proxy (respondent answers for self)
          1: Proxy interview
    - id: SEX_2
      kind: Question
      title: Respondent sex (from an earlier part; check items 'sex=female')
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: MARITAL_STATUS
      kind: Question
      title: Marital status (from an earlier part of the questionnaire; used by the CSTRESS and RECENT routing)
      external: true
      input:
        control: Dropdown
        labels:
          1: Married
          2: Living with a partner / common-law
          3: Single
          4: Widowed
          5: Separated
          6: Divorced
          9: Unknown
    - id: EMPLOYED
      kind: Question
      title: 'Currently employed (check item: ask only of those currently employed; from an earlier part)'
      external: true
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
  - id: b_s22_injury_details
    title: Injuries (continued)
    items:
    - id: INJ_Q6
      kind: Question
      title: What happened? For example, was the injury the result of a fall, motor vehicle accident, a physical assault etc.? (Do not read list. Mark one only.)
      input:
        control: Dropdown
        labels:
          1: Motor vehicle accident
          2: Accidental fall
          3: Fire, flames or resulting fumes
          4: Accidentally struck by an object/person
          5: Physical assault
          6: Suicide attempt
          7: Accidental injury caused by explosion
          8: Accidental injury caused by natural/environmental factors (e.g. weather conditions, Poison ivy, animal bites, stings)
          9: Accidental drowning or submersion
          10: Accidental suffocation
          11: Hot or corrosive liquids, foods or substances
          12: Accident caused by machinery (e.g. farm machinery, forklift, woodworking machinery)
          13: Accident caused by cutting and piercing instruments or objects (lawnmower, knife, stapler)
          14: Accidental poisoning
          15: Other (specify__________________)
    - id: INJ_Q7
      kind: Question
      title: Was this a work-related injury?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: INJ_Q8
      kind: Question
      title: We would like to know what precautions ... are/is taking, if any, to prevent this kind of injury from happening again. What precautions are/is you/he/she taking? (Do not read list. Mark all that apply.)
      postcondition:
      - predicate: not (INJ_Q8.outcome & 128 > 0 and INJ_Q8.outcome & 127 > 0)
        hint: 'INJ-Q8: ''No precautions'' cannot be ticked together with any other precaution.'
        invented: true
      input:
        control: Checkbox
        labels:
          1: Gave up the activity
          2: Being more careful
          4: Took safety training
          8: Increased supervision of child
          16: Using protective gear/safety equipment (e.g. bike helmet, car safety restraint, etc.)
          32: Changing physical situation (e.g. removing rugs, storing medications out of reach, safety gates, etc.)
          64: Other (specify)
          128: No precautions
  - id: b_s23_first
    title: Stress — Ongoing Problems
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
      hint: Asked only of respondents aged 18 or older who are not proxies
    items:
    - id: CSTRESS_Q1
      kind: Question
      title: You are trying to take on too many things at once.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
          99: Refused
  - id: b_s23_main
    title: Ongoing Problems
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
      hint: Asked only of respondents aged 18 or older who are not proxies
    - predicate: not (CSTRESS_Q1.outcome == 99)
      hint: Asked only when question CSTRESS-Q1 is not "Refused".
    items:
    - id: CSTRESS_Q2
      kind: Question
      title: There is too much pressure on you to be like other people.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q3
      kind: Question
      title: Too much is expected of you by others.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q4
      kind: Question
      title: You don't have enough money to buy the things you need.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
  - id: b_s23_partner
    title: Partner
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0 and MARITAL_STATUS.outcome in [1, 2]
      hint: Asked only of respondents with a partner
    - predicate: not (CSTRESS_Q1.outcome == 99)
      hint: Asked only when question CSTRESS-Q1 is not "Refused".
    - predicate: not (MARITAL_STATUS.outcome in [3, 4, 5, 6])
      hint: Asked only when question MARITAL_STATUS is none of "Single", "Widowed", "Separated", "Divorced".
    - predicate: not (MARITAL_STATUS.outcome == 9)
      hint: Asked only when question MARITAL_STATUS is not "Unknown".
    items:
    - id: CSTRESS_Q5
      kind: Question
      title: Your partner doesn't understand you.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q6
      kind: Question
      title: Your partner doesn't show enough affection.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q7
      kind: Question
      title: Your partner is not committed enough to your relationship.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
  - id: b_s23_no_partner
    title: No partner
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0 and MARITAL_STATUS.outcome in [3, 4, 5, 6]
      hint: Asked only of respondents without a partner
    - predicate: not (CSTRESS_Q1.outcome == 99)
      hint: Asked only when question CSTRESS-Q1 is not "Refused".
    - predicate: not (MARITAL_STATUS.outcome == 9)
      hint: Asked only when question MARITAL_STATUS is not "Unknown".
    - predicate: not (CSTRESS_Q7.outcome in [1, 2])
      hint: Asked only when question CSTRESS-Q7 is none of "True", "False".
    items:
    - id: CSTRESS_Q8
      kind: Question
      title: You find it is very difficult to find someone compatible with you.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
  - id: b_s23_children_screen
    title: Children
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
      hint: Asked only of respondents aged 18 or older who are not proxies
    - predicate: not (CSTRESS_Q1.outcome == 99)
      hint: Asked only when question CSTRESS-Q1 is not "Refused".
    items:
    - id: CSTRESS_Q9
      kind: Question
      title: Do you have any children?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
  - id: b_s23_children
    title: Children's problems
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0 and CSTRESS_Q9.outcome == 1
      hint: Asked only of respondents who have children
    - predicate: not (CSTRESS_Q1.outcome == 99)
      hint: Asked only when question CSTRESS-Q1 is not "Refused".
    - predicate: not (CSTRESS_Q9.outcome in [2, 97, 99])
      hint: Asked only when question CSTRESS-Q9 is none of "No", "Don't know", "Refused".
    items:
    - id: CSTRESS_Q10
      kind: Question
      title: Remember I want to know if you feel any of these statements are true for you at this time. One of your children seems very unhappy.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q11
      kind: Question
      title: A child's behaviour is a source of serious concern to you.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
  - id: b_s23_other
    title: Other ongoing problems
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
      hint: Asked only of respondents aged 18 or older who are not proxies
    - predicate: not (CSTRESS_Q1.outcome == 99)
      hint: Asked only when question CSTRESS-Q1 is not "Refused".
    items:
    - id: CSTRESS_Q12
      kind: Question
      title: Your work around the home is not appreciated.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q13
      kind: Question
      title: Your friends are a bad influence.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q14
      kind: Question
      title: You would like to move but you cannot.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q15
      kind: Question
      title: Your neighbourhood or community is too noisy or too polluted.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q16
      kind: Question
      title: You have a parent, a child or partner who is in very bad health and may die.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q17
      kind: Question
      title: Someone in your family has an alcohol or drug problem.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
    - id: CSTRESS_Q18
      kind: Question
      title: People are too critical of you or what you do.
      input:
        control: Radio
        labels:
          1: 'True'
          2: 'False'
  - id: b_s24_first
    title: Recent Life Events
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
      hint: Asked only of adult respondents answering for themselves
    items:
    - id: RECENT_Q1
      kind: Question
      title: In the past 12 months, was any one of you beaten up or physically attacked?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          99: Refused
  - id: b_s24_events
    title: 'Recent Life Events: Family, Work and Finances'
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
      hint: Asked only of adult respondents answering for themselves
    - predicate: not (RECENT_Q1.outcome == 99)
      hint: Asked only when question RECENT-Q1 is not "Refused".
    items:
    - id: RECENT_Q2
      kind: Question
      title: In the past 12 months, did you or someone in your family, have an unwanted pregnancy?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RECENT_Q3
      kind: Question
      title: In the past 12 months, did you or someone in your family have an abortion or miscarriage?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RECENT_Q4
      kind: Question
      title: In the past 12 months, did you or someone in your family have a major financial crisis?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RECENT_Q5
      kind: Question
      title: In the past 12 months, did you or someone in your family fail school or a training program?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RECENT_Q6
      kind: Question
      title: In the past 12 months, did you (or your partner) experience a change of job for a worse one? (If marital status = married/living together/common-law include the phrase "or your partner")
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RECENT_Q7
      kind: Question
      title: In the past 12 months, were you (or your partner) demoted at work or did you/either of you take a cut in pay? (If marital status = married/living together/common-law include the phrase "or your partner")
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RECENT_Q8
      kind: Question
      title: In the past 12 months, did you have increased arguments with your partner?
      precondition:
      - predicate: MARITAL_STATUS.outcome in [1, 2]
        hint: Asked only when question MARITAL_STATUS is one of "Married", "Living with a partner / common-law".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RECENT_Q9
      kind: Question
      title: Now, just you personally, in the past 12 months, did you go on Welfare?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RECENT_Q10
      kind: Question
      title: In the past 12 months, did you have a child move back into the house?
      precondition:
      - predicate: CSTRESS_Q9.outcome == 1
        hint: Asked only when question CSTRESS-Q9 is "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s25_traum_q1
    title: 'Childhood and Adult Stressors: hospital stay'
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
      hint: Asked only of respondents aged 18 or older who are not answered by proxy
    items:
    - id: TRAUM_Q1
      kind: Question
      title: Did you spend 2 weeks or more in the hospital?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          99: Refused
  - id: b_s25_traum_rest
    title: 'Childhood and Adult Stressors: stressful events'
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
      hint: Asked only of respondents aged 18 or older who are not answered by proxy
    - predicate: not (TRAUM_Q1.outcome == 99)
      hint: Asked only when question TRAUM-Q1 is not "Refused".
    items:
    - id: TRAUM_Q2
      kind: Question
      title: Did your parents get a divorce?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: TRAUM_Q3
      kind: Question
      title: Did your father or mother not have a job for a long time when they wanted to be working?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: TRAUM_Q4
      kind: Question
      title: Did something happen that scared you so much you thought about it for years after?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: TRAUM_Q5
      kind: Question
      title: Were you sent away from home because you did something wrong?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: TRAUM_Q6
      kind: Question
      title: Did either of your parents drink or use drugs so often that it caused problems for the family?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: TRAUM_Q7
      kind: Question
      title: Were you ever physically abused by someone close to you?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s26_work_stress_first
    title: Work Stress
    precondition:
    - predicate: AGE_2.outcome >= 15 and PROXY_2.outcome == 0 and EMPLOYED.outcome == 1
      hint: Asked of currently employed respondents aged 15 or older who answer for themselves
    items:
    - id: WSTRESS_Q1a
      kind: Question
      title: 'Now I''m going to read you a series of statements that might describe your job situation. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE, or STRONGLY DISAGREE with each of the following: a) Your job requires that you learn new things (R on first item: go to next section)'
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
          99: Refused
  - id: b_s26_work_stress_rest
    title: 'Work Stress: job characteristics and satisfaction'
    precondition:
    - predicate: AGE_2.outcome >= 15 and PROXY_2.outcome == 0 and EMPLOYED.outcome == 1
      hint: Asked of currently employed respondents aged 15 or older who answer for themselves
    - predicate: not (WSTRESS_Q1a.outcome == 99)
      hint: Asked only when question WSTRESS-Q1a is not "Refused".
    items:
    - id: WSTRESS_Q1b
      kind: Question
      title: b) Your job requires a high level of skill
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1c
      kind: Question
      title: c) Your job allows you freedom to decide how you do your job
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1d
      kind: Question
      title: d) Your job requires that you do things over and over
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1e
      kind: Question
      title: e) Your job is very hectic
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1f
      kind: Question
      title: f) You are free from conflicting demands that others make
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1g
      kind: Question
      title: g) Your job security is good
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1h
      kind: Question
      title: h) Your job requires a lot of physical effort
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1i
      kind: Question
      title: i) You have a lot to say about what happens in your job
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1j
      kind: Question
      title: j) You are exposed to hostility or conflict from the people you work with
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1k
      kind: Question
      title: k) Your supervisor is helpful in getting the job done
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q1l
      kind: Question
      title: l) The people you work with are helpful in getting the job done
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: WSTRESS_Q2
      kind: Question
      title: How satisfied are you with your job? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Somewhat satisfied
          3: Not too satisfied
          4: Not at all satisfied
  - id: b_s27_esteem_first
    title: Self-Esteem
    precondition:
    - predicate: AGE_2.outcome >= 12 and PROXY_2.outcome == 0
      hint: Asked of respondents aged 12 or older who answer for themselves
    items:
    - id: ESTEEM_Q1a
      kind: Question
      title: 'Now, I am going to read you a series of statements that people might use to describe themselves. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE or STRONGLY DISAGREE with each of the following: a) You feel that you have a number of good qualities. (R on first item: go to next section)'
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
          99: Refused
  - id: b_s27_esteem_rest
    title: Self-Esteem (continued)
    precondition:
    - predicate: AGE_2.outcome >= 12 and PROXY_2.outcome == 0
      hint: Asked of respondents aged 12 or older who answer for themselves
    - predicate: not (ESTEEM_Q1a.outcome == 99)
      hint: Asked only when question ESTEEM-Q1a is not "Refused".
    items:
    - id: ESTEEM_Q1b
      kind: Question
      title: b) You feel that you're a person of worth at least equal to others.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: ESTEEM_Q1c
      kind: Question
      title: c) You are able to do things as well as most other people.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: ESTEEM_Q1d
      kind: Question
      title: d) You take a positive attitude toward yourself.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: ESTEEM_Q1e
      kind: Question
      title: e) On the whole you are satisfied with yourself.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: ESTEEM_Q1f
      kind: Question
      title: f) All in all, you're inclined to feel you're a failure.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
  - id: b_s27_mastery_first
    title: Mastery
    precondition:
    - predicate: AGE_2.outcome > 12 and PROXY_2.outcome == 0
      hint: Asked of respondents older than 12 who answer for themselves
    items:
    - id: MAST_Q1a
      kind: Question
      title: 'a) You have little control over the things that happen to you. (R on first item: go to next section)'
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
          99: Refused
  - id: b_s27_mastery_rest
    title: Mastery (continued)
    precondition:
    - predicate: AGE_2.outcome > 12 and PROXY_2.outcome == 0
      hint: Asked of respondents older than 12 who answer for themselves
    - predicate: not (MAST_Q1a.outcome == 99)
      hint: Asked only when question MAST-Q1a is not "Refused".
    items:
    - id: MAST_Q1b
      kind: Question
      title: b) There is really no way you can solve some of the problems you have.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: MAST_Q1c
      kind: Question
      title: c) There is little you can do to change many of the important things in your life.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: MAST_Q1d
      kind: Question
      title: d) You often feel helpless in dealing with problems of life.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: MAST_Q1e
      kind: Question
      title: e) Sometimes you feel that you are being pushed around in life.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: MAST_Q1f
      kind: Question
      title: f) What happens to you in the future mostly depends on you.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: MAST_Q1g
      kind: Question
      title: g) You can do just about anything you really set your mind to.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
  - id: b_s28_screen
    title: Sense of Coherence
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
    items:
    - id: SCOH_Q1
      kind: Question
      title: In this first question 1 means very seldom or never and 7 means very often. How often do you have the feeling that you don't really care about what goes on around you?
      input:
        control: Radio
        labels:
          1: Very seldom or never
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very often
          97: Don't know
          99: Refused
  - id: b_s28_scale
    title: Sense of Coherence (continued)
    precondition:
    - predicate: AGE_2.outcome >= 18 and PROXY_2.outcome == 0
    - predicate: not (SCOH_Q1.outcome in [97, 99])
      hint: Asked only when question SCOH-Q1 is none of "Don't know", "Refused".
    items:
    - id: SCOH_Q2
      kind: Question
      title: In this question 1 that means it has never happened and 7 means it has always happened. How often in the past were you surprised by the behaviour of people whom you thought you knew well?
      input:
        control: Radio
        labels:
          1: Never happened
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Always happened
    - id: SCOH_Q3
      kind: Question
      title: In this question 1 means that it has never happened and 7 means it has always happened. How often have people you counted on disappointed you?
      input:
        control: Radio
        labels:
          1: Never happened
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Always happened
    - id: SCOH_Q4
      kind: Question
      title: In this question 1 means very often and 7 means very seldom or never. How often do you have the feeling you're being treated unfairly?
      input:
        control: Radio
        labels:
          1: Very often
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very seldom or never
    - id: SCOH_Q5
      kind: Question
      title: In this question 1 means very often and 7 means very seldom or never. How often do you have the feeling you are in an unfamiliar situation and don't know what to do?
      input:
        control: Radio
        labels:
          1: Very often
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very seldom or never
    - id: SCOH_Q6
      kind: Question
      title: In this question 1 means very often and 7 means very seldom or never. How often do you have very mixed-up feelings and ideas?
      input:
        control: Radio
        labels:
          1: Very often
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very seldom or never
    - id: SCOH_Q7
      kind: Question
      title: In this question 1 means very often and 7 means very seldom or never. how often do you have feelings inside that you would rather not feel?
      input:
        control: Radio
        labels:
          1: Very often
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very seldom or never
    - id: SCOH_Q8
      kind: Question
      title: In this question 1 means very seldom or never and 7 means very often. Many people -- even those with a strong character -- sometimes feel like sad sacks (losers) in certain situations. How often have you felt this way in the past?
      input:
        control: Radio
        labels:
          1: Very seldom or never
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very often
    - id: SCOH_Q9
      kind: Question
      title: In this question 1 means very often and 7 means very seldom or never. How often do you have the feeling that there's little meaning in the things you do in your daily life?
      input:
        control: Radio
        labels:
          1: Very often
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very seldom or never
    - id: SCOH_Q10
      kind: Question
      title: In this question 1 means very often and 7 means very seldom or never. How often do you have feelings that you're not sure you can keep under control?
      input:
        control: Radio
        labels:
          1: Very often
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very seldom or never
    - id: SCOH_Q11
      kind: Question
      title: In this question 1 means no clear goals or purpose and 7 means very clear goals and purpose. Until now your life has had no clear goals or purpose or has it had very clear goals and purpose?
      input:
        control: Radio
        labels:
          1: No clear goals or no purpose at all
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: Very clear goals and purpose
    - id: SCOH_Q12
      kind: Question
      title: In this question 1 means you overestimate or underestimate importance and 7 means you see things in the right proportion. When something happens, you generally find that you overestimate or underestimate its importance or you see things in the right proportion?
      input:
        control: Radio
        labels:
          1: Overestimate or underestimate its importance
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: See things in the right proportion
    - id: SCOH_Q13
      kind: Question
      title: In this question 1 means a source of great pleasure and satisfaction and 7 means a source of pain and boredom. Is doing the things you do every day a source of great pleasure and satisfaction or a source of pain and boredom?
      input:
        control: Radio
        labels:
          1: A great deal of pleasure and satisfaction
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: A source of pain and boredom
  - id: b_s29_vision
    title: Vision
    items:
    - id: HSTAT_Q1
      kind: Question
      title: Are/Is ... usually able to see well enough to read ordinary newsprint without glasses or contact lenses?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
  - id: b_s29_vision_aided
    title: Vision with glasses
    precondition:
    - predicate: not (HSTAT_Q1.outcome == 1)
      hint: Asked only when question HSTAT-Q1 is not "Yes".
    - predicate: not (HSTAT_Q1.outcome in [97, 99])
      hint: Asked only when question HSTAT-Q1 is none of "Don't know", "Refused".
    items:
    - id: HSTAT_Q2
      kind: Question
      title: Are/Is you/he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: HSTAT_Q3
      kind: Question
      title: Are/Is you/he/she able to see at all?
      precondition:
      - predicate: not (HSTAT_Q2.outcome == 1)
        hint: Asked only when question HSTAT-Q2 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
  - id: b_s29_vision_distance
    title: Vision at a distance
    precondition:
    - predicate: not (HSTAT_Q1.outcome in [97, 99])
      hint: Asked only when question HSTAT-Q1 is none of "Don't know", "Refused".
    - predicate: not (HSTAT_Q3.outcome in [2, 97, 99])
      hint: Asked only when question HSTAT-Q3 is none of "No", "Don't know", "Refused".
    items:
    - id: HSTAT_Q4
      kind: Question
      title: Are/Is you/he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses ?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
    - id: HSTAT_Q5
      kind: Question
      title: Are/Is you/he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?
      precondition:
      - predicate: not (HSTAT_Q4.outcome in [1, 97, 99])
        hint: Asked only when question HSTAT-Q4 is none of "Yes", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s29_hearing
    title: Hearing
    items:
    - id: HSTAT_Q6
      kind: Question
      title: Are/Is ... usually able to hear what is said in a group conversation with at least three other people without a hearing aid?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
  - id: b_s29_hearing_aided
    title: Hearing follow-ups
    precondition:
    - predicate: not (HSTAT_Q6.outcome in [1, 97, 99])
      hint: Asked only when question HSTAT-Q6 is none of "Yes", "Don't know", "Refused".
    items:
    - id: HSTAT_Q7
      kind: Question
      title: Are/Is you/he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: HSTAT_Q7a
      kind: Question
      title: Are/Is you/he/she able to hear at all?
      precondition:
      - predicate: not (HSTAT_Q7.outcome == 1)
        hint: Asked only when question HSTAT-Q7 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
    - id: HSTAT_Q8
      kind: Question
      title: Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid ?
      precondition:
      - predicate: not (HSTAT_Q7a.outcome in [2, 97, 99])
        hint: Asked only when question HSTAT-Q7a is none of "No", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          99: Refused
    - id: HSTAT_Q9
      kind: Question
      title: Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?
      precondition:
      - predicate: not (HSTAT_Q7a.outcome in [2, 97, 99])
        hint: Asked only when question HSTAT-Q7a is none of "No", "Don't know", "Refused".
      - predicate: not (HSTAT_Q8.outcome in [1, 99])
        hint: Asked only when question HSTAT-Q8 is none of "Yes", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s29_speech
    title: Speech
    items:
    - id: HSTAT_Q10
      kind: Question
      title: Are/Is ... usually able to be understood completely when speaking with strangers in your own language?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          99: Refused
  - id: b_s29_speech_follow
    title: Speech follow-ups
    precondition:
    - predicate: not (HSTAT_Q10.outcome in [1, 99])
      hint: Asked only when question HSTAT-Q10 is none of "Yes", "Refused".
    items:
    - id: HSTAT_Q11
      kind: Question
      title: Are/Is you/he/she able to be understood partially when speaking with strangers?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: HSTAT_Q12
      kind: Question
      title: Are/Is you/he/she able to be understood completely when speaking with those who know you/him/her well?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          99: Refused
    - id: HSTAT_Q13
      kind: Question
      title: Are/Is you/he/she able to be understood partially when speaking with those who know you/him/her well?
      precondition:
      - predicate: not (HSTAT_Q12.outcome in [1, 99])
        hint: Asked only when question HSTAT-Q12 is none of "Yes", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s29_mobility
    title: Mobility
    items:
    - id: HSTAT_Q14
      kind: Question
      title: Are/Is ... usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
  - id: b_s29_mobility_follow
    title: Mobility follow-ups
    precondition:
    - predicate: not (HSTAT_Q14.outcome in [1, 97, 99])
      hint: Asked only when question HSTAT-Q14 is none of "Yes", "Don't know", "Refused".
    items:
    - id: HSTAT_Q15
      kind: Question
      title: Are/Is you/he/she able to walk at all?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
    - id: HSTAT_Q16
      kind: Question
      title: Do/Does you/he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?
      precondition:
      - predicate: not (HSTAT_Q15.outcome in [2, 97, 99])
        hint: Asked only when question HSTAT-Q15 is none of "No", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: HSTAT_Q17
      kind: Question
      title: Do/Does you/he/she require the help of another person to be able to walk?
      precondition:
      - predicate: not (HSTAT_Q15.outcome in [2, 97, 99])
        hint: Asked only when question HSTAT-Q15 is none of "No", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: HSTAT_Q18
      kind: Question
      title: Do/Does you/he/she require a wheelchair to get around?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
    - id: HSTAT_Q19
      kind: Question
      title: How often do/does you/he/she use a wheelchair? (Read list. Mark one only.)
      precondition:
      - predicate: HSTAT_Q18.outcome == 1
        hint: Asked only when question HSTAT-Q18 is "Yes".
      - predicate: not (HSTAT_Q18.outcome in [2, 97, 99])
        hint: Asked only when question HSTAT-Q18 is none of "No", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Never
    - id: HSTAT_Q20
      kind: Question
      title: Do/Does you/he/she need the help of another person to get around in the wheelchair?
      precondition:
      - predicate: HSTAT_Q18.outcome == 1
        hint: Asked only when question HSTAT-Q18 is "Yes".
      - predicate: not (HSTAT_Q18.outcome in [2, 97, 99])
        hint: Asked only when question HSTAT-Q18 is none of "No", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s29_dexterity
    title: Dexterity
    items:
    - id: HSTAT_Q21
      kind: Question
      title: Are/Is ... usually able to grasp and handle small objects such as a pencil and scissors?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
  - id: b_s29_dexterity_follow
    title: Dexterity follow-ups
    precondition:
    - predicate: not (HSTAT_Q21.outcome in [1, 97, 99])
      hint: Asked only when question HSTAT-Q21 is none of "Yes", "Don't know", "Refused".
    items:
    - id: HSTAT_Q22
      kind: Question
      title: Do/Does you/he/she require the help of another person because of limitations in the use of hands or fingers?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
    - id: HSTAT_Q23
      kind: Question
      title: 'Do/Does you/he/she require the help of another person with: (Read list. Mark one only.)'
      precondition:
      - predicate: HSTAT_Q22.outcome == 1
        hint: Asked only when question HSTAT-Q22 is "Yes".
      - predicate: not (HSTAT_Q22.outcome in [2, 97, 99])
        hint: Asked only when question HSTAT-Q22 is none of "No", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: Some tasks?
          2: Most tasks?
          3: Almost all tasks?
          4: All tasks?
    - id: HSTAT_Q24
      kind: Question
      title: Do/Does you/he/she require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s29_feelings_cognition
    title: Feelings, memory and thinking
    items:
    - id: HSTAT_Q25
      kind: Question
      title: 'Would you describe yourself/... as being usually: (Read list. Mark one only.)'
      input:
        control: Radio
        labels:
          1: Happy and interested in life?
          2: Somewhat happy?
          3: Somewhat unhappy?
          4: Unhappy with little interest in life?
          5: So unhappy that life is not worthwhile?
    - id: HSTAT_Q26
      kind: Question
      title: 'How would you describe your/his/her usual ability to remember things? Are/Is you/he/she: (Read list. Mark one only.)'
      input:
        control: Radio
        labels:
          1: Able to remember most things?
          2: Somewhat forgetful?
          3: Very forgetful?
          4: Unable to remember anything at all?
    - id: HSTAT_Q27
      kind: Question
      title: 'How would you describe your/his/her usual ability to think and solve day to day problems? Are/Is you/he/she: (Read list. Mark one only.)'
      input:
        control: Radio
        labels:
          1: Able to think clearly and solve problems?
          2: Having a little difficulty?
          3: Having some difficulty?
          4: Having a great deal of difficulty?
          5: Unable to think or solve problems?
  - id: b_s29_pain
    title: Pain
    items:
    - id: HSTAT_Q28
      kind: Question
      title: Are/Is ... usually free of pain or discomfort?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: Don't know
          99: Refused
  - id: b_s29_pain_follow
    title: Pain follow-ups
    precondition:
    - predicate: HSTAT_Q28.outcome == 2
      hint: Asked only when question HSTAT-Q28 is "No".
    - predicate: not (HSTAT_Q28.outcome in [1, 97, 99])
      hint: Asked only when question HSTAT-Q28 is none of "Yes", "Don't know", "Refused".
    items:
    - id: HSTAT_Q29
      kind: Question
      title: How would you describe the usual intensity of your/his/her pain or discomfort? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Mild
          2: Moderate
          3: Severe
    - id: HSTAT_Q30
      kind: Question
      title: How many activities does your/his/her pain or discomfort prevent? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: None
          2: A few
          3: Some
          4: Most
  - id: b_s30_drug_use
    title: Drug Use
    items:
    - id: DRUG_Q1
      kind: Question
      title: In the past month4, did ... take any of the following medications? (Read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: Pain relievers such as aspirin or tylenol (includes arthritis medicine and anti-inflammatories)
          2: Tranquilizers such as valium
          4: Diet pills
          8: Anti-depressants
          16: Codeine, Demerol or Morphine
          32: Allergy medicine such as "Sinutab"
          64: Asthma medications
          128: Cough or cold remedies
          256: Penicillin or other antibiotic
          512: Medicine for the heart
          1024: Medicine for blood pressure
          2048: Diuretics or water pills
          4096: Steroids
          8192: Insulin
          16384: Pills to control diabetes
          32768: Sleeping pills
          65536: Stomach remedies
          131072: Laxatives
          262144: 'Hormones for menopause or aging symptoms (check item: sex=female, age >= 30)'
          524288: 'Birth control pills (check item: sex=female, age >= 12 & age <= 49)'
          1048576: Any other medication (Specify_________)
          2097152: None of the above
      postcondition:
      - predicate: not (DRUG_Q1.outcome & 2097152 > 0 and DRUG_Q1.outcome & 2097151 > 0)
        hint: 'DRUG-Q1: ''None of the above'' cannot be ticked together with any medication.'
        invented: true
      - predicate: not (DRUG_Q1.outcome & 262144 > 0) or (SEX_2.outcome == 2 and AGE_2.outcome >= 30)
        hint: 'DRUG-Q1: hormones for menopause or aging symptoms apply only to females aged 30 or over.'
        invented: true
      - predicate: not (DRUG_Q1.outcome & 524288 > 0) or (SEX_2.outcome == 2 and AGE_2.outcome >= 12 and AGE_2.outcome <= 49)
        hint: 'DRUG-Q1: birth control pills apply only to females aged 12 to 49.'
        invented: true
    - id: DRUG_Q2
      kind: Question
      title: Now, I am referring to yesterday and the day before yesterday. During those two days, how many different medications did you/he/she take? (Number of different medications)
      precondition:
      - predicate: DRUG_Q1.outcome & 2097151 > 0
      - predicate: not (DRUG_Q1.outcome & 2097151 == 0)
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s31_preamble
    title: Interview setup
    precondition:
    - predicate: not (DRUG_Q1.outcome & 2097151 == 0)
      hint: Asked only when DRUG-Q1 has at least one medication or product selected.
    - predicate: not (DRUG_Q2.outcome in [0, 97, 99])
      hint: Asked only when question DRUG-Q2 is none of 0, 97, 99.
    items:
    - id: PROXY_3
      kind: Question
      title: 'Proxy flag: the interview is answered by a proxy respondent (routing reads ''(Non-proxy only)''); value comes from the interview/sample record, not collected by a question'
      external: true
      input:
        control: Radio
        labels:
          0: Non-proxy
          1: Proxy
    - id: AGE_3
      kind: Question
      title: Age of respondent in years (routing reads '(Age >= 18 and non-proxy only)'); value comes from the household/sample record
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s31_medication_name
    title: Medication name
    items:
    - id: DRUG_Q3
      kind: Question
      title: What is the exact name of the medication that ... took? (Ask the person to look at the bottle, tube or box.) DK, R to any medication (Go to next section)
      precondition:
      - predicate: not (DRUG_Q1.outcome & 2097151 == 0)
        hint: Asked only when DRUG-Q1 has at least one medication or product selected.
      - predicate: not (DRUG_Q2.outcome in [0, 97, 99])
        hint: Asked only when question DRUG-Q2 is none of 0, 97, 99.
      input:
        control: Textarea
        maxLength: 200
  - id: b_s31_health_products
    title: Other health products
    items:
    - id: DRUG_Q4
      kind: Question
      title: There are many other health products such as ointments, vitamins, herbs, minerals, teas or protein drinks which people use to prevent illness or to improve or maintain their health. Do/Does ... use any of these or other health products?
      precondition:
      - predicate: not (DRUG_Q3.outcome in [97, 98])
        hint: Asked only when question DRUG-Q3 is none of 97, 98.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
    - id: DRUG_Q5
      kind: Question
      title: What is the exact name of the health product that ... use(s)? (Ask the person to look at the bottle, tube or box.) (up to 12 products)
      precondition:
      - predicate: DRUG_Q4.outcome == 1
        hint: Asked only when question DRUG-Q4 is "Yes".
      - predicate: not (DRUG_Q3.outcome in [97, 98])
        hint: Asked only when question DRUG-Q3 is none of 97, 98.
      - predicate: not (DRUG_Q4.outcome == 2)
        hint: Asked only when question DRUG-Q4 is not "No".
      - predicate: not (DRUG_Q4.outcome in [97, 98])
        hint: Asked only when question DRUG-Q4 is none of "DK", "R".
      input:
        control: Textarea
        maxLength: 500
  - id: b_s32_p1_feelings
    title: 'Mental Health: Past Month Feelings'
    precondition:
    - predicate: PROXY_3.outcome == 0
      hint: Asked only when question PROXY is "Non-proxy".
    items:
    - id: MHLTH_Q1a
      kind: Question
      title: '... so sad that nothing could cheer you up? (Read list. Mark one only.) [During the past month, about how often did you feel:]'
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
          97: DK
          98: R
    - id: MHLTH_Q1b
      kind: Question
      title: '... nervous? (Read list. Mark one only.)'
      precondition:
      - predicate: not (MHLTH_Q1a.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1a is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
          97: DK
          98: R
    - id: MHLTH_Q1c
      kind: Question
      title: '... restless or fidgety? (Read list. Mark one only.)'
      precondition:
      - predicate: not (MHLTH_Q1a.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1a is none of "DK", "R".
      - predicate: not (MHLTH_Q1b.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1b is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
          97: DK
          98: R
    - id: MHLTH_Q1d
      kind: Question
      title: '... hopeless? (Read list. Mark one only.)'
      precondition:
      - predicate: not (MHLTH_Q1a.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1a is none of "DK", "R".
      - predicate: not (MHLTH_Q1b.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1b is none of "DK", "R".
      - predicate: not (MHLTH_Q1c.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1c is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
          97: DK
          98: R
    - id: MHLTH_Q1e
      kind: Question
      title: '... worthless? (Read list. Mark one only.)'
      precondition:
      - predicate: not (MHLTH_Q1a.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1a is none of "DK", "R".
      - predicate: not (MHLTH_Q1b.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1b is none of "DK", "R".
      - predicate: not (MHLTH_Q1c.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1c is none of "DK", "R".
      - predicate: not (MHLTH_Q1d.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1d is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
          97: DK
          98: R
    - id: MHLTH_Q1f
      kind: Question
      title: During the past month, about how often did you feel that everything was an effort? (Read list. Mark one only.)
      precondition:
      - predicate: not (MHLTH_Q1a.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1a is none of "DK", "R".
      - predicate: not (MHLTH_Q1b.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1b is none of "DK", "R".
      - predicate: not (MHLTH_Q1c.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1c is none of "DK", "R".
      - predicate: not (MHLTH_Q1d.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1d is none of "DK", "R".
      - predicate: not (MHLTH_Q1e.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1e is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
          97: DK
          98: R
  - id: b_s32_p1_change
    title: 'Mental Health: Change and Interference'
    precondition:
    - predicate: not (MHLTH_Q1a.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q1a is none of "DK", "R".
    - predicate: not (MHLTH_Q1b.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q1b is none of "DK", "R".
    - predicate: not (MHLTH_Q1c.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q1c is none of "DK", "R".
    - predicate: not (MHLTH_Q1d.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q1d is none of "DK", "R".
    - predicate: not (MHLTH_Q1e.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q1e is none of "DK", "R".
    - predicate: not (MHLTH_Q1f.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q1f is none of "DK", "R".
    - predicate: not (MHLTH_Q1a.outcome == 5 and MHLTH_Q1b.outcome == 5 and MHLTH_Q1c.outcome == 5 and MHLTH_Q1d.outcome == 5 and MHLTH_Q1e.outcome == 5 and MHLTH_Q1f.outcome == 5)
      hint: Asked only when at least one past-month feeling occurred.
    items:
    - id: MHLTH_Q1g
      kind: Question
      title: We have just been talking about feelings and experiences that occurred to different degrees during the past month. Taking them altogether, did these feelings occur more often in the past month than is usual for you, less often than usual , or about the same as usual? (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: More often
          2: Less often
          3: About the same
          4: Never have had any
          97: DK
          98: R
    - id: MHLTH_Q1h
      kind: Question
      title: Is that a lot more, somewhat or only a little more often than usual? (Do not read list. Mark one only.)
      precondition:
      - predicate: MHLTH_Q1g.outcome == 1
        hint: Asked only when question MHLTH-Q1g is "More often".
      input:
        control: Radio
        labels:
          1: A lot more
          2: Somewhat more
          3: A little more
          97: DK
          98: R
    - id: MHLTH_Q1i
      kind: Question
      title: Is that a lot less, somewhat or only a little less often than usual? (Do not read list. Mark one only.)
      precondition:
      - predicate: MHLTH_Q1g.outcome == 2
        hint: Asked only when question MHLTH-Q1g is "Less often".
      - predicate: not (MHLTH_Q1g.outcome == 3)
        hint: Asked only when question MHLTH-Q1g is not "About the same".
      - predicate: not (MHLTH_Q1g.outcome == 4)
        hint: Asked only when question MHLTH-Q1g is not "Never have had any".
      - predicate: not (MHLTH_Q1g.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1g is none of "DK", "R".
      - predicate: not (MHLTH_Q1h.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1h is none of "DK", "R".
      - predicate: not (MHLTH_Q1h.outcome in [1, 2, 3])
        hint: Asked only when question MHLTH-Q1h is none of "A lot more", "Somewhat more", "A little more".
      input:
        control: Radio
        labels:
          1: A lot less
          2: Somewhat less
          3: A little less
          97: DK
          98: R
    - id: MHLTH_Q1j
      kind: Question
      title: How much do these experiences usually interfere with your life or activities? (Read list. Mark one only.)
      precondition:
      - predicate: not (MHLTH_Q1g.outcome == 4)
        hint: Asked only when question MHLTH-Q1g is not "Never have had any".
      - predicate: not (MHLTH_Q1g.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1g is none of "DK", "R".
      - predicate: not (MHLTH_Q1h.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1h is none of "DK", "R".
      - predicate: not (MHLTH_Q1i.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q1i is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: A lot
          2: Some
          3: A little
          4: Not at all
  - id: b_s32_p1_help
    title: 'Mental Health: Help Seeking'
    items:
    - id: MHLTH_Q1k
      kind: Question
      title: In the past 12 months2, have you seen or talked on the telephone to a health professional about your emotional or mental health?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q1l
      kind: Question
      title: 'How many times (in the past 12 months)? # of times'
      precondition:
      - predicate: MHLTH_Q1k.outcome == 1
        hint: Asked only when question MHLTH-Q1k is "Yes".
      input:
        control: Editbox
        min: 0
        max: 999
        right: times
  - id: b_s32_p1_screen
    title: 'Mental Health: Sad, Blue or Depressed Screener'
    items:
    - id: MHLTH_Q2
      kind: Question
      title: During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
  - id: b_s32_p1_worst
    title: 'Mental Health: Worst 2-Week Period'
    precondition:
    - predicate: not (MHLTH_Q2.outcome == 2)
      hint: Asked only when question MHLTH-Q2 is not "No".
    - predicate: not (MHLTH_Q2.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q2 is none of "DK", "R".
    items:
    - id: MHLTH_Q3
      kind: Question
      title: For the next few questions, please think of the 2-week period during the past 12 months when these feelings were worst. During that time how long did these feelings usually last? (Read list. Mark one only.)
      precondition:
      - predicate: MHLTH_Q2.outcome == 1
        hint: Asked only when question MHLTH-Q2 is "Yes".
      input:
        control: Radio
        labels:
          1: All day long
          2: Most of the day
          3: About half of the day
          4: Less than half the day
          97: DK
          98: R
  - id: b_s32_p1_frequency
    title: 'Mental Health: Frequency'
    precondition:
    - predicate: not (MHLTH_Q2.outcome == 2)
      hint: Asked only when question MHLTH-Q2 is not "No".
    - predicate: not (MHLTH_Q2.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q2 is none of "DK", "R".
    - predicate: not (MHLTH_Q3.outcome in [3, 4])
      hint: Asked only when question MHLTH-Q3 is none of "About half of the day", "Less than half the day".
    - predicate: not (MHLTH_Q3.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q3 is none of "DK", "R".
    items:
    - id: MHLTH_Q4
      kind: Question
      title: How often did you feel this way during those 2 weeks? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Every day
          2: Almost every day
          3: Less often
          97: DK
          98: R
  - id: b_s32_p1_symptoms
    title: 'Mental Health: Associated Symptoms'
    precondition:
    - predicate: not (MHLTH_Q2.outcome == 2)
      hint: Asked only when question MHLTH-Q2 is not "No".
    - predicate: not (MHLTH_Q2.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q2 is none of "DK", "R".
    - predicate: not (MHLTH_Q3.outcome in [3, 4])
      hint: Asked only when question MHLTH-Q3 is none of "About half of the day", "Less than half the day".
    - predicate: not (MHLTH_Q3.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q3 is none of "DK", "R".
    - predicate: not (MHLTH_Q4.outcome == 3)
      hint: Asked only when question MHLTH-Q4 is not "Less often".
    - predicate: not (MHLTH_Q4.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q4 is none of "DK", "R".
    items:
    - id: MHLTH_Q5
      kind: Question
      title: During those 2 weeks did you lose interest in most things?
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = LOSING INTEREST)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q6
      kind: Question
      title: Did you feel tired out or low on energy all of the time?
      precondition:
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = FEELING TIRED)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q7
      kind: Question
      title: Did you gain weight, lose weight or stay about the same? (Do not read list. Mark one only.)
      precondition:
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      - predicate: not (MHLTH_Q6.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: Gained weight (KEY PHRASE = GAINING WEIGHT)
          2: Lost weight (KEY PHRASE = LOSING WEIGHT)
          3: Stayed about the same
          4: Was on a diet
          97: DK
          98: R
    - id: MHLTH_Q8
      kind: Question
      title: About how much did you (gain/lose)? ___ pounds or kilograms
      precondition:
      - predicate: MHLTH_Q7.outcome in [1, 2]
        hint: Asked only when question MHLTH-Q7 is one of "Gained weight", "Lost weight".
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      - predicate: not (MHLTH_Q6.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
      - predicate: not (MHLTH_Q7.outcome in [3, 4])
        hint: Asked only when question MHLTH-Q7 is none of "Stayed about the same", "Was on a diet".
      - predicate: not (MHLTH_Q7.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
      input:
        control: Editbox
        min: 0
        max: 500
        right: pounds or kilograms
    - id: MHLTH_Q9
      kind: Question
      title: Did you have more trouble falling asleep than you usually do?
      precondition:
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      - predicate: not (MHLTH_Q6.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
      - predicate: not (MHLTH_Q7.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = TROUBLE FALLING ASLEEP)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q10
      kind: Question
      title: How often did that happen? (Read list. Mark one only.)
      precondition:
      - predicate: MHLTH_Q9.outcome == 1
        hint: Asked only when question MHLTH-Q9 is "Yes".
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      - predicate: not (MHLTH_Q6.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
      - predicate: not (MHLTH_Q7.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
      - predicate: not (MHLTH_Q9.outcome == 2)
        hint: Asked only when question MHLTH-Q9 is not "No".
      - predicate: not (MHLTH_Q9.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: Every night
          2: Nearly every night
          3: Less often
          97: DK
          98: R
    - id: MHLTH_Q11
      kind: Question
      title: Did you have a lot more trouble concentrating than usual?
      precondition:
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      - predicate: not (MHLTH_Q6.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
      - predicate: not (MHLTH_Q7.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
      - predicate: not (MHLTH_Q9.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
      - predicate: not (MHLTH_Q10.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q10 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = TROUBLE CONCENTRATING)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q12
      kind: Question
      title: At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?
      precondition:
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      - predicate: not (MHLTH_Q6.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
      - predicate: not (MHLTH_Q7.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
      - predicate: not (MHLTH_Q9.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
      - predicate: not (MHLTH_Q10.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q10 is none of "DK", "R".
      - predicate: not (MHLTH_Q11.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q11 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = FEELING DOWN ON YOURSELF)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q13
      kind: Question
      title: Did you think a lot about death - either your own, someone else's, or death in general?
      precondition:
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      - predicate: not (MHLTH_Q6.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
      - predicate: not (MHLTH_Q7.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
      - predicate: not (MHLTH_Q9.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
      - predicate: not (MHLTH_Q10.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q10 is none of "DK", "R".
      - predicate: not (MHLTH_Q11.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q11 is none of "DK", "R".
      - predicate: not (MHLTH_Q12.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q12 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE =THOUGHTS ABOUT DEATH)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q14
      kind: Question
      title: 'Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you were sad, blue, or depressed and also had some other things like (KEY PHRASES). About how many weeks altogether did you feel this way during the past 12 months? # of weeks (IF >51 weeks then go to next section.)'
      precondition:
      - predicate: MHLTH_Q5.outcome == 1 or MHLTH_Q6.outcome == 1 or MHLTH_Q9.outcome == 1 or MHLTH_Q11.outcome == 1 or MHLTH_Q12.outcome == 1 or MHLTH_Q13.outcome == 1 or MHLTH_Q7.outcome in [1, 2]
        hint: Asked only when at least one associated symptom was reported.
      - predicate: not (MHLTH_Q5.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
      - predicate: not (MHLTH_Q6.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
      - predicate: not (MHLTH_Q7.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
      - predicate: not (MHLTH_Q9.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
      - predicate: not (MHLTH_Q10.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q10 is none of "DK", "R".
      - predicate: not (MHLTH_Q11.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q11 is none of "DK", "R".
      - predicate: not (MHLTH_Q12.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q12 is none of "DK", "R".
      - predicate: not (MHLTH_Q13.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q13 is none of "DK", "R".
      input:
        control: Editbox
        min: 0
        max: 98
        right: weeks (97 = DK, 98 = R)
  - id: b_s32_p1_lastepisode
    title: 'Mental Health: Month of Last Episode'
    precondition:
    - predicate: not (MHLTH_Q2.outcome == 2)
      hint: Asked only when question MHLTH-Q2 is not "No".
    - predicate: not (MHLTH_Q2.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q2 is none of "DK", "R".
    - predicate: not (MHLTH_Q3.outcome in [3, 4])
      hint: Asked only when question MHLTH-Q3 is none of "About half of the day", "Less than half the day".
    - predicate: not (MHLTH_Q3.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q3 is none of "DK", "R".
    - predicate: not (MHLTH_Q4.outcome == 3)
      hint: Asked only when question MHLTH-Q4 is not "Less often".
    - predicate: not (MHLTH_Q4.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q4 is none of "DK", "R".
    - predicate: not (MHLTH_Q5.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
    - predicate: not (MHLTH_Q6.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
    - predicate: not (MHLTH_Q7.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
    - predicate: not (MHLTH_Q9.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
    - predicate: not (MHLTH_Q10.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q10 is none of "DK", "R".
    - predicate: not (MHLTH_Q11.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q11 is none of "DK", "R".
    - predicate: not (MHLTH_Q12.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q12 is none of "DK", "R".
    - predicate: not (MHLTH_Q13.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q13 is none of "DK", "R".
    - predicate: MHLTH_Q5.outcome == 1 or MHLTH_Q6.outcome == 1 or MHLTH_Q9.outcome == 1 or MHLTH_Q11.outcome == 1 or MHLTH_Q12.outcome == 1 or MHLTH_Q13.outcome == 1 or MHLTH_Q7.outcome in [1, 2]
      hint: Asked only when at least one associated symptom was reported.
    - predicate: MHLTH_Q14.outcome is not None and MHLTH_Q14.outcome >= 0 and MHLTH_Q14.outcome <= 51
      hint: Asked only when the total weeks felt this way is between 0 and 51.
    - predicate: not (MHLTH_Q14.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q14 is none of "DK", "R".
    items:
    - id: MHLTH_Q15
      kind: Question
      title: Think about the last time you felt this way for 2 weeks or more in a row. In what month was that?
      input:
        control: Dropdown
        labels:
          1: January
          2: February
          3: March
          4: April
          5: May
          6: June
          7: July
          8: August
          9: September
          10: October
          11: November
          12: December
  - id: b_s32_p1_interest_screen
    title: 'Mental Health: Loss of Interest Screener'
    precondition:
    - predicate: not (MHLTH_Q2.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q2 is none of "DK", "R".
    - predicate: not (MHLTH_Q3.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q3 is none of "DK", "R".
    - predicate: not (MHLTH_Q4.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q4 is none of "DK", "R".
    - predicate: not (MHLTH_Q5.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
    - predicate: not (MHLTH_Q6.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
    - predicate: not (MHLTH_Q7.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
    - predicate: not (MHLTH_Q9.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
    - predicate: not (MHLTH_Q10.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q10 is none of "DK", "R".
    - predicate: not (MHLTH_Q11.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q11 is none of "DK", "R".
    - predicate: not (MHLTH_Q12.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q12 is none of "DK", "R".
    - predicate: not (MHLTH_Q13.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q13 is none of "DK", "R".
    - predicate: MHLTH_Q5.outcome == 1 or MHLTH_Q6.outcome == 1 or MHLTH_Q9.outcome == 1 or MHLTH_Q11.outcome == 1 or MHLTH_Q12.outcome == 1 or MHLTH_Q13.outcome == 1 or MHLTH_Q7.outcome in [1, 2]
      hint: Asked only when at least one associated symptom was reported.
    - predicate: not (MHLTH_Q14.outcome is not None and MHLTH_Q14.outcome > 51)
      hint: Skipped when the total weeks felt this way exceeds 51.
    - predicate: not (MHLTH_Q14.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q14 is none of "DK", "R".
    - predicate: not (MHLTH_Q15.outcome is not None and MHLTH_Q15.outcome >= 1)
      hint: Skipped when the month of the last episode was already given.
    items:
    - id: MHLTH_Q16
      kind: Question
      title: During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work, or activities that usually give you pleasure?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
  - id: b_s32_p1_interest_worst
    title: 'Mental Health: Loss of Interest, Worst 2 Weeks'
    precondition:
    - predicate: not (MHLTH_Q2.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q2 is none of "DK", "R".
    - predicate: not (MHLTH_Q3.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q3 is none of "DK", "R".
    - predicate: not (MHLTH_Q4.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q4 is none of "DK", "R".
    - predicate: not (MHLTH_Q5.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
    - predicate: not (MHLTH_Q6.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
    - predicate: not (MHLTH_Q7.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
    - predicate: not (MHLTH_Q9.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
    - predicate: not (MHLTH_Q10.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q10 is none of "DK", "R".
    - predicate: not (MHLTH_Q11.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q11 is none of "DK", "R".
    - predicate: not (MHLTH_Q12.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q12 is none of "DK", "R".
    - predicate: not (MHLTH_Q13.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q13 is none of "DK", "R".
    - predicate: MHLTH_Q5.outcome == 1 or MHLTH_Q6.outcome == 1 or MHLTH_Q9.outcome == 1 or MHLTH_Q11.outcome == 1 or MHLTH_Q12.outcome == 1 or MHLTH_Q13.outcome == 1 or MHLTH_Q7.outcome in [1, 2]
      hint: Asked only when at least one associated symptom was reported.
    - predicate: not (MHLTH_Q14.outcome is not None and MHLTH_Q14.outcome > 51)
      hint: Skipped when the total weeks felt this way exceeds 51.
    - predicate: not (MHLTH_Q14.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q14 is none of "DK", "R".
    - predicate: not (MHLTH_Q15.outcome is not None and MHLTH_Q15.outcome >= 1)
      hint: Skipped when the month of the last episode was already given.
    - predicate: not (MHLTH_Q16.outcome == 2)
      hint: Asked only when question MHLTH-Q16 is not "No".
    - predicate: not (MHLTH_Q16.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q16 is none of "DK", "R".
    items:
    - id: MHLTH_Q17
      kind: Question
      title: For the next few questions, please think of the 2-week period during the past 12 months when you had the most complete loss of interest in things. During that 2-week period, how long did the loss of interest usually last? (Read list. Mark one only.)
      precondition:
      - predicate: MHLTH_Q16.outcome == 1
        hint: Asked only when question MHLTH-Q16 is "Yes".
      input:
        control: Radio
        labels:
          1: All day long
          2: Most of the day
          3: About half of the day
          4: Less than half the day
          97: DK
          98: R
  - id: b_s32_p1_interest_detail
    title: 'Mental Health: Loss of Interest Detail'
    precondition:
    - predicate: not (MHLTH_Q2.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q2 is none of "DK", "R".
    - predicate: not (MHLTH_Q3.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q3 is none of "DK", "R".
    - predicate: not (MHLTH_Q4.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q4 is none of "DK", "R".
    - predicate: not (MHLTH_Q5.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q5 is none of "DK", "R".
    - predicate: not (MHLTH_Q6.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q6 is none of "DK", "R".
    - predicate: not (MHLTH_Q7.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q7 is none of "DK", "R".
    - predicate: not (MHLTH_Q9.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q9 is none of "DK", "R".
    - predicate: not (MHLTH_Q10.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q10 is none of "DK", "R".
    - predicate: not (MHLTH_Q11.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q11 is none of "DK", "R".
    - predicate: not (MHLTH_Q12.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q12 is none of "DK", "R".
    - predicate: not (MHLTH_Q13.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q13 is none of "DK", "R".
    - predicate: MHLTH_Q5.outcome == 1 or MHLTH_Q6.outcome == 1 or MHLTH_Q9.outcome == 1 or MHLTH_Q11.outcome == 1 or MHLTH_Q12.outcome == 1 or MHLTH_Q13.outcome == 1 or MHLTH_Q7.outcome in [1, 2]
      hint: Asked only when at least one associated symptom was reported.
    - predicate: not (MHLTH_Q14.outcome is not None and MHLTH_Q14.outcome > 51)
      hint: Skipped when the total weeks felt this way exceeds 51.
    - predicate: not (MHLTH_Q14.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q14 is none of "DK", "R".
    - predicate: not (MHLTH_Q15.outcome is not None and MHLTH_Q15.outcome >= 1)
      hint: Skipped when the month of the last episode was already given.
    - predicate: not (MHLTH_Q16.outcome == 2)
      hint: Asked only when question MHLTH-Q16 is not "No".
    - predicate: not (MHLTH_Q16.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q16 is none of "DK", "R".
    - predicate: not (MHLTH_Q17.outcome in [3, 4])
      hint: Asked only when question MHLTH-Q17 is none of "About half of the day", "Less than half the day".
    - predicate: not (MHLTH_Q17.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q17 is none of "DK", "R".
    items:
    - id: MHLTH_Q18
      kind: Question
      title: How often did you feel this way during those 2 weeks? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Every day
          2: Almost every day
          3: Less often
          97: DK
          98: R
    - id: MHLTH_Q19
      kind: Question
      title: During those 2 weeks did you feel tired out or low on energy all the time?
      precondition:
      - predicate: not (MHLTH_Q18.outcome == 3)
        hint: Asked only when question MHLTH-Q18 is not "Less often".
      - predicate: not (MHLTH_Q18.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q18 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = FEELING TIRED)
          2: 'No'
          97: DK
          98: R
  - id: b_s32_p2_main
    title: Mental Health (continued)
    precondition:
    - predicate: not (MHLTH_Q2.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q2 is none of DK, R.
    - predicate: not (MHLTH_Q3.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q3 is none of DK, R.
    - predicate: not (MHLTH_Q4.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q4 is none of DK, R.
    - predicate: not (MHLTH_Q5.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q5 is none of DK, R.
    - predicate: not (MHLTH_Q6.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q6 is none of DK, R.
    - predicate: not (MHLTH_Q7.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q7 is none of DK, R.
    - predicate: not (MHLTH_Q9.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q9 is none of DK, R.
    - predicate: not (MHLTH_Q10.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q10 is none of DK, R.
    - predicate: not (MHLTH_Q11.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q11 is none of DK, R.
    - predicate: not (MHLTH_Q12.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q12 is none of DK, R.
    - predicate: not (MHLTH_Q13.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q13 is none of DK, R.
    - predicate: not (not (MHLTH_Q5.outcome == 1 or MHLTH_Q6.outcome == 1 or MHLTH_Q9.outcome == 1 or MHLTH_Q11.outcome == 1 or MHLTH_Q12.outcome == 1 or MHLTH_Q13.outcome == 1 or MHLTH_Q7.outcome in [1, 2]))
      hint: Asked only when an earlier distress or help-seeking answer qualifies.
    - predicate: MHLTH_Q14.outcome is None or not (MHLTH_Q14.outcome > 51)
      hint: Asked only when MHLTH-Q14 is not more than 51 weeks.
    - predicate: not (MHLTH_Q14.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q14 is none of DK, R.
    - predicate: MHLTH_Q15.outcome is None or not (MHLTH_Q15.outcome >= 1)
      hint: Asked only when MHLTH-Q15 is less than 1.
    - predicate: not (MHLTH_Q16.outcome == 2)
      hint: Asked only when question MHLTH-Q16 is not No.
    - predicate: not (MHLTH_Q16.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q16 is none of DK, R.
    - predicate: not (MHLTH_Q17.outcome in [3, 4])
      hint: Asked only when question MHLTH-Q17 is none of About half of the day, Less than half the day.
    - predicate: not (MHLTH_Q17.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q17 is none of DK, R.
    - predicate: not (MHLTH_Q18.outcome == 3)
      hint: Asked only when question MHLTH-Q18 is not Less often.
    - predicate: not (MHLTH_Q18.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q18 is none of DK, R.
    - predicate: not (MHLTH_Q19.outcome in [97, 98])
      hint: Asked only when question MHLTH-Q19 is none of DK, R.
    items:
    - id: MHLTH_Q20
      kind: Question
      title: Did you gain weight, lose weight, or stay about the same? (Do not read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Gained weight (KEY PHRASE = GAINING WEIGHT)
          2: Lost weight (KEY PHRASE = LOSING WEIGHT)
          3: Stayed about the same
          4: Was on a diet
          97: DK
          98: R
    - id: MHLTH_Q21
      kind: Question
      title: About how much did you (gain/lose)? ___ pounds or kilograms
      precondition:
      - predicate: MHLTH_Q20.outcome in [1, 2]
        hint: Asked only when question MHLTH-Q20 is one of Gained weight, Lost weight.
      - predicate: not (MHLTH_Q20.outcome in [3, 4])
        hint: Asked only when question MHLTH-Q20 is none of Stayed about the same, Was on a diet.
      - predicate: not (MHLTH_Q20.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q20 is none of DK, R.
      input:
        control: Editbox
        min: 0
        max: 999
    - id: MHLTH_Q22
      kind: Question
      title: Did you have more trouble falling asleep than you usually do?
      precondition:
      - predicate: not (MHLTH_Q20.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q20 is none of DK, R.
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = TROUBLE FALLING ASLEEP)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q23
      kind: Question
      title: How often did that happen during those 2 weeks? (Read list. Mark one only.)
      precondition:
      - predicate: MHLTH_Q22.outcome == 1
        hint: Asked only when question MHLTH-Q22 is Yes (KEY PHRASE = TROUBLE FALLING ASLEEP).
      - predicate: not (MHLTH_Q20.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q20 is none of DK, R.
      - predicate: not (MHLTH_Q22.outcome == 2)
        hint: Asked only when question MHLTH-Q22 is not No.
      - predicate: not (MHLTH_Q22.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q22 is none of DK, R.
      input:
        control: Radio
        labels:
          1: Every night
          2: Nearly every night
          3: Less often
          97: DK
          98: R
    - id: MHLTH_Q24
      kind: Question
      title: Did you have a lot more trouble concentrating than usual?
      precondition:
      - predicate: not (MHLTH_Q20.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q20 is none of DK, R.
      - predicate: not (MHLTH_Q22.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q22 is none of DK, R.
      - predicate: not (MHLTH_Q23.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q23 is none of DK, R.
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = TROUBLE CONCENTRATING)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q25
      kind: Question
      title: At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?
      precondition:
      - predicate: not (MHLTH_Q20.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q20 is none of DK, R.
      - predicate: not (MHLTH_Q22.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q22 is none of DK, R.
      - predicate: not (MHLTH_Q23.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q23 is none of DK, R.
      - predicate: not (MHLTH_Q24.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q24 is none of DK, R.
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE = FEELING DOWN ON YOURSELF)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q26
      kind: Question
      title: Did you think a lot about death - either your own, someone else's, or death in general?
      precondition:
      - predicate: not (MHLTH_Q20.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q20 is none of DK, R.
      - predicate: not (MHLTH_Q22.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q22 is none of DK, R.
      - predicate: not (MHLTH_Q23.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q23 is none of DK, R.
      - predicate: not (MHLTH_Q24.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q24 is none of DK, R.
      - predicate: not (MHLTH_Q25.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q25 is none of DK, R.
      input:
        control: Radio
        labels:
          1: Yes (KEY PHRASE =THOUGHTS ABOUT DEATH)
          2: 'No'
          97: DK
          98: R
    - id: MHLTH_Q27
      kind: Question
      title: 'Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you lost interest in most things and also had some other things like (KEY PHRASES). About how many weeks did you feel this way during the past 12 months? # of weeks (IF >51 weeks then go to next section.)'
      precondition:
      - predicate: MHLTH_Q19.outcome == 1 or MHLTH_Q22.outcome == 1 or MHLTH_Q24.outcome == 1 or MHLTH_Q25.outcome == 1 or MHLTH_Q26.outcome == 1 or MHLTH_Q20.outcome in [1, 2]
        hint: Asked only when a distress symptom was reported.
      - predicate: not (MHLTH_Q20.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q20 is none of DK, R.
      - predicate: not (MHLTH_Q22.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q22 is none of DK, R.
      - predicate: not (MHLTH_Q23.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q23 is none of DK, R.
      - predicate: not (MHLTH_Q24.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q24 is none of DK, R.
      - predicate: not (MHLTH_Q25.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q25 is none of DK, R.
      - predicate: not (MHLTH_Q26.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q26 is none of DK, R.
      - predicate: not (not (MHLTH_Q19.outcome == 1 or MHLTH_Q22.outcome == 1 or MHLTH_Q24.outcome == 1 or MHLTH_Q25.outcome == 1 or MHLTH_Q26.outcome == 1 or MHLTH_Q20.outcome in [1, 2]))
        hint: Asked only when a distress symptom was reported.
      input:
        control: Editbox
        min: 0
        max: 52
        right: weeks
    - id: MHLTH_Q28
      kind: Question
      title: Think about the last time you had 2 weeks in a row when you felt this way. In what month was that?
      precondition:
      - predicate: MHLTH_Q27.outcome >= 0 and MHLTH_Q27.outcome <= 51
        hint: Asked only when MHLTH-Q27 is between 0 and 51 weeks.
      - predicate: not (MHLTH_Q20.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q20 is none of DK, R.
      - predicate: not (MHLTH_Q22.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q22 is none of DK, R.
      - predicate: not (MHLTH_Q23.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q23 is none of DK, R.
      - predicate: not (MHLTH_Q24.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q24 is none of DK, R.
      - predicate: not (MHLTH_Q25.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q25 is none of DK, R.
      - predicate: not (MHLTH_Q26.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q26 is none of DK, R.
      - predicate: not (not (MHLTH_Q19.outcome == 1 or MHLTH_Q22.outcome == 1 or MHLTH_Q24.outcome == 1 or MHLTH_Q25.outcome == 1 or MHLTH_Q26.outcome == 1 or MHLTH_Q20.outcome in [1, 2]))
        hint: Asked only when a distress symptom was reported.
      - predicate: not (MHLTH_Q27.outcome > 51)
        hint: Asked only when MHLTH-Q27 is not more than 51 weeks.
      - predicate: not (MHLTH_Q27.outcome in [97, 98])
        hint: Asked only when question MHLTH-Q27 is none of DK, R.
      input:
        control: Dropdown
        labels:
          1: January
          2: February
          3: March
          4: April
          5: May
          6: June
          7: July
          8: August
          9: September
          10: October
          11: November
          12: December
  - id: b_s33_social_support
    title: Social Support
    precondition:
    - predicate: PROXY_3.outcome == 0
      hint: Asked only when question PROXY is "Non-proxy".
    items:
    - id: SOCSUP_Q1
      kind: Question
      title: Are you a member of any voluntary organizations or associations such as school groups, church social groups, community centres, ethnic associations or social, civic or fraternal clubs?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
    - id: SOCSUP_Q2
      kind: Question
      title: How often did you participate in meetings or activities sponsored by these groups in the past 12 months? If you belong to many, just think of the ones in which you are most active. (Read list. Mark one only.)
      precondition:
      - predicate: SOCSUP_Q1.outcome == 1
        hint: Asked only when question SOCSUP-Q1 is "Yes".
      - predicate: not (SOCSUP_Q1.outcome == 2)
        hint: Asked only when question SOCSUP-Q1 is not "No".
      - predicate: not (SOCSUP_Q1.outcome in [97, 98])
        hint: Asked only when question SOCSUP-Q1 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: At least once a week
          2: At least once a month
          3: At least 3 or 4 times a year
          4: At least once a year
          5: Not at all
    - id: SOCSUP_Q2a
      kind: Question
      title: Other than on special occasions (such as weddings, funerals or baptisms), how often did you attend religious services or religious meetings in the past 12 months? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: At least once a week
          2: At least once a month
          3: At least 3 or 4 times a year
          4: At least once a year
          5: Not at all
    - id: SOCSUP_Q3
      kind: Question
      title: Do you have someone you can confide in, or talk to about your private feelings or concerns?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SOCSUP_Q4
      kind: Question
      title: Do you have someone you can really count on to help you out in a crisis situation?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SOCSUP_Q5
      kind: Question
      title: Do you have someone you can really count on to give you advice when you are making important personal decisions?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SOCSUP_Q6
      kind: Question
      title: Do you have someone that makes you feel loved and cared for?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SOCSUP_Q7
      kind: Question
      title: 'The next few questions are about your contact in the past 12 months with persons who do not live with you either in person, by phone, or by mail. If you have more than one person in a category, for example, several sisters, think of the one with whom you have the most contact. How often did you have contact with [fill with categories below]? Categories (asked one by one, SSC4_7A-H): Your parents or parents-in-law; Your grandparents; Your daughters or daughters-in-law; Your sons or sons-in-law; Your brothers or sisters; Other relatives (including in-laws); Your close friends; Your neighbours. Choice of responses are: (Read list. Mark one only.)'
      input:
        control: Dropdown
        labels:
          1: Don't have any
          2: Every day
          3: At least once a week
          4: 2 or 3 times a month
          5: Once a month
          6: A few times a year
          7: Once a year
          8: Never
  - id: b_s34_health_number
    title: Health Number
    items:
    - id: H06_HLTH
      kind: Question
      title: We are seeking your permission to link information collected during this interview with provincial health information. This would include information on past and continuing use of services such as visits to hospitals, clinics, physician's offices or other services provided by the province. This information will be used for statistical purposes only. Do we have your permission?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          97: DK
          98: R
    - id: H06_HLTH_l
      kind: Question
      title: Having a provincial health number will assist us in linking to this other information. What is ...r/s provincial health number?
      precondition:
      - predicate: H06_HLTH.outcome == 1
        hint: Asked only when question H06-HLTH# is "Yes".
      - predicate: not (H06_HLTH.outcome == 2)
        hint: Asked only when question H06-HLTH# is not "No".
      - predicate: not (H06_HLTH.outcome in [97, 98])
        hint: Asked only when question H06-HLTH# is none of "DK", "R".
      input:
        control: Textarea
  - id: b_s35_agreement_to_share
    title: Agreement to Share
    items:
    - id: H06_SHARE
      kind: Question
      title: To avoid duplication Statistics Canada intends to share the information from this survey with provincial ministries of health, Health Canada, and Employment and Immigration Canada. These organizations have undertaken to keep this information confidential and use it only for statistical purposes. Do you agree to share the information you have provided?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: H06_TEL
      kind: Question
      title: 'Was this interview conducted on the telephone or in person? (Both: Specify reason)'
      input:
        control: Radio
        labels:
          1: On telephone
          2: In person
          3: Both (Specify reason)
    - id: H06_CTEXT
      kind: Question
      title: Was the respondent alone when you asked this health questionnaire?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: H06_CTEXT1
      kind: Question
      title: 'Do you think that the answers of the respondent were affected by someone else being there? (Yes: Specify)'
      precondition:
      - predicate: H06_CTEXT.outcome == 2
        hint: Asked only when question H06-CTEXT is "No".
      - predicate: not (H06_CTEXT.outcome == 1)
        hint: Asked only when question H06-CTEXT is not "Yes".
      input:
        control: Radio
        labels:
          1: Yes (Specify)
          2: 'No'
    - id: H06_P2
      kind: Question
      title: Record language of interview
      input:
        control: Dropdown
        labels:
          1: English
          2: French
          3: Arabic
          4: Chinese
          5: Cree
          6: German
          7: Greek
          8: Hungarian
          9: Italian
          10: Korean
          11: Persian (Farsi)
          12: Polish
          13: Portuguese
          14: Punjabi
          15: Spanish
          16: Tagalog (Filipino)
          17: Ukrainian
          18: Vietnamese
          19: Other (Specify)
  - id: b_s36_buyin
    title: Manitoba Buy-in Questions
    precondition:
    - predicate: AGE_3.outcome >= 18 and PROXY_3.outcome == 0
      hint: Asked of respondents aged 18 or older who are not answered by proxy
    items:
    - id: SPR6_Q1
      kind: Question
      title: Do you always try to do what is reasonable and logical?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q2
      kind: Question
      title: Do you always try to understand people and their behaviour, to avoid responding emotionally?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q3
      kind: Question
      title: When dealing with other people do you always try to act rationally?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q4
      kind: Question
      title: Do you try to overcome all conflicts with other people by intelligence and reason, trying hard not to show your emotions?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q5
      kind: Question
      title: If someone deeply hurts your feelings, do you nevertheless try to treat him or her rationally and to understand his or her way of behaving?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q6
      kind: Question
      title: Do you succeed in avoiding most conflicts with other people by relying on your reason and logic, even if this is not how you feel at the time?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q7
      kind: Question
      title: If someone acts against your needs and desires, do you nevertheless try to understand that person?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q8
      kind: Question
      title: Do you behave so rationally in most life situations that your behaviour is rarely influenced by only your emotions?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q9
      kind: Question
      title: Do your emotions frequently influence your behaviour to such a degree that your behaviour might be considered harmful to yourself and others?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q10
      kind: Question
      title: Do you try to understand others even if you don't like them?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q11
      kind: Question
      title: Does your rationality prevent you from verbally attacking or criticizing others, even if there are sufficient reasons for doing so?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SPR6_Q12
      kind: Question
      title: Imagine you are afraid of the dentist and you have to get some dental work done. Which of the following things would you do to help you overcome your fears? (Read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: Ask the dentist exactly what he is doing
          2: Take a tranquilizer or have a drink before going
          4: Try to think about other things, like pleasant memories
          8: Have the dentist tell you when you would feel pain
          16: Try to sleep
          32: Watch all the dentist's movements and listen for the sound of the drill
          64: Watch the flow of water from your mouth to see if it contained blood
          128: Do mental puzzles in your mind
          256: Other (Specify)
    - id: SPR6_Q13
      kind: Question
      title: Imagine that you are a salesperson and get along well with your fellow workers. It has been rumoured that, due to a large drop in sales, several people in your department will be laid off. The decision about lay-offs has been made and will be announced in several days. Which of the following would you do? (Read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: Talk to your fellow workers to see if they know anything about the supervisor's evaluation of you
          2: Review the list of duties for your present job and try to figure out if you had accomplished all of them
          4: Watch TV, go to the movies or do something like that, to take your mind off things
          8: Try to remember any arguments or disagreements you might have had with your supervisor that might have lowered his or her opinion of you
          16: Push all thoughts of being laid off out of your mind
          32: If it came up during a conversation say that you would rather not discuss your chances of being laid off
          64: Try to think which employees in your department the supervisor might evaluate more poorly than you
          128: Continue doing your work as if nothing special was happening
          256: Other (Specify)
  - id: b_s37_alberta_buyin
    title: Alberta Buy-in Questions
    precondition:
    - predicate: AGE_3.outcome >= 18 and PROXY_3.outcome == 0
      hint: Asked of respondents aged 18 or older who are not answered by proxy
    items:
    - id: SPR8_Q1
      kind: Question
      title: How would you rate your ability to handle the day-to-day demands in your life, for example, work, family and volunteer responsibilities? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Excellent
          2: Very Good
          3: Good
          4: Fair
          5: Poor
    - id: SPR8_Q2
      kind: Question
      title: If the day-to-day demands in your life were causing you to feel under stress, which of the following would you do? (Read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: Try not to think about the situation and keep yourself busy to prevent thinking about it
          2: Try to see the situation in a different light that makes it seem more bearable
          4: Think about ways to change the situation or do something to solve the problem causing the stress
          8: Express your emotions to reduce your tension, anxiety or frustration
          16: Admit to yourself that the situation is stressful, but otherwise do nothing
          32: Talk about the situation with others
          64: Do something you enjoy in order to relax
          128: Pray or otherwise seek comfort or strength through religious faith
          256: Do something else (Specify)
    - id: SPR8_Q3
      kind: Question
      title: How would you rate your ability to handle unexpected and difficult problems, for example, family or personal crisis? (Read list. Mark one only.)
      input:
        control: Radio
        labels:
          1: Excellent
          2: Very Good
          3: Good
          4: Fair
          5: Poor
    - id: SPR8_Q4
      kind: Question
      title: If an unexpected problem or situation was causing you to feel under stress, which of the following would you do? (Read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: Try not to think about the situation and keep yourself busy to prevent thinking about it
          2: Try to see the situation in a different light that makes it seem more bearable
          4: Think about ways to change the situation or do something to solve the problem causing the stress
          8: Express your emotions to reduce your tension, anxiety or frustration
          16: Admit to yourself that the situation is stressful, but otherwise do nothing
          32: Talk about the situation with others
          64: Do something you enjoy in order to relax
          128: Pray or otherwise seek comfort or strength through religious faith
          256: Do something else (Specify)
  - id: b_s38_preamble
    title: 'Child General Health: setup'
    items:
    - id: AGE_4
      kind: Question
      title: Age of the selected child (from the sample file / respondent record); the routing checks KCHR-C1, KHS-C1 and the age notes in KCHR1-Q1 read it
      external: true
      input:
        control: Editbox
        min: 0
        max: 11
  - id: b_s38_general_health
    title: Child General Health
    items:
    - id: KGH_Q1
      kind: Question
      title: 'In general, would you say %FNAME%’s health is: (READ LIST. MARK ONE ONLY.)'
      input:
        control: Radio
        labels:
          1: Excellent?
          2: Very good?
          3: Good?
          4: Fair?
          5: Poor?
    - id: KGH_Q3
      kind: Question
      title: Does %FNAME% have any long-term physical or mental condition or a health problem which prevents or limits %his/her% participation in school, at play, or in any other activity for a child %his/her% age?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: KGH_Q4
      kind: Question
      title: How tall is %he/she% without shoes on? ------ FEET ----- INCHES OR ------- CENTIMETRES
      input:
        control: Editbox
        min: 1
        max: 250
    - id: KGH_Q5
      kind: Question
      title: 'How much does %he/she% weigh? ____ (ENTER AMOUNT ONLY.) (MIN: 1) (MAX: 300) DK, R (Go to next section)'
      input:
        control: Editbox
        min: 1
        max: 300
    - id: KGH_C5
      kind: Question
      title: 'INTERVIEWER: WAS THAT IN POUNDS OR IN KILOGRAMS?'
      precondition:
      - predicate: KGH_Q5.outcome >= 1
      - predicate: not (KGH_Q5.outcome in [-7, -9])
        hint: Asked only when question KGH-Q5 is none of -7, -9.
      input:
        control: Radio
        labels:
          1: POUNDS
          2: KILOGRAMS
  - id: b_s39_hospital
    title: Child Health Care Utilization
    items:
    - id: KUT_Q1
      kind: Question
      title: In the past 12 months, has %FNAME% been an overnight patient in a hospital?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s39_contacts
    title: Contacts with health professionals
    items:
    - id: KUT_Q3a
      kind: Question
      title: (Not counting when %FNAME% was an overnight patient) In the past 12 months, how many times have you seen or talked on the telephone with a/an/any a) A general practitioner, family physician about %his/her% physical, emotional or mental health? (Exclude at time of birth for babies.)
      input:
        control: Editbox
        min: 0
        max: 366
    - id: KUT_Q3b
      kind: Question
      title: KUT-Q3 b) A pediatrician
      input:
        control: Editbox
        min: 0
        max: 366
    - id: KUT_Q3c
      kind: Question
      title: KUT-Q3 c) An other medical doctor (such as an orthopedist, or eye specialist)
      input:
        control: Editbox
        min: 0
        max: 300
    - id: KUT_Q3d
      kind: Question
      title: KUT-Q3 d) A public health nurse or nurse practitioner
      input:
        control: Editbox
        min: 0
        max: 366
    - id: KUT_Q3e
      kind: Question
      title: KUT-Q3 e) A dentist or orthodontist
      input:
        control: Editbox
        min: 0
        max: 99
    - id: KUT_Q3f
      kind: Question
      title: KUT-Q3 f) A psychiatrist or psychologist
      input:
        control: Editbox
        min: 0
        max: 366
    - id: KUT_Q3g
      kind: Question
      title: KUT-Q3 g) Child welfare worker or children’s aid worker
      input:
        control: Editbox
        min: 0
        max: 366
    - id: KUT_Q3h
      kind: Question
      title: KUT-Q3 h) Any other person trained to provide treatment or counsel, for example a speech therapist, a social worker
      input:
        control: Editbox
        min: 0
        max: 366
  - id: b_s40_infections
    title: 'Child Chronic Conditions: Infections'
    precondition:
    - predicate: AGE_4.outcome <= 3
    - predicate: not (AGE_4.outcome > 3)
    items:
    - id: KCHR_Q1
      kind: Question
      title: Thinking now about illnesses, how often does %FNAME% have nose or throat infections? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Almost all the time
          2: Often
          3: From time to time
          4: Rarely
          5: Never
    - id: KCHR_Q2
      kind: Question
      title: Since %his/her% birth, has %he/she% ever had an ear infection (otitis)?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (Go to KCHR-Q4)
          97: DK (Go to KCHR-Q4)
          99: R (Go to KCHR-Q4)
    - id: KCHR_Q3
      kind: Question
      title: How many times? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: KCHR_Q2.outcome == 1
        hint: Asked only when question KCHR-Q2 is "YES".
      - predicate: not (KCHR_Q2.outcome in [2, 97, 99])
        hint: Asked only when question KCHR-Q2 is none of "NO (Go to KCHR-Q4)", "DK (Go to KCHR-Q4)", "R (Go to KCHR-Q4)".
      input:
        control: Radio
        labels:
          1: ONCE
          2: 2 TIMES
          3: 3 TIMES
          4: 4 OR MORE TIMES
  - id: b_s40_asthma
    title: 'Child Chronic Conditions: Asthma'
    items:
    - id: KCHR_Q4
      kind: Question
      title: The following questions are about asthma. Has %FNAME% ever had asthma that has been diagnosed by a health professional?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (Go to KCHR1-INT)
          97: DK (Go to KCHR1-INT)
          99: R (Go to KCHR1-INT)
  - id: b_s40_asthma_followup
    title: 'Child Chronic Conditions: Asthma Follow-up'
    precondition:
    - predicate: KCHR_Q4.outcome == 1
      hint: Asked only when question KCHR-Q4 is "YES".
    - predicate: not (KCHR_Q4.outcome in [2, 97, 99])
      hint: Asked only when question KCHR-Q4 is none of "NO (Go to KCHR1-INT)", "DK (Go to KCHR1-INT)", "R (Go to KCHR1-INT)".
    items:
    - id: KCHR_Q5
      kind: Question
      title: Has %he/she% had an attack of asthma in the past 12 months?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: KCHR_Q6
      kind: Question
      title: Has %he/she% had wheezing or whistling in the chest at any time in the past 12 months?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s40_long_term
    title: Child Long-term Conditions
    items:
    - id: KCHR1_Q1
      kind: Question
      title: Does %FNAME% have any of the following long-term conditions that have been diagnosed by a health professional? (long-term conditions refer to conditions that have lasted or are expected to last 6 months or more)
      postcondition:
      - predicate: not (KCHR1_Q1.outcome & 384 > 0 and AGE_4.outcome < 6)
        hint: 'Les options h) et i) de KCHR1-Q1 ne se posent qu''à partir de 6 ans (AGE): Items h and i of KCHR1-Q1 apply only if the child is 6 or older; correct the answer or the age.'
        invented: true
      - predicate: KCHR1_Q1.outcome & 1024 == 0 or KCHR1_Q1.outcome == 1024
        hint: '''None'' in KCHR1-Q1 cannot be combined with any condition a) to j).'
        invented: true
      input:
        control: Checkbox
        labels:
          1: a) Allergies?
          2: b) Bronchitis?
          4: c) Heart condition or disease?
          8: d) Epilepsy?
          16: e) Cerebral palsy?
          32: f) Kidney condition or disease?
          64: g) Mental handicap?
          128: h) A learning disability? (Ask only age>=6)
          256: i) An emotional, psychological or nervous condition? (Ask only age>=6)
          512: j) Any other long-term condition?
          1024: k) None
  - id: b_s41_vision
    title: 'Child Health Status: Vision'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    items:
    - id: KHS_Q1
      kind: Question
      title: Is %he/she% usually able to see clearly, and without distortion, the words in a book without glasses or contact lenses?
      precondition:
      - predicate: AGE_4.outcome >= 4
        hint: Asked only of children aged 4 or older
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-Q4)
          2: 'NO'
  - id: b_s41_vision_unaided
    title: 'Child Health Status: Vision, Not Clear Without Aids'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    - predicate: not (KHS_Q1.outcome == 1)
      hint: Asked only when question KHS-Q1 is not "YES (Go to KHS-Q4)".
    items:
    - id: KHS_Q2
      kind: Question
      title: Is %he/she% usually able to see clearly, and without distortion, the words in a book with glasses or contact lenses?
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-Q4)
          2: 'NO'
          3: DOESN’T WEAR GLASSES OR CONTACT LENSES
    - id: KHS_Q3
      kind: Question
      title: Is %he/she% able to see at all?
      precondition:
      - predicate: not (KHS_Q2.outcome == 1)
        hint: Asked only when question KHS-Q2 is not "YES (Go to KHS-Q4)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (Go to KHS-Q6)
  - id: b_s41_vision_distance
    title: 'Child Health Status: Vision, Distance'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    items:
    - id: KHS_Q4
      kind: Question
      title: Is %he/she% able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?
      precondition:
      - predicate: not (KHS_Q3.outcome == 2)
        hint: Asked only when question KHS-Q3 is not "NO (Go to KHS-Q6)".
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-Q6)
          2: 'NO'
    - id: KHS_Q5
      kind: Question
      title: Is %he/she% usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?
      precondition:
      - predicate: not (KHS_Q3.outcome == 2)
        hint: Asked only when question KHS-Q3 is not "NO (Go to KHS-Q6)".
      - predicate: not (KHS_Q4.outcome == 1)
        hint: Asked only when question KHS-Q4 is not "YES (Go to KHS-Q6)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: DOESN’T WEAR GLASSES OR CONTACT LENSES
  - id: b_s41_hearing
    title: 'Child Health Status: Hearing'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    items:
    - id: KHS_Q6
      kind: Question
      title: Is %he/she% usually able to hear what is said in a group conversation with at least 3 other people without a hearing aid?
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-IN2)
          2: 'NO'
  - id: b_s41_hearing_followup
    title: 'Child Health Status: Hearing, Follow-up'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    - predicate: not (KHS_Q6.outcome == 1)
      hint: Asked only when question KHS-Q6 is not "YES (Go to KHS-IN2)".
    items:
    - id: KHS_Q7
      kind: Question
      title: Is %he/she% usually able to hear what is said in a group conversation with at least 3 other people with a hearing aid?
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-Q8)
          2: 'NO'
          3: DOESN’T WEAR A HEARING AID
    - id: KHS_Q7A
      kind: Question
      title: Is %he/she% able to hear at all?
      precondition:
      - predicate: not (KHS_Q7.outcome == 1)
        hint: Asked only when question KHS-Q7 is not "YES (Go to KHS-Q8)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (Go to KHS-IN2)
    - id: KHS_Q8
      kind: Question
      title: Is %he/she% usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?
      precondition:
      - predicate: not (KHS_Q7A.outcome == 2)
        hint: Asked only when question KHS-Q7A is not "NO (Go to KHS-IN2)".
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-IN2)
          2: 'NO'
    - id: KHS_Q9
      kind: Question
      title: Is %he/she% usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?
      precondition:
      - predicate: not (KHS_Q7A.outcome == 2)
        hint: Asked only when question KHS-Q7A is not "NO (Go to KHS-IN2)".
      - predicate: not (KHS_Q8.outcome == 1)
        hint: Asked only when question KHS-Q8 is not "YES (Go to KHS-IN2)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: DOESN’T WEAR A HEARING AID
  - id: b_s41_speech
    title: 'Child Health Status: Speech'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    items:
    - id: KHS_Q10
      kind: Question
      title: Is %he/she% usually able to be understood completely when speaking with strangers in %his/her% own language?
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-Q14)
          2: 'NO'
  - id: b_s41_speech_followup
    title: 'Child Health Status: Speech, Follow-up'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    - predicate: not (KHS_Q10.outcome == 1)
      hint: Asked only when question KHS-Q10 is not "YES (Go to KHS-Q14)".
    items:
    - id: KHS_Q11
      kind: Question
      title: Is %he/she% able to be understood partially when speaking with strangers in %his/her% own language?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: KHS_Q12
      kind: Question
      title: Is %he/she% able to be understood completely when speaking with those who know %him/her% well?
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-Q14)
          2: 'NO'
    - id: KHS_Q13
      kind: Question
      title: Is %he/she% able to be understood partially when speaking with those who know %him/her% well?
      precondition:
      - predicate: not (KHS_Q12.outcome == 1)
        hint: Asked only when question KHS-Q12 is not "YES (Go to KHS-Q14)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s41_mobility
    title: 'Child Health Status: Mobility'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    items:
    - id: KHS_Q14
      kind: Question
      title: Is %FNAME% usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-Q21)
          2: 'NO'
  - id: b_s41_mobility_followup
    title: 'Child Health Status: Mobility, Follow-up'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    - predicate: not (KHS_Q14.outcome == 1)
      hint: Asked only when question KHS-Q14 is not "YES (Go to KHS-Q21)".
    items:
    - id: KHS_Q15
      kind: Question
      title: Is %he/she% able to walk at all?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (Go to KHS-Q18)
    - id: KHS_Q16
      kind: Question
      title: Does %he/she% require mechanical support such as braces, a cane or crutches to be able to walk?
      precondition:
      - predicate: not (KHS_Q15.outcome == 2)
        hint: Asked only when question KHS-Q15 is not "NO (Go to KHS-Q18)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: KHS_Q17
      kind: Question
      title: Does %he/she% require the help of another person to be able to walk?
      precondition:
      - predicate: not (KHS_Q15.outcome == 2)
        hint: Asked only when question KHS-Q15 is not "NO (Go to KHS-Q18)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: KHS_Q18
      kind: Question
      title: Does %he/she% require a wheelchair to get around?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (Go to KHS-Q21)
  - id: b_s41_wheelchair
    title: 'Child Health Status: Wheelchair Use'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    - predicate: not (KHS_Q14.outcome == 1)
      hint: Asked only when question KHS-Q14 is not "YES (Go to KHS-Q21)".
    - predicate: not (KHS_Q18.outcome == 2)
      hint: Asked only when question KHS-Q18 is not "NO (Go to KHS-Q21)".
    items:
    - id: KHS_Q19
      kind: Question
      title: How often does %he/she% use a wheelchair? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Never
    - id: KHS_Q20
      kind: Question
      title: Does %he/she% need the help of another person to get around in the wheelchair?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s41_dexterity
    title: 'Child Health Status: Dexterity'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    items:
    - id: KHS_Q21
      kind: Question
      title: Is %FNAME% usually able to grasp and handle small objects such as a pencil or scissors?
      input:
        control: Radio
        labels:
          1: YES (Go to KHS-Q25)
          2: 'NO'
  - id: b_s41_dexterity_followup
    title: 'Child Health Status: Dexterity, Follow-up'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    - predicate: not (KHS_Q21.outcome == 1)
      hint: Asked only when question KHS-Q21 is not "YES (Go to KHS-Q25)".
    items:
    - id: KHS_Q22
      kind: Question
      title: Does %he/she% require the help of another person because of limitations in the use of hands or fingers?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (Go to KHS-Q24)
    - id: KHS_Q23
      kind: Question
      title: 'Does %he/she% require the help of another person with: (READ LIST. MARK ONE ONLY.)'
      precondition:
      - predicate: not (KHS_Q22.outcome == 2)
        hint: Asked only when question KHS-Q22 is not "NO (Go to KHS-Q24)".
      input:
        control: Radio
        labels:
          1: Some tasks?
          2: Most tasks?
          3: Almost all tasks?
          4: All tasks?
    - id: KHS_Q24
      kind: Question
      title: Does %he/she% require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s41_feelings_cognition
    title: 'Child Health Status: Feelings, Memory and Thinking'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    items:
    - id: KHS_Q25
      kind: Question
      title: 'Would you describe %FNAME% as being usually: (READ LIST. MARK ONE ONLY.)'
      input:
        control: Radio
        labels:
          1: Happy and interested in life?
          2: Somewhat happy?
          3: Somewhat unhappy?
          4: Unhappy with little interest in life?
          5: So unhappy that life is not worthwhile?
    - id: KHS_Q26
      kind: Question
      title: How would you describe %his/her% usual ability to remember things? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Able to remember most things?
          2: Somewhat forgetful?
          3: Very forgetful?
          4: Unable to remember anything at all?
    - id: KHS_Q27
      kind: Question
      title: How would you describe %his/her% usual ability to think and solve day-to-day problems? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Able to think clearly and solve problems?
          2: Having a little difficulty?
          3: Having some difficulty?
          4: Having a great deal of difficulty?
          5: Unable to think or solve problems?
  - id: b_s41_pain
    title: 'Child Health Status: Pain'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    items:
    - id: KHS_Q28
      kind: Question
      title: Is %FNAME% usually free of pain or discomfort?
      input:
        control: Radio
        labels:
          1: YES (Go to next section)
          2: 'NO'
  - id: b_s41_pain_followup
    title: 'Child Health Status: Pain, Follow-up'
    precondition:
    - predicate: not (AGE_4.outcome < 4)
      hint: Asked only of children aged 4 or older
    - predicate: KHS_Q28.outcome == 2
      hint: Asked only when question KHS-Q28 is "NO".
    - predicate: not (KHS_Q28.outcome == 1)
      hint: Asked only when question KHS-Q28 is not "YES (Go to next section)".
    items:
    - id: KHS_Q29
      kind: Question
      title: How would you describe the usual intensity of %his/her% pain or discomfort? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Mild
          2: Moderate
          3: Severe
    - id: KHS_Q30
      kind: Question
      title: How many activities does %his/her% pain or discomfort prevent? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: None
          2: A few
          3: Some
          4: Most
  - id: b_s42_screen
    title: Child Injuries
    items:
    - id: KIN_Q1
      kind: Question
      title: In the past 12 months, was %FNAME% injured?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (Go to next section)
          97: DK (Go to next section)
          99: R (Go to next section)
  - id: b_s42_injury
    title: 'Child Injuries: Details'
    precondition:
    - predicate: KIN_Q1.outcome == 1
      hint: Asked only when question KIN-Q1 is "YES".
    - predicate: not (KIN_Q1.outcome in [2, 97, 99])
      hint: Asked only when question KIN-Q1 is none of "NO (Go to next section)", "DK (Go to next section)", "R (Go to next section)".
    items:
    - id: KIN_Q2
      kind: Question
      title: 'How many times was %he/she% injured? |_|_| TIMES (MIN: 1) (MAX: 30) DK, R (Go to next section)'
      input:
        control: Editbox
        min: 1
        max: 30
        right: times
    - id: KIN_Q3
      kind: Question
      title: (For the most serious injury,) what type of injury did %he/she% have? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: not (KIN_Q2.outcome in [-7, -9])
        hint: Asked only when question KIN-Q2 is none of -7, -9.
      input:
        control: Dropdown
        labels:
          1: BROKEN OR FRACTURED BONES
          2: BURN OR SCALD
          3: DISLOCATION
          4: SPRAIN OR STRAIN
          5: CUT, SCRAPE OR BRUISE
          6: CONCUSSION (Go to KIN-Q5) (KIN-Q4=3 was filled during processing)
          7: POISONING BY SUBSTANCE OR LIQUID (Go to KIN-Q5) (KIN-Q4=11 was filled during processing)
          8: INTERNAL INJURY (Go to KIN-Q5) (KIN-Q4=11 was filled during processing)
          9: DENTAL INJURY (Go to KIN-Q5) (KIN-Q4=2 was filled during processing)
          10: OTHER (SPECIFY)
          11: MULTIPLE INJURIES (Go to KIN-Q5)
          97: DK (Go to next section)
          99: R (Go to next section)
    - id: KIN_Q4
      kind: Question
      title: What part of %your/his/her% body was injured? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: KIN_Q1.outcome == 1 and KIN_Q3.outcome not in [6, 7, 8, 9, 11]
      - predicate: not (KIN_Q2.outcome in [-7, -9])
        hint: Asked only when question KIN-Q2 is none of -7, -9.
      - predicate: not (KIN_Q3.outcome in [6, 7, 8, 9, 11])
        hint: Asked only when question KIN-Q3 is none of the injury types that skip to KIN-Q5.
      - predicate: not (KIN_Q3.outcome in [97, 99])
        hint: Asked only when question KIN-Q3 is none of "DK (Go to next section)", "R (Go to next section)".
      input:
        control: Dropdown
        labels:
          1: EYES
          2: FACE OR SCALP (EXCLUDING EYES)
          3: HEAD OR NECK (EXCLUDING EYES AND FACE OR SCALP)
          4: ARMS OR HANDS
          5: LEGS OR FEET
          6: BACK OR SPINE
          7: TRUNK (EXCLUDING BACK OR SPINE) (INCLUDING CHEST, INTERNAL ORGANS)
          8: SHOULDER
          9: HIP
          10: MULTIPLE SITES
          11: SYSTEMIC (CATEGORY CREATED DURING PROCESSING)
          97: DK (Go to next section)
          99: R (Go to next section)
    - id: KIN_Q5
      kind: Question
      title: Where did the injury happen, for example, at home, on the street, in the playground or at school? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: not (KIN_Q2.outcome in [-7, -9])
        hint: Asked only when question KIN-Q2 is none of -7, -9.
      - predicate: not (KIN_Q3.outcome in [97, 99])
        hint: Asked only when question KIN-Q3 is none of "DK (Go to next section)", "R (Go to next section)".
      - predicate: not (KIN_Q4.outcome in [97, 99])
        hint: Asked only when question KIN-Q4 is none of "DK (Go to next section)", "R (Go to next section)".
      input:
        control: Dropdown
        labels:
          1: INSIDE OWN HOME/APARTMENT
          2: OUTSIDE HOME, APARTMENT, INCLUDING YARD, DRIVEWAY, PARKING LOT OR IN SHARED AREAS RELATED TO HOME SUCH AS APARTMENT HALLWAY OR LAUNDRY ROOM
          3: IN OR AROUND OTHER PRIVATE RESIDENCE
          4: INSIDE SCHOOL/DAYCARE CENTRE OR ON SCHOOL/CENTRE GROUNDS
          5: AT AN INDOOR OR OUTDOOR SPORTS FACILITY (OTHER THAN SCHOOL)
          6: OTHER BUILDING USED BY GENERAL PUBLIC
          7: ON SIDEWALK/STREET/HIGHWAY IN NEIGHBOURHOOD
          8: ON ANY OTHER SIDEWALK/STREET/HIGHWAY
          9: IN A PLAYGROUND/PARK (OTHER THAN SCHOOL)
          10: OTHER (SPECIFY)
          97: DK (Go to next section)
          99: R (Go to next section)
    - id: KIN_Q6
      kind: Question
      title: What happened? For example, was the injury the result of a fall, a motor vehicle accident, a physical assault, etc.? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: not (KIN_Q2.outcome in [-7, -9])
        hint: Asked only when question KIN-Q2 is none of -7, -9.
      - predicate: not (KIN_Q3.outcome in [97, 99])
        hint: Asked only when question KIN-Q3 is none of "DK (Go to next section)", "R (Go to next section)".
      - predicate: not (KIN_Q4.outcome in [97, 99])
        hint: Asked only when question KIN-Q4 is none of "DK (Go to next section)", "R (Go to next section)".
      - predicate: not (KIN_Q5.outcome in [97, 99])
        hint: Asked only when question KIN-Q5 is none of "DK (Go to next section)", "R (Go to next section)".
      input:
        control: Dropdown
        labels:
          1: MOTOR VEHICLE COLLISION - PASSENGER
          2: MOTOR VEHICLE COLLISION - PEDESTRIAN
          3: MOTOR VEHICLE COLLISION - RIDING BICYCLE
          4: OTHER BICYCLE ACCIDENT
          5: FALL (EXCLUDING BICYCLE OR SPORTS)
          6: SPORTS (EXCLUDING BICYCLE)
          7: PHYSICAL ASSAULT
          8: SCALDED BY HOT LIQUIDS OR FOOD
          9: ACCIDENTAL POISONING
          10: SELF-INFLICTED POISONING
          11: OTHER INTENTIONALLY SELF-INFLICTED INJURIES
          12: NATURAL/ENVIRONMENTAL FACTORS (EG. ANIMAL BITE, STING)
          13: FIRE/FLAMES OR RESULTING FUMES
          14: NEAR DROWNING
          15: OTHER (SPECIFY)
