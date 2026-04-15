qmlVersion: "1.0"
questionnaire:
  title: "Canadian Community Health Survey 2005"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    age = 0
    has_skin_cancer = 0
    had_health_contact = 0
    has_difficulty = 0
    has_activity_limitation = 0
    needs_help_or_has_social_difficulty = 0
    never_tried_count = 0
    frequent_use_count = 0
    never_gamble_count = 0
    cpg_score = 0
    has_tangible = 0
    has_affection = 0
    has_positive_interaction = 0
    has_emotional_info = 0
    has_any_support = 0
    sad_symptom_count = 0
    interest_symptom_count = 0
    had_multiple_jobs = 0
    weeks_worked = 0
    weeks_looking = 0
    hh_income_given = 0
    income_source_count = 0
    food_insecurity = 0
    weight_measured = 0
    weight_permission = 0
    height_impossible = 0

  blocks:

    # ===================================================================
    # SECTION: demographics_general_health
    # ===================================================================
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

    # ===================================================================
    # SECTION: lifestyle
    # ===================================================================
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

    # ===================================================================
    # SECTION: chronic_conditions
    # ===================================================================
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

    # ===================================================================
    # SECTION: medication
    # ===================================================================
    - id: b_medication_use
      title: Medication Use
      items:
      - id: q_med_r1
        kind: Comment
        title: Now I'd like to ask a few questions about your use of medications, both prescription and over-the-counter.
      - id: q_med_q1a
        kind: Question
        title: 'In the past month, did you take: ... pain relievers such as aspirin or Tylenol (including arthritis medicine
          and anti-inflammatories)?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1b
        kind: Question
        title: 'In the past month, did you take: ... tranquilizers such as Valium or Ativan?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1c
        kind: Question
        title: 'In the past month, did you take: ... diet pills such as Dexatrim, Ponderal or Fastin?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1d
        kind: Question
        title: 'In the past month, did you take: ... anti-depressants such as Prozac, Paxil or Effexor?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1e
        kind: Question
        title: 'In the past month, did you take: ... codeine, Demerol or morphine?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1f
        kind: Question
        title: 'In the past month, did you take: ... allergy medicine such as Reactine or Allegra?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1g
        kind: Question
        title: 'In the past month, did you take: ... asthma medications such as inhalers or nebulizers?'
        postcondition:
        - predicate: not (q_med_q1g.outcome == 1 and ccc_q036_asthma_med == 0)
          hint: You indicated taking asthma medication this month but previously reported not taking asthma medicine in the
            past 12 months. Please confirm.
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1h
        kind: Question
        title: 'In the past month, did you take: ... cough or cold remedies?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1i
        kind: Question
        title: 'In the past month, did you take: ... penicillin or other antibiotics?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1j
        kind: Question
        title: 'In the past month, did you take: ... medicine for the heart?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1l
        kind: Question
        title: 'In the past month, did you take: ... diuretics or water pills?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1m
        kind: Question
        title: 'In the past month, did you take: ... steroids?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1p
        kind: Question
        title: 'In the past month, did you take: ... sleeping pills such as Imovane, Nytol or Starnoc?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1q
        kind: Question
        title: 'In the past month, did you take: ... stomach remedies?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1r
        kind: Question
        title: 'In the past month, did you take: ... laxatives?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1s
        kind: Question
        title: 'In the past month, did you take: ... birth control pills?'
        precondition:
        - predicate: sex == 2
        - predicate: age <= 49
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1t
        kind: Question
        title: 'In the past month, did you take: ... hormones for menopause or ageing symptoms?'
        precondition:
        - predicate: sex == 2
        - predicate: age >= 30
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1t1
        kind: Question
        title: What type of hormones are you taking?
        precondition:
        - predicate: q_med_q1t.outcome == 1
        input:
          control: Radio
          labels:
            1: Estrogen only
            2: Progesterone only
            3: Both
            4: Neither
      - id: q_med_q1t2
        kind: Question
        title: When did you start this hormone therapy?
        precondition:
        - predicate: q_med_q1t.outcome == 1
        postcondition:
        - predicate: q_med_q1t2.outcome >= 1930
          hint: Year must be 1930 or later.
        - predicate: q_med_q1t2.outcome <= 2005
          hint: Year cannot be in the future.
        input:
          control: Editbox
          min: 1900
          max: 2005
          left: 'Year:'
      - id: q_med_q1u
        kind: Question
        title: 'In the past month, did you take: ... thyroid medication such as Synthroid or Levothyroxine?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1v
        kind: Question
        title: 'In the past month, did you take: ... any other medication?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_med_q1vs
        kind: Question
        title: 'Please specify the medication:'
        precondition:
        - predicate: q_med_q1v.outcome == 1
        input:
          control: Textarea
          placeholder: Specify the medication...
          maxLength: 80
    - id: b_medication_exposure
      title: Medication Exposure
      precondition:
      - predicate: is_proxy == 0
      - predicate: sex == 2
      items:
      - id: q_mex_gave_birth
        kind: Question
        title: Have you given birth in the past 5 years?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mex_birth_year
        kind: Question
        title: In what year was your last baby born?
        precondition:
        - predicate: q_mex_gave_birth.outcome == 1
        input:
          control: Editbox
          min: 2000
          max: 2006
      - id: q_mex_folic_acid
        kind: Question
        title: Did you take a vitamin supplement containing folic acid before your last pregnancy, that is, before you found
          out that you were pregnant?
        precondition:
        - predicate: q_mex_gave_birth.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mex_breastfed
        kind: Question
        title: For your last baby, did you breastfeed or try to breastfeed your baby, even if only for a short time?
        precondition:
        - predicate: q_mex_gave_birth.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mex_no_bf_reason
        kind: Question
        title: What is the main reason that you did not breastfeed?
        precondition:
        - predicate: q_mex_breastfed.outcome == 0
        input:
          control: Dropdown
          labels:
            1: Bottle feeding easier
            2: Formula as good as breast milk
            3: Breastfeeding is unappealing/disgusting
            4: Father/partner didn't want me to
            5: Returned to work/school early
            6: C-Section
            7: Medical condition - mother
            8: Medical condition - baby
            9: Premature birth
            10: Multiple births
            11: Wanted to drink alcohol
            12: Wanted to smoke
            13: Other
      - id: q_mex_no_bf_other
        kind: Question
        title: 'Please specify the reason you did not breastfeed:'
        precondition:
        - predicate: q_mex_no_bf_reason.outcome == 13
        input:
          control: Textarea
          placeholder: Specify other reason...
          maxLength: 80
      - id: q_mex_still_bf
        kind: Question
        title: Are you still breastfeeding?
        precondition:
        - predicate: q_mex_breastfed.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mex_bf_duration
        kind: Question
        title: How long did you breastfeed your last baby?
        precondition:
        - predicate: q_mex_still_bf.outcome == 0
        input:
          control: Dropdown
          labels:
            1: Less than 1 week
            2: 1 to 2 weeks
            3: 3 to 4 weeks
            4: 5 to 8 weeks
            5: 9 weeks to less than 12 weeks
            6: 3 months
            7: 4 months
            8: 5 months
            9: 6 months
            10: 7 to 9 months
            11: 10 to 12 months
            12: More than 1 year
      - id: q_mex_added_food
        kind: Question
        title: How old was your last baby when you first added any other liquids or solid foods to the baby's feeds?
        precondition:
        - predicate: q_mex_breastfed.outcome == 1
        input:
          control: Dropdown
          labels:
            1: Less than 1 week
            2: 1 to 2 weeks
            3: 3 to 4 weeks
            4: 5 to 8 weeks
            5: 9 weeks to less than 12 weeks
            6: 3 months
            7: 4 months
            8: 5 months
            9: 6 months
            10: 7 to 9 months
            11: 10 to 12 months
            12: More than 1 year
            13: Have not added liquids or solids
      - id: q_mex_added_reason
        kind: Question
        title: What is the main reason that you first added other liquids or solid foods?
        precondition:
        - predicate: q_mex_added_food.outcome >= 1 and q_mex_added_food.outcome <= 12
        input:
          control: Dropdown
          labels:
            1: Not enough breast milk
            2: Baby was ready for solid foods
            3: Inconvenience/fatigue
            4: Difficulty with breastfeeding techniques
            5: Medical condition - mother
            6: Medical condition - baby
            7: Advice of doctor/health professional
            8: Returned to work/school
            9: Advice of partner/family/friends
            10: Formula equally healthy
            11: Wanted to drink alcohol
            12: Wanted to smoke
            13: Other
      - id: q_mex_added_other
        kind: Question
        title: 'Please specify the reason you added other liquids or solid foods:'
        precondition:
        - predicate: q_mex_added_reason.outcome == 13
        input:
          control: Textarea
          placeholder: Specify other reason...
          maxLength: 80
      - id: q_mex_vitamin_d
        kind: Question
        title: During the time when your last baby was only fed breast milk, did you give the baby a vitamin supplement containing
          Vitamin D?
        precondition:
        - predicate: q_mex_breastfed.outcome == 1
        - predicate: q_mex_added_food.outcome >= 2 or q_mex_added_food.outcome == 13
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mex_stop_bf_reason
        kind: Question
        title: What is the main reason that you stopped breastfeeding?
        precondition:
        - predicate: q_mex_breastfed.outcome == 1
        - predicate: q_mex_still_bf.outcome == 0
        input:
          control: Dropdown
          labels:
            1: Not enough breast milk
            2: Baby was ready for solid foods
            3: Inconvenience/fatigue
            4: Difficulty with breastfeeding techniques
            5: Medical condition - mother
            6: Medical condition - baby
            7: Planned to stop at this time
            8: Child weaned him/herself
            9: Advice of doctor/health professional
            10: Returned to work/school
            11: Advice of partner
            12: Formula equally healthy
            13: Wanted to drink alcohol
            14: Wanted to smoke
            15: Other
      - id: q_mex_stop_bf_other
        kind: Question
        title: 'Please specify why you stopped breastfeeding:'
        precondition:
        - predicate: q_mex_stop_bf_reason.outcome == 15
        input:
          control: Textarea
          placeholder: Specify other reason...
          maxLength: 80
      - id: q_mex_preg_smoking
        kind: Question
        title: During your last pregnancy, did you smoke daily, occasionally or not at all?
        precondition:
        - predicate: q_mex_gave_birth.outcome == 1
        - predicate: smk_status in [1, 2] or smk_100_cigs == 1 or smk_ever_whole == 1
        input:
          control: Radio
          labels:
            1: Daily
            2: Occasionally
            3: Not at all
      - id: q_mex_preg_cigs_daily
        kind: Question
        title: How many cigarettes did you usually smoke each day during your last pregnancy?
        precondition:
        - predicate: q_mex_preg_smoking.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 99
      - id: q_mex_preg_cigs_occ
        kind: Question
        title: On the days that you smoked during your last pregnancy, how many cigarettes did you usually smoke?
        precondition:
        - predicate: q_mex_preg_smoking.outcome == 2
        input:
          control: Editbox
          min: 1
          max: 99
      - id: q_mex_bf_smoking
        kind: Question
        title: When you were breastfeeding your last baby, did you smoke daily, occasionally or not at all?
        precondition:
        - predicate: q_mex_breastfed.outcome == 1
        - predicate: smk_status in [1, 2] or smk_100_cigs == 1 or smk_ever_whole == 1
        input:
          control: Radio
          labels:
            1: Daily
            2: Occasionally
            3: Not at all
      - id: q_mex_bf_cigs_daily
        kind: Question
        title: How many cigarettes did you usually smoke each day while breastfeeding?
        precondition:
        - predicate: q_mex_bf_smoking.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 99
      - id: q_mex_bf_cigs_occ
        kind: Question
        title: On the days that you smoked while breastfeeding, how many cigarettes did you usually smoke?
        precondition:
        - predicate: q_mex_bf_smoking.outcome == 2
        input:
          control: Editbox
          min: 1
          max: 99
      - id: q_mex_secondhand
        kind: Question
        title: Did anyone regularly smoke in your presence during or after the pregnancy (about 6 months after)?
        precondition:
        - predicate: q_mex_gave_birth.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mex_preg_alcohol
        kind: Question
        title: Did you drink any alcohol during your last pregnancy?
        precondition:
        - predicate: q_mex_gave_birth.outcome == 1
        - predicate: alc_past_year == 1 or alc_ever == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mex_preg_alc_freq
        kind: Question
        title: How often did you drink during your last pregnancy?
        precondition:
        - predicate: q_mex_preg_alcohol.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: Once a month
            3: 2 to 3 times a month
            4: Once a week
            5: 2 to 3 times a week
            6: 4 to 6 times a week
            7: Every day
      - id: q_mex_bf_alcohol
        kind: Question
        title: Did you drink any alcohol while you were breastfeeding your last baby?
        precondition:
        - predicate: q_mex_breastfed.outcome == 1
        - predicate: alc_past_year == 1 or alc_ever == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mex_bf_alc_freq
        kind: Question
        title: How often did you drink while breastfeeding?
        precondition:
        - predicate: q_mex_bf_alcohol.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: Once a month
            3: 2 to 3 times a month
            4: Once a week
            5: 2 to 3 times a week
            6: 4 to 6 times a week
            7: Every day

    # ===================================================================
    # SECTION: health_care
    # ===================================================================
    - id: b_health_care_satisfaction
      title: Health Care System Satisfaction
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 15
      items:
      - id: q_hcs_province_availability
        kind: Question
        title: 'Now, a few questions about health care services in your province. Overall, how would you rate the availability
          of health care services in your province? Would you say it is:'
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor
      - id: q_hcs_province_quality
        kind: Question
        title: Overall, how would you rate the quality of the health care services that are available in your province?
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor
      - id: q_hcs_community_availability
        kind: Question
        title: Overall, how would you rate the availability of health care services in your community?
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor
      - id: q_hcs_community_quality
        kind: Question
        title: Overall, how would you rate the quality of the health care services that are available in your community?
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor
    - id: b_regular_doctor_hospital
      title: Regular Doctor and Hospital Stays
      items:
      - id: q_hcu_r01
        kind: Comment
        title: Now I'd like to ask about your contacts with various health professionals during the past 12 months.
      - id: q_hcu_q01aa
        kind: Question
        title: Do you have a regular medical doctor?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_hcu_q01ab
        kind: Question
        title: Why do you not have a regular medical doctor? (Mark all that apply)
        precondition:
        - predicate: q_hcu_q01aa.outcome == 0
        input:
          control: Checkbox
          labels:
            1: No medical doctors available in the area
            2: Medical doctors in the area are not taking new patients
            4: Have not tried to contact one
            8: Had a medical doctor who left or retired
            16: Other
      - id: q_hcu_q01abs
        kind: Question
        title: Please specify the reason you do not have a regular medical doctor.
        precondition:
        - predicate: q_hcu_q01aa.outcome == 0
        - predicate: q_hcu_q01ab.outcome % 32 >= 16
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_hcu_q01ac
        kind: Question
        title: Do you and this doctor usually speak in English, in French, or in another language?
        precondition:
        - predicate: q_hcu_q01aa.outcome == 1
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
      - id: q_hcu_q01acs
        kind: Question
        title: Please specify the language.
        precondition:
        - predicate: q_hcu_q01aa.outcome == 1
        - predicate: q_hcu_q01ac.outcome == 23
        input:
          control: Textarea
          placeholder: Specify language...
          maxLength: 200
      - id: q_hcu_q01ba
        kind: Question
        title: In the past 12 months, have you been a patient overnight in a hospital, nursing home or convalescent home?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_hcu_q01bb
        kind: Question
        title: For how many nights in the past 12 months?
        precondition:
        - predicate: q_hcu_q01ba.outcome == 1
        postcondition:
        - predicate: q_hcu_q01bb.outcome <= 100
          hint: 'Warning: more than 100 nights reported. Please confirm.'
        input:
          control: Editbox
          min: 1
          max: 366
          right: nights
    - id: b_professional_contacts
      title: Contacts with Health Professionals
      items:
      - id: q_hcu_q02a
        kind: Question
        title: In the past 12 months, how many times have you seen, or talked on the telephone, about your physical, emotional
          or mental health with a family doctor, pediatrician or general practitioner?
        postcondition:
        - predicate: q_hcu_q02a.outcome <= 12
          hint: 'Warning: more than 12 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 366
          right: times
      - id: q_hcu_q02b
        kind: Question
        title: How many times have you seen an eye specialist (such as an ophthalmologist or optometrist)?
        postcondition:
        - predicate: q_hcu_q02b.outcome <= 3
          hint: 'Warning: more than 3 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 75
          right: times
      - id: q_hcu_q02c
        kind: Question
        title: How many times have you seen any other medical doctor (such as a surgeon, allergist, orthopedist, gynaecologist
          or psychiatrist)?
        postcondition:
        - predicate: q_hcu_q02c.outcome <= 7
          hint: 'Warning: more than 7 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 300
          right: times
      - id: q_hcu_q02d
        kind: Question
        title: How many times have you seen a nurse for care or advice?
        postcondition:
        - predicate: q_hcu_q02d.outcome <= 15
          hint: 'Warning: more than 15 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 366
          right: times
      - id: q_hcu_q02e
        kind: Question
        title: How many times have you seen a dentist or orthodontist?
        postcondition:
        - predicate: q_hcu_q02e.outcome <= 4
          hint: 'Warning: more than 4 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 99
          right: times
      - id: q_hcu_q02f
        kind: Question
        title: How many times have you seen a chiropractor?
        postcondition:
        - predicate: q_hcu_q02f.outcome <= 20
          hint: 'Warning: more than 20 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 366
          right: times
      - id: q_hcu_q02g
        kind: Question
        title: How many times have you seen a physiotherapist?
        postcondition:
        - predicate: q_hcu_q02g.outcome <= 30
          hint: 'Warning: more than 30 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 366
          right: times
      - id: q_hcu_q02h
        kind: Question
        title: How many times have you seen a social worker or counsellor?
        postcondition:
        - predicate: q_hcu_q02h.outcome <= 20
          hint: 'Warning: more than 20 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 366
          right: times
      - id: q_hcu_q02i
        kind: Question
        title: How many times have you seen a psychologist?
        postcondition:
        - predicate: q_hcu_q02i.outcome <= 25
          hint: 'Warning: more than 25 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 366
          right: times
      - id: q_hcu_q02j
        kind: Question
        title: How many times have you seen a speech, audiology or occupational therapist?
        postcondition:
        - predicate: q_hcu_q02j.outcome <= 12
          hint: 'Warning: more than 12 visits reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 200
          right: times
        codeBlock: |
          if q_hcu_q01ba.outcome == 1:
              had_health_contact = 1
          if q_hcu_q02a.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02b.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02c.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02d.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02e.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02f.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02g.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02h.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02i.outcome > 0:
              had_health_contact = 1
          if q_hcu_q02j.outcome > 0:
              had_health_contact = 1
    - id: b_contact_location
      title: Location of Most Recent Contact
      precondition:
      - predicate: q_hcu_q02a.outcome > 0 or q_hcu_q02c.outcome > 0 or q_hcu_q02d.outcome > 0
      items:
      - id: q_hcu_q03
        kind: Question
        title: Where did the most recent contact take place?
        input:
          control: Dropdown
          labels:
            1: Doctor's office
            2: Hospital emergency room
            3: Hospital outpatient clinic
            4: Walk-in clinic
            5: Appointment clinic
            6: Community health centre / CLSC
            7: At work
            8: At school
            9: At home
            10: Telephone consultation only
            11: Other
      - id: q_hcu_q03s
        kind: Question
        title: Please specify the location of the most recent contact.
        precondition:
        - predicate: q_hcu_q03.outcome == 11
        input:
          control: Textarea
          placeholder: Specify location...
          maxLength: 200
      - id: q_hcu_q03_1
        kind: Question
        title: 'Did this most recent contact occur:'
        precondition:
        - predicate: q_hcu_q03.outcome in [3, 5, 6]
        input:
          control: Radio
          labels:
            1: In-person (face-to-face)
            2: Through a videoconference
            3: Through another method
    - id: b_selfhelp_alternative
      title: Self-Help and Alternative Care
      items:
      - id: q_hcu_q04a
        kind: Question
        title: In the past 12 months, have you attended a meeting of a self-help group such as AA or a cancer support group?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_hcu_q04
        kind: Question
        title: In the past 12 months, have you seen or talked to an alternative health care provider such as an acupuncturist,
          homeopath or massage therapist about your physical, emotional or mental health?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_hcu_q05
        kind: Question
        title: Who did you see or talk to? (Mark all that apply)
        precondition:
        - predicate: q_hcu_q04.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Massage therapist
            2: Acupuncturist
            4: Homeopath or naturopath
            8: Feldenkrais or Alexander teacher
            16: Relaxation therapist
            32: Biofeedback teacher
            64: Rolfer
            128: Herbalist
            256: Reflexologist
            512: Spiritual healer
            1024: Religious healer
            2048: Other
      - id: q_hcu_q05s
        kind: Question
        title: Please specify the alternative health care provider.
        precondition:
        - predicate: q_hcu_q04.outcome == 1
        - predicate: q_hcu_q05.outcome % 4096 >= 2048
        input:
          control: Textarea
          placeholder: Specify alternative provider...
          maxLength: 200
    - id: b_unmet_needs
      title: Unmet Health Care Needs
      items:
      - id: q_hcu_q06
        kind: Question
        title: During the past 12 months, was there ever a time when you felt that you needed health care but you didn't receive
          it?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_hcu_q07
        kind: Question
        title: Thinking of the most recent time, why didn't you get care? (Mark all that apply)
        precondition:
        - predicate: q_hcu_q06.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Not available in the area
            2: Not available at time required
            4: Waiting time too long
            8: Felt would be inadequate
            16: Cost
            32: Too busy
            64: Didn't get around to it / didn't bother
            128: Didn't know where to go
            256: Transportation problems
            512: Language problems
            1024: Personal or family responsibilities
            2048: Dislikes doctors / afraid
            4096: Decided not to seek care
            8192: Doctor didn't think it was necessary
            16384: Unable to leave the house because of a health problem
            32768: Other
      - id: q_hcu_q07s
        kind: Question
        title: Please specify the reason for not getting care.
        precondition:
        - predicate: q_hcu_q06.outcome == 1
        - predicate: q_hcu_q07.outcome % 65536 >= 32768
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_hcu_q08
        kind: Question
        title: Again, thinking of the most recent time, what was the type of care that was needed? (Mark all that apply)
        precondition:
        - predicate: q_hcu_q06.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Treatment of a physical health problem
            2: Treatment of an emotional or mental health problem
            4: A regular check-up (including regular pre-natal care)
            8: Care of an injury
            16: Other
      - id: q_hcu_q08s
        kind: Question
        title: Please specify the type of care needed.
        precondition:
        - predicate: q_hcu_q06.outcome == 1
        - predicate: q_hcu_q08.outcome % 32 >= 16
        input:
          control: Textarea
          placeholder: Specify type of care...
          maxLength: 200
      - id: q_hcu_q09
        kind: Question
        title: Where did you try to get the service you were seeking? (Mark all that apply)
        precondition:
        - predicate: q_hcu_q06.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Doctor's office
            2: Hospital emergency room
            4: Hospital overnight patient
            8: Hospital outpatient clinic
            16: Walk-in clinic
            32: Appointment clinic
            64: Community health centre / CLSC
            128: Other
      - id: q_hcu_q09s
        kind: Question
        title: Please specify the location where you tried to get the service.
        precondition:
        - predicate: q_hcu_q06.outcome == 1
        - predicate: q_hcu_q09.outcome % 256 >= 128
        input:
          control: Textarea
          placeholder: Specify location...
          maxLength: 200
    - id: b_government_home_care
      title: Government-Covered Home Care
      precondition:
      - predicate: age >= 18
      items:
      - id: q_hmc_r09
        kind: Comment
        title: Now some questions on home care services. These are health care, homemaker or other support services received
          at home.
      - id: q_hmc_q09
        kind: Question
        title: Have you received any home care services in the past 12 months, with the cost being entirely or partially covered
          by government?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_hmc_q10
        kind: Question
        title: What type of services have you received? (Mark all that apply. Cost must be entirely or partially covered by
          government.)
        precondition:
        - predicate: q_hmc_q09.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Nursing care
            2: Other health care services
            4: Medical equipment or supplies
            8: Personal care
            16: Housework
            32: Meal preparation or delivery
            64: Shopping
            128: Respite care
            256: Other
      - id: q_hmc_q10s
        kind: Question
        title: Please specify the type of government-covered home care service.
        precondition:
        - predicate: q_hmc_q09.outcome == 1
        - predicate: q_hmc_q10.outcome % 512 >= 256
        input:
          control: Textarea
          placeholder: Specify service type...
          maxLength: 200
    - id: b_private_home_care
      title: Non-Government Home Care
      precondition:
      - predicate: age >= 18
      items:
      - id: q_hmc_q11
        kind: Question
        title: 'Have you received any other home care services in the past 12 months, with the cost not covered by government
          (for example: care provided by a private agency or by a spouse or friends)?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_hmc_q12
        kind: Question
        title: Who provided these home care services? (Mark all that apply)
        precondition:
        - predicate: q_hmc_q11.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Nurse from a private agency
            2: Homemaker or other support services from a private agency
            4: Physiotherapist or other therapist from a private agency
            8: Neighbour or friend
            16: Family member or spouse
            32: Volunteer
            64: Other
      - id: q_hmc_q12s
        kind: Question
        title: Please specify the other provider of home care.
        precondition:
        - predicate: q_hmc_q11.outcome == 1
        - predicate: q_hmc_q12.outcome % 128 >= 64
        input:
          control: Textarea
          placeholder: Specify provider...
          maxLength: 200
      - id: q_hmc_q13
        kind: Question
        title: What type of services have you received from your non-government home care providers? (Mark all that apply)
        precondition:
        - predicate: q_hmc_q11.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Nursing care
            2: Other health care services
            4: Medical equipment or supplies
            8: Personal care
            16: Housework
            32: Meal preparation or delivery
            64: Shopping
            128: Respite care
            256: Other
      - id: q_hmc_q13s
        kind: Question
        title: Please specify the other type of service from non-government provider.
        precondition:
        - predicate: q_hmc_q11.outcome == 1
        - predicate: q_hmc_q13.outcome % 512 >= 256
        input:
          control: Textarea
          placeholder: Specify service type...
          maxLength: 200
    - id: b_unmet_home_care
      title: Unmet Home Care Needs
      precondition:
      - predicate: age >= 18
      items:
      - id: q_hmc_q14
        kind: Question
        title: During the past 12 months, was there ever a time when you felt that you needed home care services but you didn't
          receive them?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_hmc_q15
        kind: Question
        title: Thinking of the most recent time, why didn't you get these services? (Mark all that apply)
        precondition:
        - predicate: q_hmc_q14.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Not available in the area
            2: Not available at time required
            4: Waiting time too long
            8: Felt would be inadequate
            16: Cost
            32: Too busy
            64: Didn't get around to it / didn't bother
            128: Didn't know where to go / call
            256: Language problems
            512: Personal or family responsibilities
            1024: Decided not to seek services
            2048: Doctor did not think it was necessary
            4096: Did not qualify / not eligible for homecare
            8192: Still waiting for homecare
            16384: Other
      - id: q_hmc_q15s
        kind: Question
        title: Please specify the reason for not getting home care.
        precondition:
        - predicate: q_hmc_q14.outcome == 1
        - predicate: q_hmc_q15.outcome % 32768 >= 16384
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_hmc_q16
        kind: Question
        title: Again, thinking of the most recent time, what type of home care was needed? (Mark all that apply)
        precondition:
        - predicate: q_hmc_q14.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Nursing care
            2: Other health care services
            4: Medical equipment or supplies
            8: Personal care
            16: Housework
            32: Meal preparation or delivery
            64: Shopping
            128: Respite care
            256: Other
      - id: q_hmc_q16s
        kind: Question
        title: Please specify the type of home care needed.
        precondition:
        - predicate: q_hmc_q14.outcome == 1
        - predicate: q_hmc_q16.outcome % 512 >= 256
        input:
          control: Textarea
          placeholder: Specify type of care...
          maxLength: 200
      - id: q_hmc_q17
        kind: Question
        title: Where did you try to get this home care service? (Mark all that apply)
        precondition:
        - predicate: q_hmc_q14.outcome == 1
        input:
          control: Checkbox
          labels:
            1: A government sponsored program
            2: A private agency
            4: A family member, friend or neighbour
            8: A volunteer organization
            16: Other
    - id: b_overall_satisfaction
      title: Overall Health Care Satisfaction
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 15
      items:
      - id: q_pas_r1
        kind: Comment
        title: Earlier, I asked about your use of health care services in the past 12 months. Now I'd like to get your opinion
          on the quality of the care you received.
      - id: q_pas_q11
        kind: Question
        title: In the past 12 months, have you received any health care services?
        precondition:
        - predicate: had_health_contact == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_pas_q12
        kind: Question
        title: Overall, how would you rate the quality of the health care you received?
        precondition:
        - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor
      - id: q_pas_q13
        kind: Question
        title: Overall, how satisfied were you with the way health care services were provided?
        precondition:
        - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Somewhat satisfied
            3: Neither satisfied nor dissatisfied
            4: Somewhat dissatisfied
            5: Very dissatisfied
    - id: b_hospital_satisfaction
      title: Hospital Care Satisfaction
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 15
      - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
      items:
      - id: q_pas_q21a
        kind: Question
        title: In the past 12 months, have you received any health care services at a hospital, for any diagnostic or day surgery
          service, overnight stay, or as an emergency room patient?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_pas_q21b
        kind: Question
        title: 'Thinking of your most recent hospital visit, were you:'
        precondition:
        - predicate: q_pas_q21a.outcome == 1
        input:
          control: Radio
          labels:
            1: Admitted overnight or longer (inpatient)
            2: Patient at a diagnostic or day surgery clinic (outpatient)
            3: Emergency room patient
      - id: q_pas_q22
        kind: Question
        title: Thinking of this most recent hospital visit, how would you rate the quality of the care you received?
        precondition:
        - predicate: q_pas_q21a.outcome == 1
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor
      - id: q_pas_q23
        kind: Question
        title: Thinking of this most recent hospital visit, how satisfied were you with the way hospital services were provided?
        precondition:
        - predicate: q_pas_q21a.outcome == 1
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Somewhat satisfied
            3: Neither satisfied nor dissatisfied
            4: Somewhat dissatisfied
            5: Very dissatisfied
    - id: b_physician_satisfaction
      title: Physician Care Satisfaction
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 15
      - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
      items:
      - id: q_pas_q31a
        kind: Question
        title: In the past 12 months, not counting hospital visits, have you received any health care services from a family
          doctor or other physician?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_pas_q31b
        kind: Question
        title: 'Thinking of the most recent time, was care provided by:'
        precondition:
        - predicate: q_pas_q31a.outcome == 1
        input:
          control: Radio
          labels:
            1: A family doctor (general practitioner)
            2: A medical specialist
      - id: q_pas_q32
        kind: Question
        title: Thinking of this most recent care from a physician, how would you rate the quality of the care you received?
        precondition:
        - predicate: q_pas_q31a.outcome == 1
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor
      - id: q_pas_q33
        kind: Question
        title: Thinking of this most recent care from a physician, how satisfied were you with the way physician care was provided?
        precondition:
        - predicate: q_pas_q31a.outcome == 1
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Somewhat satisfied
            3: Neither satisfied nor dissatisfied
            4: Somewhat dissatisfied
            5: Very dissatisfied
    - id: b_community_satisfaction
      title: Community-Based Care Satisfaction
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 15
      - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
      items:
      - id: q_pas_r2
        kind: Comment
        title: 'The next questions are about community-based health care which includes any health care received outside of
          a hospital or doctor''s office. Examples are: home nursing care, home-based counselling or therapy, personal care
          and community walk-in clinics.'
      - id: q_pas_q41
        kind: Question
        title: In the past 12 months, have you received any community-based care?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_pas_q42
        kind: Question
        title: Overall, how would you rate the quality of the community-based care you received?
        precondition:
        - predicate: q_pas_q41.outcome == 1
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor
      - id: q_pas_q43
        kind: Question
        title: Overall, how satisfied were you with the way community-based care was provided?
        precondition:
        - predicate: q_pas_q41.outcome == 1
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Somewhat satisfied
            3: Neither satisfied nor dissatisfied
            4: Somewhat dissatisfied
            5: Very dissatisfied
    - id: b_telehealth_satisfaction
      title: Telehealth Satisfaction
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 15
      items:
      - id: q_pas_q51
        kind: Question
        title: In the past 12 months, have you used a telephone health line or telehealth service?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_pas_q52
        kind: Question
        title: Overall, how would you rate the quality of the service you received?
        precondition:
        - predicate: q_pas_q51.outcome == 1
        input:
          control: Radio
          labels:
            1: Excellent
            2: Good
            3: Fair
            4: Poor

    # ===================================================================
    # SECTION: activity_limitations
    # ===================================================================
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

    # ===================================================================
    # SECTION: preventive_screening
    # ===================================================================
    - id: b_flu
      title: Flu Shots
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_flu_q160
        kind: Question
        title: Now a few questions about your use of various health care services. Have you ever had a flu shot?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_flu_q162
        kind: Question
        title: When did you have your last flu shot?
        precondition:
        - predicate: q_flu_q160.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 1 year ago
            2: 1 year to less than 2 years ago
            3: 2 years ago or more
      - id: q_flu_q166
        kind: Question
        title: What are the reasons that you have not had a flu shot in the past year?
        precondition:
        - predicate: q_flu_q160.outcome == 0 or (q_flu_q160.outcome == 1 and q_flu_q162.outcome in [2, 3])
        input:
          control: Checkbox
          labels:
            1: Have not gotten around to it
            2: Respondent did not think it was necessary
            4: Doctor did not think it was necessary
            8: Personal or family responsibilities
            16: Not available at time required
            32: Not available at all in the area
            64: Waiting time was too long
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go / uninformed
            2048: Fear (e.g., painful, embarrassing, find something wrong)
            4096: Bad reaction to previous shot
            8192: Unable to leave the house because of a health problem
            16384: Other - Specify
      - id: q_flu_q166s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_flu_q166.outcome % 32768 >= 16384
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_bpc
      title: Blood Pressure Check
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_bpc_q010
        kind: Question
        title: Have you ever had your blood pressure taken?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_bpc_q012
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_bpc_q010.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 6 months ago
            2: 6 months to less than 1 year ago
            3: 1 year to less than 2 years ago
            4: 2 years to less than 5 years ago
            5: 5 or more years ago
      - id: q_bpc_q016
        kind: Question
        title: What are the reasons that you have not had your blood pressure taken in the past 2 years?
        precondition:
        - predicate: age >= 25
        - predicate: q_bpc_q010.outcome == 0 or (q_bpc_q010.outcome == 1 and q_bpc_q012.outcome in [4, 5])
        input:
          control: Checkbox
          labels:
            1: Have not gotten around to it
            2: Respondent did not think it was necessary
            4: Doctor did not think it was necessary
            8: Personal or family responsibilities
            16: Not available at time required
            32: Not available at all in the area
            64: Waiting time was too long
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go / uninformed
            2048: Fear (e.g., painful, embarrassing, find something wrong)
            4096: Unable to leave the house because of a health problem
            8192: Other - Specify
      - id: q_bpc_q016s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_bpc_q016.outcome % 16384 >= 8192
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_pap
      title: Pap Smear Test
      precondition:
      - predicate: is_proxy == 0
      - predicate: sex == 2
      - predicate: age >= 18
      items:
      - id: q_pap_q020
        kind: Question
        title: Have you ever had a PAP smear test?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_pap_q022
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_pap_q020.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 6 months ago
            2: 6 months to less than 1 year ago
            3: 1 year to less than 3 years ago
            4: 3 years to less than 5 years ago
            5: 5 or more years ago
      - id: q_pap_q026
        kind: Question
        title: What are the reasons that you have not had a PAP smear test in the past 3 years?
        precondition:
        - predicate: q_pap_q020.outcome == 0 or (q_pap_q020.outcome == 1 and q_pap_q022.outcome in [4, 5])
        input:
          control: Checkbox
          labels:
            1: Have not gotten around to it
            2: Respondent did not think it was necessary
            4: Doctor did not think it was necessary
            8: Personal or family responsibilities
            16: Not available at time required
            32: Not available at all in the area
            64: Waiting time was too long
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go / uninformed
            2048: Fear (e.g., painful, embarrassing, find something wrong)
            4096: Have had a hysterectomy
            8192: Hate / dislike having one done
            16384: Unable to leave the house because of a health problem
            32768: Other - Specify
      - id: q_pap_q026s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_pap_q026.outcome % 65536 >= 32768
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_mam
      title: Mammography
      precondition:
      - predicate: is_proxy == 0
      - predicate: sex == 2
      items:
      - id: q_mam_q030
        kind: Question
        title: Have you ever had a mammogram, that is, a breast x-ray?
        precondition:
        - predicate: age >= 35
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mam_q031
        kind: Question
        title: Why did you have it?
        precondition:
        - predicate: q_mam_q030.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Family history of breast cancer
            2: Part of regular check-up / routine screening
            4: Age
            8: Previously detected lump
            16: Follow-up of breast cancer treatment
            32: On hormone replacement therapy
            64: Breast problem
            128: Other - Specify
      - id: q_mam_q031s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_mam_q031.outcome % 256 >= 128
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
      - id: q_mam_q032
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_mam_q030.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 6 months ago
            2: 6 months to less than 1 year ago
            3: 1 year to less than 2 years ago
            4: 2 years to less than 5 years ago
            5: 5 or more years ago
      - id: q_mam_q036
        kind: Question
        title: What are the reasons you have not had one in the past 2 years?
        precondition:
        - predicate: age >= 50 and age <= 69
        - predicate: q_mam_q030.outcome == 0 or (q_mam_q030.outcome == 1 and q_mam_q032.outcome in [4, 5])
        input:
          control: Checkbox
          labels:
            1: Have not gotten around to it
            2: Respondent did not think it was necessary
            4: Doctor did not think it was necessary
            8: Personal or family responsibilities
            16: Not available at time required
            32: Not available at all in the area
            64: Waiting time was too long
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go / uninformed
            2048: Fear (e.g., painful, embarrassing, find something wrong)
            4096: Unable to leave the house because of a health problem
            8192: Breasts removed / Mastectomy
            16384: Other - Specify
      - id: q_mam_q036s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_mam_q036.outcome % 32768 >= 16384
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
      - id: q_mam_q037
        kind: Question
        title: It is important to know when analyzing health whether or not the person is pregnant. Are you pregnant?
        precondition:
        - predicate: age >= 15 and age <= 49
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mam_q038
        kind: Question
        title: Have you had a hysterectomy? (In other words, has your uterus been removed?)
        precondition:
        - predicate: age >= 18
        - predicate: q_pap_q026.outcome % 8192 < 4096
        - predicate: q_mam_q037.outcome == 0 or age > 49 or age < 15
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_brx
      title: Breast Examinations
      precondition:
      - predicate: is_proxy == 0
      - predicate: sex == 2
      - predicate: age >= 18
      items:
      - id: q_brx_q110
        kind: Question
        title: Other than a mammogram, have you ever had your breasts examined for lumps (tumours, cysts) by a doctor or other
          health professional?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_brx_q112
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_brx_q110.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 6 months ago
            2: 6 months to less than 1 year ago
            3: 1 year to less than 2 years ago
            4: 2 years to less than 5 years ago
            5: 5 or more years ago
      - id: q_brx_q116
        kind: Question
        title: What are the reasons that you have not had a breast exam in the past 2 years?
        precondition:
        - predicate: q_brx_q110.outcome == 0 or (q_brx_q110.outcome == 1 and q_brx_q112.outcome in [4, 5])
        input:
          control: Checkbox
          labels:
            1: Have not gotten around to it
            2: Respondent did not think it was necessary
            4: Doctor did not think it was necessary
            8: Personal or family responsibilities
            16: Not available at time required
            32: Not available at all in the area
            64: Waiting time was too long
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go / uninformed
            2048: Fear (e.g., painful, embarrassing, find something wrong)
            4096: Unable to leave the house because of a health problem
            8192: Breasts removed / mastectomy
            16384: Other - Specify
      - id: q_brx_q116s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_brx_q116.outcome % 32768 >= 16384
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_bsx
      title: Breast Self-Examinations
      precondition:
      - predicate: is_proxy == 0
      - predicate: sex == 2
      - predicate: age >= 18
      items:
      - id: q_bsx_q120
        kind: Question
        title: Have you ever examined your breasts for lumps (tumours, cysts)?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_bsx_q121
        kind: Question
        title: How often?
        precondition:
        - predicate: q_bsx_q120.outcome == 1
        input:
          control: Radio
          labels:
            1: At least once a month
            2: Once every 2 to 3 months
            3: Less often than every 2 to 3 months
      - id: q_bsx_q122
        kind: Question
        title: How did you learn to do this?
        precondition:
        - predicate: q_bsx_q120.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Doctor
            2: Nurse
            4: Book / magazine / pamphlet
            8: TV / video / film
            16: Family member (e.g., mother, sister, cousin)
            32: Other - Specify
      - id: q_bsx_q122s
        kind: Question
        title: Please specify the other source.
        precondition:
        - predicate: q_bsx_q122.outcome % 64 >= 32
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_eyx
      title: Eye Examinations
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_eyx_q140
        kind: Question
        title: It was reported earlier that you have seen or talked to an optometrist or ophthalmologist in the past 12 months.
          Did you actually visit one?
        precondition:
        - predicate: hcu_q02b_eye_doctor >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_eyx_q142
        kind: Question
        title: When did you last have an eye examination?
        input:
          control: Radio
          labels:
            1: Less than 1 year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 or more years ago
            5: Never
      - id: q_eyx_q146
        kind: Question
        title: What are the reasons that you have not had an eye examination in the past 2 years?
        precondition:
        - predicate: q_eyx_q142.outcome in [3, 4, 5]
        input:
          control: Checkbox
          labels:
            1: Have not gotten around to it
            2: Respondent did not think it was necessary
            4: Doctor did not think it was necessary
            8: Personal or family responsibilities
            16: Not available at time required
            32: Not available at all in the area
            64: Waiting time was too long
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go / uninformed
            2048: Fear (e.g., painful, embarrassing, find something wrong)
            4096: Unable to leave the house because of a health problem
            8192: Other - Specify
      - id: q_eyx_q146s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_eyx_q146.outcome % 16384 >= 8192
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_pcu
      title: Physical Check-Up
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_pcu_q150
        kind: Question
        title: Have you ever had a physical check-up without having a specific health problem?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_pcu_q151
        kind: Question
        title: Have you ever had one during a visit for a health problem?
        precondition:
        - predicate: q_pcu_q150.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_pcu_q152
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_pcu_q150.outcome == 1 or q_pcu_q151.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 1 year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 years to less than 4 years ago
            5: 4 years to less than 5 years ago
            6: 5 or more years ago
      - id: q_pcu_q156
        kind: Question
        title: What are the reasons that you have not had a check-up in the past 3 years?
        precondition:
        - predicate: (q_pcu_q150.outcome == 0 and q_pcu_q151.outcome == 0) or q_pcu_q152.outcome in [4, 5, 6]
        input:
          control: Checkbox
          labels:
            1: Have not gotten around to it
            2: Respondent did not think it was necessary
            4: Doctor did not think it was necessary
            8: Personal or family responsibilities
            16: Not available at time required
            32: Not available at all in the area
            64: Waiting time was too long
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go / uninformed
            2048: Fear (e.g., painful, embarrassing, find something wrong)
            4096: Unable to leave the house because of a health problem
            8192: Other - Specify
      - id: q_pcu_q156s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_pcu_q156.outcome % 16384 >= 8192
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_psa
      title: Prostate Cancer Screening
      precondition:
      - predicate: is_proxy == 0
      - predicate: sex == 1
      - predicate: age >= 35
      items:
      - id: q_psa_q170
        kind: Question
        title: Have you ever had a prostate specific antigen test for prostate cancer, that is, a PSA blood test?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_psa_q172
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_psa_q170.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 1 year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 years to less than 5 years ago
            5: 5 or more years ago
      - id: q_psa_q173
        kind: Question
        title: Why did you have it?
        precondition:
        - predicate: q_psa_q170.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Family history of prostate cancer
            2: Part of regular check-up / routine screening
            4: Age
            8: Race
            16: Follow-up of problem
            32: Follow-up of prostate cancer treatment
            64: Other - Specify
      - id: q_psa_q173s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_psa_q173.outcome % 128 >= 64
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
      - id: q_psa_q174
        kind: Question
        title: A Digital Rectal Exam is an exam in which a gloved finger is inserted into the rectum in order to feel the prostate
          gland. Have you ever had this exam?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_psa_q175
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_psa_q174.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 1 year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 years to less than 5 years ago
            5: 5 or more years ago
    - id: b_ccs
      title: Colorectal Cancer Screening
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 35
      items:
      - id: q_ccs_q180
        kind: Question
        title: An FOBT is a test to check for blood in your stool, where you have a bowel movement and use a stick to smear
          a small sample on a special card. Have you ever had this test?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ccs_q182
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_ccs_q180.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 1 year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 years to less than 5 years ago
            5: 5 years to less than 10 years ago
            6: 10 or more years ago
      - id: q_ccs_q183
        kind: Question
        title: Why did you have it?
        precondition:
        - predicate: q_ccs_q180.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Family history of colorectal cancer
            2: Part of regular check-up / routine screening
            4: Age
            8: Race
            16: Follow-up of problem
            32: Follow-up of colorectal cancer treatment
            64: Other - Specify
      - id: q_ccs_q183s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_ccs_q183.outcome % 128 >= 64
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
      - id: q_ccs_q184
        kind: Question
        title: A colonoscopy or sigmoidoscopy is when a tube is inserted into the rectum to view the bowel for early signs of
          cancer and other health problems. Have you ever had either of these exams?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ccs_q185
        kind: Question
        title: When was the last time?
        precondition:
        - predicate: q_ccs_q184.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than 1 year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 years to less than 5 years ago
            5: 5 years to less than 10 years ago
            6: 10 or more years ago
      - id: q_ccs_q186
        kind: Question
        title: Why did you have it?
        precondition:
        - predicate: q_ccs_q184.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Family history of colorectal cancer
            2: Part of regular check-up / routine screening
            4: Age
            8: Race
            16: Follow-up of problem
            32: Follow-up of colorectal cancer treatment
            64: Other - Specify
      - id: q_ccs_q186s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_ccs_q186.outcome % 128 >= 64
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
      - id: q_ccs_q187
        kind: Question
        title: Was the colonoscopy or sigmoidoscopy a follow-up of the results of an FOBT?
        precondition:
        - predicate: q_ccs_q180.outcome == 1
        - predicate: q_ccs_q184.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_den
      title: Dental Visits
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_den_q130
        kind: Question
        title: Now dental visits. It was reported earlier that you have seen or talked to a dentist in the past 12 months. Did
          you actually visit one?
        precondition:
        - predicate: hcu_q02e_dentist >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_den_r132
        kind: Comment
        title: Now dental visits.
        precondition:
        - predicate: hcu_q02e_dentist == 0
      - id: q_den_q132
        kind: Question
        title: When was the last time that you went to a dentist?
        precondition:
        - predicate: hcu_q02e_dentist == 0 or q_den_q130.outcome == 0
        input:
          control: Radio
          labels:
            1: Less than 1 year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 years to less than 4 years ago
            5: 4 years to less than 5 years ago
            6: 5 or more years ago
            7: Never
      - id: q_den_q136
        kind: Question
        title: What are the reasons that you have not been to a dentist in the past 3 years?
        precondition:
        - predicate: q_den_q132.outcome in [4, 5, 6, 7]
        input:
          control: Checkbox
          labels:
            1: Have not gotten around to it
            2: Respondent did not think it was necessary
            4: Dentist did not think it was necessary
            8: Personal or family responsibilities
            16: Not available at time required
            32: Not available at all in the area
            64: Waiting time was too long
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go / uninformed
            2048: Fear (e.g., painful, embarrassing, find something wrong)
            4096: Wears dentures
            8192: Unable to leave the house because of a health problem
            16384: Other - Specify
      - id: q_den_q136s
        kind: Question
        title: Please specify the other reason.
        precondition:
        - predicate: q_den_q136.outcome % 32768 >= 16384
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200

    # ===================================================================
    # SECTION: nutrition
    # ===================================================================
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

    # ===================================================================
    # SECTION: physical_activity
    # ===================================================================
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

    # ===================================================================
    # SECTION: smoking_tobacco
    # ===================================================================
    - id: b_sun_safety
      title: Sun Safety Behaviours
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_ssb_intro
        kind: Comment
        title: The next few questions are about exposure to the sun and sunburns. Sunburn is defined as any reddening or discomfort
          of the skin, that lasts longer than 12 hours after exposure to the sun or other UV sources, such as tanning beds or
          sun lamps.
      - id: q_ssb_sunburnt
        kind: Question
        title: In the past 12 months, has any part of your body been sunburnt?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ssb_blister
        kind: Question
        title: Did any of your sunburns involve blistering?
        precondition:
        - predicate: q_ssb_sunburnt.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ssb_pain
        kind: Question
        title: Did any of your sunburns involve pain or discomfort that lasted for more than 1 day?
        precondition:
        - predicate: q_ssb_sunburnt.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ssb_weekend_intro
        kind: Comment
        title: For the next questions, think about a typical weekend, or day off from work or school in the summer months.
      - id: q_ssb_time_in_sun
        kind: Question
        title: About how much time each day do you spend in the sun between 11 am and 4 pm?
        input:
          control: Radio
          labels:
            1: None
            2: Less than 30 minutes
            3: 30 to 59 minutes
            4: 1 hour to less than 2 hours
            5: 2 hours to less than 3 hours
            6: 3 hours to less than 4 hours
            7: 4 hours to less than 5 hours
            8: 5 hours
      - id: q_ssb_shade
        kind: Question
        title: In the summer months, on a typical weekend or day off, when you are in the sun for 30 minutes or more, how often
          do you seek shade?
        precondition:
        - predicate: q_ssb_time_in_sun.outcome >= 3
        input:
          control: Radio
          labels:
            1: Always
            2: Often
            3: Sometimes
            4: Rarely
            5: Never
      - id: q_ssb_hat
        kind: Question
        title: How often do you wear a hat that shades your face, ears and neck?
        precondition:
        - predicate: q_ssb_time_in_sun.outcome >= 3
        input:
          control: Radio
          labels:
            1: Always
            2: Often
            3: Sometimes
            4: Rarely
            5: Never
      - id: q_ssb_long_clothing
        kind: Question
        title: How often do you wear long pants or a long skirt to protect your skin from the sun?
        precondition:
        - predicate: q_ssb_time_in_sun.outcome >= 3
        input:
          control: Radio
          labels:
            1: Always
            2: Often
            3: Sometimes
            4: Rarely
            5: Never
      - id: q_ssb_sunscreen_face
        kind: Question
        title: How often do you use sunscreen on your face?
        precondition:
        - predicate: q_ssb_time_in_sun.outcome >= 3
        input:
          control: Radio
          labels:
            1: Always
            2: Often
            3: Sometimes
            4: Rarely
            5: Never
      - id: q_ssb_spf_face
        kind: Question
        title: What Sun Protection Factor (SPF) do you usually use on your face?
        precondition:
        - predicate: q_ssb_sunscreen_face.outcome in [1, 2, 3]
        input:
          control: Radio
          labels:
            1: Less than 15
            2: 15 to 25
            3: More than 25
      - id: q_ssb_sunscreen_body
        kind: Question
        title: How often do you use sunscreen on your body?
        precondition:
        - predicate: q_ssb_time_in_sun.outcome >= 3
        input:
          control: Radio
          labels:
            1: Always
            2: Often
            3: Sometimes
            4: Rarely
            5: Never
      - id: q_ssb_spf_body
        kind: Question
        title: What Sun Protection Factor (SPF) do you usually use on your body?
        precondition:
        - predicate: q_ssb_sunscreen_body.outcome in [1, 2, 3]
        input:
          control: Radio
          labels:
            1: Less than 15
            2: 15 to 25
            3: More than 25
    - id: b_smoking
      title: Smoking
      items:
      - id: q_smk_intro
        kind: Comment
        title: The next questions are about smoking.
      - id: q_smk_100_cigs
        kind: Question
        title: In your lifetime, have you smoked a total of 100 or more cigarettes (about 4 packs)?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_smk_ever_whole
        kind: Question
        title: Have you ever smoked a whole cigarette?
        precondition:
        - predicate: q_smk_100_cigs.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_smk_age_first
        kind: Question
        title: At what age did you smoke your first whole cigarette?
        precondition:
        - predicate: q_smk_100_cigs.outcome == 1 or q_smk_ever_whole.outcome == 1
        postcondition:
        - predicate: q_smk_age_first.outcome >= 5
          hint: Age must be at least 5.
        - predicate: q_smk_age_first.outcome <= age
          hint: Age first smoked cannot exceed current age.
        input:
          control: Editbox
          min: 1
          max: 120
      - id: q_smk_status
        kind: Question
        title: At the present time, do you smoke cigarettes daily, occasionally or not at all?
        input:
          control: Radio
          labels:
            1: Daily
            2: Occasionally
            3: Not at all
      - id: q_smk_age_daily
        kind: Question
        title: At what age did you begin to smoke cigarettes daily?
        precondition:
        - predicate: q_smk_status.outcome == 1
        postcondition:
        - predicate: q_smk_age_daily.outcome >= 5
          hint: Age must be at least 5.
        - predicate: q_smk_age_daily.outcome <= age
          hint: Age began daily smoking cannot exceed current age.
        input:
          control: Editbox
          min: 1
          max: 120
      - id: q_smk_cigs_per_day
        kind: Question
        title: How many cigarettes do you smoke each day now?
        precondition:
        - predicate: q_smk_status.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 99
      - id: q_smk_cigs_occasional
        kind: Question
        title: On the days that you do smoke, how many cigarettes do you usually smoke?
        precondition:
        - predicate: q_smk_status.outcome == 2
        input:
          control: Editbox
          min: 1
          max: 99
      - id: q_smk_days_smoked
        kind: Question
        title: In the past month, on how many days have you smoked 1 or more cigarettes?
        precondition:
        - predicate: q_smk_status.outcome == 2
        input:
          control: Editbox
          min: 0
          max: 30
      - id: q_smk_ever_daily
        kind: Question
        title: Have you ever smoked cigarettes daily?
        precondition:
        - predicate: q_smk_status.outcome == 3
        - predicate: q_smk_100_cigs.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_smk_when_stopped
        kind: Question
        title: 'When did you stop smoking? Was it:'
        precondition:
        - predicate: q_smk_status.outcome == 3
        - predicate: q_smk_100_cigs.outcome == 1
        - predicate: q_smk_ever_daily.outcome == 0
        input:
          control: Radio
          labels:
            1: Less than one year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 or more years ago
      - id: q_smk_month_stopped
        kind: Question
        title: In what month did you stop?
        precondition:
        - predicate: q_smk_when_stopped.outcome == 1
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
      - id: q_smk_years_ago_stopped
        kind: Question
        title: How many years ago was it?
        precondition:
        - predicate: q_smk_when_stopped.outcome == 4
        postcondition:
        - predicate: q_smk_years_ago_stopped.outcome >= 3
          hint: Must be at least 3 years ago.
        - predicate: q_smk_years_ago_stopped.outcome <= age - 5
          hint: Years ago cannot exceed current age minus 5.
        input:
          control: Editbox
          min: 3
          max: 115
      - id: q_smk_former_age_daily
        kind: Question
        title: At what age did you begin to smoke cigarettes daily?
        precondition:
        - predicate: q_smk_ever_daily.outcome == 1
        postcondition:
        - predicate: q_smk_former_age_daily.outcome >= 5
          hint: Age must be at least 5.
        - predicate: q_smk_former_age_daily.outcome <= age
          hint: Age began daily smoking cannot exceed current age.
        input:
          control: Editbox
          min: 1
          max: 120
      - id: q_smk_former_cigs_daily
        kind: Question
        title: How many cigarettes did you usually smoke each day?
        precondition:
        - predicate: q_smk_ever_daily.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 99
      - id: q_smk_when_stopped_daily
        kind: Question
        title: 'When did you stop smoking daily? Was it:'
        precondition:
        - predicate: q_smk_ever_daily.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than one year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 or more years ago
      - id: q_smk_month_stopped_daily
        kind: Question
        title: In what month did you stop smoking daily?
        precondition:
        - predicate: q_smk_when_stopped_daily.outcome == 1
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
      - id: q_smk_years_ago_daily
        kind: Question
        title: How many years ago did you stop smoking daily?
        precondition:
        - predicate: q_smk_when_stopped_daily.outcome == 4
        postcondition:
        - predicate: q_smk_years_ago_daily.outcome >= 3
          hint: Must be at least 3 years ago.
        - predicate: q_smk_years_ago_daily.outcome <= age - 5
          hint: Years ago cannot exceed current age minus 5.
        input:
          control: Editbox
          min: 3
          max: 115
      - id: q_smk_completely_quit
        kind: Question
        title: Was that when you completely quit smoking?
        precondition:
        - predicate: q_smk_ever_daily.outcome == 1
        - predicate: q_smk_status.outcome == 3
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_smk_when_complete_stop
        kind: Question
        title: 'When did you stop smoking completely? Was it:'
        precondition:
        - predicate: q_smk_completely_quit.outcome == 0
        input:
          control: Radio
          labels:
            1: Less than one year ago
            2: 1 year to less than 2 years ago
            3: 2 years to less than 3 years ago
            4: 3 or more years ago
      - id: q_smk_month_complete_stop
        kind: Question
        title: In what month did you stop smoking completely?
        precondition:
        - predicate: q_smk_when_complete_stop.outcome == 1
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
      - id: q_smk_years_ago_complete
        kind: Question
        title: How many years ago did you stop smoking completely?
        precondition:
        - predicate: q_smk_when_complete_stop.outcome == 4
        postcondition:
        - predicate: q_smk_years_ago_complete.outcome >= 3
          hint: Must be at least 3 years ago.
        - predicate: q_smk_years_ago_complete.outcome <= age - 5
          hint: Years ago cannot exceed current age minus 5.
        input:
          control: Editbox
          min: 3
          max: 115
    - id: b_stages_of_change
      title: Smoking - Stages of Change
      precondition:
      - predicate: is_proxy == 0
      - predicate: q_smk_status.outcome in [1, 2]
      items:
      - id: q_sch_quit_6months
        kind: Question
        title: Are you seriously considering quitting smoking within the next 6 months?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sch_quit_30days
        kind: Question
        title: Are you seriously considering quitting within the next 30 days?
        precondition:
        - predicate: q_sch_quit_6months.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sch_tried_quit
        kind: Question
        title: In the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sch_quit_times
        kind: Question
        title: How many times did you stop smoking for at least 24 hours because you were trying to quit in the past 12 months?
        precondition:
        - predicate: q_sch_tried_quit.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 95
    - id: b_nicotine_dependence
      title: Nicotine Dependence
      precondition:
      - predicate: is_proxy == 0
      - predicate: q_smk_status.outcome == 1
      items:
      - id: q_nde_first_cig
        kind: Question
        title: How soon after you wake up do you smoke your first cigarette?
        input:
          control: Radio
          labels:
            1: Within 5 minutes
            2: 6 to 30 minutes after waking
            3: 31 to 60 minutes after waking
            4: More than 60 minutes after waking
      - id: q_nde_refrain
        kind: Question
        title: Do you find it difficult to refrain from smoking in places where it is forbidden?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_nde_hate_give_up
        kind: Question
        title: Which cigarette would you most hate to give up?
        input:
          control: Radio
          labels:
            1: The first one of the day
            2: Another one
      - id: q_nde_morning_more
        kind: Question
        title: Do you smoke more frequently during the first hours after waking, compared with the rest of the day?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_nde_smoke_ill
        kind: Question
        title: Do you smoke even if you are so ill that you are in bed most of the day?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_cessation_aids
      title: Smoking Cessation Aids
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_sca_patch_former
        kind: Question
        title: In the past 12 months, did you try a nicotine patch to quit smoking?
        precondition:
        - predicate: q_smk_status.outcome == 3
        - predicate: q_smk_when_stopped.outcome == 1 or q_smk_when_stopped_daily.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sca_patch_useful
        kind: Question
        title: How useful was that in helping you quit?
        precondition:
        - predicate: q_sca_patch_former.outcome == 1
        input:
          control: Radio
          labels:
            1: Very useful
            2: Somewhat useful
            3: Not very useful
            4: Not useful at all
      - id: q_sca_gum_former
        kind: Question
        title: Did you try Nicorettes or other nicotine gum or candy to quit smoking in the past 12 months?
        precondition:
        - predicate: q_smk_status.outcome == 3
        - predicate: q_smk_when_stopped.outcome == 1 or q_smk_when_stopped_daily.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sca_gum_useful
        kind: Question
        title: How useful was that in helping you quit?
        precondition:
        - predicate: q_sca_gum_former.outcome == 1
        input:
          control: Radio
          labels:
            1: Very useful
            2: Somewhat useful
            3: Not very useful
            4: Not useful at all
      - id: q_sca_med_former
        kind: Question
        title: In the past 12 months, did you try medication such as Zyban, Prolev or Wellbutrin to quit smoking?
        precondition:
        - predicate: q_smk_status.outcome == 3
        - predicate: q_smk_when_stopped.outcome == 1 or q_smk_when_stopped_daily.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sca_med_useful
        kind: Question
        title: How useful was that in helping you quit?
        precondition:
        - predicate: q_sca_med_former.outcome == 1
        input:
          control: Radio
          labels:
            1: Very useful
            2: Somewhat useful
            3: Not very useful
            4: Not useful at all
      - id: q_sca_tried_quit
        kind: Question
        title: In the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit?
        precondition:
        - predicate: q_smk_status.outcome in [1, 2]
        - predicate: q_sch_tried_quit.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sca_patch_current
        kind: Question
        title: 'In the past 12 months, did you try any of the following to quit smoking: a nicotine patch?'
        precondition:
        - predicate: q_smk_status.outcome in [1, 2]
        - predicate: q_sch_tried_quit.outcome == 1 or q_sca_tried_quit.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sca_gum_current
        kind: Question
        title: Did you try Nicorettes or other nicotine gum or candy to quit smoking in the past 12 months?
        precondition:
        - predicate: q_smk_status.outcome in [1, 2]
        - predicate: q_sch_tried_quit.outcome == 1 or q_sca_tried_quit.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sca_med_current
        kind: Question
        title: Did you try medication such as Zyban, Prolev or Wellbutrin to quit smoking in the past 12 months?
        precondition:
        - predicate: q_smk_status.outcome in [1, 2]
        - predicate: q_sch_tried_quit.outcome == 1 or q_sca_tried_quit.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_physician_counselling
      title: Smoking - Physician Counselling
      precondition:
      - predicate: is_proxy == 0
      - predicate: q_smk_status.outcome in [1, 2] or q_smk_when_stopped.outcome == 1 or q_smk_when_stopped_daily.outcome == 1
      items:
      - id: q_spc_saw_doctor
        kind: Question
        title: Earlier, you mentioned having a regular medical doctor. In the past 12 months, did you go see this doctor?
        precondition:
        - predicate: hcu_regular_doctor == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_spc_doctor_knows
        kind: Question
        title: Does your doctor know that you smoke cigarettes?
        precondition:
        - predicate: q_spc_saw_doctor.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_spc_doctor_advise
        kind: Question
        title: In the past 12 months, did your doctor advise you to quit smoking?
        precondition:
        - predicate: q_spc_doctor_knows.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_spc_doctor_help
        kind: Question
        title: Did your doctor give you any specific help or information to quit smoking?
        precondition:
        - predicate: q_spc_doctor_knows.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_spc_doctor_help_type
        kind: Question
        title: What type of help did the doctor give?
        precondition:
        - predicate: q_spc_doctor_help.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Referral to a one-on-one cessation program
            2: Referral to a group cessation program
            4: Recommended use of nicotine patch or nicotine gum
            8: Recommended Zyban or other medication
            16: Provided self-help information
            32: Own doctor offered counselling
            64: Other
      - id: q_spc_went_dentist
        kind: Question
        title: Earlier, you mentioned having seen or talked to a dentist in the past 12 months. Did you actually go to the dentist?
        precondition:
        - predicate: den_checkup == 0 and den_other_visit == 0
        - predicate: hcu_dentist_consult >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_spc_dentist_knows
        kind: Question
        title: Does your dentist or dental hygienist know that you smoke cigarettes?
        precondition:
        - predicate: den_checkup == 1 or den_other_visit == 1 or q_spc_went_dentist.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_spc_dentist_advise
        kind: Question
        title: In the past 12 months, did the dentist or hygienist advise you to quit smoking?
        precondition:
        - predicate: q_spc_dentist_knows.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_youth_smoking
      title: Youth Smoking
      precondition:
      - predicate: is_proxy == 0
      - predicate: age <= 19
      - predicate: q_smk_status.outcome in [1, 2]
      items:
      - id: q_ysm_source
        kind: Question
        title: Where do you usually get your cigarettes?
        input:
          control: Dropdown
          labels:
            1: Buy from - Vending machine
            2: Buy from - Small grocery / corner store
            3: Buy from - Supermarket
            4: Buy from - Drug store
            5: Buy from - Gas station
            6: Buy from - Other store
            7: Buy from - Friend or someone else
            8: Given them by - Brother or sister
            9: Given them by - Mother or father
            10: Given them by - Friend or someone else
            11: Take them from - Mother, father or sibling
            12: Other
      - id: q_ysm_source_other
        kind: Question
        title: 'Please specify where you usually get your cigarettes:'
        precondition:
        - predicate: q_ysm_source.outcome == 12
        input:
          control: Textarea
          placeholder: Specify other source...
          maxLength: 80
      - id: q_ysm_ever_bought
        kind: Question
        title: In the past 12 months, have you bought cigarettes for yourself or for someone else?
        precondition:
        - predicate: q_ysm_source.outcome >= 8
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ysm_asked_age
        kind: Question
        title: In the past 12 months, have you been asked your age when buying cigarettes in a store?
        precondition:
        - predicate: q_ysm_source.outcome in [1, 2, 3, 4, 5, 6, 7] or q_ysm_ever_bought.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ysm_refused_sale
        kind: Question
        title: In the past 12 months, has anyone in a store refused to sell you cigarettes?
        precondition:
        - predicate: q_ysm_source.outcome in [1, 2, 3, 4, 5, 6, 7] or q_ysm_ever_bought.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ysm_stranger_buy
        kind: Question
        title: In the past 12 months, have you asked a stranger to buy you cigarettes?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_second_hand_smoke
      title: Exposure to Second-Hand Smoke
      items:
      - id: q_ets_intro
        kind: Comment
        title: The next questions are about exposure to second-hand smoke.
      - id: q_ets_smoke_home
        kind: Question
        title: Including both household members and regular visitors, does anyone smoke inside your home, every day or almost
          every day?
        precondition:
        - predicate: not (household_size == 1 and q_smk_status.outcome in [1, 2])
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ets_smoke_home_count
        kind: Question
        title: How many people smoke inside your home every day or almost every day?
        precondition:
        - predicate: q_ets_smoke_home.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 15
      - id: q_ets_car
        kind: Question
        title: In the past month, were you exposed to second-hand smoke, every day or almost every day, in a car or other private
          vehicle?
        precondition:
        - predicate: q_smk_status.outcome == 3
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ets_public
        kind: Question
        title: In the past month, were you exposed to second-hand smoke, every day or almost every day, in public places (such
          as bars, restaurants, shopping malls, arenas, bingo halls, bowling alleys)?
        precondition:
        - predicate: q_smk_status.outcome == 3
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ets_restrictions
        kind: Question
        title: Are there any restrictions against smoking cigarettes in your home?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ets_restriction_type
        kind: Question
        title: How is smoking restricted in your home?
        precondition:
        - predicate: q_ets_restrictions.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Smokers are asked to refrain from smoking in the house
            2: Smoking is allowed in certain rooms only
            4: Smoking is restricted in the presence of young children
            8: Other restriction

    # ===================================================================
    # SECTION: substance_use
    # ===================================================================
    - id: b_alcohol
      title: Alcohol Use
      items:
      - id: q_alc_intro
        kind: Comment
        title: 'Now, some questions about your alcohol consumption. When we use the word ''drink'' it means: one bottle or can
          of beer or a glass of draft; one glass of wine or a wine cooler; one drink or cocktail with 1 and a 1/2 ounces of
          liquor.'
      - id: q_alc_past_year
        kind: Question
        title: During the past 12 months, have you had a drink of beer, wine, liquor or any other alcoholic beverage?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_alc_frequency
        kind: Question
        title: During the past 12 months, how often did you drink alcoholic beverages?
        precondition:
        - predicate: q_alc_past_year.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: Once a month
            3: 2 to 3 times a month
            4: Once a week
            5: 2 to 3 times a week
            6: 4 to 6 times a week
            7: Every day
      - id: q_alc_binge
        kind: Question
        title: How often in the past 12 months have you had 5 or more drinks on one occasion?
        precondition:
        - predicate: q_alc_past_year.outcome == 1
        input:
          control: Radio
          labels:
            1: Never
            2: Less than once a month
            3: Once a month
            4: 2 to 3 times a month
            5: Once a week
            6: More than once a week
      - id: q_alc_past_week
        kind: Question
        title: Thinking back over the past week, did you have a drink of beer, wine, liquor or any other alcoholic beverage?
        precondition:
        - predicate: q_alc_past_year.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: qg_alc_weekly
        kind: QuestionGroup
        title: 'Starting with yesterday, how many drinks did you have each day:'
        precondition:
        - predicate: q_alc_past_week.outcome == 1
        postcondition:
        - predicate: not (q_alc_binge.outcome == 1 and (qg_alc_weekly.outcome[0] >= 5 or qg_alc_weekly.outcome[1] >= 5 or qg_alc_weekly.outcome[2]
            >= 5 or qg_alc_weekly.outcome[3] >= 5 or qg_alc_weekly.outcome[4] >= 5 or qg_alc_weekly.outcome[5] >= 5 or qg_alc_weekly.outcome[6]
            >= 5))
          hint: You indicated never having 5 or more drinks on one occasion, but reported 5+ drinks on a single day last week.
        questions:
        - Sunday
        - Monday
        - Tuesday
        - Wednesday
        - Thursday
        - Friday
        - Saturday
        input:
          control: Editbox
          min: 0
          max: 99
      - id: q_alc_ever
        kind: Question
        title: Have you ever had a drink?
        precondition:
        - predicate: q_alc_past_year.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_alc_heavy_past
        kind: Question
        title: Did you ever regularly drink more than 12 drinks a week?
        precondition:
        - predicate: q_alc_past_year.outcome == 0
        - predicate: q_alc_ever.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_alc_why_reduced
        kind: Question
        title: Why did you reduce or quit drinking altogether?
        precondition:
        - predicate: q_alc_heavy_past.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Dieting
            2: Athletic training
            4: Pregnancy
            8: Getting older
            16: Drinking too much / drinking problem
            32: Affected work, studies, employment opportunities
            64: Interfered with family or home life
            128: Affected physical health
            256: Affected friendships or social relationships
            512: Affected financial position
            1024: Affected outlook on life, happiness
            2048: Influence of family or friends
            4096: Life change
            8192: Other
      - id: q_alc_why_other
        kind: Question
        title: 'Please specify why you reduced or quit drinking:'
        precondition:
        - predicate: q_alc_why_reduced.outcome % 16384 >= 8192
        input:
          control: Textarea
          placeholder: Specify other reason...
          maxLength: 80
      - id: q_alc_age_started
        kind: Question
        title: Not counting small sips, how old were you when you started drinking alcoholic beverages?
        precondition:
        - predicate: age <= 19
        postcondition:
        - predicate: q_alc_age_started.outcome >= 5
          hint: Age must be at least 5.
        - predicate: q_alc_age_started.outcome <= age
          hint: Age started drinking cannot exceed current age.
        input:
          control: Editbox
          min: 1
          max: 120
    - id: b_drug_use
      title: Drug Use
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_drg_intro
        kind: Comment
        title: I am going to ask some questions about drug use. Again, I would like to remind you that everything you say will
          remain strictly confidential.
      - id: q_drg_q01
        kind: Question
        title: Have you ever used or tried marijuana, cannabis or hashish?
        input:
          control: Radio
          labels:
            1: Yes, just once
            2: Yes, more than once
            3: 'No'
        codeBlock: |
          if q_drg_q01.outcome == 3:
              never_tried_count = never_tried_count + 1
      - id: q_drg_q02
        kind: Question
        title: Have you used it in the past 12 months?
        precondition:
        - predicate: q_drg_q01.outcome in [1, 2]
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q03
        kind: Question
        title: How often did you use marijuana, cannabis or hashish in the past 12 months?
        precondition:
        - predicate: q_drg_q01.outcome == 2
        - predicate: q_drg_q02.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: 1 to 3 times a month
            3: Once a week
            4: More than once a week
            5: Every day
        codeBlock: |
          if q_drg_q03.outcome >= 3:
              frequent_use_count = frequent_use_count + 1
      - id: q_drg_q04
        kind: Question
        title: Have you ever used or tried cocaine or crack?
        input:
          control: Radio
          labels:
            1: Yes, just once
            2: Yes, more than once
            3: 'No'
        codeBlock: |
          if q_drg_q04.outcome == 3:
              never_tried_count = never_tried_count + 1
      - id: q_drg_q05
        kind: Question
        title: Have you used it in the past 12 months?
        precondition:
        - predicate: q_drg_q04.outcome in [1, 2]
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q06
        kind: Question
        title: How often did you use cocaine or crack in the past 12 months?
        precondition:
        - predicate: q_drg_q04.outcome == 2
        - predicate: q_drg_q05.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: 1 to 3 times a month
            3: Once a week
            4: More than once a week
            5: Every day
        codeBlock: |
          if q_drg_q06.outcome >= 3:
              frequent_use_count = frequent_use_count + 1
      - id: q_drg_q07
        kind: Question
        title: Have you ever used or tried speed (amphetamines)?
        input:
          control: Radio
          labels:
            1: Yes, just once
            2: Yes, more than once
            3: 'No'
        codeBlock: |
          if q_drg_q07.outcome == 3:
              never_tried_count = never_tried_count + 1
      - id: q_drg_q08
        kind: Question
        title: Have you used it in the past 12 months?
        precondition:
        - predicate: q_drg_q07.outcome in [1, 2]
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q09
        kind: Question
        title: How often did you use speed (amphetamines) in the past 12 months?
        precondition:
        - predicate: q_drg_q07.outcome == 2
        - predicate: q_drg_q08.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: 1 to 3 times a month
            3: Once a week
            4: More than once a week
            5: Every day
        codeBlock: |
          if q_drg_q09.outcome >= 3:
              frequent_use_count = frequent_use_count + 1
      - id: q_drg_q10
        kind: Question
        title: Have you ever used or tried ecstasy (MDMA) or other similar drugs?
        input:
          control: Radio
          labels:
            1: Yes, just once
            2: Yes, more than once
            3: 'No'
        codeBlock: |
          if q_drg_q10.outcome == 3:
              never_tried_count = never_tried_count + 1
      - id: q_drg_q11
        kind: Question
        title: Have you used it in the past 12 months?
        precondition:
        - predicate: q_drg_q10.outcome in [1, 2]
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q12
        kind: Question
        title: How often did you use ecstasy or other similar drugs in the past 12 months?
        precondition:
        - predicate: q_drg_q10.outcome == 2
        - predicate: q_drg_q11.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: 1 to 3 times a month
            3: Once a week
            4: More than once a week
            5: Every day
        codeBlock: |
          if q_drg_q12.outcome >= 3:
              frequent_use_count = frequent_use_count + 1
      - id: q_drg_q13
        kind: Question
        title: Have you ever used or tried hallucinogens, PCP or LSD (acid)?
        input:
          control: Radio
          labels:
            1: Yes, just once
            2: Yes, more than once
            3: 'No'
        codeBlock: |
          if q_drg_q13.outcome == 3:
              never_tried_count = never_tried_count + 1
      - id: q_drg_q14
        kind: Question
        title: Have you used it in the past 12 months?
        precondition:
        - predicate: q_drg_q13.outcome in [1, 2]
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q15
        kind: Question
        title: How often did you use hallucinogens, PCP or LSD in the past 12 months?
        precondition:
        - predicate: q_drg_q13.outcome == 2
        - predicate: q_drg_q14.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: 1 to 3 times a month
            3: Once a week
            4: More than once a week
            5: Every day
        codeBlock: |
          if q_drg_q15.outcome >= 3:
              frequent_use_count = frequent_use_count + 1
      - id: q_drg_q16
        kind: Question
        title: Did you ever sniff glue, gasoline or other solvents?
        input:
          control: Radio
          labels:
            1: Yes, just once
            2: Yes, more than once
            3: 'No'
        codeBlock: |
          if q_drg_q16.outcome == 3:
              never_tried_count = never_tried_count + 1
      - id: q_drg_q17
        kind: Question
        title: Did you sniff some in the past 12 months?
        precondition:
        - predicate: q_drg_q16.outcome in [1, 2]
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q18
        kind: Question
        title: How often did you sniff glue, gasoline or other solvents in the past 12 months?
        precondition:
        - predicate: q_drg_q16.outcome == 2
        - predicate: q_drg_q17.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: 1 to 3 times a month
            3: Once a week
            4: More than once a week
            5: Every day
        codeBlock: |
          if q_drg_q18.outcome >= 3:
              frequent_use_count = frequent_use_count + 1
      - id: q_drg_q19
        kind: Question
        title: Have you ever used or tried heroin?
        input:
          control: Radio
          labels:
            1: Yes, just once
            2: Yes, more than once
            3: 'No'
        codeBlock: |
          if q_drg_q19.outcome == 3:
              never_tried_count = never_tried_count + 1
      - id: q_drg_q20
        kind: Question
        title: Have you used it in the past 12 months?
        precondition:
        - predicate: q_drg_q19.outcome in [1, 2]
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q21
        kind: Question
        title: How often did you use heroin in the past 12 months?
        precondition:
        - predicate: q_drg_q19.outcome == 2
        - predicate: q_drg_q20.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: 1 to 3 times a month
            3: Once a week
            4: More than once a week
            5: Every day
        codeBlock: |
          if q_drg_q21.outcome >= 3:
              frequent_use_count = frequent_use_count + 1
      - id: q_drg_q22
        kind: Question
        title: Have you ever used or tried steroids, such as testosterone, dianabol or growth hormones, to increase your performance
          in a sport or activity or to change your physical appearance?
        input:
          control: Radio
          labels:
            1: Yes, just once
            2: Yes, more than once
            3: 'No'
      - id: q_drg_q23
        kind: Question
        title: Have you used it in the past 12 months?
        precondition:
        - predicate: q_drg_q22.outcome in [1, 2]
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q24
        kind: Question
        title: How often did you use steroids in the past 12 months?
        precondition:
        - predicate: q_drg_q22.outcome == 2
        - predicate: q_drg_q23.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than once a month
            2: 1 to 3 times a month
            3: Once a week
            4: More than once a week
            5: Every day
        codeBlock: |
          if q_drg_q24.outcome >= 3:
              frequent_use_count = frequent_use_count + 1
      - id: q_drg_q25a
        kind: Question
        title: During the past 12 months, did you ever need to use more drugs than usual in order to get high, or did you ever
          find that you could no longer get high on the amount you usually took?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_r25b
        kind: Comment
        title: People who cut down their substance use or stop using drugs altogether may not feel well if they have been using
          steadily for some time. They may have what are called 'withdrawal symptoms'.
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
      - id: q_drg_q25b
        kind: Question
        title: During the past 12 months, did you ever have times when you stopped, cut down or went without drugs and then
          experienced symptoms like fatigue, headaches, diarrhoea, the shakes or emotional problems?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q25c
        kind: Question
        title: During the past 12 months, did you ever have times when you used drugs to keep from having such symptoms?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q25d
        kind: Question
        title: During the past 12 months, did you ever have times when you used drugs even though you promised yourself you
          wouldn't, or times when you used a lot more drugs than you intended?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q25e
        kind: Question
        title: During the past 12 months, were there ever times when you used drugs more frequently, or for more days in a row
          than you intended?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q25f
        kind: Question
        title: During the past 12 months, did you ever have periods of several days or more when you spent so much time using
          drugs or recovering from the effects of using drugs that you had little time for anything else?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q25g
        kind: Question
        title: During the past 12 months, did you ever have periods of a month or longer when you gave up or greatly reduced
          important activities because of your use of drugs?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_q25h
        kind: Question
        title: During the past 12 months, did you ever continue to use drugs when you knew you had a serious physical or emotional
          problem that might have been caused by or made worse by your use?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_drg_r26
        kind: Comment
        title: Please tell me what number best describes how much your use of drugs interfered with each of the following activities
          during the past 12 months. Use a scale of 0 to 10, where 0 means no interference and 10 means very severe interference.
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
      - id: q_drg_q26a
        kind: Question
        title: How much did your use of drugs interfere with your home responsibilities, like cleaning, shopping and taking
          care of the house or apartment?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Slider
          min: 0
          max: 10
          left: No interference
          right: Very severe
      - id: q_drg_q26b1
        kind: Question
        title: How much did your use interfere with your ability to attend school?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Slider
          min: 0
          max: 11
          left: No interference
          right: Very severe (11 = Not applicable)
      - id: q_drg_q26b2
        kind: Question
        title: How much did your use interfere with your ability to work at a regular job?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Slider
          min: 0
          max: 11
          left: No interference
          right: Very severe (11 = Not applicable)
      - id: q_drg_q26c
        kind: Question
        title: During the past 12 months, how much did your use of drugs interfere with your ability to form and maintain close
          relationships with other people?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Slider
          min: 0
          max: 10
          left: No interference
          right: Very severe
      - id: q_drg_q26d
        kind: Question
        title: How much did your use of drugs interfere with your social life?
        precondition:
        - predicate: never_tried_count < 7
        - predicate: frequent_use_count >= 1
        input:
          control: Slider
          min: 0
          max: 10
          left: No interference
          right: Very severe
    - id: b_gambling
      title: Canadian Problem Gambling Index
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_cpg_intro
        kind: Comment
        title: People have different definitions of gambling. For the purpose of this survey, we mean any activity where you
          risk money or valuables on the outcome. The next questions are about gambling activities and experiences.
      - id: q_cpg_q01a
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on instant win or scratch tickets, or daily lottery
          tickets such as Keno, Pick 3, Encore, Banco or Extra?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
      - id: q_cpg_q01b
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on lottery tickets such as 6/49 and Super 7, raffles
          or fund-raising tickets?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01b.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01c
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on Bingo?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01c.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01d
        kind: Question
        title: In the past 12 months, how often have you bet or spent money playing cards or board games with family or friends?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01d.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01e
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on video lottery terminals (VLTs) outside of casinos?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01e.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01f
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on coin slots or VLTs at a casino?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01f.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01g
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on casino games other than coin slots or VLTs, for
          example poker, roulette, blackjack or Keno?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01g.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01h
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on Internet or arcade gambling?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01h.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01i
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on live horse racing at the track or off track?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01i.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01j
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on sports such as sports lotteries (Sport Select,
          Pro-Line, Mise-au-jeu, Total), sports pools or sporting events?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01j.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01k
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on speculative investments such as stocks, options
          or commodities?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01k.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01l
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on games of skill such as pool, golf, bowling or
          darts?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01l.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01m
        kind: Question
        title: In the past 12 months, how often have you bet or spent money on any other forms of gambling such as dog races,
          gambling at casino nights or country fairs, betting on sports with a bookie, or gambling pools at work?
        input:
          control: Radio
          labels:
            1: Daily
            2: 2 to 6 times a week
            3: About once a week
            4: 2 to 3 times a month
            5: About once a month
            6: 6 to 11 times a year
            7: 1 to 5 times a year
            8: Never
        codeBlock: |
          if q_cpg_q01m.outcome in [7, 8]:
              never_gamble_count = never_gamble_count + 1
      - id: q_cpg_q01n
        kind: Question
        title: In the past 12 months, how much money, not including winnings, did you spend on all of your gambling activities?
        precondition:
        - predicate: never_gamble_count < 12 or q_cpg_q01a.outcome in [1, 2, 3, 4, 5, 6]
        input:
          control: Radio
          labels:
            1: Between $1 and $50
            2: Between $51 and $100
            3: Between $101 and $250
            4: Between $251 and $500
            5: Between $501 and $1000
            6: More than $1000
      - id: q_cpg_int2
        kind: Comment
        title: The next questions are about gambling attitudes and experiences. All the questions will refer to the past 12
          months.
        precondition:
        - predicate: never_gamble_count < 12 or q_cpg_q01a.outcome in [1, 2, 3, 4, 5, 6]
      - id: q_cpg_q02
        kind: Question
        title: In the past 12 months, how often have you bet or spent more money than you wanted to on gambling?
        precondition:
        - predicate: never_gamble_count < 12 or q_cpg_q01a.outcome in [1, 2, 3, 4, 5, 6]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
            5: I am not a gambler
      - id: q_cpg_q03
        kind: Question
        title: In the past 12 months, how often have you needed to gamble with larger amounts of money to get the same feeling
          of excitement?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q04
        kind: Question
        title: In the past 12 months, when you gambled, how often did you go back another day to try to win back the money you
          lost?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q05
        kind: Question
        title: In the past 12 months, how often have you borrowed money or sold anything to get money to gamble?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q06
        kind: Question
        title: In the past 12 months, how often have you felt that you might have a problem with gambling?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q07
        kind: Question
        title: In the past 12 months, how often has gambling caused you any health problems, including stress or anxiety?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q08
        kind: Question
        title: In the past 12 months, how often have people criticized your betting or told you that you had a gambling problem,
          regardless of whether or not you thought it was true?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q09
        kind: Question
        title: In the past 12 months, how often has your gambling caused financial problems for you or your family?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q10
        kind: Question
        title: In the past 12 months, how often have you felt guilty about the way you gamble or what happens when you gamble?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q11
        kind: Question
        title: In the past 12 months, how often have you lied to family members or others to hide your gambling?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q12
        kind: Question
        title: In the past 12 months, how often have you wanted to stop betting money or gambling, but didn't think you could?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q13
        kind: Question
        title: In the past 12 months, how often have you bet more than you could really afford to lose?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q14
        kind: Question
        title: In the past 12 months, have you tried to quit or cut down on your gambling but were unable to do it?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q15
        kind: Question
        title: In the past 12 months, have you gambled as a way of forgetting problems or to feel better when you were depressed?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
      - id: q_cpg_q16
        kind: Question
        title: In the past 12 months, has your gambling caused any problems with your relationship with any of your family members
          or friends?
        precondition:
        - predicate: q_cpg_q02.outcome in [1, 2, 3, 4]
        input:
          control: Radio
          labels:
            1: Never
            2: Sometimes
            3: Most of the time
            4: Almost always
        codeBlock: |
          # CPG_C17: Recode Q03-Q10 and Q13 (1→0, 2→1, 3→2, 4→3), sum
          cpg_score = 0
          if q_cpg_q03.outcome >= 1 and q_cpg_q03.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q03.outcome - 1
          if q_cpg_q04.outcome >= 1 and q_cpg_q04.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q04.outcome - 1
          if q_cpg_q05.outcome >= 1 and q_cpg_q05.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q05.outcome - 1
          if q_cpg_q06.outcome >= 1 and q_cpg_q06.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q06.outcome - 1
          if q_cpg_q07.outcome >= 1 and q_cpg_q07.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q07.outcome - 1
          if q_cpg_q08.outcome >= 1 and q_cpg_q08.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q08.outcome - 1
          if q_cpg_q09.outcome >= 1 and q_cpg_q09.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q09.outcome - 1
          if q_cpg_q10.outcome >= 1 and q_cpg_q10.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q10.outcome - 1
          if q_cpg_q13.outcome >= 1 and q_cpg_q13.outcome <= 4:
              cpg_score = cpg_score + q_cpg_q13.outcome - 1
      - id: q_cpg_q17
        kind: Question
        title: Has anyone in your family ever had a gambling problem?
        precondition:
        - predicate: cpg_score >= 3
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_cpg_q18
        kind: Question
        title: In the past 12 months, have you used alcohol or drugs while gambling?
        precondition:
        - predicate: cpg_score >= 3
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_cpg_int19
        kind: Comment
        title: Please tell me what number best describes how much your gambling activities interfered with each of the following
          activities during the past 12 months. Use a scale of 0 to 10, where 0 means no interference and 10 means very severe
          interference.
        precondition:
        - predicate: cpg_score >= 3
      - id: q_cpg_q19a
        kind: Question
        title: During the past 12 months, how much did your gambling activities interfere with your home responsibilities, like
          cleaning, shopping and taking care of the house or apartment?
        precondition:
        - predicate: cpg_score >= 3
        input:
          control: Slider
          min: 0
          max: 10
          left: No interference
          right: Very severe
      - id: q_cpg_q19b1
        kind: Question
        title: How much did these activities interfere with your ability to attend school?
        precondition:
        - predicate: cpg_score >= 3
        input:
          control: Slider
          min: 0
          max: 11
          left: No interference
          right: Very severe (11 = Not applicable)
      - id: q_cpg_q19b2
        kind: Question
        title: How much did they interfere with your ability to work at a job?
        precondition:
        - predicate: cpg_score >= 3
        input:
          control: Slider
          min: 0
          max: 11
          left: No interference
          right: Very severe (11 = Not applicable)
      - id: q_cpg_q19c
        kind: Question
        title: During the past 12 months, how much did your gambling activities interfere with your ability to form and maintain
          close relationships with other people?
        precondition:
        - predicate: cpg_score >= 3
        input:
          control: Slider
          min: 0
          max: 10
          left: No interference
          right: Very severe
      - id: q_cpg_q19d
        kind: Question
        title: How much did they interfere with your social life?
        precondition:
        - predicate: cpg_score >= 3
        input:
          control: Slider
          min: 0
          max: 10
          left: No interference
          right: Very severe

    # ===================================================================
    # SECTION: wellbeing_stress
    # ===================================================================
    - id: b_satisfaction
      title: Satisfaction with Life
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_swl_intro
        kind: Comment
        title: Now I'd like to ask about your satisfaction with various aspects of your life. Please tell me whether you are
          very satisfied, satisfied, neither satisfied nor dissatisfied, dissatisfied, or very dissatisfied.
      - id: q_swl_q02
        kind: Question
        title: How satisfied are you with your job or main activity?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
      - id: q_swl_q03
        kind: Question
        title: How satisfied are you with your leisure activities?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
      - id: q_swl_q04
        kind: Question
        title: How satisfied are you with your financial situation?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
      - id: q_swl_q05
        kind: Question
        title: How satisfied are you with yourself?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
      - id: q_swl_q06
        kind: Question
        title: How satisfied are you with the way your body looks?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
      - id: q_swl_q07
        kind: Question
        title: How satisfied are you with your relationships with other family members?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
      - id: q_swl_q08
        kind: Question
        title: How satisfied are you with your relationships with friends?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
      - id: q_swl_q09
        kind: Question
        title: How satisfied are you with your housing?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
      - id: q_swl_q10
        kind: Question
        title: How satisfied are you with your neighbourhood?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Satisfied
            3: Neither satisfied nor dissatisfied
            4: Dissatisfied
            5: Very dissatisfied
    - id: b_stress_sources
      title: Stress Sources
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_sts_intro
        kind: Comment
        title: Now a few questions about the stress in your life.
      - id: q_sts_q1
        kind: Question
        title: 'In general, how would you rate your ability to handle unexpected and difficult problems, for example, a family
          or personal crisis? Would you say your ability is:'
        input:
          control: Radio
          labels:
            1: Excellent
            2: Very good
            3: Good
            4: Fair
            5: Poor
      - id: q_sts_q2
        kind: Question
        title: 'In general, how would you rate your ability to handle the day-to-day demands in your life, for example, handling
          work, family and volunteer responsibilities? Would you say your ability is:'
        input:
          control: Radio
          labels:
            1: Excellent
            2: Very good
            3: Good
            4: Fair
            5: Poor
      - id: q_sts_q3
        kind: Question
        title: Thinking about stress in your day-to-day life, what would you say is the most important thing contributing to
          feelings of stress you may have?
        input:
          control: Radio
          labels:
            1: Time pressures / not enough time
            2: Own physical health problem or condition
            3: Own emotional or mental health problem or condition
            4: Financial situation
            5: Own work situation
            6: School
            7: Employment status
            8: Caring for own children
            9: Caring for others
            10: Other personal or family responsibilities
            11: Personal relationships
            12: Discrimination
            13: Personal and family's safety
            14: Health of family members
            15: Other
            16: Nothing
      - id: q_sts_q3s
        kind: Question
        title: Please specify the other source of stress.
        precondition:
        - predicate: q_sts_q3.outcome == 15
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_stress_coping
      title: Stress Coping
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_stc_intro
        kind: Comment
        title: Now a few questions about coping with stress.
      - id: q_stc_q1_1
        kind: Question
        title: How often do you try to solve the problem?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_2
        kind: Question
        title: To deal with stress, how often do you talk to others?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_3
        kind: Question
        title: When dealing with stress, how often do you avoid being with people?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_4
        kind: Question
        title: How often do you sleep more than usual to deal with stress?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_5a
        kind: Question
        title: When dealing with stress, how often do you try to feel better by eating more, or less, than usual?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_5b
        kind: Question
        title: When dealing with stress, how often do you try to feel better by smoking more cigarettes than usual?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
            5: Do not smoke
      - id: q_stc_q1_5c
        kind: Question
        title: When dealing with stress, how often do you try to feel better by drinking alcohol?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_5d
        kind: Question
        title: When dealing with stress, how often do you try to feel better by using drugs or medication?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_6
        kind: Question
        title: How often do you jog or do other exercise to deal with stress?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_7
        kind: Question
        title: How often do you pray or seek spiritual help to deal with stress?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_8
        kind: Question
        title: To deal with stress, how often do you try to relax by doing something enjoyable?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_9
        kind: Question
        title: To deal with stress, how often do you try to look on the bright side of things?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_10
        kind: Question
        title: How often do you blame yourself?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
      - id: q_stc_q1_11
        kind: Question
        title: To deal with stress, how often do you wish the situation would go away or somehow be finished?
        input:
          control: Radio
          labels:
            1: Often
            2: Sometimes
            3: Rarely
            4: Never
    - id: b_childhood_stressors
      title: Childhood and Adult Stressors
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 18
      items:
      - id: q_cst_intro
        kind: Comment
        title: The next few questions ask about some things that may have happened to you while you were a child or a teenager,
          before you moved out of the house. Please tell me if any of these things have happened to you.
      - id: q_cst_q1
        kind: Question
        title: Did you spend 2 weeks or more in the hospital?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_cst_q2
        kind: Question
        title: Did your parents get a divorce?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_cst_q3
        kind: Question
        title: Did your father or mother not have a job for a long time when they wanted to be working?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_cst_q4
        kind: Question
        title: Did something happen that scared you so much you thought about it for years after?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_cst_q5
        kind: Question
        title: Were you sent away from home because you did something wrong?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_cst_q6
        kind: Question
        title: Did either of your parents drink or use drugs so often that it caused problems for the family?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_cst_q7
        kind: Question
        title: Were you ever physically abused by someone close to you?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_work_stress
      title: Work Stress
      precondition:
      - predicate: is_proxy == 0
      - predicate: age >= 15 and age <= 75
      - predicate: gen_q08_worked == 1
      items:
      - id: q_wst_intro
        kind: Comment
        title: The next few questions are about your main job or business in the past 12 months. I'm going to read you a series
          of statements that might describe your job situation. Please tell me if you strongly agree, agree, neither agree nor
          disagree, disagree, or strongly disagree.
      - id: q_wst_q401
        kind: Question
        title: Your job required that you learn new things.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q402
        kind: Question
        title: Your job required a high level of skill.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q403
        kind: Question
        title: Your job allowed you freedom to decide how you did your job.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q404
        kind: Question
        title: Your job required that you do things over and over.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q405
        kind: Question
        title: Your job was very hectic.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q406
        kind: Question
        title: You were free from conflicting demands that others made.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q407
        kind: Question
        title: Your job security was good.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q408
        kind: Question
        title: Your job required a lot of physical effort.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q409
        kind: Question
        title: You had a lot to say about what happened in your job.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q410
        kind: Question
        title: You were exposed to hostility or conflict from the people you worked with.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q411
        kind: Question
        title: Your supervisor was helpful in getting the job done.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q412
        kind: Question
        title: The people you worked with were helpful in getting the job done.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q412a
        kind: Question
        title: You had the materials and equipment you needed to do your job.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_wst_q413
        kind: Question
        title: How satisfied were you with your job?
        input:
          control: Radio
          labels:
            1: Very satisfied
            2: Somewhat satisfied
            3: Not too satisfied
            4: Not at all satisfied
    - id: b_self_esteem
      title: Self-Esteem
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_sfe_intro
        kind: Comment
        title: Now a series of statements that people might use to describe themselves. Please tell me if you strongly agree,
          agree, neither agree nor disagree, disagree, or strongly disagree.
      - id: q_sfe_q501
        kind: Question
        title: You feel that you have a number of good qualities.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_sfe_q502
        kind: Question
        title: You feel that you're a person of worth at least equal to others.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_sfe_q503
        kind: Question
        title: You are able to do things as well as most other people.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_sfe_q504
        kind: Question
        title: You take a positive attitude toward yourself.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_sfe_q505
        kind: Question
        title: On the whole you are satisfied with yourself.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_sfe_q506
        kind: Question
        title: All in all, you're inclined to feel you're a failure.
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree

    # ===================================================================
    # SECTION: social_mental_health
    # ===================================================================
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

    # ===================================================================
    # SECTION: health_status
    # ===================================================================
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

    # ===================================================================
    # SECTION: sexual_behaviours
    # ===================================================================
    - id: b_sexual_behaviours
      title: Sexual Behaviours
      items:
      - id: q_sxb_r01
        kind: Comment
        title: I would like to ask you a few questions about sexual behaviour. Again, let me assure you that your answers are
          completely confidential.
      - id: q_sxb_q01
        kind: Question
        title: Have you ever had sexual intercourse?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sxb_q02
        kind: Question
        title: How old were you the first time?
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        postcondition:
        - predicate: q_sxb_q02.outcome >= 1
          hint: Age at first intercourse must be at least 1.
        - predicate: q_sxb_q02.outcome <= age
          hint: Age at first intercourse cannot exceed current age.
        input:
          control: Editbox
          min: 1
          max: 49
      - id: q_sxb_q03
        kind: Question
        title: In the past 12 months, have you had sexual intercourse?
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sxb_q04
        kind: Question
        title: With how many different partners?
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        input:
          control: Radio
          labels:
            1: 1 partner
            2: 2 partners
            3: 3 partners
            4: 4 or more partners
      - id: q_sxb_q07
        kind: Question
        title: Have you ever been diagnosed with a sexually transmitted disease?
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sxb_q08
        kind: Question
        title: Did you use a condom the last time you had sexual intercourse?
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: not (marital_status in [1, 2] and q_sxb_q04.outcome == 1)
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sxb_r9a
        kind: Comment
        title: Now a few questions about birth control.
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
      - id: q_sxb_r9b
        kind: Comment
        title: I'm going to read you a statement about pregnancy. Please tell me if you strongly agree, agree, neither agree
          nor disagree, disagree, or strongly disagree.
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        - predicate: sex == 2
        - predicate: mam_q037 != 1
      - id: q_sxb_q09
        kind: Question
        title: It is important to me to avoid getting pregnant right now.
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        - predicate: sex == 2
        - predicate: mam_q037 != 1
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
      - id: q_sxb_r10
        kind: Comment
        title: I'm going to read you a statement about pregnancy. Please tell me if you strongly agree, agree, neither agree
          nor disagree, disagree, or strongly disagree.
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        - predicate: sex == 1
      - id: q_sxb_q10
        kind: Question
        title: It is important to me to avoid getting my partner pregnant right now.
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        - predicate: sex == 1
        input:
          control: Radio
          labels:
            1: Strongly agree
            2: Agree
            3: Neither agree nor disagree
            4: Disagree
            5: Strongly disagree
            6: Doesn't have a partner right now
      - id: q_sxb_q11
        kind: Question
        title: In the past 12 months, did you and your partner usually use birth control?
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_sxb_q12
        kind: Question
        title: What kind of birth control did you and your partner usually use? (Mark all that apply)
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        - predicate: q_sxb_q11.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Condom (male or female condom)
            2: Birth control pill
            4: Diaphragm
            8: Spermicide (e.g., foam, jelly, film)
            16: Birth control injection (Deprovera)
            32: Other
      - id: q_sxb_q12s
        kind: Question
        title: Specify other birth control method usually used.
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        - predicate: q_sxb_q11.outcome == 1
        - predicate: q_sxb_q12.outcome % 64 >= 32
        input:
          control: Textarea
          placeholder: Specify other method...
          maxLength: 200
      - id: q_sxb_q13
        kind: Question
        title: What kind of birth control did you and your partner use the last time you had sex? (Mark all that apply)
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        - predicate: q_sxb_q11.outcome == 1
        - predicate: mam_q037 != 1
        input:
          control: Checkbox
          labels:
            1: Condom (male or female condom)
            2: Birth control pill
            4: Diaphragm
            8: Spermicide (e.g., foam, jelly, film)
            16: Birth control injection (Deprovera)
            32: Nothing
            64: Other
      - id: q_sxb_q13s
        kind: Question
        title: Specify other birth control method used last time.
        precondition:
        - predicate: q_sxb_q01.outcome == 1
        - predicate: q_sxb_q03.outcome == 1
        - predicate: age <= 24
        - predicate: q_sxb_q11.outcome == 1
        - predicate: mam_q037 != 1
        - predicate: q_sxb_q13.outcome % 128 >= 64
        input:
          control: Textarea
          placeholder: Specify other method...
          maxLength: 200

    # ===================================================================
    # SECTION: access_waiting
    # ===================================================================
    - id: b_specialist_care
      title: Specialist Care
      items:
      - id: q_acc_qint10
        kind: Comment
        title: The next questions are about the use of various health care services. I will start by asking about your experiences
          getting health care from a medical specialist.
      - id: q_acc_q10
        kind: Question
        title: In the past 12 months, did you require a visit to a medical specialist for a diagnosis or a consultation?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q11
        kind: Question
        title: In the past 12 months, did you ever experience any difficulties getting the specialist care you needed for a
          diagnosis or consultation?
        precondition:
        - predicate: q_acc_q10.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q12
        kind: Question
        title: What type of difficulties did you experience? (Mark all that apply)
        precondition:
        - predicate: q_acc_q10.outcome == 1
        - predicate: q_acc_q11.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty getting a referral
            2: Difficulty getting an appointment
            4: No specialists in the area
            8: Waited too long - between booking appointment and visit
            16: Waited too long - to see the doctor (i.e. in-office waiting)
            32: Transportation problems
            64: Language problem
            128: Cost
            256: Personal or family responsibilities
            512: General deterioration of health
            1024: Appointment cancelled or deferred by specialist
            2048: Still waiting for visit
            4096: Unable to leave the house because of a health problem
            8192: Other
      - id: q_acc_q12s
        kind: Question
        title: Please specify the other difficulty you experienced getting specialist care.
        precondition:
        - predicate: q_acc_q10.outcome == 1
        - predicate: q_acc_q11.outcome == 1
        - predicate: q_acc_q12.outcome % 16384 >= 8192
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
    - id: b_surgery
      title: Non-Emergency Surgery
      items:
      - id: q_acc_qint20
        kind: Comment
        title: The following questions are about any surgery not provided in an emergency.
      - id: q_acc_q20
        kind: Question
        title: In the past 12 months, did you require any non-emergency surgery?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q21
        kind: Question
        title: In the past 12 months, did you ever experience any difficulties getting the surgery you needed?
        precondition:
        - predicate: q_acc_q20.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q22
        kind: Question
        title: What type of difficulties did you experience? (Mark all that apply)
        precondition:
        - predicate: q_acc_q20.outcome == 1
        - predicate: q_acc_q21.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty getting an appointment with a surgeon
            2: Difficulty getting a diagnosis
            4: Waited too long - for a diagnostic test
            8: Waited too long - for a hospital bed to become available
            16: Waited too long - for surgery
            32: Service not available in the area
            64: Transportation problems
            128: Language problem
            256: Cost
            512: Personal or family responsibilities
            1024: General deterioration of health
            2048: Appointment cancelled or deferred by surgeon or hospital
            4096: Still waiting for surgery
            8192: Unable to leave the house because of a health problem
            16384: Other
      - id: q_acc_q22s
        kind: Question
        title: Please specify the other difficulty you experienced getting surgery.
        precondition:
        - predicate: q_acc_q20.outcome == 1
        - predicate: q_acc_q21.outcome == 1
        - predicate: q_acc_q22.outcome % 32768 >= 16384
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
    - id: b_diagnostic_tests
      title: Diagnostic Tests (MRI, CAT Scan, Angiography)
      items:
      - id: q_acc_qint30
        kind: Comment
        title: Now some questions about MRIs, CAT Scans and angiographies provided in a non-emergency situation.
      - id: q_acc_q30
        kind: Question
        title: In the past 12 months, did you require one of these tests?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q31
        kind: Question
        title: In the past 12 months, did you ever experience any difficulties getting the tests you needed?
        precondition:
        - predicate: q_acc_q30.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q32
        kind: Question
        title: What type of difficulties did you experience? (Mark all that apply)
        precondition:
        - predicate: q_acc_q30.outcome == 1
        - predicate: q_acc_q31.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty getting a referral
            2: Difficulty getting an appointment
            4: Waited too long - to get an appointment
            8: Waited too long - to get test (i.e. in-office waiting)
            16: Service not available at time required
            32: Service not available in the area
            64: Transportation problems
            128: Language problem
            256: Cost
            512: General deterioration of health
            1024: Did not know where to go (i.e. information problems)
            2048: Still waiting for test
            4096: Unable to leave the house because of a health problem
            8192: Other
      - id: q_acc_q32s
        kind: Question
        title: Please specify the other difficulty you experienced getting the diagnostic test.
        precondition:
        - predicate: q_acc_q30.outcome == 1
        - predicate: q_acc_q31.outcome == 1
        - predicate: q_acc_q32.outcome % 16384 >= 8192
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
    - id: b_health_info
      title: Health Information and Advice
      items:
      - id: q_acc_qint40
        kind: Comment
        title: Now I'd like you to think about yourself and family members living in your dwelling. The next questions are about
          your experiences getting health information or advice.
      - id: q_acc_q40
        kind: Question
        title: In the past 12 months, have you required health information or advice for yourself or a family member?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q40a
        kind: Question
        title: Who did you contact when you needed health information or advice for yourself or a family member? (Mark all that
          apply)
        precondition:
        - predicate: q_acc_q40.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Doctor's office
            2: Community health centre / CLSC
            4: Walk-in clinic
            8: Telephone health line
            16: Hospital emergency room
            32: Other hospital service
            64: Other
      - id: q_acc_q40as
        kind: Question
        title: Please specify the other contact for health information or advice.
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q40a.outcome % 128 >= 64
        input:
          control: Textarea
          placeholder: Specify other contact...
          maxLength: 200
      - id: q_acc_q41
        kind: Question
        title: In the past 12 months, did you ever experience any difficulties getting the health information or advice you
          needed for yourself or a family member?
        precondition:
        - predicate: q_acc_q40.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q42
        kind: Question
        title: Did you experience difficulties during 'regular' office hours (that is, 9:00 am to 5:00 pm, Monday to Friday)?
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Not required at this time
      - id: q_acc_q43
        kind: Question
        title: What type of difficulties did you experience during regular office hours? (Mark all that apply)
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        - predicate: q_acc_q42.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty contacting a physician or nurse
            2: Did not have a phone number
            4: Could not get through (i.e. no answer)
            8: Waited too long to speak to someone
            16: Did not get adequate info or advice
            32: Language problem
            64: Did not know where to go / call / uninformed
            128: Unable to leave the house because of a health problem
            256: Other
      - id: q_acc_q43s
        kind: Question
        title: Please specify the other difficulty during regular office hours.
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        - predicate: q_acc_q42.outcome == 1
        - predicate: q_acc_q43.outcome % 512 >= 256
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
      - id: q_acc_q44
        kind: Question
        title: Did you experience difficulties getting health information or advice during evenings and weekends (that is, 5:00
          to 9:00 pm Monday to Friday, or 9:00 am to 5:00 pm, Saturdays and Sundays)?
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Not required at this time
      - id: q_acc_q45
        kind: Question
        title: What type of difficulties did you experience during evenings and weekends? (Mark all that apply)
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        - predicate: q_acc_q44.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty contacting a physician or nurse
            2: Did not have a phone number
            4: Could not get through (i.e. no answer)
            8: Waited too long to speak to someone
            16: Did not get adequate info or advice
            32: Language problem
            64: Did not know where to go / call / uninformed
            128: Unable to leave the house because of a health problem
            256: Other
      - id: q_acc_q45s
        kind: Question
        title: Please specify the other difficulty during evenings and weekends.
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        - predicate: q_acc_q44.outcome == 1
        - predicate: q_acc_q45.outcome % 512 >= 256
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
      - id: q_acc_q46
        kind: Question
        title: Did you experience difficulties getting health information or advice during the middle of the night?
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Not required at this time
      - id: q_acc_q47
        kind: Question
        title: What type of difficulties did you experience during the middle of the night? (Mark all that apply)
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        - predicate: q_acc_q46.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty contacting a physician or nurse
            2: Did not have a phone number
            4: Could not get through (i.e. no answer)
            8: Waited too long to speak to someone
            16: Did not get adequate info or advice
            32: Language problem
            64: Did not know where to go / call / uninformed
            128: Unable to leave the house because of a health problem
            256: Other
      - id: q_acc_q47s
        kind: Question
        title: Please specify the other difficulty during the middle of the night.
        precondition:
        - predicate: q_acc_q40.outcome == 1
        - predicate: q_acc_q41.outcome == 1
        - predicate: q_acc_q46.outcome == 1
        - predicate: q_acc_q47.outcome % 512 >= 256
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
    - id: b_routine_care
      title: Routine and On-Going Care
      items:
      - id: q_acc_qint50
        kind: Comment
        title: Now some questions about your experiences when you needed health care services for routine or on-going care.
      - id: q_acc_q50a
        kind: Question
        title: Do you have a regular family doctor?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q50
        kind: Question
        title: In the past 12 months, did you require any routine or on-going care for yourself or a family member?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q51
        kind: Question
        title: In the past 12 months, did you ever experience any difficulties getting the routine or on-going care you or a
          family member needed?
        precondition:
        - predicate: q_acc_q50.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q52
        kind: Question
        title: Did you experience difficulties getting such care during 'regular' office hours (that is, 9:00 am to 5:00 pm,
          Monday to Friday)?
        precondition:
        - predicate: q_acc_q50.outcome == 1
        - predicate: q_acc_q51.outcome == 1
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Not required at this time
      - id: q_acc_q53
        kind: Question
        title: What type of difficulties did you experience during regular hours? (Mark all that apply)
        precondition:
        - predicate: q_acc_q50.outcome == 1
        - predicate: q_acc_q51.outcome == 1
        - predicate: q_acc_q52.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty contacting a physician
            2: Difficulty getting an appointment
            4: Do not have personal / family physician
            8: Waited too long - to get an appointment
            16: Waited too long - to see the doctor (i.e. in-office waiting)
            32: Service not available at time required
            64: Service not available in the area
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go (i.e. information problems)
            2048: Unable to leave the house because of a health problem
            4096: Other
      - id: q_acc_q53s
        kind: Question
        title: Please specify the other difficulty during regular hours for routine care.
        precondition:
        - predicate: q_acc_q50.outcome == 1
        - predicate: q_acc_q51.outcome == 1
        - predicate: q_acc_q52.outcome == 1
        - predicate: q_acc_q53.outcome % 8192 >= 4096
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
      - id: q_acc_q54
        kind: Question
        title: Did you experience difficulties getting such care during evenings and weekends (that is, 5:00 to 9:00 pm, Monday
          to Friday or 9:00 am to 5:00 pm, Saturdays and Sundays)?
        precondition:
        - predicate: q_acc_q50.outcome == 1
        - predicate: q_acc_q51.outcome == 1
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Not required at this time
      - id: q_acc_q55
        kind: Question
        title: What type of difficulties did you experience during evenings and weekends? (Mark all that apply)
        precondition:
        - predicate: q_acc_q50.outcome == 1
        - predicate: q_acc_q51.outcome == 1
        - predicate: q_acc_q54.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty contacting a physician
            2: Difficulty getting an appointment
            4: Do not have personal / family physician
            8: Waited too long - to get an appointment
            16: Waited too long - to see the doctor (i.e. in-office waiting)
            32: Service not available at time required
            64: Service not available in the area
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go (i.e. information problems)
            2048: Unable to leave the house because of a health problem
            4096: Other
      - id: q_acc_q55s
        kind: Question
        title: Please specify the other difficulty during evenings and weekends for routine care.
        precondition:
        - predicate: q_acc_q50.outcome == 1
        - predicate: q_acc_q51.outcome == 1
        - predicate: q_acc_q54.outcome == 1
        - predicate: q_acc_q55.outcome % 8192 >= 4096
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
    - id: b_immediate_care
      title: Immediate Care for Minor Health Problem
      items:
      - id: q_acc_qint60
        kind: Comment
        title: The next questions are about situations when you or a family member have needed immediate care for a minor health
          problem.
      - id: q_acc_q60
        kind: Question
        title: In the past 12 months, have you or a family member required immediate health care services for a minor health
          problem?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q61
        kind: Question
        title: In the past 12 months, did you ever experience any difficulties getting the immediate care needed for a minor
          health problem for yourself or a family member?
        precondition:
        - predicate: q_acc_q60.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_acc_q62
        kind: Question
        title: Did you experience difficulties getting such care during 'regular' office hours (that is, 9:00 am to 5:00 pm,
          Monday to Friday)?
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Not required at this time
      - id: q_acc_q63
        kind: Question
        title: What type of difficulties did you experience during regular hours? (Mark all that apply)
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        - predicate: q_acc_q62.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty contacting a physician
            2: Difficulty getting an appointment
            4: Do not have personal / family physician
            8: Waited too long - to get an appointment
            16: Waited too long - to see the doctor (i.e. in-office waiting)
            32: Service not available at time required
            64: Service not available in the area
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go (i.e. information problems)
            2048: Unable to leave the house because of a health problem
            4096: Other
      - id: q_acc_q63s
        kind: Question
        title: Please specify the other difficulty during regular hours for immediate care.
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        - predicate: q_acc_q62.outcome == 1
        - predicate: q_acc_q63.outcome % 8192 >= 4096
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
      - id: q_acc_q64
        kind: Question
        title: Did you experience difficulties getting such care during evenings and weekends (that is, 5:00 to 9:00 pm, Monday
          to Friday or 9:00 am to 5:00 pm, Saturdays and Sundays)?
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Not required at this time
      - id: q_acc_q65
        kind: Question
        title: What type of difficulties did you experience during evenings and weekends? (Mark all that apply)
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        - predicate: q_acc_q64.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty contacting a physician
            2: Difficulty getting an appointment
            4: Do not have personal / family physician
            8: Waited too long - to get an appointment
            16: Waited too long - to see the doctor (i.e. in-office waiting)
            32: Service not available at time required
            64: Service not available in the area
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go (i.e. information problems)
            2048: Unable to leave the house because of a health problem
            4096: Other
      - id: q_acc_q65s
        kind: Question
        title: Please specify the other difficulty during evenings and weekends for immediate care.
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        - predicate: q_acc_q64.outcome == 1
        - predicate: q_acc_q65.outcome % 8192 >= 4096
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
      - id: q_acc_q66
        kind: Question
        title: Did you experience difficulties getting such care during the middle of the night?
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Not required at this time
      - id: q_acc_q67
        kind: Question
        title: What type of difficulties did you experience during the middle of the night? (Mark all that apply)
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        - predicate: q_acc_q66.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty contacting a physician
            2: Difficulty getting an appointment
            4: Do not have personal / family physician
            8: Waited too long - to get an appointment
            16: Waited too long - to see the doctor (i.e. in-office waiting)
            32: Service not available at time required
            64: Service not available in the area
            128: Transportation problems
            256: Language problem
            512: Cost
            1024: Did not know where to go (i.e. information problems)
            2048: Unable to leave the house because of a health problem
            4096: Other
      - id: q_acc_q67s
        kind: Question
        title: Please specify the other difficulty during the middle of the night for immediate care.
        precondition:
        - predicate: q_acc_q60.outcome == 1
        - predicate: q_acc_q61.outcome == 1
        - predicate: q_acc_q66.outcome == 1
        - predicate: q_acc_q67.outcome % 8192 >= 4096
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
    - id: b_wtm_intro
      title: Waiting Times Introduction
      precondition:
      - predicate: q_acc_q10.outcome == 1 or q_acc_q20.outcome == 1 or q_acc_q30.outcome == 1
      items:
      - id: q_wtm_qint
        kind: Comment
        title: Now some additional questions about your experiences waiting for health care services.
    - id: b_wtm_specialist
      title: Waiting Times - Specialist Visit
      precondition:
      - predicate: q_acc_q10.outcome == 1
      items:
      - id: q_wtm_q01
        kind: Question
        title: In the past 12 months, did you require a visit to a medical specialist for a diagnosis or a consultation for
          a new illness or condition?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q02
        kind: Question
        title: For what type of condition?
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        postcondition:
        - predicate: not (q_wtm_q02.outcome == 8 and sex == 1)
          hint: Gynaecological problems cannot be selected for male respondents.
        input:
          control: Dropdown
          labels:
            1: Heart condition or stroke
            2: Cancer
            3: Asthma or other breathing conditions
            4: Arthritis or rheumatism
            5: Cataract or other eye conditions
            6: Mental health disorder
            7: Skin conditions
            8: Gynaecological problems
            9: Other
      - id: q_wtm_q02s
        kind: Question
        title: Please specify the type of condition.
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q02.outcome == 9
        input:
          control: Textarea
          placeholder: Specify condition...
          maxLength: 200
      - id: q_wtm_q03
        kind: Question
        title: 'Were you referred by:'
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        input:
          control: Radio
          labels:
            1: A family doctor
            2: Another specialist
            3: Another health care provider
            4: Did not require a referral
      - id: q_wtm_q04
        kind: Question
        title: Have you already visited the medical specialist?
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q05
        kind: Question
        title: Thinking about this visit, did you experience any difficulties seeing the specialist?
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q04.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q06
        kind: Question
        title: What type of difficulties did you experience? (Mark all that apply)
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q04.outcome == 1
        - predicate: q_wtm_q05.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty getting a referral
            2: Difficulty getting an appointment
            4: No specialists in the area
            8: Waited too long - between booking appointment and visit
            16: Waited too long - to see the doctor (in-office waiting)
            32: Transportation problems
            64: Language problem
            128: Cost
            256: Personal or family responsibilities
            512: General deterioration of health
            1024: Appointment cancelled or deferred by specialist
            2048: Unable to leave the house because of a health problem
            4096: Other
      - id: q_wtm_q06s
        kind: Question
        title: Please specify the other difficulty.
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q04.outcome == 1
        - predicate: q_wtm_q05.outcome == 1
        - predicate: q_wtm_q06.outcome % 8192 >= 4096
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
      - id: q_wtm_q07a
        kind: Question
        title: How long did you have to wait between when you and your doctor decided you should see a specialist and when you
          actually visited the specialist?
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q04.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n07b
        kind: Question
        title: 'Unit of time for the wait:'
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q04.outcome == 1
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q08a
        kind: Question
        title: How long have you been waiting since you and your doctor decided you should see a specialist?
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q04.outcome == 0
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n08b
        kind: Question
        title: 'Unit of time for the wait:'
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q04.outcome == 0
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q10
        kind: Question
        title: 'In your view, was the waiting time (or has the waiting time been):'
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        input:
          control: Radio
          labels:
            1: Acceptable
            2: Not acceptable
            3: No view
      - id: q_wtm_q11a
        kind: Question
        title: In this particular case, what do you think is an acceptable waiting time?
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q10.outcome == 2
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n11b
        kind: Question
        title: 'Unit of time:'
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q10.outcome == 2
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q12
        kind: Question
        title: Was your visit cancelled or postponed at any time?
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q13
        kind: Question
        title: 'Was it cancelled or postponed by: (Mark all that apply)'
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q12.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Yourself
            2: The specialist
            4: Other
      - id: q_wtm_q13s
        kind: Question
        title: Please specify who cancelled or postponed.
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q12.outcome == 1
        - predicate: q_wtm_q13.outcome % 8 >= 4
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
      - id: q_wtm_q14
        kind: Question
        title: Do you think that your health, or other aspects of your life, have been affected in any way because you had to
          wait for this visit?
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q15
        kind: Question
        title: How was your life affected as a result of waiting for this visit? (Mark all that apply)
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q14.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Worry, anxiety, stress
            2: Worry or stress for family or friends
            4: Pain
            8: Problems with activities of daily living
            16: Loss of work
            32: Loss of income
            64: Increased dependence on relatives/friends
            128: Increased use of over-the-counter drugs
            256: Overall health deteriorated, condition got worse
            512: Health problem improved
            1024: Personal relationships suffered
            2048: Other
      - id: q_wtm_q15s
        kind: Question
        title: Please specify how your life was affected.
        precondition:
        - predicate: q_wtm_q01.outcome == 1
        - predicate: q_wtm_q14.outcome == 1
        - predicate: q_wtm_q15.outcome % 4096 >= 2048
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_wtm_surgery
      title: Waiting Times - Surgery
      precondition:
      - predicate: q_acc_q20.outcome == 1
      items:
      - id: q_wtm_q16
        kind: Question
        title: What type of surgery did you require?
        postcondition:
        - predicate: not (q_wtm_q16.outcome == 5 and sex == 1)
          hint: Hysterectomy cannot be selected for male respondents.
        input:
          control: Dropdown
          labels:
            1: Cardiac surgery
            2: Cancer related surgery
            3: Hip or knee replacement surgery
            4: Cataract or other eye surgery
            5: Hysterectomy
            6: Removal of gall bladder
            7: Other
      - id: q_wtm_q16s
        kind: Question
        title: Please specify the type of surgery.
        precondition:
        - predicate: q_wtm_q16.outcome == 7
        input:
          control: Textarea
          placeholder: Specify surgery type...
          maxLength: 200
      - id: q_wtm_q17
        kind: Question
        title: Did you already have this surgery?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q18
        kind: Question
        title: Did the surgery require an overnight hospital stay?
        precondition:
        - predicate: q_wtm_q17.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q19
        kind: Question
        title: Did you experience any difficulties getting this surgery?
        precondition:
        - predicate: q_wtm_q17.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q20
        kind: Question
        title: What type of difficulties did you experience? (Mark all that apply)
        precondition:
        - predicate: q_wtm_q17.outcome == 1
        - predicate: q_wtm_q19.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty getting an appointment with a surgeon
            2: Difficulty getting a diagnosis
            4: Waited too long - for a diagnostic test
            8: Waited too long - for a hospital bed to become available
            16: Waited too long - for surgery
            32: Service not available in the area
            64: Transportation problems
            128: Language problem
            256: Cost
            512: Personal or family responsibilities
            1024: General deterioration of health
            2048: Appointment cancelled or deferred by surgeon or hospital
            4096: Unable to leave the house because of a health problem
            8192: Other
      - id: q_wtm_q20s
        kind: Question
        title: Please specify the other difficulty.
        precondition:
        - predicate: q_wtm_q17.outcome == 1
        - predicate: q_wtm_q19.outcome == 1
        - predicate: q_wtm_q20.outcome % 16384 >= 8192
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
      - id: q_wtm_q21a
        kind: Question
        title: How long did you have to wait between when you and the surgeon decided to go ahead with surgery and the day of
          surgery?
        precondition:
        - predicate: q_wtm_q17.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n21b
        kind: Question
        title: 'Unit of time for the wait:'
        precondition:
        - predicate: q_wtm_q17.outcome == 1
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q22
        kind: Question
        title: Will the surgery require an overnight hospital stay?
        precondition:
        - predicate: q_wtm_q17.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q23a
        kind: Question
        title: How long have you been waiting since you and the surgeon decided to go ahead with the surgery?
        precondition:
        - predicate: q_wtm_q17.outcome == 0
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n23b
        kind: Question
        title: 'Unit of time for the wait:'
        precondition:
        - predicate: q_wtm_q17.outcome == 0
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q24
        kind: Question
        title: 'In your view, was the waiting time (or has the waiting time been):'
        input:
          control: Radio
          labels:
            1: Acceptable
            2: Not acceptable
            3: No view
      - id: q_wtm_q25a
        kind: Question
        title: In this particular case, what do you think is an acceptable waiting time?
        precondition:
        - predicate: q_wtm_q24.outcome == 2
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n25b
        kind: Question
        title: 'Unit of time:'
        precondition:
        - predicate: q_wtm_q24.outcome == 2
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q26
        kind: Question
        title: Was your surgery cancelled or postponed at any time?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q27
        kind: Question
        title: 'Was it cancelled or postponed by: (Mark all that apply)'
        precondition:
        - predicate: q_wtm_q26.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Yourself
            2: The surgeon
            4: The hospital
            8: Other
      - id: q_wtm_q27s
        kind: Question
        title: Please specify who cancelled or postponed.
        precondition:
        - predicate: q_wtm_q26.outcome == 1
        - predicate: q_wtm_q27.outcome % 16 >= 8
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
      - id: q_wtm_q28
        kind: Question
        title: Do you think that your health, or other aspects of your life, have been affected in any way due to waiting for
          this surgery?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q29
        kind: Question
        title: How was your life affected as a result of waiting for surgery? (Mark all that apply)
        precondition:
        - predicate: q_wtm_q28.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Worry, anxiety, stress
            2: Worry or stress for family or friends
            4: Pain
            8: Problems with activities of daily living
            16: Loss of work
            32: Loss of income
            64: Increased dependence on relatives/friends
            128: Increased use of over-the-counter drugs
            256: Overall health deteriorated, condition got worse
            512: Health problem improved
            1024: Personal relationships suffered
            2048: Other
      - id: q_wtm_q29s
        kind: Question
        title: Please specify how your life was affected.
        precondition:
        - predicate: q_wtm_q28.outcome == 1
        - predicate: q_wtm_q29.outcome % 4096 >= 2048
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
    - id: b_wtm_diagnostic
      title: Waiting Times - Diagnostic Test
      precondition:
      - predicate: q_acc_q30.outcome == 1
      items:
      - id: q_wtm_q30
        kind: Question
        title: What type of test did you require?
        input:
          control: Radio
          labels:
            1: MRI
            2: CAT Scan
            3: Angiography
      - id: q_wtm_q31
        kind: Question
        title: For what type of condition?
        input:
          control: Dropdown
          labels:
            1: Heart disease or stroke
            2: Cancer
            3: Joints or fractures
            4: Neurological or brain disorders
            5: Other
      - id: q_wtm_q31s
        kind: Question
        title: Please specify the type of condition.
        precondition:
        - predicate: q_wtm_q31.outcome == 5
        input:
          control: Textarea
          placeholder: Specify condition...
          maxLength: 200
      - id: q_wtm_q32
        kind: Question
        title: Did you already have this test?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q33
        kind: Question
        title: Where was the test done?
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        input:
          control: Radio
          labels:
            1: Hospital
            2: Public clinic
            3: Private clinic
            4: Other
      - id: q_wtm_q33s
        kind: Question
        title: Please specify where the test was done.
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        - predicate: q_wtm_q33.outcome == 4
        input:
          control: Textarea
          placeholder: Specify location...
          maxLength: 200
      - id: q_wtm_q34
        kind: Question
        title: 'Was the clinic located:'
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        - predicate: q_wtm_q33.outcome == 3
        input:
          control: Radio
          labels:
            1: In your province
            2: In another province
            3: Other
      - id: q_wtm_q34s
        kind: Question
        title: Please specify where the clinic was located.
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        - predicate: q_wtm_q33.outcome == 3
        - predicate: q_wtm_q34.outcome == 3
        input:
          control: Textarea
          placeholder: Specify location...
          maxLength: 200
      - id: q_wtm_q35
        kind: Question
        title: Were you a patient in a hospital at the time of the test?
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q36
        kind: Question
        title: Did you experience any difficulties getting this test?
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q37
        kind: Question
        title: What type of difficulties did you experience? (Mark all that apply)
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        - predicate: q_wtm_q36.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Difficulty getting a referral
            2: Difficulty getting an appointment
            4: Waited too long - to get an appointment
            8: Waited too long - to get test (in-office waiting)
            16: Service not available at time required
            32: Service not available in the area
            64: Transportation problems
            128: Language problem
            256: Cost
            512: General deterioration of health
            1024: Did not know where to go
            2048: Unable to leave the house because of a health problem
            4096: Other
      - id: q_wtm_q37s
        kind: Question
        title: Please specify the other difficulty.
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        - predicate: q_wtm_q36.outcome == 1
        - predicate: q_wtm_q37.outcome % 8192 >= 4096
        input:
          control: Textarea
          placeholder: Specify other difficulty...
          maxLength: 200
      - id: q_wtm_q38a
        kind: Question
        title: How long did you have to wait between when you and your doctor decided to go ahead with the test and the day
          of the test?
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n38b
        kind: Question
        title: 'Unit of time for the wait:'
        precondition:
        - predicate: q_wtm_q32.outcome == 1
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q39a
        kind: Question
        title: How long have you been waiting for the test since you and your doctor decided to go ahead with the test?
        precondition:
        - predicate: q_wtm_q32.outcome == 0
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n39b
        kind: Question
        title: 'Unit of time for the wait:'
        precondition:
        - predicate: q_wtm_q32.outcome == 0
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q40
        kind: Question
        title: 'In your view, was the waiting time (or has the waiting time been):'
        input:
          control: Radio
          labels:
            1: Acceptable
            2: Not acceptable
            3: No view
      - id: q_wtm_q41a
        kind: Question
        title: In this particular case, what do you think is an acceptable waiting time?
        precondition:
        - predicate: q_wtm_q40.outcome == 2
        input:
          control: Editbox
          min: 1
          max: 365
          right: (enter amount)
      - id: q_wtm_n41b
        kind: Question
        title: 'Unit of time:'
        precondition:
        - predicate: q_wtm_q40.outcome == 2
        input:
          control: Radio
          labels:
            1: Days
            2: Weeks
            3: Months
      - id: q_wtm_q42
        kind: Question
        title: Was your test cancelled or postponed at any time?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q43
        kind: Question
        title: 'Was it cancelled or postponed by:'
        precondition:
        - predicate: q_wtm_q42.outcome == 1
        input:
          control: Dropdown
          labels:
            1: Yourself
            2: The specialist
            3: The hospital
            4: The clinic
            5: Other
      - id: q_wtm_q43s
        kind: Question
        title: Please specify who cancelled or postponed.
        precondition:
        - predicate: q_wtm_q42.outcome == 1
        - predicate: q_wtm_q43.outcome == 5
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200
      - id: q_wtm_q44
        kind: Question
        title: Do you think that your health, or other aspects of your life, have been affected in any way due to waiting for
          this test?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_wtm_q45
        kind: Question
        title: How was your life affected as a result of waiting for this test? (Mark all that apply)
        precondition:
        - predicate: q_wtm_q44.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Worry, anxiety, stress
            2: Worry or stress for family or friends
            4: Pain
            8: Problems with activities of daily living
            16: Loss of work
            32: Loss of income
            64: Increased dependence on relatives/friends
            128: Increased use of over-the-counter drugs
            256: Overall health deteriorated, condition got worse
            512: Health problem improved
            1024: Personal relationships suffered
            2048: Other
      - id: q_wtm_q45s
        kind: Question
        title: Please specify how your life was affected.
        precondition:
        - predicate: q_wtm_q44.outcome == 1
        - predicate: q_wtm_q45.outcome % 4096 >= 2048
        input:
          control: Textarea
          placeholder: Specify...
          maxLength: 200

    # ===================================================================
    # SECTION: injuries
    # ===================================================================
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

    # ===================================================================
    # SECTION: labour_education
    # ===================================================================
    - id: b_current_employment
      title: Current Employment Status
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      items:
      - id: q_lbf_qint
        kind: Comment
        title: The next few questions concern your activities in the last 7 days.
      - id: q_lbf_q01
        kind: Question
        title: Last week, did you work at a job or a business?
        postcondition:
        - predicate: not (gen_q08 == 2 and q_lbf_q01.outcome == 1)
          hint: Earlier you indicated you did not work in the past 12 months, but now report working last week. Please verify.
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Permanently unable to work
      - id: q_lbf_q02
        kind: Question
        title: Last week, did you have a job or business from which you were absent?
        precondition:
        - predicate: q_lbf_q01.outcome == 2
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_job_details
      title: Job Details
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1)
      items:
      - id: q_lbf_q03
        kind: Question
        title: Did you have more than one job or business last week?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_lbf_qint3
        kind: Comment
        title: The next questions are about your current or most recent job or business.
      - id: q_lbf_q31
        kind: Question
        title: Are you an employee or self-employed?
        input:
          control: Radio
          labels:
            1: Employee
            2: Self-employed
            3: Working in a family business without pay
      - id: q_lbf_q31a
        kind: Question
        title: Do you have any employees?
        precondition:
        - predicate: q_lbf_q31.outcome == 2
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_lbf_q32
        kind: Question
        title: What is the name of your business?
        precondition:
        - predicate: q_lbf_q31.outcome == 2
        input:
          control: Textarea
          placeholder: Business name...
          maxLength: 200
      - id: q_lbf_q33
        kind: Question
        title: For whom do you work?
        precondition:
        - predicate: q_lbf_q31.outcome == 1 or q_lbf_q31.outcome == 3
        input:
          control: Textarea
          placeholder: Employer name...
          maxLength: 200
      - id: q_lbf_q34
        kind: Question
        title: What kind of business, industry or service is this?
        input:
          control: Textarea
          placeholder: Business type...
          maxLength: 200
      - id: q_lbf_q35
        kind: Question
        title: What kind of work are you doing?
        input:
          control: Textarea
          placeholder: Kind of work...
          maxLength: 200
      - id: q_lbf_q36
        kind: Question
        title: What are your most important activities or duties?
        input:
          control: Textarea
          placeholder: Activities or duties...
          maxLength: 200
      - id: q_lbf_q36a
        kind: Question
        title: Is your job permanent, or is there some way that it is not permanent?
        input:
          control: Radio
          labels:
            1: Permanent
            2: Not permanent
      - id: q_lbf_q36b
        kind: Question
        title: In what way is your job not permanent?
        precondition:
        - predicate: q_lbf_q36a.outcome == 2
        input:
          control: Radio
          labels:
            1: Seasonal
            2: Temporary, term or contract
            3: Casual job
            4: Work done through a temporary help agency
            5: Other
      - id: q_lbf_q37
        kind: Question
        title: At your place of work, what are the restrictions on smoking?
        input:
          control: Radio
          labels:
            1: Restricted completely
            2: Allowed in designated areas
            3: Restricted only in certain places
            4: Not restricted at all
    - id: b_absence_reason
      title: Reason for Absence
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      - predicate: q_lbf_q01.outcome == 2
      - predicate: q_lbf_q02.outcome == 1
      items:
      - id: q_lbf_q41
        kind: Question
        title: What was the main reason you were absent from work last week?
        postcondition:
        - predicate: not (sex == 1 and q_lbf_q41.outcome == 4)
          hint: Maternity leave is only applicable for females.
        - predicate: not (q_lbf_q31.outcome == 1 and q_lbf_q41.outcome in [12, 13])
          hint: Self-employed reasons are not valid for employees.
        - predicate: not (q_lbf_q31.outcome == 2 and q_lbf_q41.outcome in [8, 9, 10, 11])
          hint: Employee reasons are not valid for self-employed.
        - predicate: not (q_lbf_q31.outcome == 3 and q_lbf_q41.outcome in [8, 9, 10, 11, 12])
          hint: These reasons are not valid for unpaid family workers.
        input:
          control: Dropdown
          labels:
            1: Own illness or disability
            2: Caring for own children
            3: Caring for elder relatives
            4: Maternity leave
            5: Other personal or family responsibilities
            6: Vacation
            7: Labour dispute
            8: Temporary layoff due to business conditions
            9: Seasonal layoff
            10: Casual job, no work available
            11: Work schedule
            12: Self-employed, no work available
            13: Seasonal business
            14: School or educational leave
            15: Other
      - id: q_lbf_q41s
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_lbf_q41.outcome == 15
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_lbf_q41a
        kind: Question
        title: Was that due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or
          to another reason?
        precondition:
        - predicate: q_lbf_q41.outcome == 1
        input:
          control: Radio
          labels:
            1: Physical health
            2: Emotional or mental health (including stress)
            3: Use of alcohol or drugs
            4: Another reason
    - id: b_hours_schedule
      title: Hours and Schedule
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1)
      items:
      - id: q_lbf_q42
        kind: Question
        title: About how many hours a week do you usually work at your job or business?
        postcondition:
        - predicate: q_lbf_q42.outcome <= 84
          hint: 'Warning: more than 84 hours per week reported. Please verify.'
        input:
          control: Editbox
          min: 1
          max: 168
          right: hours
      - id: q_lbf_q44
        kind: Question
        title: Which of the following best describes the hours you usually work at your job or business?
        input:
          control: Radio
          labels:
            1: Regular daytime schedule or shift
            2: Regular evening shift
            3: Regular night shift
            4: Rotating shift
            5: Split shift
            6: On call
            7: Irregular schedule
            8: Other
      - id: q_lbf_q44s
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_lbf_q44.outcome == 8
        input:
          control: Textarea
          placeholder: Specify schedule...
          maxLength: 200
      - id: q_lbf_q45
        kind: Question
        title: What is the main reason that you work this schedule?
        precondition:
        - predicate: q_lbf_q44.outcome != 1
        input:
          control: Radio
          labels:
            1: Requirement of job / no choice
            2: Going to school
            3: Caring for own children
            4: Caring for other relatives
            5: To earn more money
            6: Likes to work this schedule
            7: Other
      - id: q_lbf_q45s
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_lbf_q44.outcome != 1
        - predicate: q_lbf_q45.outcome == 7
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_lbf_q46
        kind: Question
        title: Do you usually work on weekends at this job or business?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_multiple_jobs
      title: Multiple Jobs Details
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1)
      - predicate: had_multiple_jobs == 1
      items:
      - id: q_lbf_q51
        kind: Question
        title: For how many weeks in a row have you held more than one job?
        input:
          control: Editbox
          min: 1
          max: 52
          right: weeks
      - id: q_lbf_q52
        kind: Question
        title: What is the main reason that you hold more than one job?
        input:
          control: Radio
          labels:
            1: To meet regular household expenses
            2: To pay off debts
            3: To buy something special
            4: To save for the future
            5: To gain experience
            6: To build up a business
            7: Enjoys the work of the second job
            8: Other
      - id: q_lbf_q52s
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_lbf_q52.outcome == 8
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_lbf_q53
        kind: Question
        title: About how many hours a week do you usually work at your other job(s)?
        postcondition:
        - predicate: q_lbf_q53.outcome <= 30
          hint: 'Warning: more than 30 hours at other jobs reported. Please verify.'
        input:
          control: Editbox
          min: 1
          max: 167
          right: hours
      - id: q_lbf_q54
        kind: Question
        title: Do you usually work on weekends at your other job(s)?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_job_search
      title: Job Search
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      - predicate: q_lbf_q01.outcome == 2
      - predicate: q_lbf_q02.outcome == 0
      items:
      - id: q_lbf_q11
        kind: Question
        title: In the past 4 weeks, did you do anything to find work?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_lbf_q13
        kind: Question
        title: What is the main reason that you are not currently working at a job or business?
        precondition:
        - predicate: q_lbf_q11.outcome == 0
        postcondition:
        - predicate: not (sex == 1 and q_lbf_q13.outcome == 4)
          hint: Pregnancy is only applicable for females.
        input:
          control: Dropdown
          labels:
            1: Own illness or disability
            2: Caring for own children
            3: Caring for elder relatives
            4: Pregnancy
            5: Other personal or family responsibilities
            6: Vacation
            7: School or educational leave
            8: Retired
            9: Believes no work available
            10: Other
      - id: q_lbf_q13s
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_lbf_q11.outcome == 0
        - predicate: q_lbf_q13.outcome == 10
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_lbf_q13a
        kind: Question
        title: Is this due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or
          to another reason?
        precondition:
        - predicate: q_lbf_q11.outcome == 0
        - predicate: q_lbf_q13.outcome == 1
        input:
          control: Radio
          labels:
            1: Physical health
            2: Emotional or mental health (including stress)
            3: Use of alcohol or drugs
            4: Another reason
    - id: b_past_12_months
      title: Past 12 Months Employment
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      - predicate: q_lbf_q01.outcome != 1
      items:
      - id: q_lbf_qint2
        kind: Comment
        title: Now some questions about jobs or employment which you have had during the past 12 months.
        precondition:
        - predicate: q_lbf_q01.outcome == 3 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 0 and q_lbf_q11.outcome == 1)
            or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 0 and q_lbf_q11.outcome == 0 and q_lbf_q13.outcome == 1)
      - id: q_lbf_q21
        kind: Question
        title: Did you work at a job or a business at any time in the past 12 months?
        postcondition:
        - predicate: not (gen_q08 == 2 and q_lbf_q21.outcome == 1)
          hint: Earlier you indicated no work in the past 12 months, but now report working. Please verify.
        - predicate: not (gen_q08 == 1 and q_lbf_q21.outcome == 0)
          hint: Earlier you indicated working in the past 12 months, but now report not working. Please verify.
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_lbf_q22
        kind: Question
        title: During the past 12 months, did you do anything to find work?
        precondition:
        - predicate: q_lbf_q21.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_lbf_q23
        kind: Question
        title: During that 12 months, did you work at more than one job or business at the same time?
        precondition:
        - predicate: q_lbf_q21.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
        codeBlock: |
          if q_lbf_q03.outcome == 1 or q_lbf_q23.outcome == 1:
              had_multiple_jobs = 1
    - id: b_weeks_worked
      title: Weeks Worked and Job Search
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1) or q_lbf_q21.outcome == 1
      items:
      - id: q_lbf_q61
        kind: Question
        title: During the past 52 weeks, how many weeks did you do any work at a job or a business?
        input:
          control: Editbox
          min: 1
          max: 52
          right: weeks
        codeBlock: |
          weeks_worked = q_lbf_q61.outcome
      - id: q_lbf_q71a
        kind: Question
        title: That leaves 1 week. During that week, did you look for work?
        precondition:
        - predicate: q_lbf_q61.outcome == 51
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
        codeBlock: |
          if q_lbf_q71a.outcome == 1:
              weeks_looking = 1
          else:
              weeks_looking = 0
      - id: q_lbf_q71
        kind: Question
        title: During the past 52 weeks, how many weeks were you looking for work?
        precondition:
        - predicate: q_lbf_q61.outcome <= 50
        input:
          control: Editbox
          min: 0
          max: 51
          right: weeks
        codeBlock: |
          weeks_looking = q_lbf_q71.outcome
      - id: q_lbf_q72
        kind: Question
        title: That leaves some weeks during which you were neither working nor looking for work. Is that correct?
        precondition:
        - predicate: q_lbf_q61.outcome <= 50
        - predicate: q_lbf_q61.outcome + q_lbf_q71.outcome < 52
        postcondition:
        - predicate: q_lbf_q72.outcome == 1
          hint: The total weeks working and looking for work do not add up to 52. Please go back and correct the values.
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_lbf_q73
        kind: Question
        title: What is the main reason that you were not looking for work?
        precondition:
        - predicate: q_lbf_q61.outcome < 52
        - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1) or (q_lbf_q01.outcome ==
            2 and q_lbf_q02.outcome == 0 and q_lbf_q11.outcome == 1)
        postcondition:
        - predicate: not (sex == 1 and q_lbf_q73.outcome == 4)
          hint: Pregnancy is only applicable for females.
        input:
          control: Dropdown
          labels:
            1: Own illness or disability
            2: Caring for own children
            3: Caring for elder relatives
            4: Pregnancy
            5: Other personal or family responsibilities
            6: Vacation
            7: Labour dispute
            8: Temporary layoff due to business conditions
            9: Seasonal layoff
            10: Casual job, no work available
            11: Work schedule
            12: School or educational leave
            13: Retired
            14: Believes no work available
            15: Other
      - id: q_lbf_q73s
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_lbf_q61.outcome < 52
        - predicate: q_lbf_q73.outcome == 15
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_lbf_q73a
        kind: Question
        title: Was that due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or
          to another reason?
        precondition:
        - predicate: q_lbf_q61.outcome < 52
        - predicate: q_lbf_q73.outcome == 1
        input:
          control: Radio
          labels:
            1: Physical health
            2: Emotional or mental health (including stress)
            3: Use of alcohol or drugs
            4: Another reason
    - id: b_current_work
      title: Current Work Status
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      items:
      - id: q_lf2_r1
        kind: Comment
        title: The next questions concern your activities in the last 7 days.
      - id: q_lf2_q1
        kind: Question
        title: Last week, did you work at a job or a business?
        postcondition:
        - predicate: not (gen_q08 == 2 and q_lf2_q1.outcome == 1)
          hint: Earlier you indicated no work in the past 12 months, but now report working last week. Please verify.
        input:
          control: Radio
          labels:
            1: 'Yes'
            2: 'No'
            3: Permanently unable to work
      - id: q_lf2_q2
        kind: Question
        title: Last week, did you have a job or business from which you were absent?
        precondition:
        - predicate: q_lf2_q1.outcome == 2
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_lf2_q3
        kind: Question
        title: Did you have more than one job or business last week?
        precondition:
        - predicate: q_lf2_q1.outcome == 1 or (q_lf2_q1.outcome == 2 and q_lf2_q2.outcome == 1)
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_lf2_q4
        kind: Question
        title: In the past 4 weeks, did you do anything to find work?
        precondition:
        - predicate: q_lf2_q1.outcome == 2
        - predicate: q_lf2_q2.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_job_details
      title: Job Details
      precondition:
      - predicate: age >= 15
      - predicate: age <= 75
      - predicate: q_lf2_q1.outcome == 1 or (q_lf2_q1.outcome == 2 and q_lf2_q2.outcome == 1)
      items:
      - id: q_lf2_r5
        kind: Comment
        title: The next questions are about your current job or business.
      - id: q_lf2_q5
        kind: Question
        title: About how many hours a week do you usually work at your job or business?
        postcondition:
        - predicate: q_lf2_q5.outcome <= 84
          hint: 'Warning: more than 84 hours per week reported. Please verify.'
        input:
          control: Editbox
          min: 1
          max: 168
          right: hours
      - id: q_lf2_q6
        kind: Question
        title: At your place of work, what are the restrictions on smoking?
        input:
          control: Radio
          labels:
            1: Restricted completely
            2: Allowed in designated areas
            3: Restricted only in certain places
            4: Not restricted at all
      - id: q_lf2_q7
        kind: Question
        title: About how many hours a week do you usually work at your other job(s)?
        precondition:
        - predicate: q_lf2_q3.outcome == 1
        postcondition:
        - predicate: q_lf2_q7.outcome <= 30
          hint: 'Warning: more than 30 hours at other jobs reported. Please verify.'
        input:
          control: Editbox
          min: 1
          max: 167
          right: hours
    - id: b_respondent_education
      title: Selected Respondent Education
      precondition:
      - predicate: age >= 14
      items:
      - id: q_edu_r01
        kind: Comment
        title: Next, education.
      - id: q_edu_q01
        kind: Question
        title: What is the highest grade of elementary or high school you have ever completed?
        input:
          control: Radio
          labels:
            1: Grade 8 or lower
            2: Grade 9-10
            3: Grade 11-13
      - id: q_edu_q02
        kind: Question
        title: Did you graduate from high school (secondary school)?
        precondition:
        - predicate: q_edu_q01.outcome == 3
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_edu_q03
        kind: Question
        title: Have you received any other education that could be counted towards a degree, certificate or diploma from an
          educational institution?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_edu_q04
        kind: Question
        title: What is the highest degree, certificate or diploma you have obtained?
        precondition:
        - predicate: q_edu_q03.outcome == 1
        input:
          control: Radio
          labels:
            1: No post-secondary degree, certificate or diploma
            2: Trade certificate or diploma
            3: Non-university certificate or diploma (community college, CEGEP, school of nursing, etc.)
            4: University certificate below bachelor's level
            5: Bachelor's degree
            6: University degree or certificate above bachelor's degree
      - id: q_edu_q05
        kind: Question
        title: Are you currently attending a school, college or university?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_edu_q06
        kind: Question
        title: Are you enrolled as a full-time student or a part-time student?
        precondition:
        - predicate: q_edu_q05.outcome == 1
        input:
          control: Radio
          labels:
            1: Full-time
            2: Part-time
    - id: b_other_member_education
      title: Other Household Member Education
      precondition:
      - predicate: has_other_hh_members_14plus == 1
      items:
      - id: q_edu_r07a
        kind: Comment
        title: Now I'd like you to think about the rest of your household.
      - id: q_edu_q07
        kind: Question
        title: What is the highest grade of elementary or high school the other household member ever completed?
        input:
          control: Radio
          labels:
            1: Grade 8 or lower
            2: Grade 9-10
            3: Grade 11-13
      - id: q_edu_q08
        kind: Question
        title: Did he/she graduate from high school (secondary school)?
        precondition:
        - predicate: q_edu_q07.outcome == 3
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_edu_q09
        kind: Question
        title: Has he/she received any other education that could be counted towards a degree, certificate or diploma from an
          educational institution?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_edu_q10
        kind: Question
        title: What is the highest degree, certificate or diploma he/she has obtained?
        precondition:
        - predicate: q_edu_q09.outcome == 1
        input:
          control: Radio
          labels:
            1: No post-secondary degree, certificate or diploma
            2: Trade certificate or diploma
            3: Non-university certificate or diploma (community college, CEGEP, school of nursing, etc.)
            4: University certificate below bachelor's level
            5: Bachelor's degree
            6: University degree or certificate above bachelor's degree

    # ===================================================================
    # SECTION: income_housing
    # ===================================================================
    - id: b_insurance
      title: Insurance Coverage
      items:
      - id: q_ins_qint
        kind: Comment
        title: Now, turning to your insurance coverage. Please include any private, government or employer-paid plans.
      - id: q_ins_q1
        kind: Question
        title: Do you have insurance that covers all or part of the cost of your prescription medications?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ins_q1a
        kind: Question
        title: 'Is it: (Mark all that apply)'
        precondition:
        - predicate: q_ins_q1.outcome == 1
        input:
          control: Checkbox
          labels:
            1: A government-sponsored plan
            2: An employer-sponsored plan
            4: A private plan
      - id: q_ins_q2
        kind: Question
        title: Do you have insurance that covers all or part of your dental expenses?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ins_q2a
        kind: Question
        title: 'Is it: (Mark all that apply)'
        precondition:
        - predicate: q_ins_q2.outcome == 1
        input:
          control: Checkbox
          labels:
            1: A government-sponsored plan
            2: An employer-sponsored plan
            4: A private plan
      - id: q_ins_q3
        kind: Question
        title: Do you have insurance that covers all or part of the costs of eye glasses or contact lenses?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ins_q3a
        kind: Question
        title: 'Is it: (Mark all that apply)'
        precondition:
        - predicate: q_ins_q3.outcome == 1
        input:
          control: Checkbox
          labels:
            1: A government-sponsored plan
            2: An employer-sponsored plan
            4: A private plan
      - id: q_ins_q4
        kind: Question
        title: Do you have insurance that covers all or part of hospital charges for a private or semi-private room?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_ins_q4a
        kind: Question
        title: 'Is it: (Mark all that apply)'
        precondition:
        - predicate: q_ins_q4.outcome == 1
        input:
          control: Checkbox
          labels:
            1: A government-sponsored plan
            2: An employer-sponsored plan
            4: A private plan
    - id: b_income_sources
      title: Income Sources
      items:
      - id: q_inc_qint
        kind: Comment
        title: Although many health expenses are covered by health insurance, there is still a relationship between health and
          income. The next questions deal with your household income.
      - id: q_inc_q1
        kind: Question
        title: Thinking about the total income for all household members, from which of the following sources did your household
          receive any income in the past 12 months? (Mark all that apply)
        input:
          control: Checkbox
          labels:
            1: Wages and salaries
            2: Income from self-employment
            4: Dividends and interest
            8: Employment insurance
            16: Worker's compensation
            32: Benefits from Canada or Quebec Pension Plan
            64: Retirement pensions, superannuation and annuities
            128: Old Age Security and Guaranteed Income Supplement
            256: Child Tax Benefit
            512: Provincial or municipal social assistance or welfare
            1024: Child support
            2048: Alimony
            4096: Other
            8192: None
        codeBlock: |
          # Count bits set to determine if multiple sources
          count = 0
          for i in range(13):
              if q_inc_q1.outcome % (2 * (2 ** i)) >= (2 ** i):
                  count = count + 1
          income_source_count = count
      - id: q_inc_q2
        kind: Question
        title: What was the main source of income?
        precondition:
        - predicate: income_source_count >= 2
        input:
          control: Dropdown
          labels:
            1: Wages and salaries
            2: Income from self-employment
            3: Dividends and interest
            4: Employment insurance
            5: Worker's compensation
            6: Benefits from Canada or Quebec Pension Plan
            7: Retirement pensions, superannuation and annuities
            8: Old Age Security and Guaranteed Income Supplement
            9: Child Tax Benefit
            10: Provincial or municipal social assistance or welfare
            11: Child support
            12: Alimony
            13: Other
    - id: b_household_income
      title: Household Income Amount
      precondition:
      - predicate: q_inc_q1.outcome % 16384 < 8192
      items:
      - id: q_inc_q3
        kind: Question
        title: What is your best estimate of the total income, before taxes and deductions, of all household members from all
          sources in the past 12 months?
        postcondition:
        - predicate: q_inc_q3.outcome <= 150000
          hint: 'Warning: income over $150,000 reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 500000
          left: $
        codeBlock: |
          if q_inc_q3.outcome > 0:
              hh_income_given = 1
      - id: q_inc_q3a
        kind: Question
        title: Can you estimate in which of the following groups your household income falls? Was the total household income
          less than $20,000 or $20,000 or more?
        precondition:
        - predicate: hh_income_given == 0
        input:
          control: Radio
          labels:
            1: Less than $20,000
            2: $20,000 or more
            3: No income
      - id: q_inc_q3b
        kind: Question
        title: Was the total household income from all sources less than $10,000 or $10,000 or more?
        precondition:
        - predicate: hh_income_given == 0
        - predicate: q_inc_q3a.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than $10,000
            2: $10,000 or more
      - id: q_inc_q3c
        kind: Question
        title: Was the total household income from all sources less than $5,000 or $5,000 or more?
        precondition:
        - predicate: hh_income_given == 0
        - predicate: q_inc_q3a.outcome == 1
        - predicate: q_inc_q3b.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than $5,000
            2: $5,000 or more
      - id: q_inc_q3d
        kind: Question
        title: Was the total household income from all sources less than $15,000 or $15,000 or more?
        precondition:
        - predicate: hh_income_given == 0
        - predicate: q_inc_q3a.outcome == 1
        - predicate: q_inc_q3b.outcome == 2
        input:
          control: Radio
          labels:
            1: Less than $15,000
            2: $15,000 or more
      - id: q_inc_q3e
        kind: Question
        title: Was the total household income from all sources less than $40,000 or $40,000 or more?
        precondition:
        - predicate: hh_income_given == 0
        - predicate: q_inc_q3a.outcome == 2
        input:
          control: Radio
          labels:
            1: Less than $40,000
            2: $40,000 or more
      - id: q_inc_q3f
        kind: Question
        title: Was the total household income from all sources less than $30,000 or $30,000 or more?
        precondition:
        - predicate: hh_income_given == 0
        - predicate: q_inc_q3a.outcome == 2
        - predicate: q_inc_q3e.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than $30,000
            2: $30,000 or more
      - id: q_inc_q3g
        kind: Question
        title: 'Was the total household income from all sources:'
        precondition:
        - predicate: hh_income_given == 0
        - predicate: q_inc_q3a.outcome == 2
        - predicate: q_inc_q3e.outcome == 2
        input:
          control: Radio
          labels:
            1: Less than $50,000
            2: $50,000 to less than $60,000
            3: $60,000 to less than $80,000
            4: $80,000 to less than $100,000
            5: $100,000 or more
    - id: b_personal_income
      title: Personal Income
      precondition:
      - predicate: age >= 15
      items:
      - id: q_inc_q4
        kind: Question
        title: What is your best estimate of your total personal income, before taxes and other deductions, from all sources
          in the past 12 months?
        postcondition:
        - predicate: q_inc_q4.outcome <= 150000
          hint: 'Warning: personal income over $150,000 reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 500000
          left: $
      - id: q_inc_q4_dk
        kind: Question
        title: Were you able to provide an exact amount above?
        input:
          control: Switch
          false: No, estimate in brackets
          true: Yes, amount was provided
      - id: q_inc_q4a
        kind: Question
        title: Can you estimate in which of the following groups your personal income falls? Was your total personal income
          less than $20,000 or $20,000 or more?
        precondition:
        - predicate: q_inc_q4_dk.outcome == 0
        input:
          control: Radio
          labels:
            1: Less than $20,000
            2: $20,000 or more
            3: No income
      - id: q_inc_q4b
        kind: Question
        title: Was your total personal income less than $10,000 or $10,000 or more?
        precondition:
        - predicate: q_inc_q4_dk.outcome == 0
        - predicate: q_inc_q4a.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than $10,000
            2: $10,000 or more
      - id: q_inc_q4c
        kind: Question
        title: Was your total personal income less than $5,000 or $5,000 or more?
        precondition:
        - predicate: q_inc_q4_dk.outcome == 0
        - predicate: q_inc_q4a.outcome == 1
        - predicate: q_inc_q4b.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than $5,000
            2: $5,000 or more
      - id: q_inc_q4d
        kind: Question
        title: Was your total personal income less than $15,000 or $15,000 or more?
        precondition:
        - predicate: q_inc_q4_dk.outcome == 0
        - predicate: q_inc_q4a.outcome == 1
        - predicate: q_inc_q4b.outcome == 2
        input:
          control: Radio
          labels:
            1: Less than $15,000
            2: $15,000 or more
      - id: q_inc_q4e
        kind: Question
        title: Was your total personal income less than $40,000 or $40,000 or more?
        precondition:
        - predicate: q_inc_q4_dk.outcome == 0
        - predicate: q_inc_q4a.outcome == 2
        input:
          control: Radio
          labels:
            1: Less than $40,000
            2: $40,000 or more
      - id: q_inc_q4f
        kind: Question
        title: Was your total personal income less than $30,000 or $30,000 or more?
        precondition:
        - predicate: q_inc_q4_dk.outcome == 0
        - predicate: q_inc_q4a.outcome == 2
        - predicate: q_inc_q4e.outcome == 1
        input:
          control: Radio
          labels:
            1: Less than $30,000
            2: $30,000 or more
      - id: q_inc_q4g
        kind: Question
        title: 'Was your total personal income:'
        precondition:
        - predicate: q_inc_q4_dk.outcome == 0
        - predicate: q_inc_q4a.outcome == 2
        - predicate: q_inc_q4e.outcome == 2
        input:
          control: Radio
          labels:
            1: Less than $50,000
            2: $50,000 to less than $60,000
            3: $60,000 to less than $80,000
            4: $80,000 to less than $100,000
            5: $100,000 or more
    - id: b_food_overview
      title: Food Situation Overview
      items:
      - id: q_fsc_r010
        kind: Comment
        title: The following questions are about the food situation for your household in the past 12 months.
      - id: q_fsc_q010
        kind: Question
        title: Which of the following statements best describes the food eaten in your household in the past 12 months?
        input:
          control: Radio
          labels:
            1: Always had enough of the kinds of food you wanted to eat
            2: Had enough to eat, but not always the kinds of food you wanted
            3: Sometimes did not have enough to eat
            4: Often didn't have enough to eat
      - id: q_fsc_r020
        kind: Comment
        title: Now I'm going to read you several statements that may be used to describe the food situation for a household.
          For each statement, please tell me if the statement was often true, sometimes true, or never true for your household
          in the past 12 months.
      - id: q_fsc_q020
        kind: Question
        title: You worried that food would run out before you got money to buy more. Was that often true, sometimes true, or
          never true in the past 12 months?
        input:
          control: Radio
          labels:
            1: Often true
            2: Sometimes true
            3: Never true
      - id: q_fsc_q030
        kind: Question
        title: The food that you bought just didn't last, and there wasn't any money to get more. Was that often true, sometimes
          true, or never true in the past 12 months?
        input:
          control: Radio
          labels:
            1: Often true
            2: Sometimes true
            3: Never true
      - id: q_fsc_q040
        kind: Question
        title: You couldn't afford to eat balanced meals. In the past 12 months was that often true, sometimes true, or never
          true?
        input:
          control: Radio
          labels:
            1: Often true
            2: Sometimes true
            3: Never true
        codeBlock: |
          if q_fsc_q020.outcome in [1, 2] or q_fsc_q030.outcome in [1, 2] or q_fsc_q040.outcome in [1, 2]:
              food_insecurity = 1
    - id: b_child_food
      title: Child Food Situation
      precondition:
      - predicate: has_children == 1
      items:
      - id: q_fsc_r050
        kind: Comment
        title: Now I'm going to read a few statements that may describe the food situation for households with children.
      - id: q_fsc_q050
        kind: Question
        title: You relied on only a few kinds of low-cost food to feed the children because you were running out of money to
          buy food. Was that often true, sometimes true, or never true in the past 12 months?
        input:
          control: Radio
          labels:
            1: Often true
            2: Sometimes true
            3: Never true
      - id: q_fsc_q060
        kind: Question
        title: You couldn't feed the children a balanced meal, because you couldn't afford it. Was that often true, sometimes
          true, or never true in the past 12 months?
        input:
          control: Radio
          labels:
            1: Often true
            2: Sometimes true
            3: Never true
      - id: q_fsc_q070
        kind: Question
        title: The children were not eating enough because you just couldn't afford enough food. Was that often true, sometimes
          true, or never true in the past 12 months?
        precondition:
        - predicate: food_insecurity == 1
        input:
          control: Radio
          labels:
            1: Often true
            2: Sometimes true
            3: Never true
    - id: b_adult_food_detail
      title: Adult Food Insecurity Details
      precondition:
      - predicate: food_insecurity == 1
      items:
      - id: q_fsc_r080
        kind: Comment
        title: The following few questions are about the food situation in the past 12 months for you or any other adults in
          your household.
      - id: q_fsc_q080
        kind: Question
        title: In the past 12 months, did you ever cut the size of your meals or skip meals because there wasn't enough money
          for food?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_fsc_q081
        kind: Question
        title: How often did this happen?
        precondition:
        - predicate: q_fsc_q080.outcome == 1
        input:
          control: Radio
          labels:
            1: Almost every month
            2: Some months but not every month
            3: Only 1 or 2 months
      - id: q_fsc_q090
        kind: Question
        title: In the past 12 months, did you ever eat less than you felt you should because there wasn't enough money to buy
          food?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_fsc_q100
        kind: Question
        title: In the past 12 months, were you ever hungry but didn't eat because you couldn't afford enough food?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_fsc_q110
        kind: Question
        title: In the past 12 months, did you lose weight because you didn't have enough money for food?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_fsc_q120
        kind: Question
        title: In the past 12 months, did you ever not eat for a whole day because there wasn't enough money for food?
        precondition:
        - predicate: q_fsc_q080.outcome == 1 or q_fsc_q090.outcome == 1 or q_fsc_q100.outcome == 1 or q_fsc_q110.outcome ==
            1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_fsc_q121
        kind: Question
        title: How often did this happen?
        precondition:
        - predicate: q_fsc_q080.outcome == 1 or q_fsc_q090.outcome == 1 or q_fsc_q100.outcome == 1 or q_fsc_q110.outcome ==
            1
        - predicate: q_fsc_q120.outcome == 1
        input:
          control: Radio
          labels:
            1: Almost every month
            2: Some months but not every month
            3: Only 1 or 2 months
    - id: b_child_food_detail
      title: Child Food Insecurity Details
      precondition:
      - predicate: has_children == 1
      - predicate: food_insecurity == 1
      items:
      - id: q_fsc_r130
        kind: Comment
        title: Now, a few questions on the food experiences for children in your household.
      - id: q_fsc_q130
        kind: Question
        title: In the past 12 months, did you ever cut the size of any of the children's meals because there wasn't enough money
          for food?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_fsc_q140
        kind: Question
        title: In the past 12 months, did any of the children ever skip meals because there wasn't enough money for food?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_fsc_q141
        kind: Question
        title: How often did this happen?
        precondition:
        - predicate: q_fsc_q140.outcome == 1
        input:
          control: Radio
          labels:
            1: Almost every month
            2: Some months but not every month
            3: Only 1 or 2 months
      - id: q_fsc_q150
        kind: Question
        title: In the past 12 months, were any of the children ever hungry but you just couldn't afford more food?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_fsc_q160
        kind: Question
        title: In the past 12 months, did any of the children ever not eat for a whole day because there wasn't enough money
          for food?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
    - id: b_dwelling
      title: Dwelling Characteristics
      items:
      - id: q_dwl_r01
        kind: Comment
        title: Now a few questions about your dwelling.
      - id: q_dwl_q01
        kind: Question
        title: 'What type of dwelling do you live in? Is it a:'
        input:
          control: Dropdown
          labels:
            1: Single detached
            2: Double (semi-detached)
            3: Row or terrace
            4: Duplex
            5: Low-rise apartment (fewer than 5 stories) or a flat
            6: High-rise apartment (5 stories or more)
            7: Institution
            8: Hotel, rooming/lodging house, camp
            9: Mobile home
            10: Other
      - id: q_dwl_q01s
        kind: Question
        title: 'INTERVIEWER: Specify the dwelling type.'
        precondition:
        - predicate: q_dwl_q01.outcome == 10
        input:
          control: Textarea
          placeholder: Specify dwelling type...
          maxLength: 200
      - id: q_dwl_q02
        kind: Question
        title: How many bedrooms are there in this dwelling?
        postcondition:
        - predicate: q_dwl_q02.outcome <= 10
          hint: 'Warning: more than 10 bedrooms reported. Please confirm.'
        input:
          control: Editbox
          min: 0
          max: 20
          right: bedrooms
      - id: q_dwl_q03
        kind: Question
        title: Is this dwelling owned by a member of this household?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'

    # ===================================================================
    # SECTION: administration
    # ===================================================================
    - id: b_weight_measurement
      title: Weight Measurement
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_mhw_n1a
        kind: Question
        title: 'INTERVIEWER: Are there any reasons that make it impossible to measure the respondent''s weight?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
        codeBlock: |
          if q_mhw_n1a.outcome == 0:
              weight_measured = 1
      - id: q_mhw_n1b
        kind: Question
        title: 'INTERVIEWER: Select reasons why it is impossible to measure the respondent''s weight.'
        precondition:
        - predicate: q_mhw_n1a.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Unable to stand unassisted
            2: In a wheelchair
            4: Bedridden
            8: Interview setting
            16: Safety concerns
            32: Has already refused to be measured
            64: Other - Specify
        codeBlock: |
          if q_mhw_n1b.outcome % 8 >= 1:
              height_impossible = 1
      - id: q_mhw_s1b
        kind: Question
        title: 'INTERVIEWER: Specify the reason.'
        precondition:
        - predicate: q_mhw_n1a.outcome == 1
        - predicate: q_mhw_n1b.outcome % 128 >= 64
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_mhw_r2
        kind: Comment
        title: A person's size is important in understanding health. Because of this, I would like to measure your height and
          weight. The measurements taken will not require any touching.
        precondition:
        - predicate: q_mhw_n1a.outcome == 0
      - id: q_mhw_q2a
        kind: Question
        title: Do I have your permission to measure your weight?
        precondition:
        - predicate: q_mhw_n1a.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
        codeBlock: |
          if q_mhw_q2a.outcome == 1:
              weight_permission = 1
      - id: q_mhw_n2a
        kind: Question
        title: 'INTERVIEWER: Record weight to the nearest 0.01 kg.'
        precondition:
        - predicate: q_mhw_n1a.outcome == 0
        - predicate: q_mhw_q2a.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 261
          right: kg
      - id: q_mhw_n3a
        kind: Question
        title: 'INTERVIEWER: Were there any articles of clothing or physical characteristics which affected the accuracy of
          this measurement?'
        precondition:
        - predicate: q_mhw_n1a.outcome == 0
        - predicate: q_mhw_q2a.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mhw_n3b
        kind: Question
        title: 'INTERVIEWER: Select reasons affecting accuracy.'
        precondition:
        - predicate: q_mhw_n1a.outcome == 0
        - predicate: q_mhw_q2a.outcome == 1
        - predicate: q_mhw_n3a.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Shoes or boots
            2: Heavy sweater or jacket
            4: Jewellery
            8: Other - Specify
      - id: q_mhw_s3b
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_mhw_n1a.outcome == 0
        - predicate: q_mhw_q2a.outcome == 1
        - predicate: q_mhw_n3a.outcome == 1
        - predicate: q_mhw_n3b.outcome % 16 >= 8
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
    - id: b_height_measurement
      title: Height Measurement
      precondition:
      - predicate: is_proxy == 0
      items:
      - id: q_mhw_n5a
        kind: Question
        title: 'INTERVIEWER: Are there any reasons that make it impossible to measure the respondent''s height?'
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mhw_n5b
        kind: Question
        title: 'INTERVIEWER: Select reasons why it is impossible to measure the respondent''s height.'
        precondition:
        - predicate: q_mhw_n5a.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Too tall
            2: Interview setting
            4: Safety concerns
            8: Has already refused to be measured
            16: Other - Specify
      - id: q_mhw_s5b
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_mhw_n5a.outcome == 1
        - predicate: q_mhw_n5b.outcome % 32 >= 16
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
      - id: q_mhw_r6
        kind: Comment
        title: A person's size is important in understanding health. Because of this, I would like to measure your height. The
          measurement will not require any touching.
        precondition:
        - predicate: q_mhw_n5a.outcome == 0
        - predicate: q_mhw_n1a.outcome == 1
      - id: q_mhw_q6a
        kind: Question
        title: Do I have your permission to measure your height?
        precondition:
        - predicate: q_mhw_n5a.outcome == 0
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mhw_n6b
        kind: Question
        title: 'INTERVIEWER: Enter height to nearest 0.5 cm.'
        precondition:
        - predicate: q_mhw_n5a.outcome == 0
        - predicate: q_mhw_q6a.outcome == 1
        input:
          control: Editbox
          min: 90
          max: 250
          right: cm
      - id: q_mhw_n7a
        kind: Question
        title: 'INTERVIEWER: Were there any articles of clothing or physical characteristics which affected the accuracy of
          this measurement?'
        precondition:
        - predicate: q_mhw_n5a.outcome == 0
        - predicate: q_mhw_q6a.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_mhw_n7b
        kind: Question
        title: 'INTERVIEWER: Select reasons affecting accuracy.'
        precondition:
        - predicate: q_mhw_n5a.outcome == 0
        - predicate: q_mhw_q6a.outcome == 1
        - predicate: q_mhw_n7a.outcome == 1
        input:
          control: Checkbox
          labels:
            1: Shoes or boots
            2: Hairstyle
            4: Hat
            8: Other - Specify
      - id: q_mhw_s7b
        kind: Question
        title: 'INTERVIEWER: Specify.'
        precondition:
        - predicate: q_mhw_n5a.outcome == 0
        - predicate: q_mhw_q6a.outcome == 1
        - predicate: q_mhw_n7a.outcome == 1
        - predicate: q_mhw_n7b.outcome % 16 >= 8
        input:
          control: Textarea
          placeholder: Specify reason...
          maxLength: 200
    - id: b_data_linkage
      title: Data Linkage Consent
      items:
      - id: q_adm_q01a
        kind: Comment
        title: Statistics Canada and your provincial or territorial ministry of health would like your permission to link information
          collected during this interview to your health records. This linked information could help improve our understanding
          of health issues.
      - id: q_adm_q01b
        kind: Question
        title: This linked information will be kept confidential and used only for statistical purposes. Do we have your permission?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_adm_q03a
        kind: Question
        title: Do you have a provincial or territorial health number?
        precondition:
        - predicate: q_adm_q01b.outcome == 1
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
      - id: q_adm_q03b
        kind: Question
        title: For which province or territory is your health number?
        precondition:
        - predicate: q_adm_q01b.outcome == 1
        - predicate: q_adm_q03a.outcome == 1
        input:
          control: Dropdown
          labels:
            1: Newfoundland and Labrador
            2: Prince Edward Island
            3: Nova Scotia
            4: New Brunswick
            5: Quebec
            6: Ontario
            7: Manitoba
            8: Saskatchewan
            9: Alberta
            10: British Columbia
            11: Yukon
            12: Northwest Territories
            13: Nunavut
      - id: q_adm_hn
        kind: Question
        title: What is your health number?
        precondition:
        - predicate: q_adm_q01b.outcome == 1
        - predicate: q_adm_q03a.outcome == 1
        input:
          control: Textarea
          placeholder: Enter health number...
          maxLength: 12
    - id: b_data_sharing
      title: Data Sharing Consent
      items:
      - id: q_adm_q04a
        kind: Comment
        title: Statistics Canada would like your permission to share the information collected in this survey with provincial
          and territorial ministries of health and the Public Health Agency of Canada. This information will allow them to better
          understand issues affecting the health of Canadians.
      - id: q_adm_q04b
        kind: Question
        title: All information will be kept confidential and used only for statistical purposes. Do you agree to share the information
          provided?
        input:
          control: Switch
          false: 'No'
          true: 'Yes'
