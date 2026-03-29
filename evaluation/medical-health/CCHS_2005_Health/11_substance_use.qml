qmlVersion: '1.0'
questionnaire:
  title: 11 Substance Use
  codeInit: |
    # Extern variables from prior sections
    age: range(12, 120)
    is_proxy: {0, 1}
    # Counter: how many "ever used" questions answered No (value 3)
    # Used to check if respondent has never tried ANY drug
    never_tried_count = 0
    # Counter: how many frequency questions reported >= weekly use (values 3,4,5)
    frequent_use_count = 0
    # Counter: how many of CPG_Q01B-Q01M answered Never/infrequent (7,8)
    # Used by CPG_C01N to check if all 12 activities are Never/rare
    never_gamble_count = 0
    # CPG problem gambling score (CPG_C17)
    # Recode Q03-Q10 and Q13: 1→0, 2→1, 3→2, 4→3; sum recoded values
    cpg_score = 0
  blocks:
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
