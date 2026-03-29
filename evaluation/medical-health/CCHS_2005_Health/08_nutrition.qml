qmlVersion: '1.0'
questionnaire:
  title: 08 Nutrition
  codeInit: |
    # Extern: age and proxy status from earlier sections
    age: range(12, 120)
    is_proxy: {0, 1}
    # Extern: outcomes from DEN (Dental Visits) section
    # DEN_Q132: "When did you last visit a dentist?" 1-7 scale (7=never)
    # DEN_Q130: "Have you ever visited a dentist?" 1=Yes, 2=No
    # DEN_Q136: "Do you have dentures?" values include 13 for full dentures
    den_q132: {1, 2, 3, 4, 5, 6, 7}
    den_q130: {1, 2}
    den_q136: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}
    # Extern: proxy status from earlier sections
  blocks:
  - id: b_oral_health
    title: Oral Health
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_oh2_q10
      kind: Question
      title: 'Do you usually visit the dentist:'
      precondition:
      - predicate: den_q132 != 7
      input:
        control: Radio
        labels:
          1: More than once a year for check-ups
          2: About once a year for check-ups
          3: Less than once a year for check-ups
          4: Only for emergency care
    - id: q_oh2_q11
      kind: Question
      title: Do you have insurance that covers all or part of your dental expenses?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q11a
      kind: Question
      title: 'Is it:'
      precondition:
      - predicate: q_oh2_q11.outcome == 1
      input:
        control: Checkbox
        labels:
          1: A government-sponsored plan
          2: An employer-sponsored plan
          4: A private plan
    - id: q_oh2_q12
      kind: Question
      title: In the past 12 months, have you had any teeth removed by a dentist?
      precondition:
      - predicate: den_q130 == 1 or den_q132 == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q13
      kind: Question
      title: In the past 12 months, were any teeth removed because of decay or gum disease?
      precondition:
      - predicate: q_oh2_q12.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q20
      kind: Question
      title: Do you have one or more of your own teeth?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q21
      kind: Question
      title: Do you wear dentures or false teeth?
      precondition:
      - predicate: den_q136 != 13
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_r22
      kind: Comment
      title: Now we have some additional questions about oral health, that is the health of your teeth and mouth.
    - id: q_oh2_q22
      kind: Question
      title: Because of the condition of your teeth, mouth or dentures, do you have difficulty pronouncing any words or speaking
        clearly?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q23
      kind: Question
      title: In the past 12 months, how often have you avoided conversation or contact with other people, because of the condition
        of your teeth, mouth or dentures?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_oh2_q24
      kind: Question
      title: In the past 12 months, how often have you avoided laughing or smiling, because of the condition of your teeth,
        mouth or dentures?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_oh2_r25
      kind: Comment
      title: Now some questions about the health of your teeth and mouth during the past month.
    - id: q_oh2_q25a
      kind: Question
      title: In the past month, have you had a toothache?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q25b
      kind: Question
      title: In the past month, were your teeth sensitive to hot or cold food or drinks?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q25c
      kind: Question
      title: In the past month, have you had pain in or around the jaw joints?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q25d
      kind: Question
      title: In the past month, have you had other pain in the mouth or face?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q25e
      kind: Question
      title: In the past month, have you had bleeding gums?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q25f
      kind: Question
      title: In the past month, have you had dry mouth?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q25g
      kind: Question
      title: In the past month, have you had bad breath?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: q_oh2_q30
      kind: Question
      title: How often do you brush your teeth?
      precondition:
      - predicate: q_oh2_q20.outcome == 1
      input:
        control: Radio
        labels:
          1: More than twice a day
          2: Twice a day
          3: Once a day
          4: Less than once a day but more than once a week
          5: Once a week
          6: Less than once a week
  - id: b_food_dietary_changes
    title: Food/Dietary Changes
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_fdc_intro
      kind: Comment
      title: Now, some questions about the foods you eat.
    - id: q_fdc_q1a
      kind: Question
      title: Do you choose certain foods or avoid others because you are concerned about your body weight?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q1b
      kind: Question
      title: Do you choose certain foods or avoid others because you are concerned about heart disease?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q1c
      kind: Question
      title: Do you choose certain foods or avoid others because you are concerned about cancer?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q1d
      kind: Question
      title: Do you choose certain foods or avoid others because you are concerned about osteoporosis (brittle bones)?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q2a
      kind: Question
      title: Do you choose certain foods because of the lower fat content?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q2b
      kind: Question
      title: Do you choose certain foods because of the fibre content?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q2c
      kind: Question
      title: Do you choose certain foods because of the calcium content?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q3a
      kind: Question
      title: Do you avoid certain foods because of the fat content?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q3b
      kind: Question
      title: Do you avoid certain foods because of the type of fat they contain?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q3c
      kind: Question
      title: Do you avoid certain foods because of the salt content?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q3d
      kind: Question
      title: Do you avoid certain foods because of the cholesterol content?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
    - id: q_fdc_q3e
      kind: Question
      title: Do you avoid certain foods because of the calorie content?
      input:
        control: Radio
        labels:
          1: Yes (or sometimes)
          2: 'No'
  - id: b_fruit_vegetable
    title: Fruit and Vegetable Consumption
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_fvc_intro
      kind: Comment
      title: The next questions are about the foods you usually eat or drink. Think about all the foods you eat, both meals
        and snacks, at home and away from home.
    - id: q_fvc_q1a
      kind: Question
      title: How often do you usually drink fruit juices such as orange, grapefruit or tomato?
      input:
        control: Radio
        labels:
          1: Per day
          2: Per week
          3: Per month
          4: Per year
          5: Never
    - id: q_fvc_n1b
      kind: Question
      title: Enter number of times per day.
      precondition:
      - predicate: q_fvc_q1a.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 20
    - id: q_fvc_n1c
      kind: Question
      title: Enter number of times per week.
      precondition:
      - predicate: q_fvc_q1a.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 90
    - id: q_fvc_n1d
      kind: Question
      title: Enter number of times per month.
      precondition:
      - predicate: q_fvc_q1a.outcome == 3
      input:
        control: Editbox
        min: 1
        max: 200
    - id: q_fvc_n1e
      kind: Question
      title: Enter number of times per year.
      precondition:
      - predicate: q_fvc_q1a.outcome == 4
      input:
        control: Editbox
        min: 1
        max: 500
    - id: q_fvc_q2a
      kind: Question
      title: Not counting juice, how often do you usually eat fruit?
      input:
        control: Radio
        labels:
          1: Per day
          2: Per week
          3: Per month
          4: Per year
          5: Never
    - id: q_fvc_n2b
      kind: Question
      title: Enter number of times per day.
      precondition:
      - predicate: q_fvc_q2a.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 20
    - id: q_fvc_n2c
      kind: Question
      title: Enter number of times per week.
      precondition:
      - predicate: q_fvc_q2a.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 90
    - id: q_fvc_n2d
      kind: Question
      title: Enter number of times per month.
      precondition:
      - predicate: q_fvc_q2a.outcome == 3
      input:
        control: Editbox
        min: 1
        max: 200
    - id: q_fvc_n2e
      kind: Question
      title: Enter number of times per year.
      precondition:
      - predicate: q_fvc_q2a.outcome == 4
      input:
        control: Editbox
        min: 1
        max: 500
    - id: q_fvc_q3a
      kind: Question
      title: How often do you usually eat green salad?
      input:
        control: Radio
        labels:
          1: Per day
          2: Per week
          3: Per month
          4: Per year
          5: Never
    - id: q_fvc_n3b
      kind: Question
      title: Enter number of times per day.
      precondition:
      - predicate: q_fvc_q3a.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 20
    - id: q_fvc_n3c
      kind: Question
      title: Enter number of times per week.
      precondition:
      - predicate: q_fvc_q3a.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 90
    - id: q_fvc_n3d
      kind: Question
      title: Enter number of times per month.
      precondition:
      - predicate: q_fvc_q3a.outcome == 3
      input:
        control: Editbox
        min: 1
        max: 200
    - id: q_fvc_n3e
      kind: Question
      title: Enter number of times per year.
      precondition:
      - predicate: q_fvc_q3a.outcome == 4
      input:
        control: Editbox
        min: 1
        max: 500
    - id: q_fvc_q4a
      kind: Question
      title: How often do you usually eat potatoes, not including french fries, fried potatoes, or potato chips?
      input:
        control: Radio
        labels:
          1: Per day
          2: Per week
          3: Per month
          4: Per year
          5: Never
    - id: q_fvc_n4b
      kind: Question
      title: Enter number of times per day.
      precondition:
      - predicate: q_fvc_q4a.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 20
    - id: q_fvc_n4c
      kind: Question
      title: Enter number of times per week.
      precondition:
      - predicate: q_fvc_q4a.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 90
    - id: q_fvc_n4d
      kind: Question
      title: Enter number of times per month.
      precondition:
      - predicate: q_fvc_q4a.outcome == 3
      input:
        control: Editbox
        min: 1
        max: 200
    - id: q_fvc_n4e
      kind: Question
      title: Enter number of times per year.
      precondition:
      - predicate: q_fvc_q4a.outcome == 4
      input:
        control: Editbox
        min: 1
        max: 500
    - id: q_fvc_q5a
      kind: Question
      title: How often do you usually eat carrots?
      input:
        control: Radio
        labels:
          1: Per day
          2: Per week
          3: Per month
          4: Per year
          5: Never
    - id: q_fvc_n5b
      kind: Question
      title: Enter number of times per day.
      precondition:
      - predicate: q_fvc_q5a.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 20
    - id: q_fvc_n5c
      kind: Question
      title: Enter number of times per week.
      precondition:
      - predicate: q_fvc_q5a.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 90
    - id: q_fvc_n5d
      kind: Question
      title: Enter number of times per month.
      precondition:
      - predicate: q_fvc_q5a.outcome == 3
      input:
        control: Editbox
        min: 1
        max: 200
    - id: q_fvc_n5e
      kind: Question
      title: Enter number of times per year.
      precondition:
      - predicate: q_fvc_q5a.outcome == 4
      input:
        control: Editbox
        min: 1
        max: 500
    - id: q_fvc_q6a
      kind: Question
      title: Not counting carrots, potatoes, or salad, how many servings of other vegetables do you usually eat?
      input:
        control: Radio
        labels:
          1: Per day
          2: Per week
          3: Per month
          4: Per year
          5: Never
    - id: q_fvc_n6b
      kind: Question
      title: Enter number of servings per day.
      precondition:
      - predicate: q_fvc_q6a.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 20
    - id: q_fvc_n6c
      kind: Question
      title: Enter number of servings per week.
      precondition:
      - predicate: q_fvc_q6a.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 90
    - id: q_fvc_n6d
      kind: Question
      title: Enter number of servings per month.
      precondition:
      - predicate: q_fvc_q6a.outcome == 3
      input:
        control: Editbox
        min: 1
        max: 200
    - id: q_fvc_n6e
      kind: Question
      title: Enter number of servings per year.
      precondition:
      - predicate: q_fvc_q6a.outcome == 4
      input:
        control: Editbox
        min: 1
        max: 500
