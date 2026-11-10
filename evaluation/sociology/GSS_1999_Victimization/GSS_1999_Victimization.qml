qmlVersion: '2.7'
questionnaire:
  title: General Social Survey, 1999 - Cycle 13 - Victimization
  blocks:
  - id: b_s1_preamble
    title: Household roster (external inputs)
    items:
    - id: ROSTER_N
      kind: Question
      title: Total number of household roster members (from the household roster, collected by CATI)
      external: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: ROSTER_X
      kind: Question
      title: Index x of the current {household member x} in the roster loop (CATI roster counter)
      external: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: ROSTER_Y
      kind: Question
      title: Index y of the {household member y} in the roster loop (CATI roster counter)
      external: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: HH_AGE
      kind: Question
      title: Age of household member x (from the household roster)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s1_marital
    title: Marital status
    items:
    - id: MARSTAT
      kind: Question
      title: 'Is {household member x}''s marital status ..... INT: ===READ LIST==='
      precondition:
      - predicate: HH_AGE.outcome >= 15
        hint: Asked only of household members aged 15 or older
      input:
        control: Radio
        labels:
          1: Living common-law?
          2: Married?
          3: Widowed?
          4: Divorced?
          5: Separated?
          6: Single (never married)?
  - id: b_s1_relationships
    title: Relationships
    items:
    - id: INTRO_2
      kind: Question
      title: What is {household member x}'s relationship to {household member y}?
      precondition:
      - predicate: ROSTER_N.outcome > 1
        hint: Asked only when the household has more than one member
      - predicate: not (ROSTER_N.outcome == 1)
        hint: Asked only when question ROSTER_N is not 1.
      input:
        control: Dropdown
        labels:
          2: Husband/wife/spouse
          3: Common-law partner
          4: Son or daughter
          10: Father or mother
          15: Brother or sister
          20: Grandchild
          21: Grandfather or grandmother
          30: Son-in-law or daughter-in-law
          31: Father-in-law or mother-in-law
          32: Brother-in-law or sister-in-law
          40: Nephew or niece
          41: Uncle or aunt
          42: Cousin
          50: Other relative
          60: Non-relative
          70: Same sex partner
    - id: INTRO_3
      kind: Question
      title: Is {household member x} the birth or step-child of {household member y}?
      precondition:
      - predicate: INTRO_2.outcome == 4
        hint: Asked only when question INTRO_2 is "Son or daughter".
      - predicate: not (ROSTER_N.outcome == 1)
        hint: Asked only when question ROSTER_N is not 1.
      - predicate: not (INTRO_2.outcome == 10)
        hint: Asked only when question INTRO_2 is not "Father or mother".
      - predicate: not (ROSTER_Y.outcome == ROSTER_N.outcome and ROSTER_X.outcome == ROSTER_Y.outcome - 1)
        hint: Not asked for the last roster pair
      input:
        control: Radio
        labels:
          5: Birth child
          6: Adopted child
          7: Step-child
          8: Foster child
    - id: INTRO_4
      kind: Question
      title: Is {household member x} the birth or step-father/mother of {household member y}?
      precondition:
      - predicate: INTRO_2.outcome == 10
        hint: Asked only when question INTRO_2 is "Father or mother".
      - predicate: not (ROSTER_N.outcome == 1)
        hint: Asked only when question ROSTER_N is not 1.
      - predicate: not (ROSTER_Y.outcome == ROSTER_N.outcome and ROSTER_X.outcome == ROSTER_Y.outcome - 1)
        hint: Not asked for the last roster pair
      input:
        control: Radio
        labels:
          11: Birth parent
          12: Adoptive parent
          13: Step parent
          14: Foster parent
  - id: b_s1_birth
    title: Respondent birth date
    items:
    - id: INTRO_5Y
      kind: Question
      title: 'What is your year of birth? (year) [CATI: 1890-1984]'
      input:
        control: Editbox
        min: 1890
        max: 1984
    - id: INTRO_5M
      kind: Question
      title: 'What is your month of birth? (month) [CATI: 1-12]'
      input:
        control: Editbox
        min: 1
        max: 12
    - id: INTRO_5D
      kind: Question
      title: 'What is your day of birth? (day) [CATI: 1-31]'
      input:
        control: Editbox
        min: 1
        max: 31
  - id: b_s1_phone_screen
    title: Telephone lines
    items:
    - id: TE1
      kind: Question
      title: To reach you for this interview, I dialed (fill phone number). Excluding cellular telephones, is this your household's only telephone number? (Because the survey sample is based on random telephone numbers, households with more than one telephone number have a greater chance of being selected for the survey. We need to ask a few questions to adjust for this.)
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
  - id: b_s1_phone_multi
    title: Multiple telephone numbers
    precondition:
    - predicate: TE1.outcome == 3
      hint: Asked only when question TE1 is "No".
    items:
    - id: TE2
      kind: Question
      title: 'Including (fill phone number), how many telephone numbers does your household have? INT:===Respondent must have at least two telephone numbers in this question since they indicated in TE1 that (fill phone number) is not their only telephone number=== [CATI: 2-10]'
      input:
        control: Editbox
        min: 2
        max: 10
    - id: TE3
      kind: Question
      title: Are any of these numbers for computer, fax or business use only?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: TE4
      kind: Question
      title: 'How many of these numbers are for computer, fax or business use only? [CATI: 1-10]'
      precondition:
      - predicate: TE3.outcome == 1
        hint: Asked only when question TE3 is "Yes".
      postcondition:
      - predicate: TE4.outcome < TE2.outcome
        hint: El número de lignes d'ordinateur, de télécopieur ou d'affaires (TE4) doit être inférieur au nombre total de numéros de téléphone du ménage (TE2). Corrigez TE4 ou TE2.
      input:
        control: Editbox
        min: 1
        max: 10
    - id: TE4e
      kind: Question
      title: 'CATI Error screen: You just said that you have [fill TE4] telephone numbers for computer, fax or business use only. This number is greater than/equal to the [fill TE2] telephone numbers reported for your household.. Which number should be corrected? (source prints no id; id TE4e taken from the CATI-TE4e label)'
      precondition:
      - predicate: TE4.outcome >= TE2.outcome
        hint: Shown only when TE4 is not less than TE2
      input:
        control: Radio
        labels:
          1: Correct number of computer, fax, business phone numbers in TE4
          2: Correct total number of phone numbers for household in TE2
          3: Correct both numbers in TE2 and TE4
          99: Refusal
  - id: b_s2_preamble
    title: Interview setup
    items:
    - id: SCENARIO
      kind: Question
      title: 'Sentencing scenario randomly assigned to the respondent (CATI-A26e: Assign respondent to answer ONE of the following 8 scenarios in random order)'
      external: true
      input:
        control: Radio
        labels:
          1: Scenario 1
          2: Scenario 2
          3: Scenario 3
          4: Scenario 4
          5: Scenario 5
          6: Scenario 6
          7: Scenario 7
          8: Scenario 8
  - id: b_s2_neighbourhood
    title: Crime in the neighbourhood
    items:
    - id: A1
      kind: Question
      title: Let's begin with some general questions on crime and safety. Compared to other areas in Canada, do you think your neighbourhood has a higher amount of crime, about the same or a lower amount of crime? (Neighbourhood refers to the area surrounding your home.)
      input:
        control: Radio
        labels:
          1: Higher
          2: About the same
          3: Lower
          98: Don't know
          99: Refused
    - id: A2
      kind: Question
      title: During the last 5 years, do you think that crime in your neighbourhood has increased, decreased, or remained about the same? INT:===If the respondent has just moved into the neighbourhood and has not lived there long enough to have an opinion, select "don't know"===
      input:
        control: Radio
        labels:
          1: Increased
          2: Decreased
          3: About the same
          98: Don't know
          99: Refused
  - id: b_s2_walking
    title: Walking alone after dark
    items:
    - id: A3
      kind: Question
      title: 'Now, I am going to ask you about some everyday situations, and I would like you to tell me how safe you feel from crime in each situation. How safe do you feel from crime walking ALONE in your area after dark? Do you feel .... INT:===If respondent cannot walk, ask if they would go out in a wheelchair.=== INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: Very safe?
          2: Reasonably safe?
          3: Somewhat unsafe?
          4: Very unsafe?
          5: Does not walk alone
          98: Don't know
          99: Refused
    - id: A4
      kind: Question
      title: How often do you walk ALONE in your area after dark? INT:===READ LIST===
      precondition:
      - predicate: A3.outcome in [1, 2, 3, 4, 98]
        hint: Asked only when question A3 is one of "Very safe?", "Reasonably safe?", "Somewhat unsafe?", "Very unsafe?", "Don't know".
      - predicate: not (A3.outcome == 5)
        hint: Asked only when question A3 is not "Does not walk alone".
      - predicate: not (A3.outcome == 99)
        hint: Asked only when question A3 is not "Refused".
      input:
        control: Radio
        labels:
          1: Daily?
          2: At least once a week?
          3: At least once a month?
          4: Less than once a month?
          5: Never?
          99: Refused
    - id: A5
      kind: Question
      title: If you felt safer from crime, would you do this (more often)?
      precondition:
      - predicate: not (A3.outcome == 99)
        hint: Asked only when question A3 is not "Refused".
      - predicate: not (A4.outcome == 1)
        hint: Asked only when question A4 is not "Daily?".
      - predicate: not (A4.outcome == 99)
        hint: Asked only when question A4 is not "Refused".
      - predicate: not (A3.outcome == 1)
        hint: Asked only when question A3 is not "Very safe?".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
  - id: b_s2_transport
    title: Public transportation after dark
    items:
    - id: A6
      kind: Question
      title: 'While waiting for or using public transportation ALONE after dark, do you feel... INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: Very worried?
          2: Somewhat worried?
          3: Not at all worried about your safety from crime?
          4: Does not use public transportation/night
          5: No public transportation available
          98: Don't know
          99: Refused
    - id: A7
      kind: Question
      title: How often do you use public transportation ALONE after dark? INT:===READ LIST===
      precondition:
      - predicate: A6.outcome in [1, 2, 3, 98]
        hint: Asked only when question A6 is one of "Very worried?", "Somewhat worried?", "Not at all worried about your safety from crime?", "Don't know".
      - predicate: not (A6.outcome == 4)
        hint: Asked only when question A6 is not "Does not use public transportation/night".
      - predicate: not (A6.outcome in [5, 99])
        hint: Asked only when question A6 is none of "No public transportation available", "Refused".
      input:
        control: Radio
        labels:
          1: Daily?
          2: At least once a week?
          3: At least once a month?
          4: Less than once a month?
          5: Never?
          99: Refused
    - id: A8
      kind: Question
      title: If you felt safer from crime, would you use public transportation ALONE after dark (more often)?
      precondition:
      - predicate: not (A6.outcome in [5, 99])
        hint: Asked only when question A6 is none of "No public transportation available", "Refused".
      - predicate: not (A7.outcome in [1, 99])
        hint: Asked only when question A7 is none of "Daily?", "Refused".
      - predicate: not (A6.outcome == 3)
        hint: Asked only when question A6 is not "Not at all worried about your safety from crime?".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
  - id: b_s2_home
    title: Alone at home
    items:
    - id: A9
      kind: Question
      title: 'When ALONE in your home in the evening or at night, do you feel... INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: Very worried?
          2: Somewhat worried?
          3: Not at all worried about your safety from crime?
          4: Never alone
          98: Don't know
          99: Refused
  - id: b_s2_police
    title: Local police force
    items:
    - id: A10a
      kind: Question
      title: 'Do you think your local police force does a good job, an average job or a poor job … a) of enforcing the laws? ("Local police force" refers to the police responsible for your municipality. Exclude security guards, fire marshals and all others who have no authority to make arrests.) INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A10b
      kind: Question
      title: A10 b) of promptly responding to calls?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A10c
      kind: Question
      title: A10 c) of being approachable and easy to talk to?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A10d
      kind: Question
      title: A10 d) of supplying information to the public on ways to reduce crime?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A10e
      kind: Question
      title: A10 e) of ensuring the safety of the citizens of your area?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
  - id: b_s2_courts
    title: Criminal courts
    items:
    - id: A11a
      kind: Question
      title: 'Now I would like to ask you a similar question about the Canadian CRIMINAL courts. Are they doing a good job, an average job or a poor job … a) of providing justice quickly? INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A11b
      kind: Question
      title: A11 b) of helping the victim?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A11c
      kind: Question
      title: A11 c) of determining whether the accused or the person charged is guilty or not?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A11d
      kind: Question
      title: A11 d) of ensuring a fair trial for the accused?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
  - id: b_s2_prison_parole
    title: Prison and parole systems
    items:
    - id: A13a
      kind: Question
      title: 'Do you think that the PRISON SYSTEM does a good job, an average job or a poor job … a) of supervising and controlling prisoners while in prison? INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A13b
      kind: Question
      title: A13 b) of helping prisoners become law-abiding citizens?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A14a
      kind: Question
      title: 'Do you think that the PAROLE SYSTEM does a good job, an average job or a poor job … a) of releasing offenders who are not likely to commit another crime? (The responsibility of the parole system is to decide which prison inmates can serve part of their sentence in the community under supervision and to make sure the conditions of parole are being met. If offenders don''t meet parole conditions they can be returned to prison.) INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
    - id: A14b
      kind: Question
      title: A14 b) of supervising offenders on parole?
      input:
        control: Radio
        labels:
          1: Good job
          2: Average job
          3: Poor job
          98: Don't know
          99: Refused
  - id: b_s2_contact
    title: Contact with police and courts
    items:
    - id: A19a
      kind: Question
      title: 'During the past 12 MONTHS, did you come into contact with the police … a) for a public information session? INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A19b
      kind: Question
      title: A19 b) for a traffic violation?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A19c
      kind: Question
      title: A19 c) as a victim of a crime?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A19d
      kind: Question
      title: A19 d) as a witness to a crime?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A19e
      kind: Question
      title: A19 e) by being arrested?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A19f
      kind: Question
      title: A19 f) for any other reason?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A19S
      kind: Question
      title: 'Specify.... [CATI]: Length of field = 50'
      precondition:
      - predicate: A19f.outcome == 1
        hint: Asked only when question A19f is "Yes".
      - predicate: not (A19f.outcome != 1)
        hint: Asked only when question A19f is "Yes".
      input:
        control: Textarea
        maxLength: 50
    - id: A19A_2
      kind: Question
      title: Have you ever had contact with the Canadian CRIMINAL courts? (Exclude family and traffic courts)
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
  - id: b_s2_evening
    title: Evening activities
    items:
    - id: A20a
      kind: Question
      title: 'On average, how many times a month do you go out during the EVENING to do the following activities? INT:===If respondent states "Less than once a month" enter (95). If the respondent says "Never" enter (0). If the respondent answers in weeks, multiply by four to convert that amount into times per month=== INT:===READ LIST=== a) Work nights, attend night classes, go to meetings or do volunteer work? [CATI: 0-95] (r) Refused'
      input:
        control: Editbox
        min: 0
        max: 95
    - id: A20b
      kind: Question
      title: 'A20 b) Go to restaurants, movies or the theatre? [CATI: 0-95] (r) Refused'
      input:
        control: Editbox
        min: 0
        max: 95
    - id: A20c
      kind: Question
      title: 'A20 c) Go to bars or pubs? (include comedy clubs) [CATI: 0-95] (r) Refused'
      input:
        control: Editbox
        min: 0
        max: 95
    - id: A20d
      kind: Question
      title: 'A20 d) Go out for sports, exercise or recreational activities? (as participant or spectator) [CATI: 0-95] (r) Refused'
      input:
        control: Editbox
        min: 0
        max: 95
    - id: A20e
      kind: Question
      title: 'A20 e) Shop? (include window shopping) [CATI: 0-95] (r) Refused'
      input:
        control: Editbox
        min: 0
        max: 95
    - id: A20f
      kind: Question
      title: 'A20 f) Visit relatives or friends in their HOMES? [CATI: 0-95] (r) Refused'
      input:
        control: Editbox
        min: 0
        max: 95
    - id: A20g
      kind: Question
      title: 'A20 g) Go to casinos or bingos [CATI: 0-95] (r) Refused'
      input:
        control: Editbox
        min: 0
        max: 95
    - id: A20h
      kind: Question
      title: 'A20 h) Other evening activities not already mentioned? [CATI: 0-95] (r) Refused'
      postcondition:
      - predicate: A20a.outcome < 31 and A20b.outcome < 31 and A20c.outcome < 31 and A20d.outcome < 31 and A20e.outcome < 31 and A20f.outcome < 31 and A20g.outcome < 31 and A20h.outcome < 31
        hint: Una o más actividades de la pregunta A20 (a a h) suman 31 o más veces al mes; verifique las respuestas de A20a a A20h con el entrevistado.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 95
  - id: b_s2_protect_first
    title: Protective actions
    items:
    - id: A21a
      kind: Question
      title: 'Have you ever done any of the following things to PROTECT yourself or your property from crime? Have you ever . . . INT:===Probe to be sure action was taken as a protection from crime=== INT: ===READ LIST=== a) changed your routine, activities, or avoided certain places?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
  - id: b_s2_protect_rest
    title: Protective actions (continued)
    precondition:
    - predicate: not (A21a.outcome == 1)
      hint: Asked only when question A21a is not "Yes".
    items:
    - id: A21b
      kind: Question
      title: A21 b) installed new locks or security bars?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21c
      kind: Question
      title: A21 c) installed burglar alarms or motion detector lights?
      precondition:
      - predicate: not (A21b.outcome == 1)
        hint: Asked only when question A21b is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21d
      kind: Question
      title: A21 d) taken a self defense course?
      precondition:
      - predicate: not (A21b.outcome == 1)
        hint: Asked only when question A21b is not "Yes".
      - predicate: not (A21c.outcome == 1)
        hint: Asked only when question A21c is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21e
      kind: Question
      title: A21 e) changed your phone number?
      precondition:
      - predicate: not (A21b.outcome == 1)
        hint: Asked only when question A21b is not "Yes".
      - predicate: not (A21c.outcome == 1)
        hint: Asked only when question A21c is not "Yes".
      - predicate: not (A21d.outcome == 1)
        hint: Asked only when question A21d is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21f
      kind: Question
      title: A21 f) obtained a dog?
      precondition:
      - predicate: not (A21b.outcome == 1)
        hint: Asked only when question A21b is not "Yes".
      - predicate: not (A21c.outcome == 1)
        hint: Asked only when question A21c is not "Yes".
      - predicate: not (A21d.outcome == 1)
        hint: Asked only when question A21d is not "Yes".
      - predicate: not (A21e.outcome == 1)
        hint: Asked only when question A21e is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21g
      kind: Question
      title: A21 g) obtained a gun?
      precondition:
      - predicate: not (A21b.outcome == 1)
        hint: Asked only when question A21b is not "Yes".
      - predicate: not (A21c.outcome == 1)
        hint: Asked only when question A21c is not "Yes".
      - predicate: not (A21d.outcome == 1)
        hint: Asked only when question A21d is not "Yes".
      - predicate: not (A21e.outcome == 1)
        hint: Asked only when question A21e is not "Yes".
      - predicate: not (A21f.outcome == 1)
        hint: Asked only when question A21f is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21h
      kind: Question
      title: A21 h) changed residence or moved?
      precondition:
      - predicate: not (A21b.outcome == 1)
        hint: Asked only when question A21b is not "Yes".
      - predicate: not (A21c.outcome == 1)
        hint: Asked only when question A21c is not "Yes".
      - predicate: not (A21d.outcome == 1)
        hint: Asked only when question A21d is not "Yes".
      - predicate: not (A21e.outcome == 1)
        hint: Asked only when question A21e is not "Yes".
      - predicate: not (A21f.outcome == 1)
        hint: Asked only when question A21f is not "Yes".
      - predicate: not (A21g.outcome == 1)
        hint: Asked only when question A21g is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
  - id: b_s2_protect_recent
    title: Protective actions in the last 12 months
    items:
    - id: A21Aa
      kind: Question
      title: 'Have you done this in the last 12 months? (a: changed your routine, activities, or avoided certain places)'
      precondition:
      - predicate: A21a.outcome == 1
        hint: Asked only when question A21a is "Yes".
      - predicate: not (A21b.outcome == 1)
        hint: Asked only when question A21b is not "Yes".
      - predicate: not (A21c.outcome == 1)
        hint: Asked only when question A21c is not "Yes".
      - predicate: not (A21d.outcome == 1)
        hint: Asked only when question A21d is not "Yes".
      - predicate: not (A21e.outcome == 1)
        hint: Asked only when question A21e is not "Yes".
      - predicate: not (A21f.outcome == 1)
        hint: Asked only when question A21f is not "Yes".
      - predicate: not (A21g.outcome == 1)
        hint: Asked only when question A21g is not "Yes".
      - predicate: not (A21h.outcome == 1)
        hint: Asked only when question A21h is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21Ab
      kind: Question
      title: 'Have you done this in the last 12 months? (b: installed new locks or security bars)'
      precondition:
      - predicate: A21b.outcome == 1
        hint: Asked only when question A21b is "Yes".
      - predicate: not (A21c.outcome == 1)
        hint: Asked only when question A21c is not "Yes".
      - predicate: not (A21d.outcome == 1)
        hint: Asked only when question A21d is not "Yes".
      - predicate: not (A21e.outcome == 1)
        hint: Asked only when question A21e is not "Yes".
      - predicate: not (A21f.outcome == 1)
        hint: Asked only when question A21f is not "Yes".
      - predicate: not (A21g.outcome == 1)
        hint: Asked only when question A21g is not "Yes".
      - predicate: not (A21h.outcome == 1)
        hint: Asked only when question A21h is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21Ac
      kind: Question
      title: 'Have you done this in the last 12 months? (c: installed burglar alarms or motion detector lights)'
      precondition:
      - predicate: A21c.outcome == 1
        hint: Asked only when question A21c is "Yes".
      - predicate: not (A21d.outcome == 1)
        hint: Asked only when question A21d is not "Yes".
      - predicate: not (A21e.outcome == 1)
        hint: Asked only when question A21e is not "Yes".
      - predicate: not (A21f.outcome == 1)
        hint: Asked only when question A21f is not "Yes".
      - predicate: not (A21g.outcome == 1)
        hint: Asked only when question A21g is not "Yes".
      - predicate: not (A21h.outcome == 1)
        hint: Asked only when question A21h is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21Ad
      kind: Question
      title: 'Have you done this in the last 12 months? (d: taken a self defense course)'
      precondition:
      - predicate: A21d.outcome == 1
        hint: Asked only when question A21d is "Yes".
      - predicate: not (A21e.outcome == 1)
        hint: Asked only when question A21e is not "Yes".
      - predicate: not (A21f.outcome == 1)
        hint: Asked only when question A21f is not "Yes".
      - predicate: not (A21g.outcome == 1)
        hint: Asked only when question A21g is not "Yes".
      - predicate: not (A21h.outcome == 1)
        hint: Asked only when question A21h is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21Ae
      kind: Question
      title: 'Have you done this in the last 12 months? (e: changed your phone number)'
      precondition:
      - predicate: A21e.outcome == 1
        hint: Asked only when question A21e is "Yes".
      - predicate: not (A21f.outcome == 1)
        hint: Asked only when question A21f is not "Yes".
      - predicate: not (A21g.outcome == 1)
        hint: Asked only when question A21g is not "Yes".
      - predicate: not (A21h.outcome == 1)
        hint: Asked only when question A21h is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21Af
      kind: Question
      title: 'Have you done this in the last 12 months? (f: obtained a dog)'
      precondition:
      - predicate: A21f.outcome == 1
        hint: Asked only when question A21f is "Yes".
      - predicate: not (A21g.outcome == 1)
        hint: Asked only when question A21g is not "Yes".
      - predicate: not (A21h.outcome == 1)
        hint: Asked only when question A21h is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21Ag
      kind: Question
      title: 'Have you done this in the last 12 months? (g: obtained a gun)'
      precondition:
      - predicate: A21g.outcome == 1
        hint: Asked only when question A21g is "Yes".
      - predicate: not (A21h.outcome == 1)
        hint: Asked only when question A21h is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A21Ah
      kind: Question
      title: 'Have you done this in the last 12 months? (h: changed residence or moved)'
      precondition:
      - predicate: A21h.outcome == 1
        hint: Asked only when question A21h is "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
  - id: b_s2_routine_safety
    title: Routine safety behaviour
    items:
    - id: A22a
      kind: Question
      title: 'Do you do any of the following things to make yourself safer from crime? Do you routinely.... (Routinely means "most of the time" even if you occasionally forget.) INT: ===READ LIST=== a) carry something to defend yourself or to alert other people?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A22b
      kind: Question
      title: A22 b) lock the car doors for your personal safety when alone in a car?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A22c
      kind: Question
      title: A22 c) when alone and returning to a parked car, check the back seat for intruders before getting into the car?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A22d
      kind: Question
      title: A22 d) plan your route with safety in mind?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A22e
      kind: Question
      title: A22 e) stay at home at night because you are afraid to go out alone?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          99: Refused
    - id: A23
      kind: Question
      title: 'Is there anything else you do to increase your personal safety that I have not already mentioned? [CATI]: Length of field = 50'
      input:
        control: Textarea
        maxLength: 50
  - id: b_s2_satisfaction
    title: Satisfaction with personal safety
    items:
    - id: A24
      kind: Question
      title: In general, are you satisfied or dissatisfied with your personal safety from crime?
      input:
        control: Radio
        labels:
          1: Satisfied
          2: Dissatisfied
          3: No opinion
          99: Refused
    - id: A24A
      kind: Question
      title: Is that somewhat or very?
      precondition:
      - predicate: A24.outcome in [1, 2]
        hint: Asked only when question A24 is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          1: Somewhat
          2: Very
          99: Refused
  - id: b_s2_sentencing
    title: Sentencing scenarios
    items:
    - id: A26A
      kind: Question
      title: 'Scenario 1: If an adult offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and this is the offender''s first offence, which sentence would you consider the most appropriate, a … INT:===READ LIST==='
      precondition:
      - predicate: SCENARIO.outcome == 1
        hint: Asked only when question SCENARIO is "Scenario 1".
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A26AP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      precondition:
      - predicate: not (A26A.outcome == 3)
        hint: Asked only when question A26A is not "Non-prison sentence?".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A26Y
      kind: Question
      title: What if this were a young offender instead of an adult offender, which sentence would you consider the most appropriate, a … (The young offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and this is the offender's first offence.) INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A26YP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A27Y
      kind: Question
      title: 'Scenario 2: If a young offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and this is the offender''s first offence, which sentence would you consider the most appropriate, a … INT:===READ LIST==='
      precondition:
      - predicate: SCENARIO.outcome == 2
        hint: Asked only when question SCENARIO is "Scenario 2".
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A27YP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      precondition:
      - predicate: not (A27Y.outcome == 3)
        hint: Asked only when question A27Y is not "Non-prison sentence?".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A27A
      kind: Question
      title: What if this were an adult offender instead of a young offender, which sentence would you consider the most appropriate, a … (The adult offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and this is the offender's first offence.) INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A27AP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A28A
      kind: Question
      title: 'Scenario 3: If an adult offender is found guilty for the first time of an assault and the victim received minor injuries but did not require medical attention, which sentence would you consider the most appropriate, a … INT:===READ LIST==='
      precondition:
      - predicate: SCENARIO.outcome == 3
        hint: Asked only when question SCENARIO is "Scenario 3".
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A28AP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      precondition:
      - predicate: not (A28A.outcome == 3)
        hint: Asked only when question A28A is not "Non-prison sentence?".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A28Y
      kind: Question
      title: What if this were a young offender instead of an adult offender, which sentence would you consider the most appropriate, a … (The young offender is found guilty for the first time of an assault and the victim received minor injuries but did not require medical attention.) INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A28YP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A29Y
      kind: Question
      title: 'Scenario 4: If a young offender is found guilty for the first time of an assault and the victim received minor injuries but did not require medical attention, which sentence would you consider the most appropriate, a … INT:===READ LIST==='
      precondition:
      - predicate: SCENARIO.outcome == 4
        hint: Asked only when question SCENARIO is "Scenario 4".
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A29YP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      precondition:
      - predicate: not (A29Y.outcome == 3)
        hint: Asked only when question A29Y is not "Non-prison sentence?".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A29A
      kind: Question
      title: What if this were an adult offender instead of a young offender, which sentence would you consider the most appropriate, a … (The adult offender is found guilty for the first time of an assault and the victim received minor injuries but did not require medical attention.) INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A29AP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A30A
      kind: Question
      title: 'Scenario 5: If an adult offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and the offender was found guilty of a similar offence once before, which sentence would you consider the most appropriate, a … INT:===READ LIST==='
      precondition:
      - predicate: SCENARIO.outcome == 5
        hint: Asked only when question SCENARIO is "Scenario 5".
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A30AP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      precondition:
      - predicate: not (A30A.outcome == 3)
        hint: Asked only when question A30A is not "Non-prison sentence?".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A30Y
      kind: Question
      title: What if this were a young offender instead of an adult offender, which sentence would you consider the most appropriate, a … (The young offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and the offender was found guilty of a similar offence once before.) INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
    - id: A30YP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          98: Don't know
          99: Refused
    - id: A31Y
      kind: Question
      title: 'Scenario 6: If a young offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and the offender was found guilty of a similar offence once before, which sentence would you consider the most appropriate, a … INT:===READ LIST==='
      precondition:
      - predicate: SCENARIO.outcome == 6
        hint: Asked only when question SCENARIO is "Scenario 6".
      input:
        control: Radio
        labels:
          1: Prison sentence?
          3: Non-prison sentence?
          98: Don't know
          99: Refused
  - id: b_s3_scenario6
    title: Scenario 6 (continued)
    items:
    - id: A31YP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      precondition:
      - predicate: not (A31Y.outcome == 3)
        hint: Asked only when question A31Y is not "Non-prison sentence?".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: A31A
      kind: Question
      title: What if this were an adult offender instead of an young offender, which sentence would you consider the most appropriate, a … (The adult offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and the offender was found guilty of a similar offence once before.) INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: (1) Prison sentence?
          3: (3) Non-prison sentence?
          -1: (x) Don’t know
          -2: (r) Refused
    - id: A31AP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
  - id: b_s3_scenario7
    title: Scenario 7
    items:
    - id: A32A
      kind: Question
      title: Scenario 7 If an adult offender is found guilty of an assault and the victim received minor injuries but did not require medical attention and the offender was found guilty of a similar offence once before, which sentence would you consider the most appropriate, a … INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: (1) Prison sentence?
          3: (3) Non-prison sentence?
          -1: (x) Don’t know
          -2: (r) Refused
    - id: A32AP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      precondition:
      - predicate: not (A32A.outcome == 3)
        hint: Asked only when question A32A is not "(3) Non-prison sentence?".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: A32Y
      kind: Question
      title: What if this were a young offender instead of an adult offender, which sentence would you consider the most appropriate, a … (The young offender is found guilty of an assault and the victim received minor injuries but did not require medical attention and the offender was found guilty of a similar offence once before.) INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: (1) Prison sentence?
          3: (3) Non-prison sentence?
          -1: (x) Don’t know
          -2: (r) Refused
    - id: A32YP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
  - id: b_s3_scenario8
    title: Scenario 8
    items:
    - id: A33Y
      kind: Question
      title: Scenario 8 If a young offender is found guilty of an assault and the victim received minor injuries but did not require medical attention and the offender was found guilty of a similar offence once before, which sentence would you consider the most appropriate, a … INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: (1) Prison sentence?
          3: (3) Non-prison sentence?
          -1: (x) Don’t know
          -2: (r) Refused
    - id: A33YP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      precondition:
      - predicate: not (A33Y.outcome == 3)
        hint: Asked only when question A33Y is not "(3) Non-prison sentence?".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: A33A
      kind: Question
      title: What if this were an adult offender instead of a young offender, which sentence would you consider the most appropriate, a … (The adult offender is found guilty of an assault and the victim received minor injuries but did not require medical attention and the offender was found guilty of a similar offence once before.) INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: (1) Prison sentence?
          3: (3) Non-prison sentence?
          -1: (x) Don’t know
          -2: (r) Refused
    - id: A33AP
      kind: Question
      title: If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
  - id: b_s4_preamble
    title: Section B setup
    items:
    - id: HHROSTER_AGE
      kind: Question
      title: 'Respondent’s age from the household roster (used by CATI-B7e: respondent >=65)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: TOTB
      kind: Question
      title: 'CATI-B14e: Total the number of incidents reported in B1A, B2A, B3A, B4AA, B4BA, B4CA, B6AA, B6BA, B7A, B8AA, B8BA, B9A, B10A, B11AA, B11BA, B12A, B13A, and B14A then enter in TOTB |__|__|__|.'
      external: true
      input:
        control: Editbox
        min: 0
        max: 999
  - id: b_s4_property
    title: Property crimes
    items:
    - id: B1
      kind: Question
      title: The next questions ask about things which may have happened to you during the past 12 months. Please include acts committed by both family and non-family members. During the past 12 months, did anyone deliberately damage or destroy any property belonging to you or anyone in your household, such as a window or a fence? INT:===Record incidents of vandalism to a motor vehicle in question B6B=== (Exclude damage to the halls or elevators or to the outside of an apartment building.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B1A
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B1.outcome == 1
        hint: Asked only when question B1 is "(1) Yes".
      postcondition:
      - predicate: B1A.outcome <= 10
        hint: 'Confirm the number of times in B1A: more than 10 incidents of vandalism (B1) must be confirmed.'
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B2
      kind: Question
      title: (Excluding incidents already mentioned,) during the past 12 months, did anyone take or try to take something from you by force or threat of force?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B2A
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B2.outcome == 1
        hint: Asked only when question B2 is "(1) Yes".
      postcondition:
      - predicate: B2A.outcome <= 10
        hint: Confirm the number of times in B2A (more than 10 incidents reported in B2).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B3
      kind: Question
      title: (Other than the incidents already mentioned,) during the past 12 months, did anyone illegally break into or attempt to break into your residence or any other building on your property?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B3A
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B3.outcome == 1
        hint: Asked only when question B3 is "(1) Yes".
      postcondition:
      - predicate: B3A.outcome <= 10
        hint: Confirm the number of times in B3A (more than 10 break-ins reported in B3).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B4A
      kind: Question
      title: (Other than the incidents already mentioned,) was anything of yours stolen during the past 12 months from the things usually kept outside your home, such as yard furniture?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B4AA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B4A.outcome == 1
        hint: Asked only when question B4A is "(1) Yes".
      postcondition:
      - predicate: B4AA.outcome <= 10
        hint: Confirm the number of times in B4AA (more than 10 thefts reported in B4A).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B4B
      kind: Question
      title: (Other than the incidents already mentioned,) was anything of yours stolen during the past 12 months from your place of work, from school or from a public place, such as a restaurant? INT:===Probe to ensure property taken was their own personal property and not property belonging to their work place or school.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B4BA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B4B.outcome == 1
        hint: Asked only when question B4B is "(1) Yes".
      postcondition:
      - predicate: B4BA.outcome <= 10
        hint: Confirm the number of times in B4BA (more than 10 thefts reported in B4B).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B4C
      kind: Question
      title: (Other than the incidents already mentioned,) was anything of yours stolen during the past 12 months from a hotel, vacation home, cottage, car, truck or while travelling?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B4CA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B4C.outcome == 1
        hint: Asked only when question B4C is "(1) Yes".
      postcondition:
      - predicate: B4CA.outcome <= 10
        hint: Confirm the number of times in B4CA (more than 10 thefts reported in B4C).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s4_vehicle_screen
    title: Motor vehicle screening
    items:
    - id: B5
      kind: Question
      title: During the past 12 months, did you or anyone in your household have a motor vehicle, such as a car, truck, motorcycle, etc.?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: CATI_B5e
      kind: Question
      title: 'Soft edit: If B5 = (3) then interviewer ask: I would like to confirm that you or no one else in your household owns or leases a car or another motor vehicle?'
      precondition:
      - predicate: B5.outcome == 3
        hint: Asked only when question B5 is "(3) No".
      input:
        control: Radio
        labels:
          1: (1) Accept
          3: (3) Correct B5
  - id: b_s4_vehicle
    title: Motor vehicle crimes
    precondition:
    - predicate: B5.outcome == 1
      hint: Asked only when question B5 is "(1) Yes".
    - predicate: not (CATI_B5e.outcome == 1)
      hint: Asked only when question CATI-B5e is not "(1) Accept".
    items:
    - id: B6A
      kind: Question
      title: (Other than the incidents already mentioned,) did anyone steal or try to steal one of these vehicles or a part of one of them, such as a battery, hubcap or radio?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B6AA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B6A.outcome == 1
        hint: Asked only when question B6A is "(1) Yes".
      postcondition:
      - predicate: B6AA.outcome <= 10
        hint: Confirm the number of times in B6AA (more than 10 vehicle thefts reported in B6A).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B6B
      kind: Question
      title: (Other than the incidents already mentioned,) did anyone deliberately damage one of these vehicles, such as slashing tires?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B6BA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B6B.outcome == 1
        hint: Asked only when question B6B is "(1) Yes".
      postcondition:
      - predicate: B6BA.outcome <= 10
        hint: Confirm the number of times in B6BA (more than 10 incidents reported in B6B).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s4_other_theft
    title: Other theft
    items:
    - id: B7
      kind: Question
      title: (Excluding the incidents already mentioned,) during the past 12 months, did anyone steal or try to steal anything else that belonged to you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B7A
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B7.outcome == 1
        hint: Asked only when question B7 is "(1) Yes".
      postcondition:
      - predicate: B7A.outcome <= 10
        hint: Confirm the number of times in B7A (more than 10 thefts reported in B7).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: CATI_B7e
      kind: Question
      title: Verify household roster - if respondent >=65 Go to B11A.
      input:
        control: Textarea
  - id: b_s4_attacks_under65
    title: Attacks and sexual offences (respondent under 65)
    precondition:
    - predicate: HHROSTER_AGE.outcome < 65
    items:
    - id: B8A
      kind: Question
      title: Now I'm going to ask you about being attacked in the past 12 months. An attack can be anything from being hit, slapped, pushed or grabbed, to being shot or beaten. (Excluding incidents already mentioned, and) excluding acts committed by current or previous spouses or common-law partners, were you attacked by anyone?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B8AA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B8A.outcome == 1
        hint: Asked only when question B8A is "(1) Yes".
      postcondition:
      - predicate: B8AA.outcome <= 10
        hint: Confirm the number of times in B8AA (more than 10 attacks reported in B8A).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B8B
      kind: Question
      title: (Other than the incidents already mentioned, and) again excluding acts committed by current or previous spouses or common-law partners, did anyone THREATEN to hit or attack you, or threaten you with a weapon?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B8BA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B8B.outcome == 1
        hint: Asked only when question B8B is "(1) Yes".
      postcondition:
      - predicate: B8BA.outcome <= 10
        hint: Confirm the number of times in B8BA (more than 10 threats reported in B8B).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B9
      kind: Question
      title: (Excluding incidents already mentioned,) during the past 12 months, has anyone forced you or attempted to force you into any unwanted sexual activity, by threatening you, holding you down or hurting you in some way? This includes acts by family and non-family but excludes acts by current or previous spouses or common-law partners. Remember that all information provided is strictly confidential.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B9A
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B9.outcome == 1
        hint: Asked only when question B9 is "(1) Yes".
      postcondition:
      - predicate: B9A.outcome <= 10
        hint: Confirm the number of times in B9A (more than 10 incidents reported in B9).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B10
      kind: Question
      title: (Apart from what you have told me,) during the past 12 months, has anyone ever touched you against your will in any sexual way? By this I mean anything from unwanted touching or grabbing, to kissing or fondling. Again, please exclude acts by current or previous spouses or common-law partners.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B10A
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B10.outcome == 1
        hint: Asked only when question B10 is "(1) Yes".
      postcondition:
      - predicate: B10A.outcome <= 10
        hint: Confirm the number of times in B10A (more than 10 incidents reported in B10).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s4_attacks_65plus
    title: Attacks and sexual offences (respondent 65 or older)
    precondition:
    - predicate: HHROSTER_AGE.outcome >= 65
    items:
    - id: B11A
      kind: Question
      title: Now I'm going to ask you about being attacked in the past 12 months. An attack can be anything from being hit, slapped, pushed or grabbed, to being shot or beaten. (Excluding incidents already mentioned, and) excluding acts committed by current or previous spouses or common-law partners, children, or caregivers, were you attacked by anyone?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B11AA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B11A.outcome == 1
        hint: Asked only when question B11A is "(1) Yes".
      postcondition:
      - predicate: B11AA.outcome <= 10
        hint: Confirm the number of times in B11AA (more than 10 attacks reported in B11A).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B11B
      kind: Question
      title: (Other than the incidents already mentioned, and) again excluding acts committed by current or previous spouses or common-law partners, children or caregivers, did anyone threaten to hit or attack you, or threaten you with a weapon?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B11BA
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B11B.outcome == 1
        hint: Asked only when question B11B is "(1) Yes".
      postcondition:
      - predicate: B11BA.outcome <= 10
        hint: Confirm the number of times in B11BA (more than 10 threats reported in B11B).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B12
      kind: Question
      title: (Excluding incidents already mentioned,) during the past 12 months, has anyone forced you or attempted to force you into any unwanted sexual activity, by threatening you, holding you down or hurting you in some way? This includes acts by family and non-family but excludes acts by current or previous spouses or common-law partners or caregivers. Remember that all information provided is strictly confidential.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B12A
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B12.outcome == 1
        hint: Asked only when question B12 is "(1) Yes".
      postcondition:
      - predicate: B12A.outcome <= 10
        hint: Confirm the number of times in B12A (more than 10 incidents reported in B12).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: B13
      kind: Question
      title: (Apart from what you have told me,) during the past 12 months, has anyone ever touched you against your will in any sexual way? By this I mean anything from unwanted touching or grabbing, to kissing or fondling. Again, please exclude acts by current or previous spouses or common-law partners or caregivers.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
    - id: B13A
      kind: Question
      title: How many times did this happen?
      precondition:
      - predicate: B13.outcome == 1
        hint: Asked only when question B13 is "(1) Yes".
      postcondition:
      - predicate: B13A.outcome <= 10
        hint: Confirm the number of times in B13A (more than 10 incidents reported in B13).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s4_other_crimes_screen
    title: Other crimes
    items:
    - id: B14
      kind: Question
      title: Were there any other crimes which happened to you during the past 12 months, which may or may not have been reported to the police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -1: (x) Don’t know
          -2: (r) Refused
  - id: b_s4_other_crimes_detail
    title: 'Other crimes: details'
    precondition:
    - predicate: B14.outcome == 1
      hint: Asked only when question B14 is "(1) Yes".
    items:
    - id: B14S
      kind: Question
      title: 'What were these crimes? (CATI: Length of field = 99)'
      input:
        control: Textarea
        maxLength: 99
    - id: B14A
      kind: Question
      title: How many were there?
      postcondition:
      - predicate: B14A.outcome <= 10
        hint: Confirm the number in B14A (more than 10 other crimes reported in B14).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s4_verify
    title: Section B verification
    precondition:
    - predicate: TOTB.outcome > 0
    items:
    - id: CATI_B14e_VERIFY
      kind: Question
      title: 'CATI Section B Verification Screen: I would like to confirm the information you have given me. You said you were a victim of crime on [insert TOTB] (separate) occasion(s) in the past 12 months. Is this correct?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
  - id: b_s5_preamble
    title: Section C setup
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: MARSTAT_2
      kind: Question
      title: Respondent’s current marital status from the household roster (used by CATI-C0e, CATI-E0e, CATI-F0e)
      external: true
      input:
        control: Radio
        labels:
          1: Married or living common-law, or same-sex partner
          2: Widowed, divorced or separated
          3: Other (e.g. single, never married)
  - id: b_s5_partner_start
    title: Start of the relationship
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: MARSTAT_2.outcome == 1
      hint: Asked only when question MARSTAT is "Married or living common-law, or same-sex partner".
    items:
    - id: C1Y
      kind: Question
      title: 'Now I would like to ask you about some things concerning your spouse/partner. We’re interested in knowing how long you’ve been married or living together/living together. In what year were you married or started living together/did you start living together? INT:===If the couple lived common-law before getting married, ask the respondent when they started living together. We want to know the total length of time that the couple has lived together.=== Year |__|__|__|__| [CATI: 1920-1999]  (Enter -1 for Don’t know, -2 for Refused)'
      input:
        control: Editbox
        min: -2
        max: 1999
    - id: C1M
      kind: Question
      title: 'In what month? Month |__|__| [CATI: 1-12]  (Enter -1 for Don’t know, -2 for Refused)'
      precondition:
      - predicate: C1Y.outcome >= 1994
      - predicate: not (C1Y.outcome < 1994 or C1Y.outcome in [-1, -2])
      input:
        control: Editbox
        min: -2
        max: 12
  - id: b_s5_statements
    title: Statements describing spouse/partner
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: C2
      kind: Question
      title: I’m going to read a list of statements that some people have used to describe their spouse/partner. I’d like you to tell me whether or not each statement describes your spouse/partner. (Please remember that all information provided is strictly confidential.) He/She tries to limit your contact with family or friends.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: C3
      kind: Question
      title: He/She puts you down or calls you names to make you feel bad. (Does this statement describe your spouse/partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: C4
      kind: Question
      title: He/She is jealous and doesn’t want you to talk to other men/women. (Does this statement describe your spouse/partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: C5
      kind: Question
      title: He/She harms, or threatens to harm, someone close to you. (Does this statement describe your spouse/partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: C6
      kind: Question
      title: He/She demands to know who you are with and where you are at all times. (Does this statement describe your spouse/partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: C7
      kind: Question
      title: He/She damages or destroys your possessions or property. (Does this statement describe your spouse/partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: C8
      kind: Question
      title: He/She prevents you from knowing about or having access to the family income, even if you ask. (Does this statement describe your spouse/partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
  - id: b_s6_screen
    title: 'SECTION D: PHYSICAL AND SEXUAL VIOLENCE BY A SPOUSE/PARTNER'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: D1
      kind: Question
      title: It is important to hear from people themselves if we are to understand the serious problem of violence in the home. I’m going to ask you ten short questions and I’d like you to tell me whether, in the past 5 years, your CURRENT spouse/partner has done any of the following to you. Your responses are important whether or not you have had any of these experiences. Remember that all information provided is strictly confidential. During the past 5 years, has your current spouse/partner THREATENED to hit you with his/her fist or anything else that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D2
      kind: Question
      title: (During the past 5 years,) has he/she THROWN anything at you that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D3
      kind: Question
      title: (During the past 5 years,) has he/she pushed, grabbed or shoved you in a way that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D4
      kind: Question
      title: (During the past 5 years,) has he/she slapped you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D5
      kind: Question
      title: (During the past 5 years,) has he/she kicked you, bit you, or hit you with his/her fist?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D6
      kind: Question
      title: (During the past 5 years,) has he/she hit you with something that could have hurt you? (Do not include hitting with fist)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D7
      kind: Question
      title: (During the past 5 years,) has he/she beaten you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D8
      kind: Question
      title: (During the past 5 years,) has he/she choked you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D9
      kind: Question
      title: (During the past 5 years,) has he/she USED or THREATENED TO USE a gun or knife on you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D10
      kind: Question
      title: (During the past 5 years,) has he/she forced you into any unwanted sexual activity, by threatening you, holding you down, or hurting you in some way?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
  - id: b_s6_more_than_once
    title: Violence on more than one occasion
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: D11
      kind: Question
      title: You said yes to at least one of the previous ten questions concerning violence. During the past 5 years, has he/she been violent towards you on more than one occasion?
      precondition:
      - predicate: D1.outcome == 1 or D2.outcome == 1 or D3.outcome == 1 or D4.outcome == 1 or D5.outcome == 1 or D6.outcome == 1 or D7.outcome == 1 or D8.outcome == 1 or D9.outcome == 1 or D10.outcome == 1
        hint: Asked only when at least one of D1 to D10 is "(1) Yes".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
  - id: b_s6_frequency
    title: Frequency of violent incidents
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: D11.outcome == 1
      hint: Asked only when question D11 is "(1) Yes".
    - predicate: not (D11.outcome in [3, -2])
      hint: Asked only when question D11 is none of "(3) No", "(r) Refused".
    items:
    - id: D12
      kind: Question
      title: How many different times did these things happen?
      input:
        control: Dropdown
        labels:
          2: (2) Two
          3: (3) Three
          4: (4) Four
          5: (5) Five
          6: (6) Six
          7: (7) Seven
          8: (8) Eight
          9: (9) Nine
          10: (10) Ten
          11: (11) More than ten
          -1: (x) Don’t know
          -2: (r) Refused
    - id: D13
      kind: Question
      title: 'How many of these were in the past 12 months? |__|__| [CATI: 0-99]'
      postcondition:
      - predicate: D12.outcome in [11, -1, -2] or D13.outcome < 0 or D13.outcome <= D12.outcome
        hint: 'The number of incidents in the past 12 months (D13) cannot exceed the total number of incidents (D12): correct D12 or D13.'
      input:
        control: Editbox
        min: -2
        max: 99
        right: (0-99; -1 = (x) Don’t know, -2 = (r) Refused)
  - id: b_s6_recent_year
    title: 'Most recent incident: year'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: D14
      kind: Question
      title: 'When did this happen (the most recent happen)? Year |__|__|__|__| [CATI: 1994-1999]'
      input:
        control: Editbox
        min: -2
        max: 1999
        right: (1994-1999; -1 = (x) Don’t know, -2 = (r) Refused)
  - id: b_s6_timing_since_1994
    title: 'Most recent incident: month and relationship status before marriage'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (C1Y.outcome is not None and C1Y.outcome >= 0 and C1Y.outcome < 1994)
      hint: Not asked when the relationship began before 1994 (C1Y).
    items:
    - id: D14M
      kind: Question
      title: 'Month |__|__| [CATI: 1-12] (month part of D14; printed without its own id)'
      input:
        control: Editbox
        min: -2
        max: 12
        right: (1-12; -1 = (x) Don’t know, -2 = (r) Refused)
    - id: D15A
      kind: Question
      title: Did this (any of these) incident(s) in the past 5 years happen before you were married or living common-law?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
  - id: b_s6_relationship_status
    title: Incidents by relationship status
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: D15B
      kind: Question
      title: Did this (any of these) incident(s) in the past 5 years happen while you were married or living common-law?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: D15C
      kind: Question
      title: Did this (any of these) incident(s) in the past 5 years happen while you were temporarily separated?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) No, never separated
          -2: (r) Refused
  - id: b_s7_previous
    title: Previous relationships and contact with ex-partners
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: E0A
      kind: Question
      title: Have you ever been married or in a common-law relationship? (By common-law we mean partners living together as a couple without being legally married).
      precondition:
      - predicate: MARSTAT_2.outcome == 3
        hint: Asked only when question MARSTAT is "Other (e.g. single, never married)".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E0AA
      kind: Question
      title: In the past 5 years, have you had any contact with any previous partner? (Contact includes receiving letters or telephone calls).
      precondition:
      - predicate: not (E0A.outcome in [3, -2])
        hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E1
      kind: Question
      title: Have you ever been in any other marriage or common-law relationship with a person other than your current spouse/partner?
      precondition:
      - predicate: MARSTAT_2.outcome == 1
        hint: Asked only when question MARSTAT is "Married or living common-law, or same-sex partner".
      - predicate: not (E0A.outcome in [3, -2])
        hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
      - predicate: not (E0AA.outcome in [3, -2])
        hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
      - predicate: not (E0AA.outcome == 1)
        hint: Asked only when question E0AA is not "(1) Yes".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E1A
      kind: Question
      title: In the past 5 years, have you had any contact with any previous partner? (Contact includes receiving letters or telephone calls).
      precondition:
      - predicate: E1.outcome == 1
        hint: Asked only when question E1 is "(1) Yes".
      - predicate: not (E0A.outcome in [3, -2])
        hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
      - predicate: not (E0AA.outcome in [3, -2])
        hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
      - predicate: not (E0AA.outcome == 1)
        hint: Asked only when question E0AA is not "(1) Yes".
      - predicate: not (E1.outcome in [3, -2])
        hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
  - id: b_s7_controlling
    title: Controlling behaviours of the ex-partner
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    items:
    - id: E2
      kind: Question
      title: He/She tried to limit your contact with family or friends.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E3
      kind: Question
      title: He/She put you down or called you names to make you feel bad. (Does this statement describe your ex-partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E4
      kind: Question
      title: He/She was jealous and didn’t want you to talk to other men/women. (Does this statement describe your ex-partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E5
      kind: Question
      title: He/She harmed, or threatened to harm, someone close to you. (Does this statement describe your ex-partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E6
      kind: Question
      title: He/She demanded to know who you were with and where you were at all times. (Does this statement describe your ex-partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E7
      kind: Question
      title: He/She damaged or destroyed your possessions or property. (Does this statement describe your ex-partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: E8
      kind: Question
      title: He/She prevented you from knowing about or having access to the family income, even if you asked. (Does this statement describe your ex-partner?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
  - id: b_s8_ex_partner_violence
    title: 'SECTION F: PHYSICAL AND SEXUAL VIOLENCE BY AN EX-PARTNER'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    items:
    - id: F1
      kind: Question
      title: During the past 5 years, did your previous partner THREATEN to hit you with his/her fist or anything else that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: F2
      kind: Question
      title: (During the past 5 years,) did he/she THROW anything at you that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: F3
      kind: Question
      title: (During the past 5 years,) did he/she push, grab, or shove you in a way that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
    - id: F4
      kind: Question
      title: (During the past 5 years,) did he/she slap you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          -2: (r) Refused
  - id: b_s9_violence
    title: Violence by ex-partner (continued)
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    items:
    - id: F5
      kind: Question
      title: (During the past 5 years,) did he/she kick you, bite you, or hit you with his/her fist?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: F6
      kind: Question
      title: (During the past 5 years,) did he/she hit you with something that could have hurt you? (Do not include hitting with fist)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: F7
      kind: Question
      title: (During the past 5 years,) did he/she beat you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: F8
      kind: Question
      title: (During the past 5 years,) did he/she choke you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: F9
      kind: Question
      title: (During the past 5 years,) did he/she USE or THREATEN TO USE a gun or knife on you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: F10
      kind: Question
      title: (During the past 5 years,) did he/she force you into any unwanted sexual activity, by threatening you, holding you down, or hurting you in some way?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s9_more_than_once
    title: Violence on more than one occasion
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    - predicate: not (F1.outcome != 1 and F2.outcome != 1 and F3.outcome != 1 and F4.outcome != 1 and F5.outcome != 1 and F6.outcome != 1 and F7.outcome != 1 and F8.outcome != 1 and F9.outcome != 1 and F10.outcome != 1)
      hint: Asked only when at least one violence question was answered Yes.
    items:
    - id: F11
      kind: Question
      title: You said yes to at least one of the previous ten questions concerning violence. During the past 5 years, was he/she violent towards you on more than one occasion?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to F14]
          99: (r) Refused [Go to F14]
  - id: b_s9_repeat
    title: Number of incidents
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    - predicate: not (F1.outcome != 1 and F2.outcome != 1 and F3.outcome != 1 and F4.outcome != 1 and F5.outcome != 1 and F6.outcome != 1 and F7.outcome != 1 and F8.outcome != 1 and F9.outcome != 1 and F10.outcome != 1)
      hint: Asked only when at least one violence question was answered Yes.
    - predicate: not (F11.outcome in [3, 99])
      hint: Asked only when question F11 is none of "(3) No [Go to F14]", "(r) Refused [Go to F14]".
    items:
    - id: F12
      kind: Question
      title: How many different times did these things happen?
      input:
        control: Dropdown
        labels:
          2: (2) Two
          3: (3) Three
          4: (4) Four
          5: (5) Five
          6: (6) Six
          7: (7) Seven
          8: (8) Eight
          9: (9) Nine
          10: (10) Ten
          11: (11) More than ten
          98: (x) Don’t know
          99: (r) Refused
    - id: F13
      kind: Question
      title: 'How many of these were in the past 12 months? [CATI: 0-99] (x) Don’t know (r) Refused'
      postcondition:
      - predicate: F13.outcome in [98, 99] or F12.outcome in [11, 98, 99] or F13.outcome <= F12.outcome
        hint: The number of incidents in the past 12 months (F13) cannot exceed the total number of incidents (F12). Correct F12 or F13.
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s9_timing
    title: Timing and setting of the violence
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    - predicate: not (F1.outcome != 1 and F2.outcome != 1 and F3.outcome != 1 and F4.outcome != 1 and F5.outcome != 1 and F6.outcome != 1 and F7.outcome != 1 and F8.outcome != 1 and F9.outcome != 1 and F10.outcome != 1)
      hint: Asked only when at least one violence question was answered Yes.
    items:
    - id: F14
      kind: Question
      title: 'When did this happen (the most recent happen)? Year |__|__|__|__| [CATI: 1994-1999] (x) Don’t know (r) Refused'
      input:
        control: Editbox
        min: 1994
        max: 1999
    - id: F14_Month
      kind: Question
      title: 'When did this happen (the most recent happen)? Month |__|__| [CATI: 1-12] (x) Don’t know (r) Refused'
      input:
        control: Editbox
        min: 1
        max: 12
    - id: F15
      kind: Question
      title: Did the(any of the) violence happen while you were living together?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s9_split
    title: Violence after the split-up
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    - predicate: not (F1.outcome != 1 and F2.outcome != 1 and F3.outcome != 1 and F4.outcome != 1 and F5.outcome != 1 and F6.outcome != 1 and F7.outcome != 1 and F8.outcome != 1 and F9.outcome != 1 and F10.outcome != 1)
      hint: Asked only when at least one violence question was answered Yes.
    - predicate: not (F11.outcome == 3 and F15.outcome == 1)
      hint: Not asked when the violence happened only while living together.
    items:
    - id: F16
      kind: Question
      title: Did any of the violence happen after you split up?
      postcondition:
      - predicate: not (F15.outcome == 3 and F16.outcome == 3)
        hint: You said the violence did not happen while living together (F15) nor after the split-up (F16). Correct F15 or F16, or accept as is.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Did not separate, partner died [Go to G0]
          98: (x) Don’t know [Go to G0]
          99: (r) Refused [Go to G0]
  - id: b_s9_after_split
    title: Checks and follow-up after the split-up
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    - predicate: not (F1.outcome != 1 and F2.outcome != 1 and F3.outcome != 1 and F4.outcome != 1 and F5.outcome != 1 and F6.outcome != 1 and F7.outcome != 1 and F8.outcome != 1 and F9.outcome != 1 and F10.outcome != 1)
      hint: Asked only when at least one violence question was answered Yes.
    - predicate: not (F11.outcome == 3 and F15.outcome == 1)
      hint: Not asked when the violence happened only while living together.
    - predicate: not (F16.outcome in [5, 98, 99])
      hint: Asked only when question F16 is none of "(5) Did not separate, partner died [Go to G0]", "(x) Don’t know [Go to G0]", "(r) Refused [Go to G0]".
    - predicate: not (F16.outcome in [1, 3] and not (F15.outcome == 1 and F16.outcome == 1) and not (F15.outcome == 3 and F16.outcome == 3))
      hint: Not asked when the F15 and F16 answers are consistent.
    items:
    - id: F16_ERR
      kind: Question
      title: 'CATI Error Screen: You said that during the past 5 years your ex-partner was violent towards you. You said that it didn’t happen while you were living together or after you split up. Is this correct?'
      precondition:
      - predicate: F15.outcome == 3 and F16.outcome == 3
        hint: Asked only when F15 and F16 are both No.
      - predicate: not (F15.outcome == 1 and F16.outcome == 1)
        hint: Not asked when F15 and F16 are both Yes.
      input:
        control: Radio
        labels:
          1: (1) Correct F15
          2: (2) Correct F16
          3: (3) Accept as is [Go to G0]
    - id: F17
      kind: Question
      title: Do you think it increased after you split up?
      precondition:
      - predicate: not (F16_ERR.outcome == 3)
        hint: Asked only when question F16-ERR is not "(3) Accept as is [Go to G0]".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s10_preamble
    title: 'Section G: household roster inputs'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (E0A.outcome in [3, -2])
      hint: Asked only when question E0A is none of "(3) No", "(r) Refused".
    - predicate: not (E0AA.outcome in [3, -2])
      hint: Asked only when question E0AA is none of "(3) No", "(r) Refused".
    - predicate: not (E1.outcome in [3, -2])
      hint: Asked only when question E1 is none of "(3) No", "(r) Refused".
    - predicate: not (E1A.outcome in [3, -2])
      hint: Asked only when question E1A is none of "(3) No", "(r) Refused".
    - predicate: not (F1.outcome != 1 and F2.outcome != 1 and F3.outcome != 1 and F4.outcome != 1 and F5.outcome != 1 and F6.outcome != 1 and F7.outcome != 1 and F8.outcome != 1 and F9.outcome != 1 and F10.outcome != 1)
      hint: Asked only when at least one of F1 to F10 is answered Yes.
    - predicate: not (F11.outcome == 3 and F15.outcome == 1)
      hint: Not asked when F11 is No and F15 is Yes.
    - predicate: not (F16.outcome in [5, 98, 99])
      hint: Asked only when question F16 is none of "(5) Did not separate, partner died [Go to G0]", "(x) Don’t know [Go to G0]", "(r) Refused [Go to G0]".
    - predicate: not (F16.outcome in [1, 3] and not (F15.outcome == 1 and F16.outcome == 1) and not (F15.outcome == 3 and F16.outcome == 3))
      hint: Not asked when F16 is inconsistent with F15.
    - predicate: not (F16_ERR.outcome == 3)
      hint: Asked only when question F16-ERR is not "(3) Accept as is [Go to G0]".
    items:
    - id: ROSTER_AGE
      kind: Question
      title: Respondent’s age, from the household roster (read by CATI-G0e and CATI-K16e)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: ROSTER_CHILD_IN_HH
      kind: Question
      title: Respondent is living with child(children), from the household roster (read by CATI-G0e)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
    - id: ROSTER_PARTNER
      kind: Question
      title: 'Respondent’s current marital status from the household roster: married or living common-law or same-sex partner (read by CATI-H0e and CATI-K0e)'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
  - id: b_s10_stamp
    title: 'Section G: time stamp'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: G0
      kind: Question
      title: Date / Time stamp
      input:
        control: Textarea
  - id: b_s10_children
    title: 'Section G: contact with children'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (ROSTER_AGE.outcome < 65)
      hint: Asked only of respondents aged 65 or older.
    - predicate: not (ROSTER_AGE.outcome >= 65 and ROSTER_CHILD_IN_HH.outcome == 1)
      hint: Not asked when the respondent is 65 or older and lives with a child.
    items:
    - id: G1
      kind: Question
      title: Have you ever had any children? Include birth, step and adopted children.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to J0]
          99: (r) Refused [Go to J0]
    - id: G2
      kind: Question
      title: During the past 5 years, how often did you have contact with any of your children? (Contact includes receiving letters or telephone calls). INT:===READ LIST===
      precondition:
      - predicate: not (G1.outcome in [3, 99])
        hint: Asked only when question G1 is none of "(3) No [Go to J0]", "(r) Refused [Go to J0]".
      input:
        control: Radio
        labels:
          1: (1) Daily
          2: (2) At least once a week
          3: (3) At least once a month
          4: (4) Less than once a month
          5: (5) Not at all [Go to J0]
          6: (6) All children deceased [Go to J0]
          99: (r) Refused [Go to J0]
  - id: b_s10_statements
    title: 'Section G: emotional and financial abuse by children'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (ROSTER_AGE.outcome < 65)
      hint: Asked only of respondents aged 65 or older.
    - predicate: not (G1.outcome in [3, 99])
      hint: Asked only when question G1 is none of "(3) No [Go to J0]", "(r) Refused [Go to J0]".
    - predicate: not (G2.outcome in [5, 6, 99])
      hint: Asked only when question G2 is none of "(5) Not at all [Go to J0]", "(6) All children deceased [Go to J0]", "(r) Refused [Go to J0]".
    items:
    - id: G3
      kind: Question
      title: Now I’m going to ask you about some things that may have happened with your children. I’m going to read a list of statements that some people have used to describe their children. I’d like you to tell me whether or not each statement describes any of them. (Please remember that all information provided is strictly confidential.) They try to limit your contact with family or friends.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: G4
      kind: Question
      title: They put you down or call you names to make you feel bad. (Does this statement describe any of your children?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: G5
      kind: Question
      title: They damage or destroy your possessions or property. (Does this statement describe any of your children?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: G6
      kind: Question
      title: They harm, or threaten to harm, someone close to you. (Does this statement describe any of your children?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: G8
      kind: Question
      title: They prevent you from knowing about or having access to your income, even if you ask. (Does this statement describe any of your children?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: G9
      kind: Question
      title: They try to force you to relinquish control over your finances when you don’t want to. (Does this statement describe any of your children?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: G10
      kind: Question
      title: They try to force you to give up something of value when you don’t want to. (Does this statement describe any of your children?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: G11
      kind: Question
      title: They try to force you to change your Last Will and Testament or try to obtain Power of Attorney over your finances when you don’t want them to. (Does this statement describe any of your children?) (By power of attorney we mean a legal document which gives someone control over your finances and permits that person to write cheques or withdraw money from your bank account.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: G12
      kind: Question
      title: You said yes to one of the previous statements describing your child/children. Was it a son or a daughter that one of the previous statements describes?
      precondition:
      - predicate: not (G3.outcome != 1 and G4.outcome != 1 and G5.outcome != 1 and G6.outcome != 1 and G8.outcome != 1 and G9.outcome != 1 and G10.outcome != 1 and G11.outcome != 1)
        hint: Asked only when at least one of G3 to G11 is answered Yes.
      input:
        control: Radio
        labels:
          1: (1) Son(s)
          2: (2) Daughter(s)
          3: (3) Both
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s11_screen
    title: 'SECTION H: PHYSICAL VIOLENCE BY CHILDREN'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (ROSTER_AGE.outcome < 65)
      hint: Asked only when the respondent's age is 65 or older.
    - predicate: not (G1.outcome in [3, 99])
      hint: Asked only when question G1 is none of "(3) No [Go to J0]", "(r) Refused [Go to J0]".
    - predicate: not (G2.outcome in [5, 6, 99])
      hint: Asked only when question G2 is none of "(5) Not at all [Go to J0]", "(6) All children deceased [Go to J0]", "(r) Refused [Go to J0]".
    items:
    - id: H0
      kind: Question
      title: Date / Time stamp
      input:
        control: Textarea
    - id: H1
      kind: Question
      title: During the past 5 years, have any of your children THREATENED to hit you with their fist or anything else that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: H2
      kind: Question
      title: (During the past 5 years,) have any of your children THROWN anything at you that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: H3
      kind: Question
      title: (During the past 5 years,) have they pushed, grabbed, or shoved you in a way that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: H4
      kind: Question
      title: (During the past 5 years,) have they slapped you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: H5
      kind: Question
      title: (During the past 5 years,) have any of your children kicked you, bit you, or hit you with their fist?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: H6
      kind: Question
      title: (During the past 5 years,) have they hit you with something that could have hurt you? (Do not include hitting with fist)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: H7
      kind: Question
      title: (During the past 5 years,) have they beaten you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: H8
      kind: Question
      title: (During the past 5 years,) have any of your children choked you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: H9
      kind: Question
      title: (During the past 5 years,) have they USED or THREATENED TO USE a gun or knife on you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s11_incidents
    title: 'Violence by children: frequency and timing'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (ROSTER_AGE.outcome < 65)
      hint: Asked only when the respondent's age is 65 or older.
    - predicate: not (G1.outcome in [3, 99])
      hint: Asked only when question G1 is none of "(3) No [Go to J0]", "(r) Refused [Go to J0]".
    - predicate: not (G2.outcome in [5, 6, 99])
      hint: Asked only when question G2 is none of "(5) Not at all [Go to J0]", "(6) All children deceased [Go to J0]", "(r) Refused [Go to J0]".
    - predicate: not (H1.outcome != 1 and H2.outcome != 1 and H3.outcome != 1 and H4.outcome != 1 and H5.outcome != 1 and H6.outcome != 1 and H7.outcome != 1 and H8.outcome != 1 and H9.outcome != 1)
      hint: Asked only when at least one of H1 to H9 was answered Yes.
    items:
    - id: H10
      kind: Question
      title: During the past 5 years, have any of your children been violent towards you on more than one occasion?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to H13]
          99: (r) Refused [Go to H13]
    - id: H11
      kind: Question
      title: How many different times did these things happen?
      precondition:
      - predicate: not (H10.outcome in [3, 99])
        hint: Asked only when question H10 is none of "(3) No [Go to H13]", "(r) Refused [Go to H13]".
      input:
        control: Dropdown
        labels:
          2: (2) Two
          3: (3) Three
          4: (4) Four
          5: (5) Five
          6: (6) Six
          7: (7) Seven
          8: (8) Eight
          9: (9) Nine
          10: (10) Ten
          11: (11) More than ten
          98: (x) Don’t know
          99: (r) Refused
    - id: H12
      kind: Question
      title: 'How many of these were in the past 12 months? [CATI: 0-99] (x) Don’t know (r) Refused'
      precondition:
      - predicate: not (H10.outcome in [3, 99])
        hint: Asked only when question H10 is none of "(3) No [Go to H13]", "(r) Refused [Go to H13]".
      postcondition:
      - predicate: H12.outcome in [98, 99] or H11.outcome in [11, 98, 99] or H12.outcome <= H11.outcome
        hint: The number of incidents in the past 12 months (H12) cannot exceed the total number of incidents (H11). Correct H11 or H12.
      input:
        control: Editbox
        min: 0
        max: 99
    - id: H13
      kind: Question
      title: 'When did this happen (the most recent happen)? Year |__|__|__|__| [CATI: 1994-1999] (x) Don’t know (r) Refused'
      input:
        control: Editbox
        min: 1994
        max: 1999
    - id: H13_Month
      kind: Question
      title: 'When did this happen (the most recent happen)? Month |__|__| [CATI: 1-12] (x) Don’t know (r) Refused'
      input:
        control: Editbox
        min: 1
        max: 12
  - id: b_s12_screen
    title: 'SECTION J: EMOTIONAL AND FINANCIAL ABUSE BY A CAREGIVER'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (ROSTER_AGE.outcome < 65)
      hint: Asked only when the respondent is not under 65.
    items:
    - id: J0
      kind: Question
      title: Date / Time stamp
      input:
        control: Textarea
    - id: J1
      kind: Question
      title: (Excluding your spouse/partner/ex-partner/children) in the past 5 years, has a caregiver come into your home to assist you with everyday activities or to provide care? By this I mean anyone, either paid or unpaid, who provided you with assistance or healthcare in your home. This includes meal preparation, personal care or medical assistance.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to K15]
          99: (r) Refused [Go to K15]
  - id: b_s12_caregiver_abuse
    title: Caregiver abuse statements
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (ROSTER_AGE.outcome < 65)
      hint: Asked only when the respondent is not under 65.
    - predicate: not (J1.outcome in [3, 99])
      hint: Asked only when question J1 is none of "(3) No [Go to K15]", "(r) Refused [Go to K15]".
    items:
    - id: J2
      kind: Question
      title: Now I’m going to ask you about some things that may have happened with your caregiver. I’d like you to tell me whether or not each statement describes any of them. (Please remember that all information provided is strictly confidential.) They put you down or call you names to make you feel bad.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: J3
      kind: Question
      title: They damage or destroy your possessions or property. (Does this statement describe your caregiver?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: J4
      kind: Question
      title: They harm, or threaten to harm, someone close to you. (Does this statement describe your caregiver?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: J6
      kind: Question
      title: They try to force you to relinquish control over your finances when you don’t want to. (Does this statement describe your caregiver?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: J7
      kind: Question
      title: They try to force you to give up something of value when you don’t want to. (Does this statement describe your caregiver?)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: J8
      kind: Question
      title: They try to force you to change your Last Will and Testament or try to obtain Power of Attorney over your finances when you don’t want them to. (Does this statement describe your caregiver?) (By power of attorney we mean a legal document which gives someone control over your finances and permits that person to write cheques or withdraw money from your bank account.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s13_caregiver
    title: Physical and sexual violence by caregiver
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (ROSTER_AGE.outcome < 65)
      hint: Asked only of respondents aged 65 or over.
    - predicate: not (J1.outcome in [3, 99])
      hint: Asked only when question J1 is none of "(3) No [Go to K15]", "(r) Refused [Go to K15]".
    items:
    - id: K0
      kind: Question
      title: Date / Time stamp
      input:
        control: Textarea
        maxLength: 50
    - id: K1
      kind: Question
      title: During the past 5 years, has any caregiver THREATENED to hit you with their fist or anything else that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K2
      kind: Question
      title: (During the past 5 years,) has any caregiver THROWN anything at you that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K3
      kind: Question
      title: (During the past 5 years,) has any caregiver pushed, grabbed, or shoved you in a way that could have hurt you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K4
      kind: Question
      title: (During the past 5 years,) has any caregiver slapped you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K5
      kind: Question
      title: (During the past 5 years,) has any caregiver kicked you, bit you, or hit you with their fist?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K6
      kind: Question
      title: (During the past 5 years,) has any caregiver hit you with something that could have hurt you? (Do not include hitting with fist)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K7
      kind: Question
      title: (During the past 5 years,) has any caregiver beaten you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K8
      kind: Question
      title: (During the past 5 years,) has any caregiver choked you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K9
      kind: Question
      title: (During the past 5 years,) has any caregiver USED or THREATENED TO USE a gun or knife on you?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: K10
      kind: Question
      title: (During the past 5 years,)has any caregiver forced you into any unwanted sexual activity, by threatening you, holding you down, or hurting you in some way?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s13_caregiver_incidents
    title: 'Caregiver violence: frequency and timing'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (ROSTER_AGE.outcome < 65)
      hint: Asked only of respondents aged 65 or over.
    - predicate: not (J1.outcome in [3, 99])
      hint: Asked only when question J1 is none of "(3) No [Go to K15]", "(r) Refused [Go to K15]".
    - predicate: not (K1.outcome != 1 and K2.outcome != 1 and K3.outcome != 1 and K4.outcome != 1 and K5.outcome != 1 and K6.outcome != 1 and K7.outcome != 1 and K8.outcome != 1 and K9.outcome != 1 and K10.outcome != 1)
      hint: Asked only when at least one of K1 to K10 is Yes.
    items:
    - id: K11
      kind: Question
      title: During the past 5 years, has any caregiver been violent towards you on more than one occasion?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to K14]
          99: (r) Refused [Go to K14]
    - id: K12
      kind: Question
      title: How many different times did these things happen?
      precondition:
      - predicate: not (K11.outcome in [3, 99])
        hint: Asked only when question K11 is none of "(3) No [Go to K14]", "(r) Refused [Go to K14]".
      input:
        control: Dropdown
        labels:
          2: (2) Two
          3: (3) Three
          4: (4) Four
          5: (5) Five
          6: (6) Six
          7: (7) Seven
          8: (8) Eight
          9: (9) Nine
          10: (10) Ten
          11: (11) More than ten
          98: (x) Don’t know
          99: (r) Refused
    - id: K13
      kind: Question
      title: 'How many of these were in the past 12 months? [CATI: 0-99] (x) Don’t know (r) Refused'
      precondition:
      - predicate: not (K11.outcome in [3, 99])
        hint: Asked only when question K11 is none of "(3) No [Go to K14]", "(r) Refused [Go to K14]".
      postcondition:
      - predicate: K13.outcome in [98, 99] or K12.outcome in [11, 98, 99] or K13.outcome <= K12.outcome
        hint: The number of incidents in the past 12 months (K13) cannot exceed the total number of incidents (K12). Correct K12 or K13.
      input:
        control: Editbox
        min: 0
        max: 99
    - id: K14
      kind: Question
      title: 'When did this happen (the most recent happen)? Year |__|__|__|__| [CATI: 1994-1999] (x) Don’t know (r) Refused'
      input:
        control: Editbox
        min: 1994
        max: 1999
    - id: K14_Month
      kind: Question
      title: 'When did this happen (the most recent happen)? Month |__|__| [CATI: 1-12] (x) Don’t know (r) Refused'
      input:
        control: Editbox
        min: 1
        max: 12
  - id: b_s13_other_crimes
    title: Other crimes in lifetime
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: K15
      kind: Question
      title: Has anything else happened to you in your lifetime that could be considered a crime? Please remember that crime includes vandalism, theft, fraud, break and enter, assault and sexual assault.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to CATI-K16e]
          98: (x) Don’t know [Go to CATI-K16e]
          99: (r) Refused [Go to CATI-K16e]
  - id: b_s13_crime_types
    title: Types of other crimes
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: K15.outcome == 1
      hint: Asked only when question K15 is "(1) Yes".
    items:
    - id: K16
      kind: Question
      title: What happened? …. (Did anything else happen to you?) INT:===Mark all that apply. Categorize if possible, or else list in “Other” category. ===
      input:
        control: Checkbox
        labels:
          1: 1 — Sexual assault (unwanted sexual touching, fondling, rape, and attempted rape)
          2: 2 — Robbery/Attempted robbery (theft with a face-to-face threat, an assault or a weapon If no threat, assault or weapon, classify elsewhere.)
          4: 3 — Assault (face-to-face threat or assault with or without a weapon but neither theft nor attempted theft of property)
          8: 4 — Break and enter/Attempt (illegal entry or attempted illegal entry into your residence or any other building on your property)
          16: 5 — Motor vehicle theft/Attempt (theft or attempted theft of motor vehicle or parts)
          32: 6 — Theft of personal property/Attempt (money or other personal property was taken or an attempt was made to take it)
          64: 7 — Fraud
          128: 8 — Theft of household property/Attempt
          256: 9 — Vandalism (something was damaged)
          512: 10 — Other [Go to K16S]
  - id: b_s13_crime_ages
    title: Age at each occurrence
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: K15.outcome == 1
      hint: Asked only when question K15 is "(1) Yes".
    - predicate: not (K16.outcome & 512 > 0)
      hint: Asked only when "Other" was not marked in K16.
    items:
    - id: K16A_1
      kind: Question
      title: 'K16A What was your approximate age when each occurrence happened? INT:===If a respondent gives an age range instead of a specific age, record the youngest age in the range. If age is < 1 year old, record age as 1.=== Category (1) Sexual assault: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 1 > 0
        hint: Asked only when Sexual assault was marked in K16.
      postcondition:
      - predicate: K16A_1.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: K16A_2
      kind: Question
      title: 'K16A (category 2) Robbery/Attempted robbery: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 2 > 0
        hint: Asked only when Robbery/Attempted robbery was marked in K16.
      postcondition:
      - predicate: K16A_2.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: K16A_3
      kind: Question
      title: 'K16A (category 3) Assault: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 4 > 0
        hint: Asked only when Assault was marked in K16.
      postcondition:
      - predicate: K16A_3.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: K16A_4
      kind: Question
      title: 'K16A (category 4) Break and enter/Attempt: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 8 > 0
        hint: Asked only when Break and enter/Attempt was marked in K16.
      postcondition:
      - predicate: K16A_4.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: K16A_5
      kind: Question
      title: 'K16A (category 5) Motor vehicle theft/Attempt: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 16 > 0
        hint: Asked only when Motor vehicle theft/Attempt was marked in K16.
      postcondition:
      - predicate: K16A_5.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: K16A_6
      kind: Question
      title: 'K16A (category 6) Theft of personal property/Attempt: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 32 > 0
        hint: Asked only when Theft of personal property/Attempt was marked in K16.
      postcondition:
      - predicate: K16A_6.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: K16A_7
      kind: Question
      title: 'K16A (category 7) Fraud: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 64 > 0
        hint: Asked only when Fraud was marked in K16.
      postcondition:
      - predicate: K16A_7.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: K16A_8
      kind: Question
      title: 'K16A (category 8) Theft of household property/Attempt: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 128 > 0
        hint: Asked only when Theft of household property/Attempt was marked in K16.
      postcondition:
      - predicate: K16A_8.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: K16A_9
      kind: Question
      title: 'K16A (category 9) Vandalism: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 256 > 0
        hint: Asked only when Vandalism was marked in K16.
      postcondition:
      - predicate: K16A_9.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
  - id: b_s13_crime_ages_other
    title: Age at occurrence of other crime
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: K15.outcome == 1
      hint: Asked only when question K15 is "(1) Yes".
    items:
    - id: K16A_10
      kind: Question
      title: 'K16A (category 10) Other: Age1 Age2 Age3 Age4'
      precondition:
      - predicate: K16.outcome & 512 > 0
        hint: Asked only when Other was marked in K16.
      postcondition:
      - predicate: K16A_10.outcome < ROSTER_AGE.outcome
        hint: The age at the occurrence (K16A) must be less than the respondent’s current age.
      input:
        control: Editbox
        min: 1
        max: 120
  - id: b_s13_crime_other_specify
    title: 'Other crime: specify'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: K15.outcome == 1
      hint: Asked only when question K15 is "(1) Yes".
    items:
    - id: K16S
      kind: Question
      title: 'Specify |__| ... [CATI]: Length of field = 50'
      precondition:
      - predicate: K16.outcome & 512 > 0
        hint: Asked only when Other was marked in K16.
      input:
        control: Textarea
        maxLength: 50
  - id: b_s14_stamp
    title: 'Section L: Spousal abuse report'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L0
      kind: Question
      title: Date / Time stamp
      input:
        control: Textarea
  - id: b_s14_injury
    title: Injuries
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L2
      kind: Question
      title: During this (these) incident(s), were you (ever) physically injured in any way?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to L6]
          99: (r) Refused [Go to L6]
  - id: b_s14_injured
    title: Injury details
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (L2.outcome in [3, 99])
      hint: Asked only when question L2 is none of "(3) No [Go to L6]", "(r) Refused [Go to L6]".
    items:
    - id: L3
      kind: Question
      title: Did any of these incidents in which you were injured happen in the past 12 months?
      precondition:
      - predicate: not (L2.outcome == 1 and (D11.outcome == 3 or D13.outcome == 0 or (D12.outcome >= 2 and D12.outcome <= 10 and D13.outcome == D12.outcome)))
        hint: Asked only when the earlier answers do not already settle the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L4
      kind: Question
      title: During the past 5 years, did you ever receive any medical attention at a hospital as aresult of the violence? (Include treatment received at emergency or as an out-patient.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to L5]
          99: (r) Refused [Go to L5]
  - id: b_s14_hospital
    title: Hospital stay
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (L2.outcome in [3, 99])
      hint: Asked only when question L2 is none of "(3) No [Go to L6]", "(r) Refused [Go to L6]".
    - predicate: not (L4.outcome in [3, 99])
      hint: Asked only when question L4 is none of "(3) No [Go to L5]", "(r) Refused [Go to L5]".
    items:
    - id: L4A
      kind: Question
      title: Did you stay in hospital overnight?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to L6]
          99: (r) Refused [Go to L6]
    - id: L4B
      kind: Question
      title: 'For how many nights? |__|__|__| [CATI: 0-999] (r) Refused'
      precondition:
      - predicate: not (L4A.outcome in [3, 99])
        hint: Asked only when question L4A is none of "(3) No [Go to L6]", "(r) Refused [Go to L6]".
      input:
        control: Editbox
        min: 0
        max: 999
  - id: b_s14_medical
    title: Medical attention
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (L2.outcome in [3, 99])
      hint: Asked only when question L2 is none of "(3) No [Go to L6]", "(r) Refused [Go to L6]".
    items:
    - id: L5
      kind: Question
      title: During the past 5 years, did you ever receive any medical attention from a doctor or anurse for your injuries? (Include medical attention received immediately after the attack as well as any medical attention received as a result of the injuries.)
      precondition:
      - predicate: not (L4A.outcome in [3, 99])
        hint: Asked only when question L4A is none of "(3) No [Go to L6]", "(r) Refused [Go to L6]".
      - predicate: not (L4A.outcome == 1)
        hint: Asked only when question L4A is not "(1) Yes".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s14_bed
    title: Time in bed
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L6
      kind: Question
      title: As a result of the violence (and excluding any time you spent in the hospital), did you, during the past 5 years, ever have to stay in bedforall or most of a day? (Include time spent in bed for injuries as well as for stress reasons.) INT:===Most of a day means at least 6 hours over and above the time the respondent normally spends sleeping.)===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to L7]
          99: (r) Refused [Go to L7]
    - id: L6A
      kind: Question
      title: 'For how many days? INT:===Count each day the respondent spent at least 6 hours in bed over and above the time he/she normally spends sleeping=== |__|__|__| [CATI: 0-999]'
      precondition:
      - predicate: not (L6.outcome in [3, 99])
        hint: Asked only when question L6 is none of "(3) No [Go to L7]", "(r) Refused [Go to L7]".
      input:
        control: Editbox
        min: 0
        max: 999
  - id: b_s14_other_effects
    title: Other effects, drinking and others harmed
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L7
      kind: Question
      title: (Other than the time you spent in the hospital or at home in bed,) during the past 5 years, did you ever have to take time off from your everyday activities because of what happened to you? INT:===Select (1) (yes) if the respondent’s everyday activities were disrupted for at least 6 hours===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L8
      kind: Question
      title: During (these) this incident(s) was your spouse/partner drinking? INT:===Select (1) (yes) if the respondent says usually or during more than half of the incidents===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Does not drink
          98: (x) Don’t know
          99: (r) Refused
    - id: L12
      kind: Question
      title: During the past 5 years, was anyone (else) ever harmed or threatened during (these) this incident(s)?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to L14]
          98: (x) Don't know [Go to L14]
          99: (r) Refused [Go to L14]
  - id: b_s14_harmed
    title: Others harmed or threatened
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: L12.outcome == 1
      hint: Asked only when question L12 is "(1) Yes".
    - predicate: not (L12.outcome in [3, 98, 99])
      hint: Asked only when question L12 is none of "(3) No [Go to L14]", "(x) Don't know [Go to L14]", "(r) Refused [Go to L14]".
    items:
    - id: L12A
      kind: Question
      title: 'How many persons? |__|__| [CATI: 0-99] (x) Don’t know (r) Refused'
      postcondition:
      - predicate: L12A.outcome >= 1 or L12A.outcome in [98, 99]
        hint: You said another person was harmed or threatened (L12), so the number of persons (L12A) must be at least 1.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: L13
      kind: Question
      title: Were any of these people who were harmed or threatenedunder15 years of age?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to L14]
          98: (x) Don’t know [Go to L14]
          99: (r) Refused [Go to L14]
  - id: b_s14_under15
    title: Persons under 15
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: L13.outcome == 1
      hint: Asked only when question L13 is "(1) Yes".
    - predicate: not (L12.outcome in [3, 98, 99])
      hint: Asked only when question L12 is none of "(3) No [Go to L14]", "(x) Don't know [Go to L14]", "(r) Refused [Go to L14]".
    - predicate: not (L13.outcome in [3, 98, 99])
      hint: Asked only when question L13 is none of "(3) No [Go to L14]", "(x) Don’t know [Go to L14]", "(r) Refused [Go to L14]".
    items:
    - id: L13A
      kind: Question
      title: 'How many persons? |__|__| [CATI: 0-99] (x) Don’t know (r) Refused'
      postcondition:
      - predicate: L12A.outcome in [98, 99] or L13A.outcome in [98, 99] or L13A.outcome <= L12A.outcome
        hint: The number of persons under 15 harmed or threatened (L13A) cannot exceed the total number of persons harmed or threatened (L12A).
        invented: true
      - predicate: L13A.outcome >= 1 or L13A.outcome in [98, 99]
        hint: You said someone under 15 was harmed or threatened (L13), so the number of persons (L13A) must be at least 1.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s14_children_compensation
    title: Children, fear and compensation
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L14
      kind: Question
      title: Did any of your children see or hear (any of these) this incident(s)?
      input:
        control: Radio
        labels:
          1: (1) Yes/think so
          3: (3) No/don’t think so
          5: (5) No children at the time
          98: (x) Don’t know
          99: (r) Refused
    - id: L15
      kind: Question
      title: During the past 5 years, did you ever fear that your life was in danger because of your spouse’s/partner’s violent or threatening behaviour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L16
      kind: Question
      title: During the past 5 years, did you ever attempt to obtain compensation, through a civil or criminal court or a provincial compensation program, because of the violence?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to L17]
          99: (r) Refused [Go to L17]
    - id: L16A
      kind: Question
      title: Did you obtain any compensation?
      precondition:
      - predicate: not (L16.outcome in [3, 99])
        hint: Asked only when question L16 is none of "(3) No [Go to L17]", "(r) Refused [Go to L17]".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Not yet resolved
          99: (r) Refused
    - id: L17
      kind: Question
      title: Did the police ever find out about the violence in any way? INT:=== If the respondent or the respondent’s spouse/partner or a member of the household is a police officer, select (1) (yes) only if it was reported to the police===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to L25A]
          98: (x) Don't know [Go to L27]
          99: (r) Refused [Go to L27]
  - id: b_s14_police
    title: Police involvement
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (L17.outcome == 3)
      hint: Asked only when question L17 is not "(3) No [Go to L25A]".
    items:
    - id: L18
      kind: Question
      title: Did they find out about it in the past 12 months?
      precondition:
      - predicate: not (L17.outcome == 1 and ((D11.outcome == 3 and D14.outcome < 12) or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when the earlier answers do not already settle the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L19
      kind: Question
      title: How did they learn about it? Was it from you or someotherway? INT:===If respondent answers both himself/herself and some other way - enter (1)===
      input:
        control: Radio
        labels:
          1: (1) Respondent
          3: (3) Some other way [Go to L21]
          98: (x) Don’t know [Go to L27]
          99: (r) Refused [Go to L27]
  - id: b_s14_police_reasons
    title: Reasons for reporting
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (L17.outcome == 3)
      hint: Asked only when question L17 is not "(3) No [Go to L25A]".
    - predicate: not (L19.outcome == 3)
      hint: Asked only when question L19 is not "(3) Some other way [Go to L21]".
    items:
    - id: L20a
      kind: Question
      title: 'People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported the violence? Was it… INT: ===READ LIST=== a) To stop the violence or receive protection?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: L20b
      kind: Question
      title: b) To arrest and punish your spouse/partner?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: L20c
      kind: Question
      title: c) Because you felt it was your duty to notify police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: L20d
      kind: Question
      title: d) On the recommendation of someone else?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
  - id: b_s14_police_actions
    title: Police actions and satisfaction
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (L17.outcome == 3)
      hint: Asked only when question L17 is not "(3) No [Go to L25A]".
    items:
    - id: L21
      kind: Question
      title: What action did the police take? INT:===Mark all that apply.===
      input:
        control: Checkbox
        labels:
          1: n — None [Go to L22]
          2: 1 — Visited Scene
          4: 2 — Made a report/Conducted an investigation
          8: 3 — Gave warning to spouse/partner
          16: 4 — Took spouse/partner away
          32: 5 — Made arrest/Laid charges
          64: 6 — Put you in touch with community services
          128: 7 — Other [Go to L21S]
          256: r — Refused [Go to L22]
          512: 0 — No other; continue [Go to L22]
    - id: L21S
      kind: Question
      title: 'Specify |__| ... CATI: Length of field = 28'
      precondition:
      - predicate: L21.outcome & 128 > 0
        hint: Asked only when "Other" was marked at L21.
      - predicate: not (L21.outcome & 1 > 0 or L21.outcome & 256 > 0 or L21.outcome & 512 > 0)
        hint: Asked only when L21 is none of "None", "Refused", "No other; continue".
      input:
        control: Textarea
        maxLength: 28
    - id: L22
      kind: Question
      title: 'How satisfied were you with the actions that the police took? Were you … INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: (1) Very satisfied?
          2: (2) Somewhat satisfied?
          3: (3) Somewhat dissatisfied?
          4: (4) Very dissatisfied?
          99: (r) Refused
    - id: L23
      kind: Question
      title: Is there anything (else) they should have done to help you? INT:===Mark all that apply.===
      input:
        control: Checkbox
        labels:
          1: n — No/nothing [Go to CATI-L23e]
          2: 1 — Take the person out of the house
          4: 2 — Charge/arrest the person
          8: 3 — Respond more quickly
          16: 4 — Refer/take you to a support service
          32: 5 — Relocate you
          64: 6 — Take you to hospital
          128: 7 — Be more supportive/sympathetic
          256: 8 — Other [Go to L23S]
          512: x — Don’t know [Go to CATI-L23e]
          1024: r — Refused [Go to CATI-L23e]
          2048: 0 — No other; continue [Go to CATI-L23e]
    - id: L23S
      kind: Question
      title: Specify (the source refers to L23S from L23 'Other' but does not print it in this part)
      precondition:
      - predicate: L23.outcome & 256 > 0
        hint: Asked only when "Other" was marked at L23.
      input:
        control: Textarea
  - id: b_s15_external
    title: External inputs
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (L17.outcome == 3)
      hint: Asked only when question L17 is not "(3) No [Go to L25A]".
    items:
    - id: RESPONDENT_SEX
      kind: Question
      title: 'Sex of respondent (CATI: only if female respondent / only if male respondent), known from the sample file or earlier in the interview'
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: RESPONDENT_AGE
      kind: Question
      title: 'Age of respondent (CATI: only if respondent is 65+), known from earlier in the interview'
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: EXABUSE
      kind: Question
      title: 'EXABUSE flag: whether the respondent reported ex-partner violence in the past 5 years (set before Section M)'
      external: true
      input:
        control: Radio
        labels:
          0: (0) No ex-spousal abuse
          1: Ex-spousal abuse reported
  - id: b_s16_police
    title: Police involvement
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (L17.outcome == 3)
      hint: Asked only when question L17 is not "(3) No [Go to L25A]".
    items:
    - id: L23S_2
      kind: Question
      title: 'L23S Specify [CATI]: Length of field = 50'
      input:
        control: Textarea
        maxLength: 50
    - id: L24
      kind: Question
      title: 'After the police were involved, did your spouse’s/partner’s violent or threatening behaviour towards you… INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: Increase?
          2: Decrease/stop?
          3: Stay the same?
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s16_reasons
    title: Reasons for not contacting the police
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L25A
      kind: Question
      title: I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it… Because it was dealt with another way? (e.g. left him/her, reported to another official, private matter that took care of myself, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25B
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because of fear of your spouse/partner?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25C
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the police couldn't do anything about it?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25D
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the police wouldn't help? (e.g. wouldn't think it was important enough, wouldn’t believe, wouldn't want to be bothered or get involved, police would be inefficient or ineffective, police would be biased, would harass/insult respondent, offender was police officer)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25E
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want to get involved with police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25X
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want your spouse/partner arrested or jailed?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25G
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the incident was a personal matter that didn’t concern the police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25Y
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want anyone to find out about it? (e.g. shame, embarrassment)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25H
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because of fear of publicity/news coverage?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25F
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because it was not important enough to you? (e.g. minor crime, no intended harm, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L25K
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) For some other reason, not already mentioned?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to CATI-L25e]
          99: (r) Refused [Go to CATI-L25e]
    - id: L25S
      kind: Question
      title: 'L25S Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: L25K.outcome == 1
        hint: Asked only when question L25K is "(1) Yes".
      input:
        control: Textarea
        maxLength: 50
    - id: L26
      kind: Question
      title: What was the main reason?
      precondition:
      - predicate: (L25A.outcome == 1) + (L25B.outcome == 1) + (L25C.outcome == 1) + (L25D.outcome == 1) + (L25E.outcome == 1) + (L25X.outcome == 1) + (L25G.outcome == 1) + (L25Y.outcome == 1) + (L25H.outcome == 1) + (L25F.outcome == 1) + (L25K.outcome == 1) >= 2
        hint: Asked only when two or more reasons were given in L25A to L25K.
      postcondition:
      - predicate: L26.outcome == 99 or (L26.outcome == 1 and L25A.outcome == 1) or (L26.outcome == 2 and L25B.outcome == 1) or (L26.outcome == 3 and L25C.outcome == 1) or (L26.outcome == 4 and L25D.outcome == 1) or (L26.outcome == 5 and L25E.outcome == 1) or (L26.outcome == 6 and L25F.outcome == 1) or (L26.outcome == 7 and L25G.outcome == 1) or (L26.outcome == 8 and L25H.outcome == 1) or (L26.outcome == 11 and L25X.outcome == 1) or (L26.outcome == 12 and L25Y.outcome == 1) or (L26.outcome == 13 and L25K.outcome == 1)
        hint: La raison principale (L26) doit être l’une des raisons que vous avez indiquées comme applicables en L25A à L25K.
        invented: true
      input:
        control: Dropdown
        labels:
          1: Dealt with another way
          2: Fear
          3: Police couldn't do anything
          4: Police wouldn't help
          5: Did not want to get involved with police
          6: Not important enough to respondent
          7: A personal matter that did not concern the police
          8: Fear of publicity/media coverage
          11: Didn’t want spouse/partner arrested or jailed
          12: Didn’t want anyone to find out about it
          13: Other
          99: (r) Refused
  - id: b_s16_talk
    title: Talking to others
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L27a
      kind: Question
      title: '(Other than to the police,) did you ever talk to anyone about (these) this incident(s), such as ... INT: ===READ LIST=== a) Family?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: L27b
      kind: Question
      title: L27 b) Friend or neighbour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: L27c
      kind: Question
      title: L27 c) Co-worker?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: L27d
      kind: Question
      title: L27 d) Doctor or nurse?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: L27e
      kind: Question
      title: L27 e) Lawyer?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: L27f
      kind: Question
      title: L27 f) Minister, priest, clergy or another spiritual advisor?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
  - id: b_s16_services
    title: Services used
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L28a
      kind: Question
      title: 'During the past 5 years, did you ever contact or use any of the following services for help because of the violence, such as … (“Victim Assistance Units” operate within a specific police office, and help victims at the police end of the justice system. “Victim Services” help victims as their cases proceed through the justice system (police, courts and corrections). Services include providing general information about the justice system, referrals, assistance with court, help preparing victim impact statements, offering emotional support and providing information to help victims recover financial losses resulting from the crime.) INT: ===READ LIST=== a) Crisis centre or crisis line?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L28b
      kind: Question
      title: L28 b) Another counsellor or psychologist?
      precondition:
      - predicate: not (L28a.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when the previous service answer does not end the list.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L28c
      kind: Question
      title: L28 c) Community centre or family centre?
      precondition:
      - predicate: not (L28a.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28b.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L28d
      kind: Question
      title: 'L28 d) Shelter or transition house? [CATI: only if female respondent]'
      precondition:
      - predicate: RESPONDENT_SEX.outcome == 2
        hint: Asked only when question RESPONDENT_SEX is "Female".
      - predicate: not (L28a.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28b.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28c.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L28e
      kind: Question
      title: 'L28 e) Women’s centre? [CATI: only if female respondent]'
      precondition:
      - predicate: RESPONDENT_SEX.outcome == 2
        hint: Asked only when question RESPONDENT_SEX is "Female".
      - predicate: not (L28a.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28b.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28c.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28d.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L28f
      kind: Question
      title: 'L28 f) Men’s centre or men’s support group? [CATI: only if male respondent]'
      precondition:
      - predicate: RESPONDENT_SEX.outcome == 1
        hint: Asked only when question RESPONDENT_SEX is "Male".
      - predicate: not (L28a.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28b.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28c.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28d.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28e.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L28g
      kind: Question
      title: 'L28 g) Seniors’ centre? [CATI: only if respondent is 65+]'
      precondition:
      - predicate: RESPONDENT_AGE.outcome >= 65
        hint: Asked only of respondents aged 65 or older.
      - predicate: not (L28a.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28b.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28c.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28d.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28e.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28f.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L28h
      kind: Question
      title: L28 h) Police-based or court-based victim services?
      precondition:
      - predicate: not (L28a.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28b.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28c.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28d.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28e.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28f.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      - predicate: not (L28g.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no earlier service answer ends the list.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: L28Aa
      kind: Question
      title: 'Was this in the past 12 months? (a: Crisis centre or crisis line)'
      precondition:
      - predicate: L28a.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome))
        hint: Asked only when crisis centre or line was used.
      - predicate: not (L28b.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28c.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28d.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28e.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28f.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28g.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28h.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L28Ab
      kind: Question
      title: 'Was this in the past 12 months? (b: Another counsellor or psychologist)'
      precondition:
      - predicate: L28b.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome))
        hint: Asked only when a counsellor or psychologist was used.
      - predicate: not (L28c.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28d.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28e.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28f.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28g.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28h.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L28Ac
      kind: Question
      title: 'Was this in the past 12 months? (c: Community centre or family centre)'
      precondition:
      - predicate: L28c.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome))
        hint: Asked only when a community or family centre was used.
      - predicate: not (L28d.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28e.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28f.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28g.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28h.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L28Ad
      kind: Question
      title: 'Was this in the past 12 months? (d: Shelter or transition house)'
      precondition:
      - predicate: L28d.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome))
        hint: Asked only when a shelter or transition house was used.
      - predicate: not (L28e.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28f.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28g.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28h.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L28Ae
      kind: Question
      title: 'Was this in the past 12 months? (e: Women’s centre)'
      precondition:
      - predicate: L28e.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome))
        hint: Asked only when a women’s centre was used.
      - predicate: not (L28f.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28g.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28h.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L28Af
      kind: Question
      title: 'Was this in the past 12 months? (f: Men’s centre or men’s support group)'
      precondition:
      - predicate: L28f.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome))
        hint: Asked only when a men’s centre or support group was used.
      - predicate: not (L28g.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      - predicate: not (L28h.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L28Ag
      kind: Question
      title: 'Was this in the past 12 months? (g: Seniors’ centre)'
      precondition:
      - predicate: L28g.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome))
        hint: Asked only when a seniors’ centre was used.
      - predicate: not (L28h.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome)))
        hint: Asked only when no later service follow-up applies.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L28Ah
      kind: Question
      title: 'Was this in the past 12 months? (h: Police-based or court-based victim services)'
      precondition:
      - predicate: L28h.outcome == 1 and not (D11.outcome == 3 or (D12.outcome >= 2 and D12.outcome <= 10 and D12.outcome == D13.outcome))
        hint: Asked only when police-based or court-based victim services were used.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: L29
      kind: Question
      title: Is there any reason why you didn’t use any of these services? INT:=== Mark all that apply.===
      precondition:
      - predicate: not (L28a.outcome != 3 or L28b.outcome != 3 or L28c.outcome != 3 or L28d.outcome != 3 or L28e.outcome != 3 or L28f.outcome != 3 or L28g.outcome != 3 or L28h.outcome != 3)
        hint: Asked only when none of the services was used.
      input:
        control: Checkbox
        labels:
          1: (1) Didn’t know of any services
          2: (2) None available
          4: (3) Waiting list
          8: (4) Too minor
          16: (5) Shame/embarrassment
          32: (6) Wouldn’t be believed
          64: (7) Offender prevented me
          128: (8) Distance
          256: (9) Fear of losing financial support
          512: (10) Fear of losing the children
          1024: (11) Didn’t want relationship to end
          2048: (12) Didn’t want/need help
          4096: (13) Other [Go to L29S]
          8192: (x) Don’t know/no reason [Go to L30]
          16384: (r) Refused [Go to L30]
          32768: (0) No other; continue [Go to L30]
    - id: L29S
      kind: Question
      title: 'L29S Specify CATI: Length of field =28'
      precondition:
      - predicate: (L29.outcome & 4096) > 0
        hint: Asked only when "Other" was marked in L29.
      - predicate: not (L28a.outcome != 3 or L28b.outcome != 3 or L28c.outcome != 3 or L28d.outcome != 3 or L28e.outcome != 3 or L28f.outcome != 3 or L28g.outcome != 3 or L28h.outcome != 3)
        hint: Asked only when none of the services was used.
      - predicate: not ((L29.outcome & 4096) == 0)
        hint: Asked only when "Other" was marked in L29.
      input:
        control: Textarea
        maxLength: 28
  - id: b_s16_impact
    title: Restorative interest and impact
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: L30
      kind: Question
      title: '(There are a number of ways to deal with an offence outside the normal police-court process. One way is a meeting between the victim and the offender to discuss an appropriate way the offender should be dealt with. Thinking about your experience, how interested would you be (have been) in participating in such a program if one was available in your community?) (Thinking about the incident(s), how interested would you be (have been) in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?) Would you be (have been)… INT: ===READ LIST=== [CATI-L30e: If this is the first time the following question is asked read conditional text 1; else read conditional text 2.]'
      input:
        control: Radio
        labels:
          1: (1) Very interested?
          2: (2) Somewhat interested?
          3: (3) Slightly interested?
          4: (4) Not at all interested?
          99: (r) Refused
    - id: L31
      kind: Question
      title: At the time of the incident(s), how did this experience affect you? INT:===Mark all that apply.=== INT:===Do not include physical injury, financial loss or medical treatment.===
      input:
        control: Checkbox
        labels:
          1: (1) Afraid for children
          2: (2) Angry
          4: (3) Ashamed/guilty
          8: (4) Depression/ anxiety attacks
          16: (5) Fearful
          32: (6) Hurt/disappointment
          64: (7) Increased self-reliance
          128: (8) Lowered self esteem
          256: (9) More cautious/aware
          512: (10) Not much
          1024: (11) Problems relating to men/women
          2048: (12) Shock/disbelief
          4096: (13) Sleeping problems
          8192: (14) Upset/confused/frustrated
          16384: (15) Other [Go to L31S]
          32768: (x) Don’t know [Go to L32]
          65536: (r) Refused [Go to L32]
          131072: (0) No other; continue [Go to L32]
    - id: L31S
      kind: Question
      title: 'L31S Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: (L31.outcome & 16384) > 0
        hint: Asked only when "Other" was marked in L31.
      - predicate: not ((L31.outcome & 16384) == 0)
        hint: Asked only when "Other" was marked in L31.
      input:
        control: Textarea
        maxLength: 50
    - id: L32
      kind: Question
      title: 'From your experience, what advice, if any, would you give another person in a similar situation? [CATI]: Length of field =50'
      input:
        control: Textarea
        maxLength: 50
  - id: b_s17_p1_injury
    title: Physical injury
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M2
      kind: Question
      title: During (these) this incident(s), were you (ever) physically injured in any way?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to M6]
          99: (r) Refused [Go to M6]
  - id: b_s17_p1_injury_followup
    title: Injury follow-up and medical attention
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (M2.outcome in [3, 99])
      hint: Asked only when question M2 is none of "(3) No [Go to M6]", "(r) Refused [Go to M6]".
    items:
    - id: M3
      kind: Question
      title: Did any of these incidents in which you were injured happen in the past 12 months?
      precondition:
      - predicate: M2.outcome == 1 and not (F11.outcome == 3 or F13.outcome == 0 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F13.outcome == F12.outcome))
        hint: Asked only when the respondent was injured and the incidents may fall in the past 12 months.
      - predicate: not (M2.outcome == 1 and (F11.outcome == 3 or F13.outcome == 0 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F13.outcome == F12.outcome)))
        hint: Asked only when the incidents may fall in the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M4
      kind: Question
      title: During the past 5 years, did you ever receive any medical attention at a hospital as a result of the violence? (Include treatment received at emergency or as an out-patient.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to M5]
          99: (r) Refused [Go to M5]
    - id: M4A
      kind: Question
      title: Did you stay in hospital overnight?
      precondition:
      - predicate: M4.outcome == 1
        hint: Asked only when question M4 is "(1) Yes".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to M6]
          99: (r) Refused [Go to M6]
    - id: M4B
      kind: Question
      title: 'For how many nights? |__|__|__| [CATI: 0-999]'
      precondition:
      - predicate: M4A.outcome == 1
        hint: Asked only when question M4A is "(1) Yes".
      input:
        control: Editbox
        min: 0
        max: 9999
        right: nights (9999 = Refused)
    - id: M5
      kind: Question
      title: During the past 5 years, did you ever receive any medical attention from a doctor or a nurse for your injuries? (Include medical attention received immediately after the attack as well as any medical attention received as a result of the injuries.)
      precondition:
      - predicate: M4.outcome in [3, 99]
        hint: Asked only when question M4 is one of "(3) No [Go to M5]", "(r) Refused [Go to M5]".
      - predicate: not (M4A.outcome in [3, 99])
        hint: Asked only when question M4A is none of "(3) No [Go to M6]", "(r) Refused [Go to M6]".
      - predicate: not (M4B.outcome is not None and M4B.outcome >= 0)
        hint: Asked only when the number of nights in hospital was not given.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s17_p1_impact
    title: Time lost and ex-partner drinking
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M6
      kind: Question
      title: As a result of the violence (and excluding any time you spent in the hospital), did you, during the past 5 years, ever have to stay in bed for all or most of a day? (Include time spent in bed for injuries as well as for stress reasons.) INT:=== Most of a day means at least 6 hours over and above the time the respondent normally spends sleeping.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to M7]
          99: (r) Refused [Go to M7]
    - id: M6A
      kind: Question
      title: 'For how many days? INT:=== Count each day the respondent spent at least 6 hours in bed over and above the time he/she normally spends sleeping=== |__|__|__| [CATI: 0-999]'
      precondition:
      - predicate: M6.outcome == 1
        hint: Asked only when question M6 is "(1) Yes".
      input:
        control: Editbox
        min: 0
        max: 9999
        right: days (9998 = Don’t know, 9999 = Refused)
    - id: M7
      kind: Question
      title: (Other than the time you spent in the hospital or at home in bed,) during the past 5 years, did you ever have to take time off from your everyday activities because of what happened to you? INT:===Select (1) (yes) if the respondent’s everyday activities were disrupted for at least 6 hours===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M8
      kind: Question
      title: During (these) this incident(s) was your ex-partner drinking? INT:===Select (1) (yes) if the respondent says usually or during more than half of the incidents===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Does not drink
          98: (x) Don’t know
          99: (r) Refused
    - id: M12
      kind: Question
      title: During the past 5 years, was anyone (else) ever harmed or threatened during (these) this incident(s)?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to M14]
          98: (x) Don't know [Go to M14]
          99: (r) Refused [Go to M14]
  - id: b_s17_p1_harmed_detail
    title: Other persons harmed or threatened
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: M12.outcome == 1
      hint: Asked only when question M12 is "(1) Yes".
    items:
    - id: M12A
      kind: Question
      title: 'How many persons? |__|__| [CATI: 0-99]'
      input:
        control: Editbox
        min: 0
        max: 999
        right: persons (998 = Don’t know, 999 = Refused)
    - id: M13
      kind: Question
      title: Were any of these people who were harmed or threatened under 15 years of age?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to M14]
          98: (x) Don’t know [Go to M14]
          99: (r) Refused [Go to M14]
    - id: M13A
      kind: Question
      title: 'How many persons? |__|__| [CATI: 0-99]'
      precondition:
      - predicate: M13.outcome == 1
        hint: Asked only when question M13 is "(1) Yes".
      postcondition:
      - predicate: M13A.outcome >= 998 or M12A.outcome >= 998 or M13A.outcome <= M12A.outcome
        hint: El número de personas menores de 15 años (M13A) no puede superar el número total de personas perjudicadas o amenazadas (M12A).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
        right: persons (998 = Don’t know, 999 = Refused)
  - id: b_s17_p1_children_compensation
    title: Children, fear and compensation
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M14
      kind: Question
      title: Did any of your children see or hear (any of these) this incident(s)?
      input:
        control: Radio
        labels:
          1: (1) Yes/think so
          3: (3) No/don’t think so
          5: (5) No children at the time
          98: (x) Don’t know
          99: (r) Refused
    - id: M15
      kind: Question
      title: During the past 5 years, did you ever fear that your life was in danger because of your ex-partner’s violent or threatening behaviour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M16
      kind: Question
      title: During the past 5 years, did you ever attempt to obtain compensation, through a civil or criminal court or a provincial compensation program, because of the violence?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to M17]
          99: (r) Refused [Go to M17]
    - id: M16A
      kind: Question
      title: Did you obtain any compensation?
      precondition:
      - predicate: M16.outcome == 1
        hint: Asked only when question M16 is "(1) Yes".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Not yet resolved
          99: (r) Refused
    - id: M17
      kind: Question
      title: Did the police ever find out about the violence in any way? INT:===If the respondent or the respondent’s ex-partner or a member of the household is a police officer, select (1) (yes) only if it was reported to the police===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to M25A]
          98: (x) Don't know [Go to M27]
          99: (r) Refused [Go to M27]
  - id: b_s17_p1_police_learned
    title: How the police found out
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (M17.outcome == 3)
      hint: Asked only when question M17 is not "(3) No [Go to M25A]".
    items:
    - id: M18
      kind: Question
      title: Did they find out about it in the past 12 months?
      precondition:
      - predicate: M17.outcome == 1 and not ((F11.outcome == 3) or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked only when the police found out and the incidents may fall in the past 12 months.
      - predicate: not (M17.outcome == 1 and (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when the incidents may fall in the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M19
      kind: Question
      title: How did they learn about it? Was it from you or some other way? INT:=== If respondent answers both himself/herself and some other way - enter (1)===
      precondition:
      - predicate: M17.outcome == 1
        hint: Asked only when question M17 is "(1) Yes".
      input:
        control: Radio
        labels:
          1: (1) Respondent
          3: (3) Some other way [Go to M21]
          98: (x) Don’t know [Go to M27]
          99: (r) Refused [Go to M27]
  - id: b_s17_p1_police_reasons
    title: Reasons for reporting to the police
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (M17.outcome == 3)
      hint: Asked only when question M17 is not "(3) No [Go to M25A]".
    - predicate: M19.outcome == 1
      hint: Asked only when question M19 is "(1) Respondent".
    items:
    - id: M20a
      kind: Question
      title: 'People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported the violence? Was it… INT: ===READ LIST=== a) To stop the violence or receive protection?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: M20b
      kind: Question
      title: M20 b) To arrest and punish your ex-partner?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: M20c
      kind: Question
      title: M20 c) Because you felt it was your duty to notify police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: M20d
      kind: Question
      title: M20 d) On the recommendation of someone else?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
  - id: b_s17_p1_police_action
    title: Police action and satisfaction
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (M17.outcome == 3)
      hint: Asked only when question M17 is not "(3) No [Go to M25A]".
    items:
    - id: M21
      kind: Question
      title: What action did the police take? INT:===Mark all that apply.===
      precondition:
      - predicate: M19.outcome in [1, 3]
        hint: Asked only when question M19 is one of "(1) Respondent", "(3) Some other way [Go to M21]".
      input:
        control: Checkbox
        labels:
          1: (1) Visited Scene
          2: (2) Made a report/Conducted an investigation
          4: (3) Gave warning to ex-partner
          8: (4) Took ex-partner away
          16: (5) Made arrest/Laid charges
          32: (6) Put in touch with community services
          64: (7) Other [Go to M21S]
          128: (n) None [Go to M22]
          256: (r) Refused [Go to M22]
          512: (0) No other; continue [Go to M22]
    - id: M21S
      kind: Question
      title: 'M21S Specify CATI: Length of field = 28'
      precondition:
      - predicate: M21.outcome is not None and M21.outcome & 64 > 0
        hint: Asked only when question M21 includes "(7) Other".
      input:
        control: Textarea
        maxLength: 28
    - id: M22
      kind: Question
      title: How satisfied were you with the actions that the police took? Were you … INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: (1) Very satisfied?
          2: (2) Somewhat satisfied?
          3: (3) Somewhat dissatisfied?
          4: (4) Very dissatisfied?
          99: (r) Refused
    - id: M23
      kind: Question
      title: Is there anything (else) they should have done to help you? INT:===Mark all that apply.===
      input:
        control: Checkbox
        labels:
          1: (1) Take the person out of the house
          2: (2) Charge/arrest the person
          4: (3) Respond more quickly
          8: (4) Refer/take you to a support service
          16: (5) Relocate you
          32: (6) Take you to hospital
          64: (7) Be more supportive/sympathetic
          128: (8) Other [Go to M23S]
          256: (n) No/nothing [Go to CATI-M23e]
          512: (x) Don’t know [Go to CATI-M23e]
          1024: (r) Refused [Go to CATI-M23e]
          2048: (0) No other; continue [Go to CATI-M23e]
    - id: M23S
      kind: Question
      title: 'M23S Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: M23.outcome is not None and M23.outcome & 128 > 0
        hint: Asked only when question M23 includes "(8) Other".
      input:
        control: Textarea
        maxLength: 50
    - id: M24
      kind: Question
      title: 'After the police were involved, did your ex-partner’s violent or threatening behaviour towards you… INT: ===READ LIST==='
      precondition:
      - predicate: F11.outcome != 3
        hint: Asked only when question F11 is not "(3) No [Go to F14]".
      input:
        control: Radio
        labels:
          1: (1) Increase?
          2: (2) Decrease/stop?
          3: (3) Stay the same?
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s17_p1_no_police
    title: Reasons for not contacting the police
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: M17.outcome == 3
      hint: Asked only when question M17 is "(3) No [Go to M25A]".
    items:
    - id: M25A
      kind: Question
      title: I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it… Because it was dealt with another way? (e.g. left him/her, reported to another official, private matter that took care of myself, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25B
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because of fear of your ex-partner?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25C
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the police couldn't do anything about it?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25D
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the police wouldn't help? (e.g. wouldn't think it was important enough, wouldn’t believe, wouldn't want to be bothered or get involved, police would be inefficient or ineffective, police would be biased, would harass/insult respondent, offender was police officer)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25E
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want to get involved with police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25X
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want your ex-partner arrested or jailed?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25G
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the incident was a personal matter that didn’t concern the police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25Y
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want anyone to find out about it? (e.g. shame, embarrassment)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25H
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because of fear of publicity/news coverage ?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25F
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because it was not important enough to you? (e.g. minor crime, no intended harm, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M25K
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) For some other reason, not already mentioned?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to CATI-M25e]
          99: (r) Refused [Go to CATI-M25e]
    - id: M25S
      kind: Question
      title: 'M25S Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: M25K.outcome == 1
        hint: Asked only when question M25K is "(1) Yes".
      input:
        control: Textarea
        maxLength: 50
    - id: M26
      kind: Question
      title: What was the main reason?
      precondition:
      - predicate: (M25A.outcome == 1) + (M25B.outcome == 1) + (M25C.outcome == 1) + (M25D.outcome == 1) + (M25E.outcome == 1) + (M25X.outcome == 1) + (M25G.outcome == 1) + (M25Y.outcome == 1) + (M25H.outcome == 1) + (M25F.outcome == 1) + (M25K.outcome == 1) >= 2
        hint: Asked only when two or more reasons were given in M25A to M25K.
      postcondition:
      - predicate: M26.outcome == 99 or (M26.outcome == 1 and M25A.outcome == 1) or (M26.outcome == 2 and M25B.outcome == 1) or (M26.outcome == 3 and M25C.outcome == 1) or (M26.outcome == 4 and M25D.outcome == 1) or (M26.outcome == 5 and M25E.outcome == 1) or (M26.outcome == 6 and M25F.outcome == 1) or (M26.outcome == 7 and M25G.outcome == 1) or (M26.outcome == 8 and M25H.outcome == 1) or (M26.outcome == 11 and M25X.outcome == 1) or (M26.outcome == 12 and M25Y.outcome == 1) or (M26.outcome == 13 and M25K.outcome == 1)
        hint: La raison principale (M26) doit être l’une des raisons que vous avez indiquées comme applicables en M25A à M25K.
        invented: true
      input:
        control: Dropdown
        labels:
          1: Dealt with another way
          2: Fear
          3: Police couldn't do anything
          4: Police wouldn't help
          5: Did not want to get involved with police
          6: Not important enough to respondent
          7: A personal matter that did not concern the police
          8: Fear of publicity/media coverage
          11: Didn’t want ex-partner arrested or jailed
          12: Didn’t want anyone to find out about it
          13: Other
          99: (r) Refused
  - id: b_s17_p1_talk_to_others
    title: Talking to others about the incidents
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M27a
      kind: Question
      title: '(Other than to the police,) did you ever talk to anyone about (these) this incident(s), such as ... INT: ===READ LIST=== a) Family?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: M27b
      kind: Question
      title: M27 b) Friend or neighbour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: M27c
      kind: Question
      title: M27 c) Co-worker?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: M27d
      kind: Question
      title: M27 d) Doctor or nurse?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: M27e
      kind: Question
      title: M27 e) Lawyer?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: M27f
      kind: Question
      title: M27 f) Minister, priest, clergy or another spiritual advisor?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
  - id: b_s17_p1_services
    title: Services contacted for help
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M28a
      kind: Question
      title: 'During the past 5 years, did you ever contact or use any of the following services for help because of the violence, such as … (“Victim Assistance Units” operate within a specific police office, and help victims at the police end of the justice system. “Victim Services” help victims as their cases proceed through the justice system (police, courts and corrections). Services include providing general information about the justice system, referrals, assistance with court, help preparing victim impact statements, offering emotional support and providing information to help victims recover financial losses resulting from the crime.) INT: ===READ LIST=== a) Crisis centre or crisis line?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M28b
      kind: Question
      title: M28 b) Another counsellor or psychologist?
      precondition:
      - predicate: not (M28a.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M28c
      kind: Question
      title: M28 c) Community centre or family centre?
      precondition:
      - predicate: not (M28a.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28b.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M28d
      kind: Question
      title: 'M28 d) Shelter or transition house? [CATI: only if female respondent]'
      precondition:
      - predicate: RESPONDENT_SEX.outcome == 2
        hint: Asked only when question RESPONDENT_SEX is "Female".
      - predicate: not (M28a.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28b.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28c.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M28e
      kind: Question
      title: 'M28 e) Women’s centre? [CATI: only if female respondent]'
      precondition:
      - predicate: RESPONDENT_SEX.outcome == 2
        hint: Asked only when question RESPONDENT_SEX is "Female".
      - predicate: not (M28a.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28b.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28c.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28d.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M28f
      kind: Question
      title: 'M28 f) Men’s centre or men’s support group? [CATI: only if male respondent]'
      precondition:
      - predicate: RESPONDENT_SEX.outcome == 1
        hint: Asked only when question RESPONDENT_SEX is "Male".
      - predicate: not (M28a.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28b.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28c.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28d.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28e.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M28g
      kind: Question
      title: 'M28 g) Seniors’ centre? [CATI: only if respondent is 65+]'
      precondition:
      - predicate: RESPONDENT_AGE.outcome >= 65
        hint: Asked only of respondents aged 65 or over.
      - predicate: not (M28a.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28b.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28c.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28d.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28e.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28f.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M28h
      kind: Question
      title: M28 h) Police-based or court-based victim services?
      precondition:
      - predicate: not (M28a.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28b.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28c.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28d.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28e.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28f.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      - predicate: not (M28g.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no earlier service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: M28Aa
      kind: Question
      title: 'Was this in the past 12 months? (a: Crisis centre or crisis line)'
      precondition:
      - predicate: M28a.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked only when crisis centre was used and the incidents may fall in the past 12 months.
      - predicate: not (M28b.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28c.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28d.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28e.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28f.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28g.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28h.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M28Ab
      kind: Question
      title: 'Was this in the past 12 months? (b: Another counsellor or psychologist)'
      precondition:
      - predicate: M28b.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked only when a counsellor was used and the incidents may fall in the past 12 months.
      - predicate: not (M28c.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28d.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28e.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28f.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28g.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28h.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M28Ac
      kind: Question
      title: 'Was this in the past 12 months? (c: Community centre or family centre)'
      precondition:
      - predicate: M28c.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked only when a community centre was used and the incidents may fall in the past 12 months.
      - predicate: not (M28d.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28e.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28f.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28g.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28h.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M28Ad
      kind: Question
      title: 'Was this in the past 12 months? (d: Shelter or transition house)'
      precondition:
      - predicate: M28d.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked only when a shelter was used and the incidents may fall in the past 12 months.
      - predicate: not (M28e.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28f.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28g.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28h.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M28Ae
      kind: Question
      title: 'Was this in the past 12 months? (e: Women’s centre)'
      precondition:
      - predicate: M28e.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked only when a women’s centre was used and the incidents may fall in the past 12 months.
      - predicate: not (M28f.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28g.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28h.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M28Af
      kind: Question
      title: 'Was this in the past 12 months? (f: Men’s centre or men’s support group)'
      precondition:
      - predicate: M28f.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked only when a men’s centre was used and the incidents may fall in the past 12 months.
      - predicate: not (M28g.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      - predicate: not (M28h.outcome == 1 and not (F11.outcome == 3 or (F12.outcome is not None and F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Asked only when no later service was already followed up for the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s17_p2_recent
    title: 'Section M: Ex-spousal abuse report (services in the past 12 months)'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M28Ag
      kind: Question
      title: 'Was this in the past 12 months? (g: Seniors’ centre)'
      precondition:
      - predicate: M28g.outcome == 1 and not (F11.outcome == 3 or (F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked when the seniors’ centre was used (M28g) and the ex-partner filter applies.
      - predicate: not (M28h.outcome == 1 and not (F11.outcome == 3 or (F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome)))
        hint: Not asked when the police-based or court-based victim services question (M28Ah) is asked instead.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: M28Ah
      kind: Question
      title: 'Was this in the past 12 months? (h: Police-based or court-based victim services)'
      precondition:
      - predicate: M28h.outcome == 1 and not (F11.outcome == 3 or (F12.outcome >= 2 and F12.outcome <= 10 and F12.outcome == F13.outcome))
        hint: Asked when police-based or court-based victim services were used (M28h) and the ex-partner filter applies.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s17_p2_reasons
    title: 'Section M: Ex-spousal abuse report (reasons for not using services)'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M29
      kind: Question
      title: Is there any reason why you didn’t use any of these services? INT:===Mark all that apply.===
      precondition:
      - predicate: not (M28a.outcome != 3 or M28b.outcome != 3 or M28c.outcome != 3 or M28d.outcome != 3 or M28e.outcome != 3 or M28f.outcome != 3 or M28g.outcome != 3 or M28h.outcome != 3)
        hint: Asked only when none of the services M28a to M28h was used.
      input:
        control: Checkbox
        labels:
          1: (1) Didn’t know of any services
          2: (2) None available
          4: (3) Waiting list
          8: (4) Too minor
          16: (5) Shame/embarrassment
          32: (6) Wouldn’t be believed
          64: (7) Offender prevented me
          128: (8) Distance
          256: (9) Fear of losing financial support
          512: (10) Fear of losing the children
          1024: (11) Didn’t want relationship to end
          2048: (12) Didn’t want/need help
          4096: (13) Other [Go to M29S]
          8192: (x) Don’t know/no reason [Go to M30]
          16384: (r) Refused [Go to M30]
          32768: (0) No other; continue [Go to M30]
    - id: M29S
      kind: Question
      title: 'M29S Specify CATI: Length of field =28'
      precondition:
      - predicate: (M29.outcome & 4096) > 0
        hint: Asked only when 'Other' was marked at M29.
      - predicate: not (M28a.outcome != 3 or M28b.outcome != 3 or M28c.outcome != 3 or M28d.outcome != 3 or M28e.outcome != 3 or M28f.outcome != 3 or M28g.outcome != 3 or M28h.outcome != 3)
        hint: Asked only when none of the services M28a to M28h was used.
      - predicate: not ((M29.outcome & 4096) == 0)
        hint: Asked only when 'Other' was marked at M29.
      input:
        control: Textarea
        maxLength: 28
  - id: b_s18_external
    title: External inputs (referenced by routing in this part)
    items:
    - id: SCABUSE
      kind: Question
      title: 'SCABUSE: flag set earlier in the interview (senior abuse by children). If SCABUSE = (0), Go to P0.'
      external: true
      input:
        control: Radio
        labels:
          0: (0) No senior abuse by children reported
          1: (1) Senior abuse by children reported
    - id: SGABUSE
      kind: Question
      title: 'SGABUSE: flag set earlier in the interview (senior abuse by caregiver). If SGABUSE = (0), Go to Q0.'
      external: true
      input:
        control: Radio
        labels:
          0: (0) No senior abuse by caregiver reported
          1: (1) Senior abuse by caregiver reported
    - id: H10_2
      kind: Question
      title: 'H10: answer from an earlier section (used in CATI-N3e, CATI-N14e, CATI-N24e)'
      external: true
      input:
        control: Radio
        labels:
          1: (1)
          3: (3)
    - id: H11_2
      kind: Question
      title: 'H11: answer from an earlier section (used in CATI-N3e, CATI-N14e, CATI-N24e)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: H12_2
      kind: Question
      title: 'H12: answer from an earlier section (used in CATI-N3e, CATI-N14e, CATI-N24e); the source also tests whether H12 is ''On path''/''Off path'''
      external: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: H13_2
      kind: Question
      title: 'H13: time since the incident from an earlier section (used in CATI-N14e, CATI-N24e: ''less than 12 months ago'')'
      external: true
      input:
        control: Editbox
        min: 0
        max: 999
    - id: K11_2
      kind: Question
      title: 'K11: answer from an earlier section (used in CATI-P3e, CATI-P14e)'
      external: true
      input:
        control: Radio
        labels:
          1: (1)
          3: (3)
    - id: K12_2
      kind: Question
      title: 'K12: answer from an earlier section (used in CATI-P3e, CATI-P14e)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: K13_2
      kind: Question
      title: 'K13: answer from an earlier section (used in CATI-P3e, CATI-P14e); the source also tests ''On path''/''Off path'''
      external: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: K14_2
      kind: Question
      title: 'K14: time since the incident from an earlier section (used in CATI-P14e: ''less than 12 months ago'')'
      external: true
      input:
        control: Editbox
        min: 0
        max: 999
    - id: RESPONDENT_SEX_2
      kind: Question
      title: 'Respondent''s sex (from sample file / earlier section), used by the ''[CATI: only if female respondent]'' and ''[CATI: only if male respondent]'' notes in N24'
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
  - id: b_s19_interest
    title: 'Section M (end): interest in a restorative meeting'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M30
      kind: Question
      title: '(There are a number of ways to deal with an offence outside the normal police-court process. One way is a meeting between the victim and the offender to discuss an appropriate way the offender should be dealt with. Thinking about your experience, how interested would you have been (be) in participating in such a program if one was available in your community?) (Thinking about the incident(s), how interested would you have been (be) in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?) Would you have been (be)… INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: (1) Very interested?
          2: (2) Somewhat interested?
          3: (3) Slightly interested?
          4: (4) Not at all interested?
          99: (r) Refused
  - id: b_s19_effects
    title: 'Section M (end): effects and advice'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: M31
      kind: Question
      title: At the time of the incident(s), how did this experience affect you? INT:===Mark all that apply.=== INT:===Do not include physical injury, financial loss or medical treatment.===
      input:
        control: Checkbox
        labels:
          1: (1) Afraid for children
          2: (2) Angry
          4: (3) Ashamed/guilty
          8: (4) Depression/ anxiety attacks
          16: (5) Fearful
          32: (6) Hurt/disappointment
          64: (7) Increased self-reliance
          128: (8) Lowered self esteem
          256: (9) More cautious/aware
          512: (10) Not much
          1024: (11) Problems relating to men/women
          2048: (12) Shock/disbelief
          4096: (13) Sleeping problems
          8192: (14) Upset/confused/frustrated
          16384: (15) Other [Go to M31S]
          32768: (x) Don’t know [Go to M32]
          65536: (r) Refused [Go to M32]
          131072: (0) No other; continue [Go to M32]
    - id: M31S
      kind: Question
      title: 'Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: M31.outcome & 16384 > 0
      - predicate: not (M31.outcome & 16384 == 0)
      input:
        control: Textarea
        maxLength: 50
    - id: M32
      kind: Question
      title: 'From your experience, what advice, if any, would you give another person in a similar situation? [CATI]: Length of field =50'
      input:
        control: Textarea
        maxLength: 50
  - id: b_s20_stamp
    title: 'SECTION N: SENIOR ABUSE BY CHILDREN REPORT'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    items:
    - id: N0
      kind: Question
      title: Date / Time stamp (system-recorded; no printed id wording beyond label)
      input:
        control: Textarea
  - id: b_s20_incident
    title: Incident
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    items:
    - id: N1A
      kind: Question
      title: Was it a son or daughter who did this to you?
      input:
        control: Radio
        labels:
          1: (1) Son(s)
          2: (2) Daughter(s)
          3: (3) Both
          98: (x) Don’t know
          99: (r) Refused
    - id: N2
      kind: Question
      title: At the time of the incident(s), did the child/children who did this to you live with you? INT:===If respondent answers “Yes” then probe as to whether it was during the whole period or if it was during some of the time===
      input:
        control: Radio
        labels:
          1: (1) Yes, during the whole period of abuse
          2: (2) Yes, during some of the time of abuse
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: N3
      kind: Question
      title: During (these) this incident(s), were you (ever) physically injured in any way?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to N7]
          99: (r) Refused [Go to N7]
  - id: b_s20_injury
    title: Injury and medical attention
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    - predicate: not (N3.outcome == 3 or N3.outcome == 99)
      hint: Asked only when the respondent was injured (N3).
    items:
    - id: N4
      kind: Question
      title: Did any of these incidents in which you were injured happen in the past 12 months?
      precondition:
      - predicate: not (N3.outcome == 1 and (H10_2.outcome == 3 or H12_2.outcome == 0 or (H11_2.outcome >= 2 and H11_2.outcome <= 10 and H12_2.outcome == H11_2.outcome)))
        hint: Skipped when the earlier answers already settle the 12-month timing.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N5
      kind: Question
      title: During the past 5 years, did you ever receive any medical attention at a hospital as aresult of the violence? (Include treatment received at emergency or as an out-patient.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to N6]
          99: (r) Refused [Go to N6]
    - id: N5A
      kind: Question
      title: Did you stay in hospital overnight?
      precondition:
      - predicate: not (N5.outcome == 3 or N5.outcome == 99)
        hint: Asked only when hospital attention was received (N5).
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to N7]
          99: (r) Refused [Go to N7]
    - id: N5B
      kind: Question
      title: 'For how many nights? [CATI: 0-999]'
      precondition:
      - predicate: not (N5.outcome == 3 or N5.outcome == 99)
        hint: Asked only when hospital attention was received (N5).
      - predicate: not (N5A.outcome == 3 or N5A.outcome == 99)
        hint: Asked only when the respondent stayed overnight (N5A).
      input:
        control: Editbox
        min: 0
        max: 999
    - id: N6
      kind: Question
      title: During the past 5 years, did you ever receive any medical attention from a doctor or anurse for your injuries? (Include medical attention received immediately after the attack as well as any medical attention received as a result of the injuries.)
      precondition:
      - predicate: not (N5A.outcome == 3 or N5A.outcome == 99)
        hint: Not asked when the respondent did not stay overnight (N5A).
      - predicate: N5B.outcome is None or N5B.outcome < 0
        hint: Not asked after the number of nights (N5B) was given.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s20_bed
    title: Consequences
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    items:
    - id: N7
      kind: Question
      title: As a result of the violence (and excluding any time you spent in the hospital), did you, during the past 5 years, ever have to stay in bedforall or most of a day? (Include time spent in bed for injuries as well as for stress reasons.) INT:===Most of a day means at least 6 hours over and above the time the respondent normally spends sleeping.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to N8]
          99: (r) Refused [Go to N8]
    - id: N7A
      kind: Question
      title: 'For how many days? INT:=== Count each day the respondent spent at least 6 hours in bed over and above the time he/she normally spends sleeping=== [CATI: 0-999]'
      precondition:
      - predicate: not (N7.outcome == 3 or N7.outcome == 99)
        hint: Asked only when the respondent stayed in bed (N7).
      input:
        control: Editbox
        min: 0
        max: 999
    - id: N8
      kind: Question
      title: (Other than the time you spent in the hospital or at home in bed,) during the past 5 years, did you ever have to take time off from your everyday activities because of what happened to you? INT:===Select (1) (yes) if the respondent’s everyday activities were disrupted for at least 6 hours===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: N9
      kind: Question
      title: During (these) this incident(s) was/were your child/children drinking? INT:===Select (1) (yes) if the respondent says usually or during more than half of the incidents.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Does not drink
          98: (x) Don't know
          99: (r) Refused
  - id: b_s20_harm
    title: Others harmed, fear, compensation
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    items:
    - id: N10
      kind: Question
      title: During the past 5 years, was anyone (else) ever harmed or threatened during this (these) incident(s)?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to N12]
          98: (x) Don't know [Go to N12]
          99: (r) Refused [Go to N12]
    - id: N10A
      kind: Question
      title: 'How many persons? [CATI: 0-99]'
      precondition:
      - predicate: not (N10.outcome == 3 or N10.outcome == 98 or N10.outcome == 99)
        hint: Asked only when others were harmed or threatened (N10).
      input:
        control: Editbox
        min: 0
        max: 99
    - id: N11
      kind: Question
      title: Were any of these people who were harmed or threatenedunder15 years of age?
      precondition:
      - predicate: not (N10.outcome == 3 or N10.outcome == 98 or N10.outcome == 99)
        hint: Asked only when others were harmed or threatened (N10).
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to N12]
          98: (x) Don’t know [Go to N12]
          99: (r) Refused [Go to N12]
    - id: N11A
      kind: Question
      title: 'How many persons? [CATI: 0-99]'
      precondition:
      - predicate: not (N10.outcome == 3 or N10.outcome == 98 or N10.outcome == 99)
        hint: Asked only when others were harmed or threatened (N10).
      - predicate: not (N11.outcome == 3 or N11.outcome == 98 or N11.outcome == 99)
        hint: Asked only when some were under 15 (N11).
      postcondition:
      - predicate: N11A.outcome <= N10A.outcome or N10A.outcome >= 98 or N11A.outcome >= 98
        hint: El número de personas menores de 15 años (N11A) no puede superar el total de personas dañadas o amenazadas (N10A). / The number of persons under 15 (N11A) cannot exceed the total number harmed or threatened (N10A).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: N12
      kind: Question
      title: During the past 5 years, did you ever fear that your life was in danger because of your child’s/children’s violent or threatening behaviour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N13
      kind: Question
      title: During the past 5 years, did you ever attempt to obtain compensation, through a civil orcriminal court or a provincial compensation program, because of the violence?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to N14]
          99: (r) Refused [Go to N14]
    - id: N13A
      kind: Question
      title: Did you obtain any compensation?
      precondition:
      - predicate: not (N13.outcome == 3 or N13.outcome == 99)
        hint: Asked only when compensation was sought (N13).
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Not yet resolved
          99: (r) Refused
  - id: b_s20_police_find
    title: Police contact
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    items:
    - id: N14
      kind: Question
      title: Did the police ever find out about the violence in any way? INT:=== If the respondent or the respondent’s child or a member of the household is a police officer, select (1) (yes) only if it was reported to the police.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to N21A]
          98: (x) Don't know [Go to N23]
          99: (r) Refused [Go to N23]
  - id: b_s20_police
    title: Police action
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    - predicate: not (N14.outcome == 3)
      hint: Asked only when N14 is not (3) No.
    items:
    - id: N15
      kind: Question
      title: Did they find out about it in the past 12 months?
      precondition:
      - predicate: not (N14.outcome == 1 and ((H10_2.outcome == 3 and H13_2.outcome < 12) or (H11_2.outcome >= 2 and H11_2.outcome <= 10 and H11_2.outcome == H12_2.outcome)))
        hint: Skipped when the earlier answers already settle the 12-month timing.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: N16
      kind: Question
      title: How did they learn about it? Was it from you or someotherway? INT:=== If respondent answers both himself/herself and some other way - select (1).===
      input:
        control: Radio
        labels:
          1: (1) Respondent
          3: (3) Some other way [Go to N18]
          98: (x) Don’t know [Go to N23]
          99: (r) Refused [Go to N23]
    - id: N17a
      kind: Question
      title: 'N17 People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported the violence? Was it… INT: ===READ LIST=== a) To stop the violence or receive protection?'
      precondition:
      - predicate: not (N16.outcome == 3)
        hint: Asked only when N16 is not (3) Some other way.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: N17b
      kind: Question
      title: N17 b) To arrest and punish your child?
      precondition:
      - predicate: not (N16.outcome == 3)
        hint: Asked only when N16 is not (3) Some other way.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: N17c
      kind: Question
      title: N17 c) Because you felt it was your duty to notify police?
      precondition:
      - predicate: not (N16.outcome == 3)
        hint: Asked only when N16 is not (3) Some other way.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: N17d
      kind: Question
      title: N17 d) On the recommendation of someone else?
      precondition:
      - predicate: not (N16.outcome == 3)
        hint: Asked only when N16 is not (3) Some other way.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: N18
      kind: Question
      title: What action did the police take? INT:===Mark all that apply.===
      input:
        control: Checkbox
        labels:
          1: (n) None [Go to N19]
          2: (1) Visited Scene
          4: (2) Made a report/Conducted an investigation
          8: (3) Gave warning to child/children
          16: (4) Took child/children away
          32: (5) Made arrest/Laid charges
          64: (6) Put in touch with community services
          128: (7) Other [Go to N18S]
          256: (r) Refused [Go to N19]
          512: (0) No other; continue [Go to N19]
    - id: N18S
      kind: Question
      title: 'Specify CATI: Length of field = 28'
      precondition:
      - predicate: (N18.outcome // 128) % 2 == 1
        hint: Asked only when 'Other' was marked in N18.
      input:
        control: Textarea
        maxLength: 28
    - id: N19
      kind: Question
      title: How satisfied were you with the actions that the police took? Were you … INT:===READ LIST===
      input:
        control: Radio
        labels:
          1: (1) Very satisfied?
          2: (2) Somewhat satisfied?
          3: (3) Somewhat dissatisfied?
          4: (4) Very dissatisfied?
          99: (r) Refused
    - id: N20
      kind: Question
      title: Is there anything (else) they should have done to help you? INT:===Mark all that apply.===
      input:
        control: Checkbox
        labels:
          1: (n) No/nothing [Go to N23]
          2: (1) Take the person out of the house
          4: (2) Charge/arrest the person
          8: (3) Respond more quickly
          16: (4) Refer/take you to a support service
          32: (5) Relocate you
          64: (6) Take you to hospital
          128: (7) Be more supportive/sympathetic
          256: (8) Other [Go to N20S]
          512: (x) Don’t know [Go to N23]
          1024: (r) Refused [Go to N23]
          2048: (0) No other; continue [Go to N23]
    - id: N20S
      kind: Question
      title: 'Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: (N20.outcome // 256) % 2 == 1
        hint: Asked only when 'Other' was marked in N20.
      input:
        control: Textarea
        maxLength: 50
  - id: b_s20_noreport
    title: Reasons for not contacting police
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    items:
    - id: N21A
      kind: Question
      title: I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it… Because it was dealt with another way? (e.g. reported to another official, private matter that took care of myself, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21B
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because of fear of your child/children?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21C
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the police couldn't do anything about it?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21D
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the police wouldn't help? (e.g. wouldn't think it was important enough, wouldn’t believe, wouldn't want to be bothered or get involved, police would be inefficient or ineffective, police would be biased, would harass/insult respondent, offender was police officer)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21E
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want to get involved with police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21X
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want your child/children arrested or jailed?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21G
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the incident was a personal matter that didn’t concern the police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21Y
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want anyone to find out about it? (e.g. shame, embarrassment)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21H
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because of fear of publicity/news coverage ?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21F
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because it was not important enough to you? (e.g. minor crime, no intended harm, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: N21K
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) For some other reason, not already mentioned?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to CATI-N21e]
          99: (r) Refused [Go to CATI-N21e]
    - id: N21S
      kind: Question
      title: 'Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: N21K.outcome == 1
        hint: Asked only when N21K is (1) Yes.
      input:
        control: Textarea
        maxLength: 50
    - id: N22
      kind: Question
      title: What was the main reason?
      input:
        control: Dropdown
        labels:
          1: (1) Dealt with another way
          2: (2) Fear
          3: (3) Police couldn't do anything
          4: (4) Police wouldn't help
          5: (5) Did not want to get involved with police
          6: (6) Not important enough to respondent
          7: (7) A personal matter that did not concern the police
          8: (8) Fear of publicity/media coverage
          11: (11) Didn’t want child/children arrested or jailed
          12: (12) Didn’t want anyone to find out about it
          13: (13) Other
          99: (r) Refused
  - id: b_s20_talk
    title: Talking to others
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    items:
    - id: N23a
      kind: Question
      title: 'N23 (Other than to the police,) did you ever talk to anyone about (these) this incident(s), such as ... INT: ===READ LIST=== a) Family?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: N23b
      kind: Question
      title: N23 b) Friend or neighbour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: N23c
      kind: Question
      title: N23 c) Co-worker?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: N23d
      kind: Question
      title: N23 d) Doctor or nurse?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: N23e
      kind: Question
      title: N23 e) Lawyer?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: N23f
      kind: Question
      title: N23 f) Minister, priest, clergy or another spiritual advisor?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
  - id: b_s20_services
    title: Services used
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    items:
    - id: N24a
      kind: Question
      title: 'N24 During the past 5 years, did you ever contact or use any of the following services for help because of the violence, such as … (“Victim Assistance Units” operate within a specific police office, and help victims at the police end of the justice system. “Victim Services” help victims as their cases proceed through the justice system (police, courts and corrections). Services include providing general information about the justice system, referrals, assistance with court, help preparing victim impact statements, offering emotional support and providing information to help victims recover financial losses resulting from the crime.) INT: ===READ LIST=== a) Crisis centre or crisis line?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N24b
      kind: Question
      title: N24 b) Another counsellor or psychologist?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N24c
      kind: Question
      title: N24 c) Community centre or family centre?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N24d
      kind: Question
      title: 'N24 d) Shelter or transition house? [CATI: only if female respondent]'
      precondition:
      - predicate: RESPONDENT_SEX_2.outcome == 2
        hint: Asked only of female respondents.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N24e
      kind: Question
      title: 'N24 e) Women’s centre? [CATI: only if female respondent]'
      precondition:
      - predicate: RESPONDENT_SEX_2.outcome == 2
        hint: Asked only of female respondents.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N24f
      kind: Question
      title: 'N24 f) Men’s centre or men’s support group? [CATI: only if male respondent]'
      precondition:
      - predicate: RESPONDENT_SEX_2.outcome == 1
        hint: Asked only of male respondents.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N24g
      kind: Question
      title: N24 g) Seniors’ centre?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N24h
      kind: Question
      title: N24 h) Police-based or court-based victim services?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: N24A_2
      kind: Question
      title: Was this in the past 12 months? a to h (asked for each of N24a to N24h answered (1) unless CATI-N24e skips it)
      precondition:
      - predicate: (N24a.outcome == 1 or N24b.outcome == 1 or N24c.outcome == 1 or N24d.outcome == 1 or N24e.outcome == 1 or N24f.outcome == 1 or N24g.outcome == 1 or N24h.outcome == 1) and not ((H10_2.outcome == 3 and H13_2.outcome < 12) or (H11_2.outcome >= 2 and H11_2.outcome <= 10 and H12_2.outcome == H13_2.outcome))
        hint: Asked only when a service was used and the 12-month timing is not already settled.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s20_noservice
    title: Reasons for not using services
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    - predicate: N24a.outcome == 3 and N24b.outcome == 3 and N24c.outcome == 3 and (N24d.outcome is None or N24d.outcome == 3) and (N24e.outcome is None or N24e.outcome == 3) and (N24f.outcome is None or N24f.outcome == 3) and N24g.outcome == 3 and N24h.outcome == 3
      hint: Asked only when no service in N24 was used.
    items:
    - id: N25
      kind: Question
      title: Is there any reason why you didn’t use any of these services? INT:===Mark all that apply.===
      input:
        control: Checkbox
        labels:
          1: (1) Didn’t know of any services
          2: (2) None available
          4: (3) Waiting list
          8: (4) Too minor
          16: (5) Shame/embarrassment
          32: (6) Wouldn’t be believed
          64: (7) Offender prevented me
          128: (8) Distance
          256: (9) Fear of losing financial support
          512: (11) Didn’t want relationship with children to end
          1024: (12) Didn’t want/need help
          2048: (13) Other [Go to N25S]
          4096: (x) Don’t know/no reason [Go to N26]
          8192: (r) Refused [Go to N26]
          16384: (0) No other; continue [Go to N26]
    - id: N25S
      kind: Question
      title: 'Specify CATI: Length of field =28'
      precondition:
      - predicate: (N25.outcome // 2048) % 2 == 1
        hint: Asked only when 'Other' was marked in N25.
      input:
        control: Textarea
        maxLength: 28
  - id: b_s20_closing
    title: Restorative program, effects and advice
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when CATI-B14e-VERIFY is not (3) No.
    - predicate: not (SCABUSE.outcome == 0)
      hint: Asked only when senior abuse by children was reported.
    items:
    - id: N26
      kind: Question
      title: '(There are a number of ways to deal with an offence outside the normal police-court process. One way is a meeting between the victim and the offender to discuss an appropriate way the offender should be dealt with. Thinking about your experience, how interested would you be (have been) in participating in such a program if one was available in your community?) (Thinking about the incident(s), how interested would you be (have been) in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?) Would you be (have been) … INT: ===READ LIST=== [CATI-N26e: If this is the first time the following question is asked read conditional text 1; else read conditional text 2.]'
      input:
        control: Radio
        labels:
          1: (1) Very interested?
          2: (2) Somewhat interested?
          3: (3) Slightly interested?
          4: (4) Not at all interested?
          99: (r) Refused
    - id: N27
      kind: Question
      title: At the time of the incident(s), how did this experience affect you? INT:===Mark all that apply.=== INT:===Do not include physical injury, financial loss or medical treatment.===
      input:
        control: Checkbox
        labels:
          1: (2) Angry
          2: (3) Ashamed/guilty
          4: (4) Depression/ anxiety attacks
          8: (5) Fearful
          16: (6) Hurt/disappointment
          32: (7) Increased self-reliance
          64: (8) Lowered self esteem
          128: (9) More cautious/aware
          256: (10) Not much
          512: (11) Problems relating to your children
          1024: (12) Shock/disbelief
          2048: (13) Sleeping problems
          4096: (14) Upset/confused/frustrated
          8192: (15) Other [Go to N27S]
          16384: (x) Don’t know [Go to N28]
          32768: (r) Refused [Go to N28]
          65536: (0) No other; continue [Go to N28]
    - id: N27S
      kind: Question
      title: 'Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: (N27.outcome // 8192) % 2 == 1
        hint: Asked only when 'Other' was marked in N27.
      input:
        control: Textarea
        maxLength: 50
    - id: N28
      kind: Question
      title: 'From your experience, what advice, if any, would you give another person in a similar situation? [CATI]: Length of field =50'
      input:
        control: Textarea
        maxLength: 50
  - id: b_s21_preamble
    title: 'SECTION P: SENIOR ABUSE BY CAREGIVER REPORT'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: P0
      kind: Question
      title: Date / Time stamp (system-recorded; no printed id wording beyond label)
      input:
        control: Textarea
  - id: b_s21_relationship
    title: Caregiver relationship
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P2
      kind: Question
      title: What is/was your caregiver’s relationship to you? INT:===Mark all that apply.===
      input:
        control: Checkbox
        labels:
          1: (1) Son-in-law
          2: (2) Daughter-in-law
          4: (3) Brother
          8: (4) Sister
          16: (5) Caregiver from an agency/organization
          32: (6) Healthcare worker
          64: (7) Friend/acquaintance
          128: (8) Neighbour
          256: (9) Other [Go to P2S]
          512: (x) Don't know [Go to P3]
          1024: (r) Refused [Go to P3]
          2048: (0) No other; continue [Go to P3]
    - id: P2S
      kind: Question
      title: 'Specify CATI: Length of field = 28'
      precondition:
      - predicate: P2.outcome & 256 > 0
      - predicate: not (P2.outcome & 256 == 0 and (P2.outcome & 512 > 0 or P2.outcome & 1024 > 0 or P2.outcome & 2048 > 0))
      input:
        control: Textarea
        maxLength: 28
  - id: b_s21_injury
    title: Injury
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P3
      kind: Question
      title: During (these) this incident(s), were you (ever) physically injured in any way?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to P7]
          99: (r) Refused [Go to P7]
  - id: b_s21_injury_followup
    title: Injury follow-up
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    - predicate: not (P3.outcome == 3 or P3.outcome == 99)
    items:
    - id: P4
      kind: Question
      title: Did any of these incidents in which you were injured happen in the past 12 months?
      precondition:
      - predicate: not (P3.outcome == 1 and (K11_2.outcome == 3 or K13_2.outcome == 0 or (K12_2.outcome >= 2 and K12_2.outcome <= 10 and K13_2.outcome == K12_2.outcome)))
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: P5
      kind: Question
      title: During the past 5 years, did you ever receive any medical attention at a hospital as aresult of the violence? (Include treatment received at emergency or as an out-patient.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to P6]
          99: (r) Refused [Go to P6]
    - id: P5A
      kind: Question
      title: Did you stay in hospital overnight?
      precondition:
      - predicate: not (P5.outcome == 3 or P5.outcome == 99)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to P7]
          99: (r) Refused [Go to P7]
    - id: P5B
      kind: Question
      title: 'For how many nights? [CATI: 0-999]'
      precondition:
      - predicate: not (P5.outcome == 3 or P5.outcome == 99)
      - predicate: not (P5A.outcome == 3 or P5A.outcome == 99)
      input:
        control: Editbox
        min: 0
        max: 999
    - id: P6
      kind: Question
      title: During the past 5 years, did you ever receive any medical attention from a doctor or a nurse for your injuries? (Include medical attention received immediately after the attack as well as any medical attention received as a result of the injuries.)
      precondition:
      - predicate: not (P5A.outcome == 3 or P5A.outcome == 99)
      - predicate: P5B.outcome is None
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
  - id: b_s21_consequences
    title: Consequences of the violence
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P7
      kind: Question
      title: As a result of the violence (and excluding any time you spent in the hospital), did you, during the past 5 years, ever have to stay in bedforall or most of a day? (Include time spent in bed for injuries as well as for stress reasons.) INT:===Most of a day means at least 6 hours over and above the time the respondent normally spends sleeping.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to P8]
          99: (r) Refused [Go to P8]
    - id: P7A
      kind: Question
      title: 'For how many days? INT:=== Count each day the respondent spent at least 6 hours in bed over and above the time he/she normally spends sleeping.=== [CATI: 0-999]'
      precondition:
      - predicate: not (P7.outcome == 3 or P7.outcome == 99)
      input:
        control: Editbox
        min: 0
        max: 999
    - id: P8
      kind: Question
      title: (Other than the time you spent in the hospital or at home in bed,) During the past 5 years, did you ever have to take time off from your everyday activities because of what happened to you? INT:=== Select (1) (yes) if the respondent’s everyday activities were disrupted for at least 6 hours.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: P9
      kind: Question
      title: During (these) this incident(s) was your caregiver drinking? INT:=== Select (1) (yes) if the respondent says usually or during more than half of the incidents.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Doesn’t drink
          98: (x) Don't know
          99: (r) Refused
    - id: P10
      kind: Question
      title: During the past 5 years, was anyone (else) ever harmed or threatened during (this) these incident(s)?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to P12]
          98: (x) Don't know [Go to P12]
          99: (r) Refused [Go to P12]
  - id: b_s21_others_harmed
    title: Other persons harmed or threatened
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    - predicate: not (P10.outcome == 3 or P10.outcome == 98 or P10.outcome == 99)
    items:
    - id: P10A
      kind: Question
      title: 'How many persons? [CATI: 0-99]'
      input:
        control: Editbox
        min: 0
        max: 99
    - id: P11
      kind: Question
      title: Were any of these people who were harmed or threatenedunder15 years of age?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to P12]
          98: (x) Don’t know [Go to P12]
          99: (r) Refused [Go to P12]
    - id: P11A
      kind: Question
      title: 'How many persons? [CATI: 0-99]'
      precondition:
      - predicate: not (P11.outcome == 3 or P11.outcome == 98 or P11.outcome == 99)
      postcondition:
      - predicate: P11A.outcome <= P10A.outcome or P10A.outcome >= 98 or P11A.outcome >= 98
        hint: El número de personas menores de 15 años (P11A) no puede superar el total de personas dañadas o amenazadas (P10A). / The number of persons under 15 (P11A) cannot exceed the total number harmed or threatened (P10A).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s21_compensation_police
    title: Fear, compensation and police
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P12
      kind: Question
      title: During the past 5 years, did you ever fear that your life was in danger because of your caregiver’s violent or threatening behaviour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P13
      kind: Question
      title: During the past 5 years, did you ever attempt to obtain compensation, through a civil or criminal court or a provincial compensation program, because of the violence?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to P14]
          99: (r) Refused [Go to P14]
    - id: P13A
      kind: Question
      title: Did you obtain any compensation?
      precondition:
      - predicate: not (P13.outcome == 3 or P13.outcome == 99)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Not yet resolved
          99: (r) Refused
    - id: P14
      kind: Question
      title: Did the police ever find out about the violence in any way? INT:=== If the respondent or the respondent’s caregiver or a member of the household is a police officer, select (1) (yes) only if it was reported to the police.===
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to P21A]
          98: (x) Don't know [Go to P23]
          99: (r) Refused [Go to P23]
  - id: b_s22_preamble
    title: Interview setup
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: RESPONDENT_SEX_3
      kind: Question
      title: 'Sex of the respondent, known to the CATI application (referenced by ''[CATI: only if female respondent]'' and ''[CATI: only if male respondent]'' at P24); not collected in this part'
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
  - id: b_s22_police_a
    title: 'Police involvement: how they found out'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    - predicate: not (P14.outcome == 3)
      hint: Asked only when question P14 is not "(3) No [Go to P21A]".
    items:
    - id: P15
      kind: Question
      title: Did they find out about it in the past 12 months?
      precondition:
      - predicate: not (P14.outcome == 1 and ((K11_2.outcome == 3 and K14_2.outcome < 12) or (K12_2.outcome >= 2 and K12_2.outcome <= 10 and K13_2.outcome == K12_2.outcome)))
        hint: Not asked when the police are already known to have found out within the past 12 months.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: P16
      kind: Question
      title: 'How did they learn about it? Was it from you or someotherway? INT: If respondent answers both himself/herself and some other way - select (1).'
      input:
        control: Radio
        labels:
          1: (1) Respondent
          3: (3) Some other way
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s22_p17
    title: Reasons for reporting to the police
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    - predicate: not (P14.outcome == 3)
      hint: Asked only when question P14 is not "(3) No [Go to P21A]".
    - predicate: not (P16.outcome == 3)
      hint: Asked only when question P16 is not "(3) Some other way".
    items:
    - id: P17a
      kind: Question
      title: 'People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported the violence? Was it … INT: READ LIST. a) To stop the violence or receive protection?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: P17b
      kind: Question
      title: P17 b) To arrest and punish your caregiver?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: P17c
      kind: Question
      title: P17 c) Because you felt it was your duty to notify police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: P17d
      kind: Question
      title: P17 d) On the recommendation of someone else?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
  - id: b_s22_police_b
    title: Police actions and satisfaction
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    - predicate: not (P14.outcome == 3)
      hint: Asked only when question P14 is not "(3) No [Go to P21A]".
    items:
    - id: P18
      kind: Question
      title: 'What action did the police take? INT: Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (n) None
          2: (1) Visited Scene
          4: (2) Made a report/Conducted an investigation
          8: (3) Gave warning to caregiver
          16: (4) Took caregiver away
          32: (5) Made arrest/Laid charges
          64: (6) Put in touch with community services
          128: (7) Other
          256: (r) Refused
          512: (0) No other; continue
    - id: P18S
      kind: Question
      title: 'Specify (CATI: Length of field = 28)'
      precondition:
      - predicate: P18.outcome & 128 > 0
        hint: Asked only when "Other" was selected at P18.
      - predicate: not (P18.outcome & 1 > 0 or P18.outcome & 256 > 0 or P18.outcome & 512 > 0)
        hint: Not asked when P18 is None, Refused or No other.
      input:
        control: Textarea
        maxLength: 28
    - id: P19
      kind: Question
      title: 'How satisfied were you with the actions that the police took? Were you … INT: READ LIST'
      input:
        control: Radio
        labels:
          1: (1) Very satisfied?
          2: (2) Somewhat satisfied?
          3: (3) Somewhat dissatisfied?
          4: (4) Very dissatisfied?
          99: (r) Refused
    - id: P20
      kind: Question
      title: 'Is there anything (else) they should have done to help you? INT: Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (n) No/nothing
          2: (1) Take the person out of the house
          4: (2) Charge/arrest the person
          8: (3) Respond more quickly
          16: (4) Refer/take you to a support service
          32: (5) Relocate you
          64: (6) Take you to hospital
          128: (7) Be more supportive/sympathetic
          256: (8) Other
          512: (x) Don’t know
          1024: (r) Refused
          2048: (0) No other; continue
    - id: P20S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 50)'
      precondition:
      - predicate: P20.outcome & 256 > 0
        hint: Asked only when "Other" was selected at P20.
      input:
        control: Textarea
        maxLength: 50
  - id: b_s22_noreport
    title: Reasons for not contacting the police
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P21A
      kind: Question
      title: I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it… Because it was dealt with another way? (e.g. reported to another official, private matter that took care of myself, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21B
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because of fear of your caregiver?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21C
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the police couldn't do anything about it?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21D
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell Me which ones apply to your experience. Was it…) Because the police wouldn't help? (e.g. wouldn't think it was important enough, wouldn’t believe, wouldn't want to be bothered or get involved, police would be inefficient or ineffective, police would be biased, would harass/insult respondent, offender was police officer)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21E
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want to get involved with police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21X
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want your caregiver arrested or jailed?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21G
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because the incident was a personal matter that didn’t concern the police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21Y
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because you didn’t want anyone to find out about it? (e.g. shame, embarrassment)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21H
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because of fear of publicity/news coverage ?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21F
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) Because it was not important enough to you? (e.g. minor crime, no intended harm, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21K
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…) For some other reason, not already mentioned?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P21S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 50)'
      precondition:
      - predicate: P21K.outcome == 1
        hint: Asked only when question P21K is "(1) Yes".
      input:
        control: Textarea
        maxLength: 50
    - id: P22
      kind: Question
      title: What was the main reason?
      precondition:
      - predicate: (P21A.outcome == 1) + (P21B.outcome == 1) + (P21C.outcome == 1) + (P21D.outcome == 1) + (P21E.outcome == 1) + (P21X.outcome == 1) + (P21G.outcome == 1) + (P21Y.outcome == 1) + (P21H.outcome == 1) + (P21F.outcome == 1) + (P21K.outcome == 1) >= 2
        hint: Asked only when two or more reasons were given at P21.
      input:
        control: Dropdown
        labels:
          1: (1) Dealt with another way
          2: (2) Fear
          3: (3) Police couldn't do anything
          4: (4) Police wouldn't help
          5: (5) Did not want to get involved with police
          6: (6) Not important enough to respondent
          7: (7) A personal matter that did not concern the police
          8: (8) Fear of publicity/media coverage
          11: (11) Didn’t want caregiver arrested or jailed
          12: (12) Didn’t want anyone to find out about it
          13: (13) Other
          99: (r) Refused
  - id: b_s22_talk
    title: Talking to others about what happened
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P23a
      kind: Question
      title: '(Other than to the police,) did you ever talk to anyone about what happened, such as ... INT: READ LIST. a) Family?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: P23b
      kind: Question
      title: P23 b) Friend or neighbour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: P23c
      kind: Question
      title: P23 c) Co-worker?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: P23d
      kind: Question
      title: P23 d) Doctor or nurse?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: P23e
      kind: Question
      title: P23 e) Lawyer?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
    - id: P23f
      kind: Question
      title: P23 f) Minister, priest, clergy or another spiritual advisor?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t Know
          99: (r) Refused
  - id: b_s22_services_1
    title: Services used (1)
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P24a
      kind: Question
      title: 'During the past 5 years, did you ever contact or use any of the following services for help because of the violence, such as … (“Victim Assistance Units” operate within a specific police office, and help victims at the police end of the justice system. “Victim Services” help victims as their cases proceed through the justice system (police, courts and corrections). Services include providing general information about the justice system, referrals, assistance with court, help preparing victim impact statements, offering emotional support and providing information to help victims recover financial losses resulting from the crime.) INT: READ LIST. a) Crisis centre or crisis line?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: P24b
      kind: Question
      title: P24 b) Another counsellor or psychologist?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: P24c
      kind: Question
      title: P24 c) Community centre or family centre?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s22_services_female
    title: Services used (female respondents)
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    - predicate: RESPONDENT_SEX_3.outcome == 2
      hint: Asked only when question RESPONDENT_SEX is "Female".
    items:
    - id: P24d
      kind: Question
      title: 'P24 d) Shelter or transition house? [CATI: only if female respondent]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: P24e
      kind: Question
      title: 'P24 e) Women’s centre? [CATI: only if female respondent]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s22_services_2
    title: Services used (2) and follow-ups
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P24f
      kind: Question
      title: 'P24 f) Men’s centre or men’s support group? [CATI: only if male respondent]'
      precondition:
      - predicate: RESPONDENT_SEX_3.outcome == 1
        hint: Asked only when question RESPONDENT_SEX is "Male".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: P24g
      kind: Question
      title: P24 g) Seniors’ centre?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: P24h
      kind: Question
      title: P24 h) Police-based or court-based victim services?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: P24A_2
      kind: Question
      title: Was this in the past 12 months? (asked for each of a to h answered Yes)
      precondition:
      - predicate: P24a.outcome == 1 or P24b.outcome == 1 or P24c.outcome == 1 or P24d.outcome == 1 or P24e.outcome == 1 or P24f.outcome == 1 or P24g.outcome == 1 or P24h.outcome == 1
        hint: Asked only when at least one service was used at P24.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: P25
      kind: Question
      title: 'Is there any reason why you didn’t use any of these services? INT: Mark all that apply.'
      precondition:
      - predicate: not (not (P24a.outcome == 3 and P24b.outcome == 3 and P24c.outcome == 3 and P24d.outcome == 3 and P24e.outcome == 3 and P24f.outcome == 3 and P24g.outcome == 3 and P24h.outcome == 3))
        hint: Asked only when no service was used at P24.
      input:
        control: Checkbox
        labels:
          1: (1) Didn’t know of any services
          2: (2) None available
          4: (3) Waiting list
          8: (4) Too minor
          16: (5) Shame/embarrassment
          32: (6) Wouldn’t be believed
          64: (7) Offender prevented me
          128: (8) Distance
          256: (9) Fear of losing financial support
          512: (11) Didn’t want relationship with caregiver to end
          1024: (12) Didn’t want/need help
          2048: (13) Other
          4096: (x) Don’t know/no reason
          8192: (r) Refused
          16384: (0) No other; continue
    - id: P25S
      kind: Question
      title: 'Specify (CATI: Length of field =28)'
      precondition:
      - predicate: P25.outcome & 2048 > 0
        hint: Asked only when "Other" was selected at P25.
      - predicate: not (not (P24a.outcome == 3 and P24b.outcome == 3 and P24c.outcome == 3 and P24d.outcome == 3 and P24e.outcome == 3 and P24f.outcome == 3 and P24g.outcome == 3 and P24h.outcome == 3))
        hint: Asked only when no service was used at P24.
      - predicate: not (P25.outcome & 4096 > 0 or P25.outcome & 8192 > 0 or P25.outcome & 16384 > 0)
        hint: Not asked when P25 is Don't know, Refused or No other.
      input:
        control: Textarea
        maxLength: 28
  - id: b_s22_effects
    title: Restorative programme and effects of the violence
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (SGABUSE.outcome == 0)
      hint: Asked only when question SGABUSE is not "(0) No senior abuse by caregiver reported".
    items:
    - id: P26
      kind: Question
      title: '(There are a number of ways to deal with an offence outside the normal police-court process. One way is a meeting between the victim and the offender to discuss an appropriate way the offender should be dealt with. Thinking about your experience, how interested would you be (have been) in participating in such a program if one was available in your community?) (Thinking about the incident(s), how interested would you be (have been) in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?) Would you be (have been) … INT: READ LIST. CATI-P26e: If this is the first time the following question is asked read conditional text 1; else read conditional text 2.'
      input:
        control: Radio
        labels:
          1: (1) Very interested?
          2: (2) Somewhat interested?
          3: (3) Slightly interested?
          4: (4) Not at all interested?
          99: (r) Refused
    - id: P27
      kind: Question
      title: 'At the time of the incident(s), how did this experience affect you? INT: Mark all that apply. INT: Do not include physical injury, financial loss or medical treatment.'
      input:
        control: Checkbox
        labels:
          1: (2) Angry
          2: (3) Ashamed/guilty
          4: (4) Depression/ anxiety attacks
          8: (5) Fearful
          16: (6) Hurt/disappointment
          32: (7) Increased self-reliance
          64: (8) Lowered self esteem
          128: (9) More cautious/aware
          256: (10) Not much
          512: (12) Shock/disbelief
          1024: (13) Sleeping problems
          2048: (14) Upset/confused/frustrated
          4096: (15) Other
          8192: (x) Don’t know
          16384: (r) Refused
          32768: (0) No other; continue
    - id: P27S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 50)'
      precondition:
      - predicate: P27.outcome & 4096 > 0
        hint: Asked only when "Other" was selected at P27.
      - predicate: not (P27.outcome & 8192 > 0 or P27.outcome & 16384 > 0 or P27.outcome & 32768 > 0)
        hint: Not asked when P27 is Don't know, Refused or No other.
      input:
        control: Textarea
        maxLength: 50
    - id: P28
      kind: Question
      title: 'From your experience, is there any advice you would give another person in a similar situation? ([CATI]: Length of field =50)'
      input:
        control: Textarea
        maxLength: 50
        placeholder: Type the advice; or note No/Nothing, Don't know or Refused
  - id: b_s23_preamble
    title: 'Classification: external inputs'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: YEAR_OF_BIRTH
      kind: Question
      title: Year of birth of the respondent, collected elsewhere in the questionnaire (referenced by CATI-Q7e)
      external: true
      input:
        control: Editbox
        min: 1850
        max: 1999
    - id: HOUSEHOLD_ROSTER_PARTNER
      kind: Question
      title: 'From the household roster (CATI-Q9e: ''Verify household roster''): whether the respondent is currently married, living common-law or has a same-sex partner; not collected in this part'
      external: true
      input:
        control: Radio
        labels:
          1: Currently married, living common-law or same-sex partner
          3: Not currently married, living common-law or with a same-sex partner
  - id: b_s23_dwelling
    title: Dwelling
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q0
      kind: Question
      title: Date / Time stamp (system-recorded; no answer asked of the respondent)
      input:
        control: Textarea
    - id: Q1
      kind: Question
      title: 'Now, I''d like to ask you for some background information. In what type of dwelling are you now living? Is it a . . . INT: READ LIST. INT: If respondent answers condominium or seniors’ housing, ask whether the building is a townhouse or high-rise or low-rise apartment'
      input:
        control: Radio
        labels:
          1: (1) Single detached house?
          2: (2) Semi-detached or double (side by side)?
          3: (3) Garden house, town-house or row house?
          4: (4) Duplex (one above the other)?
          5: (5) Low-rise apartment (less than 5 stories)?
          6: (6) High-rise apartment (5 or more stories)?
          7: (7) Mobile home or trailer?
          8: (8) Other
          99: (r) Refused
    - id: Q1S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q1.outcome == 8
        hint: Asked only when question Q1 is "(8) Other".
      input:
        control: Textarea
        maxLength: 28
    - id: Q2
      kind: Question
      title: Is this dwelling owned by a member of this household?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: Q2A
      kind: Question
      title: How long have you lived in this dwelling?
      input:
        control: Radio
        labels:
          1: (1) Less than six months
          2: (2) 6 months to less than 1 year
          3: (3) 1 year to less than 3 years
          4: (4) 3 years to less than 5 years
          5: (5) 5 years and over
          98: (x) Don't know
          99: (r) Refused
    - id: Q3
      kind: Question
      title: What is the postal code(for your current residence)? (( We use postal codes to determine if the respondent lives in an urban or rural area. If the respondent lives in a rural area and receives his/her mail at a post office in a nearby town, obtain the postal code of his/her residence if possible, otherwise enter the postal code of the mailing address.) We require at least the first two digits of the postal code to determine if the residence is in an urban or rural area.)
      input:
        control: Textarea
        maxLength: 7
  - id: b_s23_origin
    title: Cultural or racial background
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q4
      kind: Question
      title: 'Canadians come from many cultural or racial backgrounds. I''m going to read you a list. Are you... INT: READ LIST - Maximum 4 answers.'
      postcondition:
      - predicate: (Q4.outcome & 1 > 0) + (Q4.outcome & 2 > 0) + (Q4.outcome & 4 > 0) + (Q4.outcome & 8 > 0) + (Q4.outcome & 16 > 0) + (Q4.outcome & 32 > 0) + (Q4.outcome & 64 > 0) + (Q4.outcome & 128 > 0) + (Q4.outcome & 256 > 0) + (Q4.outcome & 512 > 0) + (Q4.outcome & 1024 > 0) + (Q4.outcome & 2048 > 0) + (Q4.outcome & 4096 > 0) <= 4
        hint: 'Q4: se pueden marcar como máximo 4 respuestas; quite alguna de las opciones marcadas.'
        invented: true
      input:
        control: Checkbox
        labels:
          1: (1) White?
          2: (2) Chinese?
          4: (3) Aboriginal, that is North American Indian, Métis, or Inuit?
          8: (4) South Asian? (e.g., East Indian, Pakistani, Punjabi, Sri Lankan)
          16: (5) Black ? (e.g., African, Haitian, Jamaican, Somali)
          32: (6) Filipino?
          64: (7) Latin American?
          128: (8) Southeast Asian? (e.g., Cambodian, Indonesian, Laotian, Vietnamese)
          256: (9) Arab? (e.g., Egyptian, Lebanese, Moroccan)
          512: (10) Central or West Asian? (e.g. Afghan, Iranian, Turk)
          1024: (11) Japanese?
          2048: (12) Korean?
          4096: (13) Other
          8192: (x) Don't know
          16384: (r) Refused
          32768: (0) No other; continue
    - id: Q4S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q4.outcome & 4096 > 0
        hint: Asked only when Q4 includes "(13) Other".
      - predicate: not (Q4.outcome & 8192 > 0 or Q4.outcome & 16384 > 0 or Q4.outcome & 32768 > 0)
        hint: Not asked when Q4 includes Don't know, Refused or No other.
      input:
        control: Textarea
        maxLength: 28
    - id: Q5
      kind: Question
      title: In what country were you born? (Report place of birth according to current boundaries)
      input:
        control: Radio
        labels:
          1: (1) Canada
          3: (3) Country outside Canada
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s23_birthplace
    title: Place of birth and arrival in Canada
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (Q5.outcome in [98, 99])
      hint: Asked only when question Q5 is none of "(x) Don’t know", "(r) Refused".
    items:
    - id: Q6A
      kind: Question
      title: In which province or territory? (Report place of birth according to current boundaries)
      precondition:
      - predicate: not (Q5.outcome == 3)
        hint: Asked only when question Q5 is not "(3) Country outside Canada".
      input:
        control: Dropdown
        labels:
          1: (1) Newfoundland/Labrador
          2: (2) Prince Edward Island
          3: (3) Nova Scotia
          4: (4) New Brunswick
          5: (5) Quebec
          6: (6) Ontario
          7: (7) Manitoba
          8: (8) Saskatchewan
          9: (9) Alberta
          10: (10) British Columbia
          11: (11) Yukon Territory
          12: (12) Northwest Territories
          13: (13) Nunavut
    - id: Q6B
      kind: Question
      title: In which country? (Report place of birth according to current boundaries)
      input:
        control: Dropdown
        labels:
          1: (1) China
          2: (2) England
          3: (3) France
          4: (4) Germany
          5: (5) Greece
          6: (6) Guyana
          7: (7) Hong Kong
          8: (8) India
          9: (9) Italy
          10: (10) Jamaica
          11: (11) Netherlands
          12: (12) Philippines
          13: (13) Poland
          14: (14) Portugal
          15: (15) Scotland
          16: (16) United States
          17: (17) Vietnam
          18: (18) Other
          98: (x) Don’t know
          99: (r) Refused
    - id: Q6S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q6B.outcome == 18
        hint: Asked only when question Q6B is "(18) Other".
      input:
        control: Textarea
        maxLength: 28
    - id: Q7
      kind: Question
      title: 'In what year did you first come to Canada to live permanently? ( For respondents who first came to Canada as landed immigrants, report the year they obtained landed immigrant status. For respondents who lived in Canada as foreign students, foreign workers, or refugee claimants prior to obtaining landed immigrant status, report the year they first came to Canada to live permanently. If the respondent was born outside of Canada of Canadian parents and was registered as Canadian at birth, report as “Canadian citizen by birth”.) [CATI: 1900-1999]'
      postcondition:
      - predicate: Q7.outcome in [1, 998, 999] or Q7.outcome > YEAR_OF_BIRTH.outcome
        hint: El año en que llegó a Canadá (Q7) debe ser posterior a su año de nacimiento; corrija Q7 o el año de nacimiento.
      input:
        control: Editbox
        min: 1
        max: 999999
        left: 'Year (1900-1999); or 1 = Canadian citizen by birth, 998 = Don’t know, 999 = Refused:'
  - id: b_s23_parents
    title: Parents' origin and education
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q8
      kind: Question
      title: In what country was your mother born?
      input:
        control: Dropdown
        labels:
          0: (0) Canada
          1: (1) China
          2: (2) England
          3: (3) France
          4: (4) Germany
          5: (5) Greece
          6: (6) Guyana
          7: (7) Hong Kong
          8: (8) India
          9: (9) Italy
          10: (10) Jamaica
          11: (11) Netherlands
          12: (12) Philippines
          13: (13) Poland
          14: (14) Portugal
          15: (15) Scotland
          16: (16) United States
          17: (17) Vietnam
          18: (18) Other
          98: (x) Don’t know
          99: (r) Refused
    - id: Q8S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q8.outcome == 18
        hint: Asked only when question Q8 is "(18) Other".
      input:
        control: Textarea
        maxLength: 28
    - id: Q9
      kind: Question
      title: In what country was your father born?
      input:
        control: Dropdown
        labels:
          0: (0) Canada
          1: (1) China
          2: (2) England
          3: (3) France
          4: (4) Germany
          5: (5) Greece
          6: (6) Guyana
          7: (7) Hong Kong
          8: (8) India
          9: (9) Italy
          10: (10) Jamaica
          11: (11) Netherlands
          12: (12) Philippines
          13: (13) Poland
          14: (14) Portugal
          15: (15) Scotland
          16: (16) United States
          17: (17) Vietnam
          18: (18) Other
          98: (x) Don’t know
          99: (r) Refused
    - id: Q9S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q9.outcome == 18
        hint: Asked only when question Q9 is "(18) Other".
      input:
        control: Textarea
        maxLength: 28
    - id: Q9A
      kind: Question
      title: What is the highest level of education that your mother has attained?
      input:
        control: Dropdown
        labels:
          1: (1) Masters (M.A., M.Sc.,M.Ed.) or earned doctorate (Ph.D., D.Sc., D.Ed.)
          2: (2) Degree in Medicine, Dentistry, Veterinary Medicine, or Optometry (M.D., D.D.S., D.M.D., D.V.M., O.D.)
          3: (3) Bachelor or undergraduate degree, or teacher's college (B.A., B.Sc., B.A.Sc., B.Ed.)
          4: (4) Diploma or certificate from community college, CEGEP or nursing school
          5: (5) Diploma or certificate from trade, technical or vocational school, or business college
          6: (6) Some university
          7: (7) Some community college, CEGEP or nursing school
          8: (8) Some trade, technical or vocational school, or business college
          9: (9) High School diploma
          10: (10) Some High School
          11: (11) Elementary School diploma
          12: (12) Some Elementary
          13: (13) No schooling
          14: (14) Other
          98: (x) Don’t know
          99: (r) Refused
    - id: Q9AS
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q9A.outcome == 14
        hint: Asked only when question Q9A is "(14) Other".
      input:
        control: Textarea
        maxLength: 28
    - id: Q9B
      kind: Question
      title: What is the highest level of education that your father has attained?
      input:
        control: Dropdown
        labels:
          1: (1) Masters (M.A., M.Sc.,M.Ed.) or earned doctorate (Ph.D., D.Sc., D.Ed.)
          2: (2) Degree in Medicine, Dentistry, Veterinary Medicine, or Optometry (M.D., D.D.S., D.M.D., D.V.M., O.D.)
          3: (3) Bachelor or undergraduate degree, or teacher's college (B.A., B.Sc., B.A.Sc., B.Ed.)
          4: (4) Diploma or certificate from community college, CEGEP or nursing school
          5: (5) Diploma or certificate from trade, technical or vocational school, or business college
          6: (6) Some university
          7: (7) Some community college, CEGEP or nursing school
          8: (8) Some trade, technical or vocational school, or business college
          9: (9) High School diploma
          10: (10) Some High School
          11: (11) Elementary School diploma
          12: (12) Some Elementary
          13: (13) No schooling
          14: (14) Other
          98: (x) Don’t know
          99: (r) Refused
    - id: Q9BS
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q9B.outcome == 14
        hint: Asked only when question Q9B is "(14) Other".
      input:
        control: Textarea
        maxLength: 28
  - id: b_s23_partner
    title: Spouse / partner
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (HOUSEHOLD_ROSTER_PARTNER.outcome == 3)
      hint: Asked only when question HOUSEHOLD_ROSTER_PARTNER is not "Not currently married, living common-law or with a same-sex partner".
    items:
    - id: Q10
      kind: Question
      title: 'During the past 12 months, was your spouse’s/partner’s main activity working at a paid job or business, looking for paid work, going to school, caring for children, household work, retired or something else? INT: If sickness or short-term illness is reported, ask for usual major activity'
      precondition:
      - predicate: HOUSEHOLD_ROSTER_PARTNER.outcome == 1
        hint: Asked only when question HOUSEHOLD_ROSTER_PARTNER is "Currently married, living common-law or same-sex partner".
      input:
        control: Radio
        labels:
          1: (1) Working at a paid job or business
          2: (2) Looking for paidwork
          3: (3) Going to school
          4: (4) Caring for children
          5: (5) Household work
          6: (6) Retired
          7: (7) Maternity/paternity leave
          8: (8) Long term illness
          9: (9) Other, specify
          99: (r) Refused
    - id: Q10S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q10.outcome == 9
        hint: Asked only when question Q10 is "(9) Other, specify".
      input:
        control: Textarea
        maxLength: 28
    - id: Q11
      kind: Question
      title: Was he/she studying full-time or part-time?
      precondition:
      - predicate: not (Q10.outcome == 1)
        hint: Asked only when question Q10 is not "(1) Working at a paid job or business".
      - predicate: not (Q10.outcome in [2, 4, 5, 6, 7, 8, 99])
        hint: Asked only when question Q10 is none of "(2) Looking for paidwork", "(4) Caring for children", "(5) Household work", "(6) Retired", "(7) Maternity/paternity leave", "(8) Long term illness", "(r) Refused".
      input:
        control: Radio
        labels:
          1: (1) Full-time
          3: (3) Part-time
          98: (x) Don’t know
          99: (r) Refused
    - id: Q12
      kind: Question
      title: Did he/she have a job or was he/she self-employed at any time during the past 12 months?
      precondition:
      - predicate: not (Q10.outcome == 1)
        hint: Asked only when question Q10 is not "(1) Working at a paid job or business".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: Q13
      kind: Question
      title: 'How many weeks did he/she work? [CATI: 1-52]'
      precondition:
      - predicate: not (Q12.outcome in [3, 98, 99])
        hint: Asked only when question Q12 is none of "(3) No", "(x) Don’t know", "(r) Refused".
      input:
        control: Editbox
        min: 1
        max: 999
        left: 'Weeks (1-52); or 998 = Don’t know, 999 = Refused:'
    - id: Q14
      kind: Question
      title: Was he/she working full-time or part-time?
      precondition:
      - predicate: not (Q12.outcome in [3, 98, 99])
        hint: Asked only when question Q12 is none of "(3) No", "(x) Don’t know", "(r) Refused".
      input:
        control: Radio
        labels:
          1: (1) Full-time
          3: (3) Part-time
          98: (x) Don’t know
          99: (r) Refused
    - id: Q15
      kind: Question
      title: During the past 12 months, was he/she ever without a job AND looking for work?
      precondition:
      - predicate: not (Q12.outcome in [3, 98, 99])
        hint: Asked only when question Q12 is none of "(3) No", "(x) Don’t know", "(r) Refused".
      - predicate: not (Q13.outcome == 52)
        hint: Asked only when question Q13 is not 52.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: Q18
      kind: Question
      title: What is the highest level of education that he/she has attained?
      input:
        control: Dropdown
        labels:
          1: (1) Masters (M.A., M.Sc.,M.Ed.) or earned doctorate (Ph.D., D.Sc., D.Ed.)
          2: (2) Degree in Medicine, Dentistry, Veterinary Medicine, or Optometry (M.D., D.D.S., D.M.D., D.V.M., O.D.)
          3: (3) Bachelor or undergraduate degree, or teacher's college (B.A., B.Sc., B.A.Sc., B.Ed.)
          4: (4) Diploma or certificate from community college, CEGEP or nursing school
          5: (5) Diploma or certificate from trade, technical or vocational school, or business college
          6: (6) Some university
          7: (7) Some community college, CEGEP or nursing school
          8: (8) Some trade, technical or vocational school, or business college
          9: (9) High School diploma
          10: (10) Some High School
          11: (11) Elementary School diploma
          12: (12) Some Elementary
          13: (13) No schooling
          14: (14) Other
          98: (x) Don’t know
          99: (r) Refused
    - id: Q18S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q18.outcome == 14
        hint: Asked only when question Q18 is "(14) Other".
      input:
        control: Textarea
        maxLength: 28
    - id: Q19
      kind: Question
      title: 'In the past month, how often did your spouse/partner drink alcoholic beverages. Was it … (Use of alcohol is a measure of a person’s health) INT: READ LIST'
      input:
        control: Radio
        labels:
          1: (1) Every day?
          2: (2) 4-6 times a week?
          3: (3) 2-3 times a week?
          4: (4) Once a week?
          5: (5) Once or twice in the past month?
          6: (6) Never in the past month?
          7: (7) Never drinks?
          98: (x) Don’t know
          99: (r) Refused
    - id: Q20
      kind: Question
      title: 'On how many occasions in the past month, has your spouse/partner had five or more drinks? (Consider a drink to be one beer, one small glass of wine or 1½ oz. of liquor.) [CATI: 0-99]'
      precondition:
      - predicate: not (Q19.outcome in [6, 7, 98, 99])
        hint: Asked only when question Q19 is none of "(6) Never in the past month?", "(7) Never drinks?", "(x) Don’t know", "(r) Refused".
      postcondition:
      - predicate: Q20.outcome in [998, 999] or Q19.outcome not in [4, 5] or (Q19.outcome == 5 and Q20.outcome <= 2) or (Q19.outcome == 4 and Q20.outcome <= 5)
        hint: 'Q20 no puede superar la frecuencia de consumo indicada en Q19 (una vez o dos en el mes: máximo 2; una vez por semana: máximo 5).'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
        left: 'Occasions (0-99); or 998 = Don’t know, 999 = Refused:'
  - id: b_s23_education
    title: Respondent's education
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q21A
      kind: Question
      title: Excluding kindergarten, how many years of elementary and high school education have you successfully completed?
      input:
        control: Dropdown
        labels:
          0: (0) No schooling
          1: (1) One to five years
          6: (6) Six years
          7: (7) Seven years
          8: (8) Eight years
          9: (9) Nine years
          10: (10) Ten years
          11: (11) Eleven years
          12: (12) Twelve years
          13: (13) Thirteen years
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s23_education_further
    title: 'Respondent''s education: further schooling'
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (Q21A.outcome == 0)
      hint: Asked only when question Q21A is not "(0) No schooling".
    items:
    - id: Q21B
      kind: Question
      title: Have you graduated from high school?
      precondition:
      - predicate: not (Q21A.outcome in [1, 6, 7, 8, 9, 10])
        hint: Asked only when question Q21A is none of "(1) One to five years", "(6) Six years", "(7) Seven years", "(8) Eight years", "(9) Nine years", "(10) Ten years".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: Q22
      kind: Question
      title: Have you had any further schooling beyond elementary/high school?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: Q23
      kind: Question
      title: What is the highest level of education that you have attained?
      precondition:
      - predicate: not (Q22.outcome in [3, 99])
        hint: Asked only when question Q22 is none of "(3) No", "(r) Refused".
      input:
        control: Dropdown
        labels:
          1: (1) Masters (M.A., M.Sc.,M.Ed.) or earned doctorate (Ph.D., D.Sc., D.Ed.)
          2: (2) Degree in Medicine, Dentistry, Veterinary Medicine, or Optometry (M.D., D.D.S., D.M.D., D.V.M., O.D.)
          3: (3) Bachelor or undergraduate degree, or teacher's college (B.A., B.Sc., B.A.Sc., B.Ed.)
          4: (4) Diploma or certificate from community college, CEGEP or nursing school
          5: (5) Diploma or certificate from trade, technical or vocational school, or business college
          6: (6) Some university
          7: (7) Some community college, CEGEP or nursing school
          8: (8) Some trade, technical or vocational school, or business college
          9: (9) Other
          98: (x) Don’t know
          99: (r) Refused
    - id: Q23S
      kind: Question
      title: 'Specify ([CATI]: Length of field = 28)'
      precondition:
      - predicate: Q23.outcome == 9
        hint: Asked only when question Q23 is "(9) Other".
      - predicate: not (Q22.outcome in [3, 99])
        hint: Asked only when question Q22 is none of "(3) No", "(r) Refused".
      input:
        control: Textarea
        maxLength: 28
  - id: b_s24_preamble
    title: Household size
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: HHSIZE
      kind: Question
      title: 'Number of household members, taken from the household roster (CATI-Q46e: ''Review household roster - if this is a one person household''; OTHM = Number of household members minus 1). Value comes from the household roster, not from a question in this part.'
      external: true
      input:
        control: Editbox
        min: 1
        max: 30
  - id: b_s24_language
    title: Language
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q24
      kind: Question
      title: 'What language did you first speak in childhood? INT: Accept multiple responses only if languages were learned at the same time. INT: Maximum 4 answers.'
      input:
        control: Checkbox
        labels:
          1: (1) English
          2: (2) French
          4: (13) Arabic
          8: (4) Chinese
          16: (5) German
          32: (11) Greek
          64: (15) Hungarian
          128: (3) Italian
          256: (7) Polish
          512: (6) Portuguese
          1024: (12) Punjabi
          2048: (9) Spanish
          4096: (14) Tagalog (Philipino)
          8192: (8) Ukrainian
          16384: (10) Vietnamese
          32768: (16) Other
          65536: (r) Refused
          131072: (0) No other; continue
    - id: Q24S
      kind: Question
      title: Specify
      precondition:
      - predicate: Q24.outcome & 32768 > 0
        hint: Asked only when Q24 includes "(16) Other".
      - predicate: not (Q24.outcome & 65536 > 0 or Q24.outcome & 131072 > 0)
        hint: Not asked when Q24 is Refused or No other.
      input:
        control: Textarea
    - id: Q24A
      kind: Question
      title: Do you still understand that language?
      precondition:
      - predicate: Q24.outcome & 65534 > 0
        hint: Asked only when Q24 includes a language.
      - predicate: not (Q24.outcome & 65536 > 0 or Q24.outcome & 131072 > 0)
        hint: Not asked when Q24 is Refused or No other.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: Q25
      kind: Question
      title: 'What language do you speak most often at home? INT: Accept multiple responses only if languages are spoken equally. INT: Maximum 4 answers.'
      input:
        control: Checkbox
        labels:
          1: (1) English
          2: (2) French
          4: (12) Arabic
          8: (3) Chinese
          16: (13) Cree
          32: (7) German
          64: (10) Greek
          128: (4) Italian
          256: (8) Polish
          512: (5) Portuguese
          1024: (9) Punjabi
          2048: (6) Spanish
          4096: (14) Tagalog (Philipino)
          8192: (15) Ukrainian
          16384: (11) Vietnamese
          32768: (16) Other
          65536: (r) Refused
          131072: (0) No other; continue
    - id: Q25S
      kind: Question
      title: Specify
      precondition:
      - predicate: Q25.outcome & 32768 > 0
        hint: Asked only when Q25 includes "(16) Other".
      - predicate: not (Q25.outcome & 65536 > 0 or Q25.outcome & 131072 > 0)
        hint: Not asked when Q25 is Refused or No other.
      input:
        control: Textarea
  - id: b_s24_religion
    title: Religion
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q26
      kind: Question
      title: 'What, if any, is your religion? INT: If respondent answers “Protestant”, determine which denomination'
      input:
        control: Dropdown
        labels:
          -3: (n) No religion (Agnostic, Atheist)
          4: (4) Anglican (Church of England, Episcopalian)
          7: (7) Baptist
          13: (13) Buddhist
          9: (9) Eastern Orthodox
          12: (12) Hindu
          11: (11) Islam (Muslim)
          15: (15) Jehovah's Witnesses
          10: (10) Jewish
          6: (6) Lutheran
          8: (8) Pentecostal
          5: (5) Presbyterian
          1: (1) Roman Catholic
          14: (14) Sikh
          2: (2) Ukrainian Catholic
          3: (3) United Church
          16: (16) Other
          -1: (r) Refused
    - id: Q26S
      kind: Question
      title: Specify
      precondition:
      - predicate: Q26.outcome == 16
        hint: Asked only when question Q26 is "(16) Other".
      - predicate: not (Q26.outcome in [-3, -1])
        hint: Asked only when question Q26 is none of "(n) No religion (Agnostic, Atheist)", "(r) Refused".
      input:
        control: Textarea
    - id: Q27
      kind: Question
      title: 'Other than on special occasions, (such as weddings, funerals or baptisms) how often did you attend religious services or meetings in the last 12 months? Was it ... INT: READ LIST'
      precondition:
      - predicate: not (Q26.outcome in [-3, -1])
        hint: Asked only when question Q26 is none of "(n) No religion (Agnostic, Atheist)", "(r) Refused".
      input:
        control: Radio
        labels:
          1: At least once a week?
          2: At least once a month?
          3: A few times a year?
          4: At least once a year?
          5: Not at all?
          -2: Don’t know
          -1: Refused
  - id: b_s24_health
    title: Health
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q29A
      kind: Question
      title: 'Do you have any difficulty hearing, seeing, communicating, walking, climbing stairs, bending, learning, or doing any similar activities? Is it … (Refers to long term health, i.e. a condition lasting or expected to last more than 6 months.) INT: If the respondent suffers from a temporary injury, ask about his/her usual condition. If the respondent wears glasses or corrective lenses or a hearing aid, which completely eliminate any seeing or hearing difficulty, no difficulty should be indicated. INT: READ LIST'
      input:
        control: Radio
        labels:
          1: Sometimes?
          2: Often?
          3: Never?
          -1: Refused
    - id: Q29B
      kind: Question
      title: 'Does a long term physical or mental condition or health problem reduce the amount or the kind of activity that you can do at home, at school, at work or in other activities? Is it … (Refers to long term health, i.e. a condition lasting or expected to last more than 6 months.) INT: If the respondent suffers from a temporary injury, ask about his/her usual condition. INT: READ LIST'
      input:
        control: Radio
        labels:
          1: Sometimes?
          2: Often?
          3: Never?
          -1: Refused
    - id: Q29C
      kind: Question
      title: What is the main condition or health problem that reduces your activities?
      precondition:
      - predicate: Q29B.outcome in [1, 2]
        hint: Asked only when question Q29B is one of "Sometimes?", "Often?".
      - predicate: not (Q29B.outcome in [3, -1])
        hint: Asked only when question Q29B is none of "Never?", "Refused".
      input:
        control: Textarea
    - id: Q30
      kind: Question
      title: Do you regularly have trouble going to sleep or staying asleep?
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: Q31a
      kind: Question
      title: 'During the past month, have you used medication or drugs, (prescription or over the counter) to… INT: READ LIST — a) Help you sleep?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: Q31b
      kind: Question
      title: 'During the past month, have you used medication or drugs, (prescription or over the counter) to… INT: READ LIST — b) Help you calm down?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: Q31c
      kind: Question
      title: 'During the past month, have you used medication or drugs, (prescription or over the counter) to… INT: READ LIST — c) Help you get out of depression?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: Q31A_2
      kind: Question
      title: 'Compared to other people your age, how would you describe your usual state of health? Would you say it is ... (Refers to long term health, i.e. a condition lasting or expected to last more than 6 months.) INT: If the respondent suffers from a temporary injury, ask about his/her usual condition. INT: READ LIST'
      input:
        control: Radio
        labels:
          1: Excellent?
          2: Very good?
          3: Good?
          4: Fair?
          5: Poor?
          -2: Don’t know
          -1: Refused
  - id: b_s24_activity
    title: Main activity
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q32
      kind: Question
      title: During the past 12 months, was your main activity working at a paid job or business, looking for paid work, going to school, caring for children, household work, retired or something else?
      input:
        control: Dropdown
        labels:
          1: Working at a paid job or business
          2: Looking for paid work
          3: Going to school
          4: Caring for children
          5: Household work
          6: Retired
          7: Maternity / paternity leave
          8: Long term illness
          9: Other
          -1: Refused
    - id: Q32S
      kind: Question
      title: Specify
      precondition:
      - predicate: Q32.outcome == 9
        hint: Asked only when question Q32 is "Other".
      input:
        control: Textarea
    - id: Q33
      kind: Question
      title: Were you studying full-time or part-time?
      precondition:
      - predicate: Q32.outcome == 3
        hint: Asked only when question Q32 is "Going to school".
      input:
        control: Radio
        labels:
          1: Full time
          3: Part time
          -1: Refused
    - id: Q34
      kind: Question
      title: Did you have a job or were you self-employed at any time during the past 12 months?
      precondition:
      - predicate: not (Q32.outcome == 1)
        hint: Asked only when question Q32 is not "Working at a paid job or business".
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: Q35
      kind: Question
      title: 'In what year did you last do any paid work? [CATI: 1900-1998]'
      precondition:
      - predicate: Q34.outcome == 3
        hint: Asked only when question Q34 is "No".
      - predicate: not (Q32.outcome == 1)
        hint: Asked only when question Q32 is not "Working at a paid job or business".
      input:
        control: Editbox
        min: 1900
        max: 1998
  - id: b_s24_job
    title: Job details
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    - predicate: not (Q34.outcome == -1)
      hint: Asked only when question Q34 is not "Refused".
    items:
    - id: Q36
      kind: Question
      title: 'For how many weeks during the past 12 months were you employed? (Include vacation, illness, strikes, lock-outs and maternity/paternity leave.) [CATI: 1-52]'
      input:
        control: Editbox
        min: 1
        max: 52
    - id: Q37
      kind: Question
      title: 'How many hours a week did you usually work at all jobs? INT: Round to the nearest whole hour [CATI: 1-168]'
      input:
        control: Editbox
        min: 1
        max: 168
    - id: Q38
      kind: Question
      title: 'Some people do all or some of their paid work at home. Excluding overtime, do you usually work any of your scheduled hours at home? INT: Exclude respondents who occasionally perform some overtime work in their homes.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: Q39
      kind: Question
      title: 'How many paid hours per week do you usually work at home ? INT: Round to the nearest whole hour [CATI: 1-168]'
      precondition:
      - predicate: Q38.outcome == 1
        hint: Asked only when question Q38 is "Yes".
      postcondition:
      - predicate: Q39.outcome <= Q37.outcome
        hint: Paid hours worked at home (Q39) cannot exceed the total hours usually worked per week at all jobs (Q37).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 168
    - id: Q40
      kind: Question
      title: For whom did you work the longest time during the past 12 months? (Name of business, government department or agency, or person)
      input:
        control: Textarea
    - id: Q41
      kind: Question
      title: 'What kind of business, industry or service was this? (Give full description: e.g. federal government, canning industry, forestry services)'
      input:
        control: Textarea
    - id: Q42
      kind: Question
      title: 'What kind of work were you doing? (Give full description: e.g. office clerk, factory worker, forestry technician)'
      input:
        control: Textarea
    - id: Q43
      kind: Question
      title: 'In that work, what were your most important activities or duties? (Give full description: e.g. filing documents, drying vegetables, forestry examiner)'
      input:
        control: Textarea
    - id: Q44
      kind: Question
      title: 'Which of the following best describes the hours you usually work at this job? (For respondent''s main job: “On call” means no prearranged schedules, but called as need arises (for example, a substitute teacher). “Irregular schedule” is usually prearranged one week or more in advance (for example, pilots). INT: READ LIST'
      input:
        control: Dropdown
        labels:
          1: A regular daytime schedule or shift
          2: A regular evening shift
          3: A regular night shift
          4: A rotating shift (one that changes periodically from days to evenings or to nights)
          5: A split shift (one consisting of two or more distinct periods each day)
          6: On call or casual
          7: An irregular schedule
          8: Other
          -2: Don’t know
          -1: Refused
    - id: Q44S
      kind: Question
      title: Specify
      precondition:
      - predicate: Q44.outcome == 8
        hint: Asked only when question Q44 is "Other".
      input:
        control: Textarea
  - id: b_s24_income
    title: Income
    precondition:
    - predicate: not (CATI_B14e_VERIFY.outcome == 3)
      hint: Asked only when question CATI-B14e-VERIFY is not "(3) No".
    items:
    - id: Q45
      kind: Question
      title: 'Various measures of income are needed to study the relationship between an individual''s overall economic situation and their safety. What was your main source of income during the past 12 months? INT: Mark one only.'
      input:
        control: Dropdown
        labels:
          0: No income
          1: Employment or self-employment (wages, salaries, commissions and tips)
          2: Employment insurance
          3: Worker’s compensation
          4: Benefits from Canada or Quebec Pension Plan
          5: Retirement pensions, superannuation and annuities
          6: Basic Old Age Security
          7: Guaranteed Income Supplement or Spouse’s Allowance
          8: Child Tax Benefit
          9: Provincial or municipal social assistance or welfare
          10: Child Support/Alimony
          11: Other Income (eg. Rental income, scholarships, other government income, dividends and interest on bonds, deposits and savings, stocks, mutual funds, etc.)
          -2: Don’t know
          -1: Refused
    - id: Q46
      kind: Question
      title: What is your best estimate of your total personal income, before deductions, FROM ALL SOURCES during the past 12 months? $ (-3 = No income or loss, -2 = Don’t know, -1 = Refused)
      precondition:
      - predicate: Q45.outcome != 0
        hint: Asked only when question Q45 is not "No income".
      - predicate: not (Q45.outcome == 0 and HHSIZE.outcome > 1)
        hint: Source-derived condition on Q45 and HHSIZE.
      input:
        control: Editbox
        min: -3
        max: 9999999
        left: $
    - id: Q47
      kind: Question
      title: Not including yourself, how many other household members received income from any source, during the past 12 months? [CATI 1-OTHM] (OTHM = Number of household members minus 1) (0 = No one else, -1 = Refused)
      precondition:
      - predicate: HHSIZE.outcome > 1
        hint: Asked only for households of more than one member.
      input:
        control: Editbox
        min: -1
        max: 30
    - id: Q48A
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: Q47.outcome > 0
        hint: Asked only when other household members received income.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 19999 and Q46.outcome < 40000)
        hint: Not asked when personal income is $20,000 to $39,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 39999 and Q46.outcome < 60000)
        hint: Not asked when personal income is $40,000 to $59,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 59999 and Q46.outcome < 80000)
        hint: Not asked when personal income is $60,000 to $79,999.
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      input:
        control: Radio
        labels:
          1: Less than $20,000?
          2: $20,000 and more?
          0: No income or loss
          -2: Don’t know
          -1: Refused
    - id: Q48B
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 19999 and Q46.outcome < 40000)
        hint: Not asked when personal income is $20,000 to $39,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 39999 and Q46.outcome < 60000)
        hint: Not asked when personal income is $40,000 to $59,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 59999 and Q46.outcome < 80000)
        hint: Not asked when personal income is $60,000 to $79,999.
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      - predicate: not (Q48A.outcome == 2)
        hint: Asked only when question Q48A is not "$20,000 and more?".
      input:
        control: Radio
        labels:
          1: Less than $10,000?
          2: $10,000 and more?
          -2: Don’t know
          -1: Refused
    - id: Q48C
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 19999 and Q46.outcome < 40000)
        hint: Not asked when personal income is $20,000 to $39,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 39999 and Q46.outcome < 60000)
        hint: Not asked when personal income is $40,000 to $59,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 59999 and Q46.outcome < 80000)
        hint: Not asked when personal income is $60,000 to $79,999.
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      - predicate: not (Q48A.outcome == 2)
        hint: Asked only when question Q48A is not "$20,000 and more?".
      - predicate: not (Q48B.outcome == 2)
        hint: Asked only when question Q48B is not "$10,000 and more?".
      input:
        control: Radio
        labels:
          1: Less than $5,000?
          2: $5,000 and more?
          -2: Don’t know
          -1: Refused
    - id: Q48D
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 19999 and Q46.outcome < 40000)
        hint: Not asked when personal income is $20,000 to $39,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 39999 and Q46.outcome < 60000)
        hint: Not asked when personal income is $40,000 to $59,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 59999 and Q46.outcome < 80000)
        hint: Not asked when personal income is $60,000 to $79,999.
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      - predicate: not (Q48A.outcome == 2)
        hint: Asked only when question Q48A is not "$20,000 and more?".
      input:
        control: Radio
        labels:
          1: Less than $15,000?
          2: $15,000 and more?
          -2: Don’t know
          -1: Refused
    - id: Q48E
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 39999 and Q46.outcome < 60000)
        hint: Not asked when personal income is $40,000 to $59,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 59999 and Q46.outcome < 80000)
        hint: Not asked when personal income is $60,000 to $79,999.
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      input:
        control: Radio
        labels:
          1: Less than $40,000?
          2: $40,000 and more?
          -2: Don’t know
          -1: Refused
    - id: Q48F
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 39999 and Q46.outcome < 60000)
        hint: Not asked when personal income is $40,000 to $59,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 59999 and Q46.outcome < 80000)
        hint: Not asked when personal income is $60,000 to $79,999.
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      - predicate: not (Q48E.outcome == 2)
        hint: Asked only when question Q48E is not "$40,000 and more?".
      input:
        control: Radio
        labels:
          1: Less than $30,000?
          2: $30,000 and more?
          -2: Don’t know
          -1: Refused
    - id: Q48G
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 39999 and Q46.outcome < 60000)
        hint: Not asked when personal income is $40,000 to $59,999.
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 59999 and Q46.outcome < 80000)
        hint: Not asked when personal income is $60,000 to $79,999.
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      input:
        control: Radio
        labels:
          1: Less than $50,000?
          2: $50,000 and more?
          -2: Don’t know
          -1: Refused
    - id: Q48H
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: not (Q47.outcome > 0 and Q46.outcome > 59999 and Q46.outcome < 80000)
        hint: Not asked when personal income is $60,000 to $79,999.
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      input:
        control: Radio
        labels:
          1: Less than $60,000?
          2: $60,000 and more?
          -2: Don’t know
          -1: Refused
    - id: Q48J
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      precondition:
      - predicate: not (Q47.outcome > 0 and Q45.outcome != 0 and (Q46.outcome == 0 or Q46.outcome > 79999))
        hint: Not asked when personal income is $80,000 or more.
      input:
        control: Radio
        labels:
          1: Less than $80,000?
          2: $80,000 and more?
          -2: Don’t know
          -1: Refused
    - id: Q48K
      kind: Question
      title: 'What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income... INT: READ LIST'
      input:
        control: Radio
        labels:
          1: Less than $100,000?
          2: $100,000 and more?
          -2: Don’t know
          -1: Refused
  - id: b_s25_preamble
    title: Crime incident report setup
    items:
    - id: VSCRNO
      kind: Question
      title: 'VSCRNO: the screener question the incident refers to (e.g. ''B8A'', ''B9'', ''B10'', ''B11A'', ''B12'', ''B13'' = physical attack, sexual assault or unwanted sexual touching; ''B8B'', ''B11B'' = threats). Value comes from the screening section / Filler1 to Filler13, not from a question in this part.'
      external: true
      input:
        control: Radio
        labels:
          1: B8A
          2: B8B
          3: B9
          4: B10
          5: B11A
          6: B11B
          7: B12
          8: B13
          9: Other screener item
  - id: b_s25_when
    title: 'SECTION V: CRIME INCIDENT REPORT - Timing'
    items:
    - id: V1
      kind: Question
      title: You said that during the past 12 months . . . [Filler1 to Filler13 - refers to appropriate screen question for description of incident]. In what month did (this/the most recent/the next most recent) incident happen?
      input:
        control: Dropdown
        labels:
          -3: Not in the past 12 months
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
          -2: Don't know
          -1: Refused
    - id: V1A
      kind: Question
      title: Did this happen in the past 12 months?
      precondition:
      - predicate: V1.outcome in [-2, -1]
        hint: Asked only when question V1 is Don't know or Refused.
      - predicate: not (V1.outcome == -3)
        hint: Asked only when question V1 is not 'Not in the past 12 months'.
      - predicate: not (V1.outcome > 0)
        hint: Asked only when no month was given in V1.
      input:
        control: Radio
        labels:
          1: Yes (will continue with incident report)
          3: 'No'
          5: Yes, but refuses to talk about incident
          -2: Don't know
          -1: Refused
  - id: b_s25_incident
    title: 'SECTION V: CRIME INCIDENT REPORT - Incident details'
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when question V1 is not 'Not in the past 12 months'.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when question V1A is none of No, Yes but refuses, Don't know, Refused.
    items:
    - id: V2
      kind: Question
      title: 'Where did this incident take place? For example, was it at home, on the street, at work or at school? INT: If work, ask: Where was your place of work at the time? For example, was it an office building, factory or school?'
      input:
        control: Dropdown
        labels:
          1: Inside respondent's own home/apartment
          2: Inside a vacation property (includes surrounding areas)
          3: Inside garage or other building on respondent's property
          4: Outside respondent's home, apartment, including yard, farm field, driveway, parking lot or in shared areas related to home such as apartment hallway or laundry room
          5: Offender’s home (in or around)
          6: Other Private Residence or Farm (in or around)
          7: In a restaurant or bar
          8: Inside school or on school grounds
          9: In a commercial or office building, a factory, a store, or a shopping mall
          10: In a hospital, prison or rehabilitation centre
          11: On public transportation
          12: In a parking garage or parking lot other than the respondent's
          13: On sidewalk/street/highway in respondent's neighbourhood
          14: On any other sidewalk/street/highway
          15: In a rural area or park (include national, provincial or local park, or conservation area)
          16: Other
          -1: Refused
    - id: V2S
      kind: Question
      title: Specify
      precondition:
      - predicate: V2.outcome == 16
        hint: Asked only when V2 is Other.
      - predicate: not (V2.outcome == 1)
        hint: Asked only when V2 is not the respondent's own home.
      - predicate: not (V2.outcome in [2, 3])
        hint: Asked only when V2 is not a vacation property or garage/building on the respondent's property.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      input:
        control: Textarea
    - id: V3
      kind: Question
      title: Was that the same dwelling that you are living in now?
      precondition:
      - predicate: V2.outcome == 1
        hint: Asked only when V2 is the respondent's own home/apartment.
      - predicate: not (V2.outcome in [2, 3])
        hint: Asked only when V2 is not a vacation property or garage/building on the respondent's property.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: V4
      kind: Question
      title: 'What type of dwelling were you living in at the time of this incident? Was it a . . . INT: READ LIST'
      precondition:
      - predicate: V3.outcome in [3, -1]
        hint: Asked only when V3 is No or Refused.
      - predicate: not (V2.outcome in [2, 3])
        hint: Asked only when V2 is not a vacation property or garage/building on the respondent's property.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      - predicate: not (V3.outcome == 1)
        hint: Asked only when V3 is not Yes.
      input:
        control: Radio
        labels:
          1: Single detached house?
          2: Semi-detached or double (side-by-side)?
          3: Garden house, town-house or row house?
          4: Duplex (one above the other)?
          5: Low-rise apartment (less than 5 stories)?
          6: High-rise apartment (5 or more stories)?
          7: Mobile home or trailer?
          8: Other?
          -1: Refused
    - id: V4S
      kind: Question
      title: Specify
      precondition:
      - predicate: V4.outcome == 8
        hint: Asked only when V4 is Other.
      - predicate: not (V2.outcome in [2, 3])
        hint: Asked only when V2 is not a vacation property or garage/building on the respondent's property.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      - predicate: not (V3.outcome == 1)
        hint: Asked only when V3 is not Yes.
      - predicate: not (V4.outcome != 8)
        hint: Asked only when V4 is Other.
      input:
        control: Textarea
    - id: V5
      kind: Question
      title: 'At the time of the incident, did the person(s) who committedthe act live with you? INT: If more than one person and at least one lived with respondent select yes (1)'
      precondition:
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -2: Don’t know
          -1: Refused
    - id: V6
      kind: Question
      title: 'Did someone let them in? (Example: guests, workmen) INT: If respondent advises you that the incident was a threat by telephone or mail, select "No" at this item and option 5 at item V7.'
      precondition:
      - predicate: V5.outcome == 3
        hint: Asked only when V5 is No.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      - predicate: not (V5.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V5 and the screener item.
      - predicate: not (V5.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V5 and the screener item.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -2: Don’t know
          -1: Refused
    - id: V7
      kind: Question
      title: 'Did the person(s) who committed the act actually get in or justtry to get in? INT: For apartments and multi-unit structures, determine if there was an actual or attempted entry of the respondent’s unit. Do not include entry to other parts of the building, such as the lobby.'
      precondition:
      - predicate: V6.outcome == 3
        hint: Asked only when V6 is No.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      - predicate: not (V5.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V5 and the screener item.
      - predicate: not (V5.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V5 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V6 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V6 and the screener item.
      input:
        control: Radio
        labels:
          1: Actually got in
          3: Tried to get in
          5: Threat received by telephone, mail, or e-mail
          -2: Don't know
          -1: Refused
    - id: V8
      kind: Question
      title: Was there any evidence, such as a broken lock or window, that the person(s) forced/tried to force his/her way in?
      precondition:
      - predicate: V7.outcome != 5
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      - predicate: not (V5.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V5 and the screener item.
      - predicate: not (V5.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V5 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V6 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V6 and the screener item.
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -2: Don’t know
          -1: Refused
    - id: V8A
      kind: Question
      title: 'What was the evidence? INT: Mark all that apply.'
      precondition:
      - predicate: V8.outcome == 1
        hint: Asked only when V8 is Yes.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      - predicate: not (V5.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V5 and the screener item.
      - predicate: not (V5.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V5 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V6 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V6 and the screener item.
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (V8.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V8 and the screener item.
      - predicate: not (V8.outcome in [3, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V8 and the screener item.
      input:
        control: Checkbox
        labels:
          1: (1) Broken lock or forced door
          2: (2) Broken or forced window
          4: (3) Other
          8: (r) Refused
          16: (0) No other; continue
    - id: V8S
      kind: Question
      title: Specify
      precondition:
      - predicate: V8A.outcome & 4 > 0
        hint: Asked only when 'Other' was marked in V8A.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V2 and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      - predicate: not (V5.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V5 and the screener item.
      - predicate: not (V5.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V5 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V6 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V6 and the screener item.
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (V8.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V8 and the screener item.
      - predicate: not (V8.outcome in [3, -2, -1] and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V8 and the screener item.
      - predicate: not (V8A.outcome & 4 == 0 and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V8A and the screener item.
      - predicate: not (V8A.outcome & 4 == 0 and not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8]))
        hint: Routing check on V8A and the screener item.
      input:
        control: Textarea
    - id: V9
      kind: Question
      title: Were you present at any time during the incident?
      precondition:
      - predicate: not (VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Asked only when VSCRNO is none of B8A, B9, B10, B11A, B12, B13.
      - predicate: not (not (V2.outcome in [1, 2, 3, 16]) and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V2 and the screener item.
      - predicate: not (V5.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V5 and the screener item.
      - predicate: not (V6.outcome in [1, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V6 and the screener item.
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (V8.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V8 and the screener item.
      - predicate: not (V8A.outcome & 4 == 0 and VSCRNO.outcome in [1, 3, 4, 5, 7, 8])
        hint: Routing check on V8A and the screener item.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: V10
      kind: Question
      title: Did the person(s) who committed the act have a weapon, suchas a gun or knife or something he/she was using as a weapon,such as a rock or bottle?
      precondition:
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (V9.outcome == 3 and VSCRNO.outcome in [2, 6])
        hint: Routing check on V9 and the screener item.
      - predicate: not (V9.outcome == 3 and not (VSCRNO.outcome in [2, 6]))
        hint: Routing check on V9 and the screener item.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -2: Don’t know
          -1: Refused
    - id: V10A
      kind: Question
      title: 'What type of weapon? INT: Mark all that apply.'
      precondition:
      - predicate: V10.outcome == 1
        hint: Asked only when V10 is Yes.
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (V9.outcome == 3 and VSCRNO.outcome in [2, 6])
        hint: Routing check on V9 and the screener item.
      - predicate: not (V9.outcome == 3 and not (VSCRNO.outcome in [2, 6]))
        hint: Routing check on V9 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      input:
        control: Checkbox
        labels:
          1: (1) Gun
          2: (2) Knife
          4: (3) Other
          8: (x) Don’t know
          16: (r) Refused
          32: (0) No other; continue
    - id: V10S
      kind: Question
      title: Specify
      precondition:
      - predicate: V10A.outcome & 4 > 0
        hint: Asked only when 'Other' was marked in V10A.
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (V9.outcome == 3 and VSCRNO.outcome in [2, 6])
        hint: Routing check on V9 and the screener item.
      - predicate: not (V9.outcome == 3 and not (VSCRNO.outcome in [2, 6]))
        hint: Routing check on V9 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10A and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10A and the screener item.
      input:
        control: Textarea
    - id: V11
      kind: Question
      title: 'An assault can be anything from being hit, slapped, grabbed or knocked down, to being shot, or beaten. This can also include forced sexual activity and unwanted sexual touching or grabbing. In this incident, were you assaulted in any physical or sexual way? (INT : Consider respondents as having been assaulted if something was thrown at them or if they were shot at but not hit.)'
      precondition:
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (V9.outcome == 3 and VSCRNO.outcome in [2, 6])
        hint: Routing check on V9 and the screener item.
      - predicate: not (V9.outcome == 3 and not (VSCRNO.outcome in [2, 6]))
        hint: Routing check on V9 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10A and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10A and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 5])
        hint: Asked only when VSCRNO is none of B8A, B11A.
      - predicate: not (VSCRNO.outcome in [3, 4, 7, 8])
        hint: Asked only when VSCRNO is none of B9, B10, B12, B13.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: V12
      kind: Question
      title: Did the person(s) threaten you with physical harm in any way?
      precondition:
      - predicate: not (V7.outcome == 5)
        hint: Asked only when V7 is not a threat by telephone, mail or e-mail.
      - predicate: not (V9.outcome == 3 and VSCRNO.outcome in [2, 6])
        hint: Routing check on V9 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10A and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10A and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 5])
        hint: Asked only when VSCRNO is none of B8A, B11A.
      - predicate: not (VSCRNO.outcome in [3, 4, 7, 8])
        hint: Asked only when VSCRNO is none of B9, B10, B12, B13.
      - predicate: not (V11.outcome == 1)
        hint: Asked only when V11 is not Yes.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: V13
      kind: Question
      title: 'How were you threatened? Was it … INT: READ LIST - Mark all that apply.'
      precondition:
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10A and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10A and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 5])
        hint: Asked only when VSCRNO is none of B8A, B11A.
      - predicate: not (VSCRNO.outcome in [3, 4, 7, 8])
        hint: Asked only when VSCRNO is none of B9, B10, B12, B13.
      - predicate: not (V11.outcome == 1)
        hint: Asked only when V11 is not Yes.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
        hint: Routing check on V12 and V9.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome != 3)
        hint: Routing check on V12 and V9.
      input:
        control: Checkbox
        labels:
          1: (1) Face-to-face?
          2: (2) By mail?
          4: (3) By electronic mail?
          8: (4) Over the telephone?
          16: (5) Other
          32: (r) Refused
          64: (0) No other; continue
    - id: V13S
      kind: Question
      title: Specify
      precondition:
      - predicate: V13.outcome & 16 > 0
        hint: Asked only when 'Other' was marked in V13.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10A and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10A and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 5])
        hint: Asked only when VSCRNO is none of B8A, B11A.
      - predicate: not (VSCRNO.outcome in [3, 4, 7, 8])
        hint: Asked only when VSCRNO is none of B9, B10, B12, B13.
      - predicate: not (V11.outcome == 1)
        hint: Asked only when V11 is not Yes.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
        hint: Routing check on V12 and V9.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome != 3)
        hint: Routing check on V12 and V9.
      - predicate: not (V13.outcome & 16 == 0)
        hint: Asked only when 'Other' was marked in V13.
      input:
        control: Textarea
    - id: V14
      kind: Question
      title: Did you think the threat was going to be carried out?
      precondition:
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [1, 5])
        hint: Routing check on V10A and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10A and the screener item.
      - predicate: not (VSCRNO.outcome in [1, 5])
        hint: Asked only when VSCRNO is none of B8A, B11A.
      - predicate: not (VSCRNO.outcome in [3, 4, 7, 8])
        hint: Asked only when VSCRNO is none of B9, B10, B12, B13.
      - predicate: not (V11.outcome == 1)
        hint: Asked only when V11 is not Yes.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
        hint: Routing check on V12 and V9.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome != 3)
        hint: Routing check on V12 and V9.
      input:
        control: Radio
        labels:
          1: 'Yes'
          3: 'No'
          -1: Refused
    - id: V15
      kind: Question
      title: 'How were you assaulted? Again, remember that an assault can include any type of physical or sexual assault, such as being slapped, beaten or being forced into sexual activity or being touched or grabbed in a sexual way. INT: Mark all that apply. - Probe for multiple answers.'
      precondition:
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10A and the screener item.
      - predicate: not (VSCRNO.outcome in [3, 4, 7, 8])
        hint: Asked only when VSCRNO is none of B9, B10, B12, B13.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
        hint: Routing check on V12 and V9.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome != 3)
        hint: Routing check on V12 and V9.
      postcondition:
      - predicate: V15.outcome & 1 == 0 or V15.outcome == 1
        hint: '''Not attacked/assaulted'' (V15) cannot be combined with any type of assault; choose either that option or the assault types.'
        invented: true
      input:
        control: Checkbox
        labels:
          1: (n) Not attacked/assaulted
          2: (1) Forced or attempted forced sexual assault by being threatened, held down or hurt in some way
          4: (2) Unwanted sexual touching, grabbing, kissing or fondling
          8: (3) Shot, knifed or hit with object held in hand
          16: (4) Hit, kicked, slapped, knocked down
          32: (5) Grabbed, held, tripped, jumped, pushed
          64: (6) Other
          128: (r) Refused
          256: (0) No other; continue
    - id: V15S
      kind: Question
      title: Specify
      precondition:
      - predicate: V15.outcome & 64 > 0
        hint: Asked only when 'Other' was marked in V15.
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10 and the screener item.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Routing check on V10A and the screener item.
      - predicate: not (VSCRNO.outcome in [3, 4, 7, 8])
        hint: Asked only when VSCRNO is none of B9, B10, B12, B13.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
        hint: Routing check on V12 and V9.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome != 3)
        hint: Routing check on V12 and V9.
      - predicate: not (V15.outcome & 4 > 0)
        hint: Routing check on V15.
      input:
        control: Textarea
  - id: b_s26_p1_pre
    title: 'Incident follow-up: setup'
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    items:
    - id: VSCRNO_2
      kind: Question
      title: 'VSCRNO: crime incident type code from the screener (B1, B3, B4A, B4B, B4C, B6A, B6B, B7, B8A, B9, B10, B11A, B12, B13); external value from the screening section, not asked here. Numeric values are only the ordinal position of the printed code.'
      external: true
      precondition:
      - predicate: not (V10.outcome in [3, -2, -1] and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Not asked when the V10 answer excludes this screener type.
      - predicate: not (V10A.outcome & 4 == 0 and VSCRNO.outcome in [3, 4, 7, 8])
        hint: Not asked when V10A excludes this screener type.
      - predicate: not (VSCRNO.outcome in [3, 4, 7, 8])
        hint: Asked only when VSCRNO is none of B9, B10, B12, B13.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
        hint: Not asked for this V12 and V9 combination.
      - predicate: not (V12.outcome in [3, -1] and V9.outcome != 3)
        hint: Not asked for this V12 and V9 combination.
      - predicate: not (V15.outcome & 4 > 0)
        hint: Not asked when V15 includes the option coded 4.
      input:
        control: Dropdown
        labels:
          1: B1
          2: B3
          3: B4A
          4: B4B
          5: B4C
          6: B6A
          7: B6B
          8: B7
          9: B8A
          10: B9
          11: B10
          12: B11A
          13: B12
          14: B13
  - id: b_s26_p1_hospital
    title: Injury and medical attention
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
      hint: Not asked for this V12 and V9 combination.
    - predicate: not (V12.outcome in [3, -1] and V9.outcome != 3)
      hint: Not asked for this V12 and V9 combination.
    - predicate: not (V15.outcome & 4 > 0)
      hint: Not asked when V15 includes the option coded 4.
    items:
    - id: V16
      kind: Question
      title: Were you physically injured in any way?
      postcondition:
      - predicate: not (V11.outcome == 1 and V15.outcome == 0)
        hint: 'You said in V11 that you were attacked but V15 does not say how: correct V11 or V15.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V17
      kind: Question
      title: Did you receive any medical attention at a hospital as a result of this incident? (Include treatment received at emergency or as an out-patient.)
      precondition:
      - predicate: not (V16.outcome in [3, 99])
        hint: Asked only when V16 is none of No, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V17A
      kind: Question
      title: Did you stay in hospital overnight?
      precondition:
      - predicate: not (V16.outcome in [3, 99])
        hint: Asked only when V16 is none of No, Refused.
      - predicate: not (V17.outcome in [3, 99])
        hint: Asked only when V17 is none of No, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V17B
      kind: Question
      title: 'For how many nights? |__|__|__| [CATI: 1-500]'
      precondition:
      - predicate: not (V16.outcome in [3, 99])
        hint: Asked only when V16 is none of No, Refused.
      - predicate: not (V17.outcome in [3, 99])
        hint: Asked only when V17 is none of No, Refused.
      - predicate: not (V17A.outcome in [3, 99])
        hint: Asked only when V17A is none of No, Refused.
      input:
        control: Editbox
        min: -9
        max: 500
        left: (-9 = Refused)
    - id: V18
      kind: Question
      title: Did you receive any medical attention from a doctor or a nurse? (Include medical attention received immediately after the attack as well as any follow-up medical attention received as a result of the injuries.)
      precondition:
      - predicate: not (V16.outcome in [3, 99])
        hint: Asked only when V16 is none of No, Refused.
      - predicate: not (V17A.outcome in [3, 99])
        hint: Asked only when V17A is none of No, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s26_p1_effects
    title: Effects and alcohol or drug use
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
      hint: Not asked for this V12 and V9 combination.
    items:
    - id: V19
      kind: Question
      title: As a result of this incident (and excluding any time you spent in the hospital), did you have to stay in bed for all or most of a day? (Include time spent in bed for injuries as well as for stress reasons. Six hours in bed equals one day.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V19A
      kind: Question
      title: 'For how many days? INT: Consider one day to be 6 hours over and above the respondent’s normal hours of sleeping |__|__|__| [CATI: 1-100]'
      precondition:
      - predicate: not (V19.outcome in [3, 99])
        hint: Asked only when V19 is none of No, Refused.
      input:
        control: Editbox
        min: -9
        max: 100
        left: (-9 = Refused)
    - id: V20A
      kind: Question
      title: In your opinion, was this incident related to the person’s alcohol or drug use?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V20B
      kind: Question
      title: (In your opinion, was this incident related to) your own alcohol or drug use?
      precondition:
      - predicate: not ((VSCRNO_2.outcome in [1, 2, 3, 4, 5, 6, 7, 8] or (VSCRNO_2.outcome in [9, 12] and V15.outcome == 0)) and (V12.outcome in [3, 99] or (V12.outcome == 1 and (V13.outcome != 1 or V14.outcome != 1))))
        hint: Not asked for this incident type and V12, V13, V14 combination.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V21
      kind: Question
      title: 'Was only one person involved in committing the act? INT: Select (x) “don’t know” if the respondent is unsure or guesses about the number of offenders.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s26_p1_single
    title: Single offender
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
      hint: Not asked for this V12 and V9 combination.
    - predicate: not (V21.outcome == 3)
      hint: Asked only when V21 is not No.
    - predicate: not (V21.outcome in [98, 99])
      hint: Asked only when V21 is none of Don't know, Refused.
    items:
    - id: V22
      kind: Question
      title: Was the person male or female?
      input:
        control: Radio
        labels:
          1: (1) Male
          2: (2) Female
          98: (x) Don’t know
          99: (r) Refused
    - id: V23
      kind: Question
      title: 'How old would you say the person was? |__|__| [CATI: 1-95]'
      input:
        control: Editbox
        min: -9
        max: 95
        left: (-8 = Don’t know, -9 = Refused)
    - id: V24
      kind: Question
      title: 'What was the person''s relationship to you? INT: Record relationship at time of incident (not necessarily current relationship).'
      input:
        control: Dropdown
        labels:
          1: (1) Mother
          2: (2) Father
          3: (3) Mother-in-law
          4: (4) Father-in-law
          5: (5) Step-mother
          6: (6) Step-father
          7: (7) Son
          8: (8) Daughter
          9: (9) Son-in-law
          10: (10) Daughter-in-law
          11: (11) Brother
          12: (12) Sister
          13: (13) Spouse/partner
          14: (14) Ex-spouse/ex-partner
          15: (15) Other family member
          16: (16) Boyfriend/girlfriend
          17: (17) Ex-boyfriend/ex-girlfriend
          18: (18) Neighbour
          19: (19) Friend/Casual acquaintance
          20: (20) Co-worker
          21: (21) Known by sight only
          22: (22) Stranger
          23: (23) Other
          99: (r) Refused
    - id: V24S
      kind: Question
      title: 'Specify [CATI]: Length of field = 28'
      precondition:
      - predicate: V24.outcome == 23
        hint: Asked only when V24 is Other.
      input:
        control: Textarea
        maxLength: 28
  - id: b_s26_p1_multi
    title: Several offenders
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    - predicate: not (V12.outcome in [3, -1] and V9.outcome == 3)
      hint: Not asked for this V12 and V9 combination.
    - predicate: not (V21.outcome in [98, 99])
      hint: Asked only when V21 is none of Don't know, Refused.
    - predicate: not (V24.outcome != 23)
      hint: Asked only when V24 is Other.
    items:
    - id: V25
      kind: Question
      title: 'How many people were involved? |__|__| [CATI: 1-95]'
      input:
        control: Editbox
        min: -9
        max: 95
        left: (-8 = Don’t know, -9 = Refused)
    - id: V26
      kind: Question
      title: Were they male or female?
      input:
        control: Radio
        labels:
          1: (1) All male
          2: (2) All female
          3: (3) Both male and female
          98: (x) Don’t know
          99: (r) Refused
    - id: V27
      kind: Question
      title: Were they mostly male or mostly female?
      precondition:
      - predicate: not (V26.outcome in [1, 2, 98, 99])
        hint: Asked only when V26 is none of All male, All female, Don't know, Refused.
      - predicate: not (V25.outcome == 2)
        hint: Asked only when V25 is not 2.
      input:
        control: Radio
        labels:
          1: (1) Mostly male
          2: (2) Mostly female
          3: (3) Evenly divided
          98: (x) Don’t know
          99: (r) Refused
    - id: V28
      kind: Question
      title: 'How old would you say the youngest was? |__|__| [CATI: 1-95]'
      input:
        control: Editbox
        min: -9
        max: 95
        left: (-8 = Don’t know, -9 = Refused)
    - id: V29
      kind: Question
      title: 'How old would you say the oldest was? |__|__| [CATI: 1-95]'
      postcondition:
      - predicate: V28.outcome <= V29.outcome or V28.outcome < 0 or V29.outcome < 0
        hint: 'The age of the youngest offender (V28) cannot be higher than the age of the oldest (V29): correct V28 or V29.'
        invented: true
      input:
        control: Editbox
        min: -9
        max: 95
        left: (-8 = Don’t know, -9 = Refused)
    - id: V30
      kind: Question
      title: 'What was their relationship to you? INT: Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (1) Mother
          2: (2) Father
          4: (3) Mother-in-law
          8: (4) Father-in-law
          16: (5) Step-mother
          32: (6) Step-father
          64: (7) Son
          128: (8) Daughter
          256: (9) Son-in-law
          512: (10) Daughter-in-law
          1024: (11) Brother
          2048: (12) Sister
          4096: (13) Spouse/partner
          8192: (14) Ex-spouse/ex-partner
          16384: (15) Other family member
          32768: (16) Boyfriend/girlfriend
          65536: (17) Ex-boyfriend/ex-girlfriend
          131072: (18) Neighbour
          262144: (19) Friend/Casual acquaintance
          524288: (20) Co-worker
          1048576: (21) Known by sight only
          2097152: (22) Stranger
          4194304: (23) Other
          8388608: (r) Refused
          16777216: (0) No other; continue
    - id: V30S
      kind: Question
      title: 'Specify [CATI]: Length of field = 28'
      precondition:
      - predicate: V30.outcome & 4194304 > 0
        hint: Asked only when V30 includes Other.
      - predicate: not (V30.outcome & 25165824 > 0)
        hint: Not asked when V30 includes Refused or No other.
      input:
        control: Textarea
        maxLength: 28
  - id: b_s26_p1_hate
    title: Hate crime
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    items:
    - id: V31
      kind: Question
      title: '(There is a growing concern in Canada about hate crimes. By this I mean crimes motivated by the offender’s hatred of a person’s sex, ethnicity, race, religion, sexual orientation, age, disability, culture or language.) Do you believe that this incident committed against you could be considered a hate crime? [CATI-V31e: if this is the first time the question is asked read the complete question; else read last sentence only]'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V32
      kind: Question
      title: 'Was this because of the person’s hatred of your… INT: READ LIST. Mark all that apply.'
      precondition:
      - predicate: V31.outcome == 1
        hint: Asked only when V31 is Yes.
      input:
        control: Checkbox
        labels:
          1: (1) Sex?
          2: (2) Race/Ethnicity?
          4: (3) Religion?
          8: (4) Sexual Orientation?
          16: (5) Age?
          32: (6) Disability?
          64: (7) Culture?
          128: (8) Language?
          256: (9) Other
          512: (x) Don’t know
          1024: (r) Refused
          2048: (0) No other; continue
    - id: V32S
      kind: Question
      title: 'Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: V32.outcome & 256 > 0
        hint: Asked only when V32 includes Other.
      - predicate: not (V32.outcome & 3584 > 0)
        hint: Not asked when V32 includes Don't know, Refused or No other.
      input:
        control: Textarea
        maxLength: 50
  - id: b_s26_p1_harm
    title: Others harmed or threatened
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    items:
    - id: V33
      kind: Question
      title: Was anyone (else) harmed or threatened during this incident?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V33A
      kind: Question
      title: How many people? |__|__| [CATI 1-95]
      input:
        control: Editbox
        min: -9
        max: 95
        left: (-8 = Don’t know, -9 = Refused)
    - id: V34
      kind: Question
      title: Were any of these people under 15 years of age?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V34A
      kind: Question
      title: How many people? |__|__| [CATI 1-95]
      postcondition:
      - predicate: V34A.outcome <= V33A.outcome or V34A.outcome < 0 or V33A.outcome < 0
        hint: 'The number of people under 15 (V34A) cannot exceed the number of people harmed or threatened (V33A): correct V33A or V34A.'
        invented: true
      input:
        control: Editbox
        min: -9
        max: 95
        left: (-8 = Don’t know, -9 = Refused)
  - id: b_s26_p1_theft
    title: Property stolen
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    items:
    - id: V35
      kind: Question
      title: Was anything that belonged to you or your household stolen during this incident? Do not include property belonging to a business.
      precondition:
      - predicate: not (VSCRNO_2.outcome in [3, 4, 5])
        hint: Asked only when VSCRNO is none of B4A, B4B, B4C.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V36
      kind: Question
      title: 'What was stolen during the incident? Anything else? INT: Mark all that apply.'
      postcondition:
      - predicate: not (V35.outcome == 1 and V36.outcome & 1 > 0)
        hint: 'You said in V35 that something was stolen, but V36 says nothing was: correct V35 or V36.'
      input:
        control: Checkbox
        labels:
          1: (n) Nothing
          2: (1) Cash
          4: (2) Purse, wallet, credit cards, cheques, personal cards or papers
          8: (3) Clothing, jewellery
          16: (4) Other personal property
          32: (5) Personal property of someone else
          64: (6) Car
          128: (7) Truck or van
          256: (8) Motorcycle or moped
          512: (9) Other motor vehicle
          1024: (10) Part of a motor vehicle
          2048: (11) Food, drink, liquor
          4096: (12) Electronic equipment, including T.V. stereo, video recorder, CD’s
          8192: (13) Household articles, including tools, appliances, furniture, carpets
          16384: (14) Boat
          32768: (15) Bicycle
          65536: (16) Other household property
          131072: (x) Don’t know
          262144: (r) Refused
          524288: (0) No other; continue
    - id: V37
      kind: Question
      title: What is your estimate of the value of all property and cash stolen in this incident? $|__|__|__|__|__|__|.00
      input:
        control: Editbox
        min: -9
        max: 999999
        left: $ (0 = No value, -8 = Don’t know, -9 = Refused)
    - id: V38
      kind: Question
      title: Was any of the stolen money and/or property recovered, not counting anything received from insurance?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V38A
      kind: Question
      title: Was it all recovered?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V39
      kind: Question
      title: Did this person ATTEMPT to take anything that belonged to you or your household? Do not include property belonging to a business.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V40
      kind: Question
      title: 'What did they attempt to steal during this incident? INT: Mark all that apply.'
      postcondition:
      - predicate: not (V39.outcome == 1 and V40.outcome & 1 > 0)
        hint: 'You said in V39 that something was attempted to be taken, but V40 says nothing: correct V39 or V40.'
      input:
        control: Checkbox
        labels:
          1: (n) Nothing
          2: (1) Cash
          4: (2) Respondent's personal property
          8: (3) Personal property of someone else
          16: (4) Motor vehicle
          32: (5) Part of a motor vehicle
          64: (6) Household property
          128: (x) Don’t know
          256: (r) Refused
          512: (0) No other; continue
  - id: b_s26_p1_damage
    title: Property damaged
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    items:
    - id: V41
      kind: Question
      title: Was anything that belonged to you or a member of your household damaged but not taken in this incident? (Include damage resulting from vandalism.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V42
      kind: Question
      title: 'What was damaged? INT: Mark all that apply.'
      postcondition:
      - predicate: not (V41.outcome == 1 and V42.outcome & 1 > 0)
        hint: 'You said in V41 that something was damaged, but V42 says nothing was: correct V41 or V42.'
      input:
        control: Checkbox
        labels:
          1: (n) Nothing
          2: (1) Respondent's personal property
          4: (2) Personal property of someone else
          8: (3) Motor vehicle or part of a motor vehicle
          16: (4) Dwelling or other building on property
          32: (5) Household property
          64: (x) Don’t know
          128: (r) Refused
          256: (0) No other; continue
    - id: V43
      kind: Question
      title: What is your estimate of the value of all damage done in this incident? $|__|__|__|__|__|__|.00
      input:
        control: Editbox
        min: -9
        max: 999999
        left: $ (0 = No value, -8 = Don’t know, -9 = Refused)
    - id: V44
      kind: Question
      title: Have any of the damaged items been repaired or replaced?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V45
      kind: Question
      title: Will they be repaired or replaced?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
  - id: b_s26_p1_costs
    title: Insurance, compensation and expenses
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    items:
    - id: V46
      kind: Question
      title: At the time of the incident, did you have any insurance?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V47
      kind: Question
      title: Did you attempt to obtain compensation for this incident through an insurance company?
      precondition:
      - predicate: not (V46.outcome in [3, 98, 99])
        hint: Asked only when V46 is none of No, Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V47A
      kind: Question
      title: Did you obtain any compensation?
      precondition:
      - predicate: not (V46.outcome in [3, 98, 99])
        hint: Asked only when V46 is none of No, Don't know, Refused.
      - predicate: not (V47.outcome in [3, 98, 99])
        hint: Asked only when V47 is none of No, Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Not yet resolved
          98: (x) Don't know
          99: (r) Refused
    - id: V48
      kind: Question
      title: Did you attempt to obtain compensation for this incident through a civil or criminal court or a provincial compensation program?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V48A
      kind: Question
      title: Did you obtain any compensation?
      precondition:
      - predicate: not (V48.outcome in [3, 98, 99])
        hint: Asked only when V48 is none of No, Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          5: (5) Not yet resolved
          98: (x) Don't know
          99: (r) Refused
    - id: V49
      kind: Question
      title: For this incident, what is your estimate of your out-of-pocket expenses, that is, expenses for which you do not expect to be reimbursed? $|__|__|__|__|__|__|.00
      input:
        control: Editbox
        min: -9
        max: 999999
        left: $ (0 = No expenses, -8 = Don't know, -9 = Refused)
  - id: b_s26_p1_activity
    title: Main activity
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    items:
    - id: V50
      kind: Question
      title: 'Which of the following best describes your main activity during the week of the incident? Were you . . . INT: Accept one response only. If respondent indicates more than one activity then probe for main activity. If respondent insists on more than one then select (10) (Other) and specify. INT: READ LIST'
      input:
        control: Dropdown
        labels:
          1: (1) On holiday?
          2: (2) Working at a paid job or business?
          3: (3) Looking for work?
          4: (4) A student?
          5: (5) Caring for children?
          6: (6) Household work?
          7: (7) Retired?
          8: (8) Maternity/paternity leave
          9: (9) Long term illness
          10: (10) Other
          99: (r) Refused
    - id: V50S
      kind: Question
      title: 'Specify [CATI]: Length of field = 28'
      precondition:
      - predicate: V50.outcome == 10
        hint: Asked only when V50 is Other.
      input:
        control: Textarea
        maxLength: 28
    - id: V51
      kind: Question
      title: 'As a result of this incident, did you find it difficult or impossible to carry out your main activity for all or most of a day? ( Reasons could range from requiring medical treatment to having to replace or repair property or visit insurance agents. INT: Select (1) (yes) if the respondent’s main activity was disrupted for at least 6 hours during a day.)'
      precondition:
      - predicate: not (V50.outcome in [7, 8, 9])
        hint: Asked only when V50 is none of Retired, Maternity/paternity leave, Long term illness.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V51A
      kind: Question
      title: 'For how many days? |__|__|__| [CATI: 1-999]'
      precondition:
      - predicate: not (V50.outcome in [7, 8, 9])
        hint: Asked only when V50 is none of Retired, Maternity/paternity leave, Long term illness.
      - predicate: not (V51.outcome in [3, 98, 99])
        hint: Asked only when V51 is none of No, Don't know, Refused.
      input:
        control: Editbox
        min: -9
        max: 999
        left: (-9 = Refused)
  - id: b_s26_p1_police
    title: Police contact
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when V1 is not Not in the past 12 months.
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when V1A is none of No, Yes but refuses to talk about incident, Don't know, Refused.
    items:
    - id: V52
      kind: Question
      title: 'Did the police find out about this incident in any way? INT: If the respondent or a member of the household is a police officer, select (1) (yes) only if it was reported to the police.'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V53
      kind: Question
      title: 'How did they learn about it? Was it from you or some other way? INT: If respondent answers both himself/herself and some other way - enter (1).'
      precondition:
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Respondent
          3: (3) Some other way
          98: (x) Don't know
          99: (r) Refused
    - id: V54a
      kind: Question
      title: 'People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported this incident? Was it … INT: READ LIST. a) To stop the incident or receive protection?'
      precondition:
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      - predicate: not (V53.outcome == 3)
        hint: Asked only when V53 is not Some other way.
      - predicate: not (V53.outcome in [98, 99])
        hint: Asked only when V53 is none of Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V54b
      kind: Question
      title: (People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported this incident? Was it …) b) To catch and punish the offender?
      precondition:
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      - predicate: not (V53.outcome == 3)
        hint: Asked only when V53 is not Some other way.
      - predicate: not (V53.outcome in [98, 99])
        hint: Asked only when V53 is none of Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V54c
      kind: Question
      title: (People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported this incident? Was it …) c) To file a report to claim compensation or insurance?
      precondition:
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      - predicate: not (V53.outcome == 3)
        hint: Asked only when V53 is not Some other way.
      - predicate: not (V53.outcome in [98, 99])
        hint: Asked only when V53 is none of Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V54d
      kind: Question
      title: (People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported this incident? Was it …) d) Because you felt it was your duty to notify police?
      precondition:
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      - predicate: not (V53.outcome == 3)
        hint: Asked only when V53 is not Some other way.
      - predicate: not (V53.outcome in [98, 99])
        hint: Asked only when V53 is none of Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V54e
      kind: Question
      title: (People have different reasons for reporting incidents to the police. Did any of the following have anything to do with why you reported this incident? Was it …) e) On the recommendation of someone else?
      precondition:
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      - predicate: not (V53.outcome == 3)
        hint: Asked only when V53 is not Some other way.
      - predicate: not (V53.outcome in [98, 99])
        hint: Asked only when V53 is none of Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don't know
          99: (r) Refused
    - id: V55
      kind: Question
      title: 'What action did the police take? INT: Mark all that apply.'
      precondition:
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      - predicate: not (V53.outcome in [98, 99])
        hint: Asked only when V53 is none of Don't know, Refused.
      input:
        control: Checkbox
        labels:
          1: (n) None
          2: (1) Visited Scene
          4: (2) Made a report/Conducted an investigation
          8: (3) Gave warning to offender
          16: (4) Took offender away
          32: (5) Made Arrests/Laid Charges
          64: (6) Put you in touch with community services
          128: (7) Other
          256: (x) Don't know
          512: (r) Refused
          1024: (0) No other; continue
    - id: V55S
      kind: Question
      title: 'Specify [CATI]: Length of field = 28'
      precondition:
      - predicate: V55.outcome & 128 > 0
        hint: Asked only when V55 includes Other.
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      - predicate: not (V53.outcome in [98, 99])
        hint: Asked only when V53 is none of Don't know, Refused.
      - predicate: not (V55.outcome & 1 > 0 or V55.outcome & 1792 > 0)
        hint: Not asked when V55 includes None, Don't know, Refused or No other.
      input:
        control: Textarea
        maxLength: 28
    - id: V56
      kind: Question
      title: 'How satisfied were you with the actions that the police took? Were you … INT: READ LIST'
      precondition:
      - predicate: not (V52.outcome == 3)
        hint: Asked only when V52 is not No.
      - predicate: not (V52.outcome in [98, 99])
        hint: Asked only when V52 is none of Don't know, Refused.
      - predicate: not (V53.outcome in [98, 99])
        hint: Asked only when V53 is none of Don't know, Refused.
      input:
        control: Radio
        labels:
          1: (1) Very satisfied?
          2: (2) Somewhat satisfied?
          3: (3) Somewhat dissatisfied?
          4: (4) Very dissatisfied?
          98: (x) Don't know
          99: (r) Refused
  - id: b_s26_p2_help
    title: Police help
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when question V1 is not "Not in the past 12 months".
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when question V1A is none of "No", "Yes, but refuses to talk about incident", "Don't know", "Refused".
    - predicate: not (V52.outcome == 3)
      hint: Asked only when question V52 is not "(3) No".
    - predicate: not (V52.outcome in [98, 99])
      hint: Asked only when question V52 is none of "(x) Don't know", "(r) Refused".
    - predicate: not (V53.outcome in [98, 99])
      hint: Asked only when question V53 is none of "(x) Don't know", "(r) Refused".
    items:
    - id: V57
      kind: Question
      title: 'Is there anything (else) they should have done to help you? INT: Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: (n) No/nothing
          2: (1) Take the person out of the house
          4: (2) Charge/arrest the person
          8: (3) Respond more quickly
          16: (4) Refer/take you to a support service
          32: (5) Relocate you
          64: (6) Take you to hospital
          128: (7) Be more supportive/sympathetic
          256: (8) Other
          512: (x) Don’t know
          1024: (r) Refused
          2048: (0) No other; continue
    - id: V57S
      kind: Question
      title: 'Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: V57.outcome & 256 > 0
      - predicate: not (V57.outcome & 3585 > 0)
      input:
        control: Textarea
        maxLength: 50
  - id: b_s26_p2_nopolice
    title: Reasons for not contacting the police
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when question V1 is not "Not in the past 12 months".
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when question V1A is none of "No", "Yes, but refuses to talk about incident", "Don't know", "Refused".
    - predicate: not (V52.outcome in [98, 99])
      hint: Asked only when question V52 is none of "(x) Don't know", "(r) Refused".
    - predicate: not (V53.outcome in [98, 99])
      hint: Asked only when question V53 is none of "(x) Don't know", "(r) Refused".
    - predicate: not (V57.outcome & 3585 > 0)
    items:
    - id: V58A
      kind: Question
      title: I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it … Because it was dealt with another way? (e.g. reported to another official, landlord, manager, school official, or private matter that took care of myself, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58B
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because of fear of revenge by the offender?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58C
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because the police couldn't do anything about it? (e.g. didn't find out until too late, couldn't recover or identify property, couldn't find or identify offender, lack of proof ,etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58D
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because the police wouldn't help? (e.g. wouldn't think it was important enough, wouldn't want to be bothered or get involved, police would be inefficient or ineffective, police would be biased, would harass/insult respondent, offender was police officer)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58E
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because you did not want to get involved with police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58F
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because it was not important enough to you? (e.g. minor crime, small loss, child offender, no intended harm, etc.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58G
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because the incident was a personal matter and did not concern the police?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58H
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because of fear of publicity/news coverage?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58I
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because your insurance wouldn't cover it? (e.g. no insurance, loss less than deductible, etc.)
      precondition:
      - predicate: not (((V36.outcome == 0 or V36.outcome & 1 > 0) and (V42.outcome == 0 or V42.outcome & 1 > 0)) or V15.outcome > 0 or VSCRNO_2.outcome in [10, 11, 13, 14])
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58J
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) Because nothing was taken or the items were recovered?
      precondition:
      - predicate: not (((V36.outcome == 0 or V36.outcome & 1 > 0) and (V42.outcome == 0 or V42.outcome & 1 > 0)) or V15.outcome > 0 or VSCRNO_2.outcome in [10, 11, 13, 14])
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58K
      kind: Question
      title: (I’m going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to this incident. Was it …) For some other reason, not already mentioned?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          99: (r) Refused
    - id: V58S
      kind: Question
      title: 'Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: V58K.outcome == 1
        hint: Asked only when question V58K is "(1) Yes".
      input:
        control: Textarea
        maxLength: 50
    - id: V59
      kind: Question
      title: What was the main reason?
      input:
        control: Dropdown
        labels:
          1: (1) Dealt with another way
          2: (2) Fear of revenge by the offender
          3: (3) Police couldn't do anything
          4: (4) Police wouldn't help
          5: (5) Did not want to get involved with police
          6: (6) Not important enough to respondent
          7: (7) Incident was a personal matter and did not concern the police
          8: (8) Fear of publicity/news coverage
          9: (9) Insurance wouldn't cover
          10: (10) Nothing was taken or the items were recovered
          11: (11) Other
          99: (r) Refused
  - id: b_s26_p2_talk
    title: Talking to others about the incident
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when question V1 is not "Not in the past 12 months".
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when question V1A is none of "No", "Yes, but refuses to talk about incident", "Don't know", "Refused".
    items:
    - id: V60a
      kind: Question
      title: '(Other than to the police,) did you ever talk to anyone about what happened, such as ... INT: READ LIST. a) Family?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V60b
      kind: Question
      title: ((Other than to the police,) did you ever talk to anyone about what happened, such as ...) b) Friend or neighbour?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V60c
      kind: Question
      title: ((Other than to the police,) did you ever talk to anyone about what happened, such as ...) c) Co-worker?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V60d
      kind: Question
      title: ((Other than to the police,) did you ever talk to anyone about what happened, such as ...) d) Doctor or nurse?
      precondition:
      - predicate: V15.outcome > 0 or (V13.outcome == 1 and V14.outcome == 1) or VSCRNO_2.outcome in [10, 11, 13, 14] or (((V36.outcome > 0 and V36.outcome & 1 == 0) or (V40.outcome > 0 and V40.outcome & 1 == 0)) and V10.outcome == 1)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V60e
      kind: Question
      title: ((Other than to the police,) did you ever talk to anyone about what happened, such as ...) e) Lawyer?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
    - id: V60f
      kind: Question
      title: ((Other than to the police,) did you ever talk to anyone about what happened, such as ...) f) Minister, priest, clergy, or another spiritual advisor?
      precondition:
      - predicate: V15.outcome > 0 or (V13.outcome == 1 and V14.outcome == 1) or VSCRNO_2.outcome in [10, 11, 13, 14] or (((V36.outcome > 0 and V36.outcome & 1 == 0) or (V40.outcome > 0 and V40.outcome & 1 == 0)) and V10.outcome == 1)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          98: (x) Don’t know
          99: (r) Refused
  - id: b_s27_preamble
    title: 'Section V – Incident Report: external inputs'
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when question V1 is not "Not in the past 12 months".
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when question V1A is none of "No", "Yes, but refuses to talk about incident", "Don't know", "Refused".
    items:
    - id: V60_APPLIES
      kind: Question
      title: 'External input derived from CATI-V60e: crime incident type refers to robbery, attempted robbery, physical attack, threat, sexual assault or unwanted sexual touching (from V36, V40, V10, V13, V14, V15 and VSCRNO ''B9'', ''B10'', ''B12'', ''B13'')'
      external: true
      input:
        control: Switch
        'on': Incident type applies
        'off': Incident type does not apply
    - id: RESP_SEX
      kind: Question
      title: 'External input: respondent''s sex (CATI: female respondent / male respondent)'
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: RESP_AGE
      kind: Question
      title: 'External input: respondent''s age (CATI: respondent is 65+)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: INC_REMAINING
      kind: Question
      title: 'External input: number of Incident Reports remaining to be completed for the type of crime referred to by VSCRNO (CATI-V64ae)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: V_KEY
      kind: Question
      title: 'External input: the ''v'' key was used at any time in Section V (CATI-V65e)'
      external: true
      input:
        control: Switch
        'on': Used
        'off': Not used
    - id: V1_OOS
      kind: Question
      title: 'External input derived from V67 preamble: V1 = (n) or ((V1 = (x) or V1 = (r)) and V1A NE (1) and V1A NE (5))'
      external: true
      input:
        control: Switch
        'on': Condition true (out of scope)
        'off': Condition false
  - id: b_s27_services
    title: Services, impact and similar incidents
    precondition:
    - predicate: not (V1.outcome == -3)
      hint: Asked only when question V1 is not "Not in the past 12 months".
    - predicate: not (V1A.outcome in [3, 5, -2, -1])
      hint: Asked only when question V1A is none of "No", "Yes, but refuses to talk about incident", "Don't know", "Refused".
    items:
    - id: V61a
      kind: Question
      title: 'V61 Did you ever contact or use any of the following services for help because of this incident, such as … INT: ===READ LIST=== a) Crisis centre or crisis line?'
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refused
    - id: V61b
      kind: Question
      title: V61 b) Another counsellor?
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refused
    - id: V61c
      kind: Question
      title: V61 c) Community centre/family centre
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refused
    - id: V61e
      kind: Question
      title: 'V61 e) Women’s centre? [CATI: only if female respondent]'
      precondition:
      - predicate: RESP_SEX.outcome == 2
        hint: Asked only when question RESP_SEX is "Female".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refused
    - id: V61f
      kind: Question
      title: 'V61 f) Men’s centre/men’s support group? [CATI: only if male respondent]'
      precondition:
      - predicate: RESP_SEX.outcome == 1
        hint: Asked only when question RESP_SEX is "Male".
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refused
    - id: V61g
      kind: Question
      title: 'V61 g) Senior’s centre? [CATI: only if respondent is 65+]'
      precondition:
      - predicate: RESP_AGE.outcome >= 65
        hint: Asked only when the respondent is 65 or older.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refused
    - id: V62
      kind: Question
      title: V62 Did you ever contact or use police-based or court-based victim services because of this incident? (“Victim Assistance Units” operate within a specific police office, and help victims at the police end of the justice system. “Victim Services” help victims as their cases proceed through the justice system (police, courts and corrections). Services include providing general information about the justice system, referrals, assistance with court, help preparing victim impact statements, offering emotional support and providing information to help victims recover financial losses resulting from the crime.)
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No
          8: (x) Don’t know
          9: (r) Refused
    - id: V63
      kind: Question
      title: 'V63 (There are a number of ways to deal with an offence outside the normal police-court process. One way is a meeting between the victim and the offender to discuss an appropriate way the offender should be dealt with. Thinking about this incident, how interested would you have been (be) in participating in such a program if one was available in your community?) (Thinking about this incident, how interested would you have been (be) in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?) Would you have been (be) … INT: ===READ LIST==='
      input:
        control: Radio
        labels:
          1: (1) Very interested?
          2: (2) Somewhat interested?
          3: (3) Slightly interested?
          4: (4) Not at all interested?
          9: (r) Refused
    - id: V64
      kind: Question
      title: V64 At the time of the incident, how did this experience affect you? INT:===Mark all that apply.=== INT:===Do not include physical injury, financial loss or medical treatment.===
      postcondition:
      - predicate: not ((V64.outcome & 512) > 0 and (V64.outcome & 32255) > 0)
        hint: 'V64: «Not much» cannot be combined with other effects; unmark it or the other effects.'
        invented: true
      input:
        control: Checkbox
        labels:
          1: (1) Afraid for children
          2: (2) Angry
          4: (3) Ashamed/guilty
          8: (4) Depression/ anxiety attacks
          16: (5) Fearful
          32: (6) Hurt/disappointment
          64: (7) Increased self-reliance
          128: (8) Lowered self esteem
          256: (9) More cautious/aware
          512: (10) Not much
          1024: (11) Problems relating to men/women
          2048: (12) Shock/disbelief
          4096: (13) Sleeping problems
          8192: (14) Upset/confused/frustrated
          16384: (15) Other [Go to V64S]
          32768: (x) Don’t know [Go to CATI-V64ae]
          65536: (r) Refused [Go to CATI-V64ae]
          131072: (0) No other; continue [Go to CATI-V64ae]
    - id: V64S
      kind: Question
      title: 'V64S Specify [CATI]: Length of field = 50'
      precondition:
      - predicate: (V64.outcome & 16384) > 0
        hint: Asked only when V64 includes "Other".
      - predicate: not ((V64.outcome & 16384) == 0 and INC_REMAINING.outcome < 2)
        hint: Asked only when V64 includes "Other".
      - predicate: not ((V64.outcome & 16384) == 0 and INC_REMAINING.outcome >= 2)
        hint: Asked only when V64 includes "Other".
      input:
        control: Textarea
        maxLength: 50
    - id: CATI_V64be
      kind: Question
      title: 'CATI-V64be: INT:=== Is this respondent having trouble distinguishing the details of this incident from other similar incidents? (The respondent must be unable to recall details of the incident and not able to report it separately. If the respondent remembers any important details that allow him/her to distinguish the incidents, the remaining incidents should be reported separately, regardless of how many crimes there were.)==='
      precondition:
      - predicate: INC_REMAINING.outcome >= 2
        hint: Asked only when two or more incident reports remain.
      - predicate: not ((V64.outcome & 16384) == 0 and INC_REMAINING.outcome < 2)
        hint: Asked only when two or more incident reports remain.
      - predicate: not (INC_REMAINING.outcome < 2)
        hint: Asked only when two or more incident reports remain.
      input:
        control: Radio
        labels:
          1: (1) Yes
          3: (3) No [Go to V66]
    - id: V65
      kind: Question
      title: V65 Of the remaining (calculate the number of incidents remaining) incidents during the past 12 months, how many have details similar to this one? Exclude incidents you have already told me about. |__|__| incidents (If none enter 0)
      precondition:
      - predicate: CATI_V64be.outcome == 1
        hint: Asked only when question CATI-V64be is "(1) Yes".
      - predicate: not ((V64.outcome & 16384) == 0 and INC_REMAINING.outcome < 2)
        hint: Asked only when two or more incident reports remain.
      - predicate: not (INC_REMAINING.outcome < 2)
        hint: Asked only when two or more incident reports remain.
      - predicate: not (CATI_V64be.outcome == 3)
        hint: Asked only when question CATI-V64be is not "(3) No [Go to V66]".
      postcondition:
      - predicate: V65.outcome <= INC_REMAINING.outcome
        hint: 'V65: the number of similar incidents cannot exceed the number of incidents remaining to be reported.'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: V66
      kind: Question
      title: V66 INT:===Is there any information or additional information that you would like to add about this incident?=== (n) No/Nothing
      precondition:
      - predicate: not (V_KEY.outcome == 0)
        hint: Asked only when question V_KEY is not "Not used".
      input:
        control: Textarea
  - id: b_s27_status
    title: Incident report status
    items:
    - id: V67
      kind: Question
      title: V67 If V1 = (n) or ((V1 = (x) or V1 = (r)) and V1A NE (1) and V1A NE (5)) then set REP_STAT to (4) (Out of scope); Go to V68; INT:===If it has turned out that this incident is a duplicate or is out of scope (e.g. respondent is not the victim), please indicate this.===
      precondition:
      - predicate: V1_OOS.outcome == 0
        hint: Asked only when question V1_OOS is "Condition false".
      input:
        control: Radio
        labels:
          0: (0) Neither duplicate nor out of scope - continue
          3: (3) Duplicate incident report
          4: (4) Out of scope (respondent not victim)
    - id: V68
      kind: Question
      title: 'V68 INT:===The status of this incident report is …=== (Fill: Give status) Press 0 to confirm and continue.'
      input:
        control: Radio
        labels:
          0: (0) To continue
