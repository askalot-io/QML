qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Physical Activities and Injuries"
  codeInit: |
    # No cross-section variables read or produced.
    # This section is non-proxy only (asked of the respondent directly).

  blocks:
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
