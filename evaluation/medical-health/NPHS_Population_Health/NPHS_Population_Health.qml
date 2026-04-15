qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey"
  codeInit: |
    # =========================================================================
    # Cross-section variables.
    #
    # Because a single QML file shares one codeInit scope and one dependency
    # graph, variables produced by an earlier block are visible to every
    # later block without any extern declaration. We initialize them here so
    # that Z3 sees a known domain before the producer block runs; the producer
    # block's codeBlock then reassigns them from its item's outcome, and the
    # static builder propagates the item's input domain into the variable.
    # =========================================================================

    # Produced by Section 01 (Household) — consumed by most later sections.
    age = 0               # respondent's age (q_demo_q4)
    sex = 0               # sex: 1=Male, 2=Female (q_demo_q5)
    marital_status = 0    # marital status 1-7 (q_demo_q6)

    # Produced by Section 06 (Labour Force & Income) — consumed by Section 10.
    lfs_work = 0          # derived employment status
    income_multi = 0      # multi-earner household flag

    # Produced by Section 07 (General Health & Preventive).
    is_pregnant = 0       # pregnancy flag (screens out some items)

    # Produced by Section 10 (Stress) — downstream consumers were in extern land,
    # kept as a local flag for future use.
    has_children = 0

  blocks:

    # =====================================================================
    # SECTION 01: Household
    # =====================================================================
    # =========================================================================
    # BLOCK 1: HOUSEHOLD ROSTER INTRODUCTION
    # =========================================================================
    # DEMO_INT: Section introduction (no response collected)
    # DEMO_Q1: Roster name entry (open text)
    # DEMO_Q2/Q3: Loop-based roster questions — modeled as simple Yes/No.
    #   In the original CATI, Yes routes back to DEMO_Q1 to collect another
    #   name; QML cannot model dynamic loops so these are recorded as Yes/No
    #   gates only; the loop behaviour is noted here for reference.
    # =========================================================================
    - id: b_roster
      title: "Household Roster"
      items:
        # DEMO_INT: Interviewer introduction
        - id: q_demo_int
          kind: Comment
          title: "The next few questions will provide important basic information on the people in your household."

        # DEMO_Q1: Roster name entry
        # Original: collect first and last names of all household members
        # Modeled as a text entry for the household size count proxy.
        - id: q_demo_q1
          kind: Question
          title: "What are the names of all persons now living or staying here who have no usual place of residence elsewhere?"
          input:
            control: Textarea
            placeholder: "Enter names of all usual household members..."

        # DEMO_Q2 / DHC4_3A: Persons away but usually here?
        # Original: Yes → GO TO DEMO_Q1 (loop to add more names).
        # QML cannot model loops; recorded as Yes/No only.
        # Note: In the original CATI, answering Yes causes a loop back to
        # DEMO_Q1 to record the away person's name; this loop is not
        # modelled in QML.
        - id: q_demo_q2
          kind: Question
          title: "Are there any persons away from this household attending school, visiting, travelling or in hospital who usually live here?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # DEMO_Q3 / DHC4_3B: Anyone else live here?
        # Original: Yes → GO TO DEMO_Q1 (loop to add more names).
        # QML cannot model loops; recorded as Yes/No only.
        # Note: In the original CATI, answering Yes causes a loop back to
        # DEMO_Q1 to record the additional person; this loop is not
        # modelled in QML.
        - id: q_demo_q3
          kind: Question
          title: "Does anyone else live at this dwelling such as young children, relatives, roomers, boarders or employees?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 2: INDIVIDUAL DEMOGRAPHICS (per household member)
    # =========================================================================
    # DEMO_Q4: Date of birth → calculate age (modeled as age Editbox 0-120)
    # DEMO_Q5: Sex → sets cross-section variable sex
    # DEMO_Q6: Marital status → sets cross-section variable marital_status
    #          Note: age < 15 → automatically Single (handled in codeBlock)
    # DEMO_Q7: Family ID code (A-Z text entry; modeled as numeric 1-26)
    # DEMO_Q8: Relationships grid — modeled as Comment (captured at
    #          household level in original; QML does not support matrices
    #          spanning multiple household members)
    # =========================================================================
    - id: b_individual_demographics
      title: "Individual Demographics"
      items:
        # DEMO_Q4 / DHC4_DAT / DHC4_DOB / DHC4_AGE: Date of birth → age
        # Original: date entry (DD/MM/YY); age calculated and confirmed.
        # Modeled as age in years (0-120) since QML has no date control.
        - id: q_demo_q4
          kind: Question
          title: "What is ...'s age? (Original question asks date of birth; age is calculated from DD/MM/YY and confirmed with respondent.)"
          codeBlock: |
            age = q_demo_q4.outcome
          input:
            control: Editbox
            min: 0
            max: 120
            left: "Age:"
            right: "years"

        # DEMO_Q5 / DHC4_SEX: Sex
        - id: q_demo_q5
          kind: Question
          title: "Enter or ask ...'s sex."
          codeBlock: |
            sex = q_demo_q5.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # DEMO_Q6 / DHC4_MAR: Marital status
        # Note: If age < 15, marital status is automatically Single (code 4).
        # This is handled in the codeBlock: if the entered outcome is not
        # Single but age < 15, marital_status is forced to Single (4).
        - id: q_demo_q6
          kind: Question
          title: "What is ...'s current marital status? (Note: if age is under 15, marital status is automatically recorded as Single.)"
          codeBlock: |
            if age < 15:
              marital_status = 4
            else:
              marital_status = q_demo_q6.outcome
          input:
            control: Radio
            labels:
              1: "Now married"
              2: "Common-law"
              3: "Living with a partner"
              4: "Single (never married)"
              5: "Widowed"
              6: "Separated"
              7: "Divorced"

        # DEMO_Q7 / DHC4_FID: Family ID code (A-Z)
        # Original: text entry of a single letter A-Z; legal household check
        # follows; selection criteria applied.
        # Modeled as numeric 1-26 (1=A, 2=B, ... 26=Z).
        - id: q_demo_q7
          kind: Question
          title: "Enter ...'s family Id code. (A=1, B=2, ... Z=26; legal household check and selection criteria applied after entry.)"
          input:
            control: Editbox
            min: 1
            max: 26

        # DEMO_Q8: Relationships grid
        # Original: matrix capturing relationships of every household member
        # to every other (birth parent, step parent, foster parent, etc.).
        # QML does not support multi-respondent relationship matrices;
        # this item is recorded as a Comment for documentation.
        - id: q_demo_q8
          kind: Comment
          title: "Record relationships of everyone to everyone else in the household. (Original: Grid/Matrix — Birth Parent, Step Parent, Foster Parent, Birth Child, Step Child, Foster Child, Sister/Brother, Grandparent, Grandchild, Common-law Partner, In-law, Other Related, Unrelated, Husband/Wife, Adopted Child, Adoptive Parent, Same-sex Partner. QML does not support multi-respondent relationship matrices; captured at the household level in the original CATI system.)"

    # =========================================================================
    # BLOCK 3: DWELLING CHARACTERISTICS
    # =========================================================================
    # HHLD_Q1: Dwelling owned?
    # (HHLD_Q2 is not in inventory — omitted)
    # HHLD_Q3: Number of bedrooms
    # HHLD_Q4: Pet in household? (No → skip to HHLD_Q6)
    # HHLD_Q5: What kind of pet? (precondition: HHLD_Q4=Yes)
    # HHLD_Q5a: Pet lives mainly indoors? (precondition: HHLD_Q4=Yes)
    # HHLD_Q6: Type of dwelling (interviewer-coded)
    # =========================================================================
    - id: b_dwelling
      title: "Dwelling Characteristics"
      items:
        # HHLD_Q1 / DHC4_OWN: Dwelling owned?
        - id: q_hhld_q1
          kind: Question
          title: "Now a few questions about your dwelling. Is this dwelling owned by a member of this household (even if being paid for)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD_Q3 / DHC4_BED: Number of bedrooms
        # Note: if no separate, enclosed bedroom enter "00"
        - id: q_hhld_q3
          kind: Question
          title: "How many bedrooms are there in this dwelling? (If no separate, enclosed bedroom, enter 0.)"
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Bedrooms:"

        # HHLD_Q4 / DH_4_P1: Pet in household?
        # No → GO TO HHLD_Q6 (skip HHLD_Q5 and HHLD_Q5a)
        - id: q_hhld_q4
          kind: Question
          title: "Is there a pet in this household?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD_Q5 / DH_4DP2: What kind of pet?
        # Precondition: HHLD_Q4 = Yes (1)
        # Original: Checkbox — do not read list, mark all that apply
        - id: q_hhld_q5
          kind: Question
          title: "What kind of pet? (Do not read list; mark all that apply.)"
          precondition:
            - predicate: q_hhld_q4.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Dog"
              2: "Cat"
              4: "Other"

        # HHLD_Q5a / DH_4_P3: Pet lives mainly indoors?
        # Precondition: HHLD_Q4 = Yes (1)
        - id: q_hhld_q5a
          kind: Question
          title: "Does this pet or do any of these pets live mainly indoors?"
          precondition:
            - predicate: q_hhld_q4.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD_Q6 / DHC4_DWE: Type of dwelling (interviewer-coded by observation)
        - id: q_hhld_q6
          kind: Question
          title: "Record type of dwelling (by interviewer observation)."
          input:
            control: Radio
            labels:
              1: "Single detached house"
              2: "Semi-detached or double"
              3: "Garden house/town-house/row house"
              4: "Duplex"
              5: "Low-rise apartment (less than 5 stories)"
              6: "High-rise apartment (5 or more stories)"
              7: "Institution"
              8: "Hotel/rooming/lodging house/camp/Hutterite Colony"
              9: "Mobile home"
              10: "Other (Specify)"

    # =========================================================================
    # BLOCK 4: ADMINISTRATION
    # =========================================================================
    # HHLD_Q7: Information source indicator (interviewer-recorded)
    # HHLD_Q8: Language of interview (interviewer-recorded)
    # =========================================================================
    - id: b_household_administration
      title: "Administration"
      items:
        # HHLD_Q7 / AM34_SRC: Information source indicator
        # Interviewer-coded: who is providing the information
        - id: q_hhld_q7
          kind: Question
          title: "Information Source Indicator — who is providing the information. (Interviewer-recorded.)"
          input:
            control: Radio
            labels:
              1: "Self (respondent)"
              2: "Proxy (another household member)"
              3: "Other"

        # HHLD_Q8 / AM34_LNG: Language of interview (interviewer-recorded)
        - id: q_hhld_q8
          kind: Question
          title: "Record language of interview. (Interviewer-recorded.)"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Arabic"
              4: "Chinese"
              5: "Cree"
              6: "German"
              7: "Greek"
              8: "Hungarian"
              9: "Italian"
              10: "Korean"
              11: "Persian (Farsi)"
              12: "Polish"
              13: "Portuguese"
              14: "Punjabi"
              15: "Spanish"
              16: "Tagalog (Filipino)"
              17: "Ukrainian"
              18: "Vietnamese"
              19: "Other (Specify)"

    # =====================================================================
    # SECTION 02: Two Week Disability
    # =====================================================================
    # =========================================================================
    # TWO-WEEK DISABILITY
    # =========================================================================
    # TWOWK-INT -> TWOWK-Q1 -> TWOWK-Q2 -> TWOWK-Q3 -> TWOWK-Q4 -> TWOWK-Q5
    #
    # Routing summary:
    #   Q1: Yes -> Q2, No -> Q3, DK/R -> Q5
    #   Q2: If 14 days -> Q5, else -> Q3  (DK/R -> Q5)
    #   Q3: Yes -> Q4, No -> Q5, DK/R -> Q5
    #   Q4: -> Q5
    #   Q5: always asked
    #
    # DK/R general rule (TWOWK-END check): DK and R are allowed on every
    # question throughout the General Component (Form H05). Modelled by
    # routing only the primary (non-DK/R) path via preconditions.
    # =========================================================================
    - id: b_two_week_disability
      title: "Two-Week Disability"
      items:
        # TWOWK-INT: Interviewer introduction
        - id: q_twowk_int
          kind: Comment
          title: "The first few questions ask about ...(r/'s) health during the past 14 days."

        # TWOWK-Q1 / TWC4_1
        - id: q_twowk_q1
          kind: Question
          title: "It is important for you to refer to the 14-day period from %2WKSAGO% to %YESTERDAY%. During that period, did ... stay in bed at all because of illness or injury including any nights spent as a patient in a hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              0: "No"

        # TWOWK-Q2 / TWC4_2
        # Asked only when Q1 = Yes (stayed in bed).
        # Routing: If = 14 days --> GO TO TWOWK-Q5; DK/R --> GO TO TWOWK-Q5
        - id: q_twowk_q2
          kind: Question
          title: "How many days did ... stay in bed for all or most of the day? (Enter 0 if less than a day.)"
          precondition:
            - predicate: q_twowk_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 14

        # TWOWK-Q3 / TWC4_3
        # Asked when NOT (stayed in bed all 14 days):
        #   - Q1 = No (did not stay in bed at all), OR
        #   - Q1 = Yes AND Q2 < 14 (stayed in bed but fewer than all 14 days)
        # Routing: Yes -> Q4, No -> Q5, DK/R -> Q5
        - id: q_twowk_q3
          kind: Question
          title: "(Not counting days spent in bed) During those 14 days, were there any days that ... cut down on things you/he/she normally do/does because of illness or injury?"
          precondition:
            - predicate: (q_twowk_q1.outcome == 0) or (q_twowk_q1.outcome == 1 and q_twowk_q2.outcome < 14)
          input:
            control: Radio
            labels:
              1: "Yes"
              0: "No"

        # TWOWK-Q4 / TWC4_4
        # Asked only when Q3 = Yes (cut down on activities).
        - id: q_twowk_q4
          kind: Question
          title: "How many days did ... cut down on things for all or most of the day? (Enter 0 if less than a day.)"
          precondition:
            - predicate: q_twowk_q3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 14

        # TWOWK-Q5 / TWC4_5
        # Always asked (no precondition).
        - id: q_twowk_q5
          kind: Question
          title: "Do(es) ... have a regular medical doctor?"
          input:
            control: Radio
            labels:
              1: "Yes"
              0: "No"

        # CHECK TWOWK-END: DK and R are allowed on every question throughout
        # the General Component (Form H05). No filtering action required here.
        - id: q_twowk_end
          kind: Comment
          title: "CHECK: DK and R are allowed on every question throughout the General Component (Form H05)."

    # =====================================================================
    # SECTION 03: Health Care Utilization
    # =====================================================================
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

    # =====================================================================
    # SECTION 04: Restriction Chronic
    # =====================================================================
    # =========================================================================
    # RESTRICTION OF ACTIVITIES
    # =========================================================================
    # RESTR-CINT: If age < 12, skip entire block
    # RESTR-INT -> RESTR-Q1(a-d) -> RESTR-Q2 -> CHECK RESTR-C3:
    #   Any Q1 Yes  -> RESTR-Q3 -> RESTR-Q5
    #   Q2 Yes only -> RESTR-Q4 -> RESTR-Q5
    #   Otherwise   -> RESTR-Q6
    # RESTR-Q6: Always asked within section
    #
    # DK/R handling: DK/R on any Q1 sub-item or Q2 routes to next section.
    # Modelled by routing only the primary (Yes=1, No=2, Not applicable=3) path
    # via preconditions; DK/R paths are absorbed by the block-level age gate.
    # =========================================================================
    - id: b_restriction
      title: "Restriction of Activities"
      precondition:
        - predicate: age >= 12
      items:
        # RESTR-INT: Interviewer introduction
        - id: q_restr_int
          kind: Comment
          title: "The next few questions deal with any health limitations which affect ...(r/'s) daily activities. In these questions, 'long-term conditions' refer to conditions that have lasted or are expected to last 6 months or more."

        # RESTR-Q1a / RAC4_1A: Limitation at home
        - id: q_restr_q1a
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do at home?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Refused"

        # RESTR-Q1b / RAC4_1B: Limitation at school
        - id: q_restr_q1b
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do at school?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"
              7: "Refused"

        # RESTR-Q1c / RAC4_1C: Limitation at work
        - id: q_restr_q1c
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do at work?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"
              7: "Refused"

        # RESTR-Q1d / RAC4_1D: Limitation in other activities
        - id: q_restr_q1d
          kind: Question
          title: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do in other activities such as transportation to or from work or leisure time activities?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Refused"

        # RESTR-Q2 / RAC4_2: Long-term disabilities
        - id: q_restr_q2
          kind: Question
          title: "Do(es) ... have any long term disabilities or handicaps?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Refused"

        # RESTR-Q3 / RAC4_3C: Main condition causing activity limitation
        # CHECK RESTR-C3: Asked if any Q1 sub-item = Yes
        - id: q_restr_q3
          kind: Question
          title: "What is the main condition or health problem causing ... to be limited in your/his/her activities?"
          precondition:
            - predicate: q_restr_q1a.outcome == 1 or q_restr_q1b.outcome == 1 or q_restr_q1c.outcome == 1 or q_restr_q1d.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe the main condition (up to 25 characters)"
            maxLength: 25

        # RESTR-Q4 / RAC4_3C: Main condition causing disability
        # CHECK RESTR-C3: Asked if Q2 = Yes but NO Q1 sub-item = Yes
        - id: q_restr_q4
          kind: Question
          title: "What is the main condition or health problem causing ... to have a long term disability or handicap?"
          precondition:
            - predicate: q_restr_q1a.outcome != 1 and q_restr_q1b.outcome != 1 and q_restr_q1c.outcome != 1 and q_restr_q1d.outcome != 1 and q_restr_q2.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe the main condition (up to 25 characters)"
            maxLength: 25

        # RESTR-Q5 / RAC4_5: Cause description
        # Asked after Q3 or Q4 — i.e., when Q3 was shown OR Q4 was shown
        - id: q_restr_q5
          kind: Question
          title: "Which one of the following is the best description of the cause of this condition?"
          precondition:
            - predicate: q_restr_q1a.outcome == 1 or q_restr_q1b.outcome == 1 or q_restr_q1c.outcome == 1 or q_restr_q1d.outcome == 1 or (q_restr_q1a.outcome != 1 and q_restr_q1b.outcome != 1 and q_restr_q1c.outcome != 1 and q_restr_q1d.outcome != 1 and q_restr_q2.outcome == 1)
          input:
            control: Dropdown
            labels:
              1: "Injury - at home"
              2: "Injury - sports or recreation"
              3: "Injury - motor vehicle"
              4: "Injury - work-related"
              5: "Existed at birth"
              6: "Work environment"
              7: "Disease or illness"
              8: "Natural aging process"
              9: "Psychological or physical abuse"
              10: "Other (Specify)"

        # RESTR-Q6 / RAC4_6A-RAC4_6G: Help needed (Checkbox — always asked)
        - id: q_restr_q6
          kind: Question
          title: "The next question asks about help received. Because of any condition or health problem, do(es) ... need the help of another person in any of the following? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Preparing meals"
              2: "Shopping for groceries or other necessities"
              4: "Doing normal everyday housework"
              8: "Doing heavy household chores such as washing walls, yard work, etc."
              16: "Personal care such as washing, dressing or eating"
              32: "Moving about inside the house"
              64: "None of the above"

    # =========================================================================
    # CHRONIC CONDITIONS
    # =========================================================================
    # CHRON-CINT: If age < 12, skip entire block
    # CHRON-INT -> CHRON-Q1 (individual Switch per condition)
    #   -> CHRON-Q1mm  if cancer = Yes
    #   -> CHRON-Q1cc1 if asthma = Yes
    #   -> CHRON-Q1cc2 if asthma = Yes
    #
    # Age-conditional item:
    #   CCC4_1W (acne): only if age < 30
    #   CCC4_1R, CCC4_1S, CCC4_1T (Alzheimer's, cataracts, glaucoma): age >= 18
    # =========================================================================
    - id: b_chronic
      title: "Chronic Conditions"
      precondition:
        - predicate: age >= 12
      items:
        # CHRON-INT: Interviewer introduction
        - id: q_chron_int
          kind: Comment
          title: "Now I'd like to ask about any chronic health conditions ... may have. Again, 'long-term conditions' refer to conditions that have lasted or are expected to last 6 months or more."

        # CHRON-Q1a / CCC4_1A: Food allergies
        - id: q_chron_q1a
          kind: Question
          title: "Do(es) ... have any of the following long-term conditions diagnosed by a health professional — Food allergies?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1b / CCC4_1B: Other allergies
        - id: q_chron_q1b
          kind: Question
          title: "Do(es) ... have — Other allergies?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1c / CCC4_1C: Asthma
        - id: q_chron_q1c
          kind: Question
          title: "Do(es) ... have — Asthma?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1d / CCC4_1D: Arthritis or rheumatism
        - id: q_chron_q1d
          kind: Question
          title: "Do(es) ... have — Arthritis or rheumatism?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1e / CCC4_1E: Back problems
        - id: q_chron_q1e
          kind: Question
          title: "Do(es) ... have — Back problems excluding arthritis?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1f / CCC4_1F: High blood pressure
        - id: q_chron_q1f
          kind: Question
          title: "Do(es) ... have — High blood pressure?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1g / CCC4_1G: Migraine headaches
        - id: q_chron_q1g
          kind: Question
          title: "Do(es) ... have — Migraine headaches?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1h / CCC4_1H: Chronic bronchitis or emphysema
        - id: q_chron_q1h
          kind: Question
          title: "Do(es) ... have — Chronic bronchitis or emphysema?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1i / CCC4_1I: Sinusitis
        - id: q_chron_q1i
          kind: Question
          title: "Do(es) ... have — Sinusitis?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1j / CCC4_1J: Diabetes
        - id: q_chron_q1j
          kind: Question
          title: "Do(es) ... have — Diabetes?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1k / CCC4_1K: Epilepsy
        - id: q_chron_q1k
          kind: Question
          title: "Do(es) ... have — Epilepsy?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1l / CCC4_1L: Heart disease
        - id: q_chron_q1l
          kind: Question
          title: "Do(es) ... have — Heart disease?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1m / CCC4_1M: Cancer
        - id: q_chron_q1m
          kind: Question
          title: "Do(es) ... have — Cancer?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1n / CCC4_1N: Stomach or intestinal ulcers
        - id: q_chron_q1n
          kind: Question
          title: "Do(es) ... have — Stomach or intestinal ulcers?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1o / CCC4_1O: Effects of stroke
        - id: q_chron_q1o
          kind: Question
          title: "Do(es) ... have — Effects of stroke?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1p / CCC4_1P: Urinary incontinence
        - id: q_chron_q1p
          kind: Question
          title: "Do(es) ... have — Urinary incontinence?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1w / CCC4_1W: Acne requiring prescription medication (age < 30 only)
        - id: q_chron_q1w
          kind: Question
          title: "Do(es) ... have — Acne requiring prescription medication?"
          precondition:
            - predicate: age < 30
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1r / CCC4_1R: Alzheimer's disease or other dementia (age >= 18 only)
        - id: q_chron_q1r
          kind: Question
          title: "Do(es) ... have — Alzheimer's disease or other dementia?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1s / CCC4_1S: Cataracts (age >= 18 only)
        - id: q_chron_q1s
          kind: Question
          title: "Do(es) ... have — Cataracts?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1t / CCC4_1T: Glaucoma (age >= 18 only)
        - id: q_chron_q1t
          kind: Question
          title: "Do(es) ... have — Glaucoma?"
          precondition:
            - predicate: age >= 18
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1v / CCC4_1V: Any other long term condition
        - id: q_chron_q1v
          kind: Question
          title: "Do(es) ... have — Any other long term condition? (Specify)"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # CHRON-Q1mm / CCC4_M1: Cancer type follow-up
        # Precondition: cancer = Yes (Switch on = 1)
        - id: q_chron_q1mm
          kind: Question
          title: "What type(s) of cancer is this? For example, skin, lung or colon cancer."
          precondition:
            - predicate: q_chron_q1m.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe the type(s) of cancer (up to 50 characters)"
            maxLength: 50

        # CHRON-Q1cc1 / CCC4_C7: Asthma attack in past 12 months
        # Precondition: asthma = Yes
        - id: q_chron_q1cc1
          kind: Question
          title: "Have/Has ... had an attack of asthma in the past 12 months?"
          precondition:
            - predicate: q_chron_q1c.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CHRON-Q1cc2 / CCC4_C8: Wheezing or whistling in chest in past 12 months
        # Precondition: asthma = Yes
        - id: q_chron_q1cc2
          kind: Question
          title: "Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months?"
          precondition:
            - predicate: q_chron_q1c.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =====================================================================
    # SECTION 05: Socio Demographics
    # =====================================================================
    # =========================================================================
    # INTRODUCTION
    # =========================================================================
    - id: b_socio_intro
      title: "Introduction"
      items:
        # SOCIO-INT: Section introduction (interviewer instruction, no response)
        - id: q_socio_int
          kind: Comment
          title: "Now I'd like to ask some general background questions about the characteristics of people in your household."

    # =========================================================================
    # COUNTRY OF BIRTH AND IMMIGRATION
    # =========================================================================
    # SOCIO-Q1: Canada (1) or DK/R (20) -> skip to Q4 (ethnicity)
    #           Other country -> ask Q3 (immigration year)
    # SOCIO-Q3: Always ends at Q4 (DK/R included)
    # =========================================================================
    - id: b_socio_birth
      title: "Country of Birth and Immigration"
      items:
        # SOCIO-Q1 / SDC4_1: Country of birth
        # Canada=1, DK/R=20 -> GO TO SOCIO-Q4
        # Any other country -> proceed to SOCIO-Q3
        - id: q_socio_q1
          kind: Question
          title: "In what country were/was ... born? (Do not read list. Mark one only.)"
          input:
            control: Dropdown
            labels:
              1: "Canada"
              2: "China"
              3: "France"
              4: "Germany"
              5: "Greece"
              6: "Guyana"
              7: "Hong Kong"
              8: "Hungary"
              9: "India"
              10: "Italy"
              11: "Jamaica"
              12: "Netherlands"
              13: "Philippines"
              14: "Poland"
              15: "Portugal"
              16: "United Kingdom"
              17: "United States"
              18: "Viet Nam"
              19: "Other (specify)"
              20: "Don't know / Refused"

        # SOCIO-Q1 Other specify
        - id: q_socio_q1_other
          kind: Question
          title: "Please specify the country of birth."
          precondition:
            - predicate: q_socio_q1.outcome == 19
          input:
            control: Textarea
            placeholder: "Specify country..."

        # SOCIO-Q3 / SDC4_3: Year of immigration
        # Only asked if born outside Canada AND not DK/R
        # (Canada=1, DK/R=20 both route to Q4)
        - id: q_socio_q3
          kind: Question
          title: "In what year did ... first immigrate to Canada?"
          precondition:
            - predicate: q_socio_q1.outcome != 1 and q_socio_q1.outcome != 20
          input:
            control: Editbox
            min: 1800
            max: 1999

    # =========================================================================
    # ETHNICITY
    # =========================================================================
    # SOCIO-Q4: Always asked (19 options — use QuestionGroup of Switch items)
    # =========================================================================
    - id: b_socio_ethnicity
      title: "Ethnicity"
      items:
        # SOCIO-Q4 / SDC4_4A-SDC4_4S: Ethnic or cultural groups (mark all that apply)
        - id: qg_socio_q4
          kind: QuestionGroup
          title: "To which ethnic or cultural group(s) did your/his/her ancestors belong? (Do not read list. Mark all that apply.)"
          questions:
            - "Canadian"
            - "French"
            - "English"
            - "German"
            - "Scottish"
            - "Irish"
            - "Italian"
            - "Ukrainian"
            - "Dutch (Netherlands)"
            - "Chinese"
            - "Jewish"
            - "Polish"
            - "Portuguese"
            - "South Asian"
            - "Black"
            - "North American Indian"
            - "Metis"
            - "Inuit/Eskimo"
            - "Other (specify)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q4 Other specify
        - id: q_socio_q4_other
          kind: Question
          title: "Please specify the other ethnic or cultural group."
          precondition:
            - predicate: qg_socio_q4.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify ethnic or cultural group..."

    # =========================================================================
    # LANGUAGE
    # =========================================================================
    # SOCIO-Q5: Languages for conversation (19 options)
    # SOCIO-Q6: Mother tongue (19 options)
    # =========================================================================
    - id: b_socio_language
      title: "Language"
      items:
        # SOCIO-Q5 / SDC4_5A-SDC4_5S: Languages for conversation (mark all that apply)
        - id: qg_socio_q5
          kind: QuestionGroup
          title: "In which languages can ... conduct a conversation? (Do not read list. Mark all that apply.)"
          questions:
            - "English"
            - "French"
            - "Arabic"
            - "Chinese"
            - "Cree"
            - "German"
            - "Greek"
            - "Hungarian"
            - "Italian"
            - "Korean"
            - "Persian (Farsi)"
            - "Polish"
            - "Portuguese"
            - "Punjabi"
            - "Spanish"
            - "Tagalog (Filipino)"
            - "Ukrainian"
            - "Vietnamese"
            - "Other (specify)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q5 Other specify
        - id: q_socio_q5_other
          kind: Question
          title: "Please specify the other language(s) for conversation."
          precondition:
            - predicate: qg_socio_q5.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # SOCIO-Q6 / SDC4_6A-SDC4_6S: Mother tongue (mark all that apply)
        - id: qg_socio_q6
          kind: QuestionGroup
          title: "What is the language that ... first learned at home in childhood and can still understand? (Do not read list. Mark all that apply.)"
          questions:
            - "English"
            - "French"
            - "Arabic"
            - "Chinese"
            - "Cree"
            - "German"
            - "Greek"
            - "Hungarian"
            - "Italian"
            - "Korean"
            - "Persian (Farsi)"
            - "Polish"
            - "Portuguese"
            - "Punjabi"
            - "Spanish"
            - "Tagalog (Filipino)"
            - "Ukrainian"
            - "Vietnamese"
            - "Other (specify)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q6 Other specify
        - id: q_socio_q6_other
          kind: Question
          title: "Please specify the other mother tongue language."
          precondition:
            - predicate: qg_socio_q6.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

    # =========================================================================
    # RACE
    # =========================================================================
    # SOCIO-Q7: 11 options — use QuestionGroup of Switch items
    # =========================================================================
    - id: b_socio_race
      title: "Race"
      items:
        # SOCIO-Q7 / SDC4_7A-SDC4_7L: Race or colour (mark all that apply)
        - id: qg_socio_q7
          kind: QuestionGroup
          title: "How would you best describe ...(r/'s) race or colour? (Do not read list. Mark all that apply.)"
          questions:
            - "White"
            - "Chinese"
            - "South Asian"
            - "Black"
            - "Filipino"
            - "West Asian or North African"
            - "South East Asian"
            - "Japanese"
            - "Korean"
            - "Native/Aboriginal Peoples of North America"
            - "Other (specify)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q7 Other specify
        - id: q_socio_q7_other
          kind: Question
          title: "Please specify the other race or colour."
          precondition:
            - predicate: qg_socio_q7.outcome[10] == 1
          input:
            control: Textarea
            placeholder: "Specify race or colour..."

    # =========================================================================
    # EDUCATION
    # =========================================================================
    # EDUC-C1: age < 12 -> skip entire education block
    # EDUC-Q1: No schooling (0) -> skip rest; age < 15 -> skip rest; DK/R (10) -> skip rest
    # EDUC-Q2: Asked if Q1 has a schooling value (> 0 and != 10) and age >= 15
    # EDUC-Q3: Post-secondary. No (2) -> skip to C5/Q5. DK/R (3) -> skip all.
    # EDUC-Q4: Highest level. Only if Q3 = Yes (1).
    # EDUC-C5: age >= 65 -> skip Q5 and Q6
    # EDUC-Q5: Currently attending school. No/DK/R -> skip Q6.
    # EDUC-Q6: Full/part time. Only if Q5 = Yes (1).
    # =========================================================================
    - id: b_education
      title: "Education"
      precondition:
        - predicate: age >= 12
      items:
        # EDUC-Q1 / EDC4_4: Years of elementary and high school completed
        # 0=No schooling (->skip rest), 1-9=years 1-9, 10=DK/R (->skip rest)
        # Note: age < 15 also routes to Labour Force (skip rest of education)
        - id: q_educ_q1
          kind: Question
          title: "Excluding kindergarten, how many years of elementary and high school have/has ... successfully completed? (Do not read list. Mark one only.)"
          input:
            control: Radio
            labels:
              0: "No schooling"
              1: "One to five years"
              2: "Six"
              3: "Seven"
              4: "Eight"
              5: "Nine"
              6: "Ten"
              7: "Eleven"
              8: "Twelve"
              9: "Thirteen"
              10: "Don't know / Refused"

        # EDUC-Q2 / EDC4_5: High school graduation
        # Skipped if: No schooling (0), DK/R (10), or age < 15
        - id: q_educ_q2
          kind: Question
          title: "Have/has ... graduated from high school?"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUC-Q3 / EDC4_6: Post-secondary attendance
        # Skipped if: No schooling, DK/R on Q1, or age < 15
        # No (2) -> skip to EDUC-C5/Q5; DK/R (3) -> skip all remaining education
        - id: q_educ_q3
          kind: Question
          title: "Have/has ... ever attended any other kind of school such as university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution?"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # EDUC-Q4 / EDC4_7: Highest education level
        # Only if Q3 = Yes (1)
        - id: q_educ_q4
          kind: Question
          title: "What is the highest level of education that ... have/has attained? (Do not read list. Mark one only.)"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
            - predicate: q_educ_q3.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Some trade/technical/vocational school or business college"
              2: "Some community college/CEGEP/nursing school"
              3: "Some university"
              4: "Diploma/certificate from trade/technical/vocational school or business college"
              5: "Diploma/certificate from community college/CEGEP/nursing school"
              6: "Bachelor's or undergraduate degree or teacher's college"
              7: "Master's degree"
              8: "Degree in medicine/dentistry/veterinary medicine/optometry"
              9: "Earned doctorate"
              10: "Other (specify)"

        # EDUC-Q4 Other specify
        - id: q_educ_q4_other
          kind: Question
          title: "Please specify the highest level of education attained."
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
            - predicate: q_educ_q3.outcome == 1
            - predicate: q_educ_q4.outcome == 10
          input:
            control: Textarea
            placeholder: "Specify education level..."

        # EDUC-Q5 / EDC4_1: Currently attending school
        # Skipped if: age >= 65, or Q1 issues, or Q3 = DK/R (3)
        # No (2) or DK/R (3) -> skip Q6
        - id: q_educ_q5
          kind: Question
          title: "Are/Is ... currently attending a school, college or university?"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
            - predicate: q_educ_q3.outcome != 3
            - predicate: age < 65
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # EDUC-Q6 / EDC4_2: Full-time or part-time enrollment
        # Only if Q5 = Yes (1)
        - id: q_educ_q6
          kind: Question
          title: "Are/Is ... enrolled as a full-time or part-time student?"
          precondition:
            - predicate: q_educ_q1.outcome > 0 and q_educ_q1.outcome != 10 and age >= 15
            - predicate: q_educ_q3.outcome != 3
            - predicate: age < 65
            - predicate: q_educ_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

    # =====================================================================
    # SECTION 06: Labour Force Income
    # =====================================================================
    # =========================================================================
    # BLOCK 1: LABOUR FORCE — MAIN ACTIVITY GATE
    # =========================================================================
    # LFS-C1: If age < 15 → skip entire Labour Force section → Income
    # LFS-Q1: Main activity
    # LFS-I2: Employment intro (Comment)
    # LFS-C2: If Q1=2 or Q1=3 (working) → GO TO Q3 (skip Q2)
    # LFS-Q2: Worked for pay in past 12 months?
    # LFS-C2A: If Q1=7 (retired) → GO TO LFS-C18; else → GO TO Q17B
    # =========================================================================
    - id: b_main_activity
      title: "Labour Force — Main Activity"
      precondition:
        - predicate: age >= 15
      items:
        # LFS-Q1: Current main activity
        - id: q_lfs_q1
          kind: Question
          title: "What do/does ... consider to be your/his/her current main activity? (Do not read list. Mark one only.)"
          input:
            control: Radio
            labels:
              1: "Caring for family"
              2: "Working for pay or profit"
              3: "Caring for family and working for pay or profit"
              4: "Going to school"
              5: "Recovering from illness / on disability"
              6: "Looking for work"
              7: "Retired"
              8: "Other (Specify)"

        # LFS-I2: Employment section introduction
        - id: q_lfs_i2
          kind: Comment
          title: "The next section contains questions about jobs or employment which ... have/has had during the past 12 months, that is, from 12 months ago to today. Please include such employment as part-time jobs, contract work, baby sitting and any other paid work."

        # LFS-Q2: Worked for pay in past 12 months?
        # LFS-C2: IF Q1=2 (Working) or Q1=3 (Caring+Working) → skip to Q3
        # So Q2 is shown only when Q1 is NOT 2 or 3.
        - id: q_lfs_q2
          kind: Question
          title: "Have/has you/he/she worked for pay or profit at any time in the past 12 months?"
          precondition:
            - predicate: q_lfs_q1.outcome not in [2, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 2: EMPLOYMENT DETAILS (Q3–Q16)
    # =========================================================================
    # Reached when:
    #   - Q1=2 or Q1=3 (currently working → jumped to Q3), OR
    #   - Q2=1 (worked for pay in past 12 months)
    #
    # NOTE: The original instrument uses a roster of up to 6 jobs (LFS-Q3.n
    # through Q11.n). QML cannot model dynamic rosters; only the MAIN (first)
    # job is captured here. The full employer roster is represented by a single
    # open-text question. The roster loop (n=1..6) and multi-job logic are
    # omitted by design.
    #
    # LFS-Q3: Employer name (open text; roster slot 1 only)
    # LFS-Q4: Had job 1 year ago? Y→Q6, N→Q5
    # LFS-Q5: Start date (modeled as year Editbox)
    # LFS-Q6: Currently have that job? Y→Q8, N→Q7
    # LFS-Q7: Stop date (modeled as year Editbox)
    # LFS-Q8: Hours per week
    # LFS-Q9: Work schedule
    # LFS-Q10: Weekend work?
    # LFS-Q11: Other jobs? (simplified — roster not supported)
    # LFS-C12: IF Q11=No → skip Q12
    # LFS-Q12: Which was main job? (modeled as Comment — roster not available)
    # LFS-Q13: Industry description
    # LFS-Q14: Occupation description
    # LFS-Q15: Duties description
    # LFS-Q16: Class of worker
    # =========================================================================
    - id: b_employment_details
      title: "Employment Details"
      precondition:
        - predicate: age >= 15
        - predicate: q_lfs_q1.outcome in [2, 3] or q_lfs_q2.outcome == 1
      items:
        # LFS-Q3: Employer name (main / first job only)
        - id: q_lfs_q3
          kind: Question
          title: "For whom have/has you/he/she worked for pay or profit in the past 12 months? (Enter employer name.)"
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # LFS-Q4: Had that job 1 year ago?
        - id: q_lfs_q4
          kind: Question
          title: "Did you/he/she have that job 1 year ago, without a break in employment since then?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q5: When started? (only if Q4=No; Q4=Yes → GO TO Q6)
        - id: q_lfs_q5
          kind: Question
          title: "When did you/he/she start working at this job or business? (Enter year.)"
          precondition:
            - predicate: q_lfs_q4.outcome == 2
          input:
            control: Editbox
            min: 1900
            max: 2000
            right: "year"

        # LFS-Q6: Currently have that job?
        - id: q_lfs_q6
          kind: Question
          title: "Do/Does you/he/she now have that job?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q7: When stopped? (only if Q6=No; Q6=Yes → GO TO Q8)
        - id: q_lfs_q7
          kind: Question
          title: "When did you/he/she stop working at this job or business? (Enter year.)"
          precondition:
            - predicate: q_lfs_q6.outcome == 2
          input:
            control: Editbox
            min: 1900
            max: 2000
            right: "year"

        # LFS-Q8: Usual hours per week
        - id: q_lfs_q8
          kind: Question
          title: "About how many hours per week do/does/did you/he/she usually work at this job?"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours/week"

        # LFS-Q9: Work schedule
        - id: q_lfs_q9
          kind: Question
          title: "Which of the following best describes the hours you/he/she usually work/works/worked at this job? (Read list. Mark one only.)"
          input:
            control: Dropdown
            labels:
              1: "Regular daytime schedule or shift"
              2: "Regular evening shift"
              3: "Regular night shift"
              4: "Rotating shift (change from days to evenings to nights)"
              5: "Split shift"
              6: "On call"
              7: "Irregular schedule"
              8: "Other (Specify)"

        # LFS-Q10: Weekend work?
        - id: q_lfs_q10
          kind: Question
          title: "Do/Does/Did you/he/she usually work on weekends at this job?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q11: Any other work for pay in past 12 months?
        # (Since only one job is modeled in this QML, this captures whether
        # additional jobs existed; Q12 roster selection is not fully supported.)
        - id: q_lfs_q11
          kind: Question
          title: "Did you/he/she do any other work for pay or profit in the past 12 months?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-C12 / LFS-Q12: Which was the main job?
        # LFS-C12: IF Q11=No → GO TO Q13 (skip Q12)
        # NOTE: Full roster selection unavailable in QML. Modeled as a Comment
        # acknowledging multiple jobs were reported; routing continues to Q13.
        - id: q_lfs_c12_note
          kind: Comment
          title: "(Interviewer note: Multiple jobs reported — main job selection per interviewer manual applies before proceeding to Q13.)"
          precondition:
            - predicate: q_lfs_q11.outcome == 1

        # LFS-Q13: Industry description (main job)
        - id: q_lfs_q13
          kind: Question
          title: "Thinking about this/the main job, what kind of business, service or industry is this? (For example: wheat farm, road maintenance, retail shoe store.)"
          input:
            control: Textarea
            placeholder: "Enter industry description"

        # LFS-Q14: Occupation description (main job)
        - id: q_lfs_q14
          kind: Question
          title: "Again, thinking about this/the main job, what kind of work was/were ... doing? (For example: medical lab technician, accounting clerk, secondary school teacher.)"
          input:
            control: Textarea
            placeholder: "Enter occupation description"

        # LFS-Q15: Duties description (main job)
        - id: q_lfs_q15
          kind: Question
          title: "In this work, what were your/his/her most important duties or activities? (For example: analysis of blood samples, verifying invoices, teaching mathematics.)"
          input:
            control: Textarea
            placeholder: "Enter duties description"

        # LFS-Q16: Class of worker
        - id: q_lfs_q16
          kind: Question
          title: "Did you/he/she work mainly for others for wages or commission or in your/his/her own business, farm or practice? (Do not read list. Mark one only.)"
          input:
            control: Radio
            labels:
              1: "For others for wages, salary or commission"
              2: "In own business, farm or professional practice"
              3: "Unpaid family worker"

    # =========================================================================
    # BLOCK 3: ABSENCE REASON — CURRENTLY EMPLOYED (Q17A)
    # =========================================================================
    # LFS-C17: Calendar gap check (> 6 days). If no gaps → GO TO LFS-C18.
    # LFS-C17A: If any Q6=1 (currently employed) → Q17A; else → Q17B.
    #
    # Routing: Q17A applies when the respondent IS currently employed (Q6=1)
    # but had a gap in work. In the simplified single-job model, Q6=1 means
    # the main job is still held.
    # =========================================================================
    - id: b_absence_reason_employed
      title: "Reason Not Working — Currently Employed"
      precondition:
        - predicate: age >= 15
        - predicate: q_lfs_q1.outcome in [2, 3] or q_lfs_q2.outcome == 1
        - predicate: q_lfs_q6.outcome == 1
      items:
        # LFS-Q17A: Reason for most recent period away from work (currently employed)
        - id: q_lfs_q17a
          kind: Question
          title: "What was the reason that ... were/was not working for pay or profit during the most recent period away from work in the past year? (Do not read list. Mark one only.)"
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Pregnancy"
              3: "Caring for own children"
              4: "Caring for elder relative(s)"
              5: "Other personal or family responsibilities"
              6: "School or educational leave"
              7: "Labour dispute"
              8: "Temporary layoff due to seasonal conditions"
              9: "Temporary layoff — non-seasonal"
              10: "Permanent layoff"
              11: "Unpaid or partially paid vacation"
              12: "Other (Specify)"
              13: "No period not working"

    # =========================================================================
    # BLOCK 4: ABSENCE REASON — NOT CURRENTLY EMPLOYED (Q17B)
    # =========================================================================
    # LFS-C17A: If NOT currently employed → Q17B.
    # Also applies when Q2=No and Q1≠7 (not retired, not working).
    #
    # Routing: Q17B applies when:
    #   - Had employment in past 12 months (Q2=1 or Q1=2/3) AND Q6=2 (no longer has job)
    #   - OR had no employment (Q2=2) AND Q1≠7 (not retired)
    # =========================================================================
    - id: b_absence_reason_not_employed
      title: "Reason Not Currently Working"
      precondition:
        - predicate: age >= 15
        - predicate: q_lfs_q1.outcome not in [2, 3, 7] or (q_lfs_q1.outcome in [2, 3] and q_lfs_q6.outcome == 2)
        - predicate: q_lfs_q2.outcome in [1, 2]
      items:
        # LFS-Q17B: Reason currently not working for pay or profit
        - id: q_lfs_q17b
          kind: Question
          title: "What is the reason that ... are/is currently not working for pay or profit? (Do not read list. Mark one only.)"
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Pregnancy"
              3: "Caring for own children"
              4: "Caring for elder relative(s)"
              5: "Other personal or family responsibilities"
              6: "School or educational leave"
              7: "Labour dispute"
              8: "Temporary layoff due to seasonal conditions"
              9: "Temporary layoff — non-seasonal"
              10: "Permanent layoff"
              11: "Unpaid or partially paid vacation"
              12: "Other (Specify)"
              13: "No period not working"

    # =========================================================================
    # BLOCK 5: LFS-C18 — DERIVED VARIABLE lfs_work
    # =========================================================================
    # LFS-C18: Set lfs_work = 1 if currently working, 0 otherwise.
    # Rule: Q1=2 or Q1=3 → working; OR Q6=1 → working; else → not working.
    # Modeled as a Comment with a codeBlock to set the lfs_work variable.
    # =========================================================================
    - id: b_lfs_derived
      title: "Labour Force Status (Derived)"
      precondition:
        - predicate: age >= 15
      items:
        - id: q_lfs_c18
          kind: Comment
          title: "(System: Labour force working status derived from responses above.)"
          codeBlock: |
            if q_lfs_q1.outcome in [2, 3] or q_lfs_q6.outcome == 1:
              lfs_work = 1
            else:
              lfs_work = 0

    # =========================================================================
    # BLOCK 6: INCOME SOURCES (INCOM-Q1)
    # =========================================================================
    # Asked from knowledgeable person only (no filter in QML; always shown
    # after Labour Force section for eligible respondents).
    #
    # INCOM-Q1: Household income sources (checkbox, multi-select)
    # If INCOM-Q1 = None (key 8192) or DK/R → skip rest
    # If only one source → skip INCOM-Q2, go to INCOM-Q3
    # If multiple sources → ask INCOM-Q2 first
    #
    # Checkbox key assignments (powers of 2):
    #   1   = Wages and salaries
    #   2   = Income from self-employment
    #   4   = Dividends and interest
    #   8   = Unemployment insurance
    #   16  = Worker's compensation
    #   32  = Benefits from CPP/QPP
    #   64  = Retirement pensions/superannuation/annuities
    #   128 = Old Age Security and GIS
    #   256 = Child Tax Benefit
    #   512 = Provincial/municipal social assistance or welfare
    #   1024 = Child Support
    #   2048 = Alimony
    #   4096 = Other Income
    #   8192 = None
    # =========================================================================
    - id: b_income_sources
      title: "Income Sources"
      items:
        # INCOM-Q1: Which income sources?
        - id: q_incom_q1
          kind: Question
          title: "Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (Read list. Mark all that apply.)"
          codeBlock: |
            # Count number of income sources selected (popcount of bitmask).
            # Excludes "None" bit (8192). income_multi=1 means >1 source selected.
            v = q_incom_q1.outcome & 4095  # mask out the None bit (8192) and Others
            count = bin(v).count('1')
            if count > 1:
              income_multi = 1
            else:
              income_multi = 0
          input:
            control: Checkbox
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              4: "Dividends and interest"
              8: "Unemployment insurance"
              16: "Worker's compensation"
              32: "Benefits from CPP/QPP"
              64: "Retirement pensions, superannuation or annuities"
              128: "Old Age Security and GIS"
              256: "Child Tax Benefit"
              512: "Provincial/municipal social assistance or welfare"
              1024: "Child Support"
              2048: "Alimony"
              4096: "Other income"
              8192: "None"

    # =========================================================================
    # BLOCK 7: MAIN INCOME SOURCE (INCOM-Q2)
    # =========================================================================
    # Only asked if more than one source was selected in INCOM-Q1.
    # income_multi is computed in q_incom_q1's codeBlock:
    #   income_multi = 1 if popcount(outcome & 4095) > 1, else 0.
    # =========================================================================
    - id: b_main_income_source
      title: "Main Income Source"
      precondition:
        - predicate: income_multi == 1
      items:
        # INCOM-Q2: What was the main source of income?
        - id: q_incom_q2
          kind: Question
          title: "What was the main source of income? (Do not read list. Mark one only.)"
          input:
            control: Dropdown
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              3: "Dividends and interest"
              4: "Unemployment insurance"
              5: "Worker's compensation"
              6: "Benefits from CPP/QPP"
              7: "Retirement pensions, superannuation or annuities"
              8: "Old Age Security and GIS"
              9: "Child Tax Benefit"
              10: "Provincial/municipal social assistance or welfare"
              11: "Child Support"
              12: "Alimony"
              13: "Other income"

    # =========================================================================
    # BLOCK 8: INCOME BRACKET (INCOM-Q3)
    # =========================================================================
    # Only asked if INCOM-Q1 is not None (8192).
    #
    # The original instrument uses an unfolding binary tree of 7 yes/no
    # questions (INC4_3A through INC4_3G) to arrive at one of 11 brackets.
    # This is simplified to a single Dropdown listing all final brackets,
    # per the QML conversion instruction.
    # =========================================================================
    - id: b_income_bracket
      title: "Income Bracket"
      precondition:
        - predicate: q_incom_q1.outcome != 8192
        - predicate: q_incom_q1.outcome != 0
      items:
        # INCOM-Q3: Total household income bracket
        - id: q_incom_q3
          kind: Question
          title: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?"
          input:
            control: Dropdown
            labels:
              1: "No income"
              2: "Under $5,000"
              3: "$5,000 to $9,999"
              4: "$10,000 to $14,999"
              5: "$15,000 to $19,999"
              6: "$20,000 to $29,999"
              7: "$30,000 to $39,999"
              8: "$40,000 to $49,999"
              9: "$50,000 to $59,999"
              10: "$60,000 to $79,999"
              11: "$80,000 or more"

    # =====================================================================
    # SECTION 07: General Health Preventive
    # =====================================================================
    # =========================================================================
    # BLOCK 1: ADMINISTRATION (H05-P1, H05-P2, H06-P1)
    # =========================================================================
    - id: b_health_administration
      title: "Administration"
      items:
        # H05-P1 / AM54_TEL: Interview mode
        - id: q_h05_p1
          kind: Question
          title: "Was this interview conducted on the telephone or in person?"
          input:
            control: Radio
            labels:
              1: "On telephone"
              2: "In person"
              3: "Both (Specify in comments)"

        # H05-P2 / AM54_LNG: Language of interview
        - id: q_h05_p2
          kind: Question
          title: "Record language of interview."
          input:
            control: Dropdown
            labels:
              1: "English"
              2: "French"
              3: "Arabic"
              4: "Chinese"
              5: "Cree"
              6: "German"
              7: "Greek"
              8: "Hungarian"
              9: "Italian"
              10: "Korean"
              11: "Persian (Farsi)"
              12: "Polish"
              13: "Portuguese"
              14: "Punjabi"
              15: "Spanish"
              16: "Tagalog (Filipino)"
              17: "Ukrainian"
              18: "Vietnamese"
              19: "Other (Specify)"

        # H06-P1 / AM64_SRC: Information source
        # Form H06 is for selected respondent aged 12+; proxy permitted for
        # those unable to answer themselves.
        - id: q_h06_p1
          kind: Question
          title: "Who is providing the information for this person's form?"
          input:
            control: Textarea
            placeholder: "Record name/relationship of person providing information..."

    # =========================================================================
    # BLOCK 2: GENERAL HEALTH (GENHLT-Q1 to GENHLT-Q3)
    # =========================================================================
    - id: b_general_health
      title: "General Health"
      items:
        # GENHLT-Q1 / GHC4_1: Self-rated health
        - id: q_genhlt_q1
          kind: Question
          title: "In general, would you say your health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # GENHLT-C2: Check/Filter
        # If sex = female AND age >= 15 AND age <= 49 → ask GENHLT-Q2
        # Otherwise → go to Height/Weight section
        # Modeled as precondition on GENHLT-Q2.

        # GENHLT-Q2 / HWC4_1: Pregnancy question
        # Precondition: female (sex==2) AND age 15-49
        # 1=Yes → ask GENHLT-Q3; 2=No or DK/R → skip to Height/Weight
        - id: q_genhlt_q2
          kind: Question
          title: "It is important to know when analyzing health whether or not the person is pregnant. Are you pregnant?"
          precondition:
            - predicate: sex == 2 and age >= 15 and age <= 49
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refused"
          codeBlock: |
            is_pregnant = 1 if q_genhlt_q2.outcome == 1 else 0

        # GENHLT-Q3 / GHC4_3: Physician/midwife planning
        # Precondition: pregnant (Q2 == 1)
        - id: q_genhlt_q3
          kind: Question
          title: "Are you planning to use the services of a physician, midwife or both?"
          precondition:
            - predicate: q_genhlt_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Physician only"
              2: "Midwife only"
              3: "Both physician and midwife"
              4: "Neither"

    # =========================================================================
    # BLOCK 3: HEIGHT / WEIGHT (HTWT-Q1, HTWT-Q2)
    # =========================================================================
    - id: b_height_weight
      title: "Height and Weight"
      items:
        # HTWT-Q1 / HWC4_2HT: Height
        # Note: Original records in feet+inches OR centimetres; modeled as
        # centimetres (single numeric entry) for QML simplicity.
        - id: q_htwt_q1
          kind: Question
          title: "How tall are you without shoes on? (Enter height in centimetres)"
          input:
            control: Editbox
            min: 0
            max: 300
            right: "cm"

        # HTWT-Q2 / HWC4_3LB / HWC4_3KG: Weight
        # Note: Original records in pounds OR kilograms.
        - id: q_htwt_q2
          kind: Question
          title: "How much do you weigh? (Enter weight in pounds or kilograms — note unit used)"
          input:
            control: Editbox
            min: 0
            max: 500
            right: "lbs/kg"

    # =========================================================================
    # BLOCK 4: PREVENTIVE HEALTH PRACTICES (PHP-Q1 to PHP-Q3a)
    # =========================================================================
    # Non-proxy only section.
    # PHP-C2 routing:
    #   Female age >= 35       → ask PHP-Q2 (mammogram), then PHP-Q3 (PAP)
    #   Female age 18-34       → skip PHP-Q2, ask PHP-Q3 (PAP)
    #   Male OR female age <=17 → skip entire section (go to Smoking)
    # Modeled via individual item preconditions.
    # =========================================================================
    - id: b_preventive_health
      title: "Preventive Health Practices"
      items:
        # PHP-Q1 / BPC4_1: Blood pressure check timing
        # R (refused, code 9) → skip rest of Preventive Health section
        - id: q_php_q1
          kind: Question
          title: "When did you last have your blood pressure checked by a health professional?"
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than a year ago"
              3: "1 year to less than 2 years ago"
              4: "2 years to less than 5 years ago"
              5: "5 years or more ago"
              6: "Never"
              9: "Refused"

        # PHP-Q2 / WHC4_30: Mammogram ever
        # Precondition: female (sex==2) AND age >= 35
        # PHP-C2: female age >= 35 → ask Q2
        # 1=Yes → ask PHP-Q2a and PHP-Q2b; 2=No or DK → ask PHP-Q3; R → skip section
        - id: q_php_q2
          kind: Question
          title: "Have you ever had a mammogram, that is, a breast X-ray?"
          precondition:
            - predicate: q_php_q1.outcome != 9
            - predicate: sex == 2 and age >= 35
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refused"

        # PHP-Q2a / WHC4_32: When last mammogram
        # Precondition: Q2 == Yes
        - id: q_php_q2a
          kind: Question
          title: "When was the last time you had a mammogram?"
          precondition:
            - predicate: q_php_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than one year ago"
              3: "1 year to less than 2 years ago"
              4: "2 years or more ago"

        # PHP-Q2b / WHC4_33: Why last mammogram
        # Precondition: Q2 == Yes
        - id: q_php_q2b
          kind: Question
          title: "Why did you have your last mammogram?"
          precondition:
            - predicate: q_php_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Breast problem"
              2: "Check-up, no particular problem"
              3: "Other (specify)"

        # PHP-Q3 / WHC4_20: PAP smear ever
        # Precondition: female (sex==2) AND age >= 18
        # PHP-C2: female age >= 35 also gets Q3 (after Q2); female age 18-34 gets Q3 directly
        # No/DK/R → skip PHP-Q3a
        - id: q_php_q3
          kind: Question
          title: "Have you ever had a PAP smear test?"
          precondition:
            - predicate: q_php_q1.outcome != 9
            - predicate: sex == 2 and age >= 18
            - predicate: q_php_q2.outcome != 9 or age < 35
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refused"

        # PHP-Q3a / WHC4_22: When last PAP smear
        # Precondition: Q3 == Yes
        - id: q_php_q3a
          kind: Question
          title: "When was the last time you had a PAP smear test?"
          precondition:
            - predicate: q_php_q3.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 6 months ago"
              2: "6 months to less than one year ago"
              3: "1 year to less than 3 years ago"
              4: "3 years to less than 5 years ago"
              5: "5 years or more ago"

    # =====================================================================
    # SECTION 08: Smoking Alcohol
    # =====================================================================
    # =========================================================================
    # BLOCK 1: SMOKING (SMOK-INT to SMOK-Q8)
    # =========================================================================
    # Routing summary:
    #   SMOK-Q2 = 1 (Daily)        → Q3 → Q4 → Alcohol
    #   SMOK-Q2 = 2 (Occasionally) → Q5 → [Q6 → Q7 → Q8 if Yes] → Alcohol
    #   SMOK-Q2 = 3 (Not at all)   → Q4a → [Q5 → Q6 → Q7 → Q8 if Yes] → Alcohol
    #   SMOK-Q2 = DK/R             → skip to Alcohol
    # =========================================================================
    - id: b_smoking
      title: "Smoking"
      items:
        # SMOK-INT: Section introduction (no response)
        - id: q_smok_int
          kind: Comment
          title: "The next few questions are about smoking."

        # SMOK-Q1 / SMC4_1: Household smoking
        # Always asked
        - id: q_smok_q1
          kind: Question
          title: "Does anyone in this household smoke regularly inside the house?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SMOK-Q2 / SMC4_2: Current smoking status
        # 1=Daily → Q3 → Q4
        # 2=Occasionally → Q5
        # 3=Not at all → Q4a
        # DK/R → skip to Alcohol section
        - id: q_smok_q2
          kind: Question
          title: "At the present time, does ... smoke cigarettes daily, occasionally or not at all?"
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Occasionally"
              3: "Not at all"

        # SMOK-Q3 / SMC4_3: Age began smoking daily
        # Precondition: daily smoker (Q2 = 1)
        - id: q_smok_q3
          kind: Question
          title: "At what age did ... begin to smoke cigarettes daily?"
          precondition:
            - predicate: q_smok_q2.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years old"

        # SMOK-Q4 / SMC4_4: Cigarettes per day (current daily smoker)
        # Precondition: daily smoker (Q2 = 1)
        # After Q4 → GO TO Alcohol section
        - id: q_smok_q4
          kind: Question
          title: "How many cigarettes does ... smoke each day now?"
          precondition:
            - predicate: q_smok_q2.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 200
            right: "cigarettes"

        # SMOK-Q4a / SMC4_4A: Ever smoked at all?
        # Precondition: not at all (Q2 = 3)
        # Yes (1) → Q5; No (2) → Alcohol; DK/R → Alcohol
        - id: q_smok_q4a
          kind: Question
          title: "Has ... ever smoked cigarettes at all?"
          precondition:
            - predicate: q_smok_q2.outcome == 3
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # SMOK-Q5 / SMC4_5: Ever smoked daily?
        # Precondition: occasionally (Q2=2) OR (not at all AND Q4a=Yes)
        # Yes (1) → Q6 → Q7 → Q8; No (2) → Alcohol; DK/R → Alcohol
        - id: q_smok_q5
          kind: Question
          title: "Has ... ever smoked cigarettes daily?"
          precondition:
            - predicate: q_smok_q2.outcome == 2 or (q_smok_q2.outcome == 3 and q_smok_q4a.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # SMOK-Q6 / SMC4_6: Age began smoking daily (former daily smoker)
        # Precondition: ever smoked daily (Q5 = 1)
        - id: q_smok_q6
          kind: Question
          title: "At what age did ... begin to smoke cigarettes daily?"
          precondition:
            - predicate: q_smok_q2.outcome == 2 or (q_smok_q2.outcome == 3 and q_smok_q4a.outcome == 1)
            - predicate: q_smok_q5.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years old"

        # SMOK-Q7 / SMC4_7: Cigarettes per day when smoked daily
        # Precondition: ever smoked daily (Q5 = 1)
        - id: q_smok_q7
          kind: Question
          title: "How many cigarettes did ... usually smoke each day?"
          precondition:
            - predicate: q_smok_q2.outcome == 2 or (q_smok_q2.outcome == 3 and q_smok_q4a.outcome == 1)
            - predicate: q_smok_q5.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 200
            right: "cigarettes"

        # SMOK-Q8 / SMC4_8: Age stopped smoking daily
        # Precondition: ever smoked daily (Q5 = 1)
        - id: q_smok_q8
          kind: Question
          title: "At what age did ... stop smoking cigarettes daily?"
          precondition:
            - predicate: q_smok_q2.outcome == 2 or (q_smok_q2.outcome == 3 and q_smok_q4a.outcome == 1)
            - predicate: q_smok_q5.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years old"

    # =========================================================================
    # BLOCK 2: ALCOHOL (ALCO-INT to ALCO-Q7)
    # =========================================================================
    # Routing summary:
    #   ALCO-Q1 = 1 (Yes) → Q2 → Q3 → Q4 → Q5
    #     ALCO-Q5 = 1 (Yes) → Q5A → done
    #     ALCO-Q5 = 2/DK/R  → done
    #   ALCO-Q1 = 2 (No)  → Q5B
    #     ALCO-Q5B = 1 (Yes) → Q6
    #       ALCO-Q6 = 1 (Yes) → Q7
    #     ALCO-Q5B = 2/DK/R  → done
    #   ALCO-Q1 = DK/R    → skip section (Physical Activities)
    # Note: ALCO-Q4 is non-proxy only; we include it unconditionally
    #       since proxy status is not modelled in this section.
    # =========================================================================
    - id: b_alcohol
      title: "Alcohol"
      items:
        # ALCO-INT: Section introduction (no response)
        - id: q_alco_int
          kind: Comment
          title: "Now, some questions about ...(r/'s) alcohol consumption. When we use the word drink it means: one bottle or can of beer or a glass of draft / one glass of wine or a wine cooler / one straight or mixed drink with one and a half ounces of hard liquor."

        # ALCO-Q1 / ALC4_1: Had a drink in past 12 months?
        # Yes (1) → Q2 onwards; No (2) → Q5B; DK/R → skip section
        - id: q_alco_q1
          kind: Question
          title: "During the past 12 months, has ... had a drink of beer, wine, liquor or any other alcoholic beverage?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # ALCO-Q2 / ALC4_2: Drinking frequency in past 12 months
        # Precondition: drank in past 12 months (Q1 = 1)
        - id: q_alco_q2
          kind: Question
          title: "During the past 12 months, how often did ... drink alcoholic beverages? (Do not read list. Mark one only.)"
          precondition:
            - predicate: q_alco_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "4 to 6 times a week"
              3: "2 to 3 times a week"
              4: "Once a week"
              5: "2 to 3 times a month"
              6: "Once a month"
              7: "Less than once a month"

        # ALCO-Q3 / ALC4_3: Times had 5+ drinks on one occasion
        # Precondition: drank in past 12 months (Q1 = 1)
        - id: q_alco_q3
          kind: Question
          title: "How many times in the past 12 months has ... had 5 or more drinks on one occasion?"
          precondition:
            - predicate: q_alco_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 365
            right: "times"

        # ALCO-Q4 / ALC4_4: Highest number of drinks on one occasion
        # Non-proxy only (proxy → skip to Q5); proxy not modelled, included unconditionally
        # Precondition: drank in past 12 months (Q1 = 1)
        - id: q_alco_q4
          kind: Question
          title: "In the past 12 months, what is the highest number of drinks ... had on one occasion?"
          precondition:
            - predicate: q_alco_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 100
            right: "drinks"

        # ALCO-Q5 / ALC4_5: Drank in past week?
        # Precondition: drank in past 12 months (Q1 = 1)
        # Yes (1) → Q5A; No (2) or DK/R → done (Physical Activities)
        - id: q_alco_q5
          kind: Question
          title: "Thinking back over the past week, that is, from last Monday to yesterday, did ... have a drink of beer, wine, liquor or any other alcoholic beverage?"
          precondition:
            - predicate: q_alco_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # ALCO-Q5A / ALC4_5A1-ALC4_5A7: Drinks per day of week
        # Precondition: drank in past week (Q5 = 1)
        # One Editbox sub-item per day (Monday through Sunday)
        - id: qg_alco_q5a
          kind: QuestionGroup
          title: "Starting with yesterday, how many drinks did ... have on:"
          precondition:
            - predicate: q_alco_q5.outcome == 1
          questions:
            - "Monday"
            - "Tuesday"
            - "Wednesday"
            - "Thursday"
            - "Friday"
            - "Saturday"
            - "Sunday"
          input:
            control: Editbox
            min: 0
            max: 50
            right: "drinks"

        # ALCO-Q5B / ALC4_5B: Ever had a drink at all?
        # Precondition: did NOT drink in past 12 months (Q1 = 2)
        # Yes (1) → Q6; No (2) or DK/R → done
        - id: q_alco_q5b
          kind: Question
          title: "Did ... ever have a drink?"
          precondition:
            - predicate: q_alco_q1.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # ALCO-Q6 / ALC4_6: Ever regularly drink more than 12 drinks/week?
        # Precondition: ever had a drink (Q5B = 1)
        # Yes (1) → Q7; No (2) or DK/R → done
        - id: q_alco_q6
          kind: Question
          title: "Did ... ever regularly drink more than 12 drinks a week?"
          precondition:
            - predicate: q_alco_q1.outcome == 2
            - predicate: q_alco_q5b.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know / Refused"

        # ALCO-Q7 / ALC4_7A-ALC4_7M: Why reduced or quit drinking
        # Precondition: ever regularly drank heavily (Q6 = 1)
        # Checkbox with power-of-2 keys (mark all that apply)
        - id: q_alco_q7
          kind: Question
          title: "Why did ... reduce or quit drinking altogether? (Do not read list. Mark all that apply.)"
          precondition:
            - predicate: q_alco_q1.outcome == 2
            - predicate: q_alco_q5b.outcome == 1
            - predicate: q_alco_q6.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Dieting"
              2: "Athletic training"
              4: "Pregnancy"
              8: "Getting older"
              16: "Drinking too much / drinking problem"
              32: "Affected work / studies / employment"
              64: "Interfered with family / home life"
              128: "Affected physical health"
              256: "Affected friendships / social relationships"
              512: "Affected financial position"
              1024: "Affected outlook on life / happiness"
              2048: "Influence of family / friends"
              4096: "Other (specify)"

    # =====================================================================
    # SECTION 09: Physical Activities Injuries
    # =====================================================================
    # =========================================================================
    # BLOCK 1: PHYSICAL ACTIVITIES (PHYS — 10 items)
    # =========================================================================
    # PHYS-INTa  → intro comment (always)
    # PHYS-Q1    → Checkbox of leisure activities (always)
    # PHYS-Q2    → Times participated (if any activity selected, i.e. Q1 > 0)
    # PHYS-Q3    → Duration per occasion (same precondition as Q2)
    # NOTE: In the original CATI, PHYS-Q2 and PHYS-Q3 repeat for EACH selected
    #       activity (a dynamic roster loop). QML does not support dynamic roster
    #       loops, so a single representative Q2/Q3 pair is modelled here.
    # PHYS-INTb  → transition comment (always)
    # PHYS-Q4a   → Walking hours (always)
    # PHYS-Q4b   → Bicycling hours (always)
    # PHYS-C1    → Filter: if PHYS-Q4b != 1 (not None) → ask PHYS-Q5
    # PHYS-Q5    → Helmet use (precondition: Q4b != 1)
    # PHYS-Q6    → Daily activity level (always)
    # =========================================================================
    - id: b_physical_activities
      title: "Physical Activities"
      items:
        # PHYS-INTa: Interviewer introduction
        - id: q_phys_inta
          kind: Comment
          title: "Now I'd like to ask you about some of your physical activities. To begin with, I'll be dealing with physical activities not related to work, that is, leisure time activities."

        # PHYS-Q1: Activities checklist (leisure time, past 3 months)
        # Original variables: PAC4_1A–PAC4_1X, PAC4_1V
        # Bit assignments (powers of 2) for each activity:
        #   1=Walking for exercise, 2=Gardening/yard work, 4=Swimming,
        #   8=Bicycling, 16=Popular or social dance, 32=Home exercises,
        #   64=Ice hockey, 128=Skating, 256=Downhill skiing, 512=Jogging/running,
        #   1024=Golfing, 2048=Exercise class/aerobics, 4096=Cross-country skiing,
        #   8192=Bowling, 16384=Baseball/softball, 32768=Tennis,
        #   65536=Weight-training, 131072=Fishing, 262144=Volleyball,
        #   524288=Yoga/tai-chi, 1048576=Other (specify),
        #   2097152=None
        # NOTE: "None" (PAC4_1V) routes to PHYS-INTb in the original;
        #       modelled here by skipping Q2/Q3 when outcome == 2097152 or outcome == 0.
        - id: q_phys_q1
          kind: Question
          title: "Have you done any of the following in the past 3 months?"
          input:
            control: Checkbox
            labels:
              1: "Walking for exercise"
              2: "Gardening/yard work"
              4: "Swimming"
              8: "Bicycling"
              16: "Popular or social dance"
              32: "Home exercises"
              64: "Ice hockey"
              128: "Skating"
              256: "Downhill skiing"
              512: "Jogging/running"
              1024: "Golfing"
              2048: "Exercise class/aerobics"
              4096: "Cross-country skiing"
              8192: "Bowling"
              16384: "Baseball/softball"
              32768: "Tennis"
              65536: "Weight-training"
              131072: "Fishing"
              262144: "Volleyball"
              524288: "Yoga/tai-chi"
              1048576: "Other (specify)"
              2097152: "None"

        # PHYS-Q2: Times participated (representative question for first selected activity)
        # In the original CATI this repeats for each activity selected in Q1.
        # Original variable: PAC4_2n
        - id: q_phys_q2
          kind: Question
          title: "In the past 3 months, how many times did you participate in this activity? (NOTE: In the original questionnaire this question repeats for each activity selected above.)"
          precondition:
            - predicate: q_phys_q1.outcome > 0 and q_phys_q1.outcome != 2097152
          input:
            control: Editbox
            min: 0
            max: 999

        # PHYS-Q3: Duration per occasion (representative question for first selected activity)
        # In the original CATI this repeats for each activity selected in Q1.
        # Original variable: PAC4_3n
        - id: q_phys_q3
          kind: Question
          title: "About how much time did you usually spend on each occasion? (NOTE: In the original questionnaire this question repeats for each activity selected above.)"
          precondition:
            - predicate: q_phys_q1.outcome > 0 and q_phys_q1.outcome != 2097152
          input:
            control: Radio
            labels:
              1: "1 to 15 minutes"
              2: "16 to 30 minutes"
              3: "31 to 60 minutes"
              4: "More than one hour"

        # PHYS-INTb: Transition to non-leisure physical activity
        - id: q_phys_intb
          kind: Comment
          title: "Next, some questions about the amount of time you spent in the past 3 months on physical activity at work or while doing daily chores around the house, but not leisure time activity."

        # PHYS-Q4a: Walking hours (work/school/errands)
        # Original variable: PAC4_4A
        - id: q_phys_q4a
          kind: Question
          title: "In a typical week in the past 3 months, how many hours did you usually spend walking to work or to school or while doing errands?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "Less than 1 hour"
              3: "From 1 to 5 hours"
              4: "From 6 to 10 hours"
              5: "From 11 to 20 hours"
              6: "More than 20 hours"

        # PHYS-Q4b: Bicycling hours (work/school/errands)
        # Original variable: PAC4_4B
        - id: q_phys_q4b
          kind: Question
          title: "In a typical week, how much time did you usually spend bicycling to work or to school or while doing errands?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "Less than 1 hour"
              3: "From 1 to 5 hours"
              4: "From 6 to 10 hours"
              5: "From 11 to 20 hours"
              6: "More than 20 hours"

        # PHYS-C1 routing: ask PHYS-Q5 if bicycling reported (Q4b != None, i.e. != 1).
        # The original also triggers if Bicycling was selected in Q1 (bit 8).
        # Simplified: use Q4b != 1 as the primary trigger (Q1 bicycling bit check
        # would require bitwise AND which is not supported in QML preconditions).

        # PHYS-Q5: Helmet use while bicycling
        # Original variable: PAC4_5
        - id: q_phys_q5
          kind: Question
          title: "When riding a bicycle how often did you wear a helmet?"
          precondition:
            - predicate: q_phys_q4b.outcome != 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Most of the time"
              3: "Rarely"
              4: "Never"

        # PHYS-Q6: Usual daily activity level
        # Original variable: PAC4_6
        - id: q_phys_q6
          kind: Question
          title: "Thinking back over the past 3 months, which of the following best describes your usual daily activities or work habits?"
          input:
            control: Radio
            labels:
              1: "Usually sit during day and do not walk about very much"
              2: "Stand or walk about quite a lot but do not carry or lift things often"
              3: "Usually lift or carry light loads or climb stairs/hills often"
              4: "Do heavy work or carry very heavy loads"

    # =========================================================================
    # BLOCK 2: INJURIES (INJ — 9 items)
    # =========================================================================
    # INJ-INT  → intro comment (always)
    # INJ-Q1   → Had injuries? Switch. No/DK/R → skip to Stress section
    # INJ-Q2   → How many times injured (precondition: Q1=Yes)
    # INJ-Q3   → Type of injury (precondition: Q1=Yes)
    # INJ-Q4   → Body part injured (precondition: Q1=Yes)
    # INJ-Q5   → Where it happened (precondition: Q1=Yes)
    # INJ-Q6   → What happened/cause (precondition: Q1=Yes)
    # INJ-Q7   → Work-related (precondition: Q1=Yes)
    # INJ-Q8   → Precautions taken (precondition: Q1=Yes)
    # =========================================================================
    - id: b_injuries
      title: "Injuries"
      items:
        # INJ-INT: Interviewer introduction
        - id: q_inj_int
          kind: Comment
          title: "Now some questions about any injuries, which occurred in the past 12 months, that were serious enough to limit your normal activities. For example, a broken bone, a bad cut or burn, a sore back or sprained ankle, or a poisoning."

        # INJ-Q1: Any serious injuries in past 12 months?
        # Original variable: IJC4_1; No/DK/R → GO TO Stress section
        - id: q_inj_q1
          kind: Question
          title: "In the past 12 months, did you have any injuries that were serious enough to limit your normal activities?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # INJ-Q2: Number of times injured
        # Original variable: IJC4_2
        - id: q_inj_q2
          kind: Question
          title: "How many times were you injured?"
          precondition:
            - predicate: q_inj_q1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        # INJ-Q3: Type of most serious injury
        # Original variable: IJC4_3
        - id: q_inj_q3
          kind: Question
          title: "Thinking about the most serious injury, what type of injury did you have?"
          precondition:
            - predicate: q_inj_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Multiple injuries"
              2: "Broken or fractured bones"
              3: "Burn or scald"
              4: "Dislocation"
              5: "Sprain or strain"
              6: "Cut or scrape"
              7: "Bruise or abrasion"
              8: "Concussion"
              9: "Poisoning by substance or liquid"
              10: "Internal injury"
              11: "Other (specify)"

        # INJ-Q4: Body part injured
        # Original variable: IJC4_4
        - id: q_inj_q4
          kind: Question
          title: "What part of your body was injured?"
          precondition:
            - predicate: q_inj_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Multiple sites"
              2: "Eyes"
              3: "Head (excluding eyes)"
              4: "Neck"
              5: "Shoulder"
              6: "Arms or hands"
              7: "Hip"
              8: "Legs or feet"
              9: "Back or spine"
              10: "Trunk (excluding back or spine)"

        # INJ-Q5: Where did the injury happen?
        # Original variable: IJC4_5
        - id: q_inj_q5
          kind: Question
          title: "Where did the injury happen?"
          precondition:
            - predicate: q_inj_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Home and surrounding area"
              2: "Farm"
              3: "Place for recreation or sport"
              4: "Street or highway"
              5: "Building used by general public"
              6: "Residential institution"
              7: "Mine"
              8: "Industrial place or premise"
              9: "Other (specify)"

        # INJ-Q6: What happened / cause of injury
        # Original variable: IJC4_6
        - id: q_inj_q6
          kind: Question
          title: "What happened? For example, was the injury the result of a fall, motor vehicle accident, a physical assault, etc.?"
          precondition:
            - predicate: q_inj_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Motor vehicle accident"
              2: "Accidental fall"
              3: "Fire/flames/resulting fumes"
              4: "Accidentally struck by object/person"
              5: "Physical assault"
              6: "Suicide attempt"
              7: "Accidental injury caused by explosion"
              8: "Accidental injury caused by natural/environmental factors"
              9: "Accidental drowning or submersion"
              10: "Accidental suffocation"
              11: "Hot or corrosive liquids/foods/substances"
              12: "Accident caused by machinery"
              13: "Accident caused by cutting/piercing instruments"
              14: "Accidental poisoning"
              15: "Other (specify)"

        # INJ-Q7: Work-related injury?
        # Original variable: IJC4_7
        - id: q_inj_q7
          kind: Question
          title: "Was this a work-related injury?"
          precondition:
            - predicate: q_inj_q1.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # INJ-Q8: Precautions taken to prevent recurrence
        # Original variables: IJC4_8A–IJC4_8H (8 options)
        # Bit assignments (powers of 2):
        #   1=Gave up the activity (IJC4_8A)
        #   2=Being more careful (IJC4_8B)
        #   4=Took safety training (IJC4_8C)
        #   8=Increased supervision of child (IJC4_8H)
        #   16=Using protective gear/safety equipment (IJC4_8D)
        #   32=Changing physical situation (IJC4_8E)
        #   64=Other (specify) (IJC4_8F)
        #   128=No precautions (IJC4_8G)
        - id: q_inj_q8
          kind: Question
          title: "What precautions are you taking to prevent this kind of injury from happening again?"
          precondition:
            - predicate: q_inj_q1.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Gave up the activity"
              2: "Being more careful"
              4: "Took safety training"
              8: "Increased supervision of child"
              16: "Using protective gear/safety equipment"
              32: "Changing physical situation"
              64: "Other (specify)"
              128: "No precautions"

    # =====================================================================
    # SECTION 10: Stress
    # =====================================================================
    # =========================================================================
    # BLOCK 1: ONGOING PROBLEMS (CSTRESS)
    # =========================================================================
    # Age >= 18 and non-proxy only.
    #
    # CSTRESS-Q1: R --> skip entire Ongoing Problems section
    # CSTRESS-MARITAL check:
    #   married/common-law/living-with-partner (1/2/3) --> Q5-Q7
    #   otherwise --> Q8 (single/widowed/separated/divorced/unknown)
    # CSTRESS-Q7 --> GO TO Q9 (skip Q8)
    # CSTRESS-Q9: children? No/DK/R --> GO TO Q12
    # Q10-Q11: precondition has_children == 1
    # Q12-Q18: always shown (within age >= 18 gate)
    # =========================================================================
    - id: b_ongoing_problems
      title: "Ongoing Problems"
      precondition:
        - predicate: age >= 18
      items:
        # STRESS-INT: section introduction (no response)
        - id: q_stress_intro
          kind: Comment
          title: "The next portion of the questionnaire deals with different kinds of stress. Although the questions may seem repetitive, they are related to various aspects of a person's physical, emotional and mental health."

        # CSTRESS-INT: instruction text (no response)
        - id: q_cstress_intro
          kind: Comment
          title: "I'll start by describing situations that sometimes come up in people's lives. I'd like you to tell me if these things are true for you at this time by answering 'true' if it applies to you now or 'false' if it does not."

        # CSTRESS-Q1 / ST_4_C1: "You are trying to take on too many things at once."
        # R --> GO TO next section (Recent Life Events); modeled as Switch True/False.
        # No codeBlock needed — subsequent items gate on q_cstress_q1.outcome != 9
        # (R is not expressible as a value in Switch; the R-skip is a CATI
        # interviewer-level abort. In self-administered QML we treat all
        # Q1-Q18 as always shown when age >= 18, which is the intent.)
        - id: q_cstress_q1
          kind: Question
          title: "You are trying to take on too many things at once."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q2 / ST_4_C2
        - id: q_cstress_q2
          kind: Question
          title: "There is too much pressure on you to be like other people."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q3 / ST_4_C3
        - id: q_cstress_q3
          kind: Question
          title: "Too much is expected of you by others."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q4 / ST_4_C4
        - id: q_cstress_q4
          kind: Question
          title: "You don't have enough money to buy the things you need."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-MARITAL check:
        # married/common-law/living-with-partner → Q5, Q6, Q7 (then GO TO Q9)
        # single/widowed/separated/divorced/unknown → Q8 (then continue to Q9)

        # CSTRESS-Q5 / ST_4_C5 — only if married/common-law/partner
        - id: q_cstress_q5
          kind: Question
          title: "Your partner doesn't understand you."
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q6 / ST_4_C6
        - id: q_cstress_q6
          kind: Question
          title: "Your partner doesn't show enough affection."
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q7 / ST_4_C7 — after this, GO TO Q9 (skip Q8)
        # Q8 has precondition marital_status not in [1,2,3], so it is
        # naturally skipped when Q7 is shown.
        - id: q_cstress_q7
          kind: Question
          title: "Your partner is not committed enough to your relationship."
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q8 / ST_4_C8 — only if NOT married/common-law/partner
        - id: q_cstress_q8
          kind: Question
          title: "You find it is very difficult to find someone compatible with you."
          precondition:
            - predicate: marital_status not in [1, 2, 3]
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q9 / ST_4_C9: "Do you have any children?"
        # No/DK/R --> GO TO Q12 (skip Q10, Q11)
        # codeBlock sets has_children for downstream use (RECENT-Q10).
        - id: q_cstress_q9
          kind: Question
          title: "Do you have any children?"
          codeBlock: |
            has_children = 1 if q_cstress_q9.outcome == 1 else 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CSTRESS-Q10 / ST_4_C10 — only if has children
        - id: q_cstress_q10
          kind: Question
          title: "One of your children seems very unhappy."
          precondition:
            - predicate: q_cstress_q9.outcome == 1
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q11 / ST_4_C11
        - id: q_cstress_q11
          kind: Question
          title: "A child's behaviour is a source of serious concern to you."
          precondition:
            - predicate: q_cstress_q9.outcome == 1
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q12 / ST_4_C12 — always asked (within age >= 18 gate)
        - id: q_cstress_q12
          kind: Question
          title: "Your work around the home is not appreciated."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q13 / ST_4_C13
        - id: q_cstress_q13
          kind: Question
          title: "Your friends are a bad influence."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q14 / ST_4_C14
        - id: q_cstress_q14
          kind: Question
          title: "You would like to move but you cannot."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q15 / ST_4_C15
        - id: q_cstress_q15
          kind: Question
          title: "Your neighbourhood or community is too noisy or too polluted."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q16 / ST_4_C16
        - id: q_cstress_q16
          kind: Question
          title: "You have a parent, a child or partner who is in very bad health and may die."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q17 / ST_4_C17
        - id: q_cstress_q17
          kind: Question
          title: "Someone in your family has an alcohol or drug problem."
          input:
            control: Switch
            off: "False"
            on: "True"

        # CSTRESS-Q18 / ST_4_C18
        - id: q_cstress_q18
          kind: Question
          title: "People are too critical of you or what you do."
          input:
            control: Switch
            off: "False"
            on: "True"

    # =========================================================================
    # BLOCK 2: RECENT LIFE EVENTS (RECENT)
    # =========================================================================
    # Age >= 18 and non-proxy only.
    #
    # RECENT-Q1: R --> skip entire section (CATI abort; modeled as always shown)
    # RECENT-Q2 through Q5: always asked (within gate)
    # RECENT-Q6, Q7: always asked
    # RECENT-MARITAL check: married/common-law/partner --> ask Q8
    # RECENT-Q9: always asked
    # RECENT-CHILDREN check: has_children == 1 --> ask Q10
    # =========================================================================
    - id: b_recent_life_events
      title: "Recent Life Events"
      precondition:
        - predicate: age >= 18
      items:
        # RECENT-INTa: introduction (no response)
        - id: q_recent_inta
          kind: Comment
          title: "Now I'd like to ask you about some things that may have happened in the past 12 months. First, I'd like to ask about yourself or anyone close to you (spouse/partner, children, relatives or close friends)."

        # RECENT-Q1 / ST_4_R1: "In the past 12 months, was any one of you beaten up or physically attacked?"
        # R --> GO TO next section (Childhood Stressors); CATI abort; modeled without skip.
        - id: q_recent_q1
          kind: Question
          title: "In the past 12 months, was any one of you beaten up or physically attacked?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-INTb: instruction (no response)
        - id: q_recent_intb
          kind: Comment
          title: "Now I'd like you to think just about your family (yourself and your spouse/partner or children, if any)."

        # RECENT-Q2 / ST_4_R2
        - id: q_recent_q2
          kind: Question
          title: "In the past 12 months, did you or someone in your family have an unwanted pregnancy?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q3 / ST_4_R3
        - id: q_recent_q3
          kind: Question
          title: "In the past 12 months, did you or someone in your family have an abortion or miscarriage?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q4 / ST_4_R4
        - id: q_recent_q4
          kind: Question
          title: "In the past 12 months, did you or someone in your family have a major financial crisis?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q5 / ST_4_R5
        - id: q_recent_q5
          kind: Question
          title: "In the past 12 months, did you or someone in your family fail school or a training program?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-INTc: instruction (no response)
        - id: q_recent_intc
          kind: Comment
          title: "Now I'd like you to think just about yourself and your spouse or partner."

        # RECENT-Q6 / ST_4_R6
        - id: q_recent_q6
          kind: Question
          title: "In the past 12 months, did you (or your partner) experience a change of job for a worse one?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q7 / ST_4_R7
        - id: q_recent_q7
          kind: Question
          title: "In the past 12 months, were you (or your partner) demoted at work or did you/either of you take a cut in pay?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-MARITAL check: married/common-law/partner --> ask Q8
        # RECENT-Q8 / ST_4_R8
        - id: q_recent_q8
          kind: Question
          title: "In the past 12 months, did you have increased arguments with your partner?"
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-Q9 / ST_4_R9 — always asked
        - id: q_recent_q9
          kind: Question
          title: "Now, just you personally, in the past 12 months, did you go on Welfare?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # RECENT-CHILDREN check: has_children == 1 --> ask Q10
        # RECENT-Q10 / ST_4_R10
        - id: q_recent_q10
          kind: Question
          title: "In the past 12 months, did you have a child move back into the house?"
          precondition:
            - predicate: has_children == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 3: CHILDHOOD AND ADULT STRESSORS (TRAUM)
    # =========================================================================
    # Age >= 18 and non-proxy only.
    #
    # TRAUM-Q1: R --> GO TO Work Stress section (CATI abort; modeled without skip)
    # TRAUM-Q2 through Q7: always asked (within gate)
    # =========================================================================
    - id: b_childhood_stressors
      title: "Childhood and Adult Stressors"
      precondition:
        - predicate: age >= 18
      items:
        # TRAUM-INTa: introduction (no response)
        - id: q_traum_inta
          kind: Comment
          title: "The next few questions ask about some things that may have happened to you while you were a child or a teenager, before you moved out of the house."

        # TRAUM-Q1 / ST_4_T1: R --> GO TO Work Stress section
        - id: q_traum_q1
          kind: Question
          title: "Did you spend 2 weeks or more in the hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q2 / ST_4_T2
        - id: q_traum_q2
          kind: Question
          title: "Did your parents get a divorce?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q3 / ST_4_T3
        - id: q_traum_q3
          kind: Question
          title: "Did your father or mother not have a job for a long time when they wanted to be working?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q4 / ST_4_T4
        - id: q_traum_q4
          kind: Question
          title: "Did something happen that scared you so much you thought about it for years after?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q5 / ST_4_T5
        - id: q_traum_q5
          kind: Question
          title: "Were you sent away from home because you did something wrong?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q6 / ST_4_T6
        - id: q_traum_q6
          kind: Question
          title: "Did either of your parents drink or use drugs so often that it caused problems for the family?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TRAUM-Q7 / ST_4_T7
        - id: q_traum_q7
          kind: Question
          title: "Were you ever physically abused by someone close to you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 4: WORK STRESS (WSTRESS)
    # =========================================================================
    # Age >= 15 and currently employed (lfs_work == 1), non-proxy only.
    # If more than one job, ask for the main job.
    #
    # WSTRESS-Q1: 12-item Likert scale (a through l).
    #   R on first item (index 0) --> GO TO next section (CATI abort;
    #   modeled as always shown within gate).
    # WSTRESS-Q2: Job satisfaction. Always asked (within gate).
    # =========================================================================
    - id: b_work_stress
      title: "Work Stress"
      precondition:
        - predicate: age >= 15 and lfs_work == 1
      items:
        # WSTRESS-Q1 / ST_4_W1A–ST_4_W1L: 12-item job stress Likert scale.
        # Sub-question index mapping:
        #   [0]  W1A: Your job requires that you learn new things
        #   [1]  W1B: Your job requires a high level of skill
        #   [2]  W1C: Your job allows you freedom to decide how you do your job
        #   [3]  W1D: Your job requires that you do things over and over
        #   [4]  W1E: Your job is very hectic
        #   [5]  W1F: You are free from conflicting demands that others make
        #   [6]  W1G: Your job security is good
        #   [7]  W1H: Your job requires a lot of physical effort
        #   [8]  W1I: You have a lot to say about what happens in your job
        #   [9]  W1J: You are exposed to hostility or conflict from the people you work with
        #   [10] W1K: Your supervisor is helpful in getting the job done
        #   [11] W1L: The people you work with are helpful in getting the job done
        - id: qg_wstress_q1
          kind: QuestionGroup
          title: "Now I'm going to read you a series of statements that might describe your job situation. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE, or STRONGLY DISAGREE with each of the following:"
          questions:
            - "(a) Your job requires that you learn new things."
            - "(b) Your job requires a high level of skill."
            - "(c) Your job allows you freedom to decide how you do your job."
            - "(d) Your job requires that you do things over and over."
            - "(e) Your job is very hectic."
            - "(f) You are free from conflicting demands that others make."
            - "(g) Your job security is good."
            - "(h) Your job requires a lot of physical effort."
            - "(i) You have a lot to say about what happens in your job."
            - "(j) You are exposed to hostility or conflict from the people you work with."
            - "(k) Your supervisor is helpful in getting the job done."
            - "(l) The people you work with are helpful in getting the job done."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Strongly disagree"

        # WSTRESS-Q2 / ST_4_W2: Job satisfaction
        - id: q_wstress_q2
          kind: Question
          title: "How satisfied are you with your job?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Not too satisfied"
              4: "Not at all satisfied"

    # =====================================================================
    # SECTION 11: Self Esteem Coherence
    # =====================================================================
    # =========================================================================
    # BLOCK 1: SELF-ESTEEM (ESTEEM-Q1)
    # =========================================================================
    # Age >= 12, non-proxy only.
    # ESTEEM-Q1: 6-item Rosenberg-style self-esteem battery on 5-point Likert.
    # R on first sub-item in original CATI --> skip to Sense of Coherence.
    # Modeled as QuestionGroup with Radio (forced response 1-5; refusal omitted).
    # Index mapping:
    #   [0] PY_4_E1A - You feel that you have a number of good qualities
    #   [1] PY_4_E1B - You feel that you're a person of worth at least equal to others
    #   [2] PY_4_E1C - You are able to do things as well as most other people
    #   [3] PY_4_E1D - You take a positive attitude toward yourself
    #   [4] PY_4_E1E - On the whole you are satisfied with yourself
    #   [5] PY_4_E1F - All in all, you're inclined to feel you're a failure
    # =========================================================================
    - id: b_self_esteem
      title: "Self-Esteem"
      precondition:
        - predicate: age >= 12
      items:
        # ESTEEM-Q1 / PY_4_E1A-PY_4_E1F: Self-esteem battery
        - id: qg_esteem_q1
          kind: QuestionGroup
          title: "Now, I am going to read you a series of statements that people might use to describe themselves. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE or STRONGLY DISAGREE with each of the following:"
          questions:
            - "(a) You feel that you have a number of good qualities."
            - "(b) You feel that you're a person of worth at least equal to others."
            - "(c) You are able to do things as well as most other people."
            - "(d) You take a positive attitude toward yourself."
            - "(e) On the whole you are satisfied with yourself."
            - "(f) All in all, you're inclined to feel you're a failure."
          input:
            control: Radio
            labels:
              1: "Strongly Agree"
              2: "Agree"
              3: "Neither Agree Nor Disagree"
              4: "Disagree"
              5: "Strongly Disagree"

    # =========================================================================
    # BLOCK 2: MASTERY (MAST-Q1)
    # =========================================================================
    # Age >= 12, non-proxy only.
    # MAST-Q1: 7-item Pearlin Mastery Scale on 5-point Likert.
    # R on first sub-item in original CATI --> skip to Sense of Coherence.
    # Modeled as QuestionGroup with Radio (forced response 1-5; refusal omitted).
    # Index mapping:
    #   [0] PY_4_M1A - You have little control over the things that happen to you
    #   [1] PY_4_M1B - There is really no way you can solve some of the problems you have
    #   [2] PY_4_M1C - There is little you can do to change many of the important things in your life
    #   [3] PY_4_M1D - You often feel helpless in dealing with problems of life
    #   [4] PY_4_M1E - Sometimes you feel that you are being pushed around in life
    #   [5] PY_4_M1F - What happens to you in the future mostly depends on you
    #   [6] PY_4_M1G - You can do just about anything you really set your mind to
    # =========================================================================
    - id: b_mastery
      title: "Mastery"
      precondition:
        - predicate: age >= 12
      items:
        # MAST-Q1 / PY_4_M1A-PY_4_M1G: Mastery battery
        - id: qg_mast_q1
          kind: QuestionGroup
          title: "Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE or STRONGLY DISAGREE with each of the following:"
          questions:
            - "(a) You have little control over the things that happen to you."
            - "(b) There is really no way you can solve some of the problems you have."
            - "(c) There is little you can do to change many of the important things in your life."
            - "(d) You often feel helpless in dealing with problems of life."
            - "(e) Sometimes you feel that you are being pushed around in life."
            - "(f) What happens to you in the future mostly depends on you."
            - "(g) You can do just about anything you really set your mind to."
          input:
            control: Radio
            labels:
              1: "Strongly Agree"
              2: "Agree"
              3: "Neither Agree Nor Disagree"
              4: "Disagree"
              5: "Strongly Disagree"

    # =========================================================================
    # BLOCK 3: SENSE OF COHERENCE (SCOH)
    # =========================================================================
    # Age >= 18, non-proxy only.
    # SCOH-INT: Interviewer instruction (Comment).
    # SCOH-Q1 through Q13: 13 individual questions on 7-point semantic scale.
    # DK/R on SCOH-Q1 in original CATI --> skip to Health Status section.
    # Modeled with individual Radio questions (forced response 1-7).
    # Each question has unique anchor text incorporated into the title.
    # =========================================================================
    - id: b_sense_of_coherence
      title: "Sense of Coherence"
      precondition:
        - predicate: age >= 18
      items:
        # SCOH-INT: Interviewer instruction
        - id: q_scoh_int
          kind: Comment
          title: "Next is a series of questions relating to various aspects of people's lives. For each question please answer with a number between 1 and 7."

        # SCOH-Q1 / PY_4_H1: Feeling of indifference
        # DK/R --> skip to Health Status section (modeled as forced response)
        - id: q_scoh_q1
          kind: Question
          title: "How often do you have the feeling that you don't really care about what goes on around you? (1 = Very seldom or never, 7 = Very often)"
          input:
            control: Radio
            labels:
              1: "1 - Very seldom or never"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very often"

        # SCOH-Q2 / PY_4_H2: Surprised by behaviour of known people
        - id: q_scoh_q2
          kind: Question
          title: "How often in the past were you surprised by the behaviour of people whom you thought you knew well? (1 = Never happened, 7 = Always happened)"
          input:
            control: Radio
            labels:
              1: "1 - Never happened"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Always happened"

        # SCOH-Q3 / PY_4_H3: Disappointed by people counted on
        - id: q_scoh_q3
          kind: Question
          title: "How often have people you counted on disappointed you? (1 = Never happened, 7 = Always happened)"
          input:
            control: Radio
            labels:
              1: "1 - Never happened"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Always happened"

        # SCOH-Q4 / PY_4_H4: Feeling of unfair treatment
        - id: q_scoh_q4
          kind: Question
          title: "How often do you have the feeling you're being treated unfairly? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q5 / PY_4_H5: Feeling of unfamiliar situation
        - id: q_scoh_q5
          kind: Question
          title: "How often do you have the feeling you are in an unfamiliar situation and don't know what to do? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q6 / PY_4_H6: Mixed-up feelings and ideas
        - id: q_scoh_q6
          kind: Question
          title: "How often do you have very mixed-up feelings and ideas? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q7 / PY_4_H7: Unwanted feelings inside
        - id: q_scoh_q7
          kind: Question
          title: "How often do you have feelings inside that you would rather not feel? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q8 / PY_4_H8: Feeling like a sad sack / loser
        - id: q_scoh_q8
          kind: Question
          title: "Many people -- even those with a strong character -- sometimes feel like sad sacks (losers) in certain situations. How often have you felt this way in the past? (1 = Very seldom or never, 7 = Very often)"
          input:
            control: Radio
            labels:
              1: "1 - Very seldom or never"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very often"

        # SCOH-Q9 / PY_4_H9: Little meaning in daily activities
        - id: q_scoh_q9
          kind: Question
          title: "How often do you have the feeling that there's little meaning in the things you do in your daily life? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q10 / PY_4_H10: Feelings out of control
        - id: q_scoh_q10
          kind: Question
          title: "How often do you have feelings that you're not sure you can keep under control? (1 = Very often, 7 = Very seldom or never)"
          input:
            control: Radio
            labels:
              1: "1 - Very often"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very seldom or never"

        # SCOH-Q11 / PY_4_H11: Life goals and purpose
        - id: q_scoh_q11
          kind: Question
          title: "Until now your life has had no clear goals or purpose or has it had very clear goals and purpose? (1 = No clear goals or no purpose at all, 7 = Very clear goals and purpose)"
          input:
            control: Radio
            labels:
              1: "1 - No clear goals or no purpose at all"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - Very clear goals and purpose"

        # SCOH-Q12 / PY_4_H12: Perspective on importance of events
        - id: q_scoh_q12
          kind: Question
          title: "When something happens, you generally find that you overestimate or underestimate its importance or you see things in the right proportion? (1 = Overestimate or underestimate, 7 = See things in the right proportion)"
          input:
            control: Radio
            labels:
              1: "1 - Overestimate or underestimate"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - See things in the right proportion"

        # SCOH-Q13 / PY_4_H13: Daily activities as pleasure or burden
        - id: q_scoh_q13
          kind: Question
          title: "Is doing the things you do every day a source of great pleasure and satisfaction or a source of pain and boredom? (1 = A great deal of pleasure and satisfaction, 7 = A source of pain and boredom)"
          input:
            control: Radio
            labels:
              1: "1 - A great deal of pleasure and satisfaction"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6"
              7: "7 - A source of pain and boredom"

    # =====================================================================
    # SECTION 12: Health Status
    # =====================================================================
    # =========================================================================
    # BLOCK 1: SECTION INTRODUCTION
    # =========================================================================
    # HSTAT-INT: Interviewer instruction introducing the section.
    # =========================================================================
    - id: b_intro
      title: "Section Introduction"
      items:
        # HSTAT-INT: Section introduction — no response collected
        - id: q_hstat_int
          kind: Comment
          title: "The next set of questions ask about ...(r/'s) day to day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with a person's usual abilities."

    # =========================================================================
    # BLOCK 2: VISION (HSTAT-Q1 to HSTAT-Q5)
    # =========================================================================
    # Q1: See newsprint without glasses? Yes→Q4, No→Q2
    # Q2: See newsprint with glasses? Yes→Q4, No→Q3
    # Q3: Able to see at all? Yes→continues, No→Q6 (end of vision)
    # Q4: Recognize friend across street without glasses? Yes→Q6, No→Q5
    # Q5: Recognize friend with glasses? (shown when Q4=No)
    #
    # Precondition cascade:
    #   Q2: Q1=No
    #   Q3: Q1=No AND Q2=No
    #   Q4: Q1=Yes OR Q2=Yes
    #   Q5: (Q1=Yes OR Q2=Yes) AND Q4=No
    # =========================================================================
    - id: b_vision
      title: "Vision"
      items:
        # HSTAT-Q1 / HSC4_1: See newsprint without glasses?
        # Yes(1) → skip to Q4; No(0) → continue to Q2
        - id: q_hstat_q1
          kind: Question
          title: "Are/Is ... usually able to see well enough to read ordinary newsprint without glasses or contact lenses?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q2 / HSC4_2: See newsprint with glasses?
        # Shown only when Q1=No (cannot read without glasses)
        # Yes(1) → skip to Q4; No(0) → continue to Q3
        - id: q_hstat_q2
          kind: Question
          title: "Are/Is you/he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?"
          precondition:
            - predicate: q_hstat_q1.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q3 / HSC4_3: Able to see at all?
        # Shown only when Q1=No AND Q2=No (cannot read even with glasses)
        # Yes(1) → continue to Q4; No(0) → skip to Q6 (end of vision block)
        - id: q_hstat_q3
          kind: Question
          title: "Are/Is you/he/she able to see at all?"
          precondition:
            - predicate: q_hstat_q1.outcome == 0 and q_hstat_q2.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q4 / HSC4_4: Recognize friend across street without glasses?
        # Shown when Q1=Yes OR Q2=Yes (able to read newsprint at some level)
        # Yes(1) → skip to Q6; No(0) → continue to Q5
        - id: q_hstat_q4
          kind: Question
          title: "Are/Is you/he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: q_hstat_q1.outcome == 1 or q_hstat_q2.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q5 / HSC4_5: Recognize friend with glasses?
        # Shown when Q4 was asked (Q1=Yes or Q2=Yes) AND Q4=No
        - id: q_hstat_q5
          kind: Question
          title: "Are/Is you/he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: (q_hstat_q1.outcome == 1 or q_hstat_q2.outcome == 1) and q_hstat_q4.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 3: HEARING (HSTAT-Q6 to HSTAT-Q9)
    # =========================================================================
    # Q6: Hear group conversation without hearing aid? Yes→Q10, No→Q7
    # Q7: Hear group conversation with hearing aid? Yes→Q8, No→Q7a
    # Q7a: Able to hear at all? Yes→continues, No→Q10 (end of hearing)
    # Q8: Hear one person in quiet room without aid? Yes→Q10, No→Q9
    # Q9: Hear one person in quiet room with aid? (shown when Q8=No)
    #
    # Precondition cascade:
    #   Q7: Q6=No
    #   Q7a: Q6=No AND Q7=No
    #   Q8: Q6=No AND Q7=Yes
    #   Q9: Q6=No AND Q7=Yes AND Q8=No
    # =========================================================================
    - id: b_hearing
      title: "Hearing"
      items:
        # HSTAT-Q6 / HSC4_6: Hear group conversation without hearing aid?
        # Yes(1) → skip to Q10 (Speech block); No(0) → continue to Q7
        - id: q_hstat_q6
          kind: Question
          title: "Are/Is ... usually able to hear what is said in a group conversation with at least three other people without a hearing aid?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q7 / HSC4_7: Hear group conversation with hearing aid?
        # Shown when Q6=No (cannot hear group without aid)
        # Yes(1) → skip to Q8 (one-on-one check); No(0) → Q7a (can hear at all?)
        - id: q_hstat_q7
          kind: Question
          title: "Are/Is you/he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?"
          precondition:
            - predicate: q_hstat_q6.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q7a / HSC4_7A: Able to hear at all?
        # Shown when Q6=No AND Q7=No (cannot hear group even with aid)
        # Yes(1) → continues to Q8; No(0) → skip to Q10 (Speech block)
        - id: q_hstat_q7a
          kind: Question
          title: "Are/Is you/he/she able to hear at all?"
          precondition:
            - predicate: q_hstat_q6.outcome == 0 and q_hstat_q7.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q8 / HSC4_8: Hear one person in quiet room without hearing aid?
        # Shown when Q6=No AND Q7=Yes (can hear group with aid but Q8 checks
        # finer-grained one-on-one hearing without aid)
        # Yes(1) → skip to Q10; No(0) → continue to Q9
        - id: q_hstat_q8
          kind: Question
          title: "Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: q_hstat_q6.outcome == 0 and q_hstat_q7.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q9 / HSC4_9: Hear one person in quiet room with hearing aid?
        # Shown when Q8 was asked (Q6=No, Q7=Yes) AND Q8=No
        - id: q_hstat_q9
          kind: Question
          title: "Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?"
          precondition:
            - predicate: q_hstat_q6.outcome == 0 and q_hstat_q7.outcome == 1 and q_hstat_q8.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 4: SPEECH (HSTAT-Q10 to HSTAT-Q13)
    # =========================================================================
    # Q10: Completely understood by strangers? Yes→Q14, No→Q11
    # Q11: Partially understood by strangers? Yes or No → Q12
    # Q12: Completely understood by people who know you? Yes→Q14, No→Q13
    # Q13: Partially understood by people who know you? Yes or No → Q14
    #
    # Precondition cascade:
    #   Q11: Q10=No
    #   Q12: Q10=No (asked after Q11 regardless of Q11 outcome)
    #   Q13: Q10=No AND Q12=No
    # =========================================================================
    - id: b_speech
      title: "Speech"
      items:
        # HSTAT-Q10 / HSC4_10: Completely understood by strangers?
        # Yes(1) → skip to Q14 (Getting Around); No(0) → continue to Q11
        - id: q_hstat_q10
          kind: Question
          title: "Are/Is ... usually able to be understood completely when speaking with strangers in your own language?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q11 / HSC4_11: Partially understood by strangers?
        # Shown when Q10=No (cannot be completely understood by strangers)
        - id: q_hstat_q11
          kind: Question
          title: "Are/Is you/he/she able to be understood partially when speaking with strangers?"
          precondition:
            - predicate: q_hstat_q10.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q12 / HSC4_12: Completely understood by those who know you?
        # Shown when Q10=No (continues speech capability assessment)
        # Yes(1) → skip to Q14; No(0) → continue to Q13
        - id: q_hstat_q12
          kind: Question
          title: "Are/Is you/he/she able to be understood completely when speaking with those who know you/him/her well?"
          precondition:
            - predicate: q_hstat_q10.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q13 / HSC4_13: Partially understood by those who know you?
        # Shown when Q10=No AND Q12=No (cannot be completely understood even
        # by people who know respondent well)
        - id: q_hstat_q13
          kind: Question
          title: "Are/Is you/he/she able to be understood partially when speaking with those who know you/him/her well?"
          precondition:
            - predicate: q_hstat_q10.outcome == 0 and q_hstat_q12.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 5: GETTING AROUND (HSTAT-Q14 to HSTAT-Q20)
    # =========================================================================
    # Q14: Walk around neighbourhood without difficulty or mechanical support?
    #      Yes→Q21 (Hands block), No→Q15
    # Q15: Able to walk at all? Yes→Q16, No→Q18
    # Q16: Require mechanical support (braces, cane, crutches) to walk?
    #      (shown when Q15=Yes)
    # Q17: Require help from another person to walk? (shown when Q15=Yes)
    # Q18: Require wheelchair? Yes→Q19, No→Q21
    # Q19: How often use wheelchair? (shown when Q18=Yes)
    # Q20: Need help of another person in wheelchair? (shown when Q18=Yes)
    #
    # Precondition cascade:
    #   Q15: Q14=No
    #   Q16: Q14=No AND Q15=Yes
    #   Q17: Q14=No AND Q15=Yes
    #   Q18: Q14=No AND Q15=No
    #   Q19: Q14=No AND Q15=No AND Q18=Yes
    #   Q20: Q14=No AND Q15=No AND Q18=Yes
    # =========================================================================
    - id: b_getting_around
      title: "Getting Around"
      items:
        # HSTAT-Q14 / HSC4_14: Walk around neighbourhood without difficulty?
        # Yes(1) → skip to Q21 (Hands block); No(0) → continue to Q15
        - id: q_hstat_q14
          kind: Question
          title: "Are/Is ... usually able to walk around the neighbourhood without difficulty and without mechanical support?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q15 / HSC4_15: Able to walk at all?
        # Shown when Q14=No (some difficulty walking)
        # Yes(1) → continue to Q16 (needs mechanical support check)
        # No(0) → skip to Q18 (wheelchair check)
        - id: q_hstat_q15
          kind: Question
          title: "Are/Is you/he/she able to walk at all?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q16 / HSC4_16: Require mechanical support to walk?
        # Shown when Q14=No AND Q15=Yes (can walk but with some difficulty)
        - id: q_hstat_q16
          kind: Question
          title: "Do/Does you/he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q17 / HSC4_17: Require help of another person to walk?
        # Shown when Q14=No AND Q15=Yes (can walk but with some difficulty)
        - id: q_hstat_q17
          kind: Question
          title: "Do/Does you/he/she require the help of another person to be able to walk?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q18 / HSC4_18: Require a wheelchair to get around?
        # Shown when Q14=No AND Q15=No (cannot walk at all)
        # Yes(1) → continue to Q19; No(0) → skip to Q21 (Hands block)
        - id: q_hstat_q18
          kind: Question
          title: "Do/Does you/he/she require a wheelchair to get around?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q19 / HSC4_19: How often use wheelchair?
        # Shown when Q14=No AND Q15=No AND Q18=Yes
        - id: q_hstat_q19
          kind: Question
          title: "How often do/does you/he/she use a wheelchair?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 0 and q_hstat_q18.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Never"

        # HSTAT-Q20 / HSC4_20: Need help of another person in wheelchair?
        # Shown when Q14=No AND Q15=No AND Q18=Yes
        - id: q_hstat_q20
          kind: Question
          title: "Do/Does you/he/she need the help of another person to get around in the wheelchair?"
          precondition:
            - predicate: q_hstat_q14.outcome == 0 and q_hstat_q15.outcome == 0 and q_hstat_q18.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 6: HANDS AND FINGERS (HSTAT-Q21 to HSTAT-Q24)
    # =========================================================================
    # Q21: Usually able to grasp/handle small objects? Yes→Q25, No→Q22
    # Q22: Require help of another person due to hand/finger limitations?
    #      Yes→Q23, No→Q24
    # Q23: Help with which tasks? (shown when Q22=Yes)
    # Q24: Require special equipment due to hand/finger limitations?
    #      (shown when Q21=No, after Q23 if applicable)
    #
    # Precondition cascade:
    #   Q22: Q21=No
    #   Q23: Q21=No AND Q22=Yes
    #   Q24: Q21=No (shown regardless of Q22 outcome, after Q23 if applicable)
    # =========================================================================
    - id: b_hands_fingers
      title: "Hands and Fingers"
      items:
        # HSTAT-Q21 / HSC4_21: Usually able to grasp and handle small objects?
        # Yes(1) → skip to Q25 (Feelings block); No(0) → continue to Q22
        - id: q_hstat_q21
          kind: Question
          title: "Are/Is ... usually able to grasp and handle small objects such as a pencil and scissors?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q22 / HSC4_22: Require help of another person due to hand/finger limitations?
        # Shown when Q21=No
        # Yes(1) → continue to Q23; No(0) → skip to Q24
        - id: q_hstat_q22
          kind: Question
          title: "Do/Does you/he/she require the help of another person because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_hstat_q21.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q23 / HSC4_23: Help with which tasks?
        # Shown when Q21=No AND Q22=Yes
        - id: q_hstat_q23
          kind: Question
          title: "Do/Does you/he/she require the help of another person with:"
          precondition:
            - predicate: q_hstat_q21.outcome == 0 and q_hstat_q22.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some tasks"
              2: "Most tasks"
              3: "Almost all tasks"
              4: "All tasks"

        # HSTAT-Q24 / HSC4_24: Require special equipment due to hand/finger limitations?
        # Shown when Q21=No (regardless of Q22 outcome)
        - id: q_hstat_q24
          kind: Question
          title: "Do/Does you/he/she require special equipment because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_hstat_q21.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 7: FEELINGS (HSTAT-Q25)
    # =========================================================================
    # Q25: Single question — always asked; no branching.
    # =========================================================================
    - id: b_feelings
      title: "Feelings"
      items:
        # HSTAT-Q25 / HSC4_25: Usual emotional state
        - id: q_hstat_q25
          kind: Question
          title: "Would you describe yourself/... as being usually:"
          input:
            control: Radio
            labels:
              1: "Happy and interested in life"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Unhappy with little interest in life"
              5: "So unhappy that life is not worthwhile"

    # =========================================================================
    # BLOCK 8: MEMORY (HSTAT-Q26)
    # =========================================================================
    # Q26: Single question — always asked; no branching.
    # =========================================================================
    - id: b_memory
      title: "Memory"
      items:
        # HSTAT-Q26 / HSC4_26: Usual ability to remember things
        - id: q_hstat_q26
          kind: Question
          title: "How would you describe your/his/her usual ability to remember things?"
          input:
            control: Radio
            labels:
              1: "Able to remember most things"
              2: "Somewhat forgetful"
              3: "Very forgetful"
              4: "Unable to remember anything at all"

    # =========================================================================
    # BLOCK 9: THINKING (HSTAT-Q27)
    # =========================================================================
    # Q27: Single question — always asked; no branching.
    # =========================================================================
    - id: b_thinking
      title: "Thinking"
      items:
        # HSTAT-Q27 / HSC4_27: Usual ability to think and solve problems
        - id: q_hstat_q27
          kind: Question
          title: "How would you describe your/his/her usual ability to think and solve day to day problems?"
          input:
            control: Radio
            labels:
              1: "Able to think clearly and solve problems"
              2: "Having a little difficulty"
              3: "Having some difficulty"
              4: "Having a great deal of difficulty"
              5: "Unable to think or solve problems"

    # =========================================================================
    # BLOCK 10: PAIN AND DISCOMFORT (HSTAT-Q28 to HSTAT-Q30)
    # =========================================================================
    # Q28: Usually free of pain? Yes→Drug Use section (end), No→Q29
    # Q29: Pain intensity (shown when Q28=No)
    # Q30: Activities prevented by pain (shown when Q28=No)
    # =========================================================================
    - id: b_pain
      title: "Pain and Discomfort"
      items:
        # HSTAT-Q28 / HSC4_28: Usually free of pain or discomfort?
        # Yes(1) → end of section (skip Q29/Q30); No(0) → continue to Q29
        - id: q_hstat_q28
          kind: Question
          title: "Are/Is ... usually free of pain or discomfort?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # HSTAT-Q29 / HSC4_29: Usual intensity of pain or discomfort
        # Shown when Q28=No (not free of pain)
        - id: q_hstat_q29
          kind: Question
          title: "How would you describe the usual intensity of your/his/her pain or discomfort?"
          precondition:
            - predicate: q_hstat_q28.outcome == 0
          input:
            control: Radio
            labels:
              1: "Mild"
              2: "Moderate"
              3: "Severe"

        # HSTAT-Q30 / HSC4_30: How many activities does pain prevent?
        # Shown when Q28=No (not free of pain)
        - id: q_hstat_q30
          kind: Question
          title: "How many activities does your/his/her pain or discomfort prevent?"
          precondition:
            - predicate: q_hstat_q28.outcome == 0
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Some"
              4: "Most"

    # =====================================================================
    # SECTION 13: Drug Use Mental Health
    # =====================================================================
    # =========================================================================
    # BLOCK 1: DRUG USE (DRUG-INT to DRUG-Q5)
    # =========================================================================
    # Routing summary:
    #   DRUG-Q1 (medications checkbox)
    #     Any selected (outcome > 0 and not none-only) → Q2 → Q3 → Q4
    #     None selected (DGC4_NON only, outcome = 0)   → Q4
    #   DRUG-Q4 (health products): always asked
    #     Yes (1) → Q5
    #     No / DK/R → end of section
    #
    # Sex/age gating on DRUG-Q1:
    #   DGC4_1T (hormones for menopause): sex=female (2), age >= 30
    #   DGC4_1S (birth control pills):   sex=female (2), age 12-49
    #   Both items are individual Switch questions placed after the main
    #   Checkbox so their preconditions are evaluated independently.
    #
    # DGC4_NON (None of the above) is modelled as value 0 in the Checkbox
    # (respondent selects nothing). The main Checkbox captures the 18 items
    # without sex/age gates (keys 1..2^17). The two gated items are separate.
    # =========================================================================
    - id: b_drug_use
      title: "Drug Use"
      items:
        # DRUG-INT: Section introduction (no response)
        - id: q_drug_int
          kind: Comment
          title: "Now I'd like to ask a few questions about ...(r/'s) use of medications, both prescription and over-the-counter as well as other health products."

        # DRUG-Q1 / DGC4_1A-DGC4_1V, DGC4_NON:
        # Medications taken in the past month (mark all that apply).
        # Items without sex/age restrictions. Power-of-2 keys for all 18 items.
        # DGC4_1T (hormones) and DGC4_1S (birth control) are separate questions below.
        - id: q_drug_q1
          kind: Question
          title: "In the past month, did ... take any of the following medications? (Read list. Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Pain relievers (aspirin, tylenol, anti-inflammatories)"
              2: "Tranquilizers (valium)"
              4: "Diet pills"
              8: "Anti-depressants"
              16: "Codeine, Demerol or Morphine"
              32: "Allergy medicine (Sinutab)"
              64: "Asthma medications"
              128: "Cough or cold remedies"
              256: "Penicillin or other antibiotic"
              512: "Medicine for the heart"
              1024: "Medicine for blood pressure"
              2048: "Diuretics or water pills"
              4096: "Steroids"
              8192: "Insulin"
              16384: "Pills to control diabetes"
              32768: "Sleeping pills"
              65536: "Stomach remedies"
              131072: "Laxatives"
              262144: "Any other medication (Specify)"
              0: "None of the above"

        # DRUG-Q1T / DGC4_1T: Hormones for menopause or aging symptoms
        # Sex/age gate: female (sex=2) AND age >= 30
        - id: q_drug_q1t
          kind: Question
          title: "In the past month, did ... take — Hormones for menopause or aging symptoms?"
          precondition:
            - predicate: sex == 2 and age >= 30
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # DRUG-Q1S / DGC4_1S: Birth control pills
        # Sex/age gate: female (sex=2) AND age 12-49
        - id: q_drug_q1s
          kind: Question
          title: "In the past month, did ... take — Birth control pills?"
          precondition:
            - predicate: sex == 2 and age >= 12 and age <= 49
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # DRUG-C1: If any drug(s) specified in DRUG-Q1 → Q2. Otherwise → Q4.
        # Modelled via precondition on Q2/Q3.
        # "Any drug" = q_drug_q1.outcome > 0 (Checkbox non-zero selection)
        #              OR q_drug_q1t.outcome == 1 OR q_drug_q1s.outcome == 1
        # "None" = q_drug_q1.outcome == 0 AND q_drug_q1t.outcome != 1
        #          AND q_drug_q1s.outcome != 1

        # DRUG-Q2 / DGC4_2: Count of medications taken yesterday/day before
        # Precondition: any medication was selected in Q1/Q1T/Q1S
        # DK/R → GO TO DRUG-Q4; If 0 → GO TO DRUG-Q4
        - id: q_drug_q2
          kind: Question
          title: "Now, I am referring to yesterday and the day before yesterday. During those two days, how many different medications did you/he/she take?"
          precondition:
            - predicate: q_drug_q1.outcome > 0 or q_drug_q1t.outcome == 1 or q_drug_q1s.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 12
            right: "medications"

        # DRUG-Q3 / DGC4_3nC: Exact name of each medication taken
        # Precondition: Q2 > 0 (at least one medication taken yesterday/day before)
        # Modelled as single Textarea (source has up to 12 iterations)
        - id: q_drug_q3
          kind: Question
          title: "What is the exact name of the medication that ... took? (Ask the person to look at the bottle, tube or box.)"
          precondition:
            - predicate: q_drug_q1.outcome > 0 or q_drug_q1t.outcome == 1 or q_drug_q1s.outcome == 1
            - predicate: q_drug_q2.outcome > 0
          input:
            control: Textarea
            placeholder: "List medication names (up to 12)"
            maxLength: 500

        # DRUG-Q4 / DGC4_4: Other health products
        # Always asked (no precondition). After drug medications path or directly.
        - id: q_drug_q4
          kind: Question
          title: "There are many other health products such as ointments, vitamins, herbs, minerals, teas or protein drinks which people use to prevent illness or to improve or maintain their health. Do/Does ... use any of these or other health products?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Refused"

        # DRUG-Q5 / DGC4_5nn: Exact name of health product(s)
        # Precondition: Q4 = Yes
        - id: q_drug_q5
          kind: Question
          title: "What is the exact name of the health product that ... use(s)? (Ask the person to look at the bottle, tube or box.)"
          precondition:
            - predicate: q_drug_q4.outcome == 1
          input:
            control: Textarea
            placeholder: "List health product names (up to 12)"
            maxLength: 500

    # =========================================================================
    # BLOCK 2: MENTAL HEALTH (MHLTH-INTa to MHLTH-Q28)
    # =========================================================================
    # Non-proxy only — proxy status not modelled; block always presented.
    #
    # Routing summary:
    #
    # DISTRESS SCALE (Q1a-Q1f, Q1g-Q1k):
    #   Q1a-Q1f: frequency scale 1-5 (1=All of the time … 5=None of the time)
    #   DK/R on any Q1a-Q1f → skip to Q1k
    #   C1g: if all Q1a-Q1f = 5 (None) → skip to Q1k
    #   Q1g: 1=More often → Q1h → Q1j
    #         2=Less often → Q1i → Q1k
    #         3=Same       → Q1j
    #         4=Never / DK/R → Q1k
    #   Q1h: all → Q1j
    #   Q1i: all → Q1k
    #   Q1j: always when Q1g in [1, 2, 3]
    #   Q1k: always (mental health professional contact)
    #   Q1l: if Q1k = Yes
    #
    # DEPRESSION PATHWAY (Q2-Q15):
    #   Q2 = Yes (1) → Q3
    #   Q2 = No (2)  → Q16
    #   Q2 = DK/R    → end section (Social Support)
    #   Q3: options 1-2 continue; 3-4 → Q16; DK/R → end section
    #   Q4: options 1-2 continue; 3 → Q16; DK/R → end section
    #   Q5-Q13: all asked if Q2=Yes AND Q3 in [1,2] AND Q4 in [1,2]
    #   Q7: 1=Gained / 2=Lost → Q8 → Q9; 3=Same / 4=Diet → Q9; DK/R → end
    #   Q9: Yes → Q10 → Q11; No → Q11; DK/R → end
    #   C14: any Yes in Q5,Q6,Q9,Q11,Q12,Q13 or Q7 in [1,2] → Q14; else → Q16
    #   Q14 → Q15 → Q16
    #
    # LOSS OF INTEREST PATHWAY (Q16-Q28):
    #   Q16 = Yes (1) → Q17
    #   Q16 = No / DK/R → end section
    #   Q17: 1-2 continue; 3-4 → end; DK/R → end
    #   Q18: 1-2 continue; 3 → end; DK/R → end
    #   Q19-Q26: all asked if Q16=Yes AND Q17 in [1,2] AND Q18 in [1,2]
    #   Q20: 1=Gained / 2=Lost → Q21 → Q22; 3=Same / 4=Diet → Q22; DK/R → end
    #   Q22: Yes → Q23 → Q24; No → Q24; DK/R → end
    #   C27: any Yes in Q19,Q22,Q24,Q25,Q26 or Q20 in [1,2] → Q27; else → end
    #   Q27 → Q28 → end section
    # =========================================================================
    - id: b_mental_health
      title: "Mental Health"
      items:
        # MHLTH-INTa: Section introduction
        - id: q_mhlth_int
          kind: Comment
          title: "Now some questions about mental and emotional well-being. During the past month, about how often did you feel:"

        # MHLTH-Q1a / MHC4_1A: Sad feelings
        # DK/R → GO TO MHLTH-Q1k (modelled: no precondition; Q1g+ gated on distress_any)
        - id: q_mhlth_q1a
          kind: Question
          title: "... so sad that nothing could cheer you up?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1b / MHC4_1B: Nervous
        - id: q_mhlth_q1b
          kind: Question
          title: "... nervous?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1c / MHC4_1C: Restless or fidgety
        - id: q_mhlth_q1c
          kind: Question
          title: "... restless or fidgety?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1d / MHC4_1D: Hopeless
        - id: q_mhlth_q1d
          kind: Question
          title: "... hopeless?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1e / MHC4_1E: Worthless
        - id: q_mhlth_q1e
          kind: Question
          title: "... worthless?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1f / MHC4_1F: Everything was an effort
        - id: q_mhlth_q1f
          kind: Question
          title: "During the past month, about how often did you feel that everything was an effort?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-C1g: If all Q1a-Q1f = 5 (None of the time) → skip to Q1k
        # Modelled via precondition on Q1g: requires at least one < 5

        # MHLTH-Q1g / MHC4_1G: Change in frequency of feelings
        # Precondition: at least one Q1a-Q1f answered with distress (< 5)
        # 1=More often → Q1h; 2=Less often → Q1i; 3=Same → Q1j; 4=Never / DK/R → Q1k
        - id: q_mhlth_q1g
          kind: Question
          title: "Taking them altogether, did these feelings occur more often in the past month than is usual for you, less often than usual, or about the same as usual?"
          precondition:
            - predicate: q_mhlth_q1a.outcome < 5 or q_mhlth_q1b.outcome < 5 or q_mhlth_q1c.outcome < 5 or q_mhlth_q1d.outcome < 5 or q_mhlth_q1e.outcome < 5 or q_mhlth_q1f.outcome < 5
          input:
            control: Radio
            labels:
              1: "More often"
              2: "Less often"
              3: "About the same"
              4: "Never have had any"

        # MHLTH-Q1h / MHC4_1H: How much more often
        # Precondition: Q1g = 1 (More often)
        # All → GO TO Q1j
        - id: q_mhlth_q1h
          kind: Question
          title: "Is that a lot more, somewhat or only a little more often than usual?"
          precondition:
            - predicate: q_mhlth_q1a.outcome < 5 or q_mhlth_q1b.outcome < 5 or q_mhlth_q1c.outcome < 5 or q_mhlth_q1d.outcome < 5 or q_mhlth_q1e.outcome < 5 or q_mhlth_q1f.outcome < 5
            - predicate: q_mhlth_q1g.outcome == 1
          input:
            control: Radio
            labels:
              1: "A lot more"
              2: "Somewhat more"
              3: "A little more"

        # MHLTH-Q1i / MHC4_1I: How much less often
        # Precondition: Q1g = 2 (Less often)
        # DK/R → Q1k; otherwise → Q1k (inventory: Q1i → Q1k)
        - id: q_mhlth_q1i
          kind: Question
          title: "Is that a lot less, somewhat or only a little less often than usual?"
          precondition:
            - predicate: q_mhlth_q1a.outcome < 5 or q_mhlth_q1b.outcome < 5 or q_mhlth_q1c.outcome < 5 or q_mhlth_q1d.outcome < 5 or q_mhlth_q1e.outcome < 5 or q_mhlth_q1f.outcome < 5
            - predicate: q_mhlth_q1g.outcome == 2
          input:
            control: Radio
            labels:
              1: "A lot less"
              2: "Somewhat less"
              3: "A little less"

        # MHLTH-Q1j / MHC4_1J: Interference with life/activities
        # Precondition: Q1g in [1, 2, 3] (not "Never" and not skip-to-Q1k paths)
        # Q1i → Q1k so Q1j is only reached from Q1g=1 (via Q1h) or Q1g=3 (direct)
        - id: q_mhlth_q1j
          kind: Question
          title: "How much do these experiences usually interfere with your life or activities?"
          precondition:
            - predicate: q_mhlth_q1a.outcome < 5 or q_mhlth_q1b.outcome < 5 or q_mhlth_q1c.outcome < 5 or q_mhlth_q1d.outcome < 5 or q_mhlth_q1e.outcome < 5 or q_mhlth_q1f.outcome < 5
            - predicate: q_mhlth_q1g.outcome == 1 or q_mhlth_q1g.outcome == 3
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "Some"
              3: "A little"
              4: "Not at all"

        # MHLTH-Q1k / MHC4_1K: Seen mental health professional in past 12 months
        # Always asked (no precondition within mental health block)
        # No (2) / DK/R → Q2; Yes (1) → Q1l
        - id: q_mhlth_q1k
          kind: Question
          title: "In the past 12 months, have you seen or talked on the telephone to a health professional about your emotional or mental health?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Refused"

        # MHLTH-Q1l / MHC4_1L: How many times seen mental health professional
        # Precondition: Q1k = Yes
        - id: q_mhlth_q1l
          kind: Question
          title: "How many times (in the past 12 months)?"
          precondition:
            - predicate: q_mhlth_q1k.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999
            right: "times"

        # =====================================================================
        # DEPRESSION PATHWAY (Q2-Q15)
        # =====================================================================

        # MHLTH-Q2 / MHC4_2: Sad/blue/depressed for 2+ weeks
        # Yes (1) → Q3; No (2) → Q16; DK/R → end section
        - id: q_mhlth_q2
          kind: Question
          title: "During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Refused"

        # MHLTH-Q3 / MHC4_3: How long did feelings last during worst 2-week period
        # Precondition: Q2 = Yes
        # 1=All day / 2=Most of day → continue; 3=Half day / 4=Less than half → Q16
        # DK/R → end section
        - id: q_mhlth_q3
          kind: Question
          title: "For the next few questions, please think of the 2-week period during the past 12 months when these feelings were worst. During that time how long did these feelings usually last?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "All day long"
              2: "Most of the day"
              3: "About half of the day"
              4: "Less than half the day"

        # MHLTH-Q4 / MHC4_4: How often felt this way during those 2 weeks
        # Precondition: Q2=Yes AND Q3 in [1,2]
        # 1=Every day / 2=Almost every day → continue; 3=Less often → Q16
        # DK/R → end section
        - id: q_mhlth_q4
          kind: Question
          title: "How often did you feel this way during those 2 weeks?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Almost every day"
              3: "Less often"

        # Gate for Q5-Q13: Q2=Yes AND Q3 in [1,2] AND Q4 in [1,2]
        # (used as shared precondition for depression symptom questions)

        # MHLTH-Q5 / MHC4_5: Lost interest in most things
        - id: q_mhlth_q5
          kind: Question
          title: "During those 2 weeks did you lose interest in most things?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q6 / MHC4_6: Tired out or low on energy all the time
        - id: q_mhlth_q6
          kind: Question
          title: "Did you feel tired out or low on energy all of the time?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q7 / MHC4_7: Weight change
        # 1=Gained / 2=Lost → Q8; 3=Same / 4=Diet → Q9; DK/R → end
        - id: q_mhlth_q7
          kind: Question
          title: "Did you gain weight, lose weight or stay about the same?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Gained weight"
              2: "Lost weight"
              3: "Stayed about the same"
              4: "Was on a diet"

        # MHLTH-Q8 / MHC4_8LB / MHC4_8KG: How much gained/lost
        # Precondition: Q7 in [1, 2] (gained or lost weight)
        - id: q_mhlth_q8
          kind: Question
          title: "About how much did you (gain/lose)?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
            - predicate: q_mhlth_q7.outcome == 1 or q_mhlth_q7.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 500
            right: "pounds or kilograms"

        # MHLTH-Q9 / MHC4_9: Trouble falling asleep
        # No (2) / DK/R → Q11
        - id: q_mhlth_q9
          kind: Question
          title: "Did you have more trouble falling asleep than you usually do?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q10 / MHC4_10: How often had trouble falling asleep
        # Precondition: Q9 = Yes
        - id: q_mhlth_q10
          kind: Question
          title: "How often did that happen?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
            - predicate: q_mhlth_q9.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every night"
              2: "Nearly every night"
              3: "Less often"

        # MHLTH-Q11 / MHC4_11: Trouble concentrating
        - id: q_mhlth_q11
          kind: Question
          title: "Did you have a lot more trouble concentrating than usual?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q12 / MHC4_12: Feeling down on yourself / worthless
        - id: q_mhlth_q12
          kind: Question
          title: "At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q13 / MHC4_13: Thoughts about death
        - id: q_mhlth_q13
          kind: Question
          title: "Did you think a lot about death - either your own, someone else's, or death in general?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-C14: If any Yes in Q5, Q6, Q9, Q11, Q12, Q13 or Q7 in [1,2] → Q14
        # Modelled via precondition on Q14

        # MHLTH-Q14 / MHC4_14: Total weeks sad/depressed
        # Precondition: depression path AND at least one symptom present
        - id: q_mhlth_q14
          kind: Question
          title: "Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you were sad, blue, or depressed and also had some other things. About how many weeks altogether did you feel this way during the past 12 months?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
            - predicate: q_mhlth_q5.outcome == 1 or q_mhlth_q6.outcome == 1 or q_mhlth_q9.outcome == 1 or q_mhlth_q11.outcome == 1 or q_mhlth_q12.outcome == 1 or q_mhlth_q13.outcome == 1 or q_mhlth_q7.outcome == 1 or q_mhlth_q7.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        # MHLTH-Q15 / MHC4_15: Month of last episode (depression)
        # Precondition: same as Q14
        - id: q_mhlth_q15
          kind: Question
          title: "Think about the last time you felt this way for 2 weeks or more in a row. In what month was that?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
            - predicate: q_mhlth_q5.outcome == 1 or q_mhlth_q6.outcome == 1 or q_mhlth_q9.outcome == 1 or q_mhlth_q11.outcome == 1 or q_mhlth_q12.outcome == 1 or q_mhlth_q13.outcome == 1 or q_mhlth_q7.outcome == 1 or q_mhlth_q7.outcome == 2
          input:
            control: Radio
            labels:
              1: "January"
              2: "February"
              3: "March"
              4: "April"
              5: "May"
              6: "June"
              7: "July"
              8: "August"
              9: "September"
              10: "October"
              11: "November"
              12: "December"

        # =====================================================================
        # LOSS OF INTEREST PATHWAY (Q16-Q28)
        # =====================================================================

        # MHLTH-Q16 / MHC4_16: Lost interest in most things for 2+ weeks
        # Reached from: Q2=No, Q3 in [3,4], Q4=3, or after Q14/Q15
        # Yes (1) → Q17; No (2) / DK/R → end section
        - id: q_mhlth_q16
          kind: Question
          title: "During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work, or activities that usually give you pleasure?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Refused"

        # MHLTH-Q17 / MHC4_17: Duration of loss of interest during worst 2-week period
        # Precondition: Q16 = Yes
        # 1-2 → continue; 3-4 → end; DK/R → end
        - id: q_mhlth_q17
          kind: Question
          title: "For the next few questions, please think of the 2-week period during the past 12 months when you had the most complete loss of interest in things. During that 2-week period, how long did the loss of interest usually last?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
          input:
            control: Radio
            labels:
              1: "All day long"
              2: "Most of the day"
              3: "About half of the day"
              4: "Less than half the day"

        # MHLTH-Q18 / MHC4_18: How often lost interest during those 2 weeks
        # Precondition: Q16=Yes AND Q17 in [1,2]
        # 1-2 → continue; 3 → end; DK/R → end
        - id: q_mhlth_q18
          kind: Question
          title: "How often did you feel this way during those 2 weeks?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Almost every day"
              3: "Less often"

        # Gate for Q19-Q26: Q16=Yes AND Q17 in [1,2] AND Q18 in [1,2]

        # MHLTH-Q19 / MHC4_19: Tired out or low on energy (loss of interest pathway)
        - id: q_mhlth_q19
          kind: Question
          title: "During those 2 weeks did you feel tired out or low on energy all the time?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q20 / MHC4_20: Weight change (loss of interest pathway)
        # 1=Gained / 2=Lost → Q21; 3=Same / 4=Diet → Q22; DK/R → end
        - id: q_mhlth_q20
          kind: Question
          title: "Did you gain weight, lose weight, or stay about the same?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Gained weight"
              2: "Lost weight"
              3: "Stayed about the same"
              4: "Was on a diet"

        # MHLTH-Q21 / MHC4_21L / MHC4_21K: How much gained/lost (loss of interest pathway)
        # Precondition: Q20 in [1, 2]
        - id: q_mhlth_q21
          kind: Question
          title: "About how much did you (gain/lose)?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
            - predicate: q_mhlth_q20.outcome == 1 or q_mhlth_q20.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 500
            right: "pounds or kilograms"

        # MHLTH-Q22 / MHC4_22: Trouble falling asleep (loss of interest pathway)
        # No (2) / DK/R → Q24
        - id: q_mhlth_q22
          kind: Question
          title: "Did you have more trouble falling asleep than you usually do?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q23 / MHC4_23: How often trouble falling asleep (loss of interest pathway)
        # Precondition: Q22 = Yes
        - id: q_mhlth_q23
          kind: Question
          title: "How often did that happen during those 2 weeks?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
            - predicate: q_mhlth_q22.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every night"
              2: "Nearly every night"
              3: "Less often"

        # MHLTH-Q24 / MHC4_24: Trouble concentrating (loss of interest pathway)
        - id: q_mhlth_q24
          kind: Question
          title: "Did you have a lot more trouble concentrating than usual?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q25 / MHC4_25: Feeling down on yourself (loss of interest pathway)
        - id: q_mhlth_q25
          kind: Question
          title: "At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q26 / MHC4_26: Thoughts about death (loss of interest pathway)
        - id: q_mhlth_q26
          kind: Question
          title: "Did you think a lot about death - either your own, someone else's, or death in general?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-C27: If any Yes in Q19, Q22, Q24, Q25, Q26 or Q20 in [1,2] → Q27
        # Modelled via precondition on Q27

        # MHLTH-Q27 / MHC4_27: Total weeks with loss of interest
        # Precondition: loss-of-interest path AND at least one symptom present
        - id: q_mhlth_q27
          kind: Question
          title: "Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you lost interest in most things and also had some other things. About how many weeks did you feel this way during the past 12 months?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
            - predicate: q_mhlth_q19.outcome == 1 or q_mhlth_q22.outcome == 1 or q_mhlth_q24.outcome == 1 or q_mhlth_q25.outcome == 1 or q_mhlth_q26.outcome == 1 or q_mhlth_q20.outcome == 1 or q_mhlth_q20.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        # MHLTH-Q28 / MHC4_28: Month of last episode (loss of interest)
        # Precondition: same as Q27
        - id: q_mhlth_q28
          kind: Question
          title: "Think about the last time you had 2 weeks in a row when you felt this way. In what month was that?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
            - predicate: q_mhlth_q19.outcome == 1 or q_mhlth_q22.outcome == 1 or q_mhlth_q24.outcome == 1 or q_mhlth_q25.outcome == 1 or q_mhlth_q26.outcome == 1 or q_mhlth_q20.outcome == 1 or q_mhlth_q20.outcome == 2
          input:
            control: Radio
            labels:
              1: "January"
              2: "February"
              3: "March"
              4: "April"
              5: "May"
              6: "June"
              7: "July"
              8: "August"
              9: "September"
              10: "October"
              11: "November"
              12: "December"

    # =====================================================================
    # SECTION 14: Social Support Consent
    # =====================================================================
    # =========================================================================
    # BLOCK 1: SOCIAL SUPPORT (SOCSUP — 9 items)
    # =========================================================================
    # SOCSUP-INT   → intro comment (always)
    # SOCSUP-Q1    → Member of voluntary organizations? Switch. No/DK/R → skip Q2, go to Q2a.
    # SOCSUP-Q2    → Participation frequency (precondition: Q1 = Yes, i.e. == 1)
    # SOCSUP-Q2a   → Religious service attendance (always)
    # SOCSUP-Q3    → Someone to confide in (always) Switch
    # SOCSUP-Q4    → Someone to count on in crisis (always) Switch
    # SOCSUP-Q5    → Someone to give advice (always) Switch
    # SOCSUP-Q6    → Someone who makes you feel loved (always) Switch
    # SOCSUP-Q7    → Contact frequency grid (always) QuestionGroup with 8 sub-items Radio 8 options
    # =========================================================================
    - id: b_social_support
      title: "Social Support"
      items:
        # SOCSUP-INT: Interviewer introduction
        - id: q_socsup_int
          kind: Comment
          title: "Now, a few questions about your contact with different groups and support from family and friends."

        # SOCSUP-Q1 / SSC4_1: Member of voluntary organizations?
        # No/DK/R → GO TO SOCSUP-Q2a (skip Q2)
        - id: q_socsup_q1
          kind: Question
          title: "Are you a member of any voluntary organizations or associations such as school groups, church social groups, community centres, ethnic associations or social, civic or fraternal clubs?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q2 / SSC4_2: Participation frequency
        # Precondition: Q1 = Yes (outcome == 1)
        - id: q_socsup_q2
          kind: Question
          title: "How often did you participate in meetings or activities sponsored by these groups in the past 12 months?"
          precondition:
            - predicate: q_socsup_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least 3 or 4 times a year"
              4: "At least once a year"
              5: "Not at all"

        # SOCSUP-Q2a / SSC4_2A: Religious attendance (always asked)
        - id: q_socsup_q2a
          kind: Question
          title: "Other than on special occasions (weddings, funerals, baptisms), how often did you attend religious services or religious meetings in the past 12 months?"
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least 3 or 4 times a year"
              4: "At least once a year"
              5: "Not at all"

        # SOCSUP-Q3 / SSC4_3: Someone to confide in (always asked)
        - id: q_socsup_q3
          kind: Question
          title: "Do you have someone you can confide in, or talk to about your private feelings or concerns?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q4 / SSC4_4: Someone to count on in crisis (always asked)
        - id: q_socsup_q4
          kind: Question
          title: "Do you have someone you can really count on to help you out in a crisis situation?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q5 / SSC4_5: Someone to give advice (always asked)
        - id: q_socsup_q5
          kind: Question
          title: "Do you have someone you can really count on to give you advice when you are making important personal decisions?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q6 / SSC4_6: Someone who makes you feel loved (always asked)
        - id: q_socsup_q6
          kind: Question
          title: "Do you have someone that makes you feel loved and cared for?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # SOCSUP-Q7 / SSC4_7A-7H: Contact frequency grid (always asked)
        # 8 sub-items, each with 8-option Radio scale.
        # Options: 1=Don't have any, 2=Every day, 3=At least once a week,
        #          4=2 or 3 times a month, 5=Once a month, 6=A few times a year,
        #          7=Once a year, 8=Never
        - id: qg_socsup_q7
          kind: QuestionGroup
          title: "The next few questions are about your contact in the past 12 months with persons who do not live with you. How often did you have contact with:"
          questions:
            - "Your parents or parents-in-law"
            - "Your grandparents"
            - "Your daughters or daughters-in-law"
            - "Your sons or sons-in-law"
            - "Your brothers or sisters"
            - "Other relatives (including in-laws)"
            - "Your close friends"
            - "Your neighbours"
          input:
            control: Radio
            labels:
              1: "Don't have any"
              2: "Every day"
              3: "At least once a week"
              4: "2 or 3 times a month"
              5: "Once a month"
              6: "A few times a year"
              7: "Once a year"
              8: "Never"

    # =========================================================================
    # BLOCK 2: HEALTH NUMBER (H06-HLTH# — 2 items)
    # =========================================================================
    # H06-HLTH#   → Permission to link health info. Switch. No/DK/R → skip H06-HLTH#1.
    # H06-HLTH#1  → Provincial health number. Textarea. Precondition: H06-HLTH# = Yes.
    # =========================================================================
    - id: b_health_number
      title: "Health Number"
      items:
        # H06-HLTH# / AM64_LNK: Permission to link health information
        # No/DK/R → GO TO Agreement to Share section (skip H06-HLTH#1)
        - id: q_h06_hlth_link
          kind: Question
          title: "We are seeking your permission to link information collected during this interview with provincial health information. Do we have your permission?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H06-HLTH#1 / HNC4_nn: Provincial health number
        # Precondition: H06-HLTH# = Yes (outcome == 1)
        - id: q_h06_hlth1
          kind: Question
          title: "What is your/his/her provincial health number?"
          precondition:
            - predicate: q_h06_hlth_link.outcome == 1
          input:
            control: Textarea

    # =========================================================================
    # BLOCK 3: AGREEMENT TO SHARE (H06-SHARE — 5 items)
    # =========================================================================
    # H06-SHARE  → Permission to share survey data (always)
    # H06-TEL    → Interview mode: telephone/in person/both (always)
    # H06-CTEXT  → Respondent alone? Switch. Yes → skip H06-CTEXT1, go to H06-P2.
    # H06-CTEXT1 → Answers affected by someone? Precondition: H06-CTEXT = No.
    # H06-P2     → Language of interview. Dropdown 19 options (always).
    # =========================================================================
    - id: b_agreement_to_share
      title: "Agreement to Share"
      items:
        # H06-SHARE / AM64_SHA: Permission to share survey information
        - id: q_h06_share
          kind: Question
          title: "To avoid duplication Statistics Canada intends to share the information from this survey with provincial ministries of health, Health Canada, and Employment and Immigration Canada. Do you agree to share the information you have provided?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H06-TEL / AM64_TEL: Interview mode
        - id: q_h06_tel
          kind: Question
          title: "Was this interview conducted on the telephone or in person?"
          input:
            control: Radio
            labels:
              1: "On telephone"
              2: "In person"
              3: "Both (Specify reason)"

        # H06-CTEXT / AM64_ALO: Was respondent alone?
        # Yes → GO TO H06-P2 (skip H06-CTEXT1)
        - id: q_h06_ctext
          kind: Question
          title: "Was the respondent alone when you asked this health questionnaire?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H06-CTEXT1 / AM64_AFF: Were answers affected by someone else?
        # Precondition: H06-CTEXT = No (outcome == 0)
        - id: q_h06_ctext1
          kind: Question
          title: "Do you think that the answers of the respondent were affected by someone else being there?"
          precondition:
            - predicate: q_h06_ctext.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # H06-P2 / AM64_LNG: Language of interview (always asked)
        # 19 options
        - id: q_h06_p2
          kind: Question
          title: "Record language of interview"
          input:
            control: Dropdown
            labels:
              1: "English"
              2: "French"
              3: "Arabic"
              4: "Chinese"
              5: "Cree"
              6: "German"
              7: "Greek"
              8: "Hungarian"
              9: "Italian"
              10: "Korean"
              11: "Persian (Farsi)"
              12: "Polish"
              13: "Portuguese"
              14: "Punjabi"
              15: "Spanish"
              16: "Tagalog (Filipino)"
              17: "Ukrainian"
              18: "Vietnamese"
              19: "Other (Specify)"

    # =====================================================================
    # SECTION 15: Provincial Buyin
    # =====================================================================
    # =========================================================================
    # BLOCK 1: MANITOBA BUY-IN (SPR6-INTA to SPR6-Q13)
    # =========================================================================
    # Routing summary:
    #   All items: age >= 18 (non-proxy)
    #   SPR6-INTA: Introduction
    #   SPR6-INTB: Instructions for Yes/No questions
    #   SPR6-Q1 to Q11: Rational/emotional relating style (Switch Yes/No each)
    #   SPR6-INTQ12: Scenario intro
    #   SPR6-Q12: Dentist coping scenario (Checkbox, 9 options)
    #   SPR6-Q13: Layoff coping scenario (Checkbox, 9 options)
    # =========================================================================
    - id: b_manitoba
      title: "Manitoba Buy-in"
      precondition:
        - predicate: age >= 18
      items:
        # SPR6-INTA: Section introduction (no response)
        - id: q_spr6_inta
          kind: Comment
          title: "The next questions are being asked for your provincial government. They deal with the day-to-day demands in your life."

        # SPR6-INTB: Instructions for Yes/No questions (no response)
        - id: q_spr6_intb
          kind: Comment
          title: "When relating to people, some people rely heavily on their thinking, rational side. Others rely much more on their emotional side. Please answer either 'Yes' or 'No' to each question."

        # SPR6-Q1 / RTP4_1
        - id: q_spr6_q1
          kind: Question
          title: "Do you always try to do what is reasonable and logical?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q2 / RTP4_2
        - id: q_spr6_q2
          kind: Question
          title: "Do you always try to understand people and their behaviour, to avoid responding emotionally?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q3 / RTP4_3
        - id: q_spr6_q3
          kind: Question
          title: "When dealing with other people do you always try to act rationally?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q4 / RTP4_4
        - id: q_spr6_q4
          kind: Question
          title: "Do you try to overcome all conflicts with other people by intelligence and reason, trying hard not to show your emotions?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q5 / RTP4_5
        - id: q_spr6_q5
          kind: Question
          title: "If someone deeply hurts your feelings, do you nevertheless try to treat him or her rationally and to understand his or her way of behaving?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q6 / RTP4_6
        - id: q_spr6_q6
          kind: Question
          title: "Do you succeed in avoiding most conflicts with other people by relying on your reason and logic, even if this is not how you feel at the time?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q7 / RTP4_7
        - id: q_spr6_q7
          kind: Question
          title: "If someone acts against your needs and desires, do you nevertheless try to understand that person?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q8 / RTP4_8
        - id: q_spr6_q8
          kind: Question
          title: "Do you behave so rationally in most life situations that your behaviour is rarely influenced by only your emotions?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q9 / RTP4_9
        - id: q_spr6_q9
          kind: Question
          title: "Do your emotions frequently influence your behaviour to such a degree that your behaviour might be considered harmful to yourself and others?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q10 / RTP4_10
        - id: q_spr6_q10
          kind: Question
          title: "Do you try to understand others even if you don't like them?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-Q11 / RTP4_11
        - id: q_spr6_q11
          kind: Question
          title: "Does your rationality prevent you from verbally attacking or criticizing others, even if there are sufficient reasons for doing so?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SPR6-INTQ12: Scenario introduction (no response)
        - id: q_spr6_intq12
          kind: Comment
          title: "In the next few questions, you will be asked to imagine yourself in a particular situation."

        # SPR6-Q12 / RTP4_12A-12I: Dentist coping scenario
        # Checkbox — powers of 2: 1,2,4,8,16,32,64,128,256
        - id: q_spr6_q12
          kind: Question
          title: "Imagine you are afraid of the dentist and you have to get some dental work done. Which of the following things would you do to help you overcome your fears?"
          input:
            control: Checkbox
            labels:
              1: "Ask the dentist exactly what he is doing"
              2: "Take a tranquilizer or have a drink before going"
              4: "Try to think about other things"
              8: "Have the dentist tell you when you would feel pain"
              16: "Try to sleep"
              32: "Watch all the dentist's movements and listen for the sound of the drill"
              64: "Watch the flow of water from your mouth"
              128: "Do mental puzzles in your mind"
              256: "Other (Specify)"

        # SPR6-Q13 / RTP4_13A-13I: Layoff coping scenario
        # Checkbox — powers of 2: 1,2,4,8,16,32,64,128,256
        - id: q_spr6_q13
          kind: Question
          title: "Imagine that you are a salesperson and get along well with your fellow workers. It has been rumoured that several people will be laid off. Which of the following would you do?"
          input:
            control: Checkbox
            labels:
              1: "Talk to fellow workers about supervisor's evaluation"
              2: "Review list of duties"
              4: "Watch TV/go to movies to distract"
              8: "Try to remember disagreements with supervisor"
              16: "Push all thoughts of being laid off out of mind"
              32: "Rather not discuss chances of being laid off"
              64: "Think which employees might be evaluated more poorly"
              128: "Continue doing work as if nothing was happening"
              256: "Other (Specify)"

    # =========================================================================
    # BLOCK 2: ALBERTA BUY-IN (SPR8-INT to SPR8-Q4)
    # =========================================================================
    # Routing summary:
    #   All items: age >= 18 (non-proxy)
    #   SPR8-INT: Introduction
    #   SPR8-Q1: Day-to-day coping ability (Radio 1-5)
    #   SPR8-Q2: Day-to-day stress strategies (Checkbox, 9 options)
    #   SPR8-Q3: Unexpected problems ability (Radio 1-5)
    #   SPR8-Q4: Unexpected stress strategies (Checkbox, 9 options)
    # =========================================================================
    - id: b_alberta
      title: "Alberta Buy-in"
      precondition:
        - predicate: age >= 18
      items:
        # SPR8-INT: Section introduction (no response)
        - id: q_spr8_int
          kind: Comment
          title: "The next questions are being asked for your provincial government. They deal with the day-to-day demands in your life."

        # SPR8-Q1 / COP4_1: Day-to-day coping ability
        - id: q_spr8_q1
          kind: Question
          title: "How would you rate your ability to handle the day-to-day demands in your life, for example, work, family and volunteer responsibilities?"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very Good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # SPR8-Q2 / COP4_2A-2I: Day-to-day stress strategies
        # Checkbox — powers of 2: 1,2,4,8,16,32,64,128,256
        - id: q_spr8_q2
          kind: Question
          title: "If the day-to-day demands in your life were causing you to feel under stress, which of the following would you do?"
          input:
            control: Checkbox
            labels:
              1: "Try not to think about situation/keep busy"
              2: "See situation in different light"
              4: "Think about ways to change situation/solve problem"
              8: "Express emotions to reduce tension"
              16: "Admit stressful but do nothing"
              32: "Talk about it with others"
              64: "Do something enjoyable to relax"
              128: "Pray/seek comfort through faith"
              256: "Do something else (Specify)"

        # SPR8-Q3 / COP4_3: Unexpected problems ability
        - id: q_spr8_q3
          kind: Question
          title: "How would you rate your ability to handle unexpected and difficult problems, for example, family or personal crisis?"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very Good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # SPR8-Q4 / COP4_4A-4I: Unexpected stress strategies
        # Checkbox — powers of 2: 1,2,4,8,16,32,64,128,256
        - id: q_spr8_q4
          kind: Question
          title: "If an unexpected problem or situation was causing you to feel under stress, which of the following would you do?"
          input:
            control: Checkbox
            labels:
              1: "Try not to think about situation/keep busy"
              2: "See situation in different light"
              4: "Think about ways to solve problem"
              8: "Express emotions to reduce tension"
              16: "Admit stressful but do nothing"
              32: "Talk about it with others"
              64: "Do something enjoyable to relax"
              128: "Pray/seek comfort through faith"
              256: "Do something else (Specify)"

    # =====================================================================
    # SECTION 16: Child Health
    # =====================================================================
    # =========================================================================
    # BLOCK 1: CHILD GENERAL HEALTH (KGH — 5 items)
    # =========================================================================
    # KGH-Q1   → Health rating (always)
    # KGH-Q3   → Long-term limitations (always)
    # KGH-Q4   → Height (always)
    # KGH-Q5   → Weight — DK/R routes to next block (modelled as Switch
    #             with a "Skip/Refused" path; valid entries continue to KGH-C5)
    # KGH-C5   → Units: Pounds or Kilograms (precondition: weight answered)
    # =========================================================================
    - id: b_child_general_health
      title: "Child General Health"
      items:
        # KGH-Q1: Overall health rating (GHC4_1)
        - id: q_kgh_q1
          kind: Question
          title: "In general, would you say [child's] health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # KGH-Q3: Long-term condition limiting activities (RAC4F1)
        # Original uses Radio Yes/No; modelled as Switch.
        - id: q_kgh_q3
          kind: Question
          title: "Does [child] have any long-term physical or mental condition or a health problem which prevents or limits [his/her] participation in school, at play, or in any other activity for a child [his/her] age?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # KGH-Q4: Height without shoes (HWC4_HT)
        # Stored in centimetres (0-200 cm).
        - id: q_kgh_q4
          kind: Question
          title: "How tall is [he/she] without shoes on? (in centimetres)"
          input:
            control: Editbox
            min: 0
            max: 200

        # KGH-Q5: Weight (HWC4_3LB / HWC4_3KG)
        # DK/R in original routes to Child Health Care Utilization (next block).
        # Modelled as Editbox; the DK/R skip is implicit — if no valid weight
        # is entered the interviewer proceeds to KUT. Units confirmed by KGH-C5.
        - id: q_kgh_q5
          kind: Question
          title: "How much does [he/she] weigh? (enter numeric value; DK/R proceeds to next section)"
          input:
            control: Editbox
            min: 0
            max: 300

        # KGH-C5: Units check — was the weight in pounds or kilograms?
        # Administrative item; shown after a weight value is provided (Q5 > 0).
        - id: q_kgh_c5
          kind: Question
          title: "Was that in pounds or in kilograms?"
          precondition:
            - predicate: q_kgh_q5.outcome > 0
          input:
            control: Radio
            labels:
              1: "Pounds"
              2: "Kilograms"

    # =========================================================================
    # BLOCK 2: CHILD HEALTH CARE UTILIZATION (KUT — 3 items)
    # =========================================================================
    # KUT-INT  → Interviewer intro comment (always)
    # KUT-Q1   → Overnight hospital patient (always)
    # KUT-Q3   → Professional contact counts — QuestionGroup, 8 sub-items
    # =========================================================================
    - id: b_child_hcu
      title: "Child Health Care Utilization"
      items:
        # KUT-INT: Interviewer instruction
        - id: q_kut_int
          kind: Comment
          title: "Now I'd like to ask about [child's] contacts with health professionals during the past 12 months."

        # KUT-Q1: Overnight hospital patient (HCC4_1)
        - id: q_kut_q1
          kind: Question
          title: "In the past 12 months, has [child] been an overnight patient in a hospital?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # KUT-Q3: Professional contact counts — HCC4_2A/2C/2D/2E/2I/2H/HCK4_2OT
        # "(Not counting when [child] was an overnight patient) In the past 12 months,
        #  how many times have you seen or talked on the telephone with a/an [category]
        #  about [his/her] physical, emotional or mental health?"
        # Each sub-item: 0–366 contacts.
        - id: qg_kut_q3
          kind: QuestionGroup
          title: "(Not counting when [child] was an overnight patient) In the past 12 months, how many times have you seen or talked on the telephone with each of the following about [his/her] physical, emotional or mental health?"
          questions:
            - "General practitioner or family physician"
            - "Pediatrician"
            - "Other medical doctor (orthopedist, eye specialist, etc.)"
            - "Public health nurse or nurse practitioner"
            - "Dentist or orthodontist"
            - "Psychiatrist or psychologist"
            - "Child welfare worker or children's aid worker"
            - "Any other trained person (speech therapist, social worker, etc.)"
          input:
            control: Editbox
            min: 0
            max: 366

    # =========================================================================
    # BLOCK 3: CHILD CHRONIC CONDITIONS (KCHR — 9 items)
    # =========================================================================
    # KCHR-C1  → Filter: age <= 3 → Q1–Q3; age > 3 → skip to Q4
    # KCHR-Q1  → Nose/throat infection frequency (precondition: age <= 3)
    # KCHR-Q2  → Ever had ear infection (precondition: age <= 3)
    # KCHR-Q3  → How many times (precondition: age <= 3 and Q2=Yes)
    # KCHR-Q4  → Asthma diagnosis (always)
    # KCHR-Q5  → Asthma attack past year (precondition: Q4=Yes)
    # KCHR-Q6  → Wheezing past year (precondition: Q4=Yes)
    # KCHR1-INT→ Comment about long-term conditions (always)
    # KCHR1-Q1 → Long-term condition checklist (always; learning disability
    #             and emotional condition sub-options applicable age >= 6 only,
    #             noted in item title)
    # =========================================================================
    - id: b_child_chronic
      title: "Child Chronic Conditions"
      items:
        # KCHR-Q1: Nose/throat infection frequency (CCK4_1)
        # Only asked for children aged 0-3.
        - id: q_kchr_q1
          kind: Question
          title: "Thinking now about illnesses, how often does [child] have nose or throat infections?"
          precondition:
            - predicate: age <= 3
          input:
            control: Radio
            labels:
              1: "Almost all the time"
              2: "Often"
              3: "From time to time"
              4: "Rarely"
              5: "Never"

        # KCHR-Q2: Ever had ear infection (CCK4_2)
        # No → skip to KCHR-Q4; DK/R → skip to KCHR-Q4.
        # Only asked for children aged 0-3.
        - id: q_kchr_q2
          kind: Question
          title: "Since [his/her] birth, has [he/she] ever had an ear infection (otitis)?"
          precondition:
            - predicate: age <= 3
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # KCHR-Q3: How many times had ear infection (CCK4_3)
        # Only asked when age <= 3 AND Q2=Yes.
        - id: q_kchr_q3
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: age <= 3 and q_kchr_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Once"
              2: "2 times"
              3: "3 times"
              4: "4 or more times"

        # KCHR-Q4: Asthma diagnosis (CCC4_1C)
        # Asked of all children. No/DK/R → skip to KCHR1-INT.
        - id: q_kchr_q4
          kind: Question
          title: "Has [child] ever had asthma that has been diagnosed by a health professional?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # KCHR-Q5: Asthma attack past year (CCC4_C5)
        # Only asked if Q4=Yes.
        - id: q_kchr_q5
          kind: Question
          title: "Has [he/she] had an attack of asthma in the past 12 months?"
          precondition:
            - predicate: q_kchr_q4.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # KCHR-Q6: Wheezing past year (CCC4_C6)
        # Only asked if Q4=Yes.
        - id: q_kchr_q6
          kind: Question
          title: "Has [he/she] had wheezing or whistling in the chest at any time in the past 12 months?"
          precondition:
            - predicate: q_kchr_q4.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # KCHR1-INT: Definition of long-term conditions
        - id: q_kchr1_int
          kind: Comment
          title: "In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more."

        # KCHR1-Q1: Long-term conditions checklist
        # CCK4_1AB / CCC4_1H / CCC4_1K / CCC4_1L / CCC4_1V / CCC4_NON
        # NOTE: Options h (learning disability) and i (emotional/psychological
        # condition) are only applicable for children aged 6 and over. They are
        # included in the checkbox but interviewers should only probe them when
        # age >= 6, as documented in the original questionnaire.
        # Bit assignments (powers of 2):
        #   1   = Allergies
        #   2   = Bronchitis
        #   4   = Heart condition or disease
        #   8   = Epilepsy
        #   16  = Cerebral palsy
        #   32  = Kidney condition or disease
        #   64  = Mental handicap
        #   128 = A learning disability (ask only if age >= 6)
        #   256 = An emotional, psychological or nervous condition (ask only if age >= 6)
        #   512 = Any other long-term condition
        #   1024= None of the above
        - id: q_kchr1_q1
          kind: Question
          title: "Does [child] have any of the following long-term conditions that have been diagnosed by a health professional? (NOTE: Options 'learning disability' and 'emotional/psychological condition' apply only for children aged 6 and over.)"
          input:
            control: Checkbox
            labels:
              1: "Allergies"
              2: "Bronchitis"
              4: "Heart condition or disease"
              8: "Epilepsy"
              16: "Cerebral palsy"
              32: "Kidney condition or disease"
              64: "Mental handicap"
              128: "A learning disability (age 6+ only)"
              256: "An emotional, psychological or nervous condition (age 6+ only)"
              512: "Any other long-term condition"
              1024: "None of the above"

    # =========================================================================
    # BLOCK 4: CHILD HEALTH STATUS (KHS — 32 items)
    # =========================================================================
    # Block precondition: age >= 4 (KHS-C1 filter: age < 4 → skip to Injuries)
    #
    # Vision cascade (Q1–Q5):
    #   Q1 Yes → skip to Q4; No → Q2
    #   Q2 Yes → skip to Q4; No/no glasses → Q3
    #   Q3 (see at all): No → skip to Q6 (hearing)
    #   Q4 Yes → skip to Q6; No → Q5
    #   Q5 (with glasses)
    #
    # Hearing cascade (Q6–Q9):
    #   Q6 Yes → skip to IN2; No → Q7
    #   Q7 Yes → skip to Q8; No/no aid → Q7A
    #   Q7A No → skip to IN2
    #   Q8 Yes → skip to IN2; No → Q9
    #   Q9 (with hearing aid)
    #
    # IN2: comment about age-relative abilities
    #
    # Speech cascade (Q10–Q13):
    #   Q10 Yes → skip to Q14; No → Q11
    #   Q11 (partially with strangers)
    #   Q12 Yes → skip to Q14; No → Q13
    #   Q13 (partially with those who know)
    #
    # Getting Around cascade (Q14–Q20):
    #   Q14 Yes → skip to Q21; No → Q15
    #   Q15 No → skip to Q18; Yes → Q16
    #   Q16 (mechanical support)
    #   Q17 (person help to walk)
    #   Q18 Yes → Q19; No → skip to Q21
    #   Q19 (wheelchair frequency)
    #   Q20 (person help in wheelchair)
    #
    # Hands and Fingers (Q21–Q24):
    #   Q21 Yes → skip to Q25; No → Q22
    #   Q22 No → skip to Q24; Yes → Q23
    #   Q23 (help with tasks)
    #   Q24 (special equipment)
    #
    # Feelings (Q25): Radio 5 options
    # Memory  (Q26): Radio 4 options
    # Thinking (Q27): Radio 5 options
    #
    # Pain (Q28–Q30):
    #   Q28 Yes → skip to Injuries block; No → Q29, Q30
    # =========================================================================
    - id: b_child_health_status
      title: "Child Health Status"
      precondition:
        - predicate: age >= 4
      items:
        # KHS-INT: Interviewer instruction
        - id: q_khs_int
          kind: Comment
          title: "The next set of questions asks about [child's] day-to-day health."

        # KHS-INTA: Interviewer instruction
        - id: q_khs_inta
          kind: Comment
          title: "You may feel that some of these questions do not apply to [child], but it is important that we ask the same questions of everyone."

        # ---- VISION ----

        # KHS-Q1: See words in book without glasses (HSC4_1)
        # Yes → skip to Q4
        - id: q_khs_q1
          kind: Question
          title: "Is [he/she] usually able to see clearly, and without distortion, the words in a book without glasses or contact lenses?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q2: See words in book with glasses (HSC4_2)
        # Asked only if Q1=No (cannot see without glasses).
        # Yes → skip to Q4
        - id: q_khs_q2
          kind: Question
          title: "Is [he/she] usually able to see clearly, and without distortion, the words in a book with glasses or contact lenses?"
          precondition:
            - predicate: q_khs_q1.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"

        # KHS-Q3: Can see at all? (HSC4_3)
        # Asked only when Q1=No and Q2=No or doesn't wear glasses.
        # No → skip to Q6 (Hearing).
        - id: q_khs_q3
          kind: Question
          title: "Is [he/she] able to see at all?"
          precondition:
            - predicate: q_khs_q1.outcome == 2 and q_khs_q2.outcome != 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q4: Recognize friend across street without glasses (HSC4_4)
        # Asked when Q1=Yes OR (Q2=Yes).
        # Q1=Yes → jumped here directly; Q2=Yes → jumped here directly.
        # Yes → skip to Q6 (Hearing).
        - id: q_khs_q4
          kind: Question
          title: "Is [he/she] able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: q_khs_q1.outcome == 1 or q_khs_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q5: Recognize friend across street with glasses (HSC4_5)
        # Asked when Q4=No (cannot recognize without glasses).
        - id: q_khs_q5
          kind: Question
          title: "Is [he/she] usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: (q_khs_q1.outcome == 1 or q_khs_q2.outcome == 1) and q_khs_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"

        # ---- HEARING ----

        # KHS-Q6: Hear group conversation without hearing aid (HSC4_6)
        # Yes → skip to IN2 comment.
        - id: q_khs_q6
          kind: Question
          title: "Is [he/she] usually able to hear what is said in a group conversation with at least 3 other people without a hearing aid?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q7: Hear group conversation with hearing aid (HSC4_7)
        # Asked only when Q6=No.
        # Yes → skip to Q8; No/doesn't wear → Q7A.
        - id: q_khs_q7
          kind: Question
          title: "Is [he/she] usually able to hear what is said in a group conversation with at least 3 other people with a hearing aid?"
          precondition:
            - predicate: q_khs_q6.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"

        # KHS-Q7A: Can hear at all? (HSC4_7A)
        # Asked only when Q6=No and Q7 is not Yes.
        # No → skip to IN2.
        - id: q_khs_q7a
          kind: Question
          title: "Is [he/she] able to hear at all?"
          precondition:
            - predicate: q_khs_q6.outcome == 2 and q_khs_q7.outcome != 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q8: Hear one-on-one in quiet room without hearing aid (HSC4_8)
        # Asked when Q6=No and (Q7=Yes or Q7A=Yes).
        # Yes → skip to IN2.
        - id: q_khs_q8
          kind: Question
          title: "Is [he/she] usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: q_khs_q6.outcome == 2 and (q_khs_q7.outcome == 1 or q_khs_q7a.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q9: Hear one-on-one in quiet room with hearing aid (HSC4_9)
        # Asked when Q8=No.
        - id: q_khs_q9
          kind: Question
          title: "Is [he/she] usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?"
          precondition:
            - predicate: q_khs_q6.outcome == 2 and (q_khs_q7.outcome == 1 or q_khs_q7a.outcome == 1) and q_khs_q8.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"

        # KHS-IN2: Transition comment — age-relative abilities
        - id: q_khs_in2
          kind: Comment
          title: "The next few questions on day-to-day health are concerned with [child's] abilities relative to other children the same age."

        # ---- SPEECH ----

        # KHS-Q10: Understood completely by strangers (HSC4_10)
        # Yes → skip to Q14 (Getting Around).
        - id: q_khs_q10
          kind: Question
          title: "Is [he/she] usually able to be understood completely when speaking with strangers in [his/her] own language?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q11: Understood partially by strangers (HSC4_11)
        # Asked only when Q10=No.
        - id: q_khs_q11
          kind: Question
          title: "Is [he/she] able to be understood partially when speaking with strangers?"
          precondition:
            - predicate: q_khs_q10.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q12: Understood completely by those who know well (HSC4_12)
        # Asked only when Q10=No.
        # Yes → skip to Q14.
        - id: q_khs_q12
          kind: Question
          title: "Is [he/she] able to be understood completely when speaking with those who know [him/her] well?"
          precondition:
            - predicate: q_khs_q10.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q13: Understood partially by those who know well (HSC4_13)
        # Asked only when Q10=No and Q12=No.
        - id: q_khs_q13
          kind: Question
          title: "Is [he/she] able to be understood partially when speaking with those who know [him/her] well?"
          precondition:
            - predicate: q_khs_q10.outcome == 2 and q_khs_q12.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # ---- GETTING AROUND ----

        # KHS-Q14: Walk around neighbourhood without difficulty (HSC4_14)
        # Yes → skip to Q21 (Hands).
        - id: q_khs_q14
          kind: Question
          title: "Is [child] usually able to walk around the neighbourhood without difficulty and without mechanical support?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q15: Able to walk at all? (HSC4_15)
        # Asked when Q14=No.
        # No → skip to Q18.
        - id: q_khs_q15
          kind: Question
          title: "Is [he/she] able to walk at all?"
          precondition:
            - predicate: q_khs_q14.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q16: Requires mechanical support to walk (HSC4_16)
        # Asked when Q14=No and Q15=Yes.
        - id: q_khs_q16
          kind: Question
          title: "Does [he/she] require mechanical support such as braces, a cane or crutches to be able to walk?"
          precondition:
            - predicate: q_khs_q14.outcome == 2 and q_khs_q15.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q17: Requires another person's help to walk (HSC4_17)
        # Asked when Q14=No and Q15=Yes.
        - id: q_khs_q17
          kind: Question
          title: "Does [he/she] require the help of another person to be able to walk?"
          precondition:
            - predicate: q_khs_q14.outcome == 2 and q_khs_q15.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q18: Requires wheelchair to get around (HSC4_18)
        # Asked when Q14=No and Q15=No (cannot walk at all).
        # No → skip to Q21 (Hands).
        - id: q_khs_q18
          kind: Question
          title: "Does [he/she] require a wheelchair to get around?"
          precondition:
            - predicate: q_khs_q14.outcome == 2 and q_khs_q15.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q19: How often uses wheelchair (HSC4_19)
        # Asked when Q18=Yes.
        - id: q_khs_q19
          kind: Question
          title: "How often does [he/she] use a wheelchair?"
          precondition:
            - predicate: q_khs_q14.outcome == 2 and q_khs_q15.outcome == 2 and q_khs_q18.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Never"

        # KHS-Q20: Needs person's help in wheelchair (HSC4_20)
        # Asked when Q18=Yes.
        - id: q_khs_q20
          kind: Question
          title: "Does [he/she] need the help of another person to get around in the wheelchair?"
          precondition:
            - predicate: q_khs_q14.outcome == 2 and q_khs_q15.outcome == 2 and q_khs_q18.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # ---- HANDS AND FINGERS ----

        # KHS-Q21: Grasp and handle small objects (HSC4_21)
        # Yes → skip to Q25 (Feelings).
        - id: q_khs_q21
          kind: Question
          title: "Is [child] usually able to grasp and handle small objects such as a pencil or scissors?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q22: Needs person's help due to hand/finger limitations (HSC4_22)
        # Asked when Q21=No.
        # No → skip to Q24.
        - id: q_khs_q22
          kind: Question
          title: "Does [he/she] require the help of another person because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_khs_q21.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # KHS-Q23: For which tasks needs person's help (HSC4_23)
        # Asked when Q21=No and Q22=Yes.
        - id: q_khs_q23
          kind: Question
          title: "Does [he/she] require the help of another person with:"
          precondition:
            - predicate: q_khs_q21.outcome == 2 and q_khs_q22.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some tasks"
              2: "Most tasks"
              3: "Almost all tasks"
              4: "All tasks"

        # KHS-Q24: Needs special equipment for hand/finger limitations (HSC4_24)
        # Asked when Q21=No (regardless of Q22).
        - id: q_khs_q24
          kind: Question
          title: "Does [he/she] require special equipment because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_khs_q21.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # ---- FEELINGS ----

        # KHS-Q25: Emotional state — feelings (HSC4_25)
        - id: q_khs_q25
          kind: Question
          title: "Would you describe [child] as being usually:"
          input:
            control: Radio
            labels:
              1: "Happy and interested in life"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Unhappy with little interest in life"
              5: "So unhappy that life is not worthwhile"

        # ---- MEMORY ----

        # KHS-Q26: Ability to remember things (HSC4_26)
        - id: q_khs_q26
          kind: Question
          title: "How would you describe [his/her] usual ability to remember things?"
          input:
            control: Radio
            labels:
              1: "Able to remember most things"
              2: "Somewhat forgetful"
              3: "Very forgetful"
              4: "Unable to remember anything at all"

        # ---- THINKING ----

        # KHS-Q27: Ability to think and solve problems (HSC4_27)
        - id: q_khs_q27
          kind: Question
          title: "How would you describe [his/her] usual ability to think and solve day-to-day problems?"
          input:
            control: Radio
            labels:
              1: "Able to think clearly and solve problems"
              2: "Having a little difficulty"
              3: "Having some difficulty"
              4: "Having a great deal of difficulty"
              5: "Unable to think or solve problems"

        # ---- PAIN AND DISCOMFORT ----

        # KHS-Q28: Free of pain or discomfort? (HSC4_28)
        # Yes → skip to Child Injuries block (no further items in this block shown).
        - id: q_khs_q28
          kind: Question
          title: "Is [child] usually free of pain or discomfort?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # KHS-Q29: Usual intensity of pain (HSC4_29)
        # Asked only when Q28=No.
        - id: q_khs_q29
          kind: Question
          title: "How would you describe the usual intensity of [his/her] pain or discomfort?"
          precondition:
            - predicate: q_khs_q28.outcome == 2
          input:
            control: Radio
            labels:
              1: "Mild"
              2: "Moderate"
              3: "Severe"

        # KHS-Q30: Activities prevented by pain (HSC4_30)
        # Asked only when Q28=No.
        - id: q_khs_q30
          kind: Question
          title: "How many activities does [his/her] pain or discomfort prevent?"
          precondition:
            - predicate: q_khs_q28.outcome == 2
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Some"
              4: "Most"

    # =========================================================================
    # BLOCK 5: CHILD INJURIES (KIN — 7 items)
    # =========================================================================
    # KIN-INT  → Comment (always)
    # KIN-Q1   → Injured past 12 months? Switch. No/DK/R → end
    # KIN-Q2   → How many times (precondition: Q1=Yes)
    # KIN-Q3   → Type of most serious injury (precondition: Q1=Yes)
    #            Types 6,7,8,9,11 (Concussion, Poisoning, Internal, Dental,
    #            Multiple injuries) auto-skip Q4 in original — modelled via Q4
    #            precondition.
    # KIN-Q4   → Body part injured (precondition: Q1=Yes and Q3 not in auto-skip set)
    # KIN-Q5   → Location of injury (precondition: Q1=Yes)
    # KIN-Q6   → What happened / cause (precondition: Q1=Yes)
    # =========================================================================
    - id: b_child_injuries
      title: "Child Injuries"
      items:
        # KIN-INT: Interviewer instruction
        - id: q_kin_int
          kind: Comment
          title: "The following questions refer to injuries that occurred in the past 12 months and were serious enough to require medical attention."

        # KIN-Q1: Was child injured? (IJC4_1)
        # No/DK/R → end of questionnaire.
        - id: q_kin_q1
          kind: Question
          title: "In the past 12 months, was [child] injured?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # KIN-Q2: How many times injured? (IJC4_2)
        # Precondition: Q1=Yes.
        - id: q_kin_q2
          kind: Question
          title: "How many times was [he/she] injured?"
          precondition:
            - predicate: q_kin_q1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 30

        # KIN-Q3: Type of most serious injury (IJC4_3)
        # Precondition: Q1=Yes.
        # Types that auto-skip Q4 in original:
        #   6=Concussion, 7=Poisoning, 8=Internal injury, 9=Dental injury,
        #   11=Multiple injuries → GO TO KIN-Q5
        - id: q_kin_q3
          kind: Question
          title: "For the most serious injury, what type of injury did [he/she] have?"
          precondition:
            - predicate: q_kin_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Broken or fractured bones"
              2: "Burn or scald"
              3: "Dislocation"
              4: "Sprain or strain"
              5: "Cut, scrape or bruise"
              6: "Concussion"
              7: "Poisoning"
              8: "Internal injury"
              9: "Dental injury"
              10: "Other (specify)"
              11: "Multiple injuries"

        # KIN-Q4: Body part injured (IJC4_4)
        # Skipped when injury type is one that auto-routes past it:
        #   Concussion(6), Poisoning(7), Internal(8), Dental(9), Multiple(11).
        - id: q_kin_q4
          kind: Question
          title: "What part of [his/her] body was injured?"
          precondition:
            - predicate: q_kin_q1.outcome == 1 and q_kin_q3.outcome not in [6, 7, 8, 9, 11]
          input:
            control: Dropdown
            labels:
              1: "Eyes"
              2: "Face or scalp"
              3: "Head or neck"
              4: "Arms or hands"
              5: "Legs or feet"
              6: "Back or spine"
              7: "Trunk"
              8: "Shoulder"
              9: "Hip or multiple sites"
              11: "Systemic"

        # KIN-Q5: Where did the injury happen? (IJC4_5)
        # Precondition: Q1=Yes (shown regardless of Q3 type).
        - id: q_kin_q5
          kind: Question
          title: "Where did the injury happen?"
          precondition:
            - predicate: q_kin_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Inside own home or apartment"
              2: "Outside home including yard or driveway"
              3: "In or around other private residence"
              4: "Inside school, daycare or grounds"
              5: "Indoor or outdoor sports facility"
              6: "Other public building"
              7: "Sidewalk, street or highway in neighbourhood"
              8: "Other sidewalk, street or highway"
              9: "Playground or park"
              10: "Other (specify)"

        # KIN-Q6: What happened / cause of injury (IJC4_6)
        # Precondition: Q1=Yes.
        # NOTE: The original inventory (line 1242) ends at KIN-Q5. KIN-Q6 is
        # documented in the task specification as a cause-of-injury question
        # consistent with the adult injuries module (INJ-Q6).
        - id: q_kin_q6
          kind: Question
          title: "What happened? For example, was the injury the result of a fall, a motor vehicle accident, a physical assault, etc.?"
          precondition:
            - predicate: q_kin_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Motor vehicle accident"
              2: "Accidental fall"
              3: "Fire, flames or resulting fumes"
              4: "Accidentally struck by object or person"
              5: "Physical assault"
              6: "Accidental injury caused by explosion"
              7: "Accidental injury caused by natural or environmental factors"
              8: "Accidental drowning or submersion"
              9: "Accidental suffocation"
              10: "Hot or corrosive liquids, foods or substances"
              11: "Accident caused by machinery"
              12: "Accident caused by cutting or piercing instruments"
              13: "Accidental poisoning"
              14: "Other (specify)"
