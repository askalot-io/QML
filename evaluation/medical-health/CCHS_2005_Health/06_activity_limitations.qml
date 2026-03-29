qmlVersion: '1.0'
questionnaire:
  title: 06 Activity Limitations
  codeInit: |
    # Track whether any limitation was reported (for RAC_C5 filter)
    has_difficulty = 0
    has_activity_limitation = 0
    needs_help_or_has_social_difficulty = 0
    # No cross-section extern variables needed for this section
  blocks:
  - id: b_difficulty_limitations
    title: Difficulty and Activity Limitations
    items:
    - id: q_rac_r1
      kind: Comment
      title: The next few questions deal with any current limitations in your daily activities caused by a long-term health
        condition or problem. A 'long-term condition' refers to a condition that is expected to last or has already lasted
        6 months or more.
    - id: q_rac_q1
      kind: Question
      title: Do you have any difficulty hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing
        any similar activities?
      input:
        control: Radio
        labels:
          1: Sometimes
          2: Often
          3: Never
      codeBlock: |
        if q_rac_q1.outcome == 1 or q_rac_q1.outcome == 2:
            has_difficulty = 1
    - id: q_rac_q2a
      kind: Question
      title: Does a long-term physical condition or mental condition or health problem reduce the amount or the kind of activity
        you can do at home?
      input:
        control: Radio
        labels:
          1: Sometimes
          2: Often
          3: Never
      codeBlock: |
        if q_rac_q2a.outcome == 1 or q_rac_q2a.outcome == 2:
            has_activity_limitation = 1
    - id: q_rac_q2b1
      kind: Question
      title: Does a long-term physical condition or mental condition or health problem reduce the amount or the kind of activity
        you can do at school?
      input:
        control: Radio
        labels:
          1: Sometimes
          2: Often
          3: Never
          4: Does not attend school
      codeBlock: |
        if q_rac_q2b1.outcome == 1 or q_rac_q2b1.outcome == 2:
            has_activity_limitation = 1
    - id: q_rac_q2b2
      kind: Question
      title: Does a long-term physical condition or mental condition or health problem reduce the amount or the kind of activity
        you can do at work?
      input:
        control: Radio
        labels:
          1: Sometimes
          2: Often
          3: Never
          4: Does not work at a job
      codeBlock: |
        if q_rac_q2b2.outcome == 1 or q_rac_q2b2.outcome == 2:
            has_activity_limitation = 1
    - id: q_rac_q2c
      kind: Question
      title: Does a long-term physical condition or mental condition or health problem reduce the amount or the kind of activity
        you can do in other activities, for example, transportation or leisure?
      input:
        control: Radio
        labels:
          1: Sometimes
          2: Often
          3: Never
      codeBlock: |
        if q_rac_q2c.outcome == 1 or q_rac_q2c.outcome == 2:
            has_activity_limitation = 1
  - id: b_cause_condition
    title: Cause of Condition
    precondition:
    - predicate: has_difficulty == 1 or has_activity_limitation == 1
    items:
    - id: q_rac_r5
      kind: Comment
      title: You reported that you have difficulty hearing, seeing, communicating, walking, climbing stairs, bending, learning
        or doing any similar activities.
      precondition:
      - predicate: has_difficulty == 1
      - predicate: has_activity_limitation == 0
    - id: q_rac_q5
      kind: Question
      title: Which one of the following is the best description of the cause of this condition?
      input:
        control: Dropdown
        labels:
          1: Accident at home
          2: Motor vehicle accident
          3: Accident at work
          4: Other type of accident
          5: Existed from birth or genetic
          6: Work conditions
          7: Disease or illness
          8: Ageing
          9: Emotional or mental health problem or condition
          10: Use of alcohol or drugs
          11: Other
    - id: q_rac_q5s
      kind: Question
      title: Please specify the cause of the condition.
      precondition:
      - predicate: q_rac_q5.outcome == 11
      input:
        control: Textarea
        placeholder: Specify cause...
        maxLength: 200
    - id: q_rac_q5b1
      kind: Question
      title: Because of your condition or health problem, have you ever experienced discrimination or unfair treatment?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q5b2
      kind: Question
      title: In the past 12 months, how much discrimination or unfair treatment did you experience?
      precondition:
      - predicate: q_rac_q5b1.outcome == 1
      input:
        control: Radio
        labels:
          1: A lot
          2: Some
          3: A little
          4: None at all
  - id: b_need_for_help
    title: Need for Help with Activities
    items:
    - id: q_rac_q6a
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you need the help of another person
        with preparing meals?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q6b1
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you need the help of another person
        with getting to appointments and running errands such as shopping for groceries?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q6c
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you need the help of another person
        with doing everyday housework?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q6d
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you need the help of another person
        with doing heavy household chores such as spring cleaning or yard work?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q6e
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you need the help of another person
        with personal care such as washing, dressing, eating or taking medication?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q6f
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you need the help of another person
        with moving about inside the house?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q6g
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you need the help of another person
        with looking after your personal finances such as making bank transactions or paying bills?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_social_difficulties
    title: Social Difficulties
    items:
    - id: q_rac_q7a
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you have difficulty making new friends
        or maintaining friendships?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q7b
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you have difficulty dealing with
        people you do not know well?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rac_q7c
      kind: Question
      title: Because of any physical condition or mental condition or health problem, do you have difficulty starting and
        maintaining a conversation?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_rac_q6a.outcome == 1 or q_rac_q6b1.outcome == 1 or q_rac_q6c.outcome == 1 or q_rac_q6d.outcome == 1 or q_rac_q6e.outcome == 1 or q_rac_q6f.outcome == 1 or q_rac_q6g.outcome == 1:
            needs_help_or_has_social_difficulty = 1
        if q_rac_q7a.outcome == 1 or q_rac_q7b.outcome == 1 or q_rac_q7c.outcome == 1:
            needs_help_or_has_social_difficulty = 1
  - id: b_reason_difficulties
    title: Reason for Difficulties
    precondition:
    - predicate: needs_help_or_has_social_difficulty == 1
    items:
    - id: q_rac_q8
      kind: Question
      title: Are these difficulties due to your physical health, to your emotional or mental health, to your use of alcohol
        or drugs, or to another reason? (Mark all that apply)
      input:
        control: Checkbox
        labels:
          1: Physical health
          2: Emotional or mental health
          4: Use of alcohol or drugs
          8: Another reason
    - id: q_rac_q8s
      kind: Question
      title: Please specify the other reason for your difficulties.
      precondition:
      - predicate: q_rac_q8.outcome % 16 >= 8
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
  - id: b_bed_days
    title: Bed Days
    items:
    - id: q_twd_intro
      kind: Comment
      title: The next few questions ask about your health during the past 14 days. It is important for you to refer to the
        14-day period from two weeks ago to yesterday.
    - id: q_twd_q1
      kind: Question
      title: During that period, did you stay in bed at all because of illness or injury, including any nights spent as a
        patient in a hospital?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_twd_q2
      kind: Question
      title: How many days did you stay in bed for all or most of the day?
      precondition:
      - predicate: q_twd_q1.outcome == 1
      postcondition:
      - predicate: q_twd_q2.outcome >= 0
        hint: Number of days cannot be negative.
      - predicate: q_twd_q2.outcome <= 14
        hint: Number of bed days cannot exceed 14.
      input:
        control: Editbox
        min: 0
        max: 14
        right: days
    - id: q_twd_q2a
      kind: Question
      title: Was that due to your emotional or mental health or your use of alcohol or drugs?
      precondition:
      - predicate: q_twd_q1.outcome == 1
      - predicate: q_twd_q2.outcome <= 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_twd_q2b
      kind: Question
      title: How many of these days were due to your emotional or mental health or your use of alcohol or drugs?
      precondition:
      - predicate: q_twd_q1.outcome == 1
      - predicate: q_twd_q2.outcome > 1
      postcondition:
      - predicate: q_twd_q2b.outcome <= q_twd_q2.outcome
        hint: Days due to emotional/mental health cannot exceed total bed days.
      input:
        control: Editbox
        min: 0
        max: 14
        right: days
  - id: b_cutdown_days
    title: Cut-Down Days
    precondition:
    - predicate: q_twd_q1.outcome == 0 or (q_twd_q1.outcome == 1 and q_twd_q2.outcome < 14)
    items:
    - id: q_twd_q3
      kind: Question
      title: During those 14 days, were there any days that you cut down on things you normally do because of illness or injury?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_twd_q4
      kind: Question
      title: How many days did you cut down on things for all or most of the day?
      precondition:
      - predicate: q_twd_q3.outcome == 1
      postcondition:
      - predicate: q_twd_q4.outcome >= 0
        hint: Number of days cannot be negative.
      - predicate: q_twd_q4.outcome <= 14
        hint: Cut-down days cannot exceed 14.
      input:
        control: Editbox
        min: 0
        max: 14
        right: days
    - id: q_twd_q4a
      kind: Question
      title: Was that due to your emotional or mental health or your use of alcohol or drugs?
      precondition:
      - predicate: q_twd_q3.outcome == 1
      - predicate: q_twd_q4.outcome <= 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_twd_q4b
      kind: Question
      title: How many of these days were due to your emotional or mental health or your use of alcohol or drugs?
      precondition:
      - predicate: q_twd_q3.outcome == 1
      - predicate: q_twd_q4.outcome > 1
      postcondition:
      - predicate: q_twd_q4b.outcome <= q_twd_q4.outcome
        hint: Days due to emotional/mental health cannot exceed total cut-down days.
      input:
        control: Editbox
        min: 0
        max: 14
        right: days
  - id: b_extra_effort
    title: Extra Effort Days
    precondition:
    - predicate: q_twd_q1.outcome == 0 or (q_twd_q1.outcome == 1 and q_twd_q2.outcome < 14)
    items:
    - id: q_twd_q5
      kind: Question
      title: During those 14 days, were there any days when it took extra effort to perform up to your usual level at work
        or at your other daily activities, because of illness or injury?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_twd_q6
      kind: Question
      title: How many days required extra effort?
      precondition:
      - predicate: q_twd_q5.outcome == 1
      postcondition:
      - predicate: q_twd_q6.outcome >= 0
        hint: Number of days cannot be negative.
      - predicate: q_twd_q6.outcome <= 14
        hint: Extra effort days cannot exceed 14.
      input:
        control: Editbox
        min: 0
        max: 14
        right: days
    - id: q_twd_q6a
      kind: Question
      title: Was that due to your emotional or mental health or your use of alcohol or drugs?
      precondition:
      - predicate: q_twd_q5.outcome == 1
      - predicate: q_twd_q6.outcome <= 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_twd_q6b
      kind: Question
      title: How many of these days were due to your emotional or mental health or your use of alcohol or drugs?
      precondition:
      - predicate: q_twd_q5.outcome == 1
      - predicate: q_twd_q6.outcome > 1
      postcondition:
      - predicate: q_twd_q6b.outcome <= q_twd_q6.outcome
        hint: Days due to emotional/mental health cannot exceed total extra effort days.
      input:
        control: Editbox
        min: 0
        max: 14
        right: days
