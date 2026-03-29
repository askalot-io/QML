qmlVersion: '1.0'
questionnaire:
  title: 01 Demographics General Health
  codeInit: |
    age = 0
    # Extern variables from prior sections
    age: range(12, 130)
    is_proxy: {0, 1}
    age: range(12, 120)
    sex: {1, 2}
  blocks:
  - id: b_age_dob
    title: Age and Date of Birth
    items:
    - id: q_anc_intro
      kind: Comment
      title: For some of the questions I'll be asking, I need to know your exact date of birth.
    - id: q_anc_dob_day
      kind: Question
      title: What is the day of your birth?
      input:
        control: Editbox
        min: 1
        max: 31
        right: day
    - id: q_anc_dob_month
      kind: Question
      title: What is the month of your birth?
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
    - id: q_anc_dob_year
      kind: Question
      title: What is the four-digit year of your birth?
      input:
        control: Editbox
        min: 1880
        max: 2005
        right: year
    - id: q_anc_confirm_age
      kind: Question
      title: Based on the date of birth provided, what is your age? (Enter your current age in years.)
      postcondition:
      - predicate: q_anc_confirm_age.outcome >= 12
        hint: You must be 12 years or older to participate in the Canadian Community Health Survey.
      codeBlock: |
        age = q_anc_confirm_age.outcome
      input:
        control: Editbox
        min: 0
        max: 130
        right: years
  - id: b_general_health
    title: General Health
    items:
    - id: q_gen_intro
      kind: Comment
      title: This survey deals with various aspects of your health. I'll be asking about such things as physical activity,
        social relationships and health status. By health, we mean not only the absence of disease or injury but also physical,
        mental and social well-being.
    - id: q_gen_health
      kind: Question
      title: 'To start, in general, would you say your health is:'
      input:
        control: Radio
        labels:
          1: Excellent
          2: Very good
          3: Good
          4: Fair
          5: Poor
    - id: q_gen_health_compared
      kind: Question
      title: 'Compared to one year ago, how would you say your health is now? Is it:'
      input:
        control: Radio
        labels:
          1: Much better now than 1 year ago
          2: Somewhat better now than 1 year ago
          3: About the same as 1 year ago
          4: Somewhat worse now than 1 year ago
          5: Much worse now than 1 year ago
    - id: q_gen_life_satisfaction
      kind: Question
      title: How satisfied are you with your life in general?
      precondition:
      - predicate: is_proxy == 0
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_gen_mental_health
      kind: Question
      title: 'In general, would you say your mental health is:'
      precondition:
      - predicate: is_proxy == 0
      input:
        control: Radio
        labels:
          1: Excellent
          2: Very good
          3: Good
          4: Fair
          5: Poor
    - id: q_gen_stress
      kind: Question
      title: 'Thinking about the amount of stress in your life, would you say that most days are:'
      precondition:
      - predicate: age >= 15
      input:
        control: Radio
        labels:
          1: Not at all stressful
          2: Not very stressful
          3: A bit stressful
          4: Quite a bit stressful
          5: Extremely stressful
    - id: q_gen_worked
      kind: Question
      title: Have you worked at a job or business at any time in the past 12 months?
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 15 and age <= 75
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_gen_work_stress
      kind: Question
      title: 'The next question is about your main job or business in the past 12 months. Would you say that most days at
        work were:'
      precondition:
      - predicate: q_gen_worked.outcome == 1
      input:
        control: Radio
        labels:
          1: Not at all stressful
          2: Not very stressful
          3: A bit stressful
          4: Quite a bit stressful
          5: Extremely stressful
    - id: q_gen_belonging
      kind: Question
      title: 'How would you describe your sense of belonging to your local community? Would you say it is:'
      precondition:
      - predicate: is_proxy == 0
      input:
        control: Radio
        labels:
          1: Very strong
          2: Somewhat strong
          3: Somewhat weak
          4: Very weak
  - id: b_height_weight
    title: Height and Weight
    items:
    - id: q_hwt_height_range
      kind: Question
      title: The next questions are about height and weight. How tall are you without shoes on?
      postcondition:
      - predicate: q_hwt_height_range.outcome >= 3
        hint: The selected height is too short for a respondent aged 12 or older. Please correct.
      input:
        control: Radio
        labels:
          3: 3'0" to 3'11" (90.2 to 120.6 cm)
          4: 4'0" to 4'11" (120.7 to 151.0 cm)
          5: 5'0" to 5'11" (151.1 to 181.5 cm)
          6: 6'0" to 6'11" (181.6 to 212.0 cm)
          7: 7'0" and over (212.1 cm and over)
    - id: q_hwt_height_3ft
      kind: Question
      title: 'Select the exact height:'
      precondition:
      - predicate: q_hwt_height_range.outcome == 3
      input:
        control: Dropdown
        labels:
          0: 3'0" / 36" (90.2-92.6 cm)
          1: 3'1" / 37" (92.7-95.2 cm)
          2: 3'2" / 38" (95.3-97.7 cm)
          3: 3'3" / 39" (97.8-100.2 cm)
          4: 3'4" / 40" (100.3-102.8 cm)
          5: 3'5" / 41" (102.9-105.3 cm)
          6: 3'6" / 42" (105.4-107.9 cm)
          7: 3'7" / 43" (108.0-110.4 cm)
          8: 3'8" / 44" (110.5-112.9 cm)
          9: 3'9" / 45" (113.0-115.5 cm)
          10: 3'10" / 46" (115.6-118.0 cm)
          11: 3'11" / 47" (118.1-120.6 cm)
    - id: q_hwt_height_4ft
      kind: Question
      title: 'Select the exact height:'
      precondition:
      - predicate: q_hwt_height_range.outcome == 4
      input:
        control: Dropdown
        labels:
          0: 4'0" / 48" (120.7-123.1 cm)
          1: 4'1" / 49" (123.2-125.6 cm)
          2: 4'2" / 50" (125.7-128.2 cm)
          3: 4'3" / 51" (128.3-130.7 cm)
          4: 4'4" / 52" (130.8-133.3 cm)
          5: 4'5" / 53" (133.4-135.8 cm)
          6: 4'6" / 54" (135.9-138.3 cm)
          7: 4'7" / 55" (138.4-140.9 cm)
          8: 4'8" / 56" (141.0-143.4 cm)
          9: 4'9" / 57" (143.5-146.0 cm)
          10: 4'10" / 58" (146.1-148.5 cm)
          11: 4'11" / 59" (148.6-151.0 cm)
    - id: q_hwt_height_5ft
      kind: Question
      title: 'Select the exact height:'
      precondition:
      - predicate: q_hwt_height_range.outcome == 5
      input:
        control: Dropdown
        labels:
          0: 5'0" (151.1-153.6 cm)
          1: 5'1" (153.7-156.1 cm)
          2: 5'2" (156.2-158.7 cm)
          3: 5'3" (158.8-161.2 cm)
          4: 5'4" (161.3-163.7 cm)
          5: 5'5" (163.8-166.3 cm)
          6: 5'6" (166.4-168.8 cm)
          7: 5'7" (168.9-171.4 cm)
          8: 5'8" (171.5-173.9 cm)
          9: 5'9" (174.0-176.4 cm)
          10: 5'10" (176.5-179.0 cm)
          11: 5'11" (179.1-181.5 cm)
    - id: q_hwt_height_6ft
      kind: Question
      title: 'Select the exact height:'
      precondition:
      - predicate: q_hwt_height_range.outcome == 6
      input:
        control: Dropdown
        labels:
          0: 6'0" (181.6-184.1 cm)
          1: 6'1" (184.2-186.6 cm)
          2: 6'2" (186.7-189.1 cm)
          3: 6'3" (189.2-191.7 cm)
          4: 6'4" (191.8-194.2 cm)
          5: 6'5" (194.3-196.8 cm)
          6: 6'6" (196.9-199.3 cm)
          7: 6'7" (199.4-201.8 cm)
          8: 6'8" (201.9-204.4 cm)
          9: 6'9" (204.5-206.9 cm)
          10: 6'10" (207.0-209.5 cm)
          11: 6'11" (209.6-212.0 cm)
    - id: q_hwt_weight
      kind: Question
      title: How much do you weigh?
      input:
        control: Editbox
        min: 1
        max: 575
    - id: q_hwt_weight_unit
      kind: Question
      title: Was that in pounds or kilograms?
      input:
        control: Radio
        labels:
          1: Pounds
          2: Kilograms
    - id: q_hwt_self_perception
      kind: Question
      title: 'Do you consider yourself:'
      precondition:
      - predicate: is_proxy == 0
      input:
        control: Radio
        labels:
          1: Overweight
          2: Underweight
          3: Just about right
  - id: b_birth_immigration
    title: Country of Birth and Immigration
    items:
    - id: q_sdc_r1
      kind: Comment
      title: Now some general background questions which will help us compare the health of people in Canada.
    - id: q_sdc_q1
      kind: Question
      title: In what country were you born?
      input:
        control: Dropdown
        labels:
          1: Canada
          2: China
          3: France
          4: Germany
          5: Greece
          6: Guyana
          7: Hong Kong
          8: Hungary
          9: India
          10: Italy
          11: Jamaica
          12: Netherlands / Holland
          13: Philippines
          14: Poland
          15: Portugal
          16: United Kingdom
          17: United States
          18: Viet Nam
          19: Sri Lanka
          20: Other
    - id: q_sdc_q1s
      kind: Question
      title: 'INTERVIEWER: Specify the country of birth.'
      precondition:
      - predicate: q_sdc_q1.outcome == 20
      input:
        control: Textarea
        placeholder: Specify country...
        maxLength: 200
    - id: q_sdc_q2
      kind: Question
      title: Were you born a Canadian citizen?
      precondition:
      - predicate: q_sdc_q1.outcome != 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sdc_q3
      kind: Question
      title: In what year did you first come to Canada to live?
      precondition:
      - predicate: q_sdc_q1.outcome != 1
      - predicate: q_sdc_q2.outcome == 0
      input:
        control: Editbox
        min: 1900
        max: 2005
        right: year
  - id: b_ethnicity
    title: Ethnicity and Ancestry
    items:
    - id: q_sdc_q4
      kind: Question
      title: To which ethnic or cultural group(s) did your ancestors belong? (Mark all that apply)
      input:
        control: Checkbox
        labels:
          1: Canadian
          2: French
          4: English
          8: German
          16: Scottish
          32: Irish
          64: Italian
          128: Ukrainian
          256: Dutch (Netherlands)
          512: Chinese
          1024: Jewish
          2048: Polish
          4096: Portuguese
          8192: South Asian
          16384: Norwegian
          32768: Welsh
          65536: Swedish
          131072: North American Indian
          262144: Metis
          524288: Inuit
          1048576: Other
    - id: q_sdc_q4s
      kind: Question
      title: 'INTERVIEWER: Specify the ethnic or cultural group.'
      precondition:
      - predicate: q_sdc_q4.outcome % 2097152 >= 1048576
      input:
        control: Textarea
        placeholder: Specify ethnic group...
        maxLength: 200
    - id: q_sdc_q4_1
      kind: Question
      title: Are you an Aboriginal person, that is, North American Indian, Metis or Inuit?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sdc_q4_2
      kind: Question
      title: Are you North American Indian, Metis, or Inuit?
      precondition:
      - predicate: q_sdc_q4_1.outcome == 1
      input:
        control: Checkbox
        labels:
          1: North American Indian
          2: Metis
          4: Inuit
    - id: q_sdc_q4_3
      kind: Question
      title: 'People living in Canada come from many different cultural and racial backgrounds. Are you: (Mark all that apply)'
      precondition:
      - predicate: q_sdc_q4_1.outcome == 0
      input:
        control: Checkbox
        labels:
          1: White
          2: Chinese
          4: South Asian
          8: Black
          16: Filipino
          32: Latin American
          64: Southeast Asian
          128: Arab
          256: West Asian
          512: Japanese
          1024: Korean
          2048: Other
    - id: q_sdc_q4_3s
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_sdc_q4_1.outcome == 0
      - predicate: q_sdc_q4_3.outcome % 4096 >= 2048
      input:
        control: Textarea
        placeholder: Specify racial background...
        maxLength: 200
  - id: b_languages
    title: Languages
    items:
    - id: q_sdc_q5
      kind: Question
      title: In what languages can you conduct a conversation? (Mark all that apply)
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Arabic
          8: Chinese
          16: Cree
          32: German
          64: Greek
          128: Hungarian
          256: Italian
          512: Korean
          1024: Persian (Farsi)
          2048: Polish
          4096: Portuguese
          8192: Punjabi
          16384: Spanish
          32768: Tagalog (Pilipino)
          65536: Ukrainian
          131072: Vietnamese
          262144: Dutch
          524288: Hindi
          1048576: Russian
          2097152: Tamil
          4194304: Other
    - id: q_sdc_q5s
      kind: Question
      title: 'INTERVIEWER: Specify the language.'
      precondition:
      - predicate: q_sdc_q5.outcome % 8388608 >= 4194304
      input:
        control: Textarea
        placeholder: Specify language...
        maxLength: 200
    - id: q_sdc_q5a
      kind: Question
      title: What language do you speak most often at home?
      input:
        control: Dropdown
        labels:
          1: English
          2: French
          3: Arabic
          4: Chinese
          5: Cree
          6: German
          7: Greek
          8: Hungarian
          9: Italian
          10: Korean
          11: Persian (Farsi)
          12: Polish
          13: Portuguese
          14: Punjabi
          15: Spanish
          16: Tagalog (Pilipino)
          17: Ukrainian
          18: Vietnamese
          19: Dutch
          20: Hindi
          21: Russian
          22: Tamil
          23: Other
    - id: q_sdc_q5as
      kind: Question
      title: 'INTERVIEWER: Specify the language.'
      precondition:
      - predicate: q_sdc_q5a.outcome == 23
      input:
        control: Textarea
        placeholder: Specify language...
        maxLength: 200
    - id: q_sdc_q6
      kind: Question
      title: What is the language that you first learned at home in childhood and can still understand? (Mark all that apply)
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Arabic
          8: Chinese
          16: Cree
          32: German
          64: Greek
          128: Hungarian
          256: Italian
          512: Korean
          1024: Persian (Farsi)
          2048: Polish
          4096: Portuguese
          8192: Punjabi
          16384: Spanish
          32768: Tagalog (Pilipino)
          65536: Ukrainian
          131072: Vietnamese
          262144: Dutch
          524288: Hindi
          1048576: Russian
          2097152: Tamil
          4194304: Other
    - id: q_sdc_q6s
      kind: Question
      title: 'INTERVIEWER: Specify the language.'
      precondition:
      - predicate: q_sdc_q6.outcome % 8388608 >= 4194304
      input:
        control: Textarea
        placeholder: Specify language...
        maxLength: 200
  - id: b_sexual_orientation
    title: Sexual Orientation
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 18
    - predicate: age <= 59
    items:
    - id: q_sdc_q7a
      kind: Question
      title: 'Do you consider yourself to be:'
      input:
        control: Radio
        labels:
          1: Heterosexual
          2: Homosexual, that is lesbian or gay
          3: Bisexual
