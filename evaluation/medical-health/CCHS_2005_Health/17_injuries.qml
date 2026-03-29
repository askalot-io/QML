qmlVersion: '1.0'
questionnaire:
  title: 17 Injuries
  codeInit: |
    # Extern variables from prior sections
    is_proxy: {0, 1}
    # HCU overnight hospital stay (for soft edit on INJ_Q15)
    hcu_q01ba: {0, 1}
  blocks:
  - id: b_repetitive_strain
    title: Repetitive Strain Injuries
    items:
    - id: q_rep_intro
      kind: Comment
      title: This next section deals with repetitive strain injuries. By this we mean injuries caused by overuse or by repeating
        the same movement frequently. For example, carpal tunnel syndrome, tennis elbow or tendonitis.
    - id: q_rep_q1
      kind: Question
      title: In the past 12 months, did you have any injuries due to repetitive strain which were serious enough to limit
        your normal activities?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_rep_q3
      kind: Question
      title: Thinking about the most serious repetitive strain, what part of the body was affected?
      precondition:
      - predicate: q_rep_q1.outcome == 1
      input:
        control: Dropdown
        labels:
          1: Head
          2: Neck
          3: Shoulder, upper arm
          4: Elbow, lower arm
          5: Wrist
          6: Hand
          7: Hip
          8: Thigh
          9: Knee, lower leg
          10: Ankle, foot
          11: Upper back or upper spine (excluding neck)
          12: Lower back or lower spine
          13: Chest (excluding back and spine)
          14: Abdomen or pelvis (excluding back and spine)
    - id: q_rep_q4
      kind: Question
      title: What type of activity were you doing when you got this repetitive strain? (Mark all that apply)
      precondition:
      - predicate: q_rep_q1.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Sports or physical exercise (include school activities)
          2: Leisure or hobby (include volunteering)
          4: Working at a job or business (exclude travel to or from work)
          8: Travel to or from work
          16: Household chores, other unpaid work or education
          32: Sleeping, eating, personal care
          64: Other
    - id: q_rep_q4s
      kind: Question
      title: Please specify the type of activity.
      precondition:
      - predicate: q_rep_q1.outcome == 1
      - predicate: q_rep_q4.outcome % 128 >= 64
      input:
        control: Textarea
        placeholder: Specify activity...
        maxLength: 200
  - id: b_main_injuries
    title: General Injuries
    items:
    - id: q_inj_intro
      kind: Comment
      title: Now some questions about injuries which occurred in the past 12 months, and were serious enough to limit your
        normal activities. For example, a broken bone, a bad cut or burn, a sprain, or a poisoning.
    - id: q_inj_q01
      kind: Question
      title: In the past 12 months, were you injured?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_inj_q02
      kind: Question
      title: How many times were you injured?
      precondition:
      - predicate: q_inj_q01.outcome == 1
      postcondition:
      - predicate: q_inj_q02.outcome <= 6
        hint: 'Warning: more than 6 injuries reported. Please confirm.'
      input:
        control: Editbox
        min: 1
        max: 30
        right: times
    - id: q_inj_q03
      kind: Question
      title: Thinking about the most serious injury, in which month did it happen?
      precondition:
      - predicate: q_inj_q01.outcome == 1
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
    - id: q_inj_q04
      kind: Question
      title: Was that this year or last year?
      precondition:
      - predicate: q_inj_q01.outcome == 1
      input:
        control: Radio
        labels:
          1: This year
          2: Last year
    - id: q_inj_q05
      kind: Question
      title: What type of injury did you have? For example, a broken bone or burn.
      precondition:
      - predicate: q_inj_q01.outcome == 1
      input:
        control: Dropdown
        labels:
          1: Multiple injuries
          2: Broken or fractured bones
          3: Burn, scald, chemical burn
          4: Dislocation
          5: Sprain or strain
          6: Cut, puncture, animal or human bite (open wound)
          7: Scrape, bruise, blister
          8: Concussion or other brain injury
          9: Poisoning
          10: Injury to internal organs
          11: Other
    - id: q_inj_q05s
      kind: Question
      title: Please specify the type of injury.
      precondition:
      - predicate: q_inj_q05.outcome == 11
      input:
        control: Textarea
        placeholder: Specify injury type...
        maxLength: 200
    - id: q_inj_q06
      kind: Question
      title: What part of the body was injured?
      precondition:
      - predicate: q_inj_q01.outcome == 1
      - predicate: q_inj_q05.outcome not in [8, 9, 10]
      input:
        control: Dropdown
        labels:
          1: Multiple sites
          2: Eyes
          3: Head (excluding eyes)
          4: Neck
          5: Shoulder, upper arm
          6: Elbow, lower arm
          7: Wrist
          8: Hand
          9: Hip
          10: Thigh
          11: Knee, lower leg
          12: Ankle, foot
          13: Upper back or upper spine (excluding neck)
          14: Lower back or lower spine
          15: Chest (excluding back and spine)
          16: Abdomen or pelvis (excluding back and spine)
    - id: q_inj_q07
      kind: Question
      title: What part of the body was injured?
      precondition:
      - predicate: q_inj_q05.outcome == 10
      input:
        control: Radio
        labels:
          1: Chest (within rib cage)
          2: Abdomen or pelvis (below ribs)
          3: Other
    - id: q_inj_q07s
      kind: Question
      title: Please specify the part of the body.
      precondition:
      - predicate: q_inj_q07.outcome == 3
      input:
        control: Textarea
        placeholder: Specify body part...
        maxLength: 200
    - id: q_inj_q08
      kind: Question
      title: Where did the injury happen?
      precondition:
      - predicate: q_inj_q01.outcome == 1
      input:
        control: Dropdown
        labels:
          1: In a home or its surrounding area
          2: Residential institution
          3: School, college, university (exclude sports areas)
          4: Sports or athletics area of school, college, university
          5: Other sports or athletics area (exclude school sports areas)
          6: Other institution (e.g., church, hospital, theatre, civic building)
          7: Street, highway, sidewalk
          8: Commercial area (e.g., store, restaurant, office building, transport terminal)
          9: Industrial or construction area
          10: Farm (exclude farmhouse and its surrounding area)
          11: Countryside, forest, lake, ocean, mountains, prairie, etc.
          12: Other
    - id: q_inj_q08s
      kind: Question
      title: Please specify where the injury happened.
      precondition:
      - predicate: q_inj_q08.outcome == 12
      input:
        control: Textarea
        placeholder: Specify location...
        maxLength: 200
    - id: q_inj_q09
      kind: Question
      title: What type of activity were you doing when you were injured?
      precondition:
      - predicate: q_inj_q01.outcome == 1
      input:
        control: Radio
        labels:
          1: Sports or physical exercise (include school activities)
          2: Leisure or hobby (include volunteering)
          3: Working at a job or business (exclude travel to or from work)
          4: Travel to or from work
          5: Household chores, other unpaid work or education
          6: Sleeping, eating, personal care
          7: Other
    - id: q_inj_q09s
      kind: Question
      title: Please specify the type of activity.
      precondition:
      - predicate: q_inj_q09.outcome == 7
      input:
        control: Textarea
        placeholder: Specify activity...
        maxLength: 200
    - id: q_inj_q10
      kind: Question
      title: Was the injury the result of a fall?
      precondition:
      - predicate: q_inj_q01.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_inj_q11
      kind: Question
      title: How did you fall?
      precondition:
      - predicate: q_inj_q10.outcome == 1
      input:
        control: Radio
        labels:
          1: While skating, skiing, snowboarding, in-line skating or skateboarding
          2: Going up or down stairs / steps (icy or not)
          3: Slip, trip or stumble on ice or snow
          4: Slip, trip or stumble on any other surface
          5: From furniture (e.g., bed, chair)
          6: From elevated position (e.g., ladder, tree)
          7: Other
    - id: q_inj_q11s
      kind: Question
      title: Please specify how you fell.
      precondition:
      - predicate: q_inj_q11.outcome == 7
      input:
        control: Textarea
        placeholder: Specify how you fell...
        maxLength: 200
    - id: q_inj_q12
      kind: Question
      title: What caused the injury?
      precondition:
      - predicate: q_inj_q10.outcome == 0
      input:
        control: Dropdown
        labels:
          1: Transportation accident
          2: Accidentally bumped, pushed, bitten, etc. by person or animal
          3: Accidentally struck or crushed by object(s)
          4: Accidental contact with sharp object, tool or machine
          5: Smoke, fire, flames
          6: Accidental contact with hot object, liquid or gas
          7: Extreme weather or natural disaster
          8: Overexertion or strenuous movement
          9: Physical assault
          10: Other
    - id: q_inj_q12s
      kind: Question
      title: Please specify what caused the injury.
      precondition:
      - predicate: q_inj_q12.outcome == 10
      input:
        control: Textarea
        placeholder: Specify cause...
        maxLength: 200
    - id: q_inj_q13
      kind: Question
      title: Did you receive any medical attention for the injury from a health professional in the 48 hours following the
        injury?
      precondition:
      - predicate: q_inj_q01.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_inj_q14
      kind: Question
      title: Where did you receive treatment? (Mark all that apply)
      precondition:
      - predicate: q_inj_q13.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Doctor's office
          2: Hospital emergency room
          4: Hospital outpatient clinic (e.g., day surgery, cancer)
          8: Walk-in clinic
          16: Appointment clinic
          32: Community health centre / CLSC
          64: At work
          128: At school
          256: At home
          512: Telephone consultation only
          1024: Other
    - id: q_inj_q14s
      kind: Question
      title: Please specify where you received treatment.
      precondition:
      - predicate: q_inj_q13.outcome == 1
      - predicate: q_inj_q14.outcome % 2048 >= 1024
      input:
        control: Textarea
        placeholder: Specify treatment location...
        maxLength: 200
    - id: q_inj_q15
      kind: Question
      title: Were you admitted to a hospital overnight?
      precondition:
      - predicate: q_inj_q13.outcome == 1
      postcondition:
      - predicate: q_inj_q15.outcome == 0 or hcu_q01ba == 1
        hint: 'Warning: you reported being admitted overnight for an injury but previously reported no overnight hospital
          stays.'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_other_injuries
    title: Other Injuries
    items:
    - id: q_inj_q16
      kind: Question
      title: Did you have any other injuries in the past 12 months that were treated by a health professional, but did not
        limit your normal activities?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_inj_q17
      kind: Question
      title: How many injuries?
      precondition:
      - predicate: q_inj_q16.outcome == 1
      postcondition:
      - predicate: q_inj_q17.outcome <= 6
        hint: 'Warning: more than 6 injuries reported. Please confirm.'
      input:
        control: Editbox
        min: 1
        max: 30
