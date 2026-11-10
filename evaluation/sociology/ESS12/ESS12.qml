qmlVersion: '2.7'
questionnaire:
  title: European Social Survey Round 12 Source Questionnaire 2025-2026
  blocks:
  - id: b_s1_preamble
    title: Sample design input
    items:
    - id: ADDRESS_BASED_SAMPLE
      kind: Question
      title: 'External input: whether the country uses an address-based sample (gates S1-S4); set by the national sample design'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s1_birthday
    title: SECTION S
    items:
    - id: S1
      kind: Question
      title: 'Are you the person aged 15 or over in your household who has the NEXT birthday? (ASK S1-S4 IF USING ADDRESS-BASED SAMPLE; SC WEB AND PAPER ONLY) SC PAPER INSTRUCTIONS: IF ''NO'': Please ask the person aged 15 or over who has the next birthday to complete the survey. When they start, they should change the answer above to ''Yes''.'
      precondition:
      - predicate: ADDRESS_BASED_SAMPLE.outcome == 1
        hint: Asked only when question ADDRESS_BASED_SAMPLE is "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: S4
      kind: Question
      title: Are you the person aged 15 or over in your household who has the NEXT birthday? (SC WEB ONLY. IF S1=2) The survey is to be completed by the person aged 15 or over in your household who has the next birthday.
      precondition:
      - predicate: S1.outcome == 2
        hint: Asked only when question S1 is "No".
      - predicate: not (S1.outcome == 1)
        hint: Asked only when question S1 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s1_age_permission
    title: Age and parental permission
    items:
    - id: S5
      kind: Question
      title: Are you…? (ASK ALL SC WEB AND PAPER)
      input:
        control: Radio
        labels:
          1: Aged [18] or over
          2: Aged under [18]
    - id: S6
      kind: Question
      title: 'IF AGED UNDER [18]: You are required to obtain permission from a parent/guardian in order to complete this survey. Please complete below.'
      precondition:
      - predicate: S5.outcome == 2
        hint: Asked only when question S5 is "Aged under [18]".
      - predicate: not (S5.outcome == 1)
        hint: Asked only when question S5 is not "Aged [18] or over".
      input:
        control: Radio
        labels:
          1: I confirm I have permission from a parent/guardian to complete this survey
  - id: b_s2_local_area
    title: Local area
    items:
    - id: A1
      kind: Question
      title: 'CARD 1 Overall, how satisfied or dissatisfied are you with your local area as a place to live? (ASK ALL) Footnotes: ''local area'': respondent''s local area or neighbourhood; NEW ITEM.'
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Fairly satisfied
          3: Neither satisfied nor dissatisfied
          4: Fairly dissatisfied
          5: Very dissatisfied
          7: (Refusal)
          8: (Don't Know)
    - id: A2
      kind: Question
      title: 'CARD 2 Over the past two years, has the local area where you live got better, worse, or not changed much? Footnotes: ''local area'': respondent''s local area or neighbourhood; NEW ITEM; the round brackets around ''has not got better or worse'' do not denote unprompted response options in face-to-face and are displayed in all modes.'
      input:
        control: Radio
        labels:
          1: Got better
          2: Got worse
          3: Not changed much (has not got better or worse)
          4: I have not lived here long enough to say
          7: (Refusal)
          8: (Don't Know)
    - id: A3
      kind: Question
      title: 'CARD 3 How much do you feel you belong to your local area? Please answer using this scale, where 0 means not at all and 6 means a great deal. (SC PAPER: Please tick any circle from 0 to 6, where 0 means not at all and 6 means a great deal.) 0 = Not at all, 6 = A great deal. Footnotes: ''local area'': respondent''s local area or neighbourhood; ''Belong'': feeling connected to or a part of; NEW ITEM.'
      input:
        control: Radio
        labels:
          0: 0 Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 A great deal
          7: (Refusal)
          8: (Don't know)
    - id: A4
      kind: Question
      title: 'CARD 4 How often do you chat to your neighbours, more than to just say hello? Footnotes: ''say hello'': can be translated as "greet"; NEW ITEM.'
      input:
        control: Radio
        labels:
          1: 01 — On most days
          2: 02 — Once or twice a week
          3: 03 — Once or twice a month
          4: 04 — Less than once a month
          5: 05 — Never
          6: 06 — I don't have any neighbours
          77: (Refusal)
          88: (Don't Know)
  - id: b_s2_climate_opinion
    title: Climate change
    items:
    - id: A5
      kind: Question
      title: 'Now some questions on different topics. CARD 5 Do you think that climate change is caused by natural processes, human activity, or both? Footnote: the round brackets in the ''All modes'' column on code 55 ''(I don''t think climate change is happening)'' denote an unprompted response option in face-to-face.'
      input:
        control: Dropdown
        labels:
          1: 01 — Entirely by natural processes
          2: 02 — Mainly by natural processes
          3: 03 — About equally by natural processes and human activity
          4: 04 — Mainly by human activity
          5: 05 — Entirely by human activity
          55: (I don't think climate change is happening)
          77: (Refusal)
          88: (Don't know)
  - id: b_s2_climate_believers
    title: Climate change responsibility and worry
    precondition:
    - predicate: A5.outcome != 55
      hint: Asked only when question A5 is not "(I don't think climate change is happening)".
    - predicate: not (A5.outcome == 55)
      hint: Asked only when question A5 is not "(I don't think climate change is happening)".
    items:
    - id: A6
      kind: Question
      title: CARD 6 To what extent do you feel a personal responsibility to try to reduce climate change? 0 = Not at all, 10 = A great deal
      input:
        control: Dropdown
        labels:
          0: 00 Not at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 A great deal
          77: (Refusal)
          88: (Don't know)
    - id: A7
      kind: Question
      title: CARD 7 How worried are you about climate change?
      input:
        control: Radio
        labels:
          1: Not at all worried
          2: Not very worried
          3: Somewhat worried
          4: Very worried
          5: Extremely worried
          7: (Refusal)
          8: (Don't know)
  - id: b_s2_news_media
    title: News media use
    items:
    - id: A8
      kind: Question
      title: 'ASK ALL. On a typical day, about how much time do you spend in hours and minutes watching, reading or listening to news about politics and current affairs? INSTRUCTIONS for all modes: Please give your answer in hours (0-24) and minutes (0-59). If you spend no time, please enter 0 hours and 0 minutes. For answers less than 10, only enter one digit (e.g. type 5 instead of 05). (F2F: IF RESPONDENT SPENDS NO TIME, ENTER 0 HOURS 0 MINUTES.) HOURS field. Footnote: ''about politics and current affairs'': about issues to do with governance and public policy, and with the people connected with these affairs.'
      input:
        control: Editbox
        min: 0
        max: 24
        right: hours
      postcondition:
      - predicate: A8.outcome <= 24 or A8.outcome in [7777, 8888]
        hint: We are asking about a typical day, so the maximum number of hours is 24. Please correct the hours entered at A8.
    - id: A8_min
      kind: Question
      title: 'A8 MINUTES field (same question as A8; id A8_min used to distinguish the minutes box from the hours box): Please give your answer in hours (0-24) and minutes (0-59). If you spend no time, please enter 0 hours and 0 minutes.'
      input:
        control: Editbox
        min: 0
        max: 59
        right: minutes
      postcondition:
      - predicate: A8_min.outcome <= 59
        hint: If you spend more than 60 minutes a day, please split this into hours and minutes at A8. For example, if you spend 90 minutes, enter 1 in the hour box and 30 in the minutes box.
      - predicate: not (A8.outcome == 24 and A8_min.outcome > 0)
        hint: We are asking about a typical day, so the total time at A8 (hours and minutes) must be less than or equal to one day (24 hours).
  - id: b_s3_internet
    title: Internet use
    items:
    - id: A9
      kind: Question
      title: CARD 8 People can use the internet on different devices such as computers, tablets and smartphones. How often do you use the internet on these or any other devices, whether for work or personal use?
      input:
        control: Radio
        labels:
          1: Never
          2: Only occasionally
          3: A few times a week
          4: Most days
          5: Every day
          7: (Refusal)
          8: (Don’t know)
  - id: b_s3_internet_time
    title: Internet use time
    precondition:
    - predicate: A9.outcome in [4, 5]
      hint: Asked only when question A9 is one of "Most days", "Every day".
    - predicate: not (A9.outcome in [1, 2, 3, 7, 8])
      hint: Asked only when question A9 is none of "Never", "Only occasionally", "A few times a week", "(Refusal)", "(Don’t know)".
    items:
    - id: A10
      kind: Question
      title: 'ASK IF MOST DAYS OR EVERY DAY AT A9 (IF A9 = 4, 5) On a typical day, about how much time in hours and minutes do you spend using the internet on a computer, tablet, smartphone or other device, whether for work or personal use? INSTRUCTIONS for all modes: Please give your answer in hours (0-24) and minutes (0-59). (Hours box; F2F: Refusal 7777, Don’t know 8888)'
      input:
        control: Editbox
        min: 0
        max: 8888
      postcondition:
      - predicate: A10.outcome in [7777, 8888] or A10.outcome <= 24
        hint: We are asking about a typical day, so the maximum number of hours is 24.
      - predicate: A10.outcome in [7777, 8888] or A10.outcome >= 0
        hint: Please enter a positive number.
    - id: A10_minutes
      kind: Question
      title: 'A10 Minutes box: Please give your answer in hours (0-24) and minutes (0-59). (Minutes part of the A10 answer; source_id derived because A10 has an Hours and a Minutes box)'
      input:
        control: Editbox
        min: 0
        max: 59
      postcondition:
      - predicate: A10_minutes.outcome <= 60
        hint: If you spend more than 60 minutes a day, please split this into hours and minutes. For example, if you spend 90 minutes, you would enter 1 in the hour box and 30 in the minutes box.
      - predicate: A10.outcome in [7777, 8888] or A10.outcome < 24 or A10_minutes.outcome == 0
        hint: We are asking about a typical day, so please enter a total amount of time that is less than or equal to one day.
      - predicate: A10_minutes.outcome >= 0
        hint: Please enter a positive number.
  - id: b_s3_social_trust
    title: Social trust
    items:
    - id: A11
      kind: Question
      title: 'CARD 9 Generally speaking, would you say that most people can be trusted, or that you can’t be too careful in dealing with people? F2F INTERVIEWER: Please tell me on a score of 0 to 10, where 0 means you can’t be too careful and 10 means that most people can be trusted.'
      input:
        control: Dropdown
        labels:
          0: 00 You can’t be too careful
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Most people can be trusted
          77: (Refusal)
          88: (Don’t know)
    - id: A12
      kind: Question
      title: CARD 10 Do you think that most people would try to take advantage of you if they got the chance, or would they try to be fair?
      input:
        control: Dropdown
        labels:
          0: 00 Most people would try to take advantage of me
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Most people would try to be fair
          77: (Refusal)
          88: (Don’t know)
    - id: A13
      kind: Question
      title: CARD 11 Would you say that most of the time people try to be helpful or that they are mostly looking out for themselves?
      input:
        control: Dropdown
        labels:
          0: 00 People mostly look out for themselves
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 People mostly try to be helpful
          77: (Refusal)
          88: (Don’t know)
  - id: b_s3_political_efficacy
    title: Political interest and efficacy
    items:
    - id: A14
      kind: Question
      title: 'How interested would you say you are in politics? Note to F2F INTERVIEWER: READ OUT…'
      input:
        control: Radio
        labels:
          1: Very interested
          2: Quite interested
          3: Hardly interested
          4: Not at all interested
          7: (Refusal)
          8: (Don’t know)
    - id: A15
      kind: Question
      title: CARD 12 How much would you say the political system in [country] allows people like you to have a say in what the government does?
      input:
        control: Radio
        labels:
          1: Not at all
          2: Very little
          3: Some
          4: A lot
          5: A great deal
          7: (Refusal)
          8: (Don’t know)
    - id: A16
      kind: Question
      title: CARD 13 How able do you think you are to take an active role in a group involved with political issues?
      input:
        control: Radio
        labels:
          1: Not at all able
          2: A little able
          3: Quite able
          4: Very able
          5: Completely able
          7: (Refusal)
          8: (Don’t know)
    - id: A17
      kind: Question
      title: CARD 14 How much would you say the political system in [country] allows people like you to have an influence on politics?
      input:
        control: Radio
        labels:
          1: Not at all
          2: Very little
          3: Some
          4: A lot
          5: A great deal
          7: (Refusal)
          8: (Don’t know)
    - id: A18
      kind: Question
      title: CARD 15 How confident are you in your own ability to participate in politics?
      input:
        control: Radio
        labels:
          1: Not at all confident
          2: A little confident
          3: Quite confident
          4: Very confident
          5: Completely confident
          7: (Refusal)
          8: (Don’t know)
  - id: b_s3_institutional_trust
    title: Trust in institutions
    items:
    - id: A19
      kind: Question
      title: CARD 16 How much do you personally trust [country]’s parliament?
      input:
        control: Dropdown
        labels:
          0: 00 No trust at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Complete trust
          77: (Refusal)
          88: (Don’t know)
    - id: A20
      kind: Question
      title: STILL CARD 16 How much do you personally trust the legal system?
      input:
        control: Dropdown
        labels:
          0: 00 No trust at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Complete trust
          77: (Refusal)
          88: (Don’t know)
    - id: A21
      kind: Question
      title: STILL CARD 16 How much do you personally trust the police?
      input:
        control: Dropdown
        labels:
          0: 00 No trust at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Complete trust
          77: (Refusal)
          88: (Don’t know)
    - id: A22
      kind: Question
      title: STILL CARD 16 How much do you personally trust politicians?
      input:
        control: Dropdown
        labels:
          0: 00 No trust at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Complete trust
          77: (Refusal)
          88: (Don’t know)
    - id: A23
      kind: Question
      title: STILL CARD 16 How much do you personally trust political parties?
      input:
        control: Dropdown
        labels:
          0: 00 No trust at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Complete trust
          77: (Refusal)
          88: (Don’t know)
    - id: A24
      kind: Question
      title: STILL CARD 16 How much do you personally trust the European Parliament?
      input:
        control: Dropdown
        labels:
          0: 00 No trust at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Complete trust
          77: (Refusal)
          88: (Don’t know)
    - id: A25
      kind: Question
      title: STILL CARD 16 How much do you personally trust the United Nations?
      input:
        control: Dropdown
        labels:
          0: 00 No trust at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Complete trust
          77: (Refusal)
          88: (Don’t know)
  - id: b_s3_voting
    title: Voting
    items:
    - id: A26
      kind: Question
      title: ASK ALL Some people don’t vote nowadays for one reason or another. Did you vote in the last [country nationality] national election in [month/year]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not eligible to vote
          7: (Refusal)
          8: (Don’t know)
    - id: A27
      kind: Question
      title: 'ASK IF YES AT A26 (A26 = 1) Which party did you vote for in the last [country nationality] national election in [month/year]? PROGRAMMING NOTE: a maximum of 20 response options not including the ‘Other’ category will be allowed.'
      precondition:
      - predicate: A26.outcome == 1
        hint: Asked only when question A26 is "Yes".
      - predicate: not (A26.outcome in [2, 3, 7, 8])
        hint: Asked only when question A26 is none of "No", "Not eligible to vote", "(Refusal)", "(Don’t know)".
      input:
        control: Dropdown
        labels:
          1: Option 1
          2: Option 2
          3: Option 3
          4: Option 4
          5: Option 5
          6: Option 6
          7: Option 7
          8: Option 8
          9: Option 9
          10: Option 10
          11: Option 11
          12: Option 12
          13: Option 13
          14: Option 14
          15: Option 15
          16: Option 16
          17: Option 17
          18: Option 18
          19: Option 19
          20: Option 20
          21: 'Other: please write in'
          77: (Refusal)
          88: (Don’t know)
  - id: b_s3_participation
    title: Political participation
    items:
    - id: A28
      kind: Question
      title: There are different ways of trying to improve things in [country] or help prevent things from going wrong. During the last 12 months, have you contacted a politician, government or local government official?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A29
      kind: Question
      title: During the last 12 months, have you donated to or participated in a political party or pressure group?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A30
      kind: Question
      title: During the last 12 months, have you worn or displayed a campaign badge/sticker?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A31
      kind: Question
      title: During the last 12 months, have you signed a petition?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A32
      kind: Question
      title: During the last 12 months, have you taken part in a public demonstration?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A33
      kind: Question
      title: During the last 12 months, have you boycotted certain products?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A34
      kind: Question
      title: During the last 12 months, have you posted or shared anything about politics online, for example on blogs, via email or on social media such as Facebook, Instagram, TikTok, or X (formerly known as Twitter)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A35
      kind: Question
      title: During the last 12 months, have you volunteered for a not-for-profit or charitable organisation?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
  - id: b_s3_party_closeness
    title: Party closeness and left-right placement
    items:
    - id: A36
      kind: Question
      title: Is there a particular political party you feel closer to than all the other parties?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A37
      kind: Question
      title: 'ASK IF YES AT A36 (A36 = 1) Which political party do you feel closest to? PROGRAMMING NOTE: A maximum of 20 response options not including the ‘Other’ category will be allowed.'
      precondition:
      - predicate: A36.outcome == 1
        hint: Asked only when question A36 is "Yes".
      - predicate: not (A36.outcome in [2, 7, 8])
        hint: Asked only when question A36 is none of "No", "(Refusal)", "(Don’t know)".
      input:
        control: Dropdown
        labels:
          1: Option 1
          2: Option 2
          3: Option 3
          4: Option 4
          5: Option 5
          6: Option 6
          7: Option 7
          8: Option 8
          9: Option 9
          10: Option 10
          11: Option 11
          12: Option 12
          13: Option 13
          14: Option 14
          15: Option 15
          16: Option 16
          17: Option 17
          18: Option 18
          19: Option 19
          20: Option 20
          21: 'Other: please write in'
          77: (Refusal)
          88: (Don’t know)
    - id: A38
      kind: Question
      title: 'ASK IF PARTY GIVEN AT A37 How close do you feel to this party? Note to F2F INTERVIEWER: READ OUT…'
      precondition:
      - predicate: A37.outcome is not None and (A37.outcome >= 1 and A37.outcome <= 21)
        hint: Asked only when a party was given at A37.
      - predicate: not (A36.outcome in [2, 7, 8])
        hint: Asked only when question A36 is none of "No", "(Refusal)", "(Don’t know)".
      input:
        control: Radio
        labels:
          1: Very close
          2: Quite close
          3: Not close
          4: Not at all close
          7: (Refusal)
          8: (Don’t know)
    - id: A39
      kind: Question
      title: CARD 17 In politics people sometimes talk of “left” and “right”. Where would you place yourself on this scale, where 0 means the left and 10 means the right?
      input:
        control: Dropdown
        labels:
          0: 00 Left
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Right
          77: (Refusal)
          88: (Don’t know)
  - id: b_s3_satisfaction
    title: Satisfaction and state of services
    items:
    - id: A40
      kind: Question
      title: 'CARD 18 All things considered, how satisfied are you with your life as a whole nowadays? F2F INTERVIEWER INSTRUCTIONS: Please answer using this card, where 0 means extremely dissatisfied and 10 means extremely satisfied.'
      input:
        control: Dropdown
        labels:
          0: 00 Extremely dissatisfied
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Extremely satisfied
          77: (Refusal)
          88: (Don’t know)
    - id: A41
      kind: Question
      title: STILL CARD 18 On the whole, how satisfied are you with the present state of the economy in [country]?
      input:
        control: Dropdown
        labels:
          0: 00 Extremely dissatisfied
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Extremely satisfied
          77: (Refusal)
          88: (Don’t know)
    - id: A42
      kind: Question
      title: STILL CARD 18 Now thinking about the [country nationality] government, how satisfied are you with the way it is doing its job?
      input:
        control: Dropdown
        labels:
          0: 00 Extremely dissatisfied
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Extremely satisfied
          77: (Refusal)
          88: (Don’t know)
    - id: A43
      kind: Question
      title: STILL CARD 18 And on the whole, how satisfied are you with the way democracy works in [country]?
      input:
        control: Dropdown
        labels:
          0: 00 Extremely dissatisfied
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Extremely satisfied
          77: (Refusal)
          88: (Don’t know)
    - id: A44
      kind: Question
      title: CARD 19 What do you think overall about the state of education in [country] nowadays?
      input:
        control: Dropdown
        labels:
          0: 00 Extremely bad
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Extremely good
          77: (Refusal)
          88: (Don’t know)
    - id: A45
      kind: Question
      title: STILL CARD 19 What do you think overall about the state of health services in [country] nowadays?
      input:
        control: Dropdown
        labels:
          0: 00 Extremely bad
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Extremely good
          77: (Refusal)
          88: (Don’t know)
  - id: b_s3_attitudes
    title: Social and political attitudes
    items:
    - id: A46
      kind: Question
      title: To what extent do you agree or disagree with each of the following statements? CARD 20 The government should take measures to reduce differences in income levels.
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
    - id: A47
      kind: Question
      title: STILL CARD 20 Gay men and lesbians should be free to live their own life as they wish.
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
    - id: A48
      kind: Question
      title: STILL CARD 20 If a close family member was a gay man or a lesbian, I would feel ashamed.
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
    - id: A49
      kind: Question
      title: STILL CARD 20 Gay male and lesbian couples should have the same rights to adopt children as straight couples.
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
    - id: A50
      kind: Question
      title: CARD 21 Now thinking about the European Union, some say European unification should go further. Others say it has already gone too far. Which number on this scale best describes your position?
      input:
        control: Dropdown
        labels:
          0: 00 Unification has already gone too far
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Unification should go further
          77: (Refusal)
          88: (Don’t know)
    - id: A51
      kind: Question
      title: To what extent do you agree or disagree with each of the following statements? CARD 22 Obedience and respect for authority are the most important values children should learn.
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
    - id: A52
      kind: Question
      title: STILL CARD 22 What [country] needs most is loyalty towards its leaders.
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
  - id: b_s3_immigration
    title: Immigration attitudes
    items:
    - id: A53
      kind: Question
      title: Now some questions about people from other countries coming to live in [country]. CARD 23 To what extent do you think [country] should allow people of the same race or ethnic group as most [country nationality] people to come and live here?
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: (Refusal)
          8: (Don’t know)
    - id: A54
      kind: Question
      title: STILL CARD 23 To what extent do you think [country] should allow people of a different race or ethnic group from most [country nationality] people to come and live here?
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: (Refusal)
          8: (Don’t know)
    - id: A55
      kind: Question
      title: STILL CARD 23 To what extent do you think [country] should allow people from poorer countries outside Europe to come and live here?
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: (Refusal)
          8: (Don’t know)
    - id: A56
      kind: Question
      title: STILL CARD 23 To what extent do you think [country] should allow people who are forced to leave their country because of armed conflict or persecution to come and live here?
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: (Refusal)
          8: (Don’t know)
    - id: A57
      kind: Question
      title: CARD 24 Would you say it is generally bad or good for [country]’s economy that people come to live here from other countries?
      input:
        control: Dropdown
        labels:
          0: 00 Bad for the economy
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Good for the economy
          77: (Refusal)
          88: (Don’t know)
    - id: A58
      kind: Question
      title: CARD 25 Would you say that [country]’s cultural life is generally undermined or enriched by people coming to live here from other countries?
      input:
        control: Dropdown
        labels:
          0: 00 Cultural life undermined
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Cultural life enriched
          77: (Refusal)
          88: (Don’t know)
    - id: A59
      kind: Question
      title: CARD 26 Is [country] made a worse or a better place to live by people coming to live here from other countries?
      input:
        control: Dropdown
        labels:
          0: 00 Worse place to live
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Better place to live
          77: (Refusal)
          88: (Don’t know)
  - id: b_s3_wellbeing_social
    title: Wellbeing and social life
    items:
    - id: A60
      kind: Question
      title: Now a few questions about you and your life. CARD 27 Taking all things together, how happy would you say you are?
      input:
        control: Dropdown
        labels:
          0: 00 Extremely unhappy
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Extremely happy
          77: (Refusal)
          88: (Don’t know)
    - id: A61
      kind: Question
      title: CARD 28 How often do you meet socially with friends, relatives or work colleagues?
      input:
        control: Dropdown
        labels:
          1: 01 Never
          2: 02 Less than once a month
          3: 03 Once a month
          4: 04 Several times a month
          5: 05 Once a week
          6: 06 Several times a week
          7: 07 Every day
          77: (Refusal)
          88: (Don’t know)
    - id: A62
      kind: Question
      title: CARD 29 How many people, if any, are there with whom you can discuss intimate and personal matters?
      input:
        control: Dropdown
        labels:
          0: 00 None
          1: 01 1
          2: 02 2
          3: 03 3
          4: 04 4-6
          5: 05 7-9
          6: 06 10 or more
          77: (Refusal)
          88: (Don’t know)
    - id: A63
      kind: Question
      title: CARD 30 Compared to other people of your age, how often would you say you take part in social activities?
      input:
        control: Radio
        labels:
          1: Much less than most
          2: Less than most
          3: About the same
          4: More than most
          5: Much more than most
          7: (Refusal)
          8: (Don’t know)
  - id: b_s3_safety_health
    title: Safety and health
    items:
    - id: A64
      kind: Question
      title: Have you or a member of your household been the victim of a burglary or assault in the last 5 years?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don’t know)
    - id: A65
      kind: Question
      title: 'How safe do you – or would you – feel walking alone in the area you live after dark? Note to F2F INTERVIEWER: READ OUT…'
      input:
        control: Radio
        labels:
          1: Very safe
          2: Safe
          3: Unsafe
          4: Very unsafe
          7: (Refusal)
          8: (Don’t know)
    - id: A66
      kind: Question
      title: 'How is your health in general? Note to F2F INTERVIEWER: READ OUT…'
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Fair
          4: Bad
          5: Very bad
          7: (Refusal)
          8: (Don’t know)
    - id: A67
      kind: Question
      title: 'Are you hampered in your daily activities in any way by any longstanding illness, or disability, infirmity or mental health problem? Note to F2F INTERVIEWER: IF YES, is that a lot or to some extent?'
      input:
        control: Radio
        labels:
          1: Yes, a lot
          2: Yes, to some extent
  - id: b_s4_attachment
    title: Attachment
    items:
    - id: A68
      kind: Question
      title: CARD 31 How emotionally attached72 do you feel to [country]? Please choose a number from 0 to 10, where 0 means not at all emotionally attached and 10 means very emotionally attached.
      input:
        control: Dropdown
        labels:
          0: 00 Not at all emotionally attached
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Very emotionally attached
          77: (Refusal)
          88: (Don't know)
    - id: A69
      kind: Question
      title: STILL CARD 31 And how emotionally attached72 do you feel to Europe?71
      input:
        control: Dropdown
        labels:
          0: 00 Not at all emotionally attached
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Very emotionally attached
          77: (Refusal)
          88: (Don't know)
  - id: b_s4_religion
    title: Religion
    items:
    - id: A70
      kind: Question
      title: Do you consider yourself as belonging to73 any particular religion or denomination?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: A71
      kind: Question
      title: OPTIONAL CARD Which religion or denomination do you belong to? ASK IF YES AT A70 (IF A70 = 1)
      precondition:
      - predicate: A70.outcome == 1
        hint: Asked only when question A70 is "Yes".
      - predicate: not (A70.outcome in [2, 7, 8])
        hint: Asked only when question A70 is none of "No", "(Refusal)", "(Don't know)".
      input:
        control: Dropdown
        labels:
          1: 01 Option 1
          2: 02 Option 2
          3: 03 Option 3
          4: 04 Option 4
          5: 05 Option 5
          6: 06 Option 6
          7: 07 Option 7
          8: 08 Option 8
          9: 09 Option 9
          10: 10 Option 10
          11: 11 Option 11
          12: 12 Option 12
          13: 13 Option 13
          14: 14 Option 14
          15: 15 Option 15
          16: '16 Other: please write in'
          77: (Refusal)
          88: (Don't know)
    - id: A72
      kind: Question
      title: 'Have you ever considered yourself as belonging to any particular religion or denomination? (SC WEB AND PAPER: You just indicated that you do not currently consider yourself belonging to any religion or denomination.)'
      precondition:
      - predicate: A70.outcome in [2, 7, 8, 9]
        hint: Asked only when question A70 is one of "No", "(Refusal)", "(Don't know)", 9.
      - predicate: A71.outcome is None or not (A71.outcome > 0)
        hint: Asked only when no current religion was given at A71.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: A73
      kind: Question
      title: OPTIONAL CARD Which religion or denomination did you belong to in the past?
      precondition:
      - predicate: A72.outcome == 1
        hint: Asked only when question A72 is "Yes".
      - predicate: A71.outcome is None or not (A71.outcome > 0)
        hint: Asked only when no current religion was given at A71.
      - predicate: not (A72.outcome in [2, 7, 8])
        hint: Asked only when question A72 is none of "No", "(Refusal)", "(Don't know)".
      input:
        control: Dropdown
        labels:
          1: 01 Option 1
          2: 02 Option 2
          3: 03 Option 3
          4: 04 Option 4
          5: 05 Option 5
          6: 06 Option 6
          7: 07 Option 7
          8: 08 Option 8
          9: 09 Option 9
          10: 10 Option 10
          11: 11 Option 11
          12: 12 Option 12
          13: 13 Option 13
          14: 14 Option 14
          15: 15 Option 15
          16: '16 Other: please write in'
          77: (Refusal)
          88: (Don't know)
    - id: A74
      kind: Question
      title: CARD 32 Regardless of whether you belong to a particular religion, how religious would you say you are?
      input:
        control: Dropdown
        labels:
          0: 00 Not at all religious
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Very religious
          77: (Refusal)
          88: (Don't know)
    - id: A75
      kind: Question
      title: CARD 33 Apart from special occasions such as weddings and funerals, about how often do you attend religious services nowadays?
      input:
        control: Dropdown
        labels:
          1: Every day
          2: More than once a week
          3: Once a week
          4: At least once a month
          5: Only on special holy days
          6: Less often
          7: Never
          77: (Refusal)
          88: (Don't know)
    - id: A76
      kind: Question
      title: STILL CARD 33 Apart from when you are at religious services, how often, if at all, do you pray?
      input:
        control: Dropdown
        labels:
          1: Every day
          2: More than once a week
          3: Once a week
          4: At least once a month
          5: Only on special holy days
          6: Less often
          7: Never
          77: (Refusal)
          88: (Don't know)
  - id: b_s4_discrimination
    title: Discrimination
    items:
    - id: A77
      kind: Question
      title: Would you describe yourself as being a member of a group that is discriminated against in this country?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: A78
      kind: Question
      title: 'On what grounds is your group discriminated against? SC WEB and PAPER: Select all that apply. F2F INTERVIEWER: PROBE: What other grounds? CODE ALL THAT APPLY'
      precondition:
      - predicate: A77.outcome == 1
        hint: Asked only when question A77 is "Yes".
      - predicate: not (A77.outcome in [2, 7, 8])
        hint: Asked only when question A77 is none of "No", "(Refusal)", "(Don't know)".
      input:
        control: Checkbox
        labels:
          1: 01 Colour or race
          2: 02 Nationality
          4: 03 Religion
          8: 04 Language
          16: 05 Ethnic group
          32: 06 Age
          64: 07 Gender
          128: 08 Sexuality
          256: 09 Disability
          512: '10 Other: please write in'
          1024: 77 (Refusal)
          2048: 88 (Don't know)
  - id: b_s4_citizenship
    title: Citizenship and birthplace
    items:
    - id: A79
      kind: Question
      title: Are you a citizen of [country]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: A80
      kind: Question
      title: Were you born in [country]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
  - id: b_s4_born_abroad
    title: Born abroad
    precondition:
    - predicate: A80.outcome == 2
      hint: Asked only when question A80 is "No".
    - predicate: not (A80.outcome == 1)
      hint: Asked only when question A80 is not "Yes".
    - predicate: not (A80.outcome in [7, 8])
      hint: Asked only when question A80 is none of "(Refusal)", "(Don't know)".
    items:
    - id: A81
      kind: Question
      title: 'In which country were you born? SC PAPER INSTRUCTIONS: Please write in: (To be coded into pre-specified ISO 3166-1 (2 character))'
      input:
        control: Textarea
        maxLength: 100
    - id: A82
      kind: Question
      title: 'What year did you first come to live in [country]? SC WEB AND PAPER INSTRUCTIONS: Please enter all four digits.'
      input:
        control: Editbox
        min: 1900
        max: 8888
  - id: b_s4_language_ethnic
    title: Language and ethnic group
    items:
    - id: A83
      kind: Question
      title: What language or languages do you speak most often at home? Write in a maximum of 2 languages. [Include [country's main language] if this is spoken at home.] TYPE IN UP TO 2 LANGUAGES (To be coded into ISO 639-2 (3 character))
      input:
        control: Textarea
        maxLength: 200
    - id: A84
      kind: Question
      title: Do you feel you are part of the same race or ethnic group79 as most people in [country]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
  - id: b_s4_parents
    title: Parents' birthplace
    items:
    - id: A85
      kind: Question
      title: Was your father born in [country]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Prefer not to answer)
          8: (Don't know)
    - id: A86
      kind: Question
      title: 'In which country was your father born? SC PAPER INSTRUCTIONS: Please write in: (To be coded into pre-specified ISO 3166-1 (2 character))'
      precondition:
      - predicate: A85.outcome == 2
        hint: Asked only when question A85 is "No".
      - predicate: not (A85.outcome in [1, 7, 8])
        hint: Asked only when question A85 is none of "Yes", "(Prefer not to answer)", "(Don't know)".
      input:
        control: Textarea
        maxLength: 100
    - id: A87
      kind: Question
      title: Was your mother born in [country]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Prefer not to answer)
          8: (Don't know)
    - id: A88
      kind: Question
      title: 'In which country was your mother born? SC PAPER INSTRUCTIONS: Please write in: (To be coded into pre-specified ISO 3166-1 (2 character))'
      precondition:
      - predicate: A87.outcome == 2
        hint: Asked only when question A87 is "No".
      - predicate: not (A87.outcome in [1, 7, 8])
        hint: Asked only when question A87 is none of "Yes", "(Prefer not to answer)", "(Don't know)".
      input:
        control: Textarea
        maxLength: 100
  - id: b_s4_eu_referendum
    title: EU referendum
    items:
    - id: A89a
      kind: Question
      title: Now a question on a different topic.84 Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to remain a member of the European Union or to leave the European Union? (EU members ask A89a; non-EU countries ask A89b)
      input:
        control: Radio
        labels:
          1: 01 Remain a member of the European Union
          2: 02 Leave the European Union
          33: (Would submit a blank ballot paper)
          44: (Would spoil the ballot paper)
          55: (Would not vote)
          65: (Not eligible to vote)
          77: (Refusal)
          88: (Don't know)
    - id: A89b
      kind: Question
      title: Now a question on a different topic.84 Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to become a member of the European Union or to remain outside the European Union? (non-EU countries ask A89b)
      input:
        control: Radio
        labels:
          1: 01 Become a member of the European Union
          2: 02 Remain outside the European Union
          33: (Would submit a blank ballot paper)
          44: (Would spoil the ballot paper)
          55: (Would not vote)
          65: (Not eligible to vote)
          77: (Refusal)
          88: (Don't know)
  - id: b_s5_household
    title: 'SECTION B: Household'
    items:
    - id: B1
      kind: Question
      title: Including yourself and any children, how many people live here regularly as members of your household?
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s5_respondent
    title: 'SECTION B: Respondent'
    precondition:
    - predicate: not (B1.outcome == 1)
      hint: Asked only when question B1 is not 1.
    items:
    - id: B2
      kind: Question
      title: And how many of the people in your household are aged 15 or older, including yourself?
      postcondition:
      - predicate: B2.outcome <= B1.outcome
        hint: The number of household members aged 15 or older (B2) should be less than or equal to the number of people in the household (B1).
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B3
      kind: Question
      title: 'What is your sex? (F2F: CODE SEX)'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: B4
      kind: Question
      title: 'In which month and year were you born? Please answer using two digits for the month (e.g. 01 for January) and four digits for the year. [One question with a Month field and a Year field; month must be 01-12 (validation: ''Please enter a valid month of birth (01-12).''); the bounds and checks below apply to the year field]'
      postcondition:
      - predicate: (B4.outcome >= 1900 and B4.outcome <= 2020) or B4.outcome in [7777, 8888]
        hint: Please enter a valid year of birth in full (4 digits) in question B4, between 1900 and 2020.
      input:
        control: Editbox
        min: 1900
        max: 8888
  - id: b_s5_members
    title: 'SECTION B: Household members'
    precondition:
    - predicate: B1.outcome > 1
      hint: Asked only when the household has more than one member.
    - predicate: not (B1.outcome == 1)
      hint: Asked only when question B1 is not 1.
    items:
    - id: HHName
      kind: Question
      title: Person XX First name or initial (optional)
      input:
        control: Textarea
    - id: B5
      kind: Question
      title: What is {Person XX/Person XX's name or initial}'s sex?
      input:
        control: Radio
        labels:
          1: Male
          2: Female
          7: (Refusal)
          8: (Don't know)
    - id: B6
      kind: Question
      title: In which month and year was {Person XX/Person XX's name or initial} born? [One question with a Month field and a Year field; month must be 01-12; the year must be 4 digits, from 1900 up to the current year]
      postcondition:
      - predicate: B6.outcome >= 1900 or B6.outcome in [7777, 8888]
        hint: Please enter a valid year of birth in full (4 digits) in question B6, not before 1900 and not after the current year.
      input:
        control: Editbox
        min: 1900
        max: 8888
    - id: B7
      kind: Question
      title: CARD 34 What is {Person XX/Person XX's name or initial}'s relationship to you? This person is your…
      input:
        control: Radio
        labels:
          1: 01 Husband, wife, or partner
          2: 02 Son or daughter (including step, adopted, foster, or child of partner)
          3: 03 Parent, parent-in-law, partner's parent, or step parent
          4: 04 Brother or sister (including step, adopted, or foster)
          5: 05 Other relative
          6: 06 Other non-relative
          77: 77 (Refusal)
          88: 88 (Don't know)
  - id: b_s5_partner
    title: 'SECTION B: Partner and marital status'
    items:
    - id: B8
      kind: Question
      title: 'SC WEB AND PAPER: Which one of the descriptions from the following list describes your relationship to your husband, wife, or partner? F2F: CARD 35 You just told me that you live with your husband / wife / partner. Which one of the descriptions on this card describes your relationship to them?'
      precondition:
      - predicate: B7.outcome == 1
        hint: Asked only when question B7 is "01 Husband, wife, or partner".
      - predicate: not (B1.outcome == 1)
        hint: Asked only when question B1 is not 1.
      - predicate: not (B7.outcome != 1)
        hint: Asked only when question B7 is "01 Husband, wife, or partner".
      input:
        control: Dropdown
        labels:
          1: 01 Legally married
          2: 02 In a legally registered civil union
          3: 03 Living with my partner (cohabiting) - not legally recognised
          4: 04 Living with my partner (cohabiting) - legally recognised
          5: 05 Legally separated
          6: 06 Legally divorced or civil union dissolved
          7: 07 Option 7
          8: 08 Option 8
          77: 77 (Refusal)
          88: 88 (Don't know)
    - id: B9
      kind: Question
      title: Have you ever lived with a partner without being married to them [or in a civil union]?
      precondition:
      - predicate: B7.outcome != 1 or B8.outcome in [1, 2, 5, 6, 7, 8, 77, 88, 99]
      - predicate: not (B8.outcome in [3, 4])
        hint: Asked only when question B8 is none of "03 Living with my partner (cohabiting) - not legally recognised", "04 Living with my partner (cohabiting) - legally recognised".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: B10
      kind: Question
      title: Have you ever been divorced [or had a civil union dissolved]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: B11
      kind: Question
      title: 'CARD 36 This question is about your legal marital status not about who you may or may not be living with. Which one of the descriptions from the following list describes your legal marital status now? (CODE ONE ONLY: PRIORITY CODE)'
      precondition:
      - predicate: B7.outcome != 1 or B8.outcome in [3, 4]
      input:
        control: Dropdown
        labels:
          1: 01 Legally married
          2: 02 In a legally registered civil union
          3: 03 Legally separated
          4: 04 Legally divorced or civil union dissolved
          5: 05 Widowed or civil partner died
          6: 06 None of these (NEVER married or in legally registered civil union)
          7: 07 Option 7
          8: 08 Option 8
          77: 77 (Refusal)
          88: 88 (Don't know)
    - id: B12
      kind: Question
      title: Have you ever had any children of your own, step-children, adopted children, foster children or a partner's children living in your household?
      precondition:
      - predicate: B7.outcome != 2
        hint: Asked only when question B7 is not "02 Son or daughter (including step, adopted, foster, or child of partner)".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s5_area_education
    title: 'SECTION B: Area and education'
    items:
    - id: B13
      kind: Question
      title: CARD 37 Which of the following phrases best describes the area where you live?
      input:
        control: Radio
        labels:
          1: A big city
          2: The suburbs or outskirts of a big city
          3: A town or a small city
          4: A country village
          5: A farm or home in the countryside
          7: (Refusal)
          8: (Don't know)
    - id: B14a
      kind: Question
      title: CARD 38a [Country-specific text for respondent's highest education question here] [If you are currently in education, select what corresponds to the highest level completed so far. If you completed your education abroad, select the most similar [country] education level.] (B14a/B14b country-specific; countries opt for one or two questions; SC PAPER displays B14 if one)
      input:
        control: Dropdown
        labels:
          1: 01 Option 1
          2: 02 Option 2
          3: 03 Option 3
          4: 04 Option 4
          5: 05 Option 5
          6: 06 Option 6
          7: 07 Option 7
          8: 08 Option 8
          9: 09 Option 9
          10: 10 Option 10
          11: 11 Option 11
          12: 12 Option 12
          13: 13 Option 13
          14: 14 Option 14
          15: 15 Option 15
          16: 16 Option 16
          17: 17 Option 17
          18: 18 Option 18
          19: 19 Option 19
          20: 20 Option 20
          21: 21 Option 21
          22: 22 Option 22
          23: 23 Option 23
          24: 24 Option 24
          25: '25 Other: please write in'
          7777: (Refusal)
          8888: (Don't know)
    - id: B14b
      kind: Question
      title: CARD 38b [Country-specific text for respondent's highest education question here]
      input:
        control: Dropdown
        labels:
          1: 01 Option 1
          2: 02 Option 2
          3: 03 Option 3
          4: 04 Option 4
          5: 05 Option 5
          6: 06 Option 6
          7: 07 Option 7
          8: 08 Option 8
          9: 09 Option 9
          10: 10 Option 10
          11: 11 Option 11
          12: 12 Option 12
          13: 13 Option 13
          14: 14 Option 14
          15: 15 Option 15
          16: 16 Option 16
          17: 17 Option 17
          18: 18 Option 18
          19: 19 Option 19
          20: 20 Option 20
          21: 21 Option 21
          22: 22 Option 22
          23: 23 Option 23
          24: 24 Option 24
          25: '25 Other: please write in'
          7777: (Refusal)
          8888: (Don't know)
    - id: B15
      kind: Question
      title: About how many years of education have you completed, whether full-time or part-time?
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s6_education
    title: Education
    items:
    - id: B15_2
      kind: Question
      title: 'Please report these in full-time equivalents and include compulsory years of schooling. If you don''t know the exact figure, please give an estimate. Round your answer up or down to the nearest whole year. Full-time equivalents: if you completed a part-time course, please count the number of years it would have taken you to complete the same course full-time. Years of education'
      postcondition:
      - predicate: B15_2.outcome <= 30 or B15_2.outcome in [77, 88]
        hint: Please check whether you have entered an accurate number of completed years of education (B15) before pressing Next.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
        right: years (77 = Refusal, 88 = Don't know)
  - id: b_s6_activity
    title: Activity in the last 7 days
    items:
    - id: B16
      kind: Question
      title: 'CARD 39 Which of the following descriptions applies to what you have been doing for the last 7 days? INSTRUCTIONS for all modes: Please select all that apply. F2F INTERVIEWER: PROBE: Which others? CODE ALL THAT APPLY'
      postcondition:
      - predicate: B16.outcome > 0
        hint: It's important to know whether you are currently working or doing something else (B16). Please select at least one answer if you can.
        invented: true
      input:
        control: Checkbox
        labels:
          1: 01 — in paid work (or away temporarily) (employee, self-employed, working for your family business)
          2: 02 — in education, (not paid for by employer) even if on vacation
          4: 03 — unemployed and actively looking for a job
          8: 04 — unemployed, wanting a job but not actively looking for a job
          16: 05 — permanently sick or disabled
          32: 06 — retired
          64: 07 — in community or military service
          128: 08 — doing housework, looking after children or other persons
          256: 09 — (Other)
          512: 77 — (Refusal)
          1024: 88 — (Don't know)
    - id: B17
      kind: Question
      title: 'STILL CARD 39 And which of these descriptions best describes your situation in the last 7 days? INSTRUCTIONS for all modes: Please select only one. PROGRAMMING NOTE FOR F2F and SC WEB: Response options 1-9 should be filtered to only display options that were selected at B16'
      precondition:
      - predicate: ((B16.outcome // 1) % 2) + ((B16.outcome // 2) % 2) + ((B16.outcome // 4) % 2) + ((B16.outcome // 8) % 2) + ((B16.outcome // 16) % 2) + ((B16.outcome // 32) % 2) + ((B16.outcome // 64) % 2) + ((B16.outcome // 128) % 2) + ((B16.outcome // 256) % 2) > 1
        hint: Asked only when more than one description was selected at B16.
      - predicate: not (((B16.outcome // 1) % 2) + ((B16.outcome // 2) % 2) + ((B16.outcome // 4) % 2) + ((B16.outcome // 8) % 2) + ((B16.outcome // 16) % 2) + ((B16.outcome // 32) % 2) + ((B16.outcome // 64) % 2) + ((B16.outcome // 128) % 2) + ((B16.outcome // 256) % 2) <= 1)
        hint: Not asked when at most one description was selected at B16.
      postcondition:
      - predicate: B17.outcome > 0
        hint: This question (B17) is important, please answer if you can.
        invented: true
      input:
        control: Radio
        labels:
          1: 01 — in paid work (or away temporarily) (employee, self-employed, working for your family business)
          2: 02 — in education, (not paid for by employer) even if on vacation
          3: 03 — unemployed and actively looking for a job
          4: 04 — unemployed, wanting a job but not actively looking for a job
          5: 05 — permanently sick or disabled
          6: 06 — retired
          7: 07 — in community or military service
          8: 08 — doing housework, looking after children or other persons
          9: 09 — (Other)
          77: 77 — (Refusal)
          88: 88 — (Don't know)
    - id: B18
      kind: Question
      title: Just to check, did you do any paid work of an hour or more in the last 7 days?
      precondition:
      - predicate: (B16.outcome // 1) % 2 == 0
        hint: Asked only when paid work was not selected at B16.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: B19
      kind: Question
      title: Have you ever had a paid job?
      precondition:
      - predicate: B18.outcome in [2, 7, 8, 9]
        hint: Asked only when question B18 is one of "No", "(Refusal)", "(Don't know)", 9.
      - predicate: not (B18.outcome == 1)
        hint: Asked only when question B18 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: B20
      kind: Question
      title: In what year were you last in a paid job?
      precondition:
      - predicate: B19.outcome == 1
        hint: Asked only when question B19 is "Yes".
      - predicate: not (B18.outcome == 1)
        hint: Asked only when question B18 is not "Yes".
      - predicate: not (B19.outcome == 2)
        hint: Asked only when question B19 is not "No".
      input:
        control: Editbox
        min: 1900
        max: 8888
        right: (7777 = Refusal, 8888 = Don't know)
  - id: b_s6_main_job
    title: Main or last job
    precondition:
    - predicate: (B16.outcome // 1) % 2 == 1 or B18.outcome == 1 or B19.outcome == 1
      hint: Asked of people in paid work, or who did paid work in the last 7 days, or who have ever had a paid job.
    - predicate: not (B19.outcome == 2)
      hint: Asked only when question B19 is not "No".
    items:
    - id: B21
      kind: Question
      title: 'In your main job {are/were} you… (SC PAPER: In your main job are you, or were you…) READ OUT'
      input:
        control: Radio
        labels:
          1: an employee
          2: self-employed
          3: working for your own family's business
          7: (Refusal)
          8: (Don't know)
    - id: B22
      kind: Question
      title: 'How many employees {do/did} you have? (SC PAPER: How many employees do you, or did you, have?) If you are unsure, please provide an estimate. If you have no employees, enter 0. TYPE IN NUMBER OF EMPLOYEES'
      precondition:
      - predicate: B21.outcome == 2
        hint: Asked only when question B21 is "self-employed".
      - predicate: not (B21.outcome in [1, 3])
        hint: Asked only when question B21 is none of "an employee", "working for your own family's business".
      input:
        control: Editbox
        min: 0
        max: 88888
        right: (77777 = Refusal, 88888 = Don't know)
    - id: B23
      kind: Question
      title: '{Do/did} you have a work contract of… (SC PAPER: Do you, or did you, have a work contract of...) READ OUT…'
      input:
        control: Radio
        labels:
          1: Unlimited duration
          2: Limited duration
          3: No contract at all
          7: (Refusal)
          8: (Don't know)
    - id: B24
      kind: Question
      title: 'Including yourself, about how many people {are/were} employed at the place where you usually {work/worked}? (SC PAPER: Including yourself, about how many people are, or were, employed at your place of work?) READ OUT…'
      input:
        control: Radio
        labels:
          1: under 10
          2: 10 to 24
          3: 25 to 99
          4: 100 to 499
          5: 500 or more
          7: (Refusal)
          8: (Don't know)
    - id: B25
      kind: Question
      title: 'In your main job, {do/did} you have any responsibility for supervising the work of other employees? (SC PAPER: In your main job, do you, or did you, have any responsibility for supervising the work of other employees?)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: B26
      kind: Question
      title: 'How many people {are/were} you responsible for? (SC PAPER: How many people are you, or were you, responsible for?) TYPE IN NUMBER'
      precondition:
      - predicate: B25.outcome == 1
        hint: Asked only when question B25 is "Yes".
      - predicate: not (B25.outcome == 2)
        hint: Asked only when question B25 is not "No".
      input:
        control: Editbox
        min: 0
        max: 88888
        right: (77777 = Refusal, 88888 = Don't know)
    - id: B27
      kind: Question
      title: CARD 40 How much {does/did} the management at your work allow you to decide how your own daily work {is/was} organised? (0 = I have/had no influence, 10 = I have/had complete control)
      input:
        control: Dropdown
        labels:
          0: 00 — I have/had no influence
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — I have/had complete control
          77: (Refusal)
          88: (Don't know)
    - id: B28
      kind: Question
      title: STILL CARD 40 How much {does/did} the management at your work allow you to influence policy decisions about the activities of the organisation? (0 = I have/had no influence, 10 = I have/had complete control)
      input:
        control: Dropdown
        labels:
          0: 00 — I have/had no influence
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — I have/had complete control
          77: (Refusal)
          88: (Don't know)
    - id: B29
      kind: Question
      title: 'What {are/were} your total ''basic'' or contracted hours each week in your main job? INSTRUCTIONS for all modes: Please exclude any paid and unpaid overtime. Round up or down to whole hours. ACCEPTABLE RANGE OF RESPONSES IS BETWEEN 0 AND 168 HOURS. TYPE IN HOURS'
      postcondition:
      - predicate: B29.outcome <= 80 or B29.outcome in [555, 777, 888]
        hint: Please check whether you have entered an accurate number of weekly contracted working hours (B29) before pressing Next.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 888
        right: hours (555 = No set 'basic' or contracted number of hours, 777 = Refusal, 888 = Don't know)
    - id: B30
      kind: Question
      title: Regardless of your basic or contracted hours, how many hours {do/did} you normally work a week in your main job, including any paid or unpaid overtime? This may be the same as your 'basic' or contracted hours or different. If your hours vary week-to-week, please give your best estimate. Round up or down to whole hours. ACCEPTABLE RANGE OF RESPONSES IS BETWEEN 0 AND 168 HOURS. TYPE IN HOURS
      postcondition:
      - predicate: B30.outcome <= 80 or B30.outcome in [777, 888]
        hint: Please check whether you have entered an accurate number of your normal working hours per week (B30) before pressing Next.
        invented: true
      - predicate: B29.outcome in [555, 777, 888] or B30.outcome in [777, 888] or B29.outcome <= B30.outcome
        hint: Your normal weekly hours including overtime (B30) are normally not fewer than your basic or contracted hours (B29). Please check both answers.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 888
        right: hours (777 = Refusal, 888 = Don't know)
    - id: B31
      kind: Question
      title: What {does/did} the firm or organisation you {work/worked} for mainly make or do? Please give as much detail as you can. But if you can only provide basic information, this would still be helpful. TYPE IN
      input:
        control: Textarea
    - id: B32
      kind: Question
      title: CARD 41 Which of the following types of organisation {do/did} you work for? CODE ONE ANSWER ONLY
      input:
        control: Radio
        labels:
          1: 01 — Central or local government
          2: 02 — Other public sector (such as education and health)
          3: 03 — A state-owned enterprise
          4: 04 — A private firm
          5: 05 — Self-employed
          6: 06 — Other
          77: (Refusal)
          88: (Don't know)
    - id: B33
      kind: Question
      title: What {is/was} your main job? Please be as specific as possible, e.g. 'Primary school teacher' rather than 'Teacher'. TYPE IN
      input:
        control: Textarea
      postcondition:
      - predicate: B33.outcome != ""
        hint: Please type in an answer to B33 if you can. This will help categorise people working in different types of jobs and allow us to understand how this relates to their experiences and opinions.
        invented: true
    - id: B34
      kind: Question
      title: What {do/did} you mainly do in this job? TYPE IN
      input:
        control: Textarea
    - id: B35
      kind: Question
      title: What training or qualifications {are/were} needed for this job? We are interested in what qualifications are normally required for this job. This may be different to your highest qualification. If no specific training or qualifications are needed, please write 'None'. TYPE IN
      input:
        control: Textarea
  - id: b_s6_work_abroad
    title: Work abroad
    precondition:
    - predicate: not (B19.outcome == 2)
      hint: Asked only when question B19 is not "No".
    items:
    - id: B36
      kind: Question
      title: In the last 10 years have you done any paid work in another country for a period of 6 months or more?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
  - id: b_s7_unemployment
    title: Unemployment, trade union and household income
    items:
    - id: B37
      kind: Question
      title: 'Have you ever been unemployed and seeking work for a period of more than 3 months? (SC WEB AND PAPER intro: We''d now like to know about whether there was a time when you haven''t had a job but were looking for one.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
  - id: b_s7_unemployment_spells
    title: Past unemployment spells
    precondition:
    - predicate: B37.outcome == 1
      hint: Asked only when question B37 is "Yes".
    - predicate: not (B37.outcome == 2)
      hint: Asked only when question B37 is not "No".
    items:
    - id: B38
      kind: Question
      title: Have any of these periods of unemployment lasted for 12 months or more?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: B39
      kind: Question
      title: Have any of these periods of unemployment, that lasted more than 3 months, been within the past 5 years?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
  - id: b_s7_union_income_source
    title: Trade union and main income source
    items:
    - id: B40
      kind: Question
      title: Are you or have you ever been a member of a trade union or similar organisation? IF YES, is that currently or previously?
      input:
        control: Radio
        labels:
          1: Yes, currently
          2: Yes, previously
          3: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: B41
      kind: Question
      title: CARD 42 Please consider the income of all household members and any income which may be received by the household as a whole. What is the main source of income in your household? Select one answer only.
      input:
        control: Dropdown
        labels:
          1: 01 — Wages or salaries
          2: 02 — Income from self-employment (excluding farming)
          3: 03 — Income from farming
          4: 04 — Pensions
          5: 05 — Unemployment/redundancy benefit
          6: 06 — Any other social benefits or grants
          7: 07 — Income from investment, savings, insurance or property
          8: 08 — Income from other sources
          77: (Refusal)
          88: (Don't know)
  - id: b_s7_household_income
    title: Household total income
    items:
    - id: B42filter
      kind: Question
      title: '[SC WEB only] The next question refers to your household''s total income (after tax and compulsory deductions). Please indicate whether you would prefer to provide your income in weekly, monthly, or annual figures.'
      input:
        control: Radio
        labels:
          1: Weekly
          2: Monthly
          3: Annual
    - id: B42a
      kind: Question
      title: '[SC WEB only] What is your household''s total weekly income, after tax and compulsory deductions, from all sources? If you don''t know the exact figure, please give an estimate.'
      precondition:
      - predicate: B42filter.outcome == 1
        hint: Asked only when question B42filter is "Weekly".
      - predicate: not (B42filter.outcome == 2)
        hint: Asked only when question B42filter is not "Monthly".
      - predicate: not (B42filter.outcome == 3)
        hint: Asked only when question B42filter is not "Annual".
      input:
        control: Radio
        labels:
          1: Option 1
          2: Option 2
          3: Option 3
          4: Option 4
          5: Option 5
          6: Option 6
    - id: B42b
      kind: Question
      title: '[SC WEB only] What is your household''s total monthly income, after tax and compulsory deductions, from all sources? If you don''t know the exact figure, please give an estimate.'
      precondition:
      - predicate: B42filter.outcome == 2
        hint: Asked only when question B42filter is "Monthly".
      - predicate: not (B42filter.outcome == 3)
        hint: Asked only when question B42filter is not "Annual".
      input:
        control: Radio
        labels:
          1: Option 1
          2: Option 2
          3: Option 3
          4: Option 4
          5: Option 5
          6: Option 6
    - id: B42c
      kind: Question
      title: '[SC WEB only] What is your household''s total annual income, after tax and compulsory deductions, from all sources? If you don''t know the exact figure, please give an estimate.'
      precondition:
      - predicate: B42filter.outcome == 3
        hint: Asked only when question B42filter is "Annual".
      input:
        control: Radio
        labels:
          1: Option 1
          2: Option 2
          3: Option 3
          4: Option 4
          5: Option 5
          6: Option 6
  - id: b_s8_preamble
    title: Interview setup
    items:
    - id: MODE
      kind: Question
      title: 'Interview mode (external input): 1 = SC WEB, 2 = SC PAPER, 3 = F2F; referenced by mode-specific questions'
      external: true
      input:
        control: Radio
        labels:
          1: SC WEB
          2: SC PAPER
          3: F2F
  - id: b_s8_income
    title: Household income
    items:
    - id: B42
      kind: Question
      title: 'What is your household''s total income, after tax and compulsory deductions, from all sources? CARD 43 Using this card, please tell me which letter describes your household''s total income, after tax and compulsory deductions, from all sources? If you don''t know the exact figure, please give an estimate. Use the part of the card that you know best: weekly, monthly or annual income [fn127: The actual amounts must NOT appear in the face-to-face questionnaire. Only the letters and the corresponding numeric codes.] [fn126: In the CAPI questionnaire, this question number is displayed as B42e.] [SC PAPER and F2F only] SC PAPER INSTRUCTIONS: If you don''t know the exact figure, please use an estimate. Select one answer only. PROGRAMMING NOTE for SC PAPER: country teams can decide whether to display weekly, monthly, and/or annual income deciles on their paper questionnaire. NOTE: ten income range categories, each corresponding broadly to deciles of the actual household income range
        in the country; the full list of response categories must always be used.'
      precondition:
      - predicate: MODE.outcome in [2, 3]
        hint: Asked only when question MODE is one of "SC PAPER", "F2F".
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01 J
          2: Option 2 — 02 R
          3: Option 3 — 03 C
          4: Option 4 — 04 M
          5: Option 5 — 05 F
          6: Option 6 — 06 S
          7: Option 7 — 07 K
          8: Option 8 — 08 P
          9: Option 9 — 09 D
          10: Option 10 — 10 H
          77: Prefer not to answer / (Refusal)
          88: (Don't know)
    - id: B43
      kind: Question
      title: 'CARD 44 Which of the following descriptions comes closest to how you feel about your household''s income nowadays? [fn129: ''Feel'': ''describe'', ''view'' or ''see''.] [fn128: Question text has been changed from Round 11 face-to-face for Round 12.] ASK ALL'
      input:
        control: Radio
        labels:
          1: Living comfortably on present income
          2: Coping on present income
          3: Finding it difficult on present income
          4: Finding it very difficult on present income
          7: (Refusal)
          8: (Don't know)
  - id: b_s8_partner
    title: Partner's education and activity
    precondition:
    - predicate: B7.outcome == 1
      hint: Asked only when question B7 is "01 Husband, wife, or partner".
    - predicate: not (B7.outcome != 1)
      hint: Asked only when question B7 is "01 Husband, wife, or partner".
    items:
    - id: B44a
      kind: Question
      title: 'CARD 45a [Country-specific text for partner''s highest education question here] INSTRUCTIONS for all modes: [If they are currently in education, select what corresponds to the highest level they have completed so far. If they completed their education abroad, select the most similar [country] education level.] ASK IF LIVING WITH HUSBAND/WIFE/PARTNER AT B7 (IF 01 AT B7). Country-specific question(s); countries opt whether to use one or two questions; if one, SC PAPER displays B44; response options same as B14. Allow country-specific routing for one or two questions.'
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01
          2: Option 2 — 02
          3: Option 3 — 03
          4: Option 4 — 04
          5: Option 5 — 05
          6: Option 6 — 06
          7: Option 7 — 07
          8: Option 8 — 08
          9: Option 9 — 09
          10: Option 10 — 10
          11: Option 11 — 11
          12: Option 12 — 12
          13: Option 13 — 13
          14: Option 14 — 14
          15: Option 15 — 15
          16: Option 16 — 16
          17: Option 17 — 17
          18: Option 18 — 18
          19: Option 19 — 19
          20: Option 20 — 20
          21: Option 21 — 21
          22: Option 22 — 22
          23: Option 23 — 23
          24: Option 24 — 24
          25: 'Other: please write in — 25'
          7777: (Refusal)
          8888: (Don't know)
    - id: B44b
      kind: Question
      title: 'CARD 45b [Country-specific text for partner''s highest education question here] (second education question, used only if the country opts for two questions; with two questions two showcards are used) INSTRUCTIONS for all modes: [If they are currently in education, select what corresponds to the highest level they have completed so far. If they completed their education abroad, select the most similar [country] education level.]'
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01
          2: Option 2 — 02
          3: Option 3 — 03
          4: Option 4 — 04
          5: Option 5 — 05
          6: Option 6 — 06
          7: Option 7 — 07
          8: Option 8 — 08
          9: Option 9 — 09
          10: Option 10 — 10
          11: Option 11 — 11
          12: Option 12 — 12
          13: Option 13 — 13
          14: Option 14 — 14
          15: Option 15 — 15
          16: Option 16 — 16
          17: Option 17 — 17
          18: Option 18 — 18
          19: Option 19 — 19
          20: Option 20 — 20
          21: Option 21 — 21
          22: Option 22 — 22
          23: Option 23 — 23
          24: Option 24 — 24
          25: 'Other: please write in — 25'
          7777: (Refusal)
          8888: (Don't know)
    - id: B45
      kind: Question
      title: 'CARD 46 Which of the following descriptions applies to what your husband, wife, or partner has been doing for the last 7 days? INSTRUCTIONS for all modes: Please select all that apply. F2F INTERVIEWER: PROBE: Which others? CODE ALL THAT APPLY [fn134: The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.] [fn135: Code 07 does not apply to jobs in the military but to compulsory military and community service only; remove the category where there is no compulsory military service (or equivalent compulsory community service).] Printed codes 01-09, 77, 88 are kept in the labels; answer values are powers of two.'
      input:
        control: Checkbox
        labels:
          1: 01 — in paid work (or away temporarily) (employee, self-employed, working for your family business)
          2: 02 — in education, (not paid for by employer) even if on vacation
          4: 03 — unemployed and actively looking for a job
          8: 04 — unemployed, wanting a job but not actively looking for a job
          16: 05 — permanently sick or disabled
          32: 06 — retired
          64: 07 — in community or military service
          128: 08 — doing housework, looking after children or other persons
          256: 09 — (Other)
          512: 77 — (Refusal)
          1024: 88 — (Don't know)
    - id: B46
      kind: Question
      title: 'STILL CARD 46 And which of these descriptions best describes your husband, wife, or partner''s situation in the last 7 days? INSTRUCTIONS for all modes: Please select only one. PROGRAMMING NOTE FOR F2F and SC WEB: Response options 1-9 should be filtered to only display options that were selected at B45. [fn134: round brackets do not denote unprompted options in face-to-face; displayed in all modes.] [fn136: Code 07 does not apply to jobs in the military but to compulsory military and community service only; remove the category where there is no compulsory military service.]'
      precondition:
      - predicate: (B45.outcome & 1 > 0) + (B45.outcome & 2 > 0) + (B45.outcome & 4 > 0) + (B45.outcome & 8 > 0) + (B45.outcome & 16 > 0) + (B45.outcome & 32 > 0) + (B45.outcome & 64 > 0) + (B45.outcome & 128 > 0) + (B45.outcome & 256 > 0) > 1
        hint: Asked only when more than one description was selected at B45.
      - predicate: not ((B45.outcome & 1 > 0) + (B45.outcome & 2 > 0) + (B45.outcome & 4 > 0) + (B45.outcome & 8 > 0) + (B45.outcome & 16 > 0) + (B45.outcome & 32 > 0) + (B45.outcome & 64 > 0) + (B45.outcome & 128 > 0) + (B45.outcome & 256 > 0) == 1)
        hint: Asked only when more than one description was selected at B45.
      input:
        control: Radio
        labels:
          1: 01 — in paid work (or away temporarily) (employee, self-employed, working for your family business)
          2: 02 — in education, (not paid for by employer) even if on vacation
          3: 03 — unemployed and actively looking for a job
          4: 04 — unemployed, wanting a job but not actively looking for a job
          5: 05 — permanently sick or disabled
          6: 06 — retired
          7: 07 — in community or military service
          8: 08 — doing housework, looking after children or other persons
          9: 09 — (Other)
          77: 77 — (Refusal)
          88: 88 — (Don't know)
    - id: B47
      kind: Question
      title: Just to check, did your husband, wife, or partner do any paid work of an hour or more in the last 7 days? ASK IF PARTNER NOT IN PAID WORK AT B45 (IF NOT 01 at B45)
      precondition:
      - predicate: B45.outcome & 1 == 0
        hint: Asked only when the partner was not in paid work at B45.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
  - id: b_s8_partner_job
    title: Partner's main job
    precondition:
    - predicate: B7.outcome == 1
      hint: Asked only when question B7 is "01 Husband, wife, or partner".
    - predicate: not (B7.outcome != 1)
      hint: Asked only when question B7 is "01 Husband, wife, or partner".
    - predicate: B45.outcome & 1 > 0 or B47.outcome == 1
      hint: Asked only when the partner is in paid work.
    - predicate: not (B47.outcome == 2)
      hint: Asked only when question B47 is not "No".
    items:
    - id: B48
      kind: Question
      title: 'What is your husband, wife, or partner''s main job? Note to F2F INTERVIEWER: TYPE IN (Refusal 77777; Don''t know 88888)'
      input:
        control: Textarea
    - id: B49
      kind: Question
      title: 'What does your husband, wife, or partner mainly do in their job? Note to F2F INTERVIEWER: TYPE IN (Refusal 77777; Don''t know 88888)'
      input:
        control: Textarea
    - id: B50
      kind: Question
      title: 'What training or qualifications are needed for your husband, wife, or partner''s job? SC WEB AND PAPER INSTRUCTIONS: If no specific training or qualifications are needed, please write ''None''. Note to F2F INTERVIEWER: TYPE IN (Refusal 77777; Don''t know 88888)'
      input:
        control: Textarea
    - id: B51
      kind: Question
      title: 'In your husband, wife, or partner''s main job are they… Note to F2F INTERVIEWER: READ OUT'
      input:
        control: Radio
        labels:
          1: an employee
          2: self-employed
          3: working for your own family's business
          7: (Refusal)
          8: (Don't know)
    - id: B52
      kind: Question
      title: 'How many hours does your husband, wife, or partner normally work a week in their main job? INSTRUCTIONS for all modes: Please include any paid or unpaid overtime. If his/her hours vary week-to-week, please give your best estimate. Round up or down to whole hours. ACCEPTABLE RANGE OF RESPONSES IS BETWEEN 0 AND 168 HOURS. TYPE IN HOURS (Refusal 777; Don''t know 888)'
      postcondition:
      - predicate: B52.outcome <= 80 or B52.outcome >= 777
        hint: Please check whether you have entered an accurate number of normal working hours per week for your husband, wife, or partner (B52) before pressing Next.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 888
  - id: b_s8_father
    title: Father's education and work
    items:
    - id: B53a
      kind: Question
      title: 'The following questions are about your parents'' education and employment. CARD 47a [Country-specific text for father''s highest education question here] INSTRUCTIONS for all modes: [If he is currently in education, select what corresponds to the highest level he has completed so far. If he completed his education abroad, select the most similar [country] education level.] ASK ALL. Country-specific question(s); if one question is used SC PAPER displays B53. [fn142: round brackets in the ''All modes'' column denote unprompted options in F2F; ''(Prefer not to answer)'' takes the place of ''(Refusal)'' at this question.]'
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01
          2: Option 2 — 02
          3: Option 3 — 03
          4: Option 4 — 04
          5: Option 5 — 05
          6: Option 6 — 06
          7: Option 7 — 07
          8: Option 8 — 08
          9: Option 9 — 09
          10: Option 10 — 10
          11: Option 11 — 11
          12: Option 12 — 12
          13: Option 13 — 13
          14: Option 14 — 14
          15: Option 15 — 15
          16: Option 16 — 16
          17: Option 17 — 17
          18: Option 18 — 18
          19: Option 19 — 19
          20: Option 20 — 20
          21: Option 21 — 21
          22: Option 22 — 22
          23: Option 23 — 23
          24: Option 24 — 24
          25: 'Other: please write in — 25'
          7777: (Prefer not to answer)
          8888: (Don't know)
    - id: B53b
      kind: Question
      title: 'CARD 47b [Country-specific text for father''s highest education question here] (second education question, used only if the country opts for two questions) INSTRUCTIONS for all modes: [If he is currently in education, select what corresponds to the highest level he has completed so far. If he completed his education abroad, select the most similar [country] education level.]'
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01
          2: Option 2 — 02
          3: Option 3 — 03
          4: Option 4 — 04
          5: Option 5 — 05
          6: Option 6 — 06
          7: Option 7 — 07
          8: Option 8 — 08
          9: Option 9 — 09
          10: Option 10 — 10
          11: Option 11 — 11
          12: Option 12 — 12
          13: Option 13 — 13
          14: Option 14 — 14
          15: Option 15 — 15
          16: Option 16 — 16
          17: Option 17 — 17
          18: Option 18 — 18
          19: Option 19 — 19
          20: Option 20 — 20
          21: Option 21 — 21
          22: Option 22 — 22
          23: Option 23 — 23
          24: Option 24 — 24
          25: 'Other: please write in — 25'
          7777: (Prefer not to answer)
          8888: (Don't know)
    - id: B54
      kind: Question
      title: 'When you were 14, did your father work as an employee, was he self-employed, or was he not working then? [fn144: ''Absent'': not living in same household.] [fn145: Response option has been modified from Round 11 face-to-face for Round 12.] [fn146/147: round brackets in the ''All modes'' column denote unprompted response options in F2F; ''(Prefer not to answer)'' takes the place of ''(Refusal)''.]'
      input:
        control: Radio
        labels:
          1: Employee
          2: Self-employed
          3: Not working
          4: (Father deceased or absent when I was 14)
          7: (Prefer not to answer)
          8: (Don't know)
    - id: B55
      kind: Question
      title: 'CARD 48 Which one of the descriptions from the following list best describes the sort of work your father did when you were 14? SC WEB AND PAPER INSTRUCTIONS: Please select one answer only. Note to F2F INTERVIEWER: There is no right or wrong answer. Just choose the category you think fits best. CODE ONE ANSWER ONLY. RESPONDENTS MUST CHOOSE A CATEGORY THEMSELVES. IF NECESSARY ADD: ''There is no right or wrong answer. Just choose the category you think fits best''. [fn149: The occupations here have not been annotated. If translators are unable to identify the intended occupation, contact ess_translate@gesis.org.] ASK IF FATHER WORKING OR DON''T KNOW OR NO RESPONSE AT B54 (IF B54 = 1, 2, 8, 9)'
      precondition:
      - predicate: B54.outcome in [1, 2, 8, 9]
        hint: Asked only when question B54 is one of "Employee", "Self-employed", "(Don't know)", 9.
      - predicate: not (B54.outcome == 3)
        hint: Asked only when question B54 is not "Not working".
      input:
        control: Dropdown
        labels:
          1: '01 — Professional and technical occupations such as: doctor, teacher, engineer, artist, accountant'
          2: '02 — Higher administrator occupations such as: banker, executive in big business, high government official, union official'
          3: '03 — Clerical occupations such as: secretary, clerk, office manager, book keeper'
          4: '04 — Sales occupations such as: sales manager, shop owner, shop assistant, insurance agent'
          5: '05 — Service occupations such as: restaurant owner, police officer, waiter, caretaker, barber, armed forces'
          6: '06 — Skilled worker such as: foreman, motor mechanic, printer, tool and die maker, electrician'
          7: '07 — Semi-skilled worker such as: bricklayer, bus driver, cannery worker, carpenter, sheet metal worker, baker'
          8: '08 — Unskilled worker such as: labourer, porter, unskilled factory worker'
          9: '09 — Farm worker such as: farmer, farm labourer, tractor driver, fisherman'
          77: (Prefer not to answer)
          88: (Don't know)
  - id: b_s8_mother
    title: Mother's education and work
    items:
    - id: B56a
      kind: Question
      title: 'Now thinking about your mother''s education. CARD 49a [Country-specific text for mother''s highest education question here] INSTRUCTIONS for all modes: [If she is currently in education, select what corresponds to the highest level she has completed so far. If she completed her education abroad, select the most similar [country] education level.] ASK ALL. Country-specific question(s); if one question is used SC PAPER displays B56. [fn152: ''(Prefer not to answer)'' takes the place of ''(Refusal)'' in F2F at this question; round brackets denote unprompted options in F2F.]'
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01
          2: Option 2 — 02
          3: Option 3 — 03
          4: Option 4 — 04
          5: Option 5 — 05
          6: Option 6 — 06
          7: Option 7 — 07
          8: Option 8 — 08
          9: Option 9 — 09
          10: Option 10 — 10
          11: Option 11 — 11
          12: Option 12 — 12
          13: Option 13 — 13
          14: Option 14 — 14
          15: Option 15 — 15
          16: Option 16 — 16
          17: Option 17 — 17
          18: Option 18 — 18
          19: Option 19 — 19
          20: Option 20 — 20
          21: Option 21 — 21
          22: Option 22 — 22
          23: Option 23 — 23
          24: Option 24 — 24
          25: 'Other: please write in — 25'
          7777: (Prefer not to answer)
          8888: (Don't know)
    - id: B56b
      kind: Question
      title: 'CARD 49b [Country-specific text for mother''s highest education question here] (second education question, used only if the country opts for two questions) INSTRUCTIONS for all modes: [If she is currently in education, select what corresponds to the highest level she has completed so far. If she completed her education abroad, select the most similar [country] education level.]'
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01
          2: Option 2 — 02
          3: Option 3 — 03
          4: Option 4 — 04
          5: Option 5 — 05
          6: Option 6 — 06
          7: Option 7 — 07
          8: Option 8 — 08
          9: Option 9 — 09
          10: Option 10 — 10
          11: Option 11 — 11
          12: Option 12 — 12
          13: Option 13 — 13
          14: Option 14 — 14
          15: Option 15 — 15
          16: Option 16 — 16
          17: Option 17 — 17
          18: Option 18 — 18
          19: Option 19 — 19
          20: Option 20 — 20
          21: Option 21 — 21
          22: Option 22 — 22
          23: Option 23 — 23
          24: Option 24 — 24
          25: 'Other: please write in — 25'
          7777: (Prefer not to answer)
          8888: (Don't know)
    - id: B57
      kind: Question
      title: 'When you were 14, did your mother work as an employee, was she self-employed, or was she not working then? [fn153: ''Absent'': not living in same household.] [fn154: Response option has been modified from Round 11 face-to-face for Round 12.] [fn155/156: round brackets in the ''All modes'' column denote unprompted response options in F2F; ''(Prefer not to answer)'' takes the place of ''(Refusal)''.]'
      input:
        control: Radio
        labels:
          1: Employee
          2: Self-employed
          3: Not working
          4: (Mother deceased or absent when I was 14)
          7: (Prefer not to answer)
          8: (Don't know)
    - id: B58
      kind: Question
      title: 'CARD 50 Which one of the descriptions from the following list best describes the sort of work your mother did when you were 14? SC WEB AND PAPER INSTRUCTIONS: Please select one answer only. Note to F2F INTERVIEWER: There is no right or wrong answer. Just choose the category you think fits best. CODE ONE ANSWER ONLY. RESPONDENTS MUST CHOOSE A CATEGORY THEMSELVES. IF NECESSARY ADD: ''There is no right or wrong answer. Just choose the category you think fits best''. [fn158: The occupations here have not been annotated. If translators are unable to identify the intended occupation, contact ess_translate@gesis.org.] ASK IF MOTHER WORKING OR DON''T KNOW OR NO RESPONSE AT B57 (IF B57 = 1, 2, 8, 9)'
      precondition:
      - predicate: B57.outcome in [1, 2, 8, 9]
        hint: Asked only when question B57 is one of "Employee", "Self-employed", "(Don't know)", 9.
      - predicate: not (B57.outcome == 3)
        hint: Asked only when question B57 is not "Not working".
      input:
        control: Dropdown
        labels:
          1: '01 — Professional and technical occupations such as: doctor, teacher, engineer, artist, accountant'
          2: '02 — Higher administrator occupations such as: banker, executive in big business, high government official, union official'
          3: '03 — Clerical occupations such as: secretary, clerk, office manager, book keeper'
          4: '04 — Sales occupations such as: sales manager, shop owner, shop assistant, insurance agent'
          5: '05 — Service occupations such as: restaurant owner, police officer, waiter, caretaker, barber, armed forces'
          6: '06 — Skilled worker such as: foreman, motor mechanic, printer, tool and die maker, electrician'
          7: '07 — Semi-skilled worker such as: bricklayer, bus driver, cannery worker, carpenter, sheet metal worker, baker'
          8: '08 — Unskilled worker such as: labourer, porter, unskilled factory worker'
          9: '09 — Farm worker such as: farmer, farm labourer, tractor driver, fisherman'
          77: (Prefer not to answer)
          88: (Don't know)
  - id: b_s8_training_ancestry
    title: Training and ancestry
    items:
    - id: B59
      kind: Question
      title: The next few questions are about you. During the last twelve months, have you taken any course or attended any lecture or conference to improve your knowledge or skills for work? ASK ALL
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: (Refusal)
          8: (Don't know)
    - id: B60
      kind: Question
      title: 'CARD 51 How would you describe your ancestry? [fn159: ''Ancestry'' in the sense of ''descent'' or ''family origins''.] Ancestry 1 (first drop-down menu). SC WEB: Using the two drop-down menus below, please choose up to two ancestries that best apply to you. SC PAPER: Please choose up to two ancestries that best apply to you. If you only have one ancestry, please leave the second column blank. F2F: Please use this card to choose up to two ancestries that best apply to you. CODE MAXIMUM OF TWO ANCESTRIES IN TOTAL. IF MORE THAN TWO ARE MENTIONED, ASK RESPONDENT TO SELECT TWO. IF RESPONDENT IS UNABLE TO DO THIS, CODE FIRST TWO ANCESTRIES MENTIONED. IF RESPONDENT ONLY SAYS ONE ANCESTRY, PROBE ONCE: Which other? Country-specific question: maximum of 20 response options not including ''Other''; responses recoded into the European Standard Classification of Cultural and Ethnic Groups. If ''Other'' selected, write in ancestry (Ancestry 1).'
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01
          2: Option 2 — 02
          3: Option 3 — 03
          4: Option 4 — 04
          5: Option 5 — 05
          6: Option 6 — 06
          7: Option 7 — 07
          8: Option 8 — 08
          9: Option 9 — 09
          10: Option 10 — 10
          11: Option 11 — 11
          12: Option 12 — 12
          13: Option 13 — 13
          14: Option 14 — 14
          15: Option 15 — 15
          16: Option 16 — 16
          17: Option 17 — 17
          18: Option 18 — 18
          19: Option 19 — 19
          20: Option 20 — 20
          21: Other (write in ancestry)
          777777: (Refusal)
          888888: (Don't know)
    - id: B60_Ancestry_2
      kind: Question
      title: 'How would you describe your ancestry? Ancestry 2 (second drop-down menu / second column of B60; the source prints no separate id). The second drop-down menu begins with the option ''No second ancestry''. [fn159: ''Ancestry'' in the sense of ''descent'' or ''family origins''.] [fn160: In SC PAPER, ''No second ancestry'' is not shown in the questionnaire; it is only coded in SC PAPER if Ancestry 1 has been provided. In SC WEB it is the first response option in the second drop-down menu.] If you only have one ancestry, select ''No second ancestry'' (SC WEB) or leave the second column blank (SC PAPER). If ''Other'' selected, write in ancestry (Ancestry 2).'
      input:
        control: Dropdown
        labels:
          1: Option 1 — 01
          2: Option 2 — 02
          3: Option 3 — 03
          4: Option 4 — 04
          5: Option 5 — 05
          6: Option 6 — 06
          7: Option 7 — 07
          8: Option 8 — 08
          9: Option 9 — 09
          10: Option 10 — 10
          11: Option 11 — 11
          12: Option 12 — 12
          13: Option 13 — 13
          14: Option 14 — 14
          15: Option 15 — 15
          16: Option 16 — 16
          17: Option 17 — 17
          18: Option 18 — 18
          19: Option 19 — 19
          20: Option 20 — 20
          21: Other (write in ancestry)
          555555: (No second ancestry)
          777777: (Refusal)
          888888: (Don't know)
  - id: b_s9_optimism
    title: 'SECTION C: Optimism'
    items:
    - id: C1
      kind: Question
      title: CARD 52 To what extent do you agree or disagree with the following statement? I’m always optimistic about my future. (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t Know)
  - id: b_s9_past_week
    title: 'SECTION C: Feelings during the past week'
    items:
    - id: C2
      kind: Question
      title: CARD 53 How much of the time during the past week did you feel depressed? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C3
      kind: Question
      title: STILL CARD 53 How much of the time during the past week was your sleep restless? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C4
      kind: Question
      title: STILL CARD 53 How much of the time during the past week were you happy? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C5
      kind: Question
      title: STILL CARD 53 How much of the time during the past week did you feel lonely? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C6
      kind: Question
      title: STILL CARD 53 How much of the time during the past week did you enjoy life? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C7
      kind: Question
      title: STILL CARD 53 How much of the time during the past week did you feel sad? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C8
      kind: Question
      title: STILL CARD 53 How much of the time during the past week could you not get going? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C9
      kind: Question
      title: STILL CARD 53 How much of the time during the past week did you have a lot of energy? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C10
      kind: Question
      title: STILL CARD 53 How much of the time during the past week did you feel anxious? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
    - id: C11
      kind: Question
      title: STILL CARD 53 How much of the time during the past week did you feel calm and peaceful? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: None or almost none of the time
          2: Some of the time
          3: Most of the time
          4: All or almost all of the time
          7: (Refusal)
          8: (Don’t Know)
  - id: b_s9_agreement
    title: 'SECTION C: Capability and worth'
    items:
    - id: C12
      kind: Question
      title: C12-C13 To what extent do you agree or disagree with each of the following statements? CARD 54 In my daily life I get very little chance to show how capable I am. (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t Know)
    - id: C13
      kind: Question
      title: STILL CARD 54 I generally feel that what I do in my life is valuable and worthwhile. (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t Know)
  - id: b_s9_community
    title: 'SECTION C: Harmony, help and respect'
    items:
    - id: C14
      kind: Question
      title: 'CARD 55 In your opinion, to what extent is there harmony among the people who live in [country]? F2F INTERVIEWER INSTRUCTIONS: Please use this card where 0 is not at all and 6 is a great deal. (All modes F2F only)'
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — A great deal
          7: (Refusal)
          8: (Don’t know)
    - id: C15
      kind: Question
      title: STILL CARD 55 To what extent do you feel that people in your local area help one another? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — A great deal
          7: (Refusal)
          8: (Don’t know)
    - id: C16
      kind: Question
      title: STILL CARD 55 To what extent do you feel that people treat you with respect? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — A great deal
          7: (Refusal)
          8: (Don’t know)
  - id: b_s9_eleven_point
    title: 'SECTION C: Appreciation and direction'
    items:
    - id: C17
      kind: Question
      title: 'CARD 56 On a typical day, how often do you take notice of and appreciate your surroundings? F2F INTERVIEWER INSTRUCTIONS: Please use this card where 0 is never and 10 is always. (All modes F2F only)'
      input:
        control: Dropdown
        labels:
          0: 00 — Never
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Always
          77: (Refusal)
          88: (Don’t know)
    - id: C18
      kind: Question
      title: 'CARD 57 To what extent do you feel that you have a sense of direction in your life? F2F INTERVIEWER INSTRUCTIONS: Please use this card where 0 is not at all and 10 is completely. (All modes F2F only)'
      input:
        control: Dropdown
        labels:
          0: 00 — Not at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Completely
          77: (Refusal)
          88: (Don’t know)
  - id: b_s9_support_goals
    title: 'SECTION C: Support, goals and security'
    items:
    - id: C19
      kind: Question
      title: 'CARD 58 To what extent do you receive help and support from people you are close to when you need it? F2F INTERVIEWER INSTRUCTIONS: Please use this card where 0 is not at all and 6 is completely. (All modes F2F only)'
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — Completely
          7: (Refusal)
          8: (Don’t know)
    - id: C20
      kind: Question
      title: STILL CARD 58 And to what extent do you provide help and support to people you are close to when they need it? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — Completely
          7: (Refusal)
          8: (Don’t know)
    - id: C21
      kind: Question
      title: STILL CARD 58 To what extent are you doing the things you really want and value in your life? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — Completely
          7: (Refusal)
          8: (Don’t know)
    - id: C22
      kind: Question
      title: STILL CARD 58 To what extent are you able to achieve your goals? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — Completely
          7: (Refusal)
          8: (Don’t know)
    - id: C23
      kind: Question
      title: STILL CARD 58 To what extent do you feel safe and secure in your life nowadays? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — Completely
          7: (Refusal)
          8: (Don’t know)
  - id: b_s9_connection
    title: 'SECTION C: Closeness and connection'
    items:
    - id: C24
      kind: Question
      title: CARD 59 Generally speaking, how close and connected do you feel to other people? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — Extremely
          7: (Refusal)
          8: (Don’t know)
    - id: C25
      kind: Question
      title: STILL CARD 59 How close and connected do you feel to the people in your local area? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — Extremely
          7: (Refusal)
          8: (Don’t know)
  - id: b_s9_self_compassion
    title: 'SECTION C: Resilience and self-compassion'
    items:
    - id: C26
      kind: Question
      title: CARD 60 To what extent do you agree or disagree with the following statement? In difficult periods of my life, I can usually find something good that helps me change for the better. (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t Know)
    - id: C27
      kind: Question
      title: CARD 61 When you hear about an acquaintance going through a difficult time, how much compassion do you usually feel for them? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — None at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — A great deal
          7: (Refusal)
          8: (Don’t know)
    - id: C28
      kind: Question
      title: CARD 62 When you are going through a difficult time, to what extent do you give yourself the care and kindness you need? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — A great deal
          7: (Refusal)
          8: (Don’t know)
    - id: C29
      kind: Question
      title: STILL CARD 62 To what extent do you feel there is harmony in your life, that is, you feel balanced and at peace with yourself? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Not at all
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — A great deal
          7: (Refusal)
          8: (Don’t know)
    - id: C30
      kind: Question
      title: CARD 63 In difficult situations, how often do you manage to take a pause without immediately reacting? (All modes F2F only)
      input:
        control: Radio
        labels:
          0: 0 — Never
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 — Always
          7: (Refusal)
          8: (Don’t know)
  - id: b_s10_global_help
    title: Global help and national interest
    items:
    - id: D1
      kind: Question
      title: CARD 64 How important do you think it is that people in countries which are better off should help those in poorer countries who are unable to provide for their basic needs? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Very important
          2: Important
          3: Not very important
          4: Not at all important
          7: (Refusal)
          8: (Don’t know)
    - id: D2
      kind: Question
      title: CARD 65 How acceptable do you think it is that people ONLY help those who genuinely deserve assistance? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Very acceptable
          2: Acceptable
          3: Not very acceptable
          4: Not at all acceptable
          7: (Refusal)
          8: (Don’t know)
    - id: D3
      kind: Question
      title: CARD 66 Would you say that the world would be a better or a worse place if people from other countries were more like the [country nationality] people? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: World would be a much better place
          2: World would be a better place
          3: Would not make it a better or worse place
          4: World would be a worse place
          5: World would be a much worse place
          7: (Refusal)
          8: (Don’t know)
    - id: D4
      kind: Question
      title: CARD 67 How often should [country] be ruthless in asserting its national interests against other countries? (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Hardly ever
          5: Never
          7: (Refusal)
          8: (Don’t know)
  - id: b_s10_entry_criteria
    title: Criteria for immigration
    items:
    - id: D5
      kind: Question
      title: 'How important do you think each of these things should be in deciding whether someone born, brought up and living outside [country] should be able to come and live here? F2F INTERVIEWER INSTRUCTIONS: Please answer using the scale, where 0 means ‘Extremely unimportant’ and 10 means ‘Extremely important’. CARD 68 Firstly, how important should it be for them to have good educational qualifications? (All modes F2F only)'
      input:
        control: Dropdown
        labels:
          0: 00 — Extremely unimportant
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Extremely important
          77: (Refusal)
          88: (Don’t know)
    - id: D6
      kind: Question
      title: STILL CARD 68 How important should it be for them to be able to speak [country’s official language(s)]? (All modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Extremely unimportant
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Extremely important
          77: (Refusal)
          88: (Don’t know)
    - id: D7
      kind: Question
      title: STILL CARD 68 How important should it be for them to come from a Christian background? (All modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Extremely unimportant
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Extremely important
          77: (Refusal)
          88: (Don’t know)
    - id: D8
      kind: Question
      title: STILL CARD 68 How important should it be for them to be white? (All modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Extremely unimportant
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Extremely important
          77: (Refusal)
          88: (Don’t know)
  - id: b_s10_immigrant_effects
    title: Effects of immigration
    items:
    - id: D9
      kind: Question
      title: CARD 69 Would you say that people who come to live here generally take jobs away from workers in [country], or generally help to create new jobs? (All modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Take jobs away
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Create new jobs
          77: (Refusal)
          88: (Don’t know)
    - id: D10
      kind: Question
      title: CARD 70 Most people who come to live here work and pay taxes. They also use health and welfare services. On balance, do you think people who come here take out more than they put in or put in more than they take out? (All Modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Generally take out more
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Generally put in more
          77: (Refusal)
          88: (Don’t know)
    - id: D11
      kind: Question
      title: CARD 71 Are [country]’s crime problems made worse or better by people coming to live here from other countries? (All Modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Crime problems made worse
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Crime problems made better
          77: (Refusal)
          88: (Don’t know)
  - id: b_s10_social_distance
    title: Social distance
    items:
    - id: D12
      kind: Question
      title: Now, thinking of people who have come to live in [country] from another country who are of a different race or ethnic group from most [country nationality] people. CARD 72 How much would you mind or not mind if someone like this was appointed as your boss? (All Modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Not mind at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Mind a lot
          77: (Refusal)
          88: (Don’t know)
    - id: D13
      kind: Question
      title: SC WEB INSTRUCTIONS Still thinking of people who have come to live in [country] from another country who are of a different race or ethnic group from most [country nationality] people. STILL CARD 72 How much would you mind or not mind if someone like this married a close relative of yours? (All Modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Not mind at all
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Mind a lot
          77: (Refusal)
          88: (Don’t know)
  - id: b_s10_refugees
    title: Refugees
    items:
    - id: D14
      kind: Question
      title: Some people come to this country and apply for refugee status on the grounds that they fear persecution in their own country. Please indicate how much you agree or disagree with the following statements. CARD 73 [country] has more than its fair share of people applying for refugee status. (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
    - id: D15
      kind: Question
      title: STILL CARD 73 While their applications for refugee status are being considered, people should be allowed to work in [country]. (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
    - id: D16
      kind: Question
      title: Please indicate how much you agree or disagree with the following statements. STILL CARD 73 The government should be generous in judging people’s applications for refugee status. (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
    - id: D17
      kind: Question
      title: STILL CARD 73 While their cases are being considered, applicants should be kept in detention centres. (All modes F2F only)
      input:
        control: Radio
        labels:
          1: Agree strongly
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Disagree strongly
          7: (Refusal)
          8: (Don’t know)
  - id: b_s10_immigrant_population
    title: Immigrant population and treatment
    items:
    - id: D18
      kind: Question
      title: 'Out of every 100 people living in [country], how many do you think were born outside [country]? SC WEB AND PAPER QUESTION INSTRUCTIONS: F2F INTERVIEWER INSTRUCTIONS: Please write an answer between 0 and 100 in the box below. If you are unsure, please give your best estimate. IF RESPONDENT SAYS ‘DON’T KNOW’; SAY: Please give your best estimate. TYPE IN NUMBER. (Refusal) 777, (Don’t know) 888. Validation text: if a negative number or a number greater than 100 is entered: Please enter a number between 0 and 100.'
      input:
        control: Editbox
        min: 0
        max: 100
    - id: D19
      kind: Question
      title: ASK IF 1 AT A80 (IF A80=1). CARD 74 Compared to people like yourself who were born in [country], how do you think the government treats those who have recently come to live here from other countries? (All modes F2F only)
      precondition:
      - predicate: A80.outcome == 1
        hint: Asked only when question A80 is "Yes".
      - predicate: not (A80.outcome != 1)
        hint: Asked only when question A80 is "Yes".
      input:
        control: Radio
        labels:
          1: Much better
          2: A little better
          3: The same
          4: A little worse
          5: Much worse
          7: (Refusal)
          8: (Don’t know)
    - id: D20
      kind: Question
      title: ASK ALL. CARD 75 Do you think the religious beliefs and practices in [country] are generally undermined or enriched by people coming to live here from other countries? (All Modes F2F only)
      input:
        control: Dropdown
        labels:
          0: 00 — Religious beliefs and practices undermined
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 — Religious beliefs and practices enriched
          77: (Refusal)
          88: (Don’t know)
  - id: b_s11_external
    title: External inputs
    items:
    - id: SAMPLE
      kind: Question
      title: 'Random allocation in advance of fieldwork of D30a/D30b/D30c/D30d: 25% of the total sample each (ASK SAMPLE A / B / C / D)'
      external: true
      input:
        control: Radio
        labels:
          1: Sample A
          2: Sample B
          3: Sample C
          4: Sample D
    - id: MODE_2
      kind: Question
      title: Mode of administration of the interview (F2F versus SC web and paper), known from the sample/fieldwork
      external: true
      input:
        control: Radio
        labels:
          1: F2F
          2: SC WEB AND PAPER
    - id: G4_VERSION
      kind: Question
      title: 'Country decision: include G4a instead of G4b, or G4b instead of G4a (confirmed during development stage)'
      external: true
      input:
        control: Radio
        labels:
          1: G4a included
          2: G4b included
  - id: b_s12_contact
    title: 'SECTION D (continued): Contact with other races and ethnic groups'
    items:
    - id: D21
      kind: Question
      title: 'Do you have any close friends who are of a different race or ethnic group from most [country nationality] people? F2F INTERVIEWER INSTRUCTIONS: IF YES, is that several or a few?'
      input:
        control: Radio
        labels:
          1: Yes, several
          2: Yes, a few
          3: No, none at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D22
      kind: Question
      title: 'CARD 76 How often do you have any contact with people who are of a different race or ethnic group from most [country nationality] people when you are out and about? This could be on public transport, in the street, in shops or in the neighbourhood. INSTRUCTIONS FOR ALL MODES: Any contact should be included, whether verbal or non-verbal.'
      input:
        control: Dropdown
        labels:
          1: 01 Never
          2: 02 Less than once a month
          3: 03 Once a month
          4: 04 Several times a month
          5: 05 Once a week
          6: 06 Several times a week
          7: 07 Every day
          77: 77 (Refusal)
          88: 88 (Don’t know)
    - id: D23
      kind: Question
      title: 'ASK IF CODE 02, 03, 04, 05, 06, 07 AT D22. CARD 77 Thinking about this contact, in general how bad or good is it? SC WEB INSTRUCTIONS: ‘This contact’ refers to contact with people who are of a different race or ethnic group from most [country nationality] people when you are out and about.'
      precondition:
      - predicate: D22.outcome in [2, 3, 4, 5, 6, 7]
        hint: Asked only when question D22 is one of "02 Less than once a month", "03 Once a month", "04 Several times a month", "05 Once a week", "06 Several times a week", "07 Every day".
      - predicate: not (D22.outcome in [1, 77, 88])
        hint: Asked only when question D22 is none of "01 Never", "77 (Refusal)", "88 (Don’t know)".
      input:
        control: Dropdown
        labels:
          0: 00 Extremely bad
          1: '01'
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: '06'
          7: '07'
          8: 08
          9: 09
          10: 10 Extremely good
          77: 77 (Refusal)
          88: 88 (Don’t know)
  - id: b_s12_beliefs
    title: Beliefs about races, ethnic groups and cultures
    items:
    - id: D24
      kind: Question
      title: ASK ALL. CARD 78 Do you think some races or ethnic groups are born less intelligent than others?
      input:
        control: Radio
        labels:
          1: Yes, definitely
          2: Yes, probably
          3: No, probably not
          4: No, definitely not
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D25
      kind: Question
      title: STILL CARD 78 Do you think some races or ethnic groups are born harder working than others?
      input:
        control: Radio
        labels:
          1: Yes, definitely
          2: Yes, probably
          3: No, probably not
          4: No, definitely not
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D26
      kind: Question
      title: STILL CARD 78 Thinking about the world today, would you say that some cultures are much better than others?
      input:
        control: Radio
        labels:
          1: Yes, definitely
          2: Yes, probably
          3: No, probably not
          4: No, definitely not
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D27
      kind: Question
      title: STILL CARD 78 Do you think that we should protect [country nationality] culture from the influence of other cultures?
      input:
        control: Radio
        labels:
          1: Yes, definitely
          2: Yes, probably
          3: No, probably not
          4: No, definitely not
          7: 7 (Refusal)
          8: 8 (Don’t know)
  - id: b_s12_immigration
    title: Allowing people from other countries to live here
    items:
    - id: D28
      kind: Question
      title: CARD 79 To what extent do you think [country] should allow Jewish people from other countries to come and live here?
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D29
      kind: Question
      title: STILL CARD 79 To what extent do you think [country] should allow Muslims from other countries to come and live here?
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D30a
      kind: Question
      title: ASK SAMPLE A. STILL CARD 79 In recent years, people from European countries like Ukraine have left their country because of war. Imagine a situation where Christians from a European country outside the EU have to leave their country because war makes their homes unsafe. To what extent do you think [country] should allow them to come and live here?
      precondition:
      - predicate: SAMPLE.outcome == 1
        hint: Asked only when question SAMPLE is "Sample A".
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D30b
      kind: Question
      title: ASK SAMPLE B. STILL CARD 79 In recent years, people from European countries like Ukraine have left their country due to the lack of work. Imagine a situation where Christians from a European country outside the EU have to leave their country because they are unemployed due to a lack of work. To what extent do you think [country] should allow them to come and live here?
      precondition:
      - predicate: SAMPLE.outcome == 2
        hint: Asked only when question SAMPLE is "Sample B".
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D30c
      kind: Question
      title: ASK SAMPLE C. STILL CARD 79 In recent years, people from Middle Eastern countries like Syria have left their country because of war. Imagine a situation where Muslims from a Middle Eastern country have to leave their country because war makes their homes unsafe. To what extent do you think [country] should allow them to come and live here?
      precondition:
      - predicate: SAMPLE.outcome == 3
        hint: Asked only when question SAMPLE is "Sample C".
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: D30d
      kind: Question
      title: ASK SAMPLE D. STILL CARD 79 In recent years, people from Middle Eastern countries like Syria have left their country due to the lack of work. Imagine a situation where Muslims from a Middle Eastern country have to leave their country because they are unemployed due to a lack of work. To what extent do you think [country] should allow them to come and live here?
      precondition:
      - predicate: SAMPLE.outcome == 4
        hint: Asked only when question SAMPLE is "Sample D".
      input:
        control: Radio
        labels:
          1: Allow many to come and live here
          2: Allow some
          3: Allow a few
          4: Allow none
          7: 7 (Refusal)
          8: 8 (Don’t know)
  - id: b_s13_values
    title: SECTION E
    items:
    - id: E1
      kind: Question
      title: CARD 80 It is important to this person to develop their own opinions.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E2
      kind: Question
      title: STILL CARD 80 It is important to this person that the state is strong and can defend its citizens.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E3
      kind: Question
      title: STILL CARD 80 It is important to this person to enjoy life’s pleasures.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E4
      kind: Question
      title: STILL CARD 80 It is important to this person never to make other people angry.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E5
      kind: Question
      title: STILL CARD 80 It is important to this person to be very successful.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E6
      kind: Question
      title: STILL CARD 80 It is important to this person that everyone be treated justly, even people they don’t know.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E7
      kind: Question
      title: STILL CARD 80 It is important to this person to have the power to make others comply with what they want.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E8
      kind: Question
      title: STILL CARD 80 It is important to this person to be humble.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E9
      kind: Question
      title: STILL CARD 80 It is important to this person to protect the natural environment from pollution or destruction.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E10
      kind: Question
      title: STILL CARD 80 It is important to this person never to be humiliated.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E11
      kind: Question
      title: STILL CARD 80 It is important to this person to have all sorts of new experiences.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E12
      kind: Question
      title: STILL CARD 80 It is important to this person to help the people close to them.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E13
      kind: Question
      title: STILL CARD 80 It is important to this person to be wealthy.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E14
      kind: Question
      title: STILL CARD 80 It is important to this person to be personally safe and secure.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E15
      kind: Question
      title: STILL CARD 80 It is important to this person to be tolerant towards all kinds of people and groups.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E16
      kind: Question
      title: STILL CARD 80 It is important to this person never to violate rules or regulations.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E17
      kind: Question
      title: STILL CARD 80 It is important to this person to make their own decisions about their life.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E18
      kind: Question
      title: STILL CARD 80 It is important to this person to follow traditions. These might be cultural, family or religious traditions.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E19
      kind: Question
      title: STILL CARD 80 It is important to this person that the people they know have full confidence in them.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
    - id: E20
      kind: Question
      title: STILL CARD 80 It is important to this person that their achievements are recognised by other people.
      input:
        control: Radio
        labels:
          1: Very much like me
          2: Like me
          3: Somewhat like me
          4: A little like me
          5: Not like me
          6: Not like me at all
          7: 7 (Refusal)
          8: 8 (Don’t know)
  - id: b_s14_experience
    title: SECTION F
    precondition:
    - predicate: MODE_2.outcome == 2
      hint: Asked only when question MODE is "SC WEB AND PAPER".
    items:
    - id: F1
      kind: Question
      title: Overall, how well did you feel you understood the questions?
      input:
        control: Radio
        labels:
          1: Understood only a few of the questions
          2: Understood some of the questions
          3: Understood most of the questions
          4: Understood all or nearly all of the questions
    - id: F2
      kind: Question
      title: Did you feel reluctant to answer any questions?
      input:
        control: Radio
        labels:
          1: None of the questions
          2: A few of the questions
          3: Some of the questions
          4: Most of the questions
          5: All or nearly all of the questions
    - id: F3
      kind: Question
      title: Did anyone else assist you in completing this questionnaire?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s14_assistance
    title: Assistance with the questionnaire
    precondition:
    - predicate: MODE_2.outcome == 2
      hint: Asked only when question MODE is "SC WEB AND PAPER".
    - predicate: F3.outcome == 1
      hint: Asked only when question F3 is "Yes".
    - predicate: not (F3.outcome == 2)
      hint: Asked only when question F3 is not "No".
    items:
    - id: F4
      kind: Question
      title: ASK IF ASSISTED WITH THE QUESTIONNAIRE AT F3 (IF F3 = 1). Who assisted you in completing the questionnaire? Please choose all that apply.
      input:
        control: Checkbox
        labels:
          1: 1 — Husband, wife, or partner
          2: 2 — Son or daughter
          4: 3 — Parent, parent-in-law, step-parent, or partner’s parent
          8: 4 — Other relative
          16: 5 — Other non-relative
          32: 6 — The person who delivered the questionnaire
    - id: F5
      kind: Question
      title: What kind of assistance was given to you in completing the questionnaire? Please choose all that apply.
      input:
        control: Checkbox
        labels:
          1: 1 — Understanding the invitation letter and getting started
          2: 2 — Accessing the online survey
          4: 3 — Reading the questions aloud to me
          8: 4 — Providing information for questions about relatives or household members
          16: 5 — Helping me decide answers to other questions
          32: 6 — Returning my completed paper questionnaire
          64: '7 — Other: please write in'
  - id: b_s14_comments
    title: Further comments
    precondition:
    - predicate: MODE_2.outcome == 2
      hint: Asked only when question MODE is "SC WEB AND PAPER".
    items:
    - id: F6
      kind: Question
      title: ASK ALL SC WEB AND PAPER ONLY. Do you have any further comments on this survey or its questions?
      input:
        control: Textarea
  - id: b_s15_consent
    title: SECTION G
    items:
    - id: G1
      kind: Question
      title: 'ASK ALL. Thank you for giving your time to complete this survey today. [NAME OF SURVEY] may want to contact you again to invite you to take part in further research on similar topics to those covered by the questions that you have answered here. This would involve contacting you by email, text message, telephone or post and inviting you to take part in a follow-up study. As a token of our appreciation, we would send you [a voucher of at least €X] with an invitation to take part. Would it be okay if we contact you again, to invite you to take part in a follow-up study? Note to F2F INTERVIEWER: FURTHER DETAILS ON THIS ARE INCLUDED IN THE PARTICIPANT INFORMATION LEAFLET GIVEN TO THE RESPONDENT BEFORE TAKING PART IN THIS INTERVIEW. PLEASE REFER THEM TO THIS.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s15_contact
    title: Contact details
    precondition:
    - predicate: G1.outcome == 1
      hint: Asked only when question G1 is "Yes".
    - predicate: not (G1.outcome == 2 and MODE_2.outcome == 2)
      hint: Not asked when G1 is "No" and MODE_2 is 2.
    items:
    - id: G2
      kind: Question
      title: 'ASK IF AGREE TO BE RECONTACTED AT G1 (G1= 1). SC WEB AND PAPER: We are very grateful for your willingness to be contacted again. To be able to reach you, we need your name, email address, physical address, and/or a mobile phone number. We will only use this information to contact you about the follow-up study and we will not give it to anyone outside the study. Please enter your first name and surname below. F2F: I will now ask you for some contact information to allow us to contact you regarding any further research. Note to F2F INTERVIEWER: ENTER/CONFIRM NAME OF RESPONDENT. First name / Surname'
      input:
        control: Textarea
    - id: G3
      kind: Question
      title: 'SC WEB AND PAPER: Please enter your email address in the boxes below. Please check your email address carefully before moving to the next question. If you do not have an email address, please leave this question blank. F2F: ENTER EMAIL ADDRESS OF RESPONDENT; READ EMAIL ADDRESS BACK TO RESPONDENT TO CONFIRM THIS HAS BEEN ENTERED CORRECTLY; SKIP QUESTION IF EMAIL ADDRESS NOT GIVEN BY RESPONDENT. Box 1. (Interviewers can skip if respondent declines.)'
      input:
        control: Textarea
    - id: G3_2
      kind: Question
      title: 'G3 box 2 (re-entry of the email address). SC WEB AND PAPER: Please re-enter your email address: F2F: RE-ENTER RESPONDENT’S EMAIL ADDRESS. Validation text: if box 1 does not equal box 2: Your email addresses do not match. Please re-enter them in the boxes provided.'
      input:
        control: Textarea
      postcondition:
      - predicate: G3_2.outcome == G3.outcome
        hint: Your email addresses do not match. Please re-enter them in the boxes provided.
  - id: b_s15_address
    title: Postal address
    items:
    - id: G4a
      kind: Question
      title: ASK G4a IF COUNTRY DECIDES TO INCLUDE G4a INSTEAD OF G4b. Do you agree that we may retain your physical address that we used to contact you for this survey? In order to invite you to take part in a follow up study, we will need to send you a letter in the mail.
      precondition:
      - predicate: G4_VERSION.outcome == 1 and G1.outcome == 1
        hint: Asked only when the G4a version is used and G1 is "Yes".
      - predicate: not (G1.outcome == 2 and MODE_2.outcome == 2)
        hint: Not asked when G1 is "No" and MODE_2 is 2.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: G4b
      kind: Question
      title: 'ASK G4b IF COUNTRY DECIDES TO INCLUDE G4b INSTEAD OF G4a. SC WEB AND PAPER: Please enter your address in the boxes below. In order to invite you to take part in a follow up study, we will need to send you a letter in the mail. F2F: ENTER/CONFIRM POSTAL ADDRESS OF RESPONDENT; READ ADDRESS BACK TO RESPONDENT TO CONFIRM THIS HAS BEEN ENTERED CORRECTLY. Name of property / Number / Address 1 / Address 2 / City / County / Post Code (each text box optional for countries; interviewers can skip if respondent declines)'
      precondition:
      - predicate: G4_VERSION.outcome == 2 and G1.outcome == 1
        hint: Asked only when the G4b version is used and G1 is "Yes".
      - predicate: not (G1.outcome == 2 and MODE_2.outcome == 2)
        hint: Not asked when G1 is "No" and MODE_2 is 2.
      input:
        control: Textarea
  - id: b_s15_mobile
    title: Mobile telephone
    precondition:
    - predicate: G1.outcome == 1
      hint: Asked only when question G1 is "Yes".
    - predicate: not (G1.outcome == 2 and MODE_2.outcome == 2)
      hint: Not asked when G1 is "No" and MODE_2 is 2.
    items:
    - id: G5
      kind: Question
      title: 'ASK IF AGREE TO BE RECONTACTED AT G1 (G1= 1). SC WEB AND PAPER: Please enter your mobile telephone number in the boxes below. We may invite you to participate in a future study by sending you a text message. If you have an international phone number, please include the [country code]. F2F: ENTER MOBILE TELEPHONE NUMBER OF RESPONDENT; READ MOBILE PHONE NUMBER BACK TO RESPONDENT TO CONFIRM (interviewers can skip if respondent declines)'
      input:
        control: Textarea
  - id: b_s16_preamble
    title: Fieldwork settings
    precondition:
    - predicate: not (G1.outcome == 2 and MODE_2.outcome == 2)
      hint: Asked unless the earlier G1 and MODE_2 answers exclude this section
    items:
    - id: COUNTRY_INCLUDES_G6
      kind: Question
      title: Country decision whether to include G6 (confirmed during development stage for ESS Round 12)
      external: true
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: MODE_3
      kind: Question
      title: Mode of data collection (F2F, SC PAPER, SC WEB), set by the fieldwork protocol and not collected by any question
      external: true
      input:
        control: Radio
        labels:
          1: F2F
          2: SC PAPER
          3: SC WEB
    - id: DATA_ENTRY
      kind: Question
      title: 'Flag: this is the data entry questionnaire (paper data entry), set by the fieldwork process and not collected by any question'
      external: true
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
  - id: b_s16_phone_confirm
    title: Confirm mobile number
    precondition:
    - predicate: not (G1.outcome == 2 and MODE_2.outcome == 2)
      hint: Asked unless the earlier G1 and MODE_2 answers exclude this section
    items:
    - id: G5_confirm
      kind: Question
      title: CONFIRM THIS HAS BEEN ENTERED CORRECTLY (re-enter mobile phone number, box 2) SKIP QUESTION IF MOBILE NUMBER NOT GIVEN BY RESPONDENT
      precondition:
      - predicate: G5.outcome is not None and G5.outcome != ""
        hint: Only asked when a mobile number was given
      postcondition:
      - predicate: G5_confirm.outcome == G5.outcome
        hint: Your phone numbers do not match. Please re-enter them in the boxes provided (G5 mobile number and its confirmation box)
      input:
        control: Textarea
  - id: b_s16_incentive
    title: Incentive
    precondition:
    - predicate: not (G1.outcome == 2 and MODE_2.outcome == 2)
      hint: Asked unless the earlier G1 and MODE_2 answers exclude this section
    items:
    - id: G6
      kind: Question
      title: As a thank you for taking part in this survey we will [send you] [a voucher for] [€xx]. May we use the contact details you've already provided to ensure it reaches you? (SC WEB AND PAPER ONLY. ASK IF COUNTRY DECIDES TO INCLUDE G6)
      precondition:
      - predicate: COUNTRY_INCLUDES_G6.outcome == 1 and MODE_3.outcome in [2, 3]
        hint: Asked only in SC web and paper modes when the country includes G6
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No, I don't want to receive this
          3: No, I'd like to provide other details
  - id: b_s17_incentive
    title: SECTION H - Incentive
    precondition:
    - predicate: MODE_3.outcome in [2, 3] and (G1.outcome in [2, 9] or G6.outcome == 3 or G6.outcome == 9 or COUNTRY_INCLUDES_G6.outcome == 0)
      hint: Asked when the mode is paper or web and the G1/G6 conditions hold
    - predicate: not (G6.outcome == 1 and MODE_3.outcome == 2)
      hint: Not asked of paper respondents with G6 equal to 1
    - predicate: not (G6.outcome == 2 and MODE_3.outcome == 2)
      hint: Not asked of paper respondents with G6 equal to 2
    items:
    - id: H1
      kind: Question
      title: 'Thank you for taking part in this survey today – we really appreciate you giving your time. [As a thank you for taking part we will [send you] [a voucher for] [€X]. Please enter your [name/email address/phone number/address] below to ensure it reaches you. This will only be used to send you this gift and will be securely deleted at the end of the project (no later than December 2027).] Fields: First name, Surname, Email address, Mobile phone number, Name of property, Number, Address 1, Address 2, City, County, Post Code'
      input:
        control: Textarea
  - id: b_s17_paper_date
    title: SECTION H - Paper completion date
    items:
    - id: H2
      kind: Question
      title: SC PAPER QUESTION WORDING Please record the date when you finished completing this questionnaire. Day Month Year (ASK ALL SC PAPER ONLY)
      precondition:
      - predicate: MODE_3.outcome == 2
        hint: Asked only when question MODE is "SC PAPER".
      input:
        control: Textarea
  - id: b_s17_data_entry
    title: SECTION H - Data entry
    items:
    - id: H3
      kind: Question
      title: DATA ENTRY QUESTIONNAIRE QUESTION WORDING Please enter your data entry coder ID number (DATA ENTRY QUESTIONNAIRE ONLY – ID NUMBER FOR DATA ENTRY CODER)
      precondition:
      - predicate: DATA_ENTRY.outcome == 1
        hint: Asked only when question DATA_ENTRY is "Yes".
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s18_interview
    title: SECTION J
    precondition:
    - predicate: MODE_3.outcome == 1
      hint: Asked only when question MODE is "F2F".
    items:
    - id: J1
      kind: Question
      title: Please select how the interview was conducted from the list below.
      input:
        control: Radio
        labels:
          1: In person inside respondent’s home
          2: In person outside of respondent’s home
          3: By video
    - id: J2
      kind: Question
      title: Did the respondent ask for clarification on any questions?
      input:
        control: Radio
        labels:
          1: Never
          2: Almost never
          3: Now and then
          4: Often
          5: Very often
          8: Don’t know
    - id: J3
      kind: Question
      title: Did you feel that the respondent was reluctant to answer any questions?
      input:
        control: Radio
        labels:
          1: Never
          2: Almost never
          3: Now and then
          4: Often
          5: Very often
          8: Don’t know
    - id: J4
      kind: Question
      title: Did you feel that the respondent tried to answer the questions to the best of his or her ability?
      input:
        control: Radio
        labels:
          1: Never
          2: Almost never
          3: Now and then
          4: Often
          5: Very often
          8: Don’t know
    - id: J5
      kind: Question
      title: Overall, did you feel that the respondent understood the questions?
      input:
        control: Radio
        labels:
          1: Never
          2: Almost never
          3: Now and then
          4: Often
          5: Very often
          8: Don’t know
    - id: J6
      kind: Question
      title: Was anyone else present, who interfered with the interview?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: J7
      kind: Question
      title: Who was this? CODE ALL THAT APPLY
      precondition:
      - predicate: MODE_3.outcome == 1 and J6.outcome == 1
      - predicate: not (J6.outcome == 2)
        hint: Asked only when question J6 is not "No".
      input:
        control: Checkbox
        labels:
          1: 1 — Husband/wife/partner
          2: 2 — Son/daughter (inc. step, adopted, foster, child of partner)
          4: 3 — Parent/parent-in-law/step-parent/partner’s parent
          8: 4 — Other relative
          16: 5 — Other non-relative
          32: 8 — Don’t know
    - id: J8
      kind: Question
      title: In which language was the interview conducted? [use pre-specified ISO 639-2 codes for all languages that questionnaire is translated into]
      input:
        control: Radio
        labels:
          1: '[First language that questionnaire translated into] [appropriate ISO 639-2 code]'
          2: '[Second language questionnaire translated into] [appropriate ISO 639-2 code]'
    - id: J9
      kind: Question
      title: 'Interviewer ID. NOTE: THIS NUMBER MUST BE EXCLUSIVE TO INDIVIDUAL INTERVIEWERS AND MUST NOT BE SHARED'
      input:
        control: Textarea
    - id: J10
      kind: Question
      title: If you have any additional comments on the interview, please type them in the space below.
      input:
        control: Textarea
