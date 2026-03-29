qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Activities (ACT)"
  codeInit: |
    # Variables READ from prior sections
    child_age = 0       # child's age from demographics section

  blocks:
    # =========================================================================
    # BLOCK 1: EARLY CHILDHOOD PROGRAMS (ACT-I1, ACT-Q1, ACT-Q2A, ACT-Q2B)
    # =========================================================================
    # ACT-I1: Intro for all ages
    # ACT-C1: IF AGE > 5 → skip to Q3A. Modeled as precondition child_age <= 5
    # ACT-Q1: Early childhood programs (age 0-5 only)
    # ACT-Q2A/Q2B: Program details (only if Q1 = YES)
    # =========================================================================
    - id: b_act_early
      title: "Activities - Early Childhood Programs"
      items:
        # ACT-I1: Introduction
        - id: q_act_intro
          kind: Comment
          title: "The next few questions are about this child's interests and activities."

        # ACT-Q1: Early childhood programs (age 0-5 only)
        # ACT-C1 routing: IF AGE > 5 → skip to Q3A
        - id: q_act_q1
          kind: Question
          title: "Does he/she currently attend any nursery school, play group or other early childhood program or activity? (Please do not include child care programs or time spent in elementary school.)"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ACT-Q2A: Program types (only if Q1 = YES)
        - id: q_act_q2a
          kind: Question
          title: "What type(s) of programs or activities? (Mark all that apply.)"
          precondition:
            - predicate: child_age <= 5
            - predicate: q_act_q1.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Nursery school, preschool or kindergarten"
              2: "Play group"
              4: "Drop-in centre"
              8: "Toy library"
              16: "Infant stimulation program"
              32: "Mom and tot program"
              64: "Other"

        # ACT-Q2B: Hours per week in programs
        - id: q_act_q2b
          kind: Question
          title: "For about how many hours a week does he/she attend these in total?"
          precondition:
            - predicate: child_age <= 5
            - predicate: q_act_q1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 60
            right: "hours per week"

    # =========================================================================
    # BLOCK 2: ACTIVITY FREQUENCY (ACT-Q3A through ACT-Q3E)
    # =========================================================================
    # ACT-C3: IF AGE < 4 → skip to behaviour section. Modeled as
    #         precondition child_age >= 4 on this block.
    # ACT-Q3A-Q3C: Activity frequency questions (age 4+)
    # ACT-C3D: Age-variant club question (Q3D1/Q3D2/Q3D3)
    # ACT-Q3E: Computer/video games (age 4+)
    # =========================================================================
    - id: b_act_frequency
      title: "Activities - Activity Frequency"
      precondition:
        - predicate: child_age >= 4
      items:
        # ACT-Q3A: Sports with coaching/instruction
        - id: q_act_q3a
          kind: Question
          title: "In the last 12 months, outside of school hours, how often has the child taken part in any sports which involved coaching or instruction?"
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3B: Unorganized sports/physical activities
        - id: q_act_q3b
          kind: Question
          title: "How often has the child taken part in unorganized sports or physical activities?"
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3C: Lessons in music, dance, art, etc.
        - id: q_act_q3c
          kind: Question
          title: "How often has the child taken lessons or instruction in music, dance, art or other non-sport activities?"
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3D1: Clubs/groups — age 4-5 variant
        # ACT-C3D routing: mutually exclusive by age band
        - id: q_act_q3d1
          kind: Question
          title: "How often has the child taken part in any clubs, groups or community programs with leadership, such as Beavers, Sparks or church groups?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3D2: Clubs/groups — age 6-9 variant
        - id: q_act_q3d2
          kind: Question
          title: "How often has the child taken part in any clubs, groups or community programs with leadership, such as Brownies, Cubs or church groups?"
          precondition:
            - predicate: child_age >= 6 and child_age <= 9
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3D3: Clubs/groups — age 10-11 variant
        - id: q_act_q3d3
          kind: Question
          title: "How often has the child taken part in any clubs, groups or community programs with leadership, such as Boys and Girls Clubs, Scouts, Guides or church groups?"
          precondition:
            - predicate: child_age >= 10 and child_age <= 11
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3E: Computer/video games
        - id: q_act_q3e
          kind: Question
          title: "How often has the child played computer or video games?"
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

    # =========================================================================
    # BLOCK 3: TV AND PLAY (ACT-Q4A, ACT-Q4B, ACT-Q5)
    # =========================================================================
    # Age 4+ (inherits from same routing as block 2)
    # ACT-Q4A: TV days per week; if 0 → skip Q4B
    # ACT-Q4B: TV hours per day (only if Q4A > 0)
    # ACT-Q5: Play alone frequency
    # =========================================================================
    - id: b_act_tv_play
      title: "Activities - TV and Play"
      precondition:
        - predicate: child_age >= 4
      items:
        # ACT-Q4A: TV days per week
        - id: q_act_q4a
          kind: Question
          title: "About how many days a week on average does the child watch T.V. or videos at home?"
          input:
            control: Editbox
            min: 0
            max: 7
            right: "days per week"

        # ACT-Q4B: TV hours per day (only if watches some TV)
        - id: q_act_q4b
          kind: Question
          title: "On those days, how many hours on average does he/she spend watching T.V. or videos?"
          precondition:
            - predicate: q_act_q4a.outcome >= 1
          input:
            control: Editbox
            min: 1
            max: 16
            right: "hours per day"

        # ACT-Q5: Play alone frequency
        - id: q_act_q5
          kind: Question
          title: "How often does he/she play alone (e.g., riding a bike, doing a craft or hobby, playing ball)?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # =========================================================================
    # BLOCK 4: CHORES (ACT-Q6A through ACT-Q6F)
    # =========================================================================
    # ACT-C6: IF AGE < 6 → skip to behaviour; IF AGE 6-9 → skip to Q7A
    # Chores block is for age 10-11 only.
    # =========================================================================
    - id: b_act_chores
      title: "Activities - Chores"
      precondition:
        - predicate: child_age >= 10
        - predicate: child_age <= 11
      items:
        # ACT-Q6A-Q6F: Chores frequency (6 sub-questions, same scale)
        - id: qg_act_q6
          kind: QuestionGroup
          title: "I would like to ask you some questions about his/her responsibilities at home. How often does he/she:"
          questions:
            - "(a) Make his/her own bed?"
            - "(b) Clean his/her own room?"
            - "(c) Pick up after him/herself?"
            - "(d) Help keep shared living areas clean and straight?"
            - "(e) Do routine chores such as mow the lawn, help with dinner, wash dishes, etc.?"
            - "(f) Help manage his/her own time (get up on time, be ready for school, etc.)?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # =========================================================================
    # BLOCK 5: CAMPS (ACT-Q7A, ACT-Q7B, ACT-Q8A, ACT-Q8B)
    # =========================================================================
    # ACT-C6 routing: age 6-9 → Q7A; age 10-11 → Q6A (above) then Q7A
    # Camp questions are for age 6+ only.
    # ACT-Q7A: Overnight camp; if NO → skip to Q8A
    # ACT-Q7B: Camp days (only if Q7A = YES)
    # ACT-Q8A: Day camp; if NO → end
    # ACT-Q8B: Day camp days (only if Q8A = YES)
    # =========================================================================
    - id: b_act_camps
      title: "Activities - Camps"
      precondition:
        - predicate: child_age >= 6
      items:
        # ACT-Q7A: Overnight camp
        - id: q_act_q7a
          kind: Question
          title: "Did the child attend an overnight camp last summer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ACT-Q7B: Overnight camp days (only if Q7A = YES)
        - id: q_act_q7b
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: q_act_q7a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 90
            right: "days"

        # ACT-Q8A: Day camp
        - id: q_act_q8a
          kind: Question
          title: "Last summer, did the child attend a day camp or recreational or skill-building activity that ran for half days or full days (e.g., music program, reading program, athletic program)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ACT-Q8B: Day camp days (only if Q8A = YES)
        - id: q_act_q8b
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: q_act_q8a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 90
            right: "days"
