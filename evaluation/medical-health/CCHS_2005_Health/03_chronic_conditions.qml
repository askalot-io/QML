qmlVersion: '1.0'
questionnaire:
  title: 03 Chronic Conditions
  codeInit: |
    # Extern variables from earlier sections
    age: range(12, 120)
    sex: {1, 2}
    # Derived variable: tracks whether respondent has skin cancer
    has_skin_cancer = 0
  blocks:
  - id: b_chronic_conditions
    title: Chronic Conditions Checklist
    items:
    - id: q_ccc_r011
      kind: Comment
      title: Now I'd like to ask about certain chronic health conditions which you may have. We are interested in 'long-term
        conditions' which are expected to last or have already lasted 6 months or more and that have been diagnosed by a health
        professional.
    - id: q_ccc_q011
      kind: Question
      title: 'Do you have: ... food allergies?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q021
      kind: Question
      title: 'Do you have: ... any other allergies?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q031
      kind: Question
      title: 'Do you have: ... asthma?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q035
      kind: Question
      title: Have you had any asthma symptoms or asthma attacks in the past 12 months?
      precondition:
      - predicate: q_ccc_q031.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q036
      kind: Question
      title: In the past 12 months, have you taken any medicine for asthma such as inhalers, nebulizers, pills, liquids or
        injections?
      precondition:
      - predicate: q_ccc_q031.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q041
      kind: Question
      title: Do you have fibromyalgia?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q051
      kind: Question
      title: Remember, we're interested in conditions diagnosed by a health professional. Do you have arthritis or rheumatism,
        excluding fibromyalgia?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q05a
      kind: Question
      title: What kind of arthritis do you have?
      precondition:
      - predicate: q_ccc_q051.outcome == 1
      input:
        control: Radio
        labels:
          1: Rheumatoid arthritis
          2: Osteoarthritis
          3: Rheumatism
          4: Other - Specify
    - id: q_ccc_q05as
      kind: Question
      title: 'Please specify the type of arthritis:'
      precondition:
      - predicate: q_ccc_q05a.outcome == 4
      input:
        control: Textarea
        placeholder: Specify type of arthritis...
        maxLength: 80
    - id: q_ccc_q061
      kind: Question
      title: Do you have back problems, excluding fibromyalgia and arthritis?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q071
      kind: Question
      title: Do you have high blood pressure?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q072
      kind: Question
      title: Have you ever been diagnosed with high blood pressure?
      precondition:
      - predicate: q_ccc_q071.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q073
      kind: Question
      title: In the past month, have you taken any medicine for high blood pressure?
      precondition:
      - predicate: q_ccc_q071.outcome == 1 or q_ccc_q072.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q074
      kind: Question
      title: In the past month, did you do anything else, recommended by a health professional, to reduce or control your
        blood pressure?
      precondition:
      - predicate: q_ccc_q071.outcome == 1 or q_ccc_q072.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q075
      kind: Question
      title: What did you do?
      precondition:
      - predicate: q_ccc_q074.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Changed diet (e.g., reduced salt intake)
          2: Exercised more
          4: Reduced alcohol intake
          8: Other
    - id: q_ccc_q081
      kind: Question
      title: Remember, we're interested in conditions diagnosed by a health professional. Do you have migraine headaches?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q091a
      kind: Question
      title: 'Do you have: ... chronic bronchitis?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q091e
      kind: Question
      title: 'Do you have: ... emphysema?'
      precondition:
      - predicate: age >= 30
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q091f
      kind: Question
      title: 'Do you have: ... chronic obstructive pulmonary disease (COPD)?'
      precondition:
      - predicate: age >= 30
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q101
      kind: Question
      title: 'Do you have: ... diabetes?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q102
      kind: Question
      title: How old were you when this was first diagnosed?
      precondition:
      - predicate: q_ccc_q101.outcome == 1
      input:
        control: Editbox
        min: 0
        max: 120
        right: years old
    - id: q_ccc_q10a
      kind: Question
      title: Were you pregnant when you were first diagnosed with diabetes?
      precondition:
      - predicate: q_ccc_q101.outcome == 1
      - predicate: age >= 15
      - predicate: sex == 2
      - predicate: q_ccc_q102.outcome >= 15
      - predicate: q_ccc_q102.outcome <= 49
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q10b
      kind: Question
      title: Other than during pregnancy, has a health professional ever told you that you have diabetes?
      precondition:
      - predicate: q_ccc_q10a.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q10c
      kind: Question
      title: When you were first diagnosed with diabetes, how long was it before you were started on insulin?
      precondition:
      - predicate: q_ccc_q101.outcome == 1
      - predicate: not (q_ccc_q10a.outcome == 1 and q_ccc_q10b.outcome == 0)
      input:
        control: Radio
        labels:
          1: Less than 1 month
          2: 1 month to less than 2 months
          3: 2 months to less than 6 months
          4: 6 months to less than 1 year
          5: 1 year or more
          6: Never
    - id: q_ccc_q105
      kind: Question
      title: Do you currently take insulin for your diabetes?
      precondition:
      - predicate: q_ccc_q101.outcome == 1
      - predicate: not (q_ccc_q10a.outcome == 1 and q_ccc_q10b.outcome == 0)
      - predicate: q_ccc_q10c.outcome != 6
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q106
      kind: Question
      title: In the past month, did you take pills to control your blood sugar?
      precondition:
      - predicate: q_ccc_q101.outcome == 1
      - predicate: not (q_ccc_q10a.outcome == 1 and q_ccc_q10b.outcome == 0)
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q111
      kind: Question
      title: Remember, we're interested in conditions diagnosed by a health professional. Do you have epilepsy?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q121
      kind: Question
      title: 'Do you have: ... heart disease?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q131
      kind: Question
      title: 'Do you have: ... cancer?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q132
      kind: Question
      title: Have you ever been diagnosed with cancer?
      precondition:
      - predicate: q_ccc_q131.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q133a
      kind: Question
      title: What type of cancer do/did you have?
      precondition:
      - predicate: q_ccc_q131.outcome == 1 or q_ccc_q132.outcome == 1
      - predicate: sex == 2
      input:
        control: Checkbox
        labels:
          1: Breast
          2: Colorectal
          4: Skin - Melanoma
          8: Skin - Non-melanoma
          16: Other
      codeBlock: |
        if q_ccc_q133a.outcome % 8 >= 4 or q_ccc_q133a.outcome % 16 >= 8:
            has_skin_cancer = 1
    - id: q_ccc_q133b
      kind: Question
      title: What type of cancer do/did you have?
      precondition:
      - predicate: q_ccc_q131.outcome == 1 or q_ccc_q132.outcome == 1
      - predicate: sex == 1
      input:
        control: Checkbox
        labels:
          1: Prostate
          2: Colorectal
          4: Skin - Melanoma
          8: Skin - Non-melanoma
          16: Other
      codeBlock: |
        if q_ccc_q133b.outcome % 8 >= 4 or q_ccc_q133b.outcome % 16 >= 8:
            has_skin_cancer = 1
    - id: q_ccc_q141
      kind: Question
      title: Remember, we're interested in conditions diagnosed by a health professional. Do you have intestinal or stomach
        ulcers?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q151
      kind: Question
      title: Do you suffer from the effects of a stroke?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q161
      kind: Question
      title: 'Do you suffer: ... from urinary incontinence?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q171
      kind: Question
      title: Do you suffer from a bowel disorder such as Crohn's Disease, ulcerative colitis, Irritable Bowel Syndrome or
        bowel incontinence?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q171a
      kind: Question
      title: What kind of bowel disease do you have?
      precondition:
      - predicate: q_ccc_q171.outcome == 1
      input:
        control: Radio
        labels:
          1: Crohn's Disease
          2: Ulcerative colitis
          3: Irritable Bowel Syndrome
          4: Bowel incontinence
          5: Other
    - id: q_ccc_q181
      kind: Question
      title: 'Remember, we''re interested in conditions diagnosed by a health professional. Do you have: ... Alzheimer''s
        Disease or any other dementia?'
      precondition:
      - predicate: age >= 18
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q191
      kind: Question
      title: 'Do you have: ... cataracts?'
      precondition:
      - predicate: age >= 18
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q201
      kind: Question
      title: 'Do you have: ... glaucoma?'
      precondition:
      - predicate: age >= 18
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q211
      kind: Question
      title: 'Do you have: ... a thyroid condition?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q251
      kind: Question
      title: Remember, we're interested in conditions diagnosed by a health professional. Do you have chronic fatigue syndrome?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q261
      kind: Question
      title: Do you suffer from multiple chemical sensitivities?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q271
      kind: Question
      title: Do you have schizophrenia?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q280
      kind: Question
      title: Remember, we're interested in conditions diagnosed by a health professional. Do you have a mood disorder such
        as depression, bipolar disorder, mania or dysthymia?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q290
      kind: Question
      title: Remember, we're interested in conditions diagnosed by a health professional. Do you have an anxiety disorder
        such as a phobia, obsessive-compulsive disorder or a panic disorder?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q321
      kind: Question
      title: Do you have autism or any other developmental disorder such as Down's syndrome, Asperger's syndrome or Rett syndrome?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q331
      kind: Question
      title: Remember, we're interested in conditions diagnosed by a health professional. Do you have a learning disability?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q331a
      kind: Question
      title: What kind of learning disability do you have?
      precondition:
      - predicate: q_ccc_q331.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Attention Deficit Disorder, no hyperactivity (ADD)
          2: Attention Deficit Hyperactivity Disorder (ADHD)
          4: Dyslexia
          8: Other - Specify
    - id: q_ccc_q331as
      kind: Question
      title: 'Please specify the type of learning disability:'
      precondition:
      - predicate: q_ccc_q331a.outcome % 16 >= 8
      input:
        control: Textarea
        placeholder: Specify type of learning disability...
        maxLength: 80
    - id: q_ccc_q341
      kind: Question
      title: Do you have an eating disorder such as anorexia or bulimia?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q901
      kind: Question
      title: Do you have any other long-term physical or mental health condition that has been diagnosed by a health professional?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccc_q901s
      kind: Question
      title: 'Please specify the condition:'
      precondition:
      - predicate: q_ccc_q901.outcome == 1
      input:
        control: Textarea
        placeholder: Specify the condition...
        maxLength: 80
  - id: b_diabetes_care
    title: Diabetes Care
    precondition:
    - predicate: q_ccc_q101.outcome == 1
    - predicate: q_ccc_q10a.outcome != 1
    items:
    - id: q_dia_r01
      kind: Comment
      title: It was reported earlier that you have diabetes. The following questions are about diabetes care.
    - id: q_dia_q01
      kind: Question
      title: In the past 12 months, has a health care professional tested you for haemoglobin 'A-one-C'? (An 'A-one-C' haemoglobin
        test measures the average level of blood sugar over a 3-month period.)
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_dia_q02
      kind: Question
      title: How many times?
      precondition:
      - predicate: q_dia_q01.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 99
        right: times
    - id: q_dia_q03
      kind: Question
      title: In the past 12 months, has a health care professional checked your feet for any sores or irritations?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: No feet
    - id: q_dia_q04
      kind: Question
      title: How many times?
      precondition:
      - predicate: q_dia_q03.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 99
        right: times
    - id: q_dia_q05
      kind: Question
      title: In the past 12 months, has a health care professional tested your urine for protein (i.e., Microalbumin)?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_dia_q06
      kind: Question
      title: Have you ever had an eye exam where the pupils of your eyes were dilated? (This procedure would have made you
        temporarily sensitive to light.)
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_dia_q07
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_dia_q06.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than one month ago
          2: 1 month to less than 1 year ago
          3: 1 year to less than 2 years ago
          4: 2 or more years ago
    - id: q_dia_r08
      kind: Comment
      title: Now some questions about diabetes care not provided by a health care professional.
    - id: q_dia_q08
      kind: Question
      title: How often do you usually have your blood checked for glucose or sugar by yourself or by a family member or friend?
      input:
        control: Radio
        labels:
          1: Per day
          2: Per week
          3: Per month
          4: Per year
          5: Never
    - id: q_dia_n08b
      kind: Question
      title: Enter number of times per day.
      precondition:
      - predicate: q_dia_q08.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 99
        right: times per day
    - id: q_dia_n08c
      kind: Question
      title: Enter number of times per week.
      precondition:
      - predicate: q_dia_q08.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 99
        right: times per week
    - id: q_dia_n08d
      kind: Question
      title: Enter number of times per month.
      precondition:
      - predicate: q_dia_q08.outcome == 3
      input:
        control: Editbox
        min: 1
        max: 99
        right: times per month
    - id: q_dia_n08e
      kind: Question
      title: Enter number of times per year.
      precondition:
      - predicate: q_dia_q08.outcome == 4
      input:
        control: Editbox
        min: 1
        max: 99
        right: times per year
    - id: q_dia_q09
      kind: Question
      title: How often do you usually have your feet checked for any sores or irritations by yourself or by a family member
        or friend?
      precondition:
      - predicate: q_dia_q03.outcome != 3
      input:
        control: Radio
        labels:
          1: Per day
          2: Per week
          3: Per month
          4: Per year
          5: Never
    - id: q_dia_n09b
      kind: Question
      title: Enter number of times per day.
      precondition:
      - predicate: q_dia_q03.outcome != 3
      - predicate: q_dia_q09.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 99
        right: times per day
    - id: q_dia_n09c
      kind: Question
      title: Enter number of times per week.
      precondition:
      - predicate: q_dia_q03.outcome != 3
      - predicate: q_dia_q09.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 99
        right: times per week
    - id: q_dia_n09d
      kind: Question
      title: Enter number of times per month.
      precondition:
      - predicate: q_dia_q03.outcome != 3
      - predicate: q_dia_q09.outcome == 3
      input:
        control: Editbox
        min: 1
        max: 99
        right: times per month
    - id: q_dia_n09e
      kind: Question
      title: Enter number of times per year.
      precondition:
      - predicate: q_dia_q03.outcome != 3
      - predicate: q_dia_q09.outcome == 4
      input:
        control: Editbox
        min: 1
        max: 99
        right: times per year
    - id: q_dia_r10
      kind: Comment
      title: Now a few questions about medication.
      precondition:
      - predicate: age >= 35
    - id: q_dia_q10
      kind: Question
      title: In the past month, did you take aspirin or other ASA (acetylsalicylic acid) medication every day or every second
        day?
      precondition:
      - predicate: age >= 35
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_dia_q11
      kind: Question
      title: In the past month, did you take prescription medications such as Lipitor or Zocor to control your blood cholesterol
        levels?
      precondition:
      - predicate: age >= 35
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
