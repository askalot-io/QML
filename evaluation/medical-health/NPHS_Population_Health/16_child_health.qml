qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Child Health Component (Appendix A, Form H06)"
  codeInit: |
    # Extern variable from household section
    age: range(0, 120)

  blocks:
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
