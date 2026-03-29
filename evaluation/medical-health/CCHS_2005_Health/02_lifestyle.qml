qmlVersion: '1.0'
questionnaire:
  title: 02 Lifestyle
  codeInit: |
    # Extern variables from prior sections
    is_proxy: {0, 1}
  blocks:
  - id: b_voluntary_orgs
    title: Voluntary Organizations
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_org_member
      kind: Question
      title: Are you a member of any voluntary organizations or associations such as school groups, church social groups,
        community centres, ethnic associations or social, civic or fraternal clubs?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_org_frequency
      kind: Question
      title: How often did you participate in meetings or activities of these groups in the past 12 months? If you belong
        to many, just think of the ones in which you are most active.
      precondition:
      - predicate: q_org_member.outcome == 1
      input:
        control: Radio
        labels:
          1: At least once a week
          2: At least once a month
          3: At least 3 or 4 times a year
          4: At least once a year
          5: Not at all
  - id: b_sleep
    title: Sleep
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_slp_duration
      kind: Question
      title: Now a few questions about sleep. How long do you usually spend sleeping each night? (Do not include time spent
        resting.)
      input:
        control: Dropdown
        labels:
          1: Under 2 hours
          2: 2 hours to less than 3 hours
          3: 3 hours to less than 4 hours
          4: 4 hours to less than 5 hours
          5: 5 hours to less than 6 hours
          6: 6 hours to less than 7 hours
          7: 7 hours to less than 8 hours
          8: 8 hours to less than 9 hours
          9: 9 hours to less than 10 hours
          10: 10 hours to less than 11 hours
          11: 11 hours to less than 12 hours
          12: 12 hours or more
    - id: q_slp_trouble
      kind: Question
      title: How often do you have trouble going to sleep or staying asleep?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_slp_refreshing
      kind: Question
      title: How often do you find your sleep refreshing?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
    - id: q_slp_stay_awake
      kind: Question
      title: How often do you find it difficult to stay awake when you want to?
      input:
        control: Radio
        labels:
          1: None of the time
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
  - id: b_changes_health
    title: Changes Made to Improve Health
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_cih_did_improve
      kind: Question
      title: Next, some questions about changes made to improve health. In the past 12 months, did you do anything to improve
        your health? (For example, lost weight, quit smoking, increased exercise)
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cih_change_made
      kind: Question
      title: What is the single most important change you have made?
      precondition:
      - predicate: q_cih_did_improve.outcome == 1
      input:
        control: Radio
        labels:
          1: Increased exercise, sports / physical activity
          2: Lost weight
          3: Changed diet / improved eating habits
          4: Quit smoking / reduced amount smoked
          5: Drank less alcohol
          6: Reduced stress level
          7: Received medical treatment
          8: Took vitamins
          9: Other
    - id: q_cih_change_made_other
      kind: Question
      title: 'Please specify the most important change you have made:'
      precondition:
      - predicate: q_cih_change_made.outcome == 9
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 80
    - id: q_cih_should_improve
      kind: Question
      title: Do you think there is anything you should do to improve your physical health?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cih_important_thing
      kind: Question
      title: What is the most important thing?
      precondition:
      - predicate: q_cih_should_improve.outcome == 1
      input:
        control: Radio
        labels:
          1: Start / Increase exercise, sports / physical activity
          2: Lose weight
          3: Change diet / improve eating habits
          4: Quit smoking / reduce amount smoked
          5: Drink less alcohol
          6: Reduce stress level
          7: Receive medical treatment
          8: Take vitamins
          9: Other
    - id: q_cih_important_thing_other
      kind: Question
      title: 'Please specify the most important thing:'
      precondition:
      - predicate: q_cih_important_thing.outcome == 9
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 80
    - id: q_cih_barrier
      kind: Question
      title: Is there anything stopping you from making this improvement?
      precondition:
      - predicate: q_cih_should_improve.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cih_barrier_reasons
      kind: Question
      title: What is that? (Mark all that apply)
      precondition:
      - predicate: q_cih_barrier.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Lack of will power / self-discipline
          2: Family responsibilities
          4: Work schedule
          8: Addiction to drugs / alcohol
          16: Physical condition
          32: Disability / health problem
          64: Too stressed
          128: Too costly / financial constraints
          256: Not available in area
          512: Transportation problems
          1024: Weather problems
          2048: Other
    - id: q_cih_barrier_other
      kind: Question
      title: 'Please specify what is stopping you:'
      precondition:
      - predicate: q_cih_barrier_reasons.outcome % 4096 >= 2048
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 80
    - id: q_cih_intend_improve
      kind: Question
      title: Is there anything you intend to do to improve your physical health in the next year?
      precondition:
      - predicate: q_cih_should_improve.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cih_intend_actions
      kind: Question
      title: What is that? (Mark all that apply)
      precondition:
      - predicate: q_cih_intend_improve.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Start / Increase exercise, sports / physical activity
          2: Lose weight
          4: Change diet / improve eating habits
          8: Quit smoking / reduce amount smoked
          16: Drink less alcohol
          32: Reduce stress level
          64: Receive medical treatment
          128: Take vitamins
          256: Other
    - id: q_cih_intend_other
      kind: Question
      title: 'Please specify what you intend to do:'
      precondition:
      - predicate: q_cih_intend_actions.outcome % 512 >= 256
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 80
