qmlVersion: '1.0'
questionnaire:
  title: 14 Health Status
  codeInit: |
    # Extern variables from earlier sections
    age: range(12, 120)
    sex: {1, 2}
    is_proxy: {0, 1}
  blocks:
  - id: b_hui
    title: Health Utilities Index
    items:
    - id: q_hui_qint1
      kind: Comment
      title: The next set of questions asks about your day-to-day health. We would like you to think about your ability, in
        general, to do things, not just your ability on a good day or a bad day.
    - id: q_hui_q01
      kind: Question
      title: Are you usually able to see well enough to read ordinary newsprint without glasses or contact lenses?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q02
      kind: Question
      title: Are you usually able to see well enough to read ordinary newsprint with glasses or contact lenses?
      precondition:
      - predicate: q_hui_q01.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q03
      kind: Question
      title: Are you able to see at all?
      precondition:
      - predicate: q_hui_q01.outcome == 0
      - predicate: q_hui_q02.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q04
      kind: Question
      title: Are you able to see well enough to recognize a friend on the other side of the street without glasses or contact
        lenses?
      precondition:
      - predicate: q_hui_q01.outcome == 1 or q_hui_q02.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q05
      kind: Question
      title: Are you usually able to see well enough to recognize a friend on the other side of the street with glasses or
        contact lenses?
      precondition:
      - predicate: q_hui_q01.outcome == 1 or q_hui_q02.outcome == 1
      - predicate: q_hui_q04.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q06
      kind: Question
      title: Are you usually able to hear what is said in a group conversation with at least 3 other people without a hearing
        aid?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q07
      kind: Question
      title: Are you usually able to hear what is said in a group conversation with at least 3 other people with a hearing
        aid?
      precondition:
      - predicate: q_hui_q06.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q07a
      kind: Question
      title: Are you able to hear at all?
      precondition:
      - predicate: q_hui_q06.outcome == 0
      - predicate: q_hui_q07.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q08
      kind: Question
      title: Are you usually able to hear what is said in a conversation with one other person in a quiet room without a hearing
        aid?
      precondition:
      - predicate: q_hui_q06.outcome == 0
      - predicate: q_hui_q07.outcome == 1 or q_hui_q07a.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q09
      kind: Question
      title: Are you usually able to hear what is said in a conversation with one other person in a quiet room with a hearing
        aid?
      precondition:
      - predicate: q_hui_q06.outcome == 0
      - predicate: q_hui_q07.outcome == 1 or q_hui_q07a.outcome == 1
      - predicate: q_hui_q08.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q10
      kind: Question
      title: Are you usually able to be understood completely when speaking with strangers in your own language?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q11
      kind: Question
      title: Are you able to be understood partially when speaking with strangers?
      precondition:
      - predicate: q_hui_q10.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q12
      kind: Question
      title: Are you able to be understood completely when speaking with those who know you well?
      precondition:
      - predicate: q_hui_q10.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q13
      kind: Question
      title: Are you able to be understood partially when speaking with those who know you well?
      precondition:
      - predicate: q_hui_q10.outcome == 0
      - predicate: q_hui_q12.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q14
      kind: Question
      title: Are you usually able to walk around the neighbourhood without difficulty and without mechanical support such
        as braces, a cane or crutches?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q15
      kind: Question
      title: Are you able to walk at all?
      precondition:
      - predicate: q_hui_q14.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q16
      kind: Question
      title: Do you require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?
      precondition:
      - predicate: q_hui_q14.outcome == 0
      - predicate: q_hui_q15.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q17
      kind: Question
      title: Do you require the help of another person to be able to walk?
      precondition:
      - predicate: q_hui_q14.outcome == 0
      - predicate: q_hui_q15.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q18
      kind: Question
      title: Do you require a wheelchair to get around?
      precondition:
      - predicate: q_hui_q14.outcome == 0
      - predicate: q_hui_q15.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q19
      kind: Question
      title: How often do you use a wheelchair?
      precondition:
      - predicate: q_hui_q14.outcome == 0
      - predicate: q_hui_q15.outcome == 0
      - predicate: q_hui_q18.outcome == 1
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Never
    - id: q_hui_q20
      kind: Question
      title: Do you need the help of another person to get around in the wheelchair?
      precondition:
      - predicate: q_hui_q14.outcome == 0
      - predicate: q_hui_q15.outcome == 0
      - predicate: q_hui_q18.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q21
      kind: Question
      title: Are you usually able to grasp and handle small objects such as a pencil or scissors?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q22
      kind: Question
      title: Do you require the help of another person because of limitations in the use of hands or fingers?
      precondition:
      - predicate: q_hui_q21.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q23
      kind: Question
      title: 'Do you require the help of another person with:'
      precondition:
      - predicate: q_hui_q21.outcome == 0
      - predicate: q_hui_q22.outcome == 1
      input:
        control: Radio
        labels:
          1: Some tasks
          2: Most tasks
          3: Almost all tasks
          4: All tasks
    - id: q_hui_q24
      kind: Question
      title: Do you require special equipment, for example, devices to assist in dressing, because of limitations in the use
        of hands or fingers?
      precondition:
      - predicate: q_hui_q21.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q25
      kind: Question
      title: 'Would you describe yourself as being usually:'
      input:
        control: Radio
        labels:
          1: Happy and interested in life
          2: Somewhat happy
          3: Somewhat unhappy
          4: Unhappy with little interest in life
          5: So unhappy that life is not worthwhile
    - id: q_hui_q26
      kind: Question
      title: How would you describe your usual ability to remember things?
      input:
        control: Radio
        labels:
          1: Able to remember most things
          2: Somewhat forgetful
          3: Very forgetful
          4: Unable to remember anything at all
    - id: q_hui_q27
      kind: Question
      title: How would you describe your usual ability to think and solve day-to-day problems?
      input:
        control: Radio
        labels:
          1: Able to think clearly and solve problems
          2: Having a little difficulty
          3: Having some difficulty
          4: Having a great deal of difficulty
          5: Unable to think or solve problems
    - id: q_hui_q28
      kind: Question
      title: Are you usually free of pain or discomfort?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hui_q29
      kind: Question
      title: How would you describe the usual intensity of your pain or discomfort?
      precondition:
      - predicate: q_hui_q28.outcome == 0
      input:
        control: Radio
        labels:
          1: Mild
          2: Moderate
          3: Severe
    - id: q_hui_q30
      kind: Question
      title: How many activities does your pain or discomfort prevent?
      precondition:
      - predicate: q_hui_q28.outcome == 0
      input:
        control: Radio
        labels:
          1: None
          2: A few
          3: Some
          4: Most
  - id: b_sf36
    title: SF-36 Health Status
    items:
    - id: q_sfr_r03a
      kind: Comment
      title: Although some of the following questions may seem repetitive, the next section deals with another way of measuring
        health status.
    - id: q_sfr_r03b
      kind: Comment
      title: The questions are about how you feel and how well you are able to do your usual activities.
    - id: q_sfr_q03
      kind: Question
      title: Does your health limit you in vigorous activities, such as running, lifting heavy objects, or participating in
        strenuous sports?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q04
      kind: Question
      title: Does your health limit you in moderate activities, such as moving a table, pushing a vacuum cleaner, bowling,
        or playing golf?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q05
      kind: Question
      title: Does your health limit you in lifting or carrying groceries?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q06
      kind: Question
      title: Does your health limit you in climbing several flights of stairs?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q07
      kind: Question
      title: Does your health limit you in climbing one flight of stairs?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q08
      kind: Question
      title: Does your health limit you in bending, kneeling, or stooping?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q09
      kind: Question
      title: Does your health limit you in walking more than one kilometre?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q10
      kind: Question
      title: Does your health limit you in walking several blocks?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q11
      kind: Question
      title: Does your health limit you in walking one block?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q12
      kind: Question
      title: Does your health limit you in bathing and dressing yourself?
      input:
        control: Radio
        labels:
          1: Limited a lot
          2: Limited a little
          3: Not at all limited
    - id: q_sfr_q13
      kind: Question
      title: Because of your physical health, during the past 4 weeks, did you cut down on the amount of time you spent on
        work or other activities?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sfr_q14
      kind: Question
      title: Because of your physical health, during the past 4 weeks, did you accomplish less than you would like?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sfr_q15
      kind: Question
      title: Because of your physical health, during the past 4 weeks, were you limited in the kind of work or other activities?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sfr_q16
      kind: Question
      title: Because of your physical health, during the past 4 weeks, did you have difficulty performing the work or other
        activities (for example, it took extra effort)?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sfr_q17
      kind: Question
      title: Because of emotional problems, during the past 4 weeks, did you cut down on the amount of time you spent on work
        or other activities?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sfr_q18
      kind: Question
      title: Because of emotional problems, during the past 4 weeks, did you accomplish less than you would like?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sfr_q19
      kind: Question
      title: Because of emotional problems, during the past 4 weeks, did you not do work or other activities as carefully
        as usual?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sfr_q20
      kind: Question
      title: During the past 4 weeks, how much has your physical health or emotional problems interfered with your normal
        social activities with family, friends, neighbours, or groups?
      input:
        control: Radio
        labels:
          1: Not at all
          2: A little bit
          3: Moderately
          4: Quite a bit
          5: Extremely
    - id: q_sfr_q21
      kind: Question
      title: During the past 4 weeks, how much bodily pain have you had?
      input:
        control: Radio
        labels:
          1: None
          2: Very mild
          3: Mild
          4: Moderate
          5: Severe
          6: Very severe
    - id: q_sfr_q22
      kind: Question
      title: During the past 4 weeks, how much did pain interfere with your normal work (including work both outside the home
        and housework)?
      input:
        control: Radio
        labels:
          1: Not at all
          2: A little bit
          3: Moderately
          4: Quite a bit
          5: Extremely
    - id: q_sfr_r23
      kind: Comment
      title: The next questions are about how you felt and how things have been with you during the past 4 weeks.
    - id: q_sfr_q23
      kind: Question
      title: During the past 4 weeks, how much of the time did you feel full of pep?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q24
      kind: Question
      title: During the past 4 weeks, how much of the time have you been a very nervous person?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q25
      kind: Question
      title: During the past 4 weeks, how much of the time have you felt so down in the dumps that nothing could cheer you
        up?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q26
      kind: Question
      title: During the past 4 weeks, how much of the time have you felt calm and peaceful?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q27
      kind: Question
      title: During the past 4 weeks, how much of the time did you have a lot of energy?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q28
      kind: Question
      title: During the past 4 weeks, how much of the time have you felt downhearted and blue?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q29
      kind: Question
      title: During the past 4 weeks, how much of the time did you feel worn out?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q30
      kind: Question
      title: During the past 4 weeks, how much of the time have you been a happy person?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q31
      kind: Question
      title: During the past 4 weeks, how much of the time did you feel tired?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q32
      kind: Question
      title: During the past 4 weeks, how much of the time has your health limited your social activities (such as visiting
        with friends or close relatives)?
      input:
        control: Radio
        labels:
          1: All of the time
          2: Most of the time
          3: A good bit of the time
          4: Some of the time
          5: A little of the time
          6: None of the time
    - id: q_sfr_q33
      kind: Question
      title: I seem to get sick a little easier than other people. How true or false is this for you?
      input:
        control: Radio
        labels:
          1: Definitely true
          2: Mostly true
          3: Not sure
          4: Mostly false
          5: Definitely false
    - id: q_sfr_q34
      kind: Question
      title: I am as healthy as anybody I know. How true or false is this for you?
      input:
        control: Radio
        labels:
          1: Definitely true
          2: Mostly true
          3: Not sure
          4: Mostly false
          5: Definitely false
    - id: q_sfr_q35
      kind: Question
      title: I expect my health to get worse. How true or false is this for you?
      input:
        control: Radio
        labels:
          1: Definitely true
          2: Mostly true
          3: Not sure
          4: Mostly false
          5: Definitely false
    - id: q_sfr_q36
      kind: Question
      title: My health is excellent. How true or false is this for you?
      input:
        control: Radio
        labels:
          1: Definitely true
          2: Mostly true
          3: Not sure
          4: Mostly false
          5: Definitely false
