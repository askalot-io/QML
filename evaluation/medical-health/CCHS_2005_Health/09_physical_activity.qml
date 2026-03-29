qmlVersion: '1.0'
questionnaire:
  title: 09 Physical Activity
  codeInit: |
    # Extern: proxy status from earlier sections
    is_proxy: {0, 1}
    # Extern: age from earlier sections
    age: range(12, 120)
  blocks:
  - id: b_leisure_activity
    title: Leisure Physical Activities
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_pac_r1
      kind: Comment
      title: Now I'd like to ask you about some of your physical activities. To begin with, I'll be dealing with physical
        activities not related to work, that is, leisure time activities.
    - id: q_pac_q1
      kind: Question
      title: Have you done any of the following in the past 3 months?
      postcondition:
      - predicate: q_pac_q1.outcome < 4194304 or q_pac_q1.outcome == 4194304
        hint: You cannot select 'No physical activity' together with another activity.
      input:
        control: Checkbox
        labels:
          1: Walking for exercise
          2: Gardening or yard work
          4: Swimming
          8: Bicycling
          16: Popular or social dance
          32: Home exercises
          64: Ice hockey
          128: Ice skating
          256: In-line skating or rollerblading
          512: Jogging or running
          1024: Golfing
          2048: Exercise class or aerobics
          4096: Downhill skiing or snowboarding
          8192: Bowling
          16384: Baseball or softball
          32768: Tennis
          65536: Weight-training
          131072: Fishing
          262144: Volleyball
          524288: Basketball
          1048576: Soccer
          2097152: Any other
          4194304: No physical activity
    - id: q_pac_q1vs
      kind: Question
      title: What was this activity?
      precondition:
      - predicate: q_pac_q1.outcome % 4194304 >= 2097152
      input:
        control: Textarea
        placeholder: Describe the activity...
        maxLength: 80
    - id: q_pac_q1x
      kind: Question
      title: In the past 3 months, did you do any other physical activity for leisure?
      precondition:
      - predicate: q_pac_q1.outcome % 4194304 >= 2097152
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_pac_q1xs
      kind: Question
      title: What was this activity?
      precondition:
      - predicate: q_pac_q1x.outcome == 1
      input:
        control: Textarea
        placeholder: Describe the activity...
        maxLength: 80
    - id: q_pac_q1y
      kind: Question
      title: In the past 3 months, did you do any other physical activity for leisure?
      precondition:
      - predicate: q_pac_q1x.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_pac_q1ys
      kind: Question
      title: What was this activity?
      precondition:
      - predicate: q_pac_q1y.outcome == 1
      input:
        control: Textarea
        placeholder: Describe the activity...
        maxLength: 80
    - id: q_pac_q2
      kind: Question
      title: 'In the past 3 months, how many times did you participate in the identified activity? (NOTE: In the original
        questionnaire this repeats for each activity selected above.)'
      precondition:
      - predicate: q_pac_q1.outcome > 0 and q_pac_q1.outcome != 4194304
      input:
        control: Editbox
        min: 1
        max: 270
    - id: q_pac_q3
      kind: Question
      title: 'About how much time did you spend on each occasion? (NOTE: In the original questionnaire this repeats for each
        activity selected above.)'
      precondition:
      - predicate: q_pac_q1.outcome > 0 and q_pac_q1.outcome != 4194304
      input:
        control: Radio
        labels:
          1: 1 to 15 minutes
          2: 16 to 30 minutes
          3: 31 to 60 minutes
          4: More than one hour
  - id: b_work_activity
    title: Work and Daily Physical Activity
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_pac_r2
      kind: Comment
      title: Next, some questions about the amount of time you spent in the past 3 months on physical activity at work or
        while doing daily chores around the house, but not leisure time activity.
    - id: q_pac_q4a
      kind: Question
      title: In a typical week in the past 3 months, how many hours did you usually spend walking to work or to school or
        while doing errands?
      input:
        control: Radio
        labels:
          1: None
          2: Less than 1 hour
          3: From 1 to 5 hours
          4: From 6 to 10 hours
          5: From 11 to 20 hours
          6: More than 20 hours
    - id: q_pac_q4b
      kind: Question
      title: In a typical week in the past 3 months, how many hours did you usually spend bicycling to work or to school or
        while doing errands?
      input:
        control: Radio
        labels:
          1: None
          2: Less than 1 hour
          3: From 1 to 5 hours
          4: From 6 to 10 hours
          5: From 11 to 20 hours
          6: More than 20 hours
    - id: q_pac_q6
      kind: Question
      title: Thinking back over the past 3 months, which of the following best describes your usual daily activities or work
        habits?
      input:
        control: Radio
        labels:
          1: Usually sit during the day and don't walk around very much
          2: Stand or walk quite a lot during the day but don't have to carry or lift things very often
          3: Usually lift or carry light loads, or have to climb stairs or hills often
          4: Do heavy work or carry very heavy loads
  - id: b_sedentary
    title: Sedentary Activities
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_sac_r1
      kind: Comment
      title: Now, a few additional questions about activities you do in your leisure time, that is, activities not at work
        or at school.
    - id: q_sac_q1
      kind: Question
      title: In a typical week in the past 3 months, how much time did you usually spend on a computer, including playing
        computer games and using the Internet?
      input:
        control: Radio
        labels:
          1: None
          2: Less than 1 hour
          3: From 1 to 2 hours
          4: From 3 to 5 hours
          5: From 6 to 10 hours
          6: From 11 to 14 hours
          7: From 15 to 20 hours
          8: More than 20 hours
    - id: q_sac_q2
      kind: Question
      title: In a typical week in the past 3 months, how much time did you usually spend playing video games, such as XBOX,
        Nintendo and Playstation?
      precondition:
      - predicate: age <= 19
      input:
        control: Radio
        labels:
          1: None
          2: Less than 1 hour
          3: From 1 to 2 hours
          4: From 3 to 5 hours
          5: From 6 to 10 hours
          6: From 11 to 14 hours
          7: From 15 to 20 hours
          8: More than 20 hours
    - id: q_sac_q3
      kind: Question
      title: In a typical week in the past 3 months, how much time did you usually spend watching television or videos?
      input:
        control: Radio
        labels:
          1: None
          2: Less than 1 hour
          3: From 1 to 2 hours
          4: From 3 to 5 hours
          5: From 6 to 10 hours
          6: From 11 to 14 hours
          7: From 15 to 20 hours
          8: More than 20 hours
    - id: q_sac_q4
      kind: Question
      title: In a typical week in the past 3 months, how much time did you usually spend reading, not counting at work or
        at school?
      input:
        control: Radio
        labels:
          1: None
          2: Less than 1 hour
          3: From 1 to 2 hours
          4: From 3 to 5 hours
          5: From 6 to 10 hours
          6: From 11 to 14 hours
          7: From 15 to 20 hours
          8: More than 20 hours
  - id: b_protective_equipment
    title: Use of Protective Equipment
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_upe_intro
      kind: Comment
      title: Now a few questions about precautions you take while participating in physical activities.
      precondition:
      - predicate: q_pac_q1.outcome % 16 >= 8 or q_pac_q1.outcome % 512 >= 256 or q_pac_q1.outcome % 8192 >= 4096 or (q_pac_q4b.outcome >= 2 and q_pac_q4b.outcome <= 6)
    - id: q_upe_q1
      kind: Question
      title: When riding a bicycle, how often do you wear a helmet?
      precondition:
      - predicate: q_pac_q1.outcome % 16 >= 8 or (q_pac_q4b.outcome >= 2 and q_pac_q4b.outcome <= 6)
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q2a
      kind: Question
      title: When in-line skating or rollerblading, how often do you wear a helmet?
      precondition:
      - predicate: q_pac_q1.outcome % 512 >= 256
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q2b
      kind: Question
      title: How often do you wear wrist guards or wrist protectors?
      precondition:
      - predicate: q_pac_q1.outcome % 512 >= 256
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q2c
      kind: Question
      title: How often do you wear elbow pads?
      precondition:
      - predicate: q_pac_q1.outcome % 512 >= 256
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q3a
      kind: Question
      title: 'Earlier, you mentioned going downhill skiing or snowboarding in the past 3 months. Was that:'
      precondition:
      - predicate: q_pac_q1.outcome % 8192 >= 4096
      input:
        control: Radio
        labels:
          1: Downhill skiing only
          2: Snowboarding only
          3: Both
    - id: q_upe_q3b
      kind: Question
      title: In the past 12 months, did you do any downhill skiing or snowboarding?
      precondition:
      - predicate: q_pac_q1.outcome % 8192 < 4096
      input:
        control: Radio
        labels:
          1: Downhill skiing only
          2: Snowboarding only
          3: Both
          4: Neither
    - id: q_upe_q4a
      kind: Question
      title: When downhill skiing, how often do you wear a helmet?
      precondition:
      - predicate: q_upe_q3a.outcome == 1 or q_upe_q3a.outcome == 3 or q_upe_q3b.outcome == 1 or q_upe_q3b.outcome == 3
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q5a
      kind: Question
      title: When snowboarding, how often do you wear a helmet?
      precondition:
      - predicate: q_upe_q3a.outcome == 2 or q_upe_q3a.outcome == 3 or q_upe_q3b.outcome == 2 or q_upe_q3b.outcome == 3
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q5b
      kind: Question
      title: How often do you wear wrist guards or wrist protectors?
      precondition:
      - predicate: q_upe_q3a.outcome == 2 or q_upe_q3a.outcome == 3 or q_upe_q3b.outcome == 2 or q_upe_q3b.outcome == 3
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q6
      kind: Question
      title: In the past 12 months, have you done any skateboarding?
      precondition:
      - predicate: age >= 12
      - predicate: age <= 19
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_upe_q6a
      kind: Question
      title: How often do you wear a helmet?
      precondition:
      - predicate: q_upe_q6.outcome == 1
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q6b
      kind: Question
      title: How often do you wear wrist guards or wrist protectors?
      precondition:
      - predicate: q_upe_q6.outcome == 1
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
    - id: q_upe_q6c
      kind: Question
      title: How often do you wear elbow pads?
      precondition:
      - predicate: q_upe_q6.outcome == 1
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Rarely
          4: Never
