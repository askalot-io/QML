qmlVersion: '1.0'
questionnaire:
  title: 13 Social Mental Health
  codeInit: |
    # Extern variables from prior sections
    is_proxy: {0, 1}
    # Derived SSA domain flags (computed in q_ssa_q20 codeBlock)
    has_tangible = 0
    has_affection = 0
    has_positive_interaction = 0
    has_emotional_info = 0
    has_any_support = 0
    # HCU professional contact counts (for soft edit cross-checks)
    hcu_q02a: range(0, 366)
    hcu_q02c: range(0, 300)
    hcu_q02d: range(0, 366)
    hcu_q02h: range(0, 366)
    hcu_q02i: range(0, 366)
    # Key symptom counters for sadness path and loss-of-interest path
    sad_symptom_count = 0
    interest_symptom_count = 0
    age: range(12, 120)
  blocks:
  - id: b_social_support_availability
    title: Social Support Availability
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_ssa_intro
      kind: Comment
      title: Next are some questions about the support that is available to you.
    - id: q_ssa_preamble
      kind: Comment
      title: People sometimes look to others for companionship, assistance or other types of support.
    - id: q_ssa_q01
      kind: Question
      title: About how many close friends and close relatives do you have, that is, people you feel at ease with and can talk
        to about what is on your mind?
      postcondition:
      - predicate: q_ssa_q01.outcome <= 20
        hint: 'Warning: more than 20 close friends/relatives reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 99
    - id: q_ssa_q02
      kind: Question
      title: 'How often is each of the following kinds of support available to you if you need it: someone to help you if
        you were confined to bed?'
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q03
      kind: Question
      title: Someone you can count on to listen to you when you need to talk?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q04
      kind: Question
      title: Someone to give you advice about a crisis?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q05
      kind: Question
      title: Someone to take you to the doctor if you needed it?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q06
      kind: Question
      title: Someone who shows you love and affection?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q07
      kind: Question
      title: Someone to have a good time with?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q08
      kind: Question
      title: Someone to give you information in order to help you understand a situation?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q09
      kind: Question
      title: Someone to confide in or talk to about yourself or your problems?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q10
      kind: Question
      title: Someone who hugs you?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q11
      kind: Question
      title: Someone to get together with for relaxation?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q12
      kind: Question
      title: Someone to prepare your meals if you were unable to do it yourself?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q13
      kind: Question
      title: Someone whose advice you really want?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q14
      kind: Question
      title: Someone to do things with to help you get your mind off things?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q15
      kind: Question
      title: Someone to help with daily chores if you were sick?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q16
      kind: Question
      title: Someone to share your most private worries and fears with?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q17
      kind: Question
      title: Someone to turn to for suggestions about how to deal with a personal problem?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q18
      kind: Question
      title: Someone to do something enjoyable with?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q19
      kind: Question
      title: Someone who understands your problems?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_ssa_q20
      kind: Question
      title: Someone to love you and make you feel wanted?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
      codeBlock: |
        # Compute SSA domain flags from item outcomes
        if q_ssa_q02.outcome >= 2 or q_ssa_q05.outcome >= 2 or q_ssa_q12.outcome >= 2 or q_ssa_q15.outcome >= 2:
            has_tangible = 1
        if q_ssa_q06.outcome >= 2 or q_ssa_q10.outcome >= 2 or q_ssa_q20.outcome >= 2:
            has_affection = 1
        if q_ssa_q07.outcome >= 2 or q_ssa_q11.outcome >= 2 or q_ssa_q14.outcome >= 2 or q_ssa_q18.outcome >= 2:
            has_positive_interaction = 1
        if q_ssa_q03.outcome >= 2 or q_ssa_q04.outcome >= 2 or q_ssa_q08.outcome >= 2 or q_ssa_q09.outcome >= 2 or q_ssa_q13.outcome >= 2 or q_ssa_q16.outcome >= 2 or q_ssa_q17.outcome >= 2 or q_ssa_q19.outcome >= 2:
            has_emotional_info = 1
        if has_tangible == 1 or has_affection == 1 or has_positive_interaction == 1 or has_emotional_info == 1:
            has_any_support = 1
  - id: b_social_support_utilization
    title: Social Support Utilization
    precondition:
    - predicate: is_proxy == 0
    - predicate: has_any_support == 1
    items:
    - id: q_ssu_intro
      kind: Comment
      title: You have just mentioned that if you needed support, someone would be available for you. The next questions are
        about the support or help you actually received in the past 12 months.
    - id: q_ssu_q21a
      kind: Question
      title: 'In the past 12 months, did you receive the following support: someone to help you if you were confined to bed,
        to take you to the doctor, to prepare your meals, or to help with daily chores?'
      precondition:
      - predicate: has_tangible == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ssu_q21b
      kind: Question
      title: When you needed it, how often did you receive this kind of support in the past 12 months?
      precondition:
      - predicate: q_ssu_q21a.outcome == 1
      input:
        control: Radio
        labels:
          1: Almost always
          2: Frequently
          3: Half the time
          4: Rarely
          5: Never
    - id: q_ssu_q22a
      kind: Question
      title: 'In the past 12 months, did you receive the following support: someone to show you affection, to hug you, or
        to love you and make you feel wanted?'
      precondition:
      - predicate: has_affection == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ssu_q22b
      kind: Question
      title: When you needed it, how often did you receive this kind of support in the past 12 months?
      precondition:
      - predicate: q_ssu_q22a.outcome == 1
      input:
        control: Radio
        labels:
          1: Almost always
          2: Frequently
          3: Half the time
          4: Rarely
          5: Never
    - id: q_ssu_q23a
      kind: Question
      title: 'In the past 12 months, did you receive the following support: someone to have a good time with, to relax with,
        to do things with, or to do something enjoyable with?'
      precondition:
      - predicate: has_positive_interaction == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ssu_q23b
      kind: Question
      title: When you needed it, how often did you receive this kind of support in the past 12 months?
      precondition:
      - predicate: q_ssu_q23a.outcome == 1
      input:
        control: Radio
        labels:
          1: Almost always
          2: Frequently
          3: Half the time
          4: Rarely
          5: Never
    - id: q_ssu_q24a
      kind: Question
      title: 'In the past 12 months, did you receive the following support: someone to listen to you, to give you advice,
        to give you information, to confide in, to advise you, to share your worries and fears with, to turn to for suggestions,
        or to understand your problems?'
      precondition:
      - predicate: has_emotional_info == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ssu_q24b
      kind: Question
      title: When you needed it, how often did you receive this kind of support in the past 12 months?
      precondition:
      - predicate: q_ssu_q24a.outcome == 1
      input:
        control: Radio
        labels:
          1: Almost always
          2: Frequently
          3: Half the time
          4: Rarely
          5: Never
  - id: b_mental_health_contacts
    title: Contacts with Mental Health Professionals
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_cmh_intro
      kind: Comment
      title: Now some questions about mental and emotional well-being.
    - id: q_cmh_q01k
      kind: Question
      title: In the past 12 months, have you seen, or talked on the telephone, to a health professional about your emotional
        or mental health?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cmh_q01l
      kind: Question
      title: How many times in the past 12 months?
      precondition:
      - predicate: q_cmh_q01k.outcome == 1
      postcondition:
      - predicate: q_cmh_q01l.outcome <= 25
        hint: 'Warning: more than 25 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 1
        max: 366
        right: times
    - id: q_cmh_q01m
      kind: Question
      title: Whom did you see or talk to? (Mark all that apply)
      precondition:
      - predicate: q_cmh_q01k.outcome == 1
      postcondition:
      - predicate: q_cmh_q01m.outcome % 2 == 0 or hcu_q02a > 0
        hint: 'Warning: you reported seeing a family doctor for mental health but previously reported 0 visits to a family
          doctor/GP.'
      - predicate: q_cmh_q01m.outcome % 4 < 2 or hcu_q02c > 0
        hint: 'Warning: you reported seeing a psychiatrist but previously reported 0 visits to other medical doctors.'
      - predicate: q_cmh_q01m.outcome % 8 < 4 or hcu_q02i > 0
        hint: 'Warning: you reported seeing a psychologist for mental health but previously reported 0 visits to a psychologist.'
      - predicate: q_cmh_q01m.outcome % 16 < 8 or hcu_q02d > 0
        hint: 'Warning: you reported seeing a nurse for mental health but previously reported 0 visits to a nurse.'
      - predicate: q_cmh_q01m.outcome % 32 < 16 or hcu_q02h > 0
        hint: 'Warning: you reported seeing a social worker for mental health but previously reported 0 visits to a social
          worker/counsellor.'
      input:
        control: Checkbox
        labels:
          1: Family doctor or general practitioner
          2: Psychiatrist
          4: Psychologist
          8: Nurse
          16: Social worker or counselor
          32: Other
    - id: q_cmh_q01ms
      kind: Question
      title: Please specify the health professional you saw or talked to.
      precondition:
      - predicate: q_cmh_q01k.outcome == 1
      - predicate: q_cmh_q01m.outcome % 64 >= 32
      input:
        control: Textarea
        placeholder: Specify health professional...
        maxLength: 200
  - id: b_distress
    title: Distress
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_dis_intro
      kind: Comment
      title: The following questions deal with feelings you may have had during the past month.
    - id: q_dis_q01a
      kind: Question
      title: During the past month, about how often did you feel tired out for no good reason?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01b
      kind: Question
      title: About how often did you feel nervous?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01c
      kind: Question
      title: About how often did you feel so nervous that nothing could calm you down?
      precondition:
      - predicate: q_dis_q01b.outcome != 5
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01d
      kind: Question
      title: About how often did you feel hopeless?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01e
      kind: Question
      title: About how often did you feel restless or fidgety?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01f
      kind: Question
      title: About how often did you feel so restless you could not sit still?
      precondition:
      - predicate: q_dis_q01e.outcome != 5
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01g
      kind: Question
      title: About how often did you feel sad or depressed?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01h
      kind: Question
      title: About how often did you feel so depressed that nothing could cheer you up?
      precondition:
      - predicate: q_dis_q01g.outcome != 5
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01i
      kind: Question
      title: About how often did you feel that everything was an effort?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01j
      kind: Question
      title: About how often did you feel worthless?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: Some of the time
          4: A little of the time
          5: None of the time
    - id: q_dis_q01k
      kind: Question
      title: Taking them altogether, did these feelings occur more often in the past month than is usual for you, less often
        than usual, or about the same as usual?
      input:
        control: Radio
        labels:
          1: More often
          2: Less often
          3: About the same
          4: Never have had any
    - id: q_dis_q01l
      kind: Question
      title: Is that a lot more, somewhat more, or only a little more often than usual?
      precondition:
      - predicate: q_dis_q01k.outcome == 1
      input:
        control: Radio
        labels:
          1: A lot
          2: Somewhat
          3: A little
    - id: q_dis_q01m
      kind: Question
      title: Is that a lot less, somewhat less, or only a little less often than usual?
      precondition:
      - predicate: q_dis_q01k.outcome == 2
      input:
        control: Radio
        labels:
          1: A lot
          2: Somewhat
          3: A little
    - id: q_dis_q01n
      kind: Question
      title: During the past month, how much did these feelings usually interfere with your life or activities?
      precondition:
      - predicate: q_dis_q01k.outcome in [1, 2, 3]
      input:
        control: Radio
        labels:
          1: A lot
          2: Some
          3: A little
          4: Not at all
  - id: b_depression_sadness
    title: Depression - Sadness Path
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_dep_q02
      kind: Question
      title: During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in
        a row?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_dep_q03
      kind: Question
      title: For the next few questions, please think of the 2-week period during the past 12 months when these feelings were
        the worst. During that time, how long did these feelings usually last?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      input:
        control: Radio
        labels:
          1: All day long
          2: Most of the day
          3: About half of the day
          4: Less than half of a day
    - id: q_dep_q04
      kind: Question
      title: How often did you feel this way during those 2 weeks?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      - predicate: q_dep_q03.outcome in [1, 2]
      input:
        control: Radio
        labels:
          1: Every day
          2: Almost every day
          3: Less often
    - id: q_dep_q05
      kind: Question
      title: During those 2 weeks, did you lose interest in most things?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      - predicate: q_dep_q03.outcome in [1, 2]
      - predicate: q_dep_q04.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q05.outcome == 1:
            sad_symptom_count = sad_symptom_count + 1
    - id: q_dep_q06
      kind: Question
      title: Did you feel tired out or low on energy all of the time?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      - predicate: q_dep_q03.outcome in [1, 2]
      - predicate: q_dep_q04.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q06.outcome == 1:
            sad_symptom_count = sad_symptom_count + 1
    - id: q_dep_q07
      kind: Question
      title: Did you gain weight, lose weight, or stay about the same?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      - predicate: q_dep_q03.outcome in [1, 2]
      - predicate: q_dep_q04.outcome in [1, 2]
      input:
        control: Radio
        labels:
          1: Gained weight
          2: Lost weight
          3: Stayed about the same
          4: Was on a diet
      codeBlock: |
        if q_dep_q07.outcome in [1, 2]:
            sad_symptom_count = sad_symptom_count + 1
    - id: q_dep_q08a
      kind: Question
      title: About how much did you gain or lose?
      precondition:
      - predicate: q_dep_q07.outcome in [1, 2]
      postcondition:
      - predicate: q_dep_q08a.outcome <= 20
        hint: 'Warning: more than 20 units reported. Please confirm.'
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_dep_q08b
      kind: Question
      title: Was that in pounds or in kilograms?
      precondition:
      - predicate: q_dep_q07.outcome in [1, 2]
      input:
        control: Radio
        labels:
          1: Pounds
          2: Kilograms
    - id: q_dep_q09
      kind: Question
      title: Did you have more trouble falling asleep than you usually do?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      - predicate: q_dep_q03.outcome in [1, 2]
      - predicate: q_dep_q04.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q09.outcome == 1:
            sad_symptom_count = sad_symptom_count + 1
    - id: q_dep_q10
      kind: Question
      title: How often did that happen?
      precondition:
      - predicate: q_dep_q09.outcome == 1
      input:
        control: Radio
        labels:
          1: Every night
          2: Nearly every night
          3: Less often
    - id: q_dep_q11
      kind: Question
      title: Did you have a lot more trouble concentrating than usual?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      - predicate: q_dep_q03.outcome in [1, 2]
      - predicate: q_dep_q04.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q11.outcome == 1:
            sad_symptom_count = sad_symptom_count + 1
    - id: q_dep_q12
      kind: Question
      title: At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      - predicate: q_dep_q03.outcome in [1, 2]
      - predicate: q_dep_q04.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q12.outcome == 1:
            sad_symptom_count = sad_symptom_count + 1
    - id: q_dep_q13
      kind: Question
      title: Did you think a lot about death - either your own, someone else's, or death in general?
      precondition:
      - predicate: q_dep_q02.outcome == 1
      - predicate: q_dep_q03.outcome in [1, 2]
      - predicate: q_dep_q04.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q13.outcome == 1:
            sad_symptom_count = sad_symptom_count + 1
    - id: q_dep_q14c
      kind: Comment
      title: Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you were sad, blue,
        or depressed and also had some other symptoms.
      precondition:
      - predicate: sad_symptom_count >= 1
    - id: q_dep_q14
      kind: Question
      title: About how many weeks altogether did you feel this way during the past 12 months?
      precondition:
      - predicate: sad_symptom_count >= 1
      input:
        control: Editbox
        min: 2
        max: 53
        right: weeks
    - id: q_dep_q15
      kind: Question
      title: Think about the last time you felt this way for 2 weeks or more in a row. In what month was that?
      precondition:
      - predicate: sad_symptom_count >= 1
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
  - id: b_depression_interest
    title: Depression - Loss of Interest Path
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_dep_q16
      kind: Question
      title: During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things
        like hobbies, work, or activities that usually give you pleasure?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_dep_q17
      kind: Question
      title: For the next few questions, please think of the 2-week period during the past 12 months when you had the most
        complete loss of interest in things. During that 2-week period, how long did the loss of interest usually last?
      precondition:
      - predicate: q_dep_q16.outcome == 1
      input:
        control: Radio
        labels:
          1: All day long
          2: Most of the day
          3: About half of the day
          4: Less than half of a day
    - id: q_dep_q18
      kind: Question
      title: How often did you feel this way during those 2 weeks?
      precondition:
      - predicate: q_dep_q16.outcome == 1
      - predicate: q_dep_q17.outcome in [1, 2]
      input:
        control: Radio
        labels:
          1: Every day
          2: Almost every day
          3: Less often
    - id: q_dep_q19
      kind: Question
      title: During those 2 weeks, did you feel tired out or low on energy all the time?
      precondition:
      - predicate: q_dep_q16.outcome == 1
      - predicate: q_dep_q17.outcome in [1, 2]
      - predicate: q_dep_q18.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q19.outcome == 1:
            interest_symptom_count = interest_symptom_count + 1
    - id: q_dep_q20
      kind: Question
      title: Did you gain weight, lose weight, or stay about the same?
      precondition:
      - predicate: q_dep_q16.outcome == 1
      - predicate: q_dep_q17.outcome in [1, 2]
      - predicate: q_dep_q18.outcome in [1, 2]
      input:
        control: Radio
        labels:
          1: Gained weight
          2: Lost weight
          3: Stayed about the same
          4: Was on a diet
      codeBlock: |
        if q_dep_q20.outcome in [1, 2]:
            interest_symptom_count = interest_symptom_count + 1
    - id: q_dep_q21a
      kind: Question
      title: About how much did you gain or lose?
      precondition:
      - predicate: q_dep_q20.outcome in [1, 2]
      postcondition:
      - predicate: q_dep_q21a.outcome <= 20
        hint: 'Warning: more than 20 units reported. Please confirm.'
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_dep_q21b
      kind: Question
      title: Was that in pounds or in kilograms?
      precondition:
      - predicate: q_dep_q20.outcome in [1, 2]
      input:
        control: Radio
        labels:
          1: Pounds
          2: Kilograms
    - id: q_dep_q22
      kind: Question
      title: Did you have more trouble falling asleep than you usually do?
      precondition:
      - predicate: q_dep_q16.outcome == 1
      - predicate: q_dep_q17.outcome in [1, 2]
      - predicate: q_dep_q18.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q22.outcome == 1:
            interest_symptom_count = interest_symptom_count + 1
    - id: q_dep_q23
      kind: Question
      title: How often did that happen?
      precondition:
      - predicate: q_dep_q22.outcome == 1
      input:
        control: Radio
        labels:
          1: Every night
          2: Nearly every night
          3: Less often
    - id: q_dep_q24
      kind: Question
      title: Did you have a lot more trouble concentrating than usual?
      precondition:
      - predicate: q_dep_q16.outcome == 1
      - predicate: q_dep_q17.outcome in [1, 2]
      - predicate: q_dep_q18.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q24.outcome == 1:
            interest_symptom_count = interest_symptom_count + 1
    - id: q_dep_q25
      kind: Question
      title: At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?
      precondition:
      - predicate: q_dep_q16.outcome == 1
      - predicate: q_dep_q17.outcome in [1, 2]
      - predicate: q_dep_q18.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q25.outcome == 1:
            interest_symptom_count = interest_symptom_count + 1
    - id: q_dep_q26
      kind: Question
      title: Did you think a lot about death - either your own, someone else's, or death in general?
      precondition:
      - predicate: q_dep_q16.outcome == 1
      - predicate: q_dep_q17.outcome in [1, 2]
      - predicate: q_dep_q18.outcome in [1, 2]
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_dep_q26.outcome == 1:
            interest_symptom_count = interest_symptom_count + 1
    - id: q_dep_q27c
      kind: Comment
      title: Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you lost interest in
        most things and also had some other symptoms.
      precondition:
      - predicate: interest_symptom_count >= 1
    - id: q_dep_q27
      kind: Question
      title: About how many weeks did you feel this way during the past 12 months?
      precondition:
      - predicate: interest_symptom_count >= 1
      input:
        control: Editbox
        min: 2
        max: 53
        right: weeks
    - id: q_dep_q28
      kind: Question
      title: Think about the last time you had 2 weeks in a row when you felt this way. In what month was that?
      precondition:
      - predicate: interest_symptom_count >= 1
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
  - id: b_suicidal_thoughts
    title: Suicidal Thoughts and Attempts
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 15
    items:
    - id: q_sui_intro
      kind: Comment
      title: The following questions relate to the sensitive issue of suicide.
    - id: q_sui_q1
      kind: Question
      title: Have you ever seriously considered committing suicide or taking your own life?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sui_q2
      kind: Question
      title: Has this happened in the past 12 months?
      precondition:
      - predicate: q_sui_q1.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sui_q3
      kind: Question
      title: Have you ever attempted to commit suicide or tried taking your own life?
      precondition:
      - predicate: q_sui_q1.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sui_q4
      kind: Question
      title: Did this happen in the past 12 months?
      precondition:
      - predicate: q_sui_q3.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sui_q5
      kind: Question
      title: Did you see, or talk on the telephone, to a health professional following your attempt to commit suicide?
      precondition:
      - predicate: q_sui_q4.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sui_q6
      kind: Question
      title: Whom did you see or talk to? (Mark all that apply)
      precondition:
      - predicate: q_sui_q5.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Family doctor or general practitioner
          2: Psychiatrist
          4: Psychologist
          8: Nurse
          16: Social worker or counsellor
          32: Religious or spiritual advisor such as a priest, chaplain or rabbi
          64: Teacher or guidance counsellor
          128: Other
